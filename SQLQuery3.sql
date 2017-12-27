	-- S2J ApartmentDB --

	-- CREATE DATABASE --
CREATE DATABASE S2J_ApartmentDB
SP_HELPDB S2J_ApartmentDB

	-- USE DATABASE -
USE S2J_ApartmentDB
GO

	-- CREATE TABLE --
CREATE SCHEMA Transactions

CREATE TABLE Transactions.Trans(
	TransNumber VARCHAR(6) CONSTRAINT cTransNum CHECK(TransNumber LIKE 'T[0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	RoomNum VARCHAR(5) CHECK(RoomNum LIKE 'R[0-9][0-9][0-9][0-9]') UNIQUE NOT NULL,
	RoomTypeCode VARCHAR(10) FOREIGN KEY REFERENCES Room.RoomType(RoomTypeCode) NOT NULL,
	EmpCode VARCHAR(5) FOREIGN KEY (EmpCode) REFERENCES Employee.Emp(EmpCode) NOT NULL,
	CustomerCode VARCHAR(7) FOREIGN KEY (CustomerCode) REFERENCES Customer.Cust(CustomerCode) NOT NULL,
	DateOfCheckIn DATETIME DEFAULT GETDATE() CONSTRAINT cIN CHECK(DateOfCheckIn >= CONVERT(DATE, GETDATE())) NOT NULL, --VR GETDATE()
	DateOfCheckOut DATETIME DEFAULT DATEADD(YEAR, 1, CONVERT(DATE, GETDATE())) CONSTRAINT cOUT CHECK(DateOfCheckOut >= DATEADD(YEAR, 1, CONVERT(DATE, GETDATE()))) NOT NULL, --VR GETDATE() YY + 1
	PRIMARY KEY(TransNumber, RoomNum)
);

CREATE TABLE Transactions.CostRoom(
	RoomNum VARCHAR(5) REFERENCES Transactions.Trans(RoomNum) CONSTRAINT cRoomNum CHECK(RoomNum LIKE 'R[0-9][0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	PeriodOfTime INT CONSTRAINT cPOT CHECK(PeriodOfTime BETWEEN 1 AND 50) NOT NULL,
	SubtotalCost MONEY CONSTRAINT cSubTot CHECK(SubtotalCost >= 10000000) NOT NULL, --hsl dgn kali Unit price
	TotalCost MONEY CONSTRAINT cTot CHECK(TotalCost >= 10000000) NOT NULL
);

DECLARE @SubTot MONEY, @Price MONEY, @POT INT
SELECT @Price = Price FROM Room.RoomType
SELECT @POT = PeriodOfTime FROM Transactions.CostRoom
SET @SubTot = @Price * @POT
PRINT @SubTotFFR
INSERT lanjutan
GO

SELECT Price FROM Room.RoomType

CREATE SCHEMA Employee

CREATE TABLE Employee.Emp(
	EmpCode VARCHAR(5) CONSTRAINT cEmpCode CHECK(EmpCode LIKE 'E[0-9][0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	EmpName VARCHAR(30) CHECK(EmpName NOT LIKE '*[!a-z ]*') NOT NULL,
	Gender VARCHAR(1) CHECK(Gender IN ('M', 'F')),
	DateOfBirth DATETIME CHECK(DateOfBirth < DATEADD(YEAR, -20, GETDATE())),
	EmpAddress VARCHAR(100) CHECK(EmpAddress LIKE 'Jl. %'),
	ZipCode INT CHECK(ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]') UNIQUE,
	PositionCode VARCHAR(5) CONSTRAINT fkPositionCode FOREIGN KEY (PositionCode) REFERENCES Employee.Jobs(PositionCode)
);

CREATE TABLE Employee.Contact(
	EmployeeCode VARCHAR(5) REFERENCES Employee.Emp(EmpCode) PRIMARY KEY NOT NULL,
	Telephone VARCHAR(13) CHECK(Telephone LIKE '0%') NOT NULL
);

CREATE TABLE Employee.ZipCode(
	ZipCode INT REFERENCES Employee.Emp(ZipCode) CHECK(ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	City VARCHAR(50) CHECK(City NOT LIKE '*[!a-z ]*') NOT NULL
);

CREATE TABLE Employee.Jobs(
	PositionCode VARCHAR(5) CHECK(PositionCode LIKE 'RD[0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	PositionName VARCHAR(50) CHECK(PositionName NOT LIKE '*[!0-9a-z -]*') NOT NULL,
	Salary MONEY CHECK(Salary >= 1000000) NOT NULL
);

CREATE TABLE Employee.Workspace(
	WorkspaceCode VARCHAR(5) CHECK(WorkspaceCode LIKE 'WS[0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	PositionCode VARCHAR(5) FOREIGN KEY (PositionCode) REFERENCES Employee.Jobs(PositionCode) NOT NULL
);

CREATE SCHEMA Room

CREATE TABLE Room.RoomType(
	RoomTypeCode VARCHAR(10) CHECK(RoomTypeCode LIKE 'R-%') PRIMARY KEY NOT NULL,
	TypeRoom VARCHAR(100) CHECK(TypeRoom NOT LIKE '*[!0-9a-z -]*') NOT NULL,
	Stock INT CHECK(Stock BETWEEN 0 AND 5) NOT NULL,
	Price MONEY CHECK(Price > 10000000) NOT NULL
);

CREATE TABLE Room.Servant(
	RoomTypeCode VARCHAR(10) REFERENCES Room.RoomType(RoomTypeCode) PRIMARY KEY NOT NULL,
	ServantName VARCHAR(30) CHECK(ServantName NOT LIKE '*[!a-z ]*') NOT NULL
);

CREATE SCHEMA Customer

CREATE TABLE Customer.Cust(
	CustomerCode VARCHAR(7) CHECK(CustomerCode LIKE 'P101[0-9][0-9][0-9]') NOT NULL PRIMARY KEY,
	CustomerName VARCHAR(30) CHECK(CustomerName NOT LIKE '*[!a-z ]*') NOT NULL,
	Gender VARCHAR(1) CHECK(Gender IN ('M', 'F')),
	CustomerAddress VARCHAR(100) CHECK(CustomerAddress LIKE 'Jl. %'),
	ZipCode INT CHECK(ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]') UNIQUE
);

CREATE TABLE Customer.Contact(
	CustomerCode VARCHAR(7) REFERENCES Customer.Cust(CustomerCode) PRIMARY KEY NOT NULL,
	Telephone VARCHAR(13) CHECK(Telephone LIKE '0%') NOT NULL
);

CREATE TABLE Customer.ZipCode(
	ZipCode INT REFERENCES Customer.Cust(ZipCode) CHECK(ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	City VARCHAR(50) CHECK(City NOT LIKE '*[!a-z ]*') NOT NULL
);


	-- INSERT --
--Insert Transactions.Trans
SELECT * FROM Transactions.Trans
INSERT Transactions.Trans VALUES('T00001', 'R0011', 'R-I', 'E0001', 'P101021', '2018-10-10', '2019-10-10');
INSERT Transactions.Trans VALUES('T00002', 'R0021', 'R-II', 'E0001', 'P101026', '2018-10-10', '2019-10-10');
INSERT Transactions.Trans VALUES('T00003', 'R0022', 'R-II', 'E0002', 'P101022', '2018-11-1', '2020-11-1');
INSERT Transactions.Trans VALUES('T00004', 'R0051', 'R-V', 'E0003', 'P101027', '2018-11-1', '2019-11-1');
INSERT Transactions.Trans VALUES('T00005', 'R0031', 'R-III', 'E0003', 'P101023', '2018-11-4', '2019-11-4');
INSERT Transactions.Trans VALUES('T00005', 'R0041', 'R-IV', 'E0004', 'P101023', '2018-11-4', '2019-11-4');
INSERT Transactions.Trans VALUES('T00006', 'R0052', 'R-V', 'E0005', 'P101024', '2018-11-7', '2019-11-7');
INSERT Transactions.Trans VALUES('T00007', 'R0012', 'R-I', 'E0006', 'P101025', '2018-11-12', '2021-11-12');
INSERT Transactions.Trans VALUES('T00008', 'R0053', 'R-V', 'E0006', 'P101028', '2018-11-22', '2020-11-22');
INSERT Transactions.Trans VALUES('T00009', 'R0042', 'R-IV', 'E0006', 'P101031', '2018-11-22', '2019-11-22');
INSERT Transactions.Trans VALUES('T00010', 'R0023', 'R-II', 'E0006', 'P101036', '2018-11-22', '2019-11-22');
INSERT Transactions.Trans VALUES('T00011', 'R0013', 'R-I', 'E0006', 'P101032', '2018-11-22', '2019-11-22');

--Insert Transactions.CostRoom
SELECT * FROM Transactions.CostRoom
INSERT Transactions.CostRoom VALUES('R0011', 1, 160000000, 160000000);
INSERT Transactions.CostRoom VALUES('R0021', 1, 120000000, 120000000);
INSERT Transactions.CostRoom VALUES('R0022', 2, 240000000, 240000000);
INSERT Transactions.CostRoom VALUES('R0051', 1, 110000000, 110000000);
INSERT Transactions.CostRoom VALUES('R0031', 1, 130000000, 260000000);
INSERT Transactions.CostRoom VALUES('R0041', 1, 150000000, 260000000);
INSERT Transactions.CostRoom VALUES('R0052', 1, 105000000, 105000000);
INSERT Transactions.CostRoom VALUES('R0012', 3, 480000000, 480000000);
INSERT Transactions.CostRoom VALUES('R0053', 2, 150000000, 150000000);
INSERT Transactions.CostRoom VALUES('R0042', 1, 120000000, 120000000);
INSERT Transactions.CostRoom VALUES('R0023', 1, 160000000, 160000000);
INSERT Transactions.CostRoom VALUES('R0013', 1, 120000000, 120000000);

--Insert Employee.Emp
SELECT * FROM Employee.Emp
INSERT Employee.Emp VALUES('E0001', 'Dani Darmayanto', 'M', '1990-10-07', 'Jl. Kelapa Dua No 12', 14044, 'RD001');
INSERT Employee.Emp VALUES('E0002', 'Jahuda Dolf Bacas', 'M', '1990-09-10', 'Jl. Karadenan No 12', 14045, 'RD001');
INSERT Employee.Emp VALUES('E0003', 'David Matius', 'M', '1990-10-09', 'Jl. Kukusan Teknik No 7', 14046, 'RD002');
INSERT Employee.Emp VALUES('E0004', 'Nanda Firdausi', 'M', '1990-03-02', 'Jl. Pabuaran Indah No 98', 14047, 'RD001');
INSERT Employee.Emp VALUES('E0005', 'Dessy Putri Alvini', 'F', '1985-04-13', 'Jl. Bubulak No 85', 14048, 'RD002');
INSERT Employee.Emp VALUES('E0006', 'Suci Rahmadhani', 'F', '1987-11-10', 'Jl. Citayam No 121', 14049, 'RD002');

--Insert Employee.Contact
SELECT * FROM Employee.Contact
INSERT Employee.Contact VALUES('E0001', '0851140459');
INSERT Employee.Contact VALUES('E0002', '0851140451');
INSERT Employee.Contact VALUES('E0003', '0851140443');
INSERT Employee.Contact VALUES('E0004', '0851140435');
INSERT Employee.Contact VALUES('E0005', '0851140431');
INSERT Employee.Contact VALUES('E0006', '0851140427');

--Insert Employee.ZipCode
SELECT * FROM Employee.ZipCode
INSERT Employee.ZipCode VALUES(14044, 'Depok');
INSERT Employee.ZipCode VALUES(14045, 'Bogor');
INSERT Employee.ZipCode VALUES(14046, 'Depok');
INSERT Employee.ZipCode VALUES(14047, 'Bogor');
INSERT Employee.ZipCode VALUES(14048, 'Bogor');
INSERT Employee.ZipCode VALUES(14049, 'Depok');

--Insert Employee.Jobs
SELECT * FROM Employee.Jobs
INSERT Employee.Jobs VALUES('RD001', 'Room Division Manager S', 8000000);
INSERT Employee.Jobs VALUES('RD002', 'Room Division Manager J', 5000000);

--Insert Employee.Workspace
SELECT * FROM Employee.Workspace
INSERT Employee.Workspace VALUES('WS081', 'RD001');
INSERT Employee.Workspace VALUES('WS082', 'RD001');
INSERT Employee.Workspace VALUES('WS083', 'RD001');
INSERT Employee.Workspace VALUES('WS051', 'RD002');
INSERT Employee.Workspace VALUES('WS052', 'RD002');
INSERT Employee.Workspace VALUES('WS053', 'RD002');

--Insert Room.RoomType
SELECT * FROM Room.RoomType
INSERT Room.RoomType VALUES('R-I', 'Garden Apartemen', 5, 160000000);
INSERT Room.RoomType VALUES('R-II', 'Loft', 5, 120000000);
INSERT Room.RoomType VALUES('R-III', 'Convertible', 5, 130000000);
INSERT Room.RoomType VALUES('R-IV', 'Two Bedroom', 5, 150000000);
INSERT Room.RoomType VALUES('R-V', 'Alcove', 5, 110000000);

--Insert Room.Servant
SELECT * FROM Room.Servant
INSERT Room.Servant VALUES('R-I', 'Dita Nurhayati');
INSERT Room.Servant VALUES('R-II', 'Iqbal Nugroho');
INSERT Room.Servant VALUES('R-III', 'Farhan Ramadhan');
INSERT Room.Servant VALUES('R-IV', 'Trisya Talia');
INSERT Room.Servant VALUES('R-V', 'Hendriko Musa');

--Insert Customer.Cust
SELECT * FROM Customer.Cust
INSERT Customer.Cust VALUES('P101021', 'Adni Alydrus', 'F', 'Jl. Condet Raya No 6', 13550);
INSERT Customer.Cust VALUES('P101026', 'Sabrina Anisa', 'F', 'Jl. Bhayangkara No22', 13562);
INSERT Customer.Cust VALUES('P101022', 'Jofanto Alfaj', 'M', 'Jl. Juanda No7', 13573);
INSERT Customer.Cust VALUES('P101027', 'Shafira Azzahra', 'F', 'Jl. Raya Bogor No 78', 13585);
INSERT Customer.Cust VALUES('P101023', 'Julius Danes', 'M', 'Jl. Sultan Agung No 6', 13850);
INSERT Customer.Cust VALUES('P101024', 'Kevin Kautsar', 'M', 'Jl. Jaksa Agung Suprapto No 1', 13866);
INSERT Customer.Cust VALUES('P101025', 'Johanes Chandra', 'M', 'Jl. Jendral Sudirman No 10', 13551);
INSERT Customer.Cust VALUES('P101028', 'Diaz Rivaldo', 'M', 'Jl. Manggis Raya No 6', 13862);
INSERT Customer.Cust VALUES('P101031', 'Bunga Sartika', 'F', 'Jl. Hakim Agung Supra No 1', 13853);
INSERT Customer.Cust VALUES('P101036', 'Alief Rizki', 'M', 'Jl. Jendral Gatot No 10', 13567);
INSERT Customer.Cust VALUES('P101032', 'Faisal Rahman', 'M', 'Jl. Djoeanda No7', 13857);

--Insert Customer.Contact
SELECT * FROM Customer.Contact
INSERT Customer.Contact VALUES('P101021', '0854500505');
INSERT Customer.Contact VALUES('P101026', '0854500510');
INSERT Customer.Contact VALUES('P101022', '0854500515');
INSERT Customer.Contact VALUES('P101027', '0854500520');
INSERT Customer.Contact VALUES('P101023', '0854500525');
INSERT Customer.Contact VALUES('P101024', '0854500535');
INSERT Customer.Contact VALUES('P101025', '0854500540');
INSERT Customer.Contact VALUES('P101028', '0854500545');
INSERT Customer.Contact VALUES('P101031', '0854500550');
INSERT Customer.Contact VALUES('P101036', '0854500555');
INSERT Customer.Contact VALUES('P101032', '0854500560');

--Insert Customer.ZipCode
SELECT * FROM Customer.ZipCode
INSERT Customer.ZipCode VALUES(13550, 'Jakarta');
INSERT Customer.ZipCode VALUES(13562, 'Jakarta');
INSERT Customer.ZipCode VALUES(13573, 'Tangerang');
INSERT Customer.ZipCode VALUES(13585, 'Bogor');
INSERT Customer.ZipCode VALUES(13850, 'Bekasi');
INSERT Customer.ZipCode VALUES(13866, 'Bogor');
INSERT Customer.ZipCode VALUES(13551, 'Depok');
INSERT Customer.ZipCode VALUES(13862, 'Bekasi');
INSERT Customer.ZipCode VALUES(13853, 'Bogor');
INSERT Customer.ZipCode VALUES(13567, 'Depok');
INSERT Customer.ZipCode VALUES(13857, 'Bekasi');


	-- SELECT --
SELECT * FROM Transactions.Trans
SELECT * FROM Transactions.CostRoom
SELECT * FROM Employee.Emp
SELECT * FROM Employee.Contact
SELECT * FROM Employee.ZipCode
SELECT * FROM Employee.Jobs
SELECT * FROM Employee.Workspace
SELECT * FROM Room.RoomType
SELECT * FROM Room.Servant
SELECT * FROM Customer.Cust
SELECT * FROM Customer.Contact
SELECT * FROM Customer.ZipCode


	--- INSERT BATCH ---
--Insert Employee
ALTER PROC spInsEmp @ECode VARCHAR(5), @EName VARCHAR(30), @EGender VARCHAR(1), @EDOB DATETIME, @ETelp VARCHAR(13), @EAdd VARCHAR(100), @ECity VARCHAR(50), @EZC INT, @EPosCode VARCHAR(5)
AS
INSERT Employee.Emp
	VALUES(@ECode, @EName, @EGender, @EDOB, @EAdd, @EZC, @EPosCode);
INSERT Employee.Contact
	VALUES(@ECode, @ETelp);
INSERT Employee.ZipCode
	VALUES(@EZC, @ECity);
PRINT 'Data Employee Telah Ditambah'
GO

--Hint >> @ECode, @EName, @EGender, @EDOB, @ETelp, @EAdd, @ECity, @EZC, @EPosCode
EXEC spInsEmp 'E0008', 'Edward Partogi', 'M', '1985-10-07', '0851140687', 'Jl. Halim Perdana No 12', 'Jakarta', 14570, 'RD002'

--Insert Jobs
SELECT * FROM Employee.Emp
SELECT * FROM Employee.Contact
SELECT * FROM Employee.ZipCode
SELECT * FROM Employee.Jobs
SELECT * FROM Employee.Workspace

CREATE PROC spInsJobs @EPosCode VARCHAR(5), @EPName VARCHAR(50), @ESal MONEY, @WSCode VARCHAR(5)
AS
INSERT Employee.Jobs
	VALUES(@EPosCode, @EPName, @ESal);
INSERT Employee.Workspace
	VALUES(@WSCode, @EPosCode);
PRINT 'DATA JOBS AND WORKSPACE SUCESSFULLY ADDED'
GO

--Hint >> @EPosCode, @EPName, @ESal, @WSCode
EXEC spInsJobs 'RD003', 'Room Division Manager S', 6000000, 'WS061' 


--Insert Customer
CREATE PROC spInsCust @CCODE VARCHAR(7), @CNAME VARCHAR(30), @CGENDER VARCHAR(1), @CADDRESS VARCHAR(100), @CZC INT, @CTELP VARCHAR(13), @CCITY VARCHAR(50)
AS
INSERT Customer.Cust 
	VALUES(@CCODE, @CNAME, @CGENDER, @CADDRESS, @CZC);
INSERT Customer.Contact
	VALUES(@CCODE, @CTELP);
INSERT Customer.ZipCode
	VALUES(@CZC, @CCITY);
PRINT 'Data Customer Telah Ditambah'
GO

--Hint >> @CCODE, @CNAME, @CGENDER, @CADDRESS, @CZC, @CTELP, @CCITY
EXEC spInsCust 'P101042', 'John Smith', 'M', 'Jl. Raya Margonda', 13770, '085284958697', 'Depok'

	--- VIEW ---

-- View Employee
ALTER VIEW vEmployee
AS
SELECT E.EmpCode, E.EmpName, E.Gender, E.DateOfBirth, K.Telephone, E.EmpAddress, E.ZipCode, J.PositionCode, J.PositionName, J.Salary FROM Employee.Emp E
JOIN Employee.Contact K ON E.EmpCode = K.EmployeeCode
JOIN Employee.ZipCode Z ON E.ZipCode = Z.ZipCode
JOIN Employee.Jobs J ON E.PositionCode = J.PositionCode
SELECT * FROM vEmployee

--View Jobs and Workspace
ALTER VIEW vJW
AS
SELECT J.PositionCode, J.PositionName, J.Salary, W.WorkspaceCode FROM Employee.Jobs J
JOIN Employee.Workspace W ON J.PositionCode = W.PositionCode
SELECT * FROM vJW
ORDER BY PositionCode ASC

--View Room
CREATE VIEW vRoom
AS
SELECT * FROM roo


--View Customer
CREATE VIEW vCustomer
AS 
SELECT C.CustomerCode, C.CustomerName, C.Gender, K.Telephone, C.CustomerAddress, Z.City, C.ZipCode FROM Customer.Cust C
JOIN Customer.Contact K ON C.CustomerCode = K.CustomerCode
JOIN Customer.ZipCode Z ON C.ZipCode = Z.ZipCode
SELECT * FROM vCustomer
