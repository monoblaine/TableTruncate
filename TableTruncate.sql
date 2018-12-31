-- =============================================
-- Author:	Eduardo Cuomo
-- Create date:	19/01/2015
-- Description:	Truncate Table.
-- =============================================
CREATE PROCEDURE [dbo].[TableTruncate]
	@TableName NVARCHAR(128)
AS

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

BEGIN TRAN

DECLARE @TableNameDelimited NVARCHAR(128) = CASE WHEN @TableName LIKE '%[.\]"'']' ESCAPE '\' THEN @TableName ELSE '[' + @TableName + ']' END
DECLARE @NextId NUMERIC = CASE WHEN (IDENT_CURRENT(@TableNameDelimited) = 1) THEN 1 ELSE 0 END
DECLARE @Sql NVARCHAR(MAX) = 'DELETE FROM ' + @TableNameDelimited
EXECUTE sp_executesql @Sql

IF (@@ERROR = 0) BEGIN
	DBCC CHECKIDENT (@TableNameDelimited, RESEED, @NextId)
	
	COMMIT TRAN
END ELSE BEGIN
	-- Error
	ROLLBACK
END
