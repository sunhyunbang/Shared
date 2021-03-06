USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_AD_COMPANY_DETAIL_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 구인광고 등록 기업정보 조회 팝업
 *  작   성   자 : 김 성 준
 *  작   성   일 : 2013/12/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :	EXEC GET_F_AD_COMPANY_DETAIL_PROC 'calendar72', 262305, 180, 180
										EXEC GET_F_AD_COMPANY_DETAIL_PROC NULL, 55060, 80, 20
exec GET_F_AD_COMPANY_DETAIL_PROC 'kkam1234',default,default,default WITH RECOMPILE
 PG_APP_MAIN_TB

 select top 10 * FROM dbo.PP_LINE_RESUME_APP_VI
 exec GET_F_AD_COMPANY_DETAIL_PROC '',1014407623,18,18
 exec GET_F_AD_COMPANY_DETAIL_PROC '',50758089,80,80
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_F_AD_COMPANY_DETAIL_PROC]
	@CUID INT = NULL
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
		SELECT
	        B.COM_ID AS USERID
	      , B.COM_NM AS COMPANY_NM
	      , B.MAIN_PHONE AS PHONE
	      , C.MANAGER_PHONE AS HPHONE
		    , CASE WHEN B.CEO_NM IS NULL OR B.CEO_NM = '' THEN C. MANAGER_NM ELSE B.CEO_NM END AS CEO
		    , B.HOMEPAGE
		    , C.EMP_CNT
		    , C.MAIN_BIZ
		    , B.CITY
		    , B.GU
		    , B.DONG
		    , B.ADDR1+' '+B.ADDR2 AS ADDR_B
        , CASE WHEN C.LOGO_IMG = '' OR C.LOGO_IMG IS NULL THEN '' ELSE  C.LOGO_IMG END AS LOGO_IMG
        , CASE WHEN C.EX_IMAGE_1 = '' OR C.EX_IMAGE_1 IS NULL THEN '' ELSE  C.EX_IMAGE_1 END AS EX_IMAGE_1
        , CASE WHEN C.EX_IMAGE_2 = '' OR C.EX_IMAGE_2 IS NULL THEN '' ELSE  C.EX_IMAGE_2 END AS EX_IMAGE_2
        , CASE WHEN C.EX_IMAGE_3 = '' OR C.EX_IMAGE_3 IS NULL THEN '' ELSE  C.EX_IMAGE_3 END AS EX_IMAGE_3
        , CASE WHEN C.EX_IMAGE_4 = '' OR C.EX_IMAGE_4 IS NULL THEN '' ELSE  C.EX_IMAGE_4 END AS EX_IMAGE_4
		FROM MWMEMBER.DBO.CST_MASTER	AS A WITH(NOLOCK) 
		INNER JOIN MWMEMBER.DBO.CST_COMPANY AS B WITH(NOLOCK) ON A.COM_ID=B.COM_ID
		LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY_JOB AS C WITH(NOLOCK) ON B.COM_ID = C.COM_ID
   WHERE A.CUID = @CUID

END


GO
