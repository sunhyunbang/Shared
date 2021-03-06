USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_PERSON_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 개인 회원 정보 가져오기
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.12.26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 :
 GET_MM_PERSON_PROC 'jjangssoon6'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_MM_PERSON_PROC]
	 @USERID		VARCHAR(50)	-- 회원명
AS
	-- 기본정보
	SELECT   USER_NM AS USERID	-- 회원아이디
		,USER_NM AS USERNAME	-- 회원명
		,EMAIL AS EMAIL	-- 이메일
		,'' AS PHONE	-- 전화번호
		,HPHONE AS HPHONE	-- 휴대폰
		,'' AS POST_A	-- 우편번호
		,'' AS POST_B
		,'' AS CITY		-- 시
		,'' AS GU	-- 주소
		,'' AS DONG
		,MOD_DT	-- 수정일
		,'' AS HOMEPAGE	-- 홈페이지
		,JOIN_DT
		,'' AS JOIN_DOMAIN
	 FROM CST_MASTER
	WHERE USERID = @USERID

	-- 이용동의 섹션 가져오기
	--EXEC	DBO.GET_MM_JOIN_PROC @USERID,''

	-- 메일 수신 동의 섹션 가져오기
	--EXEC	DBO.GET_MM_MSG_AGREE_PROC @USERID,''

GO
