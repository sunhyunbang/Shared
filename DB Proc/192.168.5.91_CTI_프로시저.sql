USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[GET_CS_BY_PHONE_PROC]    Script Date: 2021-11-04 오전 11:00:16 ******/
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

 exec GET_CS_BY_PHONE_PROC '02-3019-1582'
 exec GET_CS_BY_PHONE_PROC '010-4671-3335'
 exec GET_CS_BY_PHONE_PROC '010-3334-6800'
 exec GET_CS_BY_PHONE_PROC '031-772-6252'
 
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_CS_BY_PHONE_PROC]
	@KEYWORD	VARCHAR(20)	-- 검색 번호

AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
  
	DECLARE	@SQL	NVARCHAR(4000)
	DECLARE @WHERE	NVARCHAR(1000)
	DECLARE	@SQL_PARM	NVARCHAR(MAX)
	
	SET @SQL = ''
	SET @WHERE = ''
	SET @SQL_PARM = '
		@KEYWORD VARCHAR(20)
	'


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
	SELECT 0  as CNT
	SELECT 0 where 1=0
	RETURN 
END
SET @SQL = 
		/*
		' SELECT SUM(A) AS CNT FROM ' +
		' ( ' +
		' 	SELECT COUNT(*) AS A ' +
		*/
		' 	SELECT COUNT(*) AS CNT ' +
		' 	FROM MWMEMBER.DBO.CST_MASTER M WITH (NOLOCK) LEFT OUTER JOIN MWMEMBER.DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID ' +
		'			LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID ' +
		--	'		WHERE 1 = 1 AND M.HPHONE = ''' + @KEYWORD + ''' ' +
		'		WHERE 1 = 1 ' +
		'			AND M.CUID IN ( ' +
		'				SELECT CUID ' +
		'				FROM MWMEMBER.DBO.CST_MASTER M WITH (NOLOCK) ' +
		'				WHERE M.HPHONE = @KEYWORD ' +
		'				UNION ALL ' +
		'				SELECT M.CUID ' +
		'				FROM MWMEMBER.DBO.CST_MASTER M WITH (NOLOCK) ' +
		'					LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY C  WITH (NOLOCK) ON M.COM_ID = C.COM_ID ' +
		'				WHERE C.MAIN_PHONE = @KEYWORD ' +
		'			) ' +
		--	'		WHERE 1 = 1 AND (M.HPHONE = ''' + @KEYWORD + ''' OR C.MAIN_PHONE = ''' + @KEYWORD + ''')' +
		/*
		'		UNION ALL ' +
		'		SELECT COUNT(*) AS C ' +
		'		FROM [DBO].[TBL_CALLMASTER] ' +
		'		WHERE 1=1 AND (PHONE = ''' + @KEYWORD + ''' OR HPHONE = ''' + @KEYWORD + ''' OR CALL_PHONE = ''' + @KEYWORD + ''') ' +
		') AS A ' +
		*/

		' SELECT ''CUSTOMER'' AS TBLNAME ' +
	  '  ,M.CUID AS CUID ' +
	  '  ,M.USERID AS USERID ' +
	  '  ,ISNULL(M.USER_NM, '''') AS USER_NM_REAL  ' +
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
--		' WHERE 1 = 1 AND M.HPHONE = ''' + @KEYWORD + ''' ';
		'	WHERE 1 = 1 ' +
		'		AND M.CUID IN ( ' +
		'			SELECT CUID ' +
		'			FROM MWMEMBER.DBO.CST_MASTER M WITH (NOLOCK) ' +
		'			WHERE M.HPHONE = @KEYWORD ' +
		'			UNION ALL ' +
		'			SELECT M.CUID ' +
		'			FROM MWMEMBER.DBO.CST_MASTER M WITH (NOLOCK) ' +
		'				LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY C  WITH (NOLOCK) ON M.COM_ID = C.COM_ID ' +
		'			WHERE C.MAIN_PHONE = @KEYWORD ' +
		'		) ';
--		' WHERE 1 = 1 AND (M.HPHONE = ''' + @KEYWORD + ''' OR C.MAIN_PHONE = ''' + @KEYWORD + ''')';
		/*
 	  ' UNION ALL ' +
 	  ' SELECT ''CSCALL'' AS TBLNAME ' +
	  '   ,'''' AS CUID ' +
		' 	,'''' AS USERID ' +
		' 	,CUSTOMER_NM AS USER_NM ' +
		' 	,COMPANY_NM AS COM_NM ' +
		' 	,HPHONE AS HPHONE ' +
		' 	,PHONE AS PHONE ' +
		' 	,BIZNO AS BIZNO ' +
		' 	,'''' AS JOIN_DT ' +
		' 	,'''' AS SECTION_CD ' +
		' 	,MEMBERCLASS AS MEMBER_CD ' +
		' 	,'''' AS OUT_YN ' +
		' 	,'''' AS REST_YN ' +
		' 	,'''' AS SNS_TYPE ' +
		' 	,'''' AS COMPANY_TYPE ' +
		' 	,'''' AS LINEADNO ' +
		' 	,'''' AS BLACKCUID ' +
		' 	,'''' AS BLACKREMARK ' +		
		' FROM [DBO].[TBL_CALLMASTER] ' +
		' WHERE 1=1 AND (PHONE = ''' + @KEYWORD + ''' OR HPHONE = ''' + @KEYWORD + ''' OR CALL_PHONE = ''' + @KEYWORD + ''') ' +
		' GROUP BY MEMBERCLASS, CUSTOMER_NM, COMPANY_NM, BIZNO, PHONE, HPHONE ';
		*/
--print @sql
EXECUTE SP_EXECUTESQL @SQL, @SQL_PARM 
	, @KEYWORD












GO
/****** Object:  StoredProcedure [dbo].[GET_CSCALL_REPORT]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017/02/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 고객상담리스트 리포트
 *  주 의  사 항 : 
 *  사 용  소 스 :
 *  사 용  예 제 : 
 EXEC [GET_CSCALL_REPORT] '2016-02-01','','F', 'I', '', '', '', '', '', 'kkam1234', '', '', '010-3127-3287', ''
 EXEC [GET_CSCALL_REPORT] '2017-02-16','2017-02-16','F', 'I', '', '', '', '', '', '', '', '', '', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_CSCALL_REPORT]
		@START_DT VARCHAR(10) = ''	-- 기간 선택 시작 strStartDate 1
	, @END_DT VARCHAR(10) = ''	-- 기간 선택 끝 strEndDate 2
	, @SITECODE VARCHAR(5) = 'F' -- 3
	, @INOUT CHAR(1) = '' -- 인아웃 4
	, @C_NAME VARCHAR(50) = '' -- 상담자이름 5
	, @CALL_CODE VARCHAR(50) = '' -- 통화유형 6 IN 쿼리라 VARCHAR형
	, @CS_CODE VARCHAR(50) = '' -- 문의유형 7 IN 쿼리라 VARCHAR형
	, @MEMBERCLASS CHAR(1) = '' -- 회원구분 8
	, @CATE_CODE CHAR(1) = '' -- 분류 9
	, @USERID VARCHAR(50) = '' -- 회원아이디 -- 키워드 10
	, @BIZNO VARCHAR(20) = '' -- 사업자번호 -- 키워드 11
	, @PHONE VARCHAR(20) = '' -- 대표번호 -- 키워드 12
	, @HPHONE VARCHAR(20) = '' -- 휴대폰번호 -- 키워드 13
	, @CALL_PHONE VARCHAR(20) = '' -- 발신번호 -- 키워드 14

AS
SET NOCOUNT ON
	DECLARE	@SQL NVARCHAR(4000)
	DECLARE @SQL_WHERE NVARCHAR(2000)
	
	SET @SQL = ''
	SET @SQL_WHERE = ''
	
	IF @START_DT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGDATE >= CONVERT(DATETIME, ''' + @START_DT + ''') '
	END
	
	IF @END_DT <> ''
	BEGIN
		--SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGDATE <= CONVERT(DATETIME, ''' + @END_DT + ''') '
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGDATE < DATEADD(day, 1, CONVERT(DATETIME, ''' + @END_DT + ''')) '
	END
	
	IF @INOUT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.INOUT = ''' + @INOUT + ''' '
	END

	IF @C_NAME <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.C_NAME = ''' + @C_NAME + ''' '
	END

	IF @CALL_CODE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.CALL_CODE IN (' + @CALL_CODE + ') '
	END

	IF @CS_CODE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.CS_CODE IN (' + @CS_CODE + ') '
	END

	IF @MEMBERCLASS <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.MEMBERCLASS = ''' + @MEMBERCLASS + ''' '
	END

	IF @CATE_CODE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.CATE_CODE = ''' + @CATE_CODE + ''' '
	END

	IF @USERID <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.USERID = ''' + @USERID + ''' '
	END

	IF @BIZNO <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.BIZNO = ''' + @BIZNO + ''' '
	END

	IF @PHONE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.PHONE = ''' + @PHONE + ''' '
	END

	IF @HPHONE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.HPHONE = ''' + @HPHONE + ''' '
	END

	IF @CALL_PHONE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.CALL_PHONE = ''' + @CALL_PHONE + ''' '
	END

	SET @SQL = ' SELECT ' +
						 ' A.REGDATE, A.C_NAME, A.CS_TEXT, dbo.FN_GET_USERPHONE_SECURE(A.CALL_PHONE, ''M'') AS CALL_PHONE, C.CSCODENAME, C.CALLCODENAME, ' +
						 ' A.INOUT, A.MEMBERCLASS, A.USERID, dbo.FN_GET_USERNM_SECURE(A.CUSTOMER_NM,1,''M'') AS CUSTOMER_NM, A.BIZNO, dbo.FN_GET_USERPHONE_SECURE(A.PHONE, ''M'') AS PHONE, ' +
						 ' dbo.FN_GET_USERPHONE_SECURE(A.HPHONE, ''M'') AS HPHONE, A.AD_NO, A.CATE_CODE, A.C_ID, A.REMARK ' +
						/*
						 '		A.SEQ, A.INOUT, A.MEMBERCLASS, A.CS_CODE, A.CALL_CODE, A.CUSTOMER_NM ' +
						 '		, A.COMPANY_NM, A.CUID, A.USERID, A.BIZNO, A.C_ID, A.C_NAME, A.PHONE, A.HPHONE, A.CALL_PHONE ' +
						 '		, A.CS_TEXT, A.REMARK, A.REGDATE, A.STAFF_SEQ, A.STAFF_ID, A.SITE_CD, A.MODDATE, A.MODSTAFF_SEQ ' +
						 '		, A.MODSTAFF_ID, A.STAT, A.AD_NO, A.CATE_CODE ' +
						 '		, C.MEMBERCODENAME, C.CSCODENAME, C.CALLCODENAME ' +
						 */
						 ' FROM TBL_CALLMASTER A, TBL_CSCODE C ' +
						 ' WHERE A.CS_CODE = C.CSCODE ' +
						 ' 		AND A.CALL_CODE = C.CALLCODE ' +
						 ' 		AND C.SITECODE = ''F'' ' + @SQL_WHERE + ' ' +
						 ' ORDER BY A.REGDATE DESC ';
print @Sql
EXECUTE SP_EXECUTESQL @Sql
GO
/****** Object:  StoredProcedure [dbo].[GET_CSCALL_REPORT_BAK01]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017/02/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 고객상담리스트 리포트
 *  주 의  사 항 : 
 *  사 용  소 스 :
 *  사 용  예 제 : 
 EXEC [GET_CSCALL_REPORT] '2016-02-01','','F', 'I', '', '', '', '', '', 'kkam1234', '', '', '010-3127-3287', ''
 EXEC [GET_CSCALL_REPORT_BAK01] '2017-02-16','2017-03-30','S', 'I', '', '', '', '', '', '', '', '', '', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_CSCALL_REPORT_BAK01]
		@START_DT VARCHAR(10) = ''	-- 기간 선택 시작 strStartDate 1
	, @END_DT VARCHAR(10) = ''	-- 기간 선택 끝 strEndDate 2
	, @SITECODE VARCHAR(5) = 'S' -- 3
	, @INOUT CHAR(1) = '' -- 인아웃 4
	, @C_NAME VARCHAR(50) = '' -- 상담자이름 5
	, @CALL_CODE VARCHAR(50) = '' -- 통화유형 6 IN 쿼리라 VARCHAR형
	, @CS_CODE VARCHAR(50) = '' -- 문의유형 7 IN 쿼리라 VARCHAR형
	, @MEMBERCLASS CHAR(1) = '' -- 회원구분 8
	, @CATE_CODE CHAR(1) = '' -- 분류 9
	, @USERID VARCHAR(50) = '' -- 회원아이디 -- 키워드 10
	, @BIZNO VARCHAR(20) = '' -- 사업자번호 -- 키워드 11
	, @PHONE VARCHAR(20) = '' -- 대표번호 -- 키워드 12
	, @HPHONE VARCHAR(20) = '' -- 휴대폰번호 -- 키워드 13
	, @CALL_PHONE VARCHAR(20) = '' -- 발신번호 -- 키워드 14

AS
SET NOCOUNT ON
	DECLARE	@SQL NVARCHAR(4000)
	DECLARE @SQL_WHERE NVARCHAR(2000)
	
	SET @SQL = ''
	SET @SQL_WHERE = ''
	
	IF @START_DT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGDATE >= CONVERT(DATETIME, ''' + @START_DT + ''') '
	END
	
	IF @END_DT <> ''
	BEGIN
		--SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGDATE <= CONVERT(DATETIME, ''' + @END_DT + ''') '
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGDATE < DATEADD(day, 1, CONVERT(DATETIME, ''' + @END_DT + ''')) '
	END
	
	--IF @INOUT <> ''
	--BEGIN
	--	SET @SQL_WHERE = @SQL_WHERE + ' AND A.INOUT = ''' + @INOUT + ''' '
	--END

	IF @C_NAME <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.C_NAME = ''' + @C_NAME + ''' '
	END

	IF @CALL_CODE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.CALL_CODE IN (' + @CALL_CODE + ') '
	END

	IF @CS_CODE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.CS_CODE IN (' + @CS_CODE + ') '
	END

	IF @MEMBERCLASS <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.MEMBERCLASS = ''' + @MEMBERCLASS + ''' '
	END

	IF @CATE_CODE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.CATE_CODE = ''' + @CATE_CODE + ''' '
	END

	IF @USERID <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.USERID = ''' + @USERID + ''' '
	END

	IF @BIZNO <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.BIZNO = ''' + @BIZNO + ''' '
	END

	IF @PHONE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.PHONE = ''' + @PHONE + ''' '
	END

	IF @HPHONE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.HPHONE = ''' + @HPHONE + ''' '
	END

	IF @CALL_PHONE <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.CALL_PHONE = ''' + @CALL_PHONE + ''' '
	END

	SET @SQL = ' SELECT ' +
						 ' A.REGDATE, A.C_NAME, A.CS_TEXT, A.CALL_PHONE, C.CSCODENAME, C.CALLCODENAME, ' +
						 ' A.INOUT, A.MEMBERCLASS, A.USERID, A.CUSTOMER_NM, A.BIZNO, A.PHONE, ' +
						 ' A.HPHONE, A.AD_NO, A.CATE_CODE, A.C_ID, A.REMARK ' +
						/*
						 '		A.SEQ, A.INOUT, A.MEMBERCLASS, A.CS_CODE, A.CALL_CODE, A.CUSTOMER_NM ' +
						 '		, A.COMPANY_NM, A.CUID, A.USERID, A.BIZNO, A.C_ID, A.C_NAME, A.PHONE, A.HPHONE, A.CALL_PHONE ' +
						 '		, A.CS_TEXT, A.REMARK, A.REGDATE, A.STAFF_SEQ, A.STAFF_ID, A.SITE_CD, A.MODDATE, A.MODSTAFF_SEQ ' +
						 '		, A.MODSTAFF_ID, A.STAT, A.AD_NO, A.CATE_CODE ' +
						 '		, C.MEMBERCODENAME, C.CSCODENAME, C.CALLCODENAME ' +
						 */
						 ' FROM TBL_CALLMASTER A, TBL_CSCODE C ' +
						 ' WHERE A.CS_CODE = C.CSCODE ' +
						 ' 		AND A.CALL_CODE = C.CALLCODE ' +
						 ' 		AND C.SITECODE = ''S'' ' + @SQL_WHERE + ' ' +
						 ' ORDER BY A.REGDATE DESC ';
print @Sql
EXECUTE SP_EXECUTESQL @Sql




GO
/****** Object:  StoredProcedure [dbo].[GET_CST_MASTER_BY_CUID]    Script Date: 2021-11-04 오전 11:00:16 ******/
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
/****** Object:  StoredProcedure [dbo].[GET_CSTYPE_PROC]    Script Date: 2021-11-04 오전 11:00:16 ******/
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
/****** Object:  StoredProcedure [dbo].[GET_M_E_CS_STAT]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 
 *  작   성   자 : 최 승 범
 *  작   성   일 : 2017/02/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC CTI.DBO.GET_M_E_CS_STAT '2017-03-17','2017-03-17','F'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_E_CS_STAT]
	@START_DT VARCHAR(10) = ''	-- 기간 선택 시작 strStartDate
	,@END_DT VARCHAR(10) = ''	-- 기간 선택 끝 strEndDate
	,@SITECODE VARCHAR(5) =''
AS
SET NOCOUNT ON

	DECLARE	@SQL	NVARCHAR(4000)
	DECLARE @SQL_WHERE NVARCHAR(2000)
	DECLARE @SQL_WHERE2 NVARCHAR(1000)
	
	SET @SQL = ''
	SET @SQL_WHERE = ''
	SET @SQL_WHERE2 = ''
	
	IF @START_DT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND REGDATE >= CONVERT(DATETIME, ''' + @START_DT + ''') '
	END
	
    IF @END_DT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND REGDATE < DATEADD(day, 1, CONVERT(DATETIME, ''' + @END_DT + '''))'
	END
	
	IF @SITECODE <> ''
	BEGIN
		SET @SQL_WHERE2 = ' AND SITECODE='''+@SITECODE+''' '
	END

	SET @SQL = 'SELECT ' +
		'GROUP_CODE, MAX(CSCODENAME) AS CSCODENAME,' +
		'MAX(CALLCODENAME) AS CALLCODENAME,' +
		'MAX(CODE_DESC) AS CODE_DESC,' +
		'SUM([기업회원]) AS [기업회원],' +
		'SUM([개인회원]) AS [개인회원],' +
		'SUM([비회원]) AS [비회원],' +
		'SUM([지점사문의]) AS [지점사문의],' +
		'SUM(TOTAL_COUNT) AS TOTAL_COUNT' +
		'	FROM (' +

			'SELECT '+
				'GROUP_CODE, '+
				'MAX(CSCODENAME) AS CSCODENAME,  '+
				'MAX(CALLCODENAME) AS CALLCODENAME,  '+
				'MAX(CODE_DESC) AS CODE_DESC,  '+
				'MAX(ISNULL([04],0)) AS [기업회원], '+
				'MAX(ISNULL([05],0)) AS [개인회원], '+
				'MAX(ISNULL([06],0)) AS [비회원], '+
				'MAX(ISNULL([07],0)) AS [지점사문의],  '+
				'MAX(ISNULL(TOTAL_COUNT,0)) AS TOTAL_COUNT '+
				'FROM( '+
				'	SELECT A.GROUP_CODE, A.CSCODENAME, A.CALLCODENAME, A.CODE_DESC, A.MEMBERCODE, ISNULL(B.[COUNT],0) AS [COUNT], ISNULL(B.[SUM],0) AS TOTAL_COUNT '+
				'	FROM [CTI].[dbo].[TBL_CSCODE] AS A '+
				'	LEFT OUTER JOIN ( '+
				'			SELECT CASE WHEN MEMBERCLASS IN (1,3,6) THEN ''04'' WHEN MEMBERCLASS = 2 THEN ''05'' WHEN MEMBERCLASS IN (4,7) THEN ''07''  '+
				'			WHEN MEMBERCLASS = 5 THEN ''06'' ELSE '''' END AS MEMBERCODE ,  '+
				'			CS_CODE, CALL_CODE, COUNT(*) AS [COUNT], GROUP_CODE ,  '+
				'			( '+
				'			SELECT COUNT(*)  '+
				'			FROM [CTI].[dbo].[TBL_CALLMASTER] AS A1 '+
				'			INNER JOIN [CTI].[dbo].[TBL_CSCODE] AS B1  '+
				'			ON A1.CALL_CODE=B1.CALLCODE '+
				'			WHERE  B1.GROUP_CODE = B.GROUP_CODE ' + @SQL_WHERE + @SQL_WHERE2 +
				'			) AS [SUM] '+
				'			FROM [CTI].[dbo].[TBL_CALLMASTER] AS A '+
				'			INNER JOIN [CTI].[dbo].[TBL_CSCODE] AS B '+
				'			ON A.CALL_CODE=B.CALLCODE '+
				'			WHERE 1=1 ' + @SQL_WHERE + @SQL_WHERE2 +
				'			GROUP BY MEMBERCLASS, CS_CODE, CALL_CODE, B.GROUP_CODE '+
				'			) AS B '+
				'	ON A.MEMBERCODE = B.MEMBERCODE AND A.GROUP_CODE = B.GROUP_CODE '+
				'	WHERE 1=1 ' + @SQL_WHERE2 +
				') T '+
				'PIVOT ( SUM([COUNT]) FOR MEMBERCODE IN ([04],[05],[06],[07]) ) AS PVT '+
				'GROUP BY GROUP_CODE ' +
	
	
		') as TBL_R ' +
		'GROUP BY GROUP_CODE ' +
		'WITH ROLLUP ';

				print @Sql
				EXECUTE SP_EXECUTESQL @Sql







