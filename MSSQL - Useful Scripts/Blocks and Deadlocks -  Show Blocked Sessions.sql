
/*************************************************
Script Name:  Show Blocked Sessions
Created By :  Mihir J Patel
Description:  Shows information on Blocks/Deadlocks/Waits

Changes Made:
Author		 Date	    Description

*************************************************/

--USE [master]
--GO

SELECT  session_id
 ,blocking_session_id
 ,wait_time
 ,wait_type
 ,last_wait_type
 ,wait_resource
 ,transaction_isolation_level
 ,lock_timeout
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0
GO


SELECT * from sys.dm_tran_locks
WHERE request_status = 'CONVERT'
GO

SELECT   tl.resource_type
 ,tl.resource_associated_entity_id
 ,OBJECT_NAME(p.object_id) AS object_name
 ,tl.request_status
 ,tl.request_mode
 ,tl.request_session_id
 ,tl.resource_description
FROM sys.dm_tran_locks tl
LEFT JOIN sys.partitions p 
ON p.hobt_id = tl.resource_associated_entity_id
WHERE tl.resource_database_id = DB_ID()
GO

SELECT   w.session_id
 ,w.wait_duration_ms
 ,w.wait_type
 ,w.blocking_session_id
 ,w.resource_description
 ,s.program_name
 ,t.text
 ,t.dbid
 ,s.cpu_time
 ,s.memory_usage
FROM sys.dm_os_waiting_tasks w
INNER JOIN sys.dm_exec_sessions s
ON w.session_id = s.session_id
INNER JOIN sys.dm_exec_requests r
ON s.session_id = r.session_id
OUTER APPLY sys.dm_exec_sql_text (r.sql_handle) t
WHERE s.is_user_process = 1
GO