	--- S2J Apartment ---
--- CREATE DATABASE
CREATE DATABASE S2J_ApartmentDB
SP_HELPDB S2J_ApartmentDB

--- USE DATBASE
USE S2J_ApartmentDB
GO

--- CREATE SCHEMA
CREATE SCHEMA HumanResources;
CREATE SCHEMA Services;
CREATE SCHEMA Users;
CREATE SCHEMA Transactions;

--- CREATE TABLE
--Create Table Employee
DROP TABLE HumanResources.Divisions
CREATE TABLE HumanResources.Divisions(
	DivID	VARCHAR(10) CHECK(DivID NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') PRIMARY KEY NOT NULL,
	DivName	VARCHAR(30) NOT NULL,
	ChiefID VARCHAR(5)
);
SP_HELP 'HumanResources.Divisions'

ALTER TABLE HumanResources.Divisions
ADD CONSTRAINT fkChiefID FOREIGN KEY (ChiefID) REFERENCES HumanResources.Employee(EmpID) ON DELETE SET NULL ON UPDATE CASCADE;

DROP TABLE HumanResources.Incumbency
CREATE TABLE HumanResources.Incumbency(
	IncumbencyID	VARCHAR(10) CHECK(IncumbencyID NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') PRIMARY KEY NOT NULL,
	IncumbencyName	VARCHAR(100) NOT NULL,
	DivID			VARCHAR(10) FOREIGN KEY (DivID) REFERENCES HumanResources.Divisions(DivID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

DROP TABLE HumanResources.Employee
CREATE TABLE HumanResources.Employee(
	ID				INT IDENTITY NOT NULL,
	EmpID			VARCHAR(5) DEFAULT 0 PRIMARY KEY,
	NIK				BIGINT CHECK(NIK BETWEEN 1000000000000000 AND 9999999999999999) UNIQUE NOT NULL,
	EmpName			VARCHAR(30) CHECK(EmpName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') UNIQUE NOT NULL,
	Gender			VARCHAR(10) CHECK(Gender IN('M', 'F')) NOT NULL,
	DateOfBirth		DATETIME CHECK(DateOfBirth < DATEADD(YEAR, -20, GETDATE())) NOT NULL,
	Age				INT CHECK(Age > 0),
	MaritalStatus	VARCHAR(10) CHECK(MaritalStatus IN('M', 'S', 'Married', 'Single')),
	IncumbencyID	VARCHAR(10) FOREIGN KEY (IncumbencyID) REFERENCES HumanResources.Incumbency(IncumbencyID) ON DELETE SET NULL ON UPDATE CASCADE,
	Salary			MONEY CHECK(Salary >= 1000000)
);

DROP TABLE HumanResources.EmpContact
CREATE TABLE HumanResources.EmpContact(
	EmpID		VARCHAR(5) REFERENCES HumanResources.Employee(EmpID) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY NOT NULL,
	Telephone	BIGINT CHECK(Telephone BETWEEN 1000000 AND 999999999999) UNIQUE NOT NULL,
	EmaiL		VARCHAR(100) CHECK(Email LIKE '[A-Z]%@[A-Z]%.%')
);

DROP TABLE HumanResources.EmpAddress
CREATE TABLE HumanResources.EmpAddress(
	EmpID		VARCHAR(5) REFERENCES HumanResources.Employee(EmpID) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY NOT NULL,
	Address		VARCHAR(200) CHECK(Address NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	ZipCode		INT CHECK(ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]'),
	City		VARCHAR(30) CHECK(City NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	Province	VARCHAR(30) CHECK(Province NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%')
);

DROP TABLE HumanResources.EmpAccount
CREATE TABLE HumanResources.EmpAccount(
	EmpID		VARCHAR(5) REFERENCES HumanResources.Employee(EmpID) ON DELETE CASCADE ON UPDATE CASCADE UNIQUE NOT NULL,
	AccountNum	VARCHAR(19) CHECK(AccountNum LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') UNIQUE NOT NULL,
	AccountName	VARCHAR(30) CHECK(AccountName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	BankName	VARCHAR(30) CHECK(BankName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	PRIMARY KEY(EmpID, AccountNum)
);

--Create Table Services
DROP TABLE Services.RoomType
CREATE TABLE Services.RoomType(	
	RTypeID			VARCHAR(10) CHECK(RTypeID LIKE 'R-[I,V,X]%') PRIMARY KEY NOT NULL,
	RTypeName		VARCHAR(100) UNIQUE NOT NULL,
	Price			MONEY CHECK(Price >= 10000000) NOT NULL,
	RoomAvailable	INT DEFAULT 10 CHECK(RoomAvailable >= 0) NOT NULL,
	RoomIsUsed		INT DEFAULT 0 CHECK(RoomIsUsed >= 0) NOT NULL,
);

DROP TABLE Services.Servant
CREATE TABLE Services.Servant(
	ID				INT IDENTITY NOT NULL,
	SerName			VARCHAR(30) FOREIGN KEY (SerName) REFERENCES HumanResources.Employee(EmpName) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	EmpID			VARCHAR(5) REFERENCES HumanResources.Employee(EmpID) PRIMARY KEY NOT NULL,
	RTypeID			VARCHAR(10) FOREIGN KEY (RTypeID) REFERENCES Services.RoomType(RTypeID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	SerContact		INT CHECK(SerContact LIKE '9[0-9][0-9]') NOT NULL
);

DROP TABLE Services.RoomNum
CREATE TABLE Services.RoomNum(	
	RoomNum		VARCHAR(5) CHECK(RoomNum LIKE 'R[S,J][0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	Status		INT DEFAULT 1 CHECK(Status IN(1, 0)) NOT NULL,
	RTypeID		VARCHAR(10) FOREIGN KEY (RTypeID) REFERENCES Services.RoomType(RTypeID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

--Create Table Customer
DROP TABLE Users.Customer
CREATE TABLE Users.Customer(
	ID				INT IDENTITY NOT NULL,
	CustID			VARCHAR(5) DEFAULT 0 PRIMARY KEY,
	NIK				BIGINT CHECK(NIK BETWEEN 1000000000000000 AND 9999999999999999) UNIQUE NOT NULL,
	CustName		VARCHAR(30) CHECK(CustName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	Gender			VARCHAR(10) CHECK(Gender IN('M', 'F')) NOT NULL,
	DateOfBirth		DATETIME CHECK(DateOfBirth < DATEADD(YEAR, -20, GETDATE())) NOT NULL,
	Age				INT CHECK(Age > 0)
);

DROP TABLE Users.CustContact
CREATE TABLE Users.CustContact(
	CustID		VARCHAR(5) REFERENCES Users.Customer(CustID) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY NOT NULL,
	Telephone	BIGINT CHECK(Telephone BETWEEN 1000000 AND 999999999999) UNIQUE NOT NULL,
	EmaiL		VARCHAR(100) CHECK(Email LIKE '[A-Z]%@[A-Z]%.%')
);

DROP TABLE Users.CustAddress
CREATE TABLE Users.CustAddress(
	CustID		VARCHAR(5) REFERENCES Users.Customer(CustID) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY NOT NULL,
	Address		VARCHAR(200) CHECK(Address NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	ZipCode		INT CHECK(ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]'),
	City		VARCHAR(30) CHECK(City NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	Province	VARCHAR(30) CHECK(Province NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%')
);

DROP TABLE Users.CustAccount
CREATE TABLE Users.CustAccount(
	CustID		VARCHAR(5) REFERENCES Users.Customer(CustID) ON DELETE CASCADE ON UPDATE CASCADE UNIQUE NOT NULL,
	AccountNum	VARCHAR(19) CHECK(AccountNum LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') UNIQUE NOT NULL,
	AccountName	VARCHAR(30) CHECK(AccountName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	BankName	VARCHAR(30) CHECK(BankName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	PRIMARY KEY(CustID, AccountNum)
);

--Create Table Transactions
DROP TABLE Transactions.MainTrans
CREATE TABLE Transactions.MainTrans(	
	ID				INT IDENTITY NOT NULL,
	TransID			VARCHAR(5) DEFAULT 0 PRIMARY KEY,	
	CustID			VARCHAR(5) FOREIGN KEY (CustID) REFERENCES Users.Customer(CustID) NOT NULL,
	EmpID			VARCHAR(5) FOREIGN KEY (EmpID) REFERENCES HumanResources.Employee(EmpID) NOT NULL,
	RoomNum			VARCHAR(5) FOREIGN KEY (RoomNum) REFERENCES Services.RoomNum(RoomNum) UNIQUE NOT NULL
);

CREATE TABLE Transactions.TransHistory(
	TransID			VARCHAR(5) DEFAULT 0 PRIMARY KEY,
	TransDate		DATETIME
	TransTime		TIME
);

DROP TABLE Transactions.CostRoom
CREATE TABLE Transactions.CostRoom(
	RoomNum			VARCHAR(5) REFERENCES Services.RoomNum(RoomNum) PRIMARY KEY NOT NULL,
	PeriodOfTime	INT CONSTRAINT cPT CHECK(PeriodOfTime BETWEEN 1 AND 50) NOT NULL,
	TotalCost		MONEY CONSTRAINT cTC CHECK(TotalCost >= 10000000)
	ChkIN
	ChkOUT
);

INSERT Transactions.MainTrans(PeriodOfTime)
VALUES(2)

ALTER PROC spIns @POT INT
AS
DECLARE @TC MONEY, @Price MONEY
SELECT @Price = Price FROM Services.RoomType
SET @TC = @POT * @Price
INSERT Transactions.MainTrans
VALUES(@POT, @TC)
GO


SELECT * FROM Transactions.MainTrans

CREATE TABLE Transactions.Payment(
	TransID			VARCHAR(5) FOREIGN KEY (TransID) REFERENCES Transactions.Payment(TransID) NOT NULL,
	AccountNum		VARCHAR(19) REFERENCES Users.CustAccount(AccountNum) PRIMARY KEY NOT NULL,
	TotalCost		MONEY,
	DueDate			DATETIME DEFAULT DATEADD(MONTH, 1, CONVERT(DATE, GETDATE())) NOT NULL,
	Status			INT DEFAULT 0 CHECK(Status IN(1, 0)) NOT NULL
);

ALTER TABLE Transactions.Payment
ALTER COLUMN 		TotalCost		INT;
ADD 		Status			INT DEFAULT 0 CHECK(Status IN(1, 0)) NOT NULL;
ADD COLUMN	TransCODE			VARCHAR(5) FOREIGN KEY (TransID) REFERENCES Transactions.Payment(TransID) NOT NULL;
ADD COLUMN	AccountNum		VARCHAR(19) REFERENCES Users.CustAccount(AccountNum) PRIMARY KEY NOT NULL,
ADD COLUMN		TotalCost		MONEY,
ADD COLUMN		DueDate			DATETIME DEFAULT DATEADD(MONTH, 1, CONVERT(DATE, GETDATE())) NOT NULL,
ADD COLUMN		Status			INT DEFAULT 0 CHECK(Status IN(1, 0)) NOT NULL

SELECT CR.TransID, CA.AccountNum, CR.TotalCost
INTO Transactions.Payment
FROM Users.CustAccount CA
JOIN Transactions.CostRoom CR
ON CA.CustID = CR.CustID
GO

SELECT * FROM Transactions.Payment



--- CREATE VIEW ---
-- Create View Incumbency & Divisions
CREATE VIEW vIncDiv
AS
SELECT I.IncumbencyID, I.IncumbencyName, I.DivID, D.DivName, D.ChiefID
FROM HumanResources.Incumbency I
JOIN HumanResources.Divisions D
ON I.DivID = D.DivID

SELECT * FROM vIncDiv

-- Create View Employee
CREATE VIEW vEmployee
AS
SELECT E.EmpID, E.NIK, E.EmpName, E.Gender, E.DateOfBirth, E.Age, E.MaritalStatus, K.Telephone, K.EmaiL, A.Address, A.ZipCode, A.City, A.Province, C.AccountNum, C.AccountName, C.BankName, I.IncumbencyID, I.IncumbencyName, D.DivName, D.ChiefID
FROM HumanResources.Employee E
LEFT OUTER JOIN HumanResources.EmpContact K
ON E.EmpID = K.EmpID
LEFT OUTER JOIN HumanResources.EmpAddress A
ON E.EmpID = A.EmpID
LEFT OUTER JOIN HumanResources.EmpAccount C
ON E.EmpID = C.EmpID
LEFT OUTER JOIN HumanResources.Incumbency I
ON E.IncumbencyID = I.IncumbencyID
LEFT OUTER JOIN HumanResources.Divisions D
ON I.DivID = D.DivID

SELECT * FROM vEmployee

-- Create View Room
CREATE VIEW vRoom
AS
SELECT N.RoomNum, N.Status, N.RTypeID, T.RTypeName, T.Price, T.RoomAvailable, T.RoomIsUsed
FROM Services.RoomNum N
LEFT OUTER JOIN Services.RoomType T
ON N.RTypeID = T.RTypeID

SELECT * FROM vRoom

-- Create View Servant
CREATE VIEW vServant
AS
SELECT T.RTypeID, T.RTypeName, S.SerName, S.EmpID, S.SerContact FROM Services.RoomType T 
INNER JOIN Services.Servant S
ON T.RTypeID = S.RTypeID

SELECT * FROM vServant

-- Create View Customer Biodata
CREATE VIEW vCustBio
AS
SELECT U.CustID, U.NIK, U.CustName, U.Gender, U.DateOfBirth, U.Age, K.Telephone, K.EmaiL, A.Address, A.ZipCode, A.City, C.AccountNum, C.AccountName, C.BankName
FROM Users.Customer U
LEFT OUTER JOIN Users.CustContact K
ON U.CustID = K.CustID
LEFT OUTER JOIN Users.CustAddress A
ON U.CustID = A.CustID
LEFT OUTER JOIN Users.CustAccount C
ON U.CustID = C.CustID

SELECT * FROM vCustBio





--- INSERT TABLE ---
--Insert Divisions
SELECT * FROM HumanResources.Divisions
CREATE PROC spInsDiv @EID VARCHAR(5), @DivID VARCHAR(10), @DivName VARCHAR(100), @ChiefID VARCHAR(5)
AS
IF @EID = 'FOUND' OR @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'CEO' OR IncumbencyID = 'CHRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		INSERT HumanResources.Divisions(DivID, DivName, ChiefID)
			VALUES(@DivID, @DivName, @ChiefID);
		PRINT 'Division ' + @DivID + ' [' + @DivName + ']' + ' successfully Added +'
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'CEO' AND IncumbencyID != 'CHRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @DivID VARCHAR(10), @DivName VARCHAR(100), @ChiefID VARCHAR(5)

EXEC spInsDiv 'FOUND', 'FOUNDER', 'CO-Founder', NULL
EXEC spInsDiv 'FOUND', 'DEXEDIV', 'Executive Director', NULL
EXEC spInsDiv 'FOUND', 'EXEDIV', 'Executive General', 'E0003'
EXEC spInsDiv 'FOUND', 'OPDIV', 'Operating Management', 'E0005'
EXEC spInsDiv 'FOUND', 'FINDIV', 'Finance and Investment', 'E0006'
EXEC spInsDiv 'FOUND', 'HRDIV', 'Human Resources', 'E0007'
EXEC spInsDiv 'FOUND', 'LEGDIV', 'Legal', 'E0008'
EXEC spInsDiv 'FOUND', 'MIDIV', 'Marketing and Information', 'E0009'
EXEC spInsDiv 'FOUND', 'CDDIV', 'Creative Development', 'E0010'
EXEC spInsDiv 'FOUND', 'QADIV', 'Quality Assurance', 'E0011'

--Insert Incumbency
SELECT * FROM HumanResources.Incumbency
CREATE PROC spInsInc @EID VARCHAR(5), @IncID VARCHAR(10), @IncName VARCHAR(100), @DivID VARCHAR(10)
AS
IF @EID = 'FOUND' OR @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'CHRO' OR IncumbencyID = 'MHRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		INSERT HumanResources.Incumbency
			VALUES(@IncID, @IncName, @DivID);
		PRINT 'Incumbency ' + @IncID + ' [' + @IncName + ']' + ' successfully Added +'
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'CHRO' AND IncumbencyID != 'MHRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @IncID VARCHAR(10), @IncName VARCHAR(100), @DivID VARCHAR(10)

EXEC spInsInc 'FOUND', 'FOUNDER', 'CO-Founder', 'FOUNDER'
EXEC spInsInc 'FOUND', 'CEO', 'Chief Executive Officer', 'DEXEDIV'
EXEC spInsInc 'FOUND', 'COO', 'Chief Operating Executive', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CFO', 'Chief Financial Executive', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CHRO', 'Chief Human Resources Officer', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CLO', 'Chief Legal Officer', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CCDO', 'Chief Creative Development Officer', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CMO', 'Chief Marketing Officer', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CQAO', 'Chief Quality Assurance Officer', 'EXEDIV'

EXEC spInsInc 'FOUND', 'MOO', 'Manager Operating Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'OO', 'Operating Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'MAO', 'Manager Audit Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'AO', 'Audit Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'MFMO', 'Manager Facilities and Maintenance Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'FMO', 'Facilities and Maintenance Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'MTIO', 'Manager Tools and Inventory Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'TIO', 'Tools and Inventory Officer', 'OPDIV'

EXEC spInsInc 'FOUND', 'MFO', 'Manager Financial Officer', 'FINDIV'
EXEC spInsInc 'FOUND', 'FO', 'Financial Officer', 'FINDIV'
EXEC spInsInc 'FOUND', 'MIO', 'Manager Investment Officer', 'FINDIV'
EXEC spInsInc 'FOUND', 'IO', 'Investment Officer', 'FINDIV'

EXEC spInsInc 'FOUND', 'MHRO', 'Manager Human Resources Officer', 'HRDIV'
EXEC spInsInc 'FOUND', 'HRO', 'Human Resources Officer', 'HRDIV'

EXEC spInsInc 'FOUND', 'MPDO', 'Manager Plan and Design Officer', 'CDDIV'
EXEC spInsInc 'FOUND', 'PDO', 'Plan and Design Officer', 'CDDIV'
EXEC spInsInc 'FOUND', 'MCO', 'Manager Creative Officer', 'CDDIV'
EXEC spInsInc 'FOUND', 'CO', 'Creative Officer', 'CDDIV'

EXEC spInsInc 'FOUND', 'MCSO', 'Manager Customer Services Officer', 'QADIV'
EXEC spInsInc 'FOUND', 'CSO', 'Customer Services Officer', 'QADIV'
EXEC spInsInc 'FOUND', 'MSO', 'Manager Security Officer', 'QADIV'
EXEC spInsInc 'FOUND', 'SO', 'Security Officer', 'QADIV'
EXEC spInsInc 'FOUND', 'MSVO', 'Manager Servant Officer', 'QADIV'
EXEC spInsInc 'FOUND', 'SVO', 'Servant Officer', 'QADIV'

EXEC spInsInc 'FOUND', 'MLO', 'Manager Legal Officer', 'LEGDIV'
EXEC spInsInc 'FOUND', 'LO', 'Legal Officer', 'LEGDIV'
EXEC spInsInc 'FOUND', 'MDCO', 'Manager Document Control Officer', 'LEGDIV'
EXEC spInsInc 'FOUND', 'DCO', 'Document Control Officer', 'LEGDIV'

EXEC spInsInc 'FOUND', 'MMO', 'Manager Marketing Officer', 'MIDIV'
EXEC spInsInc 'FOUND', 'MO', 'Marketing Officer', 'MIDIV'
EXEC spInsInc 'FOUND', 'MPRO', 'Manager Public Relations Officer', 'MIDIV'
EXEC spInsInc 'FOUND', 'PRO', 'Public Relations Officer', 'MIDIV'

--Insert Employee
SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmpContact
SELECT * FROM HumanResources.EmpAddress
SELECT * FROM HumanResources.EmpAccount

DROP PROC spInsEmp
CREATE PROC spInsEmp @EID VARCHAR(5), @NIK BIGINT, @Name VARCHAR(30), @Gender VARCHAR(10), @DOB DATETIME, @MS VARCHAR(10), @Telp BIGINT, @Email VARCHAR(100), @Add VARCHAR(200), @ZC INT, @City VARCHAR(30), @Prov VARCHAR(30), @AccNum VARCHAR(19), @AccName VARCHAR(30), @BName VARCHAR(30), @IncID VARCHAR(10), @Salary MONEY
AS
IF @EID = 'FOUND' OR @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MHRO' OR IncumbencyID = 'HRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		INSERT HumanResources.Employee(NIK, EmpName, Gender, DateOfBirth, MaritalStatus, IncumbencyID, Salary)
			VALUES(@NIK, @Name, @Gender, @DOB, @MS, @IncID, @Salary);

		DECLARE @Count INT, @EmpID VARCHAR(5), @Age INT
		SELECT @Count = ID FROM HumanResources.Employee
		WHERE EmpID = '0'
		SET @EmpID = (
			CASE
				WHEN (@Count < 10) THEN 'E000'
				WHEN (@Count >= 10) AND (@Count < 100) THEN 'E00'
				WHEN (@Count >= 100) AND (@Count < 1000) THEN 'E0'
				WHEN (@Count >= 1000) AND (@Count < 10000) THEN 'E'
			END
			)
		SET @EmpID = @EmpID + CAST(@Count AS VARCHAR(5))
		SET @Age = FLOOR(DATEDIFF(DAY, @DOB, GETDATE()) / 365.25)

		UPDATE HumanResources.Employee
		SET EmpID = @EmpID,
			Age = @Age,
			MaritalStatus = (
			CASE
				WHEN (MaritalStatus = 'M') THEN 'Married'
				WHEN (MaritalStatus = 'S') THEN 'Single'
				ELSE @MS
			END
			)
		WHERE EmpID = '0'

		INSERT HumanResources.EmpContact
			VALUES(@EmpID, @Telp, @Email);
		INSERT HumanResources.EmpAddress
			VALUES(@EmpID, @Add, @ZC, @City, @Prov);
		INSERT HumanResources.EmpAccount
			VALUES(@EmpID, @AccNum, @AccName, @BName);
		PRINT 'Employee ' + @EmpID + ' [' + @Name + ']' + ' successfully Added +'
END
ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MHRO' AND IncumbencyID != 'HRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >>  @EID VARCHAR(5), @NIK BIGINT, @Name VARCHAR(30), @Gender VARCHAR(10), @DOB DATETIME, @MS VARCHAR(10), @Telp BIGINT, @Email VARCHAR(100), @Add VARCHAR(200), @ZC INT, @City VARCHAR(30), @Prov VARCHAR(30), @AccNum VARCHAR(19), @AccName VARCHAR(30), @BName VARCHAR(30), @IncID VARCHAR(10), @Salary MONEY

SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmpContact
SELECT * FROM HumanResources.EmpAddress
SELECT * FROM HumanResources.EmpAccount

EXEC spInsEmp 'FOUND', 3175042512990006, 'Shafira Az"zahra', 'F', '1990-01-02', 'M', 085284843201, 'shafira.azzahra@yahoo.com', 'Jl Raya Bogor No 78', 13510, 'Jakarta', 'DKI Jakarta', '1234-5678-1234-5678', 'Shafira Azzahra', 'Bukopin', 'FOUNDER', NULL
EXEC spInsEmp 'FOUND', 3175042512990001, 'Julius Danes Nugroho', 'M', '1990-12-25', 'M', 085284843202, 'julius.danes.nugroho@gmail.com', 'Jl. Bangun Raya No 23', 13550, 'Jakarta', 'DKI Jakarta', '1234-5678-8765-4321', 'Julius Danes', 'Bukopin', 'FOUNDER', NULL
EXEC spInsEmp 'FOUND', 3175042512990002, 'Jofanto Alfaj', 'M', '1990-02-03', 'M', 085284843203, 'jofanto.alfaj@outlook.biz', 'Jl Juanda No7', 13350, 'Depok', 'Jawa Barat', '8765-4321-1234-5678', 'Jofanto Alfaj', 'Bukopin', 'FOUNDER', NULL

EXEC spInsEmp 'FOUND', 3175042512990003, 'Oktaviano Pratama', 'M', '1985-12-25', 'M', 02055550132, 'oktaviano.pratama@adventure-works.com', 'Jl. Margonda Raya No 14', 17816, 'Depok', 'Jawa Barat', '0178-1650-0610-2406', 'Oktaviano Pratama', 'Bukopin', 'CEO', 76000000
EXEC spInsEmp 'FOUND', 3175042512990004, 'Sean Chai', 'F', '1990-12-27', 'S', 02055650133, 'sean1@adventure-works.com', '9314 Icicle Way', 98027, 'Bogor', 'Jawa Barat', '2053-5545-0132-4687', 'Sean Chai', 'Bukopin', 'COO', 65000000
EXEC spInsEmp 'FOUND', 3175042512990005, 'Dan Wilson', 'M', '1988-11-4', 'M', 0836765457, 'dan1@adventure-works.com', '5863 Sierra', 98004, 'Depok', 'Jawa Barat', '6533-5554-0144-8719', 'Dan Wilson', 'Bukopin', 'CFO', 55000000
EXEC spInsEmp 'FOUND', 3175042512990007, 'Mark McArthur', 'M', '1988-2-2', 'S', 068645783576, 'mark1@adventure-works.com', '9863 Ridge Place', 98006, 'Tangerang', 'Banten', '4147-5455-0154-2823', 'Mark McArthur', 'Bukopin', 'CHRO', 58000000
EXEC spInsEmp 'FOUND', 3175042512990008, 'Houman Pournasseh', 'M', '1984-1-27', 'S', 079575758685, 'houman0@adventure-works.com', '1397 Paradise Ct.', 98052, 'Bogor', 'Jawa Barat', '9325-5553-0199-6282', 'Houman Pournasseh', 'Bukopin', 'CLO', 50000000
EXEC spInsEmp 'FOUND', 3175042512990010, 'Sairaj Uddin', 'M', '1986-4-17', 'M', 085784635908, 'sairaj0@adventure-works.com', '9882 Clay Rde', 98052, 'Bogor ', 'Jawa Barat', '1830-5455-0136-4171', 'Sairaj Uddin', 'Bukopin', 'CMO', 47000000
EXEC spInsEmp 'FOUND', 3175042512990011, 'Michiko Osada', 'F', '1983-6-24', 'S', 096878568756, 'michiko0@adventure-works.com', '8040 Hill Ct', 98074, 'Jakarta', 'DKI Jakarta', '5300-5545-0159-7283', 'Michiko Osada', 'Bukopin', 'CCDO', 53000000
EXEC spInsEmp 'FOUND', 3175042512990013, 'Cynthia Randall', 'F', '1989-6-23', 'S', 05876454678, 'cynthia0@adventure-works.com', '1962 Ferndale Lane', 98028, 'Depok', 'Jawa Barat', '5333-5555-0111-7839', 'Cynthia Randall', 'Bukopin', 'CQAO', 48000000

EXEC spInsEmp 'FOUND', 3175042512990014, 'Kathie Flood', 'F', '1988-4-5', 'M', 057945687935, 'kathie0@adventure-works.com', '463 H Stagecoach Rd.', 98201, 'Bekasi', 'Jawa Barat', '3532-5565-0138-7284', 'Kathie Flood', 'Bukopin', 'MOO', 29000000
EXEC spInsEmp 'FOUND', 3175042512990015, 'Britta Simon', 'F', '1995-3-30', 'M', 06785787878, NULL, '2046 Las Palmas', NULL, 'Bekasi', 'Jawa Barat', '9535-5855-0169-8374', 'Britta Simon', 'Bukopin', 'OO', 19000000
EXEC spInsEmp 'FOUND', 3175042512990016, 'Brian Lloyd', 'M', '1996-1-1', 'S', 08357869703, NULL, '7230 Vine Maple Street', NULL, 'Tangerang', 'Banten', '1140-5559-0182-2638', 'Brian Lloyd', 'Bukopin', 'MAO', 27000000
EXEC spInsEmp 'FOUND', 3175042512990017, 'David Liu', 'M', '1995-12-31', 'M', 07394729475, NULL, '9605 Pheasant Circle', NULL, 'Jakarta', 'DKI Jakarta', '6436-5255-0185-2836', 'David Liu', 'Bukopin', 'AO', 17000000
EXEC spInsEmp 'FOUND', 3175042512990018, 'Laura Norman', 'F', '1993-3-22', 'S', 078563564587, NULL, '6937 E. 42nd Street', NULL, 'Bogor', 'Jawa Barat', '6146-5155-0185-1793', 'Laura Norman', 'Bukopin', 'MFMO', 24000000
EXEC spInsEmp 'FOUND', 3175042512990019, 'Michael Patten', 'M', '1991-11-11', 'M', 0264758647, NULL, '2038 Encino Drive', NULL, 'Depok', 'Jawa Barat', '6246-5525-1185-9729', 'Michael Patten', 'Bukopin', 'FMO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990020, 'Andy Ruth', 'F', '1993-9-20', 'M', 037492564967, NULL, '4777 Rockne Drive', NULL, 'Jakarta', 'DKI Jakarta', '6346-5575-0185-9183', 'Andy Ruth', 'Bukopin', 'MTIO', 21000000
EXEC spInsEmp 'FOUND', 3175042512990021, 'Yuhong Li', 'F', '1991-7-24', 'S', 073839428475, NULL, '502 Alexander Pl.', NULL, 'Bogor', NULL, '9165-5515-0155-2849', 'Yuhong Li', 'Bukopin', 'TIO', 11000000
EXEC spInsEmp 'FOUND', 3175042512990022, 'Robert Rounthwaite', 'M', '1987-8-17', 'M', 0637492549, NULL, '6843 San Simeon Dr.', NULL, 'Depok', 'Jawa Barat', '9675-5585-0185-8204', 'Robert Rounthwaite', 'Bukopin', 'MFO', 28000000
EXEC spInsEmp 'FOUND', 3175042512990023, 'Andreas Berglund', 'M', '1979-8-5', 'S', 0836384633, NULL, '1803 Olive Hill', NULL, 'Bekasi', 'Jawa Barat', '1981-5505-0124-8163', 'Andreas Berglund', 'Bukopin', 'FO', 18000000
EXEC spInsEmp 'FOUND', 3175042512990024, 'Reed Koch', 'M', '1980-5-26', 'M', 02648573548, NULL, '1275 West Street', NULL, 'Depok', 'Jawa Barat', '1861-5585-0124-2631', 'Reed Koch', 'Bukopin', 'MIO', 26000000

EXEC spInsEmp 'FOUND', 3175042512990025, 'Guy Gilbert', 'M', '1975-11-11', 'M', 085284843206, NULL, '7726 Driftwood Drive', NULL, 'Bogor', 'Jawa Barat', '2030-5155-0112-3934', 'Guy Gilbert', 'Bukopin', 'IO', 16000000
EXEC spInsEmp 'FOUND', 3175042512990026, 'Kevin Brown', 'M', '1978-6-2', 'M', 01837482939, NULL, '7883 Missing Canyon Court', NULL, 'Jakarta', 'DKI Jakarta', '2025-5355-0132-1033', 'Kevin Brown', 'Bukopin', 'MHRO', 27000000
EXEC spInsEmp 'FOUND', 3175042512990027, 'Roberto Tamburello', 'M', '1973-1-30', 'S', 08293648987, NULL, '2137 Birchwood Dr', NULL, 'Jakarta', 'DKI Jakarta', '6532-5155-0144-2233', 'Roberto Tamburello', 'Bukopin', 'HRO', 17000000
EXEC spInsEmp 'FOUND', 3175042512990028, 'Rob Walters', 'F', '1979-3-23', 'M', 01725374829, NULL, '5678 Lakeview Blvd.', NULL, 'Depok', 'Jawa Barat', '4137-5455-0154-1939', 'Rob Walters', 'Bukopin', 'MPDO', 24000000
EXEC spInsEmp 'FOUND', 3175042512990029, 'Thierry Hers', 'F', '1980-5-7', 'M', 07384926384, NULL, '1970 Napa Ct.', NULL, 'Depok', 'Jawa Barat', '9135-1555-0199-2933', 'Thierry Hers', 'Bukopin', 'PDO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990030, 'David Bradley', 'M', '1973-4-8', 'S', 08354758364, NULL, '3768 Door Way', NULL, 'Tangerang', 'Banten', '1820-5556-0136-5849', 'David Bradley', 'Bukopin', 'MCO', 25000000
EXEC spInsEmp 'FOUND', 3175042512990031, 'JoLynn Dobney', 'F', '1976-9-9', 'M', 08263748249, NULL, '7126 Ending Ct.', NULL, 'Tangerang', 'Banten', '5010-5515-0159-1928', 'JoLynn Dobney', 'Bukopin', 'CO', 15000000
EXEC spInsEmp 'FOUND', 3175042512990032, 'Ruth Ellerbrock', 'F', '1974-5-16', 'M', 0193946270, NULL, '2176 Apollo Way', NULL, 'Bogor', 'Jawa Barat', '9184-5155-0148-5932', 'Ruth Ellerbrock', 'Bukopin', 'MCSO', 26000000
EXEC spInsEmp 'FOUND', 3175042512990033, 'Gail Erickson', 'M', '1979-8-18', 'S', 02836282674, NULL, '9435 Breck Court', NULL, 'Bogor', 'Jawa Barat', '1533-5585-0111-2183', 'Gail Erickson', 'Bukopin', 'CSO', 16000000
EXEC spInsEmp 'FOUND', 3175042512990034, 'Barry Johnson', 'M', '1983-10-7', 'M', 04728946538, NULL, '3114 Notre Dame Ave.', NULL, 'Depok', 'Jawa Barat', '3512-5565-0138-5849', 'Barry Johnson', 'Bukopin', 'MLO', 22000000

EXEC spInsEmp 'FOUND', 3175042512990035, 'Angela Barbariol', 'F', '1976-11-30', 'S', 08394742928, NULL, '2687 Ridge Road', NULL, 'Jakarta', 'DKI Jakarta', '4224-5155-0189-2935', 'Angela Barbariol', 'Bukopin', 'LO', 12000000
EXEC spInsEmp 'FOUND', 3175042512990036, 'Jill Williams', 'F', '1977-1-28', 'M', 03825382283, NULL, '3238 Laguna Circle', NULL, 'Depok', 'Jawa Barat', '5018-5595-0165-8689', 'Jill Williams', 'Bukopin', 'MDCO', 23000000
EXEC spInsEmp 'FOUND', 3175042512990037, 'Diane Tibbott', 'F', '1983-5-7', 'M', 0836482637, NULL, '8192 Seagull Court', NULL, 'Bogor', 'Jawa Barat', '9874-5755-0185-1939', 'Diane Tibbott', 'Bukopin', 'DCO', 13000000
EXEC spInsEmp 'FOUND', 3175042512990038, 'François Ajenstat', 'F', '1980-2-12', 'M', 03794729274, NULL, '1144 Paradise Ct.', NULL, 'Depok', 'Jawa Barat', '6328-5055-0129-0865', 'François Ajenstat', 'Bukopin', 'MMO', 20000000
EXEC spInsEmp 'FOUND', 3175042512990039, 'Frank Lee', 'M', '1975-5-14', 'S', 037198373918, NULL, '8290 Margaret Ct.', NULL, 'Tangerang', 'Banten', '3128-5595-0150-9290', 'Frank Lee', 'Bukopin', 'MO', 10000000
EXEC spInsEmp 'FOUND', 3175042512990040, 'Paul Singh', 'M', '1976-4-24', 'S', 02729172981, NULL, '1343 Prospect St', NULL, 'Bekasi', 'Jawa Barat', '4325-5255-0113-2829', 'Paul Singh', 'Bukopin', 'MPRO', 24000000
EXEC spInsEmp 'FOUND', 3175042512990041, 'Gigi Matthew', 'M', '1979-5-5', 'M', 04948292849, NULL, '7808 Brown St.', NULL, 'Depok', 'Jawa Barat', '2012-5855-0151-1035', 'Gigi Matthew', 'Bukopin', 'PRO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990042, 'Marc Ingle', 'M', '1981-10-9', 'M', 08729294928, NULL, '2473 Orchard Way', NULL, 'Bekasi', 'Jawa Barat', '9125-5505-0114-4902', 'Marc Ingle', 'Bukopin', 'OO', 19000000
EXEC spInsEmp 'FOUND', 3175042512990043, 'Janeth Esteves', 'F', '1974-10-17', 'S', 08193859283, NULL, '4566 La Jolla', NULL, 'Tangerang', 'Banten', '9113-5575-0196-3822', 'Janeth Esteves', 'Bukopin', 'AO', 17000000
EXEC spInsEmp 'FOUND', 3175042512990044, 'Mark Harrington', 'M', '1977-8-11', 'S', 01719461944, NULL, '8585 Los Gatos Ct.', NULL, 'Jakarta', 'DKI Jakarta', '4133-5557-0136-3949', 'Mark Harrington', 'Bukopin', 'FMO', 14000000

EXEC spInsEmp 'FOUND', 3175042512990045, 'Zheng Mu', 'F', '1977-11-11', 'S', 08394849204, NULL, '6578 Woodhaven Ln.', NULL, 'Jakarta', 'DKI Jakarta', '1713-7555-0173-2130', 'Zheng Mu', 'Bukopin', 'TIO', 11000000
EXEC spInsEmp 'FOUND', 3175042512990046, 'Ivo Salmre', 'M', '1976-12-12', 'S', 08374274927, NULL, '3841 Silver Oaks Place', NULL, 'Bandung', 'Jawa Barat', '1415-5455-0179-2910', 'Ivo Salmre', 'Bukopin', 'FO', 18000000
EXEC spInsEmp 'FOUND', 3175042512990047, 'Ashvini Sharma', 'F', '1979-12-2', 'M', 0272847294, NULL, '7270 Pepper Way', NULL, 'Cirebon', 'Jawa Barat', '1247-5552-0160-1910', 'Ashvini Sharma', 'Bukopin', 'IO', 16000000
EXEC spInsEmp 'FOUND', 3175042512990048, 'Kendall Keil', 'M', '1986-12-3', 'M', 03628593455, NULL, '6580 Poor Ridge Court', NULL, 'Jakarta', 'DKI Jakarta', '1656-1555-0111-2829', 'Kendall Keil', 'Bukopin', 'HRO', 17000000
EXEC spInsEmp 'FOUND', 3175042512990049, 'Keil Barreto de Mattos', 'M', '1983-7-7', 'M', 02728482633, NULL, '7439 Laguna Niguel', NULL, 'Bandung', 'Jawa Barat', '9512-5585-0178-1992', 'Keil Barreto de Mattos', 'Bukopin', 'PDO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990050, 'Alejandro Alejandro', 'M', '1984-8-2', 'M', 03674828, NULL, '4311 Clay Rd', NULL, 'Cirebon', 'Jawa Barat', '1388-5558-0128-4903', 'Alejandro Alejandro', 'Bukopin', 'CO', 15000000
EXEC spInsEmp 'FOUND', 3175042512990051, 'Garrett Young', 'F', '1988-3-9', 'S', 02718163824, NULL, '7127 Los Gatos Court', 92834, 'Depok', 'Jawa Barat', '5213-5515-0173-1829', 'Garrett Young', 'Bukopin', 'CSO', 16000000
EXEC spInsEmp 'FOUND', 3175042512990052, 'Jian Shuo Wang', 'F', '1982-10-4', 'M', 02827189311, NULL, '2736 Scramble Rd', NULL, 'Bekasi', '9937-5515-0137-1920Jawa Barat', '6019-5553-0179-2929', 'Jian Shuo Wang', 'Bukopin', 'LO', 12000000
EXEC spInsEmp 'FOUND', 3175042512990053, 'Susan Eaton', 'F', '1987-3-29', 'S', 028584629496, NULL, '8310 Ridge Circle', NULL, 'Bogor', 'Jawa Barat', '9413-5557-0196-1829', 'Susan Eaton', 'Bukopin', 'DCO', 13000000
EXEC spInsEmp 'FOUND', 3175042512990054, 'Alice Ciccu', 'F', '1989-12-21', 'S', 028394729394, NULL, '2115 Passing Grade', NULL, 'Bandung', 'Jawa Barat', '9337-5515-0162-2324', 'Alice Ciccu', 'Bukopin', 'MO', 10000000
EXEC spInsEmp 'FOUND', 3175042512990055, 'Simon Rapier', 'M', '1980-6-24', 'M', 076362947393, 'simon0@adventure-works.com', '3421 Bouncing Road', NULL, 'Jakarta', 'DKI Jakarta ', '3333-5555-0173-8929', 'Simon Rapier', 'Bukopin', 'PRO', 14000000

EXEC spInsEmp 'FOUND', 3175042512990056, 'Stephanie Conroy', 'F', '1980-12-21', 'S', 072937194972, NULL, '7435 Ricardo', 91120, 'Jakarta', 'DKI Jakarta', '5934-5655-0110-8373', 'Stephanie Conroy', 'Bukopin', 'MSVO', 24000000
EXEC spInsEmp 'FOUND', 3175042512990057, 'Samantha Smith', 'M', '1979-12-21', 'M', 0193919382919, NULL, '1648 Eastgate Lane', NULL, 'Depok', 'Jawa Barat', '5287-5545-0114-9282', 'Samantha Smith', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990058, 'Tawana Nusbaum', 'F', '1983-12-21', 'S', 0278192719372, NULL, '9964 North Ridge Drive', NULL, 'Bogor', 'Jawa Barat', '3638-5535-0113-3525', 'Tawana Nusbaum', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990059, 'Denise Smith', 'F', '1985-12-21', 'M', 0828171936207, NULL, '5669 Ironwood Way', NULL, 'Tangerang', 'Banten', '9837-5595-2421-1920', 'Denise Smith', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990060, 'Hao Chen', 'F', '1982-12-21', 'S', 038936293723, NULL, '7691 Benedict Ct.', NULL, 'Bandung', 'Jawa Barat', '8291-5855-0115-8273', 'Hao Chen', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990061, 'Alex Nayberg', 'M', '1986-12-21', 'M', 091848793753, NULL, '1400 Gate Drive', NULL, 'Depok', 'Jawa Barat', '8306-5355-0136-8283', 'Alex Nayberg', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990062, 'Eugene Kogan', 'F', '1981-12-21', 'S', 018491748185, NULL, '991 Vista Verde', NULL, 'Bogor', 'Jawa Barat', '8129-5557-0198-9291', 'Eugene Kogan', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990063, 'Brandon Heidepriem', 'M', '1981-12-21', 'M', 027292747284, NULL, '8000 Crane Court', NULL, 'Bogor', 'Jawa Barat', '1723-5551-0179-7192', 'Brandon Heidepriem', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990064, 'Barbara Decker', 'M', '1984-12-21', 'M', 048719847472, NULL, '7939 Bayview Court', NULL, 'Depok', 'Jawa Barat', '4229-2555-0137-1902', 'Barbara Decker', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990065, 'Eugene Zabokritski', 'F', '1987-12-21', 'S', 038728163857, NULL, '3385 Crestview Drive', NULL, 'Jakarta', 'DKI Jakarta', '1219-5545-0192-9292', 'Eugene Zabokritski', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990066, 'Jeff Hay', 'F', '1982-12-21', 'S', 038161285728, NULL, '2275 Valley Blvd', NULL, 'Bandung', 'Jawa Barat', '2421-5552-0191-9304', 'Jeff Hay', 'Bukopin', 'SVO', 14000000

--Insert Room Type
SELECT * FROM Services.RoomType
CREATE PROC spInsRoomType @EID VARCHAR(5), @RTID VARCHAR(10), @RTN VARCHAR(100), @Price MONEY
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'COO' OR IncumbencyID = 'MFMO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		INSERT Services.RoomType(RTypeID, RTypeName, Price)
			VALUES(@RTID, @RTN, @Price);
		PRINT 'Room Type ' + @RTID + ' [' + @RTN + ']' + ' successfully Added +'
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'COO' AND IncumbencyID != 'MFMO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @RTID VARCHAR(10), @RTN VARCHAR(100), @Price MONEY

EXEC spInsRoomType 'E0016', 'R-I', 'Garden Apartement', 160000000
EXEC spInsRoomType 'E0016', 'R-II', 'Alcove Minimalist', 120000000
EXEC spInsRoomType 'E0016', 'R-III', 'Convertible', 110000000
EXEC spInsRoomType 'E0016', 'R-IV', '4Play Room', 150000000
EXEC spInsRoomType 'E0016', 'R-V', 'Loft Vintage', 130000000

--Insert Servant
SELECT * FROM Services.Servant
CREATE PROC spInsServ @EID VARCHAR(5), @EmpID VARCHAR(5), @RTID VARCHAR(10), @SC INT
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MFMO' OR IncumbencyID = 'MHRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		DECLARE @SN VARCHAR(30)
		SELECT @SN = EmpName FROM HumanResources.Employee
		WHERE EmpID = @EmpID
		IF @EmpID = (
			SELECT EmpID FROM HumanResources.Employee
			WHERE IncumbencyID = 'SVO' AND EmpID = @EmpID)
				BEGIN
				INSERT Services.Servant
					VALUES(@SN, @EmpID, @RTID, @SC);				
				PRINT 'Servant Room Type ' + @RTID + ', ' + @EmpID + ' [' + @SN + ']' + ' successfully Added +'
				END
		ELSE 
			PRINT 'He/She is not a SERVANT!';
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFMO' AND IncumbencyID != 'MHRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @EmpID VARCHAR(5), @RTID VARCHAR(10), @SC INT

EXEC spInsServ 'E0016', 'E0055', 'R-I', 911
EXEC spInsServ 'E0016', 'E0056', 'R-I', 911
EXEC spInsServ 'E0016', 'E0057', 'R-II', 922
EXEC spInsServ 'E0016', 'E0058', 'R-II', 922
EXEC spInsServ 'E0016', 'E0059', 'R-III', 933
EXEC spInsServ 'E0016', 'E0060', 'R-III', 933
EXEC spInsServ 'E0016', 'E0061', 'R-IV', 944
EXEC spInsServ 'E0016', 'E0062', 'R-IV', 944
EXEC spInsServ 'E0016', 'E0063', 'R-V', 955
EXEC spInsServ 'E0016', 'E0064', 'R-V', 955

--Insert RoomNum
SELECT * FROM Services.RoomNum
CREATE PROC spInsRoom @EID VARCHAR(5), @RTID VARCHAR(10), @BD VARCHAR(1), @Qty SMALLINT
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MFMO' OR IncumbencyID = 'FMO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		DECLARE @Count SMALLINT, @Num VARCHAR(2), @TP SMALLINT, @RN VARCHAR(5)
		SET @Count = 1
		SET @TP =
			CASE @RTID
				WHEN 'R-I' THEN 1
				WHEN 'R-II' THEN 2
				WHEN 'R-III' THEN 3
				WHEN 'R-IV' THEN 4
				WHEN 'R-V' THEN 5
				WHEN 'R-VI' THEN 6
				WHEN 'R-VII' THEN 7
				WHEN 'R-VIII' THEN 8
				WHEN 'R-IX' THEN 9
				ELSE 00
			END
		WHILE @Count <= @Qty
		BEGIN
			SET @Num = 
				CASE
					WHEN (@Count < 10) THEN '0'
					ELSE ''
				END	
			SET @Num = CAST(@Num AS VARCHAR(2)) + CAST(@Count AS VARCHAR(2))
			SET @RN = 'R' + @BD + CAST(@TP AS VARCHAR(1)) + CAST(@Num AS VARCHAR(2)) + @Num
			INSERT Services.RoomNum(RoomNum, RTypeID)
			VALUES(@RN, @RTID)
			SET @Count = CAST(@Count AS INT)
			SET @Count = @Count + 1;			
			PRINT 'Room Num ' + @RN + ' [Room Type ' + @RTID + ']' + ' successfully Added +'
		END
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFMO' AND IncumbencyID != 'FMO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @RTID VARCHAR(10), @BD VARCHAR(1), @Qty SMALLINT

EXEC spInsRoom 'E0016', 'R-I', 'S', 10
EXEC spInsRoom 'E0016', 'R-II', 'S', 10
EXEC spInsRoom 'E0016', 'R-III', 'S', 10
EXEC spInsRoom 'E0016', 'R-IV', 'S', 10
EXEC spInsRoom 'E0016', 'R-V', 'S', 10
EXEC spInsRoom 'E0016', 'R-I', 'J', 10
EXEC spInsRoom 'E0016', 'R-II', 'J', 10
EXEC spInsRoom 'E0016', 'R-III', 'J', 10
EXEC spInsRoom 'E0016', 'R-IV', 'J', 10
EXEC spInsRoom 'E0016', 'R-V', 'J', 10


--- DELETE RECORD ---
-- Delete Divisions
SELECT * FROM HumanResources.Divisions
CREATE PROC spDelDiv @EID VARCHAR(5), @DivID VARCHAR(10)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'CEO' OR IncumbencyID = 'CHRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
	DECLARE @DivName VARCHAR(100)
	SELECT @DivName = DivName FROM HumanResources.Divisions
	WHERE DivID = @DivID;
	DELETE HumanResources.Divisions
	WHERE DivID = @DivID;
	PRINT 'Division ' + @DivID + ' [' + @DivName + ']' + ' successfully Deleted -'
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'CEO' AND IncumbencyID != 'CHRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >>  @EID VARCHAR(5), @DivID VARCHAR(10)
EXEC spDelDiv 'E0007', 'OPDIV'

-- Delete Incumbency
SELECT * FROM HumanResources.Incumbency
CREATE PROC spDelInc @EID VARCHAR(5), @IncID VARCHAR(10)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'CHRO' OR IncumbencyID = 'MHRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
	DECLARE @IncName VARCHAR(100)
	SELECT @IncName = IncumbencyName FROM HumanResources.Incumbency
	WHERE IncumbencyID = @IncID;
	DELETE HumanResources.Incumbency
	WHERE IncumbencyID = @IncID;
	PRINT 'Incumbency ' + @IncID + ' [' + @IncName + ']' + ' successfully Deleted -'
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'CHRO' AND IncumbencyID != 'MHRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >>  @EID VARCHAR(5), @IncID VARCHAR(10)
EXEC spDelInc 'E0007', 'LO'

-- Delete Employee
SELECT * FROM vEmployee
CREATE PROC spDelEmp @EID VARCHAR(5), @EmpID VARCHAR(5)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MHRO' OR IncumbencyID = 'HRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
	DECLARE @EmpName VARCHAR(30)
	SELECT @EmpName = EmpName FROM HumanResources.Employee
	WHERE EmpID = @EmpID;
	DELETE HumanResources.Employee
	WHERE EmpID = @EmpID;
	PRINT 'Employee ' + @EmpID + ' [' + @EmpName + ']' + ' successfully Deleted -'
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MHRO' AND IncumbencyID != 'HRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >>  @EID VARCHAR(5), @EmpID VARCHAR(5)
EXEC spDelEmp 'E0024', 'E0008'

-- Delete RoomType
SELECT * FROM Services.RoomType
CREATE PROC spDelRoomType @EID VARCHAR(5), @RTID VARCHAR(10)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'COO' OR IncumbencyID = 'MFMO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
	DECLARE @RTN VARCHAR(100)
	SELECT @RTN = RTypeName FROM Services.RoomType
	WHERE RTypeID = @RTID;
	DELETE Services.RoomType
	WHERE RTypeID = @RTID;
	PRINT 'Room Type ' + @RTID + ' [' + @RTN + ']' + ' successfully Deleted -'
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'COO' AND IncumbencyID != 'MFMO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >>  @EID VARCHAR(5), @RTID VARCHAR(10)
EXEC spDelRoomType 'E0016', 'R-II'

-- Delete Servant
SELECT * FROM Services.Servant
CREATE PROC spDelServ @EID VARCHAR(5), @EmpID VARCHAR(5)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MFMO' OR IncumbencyID = 'MHRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
	DECLARE @SN VARCHAR(30), @RTID VARCHAR(10)
	SELECT @SN = SerName FROM Services.Servant
	WHERE EmpID = @EmpID;
	SELECT @RTID = RTypeID FROM Services.Servant
	WHERE EmpID = @EmpID;
	DELETE Services.Servant
	WHERE EmpID = @EmpID;
	PRINT 'Servant Room Type ' + @RTID + ', ' + @EmpID + ' [' + @SN + ']' + ' successfully Deleted -'
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFMO' AND IncumbencyID != 'MHRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >>  @EID VARCHAR(5), @EmpID VARCHAR(5)
EXEC spDelServ 'E0016', 'E0060'

-- Delete RoomNum
SELECT * FROM vRoom
CREATE PROC spDelRoomNum @EID VARCHAR(5), @RN VARCHAR(5)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MFMO' OR IncumbencyID = 'FMO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
	DECLARE @RTID VARCHAR(10)
	SELECT @RTID = RTypeID FROM Services.RoomNum
	WHERE RoomNum = @RN;
	DELETE Services.RoomNum
	WHERE RoomNum = @RN;
	PRINT 'Room Num ' + @RN + ' [Room Type ' + @RTID + ']' + ' successfully Deleted -'
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFMO' AND IncumbencyID != 'FMO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >>  @EID VARCHAR(5), @RN VARCHAR(5)
EXEC spDelRoomNum 'E0016', 'RS302'


SELECT * FROM Services.RoomType
SELECT * FROM Services.RoomNum
SELECT * FROM Services.Servant
SELECT * FROM vRoom


/*
CREATE PROC spDelDiv @EID VARCHAR(5)
AS

CREATE PROC spDelDiv @EID VARCHAR(5), @DivID VARCHAR(10)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'CEO' OR IncumbencyID = 'CHRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
	--
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFMO' AND IncumbencyID != 'FMO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

EXEC spDelDiv
*/

/*
TRUNCATE TABLE HumanResources.Divisions
DBCC CHECKIDENT ('HumanResources.Divisions', RESEED, 1)
GO
*/
