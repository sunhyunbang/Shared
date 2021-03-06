USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_MEMBER_SEARCH_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > Ajax 회원리스트
 *  작   성   자 :
 *  작   성   일 :
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
exec DBO.GET_AD_MM_MEMBER_SEARCH_PROC_BK01 1,10,'C.REGISTER_NO','2208528967'
exec DBO.GET_AD_MM_MEMBER_SEARCH_PROC 1,10,'C.REGISTER_NO','2208528967'
*************************************************************************************/
CREATE PROCEDURE [dbo].[GET_AD_MM_MEMBER_SEARCH_PROC]
	 @PAGE			INT		-- 페이지
	,@PAGESIZE		INT		-- 페이지사이즈
	,@KEY_CLS		VARCHAR(30)	-- 검색키	[아이디:M.USERID, 이름:M.USER_NM, 사업자번호:C.REGISTER_NO, 핸드폰:M.HPHONE , 이메일:M.EMAIL]
	,@KEYWORD		VARCHAR(50)	-- 검색어

AS
  SET NOCOUNT ON
  
	DECLARE	@SQL		NVARCHAR(4000)
	DECLARE	@SQL_PARAM	NVARCHAR(2000)
	DECLARE @WHERE		NVARCHAR(1000)

	SET @SQL = ''
	SET @WHERE = ''
SET @SQL_PARAM ='
	 @PAGE			INT		
	,@PAGESIZE		INT		
	,@KEY_CLS		VARCHAR(30)	
	,@KEYWORD		VARCHAR(50)	
'
----------------------------------------
-- 검색
----------------------------------------
	-- 검색어
--	IF @KEY_CLS <> '' AND @KEYWORD <> ''
--	BEGIN
	
--		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' LIKE @KEYWORD + ''%'' '
--		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' <> '''' '
--	END
-- 2019.04.17 변경

IF @KEY_CLS = 'C.COM_NM' AND @KEYWORD <> ''
 BEGIN
  SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' LIKE @KEYWORD + ''%'' '
 END
 ELSE
 BEGIN
  IF @KEY_CLS <> '' AND @KEYWORD <> ''
  BEGIN
 
   SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' = ' + '''' + @KEYWORD + ''''
   SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' <> '''' '
  END
 END


----------------------------------------
-- 리스트
----------------------------------------
	SET @SQL =	'SELECT COUNT(*) AS CNT '+
				'  FROM	DBO.CST_MASTER M WITH (NOLOCK)'+
				'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
				'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
				' WHERE 1=1 ' + @WHERE + ';' +

				'SELECT TOP (@PAGE * @PAGESIZE) '+
				' M.CUID'+
				',M.USERID'+
				',dbo.FN_GET_USERNM_SECURE(ISNULL(M.USER_NM,''''),1,''M'')+''/''+ISNULL(C.COM_NM,'''') AS NAME'+
				',dbo.FN_GET_USERPHONE_SECURE(ISNULL(M.HPHONE,''''), ''M'') AS HPHONE'+
				',ISNULL(C.REGISTER_NO,'''') AS NUMBER'+
				',M.JOIN_DT'+
				',B.SECTION_CD'+
				',M.MEMBER_CD'+
				',M.OUT_YN'+
				',M.REST_YN'+
				',ISNULL(M.SNS_TYPE,'''') AS SNS_TYPE'+
				',ISNULL(C.MEMBER_TYPE,'''') AS COMPANY_TYPE'+
				',ISNULL(M.STATUS_CD,'''') AS STATUS_CD'+
				',ISNULL(M.MASTER_ID,'''') AS MASTER_ID'+
				',M.BAD_YN'+
			'  FROM	DBO.CST_MASTER M WITH (NOLOCK) '+
			'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
			'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
			' WHERE 1=1 ' + @WHERE +
			'ORDER BY M.JOIN_DT DESC';
--print @sql
EXECUTE SP_EXECUTESQL @Sql,@SQL_PARAM,
	 @PAGE			
	,@PAGESIZE		
	,@KEY_CLS		
	,@KEYWORD		
GO
