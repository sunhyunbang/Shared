USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_PERSON_COMPANY_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 개인/기업 회원 정보 가져오기
 *  작   성   자 : 최승범
 *  작   성   일 : 2016.07.20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 :
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_MM_PERSON_COMPANY_PROC]
	 @CUID		INT
AS
	-- 기본정보
	SELECT   M.USERID	-- 회원아이디
		,M.USER_NM AS USERNAME	-- 회원명
		,M.EMAIL	-- 이메일
		,'' AS PHONE	-- 전화번호
		,M.HPHONE	-- 휴대폰
		,'' AS POST_A	-- 우편번호
		,'' AS POST_B
		,'' AS CITY		-- 시
		,'' AS GU	-- 주소
		,'' AS DONG
		,M.MOD_DT	-- 수정일
		,'' AS HOMEPAGE	-- 홈페이지
		,M.JOIN_DT
		,'' AS JOIN_DOMAIN
		,C.COM_NM AS COM_NM
		,C.REGISTER_NO AS BIZNO
	 FROM	DBO.CST_MASTER M WITH(NOLOCK)
	 LEFT OUTER JOIN DBO.CST_COMPANY C ON M.COM_ID = C.COM_ID
	WHERE	M.CUID = @CUID

GO
