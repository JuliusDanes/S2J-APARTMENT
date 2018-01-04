/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

		--- INSERT TABLE ---
--Insert Divisions
SELECT * FROM HumanResources.Divisions
CREATE PROC spInsDiv @EID VARCHAR(5), @DivID VARCHAR(10), @DivName VARCHAR(100), @ChiefID VARCHAR(5)
AS
IF @EID = 'FOUND' OR @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'CEO' OR IncumbencyID = 'CHRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		INSERT HumanResources.Divisions(DivID, DivName, ChiefID)
			VALUES(@DivID, @DivName, @ChiefID);
		PRINT 'Division ' + @DivID + ' [' + @DivName + ']' + ' successfully Added +';
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'CEO' AND IncumbencyID != 'CHRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @DivID VARCHAR(10), @DivName VARCHAR(100), @ChiefID VARCHAR(5)

EXEC spInsDiv 'FOUND', 'FOUNDER', 'CO-Founder', NULL
EXEC spInsDiv 'FOUND', 'DEXEDIV', 'Executive Director', NULL
EXEC spInsDiv 'FOUND', 'EXEDIV', 'Executive General', 'E0003'
EXEC spInsDiv 'FOUND', 'OPDIV', 'Operating Management', 'E0005'
EXEC spInsDiv 'FOUND', 'FINDIV', 'Finance and Investment', 'E0006'
EXEC spInsDiv 'FOUND', 'HRDIV', 'Human Resources', 'E0007'
EXEC spInsDiv 'FOUND', 'LEGDIV', 'Legal', 'E0008'
EXEC spInsDiv 'FOUND', 'MIDIV', 'Marketing and Information', 'E0009'
EXEC spInsDiv 'FOUND', 'CDDIV', 'Creative Development', 'E0010'
EXEC spInsDiv 'FOUND', 'QADIV', 'Quality Assurance', 'E0011'


--Insert Incumbency
SELECT * FROM HumanResources.Incumbency
CREATE PROC spInsInc @EID VARCHAR(5), @IncID VARCHAR(10), @IncName VARCHAR(100), @DivID VARCHAR(10)
AS
IF @EID = 'FOUND' OR @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'CHRO' OR IncumbencyID = 'MHRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		INSERT HumanResources.Incumbency
			VALUES(@IncID, @IncName, @DivID);
		PRINT 'Incumbency ' + @IncID + ' [' + @IncName + ']' + ' successfully Added +';
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'CHRO' AND IncumbencyID != 'MHRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @IncID VARCHAR(10), @IncName VARCHAR(100), @DivID VARCHAR(10)

EXEC spInsInc 'FOUND', 'FOUNDER', 'CO-Founder', 'FOUNDER'
EXEC spInsInc 'FOUND', 'CEO', 'Chief Executive Officer', 'DEXEDIV'
EXEC spInsInc 'FOUND', 'COO', 'Chief Operating Executive', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CFO', 'Chief Financial Executive', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CHRO', 'Chief Human Resources Officer', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CLO', 'Chief Legal Officer', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CCDO', 'Chief Creative Development Officer', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CMO', 'Chief Marketing Officer', 'EXEDIV'
EXEC spInsInc 'FOUND', 'CQAO', 'Chief Quality Assurance Officer', 'EXEDIV'

EXEC spInsInc 'FOUND', 'MOO', 'Manager Operating Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'OO', 'Operating Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'MAO', 'Manager Audit Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'AO', 'Audit Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'MFMO', 'Manager Facilities and Maintenance Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'FMO', 'Facilities and Maintenance Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'MTIO', 'Manager Tools and Inventory Officer', 'OPDIV'
EXEC spInsInc 'FOUND', 'TIO', 'Tools and Inventory Officer', 'OPDIV'

EXEC spInsInc 'FOUND', 'MFO', 'Manager Financial Officer', 'FINDIV'
EXEC spInsInc 'FOUND', 'FO', 'Financial Officer', 'FINDIV'
EXEC spInsInc 'FOUND', 'MIO', 'Manager Investment Officer', 'FINDIV'
EXEC spInsInc 'FOUND', 'IO', 'Investment Officer', 'FINDIV'

EXEC spInsInc 'FOUND', 'MHRO', 'Manager Human Resources Officer', 'HRDIV'
EXEC spInsInc 'FOUND', 'HRO', 'Human Resources Officer', 'HRDIV'

EXEC spInsInc 'FOUND', 'MPDO', 'Manager Plan and Design Officer', 'CDDIV'
EXEC spInsInc 'FOUND', 'PDO', 'Plan and Design Officer', 'CDDIV'
EXEC spInsInc 'FOUND', 'MCO', 'Manager Creative Officer', 'CDDIV'
EXEC spInsInc 'FOUND', 'CO', 'Creative Officer', 'CDDIV'

EXEC spInsInc 'FOUND', 'MCSO', 'Manager Customer Services Officer', 'QADIV'
EXEC spInsInc 'FOUND', 'CSO', 'Customer Services Officer', 'QADIV'
EXEC spInsInc 'FOUND', 'MSO', 'Manager Security Officer', 'QADIV'
EXEC spInsInc 'FOUND', 'SO', 'Security Officer', 'QADIV'
EXEC spInsInc 'FOUND', 'MSVO', 'Manager Servant Officer', 'QADIV'
EXEC spInsInc 'FOUND', 'SVO', 'Servant Officer', 'QADIV'

EXEC spInsInc 'FOUND', 'MLO', 'Manager Legal Officer', 'LEGDIV'
EXEC spInsInc 'FOUND', 'LO', 'Legal Officer', 'LEGDIV'
EXEC spInsInc 'FOUND', 'MDCO', 'Manager Document Control Officer', 'LEGDIV'
EXEC spInsInc 'FOUND', 'DCO', 'Document Control Officer', 'LEGDIV'

EXEC spInsInc 'FOUND', 'MMO', 'Manager Marketing Officer', 'MIDIV'
EXEC spInsInc 'FOUND', 'MO', 'Marketing Officer', 'MIDIV'
EXEC spInsInc 'FOUND', 'MPRO', 'Manager Public Relations Officer', 'MIDIV'
EXEC spInsInc 'FOUND', 'PRO', 'Public Relations Officer', 'MIDIV'


--Insert Employee
SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmpContact
SELECT * FROM HumanResources.EmpAddress
SELECT * FROM HumanResources.EmpAccount

