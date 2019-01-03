/** 
  * Clears all from the database except the database itself
  */
DECLARE
    CURSOR c_objects IS
        SELECT object_type, '"' || object_name || '"' || DECODE(object_type, 'TABLE', ' CASCADE CONSTRAINTS', NULL) obj_name
        FROM user_objects
        WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'SEQUENCE', 'PROCEDURE', 'FUNCTION', 'SYNONYM', 'MATERIALIZED VIEW')
        ORDER BY object_type;
        
    CURSOR c_objects_type IS
        SELECT object_type, '"' || object_name || '"' obj_name
        FROM user_objects
        WHERE object_type IN ('TYPE');
BEGIN
    FOR object_record IN c_objects LOOP
        EXECUTE IMMEDIATE ('DROP ' || object_record.object_type || ' ' || object_record.obj_name);
    END LOOP;
    
    FOR object_record IN c_objects_type LOOP
        EXECUTE IMMEDIATE ('DROP ' || object_record.object_type || ' ' || object_record.obj_name || ' force');
    END LOOP;
END;