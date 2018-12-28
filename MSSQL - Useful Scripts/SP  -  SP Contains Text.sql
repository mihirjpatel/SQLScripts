/*********************************************************************************

Get all SP ONLY which contains given text  (similar to SQL Search by Reddit but only SP show)

*********************************************************************************/

SELECT DISTINCT OBJECT_NAME(OBJECT_ID),
object_definition(OBJECT_ID)
FROM sys.Procedures
WHERE object_definition(OBJECT_ID) LIKE '%' + 'material' + '%'
GO


/*********************************************************************************

Get all SP/Functions ECT. which contains given text  (similar to SQL Search by Reddit)

*********************************************************************************/

SELECT DISTINCT  o.name, o.xtype--, c.text
FROM syscomments c
INNER JOIN sysobjects o ON c.id=o.id
WHERE c.TEXT LIKE '%material%'
GO

