USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_TOKEN_KEEP_LOGIN_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 로그인 유지> 로그인 유지 TOKEN 쌓기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016-08-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :

declare @outtoken varchar(36) 
SET @outtoken = '6220E8F8-49B1-400F-A617-53FC80A0B0B7'
EXEC [GET_TOKEN_KEEP_LOGIN_PROC] 'sebilia','T', @TOKEN = @outtoken OUTPUT
SELECT @outtoken
 *************************************************************************************/
CREATE PROC [dbo].[GET_TOKEN_KEEP_LOGIN_PROC]
   @CUID        INT
	,@USERID		  VARCHAR(50)	-- 회원아이디
	,@KEEPLOGIN   CHAR(1)='F'     --로그인 유지여부
  ,@TOKEN       VARCHAR(36)=''  OUTPUT
AS

DECLARE @NEWTOKEN VARCHAR(36)
SET @NEWTOKEN=''
--로그인 유지일시 TOKEN 값 바꾸기
IF @KEEPLOGIN='T'
BEGIN
  SET @NEWTOKEN = NEWID()
  IF EXISTS (
    SELECT * FROM MM_TOKEN_TB WITH (NOLOCK)
     WHERE CUID = @CUID
  )
  BEGIN
    UPDATE MM_TOKEN_TB
       SET TOKEN = CAST(@NEWTOKEN AS UNIQUEIDENTIFIER)
         , LAST_LOGIN_DT = GETDATE()
     WHERE CUID = @CUID
  END
  ELSE
  BEGIN
    INSERT MM_TOKEN_TB
         ( CUID, USERID, TOKEN, LAST_LOGIN_DT)
    VALUES
         ( @CUID, @USERID, CAST(@NEWTOKEN AS UNIQUEIDENTIFIER), GETDATE() )
  END
END

SET @TOKEN=@NEWTOKEN 
GO
