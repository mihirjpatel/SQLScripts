
/*************************************************
Script Name:  Functions That Contain Text
Created By :  Mihir J Patel
Description:  Shows ALL SPs and Functions which contain given text.

Changes Made:
Author		 Date	    Description

*************************************************/


/*********************************************************************************

Get all SP/Functions ECT. which contains given text  (similar to SQL Search by Reddit)

*********************************************************************************/
use artnet
SELECT DISTINCT  o.name, o.xtype--, c.text
FROM syscomments c
INNER JOIN sysobjects o ON c.id=o.id
WHERE c.TEXT LIKE '%material%'
GO
