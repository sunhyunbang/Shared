USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_PWD_RESET]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_PWD_RESET]
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 변경 - 관리자 화면에서 비밀번호 리셋 하기
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0) 성공
 * RETURN(500)  실패
 * DECLARE @RET INT
 * EXEC @RET=SP_PWD_RESET  'nadd','11217636'
 *
 *************************************************************************************/
@APP_USER varchar(50),
@CUID INT
AS
	SET NOCOUNT ON;
	DECLARE  @ID_COUNT bit
	
	SET @ID_COUNT = 0
	SELECT @ID_COUNT = COUNT(USERID) FROM CST_MASTER WITH(NOLOCK) WHERE CUID = @CUID

	IF @ID_COUNT = 1
	BEGIN
		UPDATE CST_MASTER SET 
		PWD_MOD_DT = getdate() 
		,PWD_NEXT_ALARM_DT = getdate() + 90
		,pwd_sha2= master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER('111111')))      -- 변경 되어야 할 값 넣어야 함(111111 으로 초기화 변경)
		WHERE CUID = @CUID
	
	INSERT INTO CST_MASTER_HISTORY (CUID,    MOD_ID,    MOD_DT,    PWD_CHANGE_YN) VALUES 
								   (@CUID,   @APP_USER, getdate(), 'Y')
		RETURN(0)
		
	END 
	ELSE
	BEGIN
		RETURN(500)
	END
GO
