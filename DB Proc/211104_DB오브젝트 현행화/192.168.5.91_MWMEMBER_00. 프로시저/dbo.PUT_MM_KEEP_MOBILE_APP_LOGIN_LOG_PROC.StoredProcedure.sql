USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_KEEP_MOBILE_APP_LOGIN_LOG_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일 앱 회원 로그인 유지> 로그쌓기
 *  작   성   자 : 조재성
 *  작   성   일 : 2017-03-21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :

 *************************************************************************************/

CREATE PROCEDURE [dbo].[PUT_MM_KEEP_MOBILE_APP_LOGIN_LOG_PROC]
   @CUID        INT
	,@USERID		  VARCHAR(50)	-- 회원아이디
	,@SECTION_CD	CHAR(4)		-- 섹션코드
	,@MEMBER_CD		CHAR(1)		-- 회원구분
	,@HOST			  VARCHAR(30)	-- 호스트(WWW.FINDJOB.CO.KR, 051.FINDJOB.CO.KR..)
	,@IP			    VARCHAR(15)	-- 회원PC_IP
	,@STR_RETURN       VARCHAR(10) = '' OUTPUT
AS
SET NOCOUNT ON

IF EXISTS (SELECT * FROM CST_MASTER WITH (NOLOCK) WHERE CUID = @CUID AND ISNULL(REST_YN,'')<>'Y' AND ISNULL(OUT_YN,'')<>'Y')
BEGIN     

  UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()
    WHERE CUID = @CUID			  -- 마지막 로그인 시간 

  -- 로그 쌓기
  INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) 
  VALUES (@CUID ,@USERID, getdate(), @SECTION_CD,'Y', @IP, @HOST)

END
ELSE
BEGIN
  --로그인 유지 쿠키 삭제
  SET @STR_RETURN = 'LOGOUT'
END
GO
