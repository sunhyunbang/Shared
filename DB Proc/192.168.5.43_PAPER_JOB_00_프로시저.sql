USE [PAPERJOB]
GO
/****** Object:  StoredProcedure [dbo].[APP_AD_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 야알바 > 모바일어플 > 광고상세
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2012/09/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /app/Json_AdDetail.asp
 *  사 용  예 제 : EXEC DBO.APP_AD_DETAIL_PROC 1011028324, 'P'
 *************************************************************************************/


CREATE PROC [dbo].[APP_AD_DETAIL_PROC]

  @ADID INT
  ,@AD_KIND CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT ADID
        ,AD_KIND
        ,CO_NAME
        ,PHONE
        ,HPHONE
        ,BIZ_CD
        ,AREA_A
        ,AREA_B
        ,AREA_C
        ,AREA_DETAIL
        ,HOMEPAGE
        ,TITLE
        ,CONTENTS
        ,THEME_CD
        ,PAY_CD
        ,PAY_AMT
        ,BIZ_NUMBER
        ,LOGO_IMG
        ,START_DT
        ,END_DT
        ,MAP_X
        ,MAP_Y
    FROM PJ_AD_PUBLISH_TENS_TB
   WHERE ADID = @ADID
     AND AD_KIND = @AD_KIND



GO
/****** Object:  StoredProcedure [dbo].[APP_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 야알바 > 모바일어플 > 광고리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2012/09/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /app/Json_AdList.asp
 *  사 용  예 제 : EXEC DBO.APP_AD_LIST_PROC 1, 20, '서울특별시','','',40300,'',''
 *************************************************************************************/


CREATE PROC [dbo].[APP_AD_LIST_PROC]

  @PAGE INT                     -- 페이지
  ,@PAGESIZE INT                -- 페이지사이즈
  ,@AREA_A VARCHAR(50)          -- 지역 (시)
  ,@AREA_B VARCHAR(50)          -- 지역 (구)
--  ,@AREA_C VARCHAR(50)          -- 지역 (동)
  ,@BIZ_CD INT                  -- 직종(분류코드)
  ,@KEYWORDKIND VARCHAR(2)      -- 검색대상 (T:제목, C:내용, TC:제목+내용)
  ,@KEYWORD     VARCHAR(100)    -- 검색키워드
  ,@TOTALCOUNT INT = 0 OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
         ,@SQL_WHERE NVARCHAR(2000)
         ,@ParmDefinition    NVARCHAR(20)
         ,@LISTCOUNT INT

  SET @SQL = ''
  SET @SQL_WHERE = ''

  -- 지역
  IF @AREA_A <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND AREA_A = '''+ @AREA_A +''''
  IF @AREA_B <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND AREA_B = '''+ @AREA_B +''''
/*
  IF @AREA_C <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND AREA_C = '''+ @AREA_C +''''
*/
  -- 직종
  IF @BIZ_CD > 0
    SET @SQL_WHERE = @SQL_WHERE +' AND BIZ_CD = '+ CAST(@BIZ_CD AS VARCHAR(5)) +''

  -- 키워드
  IF @KEYWORDKIND = 'T' AND @KEYWORD <> ''
    SET @SQL_WHERE = @SQL_WHERE +' AND TITLE LIKE ''%'+ @KEYWORD +'%'''
  ELSE IF @KEYWORDKIND = 'C' AND @KEYWORD <> ''
    SET @SQL_WHERE = @SQL_WHERE +' AND CONTENT LIKE ''%'+ @KEYWORD +'%'''
  ELSE IF @KEYWORDKIND = 'C' AND @KEYWORD <> ''
    SET @SQL_WHERE = @SQL_WHERE +' AND (TITLE LIKE ''%'+ @KEYWORD +'%'' OR CONTENT LIKE ''%'+ @KEYWORD +'%'')'

  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
    FROM PJ_AD_PUBLISH_TB
   WHERE 1 = 1 '+ @SQL_WHERE +';
  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY START_DT DESC) AS ROWNUM
        ,ADID
        ,AD_KIND
        ,CO_NAME
        ,PHONE
        ,ISNULL(HPHONE,'''') AS HPHONE
        ,BIZ_CD
        ,AREA_A
        ,AREA_B
        ,AREA_C
        ,ISNULL(AREA_DETAIL,'''') AS AREA_DETAIL
        ,ISNULL(HOMEPAGE,'''') AS HOMEPAGE
        ,TITLE
        ,CONTENTS
        ,THEME_CD
        ,PAY_CD
        ,PAY_AMT
        ,ISNULL(BIZ_NUMBER,'''') AS BIZ_NUMBER
        ,ISNULL(LOGO_IMG,'''') AS LOGO_IMG
        ,START_DT
        ,END_DT
        ,MAP_X
        ,MAP_Y
    FROM dbo.PJ_AD_PUBLISH_TENS_TB
   WHERE 1 = 1 '+ @SQL_WHERE +')
  SELECT * FROM RESULT_TABLE
   WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
     AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
   ORDER BY START_DT DESC'

  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @LISTCOUNT OUTPUT

  SET @TOTALCOUNT = @LISTCOUNT





GO
/****** Object:  StoredProcedure [dbo].[BAT_DAILY_INPUT_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 신문 데이터 가져오기 (스케쥴)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/04/12
 *  수   정   자 : 김 민 석 (rocker76@mediawill.com)
 *  수   정   일 : 2010.03.15
 *  수   정   자 : 최 봉 기 (virtualman@mediawill.com)
 *  수   정   일 : 2012/02/08
 *  수   정   자 : 김성준
 *  수   정   일 : 2013/09/03
 *  설        명 :
 *  주 의  사 항 : 매일 04:30에 실행
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_DAILY_INPUT_PROC
 *************************************************************************************/

CREATE PROC [dbo].[BAT_DAILY_INPUT_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 줄광고 등록을 위한 임시 테이블 생성
  CREATE TABLE #DAILY_JOBPAPER_TB (
  	LINEADID int NOT NULL ,
  	CODE int NOT NULL ,
  	INPUTBRANCH int NOT NULL ,
  	LAYOUTBRANCH int NOT NULL ,
  	USERNAME varchar (30) COLLATE Korean_Wansung_CI_AS NULL ,
  	CONAME varchar (200) COLLATE Korean_Wansung_CI_AS NULL ,
  	PHONE varchar (172) COLLATE Korean_Wansung_CI_AS NULL ,
  	HPHONE varchar (15) COLLATE Korean_Wansung_CI_AS NULL ,
  	EMAIL varchar (100) COLLATE Korean_Wansung_CI_AS NULL ,
  	URL varchar (100) COLLATE Korean_Wansung_CI_AS NULL ,
  	OPTTYPE char (1) COLLATE Korean_Wansung_CI_AS NULL ,
  	TITLE nvarchar (512) COLLATE Korean_Wansung_CI_AS NULL ,
  	CONTENTS nvarchar (4000) COLLATE Korean_Wansung_CI_AS NULL ,
  	MERGETEXT varchar (900) COLLATE Korean_Wansung_CI_AS NULL ,
  	ORDERNO tinyint NULL ,
  	METRO varchar (50) COLLATE Korean_Wansung_CI_AS NULL ,
  	CITY varchar (50) COLLATE Korean_Wansung_CI_AS NULL ,
  	DONG varchar (50) COLLATE Korean_Wansung_CI_AS NULL ,
  	ADDR_DETAIL varchar (50) COLLATE Korean_Wansung_CI_AS NULL ,
  	LOCALSITE tinyint NULL ,
  	REGDATE varchar (10) COLLATE Korean_Wansung_CI_AS NULL ,
  	STARTDATE smalldatetime NULL ,
  	ENDDATE smalldatetime NULL ,
  	END_YN char (1) COLLATE Korean_Wansung_CI_AS NULL ,
  	IDENTYFLAG bit NULL DEFAULT (1),
  	MAP_X int NULL DEFAULT (0),
  	MAP_Y int NULL DEFAULT (0),
  )

  -- 줄광고 데이터 임시테이블에 저장
  INSERT INTO #DAILY_JOBPAPER_TB
    (LINEADID, CODE, INPUTBRANCH, LAYOUTBRANCH, USERNAME, CONAME, PHONE, HPHONE, EMAIL, URL, OPTTYPE, TITLE, CONTENTS, MERGETEXT, ORDERNO, METRO, CITY, DONG, ADDR_DETAIL, LOCALSITE, REGDATE, STARTDATE, ENDDATE, END_YN, MAP_X, MAP_Y, IDENTYFLAG)
	SELECT A.LINEADID AS LINEADID
    		, CASE A.FINDCODE WHEN 4909003 THEN 40100
                          WHEN 4909004 THEN 40200
                          WHEN 4909001 THEN 40300
                          WHEN 4909002 THEN 40400
                          WHEN 4909005 THEN 40600
                          WHEN 4909006 THEN 40200
                          WHEN 4909007 THEN 40500
          ELSE 0 END CODE
    		, CASE WHEN A.INPUT_BRANCH IN (16,17) THEN 201
    			   WHEN A.INPUT_BRANCH IN (20,22) THEN 202
    			   WHEN A.INPUT_BRANCH IN (19,23) THEN 203
    			   WHEN A.INPUT_BRANCH IN (21,18,24) THEN 204
    		  ELSE A.INPUT_BRANCH
    		  END AS INPUTBRANCH
    		, A.LAYOUT_BRANCH AS LAYOUTBRANCH
    		, A.ORDER_NAME AS USERNAME
        , DBO.GOALBA_NAME_CONVERT_FUNC(ISNULL(A.FIELD_6,'야알바')) AS CONAME
    		, A.PHONE
    		, NULL AS HPHONE
    		, NULL AS EMAIL
    		, A.FIELD_11 AS URL
    		, 0 AS OPTTYPE
    		, NULL AS TITLE
    		, DBO.GOALBA_NAME_CONVERT_FUNC(A.CONTENTS) + ' ' + ISNULL(A.FIELD_11, '') AS CONTENTS
        , A.ORDER_NAME+' '+A.PHONE+' '+DBO.GOALBA_NAME_CONVERT_FUNC(A.CONTENTS) AS MERGETEXT
        , '1' AS ORDERNO
				/*
        , CASE WHEN A.AREA_A = '강원' THEN '강원도'
    		       WHEN A.AREA_A = '경기' THEN '경기도'
    		       WHEN A.AREA_A = '경남' THEN '경상남도'
    		       WHEN A.AREA_A = '경북' THEN '경상북도'
    		       WHEN A.AREA_A = '광주' THEN '광주광역시'
    		       WHEN A.AREA_A = '기타' THEN '기타'
    		       WHEN A.AREA_A = '대구' THEN '대구광역시'
    		       WHEN A.AREA_A = '대전' THEN '대전광역시'
    		       WHEN A.AREA_A = '부산' THEN '부산광역시'
    		       WHEN A.AREA_A IN ('서울', '서울시') THEN '서울특별시'
    		       WHEN A.AREA_A = '울산' THEN '울산광역시'
    		       WHEN A.AREA_A = '인천' THEN '인천광역시'
    		       WHEN A.AREA_A = '전남' THEN '전라남도'
    		       WHEN A.AREA_A = '전북' THEN '전라북도'
    		       WHEN A.AREA_A = '제주' THEN '제주도'
    		       WHEN A.AREA_A = '충남' THEN '충청남도'
    		       WHEN A.AREA_A = '충북' THEN '충청북도'
    		       WHEN A.AREA_A = '세종' THEN '세종특별시'
    		       WHEN A.AREA_A = '전국' THEN '전국'
               ELSE '기타'
    	    END AS METRO
				*/
				, CASE WHEN A.AREA_A IN ('서울', '서울시') THEN '서울' ELSE A.AREA_A END AS METRO
        , A.AREA_B AS CITY
        , A.AREA_C AS DONG
        , A.AREA_DETAIL AS ADDR_DETAIL
    	  , (SELECT LOCALSITE FROM FINDDB2.FINDCOMMON.DBO.BRANCH X WHERE X.BRANCHCODE = A.LAYOUT_BRANCH) AS LOCALSITE
        , CONVERT(VARCHAR(10), A.SYSDATE, 120) AS REGDATE
        , A.START_DT AS STARTDATE
        , A.END_DT AS ENDDATE
        , 'Y' AS END_YN
        , B.MAP_X
        , B.MAP_Y
        , NULL AS IDENTYFLAG
  FROM FINDDB1.PAPER_NEW.DBO.TEMP_PP_LINE_AD_ORG_TB AS A
     LEFT JOIN FINDDB1.PAPER_NEW.DBO.PP_LINE_AD_EXTEND_DETAIL_TB AS B
       ON B.LINEADID = A.LINEADID
      AND B.INPUT_BRANCH = A.INPUT_BRANCH
      AND B.LAYOUT_BRANCH = A.LAYOUT_BRANCH
  WHERE A.GROUP_CD = 14
	AND A.FINDCODE LIKE '490%'
	AND A.INPUT_BRANCH <> 70
	AND A.AREA_A <> '기타'
	AND DBO.GOALBA_NAME_EXISTS_FUNC(ISNULL(A.CONTENTS, '') + ISNULL(A.FIELD_6, '') + ISNULL(A.FIELD_11, '')) = 0;

  --// 연합광고 선별
  SELECT LINEADID
        ,INPUTBRANCH
        ,MIN(LAYOUTBRANCH) AS LAYOUTBRANCH
    INTO #ALLI_LINE_AD_TB
    FROM #DAILY_JOBPAPER_TB
   GROUP BY LINEADID,INPUTBRANCH
  HAVING COUNT(*) > 1

  -- 연합광고 값 넣어주기
  UPDATE A SET IDENTYFLAG = '0'
    FROM #DAILY_JOBPAPER_TB AS A
      JOIN #ALLI_LINE_AD_TB AS B
       ON B.LINEADID = A.LINEADID
      AND B.INPUTBRANCH = A.INPUTBRANCH

  -- 연합광고 값중 한개만 대표로
  UPDATE B SET IDENTYFLAG = '1'
    FROM #ALLI_LINE_AD_TB AS A
      JOIN #DAILY_JOBPAPER_TB AS B
       ON A.LINEADID = B.LINEADID
      AND A.INPUTBRANCH = B.INPUTBRANCH
      AND A.LAYOUTBRANCH = B.LAYOUTBRANCH

  -- 연합광고중 대표외에 광고삭제
  DELETE
    FROM #DAILY_JOBPAPER_TB
   WHERE IDENTYFLAG = 0;

  -- 광고번호 중복광고 삭제
  SELECT LINEADID
        ,COUNT(*) AS CNT
    INTO #DEL_ADID_TB
    FROM #DAILY_JOBPAPER_TB
   GROUP BY LINEADID
  HAVING COUNT(*) > 1;

  DELETE
    FROM #DAILY_JOBPAPER_TB
   WHERE LINEADID IN (SELECT LINEADID FROM #DEL_ADID_TB);

	--신문에서 넘어온 기타항목중 노래주점내역 코드변경
	UPDATE #DAILY_JOBPAPER_TB
     SET CODE = '40300'
   WHERE (CONTENTS LIKE '%노래도우미%' OR
       		CONTENTS LIKE '%노래 도우미%' OR
       		CONTENTS LIKE '%노래보조%' OR
       		CONTENTS LIKE '%노 래 도 우 미%' OR
       		CONTENTS LIKE '%노 래 방 도 우 미%' OR
       		CONTENTS LIKE '%노래장도우미%' OR
       		CONTENTS LIKE '%노래 도우미%' OR
       		CONTENTS LIKE '%가요도우미%' OR
       		CONTENTS LIKE '%가요 도우미%' OR
       		CONTENTS LIKE '%가요방도우미%' OR
       		CONTENTS LIKE '%가요방 도우미%')
     AND CODE = '40600';

	--신문테이블 특수문자 치환
	UPDATE #DAILY_JOBPAPER_TB
     SET CONTENTS = REPLACE(CONTENTS,'$',' ')
   WHERE CONTENTS LIKE '%$%';

	UPDATE #DAILY_JOBPAPER_TB
     SET CONAME = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONAME,'^',''),'$',''),'[',''),']',''),'<',''),'>',''),'「',''),'」','')
	 WHERE CONAME LIKE '%^%' OR CONAME LIKE '%$%' OR CONAME LIKE '%[%' OR CONAME LIKE '%]%' OR CONAME LIKE '%<%' OR CONAME LIKE '%>%' OR CONAME LIKE '%「%' OR CONAME LIKE '%」%';

	-- 일반줄광고 컬러옵션 표시 제거1
	UPDATE #DAILY_JOBPAPER_TB
     SET CONTENTS = REPLACE(REPLACE(REPLACE(REPLACE(CONTENTS,'ⓝ☎',''),'$',''),'■',''),'^','');

	-- 일반줄광고 컬러옵션 표시 제거2
	UPDATE #DAILY_JOBPAPER_TB
	   SET CONTENTS = REPLACE(CONTENTS,CHAR(13)+CHAR(10),'');

	-- 일반줄광고 컬러옵션 표시 제거3
	UPDATE #DAILY_JOBPAPER_TB
	   SET PHONE = REPLACE(REPLACE(PHONE,'$',''),'ⓒ','');

  -- 신규 줄광고 등록
  INSERT INTO DAILY_JOBPAPER_TB
    (A.LINEADID, A.CODE, A.INPUTBRANCH, A.LAYOUTBRANCH, A.USERNAME, A.CONAME, A.PHONE, A.HPHONE, A.EMAIL, A.URL, A.OPTTYPE, A.TITLE, A.CONTENTS, A.MERGETEXT, A.ORDERNO, A.METRO, A.CITY, A.DONG, A.ADDR_DETAIL, A.LOCALSITE, A.REGDATE, A.STARTDATE, A.ENDDATE, A.END_YN, A.IDENTYFLAG, A.MAP_X, A.MAP_Y)
  SELECT A.LINEADID, A.CODE, A.INPUTBRANCH, A.LAYOUTBRANCH, A.USERNAME, A.CONAME, A.PHONE, A.HPHONE, A.EMAIL, A.URL, A.OPTTYPE, A.TITLE, A.CONTENTS, A.MERGETEXT, A.ORDERNO, A.METRO, A.CITY, A.DONG, A.ADDR_DETAIL, A.LOCALSITE, A.REGDATE, A.STARTDATE, A.ENDDATE, A.END_YN, ISNULL(A.IDENTYFLAG,0), A.MAP_X, A.MAP_Y
    FROM #DAILY_JOBPAPER_TB AS A
    LEFT JOIN DAILY_JOBPAPER_TB AS B
      ON B.LINEADID = A.LINEADID
     AND B.INPUTBRANCH = A.INPUTBRANCH
     --AND B.LAYOUTBRANCH = A.LAYOUTBRANCH
   WHERE B.LINEADID IS NULL

  -- 신문줄광고의 내용 반영
  UPDATE A
     SET A.USERNAME = B.USERNAME
        ,A.CONAME = B.CONAME
        ,A.PHONE = B.PHONE
        ,A.CONTENTS = B.CONTENTS
        ,A.MERGETEXT = B.MERGETEXT
        ,A.METRO = B.METRO
        ,A.CITY = B.CITY
        ,A.DONG = B.DONG
        ,A.ADDR_DETAIL = B.ADDR_DETAIL
        ,A.MAP_X = B.MAP_X
        ,A.MAP_Y = B.MAP_Y
        ,A.STARTDATE = B.STARTDATE
        ,A.ENDDATE = B.ENDDATE
        ,A.CODE = B.CODE
    FROM DAILY_JOBPAPER_TB AS A
      JOIN #DAILY_JOBPAPER_TB AS B
        ON B.LINEADID = A.LINEADID
       AND B.INPUTBRANCH = A.INPUTBRANCH
       --AND B.LAYOUTBRANCH = A.LAYOUTBRANCH

	--지역이 입력이 안된 경우 게재지점의 지역으로 매칭
	UPDATE TA
     SET TA.METRO=TB.METRO
        ,TA.CITY=TB.CITY
    FROM dbo.DAILY_JOBPAPER_TB AS TA
         INNER JOIN dbo.BAT_BRANCH_AREA_MATCH_TB AS TB ON TA.LAYOUTBRANCH = TB.LAYOUTBRANCH
   WHERE TA.METRO ='' OR TA.METRO IS NULL OR TA.METRO ='기타';

	--동이 공백으로 입력된 경우 기타로 업데이트
	UPDATE DBO.DAILY_JOBPAPER_TB
     SET DONG='기타'
   WHERE DONG=''

  -- 종료일이 3개월이 지난 광고 삭제
  DELETE
    FROM DAILY_JOBPAPER_TB
   WHERE ENDDATE < DATEADD(M,-3,GETDATE())

  -- LINEADID, INPUTBRANCH 중복 데이터 삭제(대표광고 제외)
  SELECT LINEADID, COUNT(*) AS CNT
    INTO #DEL_AD_TB
    FROM DAILY_JOBPAPER_TB
   GROUP BY LINEADID
  HAVING COUNT(*) > 1;

  DELETE
    FROM DAILY_JOBPAPER_TB
   WHERE LINEADID IN (SELECT LINEADID FROM #DEL_AD_TB)
     AND IDENTYFLAG = 0;

	--// 기존 금지어 광고 마감처리 [(END_YN = 'Y') 로 변경처리]
	--SELECT *
	UPDATE A SET A.END_YN = 'Y'
	FROM DAILY_JOBPAPER_TB A
	WHERE DBO.GOALBA_NAME_EXISTS_FUNC(CONTENTS) > 0
	  AND END_YN = 'N'
    AND CONVERT(VARCHAR(10),ENDDATE,120) >= CONVERT(VARCHAR(10),GETDATE(),120)

  --// 옵션 데이터 삭제후 등록
  DELETE
    FROM PJ_OPTION_TB
   WHERE AD_KIND = 'P';

  INSERT INTO PJ_OPTION_TB
    (ADID, AD_KIND, LOCAL_CD)
  SELECT LINEADID AS ADID
        ,'P' AS AD_KIND
        ,CASE LAYOUTBRANCH WHEN 11 THEN 2  -- 대구/경북
                           WHEN 39 THEN 2  -- 구미
                           WHEN 60 THEN 2  -- 영주
                           WHEN 47 THEN 2  -- 울산
                           WHEN 26 THEN 2  -- 포항
                           WHEN 25 THEN 4  -- 부산/경남
                           WHEN 41 THEN 4  -- 경주
                           WHEN 34 THEN 4  -- 김해장유
                           WHEN 35 THEN 4  -- 창원(마창)
                           WHEN 49 THEN 4  -- 양산
                           WHEN 48 THEN 4  -- 진주
                           WHEN 46 THEN 4  -- 한려
                           ELSE 1          -- 전국
          END AS LOCAL_CD
    FROM DAILY_JOBPAPER_TB
   WHERE END_YN = 'N'
    AND CONVERT(VARCHAR(10),ENDDATE,120) >= CONVERT(VARCHAR(10),GETDATE(),120)







GO
/****** Object:  StoredProcedure [dbo].[BAT_DAILY_INPUT_PROC_20130812_BACKUP]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 신문 데이터 가져오기 (스케쥴)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/04/12
 *  수   정   자 : 김 민 석 (rocker76@mediawill.com)
 *  수   정   일 : 2010.03.15
 *  수   정   자 : 최 봉 기 (virtualman@mediawill.com)
 *  수   정   일 : 2012/02/08
 *  설        명 :
 *  주 의  사 항 : 매일 04:30에 실행
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_DAILY_INPUT_PROC
 *************************************************************************************/

CREATE PROC [dbo].[BAT_DAILY_INPUT_PROC_20130812_BACKUP]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 줄광고 등록을 위한 임시 테이블 생성
  CREATE TABLE #DAILY_JOBPAPER_TB (
  	LINEADID int NOT NULL ,
  	CODE int NOT NULL ,
  	INPUTBRANCH int NOT NULL ,
  	LAYOUTBRANCH int NOT NULL ,
  	USERNAME varchar (30) COLLATE Korean_Wansung_CI_AS NULL ,
  	CONAME varchar (200) COLLATE Korean_Wansung_CI_AS NULL ,
  	PHONE varchar (172) COLLATE Korean_Wansung_CI_AS NULL ,
  	HPHONE varchar (15) COLLATE Korean_Wansung_CI_AS NULL ,
  	EMAIL varchar (100) COLLATE Korean_Wansung_CI_AS NULL ,
  	URL varchar (100) COLLATE Korean_Wansung_CI_AS NULL ,
  	OPTTYPE char (1) COLLATE Korean_Wansung_CI_AS NULL ,
  	TITLE nvarchar (512) COLLATE Korean_Wansung_CI_AS NULL ,
  	CONTENTS nvarchar (4000) COLLATE Korean_Wansung_CI_AS NULL ,
  	MERGETEXT varchar (900) COLLATE Korean_Wansung_CI_AS NULL ,
  	ORDERNO tinyint NULL ,
  	METRO varchar (50) COLLATE Korean_Wansung_CI_AS NULL ,
  	CITY varchar (50) COLLATE Korean_Wansung_CI_AS NULL ,
  	DONG varchar (50) COLLATE Korean_Wansung_CI_AS NULL ,
  	ADDR_DETAIL varchar (50) COLLATE Korean_Wansung_CI_AS NULL ,
  	LOCALSITE tinyint NULL ,
  	REGDATE varchar (10) COLLATE Korean_Wansung_CI_AS NULL ,
  	STARTDATE smalldatetime NULL ,
  	ENDDATE smalldatetime NULL ,
  	END_YN char (1) COLLATE Korean_Wansung_CI_AS NULL ,
  	IDENTYFLAG bit NULL DEFAULT (1),
  	MAP_X int NULL DEFAULT (0),
  	MAP_Y int NULL DEFAULT (0),
  )

  -- 줄광고 데이터 임시테이블에 저장
  INSERT INTO #DAILY_JOBPAPER_TB
    (LINEADID, CODE, INPUTBRANCH, LAYOUTBRANCH, USERNAME, CONAME, PHONE, HPHONE, EMAIL, URL, OPTTYPE, TITLE, CONTENTS, MERGETEXT, ORDERNO, METRO, CITY, DONG, ADDR_DETAIL, LOCALSITE, REGDATE, STARTDATE, ENDDATE, END_YN, MAP_X, MAP_Y, IDENTYFLAG)
	SELECT A.LINEADID AS LINEADID
    		, CASE A.FINDCODE WHEN 4101103 THEN 40100
                          WHEN 4101104 THEN 40200
                          WHEN 4101101 THEN 40300
                          WHEN 4101102 THEN 40400
                          WHEN 4101105 THEN 40600
                          WHEN 4101106 THEN 40200
                          WHEN 4101107 THEN 40500
          ELSE 0 END CODE
    		, CASE WHEN A.INPUT_BRANCH IN (16,17) THEN 201
    			   WHEN A.INPUT_BRANCH IN (20,22) THEN 202
    			   WHEN A.INPUT_BRANCH IN (19,23) THEN 203
    			   WHEN A.INPUT_BRANCH IN (21,18,24) THEN 204
    		  ELSE A.INPUT_BRANCH
    		  END AS INPUTBRANCH
    		, A.LAYOUT_BRANCH AS LAYOUTBRANCH
    		, A.ORDER_NAME AS USERNAME
        , DBO.GOALBA_NAME_CONVERT_FUNC(ISNULL(A.FIELD_6,'야알바')) AS CONAME
    		, A.PHONE
    		, NULL AS HPHONE
    		, NULL AS EMAIL
    		, A.FIELD_11 AS URL
    		, 0 AS OPTTYPE
    		, NULL AS TITLE
    		, DBO.GOALBA_NAME_CONVERT_FUNC(A.CONTENTS) + ' ' + ISNULL(A.FIELD_11, '') AS CONTENTS
        , A.ORDER_NAME+' '+A.PHONE+' '+DBO.GOALBA_NAME_CONVERT_FUNC(A.CONTENTS) AS MERGETEXT
        , '1' AS ORDERNO
        , CASE WHEN A.AREA_A = '강원' THEN '강원도'
    		   WHEN A.AREA_A = '경기' THEN '경기도'
    		   WHEN A.AREA_A = '경남' THEN '경상남도'
    		   WHEN A.AREA_A = '경북' THEN '경상북도'
    		   WHEN A.AREA_A = '광주' THEN '광주광역시'
    		   WHEN A.AREA_A = '기타' THEN '기타'
    		   WHEN A.AREA_A = '대구' THEN '대구광역시'
    		   WHEN A.AREA_A = '대전' THEN '대전광역시'
    		   WHEN A.AREA_A = '부산' THEN '부산광역시'
    		   WHEN A.AREA_A IN ('서울', '서울시') THEN '서울특별시'
    		   WHEN A.AREA_A = '울산' THEN '울산광역시'
    		   WHEN A.AREA_A = '인천' THEN '인천광역시'
    		   WHEN A.AREA_A = '전남' THEN '전라남도'
    		   WHEN A.AREA_A = '전북' THEN '전라북도'
    		   WHEN A.AREA_A = '제주' THEN '제주도'
    		   WHEN A.AREA_A = '충남' THEN '충청남도'
    		   WHEN A.AREA_A = '충북' THEN '충청북도'
    	  END AS METRO
        , A.AREA_B AS CITY
        , A.AREA_C AS DONG
        , A.AREA_DETAIL AS ADDR_DETAIL
    	  , (SELECT LOCALSITE FROM FINDDB2.FINDCOMMON.DBO.BRANCH X WHERE X.BRANCHCODE = A.LAYOUT_BRANCH) AS LOCALSITE
        , CONVERT(VARCHAR(10), A.SYSDATE, 120) AS REGDATE
        , A.START_DT AS STARTDATE
        , A.END_DT AS ENDDATE
        , 'Y' AS END_YN
        , B.MAP_X
        , B.MAP_Y
        , NULL AS IDENTYFLAG
  FROM FINDDB1.PAPER_NEW.DBO.TEMP_PP_LINE_AD_ORG_TB AS A
     LEFT JOIN FINDDB1.PAPER_NEW.DBO.PP_LINE_AD_EXTEND_DETAIL_TB AS B
       ON B.LINEADID = A.LINEADID
      AND B.INPUT_BRANCH = A.INPUT_BRANCH
      AND B.LAYOUT_BRANCH = A.LAYOUT_BRANCH
    -- UNIFICATION_S1.UNILINEDB1.dbo.OnLineRelation
  WHERE A.GROUP_CD = '14'
  	AND A.FINDCODE LIKE '41011%'
  	AND A.INPUT_BRANCH <> 70;

  --// 연합광고 선별
  SELECT LINEADID
        ,INPUTBRANCH
        ,MIN(LAYOUTBRANCH) AS LAYOUTBRANCH
    INTO #ALLI_LINE_AD_TB
    FROM #DAILY_JOBPAPER_TB
   GROUP BY LINEADID,INPUTBRANCH
  HAVING COUNT(*) > 1

  -- 연합광고 값 넣어주기
  UPDATE A SET IDENTYFLAG = '0'
    FROM #DAILY_JOBPAPER_TB AS A
      JOIN #ALLI_LINE_AD_TB AS B
       ON B.LINEADID = A.LINEADID
      AND B.INPUTBRANCH = A.INPUTBRANCH

  -- 연합광고 값중 한개만 대표로
  UPDATE B SET IDENTYFLAG = '1'
    FROM #ALLI_LINE_AD_TB AS A
      JOIN #DAILY_JOBPAPER_TB AS B
       ON A.LINEADID = B.LINEADID
      AND A.INPUTBRANCH = B.INPUTBRANCH
      AND A.LAYOUTBRANCH = B.LAYOUTBRANCH

  -- 연합광고중 대표외에 광고삭제
  DELETE
    FROM #DAILY_JOBPAPER_TB
   WHERE IDENTYFLAG = 0;

  -- 광고번호 중복광고 삭제
  SELECT LINEADID
        ,COUNT(*) AS CNT
    INTO #DEL_ADID_TB
    FROM #DAILY_JOBPAPER_TB
   GROUP BY LINEADID
  HAVING COUNT(*) > 1;

  DELETE
    FROM #DAILY_JOBPAPER_TB
   WHERE LINEADID IN (SELECT LINEADID FROM #DEL_ADID_TB);

	--신문에서 넘어온 기타항목중 노래주점내역 코드변경
	UPDATE #DAILY_JOBPAPER_TB
     SET CODE = '40300'
   WHERE (CONTENTS LIKE '%노래도우미%' OR
       		CONTENTS LIKE '%노래 도우미%' OR
       		CONTENTS LIKE '%노래보조%' OR
       		CONTENTS LIKE '%노 래 도 우 미%' OR
       		CONTENTS LIKE '%노 래 방 도 우 미%' OR
       		CONTENTS LIKE '%노래장도우미%' OR
       		CONTENTS LIKE '%노래 도우미%' OR
       		CONTENTS LIKE '%가요도우미%' OR
       		CONTENTS LIKE '%가요 도우미%' OR
       		CONTENTS LIKE '%가요방도우미%' OR
       		CONTENTS LIKE '%가요방 도우미%')
     AND CODE = '40600';

	--신문테이블 특수문자 치환
	UPDATE #DAILY_JOBPAPER_TB
     SET CONTENTS = REPLACE(CONTENTS,'$',' ')
   WHERE CONTENTS LIKE '%$%';

	UPDATE #DAILY_JOBPAPER_TB
     SET CONAME = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONAME,'^',''),'$',''),'[',''),']',''),'<',''),'>',''),'「',''),'」','')
	 WHERE CONAME LIKE '%^%' OR CONAME LIKE '%$%' OR CONAME LIKE '%[%' OR CONAME LIKE '%]%' OR CONAME LIKE '%<%' OR CONAME LIKE '%>%' OR CONAME LIKE '%「%' OR CONAME LIKE '%」%';

	-- 일반줄광고 컬러옵션 표시 제거1
	UPDATE #DAILY_JOBPAPER_TB
     SET CONTENTS = REPLACE(REPLACE(REPLACE(REPLACE(CONTENTS,'ⓝ☎',''),'$',''),'■',''),'^','');

	-- 일반줄광고 컬러옵션 표시 제거2
	UPDATE #DAILY_JOBPAPER_TB
	   SET CONTENTS = REPLACE(CONTENTS,CHAR(13)+CHAR(10),'');

	-- 일반줄광고 컬러옵션 표시 제거3
	UPDATE #DAILY_JOBPAPER_TB
	   SET PHONE = REPLACE(REPLACE(PHONE,'$',''),'ⓒ','');

  -- 신규 줄광고 등록
  INSERT INTO DAILY_JOBPAPER_TB
    (A.LINEADID, A.CODE, A.INPUTBRANCH, A.LAYOUTBRANCH, A.USERNAME, A.CONAME, A.PHONE, A.HPHONE, A.EMAIL, A.URL, A.OPTTYPE, A.TITLE, A.CONTENTS, A.MERGETEXT, A.ORDERNO, A.METRO, A.CITY, A.DONG, A.ADDR_DETAIL, A.LOCALSITE, A.REGDATE, A.STARTDATE, A.ENDDATE, A.END_YN, A.IDENTYFLAG, A.MAP_X, A.MAP_Y)
  SELECT A.LINEADID, A.CODE, A.INPUTBRANCH, A.LAYOUTBRANCH, A.USERNAME, A.CONAME, A.PHONE, A.HPHONE, A.EMAIL, A.URL, A.OPTTYPE, A.TITLE, A.CONTENTS, A.MERGETEXT, A.ORDERNO, A.METRO, A.CITY, A.DONG, A.ADDR_DETAIL, A.LOCALSITE, A.REGDATE, A.STARTDATE, A.ENDDATE, A.END_YN, ISNULL(A.IDENTYFLAG,0), A.MAP_X, A.MAP_Y
    FROM #DAILY_JOBPAPER_TB AS A
    LEFT JOIN DAILY_JOBPAPER_TB AS B
      ON B.LINEADID = A.LINEADID
     AND B.INPUTBRANCH = A.INPUTBRANCH
     --AND B.LAYOUTBRANCH = A.LAYOUTBRANCH
   WHERE B.LINEADID IS NULL

  -- 신문줄광고의 내용 반영
  UPDATE A
     SET A.USERNAME = B.USERNAME
        ,A.CONAME = B.CONAME
        ,A.PHONE = B.PHONE
        ,A.CONTENTS = B.CONTENTS
        ,A.MERGETEXT = B.MERGETEXT
        ,A.METRO = B.METRO
        ,A.CITY = B.CITY
        ,A.DONG = B.DONG
        ,A.ADDR_DETAIL = B.ADDR_DETAIL
        ,A.MAP_X = B.MAP_X
        ,A.MAP_Y = B.MAP_Y
        ,A.STARTDATE = B.STARTDATE
        ,A.ENDDATE = B.ENDDATE
        ,A.CODE = B.CODE
    FROM DAILY_JOBPAPER_TB AS A
      JOIN #DAILY_JOBPAPER_TB AS B
        ON B.LINEADID = A.LINEADID
       AND B.INPUTBRANCH = A.INPUTBRANCH
       --AND B.LAYOUTBRANCH = A.LAYOUTBRANCH

	--지역이 입력이 안된 경우 게재지점의 지역으로 매칭
	UPDATE TA
     SET TA.METRO=TB.METRO        ,TA.CITY=TB.CITY    FROM dbo.DAILY_JOBPAPER_TB AS TA
         INNER JOIN dbo.BAT_BRANCH_AREA_MATCH_TB AS TB ON TA.LAYOUTBRANCH = TB.LAYOUTBRANCH
   WHERE TA.METRO ='' OR TA.METRO IS NULL OR TA.METRO ='기타';

	--동이 공백으로 입력된 경우 기타로 업데이트
	UPDATE DBO.DAILY_JOBPAPER_TB
     SET DONG='기타'
   WHERE DONG=''

  -- 종료일이 3개월이 지난 광고 삭제
  DELETE
    FROM DAILY_JOBPAPER_TB
   WHERE ENDDATE < DATEADD(M,-3,GETDATE())

  -- LINEADID, INPUTBRANCH 중복 데이터 삭제(대표광고 제외)
  SELECT LINEADID, COUNT(*) AS CNT
    INTO #DEL_AD_TB
    FROM DAILY_JOBPAPER_TB
   GROUP BY LINEADID
  HAVING COUNT(*) > 1;

  DELETE
    FROM DAILY_JOBPAPER_TB
   WHERE LINEADID IN (SELECT LINEADID FROM #DEL_AD_TB)
     AND IDENTYFLAG = 0;

  --// 옵션 데이터 삭제후 등록
  DELETE
    FROM PJ_OPTION_TB
   WHERE AD_KIND = 'P';

  INSERT INTO PJ_OPTION_TB
    (ADID, AD_KIND, LOCAL_CD)
  SELECT LINEADID AS ADID
        ,'P' AS AD_KIND
        ,CASE LAYOUTBRANCH WHEN 11 THEN 2  -- 대구/경북
                           WHEN 39 THEN 2  -- 구미
                           WHEN 60 THEN 2  -- 영주
                           WHEN 47 THEN 2  -- 울산
                           WHEN 26 THEN 2  -- 포항
                           WHEN 25 THEN 4  -- 부산/경남
                           WHEN 41 THEN 4  -- 경주
                           WHEN 34 THEN 4  -- 김해장유
                           WHEN 35 THEN 4  -- 창원(마창)
                           WHEN 49 THEN 4  -- 양산
                           WHEN 48 THEN 4  -- 진주
                           WHEN 46 THEN 4  -- 한려
                           ELSE 1          -- 전국
          END AS LOCAL_CD
    FROM DAILY_JOBPAPER_TB
   WHERE END_YN = 'N'
    AND CONVERT(VARCHAR(10),ENDDATE,120) >= CONVERT(VARCHAR(10),GETDATE(),120)





GO
/****** Object:  StoredProcedure [dbo].[BAT_HOLIDAYS_ADD_3DAYS_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 설연휴기간 유료광고 기일연장
 *  작   성   자 : 김성준
 *  작   성   일 : 2013/09/13
 *  수   정   자 : 김성준
 *  수   정   일 : 2014/01/29
 *  설        명 : 연장대상: E-COMM, 등록대행 (4일 연장)
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_HOLIDAYS_ADD_3DAYS_PROC
 *************************************************************************************/

CREATE PROC [dbo].[BAT_HOLIDAYS_ADD_3DAYS_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 1) E-COMM : 연휴기간유료광고 서브옵션 기일연장 (게재대상 광고만)
  BEGIN TRAN

		INSERT INTO PJ_OPTION_UPDATE_HISTORY_TB (ADID, AD_KIND,
			OPT_SUB_A_END_DT, OPT_SUB_B_END_DT, OPT_SUB_C_END_DT, OPT_SUB_D_END_DT, OPT_SUB_E_END_DT,
			CHANGE_OPT_SUB_A_END_DT, CHANGE_OPT_SUB_B_END_DT, CHANGE_OPT_SUB_C_END_DT, CHANGE_OPT_SUB_D_END_DT, CHANGE_OPT_SUB_E_END_DT)
		SELECT
			B.ADID, B.AD_KIND,
			B.OPT_SUB_A_END_DT,
			B.OPT_SUB_B_END_DT,
			B.OPT_SUB_C_END_DT,
			B.OPT_SUB_D_END_DT,
			B.OPT_SUB_E_END_DT,
			DATEADD(DD, 4, B.OPT_SUB_A_END_DT) AS OPT_SUB_A_END_DT,
			DATEADD(DD, 4, B.OPT_SUB_B_END_DT) AS OPT_SUB_B_END_DT,
			DATEADD(DD, 4, B.OPT_SUB_C_END_DT) AS OPT_SUB_C_END_DT,
			DATEADD(DD, 4, B.OPT_SUB_D_END_DT) AS OPT_SUB_D_END_DT,
			DATEADD(DD, 4, B.OPT_SUB_E_END_DT) AS OPT_SUB_E_END_DT
		FROM dbo.PJ_AD_USERREG_TB AS A
		JOIN dbo.PJ_OPTION_TB AS B
		ON B.ADID = A.ADID
		AND B.AD_KIND = 'U'
		WHERE EXISTS (SELECT '1' FROM dbo.PJ_AD_USERREG_TB X WHERE X.ADID = A.ADID AND X.CONFIRM_YN = 1 AND X.END_YN = 0 AND X.PAUSE_YN = 0)
		AND ((A.START_DT >= '2014-01-30' AND A.START_DT <= '2014-02-02')
		OR (A.END_DT >= '2014-01-30' AND A.END_DT <= '2014-02-02'))

  	UPDATE B
		SET B.OPT_SUB_A_END_DT = DATEADD(DD, 4, B.OPT_SUB_A_END_DT),
			B.OPT_SUB_B_END_DT = DATEADD(DD, 4, B.OPT_SUB_B_END_DT),
			B.OPT_SUB_C_END_DT = DATEADD(DD, 4, B.OPT_SUB_C_END_DT),
			B.OPT_SUB_D_END_DT = DATEADD(DD, 4, B.OPT_SUB_D_END_DT),
			B.OPT_SUB_E_END_DT = DATEADD(DD, 4, B.OPT_SUB_E_END_DT)
		--SELECT
		--	A.START_DT,
		--	B.OPT_SUB_A_END_DT,
		--	B.OPT_SUB_B_END_DT,
		--	B.OPT_SUB_C_END_DT,
		--	B.OPT_SUB_D_END_DT,
		--	B.OPT_SUB_E_END_DT,
		--	DATEADD(DD, 4, B.OPT_SUB_A_END_DT) AS OPT_SUB_A_END_DT,
		--	DATEADD(DD, 4, B.OPT_SUB_B_END_DT) AS OPT_SUB_B_END_DT,
		--	DATEADD(DD, 4, B.OPT_SUB_C_END_DT) AS OPT_SUB_C_END_DT,
		--	DATEADD(DD, 4, B.OPT_SUB_D_END_DT) AS OPT_SUB_D_END_DT,
		--	DATEADD(DD, 4, B.OPT_SUB_E_END_DT) AS OPT_SUB_E_END_DT
		FROM dbo.PJ_AD_USERREG_TB AS A
		JOIN dbo.PJ_OPTION_TB AS B
		ON B.ADID = A.ADID
		AND B.AD_KIND = 'U'
		WHERE EXISTS (SELECT '1' FROM dbo.PJ_AD_USERREG_TB X WHERE X.ADID = A.ADID AND X.CONFIRM_YN = 1 AND X.END_YN = 0 AND X.PAUSE_YN = 0)
		AND ((A.START_DT >= '2014-01-30' AND A.START_DT <= '2014-02-02')
		OR (A.END_DT >= '2014-01-30' AND A.END_DT <= '2014-02-02'))

  COMMIT TRAN

  -- 2) E-COMM : 연휴기간유료광고 기일연장 (게재대상 광고만)
  BEGIN TRAN

		INSERT INTO PJ_AD_USERREG_UPDATE_HISTORY_TB (ADID, START_DT, END_DT, CHANGE_END_DT, MOD_DT, AD_TYPE)
		SELECT A.ADID, A.START_DT, A.END_DT, DATEADD(DD, 4, A.END_DT) AS CHANGE_END_DT, GETDATE() AS MOD_DT, 'ECOMM' AS AD_TYPE
		FROM dbo.PJ_AD_USERREG_TB A
		WHERE EXISTS (SELECT '1' FROM dbo.PJ_AD_USERREG_TB X WHERE X.ADID = A.ADID AND X.CONFIRM_YN = 1 AND X.END_YN = 0 AND X.PAUSE_YN = 0)
		AND ((A.START_DT >= '2014-01-30' AND A.START_DT <= '2014-02-02')
		OR (A.END_DT >= '2014-01-30' AND A.END_DT <= '2014-02-02'))

  	UPDATE A
		SET A.END_DT = DATEADD(DD, 4, A.END_DT)
		--SELECT A.START_DT, A.END_DT, DATEADD(DD, 4, A.END_DT) AS END_DT
		FROM dbo.PJ_AD_USERREG_TB A
		WHERE EXISTS (SELECT '1' FROM dbo.PJ_AD_USERREG_TB X WHERE X.ADID = A.ADID AND X.CONFIRM_YN = 1 AND X.END_YN = 0 AND X.PAUSE_YN = 0)
		AND ((A.START_DT >= '2014-01-30' AND A.START_DT <= '2014-02-02')
		OR (A.END_DT >= '2014-01-30' AND A.END_DT <= '2014-02-02'))

  COMMIT TRAN

  -- 1) 등록대행 : 연휴기간유료광고 서브옵션 기일연장
  BEGIN TRAN

		INSERT INTO PJ_OPTION_UPDATE_HISTORY_TB (ADID, AD_KIND,
			OPT_SUB_A_END_DT, OPT_SUB_B_END_DT, OPT_SUB_C_END_DT, OPT_SUB_D_END_DT, OPT_SUB_E_END_DT,
			CHANGE_OPT_SUB_A_END_DT, CHANGE_OPT_SUB_B_END_DT, CHANGE_OPT_SUB_C_END_DT, CHANGE_OPT_SUB_D_END_DT, CHANGE_OPT_SUB_E_END_DT)
		SELECT
			B.ADID, B.AD_KIND,
			B.OPT_SUB_A_END_DT,
			B.OPT_SUB_B_END_DT,
			B.OPT_SUB_C_END_DT,
			B.OPT_SUB_D_END_DT,
			B.OPT_SUB_E_END_DT,
			DATEADD(DD, 4, B.OPT_SUB_A_END_DT) AS OPT_SUB_A_END_DT,
			DATEADD(DD, 4, B.OPT_SUB_B_END_DT) AS OPT_SUB_B_END_DT,
			DATEADD(DD, 4, B.OPT_SUB_C_END_DT) AS OPT_SUB_C_END_DT,
			DATEADD(DD, 4, B.OPT_SUB_D_END_DT) AS OPT_SUB_D_END_DT,
			DATEADD(DD, 4, B.OPT_SUB_E_END_DT) AS OPT_SUB_E_END_DT
		FROM dbo.PJ_AD_AGENCY_TB AS A
		JOIN dbo.PJ_OPTION_TB AS B
		ON B.ADID = A.ADID
		AND B.AD_KIND = 'A'
		WHERE EXISTS (SELECT '1' FROM dbo.PJ_AD_AGENCY_TB X WHERE X.ADID = A.ADID AND X.END_YN = 0 AND X.PAUSE_YN = 0)
		AND ((A.START_DT >= '2014-01-30' AND A.START_DT <= '2014-02-02')
		OR (A.END_DT >= '2014-01-30' AND A.END_DT <= '2014-02-02'))

  	UPDATE B
		SET B.OPT_SUB_A_END_DT = DATEADD(DD, 4, B.OPT_SUB_A_END_DT),
			B.OPT_SUB_B_END_DT = DATEADD(DD, 4, B.OPT_SUB_B_END_DT),
			B.OPT_SUB_C_END_DT = DATEADD(DD, 4, B.OPT_SUB_C_END_DT),
			B.OPT_SUB_D_END_DT = DATEADD(DD, 4, B.OPT_SUB_D_END_DT),
			B.OPT_SUB_E_END_DT = DATEADD(DD, 4, B.OPT_SUB_E_END_DT)
		--SELECT
		--	A.START_DT,
		--	B.OPT_SUB_A_END_DT,
		--	B.OPT_SUB_B_END_DT,
		--	B.OPT_SUB_C_END_DT,
		--	B.OPT_SUB_D_END_DT,
		--	B.OPT_SUB_E_END_DT,
		--	DATEADD(DD, 4, B.OPT_SUB_A_END_DT) AS OPT_SUB_A_END_DT,
		--	DATEADD(DD, 4, B.OPT_SUB_B_END_DT) AS OPT_SUB_B_END_DT,
		--	DATEADD(DD, 4, B.OPT_SUB_C_END_DT) AS OPT_SUB_C_END_DT,
		--	DATEADD(DD, 4, B.OPT_SUB_D_END_DT) AS OPT_SUB_D_END_DT,
		--	DATEADD(DD, 4, B.OPT_SUB_E_END_DT) AS OPT_SUB_E_END_DT
		FROM dbo.PJ_AD_AGENCY_TB AS A
		JOIN dbo.PJ_OPTION_TB AS B
		ON B.ADID = A.ADID
		AND B.AD_KIND = 'A'
		WHERE EXISTS (SELECT '1' FROM dbo.PJ_AD_AGENCY_TB X WHERE X.ADID = A.ADID AND X.END_YN = 0 AND X.PAUSE_YN = 0)
		AND ((A.START_DT >= '2014-01-30' AND A.START_DT <= '2014-02-02')
		OR (A.END_DT >= '2014-01-30' AND A.END_DT <= '2014-02-02'))

  COMMIT TRAN

  -- 2) 등록대행 : 연휴기간유료광고 기일연장
  BEGIN TRAN

		INSERT INTO PJ_AD_USERREG_UPDATE_HISTORY_TB (ADID, START_DT, END_DT, CHANGE_END_DT, MOD_DT, AD_TYPE)
		SELECT A.ADID, A.START_DT, A.END_DT, DATEADD(DD, 4, A.END_DT) AS CHANGE_END_DT, GETDATE() AS MOD_DT, 'AGENCY' AS AD_TYPE
		FROM dbo.PJ_AD_AGENCY_TB A
		WHERE EXISTS (SELECT '1' FROM dbo.PJ_AD_AGENCY_TB X WHERE X.ADID = A.ADID AND X.END_YN = 0 AND X.PAUSE_YN = 0)
		AND ((A.START_DT >= '2014-01-30' AND A.START_DT <= '2014-02-02')
		OR (A.END_DT >= '2014-01-30' AND A.END_DT <= '2014-02-02'))

  	UPDATE A
		SET A.END_DT = DATEADD(DD, 4, A.END_DT)
		--SELECT A.START_DT, A.END_DT, DATEADD(DD, 4, A.END_DT) AS END_DT
		FROM dbo.PJ_AD_AGENCY_TB A
		WHERE EXISTS (SELECT '1' FROM dbo.PJ_AD_AGENCY_TB X WHERE X.ADID = A.ADID AND X.END_YN = 0 AND X.PAUSE_YN = 0)
		AND ((A.START_DT >= '2014-01-30' AND A.START_DT <= '2014-02-02')
		OR (A.END_DT >= '2014-01-30' AND A.END_DT <= '2014-02-02'))

  COMMIT TRAN



GO
/****** Object:  StoredProcedure [dbo].[BAT_HOLIDAYS_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 연휴기간 유료광고 기간연장
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/09/05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 연장대상: E-COMM, 등록대행
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_HOLIDAYS_PROC
 *************************************************************************************/

CREATE PROC [dbo].[BAT_HOLIDAYS_PROC]

AS

  SET XACT_ABORT ON
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	DECLARE @TODAY VARCHAR(19)
	SET @TODAY = CONVERT(VARCHAR(10),GETDATE(),121)
	SET @TODAY = @TODAY + ' 00:00:00'

  -- 금일 E-Comm/등록대행 기간연장건 History Log
  BEGIN TRAN

    INSERT INTO dbo.PJ_OPTION_UPDATE_HISTORY_TB
    (ADID, AD_KIND, END_DT, OPT_SUB_A_END_DT, OPT_SUB_B_END_DT, OPT_SUB_C_END_DT, OPT_SUB_D_END_DT, OPT_SUB_E_END_DT, CHANGE_END_DT, CHANGE_OPT_SUB_A_END_DT, CHANGE_OPT_SUB_B_END_DT, CHANGE_OPT_SUB_C_END_DT, CHANGE_OPT_SUB_D_END_DT, CHANGE_OPT_SUB_E_END_DT)
    SELECT ADID, AD_KIND, END_DT, OPT_SUB_A_END_DT, OPT_SUB_B_END_DT, OPT_SUB_C_END_DT, OPT_SUB_D_END_DT, OPT_SUB_E_END_DT, CHANGE_END_DT, CHANGE_OPT_SUB_A_END_DT, CHANGE_OPT_SUB_B_END_DT, CHANGE_OPT_SUB_C_END_DT, CHANGE_OPT_SUB_D_END_DT, CHANGE_OPT_SUB_E_END_DT
      FROM (-- EComm
            SELECT A.ADID ,B.AD_KIND ,A.END_DT ,B.OPT_SUB_A_END_DT ,B.OPT_SUB_B_END_DT ,B.OPT_SUB_C_END_DT ,B.OPT_SUB_D_END_DT ,B.OPT_SUB_E_END_DT ,DATEADD(DD, 1, A.END_DT) AS CHANGE_END_DT ,DATEADD(DD, 1, B.OPT_SUB_A_END_DT) AS CHANGE_OPT_SUB_A_END_DT ,DATEADD(DD, 1, B.OPT_SUB_B_END_DT) AS CHANGE_OPT_SUB_B_END_DT,DATEADD(DD, 1, B.OPT_SUB_C_END_DT) AS CHANGE_OPT_SUB_C_END_DT, DATEADD(DD, 1, B.OPT_SUB_D_END_DT) AS CHANGE_OPT_SUB_D_END_DT, DATEADD(DD, 1, B.OPT_SUB_E_END_DT) AS CHANGE_OPT_SUB_E_END_DT
              FROM dbo.PJ_AD_USERREG_TB A
                LEFT JOIN dbo.PJ_OPTION_TB AS B
                  ON B.ADID = A.ADID
                  AND B.AD_KIND = 'U'
              WHERE A.CONFIRM_YN = 1
                AND A.END_YN = 0
                AND A.PAUSE_YN = 0
                AND A.END_DT >= @TODAY
          UNION ALL
            -- 등록대행
            SELECT A.ADID ,B.AD_KIND ,A.END_DT ,B.OPT_SUB_A_END_DT ,B.OPT_SUB_B_END_DT ,B.OPT_SUB_C_END_DT ,B.OPT_SUB_D_END_DT ,B.OPT_SUB_E_END_DT ,DATEADD(DD, 1, A.END_DT) AS CHANGE_END_DT ,DATEADD(DD, 1, B.OPT_SUB_A_END_DT) AS CHANGE_OPT_SUB_A_END_DT ,DATEADD(DD, 1, B.OPT_SUB_B_END_DT) AS CHANGE_OPT_SUB_B_END_DT,DATEADD(DD, 1, B.OPT_SUB_C_END_DT) AS CHANGE_OPT_SUB_C_END_DT, DATEADD(DD, 1, B.OPT_SUB_D_END_DT) AS CHANGE_OPT_SUB_D_END_DT, DATEADD(DD, 1, B.OPT_SUB_E_END_DT) AS CHANGE_OPT_SUB_E_END_DT
              FROM dbo.PJ_AD_AGENCY_TB A
                LEFT JOIN dbo.PJ_OPTION_TB AS B
                  ON B.ADID = A.ADID
                  AND B.AD_KIND = 'A'
              WHERE A.END_YN = 0
                AND A.PAUSE_YN = 0
                AND A.END_DT >= @TODAY
            ) AS A

  COMMIT TRAN

  BEGIN TRAN

    -- 1) E-COMM : 연휴기간유료광고 기간연장 (게재대상 광고만)
  	UPDATE A
       SET A.END_DT = B.CHANGE_END_DT
    --SELECT *
      FROM dbo.PJ_AD_USERREG_TB A
      JOIN PJ_OPTION_UPDATE_HISTORY_TB AS B
        ON B.ADID = A.ADID
     WHERE B.AD_KIND = 'U'
       AND B.REG_DT > @TODAY

    -- 2) 등록대행 : 연휴기간유료광고 기간연장
  	UPDATE A
       SET A.END_DT = B.CHANGE_END_DT
    --SELECT *
      FROM dbo.PJ_AD_AGENCY_TB A
      JOIN PJ_OPTION_UPDATE_HISTORY_TB AS B
        ON B.ADID = A.ADID
     WHERE B.AD_KIND = 'A'
       AND B.REG_DT > @TODAY

    -- 3) 연휴기간유료광고 서브옵션 기간연장 (E-COMM,등록대행)
  	UPDATE A
       SET A.OPT_SUB_A_END_DT = B.CHANGE_OPT_SUB_A_END_DT
          ,A.OPT_SUB_B_END_DT = B.CHANGE_OPT_SUB_B_END_DT
          ,A.OPT_SUB_C_END_DT = B.CHANGE_OPT_SUB_C_END_DT
          ,A.OPT_SUB_D_END_DT = B.CHANGE_OPT_SUB_D_END_DT
          ,A.OPT_SUB_E_END_DT = B.CHANGE_OPT_SUB_E_END_DT
    --SELECT *
      FROM dbo.PJ_OPTION_TB AS A
      JOIN PJ_OPTION_UPDATE_HISTORY_TB AS B
        ON B.ADID = A.ADID
       AND B.AD_KIND = A.AD_KIND
     WHERE B.REG_DT > @TODAY

  COMMIT TRAN




GO
/****** Object:  StoredProcedure [dbo].[BAT_INPUT_PUBLISH_ONLINE_DATA_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 스케쥴 > 오늘자 온라인광고 게제테이블로 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/12
 *  수   정   자 : 신 장 순 (jssin@mediawill.com)
 *  수   정   일 : 2015.02.02
 *  설        명 : 등록대행도 검수완료 된 데이터만 이관함
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_INPUT_PUBLISH_ONLINE_DATA_PROC 'A'
 *************************************************************************************/


CREATE PROC [dbo].[BAT_INPUT_PUBLISH_ONLINE_DATA_PROC]

  @AD_KIND CHAR(1)  -- 광고형태 (A: 등록대행, U:회원등록

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 기존 신문데이터 삭제
  DELETE FROM PJ_AD_PUBLISH_TB
   WHERE AD_KIND = @AD_KIND;

  IF @AD_KIND = 'A'  -- 등록대행
    BEGIN

      INSERT INTO dbo.PJ_AD_PUBLISH_TB
        (ADID, AD_KIND, CO_NAME, PHONE, HPHONE, BIZ_CD, AREA_A, AREA_B, AREA_C, AREA_DETAIL, HOMEPAGE, TITLE, CONTENTS, THEME_CD, PAY_CD, PAY_AMT, BIZ_NUMBER, LOGO_IMG, START_DT, END_DT, MAP_X, MAP_Y, SORT_ID, GRAND_IMG)
      SELECT ADID
            ,@AD_KIND AS AD_KIND
            ,CO_NAME
            ,PHONE
            ,HPHONE
            ,BIZ_CD
            ,AREA_A
            ,AREA_B
            ,AREA_C
            ,AREA_DETAIL
            ,HOMEPAGE
            ,TITLE
            ,CONTENTS
            ,THEME_CD
            ,PAY_CD
            ,PAY_AMT
            ,BIZ_NUMBER
            ,LOGO_IMG
            ,START_DT
            ,END_DT
            ,MAP_X
            ,MAP_Y
            ,0 AS SORT_ID
            ,GRAND_IMG
        FROM dbo.PJ_AD_AGENCY_TB
       WHERE CONVERT(VARCHAR(10),START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
         AND CONVERT(VARCHAR(10),END_DT,120) >= CONVERT(VARCHAR(10),GETDATE(),120)
         AND PAUSE_YN = 0
				 AND CONFIRM_YN = 1
         AND END_YN = 0

    END
  ELSE IF @AD_KIND = 'U'  -- E-COMM
    BEGIN

      INSERT INTO dbo.PJ_AD_PUBLISH_TB
        (ADID, AD_KIND, CO_NAME, PHONE, HPHONE, BIZ_CD, AREA_A, AREA_B, AREA_C, AREA_DETAIL, HOMEPAGE, TITLE, CONTENTS, THEME_CD, PAY_CD, PAY_AMT, BIZ_NUMBER, LOGO_IMG, START_DT, END_DT, MAP_X, MAP_Y, SORT_ID, GRAND_IMG)
      SELECT A.ADID
            ,@AD_KIND AS AD_KIND
            ,A.CO_NAME
            ,A.PHONE
            ,A.HPHONE
            ,A.BIZ_CD
            ,A.AREA_A
            ,A.AREA_B
            ,A.AREA_C
            ,A.AREA_DETAIL
            ,A.HOMEPAGE
            ,A.TITLE
            ,A.CONTENTS
            ,A.THEME_CD
            ,A.PAY_CD
            ,A.PAY_AMT
            ,A.BIZ_NUMBER
            ,A.LOGO_IMG
            ,A.START_DT
            ,A.END_DT
            ,A.MAP_X
            ,A.MAP_Y
            ,0 AS SORT_ID
            ,A.GRAND_IMG
        FROM dbo.PJ_AD_USERREG_TB AS A
        JOIN dbo.PJ_RECCHARGE_TB AS B
          ON B.ADID = A.ADID
         AND B.AD_GBN = 1
       WHERE CONVERT(VARCHAR(10),A.START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
         AND CONVERT(VARCHAR(10),A.END_DT,120) >= CONVERT(VARCHAR(10),GETDATE(),120)
         AND CONFIRM_YN = 1
         AND A.PAUSE_YN = 0
         AND A.END_YN = 0
         AND B.PRNAMTOK = 1

    END








GO
/****** Object:  StoredProcedure [dbo].[BAT_INPUT_PUBLISH_PAPER_DATA_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 스케쥴 > 오늘자 줄광고 게제테이블로 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/12
 *  수   정   자 : 신 장 순
 *  수   정   일 : 2015/05/29
 *  설        명 : 1. 시급데이터 제외 AND A.PAYF <> 4 조건추가
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_INPUT_PUBLISH_PAPER_DATA_PROC
 *************************************************************************************/
CREATE PROC [dbo].[BAT_INPUT_PUBLISH_PAPER_DATA_PROC]

AS

  SET XACT_ABORT ON
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN

		-- 게재전 시급으로 등록된 광고 삭제 (2015.05.29 신혜원파트장 요청)
		SELECT DISTINCT A.LINEADID
		INTO #DEL_DATA
		FROM dbo.DAILY_JOBPAPER_TB AS A
     JOIN FINDDB1.PAPER_NEW.DBO.TEMP_PP_LINE_AD_ORG_TB AS B
       ON B.LINEADID = A.LINEADID
      AND B.IDENTYFLAG = 1
     LEFT JOIN dbo.DAILY_JOBPAPER_DETAIL_TB AS C
       ON C.LINEADID = B.LINEADID
		WHERE PAYF = 4

		--SELECT *
		DELETE A
		FROM DAILY_JOBPAPER_TB A
		WHERE A.LINEADID IN (SELECT LINEADID FROM #DEL_DATA)

		--SELECT *
		DELETE A
		FROM DAILY_JOBPAPER_DETAIL_TB A
		WHERE A.LINEADID IN (SELECT LINEADID FROM #DEL_DATA)

		DROP TABLE #DEL_DATA

    -- 기존 신문데이터 삭제
    DELETE FROM PJ_AD_PUBLISH_TB
     WHERE AD_KIND = 'P';

    -- 오늘자 신문데이터 선별 (신문게재 비교)
    SELECT A.LINEADID AS ADID
          ,'P' AS AD_KIND
          ,A.CONAME AS CO_NAME
          ,A.PHONE AS PHONE
          ,NULL AS HPHONE
          ,A.CODE AS BIZ_CD
          ,A.METRO AS AREA_A
          ,A.CITY AS AREA_B
          ,A.DONG AS AREA_C
          ,A.ADDR_DETAIL AS AREA_DETAIL
          ,A.URL AS HOMEPAGE
          ,CAST(A.CONTENTS AS VARCHAR(50)) AS TITLE
          ,A.CONTENTS AS CONTENTS
          ,0 AS THEME_CD
          ,ISNULL(C.PAYF,0) AS PAY_CD
          ,ISNULL(C.PAYTO,0) AS PAY_AMT
          ,NULL AS BIZ_NUMBER
          ,NULL AS LOGO_IMG
          ,A.STARTDATE AS START_DT
          ,A.ENDDATE AS END_DT
          ,ISNULL(A.MAP_X,0) AS MAP_X
          ,ISNULL(A.MAP_Y,0) AS MAP_Y
          ,0 AS SORT_ID
     INTO #DAILY_JOBPAPER_TB
     FROM dbo.DAILY_JOBPAPER_TB AS A
     JOIN FINDDB1.PAPER_NEW.DBO.TEMP_PP_LINE_AD_ORG_TB AS B
       ON B.LINEADID = A.LINEADID
      AND B.IDENTYFLAG = 1
     LEFT JOIN dbo.DAILY_JOBPAPER_DETAIL_TB AS C
       ON C.LINEADID = B.LINEADID
    WHERE A.END_YN = 'N'
      AND CONVERT(VARCHAR(10),A.ENDDATE,120) >= CONVERT(VARCHAR(10),GETDATE(),120)
			AND C.PAYF <> 4


    -- 오늘자 신문데이터 등록 (중복데이터 제거)
    INSERT INTO dbo.PJ_AD_PUBLISH_TB
      (ADID, AD_KIND, CO_NAME, PHONE, HPHONE, BIZ_CD, AREA_A, AREA_B, AREA_C, AREA_DETAIL, HOMEPAGE, TITLE, CONTENTS, THEME_CD, PAY_CD, PAY_AMT, BIZ_NUMBER, LOGO_IMG, START_DT, END_DT, MAP_X, MAP_Y, SORT_ID)
    SELECT ADID
          ,MAX(AD_KIND) AS AD_KIND
          ,MAX(CO_NAME) AS CO_NAME
          ,MAX(PHONE) AS PHONE
          ,MAX(HPHONE) AS HPHONE
          ,MAX(BIZ_CD) AS BIZ_CD
          ,MAX(AREA_A) AS AREA_A
          ,MAX(AREA_B) AS AREA_B
          ,MAX(AREA_C) AS AREA_C
          ,MAX(AREA_DETAIL) AS AREA_DETAIL
          ,MAX(HOMEPAGE) AS HOMEPAGE
          ,MAX(TITLE) AS TITLE
          ,MAX(CONVERT(NVARCHAR(MAX),CONTENTS)) AS CONTENTS
          ,MAX(THEME_CD) AS THEME_CD
          ,MAX(PAY_CD) AS PAY_CD
          ,MAX(PAY_AMT) AS PAY_AMT
          ,MAX(BIZ_NUMBER) AS BIZ_NUMBER
          ,MAX(LOGO_IMG) AS LOGO_IMG
          ,MAX(START_DT) AS START_DT
          ,MAX(END_DT) AS END_DT
          ,MAX(MAP_X) AS MAP_X
          ,MAX(MAP_Y) AS MAP_Y
          ,MAX(SORT_ID) AS SORT_ID
      FROM #DAILY_JOBPAPER_TB
     GROUP BY ADID

   COMMIT TRAN



GO
/****** Object:  StoredProcedure [dbo].[BAT_INPUT_PUBLISH_PAPER_DATA_PROC_TEST]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 스케쥴 > 오늘자 줄광고 게제테이블로 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/12
 *  수   정   자 : 신 장 순
 *  수   정   일 : 2015/05/29
 *  설        명 : 1. 시급데이터 제외 AND A.PAYF <> 4 조건추가
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_INPUT_PUBLISH_PAPER_DATA_PROC
 *************************************************************************************/
CREATE PROC [dbo].[BAT_INPUT_PUBLISH_PAPER_DATA_PROC_TEST]

AS

  SET XACT_ABORT ON
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN

		-- 게재전 시급으로 등록된 광고 삭제 (2015.05.29 신혜원파트장 요청)
		SELECT DISTINCT A.LINEADID
		INTO #DEL_DATA
		FROM dbo.DAILY_JOBPAPER_TB AS A
     JOIN FINDDB1.PAPER_NEW.DBO.TEMP_PP_LINE_AD_ORG_TB AS B
       ON B.LINEADID = A.LINEADID
      AND B.IDENTYFLAG = 1
     LEFT JOIN dbo.DAILY_JOBPAPER_DETAIL_TB AS C
       ON C.LINEADID = B.LINEADID
		WHERE PAYF = 4

		--SELECT *
		DELETE A
		FROM DAILY_JOBPAPER_TB A
		WHERE A.LINEADID IN (SELECT LINEADID FROM #DEL_DATA)

		--SELECT *
		DELETE A
		FROM DAILY_JOBPAPER_DETAIL_TB A
		WHERE A.LINEADID IN (SELECT LINEADID FROM #DEL_DATA)

		DROP TABLE #DEL_DATA

    -- 기존 신문데이터 삭제
    DELETE FROM PJ_AD_PUBLISH_TB
     WHERE AD_KIND = 'P';

    -- 오늘자 신문데이터 선별 (신문게재 비교)
    SELECT A.LINEADID AS ADID
          ,'P' AS AD_KIND
          ,A.CONAME AS CO_NAME
          ,A.PHONE AS PHONE
          ,NULL AS HPHONE
          ,A.CODE AS BIZ_CD
          ,A.METRO AS AREA_A
          ,A.CITY AS AREA_B
          ,A.DONG AS AREA_C
          ,A.ADDR_DETAIL AS AREA_DETAIL
          ,A.URL AS HOMEPAGE
          ,CAST(A.CONTENTS AS VARCHAR(50)) AS TITLE
          ,A.CONTENTS AS CONTENTS
          ,0 AS THEME_CD
          ,ISNULL(C.PAYF,0) AS PAY_CD
          ,ISNULL(C.PAYTO,0) AS PAY_AMT
          ,NULL AS BIZ_NUMBER
          ,NULL AS LOGO_IMG
          ,A.STARTDATE AS START_DT
          ,A.ENDDATE AS END_DT
          ,ISNULL(A.MAP_X,0) AS MAP_X
          ,ISNULL(A.MAP_Y,0) AS MAP_Y
          ,0 AS SORT_ID
     INTO #DAILY_JOBPAPER_TB
     FROM dbo.DAILY_JOBPAPER_TB AS A
     JOIN FINDDB1.PAPER_NEW.DBO.TEMP_PP_LINE_AD_ORG_TB AS B
       ON B.LINEADID = A.LINEADID
      AND B.IDENTYFLAG = 1
     LEFT JOIN dbo.DAILY_JOBPAPER_DETAIL_TB AS C
       ON C.LINEADID = B.LINEADID
    WHERE A.END_YN = 'N'
      AND CONVERT(VARCHAR(10),A.ENDDATE,120) >= CONVERT(VARCHAR(10),GETDATE(),120)
			AND C.PAYF <> 4


    -- 오늘자 신문데이터 등록 (중복데이터 제거)
    INSERT INTO dbo.PJ_AD_PUBLISH_TB
      (ADID, AD_KIND, CO_NAME, PHONE, HPHONE, BIZ_CD, AREA_A, AREA_B, AREA_C, AREA_DETAIL, HOMEPAGE, TITLE, CONTENTS, THEME_CD, PAY_CD, PAY_AMT, BIZ_NUMBER, LOGO_IMG, START_DT, END_DT, MAP_X, MAP_Y, SORT_ID)
    SELECT ADID
          ,MAX(AD_KIND) AS AD_KIND
          ,MAX(CO_NAME) AS CO_NAME
          ,MAX(PHONE) AS PHONE
          ,MAX(HPHONE) AS HPHONE
          ,MAX(BIZ_CD) AS BIZ_CD
          ,MAX(AREA_A) AS AREA_A
          ,MAX(AREA_B) AS AREA_B
          ,MAX(AREA_C) AS AREA_C
          ,MAX(AREA_DETAIL) AS AREA_DETAIL
          ,MAX(HOMEPAGE) AS HOMEPAGE
          ,MAX(TITLE) AS TITLE
          ,MAX(CONVERT(NVARCHAR(MAX),CONTENTS)) AS CONTENTS
          ,MAX(THEME_CD) AS THEME_CD
          ,MAX(PAY_CD) AS PAY_CD
          ,MAX(PAY_AMT) AS PAY_AMT
          ,MAX(BIZ_NUMBER) AS BIZ_NUMBER
          ,MAX(LOGO_IMG) AS LOGO_IMG
          ,MAX(START_DT) AS START_DT
          ,MAX(END_DT) AS END_DT
          ,MAX(MAP_X) AS MAP_X
          ,MAX(MAP_Y) AS MAP_Y
          ,MAX(SORT_ID) AS SORT_ID
      FROM #DAILY_JOBPAPER_TB
     GROUP BY ADID

   COMMIT TRAN



GO
/****** Object:  StoredProcedure [dbo].[BAT_OPTION_LISTUP_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 스케쥴 > 옵션적용 : 리스트업
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 광고취합스케쥴 마지막에 실행
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_OPTION_LISTUP_PROC
 *************************************************************************************/


CREATE PROC [dbo].[BAT_OPTION_LISTUP_PROC]


AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN

    UPDATE PJ_AD_PUBLISH_TB
       SET SORT_ID = 1
      FROM PJ_AD_PUBLISH_TB AS A
           JOIN PJ_OPTION_TB AS B
             ON B.ADID = A.ADID
            AND B.AD_KIND = A.AD_KIND
     WHERE B.OPT_SUB_E = 1
       AND (CONVERT(VARCHAR(10),B.OPT_SUB_E_START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
            AND B.OPT_SUB_E_END_DT >= CONVERT(VARCHAR(10),GETDATE(),120))

  COMMIT TRAN







GO
/****** Object:  StoredProcedure [dbo].[BAT_SM_SALE_RAW_PAPERJOB_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 유흥구인 정산이관
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/09/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_SM_SALE_RAW_PAPERJOB_PROC
 *************************************************************************************/


CREATE PROC [dbo].[BAT_SM_SALE_RAW_PAPERJOB_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @DATE_YESTERDAY DATETIME
  DECLARE @DATE_TODAY	DATETIME

  SET @DATE_YESTERDAY 	= DATEADD(DD,-1,CONVERT(VARCHAR(10), GETDATE(),120))
  SET @DATE_TODAY		= CONVERT(VARCHAR(10), GETDATE(),120)

  INSERT INTO FINDDB2.FINDCOMMON.dbo.SM_SALE_RAW_TB (
  	SECTION_CD, SUB_SECTION_CD, PROD_TYPE_CD, PROD_CD, PAY_CONDITION_NM,
  	ORDER_ID, ADID, USERID, PAY_REG_DT, SALEPATH_CD, PAY_TYPE_NM,
  	PROD_NM, COMPANY_NM,
  	CNT, AMT, TOTAL_AMT, PAY_ID, SALE_DEP, SALE_ID)
  SELECT  'S116' AS SECTION_CD
  	,'www' AS SUB_SECTION_CD
  	,'C01' AS PROD_TYPE_CD
  	,'P001' AS PROD_CD
  	,'정상' AS PAY_CONDITION_NM
  	,B.SERIAL AS ORDER_ID
  	,A.ADID
  	,A.USERID
  	,CONVERT(CHAR(8), B.RECDATE, 112) + REPLACE(CONVERT(CHAR(5), B.RECDATE, 108), ':', '') AS PAY_REG_DT
  	,'SP01' AS SALEPATH_CD
  	,CASE B.CHARGE_KIND
      	WHEN '1' THEN '가상계좌'
      	WHEN '2' THEN '카드'
    	END AS PAY_TYPE_NM
   	,'야알바광고' AS PROD_NM
  	,NULL AS COMPANY_NM
  	,1 AS CNT
  	,B.PRNAMT AS AMT
  	,B.PRNAMT AS TOTAL_AMT
  	,B.INIPAYTID AS PAY_ID
  	,NULL AS SALE_DEP
  	,NULL AS	SALE_ID
    FROM dbo.PJ_AD_USERREG_TB AS A
  	JOIN dbo.PJ_RECCHARGE_TB AS B
       ON B.ADID = A.ADID
   WHERE B.PRNAMTOK = 1
     AND (B.INIPAYTID  <> '' OR B.INIPAYTID IS NOT NULL)
     AND B.RECDATE >= @DATE_YESTERDAY
     AND B.RECDATE < @DATE_TODAY







GO
/****** Object:  StoredProcedure [dbo].[BAT_TENS_AD_FILTERING_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 텐즈(모바일 앱) 광고 필터링
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2012/12/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_TENS_AD_FILTERING_PROC
 *************************************************************************************/


CREATE PROC [dbo].[BAT_TENS_AD_FILTERING_PROC]



AS

  SET NOCOUNT ON

	TRUNCATE TABLE PJ_AD_PUBLISH_TENS_TB

	INSERT INTO PJ_AD_PUBLISH_TENS_TB
	(ADID, AD_KIND, CO_NAME, PHONE, HPHONE, BIZ_CD, AREA_A, AREA_B, AREA_C, AREA_DETAIL, HOMEPAGE, TITLE, CONTENTS, THEME_CD, PAY_CD, PAY_AMT, BIZ_NUMBER, LOGO_IMG, START_DT, END_DT, MAP_X, MAP_Y, SORT_ID, GRAND_IMG)
	SELECT ADID, AD_KIND, CO_NAME, PHONE, HPHONE, BIZ_CD, AREA_A, AREA_B, AREA_C, AREA_DETAIL, HOMEPAGE, TITLE, CONTENTS, THEME_CD, PAY_CD, PAY_AMT, BIZ_NUMBER, LOGO_IMG, START_DT, END_DT, MAP_X, MAP_Y, SORT_ID, GRAND_IMG
	FROM dbo.PJ_AD_PUBLISH_TB

	-- 1.분류필터링 (다방, 카페/바, 서빙/웨이터분류 광고 제거)
	DELETE FROM PJ_AD_PUBLISH_TENS_TB
	 WHERE BIZ_CD IN (40400,40500,40600)

	-- 2.연령필터링
	DELETE FROM PJ_AD_PUBLISH_TENS_TB
	 WHERE TITLE LIKE '%~40%' OR TITLE LIKE '%~45%' OR TITLE LIKE '%~50%' OR TITLE LIKE '%30~%' OR TITLE LIKE '%40~%' OR TITLE LIKE '%40대%' OR TITLE LIKE '%50대%' OR TITLE LIKE '%40세%' OR TITLE LIKE '%45세%' OR TITLE LIKE '%50세%' OR TITLE LIKE '%55세%' OR TITLE LIKE '%미시%' OR TITLE LIKE '%주부%'

	DELETE FROM PJ_AD_PUBLISH_TENS_TB
	 WHERE CONTENTS LIKE '%~40%' OR CONTENTS LIKE '%~45%' OR CONTENTS LIKE '%~50%' OR CONTENTS LIKE '%30~%' OR CONTENTS LIKE '%40~%' OR CONTENTS LIKE '%40대%' OR CONTENTS LIKE '%50대%' OR CONTENTS LIKE '%40세%' OR CONTENTS LIKE '%45세%' OR CONTENTS LIKE '%50세%' OR CONTENTS LIKE '%55세%' OR CONTENTS LIKE '%미시%' OR CONTENTS LIKE '%주부%'

	-- 3.업무필터링
	DELETE FROM PJ_AD_PUBLISH_TENS_TB
	 WHERE TITLE LIKE '%다방%' OR TITLE LIKE '%가라오케%' OR TITLE LIKE '%가요%' OR TITLE LIKE '%노래%'

	DELETE FROM PJ_AD_PUBLISH_TENS_TB
	 WHERE CONTENTS LIKE '%다방%' OR CONTENTS LIKE '%가라오케%' OR CONTENTS LIKE '%가요%' OR CONTENTS LIKE '%노래%'

	-- 4.직군필터링
	DELETE FROM PJ_AD_PUBLISH_TENS_TB
	 WHERE TITLE LIKE '%주방%' OR TITLE LIKE '%도우미%' OR TITLE LIKE '%홀써빙%' OR TITLE LIKE '%홀서빙%' OR TITLE LIKE '%웨이터%'

	DELETE FROM PJ_AD_PUBLISH_TENS_TB
	 WHERE CONTENTS LIKE '%주방%' OR CONTENTS LIKE '%도우미%' OR CONTENTS LIKE '%홀써빙%' OR CONTENTS LIKE '%홀서빙%' OR CONTENTS LIKE '%웨이터%'

	-- 5. 노래주점 분류중 Image형태 광고 삭제
	DELETE FROM PJ_AD_PUBLISH_TENS_TB
	 WHERE BIZ_CD = 40300
	   AND CONTENTS LIKE '%<img src%'





GO
/****** Object:  StoredProcedure [dbo].[BAT_YAALBA_ZIPCODE_RENEW_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 우편번호 갱신
 *  작   성   자 : 백규원
 *  작   성   일 : 2017/12/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : PAPER_NEW BAT_ZIPCODE_RENEW_PROC 에서 호출한다
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC BAT_YAALBA_ZIPCODE_RENEW_PROC
 *************************************************************************************/

CREATE PROC [dbo].[BAT_YAALBA_ZIPCODE_RENEW_PROC]
AS
  SET XACT_ABORT ON
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN
		INSERT INTO CM_ZIPTXT_ORG
			SELECT METRO, CITY, DONG
			FROM FINDDB1.PAPER_NEW.DBO.CM_ZIPTXT_ORG WITH (NOLOCK)
			WHERE  NOT (DONG = '')


			UNION

			SELECT METRO, CITY, DONG
			FROM FINDDB1.PAPER_NEW.DBO.CM_ZIPTXT_ORG_ECOM WITH (NOLOCK)  -- CM_ZIPTXT_ORG에 없는 지역 추가
			WHERE DONG > ''

  COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[CM_GET_BIZCODE_A_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











/*************************************************************************************
 *  단위 업무 명 : 모집직종 정보 - 구인구직 (1 DEPTH)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/11/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : M: MWPLUS, N: 일반등록
 *  사 용  소 스 :
 *  사 용  예 제 :
		EXEC CM_GET_BIZCODE_A_PROC 'N'
		EXEC CM_GET_BIZCODE_A_PROC ''
 *************************************************************************************/


CREATE PROC [dbo].[CM_GET_BIZCODE_A_PROC]

  @REGGBN CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)

  SET @SQL = 'SELECT CODE3
                    ,CODENM3
                FROM PAPERCAT.DBO.CATCODE
               WHERE CODE1 = 4
                 AND CODE2 = 410
                 AND USEFLAG=''Y'''
--  IF @REGGBN = 'N'
--  BEGIN
--    SET @SQL = @SQL + 'AND CODE3 NOT IN (41045, 41085)'
--  END

	-- 유흥등록 권한이 없는 경우
  IF @REGGBN = 'X'
  BEGIN
    SET @SQL = @SQL + 'AND CODE3 NOT IN (41045, 41085)'
  END

  SET @SQL = @SQL + 'GROUP BY CODE3, CODENM3'


  EXECUTE SP_EXECUTESQL @SQL


















GO
/****** Object:  StoredProcedure [dbo].[CM_GET_BIZCODE_B_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*************************************************************************************
 *  단위 업무 명 : 모집직종 정보 - 구인구직 (2 DEPTH)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/11/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC CM_GET_BIZCODE_B_PROC 41020
 *************************************************************************************/



CREATE PROC [dbo].[CM_GET_BIZCODE_B_PROC]

  @CODE3 INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT
			CODE4,
			CASE CODENM4
				WHEN '기타학원 교사강사' THEN '기타 학원강사'
				WHEN '카운터/주차관리/기타' THEN '카운터/주차관리'
				ELSE CODENM4
			END AS CODENM4
    FROM PAPERCAT.DBO.CATCODE
   WHERE CODE1 = 4
     AND CODE2 = 410
     AND CODE3 = @CODE3
     AND USEFLAG='Y'
   GROUP BY CODE4, CODENM4












GO
/****** Object:  StoredProcedure [dbo].[CM_GET_CITYDATA_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*************************************************************************************
 *  단위 업무 명 : 시/구/동 정보 - 시(CITY)정보 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/11/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /js/SearchSiGunGu.asp
 *  사 용  예 제 : EXEC CM_GET_CITYDATA_PROC '세종'
 *************************************************************************************/


CREATE PROC [dbo].[CM_GET_CITYDATA_PROC]

  @METRONM	VARCHAR(10)

AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT [CITY]
    FROM CM_ZIPTXT_ORG WITH (NOLOCK)
   WHERE METRO = @METRONM
   GROUP BY CITY
   ORDER BY CITY ASC

END





GO
/****** Object:  StoredProcedure [dbo].[CM_GET_DONGDATA_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO










/*************************************************************************************
 *  단위 업무 명 : 시/구/동 정보 - 동정보 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/11/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /js/SearchDong.asp
 *  사 용  예 제 : EXEC CM_GET_DONGDATA_PROC '서울특별시', '강남구'
 *************************************************************************************/


CREATE PROC [dbo].[CM_GET_DONGDATA_PROC]

  @METRONM	VARCHAR(10)
 ,@CITYNM	VARCHAR(20)

AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  SELECT DONG
    FROM CM_ZIPTXT_ORG WITH (NOLOCK)  -- UNILINEDB.DBO.ZIPCODE
   WHERE METRO = @METRONM
     AND CITY = @CITYNM
	 AND DONG NOT LIKE '%사서함'
   GROUP BY DONG
   ORDER BY DONG ASC

END




GO
/****** Object:  StoredProcedure [dbo].[CUID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원통합 > 아이디 변경
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016/08/03
 *  설       명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
                 EXEC USERID_CHANGE_ALL_PROC 'ANYCALL512', 'ANYCALL512','111.111.111.111'

 *************************************************************************************/
CREATE PROCEDURE [dbo].[CUID_CHANGE_PROC]
  @MASTER_CUID			INT         =  0      -- 기존아이디
  ,@MASTER_USERID		VARCHAR(50) =  ''     -- 기존아이디
  ,@SLAVE_CUID			INT			=  0      --  변경 아이디
  ,@CLIENT_IP			VARCHAR(20) = ''

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	UPDATE A SET CUID=@MASTER_CUID FROM JOB_CUSTOMER_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM PJ_AD_SCRAP_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM PJ_AD_USERREG_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM PJ_AGENT_AD_TEL_TB A  where CUID=@SLAVE_CUID

/*
	INSERT PAPER_NEW.DBO.CUID_CHANGE_HISTORY_TB (B_CUID, N_CUID, USERID, DB_NAME, USERIP)
		SELECT @MASTER_CUID , @SLAVE_CUID,@MASTER_USERID,DB_NAME(),@CLIENT_IP
*/		
END







GO
/****** Object:  StoredProcedure [dbo].[DEL_CM_ZIPCODE_TB_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 야알바 우편번호 갱신 위한 초기화
 *  작   성   자 : 신 장 순 (jssin@mediawill.com)
 *  작   성   일 : 2015/01/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.DEL_CM_ZIPCODE_TB_PROC
 *************************************************************************************/
CREATE PROC [dbo].[DEL_CM_ZIPCODE_TB_PROC]
AS
BEGIN
	--TRUNCATE TABLE CM_ZIPCODE_TB
	TRUNCATE TABLE CM_ZIPTXT_ORG
END




GO
/****** Object:  StoredProcedure [dbo].[DEL_PP_AD_USER_MATCHING_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 관리자 > 신문광고 아이디 매칭 삭제
 *  작   성   자 : 김 성 준
 *  작   성   일 : 2014/01/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : DEL_PP_AD_USER_MATCHING_PROC 2010090702, 25, 25, 'B'
 *************************************************************************************/

CREATE PROC [dbo].[DEL_PP_AD_USER_MATCHING_PROC]

  @LINEADID INT
  ,@INPUT_BRANCH TINYINT
  ,@LAYOUT_BRANCH TINYINT
  ,@AD_KIND CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DELETE FROM dbo.PP_AD_USER_MATCHING_TB
  WHERE LINEADID = @LINEADID
    AND INPUT_BRANCH = @INPUT_BRANCH
    AND LAYOUT_BRANCH = @LAYOUT_BRANCH
    AND AD_KIND = @AD_KIND

  --등록대행광고 아이디 매칭 제거
  UPDATE dbo.PP_LINE_AD_ONLINE_TB
    SET USER_ID = NULL
    WHERE LINEADID = @LINEADID
    AND INPUT_BRANCH = @INPUT_BRANCH
    AND LAYOUT_BRANCH = @LAYOUT_BRANCH



GO
/****** Object:  StoredProcedure [dbo].[DROP_F_PAPER_AD_SCRAP_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : FRONT > 광고 스크랩 처리 삭제
 *  작   성   자 : 장 재 웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2012/09/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.DROP_F_PAPER_AD_SCRAP_PROC 1001057244, 'P', 'cbk08'
 *************************************************************************************/
CREATE PROC [dbo].[DROP_F_PAPER_AD_SCRAP_PROC]

  @ADID INT,
  @AD_KIND	CHAR,
  @CUID	INT

AS

	SET NOCOUNT ON

	IF NOT EXISTS(SELECT SEQ FROM dbo.PJ_AD_SCRAP_TB WHERE ADID = @ADID AND AD_KIND = @AD_KIND AND CUID = @CUID)
				RETURN(2) --기존 데이터 없음

	BEGIN TRY
		BEGIN TRAN
			BEGIN
				--기존 데이터가 있을 경우만 DELETE
				DELETE
				FROM dbo.PJ_AD_SCRAP_TB
				WHERE ADID = @ADID
				AND AD_KIND = @AD_KIND
				AND CUID = @CUID
			END
		COMMIT
		RETURN(1)	--정상처리
	END TRY

	BEGIN CATCH
		ROLLBACK
		RETURN(0)	--실패처리
	END CATCH







GO
/****** Object:  StoredProcedure [dbo].[DROP_F_PAY_CANCEL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > 결제취소에 따른 관련내역 삭제
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.DROP_CYBER_LINEAD_CANCEL_PROC 광고번호
 *************************************************************************************/

CREATE PROC [dbo].[DROP_F_PAY_CANCEL_PROC]

  @ADID INT
  ,@AD_GBN TINYINT

AS

  SET NOCOUNT ON
/*
  -- PJ_AD_USERREG_TB
  DELETE
    FROM PJ_AD_USERREG_TB
   WHERE ADID = @ADID

  -- PJ_OPTION_TB
  DELETE
    FROM PJ_OPTION_TB
   WHERE ADID = @ADID
     AND AD_KIND = 'U';
*/
  -- PJ_RECCHARGE_TB
  DELETE
    FROM PJ_RECCHARGE_TB
   WHERE ADID = @ADID
     AND AD_GBN = @AD_GBN







GO
/****** Object:  StoredProcedure [dbo].[DROP_M_AD_PUBLISH_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 관리자 > 게재테이블 데이터 삭제
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/09/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.DROP_M_AD_PUBLISH_PROC 1, 'U'
 *************************************************************************************/


CREATE PROC [dbo].[DROP_M_AD_PUBLISH_PROC]

  @ADID                   INT
  ,@AD_KIND               CHAR(1)  --광고종류 (A: 등록대행, U: 회원등록)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN

    DELETE
      FROM dbo.PJ_AD_PUBLISH_TB
     WHERE AD_KIND = @AD_KIND
       AND ADID = @ADID

  COMMIT TRAN






GO
/****** Object:  StoredProcedure [dbo].[DROP_M_MAINBANNER_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*************************************************************************************
 *  단위 업무 명 : 관리자 > 사이트관리 > 베너삭제
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.DROP_M_MAINBANNER_PROC 1
 *************************************************************************************/

CREATE PROC [dbo].[DROP_M_MAINBANNER_PROC]

  @IDX VARCHAR(1000)

AS

  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  SET @SQL = ''

  SET @SQL = 'DELETE
      FROM dbo.PJ_MAIN_BANNER_TB
     WHERE IDX IN ('+ @IDX +')'

  EXECUTE SP_EXECUTESQL @SQL










GO
/****** Object:  StoredProcedure [dbo].[DROP_M_NOTICE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 > 공지사항 메인게재여부 일괄처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.DROP_M_NOTICE_PROC
 *************************************************************************************/


CREATE PROC [dbo].[DROP_M_NOTICE_PROC]

  @SERIAL  VARCHAR(1000)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  SET @SQL = ''

  SET @SQL = 'UPDATE FINDDB2.FINDCOMMON.DBO.SITENEWS
                 SET DELFLAG = ''1''
               WHERE SERIAL IN ('+ @SERIAL +')'

  EXECUTE SP_EXECUTESQL @SQL







GO
/****** Object:  StoredProcedure [dbo].[EDIT_AD_GRANDLOGO_IMAGE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 광고 로고 이미지 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_AD_LOGO_IMAGE_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_AD_GRANDLOGO_IMAGE_PROC]

  @ADID         INT
  ,@AD_KIND     CHAR(1)      --광고종류 (A: 등록대행, U: 회원등록)
  ,@GRAND_IMG	VARCHAR(200)
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @CNT INT
  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_TABLE VARCHAR(20)
  DECLARE @SQL_MOD_FIELD NVARCHAR(100)

  SET @SQL = ''
  SET @SQL_MOD_FIELD = ''

  IF @AD_KIND = 'A'
    BEGIN
      SET @SQL_TABLE = 'PJ_AD_AGENCY_TB'
    END
  ELSE IF @AD_KIND = 'U'
    BEGIN
      SET @SQL_TABLE = 'PJ_AD_USERREG_TB'
    END

  IF @GRAND_IMG = ''
    BEGIN
      SET @SQL_MOD_FIELD = @SQL_MOD_FIELD + ',GRAND_IMG = NULL'
    END
  ELSE
    BEGIN
      SET @SQL_MOD_FIELD = @SQL_MOD_FIELD + ',GRAND_IMG = '''+ @GRAND_IMG +''''
    END


  SET @SQL = 'UPDATE '+ @SQL_TABLE +'
                 SET REG_DT = REG_DT '+ @SQL_MOD_FIELD +'
               WHERE ADID = '+ CAST(@ADID AS VARCHAR(10))

  EXECUTE SP_EXECUTESQL @SQL

  -- 게재테이블 수정
  SELECT @CNT = COUNT(*)
    FROM PJ_AD_PUBLISH_TB
   WHERE AD_KIND = @AD_KIND
     AND ADID = @ADID

  SET @SQL = ''

  IF @CNT > 0
    BEGIN
      SET @SQL = 'UPDATE PJ_AD_PUBLISH_TB
                     SET END_DT = END_DT '+ @SQL_MOD_FIELD +'
                   WHERE AD_KIND = '''+ @AD_KIND +'''
                     AND ADID = '+ CAST(@ADID AS VARCHAR(10))
      EXECUTE SP_EXECUTESQL @SQL
    END






GO
/****** Object:  StoredProcedure [dbo].[EDIT_AD_LOGO_IMAGE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 광고 로고 이미지 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_AD_LOGO_IMAGE_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_AD_LOGO_IMAGE_PROC]

  @ADID         INT
  ,@AD_KIND     CHAR(1)      --광고종류 (A: 등록대행, U: 회원등록)
  ,@LOGO_IMG    VARCHAR(200)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @CNT INT
  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_TABLE VARCHAR(20)
  DECLARE @SQL_MOD_FIELD NVARCHAR(100)

  SET @SQL = ''
  SET @SQL_MOD_FIELD = ''

  IF @AD_KIND = 'A'
    BEGIN
      SET @SQL_TABLE = 'PJ_AD_AGENCY_TB'
    END
  ELSE IF @AD_KIND = 'U'
    BEGIN
      SET @SQL_TABLE = 'PJ_AD_USERREG_TB'
    END

  IF @LOGO_IMG = ''
    BEGIN
      SET @SQL_MOD_FIELD = ',LOGO_IMG = NULL'
    END
  ELSE
    BEGIN
      SET @SQL_MOD_FIELD = ',LOGO_IMG = '''+ @LOGO_IMG +''''
    END

  SET @SQL = 'UPDATE '+ @SQL_TABLE +'
                 SET REG_DT = REG_DT '+ @SQL_MOD_FIELD +'
               WHERE ADID = '+ CAST(@ADID AS VARCHAR(10))

  EXECUTE SP_EXECUTESQL @SQL

  -- 게재테이블 수정
  SELECT @CNT = COUNT(*)
    FROM PJ_AD_PUBLISH_TB
   WHERE AD_KIND = @AD_KIND
     AND ADID = @ADID

  SET @SQL = ''

  IF @CNT > 0
    BEGIN
      SET @SQL = 'UPDATE PJ_AD_PUBLISH_TB
                     SET END_DT = END_DT '+ @SQL_MOD_FIELD +'
                   WHERE AD_KIND = '''+ @AD_KIND +'''
                     AND ADID = '+ CAST(@ADID AS VARCHAR(10))
      EXECUTE SP_EXECUTESQL @SQL
    END






GO
/****** Object:  StoredProcedure [dbo].[EDIT_F_USERREG_MODIFY_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > 광고수정신청 등록/수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/21
 *  수   정   자 : 신 장 순 (jssin@mediawill.com)
 *  수   정   일 : 2015.02.02
 *  설        명 : 수정신청 기능 제거 (바로 광고 수정하면서, 검수 대기 상태로 변경)
 *  주 의  사 항 : 게재 데이터에는 영향 없음. 단, 상세내용 변경시에만!!
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_F_USERREG_MODIFY_PROC 6
 SELECT * FROM PJ_AD_USERREG_TB WHERE ADID = 1143
 *************************************************************************************/

CREATE PROC [dbo].[EDIT_F_USERREG_MODIFY_PROC]

  @ADID           INT
  ,@CO_NAME       VARCHAR(100)
  ,@PHONE         VARCHAR(127)
  ,@HPHONE        VARCHAR(15)
  ,@BIZ_CD        INT
  ,@AREA_A        VARCHAR(50)
  ,@AREA_B        VARCHAR(50)
  ,@AREA_C        VARCHAR(50)
  ,@AREA_DETAIL   VARCHAR(50)
  ,@TITLE         VARCHAR(500)
  ,@CONTENTS      TEXT
  ,@PAY_CD        TINYINT
  ,@PAY_AMT       INT
  ,@BIZ_NUMBER    VARCHAR(50)
  ,@MAP_X         INT
  ,@MAP_Y         INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	BEGIN

	/* 상세내용이 다를경우에만 수정신청으로 취급하여 검수대기로 변경(나머지는 그냥 수정) -- 신혜원파트장 요청
	--------------------------------------------------------------------------------------*/
	DECLARE @MOD_REQ_YN CHAR(1)
	SET @MOD_REQ_YN = 'N'

	DECLARE @ORG_CONTENTS VARCHAR(MAX)	--// 기존 상세
	DECLARE @NEW_CONTENTS VARCHAR(MAX)	--// 변경 상세

	SET @NEW_CONTENTS = CONVERT(VARCHAR(MAX), @CONTENTS)

	SELECT @ORG_CONTENTS = CONVERT(VARCHAR(MAX), CONTENTS)
	FROM PJ_AD_USERREG_TB
	WHERE ADID = @ADID

	IF @ORG_CONTENTS <> @NEW_CONTENTS
		BEGIN
			SET @MOD_REQ_YN = 'Y'
		END
	/*
	--------------------------------------------------------------------------------------*/

	UPDATE PJ_AD_USERREG_TB
			SET CO_NAME     = @CO_NAME
          ,PHONE       = @PHONE
          ,HPHONE      = @HPHONE
          ,BIZ_CD      = @BIZ_CD
          ,AREA_A      = @AREA_A
          ,AREA_B      = @AREA_B
          ,AREA_C      = @AREA_C
          ,AREA_DETAIL = @AREA_DETAIL
          ,TITLE       = @TITLE
          ,CONTENTS    = @CONTENTS
          ,PAY_CD      = @PAY_CD
          ,PAY_AMT     = @PAY_AMT
          ,BIZ_NUMBER  = @BIZ_NUMBER
          ,MAP_X       = @MAP_X
          ,MAP_Y       = @MAP_Y
          ,MOD_DT      = GETDATE()
      WHERE ADID = @ADID

	IF @MOD_REQ_YN = 'Y'
		BEGIN
			UPDATE PJ_AD_USERREG_TB
					SET CONFIRM_YN  = 0
							,MOD_REQ_DT  = GETDATE()
					WHERE ADID = @ADID
		END

	END

	/*
	2015.02.02 수정신청 기능 제거. 바로 광고 수정하면서, 검수 대기로

  DECLARE @CNT INT
  SET @CNT = 0

  SELECT @CNT = COUNT(*)
    FROM PJ_AD_USERREG_MODIFY_TB
   WHERE ADID = @ADID

  -- 기존에 수정신청 내역이 있으면 UPDATE 아니면 INSERT
  IF @CNT > 0
    BEGIN

      UPDATE PJ_AD_USERREG_MODIFY_TB
         SET CO_NAME     = @CO_NAME
            ,PHONE       = @PHONE
            ,HPHONE      = @HPHONE
            ,BIZ_CD      = @BIZ_CD
            ,AREA_A      = @AREA_A
            ,AREA_B      = @AREA_B
            ,AREA_C      = @AREA_C
            ,AREA_DETAIL = @AREA_DETAIL
            ,TITLE       = @TITLE
            ,CONTENTS    = @CONTENTS
            ,PAY_CD      = @PAY_CD
            ,PAY_AMT     = @PAY_AMT
            ,BIZ_NUMBER  = @BIZ_NUMBER
            ,MAP_X       = @MAP_X
            ,MAP_Y       = @MAP_Y
            ,CONFIRM_YN  = 0
            ,CONFIRM_DT  = NULL
            ,REG_DT      = GETDATE()
       WHERE ADID = @ADID

    END
  ELSE
    BEGIN

      INSERT INTO PJ_AD_USERREG_MODIFY_TB
        (ADID, CO_NAME, PHONE, HPHONE, BIZ_CD, AREA_A, AREA_B, AREA_C, AREA_DETAIL, TITLE, CONTENTS, PAY_CD, PAY_AMT, BIZ_NUMBER, MAP_X, MAP_Y)
      VALUES (@ADID
              ,@CO_NAME
              ,@PHONE
              ,@HPHONE
              ,@BIZ_CD
              ,@AREA_A
              ,@AREA_B
              ,@AREA_C
              ,@AREA_DETAIL
              ,@TITLE
              ,@CONTENTS
              ,@PAY_CD
              ,@PAY_AMT
              ,@BIZ_NUMBER
              ,@MAP_X
              ,@MAP_Y)

    END
	*/






GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_AD_AGENCY_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 관리자 > 등록대행 광고 수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/20
 *  수   정   자 : 김 문 화
 *  수   정   일 : 2011/10/06
 *  설        명 : 전체관리자일 경우에만 기간 변경 처리
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :  EXEC _M_AD_AGENCY_PROC 28350, '블루문', '02-837-2845', '', 40500, '서울특별시', '서대문구', '남가좌동', '', '', '고수입 보장 20~30대 여직원 모집', N'여직원모집', 0, 1, 15000, '', '10  3 2011 12:00:00:000AM', '10 17 2011 12:00:00:000AM', 0, 0, 1009616107, 1, 10000, 0, '', 1

 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_AD_AGENCY_PROC]

  @ADID             INT
  ,@CO_NAME         VARCHAR   (30)
  ,@PHONE           VARCHAR   (127)
  ,@HPHONE          VARCHAR   (15)
  ,@BIZ_CD          INT
  ,@AREA_A          VARCHAR   (50)
  ,@AREA_B          VARCHAR   (50)
  ,@AREA_C          VARCHAR   (50)
  ,@AREA_DETAIL     VARCHAR   (50)
  ,@HOMEPAGE        VARCHAR   (100)
  ,@TITLE           VARCHAR   (500)
  ,@CONTENTS        TEXT
  ,@THEME_CD        TINYINT = 0
  ,@PAY_CD          TINYINT
  ,@PAY_AMT         INT = 0
  ,@BIZ_NUMBER      VARCHAR   (50) = ''
  ,@START_DT        DATETIME
  ,@END_DT          DATETIME
  ,@MAP_X           INT = 0
  ,@MAP_Y           INT = 0
  ,@MWPLUS_LINEADID INT
  ,@REG_KIND        TINYINT
  ,@AMOUNT_ONLINE   MONEY
  ,@AMOUNT_MWPLUS   MONEY
  ,@REASON          VARCHAR(200)
  ,@ADMINGRP		TINYINT					 			--관리자 구분  1:전체관리자

AS

  SET NOCOUNT ON

  BEGIN TRAN

	/* 상세내용이 다를경우에만 수정신청으로 취급하여 검수대기로 변경(나머지는 그냥 수정) -- 신혜원파트장 요청
	--------------------------------------------------------------------------------------*/
	DECLARE @MOD_REQ_YN CHAR(1)
	SET @MOD_REQ_YN = 'N'

	DECLARE @CONFIRM_YN CHAR(1)
	SET @CONFIRM_YN = '0'

	DECLARE @ORG_CONTENTS VARCHAR(MAX)	--// 기존 상세
	DECLARE @NEW_CONTENTS VARCHAR(MAX)	--// 변경 상세

	SET @NEW_CONTENTS = CONVERT(VARCHAR(MAX), @CONTENTS)

	SELECT @ORG_CONTENTS = CONVERT(VARCHAR(MAX), CONTENTS)
				,@CONFIRM_YN = CONFIRM_YN
	FROM PJ_AD_AGENCY_TB
	WHERE ADID = @ADID

	IF @ORG_CONTENTS <> @NEW_CONTENTS
		BEGIN
			SET @MOD_REQ_YN = 'Y'
		END
	/*
	--------------------------------------------------------------------------------------*/

  --전체관리자일 경우에만 기간 변경
  IF @ADMINGRP = 1
	BEGIN
		UPDATE PJ_AD_AGENCY_TB
		   SET CO_NAME = @CO_NAME
			  ,PHONE = @PHONE
			  ,HPHONE = @HPHONE
			  ,BIZ_CD = @BIZ_CD
			  ,AREA_A = @AREA_A
			  ,AREA_B = @AREA_B
			  ,AREA_C = @AREA_C
			  ,AREA_DETAIL = @AREA_DETAIL
			  ,HOMEPAGE = @HOMEPAGE
			  ,TITLE = @TITLE
			  ,CONTENTS = @CONTENTS
			  ,THEME_CD = @THEME_CD
			  ,PAY_CD = @PAY_CD
			  ,PAY_AMT = @PAY_AMT
			  ,BIZ_NUMBER = @BIZ_NUMBER
			  ,START_DT = @START_DT
			  ,END_DT = @END_DT
			  ,MAP_X = @MAP_X
			  ,MAP_Y = @MAP_Y
			  ,MWPLUS_LINEADID = @MWPLUS_LINEADID
			  ,REG_KIND = @REG_KIND
			  ,AMOUNT_ONLINE = @AMOUNT_ONLINE
			  ,AMOUNT_MWPLUS = @AMOUNT_MWPLUS
			  ,REASON = @REASON
			  ,MOD_DT = GETDATE()
		 WHERE ADID = @ADID
	END
  ELSE
	BEGIN
		UPDATE PJ_AD_AGENCY_TB
		   SET CO_NAME = @CO_NAME
			  ,PHONE = @PHONE
			  ,HPHONE = @HPHONE
			  ,BIZ_CD = @BIZ_CD
			  ,AREA_A = @AREA_A
			  ,AREA_B = @AREA_B
			  ,AREA_C = @AREA_C
			  ,AREA_DETAIL = @AREA_DETAIL
			  ,HOMEPAGE = @HOMEPAGE
			  ,TITLE = @TITLE
			  ,CONTENTS = @CONTENTS
			  ,THEME_CD = @THEME_CD
			  ,PAY_CD = @PAY_CD
			  ,PAY_AMT = @PAY_AMT
			  ,BIZ_NUMBER = @BIZ_NUMBER
			  ,MAP_X = @MAP_X
			  ,MAP_Y = @MAP_Y
			  ,MWPLUS_LINEADID = @MWPLUS_LINEADID
			  ,REG_KIND = @REG_KIND
			  ,AMOUNT_ONLINE = @AMOUNT_ONLINE
			  ,AMOUNT_MWPLUS = @AMOUNT_MWPLUS
			  ,REASON = @REASON
			  ,MOD_DT = GETDATE()
		 WHERE ADID = @ADID
	END

	IF @MOD_REQ_YN = 'Y'
	BEGIN
		UPDATE PJ_AD_AGENCY_TB
				SET CONFIRM_YN  = 0
						,MOD_REQ_DT  = GETDATE()
				WHERE ADID = @ADID
	END


	IF @CONFIRM_YN = '2'
		BEGIN
			UPDATE PJ_AD_AGENCY_TB
				SET CONFIRM_YN  = 0
						,MOD_REQ_DT  = GETDATE()
				WHERE ADID = @ADID
		END

  COMMIT TRAN


  -- 시작일이 오늘자보다 오늘 또는 이전일 종료일이 오늘보다 같거나 이전일이면
  IF @CONFIRM_YN = '1' AND (@START_DT <= CONVERT(VARCHAR(10), GETDATE(), 120)) AND (@END_DT >= CONVERT(VARCHAR(10), GETDATE(), 120))
    BEGIN
			IF @MOD_REQ_YN = 'N'
				BEGIN
      -- 게재테이블로 이관 (등록대행인 경우 두번째 인자값 'A')
      EXECUTE PUT_AD_PUBLISH_TRANS_PROC @ADID, 'A'
				END
    END

  -- 시작일이 오늘이후(예약)라면
  IF @START_DT > CONVERT(VARCHAR(10), GETDATE(), 120)
    BEGIN
      -- 게재테이블에서 삭제
      EXECUTE DROP_M_AD_PUBLISH_PROC @ADID, 'A'
    END








GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_AD_AGENCY_PROC_VER2]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 야알바 관리자 > 등록대행 광고 수정
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/11/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 등록대행 광고 등록 등록자 이름도 추가(윌리언트랑 별도)
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC _M_AD_AGENCY_PROC_VER2 28350, '블루문', '02-837-2845', '', 40500, '서울특별시', '서대문구', '남가좌동', '', '', '고수입 보장 20~30대 여직원 모집', N'여직원모집', 0, 1, 15000, '', '10  3 2011 12:00:00:000AM', '10 17 2011 12:00:00:000AM', 0, 0, 1009616107, 1, 10000, 0, '', 1
 *************************************************************************************/
CREATE PROC [dbo].[EDIT_M_AD_AGENCY_PROC_VER2]
	 @ADID						INT
	,@CO_NAME					VARCHAR(30)
	,@PHONE						VARCHAR(127)
	,@HPHONE					VARCHAR(15)
	,@BIZ_CD					INT
	,@AREA_A					VARCHAR(50)
	,@AREA_B					VARCHAR(50)
	,@AREA_C					VARCHAR(50)
	,@AREA_DETAIL			VARCHAR(50)
	,@HOMEPAGE				VARCHAR(100)
	,@TITLE						VARCHAR(500)
	,@CONTENTS				TEXT
	,@THEME_CD				TINYINT = 0
	,@PAY_CD					TINYINT
	,@PAY_AMT					INT = 0
	,@BIZ_NUMBER			VARCHAR(50) = ''
	,@START_DT				DATETIME
	,@END_DT					DATETIME
	,@MAP_X						INT = 0
	,@MAP_Y						INT = 0
	,@MWPLUS_LINEADID	INT
	,@REG_KIND				TINYINT
	,@AMOUNT_ONLINE		MONEY
	,@AMOUNT_MWPLUS		MONEY
	,@REASON					VARCHAR(200)
	,@ADMINGRP				TINYINT			 			-- 관리자 구분  1:전체관리자
	,@REG_NAME				VARCHAR(30) = ''
AS
  SET NOCOUNT ON
  BEGIN TRAN

	/* 상세내용이 다를경우에만 수정신청으로 취급하여 검수대기로 변경(나머지는 그냥 수정) -- 신혜원파트장 요청 S */
	DECLARE @MOD_REQ_YN CHAR(1)
	SET @MOD_REQ_YN = 'N'

	DECLARE @CONFIRM_YN CHAR(1)
	SET @CONFIRM_YN = '0'

	DECLARE @ORG_CONTENTS VARCHAR(MAX)	--// 기존 상세
	DECLARE @NEW_CONTENTS VARCHAR(MAX)	--// 변경 상세

	SET @NEW_CONTENTS = CONVERT(VARCHAR(MAX), @CONTENTS)

	SELECT @ORG_CONTENTS = CONVERT(VARCHAR(MAX), CONTENTS)
				,@CONFIRM_YN = CONFIRM_YN
	FROM PJ_AD_AGENCY_TB
	WHERE ADID = @ADID

	IF @ORG_CONTENTS <> @NEW_CONTENTS
	BEGIN
		SET @MOD_REQ_YN = 'Y'
	END
	/* 상세내용이 다를경우에만 수정신청으로 취급하여 검수대기로 변경(나머지는 그냥 수정) -- 신혜원파트장 요청 E */

  --전체관리자일 경우에만 기간 변경
  IF @ADMINGRP = 1
	BEGIN
		UPDATE PJ_AD_AGENCY_TB
		SET CO_NAME = @CO_NAME
			,PHONE = @PHONE
			,HPHONE = @HPHONE
			,BIZ_CD = @BIZ_CD
			,AREA_A = @AREA_A
			,AREA_B = @AREA_B
			,AREA_C = @AREA_C
			,AREA_DETAIL = @AREA_DETAIL
			,HOMEPAGE = @HOMEPAGE
			,TITLE = @TITLE
			,CONTENTS = @CONTENTS
			,THEME_CD = @THEME_CD
			,PAY_CD = @PAY_CD
			,PAY_AMT = @PAY_AMT
			,BIZ_NUMBER = @BIZ_NUMBER
			,START_DT = @START_DT
			,END_DT = @END_DT
			,MAP_X = @MAP_X
			,MAP_Y = @MAP_Y
			,MWPLUS_LINEADID = @MWPLUS_LINEADID
			,REG_KIND = @REG_KIND
			,AMOUNT_ONLINE = @AMOUNT_ONLINE
			,AMOUNT_MWPLUS = @AMOUNT_MWPLUS
			,REASON = @REASON
			,MOD_DT = GETDATE()
			,REG_NAME = @REG_NAME
		WHERE ADID = @ADID
	END
  ELSE
	BEGIN
		UPDATE PJ_AD_AGENCY_TB
		SET CO_NAME = @CO_NAME
			,PHONE = @PHONE
			,HPHONE = @HPHONE
			,BIZ_CD = @BIZ_CD
			,AREA_A = @AREA_A
			,AREA_B = @AREA_B
			,AREA_C = @AREA_C
			,AREA_DETAIL = @AREA_DETAIL
			,HOMEPAGE = @HOMEPAGE
			,TITLE = @TITLE
			,CONTENTS = @CONTENTS
			,THEME_CD = @THEME_CD
			,PAY_CD = @PAY_CD
			,PAY_AMT = @PAY_AMT
			,BIZ_NUMBER = @BIZ_NUMBER
			,MAP_X = @MAP_X
			,MAP_Y = @MAP_Y
			,MWPLUS_LINEADID = @MWPLUS_LINEADID
			,REG_KIND = @REG_KIND
			,AMOUNT_ONLINE = @AMOUNT_ONLINE
			,AMOUNT_MWPLUS = @AMOUNT_MWPLUS
			,REASON = @REASON
			,MOD_DT = GETDATE()
			,REG_NAME = @REG_NAME
		WHERE ADID = @ADID
	END

	IF @MOD_REQ_YN = 'Y'
	BEGIN
		UPDATE PJ_AD_AGENCY_TB
		SET CONFIRM_YN = 0
			,MOD_REQ_DT = GETDATE()
		WHERE ADID = @ADID
	END

	IF @CONFIRM_YN = '2'
	BEGIN
		UPDATE PJ_AD_AGENCY_TB
		SET CONFIRM_YN = 0
			,MOD_REQ_DT = GETDATE()
		WHERE ADID = @ADID
	END

  COMMIT TRAN

  -- 시작일이 오늘자보다 오늘 또는 이전일 종료일이 오늘보다 같거나 이전일이면
  IF @CONFIRM_YN = '1' AND (@START_DT <= CONVERT(VARCHAR(10), GETDATE(), 120)) AND (@END_DT >= CONVERT(VARCHAR(10), GETDATE(), 120))
  BEGIN
		IF @MOD_REQ_YN = 'N'
		BEGIN
			-- 게재테이블로 이관 (등록대행인 경우 두번째 인자값 'A')
			EXECUTE PUT_AD_PUBLISH_TRANS_PROC @ADID, 'A'
		END
  END

  -- 시작일이 오늘이후(예약)라면
  IF @START_DT > CONVERT(VARCHAR(10), GETDATE(), 120)
  BEGIN
    -- 게재테이블에서 삭제
    EXECUTE DROP_M_AD_PUBLISH_PROC @ADID, 'A'
  END
GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_AD_AGENCY_WILLS_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 윌스 > 등록대행 광고 수정
 *  작   성   자 : 백규원
 *  작   성   일 : 2017/03/16
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 윌스에서 게재처리
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :  EXEC _M_AD_AGENCY_PROC 28350, '블루문', '02-837-2845', '', 40500, '서울특별시', '서대문구', '남가좌동', '', '', '고수입 보장 20~30대 여직원 모집', N'여직원모집', 0, 1, 15000, '', '10  3 2011 12:00:00:000AM', '10 17 2011 12:00:00:000AM', 0, 0, 1009616107, 1, 10000, 0, '', 1

 *************************************************************************************/

--select M_STATUS, * from PJ_AD_AGENCY_TB


CREATE PROC [dbo].[EDIT_M_AD_AGENCY_WILLS_PROC]

  @ADID             INT
  ,@CO_NAME         VARCHAR   (30)
  ,@PHONE           VARCHAR   (127)
  ,@HPHONE          VARCHAR   (15)
  ,@BIZ_CD          INT
  ,@AREA_A          VARCHAR   (50)
  ,@AREA_B          VARCHAR   (50)
  ,@AREA_C          VARCHAR   (50)
  ,@AREA_DETAIL     VARCHAR   (50)
  ,@HOMEPAGE        VARCHAR   (100)
  ,@TITLE           VARCHAR   (500)
  ,@CONTENTS        TEXT
  ,@THEME_CD        TINYINT = 0
  ,@PAY_CD          TINYINT
  ,@PAY_AMT         INT = 0
  ,@BIZ_NUMBER      VARCHAR   (50) = ''
  ,@START_DT        DATETIME
  ,@END_DT          DATETIME
  ,@MAP_X           INT = 0
  ,@MAP_Y           INT = 0
  ,@MWPLUS_LINEADID INT
  ,@REG_KIND        TINYINT
  ,@AMOUNT_ONLINE   MONEY
  ,@AMOUNT_MWPLUS   MONEY
  ,@REASON          VARCHAR(200)
  ,@ADMINGRP		TINYINT					 			--관리자 구분  1:전체관리자
	,@M_STATUS CHAR(1)

AS

  SET NOCOUNT ON

  BEGIN TRAN

	/* 상세내용이 다를경우에만 수정신청으로 취급하여 검수대기로 변경(나머지는 그냥 수정) -- 신혜원파트장 요청
	--------------------------------------------------------------------------------------*/
	DECLARE @MOD_REQ_YN CHAR(1)
	SET @MOD_REQ_YN = 'N'

	DECLARE @CONFIRM_YN CHAR(1)
	SET @CONFIRM_YN = '0'

	DECLARE @ORG_CONTENTS VARCHAR(MAX)	--// 기존 상세
	DECLARE @NEW_CONTENTS VARCHAR(MAX)	--// 변경 상세

	SET @NEW_CONTENTS = CONVERT(VARCHAR(MAX), @CONTENTS)

	SELECT @ORG_CONTENTS = CONVERT(VARCHAR(MAX), CONTENTS)
				,@CONFIRM_YN = CONFIRM_YN
	FROM PJ_AD_AGENCY_TB
	WHERE ADID = @ADID

	IF @ORG_CONTENTS <> @NEW_CONTENTS
		BEGIN
			SET @MOD_REQ_YN = 'Y'
		END
	/*
	--------------------------------------------------------------------------------------*/

  --전체관리자일 경우에만 기간 변경
  IF @ADMINGRP = 1
	BEGIN
		UPDATE PJ_AD_AGENCY_TB
		   SET CO_NAME = @CO_NAME
			  ,PHONE = @PHONE
			  ,HPHONE = @HPHONE
			  ,BIZ_CD = @BIZ_CD
			  ,AREA_A = @AREA_A
			  ,AREA_B = @AREA_B
			  ,AREA_C = @AREA_C
			  ,AREA_DETAIL = @AREA_DETAIL
			  ,HOMEPAGE = @HOMEPAGE
			  ,TITLE = @TITLE
			  ,CONTENTS = @CONTENTS
			  ,THEME_CD = @THEME_CD
			  ,PAY_CD = @PAY_CD
			  ,PAY_AMT = @PAY_AMT
			  ,BIZ_NUMBER = @BIZ_NUMBER
			  ,START_DT = @START_DT
			  ,END_DT = @END_DT
			  ,MAP_X = @MAP_X
			  ,MAP_Y = @MAP_Y
			  ,MWPLUS_LINEADID = @MWPLUS_LINEADID
			  ,REG_KIND = @REG_KIND
			  ,AMOUNT_ONLINE = @AMOUNT_ONLINE
			  ,AMOUNT_MWPLUS = @AMOUNT_MWPLUS
			  ,REASON = @REASON
			  ,MOD_DT = GETDATE()
				,M_STATUS = @M_STATUS
		 WHERE ADID = @ADID
	END
  ELSE
	BEGIN
		UPDATE PJ_AD_AGENCY_TB
		   SET CO_NAME = @CO_NAME
			  ,PHONE = @PHONE
			  ,HPHONE = @HPHONE
			  ,BIZ_CD = @BIZ_CD
			  ,AREA_A = @AREA_A
			  ,AREA_B = @AREA_B
			  ,AREA_C = @AREA_C
			  ,AREA_DETAIL = @AREA_DETAIL
			  ,HOMEPAGE = @HOMEPAGE
			  ,TITLE = @TITLE
			  ,CONTENTS = @CONTENTS
			  ,THEME_CD = @THEME_CD
			  ,PAY_CD = @PAY_CD
			  ,PAY_AMT = @PAY_AMT
			  ,BIZ_NUMBER = @BIZ_NUMBER
			  ,MAP_X = @MAP_X
			  ,MAP_Y = @MAP_Y
			  ,MWPLUS_LINEADID = @MWPLUS_LINEADID
			  ,REG_KIND = @REG_KIND
			  ,AMOUNT_ONLINE = @AMOUNT_ONLINE
			  ,AMOUNT_MWPLUS = @AMOUNT_MWPLUS
			  ,REASON = @REASON
			  ,MOD_DT = GETDATE()
				,M_STATUS = @M_STATUS
		 WHERE ADID = @ADID
	END

	IF @MOD_REQ_YN = 'Y'
	BEGIN
		UPDATE PJ_AD_AGENCY_TB
				SET CONFIRM_YN  = 0
						,MOD_REQ_DT  = GETDATE()
				WHERE ADID = @ADID
	END


	IF @CONFIRM_YN = '2'
		BEGIN
			UPDATE PJ_AD_AGENCY_TB
				SET CONFIRM_YN  = 0
						,MOD_REQ_DT  = GETDATE()
				WHERE ADID = @ADID
		END

  COMMIT TRAN


  -- 시작일이 오늘자보다 오늘 또는 이전일 종료일이 오늘보다 같거나 이전일이면
  IF @CONFIRM_YN = '1' AND (@START_DT <= CONVERT(VARCHAR(10), GETDATE(), 120)) AND (@END_DT >= CONVERT(VARCHAR(10), GETDATE(), 120))
    BEGIN
			IF @MOD_REQ_YN = 'N'
				BEGIN
      -- 게재테이블로 이관 (등록대행인 경우 두번째 인자값 'A')
      EXECUTE PUT_AD_PUBLISH_TRANS_PROC @ADID, 'A'
				END
    END

  -- 시작일이 오늘이후(예약)라면
  IF @START_DT > CONVERT(VARCHAR(10), GETDATE(), 120)
    BEGIN
      -- 게재테이블에서 삭제
      EXECUTE DROP_M_AD_PUBLISH_PROC @ADID, 'A'
    END









GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_AD_MODIFY_APP_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 > E-COMM 광고 수정신청 내용 수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_AD_MODIFY_APP_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_AD_MODIFY_APP_PROC]

  @ADID             INT
  ,@CO_NAME         VARCHAR   (30)
  ,@PHONE           VARCHAR   (127)
  ,@HPHONE          VARCHAR   (15)
  ,@BIZ_CD          INT
  ,@AREA_A          VARCHAR   (10)
  ,@AREA_B          VARCHAR   (10)
  ,@AREA_C          VARCHAR   (10)
  ,@AREA_DETAIL     VARCHAR   (50)
  ,@HOMEPAGE        VARCHAR   (100)
  ,@TITLE           VARCHAR   (500)
  ,@CONTENTS        TEXT
  ,@THEME_CD        TINYINT = 0
  ,@PAY_CD          TINYINT
  ,@PAY_AMT         INT = 0
  ,@BIZ_NUMBER      VARCHAR   (50) = ''
  ,@MAP_X           INT = 0
  ,@MAP_Y           INT = 0

AS

  SET NOCOUNT ON

  BEGIN TRAN

    UPDATE PJ_AD_USERREG_MODIFY_TB
       SET CO_NAME     = @CO_NAME
          ,PHONE       = @PHONE
          ,HPHONE      = @HPHONE
          ,BIZ_CD      = @BIZ_CD
          ,AREA_A      = @AREA_A
          ,AREA_B      = @AREA_B
          ,AREA_C      = @AREA_C
          ,AREA_DETAIL = @AREA_DETAIL
          ,HOMEPAGE    = @HOMEPAGE
          ,TITLE       = @TITLE
          ,CONTENTS    = @CONTENTS
          ,THEME_CD    = @THEME_CD
          ,PAY_CD      = @PAY_CD
          ,PAY_AMT     = @PAY_AMT
          ,BIZ_NUMBER  = @BIZ_NUMBER
          ,MAP_X       = @MAP_X
          ,MAP_Y       = @MAP_Y
     WHERE ADID = @ADID

  COMMIT TRAN








GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_AD_OPTION_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











/*************************************************************************************
 *  단위 업무 명 : 관리자 > 광고 옵션수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_AD_OPTION_PROC
 *************************************************************************************/

CREATE PROC [dbo].[EDIT_M_AD_OPTION_PROC]

  @ADID                   INT
  ,@AD_KIND               CHAR(1)  --광고종류 (A: 등록대행, U: 회원등록)
  ,@LOCAL_CD              TINYINT
  ,@OPTION_MAIN_CD        TINYINT
  ,@TEMPLATE_CD           TINYINT
  ,@OPT_SUB_A             BIT
  ,@OPT_SUB_A_START_DT    DATETIME = NULL
  ,@OPT_SUB_A_END_DT      DATETIME = NULL
  ,@OPT_SUB_B             BIT
  ,@OPT_SUB_B_START_DT    DATETIME = NULL
  ,@OPT_SUB_B_END_DT      DATETIME = NULL
  ,@OPT_SUB_C             BIT
  ,@OPT_SUB_C_START_DT    DATETIME = NULL
  ,@OPT_SUB_C_END_DT      DATETIME = NULL
  ,@OPT_SUB_D             BIT
  ,@OPT_SUB_D_START_DT    DATETIME = NULL
  ,@OPT_SUB_D_END_DT      DATETIME = NULL
  ,@OPT_SUB_E             BIT
  ,@OPT_SUB_E_START_DT    DATETIME = NULL
  ,@OPT_SUB_E_END_DT      DATETIME = NULL

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @CNT INT

  -- 기존 옵션등록 여부 확인
  SELECT @CNT = COUNT(*)
    FROM PJ_OPTION_TB
   WHERE ADID = @ADID
     AND AD_KIND = @AD_KIND

  BEGIN TRAN

    IF @CNT > 0
	    BEGIN
		    UPDATE PJ_OPTION_TB
		       SET LOCAL_CD           = @LOCAL_CD
			      ,OPTION_MAIN_CD     = @OPTION_MAIN_CD
			      ,TEMPLATE_CD        = @TEMPLATE_CD
			      ,OPT_SUB_A          = @OPT_SUB_A
			      ,OPT_SUB_A_START_DT = @OPT_SUB_A_START_DT
			      ,OPT_SUB_A_END_DT   = @OPT_SUB_A_END_DT
			      ,OPT_SUB_B          = @OPT_SUB_B
			      ,OPT_SUB_B_START_DT = @OPT_SUB_B_START_DT
			      ,OPT_SUB_B_END_DT   = @OPT_SUB_B_END_DT
			      ,OPT_SUB_C          = @OPT_SUB_C
			      ,OPT_SUB_C_START_DT = @OPT_SUB_C_START_DT
			      ,OPT_SUB_C_END_DT   = @OPT_SUB_C_END_DT
			      ,OPT_SUB_D          = @OPT_SUB_D
			      ,OPT_SUB_D_START_DT = @OPT_SUB_D_START_DT
			      ,OPT_SUB_D_END_DT   = @OPT_SUB_D_END_DT
			      ,OPT_SUB_E          = @OPT_SUB_E
			      ,OPT_SUB_E_START_DT = @OPT_SUB_E_START_DT
			      ,OPT_SUB_E_END_DT   = @OPT_SUB_E_END_DT
		     WHERE ADID = @ADID
		       AND AD_KIND = @AD_KIND
	    END
    ELSE
	    BEGIN
		    EXECUTE PUT_AD_OPTION_PROC
				    @ADID
				    ,@AD_KIND
				    ,@LOCAL_CD
				    ,@OPTION_MAIN_CD
				    ,@TEMPLATE_CD
				    ,@OPT_SUB_A
				    ,@OPT_SUB_A_START_DT
				    ,@OPT_SUB_A_END_DT
				    ,@OPT_SUB_B
				    ,@OPT_SUB_B_START_DT
				    ,@OPT_SUB_B_END_DT
				    ,@OPT_SUB_C
				    ,@OPT_SUB_C_START_DT
				    ,@OPT_SUB_C_END_DT
				    ,@OPT_SUB_D
				    ,@OPT_SUB_D_START_DT
				    ,@OPT_SUB_D_END_DT
				    ,@OPT_SUB_E
				    ,@OPT_SUB_E_START_DT
				    ,@OPT_SUB_E_END_DT
	      END

  COMMIT TRAN

  -- 리스트업 적용
/*
  IF @OPT_SUB_E = 1
    BEGIN
      EXECUTE DBO.BAT_OPTION_LISTUP_PROC
    END
*/







GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_AD_STATUS_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
















/*************************************************************************************
 *  단위 업무 명 : 관리자 > 광고상태 처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /mag/admanage/AdEndProc.asp,
 *  사 용  예 제 : EXEC DBO.EDIT_M_AD_STATUS_PROC 1,'U','E',1
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_AD_STATUS_PROC]

  @ADID          INT      -- 광고번호
  ,@AD_KIND      CHAR(1)  -- 광고형태 (A: 등록대행, U: E-Comm)
  ,@STATUS_KIND  CHAR(1)  -- 처리형태 (P: 보류, E: 종료)
  ,@SWITCH       TINYINT  -- 스위치 (0:해제, 1:설정)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(2000)
  DECLARE @SQL_TABLE VARCHAR(20)
  DECLARE @SQL_EDIT VARCHAR(50)
  DECLARE @PUB_YN BIT    -- 0: 게제테이블에서 삭제, 1: 게재테이블로 등록

  SET @SQL = ''
  SET @SQL_TABLE = ''
  SET @SQL_EDIT = ''
  SET @PUB_YN = 0

  --// 광고형태에 따른 대상 테이블
  IF @AD_KIND = 'A'  -- 등록대행
    BEGIN
      SET @SQL_TABLE = 'PJ_AD_AGENCY_TB'
    END
  ELSE IF @AD_KIND = 'U'  -- E-Comm
    BEGIN
      SET @SQL_TABLE = 'PJ_AD_USERREG_TB'
    END

  --// 처리형태
  IF @STATUS_KIND = 'P'  -- 보류
    BEGIN
      IF @SWITCH = 1
        BEGIN
          SET @SQL_EDIT = 'PAUSE_YN = 1, STOP_DT = GETDATE()'
          SET @PUB_YN = 0
        END
      ELSE
        BEGIN
          SET @SQL_EDIT = 'PAUSE_YN = 0, STOP_DT = NULL, END_YN = 0'    -- 보류해제시 종료설정도 해제 (2012.08.31)
          SET @PUB_YN = 1
        END
    END
  ELSE IF @STATUS_KIND = 'E'  -- 종료
    BEGIN
      IF @SWITCH = 1
        BEGIN
          SET @SQL_EDIT = 'END_YN = 1, STOP_DT = GETDATE()'
          SET @PUB_YN = 0
        END
      ELSE
        BEGIN
          SET @SQL_EDIT = 'END_YN = 0, STOP_DT = NULL'
          SET @PUB_YN = 1
        END
    END

  --// 쿼리
  SET @SQL = 'UPDATE '+ @SQL_TABLE +'
                 SET '+ @SQL_EDIT +'
               WHERE ADID = '+ CAST(@ADID AS VARCHAR(10))

  -- 게재테이블 이관 OR 삭제
  IF @PUB_YN = 1
    BEGIN
      EXECUTE PUT_AD_PUBLISH_TRANS_PROC @ADID, @AD_KIND
    END
  ELSE
    BEGIN
      SET @SQL = @SQL +';DELETE FROM PJ_AD_PUBLISH_TB
                         WHERE ADID = '+ CAST(@ADID AS VARCHAR(10)) +'
                           AND AD_KIND = '''+ @AD_KIND +''''
    END


  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL









GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_AD_USERREG_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/*************************************************************************************
 *  단위 업무 명 : 관리자 > ECOMM 광고 수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_AD_USERREG_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_AD_USERREG_PROC]

  @ADID             INT
  ,@CO_NAME         VARCHAR   (30)
  ,@PHONE           VARCHAR   (127)
  ,@HPHONE          VARCHAR   (15)
  ,@BIZ_CD          INT
  ,@AREA_A          VARCHAR   (50)
  ,@AREA_B          VARCHAR   (50)
  ,@AREA_C          VARCHAR   (50)
  ,@AREA_DETAIL     VARCHAR   (50)
  ,@HOMEPAGE        VARCHAR   (100)
  ,@TITLE           VARCHAR   (500)
  ,@CONTENTS        TEXT
  ,@THEME_CD        TINYINT = 0
  ,@PAY_CD          TINYINT
  ,@PAY_AMT         INT = 0
  ,@BIZ_NUMBER      VARCHAR   (50) = ''
  ,@START_DT        DATETIME
  ,@END_DT          DATETIME
  ,@MAP_X           INT = 0
  ,@MAP_Y           INT = 0

AS

  SET NOCOUNT ON

  BEGIN TRAN

	/* 상세내용이 다를경우에만 수정신청으로 취급하여 검수대기로 변경(나머지는 그냥 수정) -- 신혜원파트장 요청
	--------------------------------------------------------------------------------------*/
	DECLARE @MOD_REQ_YN CHAR(1)
	SET @MOD_REQ_YN = 'N'

	DECLARE @CONFIRM_YN CHAR(1)
	SET @CONFIRM_YN = '0'

	DECLARE @ORG_CONTENTS VARCHAR(MAX)	--// 기존 상세
	DECLARE @NEW_CONTENTS VARCHAR(MAX)	--// 변경 상세

	SET @NEW_CONTENTS = CONVERT(VARCHAR(MAX), @CONTENTS)

	SELECT @ORG_CONTENTS = CONVERT(VARCHAR(MAX), CONTENTS)
				,@CONFIRM_YN = CONFIRM_YN
	FROM PJ_AD_USERREG_TB
	WHERE ADID = @ADID

	IF @ORG_CONTENTS <> @NEW_CONTENTS
		BEGIN
			SET @MOD_REQ_YN = 'Y'
		END
	/*
	--------------------------------------------------------------------------------------*/

    UPDATE PJ_AD_USERREG_TB
       SET CO_NAME     = @CO_NAME
          ,PHONE       = @PHONE
          ,HPHONE      = @HPHONE
          ,BIZ_CD      = @BIZ_CD
          ,AREA_A      = @AREA_A
          ,AREA_B      = @AREA_B
          ,AREA_C      = @AREA_C
          ,AREA_DETAIL = @AREA_DETAIL
          ,HOMEPAGE    = @HOMEPAGE
          ,TITLE       = @TITLE
          ,CONTENTS    = @CONTENTS
          ,THEME_CD    = @THEME_CD
          ,PAY_CD      = @PAY_CD
          ,PAY_AMT     = @PAY_AMT
          ,BIZ_NUMBER  = @BIZ_NUMBER
          ,START_DT    = @START_DT
          ,END_DT      = @END_DT
          ,MAP_X       = @MAP_X
          ,MAP_Y       = @MAP_Y
          ,MOD_DT      = GETDATE()
     WHERE ADID = @ADID

	IF @MOD_REQ_YN = 'Y'
		BEGIN
			UPDATE PJ_AD_USERREG_TB
					SET CONFIRM_YN  = 0
							,MOD_REQ_DT  = GETDATE()
					WHERE ADID = @ADID
		END

	IF @CONFIRM_YN = '2'
		BEGIN
			UPDATE PJ_AD_USERREG_TB
				SET CONFIRM_YN  = 0
						,MOD_REQ_DT  = GETDATE()
				WHERE ADID = @ADID
		END

  COMMIT TRAN

  -- 시작일이 오늘자보다 오늘 또는 이전일 종료일이 오늘보다 같거나 이전일이면
  IF @CONFIRM_YN = '1' AND (CONVERT(VARCHAR(10), @START_DT, 120) <= CONVERT(VARCHAR(10), GETDATE(), 120)) AND (CONVERT(VARCHAR(10), @END_DT, 120) >= CONVERT(VARCHAR(10), GETDATE(), 120))
    BEGIN
			IF @MOD_REQ_YN = 'N'
				BEGIN
      -- 게재테이블로 이관 (등록대행인 경우 두번째 인자값 'A')
      EXECUTE PUT_AD_PUBLISH_TRANS_PROC @ADID, 'U'
				END
    END









GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_ADEND_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












/*************************************************************************************
 *  단위 업무 명 : 관리자 > 등록대행 광고 > 광고마감 처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_ADEND_PROC '1, 2, 3'
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_ADEND_PROC]

  @ADID   INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	BEGIN TRAN

	UPDATE DBO.PJ_AD_AGENCY_TB
	   SET END_YN = 1
        ,PAUSE_YN = 0
        ,STOP_DT = GETDATE()
	 WHERE ADID = @ADID;

	DELETE FROM PJ_AD_PUBLISH_TB
	 WHERE ADID = @ADID
	   AND AD_KIND = 'A'

	COMMIT TRAN




GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_ECOMM_AD_STATUS_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 ) E-COMM 상태처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/05
 *  수   정   자 : 신 장 순 (jssin@mediawill.com)
 *  수   정   일 : 2015.02.02
 *  설        명 : 검수 취소시(승인 -> 거절, 거절 -> 승인 으로 상태 변경  신혜원파트장 요청)
 *  주 의  사 항 : E-Comm/등록대행 검수관리를 하면서 같은 SP를 함께 사용!!
 *  사 용  소 스 :
 *  사 용  예 제 : EXECUTE EDIT_M_ECOMM_AD_STATUS_PROC 1143,'U','CF'
 *************************************************************************************/
CREATE PROC [dbo].[EDIT_M_ECOMM_AD_STATUS_PROC]

  @ADID INT
  ,@AD_KIND CHAR(1)    --광고형태 (P:신문컨버젼데이터, A:등록대행, U:회원등록)
  ,@PROC_KIND CHAR(2)  --처리형태 (C:검수, NC:검수취소, E:마감, R:재개제, EC:마감(환불))

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(3000)
  DECLARE @SQL_TABLE VARCHAR(20)
  DECLARE @PUB_YN BIT    -- 0: 게제테이블에서 삭제, 1: 게재테이블로 등록

  SET @SQL = ''
  SET @PUB_YN = 0

	DECLARE @CONFIRM_CNT INT = 0
  -- 광고형태에 따른 테이블
  IF @AD_KIND = 'A'
		BEGIN
    SET @SQL_TABLE = 'PJ_AD_AGENCY_TB'
			SET @CONFIRM_CNT = (SELECT ISNULL((SELECT CONFIRM_CNT FROM PJ_AD_AGENCY_TB WHERE ADID = @ADID), 0))
		END
  ELSE IF @AD_KIND = 'U'
		BEGIN
    SET @SQL_TABLE = 'PJ_AD_USERREG_TB'
			SET @CONFIRM_CNT = (SELECT ISNULL((SELECT CONFIRM_CNT FROM PJ_AD_USERREG_TB WHERE ADID = @ADID), 0))
		END

  -- 상태처리
  IF @PROC_KIND = 'C'  -- 검수처리 및 게재일자 갱신
    BEGIN

			--2015.02.16 예약광고 검수승인시에는 게재 되지 않아야 되므로 상태값만 변경인 아래로직으로 변경 (@PUB_YN = 0)
			--예약광고는 등록대행에서만 가능
			DECLARE @RESERVATION CHAR(1) = 'N'

			IF @AD_KIND = 'A'
				BEGIN
					SELECT @RESERVATION = CASE WHEN START_DT > CONVERT(VARCHAR(10), GETDATE(), 120) THEN 'Y' ELSE 'N' END
					FROM PJ_AD_AGENCY_TB
					WHERE ADID = @ADID
				END

			IF @RESERVATION = 'Y'
				BEGIN
					SET @SQL = 'UPDATE '+ @SQL_TABLE +'
												 SET CONFIRM_YN = 1
														,CONFIRM_CNT = (ISNULL(CONFIRM_CNT, 0) + 1)
														,MOD_DT = GETDATE()
											 WHERE ADID = '+ CAST(@ADID AS VARCHAR(10))

					SET @PUB_YN = 0
				END
			ELSE
				BEGIN
					SET @SQL = 'UPDATE '+ @SQL_TABLE +'
												 SET CONFIRM_YN = 1
														,CONFIRM_CNT = (ISNULL(CONFIRM_CNT, 0) + 1)
														,START_DT = CASE WHEN ISNULL(CONFIRM_CNT, 0) > 0 THEN START_DT ELSE CONVERT(VARCHAR(10),GETDATE(),120) END
														,END_DT = CASE WHEN ISNULL(CONFIRM_CNT, 0) > 0 THEN END_DT ELSE CONVERT(VARCHAR(10),DATEADD(d,DATEDIFF(d,START_DT,END_DT),GETDATE()),120) END
														,MOD_DT = GETDATE()
											 WHERE ADID = '+ CAST(@ADID AS VARCHAR(10))

					SET @PUB_YN = 1

					IF @CONFIRM_CNT = 0
						BEGIN
					-- 효과옵션 갱신 (광고형태 공통)
					BEGIN TRAN

						UPDATE PJ_OPTION_TB
							 SET OPT_SUB_A_START_DT = (CASE WHEN OPT_SUB_A = 1 THEN CONVERT(VARCHAR(10),GETDATE(),120) END)
									,OPT_SUB_A_END_DT = CONVERT(VARCHAR(10),DATEADD(d,DATEDIFF(d,OPT_SUB_A_START_DT,OPT_SUB_A_END_DT),GETDATE()),120)
									,OPT_SUB_B_START_DT = (CASE WHEN OPT_SUB_B = 1 THEN CONVERT(VARCHAR(10),GETDATE(),120) END)
									,OPT_SUB_B_END_DT = CONVERT(VARCHAR(10),DATEADD(d,DATEDIFF(d,OPT_SUB_B_START_DT,OPT_SUB_B_END_DT),GETDATE()),120)
									,OPT_SUB_C_START_DT = (CASE WHEN OPT_SUB_C = 1 THEN CONVERT(VARCHAR(10),GETDATE(),120) END)
									,OPT_SUB_C_END_DT = CONVERT(VARCHAR(10),DATEADD(d,DATEDIFF(d,OPT_SUB_C_START_DT,OPT_SUB_C_END_DT),GETDATE()),120)
									,OPT_SUB_D_START_DT = (CASE WHEN OPT_SUB_D = 1 THEN CONVERT(VARCHAR(10),GETDATE(),120) END)
									,OPT_SUB_D_END_DT = CONVERT(VARCHAR(10),DATEADD(d,DATEDIFF(d,OPT_SUB_D_START_DT,OPT_SUB_D_END_DT),GETDATE()),120)
									,OPT_SUB_E_START_DT = (CASE WHEN OPT_SUB_E = 1 THEN CONVERT(VARCHAR(10),GETDATE(),120) END)
									,OPT_SUB_E_END_DT = CONVERT(VARCHAR(10),DATEADD(d,DATEDIFF(d,OPT_SUB_E_START_DT,OPT_SUB_E_END_DT),GETDATE()),120)
						 WHERE ADID = @ADID
							 AND AD_KIND = @AD_KIND

					COMMIT TRAN
						END
				END

    END
  ELSE IF @PROC_KIND = 'NC'  -- 검수취소처리
    BEGIN
			/*
			--// 상태값 변경 [승인 -> 거절], [거절 -> 승인]
			DECLARE @ORG_CONFIRM_YN CHAR(1)

			IF @AD_KIND = 'A'
				BEGIN
					SELECT @ORG_CONFIRM_YN = CONFIRM_YN
					FROM PJ_AD_AGENCY_TB
					WHERE ADID = @ADID
				END
			ELSE IF @AD_KIND = 'U'
				BEGIN
					SELECT @ORG_CONFIRM_YN = CONFIRM_YN
					FROM PJ_AD_USERREG_TB
					WHERE ADID = @ADID
				END

			IF @ORG_CONFIRM_YN = '2'
				BEGIN
					SET @SQL = '
					UPDATE '+ @SQL_TABLE +'
                     SET CONFIRM_YN = 1
                        ,MOD_DT = GETDATE()
                   WHERE ADID = ' + CAST(@ADID AS VARCHAR(10))
					SET @PUB_YN = 1
				END
			ELSE IF @ORG_CONFIRM_YN = '1'
				BEGIN
					SET @SQL = '
					UPDATE '+ @SQL_TABLE +'
                     SET CONFIRM_YN = 2
                        ,MOD_DT = GETDATE()
                   WHERE ADID = ' + CAST(@ADID AS VARCHAR(10))
					SET @PUB_YN = 0
				END
			*/

      SET @SQL = 'UPDATE '+ @SQL_TABLE +'
                     SET CONFIRM_YN = 0
                        ,MOD_DT = GETDATE()
                   WHERE ADID = '+ CAST(@ADID AS VARCHAR(10))
      SET @PUB_YN = 0

    END
	ELSE IF @PROC_KIND = 'CF'  -- 검수거절
    BEGIN
      SET @SQL = 'UPDATE '+ @SQL_TABLE +'
                     SET CONFIRM_YN = 2
                        ,MOD_DT = GETDATE()
                   WHERE ADID = '+ CAST(@ADID AS VARCHAR(10))
      SET @PUB_YN = 0
    END
  ELSE IF @PROC_KIND = 'E' OR @PROC_KIND = 'EC'  -- 마감 or 마감(환불)
    BEGIN
      SET @SQL = 'UPDATE '+ @SQL_TABLE +'
                     SET END_YN = 1
                        ,STOP_DT = GETDATE()
                   WHERE ADID = '+ CAST(@ADID AS VARCHAR(10))
      SET @PUB_YN = 0
    END
  ELSE IF @PROC_KIND = 'R'  -- 재개제
    BEGIN
      SET @SQL = 'UPDATE '+ @SQL_TABLE +'
                     SET END_YN = 0
                        ,STOP_DT = NULL
                   WHERE ADID = '+ CAST(@ADID AS VARCHAR(10))
      SET @PUB_YN = 1
    END

  -- 마감(환불)인 경우 결제정보 환불처리
  IF @PROC_KIND = 'EC'
    BEGIN
      EXECUTE EDIT_M_ECOMM_PAY_STATUS_PROC @ADID, 1, 2
    END

  -- 게재테이블 이관 OR 삭제
  IF @PUB_YN = 1
    BEGIN
      EXECUTE PUT_AD_PUBLISH_TRANS_PROC @ADID, @AD_KIND
    END
  ELSE IF @PUB_YN = 0
    BEGIN
      SET @SQL = @SQL +';DELETE FROM PJ_AD_PUBLISH_TB
                         WHERE ADID = '+ CAST(@ADID AS VARCHAR(10)) +'
                           AND AD_KIND = '''+ @AD_KIND +''''
    END


  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL







GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_ECOMM_MODIFY_CONFIRM_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 ) E-COMM 결제상태처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_ECOMM_MODIFY_CONFIRM_PROC 1546, 1
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_ECOMM_MODIFY_CONFIRM_PROC]

  @ADID INT
  ,@CONFIRM_YN CHAR(1)  -- 수정검수상태 (0:검수취소, 1:검수완료)

AS

  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(500)
  DECLARE @SQL_FIELD NVARCHAR(50)

  SET @SQL = ''

  IF @CONFIRM_YN = '0'
    SET @SQL_FIELD = ',CONFIRM_DT = NULL '
  ELSE IF @CONFIRM_YN = '1'
    SET @SQL_FIELD = ',CONFIRM_DT = GETDATE() '
	ELSE IF @CONFIRM_YN = '2'
    SET @SQL_FIELD = ',CONFIRM_DT = GETDATE() '

  SET @SQL = 'UPDATE PJ_AD_USERREG_MODIFY_TB
    SET CONFIRM_YN = '+ @CONFIRM_YN +'
			 ,CONFIRM_CNT = (ISNULL(CONFIRM_CNT, 0) + 1)
  '+ @SQL_FIELD +'
  WHERE ADID = '+ CAST(@ADID AS VARCHAR(10))

  --PRINT @SQL
  --BEGIN
	EXECUTE SP_EXECUTESQL @SQL
  --END
  --// 수정검수완료시 PJ_AD_USERREG_TB로 데이터 갱신 후 게재테이블로 이관
  IF @CONFIRM_YN = '1'
    BEGIN
      -- PJ_AD_USERREG_TB로 데이터 갱신
      UPDATE B
         SET CO_NAME     = A.CO_NAME
            ,PHONE       = A.PHONE
            ,HPHONE      = A.HPHONE
            ,BIZ_CD      = A.BIZ_CD
            ,AREA_A      = A.AREA_A
            ,AREA_B      = A.AREA_B
            ,AREA_C      = A.AREA_C
            ,AREA_DETAIL = A.AREA_DETAIL
            ,HOMEPAGE    = A.HOMEPAGE
            ,TITLE       = A.TITLE
            ,CONTENTS    = A.CONTENTS
            ,THEME_CD    = A.THEME_CD
            ,PAY_CD      = A.PAY_CD
            ,PAY_AMT     = A.PAY_AMT
            ,BIZ_NUMBER  = A.BIZ_NUMBER
            ,MAP_X       = A.MAP_X
            ,MAP_Y       = A.MAP_Y
        FROM PJ_AD_USERREG_MODIFY_TB AS A
        JOIN PJ_AD_USERREG_TB AS B
          ON B.ADID = A.ADID
       WHERE A.ADID = @ADID;

      -- 게재테이블로 데이터 이관
      EXECUTE DBO.PUT_AD_PUBLISH_TRANS_PROC @ADID, 'U'

    END







GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_ECOMM_PAY_STATUS_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 ) E-COMM 결제상태처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_ECOMM_PAY_STATUS_PROC 1, 1, 1
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_ECOMM_PAY_STATUS_PROC]

  @ADID INT
  ,@AD_GBN TINYINT
  ,@PRNAMTOK TINYINT  -- 결재상태 (1:결제완료, 2:결제취소)

AS

  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(500)
  DECLARE @SQL_FIELD NVARCHAR(50)

  SET @SQL = ''

  IF @PRNAMTOK = 1
    SET @SQL_FIELD = ',RECDATE = GETDATE(), CANCELDATE = NULL '
  ELSE IF @PRNAMTOK = 2
    SET @SQL_FIELD = ',CANCELDATE = GETDATE() '

  SET @SQL = 'UPDATE PJ_RECCHARGE_TB
    SET PRNAMTOK = '+ CAST(@PRNAMTOK AS CHAR(1)) +'
  '+ @SQL_FIELD +'
  WHERE AD_GBN = '+ CAST(@AD_GBN AS CHAR(1)) +'
    AND ADID = '+ CAST(@ADID AS VARCHAR(10))

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL








GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_MAINBANNER_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 관리자 > 사이트관리 > 베너수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_MAINBANNER_PROC 8
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_MAINBANNER_PROC]

  @IDX                 INT
  ,@LOCAL_CD           TINYINT
  ,@BANNER_IMG         VARCHAR(100) = ''
  ,@BANNER_DETAIL_IMG  VARCHAR(100) = ''
  ,@BANNER_TYPE        CHAR(1)
  ,@BANNER_URL         VARCHAR(100)
  ,@BANNER_CNT_FLAG    INT
  ,@BANNER_DESC        VARCHAR(200)
  ,@START_DT           VARCHAR(10)
  ,@END_DT             VARCHAR(10)

AS

  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_SUB NVARCHAR(500)
  SET @SQL = ''
  SET @SQL_SUB = ''

  IF @BANNER_IMG <> ''
    BEGIN
      SET @SQL_SUB = @SQL_SUB + ' ,BANNER_IMG = '''+ @BANNER_IMG +''''
    END

  IF @BANNER_DETAIL_IMG <> ''
    BEGIN
      SET @SQL_SUB = @SQL_SUB + ' ,BANNER_DETAIL_IMG = '''+ @BANNER_DETAIL_IMG +''''
    END

  -- 수정쿼리
  SET @SQL = 'UPDATE dbo.PJ_MAIN_BANNER_TB
     SET LOCAL_CD = '+ CAST(@LOCAL_CD AS CHAR(1)) +'
        ,BANNER_TYPE = '''+ @BANNER_TYPE +'''
        ,BANNER_URL = '''+ @BANNER_URL +'''
        ,BANNER_CNT_FLAG = '''+ CAST(@BANNER_CNT_FLAG AS VARCHAR(5)) +'''
        ,BANNER_DESC = '''+ @BANNER_DESC +'''
        ,START_DT = '''+ @START_DT +'''
        ,END_DT = '''+ @END_DT +'''
        '+ @SQL_SUB +'
   WHERE IDX = '+ CAST(@IDX AS VARCHAR(3))

  EXECUTE SP_EXECUTESQL @SQL









GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_NOTICE_MAINDIS_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 > 공지사항 메인게재여부 일괄처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_NOTICE_MAINDIS_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_NOTICE_MAINDIS_PROC]

  @FLAGFIELD  VARCHAR(12)
  ,@FLAGVALUE  CHAR(1)
  ,@SERIAL  VARCHAR(1000)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  SET @SQL = ''

  SET @SQL = 'UPDATE FINDDB2.FINDCOMMON.DBO.SITENEWS
                 SET '+ @FLAGFIELD +' = '''+ @FLAGVALUE +'''
               WHERE SERIAL IN ('+ @SERIAL +')'

  EXECUTE SP_EXECUTESQL @SQL







GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_NOTICE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 > 공지사항 수정하기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_NOTICE_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_NOTICE_PROC]

  @SERIAL         INT
  ,@MENUGBN       TINYINT
  ,@TITLE         VARCHAR(500)
  ,@CONTENTS      NVARCHAR(4000)
  ,@MAINDISFLAG   CHAR(1)
  ,@LOCALDISFLAG  CHAR(1)
  ,@TARGETGBN     CHAR(1)
  ,@OPTIONS       CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  UPDATE FINDDB2.FINDCOMMON.DBO.SITENEWS
     SET MENUGBN			= @MENUGBN
        ,TITLE				= @TITLE
        ,CONTENTS			= @CONTENTS
        ,MAINDISFLAG	= @MAINDISFLAG
        ,LOCALDISFLAG	= @LOCALDISFLAG
        ,TARGETGBN		= @TARGETGBN
        ,OPTIONS			= @OPTIONS
   WHERE SERIAL	= @SERIAL







GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_PAPER_AD_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 관리자 > 광고관리 - 신문광고 수정처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/12/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /mag/admanage/PaperAdModifyProc.asp
 *  사 용  예 제 : EXECUTE DBO.EDIT_M_PAPER_AD_PROC 1005554949,'우가명가갈비집','016-724-9786,02)883-8015','여홀서빙 경험자우대 09:30~22시 급여상담후결정 낙성대입구「우가명가갈비집」',4104015,'서울특별시','관악구','봉천6동'
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_PAPER_AD_PROC]

  @LINEADID VARCHAR(50)
 ,@CONAME   VARCHAR(200)
 ,@PHONE    VARCHAR(172)
 ,@HPHONE	VARCHAR(15)
 ,@TITLE    NVARCHAR(512)
 ,@CONTENTS TEXT
 ,@BIZCODE  INT
 ,@METRO    VARCHAR(50)
 ,@CITY     VARCHAR(50)
 ,@DONG     VARCHAR(50)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN

    UPDATE DAILY_JOBPAPER_TB
       SET CONAME = @CONAME
          ,PHONE = @PHONE
          ,HPHONE = @HPHONE
          ,CODE = @BIZCODE
          ,TITLE = @TITLE
          ,CONTENTS = @CONTENTS
          ,METRO = @METRO
          ,CITY = @CITY
          ,DONG = @DONG
     WHERE LINEADID = @LINEADID

  COMMIT TRAN










GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_PAPERADEND_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 관리자 > 광고관리 - 신문광고마감 처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/11/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /mag/admanage/AdEndProc.asp
 *  사 용  예 제 : EXEC DBO.EDIT_M_PAPERADEND_PROC 1, 'Y'
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_PAPERADEND_PROC]

  @LINEADID INT
  ,@END_YN   CHAR(1)        -- 광고게재상태 (N:게재, Y:마감)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN
    -- 상태값 적용
    UPDATE DAILY_JOBPAPER_TB
       SET END_YN = @END_YN
          ,MODIFY_DT = GETDATE()
     WHERE LINEADID = @LINEADID
  COMMIT TRAN

  IF @END_YN = 'Y'
    BEGIN
      -- 게재테이블에서 삭제
      DELETE
        FROM PJ_AD_PUBLISH_TB
       WHERE ADID = @LINEADID
         AND AD_KIND = 'P';

      -- 옵션테이블에서 삭제
      DELETE
        FROM PJ_OPTION_TB
       WHERE ADID = @LINEADID
         AND AD_KIND = 'P'
    END
  ELSE
    BEGIN
      EXECUTE PUT_M_PAPER_AD_TRANS_PROC @LINEADID
    END






GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_TEL_STATUS_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 관리자 > 등록대행신청 > 신청현황 수정
 *  작   성   자 : 최봉기 (cbk07@mediawill.com)
 *  작   성   일 : 2011/06/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXECUTE DBO.EDIT_M_TEL_STATUS_PROC '53','1','TEST','cbk07'
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_TEL_STATUS_PROC]

  @SEQ INT
  ,@STATUS INT
  ,@RESULT VARCHAR(100)
  ,@MAG_ID VARCHAR(30)

AS

  SET NOCOUNT ON

    UPDATE PJ_AGENT_AD_TEL_TB
       SET STATUS = @STATUS
          ,RESULT = @RESULT
          ,MAG_ID = @MAG_ID
          ,MAG_DATE = GETDATE()
     WHERE SEQ = @SEQ


  SET NOCOUNT OFF






GO
/****** Object:  StoredProcedure [dbo].[EXEC_F_AD_COUNT_ADD_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고 카운터 증가
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EXEC_F_AD_COUNT_ADD_PROC 27020, 'A'
 *************************************************************************************/


CREATE PROC [dbo].[EXEC_F_AD_COUNT_ADD_PROC]

  @ADID INT
  ,@AD_KIND CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @CNT INT

  SELECT @CNT = COUNT(*)
    FROM PJ_AD_COUNT_TB
   WHERE ADID = @ADID
     AND AD_KIND = @AD_KIND

  IF @CNT > 0  -- 기존 카운팅 내역이 있다면
    BEGIN
      UPDATE PJ_AD_COUNT_TB
         SET HIT = HIT + 1
       WHERE ADID = @ADID
         AND AD_KIND = @AD_KIND
    END
  ELSE  -- 없으면 등록
    BEGIN
      INSERT INTO PJ_AD_COUNT_TB
        (ADID, AD_KIND, HIT)
      VALUES
        (@ADID, @AD_KIND, 1)
    END







GO
/****** Object:  StoredProcedure [dbo].[EXEC_OPTION_LISTUP_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 실행 > 옵션적용 : 리스트업
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EXEC_OPTION_LISTUP_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EXEC_OPTION_LISTUP_PROC]

  @ADID     INT
  ,@AD_KIND CHAR(1)  --광고종류 (A: 등록대행, U: 회원등록)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN

    UPDATE PJ_AD_PUBLISH_TB
       SET SORT_ID = 1
      FROM PJ_AD_PUBLISH_TB AS A
           JOIN PJ_OPTION_TB AS B
             ON B.ADID = A.ADID
            AND B.AD_KIND = A.AD_KIND
     WHERE B.OPT_SUB_E = 1
       AND (CONVERT(VARCHAR(10),B.OPT_SUB_E_START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
            AND B.OPT_SUB_E_END_DT >= CONVERT(VARCHAR(10),GETDATE(),120))
       AND A.ADID = @ADID
       AND A.AD_KIND = @AD_KIND

  COMMIT TRAN








GO
/****** Object:  StoredProcedure [dbo].[EXEC_PAPERJOB_VBANK_PAYOK_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 결제 > 유흥구인 온라인 결제 입금에 따른 처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EXEC_PAPERJOB_VBANK_PAYOK_PROC 9, 1
 *************************************************************************************/
CREATE PROC [dbo].[EXEC_PAPERJOB_VBANK_PAYOK_PROC]

  @SERIAL  INT
  ,@AD_GBN  TINYINT

AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	DECLARE @RETURN	INT	= -1

	IF Not(EXISTS(SELECT 'X' FROM PJ_RECCHARGE_TB WHERE SERIAL = @SERIAL AND CHARGE_KIND = 1 AND (BANKNM <> '' OR ISNULL(BANKNM, '') <> '') AND (ACCOUNTNUM <> '' OR ISNULL(ACCOUNTNUM, '') <> '') AND (RECNM <> '' OR ISNULL(RECNM, '') <> '') AND (INIPAYTID <> '' OR ISNULL(INIPAYTID, '') <> '')))
		BEGIN
			RETURN @RETURN;
		END
	BEGIN TRY

		BEGIN TRAN

  UPDATE PJ_RECCHARGE_TB
     SET PRNAMTOK = 1
         ,RECDATE = GETDATE()
   WHERE SERIAL = @SERIAL
     AND AD_GBN = @AD_GBN

		COMMIT TRAN

		SET @RETURN = 0

	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

		-- SMS 문자 발송
		EXECUTE TAX.COMDB1.DBO.PUT_SENDSMS_PROC '0230190213','FA SYSTEM','개발담당','01073779770','[YAALBA] 가상계좌 결제장애발생'  -- 신장순

	  -- 오류 로그 기록
	  INSERT INTO FINDDB1.PAPERREG.DBO.VB_Bank_Log
	   (SERIAL, ERROR_CD, ERROR_MSG)
	  SELECT @SERIAL, ERROR_NUMBER(), '[YAALBA]' + ERROR_MESSAGE()

	END CATCH

	RETURN @RETURN

END



GO
/****** Object:  StoredProcedure [dbo].[EXEC_PUB_AD_YAALBA_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROC [dbo].[EXEC_PUB_AD_YAALBA_PROC]

  @TEMPACPTID VARCHAR(25)
  ,@REALACPTID INT
  ,@TYPECODE INT  -- 102: 저장, 103: 수정

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  BEGIN TRAN
	
--select * from YAALBA_WILLS.PAPERJOB_WILLS.DBO.PJ_AD_AGENCY_TB -> MWS_YAALBA_AD_TB
     -- 매칭광고번호 등록 (최초 등록시)
    UPDATE PJ_AD_AGENCY_TB
       SET ORG_LINEADID = @REALACPTID
          ,MWPLUS_LINEADID = @REALACPTID
     WHERE TEMP_LINEADID = @TEMPACPTID
       AND ORG_LINEADID IS NULL

    -- PP_AD_TB
    DECLARE @CO_NAME	varchar	(30)
    DECLARE @PHONE	varchar	(127)
    DECLARE @HPHONE	varchar	(15)
    DECLARE @BIZ_CD	int
    DECLARE @AREA_A	varchar	(50)
    DECLARE @AREA_B	varchar	(50)
    DECLARE @AREA_C	varchar	(50)
    DECLARE @AREA_DETAIL	varchar	(50)
    DECLARE @HOMEPAGE	varchar	(100)
    DECLARE @TITLE	varchar	(500)
    DECLARE @CONTENTS	nvarchar(max)
    DECLARE @THEME_CD	tinyint
    DECLARE @PAY_CD	tinyint
    DECLARE @PAY_AMT	int
    DECLARE @BIZ_NUMBER	varchar	(50)
    DECLARE @START_DT	datetime
    DECLARE @END_DT	datetime
    DECLARE @MAP_X	varchar(25)
    DECLARE @MAP_Y	varchar(25)
    DECLARE @MWPLUS_LINEADID	int
    DECLARE @MWPLUS_OPTION	int
    DECLARE @REG_KIND	tinyint
    DECLARE @AMOUNT_ONLINE	money
    DECLARE @AMOUNT_MWPLUS	money
    DECLARE @MAGID	varchar	(30)
    DECLARE @MAGBRANCH	tinyint
    DECLARE @ADID	int
    DECLARE @AD_KIND	char	(1)
    DECLARE @LOGO_IMG	varchar	(200)
    DECLARE @GRAND_IMG	varchar	(200)
    DECLARE @REASON	varchar	(200)

    DECLARE @LOCAL_CD	tinyint
    DECLARE @OPTION_MAIN_CD	tinyint
    DECLARE @TEMPLATE_CD	tinyint
    DECLARE @OPT_SUB_A	bit
    DECLARE @OPT_SUB_A_START_DT	varchar	(10)
    DECLARE @OPT_SUB_A_END_DT	varchar	(10)
    DECLARE @OPT_SUB_B	bit
    DECLARE @OPT_SUB_B_START_DT	varchar	(10)
    DECLARE @OPT_SUB_B_END_DT	varchar	(10)
    DECLARE @OPT_SUB_C	bit
    DECLARE @OPT_SUB_C_START_DT	varchar	(10)
    DECLARE @OPT_SUB_C_END_DT	varchar	(10)
    DECLARE @OPT_SUB_D	bit
    DECLARE @OPT_SUB_D_START_DT	varchar	(10)
    DECLARE @OPT_SUB_D_END_DT	varchar	(10)
    DECLARE @OPT_SUB_E	bit
    DECLARE @OPT_SUB_E_START_DT	varchar	(10)
    DECLARE @OPT_SUB_E_END_DT	varchar	(10)

    SELECT @ADID                = A.ADID
          ,@CO_NAME             = A.CO_NAME
          ,@PHONE               = A.PHONE
          ,@HPHONE              = A.HPHONE
          ,@BIZ_CD              = A.BIZ_CD
          ,@AREA_A              = A.AREA_A
          ,@AREA_B              = A.AREA_B
          ,@AREA_C              = A.AREA_C
          ,@AREA_DETAIL         = A.AREA_DETAIL
          ,@HOMEPAGE            = ''
          ,@TITLE               = A.TITLE
          ,@CONTENTS            = A.CONTENTS
          ,@THEME_CD            = A.THEME_CD
          ,@PAY_CD              = A.PAY_CD
          ,@PAY_AMT             = A.PAY_AMT
          ,@BIZ_NUMBER          = A.BIZ_NUMBER
          ,@START_DT            = A.START_DT
          ,@END_DT              = A.END_DT
          ,@MAP_X               = A.MAP_X
          ,@MAP_Y               = A.MAP_Y
          ,@MWPLUS_LINEADID     = A.MWPLUS_LINEADID
          ,@MWPLUS_OPTION       = 0
          ,@REG_KIND            = A.REG_KIND
          ,@AMOUNT_ONLINE       = A.AMOUNT_ONLINE
          ,@AMOUNT_MWPLUS       = A.AMOUNT_MWPLUS
          ,@MAGID               = A.MAGID
          ,@MAGBRANCH           = A.MAGBRANCH
          ,@REASON              = A.REASON

          ,@LOCAL_CD            = B.LOCAL_CD
          ,@OPTION_MAIN_CD      = B.OPTION_MAIN_CD
          ,@TEMPLATE_CD         = B.TEMPLATE_CD
          ,@OPT_SUB_A           = B.OPT_SUB_A
          ,@OPT_SUB_A_START_DT  = B.OPT_SUB_A_START_DT
          ,@OPT_SUB_A_END_DT    = B.OPT_SUB_A_END_DT
          ,@OPT_SUB_B           = B.OPT_SUB_B
          ,@OPT_SUB_B_START_DT  = B.OPT_SUB_B_START_DT
          ,@OPT_SUB_B_END_DT    = B.OPT_SUB_B_END_DT
          ,@OPT_SUB_C           = B.OPT_SUB_C
          ,@OPT_SUB_C_START_DT  = B.OPT_SUB_C_START_DT
          ,@OPT_SUB_C_END_DT    = B.OPT_SUB_C_END_DT
          ,@OPT_SUB_D           = B.OPT_SUB_D
          ,@OPT_SUB_D_START_DT  = B.OPT_SUB_D_START_DT
          ,@OPT_SUB_D_END_DT    = B.OPT_SUB_D_END_DT
          ,@OPT_SUB_E           = B.OPT_SUB_E
          ,@OPT_SUB_E_START_DT  = B.OPT_SUB_E_START_DT
          ,@OPT_SUB_E_END_DT    = B.OPT_SUB_E_END_DT
          ,@AD_KIND             = B.AD_KIND
     FROM PJ_AD_AGENCY_TB A, PJ_OPTION_TB B
    WHERE A.TEMP_LINEADID = @TEMPACPTID
			AND A.TEMP_LINEADID = B.TEMP_LINEADID

    IF @TYPECODE = 102    -- 저장
      BEGIN
        EXECUTE dbo.PUT_M_AD_AGENCY_PROC @CO_NAME        
                                                        ,@PHONE          
                                                        ,@HPHONE         
                                                        ,@BIZ_CD         
                                                        ,@AREA_A         
                                                        ,@AREA_B         
                                                        ,@AREA_C         
                                                        ,@AREA_DETAIL    
                                                        ,@HOMEPAGE       
                                                        ,@TITLE          
                                                        ,@CONTENTS       
                                                        ,@THEME_CD       
                                                        ,@PAY_CD         
                                                        ,@PAY_AMT        
                                                        ,@BIZ_NUMBER     
                                                        ,@START_DT       
                                                        ,@END_DT         
                                                        ,@MAP_X          
                                                        ,@MAP_Y          
                                                        ,@MWPLUS_LINEADID
                                                        ,@MWPLUS_OPTION  
                                                        ,@REG_KIND       
                                                        ,@AMOUNT_ONLINE  
                                                        ,@AMOUNT_MWPLUS  
                                                        ,@MAGID          
                                                        ,@MAGBRANCH      
                                                        ,@ADID = @ADID OUTPUT;

        -- 야알비 시퀀스키 갱신
       -- UPDATE PJ_AD_AGENCY_TB
       --    SET ADID = @ADID
       --  WHERE TEMP_LINEADID = @TEMPACPTID




        -- 옵션 (지점은 옵션 수정권한이 없으므로 등록시에만 옵션데이터 등록)
        EXECUTE PUT_AD_OPTION_PROC @ADID
                                                      ,@AD_KIND
                                                      ,@LOCAL_CD
                                                      ,@OPTION_MAIN_CD
                                                      ,@TEMPLATE_CD
                                                      ,@OPT_SUB_A
                                                      ,@OPT_SUB_A_START_DT
                                                      ,@OPT_SUB_A_END_DT
                                                      ,@OPT_SUB_B
                                                      ,@OPT_SUB_B_START_DT
                                                      ,@OPT_SUB_B_END_DT
                                                      ,@OPT_SUB_C
                                                      ,@OPT_SUB_C_START_DT
                                                      ,@OPT_SUB_C_END_DT
                                                      ,@OPT_SUB_D
                                                      ,@OPT_SUB_D_START_DT
                                                      ,@OPT_SUB_D_END_DT
                                                      ,@OPT_SUB_E
                                                      ,@OPT_SUB_E_START_DT
                                                      ,@OPT_SUB_E_END_DT


      END
    ELSE
      BEGIN
        EXECUTE EDIT_M_AD_AGENCY_WILLS_PROC @ADID
                                                         ,@CO_NAME
                                                         ,@PHONE
                                                         ,@HPHONE
                                                         ,@BIZ_CD
                                                         ,@AREA_A
                                                         ,@AREA_B
                                                         ,@AREA_C
                                                         ,@AREA_DETAIL
                                                         ,@HOMEPAGE
                                                         ,@TITLE
                                                         ,@CONTENTS
                                                         ,@THEME_CD
                                                         ,@PAY_CD
                                                         ,@PAY_AMT
                                                         ,@BIZ_NUMBER
                                                         ,@START_DT
                                                         ,@END_DT
                                                         ,@MAP_X
                                                         ,@MAP_Y
                                                         ,@MWPLUS_LINEADID
                                                         ,@REG_KIND
                                                         ,@AMOUNT_ONLINE
                                                         ,@AMOUNT_MWPLUS
                                                         ,@REASON
                                                         ,0
																												 ,'W'
      END

    EXECUTE EDIT_AD_LOGO_IMAGE_PROC @ADID
                                                       ,@AD_KIND
                                                       ,@LOGO_IMG

    EXECUTE EDIT_AD_GRANDLOGO_IMAGE_PROC @ADID
                                                            ,@AD_KIND
                                                            ,@GRAND_IMG
     
    -- 광고 로그
    EXECUTE PUT_M_MAG_HISTORY_PROC @ADID
                                                      ,@AD_KIND
                                                      ,@MAGID
                                                      ,@REASON

  COMMIT TRAN










GO
/****** Object:  StoredProcedure [dbo].[EXEC_USERREG_RE_PUBLISH_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 사용자 종료처리광고 게재로 복구
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/12/06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EXEC_USERREG_RE_PUBLISH_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EXEC_USERREG_RE_PUBLISH_PROC]

  @ADID INT

AS

  SET NOCOUNT ON

  -- 게재로 상태 복구
  UPDATE PJ_AD_USERREG_TB
     SET END_YN = 0
        ,STOP_DT = NULL
   WHERE ADID = @ADID;

  -- 게재테이블 이관
  EXECUTE PUT_AD_PUBLISH_TRANS_PROC @ADID, 'U'






GO
/****** Object:  StoredProcedure [dbo].[GET_AD_OPTION_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 공통 > 옵션 정보 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_AD_OPTION_DETAIL_PROC 'M',1,1,7
 *************************************************************************************/


CREATE PROC [dbo].[GET_AD_OPTION_DETAIL_PROC]

  @OPT_KIND  CHAR(1)  -- 옵션종류 (M:메인옵션, E:효과옵션)
  ,@LOCAL_CD TINYINT  -- 옵션게재지역
  ,@OPT_CD VARCHAR(2) -- 옵션코드
  ,@OPT_TERM TINYINT  -- 옵션기간(일)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  SET @SQL = ''

  IF @OPT_KIND = 'M'    -- 메인옵션
    BEGIN
      SET @SQL = 'SELECT OPTION_NAME AS OPT_NAME
                        ,OPT_TERM_TEXT AS OPT_TERM
                        ,OPT_PRICE AS OPT_PRICE
                    FROM dbo.CC_OPTION_PRICE_TB
                   WHERE LOCAL_CD = '+ CAST(@LOCAL_CD AS VARCHAR(2)) +'
                     AND OPT_TERM = '+ CAST(@OPT_TERM AS VARCHAR(3)) +'
                     AND OPTION_CD = '+ @OPT_CD
    END
  ELSE IF @OPT_KIND = 'E'
    BEGIN
      SET @SQL = 'SELECT EFF_OPT_NAME AS OPT_NAME
                        ,EFF_OPT_TERM_TEXT AS OPT_TERM
                        ,EFF_OPT_PRICE AS OPT_PRICE
                    FROM dbo.CC_OPTION_EFFECT_PRICE_TB
                   WHERE LOCAL_CD = '+ CAST(@LOCAL_CD AS VARCHAR(2)) +'
                     AND EFF_OPT_TERM = '+ CAST(@OPT_TERM AS VARCHAR(3)) +'
                     AND EFF_OPT_CD = '''+ @OPT_CD +''''
    END


  EXECUTE SP_EXECUTESQL @SQL







GO
/****** Object:  StoredProcedure [dbo].[GET_CM_EFF_OPTION_INFO_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 공통 > 노출옵션 정보 가져오기
 *  작   성   자 : 최봉기 (cbk07@mediawill.com)
 *  작   성   일 : 2011/06/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXECUTE DBO.GET_CM_EFF_OPTION_INFO_PROC 1
 *************************************************************************************/

CREATE PROC [dbo].[GET_CM_EFF_OPTION_INFO_PROC]

  @LOCAL_CD TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	SELECT EFF_OPT_CD
        ,EFF_OPT_TERM
        ,EFF_OPT_NAME
        ,EFF_OPT_TERM_TEXT
        ,EFF_OPT_PRICE
	  FROM CC_OPTION_EFFECT_PRICE_TB
   WHERE LOCAL_CD = @LOCAL_CD

  SET NOCOUNT OFF








GO
/****** Object:  StoredProcedure [dbo].[GET_CM_GROUNDPLUS_OPTION_STARTDATE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 프론트/관리자 공통 > 그랜드플러스 옵션 등록가능일자 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2012/07/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_CM_GROUNDPLUS_OPTION_STARTDATE_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_CM_GROUNDPLUS_OPTION_STARTDATE_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @START_DT VARCHAR(10)
  DECLARE @GP_OPT_CNT INT
  DECLARE @GP_OPT_START_DT VARCHAR(10)

  -- 현재 게재중인 그랜드플러스 옵션 개수
  SELECT @GP_OPT_CNT = COUNT(*)
    FROM PJ_OPTION_TB AS A
      JOIN PJ_AD_PUBLISH_TB AS B
        ON B.ADID = A.ADID
       AND B.AD_KIND = A.AD_KIND
   WHERE A.OPTION_MAIN_CD = 32
   AND B.START_DT <= GETDATE()
   AND B.END_DT >= GETDATE()

  -- 그랜드플러스옵션이 12개 미만일경우 가장 빨리끝나는 종료일 다음날 출력
  --IF (@GP_OPT_CNT >= 12)
  --  BEGIN
  --    SELECT @START_DT = CONVERT(VARCHAR(10),MIN(B.END_DT + 1),120)
  --      FROM PJ_OPTION_TB AS A
  --        JOIN PJ_AD_PUBLISH_TB AS B
  --          ON B.ADID = A.ADID
  --         AND B.AD_KIND = A.AD_KIND
  --     WHERE A.OPTION_MAIN_CD = 32
  --     AND B.START_DT <= GETDATE()
  --     AND B.END_DT >= GETDATE()
  --  END
  --ELSE
  --  BEGIN
      SET @START_DT = CONVERT(VARCHAR(10),GETDATE() + 1,120)
  --  END

  -- 시작가능일자 출력
  SELECT @START_DT AS START_DT






GO
/****** Object:  StoredProcedure [dbo].[GET_CM_TOPLIST_OPTION_STARTDATE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 프론트/관리자 공통 > 메인옵션별 리스트상위고정 등록가능일자 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2012/07/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_CM_TOPLIST_OPTION_STARTDATE_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_CM_TOPLIST_OPTION_STARTDATE_PROC]

  @OPTION_MAIN_CD TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @START_DT VARCHAR(10)
  DECLARE @MAX_CNT INT
  DECLARE @OPT_CNT INT

  IF @OPTION_MAIN_CD = 1 OR @OPTION_MAIN_CD = 2         -- 프리미엄플러스, 프리미엄박스
    SET @MAX_CNT = 18
  ELSE IF @OPTION_MAIN_CD = 4                           -- 프리미엄리스트
    SET @MAX_CNT = 10
  ELSE IF @OPTION_MAIN_CD = 8 OR @OPTION_MAIN_CD = 16   -- 스피드박스, 스피드리스트
    SET @MAX_CNT = 15

  -- 현재 게재중인 메인옵션별 상위고정옵션 개수
  SELECT @OPT_CNT = COUNT(*)
    FROM PJ_OPTION_TB AS A
      JOIN PJ_AD_PUBLISH_TB AS B
        ON B.ADID = A.ADID
       AND B.AD_KIND = A.AD_KIND
     WHERE A.OPT_SUB_E = 1
       AND A.OPTION_MAIN_CD = @OPTION_MAIN_CD

  -- 상위고정옵션 @MAX_CNT개 미만일경우 가장 빨리끝나는 종료일 다음날 출력
  IF (@OPT_CNT >= @MAX_CNT)
    BEGIN
      SELECT @START_DT = CONVERT(VARCHAR(10),MIN(A.OPT_SUB_E_END_DT + 1),120)
        FROM PJ_OPTION_TB AS A
          JOIN PJ_AD_PUBLISH_TB AS B
            ON B.ADID = A.ADID
           AND B.AD_KIND = A.AD_KIND
       WHERE A.OPT_SUB_E = 1
         AND A.OPTION_MAIN_CD = @OPTION_MAIN_CD
    END
  ELSE
    BEGIN
      SET @START_DT = CONVERT(VARCHAR(10),GETDATE(),120)
    END

  -- 시작가능일자 출력
  SELECT @START_DT AS START_DATE






GO
/****** Object:  StoredProcedure [dbo].[GET_F_AD_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고 상세페이지 내용가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_AD_DETAIL_PROC 27020, 'A'
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_AD_DETAIL_PROC]
	 @ADID INT
	,@AD_KIND CHAR(1)
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT
		 A.CO_NAME
		,A.PHONE
		,A.HPHONE
		,A.BIZ_CD
		,A.AREA_A
		,A.AREA_B
		,A.AREA_C
		,A.AREA_DETAIL
		,A.HOMEPAGE
		,A.TITLE
		,A.CONTENTS
		,A.PAY_CD
		,A.PAY_AMT
		,A.MAP_X
		,A.MAP_Y
		,B.TEMPLATE_CD
		,A.LOGO_IMG
		,A.REG_NAME
	FROM PJ_REG_AD_SEARCH_VI AS A
    LEFT JOIN PJ_OPTION_TB AS B ON B.ADID = A.ADID AND B.AD_KIND = A.AD_KIND
	WHERE A.ADID = @ADID
		AND A.AD_KIND = @AD_KIND
GO
/****** Object:  StoredProcedure [dbo].[GET_F_AD_ECOMM_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > E-COMM 광고 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_AD_ECOMM_DETAIL_PROC 8
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_AD_ECOMM_DETAIL_PROC]

  @ADID INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.CO_NAME
        ,A.PHONE
        ,A.HPHONE
        ,A.BIZ_CD
        ,A.AREA_A
        ,A.AREA_B
        ,A.AREA_C
        ,A.AREA_DETAIL
        ,A.HOMEPAGE
        ,A.TITLE
        ,A.CONTENTS
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.MAP_X
        ,A.MAP_Y
        ,B.TEMPLATE_CD
    FROM PJ_AD_USERREG_TB AS A
      JOIN PJ_OPTION_TB AS B
        ON B.ADID = A.ADID
       AND B.AD_KIND = 'U'
   WHERE A.ADID = @ADID







GO
/****** Object:  StoredProcedure [dbo].[GET_F_AD_SCRAP_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : Front 스크랩 광고 > 스크랩 광고 리스트
 *  작   성   자 : 장재웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2012/09/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : \mypage\scrap_ad
 *  사 용  예 제 : EXECUTE DBO.GET_F_AD_SCRAP_LIST_PROC 1,10,0
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_AD_SCRAP_LIST_PROC]

	  @PAGE            			INT
	, @PAGESIZE       			INT
	, @CUID						INT
	, @TOTALROWS INT OUTPUT

AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@TODAY             VARCHAR(19)

	SET @SQL = ''
	SET @SQL_WHERE = ' 1=1 AND A.ISDELYN = ''N'' AND A.CUID=' + CAST(@CUID AS VARCHAR) + ' '

  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
			  FROM PJ_AD_SCRAP_TB AS A WITH(NOLOCK)
			  INNER JOIN PJ_AD_PUBLISH_TB AS B WITH(NOLOCK)
			  ON (A.ADID = B.ADID AND A.AD_KIND = B.AD_KIND)
			  WHERE '+ @SQL_WHERE +';
	WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.REGDATE DESC) AS ROWNUM
		, A.ADID
		, A.AD_KIND
		, B.CO_NAME
		, B.TITLE
		, B.AREA_A
		, B.AREA_B
		, B.AREA_C
		, B.CONTENTS
		, B.PHONE
		, CONVERT(VARCHAR(16), A.REGDATE, 120) AS REGDATE
	FROM PJ_AD_SCRAP_TB AS A WITH(NOLOCK)
			  INNER JOIN PJ_AD_PUBLISH_TB AS B WITH(NOLOCK)
			  ON (A.ADID = B.ADID AND A.AD_KIND = B.AD_KIND)
	WHERE '+ @SQL_WHERE +')

  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY REGDATE DESC'

  PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount












GO
/****** Object:  StoredProcedure [dbo].[GET_F_AD_TODAY_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고 오늘 본 광고페이지 내용가져오기
 *  작   성   자 : 장 재 웅 rainblue1(@mediawill.com)
 *  작   성   일 : 2011/07/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_AD_TODAY_DETAIL_PROC 27020, 'A'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_AD_TODAY_DETAIL_PROC]

  @ADID INT
  ,@AD_KIND CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.CO_NAME
        ,A.PHONE
        ,A.HPHONE
        ,A.BIZ_CD
        ,A.AREA_A
        ,A.AREA_B
        ,A.AREA_C
        ,A.AREA_DETAIL
        ,A.HOMEPAGE
        ,A.TITLE
        ,A.CONTENTS
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.MAP_X
        ,A.MAP_Y
        ,B.TEMPLATE_CD
        ,A.LOGO_IMG
        ,A.GRAND_IMG
    FROM PJ_AD_PUBLISH_TB AS A
      LEFT JOIN PJ_OPTION_TB AS B
        ON B.ADID = A.ADID
       AND B.AD_KIND = A.AD_KIND
   WHERE A.ADID = @ADID
     AND A.AD_KIND = @AD_KIND









GO
/****** Object:  StoredProcedure [dbo].[GET_F_AD_USER_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고 오늘 본 광고페이지 내용가져오기
 *  작   성   자 : 장 재 웅 rainblue1(@mediawill.com)
 *  작   성   일 : 2011/07/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_AD_TODAY_DETAIL_PROC 27020, 'A'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_AD_USER_DETAIL_PROC]

  @ADID INT
  ,@AD_KIND CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.CO_NAME
        ,A.PHONE
        ,A.HPHONE
        ,A.BIZ_CD
        ,A.AREA_A
        ,A.AREA_B
        ,A.AREA_C
        ,A.AREA_DETAIL
        ,A.HOMEPAGE
        ,A.TITLE
        ,A.CONTENTS
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.MAP_X
        ,A.MAP_Y
        ,B.TEMPLATE_CD
        ,A.LOGO_IMG
        ,A.GRAND_IMG
    FROM PJ_AD_USERREG_TB AS A
      LEFT JOIN PJ_OPTION_TB AS B
        ON B.ADID = A.ADID
       AND B.AD_KIND = @AD_KIND
   WHERE A.ADID = @ADID









GO
/****** Object:  StoredProcedure [dbo].[GET_F_AREA_CATEGORY_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 프론트 > 분류 > 지역카테고리 - 지역별 광고개수
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/01/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_AREA_CATEGORY_LIST_PROC 40100, '서울특별시'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_AREA_CATEGORY_LIST_PROC]

  @BIZ_CD VARCHAR(5) = ''
  ,@LOCAL_CD TINYINT
  ,@AREA_A VARCHAR(50) = ''

AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_WHERE VARCHAR(500)
  SET @SQL = ''
  SET @SQL_WHERE = ''

/* 일반광고는 모든 지역판이 노출됨으로 지역판 조건 제외 (2011.10.19 김현정 과장 요청)
  IF @LOCAL_CD <> 1
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND B.LOCAL_CD & '+ CAST(@LOCAL_CD AS CHAR(1)) +' = '+ CAST(@LOCAL_CD AS CHAR(1))
    END
*/

  IF @BIZ_CD <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND A.BIZ_CD = '+ @BIZ_CD
    END

  IF @AREA_A = ''        -- 전지역
    BEGIN
      SET @SQL = 'SELECT COUNT(*) AS CNT
        FROM PJ_AD_PUBLISH_TB AS A
          JOIN PJ_OPTION_TB AS B
            ON B.ADID = A.ADID
           AND B.AD_KIND = A.AD_KIND
       WHERE A.AREA_A <> ''''
         '+ @SQL_WHERE +';
      SELECT AREA_A AS AREA_NM
            ,COUNT(*) AS CNT
            ,CASE AREA_A WHEN ''서울'' THEN 1
                         WHEN ''경기'' THEN 2
                         WHEN ''인천'' THEN 3
                         WHEN ''부산'' THEN 4
                         WHEN ''대구'' THEN 5
                         WHEN ''광주'' THEN 6
                         WHEN ''대전'' THEN 7
                         WHEN ''울산'' THEN 8
                         WHEN ''강원'' THEN 9
                         WHEN ''경북'' THEN 10
                         WHEN ''경남'' THEN 11
                         WHEN ''전북'' THEN 12
                         WHEN ''전남'' THEN 13
                         WHEN ''충북'' THEN 14
                         WHEN ''충남'' THEN 15
                         WHEN ''제주 '' THEN 16
                         WHEN ''기타'' THEN 17
												 WHEN ''세종'' THEN 18
												 WHEN ''전국'' THEN 19
                         ELSE 20
                END AS ORDER_NUM
        FROM PJ_AD_PUBLISH_TB AS A
          JOIN PJ_OPTION_TB AS B
            ON B.ADID = A.ADID
           AND B.AD_KIND = A.AD_KIND
       WHERE A.AREA_A <> ''''
         '+ @SQL_WHERE +'
       GROUP BY AREA_A
       ORDER BY ORDER_NUM ASC'

    END
  ELSE
    BEGIN
      SET @SQL = 'SELECT COUNT(*) AS CNT
        FROM PJ_AD_PUBLISH_TB AS A
          JOIN PJ_OPTION_TB AS B
            ON B.ADID = A.ADID
           AND B.AD_KIND = A.AD_KIND
       WHERE A.AREA_A = '''+ @AREA_A +'''
         --AND A.AREA_B <> ''''
         '+ @SQL_WHERE +';
      SELECT AREA_B AS AREA_NM
            ,COUNT(*) AS CNT
        FROM PJ_AD_PUBLISH_TB AS A
          JOIN PJ_OPTION_TB AS B
            ON B.ADID = A.ADID
           AND B.AD_KIND = A.AD_KIND
       WHERE A.AREA_A = '''+ @AREA_A +'''
         AND A.AREA_B <> ''전지역''
         '+ @SQL_WHERE +'
        GROUP BY A.AREA_B
        ORDER BY AREA_B ASC'

    END

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL


END




GO
/****** Object:  StoredProcedure [dbo].[GET_F_EFFECT_OPTION_SELECT_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > 효과옵션 SELECT 가격
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_EFFECT_OPTION_SELECT_LIST_PROC 1, 'A'
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_EFFECT_OPTION_SELECT_LIST_PROC]

  @LOCAL_CD TINYINT
  ,@EFF_OPT_CD CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT EFF_OPT_TERM
        ,EFF_OPT_TERM_TEXT
        ,EFF_OPT_PRICE
    FROM dbo.CC_OPTION_EFFECT_PRICE_TB
   WHERE LOCAL_CD = @LOCAL_CD
     AND EFF_OPT_CD = @EFF_OPT_CD
   ORDER BY EFF_OPT_TERM ASC






GO
/****** Object:  StoredProcedure [dbo].[GET_F_INIPAYMAIN_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
이니시스 결제 중복 체크 (2015.12.07)
작성 : 신장순 (jssin@mediawill.com)
exec GET_F_INIPAYMAIN_PROC
*/
CREATE PROC [dbo].[GET_F_INIPAYMAIN_PROC]
	@ResultMsg			VARCHAR(100)	= ''
, @PayMethod			VARCHAR(20)		= ''
, @CardQuota			CHAR(2)				= ''
, @CardCode				CHAR(2)				= ''
, @CardIssuerCode	CHAR(2)				= ''
, @AuthCertain		CHAR(2)				= ''
, @PGAuthDate			CHAR(8)				= ''
, @VoID						VARCHAR(40)		= ''
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT COUNT(*) AS CNT
	FROM InipayMain
	WHERE ResultCode = '00'
		AND ResultMsg = @ResultMsg
		AND PayMethod = @PayMethod
		AND CardQuota = @CardQuota
		AND CardCode = @CardCode
		AND CardIssuerCode = @CardIssuerCode
		AND AuthCertain = @AuthCertain
		AND PGAuthDate = @PGAuthDate
		AND VoID = @VoID

END



GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAIN_OPTION_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 프론트 > 메인옵션 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_MAIN_OPTION_LIST_PROC 1, 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_MAIN_OPTION_LIST_PROC]

  @OPTION_MAIN_CD TINYINT
  ,@LOCAL_CD TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_WHERE VARCHAR(100)
  SET @SQL = ''
  SET @SQL_WHERE = ''
/*
  IF @OPTION_MAIN_CD & 1 = 1
    BEGIN
      SET @SQL_WHERE = ' AND (A.LOGO_IMG IS NOT NULL OR A.LOGO_IMG <> '''') '
    END
*/
  SET @SQL = 'SELECT ADID
        ,AD_KIND
        ,CO_NAME
        ,AREA_A
        ,AREA_B
        ,BIZ_CD
        ,TITLE
        ,LOGO_IMG
        ,START_DT
        ,OPT_SUB_A
        ,OPT_SUB_A_START_DT
        ,OPT_SUB_A_END_DT
        ,OPT_SUB_B
        ,OPT_SUB_B_START_DT
        ,OPT_SUB_B_END_DT
        ,OPT_SUB_C
        ,OPT_SUB_C_START_DT
        ,OPT_SUB_C_END_DT
        ,OPT_SUB_D
        ,OPT_SUB_D_START_DT
        ,OPT_SUB_D_END_DT
        ,CONTENTS
        ,OPT_SUB_E
        ,OPT_SUB_E_START_DT
        ,OPT_SUB_E_END_DT
        ,GRAND_IMG
        ,PAY_CD
        ,PAY_AMT
        ,SORT_ID
    FROM (SELECT A.ADID
        ,A.AD_KIND
        ,A.CO_NAME
        ,A.AREA_A
        ,A.AREA_B
        ,A.BIZ_CD
        ,A.TITLE
        ,A.LOGO_IMG
        ,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
        ,B.OPT_SUB_A
        ,CONVERT(VARCHAR(10),B.OPT_SUB_A_START_DT,120) AS OPT_SUB_A_START_DT
        ,CONVERT(VARCHAR(10),B.OPT_SUB_A_END_DT,120) AS OPT_SUB_A_END_DT
        ,B.OPT_SUB_B
        ,CONVERT(VARCHAR(10),B.OPT_SUB_B_START_DT,120) AS OPT_SUB_B_START_DT
        ,CONVERT(VARCHAR(10),B.OPT_SUB_B_END_DT,120) AS OPT_SUB_B_END_DT
        ,B.OPT_SUB_C
        ,CONVERT(VARCHAR(10),B.OPT_SUB_C_START_DT,120) AS OPT_SUB_C_START_DT
        ,CONVERT(VARCHAR(10),B.OPT_SUB_C_END_DT,120) AS OPT_SUB_C_END_DT
        ,B.OPT_SUB_D
        ,CONVERT(VARCHAR(10),B.OPT_SUB_D_START_DT,120) AS OPT_SUB_D_START_DT
        ,CONVERT(VARCHAR(10),B.OPT_SUB_D_END_DT,120) AS OPT_SUB_D_END_DT
        ,A.CONTENTS
        ,B.OPT_SUB_E
        ,CONVERT(VARCHAR(10),B.OPT_SUB_E_START_DT,120) AS OPT_SUB_E_START_DT
        ,CONVERT(VARCHAR(10),B.OPT_SUB_E_END_DT,120) AS OPT_SUB_E_END_DT
        ,A.GRAND_IMG
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.SORT_ID
    FROM PJ_AD_PUBLISH_TB AS A
      LEFT JOIN PJ_OPTION_TB AS B
        ON B.ADID = A.ADID
       AND B.AD_KIND = A.AD_KIND
   WHERE B.OPTION_MAIN_CD & '+ CAST(@OPTION_MAIN_CD AS CHAR(2)) +' = '+ CAST(@OPTION_MAIN_CD AS CHAR(2)) +'
     AND B.LOCAL_CD & '+ CAST(@LOCAL_CD AS CHAR(1)) +' = '+ CAST(@LOCAL_CD AS CHAR(1)) +'
     AND A.START_DT <= GETDATE()

     '+ @SQL_WHERE +') AS T
     ORDER BY SORT_ID DESC, OPT_SUB_E_START_DT DESC, START_DT DESC, ADID DESC'

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL













GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAINBANNER_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 프론트 > 메인 > 메인베너 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_MAINBANNER_LIST_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_MAINBANNER_LIST_PROC]

  @LOCAL_CD           TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @TODAY DATETIME
  SET @TODAY = CONVERT(VARCHAR(10),GETDATE(), 120) + ' 00:00:00.000'

  SELECT IDX
        ,LOCAL_CD
        ,BANNER_IMG
        ,BANNER_CNT_FLAG
        ,BANNER_DETAIL_IMG
        ,BANNER_DESC
        ,BANNER_URL
        ,BANNER_TYPE
        ,CONVERT(VARCHAR(10),START_DT,120) AS START_DT
        ,CONVERT(VARCHAR(10),END_DT,120) AS END_DT
        ,CONVERT(VARCHAR(10),REG_DT,120) AS REG_DT
    FROM dbo.PJ_MAIN_BANNER_TB
   WHERE LOCAL_CD = @LOCAL_CD
     AND START_DT <= @TODAY
     AND END_DT >= @TODAY
   ORDER BY NEWID()








GO
/****** Object:  StoredProcedure [dbo].[GET_F_NORMAL_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 프론트 > 분류 > 일반구인정보 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/15
 *  수   정   자 : 장 재 웅 (rainblue1@mediawill.com)
 *  수   정   일 : 2012/10/08
 *  설        명 : 페이징 컨트롤 사용을 위해 rownum을 사용 하는 방식으로 수정
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_NORMAL_AD_LIST_PROC 1, 15, 1, '40100', '', '', 0
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_NORMAL_AD_LIST_PROC]

  @PAGE INT
  ,@PAGESIZE INT
  ,@LOCAL_CD TINYINT
  ,@BIZ_CD VARCHAR(5) = ''
  ,@AREA_A VARCHAR(50) = ''
  ,@AREA_B VARCHAR(50) = ''
  ,@TOTALROWS INT OUTPUT

AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT

    SET @SQL = ''
	SET @SQL_WHERE = ' 1=1 '

/* 일반광고는 모든 지역판이 노출됨으로 지역판 조건 제외 (2011.10.19 김현정 과장 요청)
  IF @LOCAL_CD <> 1
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND B.LOCAL_CD & '+ CAST(@LOCAL_CD AS CHAR(1)) +' = '+ CAST(@LOCAL_CD AS CHAR(1))
    END
*/

  IF @BIZ_CD <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND A.BIZ_CD = '+ @BIZ_CD
    END

  IF @AREA_A <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND A.AREA_A = '''+ @AREA_A +''' '
    END

  IF @AREA_B <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND A.AREA_B = '''+ @AREA_B +''' '
    END

  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
	FROM PJ_AD_PUBLISH_TB AS A
	JOIN PJ_OPTION_TB AS B
	ON B.ADID = A.ADID
	AND B.AD_KIND = A.AD_KIND
	WHERE '+ @SQL_WHERE +';

	WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.START_DT DESC, A.ADID ASC) AS ROWNUM
		,A.ADID
		,A.AD_KIND
		,A.BIZ_CD
		,A.CO_NAME
		,A.PHONE
		,A.HPHONE
		,A.AREA_A
		,A.AREA_B
		,A.AREA_C
		,A.AREA_DETAIL
		,A.TITLE
		,A.CONTENTS
		,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
		,B.OPT_SUB_A
		,CONVERT(VARCHAR(10),B.OPT_SUB_A_START_DT,120) AS OPT_SUB_A_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_A_END_DT,120) AS OPT_SUB_A_END_DT
		,B.OPT_SUB_B
		,CONVERT(VARCHAR(10),B.OPT_SUB_B_START_DT,120) AS OPT_SUB_B_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_B_END_DT,120) AS OPT_SUB_B_END_DT
		,B.OPT_SUB_C
		,CONVERT(VARCHAR(10),B.OPT_SUB_C_START_DT,120) AS OPT_SUB_C_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_C_END_DT,120) AS OPT_SUB_C_END_DT
		,B.OPT_SUB_D
		,CONVERT(VARCHAR(10),B.OPT_SUB_D_START_DT,120) AS OPT_SUB_D_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_D_END_DT,120) AS OPT_SUB_D_END_DT
		,B.OPT_SUB_E
		,CONVERT(VARCHAR(10),B.OPT_SUB_E_START_DT,120) AS OPT_SUB_E_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_E_END_DT,120) AS OPT_SUB_E_END_DT
		,A.PAY_CD
		,A.PAY_AMT
	FROM PJ_AD_PUBLISH_TB AS A
	  JOIN PJ_OPTION_TB AS B
		ON B.ADID = A.ADID
	   AND B.AD_KIND = A.AD_KIND
	WHERE '+ @SQL_WHERE +')

	SELECT * FROM RESULT_TABLE
	WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
	AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
	ORDER BY ROWNUM ASC'
	--ORDER BY START_DT DESC, ADID ASC'

  PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount






GO
/****** Object:  StoredProcedure [dbo].[GET_F_OPTION_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*************************************************************************************
 *  단위 업무 명 : 프론트 > 분류 > 옵션 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/13
 *  수   정   자 : 장재웅   (rainblue1@mediawill.com)
 *  수   정   일 : 2012/10/07 (야알바 리뉴얼로 상품 노출 기준 변경)
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_OPTION_AD_LIST_PROC 8, 1, '', '서울특별시', '구로구'
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_OPTION_AD_LIST_PROC]

  @OPTION_MAIN_CD TINYINT
  ,@LOCAL_CD TINYINT
  ,@BIZ_CD VARCHAR(5) = ''
  ,@AREA_A VARCHAR(50) = ''
  ,@AREA_B VARCHAR(50) = ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_WHERE VARCHAR(200)
  SET @SQL = ''
  SET @SQL_WHERE = ''

/*
  IF @OPTION_MAIN_CD & 1 = 1
    BEGIN
      SET @SQL_WHERE = ' AND (A.LOGO_IMG IS NOT NULL OR A.LOGO_IMG <> '''') '
    END
*/

  -- 프리미엄인 경우 그랜드, 프리미엄플러스 노출
  IF @OPTION_MAIN_CD = 1
	BEGIN
      SET @SQL_WHERE = ' AND B.OPTION_MAIN_CD IN (1,32) '
	END
  ELSE IF @OPTION_MAIN_CD = 8 -- 스피드 박스인 경우 그랜드, 프리미엄플러스, 프리미엄 박스(2012.11.19 신혜원과장요청) 광고도 노출
	BEGIN
      SET @SQL_WHERE = ' AND B.OPTION_MAIN_CD IN (8,1,2,32) '
	END
  ELSE IF  @OPTION_MAIN_CD = 16  -- 스피드리스트인 경우 프리미엄리스트 광고도 노출
	BEGIN
      SET @SQL_WHERE = ' AND B.OPTION_MAIN_CD IN (16,4) '
	END
  ELSE
	BEGIN
      SET @SQL_WHERE = ' AND B.OPTION_MAIN_CD IN (32,1,2,4,8,16) '
    END


  IF @BIZ_CD <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND A.BIZ_CD = '+ @BIZ_CD
    END

  IF @AREA_A <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND AREA_A = '''+ @AREA_A +''' '
    END

  IF @AREA_B <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND AREA_B = '''+ @AREA_B +''' '
    END

  SET @SQL = 'SELECT A.ADID
        ,A.AD_KIND
        ,A.CO_NAME
        ,A.AREA_A
        ,A.AREA_B
        ,A.BIZ_CD
        ,A.TITLE
        ,A.LOGO_IMG
        ,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
        ,B.OPT_SUB_A
        ,CONVERT(VARCHAR(10),B.OPT_SUB_A_START_DT,120) AS OPT_SUB_A_START_DT
        ,CONVERT(VARCHAR(10),B.OPT_SUB_A_END_DT,120) AS OPT_SUB_A_END_DT
        ,B.OPT_SUB_B
        ,CONVERT(VARCHAR(10),B.OPT_SUB_B_START_DT,120) AS OPT_SUB_B_START_DT
        ,CONVERT(VARCHAR(10),B.OPT_SUB_B_END_DT,120) AS OPT_SUB_B_END_DT
        ,B.OPT_SUB_C
        ,CONVERT(VARCHAR(10),B.OPT_SUB_C_START_DT,120) AS OPT_SUB_C_START_DT
        ,CONVERT(VARCHAR(10),B.OPT_SUB_C_END_DT,120) AS OPT_SUB_C_END_DT
        ,B.OPT_SUB_D
        ,CONVERT(VARCHAR(10),B.OPT_SUB_D_START_DT,120) AS OPT_SUB_D_START_DT
        ,CONVERT(VARCHAR(10),B.OPT_SUB_D_END_DT,120) AS OPT_SUB_D_END_DT
        ,A.CONTENTS
        ,B.OPT_SUB_E
        ,CONVERT(VARCHAR(10),B.OPT_SUB_E_START_DT,120) AS OPT_SUB_E_START_DT
        ,CONVERT(VARCHAR(10),B.OPT_SUB_E_END_DT,120) AS OPT_SUB_E_END_DT
        ,A.GRAND_IMG
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.SORT_ID
    FROM PJ_AD_PUBLISH_TB AS A
      LEFT JOIN PJ_OPTION_TB AS B
        ON B.ADID = A.ADID
       AND B.AD_KIND = A.AD_KIND
   WHERE B.LOCAL_CD & '+ CAST(@LOCAL_CD AS CHAR(1)) +' = '+ CAST(@LOCAL_CD AS CHAR(1)) +'
     '+ @SQL_WHERE +'
   ORDER BY A.SORT_ID DESC, OPT_SUB_E_START_DT DESC, A.START_DT DESC, A.ADID DESC'

  PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL
















GO
/****** Object:  StoredProcedure [dbo].[GET_F_OPTION_SELECT_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > 옵션 SELECT 가격
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_OPTION_SELECT_LIST_PROC 1, 1
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_OPTION_SELECT_LIST_PROC]

  @LOCAL_CD TINYINT
  ,@OPTION_MAIN_CD TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT OPT_TERM
        ,OPT_TERM_TEXT
        ,OPT_PRICE
    FROM dbo.CC_OPTION_PRICE_TB
   WHERE LOCAL_CD = @LOCAL_CD
     AND OPTION_CD = @OPTION_MAIN_CD
   ORDER BY OPT_TERM ASC






GO
/****** Object:  StoredProcedure [dbo].[GET_F_PAPER_AD_SCRAPCNT_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : FRONT > 광고 스크랩 개수 반환
 *  작   성   자 : 장 재 웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2012/09/12
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_PAPER_AD_SCRAPCNT_LIST_PROC 'rainblue70'
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_PAPER_AD_SCRAPCNT_LIST_PROC]
  @CUID INT

AS

	SET NOCOUNT ON

	SELECT COUNT(A.SEQ) AS SCRAPCNT FROM PJ_AD_SCRAP_TB AS A with(nolock)
	INNER JOIN PJ_AD_PUBLISH_TB AS B WITH(NOLOCK)
	ON (A.ADID = B.ADID AND A.AD_KIND = B.AD_KIND)
	WHERE A.CUID = @CUID







GO
/****** Object:  StoredProcedure [dbo].[GET_F_RECCHARGE_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > 온라인 입금 결제 정보
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_RECCHARGE_DETAIL_PROC 6
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_RECCHARGE_DETAIL_PROC]

  @SERIAL        INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT ADID
        ,PRNAMT
        ,BANKNM
        ,ACCOUNTNUM
    FROM PJ_RECCHARGE_TB
   WHERE SERIAL = @SERIAL








GO
/****** Object:  StoredProcedure [dbo].[GET_F_USERREG_MANAGE_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > E-COMM 광고 관리 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_USERREG_MANAGE_LIST_PROC 1, 10, 'cbk08','I',1
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_USERREG_MANAGE_LIST_PROC]

  @PAGE        INT
  ,@PAGESIZE   INT
  ,@CUID       INT
  ,@MAG_KIND   CHAR(1)    -- 리스트종류 (I:진행중, E: 마감)
  ,@TOTALROWS  INT OUTPUT
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@TODAY             VARCHAR(19)

  DECLARE @SQL_COUNT NVARCHAR(2000)
  DECLARE @LIMIT_DT VARCHAR(23)  -- 노출제한일자

  SET @TODAY = CONVERT(VARCHAR(10),GETDATE(),120) + ' 00:00:00.000'
  SET @LIMIT_DT = CONVERT(VARCHAR(10),DATEADD(m,-6,GETDATE()),120) + ' 00:00:00.000'

  SET @SQL = ''
  SET @SQL_COUNT = ''

  -- 기본 조건
  SET @SQL_WHERE = ' A.CUID = ' + CAST(@CUID AS VARCHAR) + ' AND A.REG_DT > '''+ @LIMIT_DT +''' '

  -- 리스트 분류에 따른 조건
  IF @MAG_KIND = 'I'        -- 진행
    BEGIN
      --SET @SQL_WHERE = @SQL_WHERE +' AND A.PAUSE_YN = 0 AND A.END_YN = 0 AND A.END_DT >= '''+ @TODAY +''''
      SET @SQL_WHERE = @SQL_WHERE +' AND A.END_YN = 0 AND A.END_DT >= '''+ @TODAY +''''    END
  ELSE IF  @MAG_KIND = 'E'  -- 마감
    BEGIN
      --SET @SQL_WHERE = @SQL_WHERE +' AND (A.PAUSE_YN = 1 OR A.END_YN = 1 OR A.END_DT < '''+ @TODAY +''')'
      SET @SQL_WHERE = @SQL_WHERE +' AND (A.END_YN = 1 OR A.END_DT < '''+ @TODAY +''')'
    END

  --// 카운터
    SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
    FROM PJ_AD_USERREG_TB AS A
    JOIN PJ_RECCHARGE_TB AS B
      ON B.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = ''U''
   WHERE '+ @SQL_WHERE +';

  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.REG_DT DESC) AS ROWNUM
  ,A.ADID
  ,A.TITLE
  ,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
  ,CONVERT(VARCHAR(10),A.END_DT,120) AS END_DT
  ,A.BIZ_CD
  ,C.OPTION_MAIN_CD
  ,C.OPT_SUB_A
  ,CONVERT(VARCHAR(10),C.OPT_SUB_A_START_DT,120) AS OPT_SUB_A_START_DT
  ,CONVERT(VARCHAR(10),C.OPT_SUB_A_END_DT,120) AS OPT_SUB_A_END_DT
  ,C.OPT_SUB_B
  ,CONVERT(VARCHAR(10),C.OPT_SUB_B_START_DT,120) AS OPT_SUB_B_START_DT
  ,CONVERT(VARCHAR(10),C.OPT_SUB_B_END_DT,120) AS OPT_SUB_B_END_DT
  ,C.OPT_SUB_C
  ,CONVERT(VARCHAR(10),C.OPT_SUB_C_START_DT,120) AS OPT_SUB_C_START_DT
  ,CONVERT(VARCHAR(10),C.OPT_SUB_C_END_DT,120) AS OPT_SUB_C_END_DT
  ,C.OPT_SUB_D
  ,CONVERT(VARCHAR(10),C.OPT_SUB_D_START_DT,120) AS OPT_SUB_D_START_DT
  ,CONVERT(VARCHAR(10),C.OPT_SUB_D_END_DT,120) AS OPT_SUB_D_END_DT
  ,C.OPT_SUB_E
  ,CONVERT(VARCHAR(10),C.OPT_SUB_E_START_DT,120) AS OPT_SUB_E_START_DT
  ,CONVERT(VARCHAR(10),C.OPT_SUB_E_END_DT,120) AS OPT_SUB_E_END_DT
  ,CONVERT(VARCHAR(10),A.REG_DT,120) AS REG_DT
  ,CONVERT(VARCHAR(10),A.MOD_DT,120) AS MOD_DT
  ,B.CHARGE_KIND
  ,B.PRNAMTOK
  ,A.CONFIRM_YN
  ,A.PAUSE_YN
  ,A.END_YN
  ,B.SERIAL
  ,C.AD_KIND
  ,CONVERT(VARCHAR(10),A.STOP_DT,120) AS STOP_DT
  ,D.CONFIRM_YN AS MOD_CONFIRM_YN
  ,ISNULL(E.HIT,0) AS HIT
	,F.ADID AS PUB_ADID
    FROM PJ_AD_USERREG_TB AS A
    JOIN PJ_RECCHARGE_TB AS B
      ON B.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
    LEFT JOIN PJ_AD_USERREG_MODIFY_TB AS D
      ON D.ADID = A.ADID
    LEFT JOIN PJ_AD_COUNT_TB AS E
      ON E.ADID = A.ADID
     AND E.AD_KIND = ''U''
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = ''U''
   WHERE '+ @SQL_WHERE +')
  SELECT * FROM RESULT_TABLE A
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY A.REG_DT DESC'


  PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount















GO
/****** Object:  StoredProcedure [dbo].[GET_F_USERREG_TAX_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > 세금계산서 내역 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_USERREG_TAX_LIST_PROC 'cbk08'
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_USERREG_TAX_LIST_PROC]

  @CUID INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.ADID
        ,B.AD_GBN
        ,'유흥구인광고' AS GOODS_NM
        ,CONVERT(VARCHAR(10),B.RECDATE,120) AS RECDATE
        ,B.CHARGE_KIND
        ,B.PRNAMT
        ,ISNULL(C.IDX,0) AS REQUEST_STATUS
        ,ISNULL(C.TAXFLAG,0) AS ISSUE_STATUS
        ,ISNULL(D.PRICE,0) AS EDTPRICE
        ,ISNULL(D.PKEY,0) AS ISSUEKEY
        ,E.RESULT
        ,DBO.FN_CHKMONTH(CONVERT(VARCHAR(10),B.RECDATE,112),CONVERT(VARCHAR(10),GETDATE(),112)) AS MONTHCLOSE
        ,B.SERIAL
        ,B.INIPAYTID
    FROM PJ_AD_USERREG_TB AS A
      JOIN PJ_RECCHARGE_TB AS B
        ON B.ADID = A.ADID
       AND B.AD_GBN = 1
      LEFT JOIN FINDCOMMON.DBO.TAXREQUEST AS C
        ON C.ADID = A.ADID
       AND C.ADGBN = B.AD_GBN
       AND C.GRPSERIAL = B.SERIAL
      LEFT JOIN FINDCOMMON.DBO.TAXISSUE_LOG AS D
        ON D.TAXREQUESTKEY = C.IDX
      LEFT JOIN DBO.PJ_RECEIPT_REQUEST_TB AS E
        ON E.GRPSERIAL = B.SERIAL
       AND E.ADGBN = B.AD_GBN
   WHERE A.CUID = @CUID
--     AND B.CHARGE_KIND = 1  -- 온라인 입금인 경우
     AND B.PRNAMTOK = 1     -- 결제 완료된 광고만
   ORDER BY A.ADID DESC






GO
/****** Object:  StoredProcedure [dbo].[GET_M_AD_CONFIRM_WAIT_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 관리자 > 검수관리 > 검수대기 리스트
 *  작   성   자 : 신 장 순 (jssin@mediawill.com)
 *  작   성   일 : 2015/01/29
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 EXECUTE DBO.GET_M_AD_CONFIRM_WAIT_LIST_PROC 1,20,'','','','','','','','A','',0
 EXECUTE DBO.GET_M_AD_CONFIRM_WAIT_LIST_PROC '1', '20', '', '', '', '', '', '', '', '', '', '0', 0
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_AD_CONFIRM_WAIT_LIST_PROC]
	 @PAGE INT										= 1
	,@PAGESIZE INT							= 20
	,@LOCAL_CD CHAR(1)          = ''    -- 우대옵션 게재지역
	,@OPTION_MAIN_CD VARCHAR(2) = ''    -- 우대옵션
	,@S_DATE_KIND VARCHAR(8)    = ''    -- 날짜검색 대상 (REG_DT:등록일, START_DT: 시작일, END_DT: 종료일)
	
	,@S_START_DT VARCHAR(10)    = ''    -- 검색시작일
	,@S_END_DT VARCHAR(10)      = ''    -- 검색종료일
	,@S_KWD_KIND VARCHAR(10)    = ''    -- 키워드 검색대상 (필드명)
	,@S_KWD_VALUE VARCHAR(50)   = ''    -- 키워드
	,@S_AD_KIND CHAR(1)					= ''    -- U:E-COMM / A:등록대행
	
	,@MAG_BRANCHCODE CHAR(3)		= ''		-- 등록지점
	,@S_CONFIRM_YN CHAR(1)			= ''   -- 검수상태(0:대기, 1:완료, 2:거절)
	
	,@TOTALROWS INT OUTPUT
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
					,@ECOMM_SQL					NVARCHAR(4000)
					,@AGENCY_SQL				NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(4000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@SQL_COUNT         NVARCHAR(4000)
          ,@TODAY             VARCHAR(19)

	SET @SQL = ''
	SET @ECOMM_SQL = ''
	SET @AGENCY_SQL = ''
  SET @SQL_COUNT = ''
  SET @SQL_WHERE = ''

	-- 조건: 게재지역
  IF @LOCAL_CD <> ''
		BEGIN
			SET @SQL_WHERE = @SQL_WHERE + ' AND C.LOCAL_CD & '+ @LOCAL_CD +' = '+ @LOCAL_CD
		END

  -- 검색: 우대옵션
  IF @OPTION_MAIN_CD <> ''
		BEGIN
			SET @SQL_WHERE = @SQL_WHERE + ' AND C.OPTION_MAIN_CD & '+ @OPTION_MAIN_CD +' = '+ @OPTION_MAIN_CD
		END

  -- 검색: 날짜검색
  IF @S_DATE_KIND <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @S_DATE_KIND +' BETWEEN '''+ @S_START_DT +''' AND '''+ @S_END_DT +''' '
    END

  -- 검색: 키워드 검색
  IF @S_KWD_KIND <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @S_KWD_KIND +' LIKE ''%'+ @S_KWD_VALUE +'%'''
    END

	-- 등록지점
  IF @MAG_BRANCHCODE <> ''
    BEGIN
			SET @S_AD_KIND = 'A'	--// 등록지점은 등록대행만 검색 된다. (프로시져 내에서 파라메터값 변경)
      SET @SQL_WHERE = @SQL_WHERE + ' AND MAG_BRANCHCODE = '+ @MAG_BRANCHCODE
    END

	-- 검수상태
	IF @S_CONFIRM_YN = ''
		BEGIN
			SET @SQL_WHERE = @SQL_WHERE + ' AND A.CONFIRM_YN <> ''0'' '
		END
	ELSE
		BEGIN
			SET @SQL_WHERE = @SQL_WHERE + ' AND A.CONFIRM_YN = ''' + @S_CONFIRM_YN + ''' '
		END

	--// E-Comm
	SET @ECOMM_SQL = '
	SELECT A.ADID
				,CONVERT(VARCHAR(10),A.REG_DT,11) AS REG_DT
				,A.USERID
				,A.CO_NAME
				,D.USER_NM AS USERNAME
				,C.LOCAL_CD
				,C.OPTION_MAIN_CD
				,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
				,CONVERT(VARCHAR(10),A.END_DT,120) AS END_DT
				,0 AS MAG_BRANCHCODE
				,C.AD_KIND
				,A.CONFIRM_YN
				,'''' AS PARTNM
				,'''' AS MAGNAME
				,ISNULL(CAST(A.MOD_REQ_DT AS VARCHAR), '''') AS MOD_REQ_DT
				/*,CASE WHEN A.REG_DT < A.MOD_DT THEN A.MOD_DT ELSE A.REG_DT END AS ORDER_DT*/
				,ISNULL(A.MOD_DT, A.REG_DT) AS ORDER_DT
				,A.MOD_DT
				,A.REG_DT AS REG_DT2
        ,0 AS AMOUNT_ONLINE
        ,0 AS AMOUNT_MWPLUS
        , A.CUID
				,'''' AS M_STATUS
	INTO #ECOMM_WAIT_LIST
	FROM PJ_AD_USERREG_TB AS A
	JOIN PJ_RECCHARGE_TB AS B ON B.ADID = A.ADID AND AD_GBN = 1
	JOIN PJ_OPTION_TB AS C ON C.ADID = A.ADID AND C.AD_KIND = ''U''
	JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS D ON D.CUID = A.CUID
	WHERE B.PRNAMTOK = 1
	' + @SQL_WHERE + ';'


	--// 등록대행
	SET @AGENCY_SQL = '
	SELECT A.ADID
				,CONVERT(VARCHAR(10),A.REG_DT,11) AS REG_DT
				,'''' AS USERID
				,A.CO_NAME
				,'''' AS USERNAME
				,C.LOCAL_CD
				,C.OPTION_MAIN_CD
				,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
				,CONVERT(VARCHAR(10),A.END_DT,120) AS END_DT
				,MAG_BRANCHCODE
				,C.AD_KIND
				,A.CONFIRM_YN
				,D.PARTNM
				,D.MAGNAME
				,ISNULL(CAST(A.MOD_REQ_DT AS VARCHAR), '''') AS MOD_REQ_DT
				/*,CASE WHEN A.REG_DT < A.MOD_DT THEN A.MOD_DT ELSE A.REG_DT END AS ORDER_DT*/
				,ISNULL(A.MOD_DT, A.REG_DT) AS ORDER_DT
				,A.MOD_DT
				,A.REG_DT AS REG_DT2
        ,A.AMOUNT_ONLINE
        ,A.AMOUNT_MWPLUS
        ,'''' AS CUID
				,A.M_STATUS
	INTO #AGENCY_WAIT_LIST
	FROM PJ_AGENCY_AD_LIST_VI AS A
	JOIN PJ_OPTION_TB AS C ON C.ADID = A.ADID AND C.AD_KIND = ''A''
	LEFT OUTER JOIN FINDCOMMON.dbo.CommonMagUser AS D ON D.MAGID = A.MAGID
	WHERE 1=1
	' + @SQL_WHERE + ';'
	--' + @SQL_WHERE + ' AND (A.M_STATUS NOT IN (''A'', ''W'') OR M_STATUS IS NULL); '
	
	--// 전체/이컴/등록대행 구분에 따라 RESULT 임시 테이블을 만든다.
	IF @S_AD_KIND = '' OR @S_AD_KIND IS NULL
		BEGIN
			SET @SQL = @ECOMM_SQL + @AGENCY_SQL + '
			SELECT ROW_NUMBER() OVER (ORDER BY T.ORDER_DT DESC) AS ROWNUM, T.*
				INTO #RESULT
			FROM (
				SELECT *
				FROM #ECOMM_WAIT_LIST
				UNION ALL
				SELECT *
				FROM #AGENCY_WAIT_LIST
			) AS T;

			DROP TABLE #ECOMM_WAIT_LIST;
			DROP TABLE #AGENCY_WAIT_LIST;
			'
		END
	ELSE IF @S_AD_KIND = 'U'
		BEGIN
			SET @SQL = @ECOMM_SQL + '
			SELECT ROW_NUMBER() OVER (ORDER BY T.ORDER_DT DESC) AS ROWNUM, T.*
				INTO #RESULT
			FROM (
				SELECT *
				FROM #ECOMM_WAIT_LIST
			) AS T;

			DROP TABLE #ECOMM_WAIT_LIST;
			'
		END
	ELSE IF @S_AD_KIND = 'A'
		BEGIN
			SET @SQL = @AGENCY_SQL + '
			SELECT ROW_NUMBER() OVER (ORDER BY T.ORDER_DT DESC) AS ROWNUM, T.*
				INTO #RESULT
			FROM (
				SELECT *
				FROM #AGENCY_WAIT_LIST
			) AS T;

			DROP TABLE #AGENCY_WAIT_LIST;
			'
		END


	SET @SQL += '
	/* 카운트 */
	SELECT @ROWCOUNT = COUNT(*) FROM #RESULT;

	/* 리스트 */
	SELECT * FROM #RESULT
	WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
	AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'

	DROP TABLE #RESULT;'

	PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

	EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount

END







GO
/****** Object:  StoredProcedure [dbo].[GET_M_ADID_BYLINEADID_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*************************************************************************************
 *  단위 업무 명 : MWPLUS에서 넘어올 때 기존에 등록된 광고이면 ADID값 가져오기
 *  작   성   자 : 김동협 	kdhwarfare@mediawill.com
 *  작   성   일 : 2009-04-13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :

	EXEC DBO.GET_M_ADID_BYLINEADID_PROC '1004510648', 90

 *************************************************************************************/

CREATE PROCEDURE	[dbo].[GET_M_ADID_BYLINEADID_PROC]

	@LINEADID VARCHAR(50),		--광고번호
	@BRANCHCD	INT						--지점코드

AS
	SELECT TOP 1 ADID
	FROM dbo.PJ_AD_AGENCY_TB
	WHERE MWPLUS_LINEADID = @LINEADID
	ORDER BY REG_DT DESC





GO
/****** Object:  StoredProcedure [dbo].[GET_M_ADSEARCH_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 관리자 > 신문 + 우대광고 검색 상세내용
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ADSEARCH_DETAIL_PROC 27425, 'A'
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ADSEARCH_DETAIL_PROC]

  @ADID INT
  ,@AD_KIND CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT ADID
        ,AD_KIND
        ,CO_NAME
        ,TITLE
        ,PHONE
        ,HPHONE
        ,START_DT
        ,BIZ_CD
        ,AREA_A
        ,AREA_B
        ,AREA_C
        ,AREA_DETAIL
        ,HOMEPAGE
        ,PAY_CD
        ,PAY_AMT
        ,MAP_X
        ,MAP_Y
        ,CONTENTS
    FROM PJ_REG_AD_SEARCH_VI
   WHERE ADID = @ADID
     AND AD_KIND = @AD_KIND









GO
/****** Object:  StoredProcedure [dbo].[GET_M_ADSEARCH_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











/*************************************************************************************
 *  단위 업무 명 : 관리자 > 신문 + 우대광고 검색결과
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /mag/admanage/PopSearchResult.asp
 *  사 용  예 제 : EXEC DBO.GET_M_ADSEARCH_PROC 1, 10, '', 'PHONE', '010',0
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ADSEARCH_PROC]

  @PAGE          INT
  ,@PAGESIZE     INT
  ,@ADKIND       CHAR(1) = ''
  ,@SEARCHFIELD  VARCHAR(10)
  ,@KEYWORD      VARCHAR(100)
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @WHERE_SQL NVARCHAR(500)
  DECLARE @ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT

  SET @SQL = ''
  SET @WHERE_SQL = ''

  SET @WHERE_SQL = ' WHERE '+ @SEARCHFIELD +' LIKE ''%'+ @KEYWORD +'%'''

  IF @ADKIND <> ''
    BEGIN
      SET @WHERE_SQL = @WHERE_SQL +' AND AD_KIND = '''+ @ADKIND +''''
    END

  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*) FROM PJ_REG_AD_SEARCH_VI '+ @WHERE_SQL +';'
  SET @SQL = @SQL + 'WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY START_DT DESC) AS ROWNUM
                     ,ADID
                    ,AD_KIND
                    ,CO_NAME
                    ,ISNULL(TITLE, CONTENTS) AS TITLE
                    ,PHONE
                    ,START_DT
                FROM PJ_REG_AD_SEARCH_VI
                '+ @WHERE_SQL  +')
			  SELECT * FROM RESULT_TABLE
			  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
			  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
			  ORDER BY START_DT DESC'

  --PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount








GO
/****** Object:  StoredProcedure [dbo].[GET_M_AGENCY_AD_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 관리자 > 등록대행 광고 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_AGENCY_AD_DETAIL_PROC 52888
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_AGENCY_AD_DETAIL_PROC]

  @ADID INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.CO_NAME
        ,A.PHONE
        ,A.HPHONE
        ,A.BIZ_CD
        ,A.AREA_A
        ,A.AREA_B
        ,A.AREA_C
        ,A.AREA_DETAIL
        ,A.HOMEPAGE
        ,A.TITLE
        ,A.CONTENTS
        ,A.THEME_CD
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.BIZ_NUMBER
        ,A.LOGO_IMG
        ,A.START_DT
        ,A.END_DT
        ,A.MWPLUS_LINEADID
        ,A.MWPLUS_OPTION
        ,A.AD_KIND
        ,A.REG_DT
        ,A.AMOUNT_ONLINE
        ,A.AMOUNT_MWPLUS
        ,A.REG_KIND
        ,A.LOCAL_CD
        ,A.OPTION_MAIN_CD
        ,A.TEMPLATE_CD
        ,A.OPT_SUB_A
        ,A.OPT_SUB_A_START_DT
        ,A.OPT_SUB_A_END_DT
        ,A.OPT_SUB_B
        ,A.OPT_SUB_B_START_DT
        ,A.OPT_SUB_B_END_DT
        ,A.OPT_SUB_C
        ,A.OPT_SUB_C_START_DT
        ,A.OPT_SUB_C_END_DT
        ,A.OPT_SUB_D
        ,A.OPT_SUB_D_START_DT
        ,A.OPT_SUB_D_END_DT
        ,A.OPT_SUB_E
        ,A.OPT_SUB_E_START_DT
        ,A.OPT_SUB_E_END_DT
        ,A.MAG_BRANCHCODE
        ,A.MAGID
        ,A.MAGNAME
        ,A.REASON
        ,A.GRAND_IMG
        ,A.MAP_X
        ,A.MAP_Y
				,A.CONFIRM_YN
				,A.PAUSE_YN
				,A.END_YN
				,ISNULL(F.ADID, '') AS PUB_ADID
				,A.M_STATUS
				,ISNULL(W.temp_key, '') AS temp_key
				,A.REG_NAME
    FROM PJ_AGENCY_AD_LIST_VI A
			LEFT JOIN PJ_AD_PUBLISH_TB AS F ON F.ADID = A.ADID AND F.AD_KIND = 'P'
			LEFT JOIN FINDDB1.PAPER_NEW.dbo.PP_AD_YAALBA_WILLS_RELATION_TB AS W ON A.ADID = W.adid_ppad
   WHERE A.ADID = @ADID
GO
/****** Object:  StoredProcedure [dbo].[GET_M_AGENCY_AD_DETAIL_PROC_BAK]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 관리자 > 등록대행 광고 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_AGENCY_AD_DETAIL_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_AGENCY_AD_DETAIL_PROC_BAK]

  @ADID INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.CO_NAME
        ,A.PHONE
        ,A.HPHONE
        ,A.BIZ_CD
        ,A.AREA_A
        ,A.AREA_B
        ,A.AREA_C
        ,A.AREA_DETAIL
        ,A.HOMEPAGE
        ,A.TITLE
        ,A.CONTENTS
        ,A.THEME_CD
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.BIZ_NUMBER
        ,A.LOGO_IMG
        ,A.START_DT
        ,A.END_DT
        ,A.MWPLUS_LINEADID
        ,A.MWPLUS_OPTION
        ,A.AD_KIND
        ,A.REG_DT
        ,A.AMOUNT_ONLINE
        ,A.AMOUNT_MWPLUS
        ,A.REG_KIND
        ,A.LOCAL_CD
        ,A.OPTION_MAIN_CD
        ,A.TEMPLATE_CD
        ,A.OPT_SUB_A
        ,A.OPT_SUB_A_START_DT
        ,A.OPT_SUB_A_END_DT
        ,A.OPT_SUB_B
        ,A.OPT_SUB_B_START_DT
        ,A.OPT_SUB_B_END_DT
        ,A.OPT_SUB_C
        ,A.OPT_SUB_C_START_DT
        ,A.OPT_SUB_C_END_DT
        ,A.OPT_SUB_D
        ,A.OPT_SUB_D_START_DT
        ,A.OPT_SUB_D_END_DT
        ,A.OPT_SUB_E
        ,A.OPT_SUB_E_START_DT
        ,A.OPT_SUB_E_END_DT
        ,A.MAG_BRANCHCODE
        ,A.MAGID
        ,A.MAGNAME
        ,A.REASON
        ,A.GRAND_IMG
        ,A.MAP_X
        ,A.MAP_Y
				,A.CONFIRM_YN
				,A.PAUSE_YN
				,A.END_YN
				,ISNULL(F.ADID, '') AS PUB_ADID
				,A.M_STATUS
    FROM PJ_AGENCY_AD_LIST_VI A
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = 'P'
   WHERE A.ADID = @ADID





GO
/****** Object:  StoredProcedure [dbo].[GET_M_AGENCY_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 관리자 > 등록대행 광고 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/18
 *  수   정   자 : 김 문 화
 *  수   정   일 : 2011/09/29
 *  설        명 :  모집업종/모집내용 추가조회 (엑셀전환시 추가)
 *  수   정   자 : 김 문 화
 *  수   정   일 : 2011/10/11
 *  설        명 :  목록에 상품종류+옵션함께출력
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXECUTE GET_M_AGENCY_AD_LIST_PROC 10,20,'A','','','','','','','','','',0
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_AGENCY_AD_LIST_PROC]

  @PAGE INT
  ,@PAGESIZE INT
  ,@AD_KIND CHAR(1)                   -- 광고형태 (A: 등록대행, U: E-Comm)
  ,@OPTION_MAIN_CD VARCHAR(2) = ''    -- 우대옵션
  ,@LOCAL_CD CHAR(1)          = ''    -- 우대옵션 게재지역
  ,@MAG_BRANCHCODE VARCHAR(3) = ''    -- 등록지점
  ,@AD_STATUS CHAR(1)         = ''    -- 게재상태 (1:진행중, 2:대기중, 3:종료)
  ,@S_DATE_KIND VARCHAR(8)    = ''    -- 날짜검색 대상 (REG_DT:등록일, MOD_DT:수정일, START_DT: 시작일, END_DT: 종료일)
  ,@S_START_DT VARCHAR(10)    = ''    -- 검색시작일
  ,@S_END_DT VARCHAR(10)      = ''    -- 검색종료일
  ,@S_KWD_KIND VARCHAR(20)    = ''    -- 키워드 검색대상 (필드명)
  ,@S_KWD_VALUE VARCHAR(50)   = ''    -- 키워드
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@TODAY             VARCHAR(19)


  SET @SQL = ''
  SET @SQL_WHERE = ' A.AD_KIND = '''+ @AD_KIND +''' '

  -- 우대옵션
  IF @OPTION_MAIN_CD <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND A.OPTION_MAIN_CD & '+ @OPTION_MAIN_CD +' = '+ @OPTION_MAIN_CD
    END

  -- 우대옵션 게재지역
  IF @LOCAL_CD <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND (A.LOCAL_CD IS NOT NULL AND A.LOCAL_CD & '+ @LOCAL_CD +' = '+ @LOCAL_CD +')'
    END

  -- 등록지점
  IF @MAG_BRANCHCODE <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND A.MAG_BRANCHCODE = '+ @MAG_BRANCHCODE
    END

  -- 게재상태 (1:진행중, 2:대기중, 3:종료)
  IF @AD_STATUS = '1'
    SET  @SQL_WHERE = @SQL_WHERE + ' AND B.ADID IS NOT NULL AND A.END_YN = 0 AND A.PAUSE_YN = 0'
  ELSE IF @AD_STATUS = '2'
    SET  @SQL_WHERE = @SQL_WHERE + ' AND (B.ADID IS NULL AND CONVERT(VARCHAR(10),A.START_DT,120) > CONVERT(VARCHAR(10),GETDATE(),120))'
  ELSE IF @AD_STATUS = '3'
    SET  @SQL_WHERE = @SQL_WHERE + ' AND (B.ADID IS NULL AND CONVERT(VARCHAR(10),A.END_DT,120) < CONVERT(VARCHAR(10),GETDATE(),120)) AND A.END_YN = 1'

  -- 날짜검색
  IF @S_DATE_KIND <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND A.'+ @S_DATE_KIND +' BETWEEN '''+ @S_START_DT +' 00:00:00'' AND '''+ @S_END_DT +' 23:59:59'' '
    END

  -- 키워드 검색
  IF @S_KWD_KIND <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND A.'+ @S_KWD_KIND +' LIKE ''%'+ @S_KWD_VALUE +'%'''
    END

  --// 쿼리 - 총개수
  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
    FROM PJ_AGENCY_AD_LIST_VI AS A
         LEFT JOIN PJ_AD_PUBLISH_TB AS B
           ON B.ADID = A.ADID
          AND B.AD_KIND = A.AD_KIND
   WHERE '+ @SQL_WHERE +';
  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.REG_DT DESC) AS ROWNUM
        ,A.ADID
        ,A.MWPLUS_LINEADID
        ,A.REG_KIND
        ,CONVERT(VARCHAR(10),A.REG_DT,11) AS C_REG_DT
        ,A.REG_DT
        ,A.CO_NAME
        ,A.PHONE
        ,ISNULL(A.OPTION_MAIN_CD,0) AS OPTION_MAIN_CD
        ,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
        ,CONVERT(VARCHAR(10),A.END_DT,120) AS END_DT
        ,A.AMOUNT_ONLINE
        ,A.AMOUNT_MWPLUS
        ,A.HIT
        ,A.MAG_BRANCHCODE
        ,A.LOGO_IMG
        ,B.ADID AS PUB_ADID
        ,A.PAUSE_YN
        ,A.END_YN
        ,A.STOP_DT
		,A.BIZ_CD
		,A.CONTENTS
	    ,ISNULL(C.OPT_SUB_A,0) AS OPT_SUB_A
	    ,ISNULL(C.OPT_SUB_B,0) AS OPT_SUB_B
	    ,ISNULL(C.OPT_SUB_C,0) AS OPT_SUB_C
	    ,ISNULL(C.OPT_SUB_D,0) AS OPT_SUB_D
	    ,ISNULL(C.OPT_SUB_E,0) AS OPT_SUB_E
	    ,A.MOD_DT
			,A.CONFIRM_YN
			,A.MOD_REQ_DT
			,A.MAGNAME
			,A.M_STATUS
    FROM PJ_AGENCY_AD_LIST_VI AS A
         LEFT JOIN PJ_AD_PUBLISH_TB AS B
           ON B.ADID = A.ADID
          AND B.AD_KIND = A.AD_KIND
           LEFT JOIN PJ_OPTION_TB AS C (NOLOCK)
              ON C.ADID = A.ADID
              AND C.AD_KIND = ''A''
   WHERE '+ @SQL_WHERE +')
  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY REG_DT DESC'

  --PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount





GO
/****** Object:  StoredProcedure [dbo].[GET_M_AGENCY_AD_LIST_PROC_VER2]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	/*************************************************************************************
	*  단위 업무 명 : 야알바 관리자 > 등록대행 광고 리스트
	*  작   성   자 : 백규원
	*  작   성   일 : 2018/10/05
	*  설        명 : 지점 조건 변경
	*  주 의  사 항 :
	*  사 용  소 스 :
	*  사 용  예 제 : EXECUTE GET_M_AGENCY_AD_LIST_PROC_VER2 10,20,'A','','','999','','','','','','',0
	*************************************************************************************/
	CREATE PROC [dbo].[GET_M_AGENCY_AD_LIST_PROC_VER2]
			@PAGE INT
		, @PAGESIZE INT
		, @AD_KIND CHAR(1)												-- 광고형태 (A: 등록대행, U: E-Comm)
		, @OPTION_MAIN_CD VARCHAR(2)			= ''    -- 우대옵션
		, @LOCAL_CD CHAR(1)								= ''    -- 우대옵션 게재지역
		, @MAG_BRANCHCODE VARCHAR(3)			= ''    -- 등록지점
		, @AD_STATUS CHAR(1)							= ''    -- 게재상태 (1:진행중, 2:대기중, 3:종료)
		, @S_DATE_KIND VARCHAR(8)					= ''    -- 날짜검색 대상 (REG_DT:등록일, MOD_DT:수정일, START_DT: 시작일, END_DT: 종료일)
		, @S_START_DT VARCHAR(10)					= ''    -- 검색시작일
		, @S_END_DT VARCHAR(10)						= ''    -- 검색종료일
		, @S_KWD_KIND VARCHAR(20)					= ''    -- 키워드 검색대상 (필드명)
		, @S_KWD_VALUE VARCHAR(50)				= ''    -- 키워드
		, @TOTAL_BRANCHCODE VARCHAR(1)		= 'N'		-- 전체지점 검색인지 여부
		, @TOTALROWS INT OUTPUT
	AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @SQL                NVARCHAR(4000)
					,@SQL_WHERE         NVARCHAR(1000)
					,@ParmDefinition    NVARCHAR(4000)
					,@ListCount         INT
					,@TODAY             VARCHAR(19)

	SET @SQL = ''
	SET @SQL_WHERE = ' A.AD_KIND = '''+ @AD_KIND +''' '

	-- 우대옵션
	IF @OPTION_MAIN_CD <> ''
		BEGIN
			SET @SQL_WHERE = @SQL_WHERE + ' AND A.OPTION_MAIN_CD & '+ @OPTION_MAIN_CD +' = '+ @OPTION_MAIN_CD
		END

	-- 우대옵션 게재지역
	IF @LOCAL_CD <> ''
		BEGIN
			SET @SQL_WHERE = @SQL_WHERE + ' AND (A.LOCAL_CD IS NOT NULL AND A.LOCAL_CD & '+ @LOCAL_CD +' = '+ @LOCAL_CD +')'
		END

	-- 등록지점
	IF @MAG_BRANCHCODE <> ''
		BEGIN
			IF @TOTAL_BRANCHCODE = 'Y'
				BEGIN
					SET @SQL_WHERE = @SQL_WHERE + ' AND A.MAG_BRANCHCODE IN (SELECT INPUT_BRANCH FROM DBO.CM_ADMIN_BRANCH_MAPPING_TB WITH(NOLOCK) WHERE MAG_BRANCH = ' + @MAG_BRANCHCODE + ') '
				END
			ELSE
				BEGIN
					SET @SQL_WHERE = @SQL_WHERE + ' AND A.MAG_BRANCHCODE = ' + @MAG_BRANCHCODE
				END
		END

	-- 게재상태 (1:게재중, 2:게재전, 3:종료, 4:보류)
	IF @AD_STATUS = '1'
		SET  @SQL_WHERE = @SQL_WHERE + ' AND B.ADID IS NOT NULL AND A.END_YN = 0 AND A.PAUSE_YN = 0'
	ELSE IF @AD_STATUS = '2'
		SET  @SQL_WHERE = @SQL_WHERE + ' AND (B.ADID IS NULL AND CONVERT(VARCHAR(10),A.START_DT,120) > CONVERT(VARCHAR(10),GETDATE(),120))'
	ELSE IF @AD_STATUS = '3'
		SET  @SQL_WHERE = @SQL_WHERE + ' AND (B.ADID IS NULL AND CONVERT(VARCHAR(10),A.END_DT,120) < CONVERT(VARCHAR(10),GETDATE(),120)) AND A.END_YN = 1'
	ELSE IF @AD_STATUS = '4'
		SET  @SQL_WHERE = @SQL_WHERE + ' AND A.PAUSE_YN = 1'

	-- 날짜검색
	IF @S_DATE_KIND <> ''
		BEGIN
			SET @SQL_WHERE = @SQL_WHERE + ' AND A.'+ @S_DATE_KIND +' BETWEEN '''+ @S_START_DT +' 00:00:00'' AND '''+ @S_END_DT +' 23:59:59'' '
		END

	-- 키워드 검색
	IF @S_KWD_KIND <> ''
		BEGIN
			SET @SQL_WHERE = @SQL_WHERE + ' AND A.'+ @S_KWD_KIND +' LIKE ''%'+ @S_KWD_VALUE +'%'''
		END

	--// 쿼리 - 총개수
	SET @SQL = '
	SELECT @ROWCOUNT = COUNT(*)
	FROM PJ_AGENCY_AD_LIST_VI AS A
		LEFT JOIN PJ_AD_PUBLISH_TB AS B ON B.ADID = A.ADID AND B.AD_KIND = A.AD_KIND
	WHERE ' + @SQL_WHERE + ';
	
	WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.REG_DT DESC) AS ROWNUM
			,A.ADID
			,A.MWPLUS_LINEADID
			,A.REG_KIND
			,CONVERT(VARCHAR(10),A.REG_DT,11) AS C_REG_DT
			,A.REG_DT
			,A.CO_NAME
			,A.PHONE
			,ISNULL(A.OPTION_MAIN_CD,0) AS OPTION_MAIN_CD
			,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
			,CONVERT(VARCHAR(10),A.END_DT,120) AS END_DT
			,A.AMOUNT_ONLINE
			,A.AMOUNT_MWPLUS
			,A.HIT
			,A.MAG_BRANCHCODE
			,A.LOGO_IMG
			,B.ADID AS PUB_ADID
			,A.PAUSE_YN
			,A.END_YN
			,A.STOP_DT
			,A.BIZ_CD
			,A.CONTENTS
			,ISNULL(C.OPT_SUB_A,0) AS OPT_SUB_A
			,ISNULL(C.OPT_SUB_B,0) AS OPT_SUB_B
			,ISNULL(C.OPT_SUB_C,0) AS OPT_SUB_C
			,ISNULL(C.OPT_SUB_D,0) AS OPT_SUB_D
			,ISNULL(C.OPT_SUB_E,0) AS OPT_SUB_E
			,A.MOD_DT
			,A.CONFIRM_YN
			,A.MOD_REQ_DT
			,A.MAGNAME
			,A.M_STATUS
			,A.REG_NAME
		FROM PJ_AGENCY_AD_LIST_VI AS A
			LEFT JOIN PJ_AD_PUBLISH_TB AS B ON B.ADID = A.ADID AND B.AD_KIND = A.AD_KIND
			LEFT JOIN PJ_OPTION_TB AS C (NOLOCK) ON C.ADID = A.ADID AND C.AD_KIND = ''A''
		WHERE ' + @SQL_WHERE + ')

		SELECT * FROM RESULT_TABLE
		WHERE ROWNUM BETWEEN ' + CAST((@PAGE - 1) * @PAGESIZE + 1 AS VARCHAR(10)) + '
			AND ' + CAST(@PAGE * @PAGESIZE AS VARCHAR(10)) + '
		ORDER BY REG_DT DESC'

	--PRINT @SQL_WHERE
	SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

	EXECUTE SP_EXECUTESQL @SQL
												,@ParmDefinition
												,@ROWCOUNT = @ListCount OUTPUT

	SET @TOTALROWS = @ListCount
GO
/****** Object:  StoredProcedure [dbo].[GET_M_BRANCH_TODAY_ADCNT_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





/*************************************************************************************
 *  단위 업무 명 : 관리자 > 지점별 우대광고 게재건수 (오늘자)
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2008/12/24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 	EXEC DBO.GET_M_BRANCH_TODAY_ADCNT_LIST_PROC
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_BRANCH_TODAY_ADCNT_LIST_PROC]

AS

	--TODAY :: 전국
  SELECT A.MAGBRANCH
        ,B.OPTION_MAIN_CD
        ,COUNT(*) AS CNT
    FROM dbo.PJ_AD_AGENCY_TB AS A
      JOIN dbo.PJ_OPTION_TB AS B
        ON A.ADID=B.ADID
       AND B.AD_KIND = 'A'
     LEFT JOIN PJ_AD_PUBLISH_TB AS C
       ON C.ADID = A.ADID
      AND C.AD_KIND = B.AD_KIND
   WHERE A.PAUSE_YN = 0
     AND A.END_YN = 0
     AND A.END_DT >= CONVERT(VARCHAR(10),GETDATE(),121) + ' 00:00:00'
     AND B.LOCAL_CD & 1 = 1  -- 전국
  	 AND C.ADID IS NOT NULL
   GROUP BY A.MAGBRANCH, B.OPTION_MAIN_CD
   ORDER BY A.MAGBRANCH ASC, B.OPTION_MAIN_CD ASC;


	--TODAY :: 부산/경남
  SELECT A.MAGBRANCH
        ,B.OPTION_MAIN_CD
        ,COUNT(*) AS CNT
    FROM dbo.PJ_AD_AGENCY_TB AS A
      JOIN dbo.PJ_OPTION_TB AS B
        ON A.ADID=B.ADID
       AND B.AD_KIND = 'A'
     LEFT JOIN PJ_AD_PUBLISH_TB AS C
       ON C.ADID = A.ADID
      AND C.AD_KIND = B.AD_KIND
   WHERE A.PAUSE_YN = 0
     AND A.END_YN = 0
     AND A.END_DT >= CONVERT(VARCHAR(10),GETDATE(),121) + ' 00:00:00'
     AND B.LOCAL_CD & 4 = 4  -- 부산
  	 AND C.ADID IS NOT NULL
   GROUP BY A.MAGBRANCH, B.OPTION_MAIN_CD
   ORDER BY A.MAGBRANCH ASC, B.OPTION_MAIN_CD ASC;


	--TODAY :: 대구/경북
  SELECT A.MAGBRANCH
        ,B.OPTION_MAIN_CD
        ,COUNT(*) AS CNT
    FROM dbo.PJ_AD_AGENCY_TB AS A
      JOIN dbo.PJ_OPTION_TB AS B
        ON A.ADID=B.ADID
       AND B.AD_KIND = 'A'
     LEFT JOIN PJ_AD_PUBLISH_TB AS C
       ON C.ADID = A.ADID
      AND C.AD_KIND = B.AD_KIND
   WHERE A.PAUSE_YN = 0
     AND A.END_YN = 0
     AND A.END_DT >= CONVERT(VARCHAR(10),GETDATE(),121) + ' 00:00:00'
     AND B.LOCAL_CD & 2 = 2  -- 대구
  	 AND C.ADID IS NOT NULL
   GROUP BY A.MAGBRANCH, B.OPTION_MAIN_CD
   ORDER BY A.MAGBRANCH ASC, B.OPTION_MAIN_CD ASC







GO
/****** Object:  StoredProcedure [dbo].[GET_M_BRANCH_TOMORROW_ADCNT_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





/*************************************************************************************
 *  단위 업무 명 : 관리자 > 지점별 우대광고 게재건수 (내일자)
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2008/12/24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 	EXEC DBO.GET_M_BRANCH_TOMORROW_ADCNT_LIST_PROC
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_BRANCH_TOMORROW_ADCNT_LIST_PROC]

AS

	--TOMORROW :: 전국
  SELECT A.MAGBRANCH
        ,B.OPTION_MAIN_CD
        ,COUNT(*) AS CNT
    FROM dbo.PJ_AD_AGENCY_TB AS A
      JOIN dbo.PJ_OPTION_TB AS B
        ON A.ADID=B.ADID
       AND B.AD_KIND = 'A'
   WHERE A.PAUSE_YN = 0
     AND A.END_YN = 0
     AND A.END_DT >= CONVERT(VARCHAR(10),GETDATE()+1,121) + ' 00:00:00'
     AND B.LOCAL_CD & 1 = 1  -- 전국
   GROUP BY A.MAGBRANCH, B.OPTION_MAIN_CD
   ORDER BY A.MAGBRANCH ASC, B.OPTION_MAIN_CD ASC;

	--TOMORROW :: 부산/경남
  SELECT A.MAGBRANCH
        ,B.OPTION_MAIN_CD
        ,COUNT(*) AS CNT
    FROM dbo.PJ_AD_AGENCY_TB AS A
      JOIN dbo.PJ_OPTION_TB AS B
        ON A.ADID=B.ADID
       AND B.AD_KIND = 'A'
   WHERE A.PAUSE_YN = 0
     AND A.END_YN = 0
     AND A.END_DT >= CONVERT(VARCHAR(10),GETDATE()+1,121) + ' 00:00:00'
     AND B.LOCAL_CD & 4 = 4  -- 부산
   GROUP BY A.MAGBRANCH, B.OPTION_MAIN_CD
   ORDER BY A.MAGBRANCH ASC, B.OPTION_MAIN_CD ASC;

	--TOMORROW :: 대구/경북
  SELECT A.MAGBRANCH
        ,B.OPTION_MAIN_CD
        ,COUNT(*) AS CNT
    FROM dbo.PJ_AD_AGENCY_TB AS A
      JOIN dbo.PJ_OPTION_TB AS B
        ON A.ADID=B.ADID
       AND B.AD_KIND = 'A'
   WHERE A.PAUSE_YN = 0
     AND A.END_YN = 0
     AND A.END_DT >= CONVERT(VARCHAR(10),GETDATE()+1,121) + ' 00:00:00'
     AND B.LOCAL_CD & 2 = 2  -- 대구
   GROUP BY A.MAGBRANCH, B.OPTION_MAIN_CD
   ORDER BY A.MAGBRANCH ASC, B.OPTION_MAIN_CD ASC








GO
/****** Object:  StoredProcedure [dbo].[GET_M_CM_ADMIN_BRANCH_MAPPING_TB_HOUSE_SEL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 관리자-지점권한 별 관리지점목록
 *  작   성   자 : 정 헌 수
 *  작   성   일 : 2014/05/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : GET_M_CM_ADMIN_BRANCH_MAPPING_TB_HOUSE_SEL_PROC 90
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_CM_ADMIN_BRANCH_MAPPING_TB_HOUSE_SEL_PROC]
  @MAGBRANCH    INT				-- 관리자권한
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT
		 A.INPUT_BRANCH
		,A.LOCALSITE_NM
		,isnull(b.BNAME,INPUT_BRANCH_NM) AS INPUT_BRANCH_NM
	FROM CM_ADMIN_BRANCH_MAPPING_TB AS A WITH(NOLOCK)
	  JOIN CC_BRANCH_TB AS B WITH(NOLOCK)
	    ON A.INPUT_BRANCH = B.BRANCHCODE
	WHERE A.MAG_BRANCH = @MAGBRANCH
	 -- AND B.USE_FLAG = 1
	 ORDER BY ord 
GO
/****** Object:  StoredProcedure [dbo].[GET_M_CODECONVERTING_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*************************************************************************************
 *  단위 업무 명 : MWPLUS 통합코드 변경
 *  작   성   자 : 김동협 	kdhwarfare@mediawill.com
 *  작   성   일 : 2008-11-28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :

	-- 구 MIS
	DECLARE	@FINDCODE	INT			--반환코드 OUTPUT
	EXEC DBO.GET_M_CODECONVERTING_PROC 37, 1000000001, @FINDCODE OUTPUT
	PRINT @FINDCODE

	-- 신 MIS
	DECLARE  @FINDCODE	INT			--반환코드 OUTPUT
	EXEC DBO.GET_M_CODECONVERTING_PROC 10, 1010101111, @FINDCODE OUTPUT
	PRINT @FINDCODE

 *************************************************************************************/


CREATE PROCEDURE	[dbo].[GET_M_CODECONVERTING_PROC]

	@BRANCH	INT,						--지점코드
	@UNITYCODE	INT,					--통합코드
	@FINDCODE	INT = 0	 OUTPUT		    --반환코드 OUTPUT

AS

--통합코드 유효성 체크
IF LEN(@UNITYCODE)<>10 AND LEN(@UNITYCODE)<>6
	BEGIN
		PRINT '잘못된 통합코드'
		GOTO ERROR1
	END

/* 구지점 MIS는 사용 않함으로 주석처리 2014.11.25 */
--구 MIS 지점
--IF @BRANCH IN (37,38,50,52,53,56,58)		--(37,38,44,45,47,50,51,52,53,56,57,58,59,66,67,68,80,82,83,86)
--	BEGIN
--		PRINT '구 MIS 지점 처리'

--		IF EXISTS(SELECT NULL FROM dbo.JOB_CATEGORY_CODEMATCHING_TB(NOLOCK) WHERE LEFT(CLASSCODE,6)=LEFT(@UNITYCODE,6))
--			BEGIN
--				SET @FINDCODE = (SELECT TOP 1 RETURNCODE FROM dbo.JOB_CATEGORY_CODEMATCHING_TB(NOLOCK) WHERE LEFT(CLASSCODE,6)=LEFT(@UNITYCODE,6))
--			END
--		ELSE
--			BEGIN
--				--10자리 코드일 때
--				IF LEN(@UNITYCODE) = 10
--					BEGIN
--						SET @FINDCODE = ISNULL((SELECT TOP 1 FINDCODE FROM FINDDB1.UNILINEDB.DBO.PLINETOFINDCODE2001 WHERE CLASSCODE = @UNITYCODE),0)
--					END
--				ELSE IF LEN(@UNITYCODE) = 6
--					BEGIN
--						SET @FINDCODE = ISNULL((SELECT TOP 1 FINDCODE FROM FINDDB1.UNILINEDB_NEW.DBO.PLINETOFINDCODE2001 WHERE LEFT(CLASSCODE,6) = @UNITYCODE),0)
--					END
--			END

--		GOTO SUCC
--	END

----신 MIS 지점
--ELSE IF @BRANCH IN (10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,39,40,42,43,46,48,49,54,55,60,67,68,80,83,87,90,94)		--(10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,39,40,41,42,43,46,48,49,54,55,60,61,62,73,87,90,94,103)
	BEGIN
		PRINT '신 MIS 지점 처리'

		IF EXISTS(SELECT NULL FROM dbo.JOB_CATEGORY_CODEMATCHING_TB(NOLOCK) WHERE LEFT(CLASSCODE,6)=LEFT(@UNITYCODE,6))
			BEGIN
				SET @FINDCODE = (SELECT TOP 1 RETURNCODE FROM dbo.JOB_CATEGORY_CODEMATCHING_TB(NOLOCK) WHERE LEFT(CLASSCODE,6)=LEFT(@UNITYCODE,6))
			END
		ELSE
			BEGIN
				--10자리 코드일 때
				IF LEN(@UNITYCODE) = 10
					BEGIN
						SET @FINDCODE = ISNULL((SELECT TOP 1 FINDCODE FROM FINDDB1.UNILINEDB_NEW.DBO.PLINETOFINDCODE2002 WHERE CLASSCODETOT = @UNITYCODE),0)
					END
				ELSE IF LEN(@UNITYCODE) = 6
					BEGIN
						SET @FINDCODE = ISNULL((SELECT TOP 1 FINDCODE FROM FINDDB1.UNILINEDB_NEW.DBO.PLINETOFINDCODE2002 WHERE LEFT(CLASSCODE,6) = @UNITYCODE),0)
					END
			END

		GOTO SUCC
	END

--잘못된 지점코드
--ELSE
--	BEGIN
--		PRINT '잘못된 지점 코드'
--		GOTO ERROR2
--	END

--PRINT @FINDCODE

ERROR1: --잘못된 통합코드
	BEGIN
		SET @FINDCODE = -1
		RETURN @FINDCODE
	END

ERROR2:	--잘못된 지점코드
	BEGIN
		SET @FINDCODE = -2
		RETURN @FINDCODE
	END

SUCC:
	BEGIN
		RETURN @FINDCODE
	END









GO
/****** Object:  StoredProcedure [dbo].[GET_M_E_PAPER_CASHLIST]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*********************************************************************
* Description
*
*  내용 : 관리자 E 벼룩시장 현금영수증리스트
*  EXEC  DBO.GET_M_E_PAPER_CASHLIST
*********************************************************************/
/*********************************************************************
* Work History
* GET_M_E_PAPER_CASHLIST '','','','','','','','1','15',0
*	1) 정태운(2010/05/18) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_M_E_PAPER_CASHLIST]
/*********************************************************************
* Interface Part
*********************************************************************/
(
      @strDTDIV       VARCHAR(1)    = ''                      -- 날짜구분
,     @strStDate      VARCHAR(10)   = ''                      -- 날짜시작
,     @strEnDate      VARCHAR(10)   = ''                      -- 날짜종료
,     @strUseDiv      VARCHAR(1)    = ''                      -- 용도
,     @strStateDIv    VARCHAR(1)    = ''                      -- 상태

,    	@strKey         CHAR(1)				=	''
,    	@strWord		    VARCHAR(100)	=	''
,   	@n4Page		      INT
,    	@n2PageSize     SMALLINT
,     @TOTALROWS INT OUTPUT
)
AS

  SET NOCOUNT ON

  /*********************************************************************
  * Implementation Part
  *********************************************************************/
  DECLARE @strSQL			NVARCHAR(4000)
  DECLARE @strSQLSUB	NVARCHAR(3000)
  DECLARE @ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@TODAY             VARCHAR(19)

  SET @strSQLSUB = ''
  SET @strSQL = ''


  -- 용도
  IF @strUseDiv <> '' BEGIN
    SET @strSQLSUB = @strSQLSUB+ ' AND R.UseOpt = ' + @strUseDiv
  END

  -- 상태
  IF @strStateDIv <> '' BEGIN
    SET @strSQLSUB = @strSQLSUB+ ' AND R.Result = ' + @strStateDIv
  END

  -- 날짜상태
  IF @strDTDIV <> '' BEGIN
    IF @strDTDIV = '0' BEGIN
      SET @strSQLSUB = @strSQLSUB+ ' AND (R.RegDate >= CONVERT(DATETIME, ''' + @strStDate + ''') AND R.RegDate <= CONVERT(DATETIME, ''' + @strEnDate + ' 23:59:59''))'
    END
  END

  -- 검색
  IF @strWord <> '' BEGIN
  IF @strKey = '' BEGIN
    SET @strSQLSUB = @strSQLSUB+' AND (R.Serial LIKE ''%'+@strWord+'%''
                                        OR R.GrpSerial LIKE ''%' + @strWord + '%''
                                        OR R.GoodName LIKE ''%' + @strWord + '%''
                                        OR R.BuyerName LIKE ''%'+@strWord+'%'')'
  END ELSE IF  @strKey = '0' BEGIN
    --SET @strSQLSUB = @strSQLSUB+' AND C.ADID LIKE ''%'+@strWord+'%''  '
 SET @strSQLSUB = @strSQLSUB+' AND C.ADID = '''+@strWord+'''  '
  END ELSE IF  @strKey = '1' BEGIN
    --SET @strSQLSUB = @strSQLSUB+' AND R.GrpSerial LIKE ''%'+@strWord+'%''  '
 SET @strSQLSUB = @strSQLSUB+' AND R.GrpSerial = '''+@strWord+'''  '
  END ELSE IF  @strKey = '2' BEGIN
    --SET @strSQLSUB = @strSQLSUB+' AND R.GoodName LIKE ''%'+@strWord+'%''  '
 SET @strSQLSUB = @strSQLSUB+' AND R.GoodName = '''+@strWord+'''  '
  END ELSE IF  @strKey = '3' BEGIN
    SET @strSQLSUB = @strSQLSUB+' AND R.BuyerName LIKE ''%'+@strWord+'%''  '
  END
END

  SET @strSQL='SELECT @ROWCOUNT = COUNT(*) FROM PJ_RECEIPT_REQUEST_TB R (NOLOCK)  LEFT OUTER JOIN  PJ_RECCHARGE_TB C (NOLOCK) ON R.GrpSerial = C.Serial WHERE R.GOODNAME = ''유흥구인광고''  ' +@strSQLSUB +';
  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY R.Serial DESC) AS ROWNUM
    ,R.Serial
    ,R.adGbn
    ,R.GrpSerial
    ,R.GoodName
    ,R.Cr_Price
    ,R.Sup_Price
    ,R.Tax
    ,R.Srvc_Price
    ,R.BuyerName
    ,R.BuyerEmail
    ,R.BuyerTel
    ,R.RegNum
    ,R.UseOpt
    ,ISNULL(R.Result,0) AS Result
    ,R.Tid
    ,CONVERT(VARCHAR(10), R.RegDate, 120) AS RegDate
    ,R.ResultDate
    ,R.CancelDate
    ,C.ADID
    FROM PJ_RECEIPT_REQUEST_TB R (NOLOCK) LEFT OUTER JOIN PJ_RECCHARGE_TB C (NOLOCK) ON R.GrpSerial = C.Serial
   WHERE R.GOODNAME = ''유흥구인광고''  ' +@strSQLSUB+')
  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@n4Page-1)*@n2PageSize+1 AS VARCHAR(10)) +'
  AND '+ CAST(@n4Page*@n2PageSize AS VARCHAR(10)) +'
  ORDER BY Serial DESC'

  PRINT @strSQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @strSQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF


















GO
/****** Object:  StoredProcedure [dbo].[GET_M_ECOMM_AD_CONFIRM_WAIT_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 검수대기 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXECUTE DBO.GET_M_ECOMM_AD_CONFIRM_WAIT_LIST_PROC 1,20,'','','','','','','',0
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ECOMM_AD_CONFIRM_WAIT_LIST_PROC]

  @PAGE INT
  ,@PAGESIZE INT
  ,@LOCAL_CD CHAR(1)          = ''    -- 우대옵션 게재지역
  ,@OPTION_MAIN_CD VARCHAR(2) = ''    -- 우대옵션
  ,@S_DATE_KIND VARCHAR(8)    = ''    -- 날짜검색 대상 (REG_DT:등록일, START_DT: 시작일, END_DT: 종료일)
  ,@S_START_DT VARCHAR(10)    = ''    -- 검색시작일
  ,@S_END_DT VARCHAR(10)      = ''    -- 검색종료일
  ,@S_KWD_KIND VARCHAR(10)    = ''    -- 키워드 검색대상 (필드명)
  ,@S_KWD_VALUE VARCHAR(50)   = ''    -- 키워드
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@SQL_COUNT         NVARCHAR(1000)
          ,@TODAY             VARCHAR(19)

  SET @SQL = ''
  SET @SQL_COUNT = ''
  SET @SQL_WHERE = ' B.PRNAMTOK = 1 AND A.CONFIRM_YN = 0 '  -- 기본조건: 결제완료, 검수대기

  -- 조건: 게재지역
  IF @LOCAL_CD <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND C.LOCAL_CD & '+ @LOCAL_CD +' = '+ @LOCAL_CD

  -- 검색: 우대옵션
  IF @OPTION_MAIN_CD <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND C.OPTION_MAIN_CD & '+ @OPTION_MAIN_CD +' = '+ @OPTION_MAIN_CD

  -- 검색: 날짜검색
  IF @S_DATE_KIND <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @S_DATE_KIND +' BETWEEN '''+ @S_START_DT +''' AND '''+ @S_END_DT +''' '
    END

  -- 검색: 키워드 검색
  IF @S_KWD_KIND <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @S_KWD_KIND +' LIKE ''%'+ @S_KWD_VALUE +'%'''
    END

  --// 카운터 쿼리
  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
  FROM PJ_AD_USERREG_TB AS A
    JOIN PJ_RECCHARGE_TB AS B
      ON B.ADID = A.ADID
     AND AD_GBN = 1
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS D
      ON D.CUID = A.CUID
  WHERE '+ @SQL_WHERE +';
  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.REG_DT DESC) AS ROWNUM
      ,A.ADID
      ,CONVERT(VARCHAR(10),A.REG_DT,11) AS REG_DT
      ,A.USERID
      ,A.CO_NAME
      ,D.USER_NM AS USERNAME
      ,C.LOCAL_CD
      ,C.OPTION_MAIN_CD
      ,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
      ,CONVERT(VARCHAR(10),A.END_DT,120) AS END_DT
      ,A.CUID
  FROM PJ_AD_USERREG_TB AS A
    JOIN PJ_RECCHARGE_TB AS B
      ON B.ADID = A.ADID
     AND AD_GBN = 1
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS D
      ON D.CUID = A.CUID
  WHERE '+ @SQL_WHERE +')
  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY REG_DT DESC'

  PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount





GO
/****** Object:  StoredProcedure [dbo].[GET_M_ECOMM_AD_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 ) E-COMM 광고 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ECOMM_AD_DETAIL_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ECOMM_AD_DETAIL_PROC]

  @ADID INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.CO_NAME
        ,A.PHONE
        ,A.HPHONE
        ,A.BIZ_CD
        ,A.AREA_A
        ,A.AREA_B
        ,A.AREA_C
        ,A.AREA_DETAIL
        ,A.HOMEPAGE
        ,A.TITLE
        ,A.CONTENTS
        ,A.THEME_CD
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.BIZ_NUMBER
        ,A.LOGO_IMG
        ,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
        ,CONVERT(VARCHAR(10),A.END_DT,120) AS END_DT
        ,C.AD_KIND
        ,A.REG_DT

        ,C.LOCAL_CD
        ,C.OPTION_MAIN_CD
        ,C.TEMPLATE_CD
        ,C.OPT_SUB_A
        ,CONVERT(VARCHAR(10),C.OPT_SUB_A_START_DT,120) AS OPT_SUB_A_START_DT
        ,CONVERT(VARCHAR(10),C.OPT_SUB_A_END_DT,120) AS OPT_SUB_A_END_DT
        ,C.OPT_SUB_B
        ,CONVERT(VARCHAR(10),C.OPT_SUB_B_START_DT,120) AS OPT_SUB_B_START_DT
        ,CONVERT(VARCHAR(10),C.OPT_SUB_B_END_DT,120) AS OPT_SUB_B_END_DT
        ,C.OPT_SUB_C
        ,CONVERT(VARCHAR(10),C.OPT_SUB_C_START_DT,120) AS OPT_SUB_C_START_DT
        ,CONVERT(VARCHAR(10),C.OPT_SUB_C_END_DT,120) AS OPT_SUB_C_END_DT
        ,C.OPT_SUB_D
        ,CONVERT(VARCHAR(10),C.OPT_SUB_D_START_DT,120) AS OPT_SUB_D_START_DT
        ,CONVERT(VARCHAR(10),C.OPT_SUB_D_END_DT,120) AS OPT_SUB_D_END_DT
        ,C.OPT_SUB_E
        ,CONVERT(VARCHAR(10),C.OPT_SUB_E_START_DT,120) AS OPT_SUB_E_START_DT
        ,CONVERT(VARCHAR(10),C.OPT_SUB_E_END_DT,120) AS OPT_SUB_E_END_DT

        ,A.USERID
        ,B.USER_NM AS USERNAME

        ,D.SERIAL
        ,D.RECDATE
        ,D.INIPAYTID
        ,D.PRNAMT
        ,D.CHARGE_KIND
        ,D.PRNAMTOK
        ,D.CANCELDATE
        ,D.BANKNM
        ,D.ACCOUNTNUM
        ,A.MAP_X
        ,A.MAP_Y
        ,A.GRAND_IMG
		,A.CONFIRM_YN
		,A.PAUSE_YN
		,A.END_YN
		,F.ADID AS PUB_ADID
		,A.CUID
  FROM PJ_AD_USERREG_TB AS A
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS B
      ON B.CUID = A.CUID
    JOIN PJ_RECCHARGE_TB AS D
      ON D.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = 'U'
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = 'U'
   WHERE A.ADID = @ADID











GO
/****** Object:  StoredProcedure [dbo].[GET_M_ECOMM_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 ) E-COMM 광고리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ECOMM_AD_LIST_PROC 1, 20,'','','','','','','','','',0
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ECOMM_AD_LIST_PROC]

  @PAGE  INT
  ,@PAGESIZE  INT
  ,@LOCAL CHAR(1)
  ,@PUBSTATUS CHAR(1)
  ,@PAYSTATUS CHAR(1)
  ,@OPTION CHAR(2)
  ,@FIELD_DATE VARCHAR(10)
  ,@START_DT VARCHAR(10)
  ,@END_DT VARCHAR(10)
  ,@FIELD_KEYWORD VARCHAR(15)
  ,@KEYWORD VARCHAR(30)
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@TODAY             VARCHAR(19)

  SET @TODAY = CONVERT(VARCHAR(10),GETDATE(),121) +' 00:00:00'
  SET @SQL = ''

  -- 기본조건
  SET @SQL_WHERE = ''

  -- 조건: 게재지역
  IF @LOCAL <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND C.LOCAL_CD & '+ @LOCAL +' = '+ @LOCAL

  -- 조건: 게재상태
  IF @PUBSTATUS <> ''
    BEGIN
      IF @PUBSTATUS = 1  -- 게재전
        SET @SQL_WHERE = @SQL_WHERE + ' AND (A.START_DT > '''+ @TODAY +''' OR D.PRNAMTOK <> 1 OR A.CONFIRM_YN <> 1) AND A.END_DT > '''+ @TODAY +''''
      ELSE IF @PUBSTATUS = 2  -- 게재중
        SET @SQL_WHERE = @SQL_WHERE + ' AND A.START_DT <= '''+ @TODAY +''' AND A.END_DT > '''+ @TODAY +''' AND D.PRNAMTOK = 1 AND A.PAUSE_YN = 0 AND A.END_YN = 0 '
      ELSE IF @PUBSTATUS = 3  -- 게재보류
        SET @SQL_WHERE = @SQL_WHERE + ' AND A.PAUSE_YN = 1 '
      ELSE IF @PUBSTATUS = 4  -- 게재종료
        SET @SQL_WHERE = @SQL_WHERE + ' AND (A.END_YN = 1 OR A.END_DT < '''+ @TODAY +''') AND A.PAUSE_YN = 0'
    END

  -- 조건: 결제상태
  IF @PAYSTATUS <> ''
		BEGIN
			IF @PAYSTATUS = '0'
				SET @SQL_WHERE = @SQL_WHERE + ' AND D.PRNAMTOK = 0 AND D.INIPAYTID IS NOT NULL '
			ELSE IF @PAYSTATUS = '3'
				SET @SQL_WHERE = @SQL_WHERE + ' AND D.PRNAMTOK = 0 AND D.INIPAYTID IS NULL '
			ELSE
				SET @SQL_WHERE = @SQL_WHERE + ' AND D.PRNAMTOK = '+ @PAYSTATUS +' '
		END

  -- 조건: 우대광고
  IF @OPTION <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND C.OPTION_MAIN_CD & '+ @OPTION +' = '+ @OPTION +' '

  -- 조건: 기간
  IF @FIELD_DATE <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @FIELD_DATE +' BETWEEN '''+ @START_DT +''' AND '''+ @END_DT +''' '

  -- 조건: 키워드
  IF @FIELD_KEYWORD <> '' AND @KEYWORD <> ''
    BEGIN
      IF @FIELD_KEYWORD = 'A.ADID'  -- 광고번호 검색인 경우 EQUAL
        SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @FIELD_KEYWORD +' = '+ @KEYWORD
      ELSE
        SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @FIELD_KEYWORD +' LIKE ''%'+ @KEYWORD +'%'' '
    END

  -- // 쿼리: 카운트
  SET @SQL = '
  SELECT @ROWCOUNT = COUNT(*)
    FROM PJ_AD_USERREG_TB AS A
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS B
      ON B.CUID = A.CUID
    JOIN PJ_RECCHARGE_TB AS D
      ON D.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
    LEFT JOIN PJ_AD_COUNT_TB AS E
      ON E.ADID = A.ADID
     AND E.AD_KIND = ''U''
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = ''U''
  WHERE 1 = 1 '+ @SQL_WHERE +';
  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.ADID DESC) AS ROWNUM
    ,A.ADID
    ,A.USERID
    ,B.USER_NM AS USERNAME
    ,CONVERT(VARCHAR(8),A.REG_DT,11) AS REG_DT
    ,A.CO_NAME
    ,C.LOCAL_CD
    ,C.OPTION_MAIN_CD
    ,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
    ,CONVERT(VARCHAR(10),A.END_DT,120) AS END_DT
    ,D.PRNAMT
    ,ISNULL(E.HIT,0) AS HIT
    ,A.CONFIRM_YN
    ,A.PAUSE_YN
    ,A.END_YN
    ,A.LOGO_IMG
    ,D.CHARGE_KIND
    ,D.PRNAMTOK
    ,CONVERT(VARCHAR(10),A.STOP_DT,11) AS STOP_DT
    ,D.SERIAL
    ,D.INIPAYTID
	,A.MOD_REQ_DT
	,F.ADID AS PUB_ADID
	,A.CUID
  FROM PJ_AD_USERREG_TB AS A
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS B
      ON B.CUID = A.CUID
    JOIN PJ_RECCHARGE_TB AS D
      ON D.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
    LEFT JOIN PJ_AD_COUNT_TB AS E
      ON E.ADID = A.ADID
     AND E.AD_KIND = ''U''
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND =  ''U''
  WHERE 1 = 1 '+ @SQL_WHERE +')
  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY ADID DESC'

  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount












GO
/****** Object:  StoredProcedure [dbo].[GET_M_ECOMM_END_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 ) E-COMM 종료광고리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ECOMM_END_AD_LIST_PROC 1,20,'2','','0','','','','','','','',0
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ECOMM_END_AD_LIST_PROC]

  @PAGE  INT
  ,@PAGESIZE  INT
  ,@LOCAL CHAR(1)
  ,@PUBSTATUS CHAR(1)
  ,@PAYSTATUS CHAR(1)
  ,@OPTION CHAR(2)
  ,@CONFIRM CHAR(1)
  ,@FIELD_DATE VARCHAR(10)
  ,@START_DT VARCHAR(10)
  ,@END_DT VARCHAR(10)
  ,@FIELD_KEYWORD VARCHAR(15)
  ,@KEYWORD VARCHAR(30)
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@TODAY             VARCHAR(19)


  SET @TODAY = CONVERT(VARCHAR(10),GETDATE(),121) +' 00:00:00'
  SET @SQL = ''
  SET @SQL_WHERE = ''




  -- 조건: 게재상태
  IF @PUBSTATUS <> ''
    BEGIN
      IF @PUBSTATUS = 1  -- 게재만기
        SET @SQL_WHERE = @SQL_WHERE + ' AND A.END_DT < '''+ @TODAY +''' AND A.END_YN <> 1'
      ELSE IF @PUBSTATUS = 2  -- 종료처리
        SET @SQL_WHERE = @SQL_WHERE + ' AND A.END_YN = 1 '
    END
  ELSE
    BEGIN
      -- 기본조건
      SET @SQL_WHERE = ' AND (END_YN = 1 OR A.END_DT < '''+ @TODAY +''') '
    END

-- 조건: 게재지역
  IF @LOCAL <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND C.LOCAL_CD = '+ @LOCAL

  -- 조건: 결제상태
  IF @PAYSTATUS <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND D.PRNAMTOK = '+ @PAYSTATUS +' '

  -- 조건: 우대광고
  IF @OPTION <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND C.OPTION_MAIN_CD & '+ @OPTION +' = '+ @OPTION +' '

  -- 조건: 검수상태
  IF @CONFIRM <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND A.CONFIRM_YN = '+ @CONFIRM +' '

  -- 조건: 기간
  IF @FIELD_DATE <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @FIELD_DATE +' BETWEEN '''+ @START_DT +''' AND '''+ @END_DT +''' '

  -- 조건: 키워드
  IF @FIELD_KEYWORD <> '' AND @KEYWORD <> ''
    BEGIN
      IF @FIELD_KEYWORD = 'A.ADID'  -- 광고번호 검색인 경우 EQUAL
        SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @FIELD_KEYWORD +' = '+ @KEYWORD
      ELSE
        SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @FIELD_KEYWORD +' LIKE ''%'+ @KEYWORD +'%'' '
    END

  -- // 쿼리: 리스트
  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
    FROM PJ_AD_USERREG_TB AS A
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS B
      ON B.CUID = A.CUID
    JOIN PJ_RECCHARGE_TB AS D
      ON D.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = ''U''
  WHERE 1 = 1 '+ @SQL_WHERE +';
  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.ADID DESC) AS ROWNUM
      ,A.ADID
      ,A.USERID
      ,B.USER_NM AS USERNAME
      ,CONVERT(VARCHAR(8),A.REG_DT,11) AS REG_DT
      ,A.CO_NAME
      ,A.PHONE
      ,A.HPHONE
      ,C.OPTION_MAIN_CD
      ,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
      ,CONVERT(VARCHAR(10),A.END_DT,120) AS END_DT
      ,D.PRNAMT
      ,ISNULL(E.HIT,0) AS HIT
      ,A.CONFIRM_YN
      ,A.PAUSE_YN
      ,A.END_YN
      ,CONVERT(VARCHAR(8),A.STOP_DT,11) AS STOP_DT
      ,C.LOCAL_CD
      ,D.PRNAMTOK
      ,D.CHARGE_KIND
      ,D.INIPAYTID
	  ,A.MOD_REQ_DT
	  ,F.ADID AS PUB_ADID
	  ,A.CUID
  FROM PJ_AD_USERREG_TB AS A
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS B
      ON B.CUID = A.CUID
    JOIN PJ_RECCHARGE_TB AS D
      ON D.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
    LEFT JOIN PJ_AD_COUNT_TB AS E
      ON E.ADID = A.ADID
     AND E.AD_KIND = ''U''
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = ''U''
  WHERE 1 = 1 '+ @SQL_WHERE +')
  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY ADID DESC'

  --PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount
















GO
/****** Object:  StoredProcedure [dbo].[GET_M_ECOMM_MODIFY_AD_CONFIRM_WAIT_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 검수대기 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ECOMM_MODIFY_AD_CONFIRM_WAIT_LIST_PROC 1, 20,'','','','','','','','',0
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ECOMM_MODIFY_AD_CONFIRM_WAIT_LIST_PROC]

  @PAGE INT
  ,@PAGESIZE INT
  ,@LOCAL_CD CHAR(1)          = ''    -- 우대옵션 게재지역
  ,@PUBSTATUS CHAR(1)         = ''    -- 게재상태
  ,@OPTION_MAIN_CD VARCHAR(2) = ''    -- 우대옵션
  ,@S_DATE_KIND VARCHAR(8)    = ''    -- 날짜검색 대상 (REG_DT:등록일, START_DT: 시작일, END_DT: 종료일)
  ,@S_START_DT VARCHAR(10)    = ''    -- 검색시작일
  ,@S_END_DT VARCHAR(10)      = ''    -- 검색종료일
  ,@S_KWD_KIND VARCHAR(10)    = ''    -- 키워드 검색대상 (필드명)
  ,@S_KWD_VALUE VARCHAR(50)   = ''    -- 키워드
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@SQL_COUNT         NVARCHAR(1000)
          ,@TODAY             VARCHAR(19)


  SET @TODAY = CONVERT(VARCHAR(10),GETDATE(),121) +' 00:00:00'
  SET @SQL = ''
  SET @SQL_COUNT = ''
  SET @SQL_WHERE = ' C.PRNAMTOK = 1 '  -- 기본조건: 결제완료

  -- 조건: 게재지역
  IF @LOCAL_CD <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND D.LOCAL_CD & '+ @LOCAL_CD +' = '+ @LOCAL_CD

  -- 조건: 게재상태
  IF @PUBSTATUS <> ''
    BEGIN
      IF @PUBSTATUS = 1  -- 게재전
        SET @SQL_WHERE = @SQL_WHERE + ' AND (B.START_DT > '''+ @TODAY +''' OR C.PRNAMTOK <> 1) AND B.END_DT > '''+ @TODAY +''' AND A.CONFIRM_YN = 1'
      ELSE IF @PUBSTATUS = 2  -- 게재중
        SET @SQL_WHERE = @SQL_WHERE + ' AND B.START_DT <= '''+ @TODAY +''' AND B.END_DT > '''+ @TODAY +''' AND B.PAUSE_YN = 0 AND B.END_YN = 0 '
      ELSE IF @PUBSTATUS = 3  -- 게재보류
        SET @SQL_WHERE = @SQL_WHERE + ' AND B.PAUSE_YN = 1 '
      ELSE IF @PUBSTATUS = 4  -- 게재종료
        SET @SQL_WHERE = @SQL_WHERE + ' AND (B.END_YN = 1 OR B.END_DT < '''+ @TODAY +''') AND B.PAUSE_YN = 0'
    END

  -- 검색: 우대옵션
  IF @OPTION_MAIN_CD <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND D.OPTION_MAIN_CD & '+ @OPTION_MAIN_CD +' = '+ @OPTION_MAIN_CD

  -- 검색: 날짜검색
  IF @S_DATE_KIND <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @S_DATE_KIND +' BETWEEN '''+ @S_START_DT +''' AND '''+ @S_END_DT +''' '
    END

  -- 검색: 키워드 검색
  IF @S_KWD_KIND <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @S_KWD_KIND +' LIKE ''%'+ @S_KWD_VALUE +'%'''
    END

  --// 카운터 쿼리
  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
  FROM PJ_AD_USERREG_MODIFY_TB AS A
    JOIN PJ_AD_USERREG_TB AS B
      ON B.ADID = A.ADID
    JOIN PJ_RECCHARGE_TB AS C
      ON C.ADID = A.ADID
     AND AD_GBN = 1
    JOIN PJ_OPTION_TB AS D
      ON D.ADID = A.ADID
     AND D.AD_KIND = ''U''
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS E
      ON E.CUID = B.CUID
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = ''U''
  WHERE '+ @SQL_WHERE +';
  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.CONFIRM_YN ASC, A.REG_DT DESC) AS ROWNUM
      ,A.ADID
      ,CONVERT(VARCHAR(10),A.REG_DT,11) AS REG_DT
      ,B.USERID
      ,A.CO_NAME
      ,E.USER_NM AS USERNAME
      ,D.LOCAL_CD
      ,D.OPTION_MAIN_CD
      ,CONVERT(VARCHAR(10),B.START_DT,120) AS START_DT
      ,CONVERT(VARCHAR(10),B.END_DT,120) AS END_DT
      ,B.CONFIRM_YN
      ,B.PAUSE_YN
      ,B.END_YN
      ,C.PRNAMTOK
      ,A.CONFIRM_YN AS MOD_CONFIRM_YN
	  ,F.ADID AS PUB_ADID
	  ,B.CUID
  FROM PJ_AD_USERREG_MODIFY_TB AS A
    JOIN PJ_AD_USERREG_TB AS B
      ON B.ADID = A.ADID
    JOIN PJ_RECCHARGE_TB AS C
      ON C.ADID = A.ADID
     AND AD_GBN = 1
    JOIN PJ_OPTION_TB AS D
      ON D.ADID = A.ADID
     AND D.AD_KIND = ''U''
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS E
      ON E.CUID = B.CUID
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = ''U''
  WHERE '+ @SQL_WHERE +')
  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
 '

  --PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount









GO
/****** Object:  StoredProcedure [dbo].[GET_M_ECOMM_MODIFY_AD_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 ) E-COMM 수정신청 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ECOMM_MODIFY_AD_DETAIL_PROC 12
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ECOMM_MODIFY_AD_DETAIL_PROC]

  @ADID INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.CO_NAME
        ,A.PHONE
        ,A.HPHONE
        ,A.BIZ_CD
        ,A.AREA_A
        ,A.AREA_B
        ,A.AREA_C
        ,A.AREA_DETAIL
        ,A.HOMEPAGE
        ,A.TITLE
        ,A.CONTENTS
        ,A.THEME_CD
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.BIZ_NUMBER
        ,A.REG_DT
        ,B.USERID
        ,C.USER_NM AS USERNAME
        ,A.MAP_X
        ,A.MAP_Y
        ,B.CUID
    FROM PJ_AD_USERREG_MODIFY_TB AS A
      JOIN PJ_AD_USERREG_TB AS B
        ON B.ADID = A.ADID
      JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS C
        ON C.CUID = B.CUID
   WHERE A.ADID = @ADID










GO
/****** Object:  StoredProcedure [dbo].[GET_M_ECOMM_PAY_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 ) E-COMM 결제리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ECOMM_PAY_LIST_PROC 1,20,'1','4','','','','','','','',0
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ECOMM_PAY_LIST_PROC]

  @PAGE  INT
  ,@PAGESIZE  INT
  ,@LOCAL CHAR(1)
  ,@PUBSTATUS CHAR(1)
  ,@PAYSTATUS CHAR(1)
  ,@OPTION CHAR(2)
  ,@FIELD_DATE VARCHAR(10)
  ,@START_DT VARCHAR(10)
  ,@END_DT VARCHAR(10)
  ,@FIELD_KEYWORD VARCHAR(15)
  ,@KEYWORD VARCHAR(30)
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@SQL_COUNT         NVARCHAR(1000)
          ,@TODAY             VARCHAR(19)


  SET @TODAY = CONVERT(VARCHAR(10),GETDATE(),121) +' 00:00:00'
  SET @SQL_COUNT = ''
  SET @SQL = ''
  SET @SQL_WHERE = ''

  -- 조건: 게재지역
  IF @LOCAL <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND C.LOCAL_CD & '+ @LOCAL +' = '+ @LOCAL








  -- 조건: 게재상태
  IF @PUBSTATUS <> ''
    BEGIN
      IF @PUBSTATUS = 1  -- 게재전
        SET @SQL_WHERE = @SQL_WHERE + ' AND (A.START_DT > '''+ @TODAY +''' OR B.PRNAMTOK <> 1 OR A.CONFIRM_YN <> 1) AND A.END_DT > '''+ @TODAY +''' '
      ELSE IF @PUBSTATUS = 2  -- 게재중
        SET @SQL_WHERE = @SQL_WHERE + ' AND A.START_DT <= '''+ @TODAY +''' AND A.END_DT > '''+ @TODAY +''' AND B.PRNAMTOK = 1 AND A.PAUSE_YN = 0 AND A.END_YN = 0 '
      ELSE IF @PUBSTATUS = 3  -- 게재보류
        SET @SQL_WHERE = @SQL_WHERE + ' AND A.PAUSE_YN = 1 '
      ELSE IF @PUBSTATUS = 4  -- 게재종료
        SET @SQL_WHERE = @SQL_WHERE + ' AND (A.END_YN = 1 OR A.END_DT < '''+ @TODAY +''') AND A.PAUSE_YN = 0'
    END

  -- 조건: 결제상태
  IF @PAYSTATUS <> ''
		BEGIN
			IF @PAYSTATUS = '0'
				SET @SQL_WHERE = @SQL_WHERE + ' AND B.PRNAMTOK = 0 AND B.INIPAYTID IS NOT NULL '
			ELSE IF @PAYSTATUS = '3'
				SET @SQL_WHERE = @SQL_WHERE + ' AND B.PRNAMTOK = 0 AND B.INIPAYTID IS NULL '
			ELSE
				SET @SQL_WHERE = @SQL_WHERE + ' AND B.PRNAMTOK = '+ @PAYSTATUS +' '
		END

  -- 조건: 우대광고
  IF @OPTION <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND C.OPTION_MAIN_CD & '+ @OPTION +' = '+ @OPTION +' '

  -- 조건: 기간
  IF @FIELD_DATE <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @FIELD_DATE +' BETWEEN '''+ @START_DT +''' AND '''+ @END_DT +''' '

  -- 조건: 키워드
  IF @FIELD_KEYWORD <> '' AND @KEYWORD <> ''
    BEGIN
      IF @FIELD_KEYWORD = 'A.ADID'  -- 광고번호 검색인 경우 EQUAL
        SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @FIELD_KEYWORD +' = '+ @KEYWORD
      ELSE
        SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @FIELD_KEYWORD +' LIKE ''%'+ @KEYWORD +'%'' '
    END

  -- // 쿼리: 리스트
  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
  FROM PJ_AD_USERREG_TB AS A
    JOIN PJ_RECCHARGE_TB AS B
      ON B.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS D
      ON D.CUID = A.CUID
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = ''U''
  WHERE 1 = 1 '+ @SQL_WHERE +';
  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.ADID DESC) AS ROWNUM
      ,A.ADID
      ,CONVERT(VARCHAR(8),A.REG_DT,11) AS REG_DT
      ,A.CO_NAME
      ,C.OPTION_MAIN_CD
      ,B.CHARGE_KIND
      ,B.PRNAMT
      ,B.PRNAMTOK
      ,ISNULL(CONVERT(VARCHAR(8),B.RECDATE,11),''-'') AS RECDATE
      ,A.CONFIRM_YN
      ,A.PAUSE_YN
      ,A.END_YN
      ,A.USERID
      ,D.USER_NM AS USERNAME
      ,C.LOCAL_CD
      ,A.START_DT
      ,A.END_DT
      ,B.SERIAL
      ,B.INIPAYTID
	  ,F.ADID AS PUB_ADID
	  ,A.CUID
  FROM PJ_AD_USERREG_TB AS A
    JOIN PJ_RECCHARGE_TB AS B
      ON B.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS D
      ON D.CUID = A.CUID
		LEFT JOIN PJ_AD_PUBLISH_TB AS F
      ON F.ADID = A.ADID
     AND F.AD_KIND = ''U''
  WHERE 1 = 1 '+ @SQL_WHERE +')
  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY ADID DESC'


  --PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';


  --print @SQL
  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount









GO
/****** Object:  StoredProcedure [dbo].[GET_M_JOB_AD_INFO_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 ) 세금계산서: 광고정보 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_JOB_AD_INFO_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_JOB_AD_INFO_PROC]

  @ADID INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.USERID
        ,C.OPTION_MAIN_CD
        ,C.OPT_SUB_A
        ,C.OPT_SUB_B
        ,C.OPT_SUB_C
        ,C.OPT_SUB_D
        ,C.OPT_SUB_E
        ,A.REG_DT
        ,A.START_DT
        ,A.END_DT
        ,B.SERIAL
        ,B.PRNAMT
        ,B.CHARGE_KIND
        ,B.PRNAMTOK
        ,B.RECDATE
    FROM dbo.PJ_AD_USERREG_TB AS A
    JOIN dbo.PJ_RECCHARGE_TB AS B
      ON B.ADID = A.ADID
     AND B.AD_GBN = 1
    LEFT JOIN dbo.PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = 'U'
   WHERE A.ADID = @ADID






GO
/****** Object:  StoredProcedure [dbo].[GET_M_MAG_HISTORY_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 > 광고관리 히스토리 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/21
 *  수   정   자 : 신 장 순 (jssin@mediawill.com)
 *  수   정   일 : 2015.02.02
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_MAG_HISTORY_PROC 1143, 'U'

 SELECT * FROM FINDDB2.FINDCOMMON.dbo.CommonMagUser
 SELECT * FROM FINDDB2.FINDCOMMON.dbo.CommonMagUserSub WHERE MAGID = 'JSSIN'
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_MAG_HISTORY_PROC]

  @ADID INT
  ,@AD_KIND CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.REG_DT
        ,ISNULL(C.BRANCHCODE, 0) AS BRANCHCODE
        ,ISNULL(B.MAGNAME, '') AS MAGNAME
        ,A.COMMENT
        ,A.SEQ
    FROM JOB_MAG_HISTORY_TB AS A
    LEFT JOIN FINDDB2.FINDCOMMON.dbo.CommonMagUser AS B
           ON B.MAGID = A.MAG_ID
    LEFT JOIN FINDDB2.FINDCOMMON.dbo.CommonMagUserSub AS C
           ON C.MAGID = B.MAGID
          AND C.SECTIONCODE = 12
   WHERE A.ADID = @ADID
     AND A.AD_KIND = @AD_KIND
   ORDER BY A.REG_DT DESC



GO
/****** Object:  StoredProcedure [dbo].[GET_M_MAINBANNER_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 관리자 > 사이트관리 > 베너수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_MAINBANNER_DETAIL_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_MAINBANNER_DETAIL_PROC]

  @IDX           INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT LOCAL_CD
        ,BANNER_IMG
        ,BANNER_DETAIL_IMG
        ,BANNER_TYPE
        ,BANNER_URL
        ,BANNER_CNT_FLAG
        ,BANNER_DESC
        ,CONVERT(VARCHAR(10),START_DT,120) AS START_DT
        ,CONVERT(VARCHAR(10),END_DT,120) AS END_DT
        ,REG_DT
    FROM dbo.PJ_MAIN_BANNER_TB
   WHERE IDX = @IDX









GO
/****** Object:  StoredProcedure [dbo].[GET_M_MAINBANNER_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 관리자 > 사이트관리 > 베너수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_MAINBANNER_LIST_PROC 0
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_MAINBANNER_LIST_PROC]

  @LOCAL_CD           TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  IF @LOCAL_CD = 0
    BEGIN
      SELECT IDX
            ,LOCAL_CD
            ,BANNER_IMG
            ,BANNER_DETAIL_IMG
            ,BANNER_TYPE
            ,BANNER_URL
            ,BANNER_CNT_FLAG
            ,BANNER_DESC
            ,CONVERT(VARCHAR(10),START_DT,120) AS START_DT
            ,CONVERT(VARCHAR(10),END_DT,120) AS END_DT
            ,CONVERT(VARCHAR(10),REG_DT,120) AS REG_DT
        FROM dbo.PJ_MAIN_BANNER_TB
       ORDER BY IDX DESC
    END
  ELSE
    BEGIN
      SELECT IDX
            ,LOCAL_CD
            ,BANNER_IMG
            ,BANNER_DETAIL_IMG
            ,BANNER_TYPE
            ,BANNER_URL
            ,BANNER_CNT_FLAG
            ,BANNER_DESC
            ,CONVERT(VARCHAR(10),START_DT,120) AS START_DT
            ,CONVERT(VARCHAR(10),END_DT,120) AS END_DT
            ,CONVERT(VARCHAR(10),REG_DT,120) AS REG_DT
        FROM dbo.PJ_MAIN_BANNER_TB
       WHERE LOCAL_CD = @LOCAL_CD
       ORDER BY IDX DESC
    END








GO
/****** Object:  StoredProcedure [dbo].[GET_M_NOTICE_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 > 공지사항 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2012/07/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_NOTICE_DETAIL_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_NOTICE_DETAIL_PROC]

  @SERIAL INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT LOCALSITE
        ,MENUGBN
        ,TITLE
        ,CONTENTS
        ,MAINDISFLAG
        ,LOCALDISFLAG
        ,ISNULL(TARGETGBN,'') AS TARGETGBN
        ,OPTIONS
    FROM FINDDB2.FINDCOMMON.DBO.SITENEWS
   WHERE SERIAL = @SERIAL







GO
/****** Object:  StoredProcedure [dbo].[GET_M_NOTICE_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 야알바 관리자 > 공지사항 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2012/07/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_NOTICE_LIST_PROC '', '', '', '', '', 1, 15, 0
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_NOTICE_LIST_PROC]

  @MENUGBN CHAR(1)
  ,@MAINDISFLAG CHAR(1)
  ,@LOCALDISFLAG CHAR(1)
  ,@FIELD_NAME VARCHAR(15)
  ,@KEYWORD VARCHAR(30)
  ,@PAGE  INT = 1
  ,@PAGESIZE INT = 15
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
          ,@SQL_WHERE NVARCHAR(1000)
          ,@ParmDefinition   NVARCHAR(4000)
          ,@ListCount        INT

  SET @SQL = ''
  SET @SQL_WHERE = 'Sections = 12 AND DelFlag = 0 AND LocalSite = 0 '

  -- 게재형식
  IF @MENUGBN <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND MENUGBN = '+ @MENUGBN

  -- 메인게시여부
  IF @MAINDISFLAG <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND MAINDISFLAG = '+ @MAINDISFLAG

  -- 지역게재여부
  IF @LOCALDISFLAG <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND LOCALDISFLAG = '+ @LOCALDISFLAG

  -- 키워드
  IF @FIELD_NAME <> '' AND @KEYWORD <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @FIELD_NAME +' LIKE ''%'+ @KEYWORD +'%'''


  SET @SQL = '
  SELECT @ROWCOUNT = COUNT(*)
  FROM FINDDB2.FindCommon.dbo.SiteNews
  WHERE '+ @SQL_WHERE +';
  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY Serial DESC) AS ROWNUM
  ,Serial, LocalSite, MenuGbn, Title, MainDisFlag, LocalDisFlag, Options
  FROM FINDDB2.FindCommon.dbo.SiteNews
  WHERE '+ @SQL_WHERE +')
  SELECT *
  FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY Serial DESC'

  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  --PRINT @SQL

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount






GO
/****** Object:  StoredProcedure [dbo].[GET_M_NOTICE_MAIN_PREVIEW_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 야알바 관리자 > 공지사항 리스트 (프론트 노출 미리보기)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2012/07/05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_NOTICE_MAIN_PREVIEW_LIST_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_NOTICE_MAIN_PREVIEW_LIST_PROC]


AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT TOP 5 SERIAL
              ,SECTIONS
              ,MENUGBN
              ,LEFT(CONVERT(CHAR,REGDATE,120),10) AS REGDATE
              ,ISNULL(TARGETGBN,'') AS TARGETGBN
              ,OPTIONS
              ,TITLE
              ,CONTENTS
    FROM FINDDB2.FINDCOMMON.DBO.SITENEWS
   WHERE SECTIONS = 12
     AND LOCALSITE = 0
     AND DELFLAG = '0'
     AND MAINDISFLAG ='1'
   ORDER BY SERIAL DESC






GO
/****** Object:  StoredProcedure [dbo].[GET_M_PAPER_MANAGE_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
















/*************************************************************************************
 *  단위 업무 명 : 관리자 메인 > 광고관리 > 신문광고 관리 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/11/19
 *  수   정   자 : 장재웅
 *  수   정   일 : 2012.08.21.
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /admanage/PaperAdList.cshtml
 *  사 용  예 제 : EXECUTE DBO.GET_M_PAPER_MANAGE_LIST_PROC 1,20 ,'','2013-01-14','2013-01-14','','11','','','Y', 0
 *  사 용  예 제 : EXECUTE DBO.GET_M_PAPER_MANAGE_LIST_PROC 1,20 ,'','2013-01-14','2013-01-14','','11','','','', 0
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_PAPER_MANAGE_LIST_PROC]

  @PAGE            INT
  ,@PAGESIZE       INT
  ,@TARGET_DATE    CHAR(10)
  ,@START_DT       VARCHAR(10)
  ,@END_DT         VARCHAR(10)
  ,@LOCAL          CHAR(1)
  ,@BRANCH         CHAR(3)
  ,@SEARCH_FILED   VARCHAR(10)
  ,@SEARCH_KEYWORD VARCHAR(30)
  ,@CLOSE_YN 	   VARCHAR(1)
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@TODAY             VARCHAR(19)

	SET @SQL = ''
	SET @SQL_WHERE = ' 1=1 '

  -- 기간선택 : @DATE / @START_DT / @END_DT
  IF @TARGET_DATE <> ''
      SET @SQL_WHERE = @SQL_WHERE + ' AND CONVERT(VARCHAR(10), '+ @TARGET_DATE +', 120) BETWEEN '''+ @START_DT +''' AND '''+ @END_DT +''' '

  -- 옵션게제지역 : @LOCAL
  IF @LOCAL <> ''
    IF @LOCAL = '5'
      SET @SQL_WHERE = @SQL_WHERE + ' AND LOCALSITE IN (5,6) '
    ELSE
      SET @SQL_WHERE = @SQL_WHERE + ' AND LOCALSITE = '+ @LOCAL

  -- 등록지점 : @BRANCH
  IF @BRANCH <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND INPUTBRANCH = '+ @BRANCH

  -- 검색조건 : @SEARCH_FILED / @SEARCH_KEYWORD
  IF @SEARCH_FILED <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND '+ @SEARCH_FILED +' LIKE ''%'+ @SEARCH_KEYWORD +'%'' '

  -- 게재상태 : @CLOSE_YN
  IF @CLOSE_YN <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND END_YN = '''+ @CLOSE_YN +''''

  IF @CLOSE_YN = 'N'
    SET @SQL_WHERE = @SQL_WHERE + ' AND ENDDATE > GETDATE() '
    --SET @SQL_WHERE = @SQL_WHERE + ' AND END_YN = ''N'' '

  SET @SQL = 'SELECT @ROWCOUNT = COUNT(LINEADID)
                      FROM DAILY_JOBPAPER_TB
                     WHERE ' + @SQL_WHERE +';

  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY LINEADID DESC) AS ROWNUM
                    ,LINEADID
                    ,REGDATE
          			,STARTDATE
                    ,ISNULL(CONAME, USERNAME) AS CO_NAME
                    ,PHONE
                    ,LAYOUTBRANCH
                    ,CASE END_YN WHEN ''Y'' THEN ''마감''
                                 WHEN ''N'' THEN ''게재중''
                     END AS END_YN
                    ,ENDDATE
					, INPUTBRANCH
					, CONTENTS
					, CASE WHEN CODE = ''40100'' THEN ''[마담/종업원]''
						   WHEN CODE = ''40200'' THEN ''[단란주점]''
						   WHEN CODE = ''40300'' THEN ''[노래주점]''
						   WHEN CODE = ''40400'' THEN ''[다방]''
						   WHEN CODE = ''40500'' THEN ''[카페/Bar]''
						   WHEN CODE = ''40600'' THEN ''[서빙/웨이터]''
					  END CODENM
                FROM DAILY_JOBPAPER_TB
               WHERE '+ @SQL_WHERE +')

  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY LINEADID DESC'


  PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount










GO
/****** Object:  StoredProcedure [dbo].[GET_M_PAPERDETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











/*************************************************************************************
 *  단위 업무 명 : 관리자 > 광고관리 - 신문광고 내용가져오기 (수정폼)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/04/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /mag/admanage/PaperAdModify.asp
 *  사 용  예 제 : EXEC DBO.GET_M_PAPERDETAIL_PROC 1005555007
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_PAPERDETAIL_PROC]

  @LINEADID VARCHAR(50)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  SELECT ISNULL(CONAME, USERNAME) AS CONAME
        ,PHONE
        ,ISNULL(HPHONE,'--') AS HPHONE
        ,CODE
        ,METRO
        ,CITY
        ,DONG
        ,TITLE
        ,CONTENTS
    FROM DAILY_JOBPAPER_TB
   WHERE LINEADID = @LINEADID









GO
/****** Object:  StoredProcedure [dbo].[GET_M_RECCHARGE_SEMI_INFO_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 - 결제 정보 조회
 *  작   성   자 : 김성준
 *  작   성   일 : 2013/09/25
 *  수   정   자 :
 *  수   정   일 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_RECCHARGE_SEMI_INFO_PROC 10
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_RECCHARGE_SEMI_INFO_PROC]
(
  @SERIAL		INT
)
AS

SET NOCOUNT ON

	SELECT
		INIPAYTID
		, ADID
		, CHARGE_KIND
		, BANKNM
		, ACCOUNTNUM
		, PRNAMTOK
		, CANCELDATE
	FROM PJ_RECCHARGE_TB
	WHERE SERIAL = @SERIAL

SET NOCOUNT OFF














GO
/****** Object:  StoredProcedure [dbo].[GET_M_RECEIPT_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-COMM 관리 ) 현금영수증 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/01/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_RECEIPT_LIST_PROC
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_RECEIPT_LIST_PROC]

  @PAGE            INT
  ,@PAGESIZE       INT
  ,@strDTDIV       VARCHAR(1)   = ''                      -- 날짜구분
  ,@strStDate      VARCHAR(10)  = ''                      -- 날짜시작
  ,@strEnDate      VARCHAR(10)  = ''                      -- 날짜종료
  ,@strUseDiv      VARCHAR(1)   = ''                      -- 용도
  ,@strStateDIv    VARCHAR(1)   = ''                      -- 상태
  ,@strKey         CHAR(1)      =	''
  ,@strWord		     VARCHAR(100)	=	''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(3000)
  DECLARE @SQL_WHERE NVARCHAR(1000)

  SET @SQL = ''
  SET @SQL_COUNT = ''

  -- 용도
  IF @strUseDiv <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE+ ' AND R.UseOpt = ' + @strUseDiv
    END

  -- 상태
  IF @strStateDIv <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE+ ' AND R.Result = ' + @strStateDIv
    END

  -- 날짜상태
  IF @strDTDIV <> ''
    BEGIN
      IF @strDTDIV = '0'
        SET @SQL_WHERE = @SQL_WHERE+ ' AND (R.RegDate >= CONVERT(DATETIME, ''' + @strStDate + ''') AND R.RegDate <= CONVERT(DATETIME, ''' + @strEnDate + ' 23:59:59''))'
    END

  -- 검색
  IF @strWord <> ''
    BEGIN
      IF @strKey = ''
        SET @SQL_WHERE = @SQL_WHERE+' AND (R.Serial LIKE ''%'+@strWord+'%''
                                            OR R.GrpSerial LIKE ''%' + @strWord + '%''
                                            OR R.GoodName LIKE ''%' + @strWord + '%''
                                            OR R.BuyerName LIKE ''%'+@strWord+'%'')'
      ELSE IF  @strKey = '0'
        SET @SQL_WHERE = @SQL_WHERE+' AND C.LineAdid LIKE ''%'+@strWord+'%''  '
      ELSE IF  @strKey = '1'
        SET @SQL_WHERE = @SQL_WHERE+' AND R.GrpSerial LIKE ''%'+@strWord+'%''  '
      ELSE IF  @strKey = '2'
        SET @SQL_WHERE = @SQL_WHERE+' AND R.GoodName LIKE ''%'+@strWord+'%''  '
      ELSE IF  @strKey = '3'
        SET @SQL_WHERE = @SQL_WHERE+' AND R.BuyerName LIKE ''%'+@strWord+'%''  '
    END

  SET @SQL_COUNT = 'SELECT COUNT(*)
                      FROM PJ_RECEIPT_REQUEST_TB AS A
                      JOIN PJ_RECCHARGE_TB AS B
                        ON B.SERIAL = A.GRPSERIAL
                     WHERE 1 = 1 '+ @SQL_WHERE

  SET @SQL_COUNT = 'SELECT TOP '+ CONVERT(VARCHAR(10), @PAGE * @PAGESIZE) +'
                           B.ADID
                           B.AD_GBN
                          ,A.GOODNAME
                          ,A.CR_PRICE
                          ,A.SUP_PRICE
                          ,A.TAX
                          ,A.SRVC_PRICE
                          ,A.BUYERNAME
                          ,A.BUYEREAIL
                          ,A.BUYERTEL
                          ,A.REGNUM
                          ,A.USEOPT
                          ,A.TID
                          ,CONVERT(VARCHAR(10),A.REGDATE,120) AS REGDATE
                          ,A.RESULT
                          ,A.SERIAL
                      FROM PJ_RECEIPT_REQUEST_TB AS A
                      JOIN PJ_RECCHARGE_TB AS B
                        ON B.SERIAL = A.GRPSERIAL
                     WHERE 1 = 1 '+ @SQL_WHERE +'
                     ORDER BY A.REGDATE DESC'

  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL







GO
/****** Object:  StoredProcedure [dbo].[GET_M_TEL_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*************************************************************************************
 *  단위 업무 명 : 관리자 메인 > 비회원 광고 리스트
 *  작   성   자 : 최봉기 (cbk07@mediawill.com)
 *  작   성   일 : 2011/06/29
 *  수   정   자 : 장재웅
 *  수   정   일 : 2012.08.20
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : \NoMemberAd\TreatTelList
 *  사 용  예 제 : EXECUTE DBO.GET_M_TEL_LIST_PROC 2,15 ,'','','','','','','', 0
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_TEL_LIST_PROC]

	  @PAGE            			INT
	, @PAGESIZE       			INT
	, @TARGET_DATE    	CHAR(3)			-- 기간 SELECT BOX
	, @START_DT       		VARCHAR(10)	-- 기간시작일자
	, @END_DT         			VARCHAR(10)	-- 기간종료일자
	, @SEARCH_FILED 		VARCHAR(30)	-- 업소명/담당자명/연락처/제목 SELECT BOX
	, @LOCAL          			CHAR(1)			-- 우대게재지역 SELECT BOX
	, @OPTKIND        			CHAR(3)			-- 우대광고 전체 SELECT BOX
	, @SEARCH_KEYWORD 	VARCHAR(100)	-- 검색INPUT BOX
	, @TOTALROWS INT OUTPUT

AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@TODAY             VARCHAR(19)

	SET @SQL = ''
	SET @SQL_WHERE = ' 1=1 '


	-- 기간선택 : @DATE / @START_DT / @END_DT
	IF @TARGET_DATE <> ''
	  SET @SQL_WHERE = @SQL_WHERE + ' AND REG_DATE BETWEEN '''+ @START_DT +''' AND '''+ @END_DT +''' '

	-- 업소명/담당자명/연락처/제목 SELECT BOX
	IF @SEARCH_KEYWORD <> ''
		SET @SQL_WHERE = @SQL_WHERE + 'AND '+ @SEARCH_FILED +' LIKE ''%'+@SEARCH_KEYWORD +'%'' '

	-- 옵션유형(우대광고) : @OPTKIND
	IF @OPTKIND <> ''
    SET @SQL_WHERE = @SQL_WHERE + ' AND OPTION_MAIN_CD = '+ @OPTKIND +' '

  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
	FROM PJ_AGENT_AD_TEL_TB AS A
      JOIN CC_OPTION_PRICE_TB AS B
        ON B.OPTION_CD = A.OPTION_MAIN_CD
       AND B.OPT_TERM = A.OPTION_MAIN_TERM
       AND B.LOCAL_CD = A.LOCAL_CD
	WHERE '+ @SQL_WHERE +';
	WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.REG_DATE DESC) AS ROWNUM
		,A.SEQ
		,A.BIZ_NAME
		,A.HPHONE
		,A.PHONE
		,A.TITLE
		,B.OPTION_NAME
		,B.OPT_TERM_TEXT
		,B.OPT_PRICE
		,CONVERT(VARCHAR(10),A.REG_DATE,102) AS REG_DATE
		,A.STATUS
	FROM PJ_AGENT_AD_TEL_TB AS A
	  JOIN CC_OPTION_PRICE_TB AS B
		ON B.OPTION_CD = A.OPTION_MAIN_CD
	   AND B.OPT_TERM = A.OPTION_MAIN_TERM
	   AND B.LOCAL_CD = A.LOCAL_CD
	WHERE '+ @SQL_WHERE +')

  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY REG_DATE DESC'

  PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount











GO
/****** Object:  StoredProcedure [dbo].[GET_M_TEL_POPLIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 관리자 메인 > 전화등록대행 수정
 *  작   성   자 : 최봉기 (cbk07@mediawill.com)
 *  작   성   일 : 2011/06/29
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXECUTE DBO.GET_M_TEL_POPLIST_PROC 80
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_TEL_POPLIST_PROC]

	@SEQ INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	SELECT A.BIZ_NAME
        ,A.ORDER_NAME
        ,A.EMAIL
        ,A.HPHONE
        ,A.PHONE
        ,A.AREA_A
        ,A.AREA_B
        ,A.AREA_C
        ,A.AREA_DETAIL
        ,A.BIZ_CD
        ,A.THEME_CD
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.TITLE
        ,A.CONTENTS
        ,A.STATUS
        ,A.PAYOWNER
        ,A.BIZ_NUMBER
        ,B.OPTION_NAME
        ,B.OPT_TERM_TEXT
        ,B.OPT_PRICE
        ,A.LOCAL_CD
        ,A.RESULT
        ,A.OPT_SUB_A
        ,A.OPT_SUB_A_TERM
        ,A.OPT_SUB_B
        ,A.OPT_SUB_B_TERM
        ,A.OPT_SUB_C
        ,A.OPT_SUB_C_TERM
        ,A.OPT_SUB_D
        ,A.OPT_SUB_D_TERM
        ,A.OPT_SUB_E
        ,A.OPT_SUB_E_TERM
        ,A.GRAND_IMG
        ,A.OPTION_MAIN_TEMPLATE
        ,A.OPTION_MAIN_CD
        ,A.TOTAL_PRICE
	 FROM DBO.PJ_AGENT_AD_TEL_TB AS A
      LEFT JOIN CC_OPTION_PRICE_TB AS B
        ON B.OPTION_CD = A.OPTION_MAIN_CD
       AND B.OPT_TERM = A.OPTION_MAIN_TERM
       AND B.LOCAL_CD = A.LOCAL_CD
	WHERE SEQ = @SEQ

  SET NOCOUNT OFF








GO
/****** Object:  StoredProcedure [dbo].[GET_M_YAALBA_ONLINE_AD_VALUE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- GET_M_YAALBA_ONLINE_AD_VALUE_PROC '20160624103444185TWB58351', 0 


CREATE PROC [dbo].[GET_M_YAALBA_ONLINE_AD_VALUE_PROC]
   @TEMP_ADID  VARCHAR(25)
  ,@REAL_ADID  INT = 0
AS
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	SELECT ADID AS LINEADID
	FROM PJ_AD_AGENCY_TB
	WHERE TEMP_LINEADID = @TEMP_ADID
		OR ORG_LINEADID = @REAL_ADID



GO
/****** Object:  StoredProcedure [dbo].[GET_MOBILE_AD_SCRAP_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 모바일 스크랩 광고 > 스크랩 광고 리스트
 *  작   성   자 : 김성준 (sjkim9@mediawill.com)
 *  작   성   일 : 2013/05/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : \MyPage\AjaxScrapAD
 *  사 용  예 제 : EXECUTE DBO.GET_MOBILE_AD_SCRAP_LIST_PROC 1,10,'inliner9',0
 *************************************************************************************/
CREATE PROC [dbo].[GET_MOBILE_AD_SCRAP_LIST_PROC]

	  @PAGE            			INT
	, @PAGESIZE       			INT
	, @CUID						INT
	, @TOTALROWS INT OUTPUT

AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT
          ,@TODAY             VARCHAR(19)

	SET @SQL = ''
	SET @SQL_WHERE = ' 1=1 AND A.ISDELYN = ''N'' AND A.CUID=' + CAST(@CUID AS VARCHAR) + ' '

  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
			  FROM PJ_AD_SCRAP_TB AS A WITH(NOLOCK)
			  INNER JOIN PJ_AD_PUBLISH_TB AS B WITH(NOLOCK)
			  ON (A.ADID = B.ADID AND A.AD_KIND = B.AD_KIND)
			  WHERE '+ @SQL_WHERE +';
	WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.REGDATE DESC) AS ROWNUM
		, A.ADID
		, A.AD_KIND
		, B.BIZ_CD
		, B.PAY_CD
		, B.PAY_AMT
		, B.CO_NAME
		, B.TITLE
		, B.AREA_A
		, B.AREA_B
		, B.AREA_C
		, B.CONTENTS
		, B.PHONE
		, CONVERT(VARCHAR(16), A.REGDATE, 120) AS REGDATE
	FROM PJ_AD_SCRAP_TB AS A WITH(NOLOCK)
			  INNER JOIN PJ_AD_PUBLISH_TB AS B WITH(NOLOCK)
			  ON (A.ADID = B.ADID AND A.AD_KIND = B.AD_KIND)
	WHERE '+ @SQL_WHERE +')

  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY REGDATE DESC'

  PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount












GO
/****** Object:  StoredProcedure [dbo].[GET_MOBILE_AD_TODAY_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 모바일 > 광고페이지 내용가져오기
 *  작   성   자 : 장 재 웅 rainblue1(@mediawill.com)
 *  작   성   일 : 2013/04/29
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_MOBILE_AD_TODAY_DETAIL_PROC 27020, 'A'
 *************************************************************************************/


CREATE PROC [dbo].[GET_MOBILE_AD_TODAY_DETAIL_PROC]

  @ADID INT
  ,@AD_KIND CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.CO_NAME
        ,A.PHONE
        ,A.HPHONE
        ,A.BIZ_CD
        ,A.AREA_A
        ,A.AREA_B
        ,A.AREA_C
        ,A.AREA_DETAIL
        ,A.HOMEPAGE
        ,A.TITLE
        ,A.CONTENTS
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.MAP_X
        ,A.MAP_Y
        ,B.TEMPLATE_CD
        ,A.LOGO_IMG
        ,A.GRAND_IMG
    FROM PJ_AD_PUBLISH_TB AS A
      LEFT JOIN PJ_OPTION_TB AS B
        ON B.ADID = A.ADID
       AND B.AD_KIND = A.AD_KIND
   WHERE A.ADID = @ADID
     AND A.AD_KIND = @AD_KIND



GO
/****** Object:  StoredProcedure [dbo].[GET_MOBILE_AREA_CATEGORY_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 모바일 > 분류 > 지역카테고리 - 지역별 광고개수
 *  작   성   자 : 장 재 웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2013/04/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_MOBILE_AREA_CATEGORY_LIST_PROC '', '서울특별시'
 *************************************************************************************/


CREATE PROC [dbo].[GET_MOBILE_AREA_CATEGORY_LIST_PROC]

  @BIZ_CD VARCHAR(5) = ''
  ,@AREA_A VARCHAR(50) = ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_WHERE VARCHAR(500)
  SET @SQL = ''
  SET @SQL_WHERE = ''

  IF @BIZ_CD <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND A.BIZ_CD = '+ @BIZ_CD
    END

  IF @AREA_A = ''        -- 전지역
    BEGIN
      SET @SQL = 'SELECT COUNT(*) AS CNT
        FROM PJ_AD_PUBLISH_TB AS A
          JOIN PJ_OPTION_TB AS B
            ON B.ADID = A.ADID
           AND B.AD_KIND = A.AD_KIND
       WHERE A.AREA_A <> ''''
         '+ @SQL_WHERE +';
      SELECT AREA_A AS AREA_NM
            ,COUNT(*) AS CNT
            ,CASE AREA_A WHEN ''서울특별시'' THEN 1
                         WHEN ''경기도'' THEN 2
                         WHEN ''인천광역시'' THEN 3
                         WHEN ''부산광역시'' THEN 4
                         WHEN ''대구광역시'' THEN 5
                         WHEN ''광주광역시'' THEN 6
                         WHEN ''대전광역시'' THEN 7
                         WHEN ''울산광역시'' THEN 8
                         WHEN ''강원도'' THEN 9
                         WHEN ''경상북도'' THEN 10
                         WHEN ''경상남도'' THEN 11
                         WHEN ''전라북도'' THEN 12
                         WHEN ''전라남도'' THEN 13
                         WHEN ''충청북도'' THEN 14
                         WHEN ''충청남도'' THEN 15
                         WHEN ''제주도 '' THEN 16
                         WHEN ''기타'' THEN 17
                         ELSE 18
                END AS ORDER_NUM
        FROM PJ_AD_PUBLISH_TB AS A
          JOIN PJ_OPTION_TB AS B
            ON B.ADID = A.ADID
           AND B.AD_KIND = A.AD_KIND
       WHERE A.AREA_A <> ''''
         '+ @SQL_WHERE +'
       GROUP BY AREA_A
       ORDER BY ORDER_NUM ASC'

    END
  ELSE
    BEGIN
      SET @SQL = 'SELECT COUNT(*) AS CNT
        FROM PJ_AD_PUBLISH_TB AS A
          JOIN PJ_OPTION_TB AS B
            ON B.ADID = A.ADID
           AND B.AD_KIND = A.AD_KIND
       WHERE A.AREA_A = '''+ @AREA_A +'''
         AND A.AREA_B <> ''''
         '+ @SQL_WHERE +';
      SELECT AREA_B AS AREA_NM
            ,COUNT(*) AS CNT
        FROM PJ_AD_PUBLISH_TB AS A
          JOIN PJ_OPTION_TB AS B
            ON B.ADID = A.ADID
           AND B.AD_KIND = A.AD_KIND
       WHERE A.AREA_A = '''+ @AREA_A +'''
         AND A.AREA_B <> ''''
         '+ @SQL_WHERE +'
        GROUP BY A.AREA_B
        ORDER BY AREA_B ASC'

    END

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL










GO
/****** Object:  StoredProcedure [dbo].[GET_MOBILE_MAIN_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 모바일 > 메인 광고 리스트
 *  작   성   자 : 장 재 웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2013/04/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_MOBILE_MAIN_AD_LIST_PROC 1, 15, 20
 *************************************************************************************/


CREATE PROC [dbo].[GET_MOBILE_MAIN_AD_LIST_PROC]

   @PAGE INT
  ,@PAGESIZE INT = 15
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT

    SET @SQL = ''
	SET @SQL_WHERE = ' 1=1 AND A.START_DT >= CONVERT(VARCHAR(10), DATEADD(d, -5, GETDATE()), 120)'

  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
	FROM PJ_AD_PUBLISH_TB AS A
	JOIN PJ_OPTION_TB AS B
	ON B.ADID = A.ADID
	AND B.AD_KIND = A.AD_KIND
	WHERE '+ @SQL_WHERE +';

	WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.START_DT DESC, A.ADID ASC) AS ROWNUM
		,A.ADID
		,A.AD_KIND
		,A.BIZ_CD
		,A.CO_NAME
		,A.PHONE
		,A.HPHONE
		,A.AREA_A
		,A.AREA_B
		,A.AREA_C
		,A.AREA_DETAIL
		,A.TITLE
		,A.CONTENTS
		,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
		,B.OPT_SUB_A
		,CONVERT(VARCHAR(10),B.OPT_SUB_A_START_DT,120) AS OPT_SUB_A_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_A_END_DT,120) AS OPT_SUB_A_END_DT
		,B.OPT_SUB_B
		,CONVERT(VARCHAR(10),B.OPT_SUB_B_START_DT,120) AS OPT_SUB_B_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_B_END_DT,120) AS OPT_SUB_B_END_DT
		,B.OPT_SUB_C
		,CONVERT(VARCHAR(10),B.OPT_SUB_C_START_DT,120) AS OPT_SUB_C_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_C_END_DT,120) AS OPT_SUB_C_END_DT
		,B.OPT_SUB_D
		,CONVERT(VARCHAR(10),B.OPT_SUB_D_START_DT,120) AS OPT_SUB_D_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_D_END_DT,120) AS OPT_SUB_D_END_DT
		,B.OPT_SUB_E
		,CONVERT(VARCHAR(10),B.OPT_SUB_E_START_DT,120) AS OPT_SUB_E_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_E_END_DT,120) AS OPT_SUB_E_END_DT
		,A.PAY_CD
		,A.PAY_AMT
	FROM PJ_AD_PUBLISH_TB AS A
	  JOIN PJ_OPTION_TB AS B
		ON B.ADID = A.ADID
	   AND B.AD_KIND = A.AD_KIND
	WHERE '+ @SQL_WHERE +')

	SELECT * FROM RESULT_TABLE
	WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
	AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
	ORDER BY ROWNUM ASC'
	--ORDER BY START_DT DESC, ADID ASC'

  PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount













GO
/****** Object:  StoredProcedure [dbo].[GET_MOBILE_OPTION_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 모바일 > 분류 > 조건 검색 광고 리스트
 *  작   성   자 : 장 재 웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2013/04/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_MOBILE_OPTION_AD_LIST_PROC 1, 15, '40100', '서울특별시', '', 20
 EXEC DBO.GET_MOBILE_OPTION_AD_LIST_PROC 1, 15, '', '서울특별시', '강남구', 20
 EXEC DBO.GET_MOBILE_OPTION_AD_LIST_PROC 1, 15, '40100', '', '', 20
 EXEC DBO.GET_MOBILE_OPTION_AD_LIST_PROC 1, 15, '40300', '부산광역시', '', 20
 EXEC DBO.GET_MOBILE_OPTION_AD_LIST_PROC 1, 15, '40200', '서울특별시', '송파구', 20
 *************************************************************************************/


CREATE PROC [dbo].[GET_MOBILE_OPTION_AD_LIST_PROC]

   @PAGE INT
  ,@PAGESIZE INT = 15
  ,@BIZ_CD VARCHAR(5) = ''
  ,@AREA_A VARCHAR(50) = ''
  ,@AREA_B VARCHAR(50) = ''
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT

    SET @SQL = ''
	SET @SQL_WHERE = ' 1=1 '

	IF @BIZ_CD <> ''
		BEGIN
		  SET @SQL_WHERE = @SQL_WHERE +' AND A.BIZ_CD = '+ @BIZ_CD
		END

	IF @AREA_A <> ''
		BEGIN
		  SET @SQL_WHERE = @SQL_WHERE +' AND A.AREA_A = '''+ @AREA_A +''' '
		END

	IF @AREA_B <> ''
		BEGIN
		  SET @SQL_WHERE = @SQL_WHERE +' AND A.AREA_B = '''+ @AREA_B +''' '
		END

  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
	FROM PJ_AD_PUBLISH_TB AS A
	JOIN PJ_OPTION_TB AS B
	ON B.ADID = A.ADID
	AND B.AD_KIND = A.AD_KIND
	WHERE '+ @SQL_WHERE +';

	WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.START_DT DESC, A.ADID ASC) AS ROWNUM
		,A.ADID
		,A.AD_KIND
		,A.BIZ_CD
		,A.CO_NAME
		,A.PHONE
		,A.HPHONE
		,A.AREA_A
		,A.AREA_B
		,A.AREA_C
		,A.AREA_DETAIL
		,A.TITLE
		,A.CONTENTS
		,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
		,B.OPT_SUB_A
		,CONVERT(VARCHAR(10),B.OPT_SUB_A_START_DT,120) AS OPT_SUB_A_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_A_END_DT,120) AS OPT_SUB_A_END_DT
		,B.OPT_SUB_B
		,CONVERT(VARCHAR(10),B.OPT_SUB_B_START_DT,120) AS OPT_SUB_B_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_B_END_DT,120) AS OPT_SUB_B_END_DT
		,B.OPT_SUB_C
		,CONVERT(VARCHAR(10),B.OPT_SUB_C_START_DT,120) AS OPT_SUB_C_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_C_END_DT,120) AS OPT_SUB_C_END_DT
		,B.OPT_SUB_D
		,CONVERT(VARCHAR(10),B.OPT_SUB_D_START_DT,120) AS OPT_SUB_D_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_D_END_DT,120) AS OPT_SUB_D_END_DT
		,B.OPT_SUB_E
		,CONVERT(VARCHAR(10),B.OPT_SUB_E_START_DT,120) AS OPT_SUB_E_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_E_END_DT,120) AS OPT_SUB_E_END_DT
		,A.PAY_CD
		,A.PAY_AMT
	FROM PJ_AD_PUBLISH_TB AS A
	  JOIN PJ_OPTION_TB AS B
		ON B.ADID = A.ADID
	   AND B.AD_KIND = A.AD_KIND
	WHERE '+ @SQL_WHERE +')

	SELECT * FROM RESULT_TABLE
	WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
	AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
	ORDER BY ROWNUM ASC'
	--ORDER BY START_DT DESC, ADID ASC'

  PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount













GO
/****** Object:  StoredProcedure [dbo].[GET_MOBILE_SUB_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 모바일 > 분류 > 광고 리스트
 *  작   성   자 : 장 재 웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2013/04/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_MOBILE_SUB_AD_LIST_PROC 1, 15, '40100', '', '', 20
 EXEC DBO.GET_MOBILE_SUB_AD_LIST_PROC 1, 15, '40100', '서울특별시', '', 20
 EXEC DBO.GET_MOBILE_SUB_AD_LIST_PROC 1, 15, '40100', '부산광역시', '금정구', 20
 EXEC DBO.GET_MOBILE_SUB_AD_LIST_PROC 1, 15, '', '부산광역시', '', 20
 EXEC DBO.GET_MOBILE_SUB_AD_LIST_PROC 1, 15, '', '부산광역시', '금정구', 20
 *************************************************************************************/


CREATE PROC [dbo].[GET_MOBILE_SUB_AD_LIST_PROC]

   @PAGE INT
  ,@PAGESIZE INT = 15
  ,@BIZ_CD VARCHAR(5) = ''
  ,@AREA_A VARCHAR(50) = ''
  ,@AREA_B VARCHAR(50) = ''
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@SQL_WHERE         NVARCHAR(1000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT

    SET @SQL = ''
	SET @SQL_WHERE = ' 1=1 '

	IF @BIZ_CD <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND A.BIZ_CD = '+ @BIZ_CD
    END

  IF @AREA_A <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND A.AREA_A = '''+ @AREA_A +''' '
    END

  IF @AREA_B <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE +' AND A.AREA_B = '''+ @AREA_B +''' '
    END

  SET @SQL = 'SELECT @ROWCOUNT = COUNT(*)
	FROM PJ_AD_PUBLISH_TB AS A
	JOIN PJ_OPTION_TB AS B
	ON B.ADID = A.ADID
	AND B.AD_KIND = A.AD_KIND
	WHERE '+ @SQL_WHERE +';

	WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.START_DT DESC, A.ADID ASC) AS ROWNUM
		,A.ADID
		,A.AD_KIND
		,A.BIZ_CD
		,A.CO_NAME
		,A.PHONE
		,A.HPHONE
		,A.AREA_A
		,A.AREA_B
		,A.AREA_C
		,A.AREA_DETAIL
		,A.TITLE
		,A.CONTENTS
		,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
		,B.OPT_SUB_A
		,CONVERT(VARCHAR(10),B.OPT_SUB_A_START_DT,120) AS OPT_SUB_A_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_A_END_DT,120) AS OPT_SUB_A_END_DT
		,B.OPT_SUB_B
		,CONVERT(VARCHAR(10),B.OPT_SUB_B_START_DT,120) AS OPT_SUB_B_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_B_END_DT,120) AS OPT_SUB_B_END_DT
		,B.OPT_SUB_C
		,CONVERT(VARCHAR(10),B.OPT_SUB_C_START_DT,120) AS OPT_SUB_C_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_C_END_DT,120) AS OPT_SUB_C_END_DT
		,B.OPT_SUB_D
		,CONVERT(VARCHAR(10),B.OPT_SUB_D_START_DT,120) AS OPT_SUB_D_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_D_END_DT,120) AS OPT_SUB_D_END_DT
		,B.OPT_SUB_E
		,CONVERT(VARCHAR(10),B.OPT_SUB_E_START_DT,120) AS OPT_SUB_E_START_DT
		,CONVERT(VARCHAR(10),B.OPT_SUB_E_END_DT,120) AS OPT_SUB_E_END_DT
		,A.PAY_CD
		,A.PAY_AMT
	FROM PJ_AD_PUBLISH_TB AS A
	  JOIN PJ_OPTION_TB AS B
		ON B.ADID = A.ADID
	   AND B.AD_KIND = A.AD_KIND
	WHERE '+ @SQL_WHERE +')

	SELECT * FROM RESULT_TABLE
	WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
	AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
	ORDER BY ROWNUM ASC'
	--ORDER BY START_DT DESC, ADID ASC'

  PRINT @SQL
  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount













GO
/****** Object:  StoredProcedure [dbo].[GET_MOBLIE_BIZCD_CATEGORY_LIST_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 모바일 > 분류 > 직종별 - 직종별 광고개수
 *  작   성   자 : 장 재 웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2013/04/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_MOBLIE_BIZCD_CATEGORY_LIST_PROC '40300', '서울특별시', '강남구'
 *************************************************************************************/


CREATE PROC [dbo].[GET_MOBLIE_BIZCD_CATEGORY_LIST_PROC]

  @BIZ_CD VARCHAR(5) = ''
  ,@AREA_A VARCHAR(50) = ''
  ,@AREA_B VARCHAR(50) = ''
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_WHERE VARCHAR(500)
  DECLARE @SQL_AREA_WHERE VARCHAR(500)
  SET @SQL = ''
  SET @SQL_WHERE = ' 1=1 '
  SET @SQL_AREA_WHERE = ''



	IF @BIZ_CD <> ''
	BEGIN
	  SET @SQL_WHERE = @SQL_WHERE +' AND A.BIZ_CD = '+ @BIZ_CD
	END

	IF @AREA_A <> ''
	BEGIN
	  SET @SQL_AREA_WHERE = @SQL_AREA_WHERE +' AND A.AREA_A = '''+ @AREA_A +''''
	END
	IF @AREA_B <> ''
	BEGIN
	  SET @SQL_AREA_WHERE = @SQL_AREA_WHERE +' AND A.AREA_B = '''+ @AREA_B +''''
	END


	  SET @SQL = '	SELECT COUNT(*) AS CNT
					FROM PJ_AD_PUBLISH_TB AS A
					JOIN PJ_OPTION_TB AS B
					ON B.ADID = A.ADID
					AND B.AD_KIND = A.AD_KIND
					WHERE '+ @SQL_WHERE + @SQL_AREA_WHERE + ';
					SELECT A.BIZ_CD
					,COUNT(*) AS CNT
					,CASE A.BIZ_CD WHEN 40100 THEN ''마담/종업원''
						 WHEN 40200 THEN ''단란주점''
						 WHEN 40300 THEN ''노래주점''
						 WHEN 40400 THEN ''다방''
						 WHEN 40500 THEN ''카페/Bar''
						 WHEN 40600 THEN ''서빙/웨이터''
					END AS ORDER_NUM
					FROM PJ_AD_PUBLISH_TB AS A
					  JOIN PJ_OPTION_TB AS B
						ON B.ADID = A.ADID
					   AND B.AD_KIND = A.AD_KIND
					WHERE A.BIZ_CD <> ''''

					GROUP BY A.BIZ_CD
					ORDER BY ORDER_NUM ASC'



  PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL




GO
/****** Object:  StoredProcedure [dbo].[GET_MOBLIE_SCRAP_AD_CNT_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 모바일 > 스크랩 광고 조회
 *  작   성   자 : 김 성 준 (sjkim9@mediawill.com)
 *  작   성   일 : 2013/04/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_MOBLIE_SCRAP_AD_CNT_PROC 'inliner9', 1048
 *************************************************************************************/
CREATE PROC [dbo].[GET_MOBLIE_SCRAP_AD_CNT_PROC]

  @CUID INT
  ,@ADID INT
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	SELECT COUNT(ADID) AS SCRAP_CNT
	FROM dbo.PJ_AD_SCRAP_TB
	WHERE CUID = @CUID AND ADID = @ADID






GO
/****** Object:  StoredProcedure [dbo].[GET_MOBLIE_SCRAP_AD_TOT_CNT_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 모바일 > 스크랩 광고 전체 수 조회
 *  작   성   자 : 김 성 준 (sjkim9@mediawill.com)
 *  작   성   일 : 2013/05/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : \MyPage\ScrapAD
 *  사 용  예 제 : EXEC DBO.GET_MOBLIE_SCRAP_AD_TOT_CNT_PROC 'inliner9'
 *************************************************************************************/
CREATE PROC [dbo].[GET_MOBLIE_SCRAP_AD_TOT_CNT_PROC]

  @CUID INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	SELECT COUNT(ADID) AS SCRAP_CNT
	FROM dbo.PJ_AD_SCRAP_TB
	WHERE CUID = @CUID






GO
/****** Object:  StoredProcedure [dbo].[GET_PJ_RECCHARGE_TB_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 야알바 광고 게재처리전 결제상태 체크
 *  작   성   자 : 김성준
 *  작   성   일 : 2013/07/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_PJ_RECCHARGE_TB_PROC 2179
 *************************************************************************************/

CREATE PROC [dbo].[GET_PJ_RECCHARGE_TB_PROC]

@ADID INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT CHARGE_KIND, --결제종류 (1: 가상계좌입금, 2:신용카드)
	PRNAMTOK --결제상태 (0: 미결제, 1:결제완료, 2:결제취소)
  FROM DBO.PJ_RECCHARGE_TB
  WHERE ADID = @ADID










GO
/****** Object:  StoredProcedure [dbo].[GET_SINGLEVIEW_YAALBA_AD_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*************************************************************************************
 *  단위 업무 명 : YaAlba Ecommon 광고리스트(결제완료)
 *  작   성   자 : 최 승 범 (dandybum@mediawill.com)
 *  작   성   일 : 2016/07/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_SINGLEVIEW_YAALBA_AD_PROC 2131, 1, 20, 0
 *************************************************************************************/


CREATE PROC [dbo].[GET_SINGLEVIEW_YAALBA_AD_PROC]

  @CUID INT
  ,@PAGE  INT
  ,@PAGESIZE  INT
  ,@TOTALROWS INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL                NVARCHAR(4000)
          ,@ParmDefinition    NVARCHAR(4000)
          ,@ListCount         INT

  SET @SQL = ''

  -- // 쿼리: 카운트
  SET @SQL = '
  SELECT @ROWCOUNT = COUNT(*)
    FROM PJ_AD_USERREG_TB AS A
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS B
      ON B.CUID = A.CUID
    JOIN PJ_RECCHARGE_TB AS D
      ON D.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
  WHERE A.CUID = ' + CAST(@CUID AS VARCHAR) + ' AND D.PRNAMTOK = 1 ;
  WITH RESULT_TABLE AS (SELECT ROW_NUMBER() OVER (ORDER BY A.ADID DESC) AS ROWNUM
    ,A.ADID
    ,D.RECDATE
    ,(CASE WHEN C.OPTION_MAIN_CD = 1 THEN ''프리미엄플러스''
		   WHEN C.OPTION_MAIN_CD = 2 THEN ''프리미엄박스''
		   WHEN C.OPTION_MAIN_CD = 4 THEN ''프리미엄리스트''
		   WHEN C.OPTION_MAIN_CD = 8 THEN ''스피드박스''
		   WHEN C.OPTION_MAIN_CD = 16 THEN ''스피드리스트''
		   WHEN C.OPTION_MAIN_CD = 32 THEN ''그랜드''
		   ELSE ''일반''
	 END) AS OPTION_MAIN
    ,CONVERT(VARCHAR(10),A.START_DT,120) AS START_DT
    ,CONVERT(VARCHAR(10),A.END_DT,120) AS END_DT
    ,D.PRNAMT
  FROM PJ_AD_USERREG_TB AS A
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS B
      ON B.CUID = A.CUID
    JOIN PJ_RECCHARGE_TB AS D
      ON D.ADID = A.ADID
    JOIN PJ_OPTION_TB AS C
      ON C.ADID = A.ADID
     AND C.AD_KIND = ''U''
  WHERE A.CUID = ' + CAST(@CUID AS VARCHAR) + ' AND D.PRNAMTOK = 1 )
  SELECT * FROM RESULT_TABLE
  WHERE ROWNUM BETWEEN '+ CAST((@PAGE-1)*@PAGESIZE+1 AS VARCHAR(10)) +'
  AND '+ CAST(@PAGE*@PAGESIZE AS VARCHAR(10)) +'
  ORDER BY ADID DESC'

  SET @ParmDefinition = '@ROWCOUNT INT OUTPUT';

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL
                       ,@ParmDefinition
                       ,@ROWCOUNT = @ListCount OUTPUT

  SET @TOTALROWS = @ListCount














GO
/****** Object:  StoredProcedure [dbo].[GET_WILLIANT_YAALBA_CALLBACK_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 윌리언트 콜백 처리
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/04/25
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_WILLIANT_YAALBA_CALLBACK_PROC 1020000240
*************************************************************************************/
create PROC [dbo].[GET_WILLIANT_YAALBA_CALLBACK_PROC]
	 @TempAdId			VARCHAR(20)
	,@EVENT_CODE		VARCHAR(10) = ''
	,@RecAdid				VARCHAR(20) = ''
	,@adid_ppad			INT
AS

  SET NOCOUNT ON
--SELECT '1' AS A
--return
	/* mw번호 업데이트 ,접수 완료 */
	IF @EVENT_CODE = '600' BEGIN
		EXEC FINDDB1.PAPER_NEW.dbo.MOD_WILLS_RELATION_TB_PROC @TempAdId, @adid_ppad, @RecAdid
		UPDATE A
		SET MWPLUS_LINEADID = @RecAdid
		FROM PJ_AD_AGENCY_TB A
		WHERE ADID = @adid_ppad
	END

	/*게재처리 */
	IF @EVENT_CODE = '300' BEGIN
		UPDATE A
		SET M_STATUS = 'W'
		FROM PJ_AD_AGENCY_TB A
		WHERE ADID = @adid_ppad
	END

	--일반 매물

	EXEC GET_WILLIANT_YAALBA_DETAIL_PROC @adid_ppad, @TempAdId

--로그처리
INSERT WILLIANT_YAALBA_CALLBACK_LOG_TB (
TempAdId
,EVENT_CODE
,RecAdid
,ETC_INFO
,RegDate
)
select  @TempAdId
,@EVENT_CODE
,@RecAdid
,''
,GETDATE()
GO
/****** Object:  StoredProcedure [dbo].[GET_WILLIANT_YAALBA_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 윌리언트 수급완료 시 상세항목 전송
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/04/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_WILLIANT_YAALBA_DETAIL_PROC 52727
 *************************************************************************************/
create PROC [dbo].[GET_WILLIANT_YAALBA_DETAIL_PROC]
	 @ADID					INT
	,@TempAdId			VARCHAR(20)
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	/*
	AdId : 111310561
	InputBranch : 80
	TempAdId : 
	*/
  SELECT
				 A.ADID AS OnlineAdId 
				--A.ADID AS ADID_PPAD
				--,A.MAG_BRANCHCODE AS InputBranch
				--,@TempAdId AS TempAdId
				,A.CO_NAME
        --,A.PHONE
        ,A.HPHONE
				,(A.PHONE + ',' + A.HPHONE) AS PhoneText
        ,A.BIZ_CD
        ,A.AREA_A
        ,A.AREA_B
        ,A.AREA_C
        ,A.AREA_DETAIL
        ,A.HOMEPAGE
        ,A.TITLE
        --,A.CONTENTS
        ,A.THEME_CD
        ,A.PAY_CD
        ,A.PAY_AMT
        ,A.BIZ_NUMBER
        ,A.LOGO_IMG
        ,A.START_DT AS StartDate
        ,A.END_DT AS EndDate
        ,A.MWPLUS_LINEADID
        ,A.MWPLUS_OPTION
        ,A.AD_KIND
        ,A.REG_DT
        ,A.AMOUNT_ONLINE AS Amount
        ,A.AMOUNT_MWPLUS
        ,A.REG_KIND
        ,A.LOCAL_CD
        ,A.OPTION_MAIN_CD
        ,A.TEMPLATE_CD
        ,A.OPT_SUB_A
        ,A.OPT_SUB_A_START_DT
        ,A.OPT_SUB_A_END_DT
        ,A.OPT_SUB_B
        ,A.OPT_SUB_B_START_DT
        ,A.OPT_SUB_B_END_DT
        ,A.OPT_SUB_C
        ,A.OPT_SUB_C_START_DT
        ,A.OPT_SUB_C_END_DT
        ,A.OPT_SUB_D
        ,A.OPT_SUB_D_START_DT
        ,A.OPT_SUB_D_END_DT
        ,A.OPT_SUB_E
        ,A.OPT_SUB_E_START_DT
        ,A.OPT_SUB_E_END_DT
        ,A.MAG_BRANCHCODE
        ,A.MAGID
        ,A.MAGNAME
        ,A.REASON
        ,A.GRAND_IMG
        ,A.MAP_X
        ,A.MAP_Y
				,A.CONFIRM_YN
				,A.PAUSE_YN
				,A.END_YN
				,ISNULL(F.ADID, '') AS PUB_ADID
	FROM PJ_AGENCY_AD_LIST_VI A
		LEFT JOIN PJ_AD_PUBLISH_TB AS F ON F.ADID = A.ADID
	WHERE A.ADID = @ADID
GO
/****** Object:  StoredProcedure [dbo].[GOALBA_NAME_EXISTS_FUNC_CHECK_SBCHOI]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/*************************************************************************************
 *  단위 업무 명 : 금지어 포함 여부 (인덱스 체크용 테스트 확인 함수)
 *  작   성   자 : 최승범
 *  작   성   일 : 2017.03.07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 
 *  사 용  소 스 :
 *  사 용  예 제 :
 EXEC [dbo].[GOALBA_NAME_EXISTS_FUNC_CHECK_SBCHOI] '노래도우미 급 00명 25-45세 평일,주말알바환영 콜많고 분위기짱~ 출,퇴근지원 만근수당지급 각종편의제공 서구지역「탬버린(허352)」 탬버린(허352)'
 *************************************************************************************/
CREATE PROC [dbo].[GOALBA_NAME_EXISTS_FUNC_CHECK_SBCHOI]
(
	@ADID			INT
)
AS
BEGIN
	DECLARE @CONTENT	VARCHAR(MAX)
	DECLARE @BAD_CONTENT	VARCHAR(MAX)
	DECLARE @RETURNCODE	INT
	
	SET @BAD_CONTENT = ''

	DECLARE @COL_TEXT VARCHAR(MAX)
	
	SELECT @CONTENT = CONTENTS
	FROM PJ_AD_USERREG_TB
	WHERE ADID = @ADID
	
	SET @COL_TEXT = @CONTENT

	SET @RETURNCODE = 0
	SET @RETURNCODE = CHARINDEX('피부관리' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = '피부관리'
		END
	SET @RETURNCODE = CHARINDEX('이미지모델' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 이미지모델'
		END
	SET @RETURNCODE = CHARINDEX('극강하드' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 극강하드'
		END
	SET @RETURNCODE = CHARINDEX('북창동스타일' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 북창동스타일'
		END
	SET @RETURNCODE = CHARINDEX('휴게텔' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 휴게텔'
		END
	SET @RETURNCODE = CHARINDEX('이미지클럽' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 이미지클럽'
		END
	SET @RETURNCODE = CHARINDEX('신고식' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 신고식'
		END
	SET @RETURNCODE = CHARINDEX('풀싸롱2부' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 풀싸롱2부'
		END
	SET @RETURNCODE = CHARINDEX('키스방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 키스방'
		END
	SET @RETURNCODE = CHARINDEX('홈런' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 홈런'
		END
	SET @RETURNCODE = CHARINDEX('풀코스2차' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 풀코스2차'
		END
	SET @RETURNCODE = CHARINDEX('페티쉬클럽' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 페티쉬클럽'
		END
	SET @RETURNCODE = CHARINDEX('하드업소' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 하드업소'
		END
	SET @RETURNCODE = CHARINDEX('하드코어' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 하드코어'
		END
	SET @RETURNCODE = CHARINDEX('마사지' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 마사지'
		END
	SET @RETURNCODE = CHARINDEX('구미식' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 구미식'
		END
	SET @RETURNCODE = CHARINDEX('북창동식' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 북창동식'
		END
	SET @RETURNCODE = CHARINDEX('럭셔리샵' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 럭셔리샵'
		END
	SET @RETURNCODE = CHARINDEX('외국DVD방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 외국DVD방'
		END
	SET @RETURNCODE = CHARINDEX('해외' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 해외'
		END
	SET @RETURNCODE = CHARINDEX('풀사롱' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 풀사롱'
		END
	SET @RETURNCODE = CHARINDEX('스킨케어' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 스킨케어'
		END
	SET @RETURNCODE = CHARINDEX('립서비스' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 립서비스'
		END
	SET @RETURNCODE = CHARINDEX('대화방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 대화방'
		END
	SET @RETURNCODE = CHARINDEX('전투' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 전투'
		END
	SET @RETURNCODE = CHARINDEX('안마' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 안마'
		END
	SET @RETURNCODE = CHARINDEX('북창동' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 북창동'
		END
	SET @RETURNCODE = CHARINDEX('풀서비스' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 풀서비스'
		END
	SET @RETURNCODE = CHARINDEX('구장' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 구장'
		END
	SET @RETURNCODE = CHARINDEX('마이킹' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 마이킹'
		END
	SET @RETURNCODE = CHARINDEX('보도방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 보도방'
		END
	SET @RETURNCODE = CHARINDEX('보도' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 보도'
		END
	SET @RETURNCODE = CHARINDEX('룸보도' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 룸보도'
		END
	SET @RETURNCODE = CHARINDEX('노래방보도' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 노래방보도'
		END
	SET @RETURNCODE = CHARINDEX('쭉쭉빵빵' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 쭉쭉빵빵'
		END
	SET @RETURNCODE = CHARINDEX('못생겨도됨' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 못생겨도됨'
		END
	SET @RETURNCODE = CHARINDEX('매력적인여성' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 매력적인여성'
		END
	SET @RETURNCODE = CHARINDEX('12개월내내대박' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 12개월내내대박'
		END
	SET @RETURNCODE = CHARINDEX('12개월계속' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 12개월계속'
		END
	SET @RETURNCODE = CHARINDEX('이미지방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 이미지방'
		END
	SET @RETURNCODE = CHARINDEX('비밀보장' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 비밀보장'
		END
	SET @RETURNCODE = CHARINDEX('애프터' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 애프터'
		END
	SET @RETURNCODE = CHARINDEX('에프터' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 에프터'
		END
	SET @RETURNCODE = CHARINDEX('단속걱정 NO' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 단속걱정 NO'
		END
	SET @RETURNCODE = CHARINDEX('단속걱정NO' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 단속걱정NO'
		END
	SET @RETURNCODE = CHARINDEX('접대부' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 접대부'
		END
	SET @RETURNCODE = CHARINDEX('해외업소' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 해외업소'
		END
	SET @RETURNCODE = CHARINDEX('오피스마사지' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 오피스마사지'
		END
	SET @RETURNCODE = CHARINDEX('오피스' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 오피스'
		END
	SET @RETURNCODE = CHARINDEX('오피스텔' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 오피스텔'
		END
	SET @RETURNCODE = CHARINDEX('풀살롱' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 풀살롱'
		END
	SET @RETURNCODE = CHARINDEX('소프트' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 소프트'
		END
	SET @RETURNCODE = CHARINDEX('온천장' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 온천장'
		END
	SET @RETURNCODE = CHARINDEX('맛사지' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 맛사지'
		END
	SET @RETURNCODE = CHARINDEX('오픈업소' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 오픈업소'
		END
	SET @RETURNCODE = CHARINDEX('풀싸롱' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 풀싸롱'
		END
	SET @RETURNCODE = CHARINDEX('2부' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 2부'
		END
	SET @RETURNCODE = CHARINDEX('보도' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 보도'
		END
	SET @RETURNCODE = CHARINDEX('보도방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 보도방'
		END
	SET @RETURNCODE = CHARINDEX('교포' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 교포'
		END
	SET @RETURNCODE = CHARINDEX('2차' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 2차'
		END
	SET @RETURNCODE = CHARINDEX('단속' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 단속'
		END
	SET @RETURNCODE = CHARINDEX('아빠방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 아빠방'
		END
	SET @RETURNCODE = CHARINDEX('단속 없는' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 단속 없는'
		END
	SET @RETURNCODE = CHARINDEX('단속없는' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 단속없는'
		END
	SET @RETURNCODE = CHARINDEX('안전한' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 안전한'
		END
	SET @RETURNCODE = CHARINDEX('파장동식' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 파장동식'
		END
	SET @RETURNCODE = CHARINDEX('K방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' K방'
		END
	SET @RETURNCODE = CHARINDEX('L방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' L방'
		END
	SET @RETURNCODE = CHARINDEX('k방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' k방'
		END
	SET @RETURNCODE = CHARINDEX('l방' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' l방'
		END
	SET @RETURNCODE = CHARINDEX('시급' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시급'
		END
  -- 2015.02.13 신혜원 파트장 추가 요청
	SET @RETURNCODE = CHARINDEX('시간당' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시간당'
		END
	SET @RETURNCODE = CHARINDEX('시간비' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시간비'
		END
	SET @RETURNCODE = CHARINDEX('시간당 2만5천원' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시간당 2만5천원'
		END
	SET @RETURNCODE = CHARINDEX('시간당 3만원' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시간당 3만원'
		END
	SET @RETURNCODE = CHARINDEX('시간당 25,000~30,000' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시간당 25,000~30,000'
		END
	SET @RETURNCODE = CHARINDEX('시간당+α' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시간당+α'
		END
	SET @RETURNCODE = CHARINDEX('시간비 2만5천원' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시간비 2만5천원'
		END
	SET @RETURNCODE = CHARINDEX('시간비 3만원' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시간비 3만원'
		END
	SET @RETURNCODE = CHARINDEX('시간비 25,000~30,000' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시간비 25,000~30,000'
		END
	SET @RETURNCODE = CHARINDEX('시간비+α' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 시간비+α'
		END
	SET @RETURNCODE = CHARINDEX('1시간 3만원' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 1시간 3만원'
		END
	SET @RETURNCODE = CHARINDEX('1시간 2만5천원' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 1시간 2만5천원'
		END
	SET @RETURNCODE = CHARINDEX('1시간 3만5천원' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 1시간 3만5천원'
		END
	SET @RETURNCODE = CHARINDEX('1시간 25,000-30,000' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 1시간 25,000-30,000'
		END
	SET @RETURNCODE = CHARINDEX('1시간 30,000원' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 1시간 30,000원'
		END
	SET @RETURNCODE = CHARINDEX('1시간 3만+α' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 1시간 3만+α'
		END
	SET @RETURNCODE = CHARINDEX('1시간 3만' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 1시간 3만'
		END
	SET @RETURNCODE = CHARINDEX('1시간당 3만' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 1시간당 3만'
		END
	SET @RETURNCODE = CHARINDEX('월수입600만이상' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 월수입600만이상'
		END
	-- 2015.02.16 신혜원 파트장 추가 요청
	SET @RETURNCODE = CHARINDEX('1시간' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 1시간'
		END
	SET @RETURNCODE = CHARINDEX('한시간' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 한시간'
		END
	SET @RETURNCODE = CHARINDEX('60분' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 60분'
		END
	SET @RETURNCODE = CHARINDEX('600만이상' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 600만이상'
		END
	SET @RETURNCODE = CHARINDEX('30만이상' , @COL_TEXT)
	
	IF @RETURNCODE > 0
		BEGIN
			SET @BAD_CONTENT = @BAD_CONTENT + ' 30만이상'
		END
		
	SELECT @BAD_CONTENT AS BAD_CONTENT

END






GO
/****** Object:  StoredProcedure [dbo].[GOALBA_NAME_EXISTS_FUNC_CHECK_TEST_JSSIN]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 금지어 포함 여부 (인덱스 체크용 테스트 확인 함수)
 *  작   성   자 : 신 장 순(jssin@mediawill.com)
 *  작   성   일 : 2015.03.05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 금지어 포함 광고는 이관하지 않는다
 *  사 용  소 스 :
 *  사 용  예 제 :
 EXEC [dbo].[GOALBA_NAME_EXISTS_FUNC_CHECK_TEST_JSSIN] '노래도우미 급 00명 25-45세 평일,주말알바환영 콜많고 분위기짱~ 출,퇴근지원 만근수당지급 각종편의제공 서구지역「탬버린(허352)」 탬버린(허352)'
 *************************************************************************************/
CREATE PROC [dbo].[GOALBA_NAME_EXISTS_FUNC_CHECK_TEST_JSSIN]
(
	@CONTENT		VARCHAR(MAX)
)
AS
BEGIN
	DECLARE @RETURNCODE	INT

	DECLARE @COL_TEXT VARCHAR(MAX)
	SET @COL_TEXT = @CONTENT

	SET @RETURNCODE = 0
	SET @RETURNCODE = CHARINDEX('피부관리' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '피부관리'
		END
	SET @RETURNCODE = CHARINDEX('이미지모델' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '이미지모델'
		END
	SET @RETURNCODE = CHARINDEX('극강하드' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '극강하드'
		END
	SET @RETURNCODE = CHARINDEX('북창동스타일' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '북창동스타일'
		END
	SET @RETURNCODE = CHARINDEX('휴게텔' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '휴게텔'
		END
	SET @RETURNCODE = CHARINDEX('이미지클럽' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '이미지클럽'
		END
	SET @RETURNCODE = CHARINDEX('신고식' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '신고식'
		END
	SET @RETURNCODE = CHARINDEX('풀싸롱2부' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '풀싸롱2부'
		END
	SET @RETURNCODE = CHARINDEX('키스방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '키스방'
		END
	SET @RETURNCODE = CHARINDEX('홈런' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '홈런'
		END
	SET @RETURNCODE = CHARINDEX('풀코스2차' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '풀코스2차'
		END
	SET @RETURNCODE = CHARINDEX('페티쉬클럽' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '페티쉬클럽'
		END
	SET @RETURNCODE = CHARINDEX('하드업소' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '하드업소'
		END
	SET @RETURNCODE = CHARINDEX('하드코어' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '하드코어'
		END
	SET @RETURNCODE = CHARINDEX('마사지' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '마사지'
		END
	SET @RETURNCODE = CHARINDEX('구미식' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '구미식'
		END
	SET @RETURNCODE = CHARINDEX('북창동식' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '북창동식'
		END
	SET @RETURNCODE = CHARINDEX('럭셔리샵' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '럭셔리샵'
		END
	SET @RETURNCODE = CHARINDEX('외국DVD방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '외국DVD방'
		END
	SET @RETURNCODE = CHARINDEX('해외' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '해외'
		END
	SET @RETURNCODE = CHARINDEX('풀사롱' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '풀사롱'
		END
	SET @RETURNCODE = CHARINDEX('스킨케어' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '스킨케어'
		END
	SET @RETURNCODE = CHARINDEX('립서비스' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '립서비스'
		END
	SET @RETURNCODE = CHARINDEX('대화방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '대화방'
		END
	SET @RETURNCODE = CHARINDEX('전투' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '전투'
		END
	SET @RETURNCODE = CHARINDEX('안마' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT @RETURNCODE
		END
	SET @RETURNCODE = CHARINDEX('북창동' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '북창동'
		END
	SET @RETURNCODE = CHARINDEX('풀서비스' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '풀서비스'
		END
	SET @RETURNCODE = CHARINDEX('구장' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '구장'
		END
	SET @RETURNCODE = CHARINDEX('마이킹' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '마이킹'
		END
	SET @RETURNCODE = CHARINDEX('보도방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '보도방'
		END
	SET @RETURNCODE = CHARINDEX('보도' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '보도'
		END
	SET @RETURNCODE = CHARINDEX('룸보도' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '룸보도'
		END
	SET @RETURNCODE = CHARINDEX('노래방보도' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '노래방보도'
		END
	SET @RETURNCODE = CHARINDEX('쭉쭉빵빵' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '쭉쭉빵빵'
		END
	SET @RETURNCODE = CHARINDEX('못생겨도됨' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '못생겨도됨'
		END
	SET @RETURNCODE = CHARINDEX('매력적인여성' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '매력적인여성'
		END
	SET @RETURNCODE = CHARINDEX('12개월내내대박' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '12개월내내대박'
		END
	SET @RETURNCODE = CHARINDEX('12개월계속' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '12개월계속'
		END
	SET @RETURNCODE = CHARINDEX('이미지방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '이미지방'
		END
	SET @RETURNCODE = CHARINDEX('비밀보장' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '비밀보장'
		END
	SET @RETURNCODE = CHARINDEX('애프터' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '애프터'
		END
	SET @RETURNCODE = CHARINDEX('에프터' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '에프터'
		END
	SET @RETURNCODE = CHARINDEX('단속걱정 NO' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '단속걱정 NO'
		END
	SET @RETURNCODE = CHARINDEX('단속걱정NO' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '단속걱정NO'
		END
	SET @RETURNCODE = CHARINDEX('접대부' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '접대부'
		END
	SET @RETURNCODE = CHARINDEX('해외업소' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '해외업소'
		END
	SET @RETURNCODE = CHARINDEX('오피스마사지' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '오피스마사지'
		END
	SET @RETURNCODE = CHARINDEX('오피스' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '오피스'
		END
	SET @RETURNCODE = CHARINDEX('오피스텔' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '오피스텔'
		END
	SET @RETURNCODE = CHARINDEX('풀살롱' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '풀살롱'
		END
	SET @RETURNCODE = CHARINDEX('소프트' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '소프트'
		END
	SET @RETURNCODE = CHARINDEX('온천장' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '온천장'
		END
	SET @RETURNCODE = CHARINDEX('맛사지' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '맛사지'
		END
	SET @RETURNCODE = CHARINDEX('오픈업소' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '오픈업소'
		END
	SET @RETURNCODE = CHARINDEX('풀싸롱' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '풀싸롱'
		END
	SET @RETURNCODE = CHARINDEX('2부' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '2부'
		END
	SET @RETURNCODE = CHARINDEX('보도' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '보도'
		END
	SET @RETURNCODE = CHARINDEX('보도방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '보도방'
		END
/*
	SET @RETURNCODE = CHARINDEX('교포' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '교포'
		END
*/
	SET @RETURNCODE = CHARINDEX('2차' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '2차'
		END
	SET @RETURNCODE = CHARINDEX('단속' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '단속'
		END
	SET @RETURNCODE = CHARINDEX('아빠방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '아빠방'
		END
	SET @RETURNCODE = CHARINDEX('단속 없는' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '단속 없는'
		END
	SET @RETURNCODE = CHARINDEX('단속없는' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '단속없는'
		END
	SET @RETURNCODE = CHARINDEX('안전한' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '안전한'
		END
	SET @RETURNCODE = CHARINDEX('파장동식' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '파장동식'
		END
	SET @RETURNCODE = CHARINDEX('K방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT 'K방'
		END
	SET @RETURNCODE = CHARINDEX('L방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT 'L방'
		END
	SET @RETURNCODE = CHARINDEX('k방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT 'k방'
		END
	SET @RETURNCODE = CHARINDEX('l방' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT 'l방'
		END
	SET @RETURNCODE = CHARINDEX('시급' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시급'
		END
  -- 2015.02.13 신혜원 파트장 추가 요청
	SET @RETURNCODE = CHARINDEX('시간당' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시간당'
		END
	SET @RETURNCODE = CHARINDEX('시간비' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시간비'
		END
	SET @RETURNCODE = CHARINDEX('시간당 2만5천원' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시간당 2만5천원'
		END
	SET @RETURNCODE = CHARINDEX('시간당 3만원' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시간당 3만원'
		END
	SET @RETURNCODE = CHARINDEX('시간당 25,000~30,000' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시간당 25,000~30,000'
		END
	SET @RETURNCODE = CHARINDEX('시간당+α' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시간당+α'
		END
	SET @RETURNCODE = CHARINDEX('시간비 2만5천원' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시간비 2만5천원'
		END
	SET @RETURNCODE = CHARINDEX('시간비 3만원' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시간비 3만원'
		END
	SET @RETURNCODE = CHARINDEX('시간비 25,000~30,000' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시간비 25,000~30,000'
		END
	SET @RETURNCODE = CHARINDEX('시간비+α' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '시간비+α'
		END
	SET @RETURNCODE = CHARINDEX('1시간 3만원' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '1시간 3만원'
		END
	SET @RETURNCODE = CHARINDEX('1시간 2만5천원' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '1시간 2만5천원'
		END
	SET @RETURNCODE = CHARINDEX('1시간 3만5천원' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '1시간 3만5천원'
		END
	SET @RETURNCODE = CHARINDEX('1시간 25,000-30,000' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '1시간 25,000-30,000'
		END
	SET @RETURNCODE = CHARINDEX('1시간 30,000원' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '1시간 30,000원'
		END
	SET @RETURNCODE = CHARINDEX('1시간 3만+α' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '1시간 3만+α'
		END
	SET @RETURNCODE = CHARINDEX('1시간 3만' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '1시간 3만'
		END
	SET @RETURNCODE = CHARINDEX('1시간당 3만' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '1시간당 3만'
		END
	SET @RETURNCODE = CHARINDEX('월수입600만이상' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '월수입600만이상'
		END
	-- 2015.02.16 신혜원 파트장 추가 요청
	SET @RETURNCODE = CHARINDEX('1시간' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '1시간'
		END
	SET @RETURNCODE = CHARINDEX('한시간' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '한시간'
		END
	SET @RETURNCODE = CHARINDEX('60분' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '60분'
		END
	SET @RETURNCODE = CHARINDEX('600만이상' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '600만이상'
		END
	SET @RETURNCODE = CHARINDEX('30만이상' , @COL_TEXT)
	PRINT @RETURNCODE
	IF @RETURNCODE > 0
		BEGIN
			SELECT '30만이상'
		END

	SELECT 'END'
END




GO
/****** Object:  StoredProcedure [dbo].[PUT_AD_OPTION_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












/*************************************************************************************
 *  단위 업무 명 : 광고 옵션등록 (프론트, 관리자 공통)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_AD_OPTION_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_AD_OPTION_PROC]

  @ADID                   INT
  ,@AD_KIND               CHAR(1)  --광고종류 (A: 등록대행, U: 회원등록)
  ,@LOCAL_CD              TINYINT
  ,@OPTION_MAIN_CD        TINYINT
  ,@TEMPLATE_CD           TINYINT
  ,@OPT_SUB_A             BIT
  ,@OPT_SUB_A_START_DT    VARCHAR(10)
  ,@OPT_SUB_A_END_DT      VARCHAR(10)
  ,@OPT_SUB_B             BIT
  ,@OPT_SUB_B_START_DT    VARCHAR(10)
  ,@OPT_SUB_B_END_DT      VARCHAR(10)
  ,@OPT_SUB_C             BIT
  ,@OPT_SUB_C_START_DT    VARCHAR(10)
  ,@OPT_SUB_C_END_DT      VARCHAR(10)
  ,@OPT_SUB_D             BIT
  ,@OPT_SUB_D_START_DT    VARCHAR(10)
  ,@OPT_SUB_D_END_DT      VARCHAR(10)
  ,@OPT_SUB_E             BIT
  ,@OPT_SUB_E_START_DT    VARCHAR(10)
  ,@OPT_SUB_E_END_DT      VARCHAR(10)

AS

  SET NOCOUNT ON

  BEGIN TRAN

    INSERT INTO PJ_OPTION_TB
          (ADID
          ,AD_KIND
          ,LOCAL_CD
          ,OPTION_MAIN_CD
          ,TEMPLATE_CD
          ,OPT_SUB_A
          ,OPT_SUB_A_START_DT
          ,OPT_SUB_A_END_DT
          ,OPT_SUB_B
          ,OPT_SUB_B_START_DT
          ,OPT_SUB_B_END_DT
          ,OPT_SUB_C
          ,OPT_SUB_C_START_DT
          ,OPT_SUB_C_END_DT
          ,OPT_SUB_D
          ,OPT_SUB_D_START_DT
          ,OPT_SUB_D_END_DT
          ,OPT_SUB_E
          ,OPT_SUB_E_START_DT
          ,OPT_SUB_E_END_DT)
    VALUES (@ADID
          ,@AD_KIND
          ,@LOCAL_CD
          ,@OPTION_MAIN_CD
          ,@TEMPLATE_CD
          ,@OPT_SUB_A
          ,@OPT_SUB_A_START_DT
          ,@OPT_SUB_A_END_DT
          ,@OPT_SUB_B
          ,@OPT_SUB_B_START_DT
          ,@OPT_SUB_B_END_DT
          ,@OPT_SUB_C
          ,@OPT_SUB_C_START_DT
          ,@OPT_SUB_C_END_DT
          ,@OPT_SUB_D
          ,@OPT_SUB_D_START_DT
          ,@OPT_SUB_D_END_DT
          ,@OPT_SUB_E
          ,@OPT_SUB_E_START_DT
          ,@OPT_SUB_E_END_DT)

  COMMIT TRAN

  -- 리스트업 적용
  IF @OPT_SUB_E = 1
    BEGIN
      EXECUTE DBO.BAT_OPTION_LISTUP_PROC
    END











GO
/****** Object:  StoredProcedure [dbo].[PUT_AD_PUBLISH_TRANS_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
















/*************************************************************************************
 *  단위 업무 명 : 줄광고 게재테이블로 이관
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/15
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_AD_PUBLISH_TRANS_PROC 1, 'U'
 *************************************************************************************/


CREATE PROC [dbo].[PUT_AD_PUBLISH_TRANS_PROC]

  @ADID                   INT
  ,@AD_KIND               CHAR(1)  --광고종류 (A: 등록대행, U: 회원등록)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_TABLE VARCHAR(20)
  DECLARE @CNT TINYINT

  SET @SQL = ''
  SET @SQL_TABLE = ''

  IF @AD_KIND = 'A'
    BEGIN
      SET @SQL_TABLE = 'PJ_AD_AGENCY_TB'
    END
  ELSE IF @AD_KIND = 'U'
    BEGIN
      SET @SQL_TABLE = 'PJ_AD_USERREG_TB'
    END
  ELSE
    BEGIN
      -- @AD_KIND가 NULL이거나 지정된 값이 아닐경우 중지
      RETURN
    END

  -- 게재테이블 데이터 확인
  SELECT @CNT = COUNT(*)
    FROM PJ_AD_PUBLISH_TB
   WHERE ADID = @ADID
     AND AD_KIND = @AD_KIND

  -- 게재테이블에 광고가 있으면 UPDATE 없으면 INSERT
  IF @CNT > 0
    BEGIN

      SET @SQL = 'UPDATE A
                     SET A.ADID         = B.ADID
                        ,A.CO_NAME      = B.CO_NAME
                        ,A.PHONE        = B.PHONE
                        ,A.HPHONE       = B.HPHONE
                        ,A.BIZ_CD       = B.BIZ_CD
                        ,A.AREA_A       = B.AREA_A
                        ,A.AREA_B       = B.AREA_B
                        ,A.AREA_C       = B.AREA_C
                        ,A.AREA_DETAIL  = B.AREA_DETAIL
                        ,A.HOMEPAGE     = B.HOMEPAGE
                        ,A.TITLE        = B.TITLE
                        ,A.CONTENTS     = B.CONTENTS
                        ,A.THEME_CD     = B.THEME_CD
                        ,A.PAY_CD       = B.PAY_CD
                        ,A.PAY_AMT      = B.PAY_AMT
                        ,A.BIZ_NUMBER   = B.BIZ_NUMBER
                        ,A.LOGO_IMG     = B.LOGO_IMG
                        ,A.START_DT     = B.START_DT
                        ,A.END_DT       = B.END_DT
                        ,A.MAP_X        = B.MAP_X
                        ,A.MAP_Y        = B.MAP_Y
                  FROM PJ_AD_PUBLISH_TB AS A
                       JOIN '+ @SQL_TABLE +' AS B
                         ON B.ADID = A.ADID
                 WHERE A.ADID = '+ CAST(@ADID AS VARCHAR(10)) +'
                   AND A.AD_KIND = '''+ @AD_KIND +''''

    END
  ELSE
    BEGIN

      SET @SQL = 'INSERT INTO PJ_AD_PUBLISH_TB
            (ADID
            ,AD_KIND
            ,CO_NAME
            ,PHONE
            ,HPHONE
            ,BIZ_CD
            ,AREA_A
            ,AREA_B
            ,AREA_C
            ,AREA_DETAIL
            ,HOMEPAGE
            ,TITLE
            ,CONTENTS
            ,THEME_CD
            ,PAY_CD
            ,PAY_AMT
            ,BIZ_NUMBER
            ,LOGO_IMG
            ,START_DT
            ,END_DT
            ,MAP_X
            ,MAP_Y
            ,GRAND_IMG)
      SELECT ADID
            ,'''+ @AD_KIND +''' AS AD_KIND
            ,CO_NAME
            ,PHONE
            ,HPHONE
            ,BIZ_CD
            ,AREA_A
            ,AREA_B
            ,AREA_C
            ,AREA_DETAIL
            ,HOMEPAGE
            ,TITLE
            ,CONTENTS
            ,THEME_CD
            ,PAY_CD
            ,PAY_AMT
            ,BIZ_NUMBER
            ,LOGO_IMG
            ,START_DT
            ,END_DT
            ,MAP_X
            ,MAP_Y
            ,GRAND_IMG
        FROM '+ @SQL_TABLE +'
       WHERE ADID = '+ CAST(@ADID AS VARCHAR(10)) +'
         AND CONVERT(VARCHAR(10),START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
         AND CONVERT(VARCHAR(10),END_DT,120) >= CONVERT(VARCHAR(10),GETDATE(),120)'

    END

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL

  --// 리스트업 옵션 적용
  EXECUTE DBO.EXEC_OPTION_LISTUP_PROC @ADID, @AD_KIND









GO
/****** Object:  StoredProcedure [dbo].[PUT_F_AD_RECCHARGE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > 광고결제정보 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/19
 *  수   정   자 : 신 장 순 (jssin@mediawill.com)
 *  수   정   일 : 2013/12/31
 *  설        명 : 전자세금계산서 자동발행 프로세스 변경에 따른 @TAXBILL_YN 추가
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_F_AD_RECCHARGE_PROC
 *************************************************************************************/

CREATE PROC [dbo].[PUT_F_AD_RECCHARGE_PROC]

  @ADID          INT
  ,@AD_GBN       TINYINT = 1  -- 광고구분 (1: E-Comm)
  ,@CHARGE_KIND  TINYINT      -- 결제종류 (1: 온라인입금, 2: 신용카드)
  ,@PRNAMT       INT
  ,@SERIAL       INT OUTPUT
  ,@TAXBILL_YN	 CHAR(1) = 'N'
AS

  SET NOCOUNT ON

  BEGIN TRAN

    INSERT INTO PJ_RECCHARGE_TB
           (ADID
            ,AD_GBN
            ,CHARGE_KIND
            ,PRNAMT
			,TAXBILL_YN)
    VALUES (@ADID
            ,@AD_GBN
            ,@CHARGE_KIND
            ,@PRNAMT
			,@TAXBILL_YN)

  COMMIT TRAN

  -- ADID값 리턴
  SET @SERIAL = @@IDENTITY







GO
/****** Object:  StoredProcedure [dbo].[PUT_F_AD_USERREG_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > E-COMM 광고정보입력
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_F_AD_USERREG_PROC
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_AD_USERREG_PROC]

  @CO_NAME        VARCHAR(100)
  ,@PHONE         VARCHAR(127)
  ,@HPHONE        VARCHAR(15)
  ,@BIZ_CD        INT
  ,@AREA_A        VARCHAR(50)
  ,@AREA_B        VARCHAR(50)
  ,@AREA_C        VARCHAR(50)
  ,@AREA_DETAIL   VARCHAR(50)
  ,@TITLE         VARCHAR(500)
  ,@CONTENTS      TEXT
  ,@PAY_CD        TINYINT
  ,@PAY_AMT       INT
  ,@BIZ_NUMBER    VARCHAR(50)
  ,@START_DT      VARCHAR(10)
  ,@END_DT        VARCHAR(10)
  ,@MAP_X         INT = 0
  ,@MAP_Y         INT = 0
  ,@USERID        VARCHAR(50)
  ,@ORDER_NAME    VARCHAR(30)
  ,@LOGO_IMG	  VARCHAR(100)
  ,@ADID          INT OUTPUT
  ,@CUID		  INT

AS

  SET NOCOUNT ON

  BEGIN TRAN

    INSERT INTO PJ_AD_USERREG_TB
           (CO_NAME
            ,PHONE
            ,HPHONE
            ,BIZ_CD
            ,AREA_A
            ,AREA_B
            ,AREA_C
            ,AREA_DETAIL
            ,TITLE
            ,CONTENTS
            ,PAY_CD
            ,PAY_AMT
            ,BIZ_NUMBER
            ,START_DT
            ,END_DT
            ,MAP_X
            ,MAP_Y
            ,USERID
            ,ORDER_NAME
            ,LOGO_IMG
            ,CUID)
    VALUES (@CO_NAME
            ,@PHONE
            ,@HPHONE
            ,@BIZ_CD
            ,@AREA_A
            ,@AREA_B
            ,@AREA_C
            ,@AREA_DETAIL
            ,@TITLE
            ,@CONTENTS
            ,@PAY_CD
            ,@PAY_AMT
            ,@BIZ_NUMBER
            ,@START_DT
            ,@END_DT
            ,@MAP_X
            ,@MAP_Y
            ,@USERID
            ,@ORDER_NAME
            ,@LOGO_IMG
            ,@CUID)

  COMMIT TRAN

  -- ADID값 리턴
  SET @ADID = @@IDENTITY








GO
/****** Object:  StoredProcedure [dbo].[PUT_F_AGENT_AD_TEL_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 프론트 > 광고등록/관리 > 전화등록대행 신청 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_F_AGENT_AD_TEL_PROC
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_AGENT_AD_TEL_PROC]

  @USERID	            VARCHAR(50) = ''
  ,@BIZ_CD	          INT
  ,@BIZ_NAME	        VARCHAR(120)
  ,@ORDER_NAME	      VARCHAR(30)
  ,@EMAIL	            VARCHAR(50) = ''
  ,@HPHONE	          VARCHAR(15) = ''
  ,@PHONE	            VARCHAR(15) = ''
  ,@AREA_A	          VARCHAR(50)
  ,@AREA_B	          VARCHAR(50)
  ,@AREA_C	          VARCHAR(50)
  ,@AREA_DETAIL	      VARCHAR(50)
  ,@TITLE	            VARCHAR(500)
  ,@CONTENTS	        TEXT
  ,@PAY_CD	          TINYINT
  ,@PAY_AMT	          INT
  ,@BIZ_NUMBER	      VARCHAR(50)
  ,@OPTION_MAIN_CD	  TINYINT
  ,@OPTION_MAIN_TERM	TINYINT
  ,@LOCAL_CD	        TINYINT
  ,@OPT_SUB_A	        BIT
  ,@OPT_SUB_A_TERM	  TINYINT
  ,@OPT_SUB_B	        BIT
  ,@OPT_SUB_B_TERM	  TINYINT
  ,@OPT_SUB_C	        BIT
  ,@OPT_SUB_C_TERM	  TINYINT
  ,@OPT_SUB_D	        BIT
  ,@OPT_SUB_D_TERM	  TINYINT
  ,@OPT_SUB_E	        BIT
  ,@OPT_SUB_E_TERM	  TINYINT
  ,@TOTAL_PRICE	      INT
  ,@PAYOWNER	        VARCHAR(50)
  ,@GRAND_IMG			VARCHAR(500)
  ,@OPTION_MAIN_TEMPLATE	TINYINT = NULL
  ,@CUID				INT = NULL

AS

  SET NOCOUNT ON
  DECLARE	@SEQNum					INT

  BEGIN TRAN

    INSERT INTO PJ_AGENT_AD_TEL_TB
      (USERID
      ,BIZ_CD
      ,BIZ_NAME
      ,ORDER_NAME
      ,EMAIL
      ,HPHONE
      ,PHONE
      ,AREA_A
      ,AREA_B
      ,AREA_C
      ,AREA_DETAIL
      ,TITLE
      ,CONTENTS
      ,PAY_CD
      ,PAY_AMT
      ,BIZ_NUMBER
      ,OPTION_MAIN_CD
      ,OPTION_MAIN_TERM
      ,LOCAL_CD
      ,OPT_SUB_A
      ,OPT_SUB_A_TERM
      ,OPT_SUB_B
      ,OPT_SUB_B_TERM
      ,OPT_SUB_C
      ,OPT_SUB_C_TERM
      ,OPT_SUB_D
      ,OPT_SUB_D_TERM
      ,OPT_SUB_E
      ,OPT_SUB_E_TERM
      ,TOTAL_PRICE
      ,PAYOWNER
      ,GRAND_IMG
      ,OPTION_MAIN_TEMPLATE
      ,CUID)
    VALUES
      (@USERID
      ,@BIZ_CD
      ,@BIZ_NAME
      ,@ORDER_NAME
      ,@EMAIL
      ,@HPHONE
      ,@PHONE
      ,@AREA_A
      ,@AREA_B
      ,@AREA_C
      ,@AREA_DETAIL
      ,@TITLE
      ,@CONTENTS
      ,@PAY_CD
      ,@PAY_AMT
      ,@BIZ_NUMBER
      ,@OPTION_MAIN_CD
      ,@OPTION_MAIN_TERM
      ,@LOCAL_CD
      ,@OPT_SUB_A
      ,@OPT_SUB_A_TERM
      ,@OPT_SUB_B
      ,@OPT_SUB_B_TERM
      ,@OPT_SUB_C
      ,@OPT_SUB_C_TERM
      ,@OPT_SUB_D
      ,@OPT_SUB_D_TERM
      ,@OPT_SUB_E
      ,@OPT_SUB_E_TERM
      ,@TOTAL_PRICE
      ,@PAYOWNER
      ,@GRAND_IMG
      ,@OPTION_MAIN_TEMPLATE
      ,@CUID)

  SET @SEQNum = SCOPE_IDENTITY()

  COMMIT TRAN
  RETURN (@SEQNum)









GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PAPER_AD_SCRAP_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : FRONT > 광고 스크랩 처리
 *  작   성   자 : 장 재 웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2012/09/12
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_F_PAPER_AD_SCRAP_PROC 1001057244, 'P', 'cbk08'
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_PAPER_AD_SCRAP_PROC]

  @ADID INT,
  @AD_KIND	CHAR,
  @USERID	VARCHAR(50),
  @CUID INT

AS

	SET NOCOUNT ON

	IF EXISTS(SELECT SEQ FROM dbo.PJ_AD_SCRAP_TB WHERE ADID = @ADID AND AD_KIND = @AD_KIND AND CUID = @CUID AND ISDELYN = 'N')
				RETURN(2) --기존 데이터 있음

	BEGIN TRY
		BEGIN TRAN
			BEGIN
				--기존 데이터가 없을 경우만 insert
				INSERT INTO dbo.PJ_AD_SCRAP_TB
				(ADID, AD_KIND, USERID, REGDATE, CUID)
				VALUES
				(@ADID, @AD_KIND, @USERID, GETDATE(), @CUID)
			END
		COMMIT
		RETURN(1)	--정상처리
	END TRY

	BEGIN CATCH
		ROLLBACK
		RETURN(0)	--실패처리
	END CATCH







GO
/****** Object:  StoredProcedure [dbo].[PUT_F_VBANK_SMS_SEND_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 결제 > 유흥구인 온라인 결제 입금에 따른 처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_F_VBANK_SMS_SEND_PROC 9, 1
 *************************************************************************************/


CREATE PROC [dbo].[PUT_F_VBANK_SMS_SEND_PROC]

  @SERIAL  INT
  ,@AD_GBN  TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SEND_PHONE VARCHAR(11)
  DECLARE @USERNAME VARCHAR(30)
  DECLARE @MSG VARCHAR(80)

  SELECT @SEND_PHONE = REPLACE(C.HPHONE,'-','')
        ,@USERNAME = C.USER_NM
    FROM PJ_RECCHARGE_TB AS A
    JOIN PJ_AD_USERREG_TB AS B
      ON B.ADID = A.ADID
    JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS C
      ON C.CUID = B.CUID
   WHERE A.SERIAL = @SERIAL
     AND A.AD_GBN = @AD_GBN

  SET @MSG = @USERNAME +'님 광고비가 확인 되었습니다. 항상 이용해 주셔서 감사합니다. [야알바]'

  EXECUTE FINDDB1.COMDB1.DBO.PUT_SENDSMS_PROC '0802690011','야알바','',@SEND_PHONE, @MSG







GO
/****** Object:  StoredProcedure [dbo].[PUT_INIPAYMAIN_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 이니시스 결재현황(INIPAYMAIN) 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/03/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 결제서버/inipay/Paper/INIsecurepay.asp
 *  사 용  예 제 : EXEC DBO.PUT_INIPAYMAIN_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_INIPAYMAIN_PROC]

  @Tid CHAR(40)
  ,@ResultCode CHAR(4)
  ,@ResultMsg VARCHAR(100)
  ,@PayMethod VARCHAR(20)
  ,@Price1 INT
  ,@Price2 INT
  ,@AuthCode VARCHAR(12)
  ,@CardQuota CHAR(2)
  ,@QuotaInterest CHAR(1)
  ,@CardCode CHAR(2)
  ,@CardIssuerCode CHAR(2)
  ,@AuthCertain CHAR(2)
  ,@PGAuthDate CHAR(8)
  ,@PGAuthTime CHAR(6)
  ,@OCBSaveAuthCode VARCHAR(12)
  ,@OCBUseAuthCode VARCHAR(12)
  ,@OCBAuthDate VARCHAR(8)
  ,@EventFlag CHAR(2)
  ,@PerNo VARCHAR(13)
  ,@Vacct VARCHAR(16)
  ,@VoID VARCHAR(40)
  ,@VcdBank CHAR(2)
  ,@DtInput VARCHAR(8)
  ,@NmInput VARCHAR(20)
  ,@NmVacct VARCHAR(50)

AS

  SET NOCOUNT ON

  INSERT INTO INIpayMain
              (Tid
              ,ResultCode
              ,ResultMsg
              ,PayMethod
              ,Price1
              ,Price2
              ,AuthCode
              ,CardQuota
              ,QuotaInterest
              ,CardCode
              ,CardIssuerCode
              ,AuthCertain
              ,PGAuthDate
              ,PGAuthTime
              ,OCBSaveAuthCode
              ,OCBUseAuthCode
              ,OCBAuthDate
              ,EventFlag
              ,PerNo
              ,Vacct
              ,VoID
              ,VcdBank
              ,DtInput
              ,NmInput
              ,NmVacct
              ,RegDate)
       VALUES (@Tid
              ,@ResultCode
              ,@ResultMsg
              ,@PayMethod
              ,@Price1
              ,@Price2
              ,@AuthCode
              ,@CardQuota
              ,@QuotaInterest
              ,@CardCode
              ,@CardIssuerCode
              ,@AuthCertain
              ,@PGAuthDate
              ,@PGAuthTime
              ,@OCBSaveAuthCode
              ,@OCBUseAuthCode
              ,@OCBAuthDate
              ,@EventFlag
              ,null--@PerNo
              ,@Vacct
              ,@VoID
              ,@VcdBank
              ,@DtInput
              ,@NmInput
              ,@NmVacct
              ,GETDATE())


SET QUOTED_IDENTIFIER OFF







GO
/****** Object:  StoredProcedure [dbo].[PUT_LOG_AD_PUBLISH_TB_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 야알바 관리자 > 광고상태 변경 로그(마감, 게재)
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_LOG_AD_PUBLISH_TB_PROC 'kwbaek20', '1017405480', 'PAPER', 'R'
 *************************************************************************************/

CREATE PROC [dbo].[PUT_LOG_AD_PUBLISH_TB_PROC]
		@ADMINID		VARCHAR(30) = ''
  , @ADID				INT = 0
	, @ACTPAGE		VARCHAR(10) = ''
	, @ACT				CHAR(2) = ''
AS
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN

    INSERT INTO dbo.LOG_AD_PUBLISH_TB
      (ADMINID, ADID, ACTPAGE, ACT)
		VALUES
			(@ADMINID, @ADID, @ACTPAGE, @ACT)

  COMMIT TRAN

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_AD_AGENCY_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












/*************************************************************************************
 *  단위 업무 명 : 관리자 > 등록대행 광고 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/14
 *  수   정   자 : 신 장 순 (jssin@mediawill.com)
 *  수   정   일 : 2015.01.30
 *  설        명 : 등록대행 광고도 검수관리를 통한 게재로 변경
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_M_AD_AGENCY_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_M_AD_AGENCY_PROC]

  @CO_NAME          VARCHAR   (30)
  ,@PHONE           VARCHAR   (127)
  ,@HPHONE          VARCHAR   (15)
  ,@BIZ_CD          INT
  ,@AREA_A          VARCHAR   (50)
  ,@AREA_B          VARCHAR   (50)
  ,@AREA_C          VARCHAR   (50)
  ,@AREA_DETAIL     VARCHAR   (50)
  ,@HOMEPAGE        VARCHAR   (100)
  ,@TITLE           VARCHAR   (500)
  ,@CONTENTS        TEXT
  ,@THEME_CD        TINYINT = 0
  ,@PAY_CD          TINYINT
  ,@PAY_AMT         INT = 0
  ,@BIZ_NUMBER      VARCHAR   (50) = ''
  ,@START_DT        DATETIME
  ,@END_DT          DATETIME
  ,@MAP_X           INT = 0
  ,@MAP_Y           INT = 0
  ,@MWPLUS_LINEADID INT = 0
  ,@MWPLUS_OPTION   INT = 0
  ,@REG_KIND        TINYINT
  ,@AMOUNT_ONLINE   MONEY = 0
  ,@AMOUNT_MWPLUS   MONEY = 0
  ,@MAGID           VARCHAR   (30)
  ,@MAGBRANCH       TINYINT
  ,@ADID            INT OUTPUT

AS

  SET NOCOUNT ON

  BEGIN TRAN

    INSERT INTO PJ_AD_AGENCY_TB
           (CO_NAME
            ,PHONE
            ,HPHONE
            ,BIZ_CD
            ,AREA_A
            ,AREA_B
            ,AREA_C
            ,AREA_DETAIL
            ,HOMEPAGE
            ,TITLE
            ,CONTENTS
            ,THEME_CD
            ,PAY_CD
            ,PAY_AMT
            ,BIZ_NUMBER
            ,START_DT
            ,END_DT
            ,MAP_X
            ,MAP_Y
            ,MWPLUS_LINEADID
            ,MWPLUS_OPTION
            ,REG_KIND
            ,AMOUNT_ONLINE
            ,AMOUNT_MWPLUS
            ,MAGID
            ,MAGBRANCH)
    VALUES (@CO_NAME
            ,@PHONE
            ,@HPHONE
            ,@BIZ_CD
            ,@AREA_A
            ,@AREA_B
            ,@AREA_C
            ,@AREA_DETAIL
            ,@HOMEPAGE
            ,@TITLE
            ,@CONTENTS
            ,@THEME_CD
            ,@PAY_CD
            ,@PAY_AMT
            ,@BIZ_NUMBER
            ,@START_DT
            ,@END_DT
            ,@MAP_X
            ,@MAP_Y
            ,@MWPLUS_LINEADID
            ,@MWPLUS_OPTION
            ,@REG_KIND
            ,@AMOUNT_ONLINE
            ,@AMOUNT_MWPLUS
            ,@MAGID
            ,@MAGBRANCH)

  COMMIT TRAN

  -- ADID값 리턴
  SET @ADID = @@IDENTITY
	/*
	--// 2015.01.30 검수관리를 통한 게재로 변경

  -- 시작일이 오늘자보다 오늘 또는 이전일 종료일이 오늘보다 같거나 이전일이면
  IF (CONVERT(VARCHAR(10), @START_DT, 120) <= CONVERT(VARCHAR(10), GETDATE(), 120)) AND (CONVERT(VARCHAR(10), @END_DT, 120) >= CONVERT(VARCHAR(10), GETDATE(), 120))
    BEGIN

      -- 게재테이블로 이관 (등록대행인 경우 두번째 인자값 'A')
      EXECUTE PUT_AD_PUBLISH_TRANS_PROC @ADID, 'A'

    END

	*/








GO
/****** Object:  StoredProcedure [dbo].[PUT_M_AD_AGENCY_PROC_VER2]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 야알바 관리자 > 등록대행 광고 등록
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/11/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 등록대행 광고 등록 등록자 이름도 추가(윌리언트랑 별도)
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_M_AD_AGENCY_PROC_VER2
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_AD_AGENCY_PROC_VER2]
	 @CO_NAME					VARCHAR(30)
	,@PHONE						VARCHAR(127)
	,@HPHONE					VARCHAR(15)
	,@BIZ_CD					INT
	,@AREA_A					VARCHAR(50)
	,@AREA_B					VARCHAR(50)
	,@AREA_C					VARCHAR(50)
	,@AREA_DETAIL			VARCHAR(50)
	,@HOMEPAGE				VARCHAR(100)
	,@TITLE						VARCHAR(500)
	,@CONTENTS				TEXT
	,@THEME_CD				TINYINT = 0
	,@PAY_CD					TINYINT
	,@PAY_AMT					INT = 0
	,@BIZ_NUMBER			VARCHAR(50) = ''
	,@START_DT				DATETIME
	,@END_DT					DATETIME
	,@MAP_X						INT = 0
	,@MAP_Y						INT = 0
	,@MWPLUS_LINEADID	INT = 0
	,@MWPLUS_OPTION		INT = 0
	,@REG_KIND				TINYINT
	,@AMOUNT_ONLINE		MONEY = 0
	,@AMOUNT_MWPLUS		MONEY = 0
	,@MAGID						VARCHAR(30)
	,@MAGBRANCH				TINYINT
	,@REG_NAME				VARCHAR(30) = ''
	,@ADID						INT OUTPUT
AS
	SET NOCOUNT ON
	BEGIN TRAN
		INSERT INTO PJ_AD_AGENCY_TB (
			 CO_NAME
			,PHONE
			,HPHONE
			,BIZ_CD
			,AREA_A
			,AREA_B
			,AREA_C
			,AREA_DETAIL
			,HOMEPAGE
			,TITLE
			,CONTENTS
			,THEME_CD
			,PAY_CD
			,PAY_AMT
			,BIZ_NUMBER
			,START_DT
			,END_DT
			,MAP_X
			,MAP_Y
			,MWPLUS_LINEADID
			,MWPLUS_OPTION
			,REG_KIND
			,AMOUNT_ONLINE
			,AMOUNT_MWPLUS
			,MAGID
			,MAGBRANCH
			,REG_NAME
		) VALUES (
			 @CO_NAME
			,@PHONE
			,@HPHONE
			,@BIZ_CD
			,@AREA_A
			,@AREA_B
			,@AREA_C
			,@AREA_DETAIL
			,@HOMEPAGE
			,@TITLE
			,@CONTENTS
			,@THEME_CD
			,@PAY_CD
			,@PAY_AMT
			,@BIZ_NUMBER
			,@START_DT
			,@END_DT
			,@MAP_X
			,@MAP_Y
			,@MWPLUS_LINEADID
			,@MWPLUS_OPTION
			,@REG_KIND
			,@AMOUNT_ONLINE
			,@AMOUNT_MWPLUS
			,@MAGID
			,@MAGBRANCH
			,@REG_NAME
		)
	COMMIT TRAN

	-- ADID값 리턴
	SET @ADID = @@IDENTITY
	/*
	--// 2015.01.30 검수관리를 통한 게재로 변경
	-- 시작일이 오늘자보다 오늘 또는 이전일 종료일이 오늘보다 같거나 이전일이면
	IF (CONVERT(VARCHAR(10), @START_DT, 120) <= CONVERT(VARCHAR(10), GETDATE(), 120)) AND (CONVERT(VARCHAR(10), @END_DT, 120) >= CONVERT(VARCHAR(10), GETDATE(), 120))
		BEGIN
		-- 게재테이블로 이관 (등록대행인 경우 두번째 인자값 'A')
		EXECUTE PUT_AD_PUBLISH_TRANS_PROC @ADID, 'A'
	END
	*/
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_MAG_HISTORY_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*************************************************************************************
 *  단위 업무 명 : 관리자 > 광고관리 히스토리 쌓기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/02/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_M_MAG_HISTORY_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_M_MAG_HISTORY_PROC]

   @ADID INT
  ,@AD_KIND CHAR(1)
  ,@MAG_ID VARCHAR(30)
  ,@COMMENT NVARCHAR(200)

AS

  SET NOCOUNT ON

  BEGIN TRAN

    INSERT INTO JOB_MAG_HISTORY_TB
           (ADID
           ,AD_KIND
           ,MAG_ID
           ,COMMENT)
    VALUES (@ADID
           ,@AD_KIND
           ,@MAG_ID
           ,@COMMENT)

  COMMIT TRAN









GO
/****** Object:  StoredProcedure [dbo].[PUT_M_MAINBANNER_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 관리자 > 사이트관리 > 베너등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_M_MAINBANNER_PROC 1,'AAA',1,'BBB','TEST','2012-07-19','2012-07-30',0
 *************************************************************************************/


CREATE PROC [dbo].[PUT_M_MAINBANNER_PROC]

  @LOCAL_CD            TINYINT
  ,@BANNER_IMG         VARCHAR(100)
  ,@BANNER_DETAIL_IMG  VARCHAR(100)
  ,@BANNER_TYPE        CHAR(1)
  ,@BANNER_URL         VARCHAR(100)
  ,@BANNER_CNT_FLAG    INT
  ,@BANNER_DESC        VARCHAR(200)
  ,@START_DT           VARCHAR(10)
  ,@END_DT             VARCHAR(10)

AS

  SET NOCOUNT ON

  BEGIN TRAN

    INSERT INTO dbo.PJ_MAIN_BANNER_TB
      (LOCAL_CD, BANNER_IMG, BANNER_DETAIL_IMG, BANNER_TYPE, BANNER_URL, BANNER_CNT_FLAG, BANNER_DESC, START_DT, END_DT)
    VALUES
      (@LOCAL_CD, @BANNER_IMG, @BANNER_DETAIL_IMG, @BANNER_TYPE, @BANNER_URL, @BANNER_CNT_FLAG, @BANNER_DESC, @START_DT, @END_DT)

  COMMIT TRAN

  RETURN (@@IDENTITY)





GO
/****** Object:  StoredProcedure [dbo].[PUT_M_NOTICE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 > 공지사항 등록하기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/07/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_M_NOTICE_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_M_NOTICE_PROC]

  @SECTIONS       VARCHAR(2)
  ,@MENUGBN       TINYINT
  ,@TITLE         VARCHAR(500)
  ,@CONTENTS      NVARCHAR(4000)
  ,@MAINDISFLAG   CHAR(1)
  ,@LOCALDISFLAG  CHAR(1)
  ,@TARGETGBN     CHAR(1)
  ,@OPTIONS       CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  INSERT INTO FINDDB2.FINDCOMMON.DBO.SiteNews
  (Sections, SiteGbn, LocalSite, MenuGbn, Title, Contents, MainDisFlag, LocalDisFlag, DelFlag, RegDate, TargetGbn, Options)
  VALUES
  (@SECTIONS, 'jobpaper', 0, @MENUGBN, @TITLE, @CONTENTS, @MAINDISFLAG, @LOCALDISFLAG, '0', GETDATE(), @TARGETGBN, @OPTIONS)









GO
/****** Object:  StoredProcedure [dbo].[PUT_M_PAPER_AD_TRANS_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 관리자 > 신문광고 게재테이블 이관
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/09/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_M_PAPER_AD_TRANS_PROC 1000094126
 *************************************************************************************/


CREATE PROC [dbo].[PUT_M_PAPER_AD_TRANS_PROC]

  @LINEADID INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  IF EXISTS(SELECT NULL FROM dbo.PJ_AD_PUBLISH_TB WHERE ADID = @LINEADID AND AD_KIND = 'P')
    BEGIN
      -- 기존에 게재된 데이터가 있다면 삭제
      DELETE
        FROM PJ_AD_PUBLISH_TB
       WHERE ADID = @LINEADID
         AND AD_KIND = 'P';

      DELETE
        FROM PJ_OPTION_TB
       WHERE ADID = @LINEADID
         AND AD_KIND = 'P'
    END

  -- 게제테이블로 이관
  BEGIN TRAN

    -- 게재테이블 등록
    INSERT INTO dbo.PJ_AD_PUBLISH_TB
      (ADID, AD_KIND, CO_NAME, PHONE, HPHONE, BIZ_CD, AREA_A, AREA_B, AREA_C, AREA_DETAIL, HOMEPAGE, TITLE, CONTENTS, THEME_CD, PAY_CD, PAY_AMT, BIZ_NUMBER, LOGO_IMG, START_DT, END_DT, MAP_X, MAP_Y, SORT_ID)
    SELECT LINEADID AS ADID
          ,'P' AS AD_KIND
          ,CONAME AS CO_NAME
          ,PHONE AS PHONE
          ,NULL AS HPHONE
          ,CODE AS BIZ_CD
          ,METRO AS AREA_A
          ,CITY AS AREA_B
          ,DONG AS AREA_C
          ,ADDR_DETAIL AS AREA_DETAIL
          ,URL AS HOMEPAGE
          ,CAST(CONTENTS AS VARCHAR(50)) AS TITLE
          ,CONTENTS AS CONTENTS
          ,0 AS THEME_CD
          ,0 AS PAY_CD
          ,0 AS PAY_AMT
          ,NULL AS BIZ_NUMBER
          ,NULL AS LOGO_IMG
          ,STARTDATE AS START_DT
          ,ENDDATE AS END_DT
          ,ISNULL(MAP_X,0) AS MAP_X
          ,ISNULL(MAP_Y,0) AS MAP_Y
          ,0 AS SORT_ID
     FROM dbo.DAILY_JOBPAPER_TB
    WHERE LINEADID = @LINEADID
      AND END_YN = 'N';

    -- 옵션테이블 등록
    INSERT INTO PJ_OPTION_TB
      (ADID, AD_KIND, LOCAL_CD)
    SELECT LINEADID AS ADID
          ,'P' AS AD_KIND
          ,CASE LAYOUTBRANCH WHEN 11 THEN 2  -- 대구/경북
                             WHEN 39 THEN 2  -- 구미
                             WHEN 60 THEN 2  -- 영주
                             WHEN 47 THEN 2  -- 울산
                             WHEN 26 THEN 2  -- 포항
                             WHEN 25 THEN 4  -- 부산/경남
                             WHEN 41 THEN 4  -- 경주
                             WHEN 34 THEN 4  -- 김해장유
                             WHEN 35 THEN 4  -- 창원(마창)
                             WHEN 49 THEN 4  -- 양산
                             WHEN 48 THEN 4  -- 진주
                             WHEN 46 THEN 4  -- 한려
                             ELSE 1          -- 전국
            END AS LOCAL_CD
     FROM dbo.DAILY_JOBPAPER_TB
    WHERE LINEADID = @LINEADID
      AND END_YN = 'N'

  COMMIT TRAN






GO
/****** Object:  StoredProcedure [dbo].[PUT_M_SERVICE_TEAM_ACTION_LOG_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 서비스지원파트 야알바 검수로그(승인/거절)
 *  작   성   자 : 신장순
 *  작   성   일 : 2016/03/25
 *  설        명 : 구인구직 로고검수/야알바 검수 승인or취소 의 로그를 저장
 *  주 의  사 항 :
 *  수   정   자 :
 *  수   정   일 :
 *  수   정 내용 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_SERVICE_TEAM_ACTION_LOG_PROC]
 @PROC_SITE				VARCHAR(20)
,@PROC_NM					VARCHAR(20)
,@PROC_GBN				VARCHAR(20)
,@PROC_AD_NUM			CHAR(16)
,@PROC_MAG_ID			VARCHAR(50)
,@PROC_ACTION			VARCHAR(10)
AS

BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	DECLARE @TMP_DATE DATETIME = GETDATE()
	DECLARE @TMP_PROC_DT VARCHAR(10) = CONVERT(VARCHAR(10), @TMP_DATE, 120)

	/* 야알바는 온라인 상품만 */
	DECLARE @PROC_GOODS_GBN VARCHAR(10) = '온라인'

	DECLARE @PROC_AD_TYPE VARCHAR(10)		= ''

	IF (SELECT COUNT(*) FROM PJ_AD_AGENCY_TB WHERE ADID = CONVERT(INT, @PROC_AD_NUM)) > 0
		BEGIN
			SET @PROC_AD_TYPE = '등록대행'
		END
	ELSE IF (SELECT COUNT(*) FROM PJ_AD_USERREG_TB WHERE ADID = CONVERT(INT, @PROC_AD_NUM)) > 0
		BEGIN
			SET @PROC_AD_TYPE = 'ECOMM'
		END

	EXEC FINDDB1.LOGDB.DBO.PUT_SERVICE_TEAM_ACTION_TB_LOG_PROC @PROC_SITE, @PROC_NM, @PROC_GBN, @PROC_AD_NUM, @PROC_MAG_ID, @PROC_ACTION, @PROC_GOODS_GBN, @PROC_AD_TYPE

END





GO
/****** Object:  StoredProcedure [dbo].[PUT_MWS_YAALBA_AD_OPTION_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- select * from PJ_AD_AGENCY_TB
/*
EXEC PUT_MWS_YAALBA_AD_OPTION_PROC
'54665',
'TMP100002305637',
'0',
'A',
'1',
'32',
'0',
'0',
'',
'',
'0',
'',
'',
'0',
'',
'',
'0',
'',
'',
'0',
'',
''
*/
--
--select * from PJ_AD_AGENCY_TB order by REG_DT DESC

CREATE PROC  [dbo].[PUT_MWS_YAALBA_AD_OPTION_PROC]
	 @ADID									INT
	,@TEMP_LINEADID					varchar	(25)
  ,@REALACPTID						int			= 0
  ,@AD_KIND								char(1)			-- PJ_OPTION_TB
  ,@LOCAL_CD              TINYINT = 0 -- PJ_OPTION_TB
  
	,@OPTION_MAIN_CD        TINYINT = 0 -- PJ_OPTION_TB
  ,@TEMPLATE_CD           TINYINT = 0 -- PJ_OPTION_TB
  ,@OPT_SUB_A             TINYINT = 0 -- PJ_OPTION_TB
  ,@OPT_SUB_A_START_DT    VARCHAR(10) -- PJ_OPTION_TB
  ,@OPT_SUB_A_END_DT      VARCHAR(10) -- PJ_OPTION_TB
  
	,@OPT_SUB_B             TINYINT = 0 -- PJ_OPTION_TB
  ,@OPT_SUB_B_START_DT    VARCHAR(10) -- PJ_OPTION_TB
  ,@OPT_SUB_B_END_DT      VARCHAR(10) -- PJ_OPTION_TB
  ,@OPT_SUB_C             TINYINT = 0 -- PJ_OPTION_TB
  ,@OPT_SUB_C_START_DT    VARCHAR(10) -- PJ_OPTION_TB
  
	,@OPT_SUB_C_END_DT      VARCHAR(10) -- PJ_OPTION_TB
  ,@OPT_SUB_D             TINYINT = 0 -- PJ_OPTION_TB
  ,@OPT_SUB_D_START_DT    VARCHAR(10) -- PJ_OPTION_TB
  ,@OPT_SUB_D_END_DT      VARCHAR(10) -- PJ_OPTION_TB
  ,@OPT_SUB_E             TINYINT = 0 -- PJ_OPTION_TB
  
	,@OPT_SUB_E_START_DT    VARCHAR(10) -- PJ_OPTION_TB
  ,@OPT_SUB_E_END_DT      VARCHAR(10) -- PJ_OPTION_TB
AS 

  SET NOCOUNT ON

  IF EXISTS(SELECT ADID FROM PJ_OPTION_TB WHERE ADID = @ADID)
    BEGIN
      UPDATE PJ_OPTION_TB
				SET  
						 TEMP_LINEADID				= @TEMP_LINEADID
						,ORG_LINEADID					= @REALACPTID
						,AD_KIND              = @AD_KIND
						,LOCAL_CD             = @LOCAL_CD          
						,OPTION_MAIN_CD       = @OPTION_MAIN_CD    
						,TEMPLATE_CD          = @TEMPLATE_CD       
						,OPT_SUB_A            = @OPT_SUB_A         
						,OPT_SUB_A_START_DT   = @OPT_SUB_A_START_DT
						,OPT_SUB_A_END_DT     = @OPT_SUB_A_END_DT  
						,OPT_SUB_B            = @OPT_SUB_B         
						,OPT_SUB_B_START_DT   = @OPT_SUB_B_START_DT
						,OPT_SUB_B_END_DT     = @OPT_SUB_B_END_DT  
						,OPT_SUB_C            = @OPT_SUB_C         
						,OPT_SUB_C_START_DT   = @OPT_SUB_C_START_DT
						,OPT_SUB_C_END_DT     = @OPT_SUB_C_END_DT  
						,OPT_SUB_D            = @OPT_SUB_D         
						,OPT_SUB_D_START_DT   = @OPT_SUB_D_START_DT
						,OPT_SUB_D_END_DT     = @OPT_SUB_D_END_DT  
						,OPT_SUB_E            = @OPT_SUB_E         
						,OPT_SUB_E_START_DT   = @OPT_SUB_E_START_DT
						,OPT_SUB_E_END_DT     = @OPT_SUB_E_END_DT  
       WHERE ADID = @ADID
    END
  ELSE
    BEGIN
		INSERT INTO PJ_OPTION_TB
				(
				 ADID
				,AD_KIND
        ,LOCAL_CD          
        ,OPTION_MAIN_CD    
        ,TEMPLATE_CD       
        ,OPT_SUB_A         
        ,OPT_SUB_A_START_DT
        ,OPT_SUB_A_END_DT  
        ,OPT_SUB_B         
        ,OPT_SUB_B_START_DT
        ,OPT_SUB_B_END_DT  
        ,OPT_SUB_C         
        ,OPT_SUB_C_START_DT
        ,OPT_SUB_C_END_DT  
        ,OPT_SUB_D         
        ,OPT_SUB_D_START_DT
        ,OPT_SUB_D_END_DT  
        ,OPT_SUB_E         
        ,OPT_SUB_E_START_DT
        ,OPT_SUB_E_END_DT
				,TEMP_LINEADID
				,ORG_LINEADID
				)
			VALUES
				(
				 @ADID
				,@AD_KIND
        ,@LOCAL_CD          
        ,@OPTION_MAIN_CD    
        ,@TEMPLATE_CD       
        ,@OPT_SUB_A         
        ,@OPT_SUB_A_START_DT
        ,@OPT_SUB_A_END_DT  
        ,@OPT_SUB_B         
        ,@OPT_SUB_B_START_DT
        ,@OPT_SUB_B_END_DT  
        ,@OPT_SUB_C         
        ,@OPT_SUB_C_START_DT
        ,@OPT_SUB_C_END_DT  
        ,@OPT_SUB_D         
        ,@OPT_SUB_D_START_DT
        ,@OPT_SUB_D_END_DT  
        ,@OPT_SUB_E         
        ,@OPT_SUB_E_START_DT
        ,@OPT_SUB_E_END_DT
				,@TEMP_LINEADID
				,@REALACPTID
				)
    END

GO
/****** Object:  StoredProcedure [dbo].[PUT_MWS_YAALBA_AD_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- select * from PJ_AD_AGENCY_TB

/*
exec PUT_MWS_YAALBA_AD_PROC 
'TMP100002305589',
'0',
'홍길동야식',
'053-784-1398',
'010-1111-2222',
'40100',
'강원',
'고성군',
'거진읍',
'43',
'',
'ㄴㅇㄹ',
'ㄴㄹㅇ',
'0',
'0',
'0',
'',
'2017-03-15',
'2017-03-29',
'0',
'0',
'1',
'0',
'0',
'백규원_본사',
'202',
'',
'',
'',
'',
''
*/

CREATE PROC  [dbo].[PUT_MWS_YAALBA_AD_PROC]
   @TEMP_LINEADID	varchar	(25)
  ,@REALACPTID int

  ,@CO_NAME	varchar	(30) -- PJ_AD_AGENCY_TB
  ,@PHONE	varchar	(127) -- PJ_AD_AGENCY_TB
  ,@HPHONE	varchar	(15) -- PJ_AD_AGENCY_TB
  ,@BIZ_CD	int = 0 -- PJ_AD_AGENCY_TB
  ,@AREA_A	varchar	(50) -- PJ_AD_AGENCY_TB

  ,@AREA_B	varchar	(50) -- PJ_AD_AGENCY_TB
  ,@AREA_C	varchar	(50) -- PJ_AD_AGENCY_TB
  ,@AREA_DETAIL	varchar	(50) -- PJ_AD_AGENCY_TB
	,@HOMEPAGE varchar(100) -- NEW
  ,@TITLE	varchar	(500) -- PJ_AD_AGENCY_TB
  ,@CONTENTS	nvarchar(max) -- PJ_AD_AGENCY_TB

  ,@THEME_CD	tinyint = 0 -- PJ_AD_AGENCY_TB
  ,@PAY_CD	tinyint = 0 -- PJ_AD_AGENCY_TB
  ,@PAY_AMT	int = 0 -- PJ_AD_AGENCY_TB
  ,@BIZ_NUMBER	varchar	(50) -- PJ_AD_AGENCY_TB
  ,@START_DT	datetime -- PJ_AD_AGENCY_TB

  ,@END_DT	datetime -- PJ_AD_AGENCY_TB
  ,@MAP_X	int = 0 -- PJ_AD_AGENCY_TB : int
  ,@MAP_Y	int = 0 -- PJ_AD_AGENCY_TB : int
  ,@REG_KIND	tinyint = 0 -- PJ_AD_AGENCY_TB
  ,@AMOUNT_ONLINE	int = 0 --PJ_AD_AGENCY_TB
  --,@AMOUNT_ONLINE	money = 0 --PJ_AD_AGENCY_TB

  ,@AMOUNT_MWPLUS	int = 0 -- PJ_AD_AGENCY_TB
  --,@AMOUNT_MWPLUS	money = 0 -- PJ_AD_AGENCY_TB
  ,@MAGID	varchar	(30) -- PJ_AD_AGENCY_TB
  ,@MAGBRANCH	tinyint = 0 -- PJ_AD_AGENCY_TB
  ,@LOGO_IMG	varchar	(200) -- PJ_AD_AGENCY_TB
  ,@GRAND_IMG	varchar	(200) -- PJ_AD_AGENCY_TB

	,@REASON  varchar (200) -- PJ_AD_AGENCY_TB

  ,@OUTPUT_TEMP_LINEADID VARCHAR(25) OUTPUT
  ,@OUTPUT_ADID								 INT OUTPUT
AS 

  SET NOCOUNT ON

  -- 본접수번호가 있는경우 접수번호로 임시키값을 가져옴.
  IF @REALACPTID > 0
    BEGIN
      SELECT @TEMP_LINEADID = TEMP_LINEADID
       FROM PJ_AD_AGENCY_TB
      WHERE ORG_LINEADID = @REALACPTID
    END
		
  IF EXISTS(SELECT TEMP_LINEADID FROM PJ_AD_AGENCY_TB WHERE TEMP_LINEADID = @TEMP_LINEADID)
    BEGIN
      UPDATE PJ_AD_AGENCY_TB
         SET CO_NAME              = @CO_NAME
            ,PHONE                = @PHONE
            ,HPHONE               = @HPHONE
            ,BIZ_CD               = @BIZ_CD
            ,AREA_A               = @AREA_A
            ,AREA_B               = @AREA_B
            ,AREA_C               = @AREA_C
            ,AREA_DETAIL          = @AREA_DETAIL
						,HOMEPAGE							= @HOMEPAGE
            ,TITLE                = @TITLE
            ,CONTENTS             = @CONTENTS
            ,THEME_CD             = @THEME_CD
            ,PAY_CD               = @PAY_CD
            ,PAY_AMT              = @PAY_AMT
            ,BIZ_NUMBER           = @BIZ_NUMBER
            ,START_DT             = @START_DT
            ,END_DT               = @END_DT
            ,MAP_X                = @MAP_X
            ,MAP_Y                = @MAP_Y
            ,REG_KIND             = @REG_KIND
            ,AMOUNT_ONLINE        = CAST(@AMOUNT_ONLINE AS MONEY)
            ,AMOUNT_MWPLUS        = CAST(@AMOUNT_MWPLUS AS MONEY)
            ,MAGID                = @MAGID
            ,MAGBRANCH            = @MAGBRANCH
            ,LOGO_IMG             = @LOGO_IMG
            ,GRAND_IMG            = @GRAND_IMG
            ,REASON               = @REASON
       WHERE TEMP_LINEADID				= @TEMP_LINEADID
    END
  ELSE
    BEGIN
      INSERT INTO PJ_AD_AGENCY_TB
        (TEMP_LINEADID
        ,CO_NAME
        ,PHONE
        ,HPHONE
        ,BIZ_CD
        ,AREA_A
        ,AREA_B
        ,AREA_C
        ,AREA_DETAIL
				,HOMEPAGE
        ,TITLE
        ,CONTENTS
        ,THEME_CD
        ,PAY_CD
        ,PAY_AMT
        ,BIZ_NUMBER
        ,START_DT
        ,END_DT
        ,MAP_X
        ,MAP_Y
        ,REG_KIND
        ,AMOUNT_ONLINE
        ,AMOUNT_MWPLUS
        ,MAGID
        ,MAGBRANCH
        ,LOGO_IMG
        ,GRAND_IMG
        ,REASON
				,M_STATUS)
    VALUES
        (@TEMP_LINEADID
        ,@CO_NAME
        ,@PHONE
        ,@HPHONE
        ,@BIZ_CD
        ,@AREA_A
        ,@AREA_B
        ,@AREA_C
        ,@AREA_DETAIL
				,@HOMEPAGE
        ,@TITLE
        ,@CONTENTS
        ,@THEME_CD
        ,@PAY_CD
        ,@PAY_AMT
        ,@BIZ_NUMBER
        ,@START_DT
        ,@END_DT
        ,@MAP_X
        ,@MAP_Y
        ,@REG_KIND
        ,CAST(@AMOUNT_ONLINE AS MONEY)
        ,CAST(@AMOUNT_MWPLUS AS MONEY)
        ,@MAGID
        ,@MAGBRANCH
        ,@LOGO_IMG
        ,@GRAND_IMG
        ,@REASON
				,'A')
    END

    SET @OUTPUT_TEMP_LINEADID = @TEMP_LINEADID
		SET @OUTPUT_ADID = @@IDENTITY



GO
/****** Object:  StoredProcedure [dbo].[PUT_YAALBA_AD_WILLS_LOG_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC  [dbo].[PUT_YAALBA_AD_WILLS_LOG_PROC]
	 @ADID						INT
	,@MAGID						VARCHAR(30)
	,@MAGNAME					VARCHAR(30)
	,@MAGBRANCH				TINYINT
	,@IP							VARCHAR(15)
	,@TEMP_LINEADID		VARCHAR(25)
	,@ORG_LINEADID		INT
	--,@REG_DT					DATETIME
	,@LOG_STATUS			CHAR(1)
AS 

  SET NOCOUNT ON
		INSERT INTO PJ_AD_WILLS_LOG_TB
		(
			 ADID
			,MAGID
			,MAGNAME
			,MAGBRANCH
			,IP
			,TEMP_LINEADID
			,ORG_LINEADID
			--,REG_DT
			,LOG_STATUS
		)
		VALUES
		(
			 @ADID
			,@MAGID
			,@MAGNAME
			,@MAGBRANCH
			,@IP
			,@TEMP_LINEADID
			,@ORG_LINEADID
			--,GETDATE()
			,@LOG_STATUS
		)
GO
/****** Object:  StoredProcedure [dbo].[USERID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:20:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원통합 > 아이디 변경
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016/08/03
 *  설       명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
                 EXEC USERID_CHANGE_PROC 'anycall512', 'anycall512','111.111.111.111'
                 EXEC USERID_CHANGE_PROC 'oby5002', 'oby5002','111.111.111.111'

 *************************************************************************************/
CREATE PROCEDURE [dbo].[USERID_CHANGE_PROC]
  @CUID            VARCHAR(50)        =  ''      -- 기존아이디
  ,@USERID            VARCHAR(50)        =  ''      -- 기존아이디
  ,@RE_USERID             VARCHAR(50)        =  ''      --  변경 아이디
  ,@CLIENT_IP		varchar(20) = ''

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	UPDATE A SET USERID=@RE_USERID FROM JOB_CUSTOMER_TB A  where CUID=@CUID
	UPDATE A SET userid=@RE_USERID FROM PJ_AD_SCRAP_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM PJ_AD_USERREG_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM PJ_AGENT_AD_TEL_TB A  where CUID=@CUID


/*
	INSERT LOGDB.DBO.USERID_CHANGE_HISTORY_TB (B_USERID,N_USERID,DB_NM,USERIP)
	SELECT @USERID,@RE_USERID,DB_NAME(),@CLIENT_IP
*/
END


GO
