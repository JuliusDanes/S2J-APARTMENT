/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

		--- UPDATE RECORD ---
--Update Employee
SELECT * FROM vEmployee
ALTER PROC spUpEmp @EID VARCHAR(5), @EmpID VARCHAR(5), @IncID VARCHAR(10), @Add VARCHAR(200), @ZC INT, @City VARCHAR(30), @Prov VARCHAR(30)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MHRO' OR IncumbencyID = 'HRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		DECLARE @Name VARCHAR(30)
		SELECT @Name = EmpName FROM HumanResources.Employee
		WHERE EmpID = @EmpID
		UPDATE HumanResources.Employee
		SET IncumbencyID = @IncID
		WHERE EmpID = @EmpID
		UPDATE HumanResources.EmpAddress
		SET Address = @Add,
			ZipCode = @ZC,
			City = @City,
			Province = @Prov
		WHERE EmpID = @EmpID
		PRINT 'Employee ' + @EmpID + ' [' + @Name + ']' + ' successfully Updated *';
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
ALTER PROC spUpRoomType @EID VARCHAR(5), @RTID VARCHAR(10), @RTN VARCHAR(100), @Price MONEY
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
		PRINT 'Room Type ' + @RTID + ' [' + @RTN + ']' + ' successfully Updated *';
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
ALTER PROC spUpCust @EID VARCHAR(5), @CustID VARCHAR(5), @CustName VARCHAR(30), @AccNum VARCHAR(19)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MDCO' OR IncumbencyID = 'DCO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		UPDATE Users.Customer
		SET CustName = @CustName
		WHERE CustID = @CustID
		UPDATE Users.CustAccount
		SET AccountNum = @AccNum
		WHERE CustID = @CustID
		PRINT 'Customer ID ' + @CustID + ' [' + @CustName + ']' + ' successfully Update *';
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MDCO' AND IncumbencyID != 'DCO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @CustID VARCHAR(5), @CustName VARCHAR(30), @Email VARCHAR(100)
EXEC spUpCust 'E0034', 'C0001', 'Johanes Chondro', '1650-1780-1605-2018'


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
		IF (@DCIND >= CONVERT(DATE, GETDATE()))
		BEGIN
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
			PRINT 'Your room has been changed to ' + @RND + ', from the previous room ' + @RNI;
		END
		ELSE
			PRINT 'Can not change rooms anymore!';
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
		DECLARE @UP MONEY, @CustID VARCHAR(5), @AccName VARCHAR(30), @AccNum VARCHAR(19), @DP MONEY, @DPDue DATETIME, @RePay MONEY, @RePayDue DATETIME, @Now DATETIME
		SELECT @CustID = CustID, @AccName = AccountName, @AccNum = AccountNum, @DP = DP, @DPDue = DueDateDP, @RePay = Repayment, @RePayDue = DueDateRePay FROM vMainTrans
		WHERE TransID = @TransID
		SET @Now = CONVERT(DATE, GETDATE())
		IF (((@AP = @DP AND @DPDue <= @Now) OR (@AP = @RePay AND @RePayDue <= @Now)))
		BEGIN
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
			PRINT 'Transaction bill ' + @TransID + ' on behalf of ' + @AccName + ' [' + @CustID + ']' + ' with account number ' + @AccNum + ' successfully Updated *';
		END
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFO' AND IncumbencyID != 'FO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @AP MONEY
EXEC spUpInv 'E0021', 'T0001', 160000000
EXEC spUpInv 'E0021', 'T0003', 36000000
EXEC spUpInv 'E0021', 'T0005', 600000000
EXEC spUpInv 'E0021', 'T0007', 72000000
EXEC spUpInv 'E0021', 'T0009', 15000000
                                       

