
/*************************************************
Script Name:  Identify Databases That Need Backups
Created By :  Mihir J Patel
Description:  Shows all Databases which have not been backed up previously.  
		    If Database is in Full Recovery Model, it will show if Log Backups are being taken.

Changes Made:
Author		 Date	    Description

*************************************************/


SELECT  1 AS CheckID ,
		d.[name] AS DatabaseName ,
		1 AS Priority ,
		'Backup' AS FindingsGroup ,
		'Backups Not Performed Recently' AS Finding ,
		
		'Database ' + d.Name + ' last backed up: '
		+ CAST(COALESCE(MAX(b.backup_finish_date),
		' never ') AS VARCHAR(200)) AS Details
FROM    master.sys.databases d
		LEFT OUTER JOIN msdb.dbo.backupset b ON d.name COLLATE SQL_Latin1_General_CP1_CI_AS = b.database_name COLLATE SQL_Latin1_General_CP1_CI_AS
		AND b.type = 'D'
		AND b.server_name = SERVERPROPERTY('ServerName') /*Backupset ran on current server */
WHERE   d.database_id <> 2  /* Bonus points if you know what that means */
		AND d.state <> 1 /* Not currently restoring, like log shipping databases */
		AND d.is_in_standby = 0 /* Not a log shipping target database */
		AND d.source_database_id IS NULL /* Excludes database snapshots */
								
/* 
The above NOT IN filters out the databases we're not supposed to check.
*/
GROUP BY d.name
HAVING  MAX(b.backup_finish_date) <= DATEADD(dd,-7, GETDATE())

UNION ALL 


SELECT  1 AS CheckID ,
										d.name AS DatabaseName ,
										1 AS Priority ,
										'Backup' AS FindingsGroup ,
										'Backups Not Performed Recently' AS Finding ,
							
										( 'Database ' + d.Name
										  + ' never backed up.' ) AS Details
								FROM    master.sys.databases d
								WHERE   d.database_id <> 2 /* Bonus points if you know what that means */
										AND d.state <> 1 /* Not currently restoring, like log shipping databases */
										AND d.is_in_standby = 0 /* Not a log shipping target database */
										AND d.source_database_id IS NULL /* Excludes database snapshots */
										AND NOT EXISTS ( SELECT *
														 FROM   msdb.dbo.backupset b
														 WHERE  d.name COLLATE SQL_Latin1_General_CP1_CI_AS = b.database_name COLLATE SQL_Latin1_General_CP1_CI_AS
																AND b.type = 'D'
																AND b.server_name = SERVERPROPERTY('ServerName') /*Backupset ran on current server */)



/****

DATABASES THAT ARE FULL RECOVERY MODEL AND DO NOT HAVE LOG BACKUPS

****/



SELECT DISTINCT
										2 AS CheckID ,
										d.name AS DatabaseName ,
										1 AS Priority ,
										'Backup' AS FindingsGroup ,
										'Full Recovery Mode w/o Log Backups' AS Finding ,
							
										( 'Database ' + ( d.Name COLLATE database_default )
										  + ' is in ' + d.recovery_model_desc
										  + ' recovery mode but has not had a log backup in the last week.' ) AS Details
								FROM    master.sys.databases d
								WHERE   d.recovery_model IN ( 1, 2 )
										AND d.database_id NOT IN ( 2, 3 )
										AND d.source_database_id IS NULL
										AND d.state <> 1 /* Not currently restoring, like log shipping databases */
										AND d.is_in_standby = 0 /* Not a log shipping target database */
										AND d.source_database_id IS NULL /* Excludes database snapshots */
	
										AND NOT EXISTS ( SELECT *
														 FROM   msdb.dbo.backupset b
														 WHERE  d.name COLLATE SQL_Latin1_General_CP1_CI_AS = b.database_name COLLATE SQL_Latin1_General_CP1_CI_AS
																AND b.type = 'L'
																AND b.backup_finish_date >= DATEADD(dd,
																  -7, GETDATE()) );