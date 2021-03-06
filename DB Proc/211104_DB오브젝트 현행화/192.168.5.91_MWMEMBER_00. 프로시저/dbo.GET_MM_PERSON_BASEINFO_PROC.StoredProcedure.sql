USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_PERSON_BASEINFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 개인회원 기본정보 가져오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2018-01-04
 *  설        명 : 회원 개편후 중고장터에서 사용되어 미사용 필드 없음 처리 
 *  주 의  사 항 : 각 섹션별 동의를 해야만 해당 섹션을 이용 할 수 있음.
 *  사 용  소 스 : GET_MM_PERSON_BASEINFO_PROC 'UNME80'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_MM_PERSON_BASEINFO_PROC]
	 @USERID		VARCHAR(50)	-- 회원아이디

AS
		
	SELECT	
	   M.USERID
		,M.USER_NM AS USERNAME
		,M.EMAIL
		,M.HPHONE
		,''  PHONE
		,'' HOMEPAGE
		,'' POST_A
		,'' POST_B
		,'' CITY
		,'' ADDR_A
		,'' ADDR_B
		,M.BAD_YN
		,M.JOIN_DT
		,M.MOD_DT
		,'' AS CITY		-- 시
		,'' AS GU
		,'' AS DONG		
	  FROM	DBO.CST_MASTER M WITH(NOLOCK)
	 WHERE	M.USERID = @USERID 
	   AND	M.MEMBER_CD = '1'
	   AND M.SITE_CD='F'
GO
