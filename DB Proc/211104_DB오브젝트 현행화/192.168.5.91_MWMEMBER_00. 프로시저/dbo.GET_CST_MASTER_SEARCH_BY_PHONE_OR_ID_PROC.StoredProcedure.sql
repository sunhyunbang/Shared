USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_CST_MASTER_SEARCH_BY_PHONE_OR_ID_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 아이디, 전화번호로 회원 검색
 *  작   성   자 :
 *  작   성   일 :
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
exec DBO.GET_CST_MASTER_SEARCH_BY_PHONE_OR_ID_PROC 'M.HPHONE','010-4671-3335'
*************************************************************************************/
CREATE PROCEDURE [dbo].[GET_CST_MASTER_SEARCH_BY_PHONE_OR_ID_PROC]
	@KEY_CLS		VARCHAR(30)	-- 검색키	[아이디:M.USERID, 핸드폰:M.HPHONE]
	,@KEYWORD		VARCHAR(50)	-- 검색어
AS
  SET NOCOUNT ON
  
	DECLARE	@SQL	NVARCHAR(4000)
	DECLARE @WHERE	NVARCHAR(1000)

	SET @SQL = ''
	SET @WHERE = ''

----------------------------------------
-- 검색
----------------------------------------
	-- 검색어
	IF @KEY_CLS <> '' AND @KEYWORD <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' LIKE ''' + @KEYWORD + '%'' '
		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' <> '''' '
	END
----------------------------------------
-- 리스트
----------------------------------------
	SET @SQL = 'SELECT COUNT(M.USERID) AS CNT '+
				'  FROM	DBO.CST_MASTER M WITH (NOLOCK)'+
				'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
				'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
				' WHERE 1=1 ' + @WHERE + ';' +

				' SELECT ' +
				' M.CUID'+
				',M.USERID'+
				',ISNULL(M.USER_NM,'''') AS USER_NM'+
				',ISNULL(C.COM_NM,'''') AS COM_NM'+
				',ISNULL(M.USER_NM,'''')+''/''+ISNULL(C.COM_NM,'''') AS NAME'+
				',ISNULL(M.HPHONE,'''') AS HPHONE'+
				',ISNULL(C.REGISTER_NO,'''') AS NUMBER'+
				',M.JOIN_DT'+
				',B.SECTION_CD'+
				',M.MEMBER_CD'+
				',M.OUT_YN'+
				',M.REST_YN'+
				',ISNULL(M.SNS_TYPE,'''') AS SNS_TYPE'+
				',ISNULL(C.MEMBER_TYPE,'''') AS COMPANY_TYPE'+
				',ISNULL(C.MAIN_PHONE,'''') AS CPHONE'+
			'  FROM	DBO.CST_MASTER M WITH (NOLOCK) '+
			'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
			'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
			' WHERE 1=1 ' + @WHERE +
			'ORDER BY M.JOIN_DT DESC';
--print @sql
EXECUTE SP_EXECUTESQL @Sql



GO