DROP PROC spInsEmp
CREATE PROC spInsEmp @EID VARCHAR(5), @NIK BIGINT, @Name VARCHAR(30), @Gender VARCHAR(10), @DOB DATETIME, @MS VARCHAR(10), @Telp BIGINT, @Email VARCHAR(100), @Add VARCHAR(200), @ZC INT, @City VARCHAR(30), @Prov VARCHAR(30), @AccNum VARCHAR(19), @AccName VARCHAR(30), @BName VARCHAR(30), @IncID VARCHAR(10), @Salary MONEY
AS
IF @EID = 'FOUND' OR @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MHRO' OR IncumbencyID = 'HRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		INSERT HumanResources.Employee(NIK, EmpName, Gender, DateOfBirth, MaritalStatus, IncumbencyID, Salary)
			VALUES(@NIK, @Name, @Gender, @DOB, @MS, @IncID, @Salary);

		DECLARE @Count INT, @EmpID VARCHAR(5), @Age INT
		SELECT @Count = ID FROM HumanResources.Employee
		WHERE EmpID = '0'
		SET @EmpID = (
			CASE
				WHEN (@Count < 10) THEN 'E000'
				WHEN (@Count >= 10) AND (@Count < 100) THEN 'E00'
				WHEN (@Count >= 100) AND (@Count < 1000) THEN 'E0'
				WHEN (@Count >= 1000) AND (@Count < 10000) THEN 'E'
			END
			)
		SET @EmpID = @EmpID + CAST(@Count AS VARCHAR(5))
		SET @Age = FLOOR(DATEDIFF(DAY, @DOB, GETDATE()) / 365.25)

		UPDATE HumanResources.Employee
		SET EmpID = @EmpID,
			Age = @Age,
			MaritalStatus = (
			CASE
				WHEN (MaritalStatus = 'M') THEN 'Married'
				WHEN (MaritalStatus = 'S') THEN 'Single'
				ELSE @MS
			END
			)
		WHERE EmpID = '0'

		INSERT HumanResources.EmpContact
			VALUES(@EmpID, @Telp, @Email);
		INSERT HumanResources.EmpAddress
			VALUES(@EmpID, @Add, @ZC, @City, @Prov);
		INSERT HumanResources.EmpAccount
			VALUES(@EmpID, @AccNum, @AccName, @BName);
		PRINT 'Employee ' + @EmpID + ' [' + @Name + ']' + ' successfully Added +';
END
ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MHRO' AND IncumbencyID != 'HRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >>  @EID VARCHAR(5), @NIK BIGINT, @Name VARCHAR(30), @Gender VARCHAR(10), @DOB DATETIME, @MS VARCHAR(10), @Telp BIGINT, @Email VARCHAR(100), @Add VARCHAR(200), @ZC INT, @City VARCHAR(30), @Prov VARCHAR(30), @AccNum VARCHAR(19), @AccName VARCHAR(30), @BName VARCHAR(30), @IncID VARCHAR(10), @Salary MONEY

SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmpContact
SELECT * FROM HumanResources.EmpAddress
SELECT * FROM HumanResources.EmpAccount

EXEC spInsEmp 'FOUND', 3175042512990006, 'Shafira Az"zahra', 'F', '1990-01-02', 'M', 085284843201, 'shafira.azzahra@yahoo.com', 'Jl Raya Bogor No 78', 13510, 'Jakarta', 'DKI Jakarta', '1234-5678-1234-5678', 'Shafira Azzahra', 'Bukopin', 'FOUNDER', NULL
EXEC spInsEmp 'FOUND', 3175042512990001, 'Julius Danes Nugroho', 'M', '1990-12-25', 'M', 085284843202, 'julius.danes.nugroho@gmail.com', 'Jl. Bangun Raya No 23', 13550, 'Jakarta', 'DKI Jakarta', '1234-5678-8765-4321', 'Julius Danes', 'Bukopin', 'FOUNDER', NULL
EXEC spInsEmp 'FOUND', 3175042512990002, 'Jofanto Alfaj', 'M', '1990-02-03', 'M', 085284843203, 'jofanto.alfaj@outlook.biz', 'Jl Juanda No7', 13350, 'Depok', 'Jawa Barat', '8765-4321-1234-5678', 'Jofanto Alfaj', 'Bukopin', 'FOUNDER', NULL

EXEC spInsEmp 'FOUND', 3175042512990003, 'Oktaviano Pratama', 'M', '1985-12-25', 'M', 02055550132, 'oktaviano.pratama@adventure-works.com', 'Jl. Margonda Raya No 14', 17816, 'Depok', 'Jawa Barat', '0178-1650-0610-2406', 'Oktaviano Pratama', 'Bukopin', 'CEO', 76000000
EXEC spInsEmp 'FOUND', 3175042512990004, 'Sean Chai', 'F', '1990-12-27', 'S', 02055650133, 'sean1@adventure-works.com', '9314 Icicle Way', 98027, 'Bogor', 'Jawa Barat', '2053-5545-0132-4687', 'Sean Chai', 'Bukopin', 'COO', 65000000
EXEC spInsEmp 'FOUND', 3175042512990005, 'Dan Wilson', 'M', '1988-11-4', 'M', 0836765457, 'dan1@adventure-works.com', '5863 Sierra', 98004, 'Depok', 'Jawa Barat', '6533-5554-0144-8719', 'Dan Wilson', 'Bukopin', 'CFO', 55000000
EXEC spInsEmp 'FOUND', 3175042512990007, 'Mark McArthur', 'M', '1988-2-2', 'S', 068645783576, 'mark1@adventure-works.com', '9863 Ridge Place', 98006, 'Tangerang', 'Banten', '4147-5455-0154-2823', 'Mark McArthur', 'Bukopin', 'CHRO', 58000000
EXEC spInsEmp 'FOUND', 3175042512990008, 'Houman Pournasseh', 'M', '1984-1-27', 'S', 079575758685, 'houman0@adventure-works.com', '1397 Paradise Ct.', 98052, 'Bogor', 'Jawa Barat', '9325-5553-0199-6282', 'Houman Pournasseh', 'Bukopin', 'CLO', 50000000
EXEC spInsEmp 'FOUND', 3175042512990010, 'Sairaj Uddin', 'M', '1986-4-17', 'M', 085784635908, 'sairaj0@adventure-works.com', '9882 Clay Rde', 98052, 'Bogor ', 'Jawa Barat', '1830-5455-0136-4171', 'Sairaj Uddin', 'Bukopin', 'CMO', 47000000
EXEC spInsEmp 'FOUND', 3175042512990011, 'Michiko Osada', 'F', '1983-6-24', 'S', 096878568756, 'michiko0@adventure-works.com', '8040 Hill Ct', 98074, 'Jakarta', 'DKI Jakarta', '5300-5545-0159-7283', 'Michiko Osada', 'Bukopin', 'CCDO', 53000000
EXEC spInsEmp 'FOUND', 3175042512990013, 'Cynthia Randall', 'F', '1989-6-23', 'S', 05876454678, 'cynthia0@adventure-works.com', '1962 Ferndale Lane', 98028, 'Depok', 'Jawa Barat', '5333-5555-0111-7839', 'Cynthia Randall', 'Bukopin', 'CQAO', 48000000

