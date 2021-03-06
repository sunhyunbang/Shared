USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[MB_CHK_LOGIN_PROC_NOPWD]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 기업, 일반 회원 로그인 체크(비번 없음)
 *  작   성   자 : 김 준 홍
 *  작   성   일 : 
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * EXEC MB_CHK_LOGIN_PROC_NOPWD NULL
 
 select * FROM CST_MASTER where userid ='kkam1234'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[MB_CHK_LOGIN_PROC_NOPWD]
    @CUID    INT
AS
BEGIN

	SET NOCOUNT ON
		
	DECLARE @RTN INT
	SET @RTN = 0
	
	DECLARE @ERROR INT

	SELECT
		ROW_NUMBER()  OVER( ORDER BY M.CUID DESC) AS ROW,
		M.USERID,
		M.USER_NM AS USERNAME,
		M.MEMBER_CD,
		ISNULL(C.COM_NM, '') AS COM_NM,
		ISNULL(M.EMAIL, '') AS EMAIL,
		ISNULL(M.HPHONE, '') AS HPHONE,
		ISNULL(C.PHONE, '') AS PHONE,
		ISNULL(C.ADDR1, '') AS ADDR_A,
		ISNULL(C.ADDR2, '') AS ADDR_B,
		'S101' AS SECTION_CD, /* 회원통합 후 의미없어짐 */
		M.BAD_YN,
		M.BIRTH AS JUMINNO_A,
		M.DI,		
		M.REST_YN,
		M.ADULT_YN AS ISADULT,
		M.SNS_TYPE,
		DATEDIFF(DAY, M.PWD_NEXT_ALARM_DT, GETDATE()) AS PWD_ALARM_YN,
		M.JOIN_DT,
		M.GENDER
	FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
	WHERE M.OUT_YN='N'			
		AND M.CUID = @CUID
		AND ( M.STATUS_CD IN ('W','A') OR M.STATUS_CD IS NULL ) 

	/* NULL : 통합 전    로그인 가능
				W : 통합 승인대기중  로그인 가능
				A : 통합 후 마스터계정   로그인 가능
				D : 통합 후 서브계정  로그인 불가능
				*/
		
	SELECT @ERROR=@@ERROR
	IF @ERROR<>0            --조회 에러
	BEGIN
		SET @RTN = 101
	END

	--회원 휴면 여부 판단
	DECLARE @REST_YN CHAR(1)  
	SELECT @REST_YN = REST_YN
	FROM CST_MASTER WITH (NOLOCK)
	WHERE CUID = @CUID AND OUT_YN='N'

	IF @REST_YN = 'Y' 
	BEGIN
		--휴면 회원 ID는 휴면 회원 페이지로 이동
		SET @RTN = 99
	END
	
	DECLARE @MEMBER_CD    CHAR(1)
	SELECT
		@MEMBER_CD = MEMBER_CD
	FROM CST_MASTER WITH(NOLOCK)
	WHERE CUID = @CUID
		AND OUT_YN='N'   

	SELECT @ERROR=@@ERROR
	IF @ERROR<>0            --조회 에러
	BEGIN
		SET @RTN = 100
	END

	IF @MEMBER_CD IS NULL   --로그인 실패
	BEGIN
		SET @RTN = 1
	END	
  
	SELECT @RTN AS RTN

END
GO
