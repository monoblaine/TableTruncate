-- =============================================
-- Author:		Flavio Robles & Eduardo Cuomo
-- Create date:	19/01/2015
-- Description:	Truncate Table para tablas con FK, que no permiten el uso de "TRUNCATE".
-- =============================================
CREATE PROCEDURE [dbo].[TableTruncate]
	@TableName NVARCHAR(128)
AS

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

BEGIN TRAN

DECLARE @Sql NVARCHAR(MAX) = 'DELETE FROM [' + @TableName + ']'
EXECUTE sp_executesql @Sql

IF (@@ERROR = 0) BEGIN
	-- Si NO hay error
	DBCC CHECKIDENT (@TableName, RESEED, 0)
	
	DECLARE @NextId NUMERIC = CASE WHEN (IDENT_CURRENT(@TableName) = 1) THEN 1 ELSE 0 END
	DBCC CHECKIDENT (@TableName, RESEED, @NextId)
	
	COMMIT TRAN
END ELSE BEGIN
	-- Error
	ROLLBACK
END