GO
/****** Object:  StoredProcedure [dbo].[GET_SELECTBOX_CSCODE_PROC]    Script Date: 2021-11-04 오전 11:00:16 ******/
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
/****** Object:  StoredProcedure [dbo].[GET_TBL_CALLMASTER_BY_CUID_PROC]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










/*************************************************************************************
 *  단위 업무 명 : 고객상담리스트 CUID로 검색
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017년 2월 14일
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : TBL_CALLMASTER 검색 CUID로
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :

exec [GET_TBL_CALLMASTER_BY_CUID_PROC] '1', '15', '11123101'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_TBL_CALLMASTER_BY_CUID_PROC]
		@PAGE				INT		-- 페이지
	 ,@PAGESIZE		INT		-- 페이지사이즈
	 ,@CUID				INT
AS

SET NOCOUNT ON
  
DECLARE	 @SQL NVARCHAR(4000)
DECLARE	 @WHERE NVARCHAR(1000)
				,@SQL_PARAM	NVARCHAR(MAX)

SET @SQL_PARAM ='
		 @PAGE			INT
		,@PAGESIZE  INT
		,@CUID			INT
'

SET @SQL = ''
SET @WHERE = ''
 
IF LEN(@CUID) > 1
	BEGIN
		SET @WHERE = ' AND A.CUID = @CUID '
	END

SET @SQL =  ' SELECT COUNT(*) AS CNT FROM TBL_CALLMASTER A ' +
					  '	WHERE 1 = 1 ' + @WHERE +
					
						'	SELECT TOP ' + CONVERT(VARCHAR(10), @PAGE * @PAGESIZE) +
						'		A.SEQ, A.REGDATE, A.C_NAME, LEFT(A.CS_TEXT, 20) AS CS_TEXT, A.CALL_PHONE, A.CS_CODE, A.CALL_CODE, ' +
						'		A.INOUT, A.MEMBERCLASS, A.COMPANY_NM, A.CUSTOMER_NM, A.AD_NO, A.CATE_CODE, A.USERID, ' +
						'		A.CUID, A.SITE_CD, ' +
						'		B.CSCODENAME, B.CALLCODENAME ' +
						' FROM TBL_CALLMASTER A, TBL_CSCODE B ' +
						' WHERE 1 = 1 ' +
						'		AND A.CS_CODE = B.CSCODE ' +
						'		AND A.CALL_CODE = B.CALLCODE ' + @WHERE +
						'	ORDER BY REGDATE DESC ';

--print @sql
EXECUTE SP_EXECUTESQL @SQL, @SQL_PARAM
		,@PAGE
		,@PAGESIZE
		,@CUID


GO
/****** Object:  StoredProcedure [dbo].[GET_TBL_CALLMASTER_BY_PHONE_PROC]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 고객상담리스트 검색
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017년 2월 6일
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : TBL_CALLMASTER 검색
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :

exec [GET_TBL_CALLMASTER_BY_PHONE_PROC] '10104594', '010-6833-0722', '신경숙', '123123123'
exec [GET_TBL_CALLMASTER_BY_PHONE_PROC] '0', '010-3127-3287', 'N', ''
exec [GET_TBL_CALLMASTER_BY_PHONE_PROC] '0', '010-3127-3287', '정헌수', '0050724941080180'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_TBL_CALLMASTER_BY_PHONE_PROC]
		@CUID INT = 0
	,	@KEYWORD VARCHAR(20)	-- 검색 전화번호
	, @CNAME VARCHAR(20)	-- 검색 이름
	, @CADNO VARCHAR(30)	-- 광고 번호
	

AS
  SET NOCOUNT ON
  
	DECLARE	@SQL NVARCHAR(4000)
	DECLARE @WHERE NVARCHAR(1000)
			,@SQL_PARAM	NVARCHAR(MAX)
	SET @SQL_PARAM = ' 
			@CUID INT, 
			@KEYWORD VARCHAR(20), 
			@CNAME VARCHAR(20), 
			@CADNO VARCHAR(30)
		'

	SET @SQL = ''
	SET @WHERE = ''

	IF LEN(@CUID) > 1
		BEGIN
			SET @WHERE = ' AND A.CUID = @CUID '
			--SET @WHERE = ' AND A.CUID = 0'
		END
	ELSE IF @CADNO != ''
		BEGIN
			SET @WHERE = @WHERE + ' AND A.AD_NO = @CADNO '
		END
	ELSE
		IF @CNAME = 'N'
			BEGIN
				SET @WHERE = ' AND (A.CALL_PHONE = @KEYWORD OR A.HPHONE = @KEYWORD) '
			END
		ELSE
			BEGIN
				SET @WHERE = ' AND A.CUSTOMER_NM = @CNAME AND (A.CALL_PHONE = @KEYWORD OR A.HPHONE = @KEYWORD) '
			END



SET @SQL =  ' SELECT COUNT(*) AS CNT FROM TBL_CALLMASTER A ' +
					  '	WHERE 1 = 1 ' + @WHERE +
					
						' SELECT ' +
						'		A.SEQ, A.REGDATE, dbo.FN_GET_USERNM_SECURE(A.C_NAME,1,''M'') AS C_NAME, RTRIM(LEFT(A.CS_TEXT, 200)) AS CS_TEXT, dbo.FN_GET_USERPHONE_SECURE(A.CALL_PHONE, ''M'') AS CALL_PHONE, A.CS_CODE, A.CALL_CODE, ' +
						--'		A.SEQ, A.REGDATE, A.C_NAME, RTRIM(LEFT(A.CS_TEXT, 200)) + ''...'' AS CS_TEXT, A.CALL_PHONE, A.CS_CODE, A.CALL_CODE, ' +
						'		A.INOUT, A.MEMBERCLASS, A.COMPANY_NM, A.CUSTOMER_NM, A.AD_NO, A.CATE_CODE, A.USERID, A.CUID, ' +
						'		B.CSCODENAME, B.CALLCODENAME, ' +
						'		CONVERT(VARCHAR(10), A.REGDATE, 120) AS VIEWDATE ' +
						' FROM TBL_CALLMASTER A, TBL_CSCODE B ' +
						' WHERE 1 = 1 ' +
						'		AND A.CS_CODE = B.CSCODE ' +
						'		AND A.CALL_CODE = B.CALLCODE ' + @WHERE +
						'	ORDER BY REGDATE DESC ';

print @sql
EXECUTE SP_EXECUTESQL @SQL, @SQL_PARAM
		,	@CUID 
		,	@KEYWORD 
		, @CNAME
		, @CADNO









GO
/****** Object:  StoredProcedure [dbo].[GET_TBL_CALLMASTER_BY_SEQ]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 상담내역 보기
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017/02/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
exec [GET_TBL_CALLMASTER_BY_SEQ] '13'
*************************************************************************************/
CREATE PROC [dbo].[GET_TBL_CALLMASTER_BY_SEQ]
	@SEQ	INT = 1
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @SQL	NVARCHAR(MAX)
			,@SQL_PARAM	NVARCHAR(MAX)
			,@SQL_WHERE NVARCHAR(MAX)
	SET @SQL_PARAM = '
	@SEQ		INT'
	
	SET @SQL_WHERE = ''
	IF @SEQ <> '' 
	BEGIN
			SET @SQL_WHERE = ' AND A.SEQ = @SEQ '
	END 	

	SET @SQL = '	
		SELECT A.SEQ, A.INOUT, A.MEMBERCLASS, A.CS_CODE, A.CALL_CODE
			, A.CUSTOMER_NM, A.COMPANY_NM, A.CUID, A.USERID, A.BIZNO
			, A.C_ID, A.C_NAME, A.PHONE, A.HPHONE, A.CALL_PHONE, A.CS_TEXT
			, A.REMARK, A.REGDATE, A.STAFF_SEQ, A.STAFF_ID, A.SITE_CD
			, A.MODDATE, A.MODSTAFF_SEQ, A.MODSTAFF_ID, A.STAT, A.AD_NO
			, A.CATE_CODE
			, B.CSCODENAME, B.CALLCODENAME
			, C.CUID AS BLACKCUID, C.REMARK as BLACKREMARK
		FROM TBL_CALLMASTER A WITH(NOLOCK)
			LEFT OUTER JOIN TBL_CSCODE B ON A.CS_CODE = B.CSCODE
			LEFT OUTER JOIN TBL_BLACKLIST C ON A.CUID = C.CUID
		WHERE 1 = 1
			AND A.CALL_CODE = B.CALLCODE
			' + @SQL_WHERE +'
	'
	SET @SQL_PARAM = REPLACE(@SQL_PARAM, 'OUTPUT' , '')
	EXECUTE SP_EXECUTESQL @SQL  ,@SQL_PARAM
	,@SEQ
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_CS_BLACK_PROC]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/***************************************************************
 *  단위 업무 명 : 회원상담 게시판 블랙리스트 Insert
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017/02/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
***************************************************************/
CREATE PROC [dbo].[PUT_CS_BLACK_PROC]
		@CUID INT
	, @STAFF_ID VARCHAR(50)
	, @REMARK VARCHAR(400)
	, @USEYN CHAR(1)
	, @SITE_CD CHAR(1)
