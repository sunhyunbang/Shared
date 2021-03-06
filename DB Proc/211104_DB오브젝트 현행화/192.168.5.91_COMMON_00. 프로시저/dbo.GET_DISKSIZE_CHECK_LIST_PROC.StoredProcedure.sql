USE [COMMON]
GO
/****** Object:  StoredProcedure [dbo].[GET_DISKSIZE_CHECK_LIST_PROC]    Script Date: 2021-11-03 오후 4:46:39 ******/
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
