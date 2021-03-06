USE [HOMEPY]
GO
/****** Object:  StoredProcedure [dbo].[CUID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
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

	UPDATE A SET CUID=@MASTER_CUID FROM HP_BUSINESS_TB A  where CUID=@SLAVE_CUID

/*
	INSERT PAPER_NEW.DBO.CUID_CHANGE_HISTORY_TB (B_CUID, N_CUID, USERID, DB_NAME, USERIP)
		SELECT @MASTER_CUID , @SLAVE_CUID,@MASTER_USERID,DB_NAME(),@CLIENT_IP
*/		
END







GO
/****** Object:  StoredProcedure [dbo].[EDIT_HP_BUSINESS_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 업소정보 수정 (프론트/관리자 공통)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_HP_BUSINESS_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_HP_BUSINESS_PROC]

  @IDX                INT
  ,@USERID            VARCHAR(50) = ''
  ,@USERNAME          VARCHAR(30)
  ,@HOMEPY_ID         VARCHAR(11)
  ,@HOMEPY_PHONE      VARCHAR(13)
  ,@BIZ_NUMBER        VARCHAR(12)
  ,@ETC_ID_NUMBER     VARCHAR(100)=''
  ,@BIZ_PHONE         VARCHAR(13)
  ,@BIZ_ADD_PHONE     VARCHAR(70) = ''
  ,@BIZ_EMAIL         VARCHAR(50)
  ,@BIZ_NAME          VARCHAR(50)
  ,@BIZ_CODE          INT
  ,@BIZ_ZIPCODE       VARCHAR(7)
  ,@BIZ_ADDRESS       VARCHAR(123)
  ,@BIZ_ADDRESS_DET   VARCHAR(50)
  ,@BIZ_POS_DESC      VARCHAR(200)
  ,@BIZ_HOMEPAGE      VARCHAR(100)
  ,@BIZ_OPENTIME      VARCHAR(10)
  ,@BIZ_ONELINE_DESC  VARCHAR(200)
  ,@BIZ_CONTENTS      NVARCHAR(2000)
  ,@FT_COMPANY        VARCHAR(30) = NULL
  ,@FT_PRESIDENT      VARCHAR(30) = NULL
  ,@FT_INFO           VARCHAR(200) = NULL
  ,@MAP_X             INT  = 0
  ,@MAP_Y             INT  = 0
  ,@PHOTO_1           VARCHAR(200) = ''
  ,@PHOTO_2           VARCHAR(200) = ''
  ,@PHOTO_3           VARCHAR(200) = ''
  ,@PHOTO_4           VARCHAR(200) = ''
  ,@PHOTO_5           VARCHAR(200) = ''
  ,@PHOTO_6           VARCHAR(200) = ''
  ,@PHOTO_7           VARCHAR(200) = ''
  ,@QRCODE_IMG        VARCHAR(200) = ''
  ,@CUID			  INT = 0

AS

  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_MOD_FIELD NVARCHAR(2000)
  SET @SQL = ''
  SET @SQL_MOD_FIELD = ''

  -- 이미지 등록
  IF @PHOTO_1 <> ''
    SET @SQL_MOD_FIELD = @SQL_MOD_FIELD +',PHOTO_1 = '''+ @PHOTO_1 +''''
  IF @PHOTO_2 <> ''
    SET @SQL_MOD_FIELD = @SQL_MOD_FIELD +',PHOTO_2 = '''+ @PHOTO_2 +''''
  IF @PHOTO_3 <> ''
    SET @SQL_MOD_FIELD = @SQL_MOD_FIELD +',PHOTO_3 = '''+ @PHOTO_3 +''''
  IF @PHOTO_4 <> ''
    SET @SQL_MOD_FIELD = @SQL_MOD_FIELD +',PHOTO_4 = '''+ @PHOTO_4 +''''
  IF @PHOTO_5 <> ''
    SET @SQL_MOD_FIELD = @SQL_MOD_FIELD +',PHOTO_5 = '''+ @PHOTO_5 +''''
  IF @PHOTO_6 <> ''
    SET @SQL_MOD_FIELD = @SQL_MOD_FIELD +',PHOTO_6 = '''+ @PHOTO_6 +''''
  IF @PHOTO_7 <> ''
    SET @SQL_MOD_FIELD = @SQL_MOD_FIELD +',PHOTO_7 = '''+ @PHOTO_7 +''''
  IF @QRCODE_IMG <> ''
    SET @SQL_MOD_FIELD = @SQL_MOD_FIELD +',QRCODE_IMG = '''+ REPLACE(@QRCODE_IMG,'|','') +''''

  -- UPDATE
  SET @SQL = 'UPDATE HP_BUSINESS_TB
                 SET USERID            = '''+ @USERID +'''
                    ,USERNAME          = '''+ @USERNAME +'''
                    ,HOMEPY_ID         = '''+ @HOMEPY_ID +'''
                    ,HOMEPY_PHONE      = '''+ @HOMEPY_PHONE +'''
                    ,BIZ_NUMBER        = '''+ @BIZ_NUMBER +'''
                    ,ETC_ID_NUMBER     = '''+ @ETC_ID_NUMBER +'''
                    ,BIZ_PHONE         = '''+ @BIZ_PHONE +'''
                    ,BIZ_ADD_PHONE     = '''+ @BIZ_ADD_PHONE +'''
                    ,BIZ_EMAIL         = '''+ @BIZ_EMAIL +'''
                    ,BIZ_NAME          = '''+ @BIZ_NAME +'''
                    ,BIZ_CODE          = '+ CAST(@BIZ_CODE AS VARCHAR(6)) +'
                    ,BIZ_ZIPCODE       = '''+ @BIZ_ZIPCODE +'''
                    ,BIZ_ADDRESS       = '''+ @BIZ_ADDRESS +'''
                    ,BIZ_ADDRESS_DET   = '''+ @BIZ_ADDRESS_DET +'''
                    ,BIZ_POS_DESC      = '''+ @BIZ_POS_DESC +'''
                    ,BIZ_HOMEPAGE      = '''+ @BIZ_HOMEPAGE +'''
                    ,BIZ_OPENTIME      = '''+ @BIZ_OPENTIME +'''
                    ,BIZ_ONELINE_DESC  = '''+ @BIZ_ONELINE_DESC +'''
                    ,BIZ_CONTENTS      = '''+ @BIZ_CONTENTS +'''
                    ,FT_COMPANY        = '''+ @FT_COMPANY +'''
                    ,FT_PRESIDENT      = '''+ @FT_PRESIDENT +'''
                    ,FT_INFO           = '''+ @FT_INFO +'''
                    ,MAP_X             = '+ CAST(@MAP_X AS VARCHAR(7)) +'
                    ,MAP_Y             = '+ CAST(@MAP_Y AS VARCHAR(7)) +'
                    '+ @SQL_MOD_FIELD +'
                    ,MOD_DT = GETDATE()
                    ,CUID = '+cast(@CUID as varchar(100))+'
               WHERE IDX = '+ CAST(@IDX AS VARCHAR(10))

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL



GO
/****** Object:  StoredProcedure [dbo].[EDIT_HP_PHOTO_DELETE_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 홈피에 등록된 추가사진 정보 삭제
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_HP_PHOTO_DELETE_PROC 1, 2
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_HP_PHOTO_DELETE_PROC]

  @IDX INT
  ,@IMG_SEQ TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_FIELD VARCHAR(500)


  SET @SQL = ''

  -- 파일순번에 따른 필드명
  IF @IMG_SEQ = 8
    BEGIN
      SET @SQL_FIELD = 'QRCODE_IMG'
    END
  ELSE
    BEGIN
      SET @SQL_FIELD = 'PHOTO_'+ CAST(@IMG_SEQ AS CHAR(1))
    END

  SET @SQL = 'UPDATE HP_BUSINESS_TB
                 SET '+ @SQL_FIELD +' = ''''
               WHERE IDX = '+ CAST(@IDX AS VARCHAR(12))

--PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL








GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_BUSINESS_STATUS_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 업소정보 인기홈피/삭제/재등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_BUSINESS_STATUS_PROC 'R', 1
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_BUSINESS_STATUS_PROC]

  @FLAG  CHAR(1)
  ,@IDX  INT

AS

  DECLARE @STATUS BIT

  SET NOCOUNT ON

  -- @FLAG값이 인기홈피설정/해제 라면...
  IF @FLAG = 'I' OR  @FLAG = 'N'
    BEGIN

      -- 처리항목 (D: 삭제, R:재등록)
      IF @FLAG = 'I'
        SET @STATUS = 1
      ELSE IF @FLAG = 'N'
        SET @STATUS = 0

      -- 처리
      UPDATE HP_BUSINESS_TB
         SET INTEREST_YN = @STATUS
       WHERE IDX = @IDX

    END
  ELSE  -- @FLAG값 삭제/재등록 이라면...
    BEGIN

      -- 처리항목 (D: 삭제, R:재등록)
      IF @FLAG = 'D'
        SET @STATUS = 1
      ELSE IF @FLAG = 'R'
        SET @STATUS = 0

      -- 처리
      UPDATE HP_BUSINESS_TB
         SET MOD_DT = GETDATE()
            ,DEL_YN = @STATUS
       WHERE IDX = @IDX

    END








GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_EDU_STATUS_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[EDIT_M_EDU_STATUS_PROC]
       @EDU_ID     INT
     , @MAG_ID     VARCHAR(30)
AS

SET NOCOUNT ON

UPDATE MT_PAYMENT_TB
   SET LIST_END_DT = DATEADD(DAY, -1, CONVERT(VARCHAR(10),GETDATE(),111))+' 23:59:59'
 WHERE SECTION='A01'
   AND ADID=@EDU_ID



UPDATE MT_EDU_TB
   SET MOD_DT  = GETDATE()
     , COMMENT = ISNULL(COMMENT,'')+CHAR(13)+CHAR(10)+CONVERT(VARCHAR(30),GETDATE(), 120)+' '+ CAST(@MAG_ID AS VARCHAR)+' 광고 마감 처리'
 WHERE EDU_ID = @EDU_ID







GO
/****** Object:  StoredProcedure [dbo].[GET_F_BUSINESS_IDX_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 대표전화를 통해 IDX 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 EXEC GET_F_BUSINESS_IDX_PROC '032-439-2002'
 exec GET_F_BUSINESS_IDX_PROC '032-439-2002'
 drop proc GET_F_BUSINESS_IDX_PROC
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_BUSINESS_IDX_PROC]

  @HOMEPY_PHONE VARCHAR(13)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT IDX
    FROM HP_BUSINESS_TB
   WHERE HOMEPY_PHONE = @HOMEPY_PHONE
     AND DEL_YN = 0
  UNION ALL
  SELECT IDX
    FROM HP_BUSINESS_TB
   WHERE HOMEPY_ID = @HOMEPY_PHONE
     AND DEL_YN = 0




GO
/****** Object:  StoredProcedure [dbo].[GET_F_EDU_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GET_F_EDU_DETAIL_PROC]
       @EDU_ID   INT
AS

SET NOCOUNT ON

SELECT
       E.EDU_ID
     , E.EDU_IMG1   --이미지
     , E.EDU_TYPE   --교육형태
     , E.EDU_TITLE  --과정제목
     , CAST(MONTH(E.EDU_ACCEPT_DT) AS VARCHAR)+'/'+CAST(DAY(E.EDU_ACCEPT_DT) AS VARCHAR)  AS LIST_END_DT --접수마감일
     , E.EDU_CLS       --교육분야
     , DBO.FN_GET_EDU_OBJECT_TYPE_NAME(E.EDU_OBJECT_TYPE) AS EDU_OBJECT_TYPE   --교육대상
     , E.EDU_OBJECT    --교육대상
     , E.EDU_TOTAL_PRICE    --총교육비용
     , E.EDU_NAT_PRICE      --국비지원
     , E.EDU_PRI_PRICE      --자기부담금
     , E.EDU_FREE_YN        --무료여부
     , E.EDU_METHOD         --교육방법
     , E.EDU_TIME           --교육시간
     , E.EDU_CAPACITY       --정원
     , REPLACE(CONVERT(VARCHAR(10), E.EDU_ST_DT, 111),'/','.') AS EDU_ST_DT          --교육기간
     , REPLACE(CONVERT(VARCHAR(10), E.EDU_END_DT, 111),'/','.') AS EDU_END_DT         --교육기간
     , E.EDU_PHONE1         --연락처1
     , E.EDU_PHONE2         --연락처2
     , E.AREA_A             --시/군
     , E.AREA_B             --구
     , E.AREA_C             --동
     , E.MAP_X              --지도 좌표
     , E.MAP_Y              --지도 좌표
     , E.EDU_HOMEPAGE       --홈페이지
     , E.EDU_NAME           --교육기관명
     , E.BIZ_EMAIL          --이메일
     , REPLACE(CONVERT(VARCHAR(10), E.EDU_ACCEPT_DT, 111),'/','.') AS EDU_ACCEPT_DT --접수마감일
     , E.EDU_TRAINING_PAY   --훈련수당
     , E.EDU_RECEIVE_METHOD --접수방법
     , E.EDU_FINISH_COURSE  --수업후 진로
     , E.EDU_CONTENTS       --상세 내용
     , E.AREA_DETAIL        --주소 상세
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID = P.ADID AND P.SECTION='A01'
 WHERE P.LIST_ST_DT < GETDATE() AND P.LIST_END_DT > GETDATE()   --게제중
   AND E.EDU_ID = @EDU_ID




GO
/****** Object:  StoredProcedure [dbo].[GET_F_EDU_LIST_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*메인 페이지 리스트*/

