USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_INFO_CONTRACT_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 다량등록권 회원 검색 후 개인/기업 구분에 따른 회원 정보 값 가져 오기
 *  작   성   자 : 이경덕
 *  작   성   일 : 2014.07.14
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : GET_MM_MEMBER_INFO_CONTRACT_PROC 'dfdf'
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_MM_MEMBER_INFO_CONTRACT_PROC] 

	 @USERID		VARCHAR(50)	-- 회원명

AS
	-- 기본정보
	SELECT USERID	-- 회원아이디
		 , USERNAME	-- 고객명/상호명
		 , isnull(PHONE,'')	as PHONE --연락처
		 , isnull(HPHONE,'')as HPHONE	--휴대폰		 
		 , ISNULL(ADDRESS1,'') +' '+ISNULL(ADDRESS2,'') AS ADDR-- 주소
	  FROM DBO.[USERCOMMON_VI] WITH(NOLOCK)
     WHERE USERID = @USERID
		--AND DELCANNEL IS NULL

GO
