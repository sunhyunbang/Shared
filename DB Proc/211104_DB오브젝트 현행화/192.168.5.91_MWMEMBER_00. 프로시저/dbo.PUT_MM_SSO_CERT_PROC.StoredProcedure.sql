USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_SSO_CERT_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : SSO 로그인 인증 TOKEN 생성
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2017/01/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.PUT_MM_SSO_CERT_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_MM_SSO_CERT_PROC]

  @USERID	VARCHAR	(50) = ''
  ,@PWD	VARCHAR	(30)  = ''
  ,@SECTION_CD	CHAR	(4)
  ,@IP	VARCHAR	(15)
  ,@HOST	VARCHAR	(50)
  ,@KEEPLOGIN CHAR(1) = 'N'
  ,@SNS_TYPE CHAR(1) = NULL
  ,@SNS_ID VARCHAR(100) = NULL

  ,@TOKEN VARCHAR(32) = ''  OUTPUT

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  DECLARE @NEWID VARCHAR(36)
  DECLARE @NOW VARCHAR(18) = GETDATE()
  DECLARE @TOKEN_KEY VARCHAR(32)

  SET @NEWID = NEWID()

  SET @TOKEN_KEY = dbo.FN_MD5(@NEWID + CAST(@USERID AS VARCHAR) + @NOW)

  --BEGIN TRAN

    DELETE FROM MM_SSO_CERT_TB WHERE USERID = @USERID

    INSERT INTO MM_SSO_CERT_TB
      (TOKEN_KEY
      ,USERID
      ,PWD
      ,SECTION_CD
      ,IP
      ,HOST
      ,KEEPLOGIN
      ,SNS_TYPE
      ,SNS_ID)
    VALUES
      (@TOKEN_KEY
      ,@USERID
      ,dbo.FN_MD5(LOWER(@PWD))
      ,@SECTION_CD
      ,@IP
      ,@HOST
      ,@KEEPLOGIN
      ,@SNS_TYPE
      ,@SNS_ID)

  --COMMIT TRAN

  SET @TOKEN = @TOKEN_KEY
GO
