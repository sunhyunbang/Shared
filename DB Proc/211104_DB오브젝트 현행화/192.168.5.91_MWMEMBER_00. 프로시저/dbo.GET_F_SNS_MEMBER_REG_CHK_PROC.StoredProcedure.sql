USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_SNS_MEMBER_REG_CHK_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 프론트 > SNS 회원가입 여부 확인
 *  작   성   자 : 최승범
 *  작   성   일 : 2016.08.12
 *  수   정   자 : 배진용
 *  수   정   일 : 2021-02-04
 *  설        명 : SNS_ID 길이 수정
 *  주 의  사 항 : 
 *  사 용  소 스 : 

 *************************************************************************************/
CREATE PROC [dbo].[GET_F_SNS_MEMBER_REG_CHK_PROC]
       @SNS_TYPE  CHAR(1)='N'
     , @SNS_ID    VARCHAR(100)
AS
     
DECLARE @COUNT INT
     
SELECT @COUNT = COUNT(*) 
  FROM CST_MASTER WITH (NOLOCK)
 WHERE SNS_TYPE = @SNS_TYPE
   AND SNS_ID = @SNS_ID
   AND OUT_YN='N'
   
IF @COUNT=1 
BEGIN
  RETURN 1
END   
ELSE
BEGIN
  RETURN 100
END
GO
