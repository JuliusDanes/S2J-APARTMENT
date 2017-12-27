USE [AdventureWorks]
GO

SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmployeeAddress
SELECT * FROM HumanResources.EmployeeDepartmentHistory
SELECT * FROM HumanResources.EmployeePayHistory
SELECT * FROM HumanResources.vEmployee
SELECT * FROM HumanResources.Department
SELECT * FROM HumanResources.EmployeeDepartmentHistory
SELECT * FROM Sales.Currency

SELECT EmployeeID, ContactID, LoginID, Title FROM HumanResources.Employee

SELECT * FROM HumanResources.Department
SELECT 'Departement Number' = DepartmentID, ' Departement Name' =  Name
FROM HumanResources.Department
SELECT DepartmentID 'Departement Number', NAME 'Departement Name' 
FROM HumanResources.Department
SELECT DepartmentID AS 'Department Number', NAME AS 'Department Name'
FROM [HumanResources].[Department]

SELECT EmployeeID, 'Desigantion: ', Title
FROM HumanResources.Employee

SELECT 'snow ' + 'ball'
SELECT NAME + ' department comes under ' + GROUPName + ' GROUP' AS
Department FROM HumanResources.Department

SELECT EmployeeID, Rate, Per_Day_Rate = 8 * Rate
FROM HumanResources.EmployeePayHistory

SELECT * FROM HumanResources.Department
WHERE GROUPName = 'Research and Development' OR GROUPName = 'Manufacturing'

SELECT EmployeeID, NationalIDNumber, Title, VacationHours
FROM HumanResources.Employee
WHERE VacationHours < 5

SELECT EmployeeID, NationalIDNumber, Title, VacationHours
FROM HumanResources.Employee
WHERE VacationHours < 5
ORDER BY VacationHours Desc

SELECT * FROM HumanResources.Department
SELECT * FROM HumanResources.Department WHERE GROUPName = 'Manufacturing' OR GROUPName = 'Quality Assurance'
SELECT * FROM HumanResources.Employee WHERE Title = 'Production Technician - WC60' AND MaritalStatus = 'M'
SELECT * FROM HumanResources.Department WHERE NOT GROUPName = 'Quality Assurance'
SELECT * FROM HumanResources.Department WHERE GROUPName != 'Quality Assurance'

SELECT EmployeeID, VacationHours FROM HumanResources.Employee
WHERE VacationHours BETWEEN 20 AND 50
SELECT EmployeeID, VacationHours FROM HumanResources.Employee
WHERE VacationHours NOT BETWEEN 40 AND 50

SELECT EmployeeID, Title, LoginID FROM HumanResources.Employee WHERE Title IN ('RECRUITER', 'STOCKER')
SELECT EmployeeID, Title, LoginID FROM HumanResources.Employee WHERE Title = 'RECRUITER' OR Title = 'STOCKER'
SELECT EmployeeID, Title, LoginID FROM HumanResources.Employee WHERE Title NOT IN ('RECRUITER', 'STOCKER')
SELECT EmployeeID, Title, LoginID FROM HumanResources.Employee WHERE Title != 'RECRUITER' AND Title != 'STOCKER'

SELECT * FROM HumanResources.Department
SELECT * FROM HumanResources.Department WHERE NAME LIKE 'SAL__'
SELECT * FROM HumanResources.Department WHERE GROUPName LIKE 'RE%'
SELECT * FROM HumanResources.Department WHERE GROUPName LIKE '%AN%'
SELECT * FROM HumanResources.Department WHERE GROUPName LIKE '%ENT'
SELECT * FROM HumanResources.Department WHERE GROUPName LIKE '[RES]%'
SELECT * FROM HumanResources.Department WHERE GROUPName LIKE '%[RES]'
SELECT * FROM HumanResources.Department WHERE GROUPName LIKE '[G-S]%'
SELECT * FROM HumanResources.Department WHERE GROUPName LIKE 'R[^e]'

