USE [COMMON]
GO
/****** Object:  StoredProcedure [dbo].[BAT_TRACESQL_DEV_INS_LOG_PROC]    Script Date: 2021-11-03 오후 4:46:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 전일 계정 트래킹 정보 DB입력
 *  작   성   자 : 정헌수 (HSKKA@MEDIAWILL.COM)
 *  작   성   일 : 2019/01/26
 
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC PAPER_NEW.DBO.BAT_MT_DBERROR_TB_INS_PROC
	--PAPER_NEW.DBO.BAT_MT_DBJOB_FAILURE_TB_INS_PROC에서 실행됨
	
	select REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(17), GETDATE(), 120), ':', ''), '-', ''), ' ', '-')
	select convert(varchar(10),getdate(),112)
	
	
select top 100 *FROm MAGUSER.DBO.MM_DEV_DBCON_LIST_TB    order by 1 desc

delete MAGUSER.DBO.MM_DEV_DBCON_LIST_TB where starttime >= '2019-01-28'
drop proc BAT_TRACESQL_DEV_INS_LOG_PROC
 *************************************************************************************/


CREATE PROC [dbo].[BAT_TRACESQL_DEV_INS_LOG_PROC]


AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON



declare @FILE varchar(100) ='G:\Profiler\Mon\TraceSQL_Dev_'+convert(varchar(10),getdate()-1,112) +'-0000'+'.trc'

INSERT  DBO.MM_DEV_DBCON_LIST_TB  
select StartTime,HostName ,LoginName ,ApplicationName ,name ,ServerName,textdata ,ClientProcessID ,SPID,EndTime ,Reads,Writes,CPU,Duration ,EventClass    
FROM ::FN_TRACE_GETTABLE(@FILE,DEFAULT) AS T   JOIN SYS.TRACE_EVENTS AS TE ON T.EVENTCLASS = TE.TRACE_EVENT_ID  

exec FINDDB1.MAGUSER.DBO.BAT_TRACESQL_DEV_INS_MEMBERDB_LOG_PROC

/* */
truncate table COMMON.DBO.MM_DEV_DBCON_LIST_TB 

END



GO
