USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_INFO_PROC2]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 /기업 구분 없이 회원 기본 정보 값 가져 오기
 *  작   성   자 : 안상미
 *  작   성   일 : 2008.07.03
 *  수   정   자 : 정헌수 
 *  수   정   일 : 2015-04-14
 *  설        명 : 오류 발생으로 GET_F_MM_MEMBER_TB_INFO_PROC => GET_MM_MEMBER_INFO_PROC 변경 및 필드 추가
					 http://www.findall.co.kr/survey/survey_poll.asp
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 부동산 불량광고 처리 메일 발송 페이지/FindJob 신문문 신문줄광고 신청페이지
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /BService/JobOffer/PaperInsert.asp
 GET_MM_MEMBER_INFO_PROC 'kkam1234'
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_MM_MEMBER_INFO_PROC2] 

	 @USERID VARCHAR(50)

AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 기본정보
	SELECT TOP 1
        A.USERID	-- 회원아이디
        ,A.MEMBER_CD -- 회원구분
        ,A.USER_NM AS USERNAME	-- 회원명
        ,A.EMAIL		-- 이메일
        ,'' AS PHONE
        ,A.HPHONE		-- 휴대폰
        ,A.MOD_DT		-- 수정일
        ,A.JOIN_DT	
        ,A.GENDER
        ,A.BIRTH  AS JUMINNO
        ,A.CUID
        ,A.BAD_YN
        ,A.REST_YN
	  FROM CST_MASTER AS A WITH(NOLOCK)
   WHERE A.OUT_YN ='N'
     AND A.BAD_YN ='N'
     AND A.USERID = @USERID
     AND ISNULL(A.STATUS_CD,'') <> 'D'
     --AND A.CUID = @CUID
   ORDER BY A.SITE_CD ASC   -- 사이트코드 (F:FindAll, S:부동산서브, M: MWPLUS)

END
GO