CREATE PROC [dbo].[GET_F_EDU_LIST_PROC]
       @PAGE        INT = 1
     , @PAGESIZE    INT = 15
     , @EDU_CLS     VARCHAR(3) = ''
     , @AREA_A      VARCHAR(30) = ''
     , @AREA_B      VARCHAR(30) = ''
     , @EDU_TYPE    VARCHAR(30) = ''
     , @KEYWORD     VARCHAR(30) = ''
     , @ORDER       VARCHAR(30) = 'P.LIST_ST_DT'
AS

SET NOCOUNT ON

DECLARE @SQL       NVARCHAR(4000)
DECLARE @COUNTSQL  NVARCHAR(4000)
DECLARE @WHERESQL  NVARCHAR(4000)
DECLARE @ORDERSQL  NVARCHAR(4000)

DECLARE @WHERECLS   VARCHAR(1000)
DECLARE @SELECTCLS  VARCHAR(1000)

SET @SQL = ''
SET @COUNTSQL = ''
SET @WHERESQL = ''
SET @ORDERSQL = ''

--검색
IF @EDU_CLS<>''
	SET @WHERESQL = @WHERESQL+' AND PATINDEX(''%'+@EDU_CLS+'%'', E.EDU_CLS) > 0'

IF @AREA_A <> ''
	SET @WHERESQL = @WHERESQL+' AND E.AREA_A = '''+@AREA_A+''' '

IF @AREA_B <> ''
	SET @WHERESQL = @WHERESQL+' AND E.AREA_B = '''+@AREA_B+''' '

IF @EDU_TYPE<>''
BEGIN
    SET @SELECTCLS=''
    SET @WHERECLS=' AND ( '

    WHILE PATINDEX('%,%',@EDU_TYPE)>0
    BEGIN
    	SET @SELECTCLS=SUBSTRING(@EDU_TYPE,0,PATINDEX('%,%', @EDU_TYPE))
        SET @WHERECLS = @WHERECLS + ' E.EDU_TYPE&'+@SELECTCLS+'='+@SELECTCLS+' OR'

    	SET @EDU_TYPE=SUBSTRING(@EDU_TYPE,PATINDEX('%,%',@EDU_TYPE)+1,LEN(@EDU_TYPE))
    END

    IF @EDU_TYPE<>''
        SET @WHERECLS = @WHERECLS + ' E.EDU_TYPE&'+@EDU_TYPE+'='+@EDU_TYPE+' OR'

    SET @WHERECLS=LEFT(@WHERECLS, LEN(@WHERECLS)-2)
    SET @WHERECLS=@WHERECLS +') '

    SET @WHERESQL = @WHERESQL + @WHERECLS
END

IF @KEYWORD<>''
BEGIN
	SET @WHERESQL = @WHERESQL+' AND  ( E.EDU_TITLE LIKE ''%'+@KEYWORD+'%''
                  OR DBO.FN_GET_EDU_OBJECT_TYPE_NAME(E.EDU_OBJECT_TYPE) LIKE ''%'+@KEYWORD+'%''
                  OR E.EDU_OBJECT LIKE ''%'+@KEYWORD+'%''
                  OR E.EDU_TIME LIKE ''%'+@KEYWORD+'%''
                  OR E.EDU_FINISH_COURSE LIKE ''%'+@KEYWORD+'%''
                  OR E.EDU_CONTENTS LIKE ''%'+@KEYWORD+'%''
                  OR E.EDU_PHONE1 LIKE ''%'+@KEYWORD+'%''
                  OR E.EDU_PHONE2 LIKE ''%'+@KEYWORD+'%''
                  OR E.EDU_TRAINING_PAY LIKE ''%'+@KEYWORD+'%''
                  OR E.EDU_NAME LIKE ''%'+@KEYWORD+'%''
                  ) '
END


--정렬
SET @ORDERSQL = @ORDERSQL +' ORDER BY '+@ORDER+' DESC, E.EDU_ID DESC'



--갯수
SET @COUNTSQL ='
SELECT COUNT(*)
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID = P.ADID AND P.SECTION=''A01''
 WHERE P.LIST_ST_DT < GETDATE() AND P.LIST_END_DT > GETDATE()   --게제중
'+@WHERESQL


--리스트
SET @SQL='
SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
       E.EDU_ID
     , E.EDU_IMG1   --이미지
     , E.EDU_TYPE   --교육형태
     , E.EDU_TITLE  --과정제목
     , MONTH(E.EDU_ACCEPT_DT)  AS LIST_END_MONTH --접수마감일
     , E.EDU_CLS       --교육분야
     , DBO.FN_GET_EDU_OBJECT_TYPE_NAME(E.EDU_OBJECT_TYPE) AS EDU_OBJECT_TYPE   --교육대상
     , E.EDU_OBJECT    --교육대상
     , E.EDU_TOTAL_PRICE    --총교육비용
     , E.EDU_NAT_PRICE      --국비지원
     , E.EDU_PRI_PRICE      --자기부담금
     , E.EDU_FREE_YN        --무료여부
     , E.EDU_METHOD         --교육방법
     , E.EDU_TIME           --교육시간
     , E.EDU_CAPACITY       --정원
     , REPLACE(CONVERT(VARCHAR(10), E.EDU_ST_DT, 111),''/'',''.'') AS EDU_ST_DT          --교육기간
     , REPLACE(CONVERT(VARCHAR(10), E.EDU_END_DT, 111),''/'',''.'') AS EDU_END_DT         --교육기간
     , E.EDU_PHONE1         --연락처1
     , E.EDU_PHONE2         --연락처2
     , E.AREA_A             --시/군
     , E.AREA_B             --구
     , E.AREA_C             --동
     , E.MAP_X              --지도 좌표
     , E.MAP_Y              --지도 좌표
     , E.EDU_HOMEPAGE       --홈페이지
     , E.EDU_NAME           --교육기관명
     , DAY(E.EDU_ACCEPT_DT)  AS LIST_END_DAY --접수마감일
     , E.AREA_DETAIL        --주소 상세
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID = P.ADID AND P.SECTION=''A01''
 WHERE P.LIST_ST_DT < GETDATE() AND P.LIST_END_DT > GETDATE()   --게제중
'+@WHERESQL+@ORDERSQL


--PRINT @COUNTSQL
--PRINT @SQL

EXEC SP_EXECUTESQL @COUNTSQL
EXEC SP_EXECUTESQL @SQL



GO
/****** Object:  StoredProcedure [dbo].[GET_F_EDU_PREMIUM_LIST_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[GET_F_EDU_PREMIUM_LIST_PROC]
AS

SET NOCOUNT ON

SELECT
       E.EDU_ID
     , E.EDU_NAME
     , E.EDU_IMG1
     , E.EDU_TITLE
     , E.AREA_A
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID = P.ADID AND P.SECTION = 'A01'
 WHERE P.LIST_ST_DT < GETDATE() AND P.LIST_END_DT > GETDATE()   --게제중
   AND P.PRODUCT = 1 ---프리미엄
 ORDER BY P.LIST_ST_DT DESC






GO
/****** Object:  StoredProcedure [dbo].[GET_F_HOMEPY_COUNTER_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 홈피 카운터
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_HOMEPY_COUNTER_PROC 1
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_HOMEPY_COUNTER_PROC]

  @HOMEPY_IDX  INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 오늘자 카운터
  SELECT TODAY_COUNT
    FROM HP_COUNTER_TB
   WHERE HOMEPY_IDX = @HOMEPY_IDX
     AND COUNT_DT = CONVERT(VARCHAR(10),GETDATE(),120);

  -- 총 카운터
  SELECT SUM(TODAY_COUNT) AS TOT_CNT
    FROM HP_COUNTER_TB
   WHERE HOMEPY_IDX = @HOMEPY_IDX








GO
/****** Object:  StoredProcedure [dbo].[GET_F_HOMEPY_PAPER_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 업소 홈피> 업소별 홈피 광고 내역
 *  작   성   자 : 최병찬
 *  작   성   일 : 2011-03-15
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 신문 광고 리스트
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  EXEC : DBO.GET_F_HOMEPY_PAPER_AD_LIST_PROC 5, 10, 22

 *************************************************************************************/

CREATE PROC [dbo].[GET_F_HOMEPY_PAPER_AD_LIST_PROC]
      @PAGE				INT
    , @PAGESIZE         SMALLINT
    , @IDX              INT
AS
SET NOCOUNT ON

DECLARE @STRSQL	NVARCHAR(4000)

SET @STRSQL=''

IF @PAGE = 1 -- 맨 처음페이지일때
BEGIN
  SET ROWCOUNT	@PAGESIZE

  SELECT
         C.LINEADID
       , C.INPUT_BRANCH
       , C.LAYOUT_BRANCH
       , C.GROUP_CD
       , CASE C.GROUP_CD WHEN 10 THEN LEFT(C.FIELD_2,20)
                         WHEN 12 THEN LEFT(C.FIELD_1,20)
                         WHEN 13 THEN LEFT(C.FIELD_2,20)
                         WHEN 14 THEN LEFT(C.FIELD_2,20)
         END AS ADNAME
       , C.PHONE
       , ISNULL(C.CONTENTS, C.TITLE) AS CONTENTS
       , C.LAYOUTCODENAME
       , C.FINDCODE
       , C.LAYOUTCODE
    FROM HP_BUSINESS_TB AS A WITH (NOLOCK)
    JOIN FINDDB1.MWDB.dbo.MW_CUSTOMER_AUTH_TB AS B ON B.USERID = A.USERID
    JOIN FINDDB1.PAPER_NEW.dbo.PP_LINE_AD_TB AS C ON C.INPUTCUST = B.INPUTCUST AND C.IDENTYFLAG = 1
   WHERE A.IDX = @IDX
   ORDER BY C.START_DT DESC, C.LINEADID DESC

END
ELSE
BEGIN
		SET @STRSQL= @STRSQL+'
		DECLARE	@PREVCOUNT  INT
		DECLARE	@START_DT   DATETIME
        DECLARE @LINEADID   INT

		SET	@PREVCOUNT	=	('+CAST(@PAGE AS VARCHAR(4))+' - 1)	*	'+CAST(@PAGESIZE AS VARCHAR(3))+'
		SET	ROWCOUNT @PREVCOUNT

		SELECT @START_DT = C.START_DT,
               @LINEADID = C.LINEADID
          FROM HP_BUSINESS_TB AS A WITH (NOLOCK)
          JOIN FINDDB1.MWDB.dbo.MW_CUSTOMER_AUTH_TB AS B ON B.USERID = A.USERID
          JOIN FINDDB1.PAPER_NEW.dbo.PP_LINE_AD_TB AS C ON C.INPUTCUST = B.INPUTCUST AND C.IDENTYFLAG = 1
         WHERE A.IDX = '+CAST(@IDX AS VARCHAR)+'
         ORDER BY C.START_DT DESC, C.LINEADID DESC

		SET	ROWCOUNT '+CAST(@PAGESIZE AS VARCHAR(3))+'

        SELECT
               C.LINEADID
             , C.INPUT_BRANCH
             , C.LAYOUT_BRANCH
             , C.GROUP_CD
             , CASE C.GROUP_CD WHEN 10 THEN LEFT(C.FIELD_2,20)
                               WHEN 12 THEN LEFT(C.FIELD_1,20)
                               WHEN 13 THEN LEFT(C.FIELD_2,20)
                               WHEN 14 THEN LEFT(C.FIELD_2,20)
               END AS ADNAME
             , C.PHONE
             , ISNULL(C.CONTENTS, C.TITLE) AS CONTENTS
             , C.LAYOUTCODENAME
             , C.FINDCODE
             , C.LAYOUTCODE
          FROM HP_BUSINESS_TB AS A WITH (NOLOCK)
          JOIN FINDDB1.MWDB.dbo.MW_CUSTOMER_AUTH_TB AS B ON B.USERID = A.USERID
          JOIN FINDDB1.PAPER_NEW.dbo.PP_LINE_AD_TB AS C ON C.INPUTCUST = B.INPUTCUST AND C.IDENTYFLAG = 1
         WHERE A.IDX = '+CAST(@IDX AS VARCHAR)+'
           AND C.START_DT <=  @START_DT AND C.LINEADID < @LINEADID
         ORDER BY C.START_DT DESC, C.LINEADID DESC'

    PRINT @STRSQL
    EXECUTE SP_EXECUTESQL @STRSQL

END



GO
/****** Object:  StoredProcedure [dbo].[GET_F_HOMEPY_REG_CONFIRM_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 업소홈피 메인 공지사항
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_HOMEPY_REG_CONFIRM_PROC 'cbk08'
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_HOMEPY_REG_CONFIRM_PROC]

  @USERID VARCHAR(50)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT IDX
    FROM dbo.HP_BUSINESS_TB
   WHERE USERID = @USERID







GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAIN_INTEREST_HOMEPY_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : 업소홈피메인 - 인기업소홈피
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_MAIN_INTEREST_HOMEPY_PROC
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_MAIN_INTEREST_HOMEPY_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT TOP 15
         A.IDX
        ,A.HOMEPY_PHONE
        ,A.BIZ_NAME
        ,B.CLASSNAME_B
        ,A.BIZ_ONELINE_DESC
        ,A.BIZ_ADDRESS
        ,A.BIZ_ADDRESS_DET
        ,A.BIZ_PHONE
        ,A.PHOTO_1
        ,A.QRCODE_IMG
        ,A.BIZ_CODE
    FROM HP_BUSINESS_TB AS A
    JOIN CC_INDUSTRY_CLASS_TB AS B
      ON B.CLASSCODE_B = A.BIZ_CODE
   WHERE A.DEL_YN = 0
     AND A.INTEREST_YN = 1
   ORDER BY REG_DT DESC







GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAIN_NEW_HOMEPY_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 업소홈피메인 - 신규업소홈피
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_MAIN_NEW_HOMEPY_PROC
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_MAIN_NEW_HOMEPY_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT TOP 10
         A.IDX
        ,A.HOMEPY_PHONE
        ,A.BIZ_NAME
        ,B.CLASSNAME_B
        ,A.BIZ_ONELINE_DESC
        ,A.BIZ_ADDRESS
        ,A.BIZ_ADDRESS_DET
        ,A.BIZ_PHONE
        ,A.PHOTO_1
        ,A.QRCODE_IMG
        ,A.BIZ_CODE
    FROM HP_BUSINESS_TB AS A
    JOIN CC_INDUSTRY_CLASS_TB AS B
      ON B.CLASSCODE_B = A.BIZ_CODE
   WHERE A.DEL_YN = 0
   ORDER BY REG_DT DESC








GO
/****** Object:  StoredProcedure [dbo].[GET_F_PAPER_AD_CNT_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 홈피주가 낸 신문 광고 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_PAPER_AD_CNT_PROC 22
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_PAPER_AD_CNT_PROC]

  @IDX  INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT COUNT(*)
    FROM HP_BUSINESS_TB AS A
    JOIN FINDDB1.MWDB.dbo.MW_CUSTOMER_AUTH_TB AS B
      ON B.USERID = A.USERID
    JOIN FINDDB1.PAPER_NEW.dbo.PP_LINE_AD_TB AS C
      ON C.INPUTCUST = B.INPUTCUST
     AND C.IDENTYFLAG = 1
   WHERE A.IDX = @IDX






GO
/****** Object:  StoredProcedure [dbo].[GET_F_PAPER_AD_LIST_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 홈피주가 낸 신문 광고 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_PAPER_AD_LIST_PROC 1
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_PAPER_AD_LIST_PROC]

  @IDX  INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT TOP 5
         C.LINEADID
        ,C.INPUT_BRANCH
        ,C.LAYOUT_BRANCH
        ,C.GROUP_CD
        ,CASE C.GROUP_CD WHEN 10 THEN C.FIELD_2
                         WHEN 12 THEN C.FIELD_1
                         WHEN 13 THEN C.FIELD_2
                         WHEN 14 THEN C.FIELD_2
          END AS ADNAME
        ,C.PHONE
        ,ISNULL(C.CONTENTS, C.TITLE) AS CONTENTS
        ,C.LAYOUTCODENAME
        ,C.FINDCODE
        ,C.LAYOUTCODE
    FROM HP_BUSINESS_TB AS A
    JOIN FINDDB1.MWDB.dbo.MW_CUSTOMER_AUTH_TB AS B
      ON B.USERID = A.USERID
    JOIN FINDDB1.PAPER_NEW.dbo.PP_LINE_AD_TB AS C
      ON C.INPUTCUST = B.INPUTCUST
     AND C.IDENTYFLAG = 1
   WHERE A.IDX = @IDX
   ORDER BY C.START_DT DESC










GO
/****** Object:  StoredProcedure [dbo].[GET_F_USER_AD_COUNTER_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 회원이 낸 광고 개수 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_USER_AD_COUNTER_PROC 'cbk08'
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_USER_AD_COUNTER_PROC]

  @USERID  VARCHAR(50)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @HOUSE_CNT INT
  DECLARE @PAPER_CNT INT

  -- 부동산 광고 개수
  /*
  SELECT @HOUSE_CNT = COUNT(*)
    FROM FINDDB11.HOUSE.dbo.CM_GOOD_TB
   WHERE USER_ID = @USERID
     AND GOOD_STATE_CD='L';
  */
  SET @HOUSE_CNT = 0

  -- 신문 줄광고 개수
  SELECT @PAPER_CNT = COUNT(*)
    FROM FINDDB1.PAPER_NEW.dbo.PP_LINE_AD_TB AS A
    JOIN FINDDB1.MWDB.dbo.MW_CUSTOMER_AUTH_TB AS B
      ON A.INPUTCUST = B.INPUTCUST
   WHERE B.USERID = @USERID

  -- 최종: 부동산, 줄광고 개수
  SELECT @HOUSE_CNT AS HOUSE_CNT
        ,@PAPER_CNT AS PAPER_CNT





GO
/****** Object:  StoredProcedure [dbo].[GET_HOUSE_HP_BUSINESS_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GET_HOUSE_HP_BUSINESS_PROC]
       @USERID     VARCHAR(50)
AS

SET NOCOUNT ON

SELECT TOP 1 USERID, HOMEPY_PHONE
  FROM HP_BUSINESS_TB WITH (NOLOCK)
 WHERE USERID=@USERID
   AND DEL_YN=0
 ORDER BY IDX DESC





GO
/****** Object:  StoredProcedure [dbo].[GET_HP_BUSINESS_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 업소정보 상세보기 (프론트/관리자 공통)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_HP_BUSINESS_DETAIL_PROC
 *************************************************************************************/

CREATE PROC [dbo].[GET_HP_BUSINESS_DETAIL_PROC]

  @IDX INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.USERID
        ,A.USERNAME
        ,A.HOMEPY_ID
        ,A.HOMEPY_PHONE
        ,A.BIZ_NUMBER
        ,A.ETC_ID_NUMBER
        ,A.BIZ_PHONE
        ,A.BIZ_ADD_PHONE
        ,A.BIZ_EMAIL
        ,A.BIZ_NAME
        ,A.BIZ_CODE
        ,A.BIZ_ZIPCODE
        ,A.BIZ_ADDRESS
        ,A.BIZ_ADDRESS_DET
        ,A.BIZ_POS_DESC
        ,A.BIZ_HOMEPAGE
        ,A.BIZ_OPENTIME
        ,A.BIZ_ONELINE_DESC
        ,A.BIZ_CONTENTS
        ,A.MAP_X
        ,A.MAP_Y
        ,A.PHOTO_1
        ,A.PHOTO_2
        ,A.PHOTO_3
        ,A.PHOTO_4
        ,A.PHOTO_5
        ,A.PHOTO_6
        ,A.PHOTO_7
        ,A.QRCODE_IMG
        ,A.REG_PATH
        ,ISNULL(A.REG_MAGBRANCH,0) AS REG_MAGBRANCH
        ,B.CLASSNAME_A
        ,B.CLASSNAME_B
        ,A.DEL_YN
        ,A.FT_COMPANY
        ,A.FT_PRESIDENT
        ,A.FT_INFO
        ,ISNULL(A.CUID,0) as CUID 
    FROM HP_BUSINESS_TB AS A
    JOIN CC_INDUSTRY_CLASS_TB AS B
      ON B.CLASSCODE_B = A.BIZ_CODE
   WHERE IDX = @IDX


GO
/****** Object:  StoredProcedure [dbo].[GET_HP_BUSINESS_IDX_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 업소정보 IDX값 추출
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/11/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_HP_BUSINESS_IDX_PROC
 *************************************************************************************/

CREATE PROC [dbo].[GET_HP_BUSINESS_IDX_PROC]


AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT ISNULL(MAX(IDX),0) + 1 AS MAX_IDX
    FROM HP_BUSINESS_TB







GO
/****** Object:  StoredProcedure [dbo].[GET_HP_INDUSTRY_CLASS_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 업종분류 가져오기 (프론트/관리자 공통)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/11/29
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_HP_INDUSTRY_CLASS_PROC 10, 1
 *************************************************************************************/

CREATE PROC [dbo].[GET_HP_INDUSTRY_CLASS_PROC]

  @CLASSCODE  INT
  ,@LEVEL     INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  IF @LEVEL = 1
    BEGIN

      SELECT CLASSCODE_A AS CLASSCODE
            ,CLASSNAME_A AS CLASSNAME
        FROM CC_INDUSTRY_CLASS_TB
       WHERE USEYN = 1
       GROUP BY CLASSCODE_A, CLASSNAME_A
      ORDER BY CLASSCODE_A ASC

    END
  ELSE
    BEGIN

      SELECT CLASSCODE_B AS CLASSCODE
            ,CLASSNAME_B AS CLASSNAME
        FROM CC_INDUSTRY_CLASS_TB
       WHERE USEYN = 1
         AND CLASSCODE_A = @CLASSCODE
      ORDER BY CLASSCODE_B ASC

    END






GO
/****** Object:  StoredProcedure [dbo].[GET_HP_PHOTO_INFO_ALL_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 등록된 이미지정보 추출 (프론트/관리자 공통)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_HP_PHOTO_INFO_ALL_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_HP_PHOTO_INFO_ALL_PROC]

  @IDX INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT PHOTO_1
        ,PHOTO_2
        ,PHOTO_3
        ,PHOTO_4
        ,PHOTO_5
        ,PHOTO_6
        ,PHOTO_7
        ,QRCODE_IMG
    FROM HP_BUSINESS_TB
   WHERE IDX = @IDX









GO
/****** Object:  StoredProcedure [dbo].[GET_HP_PHOTO_INFO_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 홈피에 등록된 추가사진 정보 추출
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/08/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_HP_PHOTO_INFO_PROC 1, 2
 *************************************************************************************/


CREATE PROC [dbo].[GET_HP_PHOTO_INFO_PROC]

  @IDX INT
  ,@IMG_SEQ TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(1000)
  DECLARE @SQL_FIELD VARCHAR(50)


  SET @SQL = ''

  -- 파일순번에 따른 필드명
  IF @IMG_SEQ = 8
    BEGIN
      SET @SQL_FIELD = 'QRCODE_IMG'
    END
  ELSE
    BEGIN
      SET @SQL_FIELD = 'PHOTO_'+ CAST(@IMG_SEQ AS CHAR(1))
    END

  SET @SQL = 'SELECT '+ @SQL_FIELD +' AS PHOTO
                FROM HP_BUSINESS_TB
               WHERE IDX = '+ CAST(@IDX AS VARCHAR(12))

  EXECUTE SP_EXECUTESQL @SQL







GO
/****** Object:  StoredProcedure [dbo].[GET_M_BUSINESS_LIST_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 업소관리 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/11/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_BUSINESS_LIST_PROC
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_BUSINESS_LIST_PROC]

  @PAGE                INT
  ,@PAGESIZE           INT

  ,@SCH_DATE_KIND      VARCHAR(10)
  ,@SCH_START_DT       VARCHAR(10)
  ,@SCH_END_DT         VARCHAR(10)

  ,@SCH_BIZ_CLASS_A    VARCHAR(2)
  ,@SCH_BIZ_CLASS_B    VARCHAR(6)

  ,@SCH_REG_PATH       CHAR(1)

  ,@SCH_STATUS         CHAR(1)

  ,@SCH_KEYWORD_KIND   VARCHAR(20)
  ,@SCH_KEYWORD        VARCHAR(50)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(1000)
  DECLARE @SQL_WHERE NVARCHAR(2000)

  SET @SQL = ''
  SET @SQL_COUNT = ''
  SET @SQL_WHERE = ''

  -- 검색조건: 날짜
  IF @SCH_START_DT <> '' AND @SCH_END_DT <> ''
    BEGIN
      SET @SQL_WHERE = ' AND CONVERT(VARCHAR(10),A.'+ @SCH_DATE_KIND +',120) BETWEEN '''+ @SCH_START_DT +''' AND '''+ @SCH_END_DT +'''
                       '
    END

  -- 검색조건: 업종
  IF @SCH_BIZ_CLASS_A <> '' OR @SCH_BIZ_CLASS_B <> ''
    BEGIN
      IF @SCH_BIZ_CLASS_A <> '' AND @SCH_BIZ_CLASS_B = ''
        SET @SQL_WHERE = @SQL_WHERE + ' AND B.CLASSCODE_A = '+ @SCH_BIZ_CLASS_A
      ELSE
        SET @SQL_WHERE = @SQL_WHERE + ' AND B.CLASSCODE_B = '+ @SCH_BIZ_CLASS_B
    END

  -- 검색조건: 등록경로
  IF @SCH_REG_PATH <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND A.REG_PATH = '''+ @SCH_REG_PATH +''''
    END

  -- 검색조건: 게재
  IF @SCH_STATUS <> ''
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND A.DEL_YN = '+ @SCH_STATUS +''
    END

  -- 검색조건: 키워드
  IF @SCH_KEYWORD <> ''
    BEGIN
    IF @SCH_KEYWORD='HOMEPY_PHONE'
      SET @SQL_WHERE = @SQL_WHERE + ' AND ( A.HOMEPY_PHONE='+ @SCH_KEYWORD +' OR A.BIZ_PHONE='+ @SCH_KEYWORD +' OR A.BIZ_ADD_PHONE LIKE ''%'+ @SCH_KEYWORD +'%'' ) '
    ELSE
      SET @SQL_WHERE = @SQL_WHERE + ' AND A.'+ @SCH_KEYWORD_KIND +' LIKE ''%'+ @SCH_KEYWORD +'%'''
    END

  --// 쿼리
  SET @SQL_COUNT = 'SELECT COUNT(*)
                      FROM HP_BUSINESS_TB AS A
                      JOIN CC_INDUSTRY_CLASS_TB AS B
                        ON B.CLASSCODE_B = A.BIZ_CODE
                     WHERE 1 = 1 '+ @SQL_WHERE

  SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
                    A.IDX
                    ,A.USERID
                    ,B.CLASSNAME_A +''>''+ B.CLASSNAME_B AS CLASSNAME
                    ,A.BIZ_NAME
                    ,A.HOMEPY_PHONE
                    ,A.BIZ_NUMBER
                    ,CONVERT(VARCHAR(10), A.REG_DT, 11) AS REG_DT
                    ,A.REG_PATH
                    ,A.DEL_YN
                    ,A.INTEREST_YN
                    ,A.QRCODE_IMG
                FROM HP_BUSINESS_TB AS A
                JOIN CC_INDUSTRY_CLASS_TB AS B
                  ON B.CLASSCODE_B = A.BIZ_CODE
               WHERE 1 = 1 '+ @SQL_WHERE +'
               ORDER BY IDX DESC'

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL



