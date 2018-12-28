/*********************************************************************************

Get all SP/Functions ECT. which contains given text  (similar to SQL Search by Reddit)

*********************************************************************************/

SELECT DISTINCT  o.name, o.xtype--, c.text
FROM syscomments c
INNER JOIN sysobjects o ON c.id=o.id
WHERE c.TEXT LIKE '%material%'
GO



/*********************************************************************************

Get all SP ONLY which contains given text  (similar to SQL Search by Reddit but only SP show)

*********************************************************************************/

SELECT DISTINCT OBJECT_NAME(OBJECT_ID),
object_definition(OBJECT_ID)
FROM sys.Procedures
WHERE object_definition(OBJECT_ID) LIKE '%' + 'material' + '%'
GO







/*********************************************************************************

		Viewes that are possibly not being used (not in cached plan)

*********************************************************************************/

SELECT v.name [ViewName]
FROM sys.views v
WHERE v.is_ms_shipped = 0

EXCEPT SELECT o.Name [ViewName]
FROM master.sys.dm_exec_cached_plans p
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) t
INNER JOIN sys.objects o ON t.objectid = o.object_id
WHERE t.dbid = DB_ID()
GO


/*********************************************************************************

		Get all dependencies and details. (referenced object dependencies)

*********************************************************************************/

SELECT
referencing_schema_name = SCHEMA_NAME(o.SCHEMA_ID),
referencing_object_name = o.name,
referencing_object_type_desc = o.type_desc,
referenced_schema_name,
referenced_object_name = referenced_entity_name,
referenced_object_type_desc = o1.type_desc,
referenced_server_name, referenced_database_name
--,sed.* -- Uncomment for all the columns
FROM
sys.sql_expression_dependencies sed
INNER JOIN
sys.objects o ON sed.referencing_id = o.[object_id]
LEFT OUTER JOIN
sys.objects o1 ON sed.referenced_id = o1.[object_id]
WHERE
referenced_entity_name = 'material'
order by referencing_object_name
GO

/*********************************************************************************

		Get all dependencies and details. (referencing object dependencies)

*********************************************************************************/

SELECT
referencing_schema_name = SCHEMA_NAME(o.SCHEMA_ID),
referencing_object_name = o.name,
referencing_object_type_desc = o.type_desc,
referenced_schema_name,
referenced_object_name = referenced_entity_name,
referenced_object_type_desc = o1.type_desc,
referenced_server_name, referenced_database_name
--,sed.* -- Uncomment for all the columns
FROM
sys.sql_expression_dependencies sed
INNER JOIN
sys.objects o ON sed.referencing_id = o.[object_id]
LEFT OUTER JOIN
sys.objects o1 ON sed.referenced_id = o1.[object_id]
WHERE
o.name = 'PDBCommonOrderDetailWithLoginGet'
GO

/*********************************************************************************

								SP Last Executed

*********************************************************************************/


select b.name, a.last_execution_time
from sys.dm_exec_procedure_stats a 
inner join sys.objects b on a.object_id = b.object_id 
where DB_NAME(a.database_ID) = 'Artnet_ny'
order by last_execution_time desc
GO

select * from sys.dm_os_buffer_descriptors
/*********************************************************************************

						Get list of all SPs in the current database

*********************************************************************************/

SELECT p.name AS 'SP Name', p.create_date, p.modify_date   
FROM sys.procedures AS p
WHERE p.is_ms_shipped = 0
ORDER BY p.name;
GO


/*********************************************************************************

				Get list of possibly unused SPs (SPs which are not cached)

*********************************************************************************/
SELECT p.name AS 'SP Name'        -- Get list of all SPs in the current database
FROM sys.procedures AS p
WHERE p.is_ms_shipped = 0
	
EXCEPT
    
SELECT p.name AS 'SP Name'        -- Get list of all SPs from the current database 
FROM sys.procedures AS p          -- that are in the procedure cache
INNER JOIN sys.dm_exec_procedure_stats AS qs
ON p.object_id = qs.object_id
WHERE p.is_ms_shipped = 0;
GO




/*********************************************************************************

	Find which Stored Procedures use a particular index based on cached plans
					**Also shows stats on the execution**
*********************************************************************************/

select DB_NAME(database_id) as Database_Name, object_name(object_id) as ObjectName, s.* 
from sys.dm_exec_procedure_stats s 
	cross apply sys.dm_exec_query_plan(s.plan_handle) b
where convert(nvarchar(max),b.query_plan) like '%IX_NCL_Lot_CollID_CLN_FeaturedLot_AhWeb%'
GO