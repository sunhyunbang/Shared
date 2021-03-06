USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[GET_TBL_CALLMASTER_BY_CUID_PROC]    Script Date: 2021-11-03 오후 4:49:03 ******/
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
