SET SERVEROUTPUT ON;

/**
    Triggers for working as sequence
*/    
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
(v_billdate IN VARCHAR2,
 v_otherpartyname IN bill.otherpartyname%type,
 v_billtype IN bill.billtype%type)
RETURN bill.id%type IS
    v_billId bill.id%type;
BEGIN
    INSERT INTO bill VALUES(default, TO_DATE(v_billdate, 'yyyy/mm/dd'), v_otherpartyname, v_billtype);
    
    SELECT MAX(id) INTO v_billId
    FROM bill;
        
    RETURN v_billId; 
END new_bill;
/

/**
    Creates new bill item
*/
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
BEGIN
    /* Get the referenced bill */
    SELECT * INTO v_bill
    FROM bill
    WHERE bill.id = v_billId;
    
    /* Check if there are any previous bills that list the product */
    SELECT COUNT(*)
    INTO v_previous_bills_count
    FROM billItem, bill
    WHERE billItem.bill_id = bill.id AND 
        billItem.product_id = v_productId;
    
    /* Get LATEST PREVIOUS bill that has product listed */
    IF (v_previous_bills_count > 0) THEN
        SELECT billItem.new_stock, bill.id
        INTO v_previous_stock, v_previous_bill_id
        FROM billItem, bill
        WHERE billItem.bill_id = bill.id AND
            billItem.product_id = v_productId AND
            ROWNUM = 1
        ORDER BY bill.billdate DESC;
    END IF;    
    
    v_previous_stock := NVL(v_previous_stock, 0);
    DBMS_OUTPUT.put_line('Previous stock: ' || v_previous_stock);
    
    /* Compute the new stock */
    IF (v_bill.billtype = 'incoming') THEN
        v_new_stock := v_previous_stock + v_quantity;
    ELSIF (v_bill.billtype = 'outgoing') THEN
        v_new_stock := v_previous_stock - v_quantity;
    END IF;    
    DBMS_OUTPUT.put_line('New stock: ' || v_new_stock);
    
    INSERT INTO billItem VALUES(default, v_quantity, v_billId, v_productId, v_new_stock);
END new_bill_item;
/

EXECUTE new_bill_item(2, 1, 3);