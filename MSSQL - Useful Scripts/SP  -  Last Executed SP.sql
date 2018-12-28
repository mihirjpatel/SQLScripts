
/*********************************************************************************

								SP Last Executed

*********************************************************************************/


select b.name, a.last_execution_time
from sys.dm_exec_procedure_stats a 
inner join sys.objects b on a.object_id = b.object_id 
where DB_NAME(a.database_ID) = 'Artnet_ny'
order by last_execution_time desc
GO