USE [COMMON]
GO
/****** Object:  StoredProcedure [dbo].[BAT_MT_DBERROR_TB_INS_PROC]    Script Date: 2021-11-04 오전 10:59:43 ******/
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


CREATE PROC [dbo].[BAT_MT_DBERROR_TB_INS_PROC]


AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @ROWCOUNT INT
	DECLARE @MSG	VARCHAR(200)
	
	/* 임시 테이블 생성 */ 
	SELECT TOP 0 
		LOGDATE
		,PROCESSINFO
		,MESSAGE
	INTO #TMP_TBL
	FROM  MT_DBERROR_TB
	 
	/* 오류로그 취합 */ 
	INSERT INTO #TMP_TBL
	EXEC ('EXEC XP_READERRORLOG 0,1')


	/* 이전백업데이터 삭제 */ 
	DELETE #TMP_TBL WHERE LOGDATE <= (SELECT MAX(LOGDATE) FROM MT_DBERROR_TB)

	/*신규 백업 데이터 입력 */
	INSERT INTO MT_DBERROR_TB (LOGDATE,PROCESSINFO,MESSAGE)
	SELECT *FROM #TMP_TBL WHERE LOGDATE > (SELECT isnull(MAX(LOGDATE),'') FROM MT_DBERROR_TB)

	/* 에러 발생시 메세지 전달 요망*/
	SELECT @ROWCOUNT = COUNT(*) FROM #TMP_TBL WITH(NOLOCK) 
	WHERE MESSAGE NOT LIKE 'LOG WAS BACKED UP%'	--트랜잭션 로그 백업
	AND MESSAGE NOT LIKE 'DBCC TRACEON%'		--??
	AND MESSAGE NOT LIKE 'DATABASE BACKED UP%'	--DB 백업
	AND MESSAGE NOT LIKE 'SQL TRACE STOPPED.%'	--profiler 실행
	AND MESSAGE NOT LIKE 'SQL TRACE ID %'		--profiler 실행
	AND MESSAGE NOT LIKE 'THIS INSTANCE OF SQL SERVER HAS BEEN USING %'--단순메세지
	AND MESSAGE NOT LIKE 'Setting database option%'	--재부팅시 실행시 옵션 세팅
	AND MESSAGE NOT LIKE 'Database was restored:%'  -- 리스토어
	AND MESSAGE NOT LIKE '%This is an informational message only%'  -- 메세지 전용
	AND MESSAGE NOT LIKE 'A possible infinite recompile was%'  -- recompile


	IF @ROWCOUNT > 0 
	BEGIN
		DECLARE @ERRORNM VARCHAR(40)	
		SELECT TOP 1 @ERRORNM = LEFT(MESSAGE,30) FROM #TMP_TBL WITH(NOLOCK)  
		WHERE MESSAGE NOT LIKE 'Log was backed up.%' ORDER BY LOGDATE  DESC

		SET @MSG = 'MEMBERDB(91):' + CAST(@ROWCOUNT AS VARCHAR(10)) + '건 DB오류발생 MT_DBERROR_TB[' + @ERRORNM +']'
		--EXECUTE FINDDB1.COMDB1.DBO.PUT_SENDKAKAO_PROC '01031273287', '0230190213', 'MWsms16', @MSG, NULL, NULL, '벼룩시장 DB오류메세지' 		  , @MSG	
		--EXECUTE TAX.COMDB1.DBO.PUT_SENDSMS_PROC '0230190213','FA SYSTEM','개발담당','01031273287',@MSG  -- 정헌수
	END
END  




GO
/****** Object:  StoredProcedure [dbo].[BAT_MT_DBJOB_FAILURE_TB_INS_PROC]    Script Date: 2021-11-04 오전 10:59:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 스케쥴 오류 로그
 *  작   성   자 : 정헌수 (hskka@mediawill.com)
 *  작   성   일 : 2014/06/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_MT_DBJOB_FAILURE_TB_INS_PROC
	SELECT TOP 100 * FROM PAPER_NEW.DBO.MT_DBJOB_FAILURE_TB WITH(NOLOCK) order by instance_id desc
 *************************************************************************************/