SELECT EmployeeID, EndDate FROM HumanResources.EmployeeDepartmentHistory
SELECT EmployeeID, EndDate FROM HumanResources.EmployeeDepartmentHistory 
WHERE EndDate IS NULL
SELECT EmployeeID, EndDate FROM HumanResources.EmployeeDepartmentHistory 
WHERE EndDate IS NOT NULL

SELECT DepartmentID, NAME FROM HumanResources.Department
ORDER BY NAME ASC
SELECT DepartmentID, NAME FROM HumanResources.Department
ORDER BY NAME DESC
SELECT GROUPName, DepartmentID, NAME FROM HumanResources.Department
ORDER BY GROUPName, DepartmentID
SELECT GROUPName, DepartmentID, NAME FROM HumanResources.Department
ORDER BY GROUPName, DepartmentID DESC

SELECT TOP 10 * FROM HumanResources.Employee
SELECT TOP 10 * FROM HumanResources.Employee
ORDER BY EmployeeID DESC
SELECT TOP 10 PERCENT * FROM HumanResources.Employee
SELECT TOP 3 * FROM HumanResources.Employee WHERE HireDate >= '1/1/98' AND HireDate <= '12/31/98'
ORDER BY SickLeaveHours ASC

SELECT DISTINCT Title FROM HumanResources.Employee WHERE Title LIKE 'PR%'
SELECT * FROM Production.ProductModel WHERE NAME LIKE '%ES'

SELECT 'Department Name' = UPPER(Name), DepartmentID, GROUPName FROM HumanResources.Department

SELECT * FROM Person.Contact
SELECT NAME = Title + ' ' + LEFT(FirstName, 1) + '. ' + LastName, EmailAddress FROM Person.Contact

SELECT ASCII('BOLT') --hrf awal char berapa?
SELECT CHAR(76) --char num itu apa?
SELECT CHARINDEX('E', 'HELLO') --hrf E ada di pos ke berapa?
SELECT DIFFERENCE('HELLO', 'HELL')
SELECT LEFT('RICHARD', 5) --5 hrf dr kiri
SELECT RIGHT('RICHARD', 4) --dr kanan
SELECT LTRIM('       GET RICH') --hps space yg di kiri
SELECT RTRIM('GET RICH       ') --hps space yg di kanan
SELECT LEN('DIE HARD') --jml char trmsk space
SELECT LOWER('Titip-IN') --semua hrf jd kecil
SELECT UPPER('Titip-In') --semua hrf jd besar
SELECT REPLACE('DEVILEBAD', 'BAD', 'BEST') --ganti hrf yg diSELECT
SELECT PATINDEX('%BOX%', 'ACTIONBOXMOVIE') --urutan kata BOX dr kiri
SELECT REVERSE('DEMON DEVILEBAD') --balik hrf dr kata
SELECT 'DEMON' + SPACE(5) + 'DEVILEBAD' --tmbh space dgn bnyk tertentu
SELECT STR(123.45, 6, 2) --(angka, bulatin brp angka, berapa angka di blkng koma)
SELECT STUFF('WEATHER', 2, 4, 'I') --gnt hrf --parameter(kata, posisi, bnyk hrf, ganti)
SELECT SUBSTRING('WEATHER', 2, 4) --ambil hrf --parameter(kata, posisi, bnyk hrf)

SELECT GETDATE() --waktu sekarang
SELECT GETUTCDATE() --waktu sekarang GMT 0
SELECT DATEDIFF(YY, BirthDate, GETDATE()) AS 'AGE' FROM HumanResources.Employee
SELECT DATEADD(MM, 5, '2009-01-02') --tmbh 5 bln
SELECT CONVERT(DATETIME, '2005-05-06')
SELECT DATEDIFF(YEAR, CONVERT(DATETIME, '2005-05-06'), GETDATE()) --selisih thn itu dgn thn skrng
SELECT DATENAME(MONTH, CONVERT(DATETIME, '2010-06-07')) --dpt nama bulan
SELECT DATENAME(WEEKDAY, GETDATE())
SELECT DATENAME(NANOSECOND, GETDATE())
SELECT MONTH('2017-05-16') --ambil bulan
SELECT YEAR('2017-05-16')
SELECT DATEPART(DD, '2017-05-16') --ambil tanggal
SELECT DATEPART(WEEKDAY, '2017-05-16') --hr ke brp dlm 1 minggu
SELECT DATEPART(QUARTER, '2017-05-16') --quarter brp dlm 1 
SELECT DATEPART(WEEK, '2017-05-16') --quarter brp dlm 1 thn

