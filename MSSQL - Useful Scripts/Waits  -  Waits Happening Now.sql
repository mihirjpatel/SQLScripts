
/***********************************************************************
 Query				: Waits Happening Now	        
 Creation Date		: 
 Change Date		:                                       	
 Copyright			: ARTNET.COM                                                
 Written by			:                      		
 Purpose			: Shows details on waits happening right this moment.			
 Changes			:                                              			
 Test				: exec			
 Note				: 	
                                                			

           
 Updates:                                             		
 Date  		Author   				Purpose                       		

***********************************************************************/ 


BEGIN TRAN

SELECT wt.session_id,
	   wt.wait_type,
	   er.wait_resource,
	   wt.wait_duration_ms,
	   st.text,
	   er.start_time
FROM sys.dm_os_waiting_tasks wt
	INNER JOIN sys.dm_exec_requests er
	ON wt.waiting_task_address = er.task_address
	OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) st
	where wt.wait_type not like '%sleep%'
	and wt.session_id >=50
	ORDER BY wt.wait_duration_ms desc

ROLLBACK