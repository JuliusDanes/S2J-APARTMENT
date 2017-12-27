 
-- CREATE DATABASE --
create database SIS;

-- USE DATABASE --
use  SIS;
-- CREATE TABLE --
create table student(
	id_student char(5) not null primary key,
	name varchar (50),
	pswd varchar (50),
	sex char(1),
	addresses text,
	phone varchar (12),
	id_class char (5),
	id_majoring char (5),
	joined_date date,
);

create table parents (
	id_student char(5) not null,
	name varchar(50) not null,
	relationship varchar(50),
	sex char (1),
	phone varchar (12),
	addresses text
	primary key (id_student,name)
);


create table tuition_paid (
	id_student char(5) not null,
	id_employee char(5) not null,
	date_time datetime not null,
	semester char (2),
	amount int,
	stts char (1),
	primary key (id_student,id_employee,date_time)
);


create table class(
	id_class char(5)primary key,
	name varchar (50),
	id_majoring char (5),
	id_headclass char(5)
);


create table majoring(
	id_majoring char(5) primary key,
	name varchar (50),
);


create table course(
	id_course char(5) primary key,
	id_majoring char (5),
	name varchar(50)
);

create table admins (
	id_admin char(5) primary key,
	time_start time,
	time_end time
);

create table treasurer (
	id_treasurer char(5) primary key,
	time_start time,
	time_end time,
	workdate_type char (1)
);


create table student_score (
	id_student char (5) not null,
	id_course char (5) not null,
	score int,
	stts char (1),
	id_admin char (5) not null
	primary key (id_student,id_course,id_admin)
	);


create table teacher(
	id_teacher char(5) not null primary key,
	id_course char(5)
);


create table employee (
	id_employee char (5) primary key,
	name varchar (50),
	pswd varchar (50),
	sex char (1),
	addresses text,
	phone varchar (13),
	id_type char (1),
	joined_date date,
	salary int
);
create table course(
	id_course char(5) primary key,
	id_majoring char (5),
	name varchar(50)
);

create table admins (
	id_admin char(5) primary key,
	time_start time,
	time_end time
);

create table treasurer (
	id_treasurer char(5) primary key,
	time_start time,
	time_end time,
	workdate_type char (1)
);


create table student_score (
	id_student char (5) not null,
	id_course char (5) not null,
	score int,
	stts char (1),
	id_admin char (5) not null
	primary key (id_student,id_course,id_admin)
	);


create table teacher(
	id_teacher char(5) not null primary key,
	id_course char(5)
);


create table employee (
	id_employee char (5) primary key,
	name varchar (50),
	pswd varchar (50),
	sex char (1),
	addresses text,
	phone varchar (13),
	id_type char (1),
	joined_date date,
	salary int
);
create table course(
	id_course char(5) primary key,
	id_majoring char (5),
	name varchar(50)
);

create table admins (
	id_admin char(5) primary key,
	time_start time,
	time_end time
);

create table treasurer (
	id_treasurer char(5) primary key,
	time_start time,
	time_end time,
	workdate_type char (1)
);


create table student_score (
	id_student char (5) not null,
	id_course char (5) not null,
	score int,
	stts char (1),
	id_admin char (5) not null
	primary key (id_student,id_course,id_admin)
	);


create table teacher(
	id_teacher char(5) not null primary key,
	id_course char(5)
);


create table employee (
	id_employee char (5) primary key,
	name varchar (50),
	pswd varchar (50),
	sex char (1),
	addresses text,
	phone varchar (13),
	id_type char (1),
	joined_date date,
	salary int
);

	--CONSTRAINT--
--constraint student	
alter table student drop constraint chk_pswd
alter table student add constraint chk_id_student check (id_student like 'S%%%%');
alter table student add constraint chk_sex check (sex like 'M' OR sex like 'F');
alter table student add constraint chk_phone_student check (phone like REPLICATE('[0-9]',0-12))

--constraint class
alter table class add constraint chk_class check(id_class like 'C%%%%');

--constraint majoring
alter table majoring add constraint chk_major check(id_majoring like 'M%%%%');
--constraint employee
alter table employee add constraint id_employee check (id_employee like 'E%%%%');
alter table employee add constraint id_type check (id_type like '1' OR id_type like '2' OR id_type like '3');
alter table employee add constraint chk_sex_emp check (sex like 'M' OR sex like 'F');
alter table employee add constraint chk_phone_employee check(phone like REPLICATE('[0-9]',0-12))


--constraint course
alter table course drop constraint chk_course
alter table course add constraint chk_course check(id_course like 'P%%%%');


--constraint admins
alter table admins add constraint chk_Ad check(id_admin like 'E%%%%');