GO
/****** Object:  StoredProcedure [dbo].[GET_M_HOMPY_AND_MEMBER_CONFIRM_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 홈피, 회원 등록 여부(카운터)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/11/29
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_HOMPY_AND_MEMBER_CONFIRM_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_HOMPY_AND_MEMBER_CONFIRM_PROC]

  @USERID  VARCHAR(50)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 업소홈피 등록여부
  SELECT COUNT(*) AS HOMEPY_CNT
    FROM dbo.HP_BUSINESS_TB
   WHERE USERID = @USERID;

  -- 회원가입 여부
  SELECT COUNT(*) AS MEMBER_CNT, MAX(CUID) as CUID
    FROM MEMBERDB.MWMEMBER.dbo.CST_MASTER
   WHERE USERID = @USERID





GO
/****** Object:  StoredProcedure [dbo].[GET_M_HOMPY_CONFIRM_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 홈피 등록 여부(카운터)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/11/29
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_HOMPY_CONFIRM_PROC '01012345678'
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_HOMPY_CONFIRM_PROC]

  @HOMEPY_ID  VARCHAR(13)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 업소홈피 등록여부
  SELECT COUNT(*) AS HOMEPY_CNT
    FROM dbo.HP_BUSINESS_TB
   WHERE REPLACE(HOMEPY_ID,'-','') = REPLACE(@HOMEPY_ID,'-','')



GO
/****** Object:  StoredProcedure [dbo].[GET_M_MT_EDU_LIST_EXCEL_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*관리자 페이지 학원정보넷 검색 EXCEL 리스트*/
CREATE PROC [dbo].[GET_M_MT_EDU_LIST_EXCEL_PROC]
      @SCH_DATE_KIND   VARCHAR(10)=''
     , @SCH_START_DT    VARCHAR(10)=''
     , @SCH_END_DT      VARCHAR(10)=''

     , @SCH_PRODUCT     INT
     , @SCH_STATUS      CHAR(1)
     , @SCH_BRANCH      TINYINT

     , @SCH_KEYWORD_KIND VARCHAR(20)
     , @SCH_KEYWORD      VARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @SQL        NVARCHAR(4000)