CREATE PROC [dbo].[BAT_MT_DBJOB_FAILURE_TB_INS_PROC]


AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
/******************************************************************************
  * DECLARE & INITIALIZE
 ******************************************************************************/
	DECLARE @ROWCOUNT varchar(10)
	DECLARE @MSG varchar(100)

	-- 취합로그가 없을경우 최대 12시간이전 로그를 취합
	DECLARE @date CHAR(8)
	SET @date = CONVERT(CHAR(8),DATEADD(DD, - 0.1,GETDATE()),112)

	-- DECLARE
	DECLARE @ID_DBJOB  INT


/*
	기존 수집된 에러 최신번호  (만약 에러 번호가 초기화 되었다면?)
*/	
	PRINT @ID_DBJOB
	SELECT @ID_DBJOB = ISNULL(MAX(INSTANCE_ID) ,0)
	FROM FINDDB1.LOGDB.DBO.MT_DBJOB_FAILURE_TB WITH(NOLOCK) 
	WHERE	SERVERNM = 'MWMEMBERDB'
		AND REGDT > GETDATE() - 1

	
 /******************************************************************************
  * CASE NO DATA SET
 ******************************************************************************/


	IF @ID_DBJOB = 0 
	BEGIN
		SELECT @ID_DBJOB = ISNULL(max(instance_id),0)-1
		FROM MSDB.DBO.SYSJOBHISTORY WITH(NOLOCK)
		WHERE run_status = 0 
			AND step_id>0 
			AND run_date >= @date
	END
	IF @ID_DBJOB <= 0 --오류 없으면..
	RETURN 
	PRINT @ID_DBJOB

 /******************************************************************************
  * TEMP TABLE GATHERING
  drop table #TMP
 ******************************************************************************/
 SELECT *
   INTO #TMP
   FROM (
   -- 195번 쿼리
   SELECT 'MWMEMBERDB' as servernm
     ,j.name as jobnm
     ,jh.step_name as jobstep
     ,jh.run_date
     ,jh.run_time
     ,jh.run_duration as duration
     ,jh.message as contents
     ,instance_id 
     FROM MSDB.DBO.SYSJOBHISTORY JH WITH(NOLOCK)
     INNER JOIN MSDB.DBO.SYSJOBS J WITH(NOLOCK) ON jh.job_id=j.job_id
    WHERE run_status = 0 
     AND step_id>0 
     AND instance_id > @ID_DBJOB

   ) A

INSERT FINDDB1.LOGDB.DBO.MT_DBJOB_FAILURE_TB   
SELECT servernm
	,jobnm
	,jobstep
	,LEFT(CAST(run_date AS VARCHAR(20)),4) +'-'+ SUBSTRING(CAST(run_date AS VARCHAR(20)),5,2) +'-'+ SUBSTRING(CAST(run_date AS VARCHAR(20)),7,2) +' '+ISNULL( SUBSTRING(CONVERT(varchar(7),run_time+1000000),2,2) + ':' + SUBSTRING(CONVERT(varchar(7),run_time+1000000),4,2),'') as regdt
	,duration
	,contents
	,instance_id
FROM #TMP
	ORDER BY servernm, instance_id
	
