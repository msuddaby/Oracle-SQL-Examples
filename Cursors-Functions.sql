-- Create a function to return a student's course names and grades
-- Input: student id

CREATE OR REPLACE FUNCTION FN_Get_CNames_Marks
    (P_SID NUMBER)
RETURN VARCHAR2
IS
    CURSOR C_Course IS 
        SELECT MM_Course.CName, MM_Grade.Mark
        FROM   MM_Course, MM_Grade
        WHERE MM_Course.CID = MM_Grade.CID 
            AND MM_Grade.SID = P_SID;
    
    V_CName VARCHAR2(50);
    V_Mark  NUMBER(5,2);
    V_Output VARCHAR2(750);
BEGIN
    OPEN C_Course;
    
    FETCH C_Course INTO V_CName, V_Mark;
    
    
    
    IF C_Course%NOTFOUND THEN
        V_Output := 'Student #' || TO_CHAR(P_SID) || ' did not take any courses.';
    ELSE
        WHILE C_Course%FOUND LOOP
            V_Output := V_Output || ' ' || V_CName || ' ' || TO_CHAR(V_Mark, '999.99'); 
            DBMS_Output.PUT_LINE('Output is: ' || V_Output);
            FETCH C_Course INTO V_CName, V_Mark;
        END LOOP;
    END IF;
    CLOSE C_Course;
    
    RETURN V_Output;
END FN_Get_CNames_Marks;
/
SHOW ERRORS;

SELECT FN_Get_CNames_Marks (333333)
FROM DUAL;

-- Create a function to return the name of the student (s) who has/have
-- the highest mark in a course.

CREATE OR REPLACE FUNCTION FN_Get_Highest
    (P_CID CHAR)
RETURN VARCHAR2
IS
    CURSOR C_Grades IS
        SELECT SID, Mark
        FROM MM_Grade
        WHERE CID = P_CID;
    
    V_SName VARCHAR2(50);
    V_SID   NUMBER(8,0);
    V_Mark  NUMBER(5,2);
    V_MaxMark NUMBER(5,2);
    V_Output VARCHAR(150);
    
BEGIN
    OPEN C_Grades;
    FETCH C_Grades INTO V_SID, V_Mark;
    
    IF C_Grades%NOTFOUND THEN
        V_Output := 'Nobody took the course ' || P_CID;
    ELSE
        SELECT MAX(Mark)
        INTO V_MaxMark
        FROM MM_Grade
        WHERE CID = P_CID;
        
        WHILE C_Grades%FOUND LOOP
            IF V_Mark = V_MaxMark THEN
                SELECT SName
                INTO V_SName
                FROM MM_Student
                WHERE SID = V_SID;
            
                V_Output := V_Output || ' ' || V_SName || ' ';
            END IF;
        FETCH C_Grades INTO V_SID, V_Mark;
        END LOOP;
        V_Output := V_Output || ' has / have a grade of ' || V_MaxMark || ' in course ' || P_CID;
    END IF;
    CLOSE C_Grades;
    RETURN V_Output;
END FN_Get_Highest;
/
SHOW ERRORS;

SELECT FN_Get_Highest ('DMIT1508') FROM DUAL;