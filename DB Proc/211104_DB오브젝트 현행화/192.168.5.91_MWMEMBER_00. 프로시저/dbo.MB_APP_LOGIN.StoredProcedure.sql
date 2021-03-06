USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[MB_APP_LOGIN]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
*  사 용  소 스 : EXEC [MEMBER].[dbo].[MB_APP_LOGIN] 회원아이디, 비밀번호, 서비스섹션코드, 디바이스아이디, 모바일섹션코드

* RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
 * RETURN(900) -- 복수의 아이디(아이디/비번 중복됨)

EXEC [MEMBER].[dbo].[MB_APP_LOGIN] mediawilltest, '1Q2W3E!q@w#e', 'S101', 'TESTID', 'TESTKEY', 'A404'
EXEC [MEMBER].[dbo].[MB_APP_LOGIN] mediawilltest, '1Q2W3E!q@w#e', '', 'TESTID', 'TESTKEY2', 'A404'

EXEC [MEMBER].[dbo].[MB_APP_LOGIN] mediawilltest, '1234', 'S101', 'TESTID', 'TESTKEY', 'A404'
EXEC [MB_APP_LOGIN] 'dfds', '1234', 'S101', 'TESTID', 'TESTKEY', 'A404','',''

EXEC [MB_APP_LOGIN] 'mwmobile', 'mw4758!!', 'S101', 'TESTID', 'TESTKEY', 'A404','',''
mwmobile / mw4758!!



SELECT * FROM MM_MEMBER_TB WHERE USERID = 'mediawilltest'
SELECT * FROM MM_JOIN_TB WHERE USERID = 'mediawilltest'
SELECT * FROM MEMBER.dbo.MM_MB_APP_LOGIN_TB WHERE MID = 'TESTID'
UPDATE MEMBER.dbo.MM_MB_APP_LOGIN_TB SET MKEY = 'TESTKEY' WHERE MID = 'TESTID'
*************************************************************************************/
--DROP PROCEDURE [dbo].[MB_APP_LOGIN]
CREATE PROCEDURE [dbo].[MB_APP_LOGIN]
	@USERID				VARCHAR(50)				-- 회원아이디
	, @PASSWORD			VARCHAR(32)			-- 비번
	, @SECTION_CD		CHAR(4) = 'S101'	-- 서비스섹션코드(S101 : 벼룩시장 -> MEMBER.dbo.CC_SECTION_TB 참조)
	, @MID				NVARCHAR(400)		-- 디바이스아이디
	, @MKEY				NVARCHAR(100)		-- 디바이스암호화키
	, @MB_SECTION_CD	NVARCHAR(10)		-- 모바일섹션코드(A404 : 요리음식전문앱 -> MEMBER.dbo.CC_SECTION_TB 참조)
	, @IP				VARCHAR(15)
	, @HOST				VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	
	DECLARE @RET INT
	EXEC @RET=SP_LOGIN @USERID, @PASSWORD, @MB_SECTION_CD, @IP, @HOST

/*	
	SELECT
		M.CUID
		, M.USERID
		, M.PWD
		, DBO.FN_MD5(LOWER(@PASSWORD)) AS USER_PWD
		, M.USER_NM AS USERNAME    -- 개인이름
		, M.MEMBER_CD
		, '' AS COM_NM    -- 기업명(기업만 사용)
		, ISNULL(M.EMAIL,'') AS EMAIL
		, ISNULL(M.HPHONE,'') AS HPHONE
		, '' AS PHONE
		, '' AS ADDR_A
		, '' AS ADDR_B
		, '' AS SECTION_CD     -- 섹션별 동의 해야 이용가능
		, M.BAD_YN
		, CASE WHEN LEN(M.BIRTH) = 8 THEN SUBSTRING(M.BIRTH,3,6) ELSE M.BIRTH END AS JUMINNO_A        --주민번호_A
		, M.DI
		, M.REST_YN
		, ISNULL(M.ADULT_YN,'') AS ISADULT
		, '' AS SNS_TYPE
		, DATEDIFF(DAY, M.PWD_NEXT_ALARM_DT, GETDATE()) AS PWD_ALARM_YN
		, M.JOIN_DT
		, OUT_YN AS OUT_APPLY_YN

	FROM 
		CST_MASTER M
	WHERE 
		M.USERID = @USERID AND M.OUT_YN='N'
*/	
	-- 어플 로그인 처리를 위한 리턴 값
	DECLARE @RTN_MKEY NVARCHAR(100)
	IF(@RET = 0) SET @RTN_MKEY = '200'
	ELSE IF(@RET = 200) SET @RTN_MKEY = '401'
	ELSE IF(@RET = 300) SET @RTN_MKEY = '406'
	ELSE IF(@RET = 400) SET @RTN_MKEY = '404'
	ELSE IF(@RET = 500) SET @RTN_MKEY = '405'
	ELSE IF(@RET = 900) SET @RTN_MKEY = '407'
	ELSE SET @RTN_MKEY = ''


	IF ( @RTN_MKEY = '200' )
		BEGIN
			IF EXISTS(SELECT * FROM MM_MB_APP_LOGIN_TB WITH(NOLOCK) WHERE MID = @MID AND MB_SECTION_CD = @MB_SECTION_CD)
				BEGIN
					UPDATE MM_MB_APP_LOGIN_TB SET MKEY = @MKEY, last_access_date = GETDATE() WHERE MID = @MID AND MB_SECTION_CD = @MB_SECTION_CD
				END
			ELSE
				BEGIN
					INSERT INTO MM_MB_APP_LOGIN_TB (MID, MKEY, MB_SECTION_CD, reg_date, last_access_date) VALUES ( @MID, @MKEY, @MB_SECTION_CD, GETDATE(), GETDATE() )
				END

			SET @RTN_MKEY = @MKEY
		END

	SELECT @RTN_MKEY AS MKEY

GO