--coinstraint parents
alter table parents add constraint chk_id_student2 check (id_student like 'S%%%%');
alter table parents add constraint chk_sex_Ad check (sex like 'M' OR sex like 'F');
alter table parents add constraint chk_phone_parent check(phone like REPLICATE('[0-9]',0-12))


--constraint tuition paid
alter table tuition_paid add constraint chk_status check(stts like 'Y' OR stts like 'N');

--- FK ----------
alter table parents add foreign key (id_student) references student (id_student)
alter table course add foreign key (id_majoring) references majoring (id_majoring)
alter table student add foreign key (id_class) references class (id_class)
alter table class add foreign key (id_majoring) references majoring (id_majoring)
alter table class add foreign key (id_headclass) references teacher (id_teacher)
alter table teacher add foreign key (id_teacher) references employee (id_employee)
alter table Admins add foreign key (id_admin) references employee (id_employee)
alter table treasurer add foreign key (id_treasurer) references employee (id_employee)
alter table tuition_paid add foreign key (id_student) references student (id_student)
alter table tuition_paid add foreign key (id_employee) references treasurer (id_treasurer)
alter table student_score add foreign key (id_course) references course (id_course)
alter table student_score add foreign key (id_student) references student (id_student)
alter table student_score add foreign key (id_admin) references Admins (id_admin)
--SELECT--
select * from student;
select * from student_score;
select * from course;
select * from parents;
select * from teacher;
select * from class;
select * from majoring;
select * from teacher;
select * from tuition_paid;
select * from employee;
select * from admins;

---Trigger--

--Check Score
create trigger tr_chk_score on dbo.student_score
after insert,update
as
declare @score int
begin
select @score = score from inserted
if (@score > 75)
update student_score set stts = 'Y'
else
if (@score < 75)
update student_score set stts = 'N'
end


--Check Paid
create trigger tr_chk_paid on dbo.tuition_paid
after insert,update
as
declare @amount int
begin
select @amount = amount from inserted
if (@amount = 250000 )
update tuition_paid set stts = 'Y'
else
update tuition_paid set stts = 'N'
end

--Chk Salary
create trigger  tr_chk_salary on dbo.employee
after insert,update
as
declare @id_type char (1)
begin
select @id_type = id_type from inserted
if (@id_type = 1)
update employee set salary = 5000000
else
if (@id_type = 2)
update employee set salary = 4500000
else
if(@id_type = 3)
update employee set salary = 3500000
end

-------PROCEDURE-----------


---procedure auto generate id student--
drop procedure autospecidstudent
create procedure autospecidstudent
	@name varchar (50),
	@pswd varchar (50),
	@sex char(1),
	@addresses text,
	@phone varchar (12),
	@id_class char (5),
	@id_majoring char (5),
	@joined_date date
as
	declare @id_student char(5)
	if exists(select id_student from student where id_student = 'S0001')
		begin
			select @id_student  = MAX(right(id_student ,3)) from student
			select @id_student  =
		case
			when @id_student >=0 and @id_student <10 then 'S000' + CONVERT(char(5),@id_student + 1)
			when @id_student >=10 and @id_student <100 then 'S00' + CONVERT(char(5),@id_student + 1)
			when @id_student >=100 and @id_student <1000 then 'S0' + CONVERT(char(5),@id_student + 1)
		end
		end
	else
		update student set id_student = 'S0001'
		insert into student values(@id_student,@name,@pswd,@sex,@addresses,@phone,@id_class,@id_majoring,@joined_date)
go

exec autospecidstudent 'Octav','greget123','M','Bogor','083239123','C0001','M0001','12-12-2015'
exec autospecidstudent 'Waluyo','greget123','M','Bogor','083239123','C0001','M0001','12-12-2015'
-------auto generate id employee
select * from student
drop procedure autospecidemployee
create procedure autospecidemployee
	@name varchar (50),
	@pswd varchar (50),
	@sex char(1),
	@addresses text,
	@phone varchar (12),
	@id_type char (1),
	@salary int,
	@joined_date date
as
	declare @id_employee char(5)
	if exists(select id_employee from employee where id_employee = 'E0001')
		begin
			select @id_employee  = MAX(right(id_employee ,3)) from employee
			select @id_employee  =
		case
			when @id_employee >=0 and @id_employee <10 then 'E000' + CONVERT(char(5),@id_employee + 1)
			when @id_employee >=10 and @id_employee <100 then 'E00' + CONVERT(char(5),@id_employee + 1)
			when @id_employee >=100 and @id_employee <1000 then 'E0' + CONVERT(char(5),@id_employee + 1)
		end
		end
	else
		update employee set id_employee = 'E0001'
		insert into employee values(@id_employee,@name,@pswd,@sex,@addresses,@phone,@id_type,@joined_date,@salary)
