USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[_PUT_F_CST_SERVICE_USE_AGREE_PROC_20190429]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 공통 > 서비스이용동의
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2018/09/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 
 declare @RESULT INT 
 EXEC dbo.PUT_F_CST_SERVICE_USE_AGREE_PROC 0 ,@RESULT OUTPUT
 select @RESULT
 
truncate table CST_SERVICE_USE_AGREE
 
 declare @RESULT INT 
 exec MWMEMBER.dbo.PUT_F_CST_SERVICE_USE_AGREE_PROC 10370929,'S102','9','','',' ',@RESULT OUTPUT
 select @RESULT
 
 *************************************************************************************/

 
CREATE PROC [dbo].[_PUT_F_CST_SERVICE_USE_AGREE_PROC_20190429]

  @CUID         INT
  ,@SECTION_CD	CHAR(4)       -- 섹션코드 (CC_SECTION_TB 참고)
  ,@AGREE_CD	  VARCHAR(10)     -- 서비스코드 (SELECT * FROM CMN_CODE WHERE CODE_GROUP_ID = 'SERVICE_CD' 참고)

  ,@USER_NM     VARCHAR(30) = ''
  ,@BIRTH       VARCHAR(8)  = ''
  ,@GENDER      CHAR(1)     = ''

  ,@DI          VARCHAR(70) = ''

  ,@RESULT INT = 999 OUTPUT

  ,@MEMBER_CD CHAR(1) = '1'
  ,@HPHONE VARCHAR(14)  = ''

AS

  SET NOCOUNT ON

  SET @HPHONE = REPLACE(@HPHONE,'-','')

  DECLARE @DUP_CNT INT

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

  IF @DI <> ''   -- 휴대폰 본인인증을 통하면서 기존 ID값이 있는 경우
    BEGIN
      -- 성별값 치환
      IF @GENDER = '1'
        BEGIN
          SET @GENDER = 'M'
        END
      ELSE IF @GENDER = '0'
        BEGIN
          SET @GENDER = 'F'
        END

      -- 일치하는 회원정보가 있는지 확인
      --IF NOT EXISTS(SELECT * FROM CST_MASTER WHERE CUID = @CUID AND DI = @DI AND OUT_YN = 'N')
      IF @VAL_SNSF = '1'  -- SNS 회원
        BEGIN
          IF @VAL_HPHONE <> @HPHONE
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END 
        END

      IF @VAL_MEMBER_CD = '1' AND @VAL_SNSF = '0'  -- 개인회원
        BEGIN
          IF (@VAL_USER_NM != @USER_NM OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END
        END


      IF @VAL_MEMBER_CD = '2'   -- 기업회원
        BEGIN
          IF (@VAL_USER_NM != @USER_NM OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END
        END
/*
      SELECT @DUP_CNT = COUNT(*)
        FROM CST_SERVICE_USE_AGREE
       WHERE CUID IN (SELECT CUID FROM CST_MASTER WHERE DI = @DI AND MEMBER_CD = @MEMBER_CD  AND OUT_YN = 'N')
*/
      SELECT @DUP_CNT = COUNT(*)
        FROM CST_MASTER AS A
       WHERE DI = @DI AND MEMBER_CD = @MEMBER_CD  AND OUT_YN = 'N'
         AND CUID IN (SELECT DISTINCT CUID FROM CST_SERVICE_USE_AGREE WHERE AGREE_CD = @AGREE_CD)

      IF @DUP_CNT > 2
        BEGIN
          SET @RESULT = 1     -- 서비스이용동의한 동일정보의 회원이 3개이상 존재하는 경우
          RETURN
        END

      -- 개인회원인 경우 DI값, GENDER값 갱신
      IF @VAL_MEMBER_CD = '1'
        BEGIN
          UPDATE CST_MASTER
             SET DI = @DI
                ,GENDER = @GENDER
           WHERE CUID = @CUID    
        END

      -- SNS회원인 경우 회원정보 갱신 (본인인증처에서 보낸 정보로)
      IF @VAL_SNSF = '1'
        BEGIN
          UPDATE CST_MASTER
             SET USER_NM = @USER_NM
                ,BIRTH = @BIRTH
                ,GENDER = @GENDER
                --,HPHONE = @HPHONE
           WHERE CUID = @CUID
        END

    END

  -- 동의코드 중복되지 않는다면 등록
  IF NOT EXISTS(SELECT * FROM CST_SERVICE_USE_AGREE WHERE AGREE_CD = @AGREE_CD AND CUID = @CUID)
    BEGIN
      INSERT INTO CST_SERVICE_USE_AGREE
        (CUID
        ,SECTION_CD
        ,AGREE_CD)
      VALUES
        (@CUID
        ,@SECTION_CD
        ,@AGREE_CD)
    END

    SET @RESULT = 0     -- 이용동의 처리 완료


GO
