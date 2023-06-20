-- creation of database
create database test;
use test;

-- creation of students table
create table students(
stdID int primary key,
stdname varchar(250),
sex varchar(10),
percentage int,
Sclass int,
Sec varchar(10),
Stream varchar(30),
DOB date,
check (sex in ('M', 'F'))
);

-- adding column to students
alter table students add column teacher_id int;


-- creation of teachers table
create table teachers(
teacherID int primary key,
name varchar(200),
email varchar(200),
subject varchar(200),
class int
)

-- inserting values in students

INSERT INTO students(stdID, stdname, sex, percentage, Sclass, Sec, Stream, DOB)
VALUES (1, 'Aayush','M',78,10,'A','Science','2001-03-31');

INSERT INTO students(stdID, stdname, sex, percentage, Sclass, Sec, Stream, DOB)
VALUES (3, 'Aryan','M',98,10,'B','Commerce','2001-07-08');

INSERT INTO students(stdID, stdname, sex, percentage, Sclass, Sec, Stream, DOB)
VALUES (4, 'Anika','F',98,10,'A','Science','2000-08-04');

INSERT INTO students(stdID, stdname, sex, percentage, Sclass, Sec, Stream, DOB)
VALUES (5, 'Kamal','M',68,10,'C','Humanities','2001-12-04');

INSERT INTO students(stdID, stdname, sex, percentage, Sclass, Sec, Stream, DOB)
VALUES (6, 'Riya','F',98,10,'C','Humanities','2000-08-04'),
(7, 'Aayush','M',99,10,'A','Science','2001-07-04')
(8, 'Aashna','F',88,10,'B','Commerce','2002-12-04');


-- inserting value in teachers

INSERT INTO teachers(teacherID, name, email, subject, class)
VALUES(110,'Aman','aman@gmail.com','Bio',10);

INSERT INTO teachers(teacherID, name, email, subject, class)
VALUES(111,'Saksham','saksham@gmail.com','Maths',10);

INSERT INTO teachers(teacherID, name, email, subject, class)
VALUES(112,'Anushka','anuska@gmail.com','English',10);

INSERT INTO teachers(teacherID, name, email, subject, class)
VALUES(113,'Yuvraj','yuvi@gmail.com','Physucs',10);


-- adding foreign key teacher_id to teacherID
ALTER TABLE student
ADD FOREIGN KEY (teacher_id) REFERENCES teacher (teacher_id);


-- settting foreign key of students
UPDATE students
SET teacher_id = (
SELECT teacherID FROM teachers WHERE Name = 'Aman'
)
WHERE stdID = 1;

UPDATE students
SET teacher_id = (
SELECT teacherID FROM teachers WHERE Name = 'Saksham'
)
WHERE stdname = 'Aayush';

UPDATE students
SET teacher_id = (
SELECT teacherID FROM teachers WHERE Name = 'Saksham'
)
WHERE stdname = 'Aashna';

UPDATE students
SET teacher_id = (
SELECT teacherID FROM teachers WHERE Name = 'Yuvraj'
)
WHERE stdname = 'Riya';

UPDATE students
SET teacher_id = (
SELECT teacherID FROM teachers WHERE Name = 'Anushka'
)
WHERE stdname = 'Karik';

UPDATE students
SET teacher_id = (
SELECT teacherID FROM teachers WHERE Name = 'Anushka'
)
WHERE stdname = 'Anika';

UPDATE students
SET teacher_id = (
SELECT teacherID FROM teachers WHERE Name = 'Yuvraj'
)
WHERE stdname = 'Aryan';

UPDATE students
SET teacher_id = (
SELECT teacherID FROM teachers WHERE Name = 'Yuvraj'
)
WHERE stdname = 'Kamal';


-- applying inner join to teachers and students
SELECT * FROM students s
JOIN teachers t
ON s.teacher_id = t.teacherID;

-- select distinct name from students
select distinct stdname
from students;

-- count students with sex 'M'
select count(*) , sex
from students
group by sex
having sex='M';

