/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

		--- CREATE VIEW ---
--View Incumbency & Divisions
CREATE VIEW vIncDiv
AS
SELECT I.IncumbencyID, I.IncumbencyName, I.DivID, D.DivName, D.ChiefID
FROM HumanResources.Incumbency I
JOIN HumanResources.Divisions D
ON I.DivID = D.DivID

SELECT * FROM vIncDiv


--View Employee
CREATE VIEW vEmployee
AS
SELECT E.EmpID, E.NIK, E.EmpName, E.Gender, E.DateOfBirth, E.Age, E.MaritalStatus, K.Telephone, K.EmaiL, A.Address, A.ZipCode, A.City, A.Province, C.AccountNum, C.AccountName, C.BankName, I.IncumbencyID, I.IncumbencyName, D.DivName, D.ChiefID, E.Salary
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


--View Room
CREATE VIEW vRoom
AS
SELECT N.RoomNum, N.Status, N.RTypeID, T.RTypeName, T.Price, T.RoomAvailable, T.RoomIsUsed
FROM Services.RoomNum N
LEFT OUTER JOIN Services.RoomType T
ON N.RTypeID = T.RTypeID

SELECT * FROM vRoom


--View Servant
CREATE VIEW vServant
AS
SELECT T.RTypeID, T.RTypeName, S.SerName, S.EmpID, S.SerContact FROM Services.RoomType T 
INNER JOIN Services.Servant S
ON T.RTypeID = S.RTypeID

SELECT * FROM vServant


--View Room Is Used
ALTER VIEW vRoomIsUsed
AS
SELECT R.RoomNum, R.RTypeID, R.Status, M.TransID, C.DateOfCheckIn, C.DateOfCheckOut
FROM Services.RoomNum R
INNER JOIN Transactions.MainTrans M
ON R.RoomNum = M.RoomNum
INNER JOIN Transactions.CostRoom C
ON R.RoomNum = C.RoomNum
WHERE R.Status IN('Booked', 'Occupied')

SELECT * FROM vRoomIsUsed


--View Room Available
ALTER VIEW vRoomAvailable
AS
SELECT R.RoomNum, R.Status, R.RTypeID, T.RTypeName, T.Price
FROM Services.RoomNum R
INNER JOIN Services.RoomType T
ON R.RTypeID = T.RTypeID
WHERE R.Status = 'Available'

SELECT * FROM vRoomAvailable


--View Customer Data
CREATE VIEW vCustData
AS
SELECT U.CustID, U.NIK, U.CustName, U.Gender, U.DateOfBirth, U.Age, U.Job, K.Telephone, K.EmaiL, A.Address, A.ZipCode, A.City, A.Province, C.AccountNum, C.AccountName, C.BankName
FROM Users.Customer U
LEFT OUTER JOIN Users.CustContact K
ON U.CustID = K.CustID
LEFT OUTER JOIN Users.CustAddress A
ON U.CustID = A.CustID
LEFT OUTER JOIN Users.CustAccount C
ON U.CustID = C.CustID

SELECT * FROM vCustData


--View Main Transaction
ALTER VIEW vMainTrans
AS
SELECT M.TransID, H.TransDate, H.TransTime, H.Status, C.RoomNum, R.RTypeID, C.DateOfCheckIn, C.DateOfCheckOut, C.PeriodOfTime, I.TotalInvoice, I.DP, DueDateDP, DPStatus, Repayment, DueDateRePay, RePayStatus, AlreadyPaid, Unpaid, E.EmpID, E.EmpName, E.IncumbencyID, U.CustID, U.NIK, U.CustName, U.Gender, U.DateOfBirth, U.Age, U.Job, U.Telephone, U.EmaiL, U.Address, U.ZipCode, U.City, U.Province, U.AccountNum, U.AccountName, U.BankName 
FROM Transactions.MainTrans M
INNER JOIN Transactions.TransHistory H
ON M.TransID = H.TransID
INNER JOIN Transactions.CostRoom C
ON M.RoomNum = C.RoomNum
INNER JOIN Transactions.Invoice I
ON M.TransID = I.TransID
INNER JOIN vEmployee E
ON M.EmpID = E.EmpID
INNER JOIN vCustData U
ON M.CustID = U.CustID
INNER JOIN vRoom R
ON M.RoomNum = R.RoomNum