DECLARE @WHERESQL   NVARCHAR(4000)

SET @SQL = ''
SET @WHERESQL = ''

-- 검색조건: 날짜
IF @SCH_START_DT <> '' AND @SCH_END_DT <> ''
BEGIN
  SET @WHERESQL = @WHERESQL +' AND CONVERT(VARCHAR(10),'+ @SCH_DATE_KIND +',120) BETWEEN '''+ @SCH_START_DT +''' AND '''+ @SCH_END_DT +'''  '
END

-- 상품
IF @SCH_PRODUCT<>'' AND @SCH_PRODUCT<>'0'
BEGIN
  SET @WHERESQL = @WHERESQL +' AND P.PRODUCT = '+CAST(@SCH_PRODUCT AS VARCHAR)+' '
END

-- 게제 상태
IF @SCH_STATUS<>''
BEGIN
  IF @SCH_STATUS='S'  --게재대기
  	SET @WHERESQL = @WHERESQL +' AND CONVERT(VARCHAR(10), P.LIST_ST_DT, 120) > CONVERT(VARCHAR(10), GETDATE(), 120) '
  ELSE IF @SCH_STATUS='L'  --게재중
  	SET @WHERESQL = @WHERESQL +' AND CONVERT(VARCHAR(10), P.LIST_ST_DT, 120) <= CONVERT(VARCHAR(10), GETDATE(), 120) AND CONVERT(VARCHAR(10), P.LIST_END_DT, 120) >= CONVERT(VARCHAR(10), GETDATE(), 120) '
  ELSE IF @SCH_STATUS='E'  --제재 완료
  	SET @WHERESQL = @WHERESQL +' AND CONVERT(VARCHAR(10), P.LIST_END_DT, 120) < CONVERT(VARCHAR(10), GETDATE(), 120) '
END

-- 등록 지점
IF @SCH_BRANCH<>'' AND @SCH_BRANCH<>'0'
BEGIN
  SET @WHERESQL = @WHERESQL +' AND E.BRANCH_CD = '+CAST(@SCH_BRANCH AS VARCHAR) +' '
END

IF @SCH_KEYWORD_KIND<>'' AND @SCH_KEYWORD<>''
BEGIN
  IF @SCH_KEYWORD_KIND='TEL'
    SET @WHERESQL = @WHERESQL + ' AND (E. BIZ_PHONE LIKE ''%'+@SCH_KEYWORD+'%'' OR E. EDU_PHONE1 LIKE ''%'+@SCH_KEYWORD+'%'' OR E. EDU_PHONE2 LIKE ''%'+@SCH_KEYWORD+'%'' ) '
  ELSE IF @SCH_KEYWORD_KIND='E.EDU_ID'
    SET @WHERESQL = @WHERESQL + ' AND '+@SCH_KEYWORD_KIND+' = '+@SCH_KEYWORD+' '
  ELSE IF @SCH_KEYWORD_KIND='E.EDU_NAME' OR @SCH_KEYWORD_KIND='E.MAG_NM'
    SET @WHERESQL = @WHERESQL + ' AND '+@SCH_KEYWORD_KIND+' LIKE ''%'+@SCH_KEYWORD+'%'' '
END

SET @SQL='
SELECT
       E.EDU_ID
     , CONVERT(VARCHAR(10),E.REG_DT, 111) AS REG_DT
     , E.EDU_NAME
     , E.EDU_PHONE1
     , DBO.FN_GET_PRODUCT_NAME(P.PRODUCT) AS PRODUCT
     , CONVERT(VARCHAR(10),P.LIST_ST_DT, 11) AS LIST_ST_DT
     , CONVERT(VARCHAR(10),P.LIST_END_DT, 11) AS LIST_END_DT
     , DBO.FN_GET_PAY_TYPE_NAME(P.PAY_TYPE) AS PAY_TYPE
     , P.INET_PRICE
     , P.PAPER_PRICE
     , CASE
            WHEN CONVERT(VARCHAR(10), P.LIST_ST_DT, 120) > CONVERT(VARCHAR(10), GETDATE(), 120) THEN ''게재대기''
            WHEN CONVERT(VARCHAR(10), P.LIST_ST_DT, 120) <= CONVERT(VARCHAR(10), GETDATE(), 120) AND CONVERT(VARCHAR(10), P.LIST_END_DT, 120) >= CONVERT(VARCHAR(10), GETDATE(), 120) THEN ''게재중''
            WHEN CONVERT(VARCHAR(10), P.LIST_END_DT, 120) < CONVERT(VARCHAR(10), GETDATE(), 120) THEN ''게재완료''
       END AS STATUS
     , DBO.FN_GET_REG_TYPE_NAME(E.REG_TYPE) AS REG_TYPE
     , E.BRANCH_CD
     , E.MAG_NM
     , C.CNT
     , E.EDU_CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION=''A01''
  JOIN MT_EDU_CNT_TB AS C WITH (NOLOCK) ON E.EDU_ID=C.EDU_ID
 WHERE 1=1 '+@WHERESQL+'
 ORDER BY E.EDU_ID DESC'

PRINT @SQL


EXEC SP_EXECUTESQL @SQL







GO
/****** Object:  StoredProcedure [dbo].[GET_M_MT_EDU_LIST_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*관리자 페이지 학원정보넷 검색*/

CREATE PROC [dbo].[GET_M_MT_EDU_LIST_PROC]
       @PAGE            INT
     , @PAGESIZE        INT
     , @SCH_DATE_KIND   VARCHAR(10)=''
     , @SCH_START_DT    VARCHAR(10)=''
     , @SCH_END_DT      VARCHAR(10)=''

     , @SCH_PRODUCT     INT
     , @SCH_STATUS      CHAR(1)
     , @SCH_BRANCH     TINYINT

     , @SCH_KEYWORD_KIND VARCHAR(20)
     , @SCH_KEYWORD      VARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @SQL        NVARCHAR(4000)
DECLARE @CNTSQL     NVARCHAR(4000)
DECLARE @WHERESQL   NVARCHAR(4000)

SET @SQL = ''
SET @CNTSQL = ''
SET @WHERESQL = ''

-- 검색조건: 날짜
IF @SCH_START_DT <> '' AND @SCH_END_DT <> ''
BEGIN
  SET @WHERESQL = @WHERESQL +' AND CONVERT(VARCHAR(10),'+ @SCH_DATE_KIND +',120) BETWEEN '''+ @SCH_START_DT +''' AND '''+ @SCH_END_DT +'''  '
END

-- 상품
IF @SCH_PRODUCT<>'' AND @SCH_PRODUCT<>'0'
BEGIN
  SET @WHERESQL = @WHERESQL +' AND P.PRODUCT = '+CAST(@SCH_PRODUCT AS VARCHAR)+' '
END

-- 게제 상태
IF @SCH_STATUS<>''
BEGIN
  IF @SCH_STATUS='S'  --게재대기
  	SET @WHERESQL = @WHERESQL +' AND CONVERT(VARCHAR(10), P.LIST_ST_DT, 120) > CONVERT(VARCHAR(10), GETDATE(), 120) '
  ELSE IF @SCH_STATUS='L'  --게재중
  	SET @WHERESQL = @WHERESQL +' AND CONVERT(VARCHAR(10), P.LIST_ST_DT, 120) <= CONVERT(VARCHAR(10), GETDATE(), 120) AND CONVERT(VARCHAR(10), P.LIST_END_DT, 120) >= CONVERT(VARCHAR(10), GETDATE(), 120) '
  ELSE IF @SCH_STATUS='E'  --제재 완료
  	SET @WHERESQL = @WHERESQL +' AND CONVERT(VARCHAR(10), P.LIST_END_DT, 120) < CONVERT(VARCHAR(10), GETDATE(), 120) '
END

-- 등록 지점
IF @SCH_BRANCH<>'' AND @SCH_BRANCH<>'0'
BEGIN
  SET @WHERESQL = @WHERESQL +' AND E.BRANCH_CD = '+CAST(@SCH_BRANCH AS VARCHAR)+' '
END

IF @SCH_KEYWORD_KIND<>'' AND @SCH_KEYWORD<>''
BEGIN
  IF @SCH_KEYWORD_KIND='TEL'
    SET @WHERESQL = @WHERESQL + ' AND (E. BIZ_PHONE LIKE ''%'+@SCH_KEYWORD+'%'' OR E. EDU_PHONE1 LIKE ''%'+@SCH_KEYWORD+'%'' OR E. EDU_PHONE2 LIKE ''%'+@SCH_KEYWORD+'%'' ) '
  ELSE IF @SCH_KEYWORD_KIND='E.EDU_ID'
    SET @WHERESQL = @WHERESQL + ' AND '+@SCH_KEYWORD_KIND+' = '+@SCH_KEYWORD+' '
  ELSE IF @SCH_KEYWORD_KIND='E.EDU_NAME' OR @SCH_KEYWORD_KIND='E.MAG_NM'
    SET @WHERESQL = @WHERESQL + ' AND '+@SCH_KEYWORD_KIND+' LIKE ''%'+@SCH_KEYWORD+'%'' '
END


SET @CNTSQL =
'SELECT COUNT(*)
   FROM MT_EDU_TB AS E WITH (NOLOCK)
   JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION=''A01''
   JOIN MT_EDU_CNT_TB AS C WITH (NOLOCK) ON E.EDU_ID=C.EDU_ID
  WHERE 1=1 '+@WHERESQL


SET @SQL='
SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
       E.EDU_ID
     , CONVERT(VARCHAR(10),E.REG_DT, 111) AS REG_DT
     , E.EDU_NAME
     , E.EDU_PHONE1
     , DBO.FN_GET_PRODUCT_NAME(P.PRODUCT) AS PRODUCT
     , CONVERT(VARCHAR(10),P.LIST_ST_DT, 11) AS LIST_ST_DT
     , CONVERT(VARCHAR(10),P.LIST_END_DT, 11) AS LIST_END_DT
     , P.INET_PRICE
     , P.PAPER_PRICE
     , CASE
            WHEN CONVERT(VARCHAR(10), P.LIST_ST_DT, 120) > CONVERT(VARCHAR(10), GETDATE(), 120) THEN ''게재대기''
            WHEN CONVERT(VARCHAR(10), P.LIST_ST_DT, 120) <= CONVERT(VARCHAR(10), GETDATE(), 120) AND CONVERT(VARCHAR(10), P.LIST_END_DT, 120) >= CONVERT(VARCHAR(10), GETDATE(), 120) THEN ''게재중''
            WHEN CONVERT(VARCHAR(10), P.LIST_END_DT, 120) < CONVERT(VARCHAR(10), GETDATE(), 120) THEN ''게재완료''
       END AS STATUS
     , E.REG_TYPE
     , E.BRANCH_CD
     , C.CNT
     , E.MAG_NM
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION=''A01''
  JOIN MT_EDU_CNT_TB AS C WITH (NOLOCK) ON E.EDU_ID=C.EDU_ID
 WHERE 1=1 '+@WHERESQL+'
 ORDER BY E.EDU_ID DESC'

--PRINT @CNTSQL
--PRINT @SQL

EXEC SP_EXECUTESQL @CNTSQL
EXEC SP_EXECUTESQL @SQL







GO
/****** Object:  StoredProcedure [dbo].[GET_MT_BUSINESS_INFO_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*업소홈피 검색 선택시 학원정보넷 폼에 기존 데이터 채우기*/

CREATE PROC [dbo].[GET_MT_BUSINESS_INFO_PROC]
      @IDX  INT
AS

SET NOCOUNT ON

SELECT
       USERNAME            --관리자명
     , BIZ_NUMBER          --사업자등록번호
     , ETC_ID_NUMBER       --기타 제증명
     , BIZ_PHONE           --연락처
     , BIZ_EMAIL           --이메일
     , BIZ_NAME            --업소명
     , HOMEPY_PHONE        --대표전화번호
     , BIZ_ADDRESS+' '+BIZ_ADDRESS_DET AS ADDRESS    --주소
     , BIZ_HOMEPAGE
     , LEFT(PHOTO_1,PATINDEX('%|%',PHOTO_1)-1) AS IMG
     , BIZ_ONELINE_DESC
     , BIZ_CONTENTS
  FROM HP_BUSINESS_TB WITH (NOLOCK)
 WHERE IDX=@IDX
   AND DEL_YN=0




GO
/****** Object:  StoredProcedure [dbo].[GET_MT_EDU_INFO_LOAD_LIST_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*기존 업소 홈피나 학원정보넷 불러오기 리스트*/

CREATE PROC [dbo].[GET_MT_EDU_INFO_LOAD_LIST_PROC]
       @CONDITION  VARCHAR(10)
     , @KEYWORD    VARCHAR(50)
     , @ARG        CHAR(1)    --E:학원정보넷, B:업소홈피
     , @PAGE       INT
     , @PAGESIZE   TINYINT
AS

SET NOCOUNT ON

DECLARE @SQL        NVARCHAR(4000)
DECLARE @SQLCOUNT   NVARCHAR(4000)
DECLARE @WHERESQL   NVARCHAR(4000)

SET @WHERESQL=''

IF @CONDITION='ADID'
BEGIN
    IF @ARG='E'
    	SET @WHERESQL=' EDU_ID='+@KEYWORD
    ELSE
    	SET @WHERESQL=' IDX='+@KEYWORD
END
ELSE IF @CONDITION='PHONE'
BEGIN
    SET @KEYWORD=REPLACE(REPLACE(@KEYWORD,'-',''),')','')
    IF @ARG='E'
    	SET @WHERESQL=' REPLACE(REPLACE(BIZ_PHONE,''-'',''''),'')'','''') LIKE ''%'+@KEYWORD+'%'' OR REPLACE(REPLACE(EDU_PHONE1,''-'',''''),'')'','''') LIKE ''%'+@KEYWORD+'%'' OR REPLACE(REPLACE(EDU_PHONE2,''-'',''''),'')'','''') LIKE ''%'+@KEYWORD+'%'' '
    ELSE
    	SET @WHERESQL=' REPLACE(REPLACE(HOMEPY_PHONE,''-'',''''),'')'','''') LIKE ''%'+@KEYWORD+'%'' OR REPLACE(REPLACE(BIZ_PHONE,''-'',''''),'')'','''') LIKE ''%'+@KEYWORD+'%'' OR REPLACE(REPLACE(BIZ_ADD_PHONE,''-'',''''),'')'','''') LIKE ''%'+@KEYWORD+'%'' '
END
ELSE IF @CONDITION='BIZNAME'
BEGIN
    IF @ARG='E'
    	SET @WHERESQL=' EDU_NAME LIKE ''%'+@KEYWORD+'%'' '
    ELSE
    	SET @WHERESQL=' BIZ_NAME LIKE ''%'+@KEYWORD+'%'' '

END

IF @ARG='E'    --학원정보넷
BEGIN
    SET @SQLCOUNT='
    SELECT COUNT(*)
      FROM MT_EDU_TB WITH (NOLOCK)
     WHERE '+@WHERESQL


    SET @SQL='
    SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
           EDU_ID
         , EDU_NAME
         , EDU_PHONE1
         , EDU_TITLE
         , ''E''
      FROM MT_EDU_TB WITH (NOLOCK)
     WHERE '+@WHERESQL+'
     ORDER BY EDU_ID DESC'

END
ELSE    --업소홈피(B)
BEGIN
    SET @SQLCOUNT='
    SELECT COUNT(*)
      FROM HP_BUSINESS_TB WITH (NOLOCK)
     WHERE '+@WHERESQL+'
       AND DEL_YN=0
       AND LEFT(BIZ_CODE,2)=''14'''   --교육서비스업


    SET @SQL='
    SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
           IDX
         , BIZ_NAME
         , BIZ_PHONE
         , BIZ_ONELINE_DESC
         , ''B''
      FROM HP_BUSINESS_TB WITH (NOLOCK)
     WHERE '+@WHERESQL+'
       AND DEL_YN=0
       AND LEFT(BIZ_CODE,2)=''14''   --교육서비스업
     ORDER BY IDX DESC'

