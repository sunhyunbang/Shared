USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_COMPANY_MEMBER_YN_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 기업회원 여부 가져오기
 *  작   성   자 : 최 봉 기
 *  작   성   일 : 2013-08-27
 *  수   정   자 : 최 승 범
 *  수   정   일 : 2016-07-18
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 각 섹션별 동의를 해야만 해당 섹션을 이용 할 수 있음.
 *  사 용  소 스 : GET_MM_COMPANY_MEMBER_YN_PROC 'SKY80COM','',13

 GET_MM_COMPANY_MEMBER_YN_PROC 'bizjob01','',14
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_MM_COMPANY_MEMBER_YN_PROC]
  @USERID		      VARCHAR(50)		-- 회원아이디
, @SECTION_CD     CHAR(4) = ''			-- 섹션 CD, 해당 섹션 CD가 없을 경우 기업회원으로 판단여부(쿠폰에서 필요)
, @GROUP_CD	      INT = 14				-- 부동산의 경우 일반회원도 쿠폰 발급 가능

AS

IF @SECTION_CD = 'S102'
BEGIN
	SELECT TOP 1 M.CUID
	  FROM DBO.CST_MASTER M WITH(NOLOCK)
		JOIN DBO.CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
	 WHERE M.USERID = @USERID
     AND M.OUT_YN = 'N'
   ORDER BY M.SITE_CD ASC
END
ELSE
BEGIN
  --신문관리 > 쿠폰에서 사용(기업회원 판단여부는 추후 결정, 현재는 기업회원이면 무조건 발송가능)
	SELECT TOP 1 M.CUID
	  FROM DBO.CST_MASTER M WITH(NOLOCK)
	 WHERE M.USERID = @USERID
     AND (M.MEMBER_CD=2 OR @GROUP_CD = 13)
     AND M.OUT_YN = 'N'
   ORDER BY M.SITE_CD ASC
END

GO