-- count students with sex 'M' and stream 'Science'
select count(*) , sex
from students
where sex='M'
group by sex 
having Stream='Science';


-- create features table
CREATE TABLE features(
feature_id INT AUTO_INCREMENT PRIMARY KEY,
feature_type VARCHAR(30) NOT NULL
);


INSERT INTO features (feature_type)
VALUES ('basketball'),
('cricket'),
('tenis'),
('football');

-- create table student_feature
CREATE TABLE Student_feature(
StdID INT,
feature_id INT,
FOREIGN KEY (StdID) REFERENCES students (stdID),
FOREIGN KEY (feature_id) REFERENCES features (feature_id),
PRIMARY KEY (StdID, feature_id)
);

-- insertion in student_feature
INSERT INTO Student_feature(StdID, feature_id)
VALUES (1,3),
(2,2),
(3,1),
(4,3),
(5,4);

-- students with cricket as choice
SELECT s.stdname, f.feature_type 
from students s
JOIN Student_feature sf
ON s.stdID = sf.StdID
JOIN features f
ON f.feature_id = sf.feature_id
WHERE f.feature_type = 'cricket';


-- teachers with students in tenis
SELECT t.name AS 'teacher name', s.stdname AS 'student name', f.feature_type AS 'feature'
FROM teachers t
JOIN students s 
ON s.teacher_id = t.teacherID
JOIN Student_feature sf
ON sf.StdID = s.StdID
JOIN features f
ON f.feature_id = sf.feature_id
WHERE f.feature_type = 'tenis';

-- create a view 
CREATE VIEW Student_view AS
SELECT 
s.stdname AS students,
s.sex,
s.percentage,
s.Sclass AS class,
s.Sec AS section,
t.name AS 'teacher name',
f.feature_type AS activity,
s.Stream
FROM students s
JOIN teachers t
ON s.teacher_id = t.teacherID
JOIN Student_feature sf
ON s.stdID = sf.StdID
JOIN features f
ON sf.feature_id = f.feature_id;

-- select students who are born in 2000
select * from students where DOB between '2000-01-01' and '2000-12-31';

-- create a procedure 
DELIMITER //
CREATE PROCEDURE new_procedure()
BEGIN
CREATE  TABLE temp (
    std_id INT,
    std_name VARCHAR(30),
    dob DATE,
    teacher_id INT,
    teacher_name VARCHAR(30)
  ); 
  
  select * from temp;

INSERT INTO temp (std_id, std_name, dob, teacher_id,teacher_name)
  SELECT s.stdID, s.stdname, s.DOB, t.teacherID, t.name AS 'teacher name'
  FROM students s
  JOIN teachers t 
  on s.teacher_id=t.teacherID
  WHERE YEAR(s.DOB) = 2000 AND t.name LIKE 'S%';
  
SELECT * FROM temp; 
drop table if exists temp;
END //
DELIMITER ;

-- creationg backup table
CREATE TABLE backup_student (
stdID INT PRIMARY KEY,
stdName VARCHAR(30),
sex VARCHAR(6) CHECK (Sex = 'F' || Sex = 'M'), 
Percentage INT,
Sclass INT,
Sec VARCHAR(255),
Stream Varchar(10),
DOB DATE,
teacher_id INT,
FOREIGN KEY (teacher_id) REFERENCES teachers(teacherID)
);

-- creating trigger
CREATE TRIGGER backup_std
AFTER DELETE ON students
FOR EACH ROW
INSERT INTO backup_student (StdID, StdName, Sex, Percentage, SClass, Sec, Stream, DOB, teacher_id)
VALUES (OLD.stdID, OLD.stdname, OLD.sex, OLD.percentage, OLD.Sclass, OLD.Sec, OLD.Stream, OLD.DOB, OLD.teacher_id);

DELETE FROM students WHERE stdID = 6;

SELECT * FROM backup_student;

-- printing student with 3rd highest marks
SELECT *
FROM students
ORDER BY percentage DESC
limit 2,1;

-- performing union
SELECT * FROM students
UNION
SELECT * FROM backup_student;

















