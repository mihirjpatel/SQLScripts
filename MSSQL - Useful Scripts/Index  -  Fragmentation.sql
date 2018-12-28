/**********************************************

		  INDEX FRAGMENTATION

**********************************************/

SELECT DB_NAME(ips.database_id) AS   DBName,
       OBJECT_NAME(ips.object_id) AS ObjectName,
       i.name AS                     IndexName,
       ips.avg_fragmentation_in_percent
  FROM sys.dm_db_index_physical_stats(DB_ID(), DEFAULT, DEFAULT, DEFAULT, DEFAULT)AS ips
       INNER JOIN sys.indexes AS i ON ips.index_id = i.index_id
                                  AND ips.object_id = i.object_id
  WHERE ips.object_id > 99
    AND ips.avg_fragmentation_in_percent >= 10
    AND ips.index_id > 0
  ORDER BY ips.avg_fragmentation_in_percent DESC;







/*SELECT
    t.NAME 'Table name',
    i.NAME 'Index name',
    ips.index_type_desc,
    ips.alloc_unit_type_desc,
    ips.index_depth,
    ips.index_level,
    ips.avg_fragmentation_in_percent,
    ips.fragment_count,
    ips.avg_fragment_size_in_pages,
    ips.page_count,
    ips.avg_page_space_used_in_percent,
    ips.record_count,
    ips.ghost_record_count,
    ips.Version_ghost_record_count,
    ips.min_record_size_in_bytes,
    ips.max_record_size_in_bytes,
    ips.avg_record_size_in_bytes,
    ips.forwarded_record_count
FROM 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') ips
INNER JOIN  
    sys.tables t ON ips.OBJECT_ID = t.Object_ID
INNER JOIN  
    sys.indexes i ON ips.index_id = i.index_id AND ips.OBJECT_ID = i.object_id
WHERE
    AVG_FRAGMENTATION_IN_PERCENT > 0.0
ORDER BY
    AVG_FRAGMENTATION_IN_PERCENT desc, fragment_count DESC



SELECT a.index_id, name, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(N'Artnet'), NULL, NULL, NULL, NULL) AS a
    JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id
	ORDER BY avg_fragmentation_in_percent DESC
GO*/