EXEC spInsEmp 'FOUND', 3175042512990014, 'Kathie Flood', 'F', '1988-4-5', 'M', 057945687935, 'kathie0@adventure-works.com', '463 H Stagecoach Rd.', 98201, 'Bekasi', 'Jawa Barat', '3532-5565-0138-7284', 'Kathie Flood', 'Bukopin', 'MOO', 29000000
EXEC spInsEmp 'FOUND', 3175042512990015, 'Britta Simon', 'F', '1995-3-30', 'M', 06785787878, NULL, '2046 Las Palmas', NULL, 'Bekasi', 'Jawa Barat', '9535-5855-0169-8374', 'Britta Simon', 'Bukopin', 'OO', 19000000
EXEC spInsEmp 'FOUND', 3175042512990016, 'Brian Lloyd', 'M', '1996-1-1', 'S', 08357869703, NULL, '7230 Vine Maple Street', NULL, 'Tangerang', 'Banten', '1140-5559-0182-2638', 'Brian Lloyd', 'Bukopin', 'MAO', 27000000
EXEC spInsEmp 'FOUND', 3175042512990017, 'David Liu', 'M', '1995-12-31', 'M', 07394729475, NULL, '9605 Pheasant Circle', NULL, 'Jakarta', 'DKI Jakarta', '6436-5255-0185-2836', 'David Liu', 'Bukopin', 'AO', 17000000
EXEC spInsEmp 'FOUND', 3175042512990018, 'Laura Norman', 'F', '1993-3-22', 'S', 078563564587, NULL, '6937 E. 42nd Street', NULL, 'Bogor', 'Jawa Barat', '6146-5155-0185-1793', 'Laura Norman', 'Bukopin', 'MFMO', 24000000
EXEC spInsEmp 'FOUND', 3175042512990019, 'Michael Patten', 'M', '1991-11-11', 'M', 0264758647, NULL, '2038 Encino Drive', NULL, 'Depok', 'Jawa Barat', '6246-5525-1185-9729', 'Michael Patten', 'Bukopin', 'FMO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990020, 'Andy Ruth', 'F', '1993-9-20', 'M', 037492564967, NULL, '4777 Rockne Drive', NULL, 'Jakarta', 'DKI Jakarta', '6346-5575-0185-9183', 'Andy Ruth', 'Bukopin', 'MTIO', 21000000
EXEC spInsEmp 'FOUND', 3175042512990021, 'Yuhong Li', 'F', '1991-7-24', 'S', 073839428475, NULL, '502 Alexander Pl.', NULL, 'Bogor', NULL, '9165-5515-0155-2849', 'Yuhong Li', 'Bukopin', 'TIO', 11000000
EXEC spInsEmp 'FOUND', 3175042512990022, 'Robert Rounthwaite', 'M', '1987-8-17', 'M', 0637492549, NULL, '6843 San Simeon Dr.', NULL, 'Depok', 'Jawa Barat', '9675-5585-0185-8204', 'Robert Rounthwaite', 'Bukopin', 'MFO', 28000000
EXEC spInsEmp 'FOUND', 3175042512990023, 'Andreas Berglund', 'M', '1979-8-5', 'S', 0836384633, NULL, '1803 Olive Hill', NULL, 'Bekasi', 'Jawa Barat', '1981-5505-0124-8163', 'Andreas Berglund', 'Bukopin', 'FO', 18000000
EXEC spInsEmp 'FOUND', 3175042512990024, 'Reed Koch', 'M', '1980-5-26', 'M', 02648573548, NULL, '1275 West Street', NULL, 'Depok', 'Jawa Barat', '1861-5585-0124-2631', 'Reed Koch', 'Bukopin', 'MIO', 26000000

EXEC spInsEmp 'FOUND', 3175042512990025, 'Guy Gilbert', 'M', '1975-11-11', 'M', 085284843206, NULL, '7726 Driftwood Drive', NULL, 'Bogor', 'Jawa Barat', '2030-5155-0112-3934', 'Guy Gilbert', 'Bukopin', 'IO', 16000000
EXEC spInsEmp 'FOUND', 3175042512990026, 'Kevin Brown', 'M', '1978-6-2', 'M', 01837482939, NULL, '7883 Missing Canyon Court', NULL, 'Jakarta', 'DKI Jakarta', '2025-5355-0132-1033', 'Kevin Brown', 'Bukopin', 'MHRO', 27000000
EXEC spInsEmp 'FOUND', 3175042512990027, 'Roberto Tamburello', 'M', '1973-1-30', 'S', 08293648987, NULL, '2137 Birchwood Dr', NULL, 'Jakarta', 'DKI Jakarta', '6532-5155-0144-2233', 'Roberto Tamburello', 'Bukopin', 'HRO', 17000000
EXEC spInsEmp 'FOUND', 3175042512990028, 'Rob Walters', 'F', '1979-3-23', 'M', 01725374829, NULL, '5678 Lakeview Blvd.', NULL, 'Depok', 'Jawa Barat', '4137-5455-0154-1939', 'Rob Walters', 'Bukopin', 'MPDO', 24000000
EXEC spInsEmp 'FOUND', 3175042512990029, 'Thierry Hers', 'F', '1980-5-7', 'M', 07384926384, NULL, '1970 Napa Ct.', NULL, 'Depok', 'Jawa Barat', '9135-1555-0199-2933', 'Thierry Hers', 'Bukopin', 'PDO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990030, 'David Bradley', 'M', '1973-4-8', 'S', 08354758364, NULL, '3768 Door Way', NULL, 'Tangerang', 'Banten', '1820-5556-0136-5849', 'David Bradley', 'Bukopin', 'MCO', 25000000
EXEC spInsEmp 'FOUND', 3175042512990031, 'JoLynn Dobney', 'F', '1976-9-9', 'M', 08263748249, NULL, '7126 Ending Ct.', NULL, 'Tangerang', 'Banten', '5010-5515-0159-1928', 'JoLynn Dobney', 'Bukopin', 'CO', 15000000
EXEC spInsEmp 'FOUND', 3175042512990032, 'Ruth Ellerbrock', 'F', '1974-5-16', 'M', 0193946270, NULL, '2176 Apollo Way', NULL, 'Bogor', 'Jawa Barat', '9184-5155-0148-5932', 'Ruth Ellerbrock', 'Bukopin', 'MCSO', 26000000
EXEC spInsEmp 'FOUND', 3175042512990033, 'Gail Erickson', 'M', '1979-8-18', 'S', 02836282674, NULL, '9435 Breck Court', NULL, 'Bogor', 'Jawa Barat', '1533-5585-0111-2183', 'Gail Erickson', 'Bukopin', 'CSO', 16000000
EXEC spInsEmp 'FOUND', 3175042512990034, 'Barry Johnson', 'M', '1983-10-7', 'M', 04728946538, NULL, '3114 Notre Dame Ave.', NULL, 'Depok', 'Jawa Barat', '3512-5565-0138-5849', 'Barry Johnson', 'Bukopin', 'MLO', 22000000

