USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_CM_COMPANY_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원DB > 회사 정보 가져오기
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2015/03/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 EXEC GET_CM_COMPANY_INFO_PROC 13821570, 'S102'
 *************************************************************************************/
CREATE PROC [dbo].[GET_CM_COMPANY_INFO_PROC]
  @CUID               INT
, @SECTION_CD             VARCHAR(4)        = ''
AS

BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  /* 회원 개편 후는 아래 주석으로 변경

  IF @SECTION_CD = 'S102'
  BEGIN

    SELECT C.CEO                                  -- 대표자명
         , C.COM_NM                               -- 회사명
         , C.PHONE                                -- 회사전화변호
         , C.CITY                                 -- 시/도
         , C.GU                                   -- 구/군
         , C.DONG                                 -- 동읍면
         , C.ADDR_B AS AREA_DETAIL                -- 상세
         , C.MAIN_BIZ                             -- 주요사업
         , C.EMP_CNT                              -- 직원수
         , C.HOMEPAGE                             -- 홈페이지
         , C.GMAP_X                               -- 지도좌표 X
         , C.GMAP_Y                               -- 지도좌표 Y
         , C.ONESNAME AS MANAGER_NM               -- 담당자
         , M.HPHONE AS MANAGER_PHONE              -- 담당자 연락처
         , M.EMAIL AS MANAGER_EMAIL               -- 담당자 이메일
         , '' AS LOGO_IMG                         -- 회사로고
         , '' AS EX_IMAGE_1                       -- 이미지1
         , '' AS EX_IMAGE_2                       -- 이미지2
         , '' AS EX_IMAGE_3                       -- 이미지3
         , '' AS EX_IMAGE_4                       -- 이미지4
      FROM MEMBER.DBO.MM_COMPANY_TB AS C (NOLOCK)
      JOIN MEMBER.DBO.MM_MEMBER_TB AS M (NOLOCK) ON C.USERID = M.USERID
     WHERE C.USERID = @USER_ID


  END

  */





  IF @SECTION_CD = 'S102'
  BEGIN

    SELECT C.CEO_NM AS CEO              -- 대표자명
         , C.COM_NM                     -- 회사명
         , C.PHONE                      -- 회사전화변호
         , C.CITY                       -- 시/도
         , C.GU                         -- 구/군
         , C.DONG                       -- 동읍면
         , C.ADDR2 AS AREA_DETAIL       -- 상세
         , CM.MAIN_BIZ                  -- 주요사업
         , CM.EMP_CNT                   -- 직원수
         , C.HOMEPAGE                   -- 홈페이지
         , C.LAT AS GMAP_X              -- 지도좌표 X
         , C.LNG AS GMAP_Y              -- 지도좌표 Y
         , CM.MANAGER_NM                -- 담당자
         , CM.MANAGER_PHONE             -- 담당자 연락처
         , CM.MANAGER_EMAIL             -- 담당자 이메일
         , CM.LOGO_IMG                  -- 회사로고
         , CM.EX_IMAGE_1                -- 이미지1
         , CM.EX_IMAGE_2                -- 이미지2
         , CM.EX_IMAGE_3                -- 이미지3
         , CM.EX_IMAGE_4                -- 이미지4
         , C.REGISTER_NO
      FROM MWMEMBER.DBO.CST_MASTER	AS A 
      INNER JOIN MWMEMBER.DBO.CST_COMPANY AS C (NOLOCK) ON A.COM_ID=C.COM_ID
      LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY_JOB AS CM (NOLOCK) ON C.COM_ID = CM.COM_ID
     WHERE A.CUID = @CUID

  END



END


GO
