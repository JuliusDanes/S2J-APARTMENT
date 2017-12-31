/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

		--- UPDATE RECORD ---
--Update Employee
SELECT * FROM vEmployee
CREATE PROC spUpEmp @EID VARCHAR(5), @EmpID VARCHAR(5), @IncID VARCHAR(10), @Add VARCHAR(200), @ZC INT, @City VARCHAR(30), @Prov VARCHAR(30)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MHRO' OR IncumbencyID = 'HRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		UPDATE HumanResources.Employee
		SET IncumbencyID = @IncID
		WHERE EmpID = @EmpID
		UPDATE HumanResources.EmpAddress
		SET Address = @Add,
			ZipCode = @ZC,
			City = @City,
			Province = @Prov
		WHERE EmpID = @EmpID
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MHRO' AND IncumbencyID != 'HRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @EmpID VARCHAR(5), @IncID VARCHAR(10), @Add VARCHAR(200), @ZC INT, @City VARCHAR(30), @Prov VARCHAR(30)
EXEC spUpEmp 'E0024', 'E0033', 'OO', 'Jl Ganesha No 10', 17865, 'Bandung', 'Jawa Barat'


--Update Room Type
SELECT * FROM Services.RoomType
CREATE PROC spUpRoomType @EID VARCHAR(5), @RTID VARCHAR(10), @RTN VARCHAR(100), @Price MONEY
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'COO' OR IncumbencyID = 'MFMO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		UPDATE Services.RoomType
		SET RTypeName = @RTN,
			Price = @Price
		WHERE RTypeID = @RTID
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'COO' AND IncumbencyID != 'MFMO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @RTID VARCHAR(10), @RTN VARCHAR(100), @Price MONEY
EXEC spUpRoomType 'E0005', 'R-III', 'Sunset Mozaik', 145000000


--Update Customer Data (Name & Account Number)
SELECT * FROM vCustData
ALTER PROC spUpCust @EID VARCHAR(5), @CustID VARCHAR(5), @CustName VARCHAR(30), @Email VARCHAR(100)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MDCO' OR IncumbencyID = 'DCO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		UPDATE Users.Customer
		SET CustName = @CustName
		WHERE CustID = @CustID
		UPDATE Users.CustContact
		SET EmaiL = @Email
		WHERE CustID = @CustID
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MDCO' AND IncumbencyID != 'DCO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @CustID VARCHAR(5), @CustName VARCHAR(30), @Email VARCHAR(100)
EXEC spUpCust 'E0034', 'C0001', 'Johanes Chondro', 'johanes.chondro@geevv.co.id'


--Update Transaction Room
SELECT * FROM vMainTrans
SELECT * FROM vReceipt
ALTER PROC spUpTransRoom @EID VARCHAR(5), @TransID VARCHAR(5), @RNI VARCHAR(5), @POTI INT
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MCSO' OR IncumbencyID = 'MFMO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		DECLARE @RND VARCHAR(5), @DCIND DATETIME, @DCOUTI DATETIME, @TC MONEY, @Price MONEY, @DP MONEY, @RP MONEY, @AP MONEY, @UP MONEY		
		SELECT @RND = RoomNum FROM Transactions.MainTrans
		WHERE TransID = @TransID
		SELECT @AP = AlreadyPaid FROM Transactions.Invoice
		WHERE TransID = @TransID
		SELECT @DCIND = DateOfCheckIn FROM Transactions.CostRoom
		WHERE RoomNum = @RND
		SET @DCOUTI = DATEADD(YEAR, @POTI, CONVERT(DATE, @DCIND))
		SELECT @Price = Price FROM Services.RoomType
		WHERE RTypeID = (
							SELECT T.RTypeID FROM Services.RoomType T
							INNER JOIN Services.RoomNum N
							ON T.RTypeID = N.RTypeID
							WHERE N.RoomNum = @RNI
						)
		SET @TC = @Price * @POTI --Total Cost/Invoice

		SET @DP = @TC * 0.1  --DP = 10% Total Cost
		SET @RP = @TC * 0.9  --Repayment = 90% Total Cost
		SET @UP	= @TC - @AP  --Check Transfer
		
		UPDATE Transactions.MainTrans
		SET RoomNum = @RNI
		WHERE TransID = @TransID
		UPDATE Transactions.CostRoom
		SET RoomNum = @RNI,
			PeriodOfTime = @POTI,
			DateOfCheckOut = @DCOUTI,
			TotalCost = @TC
		WHERE RoomNum = @RNI
		UPDATE Transactions.Invoice
		SET TotalInvoice = @TC,
			DP = @DP,
			Repayment = @RP,
			Unpaid = @UP
		WHERE TransID = @TransID
		UPDATE Transactions.Invoice
		SET DPStatus = (CASE
							WHEN (@AP >= DP) THEN 'Paid'
							WHEN (@AP < DP) THEN 'Unpaid'
						END),
			RePayStatus = (CASE
							WHEN (@AP >= TotalInvoice) THEN 'Paid'
							WHEN (@AP < TotalInvoice) THEN 'Unpaid'
						END)
		WHERE TransID = @TransID
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFO' AND IncumbencyID != 'FO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @@EID VARCHAR(5), @TransID VARCHAR(5), @RNI VARCHAR(5), @POTI INT
EXEC spUpTransRoom 'E0016', 'T0003', 'RJ101', 2


--Update Transaction Invoice
SELECT * FROM Transactions.Invoice
ALTER PROC spUpInv @EID VARCHAR(5), @TransID VARCHAR(5), @AP MONEY
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MFO' OR IncumbencyID = 'FO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		DECLARE @UP MONEY
		UPDATE Transactions.Invoice
		SET AlreadyPaid = @AP,
			Unpaid = TotalInvoice - @AP,
			DPStatus = (CASE
							WHEN (@AP >= DP) THEN 'Paid'
							WHEN (@AP < DP) THEN 'Unpaid'
						END),
			RePayStatus = (CASE
							WHEN (@AP >= TotalInvoice) THEN 'Paid'
							WHEN (@AP < TotalInvoice) THEN 'Unpaid'
						END)
		WHERE TransID = @TransID
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFO' AND IncumbencyID != 'FO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @AP MONEY
EXEC spUpInv 'E0021', 'T0001', 120000000
EXEC spUpInv 'E0021', 'T0003', 36000000
EXEC spUpInv 'E0021', 'T0005', 600000000
EXEC spUpInv 'E0021', 'T0007', 72000000
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              