EXEC spInsEmp 'FOUND', 3175042512990035, 'Angela Barbariol', 'F', '1976-11-30', 'S', 08394742928, NULL, '2687 Ridge Road', NULL, 'Jakarta', 'DKI Jakarta', '4224-5155-0189-2935', 'Angela Barbariol', 'Bukopin', 'LO', 12000000
EXEC spInsEmp 'FOUND', 3175042512990036, 'Jill Williams', 'F', '1977-1-28', 'M', 03825382283, NULL, '3238 Laguna Circle', NULL, 'Depok', 'Jawa Barat', '5018-5595-0165-8689', 'Jill Williams', 'Bukopin', 'MDCO', 23000000
EXEC spInsEmp 'FOUND', 3175042512990037, 'Diane Tibbott', 'F', '1983-5-7', 'M', 0836482637, NULL, '8192 Seagull Court', NULL, 'Bogor', 'Jawa Barat', '9874-5755-0185-1939', 'Diane Tibbott', 'Bukopin', 'DCO', 13000000
EXEC spInsEmp 'FOUND', 3175042512990038, 'François Ajenstat', 'F', '1980-2-12', 'M', 03794729274, NULL, '1144 Paradise Ct.', NULL, 'Depok', 'Jawa Barat', '6328-5055-0129-0865', 'François Ajenstat', 'Bukopin', 'MMO', 20000000
EXEC spInsEmp 'FOUND', 3175042512990039, 'Frank Lee', 'M', '1975-5-14', 'S', 037198373918, NULL, '8290 Margaret Ct.', NULL, 'Tangerang', 'Banten', '3128-5595-0150-9290', 'Frank Lee', 'Bukopin', 'MO', 10000000
EXEC spInsEmp 'FOUND', 3175042512990040, 'Paul Singh', 'M', '1976-4-24', 'S', 02729172981, NULL, '1343 Prospect St', NULL, 'Bekasi', 'Jawa Barat', '4325-5255-0113-2829', 'Paul Singh', 'Bukopin', 'MPRO', 24000000
EXEC spInsEmp 'FOUND', 3175042512990041, 'Gigi Matthew', 'M', '1979-5-5', 'M', 04948292849, NULL, '7808 Brown St.', NULL, 'Depok', 'Jawa Barat', '2012-5855-0151-1035', 'Gigi Matthew', 'Bukopin', 'PRO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990042, 'Marc Ingle', 'M', '1981-10-9', 'M', 08729294928, NULL, '2473 Orchard Way', NULL, 'Bekasi', 'Jawa Barat', '9125-5505-0114-4902', 'Marc Ingle', 'Bukopin', 'OO', 19000000
EXEC spInsEmp 'FOUND', 3175042512990043, 'Janeth Esteves', 'F', '1974-10-17', 'S', 08193859283, NULL, '4566 La Jolla', NULL, 'Tangerang', 'Banten', '9113-5575-0196-3822', 'Janeth Esteves', 'Bukopin', 'AO', 17000000
EXEC spInsEmp 'FOUND', 3175042512990044, 'Mark Harrington', 'M', '1977-8-11', 'S', 01719461944, NULL, '8585 Los Gatos Ct.', NULL, 'Jakarta', 'DKI Jakarta', '4133-5557-0136-3949', 'Mark Harrington', 'Bukopin', 'FMO', 14000000

EXEC spInsEmp 'FOUND', 3175042512990045, 'Zheng Mu', 'F', '1977-11-11', 'S', 08394849204, NULL, '6578 Woodhaven Ln.', NULL, 'Jakarta', 'DKI Jakarta', '1713-7555-0173-2130', 'Zheng Mu', 'Bukopin', 'TIO', 11000000
EXEC spInsEmp 'FOUND', 3175042512990046, 'Ivo Salmre', 'M', '1976-12-12', 'S', 08374274927, NULL, '3841 Silver Oaks Place', NULL, 'Bandung', 'Jawa Barat', '1415-5455-0179-2910', 'Ivo Salmre', 'Bukopin', 'FO', 18000000
EXEC spInsEmp 'FOUND', 3175042512990047, 'Ashvini Sharma', 'F', '1979-12-2', 'M', 0272847294, NULL, '7270 Pepper Way', NULL, 'Cirebon', 'Jawa Barat', '1247-5552-0160-1910', 'Ashvini Sharma', 'Bukopin', 'IO', 16000000
EXEC spInsEmp 'FOUND', 3175042512990048, 'Kendall Keil', 'M', '1986-12-3', 'M', 03628593455, NULL, '6580 Poor Ridge Court', NULL, 'Jakarta', 'DKI Jakarta', '1656-1555-0111-2829', 'Kendall Keil', 'Bukopin', 'HRO', 17000000
EXEC spInsEmp 'FOUND', 3175042512990049, 'Keil Barreto de Mattos', 'M', '1983-7-7', 'M', 02728482633, NULL, '7439 Laguna Niguel', NULL, 'Bandung', 'Jawa Barat', '9512-5585-0178-1992', 'Keil Barreto de Mattos', 'Bukopin', 'PDO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990050, 'Alejandro Alejandro', 'M', '1984-8-2', 'M', 03674828, NULL, '4311 Clay Rd', NULL, 'Cirebon', 'Jawa Barat', '1388-5558-0128-4903', 'Alejandro Alejandro', 'Bukopin', 'CO', 15000000
EXEC spInsEmp 'FOUND', 3175042512990051, 'Garrett Young', 'F', '1988-3-9', 'S', 02718163824, NULL, '7127 Los Gatos Court', 92834, 'Depok', 'Jawa Barat', '5213-5515-0173-1829', 'Garrett Young', 'Bukopin', 'CSO', 16000000
EXEC spInsEmp 'FOUND', 3175042512990052, 'Jian Shuo Wang', 'F', '1982-10-4', 'M', 02827189311, NULL, '2736 Scramble Rd', NULL, 'Bekasi', '9937-5515-0137-1920Jawa Barat', '6019-5553-0179-2929', 'Jian Shuo Wang', 'Bukopin', 'LO', 12000000
EXEC spInsEmp 'FOUND', 3175042512990053, 'Susan Eaton', 'F', '1987-3-29', 'S', 028584629496, NULL, '8310 Ridge Circle', NULL, 'Bogor', 'Jawa Barat', '9413-5557-0196-1829', 'Susan Eaton', 'Bukopin', 'DCO', 13000000
EXEC spInsEmp 'FOUND', 3175042512990054, 'Alice Ciccu', 'F', '1989-12-21', 'S', 028394729394, NULL, '2115 Passing Grade', NULL, 'Bandung', 'Jawa Barat', '9337-5515-0162-2324', 'Alice Ciccu', 'Bukopin', 'MO', 10000000
EXEC spInsEmp 'FOUND', 3175042512990055, 'Simon Rapier', 'M', '1980-6-24', 'M', 076362947393, 'simon0@adventure-works.com', '3421 Bouncing Road', NULL, 'Jakarta', 'DKI Jakarta ', '3333-5555-0173-8929', 'Simon Rapier', 'Bukopin', 'PRO', 14000000

