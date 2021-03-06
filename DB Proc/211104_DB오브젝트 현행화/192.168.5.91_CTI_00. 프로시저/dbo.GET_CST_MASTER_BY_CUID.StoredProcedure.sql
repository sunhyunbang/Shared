USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[GET_CST_MASTER_BY_CUID]    Script Date: 2021-11-03 오후 4:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











/*************************************************************************************
 *  단위 업무 명 : 고객상담리스트 게시판 전화번호 검색
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017년 2월 6일
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 전화번호로 회원정보, 상담내역리스트에서 검색
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :

 exec GET_CST_MASTER_BY_CUID '11631083'
 exec GET_CST_MASTER_BY_CUID '11631085'
 exec GET_CST_MASTER_BY_CUID '11631086'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_CST_MASTER_BY_CUID]
	@KEYWORD	VARCHAR(20)	-- 검색 번호

AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
  
	DECLARE	@SQL	NVARCHAR(4000)
	DECLARE @WHERE	NVARCHAR(1000)
	DECLARE @SQL_PARAM NVARCHAR(1000)

	SET @SQL = ''
	SET @WHERE = ''
	SET @SQL_PARAM ='@KEYWORD	VARCHAR(20)'

	-- 검색어
	--IF @KEYWORD <> ''
	--BEGIN
	--	SET @WHERE = ' AND (PHONE = ''' + @KEYWORD + ''' OR HPHONE = ''' + @KEYWORD + ''' OR CALL_PHONE = ''' + @KEYWORD + ''') '
	--END
----------------------------------------
-- 리스트
----------------------------------------

IF @KEYWORD ='' 
BEGIN
	SELECT 0 as CNT
	SELECT 0 where 1 = 0
	RETURN
END

SET @SQL = 'SELECT COUNT(*) AS CNT ' +
		' FROM MWMEMBER.DBO.CST_MASTER M WITH (NOLOCK) LEFT OUTER JOIN MWMEMBER.DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID ' +
		'		LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID ' +
		'	WHERE 1 = 1 AND M.CUID = @KEYWORD ' +

		' SELECT ''CUSTOMER'' AS TBLNAME ' +
	  '  ,M.CUID AS CUID ' +
	  '  ,M.USERID AS USERID ' +
	  '  ,ISNULL(M.USER_NM, '''') AS USER_NM_REAL ' +
	  '  ,dbo.FN_GET_USERNM_SECURE(ISNULL(M.USER_NM, ''''),1,''M'') AS USER_NM ' +
	  '  ,ISNULL(C.COM_NM, '''') AS COM_NM ' +
	  '  ,ISNULL(M.HPHONE, '''') AS HPHONE_REAL ' +
	  '  ,dbo.FN_GET_USERPHONE_SECURE(ISNULL(M.HPHONE, ''''), ''M'') AS HPHONE ' +
	  '  ,ISNULL(C.MAIN_PHONE, '''') AS PHONE_REAL ' +
	  '  ,dbo.FN_GET_USERPHONE_SECURE(ISNULL(C.MAIN_PHONE, ''''), ''M'') AS PHONE ' +
	  '  ,ISNULL(C.REGISTER_NO, '''') AS BIZNO ' +
	  '  ,M.JOIN_DT AS JOIN_DT ' +
	  '  ,B.SECTION_CD AS SECTION_CD ' +
	  '  ,M.MEMBER_CD AS MEMBER_CD ' +
	  '  ,M.OUT_YN AS OUT_YN ' +
	  '  ,M.REST_YN AS REST_YN ' +
	  '  ,ISNULL(M.SNS_TYPE, '''') AS SNS_TYPE ' +
	  '  ,ISNULL(C.MEMBER_TYPE, '''') AS COMPANY_TYPE ' +
		'  ,'''' AS LINEADNO ' +
		'	 ,S.CUID AS BLACKCUID ' +
		'	 ,S.REMARK AS BLACKREMARK ' +
    ' FROM MWMEMBER.DBO.CST_MASTER M WITH (NOLOCK) ' +
	  ' 	LEFT OUTER JOIN MWMEMBER.DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID ' +
	  ' 	LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID ' +
		'		LEFT OUTER JOIN CTI.DBO.TBL_BLACKLIST S WITH (NOLOCK) ON M.CUID = S.CUID ' +
		' WHERE 1 = 1 AND M.CUID = @KEYWORD ';
--print @sql
EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM,
	@KEYWORD


GO
