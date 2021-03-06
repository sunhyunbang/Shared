USE [FINDALL_POINT]
GO
/****** Object:  StoredProcedure [dbo].[BAT_POINT_MONTHLY_EXPIRE_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************
 *  단위 업무 명 : 회원 유효기간 만료된 포인트 삭제 작업
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-19
 *  수   정   자 : 
 *  수   정   일 : 
 *******************************************************/
CREATE PROC [dbo].[BAT_POINT_MONTHLY_EXPIRE_PROC]
AS
/*
--4월 1일만 실행
--그 후 삭제
--날짜 형식 변경(확인 필요)
UPDATE PT_STATUS_TB
   SET POINT_EXPIRE_DT=CONVERT(VARCHAR(10), CAST(POINT_EXPIRE_DT AS DATETIME), 120)
 WHERE POINT_EXPIRE_DT<>''

--유효 기간 변경
UPDATE PT_STATUS_TB
   SET POINT_EXPIRE_DT='2013-04-01'
 WHERE POINT_EXPIRE_DT<='2014-04-01'
   AND MY_SAVE_POINT>0

--유효 기간 변경
UPDATE PT_STATUS_TB
   SET POINT_EXPIRE_DT=CONVERT(VARCHAR(10), CAST(DATEADD(YEAR, -1, POINT_EXPIRE_DT) AS DATETIME), 120)
 WHERE POINT_EXPIRE_DT>'2014-04-01'
   AND MY_SAVE_POINT>0
*/

--포인트 매월 삭제 작업
DECLARE @EXPIRE_DT VARCHAR(10)

SET @EXPIRE_DT=CONVERT(VARCHAR(10), GETDATE(), 120)
--SET @EXPIRE_DT='2013-04-01'

SELECT 
       S.USERID
     , SUM(S.MY_SAVE_POINT) AS SAVE_POINT
     , SUM(S.MY_USED_POINT) AS USED_POINT
     , ISNULL((SELECT SUM(ISNULL(MY_SAVE_POINT,0)) FROM dbo.PT_STATUS_TB AS P1 WITH (NOLOCK) WHERE POINT_EXPIRE_DT=@EXPIRE_DT AND P1.USERID=S.USERID),0) AS EXPIRE_POINT
  INTO #AAA
  FROM dbo.PT_STATUS_TB AS S WITH (NOLOCK)
 GROUP BY S.USERID

--포인트 만료 내역 입력

INSERT INTO dbo.PT_STATUS_TB
(USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
SELECT USERID
   , POINT_TYPE
   , POINT_SEC
   , CONVERT(VARCHAR(10), GETDATE(), 120) AS POINT_SAVE_DT
   , 'C' AS POINT_SAVE_GB	--소멸
   , CODENM AS POINT_CONT
   , '' AS POINT_EXPIRE_DT
   , 0 AS MY_SAVE_POINT
   , DEL_POINT AS MY_USED_POINT
   , (MY_BALANCE_POINT-DEL_POINT) AS MY_BALANCE_POINT
FROM
(
SELECT A.USERID
     , A.SAVE_POINT
     , A.USED_POINT
     , A.MY_BALANCE_POINT
     , 'A52' AS POINT_TYPE
     , '포인트유효기간 만료' AS CODENM
     , A.DEL_POINT
     , 'M' AS  CASH_GB
     , 'A002' AS POINT_SEC
FROM
(
SELECT A.USERID
     , A.SAVE_POINT
     , A.USED_POINT
     , A.EXPIRE_POINT
     , A.EXPIRE_POINT-A.USED_POINT AS DEL_POINT
     , (SELECT TOP 1 B.MY_BALANCE_POINT 
          FROM PT_STATUS_TB AS B WITH (NOLOCK) 
         WHERE B.USERID=A.USERID
         ORDER BY B.POINT_SEQ DESC
       ) AS MY_BALANCE_POINT
  FROM #AAA AS A
 WHERE A.EXPIRE_POINT>0
   AND A.EXPIRE_POINT-USED_POINT>0
) AS A
) MA
GO
/****** Object:  StoredProcedure [dbo].[GET_F_PT_EVENT2_WINNER_TB_INFO_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*********************************************************************
* Description
*
*  내  용 : CF 이벤트2 정보
*  작성자 : 정태운
*  작성일 : 2011-05-31
*  EXEC  : EXEC DBO.GET_F_PT_EVENT2_WINNER_TB_INFO_PROC 'twoon'
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009/11/30) : 신규작성
*********************************************************************/
CREATE       PROCEDURE [dbo].[GET_F_PT_EVENT2_WINNER_TB_INFO_PROC]
  @USERID   VARCHAR(50)                  -- ID
AS
SET NOCOUNT ON

SELECT TOP 1 
  (SELECT COUNT(*) FROM DBO.PT_EVENT2_WINNER_TB (NOLOCK) WHERE USER_ID = @USERID) AS 'REGCNT'  
, (SELECT COUNT(*) FROM DBO.PT_EVENT2_WINNER_TB (NOLOCK) WHERE WIN_YN = 'Y' AND USER_ID = @USERID) AS 'WINYN'  
, ISNULL((SELECT TOP 1 MY_BALANCE_POINT FROM DBO.PT_STATUS_TB (NOLOCK) WHERE USERID = @USERID ORDER BY POINT_SEQ DESC),0) AS 'MYPOINT'
  FROM DBO.PT_STATUS_TB (NOLOCK)






GO
/****** Object:  StoredProcedure [dbo].[GET_F_PT_STATUS_TB_ALLPOINT_EVENT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*********************************************************************
* Description
*
*  내  용 : 2012 벼룩시장 올포인트 소진 이벤트 회원 응모정보
*  작성자 : 이경덕
*  작성일 : 2012-09-13
*  EXEC  : EXEC DBO.GET_F_PT_STATUS_TB_ALLPOINT_EVENT_PROC 'laplance'
*********************************************************************/
CREATE              PROCEDURE [dbo].[GET_F_PT_STATUS_TB_ALLPOINT_EVENT_PROC]
  @USERID   VARCHAR(50)                  -- ID

AS
SET NOCOUNT ON 

 SELECT 
   ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_REDUCE_ENTRY_TB (NOLOCK) WHERE USERID = @USERID AND EVENT_NUM = 0),0) As REGCNT1
  ,ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_REDUCE_ENTRY_TB (NOLOCK) WHERE USERID = @USERID AND EVENT_NUM = 1),0) As REGCNT2
  ,ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_REDUCE_WINNER_TB (NOLOCK) WHERE USER_ID = @USERID AND WIN_YN = 'Y'),0) As WINCNT
  ,ISNULL((SELECT TOP 1 MY_BALANCE_POINT FROM DBO.PT_STATUS_TB (NOLOCK) WHERE USERID = @USERID ORDER BY POINT_SEQ DESC),0) AS MYPOINT
   FROM DBO.PT_STATUS_TB (NOLOCK)
 WHERE 
   USERID = @USERID
 GROUP BY USERID



GO
/****** Object:  StoredProcedure [dbo].[GET_F_PT_STATUS_TB_ALLPOINT_NEWYEAR_EVENT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*********************************************************************
* Description
*
*  내  용 : 2013 벼룩시장 올포인트 소진 이벤트 회원 응모정보
*  작성자 : 이경덕
*  작성일 : 2013-01-07
*  EXEC  : EXEC DBO.GET_F_PT_STATUS_TB_ALLPOINT_NEWYEAR_EVENT_PROC 'laplance',39
*********************************************************************/

CREATE   PROCEDURE [dbo].[GET_F_PT_STATUS_TB_ALLPOINT_NEWYEAR_EVENT_PROC]
   @USERID     VARCHAR(50)                  -- ID
  ,@EVENTSEQ   INT			                -- EVENT_SEQ

AS
SET NOCOUNT ON 

 SELECT
   ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB (NOLOCK) WHERE USERID = @USERID AND EVENT_TYPE = 'A' AND EVENT_SEQ = @EVENTSEQ),0) As REGCNT1
  ,ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB (NOLOCK) WHERE USERID = @USERID AND EVENT_TYPE = 'B' AND EVENT_SEQ = @EVENTSEQ),0) As REGCNT2
  ,ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB (NOLOCK) WHERE USERID = @USERID AND EVENT_TYPE = 'C' AND EVENT_SEQ = @EVENTSEQ),0) As REGCNT3
  ,ISNULL((SELECT TOP 1 MY_BALANCE_POINT FROM DBO.PT_STATUS_TB (NOLOCK) WHERE USERID = @USERID ORDER BY POINT_SEQ DESC),0) AS MYPOINT
   FROM DBO.PT_STATUS_TB (NOLOCK)
 WHERE 
   USERID = @USERID
 GROUP BY USERID




GO
/****** Object:  StoredProcedure [dbo].[GET_F_PT_STATUS_TB_ECO_EVENT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*********************************************************************
* Description
*
*  내  용 : 2011 벼룩시장 에코이벤트 회원 응모정보
*  작성자 : 김문화
*  작성일 : 2011-07-18
*  EXEC  : EXEC DBO.GET_F_PT_STATUS_TB_ECO_EVENT_PROC 'imjsy101'
*********************************************************************/

CREATE             PROCEDURE [dbo].[GET_F_PT_STATUS_TB_ECO_EVENT_PROC]
  @USERID   VARCHAR(50)                  -- ID

AS
SET NOCOUNT ON

 SELECT 
   ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_ECO_ENTRY_TB (NOLOCK) WHERE USER_ID = @USERID AND ITEM_SEQ = 'A42'),0) AS PROMISE1 
  ,ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_ECO_ENTRY_TB (NOLOCK) WHERE USER_ID = @USERID AND ITEM_SEQ = 'A43'),0) AS PROMISE2
  ,ISNULL((SELECT DATEPART(M,GETDATE())-DATEPART(M,POINT_SAVE_DT) FROM DBO.PT_STATUS_TB (NOLOCK) WHERE USERID = @USERID AND ITEM_SEQ = 'A17'),0) AS POINTED_YN
  ,ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_ECO_ENTRY_TB (NOLOCK) WHERE USER_ID = @USERID AND ITEM_SEQ = 'A44'),0) AS ENTRY_PRESENT1
  ,ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_ECO_ENTRY_TB (NOLOCK) WHERE USER_ID = @USERID AND ITEM_SEQ = 'A45'),0) AS ENTRY_PRESENT2
  ,ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_ECO_ENTRY_TB (NOLOCK) WHERE USER_ID = @USERID AND ITEM_SEQ = 'A46'),0) AS ENTRY_PRESENT3
  --이전까지 이미 응모한 회원 모두 자동 자전거 응모처리
  ,ISNULL((SELECT COUNT(*) FROM DBO.PT_EVENT_ECO_ENTRY_TB (NOLOCK) WHERE USER_ID = @USERID AND (ITEM_SEQ = 'A47' OR (ITEM_SEQ = 'A43' AND REG_DT <= '2011-07-28 13:54:00'))),0) AS ENTRY_CYCLE
  ,ISNULL((SELECT TOP 1 MY_BALANCE_POINT FROM DBO.PT_STATUS_TB (NOLOCK) WHERE USERID = @USERID ORDER BY POINT_SEQ DESC),0) AS MYPOINT
   FROM DBO.PT_STATUS_TB (NOLOCK)
 WHERE 
   USERID = @USERID
 GROUP BY USERID




GO
/****** Object:  StoredProcedure [dbo].[GET_F_PT_STATUS_TB_MY_POINT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*********************************************************************
* Description
*
*  내  용 : 포인트왕 이벤트 내 올포인트
*  작성자 : 정태운
*  작성일 : 2011-05-19
*  EXEC  : EXEC DBO.GET_F_PT_STATUS_TB_MY_POINT_PROC 'rocker44', '2011-06-01', '2011-06-30'
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009/11/30) : 신규작성
*********************************************************************/
CREATE      PROCEDURE [dbo].[GET_F_PT_STATUS_TB_MY_POINT_PROC]
  @USERID   VARCHAR(50)                  -- ID
, @StartDt  VARCHAR(10)                  -- 시작일
, @EndDt    VARCHAR(10)                  -- 종료일

AS
SET NOCOUNT ON

SELECT SUM(MY_SAVE_POINT) - SUM(MY_USED_POINT) AS 'POINTSUM'
  FROM DBO.PT_STATUS_TB (NOLOCK)
 WHERE 
   --POINT_SAVE_GB = 'A'
   (POINT_SAVE_DT >= @StartDt AND POINT_SAVE_DT <= @EndDt)
   AND USERID = @USERID
 GROUP BY USERID




GO
/****** Object:  StoredProcedure [dbo].[GET_F_PT_STATUS_TB_POINTEVENT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*********************************************************************
* Description
*
*  내  용 : 포인트왕 이벤트 적립현황
*  작성자 : 정태운
*  작성일 : 2011-05-19
*  EXEC  : EXEC DBO.GET_F_PT_STATUS_TB_POINTEVENT_PROC
*********************************************************************/
/*********************************************************************
* Work History
*
*	1) 정태운(2009/11/30) : 신규작성
*********************************************************************/
CREATE      PROCEDURE [dbo].[GET_F_PT_STATUS_TB_POINTEVENT_PROC]
  @StartDt    VARCHAR(10)        -- 시작일
, @EndDt      VARCHAR(10)        -- 종료일

AS
SET NOCOUNT ON

SELECT * FROM (
                SELECT TOP 5 USERID, SUM(MY_SAVE_POINT) AS 'POINTSUM'
                  FROM DBO.PT_STATUS_TB (NOLOCK)
                 WHERE POINT_SAVE_GB = 'A'
                   AND (POINT_SAVE_DT >= @StartDt AND POINT_SAVE_DT <= @EndDt)
                 GROUP BY USERID
                 HAVING SUM(MY_SAVE_POINT) > 0
                 ORDER BY NEWID()
              ) A
 ORDER BY A.POINTSUM DESC


GO
/****** Object:  StoredProcedure [dbo].[GET_M_ALLPOINT_EVENT_ENTRY_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트소진이벤트 > 누적응모자 
 *  작   성   자 : 이 경 덕 (virtualman@mediawill.com)
 *  작   성   일 : 2012/09/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_ALLPOINT_EVENT_ENTRY_LIST_PROC 1, 20, '', ''
 *************************************************************************************/


