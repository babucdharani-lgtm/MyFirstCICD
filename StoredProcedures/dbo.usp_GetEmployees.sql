CREATE OR ALTER PROCEDURE dbo.usp_GetEmployees
    @Department NVARCHAR(100) = NULL
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, Department, Salary
    FROM dbo.Employees
    WHERE (@Department IS NULL OR Department = @Department);
END;