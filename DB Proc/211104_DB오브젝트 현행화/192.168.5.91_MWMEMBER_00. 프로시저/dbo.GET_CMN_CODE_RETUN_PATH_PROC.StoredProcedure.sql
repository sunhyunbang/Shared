USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_CMN_CODE_RETUN_PATH_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 공통코드 리턴 경로 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2019/04/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 해당 스토어드 프로시저를 사용하는 asp 파일을 기재한다.
 *  사 용  예 제 : EXEC dbo.GET_CMN_CODE_RETUN_PATH_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_CMN_CODE_RETUN_PATH_PROC]

  @CODE_ID VARCHAR(10)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT RETURN_PATH
    FROM CMN_CODE
   WHERE CODE_GROUP_ID = 'SERVICE_CD'
     AND USE_YN = 'Y'
     AND CODE_ID = @CODE_ID

GO
