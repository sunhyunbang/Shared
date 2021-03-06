USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_BK01]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
  DECLARE @RET INT
  EXEC @RET=SP_LOGIN 'sebilia','hs7410!!' , 'S101' ,'60.209.90.89','land.findall.co.kr'
  SELECT @RET  -- 성공
  declare @DUPLICATE_YN INT 
  		EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160
	SELECT @DUPLICATE_YN
	
	exec DBO.SP_LOGIN_BK01 'kkamang1234','hs7410!!','S101','121.166.161.13','www.findall.co.kr'
	
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_BK01]
@USERID VARCHAR(50) 
,@PWD VARCHAR(30)
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
AS
	SET NOCOUNT ON;
	DECLARE  
		@CUID INT
		,@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)
		,@ISADULT  CHAR(1)
		,@JOIN_DT VARCHAR(10)
		,@REALHP_YN	CHAR(1)
		,@ROWCOUNT INT
		,@LAND_CLASS_CD VARCHAR(30)
		,@REST_DT VARCHAR(10)
		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = ISNULL(AA.USER_NM,''),
			@EMAIL = ISNULL(AA.EMAIL,''),
			@HPHONE = ISNULL(AA.HPHONE,''),
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = ISNULL(AA.COM_NM,''),
			@CONFIRM_YN = AA.CONFIRM_YN,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = AA.REALHP_YN,
			@LAND_CLASS_CD = AA.LAND_CLASS_CD,
			@REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END)
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			ISNULL(M.ADULT_YN,'N') AS ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'N') AS REALHP_YN,
			CL.LAND_CLASS_CD,
			M.REST_DT
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
			 LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID
		WHERE M.OUT_YN='N'
		  AND M.USERID = 'kkam1234' 
			AND (PWD = DBO.FN_MD5(LOWER(@PWD)) OR PwdCompare(@PWD, login_pwd_enc) = 1)
		) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
		
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/			
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음
		set @ROWCOUNT = @@ROWCOUNT
		
		
		
		SELECT @CUID,@ROWCOUNT
GO