END

PRINT @SQLCOUNT
PRINT @SQL

EXEC (@SQLCOUNT)
EXEC (@SQL)




GO
/****** Object:  StoredProcedure [dbo].[GET_MT_EDU_INFO_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*학원정보넷 검색 선택시 학원정보넷 폼에 기존 데이터 채우기*/

CREATE PROC [dbo].[GET_MT_EDU_INFO_PROC]
      @EDU_ID  INT
AS

SET NOCOUNT ON

SELECT
       USERNAME
     , BIZ_NUMBER
     , ETC_ID_NUMBER
     , BIZ_PHONE
     , BIZ_EMAIL
     , EDU_NAME
     , EDU_PHONE1
     , EDU_PHONE2
     , AREA_A
     , AREA_B
     , AREA_C
     , AREA_DETAIL
     , MAP_X
     , MAP_Y
     , EDU_HOMEPAGE
     , EDU_IMG1
     , EDU_CLS
     , EDU_TITLE
     , EDU_TYPE
     , EDU_OBJECT_TYPE
     , EDU_OBJECT
     , EDU_ACCEPT_DT
     , EDU_ST_DT
     , EDU_END_DT
     , EDU_METHOD
     , EDU_TIME
     , EDU_CAPACITY
     , EDU_TOTAL_PRICE
     , EDU_NAT_PRICE
     , EDU_PRI_PRICE
     , EDU_FREE_YN
     , EDU_TRAINING_PAY
     , EDU_RECEIVE_METHOD
     , EDU_FINISH_COURSE
     , EDU_CONTENTS
  FROM MT_EDU_TB WITH (NOLOCK)
 WHERE EDU_ID=@EDU_ID