SELECT * FROM vMainTrans


--View Transaction Header
CREATE VIEW vTransHeader
AS
SELECT M.TransID, H.TransDate, H.TransTime, U.CustName, M.EmpID, M.RoomNum, C.DateOfCheckIn, C.DateOfCheckOut, C.PeriodOfTime, C.TotalCost
FROM Transactions.MainTrans M
INNER JOIN Transactions.TransHistory H
ON M.TransID = H.TransID
INNER JOIN Transactions.CostRoom C
ON M.RoomNum = C.RoomNum
INNER JOIN Users.Customer U
ON M.CustID = U.CustID

SELECT * FROM vTransHeader


--View Customer Transaction
CREATE VIEW vCustTrans
AS
SELECT M.TransID, H.TransDate, H.TransTime, U.CustID, U.NIK, U.CustName, U.Gender
FROM Transactions.MainTrans M
INNER JOIN Transactions.TransHistory H
ON M.TransID = H.TransID
INNER JOIN Users.Customer U
ON M.CustID = U.CustID

SELECT * FROM vCustTrans


--View Receipt
ALTER VIEW vReceipt
AS
SELECT M.TransID, H.TransDate, H.TransTime,U.CustID, U.CustName, E.EmpName AS 'Served by Employee', M.RoomNum, R.RTypeName, R.Price, C.DateOfCheckIn, C.DateOfCheckOut, C.PeriodOfTime, C.TotalCost, I.DP, I.DueDateDP, I.Repayment, I.DueDateRePay, I.AlreadyPaid, I.Unpaid
FROM Transactions.MainTrans M
INNER JOIN Transactions.TransHistory H
ON M.TransID = H.TransID
INNER JOIN Transactions.CostRoom C
ON M.RoomNum = C.RoomNum
INNER JOIN Users.Customer U
ON M.CustID = U.CustID
INNER JOIN vEmployee E
ON M.EmpID = E.EmpID
INNER JOIN vRoom R
ON M.RoomNum = R.RoomNum
INNER JOIN Transactions.Invoice I
ON M.TransID = I.TransID

SELECT * FROM vReceipt


		--- PROCEDURE VIEW ---
--Proc View Receipt by Date
CREATE PROC spvTransHeadbyDate @DCIN DATETIME, @DCOUT DATETIME
AS
SELECT * FROM vTransHeader
WHERE DateOfCheckIn BETWEEN @DCIN AND @DCOUT
ORDER BY DateOfCheckIn ASC
GO

--Hint >> @DCIN DATETIME, @DCOUT DATETIME
EXEC spvTransHeadbyDate '2018-01-01', '2018-01-03'


--Proc View Receipt by Customer
CREATE PROC spvReceipt @CustID VARCHAR(5)
AS
SELECT * FROM vReceipt
WHERE CustID = @CustID
GO

--Hint >> @CustID VARCHAR(5)
EXEC spvReceipt 'C0005'


--Proc View Transaction by Status
ALTER PROC spvTransbyStatus @TStatus VARCHAR(50), @DPS VARCHAR(10), @RPS VARCHAR(10)
AS
SELECT TransID, TransDate, TransTime, Status, DP, DPStatus, Repayment, RePayStatus, AlreadyPaid, Unpaid
FROM vMainTrans
WHERE	Status LIKE '%' + @TStatus + '%' AND DPStatus = @DPS AND RePayStatus = @RPS
GO

EXEC spvTransbyStatus 'Waiting', 'Unpaid', 'Unpaid'
EXEC spvTransbyStatus 'Waiting', 'Paid', 'Unpaid'
EXEC spvTransbyStatus 'Succeed', 'Paid', 'Paid'
EXEC spvTransbyStatus 'Cancelled', 'Unpaid', 'Unpaid'