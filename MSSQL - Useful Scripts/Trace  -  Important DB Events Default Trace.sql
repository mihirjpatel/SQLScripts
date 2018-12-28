
/************************************

Get Trace Info on Important DB Events

************************************/

DECLARE @path nvarchar(1000);
SELECT @path = SUBSTRING(PATH, 1, LEN(PATH) - CHARINDEX('\', REVERSE(PATH))) + '\log.trc'
  FROM sys.traces
  WHERE  id = 1;
SELECT databasename,
       e.name   AS eventname,
       cat.name AS CategoryName,
       starttime,
       e.category_id,
       loginname,
       loginsid,
       spid,
       hostname,
       applicationname,
       servername,
       textdata,
       objectname,
       eventclass,
       eventsubclass
  FROM ::fn_trace_gettable(@path, 0)
       INNER JOIN sys.trace_events AS e ON eventclass = trace_event_id
       INNER JOIN sys.trace_categories AS cat ON e.category_id = cat.category_id
  --WHERE  e.name IN( 'Data File Auto Grow', 'Log File Auto Grow' )
  WHERE databasename NOT IN ('tempdb', 'ignite_repository', 'master')
  ORDER  BY starttime DESC; 