set @ROWCOUNT = @@ROWCOUNT
	IF @ROWCOUNT > 0 
	BEGIN
		DECLARE @JOBNM VARCHAR(40)	
		SELECT TOP 1 @JOBNM = JOBNM FROM FINDDB1.LOGDB.dbo.MT_DBJOB_FAILURE_TB  WITH(NOLOCK)  WHERE servernm = 'MWMEMBERDB' ORDER BY regdt DESC
		SET @MSG = 'MWMEMBERDB:' + CAST(@ROWCOUNT AS VARCHAR(10)) + '건 스케쥴 오류 발생[' + @JOBNM +']'	
		EXECUTE FINDDB1.COMDB1.DBO.PUT_SENDKAKAO_PROC '01052321799', '0230190213', 'MWsms16', @MSG, NULL, NULL, '벼룩시장 DB오류메세지' 		  , @MSG	
		EXECUTE FINDDB1.COMDB1.DBO.PUT_SENDKAKAO_PROC '01049388846', '0230190213', 'MWsms16', @MSG, NULL, NULL, '벼룩시장 DB오류메세지' 		  , @MSG	
	END

/* DB 에러로그 취합 및 메세지 발송 */	
	EXEC COMMON.DBO.BAT_MT_DBERROR_TB_INS_PROC
END  


GO
/****** Object:  StoredProcedure [dbo].[BAT_TRACESQL_DEV_INS_LOG_PROC]    Script Date: 2021-11-04 오전 10:59:43 ******/
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
/****** Object:  StoredProcedure [dbo].[BAT_TRACESQL_DEV_PROC]    Script Date: 2021-11-04 오전 10:59:43 ******/
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
/****** Object:  StoredProcedure [dbo].[GET_DISKSIZE_CHECK_LIST_PROC]    Script Date: 2021-11-04 오전 10:59:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : DB_디스크용량 확인하여 오류 대비
 *  작   성   자 : 김 선 호 (sunho710@mediawill.com)
 *  작   성   일 : 2017/03/15
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : PUT_DISKSIZE_CHECK_MERGE_PROC 에서 오류 테이블 취합하여 문자 발송
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_DISKSIZE_CHECK_LIST_PROC 15 BUNCH 받아와야함 전체 드라이브정보 가져옴
 *************************************************************************************/

CREATE PROC [dbo].[GET_DISKSIZE_CHECK_LIST_PROC]
@BUNCH INT=0
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
	
	DECLARE @DRIVE VARCHAR(3)=''
	DECLARE @REMAINGB INT=0	
	DECLARE @IP VARCHAR(15)=''
	
	SELECT @IP=ISNULL(local_net_address,'.')
	FROM sys.dm_exec_connections WITH(NOLOCK)
	GROUP BY local_net_address 
	
	CREATE TABLE #TEMP_DISKSIZE_CHECK_LIST_SPACE(
		IDX int IDENTITY PRIMARY KEY,	
		DRIVE VARCHAR(10)
		,REMAINGB INT
	)
		
	INSERT INTO #TEMP_DISKSIZE_CHECK_LIST_SPACE EXEC MASTER..xp_fixeddrives		
	
	DECLARE TEMP_CURSOR CURSOR FOR SELECT @BUNCH,DRIVE+':\',REMAINGB/1024,@IP FROM #TEMP_DISKSIZE_CHECK_LIST_SPACE
	OPEN TEMP_CURSOR
	FETCH NEXT FROM TEMP_CURSOR INTO @BUNCH,@DRIVE,@REMAINGB,@IP
	WHILE(@@FETCH_STATUS=0) BEGIN			
		EXEC [FINDDB1].[STATS].[DBO].[PUT_DISKSIZE_CHECK_REMOTE_PROC] @BUNCH,@DRIVE,@REMAINGB,@IP --32번 서버로 보냄
		--SELECT @BUNCH,@DRIVE,@REMAINGB,@IP
		FETCH NEXT FROM TEMP_CURSOR INTO @BUNCH,@DRIVE,@REMAINGB,@IP
	END
	
	CLOSE TEMP_CURSOR
	DEALLOCATE TEMP_CURSOR	
			
	IF OBJECT_ID('tempdb..#TEMP_DISKSIZE_CHECK_LIST_SPACE') IS NOT NULL
		DROP TABLE #TEMP_DISKSIZE_CHECK_LIST_SPACE
END

	
GO
