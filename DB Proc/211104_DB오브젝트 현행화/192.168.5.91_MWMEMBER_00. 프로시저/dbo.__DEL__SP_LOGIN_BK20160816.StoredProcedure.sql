USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[__DEL__SP_LOGIN_BK20160816]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[__DEL__SP_LOGIN_BK20160816]
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
 * DECLARE @RET INT
 * EXEC @RET=SP_CON 'nadu81@naver.com' , 'A' , '','IP','HOST'
 * SELECT @RET  -- 성공
 *************************************************************************************/
@USERID varchar(50) 
,@PWD VARCHAR(30)
,@SECTION_CD CHAR(4)
,@IP VARCHAR(14)
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
		,@MASTER_ID INT
		,@STATUS_CD CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		


		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = AA.USER_NM,
			@EMAIL = AA.EMAIL,
			@HPHONE = AA.HPHONE,
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = AA.COM_NM,
			@CONFIRM_YN = AA.CONFIRM_YN,
			@MASTER_ID = AA.MASTER_ID,
			@STATUS_CD = AA.STATUS_CD,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY USERID DESC) AS ROW,
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
			'Y' AS TRUE_YN
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
		WHERE M.OUT_YN='N'
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/
		AND M.USERID = @USERID 
			AND (PWD = DBO.FN_MD5(LOWER(@PWD)) OR PwdCompare(@PWD, login_pwd_enc) = 1)
		) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
			
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음

		/* 2순위 계정 체크 시작 {계정 변환 로직으로 ~!!! 300 }*/
		EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC @CUID
		
		IF @DUPLICATE_YN = 1
		BEGIN
			SET @COUNT = 2
		END
		/* 2순위 계정 체크  끝*/
		
	
		IF @REST_YN = 'Y' 
		BEGIN
			RETURN(500) -- 휴면 고객
		END ELSE IF @CUID IS NULL
		BEGIN
			RETURN(400) -- 사용자가 없음
		END ELSE IF @COUNT > 1 
		BEGIN 
			RETURN(300) -- 복수의 아이디
		END ELSE IF @TRUE_YN = 'N'
		BEGIN
			INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									  (@CUID ,@USERID, getdate(), @SECTION_CD,'N', @IP, @HOST)
			RETURN(200) -- 비밀 번호 틀림
		END ELSE IF @COUNT = 1
		BEGIN 
			SET @PWD_CHANGE_YN = 'N'
			IF @PWD_NEXT_ALARM_DT < GETDATE() SET @PWD_CHANGE_YN = 'Y'
			SELECT
				-- @COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				@GENDER AS GENDER,
				@REST_YN AS REST_YN,
				@BIRTH AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				@MASTER_ID AS MASTER_ID,
				@STATUS_CD AS STATUS_CD,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN

				UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()  WHERE CUID = @CUID			  -- 마지막 로그인 시간 
				INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									  (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기
			RETURN(0) -- 정상 정상
		END	

GO
