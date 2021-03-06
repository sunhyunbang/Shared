USE [Mediawill]
GO
/****** Object:  StoredProcedure [dbo].[MW_AD_TB_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고 - MW_AD_TB 상세
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고 상세
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_AD_TB_DETAIL_PROC TO MWINCUSER
' EXEC DBO.MW_AD_TB_DETAIL_PROC 1
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_AD_TB_DETAIL_PROC]
	  @IDX			INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	SELECT    IDX
			, AD_CATEGORY
			, AD_TITLE
			, AD_CONTENTS			
			, AD_URL
			, AD_DATE
			, REG_IP
			, REG_DT
			, UPD_IP
			, UPD_DT
			, VIEW_STATUS
			, DEL_ISYN	
	FROM DBO.MW_AD_TB WITH (NOLOCK)
	WHERE IDX = @IDX AND DEL_ISYN = 'N'

END
GO
/****** Object:  StoredProcedure [dbo].[MW_AD_TB_INS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고 - MW_AD_TB INSERT
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고(TV, CF, 인쇄물) 등록
' 주  의  사  항	: @AD_CATEGORY     : T(TV CF), R(라디오 CF), P(인쇄물) 
                      @AD_CORP         : A(알바),  B(벼룩시장),  C(부동산서브)..
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_AD_TB_INS_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_AD_TB_INS_ADMIN_PROC 'T', A, 'A', '광고 제목 1 테스트', '광고 내용 1 테스트', 'https://www.youtube.com/v/vWZPRjGFsNs?wmode=transparent&autoplay=1&version=1&loop=1&ytplayer=1&fs=1&hd=1', 'AD.JPG', '2015-03-01', '111.222.333.444', 'W'
' EXEC DBO.MW_AD_TB_INS_ADMIN_PROC 'R', A, 'A', '라디오 광고 제목 1 테스트', '라디오 광고 내용 1 테스트', 'https://www.youtube.com/v/vWZPRjGFsNs?wmode=transparent&autoplay=1&version=1&loop=1&ytplayer=1&fs=1&hd=1', 'AD.JPG', '2015-03-01', '111.222.333.444', 'W'
' EXEC DBO.MW_AD_TB_INS_ADMIN_PROC 'P', A, 'A', '인쇄 광고 제목 1 테스트', '인쇄 광고 내용 1 테스트', '', 'AD.JPG', '2015-03-01', '111.222.333.444', 'W'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_AD_TB_INS_ADMIN_PROC]
	  @AD_CATEGORY			VARCHAR(1)
	, @AD_TITLE				VARCHAR(500)
	, @AD_CONTENTS			VARCHAR(5000)	
	, @AD_URL				VARCHAR(200)
	, @AD_DATE				VARCHAR(10)
	, @REG_IP				VARCHAR(50)
	, @VIEW_STATUS			VARCHAR(1)

AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	INSERT INTO DBO.MW_AD_TB (
		  AD_CATEGORY
		, AD_TITLE
		, AD_CONTENTS		
		, AD_URL
		, AD_DATE
		, REG_IP
		, VIEW_STATUS
	) VALUES (  
		  @AD_CATEGORY
		, @AD_TITLE
		, @AD_CONTENTS		
		, @AD_URL
		, @AD_DATE
		, @REG_IP
		, @VIEW_STATUS
	)

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_AD_TB_SEL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고 - MW_AD_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고 SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_AD_TB_SEL_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_AD_TB_SEL_ADMIN_PROC 1, 20, '', '', 'P', '', '', ''
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_AD_TB_SEL_ADMIN_PROC]
	  @PAGE				INT
	, @PAGESIZE			INT
	, @SDATE			VARCHAR(10)
	, @EDATE			VARCHAR(10)
	, @SCHTYPE			VARCHAR(20) = ''
	, @SCHTEXT			VARCHAR(50) = ''
	, @SCHCATEGORY		VARCHAR(1)  = ''
	, @SCHSTATUS		VARCHAR(1)  = ''
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @SQL				NVARCHAR(4000)
	DECLARE @SQL_WHERE			NVARCHAR(1000)
	DECLARE @SQL_COMMON_PARAM	NVARCHAR(1000)
	DECLARE @SQL_PARAM			NVARCHAR(500)
	DECLARE @TOTCNT				INT = 0

	SET @SQL_COMMON_PARAM = N''
	SET @SQL_PARAM = N''
	SET @SQL_WHERE = N' WHERE DEL_ISYN=''N'' '

	/* 1. 검색 기간 선택 */
	IF (@SDATE <> '' AND @EDATE <> '')
	BEGIN		
		SET @EDATE = DATEADD(DAY, 15, @EDATE)
		SET @SQL_WHERE = @SQL_WHERE + N' AND REG_DT >= @SDATE AND REG_DT < @EDATE '
	END
	
	/* 2. 검색 조건 선택 */
	IF @SCHTYPE <> '' AND @SCHTEXT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE +
		CASE 
			WHEN @SCHTYPE = ''				THEN	N''
			WHEN @SCHTYPE = 'TITLE'		THEN	N' AND AD_TITLE LIKE ''%' + @SCHTEXT + '%'''
			WHEN @SCHTYPE = 'CONTENTS'	THEN	N' AND AD_CONTENTS LIKE ''%' + @SCHTEXT + '%'''
			--WHEN @SCHTYPE = 'AD_URL'	    THEN	N' AND AD_URL LIKE ''%' + @SCHTEXT + '%'''
		END
	END
	
	IF @SCHCATEGORY <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + N' AND AD_CATEGORY = ''' + @SCHCATEGORY + ''''
	END

	IF @SCHSTATUS <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + N' AND VIEW_STATUS = ''' + @SCHSTATUS + ''''
	END

	SET @SQL_COMMON_PARAM = N' @SDATE VARCHAR(10), @EDATE VARCHAR(10), @SCHTYPE VARCHAR(20), @SCHTEXT VARCHAR(50), @SCHCATEGORY VARCHAR(1), @SCHSTATUS VARCHAR(1)'

	/* 3. 검색 카운트 */
	SET @SQL = N' SELECT @TOTCNT = COUNT(IDX) '
	SET @SQL = @SQL + N' FROM DBO.MW_AD_TB WITH(NOLOCK)' + @SQL_WHERE
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT OUT'
	
	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHCATEGORY, @SCHSTATUS, @TOTCNT OUT

	SET @SQL = N'; WITH AD_LIST AS ('
	SET @SQL = @SQL + N' SELECT TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)'
	SET @SQL = @SQL + N'     ROW_NUMBER() OVER ( ORDER BY IDX DESC ) AS RNUM'
	SET @SQL = @SQL + N'  ,  IDX'
	SET @SQL = @SQL + N'  ,  AD_CATEGORY'
	SET @SQL = @SQL + N'  ,  AD_TITLE'
	SET @SQL = @SQL + N'  ,  AD_CONTENTS'	
	SET @SQL = @SQL + N'  ,  AD_URL'
	SET @SQL = @SQL + N'  ,  AD_DATE'
	SET @SQL = @SQL + N'  ,  REG_IP'
	SET @SQL = @SQL + N'  ,  REG_DT'
	SET @SQL = @SQL + N'  ,  UPD_IP'
	SET @SQL = @SQL + N'  ,  UPD_DT'
	SET @SQL = @SQL + N'  ,  VIEW_STATUS'
	SET @SQL = @SQL + N'  ,  DEL_ISYN'
	SET @SQL = @SQL + N' FROM DBO.MW_AD_TB PT WITH (NOLOCK)' + @SQL_WHERE
	SET @SQL = @SQL + N') '
	SET @SQL = @SQL + N' SELECT  TOTCNT = @TOTCNT'
	SET @SQL = @SQL + N'  ,  RNUM'
	SET @SQL = @SQL + N'  ,  IDX'
	SET @SQL = @SQL + N'  ,  AD_CATEGORY'
	SET @SQL = @SQL + N'  ,  AD_TITLE'
	SET @SQL = @SQL + N'  ,  AD_CONTENTS'	
	SET @SQL = @SQL + N'  ,  AD_URL'
	SET @SQL = @SQL + N'  ,  AD_DATE'
	SET @SQL = @SQL + N'  ,  REG_IP'
	SET @SQL = @SQL + N'  ,  REG_DT'
	SET @SQL = @SQL + N'  ,  UPD_IP'
	SET @SQL = @SQL + N'  ,  UPD_DT'
	SET @SQL = @SQL + N'  ,  VIEW_STATUS'
	SET @SQL = @SQL + N'  ,  DEL_ISYN'
	SET @SQL = @SQL + N' FROM AD_LIST A'
	SET @SQL = @SQL + N' WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY IDX DESC ;'
	
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT, @PAGE INT, @PAGESIZE INT'

	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM 
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHCATEGORY, @SCHSTATUS, @TOTCNT, @PAGE, @PAGESIZE

END
GO
/****** Object:  StoredProcedure [dbo].[MW_AD_TB_SEL_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고 - MW_AD_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고 SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_AD_TB_SEL_PROC TO MWINCUSER
' EXEC DBO.MW_AD_TB_SEL_PROC 1, 20, 'T'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_AD_TB_SEL_PROC]
	  @PAGE				INT
	, @PAGESIZE			INT
	, @SCHCATEGORY		VARCHAR(1)  = ''
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @TOTCNT				INT

	SELECT @TOTCNT = COUNT(*) 
	FROM dbo.MW_AD_TB WITH (NOLOCK)
	WHERE AD_CATEGORY = @SCHCATEGORY
		AND VIEW_STATUS = 'A' 
		AND DEL_ISYN = 'N'

	;WITH MW_AD_TB_LIST AS (
	SELECT TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)
           ROW_NUMBER() OVER ( ORDER BY IDX DESC ) AS RNUM
		,  IDX
		,  AD_CATEGORY
		,  AD_TITLE
		,  AD_CONTENTS	
		,  AD_URL
		,  AD_DATE
		,  REG_IP
		,  REG_DT
		,  UPD_IP
		,  UPD_DT
		,  VIEW_STATUS
		,  DEL_ISYN
	FROM dbo.MW_AD_TB WITH (NOLOCK)
	WHERE AD_CATEGORY = @SCHCATEGORY
		AND VIEW_STATUS = 'A' 
		AND DEL_ISYN = 'N'
	) 
	SELECT  TOTCNT = @TOTCNT
	,  RNUM
	,  IDX
	,  AD_CATEGORY
	,  AD_TITLE
	,  AD_CONTENTS	
	,  AD_URL
	,  AD_DATE
	,  REG_IP
	,  REG_DT
	,  UPD_IP
	,  UPD_DT
	,  VIEW_STATUS
	,  DEL_ISYN
	FROM MW_AD_TB_LIST A
	WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY IDX DESC 

END
GO
/****** Object:  StoredProcedure [dbo].[MW_AD_TB_STATUS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고 - MW_AD_TB STATUS 변경
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고(TV, CF, 인쇄물) 상태값 변경
' 주  의  사  항	: @@CHG_TYPE : D(삭제여부), S(게시상태값 변경)
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_AD_TB_STATUS_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_AD_TB_STATUS_ADMIN_PROC 'S', 'A', '1,2', '111.222.333.444'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_AD_TB_STATUS_ADMIN_PROC]
	  @AD_CATEGORY		VARCHAR(1)
    , @CHG_TYPE			VARCHAR(1)
	, @CHG_STATUS		VARCHAR(1)
	, @STRIDX			VARCHAR(1000)
	, @UPD_IP           VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	IF @CHG_TYPE = 'S' -- 게시상태
	BEGIN
		UPDATE DBO.MW_AD_TB
		SET VIEW_STATUS = @CHG_STATUS
		  , UPD_IP   = @UPD_IP
		  , UPD_DT   = GETDATE()
		WHERE AD_CATEGORY = @AD_CATEGORY AND EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_AD_TB.IDX = ST.IDX)
	END
	ELSE IF @CHG_TYPE = 'D' -- 삭제여부
	BEGIN
		UPDATE DBO.MW_AD_TB
		SET DEL_ISYN = @CHG_STATUS
		  , UPD_IP   = @UPD_IP
		  , UPD_DT   = GETDATE()
		WHERE AD_CATEGORY = @AD_CATEGORY AND EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_AD_TB.IDX = ST.IDX)
	END

	RETURN @@ERROR
	

END
GO
/****** Object:  StoredProcedure [dbo].[MW_AD_TB_UPD_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고 - MW_AD_TB UPDATE
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고(TV, CF, 인쇄물) 수정
' 주  의  사  항	: @AD_CATEGORY : T(TV CF), R(라디오 CF), P(인쇄물) 
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_AD_TB_UPD_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_AD_TB_UPD_ADMIN_PROC 1, 'T', 'A', 'A', '광고 제목 1 수정 테스트', '광고 내용 1 수정 테스트', 'https://www.youtube.com/v/vWZPRjGFsNs?wmode=transparent&autoplay=1&version=1&loop=1&ytplayer=1&fs=1&hd=1', 'AD.JPG', '2015-03-01', '111.222.333.444', 'W'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_AD_TB_UPD_ADMIN_PROC]
      @IDX					INT
	, @AD_CATEGORY			VARCHAR(1)
	, @AD_TITLE				VARCHAR(500)
	, @AD_CONTENTS			VARCHAR(5000)	
	, @AD_URL				VARCHAR(200)
	, @AD_DATE				VARCHAR(10)
	, @UPD_IP				VARCHAR(50)
	, @VIEW_STATUS			VARCHAR(1) = 'W'
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	UPDATE DBO.MW_AD_TB
	SET  AD_TITLE = @AD_TITLE
	   , AD_CONTENTS = @AD_CONTENTS	   
	   , AD_URL = @AD_URL
	   , AD_DATE = @AD_DATE
	   , UPD_IP = @UPD_IP
	   , UPD_DT = GETDATE()
	   , VIEW_STATUS = @VIEW_STATUS
	WHERE IDX = @IDX AND AD_CATEGORY = @AD_CATEGORY

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_INFOPRINT_TB_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 인쇄 & 인포그래픽 - MW_INFOPRINT_TB 상세
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 인쇄 & 인포그래픽 상세
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_INFOPRINT_TB_DETAIL_PROC TO MWINCUSER
' EXEC DBO.MW_INFOPRINT_TB_DETAIL_PROC 1
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_INFOPRINT_TB_DETAIL_PROC]
	  @IDX			INT
	, @SCHCATEGORY	VARCHAR(1)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	DECLARE @PREV_IDX	INT
	DECLARE @NEXT_IDX   INT
	DECLARE @PREV_TITLE	VARCHAR(500)
	DECLARE @NEXT_TITLE	VARCHAR(500)

	SELECT TOP 1 @PREV_IDX = IDX, @PREV_TITLE = INFO_TITLE
	FROM DBO.MW_INFOPRINT_TB WITH (NOLOCK) 
	WHERE IDX < @IDX AND VIEW_STATUS = 'A' AND DEL_ISYN = 'N' AND INFO_CATEGORY = @SCHCATEGORY ORDER BY IDX DESC

	SELECT TOP 1 @NEXT_IDX = IDX, @NEXT_TITLE = INFO_TITLE 
	FROM DBO.MW_INFOPRINT_TB WITH (NOLOCK) 
	WHERE IDX > @IDX AND VIEW_STATUS = 'A' AND DEL_ISYN = 'N' AND INFO_CATEGORY = @SCHCATEGORY ORDER BY IDX ASC
	
	SELECT    IDX
			, INFO_CATEGORY
			, INFO_CORP
			, INFO_TITLE
			, INFO_TEXT
			, INFO_URL
			, INFO_IMG
			, INFO_DATE
			, REG_IP
			, REG_DT
			, UPD_IP
			, UPD_DT
			, ISNULL(@PREV_IDX, 0)
			, ISNULL(@PREV_TITLE, '')
			, ISNULL(@NEXT_IDX, 0)
			, ISNULL(@NEXT_TITLE, '')	
	FROM DBO.MW_INFOPRINT_TB WITH (NOLOCK)
	WHERE IDX = @IDX AND DEL_ISYN = 'N'

END
GO
/****** Object:  StoredProcedure [dbo].[MW_INFOPRINT_TB_INS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고 - MW_INFOPRINT_TB INSERT
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고(인쇄물 & 인포그래픽) 등록
' 주  의  사  항	: @INFO_CATEGORY     : I(인포그래픽), P(인쇄물) 
                      @INFO_CORP         : 
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_INFOPRINT_TB_INS_ADMIN_PROC TO MWINCUSER
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_INFOPRINT_TB_INS_ADMIN_PROC]
	  @INFO_CATEGORY		VARCHAR(1)
	, @INFO_CORP			VARCHAR(1)
	, @INFO_TITLE			VARCHAR(500)
	, @INFO_TEXT			VARCHAR(1000)
	, @INFO_URL				VARCHAR(1000)
	, @INFO_IMG				VARCHAR(100)
	, @INFO_DATE			VARCHAR(10)
	, @REG_IP				VARCHAR(50)
	, @VIEW_STATUS			VARCHAR(1)

AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	INSERT INTO DBO.MW_INFOPRINT_TB (
		  INFO_CATEGORY
		, INFO_CORP
		, INFO_TITLE
		, INFO_TEXT
		, INFO_URL
		, INFO_IMG
		, INFO_DATE
		, REG_IP
		, VIEW_STATUS
	) VALUES (  
		  @INFO_CATEGORY
		, @INFO_CORP
		, @INFO_TITLE
		, @INFO_TEXT
		, @INFO_URL
		, @INFO_IMG
		, @INFO_DATE
		, @REG_IP
		, @VIEW_STATUS
	)

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_INFOPRINT_TB_SEL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고 (인쇄물 & 인포그래픽) - MW_INFOPRINT_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고 (인쇄물 & 인포그래픽) SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_INFOPRINT_TB_SEL_ADMIN_PROC TO MWINCUSER
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_INFOPRINT_TB_SEL_ADMIN_PROC]
	  @PAGE				INT
	, @PAGESIZE			INT
	, @SDATE			VARCHAR(10)
	, @EDATE			VARCHAR(10)
	, @SCHTYPE			VARCHAR(20) = ''
	, @SCHTEXT			VARCHAR(50) = ''
	, @SCHCATEGORY		VARCHAR(1)  = ''
	, @INFO_CORP		VARCHAR(1)  = ''
	, @SCHSTATUS		VARCHAR(1)  = ''
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @SQL				NVARCHAR(4000)
	DECLARE @SQL_WHERE			NVARCHAR(1000)
	DECLARE @SQL_COMMON_PARAM	NVARCHAR(1000)
	DECLARE @SQL_PARAM			NVARCHAR(500)
	DECLARE @TOTCNT				INT = 0

	SET @SQL_COMMON_PARAM = N''
	SET @SQL_PARAM = N''
	SET @SQL_WHERE = N' WHERE DEL_ISYN=''N'' '

	/* 1. 검색 기간 선택 */
	IF (@SDATE <> '' AND @EDATE <> '')
	BEGIN		
		SET @EDATE = DATEADD(DAY, 15, @EDATE)
		SET @SQL_WHERE = @SQL_WHERE + N' AND REG_DT >= @SDATE AND REG_DT < @EDATE '
	END
	
	/* 2. 검색 조건 선택 */
	IF @SCHTYPE <> '' AND @SCHTEXT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE +
		CASE 
			WHEN @SCHTYPE = ''				THEN	N''
			WHEN @SCHTYPE = 'TITLE'		THEN	N' AND INFO_TITLE LIKE ''%' + @SCHTEXT + '%'''
		END
	END
	
	IF @SCHCATEGORY <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + N' AND INFO_CATEGORY = ''' + @SCHCATEGORY + ''''
	END

	IF @INFO_CORP <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + N' AND INFO_CORP = ''' + @INFO_CORP + ''''
	END

	IF @SCHSTATUS <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + N' AND VIEW_STATUS = ''' + @SCHSTATUS + ''''
	END

	SET @SQL_COMMON_PARAM = N' @SDATE VARCHAR(10), @EDATE VARCHAR(10), @SCHTYPE VARCHAR(20), @SCHTEXT VARCHAR(50), @SCHCATEGORY VARCHAR(1), @INFO_CORP VARCHAR(1), @SCHSTATUS VARCHAR(1)'

	/* 3. 검색 카운트 */
	SET @SQL = N' SELECT @TOTCNT = COUNT(IDX) '
	SET @SQL = @SQL + N' FROM DBO.MW_INFOPRINT_TB WITH(NOLOCK)' + @SQL_WHERE
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT OUT'
	
	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHCATEGORY, @INFO_CORP,@SCHSTATUS, @TOTCNT OUT

	SET @SQL = N'; WITH INFO_LIST AS ('
	SET @SQL = @SQL + N' SELECT TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)'
	SET @SQL = @SQL + N'     ROW_NUMBER() OVER ( ORDER BY IDX DESC ) AS RNUM'
	SET @SQL = @SQL + N'  ,  IDX'
	SET @SQL = @SQL + N'  ,  INFO_CATEGORY'
	SET @SQL = @SQL + N'  ,  INFO_CORP'
	SET @SQL = @SQL + N'  ,  INFO_TITLE'
	SET @SQL = @SQL + N'  ,  INFO_TEXT'
	SET @SQL = @SQL + N'  ,  INFO_URL'
	SET @SQL = @SQL + N'  ,  INFO_IMG'
	SET @SQL = @SQL + N'  ,  INFO_DATE'
	SET @SQL = @SQL + N'  ,  REG_IP'
	SET @SQL = @SQL + N'  ,  REG_DT'
	SET @SQL = @SQL + N'  ,  UPD_IP'
	SET @SQL = @SQL + N'  ,  UPD_DT'
	SET @SQL = @SQL + N'  ,  VIEW_STATUS'
	SET @SQL = @SQL + N'  ,  DEL_ISYN'
	SET @SQL = @SQL + N' FROM DBO.MW_INFOPRINT_TB PT WITH (NOLOCK)' + @SQL_WHERE
	SET @SQL = @SQL + N') '
	SET @SQL = @SQL + N' SELECT  TOTCNT = @TOTCNT'
	SET @SQL = @SQL + N'  ,  RNUM'
	SET @SQL = @SQL + N'  ,  IDX'
	SET @SQL = @SQL + N'  ,  INFO_CATEGORY'
	SET @SQL = @SQL + N'  ,  INFO_CORP'
	SET @SQL = @SQL + N'  ,  INFO_TITLE'
	SET @SQL = @SQL + N'  ,  INFO_TEXT'
	SET @SQL = @SQL + N'  ,  INFO_URL'
	SET @SQL = @SQL + N'  ,  INFO_IMG'
	SET @SQL = @SQL + N'  ,  INFO_DATE'
	SET @SQL = @SQL + N'  ,  REG_IP'
	SET @SQL = @SQL + N'  ,  REG_DT'
	SET @SQL = @SQL + N'  ,  UPD_IP'
	SET @SQL = @SQL + N'  ,  UPD_DT'
	SET @SQL = @SQL + N'  ,  VIEW_STATUS'
	SET @SQL = @SQL + N'  ,  DEL_ISYN'
	SET @SQL = @SQL + N' FROM INFO_LIST A'
	SET @SQL = @SQL + N' WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY IDX DESC ;'
	
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT, @PAGE INT, @PAGESIZE INT'

	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM 
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHCATEGORY, @INFO_CORP, @SCHSTATUS, @TOTCNT, @PAGE, @PAGESIZE

END
GO
/****** Object:  StoredProcedure [dbo].[MW_INFOPRINT_TB_SEL_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고(인쇄물&인포그래픽) - MW_INFOPRINT_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고(인쇄물&인포그래픽) SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_INFOPRINT_TB_SEL_PROC TO MWINCUSER
' EXEC MW_INFOPRINT_TB_SEL_PROC 'I', '', 0, 0
' EXEC MW_INFOPRINT_TB_SEL_PROC 'P', '', 1, 10
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_INFOPRINT_TB_SEL_PROC]
	   @SCHCATEGORY		VARCHAR(1)  = ''	 
	 , @SCHCORP 		VARCHAR(1)  = ''
	 , @PAGE		    INT 
	 , @PAGESIZE	    INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	DECLARE @TOTCNT				INT

	IF @SCHCATEGORY = 'I'
	BEGIN
		SELECT IDX
		     , INFO_CORP
			 , INFO_IMG
			 , INFO_TITLE 
		FROM DBO.MW_INFOPRINT_TB WITH (NOLOCK)
		WHERE VIEW_STATUS='A' AND DEL_ISYN='N' AND INFO_CATEGORY=@SCHCATEGORY
		ORDER BY IDX DESC
	END

	ELSE IF @SCHCATEGORY = 'P'
	BEGIN
		SELECT @TOTCNT = COUNT(*) 
		FROM dbo.MW_INFOPRINT_TB WITH (NOLOCK)
		WHERE VIEW_STATUS='A' AND DEL_ISYN='N' AND INFO_CATEGORY=@SCHCATEGORY AND INFO_CORP = @SCHCORP

		;WITH MW_INFOPRINT_TB_LIST AS (
		SELECT TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)
		  ROW_NUMBER() OVER ( ORDER BY IDX DESC ) AS RNUM
		, IDX
		, INFO_CORP
		, INFO_IMG
		, INFO_TITLE
		FROM dbo.MW_INFOPRINT_TB WITH (NOLOCK)
		WHERE VIEW_STATUS='A' AND DEL_ISYN='N' AND INFO_CATEGORY=@SCHCATEGORY AND INFO_CORP = @SCHCORP
		) 
		SELECT  TOTCNT = @TOTCNT
		, IDX
		, INFO_CORP
		, INFO_IMG
		, INFO_TITLE
		FROM MW_INFOPRINT_TB_LIST A
		WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY IDX DESC ;
	END

END
GO
/****** Object:  StoredProcedure [dbo].[MW_INFOPRINT_TB_STATUS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고(인쇄물 & 인포그래픽) - MW_INFOPRINT_TB STATUS 변경
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고인쇄물 & 인포그래픽) 상태값 변경
' 주  의  사  항	: @@CHG_TYPE : D(삭제여부), S(게시상태값 변경)
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_INFOPRINT_TB_STATUS_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_INFOPRINT_TB_STATUS_ADMIN_PROC 'S', 'A', '1,2', '111.222.333.444'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_INFOPRINT_TB_STATUS_ADMIN_PROC]
	  @INFO_CATEGORY		VARCHAR(1)
    , @CHG_TYPE			VARCHAR(1)
	, @CHG_STATUS		VARCHAR(1)
	, @STRIDX			VARCHAR(1000)
	, @UPD_IP           VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	IF @CHG_TYPE = 'S' -- 게시상태
	BEGIN
		UPDATE DBO.MW_INFOPRINT_TB
		SET VIEW_STATUS = @CHG_STATUS
		  , UPD_IP   = @UPD_IP
		  , UPD_DT   = GETDATE()
		WHERE INFO_CATEGORY = @INFO_CATEGORY AND EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_INFOPRINT_TB.IDX = ST.IDX)
	END
	ELSE IF @CHG_TYPE = 'D' -- 삭제여부
	BEGIN
		UPDATE DBO.MW_INFOPRINT_TB
		SET DEL_ISYN = @CHG_STATUS
		  , UPD_IP   = @UPD_IP
		  , UPD_DT   = GETDATE()
		WHERE INFO_CATEGORY = @INFO_CATEGORY AND EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_INFOPRINT_TB.IDX = ST.IDX)
	END

	RETURN @@ERROR
	

END
GO
/****** Object:  StoredProcedure [dbo].[MW_INFOPRINT_TB_UPD_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 광고(인쇄물 & 인포그래픽) - MW_INFOPRINT_TB UPDATE
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 광고(인쇄물 & 인포그래픽) 수정
' 주  의  사  항	: @INFO_CATEGORY : I(인포그래픽), P(인쇄물) 
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_INFOPRINT_TB_UPD_ADMIN_PROC TO MWINCUSER

******************************************************************************/
CREATE PROCEDURE [dbo].[MW_INFOPRINT_TB_UPD_ADMIN_PROC]
      @IDX					INT
	, @INFO_CATEGORY		VARCHAR(1)
	, @INFO_CORP			VARCHAR(1)
	, @INFO_TITLE			VARCHAR(500)
	, @INFO_TEXT			VARCHAR(1000)
	, @INFO_URL				VARCHAR(1000)
	, @INFO_IMG				VARCHAR(100)
	, @INFO_DATE			VARCHAR(10)
	, @UPD_IP				VARCHAR(50)
	, @VIEW_STATUS			VARCHAR(1) = 'W'
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	UPDATE DBO.MW_INFOPRINT_TB
	SET  INFO_CORP = @INFO_CORP
	   , INFO_TITLE = @INFO_TITLE
	   , INFO_TEXT = @INFO_TEXT
	   , INFO_URL = @INFO_URL
	   , INFO_IMG = @INFO_IMG
	   , INFO_DATE = @INFO_DATE
	   , UPD_IP = @UPD_IP
	   , UPD_DT = GETDATE()
	   , VIEW_STATUS = @VIEW_STATUS
	WHERE IDX = @IDX AND INFO_CATEGORY = @INFO_CATEGORY

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_NEWS_TB_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 소식 - MW_NEWS_TB 상세
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 소식 상세
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_NEWS_TB_DETAIL_PROC TO MWINCUSER
' EXEC DBO.MW_NEWS_TB_DETAIL_PROC 1
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_NEWS_TB_DETAIL_PROC]
	  @IDX			INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	DECLARE @PREV_IDX	INT
	DECLARE @NEXT_IDX   INT
	DECLARE @PREV_TITLE	VARCHAR(500)
	DECLARE @NEXT_TITLE	VARCHAR(500)

	SELECT TOP 1 @PREV_IDX = IDX, @PREV_TITLE = NW_TITLE
	FROM DBO.MW_NEWS_TB WITH (NOLOCK) 
	WHERE IDX < @IDX AND DEL_ISYN = 'N' AND VIEW_STATUS = 'A' ORDER BY IDX DESC

	SELECT TOP 1 @NEXT_IDX = IDX, @NEXT_TITLE = NW_TITLE 
	FROM DBO.MW_NEWS_TB WITH (NOLOCK) 
	WHERE IDX > @IDX AND DEL_ISYN = 'N' AND VIEW_STATUS = 'A' ORDER BY IDX ASC

	SELECT TOP 1  IDX
				, NW_TITLE
				, NW_CONTENTS
				, NW_ATTATCH_FILE
				, REG_IP
				, REG_DT
				, UPD_IP
				, UPD_DT
				, VIEW_STATUS
				, ISNULL(@PREV_IDX,0)
				, ISNULL(@PREV_TITLE,'')
				, ISNULL(@NEXT_IDX,0)
				, ISNULL(@NEXT_TITLE,'')
				, DEL_ISYN
	FROM DBO.MW_NEWS_TB WITH (NOLOCK)
	WHERE IDX = @IDX AND DEL_ISYN = 'N'

END
GO
/****** Object:  StoredProcedure [dbo].[MW_NEWS_TB_INS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 소식 - MW_NEWS_TB INSERT
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 소식 등록
' 주  의  사  항	: 
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_NEWS_TB_INS_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_NEWS_TB_INS_ADMIN_PROC '미디어윌 소식 제목 1 테스트', '미디어윌 소식 요약 1 테스트', '미디어윌 소식 내용 1 테스트', 'NEWS.JPG', '111.222.333.444'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_NEWS_TB_INS_ADMIN_PROC]
	  @NW_TITLE			VARCHAR(500)
	, @NW_CONTENTS		VARCHAR(4000)
	, @NW_ATTATCH_FILE	VARCHAR(100)
	, @REG_IP			VARCHAR(50)
	, @VIEW_STATUS		VARCHAR(1)

AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	INSERT INTO DBO.MW_NEWS_TB (
		  NW_TITLE
		, NW_CONTENTS
		, NW_ATTATCH_FILE
		, REG_IP
		, VIEW_STATUS
	) VALUES (  
		  @NW_TITLE
		, @NW_CONTENTS
		, @NW_ATTATCH_FILE
		, @REG_IP
		, @VIEW_STATUS
	)

	RETURN @@ERROR

END

GO
/****** Object:  StoredProcedure [dbo].[MW_NEWS_TB_SEL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 소식 - MW_NEWS_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 소식 SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_NEWS_TB_SEL_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_NEWS_TB_SEL_ADMIN_PROC 1, 20, '', '', '', '', ''
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_NEWS_TB_SEL_ADMIN_PROC]
	  @PAGE				INT
	, @PAGESIZE			INT
	, @SDATE			VARCHAR(10)
	, @EDATE			VARCHAR(10)
	, @SCHTYPE			VARCHAR(20) = ''
	, @SCHTEXT			VARCHAR(50) = ''
	, @SCHSTATUS		VARCHAR(1)  = ''
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @SQL				NVARCHAR(4000)
	DECLARE @SQL_WHERE			NVARCHAR(1000)
	DECLARE @SQL_COMMON_PARAM	NVARCHAR(1000)
	DECLARE @SQL_PARAM			NVARCHAR(500)
	DECLARE @TOTCNT				INT = 0

	SET @SQL_COMMON_PARAM = N''
	SET @SQL_PARAM = N''
	SET @SQL_WHERE = N' WHERE DEL_ISYN=''N'' '

	/* 1. 검색 기간 선택 */
	IF (@SDATE <> '' AND @EDATE <> '')
	BEGIN		
		SET @EDATE = DATEADD(DAY, 15, @EDATE)
		SET @SQL_WHERE = @SQL_WHERE + N' AND REG_DT >= @SDATE AND REG_DT < @EDATE '
	END
	
	/* 2. 검색 조건 선택 */
	IF @SCHTYPE <> '' AND @SCHTEXT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE +
		CASE 
			WHEN @SCHTYPE = ''					THEN	N''
			WHEN @SCHTYPE = 'TITLE'			THEN	N' AND NW_TITLE LIKE ''%' + @SCHTEXT + '%'''
			WHEN @SCHTYPE = 'CONTENTS'		THEN	N' AND NW_CONTENTS LIKE ''%' + @SCHTEXT + '%'''
		END
	END
	
	IF @SCHSTATUS <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + N' AND VIEW_STATUS = ''' + @SCHSTATUS + ''''
	END

	SET @SQL_COMMON_PARAM = N' @SDATE VARCHAR(10), @EDATE VARCHAR(10), @SCHTYPE VARCHAR(20), @SCHTEXT VARCHAR(50), @SCHSTATUS VARCHAR(1)'

	/* 3. 검색 카운트 */
	SET @SQL = N' SELECT @TOTCNT = COUNT(IDX) '
	SET @SQL = @SQL + N' FROM DBO.MW_NEWS_TB WITH(NOLOCK)' + @SQL_WHERE
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT OUT'
	
	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHSTATUS, @TOTCNT OUT

	SET @SQL = N'; WITH NEWS_LIST AS ('
	SET @SQL = @SQL + N' SELECT TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)'
	SET @SQL = @SQL + N'    ROW_NUMBER() OVER ( ORDER BY IDX DESC ) AS RNUM'
	SET @SQL = @SQL + N'  , IDX'
	SET @SQL = @SQL + N'  , NW_TITLE'
	SET @SQL = @SQL + N'  , NW_CONTENTS'
	SET @SQL = @SQL + N'  , NW_ATTATCH_FILE'
	SET @SQL = @SQL + N'  , REG_IP'
	SET @SQL = @SQL + N'  , REG_DT'
	SET @SQL = @SQL + N'  , UPD_IP'
	SET @SQL = @SQL + N'  , UPD_DT'
	SET @SQL = @SQL + N'  , VIEW_STATUS'
	SET @SQL = @SQL + N'  , DEL_ISYN'
	SET @SQL = @SQL + N' FROM DBO.MW_NEWS_TB PT WITH (NOLOCK)' + @SQL_WHERE
	SET @SQL = @SQL + N') '
	SET @SQL = @SQL + N' SELECT  TOTCNT = @TOTCNT'
	SET @SQL = @SQL + N'  , RNUM'
	SET @SQL = @SQL + N'  , IDX'
	SET @SQL = @SQL + N'  , NW_TITLE'
	SET @SQL = @SQL + N'  , NW_CONTENTS'
	SET @SQL = @SQL + N'  , NW_ATTATCH_FILE'	
	SET @SQL = @SQL + N'  , REG_IP'
	SET @SQL = @SQL + N'  , REG_DT'
	SET @SQL = @SQL + N'  , UPD_IP'
	SET @SQL = @SQL + N'  , UPD_DT'
	SET @SQL = @SQL + N'  , VIEW_STATUS'
	SET @SQL = @SQL + N'  , DEL_ISYN'
	SET @SQL = @SQL + N' FROM NEWS_LIST A'
	SET @SQL = @SQL + N' WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY IDX DESC ;'
	
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT, @PAGE INT, @PAGESIZE INT'

	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM 
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHSTATUS, @TOTCNT, @PAGE, @PAGESIZE

END
GO
/****** Object:  StoredProcedure [dbo].[MW_NEWS_TB_SEL_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 소식 - MW_NEWS_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 소식 SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_NEWS_TB_SEL_PROC TO MWINCUSER
' EXEC DBO.MW_NEWS_TB_SEL_PROC 1, 20
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_NEWS_TB_SEL_PROC]
	  @PAGE				INT
	, @PAGESIZE			INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @TOTCNT				INT

	SELECT @TOTCNT = COUNT(*) 
	FROM dbo.MW_NEWS_TB WITH (NOLOCK)
	WHERE   VIEW_STATUS = 'A' 
		AND DEL_ISYN = 'N'

	;WITH MW_NEWS_TB_LIST AS (
	SELECT  TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)
           	ROW_NUMBER() OVER ( ORDER BY IDX DESC ) AS RNUM
		  , IDX
		  , NW_TITLE
		  , NW_CONTENTS
		  , NW_ATTATCH_FILE
		  , REG_IP
		  , REG_DT
		  , UPD_IP
		  , UPD_DT
		  , VIEW_STATUS
		  , DEL_ISYN
	FROM dbo.MW_NEWS_TB WITH (NOLOCK)
	WHERE   VIEW_STATUS = 'A' 
		AND DEL_ISYN = 'N'
	) 
	SELECT  TOTCNT = @TOTCNT
		  , RNUM
		  , IDX
		  , NW_TITLE
		  , NW_CONTENTS
		  , NW_ATTATCH_FILE
		  , REG_IP
		  , REG_DT
		  , UPD_IP
		  , UPD_DT
		  , VIEW_STATUS
		  , DEL_ISYN
	FROM MW_NEWS_TB_LIST A
	WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY IDX DESC 

END
GO
/****** Object:  StoredProcedure [dbo].[MW_NEWS_TB_STATUS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 소식 - MW_NEWS_TB STATUS 변경
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 소식 상태값 변경
' 주  의  사  항	: 
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_NEWS_TB_STATUS_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_NEWS_TB_STATUS_ADMIN_PROC 1, 'S', 'N'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_NEWS_TB_STATUS_ADMIN_PROC]
      @CHG_TYPE			VARCHAR(1)
	, @CHG_STATUS		VARCHAR(1)
	, @STRIDX			VARCHAR(1000)
	, @UPD_IP           VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	IF @CHG_TYPE = 'S' -- 게시상태
	BEGIN
		UPDATE DBO.MW_NEWS_TB
		SET VIEW_STATUS = @CHG_STATUS
		  , UPD_IP   = @UPD_IP
		  , UPD_DT   = GETDATE()
		WHERE EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_NEWS_TB.IDX = ST.IDX)
	END
	ELSE IF @CHG_TYPE = 'D' -- 삭제여부
	BEGIN
		UPDATE DBO.MW_NEWS_TB
		SET DEL_ISYN = @CHG_STATUS
		  , UPD_IP   = @UPD_IP
		  , UPD_DT   = GETDATE()
		WHERE EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_NEWS_TB.IDX = ST.IDX)
	END

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_NEWS_TB_UPD_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 소식 - MW_NEWS_TB UPDATE
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 소식 수정
' 주  의  사  항	: 
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_NEWS_TB_UPD_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_NEWS_TB_UPD_ADMIN_PROC 1, '미디어윌 소식 제목 수정 1 테스트', '미디어윌 소식 요약 수정 1 테스트', '미디어윌 소식 내용 수정 1 테스트', 'NEWS.JPG', '111.222.333.444'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_NEWS_TB_UPD_ADMIN_PROC]
      @IDX				INT
	, @NW_TITLE			VARCHAR(500)
	, @NW_CONTENTS		VARCHAR(4000)
	, @NW_ATTATCH_FILE	VARCHAR(100)
	, @UPD_IP			VARCHAR(50)
	, @VIEW_STATUS		VARCHAR(1)

AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	UPDATE DBO.MW_NEWS_TB
	SET  NW_TITLE = @NW_TITLE
	   , NW_CONTENTS = @NW_CONTENTS
	   , NW_ATTATCH_FILE = @NW_ATTATCH_FILE	   
	   , UPD_IP = @UPD_IP
	   , UPD_DT = GETDATE()
	   , VIEW_STATUS = @VIEW_STATUS
	WHERE IDX = @IDX

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PRESS_TB_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 언론보도 - MW_PRESS_TB 상세
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 언론보도 상세
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PRESS_TB_DETAIL_PROC TO MWINCUSER
' EXEC DBO.MW_PRESS_TB_DETAIL_PROC 1
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PRESS_TB_DETAIL_PROC]
	  @IDX			INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	DECLARE @PREV_IDX	INT
	DECLARE @NEXT_IDX   INT
	DECLARE @PREV_TITLE	VARCHAR(500)
	DECLARE @NEXT_TITLE	VARCHAR(500)

	SELECT TOP 1 @PREV_IDX = IDX, @PREV_TITLE = PR_TITLE
	FROM DBO.MW_PRESS_TB WITH (NOLOCK) 
	WHERE IDX < @IDX AND VIEW_STATUS = 'A' AND DEL_ISYN = 'N' ORDER BY IDX DESC

	SELECT TOP 1 @NEXT_IDX = IDX, @NEXT_TITLE = PR_TITLE 
	FROM DBO.MW_PRESS_TB WITH (NOLOCK) 
	WHERE IDX > @IDX AND VIEW_STATUS = 'A' AND DEL_ISYN = 'N' ORDER BY IDX ASC
	
	SELECT TOP 1 IDX
			, PR_TITLE
			, PR_CONTENTS
			, PR_IMG
			, PR_DATE
			, PR_ARTICLE_ORG
			, PR_ARTICLE_URL			
			, REG_IP
			, REG_DT
			, UPD_IP
			, UPD_DT
			, VIEW_STATUS
			, ISNULL(@PREV_IDX,0)
			, ISNULL(@PREV_TITLE,'')
			, ISNULL(@NEXT_IDX,0)
			, ISNULL(@NEXT_TITLE,'')
			, DEL_ISYN
	FROM DBO.MW_PRESS_TB WITH (NOLOCK)
	WHERE IDX = @IDX AND DEL_ISYN = 'N'

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PRESS_TB_INS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 언론보도 - MW_PRESS_TB INSERT
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 언론보도 등록
' 주  의  사  항	: 
' 사  용  소  스 	:
' 예          제	:
' EXEC DBO.MW_PRESS_TB_INS_ADMIN_PROC '미디어윌 언론보도 제목 1 테스트',  '미디어윌 언론보도 내용 1 테스트', 'PRESS.JPG', '2016-01-01', '원기사전문요약', '원기사전문 링크', '111.222.333.444', 'A'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PRESS_TB_INS_ADMIN_PROC]
	  @PR_TITLE			VARCHAR(500)
	, @PR_CONTENTS		VARCHAR(MAX)
	, @PR_IMG			VARCHAR(100)
	, @PR_DATE			VARCHAR(10)
	, @PR_ARTICLE_ORG	VARCHAR(500)
	, @PR_ARTICLE_URL	VARCHAR(500)	
	, @REG_IP			VARCHAR(50)
	, @VIEW_STATUS      VARCHAR(1)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	INSERT INTO DBO.MW_PRESS_TB (
		  PR_TITLE
		, PR_CONTENTS
		, PR_IMG
		, PR_DATE
		, PR_ARTICLE_ORG
		, PR_ARTICLE_URL	
		, VIEW_STATUS	
		, REG_IP
	) VALUES (  
		  @PR_TITLE
		, @PR_CONTENTS
		, @PR_IMG
		, @PR_DATE
		, @PR_ARTICLE_ORG
		, @PR_ARTICLE_URL
		, @VIEW_STATUS		
		, @REG_IP
	)

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PRESS_TB_SEL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 언론보도 - MW_PRESS_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 언론보도 SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PRESS_TB_SEL_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PRESS_TB_SEL_ADMIN_PROC 1, 20, '2015-01-01', '2016-03-08', '', '', ''
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PRESS_TB_SEL_ADMIN_PROC]
	  @PAGE				INT
	, @PAGESIZE			INT
	, @SDATE			VARCHAR(10)
	, @EDATE			VARCHAR(10)
	, @SCHTYPE			VARCHAR(20) = ''
	, @SCHTEXT			VARCHAR(50) = ''
	, @SCHSTATUS		VARCHAR(1)  = ''
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @SQL				NVARCHAR(4000)
	DECLARE @SQL_WHERE			NVARCHAR(1000)
	DECLARE @SQL_COMMON_PARAM	NVARCHAR(1000)
	DECLARE @SQL_PARAM			NVARCHAR(500)
	DECLARE @TOTCNT				INT = 0

	SET @SQL_COMMON_PARAM = N''
	SET @SQL_PARAM = N''
	SET @SQL_WHERE = N' WHERE DEL_ISYN=''N'' '

	/* 1. 검색 기간 선택 */
	IF (@SDATE <> '' AND @EDATE <> '')
	BEGIN		
		SET @EDATE = DATEADD(DAY, 15, @EDATE)
		SET @SQL_WHERE = @SQL_WHERE + N' AND REG_DT >= @SDATE AND REG_DT < @EDATE '
	END
	
	/* 2. 검색 조건 선택 */
	IF @SCHTYPE <> '' AND @SCHTEXT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE +
		CASE 
			WHEN @SCHTYPE = ''					THEN	N''
			WHEN @SCHTYPE = 'TITLE'			THEN	N' AND PR_TITLE LIKE ''%' + @SCHTEXT + '%'''
			WHEN @SCHTYPE = 'CONTENTS'		THEN	N' AND PR_CONTENTS LIKE ''%' + @SCHTEXT + '%'''
		END
	END
	
	IF @SCHSTATUS <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + N' AND VIEW_STATUS = ''' + @SCHSTATUS + ''''
	END

	SET @SQL_COMMON_PARAM = N' @SDATE VARCHAR(10), @EDATE VARCHAR(10), @SCHTYPE VARCHAR(20), @SCHTEXT VARCHAR(50), @SCHSTATUS VARCHAR(1)'

	/* 3. 검색 카운트 */
	SET @SQL = N' SELECT @TOTCNT = COUNT(IDX) '
	SET @SQL = @SQL + N' FROM DBO.MW_PRESS_TB WITH(NOLOCK)' + @SQL_WHERE
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT OUT'
	
	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHSTATUS, @TOTCNT OUT

	SET @SQL = N'; WITH NEWS_LIST AS ('
	SET @SQL = @SQL + N' SELECT TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)'
	SET @SQL = @SQL + N'    ROW_NUMBER() OVER ( ORDER BY IDX DESC ) AS RNUM'
	SET @SQL = @SQL + N'  , IDX'
	SET @SQL = @SQL + N'  , PR_TITLE'
	SET @SQL = @SQL + N'  , PR_CONTENTS'
	SET @SQL = @SQL + N'  , PR_IMG'
	SET @SQL = @SQL + N'  , PR_DATE'
	SET @SQL = @SQL + N'  , PR_ARTICLE_ORG'
	SET @SQL = @SQL + N'  , PR_ARTICLE_URL'
	SET @SQL = @SQL + N'  , REG_IP'
	SET @SQL = @SQL + N'  , REG_DT'
	SET @SQL = @SQL + N'  , UPD_IP'
	SET @SQL = @SQL + N'  , UPD_DT'
	SET @SQL = @SQL + N'  , VIEW_STATUS'
	SET @SQL = @SQL + N'  , DEL_ISYN'
	SET @SQL = @SQL + N' FROM DBO.MW_PRESS_TB PT WITH (NOLOCK)' + @SQL_WHERE
	SET @SQL = @SQL + N') '
	SET @SQL = @SQL + N' SELECT  TOTCNT = @TOTCNT'
	SET @SQL = @SQL + N'  , RNUM'
	SET @SQL = @SQL + N'  , IDX'
	SET @SQL = @SQL + N'  , PR_TITLE'
	SET @SQL = @SQL + N'  , PR_CONTENTS'
	SET @SQL = @SQL + N'  , PR_IMG'
	SET @SQL = @SQL + N'  , PR_DATE'
	SET @SQL = @SQL + N'  , PR_ARTICLE_ORG'
	SET @SQL = @SQL + N'  , PR_ARTICLE_URL'
	SET @SQL = @SQL + N'  , REG_IP'
	SET @SQL = @SQL + N'  , REG_DT'
	SET @SQL = @SQL + N'  , UPD_IP'
	SET @SQL = @SQL + N'  , UPD_DT'
	SET @SQL = @SQL + N'  , VIEW_STATUS'
	SET @SQL = @SQL + N'  , DEL_ISYN'
	SET @SQL = @SQL + N' FROM NEWS_LIST A'
	SET @SQL = @SQL + N' WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY IDX DESC ;'
	
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT, @PAGE INT, @PAGESIZE INT'

	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM 
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHSTATUS, @TOTCNT, @PAGE, @PAGESIZE

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PRESS_TB_SEL_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 소식 - MW_PRESS_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 소식 SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PRESS_TB_SEL_PROC TO MWINCUSER
' EXEC DBO.MW_PRESS_TB_SEL_PROC 1, 20
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PRESS_TB_SEL_PROC]
	  @PAGE				INT
	, @PAGESIZE			INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @TOTCNT				INT

	SELECT @TOTCNT = COUNT(*) 
	FROM dbo.MW_PRESS_TB WITH (NOLOCK)
	WHERE   VIEW_STATUS = 'A' 
		AND DEL_ISYN = 'N'

	;WITH MW_PRESS_TB_LIST AS (
	SELECT  TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)
            ROW_NUMBER() OVER ( ORDER BY IDX DESC ) AS RNUM
		  , IDX
		  , PR_TITLE
		  , PR_CONTENTS
		  , PR_IMG
		  , PR_DATE
		  , PR_ARTICLE_ORG
		  , PR_ARTICLE_URL
		  , REG_IP
		  , REG_DT
		  , UPD_IP
		  , UPD_DT
		  , VIEW_STATUS
		  , DEL_ISYN
	FROM dbo.MW_PRESS_TB WITH (NOLOCK)
	WHERE   VIEW_STATUS = 'A' 
		AND DEL_ISYN = 'N'
	) 
	SELECT  TOTCNT = @TOTCNT
		  , RNUM
		  , IDX
		  , PR_TITLE
		  , PR_CONTENTS
		  , PR_IMG
		  , PR_DATE
		  , PR_ARTICLE_ORG
		  , PR_ARTICLE_URL
		  , REG_IP
		  , REG_DT
		  , UPD_IP
		  , UPD_DT
		  , VIEW_STATUS
		  , DEL_ISYN
	FROM MW_PRESS_TB_LIST A
	WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY IDX DESC 

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PRESS_TB_STATUS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 언론보도 - MW_PRESS_TB STATUS 변경
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 언론보도 상태값 변경
' 주  의  사  항	: 
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_PRESS_TB_STATUS_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PRESS_TB_STATUS_ADMIN_PROC 1, 'S', 'N'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PRESS_TB_STATUS_ADMIN_PROC]
      @CHG_TYPE			VARCHAR(1)
	, @CHG_STATUS		VARCHAR(1)
	, @STRIDX			VARCHAR(1000)
	, @UPD_IP           VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	IF @CHG_TYPE = 'S' -- 게시상태
	BEGIN
		UPDATE DBO.MW_PRESS_TB
		SET VIEW_STATUS = @CHG_STATUS
		  , UPD_IP   = @UPD_IP
		  , UPD_DT   = GETDATE()
		WHERE EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_PRESS_TB.IDX = ST.IDX)
	END
	ELSE IF @CHG_TYPE = 'D' -- 삭제여부
	BEGIN
		UPDATE DBO.MW_PRESS_TB
		SET DEL_ISYN = @CHG_STATUS
		  , UPD_IP   = @UPD_IP
		  , UPD_DT   = GETDATE()
		WHERE EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_PRESS_TB.IDX = ST.IDX)
	END

	RETURN @@ERROR

END

GO
/****** Object:  StoredProcedure [dbo].[MW_PRESS_TB_UPD_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 미디어윌 언론보도 - MW_PRESS_TB UPDATE
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 미디어윌 언론보도 수정
' 주  의  사  항	: 
' 사  용  소  스 	:
' 예          제	:
' EXEC DBO.MW_PRESS_TB_UPD_ADMIN_PROC 1, '미디어윌 언론보도 제목 1 테스트', '미디어윌 언론보도 내용 1 테스트', 'PRESS.JPG', '2016-01-01', '원기사전문요약', '원기사전문 링크', '111.222.333.444','A'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PRESS_TB_UPD_ADMIN_PROC]
      @IDX				INT
	, @PR_TITLE			VARCHAR(500)
	, @PR_CONTENTS		VARCHAR(MAX)
	, @PR_IMG			VARCHAR(100)
	, @PR_DATE			VARCHAR(10)
	, @PR_ARTICLE_ORG	VARCHAR(500)
	, @PR_ARTICLE_URL	VARCHAR(500)	
	, @UPD_IP			VARCHAR(50)
	, @VIEW_STATUS      VARCHAR(1)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	UPDATE DBO.MW_PRESS_TB
	SET  PR_TITLE = @PR_TITLE
	   , PR_CONTENTS = @PR_CONTENTS
	   , PR_IMG = @PR_IMG
	   , PR_DATE = @PR_DATE
	   , PR_ARTICLE_ORG = @PR_ARTICLE_ORG
	   , PR_ARTICLE_URL = @PR_ARTICLE_URL
	   , VIEW_STATUS   = @VIEW_STATUS
	   , UPD_IP = @UPD_IP
	   , UPD_DT = GETDATE()
	WHERE IDX = @IDX

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PROPOSAL_REPLY_TB_DEL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 제휴/제안 - MW_PROPOSAL_REPLY_TB DELETE
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 제휴/제안 답변 게시물 삭제
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PROPOSAL_REPLY_TB_DEL_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PROPOSAL_REPLY_TB_DEL_ADMIN_PROC '1,2', '111.222.333.444'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PROPOSAL_REPLY_TB_DEL_ADMIN_PROC]
	    @STRIDX		VARCHAR(1000)
	  , @UPD_IP     VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	UPDATE DBO.MW_PROPOSAL_REPLY_TB
	SET DEL_ISYN = 'Y'
	  , UPD_IP   = @UPD_IP
	  , UPD_DT   = GETDATE()
	WHERE EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_PROPOSAL_REPLY_TB.R_IDX = ST.IDX)

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PROPOSAL_REPLY_TB_DETAIL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 제휴/제안 답변 게시물 - MW_PROPOSAL_TB 리스트
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 제휴/제안 답변 게시물 리스트
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PROPOSAL_REPLY_TB_DETAIL_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PROPOSAL_REPLY_TB_DETAIL_ADMIN_PROC 4
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PROPOSAL_REPLY_TB_DETAIL_ADMIN_PROC]
	  @R_IDX			INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN	
	SELECT TOP 1 R_TITLE 
			, R_CONTENTS 
			, R_ATTATCH_FILE 
			, R_STATUS 
			, REG_IP 
			, REG_DT 
			, UPD_IP 
			, UPD_DT
	FROM DBO.MW_PROPOSAL_REPLY_TB WITH (NOLOCK)
	WHERE R_IDX = @R_IDX
	  AND DEL_ISYN = 'N'
END
GO
/****** Object:  StoredProcedure [dbo].[MW_PROPOSAL_REPLY_TB_INS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 제휴/제안 - MW_PROPOSAL_REPLY_TB INSERT
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 제휴/제안 답변 등록
' 주  의  사  항	: @P_STATUS - R (답변 & 메일 발송 대기), S (답변 & 메일 발송)
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PROPOSAL_REPLY_TB_INS_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PROPOSAL_REPLY_TB_INS_ADMIN_PROC 1, '마케팅 제휴 답변 제목 테스트', '마케팅 제휴 답변 내용 테스트', 'FILENAME.PPT', '111.222.33.44', 'R'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PROPOSAL_REPLY_TB_INS_ADMIN_PROC]
	  @P_IDX			INT
	, @R_TITLE			VARCHAR(500)
	, @R_CONTENTS		VARCHAR(5000)
	, @R_ATTATCH_FILE	VARCHAR(100)
	, @REG_IP			VARCHAR(50)
	, @R_STATUS			VARCHAR(1)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @RETURNVALUE INT = 0

	INSERT INTO DBO.MW_PROPOSAL_REPLY_TB (
		  P_IDX
		, R_TITLE
		, R_CONTENTS
		, R_ATTATCH_FILE
		, R_STATUS
		, REG_IP
	) VALUES (  
		  @P_IDX
		, @R_TITLE
		, @R_CONTENTS
		, @R_ATTATCH_FILE
		, @R_STATUS
		, @REG_IP
	)

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PROPOSAL_REPLY_TB_SEL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 제휴/제안 답변 게시물 - MW_PROPOSAL_TB 리스트
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 제휴/제안 답변 게시물 리스트
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PROPOSAL_REPLY_TB_SEL_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PROPOSAL_REPLY_TB_SEL_ADMIN_PROC 4
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PROPOSAL_REPLY_TB_SEL_ADMIN_PROC]
	  @P_IDX			INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN	
	SELECT    R_IDX 
			, R_TITLE 
			, R_CONTENTS 
			, R_ATTATCH_FILE 
			, R_STATUS 
			, REG_IP 
			, REG_DT 
			, UPD_IP 
			, UPD_DT
	FROM DBO.MW_PROPOSAL_REPLY_TB WITH (NOLOCK)
	WHERE P_IDX = @P_IDX
	  AND DEL_ISYN = 'N'
END
GO
/****** Object:  StoredProcedure [dbo].[MW_PROPOSAL_REPLY_TB_STATUS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 제휴/제안 - MW_PROPOSAL_REPLY_TB 메일발송 상태값 UPDATE
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 제휴/제안 메일발송 상태값 업데이트
' 주  의  사  항	: @VIEW_STATUS - R (답변 & 메일 발송 대기), S (답변 & 메일 발송)
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PROPOSAL_REPLY_TB_STATUS_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PROPOSAL_REPLY_TB_STATUS_ADMIN_PROC 1
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PROPOSAL_REPLY_TB_STATUS_ADMIN_PROC]
	  @R_IDX			INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	DECLARE @RETURNVALUE INT = 0
	
	UPDATE DBO.MW_PROPOSAL_REPLY_TB 
	SET R_STATUS = 'S'
	WHERE R_IDX = @R_IDX	

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PROPOSAL_REPLY_TB_UPD_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 제휴/제안 - MW_PROPOSAL_REPLY_TB UPDATE
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 제휴/제안 답변 수정
' 주  의  사  항	: @VIEW_STATUS - R (답변 & 메일 발송 대기), S (답변 & 메일 발송)
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PROPOSAL_REPLY_TB_UPD_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PROPOSAL_REPLY_TB_UPD_ADMIN_PROC 1, '마케팅 제휴 답변 제목 수정 테스트', '마케팅 제휴 답변 내용 수정 테스트', 'FILENAME.PPT', '111.222.33.44', 'R'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PROPOSAL_REPLY_TB_UPD_ADMIN_PROC]
	  @R_IDX			INT
	, @R_TITLE			VARCHAR(500)
	, @R_CONTENTS		VARCHAR(5000)
	, @R_ATTATCH_FILE	VARCHAR(100)	
	, @UPD_IP			VARCHAR(50)
	, @R_STATUS			VARCHAR(1)

AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	DECLARE @RETURNVALUE INT = 0
	
	UPDATE DBO.MW_PROPOSAL_REPLY_TB 
	SET 	  R_TITLE = @R_TITLE
			, R_CONTENTS = @R_TITLE
			, R_ATTATCH_FILE = @R_ATTATCH_FILE	
			, UPD_IP = @UPD_IP
			, UPD_DT = GETDATE()
			, R_STATUS = @R_STATUS
	WHERE R_IDX = @R_IDX	

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PROPOSAL_TB_DEL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 제휴/제안 - MW_PROPOSAL_TB STATUS UPDATE
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 제휴/제안 상태값 수정
' 주  의  사  항	: @P_STATUS - R (답변 & 메일 발송 대기), S (답변 & 메일 발송)
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PROPOSAL_TB_DEL_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PROPOSAL_TB_DEL_ADMIN_PROC '1,2', '111.222.333.444'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PROPOSAL_TB_DEL_ADMIN_PROC]
	    @STRIDX		VARCHAR(1000)
	  , @UPD_IP     VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	UPDATE DBO.MW_PROPOSAL_TB
	SET DEL_ISYN = 'Y'
	  , UPD_IP   = @UPD_IP
	  , UPD_DT   = GETDATE()
	WHERE EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_PROPOSAL_TB.P_IDX = ST.IDX)

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PROPOSAL_TB_INS_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 제휴/제안 - MW_PROPOSAL_TB INSERT
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 제휴/제안 등록
' 주  의  사  항	: @P_CATEGORY : M(마케팅 제휴), B(사업 제휴) 
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_PROPOSAL_TB_INS_PROC TO MWINCUSER
' EXEC DBO.MW_PROPOSAL_TB_INS_PROC 'M', 'SINNIE@MEDIAWILL.COM', '마케팅 제휴 제목 테스트', '마케팅 제휴 내용 테스트', 'FILENAME.PPT', '제안자명', '제안자@MEDIAWILL.COM', '111.222.33.44'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PROPOSAL_TB_INS_PROC]
	  @P_CATEGORY		VARCHAR(1)
	, @P_EMAIL			VARCHAR(100)
	, @P_TITLE			VARCHAR(500)
	, @P_CONTENTS		VARCHAR(5000)
	, @P_ATTATCH_FILE	VARCHAR(100)
	, @REG_NM			VARCHAR(20)
	, @REG_EMAIL		VARCHAR(100)
	, @REG_IP			VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	INSERT INTO DBO.MW_PROPOSAL_TB (
		  P_CATEGORY
		, P_EMAIL
		, P_TITLE
		, P_CONTENTS
		, P_ATTATCH_FILE
		, REG_NM
		, REG_EMAIL
		, REG_IP
	) VALUES (  
		  @P_CATEGORY
		, @P_EMAIL
		, @P_TITLE
		, @P_CONTENTS
		, @P_ATTATCH_FILE
		, @REG_NM
		, @REG_EMAIL
		, @REG_IP
	)

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PROPOSAL_TB_SEL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 제휴/제안 - MW_PROPOSAL_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 제휴/제안 게시물 SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PROPOSAL_TB_SEL_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PROPOSAL_TB_SEL_ADMIN_PROC 1, 20, '2015-01-01', '2016-03-08', '', '', ''
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PROPOSAL_TB_SEL_ADMIN_PROC]
	  @PAGE			INT
	, @PAGESIZE		INT
	, @SDATE		VARCHAR(10)
	, @EDATE		VARCHAR(10)
	, @SCHTYPE		VARCHAR(20) = ''
	, @SCHTEXT		VARCHAR(50) = ''
	, @SCHCATEGORY	VARCHAR(1)  = ''
	, @SCHSTATUS	VARCHAR(1)  = ''
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @SQL				NVARCHAR(4000)
	DECLARE @SQL_WHERE			NVARCHAR(1000)
	DECLARE @SQL_COMMON_PARAM	NVARCHAR(1000)
	DECLARE @SQL_PARAM			NVARCHAR(500)
	DECLARE @TOTCNT				INT = 0

	SET @SQL_COMMON_PARAM = N''
	SET @SQL_PARAM = N''
	SET @SQL_WHERE = N' WHERE DEL_ISYN=''N'' '

	/* 1. 검색 기간 선택 */
	IF (@SDATE <> '' AND @EDATE <> '')
	BEGIN		
		SET @EDATE = DATEADD(DAY, 15, @EDATE)
		SET @SQL_WHERE = @SQL_WHERE + N' AND REG_DT >= @SDATE AND REG_DT < @EDATE '
	END
	
	/* 2. 검색 조건 선택 */
	IF @SCHTYPE <> '' AND @SCHTEXT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE +
		CASE 
			WHEN @SCHTYPE = ''				THEN	N''
			WHEN @SCHTYPE = 'TITLE'		THEN		N' AND P_TITLE LIKE ''%' + @SCHTEXT + '%'''
			WHEN @SCHTYPE = 'CONTENTS'	THEN		N' AND P_CONTENTS LIKE ''%' + @SCHTEXT + '%'''
			WHEN @SCHTYPE = 'REG_NM'		THEN	N' AND REG_NM LIKE ''%' + @SCHTEXT + '%'''
			WHEN @SCHTYPE = 'REG_EMAIL'		THEN	N' AND REG_EMAIL LIKE ''%' + @SCHTEXT + '%'''
		END
	END

	IF @SCHCATEGORY <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + N' AND P_CATEGORY = ''' + @SCHCATEGORY + ''''
	END
	
	SET @SQL_COMMON_PARAM = N' @SDATE VARCHAR(10), @EDATE VARCHAR(10), @SCHTYPE VARCHAR(20), @SCHTEXT VARCHAR(50), @SCHCATEGORY VARCHAR(1), @SCHSTATUS VARCHAR(1)'

	/* 3. 검색 카운트 */
	SET @SQL = N' SELECT @TOTCNT = COUNT(P_IDX) '
	SET @SQL = @SQL + N' FROM DBO.MW_PROPOSAL_TB WITH(NOLOCK)' + @SQL_WHERE
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT OUT'
	
	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHCATEGORY, @SCHSTATUS, @TOTCNT OUT

	SET @SQL = N'; WITH PROPOSAL_LIST AS ('
	SET @SQL = @SQL + N' SELECT TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)'
	SET @SQL = @SQL + N'    ROW_NUMBER() OVER ( ORDER BY P_IDX DESC ) AS RNUM'
	SET @SQL = @SQL + N'  , P_IDX'
	SET @SQL = @SQL + N'  , P_CATEGORY'
	SET @SQL = @SQL + N'  , P_EMAIL'
	SET @SQL = @SQL + N'  , P_TITLE'
	SET @SQL = @SQL + N'  , P_CONTENTS'
	SET @SQL = @SQL + N'  , P_ATTATCH_FILE'
	SET @SQL = @SQL + N'  , REG_NM'
	SET @SQL = @SQL + N'  , REG_EMAIL'
	SET @SQL = @SQL + N'  , REG_IP'
	SET @SQL = @SQL + N'  , REG_DT'
	SET @SQL = @SQL + N'  , R_CNT = (SELECT COUNT(*) FROM MW_PROPOSAL_REPLY_TB WITH (NOLOCK) WHERE P_IDX = PT.P_IDX AND DEL_ISYN=''N'')'
	SET @SQL = @SQL + N' FROM DBO.MW_PROPOSAL_TB PT WITH (NOLOCK)' + @SQL_WHERE
	SET @SQL = @SQL + N') '
	SET @SQL = @SQL + N' SELECT  TOTCNT = @TOTCNT'
	SET @SQL = @SQL + N'  , RNUM'
	SET @SQL = @SQL + N'  , P_IDX'
	SET @SQL = @SQL + N'  , P_CATEGORY'
	SET @SQL = @SQL + N'  , P_EMAIL'
	SET @SQL = @SQL + N'  , P_TITLE'
	SET @SQL = @SQL + N'  , P_CONTENTS'
	SET @SQL = @SQL + N'  , P_ATTATCH_FILE'
	SET @SQL = @SQL + N'  , REG_NM'
	SET @SQL = @SQL + N'  , REG_EMAIL'
	SET @SQL = @SQL + N'  , REG_IP'
	SET @SQL = @SQL + N'  , REG_DT'
	SET @SQL = @SQL + N'  , R_CNT'
	SET @SQL = @SQL + N' FROM PROPOSAL_LIST A'
	SET @SQL = @SQL + N' WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY P_IDX DESC ;'
	
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT, @PAGE INT, @PAGESIZE INT'

	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM 
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHCATEGORY, @SCHSTATUS, @TOTCNT, @PAGE, @PAGESIZE

END
GO
/****** Object:  StoredProcedure [dbo].[MW_PROPOSAL_TB_SEL_DETAIL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 제휴/제안 답변 게시물 - MW_PROPOSAL_TB 상세
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 제휴/제안 게시물 상세
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_PROPOSAL_TB_SEL_DETAIL_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_PROPOSAL_TB_SEL_DETAIL_ADMIN_PROC 4
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_PROPOSAL_TB_SEL_DETAIL_ADMIN_PROC]
	  @P_IDX			INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN	
	SELECT TOP 1 P_IDX
			, P_CATEGORY
			, P_EMAIL
			, P_TITLE
			, P_CONTENTS
			, P_ATTATCH_FILE
			, REG_NM
			, REG_EMAIL
			, REG_IP
			, REG_DT
			, UPD_IP
			, UPD_DT
	FROM DBO.MW_PROPOSAL_TB WITH (NOLOCK)
	WHERE P_IDX = @P_IDX
	  AND DEL_ISYN = 'N'

END
GO
/****** Object:  StoredProcedure [dbo].[MW_SOCIETY_TB_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 사회공헌 - MW_SOCIETY_TB 상세
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 사회공헌 상세
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_SOCIETY_TB_DETAIL_PROC TO MWINCUSER
' EXEC DBO.MW_SOCIETY_TB_DETAIL_PROC 1
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_SOCIETY_TB_DETAIL_PROC]
	  @IDX			INT
	, @SCHCATEGORY	VARCHAR(1)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	DECLARE @PREV_IDX	INT
	DECLARE @NEXT_IDX   INT
	DECLARE @PREV_TITLE	VARCHAR(500)
	DECLARE @NEXT_TITLE	VARCHAR(500)

	SELECT TOP 1 @PREV_IDX = IDX, @PREV_TITLE = SC_TITLE
	FROM DBO.MW_SOCIETY_TB WITH (NOLOCK) 
	WHERE IDX < @IDX AND VIEW_STATUS = 'A' AND DEL_ISYN = 'N' AND SC_CATEGORY = @SCHCATEGORY ORDER BY IDX DESC

	SELECT TOP 1 @NEXT_IDX = IDX, @NEXT_TITLE = SC_TITLE 
	FROM DBO.MW_SOCIETY_TB WITH (NOLOCK) 
	WHERE IDX > @IDX AND VIEW_STATUS = 'A' AND DEL_ISYN = 'N' AND SC_CATEGORY = @SCHCATEGORY ORDER BY IDX ASC
	
	SELECT    IDX
			, SC_CATEGORY
			, SC_BBSTYPE
			, SC_TITLE
			, SC_ADURL
			, SC_CONTENTS
			, SC_THUMBIMG
			, SC_THUMBWIDTH
			, SC_THUMBHEIGHT
			, SC_IMG
			, SC_DATE
			, REG_IP
			, REG_DT
			, UPD_IP
			, UPD_DT
			, VIEW_STATUS
			, DEL_ISYN
			, ISNULL(@PREV_IDX, 0)
			, ISNULL(@PREV_TITLE, '')
			, ISNULL(@NEXT_IDX, 0)
			, ISNULL(@NEXT_TITLE, '')	
	FROM DBO.MW_SOCIETY_TB WITH (NOLOCK)
	WHERE IDX = @IDX AND DEL_ISYN = 'N'

END
GO
/****** Object:  StoredProcedure [dbo].[MW_SOCIETY_TB_INS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 사회공헌 - MW_SOCIETY_TB INSERT
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 사회공헌 등록
' 주  의  사  항	: @SC_CATEGORY 부천 필하모닉 오케스트라(A), 사랑의 자원봉사(B), 착한나눔(C)
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_SOCIETY_TB_INS_ADMIN_PROC TO MWINCUSER
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_SOCIETY_TB_INS_ADMIN_PROC]
	  @SC_CATEGORY			VARCHAR(1)
	, @SC_BBSTYPE			VARCHAR(1)
	, @SC_TITLE				VARCHAR(500)
	, @SC_ADURL				VARCHAR(100)
	, @SC_CONTENTS			VARCHAR(5000)
	, @SC_THUMBIMG			VARCHAR(100)
	, @SC_THUMBWIDTH		VARCHAR(10)
	, @SC_THUMBHEIGHT		VARCHAR(10)
	, @SC_IMG				VARCHAR(100)
	, @SC_DATE				VARCHAR(100)
	, @REG_IP				VARCHAR(50)
	, @VIEW_STATUS			VARCHAR(1)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	INSERT INTO DBO.MW_SOCIETY_TB (
		      SC_CATEGORY
			, SC_BBSTYPE
			, SC_TITLE
			, SC_ADURL
			, SC_CONTENTS
			, SC_THUMBIMG
			, SC_THUMBWIDTH
			, SC_THUMBHEIGHT
			, SC_IMG
			, SC_DATE
			, REG_IP
			, VIEW_STATUS
	) VALUES (  
		      @SC_CATEGORY
			, @SC_BBSTYPE
			, @SC_TITLE
			, @SC_ADURL
			, @SC_CONTENTS
			, @SC_THUMBIMG
			, @SC_THUMBWIDTH
			, @SC_THUMBHEIGHT
			, @SC_IMG
			, @SC_DATE
			, @REG_IP
			, @VIEW_STATUS
	)	  

	RETURN @@ERROR

END

GO
/****** Object:  StoredProcedure [dbo].[MW_SOCIETY_TB_SEL_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 사회공헌 - MW_SOCIETY_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 사회공헌 SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_SOCIETY_TB_SEL_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_SOCIETY_TB_SEL_ADMIN_PROC 1, 20, '2015-01-01', '2016-03-08', '', '', '', ''
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_SOCIETY_TB_SEL_ADMIN_PROC]
	  @PAGE				INT
	, @PAGESIZE			INT
	, @SDATE			VARCHAR(10)
	, @EDATE			VARCHAR(10)
	, @SCHTYPE			VARCHAR(20) = ''
	, @SCHTEXT			VARCHAR(50) = ''
	, @SCHCATEGORY		VARCHAR(1)  = ''
	, @SCHSTATUS		VARCHAR(1)  = ''
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @SQL				NVARCHAR(4000)
	DECLARE @SQL_WHERE			NVARCHAR(1000)
	DECLARE @SQL_COMMON_PARAM	NVARCHAR(1000)
	DECLARE @SQL_PARAM			NVARCHAR(500)
	DECLARE @TOTCNT				INT = 0

	SET @SQL_COMMON_PARAM = N''
	SET @SQL_PARAM = N''
	SET @SQL_WHERE = N' WHERE DEL_ISYN=''N'' '

	/* 1. 검색 기간 선택 */
	IF (@SDATE <> '' AND @EDATE <> '')
	BEGIN		
		SET @EDATE = DATEADD(DAY, 15, @EDATE)
		SET @SQL_WHERE = @SQL_WHERE + N' AND REG_DT >= @SDATE AND REG_DT < @EDATE '
	END
	
	/* 2. 검색 조건 선택 */
	IF @SCHTYPE <> '' AND @SCHTEXT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE +
		CASE 
			WHEN @SCHTYPE = ''			THEN	N''
			WHEN @SCHTYPE = 'TITLE'		THEN	N' AND SC_TITLE LIKE ''%' + @SCHTEXT + '%'''
			WHEN @SCHTYPE = 'CONTENTS'	THEN	N' AND SC_CONTENTS LIKE ''%' + @SCHTEXT + '%'''
		END
	END
	
	IF @SCHCATEGORY <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + N' AND SC_CATEGORY = ''' + @SCHCATEGORY + ''''
	END

	IF @SCHSTATUS <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + N' AND VIEW_STATUS = ''' + @SCHSTATUS + ''''
	END

	SET @SQL_COMMON_PARAM = N' @SDATE VARCHAR(10), @EDATE VARCHAR(10), @SCHTYPE VARCHAR(20), @SCHTEXT VARCHAR(50), @SCHCATEGORY VARCHAR(1), @SCHSTATUS VARCHAR(1)'

	/* 3. 검색 카운트 */
	SET @SQL = N' SELECT @TOTCNT = COUNT(IDX) '
	SET @SQL = @SQL + N' FROM DBO.MW_SOCIETY_TB WITH(NOLOCK)' + @SQL_WHERE
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT OUT'
	
	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHCATEGORY, @SCHSTATUS, @TOTCNT OUT

	SET @SQL = N'; WITH SC_LIST AS ('
	SET @SQL = @SQL + N' SELECT TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)'
	SET @SQL = @SQL + N'     ROW_NUMBER() OVER ( ORDER BY IDX DESC ) AS RNUM'
	SET @SQL = @SQL + N'  ,  IDX'
	SET @SQL = @SQL + N'  ,  SC_CATEGORY'
	SET @SQL = @SQL + N'  ,  SC_BBSTYPE'
	SET @SQL = @SQL + N'  ,  SC_TITLE'
	SET @SQL = @SQL + N'  ,  SC_ADURL'
	SET @SQL = @SQL + N'  ,  SC_CONTENTS'
	SET @SQL = @SQL + N'  ,  SC_THUMBIMG'
	SET @SQL = @SQL + N'  ,  SC_THUMBWIDTH'
	SET @SQL = @SQL + N'  ,  SC_THUMBHEIGHT'
	SET @SQL = @SQL + N'  ,  SC_IMG'
	SET @SQL = @SQL + N'  ,  SC_DATE'
	SET @SQL = @SQL + N'  ,  REG_IP'
	SET @SQL = @SQL + N'  ,  REG_DT'
	SET @SQL = @SQL + N'  ,  UPD_IP'
	SET @SQL = @SQL + N'  ,  UPD_DT'
	SET @SQL = @SQL + N'  ,  VIEW_STATUS'
	SET @SQL = @SQL + N'  ,  DEL_ISYN'
	SET @SQL = @SQL + N' FROM DBO.MW_SOCIETY_TB PT WITH (NOLOCK)' + @SQL_WHERE
	SET @SQL = @SQL + N') '
	SET @SQL = @SQL + N' SELECT  TOTCNT = @TOTCNT'
	SET @SQL = @SQL + N'  ,  RNUM'
	SET @SQL = @SQL + N'  ,  IDX'
	SET @SQL = @SQL + N'  ,  SC_CATEGORY'
	SET @SQL = @SQL + N'  ,  SC_BBSTYPE'
	SET @SQL = @SQL + N'  ,  SC_TITLE'
	SET @SQL = @SQL + N'  ,  SC_ADURL'
	SET @SQL = @SQL + N'  ,  SC_CONTENTS'
	SET @SQL = @SQL + N'  ,  SC_THUMBIMG'
	SET @SQL = @SQL + N'  ,  SC_THUMBWIDTH'
	SET @SQL = @SQL + N'  ,  SC_THUMBHEIGHT'
	SET @SQL = @SQL + N'  ,  SC_IMG'
	SET @SQL = @SQL + N'  ,  SC_DATE'
	SET @SQL = @SQL + N'  ,  REG_IP'
	SET @SQL = @SQL + N'  ,  REG_DT'
	SET @SQL = @SQL + N'  ,  UPD_IP'
	SET @SQL = @SQL + N'  ,  UPD_DT'
	SET @SQL = @SQL + N'  ,  VIEW_STATUS'
	SET @SQL = @SQL + N'  ,  DEL_ISYN'
	SET @SQL = @SQL + N' FROM SC_LIST A'
	SET @SQL = @SQL + N' WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY IDX DESC ;'
	
	SET @SQL_PARAM = @SQL_COMMON_PARAM  + N', @TOTCNT INT, @PAGE INT, @PAGESIZE INT'

	EXEC SP_EXECUTESQL @SQL
					 , @SQL_PARAM 
					 , @SDATE, @EDATE, @SCHTYPE, @SCHTEXT, @SCHCATEGORY, @SCHSTATUS, @TOTCNT, @PAGE, @PAGESIZE

END
GO
/****** Object:  StoredProcedure [dbo].[MW_SOCIETY_TB_SEL_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 사회공헌 - MW_SOCIETY_TB  SELECT LISTING
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 사회공헌 SELECT LISTING
' 주  의  사  항	:
' 사  용  소  스 	:
' 예          제	: 
' GRANT EXECUTE ON DBO.MW_SOCIETY_TB_SEL_PROC TO MWINCUSER
' EXEC DBO.MW_SOCIETY_TB_SEL_PROC 1, 8, 'C'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_SOCIETY_TB_SEL_PROC]
	  @PAGE				INT
	, @PAGESIZE			INT
	, @SCHCATEGORY		VARCHAR(1)  = ''
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @TOTCNT				INT

	SELECT @TOTCNT = COUNT(*) 
	FROM dbo.MW_SOCIETY_TB WITH (NOLOCK)
	WHERE SC_CATEGORY = (CASE WHEN @SCHCATEGORY = '' THEN SC_CATEGORY ELSE @SCHCATEGORY END)
		AND VIEW_STATUS = 'A' 
		AND DEL_ISYN = 'N'

	;WITH MW_SOCIETY_TB AS (
	SELECT TOP((@PAGE - 1) * @PAGESIZE + @PAGESIZE)
         ROW_NUMBER() OVER ( ORDER BY IDX DESC ) AS RNUM
	  ,  IDX
	  ,  SC_CATEGORY
	  ,  SC_BBSTYPE
	  ,  SC_TITLE
	  ,  SC_ADURL
	  ,  SC_CONTENTS
	  ,  SC_THUMBIMG
	  ,  SC_THUMBWIDTH
	  ,  SC_THUMBHEIGHT
	  ,  SC_IMG
	  ,  SC_DATE
	  ,  REG_IP
	  ,  REG_DT
	  ,  UPD_IP
	  ,  UPD_DT
	  ,  VIEW_STATUS
	  ,  DEL_ISYN
	FROM dbo.MW_SOCIETY_TB WITH (NOLOCK)
	WHERE SC_CATEGORY = (CASE WHEN @SCHCATEGORY = '' THEN SC_CATEGORY ELSE @SCHCATEGORY END)
		AND VIEW_STATUS = 'A' 
		AND DEL_ISYN = 'N'
	) 
	SELECT  TOTCNT = @TOTCNT
	  ,  RNUM
	  ,  IDX
	  ,  SC_CATEGORY
	  ,  SC_BBSTYPE
	  ,  SC_TITLE
	  ,  SC_ADURL
	  ,  SC_CONTENTS
	  ,  SC_THUMBIMG
	  ,  SC_THUMBWIDTH
	  ,  SC_THUMBHEIGHT
	  ,  SC_IMG
	  ,  SC_DATE
	  ,  REG_IP
	  ,  REG_DT
	  ,  UPD_IP
	  ,  UPD_DT
	  ,  VIEW_STATUS
	  ,  DEL_ISYN
	FROM MW_SOCIETY_TB A
	WHERE RNUM BETWEEN (@PAGE-1)*@PAGESIZE+1 AND (@PAGE-1)*@PAGESIZE+@PAGESIZE ORDER BY IDX DESC 

END
GO
/****** Object:  StoredProcedure [dbo].[MW_SOCIETY_TB_STATUS_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 사회공헌 - MW_SOCIETY_TB STATUS 변경
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 사회공헌 상태값 변경
' 주  의  사  항	: @VIEW_TYPE : D(삭제여부), S(게시상태값 변경)
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.MW_SOCIETY_TB_STATUS_ADMIN_PROC TO MWINCUSER
' EXEC DBO.MW_SOCIETY_TB_STATUS_ADMIN_PROC 'A', 'A', '1,2', '111.222.333.444'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_SOCIETY_TB_STATUS_ADMIN_PROC]
	  @SC_CATEGORY		VARCHAR(1)
    , @CHG_TYPE			VARCHAR(1)
	, @CHG_STATUS		VARCHAR(1)
	, @STRIDX			VARCHAR(1000)
	, @UPD_IP           VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	IF @CHG_TYPE = 'S' -- 게시상태
	BEGIN
		UPDATE DBO.MW_SOCIETY_TB
		SET VIEW_STATUS = @CHG_STATUS
		  , UPD_IP   = @UPD_IP
		  , UPD_DT   = GETDATE()
		WHERE SC_CATEGORY = @SC_CATEGORY AND EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_SOCIETY_TB.IDX = ST.IDX)
	END
	ELSE IF @CHG_TYPE = 'D' -- 삭제여부
	BEGIN
		UPDATE DBO.MW_SOCIETY_TB
		SET DEL_ISYN = @CHG_STATUS
		  , UPD_IP   = @UPD_IP
		  , UPD_DT   = GETDATE()
		WHERE SC_CATEGORY = @SC_CATEGORY AND EXISTS (SELECT TOP 1 IDX  FROM GET_SPLITER_INT_FNC(@STRIDX, ',') AS ST WHERE DBO.MW_SOCIETY_TB.IDX = ST.IDX)
	END

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[MW_SOCIETY_TB_UPD_ADMIN_PROC]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 사회공헌 - MW_SOCIETY_TB UPDATE
' 작    성    자	: 
' 작    성    일	: 2016년 3월 8일
' 수    정    자	:
' 수    정    일	:
' 설          명	: 사회공헌 수정
' 주  의  사  항	: 
' 사  용  소  스 	:
' 예          제	:
' GRANT EXECUTE ON DBO.[MW_SOCIETY_TB_UPD_ADMIN_PROC] TO MWINCUSER
' EXEC DBO.[MW_SOCIETY_TB_UPD_ADMIN_PROC 1, 'A', '부천필하모닉오케스트라 제야음악회', '사회공헌 요약 1 테스트',  '사회공헌 내용 1 테스트',  'AD.JPG', '2011~현재',  '111.222.333.444', 'W'
******************************************************************************/
CREATE PROCEDURE [dbo].[MW_SOCIETY_TB_UPD_ADMIN_PROC]
      @IDX					INT
	, @SC_CATEGORY			VARCHAR(1)
	, @SC_BBSTYPE			VARCHAR(1)
	, @SC_TITLE				VARCHAR(500)
	, @SC_ADURL				VARCHAR(100)
	, @SC_CONTENTS			VARCHAR(5000)
	, @SC_THUMBIMG			VARCHAR(100)
	, @SC_THUMBWIDTH		VARCHAR(10)
	, @SC_THUMBHEIGHT		VARCHAR(10)
	, @SC_IMG				VARCHAR(100)
	, @SC_DATE				VARCHAR(100)
	, @UPD_IP				VARCHAR(50)
	, @VIEW_STATUS			VARCHAR(1) = 'W'

AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	UPDATE DBO.MW_SOCIETY_TB
	SET  SC_CATEGORY = @SC_CATEGORY  
	   , SC_BBSTYPE = @SC_BBSTYPE
	   , SC_TITLE = @SC_TITLE
	   , SC_ADURL = @SC_ADURL
	   , SC_CONTENTS = @SC_CONTENTS
	   , SC_THUMBIMG = @SC_THUMBIMG
	   , SC_THUMBWIDTH = @SC_THUMBWIDTH
	   , SC_THUMBHEIGHT = @SC_THUMBHEIGHT
	   , SC_IMG = @SC_IMG
	   , SC_DATE = @SC_DATE
	   , UPD_IP = @UPD_IP
	   , UPD_DT = GETDATE()
	   , VIEW_STATUS = @VIEW_STATUS
	WHERE IDX = @IDX

	RETURN @@ERROR

END
GO
/****** Object:  StoredProcedure [dbo].[proc_Delete_SiteNews]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[proc_Delete_SiteNews]
(
	@Serial varchar(100)
)
AS
DECLARE @strQuery varchar(200)
SET @strQuery = 'DELETE FROM SiteNews WHERE Serial IN (' + @Serial + ')'
EXEC (@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[proc_Detail_SiteNews]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[proc_Detail_SiteNews]
(
	@Serial int
)
AS
SELECT 
	Serial, Code, Title, ISNULL(InviteDate,'') AS InviteDate, ISNULL(FileUrl,'') AS FileUrl, Name, 
	CONVERT(varchar(10),RegDate,120) AS RegDate, Summary, Contents, ViewCnt, ViewFlag, InDate
FROM MWBBS WHERE Serial=@Serial 
UPDATE MWBBS SET ViewCnt=ViewCnt + 1 WHERE Serial=@Serial
GO
/****** Object:  StoredProcedure [dbo].[proc_Insert_SiteNews]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       PROCEDURE [dbo].[proc_Insert_SiteNews]
(
	@Code int, 
	@Title varchar(100), 
	@InviteDate varchar(50),
	@FileUrl varchar(200), 
	@Name varchar(50), 
	@RegDate datetime, 
	@Summary varchar(500),
	@Contents text, 
	@ViewCnt int, 
	@ViewFlag char(1),
             @InDate varchar(50),
	@Serial int OUTPUT
)
AS
INSERT INTO MWBBS (Code, Title, InviteDate, FileUrl, Name, RegDate, Summary, Contents, ViewCnt, ViewFlag, InDate) 
VALUES(@Code, @Title, @InviteDate, @FileUrl, @Name, GETDATE(), @Summary, @Contents, @ViewCnt, @ViewFlag, @InDate)
SELECT @Serial = @@IDENTITY
GO
/****** Object:  StoredProcedure [dbo].[proc_List_MainNews]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[proc_List_MainNews]  AS


select  top 1 Serial, Title, Summary, RegDate from MWBBS
with (nolock)
 where Code =2 and  ViewFlag = 2 order by Serial desc
GO
/****** Object:  StoredProcedure [dbo].[proc_List_MainNews2]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[proc_List_MainNews2]  AS


select  top 2 Serial, Title, Summary, RegDate from MWBBS
with (nolock)
 where Code =2 and  ViewFlag = 2 order by Serial desc
GO
/****** Object:  StoredProcedure [dbo].[proc_List_SiteNews]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE              PROCEDURE [dbo].[proc_List_SiteNews]
(
	@Code int,
	@CurPage int,
	@PagePerCnt int,
	@ViewFlag char(1),
	@Title varchar(100),
	@Name varchar(50),
	@Content varchar(100),
             @InDate varchar(50)
)

AS

DECLARE @strQuery varchar(500)

SET @strQuery = 'SELECT TOP ' + CONVERT(varchar,@CurPage*@PagePerCnt)  + ' '
SET @strQuery = @strQuery + '0 AS ViewSerial, Serial, Code, Title, Name, InviteDate, Summary, ISNULL(FileUrl,'''') AS FileUrl, ViewFlag, ViewCnt, CONVERT(varchar(10),RegDate,120) AS RegDate,  InDate, '
SET @strQuery = @strQuery + 'CASE WHEN ViewFlag=''1'' THEN ''게재중'' WHEN ViewFlag=''0'' THEN ''미게재'' WHEN ViewFlag=''2'' THEN ''메인게재'' END AS ViewText ' 
SET @strQuery = @strQuery + 'FROM MWBBS WHERE Serial=Serial '  

