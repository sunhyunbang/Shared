USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_JOB_SELECT]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_COMPANY_JOB_SELECT]
/*************************************************************************************
 *  단위 업무 명 : 기업 부가 정보 입력 및 수정, 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 * RETURN(0)  -- 정상
 * RETURN(500) -- 에러
 * DECLARE @RET INT
 * EXEC @RET=SP_COMPANY_JOB_SELECT 123123
 * SELECT @RET
 *************************************************************************************/
@COM_ID	INT
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT
		SET @ID_COUNT = 0
		SELECT @ID_COUNT = COUNT(COM_ID) FROM CST_COMPANY_AUTO WITH(NOLOCK) WHERE COM_ID = @COM_ID

	IF @ID_COUNT = 1
	BEGIN
		SELECT COM_ID, 
		       USERID,
			   MANAGER_NM, 
			   MANAGER_PHONE, 
			   MANAGER_EMAIL, 
			   BIZ_CD, 
			   BIZ_CLASS, 
			   EMP_CNT, 
			   MAIN_BIZ,
			   LOGO_IMG, 
			   EX_IMAGE_1, 
			   EX_IMAGE_2, 
			   EX_IMAGE_3, 
			   EX_IMAGE_4 FROM CST_COMPANY_JOB WITH(NOLOCK) WHERE COM_ID = @COM_ID
		RETURN(0)  -- 정상
	END
	ELSE
	BEGIN
		RETURN(500) -- 에러
	END


GO
