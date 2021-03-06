USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_OUT_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 탈퇴 처리(전날 탈퇴 신청 회원 정보 삭제 및 탈퇴 처리)
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016-08-28
 *  설        명 : 
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
                     SP_REST_OUT 프로시저에서 휴면회원 처리
                     사용자가 신청한 탈퇴 회원만 처리한다
 *  사 용  소 스 :

 *************************************************************************************/
CREATE PROCEDURE [dbo].[BAT_MM_OUT_PROC]

AS
-- 전날 일자
DECLARE @PRE_DT DATETIME
DECLARE @RETURN INT
DECLARE @ROWS INT
DECLARE @LOG_ID INT

SET @PRE_DT = CONVERT(CHAR(10),DATEADD(D,-1,GETDATE()),120)
SET @RETURN = 0

BEGIN TRANSACTION
--------------------------------------------
-- 1. 전날 탈퇴 신청 아이디 가져오기
--------------------------------------------
SELECT CUID
  INTO #TEMP_OUT_CUID
  FROM CST_OUT_MASTER WITH(NOLOCK)
 WHERE OUT_APPLY_DT > @PRE_DT AND OUT_PROC_DT IS NULL

IF (@@ERROR <> 0) 
BEGIN
	ROLLBACK TRANSACTION;
	SET	@RETURN = 1;
END

INSERT INTO CST_BATCH_LOG 
            (BATCH_NM, BATCH_DETAIL, CONDITION) 
		 VALUES ('BAT_MM_OUT_PROC', 'OUT', '회원 신청 탈퇴' ) ;
SET @LOG_ID = @@IDENTITY;

IF (@@ERROR <> 0) 
BEGIN
	ROLLBACK TRANSACTION;
	SET	@RETURN = 1;
END
--------------------------------------------
-- 2. 회원 정보 업데이트
--------------------------------------------
UPDATE CST_MASTER 
  SET USER_NM = ''
    , HPHONE = ''
    , EMAIL = ''
    , BIRTH =  REPLACE(REPLACE(SUBSTRING(BIRTH,1,4),'-',''),' ','')
    , DI = '' 
    , CI = ''
    , MOD_DT = GETDATE()
    , PWD = ''
 FROM #TEMP_OUT_CUID AS A
 JOIN CST_MASTER AS B ON A.CUID = B.CUID

SET @ROWS = @@ROWCOUNT;

IF (@@ERROR <> 0) 
BEGIN
	ROLLBACK TRANSACTION;
	SET	@RETURN = 1;
END

UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;	

-- 탈퇴 테이블
UPDATE	A
   SET	A.OUT_PROC_DT = GETDATE()
  FROM	CST_OUT_MASTER A
	JOIN #TEMP_OUT_CUID B ON A.CUID = B.CUID

IF (@@ERROR <> 0) 
BEGIN
	ROLLBACK TRANSACTION;
	SET	@RETURN = 1;
END		

	
COMMIT TRANSACTION

SELECT @RETURN;
GO
