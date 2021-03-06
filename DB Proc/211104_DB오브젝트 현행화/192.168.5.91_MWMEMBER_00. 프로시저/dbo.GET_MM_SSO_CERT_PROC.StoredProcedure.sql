USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_SSO_CERT_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : SSO 로그인 인증 TOKEN 확인
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2017/01/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_MM_SSO_CERT_PROC '32d52fd0ee59cac0f2d055dc3867950c'
 *************************************************************************************/


CREATE PROC [dbo].[GET_MM_SSO_CERT_PROC]

  @TOKEN_KEY VARCHAR(32)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT USERID
        ,PWD
        ,SECTION_CD
        ,IP
        ,HOST
        ,KEEPLOGIN
        ,SNS_TYPE
        ,SNS_ID
    FROM MM_SSO_CERT_TB
   WHERE TOKEN_KEY = @TOKEN_KEY

  -- 조회후 데이터 삭제 (보안을 위해 한번 인증받은 데이터는 삭제처리)
  DELETE FROM MM_SSO_CERT_TB WHERE TOKEN_KEY = @TOKEN_KEY
GO
