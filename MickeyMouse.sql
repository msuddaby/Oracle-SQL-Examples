DROP TABLE MM_Help_Me;
DROP TABLE MM_Honours;
DROP TABLE MM_Grade;
DROP TABLE MM_Course;
DROP TABLE MM_Student;


CREATE TABLE MM_Student(
    SID NUMBER(8,0)
        CONSTRAINT PK_MMStudent_SID PRIMARY KEY
        CONSTRAINT NN_MMStudent_SID NOT NULL,
    SName VARCHAR2(50)
        DEFAULT 'Unknown'
        CONSTRAINT NL_MMStudent_SName NULL,
    Gender CHAR(1)
        CONSTRAINT NN_MMStudent_Gender NOT NULL
        CONSTRAINT CK_MMStudent_Gender CHECK ( Gender IN ('M','F','N')),
    EDate DATE
        DEFAULT SYSDATE
        CONSTRAINT NN_MMStudent_EDate NOT NULL
        
);

CREATE TABLE MM_Course(
    CID CHAR(8)
        CONSTRAINT PK_MMCourse_CID PRIMARY KEY
        CONSTRAINT NN_MMCourse_CID NOT NULL,
    CName VARCHAR2(50)
        CONSTRAINT NL_MMCourse_CName NULL,
    Location VARCHAR2(50)
        CONSTRAINT NL_MMCourse_Location NULL,
    CCost NUMBER(6,2)
        DEFAULT 575.00
        CONSTRAINT NL_MMCourse_CCost NULL
);


CREATE TABLE MM_Grade(
    SID NUMBER(8,0)
        CONSTRAINT FK_MMGrade_SID REFERENCES MM_Student ( SID )
        CONSTRAINT NN_MMGrade_SID NOT NULL,
    CID CHAR(8)
        CONSTRAINT FK_MMGrade_CID REFERENCES MM_Course ( CID )
        CONSTRAINT NN_MMGrade_CID NOT NULL,
    Mark NUMBER(5,2)
        CONSTRAINT NN_MMGrade_Mark NOT NULL
        CONSTRAINT CK_MMGrade_Mark CHECK (Mark >= 0 AND Mark <= 100),
    CONSTRAINT MM_Grade_PK PRIMARY KEY (SID, CID)
);

// >= 80
CREATE TABLE MM_Honours(
    SID NUMBER(8,0)
        CONSTRAINT FK_MMHonours_SID REFERENCES MM_Student
        CONSTRAINT NN_MMHonours_SID NOT NULL,
    CID CHAR(8)
        CONSTRAINT FK_MMHonours_CID REFERENCES MM_Course
        CONSTRAINT NN_MMHonours_CID NOT NULL,
    Mark NUMBER(5,2)
        CONSTRAINT NN_MMHonours_Mark NOT NULL
        CONSTRAINT CK_MMHonours_Mark CHECK (Mark >= 0 AND Mark <= 100),
    CONSTRAINT PK_MMHonours PRIMARY KEY (SID, CID)
);

// < 50
CREATE TABLE MM_Help_Me(
    SID NUMBER(8,0)
        CONSTRAINT FK_MMHelpMe_SID REFERENCES MM_Student
        CONSTRAINT NN_MMHelpMe_SID NOT NULL,
    CID CHAR(8)
        CONSTRAINT FK_MMHelpMe_CID REFERENCES MM_Course
        CONSTRAINT NN_MMHelpMe_CID NOT NULL,
    MARK NUMBER(5,2)
        CONSTRAINT NN_MMHelpMe_Mark NOT NULL
        CONSTRAINT CK_MMHelpMe_Mark CHECK (Mark >= 0 AND Mark <= 100),
    CONSTRAINT PK_MMHelpMe PRIMARY KEY (SID, CID)
        
);

-- delete all old records
delete from mm_grade;
delete from mm_course;
delete from mm_student;

-- table inserts into mm_student
insert into mm_student
	(sid, sname, gender, edate)
values
	(333333, 'Elmer Fudd', 'M', TO_DATE('22-Oct-1967 08:05:00','DD-Mon-YYYY HH24:MI:SS'));

insert into mm_student
	(sid, sname, gender, edate)
values
	(111111, 'Donald Duck', 'M', TO_DATE('18-Dec-1992 15:45:00','DD-Mon-YYYY HH24:MI:SS'));

insert into mm_student
	(sid, sname, gender, edate)
values
	(555555, 'Bugs Bunny', 'M', TO_DATE('28-Feb-1972 10:50:00','DD-Mon-YYYY HH24:MI:SS'));