IF @Code <> 0
	SET @strQuery = @strQuery + 'AND Code=' + CONVERT(varchar,@Code) + ' '
IF @ViewFlag = '1'
	SET @strQuery = @strQuery + 'AND ViewFlag IN (''1'',''2'') ' 
IF @ViewFlag = '2'
	SET @strQuery = @strQuery + 'AND ViewFlag = ''2'' ' 
IF @Title <> ''
	SET @strQuery = @strQuery + 'AND Title Like''%' + @Title + '%'' ' 
IF @Name <> ''
	SET @strQuery = @strQuery + 'AND Name Like''%' + @Name + '%'' ' 
IF @Content <> ''
	SET @strQuery = @strQuery + 'AND Contents Like ''%' + @Content + '%'' ' 
IF @InDate <> ''
	SET @strQuery = @strQuery + 'AND InDate Like ''%' + @InDate + '%'' ' 

SET @strQuery = @strQuery + 'ORDER BY RegDate DESC,  Serial DESC '

EXEC (@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[proc_ListCount_SiteNews]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[proc_ListCount_SiteNews]
(
	@Code int,
	@ViewFlag char(1),
	@Title varchar(100),
	@Name varchar(50),
	@Content varchar(100),
	@InDate varchar(50)

)
AS
DECLARE @strQuery varchar(500)
SET @strQuery = 'SELECT COUNT(Serial) AS Cnt FROM MWBBS WHERE Serial=Serial '  
IF @Code <> 0
	SET @strQuery = @strQuery + 'AND Code=' + CONVERT(varchar,@Code) + ' '
IF @ViewFlag = '1'
	SET @strQuery = @strQuery + 'AND ViewFlag IN (''1'',''2'') ' 
IF @ViewFlag = '2'
	SET @strQuery = @strQuery + 'AND ViewFlag = ''2'' ' 
IF @Title <> ''
	SET @strQuery = @strQuery + 'AND Title Like''%' + @Title + '%'' ' 
IF @Name <> ''
	SET @strQuery = @strQuery + 'AND Name Like''%' + @Name + '%'' ' 
IF @Content <> ''
	SET @strQuery = @strQuery + 'AND Contents Like ''%' + @Content + '%'' ' 
IF @InDate <> ''
	SET @strQuery = @strQuery + 'AND InDate Like ''%' + @InDate + '%'' ' 
PRINT (@strQuery)
EXEC (@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[proc_Modify_SiteNews]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[proc_Modify_SiteNews]
(
	@Serial int,
	@Code int, 
	@Title varchar(100), 
	@InviteDate varchar(50),
	@FileUrl varchar(200), 
	@Name varchar(50), 
	@RegDate datetime, 
	@Summary varchar(500),
	@Contents text, 
	@ViewCnt int, 
	@ViewFlag char(1),
	@InDate varchar(50)
)
AS
IF @FileUrl <> ''
	BEGIN
		UPDATE MWBBS SET 
			Code    	=	@Code, 
			Title   	=	@Title, 
			InviteDate  = 	@InviteDate,
			FileUrl 	=	@FileUrl, 
			Name    	=	@Name, 
			RegDate =	RegDate, 
			Summary = 	@Summary,
			Contents	=	@Contents, 
			ViewCnt 	=	@ViewCnt, 
			ViewFlag	=	@ViewFlag,
			InDate		=	@InDate
		WHERE Serial=@Serial 
	END
ELSE
	BEGIN
		UPDATE MWBBS SET 
			Code    	=	@Code, 
			Title   	=	@Title, 
			InviteDate  = 	@InviteDate,
			Name    	=	@Name, 
			RegDate =	RegDate, 
			Summary = 	@Summary,
			Contents	=	@Contents, 
			ViewCnt 	=	@ViewCnt, 
			ViewFlag	=	@ViewFlag,
			InDate		=	@InDate
		WHERE Serial=@Serial 
	END
GO
/****** Object:  StoredProcedure [dbo].[proc_ViewFlag_SiteNews]    Script Date: 2021-11-04 오전 10:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[proc_ViewFlag_SiteNews]
(
	@Serial varchar(100),
	@ViewFlag char(1)
)
AS
DECLARE @strQuery varchar(200)
SET @strQuery = 'UPDATE MWBBS SET ViewFlag=''' + @ViewFlag + ''' WHERE Serial IN (' + @Serial + ')'
EXEC(@strQuery)
GO
