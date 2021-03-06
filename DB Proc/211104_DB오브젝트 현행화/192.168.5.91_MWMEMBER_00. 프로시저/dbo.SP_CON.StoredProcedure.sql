USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_CON]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CON]--[SP_LOGIN_SNS]
/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력 SNS
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * CUID ,USERID, USER_NM, 이메일, 회사명, 휴대폰, 회원타입(개인/기업), 성별, 연령, 휴면여부, 생년월일, 비번 변경일로부터 90일 지난여부(Y/N)
 *************************************************************************************/
@USERID varchar(50)
,@SNS_TYPE CHAR(1)  --K
,@SNS_ID VARCHAR(25) -- 207053388
,@SECTION_CD CHAR(4)
,@IP VARCHAR(14)
,@HOST VARCHAR(50)
,@PKEY INT
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
		--,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT


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
			--@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD
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
			--M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD
		FROM CST_MASTER M LEFT OUTER JOIN CST_COMPANY C ON M.COM_ID = C.COM_ID
		WHERE M.OUT_YN='N' AND M.USERID = @USERID AND M.SNS_TYPE = @SNS_TYPE AND SNS_ID = @SNS_ID) AA
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음

		IF @REST_YN = 'Y' 
		BEGIN
			RETURN(500) -- 휴면 고객
		END ELSE IF @CUID IS NULL
		BEGIN
			RETURN(400) -- 사용자가 없음
			/*
		END ELSE IF @COUNT > 1 
		BEGIN 
			RETURN(300) -- 복수의 아이디
			
		END ELSE IF @TRUE_YN = 'N'
		BEGIN
			INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST, PKEY) VALUES
									  (@CUID ,@USERID, getdate(), @SECTION_CD,'N', @IP, @HOST, @PKEY)
			RETURN(200) -- 비밀 번호 틀림
			*/
		END ELSE IF @COUNT = 1
		BEGIN 
			--SET @PWD_CHANGE_YN = 'N'
			--IF @PWD_NEXT_ALARM_DT < GETDATE() - 90 SET @PWD_CHANGE_YN = 'Y'
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
				@MEMBER_CD AS MEMBER_CD
				--@TRUE_YN AS TRUE_YN
				--@PWD_CHANGE_YN AS PWD_CHANGE_YN

				--UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()  WHERE CUID = @CUID			  -- 마지막 로그인 시간 
				INSERT INTO CST_LOGIN_LOG (CUID, USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST, PKEY) VALUES
									      (@CUID, @USERID, getdate(),@SECTION_CD,'Y', @IP, @HOST, @PKEY)    -- 로그인 이력 남기기
			RETURN(0) -- 정상 정상
		END	
GO
