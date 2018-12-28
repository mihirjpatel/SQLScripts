


SELECT top 10
	object_name(s.[object_id]) TableName,
    i.name                  AS IndexName,
    SUM(s.used_page_count) * 8   AS IndexSizeKB
FROM sys.dm_db_partition_stats  AS s 
JOIN sys.indexes                AS i
ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
WHERE i.name is not null and i.name<>'clust'
GROUP BY i.name, s.[object_id]
ORDER BY IndexSizeKB desc
