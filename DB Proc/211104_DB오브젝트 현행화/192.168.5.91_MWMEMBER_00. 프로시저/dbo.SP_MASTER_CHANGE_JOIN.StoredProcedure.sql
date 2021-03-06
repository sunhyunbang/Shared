USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_CHANGE_JOIN]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_MASTER_CHANGE_JOIN]
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
  @CUID INT,
  @USERID VARCHAR(50),
  @USER_NM  varchar(30) ,
  @HPHONE  varchar(14),
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
  @COM_ID int output,
  @MEMBER_TYPE char(1)

--이력 정보
AS
	SET NOCOUNT ON;
		
	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한
		INSERT INTO CST_COMPANY (COM_NM, CEO_NM, MAIN_PHONE , PHONE, FAX , HOMEPAGE , REGISTER_NO ,
								LAT , LNG , ZIP_SEQ, CITY,
								GU , DONG , ADDR1 , ADDR2 , LAW_DONGNO , MAN_NO , ROAD_ADDR_DETAIL, 
								REG_ID, REG_DT, MOD_ID, MOD_DT, MEMBER_TYPE
								)
							VALUES (@COM_NM, @CEO_NM, @MAIN_PHONE, @PHONE, @FAX , @HOMEPAGE , @REGISTER_NO , 
								@LAT ,@LNG, @ZIP_SEQ , @CITY ,
								@GU ,@DONG ,@ADDR1 , @ADDR2 , @LAW_DONGNO , @MAN_NO , @ROAD_ADDR_DETAIL, 
								@USERID, GETDATE() ,@USERID,  GETDATE(), @MEMBER_TYPE)
		SET @COM_ID = SCOPE_IDENTITY()
	

		UPDATE CST_MASTER 
       SET USER_NM = @USER_NM
          ,DI = @DI
          ,CI = @CI
          ,ADULT_YN = 'Y'
          ,HPHONE = dbo.FN_PHONE_STRING(@HPHONE)
          ,MEMBER_CD = '2'
          ,COM_ID = @COM_ID
          ,BIRTH = @BIRTH
          ,GENDER = @GENDER
          ,MOD_DT = GETDATE()
		 WHERE CUID = @CUID

    -- 구인기업회원으로 전환하는 경우 담당자 정보 개인정보로 대체 등록 (2018.04.02)
    IF @MEMBER_TYPE = '1'
      BEGIN
        INSERT INTO CST_COMPANY_JOB
          (COM_ID, USERID, MANAGER_NM, MANAGER_PHONE, MANAGER_EMAIL, SECTION_CD)
        SELECT @COM_ID AS COM_ID
              ,USERID
              ,@USER_NM AS MANAGER_NM
              ,dbo.FN_PHONE_STRING(@HPHONE) AS MANAGER_PHONE
              ,EMAIL AS MANAGER_EMAIL
              ,'S102' AS SECTION_CD
          FROM CST_MASTER 
         WHERE CUID = @CUID
      END
      

--		SELECT @CUID
		-- 이력을 남기자...
		INSERT INTO CST_CHANGE_HISTORY (CUID,   USERID, CHANGE_DT )
						        VALUES (@CUID, @USERID, GETDATE() )					   

GO
