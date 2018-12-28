
/*************************************************
Script Name:  User Connections Information
Created By :  Mihir J Patel
Description:  Shows all Connections Information


Changes Made:
Author		 Date	    Description

*************************************************/



BEGIN TRAN;

SELECT c.session_id,
       c.auth_scheme,
       c.node_affinity,
       r.scheduler_id,
       host_name,
       program_name,
       s.login_name,
       DB_NAME(s.database_id) AS database_name,
       CASE s.transaction_isolation_level
       WHEN 0 THEN 'Unspecified'
       WHEN 1 THEN 'Read Uncomitted'
       WHEN 2 THEN 'Read Committed'
       WHEN 3 THEN 'Repeatable'
       WHEN 4 THEN 'Serializable'
       WHEN 5 THEN 'Snapshot'
       END AS                    transaction_isolation_level,
       s.status AS               SessionStatus,
       r.status AS               RequestStatus,
       CASE
       WHEN r.sql_handle IS NULL THEN
       c.most_recent_sql_handle
       ELSE
       r.sql_handle
       END AS                    sql_handle,
       r.cpu_time,
       r.reads,
       r.writes,
       r.logical_reads,
       r.total_elapsed_time
  FROM sys.dm_exec_connections AS c
       INNER JOIN sys.dm_exec_sessions AS s ON c.session_id = s.session_id
       LEFT JOIN sys.dm_exec_requests AS r ON c.session_id = r.session_id;

SELECT S.*,
       R.*
  FROM sys.dm_exec_sessions AS s
       LEFT OUTER JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
  WHERE s.session_id >= 50;

/********************************

	   TOTAL CONNECTIONS

********************************/

SELECT
COUNT(dbid) AS TotalConnections
  FROM sys.sysprocesses
  WHERE
  dbid > 0;


/*******************************************************

    TOTAL CONNECTIONS BY DATABASE AND LOGIN NAME

*******************************************************/


SELECT
DB_NAME(dbid) AS DBName,
COUNT(dbid) AS   NumberOfConnections,
loginame AS      LoginName
  FROM sys.sysprocesses
  WHERE
  dbid > 0
  GROUP BY
  dbid,
  loginame;


/********************************

  ACTIVE CONNECTIONS INFO

********************************/


ROLLBACK;