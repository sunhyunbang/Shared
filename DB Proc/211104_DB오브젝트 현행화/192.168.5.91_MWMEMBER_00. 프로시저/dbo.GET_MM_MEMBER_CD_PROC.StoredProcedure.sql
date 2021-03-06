USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_CD_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
새로 추가한 프로시저

회원의 MEMBER_CD를 조회해 옴

2009년 2월 20일 추가 최병찬

신문 자동 등록 관리자 페이지에서 사용
*/
CREATE PROC [dbo].[GET_MM_MEMBER_CD_PROC]
	 @USERID		VARCHAR(50)	-- 회원명

AS
SET NOCOUNT ON

	-- 기본정보
	SELECT  ISNULL(M.MEMBER_CD,1) AS MEMBER_CD
	  FROM dbo.CST_MASTER M WITH(NOLOCK)
	 WHERE M.USERID = @USERID
GO
