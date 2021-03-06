USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[MB_LAND_DETAIL_GET_LOGO_INFO]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 부동산 모바일 상세 로고 이미지 콜
 *  작   성   자 : 정헌수
 *  작   성   일 : 2017-03-29
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 MB_LAND_DETAIL_GET_LOGO_INFO 0
************************************************************************************/
CREATE   PROC [dbo].[MB_LAND_DETAIL_GET_LOGO_INFO]
      @CUID		INT=NULL
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT isnull(B.LOGO_IMG, '') AS AGENCY_LOGO
	FROM MWMEMBER.DBO.CST_MASTER A WITH(NOLOCK)
	JOIN MWMEMBER.DBO.CST_COMPANY_LAND B WITH(NOLOCK) ON B.COM_ID = A.COM_ID
	WHERE CUID = @CUID
END
GO
