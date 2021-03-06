USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_HP_AUTH_CODE_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013-03-04
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 회원가입 및 ID 찾기 핸드폰 인증 번호 발송
 *  수   정   자 : 여운영
 *  수   정   일 : 2015-10-21
 *  설        명 : 문자발송로그 추가
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 PUT_MM_HP_AUTH_CODE_PROC '2', '최병찬', '', '', '01032134592', '206-85-26551', 'P', 'S101'
************************************************************************************/
CREATE   PROC [dbo].[PUT_MM_HP_AUTH_CODE_PROC]
       @MEMBER_CD   CHAR(1)
     , @USERNAME    VARCHAR(30)
     , @JUMINNO     CHAR(8)
     , @GENDER      CHAR(1)
     , @HP          VARCHAR(14)
     , @BIZNO       CHAR(12)=NULL
     , @TYPE        CHAR(1)='R'
     , @SECTION_CD  CHAR(4)='S101'
     , @SNS_TYPE    CHAR(1)=NULL
     , @SNS_ID      VARCHAR(100)=NULL
     , @CUID		    INT=NULL
AS

SET NOCOUNT ON

DECLARE @ROWCOUNT INT
DECLARE @RANDOMCHAR   CHAR(6)

DECLARE @RANDOM INT

SELECT @RANDOM=RAND()*1000000
SET @RANDOMCHAR=REPLICATE('0',6-LEN(@RANDOM))+CAST(@RANDOM AS VARCHAR)

/***************** 인증코드 고정 (테스트서버에서만) *****************/
--IF @@SERVERNAME = 'WIN-RUU8V04D675'
IF @@SERVERNAME = 'ONLINEFINDTEST\FINDALL_DEV_DB'
  BEGIN
    SET @RANDOMCHAR = '000000'
  END
/***************** 인증코드 고정 (테스트서버에서만) *****************/

IF @MEMBER_CD='1' AND @SNS_TYPE<>'' AND @SNS_TYPE IS NOT NULL   --SNS 회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
         , CUID = @CUID 
     WHERE MEMBER_CD='1' 
       AND USERNAME=@USERNAME
		   AND JUMINNO=@JUMINNO
		   AND GENDER=@GENDER
       AND HP=@HP
       AND SNS_TYPE=@SNS_TYPE
       AND SNS_ID=@SNS_ID
       AND CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN CUID
                ELSE 1
           END = 
           CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN @CUID
                ELSE 1
           END

END
ELSE IF @MEMBER_CD='1'  --개인회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
         , CUID = @CUID 
     WHERE MEMBER_CD='1' 
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
       AND ISNULL(SNS_TYPE, '') = ''
       AND ISNULL(SNS_ID, '') = ''
       AND CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN CUID
                ELSE 1
           END = 
           CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN @CUID
                ELSE 1
           END

END
ELSE    --기업회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
         , CUID = @CUID 
     WHERE MEMBER_CD='2' 
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
       AND BIZNO=@BIZNO
       AND CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN CUID
                ELSE 1
           END = 
           CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN @CUID
                ELSE 1
           END
END


SELECT @ROWCOUNT=@@ROWCOUNT
IF @ROWCOUNT=0
BEGIN
    INSERT MM_HP_AUTH_CODE_TB
         ( CUID, USERNAME, JUMINNO, GENDER, HP, BIZNO, DT, IDCODE, TYPE, MEMBER_CD, SNS_TYPE, SNS_ID)
    VALUES
         ( @CUID, @USERNAME, @JUMINNO, @GENDER, @HP, @BIZNO, GETDATE(), @RANDOMCHAR, @TYPE, @MEMBER_CD, @SNS_TYPE, @SNS_ID)
END

--// 비밀번호 찾기(메일인증번호 발송시 사용)
SELECT TOP 1 IDCODE, DT
FROM MM_HP_AUTH_CODE_TB (NOLOCK)
WHERE USERNAME = @USERNAME
  AND JUMINNO = @JUMINNO
	AND GENDER = @GENDER
	AND HP = @HP
	AND IDCODE = @RANDOMCHAR
	AND TYPE = @TYPE
	AND MEMBER_CD = @MEMBER_CD
	AND CASE WHEN @MEMBER_CD = '2' THEN BIZNO ELSE 'BIZNO' END = CASE WHEN @MEMBER_CD = '2' THEN @BIZNO ELSE 'BIZNO' END
  AND CASE 
           WHEN @CUID IS NOT NULL AND @TYPE='M' THEN CUID
           ELSE 1
      END = 
      CASE 
           WHEN @CUID IS NOT NULL AND @TYPE='M' THEN @CUID
           ELSE 1
      END
ORDER BY DT DESC       
--불량 회원 전화번호 목록에 존재하면 SMS 발송 안됨
IF NOT EXISTS (SELECT HP FROM MM_BAD_HP_TB WHERE HP=@HP)
BEGIN

  DECLARE @MSG NVARCHAR(4000)
  DECLARE @TEXT VARCHAR(20)

  IF @TYPE = 'I'
    SET @TEXT = '아이디찾기'
  ELSE IF @TYPE = 'P' 
    SET @TEXT = '비밀번호찾기'  
  ELSE IF @TYPE = 'M' 
    SET @TEXT = '회원정보수정'
  ELSE
    SET @TEXT = '회원가입'

  -- 카카오 알림톡 템플릿 정보 가져오기 / 전송 메시지 가공
  DECLARE @SUBJECT	varchar	(160)
  DECLARE @CALLBACK	varchar	(24)        = '0221877867'        -- 발신자번호

  SELECT @SUBJECT = LMS_TITLE
        ,@MSG = REPLACE(REPLACE(LMS_MSG,'#{구분}',@TEXT),'#{인증번호}',@RANDOMCHAR)
  -- SELECT *
    FROM OPENQUERY(FINDDB1,'SELECT LMS_MSG, LMS_TITLE FROM COMDB1.dbo.FN_GET_KKO_TEMPLATE_INFO(''MWsms02'')')

  -- SMS 발송
  EXEC FINDDB1.COMDB1.dbo.PUT_SENDSMS_PROC @CALLBACK,'','',@HP,@MSG
END
GO
