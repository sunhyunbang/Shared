USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_KEEP_LOGIN_LOG_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 로그인 유지> 로그쌓기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016-03-23
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :

declare @outtoken varchar(36) 
SET @outtoken = '6220E8F8-49B1-400F-A617-53FC80A0B0B7'
EXEC [PUT_MM_KEEP_LOGIN_LOG_PROC] 'sebilia','S101','2','www.findall.co.kr','123.111.230.51',@TOKEN = @outtoken OUTPUT
SELECT @outtoken
 *************************************************************************************/

CREATE PROCEDURE [dbo].[PUT_MM_KEEP_LOGIN_LOG_PROC]
   @CUID        INT
	,@USERID		  VARCHAR(50)	-- 회원아이디
	,@SECTION_CD	CHAR(4)		-- 섹션코드
	,@MEMBER_CD		CHAR(1)		-- 회원구분
	,@HOST			  VARCHAR(30)	-- 호스트(WWW.FINDJOB.CO.KR, 051.FINDJOB.CO.KR..)
	,@IP			    VARCHAR(15)	-- 회원PC_IP
	,@TOKEN       VARCHAR(36) OUTPUT
 
AS

IF LEN(@TOKEN)<>36
BEGIN
  --로그인 유지 쿠키 삭제
  SET @TOKEN = 'LOGOUT'
  RETURN (0)
END

IF EXISTS (
  SELECT * FROM MM_TOKEN_TB WITH (NOLOCK)
   WHERE CUID = @CUID AND TOKEN = @TOKEN
)
BEGIN     
  DECLARE @NEWTOKEN VARCHAR(36)
  
  SET @NEWTOKEN = NEWID()
  UPDATE MM_TOKEN_TB
     SET TOKEN = CAST(@NEWTOKEN AS UNIQUEIDENTIFIER)
       , LAST_LOGIN_DT = GETDATE()
   WHERE CUID = @CUID

  UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()
    WHERE CUID = @CUID			  -- 마지막 로그인 시간 

  -- 로그 쌓기
  INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) 
                     VALUES (@CUID ,@USERID, getdate(), @SECTION_CD,'Y', @IP, @HOST)

  SET @TOKEN = @NEWTOKEN

END
ELSE
BEGIN
  --로그인 유지 쿠키 삭제
  SET @TOKEN = 'LOGOUT'
END
GO
