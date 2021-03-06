USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_COMPANY_TB_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 기업 회원 정보 가져오기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_MM_COMPANY_TB_INFO_PROC 'SEBILIA'

 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_AD_MM_COMPANY_TB_INFO_PROC]
	 @CUID		    INT
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
SET NOCOUNT ON

SELECT 
       A.CUID
     , B.COM_ID
     , A.USERID 
     , B.REGISTER_NO
     , B.COM_NM
     , B.CEO_NM
     , B.MAIN_PHONE
     , B.FAX
     , B.PHONE
     , B.HOMEPAGE
     , B.REG_DT
     , B.MOD_DT
     , B.CITY
     , B.GU
     , B.DONG
     , B.ADDR1 AS AREA_DETAIL
     , B.ADDR2 AS AREA_DETAIL2
     , B.LAW_DONGNO As LAW_DONGNO
     , B.MAN_NO As MAN_NO
     , B.ROAD_ADDR_DETAIL As ROAD_ADDR_DETAIL
     , B.LAT AS GMAP_X
     , B.LNG AS GMAP_Y
     , B.ZIP_SEQ 
     , B.MEMBER_TYPE
     , ISNULL(C.REG_NUMBER, '') AS REG_NUMBER
  FROM CST_MASTER AS A WITH (NOLOCK)
  JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
  LEFT JOIN CST_COMPANY_LAND AS C WITH (NOLOCK) ON B.COM_ID=C.COM_ID
 WHERE A.CUID = @CUID
GO
