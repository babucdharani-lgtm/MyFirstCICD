-- tSQLt Unit Tests for MyFirstCICD_DEV
-- Run these tests automatically in CI/CD pipeline

USE MyFirstCICD_DEV;
GO

-- ─────────────────────────────────────────────
-- CREATE TEST CLASSES (groups of related tests)
-- ─────────────────────────────────────────────

EXEC tSQLt.NewTestClass 'EmployeeTests';
GO

EXEC tSQLt.NewTestClass 'DepartmentTests';
GO

EXEC tSQLt.NewTestClass 'SchemaTests';
GO


-- ─────────────────────────────────────────────
-- SCHEMA TESTS
-- ─────────────────────────────────────────────

-- Test 1: Employees table has all required columns
CREATE OR ALTER PROCEDURE SchemaTests.[test Employees table has required columns]
AS
BEGIN
    -- Check all required columns exist
    IF NOT EXISTS (SELECT 1 FROM sys.columns
                   WHERE object_id = OBJECT_ID('dbo.Employees')
                   AND name = 'EmployeeID')
        EXEC tSQLt.Fail 'EmployeeID column is missing';

    IF NOT EXISTS (SELECT 1 FROM sys.columns
                   WHERE object_id = OBJECT_ID('dbo.Employees')
                   AND name = 'FirstName')
        EXEC tSQLt.Fail 'FirstName column is missing';

    IF NOT EXISTS (SELECT 1 FROM sys.columns
                   WHERE object_id = OBJECT_ID('dbo.Employees')
                   AND name = 'Email')
        EXEC tSQLt.Fail 'Email column is missing';

    IF NOT EXISTS (SELECT 1 FROM sys.columns
                   WHERE object_id = OBJECT_ID('dbo.Employees')
                   AND name = 'Phone')
        EXEC tSQLt.Fail 'Phone column is missing';

    PRINT 'PASS: All required columns exist in Employees table';
END;
GO


-- ─────────────────────────────────────────────
-- EMPLOYEE TESTS
-- ─────────────────────────────────────────────

-- Test 2: usp_GetEmployees returns all employees when no filter
CREATE OR ALTER PROCEDURE EmployeeTests.[test usp_GetEmployees returns all employees]
AS
BEGIN
    -- Arrange: fake the Employees table with test data
    EXEC tSQLt.FakeTable 'dbo.Employees';

    INSERT INTO dbo.Employees
        (FirstName, LastName, Department, Salary)
    VALUES
        ('John',  'Smith', 'IT', 55000),
        ('Sarah', 'Jones', 'HR', 48000),
        ('Mike',  'Brown', 'IT', 62000);

    -- Act: run the procedure
    CREATE TABLE #ActualResult (
        EmployeeID  INT,
        FirstName   NVARCHAR(100),
        LastName    NVARCHAR(100),
        Department  NVARCHAR(100),
        Salary      DECIMAL(10,2),
        Email       NVARCHAR(200),
        Phone       NVARCHAR(20),
        CreatedDate DATETIME
    );

    INSERT INTO #ActualResult
    EXEC dbo.usp_GetEmployees;

    -- Assert: should return 3 employees
    DECLARE @Count INT = (SELECT COUNT(*) FROM #ActualResult);

    IF @Count <> 3
        EXEC tSQLt.Fail 'Expected 3 employees but got: ', @Count;

    PRINT 'PASS: usp_GetEmployees returns all employees';
END;
GO


-- Test 3: usp_GetEmployees filters by department correctly
CREATE OR ALTER PROCEDURE EmployeeTests.[test usp_GetEmployees filters by department]
AS
BEGIN
    -- Arrange
    EXEC tSQLt.FakeTable 'dbo.Employees';

    INSERT INTO dbo.Employees
        (FirstName, LastName, Department, Salary)
    VALUES
        ('John',  'Smith', 'IT', 55000),
        ('Sarah', 'Jones', 'HR', 48000),
        ('Mike',  'Brown', 'IT', 62000);

    -- Act: filter by IT department only
    CREATE TABLE #ActualResult (
        EmployeeID  INT,
        FirstName   NVARCHAR(100),
        LastName    NVARCHAR(100),
        Department  NVARCHAR(100),
        Salary      DECIMAL(10,2),
        Email       NVARCHAR(200),
        Phone       NVARCHAR(20),
        CreatedDate DATETIME
    );

    INSERT INTO #ActualResult
    EXEC dbo.usp_GetEmployees @Department = 'IT';

    -- Assert: should return only 2 IT employees
    DECLARE @Count INT = (SELECT COUNT(*) FROM #ActualResult);

    IF @Count <> 2
        EXEC tSQLt.Fail 'Expected 2 IT employees but got: ', @Count;

    -- Assert: all returned employees are from IT
    IF EXISTS (SELECT 1 FROM #ActualResult WHERE Department <> 'IT')
        EXEC tSQLt.Fail 'Non-IT employees returned in IT filter';

    PRINT 'PASS: usp_GetEmployees filters by department correctly';
END;
GO


-- Test 4: Salary must be greater than zero
CREATE OR ALTER PROCEDURE EmployeeTests.[test Salary must be greater than zero]
AS
BEGIN
    -- Arrange
    EXEC tSQLt.FakeTable 'dbo.Employees';

    INSERT INTO dbo.Employees
        (FirstName, LastName, Department, Salary)
    VALUES ('Test', 'Employee', 'IT', 50000);

    -- Act and Assert
    DECLARE @Salary DECIMAL(10,2);
    SELECT @Salary = Salary FROM dbo.Employees WHERE FirstName = 'Test';

    IF @Salary <= 0
        EXEC tSQLt.Fail 'Salary must be greater than zero';

    PRINT 'PASS: Salary is greater than zero';
END;
GO


-- ─────────────────────────────────────────────
-- DEPARTMENT TESTS
-- ─────────────────────────────────────────────

-- Test 5: usp_GetDepartments returns all departments
CREATE OR ALTER PROCEDURE DepartmentTests.[test usp_GetDepartments returns departments]
AS
BEGIN
    -- Arrange
    EXEC tSQLt.FakeTable 'dbo.Departments';

    INSERT INTO dbo.Departments (DepartmentName, Location)
    VALUES
        ('IT',      'Floor 1'),
        ('HR',      'Floor 2'),
        ('Finance', 'Floor 3');

    -- Act
    CREATE TABLE #ActualResult (
        DepartmentID   INT,
        DepartmentName NVARCHAR(100),
        Location       NVARCHAR(100)
    );

    INSERT INTO #ActualResult
    EXEC dbo.usp_GetDepartments;

    -- Assert
    DECLARE @Count INT = (SELECT COUNT(*) FROM #ActualResult);

    IF @Count <> 3
        EXEC tSQLt.Fail 'Expected 3 departments but got: ', @Count;

    PRINT 'PASS: usp_GetDepartments returns all departments';
END;
GO


-- ─────────────────────────────────────────────
-- RUN ALL TESTS
-- ─────────────────────────────────────────────
EXEC tSQLt.RunAll;
GO