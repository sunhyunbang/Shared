USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[GET_SELECTBOX_CSCODE_PROC]    Script Date: 2021-11-03 오후 4:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 회원상담 게시판 유형 SELECT BOX
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017/02/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
EXEC DBO.GET_SELECTBOX_CSCODE_PROC 4, 'F', '05', '45', ''

EXEC DBO.GET_SELECTBOX_CSCODE_PROC 3, 'F', '06', '', ''

EXEC DBO.GET_SELECTBOX_CSCODE_PROC 4, 'F', '', '36', ''

EXEC DBO.GET_SELECTBOX_CSCODE_PROC 5, 'F', '', '', '117'

*************************************************************************************/

CREATE PROCEDURE [dbo].[GET_SELECTBOX_CSCODE_PROC]
		@LEVEL INT
	, @SITECODE CHAR(1) = ''
	, @MEMBERCODE CHAR(2) = ''
	, @CSCODE CHAR(2) = ''
	, @CALLCODE CHAR(3) = ''
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	IF @LEVEL = 1 -- 벼룩시장, 써브 구분
		BEGIN
			SELECT SITECODE, SITECODENAME
			FROM TBL_CSCODE
			WHERE STAT = 'Y'
			GROUP BY SITECODE, SITECODENAME
		END
	ELSE IF @LEVEL = 2 -- 회원구분
		BEGIN
			SELECT MEMBERCODE, MEMBERCODENAME
			FROM TBL_CSCODE
			WHERE SITECODE = @SITECODE
				AND STAT = 'Y'
			GROUP BY MEMBERCODE, MEMBERCODENAME
		END
	ELSE IF @LEVEL = 3 -- 문의유형구분
		BEGIN
			SELECT CSCODE, CSCODENAME
			FROM TBL_CSCODE
			WHERE SITECODE = @SITECODE
				AND MEMBERCODE = @MEMBERCODE
				AND STAT = 'Y'
			GROUP BY CSCODE, CSCODENAME
		END
	ELSE IF @LEVEL = 4 -- 통화유형구분
		BEGIN
			SELECT CALLCODE, CALLCODENAME
			FROM TBL_CSCODE
			WHERE SITECODE = @SITECODE
				--AND MEMBERCODE = @MEMBERCODE
				AND CSCODE = @CSCODE
				AND STAT = 'Y'
			GROUP BY CALLCODE, CALLCODENAME
		END
	ELSE IF @LEVEL = 5 -- 통화유형 설명
		BEGIN
			SELECT CALLCODE, CODE_DESC
			FROM TBL_CSCODE
			WHERE SITECODE = @SITECODE
				--AND MEMBERCODE = @MEMBERCODE
				AND CALLCODE = @CALLCODE
				AND STAT = 'Y'
			GROUP BY CALLCODE, CODE_DESC
		END
END


GO