insert into mm_student
	(sid, sname, gender, edate)
values
	(222222, 'Minnie Mouse', 'F', TO_DATE('01-Mar-1986 16:20:06','DD-Mon-YYYY HH24:MI:SS'));

insert into mm_student
	(sid, sname, gender, edate)
values
	(444444, 'Pluto T. Dog', 'M', TO_DATE('09-Jul-1994 12:05:05','DD-Mon-YYYY HH24:MI:SS'));

-- table inserts into mm_course
insert into mm_course
	(cid, cname, location, ccost)
values
	('DMIT2019', 'Intermediate Database Programming', 'WA320', 999.99);

insert into mm_course
	(cid, cname, location, ccost)
values
	('CPSC1012', 'Programming Fundamentals', 'WA316', 888.88);

insert into mm_course
	(cid, cname, location, ccost)
values
	('DMIT1508', 'Database Fundamentals', 'WB320', 777.77);

-- table inserts into mm_grade

insert into mm_grade
	(sid, cid, mark)
values
	(333333, 'DMIT1508', 100.00);

insert into mm_grade
	(sid, cid, mark)
values
	(111111, 'DMIT2019', 95.50);

insert into mm_grade
	(sid, cid, mark)
values
	(333333, 'CPSC1012', 89.75);

insert into mm_grade
	(sid, cid, mark)
values
	(111111, 'DMIT1508', 86.00);

insert into mm_grade
	(sid, cid, mark)
values
	(333333, 'DMIT2019', 92.25);

commit;


CREATE OR REPLACE PROCEDURE PR_Update_MMGrade
    (P_SID NUMBER, P_CID CHAR, P_MARK NUMBER)
IS
BEGIN
    UPDATE MM_Grade
    SET Mark = P_MARK
    WHERE SID = P_SID AND
            CID = P_CID;
    
END PR_Update_MMGrade;
/
SHOW ERRORS;

CREATE OR REPLACE PROCEDURE PR_Update_MMGrade2
    (P_SName VARCHAR2, P_CName VARCHAR2, P_MARK NUMBER2)
IS
    V_SID NUMBER(8,0);
    V_CID CHAR(8);
BEGIN
    SELECT SID
    INTO V_SID
    FROM MM_Student
    WHERE SName = P_SName;
    
    SELECT CID
    INTO V_CID
    FROM MM_Course
    WHERE CName = P_CName;
    
    UPDATE MM_Grade
    SET Mark = P_Mark
    WHERE SID = V_SID AND
          CID = V_CID;
    
END PR_Update_MMGrade2;
/
SHOW ERRORS;


SELECT * FROM MM_Grade;



CREATE OR REPLACE FUNCTION FN_Get_SName_And_EDate
    (P_SID NUMBER)
RETURN VARCHAR2
IS
    V_SName VARCHAR2(50);
    V_EDate DATE;
    V_Output VARCHAR2(100);
BEGIN
    SELECT SName, EDate
    INTO V_SName, V_EDate
    FROM MM_Student
    WHERE SID = P_SID;
    
    V_Output := 'The student ' || V_SName || ' enrolled on ' || TO_CHAR(V_EDate, 'DD-MON-YYYY');
    
END FN_Get_SName_And_EDate;
/
SHOW ERRORS;

COLUMN MM_Student FORMAT A8 HEADING "Student|Nice"


CREATE OR REPLACE FUNCTION FN_SHOW_COURSE_INFORMATION
    (P_CID CHAR)
RETURN VARCHAR2
IS
 V_CName VARCHAR2(50);
 V_Count NUMBER(2,0);
 V_Output VARCHAR2(100);
BEGIN
    SELECT CName
    INTO V_CName
    FROM MM_Course
    WHERE CID = P_CID;
    
    SELECT COUNT(SID) 
    INTO V_Count
    FROM MM_Grade
    WHERE CID = P_CID;
    
    V_Output := 'The course ' || V_CName;
    IF V_Count = 0 THEN
         V_Output := V_Output || ' is empty';
    ELSIF V_Count BETWEEN 1 AND 25 THEN
        V_Output := V_Output || ' has ' || to_char(V_Count) || ' students';
    ELSE
        V_Output := V_Output || ' is overfull.';
    END IF;
    
    RETURN V_Output;
END FN_Show_Course_Information;
/
SHOW ERRORS;

SELECT FN_Show_Course_Information ('DMIT2019')
FROM dual;

SELECT SID, CID FROM MM_Grade;