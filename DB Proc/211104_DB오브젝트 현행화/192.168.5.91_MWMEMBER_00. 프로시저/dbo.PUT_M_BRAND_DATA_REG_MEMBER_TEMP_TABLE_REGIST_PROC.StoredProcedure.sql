USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_BRAND_DATA_REG_MEMBER_TEMP_TABLE_REGIST_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 구인관리자 > 브랜드 일괄 등록 > TEMP 테이블 등록
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2015/07/27
 *  수   정   자 :
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC PUT_M_BRAND_DATA_REG_MEMBER_TEMP_TABLE_REGIST_PROC
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_BRAND_DATA_REG_MEMBER_TEMP_TABLE_REGIST_PROC]  
  @CNT                SMALLINT            = 0                 
, @USERID             VARCHAR(30)         = ''
, @PASSWORD           VARCHAR(30)         = ''
, @USERNAME           VARCHAR(30)         = ''
, @JUMINNO            CHAR(8)             = ''
, @EMAIL              VARCHAR(50)         = ''
, @PHONE              VARCHAR(14)         = ''
, @HPHONE             VARCHAR(14)         = ''
, @CITY               VARCHAR(50)         = ''
, @GU                 VARCHAR(50)         = ''
, @DONG               VARCHAR(50)         = ''
, @ADDR_A             VARCHAR(100)        = ''
, @ADDR_B             VARCHAR(100)        = ''
, @JOIN_PATH          VARCHAR(50)         = ''
, @JOIN_DOMAIN        VARCHAR(50)         = ''
, @JOIN_SECTION       VARCHAR(200)        = ''
, @MSG_SECTION        VARCHAR(200)        = ''
, @SMS_SECTION        VARCHAR(200)        = ''
, @BIZNO              CHAR(12)            = ''
, @COM_NM             VARCHAR(50)         = ''
, @CEO                VARCHAR(30)         = ''
, @MAIN_BIZ           VARCHAR(100)        = ''
, @SECTION_CD         CHAR(4)             = ''
, @GENDER             CHAR(1)             = ''
, @AUTHTYPE           CHAR(1)             = ''
, @EMP_CNT            VARCHAR(7)          = ''
, @HOMEPAGE           VARCHAR(100)        = ''
AS 
  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

  IF @CNT = 0
  BEGIN
    TRUNCATE TABLE TEMP_REG_BIZMEMBER_TB
  END

  -- 아이디가 없거나
  IF @USERID IS NULL OR LTRIM(RTRIM(@USERID)) = '' BEGIN
    RETURN;
  END

  -- 아이디가 3자 이하거나
  IF LEN(@USERID) < 4 BEGIN
    RETURN;
  END

  INSERT INTO TEMP_REG_BIZMEMBER_TB (
    USERID
  , PASSWORD
  , USERNAME
  , JUMINNO
  , EMAIL
  , PHONE
  , HPHONE
  , CITY
  , GU
  , DONG
  , ADDR_A
  , ADDR_B
  , JOIN_PATH
  , JOIN_DOMAIN
  , JOIN_SECTION
  , MSG_SECTION
  , SMS_SECTION
  , BIZNO
  , COM_NM
  , CEO
  , MAIN_BIZ
  , SECTION_CD
  , GENDER
  , AUTHTYPE
  , EMP_CNT
  , HOMEPAGE
  )
  VALUES (
    @USERID
  , @PASSWORD
  , @USERNAME
  , @JUMINNO
  , @EMAIL
  , @PHONE
  , @HPHONE
  , @CITY
  , @GU
  , @DONG
  , @ADDR_A
  , @ADDR_B
  , @JOIN_PATH
  , @JOIN_DOMAIN
  , @JOIN_SECTION
  , @MSG_SECTION
  , @SMS_SECTION
  , @BIZNO
  , @COM_NM
  , @CEO
  , @MAIN_BIZ
  , @SECTION_CD
  , @GENDER
  , @AUTHTYPE
  , @EMP_CNT
  , @HOMEPAGE
  )



END
GO
