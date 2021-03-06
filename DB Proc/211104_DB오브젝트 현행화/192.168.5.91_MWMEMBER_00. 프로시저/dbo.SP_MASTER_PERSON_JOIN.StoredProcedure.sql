USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_PERSON_JOIN]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_MASTER_PERSON_JOIN]
/*************************************************************************************
 *  단위 업무 명 : 개인 회원 가입 및 이력
 *  작   성   자 : 최승범
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 DBO.SP_MASTER_PERSON_JOIN 'bird3325@naver.com', '', 'N', '1', '조민기', '010-6393-0923', 'bird3325@naver.com', 'M', '19970706', 'N', '23598650', '', '','www.findall.co.kr', '0', 'F', 'S101', 'N'
 DBO.SP_MASTER_PERSON_JOIN '','','N', '1', '조민기', '010-6393-0923', '', 'M', '1990713', 'K', '41197063', '', '', 'WWW.FINDALL.CO.KR', 0, 'F', 'S101', 'N'
 *************************************************************************************/
 -- 개인 정보
@USERID  varchar(50),
@PWD  VARCHAR(30) = NULL,
@ADULT_YN  char(1),
@MEMBER_CD  char(1),
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@EMAIL  varchar(50),
@GENDER  char(1),
@BIRTH  varchar(8),
@SNS_TYPE  char(1),
@SNS_ID  varchar(100),
@DI  char(64),
@CI  char(88),
--이력 정보
--@JOIN_PATH varchar(50),
@JOIN_DOMAIN varchar(50),
@JOIN_OBJECT INT ,
@SITE_CD char(1),
@SECTION_CD char(4),
@HPCHECK char(1),
@JOIN_IP	varchar(20),
@CUID int = 0 output

AS
	SET	XACT_ABORT	ON
	SET NOCOUNT ON;

	DECLARE @COUNT INT, @PWD_NEXT_ALARM_DT DATETIME
	SET @PWD_NEXT_ALARM_DT = GETDATE() + 180
	
	-- SNS 가입자이면
	IF @PWD='' AND @SNS_TYPE<>''
	BEGIN
		SET @PWD = NULL
		SET @PWD_NEXT_ALARM_DT = NULL
		SET @DI = NULL
		SET @CI = NULL

		SELECT @COUNT = COUNT(*)  
		  FROM CST_MASTER WITH (NOLOCK)
		 WHERE SNS_ID  = @SNS_ID
		 AND SNS_TYPE = @SNS_TYPE
		 AND OUT_YN='N'

	END	
	ElSE 
	BEGIN
		SELECT @COUNT = COUNT(*)  
		  FROM CST_MASTER WITH (NOLOCK)
		 WHERE USERID = @USERID
	END
	 
	IF @COUNT=0
	BEGIN

			INSERT INTO CST_MASTER ( 
									USERID,  
									USER_NM, 
									BAD_YN, 
									JOIN_DT,   
									MOD_DT,    
									MOD_ID , 
									pwd_sha2 , 
									PWD_NEXT_ALARM_DT ,
									MEMBER_CD,  
									REST_YN, 
									OUT_YN, 
									ADULT_YN, 
									HPHONE, 
									EMAIL, 
									GENDER, 
									BIRTH, 
									SNS_TYPE, 
									SNS_ID , 
									CI, 
									DI,
									LAST_LOGIN_DT,
									SITE_CD,
									REALHP_YN,
									JOIN_IP)
			VALUES (@USERID, 
					@USER_NM, 
					'N',   
					GETDATE(), 
					GETDATE(), 
					@USERID, 
					master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD))), 
					@PWD_NEXT_ALARM_DT ,
					--@MEMBER_CD ,  
					'1',
					'N' ,   
					'N', 
					@ADULT_YN, 
					@HPHONE, 
					@EMAIL, 
					@GENDER, 
					@BIRTH, 
					@SNS_TYPE, 
					@SNS_ID, 
					@CI, 
					@DI,
					GETDATE(),
					@SITE_CD,
					@HPCHECK,
					@JOIN_IP)
			
			SET @CUID = SCOPE_IDENTITY() 
			
			 -- 써브 비번 변경 호출 2016.09.07 jmg
			 --exec [221.143.23.211,8019].rserve.dbo.SV_PWD_SYNC @CUID, @PWD
			
			IF @HPCHECK = 'Y'
			BEGIN
				UPDATE CST_MASTER 
				SET REALHP_YN = 'N'
				WHERE CUID <> @CUID AND HPHONE = @HPHONE AND MEMBER_CD = '1' AND @HPHONE > ''
			END
			
			IF  @SNS_ID <> '' AND (@SNS_TYPE = 'K' OR @SNS_TYPE = 'N' OR @SNS_TYPE = 'F' OR @SNS_TYPE = 'A' )
			BEGIN
				UPDATE CST_MASTER
				SET USERID = @CUID
				WHERE CUID = @CUID
			END

			-- 이력을 남기자...
			INSERT INTO CST_JOIN_INFO (CUID, USERID, JOIN_DOMAIN, JOIN_OBJECT, SECTION_CD)
			VALUES (@CUID, @USERID, @JOIN_DOMAIN, @JOIN_OBJECT, @SECTION_CD)	
			
			SELECT @CUID
		END
GO
