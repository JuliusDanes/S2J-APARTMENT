	--- S2J Apartment ---
--- CREATE DATABASE
CREATE DATABASE qwertyDB
SP_HELPDB qwertyDB

--- USE DATBASE
USE DATABASE qwertyDB
GO

--- CREATE SCHEMA
CREATE SCHEMA HumanResources
CREATE SCHEMA Services
CREATE SCHEMA Users
CREATE SCHEMA Transactions

--- CREATE TABLE
CREATE TABLE HumanResources.Divisions(
	ID		INT IDENTITY NOT NULL,
	DivID	VARCHAR(5) PRIMARY KEY,
	DivName	VARCHAR(30) CHECK(DivName LIKE '(0-9)') NOT NULL,
	ChiefID VARCHAR(5) UNIQUE
);

ALTER TABLE HumanResources.Divisions
ADD CONSTRAINT fkChiefID FOREIGN KEY HumanResources.Employee(DivID);

CREATE TABLE HumanResources.Employee(
	ID				INT IDENTITY NOT NULL,
	EmpID			VARCHAR(5) PRIMARY KEY,
	NIK				BIGINT CHECK(NIK BETWEEN 1000000000000000 AND 9999999999999999) NOT NULL,
	DivName			VARCHAR(30) CHECK(DivName NOT LIKE '%[!~`@#$%^&*()_+-={}:<>?\;'',/(0-9)]%') NOT NULL,
	Gender			VARCHAR(10) CHECK(Gender IN('M', 'F')) NOT NULL,
	DateOfBirth		DATETIME CHECK(DateOfBirth < DATEADD(YEAR, -20, GETDATE())) NOT NULL,
	Age				INT,
	MaritalStatus	VARCHAR(10) CHECK(MaritalStatus IN('M', 'S')),
	DivID			VARCHAR(5) FOREIGN KEY (DivID) REFERENCES HumanResources.Divisions(DivID),
);

CREATE TABLE HumanResources.EmpContact(
	EmpID		VARCHAR(5) REFERENCES HumanResources.Employee(EmpID) PRIMARY KEY NOT NULL,
	Telephone	BIGINT CHECK(Telephone BETWEEN 1000000 AND 999999999999) NOT NULL,
	EmaiL		VARCHAR(100) CHECK(Email LIKE '[A-Z]%@[A-Z]%.%')
);

CREATE TABLE HumanResources.EmpAddress(
	EmpID		VARCHAR(5) REFERENCES HumanResources.Employee(EmpID) PRIMARY KEY NOT NULL,
	Address		VARCHAR(200) CHECK(DivName NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	ZipCode		INT CHECK(ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]'),
	City		VARCHAR(30) CHECK(DivName NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%') NOT NULL,
	Province	VARCHAR(30) CHECK(DivName NOT LIKE '%[!~`@#$%^&*_+={}:<>?;'']%')
);