CREATE         PROC [dbo].[GET_M_ALLPOINT_EVENT_ENTRY_LIST_PROC]

   @PAGE      INT
  ,@PAGESIZE  INT
  ,@KEY       VARCHAR(10) 	= ''
  ,@KEYWORD   VARCHAR(50) 	= ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(4000)
  DECLARE @WHERE_SQL NVARCHAR(200)

  SET @SQL = ''
  SET @SQL_COUNT = ''
  SET @WHERE_SQL = ''

  -- 이벤트 제목
  IF @KEY<>'' AND @KEYWORD <> ''

	  IF  @KEY = 'USERID'
	   BEGIN 
	  	SET @WHERE_SQL = @WHERE_SQL + ' AND A.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE IF @KEY = 'BIZNO'
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND C.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND M.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END


  SET @SQL_COUNT = 'SELECT COUNT(*) CNT FROM 
					(
						SELECT A.USERID AS USER_ID
							, M.USERNAME USERNAME
						 	, M.OUT_APPLY_YN OUT_APPLY_YN
							, M.JUMINNO_A+''-*******'' AS JUMINNO
							, CONVERT(VARCHAR(10), M.JOIN_DT,11)  JOIN_DT
							, C.COM_NM COM_NM
							, C.BIZNO BIZNO
							, (SELECT COUNT(*) FROM PT_EVENT_REDUCE_ENTRY_TB WHERE USERID=A.USERID AND EVENT_NUM=0) AS ''50CNT''
							, (SELECT COUNT(*) FROM PT_EVENT_REDUCE_ENTRY_TB WHERE USERID=A.USERID AND EVENT_NUM=1) AS ''5CNT''
						    , M.REST_YN
						    , M.BAD_YN
						FROM dbo.PT_EVENT_REDUCE_ENTRY_TB A
						JOIN MEMBER.DBO.MM_MEMBER_TB M ON A.USERID=M.USERID
						LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID
						LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID
						WHERE A.USERID<>'''' '+ @WHERE_SQL+'
						GROUP BY A.USERID 
							, M.USERNAME
							, M.OUT_APPLY_YN
							, M.JUMINNO_A
							, M.JOIN_DT
							, C.COM_NM
							, C.BIZNO
						    , M.REST_YN
						    , M.BAD_YN
					) ABC '



  SET @SQL = 'SELECT  TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
				 A.USERID AS USER_ID
				,M.USERNAME USERNAME
				,M.OUT_APPLY_YN OUT_APPLY_YN
				,M.JUMINNO_A+''-*******'' AS JUMINNO
				,CONVERT(VARCHAR(10), M.JOIN_DT,11)  JOIN_DT
				,C.COM_NM COM_NM
				,C.BIZNO BIZNO
				,(SELECT COUNT(*) FROM PT_EVENT_REDUCE_ENTRY_TB WHERE USERID=A.USERID AND EVENT_NUM=0) AS ''50CNT''
				,(SELECT COUNT(*) FROM PT_EVENT_REDUCE_ENTRY_TB WHERE USERID=A.USERID AND EVENT_NUM=1) AS ''5CNT''
				,M.REST_YN
				,M.BAD_YN
			FROM dbo.PT_EVENT_REDUCE_ENTRY_TB A
			JOIN MEMBER.DBO.MM_MEMBER_TB M ON A.USERID=M.USERID
			LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID
			LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID
			WHERE A.USERID<>'''' '+ @WHERE_SQL+'
			GROUP BY A.USERID 
				,M.USERNAME
				,M.OUT_APPLY_YN
				,M.JUMINNO_A
				,M.JOIN_DT
				,C.COM_NM
				,C.BIZNO
				,M.REST_YN
				,M.BAD_YN '

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL










GO
/****** Object:  StoredProcedure [dbo].[GET_M_ALLPOINT_EVENT_ENTRY_YEAR_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트소진이벤트 > 응모현황 Excel
 *  작   성   자 : 이 경 덕 (laplance@mediawill.com)
 *  작   성   일 : 2013/01/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_ALLPOINT_EVENT_ENTRY_YEAR_LIST_EXCEL_PROC 380,'','', ''
 *************************************************************************************/


CREATE              PROC [dbo].[GET_M_ALLPOINT_EVENT_ENTRY_YEAR_LIST_EXCEL_PROC]

   @EVENTSEQ  INT
  ,@EVENTTYPE CHAR(1)	
  ,@KEY       VARCHAR(10) 	= ''
  ,@KEYWORD   VARCHAR(50) 	= ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @WHERE_SQL NVARCHAR(200)

  SET @SQL = ''
  SET @WHERE_SQL = ''

  -- 이벤트 선택
  IF @EVENTSEQ<>'' 

 	SET @WHERE_SQL = @WHERE_SQL + ' AND A.EVENT_SEQ ='+  CONVERT(VARCHAR(30),@EVENTSEQ) +''
  

  -- 이벤트 제목
  IF @KEY<>'' AND @KEYWORD <> ''

	  IF  @KEY = 'USERID'
	   BEGIN 
	  	SET @WHERE_SQL = @WHERE_SQL + ' AND A.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE IF @KEY = 'BIZNO'
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND C.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND M.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END

-- 상품응모여부
 IF @EVENTTYPE<>'' 

 	SET @WHERE_SQL = @WHERE_SQL + ' AND A.EVENT_TYPE ='''+ @EVENTTYPE +''''


	  SET @SQL = 'SELECT A.USERID AS USER_ID
					   , M.USERNAME USERNAME
					   , C.COM_NM COM_NM
					   , M.OUT_APPLY_YN OUT_APPLY_YN
					   , CONVERT(VARCHAR(10), M.JOIN_DT,11)  JOIN_DT
					   , M.HPHONE
					   , M.PHONE
					   , A.EVENT_TYPE
					   , A.REG_DT
					   , M.REST_YN
					   , M.BAD_YN
					   , (SELECT CASE 	WHEN YEAR(A.REG_DT)=2013 AND T.TEXT02=''5000'' THEN ''3000''
							  			WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)<10 AND T.TEXT02=''3000'' THEN ''2000''
							  			WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)=10 AND T.TEXT02=''3000'' THEN ''1000''
							  			WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)>10 AND T.TEXT02=''3000'' THEN ''2000''
							  			WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)=10 AND T.TEXT02=''1000'' THEN ''2000''
							  			ELSE T.TEXT02
						 		   END  TEXT02 
						    FROM TCC_COM_TB T WHERE T.CODEID = 
									    CASE A.EVENT_TYPE WHEN ''A'' THEN ''A49''
														  WHEN ''B'' THEN ''A50''	
														  WHEN ''C'' THEN ''A51''	
										END
						 ) POINT
					FROM dbo.PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB A
					JOIN MEMBER.DBO.MM_MEMBER_TB M ON A.USERID=M.USERID
					LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID
					LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID
					WHERE A.USERID<>'''' '+ @WHERE_SQL+'
					GROUP BY A.USERID 
					    , M.USERNAME
					    , C.COM_NM
					    , M.OUT_APPLY_YN
					    , M.JOIN_DT
					    , M.HPHONE
					    , M.PHONE
					    , A.EVENT_TYPE
					    , A.REG_DT
					    , C.BIZNO
					    , M.REST_YN
					    , M.BAD_YN '

  --PRINT @SQL

  EXECUTE SP_EXECUTESQL @SQL






GO
/****** Object:  StoredProcedure [dbo].[GET_M_ALLPOINT_EVENT_ENTRY_YEAR_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트소진이벤트 > 응모현황
 *  작   성   자 : 이 경 덕 (virtualman@mediawill.com)
 *  작   성   일 : 2013/01/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_ALLPOINT_EVENT_ENTRY_YEAR_LIST_PROC 1, 20, 390,'A', '',''
 *************************************************************************************/


CREATE                   PROC [dbo].[GET_M_ALLPOINT_EVENT_ENTRY_YEAR_LIST_PROC]

   @PAGE      INT
  ,@PAGESIZE  INT
  ,@EVENTSEQ  INT
  ,@EVENTTYPE CHAR(1)	
  ,@KEY       VARCHAR(10) 	= ''
  ,@KEYWORD   VARCHAR(50) 	= ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_TOTALCNT NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(4000)
  DECLARE @WHERE_SQL NVARCHAR(200)

  SET @SQL = ''
  SET @SQL_TOTALCNT = ''
  SET @SQL_COUNT = ''
  SET @WHERE_SQL = ''

  -- 이벤트 선택
  IF @EVENTSEQ<>'' 

 	SET @WHERE_SQL = @WHERE_SQL + ' AND A.EVENT_SEQ ='+  CONVERT(VARCHAR(30),@EVENTSEQ) +''
  


  -- 이벤트 제목
  IF @KEY<>'' AND @KEYWORD <> ''

	  IF  @KEY = 'USERID'
	   BEGIN 
	  	SET @WHERE_SQL = @WHERE_SQL + ' AND A.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE IF @KEY = 'BIZNO'
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND C.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND M.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END

-- 상품응모여부
 IF @EVENTTYPE<>'' 

 	SET @WHERE_SQL = @WHERE_SQL + ' AND A.EVENT_TYPE ='''+ @EVENTTYPE +''''

  SET @SQL_TOTALCNT = 'SELECT COUNT(*) TOTALCNT FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB WITH (NOLOCK) WHERE EVENT_SEQ = '+  CONVERT(VARCHAR(30),@EVENTSEQ) +''
  

  SET @SQL_COUNT = 'SELECT COUNT(*) CNT FROM 
					(
					  SELECT A.USERID AS USER_ID
						   , M.USERNAME USERNAME
						   , C.COM_NM COM_NM
						   , M.OUT_APPLY_YN OUT_APPLY_YN
						   , CONVERT(VARCHAR(10), M.JOIN_DT,11)  JOIN_DT
						   , M.HPHONE
						   , M.PHONE
						   , A.EVENT_TYPE
						   , A.REG_DT
						   , M.REST_YN
						   , M.BAD_YN
						FROM dbo.PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB A
						JOIN MEMBER.DBO.MM_MEMBER_TB M ON A.USERID=M.USERID
						LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID
						LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID
						WHERE A.USERID<>'''' '+ @WHERE_SQL+'
						GROUP BY A.USERID 
						    , M.USERNAME
						    , C.COM_NM
						    , M.OUT_APPLY_YN
						    , M.JOIN_DT
						    , M.HPHONE
						    , M.PHONE
						    , A.EVENT_TYPE
						    , A.REG_DT
						    , C.BIZNO
						    , M.REST_YN
						    , M.BAD_YN 
					) ABC '



	  SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
						 A.USERID AS USER_ID
					   , M.USERNAME USERNAME
					   , C.COM_NM COM_NM
					   , M.OUT_APPLY_YN OUT_APPLY_YN
					   , CONVERT(VARCHAR(10), M.JOIN_DT,11)  JOIN_DT
					   , M.HPHONE
					   , M.PHONE
					   , A.EVENT_TYPE
					   , A.REG_DT
					   , M.REST_YN
					   , M.BAD_YN
					   , CASE WHEN YEAR(A.REG_DT)=2013 AND T.TEXT02=''5000'' THEN ''3000''
							  WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)<10 AND T.TEXT02=''3000'' THEN ''2000''
							  WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)=10 AND T.TEXT02=''3000'' THEN ''1000''
							  WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)>10 AND T.TEXT02=''3000'' THEN ''2000''
							  WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)=10 AND T.TEXT02=''1000'' THEN ''2000''
						 ELSE T.TEXT02
						 END  POINT
					 --, T.TEXT02 POINT
					FROM dbo.PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB A
					JOIN TCC_COM_TB T WITH (NOLOCK) ON A.CODEID = T.CODEID
					JOIN MEMBER.DBO.MM_MEMBER_TB M ON A.USERID=M.USERID
					LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID
					LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID
					WHERE A.USERID<>'''' '+ @WHERE_SQL+'
					GROUP BY A.USERID 
					    , M.USERNAME
					    , C.COM_NM
					    , M.OUT_APPLY_YN
					    , M.JOIN_DT
					    , M.HPHONE
					    , M.PHONE
					    , A.EVENT_TYPE
					    , A.REG_DT
					    , C.BIZNO
					    , M.REST_YN
					    , M.BAD_YN 
					    , T.TEXT02
					ORDER BY A.REG_DT DESC'
  --PRINT @SQL_TOTALCNT
  --PRINT @SQL
  --PRINT @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL_TOTALCNT
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL






GO
/****** Object:  StoredProcedure [dbo].[GET_M_ALLPOINT_EVENT_WINNER_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트소진이벤트 > 즉석응모자 
 *  작   성   자 : 이 경 덕 (virtualman@mediawill.com)
 *  작   성   일 : 2012/09/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_ALLPOINT_EVENT_WINNER_LIST_PROC 1, 20, '', '' ,''
 *************************************************************************************/


CREATE       PROC [dbo].[GET_M_ALLPOINT_EVENT_WINNER_LIST_PROC]

   @PAGE      INT
  ,@PAGESIZE  INT
  ,@KEY       VARCHAR(10) 	= ''
  ,@KEYWORD   VARCHAR(50) 	= ''
  ,@ORDERBY	  VARCHAR(10)  	= ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_TOTALCNT NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(4000)
  DECLARE @WHERE_SQL NVARCHAR(200)
  DECLARE @ORDERY_SQL NVARCHAR(200)

  SET @SQL = ''
  SET @SQL_TOTALCNT = ''
  SET @SQL_COUNT = ''
  SET @WHERE_SQL = ''
  SET @ORDERY_SQL = ''
  	

  -- 이벤트 제목
  IF @KEY<>'' AND @KEYWORD <> ''

	  IF  @KEY = 'USER_ID'
	   BEGIN 
	  	SET @WHERE_SQL = @WHERE_SQL + ' AND A.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE IF @KEY = 'BIZNO'
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND C.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND M.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END

  -- 정렬
  IF @ORDERBY <> ''
	   BEGIN 
	  	SET @ORDERY_SQL = @ORDERY_SQL + ' ORDER BY B.'+ @ORDERBY +' DESC'
	   END

  SET @SQL_TOTALCNT = 'SELECT COUNT(*) TOTALCNT FROM PT_EVENT_REDUCE_WINNER_TB '	

  SET @SQL_COUNT = 'SELECT COUNT (*) CNT FROM 
					(
					SELECT A.USER_ID AS USER_ID
						 , M.USERNAME USERNAME
						 , M.OUT_APPLY_YN OUT_APPLY_YN
						 , M.JUMINNO_A+''-*******'' AS JUMINNO
						 , CONVERT(VARCHAR(10),M.JOIN_DT,11) JOIN_DT
						 , C.COM_NM COM_NM
						 , C.BIZNO BIZNO
						 , COUNT(*) WINCNT
						 , ISNULL(CONVERT(VARCHAR(10),B.REG_DT,11),''-'') REG_DT	
						 , M.REST_YN
						 , M.BAD_YN
	 					  FROM PT_EVENT_REDUCE_WINNER_TB AS A
					  LEFT JOIN (
					       SELECT USER_ID, REG_DT
					         FROM PT_EVENT_REDUCE_WINNER_TB
					        WHERE WIN_YN=''Y''
					       ) AS B ON A.USER_ID=B.USER_ID
			
					 JOIN MEMBER.DBO.MM_MEMBER_TB M ON A.USER_ID=M.USERID
					 LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID
					 LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID
					WHERE A.USER_ID<>'''' '+ @WHERE_SQL+'
					  GROUP BY A.USER_ID 
						  , M.USERNAME
						  , M.OUT_APPLY_YN
						  , M.JUMINNO_A
						  , M.JOIN_DT
						  , C.COM_NM
						  , C.BIZNO
						  , B.REG_DT
						  , M.REST_YN
						  , M.BAD_YN
					) ABC '


  SET @SQL =	'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
						   A.USER_ID AS USER_ID
						 , M.USERNAME USERNAME
						 , M.OUT_APPLY_YN OUT_APPLY_YN
						 , M.JUMINNO_A+''-*******'' AS JUMINNO
						 , CONVERT(VARCHAR(10),M.JOIN_DT,11) JOIN_DT
						 , C.COM_NM COM_NM
						 , C.BIZNO BIZNO
						 , COUNT(*) WINCNT
						 , ISNULL(CONVERT(VARCHAR(10),B.REG_DT,11),''-'') REG_DT		 
						 , M.REST_YN
						 , M.BAD_YN
					  FROM PT_EVENT_REDUCE_WINNER_TB AS A
					  LEFT JOIN (
					       SELECT USER_ID, REG_DT
					         FROM PT_EVENT_REDUCE_WINNER_TB
					        WHERE WIN_YN=''Y''
					       ) AS B ON A.USER_ID=B.USER_ID
			
					 JOIN MEMBER.DBO.MM_MEMBER_TB M ON A.USER_ID=M.USERID
					 LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID
					 LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID
					WHERE A.USER_ID<>'''' '+ @WHERE_SQL+'
					  GROUP BY A.USER_ID 
						  , M.USERNAME
						  , M.OUT_APPLY_YN
						  , M.JUMINNO_A
						  , M.JOIN_DT
						  , C.COM_NM
						  , C.BIZNO
						  , B.REG_DT 
						  , M.REST_YN
						  , M.BAD_YN'+ @ORDERY_SQL

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL_TOTALCNT
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL








GO
/****** Object:  StoredProcedure [dbo].[GET_M_ALLPOINT_EVENT_WINNER_YEAR_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트소진이벤트 > 응모자조회 Excel
 *  작   성   자 : 이 경 덕 (laplance@mediawill.com)
 *  작   성   일 : 2013/01/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_ALLPOINT_EVENT_WINNER_YEAR_LIST_EXCEL_PROC 390,'','', '',''
 *************************************************************************************/


CREATE                 PROC [dbo].[GET_M_ALLPOINT_EVENT_WINNER_YEAR_LIST_EXCEL_PROC]

   @EVENTSEQ  INT
  ,@EVENTTYPE CHAR(1)
  ,@WINTYPE   CHAR(1)
  ,@KEY       VARCHAR(10) 	= ''
  ,@KEYWORD   VARCHAR(50) 	= ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @WHERE_SQL NVARCHAR(200)
  DECLARE @ORDERY_SQL NVARCHAR(200)

  SET @SQL = ''
  SET @WHERE_SQL = ''
  SET @ORDERY_SQL = ''

  -- 이벤트 선택
  IF @EVENTSEQ<>'' 

 	SET @WHERE_SQL = @WHERE_SQL + ' AND A.EVENT_SEQ ='+  CONVERT(VARCHAR(30),@EVENTSEQ) +''


  -- 이벤트 제목
  IF @KEY<>'' AND @KEYWORD <> ''

	  IF  @KEY = 'USERID'
	   BEGIN 
	  	SET @WHERE_SQL = @WHERE_SQL + ' AND A.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE IF @KEY = 'BIZNO'
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND C.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND M.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END

  -- 당첨여부
  IF @WINTYPE<>'' 

 	SET @WHERE_SQL = @WHERE_SQL + ' AND R.WIN_TYPE ='''+ @WINTYPE +''''

  -- 이벤트 상품선택 별 정렬
  IF @EVENTTYPE<>'' 

	SET @ORDERY_SQL = @ORDERY_SQL + ' ORDER BY AA.'+ @EVENTTYPE +' DESC'


	  SET @SQL = 'SELECT AA.* FROM
					(
					SELECT   A.USERID AS USER_ID
						   , M.USERNAME USERNAME
						   , C.COM_NM COM_NM
						   , M.OUT_APPLY_YN OUT_APPLY_YN
						   , CONVERT(VARCHAR(10), M.JOIN_DT,11)  JOIN_DT
						   , M.HPHONE
						   , M.PHONE
						   , M.REST_YN
						   , M.BAD_YN
						   , (SELECT COUNT(*) FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB WITH (NOLOCK) WHERE USERID=A.USERID AND EVENT_TYPE=''A'' AND EVENT_SEQ = '+  CONVERT(VARCHAR(30),@EVENTSEQ) +') AS ''A''
						   , (SELECT COUNT(*) FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB WITH (NOLOCK) WHERE USERID=A.USERID AND EVENT_TYPE=''B'' AND EVENT_SEQ = '+  CONVERT(VARCHAR(30),@EVENTSEQ) +') AS ''B''
						   , (SELECT COUNT(*) FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB WITH (NOLOCK) WHERE USERID=A.USERID AND EVENT_TYPE=''C'' AND EVENT_SEQ = '+  CONVERT(VARCHAR(30),@EVENTSEQ) +') AS ''C''
						   , SUM(CASE	WHEN YEAR(A.REG_DT)=2013 AND CAST(T.TEXT02 AS DECIMAL)=5000 THEN 3000
							      		WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)<10 AND CAST(T.TEXT02 AS DECIMAL)=3000 THEN 2000
							      		WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)=10 AND CAST(T.TEXT02 AS DECIMAL)=3000 THEN 1000
							      		WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)>10 AND CAST(T.TEXT02 AS DECIMAL)=3000 THEN 2000
							      		WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)=10 AND CAST(T.TEXT02 AS DECIMAL)=1000 THEN 2000
							      		ELSE CAST(T.TEXT02 AS DECIMAL)
						 	 	 END) AS POINT
						 --, SUM(CAST(T.TEXT02 AS INT)) AS POINT
						   , R.WIN_TYPE	
						FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB A WITH (NOLOCK)
						JOIN TCC_COM_TB T WITH (NOLOCK) ON A.CODEID = T.CODEID
						JOIN MEMBER.DBO.MM_MEMBER_TB M ON A.USERID=M.USERID
						LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID
						LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID
						LEFT OUTER JOIN DBO.PT_EVENT_REDUCE_WINNER_NEWYEAR_TB R WITH (NOLOCK) ON A.USERID = R.USER_ID
						WHERE A.USERID<>'''' '+ @WHERE_SQL+'
						GROUP BY A.USERID 
						    , M.USERNAME
						    , C.COM_NM
						    , M.OUT_APPLY_YN
						    , M.JOIN_DT
						    , M.HPHONE
						    , M.PHONE
						    , C.BIZNO
						    , M.REST_YN
						    , M.BAD_YN
						    , R.WIN_TYPE	
						) AA '+ @ORDERY_SQL

  --PRINT @SQL

  EXECUTE SP_EXECUTESQL @SQL







