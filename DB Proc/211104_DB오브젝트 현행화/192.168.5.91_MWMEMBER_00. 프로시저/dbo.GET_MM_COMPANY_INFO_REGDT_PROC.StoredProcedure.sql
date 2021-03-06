USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_COMPANY_INFO_REGDT_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비지니스 회원 가입일
 *  작   성   자 : 정헌수
 *  작   성   일 : 2018-7-06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * EXEC GET_MM_COMPANY_INFO_PROC 10621983,'S103'
   
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_COMPANY_INFO_REGDT_PROC]
	@CUID         INT
	,@REG_DT DATETIME OUTPUT
AS

	SET NOCOUNT ON
	SELECT
		@REG_DT = B.REG_DT
		FROM MWMEMBER.dbo.CST_MASTER AS A WITH(NOLOCK)
		JOIN MWMEMBER.dbo.CST_COMPANY AS B WITH(NOLOCK) ON B.COM_ID = A.COM_ID 
		WHERE A.CUID = @CUID


GO
