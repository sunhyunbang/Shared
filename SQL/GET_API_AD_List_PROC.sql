USE [PARTNERSHIP]
GO
/****** Object:  StoredProcedure [dbo].[GET_API_AD_List_PROC]    Script Date: 2023-04-25 오후 4:12:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 벼룩시장 광고 API (List)
 *  작   성   자 : 신 장 순 (jssin@mediawill.com)
 *  작   성   일 : 2014/10/22
 *  설        명 : 벼룩시장 광고리스트(API 사용)
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 EXEC GET_API_AD_List_PROC 1, 10000, 'simple', 'jobsch', ''
 go
 EXEC GET_API_AD_List_PROC 1, 100000, '', 'alba', ''
 go
 EXEC GET_API_AD_List_PROC 1, 10000, '', 'Kinfa', ''
 go

 exec GET_API_AD_List_PROC @pPaze=1,@pPageSize=100,@pSelGbn=N'',@SITE_ID=N'test',@SITE_AUTH_NO=N'orzxsic/ls6jbzizsilsna=='

 *************************************************************************************/
ALTER PROC [dbo].[GET_API_AD_List_PROC]

	@pPaze				INT	= 1
, @pPageSize		INT = 50
, @pSelGbn			VARCHAR(10) = ''
, @SITE_ID			VARCHAR(50) = ''
, @SITE_AUTH_NO VARCHAR(100) = ''
AS

BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON

  DECLARE @TMP_AD_MAIN TABLE (
    R_NUM INT
  , LINEADNO CHAR(16)
      ,LINEADID INT
      ,INPUT_BRANCH TINYINT
      ,LAYOUT_BRANCH TINYINT
      ,GROUP_CD TINYINT
      ,ORDER_NAME VARCHAR(30)
      ,FIELD_6 VARCHAR(100)
      ,START_DT DATETIME
      ,END_DT DATETIME
      ,VERSION CHAR(1)
      ,REG_DT DATETIME
      ,MOD_DT DATETIME
      ,TITLE VARCHAR(500)
      ,ORDER_EMAIL VARCHAR(50)
      ,PHONE VARCHAR(127)
      ,PHONE_MOBILE VARCHAR(127)
      ,VNSNO VARCHAR(127)
      ,FREE_AD_F TINYINT
      ,ALBA_PARTNER TINYINT
      ,KINFA_PARTNER TINYINT
      ,SENIORTV_PARTNER TINYINT
      ,AREA_DETAIL VARCHAR(60)
      ,CONTENTS VARCHAR(1000)
      ,HOMEPAGE VARCHAR(100)
      ,FIELD_2 VARCHAR(100)
      ,AD_KIND CHAR(1)
      ,ADORDERPHONE VARCHAR(20)
      ,EX_CONTENTS TEXT
      ,EX_IMAGE_1 VARCHAR(200)
      ,EX_IMAGE_2 VARCHAR(200)
      ,EX_IMAGE_3 VARCHAR(200)
      ,EX_IMAGE_4 VARCHAR(200)
      ,GMAP_X VARCHAR(25)
      ,GMAP_Y VARCHAR(25)
      ,HTML_FLAG CHAR(1)
      ,OPT_CODE SMALLINT
      ,OPT_START_DT DATETIME
      ,OPT_END_DT DATETIME
      ,MOBILE_OPT_CODE SMALLINT
      ,DISPLAY_OPT SMALLINT
      ,AREA_DONG VARCHAR(30)
      ,RV_PANOID INT
      ,RV_ANGLEID VARCHAR(25)
      ,MAP_VIEW_YN CHAR(1)
      ,VNSUSEF TINYINT
      ,FIELD_3 VARCHAR(100)
      ,IDENTYFLAG CHAR(1)
  )

  DECLARE @TMP_LINEADNO TABLE (
    LINEADNO CHAR(16)
  , [VERSION]  CHAR(1)
  , FREE_AD_F  TINYINT
  )

	IF @pPageSize > 50000 BEGIN
		SET @pPageSize = 500000
	END

  DECLARE @TRANS_VERSION_ECOMM TINYINT
        , @TRANS_VERSION_AGENCY TINYINT
        , @TRANS_FREE TINYINT


  SELECT @TRANS_VERSION_ECOMM = TRANS_VERSION_ECOMM
       , @TRANS_VERSION_AGENCY = TRANS_VERSION_AGENCY
       , @TRANS_FREE = TRANS_FREE
    FROM CC_FINDALL_API_AUTH_MEMBER
   WHERE SITE_ID = @SITE_ID
     --AND SITE_AUTH_NO = @SITE_AUTH_NO
 
	IF @SITE_ID = 'alba' OR @SITE_ID = 'test' BEGIN
		INSERT INTO @TMP_LINEADNO
		SELECT A.LINEADNO, VERSION, FREE_AD_F
			FROM API_LINE_AD_TB A
		 WHERE A.GROUP_CD = 14            -- 구인구직
			 AND A.IDENTYFLAG = 1
			 AND A.ALBA_PARTNER = 1
	END
	ELSE IF @SITE_ID = 'kinfa' BEGIN
		INSERT INTO @TMP_LINEADNO
		SELECT A.LINEADNO, VERSION, FREE_AD_F
			FROM API_LINE_AD_TB A
		 WHERE A.GROUP_CD = 14            -- 구인구직
			 AND A.IDENTYFLAG = 1
			 AND A.KINFA_PARTNER = 1
	END

  --Ecomm 제외
  IF @TRANS_VERSION_ECOMM = 0 
  BEGIN
    DELETE A
    -- SELECT *
      FROM @TMP_LINEADNO A
     WHERE A.VERSION = 'E'
  END

  --등록대행 제외
  IF @TRANS_VERSION_AGENCY = 0 
  BEGIN
    DELETE A
    -- SELECT *
      FROM @TMP_LINEADNO A
     WHERE A.VERSION = 'M'
  END

  --무료공고 제외
  IF @TRANS_FREE = 0
  BEGIN
    DELETE A
    -- SELECT *
      FROM @TMP_LINEADNO A
     WHERE A.FREE_AD_F = 1
  END


  INSERT INTO @TMP_AD_MAIN
  SELECT ROW_NUMBER() OVER(ORDER BY LINEADNO) AS R_NUM
       , A.*
    FROM API_LINE_AD_TB A
   WHERE A.LINEADNO IN (SELECT LINEADNO FROM @TMP_LINEADNO)


  SELECT *
    INTO #AD_MAIN
    FROM @TMP_AD_MAIN AS T
   WHERE R_NUM > ((@pPaze - 1) * @pPageSize)
     AND R_NUM <= (@pPaze * @pPageSize)

  --// Table[0] -- 추후 추가예정
  --SELECT COUNT(*) FROM @TMP_AD_MAIN


  IF @pSelGbn = 'simple'
    BEGIN

      --// Table[1]
      SELECT A.R_NUM
           , A.LINEADNO
           , A.LINEADID
           , A.INPUT_BRANCH
           , A.LAYOUT_BRANCH
           , PAPER_NEW.[dbo].[fn_DelSpecCharTitle](A.TITLE,'E') AS TITLE
           , A.FIELD_6
           , CASE WHEN B.PUB_LOGO IS NULL THEN '' ELSE 'http://job.findall.co.kr/UploadFiles/Platinum/' + B.PUB_LOGO END AS PUB_LOGO
           , A.START_DT
           , A.END_DT
      FROM #AD_MAIN A
      LEFT JOIN API_LOGO_OPTION_TB B ON B.LINEADNO = A.LINEADNO

      --// Table[2]
      -- simple 에서는 FindCode와 Area를 추가 Select
      SELECT A.LINEADNO
           , B.LINEADID
           , B.INPUT_BRANCH
           , B.LAYOUT_BRANCH
           , A.FINDCODE
           , A.[ORDER]
      FROM API_LINE_AD_FINDCODE_TB A
      JOIN #AD_MAIN B ON B.LINEADNO = A.LINEADNO
      ORDER BY A.[ORDER]

      --// Table[3]
      SELECT A.LINEADNO
           , B.LINEADID
           , B.INPUT_BRANCH
           , B.LAYOUT_BRANCH
           , A.AREA_A
           , C.AREA_A_CODE
           , A.AREA_B
           , C.AREA_B_CODE
           , A.AREA_C
           , C.AREA_C_CODE
           , A.[ORDER]
      FROM API_LINE_AD_AREA_TB A
      JOIN #AD_MAIN B ON B.LINEADNO = A.LINEADNO
      LEFT JOIN [PAPER_NEW].[DBO].[CM_ZIPTXT_CODE] C ON C.AREA_C_CODE = A.AREA_C_CODE
      ORDER BY A.[ORDER]

    END
  ELSE
    BEGIN

      --// Table[1]
      SELECT A.R_NUM
           , A.LINEADNO
           , A.LINEADID
           , A.INPUT_BRANCH
           , A.LAYOUT_BRANCH
      FROM #AD_MAIN A
    END

  DROP TABLE #AD_MAIN

END


