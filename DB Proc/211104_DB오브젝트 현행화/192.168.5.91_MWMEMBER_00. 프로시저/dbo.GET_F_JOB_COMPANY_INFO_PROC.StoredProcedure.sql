USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_JOB_COMPANY_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013-03-04
 *  수   정   자 : 김 준 홍
 *  수   정   일 : 2015-06-17
 *  수   정      : @P_IDCODE 변수의 데이터타입을 int 에서 char(6)으로 변경함
 *  설        명 : 회원가입 및 ID 찾기 핸드폰 인증 번호 확인
 *  주 의  사 항 :
 *  사 용  소 스 :
 EXEC DBO.CHK_MM_HP_AUTH_CODE_PROC '1','김준홍2','19790522','M','01020500865','','053413','R','','' 
 select top 10 * from MM_HP_AUTH_CODE_TB where username = '김준홍2' order by dt desc
 SELECT * FROM CST_MASTER WHERE USERID = 'cowto7602'
 GET_F_JOB_COMPANY_INFO_PROC 10621983
 exec [dbo].[GET_F_JOB_COMPANY_INFO_PROC] @CUID=13924991
************************************************************************************/
CREATE  PROC [dbo].[GET_F_JOB_COMPANY_INFO_PROC]

  @CUID  INT
     
AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT B.CEO_NM AS CEO              -- 대표자명
       , B.REGISTER_NO AS BIZNO       -- 사업자번호
       , B.COM_NM                     -- 회사명
       , B.MAIN_PHONE AS PHONE1       -- 회사전화변호
       , B.CITY                       -- 시/도
       , B.GU                         -- 구/군
       , B.DONG                       -- 동읍면
       , B.ADDR1 AS AREA_DETAIL       -- 상세
       , C.MAIN_BIZ                   -- 주요사업
       , C.EMP_CNT                    -- 직원수
       , B.HOMEPAGE                   -- 홈페이지
       , B.LAT AS GMAP_X              -- 지도좌표 X
       , B.LNG AS GMAP_Y              -- 지도좌표 Y
       , C.MANAGER_NM AS ONESNAME     -- 담당자
       , C.MANAGER_PHONE AS PHONE2    -- 담당자 연락처
       , C.MANAGER_EMAIL AS EMAIL     -- 담당자 이메일
       , C.LOGO_IMG                   -- 회사로고
       , C.EX_IMAGE_1                 -- 이미지1
       , C.EX_IMAGE_2                 -- 이미지2
       , C.EX_IMAGE_3                 -- 이미지3
       , C.EX_IMAGE_4                 -- 이미지4
       , B.FAX
			 , ISNULL(B.ADDR2, '') AS AREA_DETAIL2      -- 상세2
    FROM MWMEMBER.dbo.CST_MASTER AS A (NOLOCK)
    JOIN MWMEMBER.dbo.CST_COMPANY AS B (NOLOCK) ON B.COM_ID = A.COM_ID
    LEFT JOIN MWMEMBER.dbo.CST_COMPANY_JOB AS C ON B.COM_ID = C.COM_ID
   WHERE A.CUID = @CUID
     -- AND C.SECTION_CD = 'S102'
     
     
END
GO