SELECT * FROM HumanResources.Employee
SELECT TITLE, DATEPART(YY, HIREDATE) AS 'YEAR OF JOINING' FROM HumanResources.Employee
SELECT EMPLOYEEID, DATENAME(MM, HIREDATE) + ', ' + CONVERT(varchar, DATEPART(YYYY, HIREDATE)) AS 'JOINING'
FROM HumanResources.Employee --tampil bulan, tahun

SELECT ABS(-76)
SELECT ACOS(0.5) --range(-1 s/d 1) --dlm radian angle
SELECT ASIN(-1.0)
SELECT ATAN(-1.0)
SELECT SIN(0.5)
SELECT COS(-1.0)
SELECT TAN(-1.0)
SELECT CEILING(14.15) --bulatkan ke atas
SELECT EXP(0)
SELECT FLOOR(14.56) --bulatkan ke bawah
SELECT LOG(100, 10) --log(nilai, basis)
SELECT LOG10(100) --logbasis(nilai)
SELECT PI() --nilai phi 3,14
SELECT POWER(2, 5) --prmtr(nilai, pangkat)
SELECT RADIANS(180)
SELECT RAND() --random num between 0 and 1
SELECT ROUND(15.789)U
SELECT SIGN(-15)
SELECT SQRT(64) --akar dari bil
SELECT EMPLOYEEID, 'HOURLY PAY RATE' = ROUND(RATE, 2) FROM HumanResources.EmployeePayHistory
SELECT ROUND(1234.567, 1) --bulatkan 1 angka di blkng koma
SELECT ROUND(1234.567, 0) --bulatkan tepat di koma
SELECT ROUND(1234.567, -1) --bulatkan 1 angka di depan koma
SELECT SHIFTID, STARTTIME, 'END TIME' = DATEADD(HH, 10, STARTTIME) FROM HumanResources.Shift --tmbh 10 jam dr starttime

SELECT EMPLOYEEID, RATE FROM HumanResources.EmployeePayHistory
SELECT EMPLOYEEID, RATE, ROW_NUMBER() OVER(ORDER BY RATE DESC, EMPLOYEEID) AS RANK
FROM HumanResources.EmployeePayHistory
SELECT EMPLOYEEID, RATE, ROW_NUMBER() OVER(ORDER BY RATE DESC) AS RANK
FROM HumanResources.EmployeePayHistory
SELECT EMPLOYEEID, RATE, RANK() OVER(ORDER BY RATE DESC) AS RANK
FROM HumanResources.EmployeePayHistory
SELECT EMPLOYEEID, RATE, DENSE_RANK() OVER(ORDER BY RATE DESC) AS RANK
FROM HumanResources.EmployeePayHistory
SELECT SALESPERSONID, TERRITORYID, SALESYTD FROM Sales.SalesPerson
SELECT SALESPERSONID, TERRITORYID, SALESYTD, DENSE_RANK() OVER(PARTITION BY TERRITORYID ORDER BY SALESYTD DESC)
AS RANK FROM Sales.SalesPerson WHERE TerritoryID IS NOT NULL
SELECT EMPLOYEEID, BIRTHDATE, HIREDATE, NTILE(4) OVER(ORDER BY BIRTHDATE) AS RANK FROM HumanResources.Employee
WHERE DATEPART(MM, HIREDATE) >= 04 AND DATEPART(YY, HIREDATE) >= 2001
SELECT EMPLOYEEID, BIRTHDATE, HIREDATE, NTILE(5) OVER(ORDER BY BIRTHDATE) AS RANK FROM HumanResources.Employee
WHERE DATEPART(MM, HIREDATE) >= 04 AND DATEPART(YY, HIREDATE) >= 2001

