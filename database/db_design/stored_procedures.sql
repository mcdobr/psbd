-- SET SERVEROUTPUT ON;

-- Triggers for working as sequence
    
CREATE OR REPLACE TRIGGER new_bill_id
BEFORE INSERT ON bill
FOR EACH ROW
BEGIN
    SELECT 1 + NVL(MAX(id), 0)
    INTO :new.id
    FROM bill;
END;
/

CREATE OR REPLACE TRIGGER new_bill_item_id
BEFORE INSERT ON billItem
FOR EACH ROW
BEGIN
   SELECT 1 + NVL(MAX(id), 0)
   INTO :new.id
   FROM billItem;
END;
/

CREATE OR REPLACE FUNCTION new_bill
(v_bill_date IN VARCHAR2,
v_other_party_name IN bill.other_party_name%type,
v_bill_type IN bill.bill_type%type)
RETURN bill.id%type IS
   v_billId bill.id%type;
BEGIN
   INSERT INTO bill VALUES(default, TO_DATE(v_bill_date, 'yyyy/mm/dd hh24:mi:ss'), v_other_party_name, v_bill_type);
   
   SELECT MAX(id) INTO v_billId
   FROM bill;
       
   RETURN v_billId; 
END new_bill;
/

-- This function changes newer bills' stock and also propagates the latest stock to
-- the product table

CREATE OR REPLACE PROCEDURE update_newer_bills(
   v_updated_bill_id IN bill.id%type,
   v_stock_difference IN billItem.quantity%type,
   v_product_id IN product.id%type
)
IS
   v_count_later_bills NUMBER;
   v_latest_stock product.stock%type;
   
   
   -- Get all bill items with the product that appear on bills later than updated bill
   CURSOR later_bill_item_cursor IS
       SELECT billItem.*
       FROM billItem
       INNER JOIN bill ON billItem.bill_id = bill.id
       WHERE product_id = v_product_id AND
           bill.bill_date > (SELECT bill_date
                           FROM bill
                           WHERE bill.id = v_updated_bill_id);
       
BEGIN
   -- Update the historical stocks
   FOR later_bill_item_record IN later_bill_item_cursor LOOP
       UPDATE billItem
       SET billItem.new_stock = billItem.new_stock + v_stock_difference
       WHERE billItem.id = later_bill_item_record.id;      
   END LOOP;
   
    -- Get the stock of the billitem of the bill that doesn't have a later bill AKA THE LATEST ONE
   SELECT billItem.new_stock
   INTO v_latest_stock
   FROM billItem
   INNER JOIN bill b1 ON billItem.bill_id = b1.id
   WHERE billItem.product_id = v_product_id AND 
       NOT EXISTS (SELECT bill.*
                   FROM bill b2
                   WHERE b2.bill_date > b1.bill_date);

   UPDATE product
   SET stock = v_latest_stock
   WHERE product.id = v_product_id;
   
   -- TODO: Exception for not found
END update_newer_bills;
/

-- Creates new bill item

CREATE OR REPLACE PROCEDURE new_bill_item(
   v_billId IN bill.id%type,
   v_productId IN product.id%type,
   v_quantity IN billItem.quantity%type
) IS
   v_bill bill%ROWTYPE;
   v_previous_bill_id bill.id%type;
   v_previous_bills_count number;
   
   v_previous_stock billItem.new_stock%type;
   v_new_stock billItem.new_stock%type;

   v_stock_difference billItem.new_stock%type;
BEGIN
   -- Get the referenced bill
   SELECT * INTO v_bill
   FROM bill
   WHERE bill.id = v_billId;
   
   -- Check if there are any previous bills that list the product
   SELECT COUNT(*)
   INTO v_previous_bills_count
   FROM billItem
   INNER JOIN bill ON billItem.bill_id = bill.id
   WHERE billItem.product_id = v_productId AND
       bill.bill_date < v_bill.bill_date;
   
   -- Get LATEST PREVIOUS bill that has product listed
   -- Only one transaction on the same timestamp
   IF (v_previous_bills_count > 0) THEN
       SELECT billItem.new_stock, bill.id
       INTO v_previous_stock, v_previous_bill_id
       FROM billItem
       INNER JOIN bill ON billItem.bill_id = bill.id
       WHERE billItem.product_id = v_productId AND
           bill.bill_date = (SELECT MAX(bill_date)
                           FROM bill
                           WHERE bill_date < v_bill.bill_date)
       ORDER BY bill.bill_date DESC;
   END IF;    
   
   v_previous_stock := NVL(v_previous_stock, 0);
   DBMS_OUTPUT.put_line('Previous stock: ' || v_previous_stock);
   
   -- Compute the new stock
   IF (v_bill.bill_type = 'incoming') THEN
       v_new_stock := v_previous_stock + v_quantity;
       v_stock_difference := v_quantity;
   ELSIF (v_bill.bill_type = 'outgoing') THEN
       v_new_stock := v_previous_stock - v_quantity;
       v_stock_difference := -v_quantity;
   END IF;    
   DBMS_OUTPUT.put_line('New stock: ' || v_new_stock);
   
   INSERT INTO billItem VALUES(default, v_quantity, v_billId, v_productId, v_new_stock);


   -- Propagate the stock change in later transactions
   update_newer_bills(v_billId, v_stock_difference, v_productId);
END new_bill_item;
/
