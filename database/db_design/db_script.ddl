-- Generated by Oracle SQL Developer Data Modeler 18.3.0.268.1208
--   at:        2018-12-16 19:28:13 EET
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



CREATE TABLE bill (
    id                 INTEGER NOT NULL,
    bill_date          DATE NOT NULL,
    other_party_name   VARCHAR2(50),
    bill_type          VARCHAR2(20) NOT NULL
);

ALTER TABLE bill
    ADD CONSTRAINT ck_valid_bill_type CHECK ( bill_type IN (
        'incoming',
        'outgoing'
    ) );

ALTER TABLE bill ADD CONSTRAINT bill_pk PRIMARY KEY ( id );

CREATE TABLE billitem (
    id           INTEGER NOT NULL,
    quantity     INTEGER NOT NULL,
    bill_id      INTEGER NOT NULL,
    product_id   INTEGER NOT NULL,
    new_stock    INTEGER NOT NULL
);

ALTER TABLE billitem ADD CONSTRAINT ck_valid_billed_quantity CHECK ( quantity > 0 );

ALTER TABLE billitem ADD CONSTRAINT billitem_stock_ck CHECK ( new_stock >= 0 );

ALTER TABLE billitem ADD CONSTRAINT billitem_pk PRIMARY KEY ( id );

CREATE TABLE category (
    id     INTEGER NOT NULL,
    name   VARCHAR2(50)
);

ALTER TABLE category ADD CONSTRAINT category_pk PRIMARY KEY ( id );

CREATE TABLE product (
    id            INTEGER NOT NULL,
    name          VARCHAR2(100) NOT NULL,
    unit          VARCHAR2(20) DEFAULT 'buc' NOT NULL,
    price         NUMBER(10, 2) NOT NULL,
    category_id   INTEGER NOT NULL
);

ALTER TABLE product
    ADD CONSTRAINT ck_correct_unit CHECK ( unit IN (
        'buc',
        'kg',
        'm',
        'm2',
        'm3'
    ) );

ALTER TABLE product
    ADD CONSTRAINT ck_price_positive CHECK ( price > 0.0 );

ALTER TABLE product ADD CONSTRAINT product_pk PRIMARY KEY ( id );

ALTER TABLE billitem
    ADD CONSTRAINT billitem_bill_fk FOREIGN KEY ( bill_id )
        REFERENCES bill ( id );

ALTER TABLE billitem
    ADD CONSTRAINT billitem_product_fk FOREIGN KEY ( product_id )
        REFERENCES product ( id );

ALTER TABLE product
    ADD CONSTRAINT product_category_fk FOREIGN KEY ( category_id )
        REFERENCES category ( id );

ALTER TABLE billitem
    ADD CONSTRAINT billitem_bill_fk FOREIGN KEY ( bill_id )
        REFERENCES bill ( id );

ALTER TABLE billitem
    ADD CONSTRAINT billitem_product_fk FOREIGN KEY ( product_id )
        REFERENCES product ( id );

ALTER TABLE product
    ADD CONSTRAINT product_category_fk FOREIGN KEY ( category_id )
        REFERENCES category ( id );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             4
-- CREATE INDEX                             0
-- ALTER TABLE                             15
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
