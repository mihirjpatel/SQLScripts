/*********************************************************************************

	Find which Stored Procedures use a particular index based on cached plans
					**Also shows stats on the execution**
*********************************************************************************/

select DB_NAME(database_id) as Database_Name, object_name(object_id) as ObjectName, s.* 
from sys.dm_exec_procedure_stats s 
	cross apply sys.dm_exec_query_plan(s.plan_handle) b
where convert(nvarchar(max),b.query_plan) like '%IX_NCL_Lot_CollID_CLN_FeaturedLot_AhWeb%'
GO