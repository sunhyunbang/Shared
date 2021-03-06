USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_M_JOIN_SEARCH_LIST_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 - 등록대행 - 공고등록 - ************************************
 *  단위 업무 명 : 관리자 - 등록대행 - 공고등록 - 기업회원 가입여부 조회
 *  작   성   자 : 배진용
 *  작   성   일 : 2020/12/03
 *  설		  명 : 탈퇴(OUT_YN = 'N')가 아니고 휴면(REST_YN = N)이 아니고 일반회원(MEMBER_TYPE = 1)이면서 기업 회원(MEMBER_CODE = 2)인 계정 조회
 *  수   정   자 :
 *  수   정   일 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
EXEC DBO.[GET_M_JOIN_SEARCH_LIST_PROC] @PAGE=1, @PAGE_SIZE=10, @SEARCH_KEY='4', @SEARCH_WORD='1234567890'
EXEC DBO.[GET_M_JOIN_SEARCH_LIST_PROC] @PAGE=1, @PAGE_SIZE=10, @SEARCH_KEY='4', @SEARCH_WORD='123-45-67890'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_M_JOIN_SEARCH_LIST_PROC]
(
	  @PAGE				INT				    = 1
	, @PAGE_SIZE		INT				    = 10
	, @SEARCH_KEY		VARCHAR(1)		     = NULL
	, @KEYWORD		 VARCHAR(50)		      = NULL
)
AS

BEGIN
	SET NOCOUNT ON

	DECLARE @SQL NVARCHAR(4000)
	DECLARE @SQL_WHERE NVARCHAR(1000)

	SET @SQL = ''
	SET @SQL_WHERE = ''

	IF @SEARCH_KEY = '1'  -- 대표번호
	BEGIN
		SET @SQL_WHERE = ' AND REPLACE(B.MAIN_PHONE, ''-'', '''') LIKE ''%' + @KEYWORD + '%'''
	END

	IF @SEARCH_KEY = '2'  -- 회원 휴대폰 번호
	BEGIN
		SET @SQL_WHERE = ' AND REPLACE(A.HPHONE, ''-'', '''') LIKE ''%' + @KEYWORD + '%'''
	END

	IF @SEARCH_KEY = '3'  -- 회사명
	BEGIN
		SET @SQL_WHERE = ' AND B.COM_NM LIKE ''%' + @KEYWORD + '%'''
	END

	IF @SEARCH_KEY = '4'  -- 사업자등록번호
	BEGIN
		SET @SQL_WHERE = ' AND REPLACE(B.REGISTER_NO, ''-'', '''') LIKE ''%' + @KEYWORD + '%'''
	END

	SET @SQL =
				'SELECT	count(*)
				  FROM CST_MASTER AS A WITH (NOLOCK) 
				  JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
				 WHERE A.MEMBER_CD = ''2'' 
				   AND A.REST_YN = ''N''
				   AND B.MEMBER_TYPE = 1
				   AND A.OUT_YN=''N''' + @SQL_WHERE

	EXECUTE SP_EXECUTESQL @SQL

	SET @SQL = 'SELECT * 
				  FROM
						(SELECT
							   A.USERID   -- 아이디
							 , B.COM_NM -- 회사명 
							 , b.CEO_NM	-- 대표자명
							 , B.REGISTER_NO AS BIZNO
							 , B.MAIN_PHONE AS MAIN_NUMBER -- 대표번호
							 , A.HPHONE -- 회원 핸드폰번호
							 , A.USER_NM -- 회원 이름
							 , CASE WHEN AGENCY_YN = ''Y'' AND LAST_SIGNUP_YN =''N'' THEN ''N''
                 ELSE ''Y'' END AS LAST_SIGNUP_YN -- 최종가입여부
							 ,ROW_NUMBER() OVER (ORDER BY A.JOIN_DT DESC) AS ROWNUM
						  FROM CST_MASTER AS A WITH (NOLOCK) 
						  JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
						 WHERE A.MEMBER_CD = ''2'' 
						   AND A.REST_YN = ''N''
						   AND B.MEMBER_TYPE = 1
						   AND A.OUT_YN=''N'' ' + @SQL_WHERE  + ') AS row 
					WHERE row.ROWNUM > ' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGE_SIZE) + ' AND row.ROWNUM <= ' + CONVERT(VARCHAR(10), (@PAGE) * @PAGE_SIZE)

	 EXECUTE SP_EXECUTESQL @SQL
END
GO
