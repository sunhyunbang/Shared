USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_M_BRAND_DATA_REG_MEMBER_ID_OVERLAP_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 구인관리자 > 브랜드 일괄 등록 > 회원 아이디 중복 확인
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2015/07/27
 *  수   정   자 :
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC GET_M_BRAND_DATA_REG_MEMBER_ID_OVERLAP_PROC
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_BRAND_DATA_REG_MEMBER_ID_OVERLAP_PROC]
AS 
  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

  DECLARE @RESULT CHAR(1)
  DECLARE @CNT INT

  SET @RESULT = '0'


  SELECT @CNT = COUNT(*)
    FROM CST_MASTER
   WHERE USERID IN (SELECT USERID FROM TEMP_REG_BIZMEMBER_TB)
              
  IF @CNT > 0
  BEGIN
    SET @RESULT = '2'
  END
  ELSE
  BEGIN
    SET @RESULT = '1'
  END
  
  SELECT @RESULT
  
  IF @RESULT = '2'
  BEGIN
    SELECT USERID
      FROM CST_MASTER
     WHERE USERID IN (SELECT USERID FROM TEMP_REG_BIZMEMBER_TB)
  END
END
GO
