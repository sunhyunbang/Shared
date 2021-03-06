USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[MB_APP_LOGIN_NEW]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
*  단위 업무 명 : 모바일 어플 기업, 일반 회원 로그인 체크
*  작   성   자 : 함창훈(innerspace@mediawill.com)
*  작   성   일 : 
*  수   정   자 :
*  수   정   일 :
*  설        명 : 
*  주 의  사 항 : 
*  사 용  소 스 : 
-- EXEC [dbo].[MB_APP_LOGIN_NEW] [회원아이디], [비밀번호], [디바이스아이디], [디바이스암호화키], [모바일섹션코드]
-- EXEC [dbo].[MB_APP_LOGIN_NEW] 'entjssin', 'jjss0486', '', '', 'A404'
*************************************************************************************/
CREATE PROCEDURE [dbo].[MB_APP_LOGIN_NEW]
	@USERID					VARCHAR(50)				-- 회원아이디
, @PASSWORD				VARCHAR(32)				-- 비번
, @MID						NVARCHAR(400)			-- 디바이스아이디
, @MKEY						NVARCHAR(100)			-- 디바이스암호화키
, @MB_SECTION_CD	NVARCHAR(4)				-- 모바일섹션코드(A404 : 요리음식전문앱 -> MEMBER.dbo.CC_SECTION_TB 참조)
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @RTN INT = 400 -- 기본 (400:사용자가없음)
	EXEC @RTN = [dbo].[SP_LOGIN] @USERID, @PASSWORD, @MB_SECTION_CD, '', ''

	--IF @RTN = 0
	--	BEGIN

	--	END

END
GO
