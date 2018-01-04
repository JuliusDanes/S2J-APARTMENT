/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

		--- TRIGGER ---
-- Trigger Delete Transaction
CREATE TRIGGER Transactions.trgDelTrans
ON Transactions.TransHistory
INSTEAD OF UPDATE AS
IF UPDATE (Status)
BEGIN
	IF((SELECT Status FROM INSERTED) = 'Cancelled (Not Paid the Down Payment)' OR (SELECT Status FROM INSERTED) = 'Cancelled (Not Paid the Repayment)')
	BEGIN
	PRINT 'FALSE'
 	UPDATE Services.RoomType
 	SET RoomAvailable = RoomAvailable + 1,
 		RoomIsUsed = RoomIsUsed - 1
 	WHERE RTypeID = (SELECT RTypeID FROM vMainTrans
 						WHERE TransID = (SELECT TransID FROM INSERTED))
 	UPDATE Services.RoomNum
 	SET Status = 'Available'
 	WHERE RoomNum = (SELECT RoomNum FROM vMainTrans
 						WHERE TransID = (SELECT TransID FROM INSERTED))
	
	DECLARE @CountC INT, @LogCID VARCHAR(7), @CustID VARCHAR(5), @NIK BIGINT, @CustName VARCHAR(30), @Gender VARCHAR(10), @DOB DATETIME, @Age INT, @Job VARCHAR(30),
						@Telp BIGINT, @Email VARCHAR(100), @Add VARCHAR(200), @ZC INT, @City VARCHAR(30), @Prov VARCHAR(30), @AccNum VARCHAR(19), @AccName VARCHAR(30), @BName VARCHAR(30),
			@CountT INT, @LogTID VARCHAR(7), @TransID VARCHAR(5), @EmpID VARCHAR(5), @RN VARCHAR(5), @RTID VARCHAR(5), @RTN VARCHAR(50), @Price MONEY, @TDate DATETIME, @TTime DATETIME, @Status VARCHAR(50), 
						@POT INT, @DCIN DATETIME, @DCOUT DATETIME, @TotCost MONEY, @TotInv MONEY, @DP MONEY, @DPDue DATETIME, @DPS VARCHAR(10), @RePay MONEY, @RePayDue DATETIME, @RPS VARCHAR(10), @AP MONEY, @UP MONEY
	
	SELECT @TransID = TransID, @TDate = TransDate, @TTime = TransTime, @RN = RoomNum, @RTID = RTypeID, @RTN = RTypeName, @Price = Price, @DCIN = DateOfCheckIn, @DCOUT = DateOfCheckOut, @POT = PeriodOfTime, @TotCost = TotalCost, 
			@TotInv = TotalInvoice, @DP = DP, @DPDue = DueDateDP, @DPS = DPStatus, @RePay = Repayment, @RePayDue = DueDateRePay, @RPS = RePayStatus, @AP = AlreadyPaid, @UP = Unpaid, @EmpID = EmpID,
			@CustID = CustID, @NIK = NIK, @CustName = CustName, @Gender = Gender, @DOB = DateOfBirth, @Age = Age, @Job = Job, @Telp = Telephone, @Email = EmaiL, @Add = Address, @ZC = ZipCode, @City = City, @Prov = Province, 
			@AccNum = AccountNum, @AccName = AccountName, @BName = BankName FROM vMainTrans
	WHERE TransID = (SELECT TransID FROM INSERTED)
	SELECT @Status = Status FROM INSERTED
	PRINT @Status

	INSERT Log.Customer(CustID, NIK, CustName, Gender, DateOfBirth, Age, Job, Telephone, EmaiL, Address, ZipCode, City, Province, AccountNum, AccountName, BankName)
		VALUES(@CustID, @NIK, @CustName, @Gender, @DOB, @Age, @Job, @Telp, @Email, @Add, @ZC, @City, @Prov, @AccNum, @AccName, @BName);
	INSERT Log.Transactions(TransID, CustID, EmpID, RoomNum, RTypeID, RTypeName, Price, TransDate, TransTime, Status, PeriodOfTime, DateOfCheckIn, DateOfCheckOut, TotalCost, AccountNum, TotalInvoice, DP, DueDateDP, DPStatus, Repayment, DueDateRePay, RePayStatus, AlreadyPaid, Unpaid)
		VALUES(@TransID, @CustID, @EmpID, @RN, @RTID, @RTN, @Price, @TDate, @TTime, @Status, @POT, @DCIN, @DCOUT, @TotCost, @AccNum, @TotInv, @DP, @DPDue, @DPS, @RePay, @RePayDue, @RPS, @AP, @UP);

	SELECT @CountC = ID FROM Log.Customer
	WHERE LogCID = '0'
	SET @LogCID = (
		CASE
			WHEN (@CountC < 10) THEN 'LOG000'
			WHEN (@CountC >= 10) AND (@CountC < 100) THEN 'LOG00'
			WHEN (@CountC >= 100) AND (@CountC < 1000) THEN 'LOG0'
			WHEN (@CountC >= 1000) AND (@CountC < 10000) THEN 'LOG'
		END
		)
	SET @LogCID = @LogCID + CAST(@CountC AS VARCHAR(5))
	UPDATE Log.Customer
	SET LogCID = @LogCID
	WHERE LogCID = '0'
	
	SELECT @CountT = ID FROM Log.Transactions
	WHERE LogTID = '0'
	SET @LogTID = (
		CASE
			WHEN (@CountT < 10) THEN 'LOG000'
			WHEN (@CountT >= 10) AND (@CountT < 100) THEN 'LOG00'
			WHEN (@CountT >= 100) AND (@CountT < 1000) THEN 'LOG0'
			WHEN (@CountT >= 1000) AND (@CountT < 10000) THEN 'LOG'
		END
		)
	SET @LogTID = @LogTID + CAST(@CountT AS VARCHAR(7))
	UPDATE Log.Transactions
	SET LogTID = @LogTID
	WHERE LogTID = '0'
	END
