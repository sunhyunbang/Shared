USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_PP_USER_REASON_INSERT_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PUT_PP_USER_REASON_INSERT_PROC]
/*************************************************************************************
 *  단위 업무 명 : 개인 회원 가입 계기
 *  작   성   자 : 조민기
 *  작   성   일 : 2019-09-19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
 --mwmember.dbo.PUT_PP_USER_REASON_INSERT_PROC '1,2', 13621996
 -- 개인 정보
@ETC_CHECK  varchar(50),
@CUID		INT

AS
	SET	XACT_ABORT	ON
	SET NOCOUNT ON;
BEGIN
	
	IF NOT EXISTS (SELECT * FROM CST_JOIN_REASON WHERE CUID = @CUID)
	BEGIN
		INSERT INTO CST_JOIN_REASON (CUID, REASON_CD, ORD, REGDT)
		SELECT @CUID, VALUE, 0, GETDATE() FROM DBO.FN_SPLIT_TB(@ETC_CHECK,',')
	END

END
GO
