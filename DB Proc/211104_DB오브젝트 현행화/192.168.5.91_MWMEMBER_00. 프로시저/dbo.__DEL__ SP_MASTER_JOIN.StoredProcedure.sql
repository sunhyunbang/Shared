USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[__DEL__ SP_MASTER_JOIN]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[__DEL__ SP_MASTER_JOIN]
/*************************************************************************************
 *  단위 업무 명 : 개인/기업 회원 가입 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *
 * RETURN(@COM_ID)
 * DECLARE @COM_ID
 * EXEC @COM_ID=SP_MASTER_JOIN
 * SELECT @COM_ID
 *************************************************************************************/
 -- 개인 정보
@USERID  varchar(50),
@PWD  VARCHAR(30),
@FLOW  varchar(100),
@ADULT_YN  char(1),
@MEMBER_CD  char(1),
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@EMAIL  varchar(50),
@GENDER  char(1),
@BIRTH  varchar(8),
@SNS_TYPE  char(1),
@SNS_ID  varchar(25),
@DI  char(64),
@CI  char(88),
-- 기업 정보
@COM_NM  varchar(50),
@CEO_NM  varchar(30),
@MAIN_PHONE  varchar(14),
@PHONE  varchar(14),
@FAX  varchar(14),
@HOMEPAGE  varchar(100),
@REGISTER_NO  varchar(12),
@LAT  decimal(16, 14),
@LNG  decimal(17, 14),
@ZIP_SEQ  int,
@CITY  varchar(50),
@GU  varchar(50),
@DONG  varchar(50),
@ADDR1  varchar(100),
@ADDR2  varchar(100),
@LAW_DONGNO  char(10),
@MAN_NO  varchar(25),
@ROAD_ADDR_DETAIL  varchar(100),
--이력 정보
@SITE_CD  char(1),
@JOIN_PATH varchar(50),
@JOIN_DOMAIN varchar(50),
@JOIN_OBJECT INT ,
@CUID int = 0 output,
@COM_ID int = 0 output
AS
	SET NOCOUNT ON;
	--DECLARE @CUID INT, @ID_COUNT BIT, @COM_ID INT
	DECLARE @ID_COUNT BIT
		
		BEGIN
		

			INSERT INTO CST_MASTER ( USERID,  USER_NM, BAD_YN, JOIN_DT,   MOD_DT,    MOD_ID , PWD , MEMBER_CD, SITE_CD, REST_YN, OUT_YN)
							VALUES (@USERID, @USER_NM, 'N',   GETDATE(), GETDATE(), @USERID, DBO.FN_MD5(LOWER(@PWD)), @MEMBER_CD ,@SITE_CD ,  'N' ,   'N')

			UPDATE CST_MASTER SET ADULT_YN = @ADULT_YN, HPHONE = @HPHONE, EMAIL = @EMAIL, GENDER = @GENDER, BIRTH = @BIRTH, 
								  LAST_LOGIN_DT = GETDATE()
				   WHERE CUID = @CUID
			
			IF @SNS_TYPE IS NOT NULL
				BEGIN
				UPDATE CST_MASTER SET SNS_TYPE = @SNS_TYPE, SNS_ID = @SNS_ID
						WHERE CUID = @CUID
				END

			IF @MEMBER_CD = 2
				BEGIN
				SELECT @COM_ID = MAX(COM_ID) + 1 FROM CST_COMPANY
				UPDATE CST_MASTER SET DI = @DI, CI = @CI, MEMBER_CD = @MEMBER_CD, COM_ID = @COM_ID
						WHERE CUID = @CUID
				-- CST_COMPANY
				INSERT INTO CST_COMPANY (COM_NM, CEO_NM, MAIN_PHONE , PHONE, FAX , HOMEPAGE , REGISTER_NO ,
										LAT , LNG , ZIP_SEQ, CITY,
										GU , DONG , ADDR1 , ADDR2 , LAW_DONGNO , MAN_NO , ROAD_ADDR_DETAIL, CUID )
					             VALUES (@COM_NM, @CEO_NM, @MAIN_PHONE, @PHONE, @FAX , @HOMEPAGE , @REGISTER_NO , 
										@LAT ,@LNG, @ZIP_SEQ , @CITY ,
										@GU ,@DONG ,@ADDR1 , @ADDR2 , @LAW_DONGNO , @MAN_NO , @ROAD_ADDR_DETAIL, @CUID)
				/*왜 따로??? 2016-08-24 정헌수*/
				UPDATE CST_COMPANY SET REG_ID = @USERID , REG_DT = GETDATE() , MOD_ID = @USERID , MOD_DT = GETDATE()
									WHERE COM_ID = @COM_ID
				
				RETURN(@COM_ID)
				
				END
				-- 이력을 남기자...
				INSERT INTO CST_JOIN_INFO (CUID, USERID, JOIN_DOMAIN, JOIN_OBJECT)
								   VALUES (@CUID, @USERID, @JOIN_DOMAIN, @JOIN_OBJECT)		
								   
		END
		

GO
