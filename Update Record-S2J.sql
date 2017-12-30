/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

		--- UPDATE RECORD ---
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

SELECT * FROM Transactions.Invoice
SELECT * FROM Transactions.TransHistory
