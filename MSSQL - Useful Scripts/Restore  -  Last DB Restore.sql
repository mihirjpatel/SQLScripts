SELECT MAX(restore_date) AS LastRestore
      ,COUNT(*) AS CountRestores
      ,destination_database_name
FROM msdb.dbo.restorehistory
GROUP BY destination_database_name
order by lastRestore desc