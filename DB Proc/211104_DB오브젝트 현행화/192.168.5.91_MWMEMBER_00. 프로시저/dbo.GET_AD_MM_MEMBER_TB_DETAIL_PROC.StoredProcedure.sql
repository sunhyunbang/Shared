USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_MEMBER_TB_DETAIL_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원리스트 > 회원 상세
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015.02.15
 *  수   정   자 : 도정민
 *  수   정   일 : 2019.10.01
 *  설        명 : 마케팅·이벤트정보 수신 동의 추가
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_MM_MEMBER_TB_DETAIL_PROC 'SEBILIA'

 *************************************************************************************/

CREATE PROCEDURE [dbo].[GET_AD_MM_MEMBER_TB_DETAIL_PROC]
	@CUID		INT
AS

SET NOCOUNT ON

	SELECT	M.USERID
		,CASE
		      WHEN MEMBER_CD=2 THEN '비즈니스'
		      WHEN MEMBER_CD=1 AND SNS_TYPE='N' THEN '일반(네이버)'
		      WHEN MEMBER_CD=1 AND SNS_TYPE='F' THEN '일반(페이스북)'
		      WHEN MEMBER_CD=1 AND SNS_TYPE='K' THEN '일반(카카오톡)'
		      WHEN MEMBER_CD=1 THEN '일반'
		 END AS MEMBER_CD
		,J.SECTION_CD
		,M.JOIN_DT
		,M.USER_NM
		,M.MOD_DT
		,M.HPHONE
		,CASE
		      WHEN M.DI IS NOT NULL AND M.DI <> '' THEN 'Y' -- DI ='' 인경우 추가
		      ELSE 'N'
		 END AS REAL_CHK_YN
		,M.REST_YN
		,M.EMAIL		
		,M.OUT_YN
	    ,M.BAD_YN
		,M.BIRTH AS JUMINNO	
	    , NULL AS SECTION_CD_ETC
        ,CM.AGREE_DT AS MK_AGREE_DT             -- 20191001 추가 
		,ISNULL(CM.AGREEF,'0') AS MK_AGREEF     -- 20191001 추가
		,CASE
		      WHEN ISNULL(AGENCY_YN, 'N') = 'Y' THEN 'Y' -- 회원가입대행 여부 추가 2021-06-07
		      ELSE 'N'
		 END AS AGENCY_YN
		,ISNULL(LAST_SIGNUP_YN, 'Y') AS LAST_SIGNUP_YN
	  FROM	DBO.CST_MASTER M WITH(NOLOCK)
	  LEFT JOIN CST_JOIN_INFO AS J WITH (NOLOCK) ON M.CUID = J.CUID
	  LEFT OUTER JOIN CST_MARKETING_AGREEF_TB AS CM ON CM.CUID = M.CUID       -- 20191001 추가
	 WHERE	M.CUID = @CUID
GO
