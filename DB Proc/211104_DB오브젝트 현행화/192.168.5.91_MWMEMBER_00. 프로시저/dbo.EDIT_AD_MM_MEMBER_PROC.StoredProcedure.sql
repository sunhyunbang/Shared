USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_AD_MM_MEMBER_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원리스트 >  상세 > 수정처리
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015.02.24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :

 *************************************************************************************/

CREATE PROCEDURE [dbo].[EDIT_AD_MM_MEMBER_PROC]
     @CUID         INT
   , @USERID       VARCHAR(50)        -- 아이디
   , @USERNAME     VARCHAR(30)        -- 이름
   , @PASSWORD     VARCHAR(30) = ''   -- 비밀번호
   , @EMAIL        VARCHAR(50)        -- 이메일
   , @HPHONE       VARCHAR(14)        -- 휴대폰번호
   , @ADMIN_ID     VARCHAR(30) = ''    -- 관리자아이디
AS

DECLARE @PWDCHANGEYN  CHAR(1)
SET @PWDCHANGEYN='N'
--------------------------------
-- 공통 테이블
--------------------------------
IF @PASSWORD=''
BEGIN
		--패스워드 제외
    UPDATE DBO.CST_MASTER
       SET USER_NM = @USERNAME
         , EMAIL    = @EMAIL
         , HPHONE   = @HPHONE
         , MOD_DT   = GETDATE()
         , MOD_ID   = @ADMIN_ID
     WHERE USERID   = @USERID
       AND CUID = @CUID
END
ELSE
BEGIN
    SET @PWDCHANGEYN='Y'
    
    UPDATE DBO.CST_MASTER
       SET 
       --PWD        = DBO.FN_MD5(LOWER(@PASSWORD))         , 
         PWD_MOD_DT = GETDATE()
         , PWD_NEXT_ALARM_DT = GETDATE()
         , USER_NM   = @USERNAME
         , EMAIL      = @EMAIL
         , HPHONE     = @HPHONE
         , MOD_DT     = GETDATE()
         , MOD_ID     = @ADMIN_ID
         ,pwd_sha2	  = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PASSWORD)))	
     WHERE USERID = @USERID
       AND CUID = @CUID
       
	UPDATE CST_LOGIN_FAIL_COUNT 
	SET FAIL_CNT = 0
	, FAIL_DATE = ''
	WHERE USERID = @USERID
END

	INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, HPHONE, COM_ID, USER_NM, PWD_CHANGE_YN) 
	     VALUES (@CUID, @ADMIN_ID, getdate(), @HPHONE, NULL, @USERNAME, @PWDCHANGEYN)
GO
