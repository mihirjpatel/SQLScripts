/******************************************************************************

					Statistics of All Indexes on All Tables

******************************************************************************/

SELECT sso.name objectname, 
	   ssi.name indexname,
	   user_seeks, 
	   user_scans, 
	   user_lookups, 
	   user_updates
from sys.dm_db_index_usage_stats ddius 
	join sys.sysdatabases ssd on ddius.database_id = ssd.dbid 
	join sys.sysindexes ssi on ddius.object_id = ssi.id and ddius.index_id = ssi.indid 
	join sys.sysobjects sso on ddius.object_id = sso.id 
where sso.type = 'u'
order by user_seeks+user_scans+user_lookups+user_updates,objectname desc
GO



/******************************************************************************

	Shows tables with indexname=null (HEAP) -- Might need to create index

******************************************************************************/

SELECT sso.name objectname, 
		ssi.name indexname,
		user_seeks, 
		user_scans, 
		user_lookups, 
		user_updates
from sys.dm_db_index_usage_stats ddius 
	join sys.sysdatabases ssd on ddius.database_id = ssd.dbid 
	join sys.sysindexes ssi on ddius.object_id = ssi.id and ddius.index_id = ssi.indid 
	join sys.sysobjects sso on ddius.object_id = sso.id 
where ssi.name is null 
order by user_seeks+user_scans+user_lookups+user_updates desc
GO



/*********************************************************************************

		Find all tables which are being used as seeks scans or lookups

*********************************************************************************/

SELECT 
  t.name AS 'Table', 
  SUM(i.user_seeks + i.user_scans + i.user_lookups) 
    AS 'Total accesses',
  SUM(i.user_seeks) AS 'Seeks',
  SUM(i.user_scans) AS 'Scans',
  SUM(i.user_lookups) AS 'Lookups'
FROM 
  sys.dm_db_index_usage_stats i RIGHT OUTER JOIN 
    sys.tables t ON (t.object_id = i.object_id)
GROUP BY 
  i.object_id, 
  t.name
ORDER BY [Total accesses] DESC
GO
