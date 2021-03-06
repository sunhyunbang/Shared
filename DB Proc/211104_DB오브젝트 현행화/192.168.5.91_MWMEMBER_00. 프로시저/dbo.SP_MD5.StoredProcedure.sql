USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_MD5]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_MD5]
/*************************************************************************************
 *  단위 업무 명 : 승인 이력 및 관리자 전달
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : @S_CUID , @C_CUID 구분값 " ,  "
 *************************************************************************************/
@CUID INT,
@PWD VARCHAR(25)
AS 
	SET NOCOUNT ON;
	DECLARE @SELECTPWD varbinary(128), 
			@MD5PWD varbinary(128)

	SET @MD5PWD = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD)))
	PRINT(@MD5PWD)

	SELECT @SELECTPWD = pwd_sha2 FROM CST_MASTER WHERE CUID = @CUID 

	IF @SELECTPWD = @MD5PWD
	BEGIN
		PRINT(@SELECTPWD)	
		PRINT(@MD5PWD)
	SELECT '맞아'
	END ELSE
	BEGIN 
	
	PRINT(@SELECTPWD)	
	PRINT(@MD5PWD)
	
	END
GO
