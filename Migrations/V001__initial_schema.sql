-- V001: Initial schema

CREATE TABLE dbo.Employees (
    EmployeeID   INT IDENTITY(1,1) PRIMARY KEY,
    FirstName    NVARCHAR(100) NOT NULL,
    LastName     NVARCHAR(100) NOT NULL,
    Department   NVARCHAR(100),
    Salary       DECIMAL(10,2),
    CreatedDate  DATETIME DEFAULT GETDATE()
);
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetEmployees
    @Department NVARCHAR(100) = NULL
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, Department, Salary
    FROM dbo.Employees
    WHERE (@Department IS NULL OR Department = @Department);
END;
GO