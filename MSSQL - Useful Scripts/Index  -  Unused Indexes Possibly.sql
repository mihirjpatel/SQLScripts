


/******************************************************************************

		Indexes Not Being Used ([user_seeks, user_scans, user_lookups] =0)

******************************************************************************/

SELECT st.name as TableName , si.name as IndexName, user_seeks, user_scans,user_lookups
from sys.indexes si 
	inner join sys.dm_db_index_usage_stats ddius on ddius.object_id = si.object_id and ddius.index_id = si.index_id 
	inner join sys.tables st on si.object_id = st.object_id 
where ((user_seeks = 0 and user_scans = 0 and user_lookups = 0) or ddius.object_id is null)
GO