SELECT HOST_ID() AS 'HOSTID'
SELECT HOST_NAME() AS 'HostName' --server name
SELECT SUSER_SID('SA') AS SID --SecId LogIn username
SELECT SUSER_ID('SA') AS USERID --Id number username
SELECT SUSER_SNAME(0X01) AS SUSER --name of username
SELECT USER_ID('ROBERT') AS USERID
SELECT USER_ID('DBO') AS USERID --Id Number 0f username --AdvenWork/Security/Users/
SELECT USER_ID('guest') AS USERID
SELECT USER_ID('sys') AS USERID
SELECT USER_NAME(4) AS UserName --username FROM IdNum
SELECT DB_ID('AdventureWorks') AS DATABASEID --id of database
SELECT DB_NAME(7) AS DATABASENAME --name of database
SELECT OBJECT_ID('AdventureWorks.HumanResources.Employee') AS OBEJCTID --id of table or object
SELECT OBJECT_NAME(901578250) AS OEBJECTNAME --name of table/obect FROM IdNum
SELECT [NationalIDNumber] FROM HumanResources.Employee
SELECT CAST([NationalIDNumber] AS CHAR(20)) AS IDNUMBER FROM HumanResources.Employee
SELECT CONVERT(CHAR(20), [NationalIDNumber]) AS IDNUMBER FROM HumanResources.Employee
SELECT DATALENGTH('TestExpression') AS LENGTHOFDATA --Get length/bnyk hrf dari kata

SELECT * FROM HumanResources.EmployeePayHistory
SELECT Rate FROM HumanResources.EmployeePayHistory
--SELECT AGGREGATE_FUNCTION(...) FROM tablename
SELECT 'AVERAGE RATE' = AVG(RATE) FROM HumanResources.EmployeePayHistory --average all row in colum
SELECT 'UNIQUE RATE' = COUNT(DISTINCT RATE) FROM HumanResources.EmployeePayHistory
SELECT COUNT(EmployeeID) FROM HumanResources.Employee
SELECT * FROM Sales.SalesOrderDetail
SELECT COUNT(*) FROM Sales.SalesOrderDetail
SELECT SUM(LineTotal) AS TOTALPRICE, AVG(UnitPrice) AS AVERAGETOTAL FROM Sales.SalesOrderDetail --total hrg keseluruhan
SELECT 'MINIMUM RATE' = MIN(RATE) FROM HumanResources.EmployeePayHistory --nilai terKECIL
SELECT 'MAXIMUM RATE' = MAX(RATE) FROM HumanResources.EmployeePayHistory --nilai terBESAR
SELECT 'SUM' = SUM(DISTINCT RATE) FROM HumanResources.EmployeePayHistory --menJUMLAHkan semua brs jd 1 brs
SELECT UNITPRICE FROM Sales.SalesOrderDetail
SELECT 'MAXIMUM RATE' = MAX(UNITPRICE) FROM Sales.SalesOrderDetail

SELECT Title, MINIMUM = MIN(VacationHours), MAXIMUM = MAX(VacationHours) FROM HumanResources.Employee
WHERE VacationHours > 80 GROUP BY Title --GROUP BY mirip ORDER BY, grup tapi blm urut
SELECT Title, 'AVERAGE VACATION HOURS' = AVG(VacationHours) FROM HumanResources.Employee
WHERE VacationHours > 30 GROUP BY Title HAVING AVG(VacationHours) > 55 --HAVING mirip WHERE
SELECT Title, 'MANAGER ID' = ManagerID, AVERAGE = AVG(VacationHours) FROM HumanResources.Employee GROUP BY Title, ManagerID --grup tapi blm urut
SELECT Title, VacationHours = SUM(VacationHours) FROM HumanResources.Employee
WHERE Title IN ('RECRUITER', 'STOCKER', 'DESIGN ENGINEER') 
GROUP BY ALL Title ORDER BY SUM(VacationHours) DESC

SELECT * FROM EmpTable
SELECT * FROM HumanResources.Employee
SELECT EmployeeID, Title, 'VACATION HOURS' = AVG(VacationHours) FROM HumanResources.Employee
GROUP BY 
	GROUPING SETS
	(
		(EmployeeID, Title),
		(EmployeeID), 
		(Title)
	) --???

