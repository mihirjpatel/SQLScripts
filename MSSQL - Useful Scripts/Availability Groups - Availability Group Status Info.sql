
/*************************************************
Script Name:  Availability Groups Status Information
Created By :  Mihir J Patel
Description:  Gives Information on all Servers and Databases involved in the Availability Group.
			 1. Replication ID
			 2. Replication DB Name
			 3. Replication Server Name
			 4. Join State
			 5. Primary or Secondary
			 6. Availability Mode
			 7. Synchronization State
			 8. Synchronization Health Status
			 9. OperationalState (Does not show online or offline for other servers)
			 10. Connection State
			 11. Suspend Reason
			 12. Recovery Health
			 13. Failover Type
			 14. OTHER USEFUL INFORMATION

Changes Made:
Author		 Date	    Description
Mihir J Patel	 4/14/14	   Commented out join to sysLogins and first where clause where islocal=1 to show ALL Servers' Information.

*************************************************/


WITH [AvailabilityGroupReplicaCTE]
    AS (
    SELECT dc.database_name
         , dr.synchronization_state_desc
         , dr.suspend_reason_desc
         , dr.synchronization_health_desc
         , dr.replica_id
         , ar.availability_mode_desc
         , ar.primary_role_allow_connections_desc
         , ar.secondary_role_allow_connections_desc
         , ar.failover_mode_desc
         , ar.endpoint_url
         , ar.owner_sid
         , ar.create_date
         , ar.modify_date
         , dr.recovery_lsn
         , dr.truncation_lsn
         , dr.last_sent_lsn
         , dr.last_sent_time
         , dr.last_received_lsn
         , dr.last_received_time
         , dr.last_hardened_lsn
         , dr.last_hardened_time
         , dr.last_redone_lsn
         , dr.last_redone_time
         , dr.redo_queue_size
         , dr.log_send_queue_size
      FROM sys.dm_hadr_database_replica_states AS dr
           INNER JOIN sys.availability_databases_cluster AS dc ON dr.group_database_id = dc.group_database_id
           INNER JOIN sys.availability_replicas AS ar ON ar.replica_id = dr.replica_id
    --  WHERE dr.is_local = 1
    )
, [AvailabilityGroupReplicaDatabaseState] (
ReplicaID
, ReplicaDBName
, ReplicaServerName
, JoinState
, Role
, AvailabilityMode
, SynchronizationState
, SynchronizationHealth
, OperationalState
, ConnectedState
, SuspendReason
, RecoveryHealth
, RecoveryLSN
, TruncationLSN
, LastSentLSN
, LastSentTime
, LastReceivedLSN
, LastReceivedTime
, LastHardenedLSN
, LastHardenedTime
, LastRedoneLSN
, LastRedoneTime
, RedoQueueSize
, LogSendQueueSize
, PrimaryRoleAllowConnections
, SecondaryRoleAllowConnections
, FailoverMode
, EndPointURL
--, Owner
, CreateDate
, ModifyDate
)
    AS (
    SELECT c.replica_id
         , c.database_name
         , cs.replica_server_name
         , cs.join_state_desc
         , rs.role_desc
         , c.availability_mode_desc
         , c.synchronization_state_desc
         , c.synchronization_health_desc
         , rs.operational_state_desc
         , rs.connected_state_desc
         , c.suspend_reason_desc
         , rs.recovery_health_desc
         , c.recovery_lsn
         , c.truncation_lsn
         , c.last_sent_lsn
         , c.last_sent_time
         , c.last_received_lsn
         , c.last_received_time
         , c.last_hardened_lsn
         , c.last_hardened_time
         , c.last_redone_lsn
         , c.last_redone_time
         , c.redo_queue_size
         , c.log_send_queue_size
         , c.primary_role_allow_connections_desc
         , c.secondary_role_allow_connections_desc
         , c.failover_mode_desc
         , c.endpoint_url
        -- , sl.name
         , c.create_date
         , c.modify_date
      FROM AvailabilityGroupReplicaCTE AS c
           INNER JOIN sys.dm_hadr_availability_replica_states AS rs ON rs.replica_id = c.replica_id
           INNER JOIN sys.dm_hadr_availability_replica_cluster_states AS cs ON cs.replica_id = c.replica_id
          -- INNER JOIN sys.syslogins AS sl ON c.owner_sid = sl.sid
    )
    SELECT *
      FROM AvailabilityGroupReplicaDatabaseState;