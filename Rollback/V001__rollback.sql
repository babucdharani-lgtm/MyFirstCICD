-- ROLLBACK SCRIPT FOR V001
-- Run this to completely remove initial schema
-- WARNING: This drops all tables — all data will be lost

PRINT 'Starting V001 rollback...';

-- Drop procedures first
IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'usp_GetEmployees')
BEGIN
    DROP PROCEDURE dbo.usp_GetEmployees;
    PRINT 'ROLLBACK: usp_GetEmployees dropped';
END

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'usp_GetDepartments')
BEGIN
    DROP PROCEDURE dbo.usp_GetDepartments;
    PRINT 'ROLLBACK: usp_GetDepartments dropped';
END

-- Drop tables
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Departments')
BEGIN
    DROP TABLE dbo.Departments;
    PRINT 'ROLLBACK: Departments table dropped';
END

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Employees')
BEGIN
    DROP TABLE dbo.Employees;
    PRINT 'ROLLBACK: Employees table dropped';
END

PRINT '================================================';
PRINT 'V001 ROLLBACK COMPLETED SUCCESSFULLY';
PRINT 'Database is now empty';
PRINT '================================================';