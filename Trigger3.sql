-- Create a trigger to use the sequence SID_SEQ to populate the SID column for any insert into MM_Student
CREATE OR REPLACE TRIGGER TR_BIR_MMStudent_SID
BEFORE INSERT
ON MM_STUDENT
FOR EACH ROW
DECLARE
    V_SID NUMBER(8,0);
BEGIN
    SELECT SID_SEQ.NEXTVAL
    INTO V_SID
    FROM DUAL;
    :new.SID := V_SID;
END;
/
SHOW ERRORS;