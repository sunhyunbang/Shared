USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_HP_AUTH_CODE_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013-03-04
 *  수   정   자 : 김 준 홍
 *  수   정   일 : 2015-06-17
 *  수   정      : @P_IDCODE 변수의 데이터타입을 int 에서 char(6)으로 변경함
 *  설        명 : 회원가입 및 ID 찾기 핸드폰 인증 번호 확인
 *  주 의  사 항 :
 *  사 용  소 스 :
 EXEC DBO.CHK_MM_HP_AUTH_CODE_PROC '1','김준홍2','19790522','M','01020500865','','053413','R','','' 
 select top 10 * from MM_HP_AUTH_CODE_TB where username = '김준홍2' order by dt desc
 
************************************************************************************/
CREATE  PROC [dbo].[CHK_MM_HP_AUTH_CODE_PROC]
       @MEMBER_CD   CHAR(1)
     , @USERNAME    VARCHAR(30)
     , @JUMINNO     CHAR(8) = ''
     , @GENDER      CHAR(1) = ''
     , @HP          VARCHAR(14)
     , @BIZNO       CHAR(12)=NULL
     , @IDCODE      CHAR(6)
     , @TYPE        CHAR(1)   --R:회원등록 I:ID찾기
     , @SNS_TYPE    CHAR(1)=NULL
     , @SNS_ID      VARCHAR(100)=NULL
     
AS

SET NOCOUNT ON

DECLARE @CNT  INT
DECLARE @P_IDCODE   CHAR(6)

IF @MEMBER_CD='1' AND @SNS_TYPE<>''   --SNS 회원
BEGIN
    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       AND USERNAME=@USERNAME
       AND HP=@HP
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE
       AND SNS_TYPE=@SNS_TYPE
       AND SNS_ID=@SNS_ID
       AND DATEDIFF(mi,DT,GETDATE()) < 30

    SELECT TOP 1 @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       AND USERNAME=@USERNAME
       AND HP=@HP
       AND TYPE=@TYPE
       AND SNS_TYPE=@SNS_TYPE
       AND SNS_ID=@SNS_ID
       AND DATEDIFF(mi,DT,GETDATE()) < 30
    ORDER BY DT DESC
       
END
ELSE IF @MEMBER_CD='1'  --개인회원
BEGIN

    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       --AND USERNAME=@USERNAME
       --AND JUMINNO=@JUMINNO
       --AND GENDER=@GENDER
       AND HP=@HP
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE
	   AND ISNULL(SNS_TYPE, '') = ''
	   AND ISNULL(SNS_ID, '') = ''
     AND DATEDIFF(mi,DT,GETDATE()) < 30

    SELECT TOP 1 @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       --AND USERNAME=@USERNAME
       --AND JUMINNO=@JUMINNO
       --AND GENDER=@GENDER
       AND HP=@HP
       AND TYPE=@TYPE
	   AND ISNULL(SNS_TYPE, '') = ''
	   AND ISNULL(SNS_ID, '') = ''
     AND DATEDIFF(mi,DT,GETDATE()) < 30
    ORDER BY DT DESC

END
ELSE    --기업회원
BEGIN

    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='2'
       AND USERNAME=@USERNAME
       --AND JUMINNO=@JUMINNO
       --AND GENDER=@GENDER
       AND HP=@HP
       AND BIZNO=@BIZNO
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE
       AND DATEDIFF(mi,DT,GETDATE()) < 30

    SELECT TOP 1 @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='2'
       AND USERNAME=@USERNAME
       --AND JUMINNO=@JUMINNO
       --AND GENDER=@GENDER
       AND HP=@HP
       AND BIZNO=@BIZNO
       AND TYPE=@TYPE
       AND DATEDIFF(mi,DT,GETDATE()) < 30
    ORDER BY DT DESC
END

--로그 기록
INSERT TEMP_HP_AUTH_CODE_TB
     ( USERID, USERNAME, JUMINNO, GENDER, HP, BIZNO, IDCODE, TYPE, MEMBER_CD)
VALUES 
     ( '', @USERNAME, @JUMINNO, @GENDER, @HP, @BIZNO, @IDCODE, @TYPE, @MEMBER_CD)

IF @CNT > 0
  BEGIN
    SELECT @CNT, @P_IDCODE
  END
ELSE
  BEGIN
    DECLARE @TMP TABLE(TMP CHAR(1))
    SELECT @CNT, @P_IDCODE FROM @TMP
  END

--SELECT 1, @P_IDCODE     -- 주의!!!! 인증을 우회하기 위해 테스트서버에서만 적용 (운영에서는 SELECT @CNT, @P_IDCODE )
GO
