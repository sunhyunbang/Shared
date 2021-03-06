USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOMER_INTEGRATION_LIST]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CUSTOMER_INTEGRATION_LIST]
/*************************************************************************************
 *  단위 업무 명 : 통합 회원 확인
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0) 정상
 * RETURN(500)  에러..
 * DECLARE RET INT
 * EXEC @RET=SP_CUSTOMER_INTEGRATION_LIST  'nadu81@naver.com' , 'AA' , 'F'
 * SELECT @RET
 *************************************************************************************/
@SELECT_USERID VARCHAR(50),  -- 찾을 유져아이디
@SELECT_PWD VARCHAR(20),     -- 
@SEELCT_SITE_CD CHAR(1),
@MEMBER_CD CHAR(1)     -- 현재 로그인 한 회원 상태 값
AS	
	SET NOCOUNT ON;
	DECLARE @USER_NM varchar(30),
			@EMAIL varchar(50),
			@HPHONE varchar(14),
			@MAIN_PHONE varchar(14),
			@CEO_NM varchar(30),
			@COM_NM varchar(50),
			@JOIN_DT DATETIME,
			@LAST_LOGIN_DT DATETIME,
			@REGISTER_NO varchar(12)
		
		SELECT @USER_NM = USER_NM
		   ,@EMAIL = EMAIL
		   ,@HPHONE = HPHONE
		   ,@MAIN_PHONE = CO.MAIN_PHONE
		   ,@JOIN_DT = M.JOIN_DT
		   ,@LAST_LOGIN_DT = M.LAST_LOGIN_DT
--		   ,CO.CITY 
--		   ,CO.GU
--		   ,CO.DONG
		   ,@REGISTER_NO = CO.REGISTER_NO
		   ,@MEMBER_CD = M.MEMBER_CD
		   ,@CEO_NM = CO.CEO_NM
		   ,@COM_NM = CO.COM_NM
			FROM CST_MASTER M WITH(NOLOCK) LEFT JOIN CST_COMPANY CO  WITH(NOLOCK) ON 
			M.COM_ID = CO.COM_ID
			WHERE USERID = @SELECT_USERID
			AND M.SITE_CD = @SEELCT_SITE_CD
			AND  pwd_sha2 = master.DBO.fnGetStringToSha256(dbo.FN_MD5(LOWER(@SELECT_PWD)))
			AND M.MEMBER_CD = @MEMBER_CD 
			AND REST_YN = 'N' AND OUT_YN = 'N'


	IF @MEMBER_CD = 1
	BEGIN
	SELECT  @USER_NM AS USER_NM
		   ,@EMAIL AS EMAIL
		   ,@HPHONE AS  HPHONE

		RETURN(0)
	END ELSE IF @MEMBER_CD = 2
	BEGIN
		SELECT
			@USER_NM AS USER_NM
		   ,@EMAIL AS EMAIL
		   ,@HPHONE AS HPHONE
		   ,@MAIN_PHONE AS MAIN_PHONE
		   ,@CEO_NM AS CEO_NM
		   ,@COM_NM AS COM_NM
		   ,@REGISTER_NO AS REGISTER_NO
		RETURN(0)
	END ELSE
		BEGIN
			RETURN(500)
		END
GO
