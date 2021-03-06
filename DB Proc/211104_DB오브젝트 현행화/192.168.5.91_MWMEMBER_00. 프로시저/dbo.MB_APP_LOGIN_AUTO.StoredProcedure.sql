USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[MB_APP_LOGIN_AUTO]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
*  사 용  소 스 : EXEC [MEMBER].[dbo].[MB_APP_LOGIN_AUTO] 회원아이디, 서비스섹션코드, 디바이스아이디, 디바이스이전암호화키, 디바이스업데이트암호화키, 모바일섹션코드

EXEC [MEMBER].[dbo].[MB_APP_LOGIN_AUTO] mediawilltest, 'S101', 'TESTID', 'TESTKEY2', 'TESTKEY', 'A404'
EXEC [MEMBER].[dbo].[MB_APP_LOGIN_AUTO] mediawilltest, 'S101', 'TESTID', 'TESTKEY', 'TESTKEY2', 'A404'

SELECT * FROM MM_MEMBER_TB WHERE USERID = 'mediawilltest'
SELECT * FROM MM_JOIN_TB WHERE USERID = 'mediawilltest'
SELECT * FROM MEMBER.dbo.MM_MB_APP_LOGIN_TB WHERE MID = 'TESTID'
UPDATE MEMBER.dbo.MM_MB_APP_LOGIN_TB SET MKEY = 'TESTKEY' WHERE MID = 'TESTID'
*************************************************************************************/
--DROP PROCEDURE [dbo].[MB_APP_LOGIN_AUTO]
CREATE PROCEDURE [dbo].[MB_APP_LOGIN_AUTO]
	@CUID				INT			-- CUID
	, @SECTION_CD		CHAR(4) = 'S101'	-- 서비스섹션코드(S101 : 벼룩시장 -> MEMBER.dbo.CC_SECTION_TB 참조)
	, @MID				NVARCHAR(400)		-- 디바이스아이디
	, @MKEY				NVARCHAR(100)		-- 디바이스이전암호화키
	, @UPDATE_MKEY		NVARCHAR(100)		-- 업데이트할 디바이스암호화키
	, @MB_SECTION_CD	NVARCHAR(10)		-- 모바일섹션코드(A404 : 요리음식전문앱 -> MEMBER.dbo.CC_SECTION_TB 참조)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	--기업 관련 정보를 가져올 수 없음
	--해당 섹션별 정보가 다를 수 있다는 전제로 출발
	SELECT
		M.CUID
		, M.USERID
		, M.PWD
		, M.PWD AS USER_PWD
		, USER_NM AS USERNAME    -- 개인이름
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
		M.CUID = @CUID AND M.OUT_YN='N'
	
	
	-- 어플 로그인 위한 키 발급
	DECLARE @MKEY_ORG NVARCHAR(100)		--이전 입력된 키값
	DECLARE @RTN_MKEY NVARCHAR(100)		--조회후 리턴할 키값
	SET @MKEY_ORG = ''
	SET @RTN_MKEY = ''

	SELECT TOP 1 @MKEY_ORG = MKEY FROM MM_MB_APP_LOGIN_TB WHERE MID = @MID AND MB_SECTION_CD = @MB_SECTION_CD

	IF ( @MKEY_ORG = @MKEY )
		BEGIN
			UPDATE MM_MB_APP_LOGIN_TB SET MKEY = @UPDATE_MKEY, last_access_date = GETDATE() WHERE MID = @MID AND MB_SECTION_CD = @MB_SECTION_CD
			SET @RTN_MKEY = @UPDATE_MKEY
		END
	ELSE
		BEGIN
			SET @RTN_MKEY = '401'
		END

	SELECT @RTN_MKEY AS MKEY
GO