AS

SET NOCOUNT ON

INSERT [dbo].[TBL_BLACKLIST]
	( CUID, STAFF_ID, REMARK, USEYN, SITE_CD )
VALUES
	( @CUID, @STAFF_ID, @REMARK, @USEYN, @SITE_CD )


GO
/****** Object:  StoredProcedure [dbo].[PUT_CS_CALLMASTER_PROC]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/***************************************************************
 *  단위 업무 명 : 회원상담 게시판 Insert
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017/02/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
***************************************************************/
CREATE PROC [dbo].[PUT_CS_CALLMASTER_PROC]
		@INOUT CHAR(1)
	, @MEMBERCLASS CHAR(1)
	, @CS_CODE CHAR(2)
	, @CALL_CODE CHAR(3)
	, @CUSTOMER_NM VARCHAR(50)

	, @COMPANY_NM VARCHAR(50)
	, @CUID INT
	, @USERID VARCHAR(50)
	, @BIZNO VARCHAR(20)
	, @C_ID INT
	
	, @C_NAME VARCHAR(50)
	, @PHONE VARCHAR(20)
	, @HPHONE VARCHAR(20)
	, @CALL_PHONE VARCHAR(20)
	, @CS_TEXT VARCHAR(MAX)
	
	, @REMARK VARCHAR(400)
	, @STAFF_ID VARCHAR(50)
	, @SITE_CD CHAR(1)
	--, @MODSTAFF_ID VARCHAR(50)
	, @STAT CHAR(1)
	
	, @AD_NO VARCHAR(20)
	, @CATE_CODE CHAR(1)
