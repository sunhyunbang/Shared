USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[__DEL__20190131__PUT_MM_HP_AUTH_CODE_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS OFF
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
 PUT_MM_HP_AUTH_CODE_PROC '1', '이근우', '19760925', 'M', '01033931420', '', 'P', 'S101'
************************************************************************************/
CREATE   PROC [dbo].[__DEL__20190131__PUT_MM_HP_AUTH_CODE_PROC]
       @MEMBER_CD   CHAR(1)
     , @USERNAME    VARCHAR(30)
     , @JUMINNO     CHAR(8)
     , @GENDER      CHAR(1)
     , @HP          VARCHAR(14)
     , @BIZNO       CHAR(12)=NULL
     , @TYPE        CHAR(1)='R'
     , @SECTION_CD  CHAR(4)='S101'
     , @SNS_TYPE    CHAR(1)=NULL
     , @SNS_ID      VARCHAR(25)=NULL
     , @CUID		INT=NULL
AS

SET NOCOUNT ON

DECLARE @ROWCOUNT INT
DECLARE @RANDOMCHAR   CHAR(6)

DECLARE @RANDOM INT
SELECT @RANDOM=RAND()*1000000
SET @RANDOMCHAR=REPLICATE('0',6-LEN(@RANDOM))+CAST(@RANDOM AS VARCHAR)

IF @MEMBER_CD='1' AND @SNS_TYPE<>'' AND @SNS_TYPE IS NOT NULL   --SNS 회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
     WHERE MEMBER_CD='1' 
       AND USERNAME=@USERNAME
			 AND JUMINNO=@JUMINNO
			 AND GENDER=@GENDER
       AND HP=@HP
       AND SNS_TYPE=@SNS_TYPE
       AND SNS_ID=@SNS_ID
END
ELSE IF @MEMBER_CD='1'  --개인회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
     WHERE MEMBER_CD='1' 
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
	  AND ISNULL(SNS_TYPE, '') = ''
	  AND ISNULL(SNS_ID, '') = ''
END
ELSE    --기업회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
     WHERE MEMBER_CD='2' 
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
       AND BIZNO=@BIZNO
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
SELECT IDCODE, DT
FROM MM_HP_AUTH_CODE_TB (NOLOCK)
WHERE USERNAME = @USERNAME
  AND JUMINNO = @JUMINNO
	AND GENDER = @GENDER
	AND HP = @HP
	AND IDCODE = @RANDOMCHAR
	AND TYPE = @TYPE
	AND MEMBER_CD = @MEMBER_CD
	AND CASE WHEN @MEMBER_CD = '2' THEN BIZNO ELSE 'BIZNO' END = CASE WHEN @MEMBER_CD = '2' THEN @BIZNO ELSE 'BIZNO' END

--불량 회원 전화번호 목록에 존재하면 SMS 발송 안됨
IF NOT EXISTS (SELECT HP FROM MM_BAD_HP_TB WHERE HP=@HP)
BEGIN
  DECLARE @MSG VARCHAR(80)
  DECLARE @TEXT VARCHAR(20)
  IF @TYPE = 'I'
    SET @TEXT = '아이디찾기'
  ELSE IF @TYPE = 'P' 
    SET @TEXT = '비밀번호찾기'  
  ELSE IF @TYPE = 'M' 
    SET @TEXT = '회원정보수정'
  ELSE
    SET @TEXT = '회원가입'

  IF @SECTION_CD='S101'
  BEGIN
	  SET @MSG='[벼룩시장] ' + @TEXT + ' 휴대폰 인증번호 ['+@RANDOMCHAR+']'
	  EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '02-3019-1590','벼룩시장',@USERNAME ,@HP ,@MSG ,'FINDALL'
	  
	   --SMS로깅 (2015.10.19)
	   EXECUTE FINDDB1.MWDB.DBO.PUT_MMSDATA_STAT_LOG_PROC '00','s','','',16,0,'',@MSG
  END
  IF @SECTION_CD='H001'
  BEGIN
	  SET @MSG='[부동산써브] ' + @TEXT + ' 휴대폰 인증번호 ['+@RANDOMCHAR+']'
	  EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '080-269-0011','써브',@USERNAME ,@HP ,@MSG ,'SERVE'
  END
  IF @SECTION_CD='S116'
  BEGIN
	  SET @MSG='[야알바] ' + @TEXT + ' 휴대폰 인증번호 ['+@RANDOMCHAR+']'
	  EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '080-269-0011','야알바',@USERNAME ,@HP ,@MSG ,'FINDALL'
  END

  IF @SECTION_CD='S117'
  BEGIN
	  SET @MSG='[테니스코리아] ' + @TEXT + ' 휴대폰 인증번호 ['+@RANDOMCHAR+']'
	  EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-1433','테니스코리아',@USERNAME ,@HP ,@MSG ,'M&B'
  END

  IF @SECTION_CD='S118'
  BEGIN
	  SET @MSG='[포포투] ' + @TEXT + ' 휴대폰 인증번호 ['+@RANDOMCHAR+']'
	  EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-6924','포포투',@USERNAME ,@HP ,@MSG ,'M&B'
  END
END
GO
