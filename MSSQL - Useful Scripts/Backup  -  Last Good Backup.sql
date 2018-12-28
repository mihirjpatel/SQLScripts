
/*************************************************
Script Name:  Last Good Backup
Created By :  Mihir J Patel
Description:  Shows Information on when the last GOOD Backup was taken.  
		    Also Shows Recovery Model, and Type of backup taken for each Database.

Changes Made:
Author		 Date	    Description

*************************************************/


 SELECT
  DISTINCT
        a.Name AS DatabaseName ,
        CONVERT(SYSNAME, DATABASEPROPERTYEX(a.name, 'Recovery')) RecoveryModel ,
        COALESCE(( SELECT   CONVERT(VARCHAR(12), MAX(backup_finish_date), 101)
                   FROM     msdb.dbo.backupset
                   WHERE    database_name = a.name
                            AND type = 'd'
                            AND is_copy_only = '0'
                 ), 'No Full') AS 'Full' ,
        COALESCE(( SELECT   CONVERT(VARCHAR(12), MAX(backup_finish_date), 101)
                   FROM     msdb.dbo.backupset
                   WHERE    database_name = a.name
                            AND type = 'i'
                            AND is_copy_only = '0'
                 ), 'No Diff') AS 'Diff' ,
        COALESCE(( SELECT   CONVERT(VARCHAR(20), MAX(backup_finish_date), 120)
                   FROM     msdb.dbo.backupset
                   WHERE    database_name = a.name
                            AND type = 'l'
                 ), 'No Log') AS 'LastLog' ,
        COALESCE(( SELECT   CONVERT(VARCHAR(20), backup_finish_date, 120)
                   FROM     ( SELECT    ROW_NUMBER() OVER ( ORDER BY backup_finish_date DESC ) AS 'rownum' ,
                                        backup_finish_date
                              FROM      msdb.dbo.backupset
                              WHERE     database_name = a.name
                                        AND type = 'l'
                            ) withrownum
                   WHERE    rownum = 2
                 ), 'No Log') AS 'LastLog2'
FROM    sys.databases a
        LEFT OUTER JOIN msdb.dbo.backupset b ON b.database_name = a.name
WHERE   a.name <> 'tempdb'
        AND a.state_desc = 'online'
GROUP BY a.Name ,
        a.compatibility_level
ORDER BY a.name



SELECT  sd.name AS [Database],
        CASE WHEN bs.type = 'D' THEN 'Full backup'
             WHEN bs.type = 'I' THEN 'Differential'
             WHEN bs.type = 'L' THEN 'Log'
             WHEN bs.type = 'F' THEN 'File/Filegroup'
             WHEN bs.type = 'G' THEN 'Differential file'
             WHEN bs.type = 'P' THEN 'Partial'
             WHEN bs.type = 'Q' THEN 'Differential partial'
             WHEN bs.type IS NULL THEN 'No backups'
             ELSE 'Unknown (' + bs.type + ')'
        END AS [Backup Type],
        max(bs.backup_start_date) AS [Last Backup of Type]
FROM    master..sysdatabases sd
        LEFT OUTER JOIN msdb..backupset bs ON rtrim(bs.database_name) = rtrim(sd.name)
        LEFT OUTER JOIN msdb..backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
WHERE   sd.name <> 'tempdb'
GROUP BY sd.name,
        bs.type,
        bs.database_name
ORDER BY sd.name, [Last Backup of Type]


