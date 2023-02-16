-- Create a procedure to update the mark in the grade table
-- SID, CID, Mark

CREATE OR REPLACE PROCEDURE PR_Update_Mark
    (P_SID NUMBER, P_CID CHAR, P_Mark NUMBER)
AS
    V_CID CHAR(8);
    E_InvalidMark EXCEPTION;
BEGIN    
    SELECT CID
    INTO V_CID
    FROM MM_Grade
    WHERE SID = P_SID AND UPPER(CID) = UPPER(P_CID);
    
    IF (P_Mark NOT BETWEEN 0 AND 100) THEN
        RAISE E_InvalidMark;
    ELSE
        UPDATE MM_Grade
        SET Mark = P_Mark
        WHERE SID = P_SID AND CID = P_CID;
    END IF;


EXCEPTION 
    WHEN No_Data_Found THEN
        RAISE_APPLICATION_ERROR(-20095, 'The input did not match any records in the Grades table.');
    WHEN E_InvalidMark THEN
        RAISE_APPLICATION_ERROR(-20097, 'An invalid value was passed into the mark parameter. Mark must be between 0 and 100.');
    WHEN Others THEN
        RAISE_APPLICATION_ERROR(-20096, 'An unknown error occured while updating the grade table. Please call 1-800-PAIN');
END PR_Update_Mark;
/
SHOW ERRORS;
EXECUTE PR_Update_Mark (111111, 'DMIT2019', 1000);
EXECUTE PR_Update_Mark (111111, 'DMIT2019', 100);
EXECUTE PR_Update_Mark (101010, 'DMIT2019', 40);