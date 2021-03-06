USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_COMPANY_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************  
 *  단위 업무 명 : 기업서비스 홈 > 기업정보 불러오기  
 *  작   성   자 : 최 병찬  
 *  작   성   일 : 2013/08/12  
 *  수   정   자 : 정헌수  
 *  수   정   일 : 2015-04-20  
 *  설        명 : RPC CALL 로 변경  
 *  주 의  사 항 :  
 *  사 용  소 스 : 기업서비스 홈  
 *  사 용  예 제 : EXEC DBO.GET_F_COMPANY_INFO_PROC 14129771  
 *************************************************************************************/  
CREATE PROC [dbo].[GET_F_COMPANY_INFO_PROC]  
  @CUID INT  
AS  
  
SET NOCOUNT ON  
  
  SELECT TOP 1 B.CEO_NM  AS CEO                -- 대표자명  
       , B.REGISTER_NO  AS  BIZNO                    -- 사업자번호  
       , B.COM_NM                     -- 회사명  
       , replace(B.MAIN_PHONE,' ','')  AS PHONE1      -- 회사전화변호  
       , B.CITY                       -- 시/도  
       , B.GU                         -- 구/군  
       , B.DONG                       -- 동읍면  
       --, B.ADDR1 + ' ' + B.ADDR2 AS AREA_DETAIL                -- 상세  
       , B.ADDR1 AS AREA_DETAIL                -- 상세  
       , C.MAIN_BIZ                  -- 주요사업  
       , C.EMP_CNT                   -- 직원수  
       , B.HOMEPAGE                   -- 홈페이지  
       , B.LAT AS GMAP_X                     -- 지도좌표 X  
       , B.LNG AS GMAP_Y                     -- 지도좌표 Y  
       , C.MANAGER_NM AS ONESNAME    -- 담당자  
       , C.MANAGER_PHONE AS PHONE2   -- 담당자 연락처  
       , C.MANAGER_EMAIL AS EMAIL    -- 담당자 이메일  
       , C.LOGO_IMG                  -- 회사로고  
       , C.EX_IMAGE_1                -- 이미지1  
       , C.EX_IMAGE_2                -- 이미지2  
       , C.EX_IMAGE_3                -- 이미지3  
       , C.EX_IMAGE_4                -- 이미지4  
			 , ISNULL(B.ADDR2, '') AS AREA_DETAIL2      -- 상세2
    FROM MWMEMBER.dbo.CST_MASTER AS A  
    JOIN MWMEMBER.dbo.CST_COMPANY AS B ON B.COM_ID = A.COM_ID  
    LEFT JOIN MWMEMBER.dbo.CST_COMPANY_JOB AS C ON C.COM_ID = B.COM_ID  
   WHERE A.USERID NOT IN ('a2013', 'NoMember')      -- NoMember : 비회원 계정, a2013 : 간편구인등록 등록대행 계정  
     AND A.CUID NOT IN (1001, 1002)  
     AND A.CUID = @CUID  
  
  
  
  
  
GO
