/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

		--- TRUNCATE TABLE ---
TRUNCATE TABLE HumanResources.Divisions
TRUNCATE TABLE HumanResources.Incumbency
TRUNCATE TABLE HumanResources.Employee

TRUNCATE TABLE Services.RoomType
TRUNCATE TABLE Services.Servant
TRUNCATE TABLE Services.RoomNum

TRUNCATE TABLE Users.Customer
TRUNCATE TABLE Users.CustContact
TRUNCATE TABLE Users.CustAddress
TRUNCATE TABLE Users.CustAccount

TRUNCATE TABLE Transactions.MainTrans
TRUNCATE TABLE Transactions.TransHistory
TRUNCATE TABLE Transactions.CostRoom
TRUNCATE TABLE Transactions.Invoice



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

-- Delete Transactions
SELECT * FROM vMainTrans
SELECT * FROM vCustTrans
SELECT * FROM vCustBio
SELECT * FROM Transactions.Invoice

ALTER PROC spDelTrans @EID VARCHAR(5), @TransID VARCHAR(5)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MCSO' OR IncumbencyID = 'CSO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
	DECLARE @CustID VARCHAR(5), @Name VARCHAR(30), @RN VARCHAR(5)
	SELECT @CustID = CustID FROM Users.Customer
	WHERE CustID = (
						SELECT CustID FROM Transactions.MainTrans
						WHERE TransID = @TransID
					);
	SELECT @Name = CustName FROM Users.Customer
	WHERE CustName = (
						SELECT CustID FROM Transactions.MainTrans
						WHERE TransID = @TransID
					);
	SELECT @RN = RoomNum FROM Services.RoomNum
	WHERE RoomNum = (
						SELECT RoomNum FROM Transactions.MainTrans
						WHERE TransID = @TransID
					);
	DELETE Transactions.MainTrans
	WHERE TransID = @TransID;
	DELETE Transactions.CostRoom
	WHERE RoomNum = @RN	
	PRINT 'Transaction ' + @TransID + ' for booking room number ' + @RN + ' with user id ' + @CustID + ' [' + @Name + ']' + ' successfully Deleted -'
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MCSO' AND IncumbencyID != 'CSO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

EXEC spDelTrans 'E0030', 'T0002'

SELECT * FROM vMainTrans

DELETE Users.Customer
WHERE CustID = 'C2003'

DELETE Transactions.CostRoom
WHERE RoomNum = 'RJ206'

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
