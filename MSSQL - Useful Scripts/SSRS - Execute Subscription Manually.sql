/*Execute SSRS Subscription Manually*/
USE ReportServer
SELECT
      S.ScheduleID AS SQLAgent_Job_Name
      ,SUB.Description AS Sub_Desc
      ,SUB.DeliveryExtension AS Sub_Del_Extension
      ,C.Name AS ReportName
      ,C.Path AS ReportPath
FROM ReportSchedule RS (NOLOCK)
      INNER JOIN Schedule S (NOLOCK) ON (RS.ScheduleID = S.ScheduleID) 
      INNER JOIN Subscriptions SUB (NOLOCK) ON (RS.SubscriptionID = SUB.SubscriptionID) 
      INNER JOIN [Catalog] C (NOLOCK) ON (RS.ReportID = C.ItemID AND SUB.Report_OID = C.ItemID)
WHERE 
      C.Name like '' --Enter Report Name to find Job_Name

/*Enter SQLAgent_Job_Name to execute the subscription based on Job ID*/
--USE msdb
--EXEC sp_start_job @job_name = '' --Enter SQLAgent_Job_Name