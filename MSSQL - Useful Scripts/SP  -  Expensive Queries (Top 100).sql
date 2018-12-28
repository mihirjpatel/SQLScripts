
/***********************************************************************
 Stored Procedure	: Most Expensive Queries (Top 100)	        
 Creation Date		: 
 Change Date		:                                       	
 Copyright			: ARTNET.COM                                                
 Written by			:                      		
 Purpose			: Get the Top 100 Most Expensive Queries			
 Changes			:                                              			
 Test				: 			
 Note				: 	
                                                			

           
 Updates:                                             		
 Date  		Author   				Purpose                       		

***********************************************************************/ 


BEGIN TRAN

SELECT TOP 100 SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
		((CASE qs.statement_end_offset
		WHEN -1 THEN DATALENGTH(qt.TEXT)
		ELSE qs.statement_end_offset
		END - qs.statement_start_offset)/2)+1),
		qs.execution_count,
		qs.total_logical_reads, qs.last_logical_reads,
		qs.total_logical_writes, qs.last_logical_writes,
		qs.total_worker_time,
		qs.last_worker_time,
		qs.total_elapsed_time/1000000 total_elapsed_time_in_S,
		qs.last_elapsed_time/1000000 last_elapsed_time_in_S,
		qs.last_execution_time,
		qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time




SELECT TOP 100
(total_logical_reads + total_logical_writes) / qs.execution_count AS average_IO,
(total_logical_reads + total_logical_writes) AS total_IO,
qs.total_elapsed_time / qs.execution_count / 1000000.0 AS average_seconds,
qs.total_elapsed_time / 1000000.0 AS total_seconds,
qs.execution_count,
SUBSTRING (qt.text,qs.statement_start_offset/2,
(CASE WHEN qs.statement_end_offset = -1
THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
ELSE qs.statement_end_offset END - qs.statement_start_offset)/2) AS individual_query,
o.name AS object_name,
DB_NAME(qt.dbid) AS database_name
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
LEFT OUTER JOIN sys.objects o ON qt.objectid = o.object_id
--where qt.dbid = DB_ID()
order by total_io desc;
--ORDER BY average_seconds DESC;
--ORDER BY average_IO;


ROLLBACK