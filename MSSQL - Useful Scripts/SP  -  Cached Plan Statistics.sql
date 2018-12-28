
/***********************************************************************
 Query				: 	Cached Plan Statistics        
 Creation Date		: 
 Change Date		:                                       	
 Copyright			: ARTNET.COM                                                
 Written by			:                      		
 Purpose			: Shows Cached Plan Statistics and all States based on Cache Object Type.		
 Changes			:                                              			
 Test				: 			
 Note				: 	
                                                			

           
 Updates:                                             		
 Date  		Author   				Purpose                       		

***********************************************************************/ 


BEGIN TRAN

-- Cached Plan Stats
SELECT  DB_NAME(DBID),
		text, 
		*
FROM    sys.dm_exec_cached_plans
CROSS APPLY 
        sys.dm_exec_sql_text(plan_handle)
WHERE   text LIKE '%%' and dbid=17
order by usecounts desc



--Total Plans based on CacheType
SELECT objtype AS [CacheType]
        , count_big(*) AS [Total Plans]
        , sum(cast(size_in_bytes as decimal(18,2)))/1024/1024 AS [Total MBs]
        , avg(usecounts) AS [Avg Use Count]
        , sum(cast((CASE WHEN usecounts = 1 THEN size_in_bytes ELSE 0 END) as decimal(18,2)))/1024/1024 AS [Total MBs - USE Count 1]
        , sum(CASE WHEN usecounts = 1 THEN 1 ELSE 0 END) AS [Total Plans - USE Count 1]
FROM sys.dm_exec_cached_plans
GROUP BY objtype
ORDER BY [Total MBs - USE Count 1] DESC
ROLLBACK




select * from sys.dm_exec_cached_plans s cross apply sys.dm_exec_query_plan(s.plan_handle) CROSS APPLY 
        sys.dm_exec_sql_text(s.plan_handle)