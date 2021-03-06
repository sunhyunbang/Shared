USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[GET_CSTYPE_PROC]    Script Date: 2021-11-03 오후 4:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 회원상담 게시판 유형 검색
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2018/01/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC GET_CSTYPE_PROC 'F', '04', '신문'

*************************************************************************************/

CREATE PROCEDURE [dbo].[GET_CSTYPE_PROC]
		@SITECODE CHAR(1) = ''
	,	@MEMBERCODE CHAR(2) = ''
	, @TYPEKEYWORD VARCHAR(50) = ''
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT COUNT(*) AS CNT
	FROM TBL_CSCODE
	WHERE SITECODE = 'F'
		AND (MEMBERCODENAME + ' ' + CSCODENAME + ' ' + CALLCODENAME + ' ' + CODE_DESC) LIKE '%' + @TYPEKEYWORD + '%'
		AND STAT = 'Y'
		AND MEMBERCODE = @MEMBERCODE

	SELECT
		CODE, SITECODE, MEMBERCODE, MEMBERCODENAME, CSCODE, CSCODENAME, CALLCODE, CALLCODENAME, CODE_DESC
	FROM TBL_CSCODE
	WHERE SITECODE = 'F'
		AND (MEMBERCODENAME + ' ' + CSCODENAME + ' ' + CALLCODENAME + ' ' + CODE_DESC) LIKE '%' + @TYPEKEYWORD + '%'
		AND STAT = 'Y'
		AND MEMBERCODE = @MEMBERCODE
	ORDER BY DISPLAY_ORDER, CODE_SEQ;

END
GO
