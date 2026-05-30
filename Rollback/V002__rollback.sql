-- ROLLBACK SCRIPT FOR V002
-- Run this if V002 deployment causes issues
-- This undoes everything V002 added

PRINT 'Starting V002 rollback...';

-- Step 1: Drop new procedure
IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'usp_GetDepartments')
BEGIN
    DROP PROCEDURE dbo.usp_GetDepartments;
    PRINT 'ROLLBACK: usp_GetDepartments dropped';
END

-- Step 2: Restore original procedure (without Email, Phone)
CREATE OR ALTER PROCEDURE dbo.usp_GetEmployees
    @Department NVARCHAR(100) = NULL
AS
BEGIN
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        Department,
        Salary,
        CreatedDate
    FROM dbo.Employees
    WHERE (@Department IS NULL OR Department = @Department);
END;
GO
PRINT 'ROLLBACK: usp_GetEmployees restored to original';

-- Step 3: Drop Departments table
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Departments')
BEGIN
    DROP TABLE dbo.Departments;
    PRINT 'ROLLBACK: Departments table dropped';
END

-- Step 4: Remove new columns from Employees
IF EXISTS (SELECT 1 FROM sys.columns
           WHERE object_id = OBJECT_ID('dbo.Employees')
           AND name = 'Phone')
BEGIN
    ALTER TABLE dbo.Employees DROP COLUMN Phone;
    PRINT 'ROLLBACK: Phone column removed';
END

IF EXISTS (SELECT 1 FROM sys.columns
           WHERE object_id = OBJECT_ID('dbo.Employees')
           AND name = 'Email')
BEGIN
    ALTER TABLE dbo.Employees DROP COLUMN Email;
    PRINT 'ROLLBACK: Email column removed';
END

IF EXISTS (SELECT 1 FROM sys.columns
           WHERE object_id = OBJECT_ID('dbo.Employees')
           AND name = 'ManagerID')
BEGIN
    ALTER TABLE dbo.Employees DROP COLUMN ManagerID;
    PRINT 'ROLLBACK: ManagerID column removed';
END

PRINT '================================================';
PRINT 'V002 ROLLBACK COMPLETED SUCCESSFULLY';
PRINT 'Database restored to V001 state';
PRINT '================================================';