go

exec autospecidemployee 'Aban','fchr123','M','Bogor','0891823','2','','12-12-2015'

select * from employee

-------auto generate id class
select * from class
drop procedure autospecidclass
create procedure autospecidclass
	@name varchar (50),
	@id_majoring char (5),
	@id_heacdlass char (5)
as
	declare @id_class char(5)
	if exists(select id_class from class where id_class = 'C0001')
		begin
			select @id_class  = MAX(right(id_class ,3)) from class
			select @id_class  =
		case
			when @id_class >=0 and @id_class <10 then 'C000' + CONVERT(char(5),@id_class + 1)
			when @id_class >=10 and @id_class <100 then 'C00' + CONVERT(char(5),@id_class + 1)
			when @id_class >=100 and @id_class <1000 then 'C0' + CONVERT(char(5),@id_class + 1)
		end
		end
	else
		insert into class values('C0001',@name,@id_majoring,@id_heacdlass)
		insert into class values(@id_class,@name,@id_majoring,@id_heacdlass)
go

exec autospecidclass 'X IPA 2','M0001','E0001'

select * from class

---auto generate id majoring

create procedure autospecidmajoring
	@name varchar (50)
as
	declare @id_majoring char(5)
	if exists(select id_majoring from majoring where id_majoring = 'M0001')
		begin
			select @id_majoring  = MAX(right(id_majoring ,3)) from majoring
			select @id_majoring  =
		case
			when @id_majoring >=0 and @id_majoring <10 then 'M000' + CONVERT(char(5),@id_majoring + 1)
			when @id_majoring >=10 and @id_majoring <100 then 'M00' + CONVERT(char(5),@id_majoring + 1)
			when @id_majoring >=100 and @id_majoring <1000 then 'M0' + CONVERT(char(5),@id_majoring + 1)
		end
		end
	else
		insert into majoring values('M0001',@name)
		insert into majoring values(@id_majoring,@name)
go

exec autospecidmajoring 'Arsitektur'

select * from course

----- auto spec id course
create procedure autospecidcourse
	@id_majoring char (5),
	@name varchar (50)
as
	declare @id_course char(5)
	if exists(select id_course from course where id_course = 'P0001')
		begin
			select @id_course  = MAX(right(id_course ,3)) from course
			select @id_course  =
		case
			when @id_course >=0 and @id_course <10 then 'P000' + CONVERT(char(5),@id_course + 1)
			when @id_course >=10 and @id_course <100 then 'P00' + CONVERT(char(5),@id_course + 1)
			when @id_course >=100 and @id_course <1000 then 'P0' + CONVERT(char(5),@id_course + 1)
		end
		end
	else
		insert into course values('P0001',@id_majoring,@name)
		insert into course values(@id_course,@id_majoring,@name)
go

exec autospecidcourse 'M0001','Bahasa Jerman'

----- VIEW ------
create view vscore as
select A.id_student as id_s,A.name,  B.score as score, B.stts as statuss,
C.name as name_course from student A, student_score B, course C where
A.id_student = B.id_student AND C.id_course = B.id_course

select id_s,name,name_course,score,statuss from vscore where statuss = 'N'
select id_s,name,name_course,score,statuss from vscore where statuss = 'Y'
select id_s,name,name_course,score,statuss from vscore where score > 78

create view vpayment as
select A.id_student as id_s, A.name,B.semester ,B.amount,B.stts as status
from student A, tuition_paid B where A.id_student = B.id_student

select id_s,name,semester,amount,status from vpayment where semester = 1
select id_s,name,semester,amount,status from vpayment where status = 'Y'
select id_s,name,semester,amount,status from vpayment where status = 'N'

create view vstudent_status as
select A.id_student as id_s, A.name,B.name as Class, C.name as Majoring
from student A, class B, majoring C

select name,class,majoring from vstudent_status where Majoring = 'IPA'


use SIS
GRANT CREATE PROCEDURE,CREATE TABLE,CREATE FUNCTION
to mutiad

use SIS
GRANT DELETE,INSERT,SELECT,UPDATE
to raditt

create user raditt
for login radit

create user mutiad
for login mutia

---BACKUP
BACKUP DATABASE SIS
to disk= 'C:\Program Files\Microsoft SQL Server\MSSQL10_50.DHANA\MSSQL\Backup\SIS.bak'
WITH FORMAT
GO

BACKUP LOG SIS
to disk= 'C:\Program Files\Microsoft SQL Server\MSSQL10_50.DHANA\MSSQL\Backup\SIS.bak'
GO
