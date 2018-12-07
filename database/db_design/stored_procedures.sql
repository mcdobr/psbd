CREATE OR REPLACE TRIGGER new_bill_id
BEFORE INSERT ON bill
FOR EACH ROW
BEGIN
    SELECT 1 + NVL(MAX(id), 0)
    INTO :new.id
    FROM bill;
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