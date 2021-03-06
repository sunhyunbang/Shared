USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[_GET_MM_COMPANY_SECTION_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 가입한 기업회원 섹션 가져오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015.3.6
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 

 *************************************************************************************/
CREATE PROCEDURE [dbo].[_GET_MM_COMPANY_SECTION_PROC]
	 @CUID		INT
AS
	
	SELECT ISNULL(COM_NM,'') AS COM_NM
	  FROM CST_MASTER AS A WITH (NOLOCK) 
	  INNER JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID 
	 WHERE A.CUID= @CUID
GO