AS

SET NOCOUNT ON

INSERT [dbo].[TBL_CALLMASTER]
	( INOUT, MEMBERCLASS, CS_CODE, CALL_CODE, CUSTOMER_NM, COMPANY_NM, CUID, USERID, BIZNO, C_ID, C_NAME
		, PHONE, HPHONE, CALL_PHONE, CS_TEXT, REMARK, STAFF_ID, SITE_CD 
		, STAT, AD_NO, CATE_CODE )
VALUES
	( @INOUT, @MEMBERCLASS, @CS_CODE, @CALL_CODE, @CUSTOMER_NM, @COMPANY_NM, @CUID, @USERID, @BIZNO, @C_ID, @C_NAME
		, @PHONE, @HPHONE, @CALL_PHONE, @CS_TEXT, @REMARK, @STAFF_ID, @SITE_CD
		, @STAT, @AD_NO, @CATE_CODE )


GO
/****** Object:  StoredProcedure [dbo].[SP_CTI_GETCODE]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
*객체이름 : CTI 코드 검색
*제작자   : KJH
*버젼     :
*제작일   : 2017.02.08
EXEC SP_CTI_GETCODE 'S','1','01'
****************************************************************************************************/
CREATE	PROCEDURE [dbo].[SP_CTI_GETCODE]
	@SITECODE		CHAR(1)	= '',	
	@CODECLASS		VARCHAR(3)	= '',
	@CODE			CHAR(2)		= ''	