EXEC spInsEmp 'FOUND', 3175042512990056, 'Stephanie Conroy', 'F', '1980-12-21', 'S', 072937194972, NULL, '7435 Ricardo', 91120, 'Jakarta', 'DKI Jakarta', '5934-5655-0110-8373', 'Stephanie Conroy', 'Bukopin', 'MSVO', 24000000
EXEC spInsEmp 'FOUND', 3175042512990057, 'Samantha Smith', 'M', '1979-12-21', 'M', 0193919382919, NULL, '1648 Eastgate Lane', NULL, 'Depok', 'Jawa Barat', '5287-5545-0114-9282', 'Samantha Smith', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990058, 'Tawana Nusbaum', 'F', '1983-12-21', 'S', 0278192719372, NULL, '9964 North Ridge Drive', NULL, 'Bogor', 'Jawa Barat', '3638-5535-0113-3525', 'Tawana Nusbaum', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990059, 'Denise Smith', 'F', '1985-12-21', 'M', 0828171936207, NULL, '5669 Ironwood Way', NULL, 'Tangerang', 'Banten', '9837-5595-2421-1920', 'Denise Smith', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990060, 'Hao Chen', 'F', '1982-12-21', 'S', 038936293723, NULL, '7691 Benedict Ct.', NULL, 'Bandung', 'Jawa Barat', '8291-5855-0115-8273', 'Hao Chen', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990061, 'Alex Nayberg', 'M', '1986-12-21', 'M', 091848793753, NULL, '1400 Gate Drive', NULL, 'Depok', 'Jawa Barat', '8306-5355-0136-8283', 'Alex Nayberg', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990062, 'Eugene Kogan', 'F', '1981-12-21', 'S', 018491748185, NULL, '991 Vista Verde', NULL, 'Bogor', 'Jawa Barat', '8129-5557-0198-9291', 'Eugene Kogan', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990063, 'Brandon Heidepriem', 'M', '1981-12-21', 'M', 027292747284, NULL, '8000 Crane Court', NULL, 'Bogor', 'Jawa Barat', '1723-5551-0179-7192', 'Brandon Heidepriem', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990064, 'Barbara Decker', 'M', '1984-12-21', 'M', 048719847472, NULL, '7939 Bayview Court', NULL, 'Depok', 'Jawa Barat', '4229-2555-0137-1902', 'Barbara Decker', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990065, 'Eugene Zabokritski', 'F', '1987-12-21', 'S', 038728163857, NULL, '3385 Crestview Drive', NULL, 'Jakarta', 'DKI Jakarta', '1219-5545-0192-9292', 'Eugene Zabokritski', 'Bukopin', 'SVO', 14000000
EXEC spInsEmp 'FOUND', 3175042512990066, 'Jeff Hay', 'F', '1982-12-21', 'S', 038161285728, NULL, '2275 Valley Blvd', NULL, 'Bandung', 'Jawa Barat', '2421-5552-0191-9304', 'Jeff Hay', 'Bukopin', 'SVO', 14000000


--Insert Room Type
SELECT * FROM Services.RoomType
CREATE PROC spInsRoomType @EID VARCHAR(5), @RTID VARCHAR(10), @RTN VARCHAR(100), @Price MONEY
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'COO' OR IncumbencyID = 'MFMO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		INSERT Services.RoomType(RTypeID, RTypeName, Price)
			VALUES(@RTID, @RTN, @Price);
		PRINT 'Room Type ' + @RTID + ' [' + @RTN + ']' + ' successfully Added +';
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'COO' AND IncumbencyID != 'MFMO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @RTID VARCHAR(10), @RTN VARCHAR(100), @Price MONEY

EXEC spInsRoomType 'E0016', 'R-I', 'Garden Apartement', 160000000
EXEC spInsRoomType 'E0016', 'R-II', 'Alcove Minimalist', 120000000
EXEC spInsRoomType 'E0016', 'R-III', 'Convertible', 110000000
EXEC spInsRoomType 'E0016', 'R-IV', '4Play Block', 150000000
EXEC spInsRoomType 'E0016', 'R-V', 'Loft Vintage', 130000000


--Insert Servant
SELECT * FROM Services.Servant
CREATE PROC spInsServ @EID VARCHAR(5), @EmpID VARCHAR(5), @RTID VARCHAR(10), @SC INT
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MFMO' OR IncumbencyID = 'MHRO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		DECLARE @SN VARCHAR(30)
		SELECT @SN = EmpName FROM HumanResources.Employee
		WHERE EmpID = @EmpID
		IF @EmpID = (
			SELECT EmpID FROM HumanResources.Employee
			WHERE IncumbencyID = 'SVO' AND EmpID = @EmpID)
				BEGIN
				INSERT Services.Servant
					VALUES(@SN, @EmpID, @RTID, @SC);				
				PRINT 'Servant Room Type ' + @RTID + ', ' + @EmpID + ' [' + @SN + ']' + ' successfully Added +';
				END
		ELSE 
			PRINT 'He/She is not a SERVANT!';
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFMO' AND IncumbencyID != 'MHRO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @EmpID VARCHAR(5), @RTID VARCHAR(10), @SC INT

EXEC spInsServ 'E0016', 'E0055', 'R-I', 911
EXEC spInsServ 'E0016', 'E0056', 'R-I', 911
EXEC spInsServ 'E0016', 'E0057', 'R-II', 922
EXEC spInsServ 'E0016', 'E0058', 'R-II', 922
EXEC spInsServ 'E0016', 'E0059', 'R-III', 933
EXEC spInsServ 'E0016', 'E0060', 'R-III', 933
EXEC spInsServ 'E0016', 'E0061', 'R-IV', 944
EXEC spInsServ 'E0016', 'E0062', 'R-IV', 944
EXEC spInsServ 'E0016', 'E0063', 'R-V', 955
EXEC spInsServ 'E0016', 'E0064', 'R-V', 955


