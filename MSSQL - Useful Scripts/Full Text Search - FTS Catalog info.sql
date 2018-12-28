
/*************************************************
Script Name:  FTS Catalog Info
Created By :  Mihir J Patel
Description:  Shows FTS Catalog Information in ALL Databases

Changes Made:
Author		 Date	    Description

*************************************************/




SELECT DB_NAME(ftsac.[database_id]) AS [db_name]
      ,DATABASEPROPERTYEX(DB_NAME(ftsac.[database_id]), 'IsFulltextEnabled') AS [is_ft_enabled]
      ,ftsac.[name] AS [catalog_name]
      ,mfs.[name] AS [ft_catalog_file_logical_name]
      ,mfs.[physical_name] AS [ft_catalog_file_physical_name]
      ,OBJECT_NAME(ftsip.[table_id]) AS [table_name]
      ,FULLTEXTCATALOGPROPERTY(ftsac.[name], 'IndexSize') AS [ft_catalog_logical_index_size_in_mb]
      ,FULLTEXTCATALOGPROPERTY(ftsac.[name], 'AccentSensitivity') AS [is_accent_sensitive]
      ,FULLTEXTCATALOGPROPERTY(ftsac.[name], 'UniqueKeyCount') AS [unique_key_count]
      ,ftsac.[row_count_in_thousands]
      ,ftsip.[is_clustered_index_scan]
      ,ftsip.[range_count]
      ,FULLTEXTCATALOGPROPERTY(ftsac.[name], 'ImportStatus') AS [import_status]
      ,ftsac.[status_description] AS [current_state_of_fts_catalog]
      ,ftsac.[is_paused]
      ,(SELECT CASE FULLTEXTCATALOGPROPERTY(ftsac.[name], 'PopulateStatus')
                    WHEN 0
                            THEN 'Idle'
                    WHEN 1
                            THEN 'Full Population In Progress'
                    WHEN 2
                            THEN 'Paused'
                    WHEN 3
                            THEN 'Throttled'
                    WHEN 4
                            THEN 'Recovering'
                    WHEN 5
                            THEN 'Shutdown'
                    WHEN 6
                            THEN 'Incremental Population In Progress'
                    WHEN 7
                            THEN 'Building Index'
                    WHEN 8
                            THEN 'Disk Full. Paused'
                    WHEN 9
                            THEN 'Change Tracking'
              END) AS [population_status]
      ,ftsip.[population_type_description] AS [ft_catalog_population_type]
      ,ftsip.[status_description] AS [status_of_population]
      ,ftsip.[completion_type_description]
      ,ftsip.[queued_population_type_description]
      ,ftsip.[start_time]
    ,DATEADD(ss, FULLTEXTCATALOGPROPERTY(ftsac.[name], 'PopulateCompletionAge'), '1/1/1990') AS [last_populated]
FROM [sys].[dm_fts_active_catalogs] ftsac
INNER JOIN [sys].[databases] dbs
       ON dbs.[database_id] = ftsac.[database_id]
LEFT JOIN [sys].[master_files] mfs
       ON mfs.[database_id] = dbs.[database_id]
              AND mfs.[physical_name] NOT LIKE '%.mdf'
              AND mfs.[physical_name] NOT LIKE '%.ndf'
              AND mfs.[physical_name] NOT LIKE '%.ldf'
CROSS JOIN [sys].[dm_fts_index_population] ftsip
WHERE ftsac.[database_id] = ftsip.[database_id]
       AND ftsac.[catalog_id] = ftsip.[catalog_id];