SELECT Title, 'TOTAL VACATIONHOURS' = VacationHours, 'TOTAL SICKLEAVEHOURS' = SickLeaveHours FROM HumanResources.Employee
WHERE Title IN ('RECRUITER', 'STOCKER') ORDER BY Title, VacationHours, SickLeaveHours 
COMPUTE SUM(VacationHours), SUM(SickLeaveHours) --???

SELECT Title, 'TOTAL VACATIONHOURS' = VacationHours, 'TOTAL SICKLEAVEHOURS' = SickLeaveHours FROM HumanResources.Employee
WHERE Title IN ('RECRUITER', 'STOCKER') ORDER BY Title, VacationHours, SickLeaveHours
COMPUTE SUM(VacationHours), SUM(SickLeaveHours) BY Title COMPUTE SUM(VacationHours), SUM(SickLeaveHours) --???

SELECT VendorID, [164] AS Emp1, [198] AS Emp2, [223] AS Emp3, [231] AS Emp4, [233] AS Emp5 
FROM
	(SELECT PurchaseOrderID, EmployeeID, VendorID
	 FROM Purchasing.PurchaseOrderHeader) P
PIVOT
	( COUNT (PurchaseOrderID)
	FOR EmployeeID IN ([164], [198], [223], [231], [233])
	) AS PVT ORDER BY VendorID --???

--AGGREGATE FUNCTION
SELECT Title,VacationHours FROM HumanResources.Employee
WHERE VacationHours > 80
SELECT Title, Minimum = MIN(VacationHours), Maximum = MAX(VacationHours) FROM HumanResources.Employee
WHERE VacationHours > 80 GROUP BY Title
SELECT Title, COUNT(EmployeeID) AS TOTALEMP FROM HumanResources.Employee GROUP BY Title

--HAVING elimimasi yg tdk sesuai kelompok
SELECT * FROM Sales.SalesOrderDetail WHERE SalesOrderID = 43659
SELECT SalesOrderID, SUM(LineTotal) AS SUBTOTAL FROM Sales.SalesOrderDetail 
GROUP BY SalesOrderID HAVING SUM(LineTotal) > 100000.00 ORDER BY SalesOrderID --HAVING --Yg hny memenuhi syarat HAVING

SELECT EmployeeID, Title, AVG(VacationHours) AS AVGVACATIONHOURS FROM HumanResources.Employee
GROUP BY
	GROUPING SETS
	(
		(EmployeeID, Title),
		(EmployeeID),
		(Title)
	)

SELECT Title, 'Total VacationHours' = VacationHours, 'Total SickLeaveHours' = SickLeaveHours FROM HumanResources.Employee
WHERE Title IN ('RECRUITER', 'STOCKER') ORDER BY Title, VacationHours, SickLeaveHours
COMPUTE SUM(VacationHours), SUM(SickLeaveHours) --COMPUTE menghitung jmlh semua SUM(VacationHours) AND SUM(SickLeaveHours) --2014 ke ats tdk bs

--PIVOT kelompokkan & buat unik
SELECT * FROM Purchasing.PurchaseOrderHeader
SELECT PurchaseOrderID, EmployeeID, VendorID
	 FROM Purchasing.PurchaseOrderHeade

SELECT VendorID, [164] AS Emp1, [198] AS Emp2, [223] AS Emp3, [231] AS Emp4, [233] AS Emp5 --[value] AS alias
	FROM 
	(SELECT PurchaseOrderID, EmployeeID, VendorID --diambil dr table
	 FROM Purchasing.PurchaseOrderHeader) p
	 PIVOT
	 (
	 COUNT (PurchaseOrderID)
	 FOR EmployeeID IN 
	 ( [164], [198], [223], [231], [233] )
	 ) AS pvt
	 ORDER BY VendorID

--select DISTINCT >> membuat unik nilai yg ganda
--P001, P001, P001 >> P001 ; P001, P001, P002 >> P001, P002

