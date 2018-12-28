/******************************************************************************

	Last Updated Stats by table (remove where to see all indexes in DB)

******************************************************************************/

SELECT name AS index_name,
STATS_DATE(OBJECT_ID, index_id) AS StatsUpdated
FROM sys.indexes WITH (NOLOCK)
where object_id=object_id('Artnet.dbo.lot') 
ORDER BY StatsUpdated desc
GO