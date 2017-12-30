/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

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
SELECT U.CustID, U.NIK, U.CustName, U.Gender, U.DateOfBirth, U.Age, U.Job, K.Telephone, K.EmaiL, A.Address, A.ZipCode, A.City, C.AccountNum, C.AccountName, C.BankName
FROM Users.Customer U
LEFT OUTER JOIN Users.CustContact K
ON U.CustID = K.CustID
LEFT OUTER JOIN Users.CustAddress A
ON U.CustID = A.CustID
LEFT OUTER JOIN Users.CustAccount C
ON U.CustID = C.CustID

SELECT * FROM vCustBio

--View MainTrans
ALTER VIEW vMainTrans
AS
SELECT M.TransID, H.TransDate, H.TransTime, K.CUSTNAME, M.EmpID, M.RoomNum, C.DateOfCheckIn, C.DateOfCheckOut, C.PeriodOfTime, C.TotalCost
FROM Transactions.MainTrans M
INNER JOIN Transactions.TransHistory H
ON M.TransID = H.TransID
INNER JOIN Transactions.CostRoom C
ON M.RoomNum = C.RoomNum
INNER JOIN Users.Customer K
ON M.CUSTID = K.CUSTID

SELECT * FROM vMainTrans

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