GO
/****** Object:  StoredProcedure [dbo].[GET_MT_EDU_PAYMENT_INFO_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*학원 정보넷 수정폼 데이타 불러오기*/

CREATE PROC [dbo].[GET_MT_EDU_PAYMENT_INFO_PROC]
      @EDU_ID  INT
AS

SET NOCOUNT ON

SELECT
       E.EDU_ID
     , E.USERNAME
     , E.BIZ_NUMBER
     , E.ETC_ID_NUMBER
     , E.BIZ_PHONE
     , E.BIZ_EMAIL
     , E.EDU_NAME
     , E.EDU_PHONE1
     , E.EDU_PHONE2
     , E.AREA_A
     , E.AREA_B
     , E.AREA_C
     , E.AREA_DETAIL
     , E.MAP_X
     , E.MAP_Y
     , E.EDU_HOMEPAGE
     , E.EDU_IMG1
     , E.EDU_CLS
     , E.EDU_TITLE
     , E.EDU_TYPE
     , E.EDU_OBJECT_TYPE
     , E.EDU_OBJECT
     , E.EDU_ACCEPT_DT
     , E.EDU_ST_DT
     , E.EDU_END_DT
     , E.EDU_METHOD
     , E.EDU_TIME
     , E.EDU_CAPACITY
     , E.EDU_TOTAL_PRICE
     , E.EDU_NAT_PRICE
     , E.EDU_PRI_PRICE
     , E.EDU_FREE_YN
     , E.EDU_TRAINING_PAY
     , E.EDU_RECEIVE_METHOD
     , E.EDU_FINISH_COURSE
     , E.EDU_CONTENTS

     , E.MAG_ID
     , E.BRANCH_CD
     , E.MAG_NM
     , E.REG_TYPE
     , E.COMMENT

     , P.PRODUCT
     , P.LIST_ST_DT
     , REPLACE(CONVERT(VARCHAR(10),P.LIST_END_DT,111),'/','-') AS LIST_END_DT
     , P.PAY_TYPE
     , P.INET_PRICE
     , P.PAPER_PRICE
     , P.LINEADID

  FROM MT_EDU_TB AS E WITH (NOLOCK)
  LEFT JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE E.EDU_ID=@EDU_ID




