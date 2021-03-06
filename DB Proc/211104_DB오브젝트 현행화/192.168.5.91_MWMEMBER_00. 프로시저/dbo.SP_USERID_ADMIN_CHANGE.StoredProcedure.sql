USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_USERID_ADMIN_CHANGE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_USERID_ADMIN_CHANGE]
/*************************************************************************************
 *  단위 업무 명 : ID 변경
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 아이디 변경 및 비밀번호 변경
 *************************************************************************************/
@CUID INT,
@USERID VARCHAR(50),
@NEW_USERID VARCHAR(50),
@IP VARCHAR(20)
AS
	SET NOCOUNT ON;
	DECLARE @CKECK INT
  
	SELECT @CKECK = COUNT(CUID) FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @NEW_USERID

	IF @CKECK > 0
	BEGIN
		SELECT 2 AS RESULT
	END
	ELSE IF @CKECK = 0
	BEGIN
		IF EXISTS (SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE  CUID = @CUID )
		BEGIN	
			UPDATE CST_MASTER SET 
								USERID = @NEW_USERID 
								WHERE CUID = @CUID

			DELETE DUPLICATE_USERID_TB WHERE CUID = @CUID 
			EXEC FINDDB1.PAPER_NEW.DBO.USERID_CHANGE_ALL_PROC  @CUID, @USERID, @NEW_USERID, @IP
/*
ALTER PROCEDURE [dbo].[USERID_CHANGE_ALL_PROC]
  @CUID             INT
, @USERID           VARCHAR(50)       = ''      -- 기존아이디
, @RE_USERID        VARCHAR(50)       = ''      -- 변경아이디
, @CLIENT_IP      VARCHAR(20)       = ''
AS
*/
			-- USREID 변경 시 이력을 만들자..
			INSERT INTO CST_MASTER_HISTORY (CUID,   MOD_ID,  MOD_DT, NEW_USERID, PWD_CHANGE_YN) VALUES 
										   (@CUID  ,@USERID, getdate(),@NEW_USERID, 'N')
			SELECT 1 AS RESULT
		END
		ELSE
		BEGIN
			SELECT 2 AS RESULT
		END
	END
GO