GO
/****** Object:  StoredProcedure [dbo].[GET_M_ALLPOINT_EVENT_WINNER_YEAR_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트소진이벤트 > 응모자조회
 *  작   성   자 : 이 경 덕 (virtualman@mediawill.com)
 *  작   성   일 : 2013/01/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : GET_M_ALLPOINT_EVENT_WINNER_YEAR_LIST_PROC
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_ALLPOINT_EVENT_WINNER_YEAR_LIST_PROC 1, 20, 390, '','A',''
 *************************************************************************************/


CREATE                     PROC [dbo].[GET_M_ALLPOINT_EVENT_WINNER_YEAR_LIST_PROC]

   @PAGE      INT
  ,@PAGESIZE  INT
  ,@EVENTSEQ  INT
  ,@EVENTTYPE CHAR(1)
  ,@WINTYPE   CHAR(1)
  ,@KEY       VARCHAR(10) 	= ''
  ,@KEYWORD   VARCHAR(50) 	= ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_TOTALCNT NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(4000)
  DECLARE @WHERE_SQL NVARCHAR(200)
  DECLARE @ORDERY_SQL NVARCHAR(200)

  SET @SQL = ''
  SET @SQL_TOTALCNT = ''
  SET @SQL_COUNT = ''
  SET @WHERE_SQL = ''
  SET @ORDERY_SQL = ''

  -- 이벤트 선택
  IF @EVENTSEQ<>'' 

 	SET @WHERE_SQL = @WHERE_SQL + ' AND A.EVENT_SEQ ='+  CONVERT(VARCHAR(30),@EVENTSEQ) +''


  -- 이벤트 제목
  IF @KEY<>'' AND @KEYWORD <> ''

	  IF  @KEY = 'USERID'
	   BEGIN 
	  	SET @WHERE_SQL = @WHERE_SQL + ' AND A.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE IF @KEY = 'BIZNO'
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND C.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END
	 ELSE
	   BEGIN  	
		SET @WHERE_SQL = @WHERE_SQL + ' AND M.'+ @KEY +' LIKE ''%'+ @KEYWORD +'%'''
	   END

  -- 당첨여부
  IF @WINTYPE<>'' 

 	SET @WHERE_SQL = @WHERE_SQL + ' AND R.WIN_TYPE ='''+ @WINTYPE +''''

  -- 이벤트 상품선택 별 정렬
  IF @EVENTTYPE<>'' 

	SET @ORDERY_SQL = ' ORDER BY '+ @EVENTTYPE +' DESC'


  SET @SQL_TOTALCNT = 'SELECT COUNT(*) TOTALCNT FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB WITH (NOLOCK) WHERE EVENT_SEQ = '+  CONVERT(VARCHAR(30),@EVENTSEQ) +''

  SET @SQL_COUNT = 'SELECT COUNT(*) CNT FROM 
					(		
						
					  SELECT A.USERID AS USER_ID
						   , M.USERNAME USERNAME
						   , C.COM_NM COM_NM
						   , M.OUT_APPLY_YN OUT_APPLY_YN
						   , CONVERT(VARCHAR(10), M.JOIN_DT,11)  JOIN_DT
						   , M.HPHONE
						   , M.PHONE
						   , M.REST_YN
						   , M.BAD_YN
						   , R.WIN_TYPE	
						FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB A WITH (NOLOCK)
						JOIN TCC_COM_TB T WITH (NOLOCK) ON A.CODEID = T.CODEID
						JOIN MEMBER.DBO.MM_MEMBER_TB M ON A.USERID=M.USERID
						LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID
						LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID
						LEFT OUTER JOIN DBO.PT_EVENT_REDUCE_WINNER_NEWYEAR_TB R ON A.USERID = R.USER_ID
						WHERE A.USERID<>'''' '+ @WHERE_SQL+'
						GROUP BY A.USERID 
						    , M.USERNAME
						    , C.COM_NM
						    , M.OUT_APPLY_YN
						    , M.JOIN_DT
						    , M.HPHONE
						    , M.PHONE
						    , C.BIZNO
						    , M.REST_YN
						    , M.BAD_YN
						    , R.WIN_TYPE	
					) ABC '



	  SET @SQL = '
					SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
							 A.USERID AS USER_ID
						   , M.USERNAME USERNAME
						   , C.COM_NM COM_NM
						   , M.OUT_APPLY_YN OUT_APPLY_YN
						   , CONVERT(VARCHAR(10), M.JOIN_DT,11)  JOIN_DT
						   , M.HPHONE
						   , M.PHONE
						   , M.REST_YN
						   , M.BAD_YN
						   , (SELECT COUNT(*) FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB WITH (NOLOCK) WHERE USERID=A.USERID AND EVENT_TYPE=''A'' AND EVENT_SEQ = '+  CONVERT(VARCHAR(30),@EVENTSEQ) +') AS ''A''
						   , (SELECT COUNT(*) FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB WITH (NOLOCK) WHERE USERID=A.USERID AND EVENT_TYPE=''B'' AND EVENT_SEQ = '+  CONVERT(VARCHAR(30),@EVENTSEQ) +') AS ''B''
						   , (SELECT COUNT(*) FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB WITH (NOLOCK) WHERE USERID=A.USERID AND EVENT_TYPE=''C'' AND EVENT_SEQ = '+  CONVERT(VARCHAR(30),@EVENTSEQ) +') AS ''C''
						   , SUM(CASE	WHEN YEAR(A.REG_DT)=2013 AND CAST(T.TEXT02 AS DECIMAL)=5000 THEN 3000
							      		WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)<10 AND CAST(T.TEXT02 AS DECIMAL)=3000 THEN 2000
							      		WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)=10 AND CAST(T.TEXT02 AS DECIMAL)=3000 THEN 1000
							      		WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)>10 AND CAST(T.TEXT02 AS DECIMAL)=3000 THEN 2000
							      		WHEN YEAR(A.REG_DT)=2013 AND MONTH(A.REG_DT)=10 AND CAST(T.TEXT02 AS DECIMAL)=1000 THEN 2000
							      		ELSE CAST(T.TEXT02 AS DECIMAL)
						 	 	 END) AS POINT
						 --, SUM(CAST(T.TEXT02 AS DECIMAL)) AS POINT
						   , R.WIN_TYPE	
						FROM PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB A WITH (NOLOCK)
						JOIN TCC_COM_TB T WITH (NOLOCK) ON A.CODEID = T.CODEID
						JOIN MEMBER.DBO.MM_MEMBER_TB M ON A.USERID=M.USERID
						LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID
						LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID
						LEFT OUTER JOIN DBO.PT_EVENT_REDUCE_WINNER_NEWYEAR_TB R WITH (NOLOCK) ON A.USERID = R.USER_ID
						WHERE A.USERID<>'''' '+ @WHERE_SQL+'
						GROUP BY A.USERID 
						    , M.USERNAME
						    , C.COM_NM
						    , M.OUT_APPLY_YN
						    , M.JOIN_DT
						    , M.HPHONE
						    , M.PHONE
						    , C.BIZNO
						    , M.REST_YN
						    , M.BAD_YN
						    , R.WIN_TYPE '
						 +@ORDERY_SQL

  --PRINT @SQL_TOTALCNT
  --PRINT @SQL_COUNT
  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL_TOTALCNT
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL










GO
/****** Object:  StoredProcedure [dbo].[GET_MEMBER_REG_POINT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*회원 가입시 적립한 포인트 조회*/

CREATE PROC [dbo].[GET_MEMBER_REG_POINT_PROC]
       @USERID  VARCHAR(50)
AS

SET NOCOUNT ON

SELECT SUM(MY_SAVE_POINT) AS SAVE_POINT FROM PT_STATUS_TB WITH (NOLOCK)
 WHERE USERID=@USERID
   AND ITEM_SEQ IN ('A01','A48')
 GROUP BY USERID
GO
/****** Object:  StoredProcedure [dbo].[GET_MYPOINT_CNT_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/*************************************************************************************
 *  단위 업무 명 : 프론트 > 포인트 현황조회 > 나의 포인트 적립/사용내역
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-02-10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 나의 포인트 현황조회 리스트
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.GET_MYPOINT_CNT_LIST_PROC '1','10', 'rocker44', 'B', '', '', '2011-01-01', '2011-02-31'

 *************************************************************************************/

CREATE     PROCEDURE [dbo].[GET_MYPOINT_CNT_LIST_PROC]

  @n4Page				      INT
, @n2PageSize         SMALLINT
, @userID             VARCHAR(50) = ''  -- 아이디
, @point_term         VARCHAR(2) = ''   -- 기간설정 구분
, @point_dt           VARCHAR(7) = ''   -- 기간설정 년월
, @point_sec          VARCHAR(50) = ''  -- 섹션
, @datepicker1        VARCHAR(10) = ''  -- 적립/사용기간시작
, @datepicker2        VARCHAR(10) = ''  -- 적립/사용기간종료

AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL	NVARCHAR(4000)
DECLARE @strSQLSUB NVARCHAR(2000)

SET @strSQLSUB = ''

IF @userID <> ''	-- 아이디
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.USERID  = '''+@userID+''''
	END 

IF @point_sec <> ''	-- 섹션
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SEC  = '''+@point_sec+''''
	END 


IF @point_term = 'A' -- 기간설정인 경우
  BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_DT  LIKE '''+@point_dt+'%'''
	END

ELSE 
  IF @datepicker1 <> ''	-- 적립/사용기간시작
  	BEGIN
  		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_DT  >= '''+@datepicker1+''''
  	END 
  
  IF @datepicker2 <> ''	-- 적립/사용기간종료
  	BEGIN
  		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_DT  <= '''+@datepicker2+''''
  	END 


---------------------------------
-- 게시판리스트 SELECT
---------------------------------

SET @strSQL=' SELECT COUNT(1) FROM DBO.PT_STATUS_TB A (NOLOCK) WHERE 1 = 1 '+@strSQLSUB+' ;'


--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

SET NOCOUNT OFF












GO
/****** Object:  StoredProcedure [dbo].[GET_MYPOINT_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO













/*************************************************************************************
 *  단위 업무 명 : 프론트 > 포인트 현황조회 > 나의 포인트 적립/사용내역
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-02-10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 나의 포인트 현황조회 리스트
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.GET_MYPOINT_LIST_PROC '1','10', 'rocker44', 'B', '', '', '2011-01-01', '2011-01-31'

 *************************************************************************************/

CREATE      PROCEDURE [dbo].[GET_MYPOINT_LIST_PROC]

  @n4Page				      INT
, @n2PageSize         SMALLINT
, @userID             VARCHAR(50) = ''  -- 아이디
, @point_term         VARCHAR(2) = ''   -- 기간설정 구분
, @point_dt           VARCHAR(7) = ''   -- 기간설정 년월
, @point_sec          VARCHAR(50) = ''  -- 섹션
, @datepicker1        VARCHAR(10) = ''  -- 적립/사용기간시작
, @datepicker2        VARCHAR(10) = ''  -- 적립/사용기간종료

AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL	NVARCHAR(4000)
DECLARE @strSQLSUB NVARCHAR(2000)