AS
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	IF @CODECLASS ='1' BEGIN --문의유형	
		SELECT CSCODE,CSCODENAME FROM TBL_CSCODE WITH(NOLOCK) WHERE SITECODE=@SITECODE AND MEMBERCODE=@CODE GROUP BY CSCODE,CSCODENAME
	END 
	
	IF @CODECLASS ='2' BEGIN --콜유형
		SELECT CALLCODE,CALLCODENAME FROM TBL_CSCODE WITH(NOLOCK) WHERE SITECODE=@SITECODE AND CSCODE=@CODE GROUP BY CALLCODE,CALLCODENAME
	END 
	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_CTI_I1]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: CIT Insert
	제작자		: kjh
	제작일		: 20170209
	수정자		: 
	수정일		: 
	실행예제	:
 
 ******************************************************************************/
CREATE       PROCEDURE [dbo].[SP_CTI_I1]

	@callType	char(1) = '',
	@membercode	char(1) = '',
	@CSCODE		char(2) = '',
	@CALLCODE	char(3) = '',
	@customer_nm	varchar(50) = '',	
	@company_nm	varchar(50) = '',
	@CUID		int	= 0 ,	
	@userid		varchar(50) = '',
	@phone		varchar(20) = '',
	@bizno		varchar(20) = '',
	@callno		varchar(20) = '',
	@c_id		int = 0,
	@c_name		varchar(50) = '',
	@cs_text	varchar(max) = '',
	@remark		varchar(400) = '',
	@STAFF_SEQ	int = 0,
	@stat		char(1) = '',
	@good_id	int = 0,
	@blackyn	char(1) = '',
	@black_txt	varchar(200)
	
	
