

/*****************************************************************************

		Find all tables which are being used as seeks scans or lookups

*****************************************************************************/

SELECT  t.name AS              'Table',
        SUM(i.user_seeks + i.user_scans + i.user_lookups)
        AS                     'Total accesses',
        SUM(i.user_seeks) AS   'Seeks',
        SUM(i.user_scans) AS   'Scans',
        SUM(i.user_lookups) AS 'Lookups',
        SUM(i.user_updates) AS 'updates'
  FROM sys.dm_db_index_usage_stats AS i
       RIGHT OUTER JOIN sys.tables AS t ON t.object_id = i.object_id
  GROUP BY  i.object_id,
            t.name
  ORDER BY [Total accesses] DESC;
GO

/*****************************************************************************

		Find all tables which are being used as seeks scans or lookups

*****************************************************************************/

SELECT *
  FROM(SELECT b.RowCounts,
              t.name AS                                           'Table',
              SUM(i.user_seeks + i.user_scans + i.user_lookups)AS 'Total accesses',
              SUM(i.user_seeks)AS                                 'Seeks',
              SUM(i.user_scans)AS                                 'Scans',
              SUM(i.user_lookups)AS                               'Lookups',
              SUM(i.user_updates)AS                               'updates'
         FROM sys.dm_db_index_usage_stats AS i
              RIGHT OUTER JOIN sys.tables AS t ON t.object_id = i.object_id, (SELECT sc.name + '.' + ta.name AS TableName,
                                                                                     SUM(pa.rows)AS             RowCounts
                                                                                FROM sys.tables AS ta
                                                                                     INNER JOIN sys.partitions AS pa ON pa.OBJECT_ID = ta.OBJECT_ID
                                                                                     INNER JOIN sys.schemas AS sc ON ta.schema_id = sc.schema_id
                                                                                WHERE ta.is_ms_shipped = 0
                                                                                  AND pa.index_id IN(1, 0)
                                                                                GROUP BY sc.name,
                                                                                         ta.name)AS b
         WHERE REPLACE(b.TableName, 'dbo.', '') = t.name
         GROUP BY i.object_id,
                  t.name,
                  b.RowCounts)AS av
  ORDER BY RowCounts, [Total Accesses] DESC;
GO

