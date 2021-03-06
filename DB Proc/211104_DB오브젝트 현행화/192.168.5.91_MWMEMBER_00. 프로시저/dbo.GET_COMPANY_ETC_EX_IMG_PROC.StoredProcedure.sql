USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_COMPANY_ETC_EX_IMG_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 기업정보 추가 이미지 불러오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015/3/30
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_COMPANY_ETC_EX_IMG_PROC 'SEBILIA123','S102'
 *************************************************************************************/
CREATE PROC [dbo].[GET_COMPANY_ETC_EX_IMG_PROC]
       @CUID		INT
AS

SET NOCOUNT ON       

SELECT EX_IMAGE_1
     , EX_IMAGE_2
     , EX_IMAGE_3
     , EX_IMAGE_4 
  FROM CST_MASTER AS A WITH (NOLOCK) 
  JOIN CST_COMPANY_JOB AS C WITH (NOLOCK) ON A.COM_ID=C.COM_ID
 WHERE CUID = @CUID

GO
