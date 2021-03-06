USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[GET_M_E_CS_STAT]    Script Date: 2021-11-03 오후 4:49:03 ******/
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