SET @strSQLSUB = ''

IF @userID <> ''	-- 아이디
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.USERID  = '''+@userID+''''
	END 

IF @point_sec <> ''	-- 섹션
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SEC  = '''+@point_sec+''''
	END 


IF @point_term = 'A' -- 기간설정인 경우
  BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_DT  LIKE '''+@point_dt+'%'''
	END

ELSE 
  IF @datepicker1 <> ''	-- 적립/사용기간시작
  	BEGIN
  		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_DT  >= '''+@datepicker1+''''
  	END 
  
  IF @datepicker2 <> ''	-- 적립/사용기간종료
  	BEGIN
  		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_DT  <= '''+@datepicker2+''''
  	END 


---------------------------------
-- 게시판리스트 SELECT
---------------------------------

SET @strSQL=' SELECT COUNT(1) FROM DBO.PT_STATUS_TB A (NOLOCK) WHERE 1 = 1 '+@strSQLSUB+' ;'

IF @n4Page = 1 -- 맨 처음페이지일때
	
	BEGIN

     SET	Rowcount	@n2PageSize
     SET @strSQL= @strSQL+
     ' SELECT A.POINT_SEQ
          , A.USERID
          , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_GB'' AND X.CODEID = A.POINT_SAVE_GB) POINT_GB_NM
          , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_SEC'' AND X.CODEID = A.POINT_SEC) POINT_SEC_NM
          , A.POINT_SAVE_DT
          , A.POINT_SAVE_GB
          , A.POINT_CONT
          , A.POINT_EXPIRE_DT
          , A.MY_SAVE_POINT
          , A.MY_USED_POINT
          , A.MY_BALANCE_POINT
          , A.POINT_COMM
     FROM dbo.PT_STATUS_TB A (NOLOCK)
     WHERE 1= 1 '+@strSQLSUB+'
     AND ITEM_SEQ <> ''A39''
     ORDER BY A.POINT_SEQ DESC '

	END

ELSE

	BEGIN
		SET @strSQL= @strSQL+'
		DECLARE	@PrevCount	INT
		DECLARE	@n4ComID		INT

		SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'
		SET	RowCount	@PrevCount
	
		SELECT	@n4ComID = POINT_SEQ
		FROM DBO.PT_STATUS_TB A (NOLOCK)
    WHERE 1= 1 '+@strSQLSUB+'
		ORDER BY A.POINT_SEQ DESC
		
		SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'
		
		SELECT A.POINT_SEQ
         , A.USERID
         , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_GB'' AND X.CODEID = A.POINT_SAVE_GB) POINT_GB_NM
         , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_SEC'' AND X.CODEID = A.POINT_SEC) POINT_SEC_NM
         , A.POINT_SAVE_DT
         , A.POINT_SAVE_GB
         , A.POINT_CONT
         , A.POINT_EXPIRE_DT
         , A.MY_SAVE_POINT
         , A.MY_USED_POINT
         , A.MY_BALANCE_POINT
         , A.POINT_COMM
    FROM dbo.PT_STATUS_TB A (NOLOCK)
		WHERE A.POINT_SEQ < @n4ComID '+@strSQLSUB+' AND ITEM_SEQ <> ''A39'' ORDER BY A.POINT_SEQ DESC'

	END


PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

SET NOCOUNT OFF













GO
/****** Object:  StoredProcedure [dbo].[GET_PT_ALLPOINT_CNT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트 항목관리 > 포인트사용현황 카운트
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-25
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 포인트사용현황 카운트
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.GET_PT_ALLPOINT_CNT_PROC

 *************************************************************************************/

CREATE     PROCEDURE [dbo].[GET_PT_ALLPOINT_CNT_PROC]

AS

SET NOCOUNT ON


  
  -- 전체 사용포인트
  SELECT YYYYMMDD
       , TOTAL_POINT
       , USED_POINT
       , BALANCE_POINT
  FROM
  (
    SELECT '('+CONVERT(VARCHAR(10), GETDATE(), 120) + ' 현재)' YYYYMMDD
         , SUM(A.TOTAL_POINT) TOTAL_POINT
         , SUM(A.USED_POINT) USED_POINT
         , SUM(A.BALANCE_POINT) BALANCE_POINT
         , GROUPING(YYYYMM) GB
    FROM
    (
      --포인트사용현황 현재
      SELECT YYYYMM, TOTAL_POINT, USED_POINT, BALANCE_POINT
      FROM dbo.PT_MONTH_TB
      UNION ALL
      -- 월별 사용포인트
      SELECT REPLACE(CONVERT(VARCHAR(7), POINT_SAVE_DT, 120), '-', '') POINT_SAVE_DT
           , MY_SAVE_POINT
           , MY_USED_POINT
           , MY_BALANCE_POINT
      FROM dbo.PT_STATUS_TB
      WHERE POINT_SEQ IN 
      (
        SELECT TOP 50000 MAX(POINT_SEQ) POINT_SEQ
        FROM dbo.PT_STATUS_TB
		WHERE POINT_SAVE_DT LIKE CONVERT(VARCHAR(7), GETDATE(), 120) + '%'
        GROUP BY USERID
      )
      --AND POINT_SAVE_DT LIKE CONVERT(VARCHAR(7), GETDATE(), 120) + '%'
    ) A
    GROUP BY YYYYMM WITH ROLLUP
  ) MA
  WHERE MA.GB = 1

  /* 월별 사용포인트
  SELECT CONVERT(VARCHAR(7), POINT_SAVE_DT, 120) POINT_SAVE_DT
       , SUM(MY_SAVE_POINT) MY_SAVE_POINT
       , SUM(MY_USED_POINT) MY_USED_POINT
       , SUM(MY_BALANCE_POINT) MY_BALANCE_POINT
  FROM dbo.PT_STATUS_TB
  WHERE POINT_SEQ IN 
  (
    SELECT MAX(POINT_SEQ) POINT_SEQ
    FROM dbo.PT_STATUS_TB
    GROUP BY USERID
  )
  AND POINT_SAVE_DT LIKE CONVERT(VARCHAR(7), GETDATE(), 120) + '%'
  GROUP BY CONVERT(VARCHAR(7), POINT_SAVE_DT, 120)
  
  
  
  -- 유저별/월별 사용포인트
  SELECT POINT_SAVE_DT, POINT_SEQ, USERID, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
  FROM dbo.PT_STATUS_TB
  WHERE POINT_SEQ IN 
  (
    SELECT MAX(POINT_SEQ) POINT_SEQ
    FROM dbo.PT_STATUS_TB
    GROUP BY USERID
  )
  AND POINT_SAVE_DT LIKE CONVERT(VARCHAR(7), GETDATE(), 120) + '%'
  */



SET NOCOUNT OFF







GO
/****** Object:  StoredProcedure [dbo].[GET_PT_ITEM_LIST_CNT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트 항목관리 카운트(전체/진행)
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-18
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 포인트 항목관리 리스트
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.GET_PT_ITEM_LIST_CNT_PROC '', '', ''

 *************************************************************************************/

CREATE     PROCEDURE [dbo].[GET_PT_ITEM_LIST_CNT_PROC]

  @point_sec          VARCHAR(50) = ''
, @point_gb           CHAR(1) = ''
, @point_save_ing_gb  CHAR(1) = ''

AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL	NVARCHAR(4000)
DECLARE @strSQLSUB NVARCHAR(2000)

SET @strSQLSUB = ''

IF @point_sec <> ''	-- 섹션
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SEC  = '''+@point_sec+''''
	END 

IF @point_gb <> ''	-- 구분
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_GB  = '''+@point_gb+''''
	END 

IF @point_save_ing_gb <> ''	-- 진행여부
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_ING_GB  = '''+@point_save_ing_gb+''''
	END 


---------------------------------
-- 게시판리스트 카운트 SELECT
---------------------------------
SET @strSQL=' 

SELECT MAX(TOT) TOT, MAX(PT_ING) PT_ING, MAX(PT_CLOSE) PT_CLOSE
FROM
(
  SELECT COUNT(1) TOT
       , COUNT(CASE WHEN POINT_SAVE_ING_GB = ''Y'' THEN 1 END) PT_ING
       , COUNT(CASE WHEN POINT_SAVE_ING_GB = ''N'' THEN 1 END) PT_CLOSE
       , GROUPING(POINT_SAVE_ING_GB) GP
  FROM DBO.PT_ITEM_TB A (NOLOCK)
  WHERE 1 = 1 '+@strSQLSUB+'
  GROUP BY POINT_SAVE_ING_GB WITH ROLLUP
) A
WHERE A.GP = 1 

;'



--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

SET NOCOUNT OFF








GO
/****** Object:  StoredProcedure [dbo].[GET_PT_ITEM_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트 항목관리
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 포인트 항목관리 리스트
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.GET_PT_ITEM_LIST_PROC '1','10', '', '', ''

 *************************************************************************************/

CREATE          PROCEDURE [dbo].[GET_PT_ITEM_LIST_PROC]

  @n4Page				      INT
, @n2PageSize         SMALLINT
, @point_sec          VARCHAR(50) = ''
, @point_gb           CHAR(1) = ''
, @point_save_ing_gb  CHAR(1) = ''

AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL	NVARCHAR(4000)
DECLARE @strSQLSUB NVARCHAR(2000)

SET @strSQLSUB = ''

IF @point_sec <> ''	-- 섹션
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SEC  = '''+@point_sec+''''
	END 

IF @point_gb <> ''	-- 구분
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_GB  = '''+@point_gb+''''
	END 

IF @point_save_ing_gb <> ''	-- 진행여부
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_ING_GB  = '''+@point_save_ing_gb+''''
	END 


---------------------------------
-- 게시판리스트 SELECT
---------------------------------

SET @strSQL=' SELECT COUNT(1) FROM DBO.PT_ITEM_TB A (NOLOCK) WHERE 1 = 1 '+@strSQLSUB+' ;'

IF @n4Page = 1 -- 맨 처음페이지일때
	
	BEGIN

		SET	Rowcount	@n2PageSize
    SET @strSQL= @strSQL+
    ' SELECT A.ITEM_SEQ
          , ''A'' TYPE_SEQ
          , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_GB'' AND X.CODEID = A.POINT_GB) POINT_GB
          , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_SAVE_ING_GB'' AND X.CODEID = A.POINT_SAVE_ING_GB) POINT_SAVE_ING_GB
          , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_SEC'' AND X.CODEID = A.POINT_SEC) POINT_SEC_NM
          , A.POINT_USED_CONT 
          , A.POINT_SAVE
          , A.POINT_SAVE_STAND
          , A.POINT_SAVE_GB
          , CONVERT(VARCHAR(10), A.POINT_TERM_SDT, 120) POINT_TERM_SDT
          , CONVERT(VARCHAR(10), A.POINT_TERM_EDT, 120) POINT_TERM_EDT
          , CONVERT(VARCHAR(10), A.REG_DTE, 120) REG_DTE
          , A.POINT_SEC
     FROM DBO.PT_ITEM_TB A (NOLOCK)
     WHERE 1= 1 '+@strSQLSUB+'
     ORDER BY A.ITEM_SEQ DESC '

	END

ELSE

	BEGIN
		SET @strSQL= @strSQL+'
		DECLARE	@PrevCount	INT
		DECLARE	@n4ComID		INT

		SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'
		SET	RowCount	@PrevCount
	
		SELECT	@n4ComID = ITEM_SEQ
		FROM DBO.PT_ITEM_TB A (NOLOCK)
    WHERE 1= 1 '+@strSQLSUB+'
		ORDER BY A.ITEM_SEQ DESC
		
		SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'
		
		SELECT A.ITEM_SEQ
        , ''B'' TYPE_SEQ
        , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_GB'' AND X.CODEID = A.POINT_GB) POINT_GB
        , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_SAVE_ING_GB'' AND X.CODEID = A.POINT_SAVE_ING_GB) POINT_SAVE_ING_GB
        , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_SEC'' AND X.CODEID = A.POINT_SEC) POINT_SEC_NM
        , A.POINT_USED_CONT
        , A.POINT_SAVE
        , A.POINT_SAVE_STAND
        , A.POINT_SAVE_GB
        , CONVERT(VARCHAR(10), A.POINT_TERM_SDT, 120) POINT_TERM_SDT
        , CONVERT(VARCHAR(10), A.POINT_TERM_EDT, 120) POINT_TERM_EDT
        , CONVERT(VARCHAR(10), A.REG_DTE, 120) REG_DTE
        , A.POINT_SEC
    FROM DBO.PT_ITEM_TB A (NOLOCK)
		WHERE A.ITEM_SEQ < @n4ComID '+@strSQLSUB+' ORDER BY A.ITEM_SEQ DESC'

	END


PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

SET NOCOUNT OFF









GO
/****** Object:  StoredProcedure [dbo].[GET_PT_ITEM_MODI_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트항목관리 > 포인트항목관리 리스트
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-19
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.MOD_PT_ITEM_LIST_PROC 128

 *************************************************************************************/

CREATE       PROC [dbo].[GET_PT_ITEM_MODI_PROC]
	@ITEM_SEQ INT
AS

