USE [COMMON]
GO
/****** Object:  StoredProcedure [dbo].[BAT_MT_DBJOB_FAILURE_TB_INS_PROC]    Script Date: 2021-11-03 오후 4:46:39 ******/
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
