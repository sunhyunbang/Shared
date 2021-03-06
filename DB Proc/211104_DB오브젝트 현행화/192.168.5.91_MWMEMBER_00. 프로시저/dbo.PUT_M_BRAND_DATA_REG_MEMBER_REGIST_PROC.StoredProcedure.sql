USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_BRAND_DATA_REG_MEMBER_REGIST_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 구인관리자 > 브랜드 일괄 등록 > 회원 등록
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2015/07/27
 *  수   정   자 :
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC PUT_M_BRAND_DATA_REG_MEMBER_REGIST_PROC
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_BRAND_DATA_REG_MEMBER_REGIST_PROC]
AS 
  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

  UPDATE TEMP_REG_BIZMEMBER_TB
  SET CITY = dbo.FN_CITY(CITY)

  DECLARE @ERROR INT

  SET @ERROR = 0

  SET	XACT_ABORT ON
  BEGIN TRAN

  --------------------------------
  -- 회원 공통테이블
  --------------------------------
	  INSERT INTO	DBO.CST_MASTER (
      USERID
    , USER_NM
    , BAD_YN
    , JOIN_DT
    , MOD_DT
    , MOD_ID
    , pwd_sha2
    , PWD_NEXT_ALARM_DT
    , MEMBER_CD
    , ADULT_YN
    , HPHONE
    , EMAIL
    , GENDER
    , BIRTH
    , DI
    , CI
    , SITE_CD
    , REST_YN
    , OUT_YN
    , LAST_LOGIN_DT
    )    
	  SELECT
      USERID
		, USERNAME
    , 'N'
    , GETDATE()
    , GETDATE()
    , USERID
    , master.DBO.fnGetStringToSha256(dbo.FN_MD5(LOWER(PASSWORD))) 
    , DATEADD(DAY, 180, GETDATE())
    , '2'
    , NULL
    , HPHONE
    , EMAIL		  
    , GENDER
		, JUMINNO
    , NULL
    , NULL
    , 'J'
    , 'N'
    , 'N'
    , GETDATE()
    FROM TEMP_REG_BIZMEMBER_TB


    UPDATE A
       SET A.CUID = B.CUID
    -- SELECT *
      FROM TEMP_REG_BIZMEMBER_TB A
      JOIN DBO.CST_MASTER B ON A.USERID = B.USERID

    IF @@ERROR > 0
      SET @ERROR = @ERROR + 1

  --------------------------------
  -- 기업회원 테이블
  --------------------------------
  --> 기업메인
	  INSERT INTO	DBO.CST_COMPANY (
      REG_ID
    , COM_NM
    , CEO_NM
    , MAIN_PHONE
    , PHONE
    , FAX
    , REGISTER_NO
    , HOMEPAGE
    , LAT
    , LNG
    , CITY
    , GU
    , DONG
    , ADDR1
    , ADDR2
    , LAW_DONGNO
    , MAN_NO
    , ROAD_ADDR_DETAIL
    , REG_DT
    , MOD_ID
    , MOD_DT
    , MEMBER_TYPE
    )
	  SELECT
      A.USERID
    , A.COM_NM
    , A.CEO
    , A.PHONE
    , A.PHONE
    , NULL
    , A.BIZNO
    , A.HOMEPAGE
    , NULL
    , NULL
    , A.CITY
    , A.GU
    , A.DONG
    , A.ADDR_A
    , A.ADDR_B
    , NULL
    , NULL
    , NULL
    , GETDATE()
    , A.USERID
    , GETDATE()
    , 1
    FROM TEMP_REG_BIZMEMBER_TB A    

    UPDATE A
       SET A.COM_ID = B.COM_ID
    -- SELECT *
      FROM TEMP_REG_BIZMEMBER_TB A
      JOIN DBO.CST_COMPANY B ON A.USERID = B.REG_ID

    UPDATE A
       SET A.COM_ID = B.COM_ID
    -- SELECT *
    --  FROM CST_MASTER A
    --  JOIN DBO.CST_COMPANY B ON A.USERID = B.REG_ID
      FROM CST_MASTER A
      JOIN DBO.TEMP_REG_BIZMEMBER_TB B ON A.CUID = B.CUID


    IF @@ERROR > 0
      SET @ERROR = @ERROR + 1

  --> 기업구인 기타정보
	  INSERT INTO	DBO.CST_COMPANY_JOB (
      COM_ID
    , USERID
    , MANAGER_NM
    , MANAGER_PHONE
    , MANAGER_EMAIL
    , EMP_CNT
    , MAIN_BIZ
    , SECTION_CD
    , MOD_DT
    )
    SELECT
      COM_ID
    , USERID
    , USERNAME
    , HPHONE
    , EMAIL
    , EMP_CNT
    , MAIN_BIZ
    , SECTION_CD
    , GETDATE()
    FROM TEMP_REG_BIZMEMBER_TB A

    IF @@ERROR > 0
      SET @ERROR = @ERROR + 1

  ------------------------------------------------------------------------------------------------
  -- 메일수신동의(현재 EMAIL/SMS값을 하나로 입력 받으나 언제든지 분리할 수도 있기 때문)
  ------------------------------------------------------------------------------------------------
    INSERT INTO CST_MSG_SECTION (
      CUID
    , SECTION_CD
    , MEDIA_CD
    , AGREE_DT
    )
    SELECT 
      CUID
    , SECTION_CD
		, 'M' AS MEDIA_CD
		, GETDATE() AS AGREE_DT
    FROM TEMP_REG_BIZMEMBER_TB

    IF @@ERROR > 0
      SET @ERROR = @ERROR + 1

  ------------------------------------------------------------------------------------------------
  -- SMS 수신동의
  ------------------------------------------------------------------------------------------------
    INSERT INTO CST_MSG_SECTION (
      CUID
    , SECTION_CD
    , MEDIA_CD
    , AGREE_DT
    )
    SELECT 
      CUID
    , 'S101' AS SECTION_CD
		, 'S' AS MEDIA_CD
		, GETDATE() AS AGREE_DT
    FROM TEMP_REG_BIZMEMBER_TB

    IF @@ERROR > 0
      SET @ERROR = @ERROR + 1
  
  COMMIT TRAN

  SET	XACT_ABORT OFF

  SELECT @ERROR
END
GO
