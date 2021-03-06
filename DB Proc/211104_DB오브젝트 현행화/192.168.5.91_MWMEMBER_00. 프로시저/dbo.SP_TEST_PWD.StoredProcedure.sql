USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_TEST_PWD]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_TEST_PWD]
/*************************************************************************************
 *  단위 업무 명 : 승인 이력 및 관리자 전달
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : @S_CUID , @C_CUID 구분값 " ,  "
 *************************************************************************************/
@USERID varchar(50)
AS 
	SET NOCOUNT ON;
	DECLARE @CUID INT
	SELECT @CUID = CUID FROM CST_MASTER WHERE USERID = @USERID
	RETURN(@CUID)
GO