AS
BEGIN

	declare @blackregcnt int	

	SET NOCOUNT ON

	INSERT INTO memberdb.cti.dbo.tbl_callmaster
           (
			INOUT, 
			MEMBERCLASS, 
			CS_CODE, 
			CALL_CODE, 
			CUSTOMER_NM, 
			COMPANY_NM, 
			CUID, 
			USERID, 
			BIZNO, 
			C_ID, 
			C_NAME, 
			PHONE, 
			CALL_PHONE, 
			CS_TEXT, 
			REMARK, 
			REGDATE, 
			STAFF_SEQ,
			SITE_CD, 
			STAT, 
			AD_NO
           )
     VALUES
           (
			@callType,
			@membercode,			
			@CSCODE,
			@CALLCODE,
			@customer_nm,
			@company_nm,
			@CUID,			
			@userid,
			@bizno,
			@c_id,
			@c_name,			
			@phone,
			@callno,
			@cs_text,
			@remark,
			getdate(),
			@STAFF_SEQ,
			'S',
			@stat,
			@good_id
           )
           
      IF  @blackyn ='Y' BEGIN
		select @blackregcnt=count(*) from memberdb.cti.dbo.tbl_blacklist where cuid=@CUID and remark=@black_txt
		if @blackregcnt =0 begin
			INSERT INTO memberdb.cti.dbo.tbl_blacklist (cuid,regdate,staff_seq,remark,site_cd) values (@CUID,getdate(),@STAFF_SEQ,@black_txt,'S')
		end 
      END     
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CTI_S01]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
*객체이름 : CTI 리스트
*제작자   : JMG
*버젼     :
*제작일   : 2017.02.08
SP_CTI_S01 13621996
****************************************************************************************************/
CREATE	PROCEDURE [dbo].[SP_CTI_S01]
	@mem_seq		int,
	@CurrentPage	int = 1	,
	@pagesize		int = 300,
	@rowCnt			int=0 output
