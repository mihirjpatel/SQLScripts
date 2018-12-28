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