--Update Check Invoice Down Payment (DP) Due Date
SELECT * FROM vMainTrans
SELECT TransID, Status, DueDateDP, DPStatus, DueDateRePay, RePayStatus FROM vMainTrans
WHERE Status LIKE '%Waiting%' AND DPStatus = 'Unpaid' AND RePayStatus = 'Unpaid' AND DueDateDP < CONVERT(DATE, GETDATE())
ALTER PROC spUpChkDPDue @EID VARCHAR(5)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MFO' OR IncumbencyID = 'FO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
	DECLARE @Count INT, @Until INT, @TransID varchar(5), @DPS VARCHAR(10), @RPS VARCHAR(10), @DPDue DATETIME, @CustID VARCHAR(5), @NIK BIGINT, @Name VARCHAR(30), @RN VARCHAR(5)
	SET @Count = 1
	SELECT @Until = MAX(ID) FROM Transactions.MainTrans

	WHILE @Count <= @Until
	BEGIN
		SELECT @TransID = TransID FROM Transactions.MainTrans
		WHERE ID = @Count
		SELECT @DPS = DPStatus, @RPS = RePayStatus, @DPDue = DueDateDP, @CustID = CustID, @Name = CustName, @RN = RoomNum FROM vMainTrans
		WHERE TransID = @TransID

		IF (@DPS = 'Unpaid' AND @RPS = 'Unpaid' AND @DPDue < CONVERT(DATE, GETDATE()))
		BEGIN
			UPDATE Transactions.TransHistory
			SET Status = 'Cancelled (Not Paid the Down Payment)'
			WHERE TransID = @TransID			
			DELETE Transactions.TransHistory
			WHERE TransID = @TransID;

			IF (@TransID = (SELECT TransID FROM Transactions.MainTrans
							WHERE CustID = @CustID))
			BEGIN
				DELETE Users.Customer
				WHERE CustID = @CustID
				PRINT 'The ' + @TransID + ' transaction for ' + @RN + ' room number booking on behalf of ' + @CustID + ' [' + @Name + ']' + ' was Canceled because the payment of Down Payment (DP) was past due date [' + CAST(@DPDue AS VARCHAR(10)) + '] -';
			END
			ELSE
			BEGIN
				PRINT 'The ' + @TransID + ' transaction for ' + @RN + ' room number booking on behalf of ' + @CustID + ' [' + @Name + ']' + ' was Canceled because the payment of Down Payment (DP) was past due date [' + CAST(@DPDue AS VARCHAR(10)) + '], -';
				PRINT 'but for the Customer Data ' + @CustID + ' [' + @Name + ']' + ' persists because it has more than one transaction *';
			END						
			DELETE Transactions.MainTrans
			WHERE TransID = @TransID;
			DELETE Transactions.CostRoom
			WHERE RoomNum = @RN;
		END
		SET @Count += 1
	END	
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFO' AND IncumbencyID != 'FO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5)
EXEC spUpChkDPDue 'E0020'


--Update Check Invoice Repayment Due Date
SELECT * FROM vMainTrans
SELECT TransID, Status, DueDateDP, DPStatus, DueDateRePay, RePayStatus FROM vMainTrans
WHERE Status LIKE '%Waiting%' AND DPStatus = 'Paid' AND RePayStatus = 'Unpaid' AND DueDateDP < CONVERT(DATE, GETDATE())
ALTER PROC spUpChkRePayDue @EID VARCHAR(5)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MFO' OR IncumbencyID = 'FO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
	DECLARE @Count INT, @Until INT, @TransID varchar(5), @DPS VARCHAR(10), @RPS VARCHAR(10), @RPDue DATETIME, @CustID VARCHAR(5), @Name VARCHAR(30), @RN VARCHAR(5)
	SET @Count = 1
	SELECT @Until = MAX(ID) FROM Transactions.MainTrans

	WHILE @Count <= @Until
	BEGIN
		SELECT @TransID = TransID FROM Transactions.MainTrans
		WHERE ID = @Count
		SELECT @DPS = DPStatus, @RPS = RePayStatus, @RPDue = DueDateRePay, @CustID = CustID, @Name = CustName, @RN = RoomNum FROM vMainTrans
		WHERE TransID = @TransID

		IF (@DPS = 'Paid' AND @RPS = 'Unpaid' AND @RPDue < CONVERT(DATE, GETDATE()))
		BEGIN		
			UPDATE Transactions.TransHistory
			SET Status = 'Cancelled (Not Paid the Repayment)'
			WHERE TransID = @TransID		
			DELETE Transactions.TransHistory
			WHERE TransID = @TransID;		

			IF (@TransID = (SELECT TransID FROM Transactions.MainTrans
							WHERE CustID = @CustID))
			BEGIN
				DELETE Users.Customer
				WHERE CustID = @CustID
				PRINT 'The ' + @TransID + ' transaction for ' + @RN + ' room number booking on behalf of ' + @CustID + ' [' + @Name + ']' + ' was Canceled because the payment of Repayment was past due date [' + CAST(@RPDue AS VARCHAR(10)) + '] -';
			END
			ELSE
			BEGIN
				PRINT 'The ' + @TransID + ' transaction for ' + @RN + ' room number booking on behalf of ' + @CustID + ' [' + @Name + ']' + ' was Canceled because the payment of Repayment was past due date [' + CAST(@RPDue AS VARCHAR(10)) + '], -';
				PRINT 'but for the Customer Data ' + @CustID + ' [' + @Name + ']' + ' persists because it has more than one transaction *';
			END			
			DELETE Transactions.MainTrans
			WHERE TransID = @TransID
			DELETE Transactions.CostRoom
			WHERE RoomNum = @RN;
		END
		SET @Count += 1
	END	
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFO' AND IncumbencyID != 'FO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5)
EXEC spUpChkRePayDue 'E0020'