AS
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @sql varchar(5000)	
	SET @sql = ''
	
	CREATE TABLE #temp_list (tseq int not null identity(1,1) primary key nonclustered, seq int not null) 
	
	SET @sql = @sql + '
	INSERT INTO #temp_list(seq)
	select seq
	from dbo.tbl_callmaster with(nolock)
	where 1 = 1'
    IF @mem_seq > 0 BEGIN
		SET @sql = @sql + '	AND cuid = ''' + CAST(@mem_seq AS VARCHAR) + ''''
	END
	SET @sql = @sql + '	ORDER BY seq DESC '
		
	PRINT(@sql)
	EXEC(@sql)
	SET @rowCnt = @@rowcount

	select totalcount = @rowCnt
	, tc.seq, convert(varchar(10),regdate, 121) regdate, c_name, cs_text, call_phone, cs_code, call_code, inout, memberclass, company_nm, customer_nm, ad_no
     from dbo.tbl_callmaster tc with(nolock) 
     join #temp_list t with(nolock) on t.seq = tc.seq AND t.tseq BETWEEN (((@CurrentPage-1)*@pagesize)+1) AND (@CurrentPage*@pagesize)
     ORDER BY t.tseq	
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CTI_U1]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: CIT Insert
	제작자		: kjh
	제작일		: 20170209
	수정자		: 
	수정일		: 
	실행예제	:
 exec rserve.dbo.SP_CTI_U1 '1', '1', '09', '031', '중개업소', '', 0, '', '', '', '010-9543-2616', 0, '', '모바일2 등기부 파일명 숫자로 변환후 재첨부해보실것 안내111', '', 1038, '1', 0, 61821 
 ******************************************************************************/
CREATE       PROCEDURE [dbo].[SP_CTI_U1]

	@callType	char(1) = '',
	@membercode	char(1) = '',
	@CSCODE		char(2) = '',
	@CALLCODE	char(3) = '',
	@customer_nm	varchar(50) = '',	
	@company_nm	varchar(50) = '',
	@CUID		int	= 0 ,	
	@userid		varchar(50) = '',
	@phone		varchar(20) = '',
	@bizno		varchar(20) = '',
	@callno		varchar(20) = '',
	@c_id		int = 0,
	@c_name		varchar(50) = '',
	@cs_text	varchar(max) = '',
	@remark		varchar(400) = '',
	@STAFF_SEQ	int = 0,
	@stat		char(1) = '',
	@good_id	int = 0,
	@callseq	int = 0

	
	
AS
BEGIN

	SET NOCOUNT ON

	UPDATE cti.dbo.tbl_callmaster
    SET
			INOUT = @callType, 
			MEMBERCLASS = @membercode, 
			CS_CODE = @CSCODE, 
			CALL_CODE = @CALLCODE, 
			CUSTOMER_NM = @customer_nm, 
			COMPANY_NM = @company_nm, 
			CUID = @CUID, 
			USERID = @userid, 
			BIZNO = @bizno, 
			C_ID = @c_id, 
			C_NAME = @c_name, 
			PHONE = @phone, 
			CALL_PHONE = @callno, 
			CS_TEXT = @cs_text, 
			REMARK = @remark, 
			MODDATE = getdate(), 
			MODSTAFF_SEQ = @STAFF_SEQ,
			AD_NO = @good_id
     WHERE  SITE_CD ='S' and seq=@callseq
           
   
END

GO
/****** Object:  StoredProcedure [dbo].[UPDATE_CS_CALLMASTER_PROC]    Script Date: 2021-11-04 오전 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/***************************************************************
 *  단위 업무 명 : 회원상담 게시판 Edit
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017/02/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
***************************************************************/
CREATE PROC [dbo].[UPDATE_CS_CALLMASTER_PROC]
		@SEQ INT
	,	@INOUT CHAR(1)
	, @MEMBERCLASS CHAR(1)
	, @CS_CODE CHAR(2)
	, @CALL_CODE CHAR(3)

	, @CUSTOMER_NM VARCHAR(50)
	, @COMPANY_NM VARCHAR(50)
	--, @CUID INT
	, @USERID VARCHAR(50)
	, @BIZNO VARCHAR(20)

	, @C_ID INT
	, @C_NAME VARCHAR(50)
	, @PHONE VARCHAR(20)
	, @HPHONE VARCHAR(20)
	, @CALL_PHONE VARCHAR(20)

	, @CS_TEXT VARCHAR(MAX)
	, @REMARK VARCHAR(400)
	, @SITE_CD CHAR(1)
	, @MODSTAFF_ID VARCHAR(50)
	, @STAT CHAR(1)

	, @AD_NO VARCHAR(20)
	, @CATE_CODE CHAR(1)
--	, @CHKBLACK CHAR(1)
AS

SET NOCOUNT ON

UPDATE DBO.TBL_CALLMASTER
SET 
		INOUT =	@INOUT
	, MEMBERCLASS = @MEMBERCLASS
	, CS_CODE = @CS_CODE
	, CALL_CODE = @CALL_CODE
	, CUSTOMER_NM = @CUSTOMER_NM

	, COMPANY_NM = @COMPANY_NM
--	, CUID = @CUID
	, USERID = @USERID
	, BIZNO = @BIZNO
	, C_ID = @C_ID

	, C_NAME = @C_NAME
	, PHONE = @PHONE
	, HPHONE = @HPHONE
	, CALL_PHONE = @CALL_PHONE
	, CS_TEXT = @CS_TEXT

	, REMARK = @REMARK
	, SITE_CD = @SITE_CD
	, MODSTAFF_ID = @MODSTAFF_ID
	, STAT = @STAT
	, MODDATE = GETDATE()

	, AD_NO = @AD_NO
	, CATE_CODE = @CATE_CODE
WHERE SEQ = @SEQ

--IF @CHKBLACK = 'ON'


GO
