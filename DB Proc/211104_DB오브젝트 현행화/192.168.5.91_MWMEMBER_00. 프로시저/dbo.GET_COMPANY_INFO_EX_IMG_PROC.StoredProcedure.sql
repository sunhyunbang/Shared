USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_COMPANY_INFO_EX_IMG_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 기업정보 추가 이미지 불러오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013/8/31
 *  수   정   자 :
 *  수   정   일 :
 *  수 정  내 용 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_COMPANY_INFO_EX_IMG_PROC 'SEBILIA123'
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_COMPANY_INFO_EX_IMG_PROC] 
       @CUID    INT
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT 
		EX_IMAGE_1, EX_IMAGE_2, EX_IMAGE_3, EX_IMAGE_4
	FROM DBO.CST_MASTER	AS A  WITH(NOLOCK)
	LEFT JOIN DBO.CST_COMPANY_JOB AS B  WITH(NOLOCK) ON A.COM_ID=B.COM_ID
	WHERE A.CUID = @CUID

END
GO
