USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_COMPANY_INFO_LOGO_IMG_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 기업정보 로고 이미지 불러오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013/8/31
 *  수   정   자 :
 *  수   정   일 :
 *  수 정  내 용 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_COMPANY_INFO_LOGO_IMG_PROC 'SEBILIA123'
 *************************************************************************************/
CREATE PROC [dbo].[GET_COMPANY_INFO_LOGO_IMG_PROC]
       @CUID    INT
AS

SET NOCOUNT ON

SELECT TOP 1 B.LOGO_IMG
  FROM MWMEMBER.DBO.CST_MASTER	AS A INNER JOIN MWMEMBER.DBO.CST_COMPANY_LAND AS B ON A.COM_ID=B.COM_ID
 WHERE A.CUID = @CUID


GO