GO
/****** Object:  StoredProcedure [dbo].[META_EDU_MAIN_CLS_MAKE_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[META_EDU_MAIN_CLS_MAKE_PROC]
AS

SET NOCOUNT ON

SELECT COUNT(*) AS COU, 'A01' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A01%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A02' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A02%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A03' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A03%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A04' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A04%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A05' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A05%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A06' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A06%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A07' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A07%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A08' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A08%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A09' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A09%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A10' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A10%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A11' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A11%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A12' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A12%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A13' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A13%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A14' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A14%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A15' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A15%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()

SELECT COUNT(*) AS COU, 'A16' AS CLS
  FROM MT_EDU_TB AS E WITH (NOLOCK)
  JOIN MT_PAYMENT_TB AS P WITH (NOLOCK) ON E.EDU_ID=P.ADID AND P.SECTION='A01'
 WHERE PATINDEX('%A16%',E.EDU_CLS)>0
   AND P.LIST_ST_DT<GETDATE() AND P.LIST_END_DT>GETDATE()







GO
/****** Object:  StoredProcedure [dbo].[PUT_EDU_CNT_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[PUT_EDU_CNT_PROC]
       @EDU_ID     INT
AS

SET NOCOUNT ON

DECLARE @ROWCOUNT INT

UPDATE MT_EDU_CNT_TB
   SET CNT=CNT+1
 WHERE EDU_ID = @EDU_ID

SELECT @ROWCOUNT = @@ROWCOUNT

IF @ROWCOUNT=0
INSERT MT_EDU_CNT_TB
     ( EDU_ID, CNT )
VALUES
     ( @EDU_ID, 1)








GO
/****** Object:  StoredProcedure [dbo].[PUT_F_HOMEPY_COUNTER_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 홈피 카운터 누적
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/12/06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_F_HOMEPY_COUNTER_PROC 1
 *************************************************************************************/

CREATE PROC [dbo].[PUT_F_HOMEPY_COUNTER_PROC]

  @HOMEPY_IDX  INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @CNT INT

  SELECT @CNT = COUNT(*)
    FROM HP_COUNTER_TB
   WHERE HOMEPY_IDX = @HOMEPY_IDX
     AND COUNT_DT = CONVERT(VARCHAR(10),GETDATE(),120)

  -- 오늘자 카운터가 생성되어있지 않다면 INSERT
  IF @CNT = 0
    BEGIN

      INSERT INTO HP_COUNTER_TB
        (HOMEPY_IDX
        ,COUNT_DT
        ,TODAY_COUNT)
      VALUES
        (@HOMEPY_IDX
        ,CONVERT(VARCHAR(10),GETDATE(),120)
        ,1)

    END
  ELSE
    BEGIN

      UPDATE HP_COUNTER_TB
         SET TODAY_COUNT = TODAY_COUNT + 1
       WHERE HOMEPY_IDX = @HOMEPY_IDX
         AND COUNT_DT = CONVERT(VARCHAR(10),GETDATE(),120)

    END







GO
/****** Object:  StoredProcedure [dbo].[PUT_HP_BUSINESS_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 업소등록 (프론트/관리자 공통)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/11/24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_HP_BUSINESS_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_HP_BUSINESS_PROC]

  @USERID             VARCHAR(50) = NULL
  ,@USERNAME          VARCHAR(30)
  ,@HOMEPY_ID         VARCHAR(11)
  ,@HOMEPY_PHONE      VARCHAR(13)
  ,@BIZ_NUMBER        VARCHAR(12)
  ,@ETC_ID_NUMBER     VARCHAR(100)
  ,@BIZ_PHONE         VARCHAR(13)
  ,@BIZ_ADD_PHONE     VARCHAR(70) = NULL
  ,@BIZ_EMAIL         VARCHAR(50)
  ,@BIZ_NAME          VARCHAR(50)
  ,@BIZ_CODE          INT
  ,@BIZ_ZIPCODE       VARCHAR(7)
  ,@BIZ_ADDRESS       VARCHAR(123)
  ,@BIZ_ADDRESS_DET   VARCHAR(50)
  ,@BIZ_POS_DESC      VARCHAR(200)
  ,@BIZ_HOMEPAGE      VARCHAR(100)
  ,@BIZ_OPENTIME      VARCHAR(10)
  ,@BIZ_ONELINE_DESC  VARCHAR(200)
  ,@BIZ_CONTENTS      NVARCHAR(2000)
  ,@FT_COMPANY        VARCHAR(30) = NULL
  ,@FT_PRESIDENT      VARCHAR(30) = NULL
  ,@FT_INFO           VARCHAR(200) = NULL
  ,@MAP_X             INT  = 0
  ,@MAP_Y             INT  = 0
  ,@PHOTO_1           VARCHAR(200) = NULL
  ,@PHOTO_2           VARCHAR(200) = NULL
  ,@PHOTO_3           VARCHAR(200) = NULL
  ,@PHOTO_4           VARCHAR(200) = NULL
  ,@PHOTO_5           VARCHAR(200) = NULL
  ,@PHOTO_6           VARCHAR(200) = NULL
  ,@PHOTO_7           VARCHAR(200) = NULL
  ,@REG_PATH          CHAR(1)
  ,@REG_MAGID         VARCHAR(30) = NULL
  ,@REG_MAGBRANCH     TINYINT = NULL
  ,@CUID			  INT

AS

  SET NOCOUNT ON

  INSERT
    INTO HP_BUSINESS_TB
        (USERID
        ,USERNAME
        ,HOMEPY_ID
        ,HOMEPY_PHONE
        ,BIZ_NUMBER
        ,ETC_ID_NUMBER
        ,BIZ_PHONE
        ,BIZ_ADD_PHONE
        ,BIZ_EMAIL
        ,BIZ_NAME
        ,BIZ_CODE
        ,BIZ_ZIPCODE
        ,BIZ_ADDRESS
        ,BIZ_ADDRESS_DET
        ,BIZ_POS_DESC
        ,BIZ_HOMEPAGE
        ,BIZ_OPENTIME
        ,BIZ_ONELINE_DESC
        ,BIZ_CONTENTS
        ,FT_COMPANY
        ,FT_PRESIDENT
        ,FT_INFO
        ,MAP_X
        ,MAP_Y
        ,PHOTO_1
        ,PHOTO_2
        ,PHOTO_3
        ,PHOTO_4
        ,PHOTO_5
        ,PHOTO_6
        ,PHOTO_7
        ,REG_PATH
        ,REG_MAGID
        ,REG_MAGBRANCH
        ,CUID)
  VALUES
        (@USERID
        ,@USERNAME
        ,@HOMEPY_ID
        ,@HOMEPY_PHONE
        ,@BIZ_NUMBER
        ,@ETC_ID_NUMBER
        ,@BIZ_PHONE
        ,@BIZ_ADD_PHONE
        ,@BIZ_EMAIL
        ,@BIZ_NAME
        ,@BIZ_CODE
        ,@BIZ_ZIPCODE
        ,@BIZ_ADDRESS
        ,@BIZ_ADDRESS_DET
        ,@BIZ_POS_DESC
        ,@BIZ_HOMEPAGE
        ,@BIZ_OPENTIME
        ,@BIZ_ONELINE_DESC
        ,@BIZ_CONTENTS
        ,@FT_COMPANY
        ,@FT_PRESIDENT
        ,@FT_INFO
        ,@MAP_X
        ,@MAP_Y
        ,@PHOTO_1
        ,@PHOTO_2
        ,@PHOTO_3
        ,@PHOTO_4
        ,@PHOTO_5
        ,@PHOTO_6
        ,@PHOTO_7
        ,@REG_PATH
        ,@REG_MAGID
        ,@REG_MAGBRANCH
        ,@CUID)



GO
/****** Object:  StoredProcedure [dbo].[PUT_M_MT_EDU_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*학원 정보넷 입력하기*/

