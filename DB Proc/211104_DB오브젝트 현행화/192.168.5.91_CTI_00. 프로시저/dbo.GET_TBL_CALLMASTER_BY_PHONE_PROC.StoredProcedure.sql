USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[GET_TBL_CALLMASTER_BY_PHONE_PROC]    Script Date: 2021-11-03 오후 4:49:03 ******/
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
