USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_JOIN_COMPANY]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MASTER_JOIN_COMPANY]
/*************************************************************************************
 *  단위 업무 명 : 기업 회원 가입 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500)  -- 에러
 * RETURN(0)  -- 정상
 * DECLARE @RET INT
 * EXEC @RET=SP_MASTER_JOIN_COMPANY 'USERID','PWD','Y','2','USER_NM','010-0000-0000','EMAIL@EMAIL.EL','M','19802510','DI','CI',  -- 개인정보
         'COM_NM','CEO_NM','MAIN_PHONE','PHONE','FAX','HOMEPAGE','REGISTER_NO',33.47773717697358 ,124.84925073212366,'123','CITY',    
         'GU','DONG','ADDR1','ADDR2','LAW_DONGNO','MAN_NO','ROAD_ADDR_DETAIL',    -- 기업 정보
         'F','JOIN_PATH','JOIN_DOMAIN',1  -- 이력
 * SELECT @RET    -- CUID  
 *************************************************************************************/
 -- 개인 정보
@USERID  varchar(50),
@PWD  VARCHAR(30),
@ADULT_YN  char(1),
@MEMBER_CD  char(1),
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@EMAIL  varchar(50),
@GENDER  char(1),
@BIRTH  varchar(8),
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
@JOIN_OBJECT INT  
AS
	SET	XACT_ABORT	ON
	SET NOCOUNT ON;
	DECLARE @CUID INT, @COM_ID INT, @PWD_NEXT_ALARM_DT DATETIME, @COUNT INT
	SET @PWD_NEXT_ALARM_DT = GETDATE() + 180
	
	SELECT @COUNT = COUNT(*)  
	  FROM CST_MASTER WITH (NOLOCK)
	 WHERE USERID = @USERID
		
	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한
		IF @SITE_CD = 'S'
		BEGIN
			RETURN(500)
		END ELSE IF @SITE_CD = 'F'
		BEGIN
			RETURN(500)
		END
		ELSE IF @COUNT > 0
		BEGIN
			RETURN(500)
		END
		ELSE IF @COUNT = 0
		BEGIN
		INSERT INTO CST_MASTER ( USERID,  USER_NM,  ADULT_YN,   MOD_ID , pwd_sha2 ,                   MEMBER_CD ,HPHONE,
							EMAIL, GENDER ,  BIRTH, DI, CI, 
							BAD_YN, JOIN_DT, MOD_DT , REST_YN, OUT_YN , LAST_LOGIN_DT, PWD_NEXT_ALARM_DT) 
					VALUES ( @USERID, @USER_NM, @ADULT_YN,  @USERID, master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD))),  @MEMBER_CD, @HPHONE,
							@EMAIL,@GENDER,   @BIRTH, @DI, @CI ,
							'N', GETDATE(),GETDATE(),'N' ,'N' ,GETDATE(), @PWD_NEXT_ALARM_DT)  -- 기본 정보 INSERT
		
		SELECT @CUID = CUID FROM CST_MASTER WITH(NOLOCK)  
		WHERE USERID = @USERID AND REST_YN ='N' AND OUT_YN = 'N' -- 기본 정보를 저장 하고 CUID를 구해 온다

		INSERT INTO CST_COMPANY (COM_NM, CEO_NM, MAIN_PHONE , PHONE, FAX , HOMEPAGE , REGISTER_NO ,
								LAT , LNG , ZIP_SEQ, CITY,
								GU , DONG , ADDR1 , ADDR2 , LAW_DONGNO , MAN_NO , ROAD_ADDR_DETAIL, 
								REG_ID, REG_DT, MOD_ID, MOD_DT, USE_YN
								)
							VALUES (@COM_NM, @CEO_NM, @MAIN_PHONE, @PHONE, @FAX , @HOMEPAGE , @REGISTER_NO , 
								@LAT ,@LNG, @ZIP_SEQ , @CITY ,
								@GU ,@DONG ,@ADDR1 , @ADDR2 , @LAW_DONGNO , @MAN_NO , @ROAD_ADDR_DETAIL, 
								@USERID, GETDATE() ,@USERID,  GETDATE(), 'Y' )
		
		SET  @COM_ID = SCOPE_IDENTITY() 
		
		UPDATE CST_MASTER SET COM_ID = @COM_ID WHERE CUID = @CUID
		-- 이력을 남기자...
		INSERT INTO CST_JOIN_INFO (CUID, USERID, JOIN_DOMAIN, JOIN_OBJECT)
						   VALUES (@CUID, @USERID, @JOIN_DOMAIN, @JOIN_OBJECT)
						   
		SELECT @CUID AS CUID	
		RETURN(0)				   
		END
GO
