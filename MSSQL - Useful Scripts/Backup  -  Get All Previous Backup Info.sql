
/*************************************************
Script Name:  Get All Previous Backup Information
Created By :  Mihir J Patel
Description:  Gives backup History of all Databases that have been backed up.

Changes Made:
Author		 Date	    Description

*************************************************/



--All Backup Info
SELECT  sd.name AS [Database],
        CASE WHEN bs.type = 'D' THEN 'Full backup'
             WHEN bs.type = 'I' THEN 'Differential'
             WHEN bs.type = 'L' THEN 'Log'
             WHEN bs.type = 'F' THEN 'File/Filegroup'
             WHEN bs.type = 'G' THEN 'Differential file'
             WHEN bs.type = 'P' THEN 'Partial'
             WHEN bs.type = 'Q' THEN 'Differential partial'
             ELSE 'Unknown (' + bs.type + ')'
        END AS [Backup Type],
        bs.backup_start_date AS [Date], SERVERPROPERTY('ServerName'), bs.server_name
FROM    master..sysdatabases sd
        LEFT OUTER JOIN msdb..backupset bs ON RTRIM(bs.database_name) = RTRIM(sd.name)
        LEFT OUTER JOIN msdb..backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
WHERE bs.backup_start_date > GETDATE() - 1010 AND bs.server_name = SERVERPROPERTY('ServerName')  --remove this to get all server
ORDER BY sd.name, [Date]


--Only Full Backups

SELECT distinct d.[name] AS DatabaseName ,
		b.backup_finish_date
FROM    master.sys.databases d
		LEFT OUTER JOIN msdb.dbo.backupset b ON d.name COLLATE SQL_Latin1_General_CP1_CI_AS = b.database_name COLLATE SQL_Latin1_General_CP1_CI_AS
		AND b.type = 'D' AND b.server_name = SERVERPROPERTY('ServerName') /*Backupset ran on current server */
		ORDER BY d.name, b.backup_finish_date
								