
/*************************************************
Script Name:  DBCC Statements
Created By :  Mihir J Patel
Description:  All useful DBCC Statements

Changes Made:
Author		 Date	    Description

*************************************************/


--http://technet.microsoft.com/en-us/library/ms176064.aspx
DBCC CHECKDB --(NOINDEX, | REPAIR_ALLOW_DATA_LOSS | REPAIR_FAST | REPAIR_REBUILD)








--Checks the consistency of disk space allocation structures for a specified database.
DBCC CHECKALLOC







--Checks the integrity of a specified constraint or all constraints on a specified table in the current database.
DBCC CHECKCONSTRAINTS







--CHECKDB BUT FOR PARTICULAR TABLE
DBCC CHECKTABLE (LOT)







--Checks for catalog consistency within the specified database. The database must be online.
DBCC CHECKCATALOG






--Display contents of database pages
DBCC PAGE --('dbname' | dbid, filenum, pagenum)





--Displays Fragmentation information for the data and indexes of the specified table or view
DBCC SHOWCONTIG (LOT)





--REBUILD Particular Indexes by Table or Individual Index
DBCC DBREINDEX (table_name) --,index_name





--Removes all clean buffers from the buffer pool
DBCC DROPCLEANBUFFERS




--Cleans All Planned Cache or Individual Plan Cache
DBCC FREEPROCCACHE --(plan_handle | sql_handle | pool_name)