--Insert RoomNum
SELECT * FROM Services.RoomNum
CREATE PROC spInsRoom @EID VARCHAR(5), @RTID VARCHAR(10), @BD VARCHAR(1), @Qty SMALLINT
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MFMO' OR IncumbencyID = 'FMO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN
		DECLARE @Count SMALLINT, @Num VARCHAR(2), @TP SMALLINT, @RN VARCHAR(5)
		SET @Count = 1
		SET @TP =
			CASE @RTID
				WHEN 'R-I' THEN 1
				WHEN 'R-II' THEN 2
				WHEN 'R-III' THEN 3
				WHEN 'R-IV' THEN 4
				WHEN 'R-V' THEN 5
				WHEN 'R-VI' THEN 6
				WHEN 'R-VII' THEN 7
				WHEN 'R-VIII' THEN 8
				WHEN 'R-IX' THEN 9
				ELSE 00
			END
		WHILE @Count <= @Qty
		BEGIN
			SET @Num = 
				CASE
					WHEN (@Count < 10) THEN '0'
					ELSE ''
				END	
			SET @Num = CAST(@Num AS VARCHAR(2)) + CAST(@Count AS VARCHAR(2))
			SET @RN = 'R' + @BD + CAST(@TP AS VARCHAR(1)) + CAST(@Num AS VARCHAR(2)) + @Num
			INSERT Services.RoomNum(RoomNum, RTypeID)
			VALUES(@RN, @RTID)
			SET @Count = CAST(@Count AS INT)
			SET @Count = @Count + 1;			
			PRINT 'Room Num ' + @RN + ' [Room Type ' + @RTID + ']' + ' successfully Added +';
		END
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MFMO' AND IncumbencyID != 'FMO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @RTID VARCHAR(10), @BD VARCHAR(1), @Qty SMALLINT

EXEC spInsRoom 'E0016', 'R-I', 'S', 10
EXEC spInsRoom 'E0016', 'R-II', 'S', 10
EXEC spInsRoom 'E0016', 'R-III', 'S', 10
EXEC spInsRoom 'E0016', 'R-IV', 'S', 10
EXEC spInsRoom 'E0016', 'R-V', 'S', 10
EXEC spInsRoom 'E0016', 'R-I', 'J', 10
EXEC spInsRoom 'E0016', 'R-II', 'J', 10
EXEC spInsRoom 'E0016', 'R-III', 'J', 10
EXEC spInsRoom 'E0016', 'R-IV', 'J', 10
EXEC spInsRoom 'E0016', 'R-V', 'J', 10


--Insert Transactions
ALTER PROC spInsTrans @EID VARCHAR(5), @RN VARCHAR(5), @POT INT, @DCIN DATETIME, @AP MONEY, @NIK BIGINT, @Name VARCHAR(30), @Gender VARCHAR(10), @DOB DATETIME, @Job VARCHAR(30),
						 @Telp BIGINT, @Email VARCHAR(100), @Add VARCHAR(200), @ZC INT, @City VARCHAR(30), @Prov VARCHAR(30), @AccNum VARCHAR(19), @AccName VARCHAR(30), @BName VARCHAR(30)
AS
IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID = 'MCSO' OR IncumbencyID = 'CSO') AND EmpID = @EID)
		--PRINT 'Access Allowed';
BEGIN		
		DECLARE @CustID VARCHAR(5)
		IF @NIK = (
				SELECT NIK FROM Users.Customer
				WHERE NIK = @NIK)
			BEGIN
				--Get Customer Data
				SELECT @CustID = CustID FROM Users.Customer
				WHERE NIK = @NIK
				SELECT @AccNum = AccountNum FROM Users.CustAccount
				WHERE CustID = @CustID	
			END

		ELSE 
			BEGIN
				--Insert Customer Data
				INSERT Users.Customer(NIK, CustName, Gender, DateOfBirth, Job)
					VALUES(@NIK, @Name, @Gender, @DOB, @Job);
		
				--<Batch Cust
				DECLARE @CountC INT, @Age INT
				SELECT @CountC = ID FROM Users.Customer
				WHERE CustID = '0'
				SET @CustID = (
					CASE
						WHEN (@CountC < 10) THEN 'C000'
						WHEN (@CountC >= 10) AND (@CountC < 100) THEN 'C00'
						WHEN (@CountC >= 100) AND (@CountC < 1000) THEN 'C0'
						WHEN (@CountC >= 1000) AND (@CountC < 10000) THEN 'C'
					END
					)
				SET @CustID = @CustID + CAST(@CountC AS VARCHAR(5))
				SET @Age = FLOOR(DATEDIFF(DAY, @DOB, GETDATE()) / 365.25)

				UPDATE Users.Customer
				SET CustID = @CustID,
					Age = @Age
				WHERE CustID = '0'
				--?>

				INSERT Users.CustContact
					VALUES(@CustID, @Telp, @Email);
				INSERT Users.CustAddress
					VALUES(@CustID, @Add, @ZC, @City, @Prov);
				INSERT Users.CustAccount
					VALUES(@CustID, @AccNum, @AccName, @BName);
			END
		
		--Insert Transaction Data
		INSERT Transactions.MainTrans(CustID, EmpID, RoomNum)
			VALUES(@CustID, @EID, @RN);

		--<Batch Trans
		DECLARE @CountT INT, @TransID VARCHAR(5), @DCOUT DATETIME, @TC MONEY, @Price MONEY, @DP MONEY, @DPDue DATETIME, @RP MONEY, @UP MONEY
		SELECT @CountT = ID FROM Transactions.MainTrans
		WHERE TransID = '0'
		SET @TransID = (
			CASE
				WHEN (@CountT < 10) THEN 'T000'
				WHEN (@CountT >= 10) AND (@CountT < 100) THEN 'T00'
				WHEN (@CountT >= 100) AND (@CountT < 1000) THEN 'T0'
				WHEN (@CountT >= 1000) AND (@CountT < 10000) THEN 'T'
			END
			)
		SET @TransID = @TransID + CAST(@CountT AS VARCHAR(5))

		SET @DCOUT = DATEADD(YEAR, @POT, CONVERT(DATE, @DCIN))
		SET @DPDue = (
					CASE
						WHEN (@DCIN <= DATEADD(DAY, 2, CONVERT(DATE, GETDATE()))) THEN @DCIN
						ELSE DATEADD(DAY, 2, CONVERT(DATE, GETDATE()))
					END)
		SELECT @Price = Price FROM Services.RoomType
		WHERE RTypeID = (
							SELECT T.RTypeID FROM Services.RoomType T
							INNER JOIN Services.RoomNum N
							ON T.RTypeID = N.RTypeID
							WHERE N.RoomNum = @RN
						)
		SET @TC = @Price * @POT --Total Cost/Invoice

		SET @DP = @TC * 0.1  --DP = 10% Total Cost
		SET @RP = @TC * 0.9  --Repayment = 90% Total Cost
		SET @UP	= @TC - @AP  --Check Transfer

		UPDATE Transactions.MainTrans
		SET TransID = @TransID
		WHERE TransID = '0'
		--?>
				
		INSERT Transactions.TransHistory(TransID)
			VALUES(@TransID);
		INSERT Transactions.CostRoom(RoomNum, PeriodOfTime, DateOfCheckIn, DateOfCheckOut, TotalCost)
			VALUES(@RN, @POT, @DCIN, @DCOUT, @TC);
		INSERT Transactions.Invoice(TransID, AccountNum, TotalInvoice, DP, DueDateDP, Repayment, DueDateRePay, AlreadyPaid, Unpaid)
			VALUES(@TransID, @AccNum, @TC, @DP, @DPDue, @RP, @DCIN, @AP, @UP);
		PRINT 'Transaction ' + @TransID + ' for booking room number ' + @RN + ' with Customer ID ' + @CustID + ' [' + @Name + ']' + ' successfully Added +';