SET NOCOUNT ON

  SELECT A.ITEM_SEQ
      , A.POINT_GB
      , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = 'POINT_GB' AND X.CODEID = A.POINT_GB) POINT_GB_NM
      , A.POINT_SAVE_ING_GB
      , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = 'POINT_SAVE_ING_GB' AND X.CODEID = A.POINT_SAVE_ING_GB) POINT_SAVE_ING_GB_NM
      , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = 'POINT_SEC' AND X.CODEID = A.POINT_SEC) POINT_SEC_NM
      , A.POINT_USED_CONT 
      , A.POINT_SAVE
      , A.POINT_SAVE_STAND
      , A.POINT_SAVE_GB
      , CONVERT(VARCHAR(10), A.POINT_TERM_SDT, 120) POINT_TERM_SDT
      , CONVERT(VARCHAR(10), A.POINT_TERM_EDT, 120) POINT_TERM_EDT
      , CONVERT(VARCHAR(10), A.REG_DTE, 120) REG_DTE
      , A.POINT_SEC
  FROM DBO.PT_ITEM_TB A (NOLOCK)
  WHERE ITEM_SEQ = @ITEM_SEQ

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[GET_PT_MEMBER_LIST_CNT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트 항목관리 > 회원검색
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-20
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 포인트 항목관리 리스트
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : EXEC DBO.GET_PT_MEMBER_LIST_CNT_PROC 'USERNAME', '이제명'

 *************************************************************************************/

CREATE   PROCEDURE [dbo].[GET_PT_MEMBER_LIST_CNT_PROC]

  @KEY_CLS		VARCHAR(10)	-- 검색키	[아이디:M.USERID, 이름:USERNAME, 회사명:COM_NM , 이메일:EMAIL]
, @KEYWORD		VARCHAR(50)	-- 검색어

AS

/*********************************************************************
* Implementation Part
*********************************************************************/
  
  DECLARE	@SQL	NVARCHAR(4000)
  DECLARE @WHERE	NVARCHAR(1000)
  
  SET @SQL = ''
  SET @WHERE = ''
  
  ----------------------------------------
  -- 검색
  ----------------------------------------
  -- 검색어
  IF @KEY_CLS <> '' AND @KEYWORD <> ''
  BEGIN
  	SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' LIKE ''' + @KEYWORD + '%'' '
  	SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' <> '''' '
  END


---------------------------------
-- 게시판리스트 SELECT
---------------------------------

	SET @SQL =	'SELECT COUNT(M.USERID) AS CNT '+
				'      FROM	MEMBER.DBO.MM_MEMBER_TB M'+
				'	     LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID '+
				'	     LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID '+
				'      WHERE 1=1 ' + @WHERE + ';'

--PRINT @SQL
EXECUTE SP_EXECUTESQL @Sql





GO
/****** Object:  StoredProcedure [dbo].[GET_PT_MEMBER_SEARCH_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트 항목관리 > 회원검색
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-20
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 포인트 항목관리 리스트
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : EXEC DBO.GET_PT_MEMBER_SEARCH_PROC '1','15', 'USERNAME', '김민석'

 *************************************************************************************/

CREATE     PROCEDURE [dbo].[GET_PT_MEMBER_SEARCH_PROC]

  @n4Page				      INT
, @n2PageSize         SMALLINT
, @KEY_CLS		VARCHAR(10)	-- 검색키	[아이디:M.USERID, 이름:USERNAME, 회사명:COM_NM , 이메일:EMAIL]
, @KEYWORD		VARCHAR(50)	-- 검색어

AS

/*********************************************************************
* Implementation Part
*********************************************************************/
  
  DECLARE	@SQL	NVARCHAR(4000)
  DECLARE @WHERE	NVARCHAR(1000)
  
  SET @SQL = ''
  SET @WHERE = ''
  
  ----------------------------------------
  -- 검색
  ----------------------------------------
  -- 검색어
  IF @KEY_CLS <> '' AND @KEYWORD <> ''
  BEGIN
  	SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' LIKE ''' + @KEYWORD + '%'' '
  	SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' <> '''' '
  END


---------------------------------
-- 게시판리스트 SELECT
---------------------------------

	SET @SQL =	'SELECT COUNT(M.USERID) AS CNT '+
				'      FROM	MEMBER.DBO.MM_MEMBER_TB M'+
				'	     LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID '+
				'	     LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID '+
				'      WHERE 1=1 ' + @WHERE + ';' +

				'SELECT TOP ' + CONVERT(VARCHAR(10),@n4Page * @n2PageSize) +
				'    M.USERID'+
				'  , M.USERNAME'+
				'  , M.MEMBER_CD'+
				'  , M.JUMINNO_A+''-*******'' AS JUMINNO '+
				'  , M.JOIN_DT '+
				'  , M.SECTION_CD'+
				'  , M.OUT_APPLY_YN'+
				'  , M.REST_YN'+
				'  , M.BAD_YN'+
				'  , C.COM_NM  '+
				'  , C.BIZNO'+
        '  , CASE WHEN M.OUT_APPLY_YN =''N'' AND M.REST_YN = ''N'' AND M.BAD_YN = ''N'' THEN ''정상''    '+
        '    ELSE    '+
        '      CASE WHEN M.OUT_APPLY_YN =''Y'' THEN ''탈퇴''    '+
        '           WHEN M.REST_YN =''Y'' THEN ''휴먼''    '+
        '           WHEN M.BAD_YN =''Y'' THEN ''부적합 회원''    '+
        '      END    '+
        '    END USER_GB    '+
        '  , CASE WHEN M.OUT_APPLY_YN =''N'' AND M.REST_YN = ''N'' AND M.BAD_YN = ''N'' THEN ''#000000''    '+
        '    ELSE    '+
        '      CASE WHEN M.OUT_APPLY_YN =''Y'' THEN ''#D30000''    '+
        '           WHEN M.REST_YN =''Y'' THEN ''#000000''    '+
        '           WHEN M.BAD_YN =''Y'' THEN ''#D30000''    '+
        '      END    '+
        '    END COLOR    '+
        '  , ISNULL((  '+
        '    SELECT TOP 1 MY_BALANCE_POINT '+
        '    FROM dbo.PT_STATUS_TB A '+
        '    WHERE A.USERID = M.USERID '+
        '    ORDER BY POINT_SEQ DESC '+
        '  ), 0) POINT '+
			  ' FROM	MEMBER.DBO.MM_MEMBER_TB M'+
			  '	LEFT OUTER JOIN MEMBER.DBO.MM_COMPANY_TB C ON M.USERID = C.USERID '+
			  '	LEFT OUTER JOIN MEMBER.DBO.MM_OUT_TB O ON M.USERID = O.USERID '+
			  ' WHERE 1=1 ' + @WHERE +
			  'ORDER BY M.JOIN_DT DESC';

--PRINT @SQL
EXECUTE SP_EXECUTESQL @Sql







GO
/****** Object:  StoredProcedure [dbo].[GET_PT_MYPOINT_CNT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/*************************************************************************************
 *  단위 업무 명 : 중고장터 프론트 > 판매구매관리 > 나의 포인트
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-02-09
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 나의 최종 잔여 포인트 
 *  주 의  사 항 : 
 *  사 용  소 스 : http://new.used.findall.co.kr/MyShop/MyShopMain.asp
 *  EXEC : DBO.GET_PT_MYPOINT_CNT_PROC 'rocker44'
 *************************************************************************************/

CREATE   PROCEDURE [dbo].[GET_PT_MYPOINT_CNT_PROC]

  @USERID          VARCHAR(50)

AS

SET NOCOUNT ON


  -- 나의 최종 잔여 포인트
  SELECT TOP 1 USERID, 0 AS MY_BALANCE_POINT
  FROM dbo.PT_STATUS_TB NOLOCK WITH (INDEX (PT_STATUS_TB_IDX02))
  WHERE USERID = @USERID



SET NOCOUNT OFF







GO
/****** Object:  StoredProcedure [dbo].[GET_PT_MYPOINT_LIST_COUNT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트 현황조회 > 나의 포인트 적립/사용내역
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-21
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 포인트 현황조회 리스트
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.GET_PT_MYPOINT_LIST_COUNT_PROC 'rocker44', '', '2011-01-19', '2011-01-20'

 *************************************************************************************/

CREATE   PROCEDURE [dbo].[GET_PT_MYPOINT_LIST_COUNT_PROC]

  @userID             VARCHAR(50) = ''  -- 아이디
, @point_sec          VARCHAR(50) = ''  -- 섹션
, @datepicker1        VARCHAR(10) = ''  -- 적립/사용기간시작
, @datepicker2        VARCHAR(10) = ''  -- 적립/사용기간종료

AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL	NVARCHAR(4000)
DECLARE @strSQLSUB NVARCHAR(2000)

SET @strSQLSUB = ''

IF @userID <> ''	-- 아이디
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.USERID  = '''+@userID+''''
	END 

IF @point_sec <> ''	-- 섹션
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SEC  = '''+@point_sec+''''
	END 

IF @datepicker1 <> ''	-- 적립/사용기간시작
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_DT  >= '''+@datepicker1+''''
	END 

IF @datepicker2 <> ''	-- 적립/사용기간종료
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_DT  <= '''+@datepicker2+''''
	END 


---------------------------------
-- 게시판리스트 SELECT
---------------------------------

SET @strSQL=' SELECT COUNT(1) FROM DBO.PT_STATUS_TB A (NOLOCK) WHERE 1 = 1 '+@strSQLSUB+' ;'



PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

SET NOCOUNT OFF










GO
/****** Object:  StoredProcedure [dbo].[GET_PT_MYPOINT_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트 현황조회 > 나의 포인트 적립/사용내역
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-21
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 포인트 현황조회 리스트
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.GET_PT_MYPOINT_LIST_PROC '1','10', 'rocker44', '', '2011-01-19', '2011-01-25'

 *************************************************************************************/

CREATE    PROCEDURE [dbo].[GET_PT_MYPOINT_LIST_PROC]

  @n4Page				      INT
, @n2PageSize         SMALLINT
, @userID             VARCHAR(50) = ''  -- 아이디
, @point_sec          VARCHAR(50) = ''  -- 섹션
, @datepicker1        VARCHAR(10) = ''  -- 적립/사용기간시작
, @datepicker2        VARCHAR(10) = ''  -- 적립/사용기간종료

AS
SET NOCOUNT ON

/*********************************************************************
* Implementation Part
*********************************************************************/

DECLARE @strSQL	NVARCHAR(4000)
DECLARE @strSQLSUB NVARCHAR(2000)

SET @strSQLSUB = ''

IF @userID <> ''	-- 아이디
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.USERID  = '''+@userID+''''
	END 

IF @point_sec <> ''	-- 섹션
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SEC  = '''+@point_sec+''''
	END 

IF @datepicker1 <> ''	-- 적립/사용기간시작
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_DT  >= '''+@datepicker1+''''
	END 

IF @datepicker2 <> ''	-- 적립/사용기간종료
	BEGIN
		SET @strSQLSUB = @strSQLSUB+ ' AND A.POINT_SAVE_DT  <= '''+@datepicker2+''''
	END 


---------------------------------
-- 게시판리스트 SELECT
---------------------------------

SET @strSQL=' SELECT COUNT(1) FROM DBO.PT_STATUS_TB A (NOLOCK) WHERE 1 = 1 '+@strSQLSUB+' ;'

IF @n4Page = 1 -- 맨 처음페이지일때
	
	BEGIN

     SET	Rowcount	@n2PageSize
     SET @strSQL= @strSQL+
     ' SELECT A.POINT_SEQ
          , A.USERID
          , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_GB'' AND X.CODEID = A.POINT_SAVE_GB) POINT_GB_NM
          , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_SEC'' AND X.CODEID = A.POINT_SEC) POINT_SEC_NM
          , A.POINT_SAVE_DT
          , A.POINT_SAVE_GB
          , A.POINT_CONT
          , A.POINT_EXPIRE_DT
          , A.MY_SAVE_POINT
          , A.MY_USED_POINT
          , A.MY_BALANCE_POINT
          , A.POINT_COMM
     FROM dbo.PT_STATUS_TB A (NOLOCK)
     WHERE 1= 1 '+@strSQLSUB+'
     ORDER BY A.POINT_SEQ DESC '

	END

ELSE

	BEGIN
		SET @strSQL= @strSQL+'
		DECLARE	@PrevCount	INT
		DECLARE	@n4ComID		INT

		SET	@PrevCount	=	('+CAST(@n4Page AS VARCHAR(4))+' - 1)	*	'+CAST(@n2PageSize AS CHAR(2))+'
		SET	RowCount	@PrevCount
	
		SELECT	@n4ComID = POINT_SEQ
		FROM DBO.PT_STATUS_TB A (NOLOCK)
    WHERE 1= 1 '+@strSQLSUB+'
		ORDER BY A.POINT_SEQ DESC
		
		SET	Rowcount	'+CAST(@n2PageSize AS CHAR(2))+'
		
		SELECT A.POINT_SEQ
         , A.USERID
         , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_GB'' AND X.CODEID = A.POINT_SAVE_GB) POINT_GB_NM
         , (SELECT CODENM FROM DBO.TCC_COM_TB X WHERE X.GUBUN = ''POINT_SEC'' AND X.CODEID = A.POINT_SEC) POINT_SEC_NM
         , A.POINT_SAVE_DT
         , A.POINT_SAVE_GB
         , A.POINT_CONT
         , A.POINT_EXPIRE_DT
         , A.MY_SAVE_POINT
         , A.MY_USED_POINT
         , A.MY_BALANCE_POINT
         , A.POINT_COMM
    FROM dbo.PT_STATUS_TB A (NOLOCK)
		WHERE A.POINT_SEQ < @n4ComID '+@strSQLSUB+' ORDER BY A.POINT_SEQ DESC'

	END


--PRINT @strSQL
EXECUTE SP_EXECUTESQL @strSQL

SET NOCOUNT OFF











GO
/****** Object:  StoredProcedure [dbo].[MOD_PT_ITEM_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트항목관리 > 포인트항목관리 수정
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-19
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.MOD_PT_ITEM_LIST_PROC 128

 *************************************************************************************/

CREATE  PROC [dbo].[MOD_PT_ITEM_LIST_PROC]
	@ITEM_SEQ INT
, @I_POINT_SEC VARCHAR(50)
, @I_POINT_GB CHAR(1)
, @I_POINT_USED_CONT VARCHAR(400)
, @I_POINT_SAVE VARCHAR(50)
, @I_POINT_SAVE_STAND VARCHAR(100)
, @I_POINT_SAVE_GB CHAR(1)
, @I_DATEPICKER1 VARCHAR(10)
, @I_DATEPICKER2 VARCHAR(10)
, @I_POINT_SAVE_ING_GB CHAR(1)
, @USERID VARCHAR(50)	--@USERID VARCHAR(80)
AS

SET NOCOUNT ON
  
  UPDATE DBO.PT_ITEM_TB SET
    POINT_SEC = @I_POINT_SEC
  , POINT_GB = @I_POINT_GB
  , POINT_SAVE_ING_GB = @I_POINT_SAVE_ING_GB
  , POINT_USED_CONT = @I_POINT_USED_CONT
  , POINT_SAVE = @I_POINT_SAVE
  , POINT_SAVE_STAND = @I_POINT_SAVE_STAND
  , POINT_SAVE_GB = @I_POINT_SAVE_GB
  , POINT_TERM_SDT = CASE WHEN @I_POINT_SAVE_GB = 'A' THEN @I_DATEPICKER1 ELSE '' END
  , POINT_TERM_EDT = CASE WHEN @I_POINT_SAVE_GB = 'A' THEN @I_DATEPICKER2 ELSE '' END
  , MOD_DTE = GETDATE()
  , MOD_USERID = @USERID
  WHERE ITEM_SEQ = @ITEM_SEQ

SET NOCOUNT OFF






GO
/****** Object:  StoredProcedure [dbo].[PUT_COMM_NUJUK_POINT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*************************************************************************************
 *  단위 업무 명 : 프론트 > 올포인트 TEMP테이블에 있는 내역 적립
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-02-18
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 오늘날짜와 적립날짜가 같은 회원인경우 적립
 *  사 용  소 스 : 
 *  EXEC : EXEC DBO.PUT_COMM_NUJUK_POINT_PROC
 
 * PARAMS (DBO.TCC_COM_TB 참조)

 *************************************************************************************/

CREATE          PROC [dbo].[PUT_COMM_NUJUK_POINT_PROC]
  --@USERID VARCHAR(50)        -- 아이디

AS

BEGIN
  
  /**************************************
   *  1. 3, 10일후 적립 (아이디 전체일 경우)
   **************************************/

  INSERT INTO dbo.PT_STATUS_TB
  (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
  SELECT USERID
       , POINT_TYPE
       , POINT_SEC
       , POINT_SAVE_DT
       , 'A' POINT_SAVE_GB
       , POINT_CONT
       , POINT_EXPIRE_DT
       , MY_SAVE_POINT
       , MY_USED_POINT
       , (ISNULL(MY_BALANCE_POINT,0)+ISNULL(NUJUK,0)) MY_BALANCE_POINT
  FROM
  (
    SELECT TOP 100 PERCENT MA.USERID
         , POINT_TYPE
         , POINT_SEC
         , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
         , 'A' POINT_SAVE_GB
         , POINT_CONT
         , CONVERT(VARCHAR(8), DATEADD(MONTH, 1, DATEADD(YEAR, 1, GETDATE())), 120)+'01' POINT_EXPIRE_DT
         , MY_SAVE_POINT
         , MY_USED_POINT
         , MY_BALANCE_POINT
         , (
              SELECT SUM(MY_SAVE_POINT) 
              FROM dbo.PT_STATUS_TEMP_TB X 
              WHERE USERID = MA.USERID 
                AND X.POINT_SEQ <= MA.POINT_SEQ
           ) NUJUK
    FROM
    (
      -- [3, 10] 일후의 적립일자와 같은 데이터 추출
      -- POINT_SAVE_DT 에  [3, 10] 일후의 적립일자 매핑
      SELECT A.POINT_SEQ, A.USERID, A.POINT_SAVE_DT, A.MY_SAVE_POINT, A.MY_USED_POINT, A.POINT_CONT
           ,( 
              SELECT TOP 1  MY_BALANCE_POINT 
              FROM dbo.PT_STATUS_TB X (NOLOCK) 
              WHERE X.USERID = A.USERID 
              ORDER BY POINT_SEQ DESC
            ) MY_BALANCE_POINT
           , B.CODEID POINT_TYPE
           , B.TEXT04 POINT_SEC
      FROM dbo.PT_STATUS_TEMP_TB A (NOLOCK) INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
      ON B.CODEID = A.ITEM_SEQ AND B.GUBUN = 'POINT_TYPE'
        AND A.POINT_SAVE_DT = CONVERT(VARCHAR(10), GETDATE(), 120)
    ) MA
  ) TOT
  


  
  /**************************************
   *  1. 3, 10일후 적립 (개인일 경우)
   *************************************
  
  BEGIN
        
    INSERT INTO dbo.PT_STATUS_TB
    (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
    SELECT USERID
     , POINT_TYPE
         , POINT_SEC
         , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
         , 'A' POINT_SAVE_GB
         , POINT_CONT
         , MY_SAVE_POINT
         , MY_USED_POINT
         , (MY_BALANCE_POINT+NUJUK) MY_BALANCE_POINT
    FROM
    (
      SELECT TOP 100 PERCENT @USERID USERID
           , POINT_TYPE
           , POINT_SEC
           , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
           , 'A' POINT_SAVE_GB
           , POINT_CONT
           , MY_SAVE_POINT
           , MY_USED_POINT
           , MY_BALANCE_POINT
           , (
                SELECT SUM(MY_SAVE_POINT) 
                FROM dbo.PT_STATUS_TEMP_TB X 
                WHERE USERID = @USERID
                  AND X.POINT_SEQ <= MA.POINT_SEQ
             ) NUJUK
      FROM
      (
        -- [3, 10] 일후의 적립일자와 같은 데이터 추출
        -- POINT_SAVE_DT 에  [3, 10] 일후의 적립일자 매핑
        SELECT A.POINT_SEQ, A.POINT_SAVE_DT, A.MY_SAVE_POINT, A.MY_USED_POINT, A.POINT_CONT
             ,( 
                SELECT TOP 1  MY_BALANCE_POINT 
                FROM dbo.PT_STATUS_TB X (NOLOCK) 
                WHERE USERID = @USERID
                ORDER BY POINT_SEQ DESC
              ) MY_BALANCE_POINT
             , B.CODEID POINT_TYPE
             , B.TEXT04 POINT_SEC
        FROM dbo.PT_STATUS_TEMP_TB A (NOLOCK) INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
        ON B.CODEID = A.ITEM_SEQ AND B.GUBUN = 'POINT_TYPE'
        WHERE A.USERID = @USERID
          AND A.POINT_SAVE_DT = CONVERT(VARCHAR(10), GETDATE(), 120)
      ) MA
      --ORDER BY POINT_SEQ DESC
    ) TOT
    
  END
  
  */

  /**************************************
   *  TEMP데이터 삭제 (3/10일 후 적립일자가 같은 데이터만)
   **************************************/
  BEGIN
    DELETE FROM dbo.PT_STATUS_TEMP_TB WHERE POINT_SAVE_DT = CONVERT(VARCHAR(10), GETDATE(), 120)
  END

END
GO
/****** Object:  StoredProcedure [dbo].[PUT_COMM_POINT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 프론트 > 올포인트 적립 공통
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-02-14
 *  수   정   자 : 김 문 화
 *  수   정   일 : 2011-07-21
 *  설        명 : 이벤트 관련 포인트 적립/차감 추가
 *  수   정   자 : 이 경 덕
 *  수   정   일 : 2012-09-13
 *  설        명 : 파인드올 포인트소진 이벤트 포인트 차감 추가
 *  주 의  사 항 : 올포인트 적립 공통
 *  사 용  소 스 : 
 *  EXEC : EXEC DBO.PUT_COMM_POINT_PROC 'twoon', 'A40'
 
 * PARAMS (DBO.TCC_COM_TB 참조)

  1. POINT_TYPE (적립기준)
    1) A01	      최초 1회                회원가입완료
    2) A02	      최초 1회 	              업소홈피 등록완료
    4) A03	      최초 1회 	              광고주 인증완료
    5) A04	      최초 1회	              업소등록 완료
    6) A05	      1일 1회	                로그인 완료
    7) A06	      1일 1회 	              E-PAPER 정기구독 수신확인
    8) A07	      1일 1회 	              맞춤정보 수신확인(구인/부동산/자동차/상품&서비스)
    9) A08	      1일 1회 	              무료매물 등록완료
    10) A09	      1일 1회	                부동산 구합니다 등록완료
    11) A10	      월 1회	                무료컨설팅 신청완료
    12) A11	      1일 최대 3,000 적립 	  벼룩시장Plus > 독자참여마당 게시물 등록
    13) A12	      1일 최대 3,000 적립	    게시물등록_부동산지식인
    14) A13	      1일 최대 3,000 적립	    게시물등록_부동산광장1
    15) A14	      1일 최대 3,000 적립	    게시물등록_부동산광장2
    16) A15	      1일 최대 3,000 적립	    게시물등록_부동산광장3
    17) A16	      1일 최대 3,000 적립	    커뮤니티 등록완료
    18) A17	      3개월 내 재적립 불가 	  E-PAPER 정기구독 신청완료
    19) A18	      3개월 내 재적립 불가 	  맞춤정보 신청완료(구인/부동산/자동차/상품&서비스)
    20) A19	      3개월 내 재적립 불가	  이력서등록 완료    		
    21) A20~23	  3일 후 적립	            인터넷광고등록 결제완료
    22) A24~27	  3일 후 적립	            신문직접등록 결제완료
    23) A28	      3일 후 적립	            유료옵션 결제완료
    24) A29	      3일 후 적립	            일반매물_무료등록완료
    25) A30	      3일 후 적립	            일반매물_유료옵션 결제완료
    26) A31	      3일 후 적립	            다량매물_유료옵션 결제완료
    27) A32	      3일 후 적립	            분양매물_무료등록완료
    28) A33	      3일 후 적립	            분양매물_유료옵션결제완료
    29) A34	      10일 후 적립	          다량등록권구매 결제완료

    30) A38       1일 최대 3,000 적립     벼룩시장플러스 독자참여 댓글
    31) A39       1일 최대 3,000 적립     이벤트존 댓글
    32) A40       최초 1회                즐겨찾기 추가
    33) A41       -200 포인트             2011-06 이벤트 응모
    34) A42       최초 1회 1000 적립      2011 벼룩시장 에코이벤트 약속
    35) A43       최초 1회 1000 적립      2011 벼룩시장 에코이벤트 약속
    36) A44       최초 1회 5000 차감      2011 벼룩시장 에코이벤트 응모
    37) A45       최초 1회 3000 차감      2011 벼룩시장 에코이벤트 응모
    38) A46       최초 1회 1000 차감      2011 벼룩시장 에코이벤트 응모
    39) A47       최초 1회 차감없음       2011 벼룩시장 에코이벤트 응모
    40) A48       최초 1회                회원가입 선택 사항 입력
    41) A49       포인트 차감      		  파인드올 포인트소진 이벤트 신세계상품권 300,000
    42) A50       포인트 차감       	  파인드올 포인트소진 이벤트 신세계상품권 50,000
    43) A51       포인트 차감             파인드올 포인트소진 이벤트 신세계상품권 5,000


  2. POINT_SEC (포인트 섹션)
    1)  A002 - 파인드올
    2)  A003 - 파인드하우스
    3)  A004 - 회원
    4)  A005 - 벼룩시장
    5)  A006 - 벼룩시장 구인구직
    6)  A007 - 벼룩시장 부동산
    7)  A008 - 벼룩시장 자동차
    8)  A009 - 벼룩시장 상품&서비스
    9)  A010 - 중고장터
    10) A011 - 키워드샵
    11) A012 - 맛집경영
    12) A013 - 고객센터
    13) A014 - 운영자판단
    15) A015 - 이벤트


 *************************************************************************************/
CREATE                       PROC [dbo].[PUT_COMM_POINT_PROC]
  @USERID VARCHAR(50)        -- 아이디
, @I_ITEM_SEQ VARCHAR(3)     -- 적립기준 (POINT_TYPE)

AS

BEGIN

  DECLARE @CHECK INT
  DECLARE @POINT_CHK INT

  SET @CHECK = 0
  SET @POINT_CHK = (SELECT COUNT(POINT_SEQ) FROM dbo.PT_STATUS_TB WHERE USERID = @USERID)


  /**************************************
   *  포인트 등록건이 한건도 없을경우
   **************************************/
  IF @POINT_CHK = 0
    BEGIN
      INSERT INTO dbo.PT_STATUS_TB
      (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
      SELECT @USERID USERID
           , 'TMP' POINT_TYPE
           , 'TMP' POINT_SEC
           , '' POINT_SAVE_DT
           , '' POINT_SAVE_GB
           , '' POINT_CONT
           , 0 MY_SAVE_POINT
           , 0 MY_USED_POINT
           , 0 MY_BALANCE_POINT
    END

  
  /**************************************
   *  1. 최초 1회
   **************************************/
  IF @I_ITEM_SEQ IN ('A01', 'A02', 'A03', 'A04', 'A40', 'A41', 'A42', 'A43','A48')
  BEGIN
    IF NOT EXISTS (
      SELECT '1' 
      FROM dbo.PT_STATUS_TB (NOLOCK) 
      WHERE USERID = @USERID 
        AND ITEM_SEQ = @I_ITEM_SEQ
    )    
    BEGIN
      
      IF @I_ITEM_SEQ <> 'A43'
      BEGIN
        INSERT INTO dbo.PT_STATUS_TB
        (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
        SELECT @USERID USERID
             , POINT_TYPE
             , POINT_SEC
             , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
             , 'A' POINT_SAVE_GB
             , CODENM POINT_CONT
             , CONVERT(VARCHAR(8), DATEADD(MONTH, 1, DATEADD(YEAR, 1, GETDATE())), 120)+'01' POINT_EXPIRE_DT
             , CASH MY_SAVE_POINT
             , 0 MY_USED_POINT
             , (MY_BALANCE_POINT+CASH) MY_BALANCE_POINT
        FROM
        (
          SELECT A.POINT_SEQ, A.MY_SAVE_POINT, A.MY_USED_POINT, A.MY_BALANCE_POINT
               , B.CODEID POINT_TYPE, B.CODENM, B.TEXT02 CASH, B.TEXT03 CASH_GB, B.TEXT04 POINT_SEC
          FROM
          (
            SELECT TOP 1 POINT_SEQ
                 , MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
            FROM dbo.PT_STATUS_TB A (NOLOCK)
            WHERE USERID = @USERID
            ORDER BY POINT_SEQ DESC
          ) A INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
          ON B.GUBUN = 'POINT_TYPE'
            AND B.CODEID = @I_ITEM_SEQ
        ) MA
  
        SELECT @CHECK = 1
      END
      ELSE
      BEGIN
          --이벤트 E-PAPER구독의 경우 3개월내 기존 정기구독 신청내역 확인
          IF NOT EXISTS (      
          SELECT '1'
          FROM 
          (
            SELECT POINT_SEQ
            FROM dbo.PT_STATUS_TB (NOLOCK) 
            WHERE USERID = @USERID
              AND ITEM_SEQ = 'A17' 
              AND DATEADD(MONTH, 3, POINT_SAVE_DT) >= GETDATE()
          ) A
        )
        BEGIN    
          INSERT INTO dbo.PT_STATUS_TB
          (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
          SELECT @USERID USERID
               , POINT_TYPE
               , POINT_SEC
               , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
               , 'A' POINT_SAVE_GB
               , CODENM POINT_CONT
               , CONVERT(VARCHAR(8), DATEADD(MONTH, 1, DATEADD(YEAR, 1, GETDATE())), 120)+'01' POINT_EXPIRE_DT
               , CASH MY_SAVE_POINT
               , 0 MY_USED_POINT
               , (MY_BALANCE_POINT+CASH) MY_BALANCE_POINT
          FROM
          (
            SELECT A.POINT_SEQ, A.MY_SAVE_POINT, A.MY_USED_POINT, A.MY_BALANCE_POINT
                 , B.CODEID POINT_TYPE, B.CODENM, B.TEXT02 CASH, B.TEXT03 CASH_GB, B.TEXT04 POINT_SEC
            FROM
            (
              SELECT TOP 1 POINT_SEQ
                   , MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
              FROM dbo.PT_STATUS_TB A (NOLOCK)
              WHERE USERID = @USERID
              ORDER BY POINT_SEQ DESC
            ) A INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
            ON B.GUBUN = 'POINT_TYPE'
              AND B.CODEID = @I_ITEM_SEQ
          ) MA
    
          SELECT @CHECK = 1
        END
      END
    END
  END

  /**************************************
   *  2. 1일 1회
   **************************************/
  IF @I_ITEM_SEQ IN ('A05', 'A06', 'A07', 'A08', 'A09')
  BEGIN
    IF NOT EXISTS (
      SELECT '1' 
      FROM dbo.PT_STATUS_TB (NOLOCK) 
      WHERE USERID = @USERID 
        AND ITEM_SEQ = @I_ITEM_SEQ
        AND POINT_SAVE_DT = CONVERT(VARCHAR(10), GETDATE(), 120)
    )   
    BEGIN 

      
      INSERT INTO dbo.PT_STATUS_TB
      (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
      SELECT @USERID USERID
           , POINT_TYPE
           , POINT_SEC
           , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
           , 'A' POINT_SAVE_GB
           , CODENM POINT_CONT
           , CONVERT(VARCHAR(8), DATEADD(MONTH, 1, DATEADD(YEAR, 1, GETDATE())), 120)+'01' POINT_EXPIRE_DT
           , CASH MY_SAVE_POINT
           , 0 MY_USED_POINT
           , (MY_BALANCE_POINT+CASH) MY_BALANCE_POINT
      FROM
      (
        SELECT A.POINT_SEQ, A.MY_SAVE_POINT, A.MY_USED_POINT, A.MY_BALANCE_POINT
             , B.CODEID POINT_TYPE, B.CODENM, B.TEXT02 CASH, B.TEXT03 CASH_GB, B.TEXT04 POINT_SEC
        FROM
        (
          SELECT TOP 1 POINT_SEQ
               , MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
          FROM dbo.PT_STATUS_TB A (NOLOCK)
          WHERE USERID = @USERID
          ORDER BY POINT_SEQ DESC
        ) A INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
        ON B.GUBUN = 'POINT_TYPE'
          AND B.CODEID = @I_ITEM_SEQ
      ) MA

      SELECT @CHECK = 1
    END
  END
  /**************************************
   *  3. 월 1회
   **************************************/
  IF @I_ITEM_SEQ = 'A10'
  BEGIN
    IF NOT EXISTS (
      SELECT '1' 
      FROM dbo.PT_STATUS_TB (NOLOCK) 
      WHERE USERID = @USERID 
        AND ITEM_SEQ = @I_ITEM_SEQ
        AND POINT_SAVE_DT >= CONVERT(VARCHAR(7), GETDATE(), 120)+'-01'
        AND POINT_SAVE_DT <= CONVERT(VARCHAR(7), GETDATE(), 120)+'-31'
    )    
    BEGIN
      INSERT INTO dbo.PT_STATUS_TB
      (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
      SELECT @USERID USERID
           , POINT_TYPE
           , POINT_SEC
           , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
           , 'A' POINT_SAVE_GB
           , CODENM POINT_CONT
           , CONVERT(VARCHAR(8), DATEADD(MONTH, 1, DATEADD(YEAR, 1, GETDATE())), 120)+'01' POINT_EXPIRE_DT
           , CASH MY_SAVE_POINT
           , 0 MY_USED_POINT
           , (MY_BALANCE_POINT+CASH) MY_BALANCE_POINT
      FROM
      (
        SELECT A.POINT_SEQ, A.MY_SAVE_POINT, A.MY_USED_POINT, A.MY_BALANCE_POINT
             , B.CODEID POINT_TYPE, B.CODENM, B.TEXT02 CASH, B.TEXT03 CASH_GB, B.TEXT04 POINT_SEC
        FROM
        (
          SELECT TOP 1 POINT_SEQ
               , MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
          FROM dbo.PT_STATUS_TB A (NOLOCK)
          WHERE USERID = @USERID
          ORDER BY POINT_SEQ DESC
        ) A INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
        ON B.GUBUN = 'POINT_TYPE'
          AND B.CODEID = @I_ITEM_SEQ
      ) MA
      
      SELECT @CHECK = 1
    END
  END


  /**************************************
   *  4. 1일 최대 3,000 적립
   **************************************/
  IF @I_ITEM_SEQ IN ('A11', 'A12', 'A13', 'A14', 'A15', 'A16','A38','A39')
  BEGIN
    IF NOT EXISTS (
      SELECT SUM(MY_SAVE_POINT)
      FROM dbo.PT_STATUS_TB (NOLOCK) 
      WHERE USERID = @USERID
        --AND ITEM_SEQ = @I_ITEM_SEQ
        AND ITEM_SEQ IN ('A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A38', 'A39')
        AND POINT_SAVE_DT = CONVERT(VARCHAR(10), GETDATE(), 120)
      GROUP BY USERID
      HAVING SUM(MY_SAVE_POINT) >= 3000
    )
    BEGIN    
      INSERT INTO dbo.PT_STATUS_TB
      (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
      SELECT @USERID USERID
           , POINT_TYPE
           , POINT_SEC
           , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
           , 'A' POINT_SAVE_GB
           , CODENM POINT_CONT
           , CONVERT(VARCHAR(8), DATEADD(MONTH, 1, DATEADD(YEAR, 1, GETDATE())), 120)+'01' POINT_EXPIRE_DT
           , CASH MY_SAVE_POINT
           , 0 MY_USED_POINT
           , (MY_BALANCE_POINT+CASH) MY_BALANCE_POINT
      FROM
      (
        SELECT A.POINT_SEQ, A.MY_SAVE_POINT, A.MY_USED_POINT, A.MY_BALANCE_POINT
             , B.CODEID POINT_TYPE, B.CODENM, B.TEXT02 CASH, B.TEXT03 CASH_GB, B.TEXT04 POINT_SEC
        FROM
        (
          SELECT TOP 1 POINT_SEQ
               , MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
          FROM dbo.PT_STATUS_TB A (NOLOCK)
          WHERE USERID = @USERID
          ORDER BY POINT_SEQ DESC
        ) A INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
        ON B.GUBUN = 'POINT_TYPE'
          AND B.CODEID = @I_ITEM_SEQ
      ) MA

      SELECT @CHECK = 1
    END
  END

  /**************************************
   *  5. 3개월 내 재적립 불가
   **************************************/
  IF @I_ITEM_SEQ IN ('A17', 'A18', 'A19')
  BEGIN
    IF NOT EXISTS (      
      SELECT '1'
      FROM 
      (
        SELECT POINT_SAVE_DT
             , CONVERT(VARCHAR(10), DATEADD(MONTH, 3, POINT_SAVE_DT), 120) EDT
        FROM dbo.PT_STATUS_TB (NOLOCK) 
        WHERE USERID = @USERID
          AND ITEM_SEQ = @I_ITEM_SEQ  
      ) A
      WHERE POINT_SAVE_DT <= EDT
    )
    BEGIN
      IF @I_ITEM_SEQ <> 'A17'
      BEGIN
          INSERT INTO dbo.PT_STATUS_TB
          (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
          SELECT @USERID USERID
               , POINT_TYPE
               , POINT_SEC
               , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
               , 'A' POINT_SAVE_GB
               , CODENM POINT_CONT
               , CONVERT(VARCHAR(8), DATEADD(MONTH, 1, DATEADD(YEAR, 1, GETDATE())), 120)+'01' POINT_EXPIRE_DT
               , CASH MY_SAVE_POINT
               , 0 MY_USED_POINT
               , (MY_BALANCE_POINT+CASH) MY_BALANCE_POINT
          FROM
          (
            SELECT A.POINT_SEQ, A.MY_SAVE_POINT, A.MY_USED_POINT, A.MY_BALANCE_POINT
                 , B.CODEID POINT_TYPE, B.CODENM, B.TEXT02 CASH, B.TEXT03 CASH_GB, B.TEXT04 POINT_SEC
            FROM
            (
              SELECT TOP 1 POINT_SEQ
                   , MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
              FROM dbo.PT_STATUS_TB A (NOLOCK)
              WHERE USERID = @USERID
              ORDER BY POINT_SEQ DESC
            ) A INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
            ON B.GUBUN = 'POINT_TYPE'
              AND B.CODEID = @I_ITEM_SEQ
          ) MA
    
          SELECT @CHECK = 1
      END
      ELSE
      BEGIN
          --E-PAPER 정기구독의 경우 3개월내 이벤트 신청내역도 확인
          IF NOT EXISTS (      
            SELECT '1'
            FROM 
            (
              SELECT POINT_SEQ
              FROM dbo.PT_STATUS_TB (NOLOCK) 
              WHERE USERID = @USERID
                AND ITEM_SEQ = 'A43' 
                AND DATEADD(MONTH, 3, POINT_SAVE_DT) >= GETDATE()
            ) A
          )
         BEGIN
            INSERT INTO dbo.PT_STATUS_TB
            (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
            SELECT @USERID USERID
                 , POINT_TYPE
                 , POINT_SEC
                 , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
                 , 'A' POINT_SAVE_GB
                 , CODENM POINT_CONT
                 , CONVERT(VARCHAR(8), DATEADD(MONTH, 1, DATEADD(YEAR, 1, GETDATE())), 120)+'01' POINT_EXPIRE_DT
                 , CASH MY_SAVE_POINT
                 , 0 MY_USED_POINT
                 , (MY_BALANCE_POINT+CASH) MY_BALANCE_POINT
            FROM
            (
              SELECT A.POINT_SEQ, A.MY_SAVE_POINT, A.MY_USED_POINT, A.MY_BALANCE_POINT
                   , B.CODEID POINT_TYPE, B.CODENM, B.TEXT02 CASH, B.TEXT03 CASH_GB, B.TEXT04 POINT_SEC
              FROM
              (
                SELECT TOP 1 POINT_SEQ
                     , MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
                FROM dbo.PT_STATUS_TB A (NOLOCK)
                WHERE USERID = @USERID
                ORDER BY POINT_SEQ DESC
              ) A INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
              ON B.GUBUN = 'POINT_TYPE'
                AND B.CODEID = @I_ITEM_SEQ
            ) MA
      
            SELECT @CHECK = 1
         END
      END
    END
  END

  /**************************************
   *  6. 계속 실행(차감)
   **************************************/
  IF @I_ITEM_SEQ IN ('A41','A49','A50','A51')
  BEGIN

    INSERT INTO dbo.PT_STATUS_TB
    (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
    SELECT @USERID USERID
         , POINT_TYPE
         , POINT_SEC
         , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
         , 'B' POINT_SAVE_GB
         , CODENM POINT_CONT
         , '' POINT_EXPIRE_DT
         , 0 MY_SAVE_POINT
         , CASH MY_USED_POINT
         , (MY_BALANCE_POINT-CASH) MY_BALANCE_POINT
    FROM
    (
      SELECT A.POINT_SEQ, A.MY_SAVE_POINT, A.MY_USED_POINT, A.MY_BALANCE_POINT
           , B.CODEID POINT_TYPE, B.CODENM, B.TEXT02 CASH, B.TEXT03 CASH_GB, B.TEXT04 POINT_SEC
      FROM
      (
        SELECT TOP 1 POINT_SEQ
             , MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
        FROM dbo.PT_STATUS_TB A (NOLOCK)
        WHERE USERID = @USERID
        ORDER BY POINT_SEQ DESC
      ) A INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
      ON B.GUBUN = 'POINT_TYPE'
        AND B.CODEID = @I_ITEM_SEQ
    ) MA

    SELECT @CHECK = 1

  END

  /**************************************
   *  7. 최초 1회 차감
   **************************************/
  IF @I_ITEM_SEQ IN ('A44', 'A45', 'A46', 'A47')
  BEGIN
    IF NOT EXISTS (
      SELECT '1' 
      FROM dbo.PT_STATUS_TB (NOLOCK) 
      WHERE USERID = @USERID 
        AND ITEM_SEQ = @I_ITEM_SEQ
    )    
    BEGIN
        
      INSERT INTO dbo.PT_STATUS_TB
      (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
      SELECT @USERID USERID
           , POINT_TYPE
           , POINT_SEC
           , CONVERT(VARCHAR(10), GETDATE(), 120) POINT_SAVE_DT
           , 'B' POINT_SAVE_GB
           , CODENM POINT_CONT
           , '' POINT_EXPIRE_DT
           , 0 MY_SAVE_POINT
           , CASH MY_USED_POINT
           , (MY_BALANCE_POINT-CASH) MY_BALANCE_POINT
      FROM
      (
        SELECT A.POINT_SEQ, A.MY_SAVE_POINT, A.MY_USED_POINT, A.MY_BALANCE_POINT
             , B.CODEID POINT_TYPE, B.CODENM, B.TEXT02 CASH, B.TEXT03 CASH_GB, B.TEXT04 POINT_SEC
        FROM
        (
          SELECT TOP 1 POINT_SEQ
               , MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
          FROM dbo.PT_STATUS_TB A (NOLOCK)
          WHERE USERID = @USERID
          ORDER BY POINT_SEQ DESC
        ) A INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
        ON B.GUBUN = 'POINT_TYPE'
          AND B.CODEID = @I_ITEM_SEQ
      ) MA

      SELECT @CHECK = 1
    END
  END

  /**************************************
   *  TEMP데이터 삭제
   **************************************/
  BEGIN
    DELETE FROM dbo.PT_STATUS_TB WHERE USERID = @USERID AND POINT_SEC ='TMP'
  END


  RETURN @CHECK
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_COMM_TEMP_POINT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*************************************************************************************
 *  단위 업무 명 : 프론트 > 올포인트 결제완료 후 적립
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-02-17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : TEMP테이블에 누적
 *  사 용  소 스 : 
 *  EXEC : EXEC DBO.PUT_COMM_TEMP_POINT_PROC 'rocker44', 'A34', 5000
 
 * PARAMS (DBO.TCC_COM_TB 참조)

 *************************************************************************************/

CREATE          PROC [dbo].[PUT_COMM_TEMP_POINT_PROC]
  @USERID VARCHAR(50)        -- 아이디
, @I_ITEM_SEQ VARCHAR(3)     -- 적립기준 (POINT_TYPE)
, @I_CASH  INT               -- 포인트 금액

AS

BEGIN

  DECLARE @CHECK INT
  DECLARE @POINT_CHK INT
  DECLARE @PLUSDATE  VARCHAR(10)  -- 중고장터 적립일

  SET @CHECK = 0
  SET @POINT_CHK = (SELECT COUNT(POINT_SEQ) FROM dbo.PT_STATUS_TB WHERE USERID = @USERID)
  SET @PLUSDATE = CONVERT(VARCHAR(10), DATEADD(DAY, 3, GETDATE()), 120)



  /**************************************일
   **************************************/
  IF @POINT_CHK = 0
    BEGIN
      INSERT INTO dbo.PT_STATUS_TB
      (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
      SELECT @USERID USERID
           , 'TMP' POINT_TYPE
           , 'TMP' POINT_SEC
           , '' POINT_SAVE_DT
           , '' POINT_SAVE_GB
           , '' POINT_CONT
           , 0 MY_SAVE_POINT
           , 0 MY_USED_POINT
           , 0 MY_BALANCE_POINT
    END

  
  /**************************************
   *  1. 3, 10일후 적립
   **************************************/
  IF @I_ITEM_SEQ >= 'A20' --3, 10일후 적립은 코드가 A20부터시작..
  
  BEGIN
        
    INSERT INTO dbo.PT_STATUS_TEMP_TB
    (USERID, ITEM_SEQ, POINT_SEC, POINT_SAVE_DT, POINT_SAVE_GB, POINT_CONT, POINT_EXPIRE_DT, MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT)
    SELECT @USERID USERID
         , POINT_TYPE
         , POINT_SEC
         , CASE WHEN @I_ITEM_SEQ = 'A28' THEN @PLUSDATE ELSE CONVERT(VARCHAR(10), GETDATE(), 120) END POINT_SAVE_DT
         , 'A' POINT_SAVE_GB
         , CODENM POINT_CONT
         , CONVERT(VARCHAR(8), DATEADD(MONTH, 1, DATEADD(YEAR, 1, GETDATE())), 120)+'01' POINT_EXPIRE_DT
         , (
           CASE WHEN @I_ITEM_SEQ='A37' THEN @I_CASH
                ELSE CASE WHEN MA.CASH_GB = 'P' THEN CASH * @I_CASH 
                          ELSE CASH 
                     END
           END) MY_SAVE_POINT
         , 0 MY_USED_POINT
         , MY_BALANCE_POINT + (
                               CASE WHEN @I_ITEM_SEQ='A37' THEN @I_CASH
                                    ELSE CASE WHEN MA.CASH_GB = 'P' THEN CASH * @I_CASH 
                                              ELSE CASH 
                                         END
                               END) MY_BALANCE_POINT
    FROM
    (
      SELECT A.POINT_SEQ, A.MY_SAVE_POINT, A.MY_USED_POINT, A.MY_BALANCE_POINT
           , B.CODEID POINT_TYPE, B.CODENM, CAST(B.TEXT02 AS MONEY) CASH
           , B.TEXT03 CASH_GB, B.TEXT04 POINT_SEC, B.SORT JUKRIP_DAY
      FROM
      (
        SELECT TOP 1 POINT_SEQ
             , MY_SAVE_POINT, MY_USED_POINT, MY_BALANCE_POINT
        FROM dbo.PT_STATUS_TB A (NOLOCK)
        WHERE USERID = @USERID
        ORDER BY POINT_SEQ DESC
      ) A INNER JOIN dbo.TCC_COM_TB B (NOLOCK) 
      ON B.GUBUN = 'POINT_TYPE'
        AND B.CODEID = @I_ITEM_SEQ
    ) MA
    
    BEGIN
      SELECT @CHECK = 1
    END

  END


  /**************************************
   *  TEMP데이터 삭제
   **************************************/
  BEGIN
    DELETE FROM dbo.PT_STATUS_TB WHERE USERID = @USERID AND POINT_SEC ='TMP'
  END

END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PT_EVENT_ECO_ENTRY_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/********************************************************************************
 *  단위 업무 명 : 2011 벼룩시장 에코캠페인 이벤트 
 *  작   성   자 : 김 문 화 (lgtaiji@mediawill.com)
 *  작   성   일 : 2011-07-21
 *  설        명 : 응모정보 등록
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  EXEC         : EXEC DBO.PUT_F_PT_EVENT_ECO_ENTRY_TB_INSERT_PROC 'findjob', 'A42'
********************************************************************************/

CREATE           PROC [dbo].[PUT_F_PT_EVENT_ECO_ENTRY_TB_INSERT_PROC]
  @USERID        VARCHAR(50)            -- USERID
 ,@CODE          VARCHAR(3)
AS
BEGIN
	SET NOCOUNT ON
  
  DECLARE @CNT INT

  SELECT @CNT = COUNT(IDX) FROM PT_EVENT_ECO_ENTRY_TB 
  WHERE USER_ID = @USERID AND ITEM_SEQ = @CODE

  IF @CNT = 0
  BEGIN
  --응모 등록
    INSERT INTO PT_EVENT_ECO_ENTRY_TB
    ( USER_ID,ITEM_SEQ ) VALUES ( @USERID, @CODE )

    RETURN 1
  END
  ELSE BEGIN
    RETURN 2
  END
END

IF @@ERROR <> 0
BEGIN
  RETURN -1
END



GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PT_EVENT_ENTRY_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************************
 *  단위 업무 명 : 2011 벼룩시장 포인트 이벤트응모 
 *  작   성   자 : 김 문 화 (lgtaiji@mediawill.com)
 *  작   성   일 : 2011-09-20
 *  설        명 : 응모정보 등록
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  EXEC         : EXEC DBO.PUT_F_PT_EVENT_ENTRY_TB_INSERT_PROC 'findjob', 'A42'
********************************************************************************/

CREATE            PROC [dbo].[PUT_F_PT_EVENT_ENTRY_TB_INSERT_PROC]
  @USERID        VARCHAR(50)            -- USERID
 ,@CODE          VARCHAR(3)
AS
BEGIN
	SET NOCOUNT ON
  
  DECLARE @CNT INT

  SELECT @CNT = COUNT(IDX) FROM PT_EVENT_ENTRY_TB 
  WHERE USER_ID = @USERID AND ITEM_SEQ = @CODE

  IF @CNT = 0
  BEGIN
  --응모 등록
    INSERT INTO PT_EVENT_ENTRY_TB
    ( USER_ID,ITEM_SEQ ) VALUES ( @USERID, @CODE )

    RETURN 1
  END
  ELSE BEGIN
    RETURN 2
  END
END

IF @@ERROR <> 0
BEGIN
  RETURN -1
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/********************************************************************************
 *  단위 업무 명 : 2013 벼룩시장 파인드올 포인트 소진 이벤트 
 *  작   성   자 : 이 경 덕 (laplance@mediawill.com)
 *  작   성   일 : 2013-01-07
 *  설        명 : 응모정보 등록
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  EXEC         : EXEC DBO.PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB 'laplance', 'A' , 39, 'A49'
********************************************************************************/

CREATE         	 PROC [dbo].[PUT_F_PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB_INSERT_PROC]
  @USERID        VARCHAR(50)            -- USERID
 ,@EVENTTYPE	 CHAR(1)
 ,@EVENTSEQ		 INT
 ,@CODEID 		 VARCHAR(10)
AS
BEGIN 
	SET NOCOUNT ON

  --응모 등록
    INSERT INTO PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB (USERID, EVENT_TYPE, EVENT_SEQ, CODEID) VALUES (@USERID, @EVENTTYPE, @EVENTSEQ, @CODEID)
END

IF @@ERROR <> 0
BEGIN
  RETURN -1
END


GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PT_EVENT_REDUCE_ENTRY_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/********************************************************************************
 *  단위 업무 명 : 2012 벼룩시장 파인드올 포인트 소진 프로모션 이벤트 
 *  작   성   자 : 이 경 덕 (laplance@mediawill.com)
 *  작   성   일 : 2012-09-12
 *  설        명 : 응모정보 등록
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  EXEC         : EXEC DBO.PUT_F_PT_EVENT_REDUCE_ENTRY_TB_INSERT_PROC 'findjob', '0'
********************************************************************************/

CREATE        	 PROC [dbo].[PUT_F_PT_EVENT_REDUCE_ENTRY_TB_INSERT_PROC]
  @USERID        VARCHAR(50)            -- USERID
 ,@EVENTNUM      INT
AS
BEGIN 
	SET NOCOUNT ON

  --응모 등록
    INSERT INTO PT_EVENT_REDUCE_ENTRY_TB (USERID, EVENT_NUM ) VALUES ( @USERID, @EVENTNUM)
END

IF @@ERROR <> 0
BEGIN
  RETURN -1
END




GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PT_EVENT_REDUCE_WINNER_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




















/*************************************************************************************
 *  단위 업무 명 : 2012 벼룩시장 파인드올 포인트 소진 프로모션 이벤트 
 *  작   성   자 : 이 경 덕 (laplance@mediawill.com)
 *  작   성   일 : 2012-09-12
 *  설        명 : 당첨자 등록
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  EXEC         : EXEC DBO.PUT_F_PT_EVENT_REDUCE_WINNER_TB_INSERT_PROC
==============================================================================*/
CREATE                      PROC [dbo].[PUT_F_PT_EVENT_REDUCE_WINNER_TB_INSERT_PROC]
  @USERID        VARCHAR(50)            -- USERID
AS
BEGIN
	SET NOCOUNT ON

  DECLARE @REGSUMCNT INT                -- 신청총합
  DECLARE @LASTIDX   INT                -- 마지막 번호

  SET @REGSUMCNT = 0
  SET @LASTIDX = 0

  -- 등록
  INSERT INTO PT_EVENT_REDUCE_WINNER_TB (USER_ID) VALUES (@USERID)

  SELECT @REGSUMCNT = COUNT(IDX) FROM PT_EVENT_REDUCE_WINNER_TB (NOLOCK) WHERE CONVERT(VARCHAR(10),REG_DT,121) = CONVERT(VARCHAR(10),GETDATE(),121)   -- 총합

  SELECT TOP 1 @LASTIDX = IDX FROM PT_EVENT_REDUCE_WINNER_TB (NOLOCK) WHERE CONVERT(VARCHAR(10),REG_DT,121) = CONVERT(VARCHAR(10),GETDATE(),121) ORDER BY IDX DESC -- 마지막 번호
  
  -- 당첨 번호 확인
  IF @REGSUMCNT IN (0)
  BEGIN
    -- 당첨
    UPDATE PT_EVENT_REDUCE_WINNER_TB 
	   SET WIN_YN = 'Y'
     WHERE IDX = @LASTIDX
   
    RETURN 2
  END ELSE BEGIN
    RETURN 1
  END

	IF @@ERROR <> 0
	BEGIN
		RETURN (-1)
	END
END
























GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PT_EVENT2_WINNER_TB_INCERT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*************************************************************************************
 *  단위 업무 명 : CF 이벤트2 당첨자 등록
 *  작   성   자 : 정태운
 *  작   성   일 : 2011-06-01
 *  설        명 : 당첨자 등록
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  EXEC         : EXEC DBO.PUT_F_PT_EVENT2_WINNER_TB_INCERT_PROC
==============================================================================*/
CREATE             PROC [dbo].[PUT_F_PT_EVENT2_WINNER_TB_INCERT_PROC]
  @USERID        VARCHAR(50)            -- USERID
AS
BEGIN
	SET NOCOUNT ON

  DECLARE @REGSUMCNT INT                -- 신청총합
  DECLARE @LASTIDX   INT                -- 마지막 번호

  SET @REGSUMCNT = 0
  SET @LASTIDX = 0

  -- 등록
  INSERT INTO PT_EVENT2_WINNER_TB (USER_ID)
  VALUES (@USERID)

  SELECT @REGSUMCNT = COUNT(IDX) FROM PT_EVENT2_WINNER_TB (NOLOCK) WHERE CONVERT(VARCHAR(10),REG_DT,121) = CONVERT(VARCHAR(10),GETDATE(),121)   -- 총합

  SELECT TOP 1 @LASTIDX = IDX FROM PT_EVENT2_WINNER_TB (NOLOCK) WHERE CONVERT(VARCHAR(10),REG_DT,121) = CONVERT(VARCHAR(10),GETDATE(),121) ORDER BY IDX DESC -- 마지막 번호
  
  -- 당첨 번호 확인
  IF CONVERT(VARCHAR(10),GETDATE(),121) = '2011-06-28'
  BEGIN
    IF @REGSUMCNT IN (208, 211, 224, 238, 245, 256, 262, 278, 285, 299, 336, 348, 357, 361, 370, 381, 400, 526, 555)
    BEGIN
      -- 당첨
      UPDATE PT_EVENT2_WINNER_TB SET
        WIN_YN = 'Y'
      WHERE IDX = @LASTIDX
         
      RETURN 2
    END ELSE BEGIN
      RETURN 1
    END
  END
  ELSE IF CONVERT(VARCHAR(10),GETDATE(),121) = '2011-06-29'
  BEGIN
    IF @REGSUMCNT IN (201, 212, 224, 236, 248, 255, 267, 279, 281, 299, 336, 347, 358, 362, 381, 402, 431, 457, 475, 490)
    BEGIN
      -- 당첨
      UPDATE PT_EVENT2_WINNER_TB SET
        WIN_YN = 'Y'
      WHERE IDX = @LASTIDX
         
      RETURN 2
    END ELSE BEGIN
      RETURN 1
    END
  END

	IF @@ERROR <> 0
	BEGIN
		RETURN (-1)
	END
END








GO
/****** Object:  StoredProcedure [dbo].[PUT_M_PT_EVENT_REDUCE_WINNER_NEWYEAR_TB_DEL_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/********************************************************************************
 *  단위 업무 명 : 2013 벼룩시장 파인드올 포인트 소진 프로모션 이벤트 
 *  작   성   자 : 이 경 덕 (laplance@mediawill.com)
 *  작   성   일 : 2013-01-04
 *  설        명 : 당첨자 적용 해제
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  EXEC         : EXEC DBO.PUT_M_PT_EVENT_REDUCE_WINNER_NEWYEAR_TB_DEL_PROC 'laplance'
********************************************************************************/

CREATE	PROC [dbo].[PUT_M_PT_EVENT_REDUCE_WINNER_NEWYEAR_TB_DEL_PROC]
      @USERID	VARCHAR(50)
	 ,@EVENTSEQ INT 
AS
BEGIN 
	SET NOCOUNT ON

DECLARE @CNT INT

SELECT @CNT=COUNT(*) FROM DBO.PT_EVENT_REDUCE_WINNER_NEWYEAR_TB WITH (NOLOCK)
WHERE USER_ID = @USERID AND EVENT_SEQ = @EVENTSEQ

 -- 당첨자 삭제
	IF @CNT > 0
	
	BEGIN
		DELETE FROM  DBO.PT_EVENT_REDUCE_WINNER_NEWYEAR_TB
		WHERE USER_ID= @USERID AND EVENT_SEQ = @EVENTSEQ
	END 

END


GO
/****** Object:  StoredProcedure [dbo].[PUT_M_PT_EVENT_REDUCE_WINNER_NEWYEAR_TB_INSERT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/********************************************************************************
 *  단위 업무 명 : 2013 벼룩시장 파인드올 포인트 소진 프로모션 이벤트 
 *  작   성   자 : 이 경 덕 (laplance@mediawill.com)
 *  작   성   일 : 2013-01-04
 *  설        명 : 당첨자 적용
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  EXEC         : EXEC DBO.PUT_M_PT_EVENT_REDUCE_WINNER_NEWYEAR_TB_INSERT_PROC 'laplance', 'B'
********************************************************************************/

CREATE	PROC [dbo].[PUT_M_PT_EVENT_REDUCE_WINNER_NEWYEAR_TB_INSERT_PROC]
      @USERID	VARCHAR(50)
	 ,@WINTYPE	VARCHAR(10)	
	 ,@EVENTSEQ INT
AS
BEGIN 
	SET NOCOUNT ON

DECLARE @CNT INT

SELECT @CNT=COUNT(*) FROM DBO.PT_EVENT_REDUCE_WINNER_NEWYEAR_TB WITH (NOLOCK)
WHERE USER_ID = @USERID AND EVENT_SEQ = @EVENTSEQ

 -- 기존 등록된 사항은 삭제
IF @CNT > 0
BEGIN
	DELETE FROM PT_EVENT_REDUCE_WINNER_NEWYEAR_TB
	WHERE USER_ID= @USERID AND EVENT_SEQ = @EVENTSEQ
END 
  --당첨자 등록

INSERT INTO DBO.PT_EVENT_REDUCE_WINNER_NEWYEAR_TB (USER_ID, WIN_TYPE, EVENT_SEQ) VALUES (@USERID, @WINTYPE, @EVENTSEQ)

END


GO
/****** Object:  StoredProcedure [dbo].[PUT_PT_ADMIN_MYPOINT_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트현황조회 > 포인트 신규 적립/차감
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-21
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.PUT_PT_ADMIN_MYPOINT_PROC 'A002', 'A', 'KKK', 'COMMENT', 50, 'rocker44'

 *************************************************************************************/

CREATE       PROC [dbo].[PUT_PT_ADMIN_MYPOINT_PROC]
  @I_POINT_SEC VARCHAR(50)
, @I_POINT_GB CHAR(1)
, @I_POINT_USED_CONT VARCHAR(200)
, @I_POINT_COMMENT VARCHAR(400)
, @I_POINT_SAVE INT
, @USERID VARCHAR(50)
AS

BEGIN

INSERT INTO DBO.PT_STATUS_TB
(
   USERID
 , ITEM_SEQ
 , POINT_SEC
 , POINT_SAVE_DT
 , POINT_SAVE_GB
 , POINT_CONT
 , POINT_EXPIRE_DT
 , MY_SAVE_POINT
 , MY_USED_POINT
 , MY_BALANCE_POINT
 , POINT_COMM
)
SELECT @USERID
     , 0
     , @I_POINT_SEC
     , CONVERT(VARCHAR(10), GETDATE(), 120)
     , @I_POINT_GB
     , @I_POINT_USED_CONT
     --, CASE WHEN @I_POINT_GB = 'A' THEN CONVERT(VARCHAR(10), DATEADD(YEAR, 2, GETDATE()), 120) ELSE '' END
     , CASE WHEN @I_POINT_GB = 'A' THEN CONVERT(VARCHAR(8), DATEADD(MONTH, 1, DATEADD(YEAR, 1, GETDATE())), 120)+'01'  ELSE '' END
     , (CASE WHEN @I_POINT_GB = 'A' THEN @I_POINT_SAVE ELSE 0 END) MY_SAVE_POINT
     , (CASE WHEN @I_POINT_GB = 'B' THEN @I_POINT_SAVE ELSE 0 END) MY_USED_POINT
     , (CASE WHEN @I_POINT_GB = 'A' THEN A.MY_BALANCE_POINT+@I_POINT_SAVE ELSE A.MY_BALANCE_POINT-@I_POINT_SAVE END) MY_BALANCE_POINT
     , @I_POINT_COMMENT
FROM
(
  SELECT TOP 1 POINT_SEQ
       , MY_SAVE_POINT
       , MY_USED_POINT
       , MY_BALANCE_POINT
  FROM dbo.PT_STATUS_TB
  WHERE USERID = @USERID
  ORDER BY POINT_SEQ DESC
) A


END
GO
/****** Object:  StoredProcedure [dbo].[PUT_PT_ITEM_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트항목관리 > 포인트항목관리 저장
 *  작   성   자 : 김 민 석
 *  작   성   일 : 2011-01-19
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *  EXEC : DBO.PUT_PT_ITEM_LIST_PROC

 *************************************************************************************/

CREATE  PROC [dbo].[PUT_PT_ITEM_LIST_PROC]
  @I_POINT_SEC VARCHAR(50)
, @I_POINT_GB CHAR(1)
, @I_POINT_USED_CONT VARCHAR(400)
, @I_POINT_SAVE VARCHAR(50)
, @I_POINT_SAVE_STAND VARCHAR(100)
, @I_POINT_SAVE_GB CHAR(1)
, @I_DATEPICKER1 VARCHAR(10)
, @I_DATEPICKER2 VARCHAR(10)
, @I_POINT_SAVE_ING_GB CHAR(1)
, @USERID VARCHAR(50)	--@USERID VARCHAR(80)
AS

BEGIN

  INSERT INTO DBO.PT_ITEM_TB
  (
     POINT_SEC
   , POINT_GB
   , POINT_SAVE_ING_GB
   , POINT_USED_CONT
   , POINT_SAVE
   , POINT_SAVE_STAND
   , POINT_SAVE_GB
   , POINT_TERM_SDT
   , POINT_TERM_EDT
   , REG_DTE
   , REG_USERID
  )
  VALUES
  (
    @I_POINT_SEC
  , @I_POINT_GB
  , @I_POINT_SAVE_ING_GB
  , @I_POINT_USED_CONT
  , @I_POINT_SAVE
  , @I_POINT_SAVE_STAND
  , @I_POINT_SAVE_GB
  , @I_DATEPICKER1
  , @I_DATEPICKER2
  , GETDATE()
  , @USERID
  )

END




GO
