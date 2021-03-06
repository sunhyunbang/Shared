USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_COMPANY_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 기업 정보 가져오기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-3-12
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * EXEC GET_MM_COMPANY_INFO_PROC 10621983,'S103'
   
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_COMPANY_INFO_PROC]
       @CUID         INT
     , @SECTION_CD   CHAR(4) = 'S102'
AS

SET NOCOUNT ON

IF @SECTION_CD='S103'
BEGIN
SELECT
       A.USERID   --0
     , B.REGISTER_NO AS BIZNO
     , B.COM_NM
     , B.CEO_NM AS CEO
     , B.MAIN_PHONE AS MAIN_NUMBER
     , ISNULL(B.PHONE,'') PHONE    --5
     , B.FAX
     , B.HOMEPAGE
     , B.CITY
     , B.GU
     , B.DONG     --10
     , B.ADDR1 AS AREA_DETAIL
     , B.LNG AS GMAP_X
     , B.LAT AS GMAP_Y
     
     , '' AS MANAGER_NM
     , '' AS MANAGER_PHONE  --15
     , '' AS MANAGER_EMAIL
     , '' AS MANAGER_NUMBER
     , '' AS MANAGER_IMG_F
     , '' AS MANAGER_IMG_B
     , '' AS MANAGER_KAKAO_ID    --20
     
     , '' AS BIZ_CLASS
     , '' AS BIZ_CODE
     , '' AS EMP_CNT
     , '' AS MAIN_BIZ
     , case when REG_NUMBER > '' then 'A' ELSE '' end  AS LAND_CLASS        --25
     , ISNULL(C.REG_NUMBER,'') AS REG_NUMBER
     , C.INTRO
     , C.LOGO_IMG
     , '' AS EX_IMAGE_1
     , '' AS EX_IMAGE_2       --30
     , '' AS EX_IMAGE_3
     , '' AS EX_IMAGE_4
     , C.ETCINFO_SYNC
     , A.CUID
     , A.EMAIL as EMAIL		--35
     , A.HPHONE 
     , B.ADDR2 AS AREA_DETAIL2
     , B.ZIP_SEQ AS ZIP_SEQ
     , B.LAW_DONGNO As LAW_DONGNO
     , B.MAN_NO As MAN_NO		--40
     , B.ROAD_ADDR_DETAIL As ROAD_ADDR_DETAIL
     , A.USER_NM AS USERNAME
     FROM CST_MASTER AS A WITH (NOLOCK) 
  JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
  LEFT JOIN CST_COMPANY_LAND AS C WITH (NOLOCK) ON B.COM_ID=C.COM_ID
 WHERE A.CUID = @CUID
   AND A.OUT_YN='N'
   
END

ELSE --부동산 아니면 나머지는 구인에서 가져옮
BEGIN
SELECT
       A.USERID   --0
     , B.REGISTER_NO AS BIZNO
     , B.COM_NM
     , B.CEO_NM AS CEO
     , B.MAIN_PHONE AS MAIN_NUMBER
     , ISNULL(B.PHONE,'') PHONE    --5
     , B.FAX
     , B.HOMEPAGE
     , B.CITY
     , B.GU
     , B.DONG     --10
     , B.ADDR1 AS AREA_DETAIL
     , B.LAT AS GMAP_X
     , B.LNG AS GMAP_Y
     
     , C.MANAGER_NM
     , C.MANAGER_PHONE  --15
     , C.MANAGER_EMAIL
     , '' AS MANAGER_NUMBER
     , '' AS MANAGER_IMG_F
     , '' AS MANAGER_IMG_B
     , '' AS MANAGER_KAKAO_ID    --20
     
     , C.BIZ_CLASS
     , C.BIZ_CD AS BIZ_CODE
     , C.EMP_CNT
     , C.MAIN_BIZ
     , case when REG_NUMBER > '' then 'A' ELSE '' end  AS LAND_CLASS        --25
     , D.REG_NUMBER
     , '' AS INTRO
     , C.LOGO_IMG
     , C.EX_IMAGE_1
     , C.EX_IMAGE_2       --30
     , C.EX_IMAGE_3
     , C.EX_IMAGE_4
     , '' AS ETCINFO_SYNC		
     , A.CUID
     , A.EMAIL as EMAIL	--35
     , A.HPHONE 
     , B.ADDR2 AS AREA_DETAIL2
     , B.ZIP_SEQ AS ZIP_SEQ
     , B.LAW_DONGNO As LAW_DONGNO
     , B.MAN_NO As MAN_NO		--40
     , B.ROAD_ADDR_DETAIL As ROAD_ADDR_DETAIL
		 , A.USER_NM AS USERNAME
  FROM CST_MASTER AS A WITH (NOLOCK) 
  JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
  LEFT JOIN CST_COMPANY_JOB AS C WITH (NOLOCK) ON B.COM_ID=C.COM_ID
  LEFT OUTER JOIN CST_COMPANY_LAND AS D WITH (NOLOCK) ON B.COM_ID=D.COM_ID
 WHERE A.CUID = @CUID
   AND A.OUT_YN='N'
END



GO
