-- Create a trigger to stop weekend enrollments 'SAT' 'SUN'
CREATE OR REPLACE TRIGGER TR_BIS_MMStudent_NoWeekends
BEFORE INSERT
ON MM_Student
BEGIN
    IF TO_CHAR(SYSDATE, 'DY') IN('SAT','SUN') THEN
        RAISE_APPLICATION_ERROR(-20097, 'You cannot enroll students on the weekend.');
    END IF;
END TR_BIS_MMStudent_NoWeekends;
/
SHOW ERRORS;

-- Before statement, (before row, after row) * 5, after statement

CREATE OR REPLACE TRIGGER TR_ADS_MMStudent_Show_Message
AFTER DELETE
ON MM_Student
BEGIN
    DBMS_OUTPUT.PUT_LINE('Inside After Delete Statement Trigger');
END TR_BDS_MMGrade_Show_Message;
/
SHOW ERRORS;

DELETE FROM MM_Student WHERE sid = 154123;

INSERT INTO MM_Student (sid, sname, gender, edate) VALUES (154123, 'Jeff', 'M', SYSDATE);