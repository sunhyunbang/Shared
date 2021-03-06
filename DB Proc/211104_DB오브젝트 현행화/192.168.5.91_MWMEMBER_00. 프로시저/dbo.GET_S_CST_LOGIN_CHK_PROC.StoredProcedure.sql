USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_S_CST_LOGIN_CHK_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 로그인
 *  작   성   자 : JMG
 *  작   성   일 : 2020/05/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 매물등록이나 전용창에 접속시 로그인으로 간주하고 LAST_LOGIN_DT 를 저장함.
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_S_CST_LOGIN_CHK_PROC 13621996
 *************************************************************************************/


CREATE PROC [dbo].[GET_S_CST_LOGIN_CHK_PROC]

	@CUID			INT = 0

AS
BEGIN
	SET NOCOUNT ON

	IF EXISTS(SELECT * FROM CST_MASTER WITH(NOLOCK)	WHERE CUID = @CUID)
	BEGIN

		UPDATE CST_MASTER
		SET LAST_LOGIN_DT = GETDATE()
		WHERE CUID = @CUID

	END

END

GO
