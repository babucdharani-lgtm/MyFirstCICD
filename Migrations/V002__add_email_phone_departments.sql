-- V002: Add Email, Phone to Employees + Create Department table

-- 1. Add new columns to Employees
ALTER TABLE dbo.Employees
    ADD Email       NVARCHAR(200) NULL,
        Phone       NVARCHAR(20)  NULL,
        ManagerID   INT           NULL;
GO

-- 2. Create new Department table
CREATE TABLE dbo.Departments (
    DepartmentID   INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    Location       NVARCHAR(100) NULL,
    CreatedDate    DATETIME DEFAULT GETDATE()
);
GO

-- 3. Insert sample departments
INSERT INTO dbo.Departments (DepartmentName, Location)
VALUES
    ('IT',      'Floor 1'),
    ('HR',      'Floor 2'),
    ('Finance', 'Floor 3');
GO

-- 4. Update procedure to include new columns
CREATE OR ALTER PROCEDURE dbo.usp_GetEmployees
    @Department NVARCHAR(100) = NULL
AS
BEGIN
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.Department,
        e.Salary,
        e.Email,
        e.Phone,
        e.CreatedDate
    FROM dbo.Employees e
    WHERE (@Department IS NULL OR e.Department = @Department);
END;
GO

-- 5. New procedure to get departments
CREATE OR ALTER PROCEDURE dbo.usp_GetDepartments
AS
BEGIN
    SELECT DepartmentID, DepartmentName, Location
    FROM dbo.Departments
    ORDER BY DepartmentName;
END;
GO

PRINT 'V002 - Email, Phone, Departments added successfully';