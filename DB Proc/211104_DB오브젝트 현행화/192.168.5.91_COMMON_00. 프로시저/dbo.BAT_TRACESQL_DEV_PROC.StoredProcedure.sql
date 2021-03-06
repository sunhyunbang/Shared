USE [COMMON]
GO
/****** Object:  StoredProcedure [dbo].[BAT_TRACESQL_DEV_PROC]    Script Date: 2021-11-03 오후 4:46:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : DB 오류 로그
 *  작   성   자 : 정헌수 (HSKKA@MEDIAWILL.COM)
 *  작   성   일 : 2014/04/15
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC PAPER_NEW.DBO.BAT_MT_DBERROR_TB_INS_PROC
	--PAPER_NEW.DBO.BAT_MT_DBJOB_FAILURE_TB_INS_PROC에서 실행됨
 *************************************************************************************/


CREATE PROC [dbo].[BAT_TRACESQL_DEV_PROC]


AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON




/*
-- Trace 종료
exec sp_trace_setstatus 6, 0	--지정한 추적을 중지
exec sp_trace_setstatus 6, 2	--지정한 추적을 닫고 서버에서 해당 정의를 삭제
go

-- 현재 Trace 정보 확인
SELECT * FROM ::fn_trace_getinfo(default)
*/
BEGIN

	DECLARE @rc INT
	DECLARE @TraceID INT
	DECLARE @TraceFileOver INT = 2
	DECLARE @MaxFileSize BIGINT = 300
	DECLARE @StopTime DATETIME = DATEADD(MI, 1, GETDATE())
	DECLARE @File NVARCHAR(245)
	DECLARE @on BIT = 1

	SET @StopTime = CONVERT(CHAR(10), GETDATE(), 121) + ' 23:59:59'		--종료시간
	SET @File = 'G:\Profiler\Mon\TraceSQL_Dev_' + REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(17), GETDATE(), 120), ':', ''), '-', ''), ' ', '-')

	-- Trace 생성                                                          
	EXEC @rc = sp_trace_create @TraceID OUTPUT, @TraceFileOver, @File, @MaxFileSize, @StopTime                               

	IF (@rc != 0) GOTO ERROR
	
	BEGIN TRY

		-- eventid(10) -  RPC:Completed - RPC(원격 프로시저 호출)가 완료되면 발생
		-- eventid(11) -  RPC:Starting - RPC(원격 프로시저 호출)가 시작되면 발생
		exec sp_trace_setevent @TraceID, 10, 1, @on				-- TextData	
		exec sp_trace_setevent @TraceID, 10, 2, @on				-- BinaryData
		exec sp_trace_setevent @TraceID, 10, 3, @on				-- DatabaseID
		exec sp_trace_setevent @TraceID, 10, 6, @on				-- NTUserName
		exec sp_trace_setevent @TraceID, 10, 8, @on				-- HostName
		exec sp_trace_setevent @TraceID, 10, 9, @on				-- ClientProcessID
		exec sp_trace_setevent @TraceID, 10, 10, @on			-- ApplicationName
		exec sp_trace_setevent @TraceID, 10, 11, @on			-- LoginName
		exec sp_trace_setevent @TraceID, 10, 12, @on			-- SPID
		exec sp_trace_setevent @TraceID, 10, 18, @on			-- CPU
		exec sp_trace_setevent @TraceID, 10, 16, @on			-- Reads
		exec sp_trace_setevent @TraceID, 10, 17, @on			-- Writes
		exec sp_trace_setevent @TraceID, 10, 13, @on			-- Duration
		exec sp_trace_setevent @TraceID, 10, 14, @on			-- StartTime
		exec sp_trace_setevent @TraceID, 10, 15, @on			-- EndTime
		exec sp_trace_setevent @TraceID, 10, 22, @on			-- ObjectID
		exec sp_trace_setevent @TraceID, 10, 25, @on			-- ServerName
		exec sp_trace_setevent @TraceID, 10, 27, @on			-- EventClass
		exec sp_trace_setevent @TraceID, 10, 35, @on			-- DatabaseName

		-- eventid(12) - SQL:BatchCompleted - Transact-SQL 일괄 처리가 완료되면 발생
		-- eventid(13) - SQL:BatchStarting - Transact-SQL 일괄 처리가 시작되면 발생
		exec sp_trace_setevent @TraceID, 12, 1, @on
		exec sp_trace_setevent @TraceID, 12, 2, @on
		exec sp_trace_setevent @TraceID, 12, 3, @on
		exec sp_trace_setevent @TraceID, 10, 6, @on
		exec sp_trace_setevent @TraceID, 12, 8, @on
		exec sp_trace_setevent @TraceID, 12, 9, @on
		exec sp_trace_setevent @TraceID, 12, 10, @on
		exec sp_trace_setevent @TraceID, 12, 11, @on
		exec sp_trace_setevent @TraceID, 12, 12, @on
		exec sp_trace_setevent @TraceID, 12, 18, @on
		exec sp_trace_setevent @TraceID, 12, 16, @on
		exec sp_trace_setevent @TraceID, 12, 17, @on
		exec sp_trace_setevent @TraceID, 12, 13, @on
		exec sp_trace_setevent @TraceID, 12, 14, @on
		exec sp_trace_setevent @TraceID, 12, 15, @on
		exec sp_trace_setevent @TraceID, 12, 22, @on
		exec sp_trace_setevent @TraceID, 12, 25, @on
		exec sp_trace_setevent @TraceID, 10, 27, @on
		exec sp_trace_setevent @TraceID, 10, 35, @on
                              
                              
                              
		exec sp_trace_setevent @TraceID, 14, 1, @on
		exec sp_trace_setevent @TraceID, 14, 9, @on
		exec sp_trace_setevent @TraceID, 14, 2, @on
		exec sp_trace_setevent @TraceID, 14, 6, @on
		exec sp_trace_setevent @TraceID, 14, 10, @on
		exec sp_trace_setevent @TraceID, 14, 14, @on
		exec sp_trace_setevent @TraceID, 14, 11, @on
		exec sp_trace_setevent @TraceID, 14, 12, @on
		exec sp_trace_setevent @TraceID, 20, 1, @on
		exec sp_trace_setevent @TraceID, 20, 9, @on
		exec sp_trace_setevent @TraceID, 20, 6, @on
		exec sp_trace_setevent @TraceID, 20, 10, @on
		exec sp_trace_setevent @TraceID, 20, 14, @on
		exec sp_trace_setevent @TraceID, 20, 11, @on
		exec sp_trace_setevent @TraceID, 20, 12, @on
		exec sp_trace_setevent @TraceID, 15, 15, @on
		exec sp_trace_setevent @TraceID, 15, 16, @on
		exec sp_trace_setevent @TraceID, 15, 9, @on
		exec sp_trace_setevent @TraceID, 15, 17, @on
		exec sp_trace_setevent @TraceID, 15, 6, @on
		exec sp_trace_setevent @TraceID, 15, 10, @on
		exec sp_trace_setevent @TraceID, 15, 14, @on
		exec sp_trace_setevent @TraceID, 15, 18, @on
		exec sp_trace_setevent @TraceID, 15, 11, @on
		exec sp_trace_setevent @TraceID, 15, 12, @on
		exec sp_trace_setevent @TraceID, 15, 13, @on                              
		-- 필요없는 명령어 필터링
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_reset_connection%'
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_execute%'
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_unprepare%'
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_oledb_ro_usrname%'
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'select collationname(0x1204D00000)%'
		--exec sp_trace_setfilter @TraceID, 11, 0, 0, N'sqlmonitor'		--column_ID = LoginName 지정


		exec sp_trace_setfilter @TraceID, 11, 0, 6, N'%dev%'
		--exec sp_trace_setfilter @TraceID, 18, 0, 4, 1000					--column_ID = CPU
		--exec sp_trace_setfilter @TraceID, 3, 0, 0, 28					--column_ID = DatabaseID         

		/*                              
		exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Profiler'		--column_ID = ApplicationName                     
		exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL 프로필러'                              
		exec sp_trace_setfilter @TraceID, 10, 0, 7, N'MS SQLEM'                              
		exec sp_trace_setfilter @TraceID, 12, 0, 4, 50					--column_ID = SPID                  
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'select 504%'		--column_ID = TextData                
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'select @@%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'SET TEXTSIZE%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'set showplan%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'set NOEXEC%'             
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'set nocount%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'set lock_timeout% '                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'select IS_SRVROLEMEMBER%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_reset%'                 
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%sp_MS%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%sp_help%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%dbo.sysindexes%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%dbo.syscolumns%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%sysobjects%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%dbo.sysusers%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'select SERVERPROPERTY%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'dbcc%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_cursorfetch%'
		*/

		-- Trace 실행
		EXEC sp_trace_setstatus @TraceID, 1
		   
	END TRY
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT
			@ErrorMessage = ERROR_MESSAGE()
		,	@ErrorSeverity = ERROR_SEVERITY()
		,	@ErrorState = ERROR_STATE();

		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

	END CATCH
                           

	SELECT 'ID=' + CAST(@TraceID AS VARCHAR(10))
	GOTO FINISH

	ERROR:                               
		SELECT 'Err=' + CAST(@rc AS VARCHAR(10))
	FINISH:                              
		RETURN

END




END  




GO