END
GO


-- Trigger Insert Transaction
CREATE TRIGGER Transactions.trgInsTrans
ON Transactions.MainTrans
FOR INSERT AS
	UPDATE Services.RoomType
	SET RoomAvailable = RoomAvailable - 1,
		RoomIsUsed = RoomIsUsed + 1
	WHERE RTypeID = (
					SELECT RTypeID FROM vRoom
					WHERE RoomNum = (SELECT RoomNum FROM INSERTED)
					)
	UPDATE Services.RoomNum
	SET Status = 'Booked'
	WHERE RoomNum = (SELECT RoomNum FROM INSERTED)
GO



-- Trigger Update Transaction Room
CREATE TRIGGER Transactions.trgUpTransRoom
ON Transactions.MainTrans 
AFTER UPDATE AS
IF UPDATE (RoomNum)
BEGIN
	UPDATE Services.RoomType
	SET RoomAvailable = RoomAvailable + 1,
		RoomIsUsed = RoomIsUsed - 1
	WHERE RTypeID = (
					SELECT RTypeID FROM vRoom
					WHERE RoomNum = (SELECT RoomNum FROM DELETED)
					)
	UPDATE Services.RoomNum
	SET Status = 'Available'
	WHERE RoomNum = (SELECT RoomNum FROM DELETED)
	
	UPDATE Services.RoomType
	SET RoomAvailable = RoomAvailable - 1,
		RoomIsUsed = RoomIsUsed + 1
	WHERE RTypeID = (
					SELECT RTypeID FROM vRoom
					WHERE RoomNum = (SELECT RoomNum FROM INSERTED)
					)
	UPDATE Services.RoomNum
	SET Status = 'Booked'
	WHERE RoomNum = (SELECT RoomNum FROM INSERTED)	
END
GO


-- Trigger Update Invoice
CREATE TRIGGER Transactions.trgUpInvoice
ON Transactions.Invoice
FOR UPDATE AS
IF UPDATE (DPStatus) OR UPDATE (RePayStatus)
BEGIN
	DECLARE @TransID VARCHAR(5), @DPS VARCHAR(10), @RPS VARCHAR(10)	
	SELECT @TransID = TransID FROM INSERTED
	SELECT @DPS = DPStatus FROM INSERTED
	SELECT @RPS = RePayStatus FROM INSERTED
	IF @DPS = 'Paid'	
		BEGIN
			UPDATE Transactions.TransHistory
			SET Status = 'Waiting (Payment of Repayment)'
			WHERE TransID = @TransID
			PRINT 'Payment transaction of down payment is successful.'
			UPDATE Services.RoomNum
			SET Status = 'Occupied'
			WHERE RoomNum = (SELECT RoomNum FROM Transactions.MainTrans
								WHERE TransID = @TransID);
			IF @RPS = 'Paid'
				BEGIN					
					UPDATE Transactions.TransHistory
					SET Status = 'Succeed (Paid Off)'					
					WHERE TransID = @TransID					
					PRINT 'Payment transaction of repayment is successful.'
				END
			ELSE 
				BEGIN 						
					UPDATE Transactions.TransHistory
					SET Status = 'Waiting (Payment of Repayment)'			
					WHERE TransID = @TransID
				END	
		END
	ELSE
		BEGIN					
			UPDATE Transactions.TransHistory
			SET Status = 'Waiting (Payment of Down Payment)'			
			WHERE TransID = @TransID			
			UPDATE Services.RoomNum
			SET Status = 'Booked'
			WHERE RoomNum = (SELECT RoomNum FROM Transactions.MainTrans
								WHERE TransID = @TransID);
		END
END
GO


-- Trigger Update Customer Account
CREATE TRIGGER Users.trgUpCustAcc
ON Users.CustAccount
FOR UPDATE AS
IF UPDATE (AccountNum)
BEGIN
	UPDATE Transactions.Invoice
	SET AccountNum = (SELECT AccountNum FROM INSERTED)
	WHERE TransID = (SELECT TransID FROM vMainTrans
					WHERE CustID = (SELECT CustID FROM INSERTED))
END
GO


-- Trigger Delete Log Customer
CREATE TRIGGER Log.trgLogCust
ON Log.Customer
FOR UPDATE, DELETE AS
	PRINT 'Updation or Deletion of Log Customer is not allowed!'
	ROLLBACK TRANSACTION;
RETURN;
GO


-- Trigger Delete Log Customer
CREATE TRIGGER Log.trgLogTrans
ON Log.Transactions
FOR UPDATE, DELETE AS
	PRINT 'Updation or Deletion of Log Transactions is not allowed!'
	ROLLBACK TRANSACTION;
RETURN;
GO



SP_HELP 'Transactions.MainTrans'						
EXEC sp_helptrigger 'Transactions.MainTrans ';

DISABLE TRIGGER Transactions.trgTrans
ON Transactions.MainTrans;  

DROP TRIGGER Transactions.trgInsTrans
ON Transactions.MainTrans;  