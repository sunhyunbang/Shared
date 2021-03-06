USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_FAIL_COUNT]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 실패 로그
 *  작   성   자 : JMG
 *  작   성   일 : 2019-01-02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
exec sp_login_fail_count 'bird4567', 'T'
exec sp_login_fail_count 'bird4567', 'F'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_FAIL_COUNT]
@USERID VARCHAR(50) ,
@TANDF  VARCHAR(2)
AS
	SET NOCOUNT ON;

	IF @TANDF = 'T' 
	BEGIN
		
		IF EXISTS(SELECT FAIL_CNT FROM CST_LOGIN_FAIL_COUNT	WHERE USERID = @USERID AND FAIL_CNT <= 5)
		BEGIN
			UPDATE CST_LOGIN_FAIL_COUNT 
			SET FAIL_CNT = 0
			, FAIL_DATE = ''
			WHERE USERID = @USERID
		END 

	END ELSE BEGIN

		--로그인 실패 횟수 체크
		IF EXISTS(SELECT * FROM CST_LOGIN_FAIL_COUNT WITH(NOLOCK) WHERE USERID = @USERID) 
		BEGIN
			UPDATE CST_LOGIN_FAIL_COUNT
			SET FAIL_CNT = FAIL_CNT + 1
			, FAIL_DATE = GETDATE()
			WHERE USERID = @USERID
		END ELSE BEGIN
			INSERT INTO CST_LOGIN_FAIL_COUNT (USERID, FAIL_CNT, FAIL_DATE) VALUES
			(@USERID, 1, GETDATE())
		END
	END 

	SELECT FAIL_CNT
	FROM CST_LOGIN_FAIL_COUNT
	WHERE USERID = @USERID

	
GO
