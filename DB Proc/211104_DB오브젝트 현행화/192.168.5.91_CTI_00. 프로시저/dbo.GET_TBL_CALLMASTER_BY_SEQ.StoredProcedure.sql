USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[GET_TBL_CALLMASTER_BY_SEQ]    Script Date: 2021-11-03 오후 4:49:03 ******/
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