END

ELSE IF @EID = (
	SELECT EmpID FROM vEmployee
	WHERE (IncumbencyID != 'MCSO' AND IncumbencyID != 'CSO') AND EmpID = @EID)
		PRINT 'You [' + CAST(@EID AS VARCHAR(5)) + '] are no Authorized !';
ELSE
	PRINT 'Unknown Employee ID [' + CAST(@EID AS VARCHAR(5)) + '] !!!';
GO

--Hint >> @EID VARCHAR(5), @RN VARCHAR(5), @POT INT, @DCIN DATETIME, @AP MONEY, @NIK BIGINT, @Name VARCHAR(30), @Gender VARCHAR(10), @DOB DATETIME, @Job VARCHAR(30),
--			 @Telp BIGINT, @Email VARCHAR(100), @Add VARCHAR(200), @ZC INT, @City VARCHAR(30), @Prov VARCHAR(30), @AccNum VARCHAR(19), @AccName VARCHAR(30), @BName VARCHAR(30)

EXEC spInsTrans 'E0031', 'RS102', 1, '2018-01-04', 0, '3175041708450001', 'Johanes Chandra', 'M', '1990-08-17', 'Entrepreneur', 
					085214149801, 'johanes.chandra@geevv.com', 'Jl Jendral Sudirman No 10', 14045, 'Padang', 'Sumatra Barat', '1650-1780-1605-2018', 'Johanes Chandra', 'BCA'
EXEC spInsTrans 'E0031', 'RS203', 2, '2018-01-08', 0, '3175041708450002', 'Diaz Rivaldo', 'M', '1988-05-16', 'Employee', 
					082929192012, 'diaz.rivaldo@geevv.com', 'Jl Manggis Raya No 6', 14022, 'Sentolo', 'Yogyakarta', '7829-2839-1042-1040', 'Diaz Rivaldo', 'BRI'
EXEC spInsTrans 'E0031', 'RS304', 3, '2018-01-07', 0, '3175041708450003', 'Sabrina Anisa', 'F', '1995-12-25', 'Doctor', 
					087829289292, 'sabrina.anisa@geevv.com', 'Jl Jendral Sudirman No 10', 50505, 'Manado', 'Sulawesi Utara', '1728-1718-1931-4921', 'Sabrina Anisa', 'BNI'
EXEC spInsTrans 'E0031', 'RS405', 4, '2018-01-06', 0, '3175041708450004', 'Kevin Kautsar', 'M', '1986-04-21', 'Actor', 
					088382948582, 'kevin.kautsar@geevv.com', 'Jl Jaksa Agung Suprapto No 1', 91100, 'Jakarta', 'DKI Jakarta', '2719-2819-1921-1912', 'Kevin Kautsar', 'MEGA'
EXEC spInsTrans 'E0031', 'RS501', 5, '2018-01-10', 0, '3175041708450005', 'Adni Alydrus', 'F', '1980-12-22', 'Lecturer', 
					085592948393, 'adni.alydrus@geevv.com', 'Jl Condet Raya No 6', 11200, 'Bandung', 'Jawa Barat', '2910-1936-2919-3242', 'Adni Alydrus', 'BTN'
EXEC spInsTrans 'E0031', 'RJ110', 1, '2018-01-09', 0, '3175041708450006', 'Faisal Rahman', 'M', '1984-01-03', 'Teacher', 
					088284929293, 'faisal.rahman@contoso.com', 'Jl Juanda No 7', 12345, 'Medan', 'Sumatra Utara', '2371-6321-6235-2562', 'Faisal Rahman', 'CIMB'
EXEC spInsTrans 'E0031', 'RJ209', 6, '2018-01-04', 0, '3175041708450007', 'Bunga Sartika', 'F', '1987-09-02', 'Trader', 
					088305949394, 'bunga.sartika@harvard.edu', 'Jl Walkstreet No 10', 67890, 'Surabaya', 'Jawa Timur', '4577-5413-4332-7542', 'Bunga Sartika', 'Mandiri'
EXEC spInsTrans 'E0031', 'RJ308', 5, '2018-01-08', 0, '3175041708450008', 'Iqbal Nugroho', 'M', '1976-09-11', 'Scientist', 
					084894930390, 'iqbal.nugroho@farma.biz', 'Jl Raya Bogor No 78', 16058, 'Jakarta', 'DKI Jakarta', '1035-2246-6442-4363', 'Iqbal Nugroho', 'Bank DKI'
EXEC spInsTrans 'E0031', 'RJ407', 1, '2018-01-07', 0, '3175041708450009', 'Farhan Ramadhan', 'M', '1990-12-21', 'Police', 
					088493090203, 'farhan.ramadhan@eng.ui.ac.id ', 'Jl Djoko Anwar', 16518, 'Flores', 'Nusa Tenggara Timur', '3813-7268-2819-1391', 'Farhan Ramadhan', 'BJB'
EXEC spInsTrans 'E0031', 'RJ506', 7, '2018-01-06', 0, '3175041708450010', 'Trisya Talia', 'F', '1985-12-12', 'Lawyer', 
					083983893938, 'trisya.talia@yooho.co.id', 'Jl Gelora Bung Karno', 17818, 'Pontianak', 'Kalimantan Barat', '5229-1361-5321-4212', 'Trisya Talia', 'Bukopin'
EXEC spInsTrans 'E0031', 'RJ206', 8, '2018-01-05', 0, '3175041708450009', 'Farhan Ramadhan', 'M', '1990-12-21', 'Police', 
					088493090203, 'farhan.ramadhan@eng.ui.ac.id ', 'Jl Djoko Anwar', 16518, 'Flores', 'Nusa Tenggara Timur', '3813-7268-2819-1391', 'Farhan Ramadhan', 'BJB'
EXEC spInsTrans 'E0031', 'RJ306', 1, '2018-01-04', 0, '3175041708450011', 'Tevin Dean Ramadhan', 'M', '1991-11-11', 'Freelancer', 
					089297301048, 'tevin.dean.ramadhan@eng.ui.ac.id ', 'Jl Djoko Susilo', 16594, 'Malang', 'Jawa Timur', '6990-2442-6126-5367', 'Tevin Dean Ramadhan', 'DBS'



-------------------------------------------------------------
--------------------------------------------------------

EXEC spInsRoomType 'E0016', 'R-I', 'Garden Apartement', 160000000
EXEC spInsRoomType 'E0016', 'R-II', 'Alcove Minimalist', 120000000
EXEC spInsRoomType 'E0016', 'R-III', 'Convertible', 110000000
EXEC spInsRoomType 'E0016', 'R-IV', '4Play Block', 150000000
EXEC spInsRoomType 'E0016', 'R-V', 'Loft Vintage', 130000000

