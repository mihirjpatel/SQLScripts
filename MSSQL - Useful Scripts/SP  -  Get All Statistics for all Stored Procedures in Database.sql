SELECT s.object_id,
       OBJECT_NAME(s.object_id) SP_Name,
       execution_count,
       total_worker_time,
       last_worker_time,
       min_worker_time,
       max_worker_time,
       total_physical_reads,
       last_physical_reads AS min_physical_reads,
       max_physical_reads,
       total_logical_writes,
       last_logical_writes AS min_logical_writes,
       max_logical_writes,
       total_logical_reads,
       last_logical_reads,
       min_logical_reads,
       max_logical_reads,
       total_elapsed_time,
       last_elapsed_time,
       min_elapsed_time,
       max_elapsed_time, cached_time, last_execution_time
  FROM sys.dm_exec_procedure_stats AS s
  WHERE database_id = DB_ID('Artnet')
  order by total_worker_time desc
