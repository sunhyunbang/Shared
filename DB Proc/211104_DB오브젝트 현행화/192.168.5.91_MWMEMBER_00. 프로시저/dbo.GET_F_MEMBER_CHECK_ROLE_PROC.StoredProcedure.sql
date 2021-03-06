USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MEMBER_CHECK_ROLE_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 공통 > 회원정보값 비교
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2019/01/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 *************************************************************************************/

 
CREATE PROC [dbo].[GET_F_MEMBER_CHECK_ROLE_PROC]

  @CUID         INT

  ,@USER_NM     VARCHAR(30)
  ,@BIRTH       VARCHAR(8)
  ,@GENDER      CHAR(1)
  ,@HPHONE VARCHAR(14)
  ,@DI          VARCHAR(70)

  ,@RESULT INT = 999 OUTPUT


AS

  SET NOCOUNT ON

  SET @HPHONE = REPLACE(@HPHONE,'-','')

  DECLARE @VAL_DI CHAR(64)
  DECLARE @VAL_MEMBER_CD CHAR(1)
  DECLARE @VAL_SNSF CHAR(1)
  DECLARE @VAL_USER_NM VARCHAR(30)
  DECLARE @VAL_BIRTH VARCHAR(8)
  DECLARE @VAL_HPHONE VARCHAR(14)
  DECLARE @VAL_GENDER CHAR(1)

  -- 기존 정보
  SELECT @VAL_DI = DI
        ,@VAL_USER_NM = USER_NM
        ,@VAL_MEMBER_CD = MEMBER_CD
        ,@VAL_SNSF = CASE ISNULL(SNS_TYPE,'') WHEN '' THEN '0'
                          ELSE '1'
                          END
        ,@VAL_BIRTH   = BIRTH
        ,@VAL_HPHONE  = REPLACE(HPHONE,'-','')
        ,@VAL_GENDER  = GENDER
    FROM CST_MASTER
   WHERE CUID = @CUID

  -- 성별값 치환
  IF @GENDER = '1'
    BEGIN
      SET @GENDER = 'M'
    END
  ELSE IF  @GENDER = '2'
    BEGIN
      SET @GENDER = 'F'
    END

  IF @VAL_SNSF = '1'    -- SNS 회원인 경우
    BEGIN
      IF @VAL_HPHONE <> @HPHONE
        BEGIN
          SET @RESULT = 1     -- 휴대폰 번호가 회원정보와 일치하지 않습니다. 휴대폰 번호 변경은 회원정보수정에서 가능합니다.
          RETURN
        END
    END

  IF @VAL_MEMBER_CD = '1' AND @VAL_SNSF = '0'    -- SNS 회원인 경우
    BEGIN
      -- IF (@VAL_USER_NM != @USER_NM OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
	  IF (@VAL_USER_NM != @USER_NM OR @VAL_HPHONE != @HPHONE) --2020.02.14 
        BEGIN
          SET @RESULT = 2     -- 인증정보가 회원정보와 일치하지 않습니다.회원정보수정에서 정보를 확인해 주세요.
          RETURN
        END
    END

  IF @VAL_MEMBER_CD = '2'
    BEGIN
      -- IF (@VAL_USER_NM != @USER_NM OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE) 
	  IF (@VAL_USER_NM != @USER_NM OR @VAL_HPHONE != @HPHONE) --2020.02.14 
        BEGIN
          SET @RESULT = 3     -- 인증정보가 회원정보와 일치하지 않습니다. 회원정보수정에서 정보를 확인해 주세요.
          RETURN
        END
    END

  SET @RESULT = 0     -- 이상무
GO