CREATE PROC [dbo].[PUT_M_MT_EDU_PROC]
       @USERNAME          VARCHAR(30)
     , @BIZ_NUMBER        VARCHAR(12)
     , @ETC_ID_NUMBER     VARCHAR(100)
     , @BIZ_PHONE         VARCHAR(13)
     , @BIZ_EMAIL         VARCHAR(50)
     , @EDU_NAME          VARCHAR(50)
     , @EDU_PHONE1        VARCHAR(13)
     , @EDU_PHONE2        VARCHAR(13)
     , @AREA_A            VARCHAR(30)
     , @AREA_B            VARCHAR(30)
     , @AREA_C            VARCHAR(30)
     , @AREA_DETAIL       VARCHAR(60)
     , @MAP_X             INT
     , @MAP_Y             INT
     , @EDU_HOMEPAGE      VARCHAR(100)
     , @EDU_IMG1          VARCHAR(200)
     , @EDU_CLS           VARCHAR(20)
     , @EDU_TITLE         VARCHAR(200)
     , @EDU_TYPE          INT
     , @EDU_OBJECT_TYPE   CHAR(1)
     , @EDU_OBJECT        VARCHAR(100)
     , @EDU_ACCEPT_DT     VARCHAR(10)
     , @EDU_ST_DT         VARCHAR(10)
     , @EDU_END_DT        VARCHAR(10)
     , @EDU_METHOD        INT
     , @EDU_TIME          VARCHAR(100)
     , @EDU_CAPACITY      SMALLINT
     , @EDU_TOTAL_PRICE   INT
     , @EDU_NAT_PRICE     INT
     , @EDU_PRI_PRICE     INT
     , @EDU_FREE_YN       CHAR(1)
     , @EDU_TRAINING_PAY  VARCHAR(100)
     , @EDU_RECEIVE_METHOD  VARCHAR(100)
     , @EDU_FINISH_COURSE   VARCHAR(500)
     , @EDU_CONTENTS        NVARCHAR(4000)
     , @MAG_ID            VARCHAR(30)
     , @BRANCH_CD         TINYINT
     , @MAG_NM            VARCHAR(30)
     , @REG_TYPE          CHAR(1)='M'
     , @COMMENT           NVARCHAR(200)
     , @PRODUCT           INT
     , @LIST_ST_DT        VARCHAR(10)
     , @LIST_END_DT       VARCHAR(10)
     , @PAY_TYPE          CHAR(1)
     , @INET_PRICE        INT
     , @PAPER_PRICE       INT
     , @LINEADID          INT = 0
     , @EDU_ID            INT = 0      OUTPUT
AS

DECLARE @ERROR    INT
DECLARE @ROWCOUNT INT


--MT_EDU_TB
UPDATE MT_EDU_TB
   SET USERNAME = @USERNAME
     , BIZ_NUMBER = @BIZ_NUMBER
     , ETC_ID_NUMBER = @ETC_ID_NUMBER
     , BIZ_PHONE = @BIZ_PHONE
     , BIZ_EMAIL = @BIZ_EMAIL
     , EDU_NAME = @EDU_NAME
     , EDU_PHONE1 = @EDU_PHONE1
     , EDU_PHONE2 = @EDU_PHONE2
     , AREA_A = @AREA_A
     , AREA_B = @AREA_B
     , AREA_C = @AREA_C
     , AREA_DETAIL = @AREA_DETAIL
     , MAP_X = @MAP_X
     , MAP_Y = @MAP_Y
     , EDU_HOMEPAGE = @EDU_HOMEPAGE
     , EDU_IMG1 = @EDU_IMG1
     , EDU_CLS = @EDU_CLS
     , EDU_TITLE = @EDU_TITLE
     , EDU_TYPE = @EDU_TYPE
     , EDU_OBJECT_TYPE = @EDU_OBJECT_TYPE
     , EDU_OBJECT = @EDU_OBJECT
     , EDU_ACCEPT_DT = @EDU_ACCEPT_DT
     , EDU_ST_DT = @EDU_ST_DT
     , EDU_END_DT = @EDU_END_DT
     , EDU_METHOD = @EDU_METHOD
     , EDU_TIME = @EDU_TIME
     , EDU_CAPACITY = @EDU_CAPACITY
     , EDU_TOTAL_PRICE = @EDU_TOTAL_PRICE
     , EDU_NAT_PRICE = @EDU_NAT_PRICE
     , EDU_PRI_PRICE = @EDU_PRI_PRICE
     , EDU_FREE_YN = @EDU_FREE_YN
     , EDU_TRAINING_PAY = @EDU_TRAINING_PAY
     , EDU_RECEIVE_METHOD = @EDU_RECEIVE_METHOD
     , EDU_FINISH_COURSE = @EDU_FINISH_COURSE
     , EDU_CONTENTS = @EDU_CONTENTS
     , MOD_DT = GETDATE()
     , COMMENT = @COMMENT
 WHERE EDU_ID=@EDU_ID

SELECT @ROWCOUNT=@@ROWCOUNT, @ERROR=@@ERROR

IF @ROWCOUNT=0
BEGIN
    INSERT MT_EDU_TB
         ( USERNAME, BIZ_NUMBER, ETC_ID_NUMBER, BIZ_PHONE, BIZ_EMAIL, EDU_NAME, EDU_PHONE1, EDU_PHONE2, AREA_A, AREA_B, AREA_C, AREA_DETAIL, MAP_X, MAP_Y, EDU_HOMEPAGE, EDU_IMG1, EDU_CLS, EDU_TITLE, EDU_TYPE, EDU_OBJECT_TYPE, EDU_OBJECT, EDU_ACCEPT_DT, EDU_ST_DT, EDU_END_DT, EDU_METHOD, EDU_TIME, EDU_CAPACITY, EDU_TOTAL_PRICE, EDU_NAT_PRICE, EDU_PRI_PRICE, EDU_FREE_YN, EDU_TRAINING_PAY, EDU_RECEIVE_METHOD, EDU_FINISH_COURSE, EDU_CONTENTS, MAG_ID, BRANCH_CD, MAG_NM, REG_TYPE, REG_DT, MOD_DT, COMMENT )
    VALUES
         ( @USERNAME, @BIZ_NUMBER, @ETC_ID_NUMBER, @BIZ_PHONE, @BIZ_EMAIL, @EDU_NAME, @EDU_PHONE1, @EDU_PHONE2, @AREA_A, @AREA_B, @AREA_C, @AREA_DETAIL, @MAP_X, @MAP_Y, @EDU_HOMEPAGE, @EDU_IMG1, @EDU_CLS, @EDU_TITLE, @EDU_TYPE, @EDU_OBJECT_TYPE, @EDU_OBJECT, @EDU_ACCEPT_DT, @EDU_ST_DT, @EDU_END_DT, @EDU_METHOD, @EDU_TIME, @EDU_CAPACITY, @EDU_TOTAL_PRICE, @EDU_NAT_PRICE, @EDU_PRI_PRICE, @EDU_FREE_YN, @EDU_TRAINING_PAY, @EDU_RECEIVE_METHOD, @EDU_FINISH_COURSE, @EDU_CONTENTS, @MAG_ID, @BRANCH_CD, @MAG_NM, @REG_TYPE, GETDATE(), GETDATE(), @COMMENT )

    PRINT 'AAA'
    SELECT @EDU_ID = IDENT_CURRENT('MT_EDU_TB')
END



--MT_PAYMENT_TB
UPDATE MT_PAYMENT_TB
   SET PRODUCT = @PRODUCT
     , LIST_ST_DT = @LIST_ST_DT
     , LIST_END_DT = @LIST_END_DT+' 23:59:59'
     , PAY_TYPE = @PAY_TYPE
     , INET_PRICE = @INET_PRICE
     , PAPER_PRICE = @PAPER_PRICE
     , LINEADID = @LINEADID
 WHERE [SECTION] = 'A01'
   AND ADID = @EDU_ID

SELECT @ROWCOUNT=@@ROWCOUNT, @ERROR=@@ERROR

IF @ROWCOUNT=0
BEGIN
    PRINT 'BBB'
    INSERT MT_PAYMENT_TB
         ( [SECTION], ADID, PRODUCT, LIST_ST_DT, LIST_END_DT, PAY_TYPE, INET_PRICE, PAPER_PRICE, LINEADID, REG_DT, PAY_DT )
    VALUES
         ( 'A01', @EDU_ID, @PRODUCT, @LIST_ST_DT, @LIST_END_DT+' 23:59:59', @PAY_TYPE, @INET_PRICE, @PAPER_PRICE, @LINEADID, GETDATE(), GETDATE() )

END

--MT_EUD_CNT_TB
UPDATE MT_EDU_CNT_TB
   SET CNT=CNT
 WHERE EDU_ID= @EDU_ID

SELECT @ROWCOUNT=@@ROWCOUNT, @ERROR=@@ERROR

IF @ROWCOUNT=0
BEGIN
    PRINT 'CCC'
    INSERT MT_EDU_CNT_TB
         ( EDU_ID, CNT)
    VALUES
         ( @EDU_ID, 0)
END

RETURN (0)



GO
/****** Object:  StoredProcedure [dbo].[SET_MT_EDU_CLOSE_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*학원 정보넷 광고 마감 처리*/

CREATE PROC [dbo].[SET_MT_EDU_CLOSE_PROC]
       @EDU_ID  INT
     , @MSG     NVARCHAR(4000)=''
AS

SET NOCOUNT ON

DECLARE @CNT   INT
SET @MSG=''


SELECT @CNT=COUNT(*)
  FROM MT_PAYMENT_TB WITH (NOLOCK)
 WHERE ADID=@EDU_ID
   AND SECTION='A01'
   AND CONVERT(VARCHAR(10),LIST_END_DT,111)<CONVERT(VARCHAR(10),GETDATE(),111)

IF @CNT=1
BEGIN
  SET @MSG='이미 마감된 광고입니다.'
  RETURN (1)
END

UPDATE MT_PAYMENT_TB
   SET LIST_END_DT=CONVERT(VARCHAR(10),DATEADD(DAY,-1,GETDATE()),111)+' 23:59:59.000'
 WHERE ADID=@EDU_ID
   AND SECTION='A01'








GO
/****** Object:  StoredProcedure [dbo].[USERID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:23:22 ******/
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
CREATE PROC [dbo].[USERID_CHANGE_PROC]
  @CUID            VARCHAR(50)        =  ''      -- 기존아이디
  ,@USERID            VARCHAR(50)        =  ''      -- 기존아이디
  ,@RE_USERID             VARCHAR(50)        =  ''      --  변경 아이디
  ,@CLIENT_IP		varchar(20) = ''

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	UPDATE A SET USERID=@RE_USERID FROM HP_BUSINESS_TB A  where CUID=@CUID


/*
	INSERT LOGDB.DBO.USERID_CHANGE_HISTORY_TB (B_USERID,N_USERID,DB_NM,USERIP)
	SELECT @USERID,@RE_USERID,DB_NAME(),@CLIENT_IP
*/
END


GO
