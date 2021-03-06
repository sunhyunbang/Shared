USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_SNS]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_LOGIN_SNS]
/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력 SNS
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(0) -- 정상 정상
 * DECLARE @RET INT
 * EXEC @RET=SP_LOGIN_SNS 'nadu81@naver.com' , 'K' ,'207053388', '','IP','HOST'
 * SELECT @RET
 *************************************************************************************/
@SNS_TYPE CHAR(1)  
,@SNS_ID VARCHAR(100) 
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
,@USERID  varchar(50) OUTPUT
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
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)		
		,@ISADULT CHAR(1)
		,@JOIN_DT VARCHAR(10)
    ,@REALHP_YN	CHAR(1)
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
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,			
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = IsNULL(AA.REALHP_YN,'N')
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
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			ISNULL(M.ADULT_YN,'N') AS ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'Y') AS REALHP_YN ,
      C.COM_NM
	 FROM CST_MASTER M WITH(NOLOCK) 
   LEFT JOIN CST_COMPANY AS C WITH(NOLOCK) ON C.COM_ID = M.COM_ID
	WHERE M.OUT_YN='N' 
	  AND M.SNS_TYPE = @SNS_TYPE 
	  AND SNS_ID = @SNS_ID 
		) AA WHERE  AA.STATUS_CD IN ('W', 'A') OR AA.STATUS_CD IS NULL
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/
		IF @REST_YN = 'Y' 
		BEGIN
			RETURN(500) -- 휴면 고객
		END ELSE IF @CUID IS NULL
		BEGIN
			RETURN(400) -- 사용자가 없음
		END ELSE IF @COUNT = 1
		BEGIN 
			SET @PWD_CHANGE_YN = 'N'

			/*전화번호 중복 alert 확인용*/
			IF @MEMBER_CD  = 1  AND ISNULL(@REALHP_YN,'N') <> 'Y'
			BEGIN
				SELECT @DUPLICATE_PHONE = COUNT(*) 
				FROM CST_MASTER WITH(NOLOCK) 
				where HPHONE = @HPHONE and MEMBER_CD = 1 

				IF @DUPLICATE_PHONE  > 1 
				BEGIN
					SET @REALHP_YN ='N'
					SET @DUPLICATE_PHONE = 1
				END 
				ELSE BEGIN
					SET @REALHP_YN ='Y'
					SET @DUPLICATE_PHONE = 0
				END
			END
			BEGIN
				SET @REALHP_YN = 'Y'
			END

		  /*순서 변경하지 마세요. 뒷부분에 추가*/
			SELECT
				--@COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				ISNULL(@GENDER,'') AS GENDER,
				@REST_YN AS REST_YN,
				ISNULL(@BIRTH,'') AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAR_YN,
				ISNULL(@DI,'') AS DI,
				ISNULL(@ISADULT,'') AS ISADULT,
				@SNS_TYPE AS SNS_TYPE,
				@JOIN_DT AS JOIN_DT,
				ISNULL(@REALHP_YN,'') as REALHP_YN
				
				UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()  WHERE CUID = @CUID			  -- 마지막 로그인 시간
				 
				INSERT INTO CST_LOGIN_LOG (CUID, USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									      (@CUID, @USERID, getdate(),@SECTION_CD,'Y', @IP, @HOST )    -- 로그인 이력 남기기
									      
			RETURN(0) -- 정상 정상
		END
GO
