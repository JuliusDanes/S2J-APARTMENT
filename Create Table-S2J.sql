/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
CREATE DATABASE S2J_ApartmentDB
SP_HELPDB S2J_ApartmentDB

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

		--- CREATE SCHEMA ---
CREATE SCHEMA HumanResources;
CREATE SCHEMA Services;
CREATE SCHEMA Users;
CREATE SCHEMA Transactions;
CREATE SCHEMA Log;

		--- CREATE TABLE ---
--Create Table Employee
CREATE TABLE HumanResources.Divisions(
	DivID	VARCHAR(10) CHECK(DivID NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') PRIMARY KEY NOT NULL,
	DivName	VARCHAR(30) NOT NULL,
	ChiefID VARCHAR(5)
);
SP_HELP 'HumanResources.Divisions'

ALTER TABLE HumanResources.Divisions
ADD CONSTRAINT fkChiefID FOREIGN KEY (ChiefID) REFERENCES HumanResources.Employee(EmpID) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE HumanResources.Incumbency(
	IncumbencyID	VARCHAR(10) CHECK(IncumbencyID NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') PRIMARY KEY NOT NULL,
	IncumbencyName	VARCHAR(100) NOT NULL,
	DivID			VARCHAR(10) FOREIGN KEY (DivID) REFERENCES HumanResources.Divisions(DivID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE HumanResources.Employee(
	ID				INT IDENTITY NOT NULL,
	EmpID			VARCHAR(5) DEFAULT 0 PRIMARY KEY NOT NULL,
	NIK				BIGINT CHECK(NIK BETWEEN 1000000000000000 AND 9999999999999999) UNIQUE NOT NULL,
	EmpName			VARCHAR(30) CHECK(EmpName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') UNIQUE NOT NULL,
	Gender			VARCHAR(10) CHECK(Gender IN('M', 'F')) NOT NULL,
	DateOfBirth		DATETIME CHECK(DateOfBirth < DATEADD(YEAR, -20, GETDATE()) AND DateOfBirth > DATEADD(YEAR, -56, GETDATE())) NOT NULL,
	Age				INT CHECK(Age > 0),
	MaritalStatus	VARCHAR(10) CHECK(MaritalStatus IN('M', 'S', 'Married', 'Single')) NOT NULL,
	IncumbencyID	VARCHAR(10) FOREIGN KEY (IncumbencyID) REFERENCES HumanResources.Incumbency(IncumbencyID) ON DELETE SET NULL ON UPDATE CASCADE,
	Salary			MONEY CHECK(Salary >= 1000000)
);

CREATE TABLE HumanResources.EmpContact(
	EmpID		VARCHAR(5) REFERENCES HumanResources.Employee(EmpID) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY NOT NULL,
	Telephone	BIGINT CHECK(Telephone BETWEEN 1000000 AND 999999999999) UNIQUE NOT NULL,
	EmaiL		VARCHAR(100) CHECK(Email LIKE '[A-Z]%@[A-Z]%.%')
);

CREATE TABLE HumanResources.EmpAddress(
	EmpID		VARCHAR(5) REFERENCES HumanResources.Employee(EmpID) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY NOT NULL,
	Address		VARCHAR(200) CHECK(Address NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	ZipCode		INT CHECK(ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]'),
	City		VARCHAR(30) CHECK(City NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	Province	VARCHAR(30) CHECK(Province NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%')
);

CREATE TABLE HumanResources.EmpAccount(
	EmpID		VARCHAR(5) REFERENCES HumanResources.Employee(EmpID) ON DELETE CASCADE ON UPDATE CASCADE UNIQUE NOT NULL,
	AccountNum	VARCHAR(19) CHECK(AccountNum LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') UNIQUE NOT NULL,
	AccountName	VARCHAR(30) CHECK(AccountName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	BankName	VARCHAR(30) CHECK(BankName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	PRIMARY KEY(EmpID, AccountNum)
);

--Create Table Services
CREATE TABLE Services.RoomType(	
	RTypeID			VARCHAR(10) CHECK(RTypeID LIKE 'R-[I,V,X]%') PRIMARY KEY NOT NULL,
	RTypeName		VARCHAR(100) UNIQUE NOT NULL,
	Price			MONEY CHECK(Price >= 10000000) NOT NULL,
	RoomAvailable	INT DEFAULT 10 CHECK(RoomAvailable >= 0 AND RoomAvailable = FLOOR(RoomAvailable)) NOT NULL,
	RoomIsUsed		INT DEFAULT 0 CHECK(RoomIsUsed >= 0 AND RoomIsUsed = FLOOR(RoomIsUsed)) NOT NULL
);

CREATE TABLE Services.Servant(
	ID				INT IDENTITY NOT NULL,
	SerName			VARCHAR(30) FOREIGN KEY (SerName) REFERENCES HumanResources.Employee(EmpName) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	EmpID			VARCHAR(5) REFERENCES HumanResources.Employee(EmpID) PRIMARY KEY NOT NULL,
	RTypeID			VARCHAR(10) FOREIGN KEY (RTypeID) REFERENCES Services.RoomType(RTypeID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	SerContact		INT CHECK(SerContact LIKE '9[0-9][0-9]') NOT NULL
);

CREATE TABLE Services.RoomNum(	
	RoomNum		VARCHAR(5) CHECK(RoomNum LIKE 'R[S,J][0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	Status		VARCHAR(10) DEFAULT 'Available' CHECK(Status IN('Available', 'Booked' ,'Occupied')) NOT NULL,
	RTypeID		VARCHAR(10) FOREIGN KEY (RTypeID) REFERENCES Services.RoomType(RTypeID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

--Create Table Customer
CREATE TABLE Users.Customer(
	ID				INT IDENTITY NOT NULL,
	CustID			VARCHAR(5) DEFAULT 0 PRIMARY KEY NOT NULL,
	NIK				BIGINT CHECK(NIK BETWEEN 1000000000000000 AND 9999999999999999) UNIQUE NOT NULL,
	CustName		VARCHAR(30) CHECK(CustName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	Gender			VARCHAR(10) CHECK(Gender IN('M', 'F')) NOT NULL,
	DateOfBirth		DATETIME CHECK(DateOfBirth <= DATEADD(YEAR, -18, GETDATE())) NOT NULL,
	Age				INT CHECK(Age > 0),
	Job				VARCHAR(30) CHECK(Job NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
);

CREATE TABLE Users.CustContact(
	CustID		VARCHAR(5) REFERENCES Users.Customer(CustID) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY NOT NULL,
	Telephone	BIGINT CHECK(Telephone BETWEEN 1000000 AND 999999999999) UNIQUE NOT NULL,
	EmaiL		VARCHAR(100) CHECK(Email LIKE '[A-Z]%@[A-Z]%.%')
);

CREATE TABLE Users.CustAddress(
	CustID		VARCHAR(5) REFERENCES Users.Customer(CustID) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY NOT NULL,
	Address		VARCHAR(200) CHECK(Address NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	ZipCode		INT CHECK(ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]'),
	City		VARCHAR(30) CHECK(City NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	Province	VARCHAR(30) CHECK(Province NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%')
);

CREATE TABLE Users.CustAccount(
	CustID		VARCHAR(5) REFERENCES Users.Customer(CustID) ON DELETE CASCADE ON UPDATE CASCADE UNIQUE NOT NULL,
	AccountNum	VARCHAR(19) CHECK(AccountNum LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') UNIQUE NOT NULL,
	AccountName	VARCHAR(30) CHECK(AccountName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	BankName	VARCHAR(30) CHECK(BankName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	PRIMARY KEY(CustID, AccountNum)
);

--Create Table Transactions
CREATE TABLE Transactions.MainTrans(	
	ID				INT IDENTITY NOT NULL,
	TransID			VARCHAR(5) DEFAULT 0 PRIMARY KEY NOT NULL,	
	CustID			VARCHAR(5) FOREIGN KEY (CustID) REFERENCES Users.Customer(CustID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	EmpID			VARCHAR(5) FOREIGN KEY (EmpID) REFERENCES HumanResources.Employee(EmpID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	RoomNum			VARCHAR(5) FOREIGN KEY (RoomNum) REFERENCES Services.RoomNum(RoomNum) ON DELETE CASCADE ON UPDATE CASCADE UNIQUE NOT NULL
);

CREATE TABLE Transactions.TransHistory(
	TransID			VARCHAR(5) REFERENCES Transactions.MainTrans(TransID) PRIMARY KEY NOT NULL,
	TransDate		DATETIME DEFAULT CONVERT(DATE, GETDATE()) NOT NULL,
	TransTime		DATETIME DEFAULT CONVERT(TIME, GETDATE()) UNIQUE NOT NULL,
	Status			VARCHAR(50) DEFAULT 'Waiting (Payment of Down Payment)' CHECK(Status IN ('Cancelled (Not Paid the Down Payment)', 'Cancelled (Not Paid the Repayment)', 'Waiting (Payment of Down Payment)', 'Waiting (Payment of Repayment)', 'Succeed (Paid Off)')) NOT NULL
);

CREATE TABLE Transactions.CostRoom(
	RoomNum			VARCHAR(5) REFERENCES Transactions.MainTrans(RoomNum) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY NOT NULL,
	PeriodOfTime	INT CONSTRAINT cPOT CHECK((PeriodOfTime BETWEEN 1 AND 50) AND PeriodOfTime = FLOOR(PeriodOfTime)) NOT NULL,
	DateOfCheckIn	DATETIME DEFAULT CONVERT(DATE, GETDATE()) CONSTRAINT cIN CHECK(DateOfCheckIn >= CONVERT(DATE, GETDATE()) 
					AND DateOfCheckIn <= DATEADD(DAY, 7, CONVERT(DATE, GETDATE()))) NOT NULL,
	DateOfCheckOut	DATETIME DEFAULT DATEADD(YEAR, 1, CONVERT(DATE, GETDATE())) CONSTRAINT cOUT CHECK(DateOfCheckOut >= DATEADD(YEAR, 1, CONVERT(DATE, GETDATE()))) NOT NULL,
	TotalCost		MONEY CONSTRAINT cTC CHECK(TotalCost >= 0) NOT NULL
);

CREATE TABLE Transactions.Invoice(
	TransID			VARCHAR(5) REFERENCES Transactions.MainTrans(TransID) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY NOT NULL,
	AccountNum		VARCHAR(19) FOREIGN KEY (AccountNum) REFERENCES Users.CustAccount(AccountNum) NOT NULL,
	TotalInvoice	MONEY CHECK(TotalInvoice >= 0) NOT NULL,
	DP				MONEY CHECK(DP >= 0) NOT NULL,
	DueDateDP		DATETIME DEFAULT DATEADD(DAY, 2, CONVERT(DATE, GETDATE())) CHECK(DueDateDP <= DATEADD(DAY, 2, CONVERT(DATE, GETDATE()))) NOT NULL,	
	DPStatus		VARCHAR(10) DEFAULT 'Unpaid' CHECK(DPStatus IN('Paid', 'Unpaid')) NOT NULL,
	Repayment		MONEY CHECK(Repayment >= 0) NOT NULL,
	DueDateRePay	DATETIME DEFAULT CONVERT(DATE, GETDATE()) CHECK(DueDateRePay >= CONVERT(DATE, GETDATE()) 
					AND DueDateRePay <= DATEADD(DAY, 7, CONVERT(DATE, GETDATE()))) NOT NULL,
	RePayStatus		VARCHAR(10) DEFAULT 'Unpaid' CHECK(RePayStatus IN('Paid', 'Unpaid')) NOT NULL,
	AlreadyPaid		MONEY DEFAULT 0 CHECK(AlreadyPaid >= 0) NOT NULL,
	Unpaid			MONEY CHECK(Unpaid >= 0) NOT NULL
);

CREATE TABLE Log.Customer(
	ID				INT IDENTITY NOT NULL,
	LogCID			VARCHAR(7) DEFAULT 0 UNIQUE NOT NULL,
	CustID			VARCHAR(5) DEFAULT 0 UNIQUE,
	NIK				BIGINT CHECK(NIK BETWEEN 1000000000000000 AND 9999999999999999) UNIQUE NOT NULL,
	CustName		VARCHAR(30) CHECK(CustName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	Gender			VARCHAR(10) CHECK(Gender IN('M', 'F')) NOT NULL,
	DateOfBirth		DATETIME CHECK(DateOfBirth <= DATEADD(YEAR, -18, GETDATE())) NOT NULL,
	Age				INT CHECK(Age > 0),
	Job				VARCHAR(30) CHECK(Job NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	Telephone		BIGINT CHECK(Telephone BETWEEN 1000000 AND 999999999999) UNIQUE NOT NULL,
	EmaiL			VARCHAR(100) CHECK(Email LIKE '[A-Z]%@[A-Z]%.%'),
	Address			VARCHAR(200) CHECK(Address NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	ZipCode			INT CHECK(ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]'),
	City			VARCHAR(30) CHECK(City NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	Province		VARCHAR(30) CHECK(Province NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%'),
	AccountNum		VARCHAR(19) CHECK(AccountNum LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') UNIQUE NOT NULL,
	AccountName		VARCHAR(30) CHECK(AccountName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	BankName		VARCHAR(30) CHECK(BankName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	PRIMARY KEY(LogCID, CustID, NIK, AccountNum)
);

CREATE TABLE Log.Transactions(
	ID				INT IDENTITY NOT NULL,
	LogTID			VARCHAR(7) DEFAULT 0 UNIQUE NOT NULL,
	TransID			VARCHAR(5) DEFAULT 0 UNIQUE NOT NULL,	
	CustID			VARCHAR(5) FOREIGN KEY (CustID) REFERENCES Log.Customer(CustID) ON DELETE CASCADE ON UPDATE CASCADE,
	EmpID			VARCHAR(5) CHECK(EmpID LIKE 'E[0-9][0-9][0-9][0-9]') NOT NULL,
	RoomNum			VARCHAR(5) CHECK(RoomNum LIKE 'R[S,J][0-9][0-9][0-9]') NOT NULL,	
	RTypeID			VARCHAR(10) CHECK(RTypeID LIKE 'R-[I,V,X]%') NOT NULL,
	RTypeName		VARCHAR(100) NOT NULL,
	Price			MONEY CHECK(Price >= 10000000) NOT NULL,
	TransDate		DATETIME NOT NULL,
	TransTime		DATETIME UNIQUE NOT NULL,
	Status			VARCHAR(50) CHECK(Status IN ('Cancelled (Not Paid the Down Payment)', 'Cancelled (Not Paid the Repayment)', 'Succeed (Paid Off)')) NOT NULL,
	PeriodOfTime	INT CONSTRAINT cPOT CHECK((PeriodOfTime BETWEEN 1 AND 50) AND PeriodOfTime = FLOOR(PeriodOfTime)) NOT NULL,
	DateOfCheckIn	DATETIME NOT NULL,
	DateOfCheckOut	DATETIME NOT NULL,
	TotalCost		MONEY CONSTRAINT cTC CHECK(TotalCost >= 0) NOT NULL,
	AccountNum		VARCHAR(19) FOREIGN KEY (AccountNum) REFERENCES Log.Customer(AccountNum) NOT NULL,
	TotalInvoice	MONEY CHECK(TotalInvoice >= 0) NOT NULL,
	DP				MONEY CHECK(DP >= 0) NOT NULL,
	DueDateDP		DATETIME NOT NULL,	
	DPStatus		VARCHAR(10) DEFAULT 'Unpaid' CHECK(DPStatus IN('Paid', 'Unpaid')) NOT NULL,
	Repayment		MONEY CHECK(Repayment >= 0) NOT NULL,
	DueDateRePay	DATETIME NOT NULL,
	RePayStatus		VARCHAR(10) DEFAULT 'Unpaid' CHECK(RePayStatus IN('Paid', 'Unpaid')) NOT NULL,
	AlreadyPaid		MONEY DEFAULT 0 CHECK(AlreadyPaid >= 0) NOT NULL,
	Unpaid			MONEY CHECK(Unpaid >= 0) NOT NULL
	PRIMARY KEY(LogTID, TransID)
);


		--- SELECT TABLE ---
SELECT * FROM HumanResources.Divisions
SELECT * FROM HumanResources.Incumbency
SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmpContact
SELECT * FROM HumanResources.EmpAddress
SELECT * FROM HumanResources.EmpAccount

SELECT * FROM Services.RoomType
SELECT * FROM Services.Servant
SELECT * FROM Services.RoomNum

SELECT * FROM Users.Customer
SELECT * FROM Users.CustContact
SELECT * FROM Users.CustAddress
SELECT * FROM Users.CustAccount

SELECT * FROM Transactions.MainTrans
SELECT * FROM Transactions.TransHistory
SELECT * FROM Transactions.CostRoom
SELECT * FROM Transactions.Invoice

SELECT * FROM Log.Customer
SELECT * FROM Log.Transactions


		--- DROP TABLE ---
DROP TABLE Transactions.Invoice;
DROP TABLE Transactions.CostRoom;
DROP TABLE Transactions.TransHistory;
DROP TABLE Transactions.MainTrans;
DROP TABLE Users.CustAccount;
DROP TABLE Users.CustAddress;
DROP TABLE Users.CustContact;
DROP TABLE Users.Customer;
DROP TABLE Services.RoomNum;
DROP TABLE Services.Servant;
DROP TABLE Services.RoomType;
DROP TABLE Log.Transactions;
DROP TABLE Log.Customer;
DROP TABLE HumanResources.EmpAccount;
DROP TABLE HumanResources.EmpAddress;
DROP TABLE HumanResources.EmpContact;
DROP TABLE HumanResources.Employee;
DROP TABLE HumanResources.Incumbency;
DROP TABLE HumanResources.Divisions;


		--- BACKUP & RESTORE DATABASE ---
SELECT * INTO BackupIncDiv FROM vIncDiv
SELECT * INTO BackupEmp FROM vEmployee
SELECT * INTO BackupRoom FROM vRoom
SELECT * INTO BackupCust FROM vCustData
SELECT * INTO BackupTrans FROM vMainTrans

BACKUP DATABASE S2J_ApartmentDB
TO  DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLSERVER14\MSSQL\Backup\S2J_ApartmentDB.BAK',
	DISK = 'D:\S2J_ApartmentDB.BAK'
WITH STATS = 25, FORMAT,
      NAME = 'Full Backup of S2J_ApartmentDB';
GO

RESTORE DATABASE S2J_ApartmentDB   
   FROM DISK = 'D:\S2J_ApartmentDB.BAK';
GO  