--JOINS (Outer, Inner, )
-- Inner Join >> irisan aja yg diambil, bebas pilih kolom yg ditmplk, keduanya pasti sdh terisi
SELECT * FROM HumanResources.Employee
SELECT e.EmployeeID, e.Title, eph.Rate, eph.PayFrequency FROM HumanResources.Employee e
JOIN HumanResources.EmployeePayHistory eph
ON e.EmployeeID = eph.EmployeeID

SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmployeeAddress
SELECT * FROM Person.Address

SELECT e.EmployeeID, e.Title, ea.AddressID, pa.AddressLine1, pa.City FROM HumanResources.Employee e
JOIN HumanResources.EmployeeAddress ea
ON e.EmployeeID = ea.EmployeeID 
JOIN Person.Address pa
ON pa.AddressID = ea.AddressID 
WHERE pa.City = 'Berlin'

SELECT 'EMPLOYEE ID' = e.EmployeeID, 'DESIGNATION' = e.Title FROM HumanResources.Employee e 
INNER JOIN HumanResources.EmployeePayHistory eph
ON e.EmployeeID = eph.EmployeeID WHERE eph.Rate > 40
--cth penerapan tmpl produk yg sdh terjual

--OUTER JOIN
---LEFT OJ >> hny table kiri aja yg tmpl, jika slh satu tdk ada maka NULL, tdk ada data sbh kanan yg tdk sama sblh kiri
SELECT * FROM Sales.SpecialOfferProduct p 
LEFT OUTER JOIN Sales.SalesOrderDetail p1 ON p.ProductID = p1.ProductID

SELECT ProductID FROM Sales.SpecialOfferProduct WHERE ProductID = 846
SELECT ProductID FROM Sales.SalesOrderDetail WHERE ProductID = 846
--cth penerapan tmpl produk yang sdh dipesan, tapi ada yg blm dibayar

--RIGHT OJ >> tmpl output semua record sblh kanan & cocok dgn sblh kiri
SELECT * FROM Sales.SalesTerritory; SELECT * FROM Sales.SalesPerson
SELECT st.Name AS TERRITORY, sp.SalesPersonID FROM Sales.SalesTerritory st
RIGHT OUTER JOIN Sales.SalesPerson sp
ON st.TerritoryID = sp.TerritoryID

--FULL OJ >> gab left & right oj
SELECT st.Name AS TERRITORY, sp.SalesPersonID FROM Sales.SalesTerritory st
FULL OUTER JOIN Sales.SalesPerson sp
ON st.TerritoryID = sp.TerritoryID

--CROSS join >> tmpl semua kolom yg ada di tbl lain, brs kali brs
--utk hitung probalitas
SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.Shift
SELECT e.EmployeeID, e.Title FROM HumanResources.Employee e
CROSS JOIN HumanResources.Shift

--EQUI join >> sama inner join, gab dgn bantuan foreign key, & tmpl semua kolom dr dua tbl tsb, kolom yg sama keduanya tetap ditmplk
SELECT * FROM HumanResources.EmployeeDepartmentHistory d
JOIN HumanResources.Employee e
ON  d.EmployeeID = e.EmployeeID
JOIN HumanResources.Department p 
ON p.DepartmentID = d.DepartmentID

SELECT * FROM HumanResources.Department d, HumanResources.EmployeeDepartmentHistory dh
WHERE d.DepartmentID = dh.DepartmentID

--SELF join >> gab data yg berada di tbl itu sendiri, dgn alias name beda
SELECT * FROM HumanResources.Employee
SELECT emp.EmployeeID, emp.Title AS EMPLOYEE_DESIGNATION FROM HumanResources.Employee emp, HumanResources.Employee mgr
WHERE emp.ManagerID = mgr.EmployeeID

SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.Employee
WHERE Title = 'TOOL DESIGNER'
SELECT * FROM HumanResources.Employee
WHERE Title = (SELECT Title FROM HumanResources.Employee
			   WHERE EmployeeID = '16')

SELECT Name FROM HumanResources.Department
WHERE DepartmentID = (SELECT DepartmentID FROM HumanResources.EmployeeDepartmentHistory
WHERE EmployeeID = 46 AND EndDate IS NULL)
