USE [FINDCONTENTS]
GO
/****** Object:  StoredProcedure [dbo].[_DEL__PUT_F_EBOOK_CLICKLOG_PROC_20191001]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 - 이북보기 클릭 로그
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/02/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/

CREATE PROC [dbo].[_DEL__PUT_F_EBOOK_CLICKLOG_PROC_20191001]
	@SECTIONNM	VARCHAR(20),
	@BRANCHCODE	INT
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	INSERT INTO DBO.EBOOKCOUNT(SECTIONNM, BRANCHCODE) VALUES (@SECTIONNM, @BRANCHCODE)

GO
/****** Object:  StoredProcedure [dbo].[_FINDALL_MAIN_COCOFUN_LIST_BATCH_PROC_20191001]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*********************************************************************
* Description
*
*  내용 :메인 코코펀 쿠폰 리스트 리스트
*  EXEC : exec DBO.FINDALL_MAIN_COCOFUN_LIST_BATCH_PROC 
* 작성자: 정태운
* 작성일: 20100111
*********************************************************************/
CREATE              PROC [dbo].[_FINDALL_MAIN_COCOFUN_LIST_BATCH_PROC_20191001] 
AS
SET NOCOUNT ON

-- 임시 테이블 생성
CREATE TABLE #StoreInfo(
	StoreSeq   INT
,	STORE_NAME VARCHAR(200)
,	CATEGORY2  INT
,  IMG_URL    VARCHAR(200)
,  CITY_CODE  INT
)

-- 임시 테이블 데이터 넣기
INSERT INTO #StoreInfo
(
  StoreSeq
, STORE_NAME
, CATEGORY2
, IMG_URL
, CITY_CODE
)

SELECT DISTINCT A.STORE_NO
     ,A.STORE_NAME
     , A.CATEGORY2
     , 'http://file.cocofun.co.kr/filestore/' + REPLACE(STR(A.CITY_CODE, 2), ' ', '0') + REPLACE(STR(A.PLACE_CODE, 2), ' ', '0')  +'/' + REPLACE(STR(A.STORE_NO, 6), ' ', '0')+'/'+(SELECT TOP 1 'IMG02'+RIGHT('00'+CONVERT(VARCHAR(2),IMAGE_NO),2)+'.'+RIGHT(FILE_NAME,LEN(FILE_NAME)-CHARINDEX('.',FILE_NAME)) FROM cocofun.cocofun.dbo.STORE_IMAGE WHERE STORE_NO = A.STORE_NO AND IMAGE_TYPE=2 AND IMAGE_NO != 1)
     , A.CITY_CODE  
FROM cocofun.cocofun.dbo.store A, cocofun.cocofun.dbo.coupon C
WHERE (A.CATEGORY1 = 1)
	AND A.STORE_NO = C.STORE_NO
	AND C.VALI_START <= GETDATE()
	AND C.VALI_END >= GETDATE()
  and C.STORE_NO IN (SELECT STORE_NO FROM cocofun.cocofun.dbo.STORE_IMAGE WHERE IMAGE_TYPE=2 AND IMAGE_NO != 1)

-- 서울 리스트
SELECT TOP 40 StoreSeq
, STORE_NAME
, CASE CATEGORY2
		             WHEN 1 THEN '한식'
		             WHEN 2 THEN '고깃집'
		             WHEN 3 THEN '면류'
		             WHEN 4 THEN '양식'
		             WHEN 5 THEN '중식'
		             WHEN 6 THEN '일식'
		             WHEN 7 THEN '스파게티&피자'
		             WHEN 8 THEN '패밀리 레스토랑'
		             WHEN 9 THEN '세계요리'
		             WHEN 10 THEN '패스트푸드'
		             WHEN 11 THEN '분식'
		             WHEN 12 THEN '퓨전'
		             WHEN 13 THEN '뷔페'
		             WHEN 14 THEN '배달전문'
		             WHEN 15 THEN '기타'
		  END as 'Cat'
, IMG_URL
  
FROM #StoreInfo
WHERE CITY_CODE = 1
ORDER BY NEWID() 

-- 부산 리스트
SELECT TOP 40  StoreSeq
, STORE_NAME
, CASE CATEGORY2
		             WHEN 1 THEN '한식'
		             WHEN 2 THEN '고깃집'
		             WHEN 3 THEN '면류'
		             WHEN 4 THEN '양식'
		             WHEN 5 THEN '중식'
		             WHEN 6 THEN '일식'
		             WHEN 7 THEN '스파게티&피자'
		             WHEN 8 THEN '패밀리 레스토랑'
		             WHEN 9 THEN '세계요리'
		             WHEN 10 THEN '패스트푸드'
		             WHEN 11 THEN '분식'
		             WHEN 12 THEN '퓨전'
		             WHEN 13 THEN '뷔페'
		             WHEN 14 THEN '배달전문'
		             WHEN 15 THEN '기타'
		  END as 'Cat'
, IMG_URL
  
FROM #StoreInfo
WHERE CITY_CODE = 2
ORDER BY NEWID() 

-- 대구 리스트
SELECT TOP 40  StoreSeq
, STORE_NAME
, CASE CATEGORY2
		             WHEN 1 THEN '한식'
		             WHEN 2 THEN '고깃집'
		             WHEN 3 THEN '면류'
		             WHEN 4 THEN '양식'
		             WHEN 5 THEN '중식'
		             WHEN 6 THEN '일식'
		             WHEN 7 THEN '스파게티&피자'
		             WHEN 8 THEN '패밀리 레스토랑'
		             WHEN 9 THEN '세계요리'
		             WHEN 10 THEN '패스트푸드'
		             WHEN 11 THEN '분식'
		             WHEN 12 THEN '퓨전'
		             WHEN 13 THEN '뷔페'
		             WHEN 14 THEN '배달전문'
		             WHEN 15 THEN '기타'
		  END as 'Cat'
, IMG_URL
  
FROM #StoreInfo
WHERE CITY_CODE = 6
ORDER BY NEWID() 

SET NOCOUNT OFF

DROP TABLE dbo.#StoreInfo






GO
/****** Object:  StoredProcedure [dbo].[_pLineToHomeTownDelete_DelAN_20191001]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[_pLineToHomeTownDelete_DelAN_20191001]

AS
---------------------------------------------------------------------------------------------------------------
	-- pLineToHomeTownDelete
	-- pLine 자료를 HomeTown 인터넷 자료에 반영하기 전 신문 자료 Delete  (스케쥴 걸어서 한번에 처리)
	-- 2001. 9.  20
---------------------------------------------------------------------------------------------------------------
	-- 작 성 자 : 김수정
	-- 수 정 자 : 김수정
	-- 수정일자 : 2001. 9. 20
---------------------------------------------------------------------------------------------------------------

BEGIN
BEGIN TRAN
            --오늘 반영되는 지점의 어제 반영했던 신문자료 삭제Q
	-- ① HomeTown
	DELETE FROM FINDDB2.FindContents.dbo.HomeTown
	 WHERE  Flag =  'P'

	IF @@error = 0 
	    COMMIT TRAN
	ELSE
	    ROLLBACK TRAN
END
GO
/****** Object:  StoredProcedure [dbo].[_Proc_KeyWordRemainLog_20191001]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************
	제목		: 키워드 검색 사이트별 미반영 건수 로그 체크 
	작성자	:	박준희  2004-05-31 
*****************************************************************/
CREATE  PROCEDURE [dbo].[_Proc_KeyWordRemainLog_20191001]
AS

SELECT '올' , count(logid) from watcher_log.dbo.kw_klog with(NoLock) ;   --올
SELECT '잡' , count(logid) from finddb4.watcher_log.dbo.kw_klog ;   --잡 
SELECT '오토/업소' , count(logid) from finddb3.watcher_log.dbo.kw_klog ;    --오토/업소 
SELECT '유즈드 ' ,count(logid) from finddb13.watcher_log.dbo.kw_klog;   --유즈드 
SELECT '알바 ' ,count(logid) from finddb5.watcher_log.dbo.kw_klog ;   --알바   
SELECT '하우스 ' ,count(logid) from finddb11.watcher_log.dbo.kw_klog ;   --하우스  



GO
/****** Object:  StoredProcedure [dbo].[_procEventCnt_1008_DelAN_20191001]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[_procEventCnt_1008_DelAN_20191001]
AS
--===============================================================================================
-- 신문자료가 신문벼룩시장, 오토, 잡, 알바에 반영된 건수 계산
-- 작성일 : 2002-10-09
-- 작성자 : 김준범
--===============================================================================================

--항상 어제 등록된 이벤트 건수가 반영됨

-- 설문 이벤트 총건수 (FindAll)
	INSERT INTO FindContents.dbo.EventCnt_1008  (PubDate, CntAll)
	SELECT Convert(varchar(10), Getdate()-1, 120), Count(*)
	FROM	FindDB2.Findcontents.dbo.PollRespondent
	WHERE Convert(varchar(10), RegDate, 120) = Convert(varchar(10), GetDate()-1, 120)

-- 잡 행운메일 발송건수
	UPDATE A
	SET	A.CntJob1 = B.Cnt
	FROM	FindContents.dbo.EventCnt_1008 A,
		(SELECT Count(*) as Cnt 
		FROM	FindDB4.JobCommon.dbo.openevent
		WHERE SiteGbn = 'J' AND CONVERT(varchar(10), RegDate, 120) = CONVERT(varchar(10), GetDate()-1, 120))  B
	WHERE 	A.PubDate	=  Convert(varchar(10), getdate()-1, 120)

-- 잡 베스트 이력서 참여수
	UPDATE A
	SET	A.CntJob2 = B.Cnt
	FROM	FindContents.dbo.EventCnt_1008 A,
		(SELECT Count(*) as Cnt 
		FROM	FindDB4.JobCommon.dbo.openevent
		WHERE SiteGbn = 'J' AND CONVERT(varchar(10), RegDate, 120) = CONVERT(varchar(10), GetDate()-1, 120) and AdId > 0)  B
	WHERE 	A.PubDate	=  Convert(varchar(10), getdate()-1, 120)
-- 알바 행운메일 발송건수
	UPDATE A
	SET	A.CntAlba1 = B.Cnt
	FROM	FindContents.dbo.EventCnt_1008 A,
		(SELECT Count(*) as Cnt 
		FROM	FindDB4.JobCommon.dbo.openevent
		WHERE SiteGbn = 'A' AND CONVERT(varchar(10), RegDate, 120) = CONVERT(varchar(10), GetDate()-1, 120))  B
	WHERE 	A.PubDate	=  Convert(varchar(10), getdate()-1, 120)

-- 알바 베스트 이력서 참여수
	UPDATE A
	SET	A.CntAlba2 = B.Cnt
	FROM	FindContents.dbo.EventCnt_1008 A,
		(SELECT Count(*) as Cnt 
		FROM	FindDB4.JobCommon.dbo.openevent
		WHERE SiteGbn = 'A' AND CONVERT(varchar(10), RegDate, 120) = CONVERT(varchar(10), GetDate()-1, 120) and AdId > 0)  B
	WHERE 	A.PubDate	=  Convert(varchar(10), getdate()-1, 120)


-- 유즈드 중고물품 등록 건수
	UPDATE A
	SET	A.CntUsed = B.Cnt
	FROM	FindContents.dbo.EventCnt_1008 A,
		(SELECT Count(*) as Cnt 
		FROM	 FindDB5.UsedMain.dbo.event021008
		WHERE CONVERT(varchar(10), RegDate, 120) = CONVERT(varchar(10), GetDate()-1, 120))  B
	WHERE 	A.PubDate	=  Convert(varchar(10), getdate()-1, 120)


-- 오토 차량 등록 건수 (AUTO)
	UPDATE A
	SET	A.CntAuto1 = B.Cnt
	FROM	FindContents.dbo.EventCnt_1008 A,
		(SELECT Count(*) as Cnt 
		FROM	FINDDB3.AutoMain.dbo.MyCarInfo
		WHERE (SiteNm <> 'stoo') AND CONVERT(varchar(10), RegDate, 120) = CONVERT(varchar(10), GetDate()-1, 120))  B
	WHERE 	A.PubDate	=  Convert(varchar(10), getdate()-1, 120)

-- 오토 차량 등록 건수 (stoo)
	UPDATE A
	SET	A.CntAuto2 = B.Cnt
	FROM	FindContents.dbo.EventCnt_1008 A,
		(SELECT Count(*) as Cnt 
		FROM	FINDDB3.AutoMain.dbo.MyCarInfo
		WHERE (SiteNm = 'stoo') AND CONVERT(varchar(10), RegDate, 120) = CONVERT(varchar(10), GetDate()-1, 120))  B
	WHERE 	A.PubDate	=  Convert(varchar(10), getdate()-1, 120)


-- 오토 유료회원 등록 건수
	UPDATE A
	SET	A.CntAuto3 = B.Cnt
	FROM	FindContents.dbo.EventCnt_1008 A,
		(SELECT Count(*) as Cnt 
		FROM FINDDB3.AutoCommon.dbo.RecommendUser 
		WHERE ChargeOk='Y' AND  CONVERT(varchar(10), RegDate, 120) = CONVERT(varchar(10), GetDate()-1, 120))  B
	WHERE 	A.PubDate	=  Convert(varchar(10), getdate()-1, 120)
GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_BESTINFO_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	:	ADMIN_FA_BESTINFO_INSERT_PROC
 설명	:	베스트인포 등록
 작성자 : 김 민 석
 작성일	:	2009-12-20
==============================================================================*/
CREATE PROC [dbo].[ADMIN_FA_BESTINFO_INSERT_PROC]

  @MAINYN       Char(1)			    -- 메인게재유무
, @LOCATION     varChar(20)			-- 지역
, @TITLE        Varchar(200)		-- 제목
, @LINKURL      Varchar(100)		-- 링크주소
, @BANNERING    Varchar(100)		-- 배너진행
--, @BANNERED     Varchar(100)		-- 배너마감
, @REGID        Varchar(30)		  -- 등록자


AS

	INSERT INTO FA_BESTINFO_TB
  (MAINYN, LOCATION, TITLE, LINKURL, BANNERING, READ_CNT, REGID, REGDATE, DELYN)
	VALUES
  (
		@MAINYN
		, @LOCATION
		, @TITLE
		, @LINKURL
		, @BANNERING
		--, @BANNERED
    , 0
		, @REGID
		, getdate()
		, 'N'
  )

	IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

	SET NOCOUNT OFF
	RETURN (1)

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_BESTINFO_TB_DEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 베스트인포 삭제
*  EXEC :
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 김 민 석(2010-12-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_BESTINFO_TB_DEL_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
      @NEVENTID         INT
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/
BEGIN TRAN

UPDATE DBO.FA_BESTINFO_TB SET
	DELYN = 'Y'
 WHERE EVENT_ID = @NEVENTID

IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		ROLLBACK TRAN
	END

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF
COMMIT TRAN

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_BESTINFO_TB_INFO_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Work History
*
*	1) 김 민 석(2010-12-21) : 베스트인포 수정폼
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_BESTINFO_TB_INFO_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
 	@NEVENTID              INT
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/
SELECT MAINYN
  , LOCATION
  , TITLE
  , LINKURL
  , BANNERING
  , BANNERED
  , REGDATE
FROM FA_BESTINFO_TB
WHERE EVENT_ID = @NEVENTID


/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_BESTINFO_TB_LIST_CNT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* DESCRIPTION
*
*  내용 : 베스트인포 리스트
*  EXEC : ADMIN_FA_BESTINFO_TB_LIST_CNT_PROC
*********************************************************************/
/*********************************************************************
* WORK HISTORY
*
*	1) 김 민 석 (2010-12-17) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_BESTINFO_TB_LIST_CNT_PROC]
/*********************************************************************
* INTERFACE PART
*********************************************************************/
(
  	@STRLOCATION	    CHAR(1)
, 	@STRMAINYN        CHAR(1)				=	''
,   @STRKEY           CHAR(1)				=	''
,   @STRWORD					VARCHAR(100)	=	''

)
AS
SET NOCOUNT ON

/*********************************************************************
* IMPLEMENTATION PART
*********************************************************************/

DECLARE @STRSQL			NVARCHAR(4000)
DECLARE @STRSQLSUB	NVARCHAR(3000)

SET @STRSQLSUB = ''

IF @STRLOCATION <> '' OR @STRMAINYN <>'' OR @STRWORD <> '' BEGIN

    IF @STRLOCATION <> ''
      SET @STRSQLSUB = @STRSQLSUB+' AND LOCATION LIKE ''%'+@STRLOCATION+'%''  '

    IF @STRMAINYN <> ''
      SET @STRSQLSUB = @STRSQLSUB+' AND MAINYN ='''+@STRMAINYN+''''

    IF @STRWORD <> '' BEGIN
      IF @STRKEY = '' BEGIN
         SET @STRSQLSUB = @STRSQLSUB+' AND (TITLE LIKE ''%'+@STRWORD+'%''
	                                                   OR CONTS LIKE  ''%'+@STRWORD+'%'')'
      END ELSE IF  @STRKEY = '1' BEGIN
         SET @STRSQLSUB = @STRSQLSUB+' AND TITLE LIKE ''%'+@STRWORD+'%''  '
      END ELSE IF  @STRKEY = '2' BEGIN
         SET @STRSQLSUB = @STRSQLSUB+' AND CONTS LIKE ''%'+@STRWORD+'%''  '
      END
    END
END

SET @STRSQL='SELECT COUNT(1) FROM FA_BESTINFO_TB (NOLOCK) WHERE DELYN=' + '''N''' +@STRSQLSUB

EXECUTE SP_EXECUTESQL @STRSQL
/*********************************************************************
* END OF LSP
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_BESTINFO_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* DESCRIPTION
*
*  내용 : 베스트인포 리스트
*  EXEC : ADMIN_FA_BESTINFO_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* WORK HISTORY
*
*	1) 김 민 석(2010-12-17) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_BESTINFO_TB_LIST_PROC]
/*********************************************************************
* INTERFACE PART
*********************************************************************/
(
  	@STRLOCATION	  CHAR(1)
, 	@STRMAINYN      CHAR(1)				=	''
,  	@STRKEY         CHAR(1)				=	''
,  	@STRWORD			  VARCHAR(100)	=	''
,   @NTOP		        INT	-- 총갯수


)
AS
SET NOCOUNT ON

/*********************************************************************
* IMPLEMENTATION PART
*********************************************************************/

DECLARE @STRSQL			NVARCHAR(4000)
DECLARE @STRSQLSUB	NVARCHAR(3000)

SET @STRSQLSUB = ''

IF @STRLOCATION <> '' OR @STRMAINYN <>'' OR @STRWORD <> '' BEGIN

    IF @STRLOCATION <> ''
      SET @STRSQLSUB = @STRSQLSUB+' AND LOCATION LIKE ''%'+@STRLOCATION+'%''  '

    IF @STRMAINYN <> ''
      SET @STRSQLSUB = @STRSQLSUB+' AND MAINYN ='''+@STRMAINYN+''''

    IF @STRWORD <> '' BEGIN
      SET @STRSQLSUB = @STRSQLSUB+' AND TITLE LIKE ''%'+@STRWORD+'%''  '
    END
END



-- 이벤트 리스트
SET @STRSQL =	'SELECT TOP '+ CAST(@NTOP AS NVARCHAR(10)) +'
                  EVENT_ID
          			, REGDATE
          			, TITLE
                , READ_CNT
          			, MAINYN
          			,LOCATION
	 	 FROM FA_BESTINFO_TB
		 WHERE DELYN =' + '''N''' +
		@STRSQLSUB +
		 'ORDER BY EVENT_ID DESC'

EXECUTE SP_EXECUTESQL @STRSQL
/*********************************************************************
* END OF LSP
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_BESTINFO_TB_MAINBANNER_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 베스트인포 메인적용하기
*  EXEC : ADMIN_FA_BESTINFO_TB_MAINBANNER_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 김 민 석 (2010-12-20) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_BESTINFO_TB_MAINBANNER_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
 	@strLocation              CHAR(1)
)
AS
SET NOCOUNT ON

declare		@sql		NVARCHAR(1000)
set @sql = ''
/*********************************************************************
* Implementation Part
*********************************************************************/

set @sql = '
SELECT TOP 5
  BANNERING
, BANNERED
, LINKURL
, EVENT_ID
FROM FA_BESTINFO_TB
WHERE DELYN = ''N' + '''' + '
  AND MAINYN = ''Y' + '''' + '
  AND LOCATION LIKE  ''%' + @strLocation + '%''' +
' ORDER BY EVENT_ID DESC '


EXECUTE SP_EXECUTESQL @sql
/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_BESTINFO_TB_MODIFY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	:	ADMIN_FA_BESTINFO_TB_MODIFY_PROC
 설명	:	베스트인포 수정
작성자    :   김 민 석
작성일	:	2010-12-21
==============================================================================*/
CREATE PROC [dbo].[ADMIN_FA_BESTINFO_TB_MODIFY_PROC]

  @NEVENTID	  INT			-- 이벤트ID
, @MAINYN     CHAR(1)			-- 메인게재유무
, @LOCATION	  VARCHAR(20)		-- 지역
, @TITLE      VARCHAR(200)		--제목
, @LINKURL    VARCHAR(100)		-- 링크주소
, @BANNERING  VARCHAR(100)		-- 배너진행
--, @BANNERED   VARCHAR(100)		--배너마감
, @REGID      VARCHAR(30)		--등록자


AS

	UPDATE FA_BESTINFO_TB SET
    MAINYN = @MAINYN
  , LOCATION = @LOCATION
  , TITLE = @TITLE
  , LINKURL = @LINKURL
  , BANNERING = @BANNERING
  --, BANNERED = @BANNERED
  , REGID = @REGID
	WHERE EVENT_ID = @NEVENTID


	IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

	SET NOCOUNT OFF
	RETURN (1)

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_CUSTOMER_EVENT_201002_TB_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 20주년 앙케이트 이벤트 리스트엑셀
*  EXEC : DBO.ADMIN_FA_CUSTOMER_EVENT_201002_TB_LIST_EXCEL_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/01/27) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_CUSTOMER_EVENT_201002_TB_LIST_EXCEL_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

SELECT IDX
  , USERID
  , USERNM
  , USERAGE
  , POST
  , ADDR
  , EMAIL
  , JOB
  , TEL

  , ITEM1
  , ITEM2
  , ITEM3
  , ITEM4
  , ITEM5
  , ITEM6
  , ANSWER1
  , REG_DT
  FROM FA_CUSTOMER_EVENT_201002_TB
 ORDER BY IDX ASC


/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_CUSTOMER_EVENT_201002_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 20주년 앙케이트 이벤트 리스트
*  EXEC : DBO.ADMIN_CM_DISTRIBUTION_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009/12/21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_CUSTOMER_EVENT_201002_TB_LIST_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@n4Page		        INT
,    	@n2PageSize       SMALLINT
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(2000)

SET @strSQLSUB = ''

SET @strSQL='SELECT COUNT(IDX)  FROM FA_CUSTOMER_EVENT_201002_TB (NOLOCK) '


IF @n4Page = 1 BEGIN
  	set	Rowcount	@n2PageSize
   SET @strSQL= @strSQL+'select IDX
                                , USERID
                                , USERNM
                                , USERAGE
                                , POST
                                , ADDR
                                , EMAIL
                                , JOB
                                , TEL
                                , ITEM1
                                , ITEM2
                                , ITEM3
                                , ITEM4
                                , ITEM5
                                , ITEM6
                                , ANSWER1
                                , REG_DT
						   FROM FA_CUSTOMER_EVENT_201002_TB  ORDER BY IDX ASC'

END ELSE BEGIN
	SET @strSQL= @strSQL+'
	DECLARE	@PrevCount	  INT
	DECLARE	@n4ID      		INT

	SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'

	SET	RowCount	@PrevCount

	SELECT	@n4ID = IDX
	   FROM FA_CUSTOMER_EVENT_201002_TB (NOLOCK) ORDER BY IDX ASC

	SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'

	SELECT IDX
        , USERID
        , USERNM
        , USERAGE
        , POST
        , ADDR
        , EMAIL
        , JOB
        , TEL
        , ITEM1
        , ITEM2
        , ITEM3
        , ITEM4
        , ITEM5
        , ITEM6
        , ANSWER1
        , REG_DT
	   FROM FA_CUSTOMER_EVENT_201002_TB (NOLOCK) WHERE IDX >  @n4ID ORDER BY IDX ASC'
END

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_CUSTOMER_EVENT_201004_TB_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 앙케이트 이벤트 리스트4월_엑셀
*  EXEC  DBO.ADMIN_FA_CUSTOMER_EVENT_201004_TB_LIST_EXCEL_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/01/27) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_CUSTOMER_EVENT_201004_TB_LIST_EXCEL_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

SELECT IDX
, USERID
, USERNM
, TEL
, ADDR
, EMAIL
, ISNULL(CONVERT(VARCHAR(1),JOB),'0')
, SEX
, AGE
, SUBSCRIBE
, ISNULL(CONVERT(VARCHAR(1),ANSWER1),'')

, ISNULL(CONVERT(VARCHAR(1),ANSWER2),'')
, ISNULL(CONVERT(VARCHAR(1),ANSWER3),'')
, ISNULL(CONVERT(VARCHAR(1),ANSWER4),'')
, ISNULL(CONVERT(VARCHAR(1),ANSWER5),'')
, ISNULL(CONVERT(VARCHAR(1),ANSWER6),'')

, ISNULL(CONVERT(VARCHAR(1),ANSWER7),'')
, ISNULL(CONVERT(VARCHAR(1),ANSWER8),'')
, REG_DT
FROM FA_CUSTOMER_EVENT_201004_TB  ORDER BY IDX ASC


/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_CUSTOMER_EVENT_201004_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 앙케이트 이벤트 리스트4월
*  EXEC  DBO.ADMIN_FA_CUSTOMER_EVENT_201004_TB_LIST_PROC  1,20
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/04/14) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_CUSTOMER_EVENT_201004_TB_LIST_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@n4Page		        INT
,    	@n2PageSize       SMALLINT
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(2000)

SET @strSQLSUB = ''

SET @strSQL='SELECT COUNT(IDX)  FROM FA_CUSTOMER_EVENT_201004_TB (NOLOCK) '


IF @n4Page = 1 BEGIN
  	set	Rowcount	@n2PageSize
   SET @strSQL= @strSQL+'SELECT IDX
                                , USERID
                                , USERNM
                                , TEL
                                , ADDR
                                , EMAIL
                                , ISNULL(CONVERT(VARCHAR(1),JOB),''0'')
                                , SEX
                                , AGE
                                , SUBSCRIBE
                                , ISNULL(CONVERT(VARCHAR(1),ANSWER1),'''')
                                , ISNULL(CONVERT(VARCHAR(1),ANSWER2),'''')
                                , ISNULL(CONVERT(VARCHAR(1),ANSWER3),'''')
                                , ISNULL(CONVERT(VARCHAR(1),ANSWER4),'''')
                                , ISNULL(CONVERT(VARCHAR(1),ANSWER5),'''')
                                , ISNULL(CONVERT(VARCHAR(1),ANSWER6),'''')
                                , ISNULL(CONVERT(VARCHAR(1),ANSWER7),'''')
                                , ISNULL(CONVERT(VARCHAR(1),ANSWER8),'''')
                                , REG_DT
						   FROM FA_CUSTOMER_EVENT_201004_TB  ORDER BY IDX ASC'

END ELSE BEGIN
	SET @strSQL= @strSQL+'
	DECLARE	@PrevCount	  INT
	DECLARE	@n4ID      		INT

	SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'

	SET	RowCount	@PrevCount

	SELECT	@n4ID = IDX
	   FROM FA_CUSTOMER_EVENT_201004_TB (NOLOCK) ORDER BY IDX ASC

	SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'

	SELECT IDX
        , USERID
        , USERNM
        , TEL
        , ADDR
        , EMAIL
        , ISNULL(CONVERT(VARCHAR(1),JOB),''0'')
        , SEX
        , AGE
        , SUBSCRIBE
        , ISNULL(CONVERT(VARCHAR(1),ANSWER1),'''')
        , ISNULL(CONVERT(VARCHAR(1),ANSWER2),'''')
        , ISNULL(CONVERT(VARCHAR(1),ANSWER3),'''')
        , ISNULL(CONVERT(VARCHAR(1),ANSWER4),'''')
        , ISNULL(CONVERT(VARCHAR(1),ANSWER5),'''')
        , ISNULL(CONVERT(VARCHAR(1),ANSWER6),'''')
        , ISNULL(CONVERT(VARCHAR(1),ANSWER7),'''')
        , ISNULL(CONVERT(VARCHAR(1),ANSWER8),'''')
        , REG_DT
	   FROM FA_CUSTOMER_EVENT_201004_TB (NOLOCK) WHERE IDX >  @n4ID ORDER BY IDX ASC'
END

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_CUSTOMER_EVENT_201005_TB_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 5월 앙케이트 이벤트 리스트엑셀
*  EXEC : DBO.ADMIN_FA_CUSTOMER_EVENT_201005_TB_LIST_EXCEL_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/04/26) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_CUSTOMER_EVENT_201005_TB_LIST_EXCEL_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

SELECT IDX
  , USERID
  , USERNM
  , USERAGE
  , POST
  , ADDR
  , EMAIL
  , JOB
  , TEL

  , ITEM1
  , ITEM2
  , ITEM3
  , ITEM4
  , ITEM5
  , ITEM6
  , ITEM7
  , ANSWER1
  , REG_DT
  FROM FA_CUSTOMER_EVENT_201005_TB
 ORDER BY IDX ASC


/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_CUSTOMER_EVENT_201005_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* DESCRIPTION
*
*  내용 : 5월 앙케이트 이벤트 리스트
*  EXEC : DBO.ADMIN_FA_CUSTOMER_EVENT_201005_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* WORK HISTORY
*
*	1) 정태운(2009/12/21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_CUSTOMER_EVENT_201005_TB_LIST_PROC]
(
     	@N4PAGE		        INT
,    	@N2PAGESIZE       SMALLINT
)
AS
SET NOCOUNT ON

DECLARE @STRSQL		NVARCHAR(4000)
DECLARE @STRSQLSUB	NVARCHAR(2000)

SET @STRSQLSUB = ''

SET @STRSQL='SELECT COUNT(IDX)  FROM FA_CUSTOMER_EVENT_201005_TB (NOLOCK) '


IF @N4PAGE = 1
BEGIN
  SET ROWCOUNT	@N2PAGESIZE
  SET @STRSQL= @STRSQL+'SELECT IDX
                                , USERID
                                , USERNM
                                , USERAGE
                                , POST
                                , ADDR
                                , EMAIL
                                , JOB
                                , TEL
                                , ITEM1
                                , ITEM2
                                , ITEM3
                                , ITEM4
                                , ITEM5
                                , ITEM6
                                , ITEM7
                                , ANSWER1
                                , REG_DT
						   FROM FA_CUSTOMER_EVENT_201005_TB  ORDER BY IDX ASC'

END
ELSE
BEGIN
	SET @STRSQL= @STRSQL+'
	DECLARE	@PREVCOUNT	  INT
	DECLARE	@N4ID      		INT

	SET	@PREVCOUNT	=	('+CAST(@N4PAGE AS VARCHAR(4))+' - 1)	*	'+CAST(@N2PAGESIZE AS CHAR(2))+'

	SET	ROWCOUNT	@PREVCOUNT

	SELECT	@N4ID = IDX
	   FROM FA_CUSTOMER_EVENT_201005_TB (NOLOCK) ORDER BY IDX ASC

	SET	ROWCOUNT	'+CAST(@N2PAGESIZE AS CHAR(2))+'

	SELECT IDX
        , USERID
        , USERNM
        , USERAGE
        , POST
        , ADDR
        , EMAIL
        , JOB
        , TEL
        , ITEM1
        , ITEM2
        , ITEM3
        , ITEM4
        , ITEM5
        , ITEM6
        , ITEM7
        , ANSWER1
        , REG_DT
	   FROM FA_CUSTOMER_EVENT_201005_TB (NOLOCK) WHERE IDX >  @N4ID ORDER BY IDX ASC'
END
--PRINT @STRSQL
EXECUTE SP_EXECUTESQL @STRSQL

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_CUSTOMER_EVENT_201007_TB_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*  작성자 : 정태운(2010/01/27) : 신규작성
*  내  용 : 앙케이트 이벤트 리스트7월_엑셀
*  EXEC  DBO.ADMIN_FA_CUSTOMER_EVENT_201007_TB_LIST_EXCEL_PROC
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_CUSTOMER_EVENT_201007_TB_LIST_EXCEL_PROC]
AS
SET NOCOUNT ON

SELECT
  IDX
, SEX
, AGE
, JOB
, PLACE
, ISNULL(CONVERT(VARCHAR(1),ANSWER1),'''')
, ISNULL(CONVERT(VARCHAR(1),ANSWER2),'''')
, ISNULL(CONVERT(VARCHAR(1),ANSWER3),'''')
, ISNULL(CONVERT(VARCHAR(1),ANSWER4),'''')
, ISNULL(CONVERT(VARCHAR(1),ANSWER5),'''')
, ISNULL(CONVERT(VARCHAR(1),ANSWER6),'''')

, ANSWER3_D
, ANSWER4_D
, ANSWER5_D
, ANSWER6_D
, REG_DT
  FROM FA_CUSTOMER_EVENT_201007_TB  ORDER BY IDX ASC

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_CUSTOMER_EVENT_201007_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*  작성자 : 정태운(2010/06/24) : 신규작성
*  내  용 : 앙케이트 이벤트 리스트4월
*  EXEC  DBO.ADMIN_FA_CUSTOMER_EVENT_201007_TB_LIST_PROC  1,20
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_CUSTOMER_EVENT_201007_TB_LIST_PROC]
(
     	@n4Page		        INT
,    	@n2PageSize       SMALLINT
)
AS
SET NOCOUNT ON

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(2000)

SET @strSQLSUB = ''

SET @strSQL='SELECT COUNT(IDX)  FROM FA_CUSTOMER_EVENT_201007_TB (NOLOCK) '


IF @n4Page = 1 BEGIN
  	set	Rowcount	@n2PageSize
   SET @strSQL= @strSQL+'SELECT IDX
                              , SEX
                              , AGE
                              , JOB
                              , PLACE
                              , ISNULL(CONVERT(VARCHAR(1),ANSWER1),'''')
                              , ISNULL(CONVERT(VARCHAR(1),ANSWER2),'''')
                              , ISNULL(CONVERT(VARCHAR(1),ANSWER3),'''')
                              , ISNULL(CONVERT(VARCHAR(1),ANSWER4),'''')
                              , ISNULL(CONVERT(VARCHAR(1),ANSWER5),'''')
                              , ISNULL(CONVERT(VARCHAR(1),ANSWER6),'''')

                              , ANSWER3_D
                              , ANSWER4_D
                              , ANSWER5_D
                              , ANSWER6_D
                              , REG_DT
						   FROM FA_CUSTOMER_EVENT_201007_TB  ORDER BY IDX ASC'

END ELSE BEGIN
	SET @strSQL= @strSQL+'
	DECLARE	@PrevCount	  INT
	DECLARE	@n4ID      		INT

	SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'

	SET	RowCount	@PrevCount

	SELECT	@n4ID = IDX
	   FROM FA_CUSTOMER_EVENT_201007_TB (NOLOCK) ORDER BY IDX ASC

	SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'

	SELECT IDX
      , SEX
      , AGE
      , JOB
      , PLACE
      , ISNULL(CONVERT(VARCHAR(1),ANSWER1),'''')
      , ISNULL(CONVERT(VARCHAR(1),ANSWER2),'''')
      , ISNULL(CONVERT(VARCHAR(1),ANSWER3),'''')
      , ISNULL(CONVERT(VARCHAR(1),ANSWER4),'''')
      , ISNULL(CONVERT(VARCHAR(1),ANSWER5),'''')
      , ISNULL(CONVERT(VARCHAR(1),ANSWER6),'''')

      , ANSWER3_D
      , ANSWER4_D
      , ANSWER5_D
      , ANSWER6_D
      , REG_DT
	   FROM FA_CUSTOMER_EVENT_201007_TB (NOLOCK) WHERE IDX >  @n4ID ORDER BY IDX ASC'
END

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_CUSTOMER_EVENT_201008_TB_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 8월 앙케이트 이벤트 리스트엑셀
*  EXEC : DBO.ADMIN_FA_CUSTOMER_EVENT_201008_TB_LIST_EXCEL_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/07/30) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_CUSTOMER_EVENT_201008_TB_LIST_EXCEL_PROC]
AS
SET NOCOUNT ON

SELECT IDX
  , USERID
  , USERNM
  , USERAGE
  , POST
  , ADDR
  , EMAIL
  , JOB
  , TEL

  , ITEM1
  , ITEM2
  , ITEM3
  , ITEM4
  , ITEM5
  , ITEM6
  , ITEM7
  , ITEM8
  , ANSWER1
  , REG_DT
  FROM FA_CUSTOMER_EVENT_201008_TB
 ORDER BY IDX ASC

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_CUSTOMER_EVENT_201008_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 8월 앙케이트 이벤트 리스트
*  EXEC : DBO.ADMIN_FA_CUSTOMER_EVENT_201008_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/07/30) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_CUSTOMER_EVENT_201008_TB_LIST_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@n4Page		        INT
,    	@n2PageSize       SMALLINT
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(2000)

SET @strSQLSUB = ''

SET @strSQL='SELECT COUNT(IDX)  FROM FA_CUSTOMER_EVENT_201008_TB (NOLOCK) '


IF @n4Page = 1 BEGIN
  	set	Rowcount	@n2PageSize
   SET @strSQL= @strSQL+'select IDX
                                , USERID
                                , USERNM
                                , USERAGE
                                , POST
                                , ADDR
                                , EMAIL
                                , JOB
                                , TEL
                                , ITEM1
                                , ITEM2
                                , ITEM3
                                , ITEM4
                                , ITEM5
                                , ITEM6
                                , ITEM7
                                , ITEM8
                                , ANSWER1
                                , REG_DT
						   FROM FA_CUSTOMER_EVENT_201008_TB  ORDER BY IDX ASC'

END ELSE BEGIN
	SET @strSQL= @strSQL+'
	DECLARE	@PrevCount	  INT
	DECLARE	@n4ID      		INT

	SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'

	SET	RowCount	@PrevCount

	SELECT	@n4ID = IDX
	   FROM FA_CUSTOMER_EVENT_201008_TB (NOLOCK) ORDER BY IDX ASC

	SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'

	SELECT IDX
        , USERID
        , USERNM
        , USERAGE
        , POST
        , ADDR
        , EMAIL
        , JOB
        , TEL
        , ITEM1
        , ITEM2
        , ITEM3
        , ITEM4
        , ITEM5
        , ITEM6
        , ITEM7
        , ITEM8
        , ANSWER1
        , REG_DT
	   FROM FA_CUSTOMER_EVENT_201008_TB (NOLOCK) WHERE IDX >  @n4ID ORDER BY IDX ASC'
END

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_EVENT_TB_DEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 이벤트 삭제
*  EXEC :
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_EVENT_TB_DEL_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
      @nEventID         INT
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/
BEGIN TRAN

UPDATE FA_EVENT_TB SET
	DelYN = 'Y'
 WHERE EventId = @nEventID

IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		ROLLBACK TRAN
	END

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF
COMMIT TRAN

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_EVENT_TB_INFO_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
* EXEC ADMIN_FA_EVENT_TB_INFO_PROC 156
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_EVENT_TB_INFO_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
 	@nEventID              INT
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/
	SELECT
MainYN
,Location
,title
,Conts
,dtSDate
,dtEDate
,EventYN
,LinkUrl
,BannerIng
,Bannered
,DtPreDate
,regdate
	  FROM FA_EVENT_TB
	WHERE EventId = 	@nEventID


/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

--select * from fa_event_tb

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_Event_Tb_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	:	ADMIN_FA_Event_Tb_INSERT_PROC
 설명	:	이벤트 등록
작성자    :             정태운
작성일	:	2009-10-19
==============================================================================*/
CREATE PROC [dbo].[ADMIN_FA_Event_Tb_INSERT_PROC]

@MainYN           	CHAR(1)			    -- 메인게재유무
,@Location         	VARCHAR(20)			-- 지역
,@title            	VARCHAR(200)		-- 제목
,@Conts             VARCHAR(4000)		-- 내용

,@dtSDate           DATETIME		    --기간 시작
,@dtEDate           DATETIME		    --기간 끝
,@EventYN           CHAR(1)			    -- 이벤트진행YN
,@LinkUrl           VARCHAR(200)		-- 링크주소
,@BannerIng         VARCHAR(100)		-- 배너진행

,@BannerEd          VARCHAR(100)	  -- 배너마감
,@DtPreDate         DATETIME		    -- 발표일
,@regID             VARCHAR(30)		  -- 등록자


AS

	INSERT INTO FA_Event_Tb
	VALUES	(
		@MainYN
		,@Location
		,@title
		,@Conts

		,@dtSDate
		,@dtEDate
		,@EventYN
		,@LinkUrl
		,@BannerIng

		,@BannerEd
		,@DtPreDate
		,@regID
		,GETDATE()
		,'N'
		,0)

	IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

	SET NOCOUNT OFF
	RETURN (1)

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_EVENT_TB_LIST_CNT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 이벤트 리스트
*  EXEC : ADMIN_FA_EVENT_TB_LIST_CNT_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_EVENT_TB_LIST_CNT_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  	@strLocation	    CHAR(1)
, 	@strMainYn        CHAR(1)				=	''
,   @strKey           CHAR(1)				=	''
,   @strWord					VARCHAR(100)	=	''

)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(3000)

SET @strSQLSUB = ''

IF @strLocation <> '' OR @strMainYn <>'' OR @strWord <> '' BEGIN

    IF @strLocation <> ''
      SET @strSQLSUB = @strSQLSUB+' AND location LIKE ''%'+@strLocation+'%''  '

    IF @strMainYn <> ''
      SET @strSQLSUB = @strSQLSUB+' AND MainYN ='''+@strMainYn+''''

    IF @strWord <> '' BEGIN
      IF @strKey = '' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND (title LIKE ''%'+@strWord+'%''
	                                                   OR Conts LIKE  ''%'+@strWord+'%'')'
      END ELSE IF  @strKey = '1' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND title LIKE ''%'+@strWord+'%''  '
      END ELSE IF  @strKey = '2' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND Conts LIKE ''%'+@strWord+'%''  '
      END
    END
END

SET @strSQL='SELECT COUNT(*)
                      FROM FA_EVENT_TB (NOLOCK) WHERE delYN=' + '''N''' +@strSQLSUB

EXECUTE SP_EXECUTESQL @strSQL
/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_EVENT_TB_LIST_NEW_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 이벤트 리스트
*  EXEC : ADMIN_FA_EVENT_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_EVENT_TB_LIST_NEW_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  	@strLocation	  CHAR(1)
, 	@strMainYn      CHAR(1)				=	''
,  	@strKey         CHAR(1)				=	''
,  	@strWord			  VARCHAR(100)	=	''
,   @nTop		        INT	-- 총갯수


)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(3000)

SET @strSQLSUB = ''

IF @strLocation <> '' OR @strMainYn <>'' OR @strWord <> '' BEGIN

    IF @strLocation <> ''
      SET @strSQLSUB = @strSQLSUB+' AND location LIKE ''%'+@strLocation+'%''  '

    IF @strMainYn <> ''
      SET @strSQLSUB = @strSQLSUB+' AND MainYN ='''+@strMainYn+''''

    IF @strWord <> '' BEGIN
      IF @strKey = '' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND (title LIKE ''%'+@strWord+'%''
	                                                   OR Conts LIKE  ''%'+@strWord+'%'')'
      END ELSE IF  @strKey = '1' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND title LIKE ''%'+@strWord+'%''  '
      END ELSE IF  @strKey = '2' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND Conts LIKE ''%'+@strWord+'%''  '
      END
    END
END



-- 이벤트 리스트
SET @strSQL =	N'SELECT TOP '+ CAST(@nTop AS NVARCHAR(10)) +'
                  EventId
          			, regdate
          			, title
          			, dtSDate
          			, dtEDate
          			, EventYN
          			, read_cnt
          			, MainYN
          			,Location
	 	 FROM FA_Event_Tb
		 WHERE delYN =' + '''N''' +
		@strSQLSUB +
		 'ORDER BY EventYN DESC, EventId DESC'

EXECUTE SP_EXECUTESQL @strSQL
/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_EVENT_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 이벤트 리스트
*  EXEC : ADMIN_FA_EVENT_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_EVENT_TB_LIST_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
	@strLocation	    CHAR(1)
, 	@strMainYn              CHAR(1)				=	''
,    	@strKey                   CHAR(1)				=	''
,    	@strWord					VARCHAR(100)	=	''
,   	@n4Page					INT
,    	@n2PageSize          SMALLINT

)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(3000)

SET @strSQLSUB = ''

IF @strLocation <> '' OR @strMainYn <>'' OR @strWord <> '' BEGIN

    IF @strLocation <> ''
      SET @strSQLSUB = @strSQLSUB+' AND location LIKE ''%'+@strLocation+'%''  '

    IF @strMainYn <> ''
      SET @strSQLSUB = @strSQLSUB+' AND MainYN ='''+@strMainYn+''''

    IF @strWord <> '' BEGIN
      IF @strKey = '' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND (title LIKE ''%'+@strWord+'%''
	                                                   OR Conts LIKE  ''%'+@strWord+'%'')'
      END ELSE IF  @strKey = '1' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND title LIKE ''%'+@strWord+'%''  '
      END ELSE IF  @strKey = '2' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND Conts LIKE ''%'+@strWord+'%''  '
      END
    END
END

SET @strSQL='SELECT COUNT(*)
                      FROM FA_EVENT_TB (NOLOCK) WHERE delYN=' + '''N''' +@strSQLSUB


IF @n4Page = 1 BEGIN
  	set	Rowcount	@n2PageSize
   SET @strSQL= @strSQL+' select
			EventId
			, regdate
			, title
			, dtSDate
			, dtEDate
			, EventYN
			, read_cnt
			, MainYN
			,Location
			 from FA_Event_Tb
			  where delYN = '+'''N'''+@strSQLSUB+'
                                          order by EventId DESC'
END ELSE BEGIN
	SET @strSQL= @strSQL+'
	DECLARE	@PrevCount			INT
	DECLARE	@n4EventID	INT
	SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'

	SET	RowCount	@PrevCount

   SELECT	@n4EventID = EventId
                       FROM FA_EVENT_TB (NOLOCK) WHERE delYN='+ '''N''' +@strSQLSUB+'
                    ORDER BY EventId DESC

	SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'


   			select
			EventId
			, regdate
			, title
			, dtSDate
			, dtEDate
			, EventYN
			, read_cnt
			, MainYN
			,Location
			 from FA_Event_Tb
 			where EventId< @n4EventID and  delYN = '+ '''N'''+@strSQLSUB+'
                                          order by EventId DESC'
END

EXECUTE SP_EXECUTESQL @strSQL
/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_EVENT_TB_Main_Banner_List_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*********************************************************************
* Description
*
*  내용 : 이벤트 리스트
*  EXEC : ADMIN_FA_EVENT_TB_Main_Banner_List_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FA_EVENT_TB_Main_Banner_List_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
 	@strLocation              CHAR(1)
)
AS
SET NOCOUNT ON

declare		@sql		NVARCHAR(1000)
set @sql = ''
/*********************************************************************
* Implementation Part
*********************************************************************/

set @sql = '
SELECT TOP 5
  BannerIng
, BannerEd
,LinkUrl
,EventID
  FROM fa_event_tb
WHERE delYN = ''N' + '''' + '
     AND EVENTYN = ''Y' + '''' + '
     AND MAinYN = ''Y' + '''' + '
     AND location LIKE  ''%' + @strLocation + '%''' +
' ORDER BY regdate desc '


EXECUTE SP_EXECUTESQL @sql
/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FA_Event_Tb_MODIFY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	:	ADMIN_FA_Event_Tb_MODIFY_PROC
 설명	:	이벤트 수정
작성자    :             정태운
작성일	:	2009-10-20
==============================================================================*/
CREATE PROC [dbo].[ADMIN_FA_Event_Tb_MODIFY_PROC]

@nEventId	int			-- 이벤트ID
,@MainYN           	Char(1)			-- 메인게재유무
,@location	varchar(20)		-- 지역
,@title            	Varchar(200)		--제목
,@Conts             	Varchar(4000)		--내용

,@dtSDate           	datetime		--기간 시작
,@dtEDate           	datetime		--기간 끝
,@EventYN           	Char(1)			-- 이벤트진행YN
,@LinkUrl           	Varchar(200)		-- 링크주소
,@BannerIng        Varchar(100)		-- 배너진행

,@BannerEd         Varchar(100)		--배너마감
,@DtPreDate         datetime		--발표일
,@regID             	Varchar(30)		--등록자


AS

	UPDATE FA_EVENT_TB SET

MainYn = @MainYN
,location = @location
,title = @title
,Conts = @Conts
, dtSDate = @dtSDate
, dtEDate = @dtEDate
, EventYN = @EventYN
, LinkUrl = @LinkUrl
, BannerIng = @BannerIng
, Bannered = @Bannered
, DtPreDate = @DtPreDate
, regID = @regID
	WHERE EventId = @nEventId


	IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

	SET NOCOUNT OFF
	RETURN (1)

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FOOD_SEMINAR_EVENT_201102_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 맛집경영 창업세미나 신청 리스트 엑셀
*  EXEC : DBO.ADMIN_FOOD_SEMINAR_EVENT_201102_LIST_EXCEL_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2011/02/15) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FOOD_SEMINAR_EVENT_201102_LIST_EXCEL_PROC]
AS
SET NOCOUNT ON
SELECT IDX
     , USERID
     , USERNM
     , PHONE
     , HPHONE
     , EMAIL
     , REG_DT
  FROM FOOD_SEMINAR_EVENT_201102
 ORDER BY IDX DESC

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FOOD_SEMINAR_EVENT_201102_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 맛집경영 창업세미나 조회
*  EXEC : DBO.ADMIN_FOOD_SEMINAR_EVENT_201102_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009/12/21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FOOD_SEMINAR_EVENT_201102_LIST_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@n4Page		        INT
,    	@n2PageSize       SMALLINT
)
AS
SET NOCOUNT ON
DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(2000)

SET @strSQLSUB = ''

SET @strSQL='SELECT COUNT(IDX)  FROM FOOD_SEMINAR_EVENT_201102 (NOLOCK) '


IF @n4Page = 1 BEGIN
  	set	Rowcount	@n2PageSize
   SET @strSQL= @strSQL+'select IDX
                                , USERID
                                , USERNM
                                , PHONE
                                , HPHONE
                                , EMAIL
                                , REG_DT
						   FROM FOOD_SEMINAR_EVENT_201102  ORDER BY IDX DESC'

END ELSE BEGIN
	SET @strSQL= @strSQL+'
	DECLARE	@PrevCount	  INT
	DECLARE	@n4ID      		INT

	SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'

	SET	RowCount	@PrevCount

	SELECT	@n4ID = IDX
	   FROM FOOD_SEMINAR_EVENT_201102 (NOLOCK) ORDER BY IDX DESC

	SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'

	SELECT IDX
       , USERID
       , USERNM
       , PHONE
       , HPHONE
       , EMAIL
       , REG_DT
	   FROM FOOD_SEMINAR_EVENT_201102 (NOLOCK) WHERE IDX >  @n4ID ORDER BY IDX DESC'
END

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FOOD_SEMINAR_EVENT_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 맛집경영 창업세미나 신청 리스트 엑셀
*  EXEC : DBO.ADMIN_FOOD_SEMINAR_EVENT_LIST_EXCEL_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 김문화(2011/05/13) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FOOD_SEMINAR_EVENT_LIST_EXCEL_PROC]
(
     	@strEventDiv		        CHAR(6)
)
AS
SET NOCOUNT ON
SELECT IDX
     , USERID
     , USERNM
     , PHONE
     , HPHONE
     , EMAIL
     , REG_DT
  FROM FOOD_SEMINAR_EVENT
  WHERE EVENT_DIV = @strEventDiv

 ORDER BY IDX DESC

GO
/****** Object:  StoredProcedure [dbo].[ADMIN_FOOD_SEMINAR_EVENT_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*********************************************************************
* Description
*
*  내용 : 맛집경영 창업세미나 조회
*  EXEC : DBO.ADMIN_FOOD_SEMINAR_EVENT_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 김문화(2009/12/21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[ADMIN_FOOD_SEMINAR_EVENT_LIST_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@n4Page		        INT
,    	@n2PageSize       SMALLINT
,     @strEventDiv      CHAR(6)
)
AS
SET NOCOUNT ON
DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(2000)

SET @strSQLSUB = ''

SET @strSQL='SELECT COUNT(IDX)  FROM FOOD_SEMINAR_EVENT (NOLOCK) WHERE EVENT_DIV = ''' + @strEventDiv + ''' '


IF @n4Page = 1 BEGIN
  	set	Rowcount	@n2PageSize
   SET @strSQL= @strSQL+'select IDX
                                , USERID
                                , USERNM
                                , PHONE
                                , HPHONE
                                , EMAIL
                                , REG_DT
                                , EVENT_DIV
						   FROM FOOD_SEMINAR_EVENT WHERE EVENT_DIV = ''' + @strEventDiv + '''
               ORDER BY IDX DESC'

END ELSE BEGIN
	SET @strSQL= @strSQL+'
	DECLARE	@PrevCount	  INT
	DECLARE	@n4ID      		INT

	SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'

	SET	RowCount	@PrevCount

	SELECT	@n4ID = IDX
	   FROM FOOD_SEMINAR_EVENT (NOLOCK) WHERE EVENT_DIV = ''' + @strEventDiv + '''
     ORDER BY IDX DESC

   SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'

	SELECT IDX
       , USERID
       , USERNM
       , PHONE
       , HPHONE
       , EMAIL
       , REG_DT
       ,  EVENT_DIV
	   FROM FOOD_SEMINAR_EVENT (NOLOCK) WHERE IDX <  @n4ID AND EVENT_DIV = ''' + @strEventDiv + '''
     ORDER BY IDX DESC'
END

EXECUTE SP_EXECUTESQL @strSQL
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[BAT_FA_MAINTOTALCNT_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	:	ADMIN_FA_BESTINFO_INSERT_PROC
 설명	:	클릭(노출)카운트 통계 정보 업데이트 BAT_FA_MAINTOTALCNT_INSERT_PROC
 작성자 : 정헌수
 작성일	:	2015-10-03
==============================================================================*/
CREATE PROC [dbo].[BAT_FA_MAINTOTALCNT_INSERT_PROC]
AS
INSERT INTO FA_MAINTOTALCNT (SECTIONNM, FLAG, REGDATE, CLICKCNT,IpCnt)

SELECT 
B.SECTIONNM
,S.FLAG
,S.REGDATE
,SUM(CLICKCNT) as CLICKCNT
,COUNT(*) as IpCnt
FROM (
SELECT
	 A.FLAG
	, CONVERT(VARCHAR(10) 	, A.REGDATE,120) AS REGDATE
	, SUM(CLICKCNT) AS CLICKCNT
	, IP 
  FROM FA_MAINCOUNT A WITH(NOLOCK)
 WHERE  LEN(A.FLAG) > 2
   AND A.REGDATE >= DATEADD(D,-1,CONVERT(VARCHAR(10),GETDATE(),120))
   AND A.REGDATE < CONVERT(VARCHAR(10),GETDATE(),120)
 GROUP BY A.SECTIONNM, A.FLAG, CONVERT(VARCHAR(10),A.REGDATE,120),IP
 ) S INNER JOIN  FA_MAINFLAG B WITH(NOLOCK) ON  S.FLAG = B.FLAG
 GROUP BY SECTIONNM,S.FLAG,S.REGDATE
 ORDER BY S.FLAG


DELETE FROM FA_MAINCOUNT
 WHERE REGDATE < DATEADD(D,-7,CONVERT(VARCHAR(10),GETDATE(),120))

 
GO
/****** Object:  StoredProcedure [dbo].[CUID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
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

	UPDATE A SET CUID=@MASTER_CUID FROM AfterBoardRe A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM Anc365Prize2 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM Anc365SubRespondent2 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM BD_LOCALEVENT_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM BD_LOCALNEWS_COMMENT_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM DaeguAniversary A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM EssayComment A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM FA_BUS_EVENT_201009_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM FA_CLEANBOARD_COMMENT_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM FA_CLEANBOARD_RECOMMEND_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM FA_CLEANBOARD_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM FA_CUSTOMER_EVENT_201002_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM FA_CUSTOMER_EVENT_201004_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM FA_CUSTOMER_EVENT_201005_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM FA_CUSTOMER_EVENT_201008_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM FA_RENEW_EVENT_201010_COMMENT_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM FA_RENEW_EVENT_201010_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM FA_RESEARCH_201006_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM FA_SURVEY_ANSWER_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM FOOD_SEMINAR_EVENT A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM JEssayComment A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM LocalNewsComment A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM NESSAYCOMMENT A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM NESSAYCOMMENT_MEMO_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM Paper_Kwd_Excel_User A  where CUID=@SLAVE_CUID
	UPDATE A SET RESUME_CUID=@MASTER_CUID FROM PG_RESUME_READ_BLOCK_TB A  where RESUME_CUID=@SLAVE_CUID
	UPDATE A SET BLOCK_CUID=@MASTER_CUID FROM PG_RESUME_READ_BLOCK_TB A  where BLOCK_CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM ReaderComment2 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM ReaderEvent2 A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM UsrCenter A  where CUID=@SLAVE_CUID


/*
	INSERT PAPER_NEW.DBO.CUID_CHANGE_HISTORY_TB (B_CUID, N_CUID, USERID, DB_NAME, USERIP)
		SELECT @MASTER_CUID , @SLAVE_CUID,@MASTER_USERID,DB_NAME(),@CLIENT_IP
*/		
END







GO
/****** Object:  StoredProcedure [dbo].[DEL_F_ARTICLE_COMMENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 독자참여마당 - 댓글삭제
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[DEL_F_ARTICLE_COMMENT_PROC]
	@SERIAL INT,
	@USERID	VARCHAR(50)
AS

	IF EXISTS(SELECT NULL FROM DBO.READERCOMMENT2(NOLOCK) WHERE	SERIAL=@SERIAL AND USERID=@USERID)
		BEGIN
			DELETE FROM
				DBO.READERCOMMENT2
			WHERE
				SERIAL=@SERIAL AND
				USERID=@USERID
		END

GO
/****** Object:  StoredProcedure [dbo].[DEL_F_ESSAY_COMMENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 댓글삭제
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC	[dbo].[DEL_F_ESSAY_COMMENT_PROC]
	@SERIAL INT,
	@USERID	VARCHAR(50)
AS
  SET NOCOUNT ON
  BEGIN TRAN

	IF EXISTS(SELECT NULL FROM DBO.NESSAYCOMMENT(NOLOCK) WHERE SERIAL = @SERIAL AND USERID = @USERID )
		BEGIN
			DELETE FROM
				DBO.NESSAYCOMMENT
			WHERE
				SERIAL = @SERIAL AND
				USERID = @USERID
		END

  IF @@ERROR <> 0
  	BEGIN
      ROLLBACK TRAN
  		SET NOCOUNT OFF
  	END

  DELETE
      FROM DBO.NESSAYCOMMENT_MEMO_TB
     WHERE SERIAL = @SERIAL
       AND USERID = @USERID

  IF @@ERROR <> 0
    	BEGIN
        ROLLBACK TRAN
    		SET NOCOUNT OFF
    	END

  COMMIT TRAN
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[DEL_F_LOCALEVENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장PLUS - 지역이벤트 글 삭제
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[DEL_F_LOCALEVENT_PROC]
    @SERIAL       INT=0,
    @BOARDCODE    INT=0,
    @CUID         INT = NULL,

    @IRESULT      INT=0 OUTPUT
AS

BEGIN TRAN

    UPDATE DBO.BD_LOCALEVENT_TB
    SET
        DELFLAG='1'
    WHERE
        SERIAL     = @SERIAL AND
        BOARDCODE  = @BOARDCODE AND
        CUID = @CUID

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[DEL_F_LOCALEVENT_PROC_VER2]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장PLUS - 지역이벤트 글 삭제
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : BOARDCODE가 필요없다
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[DEL_F_LOCALEVENT_PROC_VER2]
    @SERIAL       INT=0,
    @BOARDCODE    INT=0,
    @CUID         INT = NULL,
    @IRESULT      INT=0 OUTPUT
AS

BEGIN TRAN

    UPDATE DBO.BD_LOCALEVENT_TB
    SET
        DELFLAG='1'
    WHERE
        SERIAL     = @SERIAL AND
        --BOARDCODE  = @BOARDCODE AND
        CUID = @CUID

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END


GO
/****** Object:  StoredProcedure [dbo].[DEL_F_LOCALNEWS_COMMENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 지역소식 댓글삭제
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC	[dbo].[DEL_F_LOCALNEWS_COMMENT_PROC]
	@SERIAL         INT,
	@USERID	        VARCHAR(50)
AS
BEGIN TRAN

	IF EXISTS(SELECT NULL FROM DBO.BD_LOCALNEWS_COMMENT_TB(NOLOCK) WHERE SERIAL = @SERIAL AND USERID = @USERID )
		BEGIN
			DELETE FROM
				DBO.BD_LOCALNEWS_COMMENT_TB
			WHERE
				SERIAL = @SERIAL AND
				USERID = @USERID
		END

    IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRAN
            SET NOCOUNT OFF
        END


    COMMIT TRAN
    SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[DEL_FA_MAINFLAG_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 로그관리 > FLAG항목 삭제
 *  작   성   자 : 이 경 덕
 *  작   성   일 : 2012-11-27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 :
 *  EXEC : DBO.DEL_FA_MAINFLAG_PROC

 *************************************************************************************/

CREATE PROC [dbo].[DEL_FA_MAINFLAG_PROC]
	    @SERIAL 	INT
AS

BEGIN

 DELETE FROM  DBO.FA_MainFlag
  WHERE Serial = @SERIAL

END

GO
/****** Object:  StoredProcedure [dbo].[DEL_M_BRANCH_BANNER_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배너관리 > 배너 삭제
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2013-02-13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.DEL_M_BRANCH_BANNER_PROC 5
 *************************************************************************************/


CREATE PROC [dbo].[DEL_M_BRANCH_BANNER_PROC]
   @IDX INT
AS

SET NOCOUNT ON

UPDATE FA_BANNER_MANAGE_TB
SET DELF = 1
WHERE IDX = @IDX

GO
/****** Object:  StoredProcedure [dbo].[DEL_M_F_LOCALEVENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트(스도쿠, 포토이벤트) 글 삭제
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[DEL_M_F_LOCALEVENT_PROC]
	@SERIAL       INT = 0,
	@BOARDCODE    INT = 0,
	@CUID         INT = NULL,
	@IRESULT      INT = 0 OUTPUT
AS

BEGIN
	UPDATE FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB
	SET
		DEL_YN = 'Y'
	WHERE
		RE_ID = @SERIAL
		--AND	BOARDCODE = @BOARDCODE
		AND CUID = @CUID

	IF @@ERROR > 1
	BEGIN
		SET @IRESULT = -1
		RETURN
	END
	ELSE
	BEGIN
		SET @IRESULT = 1
		RETURN
	END
END
GO
/****** Object:  StoredProcedure [dbo].[DEL_M_FA_SURVEY_QUESTION_TB_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	 :	DEL_M_FA_SURVEY_QUESTION_TB_PROC
 설명	 :	설문조사 질문 삭제
작성자 :  정태운
작성일 :	2010-10-15
==============================================================================*/
CREATE PROC [dbo].[DEL_M_FA_SURVEY_QUESTION_TB_PROC]
(
  @SURVEY_ID       INT             -- 설문등록번호
)
AS
SET NOCOUNT ON


DELETE FA_SURVEY_QUESTION_TB
 WHERE SURVEY_ID = @SURVEY_ID


IF @@ERROR <> 0
BEGIN
	RETURN (-1)

END

RETURN 1

GO
/****** Object:  StoredProcedure [dbo].[DEL_M_FA_SURVEY_TB_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	 :	DEL_M_FA_SURVEY_TB_PROC
 설명	 :	설문조사 삭제
작성자 :  정태운
작성일 :	2010-10-13
==============================================================================*/
CREATE PROC [dbo].[DEL_M_FA_SURVEY_TB_PROC]
(
  @nSurvey_ID      INT         -- 등록번호
)
AS
SET NOCOUNT ON

UPDATE FA_SURVEY_TB SET
  DEL_YN = 'Y'
, PROGRESS_DIV = 'N'

 WHERE SURVEY_ID = @nSurvey_ID


IF @@ERROR <> 0
BEGIN
	RETURN (-1)
END

RETURN 1

GO
/****** Object:  StoredProcedure [dbo].[DROP_M_ESSAY_COMMMENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 - 글마당 댓글 삭제
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2009/11/23
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.DROP_M_ESSAY_COMMMENT_PROC
 *************************************************************************************/


CREATE PROC [dbo].[DROP_M_ESSAY_COMMMENT_PROC]

  @SERIAL INT
  ,@ORG_SERIAL INT

AS
  SET NOCOUNT ON
  BEGIN TRAN


   DELETE
    FROM DBO.NESSAYCOMMENT
   WHERE SERIAL = @SERIAL
     AND ESSAYSERIAL = @ORG_SERIAL

   IF @@ERROR <> 0
  	BEGIN
      ROLLBACK TRAN
  		SET NOCOUNT OFF
  	END


    DELETE
      FROM DBO.NESSAYCOMMENT_MEMO_TB
     WHERE SERIAL = @SERIAL
       AND ESSAYSERIAL = @ORG_SERIAL


    IF @@ERROR <> 0
  	BEGIN
      ROLLBACK TRAN
  		SET NOCOUNT OFF
  	END

  COMMIT TRAN
  SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_BRANCH_BANNER_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배너관리 > 배너 수정
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2013-02-13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_BRANCH_BANNER_PROC 5
 *************************************************************************************/




CREATE PROC [dbo].[EDIT_M_BRANCH_BANNER_PROC]
   @IDX INT
  ,@INPUT_BRANCH TINYINT
  ,@LOCAL_BRANCH VARCHAR(50)
  ,@BANNER_PATH VARCHAR(100)		--이미지경로
  ,@BANNER_NM VARCHAR(100)		--배너명
  ,@BANNER_GBN CHAR(1)				--배너유형
  ,@BANNER_URL VARCHAR(100)			--배너이동주소
  ,@TARGET TINYINT					--배너타겟(0:본창 1:새창)
  ,@STARTDT DATETIME                --시작일
  ,@ENDDT DATETIME                  --종료일
  ,@DISF  BIT                       --게재여부(0:게재 1:미게재)
  ,@MAGID VARCHAR(20)
AS

SET NOCOUNT ON

UPDATE FA_BANNER_MANAGE_TB
SET
	LOCAL_BRANCH = @LOCAL_BRANCH,
    BANNER_NM    = @BANNER_NM,
    BANNER_PATH  = @BANNER_PATH,
    BANNER_URL   = @BANNER_URL,
    BANNER_GBN   = @BANNER_GBN,
    TARGET       = @TARGET,
    START_DT     = @STARTDT,
    END_DT		 = @ENDDT,
    DISF         = @DISF
WHERE IDX = @IDX

--수정 내역 등록
INSERT INTO FA_BANNER_HISTORY_TB
( BANNER_IDX, INPUT_BRANCH, LOCAL_BRANCH, BANNER_NM, BANNER_PATH, BANNER_URL, BANNER_GBN, TARGET, START_DT, END_DT, DISF, MAINF, DELF, READ_CNT, MAG_ID )
SELECT
  IDX,
  INPUT_BRANCH,
  LOCAL_BRANCH,
  BANNER_NM,
  BANNER_PATH,
  BANNER_URL,
  BANNER_GBN,
  TARGET,
  START_DT,
  END_DT,
  DISF,
  MAINF,
  DELF,
  READ_CNT,
  @MAGID
FROM FA_BANNER_MANAGE_TB
  WHERE IDX = @IDX

GO
/****** Object:  StoredProcedure [dbo].[FA_BESTINFO_COUNT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 베스트인포 카운트
*  EXEC :
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 김 민 석(2011-01-11) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_BESTINFO_COUNT_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
      @EVENT_ID         INT
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/
BEGIN TRAN

UPDATE DBO.FA_BESTINFO_TB SET
	READ_CNT = READ_CNT+1
 WHERE EVENT_ID = @EVENT_ID

IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		ROLLBACK TRAN
	END

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF
COMMIT TRAN

GO
/****** Object:  StoredProcedure [dbo].[FA_BUS_EVENT_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[FA_BUS_EVENT_INSERT_PROC]
       @USERID     VARCHAR(50)
     , @USERNM     VARCHAR(30)
     , @PHONE      VARCHAR(50)
     , @HPHONE     VARCHAR(50)
     , @EMAIL      VARCHAR(100)
     , @ANSWER1    VARCHAR(100)
AS

SET NOCOUNT ON

INSERT dbo.FA_BUS_EVENT_201009_TB
     ( USERID, USERNM, PHONE, HPHONE, EMAIL, ANSWER1)
VALUES
     ( @USERID, @USERNM, @PHONE, @HPHONE, @EMAIL, @ANSWER1)

GO
/****** Object:  StoredProcedure [dbo].[FA_CLEANBOARD_COMMENT_DROP_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 클린캠페인(나만의 노하우) - 댓글 삭제
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/08/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /CleanCampaign/cc_knowhow_comment_delete_proc.asp
EXEC FA_CLEANBOARD_COMMENT_DROP_PROC 1,1,'cbk08'
 *************************************************************************************/


CREATE PROC [dbo].[FA_CLEANBOARD_COMMENT_DROP_PROC]

  @COM_SEQ   INT
  ,@SEQ      INT
  ,@USERID   VARCHAR(50)

AS

  SET NOCOUNT ON

  BEGIN TRAN

    -- 댓글 개수 감소
    UPDATE FA_CLEANBOARD_TB
       SET MEMOCNT = MEMOCNT - 1
     WHERE SEQ = @SEQ

    -- 댓글 삭제
    DELETE
      FROM FA_CLEANBOARD_COMMENT_TB
     WHERE SEQ = @COM_SEQ
       AND HDRSEQ = @SEQ
       AND USERID = @USERID

  COMMIT TRAN

GO
/****** Object:  StoredProcedure [dbo].[FA_CLEANBOARD_COMMENT_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 클린캠페인(나만의 노하우) - 댓글 입력
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/08/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /CleanCampaign/cc_knowhow_comm_proc.asp
EXEC FA_CLEANBOARD_COMMENT_INSERT_PROC 1, 'cbk08', '최봉기','댓글 내용','123.111.230.56'
 *************************************************************************************/


CREATE PROC [dbo].[FA_CLEANBOARD_COMMENT_INSERT_PROC]

  @SEQ       INT
  ,@USERID   VARCHAR(50)
  ,@USERNAME VARCHAR(30)
  ,@COMMENT  VARCHAR(256)
  ,@IPADDR   VARCHAR(15)

AS

  SET NOCOUNT ON

  BEGIN TRAN

    -- 댓글 개수 증가
    UPDATE FA_CLEANBOARD_TB
       SET MEMOCNT = MEMOCNT + 1
     WHERE SEQ = @SEQ

    -- 댓글 내용 저장
    INSERT INTO FA_CLEANBOARD_COMMENT_TB
           (HDRSEQ
           ,USERID
           ,USERNAME
           ,COMMENT
           ,IPADDR)
    VALUES
           (@SEQ
           ,@USERID
           ,@USERNAME
           ,@COMMENT
           ,@IPADDR)

  COMMIT TRAN

GO
/****** Object:  StoredProcedure [dbo].[FA_CLEANBOARD_DROP_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 클린캠페인(나만의 노하우) - 글 삭제
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/08/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /CleanCampaign/cc_knowhow_delete_proc.asp
EXEC FA_CLEANBOARD_DROP_PROC 1,'cbk08'
 *************************************************************************************/


CREATE PROC [dbo].[FA_CLEANBOARD_DROP_PROC]

  @SEQ      INT
  ,@USERID   VARCHAR(50)

AS

  SET NOCOUNT ON

  BEGIN TRAN

    -- 관련 댓글 삭제
    DELETE
      FROM FA_CLEANBOARD_COMMENT_TB
     WHERE HDRSEQ = @SEQ

    -- 댓글 삭제
    DELETE
      FROM FA_CLEANBOARD_TB
     WHERE SEQ = @SEQ
       AND USERID = @USERID

  COMMIT TRAN

GO
/****** Object:  StoredProcedure [dbo].[FA_CLEANBOARD_EDIT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 클린캠페인(나만의 노하우) - 글 삭제
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/08/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /CleanCampaign/cc_knowhow_delete_proc.asp
EXEC FA_CLEANBOARD_EDIT_PROC '글제목','글내용',6
 *************************************************************************************/


CREATE PROC [dbo].[FA_CLEANBOARD_EDIT_PROC]

  @SUBJECT   VARCHAR(200)
  ,@CONTENTS TEXT
  ,@SEQ      INT

AS

  SET NOCOUNT ON

  BEGIN TRAN

    UPDATE FA_CLEANBOARD_TB
       SET SUBJECT = @SUBJECT
          ,CONTENTS = @CONTENTS
          ,MODDATE = GETDATE()
     WHERE SEQ = @SEQ

  COMMIT TRAN

GO
/****** Object:  StoredProcedure [dbo].[FA_CLEANBOARD_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 :
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/08/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /CleanCampaign/cc_knowhow_write_proc.asp
EXEC FA_CLEANBOARD_INSERT_PROC 'cbk08','최봉기','제목','내용','8','1','30','1','5','192.168.8.76'
 *************************************************************************************/


CREATE PROC [dbo].[FA_CLEANBOARD_INSERT_PROC]

  @USERID    VARCHAR(50)
  ,@USERNAME VARCHAR(30)
  ,@SUBJECT  VARCHAR(200)
  ,@CONTENTS TEXT
  ,@REFROM   INT
  ,@RELEVEL  INT
  ,@SEQNO    INT
  ,@RESTEP   INT
  ,@RENO     INT
  ,@IPADDR   VARCHAR(15)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @MAXRESTEP INT
  DECLARE @NRENO INT

  IF @RENO <> '' 	--답변글이 있을 경우

    BEGIN

      SET @NReNo = @RENO

      SELECT @MAXRESTEP = ISNULL(MAX(RESTEP),0) FROM FA_CLEANBOARD_TB WITH (NOLOCK) WHERE RENO = @RENO AND REFROM = @SEQNO

      -- 답글 존재 여부 체크
      IF @MAXRESTEP > 0
         BEGIN
          SET @RESTEP		= @MAXRESTEP + 1
         END
      ELSE
         BEGIN
      	  SET @MAXRESTEP	= @RESTEP
          SET @RESTEP		= @RESTEP + 1
         END

      BEGIN TRAN
        UPDATE FA_CLEANBOARD_TB SET RESTEP = RESTEP+1 WHERE RENO = @RENO AND RESTEP > @MAXRESTEP
      COMMIT TRAN

      SET @RELEVEL = @RELEVEL + 1
      SET @REFROM  = @SEQNO

    END

  ELSE	--신규입력

    BEGIN

  	  SELECT @NRENO = MAX(RENO) FROM FA_CLEANBOARD_TB WITH (NOLOCK)

  	  IF @RENO <> '' OR @NRENO IS NULL
        BEGIN
  	      SET @NRENO = 1
        END
  	  ELSE
        BEGIN
  	      SET @NRENO = @NRENO + 1
        END

  	  SET @REFROM	 = 0
  	  SET @RESTEP	 = 0
  	  SET @RELEVEL   = 0

    END

  BEGIN TRAN

	INSERT INTO FA_CLEANBOARD_TB
	       (USERID
	       ,USERNAME
	       ,SUBJECT
	       ,CONTENTS
	       ,REFROM
	       ,RELEVEL
	       ,SEQNO
	       ,RESTEP
	       ,RENO
	       ,IPADDR)
	VALUES
	       (@USERID
	       ,@USERNAME
	       ,@SUBJECT
	       ,@CONTENTS
	       ,@REFROM
	       ,@RELEVEL
	       ,@SEQNO
	       ,@RESTEP
	       ,@NRENO
	       ,@IPADDR)

  COMMIT TRAN

GO
/****** Object:  StoredProcedure [dbo].[FA_CLEANBOARD_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 클린캠페인(나만의 노하우) - 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/08/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /CleanCampaign/cc_knowhow.asp
EXEC FA_CLEANBOARD_LIST_PROC 1,5,'SUBJECT',''
 *************************************************************************************/


CREATE PROC [dbo].[FA_CLEANBOARD_LIST_PROC]

  @PAGE           INT
  ,@PAGESIZE      INT
  ,@SEARCHFIELD   VARCHAR(10)
  ,@SEARCHKEYWORD VARCHAR(50)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_WHERE NVARCHAR(4000)

  SET @SQL = 'SELECT COUNT(SEQ) AS CNT FROM FA_CLEANBOARD_TB '
  IF @SEARCHKEYWORD <> ''
    SET @SQL = @SQL +'WHERE '+ @SEARCHFIELD +' LIKE ''%'+ @SEARCHKEYWORD +'%'';'

  SET @SQL = @SQL +'SELECT TOP '+ CONVERT(VARCHAR(10), @PAGE * @PAGESIZE) +'
                           SEQ
                          ,RENO
                          ,SUBJECT
                          ,USERNAME
                          ,CONVERT(VARCHAR(10),REGDATE, 102) AS REGDATE
                          ,READCNT
                          ,RECOMCNT
                          ,MEMOCNT
                          ,RELEVEL
                      FROM FA_CLEANBOARD_TB '

  IF @SEARCHKEYWORD <> ''
    SET @SQL = @SQL +' WHERE '+ @SEARCHFIELD +' LIKE ''%'+ @SEARCHKEYWORD +'%'' '

  SET @SQL = @SQL +' ORDER BY RENO DESC, RESTEP ASC'

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[FA_CLEANBOARD_RECOMMEND_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 클린캠페인(나만의 노하우) - 글 추천하기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/08/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /CleanCampaign/cc_knowhow_Recom_Proc.asp
EXEC FA_CLEANBOARD_RECOMMEND_PROC 1,'cbk08','123.111.230.54'
 *************************************************************************************/


CREATE PROC [dbo].[FA_CLEANBOARD_RECOMMEND_PROC]

  @SEQ  INT
  ,@USERID VARCHAR(50)
  ,@IPADDR VARCHAR(15)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @INTCNT INT

  SELECT @INTCNT = ISNULL(COUNT(BOARD_SEQ),0)
    FROM FA_CLEANBOARD_RECOMMEND_TB
   WHERE USERID = @USERID
     AND BOARD_SEQ = @SEQ

  IF @INTCNT = 0
  BEGIN
    BEGIN TRAN

      -- 추천수 증가
      UPDATE FA_CLEANBOARD_TB
         SET RECOMCNT = RECOMCNT + 1
       WHERE SEQ = @SEQ

      -- 추천내역 입력
      INSERT INTO FA_CLEANBOARD_RECOMMEND_TB
             (BOARD_SEQ
             ,USERID
             ,IPADDR)
      VALUES
             (@SEQ
             ,@USERID
             ,@IPADDR)
    COMMIT TRAN
  END

  SELECT @INTCNT AS RESULT

GO
/****** Object:  StoredProcedure [dbo].[FA_CLEANBOARD_VIEW_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 클린캠페인(나만의 노하우) - 내용/댓글 보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/08/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /CleanCampaign/cc_knowhow.asp
EXEC FA_CLEANBOARD_VIEW_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[FA_CLEANBOARD_VIEW_PROC]

  @SEQ  INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN
    UPDATE FA_CLEANBOARD_TB
       SET READCNT = READCNT + 1
     WHERE SEQ = @SEQ
  COMMIT TRAN

  -- 글 내용
  SELECT A.USERID
        ,A.USERNAME
        ,A.SUBJECT
        ,CONVERT(NVARCHAR(4000),A.CONTENTS) AS CONTENTS
        ,A.READCNT
        ,A.RECOMCNT
        ,A.MEMOCNT
        ,CONVERT(VARCHAR(10), REGDATE, 102) AS REGDATE
        ,RENO
        ,REFROM
        ,RELEVEL
        ,RESTEP
    FROM FA_CLEANBOARD_TB AS A
   WHERE SEQ = @SEQ;

  -- 댓글
  SELECT SEQ
        ,USERID
        ,USERNAME
        ,COMMENT
        ,CONVERT(VARCHAR(10), REGDATE, 102) +' '+ CONVERT(VARCHAR(5),REGDATE,108) AS REGDATE
    FROM FA_CLEANBOARD_COMMENT_TB
   WHERE HDRSEQ = @SEQ
   ORDER BY SEQ DESC

GO
/****** Object:  StoredProcedure [dbo].[FA_CLEANBOARD_VIEWLIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 클린캠페인(나만의 노하우) - 글내용보기내 윗글,아랫글 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/08/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : /CleanCampaign/cc_knowhow_view.asp
EXEC FA_CLEANBOARD_VIEWLIST_PROC 7
 *************************************************************************************/


CREATE PROC [dbo].[FA_CLEANBOARD_VIEWLIST_PROC]

  @SEQ      INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 윗글
  SELECT TOP 1
         SEQ
        ,SUBJECT
        ,MEMOCNT
        ,CONVERT(VARCHAR(10), REGDATE, 102) AS REGDATE
    FROM FA_CLEANBOARD_TB
   WHERE SEQ > @SEQ
     AND RESTEP = 0
   ORDER BY SEQ ASC;

  -- 아래글
  SELECT TOP 1
         SEQ
        ,SUBJECT
        ,MEMOCNT
        ,CONVERT(VARCHAR(10), REGDATE, 102) AS REGDATE
    FROM FA_CLEANBOARD_TB
   WHERE SEQ < @SEQ
     AND RESTEP = 0
   ORDER BY SEQ DESC

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201002_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 20주면 앙케이트 이벤트 등록
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/01/27) : 신규작성
*********************************************************************/
CREATE PROC  [dbo].[FA_CUSTOMER_EVENT_201002_TB_INSERT_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  @strUserid   VARCHAR(30)          -- 등록자 아이디
, @strUserNm   VARCHAR(20)          -- 등록자 이름
, @strAge      TINYINT              -- 등록자 연령
, @strPost     CHAR(6)              -- 등록자 우편번호
, @strAddr     VARCHAR(200)         -- 등록자 주소

, @strEmail    VARCHAR(100)         -- 등록자 이메일
, @strJob      TINYINT              -- 등록자 직업
, @strTel      VARCHAR(50)          -- 등록자 연락처
, @strItem1    TINYINT              -- 앙케이트1

, @strItem2    TINYINT              -- 앙케이트2
, @strItem3    TINYINT              -- 앙케이트3
, @strItem4    TINYINT              -- 앙케이트4
, @strItem5    TINYINT              -- 앙케이트5
, @strItem6    TINYINT              -- 앙케이트6
, @StrAnswer1  VARCHAR(2000)        -- 답변1

)
AS
SET NOCOUNT ON
/*********************************************************************
* Implementation Part
*********************************************************************/

INSERT INTO FA_CUSTOMER_EVENT_201002_TB
(
	 USERID
  ,USERNM
  ,USERAGE
  ,POST
  ,ADDR
  ,EMAIL
  ,JOB
  ,TEL
  ,ITEM1
  ,ITEM2
  ,ITEM3
  ,ITEM4
  ,ITEM5
  ,ITEM6
  ,ANSWER1
  ,REG_DT
)
VALUES
(
	 @strUserid
	, @strUserNm
	, @strAge
	, @strPost
	, @strAddr

	, @strEmail
	, @strJob
  , @strTel
	, @strItem1

	, @strItem2
	, @strItem3
	, @strItem4
	, @strItem5
	, @strItem6
	, @StrAnswer1
	, GETDATE()
)
IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

	SET NOCOUNT OFF
	RETURN (1)
/*********************************************************************
* End of lsp
*********************************************************************/

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201002_TB_YN_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 20년기념 앙케이트 참여 여부
*  EXEC : DBO.FA_CUSTOMER_EVENT_201002_TB_YN_PROC 'test'
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/01/27) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_CUSTOMER_EVENT_201002_TB_YN_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
		@strUserID			VARCHAR(30)
)
AS
SET NOCOUNT ON
/*********************************************************************
* Implementation Part
*********************************************************************/

--이미 참여한 회원
SELECT IDX FROM FA_CUSTOMER_EVENT_201002_TB
 WHERE USERID = @strUserID

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201004_TB_ANSWER_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*********************************************************************
* Description
*
*  내용 : 2010-04월 앙케이트 이벤트
*  EXEC  DBO.FA_CUSTOMER_EVENT_201004_TB_ANSWER_PROC 1,1,1
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009/12/21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_CUSTOMER_EVENT_201004_TB_ANSWER_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@nIDX  		        INT
,    	@nAnswerCnt       TINYINT
,     @nAnswer          TINYINT
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL		  	NVARCHAR(4000)
DECLARE @strColNm			NVARCHAR(10)

SET @strSQL = ''
SET @strColNm = ''
SET @strColNm = 'answer' + CAST(@nAnswerCnt AS VARCHAR(2))

SET @strSQL= @strSQL+'
  UPDATE FA_CUSTOMER_EVENT_201004_TB SET
    ' + CAST(@strColNm AS VARCHAR(10)) +  ' = ' + CAST(@nAnswer AS VARCHAR(1)) +  '
   WHERE IDX = ' + CAST(@nIDX AS VARCHAR(4))



--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201004_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*	1) 작성자 : 정태운(2010/04/12)
* 2) 내용   : 20주면 앙케이트 이벤트 등록
*********************************************************************/
/*********************************************************************
* Work History
*

*********************************************************************/
CREATE PROC  [dbo].[FA_CUSTOMER_EVENT_201004_TB_INSERT_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
@strUserid    VARCHAR(30)      -- 아이디
, @strUserNm  VARCHAR(20)      -- 성명
, @strTel     VARCHAR(50)      -- 연락처
, @strAddr    VARCHAR(200)     -- 주소
, @strPost    VARCHAR(6)       -- 우편번호
, @strEmail   VARCHAR(100)     -- 이메일
, @strJob     TINYINT          -- 직종

, @strsex     TINYINT          -- 성별
, @strage     TINYINT          -- 연령
, @strday     TINYINT          -- 구독빈도
, @nIDX       INT        OUTPUT

)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

INSERT INTO FA_CUSTOMER_EVENT_201004_TB
(
  USERID
  , USERNM
  , TEL
  , ADDR
  , POST
  , EMAIL
  , JOB
  , SEX
  , AGE
  , SUBSCRIBE
  , REG_DT
)
VALUES
(
  @strUserid
  , @strUserNm
  , @strTel
  , @strAddr
  , @strPost
  , @strEmail
  , @strJob

  , @strsex
	, @strage
	, @strday
	, GETDATE()
)

IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		SET @nIDX = -1
	END

SELECT TOP 1 @nIDX = IDX
  FROM FA_CUSTOMER_EVENT_201004_TB
 ORDER BY REG_DT DESC

SET NOCOUNT OFF
/*********************************************************************
* End of lsp
*********************************************************************/

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201004_TB_YN_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 5월 앙케이트 참여 여부
*  EXEC : DBO.FA_CUSTOMER_EVENT_201005_TB_YN_PROC 'test'
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/04/26) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_CUSTOMER_EVENT_201004_TB_YN_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
		@strUserID			VARCHAR(30)
)
AS
SET NOCOUNT ON
/*********************************************************************
* Implementation Part
*********************************************************************/

--이미 참여한 회원
SELECT IDX FROM FA_CUSTOMER_EVENT_201004_TB
 WHERE USERID = @strUserID

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201005_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 5월 앙케이트 이벤트 등록
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/04/26) : 신규작성
*********************************************************************/
CREATE PROC  [dbo].[FA_CUSTOMER_EVENT_201005_TB_INSERT_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  @strUserid   VARCHAR(30)          -- 등록자 아이디
, @strUserNm   VARCHAR(20)          -- 등록자 이름
, @strAge      TINYINT              -- 등록자 연령
, @strPost     CHAR(6)              -- 등록자 우편번호
, @strAddr     VARCHAR(200)         -- 등록자 주소

, @strEmail    VARCHAR(100)         -- 등록자 이메일
, @strJob      TINYINT              -- 등록자 직업
, @strTel      VARCHAR(50)          -- 등록자 연락처
, @strItem1    TINYINT              -- 앙케이트1

, @strItem2    TINYINT              -- 앙케이트2
, @strItem3    TINYINT              -- 앙케이트3
, @strItem4    TINYINT              -- 앙케이트4
, @strItem5    TINYINT              -- 앙케이트5
, @strItem6    TINYINT              -- 앙케이트6
, @strItem7    TINYINT              -- 앙케이트7
, @StrAnswer1  VARCHAR(2000)        -- 답변1

)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

INSERT INTO FA_CUSTOMER_EVENT_201005_TB
(
	 USERID
  ,USERNM
  ,USERAGE
  ,POST
  ,ADDR
  ,EMAIL
  ,JOB
  ,TEL
  ,ITEM1
  ,ITEM2
  ,ITEM3
  ,ITEM4
  ,ITEM5
  ,ITEM6
  ,ITEM7
  ,ANSWER1
  ,REG_DT
)
VALUES
(
	 @strUserid
	, @strUserNm
	, @strAge
	, @strPost
	, @strAddr

	, @strEmail
	, @strJob
  , @strTel
	, @strItem1

	, @strItem2
	, @strItem3
	, @strItem4
	, @strItem5
	, @strItem6
	, @strItem7
	, @StrAnswer1
	, GETDATE()
)
IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

	SET NOCOUNT OFF
	RETURN (1)
/*********************************************************************
* End of lsp
*********************************************************************/

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201005_TB_YN_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 5월 앙케이트 참여 여부
*  EXEC : DBO.FA_CUSTOMER_EVENT_201005_TB_YN_PROC 'test'
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/04/26) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_CUSTOMER_EVENT_201005_TB_YN_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
		@strUserID			VARCHAR(30)
)
AS
SET NOCOUNT ON
/*********************************************************************
* Implementation Part
*********************************************************************/

--이미 참여한 회원
SELECT IDX FROM FA_CUSTOMER_EVENT_201005_TB
 WHERE USERID = @strUserID

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201007_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*	1) 작성자 : 정태운(2010/06/23)
* 2) 내용   : 201007 이벤트 등록
*********************************************************************/

CREATE PROC  [dbo].[FA_CUSTOMER_EVENT_201007_TB_INSERT_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  @strsex     TINYINT          -- 성별
, @strage     TINYINT          -- 연령
, @strJob     TINYINT          -- 직종
, @strplace   TINYINT          -- 거주지
, @nIDX       INT        OUTPUT

)
AS
SET NOCOUNT ON

INSERT INTO FA_CUSTOMER_EVENT_201007_TB
(
    SEX
  , AGE
  , JOB
  , PLACE
  , REG_DT
)
VALUES
(
    @strsex
	, @strage
  , @strJob
	, @strplace
	, GETDATE()
)

IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		SET @nIDX = -1
	END

SELECT TOP 1 @nIDX = IDX
  FROM FA_CUSTOMER_EVENT_201007_TB
 ORDER BY REG_DT DESC



select * from
FA_CUSTOMER_EVENT_201007_TB
FA_CUSTOMER_EVENT_201007

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201007_TB_MODIFY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*	 작성자 :  정태운(2010/06/24) : 신규작성
*  내  용 : 7월 앙케이트 이벤트 등록
*********************************************************************/
CREATE PROC  [dbo].[FA_CUSTOMER_EVENT_201007_TB_MODIFY_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  @nIdx        INT                  -- idx
, @strItem1    TINYINT              -- 앙케이트1
, @strItem2    TINYINT              -- 앙케이트2
, @strItem3    TINYINT              -- 앙케이트3
, @strItem4    TINYINT              -- 앙케이트4
, @strItem5    TINYINT              -- 앙케이트5
, @strItem6    TINYINT              -- 앙케이트6

, @strItem3_D  VARCHAR(20)          -- 답변3 기타
, @strItem4_D  VARCHAR(20)          -- 답변4 기타
, @strItem5_D  VARCHAR(50)          -- 답변5 기타
, @strItem6_D  VARCHAR(50)          -- 답변6 기타

)
AS
SET NOCOUNT ON

UPDATE FA_CUSTOMER_EVENT_201007_TB SET
  ANSWER1     = @strItem1
, ANSWER2     = @strItem2
, ANSWER3     = @strItem3
, ANSWER4     = @strItem4
, ANSWER5     = @strItem5
, ANSWER6     = @strItem6
, ANSWER3_D   = @strItem3_D
, ANSWER4_D   = @strItem4_D
, ANSWER5_D   = @strItem5_D
, ANSWER6_D   = @strItem6_D
, REG_DT      = GETDATE()
 WHERE IDX = @nIdx

IF @@ERROR <> 0
	BEGIN
		RETURN (-1)
	END

RETURN (1)

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201008_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*********************************************************************
* Description
*
*  내용 : 8월 앙케이트 이벤트 등록
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/07/30) : 신규작성
*********************************************************************/
CREATE PROC  [dbo].[FA_CUSTOMER_EVENT_201008_TB_INSERT_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  @strUserid   VARCHAR(30)          -- 등록자 아이디
, @strUserNm   VARCHAR(20)          -- 등록자 이름
, @strAge      TINYINT              -- 등록자 연령
, @strPost     CHAR(6)              -- 등록자 우편번호
, @strAddr     VARCHAR(200)         -- 등록자 주소

, @strEmail    VARCHAR(100)         -- 등록자 이메일
, @strJob      TINYINT              -- 등록자 직업
, @strTel      VARCHAR(50)          -- 등록자 연락처
, @strItem1    TINYINT              -- 앙케이트1

, @strItem2    TINYINT              -- 앙케이트2
, @strItem3    TINYINT              -- 앙케이트3
, @strItem4    TINYINT              -- 앙케이트4
, @strItem5    TINYINT              -- 앙케이트5
, @strItem6    TINYINT              -- 앙케이트6
, @strItem7    TINYINT              -- 앙케이트7
, @strItem8    TINYINT              -- 앙케이트8
, @StrAnswer1  VARCHAR(2000)        -- 답변1

)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

INSERT INTO FA_CUSTOMER_EVENT_201008_TB
(
	 USERID
  ,USERNM
  ,USERAGE
  ,POST
  ,ADDR
  ,EMAIL
  ,JOB
  ,TEL
  ,ITEM1
  ,ITEM2
  ,ITEM3
  ,ITEM4
  ,ITEM5
  ,ITEM6
  ,ITEM7
  ,ITEM8
  ,ANSWER1
  ,REG_DT
)
VALUES
(
	 @strUserid
	, @strUserNm
	, @strAge
	, @strPost
	, @strAddr

	, @strEmail
	, @strJob
  , @strTel
	, @strItem1

	, @strItem2
	, @strItem3
	, @strItem4
	, @strItem5
	, @strItem6
	, @strItem7
	, @strItem8
	, @StrAnswer1
	, GETDATE()
)
IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

	SET NOCOUNT OFF
	RETURN (1)
/*********************************************************************
* End of lsp
*********************************************************************/

GO
/****** Object:  StoredProcedure [dbo].[FA_CUSTOMER_EVENT_201008_TB_YN_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 20년기념 앙케이트 참여 여부
*  EXEC : DBO.FA_CUSTOMER_EVENT_201002_TB_YN_PROC 'test'
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/07/30) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_CUSTOMER_EVENT_201008_TB_YN_PROC]
(
		@strUserID			VARCHAR(30)
)
AS
SET NOCOUNT ON

--이미 참여한 회원
SELECT IDX FROM FA_CUSTOMER_EVENT_201008_TB
 WHERE USERID = @strUserID

GO
/****** Object:  StoredProcedure [dbo].[FA_EVENT_TB_LIST_CNT]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*==============================================================================
 sp명	:	exec FA_EVENT_TB_LIST_CNT ''
 설명	:	이벤트 리스트 카운트
==============================================================================*/
CREATE PROC [dbo].[FA_EVENT_TB_LIST_CNT]

    	@strLocation         CHAR(1)				=	''
,    	@nCnt		             INT		OUTPUT	-- 목록 개수
AS
BEGIN

	SET NOCOUNT ON

IF @strLocation <> ''
BEGIN
	SELECT @nCnt = count(*)
	  FROM FA_EVENT_TB
	 WHERE Location = @strLocation
     AND DELYN = 'N'
END
ELSE
BEGIN
 	SELECT @nCnt = count(*)
	  FROM FA_EVENT_TB
   WHERE DELYN = 'N'
END
	SET NOCOUNT OFF
END

GO
/****** Object:  StoredProcedure [dbo].[FA_EVENT_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 이벤트 리스트
*  EXEC  FA_EVENT_TB_LIST_PROC 'A', 2, 6
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_EVENT_TB_LIST_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@strLocation         CHAR(1)				=	''
,   	@n4Page					     INT
,    	@n2PageSize          SMALLINT

)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(3000)

SET @strSQLSUB = ''

    IF @strLocation <> ''
      SET @strSQLSUB = @strSQLSUB+' AND location LIKE ''%'+@strLocation+'%''  '



SET @strSQL='SELECT COUNT(*)
                      FROM FA_EVENT_TB (NOLOCK) WHERE delYN=' + '''N''' +@strSQLSUB


IF @n4Page = 1 BEGIN
  	set	Rowcount	@n2PageSize
   SET @strSQL= @strSQL+' SELECT
			EventId
			,title
			,Conts
			,dtSDate
			,dtEDate
			,EventYN
			,LinkUrl
			,BannerIng
			,Bannered
			,DtPreDate
			 from FA_Event_Tb
			  where delYN = '+'''N'''+@strSQLSUB+'
        ORDER BY EventId DESC'
END ELSE BEGIN
	SET @strSQL= @strSQL+'
	DECLARE	@PrevCount			INT
	DECLARE	@n4EventID	INT
	SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'

	SET	RowCount	@PrevCount

   SELECT	@n4EventID = EventId
                       FROM FA_EVENT_TB (NOLOCK) WHERE delYN='+ '''N''' +@strSQLSUB+'
                    ORDER BY EventId DESC

	SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'

   			SELECT
         EventId
  			,title
  			,Conts
  			,dtSDate
  			,dtEDate
  			,EventYN
  			,LinkUrl
  			,BannerIng
  			,Bannered
  			,DtPreDate
  			 from FA_Event_Tb
 			where EventId< @n4EventID and  delYN = '+ '''N'''+@strSQLSUB+'
      ORDER BY EventId DESC'
END

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL
/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[FA_EVENT_TB_LIST_PROC_]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 이벤트 리스트
*  EXEC  FA_EVENT_TB_LIST_PROC_ 'A', 12
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_EVENT_TB_LIST_PROC_]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@strLocation         CHAR(1)				=	''
,	    @nTop		             INT	-- 총갯수

)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(500)

SET @strSQLSUB = ''

    IF @strLocation <> ''
      SET @strSQLSUB = @strSQLSUB+' AND location LIKE ''%'+@strLocation+'%''  '

	-- 이벤트 리스트
SET @strSQL =	N'SELECT TOP '+ CAST(@nTop AS NVARCHAR(10)) +'
                  EventId
                  ,title
                  ,Conts
                  ,dtSDate
                  ,dtEDate
                  ,EventYN
                  ,LinkUrl
                  ,BannerIng
                  ,Bannered
                  ,DtPreDate
	 	 FROM FA_Event_Tb
		 WHERE delYN =' + '''N''' +
		@strSQLSUB +
		 'ORDER BY EventYN DESC, EventId DESC'

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL
/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[FA_EVENT_TB_LIST_PROC_20100330]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 이벤트 리스트
*  EXEC  FA_EVENT_TB_LIST_PROC_20100330 'A', 12
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_EVENT_TB_LIST_PROC_20100330]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@strLocation         CHAR(1)				=	''
,	    @nTop		             INT	-- 총갯수

)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(500)

SET @strSQLSUB = ''

    IF @strLocation <> ''
      SET @strSQLSUB = @strSQLSUB+' AND location LIKE ''%'+@strLocation+'%''  '

	-- 이벤트 리스트
SET @strSQL =	N'SELECT TOP '+ CAST(@nTop AS NVARCHAR(10)) +'
                  EventId
                  ,title
                  ,Conts
                  ,dtSDate
                  ,dtEDate
                  ,EventYN
                  ,LinkUrl
                  ,BannerIng
                  ,Bannered
                  ,DtPreDate
	 	 FROM FA_Event_Tb
		 WHERE delYN =' + '''N''' +
		@strSQLSUB +
		 'ORDER BY EventYN DESC, EventId DESC'
	SET NOCOUNT OFF

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL
/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[FA_ISVOTE_YN_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[FA_ISVOTE_YN_PROC]
     @USERID     VARCHAR(50)
   , @TBLNAME    VARCHAR(30)
AS

SET NOCOUNT ON

DECLARE @SQL VARCHAR(4000)

SET @SQL='SELECT COUNT(*) FROM '+@TBLNAME+' WITH (NOLOCK) WHERE USERID='''+@USERID+''''

EXECUTE(@SQL)

GO
/****** Object:  StoredProcedure [dbo].[FA_MainCount_INS_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	:	ADMIN_FA_BESTINFO_INSERT_PROC
 설명	:	클릭로그
 작성자 :   정헌수
 작성일	:	2015-10-02
==============================================================================*/
CREATE PROC [dbo].[FA_MainCount_INS_PROC]

  @SectionNm    varChar(20)		-- 대분류
, @Flag			varChar(10)		-- 구분코드
, @IP			Varchar(20)		-- 아이피


AS
	SET NOCOUNT ON
	INSERT INTO FA_MainCount (
		SectionNm
		,Flag
		,ClickCnt
		,IP
	)
	SELECT
		@SectionNm
		, @Flag
		,1
		, @IP

GO
/****** Object:  StoredProcedure [dbo].[FA_RENEW_EVENT_201010_COMMENT_TB_INFO_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 개편 이벤트 코멘트 정보
*  EXEC : DBO.FA_RENEW_EVENT_201010_COMMENT_TB_INFO_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/10/01) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_RENEW_EVENT_201010_COMMENT_TB_INFO_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@IDX		        INT
)
AS
SET NOCOUNT ON


SELECT CONTENTS FROM FA_RENEW_EVENT_201010_COMMENT_TB (NOLOCK)
WHERE IDX = @IDX

GO
/****** Object:  StoredProcedure [dbo].[FA_RENEW_EVENT_201010_COMMENT_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 개편이벤트 코멘트
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/09/30) : 신규작성
*********************************************************************/
CREATE PROC  [dbo].[FA_RENEW_EVENT_201010_COMMENT_TB_INSERT_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  @strUserid   VARCHAR(30)          -- 등록자 아이디
, @strUserNm   VARCHAR(20)          -- 등록자 이름
, @strConts    VARCHAR(300)         -- 내용

)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

INSERT INTO FA_RENEW_EVENT_201010_COMMENT_TB
(
	 USERID
  ,USERNM
  ,CONTENTS
  ,REG_DT
)
VALUES
(
	 @strUserid
	, @strUserNm
	, @strConts
	, GETDATE()
)
IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

	SET NOCOUNT OFF
	RETURN (1)
/*********************************************************************
* End of lsp
*********************************************************************/

GO
/****** Object:  StoredProcedure [dbo].[FA_RENEW_EVENT_201010_COMMENT_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 개편 이벤트 코멘트 리스트
*  EXEC : DBO.FA_RENEW_EVENT_201010_COMMENT_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/09/30) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_RENEW_EVENT_201010_COMMENT_TB_LIST_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
     	@n4Page		        INT
,    	@n2PageSize       SMALLINT
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(2000)

SET @strSQLSUB = ''

SET @strSQL='SELECT COUNT(IDX)  FROM FA_RENEW_EVENT_201010_COMMENT_TB (NOLOCK) '


IF @n4Page = 1 BEGIN
  	set	Rowcount	@n2PageSize
   SET @strSQL= @strSQL+'select IDX
                                , USERID
                                , USERNM
                                , CONTENTS
                                , CONVERT(VARCHAR(19), REG_DT, 121)
						   FROM FA_RENEW_EVENT_201010_COMMENT_TB  ORDER BY IDX DESC'

END ELSE BEGIN
	SET @strSQL= @strSQL+'
	DECLARE	@PrevCount	  INT
	DECLARE	@n4ID      		INT

	SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'

	SET	RowCount	@PrevCount

	SELECT	@n4ID = IDX
	   FROM FA_RENEW_EVENT_201010_COMMENT_TB (NOLOCK) ORDER BY IDX DESC

	SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'

	SELECT IDX
        , USERID
        , USERNM
        , CONTENTS
        , CONVERT(VARCHAR(19), REG_DT, 121)
	   FROM FA_RENEW_EVENT_201010_COMMENT_TB (NOLOCK) WHERE IDX <  @n4ID ORDER BY IDX DESC'
END

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

/*********************************************************************
* End of lsp
*********************************************************************/
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[FA_RENEW_EVENT_201010_COMMENT_TB_MOD_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 개편이벤트 코멘트 수정 및 삭제
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/10/01) : 신규작성
*********************************************************************/
CREATE PROC  [dbo].[FA_RENEW_EVENT_201010_COMMENT_TB_MOD_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  @IDX       INT            -- 등록번호
, @MOD       CHAR(1)        -- 수정및 삭제 구분
, @strConts  VARCHAR(300)   -- 내용

)
AS
SET NOCOUNT ON

IF @MOD = 'M'
  BEGIN
    UPDATE FA_RENEW_EVENT_201010_COMMENT_TB SET
      CONTENTS = @strConts
    WHERE IDX = @IDX

    IF @@ERROR <> 0
  	BEGIN
  		SET NOCOUNT OFF
  		RETURN (-1)
  	END
  END
ELSE
  BEGIN
    DELETE FA_RENEW_EVENT_201010_COMMENT_TB
    WHERE IDX = @IDX

    IF @@ERROR <> 0
  	BEGIN
  		SET NOCOUNT OFF
  		RETURN (-2)
  	END
  END

RETURN (1)

GO
/****** Object:  StoredProcedure [dbo].[FA_RENEW_EVENT_201010_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 개편이벤트
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/09/30) : 신규작성
*********************************************************************/
CREATE PROC  [dbo].[FA_RENEW_EVENT_201010_TB_INSERT_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  @strUserid   VARCHAR(30)          -- 등록자 아이디
, @strUserNm   VARCHAR(20)          -- 등록자 이름
, @strHPhone   VARCHAR(14)          -- 핸번
, @strPhone    VARCHAR(14)          -- 전번
, @StrAnswer   VARCHAR(7)           -- 답변

)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

INSERT INTO FA_RENEW_EVENT_201010_TB
(
	 USERID
  ,USERNM
  ,HPHONE
  ,PHONE
  ,ANSWER
  ,REG_DT
)
VALUES
(
	 @strUserid
	, @strUserNm
	, @strHPhone
	, @strPhone
	, @StrAnswer
	, GETDATE()
)
IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

	SET NOCOUNT OFF
	RETURN (1)
/*********************************************************************
* End of lsp
*********************************************************************/

GO
/****** Object:  StoredProcedure [dbo].[FA_RENEW_EVENT_201010_TB_YN_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 개편이벤트 참여여부
*  EXEC : DBO.FA_RENEW_EVENT_201010_TB_YN_PROC 'test'
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/04/26) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FA_RENEW_EVENT_201010_TB_YN_PROC]
(
		@strUserID			VARCHAR(30)
)
AS
SET NOCOUNT ON

--이미 참여한 회원
SELECT IDX FROM FA_RENEW_EVENT_201010_TB
 WHERE USERID = @strUserID

GO
/****** Object:  StoredProcedure [dbo].[FA_RESEARCH_INSERT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[FA_RESEARCH_INSERT_PROC]
       @USERID     VARCHAR(50)
     , @USERNAME   VARCHAR(30)
     , @AGE        TINYINT
     , @TEL        VARCHAR(50)
     , @ADDR       VARCHAR(200)
     , @EMAIL      VARCHAR(100)
     , @Q1         TINYINT
     , @Q2         TINYINT
     , @Q2_TEXT    NVARCHAR(300)
     , @Q3         TINYINT
     , @Q4         TINYINT
     , @Q5         TINYINT
     , @Q6_1       TINYINT
     , @Q6_2       TINYINT
     , @Q6_3       TINYINT
     , @Q6_4       TINYINT
     , @Q6_5       TINYINT
     , @Q6_6       TINYINT
     , @Q6_7       TINYINT
     , @Q7         TINYINT
     , @Q8         TINYINT
     , @Q9         TINYINT
     , @Q10        TINYINT
     , @Q11_TEXT   NVARCHAR(300)
AS

SET NOCOUNT ON


IF @Q4=0
   SET @Q4=NULL

IF @Q5=0
   SET @Q5=NULL


INSERT dbo.FA_RESEARCH_201006_TB
     ( USERID, USERNM, USERAGE, TEL, ADDR, EMAIL
     , ITEM1, ITEM2, ITEM2_TEXT, ITEM3, ITEM4, ITEM5
     , ITEM6_1, ITEM6_2, ITEM6_3, ITEM6_4, ITEM6_5, ITEM6_6, ITEM6_7
     , ITEM7, ITEM8, ITEM9, ITEM10, ITEM11_TEXT )
VALUES
     ( @USERID, @USERNAME, @AGE, @TEL, @ADDR, @EMAIL
     , @Q1, @Q2, @Q2_TEXT, @Q3, @Q4, @Q5
     , @Q6_1, @Q6_2, @Q6_3, @Q6_4, @Q6_5, @Q6_6, @Q6_7
     , @Q7, @Q8, @Q9, @Q10, @Q11_TEXT )

GO
/****** Object:  StoredProcedure [dbo].[FOOD_SEMINAR_EVENT_201102_YN_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 창업세미나 신청 체크
*  EXEC : DBO.FOOD_SEMINAR_EVENT_201102_YN_PROC 'test'
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2011/02/15) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FOOD_SEMINAR_EVENT_201102_YN_PROC]
(
		@strUserID			VARCHAR(30)
)
AS
SET NOCOUNT ON

--이미 참여한 회원
SELECT IDX FROM FOOD_SEMINAR_EVENT_201102
 WHERE USERID = @strUserID

GO
/****** Object:  StoredProcedure [dbo].[FOOD_SEMINAR_EVENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 창업세미나 신청 체크
*  EXEC : DBO.FOOD_SEMINAR_EVENT_PROC 'test'
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 김문화(2011/05/13) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[FOOD_SEMINAR_EVENT_PROC]
(
		@strUserID			VARCHAR(30)
    ,@strEventDiv    CHAR(6)
)
AS
SET NOCOUNT ON

--이미 참여한 회원
SELECT IDX FROM FOOD_SEMINAR_EVENT
 WHERE USERID = @strUserID
 AND EVENT_DIV = @strEventDiv

GO
/****** Object:  StoredProcedure [dbo].[GET_F_ARTICLE_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 컨텐츠관리 - 글마당 상세보기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_ARTICLE_DETAIL_PROC 3502, 10, '',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_ARTICLE_DETAIL_PROC]
	@IDX 	INT,
	@NDX	INT,
  @MODE INT,
	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)=''
AS

SET NOCOUNT ON

DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET @SQL =''
	SET @WHERE = ''

	--VIEWCNT++
  UPDATE
		DBO.READEREVENT2
	SET
		VIEWCNT=VIEWCNT + 1
	WHERE
		IDX = @IDX

	-- 글 내용
	SELECT
		TOP 1
		TA.NDX,
		TA.TITLE,
		ISNULL(TA.USERNAME,'') as USERNAME ,
		ISNULL(TA.USERID,'') as USERID,
		ISNULL(TA.EMAIL,'') as EMAIL ,
		TA.REGDATE,
		TA.VIEWCNT,
		TA.DREW,
		TA.GRADES,
		TA.IMGSRC,
		TA.CONTENTS,
		TB.TITLE AS CATETITLE
	FROM
		DBO.READEREVENT2 TA(NOLOCK)
		INNER JOIN DBO.READERROUND2 TB(NOLOCK)
		ON TA.NDX = TB.NDX
	WHERE TA.IDX = @IDX
    AND TA.DelFlag = '0'

	--검색절 SET
	IF @SEARCHFIELD<>''
		BEGIN
			IF @SEARCHFIELD='USERNAME'
				SET @WHERE = @WHERE + '		TA.USERNAME LIKE ''%' + @SEARCHTEXT + '%'' AND '
			IF @SEARCHFIELD='USERID'
				SET @WHERE = @WHERE + '		TA.USERID LIKE ''%' + @SEARCHTEXT + '%'' AND '
			IF @SEARCHFIELD='TITLE'
				SET @WHERE = @WHERE + '		TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
		END

  IF @MODE <> 0
    BEGIN
      SET @WHERE = @WHERE + '		TA.NDX = ' + @NDX + ' AND '
    END

	--이전글
	SET @SQL = '' +
		'	SELECT TOP 1	' +
		'		TA.IDX, TA.NDX, TA.TITLE	' +
		'	FROM ' +
		'		DBO.READEREVENT2 TA(NOLOCK)	' +
		' WHERE ' +  @WHERE +
		'		TA.IDX < ' + CAST(@IDX AS VARCHAR(10)) + ' AND ' +
		'		TA.DELFLAG = ''0'' AND ' +
		'		1=1	' +
		'	ORDER BY ' +
		'		TA.REF DESC, TA.LOWREF, TA.STEP ; '

	--다음글
	SET @SQL = @SQL +
		'	SELECT TOP 1	' +
		'		TA.IDX, TA.NDX, TA.TITLE	' +
		'	FROM ' +
		'		DBO.READEREVENT2 TA(NOLOCK)	' +
		' WHERE ' +  @WHERE +
		'		TA.IDX > ' + CAST(@IDX AS VARCHAR(10)) + ' AND ' +
		'		TA.DELFLAG = ''0'' AND ' +
		'		1=1	' +
		'	ORDER BY ' +
		'		TA.REF ASC, TA.LOWREF DESC, TA.STEP DESC ; '

  --PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

	-- 댓글 리스트
  SELECT
	  SERIAL,
		USERID,
		COMMENT,
		GRADES,
		REGDATE
	FROM
		DBO.READERCOMMENT2(NOLOCK)
	WHERE
		IDX = @IDX
	ORDER BY
		SERIAL DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_F_ARTICLE_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장plus - 글마당 리스트
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 : 정태운
 *  수   정   일 : 2009-12-04
 *  설        명 : 제거
 *  수   정   자 : 김문화
 *  수   정   일 : 2011-07-01
 *  설        명 : 테마별보기 추가
 *  주 의  사 항 :
								CONTKIND :	NDX=13(이용후기)일 때 - 11:파인드올, 12:신문벼룩시장, 2:부동산, 1:중고장터, 3:자동차, 10:공지사항
														NDX=14(유머벼룩시장)일 때 - 0:전체, 6:상품&서비스, 7:부동산, 8:자동차, 9:구인구직,
														그외 : '',NULL,0
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_ARTICLE_LIST_PROC 1,10,4,'',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_ARTICLE_LIST_PROC]

	@PAGE					INT,
	@PAGESIZE			INT,

	@NDX					VARCHAR(3),							--글마당 테마

	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)=''

AS
DECLARE

	@SQL		NVARCHAR(4000),
	@WHERE	NVARCHAR(1000)

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	--검색절 SET
	SET @WHERE = ''

	IF @SEARCHFIELD<>''
		BEGIN
			IF @SEARCHFIELD='USERNAME'
				SET @WHERE = @WHERE + '		TA.USERNAME LIKE ''%' + @SEARCHTEXT + '%'' AND '
			IF @SEARCHFIELD='CONTENTS'
				SET @WHERE = @WHERE + '		TA.CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
			IF @SEARCHFIELD='TITLE'
				SET @WHERE = @WHERE + '		TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
		END

  --테마별 보기 추가
  IF @NDX <> ''
    BEGIN
        SET @WHERE = @WHERE + '   TA.NDX = ' + @NDX + ' AND '
    END

	SET @SQL = '' +

			'		SELECT  ' +
			'			TOP 1 ' +
			'			TA.USERNAME, ' +
			'			TB.TITLE AS CATTITLE, ' +
			'			TA.IDX, ' +
			'			TA.NDX, ' +
			'			TA.TITLE, ' +
			'			(SELECT COUNT(*) FROM READERCOMMENT2(NOLOCK) WHERE IDX=TA.IDX) AS CMTCNT, ' +
			'			TA.REGDATE ' +
			'		FROM  ' +
			'			DBO.READEREVENT2 TA(NOLOCK) ' +
			'			LEFT JOIN DBO.READERROUND2 TB(NOLOCK) ON TA.NDX = TB.NDX ' +
			'		WHERE ' +
			'			TA.DELFLAG=''0'' AND ' +
			'			TA.DREW=''1'' AND ' +
			'			TA.NDX IN (10,4) ' +
			'		ORDER BY  ' +
			'			TA.MODDATE DESC, TA.IDX DESC ; ' +

			'	SELECT ' +
			'		COUNT(*) AS CNT ' +
			'	FROM ' +
			'		DBO.READEREVENT2 TA(NOLOCK) ' +
			'		INNER JOIN DBO.READERROUND2 TB(NOLOCK) ' +
			'		ON TA.NDX = TB.NDX ' +
			' WHERE ' + @WHERE +
			'		TA.DELFLAG = ''0'' AND ' +
			'		1=1 ; ' +

			' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
			'		 TA.IDX, ' +
			'		 TA.NDX, ' +
			'		 TA.TITLE, ' +
			'		 TA.STEP, ' +
			'		 TA.USERNAME, ' +
			'		 TA.USERID, ' +
			'		 TA.REGDATE, ' +
			'		 TA.VIEWCNT, ' +
			'		 TA.REF, ' +
			'		 TA.LOWREF, ' +
			'		 TA.STEP, ' +
			'		 TA.DREW, ' +
			'		 TA.GRADES, ' +
			'		 TA.IMGSRC, ' +
			'		 TB.TITLE AS CATETITLE, ' +
			'		 (SELECT COUNT(*) FROM DBO.READERCOMMENT2 WHERE IDX=TA.IDX ) AS COMMENTCNT, ' +
			'		 (SELECT Title from  READERROUND2 WHERE Ndx = TA.NDX) as ThemeNm ' +
			'	FROM ' +
			'		DBO.READEREVENT2 TA(NOLOCK) ' +
			'		INNER JOIN DBO.READERROUND2 TB(NOLOCK) ' +
			'		ON TA.NDX = TB.NDX ' +
			' WHERE ' +  @WHERE +
			'		TA.DELFLAG = ''0'' AND ' +
			'		1=1 ' +
			' ORDER BY ' +
			'		TA.REF DESC, TA.STEP ASC, TA.REGDATE DESC '

PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_F_ARTICLE_MODDETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 컨텐츠관리 - 글마당 수정시 원본글보기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_ARTICLE_MODDETAIL_PROC 4662, 10
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_ARTICLE_MODDETAIL_PROC]
	@IDX 	INT,
	@NDX	INT
AS

	-- 글 내용
	SELECT
		TOP 1
		TA.NDX,
		TA.TITLE,
		TA.USERNAME,
		TA.USERID,
		TA.EMAIL,
		TA.REGDATE,
		TA.VIEWCNT,
		TA.DREW,
		TA.GRADES,
		TA.IMGSRC,
		TA.CONTENTS,
		TB.TITLE AS CATETITLE
	FROM
		DBO.READEREVENT2 TA(NOLOCK)
		INNER JOIN DBO.READERROUND2 TB(NOLOCK)
		ON TA.NDX = TB.NDX
	WHERE
		TA.IDX = @IDX

GO
/****** Object:  StoredProcedure [dbo].[GET_F_ARTICLE_TODAY_WRITE_CNT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 오늘 독자글마당 등록수
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/06/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : GET_F_ARTICLE_TODAY_WRITE_CNT_PROC 'cbk08'
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_ARTICLE_TODAY_WRITE_CNT_PROC]

	@USERID VARCHAR(50)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT COUNT(*) AS CNT
    FROM READEREVENT2
   WHERE CONVERT(VARCHAR(10),REGDATE,120) = CONVERT(VARCHAR(10),GETDATE(),120)
     AND USERID = @USERID

GO
/****** Object:  StoredProcedure [dbo].[GET_F_BOARDPLUS_MAIN_ALL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장plus - 메인
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/08/06
 *  수   정   자 : 정태운
 *  수   정   일 : 2009-12-07
 *  설        명 : 독자참여공간 통합
 *  수   정   일 : 2009-12-30
 *  설        명 : 최신정보 top13 => top15 변경, 독자참여공간 top 11 => top 14
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_BOARDPLUS_MAIN_ALL_PROC 0
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_BOARDPLUS_MAIN_ALL_PROC]
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON


	DECLARE	@TMPSERIAL 		INT

	--##### 오늘의 기사 시작
	-- 메인게재 글 중 최근 글 번호
	SELECT
		TOP 1
		@TMPSERIAL = TA.SERIAL
	FROM
		DBO.NESSAY TA(NOLOCK)
		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
	WHERE
		TA.IMGSRC3 IS NOT NULL AND
		TA.MAINFLAG = '1' AND
		TB.DISFLAG = 1
	ORDER BY
		TA.MODDATE DESC,
		TA.SERIAL DESC

	-- 메인적용 기사 중 최근글 내용
	SELECT
		TOP 1
		TB.LNAME,
		TB.MNAME,
		TA.SERIAL,
		TA.CODE,
		TA.TITLE,
		TA.SUMMARY,
		TA.IMGSRC3
	FROM
		DBO.NESSAY TA(NOLOCK)
		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
	WHERE
		TA.SERIAL = @TMPSERIAL

	--##### // 오늘의 기사 끝

	-- 읽을거리, 부동산정보 제외한 벼룩시장 플러스 글
	SELECT
		TOP 18
		TB.LNAME,
		TB.MNAME,
		TA.SERIAL,
		TA.CODE,
		TA.TITLE,
		TA.SUMMARY,
		TA.IMGSRC3,
		TA.MODDATE
	FROM
		DBO.NESSAY TA(NOLOCK)
		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
	WHERE
		TB.LCODE NOT IN (50, 60) AND
		TA.SERIAL <> @TMPSERIAL AND
		TB.DISFLAG = 1
	ORDER BY
		TA.MODDATE DESC,
		TA.SERIAL DESC

	-- 부동산 정보
	SELECT
		TOP 2
		TB.LNAME,
		TB.MNAME,
		TA.SERIAL,
		TA.CODE,
		TA.TITLE,
		TA.SUMMARY,
		TA.IMGSRC3,
		TA.MODDATE
	FROM
		DBO.NESSAY TA(NOLOCK)
		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
	WHERE
		TB.LCODE = 60 AND
		TA.SERIAL <> @TMPSERIAL AND
		TB.DISFLAG = 1
	ORDER BY
		TA.MODDATE DESC,
		TA.SERIAL DESC

	--##### 읽을거리 시작
	-- 이미지 등록된 글 번호
	SELECT
		TOP 1
		@TMPSERIAL = TA.SERIAL
	FROM
		DBO.NESSAY TA(NOLOCK)
		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
	WHERE
		TB.LCODE = 50 AND
		TA.IMGSRC3 IS NOT NULL AND
		TB.DISFLAG = 1
	ORDER BY
		TA.MODDATE DESC,
		TA.SERIAL DESC

	-- 이미지 등록된 글 내용
	SELECT
		TOP 1
		TB.LNAME,
		TB.MNAME,
		TA.SERIAL,
		TA.CODE,
		TA.TITLE,
		TA.SUMMARY,
		TA.IMGSRC3
	FROM
		DBO.NESSAY TA(NOLOCK)
		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
	WHERE
		TA.SERIAL = @TMPSERIAL

	-- 그 외 네개
	SELECT
		TOP 4
		TB.LNAME,
		TB.MNAME,
		TA.SERIAL,
		TA.CODE,
		TA.TITLE,
		TA.SUMMARY,
		TA.IMGSRC3,
		TA.MODDATE
	FROM
		DBO.NESSAY TA(NOLOCK)
		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
	WHERE
		TB.LCODE = 50 AND
		TA.SERIAL <> @TMPSERIAL AND
		TB.DISFLAG = 1
	ORDER BY
		TA.MODDATE DESC,
		TA.SERIAL DESC

	--##### // 읽을거리 끝

	-- 독자참여공간 - 금주의 당첨글
	SELECT
		TOP 1
		TA.USERNAME,
		TB.TITLE AS CATTITLE,
		TA.IDX,
		TA.NDX,
		TA.TITLE,
		(SELECT COUNT(*) FROM READERCOMMENT2(NOLOCK) WHERE IDX=TA.IDX) AS CMTCNT,
		TA.REGDATE
	FROM
		DBO.READEREVENT2 TA(NOLOCK)
		LEFT JOIN DBO.READERROUND2 TB(NOLOCK) ON TA.NDX = TB.NDX
	WHERE
		TA.DELFLAG='0' AND
		TA.DREW='1' AND
		TA.NDX IN (10,4)
	ORDER BY
		TA.MODDATE DESC, TA.IDX DESC

	-- 독자참여공간 - 살아가는 이야기 #####
--	SELECT
--		TOP 4
--		TA.USERNAME,
--		TB.TITLE AS CATTITLE,
--		TA.IDX,
--		TA.NDX,
--		TA.TITLE,
--		TA.CONTENTS,
--		(SELECT COUNT(*) FROM READERCOMMENT2(NOLOCK) WHERE IDX=TA.IDX) AS CMTCNT
--	FROM
--		DBO.READEREVENT2 TA(NOLOCK)
--		LEFT JOIN DBO.READERROUND2 TB(NOLOCK) ON TA.NDX = TB.NDX
--	WHERE
--		TA.DELFLAG='0' AND
--		TA.NDX = 10
--	ORDER BY
--		TA.MODDATE DESC, TA.IDX DESC

	-- 독자참여공간 - 독자문화 클럽 #####
--	SELECT
--		TOP 5
--		TA.USERNAME,
--		TB.TITLE AS CATTITLE,
--		TA.IDX,
--		TA.NDX,
--		TA.TITLE,
--		(SELECT COUNT(*) FROM READERCOMMENT2(NOLOCK) WHERE IDX=TA.IDX) AS CMTCNT
--	FROM
--		DBO.READEREVENT2 TA(NOLOCK)
--		LEFT JOIN DBO.READERROUND2 TB(NOLOCK) ON TA.NDX = TB.NDX
--	WHERE
--		TA.DELFLAG='0' AND
--		TA.NDX = 4
--	ORDER BY
--		TA.MODDATE DESC, TA.IDX DESC



	-- 독자참여공간 - 살아가는 이야기 #####
  -- 대구: 10건, 대구제외 전지역 5건(대구제외 전 지역 이벤트추가로 배너만큼 게시물 조정)
     SELECT
    	TOP 12
    	TA.USERNAME,
    	TB.TITLE AS CATTITLE,
    	TA.IDX,
    	TA.NDX,
    	TA.TITLE,
    	TA.CONTENTS,
    	(SELECT COUNT(*) FROM READERCOMMENT2(NOLOCK) WHERE IDX=TA.IDX) AS CMTCNT
    FROM
    	DBO.READEREVENT2 TA(NOLOCK)
    	LEFT JOIN DBO.READERROUND2 TB(NOLOCK) ON TA.NDX = TB.NDX
    WHERE
    	TA.DELFLAG='0'
    ORDER BY
    	TA.MODDATE DESC, TA.IDX DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_F_BOARDPLUS_MAIN_SUB_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장plus - 메인 2
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_BOARDPLUS_MAIN_SUB_PROC
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_BOARDPLUS_MAIN_SUB_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


	--##### 금주의 당첨글 #####
	SELECT
		TOP 1
		TA.USERNAME,
		TB.TITLE AS CATTITLE,
		TA.IDX,
		TA.NDX,
		TA.TITLE,
		(SELECT COUNT(*) FROM READERCOMMENT2(NOLOCK) WHERE IDX=TA.IDX) AS CMTCNT,
		TA.REGDATE
	FROM
		DBO.READEREVENT2 TA(NOLOCK)
		LEFT JOIN DBO.READERROUND2 TB(NOLOCK) ON TA.NDX = TB.NDX
	WHERE
		TA.DELFLAG='0' AND
		TA.DREW='1' AND
		TA.NDX IN (10,4)
	ORDER BY
		TA.MODDATE DESC, TA.IDX DESC

	--##### 살아가는 이야기 #####
	SELECT
		TOP 4
		TA.USERNAME,
		TB.TITLE AS CATTITLE,
		TA.IDX,
		TA.NDX,
		TA.TITLE,
		(SELECT COUNT(*) FROM READERCOMMENT2(NOLOCK) WHERE IDX=TA.IDX) AS CMTCNT
	FROM
		DBO.READEREVENT2 TA(NOLOCK)
		LEFT JOIN DBO.READERROUND2 TB(NOLOCK) ON TA.NDX = TB.NDX
	WHERE
		TA.DELFLAG='0' AND
		--TA.DREW='1' AND
		TA.NDX = 10
	ORDER BY
		TA.MODDATE DESC, TA.IDX DESC

	--##### 독자문화 클럽 #####
	SELECT
		TOP 4
		TA.USERNAME,
		TB.TITLE AS CATTITLE,
		TA.IDX,
		TA.NDX,
		TA.TITLE,
		(SELECT COUNT(*) FROM READERCOMMENT2(NOLOCK) WHERE IDX=TA.IDX) AS CMTCNT
	FROM
		DBO.READEREVENT2 TA(NOLOCK)
		LEFT JOIN DBO.READERROUND2 TB(NOLOCK) ON TA.NDX = TB.NDX
	WHERE
		TA.DELFLAG='0' AND
		--TA.DREW='1' AND
		TA.NDX = 4
	ORDER BY
		TA.MODDATE DESC, TA.IDX DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_F_BOARDPLUS_MAIN_TOPMIDDLE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장plus - 메인 1
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_BOARDPLUS_MAIN_TOPMIDDLE_PROC
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_BOARDPLUS_MAIN_TOPMIDDLE_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	--벼룩시장 플러스 메인 오늘의 기사
	SELECT
		TOP 1
		TB.LNAME,
		TB.MNAME,
		TA.SERIAL,
		TA.CODE,
		TA.TITLE,
		TA.SUMMARY,
		TA.IMGSRC3
	FROM
		DBO.NESSAY TA(NOLOCK)
		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
	WHERE
		TA.IMGSRC3 IS NOT NULL
	ORDER BY
		TA.MODDATE DESC,
		TA.SERIAL DESC


	--벼룩시장플러스 메인중앙 머니 : 이미지 있음
	DECLARE @SECTIONCODE	INT
	DECLARE	@TMPSERIAL 		INT



	--################ 머니 ################
	SET @SECTIONCODE = 1010
	SET @TMPSERIAL 	= NULL

		--이미지가 등록된 글의 SERIAL을 가져온다.
		SELECT
			TOP 1
			@TMPSERIAL=TA.SERIAL
		FROM
			DBO.NESSAY TA(NOLOCK)
		WHERE
			TA.IMGSRC3 IS NOT NULL AND
			TA.CODE = @SECTIONCODE
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

		--이미지가 등록된 글의 레코드
		SELECT
			TOP 1
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			TA.SERIAL = @TMPSERIAL
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

		--이미지가 등록되지 않은 글의 레코드
		SELECT
			TOP 3
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3,
			TA.MODDATE
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			TA.CODE = @SECTIONCODE AND
			TA.SERIAL <> @TMPSERIAL
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

	--################ 일과사람 ################
	SET @SECTIONCODE = 2010
	SET @TMPSERIAL 	= NULL

		--이미지가 등록된 글의 SERIAL을 가져온다.
		SELECT
			TOP 1
			@TMPSERIAL=TA.SERIAL
		FROM
			DBO.NESSAY TA(NOLOCK)
		WHERE
			TA.IMGSRC3 IS NOT NULL AND
			TA.CODE = @SECTIONCODE
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

		--이미지가 등록된 글의 레코드
		SELECT
			TOP 1
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			TA.SERIAL = @TMPSERIAL
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

		--이미지가 등록되지 않은 글의 레코드
		SELECT
			TOP 3
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3,
			TA.MODDATE
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			TA.CODE = @SECTIONCODE AND
			TA.SERIAL <> @TMPSERIAL
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

	--################ 건강365 ################
	SET @SECTIONCODE = 3010
	SET @TMPSERIAL 	= NULL

		--이미지가 등록된 글의 SERIAL을 가져온다.
		SELECT
			TOP 1
			@TMPSERIAL=TA.SERIAL
		FROM
			DBO.NESSAY TA(NOLOCK)
		WHERE
			TA.IMGSRC3 IS NOT NULL AND
			TA.CODE = @SECTIONCODE
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

		--이미지가 등록된 글의 레코드
		SELECT
			TOP 1
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			TA.SERIAL = @TMPSERIAL
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

		--이미지가 등록되지 않은 글의 레코드
		SELECT
			TOP 3
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3,
			TA.MODDATE
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			TA.CODE = @SECTIONCODE AND
			TA.SERIAL <> @TMPSERIAL
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

	--################ 테마가 있는 오늘 ################
	SET @SECTIONCODE = 4010
	SET @TMPSERIAL 	= NULL

		--이미지가 등록된 글의 SERIAL을 가져온다.
		SELECT
			TOP 1
			@TMPSERIAL=TA.SERIAL
		FROM
			DBO.NESSAY TA(NOLOCK)
		WHERE
			TA.IMGSRC3 IS NOT NULL AND
			TA.CODE = @SECTIONCODE
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

		--이미지가 등록된 글의 레코드
		SELECT
			TOP 1
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			TA.SERIAL = @TMPSERIAL
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

		--이미지가 등록되지 않은 글의 레코드
		SELECT
			TOP 3
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3,
			TA.MODDATE
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			TA.CODE = @SECTIONCODE AND
			TA.SERIAL <> @TMPSERIAL
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

	--################ 읽을거리 ################
		--이미지가 등록되지 않은 글의 레코드
		SELECT
			TOP 1
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3,
			TA.MODDATE
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			--LEFT(TA.CODE,2) = 50
			TA.CODE BETWEEN 5000 AND 5999
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

	--################ 부동산정보 ################
		--이미지가 등록되지 않은 글의 레코드
		SELECT
			TOP 2
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3,
			TA.MODDATE
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			--LEFT(TA.CODE,2) = 60
			TA.CODE BETWEEN 6000 AND 6999
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

	--################ 구인구직 ################
		SELECT
			TOP 4
			TB.LNAME,
			TB.MNAME,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SUMMARY,
			TA.IMGSRC3,
			TA.MODDATE
		FROM
			DBO.NESSAY TA(NOLOCK)
			LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE = TB.CODE
		WHERE
			TA.CODE = 7010
		ORDER BY
			TA.MODDATE DESC,
			TA.SERIAL DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_F_ESSAY_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 컨텐츠관리 - 정보마당 상세페이지
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : exec GET_F_ESSAY_DETAIL_PROC 25412
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_ESSAY_DETAIL_PROC]
	@SERIAL	INT,
	@LCODE	INT,
	@MCODE	INT,

	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)=''
AS

	SET NOCOUNT ON

	DECLARE
		@SQL				NVARCHAR(4000),
		@WHERE			NVARCHAR(1000)

	SET @SQL = ''
	SET @WHERE = ''

--뷰카운트 1증가
UPDATE
	DBO.NESSAY
SET
	CNT=CNT+1
WHERE
	SERIAL = @SERIAL

--글 상세,본문 가져오기
SELECT
	TB.LNAME,
	TB.MNAME,
	TA.SERIAL,
	TA.STYLE,
	TA.TITLE,
	TA.DESCRIPTION,
	TA.MODDATE,
	TA.IMGSRC3,
	TA.IMGSRC4
FROM
	DBO.NESSAY TA(NOLOCK)
	LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE=TB.CODE
WHERE
	TA.SERIAL = @SERIAL

--이전글, 다음글
	--검색절 SET
	SET @WHERE = ''
	IF @SEARCHFIELD<>''
		BEGIN
			IF @SEARCHFIELD='TITLE'
				SET @WHERE = @WHERE + '		TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
			ELSE IF @SEARCHFIELD='CONTENTS'
				SET @WHERE = @WHERE + '		TA.DESCRIPTION LIKE ''%' + @SEARCHTEXT + '%'' AND '
			ELSE IF @SEARCHFIELD='TITLECONTENTS'
				SET @WHERE = @WHERE + '		(TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' OR TA.DESCRIPTION LIKE ''%' + @SEARCHTEXT + '%'') AND '
		END

	IF @MCODE<>0
		SET @WHERE = @WHERE + '		TA.CODE = ' + CAST(@LCODE AS VARCHAR(3)) + CAST(@MCODE AS VARCHAR(2)) + ' AND '
	ELSE
		BEGIN
			IF @LCODE>90
				SET @WHERE = @WHERE + '		LEFT(TA.CODE,3) = ' + CAST(@LCODE AS VARCHAR(3)) + ' AND '
			ELSE
				SET @WHERE = @WHERE + '		LEFT(TA.CODE,2) = ' + CAST(@LCODE AS VARCHAR(3)) + ' AND '
		END

	--이전글
	SET @SQL = '' +
			' SELECT TOP 1 ' +
			' 	TB.LNAME,	' +
			' 	TB.MNAME,	' +
			' 	TA.SERIAL,	' +
			' 	TA.CODE,	' +
			' 	TA.TITLE	' +
			' FROM 	' +
			' 		DBO.NESSAY TA(NOLOCK)	' +
			' 		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE=TB.CODE	' +
			' WHERE ' + @WHERE +
			'		TA.SERIAL < ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
			'		1=1  ' +
			'	ORDER BY	' +
			'		TA.MODDATE DESC,  '  +
			'		TA.SERIAL DESC;  '

	--다음글
	SET @SQL = @SQL +
			' SELECT TOP 1 ' +
			' 	TB.LNAME,	' +
			' 	TB.MNAME,	' +
			' 	TA.SERIAL,	' +
			' 	TA.CODE,	' +
			' 	TA.TITLE	' +
			' FROM 	' +
			' 		DBO.NESSAY TA(NOLOCK)	' +
			' 		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE=TB.CODE	' +
			' WHERE ' + @WHERE +
			'		TA.SERIAL > ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
			'		1=1  ' +
			'	ORDER BY	' +
			'		TA.MODDATE ASC,  '  +
			'		TA.SERIAL ASC ;  '

	--댓글
	SET @SQL = @SQL +
			' SELECT ' +
			'		A.SERIAL, ' +
			'		A.CODE, ' +
			'		A.USERID, ' +
			'		A.COMMENT, ' +
			'		A.REGDATE, ' +
			'		A.GRADES, ' +
			'		(SELECT COUNT(B.IDX) FROM NESSAYCOMMENT_MEMO_TB B WHERE B.SERIAL = A.SERIAL AND B.ESSAYSERIAL = A.ESSAYSERIAL) as ReReplyCnt' +
			' FROM ' +
			'		DBO.NESSAYCOMMENT A ' +
			' WHERE ' +
			'		A.ESSAYSERIAL = ' + CAST(@SERIAL AS VARCHAR(10)) +
			'	ORDER BY ' +
			'		A.REGDATE DESC '

-- 댓글의 답변리스트
	SET @SQL = @SQL +
			' SELECT  ' +
			'   IDX ' +
			' , SERIAL ' +
			' , MEMO ' +
			' , UserID ' +
			' , UserNM ' +
			' , REG_DT ' +
			'   FROM NESSAYCOMMENT_MEMO_TB ' +
			' WHERE ' +
			'		ESSAYSERIAL = ' + CAST(@SERIAL AS VARCHAR(10)) +
			'	ORDER BY ' +
			'		REG_DT ASC '


--PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_F_ESSAY_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 정보마당 리스트
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC dbo.[GET_F_ESSAY_LIST_PROC] 1,15,'60','10','',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_ESSAY_LIST_PROC]

	@PAGE					INT,
	@PAGESIZE			INT,

	@LCODE				INT=NULL,
	@MCODE				INT=NULL,

	@SEARCHFIELD	VARCHAR(20)='',
	@SEARCHTEXT		VARCHAR(30)=''
AS

DECLARE
	@SQL				NVARCHAR(4000),
	@WHERE			NVARCHAR(1000)

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	--검색절 SET
	SET @WHERE = ''
	IF @SEARCHFIELD<>''
		BEGIN
			IF @SEARCHFIELD='TITLE'
				SET @WHERE = @WHERE + '		TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
			ELSE IF @SEARCHFIELD='CONTENTS'
				SET @WHERE = @WHERE + '		TA.DESCRIPTION LIKE ''%' + @SEARCHTEXT + '%'' AND '
			ELSE IF @SEARCHFIELD='TITLECONTENTS'
				SET @WHERE = @WHERE + '		(TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' OR TA.DESCRIPTION LIKE ''%' + @SEARCHTEXT + '%'') AND '
		END

	IF @LCODE <> 0 AND @MCODE <> 0
		SET @WHERE = @WHERE + '		TB.GROUPCODE in (select GROUPCODE from NESSAYCODE where code =  ' + CAST(@LCODE AS VARCHAR(3)) + CAST(@MCODE AS VARCHAR(2)) +')  and  '
	ELSE IF @LCODE <> 0
		SET @WHERE = @WHERE + '		TA.CODE = ' + CAST(@LCODE AS VARCHAR(3)) + CAST(@MCODE AS VARCHAR(2)) + ' AND '

	SET @SQL = '' +

			' SELECT TOP 1 ' +
			' 	LNAME, MNAME' +
			'	FROM ' +
			'		DBO.NESSAYCODE ' +
			'	WHERE '	+
			'		LCODE = ' + CAST(@LCODE AS VARCHAR(3)) + ' AND ' +
			'		MCODE = ' + CAST(@MCODE AS VARCHAR(2)) +
			'	;	' +

			'	SELECT ' +
			'		COUNT(*) AS CNT ' +
			'	FROM ' +
			'		DBO.NESSAY TA(NOLOCK) ' +
			' 	LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE=TB.CODE	' +
			' WHERE ' + @WHERE +
			'		TB.DISFLAG = 1 ; ' +

			' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
			' 	TB.LNAME,	' +
			' 	TB.MNAME,	' +
			' 	TA.SERIAL,	' +
			' 	TA.CODE,	' +
			' 	TA.TITLE,	' +
			' 	TA.SOURCE,	' +
			' 	TA.DESCRIPTION,	' +
			' 	TA.MODDATE,	' +
			' 	TA.MAINFLAG,	' +
			' 	TA.MAINLISTFLAG,	' +
			' 	TA.CMTCNT,	' +
			' 	TA.CNT,	' +
			' 	TA.STYLE,	' +
			' 	TA.IMGSRC3,	' +
			' 	TA.IMGSRC4,	' +
			' 	(SELECT ISNULL(SUM(GRADES),0) FROM DBO.NESSAYCOMMENT WHERE ESSAYSERIAL = TA.SERIAL) AS GRADES,	' +
			' 	TA.SUMMARY	' +
			' FROM 	' +
			' 		DBO.NESSAY TA(NOLOCK)	' +
			' 		LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE=TB.CODE	' +
			' WHERE ' + @WHERE +
			'		TB.DISFLAG = 1 ' +
			'	ORDER BY	' +
			'		TA.MODDATE DESC,  '  +
			'		TA.SERIAL DESC  '

--	PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_F_FA_MAIN_NESSAY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- GET_F_FA_MAIN_NESSAY_PROC 6010

CREATE PROC [dbo].[GET_F_FA_MAIN_NESSAY_PROC]

  @CODE INT = 0

AS

  BEGIN

    IF @CODE = 0
      BEGIN
/*
        SELECT TOP 5 TA.IDX AS SERIAL
                  ,0 AS CODE
                  ,0 AS IMAGEF
                  ,TA.TITLE
                  ,NULL AS SUMMARY
                  ,CONVERT(VARCHAR(10),TA.RegDate,120) AS REG_DT
          FROM dbo.READEREVENT2 AS TA(NOLOCK)
            JOIN dbo.READERROUND2 AS TB(NOLOCK) ON TB.NDX = TA.NDX
         WHERE TA.DELFLAG = '0'
           AND TA.Drew = 1
         ORDER BY TA.REF DESC, TA.STEP ASC, TA.REGDATE DESC
*/
        SELECT TOP 5 TA.SERIAL AS SERIAL
                  ,TA.CODE AS CODE
                  ,0 AS IMAGEF
                  ,TA.TITLE
                  ,NULL AS SUMMARY
                  ,CONVERT(VARCHAR(10),TA.MODDATE,120) AS REG_DT
           FROM DBO.NESSAY AS TA WITH(NOLOCK)	 		
            LEFT JOIN DBO.NESSAYCODE AS TB WITH(NOLOCK) ON TA.CODE=TB.CODE	 
          WHERE TA.CODE = 5018
            AND TB.DISFLAG = 1 	
          ORDER BY TA.MODDATE DESC, TA.SERIAL DESC

      END
		ELSE IF @CODE = 90001
			BEGIN
				SELECT TOP 3 * FROM
				(
					SELECT TOP 1 
						'1' AS ORD,
						BOARDCODE,
						BOARDCODENM,
						CONVERT(VARCHAR(10), REGDATE, 120) AS REG_DT
					FROM BD_LOCALEVENTCODE_TB WITH(NOLOCK)
					WHERE BOARDCODENM LIKE '%스도%'
						AND BRANCH_CD = 0 AND DELFLAG = '0' AND DISFLAG = 'Y' 
					ORDER BY MODDATE DESC
					UNION ALL
					SELECT TOP 1 
						'2' AS ORD,
						BOARDCODE,
						BOARDCODENM,
						CONVERT(VARCHAR(10), REGDATE, 120) AS REG_DT
					FROM BD_LOCALEVENTCODE_TB
					WHERE BOARDCODENM LIKE '%행시%'
						AND BRANCH_CD = 0 AND DELFLAG = '0' AND DISFLAG = 'Y' 
					ORDER BY MODDATE DESC
					UNION ALL
					SELECT TOP 1 
						'3' AS ORD,
						BOARDCODE,
						BOARDCODENM,
						CONVERT(VARCHAR(10), REGDATE, 120) AS REG_DT
					FROM BD_LOCALEVENTCODE_TB WITH(NOLOCK)
					WHERE BOARDCODENM LIKE '%포토%'
						AND BRANCH_CD = 0 AND DELFLAG = '0' AND DISFLAG = 'Y' 
					ORDER BY MODDATE DESC
				) AS LOCALEEVENT
				ORDER BY ORD ASC
			END
    ELSE
      BEGIN

		select   TA.SERIAL,TA.CODE
				,CASE WHEN TA.IMGSRC3 IS NULL THEN 0
					  ELSE 1
				  END AS IMAGEF
				,TA.TITLE
				,TA.SUMMARY
				,CONVERT(VARCHAR(10),TA.MODDATE,120) AS REG_DT
		FROM dbo.NESSAY AS TA  WITH(NOLOCK)
		WHERE SERIAL IN(
		SELECT TOP 3 	TA.SERIAL
		FROM dbo.NESSAY AS TA  WITH(NOLOCK)
		LEFT JOIN DBO.NESSAYCODE TB  WITH(NOLOCK) ON TB.CODE = TA.CODE
		WHERE 		TB.GROUPCODE in (select GROUPCODE from NESSAYCODE where code =  @CODE) 

		AND TB.DISFLAG = 1
		--AND TA.IMGSRC3 IS NOT NULL
		ORDER BY TA.MODDATE DESC ,TA.SERIAL DESC
		)  
		order by TA.MODDATE DESC ,TA.SERIAL DESC


      END

  END

GO
/****** Object:  StoredProcedure [dbo].[GET_F_FA_SURVEY_ANSWER_TB_JOINYN_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 참여 여부
*  EXEC : DBO.GET_F_FA_SURVEY_ANSWER_TB_JOINYN_PROC 'test',1
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/10/18) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_F_FA_SURVEY_ANSWER_TB_JOINYN_PROC]
(
		@strUserID			VARCHAR(30)
  , @SURVEY_ID      INT
)
AS
SET NOCOUNT ON

--이미 참여한 회원
SELECT IDX FROM FA_SURVEY_ANSWER_TB
 WHERE USERID = @strUserID
   AND SURVEY_ID = @SURVEY_ID

GO
/****** Object:  StoredProcedure [dbo].[GET_F_FA_SURVEY_QUESTION_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 질문정보
*  EXEC : GET_F_FA_SURVEY_QUESTION_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010-10-19) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_F_FA_SURVEY_QUESTION_TB_LIST_PROC]
(
  	@nSurvey_ID	  INT


)
AS
SET NOCOUNT ON




SELECT QUESTION_DIV
     , ANSWER_CNT
     , QUESTION_TITLE
     , ANSWER1
     , ANSWER2
     , ANSWER3

     , ANSWER4
     , ANSWER5
     , ANSWER6
     , RESPONSE_CNT
     , INPUT_DIV

     , CHAR_LIMIT_CNT
     , INDEX_NUM

  FROM FA_SURVEY_QUESTION_TB
 WHERE SURVEY_ID = @nSurvey_ID
 ORDER BY INDEX_NUM ASC

GO
/****** Object:  StoredProcedure [dbo].[GET_F_FA_SURVEY_TB_INFO_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 정보
*  EXEC : GET_F_FA_SURVEY_TB_INFO_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010-10-18) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_F_FA_SURVEY_TB_INFO_PROC]
(
  	@nSurvey_ID	  INT


)
AS
SET NOCOUNT ON

SELECT  TITLE
      , JOIN_DIV
      , START_DT
      , END_DT
      , PRIZE_YN
      , PRIZE_CONTS

      , PRIZE_IMG
      , PRIZE_DT
      , GIVE_DT
      , PROGRESS_DIV
  FROM FA_SURVEY_TB
 WHERE SURVEY_ID = @nSurvey_ID

GO
/****** Object:  StoredProcedure [dbo].[GET_F_FA_SURVEY_TB_INFO_SEMI_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 기초정보
*  EXEC : GET_F_FA_SURVEY_TB_INFO_SEMI_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_F_FA_SURVEY_TB_INFO_SEMI_PROC]
(
  	@nSurvey_ID	  INT


)
AS
SET NOCOUNT ON

SELECT  TITLE
      , JOIN_DIV
      , PROGRESS_DIV
  FROM FA_SURVEY_TB
 WHERE SURVEY_ID = @nSurvey_ID

GO
/****** Object:  StoredProcedure [dbo].[GET_F_LOCALEVENT_BOARD_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장플러스 - 지역이벤트 게시판이름 가져오기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/28
 *  수정일/수정자: 20180813 김선호 이벤트명 불러오는 테이블 변경
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.[GET_F_LOCALEVENT_BOARD_PROC_BK01] 0,3
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_LOCALEVENT_BOARD_PROC]
    @BRANCH_CD INT,
    @CODE    INT
AS
	DECLARE @BCODE INT
	IF @CODE = 1 
	BEGIN
		SET @BCODE = 2
	END
	ELSE IF @CODE = 2
	BEGIN
		SET @BCODE = 3
	END
	ELSE IF @CODE = 3
	BEGIN
		SET @BCODE = 1
	END
	
	/*
    SELECT
        BRANCH_CD,
        BOARDCODE,
        BOARDCODENM
    FROM
        DBO.BD_LOCALEVENTCODE_TB(NOLOCK)
    WHERE
        BRANCH_CD = @BRANCH_CD AND
        BOARDCODE = @CODE
    */
     
    SELECT TOP(1)
        0 AS BRANCH_CD
        ,@CODE AS BOARDCODE
        ,(CASE EVENT_TYPE WHEN 1 THEN '행시이벤트' WHEN 2 THEN '포토갤러리' WHEN 3 THEN '스도쿠' WHEN 4 THEN '독자글마당' WHEN 5 THEN '깜짝이벤트' END) AS BOARDCODENM
    FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB WITH(NOLOCK)
    WHERE DEL_YN = 'N' AND VIEW_TYPE = 1 AND EVENT_TYPE = @BCODE
    
        

GO
/****** Object:  StoredProcedure [dbo].[GET_F_LOCALEVENT_BOARD_PROC_BK01]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장플러스 - 지역이벤트 게시판이름 가져오기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/28
 *  수정일/수정자: 20180813 김선호 이벤트명 불러오는 테이블 변경
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_LOCALEVENT_BOARD_PROC 0,3
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_LOCALEVENT_BOARD_PROC_BK01]
    @BRANCH_CD INT,
    @CODE    INT
AS
	DECLARE @BCODE INT
	IF @CODE = 1 
	BEGIN
		SET @BCODE = 2
	END
	ELSE IF @CODE = 2
	BEGIN
		SET @BCODE = 3
	END
	ELSE IF @CODE = 3
	BEGIN
		SET @BCODE = 1
	END
	
	/*
    SELECT
        BRANCH_CD,
        BOARDCODE,
        BOARDCODENM
    FROM
        DBO.BD_LOCALEVENTCODE_TB(NOLOCK)
    WHERE
        BRANCH_CD = @BRANCH_CD AND
        BOARDCODE = @CODE
    */
     
    SELECT TOP(1)
        0 AS BRANCH_CD
        ,@CODE AS BOARDCODE
        ,(CASE EVENT_TYPE WHEN 1 THEN '행시이벤트' WHEN 2 THEN '포토갤러리' WHEN 3 THEN '스도쿠' WHEN 4 THEN '독자글마당' WHEN 5 THEN '깜짝이벤트' END) AS BOARDCODENM
    FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB WITH(NOLOCK)
    WHERE DEL_YN = 'N' AND VIEW_TYPE = 1 AND EVENT_TYPE = @BCODE
    
        

GO
/****** Object:  StoredProcedure [dbo].[GET_F_LOCALEVENT_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장플러스 - 지역이벤트 상세보기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_LOCALEVENT_DETAIL_PROC 2798, 1, 11, '',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_LOCALEVENT_DETAIL_PROC]
	@SERIAL 	    INT,
	@CODE	        INT,
    @BRANCH_CD      INT,

	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)=''
AS

SET NOCOUNT ON

DECLARE
	@SQL		NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET @SQL    =''
	SET @WHERE  = ''

	--VIEWCNT++
	UPDATE
		DBO.BD_LOCALEVENT_TB
	SET
		VIEWCNT=VIEWCNT + 1
	WHERE
		SERIAL = @SERIAL

	-- 글 내용
	SELECT
		TOP 1
		TA.BOARDCODE,
		TA.TITLE,
		TA.USERNAME,
		TA.USERID,
		TA.REGDATE,
		TA.VIEWCNT,
		TA.PICFILE,
		TA.CONTENTS,
		TB.BOARDCODENM,
        TA.RENO,
        TA.STEP,
        TB.SECFLAG,
        TB.PICFLAG
	FROM
		DBO.BD_LOCALEVENT_TB TA(NOLOCK)
		INNER JOIN DBO.BD_LOCALEVENTCODE_TB TB(NOLOCK)
		ON TA.BOARDCODE = TB.BOARDCODE AND TA.BRANCH_CD=TB.BRANCH_CD
	WHERE
		TA.SERIAL = @SERIAL AND
        TB.BRANCH_CD = @BRANCH_CD

    --검색절 SET
    IF @SEARCHTEXT<>''
    	BEGIN
    		IF @SEARCHFIELD='TITLE'
    			SET @WHERE = @WHERE + '		TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
    		IF @SEARCHFIELD='CONTENTS'
    			SET @WHERE = @WHERE + '		TA.CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
    	END

    --이전글
	SET @SQL = @SQL +
		'	SELECT TOP 1	' +
    	'		TA.SERIAL, TA.BOARDCODE, TA.TITLE, TA.RENO, TA.STEP	' +
		'	FROM ' +
		'		DBO.BD_LOCALEVENT_TB TA(NOLOCK)	' +
		' WHERE ' +  @WHERE +
		'		TA.SERIAL > ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
    	'		TA.BOARDCODE = '''+ CAST(@CODE AS VARCHAR(3)) +''' AND ' +
    	'		TA.BRANCH_CD = '''+ CAST(@BRANCH_CD AS VARCHAR(3)) +''' AND ' +
		'		TA.DELFLAG = ''0'' AND ' +
		'		1=1	' +
		'	ORDER BY ' +
		'		SERIALNO ASC, RENO DESC; ' +

	--다음글
    	'	SELECT TOP 1	' +
    	'		TA.SERIAL, TA.BOARDCODE, TA.TITLE, TA.RENO, TA.STEP	' +
    	'	FROM ' +
    	'		DBO.BD_LOCALEVENT_TB TA(NOLOCK)	' +
    	' WHERE ' +  @WHERE +
    	'		TA.SERIAL < ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
    	'		TA.BOARDCODE = '''+  CAST(@CODE AS VARCHAR(3)) +''' AND ' +
    	'		TA.BRANCH_CD = '''+ CAST(@BRANCH_CD AS VARCHAR(3)) +''' AND ' +
    	'		TA.DELFLAG = ''0'' AND ' +
    	'		1=1	' +
    	'	ORDER BY ' +
    	'		SERIALNO DESC, RENO ; '

	--PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_F_LOCALEVENT_DETAIL_PROC_VER2]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장플러스 - 지역이벤트 상세보기
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : BOARDCODE(CODE)를 입력받지 않는다
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_LOCALEVENT_DETAIL_PROC_VER2 2798, 1, 11, '',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_LOCALEVENT_DETAIL_PROC_VER2]
	@SERIAL 				INT,
	@CODE						INT,
  @BRANCH_CD      INT,
	@SEARCHFIELD		VARCHAR(10)='',
	@SEARCHTEXT			VARCHAR(30)=''
AS

SET NOCOUNT ON

DECLARE
	@SQL		NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET @SQL    =''
	SET @WHERE  = ''

	--VIEWCNT++
	UPDATE
		DBO.BD_LOCALEVENT_TB
	SET
		VIEWCNT=VIEWCNT + 1
	WHERE
		SERIAL = @SERIAL

	-- 글 내용
	SELECT
		TOP 1
		TA.BOARDCODE,
		TA.TITLE,
		TA.USERNAME,
		TA.USERID,
		TA.REGDATE,
		TA.VIEWCNT,
		TA.PICFILE,
		TA.CONTENTS,
		TB.BOARDCODENM,
        TA.RENO,
        TA.STEP,
        TB.SECFLAG,
        TB.PICFLAG
	FROM
		DBO.BD_LOCALEVENT_TB TA(NOLOCK)
		INNER JOIN DBO.BD_LOCALEVENTCODE_TB TB(NOLOCK)
		ON TA.BOARDCODE = TB.BOARDCODE AND TA.BRANCH_CD=TB.BRANCH_CD
	WHERE
		TA.SERIAL = @SERIAL AND
        TB.BRANCH_CD = @BRANCH_CD

    --검색절 SET
    IF @SEARCHTEXT<>''
    	BEGIN
    		IF @SEARCHFIELD='TITLE'
    			SET @WHERE = @WHERE + '		TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
    		IF @SEARCHFIELD='CONTENTS'
    			SET @WHERE = @WHERE + '		TA.CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
    	END

    --이전글
	SET @SQL = @SQL +
		'	SELECT TOP 1	' +
    	'		TA.SERIAL, TA.BOARDCODE, TA.TITLE, TA.RENO, TA.STEP	' +
		'	FROM ' +
		'		DBO.BD_LOCALEVENT_TB TA(NOLOCK)	' +
		' WHERE ' +  @WHERE +
		'		TA.SERIAL > ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
		'		TA.BOARDCODE = (SELECT BOARDCODE FROM BD_LOCALEVENT_TB WITH (NOLOCK) WHERE SERIAL = ''' + CAST(@SERIAL AS VARCHAR(10)) + ''') AND ' +
    --'		TA.BOARDCODE = '''+ CAST(@CODE AS VARCHAR(3)) +''' AND ' +
    '		TA.BRANCH_CD = '''+ CAST(@BRANCH_CD AS VARCHAR(3)) +''' AND ' +
		'		TA.DELFLAG = ''0'' AND ' +
		'		1=1	' +
		'	ORDER BY ' +
		'		SERIALNO ASC, RENO DESC; ' +

	--다음글
    	'	SELECT TOP 1	' +
    	'		TA.SERIAL, TA.BOARDCODE, TA.TITLE, TA.RENO, TA.STEP	' +
    	'	FROM ' +
    	'		DBO.BD_LOCALEVENT_TB TA(NOLOCK)	' +
    	' WHERE ' +  @WHERE +
    	'		TA.SERIAL < ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
    	'		TA.BOARDCODE = (SELECT BOARDCODE FROM BD_LOCALEVENT_TB WITH (NOLOCK) WHERE SERIAL = ''' + CAST(@SERIAL AS VARCHAR(10)) + ''') AND ' +
			--'		TA.BOARDCODE = '''+  CAST(@CODE AS VARCHAR(3)) +''' AND ' +			
    	'		TA.BRANCH_CD = '''+ CAST(@BRANCH_CD AS VARCHAR(3)) +''' AND ' +
    	'		TA.DELFLAG = ''0'' AND ' +
    	'		1=1	' +
    	'	ORDER BY ' +
    	'		SERIALNO DESC, RENO ; '

	PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_F_LOCALEVENT_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 지역이벤트 리스트
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_LOCALEVENT_LIST_PROC 1,10, 11, 2, '', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_LOCALEVENT_LIST_PROC]
    @PAGE         INT=1,
    @PAGESIZE	  INT=10,

    @BRANCH_CD    INT=0,
    @CODE         INT=0,

    @SEARCHFIELD  VARCHAR(10)='',
    @SEARCHTEXT   VARCHAR(30)=''

AS

DECLARE
    @SQL		  NVARCHAR(4000),
    @WHERE		  NVARCHAR(1000)

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

    SET @WHERE=''

    IF @BRANCH_CD<>0
        BEGIN
            SET @WHERE = @WHERE + '		AA.BRANCH_CD = ' + CAST(@BRANCH_CD AS VARCHAR(3)) + ' AND '
        END

    IF @SEARCHFIELD<>''
        BEGIN
        	IF @SEARCHFIELD='TITLE'
        		SET @WHERE = @WHERE + '		BB.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
        	ELSE IF @SEARCHFIELD='CONTENTS'
        		SET @WHERE = @WHERE + '		BB.CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
        	ELSE IF @SEARCHFIELD='TITLECONTENTS'
        		SET @WHERE = @WHERE + '		(BB.TITLE LIKE ''%' + @SEARCHTEXT + '%'' OR BB.CONTENTS LIKE ''%' + @SEARCHTEXT + '%'') AND '
        END

    IF @CODE<>0
        BEGIN
            SET @WHERE = @WHERE + '		AA.BOARDCODE = ' + CAST(@CODE AS VARCHAR(3)) + ' AND '
        END

    SET @SQL = '' +
        -- 게시판 정보
        ' SELECT BOARDCODENM, INTRO, IMG, PICFLAG FROM DBO.BD_LOCALEVENTCODE_TB(NOLOCK) '+
        ' WHERE DISFLAG=''Y'' AND BRANCH_CD='+ CAST(@BRANCH_CD AS VARCHAR(3)) +' AND BOARDCODE = ' + CAST(@CODE AS VARCHAR(3)) +' ; '+

        -- 게시물 카운트
        ' SELECT ' +
        '     COUNT(BB.SERIAL) AS CNT ' +
        ' FROM ' +
        '     DBO.BD_LOCALEVENTCODE_TB AA(NOLOCK) ' +
        '     INNER JOIN DBO.BD_LOCALEVENT_TB BB(NOLOCK) ' +
        '     ON AA.BOARDCODE=BB.BOARDCODE AND AA.BRANCH_CD=BB.BRANCH_CD ' +
        ' WHERE ' +  @WHERE +
        '     BB.DELFLAG=''0'' AND AA.DISFLAG=''Y'' AND ' +
        '     AA.BRANCH_CD='+ CAST(@BRANCH_CD AS VARCHAR(3)) +


        -- 게시물 내용
        ' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
        '     BB.SERIAL, ' +
        '     BB.TITLE, ' +
        '     BB.USERNAME, ' +
        '     BB.REGDATE, ' +
        '     BB.VIEWCNT, ' +
        '     BB.STEP, ' +
        '     BB.RENO,' +
        '     BB.PICFILE, ' +
        '     BB.USERID ' +
        ' FROM ' +
        '     DBO.BD_LOCALEVENTCODE_TB AA(NOLOCK) ' +
        '     INNER JOIN DBO.BD_LOCALEVENT_TB BB(NOLOCK) ' +
        '     ON AA.BOARDCODE=BB.BOARDCODE AND AA.BRANCH_CD=BB.BRANCH_CD ' +
        ' WHERE ' +  @WHERE +
        '     BB.DELFLAG=''0'' AND AA.DISFLAG=''Y'' AND ' +
        '     AA.BRANCH_CD='+ CAST(@BRANCH_CD AS VARCHAR(3)) +
        ' ORDER BY ' +
        '     SERIALNO DESC, RENO '

    --PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_F_LOCALEVENT_LIST_PROC_VER2]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 지역이벤트 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 스도쿠, 행시이벤트, 포토갤러리 외에 이벤트 추가시 여기에 조건문 추가 필
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_LOCALEVENT_LIST_PROC_VER2 1,10, 0, 22, '', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_LOCALEVENT_LIST_PROC_VER2]
    @PAGE         INT=1,
    @PAGESIZE	  INT=10,
    @BRANCH_CD    INT=0,
    @CODE         INT=0,
    @SEARCHFIELD  VARCHAR(10)='',
    @SEARCHTEXT   VARCHAR(30)=''
AS

DECLARE
    @SQL		  NVARCHAR(4000),
    @WHERE		  NVARCHAR(1000)

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

    SET @WHERE = ''

    IF @BRANCH_CD<>0
        BEGIN
            SET @WHERE = @WHERE + '		AA.BRANCH_CD = ' + CAST(@BRANCH_CD AS VARCHAR(3)) + ' AND '
        END

    IF @SEARCHFIELD<>''
        BEGIN
        	IF @SEARCHFIELD='TITLE'
        		SET @WHERE = @WHERE + '		BB.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
        	ELSE IF @SEARCHFIELD='CONTENTS'
        		SET @WHERE = @WHERE + '		BB.CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
        	ELSE IF @SEARCHFIELD='TITLECONTENTS'
        		SET @WHERE = @WHERE + '		(BB.TITLE LIKE ''%' + @SEARCHTEXT + '%'' OR BB.CONTENTS LIKE ''%' + @SEARCHTEXT + '%'') AND '
        END

    IF @CODE <> 0
    BEGIN
			DECLARE @VBOARDNM CHAR(10)
			SET @VBOARDNM = (SELECT TOP 1 LEFT(BOARDCODENM, 2) AS SNAME FROM BD_LOCALEVENTCODE_TB WHERE BOARDCODE = @CODE AND BRANCH_CD = 0 AND DELFLAG = '0' AND DISFLAG = 'Y' ORDER BY MODDATE DESC)

			IF @VBOARDNM = '포토' 
			BEGIN
				SET @WHERE = @WHERE + '	AA.BOARDCODE IN (1,  ' + CAST(@CODE AS VARCHAR(3)) + ') AND '
			END
			ELSE IF @VBOARDNM = '스도' 
			BEGIN
				SET @WHERE = @WHERE + '	AA.BOARDCODE IN (2,  ' + CAST(@CODE AS VARCHAR(3)) + ') AND '
			END
			ELSE IF @VBOARDNM = '행시' 
			BEGIN
				SET @WHERE = @WHERE + '	AA.BOARDCODE IN (3,  ' + CAST(@CODE AS VARCHAR(3)) + ') AND '
			END
			ELSE
			BEGIN
				SET @WHERE = @WHERE + '	AA.BOARDCODE = ' + CAST(@CODE AS VARCHAR(3)) + ' AND '
			END
    END

    SET @SQL = '' +
        -- 게시판 정보
        ' SELECT BOARDCODENM, INTRO, IMG, PICFLAG FROM DBO.BD_LOCALEVENTCODE_TB(NOLOCK) '+
        ' WHERE DISFLAG=''Y'' AND BRANCH_CD='+ CAST(@BRANCH_CD AS VARCHAR(3)) +' AND BOARDCODE = ' + CAST(@CODE AS VARCHAR(3)) +' ; '+

        -- 게시물 카운트
        ' SELECT ' +
        '     COUNT(BB.SERIAL) AS CNT ' +
        ' FROM ' +
        '     DBO.BD_LOCALEVENTCODE_TB AA(NOLOCK) ' +
        '     INNER JOIN DBO.BD_LOCALEVENT_TB BB(NOLOCK) ' +
        '     ON AA.BOARDCODE=BB.BOARDCODE AND AA.BRANCH_CD=BB.BRANCH_CD ' +
        ' WHERE ' +  @WHERE +
        '     BB.DELFLAG=''0'' AND AA.DISFLAG=''Y'' AND ' +
        '     AA.BRANCH_CD='+ CAST(@BRANCH_CD AS VARCHAR(3)) +


        -- 게시물 내용
        ' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
        '     BB.SERIAL, ' +
        '     BB.TITLE, ' +
        '     BB.USERNAME, ' +
        '     BB.REGDATE, ' +
        '     BB.VIEWCNT, ' +
        '     BB.STEP, ' +
        '     BB.RENO,' +
        '     BB.PICFILE, ' +
        '     BB.USERID ' +
        ' FROM ' +
        '     DBO.BD_LOCALEVENTCODE_TB AA(NOLOCK) ' +
        '     INNER JOIN DBO.BD_LOCALEVENT_TB BB(NOLOCK) ' +
        '     ON AA.BOARDCODE=BB.BOARDCODE AND AA.BRANCH_CD=BB.BRANCH_CD ' +
        ' WHERE ' +  @WHERE +
        '     BB.DELFLAG=''0'' AND AA.DISFLAG=''Y'' AND ' +
        '     AA.BRANCH_CD='+ CAST(@BRANCH_CD AS VARCHAR(3)) +
        ' ORDER BY ' +
        '     SERIALNO DESC, RENO '

    PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_F_LOCALNEWS_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 지역소식 상세
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_LOCALNEWS_DETAIL_PROC 23714, 9, '', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_LOCALNEWS_DETAIL_PROC]
    @SERIAL         INT,
	@CODE	        INT=0,

	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)=''
AS

    SET NOCOUNT ON

	DECLARE
		@SQL		NVARCHAR(4000),
		@WHERE		NVARCHAR(1000)

	SET @SQL = ''
	SET @WHERE = ''

    -- 조회수 1 증가
    UPDATE DBO.BD_LOCALNEWS_TB
    SET INQCNT=INQCNT+1
    WHERE
        SERIAL=@SERIAL

    -- 상세항목
    SELECT
        AA.BRANCH_CD,
        AA.NEWSCODE,
        AA.NEWSCODENM,
        BB.TITLE,
        BB.REGDATE,
        BB.HTMLFLAG,
        BB.IMGSRC1,
        BB.DESCRIPTION
    FROM
        DBO.BD_LOCALNEWSCODE_TB AA(NOLOCK)
        INNER JOIN DBO.BD_LOCALNEWS_TB BB(NOLOCK) ON AA.BRANCH_CD=BB.BRANCH_CD AND AA.NEWSCODE=BB.NEWSCODE
    WHERE
        AA.DELFLAG='0' AND
        AA.DISFLAG='Y' AND
        BB.DISFLAG='Y' AND
        BB.SERIAL=@SERIAL

    -- 이전글, 다음글
    IF @SEARCHTEXT<>''
        BEGIN
        	IF @SEARCHFIELD='TITLE'
        		SET @WHERE = @WHERE + '		BB.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
        	ELSE IF @SEARCHFIELD='CONTENTS'
        		SET @WHERE = @WHERE + '		BB.DESCRIPTION LIKE ''%' + @SEARCHTEXT + '%'' AND '
        	ELSE IF @SEARCHFIELD='TITLECONTENTS'
        		SET @WHERE = @WHERE + '		(BB.TITLE LIKE ''%' + @SEARCHTEXT + '%'' OR BB.DESCRIPTION LIKE ''%' + @SEARCHTEXT + '%'') AND '
        END

    IF @CODE<>0
        BEGIN
            SET @WHERE = @WHERE + '		AA.NEWSCODE = ' + CAST(@CODE AS VARCHAR(3)) + ' AND '
        END

	--이전글
	SET @SQL = '' +
		' SELECT TOP 1 ' +
        '     AA.NEWSCODENM, ' +
        '     AA.NEWSCODE, ' +
        '     BB.SERIAL, ' +
        '     BB.TITLE ' +
        ' FROM ' +
        '     DBO.BD_LOCALNEWSCODE_TB AA(NOLOCK) ' +
        '     INNER JOIN DBO.BD_LOCALNEWS_TB BB(NOLOCK) ON AA.NEWSCODE=BB.NEWSCODE ' +
		' WHERE ' + @WHERE +
        '       AA.DELFLAG=''0'' AND AA.DISFLAG=''Y'' AND BB.DISFLAG=''Y'' AND ' +
		'		BB.SERIAL < ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
		'		1=1  ' +
		' ORDER BY	' +
		'		BB.REGDATE DESC,  '  +
		'		AA.NEWSCODE ASC;  '

	--다음글
	SET @SQL = @SQL +
		' SELECT TOP 1 ' +
        '     AA.NEWSCODENM, ' +
        '     AA.NEWSCODE, ' +
        '     BB.SERIAL, ' +
        '     BB.TITLE ' +
        ' FROM ' +
        '     DBO.BD_LOCALNEWSCODE_TB AA(NOLOCK) ' +
        '     INNER JOIN DBO.BD_LOCALNEWS_TB BB(NOLOCK) ON AA.NEWSCODE=BB.NEWSCODE ' +
		' WHERE ' + @WHERE +
        '       AA.DELFLAG=''0'' AND AA.DISFLAG=''Y'' AND BB.DISFLAG=''Y'' AND ' +
		'		BB.SERIAL > ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
		'		1=1  ' +
		' ORDER BY	' +
		'		BB.REGDATE ASC,  '  +
		'		AA.NEWSCODE DESC;  '

	--댓글
	SET @SQL = @SQL +
		' SELECT ' +
		'		A.SERIAL, ' +
		'		A.LOCALNEWSSERIAL, ' +
		'		A.USERID, ' +
		'		A.COMMENT, ' +
		'		A.REGDATE ' +
		' FROM ' +
		'		DBO.BD_LOCALNEWS_COMMENT_TB A ' +
		' WHERE ' +
		'		A.LOCALNEWSSERIAL = ' + CAST(@SERIAL AS VARCHAR(10)) +
		'	ORDER BY ' +
		'		A.REGDATE DESC '


    --PRINT @SQL
    EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_F_LOCALNEWS_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 지역소식 리스트
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_LOCALNEWS_LIST_PROC 1,10, 11, 66, '', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_LOCALNEWS_LIST_PROC]
    @PAGE         INT=1,
    @PAGESIZE	  INT=10,

    @BRANCH_CD    INT=0,
    @CODE         INT=0,

    @SEARCHFIELD  VARCHAR(10)='',
    @SEARCHTEXT   VARCHAR(30)=''

AS

DECLARE
    @SQL		  NVARCHAR(4000),
    @WHERE		  NVARCHAR(1000)

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

    SET @WHERE=''

    --IF @BRANCH_CD<>0
        --BEGIN
            SET @WHERE = @WHERE + '		AA.BRANCH_CD = ' + CAST(@BRANCH_CD AS VARCHAR(3)) + ' AND '
        --END

    IF @SEARCHTEXT<>''
        BEGIN
        	IF @SEARCHFIELD='TITLE'
        		SET @WHERE = @WHERE + '		BB.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
        	ELSE IF @SEARCHFIELD='CONTENTS'
        		SET @WHERE = @WHERE + '		BB.DESCRIPTION LIKE ''%' + @SEARCHTEXT + '%'' AND '
        	ELSE IF @SEARCHFIELD='TITLECONTENTS'
        		SET @WHERE = @WHERE + '		(BB.TITLE LIKE ''%' + @SEARCHTEXT + '%'' OR BB.DESCRIPTION LIKE ''%' + @SEARCHTEXT + '%'') AND '
        END

    IF @CODE<>0
        BEGIN
            SET @WHERE = @WHERE + '		AA.NEWSCODE = ' + CAST(@CODE AS VARCHAR(3)) + ' AND '
        END

    SET @SQL = '' +
        -- 분류명
        ' SELECT TOP 1 NEWSCODENM FROM DBO.BD_LOCALNEWSCODE_TB(NOLOCK) ' +
        ' WHERE BRANCH_CD='+ CAST(@BRANCH_CD AS VARCHAR(3)) +' AND DISFLAG=''Y'' AND DELFLAG=''0'' ' +
        '       AND NEWSCODE='+  CAST(@CODE AS VARCHAR(3)) + ' ; ' +

        -- 게시물카운트
        ' SELECT COUNT(BB.SERIAL) AS CNT ' +
        ' FROM ' +
        '     DBO.BD_LOCALNEWSCODE_TB AA(NOLOCK) ' +
        '     INNER JOIN DBO.BD_LOCALNEWS_TB BB(NOLOCK) ON AA.NEWSCODE=BB.NEWSCODE AND AA.BRANCH_CD=BB.BRANCH_CD ' +
        ' WHERE ' + @WHERE +
        '      AA.DISFLAG=''Y'' AND AA.DELFLAG=''0'' AND BB.DISFLAG=''Y'' ; ' +

        -- 게시물 내용 가져오기
        ' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
        '     AA.BRANCH_CD, ' +
        '     AA.NEWSCODENM, ' +
        '     AA.NEWSCODE, ' +
        '     BB.SERIAL, ' +
        '     BB.TITLE, ' +
        '     BB.SUMMARY, ' +
        '     BB.DESCRIPTION, ' +
        '     BB.HTMLFLAG, ' +
        '     BB.IMGSRC1, ' +
        '     BB.REGDATE, ' +
        '     (SELECT ISNULL(COUNT(SERIAL),0) FROM DBO.BD_LOCALNEWS_COMMENT_TB(NOLOCK) WHERE LOCALNEWSSERIAL=BB.SERIAL) AS CMTCNT ' +
        ' FROM ' +
        '     DBO.BD_LOCALNEWSCODE_TB AA(NOLOCK) ' +
        '     INNER JOIN DBO.BD_LOCALNEWS_TB BB(NOLOCK) ON AA.NEWSCODE=BB.NEWSCODE AND AA.BRANCH_CD=BB.BRANCH_CD ' +
        ' WHERE ' + @WHERE +
        '      AA.DISFLAG=''Y'' AND AA.DELFLAG=''0'' AND BB.DISFLAG=''Y'' ' +
    	' ORDER BY	' +
    	'    BB.REGDATE DESC,  '  +
    	'	 BB.SERIAL DESC  '

    --PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAIN_BOARDPLUS_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 전국판 메인 : 벼룩시장 플러스
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2009/09/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : Create_Main_BDPlus.vbs
 *  사 용  예 제 : EXEC DBO.GET_F_MAIN_BOARDPLUS_PROC
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_MAIN_BOARDPLUS_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @IMG_SERIAL INT

  -- 이미지 기사 (임시테이블 저장)
  SELECT TOP 2
         A.SERIAL
        ,A.CODE
        ,B.LNAME
        ,A.TITLE
        ,A.SUMMARY
    INTO #IMG_ROW_TB
    FROM DBO.NESSAY A
    LEFT JOIN DBO.NESSAYCODE B
           ON B.CODE = A.CODE
   WHERE B.DISFLAG = '1'
     AND A.MAINFLAG = '1'
     AND A.IMGSRC3 IS NOT NULL
   ORDER BY A.MODDATE DESC, A.SERIAL DESC

  -- 이미지 기사
  SELECT SERIAL
        ,CODE
        ,LNAME
        ,TITLE
        ,SUMMARY
    FROM #IMG_ROW_TB

  -- 나머지 리스트
  SELECT TOP 2
         A.SERIAL
        ,A.CODE
        ,B.LNAME
        ,A.TITLE
        ,A.SUMMARY
    FROM DBO.NESSAY A(NOLOCK)
    LEFT JOIN DBO.NESSAYCODE B(NOLOCK) ON B.CODE = A.CODE
   WHERE B.DISFLAG = '1'
     AND A.MAINFLAG = '1'
     AND A.SERIAL NOT IN (SELECT SERIAL FROM #IMG_ROW_TB)
   ORDER BY A.MODDATE DESC, A.SERIAL DESC

  -- 임시 테이블(#IMG_ROW_TB) 삭제
  DROP TABLE #IMG_ROW_TB

GO
/****** Object:  StoredProcedure [dbo].[GET_F_PLUS_LEFTLOCALMENU_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 벼룩시장플러스 - 지역소식,지역이벤트 - 좌측메뉴가져오기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_PLUS_LEFTLOCALMENU_PROC 11
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_PLUS_LEFTLOCALMENU_PROC]
    @BRANCH_CD INT
AS

SET NOCOUNT ON
BEGIN

    -- 지역소식 메뉴
    SELECT
        NEWSCODE, NEWSCODENM
    FROM
        DBO.BD_LOCALNEWSCODE_TB(NOLOCK)
    WHERE
        BRANCH_CD=@BRANCH_CD AND DISFLAG='Y' AND DELFLAG='0'
    ORDER BY
        ORDERNO ASC

    -- 지역이벤트 메뉴
    SELECT
        BOARDCODE, BOARDCODENM
    FROM
        DBO.BD_LOCALEVENTCODE_TB(NOLOCK)
    WHERE
        BRANCH_CD=@BRANCH_CD AND DISFLAG='Y' AND DELFLAG='0'
    ORDER BY
        ORDERNO ASC

    -- 전국공통이벤트 메뉴
    SELECT
        BOARDCODE, BOARDCODENM
    FROM
        DBO.BD_LOCALEVENTCODE_TB(NOLOCK)
    WHERE
        BRANCH_CD=0 AND DISFLAG='Y' AND DELFLAG='0'
    ORDER BY
        ORDERNO ASC

END
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[GET_F_PLUS_LEFTMENU_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 벼룩시장플러스 개편 - 좌측메뉴가져오기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/07/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_PLUS_LEFTMENU_PROC
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_PLUS_LEFTMENU_PROC]
AS
SET NOCOUNT ON

BEGIN

/*
	SELECT
		CODE, LCODE, LNAME, MCODE, MNAME
	FROM
		DBO.NESSAYCODE(NOLOCK)
	WHERE
		LCODE IN (
			-- 대분류가 게재인 것.
			SELECT LCODE FROM DBO.NESSAYCODE(NOLOCK)
			WHERE DISFLAG=1 AND MCODE=0
		) AND
		DISFLAG=1
	ORDER BY
		CODE
*/

	-- 읽을거리, 부동산정보 외의 메뉴를 먼저
	SELECT
		TB.CODE, TB.LCODE, TB.LNAME, TB.MCODE, TB.MNAME
	FROM
		DBO.NESSAYCODE TA(NOLOCK)
		INNER JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.LCODE = TB.LCODE
	WHERE
		TA.DISFLAG=1 AND
		TA.MCODE=0 AND
		TB.DISFLAG=1 AND
		TA.LCODE NOT IN (50, 60)
	ORDER BY
		TB.CODE

	-- 읽을거리, 부동산 정보는 나중에
	SELECT
		TB.CODE, TB.LCODE, TB.LNAME, TB.MCODE, TB.MNAME
	FROM
		DBO.NESSAYCODE TA(NOLOCK)
		INNER JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.LCODE = TB.LCODE
	WHERE
		TA.DISFLAG=1 AND
		TA.MCODE=0 AND
		TB.DISFLAG=1 AND
		TA.LCODE IN (50, 60)
	ORDER BY
		TB.CODE
END

SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[GET_F_PLUS_LOCALEVENTMENU_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 벼룩시장플러스 - 지역별 최신이벤트
 *  작   성   자 : 김문화(kdhwarfare@mediawill.com)
 *  작   성   일 : 2011/07/05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_PLUS_LOCALEVENTMENU_PROC 0
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_PLUS_LOCALEVENTMENU_PROC]
    @BRANCH_CD INT
AS

SET NOCOUNT ON
BEGIN

    -- 지역별 최근이벤트
    SELECT
        TOP 2 BOARDCODE, BOARDCODENM
    FROM
        DBO.BD_LOCALEVENTCODE_TB(NOLOCK)
    WHERE
        BRANCH_CD=@BRANCH_CD
    AND DISFLAG='Y'
    AND DELFLAG='0'

    ORDER BY
        ORDERNO ASC

END
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[GET_F_SECTIONMAIN_ESSAY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 벼룩시장 - 분류메인 - 취업플러스, 창업플러스
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/09/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_SECTIONMAIN_ESSAY_PROC 7010
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_SECTIONMAIN_ESSAY_PROC]

	@CODE		INT	-- 취업플러스 : 7010, 창업플러스 : 2010

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	SELECT TOP 2
		TA.SERIAL,
		TA.CODE,
		TA.TITLE,
		TA.SUMMARY,
		TA.IMGSRC3,
		TA.IMGSRC4
	FROM
		DBO.NESSAY TA(NOLOCK)
	WHERE
		CODE = @CODE
	ORDER BY
		TA.MODDATE DESC,
		TA.SERIAL DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_F_SECTIONMAIN_HOUSEESSAY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 벼룩시장 - 분류메인 - 부동산관련 벼룩시장 PLUS
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/09/15
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_SECTIONMAIN_HOUSEESSAY_PROC
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_SECTIONMAIN_HOUSEESSAY_PROC]
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	SELECT TOP 4
		TA.SERIAL,
		TA.CODE,
		TA.TITLE,
		TA.SUMMARY,
		TA.IMGSRC3,
		TA.IMGSRC4
	FROM
		DBO.NESSAY TA(NOLOCK)
	WHERE
		CODE BETWEEN 6010 AND 6098
	ORDER BY
		TA.MODDATE DESC,
		TA.SERIAL DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_F_SECTIONMAIN_INCRUITNEWS_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 벼룩시장 - 분류메인 - 취업뉴스
 *  작   성   자 : 이경덕 (laplance@mediawill.com)
 *  작   성   일 : 2012/09/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : IncruitNews
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_SECTIONMAIN_INCRUITNEWS_PROC 7010
 EXEC DBO.GET_F_SECTIONMAIN_INCRUITNEWS_PROC_BAK01 7010
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_SECTIONMAIN_INCRUITNEWS_PROC]

	@CODE		INT	-- 취업플러스 : 7010

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT TOP 7
		IDX SERIAL
		, CODE
		, TITLE
		, DESCRIPTION SUMMARY
		, IMG_PATH2 IMGSRC3
		, IMG_PATH2 IMGSRC4
		, CONVERT(VARCHAR(10),REG_DATE,2) MODDATE
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_ESSAY_TB WITH(NOLOCK)
	WHERE DEL_YN = 'N' AND STARTDATE <= CONVERT(VARCHAR(10),GETDATE(),120) AND ENDDATE >= CONVERT(VARCHAR(10),GETDATE(),120)
	AND CODE = @CODE
	ORDER BY IDX DESC

END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_SECTIONMAIN_INCRUITNEWS_PROC_BAK01]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 벼룩시장 - 분류메인 - 취업뉴스
 *  작   성   자 : 이경덕 (laplance@mediawill.com)
 *  작   성   일 : 2012/09/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : IncruitNews
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_SECTIONMAIN_INCRUITNEWS_PROC 7010
 EXEC DBO.GET_F_SECTIONMAIN_INCRUITNEWS_PROC_BAK01 7010
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_SECTIONMAIN_INCRUITNEWS_PROC_BAK01]

	@CODE		INT	-- 취업플러스 : 7010

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT TOP 7
		IDX SERIAL
		, CODE
		, TITLE
		, DESCRIPTION SUMMARY
		, IMG_PATH2 IMGSRC3
		, IMG_PATH2 IMGSRC4
		, CONVERT(VARCHAR(10),REG_DATE,2) MODDATE
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_ESSAY_TB WITH(NOLOCK)
	WHERE DEL_YN = 'N' AND STARTDATE <= CONVERT(VARCHAR(10),GETDATE(),120) AND ENDDATE >= CONVERT(VARCHAR(10),GETDATE(),120)
	AND CODE = @CODE
	ORDER BY IDX DESC

END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_SECTIONMAIN_INCRUITNEWS_PROC_BAK180730]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 벼룩시장 - 분류메인 - 취업뉴스
 *  작   성   자 : 이경덕 (laplance@mediawill.com)
 *  작   성   일 : 2012/09/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : IncruitNews
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_SECTIONMAIN_INCRUITNEWS_PROC 7010
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_SECTIONMAIN_INCRUITNEWS_PROC_BAK180730]

	@CODE		INT	-- 취업플러스 : 7010

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	SELECT TOP 7
		   TA.SERIAL
		 , TA.CODE
		 , TA.TITLE
		 , TA.SUMMARY
		 , TA.IMGSRC3
		 , TA.IMGSRC4
		 , CONVERT(VARCHAR(10),TA.MODDATE,2) MODDATE
	  FROM  DBO.NESSAY TA(NOLOCK)
	 WHERE CODE = @CODE
	 ORDER BY
		   TA.SERIAL DESC
		 , TA.MODDATE DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_FA_MainCount_ITEM_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 이민규 > 이컴, 등록대행 현황(유료무료)
 *  작   성   자 : 여운영
 *  작   성   일 : 2015-09-23
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 

exec GET_FA_MainCount_ITEM_PROC 'FMB','2016-03-18','2016-03-18'
select *FROM FINDCONTENTS.DBO.FA_MainFlag
*************************************************************************************/

create   PROC [dbo].[GET_FA_MainCount_ITEM_PROC]
	@FLAG		NVARCHAR(1000)
	,@START_DT	VARCHAR(10)
	,@END_DT	VARCHAR(10)=''
	
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
	
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @SQL_PARAM NVARCHAR(MAX) 
	DECLARE @SQL_DAILY NVARCHAR(MAX) --일 대비(전 년,월,주) 쿼리용
	DECLARE @SQL_WEEKLY NVARCHAR(MAX) --일 대비(전 년,월,주) 쿼리용
	DECLARE @PARAM NVARCHAR(MAX)
	set @END_DT = DATEADD(d,1,@END_DT)

	/* PIVOT용 필드 */
	SET @PARAM = (
	SELECT STUFF(
		(
		SELECT ',' + C.FlagNm 
		FROM FINDCONTENTS.DBO.FA_MainFlag AS C
		WHERE C.Flag like @FLAG +'%'
		ORDER BY C.Serial 
		FOR XML PATH ('')
		
		)
	,1,1,'') AS CODE_LIST
	)
	SET @PARAM = '[' + REPLACE(@PARAM, ',', '],[') + ']'
	
	--select *FROM FA_MainFlag
--	SELECT @PARAM
	SET @SQL_PARAM = '
	@START_DT	VARCHAR(10)
	,@END_DT	VARCHAR(10)
	'
	SET @SQL = '	
	SELECT 
		regdate,	'+@PARAM+'
	FROM (
		SELECT 
			convert(varchar(10),A.regdate,120) as regdate
			,B.FlagNm
			,sum(A.clickcnt) clickcnt 
		FROM FINDCONTENTS.DBO.FA_MainCount A WITH(NOLOCK)
		RIGHT OUTER JOIN FINDCONTENTS.DBO.FA_MainFlag B ON A.Flag = B.Flag and B.flag like ''' +@FLAG +'%''

		WHERE	
			A.RegDate BETWEEN @START_DT AND @END_DT
		group by convert(varchar(10),A.regdate,120),B.FlagNm
	)A 
	PIVOT (  sum(clickcnt)
		FOR FlagNm  IN ( '+@PARAM+')
	) AS PVT
ORDER BY 1,2
'

PRINT @SQL
 EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM,
	@START_DT
	,@END_DT



	
GO
/****** Object:  StoredProcedure [dbo].[GET_FA_MainTotalCnt_ITEM_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 이민규 > 이컴, 등록대행 현황(유료무료)
 *  작   성   자 : 여운영
 *  작   성   일 : 2015-09-23
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 

exec GET_FA_MainTotalCnt_ITEM_PROC 'LMB','2016-01-01','2016-03-01'
select *FROM FINDCONTENTS.DBO.FA_MainFlag
*************************************************************************************/

CREATE   PROC [dbo].[GET_FA_MainTotalCnt_ITEM_PROC]
	@FLAG		NVARCHAR(1000)
	,@START_DT	VARCHAR(10)
	,@END_DT	VARCHAR(10)=''
	
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
	
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @SQL_PARAM NVARCHAR(MAX) 
	DECLARE @SQL_DAILY NVARCHAR(MAX) --일 대비(전 년,월,주) 쿼리용
	DECLARE @SQL_WEEKLY NVARCHAR(MAX) --일 대비(전 년,월,주) 쿼리용
	DECLARE @PARAM NVARCHAR(MAX)
	

	/* PIVOT용 필드 */
	SET @PARAM = (
	SELECT STUFF(
		(
		SELECT ',' + C.FlagNm 
		FROM FINDCONTENTS.DBO.FA_MainFlag AS C
		WHERE C.Flag like @FLAG +'%'
		ORDER BY C.Serial 
		FOR XML PATH ('')
		
		)
	,1,1,'') AS CODE_LIST
	)
	SET @PARAM = '[' + REPLACE(@PARAM, ',', '],[') + ']'
	
	--select *FROM FA_MainFlag
--	SELECT @PARAM
	SET @SQL_PARAM = '
	@START_DT	VARCHAR(10)
	,@END_DT	VARCHAR(10)
	'
	SET @SQL = '	
	SELECT 
		regdate,	'+@PARAM+'
	FROM (
		SELECT 
			convert(varchar(10),A.regdate,120) as regdate
			,B.FlagNm
			,sum(A.clickcnt) clickcnt 
		FROM FINDCONTENTS.DBO.FA_MainTotalCnt A WITH(NOLOCK)
		RIGHT OUTER JOIN FINDCONTENTS.DBO.FA_MainFlag B ON A.Flag = B.Flag and B.flag like ''' +@FLAG +'%''

		WHERE	
			A.RegDate BETWEEN @START_DT AND @END_DT
		group by convert(varchar(10),A.regdate,120),B.FlagNm
	)A 
	PIVOT (  sum(clickcnt)
		FOR FlagNm  IN ( '+@PARAM+')
	) AS PVT
ORDER BY 1,2
'

PRINT @SQL
 EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM,
	@START_DT
	,@END_DT



	
GO
/****** Object:  StoredProcedure [dbo].[GET_FINDJOB_CLICKLOG]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GET_FINDJOB_CLICKLOG]
       @FROMDT    VARCHAR(10)
     , @TODT      VARCHAR(10)
AS

SET NOCOUNT ON

SELECT CONVERT(VARCHAR(10),LOG_DT,111) AS LOG_DT
     , CNT
  FROM CM_JOB_REFERRER_FINDALL_TB WITH (NOLOCK)
 WHERE LOG_DT>=@FROMDT
   AND LOG_DT<=@TODT
 ORDER BY LOG_DT ASC

GO
/****** Object:  StoredProcedure [dbo].[GET_M_ARTICLE_DETAIL_MAIN_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 독자참여공간 메인
 *  작   성   자 : 정태운
 *  작   성   일 : 2009/12/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ARTICLE_DETAIL_MAIN_PROC 4711,4712
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_ARTICLE_DETAIL_MAIN_PROC]
	@IDX INT
,	@IDX2 INT
AS

	-- 글 내용
	SELECT
		TOP 2
		TA.NDX,
		TA.TITLE,
		TA.USERNAME,
		TA.USERID,
		TA.EMAIL,
		TA.REGDATE,
		TA.VIEWCNT,
		TA.DREW,
		TA.GRADES,
		TA.IMGSRC,
		TA.CONTENTS,
		TB.TITLE AS CATETITLE
	FROM
		DBO.READEREVENT2 TA(NOLOCK)
		INNER JOIN DBO.READERROUND2 TB(NOLOCK)
		ON TA.NDX = TB.NDX
	WHERE
		TA.IDX = @IDX or TA.IDX = @IDX2

GO
/****** Object:  StoredProcedure [dbo].[GET_M_ARTICLE_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 글마당 상세보기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ARTICLE_DETAIL_PROC 4711
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_ARTICLE_DETAIL_PROC]
	@IDX INT
AS

	-- 글 내용
	SELECT
		TOP 1
		TA.NDX,
		TA.TITLE,
		TA.USERNAME,
		TA.USERID,
		TA.EMAIL,
		TA.REGDATE,
		TA.VIEWCNT,
		TA.DREW,
		TA.GRADES,
		TA.IMGSRC,
		TA.CONTENTS,
		TB.TITLE AS CATETITLE
	FROM
		DBO.READEREVENT2 TA(NOLOCK)
		INNER JOIN DBO.READERROUND2 TB(NOLOCK)
		ON TA.NDX = TB.NDX
	WHERE
		TA.IDX = @IDX

	-- 댓글 리스트
	SELECT
		SERIAL,
		USERID,
		COMMENT,
		GRADES,
		REGDATE
	FROM
		DBO.READERCOMMENT2(NOLOCK)
	WHERE
		IDX = @IDX
	ORDER BY
		SERIAL DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_M_ARTICLE_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 글마당 리스트
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
								CONTKIND :	NDX=13(이용후기)일 때 - 11:파인드올, 12:신문벼룩시장, 2:부동산, 1:중고장터, 3:자동차, 10:공지사항
														NDX=14(유머벼룩시장)일 때 - 0:전체, 6:상품&서비스, 7:부동산, 8:자동차, 9:구인구직,
														그외 : '',NULL,0
 *  사 용  소 스 :
 *  사 용  예 제 :
EXEC DBO.GET_M_ARTICLE_LIST_PROC 1,10, 1, '','','','','','','',''
EXEC DBO.GET_M_ARTICLE_LIST_PROC 1,10,'1','','0','0','Y','2009-03-01','2009-03-09','USERNAME','ㄴㅇㄻㄴㅇㄹ'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_ARTICLE_LIST_PROC]

	@PAGE					INT,
	@PAGESIZE			INT,

	@NDX					VARCHAR(3),							--글마당 테마
	@CONTKIND			VARCHAR(30),
	@DREW					CHAR(1),					--당첨글인지 0:미당첨, 1: 당첨
	@DELFLAG			CHAR(1)='',					--삭제글 0:미삭제, 1: 삭제

	@DATEFLAG			CHAR(1),					--날짜검색할지 : 0 이면 날짜검색
	@FROMDATE			VARCHAR(10)='',		--검색 시작일
	@TODATE				VARCHAR(10)='',		--검색 종료일

	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)=''

AS
DECLARE

	@SQL				NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	--검색절 SET
	SET @WHERE = ''
	IF @DATEFLAG='0'	--날짜검색
		SET @WHERE = @WHERE + '	AND	TA.REGDATE BETWEEN ''' + @FROMDATE + ' 00:00:00'' AND ''' + @TODATE + ' 23:59:59'' '
	IF @NDX <> ''	--테마검색
		SET @WHERE = @WHERE + '	AND	TA.NDX	= ' + @NDX + '  '
	IF @DREW<>''	--당첨글여부
		SET @WHERE = @WHERE + '	AND	TA.DREW = ''' + @DREW + ''' '
	IF @DELFLAG<>'' -- 삭제글여부
		SET @WHERE = @WHERE + ' AND	TA.DELFLAG = ''' + @DELFLAG + ''' '

	IF @SEARCHFIELD<>''
		BEGIN
			IF @SEARCHFIELD='USERNAME'
				SET @WHERE = @WHERE + '	AND	TA.USERNAME LIKE ''%' + @SEARCHTEXT + '%''  '
			IF @SEARCHFIELD='USERID'
				SET @WHERE = @WHERE + '	AND	TA.USERID LIKE ''%' + @SEARCHTEXT + '%'' '
			IF @SEARCHFIELD='TITLE'
				SET @WHERE = @WHERE + '	AND	TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' '
		END

	SET @SQL = '' +
			'	SELECT ' +
			'		COUNT(*) AS CNT ' +
			'	FROM ' +
			'		DBO.READEREVENT2 TA(NOLOCK) ' +
			'		INNER JOIN DBO.READERROUND2 TB(NOLOCK) ' +
			'		ON TA.NDX = TB.NDX ' +
			' WHERE 1 = 1 ' + @WHERE + '; ' +

			' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
			'		 TA.IDX, ' +
			'		 TA.NDX, ' +
			'		 TA.TITLE, ' +
			'		 TA.STEP, ' +
			'		 TA.USERNAME, ' +
			'		 TA.USERID, ' +
			'		 TA.REGDATE, ' +
			'		 TA.VIEWCNT, ' +
			'		 TA.REF, ' +
			'		 TA.LOWREF, ' +
			'		 TA.STEP, ' +
			'		 TA.DREW, ' +
			'		 TA.GRADES, ' +
			'		 TA.IMGSRC, ' +
			'		 TB.TITLE AS CATETITLE, ' +
			'		 TA.DELFLAG ' +
			'	FROM ' +
			'		DBO.READEREVENT2 TA(NOLOCK) ' +
			'		INNER JOIN DBO.READERROUND2 TB(NOLOCK) ' +
			'		ON TA.NDX = TB.NDX ' +
			' WHERE 1 = 1 ' +  @WHERE +
			' ORDER BY ' +
			'		TA.REF DESC, TA.LOWREF, TA.STEP '

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_ARTICLE_THEME_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 글마당 테마상세
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : DBO.GET_M_ARTICLE_THEME_DETAIL_PROC 1
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_ARTICLE_THEME_DETAIL_PROC]
	@NDX	INT
AS

	SELECT
		NDX, TITLE, COMMENT, IMGURL, DISFLAG, SORTID
	FROM
		DBO.READERROUND2(NOLOCK)
	WHERE
		NDX = @NDX

GO
/****** Object:  StoredProcedure [dbo].[GET_M_ARTICLE_THEME_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 글마당 테마리스트
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : DBO.GET_M_ARTICLE_THEME_PROC ''
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_ARTICLE_THEME_PROC]
	@DISGBN CHAR(1) = ''
AS

	IF @DISGBN <> ''
		BEGIN
			SELECT
				NDX, TITLE, DISFLAG, SORTID
			FROM
				DBO.READERROUND2(NOLOCK)
			WHERE
				DISFLAG = @DISGBN
			ORDER BY
				SORTID ASC
		END
	ELSE
		BEGIN
			SELECT
				NDX, TITLE, DISFLAG, SORTID
			FROM
				DBO.READERROUND2(NOLOCK)
			ORDER BY
				SORTID ASC
		END

GO
/****** Object:  StoredProcedure [dbo].[GET_M_BANNER_PREVIEW_LIST]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 :
 *  작   성   자 :
 *  작   성   일 :
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_BANNER_PREVIEW_LIST , '', 'D'
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_BANNER_PREVIEW_LIST]

   @INPUT_BRANCH TINYINT
  ,@LOCAL_BRANCH VARCHAR(20)
  ,@BANNER_GBN CHAR(1)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @SQL NVARCHAR(1000)
DECLARE @WHERE_SQL NVARCHAR(1000)

SET @SQL = '
SELECT TOP 3 IDX, BANNER_GBN, CASE TARGET WHEN 0 THEN '''' ELSE ''_blank'' END, BANNER_PATH, BANNER_URL, BANNER_NM, LOCAL_BRANCH
FROM FA_BANNER_MANAGE_TB
WHERE DELF = 0 AND DISF = 0
  AND BANNER_GBN = '''+ @BANNER_GBN + ''' '

SET @WHERE_SQL = ''

IF @INPUT_BRANCH = 0
BEGIN
	SET @WHERE_SQL = @WHERE_SQL + ' AND INPUT_BRANCH IN (80, 11, 25) '
END
ELSE IF @INPUT_BRANCH = 11
BEGIN
	SET @WHERE_SQL = @WHERE_SQL + ' AND (INPUT_BRANCH = 11 OR INPUT_BRANCH = 80) '
END
ELSE IF @INPUT_BRANCH = 25
BEGIN
	SET @WHERE_SQL = @WHERE_SQL + ' AND (INPUT_BRANCH = 25 OR INPUT_BRANCH = 80) '
END

IF @LOCAL_BRANCH <> ''
BEGIN
	IF @LOCAL_BRANCH = '11'
	BEGIN
		SET @WHERE_SQL = @WHERE_SQL + ' AND (LOCAL_BRANCH = ''11'' OR LOCAL_BRANCH LIKE ''%, 11'' OR LOCAL_BRANCH LIKE ''%, 11, %'' OR LOCAL_BRANCH LIKE ''11, %'') '
	END
	ELSE IF @LOCAL_BRANCH = '25'
	BEGIN
		SET @WHERE_SQL = @WHERE_SQL + ' AND (LOCAL_BRANCH = ''25'' OR LOCAL_BRANCH LIKE ''%, 25'' OR LOCAL_BRANCH LIKE ''%, 25, %'' OR LOCAL_BRANCH LIKE ''25, %'') '
	END
	ELSE
	BEGIN
		SET @WHERE_SQL = @WHERE_SQL + ' AND (LEFT(LOCAL_BRANCH,1) = ''0'' OR LEFT(LOCAL_BRANCH,2) = ''0,'') '
	END
END

SET @SQL = @SQL +  @WHERE_SQL + 'ORDER BY REG_DT DESC '

PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_BRANCH_BANNER_DETAIL]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배너관리 > 배너정보 상세보기
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2013-02-13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_BRANCH_BANNER_DETAIL 5
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_BRANCH_BANNER_DETAIL]
   @IDX INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT
 INPUT_BRANCH,
 LOCAL_BRANCH,
 BANNER_NM,
 BANNER_PATH,
 BANNER_URL,
 BANNER_GBN,
 TARGET,
 START_DT,
 END_DT,
 DISF,
 MAINF,
 READ_CNT,
 REG_DT
FROM
  FA_BANNER_MANAGE_TB
WHERE DELF = 0
  AND IDX = @IDX

GO
/****** Object:  StoredProcedure [dbo].[GET_M_BRANCH_BANNER_HISTORY_LIST]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배너관리 > 배너관리 이력
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2013-02-13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_BRANCH_BANNER_HISTORY_LIST 3
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_BRANCH_BANNER_HISTORY_LIST]

   @IDX INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON


SELECT COUNT(*) FROM FA_BANNER_HISTORY_TB WHERE BANNER_IDX = @IDX

SELECT
 INPUT_BRANCH,
 LOCAL_BRANCH,
 BANNER_NM,
 BANNER_PATH,
 BANNER_URL,
 CASE BANNER_GBN WHEN 'A' THEN '메인A'
               WHEN 'B' THEN '메인B'
               WHEN 'C' THEN '메인C'
               WHEN 'D' THEN '메인D' ELSE '' END AS BANNER_GBN,
 TARGET,
 START_DT,
 END_DT,
 DISF,
 MAINF,
 READ_CNT,
 REG_DT,
 MAG_ID
FROM
  FA_BANNER_HISTORY_TB
WHERE BANNER_IDX = @IDX
ORDER BY IDX DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_M_BRANCH_BANNER_LIST]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배너관리 > 배너목록
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2013-02-13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_BRANCH_BANNER_LIST 80, '', '', '', '0', ''
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_BRANCH_BANNER_LIST]

   @INPUT_BRANCH TINYINT
  ,@LOCAL_BRANCH VARCHAR(20)
  ,@BANNER_GBN VARCHAR(10)		    --배너유형
  ,@REG_DT VARCHAR(10)			    --등록일
  ,@DISF  CHAR(1)                   --게재여부(0:미게재 1:게재)
  ,@BANNER_NAME VARCHAR(100)	    --배너명
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @SQL NVARCHAR(1000)
DECLARE @WHERE_SQL NVARCHAR(1000)
DECLARE @TOTAL_SQL NVARCHAR(1000)

SET @TOTAL_SQL = 'SELECT COUNT(*) FROM FA_BANNER_MANAGE_TB WHERE DELF = 0 '
SET @SQL = '
SELECT
 IDX,
 INPUT_BRANCH,
 LOCAL_BRANCH,
 BANNER_NM,
 BANNER_PATH,
 BANNER_URL,
 CASE BANNER_GBN WHEN ''A'' THEN ''메인A''
               WHEN ''B'' THEN ''메인B''
               WHEN ''C'' THEN ''메인C''
               WHEN ''D'' THEN ''메인D''
               WHEN ''E'' THEN ''부동산전체1''
               WHEN ''F'' THEN ''부동산메인2''
               WHEN ''G'' THEN ''메인우측SKY''
      ELSE '''' END AS BANNER_GBN,
 TARGET,
 START_DT,
 END_DT,
 DISF,
 MAINF,
 READ_CNT,
 REG_DT
FROM
  FA_BANNER_MANAGE_TB
WHERE DELF = 0 '

SET @WHERE_SQL = ''

IF @INPUT_BRANCH = 0
BEGIN
	SET @WHERE_SQL = @WHERE_SQL + ' AND INPUT_BRANCH IN (80, 11, 25) '
END
ELSE IF @INPUT_BRANCH = 11
BEGIN
	SET @WHERE_SQL = @WHERE_SQL + ' AND (INPUT_BRANCH = 11 OR INPUT_BRANCH = 80) '
END
ELSE IF @INPUT_BRANCH = 25
BEGIN
	SET @WHERE_SQL = @WHERE_SQL + ' AND (INPUT_BRANCH = 25 OR INPUT_BRANCH = 80) '
END

IF @LOCAL_BRANCH <> ''
BEGIN
	IF @LOCAL_BRANCH = '11'
	BEGIN
		SET @WHERE_SQL = @WHERE_SQL + ' AND (LOCAL_BRANCH = ''11'' OR LOCAL_BRANCH LIKE ''%, 11'' OR LOCAL_BRANCH LIKE ''%, 11, %'' OR LOCAL_BRANCH LIKE ''11, %'') '
	END
	ELSE IF @LOCAL_BRANCH = '25'
	BEGIN
		SET @WHERE_SQL = @WHERE_SQL + ' AND (LOCAL_BRANCH = ''25'' OR LOCAL_BRANCH LIKE ''%, 25'' OR LOCAL_BRANCH LIKE ''%, 25, %'' OR LOCAL_BRANCH LIKE ''25, %'') '
	END
	ELSE
	BEGIN
		SET @WHERE_SQL = @WHERE_SQL + ' AND (LEFT(LOCAL_BRANCH,1) = ''0'' OR LEFT(LOCAL_BRANCH,2) = ''0,'') '
	END
END

IF @BANNER_GBN <> ''
  SET @WHERE_SQL = @WHERE_SQL + ' AND BANNER_GBN = ''' + @BANNER_GBN + ''''

IF @REG_DT <> ''
  SET @WHERE_SQL = @WHERE_SQL + ' AND CONVERT(VARCHAR(10),REG_DT, 120) = ''' + @REG_DT + ''''

IF @DISF <> ''
  SET @WHERE_SQL = @WHERE_SQL + ' AND DISF = ' + @DISF

IF @BANNER_NAME <> ''
  SET @WHERE_SQL = @WHERE_SQL + ' AND BANNER_NM LIKE ''%' + @BANNER_NAME +'%'' '

SET @TOTAL_SQL = @TOTAL_SQL + @WHERE_SQL + ';'
SET @SQL = @SQL + @WHERE_SQL + ' ORDER BY IDX DESC '

PRINT @TOTAL_SQL
PRINT @SQL

EXECUTE SP_EXECUTESQL @TOTAL_SQL
EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_ESSAY_CATEGORY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 정보마당 카테고리 리스트
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : DBO.GET_M_ESSAY_CATEGORY_PROC NULL, NULL
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_ESSAY_CATEGORY_PROC]
	@LCODE	SMALLINT = NULL,
	@MCODE	SMALLINT = NULL
AS

	IF (@LCODE IS NOT NULL AND @MCODE IS NOT NULL)
		BEGIN
			SELECT
				SERIAL, REPLICATE('0', 2 - LEN(CONVERT(VARCHAR(2),MCODE))) + CONVERT(VARCHAR(2),MCODE) AS CODE, LCODE, LNAME, MCODE, MNAME, DESCRIPTION, CNT, DISFLAG
			FROM
				DBO.NESSAYCODE(NOLOCK)
			WHERE
				LCODE = @LCODE AND
				MCODE = @MCODE
			ORDER BY
				LCODE ASC,
				MCODE ASC
		END
	ELSE
		BEGIN
			SELECT
				SERIAL, REPLICATE('0', 2 - LEN(CONVERT(VARCHAR(2),MCODE))) + CONVERT(VARCHAR(2),MCODE) AS CODE, LCODE, LNAME, MCODE, MNAME, DESCRIPTION, CNT, DISFLAG
			FROM
				DBO.NESSAYCODE(NOLOCK)
			ORDER BY
				LCODE ASC,
				MCODE ASC
		END

GO
/****** Object:  StoredProcedure [dbo].[GET_M_ESSAY_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 정보마당 상세보기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 : 정태운
 *  수   정   일 : 2010/01/22
 *  설        명 : 리플에 답변 추가
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ESSAY_DETAIL_PROC 25412
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_ESSAY_DETAIL_PROC]
	@SERIAL	INT
AS
		--글 상세 가져오기
		SELECT
			TB.LNAME,
			TB.LCODE,
			TB.MNAME,
			TB.MCODE,
			TA.SERIAL,
			TA.CODE,
			TA.TITLE,
			TA.SOURCE,
			TA.SUMMARY,
			TA.DESCRIPTION,
			TA.MODDATE,
			TA.DISFLAG,
			TA.MAINFLAG,
			TA.MAINLISTFLAG,
			TA.CMTCNT,
			TA.CNT,
			TA.STYLE,
			TA.IMGSRC3,
			TA.IMGSRC4
		FROM
			DBO.NESSAY TA(NOLOCK)
			INNER JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE=TB.CODE
		WHERE
		 	TA.SERIAL = @SERIAL

		--## 댓글 가져오기
		SELECT
			A.SERIAL,
			A.ESSAYSERIAL,
			A.CODE,
			A.USERID,
			A.COMMENT,
			A.REGDATE,
			A.GRADES,
		  (SELECT COUNT(B.IDX) FROM NESSAYCOMMENT_MEMO_TB B WHERE B.SERIAL = A.SERIAL AND B.ESSAYSERIAL = A.ESSAYSERIAL) as ReReplyCnt
		FROM
			DBO.NESSAYCOMMENT A
		WHERE
			A.ESSAYSERIAL = @SERIAL
		ORDER BY
			REGDATE DESC

		--## 댓글 답변가져오기
     SELECT IDX
			 , SERIAL
			 , MEMO
			 , UserID
			 , UserNM
			 , REG_DT
			   FROM NESSAYCOMMENT_MEMO_TB
			 WHERE
					ESSAYSERIAL = @SERIAL
				ORDER BY
					REG_DT ASC

GO
/****** Object:  StoredProcedure [dbo].[GET_M_ESSAY_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 정보마당 리스트
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/13
 *  수   정   자 : 김문화
 *  수   정   일 : 2012.03.07
 *  설        명 : 취재팀요청-미사용카테고리기사 관리자에서 노출안되도록 수정
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ESSAY_LIST_PROC 2,30,5016,'2000-02-11','2009-03-13','TITLE',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_ESSAY_LIST_PROC]
	@PAGE					INT,
	@PAGESIZE			INT,

	@LCODE					INT,
	@MCODE					INT,

	@FROMDATE			VARCHAR(10)='',		--검색 시작일
	@TODATE				VARCHAR(10)='',		--검색 종료일

	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)='',

	@MAINFLAG			CHAR(1) = ''
AS

DECLARE

	@SQL				NVARCHAR(4000),
	@WHERE			NVARCHAR(1000)

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	--검색절 SET
	SET @WHERE = ''
	IF @FROMDATE<>'' AND @TODATE<>''
		SET @WHERE = @WHERE + '		TA.MODDATE BETWEEN ''' + @FROMDATE + ' 00:00:00'' AND ''' + @TODATE + ' 23:59:59'' AND '

	IF @SEARCHFIELD<>''
		BEGIN
			IF @SEARCHFIELD='TITLE'
				SET @WHERE = @WHERE + '		TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
		END

	IF @MAINFLAG='1'	--메인게재 목록일 경우 분류와 상관없이 모두
		SET @WHERE = @WHERE + '		TA.MAINFLAG=''1'' AND '
	ELSE
	  IF @LCODE <> '' AND @MCODE <> ''
		SET @WHERE = @WHERE + '		TA.CODE= ' + CAST(@LCODE AS VARCHAR(5)) + CAST(@MCODE AS VARCHAR(5)) + ' AND '
	  ELSE IF @LCODE <> '' AND @MCODE = ''
	    SET @WHERE = @WHERE + '		TA.CODE LIKE ''' + CAST(@LCODE AS VARCHAR(5)) + '%'' AND '

	SET @SQL = '' +
			'	SELECT ' +
			'		COUNT(TA.SERIAL) AS CNT ' +
			'	FROM ' +
			'		DBO.NESSAY TA(NOLOCK) ' +
			'   WHERE ' + @WHERE +
--			'		CODE= ' + CAST(@CODE AS VARCHAR(4)) + ' AND ' +
			'		1= 1 ; ' +

			' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
			' 	TA.SERIAL,	' +
			' 	TA.CODE,	' +
			' 	TA.TITLE,	' +
			' 	TA.SOURCE,	' +
			' 	TA.DESCRIPTION,	' +
			' 	TA.MODDATE,	' +
			' 	TA.MAINFLAG,	' +
			' 	TA.MAINLISTFLAG,	' +
			' 	TA.CMTCNT,	' +
			' 	TA.CNT,	' +
			' 	TA.STYLE,	' +
			' 	TA.IMGSRC3,	' +
			' 	TA.IMGSRC4,	' +
			' 	(SELECT ISNULL(SUM(GRADES),0) FROM DBO.NESSAYCOMMENT WHERE ESSAYSERIAL = TA.SERIAL) AS GRADES	' +
			' FROM 	' +
			' 		DBO.NESSAY TA(NOLOCK)	' +
			' WHERE ' + @WHERE +
--			'		CODE= ' + CAST(@CODE AS VARCHAR(4)) + ' AND ' +
			'		1 = 1  ' +
			'	ORDER BY	' +
			'		TA.MODDATE DESC,  '  +
			'		TA.SERIAL DESC  '

--PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_ESSAY_MAINLIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 벼룩시장 플러스 - 메인우측노출페이지 만들기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_ESSAY_MAINLIST_PROC '25411, 25410, 25407, 25406'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_ESSAY_MAINLIST_PROC]
	@STRSERIAL	VARCHAR(40)
AS

DECLARE
	@SQL				NVARCHAR(4000)

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	SET @SQL = '' +
			'		SELECT TOP 4 ' +
			'			SERIAL, ' +
			'			CODE, ' +
			'			TITLE, ' +
			'			SUMMARY, ' +
			'			IMGSRC3, ' +
			'			IMGSRC4  ' +
			'		FROM  ' +
			'			DBO.NESSAY ' +
			'		WHERE ' +
			'			MAINFLAG=''1'' AND ' +
			'			SERIAL IN ('+@STRSERIAL+') ' +
			'		ORDER BY  ' +
			'			SERIAL DESC '

	--PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_ARTICLE_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 독자글마당 상세보기
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_ARTICLE_DETAIL_PROC 82, 10, '','',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_ARTICLE_DETAIL_PROC]
	@IDX 					INT,
	@NDX					INT,
	@MODE					INT,
	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)=''
AS

SET NOCOUNT ON

DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET @SQL =''
	SET @WHERE = ''

	-- 글 내용
	SELECT TOP 1
		ISNULL(LOTTERY_ID,0) NDX
		, TITLE
		, ISNULL(USERNAME, '') AS USERNAME 
		, ISNULL(USERID, '') AS USERID
		, '' AS EMAIL 
		, REG_DATE REGDATE
		, 0 VIEWCNT
		, 0 DREW
		, 0 GRADES
		, IMG_PATH IMGSRC
		, CONTENT CONTENTS
		, THEMA CATETITLE
		, ISNULL(CUID, '') AS CUID
		, CASE DEL_YN WHEN 'Y' THEN 1 ELSE 0 END DELFLAG
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB
	WHERE RE_ID = @IDX
	
	--검색절 SET
	IF @SEARCHFIELD <> ''
	BEGIN
		IF @SEARCHFIELD = 'USERNAME'
			SET @WHERE = @WHERE + '	USERNAME LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'USERID'
			SET @WHERE = @WHERE + '	USERID LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'TITLE'
			SET @WHERE = @WHERE + '	TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
	END

  --IF @MODE <> 0
  --  BEGIN
  --    SET @WHERE = @WHERE + '		TA.NDX = ' + @NDX + ' AND '
  --  END

	--이전글
	SET @SQL = '' +
		' SELECT TOP 1 ' +
		' RE_ID IDX, 0 NDX, TITLE ' +
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB ' +
		' WHERE ' + @WHERE +
		' RE_ID < ' + CAST(@IDX AS VARCHAR(10)) + 
		' AND DEL_YN = ''N'' ' +
		' AND 1 = 1	' +
		' ORDER BY RE_ID '

	--다음글
	SET @SQL = @SQL +
		' SELECT TOP 1 ' +
		' RE_ID IDX, 0 NDX, TITLE ' +
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB ' +
		' WHERE ' + @WHERE +
		' RE_ID > ' + CAST(@IDX AS VARCHAR(10)) + 
		' AND DEL_YN = ''N'' ' +
		' AND 1 = 1	' +
		' ORDER BY RE_ID '

  -- PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

	-- 댓글 리스트
  SELECT
	  SERIAL,
		USERID,
		COMMENT,
		GRADES,
		REGDATE
	FROM DBO.READERCOMMENT2 WITH (NOLOCK)
	WHERE IDX = @IDX
	ORDER BY SERIAL DESC
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_ARTICLE_DETAIL_PROC_BAK01]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 독자글마당 상세보기
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_ARTICLE_DETAIL_PROC_BAK01 82, 10, '','',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_ARTICLE_DETAIL_PROC_BAK01]
	@IDX 					INT,
	@NDX					INT,
	@MODE					INT,
	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)=''
AS

SET NOCOUNT ON

DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET @SQL =''
	SET @WHERE = ''

	-- 글 내용
	SELECT TOP 1
		ISNULL(LOTTERY_ID,0) NDX
		, TITLE
		, ISNULL(USERNAME, '') AS USERNAME 
		, ISNULL(USERID, '') AS USERID
		, '' AS EMAIL 
		, REG_DATE REGDATE
		, 0 VIEWCNT
		, 0 DREW
		, 0 GRADES
		, IMG_PATH IMGSRC
		, CONTENT CONTENTS
		, THEMA CATETITLE
		, ISNULL(CUID, '') AS CUID
		, DEL_YN DELFLAG
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB
	WHERE RE_ID = @IDX
	
	--검색절 SET
	IF @SEARCHFIELD <> ''
	BEGIN
		IF @SEARCHFIELD = 'USERNAME'
			SET @WHERE = @WHERE + '	USERNAME LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'USERID'
			SET @WHERE = @WHERE + '	USERID LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'TITLE'
			SET @WHERE = @WHERE + '	TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
	END

  --IF @MODE <> 0
  --  BEGIN
  --    SET @WHERE = @WHERE + '		TA.NDX = ' + @NDX + ' AND '
  --  END

	--이전글
	SET @SQL = '' +
		' SELECT TOP 1 ' +
		' RE_ID IDX, 0 NDX, TITLE ' +
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB ' +
		' WHERE ' + @WHERE +
		' RE_ID < ' + CAST(@IDX AS VARCHAR(10)) + 
		' AND DEL_YN = ''N'' ' +
		' AND 1 = 1	' +
		' ORDER BY RE_ID '

	--다음글
	SET @SQL = @SQL +
		' SELECT TOP 1 ' +
		' RE_ID IDX, 0 NDX, TITLE ' +
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB ' +
		' WHERE ' + @WHERE +
		' RE_ID > ' + CAST(@IDX AS VARCHAR(10)) + 
		' AND DEL_YN = ''N'' ' +
		' AND 1 = 1	' +
		' ORDER BY RE_ID '

  -- PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_ARTICLE_DETAIL_PROC_BAK180720]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일 독자글마당 상세보기
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_ARTICLE_DETAIL_PROC 12166, 10, '','',''

 EXEC DBO.GET_M_F_ARTICLE_DETAIL_PROC 12185, 10, '','',''

 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_ARTICLE_DETAIL_PROC_BAK180720]
	@IDX 					INT,
	@NDX					INT,
  @MODE					INT,
	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)=''
AS

SET NOCOUNT ON

DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET @SQL =''
	SET @WHERE = ''

	--VIEWCNT++
  UPDATE
		DBO.READEREVENT2
	SET
		VIEWCNT=VIEWCNT + 1
	WHERE
		IDX = @IDX

	-- 글 내용
	SELECT
		TOP 1
		TA.NDX,
		TA.TITLE,
		ISNULL(TA.USERNAME, '') AS USERNAME ,
		ISNULL(TA.USERID, '') AS USERID,
		ISNULL(TA.EMAIL, '') AS EMAIL ,
		TA.REGDATE,
		TA.VIEWCNT,
		TA.DREW,
		TA.GRADES,
		TA.IMGSRC,
		TA.CONTENTS,
		TB.TITLE AS CATETITLE,
		ISNULL(TA.CUID, '') AS CUID,
		TA.DELFLAG
	FROM DBO.READEREVENT2 TA WITH (NOLOCK)
		INNER JOIN DBO.READERROUND2 TB WITH (NOLOCK) ON TA.NDX = TB.NDX
	WHERE TA.IDX = @IDX
    --AND TA.DelFlag = '0'

	--검색절 SET
	IF @SEARCHFIELD <> ''
		BEGIN
			IF @SEARCHFIELD = 'USERNAME'
				SET @WHERE = @WHERE + '	TA.USERNAME LIKE ''%' + @SEARCHTEXT + '%'' AND '
			IF @SEARCHFIELD = 'USERID'
				SET @WHERE = @WHERE + '	TA.USERID LIKE ''%' + @SEARCHTEXT + '%'' AND '
			IF @SEARCHFIELD = 'TITLE'
				SET @WHERE = @WHERE + '	TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
		END

  IF @MODE <> 0
    BEGIN
      SET @WHERE = @WHERE + '		TA.NDX = ' + @NDX + ' AND '
    END

	--이전글
	SET @SQL = '' +
		'	SELECT TOP 1	' +
		'		TA.IDX, TA.NDX, TA.TITLE	' +
		'	FROM ' +
		'		DBO.READEREVENT2 TA(NOLOCK)	' +
		' WHERE ' +  @WHERE +
		'		TA.IDX < ' + CAST(@IDX AS VARCHAR(10)) + ' AND ' +
		'		TA.DELFLAG = ''0'' AND ' +
		'		1=1	' +
		'	ORDER BY ' +
		'		TA.REF DESC, TA.LOWREF, TA.STEP ; '

	--다음글
	SET @SQL = @SQL +
		'	SELECT TOP 1	' +
		'		TA.IDX, TA.NDX, TA.TITLE	' +
		'	FROM ' +
		'		DBO.READEREVENT2 TA(NOLOCK)	' +
		' WHERE ' +  @WHERE +
		'		TA.IDX > ' + CAST(@IDX AS VARCHAR(10)) + ' AND ' +
		'		TA.DELFLAG = ''0'' AND ' +
		'		1=1	' +
		'	ORDER BY ' +
		'		TA.REF ASC, TA.LOWREF DESC, TA.STEP DESC ; '

  -- PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

	-- 댓글 리스트
  SELECT
	  SERIAL,
		USERID,
		COMMENT,
		GRADES,
		REGDATE
	FROM DBO.READERCOMMENT2 WITH (NOLOCK)
	WHERE IDX = @IDX
	ORDER BY SERIAL DESC
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_ARTICLE_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 독자글마당 상세 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/01
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
		CONTKIND : NDX=13(이용후기)일 때 - 11:파인드올, 12:신문벼룩시장, 2:부동산, 1:중고장터, 3:자동차, 10:공지사항
							 NDX=14(유머벼룩시장)일 때 - 0:전체, 6:상품&서비스, 7:부동산, 8:자동차, 9:구인구직,
							 그외 : '',NULL,0
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_ARTICLE_LIST_PROC 1, 10, 4, '', ''
*************************************************************************************/
CREATE PROC [dbo].[GET_M_F_ARTICLE_LIST_PROC]
		@PAGE					INT,
		@PAGESIZE			INT,
		@NDX					VARCHAR(3),					--글마당 테마
		@SEARCHFIELD	VARCHAR(10) = '',
		@SEARCHTEXT		VARCHAR(30) = ''
AS
DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	-- 검색절 SET
	SET @WHERE = ''

	IF @SEARCHFIELD <> ''
	BEGIN
		IF @SEARCHFIELD = 'USERNAME'
			SET @WHERE = @WHERE + '	TA.USERNAME LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'CONTENTS'
			SET @WHERE = @WHERE + '	TA.CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'TITLE'
			SET @WHERE = @WHERE + '	TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
	END

	--IF @NDX <> ''
	--BEGIN
	--	SET @WHERE = @WHERE + ' TA.NDX = ' + @NDX + ' AND '
	--END

	-- 순서 : 지난주 당첨글, 리스트 카운트, 리스트
	SET @SQL = '' +
		' SELECT TOP 1 ' +
		' USERNAME, THEMA CATTITLE, RE_ID IDX, LOTTERY_ID NDX, RT.TITLE, 0 CMTCNT, RT.REG_DATE REGDATE'+
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ' +
		' JOIN FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK) ON BT.BANNER_ID = RT.BANNER_ID ' +
		' WHERE BT.EVENT_TYPE = 4 AND RT.DEL_YN =''N'' ' +
		' AND LOTTERY_YN = ''Y'' ' +
		' ORDER BY RE_ID DESC ' +

		' SELECT' +
		' COUNT(*) AS CNT ' +
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ' +
		' JOIN FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK) ON BT.BANNER_ID = RT.BANNER_ID ' +
		' WHERE ' + @WHERE +
		' BT.EVENT_TYPE = 4 AND RT.DEL_YN =''N'' ' +

		' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
		' X.IDX, X.NDX, X.TITLE, X.STEP, X.USERNAME, X.USERID, X.REGDATE, X.VIEWCNT, X.REF, ' +
		' X.LOWREF, X.STEP, X.DREW, X.GRADES, X.IMGSRC, X.CATETITLE, X.COMMENTCNT, X.ThemeNm ' +
		' FROM ( ' +
		'	SELECT ' +	
		'   RE_ID IDX ' +
		'   , LOTTERY_ID NDX ' +
		'   , RT.TITLE ' +
		'   , 1 STEP ' +
		'   , USERNAME ' +
		'   , USERID ' +
		'   , RT.REG_DATE REGDATE ' +
		'   , 0 VIEWCNT ' +
		'   , RE_ID REF ' +
		'   , 1 LOWREF ' +
		'   , 0 DREW ' +
		'   , 0 GRADES ' +
		'   , '''' IMGSRC ' +
		'   , THEMA CATETITLE ' +
		'   , 0 COMMENTCNT ' +
		'   , THEMA ThemeNm ' +
		'	, ROW_NUMBER() OVER(ORDER BY RE_ID DESC) AS ROW_NUM ' +
		'   FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ' +
		'   JOIN FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK) ON BT.BANNER_ID = RT.BANNER_ID ' +
		'   WHERE ' + @WHERE +
		'   BT.EVENT_TYPE = 4 AND RT.DEL_YN =''N'' ' +
		' ) AS X ' +
		' WHERE X.ROW_NUM > (' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + ') ' +
		' AND X.ROW_NUM <= (' + CONVERT(VARCHAR(10), ((@PAGE) * @PAGESIZE)) + ');'

	PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_ARTICLE_LIST_PROC_BAK01]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 독자글마당 상세 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/01
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
		CONTKIND : NDX=13(이용후기)일 때 - 11:파인드올, 12:신문벼룩시장, 2:부동산, 1:중고장터, 3:자동차, 10:공지사항
							 NDX=14(유머벼룩시장)일 때 - 0:전체, 6:상품&서비스, 7:부동산, 8:자동차, 9:구인구직,
							 그외 : '',NULL,0
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_ARTICLE_LIST_PROC_BAK01 1, 10, 4, '', ''
*************************************************************************************/
CREATE PROC [dbo].[GET_M_F_ARTICLE_LIST_PROC_BAK01]
		@PAGE					INT,
		@PAGESIZE			INT,
		@NDX					VARCHAR(3),					--글마당 테마
		@SEARCHFIELD	VARCHAR(10) = '',
		@SEARCHTEXT		VARCHAR(30) = ''
AS
DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	-- 검색절 SET
	SET @WHERE = ''

	IF @SEARCHFIELD <> ''
	BEGIN
		IF @SEARCHFIELD = 'USERNAME'
			SET @WHERE = @WHERE + '	TA.USERNAME LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'CONTENTS'
			SET @WHERE = @WHERE + '	TA.CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'TITLE'
			SET @WHERE = @WHERE + '	TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
	END

	--IF @NDX <> ''
	--BEGIN
	--	SET @WHERE = @WHERE + ' TA.NDX = ' + @NDX + ' AND '
	--END

	-- 순서 : 지난주 당첨글, 리스트 카운트, 리스트
	SET @SQL = '' +
		' SELECT TOP 1 ' +
		' USERNAME, THEMA, RE_ID IDX, LOTTERY_ID NDX, TITLE, 0 CMTCNT, REG_DATE REGDATE'+
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB ' +
		' WHERE DEL_YN = ''N'' ' +
		' AND LOTTERY_YN = ''Y'' ' +
		' ORDER BY RE_ID DESC ' +

		' SELECT' +
		' COUNT(*) AS CNT ' +
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB ' +
		' WHERE ' + @WHERE +
		' DEL_YN = ''N'' AND 1=1' +

		' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
		' X.IDX, X.NDX, X.TITLE, X.STEP, X.USERNAME, X.USERID, X.REGDATE, X.VIEWCNT, X.REF, ' +
		' X.LOWREF, X.STEP, X.DREW, X.GRADES, X.IMGSRC, X.CATETITLE, X.COMMENTCNT, X.ThemeNm ' +
		' FROM ( ' +
		'	SELECT ' +	
		'   RE_ID IDX ' +
		'   , LOTTERY_ID NDX ' +
		'   , TITLE ' +
		'   , 1 STEP ' +
		'   , USERNAME ' +
		'   , USERID ' +
		'   , REG_DATE REGDATE ' +
		'   , 0 VIEWCNT ' +
		'   , RE_ID REF ' +
		'   , 1 LOWREF ' +
		'   , 0 DREW ' +
		'   , 0 GRADES ' +
		'   , '''' IMGSRC ' +
		'   , THEMA CATETITLE ' +
		'   , 0 COMMENTCNT ' +
		'   , THEMA ThemeNm ' +
		'	, ROW_NUMBER() OVER(ORDER BY RE_ID DESC) AS ROW_NUM ' +
		'   FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB ' +
		' ) AS X ' +
		' WHERE X.ROW_NUM > (' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + ') ' +
		' AND X.ROW_NUM <= (' + CONVERT(VARCHAR(10), ((@PAGE) * @PAGESIZE)) + ');'

	--PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_ARTICLE_LIST_PROC_BAK180720]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 독자글마당 상세 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/01
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
		CONTKIND : NDX=13(이용후기)일 때 - 11:파인드올, 12:신문벼룩시장, 2:부동산, 1:중고장터, 3:자동차, 10:공지사항
							 NDX=14(유머벼룩시장)일 때 - 0:전체, 6:상품&서비스, 7:부동산, 8:자동차, 9:구인구직,
							 그외 : '',NULL,0
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_ARTICLE_LIST_PROC_BAK01 1, 10, 4, '', ''
*************************************************************************************/
CREATE PROC [dbo].[GET_M_F_ARTICLE_LIST_PROC_BAK180720]
		@PAGE					INT,
		@PAGESIZE			INT,
		@NDX					VARCHAR(3),					--글마당 테마
		@SEARCHFIELD	VARCHAR(10) = '',
		@SEARCHTEXT		VARCHAR(30) = ''
AS
DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	-- 검색절 SET
	SET @WHERE = ''

	IF @SEARCHFIELD <> ''
	BEGIN
		IF @SEARCHFIELD = 'USERNAME'
			SET @WHERE = @WHERE + '	TA.USERNAME LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'CONTENTS'
			SET @WHERE = @WHERE + '	TA.CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'TITLE'
			SET @WHERE = @WHERE + '	TA.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
	END

	--IF @NDX <> ''
	--BEGIN
	--	SET @WHERE = @WHERE + ' TA.NDX = ' + @NDX + ' AND '
	--END

	-- 순서 : 지난주 당첨글, 리스트 카운트, 리스트
	SET @SQL = '' +
		' SELECT TOP 1 ' +
		' USERNAME, THEMA, RE_ID IDX, LOTTERY_ID NDX, TITLE, 0 CMTCNT, REG_DATE REGDATE'+
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB ' +
		' WHERE DEL_YN = ''N'' ' +
		' AND LOTTERY_YN = ''Y'' ' +
		' ORDER BY RE_ID DESC ' +

		' SELECT' +
		' COUNT(*) AS CNT ' +
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB ' +
		' WHERE ' + @WHERE +
		' DEL_YN = ''N'' AND 1=1' +

		' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
		' X.IDX, X.NDX, X.TITLE, X.STEP, X.USERNAME, X.USERID, X.REGDATE, X.VIEWCNT, X.REF, ' +
		' X.LOWREF, X.STEP, X.DREW, X.GRADES, X.IMGSRC, X.CATETITLE, X.COMMENTCNT, X.ThemeNm ' +
		' FROM ( ' +
		'	SELECT ' +	
		'   RE_ID IDX ' +
		'   , LOTTERY_ID NDX ' +
		'   , TITLE ' +
		'   , 1 STEP ' +
		'   , USERNAME ' +
		'   , USERID ' +
		'   , REG_DATE REGDATE ' +
		'   , 0 VIEWCNT ' +
		'   , RE_ID REF ' +
		'   , 1 LOWREF ' +
		'   , 0 DREW ' +
		'   , 0 GRADES ' +
		'   , '''' IMGSRC ' +
		'   , THEMA CATETITLE ' +
		'   , 0 COMMENTCNT ' +
		'   , THEMA ThemeNm ' +
		'	, ROW_NUMBER() OVER(ORDER BY RE_ID DESC) AS ROW_NUM ' +
		'   FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB ' +
		' ) AS X ' +
		' WHERE X.ROW_NUM > (' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + ') ' +
		' AND X.ROW_NUM <= (' + CONVERT(VARCHAR(10), ((@PAGE) * @PAGESIZE)) + ');'

	--PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_ARTICLE_MODDETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 벼룩시장 이벤트 독자글마당 수정시 원본글보기
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_ARTICLE_MODDETAIL_PROC 4662, 10, '010923'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_ARTICLE_MODDETAIL_PROC]
	@IDX			INT,
	@NDX			INT,
	@USERID		VARCHAR(50)
AS

	-- 글 내용
	SELECT TOP 1
		TA.NDX,
		TA.TITLE,
		TA.USERNAME,
		TA.USERID,
		TA.EMAIL,
		TA.REGDATE,
		TA.VIEWCNT,
		TA.DREW,
		TA.GRADES,
		TA.IMGSRC,
		TA.CONTENTS,
		TB.TITLE AS CATETITLE,
		TA.CUID,
		TA.DELFLAG
	FROM
		DBO.READEREVENT2 TA WITH (NOLOCK)
			INNER JOIN DBO.READERROUND2 TB WITH (NOLOCK) ON TA.NDX = TB.NDX
	WHERE	TA.IDX = @IDX
		AND TA.UserID = @USERID
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 이벤트 상세보기(스도쿠, 포토갤러리 등)
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/29
 *  수   정   자 : 조민기
 *  수   정   일 : 2018/07/17
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_LOCALEVENT_DETAIL_PROC 82117, 1, 0, '',''
 EXEC DBO.GET_M_F_LOCALEVENT_DETAIL_PROC_BAK01 2, 1, 0, '',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_DETAIL_PROC]
	@SERIAL					INT,
	@BOARDCODE			INT,
	@BRANCH_CD			INT,
	@SEARCHFIELD		VARCHAR(10) = '',
	@SEARCHTEXT			VARCHAR(30) = ''
AS

SET NOCOUNT ON

DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET @SQL    =''
	SET @WHERE  = ''

	SELECT TOP 1
	RE_ID SERIAL, BT.EVENT_TYPE BOARDCODE, RT.USERNAME, RT.USERID, RT.TITLE, RT.REG_DATE REGDATE, 0 VIEWCNT, ISNULL(RT.IMG_PATH,'') AS PICFILE, RT.CONTENT CONTENTS, BT.BANNER_TYPE BOARDCODENM, 0 RENO, 0 STEP, 'Y' SECFLAG, 'Y' PICFLAG, ISNULL(RT.CUID, '') AS CUID, CASE RT.DEL_YN WHEN 'Y' THEN 1 ELSE 0 END DELFLAG
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK)
	JOIN FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ON RT.BANNER_ID = BT.BANNER_ID
	WHERE RE_ID = @SERIAL --AND EVENT_TYPE = @BOARDCODE
	
  -- 검색절 SET
  IF @SEARCHTEXT <> ''
	BEGIN
		IF @SEARCHFIELD = 'TITLE'
			SET @WHERE = @WHERE + '	TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'CONTENTS'
			SET @WHERE = @WHERE + '	CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
	END

	-- 이전글
	SET @SQL = @SQL +
		'	SELECT TOP 1 ' +
		'		RE_ID SERIAL, BT.EVENT_TYPE BOARDCODE, RT.TITLE, 0 RENO, 0 STEP, RT.USERID, RT.CUID' +
		'	FROM ' +
		'		FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK)	' +
		'		JOIN FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ON RT.BANNER_ID = BT.BANNER_ID	' +
		'	WHERE ' +  @WHERE +
		'		RE_ID > ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
		--'		EVENT_TYPE = ''' + CAST(@BOARDCODE AS VARCHAR(3)) + ''' AND ' +
		--'		BRANCH_CD = ''' + CAST(@BRANCH_CD AS VARCHAR(3)) + ''' AND ' +
		'		RT.DEL_YN = ''N'' AND ' +
		'		1 = 1	' +
		'	ORDER BY ' +
		'		BT.BANNER_ID ASC, RE_ID DESC; ' +

	--다음글
		'	SELECT TOP 1 ' +
		'		RE_ID SERIAL, BT.EVENT_TYPE BOARDCODE, RT.TITLE, 0 RENO, 0 STEP, RT.USERID, RT.CUID' +
		'	FROM ' +
		'		FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK)	' +
		'		JOIN FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ON RT.BANNER_ID = BT.BANNER_ID	' +
		'	WHERE ' +  @WHERE +
		'		RE_ID < ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
		--'		EVENT_TYPE = ''' + CAST(@BOARDCODE AS VARCHAR(3)) + ''' AND ' +
		--'		BRANCH_CD = ''' + CAST(@BRANCH_CD AS VARCHAR(3)) + ''' AND ' +
		'		RT.DEL_YN = ''N'' AND ' +
		'		1 = 1	' +
		'	ORDER BY ' +
		'		BT.BANNER_ID ASC, RE_ID DESC; ' 

	PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_DETAIL_PROC_BAK01]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 이벤트 상세보기(스도쿠, 포토갤러리 등)
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/29
 *  수   정   자 : 조민기
 *  수   정   일 : 2018/07/17
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_LOCALEVENT_DETAIL_PROC 82117, 1, 0, '',''
 EXEC DBO.GET_M_F_LOCALEVENT_DETAIL_PROC_BAK01 2, 1, 0, '',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_DETAIL_PROC_BAK01]
	@SERIAL					INT,
	@BOARDCODE			INT,
	@BRANCH_CD			INT,
	@SEARCHFIELD		VARCHAR(10) = '',
	@SEARCHTEXT			VARCHAR(30) = ''
AS

SET NOCOUNT ON

DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET @SQL    =''
	SET @WHERE  = ''

	SELECT TOP 1
	RE_ID SERIAL, BT.EVENT_TYPE BOARDCODE, RT.USERNAME, RT.USERID, RT.TITLE, RT.REG_DATE REGDATE, 0 VIEWCNT, '' PICFILE, RT.CONTENT CONTENTS, BT.BANNER_TYPE BOARDCODENM, 0 RENO, 0 STEP, 'Y' SECFLAG, 'Y' PICFLAG, ISNULL(RT.CUID, '') AS CUID, RT.DEL_YN DELFLAG
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK)
	JOIN FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ON RT.BANNER_ID = BT.BANNER_ID
	WHERE RE_ID = @SERIAL --AND EVENT_TYPE = @BOARDCODE
	
  -- 검색절 SET
  IF @SEARCHTEXT <> ''
	BEGIN
		IF @SEARCHFIELD = 'TITLE'
			SET @WHERE = @WHERE + '	TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'CONTENTS'
			SET @WHERE = @WHERE + '	CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
	END

	-- 이전글
	SET @SQL = @SQL +
		'	SELECT TOP 1 ' +
		'		RE_ID SERIAL, BT.EVENT_TYPE BOARDCODE, RT.TITLE, 0 RENO, 0 STEP, RT.USERID, RT.CUID' +
		'	FROM ' +
		'		FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK)	' +
		'		JOIN FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ON RT.BANNER_ID = BT.BANNER_ID	' +
		'	WHERE ' +  @WHERE +
		'		RE_ID > ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
		--'		EVENT_TYPE = ''' + CAST(@BOARDCODE AS VARCHAR(3)) + ''' AND ' +
		--'		BRANCH_CD = ''' + CAST(@BRANCH_CD AS VARCHAR(3)) + ''' AND ' +
		'		RT.DEL_YN = ''N'' AND ' +
		'		1 = 1	' +
		'	ORDER BY ' +
		'		BT.BANNER_ID ASC, RE_ID DESC; ' +

	--다음글
		'	SELECT TOP 1 ' +
		'		RE_ID SERIAL, BT.EVENT_TYPE BOARDCODE, RT.TITLE, 0 RENO, 0 STEP, RT.USERID, RT.CUID' +
		'	FROM ' +
		'		FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK)	' +
		'		JOIN FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ON RT.BANNER_ID = BT.BANNER_ID	' +
		'	WHERE ' +  @WHERE +
		'		RE_ID < ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
		--'		EVENT_TYPE = ''' + CAST(@BOARDCODE AS VARCHAR(3)) + ''' AND ' +
		--'		BRANCH_CD = ''' + CAST(@BRANCH_CD AS VARCHAR(3)) + ''' AND ' +
		'		RT.DEL_YN = ''N'' AND ' +
		'		1 = 1	' +
		'	ORDER BY ' +
		'		BT.BANNER_ID ASC, RE_ID DESC; ' 

	PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_DETAIL_PROC_BAK180720]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 이벤트 상세보기(스도쿠, 포토갤러리 등)
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/29
 *  수   정   자 : 조민기
 *  수   정   일 : 2018/07/17
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_LOCALEVENT_DETAIL_PROC 82117, 1, 0, '',''
 EXEC DBO.GET_M_F_LOCALEVENT_DETAIL_PROC_BAK01 2, 1, 0, '',''
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_DETAIL_PROC_BAK180720]
	@SERIAL					INT,
	@BOARDCODE			INT,
	@BRANCH_CD			INT,
	@SEARCHFIELD		VARCHAR(10) = '',
	@SEARCHTEXT			VARCHAR(30) = ''
AS

SET NOCOUNT ON

DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET @SQL    =''
	SET @WHERE  = ''

	SELECT TOP 1
	RE_ID SERIAL, BT.EVENT_TYPE BOARDCODE, RT.USERNAME, RT.USERID, RT.TITLE, RT.REG_DATE REGDATE, 0 VIEWCNT, '' PICFILE, RT.CONTENT CONTENTS, BT.BANNER_TYPE BOARDCODENM, 0 RENO, 0 STEP, 'Y' SECFLAG, 'Y' PICFLAG, ISNULL(RT.CUID, '') AS CUID, RT.DEL_YN DELFLAG
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK)
	JOIN FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ON RT.BANNER_ID = BT.BANNER_ID
	WHERE RE_ID = @SERIAL --AND EVENT_TYPE = @BOARDCODE
	
  -- 검색절 SET
  IF @SEARCHTEXT <> ''
	BEGIN
		IF @SEARCHFIELD = 'TITLE'
			SET @WHERE = @WHERE + '	TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
		IF @SEARCHFIELD = 'CONTENTS'
			SET @WHERE = @WHERE + '	CONTENTS LIKE ''%' + @SEARCHTEXT + '%'' AND '
	END

	-- 이전글
	SET @SQL = @SQL +
		'	SELECT TOP 1 ' +
		'		RE_ID SERIAL, BT.EVENT_TYPE BOARDCODE, RT.TITLE, 0 RENO, 0 STEP, RT.USERID, RT.CUID' +
		'	FROM ' +
		'		FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK)	' +
		'		JOIN FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ON RT.BANNER_ID = BT.BANNER_ID	' +
		'	WHERE ' +  @WHERE +
		'		RE_ID > ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
		--'		EVENT_TYPE = ''' + CAST(@BOARDCODE AS VARCHAR(3)) + ''' AND ' +
		--'		BRANCH_CD = ''' + CAST(@BRANCH_CD AS VARCHAR(3)) + ''' AND ' +
		'		RT.DEL_YN = ''N'' AND ' +
		'		1 = 1	' +
		'	ORDER BY ' +
		'		BT.BANNER_ID ASC, RE_ID DESC; ' +

	--다음글
		'	SELECT TOP 1 ' +
		'		RE_ID SERIAL, BT.EVENT_TYPE BOARDCODE, RT.TITLE, 0 RENO, 0 STEP, RT.USERID, RT.CUID' +
		'	FROM ' +
		'		FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK)	' +
		'		JOIN FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ON RT.BANNER_ID = BT.BANNER_ID	' +
		'	WHERE ' +  @WHERE +
		'		RE_ID < ' + CAST(@SERIAL AS VARCHAR(10)) + ' AND ' +
		--'		EVENT_TYPE = ''' + CAST(@BOARDCODE AS VARCHAR(3)) + ''' AND ' +
		--'		BRANCH_CD = ''' + CAST(@BRANCH_CD AS VARCHAR(3)) + ''' AND ' +
		'		RT.DEL_YN = ''N'' AND ' +
		'		1 = 1	' +
		'	ORDER BY ' +
		'		BT.BANNER_ID ASC, RE_ID DESC; ' 

	PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_LAST_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트 지난주 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : @BOARDCODE가 키값
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC dbo.GET_M_F_LOCALEVENT_LAST_LIST_PROC 0 ,'19'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_LAST_LIST_PROC]
    @BRANCH_CD    INT = 0,
    @BOARDCODE    INT = 0
AS

DECLARE
    @SQL				NVARCHAR(4000),
    @WHERE		  NVARCHAR(1000)

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

    SET @WHERE=''

    IF @BRANCH_CD <> 0
        BEGIN
            SET @WHERE = @WHERE + ' AA.BRANCH_CD = ' + CAST(@BRANCH_CD AS VARCHAR(8)) + ' AND '
        END

    IF @BOARDCODE <> 0
        BEGIN
            SET @WHERE = @WHERE + '	AA.BOARDCODE = ' + CAST(@BOARDCODE AS VARCHAR(8)) + ' AND '
        END

    SET @SQL = '' +
        -- 게시판 정보
        ' SELECT BOARDCODENM, INTRO, IMGM1, IMGM2, DUEDATE, WINNERDATE, EVENTSTARTDATE, PICFLAG FROM DBO.BD_LOCALEVENTCODE_TB WITH (NOLOCK) ' +
        ' WHERE DISFLAG = ''Y'' AND BRANCH_CD = ' + CAST(@BRANCH_CD AS VARCHAR(8)) + ' AND BOARDCODE = ' + CAST(@BOARDCODE AS VARCHAR(8)) + ';'
    -- PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_LASTANSWER_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트 스도쿠 지난주 정답
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : @BOARDCODE가 키값
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC dbo.GET_M_F_LOCALEVENT_LASTANSWER_PROC 0 ,'20'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_LASTANSWER_PROC]
    @BRANCH_CD    INT = 0,
    @BOARDCODE    INT = 0
AS

DECLARE
    @SQL				NVARCHAR(4000),
    @WHERE		  NVARCHAR(1000)

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

    SET @WHERE=''

		IF @BRANCH_CD <> 0
		BEGIN
			SET @WHERE = @WHERE + ' AA.BRANCH_CD = ' + CAST(@BRANCH_CD AS VARCHAR(8)) + ' AND '
		END

		IF @BOARDCODE <> 0
		BEGIN
			SET @WHERE = @WHERE + '	AA.BOARDCODE = ' + CAST(@BOARDCODE AS VARCHAR(8)) + ' AND '
		END

    SET @SQL = '' +
        -- 게시판 정보
        ' SELECT BOARDCODENM, INTRO, IMGM1, IMGM2, DUEDATE, WINNERDATE, EVENTSTARTDATE, PICFLAG FROM DBO.BD_LOCALEVENTCODE_TB WITH (NOLOCK) ' +
        ' WHERE DISFLAG = ''Y'' AND BRANCH_CD = ' + CAST(@BRANCH_CD AS VARCHAR(8)) + ' AND BOARDCODE = ' + CAST(@BOARDCODE AS VARCHAR(8)) + ';'

    --PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_LATEST_BOARDCODE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트 각 이벤트의 최신 BOARDCODE와 직전 주(지난 주) BOARDCODE 가져오기
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/23
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC dbo.GET_M_F_LOCALEVENT_LATEST_BOARDCODE_PROC '스도쿠' 
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_LATEST_BOARDCODE_PROC]
	@BOARDCODENM		VARCHAR(20) = ''
AS

	DECLARE
		@SQL				NVARCHAR(4000),
		@WHERE		  NVARCHAR(1000)

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

    SET @WHERE = ''

    IF @BOARDCODENM <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND BOARDCODENM LIKE ''%' + @BOARDCODENM + '%'' '

			SET @SQL = '' +
				'	SELECT TOP 1 ' +
				'		BOARDCODE ' +
				'	FROM BD_LOCALEVENTCODE_TB ' +
				'	WHERE BRANCH_CD = 0 ' +
				'		AND DISFLAG = ''Y'' ' +
				'		AND DELFLAG = 0 ' +
				+ @WHERE +
				'	ORDER BY EVENTSTARTDATE DESC, MODDATE DESC; ' +
				
				-- 지난 주
				' SELECT TOP 1 X.LASTBOARDCODE ' +
				' FROM ( ' +
				' 	SELECT TOP 100 ' +
				' 		BOARDCODE AS LASTBOARDCODE, ' +
				' 		ROW_NUMBER() OVER(ORDER BY EVENTSTARTDATE DESC, MODDATE DESC) AS ROW_NUM ' +
				' 	FROM BD_LOCALEVENTCODE_TB ' +
				' 	WHERE BRANCH_CD = 0 ' +
				' 		AND DISFLAG = ''Y'' ' +
				' 		AND DELFLAG = 0 ' +
				+ @WHERE +
				'	ORDER BY EVENTSTARTDATE DESC, MODDATE DESC ' +
				' ) AS X ' +
				' WHERE X.ROW_NUM = 2; '

			--PRINT @SQL
			EXECUTE SP_EXECUTESQL @SQL
		END
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_LATEST_BOARDCODE_PROC_BAK01]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트 각 이벤트의 최신 BOARDCODE와 직전 주(지난 주) BOARDCODE 가져오기
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/23
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC dbo.GET_M_F_LOCALEVENT_LATEST_BOARDCODE_PROC '스도쿠' 
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_LATEST_BOARDCODE_PROC_BAK01]
	@BOARDCODENM		VARCHAR(20) = ''
AS

	DECLARE
		@SQL				NVARCHAR(4000),
		@WHERE		  NVARCHAR(1000)

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

    SET @WHERE = ''

    IF @BOARDCODENM <> ''
		BEGIN
			SET @WHERE = @WHERE + ' AND BOARDCODENM LIKE ''%' + @BOARDCODENM + '%'' '

			SET @SQL = '' +
				'	SELECT TOP 1 ' +
				'		BOARDCODE ' +
				'	FROM BD_LOCALEVENTCODE_TB ' +
				'	WHERE BRANCH_CD = 0 ' +
				'		AND DISFLAG = ''Y'' ' +
				'		AND DELFLAG = 0 ' +
				+ @WHERE +
				'	ORDER BY EVENTSTARTDATE DESC, MODDATE DESC; ' +
				
				-- 지난 주
				' SELECT TOP 1 X.LASTBOARDCODE ' +
				' FROM ( ' +
				' 	SELECT TOP 100 ' +
				' 		BOARDCODE AS LASTBOARDCODE, ' +
				' 		ROW_NUMBER() OVER(ORDER BY EVENTSTARTDATE DESC, MODDATE DESC) AS ROW_NUM ' +
				' 	FROM BD_LOCALEVENTCODE_TB ' +
				' 	WHERE BRANCH_CD = 0 ' +
				' 		AND DISFLAG = ''Y'' ' +
				' 		AND DELFLAG = 0 ' +
				+ @WHERE +
				'	ORDER BY EVENTSTARTDATE DESC, MODDATE DESC ' +
				' ) AS X ' +
				' WHERE X.ROW_NUM = 2; '

			--PRINT @SQL
			EXECUTE SP_EXECUTESQL @SQL
		END
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트 상세 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/22
 *  수   정   자 : 조민기
 *  수   정   일 : 2018/07/18
 *  수정일/수정자: 20180813 김선호 @LASTDATE 재추가
 *  설        명 :
 *  주 의  사 항 : @BOARDCODE가 키값
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC dbo.GET_M_F_LOCALEVENT_LIST_PROC 1, 5, 0, '3', '포토', '', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_LIST_PROC]
    @PAGE				INT = 1,
    @PAGESIZE			INT = 5,
    @BRANCH_CD			INT = 0,
    @BOARDCODE			INT = 0,
	@BOARDCODENM		VARCHAR(20) = '',
    @SEARCHFIELD		VARCHAR(8) = '',
    @SEARCHTEXT			VARCHAR(30) = ''
AS

DECLARE
    @SQL			NVARCHAR(4000),
    @WHERE			NVARCHAR(1000)

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

	IF @BOARDCODE = 1 
	BEGIN
		SET @BOARDCODE = 2
	END
	ELSE IF @BOARDCODE = 2
	BEGIN
		SET @BOARDCODE = 3
	END
	ELSE IF @BOARDCODE = 3
	BEGIN
		SET @BOARDCODE = 1
	END

    SET @WHERE=''

    IF @SEARCHFIELD <> ''
    BEGIN
        IF @SEARCHFIELD = 'TITLE'
        	SET @WHERE = @WHERE + '	RT.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
        ELSE IF @SEARCHFIELD = 'CONTENTS'
        	SET @WHERE = @WHERE + '	RT.CONTENT LIKE ''%' + @SEARCHTEXT + '%'' AND '
        ELSE IF @SEARCHFIELD = 'TITLECONTENTS'
        	SET @WHERE = @WHERE + ' (RT.TITLE LIKE ''%' + @SEARCHTEXT + '%'' OR RT.CONTENT LIKE ''%' + @SEARCHTEXT + '%'') AND '
    END

    IF @BOARDCODE <> 0
    BEGIN
        --SET @WHERE = @WHERE + '	AA.BOARDCODE = ' + CAST(@BOARDCODE AS VARCHAR(8)) + ' AND '
		SET @WHERE = @WHERE + '	BT.EVENT_TYPE = '+ CAST(@BOARDCODE AS VARCHAR(8)) + ' AND '
    END

    SET @SQL = '' +
        -- 게시판 정보
		' SELECT CASE EVENT_TYPE WHEN 1 THEN ''행시이벤트'' WHEN 2 THEN ''포토갤러리'' WHEN 3 THEN ''스도쿠'' WHEN 4 THEN ''독자글마당'' WHEN 5 THEN ''깜짝이벤트'' END BOARDCODENM ' +
		' , TITLE INTRO, IMG_PATH3 IMGM1, IMG_PATH4 IMGM2, ENDDATE DUEDATE, LOTTERYDATE WINNERDATE, STARTDATE EVENTSTARTDATE, '''' PICFLAG, SUDOKUDATE LASTDATE ' +
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB WITH(NOLOCK) ' +
		' WHERE DEL_YN = ''N'' AND VIEW_TYPE = 1 AND EVENT_TYPE = ' + CAST(@BOARDCODE AS VARCHAR(8)) + ';' +

        -- 게시물 카운트
        ' SELECT COUNT(*) AS CNT ' +
        ' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ' +
		' JOIN FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK) ON BT.BANNER_ID = RT.BANNER_ID ' +
		' WHERE ' + @WHERE +
		' RT.DEL_YN = ''N'' AND BT.DEL_YN = ''N'' ' +

        -- 게시물 답글
        ' SELECT TOP ' + CONVERT(VARCHAR(10), @PAGE * @PAGESIZE) +
		' X.ROW_NUM, X.SERIAL, X.TITLE, X.USERNAME, X.REGDATE, X.VIEWCNT, X.STEP, X.RENO,	X.PICFILE, X.USERID ' +
		' FROM ( ' +
		'	SELECT ' +
        '		RT.RE_ID SERIAL, ' +
        '		CASE WHEN EVENT_TYPE IN (1,3) THEN BT.TITLE ELSE RT.TITLE END TITLE, ' +
        '		RT.USERNAME, ' +
        '		RT.REG_DATE REGDATE, ' +
        '		0 VIEWCNT, ' +
        '		0 STEP, ' +
        '		0 RENO, ' +
        '		'''' PICFILE, ' +
        '		RT.USERID, ' +
		'		ROW_NUMBER() OVER(ORDER BY RT.BANNER_ID DESC, RE_ID DESC) AS ROW_NUM ' +
        '	FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ' +
		'	JOIN FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK) ON BT.BANNER_ID = RT.BANNER_ID ' +
        '	WHERE ' + @WHERE +
        '	RT.DEL_YN = ''N'' AND BT.DEL_YN = ''N'' ' +
        '	) AS X ' +
		' WHERE X.ROW_NUM > (' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + ') ' +
		'	AND X.ROW_NUM <= (' + CONVERT(VARCHAR(10), ((@PAGE) * @PAGESIZE)) + ');'

     PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_LIST_PROC_BAK01]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트 상세 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/22
 *  수   정   자 : 조민기
 *  수   정   일 : 2018/07/18
 *  설        명 :
 *  주 의  사 항 : @BOARDCODE가 키값
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC dbo.GET_M_F_LOCALEVENT_LIST_PROC_BAK01 1, 5, 0, '3', '스도쿠', '', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_LIST_PROC_BAK01]
    @PAGE				INT = 1,
    @PAGESIZE			INT = 5,
    @BRANCH_CD			INT = 0,
    @BOARDCODE			INT = 0,
	@BOARDCODENM		VARCHAR(20) = '',
    @SEARCHFIELD		VARCHAR(8) = '',
    @SEARCHTEXT			VARCHAR(30) = ''
AS

DECLARE
    @SQL			NVARCHAR(4000),
    @WHERE			NVARCHAR(1000)

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

    SET @WHERE=''

    IF @SEARCHFIELD <> ''
    BEGIN
        IF @SEARCHFIELD = 'TITLE'
        	SET @WHERE = @WHERE + '	RT.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
        ELSE IF @SEARCHFIELD = 'CONTENTS'
        	SET @WHERE = @WHERE + '	RT.CONTENT LIKE ''%' + @SEARCHTEXT + '%'' AND '
        ELSE IF @SEARCHFIELD = 'TITLECONTENTS'
        	SET @WHERE = @WHERE + ' (RT.TITLE LIKE ''%' + @SEARCHTEXT + '%'' OR RT.CONTENT LIKE ''%' + @SEARCHTEXT + '%'') AND '
    END

    IF @BOARDCODE <> 0
    BEGIN
        --SET @WHERE = @WHERE + '	AA.BOARDCODE = ' + CAST(@BOARDCODE AS VARCHAR(8)) + ' AND '
		SET @WHERE = @WHERE + '	BT.EVENT_TYPE = '+ CAST(@BOARDCODE AS VARCHAR(8)) + ' AND '
    END

    SET @SQL = '' +
        -- 게시판 정보
		' SELECT CASE EVENT_TYPE WHEN 1 THEN ''행시이벤트'' WHEN 2 THEN ''포토갤러리'' WHEN 3 THEN ''스도쿠'' WHEN 4 THEN ''독자글마당'' WHEN 5 THEN ''깜짝이벤트'' END BOARDCODENM ' +
		' , TITLE INTRO, IMG_PATH3 IMGM1, IMG_PATH4 IMGM2, '''' DUEDATE, LOTTERYDATE WINNERDATE, STARTDATE EVENTSTARTDATE, '''' PICFLAG,  '''' LASTDATE ' +
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB ' +
		' WHERE DEL_YN = ''N'' AND EVENT_TYPE = ' + CAST(@BOARDCODE AS VARCHAR(8)) + ';' +

        -- 게시물 카운트
        ' SELECT COUNT(*) AS CNT ' +
        ' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ' +
		' JOIN FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK) ON BT.BANNER_ID = RT.BANNER_ID ' +
		' WHERE ' + @WHERE +
		' RT.DEL_YN = ''N'' AND BT.DEL_YN = ''N'' ' +

        -- 게시물 답글
        ' SELECT TOP ' + CONVERT(VARCHAR(10), @PAGE * @PAGESIZE) +
		' X.ROW_NUM, X.SERIAL, X.TITLE, X.USERNAME, X.REGDATE, X.VIEWCNT, X.STEP, X.RENO,	X.PICFILE, X.USERID ' +
		' FROM ( ' +
		'	SELECT ' +
        '		RT.RE_ID SERIAL, ' +
        '		RT.TITLE, ' +
        '		RT.USERNAME, ' +
        '		RT.REG_DATE REGDATE, ' +
        '		0 VIEWCNT, ' +
        '		0 STEP, ' +
        '		0 RENO, ' +
        '		'''' PICFILE, ' +
        '		RT.USERID, ' +
		'		ROW_NUMBER() OVER(ORDER BY RT.BANNER_ID DESC, RE_ID) AS ROW_NUM ' +
        '	FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ' +
		'	JOIN FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK) ON BT.BANNER_ID = RT.BANNER_ID ' +
        '	WHERE ' + @WHERE +
        '		RT.DEL_YN = ''N'' AND BT.DEL_YN = ''N'' ' +
        '	) AS X ' +
		' WHERE X.ROW_NUM > (' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + ') ' +
		'	AND X.ROW_NUM <= (' + CONVERT(VARCHAR(10), ((@PAGE) * @PAGESIZE)) + ');'

     PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_LIST_PROC_BAK180720]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트 상세 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/22
 *  수   정   자 : 조민기
 *  수   정   일 : 2018/07/18
 *  설        명 :
 *  주 의  사 항 : @BOARDCODE가 키값
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC dbo.GET_M_F_LOCALEVENT_LIST_PROC_BAK01 1, 5, 0, '3', '스도쿠', '', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_LIST_PROC_BAK180720]
    @PAGE				INT = 1,
    @PAGESIZE			INT = 5,
    @BRANCH_CD			INT = 0,
    @BOARDCODE			INT = 0,
	@BOARDCODENM		VARCHAR(20) = '',
    @SEARCHFIELD		VARCHAR(8) = '',
    @SEARCHTEXT			VARCHAR(30) = ''
AS

DECLARE
    @SQL			NVARCHAR(4000),
    @WHERE			NVARCHAR(1000)

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

    SET @WHERE=''

    IF @SEARCHFIELD <> ''
    BEGIN
        IF @SEARCHFIELD = 'TITLE'
        	SET @WHERE = @WHERE + '	RT.TITLE LIKE ''%' + @SEARCHTEXT + '%'' AND '
        ELSE IF @SEARCHFIELD = 'CONTENTS'
        	SET @WHERE = @WHERE + '	RT.CONTENT LIKE ''%' + @SEARCHTEXT + '%'' AND '
        ELSE IF @SEARCHFIELD = 'TITLECONTENTS'
        	SET @WHERE = @WHERE + ' (RT.TITLE LIKE ''%' + @SEARCHTEXT + '%'' OR RT.CONTENT LIKE ''%' + @SEARCHTEXT + '%'') AND '
    END

    IF @BOARDCODE <> 0
    BEGIN
        --SET @WHERE = @WHERE + '	AA.BOARDCODE = ' + CAST(@BOARDCODE AS VARCHAR(8)) + ' AND '
		SET @WHERE = @WHERE + '	BT.EVENT_TYPE = '+ CAST(@BOARDCODE AS VARCHAR(8)) + ' AND '
    END

    SET @SQL = '' +
        -- 게시판 정보
		' SELECT CASE EVENT_TYPE WHEN 1 THEN ''행시이벤트'' WHEN 2 THEN ''포토갤러리'' WHEN 3 THEN ''스도쿠'' WHEN 4 THEN ''독자글마당'' WHEN 5 THEN ''깜짝이벤트'' END BOARDCODENM ' +
		' , TITLE INTRO, IMG_PATH3 IMGM1, IMG_PATH4 IMGM2, '''' DUEDATE, LOTTERYDATE WINNERDATE, STARTDATE EVENTSTARTDATE, '''' PICFLAG,  '''' LASTDATE ' +
		' FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB ' +
		' WHERE DEL_YN = ''N'' AND EVENT_TYPE = ' + CAST(@BOARDCODE AS VARCHAR(8)) + ';' +

        -- 게시물 카운트
        ' SELECT COUNT(*) AS CNT ' +
        ' FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ' +
		' JOIN FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK) ON BT.BANNER_ID = RT.BANNER_ID ' +
		' WHERE ' + @WHERE +
		' RT.DEL_YN = ''N'' AND BT.DEL_YN = ''N'' ' +

        -- 게시물 답글
        ' SELECT TOP ' + CONVERT(VARCHAR(10), @PAGE * @PAGESIZE) +
		' X.ROW_NUM, X.SERIAL, X.TITLE, X.USERNAME, X.REGDATE, X.VIEWCNT, X.STEP, X.RENO,	X.PICFILE, X.USERID ' +
		' FROM ( ' +
		'	SELECT ' +
        '		RT.RE_ID SERIAL, ' +
        '		RT.TITLE, ' +
        '		RT.USERNAME, ' +
        '		RT.REG_DATE REGDATE, ' +
        '		0 VIEWCNT, ' +
        '		0 STEP, ' +
        '		0 RENO, ' +
        '		'''' PICFILE, ' +
        '		RT.USERID, ' +
		'		ROW_NUMBER() OVER(ORDER BY RT.BANNER_ID DESC, RE_ID) AS ROW_NUM ' +
        '	FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH(NOLOCK) ' +
		'	JOIN FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH(NOLOCK) ON BT.BANNER_ID = RT.BANNER_ID ' +
        '	WHERE ' + @WHERE +
        '		RT.DEL_YN = ''N'' AND BT.DEL_YN = ''N'' ' +
        '	) AS X ' +
		' WHERE X.ROW_NUM > (' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + ') ' +
		'	AND X.ROW_NUM <= (' + CONVERT(VARCHAR(10), ((@PAGE) * @PAGESIZE)) + ');'

     PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_LOCALEVENT_MOD_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 이벤트 상세보기(스도쿠, 포토갤러리 등)
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/29
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_F_LOCALEVENT_MOD_DETAIL_PROC 60001, 20, 0, 'm52545'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_LOCALEVENT_MOD_DETAIL_PROC]
	@SERIAL					INT,
	@BOARDCODE			INT,
	@BRANCH_CD			INT,
	@USERID					VARCHAR(50) = ''
AS

	-- 글 내용
	--SELECT TOP 1
	--	TA.SERIAL, TA.BOARDCODE, TA.TITLE, TA.USERNAME, TA.USERID, TA.REGDATE, TA.VIEWCNT, TA.PICFILE, TA.CONTENTS, 
	--	TB.BOARDCODENM, TA.RENO, TA.STEP, TB.SECFLAG, TB.PICFLAG, ISNULL(TA.CUID, '') AS CUID, TA.DELFLAG
	--FROM DBO.BD_LOCALEVENT_TB TA WITH (NOLOCK)
	--	INNER JOIN DBO.BD_LOCALEVENTCODE_TB TB WITH (NOLOCK) ON TA.BOARDCODE = TB.BOARDCODE AND TA.BRANCH_CD = TB.BRANCH_CD
	--WHERE	TA.SERIAL = @SERIAL
	--	AND	TB.BRANCH_CD = @BRANCH_CD
	--	AND TA.USERID = @USERID

	SELECT RT.RE_ID SERIAL, BT.EVENT_TYPE BOARDCODE, RT.TITLE, RT.USERNAME, RT.USERID, RT.REG_DATE REGDATE, 0 VIEWCNT, RT.IMG_PATH PICFILE, RT.CONTENT CONTENTS
	, BT.TITLE BOARDCODENM, 0 RENO, 0 STEP, 'Y' SECFLAG, 'Y' PICFLAG, ISNULL(RT.CUID, '') AS CUID, CASE RT.DEL_YN WHEN 'Y' THEN 1 ELSE 0 END DELFLAG 
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB RT WITH (NOLOCK)
	JOIN FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB BT WITH (NOLOCK) ON BT.BANNER_ID = RT.BANNER_ID
	WHERE RT.RE_ID = @SERIAL
		AND RT.USERID = @USERID
GO
/****** Object:  StoredProcedure [dbo].[GET_M_FA_SURVEY_ANSWER_TB_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 응답 리스트
*  EXEC  DBO.GET_M_FA_SURVEY_ANSWER_TB_LIST_EXCEL_PROC 1
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/10/13) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_M_FA_SURVEY_ANSWER_TB_LIST_EXCEL_PROC]
(
      @SURVEY_ID        INT
)
AS
SET NOCOUNT ON

DECLARE @strSQL			NVARCHAR(4000)

SET @strSQL = ''

SET @strSQL= @strSQL+'select A.IDX
                                , A.USERID
                                , A.USERNM
                                , A.USERAGE
                                , A.POST
                                , A.ADDR

                                , A.EMAIL
                                , A.JOB
                                , A.TEL
                                , A.OBJECTIVE
                                , A.SUBJECTIVE

                                , A.MULTIPLE
                                , A.REG_DT
                                , CASE
                                       WHEN A.SEX IN (''0'',''A'',''M'') THEN ''남''
                                       WHEN A.SEX IN (''1'',''B'',''F'') THEN ''여''
                                  END AS GENDER
						   FROM FA_SURVEY_ANSWER_TB AS A
						   WHERE SURVEY_ID = ' + CAST(@SURVEY_ID AS VARCHAR(4)) + ' ORDER BY IDX ASC'

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_FA_SURVEY_ANSWER_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 응답 리스트
*  EXEC : DBO.GET_M_FA_SURVEY_ANSWER_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/10/13) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_M_FA_SURVEY_ANSWER_TB_LIST_PROC]
(
      @SURVEY_ID        INT
,    	@n4Page		        INT
,    	@n2PageSize       SMALLINT
)
AS
SET NOCOUNT ON

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(2000)

SET @strSQLSUB = ''

SET @strSQL='SELECT COUNT(IDX)  FROM FA_SURVEY_ANSWER_TB (NOLOCK) WHERE SURVEY_ID =  ' + CAST(@SURVEY_ID AS VARCHAR(4))



IF @n4Page = 1 BEGIN
  	set	Rowcount	@n2PageSize
   SET @strSQL= @strSQL+'select A.IDX
                                , A.USERID
                                , A.USERNM
                                , A.USERAGE
                                , A.POST
                                , A.ADDR

                                , A.EMAIL
                                , A.JOB
                                , A.TEL
                                , A.OBJECTIVE
                                , A.SUBJECTIVE

                                , A.MULTIPLE
                                , A.REG_DT
                                , CASE
                                       WHEN A.SEX IN (''0'',''A'',''M'') THEN ''남''
                                       WHEN A.SEX IN (''1'',''B'',''F'') THEN ''여''
                                  END AS GENDER
						   FROM FA_SURVEY_ANSWER_TB AS A (NOLOCK)
						   WHERE SURVEY_ID = ' + CAST(@SURVEY_ID AS VARCHAR(4)) + ' ORDER BY IDX ASC'

END ELSE BEGIN
	SET @strSQL= @strSQL+'
	DECLARE	@PrevCount	  INT
	DECLARE	@n4ID      		INT

	SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'

	SET	RowCount	@PrevCount

	SELECT	@n4ID = IDX
	   FROM FA_SURVEY_ANSWER_TB (NOLOCK)  WHERE SURVEY_ID =  ' + CAST(@SURVEY_ID AS VARCHAR(4)) + ' ORDER BY IDX ASC

	SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'

	SELECT A.IDX
        , A.USERID
        , A.USERNM
        , A.USERAGE
        , A.POST
        , A.ADDR

        , A.EMAIL
        , A.JOB
        , A.TEL
        , A.OBJECTIVE
        , A.SUBJECTIVE

        , A.MULTIPLE
        , A.REG_DT
        , CASE
               WHEN A.SEX IN (''0'',''A'',''M'') THEN ''남''
               WHEN A.SEX IN (''1'',''B'',''F'') THEN ''여''
          END AS GENDER
	   FROM FA_SURVEY_ANSWER_TB AS A (NOLOCK)
	  WHERE IDX >  @n4ID AND SURVEY_ID = ' + CAST(@SURVEY_ID AS VARCHAR(4)) + ' ORDER BY IDX ASC'
END

--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_FA_SURVEY_QUESTION_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 기초정보
*  EXEC : GET_M_FA_SURVEY_QUESTION_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_M_FA_SURVEY_QUESTION_TB_LIST_PROC]
(
  	@nSurvey_ID	  INT


)
AS
SET NOCOUNT ON




SELECT S.TITLE
     , SQ.QUESTION_DIV
     , SQ.ANSWER_CNT
     , SQ.QUESTION_TITLE
     , SQ.ANSWER1
     , SQ.ANSWER2
     , SQ.ANSWER3

     , SQ.ANSWER4
     , SQ.ANSWER5
     , SQ.ANSWER6
     , SQ.RESPONSE_CNT
     , SQ.INPUT_DIV

     , SQ.CHAR_LIMIT_CNT
     , SQ.INDEX_NUM

  FROM FA_SURVEY_QUESTION_TB SQ, FA_SURVEY_TB S
 WHERE SQ.SURVEY_ID = @nSurvey_ID
   AND SQ.SURVEY_ID = S.SURVEY_ID

GO
/****** Object:  StoredProcedure [dbo].[GET_M_FA_SURVEY_TB_INFO_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 정보
*  EXEC : GET_M_FA_SURVEY_TB_INFO_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_M_FA_SURVEY_TB_INFO_PROC]
(
  	@nSurvey_ID	  INT


)
AS
SET NOCOUNT ON

SELECT  MANAGE_AREA
      , MANAGE_NM
      , TITLE
      , JOIN_DIV
      , START_DT

      , END_DT
      , PRIZE_YN
      , PRIZE_CONTS
      , PRIZE_IMG
      , PRIZE_DT

      , GIVE_DT
      , OBJECTIVE_CNT
      , SUBJECTIVE_CNT
      , MULTIPLE_CNT
      , PROGRESS_DIV
  FROM FA_SURVEY_TB
 WHERE SURVEY_ID = @nSurvey_ID

GO
/****** Object:  StoredProcedure [dbo].[GET_M_FA_SURVEY_TB_INFO_SEMI_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 기초정보
*  EXEC : GET_M_FA_SURVEY_TB_INFO_SEMI_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_M_FA_SURVEY_TB_INFO_SEMI_PROC]
(
  	@nSurvey_ID	  INT


)
AS
SET NOCOUNT ON

SELECT  TITLE
      , OBJECTIVE_CNT
      , SUBJECTIVE_CNT
      , MULTIPLE_CNT
  FROM FA_SURVEY_TB
 WHERE SURVEY_ID = @nSurvey_ID

GO
/****** Object:  StoredProcedure [dbo].[GET_M_FA_SURVEY_TB_LIST_CNT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 리스트 갯수
*  EXEC : GET_M_FA_SURVEY_TB_LIST_CNT_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-10-13) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_M_FA_SURVEY_TB_LIST_CNT_PROC]
(
  	@strProgressDiv	  CHAR(1)				=	''
, 	@strArea          CHAR(1)				=	''
,   @strKey           CHAR(1)				=	''
,   @strWord					VARCHAR(100)	=	''

)
AS
SET NOCOUNT ON

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(3000)

SET @strSQLSUB = ''

IF @strProgressDiv <> '' OR @strArea <>'' OR @strWord <> '' BEGIN
    IF @strProgressDiv <> ''
      SET @strSQLSUB = @strSQLSUB+' AND PROGRESS_DIV LIKE ''%'+@strProgressDiv+'%''  '

    IF @strArea <> '0'
      SET @strSQLSUB = @strSQLSUB+' AND MANAGE_AREA ='''+@strArea+''''

    IF @strWord <> '' BEGIN
      IF @strKey = '' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND TITLE LIKE ''%'+@strWord+'%''  '
      END ELSE IF  @strKey = '1' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND TITLE LIKE ''%'+@strWord+'%''  '
      END
    END
END

SET @strSQL='SELECT COUNT(*)
                      FROM FA_SURVEY_TB (NOLOCK) WHERE DEL_YN=' + '''N''' +@strSQLSUB

EXECUTE SP_EXECUTESQL @strSQL
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[GET_M_FA_SURVEY_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 리스트
*  EXEC : GET_M_FA_SURVEY_TB_LIST_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009-07-21) : 신규작성
*********************************************************************/
CREATE PROCEDURE [dbo].[GET_M_FA_SURVEY_TB_LIST_PROC]
(
  	@strProgressDiv	  CHAR(1)				=	''
, 	@strArea          CHAR(1)				=	''
,  	@strKey         CHAR(1)				  =	''
,  	@strWord			  VARCHAR(100)	  =	''
,   @nTop		        INT	            -- 총갯수


)
AS
SET NOCOUNT ON

DECLARE @strSQL			NVARCHAR(4000)
DECLARE @strSQLSUB	NVARCHAR(3000)

SET @strSQLSUB = ''

IF @strProgressDiv <> '' OR @strArea <>'' OR @strWord <> '' BEGIN
    IF @strProgressDiv <> ''
      SET @strSQLSUB = @strSQLSUB+' AND PROGRESS_DIV LIKE ''%'+@strProgressDiv+'%''  '

    IF @strArea <> '0'
      SET @strSQLSUB = @strSQLSUB+' AND MANAGE_AREA ='''+@strArea+''''

    IF @strWord <> '' BEGIN
      IF @strKey = '' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND TITLE LIKE ''%'+@strWord+'%''  '
      END ELSE IF  @strKey = '1' BEGIN
         SET @strSQLSUB = @strSQLSUB+' AND TITLE LIKE ''%'+@strWord+'%''  '
      END
    END
END

-- 이벤트 리스트
SET @strSQL =	N'SELECT TOP '+ CAST(@nTop AS NVARCHAR(10)) +'
                 SURVEY_ID
               , MANAGE_AREA
               , TITLE
               , JOIN_DIV
               , START_DT
               , END_DT
               , PROGRESS_DIV
	 	 FROM FA_SURVEY_TB
		 WHERE DEL_YN =' + '''N''' +
		@strSQLSUB +
		 'ORDER BY SURVEY_ID DESC'

EXECUTE SP_EXECUTESQL @strSQL
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[GET_M_LOCALEVENTCODE_DATA_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 컨텐츠관리 > 지역이벤트 카테고리 가져오기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2010-10-18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : exec DBO.GET_M_LOCALEVENTCODE_DATA_PROC 11
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_LOCALEVENTCODE_DATA_PROC]
    @BRANCH_CD INT
AS

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON


    SELECT
        COUNT(*) AS CNT
    FROM
        DBO.BD_LOCALEVENTCODE_TB(NOLOCK)
    WHERE
        BRANCH_CD =@BRANCH_CD AND
        DELFLAG ='0';

    SELECT
        BRANCH_CD,
        BOARDCODE,
        BOARDCODENM,
        ISNULL(DISFLAG,'N') AS DISFLAG,
        ISNULL(PICFLAG,'N') AS PICFLAG,
        ISNULL(SECFLAG,'N') AS SECFLAG
    FROM
        DBO.BD_LOCALEVENTCODE_TB(NOLOCK)
    WHERE
        BRANCH_CD = @BRANCH_CD AND
        DELFLAG ='0'
    ORDER BY
        DISFLAG DESC,
        ORDERNO ASC

GO
/****** Object:  StoredProcedure [dbo].[GET_M_LOCALEVENTCODE_SORT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 컨텐츠관리 > 지역이벤트 카테고리 가져오기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2010-10-18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : exec DBO.GET_M_LOCALEVENTCODE_SORT_PROC 11
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_LOCALEVENTCODE_SORT_PROC]
    @BRANCH_CD INT
AS

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

    SELECT
        COUNT(*) AS CNT
    FROM
        DBO.BD_LOCALEVENTCODE_TB(NOLOCK)
    WHERE
        BRANCH_CD = @BRANCH_CD AND
        DELFLAG ='0' AND
        DISFLAG ='Y'
    ;

    SELECT
        BOARDCODE,
        BOARDCODENM,
        ORDERNO
    FROM
        DBO.BD_LOCALEVENTCODE_TB(NOLOCK)
    WHERE
        BRANCH_CD = @BRANCH_CD AND
        DISFLAG ='Y' AND
        DELFLAG ='0'
    ORDER BY
        ORDERNO ASC;

GO
/****** Object:  StoredProcedure [dbo].[GET_M_MAGBOX_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 - 벼룩시장정보관리 - 줄,박스광고 요금관리
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_MAGBOX_PROC '310', 16
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_MAGBOX_PROC]
	@BOXID				VARCHAR(50),
	@LOCALBRANCH	INT = 0
AS

	SELECT
		TOP 1
		SERIAL,
		BOXCONTENTS1,
		BOXCONTENTS2
	FROM
		DBO.MAGBOX(NOLOCK)
	WHERE
		BOXID=@BOXID AND
		LOCALBRANCH=@LOCALBRANCH
	ORDER BY
		SERIAL DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_M_MEMBER_INFO_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 기본 정보 가져 오기
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/12
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 GET_M_MEMBER_INFO_PROC '11918934'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_M_MEMBER_INFO_PROC] 
	@CUID INT
AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 기본정보
	SELECT TOP 1
		 A.USERID	-- 회원아이디
		,A.MEMBER_CD -- 회원구분
		,A.USER_NM AS USERNAME	-- 회원명
		,A.EMAIL		-- 이메일
		,'' AS PHONE
		,A.HPHONE		-- 휴대폰
		,A.MOD_DT		-- 수정일
		,A.JOIN_DT	
		,A.GENDER
		,A.BIRTH  AS JUMINNO
		,A.CUID
		,A.BAD_YN
	FROM MEMBERDB.MWMEMBER.DBO.CST_MASTER AS A WITH(NOLOCK)
	WHERE A.OUT_YN ='N'
		AND A.BAD_YN ='N'
		AND A.CUID = @CUID
	ORDER BY A.SITE_CD ASC -- 사이트코드 (F:FindAll, S:부동산서브, M: MWPLUS)
END
GO
/****** Object:  StoredProcedure [dbo].[GET_M_PLUS_LCODE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단-컨텐츠관리-벼룩시장플러스개편-카테고리리스트:대분류 카테고리가져오기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/07/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_PLUS_LCODE_PROC
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_PLUS_LCODE_PROC]
AS
SET NOCOUNT ON

	SELECT
		LCODE, LNAME, DISFLAG
	FROM
		DBO.NESSAYCODE(NOLOCK)
	WHERE
		MCODE = 0
	ORDER BY
		LCODE


SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[GET_M_PLUS_MCODE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단-컨텐츠관리-벼룩시장플러스개편- 중분류 가져오기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/08/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_PLUS_MCODE_PROC 50
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_PLUS_MCODE_PROC]
	@LCODE	SMALLINT
AS
SET NOCOUNT ON

	SELECT
		MCODE, MNAME, DISFLAG
	FROM
		DBO.NESSAYCODE(NOLOCK)
	WHERE
		MCODE <> 0 AND
		LCODE = @LCODE
	ORDER BY
		MCODE


SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[GET_NEWS_PLUS_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*뉴스 메인과 서브 페이지 - 벼룩시장 플러스*/
CREATE PROC [dbo].[GET_NEWS_PLUS_PROC]
AS

SET NOCOUNT ON

SELECT
       TOP 2
       SERIAL
     , CODE
     , TITLE
     , SUMMARY
     , IMGSRC4
  FROM NESSAY
 WHERE PATINDEX('%.jpg',IMGSRC4)> 0
 ORDER BY
       MODDATE DESC,
       SERIAL DESC


SELECT
       TOP 2
       SERIAL
     , CODE
     , TITLE
     , SUMMARY
  FROM NESSAY
 WHERE PATINDEX('%.jpg',IMGSRC4)= 0
 ORDER BY
       MODDATE DESC,
       SERIAL DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_WINNING_LIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 글마당 당첨자 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/10/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : http://admin.paper.findall.co.kr/DATA/WinningResult.asp
 *  사 용  예 제 : EXEC DBO.GET_WINNING_LIST_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_WINNING_LIST_PROC]

  @IDX VARCHAR(500)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  SET @SQL = ''

  SET @SQL = 'SELECT IDX
                    ,TITLE
                    ,USERID
                    ,USERNAME
                    ,EMAIL
                    ,CONTENTS
                    ,IMGSRC
                    ,IPADDR
                    ,VIEWCNT
                    ,DELFLAG
                    ,DREW
                    ,REGDATE
                    ,MODDATE
                FROM DBO.READEREVENT2
               WHERE IDX IN ('+ @IDX +')'

  EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[InsertKnowPointSub_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertKnowPointSub_DelAN]
(
	@UserID varchar(50),
	@Point int,
	@AccPoint int,
	@Reason varchar(500),
	@MagFlag int
)
AS

BEGIN

	INSERT INTO k_PointSub(UserID,
		Point,
		AccPoint,
		Reason,
		RegDate,
		MagFlag)
	VALUES(@UserID,
		@Point,
		@AccPoint,
		@Reason,
		GetDate(),
		@MagFlag)

END

GO
/****** Object:  StoredProcedure [dbo].[InsertLifeLinkAd]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertLifeLinkAd]
(
	@Serial int,
	@Title varchar(200),
	@Url varchar(200),
	@StDate datetime,
	@EnDate datetime,
	@ViewFlag char(1),
	@Type char(1)
)
AS
BEGIN
	IF @Serial = 0
		BEGIN
			INSERT INTO LifeLinkAd(Title,
				Url,
				StDate,
				EnDate,
				ViewFlag,
				Type)
			VALUES(@Title,
				@Url,
				@StDate,
				@EnDate,
				@ViewFlag,
				@Type)
			SET @Serial = @@IDENTITY
		END
	ELSE
		BEGIN
			UPDATE LifeLinkAd SET
				Title  	= @Title,
				Url  	= @Url,
				StDate  	= @StDate,
				EnDate  	= @EnDate,
				ViewFlag	= @ViewFlag
			WHERE Serial = @Serial
		END
	SELECT @Serial

END

GO
/****** Object:  StoredProcedure [dbo].[InsertLifeLinkCode_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertLifeLinkCode_DelAN]
(
	@Code1 int,
	@CodeNm1 varchar(30),
	@FontColor varchar(50)
)
AS
BEGIN
	IF @Code1 = 0
		BEGIN
			INSERT LifeLinkCode1(CodeNm1,FontColor, Code1Order)
				SELECT  @CodeNm1, @FontColor,
					ISNULL(MAX(Code1Order),0) +  1
				FROM LifeLinkCode1
			SET @Code1 = @@IDENTITY
		END
	ELSE
		BEGIN
			UPDATE LifeLinkCode1 SET
				CodeNm1 = @CodeNm1,
				FontColor = @FontColor
			WHERE Code1 = @Code1
		END
	SELECT @Code1

END

GO
/****** Object:  StoredProcedure [dbo].[InsertLifeLinkCode2_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertLifeLinkCode2_DelAN]
(
	@Code1 int,
	@Code2 int,
	@CodeNm2 varchar(30)
)
AS
BEGIN
	IF @Code2 = 0
		BEGIN
			-- 기존에 입력된 Code2 최대값에 1을 더하여 Code2를 생성한다.
			-- 만약 해당하는 카테고리에 입력된 Code2 값이 없으면 Code1 + 001 값을
			-- Code2에 입력한다.
			INSERT LifeLinkCode2(Code1, Code2, CodeNm2, Code2Order)
				SELECT  @Code1,
					ISNULL(MAX(Code2), CONVERT(int,CONVERT(varchar,@Code1) + '000')) + 1,
					@CodeNm2,
					ISNULL(MAX(Code2Order),0) +  1
				FROM LifeLinkCode2 WHERE Code1 = @Code1
			SET @Code2 = @@IDENTITY
		END
	ELSE
		BEGIN
			UPDATE LifeLinkCode2 SET
				CodeNm2 = @CodeNm2
			WHERE Code2 = @Code2
		END
	SELECT @Code2

END

GO
/****** Object:  StoredProcedure [dbo].[InsertLifeLinkKeywd_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertLifeLinkKeywd_DelAN]
(
	@Serial int,
	@Keywd varchar(30),
	@StDate datetime,
	@EnDate datetime,
	@ViewFlag char(1)
)
AS
BEGIN
	IF @Serial = 0
		BEGIN
			INSERT INTO LifeLinkKeywd(Keywd,
				StDate,
				EnDate,
				ViewFlag)
			VALUES(@Keywd,
				@StDate,
				@EnDate,
				@ViewFlag)
			SET @Serial = @@IDENTITY
		END
	ELSE
		BEGIN
			UPDATE LifeLinkKeywd SET
				Keywd  	= @Keywd,
				StDate  	= @StDate,
				EnDate  	= @EnDate,
				ViewFlag	= @ViewFlag
			WHERE Serial = @Serial
		END
	SELECT @Serial

END

GO
/****** Object:  StoredProcedure [dbo].[InsertLifeLinkRecmd_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertLifeLinkRecmd_DelAN]
(
	@Serial int,
	@SiteNm varchar(30),
	@Url varchar(200),
	@StDate datetime,
	@EnDate datetime,
	@ViewFlag char(1)
)
AS
BEGIN
	IF @Serial = 0
		BEGIN
			INSERT INTO LifeLinkRecmd(SiteNm,
				Url,
				StDate,
				EnDate,
				ViewFlag)
			VALUES(@SiteNm,
				@Url,
				@StDate,
				@EnDate,
				@ViewFlag)
			SET @Serial = @@IDENTITY
		END
	ELSE
		BEGIN
			UPDATE LifeLinkRecmd SET
				SiteNm  	= @SiteNm,
				Url  	= @Url,
				StDate  	= @StDate,
				EnDate  	= @EnDate,
				ViewFlag	= @ViewFlag
			WHERE Serial = @Serial
		END
	SELECT @Serial

END

GO
/****** Object:  StoredProcedure [dbo].[InsertLifeLinkServ_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertLifeLinkServ_DelAN]
(
	@Serial int,
	@Title varchar(200),
	@Url varchar(200),
	@StDate datetime,
	@EnDate datetime,
	@ViewFlag char(1)
)
AS
BEGIN
	IF @Serial = 0
		BEGIN
			INSERT INTO LifeLinkServ(Title,
				Url,
				StDate,
				EnDate,
				ViewFlag)
			VALUES(@Title,
				@Url,
				@StDate,
				@EnDate,
				@ViewFlag)
			SET @Serial = @@IDENTITY
		END
	ELSE
		BEGIN
			UPDATE LifeLinkServ SET
				Title  	= @Title,
				Url  	= @Url,
				StDate  	= @StDate,
				EnDate  	= @EnDate,
				ViewFlag	= @ViewFlag
			WHERE Serial = @Serial
		END
	SELECT @Serial

END

GO
/****** Object:  StoredProcedure [dbo].[InsertLifeLinkSite_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertLifeLinkSite_DelAN]
(
	@Serial int,
	@Code2 int,
	@SiteNm varchar(35),
	@Url varchar(200),
	@OptType char(1),
	@StDate datetime,
	@EnDate datetime,
	@BRChk char(1),
	@ViewFlag char(1)
)
AS
BEGIN
	IF @Serial = 0
		BEGIN
			INSERT INTO LifeLinkSite(Code2,
				SiteNm,
				Url,
				OptType,
				StDate,
				EnDate,
				BRChk,
				ViewFlag)
			VALUES(@Code2,
				@SiteNm,
				@Url,
				@OptType,
				@StDate,
				@EnDate,
				@BRChk,
				@ViewFlag)
			SET @Serial = @@IDENTITY
		END
	ELSE
		BEGIN
			UPDATE LifeLinkSite SET
				Code2 	= @Code2,
				SiteNm  	= @SiteNm,
				Url  	= @Url,
				OptType = @OptType,
				StDate  	= @StDate,
				EnDate  	= @EnDate,
				ViewFlag	= @ViewFlag,
				BRChk   = @BRChk
			WHERE Serial = @Serial
		END
	SELECT @Serial

END

GO
/****** Object:  StoredProcedure [dbo].[IPJ_GuideMain]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[IPJ_GuideMain]
as
--입주 벼룩시장에서 사용
--Created By Sebilia
--2007/07/13
SET NOCOUNT ON

	/*
	LCode=30 and MCode=60	--부동산 Q&A
	LCode=30 and MCode=42	--부동산 가이드
	LCode=30 and MCode=62	--아파트 백과
	LCode=10 and MCode=96	--생활의 지혜
	*/
	DECLARE 	@SQL 		varchar(2000)

	SET @SQL = 'SELECT top 3 Serial, Code, Title, Summary
			FROM Essay WITH (NOLOCK)
			where DisFlag=2
			and Code=3042
			order by serial desc;

			SELECT top 3 Serial, Code, Title, Summary
			FROM Essay WITH (NOLOCK)
			where DisFlag=2
			and Code=3060
			order by serial desc;

			SELECT Top 1 Serial, Code, Title, Summary
			FROM Essay WITH (NOLOCK)
			where DisFlag=2
			and Code=3062
			order by serial desc;

			SELECT Top 1 Serial, Code, Title, Summary
			FROM Essay WITH (NOLOCK)
			where DisFlag=2
			and Code=1096
			order by serial desc'

	Exec(@SQL)
--	Print(@SQL)

GO
/****** Object:  StoredProcedure [dbo].[IpJooMainDisplay]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IpJooMainDisplay]
as
--입주 벼룩시장에서 사용
--Created By Sebilia
--2007/07/13
SET NOCOUNT ON

/*
LCode=30 and MCode=60	--부동산 Q&A
LCode=30 and MCode=42	--부동산 가이드
LCode=30 and MCode=62	--아파트 백과
LCode=10 and MCode=96	--생활의 지혜
*/

SELECT top 1 Serial, Code, Title, Summary
FROM Essay WITH (NOLOCK)
where DisFlag=2
and Code='3060'
order by serial desc

SELECT top 1 Serial, Code, Title, Summary
FROM Essay WITH (NOLOCK)
where DisFlag=2
and Code='3042'
order by serial desc

SELECT Top 1 Serial, Code, Title, Summary
FROM Essay WITH (NOLOCK)
where DisFlag=2
and Code='3062'
order by serial desc

/*
SELECT Top 1 Serial, Code, Title, Summary
FROM Essay WITH (NOLOCK)
where DisFlag=2
and Code='1096'
order by serial desc
*/

GO
/****** Object:  StoredProcedure [dbo].[MOD_F_ARTICLE_DEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장PLUS - 글마당 - 글 삭제
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC	[dbo].[MOD_F_ARTICLE_DEL_PROC]
	@IDX				INT,
	@USERID		VARCHAR(50),

	@IRESULT		INT=0 OUTPUT
AS
BEGIN TRAN

	UPDATE DBO.READEREVENT2
	SET
		DELFLAG = '1'
	WHERE
		IDX = @IDX	AND
		USERID	= @USERID

	IF @@ROWCOUNT>1 OR @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[MOD_F_ARTICLE_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장PLUS - 글마당 - 글 수정
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC	[dbo].[MOD_F_ARTICLE_DETAIL_PROC]
	@IDX				INT,
	@USERID			VARCHAR(50),
	@USERNAME		VARCHAR(30),
	@TITLE			VARCHAR(100),
	@EMAIL			VARCHAR(50),
	@CONTENTS		TEXT,
	@Ndx				Int,

	@IRESULT		INT=0 OUTPUT
AS
BEGIN TRAN

	UPDATE
		DBO.READEREVENT2
	SET
		USERNAME = @USERNAME,
		TITLE		 = @TITLE,
		EMAIL		 = @EMAIL,
		CONTENTS = @CONTENTS,
		Ndx = @Ndx
	WHERE
		IDX = @IDX AND
		USERID = @USERID

	IF @@ROWCOUNT<>1 OR @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[MOD_F_LOCALEVENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장PLUS - 지역이벤트 수정
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[MOD_F_LOCALEVENT_PROC]
    @SERIAL       INT=0,

    @TITLE        VARCHAR(100)='',
    @USERNAME     VARCHAR(30)='',
    @CONTENTS     TEXT='',

    @IPADDR       VARCHAR(30)='',
    @PICDEL       VARCHAR(2)='',
    @PICFILE      VARCHAR(200)='',

    @IRESULT      INT=0 OUTPUT
AS

BEGIN TRAN

    IF @PICDEL='ON'    -- 삭제를 체크했으면 이미지 삭제
        BEGIN
            UPDATE dbo.BD_LOCALEVENT_TB
            SET
                PICFILE  = ''
            WHERE
                SERIAL = @SERIAL
        END

    IF @PICFILE<>''    -- 이미지를 새로 등록한다면
        BEGIN
            UPDATE dbo.BD_LOCALEVENT_TB
            SET
                TITLE    = @TITLE,
                USERNAME = @USERNAME,
                CONTENTS = @CONTENTS,
                PICFILE  = @PICFILE,
                MODDATE  = GETDATE()
            WHERE
                SERIAL = @SERIAL
        END
    ELSE
        BEGIN
            UPDATE dbo.BD_LOCALEVENT_TB
            SET
                TITLE    = @TITLE,
                USERNAME = @USERNAME,
                CONTENTS = @CONTENTS,
                MODDATE  = GETDATE()
            WHERE
                SERIAL = @SERIAL
        END

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[MOD_M_ARTICLE_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 글마당 - 글 수정
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC	[dbo].[MOD_M_ARTICLE_DETAIL_PROC]
	@IDX				INT,
	@USERNAME		VARCHAR(30),
	@TITLE			VARCHAR(100),
	@EMAIL			VARCHAR(50),
	@CONTENTS		TEXT,

	@IRESULT		INT=0 OUTPUT
AS
BEGIN TRAN

	UPDATE
		DBO.READEREVENT2
	SET
		USERNAME = @USERNAME,
		TITLE		 = @TITLE,
		EMAIL		 = @EMAIL,
		CONTENTS = @CONTENTS
	WHERE
		IDX = @IDX

	IF @@ROWCOUNT>1 OR @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[MOD_M_ARTICLE_DREWDEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 글마당 - 당첨글 처리 및 글 삭제
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC	[dbo].[MOD_M_ARTICLE_DREWDEL_PROC]
		@IDX		INT,
		@GBN		CHAR(1),

		@IRESULT	INT=0 OUTPUT
AS

BEGIN TRAN
	IF @GBN='2'	-- 삭제
		BEGIN
			UPDATE
				DBO.READEREVENT2
			SET
				DELFLAG = '1'
			WHERE
				IDX=@IDX
		END
	ELSE	-- 당첨글, 비당첨글 처리 0:당첨취소, 1:당첨
		BEGIN
			UPDATE
				DBO.READEREVENT2
			SET
				DREW = @GBN
			WHERE
				IDX = @IDX
		END

	IF @@ROWCOUNT>1 OR @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[MOD_M_ARTICLE_THEME_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 글마당 테마수정
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : --DBO.MOD_M_ARTICLE_THEME_DETAIL_PROC 1
 *************************************************************************************/
CREATE PROC	[dbo].[MOD_M_ARTICLE_THEME_DETAIL_PROC]
	@MODTYPE	VARCHAR(10),

	@NDX			INT,
	@TITLE		NVARCHAR(30),
	@COMMENT	NVARCHAR(500),
	@IMGURL		VARCHAR(200),
	@DISFLAG	CHAR(1),
	@SORTID		TINYINT,

	@IRESULT	INT=0 OUTPUT
AS

BEGIN TRAN
	IF @MODTYPE='view'	--# 상세보기 페이지에서 수정하는 경우
		BEGIN

			UPDATE
				DBO.READERROUND2
			SET
				TITLE 	= @TITLE,
				COMMENT = @COMMENT,
				IMGURL	= @IMGURL,
				DISFLAG	= @DISFLAG,
				SORTID	= @SORTID
			WHERE
				NDX	= @NDX

		END
	ELSE	--# 리스트에서 수정하는 경우
		BEGIN

			UPDATE
				DBO.READERROUND2
			SET
				DISFLAG	= @DISFLAG,
				SORTID	= @SORTID
			WHERE
				NDX	= @NDX

		END

	IF @@ROWCOUNT>1 OR @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[MOD_M_ESSAY_ASMAINLIST_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 벼룩시장plus - 체크항목 메인리스트로 처리 혹은 메인리스트에서 삭제
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC	[dbo].[MOD_M_ESSAY_ASMAINLIST_PROC]
	@INT	INT,
	@TYPE	CHAR(1)=NULL
AS

	UPDATE DBO.NESSAY
	SET
		MAINFLAG = @TYPE
	WHERE
		SERIAL = @INT

GO
/****** Object:  StoredProcedure [dbo].[MOD_M_ESSAY_CATEGORY_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 정보마당 카테고리 수정
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC	[dbo].[MOD_M_ESSAY_CATEGORY_DETAIL_PROC]
	@LCODE				SMALLINT,
	@MCODE				SMALLINT,

	@MNAME				VARCHAR(100) = NULL,
	@DESCRIPTION	VARCHAR(200) = NULL,
	@DISFLAG			TINYINT,

	@IRESULT	INT=0 OUTPUT
AS

BEGIN TRAN

	UPDATE DBO.NESSAYCODE
	SET
		MNAME 			= @MNAME,
		DESCRIPTION = @DESCRIPTION,
		DISFLAG 		= @DISFLAG
	WHERE
		LCODE = @LCODE AND
		MCODE = @MCODE

	IF @@ROWCOUNT>1 OR @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[MOD_M_ESSAY_DEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 정보마당 - 글 삭제
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC	[dbo].[MOD_M_ESSAY_DEL_PROC]
	@SERIAL				INT
AS

	DECLARE @CODE	INT
	SELECT TOP 1 @CODE = CODE FROM DBO.NESSAY WHERE SERIAL= @SERIAL

	--카운트 다운
	UPDATE DBO.NESSAYCODE
	SET
		CNT = CNT-1
	WHERE
		CODE = @CODE

	--글 삭제
	DELETE FROM DBO.NESSAY
	WHERE
		CODE 		= @CODE AND
		SERIAL	= @SERIAL

	--댓글삭제
	DELETE FROM DBO.NESSAYCOMMENT
	WHERE
		CODE = @SERIAL

GO
/****** Object:  StoredProcedure [dbo].[MOD_M_F_LOCALEVENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트(스도쿠, 포토이벤트) 글 수정
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[MOD_M_F_LOCALEVENT_PROC]
		@SERIAL			INT = 0,
		@TITLE			VARCHAR(100) = '',
		@USERNAME		VARCHAR(30) = '',
		@CONTENTS		TEXT = '',
		@IPADDR			VARCHAR(30) = '',
		@PICDEL			VARCHAR(2) = '',
		@PICFILE		VARCHAR(200) = '',
		@IRESULT		INT = 0 OUTPUT
AS

BEGIN

	EXEC FINDDB1.PAPER_NEW.DBO.MOD_M_F_LOCALEVENT_PROC @SERIAL,@TITLE,@USERNAME,@CONTENTS,@IPADDR,@PICDEL,@PICFILE,@IRESULT OUTPUT

END
GO
/****** Object:  StoredProcedure [dbo].[MOD_M_FA_SURVEY_TB_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	 :	MOD_M_FA_SURVEY_TB_PROC
 설명	 :	설문조사 기초정보 수정
작성자 :  정태운
작성일 :	2010-10-13
==============================================================================*/
CREATE PROC [dbo].[MOD_M_FA_SURVEY_TB_PROC]
(
  @SURVEY_ID       INT             -- 등록번호
, @MANAGE_AREA     TINYINT         -- 관리지역
, @MANAGE_NM       VARCHAR(20)     -- 담당자
, @TITLE           VARCHAR(200)    -- 제목
, @JOIN_DIV        CHAR(1)         -- 참여대상(N:비회원, Y:회원)
, @START_DT        DATETIME        -- 설문기간시작

, @END_DT          DATETIME        -- 설문기간끝
, @PRIZE_YN        CHAR(1)         -- 경품유무(N:없음, Y:있음)
, @PRIZE_CONTS     VARCHAR(1000)   -- 경품내용
, @PRIZE_IMG       VARCHAR(200)    -- 경품이미지
, @PRIZE_DT        DATETIME        -- 당첨자발표날짜

, @GIVE_DT         DATETIME        -- 경품발송날짜
, @OBJECTIVE_CNT   TINYINT         -- 객관식수
, @SUBJECTIVE_CNT  TINYINT         -- 주관식수
, @MULTIPLE_CNT    TINYINT         -- 멀티선택수
, @PROGRESS_DIV    CHAR(1)         -- 진행구분

, @REG_ID          VARCHAR(30)     -- 등록자ID
, @REG_NM          VARCHAR(20)     -- 등록자이름
)
AS
SET NOCOUNT ON

DECLARE @END_DT_M			VARCHAR(23)

SET @END_DT_M = @END_DT + ' 23:59:59.000'

UPDATE FA_SURVEY_TB SET
  MANAGE_AREA    = @MANAGE_AREA
, MANAGE_NM      = @MANAGE_NM
, TITLE          = @TITLE
, JOIN_DIV       = @JOIN_DIV
, START_DT       = @START_DT

, END_DT         = @END_DT_M
, PRIZE_YN       = @PRIZE_YN
, PRIZE_CONTS    = @PRIZE_CONTS
, PRIZE_IMG      = @PRIZE_IMG
, PRIZE_DT       = @PRIZE_DT

, GIVE_DT        = @GIVE_DT
, OBJECTIVE_CNT  = @OBJECTIVE_CNT
, SUBJECTIVE_CNT = @SUBJECTIVE_CNT
, MULTIPLE_CNT   = @MULTIPLE_CNT
, PROGRESS_DIV   = @PROGRESS_DIV

, REG_ID         = @REG_ID
, REG_NM         = @REG_NM
, REG_DT         = GETDATE()
 WHERE SURVEY_ID = @SURVEY_ID

IF @@ERROR <> 0
BEGIN
	RETURN (-1)

END

RETURN 1

GO
/****** Object:  StoredProcedure [dbo].[MOD_M_FA_SURVEY_TB_YN_SCHEDULE]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	:	MOD_M_FA_SURVEY_TB_YN_SCHEDULE
 설명	:	이벤트 관련 스케줄
==============================================================================*/
CREATE PROC [dbo].[MOD_M_FA_SURVEY_TB_YN_SCHEDULE]

AS
	SET NOCOUNT ON
-- 기간에 맞춰 진행대기 -> 진행중으로 바꾸기
UPDATE FA_SURVEY_TB SET
  PROGRESS_DIV = 'Y'
 WHERE START_DT <=GETDATE()
   AND PROGRESS_DIV = 'P'

-- 기간에 맞춰 진행대기, 진행중 -> 종료로 바꾸기
UPDATE FA_SURVEY_TB SET
  PROGRESS_DIV = 'N'
 WHERE END_DT <= GETDATE()
   AND (PROGRESS_DIV = 'P' OR PROGRESS_DIV = 'Y')

GO
/****** Object:  StoredProcedure [dbo].[MOD_M_LOCALEVENTCODE_SORT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 컨텐츠관리 > 지역이벤트 카테고리 가져오기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2010-10-18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : exec DBO.MOD_M_LOCALEVENTCODE_SORT_PROC
 *************************************************************************************/
CREATE PROC [dbo].[MOD_M_LOCALEVENTCODE_SORT_PROC]
    @BRANCH_CD     INT,
    @ORDER         INT,
    @BOARDCODE     INT
AS
    SET NOCOUNT ON

    UPDATE DBO.BD_LOCALEVENTCODE_TB
    SET
        ORDERNO = @ORDER
    WHERE
        BRANCH_CD = @BRANCH_CD AND
        BOARDCODE = @BOARDCODE

GO
/****** Object:  StoredProcedure [dbo].[MOD_M_PLUS_CATEGORY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 벼룩시장플러스 개편 - 카테고리 수정
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/07/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC	[dbo].[MOD_M_PLUS_CATEGORY_PROC]
	@LCODE					SMALLINT,
	@MCODE					SMALLINT,

	@CATEGORYNAME		VARCHAR(100),
	@DESCRIPTION		VARCHAR(200),
	@DISFLAG				TINYINT,

	@IRESULT	INT=0 OUTPUT
AS

BEGIN TRAN


	IF @MCODE = 0 	--# 대분류 수정이라면
		BEGIN

			UPDATE DBO.NESSAYCODE
			SET
				LNAME 			= @CATEGORYNAME,
				DESCRIPTION = @DESCRIPTION,
				DISFLAG 		= @DISFLAG
			WHERE
				LCODE = @LCODE AND
				MCODE = @MCODE

			--하위분류 카테고리명 수정
			UPDATE DBO.NESSAYCODE
			SET
				LNAME 			= @CATEGORYNAME
			WHERE
				LCODE = @LCODE AND
				MCODE <> 0

			If @DISFLAG=0	--# 대분류 미사용이면 하위분류 모두 미사용처리
				BEGIN
					UPDATE DBO.NESSAYCODE
					SET
						LNAME 			= @CATEGORYNAME,
						DESCRIPTION = @DESCRIPTION,
						DISFLAG 		= 0
					WHERE
						LCODE = @LCODE AND
						MCODE <> 0
				END

			IF @@ERROR>1
				BEGIN
					SET @IRESULT = -1
					ROLLBACK TRAN
					RETURN
				END
			ELSE
				BEGIN
					SET @IRESULT = 1
					COMMIT TRAN
					RETURN
				END

		END
	ELSE --# 중분류 수정이라면
		BEGIN

			UPDATE DBO.NESSAYCODE
			SET
				MNAME 			= @CATEGORYNAME,
				DESCRIPTION = @DESCRIPTION,
				DISFLAG 		= @DISFLAG
			WHERE
				LCODE = @LCODE AND
				MCODE = @MCODE

			IF @@ROWCOUNT>1 OR @@ERROR>1
				BEGIN
					SET @IRESULT = -1
					ROLLBACK TRAN
					RETURN
				END
			ELSE
				BEGIN
					SET @IRESULT = 1
					COMMIT TRAN
					RETURN
				END
		END

GO
/****** Object:  StoredProcedure [dbo].[pLineToHomeTownCovt_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCedure [dbo].[pLineToHomeTownCovt_DelAN]
as

------------------------------------------------------------------------------------------------------
--    고향길 함께가기 신문자료 반영후 자료 재정리
------------------------------------------------------------------------------------------------------

update HomeTown
set content = ' ▶ ' + replace(replace(replace(replace(replace(content, char(9), ''),char(10), ''), char(13), ''), '·', ''), '^', '')
where  flag = 'P'

update HomeTown
set content = left(content, patindex('%출발장소%', content) - 1) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%출발장소%', content) + 1)
where  flag = 'P'
and patindex('%출발장소%', content) > 0

update HomeTown
set content = left(content, patindex('%출발:%', content) - 1) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%출발:%', content) + 1)
where  flag = 'P'
and patindex('%출발:%', content) > 0

update HomeTown
set content = left(content, patindex('%희망인원%', content) - 1) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%희망인원%', content) + 1)
where  flag = 'P'
and patindex('%희망인원%', content) > 0

update HomeTown
set content = left(content, patindex('%여유좌석%', content) - 1) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%여유좌석%', content) + 1)
where  flag = 'P'
and patindex('%여유좌석%', content) > 0

update HomeTown
set content = left(content, patindex('%출발일시%', content) - 1 ) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%출발일시%', content) + 1)
where  flag = 'P'
and patindex('%출발일시%', content) > 0

update HomeTown
set content = left(content, patindex('%연락처%', content) - 1) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%연락처%', content) + 1)
where  flag = 'P'
and patindex('%연락처%', content) > 0

update HomeTown
set content = left(content, patindex('%출 발 지%', content) - 1) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%출 발 지%', content) + 1)
where  flag = 'P'
and patindex('%출 발 지%', content) > 0

update HomeTown
set content = left(content, patindex('%여유자석%', content) - 1) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%여유자석%', content) + 1)
where  flag = 'P'
and patindex('%여유자석%', content) > 0

update HomeTown
set content = left(content, patindex('%출발일:%', content) - 1) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%출발일:%', content) + 1)
where  flag = 'P'
and patindex('%출발일:%', content) > 0


update HomeTown
set content = left(content, patindex('%출발지:%', content) - 1) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%출발지:%', content) + 1)
where  flag = 'P'
and patindex('%출발지:%', content) > 0



update HomeTown
set content = left(content, patindex('%목적지:%', content) - 1) + char(10) + ' ▶ ' + right(content, len(content) - patindex('%목적지:%', content) + 1)
where  flag = 'P'
and patindex('%목적지:%', content) > 0


update HomeTown
set content = left(content, patindex('%고향길 함께 %', content) - 1) + char(10) + '    ' + right(content, len(content) - patindex('%고향길 함께 %', content) + 1)
where  flag = 'P'
and patindex('%고향길 함께 %', content) > 0

GO
/****** Object:  StoredProcedure [dbo].[Proc_YHNews_Insert_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_YHNews_Insert_DelAN]
(
	@strArticleNo 		varchar(15),
	@strStyle 				varchar(15),
	@strBodySize 		int,
	@strDeliCd 			varchar(30),
	@strMoneyCd 		varchar(30),
	@strSendDate 		varchar(10),
	@strSendTime 		varchar(10),
	@strDeliDate 			varchar(10),
	@strDeliTime 		varchar(10),
	@strIssuCd1 			varchar(30),
	@strIssuCd2 			varchar(30),
	@strIssuCd3 			varchar(30),
	@strIssuCd4 			varchar(30),
	@strIssuCd5 			varchar(30),
	@strIssuMatch1 	varchar(10),
	@strIssuMatch2 	varchar(10),
	@strIssuMatch3 	varchar(10),
	@strIssuMatch4 	varchar(10),
	@strIssuMatch5 	varchar(10),
	@strIssuDesc1 	varchar(100),
	@strIssuDesc2 	varchar(100),
	@strIssuDesc3 	varchar(100),
	@strIssuDesc4 	varchar(100),
	@strIssuDesc5 	varchar(100),
	@strTopIssu1 		varchar(20),
	@strTopIssu2 		varchar(20),
	@strResendFlag 	char(1),
	@strArticleFlag 		char(1),
	@strDeleteFlag 		char(15),
	@strTitle 				nvarchar(200),
	@strBody 				text
)

As

DECLARE @RsCnt int
DECLARE @RsError	varchar(255)

SET		@RsError = ''
SET		@RsCnt = 0


SELECT @RsCnt = Count(*) FROM YHNews
WHERE 기사번호 = @strArticleNo

IF @RsCnt > 0
	BEGIN
		SET @RsError = '동일한 기사번호가 이미 존재합니다.'
		GOTO LAST_PROC
	END

BEGIN TRAN

		INSERT INTO YHNews (기사번호, 기사종류, 본문길이, 배부처, 상품명, 송고날짜, 송고시간, 배부날짜, 배부시간,
												분류1, 분류2, 분류3, 분류4, 분류5, 코드1, 코드2, 코드3, 코드4, 코드5,
												설명1, 설명2, 설명3, 설명4, 설명5, 분야1, 분야2, 재송구분, 기사구분, 삭제유무,
												제목, 본문, Cate_Flag)
		VALUES (

			@strArticleNo,
			@strStyle ,
			@strBodySize,
			@strDeliCd,
			@strMoneyCd,
			@strSendDate,
			@strSendTime,
			@strDeliDate,
			@strDeliTime,
			@strIssuCd1,
			@strIssuCd2,
			@strIssuCd3,
			@strIssuCd4,
			@strIssuCd5,
			@strIssuMatch1,
			@strIssuMatch2,
			@strIssuMatch3,
			@strIssuMatch4,
			@strIssuMatch5,
			@strIssuDesc1,
			@strIssuDesc2,
			@strIssuDesc3,
			@strIssuDesc4,
			@strIssuDesc5,
			@strTopIssu1,
			@strTopIssu2,
			@strResendFlag,
			@strArticleFlag,
			@strDeleteFlag,
			@strTitle,
			@strBody,
			dbo.Fun_YHNews(@strTitle + Convert(varchar(8000),@strBody))
		)

IF @@ERROR = 0
	BEGIN
		COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END


LAST_PROC:
PRINT(@RsError)
return(0)

GO
/****** Object:  StoredProcedure [dbo].[Proc_YHNews_Update_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_YHNews_Update_DelAN]
(
	@strArticleNo 		varchar(15),
	@strStyle 				varchar(15),
	@strBodySize 		int,
	@strDeliCd 			varchar(30),
	@strMoneyCd 		varchar(30),
	@strSendDate 		varchar(10),
	@strSendTime 		varchar(10),
	@strDeliDate 			varchar(10),
	@strDeliTime 		varchar(10),
	@strIssuCd1 			varchar(30),
	@strIssuCd2 			varchar(30),
	@strIssuCd3 			varchar(30),
	@strIssuCd4 			varchar(30),
	@strIssuCd5 			varchar(30),
	@strIssuMatch1 	varchar(10),
	@strIssuMatch2 	varchar(10),
	@strIssuMatch3 	varchar(10),
	@strIssuMatch4 	varchar(10),
	@strIssuMatch5 	varchar(10),
	@strIssuDesc1 	varchar(100),
	@strIssuDesc2 	varchar(100),
	@strIssuDesc3 	varchar(100),
	@strIssuDesc4 	varchar(100),
	@strIssuDesc5 	varchar(100),
	@strTopIssu1 		varchar(20),
	@strTopIssu2 		varchar(20),
	@strResendFlag 	char(1),
	@strArticleFlag 		char(1),
	@strDeleteFlag 		char(15),
	@strTitle 				nvarchar(200),
	@strBody 				text
)

As

BEGIN TRAN
		UPDATE YHNews
		SET 기사종류 = @strStyle,
				본문길이 = @strBodySize,
				배부처		= @strDeliCd,
				상품명		= @strMoneyCd,
				송고날짜	= @strSendDate,
				송고시간	= @strSendTime,
				배부날짜	= @strDeliDate,
				배부시간	= @strDeliTime,
				분류1		= @strIssuCd1,
				분류2		= @strIssuCd2,
				분류3		= @strIssuCd3,
				분류4		= @strIssuCd4,
				분류5		= @strIssuCd5,
				코드1		= @strIssuMatch1,
				코드2		= @strIssuMatch2,
				코드3		= @strIssuMatch3,
				코드4		= @strIssuMatch4,
				코드5		= @strIssuMatch5,
				설명1		= @strIssuDesc1,
				설명2		= @strIssuDesc2,
				설명3		= @strIssuDesc3 ,
				설명4		= @strIssuDesc4,
				설명5		= @strIssuDesc5,
				분야1		= @strTopIssu1,
				분야2		= @strTopIssu2,
				재송구분 = @strResendFlag,
				기사구분 = @strArticleFlag,
				삭제유무 = @strDeleteFlag,
				제목			= @strTitle,
				본문			= @strBody,
				Cate_Flag = dbo.Fun_YHNews(@strTitle + Convert(varchar(8000),@strBody))

		WHERE 기사번호 = @strArticleNo

IF @@ERROR = 0
	BEGIN
		COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END

GO
/****** Object:  StoredProcedure [dbo].[proc_YHNewsAreaList_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/**************************************************************************************************************
	설명	: yhnews 리스팅
	제작자	: 조성훈
	제작일	: 2004-09-09
	셜명	:
		NL : 뉴스 리스트
		NV : 뉴스 보기
		NS : 검색페이지 리스트
		MF : 관리자 파일 만들기 페이지

		PageSize	 : 페이지당 게시물 개수
		Page		 : 페이지값

	관련페이지 : YHNews/AreaList_sub.asp, YHNews/ViewList_sub.asp , Mag/YHNews/MakeFile.asp
EXECUTE proc_YHNewsAreaList 'NV','외신','092005011906700','20050119','150241','NULL','NULL',Null,Null,'NULL'
**************************************************************************************************************/
CREATE PROCEDURE [dbo].[proc_YHNewsAreaList_DelAN]
	@Gubun		CHAR(2),		--리스트 or 상세보기
	@Code			VARCHAR(10)	= NULL,	--분야별 경제,사회,정치,생활/문화,스포츠....
	@ArtId			CHAR(15)		= NULL,	--기사송고번호
	@SDate		CHAR(8)		= NULL,	--송고날짜
	@STime		CHAR(6)		= NULL,	--송고시간
	@Subject		VARCHAR(200)	= NULL,	--제목
	@Contents		TEXT		= NULL,	--내용
	@Page			INT		= NULL,	--현재 페이지
	@PageSize		INT		= NULL,	--한화면에 뿌려질 로우
	@SearchWord		VARCHAR(50)	= NULL	--검색어

AS

	IF 		@Gubun='NL' GOTO NewsList
	ELSE IF	@Gubun='NS' GOTO NewsSearch
	ELSE IF	@Gubun='NV' GOTO NewsView
	ELSE IF	@Gubun='MF' GOTO MakeFile

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 변수 선언 @Query(쿼리 스트링) @Where(WHERE 조건절 쿼리 스트링)  @ReadCount(조회수 +1증가 )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	DECLARE @Query VARCHAR(6000),@Where VARCHAR(4000),@ReadCount INT

--------------------------------------------------------------------------------------------------------------------
--각 분야별 리스팅
--------------------------------------------------------------------------------------------------------------------

MakeFile:
	IF @Code='A' or @Code='B' or @Code='C'  --  취업/알바, 부동산, 자동차가 오른쪽 메뉴에 게재되면 리스트에 뿌려지도록 업데이트
		BEGIN
			UPDATE YHNews Set NLCode = @Code  WHERE 기사번호 = @ArtId;
--			SELECT @Query ='update YHNews Set NLCode=''' + @Code + ''' Where 기사번호 ='''+ @ArtId + '''' + ';'
		END

		BEGIN

			SELECT @Query ='select 송고날짜, 송고시간, 분야1, 제목, 본문 from YHNews with (NoLock) where 기사번호='''+ @ArtId + ''''
		END

	print @Query
	EXECUTE (@Query)
	RETURN

NewsList:
	IF @Code='A'  or @Code='B' or @Code='C'  --취업/알바, 부동산, 자동차 의 키워드로 검색된 리스트 이면...
		BEGIN
			SELECT @Where =' WHERE NLCode= ''' +@Code +''''
		END

	ELSE
		BEGIN
			SELECT @Where =' WHERE 분야1= ''' +@Code +''''
		END

	SELECT @Query='select count(기사번호) as cnt from YHNews with (NoLock) '+ @Where + ';'+
			'select top ' +convert(varchar(10), @page*@pagesize)+' 기사번호, 송고날짜, 송고시간, 제목,  Convert(varchar(8000),본문) as 본문' +
			' FROM YHNews with (NoLock) ' + @Where +'  ORDER BY 송고날짜 DESC, 송고시간 DESC'

	print @where
	print @query
	EXECUTE(@Query)
	RETURN

NewsSearch:
	IF @Code=''  --분야별 검색이 아니라 전체 검색이면...
		BEGIN
			--SELECT @Where =' WHERE  (제목 like ''%' +@SearchWord+'%'' or 본문 like ''%' + @SearchWord+'%'') '
			SELECT @Where =' WHERE  (Contains(본문, ''"' + @SearchWord + '"'') Or Contains(제목,''"' + @SearchWord + '"'')) '
		END
	ELSE
		BEGIN
			--SELECT @Where =' WHERE 분야1= ''' +@Code +''' and (제목 like ''%' +@SearchWord+'%'' or 본문 like ''%' + @SearchWord+'%'') '
			SELECT @Where =' WHERE  (Contains(본문, ''"' + @SearchWord + '"'') Or Contains(제목,''"' + @SearchWord + '"'')) AND  분야1 = ''' + @Code +'''  '
		END

	SELECT @Query='select count(기사번호) as cnt from YHNews with (NoLock) '+ @Where + ';'+
			'select top ' +convert(varchar(10), @page*@pagesize)+' 기사번호, 송고날짜, 송고시간, 제목,  Convert(varchar(8000),본문) as 본문' +
			' FROM YHNews with (NoLock) ' + @Where +'  ORDER BY 송고날짜 DESC, 송고시간 DESC'

	print @where
	print @query
	EXECUTE(@Query)
	RETURN

NewsView:
	IF @Code='A'  or @Code='B' or @Code='C'  --취업/알바, 부동산, 자동차 의 키워드로 검색된 리스트 이면...
		BEGIN
			SELECT @Where =' WHERE NLCode= ''' +@Code +''''
		END

	ELSE
		BEGIN
			SELECT @Where =' WHERE 분야1= ''' +@Code +''''
		END

	UPDATE YHNews Set 조회수 = 조회수 + 1 WHERE 기사번호 = @ArtId;


	--첫번째 쿼리	:  상세보기에 보여질 내용
	--두번째 쿼리	: 상위글 3개
	--두번째 쿼리	: 하위글  3개

	SELECT @Query = 'select 송고날짜, 송고시간, 제목, 본문 ' +
			' FROM YHNews with (NoLock)  where 기사번호 = '''+ @ArtId + ''' ORDER BY 송고날짜 DESC, 송고시간 DESC' + ';' +

			'select 기사번호, 송고날짜, 송고시간, 제목  from YHNews with (NoLock) '+@Where +' and 기사번호 in (select top 2 기사번호  from YHNews with (NoLock) '+
			@where +' and  송고날짜+송고시간 >''' + @SDate + @STime +''' order by 송고날짜 asc, 송고시간 asc) ORDER BY 송고날짜 DESC, 송고시간 DESC ' +';' +

			'select 기사번호, 송고날짜, 송고시간, 제목  from YHNews with (NoLock) '+@where+' and 기사번호 in (select top 2 기사번호  from YHNews with (NoLock) '+
			@where +' and  송고날짜 + 송고시간 <''' + @SDate + @STime +''' order by 송고날짜 desc, 송고시간 desc) ORDER BY 송고날짜 DESC, 송고시간 DESC'


	print @query
	print @query
	EXECUTE(@Query)
	RETURN


--------------------------------------------------------------------------------------------------------------------
------------			 	COMMIT & ROLLBACK                                              ------------
--------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[proc_YHNewsMain_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************************************
	설명	: 연합뉴스 메인 페이지 리스팅
	제작자	: 조성훈
	제작일	: 2004-09-07
	셜명	:
*******************************************************************************************************/
CREATE PROCEDURE [dbo].[proc_YHNewsMain_DelAN]

	@main_flag	char(1),
	@SearchCat	varchar(10),
	@SearchText	varchar(50)

	AS

	DECLARE @Query 	VARCHAR(1000)
	DECLARE @QryWhere	VARCHAR(500)


	-- ######### 검색조건에 따른 WHERE 문 만들기
	IF @SearchCat <>''
		BEGIN
		SET @QryWhere = ' WHERE main_flag='+Convert(varchar(2),@main_flag)+' AND 분야='+@SearchCat+' AND 제목='+@SearchText
		END
	Else
		BEGIN
		SET @QryWhere =' WHERE main_flag=''' + @main_flag +''''
		END

	SET @Query = 'SELECT 기사번호, 송고날짜, 송고시간, 제목,  Convert(varchar(8000),본문) as 본문, 분야1 FROM YHNews (NoLock, ReadUnCommitted)  '+@QryWhere

--	print @query
--	EXECUTE sp_executesql @Query
	EXECUTE (@Query)

GO
/****** Object:  StoredProcedure [dbo].[procCusCenter]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: FindAll / Paper 고객센터
제작자		: 이혜민
제작일		: 2004-10-04
셜명		: 페이징,검색

Page		: 페이지
PageSize	: 페이지당 게시물 개수
SiteGbn		: 사이트구분
QueryType2	: 접수유형
DateGbn	: 접수일/처리일
StartDate	: 접수일검색(시작일)
EndDate 	: 접수일검색(종료일)
*************************************************************************************/
CREATE PROCEDURE [dbo].[procCusCenter] (
@PAGE			int,
@PAGESIZE		int,
--@SITEGBN		as varchar(30),
@QUERYTYPE2		as varchar(30),
@REPLYFLAG		as varchar(1),
@DATEGBN		as varchar(10),
@STARTDATE		as varchar(12),
@ENDDATE		as varchar(12),
@LOCALSITE		int
)
AS


-- 사이트 구분값
--	DECLARE @SqlSiteGbn varchar(100)
--	IF @SITEGBN =''
--		BEGIN
--			SET 	@SqlSiteGbn = ''
--		END
--	ELSE
--		BEGIN
--			SET 	@SqlSiteGbn = 'SiteGbn =  '''+ @SITEGBN + ''' '
--		END


-- 검색기간
	DECLARE @SqlStartDate	varchar(200)
	IF @STARTDATE = ''
		BEGIN
			SET 	@SqlStartDate= ''
		END
	ELSE
		BEGIN
			SET	@SqlStartDate= ' Convert(varchar(10),' + @DATEGBN + ',120) >= ''' +@STARTDATE + ''''
		END

	DECLARE @SqlEndDate	varchar(200)
	IF @ENDDATE=''
		BEGIN
			SET	@SqlEndDate=''
		END
	ELSE
		BEGIN
			SET 	@SqlEndDate= ' AND Convert(varchar(10),' + @DATEGBN + ',120) <= ''' +@ENDDATE+ ''''
		END

-- 질문유형
	DECLARE @SqlQueryType2 varchar(200)
	IF @QUERYTYPE2 =''
		BEGIN
			SET 	@SqlQueryType2= ''
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType2= ' AND QueryType2 = ''' + @QUERYTYPE2 + ''' '
		END

-- 회신여부
	DECLARE @SqlReplyFlag varchar(80)
	IF @REPLYFLAG =''
		BEGIN
			SET 	@SqlReplyFlag= ''
		END
	ELSE
		BEGIN
			SET 	@SqlReplyFlag= ' AND Sended = ''' + @REPLYFLAG + ''' '
		END


-- 전국 관리자의 경우 전체 또는 각 지역별 리스트 출력위해
-- 전국 관리자가 아닐경우 해당 지역리스트 출력
	DECLARE @SqlMagAll varchar(80)
	IF @LOCALSITE =''
		BEGIN
			SET 	@SqlMagAll= ''
		END
	ELSE
		BEGIN
			SET 	@SqlMagAll= ' AND LocalSite =' + CONVERT(varchar(10),@LOCALSITE) + ' '
		END


--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlStartDate + @SqlEndDate + @SqlQueryType2 + @SqlReplyFlag + @SqlMagAll
		END

DECLARE @SQL varchar(2000)
SET     @SQL =

	'SELECT COUNT(serial) FROM CusCenter WHERE ' + @SqlAll + ' ; ' +
	'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) +
	' Serial, CONVERT(char(10) , RegDate , 120) as  RegDate , UserID, UserName, QueryType2, Title, Sended, SendDate, MoveSite, MoveLocal, MoveDate ' +
	' FROM  CusCenter WHERE  '+ @SqlAll + ' Order by Serial DESC, RegDate DESC '


print(@SQL)
EXEC(@SQL)

GO
/****** Object:  StoredProcedure [dbo].[procEventResult_1008_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
--작성자 김준범
--2002-11-07
--가을 이벤트 당첨자 추출

CREATE PROCEDURE [dbo].[procEventResult_1008_DelAN]

AS


TRUNCATE TABLE OpenEvent2
TRUNCATE TABLE OpenEvent3
TRUNCATE TABLE OpenEvent4
TRUNCATE TABLE OpenEvent5
TRUNCATE TABLE OpenEvent6

DECLARE @TotCountSql	varchar(200)		--총 참여자의 20%
DECLARE @TotCountSql2	varchar(200)		--20%중 랜덤 1053
DECLARE @TotCountSql3	varchar(200)		--1053중 랜덤하게 1000
DECLARE @TotCountSql4	varchar(200)		--1053중 1000명을 제외한 30
DECLARE @TotCountSql5	varchar(200)		--1053중 1000명과 30명을 제외한 23명

DECLARE @TotCount 		int			-- 총 카운트
DECLARE @Cnt1		int			-- 1등
DECLARE @Cnt2		int			-- 2등
DECLARE @Cnt3		int			-- 3등

SET @Cnt1 = 23
SET @Cnt2 = 30
SET @Cnt3 = 1000

SELECT @TotCount = Count(*) * 0.2  FROM OpenEvent	-- 20%가 몇 건인지 계산

IF @TotCount > 0
	BEGIN
	SET @TotCountSql = 'SELECT TOP ' + Convert(varchar(10),@TotCount) + ' * FROM OpenEvent ORDER BY NewID()'
	SET @TotCountSql = ' INSERT INTO OpenEvent2 ' + @TotCountSql
	END

IF (@Cnt3 > 0 ) AND (@Cnt2 > 0) AND (@Cnt1>0)
	BEGIN
	SET @TotCountSql2 = 'SELECT TOP ' + Convert(varchar(10),@Cnt1 + @Cnt2 + @Cnt3) + ' * FROM OpenEvent2 ORDER BY NewID()'
	SET @TotCountSql2 = ' INSERT INTO OpenEvent3 ' + @TotCountSql2


	SET @TotCountSql3 = 'SELECT TOP ' + Convert(varchar(10),@Cnt3) + ' * FROM OpenEvent3 ORDER BY NewID()'
	SET @TotCountSql3 = ' INSERT INTO OpenEvent4 ' + @TotCountSql3


	SET @TotCountSql4 = 'SELECT TOP ' + Convert(varchar(10),@Cnt2) + ' * FROM OpenEvent3  ' +
			      'WHERE LotteryNum Not In(Select LotteryNum From OpenEvent4)  ORDER BY NewID() '
	SET @TotCountSql4 = 'INSERT INTO OpenEvent5 ' + @TotCountSql4


	SET @TotCountSql5 = 'SELECT  * FROM OpenEvent3 ' +
			      'WHERE LotteryNum Not In(Select LotteryNum From OpenEvent4) ' +
			      'AND  LotteryNum Not In(Select LotteryNum From OpenEvent5)'
	SET @TotCountSql5 = ' INSERT INTO OpenEvent6 ' + @TotCountSql5

	END


EXEC(@TotCountSql + @TotCountSql2 + @TotCountSql3 + @TotCountSql4 + @TotCountSql5)

GO
/****** Object:  StoredProcedure [dbo].[procKnowAAList_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 지식검색-질문 가져오기(새로운, 해결된, 미해결된)
제작자		:
제작일		: 2004-11-1
셜명		: 페이징,리스트

ListGbn		: 'C' 카운트, 'L' 리스트
Page		: 페이지
PageSize	: 페이지당 게시물 개수
AAGbn		: 구분 (알짜/엉뚱생뚱)
SearchGbn	: 검색구분(Title,Content,UserID)
SearchString	: 검색내용
*************************************************************************************/
CREATE PROCEDURE [dbo].[procKnowAAList_DelAN] (
@ListGbn	Char(1),
@PAGE		int,
@PAGESIZE	int,
@AAGbn	Char(1),
@SearchGbn	Varchar(10),
@SearchString	Varchar(100)
)
AS

-- 카운트와 리스트 구분
	DECLARE @SqlTopLine varchar(200)
	IF @ListGbn = 'C'
		BEGIN
			SET 	@SqlTopLine= ' Count(*) '
		END
	Else
		BEGIN
			SET 	@SqlTopLine = ' TOP ' + CONVERT(varchar(10), + @PAGE*@PAGESIZE ) + ' A.MainFlag, V.Adid, V.Gubun, V.CodeNm1, V.CodeNm2, V.Title, V.Content, V.UserID, V.UserNm, V.RegDate, V.viewCnt '
		END

-- Order By
	DECLARE @OrderBy varchar(100)
	IF @ListGbn = 'C'
		BEGIN
			SET 	@OrderBy= ''
		END
	Else
		BEGIN
			SET 	@OrderBy = ' Order By A.MainFlag DESC, V.RegDate DESC '
		END

-- 검색내용
	DECLARE @SqlQueryType varchar(1000)
	IF @SearchString = ''
		BEGIN
			SET 	@SqlQueryType= ''
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType= ' And V.' + @SearchGbn + ' Like ''%' + @SearchString + '%'''
		END

DECLARE @SQL varchar(2000)
	SET     @SQL =
		'SELECT ' + @SqlTopLine +
		' FROM vw_MagQueKnow V, k_AljjaAung A ' +
		' Where V.Gubun = A.ListGbn AND V.Adid = A.Qk_Adid AND A.DelFlag = 0 ' +
		' AND A.AA_Gbn = ''' + @AAGbn + '''' + @SqlQueryType + @OrderBy

print(@SQL)
EXEC(@SQL)

GO
/****** Object:  StoredProcedure [dbo].[procKnowContent_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/**************************************************************************************************************
	설명	 : 지식검색-질문,답변,의견 가져오기
	제작자 :
	제작일 : 2003-11-24
	설명	 :
	 ProcessGubun : 이 파라메터의 구분을 통해 각 구문을 실행하게 된다.
	QUE		: 질문
	ANS		: 답변
	OPI		: 의견
	Adid		: 질문번호
	KHW		: 노하우
**************************************************************************************************************/
CREATE PROCEDURE [dbo].[procKnowContent_DelAN]
	@ProcessGubun	                  CHAR(3),
	@Adid                                               INT		--질문번호

AS

	IF @ProcessGubun = 'QUE' GOTO QuestionSelect
	IF @ProcessGubun = 'ANS' GOTO AnswerSelect
	IF @ProcessGubun = 'OPI' GOTO OpinionSelect
	IF @ProcessGubun = 'KHW' GOTO KnowhowSelect
	IF @ProcessGubun = 'KOP' GOTO KhwOpinionSelect	-- 노하우 의견
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 변수 선언
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
	BEGIN TRANSACTION

----------------------------------------------------------------------------------------------------------------------------------------------------
-- QUE	:	 k_Question(질문) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
QuestionSelect:
		BEGIN
			SELECT a.Adid, Code1, Code2,
				Case When ISNULL(a.ModDate,'') = '' or a.ModDate = '' Then
					Case When a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.RegDate) > Getdate() Then 'New'
						When (a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.RegDate) < Getdate() OR a.ChoiceSerial = -99) Then 'N'
						When a.ChoiceSerial not in (0,-99) Then 'Y' Else '' End
				Else
					Case When a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.ModDate) > Getdate() Then 'New'
						When (a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.ModDate) < Getdate() OR a.ChoiceSerial = -99) Then 'N'
						When a.ChoiceSerial not in (0,-99) Then 'Y' Else '' End
				End as ReChk,
				a.UserID, a.UserNm, b.TotalPoint, a.viewCnt, (Select Count(*) From k_Answer Where queAdid = a.Adid And DelFlag = 0) As ReplyCnt,
				a.ChoiceSerial, a.Title, a.TagYn,
				Case When isnull(a.ModDate,'') = '' Then
					DateDiff(dd,DateAdd(dd,a.ReplyTerm,a.RegDate),Getdate())
				Else
					DateDiff(dd,DateAdd(dd,a.ReplyTerm,a.ModDate),Getdate())
				End as Termday, a.ReplyTerm, a.MailYn,
				a.RegDate, a.ModDate, a.content, a.DelFlag
			FROM k_Question a with (Nolock), k_Point b with (NoLock)
			Where a.UserID *= b.UserID
				And a.Adid = @Adid
		END
	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
-- ANS	:	 k_Answer(답변) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
AnswerSelect:
		BEGIN
			SELECT Serial, queAdid, UserID, UserNm, Title, TagYn,
				Content, Origin, RegDate, ModDate, ChoiceYN, DelFlag
			FROM k_Answer with (NoLock)
			Where queAdid = @Adid
			Order By RegDate DESC
		END
	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
-- OPI	:	 k_Opinion(의견) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
OpinionSelect:
		BEGIN
			Select Serial, Gubun, UserID, UserNm, Title, Content, RegDate, DelFlag
			From k_Opinion with (NoLock)
			Where queAdid = @Adid
			Order By RegDate DESC
		END
	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
-- KOP	:	 노하우 k_Opinion(의견) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
KhwOpinionSelect:
		BEGIN
			Select Serial, Gubun, UserID, UserNm, Title, Content, RegDate, DelFlag
			From k_Opinion with (NoLock)
			Where khwAdid = @Adid
			Order By RegDate DESC
		END
	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
-- Knowhow	:	 k_Knowhow(질문) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
KnowhowSelect:
		BEGIN
			SELECT a.Adid, Code1, Code2,
				a.UserID, a.UserNm, b.TotalPoint, a.viewCnt,
				a.Title, a.TagYn, a.RegDate, a.ModDate, a.content, a.DelFlag
			FROM k_Knowhow a with (NoLock), k_Point b with (NoLock)
			Where a.UserID *= b.UserID
				And a.Adid = @Adid
		END
	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
------------			 	COMMIT & ROLLBACK                                              ------------
----------------------------------------------------------------------------------------------------------------------------------------------------
	IF @@ERROR = 0
	BEGIN
    		COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
	END
END

GO
/****** Object:  StoredProcedure [dbo].[procKnowhowList_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 생활지식-노하우
제작자		:
제작일		: 2004-10-21
셜명		: 페이징,리스트

Page		: 페이지
PageSize	: 페이지당 게시물 개수
Cate1Gbn	: 카테고리 대분류구분(100:부동산, 110:취업, 120:자동차, 130:맛있는집, 140:중고장터)
Cate2Gbn	: 카테고리 중분류구분
QueLocation	: 질문리스트 위치(메인:ML/메인전체:MA/카테고리별메인:CL/카테고리별전체:CA)
SearchGbn	: 검색구분(Title,Content,UserID)
SearchString	: 검색내용
*************************************************************************************/
CREATE PROCEDURE [dbo].[procKnowhowList_DelAN] (
@PAGE		int,
@PAGESIZE	int,
@Cate1Gbn	varchar(3),
@Cate2Gbn	varchar(6),
@QueLocation	as varchar(2),
@SearchGbn	varchar(10),
@SearchString	varchar(100)
)
AS


-- 페이징과 메인리스트 구분
	DECLARE @SqlTopLine varchar(50)
		BEGIN
			SET 	@SqlTopLine= ' TOP ' + CONVERT(varchar(10), + @PAGE*@PAGESIZE )
		END

-- 질문리스트
	DECLARE @SqlQueryLocation varchar(200)
	IF @QueLocation ='ML'
		BEGIN
			SET 	@SqlQueryLocation= ' b.CodeNm1, a.Title '
		END
	ELSE IF @QueLocation ='MA'
		BEGIN
			SET 	@SqlQueryLocation= ' b.CodeNm1, a.Title, a.UserID, a.ViewCnt '
		END
	ELSE IF @QueLocation ='CL'
		BEGIN
			SET 	@SqlQueryLocation= ' b.CodeNm2, a.Title, a.UserID, a.ViewCnt '
		END
	ELSE IF @QueLocation ='CA'
		BEGIN
			SET 	@SqlQueryLocation= ' b.CodeNm2, a.Title, a.UserID, a.ViewCnt '
		END
	ELSE
		BEGIN
			SET 	@SqlQueryLocation= ''
		END


-- 카테고리 대분류구분
	DECLARE @SqlQueryType1 varchar(1000)
	IF @Cate1Gbn = 0 AND @Cate2Gbn = 0
		BEGIN
			SET 	@SqlQueryType1= ''
		END
	ELSE IF @Cate1Gbn <> 0 AND @Cate2Gbn = 0
		BEGIN
			SET 	@SqlQueryType1= ' And a.Code1=' + @Cate1Gbn
		END
	ELSE IF @Cate1Gbn = 0 AND @Cate2Gbn <> 0
		BEGIN
			SET 	@SqlQueryType1= ' And a.Code2=' + @Cate2Gbn
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType1= ' And a.Code1=' + @Cate1Gbn + ' And a.Code2=' + @Cate2Gbn
		END

-- 검색내용
	DECLARE @SqlQueryType2 varchar(1000)
	IF @SearchString = ''
		BEGIN
			SET 	@SqlQueryType2= ''
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType2= ' And a.' + @SearchGbn + ' Like ''%' + @SearchString + '%'''
		END

DECLARE @SQL varchar(2000)
	SET     @SQL =
		'SELECT ' + @SqlTopLine + ' a.Adid, ' + @SqlQueryLocation + ', a.RegDate' +
		' FROM k_Knowhow a, k_Category b ' +
		' Where a.Code2 = b.Code2 And a.DelFlag=0 ' + @SqlQueryType1 + @SqlQueryType2 +
		' Order By a.RegDate DESC'

--print(@SQL)
EXEC(@SQL)

GO
/****** Object:  StoredProcedure [dbo].[procKnowhowListCount_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 생활지식-노하우
제작자		:
제작일		: 2004-10-21
셜명		: 카운트수

Cate1Gbn	: 카테고리 대분류구분(100:부동산, 110:취업, 120:자동차, 130:맛있는집, 140:중고장터)
Cate2Gbn	: 카테고리 중분류구분
SearchGbn	: 검색구분(Title,Content,UserID)
SearchString	: 검색내용
*************************************************************************************/
CREATE PROCEDURE [dbo].[procKnowhowListCount_DelAN] (
@Cate1Gbn	varchar(3),
@Cate2Gbn	varchar(6),
@SearchGbn	varchar(10),
@SearchString	varchar(100)
)
AS


-- 카테고리 대분류구분
	DECLARE @SqlQueryType1 varchar(1000)
	IF @Cate1Gbn = 0 AND @Cate2Gbn = 0
		BEGIN
			SET 	@SqlQueryType1= ''
		END
	ELSE IF @Cate1Gbn <> 0 AND @Cate2Gbn = 0
		BEGIN
			SET 	@SqlQueryType1= ' And a.Code1=' + @Cate1Gbn
		END
	ELSE IF @Cate1Gbn = 0 AND @Cate2Gbn <> 0
		BEGIN
			SET 	@SqlQueryType1= ' And a.Code2=' + @Cate2Gbn
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType1= ' And a.Code1=' + @Cate1Gbn + ' And a.Code2=' + @Cate2Gbn
		END

-- 검색내용
	DECLARE @SqlQueryType2 varchar(1000)
	IF @SearchString = ''
		BEGIN
			SET 	@SqlQueryType2= ''
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType2= ' And a.' + @SearchGbn + ' Like ''%' + @SearchString + '%'''
		END

DECLARE @SQL varchar(2000)
	SET     @SQL =
		'SELECT Count(*) ' +
		' FROM k_Knowhow a, k_Category b ' +
		' Where a.Code2 = b.Code2 And a.DelFlag=0 ' + @SqlQueryType1 + @SqlQueryType2


--print(@SQL)
EXEC(@SQL)

GO
/****** Object:  StoredProcedure [dbo].[procKnowList_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 지식검색-질문 가져오기(새로운, 해결된, 미해결된)
제작자		:
제작일		: 2003-11-28
셜명		: 페이징,리스트

Page				: 페이지
PageSize		: 페이지당 게시물 개수
Cate1Gbn		: 카테고리 대분류구분(100:부동산, 110:취업, 120:자동차, 130:맛있는집, 140:상품직거래)
Cate2Gbn		: 카테고리 중분류구분
QueGbn			: 질문구분 (새로운질문/해결된질문/미해결된질문)
QueLocation	: 질문리스트 위치(메인:ML/메인전체:MA/카테고리별메인:CL/카테고리별전체:CA)
SearchGbn	: 검색구분(Title,Content,UserID)
SearchString	: 검색내용
*************************************************************************************/
CREATE PROCEDURE [dbo].[procKnowList_DelAN] (
@PAGE		int,
@PAGESIZE	int,
@Cate1Gbn varchar(3),
@Cate2Gbn varchar(6),
@QueGbn	as varchar(3),
@QueLocation	as varchar(2),
@SearchGbn	varchar(10),
@SearchString	varchar(100)
)
AS


-- 페이징과 메인리스트 구분
	DECLARE @SqlTopLine varchar(50)
		BEGIN
			SET 	@SqlTopLine= ' TOP ' + CONVERT(varchar(10), + @PAGE*@PAGESIZE )
		END

-- 답변갯수 필드
	DECLARE @SqlReplyCnt varchar(100)
		BEGIN
			SET 	@SqlReplyCnt= ' (Select Count(*) From k_Answer Where queAdid = a.Adid And DelFlag = 0) As ReplyCnt, '
		END


-- 질문리스트
	DECLARE @SqlQueryLocation varchar(200)
	IF @QueLocation ='ML'
		BEGIN
			SET 	@SqlQueryLocation= ' b.CodeNm1, ' + @SqlReplyCnt + ' a.Title '
		END
	ELSE IF @QueLocation ='MA'
		BEGIN
			SET 	@SqlQueryLocation= ' b.CodeNm1, a.Title, a.UserID, ' + @SqlReplyCnt + ' a.ViewCnt '
		END
	ELSE IF @QueLocation ='CL'
		BEGIN
			SET 	@SqlQueryLocation= ' b.CodeNm2, a.Title, a.UserID, ' + @SqlReplyCnt + ' a.ViewCnt '
		END
	ELSE IF @QueLocation ='CA'
		BEGIN
			SET 	@SqlQueryLocation= ' b.CodeNm2, a.Title, a.UserID, ' + @SqlReplyCnt + ' a.ViewCnt '
		END
	ELSE
		BEGIN
			SET 	@SqlQueryLocation= ''
		END

-- 질문유형
	DECLARE @SqlQueryType varchar(2000)
	IF @QueGbn ='New'
		BEGIN
			SET 	@SqlQueryType= ' And ((a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.RegDate) > Getdate()) ' +
								' Or(ISNULL(a.ModDate,'''') <> '''' And a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.ModDate) > Getdate())) '
		END
	ELSE IF @QueGbn ='Set'
		BEGIN
			SET 	@SqlQueryType= ' And a.ChoiceSerial not in (0,-99) '
		END
	ELSE IF @QueGbn ='Uns'
		BEGIN
			SET 	@SqlQueryType= ' And (( ISNULL(a.ModDate,'''') = '''' And a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.RegDate) < Getdate() OR a.ChoiceSerial = -99) ' +
								' Or( ISNULL(a.ModDate,'''') <> '''' And a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.ModDate) < Getdate() OR a.ChoiceSerial = -99)) '
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType= ''
		END

-- 카테고리 대분류구분
	DECLARE @SqlQueryType1 varchar(1000)
	IF @Cate1Gbn = 0 AND @Cate2Gbn = 0
		BEGIN
			SET 	@SqlQueryType1= ''
		END
	ELSE IF @Cate1Gbn <> 0 AND @Cate2Gbn = 0
		BEGIN
			SET 	@SqlQueryType1= ' And a.Code1=' + @Cate1Gbn
		END
	ELSE IF @Cate1Gbn = 0 AND @Cate2Gbn <> 0
		BEGIN
			SET 	@SqlQueryType1= ' And a.Code2=' + @Cate2Gbn
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType1= ' And a.Code1=' + @Cate1Gbn + ' And a.Code2=' + @Cate2Gbn
		END

-- 검색내용
	DECLARE @SqlQueryType2 varchar(1000)
	IF @SearchString = ''
		BEGIN
			SET 	@SqlQueryType2= ''
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType2= ' And a.' + @SearchGbn + ' Like ''%' + @SearchString + '%'''
		END

DECLARE @SQL varchar(2000)
	SET     @SQL =
		'SELECT ' + @SqlTopLine + ' a.Adid, a.RegDate, ' + @SqlQueryLocation +
		' FROM k_Question a, k_Category b ' +
		' Where a.Code2 = b.Code2 And a.DelFlag=0 ' + @SqlQueryType + @SqlQueryType1 + @SqlQueryType2 +
		' Order By a.RegDate DESC'

print(@SQL)
EXEC(@SQL)

GO
/****** Object:  StoredProcedure [dbo].[procKnowListCount_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 지식검색-질문(새로운, 해결된, 미해결된) 카운트
제작자		:
제작일		: 2003-12-16
셜명		: 페이징,리스트(카운트)

Cate1Gbn		: 카테고리 대분류구분(100:부동산, 110:취업, 120:자동차, 130:맛있는집, 140:상품직거래)
Cate2Gbn		: 카테고리 중분류구분
QueGbn		: 질문구분 (새로운질문/해결된질문/미해결된질문)
*************************************************************************************/
CREATE PROCEDURE [dbo].[procKnowListCount_DelAN] (
@Cate1Gbn	varchar(3),
@Cate2Gbn	varchar(6),
@QueGbn	varchar(3),
@SearchGbn	varchar(10),
@SearchString	varchar(100)
)
AS

-- 질문유형
	DECLARE @SqlQueryType varchar(1000)
	IF @QueGbn ='New'
		BEGIN
			SET 	@SqlQueryType= ' And ((a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.RegDate) > Getdate()) ' +
								' Or(ISNULL(a.ModDate,'''') <> '''' And a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.ModDate) > Getdate())) '
		END
	ELSE IF @QueGbn ='Set'
		BEGIN
			SET 	@SqlQueryType= ' And a.ChoiceSerial not in (0,-99) '
		END
	ELSE IF @QueGbn ='Uns'
		BEGIN
			SET 	@SqlQueryType= ' And (( ISNULL(a.ModDate,'''') = '''' And a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.RegDate) < Getdate() OR a.ChoiceSerial = -99) ' +
								' Or( ISNULL(a.ModDate,'''') <> '''' And a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.ModDate) < Getdate() OR a.ChoiceSerial = -99)) '
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType= ''
		END

-- 카테고리 대분류구분
	DECLARE @SqlQueryType1 varchar(1000)
	IF @Cate1Gbn = 0
		BEGIN
			SET 	@SqlQueryType1= ''
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType1= ' And a.Code1=' + @Cate1Gbn
		END

-- 카테고리 중분류구분
	DECLARE @SqlQueryType2 varchar(1000)
	IF @Cate1Gbn = 0
		BEGIN
			SET 	@SqlQueryType2= ''
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType2= ' And a.Code2=' + @Cate2Gbn
		END

-- 검색내용
	DECLARE @SqlQueryType3 varchar(1000)
	IF @SearchGbn = ''
		BEGIN
			SET 	@SqlQueryType3= ''
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType3= ' And a.' + @SearchGbn + ' Like ''%' + @SearchString + '%'''
		END

DECLARE @SQL varchar(2000)
	SET     @SQL =
		'SELECT Count(*) ' +
		' FROM k_Question a, k_Category b ' +
		' Where a.Code2 = b.Code2 And a.DelFlag=0 ' + @SqlQueryType + @SqlQueryType1 + @SqlQueryType2 + @SqlQueryType3

print(@SQL)
EXEC(@SQL)

GO
/****** Object:  StoredProcedure [dbo].[procKnowMyPage_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/**************************************************************************************************************
	설명	 : 지식검색-내 지식관리(카운트 및 내소개관리)
	제작자 :
	제작일 : 2003-12-08
	설명	 :
	ProcessGubun : 이 파라메터의 구분을 통해 각 구문을 실행하게 된다.
		QUEC	        :	질문카운트
		ANSC         	: 답변카운트
		MyPa	        : 내소개관리
		MQUE					: 내질문리스트
		MANS					: 내답변리스트
	UID					: 회원아이디
**************************************************************************************************************/
CREATE PROCEDURE [dbo].[procKnowMyPage_DelAN](
	@ProcessGubun	                  CHAR(4),
	@UID                            VARCHAR(30)		--회원아이디
)
AS

	IF @ProcessGubun = 'QUEC' GOTO QuestionCount
	IF @ProcessGubun = 'ANSC' GOTO AnswerCount
	IF @ProcessGubun = 'SCPC' GOTO ScrapCount
	IF @ProcessGubun = 'MyPa' GOTO MyPage
	IF @ProcessGubun = 'KHow' GOTO KnowhowCount
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 변수 선언
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN
	BEGIN TRANSACTION

----------------------------------------------------------------------------------------------------------------------------------------------------
-- QUEC	:	 k_Question(질문 카운트) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
QuestionCount:
		BEGIN
			SELECT count(*) as QTCount,
			--  Sum(case When ChoiceSerial = 0 And DateAdd(dd,ReplyTerm,RegDate) > Getdate() Then 1 Else 0 End) as NewCnt,		--신규(새로운질문)
			  Sum(
			    Case When ISNULL(ModDate,'') = '' Then	--수정일이 Null이거나 공백일 경우
				Case When (ChoiceSerial = 0 And DateAdd(dd,ReplyTerm,RegDate) < Getdate() OR ChoiceSerial = -99) Then 1 Else 0 End	--미해결답변(답변기간지남)
			    Else
				Case When (ChoiceSerial = 0 And DateAdd(dd,ReplyTerm,ModDate) < Getdate() OR ChoiceSerial = -99) Then 1 Else 0 End	--미해결답변(답변기간지남)
			    End) as ReNoCnt,
			  Sum(case When ChoiceSerial not in (0,-99)  Then 1 Else 0 End) as ReCnt		--해결된답변
			FROM k_Question
			Where UserID = '' + @UID + ''
			And DelFlag = 0
		END
	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
-- ANSC	:	 k_Answer(답변 카운트) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
AnswerCount:
		BEGIN
			SELECT count(*) as ATCount,
			  Sum(case When ChoiceYn = 1 Then 1 Else 0 End) as ChoiceY	--채택된답변
			FROM k_Answer
			Where UserID = '' + @UID + ''
			And DelFlag = 0
		END
	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
-- SCPC	:	 k_Answer(스크랩 카운트) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
ScrapCount:
		BEGIN
			SELECT count(*) as Cnt
			FROM k_Scrap
			Where UserID = '' + @UID + ''
			And DelFlag = 0
		END
	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
-- MyPa	:	 k_Member(내 소개관리) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
MyPage:
		BEGIN
			SELECT UserID, UserNm, SelfInfo, PicYN, PicUrl, eMail, eMailOpenYn
			FROM k_Member
			Where UserID = '' + @UID + ''
		END
	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
-- KHow	:	 k_Knowhow(내 노하우 카운트) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
KnowhowCount:
		BEGIN
			SELECT count(*) as Cnt
			FROM k_Knowhow
			Where UserID = '' + @UID + ''
			And DelFlag = 0
		END
	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
------------			 	COMMIT & ROLLBACK                                              ------------
----------------------------------------------------------------------------------------------------------------------------------------------------
	IF @@ERROR = 0
	BEGIN
    COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
	END
END

GO
/****** Object:  StoredProcedure [dbo].[procKnowMyPageList_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/**************************************************************************************************************
	설명	 : 지식검색-내 지식관리
	제작자 :
	제작일 : 2003-12-08
	설명	 :
	Page				: 페이지
	PageSize		: 페이지당 게시물 개수
	ProcessGubun : 이 파라메터의 구분을 통해 각 구문을 실행하게 된다.
		MQUE					: 내질문리스트
		MANS					: 내답변리스트
		MSCP					: 내스케줄리스트
		MKHW					: 내노하우리스트
	UID					: 회원아이디
**************************************************************************************************************/
CREATE PROCEDURE [dbo].[procKnowMyPageList_DelAN](
	@PAGE		int,
	@PAGESIZE	int,
	@ProcessGubun	                  CHAR(4),
	@UID                            VARCHAR(30)		--회원아이디
)
AS


-- 페이징과 메인리스트 구분
	DECLARE @SqlTopLine varchar(50)
		BEGIN
			SET 	@SqlTopLine= ' TOP ' + CONVERT(varchar(10), + @PAGE*@PAGESIZE )
		END

	DECLARE @SQL varchar(2000)
----------------------------------------------------------------------------------------------------------------------------------------------------
-- MQUE	:	 k_Question(내질문리스트) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
	IF @ProcessGubun = 'MQUE'
		BEGIN
			SET     @SQL =
			' a.Adid, b.CodeNm1, a.Title, a.ReplyTerm, (Select Count(*) From k_Answer Where queAdid = a.Adid And DelFlag = 0) As ReplyCnt, ' +
			' a.ViewCnt, a.ChoiceSerial, a.RegDate, ' +
			' Case When a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.RegDate) > Getdate() Then ''진행중''' +
			' When a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.RegDate) < Getdate() Then ''미해결''' +
			'	When a.ChoiceSerial <> 0 Then ''완료''' +
			' Else ''''' +
			' End as ReChk' +
			' FROM k_Question a, k_Category b ' +
			' Where a.Code2 = b.Code2 '

		END

----------------------------------------------------------------------------------------------------------------------------------------------------
-- MANS	:	 k_Question(내답변리스트) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
	ELSE IF @ProcessGubun = 'MANS'
		BEGIN
			SET     @SQL =
			' b.Adid, c.CodeNm1, b.UserID, a.Title, b.ViewCnt, a.RegDate, b.ChoiceSerial, ' +
			' Case When b.ChoiceSerial = 0 And DateAdd(dd,b.ReplyTerm,b.RegDate) > Getdate() Then ''진행중''' +
			' When b.ChoiceSerial = 0 And DateAdd(dd,b.ReplyTerm,b.RegDate) < Getdate() Then ''미해결''' +
			'	When b.ChoiceSerial <> 0 Then ''완료''' +
			' Else ''''' +
			' End as ReChk' +
			' FROM k_Answer a, k_Question b, k_Category c ' +
			' Where b.Code2 = c.Code2 ' +
			'	And a.queAdid = b.Adid '
		END

----------------------------------------------------------------------------------------------------------------------------------------------------
-- MSCP	:	 k_Scrap(내스크랩리스트) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
	ELSE IF @ProcessGubun = 'MSCP'
		BEGIN
			SET     @SQL =
			' a.Serial, a.queAdid, c.CodeNm1, b.Title, b.RegDate, ' +
			' (Select Count(*) From k_Answer Where queAdid = b.Adid And DelFlag = 0) As ReplyCnt, b.ViewCnt ' +
			' From k_Scrap a, k_Question b, k_Category c ' +
			' Where a.queAdid = b.Adid ' +
			'	And b.Code2 = c.Code2 '
		END

----------------------------------------------------------------------------------------------------------------------------------------------------
-- MKHW	:	 k_Knowhow(내노하우리스트) SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------
	IF @ProcessGubun = 'MKHW'
		BEGIN
			SET     @SQL =
			' a.Adid, b.CodeNm1, a.Title, a.ViewCnt, a.RegDate ' +
			' FROM k_Knowhow a, k_Category b ' +
			' Where a.Code2 = b.Code2 '

		END

DECLARE @SQLQ varchar(2000)
	SET     @SQLQ =
		'SELECT ' + @SqlTopLine + @SQL +
		'	And a.UserID = ''' + @UID + '''' +
		'	And a.DelFlag = 0 ' +
		'	Order By a.RegDate DESC '

BEGIN
	PRINT(@SQLQ)
	EXEC(@SQLQ)
END

GO
/****** Object:  StoredProcedure [dbo].[procSupportsPoll]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procSupportsPoll]
	@ProcessGubun		  CHAR(3),
	@Serial			  INT			      = NULL,
	@SiteGbn		  VARCHAR(10)		      = NULL,
	@Title			  VARCHAR(200)	                    = NULL,
	@Poll			  VARCHAR(2000)	                    = NULL,
	@Exam1		                VARCHAR(50)		      = NULL,
	@Exam2		                VARCHAR(50)		      = NULL,
	@Exam3		                VARCHAR(50)		      = NULL,
	@Exam4		                VARCHAR(50)		      = NULL,
	@Exam5		                VARCHAR(50)		      = NULL,
	@Exam6		                VARCHAR(50)		      = NULL,
	@Exam7		                VARCHAR(50)		      = NULL,
	@Exam8		                VARCHAR(50)		      = NULL,
	@ResultCnt1		  INT			      = NULL,
	@ResultCnt2		  INT			      = NULL,
	@ResultCnt3		  INT			      = NULL,
	@ResultCnt4		  INT			      = NULL,
	@ResultCnt5		  INT			      = NULL,
	@ResultCnt6		  INT			      = NULL,
	@ResultCnt7		  INT			      = NULL,
	@ResultCnt8		  INT			      = NULL,
	@MagCnt11		  INT			      = NULL,
	@MagCnt12		  INT			      = NULL,
	@MagCnt21		  INT			      = NULL,
	@MagCnt22		  INT			      = NULL,
	@MagCnt31		  INT			      = NULL,
	@MagCnt32		  INT			      = NULL,
	@MagCnt41		  INT			      = NULL,
	@MagCnt42		  INT			      = NULL,
	@MagCnt51		  INT			      = NULL,
	@MagCnt52		  INT			      = NULL,
	@MagCnt61		  INT			      = NULL,
	@MagCnt62		  INT			      = NULL,
	@MagCnt71		  INT			      = NULL,
	@MagCnt72		  INT			      = NULL,
	@MagCnt81		  INT			      = NULL,
	@MagCnt82		  INT			      = NULL,
	@StDate		                CHAR(8)		      = NULL,
	@EnDate		                CHAR(8)		      = NULL,
	@VoteRight		  VARCHAR(10)		      = NULL,
	@IsEnd			  CHAR(1)		      = NULL,
	@Page			  INT			      = NULL,
	@PageSize		  INT			      = NULL,
	@LocalSite		  VARCHAR(8)		      = NULL,
	@MagLocalSite	                VARCHAR(8)		      = NULL

AS

	IF @ProcessGubun = 'ALP' GOTO AdminPollListPrint
	ELSE IF @ProcessGubun = 'AIN' GOTO AdminPollInsertData
	ELSE IF @ProcessGubun = 'ADS' GOTO AdminPollDetailSelect
	ELSE IF @ProcessGubun = 'AUS' GOTO AdminPollModifySelect
	ELSE IF @ProcessGubun = 'AUP' GOTO AdminPollUpdate
	ELSE IF @ProcessGubun = 'ADP' GOTO AdminPollDelete
	ELSE IF @ProcessGubun = 'AFU' GOTO AdminPollFlagUpdate
	ELSE IF @ProcessGubun = 'FPS' GOTO FrontPollDataSelect
	ELSE IF @ProcessGubun = 'FPU' GOTO FrontPollCountData
	ELSE IF @ProcessGubun = 'FRP' GOTO FrontPollResultSelect

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 변수 선언 @Query(쿼리 스트링) @Where(WHERE 조건절 쿼리 스트링) @SrvGbn(ServiceCode TABLE의 대분류 값)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE   @Query VARCHAR(8000)
	  , @Where VARCHAR(500)
	  , @SrvGbn INT
	  , @PollCnt INT
	  , @insertpollsql nvarchar(4000)
BEGIN
	BEGIN TRANSACTION
----------------------------------------------------------------------------------------------------------------------------------------------------
-- ALP : LIST 출력용(AdminPollListPrint)
----------------------------------------------------------------------------------------------------------------------------------------------------
AdminPollListPrint:
	IF ISNULL(@VoteRight,'') <> ''
--	IF @VoteRight <> ''
		BEGIN
			SELECT @Where = ' AND VoteRight=''' + @VoteRight + ''''
		END

	IF ISNULL(@IsEnd,'') <> ''
		BEGIN
			SELECT @Where = ISNULL(@Where,'') + ' AND IsEnd=''' + @IsEnd + ''''
		END

	IF ISNULL(@Title,'') <> ''
		BEGIN
			SELECT @Where = ISNULL(@Where,'') + ' AND Title LIKE ''%' + @Title + '%'''
		END

	IF ISNULL(@Poll,'') <> ''
		BEGIN
			SELECT @Where = ISNULL(@Where,'') + ' AND Poll LIKE ''%' + @Poll + '%'''
		END

	--게재 구분
	IF ISNULL(@LocalSite,'') <> ''
		BEGIN
			SELECT @Where = ISNULL(@Where,'') + ' AND A.InsLocalSite=''' + @LocalSite + ''''
		END
	ELSE
		BEGIN
			IF @MagLocalSite <> '0'
			SELECT @Where = ISNULL(@Where,'') + ' AND A.InsLocalSite=''' + @MagLocalSite + ''''
		END



	SET @Query = 'SELECT COUNT(DISTINCT Serial) FROM SupportsPoll A With (NoLock, ReadUnCommitted) inner join FINDDB2.FindCommon.dbo.LocalSite B on A.InsLocalSite = B.LocalSite WHERE SiteGbn=''' + @SiteGbn + '''' + ISNULL(@Where,'') + ';'
	SET @Query = @Query + 'SELECT DISTINCT TOP ' + CONVERT(varchar,@Page*@PageSize) + ' Serial,Title,StDate,EnDate,A.RegDate,VoteRight,IsEnd,A.InsLocalSite,LocalSiteNm, A.PollGbn, A.ResultCnt1+A.ResultCnt2+A.ResultCnt3+A.ResultCnt4+A.ResultCnt5+A.ResultCnt6+A.ResultCnt7+A.ResultCnt8 as ResultCntTot '
	SET @Query = @Query + ' FROM SupportsPoll A With (NoLock, ReadUnCommitted) inner join FINDDB2.FindCommon.dbo.LocalSite B on A.InsLocalSite = B.LocalSite WHERE SiteGbn=''' + @SiteGbn + '''' + ISNULL(@Where,'')
	SET @Query = @Query + ' ORDER BY Serial DESC, IsEnd ASC '

	PRINT(@Query)
	EXEC( @Query )
	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
-- AIN : INSERT DATA(AdminPollInsertData)
----------------------------------------------------------------------------------------------------------------------------------------------------
AdminPollInsertData:
select max(Serial) as NextSerial from SupportsPoll;
BEGIN TRANSACTION
	select max(Serial) as NextSerial from SupportsPoll;
	INSERT INTO SupportsPoll(SiteGbn,InsLocalSite,Title,Poll,Exam1,Exam2,Exam3,Exam4,Exam5,Exam6,Exam7,Exam8,ResultCnt1,ResultCnt2,ResultCnt3,ResultCnt4,ResultCnt5,ResultCnt6,ResultCnt7,ResultCnt8,StDate,EnDate,RegDate,VoteRight,IsEnd)
	VALUES(@SiteGbn,convert(int,@LocalSite),@Title,@Poll,@Exam1,@Exam2,@Exam3,@Exam4,@Exam5,@Exam6,@Exam7,@Exam8,0,0,0,0,0,0,0,0,@StDate,@EnDate,GETDATE(),@VoteRight,@IsEnd)
--Poll Table에 Insert 후 @@identity 로 Serial을 가져와 나머지 테이블의 Insert를 처리한다
IF @@ERROR = 0
	BEGIN
		COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END

	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
-- ADS : 설문내용 상세보기 SELECT(AdminPollDetailSelect)
----------------------------------------------------------------------------------------------------------------------------------------------------
AdminPollDetailSelect:
	SELECT Serial,Title,Poll,Exam1,Exam2,Exam3,Exam4,Exam5,Exam6,Exam7,Exam8,ResultCnt1,ResultCnt2,ResultCnt3,ResultCnt4,ResultCnt5,ResultCnt6,ResultCnt7,ResultCnt8,StDate,EnDate,RegDate,
		  VoteRight=CASE VoteRight WHEN '0' THEN '일반' WHEN '1' THEN '개인' WHEN '2' THEN '기업' END,
		  IsEnd=CASE IsEnd WHEN '0' THEN '진행' WHEN '1' THEN '종료' END,InsLocalSite,
		  PollGbn,SubExam1,SubExam2,SubResultCnt11,SubResultCnt12,SubResultCnt21,SubResultCnt22,
		  SubResultCnt31,SubResultCnt32,SubResultCnt41,SubResultCnt42,SubResultCnt51,SubResultCnt52,SubResultCnt61,SubResultCnt62,SubResultCnt71,SubResultCnt72,SubResultCnt81,SubResultCnt82,
		  MagCnt11,MagCnt12,MagCnt21,MagCnt22,MagCnt31,MagCnt32,MagCnt41,MagCnt42,MagCnt51,MagCnt52,MagCnt61,MagCnt62,MagCnt71,MagCnt72,MagCnt81,MagCnt82

	FROM SupportsPoll With (NoLock, ReadUnCommitted)
	WHERE Serial=@Serial

	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
-- AUS : 수정폼에서 해당 데이타 SELECT(AdminPollModifySelect)
----------------------------------------------------------------------------------------------------------------------------------------------------
AdminPollModifySelect:
	SELECT Serial,Title,Poll,Exam1,Exam2,Exam3,Exam4,Exam5,Exam6,Exam7,Exam8,StDate,EnDate,VoteRight,IsEnd,InsLocalSite,PollGbn,SubExam1,SubExam2,MagCnt11,MagCnt12,MagCnt21,MagCnt22,MagCnt31,MagCnt32,MagCnt41,MagCnt42,MagCnt51,MagCnt52,MagCnt61,MagCnt62,MagCnt71,MagCnt72,MagCnt81,MagCnt82
	FROM SupportsPoll With (NoLock, ReadUnCommitted)
	WHERE Serial=@Serial

	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
-- AUP : UPDATE DATA(AdminPollUpdate)
----------------------------------------------------------------------------------------------------------------------------------------------------
AdminPollUpdate:
	UPDATE SupportsPoll SET Title=@Title,Poll=@Poll,Exam1=@Exam1,Exam2=@Exam2,Exam3=@Exam3,Exam4=@Exam4,Exam5=@Exam5,Exam6=@Exam6,Exam7=@Exam7,Exam8=@Exam8,
			    StDate=@StDate,EnDate=@Endate,VoteRight=@VoteRight,IsEnd=@IsEnd,InsLocalSite=convert(int,@LocalSite)
	WHERE Serial=@Serial

	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
-- ADP : DELETE DATA(AdminPollDelete)
----------------------------------------------------------------------------------------------------------------------------------------------------
AdminPollDelete:

	DELETE SupportsPoll WHERE Serial=@Serial

	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
-- AFU : 투표권한,종료여부 변경 처리(AdminPollFlagUpdate)
----------------------------------------------------------------------------------------------------------------------------------------------------
AdminPollFlagUpdate:

	UPDATE SupportsPoll SET VoteRight=@VoteRight,IsEnd=@IsEnd WHERE Serial=@Serial

	RETURN

----------------------------------------------------------------------------------------------------------------------------------------------------
-- FPS : 설문 데이타 SELECT(FrontPollDataSelect)
----------------------------------------------------------------------------------------------------------------------------------------------------
FrontPollDataSelect:


	IF @LocalSite = '0'
		BEGIN
			SELECT TOP 1 Serial,Poll,Exam1,Exam2,Exam3,Exam4,Exam5,Exam6,Exam7,Exam8,VoteRight,PollGbn,SubExam1,SubExam2
			FROM SupportsPoll With (NoLock, ReadUnCommitted)
			WHERE IsEnd = '0'
			AND SiteGbn=@SiteGbn
			AND CONVERT(CHAR(8),GETDATE(),112) >= CONVERT(CHAR(8),StDate,112)
			AND CONVERT(CHAR(8),GETDATE(),112) <= CONVERT(CHAR(8),EnDate,112)
			AND InsLocalSite = convert(int,@LocalSite)
		END
	ELSE
		BEGIN
			--해당 지역 설문이 없을 경우 전국설문을 SELECT
			SET @PollCnt = (
					SELECT COUNT(Serial)
					FROM SupportsPoll With (NoLock, ReadUnCommitted)
					WHERE IsEnd = '0'
					AND SiteGbn=@SiteGbn
					AND CONVERT(CHAR(8),GETDATE(),112) >= CONVERT(CHAR(8),StDate,112)
					AND CONVERT(CHAR(8),GETDATE(),112) <= CONVERT(CHAR(8),EnDate,112)
					AND InsLocalSite = convert(int,@LocalSite) )

			IF @PollCnt > 0
					SELECT TOP 1 Serial,Poll,Exam1,Exam2,Exam3,Exam4,Exam5,Exam6,Exam7,Exam8,VoteRight,PollGbn,SubExam1,SubExam2
					FROM SupportsPoll With (NoLock, ReadUnCommitted)
					WHERE IsEnd = '0'
					AND SiteGbn=@SiteGbn
					AND CONVERT(CHAR(8),GETDATE(),112) >= CONVERT(CHAR(8),StDate,112)
					AND CONVERT(CHAR(8),GETDATE(),112) <= CONVERT(CHAR(8),EnDate,112)
					AND InsLocalSite = convert(int,@LocalSite)
			ELSE
					SELECT TOP 1 Serial,Poll,Exam1,Exam2,Exam3,Exam4,Exam5,Exam6,Exam7,Exam8,VoteRight,PollGbn,SubExam1,SubExam2
					FROM SupportsPoll With (NoLock, ReadUnCommitted)
					WHERE IsEnd = '0'
					AND SiteGbn=@SiteGbn
					AND CONVERT(CHAR(8),GETDATE(),112) >= CONVERT(CHAR(8),StDate,112)
					AND CONVERT(CHAR(8),GETDATE(),112) <= CONVERT(CHAR(8),EnDate,112)
					AND InsLocalSite = 0
	END
	RETURN



----------------------------------------------------------------------------------------------------------------------------------------------------
-- FPU : 설문 답변 카운트 처리(FrontPollCountData)
----------------------------------------------------------------------------------------------------------------------------------------------------
FrontPollCountData:
	set @insertpollsql = 'UPDATE SupportsPoll SET ResultCnt1=ResultCnt1 +' + convert(char(1),@ResultCnt1)
	set @insertpollsql = @insertpollsql + ',ResultCnt2=ResultCnt2 +' +convert(char(1),@ResultCnt2)
	set @insertpollsql = @insertpollsql + ',ResultCnt3=ResultCnt3 +' +convert(char(1),@ResultCnt3)
	set @insertpollsql = @insertpollsql + ',ResultCnt4=ResultCnt4 +' +convert(char(1),@ResultCnt4)
	set @insertpollsql = @insertpollsql + ',ResultCnt5=ResultCnt5 +' +convert(char(1),@ResultCnt5)
	set @insertpollsql = @insertpollsql + ',ResultCnt6=ResultCnt6 +' +convert(char(1),@ResultCnt6)
	set @insertpollsql = @insertpollsql + ',ResultCnt7=ResultCnt7 +' +convert(char(1),@ResultCnt7)
	set @insertpollsql = @insertpollsql + ',ResultCnt8=ResultCnt8 +' +convert(char(1),@ResultCnt8)

	IF @Title = 'SubResultCnt11'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt11=SubResultCnt11+1'
		end
	ELSE IF @Title = 'SubResultCnt12'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt12=SubResultCnt12+1'
		end
	ELSE IF @Title = 'SubResultCnt21'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt21=SubResultCnt21+1'
		end
	ELSE IF @Title = 'SubResultCnt22'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt22=SubResultCnt22+1'
		end
	ELSE IF @Title = 'SubResultCnt31'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt31=SubResultCnt31+1'
		end
	ELSE IF @Title = 'SubResultCnt32'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt32=SubResultCnt32+1'
		end
	ELSE IF @Title = 'SubResultCnt41'
		begin
			set @insertpollsql = @insertpollsql +' ,SubResultCnt41=SubResultCnt41+1'
		end
	ELSE IF @Title = 'SubResultCnt42'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt42=SubResultCnt42+1'
		end
	ELSE IF @Title = 'SubResultCnt51'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt51=SubResultCnt51+1'
		end
	ELSE IF @Title = 'SubResultCnt52'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt52=SubResultCnt52+1'
		end
	ELSE IF @Title = 'SubResultCnt61'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt61=SubResultCnt61+1'
		end
	ELSE IF @Title = 'SubResultCnt62'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt62=SubResultCnt62+1'
		end
	ELSE IF @Title = 'SubResultCnt71'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt71=SubResultCnt71+1'
		end
	ELSE IF @Title = 'SubResultCnt72'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt72=SubResultCnt72+1'
		end
	ELSE IF @Title = 'SubResultCnt81'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt81=SubResultCnt81+1'
		end
	ELSE IF @Title = 'SubResultCnt82'
		begin
			set @insertpollsql = @insertpollsql + ',SubResultCnt82=SubResultCnt82+1'
		end
	set @insertpollsql = @insertpollsql + '  WHERE Serial=' + convert(varchar,@Serial)

	print(@insertpollsql)
	execute sp_executesql @insertpollsql
	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
-- FRP : 결과보기 SELECT(FrontPollResultSelect)
----------------------------------------------------------------------------------------------------------------------------------------------------
FrontPollResultSelect:
	SELECT	Serial,Poll,
			Exam1,Exam2,Exam3,Exam4,Exam5,Exam6,Exam7,Exam8,
			ResultCnt1,ResultCnt2,ResultCnt3,ResultCnt4,ResultCnt5,ResultCnt6,ResultCnt7,ResultCnt8,
			StDate,EnDate,PollGbn,SubExam1,SubExam2,
			SubResultCnt11,SubResultCnt12,SubResultCnt21,SubResultCnt22,SubResultCnt31,SubResultCnt32,SubResultCnt41,SubResultCnt42,
			SubResultCnt51,SubResultCnt52,SubResultCnt61,SubResultCnt62,SubResultCnt71,SubResultCnt72,SubResultCnt81,SubResultCnt82,
			MagCnt11,MagCnt12,MagCnt21,MagCnt22,MagCnt31,MagCnt32,MagCnt41,MagCnt42,MagCnt51,MagCnt52,MagCnt61,MagCnt62,
			MagCnt71,MagCnt72,MagCnt81,MagCnt82
	FROM SupportsPoll With (NoLock, ReadUnCommitted)
	WHERE Serial=@Serial

	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
------------			 	COMMIT & ROLLBACK                                              ------------
----------------------------------------------------------------------------------------------------------------------------------------------------
	IF @@ERROR = 0
	BEGIN
		COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
	END
END

GO
/****** Object:  StoredProcedure [dbo].[procUserCenter]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: FindAll / Paper 고객센터
제작자		: 강홍석
제작일		: 2002-07-30
셜명		: 페이징,검색

Page		: 페이지
PageSize	: 페이지당 게시물 개수
SiteGbn		: 사이트구분 (all/paper)
QueryType	: 접수유형
ReplyFlag	: 회신여부
DateGbn		: 접수일/처리일
StartDate	: 접수일검색(시작일)
EndDate 	: 접수일검색(종료일)
LocalSite	: 관리자 관리지역 코드
*************************************************************************************/
CREATE PROCEDURE [dbo].[procUserCenter] (
@PAGE		int,
@PAGESIZE	int,
@SITEGBN	as varchar(10),
@QUERYTYPE	as varchar(30),
@REPLYFLAG	as varchar(1),
@DATEGBN	as varchar(10),
@STARTDATE	as varchar(12),
@ENDDATE	as varchar(12),
@LOCALSITE	int,
@LocalSub	as varchar(30)
)
AS


-- all일경우와 paper일경우 출력
	DECLARE @SqlSiteGbn varchar(200)
	IF @SITEGBN =''
		BEGIN
			SET 	@SqlSiteGbn= ''
		END
	ELSE
		BEGIN
			SET 	@SqlSiteGbn= ' (SiteGbn = ''' + @SITEGBN + ''' OR MoveSite =  ''' + @SITEGBN + ''' ) '

		END
		IF @LocalSub <>''
			BEGIN
				SET 	@SqlSiteGbn= '(LocalName = ''' + @LocalSub + ''' OR MoveLocal =  ''' + @LocalSub + '''  '


-- 전국 관리자의 경우 전체 또는 각 지역별 리스트 출력위해
-- 전국 관리자가 아닐경우 해당 지역리스트 출력
				IF @LOCALSITE <>''
					BEGIN
						SET 	@SqlSiteGbn= @SqlSiteGbn + ' OR (LocalSite =' + CONVERT(varchar(10),@LOCALSITE) + ' AND LocalName = ''' + @LocalSub + ''') '
					END
				SET	@SqlSiteGbn = @SqlSiteGbn + ') '
			END

-- 질문유형
	DECLARE @SqlQueryType varchar(200)
	IF @QUERYTYPE =''
		BEGIN
			SET 	@SqlQueryType= ''
		END
	ELSE
		BEGIN
			SET 	@SqlQueryType= ' AND QueryType = ''' + @QUERYTYPE + ''' '
		END

-- 회신여부
	DECLARE @SqlReplyFlag varchar(80)
	IF @REPLYFLAG =''
		BEGIN
			SET 	@SqlReplyFlag= ''
		END
	ELSE
		BEGIN
			SET 	@SqlReplyFlag= ' AND Sended = ''' + @REPLYFLAG + ''' '
		END



-- 검색기간
	DECLARE @SqlStartDate	varchar(200)
	IF @STARTDATE = ''
		BEGIN
			SET 	@SqlStartDate= ''
		END
	ELSE
		BEGIN
			SET 	@SqlStartDate= ' AND Convert(varchar(10),' + @DATEGBN + ',120) >= ''' +@STARTDATE +''''
		END

	DECLARE @SqlEndDate	varchar(200)
	IF @ENDDATE=''
		BEGIN
			SET	@SqlEndDate=''
		END
	ELSE
		BEGIN
			SET 	@SqlEndDate= ' AND Convert(varchar(10),' + @DATEGBN + ',120) <= ''' +@ENDDATE+ ''''
		END



--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlSiteGbn +@SqlQueryType+ @SqlReplyFlag + @SqlStartDate + @SqlEndDate
		END

DECLARE @SQL varchar(2000)
SET     @SQL =

	'SELECT COUNT(serial) FROM UsrCenter WHERE ' + @SqlAll + ' ; ' +
	'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) +
	' Serial, CONVERT(char(10) , RegDate , 120) as  RegDate , UserID, UserName, QueryType, Title, LocalName,Sended, SendDate, MoveSite, MoveLocal, MoveDate ' +
	' FROM  UsrCenter WHERE  '+ @SqlAll + ' Order by Serial DESC,RegDate DESC '

print(@SQL)
EXEC(@SQL)

GO
/****** Object:  StoredProcedure [dbo].[procViewEtc]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[procViewEtc]
(
	@Page			int		-- Jump할 페이지
,	@PageSize		int		-- 페이지당 게시물 개수
,	@cboProxy		varchar(10)	-- 접수경로
,	@cboMainSeq		varchar(10)	-- 메인순번
,	@cboMainTextSeq	varchar(10)	-- 질문번호
,	@cboSubTextSeq	varchar(10)         -- 답변번호
,	@cboPeriod		varchar(10)
,	@txtKeyword		varchar(40)
)
AS
-- 조건 쿼리
DECLARE @ConSql	varchar(200)
	SET	@ConSql = ' AND A.MainSeq = ' +@cboMainSeq + ' AND A.MainSeq = B.MainSeq  AND B. MainTextSeq = ' + @cboMainTextSeq
-- 접수경로 쿼리 0:인터넷,1:우편,NULL:전체
DECLARE @ProxySql varchar(200)
IF @cboProxy = '0'
	BEGIN
		SET	@ProxySql = 'AND A.Proxy IS NULL '
	END
ELSE IF  @cboProxy = '1'
	BEGIN
		SET	@ProxySql = 'AND A.Proxy IS NOT NULL '
	END
ELSE
	BEGIN
		SET	@ProxySql = ' '
	END
-- 키워드 검색쿼리
DECLARE @KeyWordSql varchar(200)
IF @cboPeriod <> '' AND @txtKeyWord <> ''
	BEGIN
		SET	@KeyWordSql = 'AND ' + @cboPeriod + ' LIKE ''%' + @txtKeyWord + '%'' '
	END
ELSE
	BEGIN
		SET	@KeyWordSql = ''
	END
-- 모든 쿼리
DECLARE @AllSql	varchar(4000)
SET @AllSql =  @ConSql + ' ' + @ProxySql +  ' ' + @KeyWordSql
DECLARE @Sql		varchar(6000)
IF @cboSubTextSeq <> '' 			--서브 답변의 기타사항일때
	BEGIN
		SET @Sql =
			'SELECT Count(*)  ' +
			'FROM Anc365Respondent A, Anc365SubRespondent B ' +
			'WHERE A.UserID = B.UserID AND B.SubExamEtc IS Not NULL ' + @AllSql + ';' +

			'SELECT  TOP ' + CONVERT(varchar(10), @Page*@PageSize) + ' A.RegDate, A.Proxy, A.UserID, A.UserName, A.Phone, A.Sex, A.Age, ' +
			'(A.Metro  + '' '' + A.City + '' '' +  ISNULL(A.Address1,'''')  + '' '' + ISNULL(A.Address2,'''')) AS Address, B.SubExamEtc As EtcContents ' +
			'FROM Anc365Respondent A, Anc365SubRespondent B ' +
			'WHERE A.UserID = B.UserID AND B.SubExamEtc IS Not NULL ' + @AllSql +
			' ORDER BY A.RegDate DESC '
	END
ELSE
	BEGIN
		SET @Sql =
			'SELECT Count(*)  ' +
			'FROM Anc365Respondent A, Anc365SubRespondent B ' +
			'WHERE A.UserID = B.UserID AND B.ExamEtc IS Not NULL ' + @AllSql + ';' +

			'SELECT  TOP ' + CONVERT(varchar(10), @Page*@PageSize) + ' A.RegDate, A.Proxy, A.UserID, A.UserName, A.Phone, A.Sex, A.Age, ' +
			'(A.Metro  + '' '' + A.City + '' '' +  ISNULL(A.Address1,'''')  + '' '' + ISNULL(A.Address2,'''')) AS Address, B.ExamEtc As EtcContents ' +
			'FROM Anc365Respondent A, Anc365SubRespondent B ' +
			'WHERE A.UserID = B.UserID AND B.ExamEtc IS Not NULL ' + @AllSql +
			' ORDER BY A.RegDate DESC '
	END
PRINT(@Sql)
EXEC(@Sql)

GO
/****** Object:  StoredProcedure [dbo].[procViewJu_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procViewJu_DelAN]
(
	@Page			int		-- Jump할 페이지
,	@PageSize		int		-- 페이지당 게시물 개수
,	@cboProxy		varchar(10)	-- 접수경로
,	@cboMainSeq		varchar(10)	-- 메인순번
,	@cboMainTextSeq	varchar(10)	-- 질문번호
,	@cboPeriod		varchar(10)
,	@txtKeyword		varchar(40)
)
AS
-- 조건 쿼리
DECLARE @ConSql	varchar(200)
	SET	@ConSql = ' AND A.MainSeq = ' +@cboMainSeq + ' AND A.MainSeq = B.MainSeq  AND B. MainTextSeq = ' + @cboMainTextSeq
-- 접수경로 쿼리 0:인터넷,1:우편,NULL:전체
DECLARE @ProxySql varchar(200)
IF @cboProxy = '0'
	BEGIN
		SET	@ProxySql = 'AND A.Proxy IS NULL '
	END
ELSE IF  @cboProxy = '1'
	BEGIN
		SET	@ProxySql = 'AND A.Proxy IS NOT NULL '
	END
ELSE
	BEGIN
		SET	@ProxySql = ' '
	END
-- 키워드 검색쿼리
DECLARE @KeyWordSql varchar(200)
IF @cboPeriod <> '' AND @txtKeyWord <> ''
	BEGIN
		SET	@KeyWordSql = 'AND ' + @cboPeriod + ' LIKE ''%' + @txtKeyWord + '%'' '
	END
ELSE
	BEGIN
		SET	@KeyWordSql = ''
	END
-- 모든 쿼리
DECLARE @AllSql	varchar(4000)
SET @AllSql =  @ConSql + ' ' + @ProxySql +  ' ' + @KeyWordSql
DECLARE @Sql		varchar(6000)
SET @Sql =
		'SELECT Count(*)  ' +
		'FROM Anc365Respondent A, Anc365SubRespondent B ' +
		'WHERE A.UserID = B.UserID AND B.SbjExam IS Not NULL ' + @AllSql + ';' +

		'SELECT  TOP ' + CONVERT(varchar(10), @Page*@PageSize) + ' A.RegDate, A.Proxy, A.UserID, A.UserName, A.Phone, A.Sex, A.Age, ' +
		'(A.Metro  + '' '' + A.City + '' '' +  ISNULL(A.Address1,'''')  + '' '' + ISNULL(A.Address2,'''')) AS Address, B.SbjExam ' +
		'FROM Anc365Respondent A, Anc365SubRespondent B ' +
		'WHERE A.UserID = B.UserID AND B.SbjExam IS Not NULL ' + @AllSql +
		' ORDER BY A.RegDate DESC '
PRINT(@Sql)
EXEC(@Sql)

GO
/****** Object:  StoredProcedure [dbo].[PUT_F_ARTICLE_COMMENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 글마당 댓글 달기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_ARTICLE_COMMENT_PROC]
	@NDX		INT,
	@IDX		INT,

	@USERID		VARCHAR(50),
	@USERNAME	VARCHAR(20),
	@COMMENT	VARCHAR(500),
	@GRADES		INT,

	@IRESULT	INT=0	OUTPUT
AS

BEGIN TRAN

	--평점 ++
	UPDATE	DBO.READEREVENT2
	SET
		GRADES = GRADES + @GRADES
	WHERE
		IDX	= @IDX

	--댓글입력
	INSERT INTO DBO.READERCOMMENT2(
		NDX,
		IDX,
		USERID,
		USERNAME,
		COMMENT,
		GRADES,
		REGDATE
	)	VALUES (
		@NDX,
		@IDX,
		@USERID,
		@USERNAME,
		@COMMENT,
		@GRADES,
		GETDATE()
	)

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_F_ARTICLE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장PLUS - 글마당 글등록
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_ARTICLE_PROC]
	@NDX			INT,
	@TITLE		VARCHAR(100),
	@USERID		VARCHAR(50),
	@USERNAME	VARCHAR(30),
	@EMAIL		VARCHAR(50),
	@CONTENTS	TEXT,
	@IPADDR		VARCHAR(30),

	@IRESULT	INT=0 OUTPUT
AS

	DECLARE	@REF	INT

BEGIN TRAN

	INSERT INTO DBO.READEREVENT2(
		NDX,
		TITLE,
		LOWREF,
		STEP,
		USERID,
		USERNAME,
		EMAIL,
		CONTENTS,
		IPADDR
	) VALUES (
		@NDX,
		@TITLE,
		1,
		1,
		@USERID,
		@USERNAME,
		@EMAIL,
		@CONTENTS,
		@IPADDR
	)

	SET @REF = SCOPE_IDENTITY()

	UPDATE
		DBO.READEREVENT2
	SET
		REF = @REF
	WHERE
		IDX = @REF

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_F_ARTICLE_REPLY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장PLUS - 글마당 답글등록
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_ARTICLE_REPLY_PROC]
	@IDX			INT,
	@NDX			INT,
	@TITLE		VARCHAR(100),
	@USERID		VARCHAR(50),
	@USERNAME	VARCHAR(30),
	@EMAIL		VARCHAR(50),
	@CONTENTS	TEXT,
	@IPADDR		VARCHAR(30),

	@IRESULT	INT=0 OUTPUT
AS
	DECLARE @REF		INT
	DECLARE	@LOWREF	INT
	DECLARE	@STEP		INT

BEGIN TRAN

	--부모글의 REF,LOWREF,STEP 가져오기
	SELECT
		@REF=REF, @LOWREF=LOWREF, @STEP=STEP
	FROM
		DBO.READEREVENT2(NOLOCK)
	WHERE
		IDX = @IDX

	--STEP처리
	UPDATE
		DBO.READEREVENT2
	SET
		STEP = @STEP + 1
	WHERE
		REF = @REF AND
		STEP > @STEP

	SET @STEP = @STEP + 1
	SET @LOWREF = @LOWREF + 1

	INSERT INTO DBO.READEREVENT2(
		NDX,
		REF,
		LOWREF,
		STEP,
		TITLE,
		USERID,
		USERNAME,
		EMAIL,
		CONTENTS,
		IPADDR
	) VALUES (
		@NDX,
		@REF,
		@LOWREF,
		@STEP,
		@TITLE,
		@USERID,
		@USERNAME,
		@EMAIL,
		@CONTENTS,
		@IPADDR
	)

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_F_ESSAY_COMMENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 정보마당 댓글 달기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_ESSAY_COMMENT_PROC]
	@SERIAL		INT,
	@CODE			INT,
	@USERID		VARCHAR(50),
	@COMMENT	VARCHAR(500),
	@GRADES		INT,

	@IRESULT	INT=0	OUTPUT

AS

BEGIN TRAN
	--댓글 카운트 1증가
	UPDATE DBO.NESSAY
	SET
		CMTCNT = CMTCNT + 1
	WHERE
		SERIAL = @SERIAL

	--댓글 삽입
	INSERT INTO DBO.NESSAYCOMMENT(
		ESSAYSERIAL,
		CODE,
		USERID,
		COMMENT,
		REGDATE,
		GRADES
	)	VALUES (
		@SERIAL,
		@CODE,
		@USERID,
		@COMMENT,
		GETDATE(),
		@GRADES
	)

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_F_FA_SURVEY_ANSWER_TB_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 설문조사 이벤트 등록
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2010/10/25) : 신규작성
*********************************************************************/
CREATE PROC  [dbo].[PUT_F_FA_SURVEY_ANSWER_TB_PROC]
/*********************************************************************
* Interface Part
*********************************************************************/
(
  @SUTVEY_ID      INT                  -- 등록번호
, @strUserid      VARCHAR(30)          -- 등록자 아이디
, @strUserNm      VARCHAR(20)          -- 등록자 이름
, @strAge         TINYINT              -- 등록자 연령
, @strPost        CHAR(6)              -- 등록자 우편번호
, @strSex         CHAR(1)              -- 등록자 성별

, @strAddr        VARCHAR(200)         -- 등록자 주소
, @strEmail       VARCHAR(100)         -- 등록자 이메일
, @strJob         TINYINT              -- 등록자 직업
, @strTel         VARCHAR(50)          -- 등록자 연락처
, @strOBJECTIVE   VARCHAR(40)          -- 객관식 답
, @strSUBJECTIVE  VARCHAR(8000)        -- 주관식 답
, @strMULTIPLE    VARCHAR(70)          -- 복수응답 답
)
AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

INSERT INTO FA_SURVEY_ANSWER_TB
(
  SURVEY_ID
, USERID
, USERNM
, USERAGE
, POST
, ADDR

, EMAIL
, JOB
, TEL
, OBJECTIVE
, SUBJECTIVE

, MULTIPLE
, REG_DT
, SEX
)
VALUES
(
  @SUTVEY_ID
, @strUserid
, @strUserNm
, @strAge
, @strPost
, @strAddr

, @strEmail
, @strJob
, @strTel
, @strOBJECTIVE
, @strSUBJECTIVE

, @strMULTIPLE
, GETDATE()
, @strSex
)
IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

RETURN (1)

GO
/****** Object:  StoredProcedure [dbo].[PUT_F_LOCALEVENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장PLUS - 지역이벤트 글등록
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_LOCALEVENT_PROC]
    @BRANCH_CD    INT=0,
    @BOARDCODE    INT=0,
    @TITLE        VARCHAR(100)='',
    @USERID       VARCHAR(50)='',
    @USERNAME     VARCHAR(30)='',
    @CONTENTS     TEXT='',
    @IPADDR       VARCHAR(30)='',
    @PICFILE      VARCHAR(200)='',

    @IRESULT      INT=0 OUTPUT,
    @CUID         INT = NULL
AS

    DECLARE @SERIALNO INT

BEGIN TRAN

    INSERT INTO dbo.BD_LOCALEVENT_TB(
        BRANCH_CD,
        BOARDCODE,
        TITLE,
        USERID,
        USERNAME,
        CONTENTS,
        DELFLAG,
        VIEWCNT,
        IPADDR,

        RENO,
        STEP,
        SERIALNO,

        REGDATE,
        MODDATE,
        PICFILE,
        CUID
    )VALUES(
        @BRANCH_CD,
        @BOARDCODE,
        @TITLE,
        @USERID,
        @USERNAME,
        @CONTENTS,
        '0',
        0,
        @IPADDR,

        0,
        0,
        0,

        GETDATE(),
        NULL,
        @PICFILE,
        @CUID
    )

    SET @SERIALNO = SCOPE_IDENTITY()

    UPDATE dbo.BD_LOCALEVENT_TB
    SET SERIALNO=@SERIALNO
    WHERE
        SERIAL=@SERIALNO

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_F_LOCALEVENT_REPLY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장PLUS - 지역이벤트 답글 글등록
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_LOCALEVENT_REPLY_PROC]
    @SERIAL       INT=0,
    @BRANCH_CD    INT=0,
    @BOARDCODE    INT=0,
    @TITLE        VARCHAR(100)='',
    @USERID       VARCHAR(50)='',
    @USERNAME     VARCHAR(30)='',
    @CONTENTS     TEXT='',
    @IPADDR       VARCHAR(30)='',
    @PICFILE      VARCHAR(200)='',

    @IRESULT      INT=0 OUTPUT,
    @CUID         INT = NULL

AS

BEGIN TRAN

    DECLARE @SERIALNO    INT
    DECLARE @RENO        INT
    DECLARE @STEP        INT

    -- 원본글의 답변번호 및 들여쓰기
    SELECT
        @SERIALNO = SERIALNO,
        @RENO     = RENO,
        @STEP     = STEP
    FROM
        dbo.BD_LOCALEVENT_TB(NOLOCK)
    WHERE
        SERIAL = @SERIAL

    SET @RENO = @RENO + 1
    SET @STEP = @STEP + 1

    -- 기존의 답글 업데이트
    UPDATE dbo.BD_LOCALEVENT_TB
    SET
        RENO = @RENO + 1
    WHERE
        SERIALNO = @SERIALNO AND RENO > @RENO-1

    INSERT INTO dbo.BD_LOCALEVENT_TB(
        BRANCH_CD,
        BOARDCODE,
        TITLE,
        USERID,
        USERNAME,
        CONTENTS,
        DELFLAG,
        VIEWCNT,
        IPADDR,

        RENO,
        STEP,
        SERIALNO,

        REGDATE,
        MODDATE,
        PICFILE,
        CUID
    )VALUES(
        @BRANCH_CD,
        @BOARDCODE,
        @TITLE,
        @USERID,
        @USERNAME,
        @CONTENTS,
        '0',
        0,
        @IPADDR,

        @RENO,
        @STEP,
        @SERIALNO,

        GETDATE(),
        NULL,
        @PICFILE,
        @CUID
    )

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_F_LOCALNEWS_COMMENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 지역소식 - 댓글 달기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2010/10/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_LOCALNEWS_COMMENT_PROC]
	@NEWSSERIAL		INT,
	@USERID		    VARCHAR(50),
	@COMMENT	    VARCHAR(1000),

	@IRESULT	    INT=0	OUTPUT

AS

BEGIN TRAN
	--댓글 카운트 1증가
	UPDATE DBO.BD_LOCALNEWS_TB
	SET
		INQCNT = INQCNT + 1
	WHERE
		SERIAL = @NEWSSERIAL

	--댓글 삽입
	INSERT INTO DBO.BD_LOCALNEWS_COMMENT_TB(
		LOCALNEWSSERIAL,
		USERID,
		COMMENT,
		REGDATE
	)	VALUES (
		@NEWSSERIAL,
		@USERID,
		@COMMENT,
		GETDATE()
	)

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_FA_MAINFLAG_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 로그관리 > FLAG항목 저장
 *  작   성   자 : 이 경 덕
 *  작   성   일 : 2012-11-27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 :
 *  EXEC : DBO.PUT_FA_MAINFLAG_PROC

 *************************************************************************************/

CREATE PROC [dbo].[PUT_FA_MAINFLAG_PROC]
	    @SECTIONNM 	VARCHAR(20)
	  , @GBN 		VARCHAR(2)
	  , @FLAG 		VARCHAR(10)
	  , @FLAGNM 	VARCHAR(50)
AS

BEGIN

  INSERT INTO DBO.FA_MainFlag
  (
	  SectionNm
	, Gbn
	, Flag
	, FlagNm
  )
  VALUES
  (
	  @SECTIONNM
	, @GBN
	, @FLAG
	, @FLAGNM
  )

END

GO
/****** Object:  StoredProcedure [dbo].[PUT_FOOD_SEMINAR_EVENT_201102_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 창업세미나 등록
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2011/02/15) : 신규작성
*********************************************************************/
CREATE PROC  [dbo].[PUT_FOOD_SEMINAR_EVENT_201102_PROC]
(
	@strUserId		  VARCHAR(30)
,	@strUserNm    	VARCHAR(20)
,	@strPhone  		  VARCHAR(16)
,	@strHPhone    	VARCHAR(13)
, @strEmail       VARCHAR(100)
)
AS
SET NOCOUNT ON

INSERT INTO FOOD_SEMINAR_EVENT_201102
(
  	USERID
  ,	USERNM
  ,	PHONE
  ,	HPHONE
  ,	EMAIL
)
VALUES
(
  	@strUserId
  , @strUserNm
	, @strPhone

	, @strHPhone
	, @strEmail
)

IF @@ERROR <> 0
	BEGIN
		RETURN (-1)

	END

RETURN (1)

GO
/****** Object:  StoredProcedure [dbo].[PUT_FOOD_SEMINAR_EVENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
* Description
*
*  내용 : 창업세미나 등록
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 김문화(2011/05/13) : 신규작성
*********************************************************************/
CREATE PROC  [dbo].[PUT_FOOD_SEMINAR_EVENT_PROC]
(
	@strUserId		  VARCHAR(30)
,	@strUserNm    	VARCHAR(20)
,	@strPhone  		  VARCHAR(16)
,	@strHPhone    	VARCHAR(13)
, @strEmail       VARCHAR(100)
, @strEventDiv    CHAR(6)
)
AS
SET NOCOUNT ON

INSERT INTO FOOD_SEMINAR_EVENT
(
  	USERID
  ,	USERNM
  ,	PHONE
  ,	HPHONE
  ,	EMAIL
  , EVENT_DIV
)
VALUES
(
  	@strUserId
  , @strUserNm
	, @strPhone

	, @strHPhone
	, @strEmail
  , @strEventDiv
)

IF @@ERROR <> 0
	BEGIN
		RETURN (-1)

	END

RETURN (1)

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_ARTICLE_THEME_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 글마당 테마등록
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_ARTICLE_THEME_PROC]
	@TITLE		NVARCHAR(30),
	@IMGURL		VARCHAR(200)=NULL,
	@COMMENT	NVARCHAR(500),

	@IRESULT	INT=0 OUTPUT
AS

BEGIN TRAN

	INSERT INTO DBO.READERROUND2(TITLE, IMGURL, COMMENT)
	VALUES(@TITLE, @IMGURL, @COMMENT)

	IF @@ROWCOUNT>1 OR @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_BRANCH_BANNER_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배너관리 > 지역별 배너 등록
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2013-02-13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_M_BRANCH_BANNER_PROC 0, 'Koala_25_A.gif', '이벤트배너1', 'A', 'www.naver.com', 0, '2013-01-24', '2013-01-31', 1
 *************************************************************************************/


CREATE PROC [dbo].[PUT_M_BRANCH_BANNER_PROC]

   @INPUT_BRANCH TINYINT
  ,@LOCAL_BRANCH VARCHAR(50)
  ,@BANNER_PATH VARCHAR(100)		--이미지경로
  ,@BANNER_NAME VARCHAR(100)		--배너명
  ,@BANNER_GBN CHAR(1)				--배너유형
  ,@BANNER_URL VARCHAR(100)			--배너이동주소
  ,@TARGET TINYINT					--배너타겟(0:본창 1:새창)
  ,@STARTDT DATETIME                --시작일
  ,@ENDDT DATETIME                  --종료일
  ,@DISF  BIT                       --게재여부(0:게재 1:미게재)
  ,@MAGID VARCHAR(20)
AS

  SET NOCOUNT ON

  BEGIN
    INSERT INTO FA_BANNER_MANAGE_TB
      (INPUT_BRANCH, LOCAL_BRANCH, BANNER_NM, BANNER_PATH, BANNER_URL, BANNER_GBN, TARGET, START_DT, END_DT, DISF)
    VALUES
      (@INPUT_BRANCH, @LOCAL_BRANCH, @BANNER_NAME, @BANNER_PATH, @BANNER_URL, @BANNER_GBN, @TARGET, @STARTDT, @ENDDT, @DISF)

	DECLARE @IDX INT
	SELECT @IDX = MAX(IDX) FROM FA_BANNER_MANAGE_TB

	INSERT INTO FA_BANNER_HISTORY_TB
	( BANNER_IDX, INPUT_BRANCH, LOCAL_BRANCH, BANNER_NM, BANNER_PATH, BANNER_URL, BANNER_GBN, TARGET, START_DT, END_DT, DISF, MAINF, DELF, READ_CNT, MAG_ID )
	SELECT
	  IDX,
	  INPUT_BRANCH,
	  LOCAL_BRANCH,
	  BANNER_NM,
	  BANNER_PATH,
	  BANNER_URL,
	  BANNER_GBN,
	  TARGET,
	  START_DT,
	  END_DT,
	  DISF,
	  MAINF,
	  DELF,
	  READ_CNT,
	  @MAGID
	FROM FA_BANNER_MANAGE_TB
	  WHERE IDX = @IDX
  END

  SELECT MAX(IDX)
	  FROM FA_BANNER_MANAGE_TB

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_BRANCH_READCOUNT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배너관리 > 조회수 증가
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2013-02-13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC PUT_M_BRANCH_READCOUNT_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[PUT_M_BRANCH_READCOUNT_PROC]

   @IDX INT
AS

SET NOCOUNT ON

 UPDATE FA_BANNER_MANAGE_TB
   SET READ_CNT = READ_CNT + 1
  WHERE IDX = @IDX

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_ESSAY_CATEGORY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 정보마당 카테고리등록
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_ESSAY_CATEGORY_PROC]
	@LCODE				SMALLINT,			-- 대분류 코드
	@MNAME				VARCHAR(100),	-- 추가할 중분류 명
	@DESCRIPTION	VARCHAR(200),	-- 설명
	@DISFLAG			TINYINT,			-- 노출여부 1:노출, 2:비노출

	@IRESULT 			INT = 0 OUTPUT
AS

	DECLARE @CODE INT
	DECLARE @LNAME VARCHAR(100)
	DECLARE @MCODE SMALLINT

	-- 새로입력하려는 분류와 동일한 분류명이 존재한다면
	IF EXISTS (SELECT NULL FROM DBO.NESSAYCODE WHERE LCODE=@LCODE AND MNAME=@MNAME)
		BEGIN
			SET @IRESULT = -1	--# 분류명이 존재
			RETURN
		END
	ELSE
		BEGIN
			-- 입력할 대분류의 최대코드값, 대분류명, 최대 중분류 코드 가져오기
			SELECT
				@CODE 	= MAX(CODE),
				@LNAME 	= MAX(LNAME),
				@MCODE	= MAX(MCODE)
			FROM
				DBO.NESSAYCODE(NOLOCK)
			WHERE
				LCODE = @LCODE

			SET @CODE		= @CODE + 2
			SET @MCODE 	= @MCODE + 2

			BEGIN TRAN
				INSERT INTO DBO.NESSAYCODE(
					CODE,
					LCODE,
					LNAME,
					MCODE,
					MNAME,
					DESCRIPTION,
					DISFLAG
				) VALUES (
					@CODE,
					@LCODE,
					@LNAME,
					@MCODE,
					@MNAME,
					@DESCRIPTION,
					@DISFLAG
				)

				IF @@ROWCOUNT>1 OR @@ERROR>1
					BEGIN
						SET @IRESULT = -2
						ROLLBACK TRAN
						RETURN
					END
				ELSE
					BEGIN
						SET @IRESULT = 1
						COMMIT TRAN
						RETURN
					END

		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_F_ARTICLE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 벼룩시장 이벤트 독자글마당 글 등록
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : CUID도 입력 함
 *  사 용  소 스 :
 *  사 용  예 제 :
 declare @p9 int
set @p9=NULL
exec [dbo].[PUT_M_F_ARTICLE_PROC] @NDX=10,@TITLE=N'sdfsdfs',@USERID=N'bird3658',@USERNAME=N'부동산',@EMAIL=N'bird3325@daum.net',@CONTENTS='dfsdf',@IPADDR=N'121.166.161.16',@CUID=13821491,@IRESULT=@p9 output
select @p9
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_F_ARTICLE_PROC]
	@NDX				INT,
	@TITLE			VARCHAR(100),
	@USERID			VARCHAR(50),
	@USERNAME		VARCHAR(30),
	@EMAIL			VARCHAR(50),
	@CONTENTS		TEXT,
	@IPADDR			VARCHAR(30),
	@CUID				INT = 0,
	@IRESULT		INT=0 OUTPUT
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE	@REF	INT
	DECLARE @BANNER_ID INT
	DECLARE @THEMA VARCHAR(50)

	IF @NDX = 10 
	BEGIN
		SET @THEMA = '살아가는 이야기'
	END 
	ELSE IF @NDX = 21 
	BEGIN
		SET @THEMA = '자작글'
	END
	ELSE IF @NDX = 25
	BEGIN
		SET @THEMA = '벼룩시장 관련 에피소드'
	END
	
	SELECT TOP 1 @BANNER_ID = BANNER_ID
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB
	WHERE DEL_YN = 'N'
	AND VIEW_TYPE = '1'
	AND EVENT_TYPE = 4
	ORDER BY BANNER_ID DESC

	INSERT INTO FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB (
		BANNER_ID
		, TITLE
		, CONTENT
		, CUID
		, STATS
		, LOTTERY_ID
		, LOTTERY_YN
		, DEL_YN
		, REG_DATE
		, USERID
		, USERNAME
		, THEMA
	) VALUES (
		@BANNER_ID
		, @TITLE
		, @CONTENTS
		, @CUID
		, 'Y'
		, 0
		, 'N'
		, 'N'
		, GETDATE()
		, @USERID
		, @USERNAME	
		, @THEMA	
	)

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			RETURN
		END
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_F_ARTICLE_PROC_BAK01]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 벼룩시장 이벤트 독자글마당 글 등록
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : CUID도 입력 함
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_F_ARTICLE_PROC_BAK01]
	@NDX				INT,
	@TITLE			VARCHAR(100),
	@USERID			VARCHAR(50),
	@USERNAME		VARCHAR(30),
	@EMAIL			VARCHAR(50),
	@CONTENTS		TEXT,
	@IPADDR			VARCHAR(30),
	@CUID				INT = 0,
	@IRESULT		INT=0 OUTPUT
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE	@REF	INT
	DECLARE @BANNER_ID INT
	
	SELECT TOP 1 @BANNER_ID = BANNER_ID
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB
	WHERE DEL_YN = 'N'
	AND VIEW_TYPE = '1'
	AND EVENT_TYPE = 4
	ORDER BY BANNER_ID DESC

	INSERT INTO FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB (
		BANNER_ID
		, TITLE
		, CONTENT
		, CUID
		, STATS
		, LOTTERY_YN
		, DEL_YN
		, REG_DATE
		, USERID
		, USERNAME
	) VALUES (
		@BANNER_ID
		, @TITLE
		, @CONTENTS
		, @CUID
		, 'Y'
		, 'N'
		, 'N'
		, GETDATE()
		, @USERID
		, @USERNAME		
	)

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_F_ARTICLE_PROC_BAK180720]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 벼룩시장 이벤트 독자글마당 글 등록
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/02/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : CUID도 입력 함
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_F_ARTICLE_PROC_BAK180720]
	@NDX				INT,
	@TITLE			VARCHAR(100),
	@USERID			VARCHAR(50),
	@USERNAME		VARCHAR(30),
	@EMAIL			VARCHAR(50),
	@CONTENTS		TEXT,
	@IPADDR			VARCHAR(30),
	@CUID				INT = 0,
	@IRESULT		INT=0 OUTPUT
AS
	DECLARE	@REF	INT

BEGIN TRAN
	INSERT INTO DBO.READEREVENT2(
		NDX,
		TITLE,
		LOWREF,
		STEP,
		USERID,
		USERNAME,
		EMAIL,
		CONTENTS,
		IPADDR,
		CUID
	) VALUES (
		@NDX,
		@TITLE,
		1,
		1,
		@USERID,
		@USERNAME,
		@EMAIL,
		@CONTENTS,
		@IPADDR,
		@CUID
	)

	SET @REF = SCOPE_IDENTITY()

	UPDATE
		DBO.READEREVENT2
	SET
		REF = @REF
	WHERE
		IDX = @REF

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			ROLLBACK TRAN
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			COMMIT TRAN
			RETURN
		END
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_F_LOCALEVENT_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트(스도쿠, 포토이벤트) 글등록
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :

 exec [PUT_M_F_LOCALEVENT_PROC] 0,2,'test','asdasd','name','dkfjsldkfjslkdfjlskd','118.128.248.2','Bbs201195215738_1121211.jpg','','12249716', ''
 exec PUT_M_F_LOCALEVENT_PROC @BRANCH_CD=0,@BOARDCODE=3,@TITLE=N'ㄴㅁㅇㄹㄴㅇㅁㄹ',@USERID=N'bird3658',@USERNAME=N'부동산',@CONTENTS='ㄴㅁㅇㄹㄴㅁㅇㄹ',@IPADDR=N'121.166.161.16',@PICFILE=N'',@CUID=13821491,@IRESULT=0
 declare @p10 int
set @p10=NULL
exec [dbo].[PUT_M_F_LOCALEVENT_PROC] @BRANCH_CD=0,@BOARDCODE=3,@TITLE=N'SDFSD',@USERID=N'bird3658',@USERNAME=N'부동산',@CONTENTS='SDFSDF',@IPADDR=N'121.166.161.16',@PICFILE=N'',@CUID=13821491,@IRESULT=@p10 output
select @p10
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_F_LOCALEVENT_PROC]
    @BRANCH_CD    INT = 0,
    @BOARDCODE    INT = 0,
    @TITLE        VARCHAR(100) = '',
    @USERID       VARCHAR(50) = '',
    @USERNAME     VARCHAR(30) = '',
    @CONTENTS     TEXT = '',
    @IPADDR       VARCHAR(30) = '',
    @PICFILE      VARCHAR(200) = '',
    @CUID         INT = NULL,
    @IRESULT      INT = 0 OUTPUT
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

    DECLARE @SERIALNO INT
	DECLARE @EVENT_TYPE INT
	DECLARE @BANNER_ID INT

	IF @BOARDCODE = '1' 		--포토갤러리
	BEGIN
		SET @EVENT_TYPE = 2
	END
	ELSE IF @BOARDCODE = '2'	--스도쿠
	BEGIN
		SET @EVENT_TYPE = 3
	END
	ELSE IF @BOARDCODE = '3'	--행시
	BEGIN
		SET @EVENT_TYPE = 1
	END 

	EXEC FINDDB1.PAPER_NEW.DBO.PUT_M_F_LOCALEVENT_PROC @BRANCH_CD,@BOARDCODE,@TITLE,@USERID,@USERNAME,@CONTENTS,@IPADDR,@PICFILE,@CUID,@IRESULT OUTPUT

	--SELECT TOP 1 @BANNER_ID = BANNER_ID
	--FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB
	--WHERE DEL_YN = 'N'
	--AND VIEW_TYPE = '1'
	--AND EVENT_TYPE = @EVENT_TYPE
	--ORDER BY BANNER_ID DESC

	--INSERT INTO FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB (
	--	BANNER_ID
	--	, TITLE
	--	, CONTENT
	--	, CUID
	--	, IMG_PATH
	--	, STATS
	--	, LOTTERY_YN
	--	, DEL_YN
	--	, REG_DATE
	--	, USERID
	--	, USERNAME
	--) VALUES (
	--	@BANNER_ID
	--	, @TITLE
	--	, @CONTENTS
	--	, @CUID
	--	, @PICFILE
	--	, 'Y'
	--	, 'N'
	--	, 'N'
	--	, GETDATE()
	--	, @USERID
	--	, @USERNAME		
	--)


END
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_F_LOCALEVENT_PROC_BAK01]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트(스도쿠, 포토이벤트) 글등록
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :

 exec [PUT_M_F_LOCALEVENT_PROC] 0,2,'test','asdasd','name','dkfjsldkfjslkdfjlskd','118.128.248.2','Bbs201195215738_1121211.jpg','','12249716', ''

 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_F_LOCALEVENT_PROC_BAK01]
    @BRANCH_CD    INT = 0,
    @BOARDCODE    INT = 0,
    @TITLE        VARCHAR(100) = '',
    @USERID       VARCHAR(50) = '',
    @USERNAME     VARCHAR(30) = '',
    @CONTENTS     TEXT = '',
    @IPADDR       VARCHAR(30) = '',
    @PICFILE      VARCHAR(200) = '',
    @CUID         INT = NULL,
    @IRESULT      INT = 0 OUTPUT
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

    DECLARE @SERIALNO INT
	DECLARE @EVENT_TYPE INT
	DECLARE @BANNER_ID INT

	IF @BOARDCODE = '1' 		--포토갤러리
	BEGIN
		SET @EVENT_TYPE = 2
	END
	ELSE IF @BOARDCODE = '2'	--스도쿠
	BEGIN
		SET @EVENT_TYPE = 3
	END
	ELSE IF @BOARDCODE = '3'	--행시
	BEGIN
		SET @EVENT_TYPE = 1
	END 

	SELECT TOP 1 @BANNER_ID = BANNER_ID
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_BANNER_TB
	WHERE DEL_YN = 'N'
	AND VIEW_TYPE = '1'
	AND EVENT_TYPE = @EVENT_TYPE
	ORDER BY BANNER_ID DESC

	INSERT INTO FINDDB1.PAPER_NEW.DBO.EVENT_RE_TB (
		BANNER_ID
		, TITLE
		, CONTENT
		, CUID
		, IMG_PATH
		, STATS
		, LOTTERY_YN
		, DEL_YN
		, REG_DATE
		, USERID
		, USERNAME
	) VALUES (
		@BANNER_ID
		, @TITLE
		, @CONTENTS
		, @CUID
		, @PICFILE
		, 'Y'
		, 'N'
		, 'N'
		, GETDATE()
		, @USERID
		, @USERNAME		
	)

	IF @@ERROR > 1
	BEGIN
		SET @IRESULT = -1
		ROLLBACK TRAN
		RETURN
	END
	ELSE
	BEGIN
		SET @IRESULT = 1
		COMMIT TRAN
		RETURN
	END
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_F_LOCALEVENT_PROC_BAK180720]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 지역이벤트(스도쿠, 포토이벤트) 글등록
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :

 exec [PUT_M_F_LOCALEVENT_PROC] 0,2,'test','asdasd','name','dkfjsldkfjslkdfjlskd','118.128.248.2','Bbs201195215738_1121211.jpg','','12249716', ''

 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_F_LOCALEVENT_PROC_BAK180720]
    @BRANCH_CD    INT = 0,
    @BOARDCODE    INT = 0,
    @TITLE        VARCHAR(100) = '',
    @USERID       VARCHAR(50) = '',
    @USERNAME     VARCHAR(30) = '',
    @CONTENTS     TEXT = '',
    @IPADDR       VARCHAR(30) = '',
    @PICFILE      VARCHAR(200) = '',
    @CUID         INT = NULL,
    @IRESULT      INT = 0 OUTPUT
AS
    DECLARE @SERIALNO INT

BEGIN TRAN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  INSERT INTO dbo.BD_LOCALEVENT_TB (
      BRANCH_CD,
      BOARDCODE,
      TITLE,
      USERID,
      USERNAME,
      CONTENTS,
      DELFLAG,
      VIEWCNT,
      IPADDR,
      RENO,
      STEP,
      SERIALNO,
      REGDATE,
      MODDATE,
      PICFILE,
      CUID
  ) VALUES (
      @BRANCH_CD,
      @BOARDCODE,
      @TITLE,
      @USERID,
      @USERNAME,
      @CONTENTS,
      '0',
      0,
      @IPADDR,
      0,
      0,
      0,
      GETDATE(),
      NULL,
      @PICFILE,
      @CUID
  )

  SET @SERIALNO = SCOPE_IDENTITY()

  UPDATE dbo.BD_LOCALEVENT_TB
  SET SERIALNO=@SERIALNO
  WHERE SERIAL=@SERIALNO

	IF @@ERROR > 1
	BEGIN
		SET @IRESULT = -1
		ROLLBACK TRAN
		RETURN
	END
	ELSE
	BEGIN
		SET @IRESULT = 1
		COMMIT TRAN
		RETURN
	END
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_FA_SURVEY_QUESTION_TB_MULTIPLE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	 :	PUT_M_FA_SURVEY_QUESTION_TB_MULTIPLE_PROC
 설명	 :	설문조사 질문 등록 복수응답
작성자 :  정태운
작성일 :	2010-10-15
==============================================================================*/
CREATE PROC [dbo].[PUT_M_FA_SURVEY_QUESTION_TB_MULTIPLE_PROC]
(
  @SURVEY_ID       INT             -- 설문등록번호
, @ANSWER_CNT      TINYINT         -- 답변갯수
, @QUESTION_TITLE  VARCHAR(200)    -- 질문내용
, @ANSWER1         VARCHAR(200)    -- 답변1내용
, @ANSWER2         VARCHAR(200)    -- 답변2내용

, @ANSWER3         VARCHAR(200)    -- 답변3내용
, @ANSWER4         VARCHAR(200)    -- 답변4내용
, @ANSWER5         VARCHAR(200)    -- 답변5내용
, @ANSWER6         VARCHAR(200)    -- 답변6내용
, @RESPONSE_CNT    TINYINT         -- 응답갯수
, @INDEX_NUM       INT             -- 노출순서
)
AS
SET NOCOUNT ON

INSERT INTO FA_SURVEY_QUESTION_TB(
            SURVEY_ID
          , QUESTION_DIV
          , ANSWER_CNT
          , QUESTION_TITLE
          , ANSWER1

          , ANSWER2
          , ANSWER3
          , ANSWER4
          , ANSWER5
          , ANSWER6

          , RESPONSE_CNT
          , INPUT_DIV
          , CHAR_LIMIT_CNT
          , INDEX_NUM
          , REG_DT
) VALUES(
            @SURVEY_ID
          , 'M'
          , @ANSWER_CNT
          , @QUESTION_TITLE
          , @ANSWER1

          , @ANSWER2
          , @ANSWER3
          , @ANSWER4
          , @ANSWER5
          , @ANSWER6

          , @RESPONSE_CNT
          , ''
          , 0
          , @INDEX_NUM
          , GETDATE()
)


IF @@ERROR <> 0
BEGIN
	RETURN (-1)

END

RETURN 1

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_FA_SURVEY_QUESTION_TB_OBJECTIVE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	 :	PUT_M_FA_SURVEY_QUESTION_TB_OBJECTIVE_PROC
 설명	 :	설문조사 질문 등록 객관식
작성자 :  정태운
작성일 :	2010-10-15
==============================================================================*/
CREATE PROC [dbo].[PUT_M_FA_SURVEY_QUESTION_TB_OBJECTIVE_PROC]
(
  @SURVEY_ID       INT             -- 설문등록번호
, @ANSWER_CNT      TINYINT         -- 답변갯수
, @QUESTION_TITLE  VARCHAR(1000)    -- 질문내용
, @ANSWER1         VARCHAR(200)    -- 답변1내용
, @ANSWER2         VARCHAR(200)    -- 답변2내용

, @ANSWER3         VARCHAR(200)    -- 답변3내용
, @ANSWER4         VARCHAR(200)    -- 답변4내용
, @ANSWER5         VARCHAR(200)    -- 답변5내용
, @ANSWER6         VARCHAR(200)    -- 답변6내용
, @INDEX_NUM       INT             -- 노출순서
)
AS
SET NOCOUNT ON

INSERT INTO FA_SURVEY_QUESTION_TB(
            SURVEY_ID
          , QUESTION_DIV
          , ANSWER_CNT
          , QUESTION_TITLE
          , ANSWER1

          , ANSWER2
          , ANSWER3
          , ANSWER4
          , ANSWER5
          , ANSWER6

          , RESPONSE_CNT
          , INPUT_DIV
          , CHAR_LIMIT_CNT
          , INDEX_NUM
          , REG_DT
) VALUES(
            @SURVEY_ID
          , 'O'
          , @ANSWER_CNT
          , @QUESTION_TITLE
          , @ANSWER1

          , @ANSWER2
          , @ANSWER3
          , @ANSWER4
          , @ANSWER5
          , @ANSWER6

          , 0
          , ''
          , 0
          , @INDEX_NUM
          , GETDATE()
)


IF @@ERROR <> 0
BEGIN
	RETURN (-1)

END

RETURN 1

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_FA_SURVEY_QUESTION_TB_SUBJECTIVE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	 :	PUT_M_FA_SURVEY_QUESTION_TB_SUBJECTIVE_PROC
 설명	 :	설문조사 질문 등록 쭈관식
작성자 :  정태운
작성일 :	2010-10-15
==============================================================================*/
CREATE PROC [dbo].[PUT_M_FA_SURVEY_QUESTION_TB_SUBJECTIVE_PROC]
(
  @SURVEY_ID       INT             -- 설문등록번호
, @QUESTION_TITLE  VARCHAR(200)    -- 질문내용
, @INDEX_NUM       INT             -- 노출순서
, @INPUT_DIV       CHAR(1)         -- 입력창구분
, @CHAR_LIMIT_CNT  INT             -- 글자수제한
)
AS
SET NOCOUNT ON

INSERT INTO FA_SURVEY_QUESTION_TB(
            SURVEY_ID
          , QUESTION_DIV
          , ANSWER_CNT
          , QUESTION_TITLE
          , ANSWER1

          , ANSWER2
          , ANSWER3
          , ANSWER4
          , ANSWER5
          , ANSWER6

          , RESPONSE_CNT
          , INPUT_DIV
          , CHAR_LIMIT_CNT
          , INDEX_NUM
          , REG_DT
) VALUES(
            @SURVEY_ID
          , 'S'
          , 0
          , @QUESTION_TITLE
          , ''

          , ''
          , ''
          , ''
          , ''
          , ''

          , 0
          , @INPUT_DIV
          , @CHAR_LIMIT_CNT
          , @INDEX_NUM
          , GETDATE()
)


IF @@ERROR <> 0
BEGIN
	RETURN (-1)

END

RETURN 1

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_FA_SURVEY_TB_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	 :	PUT_M_FA_SURVEY_TB_PROC
 설명	 :	설문조사 기초정보 등록
작성자 :  정태운
작성일 :	2010-10-13
==============================================================================*/
CREATE PROC [dbo].[PUT_M_FA_SURVEY_TB_PROC]
(
  @MANAGE_AREA     TINYINT         -- 관리지역
, @MANAGE_NM       VARCHAR(20)     -- 담당자
, @TITLE           VARCHAR(200)    -- 제목
, @JOIN_DIV        CHAR(1)         -- 참여대상(N:비회원, Y:회원)
, @START_DT        DATETIME        -- 설문기간시작

, @END_DT          DATETIME        -- 설문기간끝
, @PRIZE_YN        CHAR(1)         -- 경품유무(N:없음, Y:있음)
, @PRIZE_CONTS     VARCHAR(1000)   -- 경품내용
, @PRIZE_IMG       VARCHAR(200)    -- 경품이미지
, @PRIZE_DT        DATETIME        -- 당첨자발표날짜

, @GIVE_DT         DATETIME        -- 경품발송날짜
, @OBJECTIVE_CNT   TINYINT         -- 객관식수
, @SUBJECTIVE_CNT  TINYINT         -- 주관식수
, @MULTIPLE_CNT    TINYINT         -- 멀티선택수
, @PROGRESS_DIV    CHAR(1)         -- 진행구분

, @REG_ID          VARCHAR(30)     -- 등록자ID
, @REG_NM          VARCHAR(20)     -- 등록자이름
)
AS
SET NOCOUNT ON

DECLARE @SURVEY_ID		INT
DECLARE @END_DT_M			VARCHAR(23)

SET @END_DT_M = @END_DT + ' 23:59:59.000'

	INSERT INTO FA_SURVEY_TB(
              MANAGE_AREA
            , MANAGE_NM
            , TITLE
            , JOIN_DIV
            , START_DT

            , END_DT
            , PRIZE_YN
            , PRIZE_CONTS
            , PRIZE_IMG
            , PRIZE_DT

            , GIVE_DT
            , OBJECTIVE_CNT
            , SUBJECTIVE_CNT
            , MULTIPLE_CNT
            , PROGRESS_DIV

            , REG_ID
            , REG_NM
            , REG_DT
            , DEL_YN
            )
	VALUES	(
              @MANAGE_AREA
            , @MANAGE_NM
            , @TITLE
            , @JOIN_DIV
            , @START_DT

            , @END_DT_M
            , @PRIZE_YN
            , @PRIZE_CONTS
            , @PRIZE_IMG
            , @PRIZE_DT

            , @GIVE_DT
            , @OBJECTIVE_CNT
            , @SUBJECTIVE_CNT
            , @MULTIPLE_CNT
            , @PROGRESS_DIV

            , @REG_ID
            , @REG_NM
            , GETDATE()
            , 'N'
            )

	IF @@ERROR <> 0
	BEGIN
		RETURN (-1)

	END


  SET @SURVEY_ID = (SELECT TOP 1 SURVEY_ID FROM FA_SURVEY_TB ORDER BY SURVEY_ID DESC)

	RETURN (@SURVEY_ID)

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_MAGBOX_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 벼룩시장정보관리 - 줄, 박스광고 요금안내 데이터 입력
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_MAGBOX_PROC]
	@SERIAL 			INT = NULL,
	@LOCALBRANCH	INT = NULL,
	@BOXID				VARCHAR(50),
	@BOXCONTENTS1	TEXT,
	@BOXCONTENTS2	TEXT
AS


  DECLARE @CNT INT

  --기존 데이터 삭제
/*
  IF EXISTS (SELECT NULL FROM MAGBOX WHERE SERIAL=@SERIAL)
  BEGIN
    DELETE FROM MAGBOX WHERE SERIAL = @SERIAL
  END
*/
  SELECT @CNT = COUNT(*)
    FROM MAGBOX
   WHERE BOXID = @BOXID
     AND LOCALBRANCH = @LOCALBRANCH
     AND SERIAL = @SERIAL

  IF @CNT > 0
    BEGIN
      UPDATE MAGBOX
         SET BOXCONTENTS1 = @BOXCONTENTS1
             ,BOXCONTENTS2 = @BOXCONTENTS2
       WHERE BOXID = @BOXID
         AND LOCALBRANCH = @LOCALBRANCH
         AND SERIAL = @SERIAL
    END
  ELSE
    BEGIN
    --신규 데이터 입력
      INSERT INTO DBO.MAGBOX
             (LOCALBRANCH, BOXID, BOXCONTENTS1, BOXCONTENTS2)
      VALUES ( @LOCALBRANCH, @BOXID, @BOXCONTENTS1, @BOXCONTENTS2 )
    END

GO
/****** Object:  StoredProcedure [dbo].[PUT_M_PLUS_CATEGORY_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 컨텐츠관리 - 벼룩시장플러스 개편 - 카테고리 추가
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/07/27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_PLUS_CATEGORY_PROC]
	@CATEGORYGUBUN	CHAR(1),				-- 대분류/중분류 구분 : L/M
	@LCODE					SMALLINT,				-- 중분류 입력시 대분류코드
	@CATEGORYNAME		VARCHAR(100),		-- 분류명
	@DISFLAG				TINYINT,				-- 사용여부(1:사용, 0:미사용)

	@IRESULT				INT=0	OUTPUT
AS

	DECLARE @MAX_LCODE 	INT
	DECLARE @LNAME 			VARCHAR(100)
	DECLARE @MAX_MCODE 	SMALLINT
	DECLARE @MNAME 			VARCHAR(100)

	--# 대분류입력이라면
	IF @CATEGORYGUBUN = 'L'
		BEGIN

			IF EXISTS(SELECT NULL FROM DBO.NESSAYCODE(NOLOCK) WHERE LNAME=@CATEGORYNAME)
				BEGIN
					SET @IRESULT = -1	--# 분류명이 존재
					RETURN
				END
			ELSE
				BEGIN
					-- 현재 등록된 대분류 코드의 최대값+10 가져오기
					SELECT @MAX_LCODE = (MAX(LCODE)+10) FROM DBO.NESSAYCODE(NOLOCK)

					BEGIN TRAN
						INSERT INTO DBO.NESSAYCODE(
							CODE,
							LCODE,
							LNAME,
							MCODE,
							MNAME,
							DESCRIPTION,
							CNT,
							DISFLAG
						) VALUES (
							@MAX_LCODE*100,
							@MAX_LCODE,
							@CATEGORYNAME,
							0,
							'',
							'',
							0,
							@DISFLAG
						)

						IF @@ROWCOUNT>1 OR @@ERROR>1	-- 에러
							BEGIN
								SET @IRESULT = -2
								ROLLBACK TRAN
								RETURN
							END
						ELSE	-- 성공
							BEGIN
								SET @IRESULT = 1
								COMMIT TRAN
								RETURN
							END
				END

		END

	--# 중분류입력이라면
	ELSE IF @CATEGORYGUBUN = 'M'
		BEGIN

			IF EXISTS(SELECT NULL FROM DBO.NESSAYCODE(NOLOCK) WHERE MNAME=@CATEGORYNAME)
				BEGIN
					SET @IRESULT = -1	--# 분류명이 존재
					RETURN
				END
			ELSE
				BEGIN

					SELECT
						TOP 1
						@LNAME 			= LNAME, 			-- 대분류명
						@MAX_MCODE 	= MCODE 			-- 중분류코드 최대값
					FROM
						DBO.NESSAYCODE(NOLOCK)
					WHERE
						LCODE=@LCODE
					ORDER BY
						MCODE DESC

					IF @MAX_MCODE = 0 	-- 대분류만 있고 입력된 중분류가 없을 경우
						SET @MAX_MCODE = 10
					ELSE								-- 기존에 입력된 중분류가 있을 경우
						SET @MAX_MCODE = @MAX_MCODE + 2

					BEGIN TRAN
						INSERT INTO DBO.NESSAYCODE(
							CODE,
							LCODE,
							LNAME,
							MCODE,
							MNAME,
							DESCRIPTION,
							CNT,
							DISFLAG
						) VALUES (
							(@LCODE*100 + @MAX_MCODE),
							@LCODE,
							@LNAME,
							@MAX_MCODE,
							@CATEGORYNAME,
							'',
							0,
							@DISFLAG
						)

						IF @@ROWCOUNT>1 OR @@ERROR>1	-- 에러
							BEGIN
								SET @IRESULT = -2
								ROLLBACK TRAN
								RETURN
							END
						ELSE	-- 성공
							BEGIN
								SET @IRESULT = 1
								COMMIT TRAN
								RETURN
							END
				END

		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_NESSAYCOMMENT_MEMO_TB_DEL_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 정보마당 댓글의 답변 삭제
 *  작   성   자 : 정태운
 *  작   성   일 : 2010/01/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_NESSAYCOMMENT_MEMO_TB_DEL_PROC]
  @IDX            INT
,	@SERIAL		      INT
,	@ESSAYSERIAL		INT

,	@IRESULT	INT=0	OUTPUT

AS
	--답변 수정
  DELETE DBO.NESSAYCOMMENT_MEMO_TB
  WHERE IDX = @IDX
    AND SERIAL = @SERIAL
    AND ESSAYSERIAL = @ESSAYSERIAL

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_NESSAYCOMMENT_MEMO_TB_REG_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 PLUS - 정보마당 댓글의 답변 달기
 *  작   성   자 : 정태운
 *  작   성   일 : 2010/01/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[PUT_NESSAYCOMMENT_MEMO_TB_REG_PROC]
	@SERIAL		      INT
,	@ESSAYSERIAL		INT
, @MEMO      VARCHAR(500)
, @USERID    VARCHAR(50)
, @USERNM    VARCHAR(30)

,	@IRESULT	INT=0	OUTPUT

AS
	--답변 삽입
  INSERT INTO DBO.NESSAYCOMMENT_MEMO_TB(
		SERIAL
,		ESSAYSERIAL
,   MEMO
,   USERID
,   USERNM
,   REG_DT
	)	VALUES (
		@SERIAL,
		@ESSAYSERIAL,
		@MEMO,
		@USERID,
		@USERNM,
		GETDATE()
	)

	IF @@ERROR>1
		BEGIN
			SET @IRESULT = -1
			RETURN
		END
	ELSE
		BEGIN
			SET @IRESULT = 1
			RETURN
		END

GO
/****** Object:  StoredProcedure [dbo].[SET_FINDJOB_CLICKLOG]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SET_FINDJOB_CLICKLOG]
       @FROMDT     VARCHAR(10)
     , @CNT        INT
AS

SET NOCOUNT ON

UPDATE CM_JOB_REFERRER_FINDALL_TB
   SET CNT = @CNT
 WHERE LOG_DT = @FROMDT

IF @@ROWCOUNT=0
BEGIN
	INSERT CM_JOB_REFERRER_FINDALL_TB
       ( LOG_DT, CNT )
  VALUES
       ( @FROMDT, @CNT)

END

GO
/****** Object:  StoredProcedure [dbo].[sp_FA_Event_Tb_Click_cnt_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	:	sp_FA_Event_Tb_Click_cnt_PROC
 설명	:	이벤트 등록
작성자    :             정태운
작성일	:	2009-10-19
==============================================================================*/
CREATE PROC [dbo].[sp_FA_Event_Tb_Click_cnt_PROC]

@nEventId           	int			-- eventId

AS
BEGIN

	SET NOCOUNT ON

	DECLARE @nReadCnt	Int	-- 조회수

	--  카운트 계산
	SET @nReadCnt = (select read_cnt from fa_event_tb where EventId = @nEventId)
	SET @nReadCnt = @nReadCnt + 1

	-- 카운트 넣기
	UPDATE fa_event_tb SET
	read_cnt = @nReadCnt
	WHERE EventId = @nEventId

	IF @@ERROR <> 0
	BEGIN
		SET NOCOUNT OFF
		RETURN (-1)

	END

	SET NOCOUNT OFF
	RETURN (1)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Section_PopKwdsList]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 인기 검색어 노출 관련 리스트
	제작자		: 박준희
	제작일		: 2005.06.10
	수정자		: 박준희
	수정일		: 2005.06.10
	수정내용	: 각 섹션별 인기  검색어 노출 데이터 출력
	파라미터              :
use FindContents

SELECT Site, isManual, Kwd  FROM Konan.PopKwds With (NoLock)
	Order By Site

******************************************************************************/

CREATE PROCEDURE  [dbo].[sp_Section_PopKwdsList]
--(
	--@SectionGbn	tinyint		= 0,
	--@outprm		int 		= 0
--)


AS
SET NOCOUNT ON
BEGIN


	SELECT SectionGbn,  Kwd  FROM PopKwds With (NoLock)
	Order By SectionGbn














END

GO
/****** Object:  StoredProcedure [dbo].[updateLifeLinkViewCnt_DelAN]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updateLifeLinkViewCnt_DelAN]
(
	@Gubun char(1),
	@Serial int
)
AS

BEGIN

	IF @Gubun = '1'		--  인기검색어
		BEGIN
			UPDATE LifeLinkKeywd SET ViewCnt = ISNULL(ViewCnt,0) + 1 WHERE Serial = @Serial
			SELECT Keywd FROM LifeLinkKeywd WHERE Serial = @Serial
		END
	ELSE IF @Gubun = '2'	--  추천사이트
		BEGIN
			UPDATE LifeLinkRecmd SET ViewCnt = ISNULL(ViewCnt,0) + 1 WHERE Serial = @Serial
			SELECT Url FROM LifeLinkRecmd WHERE Serial = @Serial
		END
	ELSE IF @Gubun = '3'	--  사이트
		BEGIN
			UPDATE LifeLinkSite SET ViewCnt = ISNULL(ViewCnt,0) + 1 WHERE Serial = @Serial
			SELECT Url FROM LifeLinkSite WHERE Serial = @Serial
		END
	ELSE IF @Gubun = '4'	--  추천서비스
		BEGIN
			UPDATE LifeLinkServ SET ViewCnt = ISNULL(ViewCnt,0) + 1 WHERE Serial = @Serial
			SELECT Url FROM LifeLinkServ WHERE Serial = @Serial
		END
	ELSE IF @Gubun = '5'	--  서비스링크
		BEGIN
			UPDATE LifeLinkAd SET ViewCnt = ISNULL(ViewCnt,0) + 1 WHERE Serial = @Serial
			SELECT Url FROM LifeLinkAd WHERE Serial = @Serial
		END

END

GO
/****** Object:  StoredProcedure [dbo].[USERID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:24:01 ******/
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

	UPDATE A SET UserID=@RE_USERID FROM AfterBoardRe A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM Anc365Prize2 A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM Anc365SubRespondent2 A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM BD_LOCALEVENT_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM BD_LOCALNEWS_COMMENT_TB A  where CUID=@CUID
	--UPDATE A SET UserId=@RE_USERID FROM DaeguAniversary A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM EssayComment A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_BUS_EVENT_201009_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_CLEANBOARD_COMMENT_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_CLEANBOARD_RECOMMEND_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_CLEANBOARD_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_CUSTOMER_EVENT_201002_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_CUSTOMER_EVENT_201004_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_CUSTOMER_EVENT_201005_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_CUSTOMER_EVENT_201008_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_RENEW_EVENT_201010_COMMENT_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_RENEW_EVENT_201010_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_RESEARCH_201006_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FA_SURVEY_ANSWER_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM FOOD_SEMINAR_EVENT A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM JEssayComment A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM LocalNewsComment A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM NESSAYCOMMENT A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM NESSAYCOMMENT_MEMO_TB A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM Paper_Kwd_Excel_User A  where CUID=@CUID
	UPDATE A SET RESUME_USER_ID=@RE_USERID FROM PG_RESUME_READ_BLOCK_TB A  where RESUME_CUID=@CUID
	UPDATE A SET BLOCK_USER_ID=@RE_USERID FROM PG_RESUME_READ_BLOCK_TB A  where BLOCK_CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM ReaderComment2 A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM ReaderEvent2 A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM UsrCenter A  where CUID=@CUID
/*
	INSERT LOGDB.DBO.USERID_CHANGE_HISTORY_TB (B_USERID,N_USERID,DB_NM,USERIP)
	SELECT @USERID,@RE_USERID,DB_NAME(),@CLIENT_IP
*/
END

GO
/****** Object:  StoredProcedure [dbo].[usp_fa_event_tb_schedule]    Script Date: 2021-11-04 오전 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	:	usp_fa_event_tb_schedule
 설명	:	이벤트 관련 스케줄
==============================================================================*/
CREATE PROC [dbo].[usp_fa_event_tb_schedule]

AS
	SET NOCOUNT ON

	-- 기간에 맞춰 게재전=> 게재중으로 바꾸기
	update fa_event_tb set
	EventYN = 'Y'
	where EventYN = 'P'
	    and DelYN = 'N'
	    and dtSDate <= getdate()

	-- 기간에 맞춰 게재중=> 마감으로 바꾸기
	update fa_event_tb set
	EventYN = 'N'
	where EventYN = 'Y'
	    and DelYN = 'N'
	    and dtEDate <= getdate()

	SET NOCOUNT OFF

GO
