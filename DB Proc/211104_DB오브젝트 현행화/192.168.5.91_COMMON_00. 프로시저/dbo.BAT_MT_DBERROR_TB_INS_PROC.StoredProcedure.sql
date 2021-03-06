USE [COMMON]
GO
/****** Object:  StoredProcedure [dbo].[BAT_MT_DBERROR_TB_INS_PROC]    Script Date: 2021-11-03 오후 4:46:39 ******/
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
