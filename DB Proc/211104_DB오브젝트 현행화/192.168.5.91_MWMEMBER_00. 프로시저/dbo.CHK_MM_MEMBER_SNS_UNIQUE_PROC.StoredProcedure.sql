USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_MEMBER_SNS_UNIQUE_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : SNS 회원 가입 > SNS_TYPE, SNS_ID 확인 및 이메일(회원ID) 중복 체크
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-03-04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :  SNS 회원 중복체크 조건(SNS_TYPE, SNS_ID) 으로 중복가입 체크, 이메일 중복 체크
 *  주 의  사 항 :
 *  사 용  소 스 :
 EXEC DBO.CHK_MM_MEMBER_SNS_UNIQUE_PROC 'N', '23598650', 'bird3325@gmail.com'
************************************************************************************/
CREATE  PROC [dbo].[CHK_MM_MEMBER_SNS_UNIQUE_PROC]
       @SNS_TYPE    CHAR(1)
     , @SNS_ID      VARCHAR(25)
     , @USERID      VARCHAR(50)   --회원 ID
AS
--RECORDSET이 반환되지 않는 경우는 없음
SET NOCOUNT ON

DECLARE @CNT  INT

SELECT @CNT = COUNT(*) 
  FROM CST_MASTER WITH (NOLOCK)
 WHERE SNS_TYPE=@SNS_TYPE 
   AND SNS_ID = @SNS_ID
   AND MEMBER_CD='1'
   AND OUT_YN='N'
   
IF @CNT=0   --아이디 중복 체크(EMAIL 중복)
BEGIN
  SELECT @CNT = COUNT(*)
  FROM CST_MASTER WITH (NOLOCK)
 WHERE SNS_ID <> ''
   AND MEMBER_CD='1'
   AND USERID = @USERID
END   

SELECT @CNT

GO
