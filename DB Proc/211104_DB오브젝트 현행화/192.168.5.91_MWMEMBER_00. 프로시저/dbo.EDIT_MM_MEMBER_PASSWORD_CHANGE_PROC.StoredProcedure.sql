USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_MM_MEMBER_PASSWORD_CHANGE_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 찾기>비밀번호 변경
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 변경
 *  주 의  사 항 :
 *  사 용  소 스 :
 EDIT_MM_MEMBER_PASSWORD_CHANGE_PROC 'cowto76', '11111', '12807058'
 *************************************************************************************/
CREATE PROC [dbo].[EDIT_MM_MEMBER_PASSWORD_CHANGE_PROC]
  @USERID     VARCHAR(50)
, @PASSWORD   VARCHAR(20)
, @CUID       INT
AS

BEGIN
  DECLARE @ROWCOUNT INT

  SET NOCOUNT ON
  DECLARE @MD5PWD VARCHAR(100)

  SET @MD5PWD = DBO.FN_MD5(LOWER(@PASSWORD))  -- 소문자 변경 및 MD5로 변경

  UPDATE A
     SET --PWD = @MD5PWD       , 
		 PWD_MOD_DT = GETDATE()
       , PWD_NEXT_ALARM_DT = GETDATE() + 180
       , login_pwd_enc = NULL
       , pwd_sha2	  = master.DBO.fnGetStringToSha256(@MD5PWD)	
    FROM CST_MASTER A
   WHERE CUID = @CUID
  	AND USERID = @USERID

	--jmg@20190103 비밀번호 실패 카운터 초기화
	UPDATE CST_LOGIN_FAIL_COUNT 
	SET FAIL_CNT = 0
	, FAIL_DATE = ''
	WHERE USERID = @USERID
  
  INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, PWD_CHANGE_YN) 
  VALUES (@CUID, @USERID, GETDATE(), 'Y')  -- 이력을 남기자
    
  SELECT @ROWCOUNT = @@ROWCOUNT

  IF @ROWCOUNT <> 1
  BEGIN
    SELECT 1
    RETURN;
  END
  ELSE
  BEGIN
    SELECT 0
    RETURN;
  END 
END



GO