EXEC spInsServ 'E0016', 'E0055', 'R-I', 911
EXEC spInsServ 'E0016', 'E0056', 'R-I', 911
EXEC spInsServ 'E0016', 'E0057', 'R-II', 922
EXEC spInsServ 'E0016', 'E0058', 'R-II', 922
EXEC spInsServ 'E0016', 'E0059', 'R-III', 933
EXEC spInsServ 'E0016', 'E0060', 'R-III', 933
EXEC spInsServ 'E0016', 'E0061', 'R-IV', 944
EXEC spInsServ 'E0016', 'E0062', 'R-IV', 944
EXEC spInsServ 'E0016', 'E0063', 'R-V', 955
EXEC spInsServ 'E0016', 'E0064', 'R-V', 955

EXEC spInsRoom 'E0016', 'R-I', 'S', 10
EXEC spInsRoom 'E0016', 'R-II', 'S', 10
EXEC spInsRoom 'E0016', 'R-III', 'S', 10
EXEC spInsRoom 'E0016', 'R-IV', 'S', 10
EXEC spInsRoom 'E0016', 'R-V', 'S', 10
EXEC spInsRoom 'E0016', 'R-I', 'J', 10
EXEC spInsRoom 'E0016', 'R-II', 'J', 10
EXEC spInsRoom 'E0016', 'R-III', 'J', 10
EXEC spInsRoom 'E0016', 'R-IV', 'J', 10
EXEC spInsRoom 'E0016', 'R-V', 'J', 10

EXEC spInsTrans 'E0031', 'RS102', 1, '2018-01-04', 0, '3175041708450001', 'Johanes Chandra', 'M', '1990-08-17', 'Entrepreneur', 
					085214149801, 'johanes.chandra@geevv.com', 'Jl Jendral Sudirman No 10', 14045, 'Padang', 'Sumatra Barat', '1650-1780-1605-2018', 'Johanes Chandra', 'BCA'
EXEC spInsTrans 'E0031', 'RS203', 2, '2018-01-08', 0, '3175041708450002', 'Diaz Rivaldo', 'M', '1988-05-16', 'Employee', 
					082929192012, 'diaz.rivaldo@geevv.com', 'Jl Manggis Raya No 6', 14022, 'Sentolo', 'Yogyakarta', '7829-2839-1042-1040', 'Diaz Rivaldo', 'BRI'
EXEC spInsTrans 'E0031', 'RS304', 3, '2018-01-07', 0, '3175041708450003', 'Sabrina Anisa', 'F', '1995-12-25', 'Doctor', 
					087829289292, 'sabrina.anisa@geevv.com', 'Jl Jendral Sudirman No 10', 50505, 'Manado', 'Sulawesi Utara', '1728-1718-1931-4921', 'Sabrina Anisa', 'BNI'
EXEC spInsTrans 'E0031', 'RS405', 4, '2018-01-06', 0, '3175041708450004', 'Kevin Kautsar', 'M', '1986-04-21', 'Actor', 
					088382948582, 'kevin.kautsar@geevv.com', 'Jl Jaksa Agung Suprapto No 1', 91100, 'Jakarta', 'DKI Jakarta', '2719-2819-1921-1912', 'Kevin Kautsar', 'MEGA'
EXEC spInsTrans 'E0031', 'RS501', 5, '2018-01-10', 0, '3175041708450005', 'Adni Alydrus', 'F', '1980-12-22', 'Lecturer', 
					085592948393, 'adni.alydrus@geevv.com', 'Jl Condet Raya No 6', 11200, 'Bandung', 'Jawa Barat', '2910-1936-2919-3242', 'Adni Alydrus', 'BTN'
EXEC spInsTrans 'E0031', 'RJ110', 1, '2018-01-09', 0, '3175041708450006', 'Faisal Rahman', 'M', '1984-01-03', 'Teacher', 
					088284929293, 'faisal.rahman@contoso.com', 'Jl Juanda No 7', 12345, 'Medan', 'Sumatra Utara', '2371-6321-6235-2562', 'Faisal Rahman', 'CIMB'
EXEC spInsTrans 'E0031', 'RJ209', 6, '2018-01-04', 0, '3175041708450007', 'Bunga Sartika', 'F', '1987-09-02', 'Trader', 
					088305949394, 'bunga.sartika@harvard.edu', 'Jl Walkstreet No 10', 67890, 'Surabaya', 'Jawa Timur', '4577-5413-4332-7542', 'Bunga Sartika', 'Mandiri'
EXEC spInsTrans 'E0031', 'RJ308', 5, '2018-01-08', 0, '3175041708450008', 'Iqbal Nugroho', 'M', '1976-09-11', 'Scientist', 
					084894930390, 'iqbal.nugroho@farma.biz', 'Jl Raya Bogor No 78', 16058, 'Jakarta', 'DKI Jakarta', '1035-2246-6442-4363', 'Iqbal Nugroho', 'Bank DKI'
EXEC spInsTrans 'E0031', 'RJ407', 1, '2018-01-05', 0, '3175041708450009', 'Farhan Ramadhan', 'M', '1990-12-21', 'Police', 
					088493090203, 'farhan.ramadhan@eng.ui.ac.id ', 'Jl Djoko Anwar', 16518, 'Flores', 'Nusa Tenggara Timur', '3813-7268-2819-1391', 'Farhan Ramadhan', 'BJB'
EXEC spInsTrans 'E0031', 'RJ506', 7, '2018-01-06', 0, '3175041708450010', 'Trisya Talia', 'F', '1985-12-12', 'Lawyer', 
					083983893938, 'trisya.talia@yooho.co.id', 'Jl Gelora Bung Karno', 17818, 'Pontianak', 'Kalimantan Barat', '5229-1361-5321-4212', 'Trisya Talia', 'Bukopin'
EXEC spInsTrans 'E0031', 'RJ206', 8, '2018-01-05', 0, '3175041708450009', 'Farhan Ramadhan', 'M', '1990-12-21', 'Police', 
					088493090203, 'farhan.ramadhan@eng.ui.ac.id ', 'Jl Djoko Anwar', 16518, 'Flores', 'Nusa Tenggara Timur', '3813-7268-2819-1391', 'Farhan Ramadhan', 'BJB'
EXEC spInsTrans 'E0031', 'RJ306', 1, '2018-01-04', 0, '3175041708450011', 'Tevin Dean Ramadhan', 'M', '1991-11-11', 'Freelancer', 
					089297301048, 'tevin.dean.ramadhan@eng.ui.ac.id ', 'Jl Djoko Susilo', 16594, 'Malang', 'Jawa Timur', '6990-2442-6126-5367', 'Tevin Dean Ramadhan', 'DBS'

----------------------------------------------------------------
