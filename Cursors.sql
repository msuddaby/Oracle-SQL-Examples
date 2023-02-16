-- Create a procedure to insert records into the MM_Honours or MM_Help_Me table.

INSERT INTO MM_Student (SID, SNAME, GENDER, EDATE)
VALUES (554433, 'Jeffery', 'M', SYSDATE);

INSERT INTO MM_Grade (SID, MARK, CID)
VALUES (554433, 21.3, 'DMIT2019');

CREATE OR REPLACE PROCEDURE PR_Populate_New_Tables
AS
    CURSOR C_GRADES IS SELECT SID, CID, Mark
                       FROM MM_Grade
                       WHERE Mark NOT BETWEEN 50 AND 79.99;
    V_SID NUMBER(8,0);
    V_CID CHAR(8);
    V_Mark NUMBER(5,2);
BEGIN
    OPEN C_GRADES;
    FETCH C_Grades INTO V_SID, V_CID, V_MARK;
    
    WHILE C_GRADES%FOUND
    LOOP
        IF V_MARK >= 80 THEN
            INSERT INTO MM_Honours 
                (SID, CID, Mark)
            VALUES
                (V_SID, V_CID, V_MARK);
        ELSE
            INSERT INTO MM_HELP_ME
                (SID, CID, Mark)
            VALUES
                (V_SID, V_CID, V_MARK);
        END IF;
    FETCH C_Grades INTO V_SID, V_CID, V_MARK;    
    END LOOP;
    
    
    CLOSE C_GRADES;
END PR_Populate_New_Tables;
/
SHOW ERRORS;

-- Same procedure using a RowType variable.

CREATE OR REPLACE PROCEDURE PR_Populate_New_Tables
AS
    CURSOR C_GRADES IS SELECT SID, CID, Mark
                       FROM MM_Grade
                       WHERE Mark NOT BETWEEN 50 AND 79.99;
    V_GRADE_ROW C_GRADES%ROWTYPE;                       
BEGIN
    OPEN C_GRADES;
    FETCH C_Grades INTO V_GRADE_ROW;
    
    WHILE C_GRADES%FOUND
    LOOP
        IF V_MARK >= 80 THEN
            INSERT INTO MM_Honours 
                (SID, CID, Mark)
            VALUES
                (V_GRADE_ROW.SID, V_GRADE_ROW.CID, V_GRADE_ROW.MARK);
        ELSE
            INSERT INTO MM_HELP_ME
                (SID, CID, Mark)
            VALUES
                (V_GRADE_ROW.SID, V_GRADE_ROW.CID, V_GRADE_ROW.MARK);
        END IF;
    FETCH C_Grades INTO V_GRADE_ROW;    
    END LOOP;
    
    
    CLOSE C_GRADES;
END PR_Populate_New_Tables;
/
SHOW ERRORS;

EXECUTE PR_Populate_New_Tables();