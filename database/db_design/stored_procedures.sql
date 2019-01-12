CREATE OR REPLACE FUNCTION new_bill(
    v_bill_date IN VARCHAR2,
    v_other_party_name IN bill.other_party_name%TYPE,
    v_bill_type IN bill.bill_type%TYPE
)RETURN bill.id%TYPE IS
    v_billid bill.id%TYPE;
BEGIN
    INSERT INTO bill VALUES(DEFAULT,
    TO_DATE(v_bill_date, 'yyyy/mm/dd hh24:mi:ss'),
    v_other_party_name,
    v_bill_type);

    SELECT MAX(id)
      INTO v_billid
      FROM bill;

    RETURN v_billid;
END new_bill;
/

CREATE OR REPLACE PROCEDURE edit_bill(
    v_bill_id IN bill.id%TYPE,
    v_bill_date IN VARCHAR2,
    v_other_party_name IN bill.other_party_name%TYPE,
    v_bill_type IN bill.bill_type%TYPE
)IS
BEGIN
    UPDATE bill
       SET bill.bill_date = TO_DATE(v_bill_date, 'yyyy/mm/dd hh24:mi:ss'),
           bill.other_party_name = v_other_party_name,
           bill.bill_type = v_bill_type
     WHERE bill.id = v_bill_id;

END edit_bill;
/

CREATE OR REPLACE PROCEDURE delete_bill_items(
    v_bill_id IN bill.id%TYPE
)IS
BEGIN
    DELETE billitem
     WHERE billitem.bill_id = v_bill_id;

END delete_bill_items;
/

-- This function intends to change newer bills' stock and also propagates the latest stock to the product table

CREATE OR REPLACE PROCEDURE update_stocks(
    v_updated_bill_id IN bill.id%TYPE,
    v_product_id IN product.id%TYPE
)IS

    v_overlapping_bills_count NUMBER;
    v_latest_stock product.stock%TYPE;
   
   -- Get all bill items with the product that appear on bills later than updated bill

    CURSOR bill_with_item_cursor IS
    SELECT billitem.*,
           bill.bill_date
      FROM billitem
     INNER JOIN bill ON billitem.bill_id = bill.id
     WHERE product_id = v_product_id;

BEGIN
    -- Select overlapping bills (if two bills that have the same product happen at the same time => FAIL

    SELECT COUNT(this_bill.id)
      INTO v_overlapping_bills_count
      FROM bill this_bill,
           billitem this_item,
           bill other_bill,
           billitem other_item
     WHERE this_bill.id <> other_bill.id AND
           this_item.bill_id = this_bill.id AND
           other_item.bill_id = other_bill.id AND
           this_item.product_id = other_item.product_id AND
           this_bill.bill_date = other_bill.bill_date;

    IF(v_overlapping_bills_count >= 2)THEN
        raise_application_error(-20001, 'Overlapping concurrent bills.');
    END IF;


    --Update the later bill items

    FOR later_bill_item_record IN bill_with_item_cursor LOOP
        UPDATE billitem
           SET
            billitem.new_stock = nvl((
                SELECT SUM(DECODE(bill.bill_type, 'incoming', 1, 'outgoing', - 1)* billitem.quantity)
                  FROM billitem
                 INNER JOIN bill ON billitem.bill_id = bill.id
                 WHERE bill.bill_date <= later_bill_item_record.bill_date AND
                       billitem.product_id = later_bill_item_record.product_id
            ), 0)
         WHERE billitem.id = later_bill_item_record.id;

    END LOOP;
   
    -- Get the stock of the billitem of the bill that doesn't have a later bill AKA THE LATEST ONE

    SELECT billitem.new_stock
      INTO v_latest_stock
      FROM billitem
     INNER JOIN bill b1 ON billitem.bill_id = b1.id
     WHERE billitem.product_id = v_product_id AND
           NOT EXISTS(
               SELECT bill.*
                 FROM bill b2
                WHERE b2.bill_date > b1.bill_date
           );

    UPDATE product
       SET
        stock = v_latest_stock
     WHERE product.id = v_product_id;
   
   -- TODO: Exception for not found

END update_stocks;
/

-- Creates new bill item

CREATE OR REPLACE PROCEDURE new_bill_item(
    v_billid IN bill.id%TYPE,
    v_productid IN product.id%TYPE,
    v_quantity IN billitem.quantity%TYPE
)IS

    v_bill bill%rowtype;
    v_previous_bill_id bill.id%TYPE;
    v_previous_bills_count NUMBER;
    v_previous_stock billitem.new_stock%TYPE;
    v_new_stock billitem.new_stock%TYPE;
    v_stock_difference billitem.new_stock%TYPE;
BEGIN
   -- Get the referenced bill

    SELECT *
      INTO v_bill
      FROM bill
     WHERE bill.id = v_billid;
   
   -- Check if there are any previous bills that list the product

    SELECT COUNT(*)
      INTO v_previous_bills_count
      FROM billitem
     INNER JOIN bill ON billitem.bill_id = bill.id
     WHERE billitem.product_id = v_productid AND
           bill.bill_date < v_bill.bill_date;
   
   -- Get LATEST PREVIOUS bill that has product listed

    IF(v_previous_bills_count > 0)THEN
        SELECT billitem.new_stock,
               bill.id
          INTO
            v_previous_stock,
            v_previous_bill_id
          FROM billitem
         INNER JOIN bill ON billitem.bill_id = bill.id
         WHERE billitem.product_id = v_productid AND
               bill.bill_date =(
                   SELECT MAX(bill_date)
                     FROM bill
                    WHERE bill_date < v_bill.bill_date
               )
         ORDER BY bill.bill_date DESC;

    END IF;

    v_previous_stock := nvl(v_previous_stock, 0);
   
   -- Compute the new stock

    IF(v_bill.bill_type = 'incoming')THEN
        v_new_stock := v_previous_stock + v_quantity;
        v_stock_difference := v_quantity;
    ELSIF(v_bill.bill_type = 'outgoing')THEN
        v_new_stock := v_previous_stock - v_quantity;
        v_stock_difference := -v_quantity;
    END IF;

    INSERT INTO billitem VALUES(DEFAULT,
    v_quantity,
    v_billid,
    v_productid,
    v_new_stock);

   -- Propagate the stock change in later transactions

    update_stocks(v_billid, v_productid);
END new_bill_item;
/

-- Triggers for working as sequence    

CREATE OR REPLACE TRIGGER new_bill_id BEFORE
    INSERT ON bill
    FOR EACH ROW
BEGIN
    SELECT 1 + nvl(MAX(id), 0)
      INTO :new.id
      FROM bill;

END;
/

CREATE OR REPLACE TRIGGER new_bill_item_id BEFORE
    INSERT ON billitem
    FOR EACH ROW
BEGIN
    SELECT 1 + nvl(MAX(id), 0)
      INTO :new.id
      FROM billitem;

END;
/