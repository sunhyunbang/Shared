USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[GET_CSCALL_REPORT_BAK01]    Script Date: 2021-11-03 오후 4:49:03 ******/
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
