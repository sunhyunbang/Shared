USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_INFO_HAS_COMPANY_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원정보 (기업/일반 구분)  (일단 부동산만{LAND_CLASS 로 구분함 A:중개,B:임대/사업,공백:개인}
												, 다른 섹션 추가해도 무관)
 *  작   성   자 : 정헌수
 *  작   성   일 : 2015-04-03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * 
 EXEC [GET_MM_MEMBER_INFO_HAS_COMPANY_PROC] 'kkam123456789','S103'   
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_INFO_HAS_COMPANY_PROC]
       @USERID       VARCHAR(50)
     , @SECTION_CD   CHAR(4)
AS
BEGIN

	SET NOCOUNT ON

	SELECT
				 M.USERID   --0
			 , M.USER_NM AS USERNAME
			 , M.HPHONE        
			 , D.BIZ_CD AS BIZNO
			 , C.COM_NM
			 , C.CEO_NM AS CEO
			 , CASE WHEN DBO.FN_GETSPLITSEPARATORCOUNT(C.MAIN_PHONE ,'-')=2 THEN '000-' + C.MAIN_PHONE 
					ELSE C.MAIN_PHONE  
			   END  AS MAIN_NUMBER
			 , C.PHONE
			 , C.FAX
			 , ISNULL(C.HOMEPAGE,'') as HOMEPAGE
			 , C.CITY
			 , C.GU			--10
			 , C.DONG     
			 , C.ADDR1 AS AREA_DETAIL
			 , C.LAT AS GMAP_X
			 , C.LNG AS GMAP_Y     
			 , D.BIZ_CLASS AS BIZ_CLASS        --15
			 , D.BIZ_CD AS BIZ_CODE
			 , D.EMP_CNT
			 , D.MAIN_BIZ	
			 , case when D.REG_NUMBER > '' then  'A' 
					when C.REGISTER_NO > '' then 'B'
					else''	
			   end  as LAND_CLASS
			 , D.REG_NUMBER
			 , D.INTRO
			 , isnull(D.LOGO_IMG,'') as LOGO_IMG
			 , M.CUID
			 , M.REST_YN 
		FROM DBO.CST_MASTER M WITH(NOLOCK)
		LEFT OUTER JOIN  DBO.CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
		LEFT OUTER JOIN  DBO.CST_COMPANY_ETC_VI D WITH(NOLOCK) ON C.COM_ID = D.COM_ID
	 WHERE M.USERID = @USERID
--     AND D.SECTION_CD = @SECTION_CD
     AND M.OUT_YN = 'N'
     AND ISNULL(M.STATUS_CD,'') <> 'D'
	ORDER BY M.REST_YN ,  M.SITE_CD ASC --  휴면후순위, 벼룩화원우선 검색되게..
END


GO
