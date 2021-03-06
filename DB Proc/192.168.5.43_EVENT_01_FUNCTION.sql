USE [EVENT]
GO
/****** Object:  StoredProcedure [dbo].[CUID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
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

	--UPDATE A SET CUID=@MASTER_CUID FROM EV_ATTENDANCE_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_BI_FIND_ENTRY_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM EV_COMMENT_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_JOBRENEW_201309_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_COMMENT_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_MY_ALLPOINT_ENTRY_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_MY_ENTRY_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_MY_SCRAP_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_SAMSUNG_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_TVCF_EVENT_201311_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_TVCF_PROMOTION_201310_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_TVCF_PROMOTION_201404_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM EV_TVCF_PROMOTION_LIKE_JOIN_COUNT_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM PROMOTION_HOUSE_RECOM_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM PROMOTION_HOUSE_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM PROMOTION_JOB_STATUS_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM PROMOTION_JOB_TB A  where CUID=@SLAVE_CUID
	--UPDATE A SET CUID=@MASTER_CUID FROM PROMOTION_RESUME_OPEN_TB A  where CUID=@SLAVE_CUID

/*
	INSERT PAPER_NEW.DBO.CUID_CHANGE_HISTORY_TB (B_CUID, N_CUID, USERID, DB_NAME, USERIP)
		SELECT @MASTER_CUID , @SLAVE_CUID,@MASTER_USERID,DB_NAME(),@CLIENT_IP
*/		
END







GO
/****** Object:  StoredProcedure [dbo].[DROP_F_PROMOTION_HOUSE_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프로모션(2011.11) > 응모내용 삭제
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/10/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.DROP_F_PROMOTION_HOUSE_PROC
 *************************************************************************************/


CREATE PROC [dbo].[DROP_F_PROMOTION_HOUSE_PROC]

  @IDX           INT

AS

  SET NOCOUNT ON

  BEGIN TRAN

    UPDATE dbo.PROMOTION_HOUSE_TB
       SET DEL_YN = 1
     WHERE IDX = @IDX

  COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[DROP_F_PROMOTION_JOB_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 구인구직 드림프로젝트 (개인회원 취업일기 삭제)
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2011/10/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.DROP_F_PROMOTION_JOB_PROC 1
 *************************************************************************************/
 
CREATE PROC [dbo].[DROP_F_PROMOTION_JOB_PROC]
(
   	@SEQ			INT
)

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

BEGIN TRAN

	UPDATE PROMOTION_JOB_TB
	   SET DEL_YN = 'Y'
	       ,MOD_DT = GETDATE()
	     WHERE SEQ = @SEQ
 
IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
  BEGIN
    ROLLBACK TRAN
	RETURN (-1)
  END
ELSE
  BEGIN
	COMMIT TRAN
	RETURN (1)
  END
GO
/****** Object:  StoredProcedure [dbo].[EDIT_F_BI_FIND_ENTRY_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이 근 우(stari@mediawill.com)
-- Create date: 2013.09.30
-- Description:	이벤트 > BI찾기 이벤트 > BI 찾기 응모하기
-- Exam: EXEC EDIT_F_BI_FIND_ENTRY_PROC 'cowto76'
-- =============================================
CREATE PROCEDURE [dbo].[EDIT_F_BI_FIND_ENTRY_PROC]
		@USERID         VARCHAR(50)
		,@CUID			INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
  DECLARE @IDX INT
  DECLARE @ENTRY_COUNT INT
  DECLARE @MAX_ENTRY_DT SMALLDATETIME


  SELECT @MAX_ENTRY_DT = MAX(ENTRY_DT)
    FROM EV_BI_FIND_ENTRY_TB WITH (NOLOCK)
   WHERE USER_ID = @USERID
     AND ENTRY_YN = 'Y'
     AND ENTRY_COUNT = 5
     AND CUID = @CUID


  IF CONVERT(VARCHAR(10), @MAX_ENTRY_DT, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)
  BEGIN
    SELECT '2'
  END
  ELSE
  BEGIN

    SELECT @ENTRY_COUNT = COUNT(*)
      FROM EV_BI_FIND_ENTRY_TB WITH (NOLOCK)
     WHERE USER_ID = @USERID
       AND ENTRY_YN = 'N'
       AND ENTRY_COUNT = 5

    IF @ENTRY_COUNT > 0 
    BEGIN

      SELECT @IDX = IDX
        FROM EV_BI_FIND_ENTRY_TB WITH (NOLOCK)
       WHERE USER_ID = @USERID
         AND ENTRY_YN = 'N'
         AND ENTRY_COUNT = 5
       ORDER BY IDX DESC


      UPDATE TB
         SET ENTRY_YN = 'Y'
            ,ENTRY_DT = GETDATE()
        FROM EV_BI_FIND_ENTRY_TB TB
       WHERE IDX = @IDX
    
      SELECT '1'
    END

    ELSE
    BEGIN
      SELECT '3'
    END
  END
END
GO
/****** Object:  StoredProcedure [dbo].[EDIT_F_PROMOTION_HOUSE_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프로모션(2011.11) > 응모내용 수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/10/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.EDIT_F_PROMOTION_HOUSE_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_F_PROMOTION_HOUSE_PROC]

  @IDX             int
  ,@ETC_CONTENTS   varchar (500)
  ,@REG_NAME       varchar (30)
  ,@REG_PHONE      varchar (30)
  ,@REG_TITLE      varchar (250)
  ,@REG_CONTENTS   nvarchar(3000)

AS

  SET NOCOUNT ON

  BEGIN TRAN

    UPDATE dbo.PROMOTION_HOUSE_TB
       SET ETC_CONTENTS = @ETC_CONTENTS
          ,REG_NAME     = @REG_NAME
          ,REG_PHONE    = @REG_PHONE
          ,REG_TITLE    = @REG_TITLE
          ,REG_CONTENTS = @REG_CONTENTS
     WHERE IDX = @IDX

  COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[EDIT_F_PROMOTION_JOB_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 구인구직 드림프로젝트 (개인회원 취업일기 수정)
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2011/10/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.EDIT_F_PROMOTION_JOB_PROC '3', '면접 보러 갑니다. 내일도..', '1'
 *************************************************************************************/
 
CREATE PROC [dbo].[EDIT_F_PROMOTION_JOB_PROC]
(
   	@Seq			INT
,   @Contents       VARCHAR(280)
,   @Job_Status		CHAR(1)
)

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

BEGIN TRAN

  UPDATE PROMOTION_JOB_TB
	SET CONTENTS = @Contents
	    ,MOD_DT = GETDATE()
	WHERE SEQ = @Seq
	
  UPDATE PROMOTION_JOB_STATUS_TB
	SET JOB_STATUS = @Job_Status
	WHERE CUID = (SELECT CUID FROM PROMOTION_JOB_TB WHERE SEQ = @Seq)
 
IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
  BEGIN
    ROLLBACK TRAN
	RETURN (-1)
  END
ELSE
  BEGIN
	COMMIT TRAN
	RETURN (1)
  END
GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_EVENT_BANNER_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 이벤트 베너 등록/수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/02/24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.EDIT_M_EVENT_BANNER_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_EVENT_BANNER_PROC]

  @EVENT_SEQ         INT
  ,@BANNER_ING       VARCHAR(50) = ''
  ,@BANNER_END       VARCHAR(50) = ''
  ,@BANNER_MAIN      VARCHAR(50) = ''

AS

  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(1000)
  DECLARE @SQL_WHERE VARCHAR(200)

  SET @SQL = ''
  SET @SQL_WHERE = ''

  IF @BANNER_ING <> ''  
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ',BANNER_ING = '''+ @BANNER_ING +''''
    END

  IF @BANNER_END <> ''  
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ',BANNER_END = '''+ @BANNER_END +''''
    END

  IF @BANNER_MAIN <> ''  
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ',BANNER_MAIN = '''+ @BANNER_MAIN +''''
    END


  SET @SQL = 'UPDATE EV_EVENT_TB
       SET REG_DT = REG_DT
           '+ @SQL_WHERE +'
     WHERE EVENT_SEQ = '+ CAST(@EVENT_SEQ AS VARCHAR(12))


  BEGIN TRAN

    EXECUTE SP_EXECUTESQL @SQL

  COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_EVENT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 이벤트 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/02/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_EVENT_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_EVENT_PROC]

  @EVENT_SEQ          INT
  ,@PUB_LOCAL         TINYINT
  ,@PUB_FA            BIT
  ,@PUB_MAIN          BIT
  ,@TITLE             VARCHAR(200)
	,@SURVEY						CHAR(1)
  ,@INTRODUCTION      VARCHAR(100)
  ,@PUB_TYPE          TINYINT
  ,@CONTENTS          TEXT
  ,@START_DT          DATETIME
  ,@END_DT            DATETIME
  ,@STATUS            TINYINT
  ,@ANNOUNCE_DT       DATETIME
  ,@POINT_TYPE        TINYINT
  ,@POINT_VALUE       INT = 0
  ,@COMMENT_YN        BIT
  ,@PROGRESSION_SITE  VARCHAR(50) = NULL

AS

  SET NOCOUNT ON

  BEGIN TRAN

    -- 이벤트 정보 INSERT
    UPDATE EV_EVENT_TB
       SET PUB_LOCAL        = @PUB_LOCAL
          ,PUB_FA           = @PUB_FA
          ,PUB_MAIN         = @PUB_MAIN
          ,TITLE            = @TITLE
					,SURVEY						= @SURVEY
          ,INTRODUCTION     = @INTRODUCTION
          ,PUB_TYPE         = @PUB_TYPE
          ,CONTENTS         = @CONTENTS
          ,START_DT         = @START_DT
          ,END_DT           = @END_DT
          ,STATUS           = @STATUS
          ,ANNOUNCE_DT      = @ANNOUNCE_DT
          ,POINT_TYPE       = @POINT_TYPE
          ,POINT_VALUE      = @POINT_VALUE
          ,COMMENT_YN       = @COMMENT_YN
          ,PROGRESSION_SITE = @PROGRESSION_SITE
          ,MOD_DT = GETDATE()
     WHERE EVENT_SEQ = @EVENT_SEQ

  COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_EVENT_STATUS_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 이벤트 상태 처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/02/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : (D: 삭제, F: FA홈 적용, M: 이벤트 메인적용)
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.EDIT_M_EVENT_STATUS_PROC
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_EVENT_STATUS_PROC]

  @EVENT_SEQ INT
  ,@FLAG CHAR(1)

AS

  SET NOCOUNT ON

  IF @FLAG = 'D'
    BEGIN
      UPDATE EV_EVENT_TB
         SET DEL_YN = 1
       WHERE EVENT_SEQ = @EVENT_SEQ
    END
  ELSE IF @FLAG = 'F'
    BEGIN
      UPDATE EV_EVENT_TB
         SET PUB_FA = 1
       WHERE EVENT_SEQ = @EVENT_SEQ
    END
  ELSE IF @FLAG = 'M'
    BEGIN
      UPDATE EV_EVENT_TB
         SET PUB_MAIN = 1
       WHERE EVENT_SEQ = @EVENT_SEQ
    END
GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_TVCF_PROMOTION_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : TVCF 프로모션 삭제
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2014/04/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC EDIT_M_TVCF_PROMOTION_PROC 1
 *************************************************************************************/
CREATE PROC [dbo].[EDIT_M_TVCF_PROMOTION_PROC]
  @SEQ                      INT           = 6
AS

BEGIN
  IF @SEQ > 0
  BEGIN
    UPDATE TB
       SET TB.DEL_YN = 'Y'
      FROM EV_TVCF_PROMOTION_201404_TB AS TB
     WHERE TB.SEQ = @SEQ
  END
END
GO
/****** Object:  StoredProcedure [dbo].[EDIT_M_WININFO_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 당첨안내 수정하기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.EDIT_M_WININFO_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[EDIT_M_WININFO_PROC]

  @EVENT_SEQ INT
  ,@TITLE             VARCHAR(200)
  ,@START_DT          DATETIME
  ,@END_DT            DATETIME
  ,@ANNOUNCE_DT       DATETIME
  ,@PROGRESSION_SITE  VARCHAR(50) = NULL
  ,@WINNER_CNT        INT
  ,@GIVEAWAY          VARCHAR(200)
  ,@PUB_TYPE          TINYINT
  ,@CONTENTS          TEXT
  ,@INFO_DESC         TEXT
  ,@PUB_YN            BIT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 이벤트 정보 수정
  UPDATE EV_EVENT_TB
     SET TITLE = @TITLE
        ,START_DT = @START_DT
        ,END_DT = @END_DT
        ,ANNOUNCE_DT = @ANNOUNCE_DT
        ,PROGRESSION_SITE = @PROGRESSION_SITE
   WHERE EVENT_SEQ = @EVENT_SEQ;

  -- 당첨안내 수정
  UPDATE EV_WIN_INFO_TB
     SET WINNER_CNT = @WINNER_CNT
        ,GIVEAWAY = @GIVEAWAY
        ,PUB_TYPE = @PUB_TYPE
        ,CONTENTS = @CONTENTS
        ,INFO_DESC = @INFO_DESC
        ,PUB_YN = @PUB_YN
        ,MOD_DT = GETDATE()
   WHERE EVENT_SEQ = @EVENT_SEQ
GO
/****** Object:  StoredProcedure [dbo].[EXEC_LAYOUTCODENAME_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 게재띠변경시 해당지역 게재띠명칭 수정
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EXEC_LAYOUTCODENAME_CHANGE_PROC 14
 *************************************************************************************/


CREATE PROC [dbo].[EXEC_LAYOUTCODENAME_CHANGE_PROC]

  @LAYOUT_BRANCH          TINYINT

AS

  SET NOCOUNT ON

  BEGIN TRAN

    -- 오늘자 줄광고
    UPDATE PP_LINE_AD_TB
       SET LAYOUTCODENAME = B.VIEWTEXT
      FROM PP_LINE_AD_TB AS A
          JOIN LayoutClassDB.dbo.LAYOUTCLASS_TOT AS B
            ON B.BRANCHCODE = A.LAYOUT_BRANCH
           AND B.HEADERCODE = A.LAYOUTCODE
     WHERE A.LAYOUT_BRANCH = @LAYOUT_BRANCH

    -- 온라인 등록 광고
    UPDATE PP_LINE_AD_ONLINE_TB
       SET LAYOUTCODENAME = B.VIEWTEXT
      FROM PP_LINE_AD_ONLINE_TB AS A
          JOIN LayoutClassDB.dbo.LAYOUTCLASS_TOT AS B
            ON B.BRANCHCODE = A.LAYOUT_BRANCH
           AND B.HEADERCODE = A.LAYOUTCODE
     WHERE A.LAYOUT_BRANCH = @LAYOUT_BRANCH


    -- 관리자 수정 광고
    UPDATE PP_LINE_AD_MANAGE_TB
       SET LAYOUTCODENAME = B.VIEWTEXT
      FROM PP_LINE_AD_MANAGE_TB AS A
          JOIN LayoutClassDB.dbo.LAYOUTCLASS_TOT AS B
            ON B.BRANCHCODE = A.LAYOUT_BRANCH
           AND B.HEADERCODE = A.LAYOUTCODE
     WHERE A.LAYOUT_BRANCH = @LAYOUT_BRANCH


  COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[GET_EV_EVENT_DATA_TB_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 이벤트 리스트
 *  작   성   자 : 김선호
 *  작   성   일 : 2018.09.03
 *  설        명 : 이벤트 번호로 참여한 리스트 노출
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
EXEC GET_EV_EVENT_DATA_TB_LIST_PROC 0,1,5,672,'192.168.77.214'
*************************************************************************************/
CREATE PROC [dbo].[GET_EV_EVENT_DATA_TB_LIST_PROC]
	@TOTALCOUNT INT = 0
	,@PAGE		INT  = 1
	,@PAGESIZE	INT = 5
	,@EVENT_SEQ	INT = 672
	,@IPADDR	VARCHAR(20) = ''
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @SQL	NVARCHAR(MAX)
			,@SQL_PARAM	NVARCHAR(MAX)
			,@SQL_WHERE NVARCHAR(MAX)
			
	SET @SQL_PARAM ='
		@TOTALCOUNT INT OUTPUT
		,@PAGE		INT
		,@PAGESIZE	INT
		,@EVENT_SEQ	INT
		,@IPADDR	VARCHAR(20)
	'

	SET @SQL_WHERE = ''
	SET @SQL_WHERE = @SQL_WHERE + '
		AND B.EVENT_SEQ = @EVENT_SEQ
	'

	SET @SQL = ''
	IF @TOTALCOUNT = 0 BEGIN
		SET @SQL = @SQL + '		
			SELECT @TOTALCOUNT = COUNT(*)
			FROM [DBO].[EV_EVENT_DATA_SUB_TB] A WITH(NOLOCK)
			INNER JOIN [DBO].[EV_EVENT_DATA_TB] B WITH(NOLOCK) ON A.DATAIDX=B.DATAIDX
			WHERE 1 = 1
			' + @SQL_WHERE + '
		'
	END
	
	SET @SQL = @SQL + '		
		SELECT TOP(@PAGESIZE) @TOTALCOUNT AS TOTALCOUNT
			,A.DATAIDX
			,ISNULL(C.REGNAME,'''') AS REGNAME
			,ISNULL(A.GBN,'''') AS GBN
			,A.IDX
			,A.REGDATE							--5			
			,dbo.FN_GET_USERID_SECURE(C.REGID) as REGID 
		FROM EV_EVENT_DATA_SUB_TB A WITH(NOLOCK)
		INNER JOIN(
			SELECT TOP (@PAGE*@PAGESIZE)
			IDX
			, ROW_NUMBER() OVER(ORDER BY IDX DESC) AS ROWNUM
			FROM [DBO].[EV_EVENT_DATA_SUB_TB] A WITH(NOLOCK)
			INNER JOIN [DBO].[EV_EVENT_DATA_TB] B WITH(NOLOCK) ON A.DATAIDX=B.DATAIDX
			WHERE 1 = 1
			' + @SQL_WHERE + '
			ORDER BY A.IDX DESC		
		) B ON A.IDX = B.IDX
		INNER JOIN [DBO].[EV_EVENT_DATA_TB] C WITH(NOLOCK) ON A.DATAIDX=C.DATAIDX
		WHERE ROWNUM BETWEEN (@PAGE - 1) * @PAGESIZE + 1  AND @PAGE * @PAGESIZE
		ORDER BY B.ROWNUM
	'

	EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM
	,@TOTALCOUNT 
	,@PAGE		
	,@PAGESIZE	
	,@EVENT_SEQ	
	,@IPADDR	
END


GO
/****** Object:  StoredProcedure [dbo].[GET_EV_PROMOTION_FINDALL_FORTUNE_SERVICE_TB_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 운세서비스 설정값 가져오기
 *  작   성   자 : 신 장 순 (jssin@mediawill.com)
 *  작   성   일 : 2016/09/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_EV_PROMOTION_FINDALL_FORTUNE_SERVICE_TB_PROC 11343563
 *************************************************************************************/
CREATE PROC [dbo].[GET_EV_PROMOTION_FINDALL_FORTUNE_SERVICE_TB_PROC]
	@MID VARCHAR(200)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	SELECT *
	FROM PROMOTION_FINDALL_FORTUNE_SERVICE_TB
	WHERE MID = @MID
END
GO
/****** Object:  StoredProcedure [dbo].[GET_EV_WeArea_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
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
 *  사 용  예 제 : EXEC DBO.[GET_EV_WeArea_LIST_PROC] 1, 12
 *************************************************************************************/


CREATE PROC [dbo].[GET_EV_WeArea_LIST_PROC]
		@PAGE      INT
	, @PAGESIZE INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)
DECLARE @SQL_COUNT NVARCHAR(4000)

SET @SQL = ''
SET @SQL_COUNT = ''

SET @SQL_COUNT = 'SELECT COUNT(*) AS CNT
									FROM dbo.EV_WeArea'

SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
								idx
							, Name
							, HP
							, Area
							, Contents
							, RegDT
						FROM dbo.EV_WeArea 
						ORDER BY RegDT DESC'

--PRINT @SQL

EXECUTE SP_EXECUTESQL @SQL_COUNT
EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_F_ATTENDANCE_DAY_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 메인 > 출석체크 현황
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_ATTENDANCE_DAY_PROC 'cbk08'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_ATTENDANCE_DAY_PROC]

  @USERID VARCHAR(50)
  ,@CUID  INT = NULL

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT DAY(REG_DT) AS REG_DAY
    FROM dbo.EV_ATTENDANCE_TB
   WHERE USERID = @USERID
	 AND CUID = @CUID
     AND CONVERT(VARCHAR(7),REG_DT,120) = CONVERT(VARCHAR(7),GETDATE(),120)
   ORDER BY REG_DAY ASC
GO
/****** Object:  StoredProcedure [dbo].[GET_F_BI_FIND_SEARCH_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이 근 우(stari@mediawill.com)
-- Create date: 2013.09.30
-- Description:	BI 찾기 이벤트 참여조회
-- Exam: EXEC GET_F_BI_FIND_SEARCH_PROC 'cowto76'
-- =============================================
CREATE PROCEDURE [dbo].[GET_F_BI_FIND_SEARCH_PROC]
	@USERID         VARCHAR(50)
    ,@CUID  INT = NULL
AS
BEGIN	
	SET NOCOUNT ON;
  DECLARE @MAX_ENTRY_DT SMALLDATETIME


  SELECT ENTRY_COUNT
    FROM EV_BI_FIND_ENTRY_TB WITH (NOLOCK)
   WHERE USER_ID = @USERID
	 AND CUID = @CUID
     AND ENTRY_YN = 'N'


  SELECT @MAX_ENTRY_DT = MAX(ENTRY_DT)
    FROM EV_BI_FIND_ENTRY_TB WITH (NOLOCK)
   WHERE USER_ID = @USERID
 	 AND CUID = @CUID
     AND ENTRY_YN = 'Y'
     AND ENTRY_COUNT = 5

  IF CONVERT(VARCHAR(10), @MAX_ENTRY_DT, 120) < CONVERT(VARCHAR(10), GETDATE(), 120) OR @MAX_ENTRY_DT IS NULL
  BEGIN
    SELECT '1'
  END
  ELSE
  BEGIN
    SELECT '2'
  END 
END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_EV_EVENT_DATA_SUB_TB_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 이벤트 SUB 데이터 SELECT
 *  작   성   자 : 조재성
 *  작   성   일 : 2018/02/20
 *  설        명 : EV_EVENT_DATA_SUB_TB 테이블 SELECT
 *  수   정   자 : 김선호
 *  수   정   일 : 2018/04/03
 *  설        명 : 당일 참여여부 확인(출석체크 이벤트용)
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 *************************************************************************************/
 
CREATE PROC [dbo].[GET_F_EV_EVENT_DATA_SUB_TB_PROC]
(
	@DATAIDX INT=0 --참여자IDX
	,@GBN  VARCHAR(20)='' --참여자,피참여자등의 구분 --entry, visit
	,@GCODE SMALLINT=0 --그룹코드
	,@ICODE INT=0 --개별코드
	,@REGIP VARCHAR(15)='' -- 참여자 IP
	,@1DAYCHECK CHAR(1)='' --당일 참여내역 조회
)
AS
BEGIN	
	SET NOCOUNT ON	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQL NVARCHAR(MAX)      = ''
	DECLARE @SQL_WHERE NVARCHAR(MAX)      = ''
	DECLARE @Params NVARCHAR(4000) -- 동적 전용 쿼리
	
	--참여자IDX
	IF @DATAIDX <> 0 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.DATAIDX = @DATAIDX '
	END

	--참여자,피참여자등의 구분 --entry, visit
	IF @GBN <> '' 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.GBN = @GBN '
	END

	--그룹코드
	IF @GCODE <> 0 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.GCODE = @GCODE '
	END

	--개별코드
	IF @ICODE <> 0 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.ICODE = @ICODE '
	END

	--참여자 IP
	IF @REGIP <> '' 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGIP = @REGIP '
	END
	
	--출석체크, 당일 참여 여부 확인
	IF @1DAYCHECK = 'Y' 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGDATE >= CONVERT(CHAR(10), GETDATE(), 23)'
	END

	IF @SQL_WHERE <> ''
	BEGIN
		SET @SQL_WHERE = ' WHERE ' + SubString(@SQL_WHERE,6,Len(@SQL_WHERE)-4)
	END

	SET @SQL = ' SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		 SELECT A.IDX, A.DATAIDX, A.GBN, A.GCODE, A.ICODE, A.REGIP, A.REGDATE, A.DEVICE
		 FROM EV_EVENT_DATA_SUB_TB A ' + @SQL_WHERE + '
		 ORDER BY A.IDX' 

	SET @Params = '@DATAIDX INT
	,@GBN  VARCHAR(20)
	,@GCODE SMALLINT
	,@ICODE VARCHAR(50)
	,@REGIP VARCHAR(15)'

EXEC sp_executesql @SQL, @Params
, @DATAIDX = @DATAIDX
, @GBN = @GBN
, @GCODE = @GCODE
, @ICODE = @ICODE
, @REGIP = @REGIP

END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_EV_EVENT_DATA_TB_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 이벤트 데이터 SELECT
 *  작   성   자 : 조재성
 *  작   성   일 : 2018/02/21
 *  설        명 : EV_EVENT_DATA_TB 테이블 SELECT
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 *************************************************************************************/
 
CREATE PROC [dbo].[GET_F_EV_EVENT_DATA_TB_PROC]
(
	@DATAIDX INT=0	--참여자IDX
	,@EVENT_SEQ INT = 0 --이벤트번호
	,@REGNAME VARCHAR(20)='' -- 참여자 이름
	,@REGPHONE VARCHAR(13)='' -- 참여자 전화번호
	,@REGEMAIL VARCHAR(50)='' -- 참여자 이메일
	,@REGID VARCHAR(30)='' -- 참여자 아이디
	,@CUID INT=0 --참여자 회원번호
	,@REGIP VARCHAR(15)='' -- 참여자 IP 
)
AS
BEGIN	
	SET NOCOUNT ON	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQL NVARCHAR(MAX)      = ''
	DECLARE @SQL_WHERE NVARCHAR(MAX)      = ''
	DECLARE @Params NVARCHAR(4000) -- 동적 전용 쿼리
	
	--참여자IDX
	IF @DATAIDX <> 0 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.DATAIDX = @DATAIDX '
	END

	--이벤트번호
	IF @EVENT_SEQ <> 0 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.EVENT_SEQ = @EVENT_SEQ '
	END

	--참여자이름
	IF @REGNAME <> '' 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGNAME = @REGNAME '
	END

	--참여자전화번호
	IF @REGPHONE <> '' 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGNAME LIKE ''%''+@REGPHONE+''%''  '
	END

	--참여자아이디
	IF @REGID <> '' 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGID = @REGID '
	END

	--cuid
	IF @CUID <> 0 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.CUID = @CUID '
	END

	--참여자 IP
	IF @REGIP <> '' 
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGIP = @REGIP '
	END

	IF @SQL_WHERE <> ''
	BEGIN
		SET @SQL_WHERE = ' WHERE ' + SubString(@SQL_WHERE,6,Len(@SQL_WHERE)-4)
	END

	SET @SQL = ' SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		 SELECT A.DATAIDX, A.EVENT_SEQ, A.REGNAME, A.REGPHONE, A.REGEMAIL, A.REGID, A.CUID, A.REGIP, A.REGDATE, A.MODDATE
		 FROM EV_EVENT_DATA_TB A ' + @SQL_WHERE

	SET @Params = '@DATAIDX INT
	,@EVENT_SEQ INT
	,@REGNAME VARCHAR(20)
	,@REGPHONE VARCHAR(13)
	,@REGEMAIL VARCHAR(50)
	,@REGID VARCHAR(30)
	,@CUID INT
	,@REGIP VARCHAR(15)'

EXEC sp_executesql @SQL, @Params
, @DATAIDX = @DATAIDX
, @EVENT_SEQ = @EVENT_SEQ
, @REGNAME = @REGNAME
, @REGPHONE = @REGPHONE
, @REGEMAIL = @REGEMAIL
, @REGID = @REGID
, @CUID = @CUID
, @REGIP = @REGIP

END


GO
/****** Object:  StoredProcedure [dbo].[GET_F_EVENT_COMMENT_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 이벤트 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_EVENT_COMMENT_LIST_PROC 1, 5, 2
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_EVENT_COMMENT_LIST_PROC]

  @PAGE INT
  ,@PAGESIZE INT
  ,@EVENT_SEQ INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(600)
  DECLARE @SQL_COUNT NVARCHAR(200)

  SET @SQL_COUNT = 'SELECT COUNT(*) AS CNT
                      FROM EV_COMMENT_TB
                     WHERE EVENT_SEQ = '+ CAST(@EVENT_SEQ AS VARCHAR(10))
  
  
  SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
                     SEQ
                    ,USERID
                    ,CAST(COMMENT AS VARCHAR(249)) AS COMMENT
                    ,REG_DT
                    ,CUID
                FROM EV_COMMENT_TB
               WHERE EVENT_SEQ = '+ CAST(@EVENT_SEQ AS VARCHAR(10)) +'
               ORDER BY REG_DT DESC'

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_F_EVENT_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 이벤트 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_EVENT_DETAIL_PROC 5, 0
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_EVENT_DETAIL_PROC]

  @EVENT_SEQ INT
  ,@KIND CHAR(1) = '1'

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL_DETAIL NVARCHAR(500)
  DECLARE @SQL_PRE    NVARCHAR(750)
  DECLARE @SQL_NEXT   NVARCHAR(750)
  DECLARE @SQL_WHERE  NVARCHAR(500)

  SET @SQL_DETAIL = ''
  SET @SQL_PRE    = ''
  SET @SQL_NEXT   = ''
  SET @SQL_WHERE  = ''

  -- 상세보기 종류 (종료: '0', 진행: '1')
  IF @KIND = '1'
    BEGIN
      SET @SQL_WHERE = 'AND DEL_YN = 0
                        AND STATUS = 1
                        AND CONVERT(VARCHAR(10),START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
                        AND CONVERT(VARCHAR(10),END_DT,120) >= CONVERT(VARCHAR(10),GETDATE(),120)'
    END
  ELSE
    BEGIN
      SET @SQL_WHERE = 'AND DEL_YN = 0
                        AND STATUS = 1
                        AND CONVERT(VARCHAR(10),END_DT,120) < CONVERT(VARCHAR(10),GETDATE(),120)'
    END

  -- 상세보기 항목
  SET @SQL_DETAIL = 'SELECT TITLE
                           ,CONTENTS
                           ,COMMENT_YN
                       FROM EV_EVENT_TB
                      WHERE EVENT_SEQ ='+ CAST(@EVENT_SEQ AS VARCHAR(10)) +' '+ @SQL_WHERE


  -- 이전목록
  SET @SQL_PRE = 'SELECT TOP 1
                         EVENT_SEQ
                        ,TITLE
                        ,CONVERT(VARCHAR(10),START_DT,102) AS START_DT
                        ,CONVERT(VARCHAR(10),END_DT,102) AS END_DT
                        ,PUB_TYPE
                        ,CONTENTS
                    FROM EV_EVENT_TB
                   WHERE EVENT_SEQ < '+ CAST(@EVENT_SEQ AS VARCHAR(10)) +'
                         '+ @SQL_WHERE +'
                   ORDER BY EVENT_SEQ DESC'

  -- 다음목록
  SET @SQL_NEXT = 'SELECT TOP 1
                          EVENT_SEQ
                         ,TITLE
                         ,CONVERT(VARCHAR(10),START_DT,102) AS START_DT
                         ,CONVERT(VARCHAR(10),END_DT,102) AS END_DT
                         ,PUB_TYPE
                         ,CONTENTS
                     FROM EV_EVENT_TB
                    WHERE EVENT_SEQ > '+ CAST(@EVENT_SEQ AS VARCHAR(10)) +'
                          '+ @SQL_WHERE +'
                    ORDER BY EVENT_SEQ ASC'

--PRINT @SQL_NEXT
  EXECUTE SP_EXECUTESQL @SQL_DETAIL
  EXECUTE SP_EXECUTESQL @SQL_PRE
  EXECUTE SP_EXECUTESQL @SQL_NEXT
GO
/****** Object:  StoredProcedure [dbo].[GET_F_EVENT_END_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 종료된 이벤트 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_EVENT_END_LIST_PROC 1, 12
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_EVENT_END_LIST_PROC]

  @PAGE      INT
  ,@PAGESIZE INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(4000)

  SET @SQL = ''
  SET @SQL_COUNT = ''

  SET @SQL_COUNT = 'SELECT COUNT(*) AS CNT
    FROM dbo.EV_EVENT_TB
   WHERE DEL_YN = 0
     AND STATUS = 1
     AND CONVERT(VARCHAR(10),END_DT,120) < CONVERT(VARCHAR(10),GETDATE(),120)'

  SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
         A.EVENT_SEQ
        ,A.TITLE
        ,A.BANNER_END
        ,A.INTRODUCTION
        ,CONVERT(VARCHAR(10),A.START_DT,102) AS START_DT
        ,CONVERT(VARCHAR(10),A.END_DT,102) AS END_DT
        ,CONVERT(VARCHAR(10),A.ANNOUNCE_DT,102) AS ANNOUNCE_DT
        ,A.PUB_TYPE
        ,B.PUB_TYPE AS WIN_PUB_TYPE
        ,B.CONTENTS AS WIN_CONTENTS
    FROM dbo.EV_EVENT_TB AS A
         JOIN dbo.EV_WIN_INFO_TB AS B
           ON B.EVENT_SEQ = A.EVENT_SEQ
   WHERE A.DEL_YN = 0
     AND A.STATUS = 1
     AND CONVERT(VARCHAR(10),A.END_DT,120) < CONVERT(VARCHAR(10),GETDATE(),120)
   ORDER BY A.EVENT_SEQ DESC'

--PRINT @SQL

  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_F_EVENT_ENTRY_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 나의 응모내역
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_F_EVENT_ENTRY_LIST_PROC 1, 20, 'cbk08'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_EVENT_ENTRY_LIST_PROC]

  @PAGE       INT
  ,@PAGESIZE  INT
  ,@CUID	  INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(1000)
  DECLARE @SQL_COUNT NVARCHAR(1000)

  SET @SQL = ''
  SET @SQL_COUNT = ''

  SET @SQL_COUNT = 'SELECT COUNT(*) AS CNT
                      FROM EVENT_ENTRY_VI
                     WHERE CUID = '''+CAST(@CUID as varchar)+'''
                     ;'

  SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
                     EVENT_SEQ
                    ,PROGRESSION_SITE
                    ,TITLE
                    ,START_DT
                    ,END_DT
                    ,ENTRY_DT
                    ,ANNOUNCE_DT
                    ,PUB_TYPE
                FROM EVENT_ENTRY_VI
               WHERE CUID = '''+CAST(@CUID as varchar)+'''
               ORDER BY ENTRY_DT DESC'

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_F_EVENT_ING_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 진행중인 이벤트 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_EVENT_ING_LIST_PROC 1, 12
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_EVENT_ING_LIST_PROC]

  @PAGE      INT
  ,@PAGESIZE INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(4000)

  SET @SQL = ''
  SET @SQL_COUNT = ''

  SET @SQL_COUNT = 'SELECT COUNT(*) AS CNT
    FROM dbo.EV_EVENT_TB
   WHERE DEL_YN = 0
     AND STATUS = 1
     AND CONVERT(VARCHAR(10),START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
     AND CONVERT(VARCHAR(10),END_DT,120) >= CONVERT(VARCHAR(10),GETDATE(),120)'

  SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
         EVENT_SEQ
        ,TITLE
        ,BANNER_ING
        ,INTRODUCTION
        ,CONVERT(VARCHAR(10),START_DT,102) AS START_DT
        ,CONVERT(VARCHAR(10),END_DT,102) AS END_DT
        ,CONVERT(VARCHAR(10),ANNOUNCE_DT,102) AS ANNOUNCE_DT
        ,PUB_TYPE
    FROM dbo.EV_EVENT_TB
   WHERE DEL_YN = 0
     AND STATUS = 1
     AND CONVERT(VARCHAR(10),START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
     AND CONVERT(VARCHAR(10),END_DT,120) >= CONVERT(VARCHAR(10),GETDATE(),120)
   ORDER BY EVENT_SEQ DESC'

  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_F_EVENT_REDIRECT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 이벤트 HIT 추가 및 이동경로
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_EVENT_REDIRECT_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_EVENT_REDIRECT_PROC]

  @EVENT_SEQ INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- HIT수 갱신
  UPDATE EV_EVENT_TB
     SET HIT = HIT + 1
   WHERE EVENT_SEQ = @EVENT_SEQ;

  -- 경로로 이동 (외부링크인 경우)
  SELECT CONTENTS
    FROM EV_EVENT_TB
   WHERE PUB_TYPE = 2
     AND EVENT_SEQ = @EVENT_SEQ
GO
/****** Object:  StoredProcedure [dbo].[GET_F_EVENT_SCRAP_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 나의 관심이벤트 (스크랩)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_EVENT_SCRAP_LIST_PROC 1, 20, 'cbk08'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_EVENT_SCRAP_LIST_PROC]

  @PAGE       INT
  ,@PAGESIZE  INT
  ,@USERID    VARCHAR(50)
  ,@CUID	  INT = NULL

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(1000)
  DECLARE @SQL_COUNT NVARCHAR(1000)

  SET @SQL = ''
  SET @SQL_COUNT = ''

  SET @SQL_COUNT = 'SELECT COUNT(*) AS CNT
                      FROM EV_MY_SCRAP_TB AS A
                           JOIN EV_EVENT_TB AS B
                             ON B.EVENT_SEQ = A.EVENT_SEQ
                     WHERE A.USERID = '''+ @USERID +'''
					   AND CUID = '''+CAST(@CUID as varchar)+'''
                     
                     ;'

  SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
                     A.EVENT_SEQ
                    ,B.PROGRESSION_SITE
                    ,B.TITLE
                    ,CONVERT(VARCHAR(10),B.START_DT,102) AS START_DT
                    ,CONVERT(VARCHAR(10),B.END_DT,102) AS END_DT
                    ,A.REG_DT AS ENTRY_DT
                    ,CONVERT(VARCHAR(10),B.ANNOUNCE_DT,102) AS ANNOUNCE_DT
                    ,A.USERID
                    ,B.PUB_TYPE
                    ,A.CUID
                FROM EV_MY_SCRAP_TB AS A
                     JOIN EV_EVENT_TB AS B
                       ON B.EVENT_SEQ = A.EVENT_SEQ
               WHERE A.USERID = '''+ @USERID + '''
				 AND CUID = '''+CAST(@CUID as varchar)+'''
               
               ORDER BY ENTRY_DT DESC'

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAIN_EV_WIN_INFO_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 메인 > 당첨안내공지
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_MAIN_EV_WIN_INFO_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_MAIN_EV_WIN_INFO_PROC]


AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT TOP 6
         A.EVENT_SEQ
        ,B.TITLE
        ,A.PUB_TYPE
        ,A.CONTENTS
    FROM dbo.EV_WIN_INFO_TB AS A
         JOIN dbo.EV_EVENT_TB AS B
           ON B.EVENT_SEQ = A.EVENT_SEQ
   WHERE A.PUB_YN = 1
	AND B.DEL_YN =0
   ORDER BY B.REG_DT DESC



GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAIN_ING_EVENT_COUNT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 메인 > 시작,종료 이벤트 갯수
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_MAIN_ING_EVENT_COUNT_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_MAIN_ING_EVENT_COUNT_PROC]


AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT COUNT(*) AS CNT
    FROM dbo.EV_EVENT_TB
   WHERE CONVERT(VARCHAR(10), START_DT, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)
     AND DEL_YN = 0
     AND STATUS = 1

  UNION ALL

  SELECT COUNT(*) AS CNT
    FROM dbo.EV_EVENT_TB
   WHERE CONVERT(VARCHAR(10), END_DT, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)
--     AND (DEL_YN = 1 OR STATUS <> 1)  -- 삭제되었거나 진행중이 아닌것
     AND DEL_YN = 0
     AND STATUS = 1
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAIN_NEW_EVENT_ING_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 메인 > 진행중인 이벤트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_MAIN_NEW_EVENT_ING_LIST_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_MAIN_NEW_EVENT_ING_LIST_PROC]



AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  SELECT TOP 12
         EVENT_SEQ
        ,TITLE
        ,BANNER_ING
        ,INTRODUCTION
        ,CONVERT(VARCHAR(10),START_DT,102) AS START_DT
        ,CONVERT(VARCHAR(10),END_DT,102) AS END_DT
        ,CONVERT(VARCHAR(10),ANNOUNCE_DT,102) AS ANNOUNCE_DT
        ,PUB_TYPE
    FROM dbo.EV_EVENT_TB
   WHERE DEL_YN = 0
     AND STATUS = 1
     AND CONVERT(VARCHAR(10),START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
     AND CONVERT(VARCHAR(10),END_DT,120) >= CONVERT(VARCHAR(10),GETDATE(),120)
   ORDER BY NEWID()
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAIN_NEW_EVENT_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 메인 > 신규이벤트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_MAIN_NEW_EVENT_LIST_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_MAIN_NEW_EVENT_LIST_PROC]



AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  SELECT TOP 9
         EVENT_SEQ
        ,TITLE
        ,BANNER_ING
        ,PUB_TYPE
    FROM dbo.EV_EVENT_TB
   WHERE DEL_YN = 0
     AND STATUS = 1
     AND CONVERT(VARCHAR(10),START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
     AND CONVERT(VARCHAR(10),END_DT,120) >= CONVERT(VARCHAR(10),GETDATE(),120)
   ORDER BY EVENT_SEQ DESC
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAIN_SEARCH_RENEWAL_PROMOTION_COMMENT_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 메인/검색 리뉴얼 프로모션 참여리스트 코멘트
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016/06/28
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_MAIN_SEARCH_RENEWAL_PROMOTION_COMMENT_LIST_PROC]

  @START_DT           VARCHAR(10)     = ''
, @END_DT             VARCHAR(10)     = ''

AS 
  
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT USERID AS [아이디]
       , COMMENT AS[내용]
       , REG_DT AS [등록일]
       , CUID  AS [회원번호]
    FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_COMMENT_TB
   ORDER BY EVENT_SEQ DESC


END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MAIN_SEARCH_RENEWAL_PROMOTION_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 메인/검색 리뉴얼 프로모션 참여리스트
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016/06/28
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC FINDDB2.EVENT.DBO.GET_F_MAIN_SEARCH_RENEWAL_PROMOTION_LIST_PROC
 EXEC FINDDB2.EVENT.DBO.GET_F_MAIN_SEARCH_RENEWAL_PROMOTION_LIST_PROC
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_MAIN_SEARCH_RENEWAL_PROMOTION_LIST_PROC]

  @START_DT           VARCHAR(10)     = ''
, @END_DT             VARCHAR(10)     = ''

AS 
  
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  IF @START_DT = ''
    SET @START_DT = CONVERT(VARCHAR(10), GETDATE(), 120)
  

  SELECT EVENT_DT AS [이벤트일]
       , CASE WHEN EVENT_TYPE = 1 THEN '이벤트1'
         ELSE '이벤트2' END AS [이벤트 구분]
       , USERID AS [아이디]
       , WIN_GBN AS [당첨여부]
       , CASE WIN_PRIZE WHEN 1 THEN '사이다'
                        WHEN 2 THEN '스타벅스'
                        WHEN 3 THEN '백화점상품권'
         ELSE '' END AS [당첨_경품]
       , CASE WHEN USER_IP <> '' THEN 'PC'
         ELSE 'MOBILE' END AS [이벤트 참여경로]
       , REG_DT AS [이벤트 참여일]
       , CUID AS [회원번호]
    FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_TB
   WHERE EVENT_DT = @START_DT
   ORDER BY EVENT_DT, EVENT_SEQ


END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MONTHLY_EVENT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 월별 이벤트 현황 (이벤트 캘린더)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_MONTHLY_EVENT_PROC '2011-03-14'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_MONTHLY_EVENT_PROC]

  @TARGET_DATE  VARCHAR(10)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT EVENT_SEQ
        ,TITLE
        ,CONVERT(VARCHAR(10),START_DT,120) AS START_DT
        ,CONVERT(VARCHAR(10),END_DT,120) AS END_DT
        ,PUB_TYPE
   FROM dbo.EV_EVENT_TB
  WHERE DEL_YN = 0
    AND STATUS = 1
    AND (CONVERT(VARCHAR(7),START_DT,120) = LEFT(@TARGET_DATE,7)
         OR CONVERT(VARCHAR(7),END_DT,120) = LEFT(@TARGET_DATE,7))
  ORDER BY START_DT ASC
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MY_EVENT_COUNT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 >  응모, 관심 이벤트 갯수
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_MY_EVENT_COUNT_PROC 'cbk08'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_MY_EVENT_COUNT_PROC]

  @USERID  VARCHAR(50)
  ,@CUID	INT = null

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT COUNT(*) AS CNT
    FROM EVENT_ENTRY_VI
   WHERE USERID = @USERID
	AND  CUID = @CUID
	AND ENTRY_DT>=DATEADD(DAY, -180, GETDATE())
  UNION ALL

  SELECT COUNT(*) AS CNT
    FROM EV_MY_SCRAP_TB AS A
         JOIN EV_EVENT_TB AS B
           ON B.EVENT_SEQ = A.EVENT_SEQ
   WHERE A.USERID = @USERID
	AND  A.CUID = @CUID
	AND A.REG_DT>=DATEADD(DAY, -180, GETDATE())
GO
/****** Object:  StoredProcedure [dbo].[GET_F_PROMOTION_HOUSE_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프로모션(2011.11) > 응모 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/10/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_PROMOTION_HOUSE_DETAIL_PROC 1
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_PROMOTION_HOUSE_DETAIL_PROC]

  @IDX           INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 조회수 증가
  BEGIN TRAN
    UPDATE dbo.PROMOTION_HOUSE_TB
       SET HIT = HIT + 1
     WHERE IDX = @IDX
  COMMIT TRAN

  -- 내용가져오기
  SELECT USERID
        ,AD_CATEGORY_NM
        ,AD_ADDRESS
        ,AD_PRICE_JUN
        ,AD_PRICE_BO
        ,AD_PRICE_WOL
        ,ETC_CONTENTS
        ,REG_NAME
        ,REG_PHONE
        ,REG_TITLE
        ,REG_CONTENTS
        ,(SELECT COUNT(*)
              FROM dbo.PROMOTION_HOUSE_RECOM_TB
             WHERE IDX = @IDX) AS RECOM_CNT
        ,HIT
        ,REG_DT
        ,CUID
    FROM dbo.PROMOTION_HOUSE_TB
   WHERE IDX = @IDX
GO
/****** Object:  StoredProcedure [dbo].[GET_F_PROMOTION_HOUSE_ENTRY_COUNT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프로모션(2011.11) > 광고별 참여 건수
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/10/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_PROMOTION_HOUSE_ENTRY_COUNT_PROC 1, 'P'
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_PROMOTION_HOUSE_ENTRY_COUNT_PROC]

  @ADID           INT
  ,@AD_TYPE       CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT COUNT(*) AS CNT
    FROM dbo.PROMOTION_HOUSE_TB
   WHERE AD_TYPE = @AD_TYPE
     AND ADID = @ADID
GO
/****** Object:  StoredProcedure [dbo].[GET_F_PROMOTION_HOUSE_IDX_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프로모션(2011.11) > 프로모션 응모 순번 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/10/24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_PROMOTION_HOUSE_IDX_PROC 'cbk08','H'
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_PROMOTION_HOUSE_IDX_PROC]

  @USERID           VARCHAR(50)
--  ,@AD_TYPE         CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT TOP 1 IDX
    FROM PROMOTION_HOUSE_TB
   WHERE DEL_YN = 0
     AND USERID = @USERID
--     AND AD_TYPE = @AD_TYPE
GO
/****** Object:  StoredProcedure [dbo].[GET_F_PROMOTION_HOUSE_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프로모션(2011.11) > 응모 상세보기(관리자)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/10/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_PROMOTION_HOUSE_LIST_PROC 1, 20
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_PROMOTION_HOUSE_LIST_PROC]

  @PAGE       INT
  ,@PAGESIZE  INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(2000)
  DECLARE @SQL_COUNT NVARCHAR(1000)

  SET @SQL = ''
  SET @SQL_COUNT = ''

  SET @SQL_COUNT = 'SELECT COUNT(*)
    FROM dbo.PROMOTION_HOUSE_TB
   WHERE DEL_YN = 0'

  SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
        A.IDX
        ,A.REG_TITLE
        ,A.AD_ADDRESS
        ,(SELECT COUNT(*)
              FROM dbo.PROMOTION_HOUSE_RECOM_TB AS B
             WHERE B.IDX = A.IDX) AS RECOM_CNT
        ,A.AD_TYPE
    FROM dbo.PROMOTION_HOUSE_TB AS A
   WHERE A.DEL_YN = 0
   ORDER BY A.IDX DESC'

  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_F_PROMOTION_JOB_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 구인구직 드림프로젝트 (전체회원 취업일기 조회)
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2011/10/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_PROMOTION_JOB_LIST_PROC 1, 10
 *************************************************************************************/
 
CREATE PROC [dbo].[GET_F_PROMOTION_JOB_LIST_PROC]
(
   	@Page		         INT
,   @intPageSize     SMALLINT
)

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @LIST_CNT		INT
DECLARE @SQL			NVARCHAR(4000)

SET @SQL = ' SELECT COUNT(*) 
FROM PROMOTION_JOB_TB WHERE DEL_YN = ''N''; '

SET @SQL = @SQL + 'SELECT TOP '+ CONVERT(VARCHAR(10),@Page * @intPageSize) + '
	  J.SEQ
	 ,J.USER_ID
     ,R.RESUME_ID
     ,R.OPEN_YN
     ,R.PHOTO_URL
     ,J.CONTENTS
     ,J.REG_DT
     ,R.SEX
     ,J.CUID
   FROM 
	    PROMOTION_JOB_TB AS J 
   JOIN FINDDB1.PAPER_NEW.DBO.PG_RESUME_TB AS R 
   ON R.USER_ID = J.USER_ID
	AND R.CUID = J.CUID
	 WHERE J.DEL_YN = ''N'' AND R.DEL_YN = ''N''
 ORDER BY 
	J.SEQ DESC '

SET NOCOUNT OFF

--PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_F_PROMOTION_JOB_MY_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 구인구직 드림프로젝트 (개인회원 취업일기 조회)
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2011/10/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_PROMOTION_JOB_MY_LIST_PROC 1, 10, 'findjob'
 *************************************************************************************/
 
CREATE PROC [dbo].[GET_F_PROMOTION_JOB_MY_LIST_PROC]
(
   	@Page		         INT
,   @intPageSize     SMALLINT
,	@User_ID			 VARCHAR(50)
,	@CUID			 INT
)

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @LIST_CNT		INT
DECLARE @SQL			NVARCHAR(4000)

SET @SQL = ' 
SELECT 
   COUNT(*) AS CNT
  ,S.JOB_STATUS 
FROM 
  PROMOTION_JOB_TB AS J
  LEFT JOIN PROMOTION_JOB_STATUS_TB AS S ON S.USER_ID = J.USER_ID
	WHERE
	  J.USER_ID = ''' + CONVERT(VARCHAR(50),@User_ID) + ''' AND J.CUID = ''' + CAST(@CUID as varchar) + ''' AND J.DEL_YN = ''N''
	GROUP BY S.JOB_STATUS ;'

SET @SQL = @SQL + 'SELECT TOP '+ CONVERT(VARCHAR(10),@Page * @intPageSize) +'
	  J.SEQ
	 ,J.USER_ID
	 ,R.RESUME_ID
	 ,R.OPEN_YN
	 ,R.PHOTO_URL
	 ,J.CONTENTS
	 ,ISNULL(J.MOD_DT,J.REG_DT) AS REG_DT
     ,R.SEX
     ,J.CUID
   FROM 
	  PROMOTION_JOB_TB AS J 
   JOIN FINDDB1.PAPER_NEW.DBO.PG_RESUME_TB AS R ON R.USER_ID = J.USER_ID
	  WHERE
		J.USER_ID = ''' + CONVERT(VARCHAR(50),@User_ID) + ''' AND J.CUID = ''' + CAST(@CUID as varchar) + '''  AND J.DEL_YN = ''N'' AND R.DEL_YN = ''N''
	ORDER BY 
		J.SEQ DESC '

SET NOCOUNT OFF

--PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_F_RECOMMEND_EVENT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 추천이벤트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/08
 *  수   정   자 : 김 문 화
 *  수   정   일 : 2011.11.09
 *  설        명 : 현재 진행중인 이벤트에서 추출
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_RECOMMEND_EVENT_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_RECOMMEND_EVENT_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT TOP 3
         EVENT_SEQ
        ,BANNER_ING
    FROM dbo.EV_EVENT_TB
   WHERE DEL_YN = 0 
     AND STATUS = 1
     AND CONVERT(VARCHAR(10),START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
     AND CONVERT(VARCHAR(10),END_DT,120) >= CONVERT(VARCHAR(10),GETDATE(),120)
   ORDER BY NEWID()
GO
/****** Object:  StoredProcedure [dbo].[GET_F_TVCF_PROMOTION_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : TVCF 프로모션 상세
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2014/04/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC GET_F_TVCF_PROMOTION_DETAIL_PROC 12
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_TVCF_PROMOTION_DETAIL_PROC]
  @SEQ                      VARCHAR(30)
AS

BEGIN
  SET NOCOUNT ON

  SELECT USERID
        ,EVT_PROPOSE_KIND
        ,EVT_PROPOSE_COMMENT
        ,EVT_LIKE_CNT
        ,CUID
    FROM EV_TVCF_PROMOTION_201404_TB WITH (NOLOCK)
   WHERE DEL_YN = 'N'
     AND SEQ = @SEQ
END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_TVCF_PROMOTION_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : TVCF 프로모션 리스트
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2014/04/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC GET_F_TVCF_PROMOTION_LIST_PROC '', 1, 1, '', 1, 6
 *************************************************************************************/
CREATE PROC [dbo].[GET_F_TVCF_PROMOTION_LIST_PROC]
  @SEARCHWORD               VARCHAR(30)
  ,@ORDERBY                 TINYINT       = 1
  ,@WEEKKIND                TINYINT       = 0
  ,@DEL_YN                  CHAR(1)       = ''
  ,@PAGE                    INT           = 1
  ,@PAGESIZE                INT           = 6
AS

BEGIN
  SET NOCOUNT ON

  DECLARE @SQL          NVARCHAR(4000)
  DECLARE @SQL_COUNT    NVARCHAR(4000)
  DECLARE @SQL_WHERE    NVARCHAR(4000)
  DECLARE @SQL_ORDER    NVARCHAR(4000)

  SET @SQL = ''
  SET @SQL_COUNT = ''
  SET @SQL_WHERE = ''
  SET @SQL_ORDER = ''

  -- 아이디 검색
  IF @SEARCHWORD != ''
  BEGIN
    SET @SQL_WHERE = @SQL_WHERE + ' AND USERID = ''' + @SEARCHWORD + ''' '
  END
  ELSE
  BEGIN
    -- 주차별 검색
    IF @WEEKKIND > 0
    BEGIN
      SET @SQL_WHERE = @SQL_WHERE + ' AND EVT_WEEKEND = ' + LTRIM(RTRIM(STR(@WEEKKIND)))
    END
  END 


  -- 삭제여부 검색
  IF @DEL_YN != ''
  BEGIN
    SET @SQL_WHERE = @SQL_WHERE + ' AND DEL_YN = ''' + @DEL_YN + ''' '
  END
  

  -- 정렬
  IF @ORDERBY = 1
  BEGIN
    SET @SQL_ORDER = ' REG_DT DESC, EVT_LIKE_CNT DESC '
  END
  ELSE IF @ORDERBY = 2
  BEGIN
    SET @SQL_ORDER = ' EVT_LIKE_CNT DESC, REG_DT DESC '
  END



  SET @SQL_COUNT = '
  SELECT COUNT(*) AS CNT
    FROM EV_TVCF_PROMOTION_201404_TB
   WHERE SEQ > 0
    ' + @SQL_WHERE


  SET @SQL = '
  SELECT X.SEQ
        ,X.USERID
        ,X.REG_DT
        ,X.EVT_WEEKEND
        ,X.EVT_PROPOSE_KIND
        ,X.EVT_PROPOSE_COMMENT
        ,X.EVT_LIKE_CNT
        ,X.DEL_YN
        ,X.CUID
    FROM (
          SELECT ROW_NUMBER() OVER (ORDER BY ' + @SQL_ORDER + ') AS ROWNUM
                ,SEQ
                ,USERID
                ,REG_DT
                ,EVT_WEEKEND
                ,EVT_PROPOSE_KIND
                ,EVT_PROPOSE_COMMENT
                ,ISNULL(EVT_LIKE_CNT, 0) AS EVT_LIKE_CNT
                ,DEL_YN
                ,CUID
            FROM EV_TVCF_PROMOTION_201404_TB
           WHERE SEQ > 0
            ' + @SQL_WHERE + '
         ) AS X 
   WHERE X.ROWNUM > ' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + '
     AND X.ROWNUM <= ' + CONVERT(VARCHAR(10), (@PAGE) * @PAGESIZE)

  --PRINT @SQL_COUNT
  --PRINT @SQL


  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL

END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_WININFO_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 당첨자 발표 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_WININFO_DETAIL_PROC 6
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_WININFO_DETAIL_PROC]

  @EVENT_SEQ INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 상세보기 항목
  SELECT TITLE
        ,'파인드올' PROGRESSION_SITE
        ,CONVERT(VARCHAR(10),STARTDATE,102) AS START_DT
        ,CONVERT(VARCHAR(10),ENDDATE,102) AS END_DT
        ,CONVERT(VARCHAR(10),LOTTERYDATE,102) AS ANNOUNCE_DT
        ,LOTTERY_CNT WINNER_CNT
        ,EVENT_GIFT GIVEAWAY
        ,CONTENT CONTENTS
        ,CONTENT INFO_DESC
   FROM FINDDB1.PAPER_NEW.DBO.EVENT_LOTTERY_TB 
   WHERE DEL_YN = 'N' AND LO_ID = @EVENT_SEQ;

  -- 이전목록
  SELECT TOP 1
         LO_ID EVENT_SEQ
        ,TITLE
        ,CONVERT(VARCHAR(10),STARTDATE,102) AS START_DT
        ,CONVERT(VARCHAR(10),ENDDATE,102) AS END_DT
        ,'' PUB_TYPE
        ,CONTENT CONTENTS
    FROM FINDDB1.PAPER_NEW.DBO.EVENT_LOTTERY_TB 
    WHERE DEL_YN = 'N' AND  LO_ID < @EVENT_SEQ
   ORDER BY LO_ID DESC;

  -- 다음목록
  SELECT TOP 1
         LO_ID EVENT_SEQ
        ,TITLE
        ,CONVERT(VARCHAR(10),STARTDATE,102) AS START_DT
        ,CONVERT(VARCHAR(10),ENDDATE,102) AS END_DT
        ,'' PUB_TYPE
        ,CONTENT CONTENTS
    FROM FINDDB1.PAPER_NEW.DBO.EVENT_LOTTERY_TB 
    WHERE DEL_YN = 'N' AND  LO_ID > @EVENT_SEQ
   ORDER BY LO_ID DESC;


GO
/****** Object:  StoredProcedure [dbo].[GET_F_WININFO_DETAIL_PROC_BAK180725]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 당첨자 발표 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_WININFO_DETAIL_PROC 6
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_WININFO_DETAIL_PROC_BAK180725]

  @EVENT_SEQ INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 상세보기 항목
  SELECT B.TITLE
        ,B.PROGRESSION_SITE
        ,CONVERT(VARCHAR(10),B.START_DT,102) AS START_DT
        ,CONVERT(VARCHAR(10),B.END_DT,102) AS END_DT
        ,CONVERT(VARCHAR(10),B.ANNOUNCE_DT,102) AS ANNOUNCE_DT
        ,A.WINNER_CNT
        ,A.GIVEAWAY
        ,A.CONTENTS
        ,A.INFO_DESC
    FROM EV_WIN_INFO_TB AS A
         JOIN EV_EVENT_TB AS B
           ON B.EVENT_SEQ = A.EVENT_SEQ
   WHERE A.PUB_YN = 1  
     AND A.EVENT_SEQ = @EVENT_SEQ;

  -- 이전목록
  SELECT TOP 1
         A.EVENT_SEQ
        ,B.TITLE
        ,CONVERT(VARCHAR(10),B.START_DT,102) AS START_DT
        ,CONVERT(VARCHAR(10),B.END_DT,102) AS END_DT
        ,A.PUB_TYPE
        ,A.CONTENTS
    FROM EV_WIN_INFO_TB AS A
         JOIN EV_EVENT_TB AS B
           ON B.EVENT_SEQ = A.EVENT_SEQ
   WHERE A.PUB_YN = 1  
     AND A.EVENT_SEQ < @EVENT_SEQ
   ORDER BY A.EVENT_SEQ DESC;

  -- 다음목록
  SELECT TOP 1
         A.EVENT_SEQ
        ,B.TITLE
        ,CONVERT(VARCHAR(10),B.START_DT,102) AS START_DT
        ,CONVERT(VARCHAR(10),B.END_DT,102) AS END_DT
        ,A.PUB_TYPE
        ,A.CONTENTS
    FROM EV_WIN_INFO_TB AS A
         JOIN EV_EVENT_TB AS B
           ON B.EVENT_SEQ = A.EVENT_SEQ
   WHERE A.PUB_YN = 1  
     AND A.EVENT_SEQ > @EVENT_SEQ
   ORDER BY A.EVENT_SEQ ASC
GO
/****** Object:  StoredProcedure [dbo].[GET_F_WININFO_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 당첨자 발표
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_F_WININFO_LIST_PROC 12 ,15
 
 exec GET_F_WININFO_LIST_PROC 11,15
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_WININFO_LIST_PROC]

  @PAGE INT
  ,@PAGESIZE INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

SELECT COUNT(*) AS CNT
                FROM EV_WIN_INFO_TB AS A
                     JOIN EV_EVENT_TB AS B
                       ON B.EVENT_SEQ = A.EVENT_SEQ
               WHERE A.PUB_YN = 1
					AND B.DEL_YN = 0

SELECT TOP (@PAGE * @PAGESIZE)
                     A.EVENT_SEQ
                    ,B.PROGRESSION_SITE
                    ,B.TITLE
                    ,CONVERT(VARCHAR(10),B.START_DT,102) AS START_DT
                    ,CONVERT(VARCHAR(10),B.END_DT,102) AS END_DT
                    ,CONVERT(VARCHAR(10),B.ANNOUNCE_DT,102) AS ANNOUNCE_DT
                    ,A.WINNER_CNT
                    ,A.PUB_TYPE
                    ,A.CONTENTS
                FROM EV_WIN_INFO_TB AS A
                     JOIN EV_EVENT_TB AS B
                       ON B.EVENT_SEQ = A.EVENT_SEQ
               WHERE A.PUB_YN = 1
					AND B.DEL_YN = 0
               ORDER BY B.REG_DT DESC

GO
/****** Object:  StoredProcedure [dbo].[GET_M_ALLPOINT_EVENT_CATEGORY_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트소진이벤트 > 이벤트 리스트
 *  작   성   자 : 이 경 덕 (virtualman@mediawill.com)
 *  작   성   일 : 2013/01/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_ALLPOINT_EVENT_CATEGORY_LIST_PROC 'DESC'
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ALLPOINT_EVENT_CATEGORY_LIST_PROC]

  @ORDERBY VARCHAR(10)
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(4000)


  SET @SQL = ''
  SET @SQL_COUNT = ''

  SET @SQL_COUNT = 'SELECT COUNT(*) CNT  					
					  FROM DBO.EV_EVENT_TB WITH (NOLOCK)
					 WHERE STATUS IN (1,2)
					   AND TITLE LIKE ''올 포인트%'' '

	  SET @SQL = ' SELECT EVENT_SEQ
						, TITLE
					 FROM DBO.EV_EVENT_TB WITH (NOLOCK)
					WHERE STATUS IN (1,2)
					  AND TITLE LIKE ''올 포인트%''
					ORDER BY EVENT_SEQ '+@ORDERBY
--  PRINT @SQL
--  PRINT @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_ALLPOINT_EVENT_LAST_EVENT_SEQ_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 포인트소진이벤트 > 이벤트 리스트 최근 이벤트 번호추출
 *  작   성   자 : 이 경 덕 (virtualman@mediawill.com)
 *  작   성   일 : 2013/03/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_ALLPOINT_EVENT_LAST_EVENT_SEQ_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_ALLPOINT_EVENT_LAST_EVENT_SEQ_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


SELECT TOP 1 EVENT_SEQ
  FROM DBO.EV_EVENT_TB WITH (NOLOCK)
 WHERE TITLE LIKE '올 포인트%'
   AND STATUS = 1
 ORDER BY EVENT_SEQ DESC
GO
/****** Object:  StoredProcedure [dbo].[GET_M_EVENT_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 이벤트 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/02/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_EVENT_DETAIL_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_EVENT_DETAIL_PROC]

  @EVENT_SEQ INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT PUB_LOCAL
        ,PUB_FA
        ,PUB_MAIN
        ,TITLE
        ,INTRODUCTION
        ,PUB_TYPE
        ,CONTENTS
        ,CONVERT(VARCHAR(10),START_DT,120) AS START_DT
        ,CONVERT(VARCHAR(10),END_DT,120) AS END_DT
        ,STATUS
        ,CONVERT(VARCHAR(10),ANNOUNCE_DT,120) AS ANNOUNCE_DT
        ,BANNER_ING
        ,BANNER_END
        ,BANNER_MAIN
        ,POINT_TYPE
        ,POINT_VALUE
        ,COMMENT_YN
        ,PROGRESSION_SITE
				,SURVEY
    FROM EV_EVENT_TB
   WHERE EVENT_SEQ = @EVENT_SEQ
GO
/****** Object:  StoredProcedure [dbo].[GET_M_EVENT_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 이벤트 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/02/25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_EVENT_LIST_PROC 1, 20, '', '', '', '', ''
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_EVENT_LIST_PROC]

  @PAGE       INT
  ,@PAGESIZE  INT
  ,@PUB_LOCAL CHAR(1) = ''
  ,@PUB_FA    CHAR(1) = ''
  ,@PUB_MAIN  CHAR(1) = ''
  ,@STATUS    CHAR(1) = ''
  ,@KEYWORD   VARCHAR(50) = ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(4000)
  DECLARE @WHERE_SQL NVARCHAR(200)

  SET @SQL = ''
  SET @SQL_COUNT = ''
  SET @WHERE_SQL = ''

  -- 게재지역
  IF @PUB_LOCAL <> ''
    BEGIN
      SET @WHERE_SQL = @WHERE_SQL +' AND PUB_LOCAL &'+ @PUB_LOCAL +' = '+ @PUB_LOCAL
    END

  -- FA홈 게재
  IF @PUB_FA <> ''
    BEGIN
      SET @WHERE_SQL = @WHERE_SQL +' AND PUB_FA = '+ @PUB_FA
    END

  -- 메인 게재
  IF @PUB_MAIN <> ''
    BEGIN
      SET @WHERE_SQL = @WHERE_SQL +' AND PUB_MAIN = '+ @PUB_MAIN
    END

  -- 등록상태
  IF @STATUS <> ''
    BEGIN
      SET @WHERE_SQL = @WHERE_SQL +' AND STATUS = '+ @STATUS
    END

  -- 이벤트 제목
  IF @KEYWORD <> ''
    BEGIN
      SET @WHERE_SQL = @WHERE_SQL +' AND TITLE LIKE ''%'+ @KEYWORD +'%'''
    END

  SET @SQL_COUNT = 'SELECT COUNT(*)
                      FROM dbo.EV_EVENT_TB
                     WHERE DEL_YN = 0 '+ @WHERE_SQL

  SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
                     EVENT_SEQ
                    ,CONVERT(VARCHAR(10), REG_DT, 120) AS REG_DT
                    ,TITLE
                    ,CONVERT(VARCHAR(10), START_DT, 102) AS START_DT
                    ,CONVERT(VARCHAR(10), END_DT, 102) AS END_DT
                    ,STATUS
                    ,PUB_FA
                    ,PUB_MAIN
                    ,PUB_LOCAL
                    ,HIT
                FROM dbo.EV_EVENT_TB
               WHERE DEL_YN = 0 '+ @WHERE_SQL +'
               ORDER BY EVENT_SEQ DESC'

  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_EVENT_MAIN_BANNER_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 사이버 벼룩시장 - 프론트 > 결제정보 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/05/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_EVENT_MAIN_BANNER_PROC 4, 'F'
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_EVENT_MAIN_BANNER_PROC]

  @PUB_LOCAL TINYINT
  ,@FLAG CHAR(1)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  DECLARE @SQL NVARCHAR(1000)
  DECLARE @SQL_WHERE NVARCHAR(100)
  SET @SQL = ''
  SET @SQL_WHERE = ''

  IF @FLAG = 'M'  -- 이벤트 메인 베너
    BEGIN
      SET @SQL_WHERE = 'AND PUB_MAIN = 1'
    END
  ELSE  -- 파인드올 메인 베너 ''
    BEGIN
      SET @SQL_WHERE = 'AND PUB_FA = 1'
    END

  SET @SQL = 'SELECT TOP 5
                     BANNER_ING
                    ,BANNER_END
                    ,PUB_TYPE
                    ,EVENT_SEQ
                FROM EV_EVENT_TB
               WHERE DEL_YN = 0
                 AND PUB_LOCAL &'+ CAST(@PUB_LOCAL AS VARCHAR(3)) +' = '+ CAST(@PUB_LOCAL AS VARCHAR(3)) +'
                 '+ @SQL_WHERE +'
               ORDER BY EVENT_SEQ DESC'

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_EVENTDATE_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 포인트 소진 이벤트 > 이벤트 선택 > 이벤트 기간 가져오기
 *  작   성   자 : 이 경 덕 (laplance@mediawill.com)
 *  작   성   일 : 2013/01/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC GET_M_EVENTDATE_PROC 39
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_EVENTDATE_PROC]

  @EVENTSEQ INT

AS
 DECLARE @START_DT 		AS DATETIME --이벤트 시작일
 DECLARE @END_DT 		AS DATETIME --이벤트 시작일
 DECLARE @ST_DT 		AS DATETIME --이벤트 참여 시작일
 DECLARE @ED_DT 		AS DATETIME --이벤트 참여 종료일
 DECLARE @TOTAL_POINT 	AS INT


SELECT   @START_DT  = START_DT
	   , @END_DT 	= END_DT
 FROM EV_EVENT_TB WITH (NOLOCK)
WHERE EVENT_SEQ = @EVENTSEQ

SELECT @ST_DT = MIN(REG_DT)
	 , @ED_DT = MAX(REG_DT)
FROM FINDALL_POINT.DBO.PT_EVENT_REDUCE_ENTRY_NEWYEAR_TB
WHERE EVENT_SEQ = @EVENTSEQ


SELECT @TOTAL_POINT = SUM(MY_USED_POINT)
  FROM FINDALL_POINT.DBO.PT_STATUS_TB WITH (NOLOCK)
 WHERE ITEM_SEQ IN ('A49', 'A50','A51')
   AND DT BETWEEN CONVERT(VARCHAR(10), @ST_DT,120) +' 00:00:00'
		   	  AND CONVERT(VARCHAR(10), @ED_DT,120) +' 23:59:59'

SELECT CONVERT(VARCHAR(10),@START_DT,102) AS START_DT
     , CONVERT(VARCHAR(10),@END_DT,102)   AS END_DT
 	 , ISNULL(@TOTAL_POINT,0) AS TOTAL_POINT
GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_EVENT_ING_SURVEY_GET1_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 파인드올 모바일 이벤트 최신 설문조사 1개 가져오기
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_F_EVENT_ING_SURVEY_GET1_PROC 'Y'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_EVENT_ING_SURVEY_GET1_PROC]
	@GOFLAG		CHAR(1) = ''

AS
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	IF @GOFLAG = 'Y'
	BEGIN
		SELECT TOP 1 
			  EVENT_SEQ
			, TITLE
			, BANNER_ING
			, INTRODUCTION
			, CONTENTS
			, CONVERT(VARCHAR(10),START_DT,102) AS SDT
			, CONVERT(VARCHAR(10),END_DT,102) AS EDT
			, CONVERT(VARCHAR(10),ANNOUNCE_DT,102) AS ADT
			, START_DT
			, END_DT
			, ANNOUNCE_DT
			, PUB_TYPE
		FROM EV_EVENT_TB
		WHERE DEL_YN = 0
			AND STATUS = 1
			AND CONVERT(VARCHAR(10),START_DT,120) <= CONVERT(VARCHAR(10),GETDATE(),120)
			AND CONVERT(VARCHAR(10),END_DT,120) >= CONVERT(VARCHAR(10),GETDATE(),120)
			--AND TITLE LIKE '%설문%'
			AND SURVEY = '1'
		ORDER BY REG_DT DESC
	END










GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_WININFO_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 이벤트 당첨자 발표 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_F_WININFO_LIST_PROC 1, 15, 'ALL'
 EXEC DBO.GET_M_F_WININFO_LIST_PROC_BAK01 1, 15, 'ALL'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_WININFO_LIST_PROC]
		@PAGE								INT = 1,
		@PAGESIZE						INT = 10,
		@PROGRESSION_SITE		VARCHAR(30) = 'ALL'

AS
	DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SET @WHERE = ''

	SET @SQL = '' +
	' SELECT COUNT(*) AS CNT ' +
	' FROM FINDDB1.PAPER_NEW.DBO.EVENT_LOTTERY_TB ' +
	' WHERE DEL_YN = ''N'' ' +

	' SELECT TOP ' + CONVERT(VARCHAR(10), @PAGE * @PAGESIZE) +
	' X.EVENT_SEQ, X.PROGRESSION_SITE, X.TITLE, X.START_DT, X.END_DT, X.ANNOUNCE_DT, X.WINNER_CNT, X.PUB_TYPE, X.CONTENTS ' +
	' FROM ( ' +
	' 	SELECT ' +
	' 		LO_ID EVENT_SEQ, ' +
	' 		''벼룩시장'' PROGRESSION_SITE, ' +
	' 		TITLE, ' +
	' 		STARTDATE START_DT, ' +
	' 		ENDDATE END_DT, ' +
	' 		LOTTERYDATE ANNOUNCE_DT, ' +
	' 		LOTTERY_CNT WINNER_CNT, ' +
	' 		1 PUB_TYPE, ' +
	' 		CONTENT CONTENTS, ' +
	' 		ROW_NUMBER() OVER(ORDER BY LO_ID DESC) AS ROW_NUM ' +
	'   FROM FINDDB1.PAPER_NEW.DBO.EVENT_LOTTERY_TB ' +
	'   WHERE DEL_YN = ''N'' ' + @WHERE +
	' 	) AS X ' +
	' WHERE X.ROW_NUM > (' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + ') ' +
	'	AND X.ROW_NUM <= (' + CONVERT(VARCHAR(10), ((@PAGE) * @PAGESIZE)) + ');'

	--PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_WININFO_LIST_PROC_BAK01]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 이벤트 당첨자 발표 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_F_WININFO_LIST_PROC 1, 15, 'ALL'
 EXEC DBO.GET_M_F_WININFO_LIST_PROC_BAK01 1, 15, 'ALL'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_WININFO_LIST_PROC_BAK01]
		@PAGE								INT = 1,
		@PAGESIZE						INT = 10,
		@PROGRESSION_SITE		VARCHAR(30) = 'ALL'

AS
	DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SET @WHERE = ''

	SET @SQL = '' +
	' SELECT COUNT(*) AS CNT ' +
	' FROM FINDDB1.PAPER_NEW.DBO.EVENT_LOTTERY_TB ' +
	' WHERE DEL_YN = ''N'' ' +

	' SELECT TOP ' + CONVERT(VARCHAR(10), @PAGE * @PAGESIZE) +
	' X.EVENT_SEQ, X.PROGRESSION_SITE, X.TITLE, X.START_DT, X.END_DT, X.ANNOUNCE_DT, X.WINNER_CNT, X.PUB_TYPE, X.CONTENTS ' +
	' FROM ( ' +
	' 	SELECT ' +
	' 		LO_ID EVENT_SEQ, ' +
	' 		''벼룩시장'' PROGRESSION_SITE, ' +
	' 		TITLE, ' +
	' 		STARTDATE START_DT, ' +
	' 		ENDDATE END_DT, ' +
	' 		LOTTERYDATE ANNOUNCE_DT, ' +
	' 		LOTTERY_CNT WINNER_CNT, ' +
	' 		1 PUB_TYPE, ' +
	' 		CONTENT CONTENTS, ' +
	' 		ROW_NUMBER() OVER(ORDER BY LO_ID DESC) AS ROW_NUM ' +
	'   FROM FINDDB1.PAPER_NEW.DBO.EVENT_LOTTERY_TB ' +
	'   WHERE DEL_YN = ''N'' ' + @WHERE +
	' 	) AS X ' +
	' WHERE X.ROW_NUM > (' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + ') ' +
	'	AND X.ROW_NUM <= (' + CONVERT(VARCHAR(10), ((@PAGE) * @PAGESIZE)) + ');'

	--PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_F_WININFO_LIST_PROC_BAK180720]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일 이벤트 당첨자 발표 리스트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/01/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_F_WININFO_LIST_PROC 1, 15, 'ALL'
 EXEC DBO.GET_M_F_WININFO_LIST_PROC_BAK01 1, 15, 'ALL'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_F_WININFO_LIST_PROC_BAK180720]
		@PAGE								INT = 1,
		@PAGESIZE						INT = 10,
		@PROGRESSION_SITE		VARCHAR(30) = 'ALL'

AS
	DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SET @WHERE = ''

	SET @SQL = '' +
	' SELECT COUNT(*) AS CNT ' +
	' FROM FINDDB1.PAPER_NEW.DBO.EVENT_LOTTERY_TB ' +
	' WHERE DEL_YN = ''N'' ' +

	' SELECT TOP ' + CONVERT(VARCHAR(10), @PAGE * @PAGESIZE) +
	' X.EVENT_SEQ, X.PROGRESSION_SITE, X.TITLE, X.START_DT, X.END_DT, X.ANNOUNCE_DT, X.WINNER_CNT, X.PUB_TYPE, X.CONTENTS ' +
	' FROM ( ' +
	' 	SELECT ' +
	' 		LO_ID EVENT_SEQ, ' +
	' 		''벼룩시장'' PROGRESSION_SITE, ' +
	' 		TITLE, ' +
	' 		STARTDATE START_DT, ' +
	' 		ENDDATE END_DT, ' +
	' 		LOTTERYDATE ANNOUNCE_DT, ' +
	' 		LOTTERY_CNT WINNER_CNT, ' +
	' 		1 PUB_TYPE, ' +
	' 		CONTENT CONTENTS, ' +
	' 		ROW_NUMBER() OVER(ORDER BY LO_ID DESC) AS ROW_NUM ' +
	'   FROM FINDDB1.PAPER_NEW.DBO.EVENT_LOTTERY_TB ' +
	'   WHERE DEL_YN = ''N'' ' + @WHERE +
	' 	) AS X ' +
	' WHERE X.ROW_NUM > (' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + ') ' +
	'	AND X.ROW_NUM <= (' + CONVERT(VARCHAR(10), ((@PAGE) * @PAGESIZE)) + ');'

	--PRINT @SQL
	EXECUTE SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[GET_M_PROMOTION_HOUSE_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프로모션(2011.11) > 응모 상세보기(관리자)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/10/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_PROMOTION_HOUSE_DETAIL_PROC 1
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_PROMOTION_HOUSE_DETAIL_PROC]

  @IDX           INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 내용가져오기
  SELECT USERID
        ,ADID
        ,AD_TYPE
        ,AD_CATEGORY_NM
        ,AD_ADDRESS
        ,AD_PRICE_JUN
        ,AD_PRICE_BO
        ,AD_PRICE_WOL
        ,ETC_CONTENTS
        ,REG_NAME
        ,REG_PHONE
        ,REG_TITLE
        ,REG_CONTENTS
        ,(SELECT COUNT(*)
              FROM dbo.PROMOTION_HOUSE_RECOM_TB
             WHERE IDX = @IDX) AS RECOM_CNT
        ,HIT
        ,REG_DT
        ,CUID
    FROM dbo.PROMOTION_HOUSE_TB
   WHERE IDX = @IDX
GO
/****** Object:  StoredProcedure [dbo].[GET_M_PROMOTION_HOUSE_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프로모션(2011.11) > 응모 상세보기(관리자)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/10/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_PROMOTION_HOUSE_LIST_PROC 1, 20, '','','','',''
 *************************************************************************************/

CREATE PROC [dbo].[GET_M_PROMOTION_HOUSE_LIST_PROC]

  @PAGE       INT
  ,@PAGESIZE  INT

  ,@SCH_START_DT    VARCHAR(10)
  ,@SCH_END_DT   VARCHAR(10)
  ,@SCH_FIELD    VARCHAR(20)
  ,@SCH_KEYWORD  VARCHAR(50)  = ''
  ,@RECOM_SORT   VARCHAR(5)   = ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(2000)
  DECLARE @WHERE_SQL NVARCHAR(1000)
  DECLARE @ORDER_SQL NVARCHAR(500)

  SET @SQL = ''
  SET @SQL_COUNT = ''
  SET @WHERE_SQL = ''
  SET @ORDER_SQL = 'A.IDX DESC'

  -- 등록일 조회
  IF @SCH_START_DT <> '' AND @SCH_END_DT <> ''
    BEGIN
      SET @WHERE_SQL = @WHERE_SQL + ' AND A.REG_DT BETWEEN '''+ @SCH_START_DT +''' AND '''+ @SCH_END_DT +''''
    END

  -- 키워드 조회
  IF @SCH_KEYWORD <> ''
    BEGIN
      IF @SCH_FIELD = 'IDX'
        BEGIN
          SET @WHERE_SQL = @WHERE_SQL + ' AND A.IDX = '+ @SCH_KEYWORD +''
        END
      ELSE
        BEGIN
          SET @WHERE_SQL = @WHERE_SQL + ' AND A.'+ @SCH_FIELD +' LIKE ''%'+ @SCH_KEYWORD +'%'''
        END
    END

  -- 추천수 정렬
  IF @RECOM_SORT <> ''
    SET @ORDER_SQL = 'RECOM_CNT '+ @RECOM_SORT

  SET @SQL_COUNT = 'SELECT COUNT(*)
    FROM dbo.PROMOTION_HOUSE_TB AS A
   WHERE 1 = 1 '+ @WHERE_SQL

  SET @SQL = 'SELECT  TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
        A.IDX
        ,CONVERT(VARCHAR(10),A.REG_DT,120) AS REG_DT
        ,A.USERID
        ,A.REG_NAME
        ,A.AD_ADDRESS
        ,A.REG_PHONE
        ,(SELECT COUNT(*)
              FROM dbo.PROMOTION_HOUSE_RECOM_TB AS B
             WHERE B.IDX = A.IDX) AS RECOM_CNT
        ,A.HIT
        ,A.AD_TYPE
        ,A.ADID
        ,A.DEL_YN
        ,CONVERT(VARCHAR(10),B.JOIN_DT,120) AS JOIN_DT
        ,A.CUID
    FROM dbo.PROMOTION_HOUSE_TB AS A
    JOIN MEMBER.dbo.MM_MEMBER_TB AS B
      ON B.USERID = A.USERID
   WHERE 1 = 1 '+ @WHERE_SQL +'
   ORDER BY '+ @ORDER_SQL

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_PROMOTION_JOB_COUNT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 구인구직 드림프로젝트 (등록현황 조회)
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2011/12/05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_PROMOTION_JOB_COUNT_PROC '2011-10-01', '2011-10-30'
 *************************************************************************************/
 
CREATE PROC [dbo].[GET_M_PROMOTION_JOB_COUNT_PROC]
(
	@StartDate		 VARCHAR(10)
,	@EndDate		 VARCHAR(10)
)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

--전체
SELECT COUNT(*) AS TOTAL_MEMBER
FROM dbo.PROMOTION_JOB_TB
WHERE DEL_YN = 'N'
AND REG_DT > @StartDate AND REG_DT < CONVERT(VARCHAR(10),DATEADD(DAY, 1, @EndDate),121)

--신규
SELECT COUNT(*) AS NEW_MEMBER
FROM dbo.PROMOTION_JOB_TB AS P
JOIN MEMBER.DBO.MM_MEMBER_TB AS M
ON P.USER_ID = M.USERID
	AND P.CUID = M.CUID
WHERE P.DEL_YN='N'
AND P.REG_DT > @StartDate AND P.REG_DT < CONVERT(VARCHAR(10),DATEADD(DAY, 1, @EndDate),121)
AND M.JOIN_DT > @StartDate AND M.JOIN_DT < CONVERT(VARCHAR(10),DATEADD(DAY, 1, @EndDate),121)

--기존
SELECT COUNT(*) AS OLD_MEMBER
FROM dbo.PROMOTION_JOB_TB AS P
JOIN MEMBER.DBO.MM_MEMBER_TB AS M
ON P.USER_ID = M.USERID
WHERE P.DEL_YN='N'
AND (M.JOIN_DT < @StartDate OR M.JOIN_DT > CONVERT(VARCHAR(10),DATEADD(DAY, 1, @EndDate),121))
AND P.REG_DT > @StartDate 
AND P.REG_DT < CONVERT(VARCHAR(10),DATEADD(DAY, 1, @EndDate),121)
GO
/****** Object:  StoredProcedure [dbo].[GET_M_PROMOTION_JOB_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 구인구직 드림프로젝트 (전체회원 조회)
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2011/10/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_PROMOTION_JOB_LIST_PROC 1, 10, '2011-10-01', '2011-10-30', '', '', '' 
 *************************************************************************************/
 
CREATE PROC [dbo].[GET_M_PROMOTION_JOB_LIST_PROC]
(
   	@Page		         INT
,   @intPageSize     SMALLINT
,	@StartDate		 VARCHAR(10)
,	@EndDate		 VARCHAR(10)
,	@Job_Status		 CHAR(1)
,   @Keyfield		 VARCHAR(10)
,   @Keyword		 VARCHAR(100)
)

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @LIST_CNT		INT
DECLARE @CNT_SQL		NVARCHAR(4000)
DECLARE @SQL			NVARCHAR(4000)
DECLARE @WHERE_SQL		NVARCHAR(4000)

SET @CNT_SQL = 'SELECT COUNT(*) AS LIST_CNT
   FROM 
	    PROMOTION_JOB_TB AS J
   JOIN PROMOTION_JOB_STATUS_TB AS S ON S.USER_ID = J.USER_ID
   JOIN FINDDB2.MEMBER.DBO.MM_MEMBER_TB AS M ON M.USERID = J.USER_ID '

SET @WHERE_SQL = 'WHERE 1=1 '

IF @StartDate <> ''
BEGIN
  SET @WHERE_SQL = @WHERE_SQL + ' AND J.REG_DT >= ''' + @StartDate + ''''
END

IF @EndDate <> ''
BEGIN
  SET @WHERE_SQL = @WHERE_SQL + ' AND J.REG_DT <= ''' + CONVERT(VARCHAR(10),DATEADD(DAY, 1, @EndDate),121) + ''''
END

IF @Job_Status <> ''
BEGIN
  SET @WHERE_SQL = @WHERE_SQL + ' AND S.JOB_STATUS = ''' + @Job_Status + ''''
END

IF @Keyword <> ''
BEGIN
  IF @Keyfield = 'ID'  
  BEGIN 
    SET @WHERE_SQL = @WHERE_SQL + ' AND J.USER_ID LIKE ''%' + @Keyword + '%'''
  END
  ELSE IF @Keyfield = 'NAME'  
  BEGIN 
    SET @WHERE_SQL = @WHERE_SQL + ' AND M.USERNAME LIKE ''%' + @Keyword + '%'''
  END
  ELSE
  BEGIN
	SET @WHERE_SQL = @WHERE_SQL + ' AND M.HPHONE LIKE ''%' + @Keyword + '%'''
  END
END

SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@Page * @intPageSize) + '
	  J.REG_DT
	 ,J.USER_ID
     ,M.USERNAME
     ,CASE S.JOB_STATUS WHEN 0 THEN ''취업준비'' ELSE ''취업성공'' END AS JOB_STATUS
     ,M.HPHONE
     ,(
       SELECT COUNT(*) FROM PROMOTION_JOB_TB AS A
	    JOIN PROMOTION_JOB_STATUS_TB AS S ON S.USER_ID = A.USER_ID
	    JOIN FINDDB2.MEMBER.DBO.MM_MEMBER_TB AS M ON M.USERID = A.USER_ID
	     WHERE A.USER_ID = J.USER_ID AND A.DEL_YN = ''N''
	   ) AS REG_CNT
	 , (
		SELECT COUNT(*) 
	     FROM FINDDB1.PAPER_NEW.DBO.LOG_SMS_TB 
	      WHERE SND_NO = M.HPHONE
		) AS SMS_CNT
	 ,CASE J.DEL_YN WHEN ''Y'' THEN ''삭제'' ELSE ''&nbsp;'' END AS DEL_YN 
	 ,J.CUID
   FROM 
	    PROMOTION_JOB_TB AS J
   JOIN PROMOTION_JOB_STATUS_TB AS S ON S.USER_ID = J.USER_ID
   JOIN FINDDB2.MEMBER.DBO.MM_MEMBER_TB AS M ON M.USERID = J.USER_ID '

SET @CNT_SQL = @CNT_SQL + @WHERE_SQL
SET @SQL = @SQL + @WHERE_SQL + 'ORDER BY J.REG_DT DESC'

SET NOCOUNT OFF

--PRINT @CNT_SQL
--PRINT @WHERE_SQL
--PRINT @SQL
EXECUTE SP_EXECUTESQL @CNT_SQL
EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_M_WININFO_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 당첨안내 상세보기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/02/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_WININFO_DETAIL_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_WININFO_DETAIL_PROC]

  @EVENT_SEQ INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT B.TITLE
        ,CONVERT(VARCHAR(10),B.START_DT,120) AS START_DT
        ,CONVERT(VARCHAR(10),B.END_DT,120) AS END_DT
        ,CONVERT(VARCHAR(10),B.ANNOUNCE_DT,120) AS ANNOUNCE_DT
        ,A.WINNER_CNT
        ,A.GIVEAWAY
        ,A.PUB_TYPE
        ,A.CONTENTS
        ,A.INFO_DESC
        ,B.PROGRESSION_SITE
        ,A.PUB_YN
    FROM EV_WIN_INFO_TB AS A
         JOIN EV_EVENT_TB AS B
           ON B.EVENT_SEQ = A.EVENT_SEQ
   WHERE A.EVENT_SEQ = @EVENT_SEQ
GO
/****** Object:  StoredProcedure [dbo].[GET_M_WININFO_LIST_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 당첨안내 리스트
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/02/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_WININFO_LIST_PROC 1, 20, '', '', ''
 *************************************************************************************/


CREATE PROC [dbo].[GET_M_WININFO_LIST_PROC]

  @PAGE       INT
  ,@PAGESIZE  INT
  ,@START_DT  VARCHAR(10) = ''
  ,@END_DT    VARCHAR(10) = ''
  ,@KEYWORD   VARCHAR(50) = ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_COUNT NVARCHAR(4000)
  DECLARE @WHERE_SQL NVARCHAR(200)

  SET @SQL = ''
  SET @SQL_COUNT = ''
  SET @WHERE_SQL = ''

  -- 등록상태
  IF @START_DT <> '' AND @END_DT <> ''
    BEGIN
      SET @WHERE_SQL = @WHERE_SQL +' AND B.START_DT >= '''+ @START_DT +''' AND B.END_DT <= '''+ @END_DT +''''
    END

  -- 이벤트 제목
  IF @KEYWORD <> ''
    BEGIN
      SET @WHERE_SQL = @WHERE_SQL +' AND B.TITLE LIKE ''%'+ @KEYWORD +'%'''
    END

  SET @SQL_COUNT = 'SELECT COUNT(*)
                      FROM dbo.EV_WIN_INFO_TB AS A
                           JOIN dbo.EV_EVENT_TB AS B
                             ON B.EVENT_SEQ = A.EVENT_SEQ
                     WHERE DEL_YN = 0 '+ @WHERE_SQL

  SET @SQL = 'SELECT TOP '+ CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +'
                     A.EVENT_SEQ
                    ,B.PROGRESSION_SITE
                    ,B.TITLE
                    ,CONVERT(VARCHAR(10),B.START_DT,102) AS START_DT
                    ,CONVERT(VARCHAR(10),B.END_DT,102) AS END_DT
                    ,CONVERT(VARCHAR(10),B.ANNOUNCE_DT,102) AS ANNOUNCE_DT
                    ,A.WINNER_CNT
                    ,B.HIT
                FROM dbo.EV_WIN_INFO_TB AS A
                     JOIN dbo.EV_EVENT_TB AS B
                       ON B.EVENT_SEQ = A.EVENT_SEQ
               WHERE B.DEL_YN = 0 '+ @WHERE_SQL +'
               ORDER BY A.EVENT_SEQ DESC'

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL_COUNT
  EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_SAMSUNG_EVENT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
*객체이름 : 삼성전자 이벤트 xml 제공
*파라미터 : 	
*제작자 : 권준호
*버젼 :
*제작일 : 2013.07.05
*변경일 :
*그외 : 
*실행예제 : exec GET_SAMSUNG_EVENT_PROC
****************************************************************************************************/

CREATE PROCEDURE [dbo].[GET_SAMSUNG_EVENT_PROC]

AS
	set nocount on
	set ANSI_NULLS ON
	set QUOTED_IDENTIFIER ON
BEGIN

	SELECT  A.userid
	,		A.CI
	,		A.regdt
	,		B.username
	,		B.hphone
	,		B.juminno_a
	,		B.email
	,		A.senddate
	,		(select COUNT(*) from EVENT.dbo.EV_SAMSUNG_TB) as TOTALCOUNT
	,		A.CUID
	FROM	EVENT.dbo.EV_SAMSUNG_TB A
	JOIN	MEMBER.dbo.MM_MEMBER_TB B
	ON		A.userid = B.userid

	ORDER   BY A.seq DESC	
	
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_AREAINTEREST]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 모바일 개편 오픈 이벤트
 *  작   성   자 : 최승범
 *  작   성   일 : 2017/07/10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 :  PUT_EV_AREAINTEREST '','','','','',1234,'123123'
*************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_EV_AREAINTEREST]
@Area1				VARCHAR(25)		= ''
,@Area2				VARCHAR(25)		= ''
,@Area3				VARCHAR(25)		= ''
,@sectioncd			INT				= 0
,@lyApply			INT				= 0  
,@cuid				INT				= 0  
,@HP					VARCHAR(20)     = ''

AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
	
	DECLARE @ATTENDANCE_COUNT	INT = 0 
	
	IF CONVERT(VARCHAR(10), GETDATE(), 120) >= '2017-08-01'
	BEGIN
		RETURN 2
	END
	ELSE
	BEGIN
	
		SELECT @ATTENDANCE_COUNT = COUNT(*)
		FROM EV_AREAINTEREST
		WHERE CUID = @cuid
		
		IF @ATTENDANCE_COUNT > 0	
		BEGIN
			RETURN 1
		END
		Else
		BEGIN
			
			INSERT INTO EV_AREAINTEREST (CUID,AREA1,AREA2,AREA3,SECTIONCD,lyApply,HP) VALUES (@cuid, @Area1, @Area2, @Area3, @sectioncd, @lyApply, @HP)
			RETURN 0
			
		END
		
	END
	
END



GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_INITIAL]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 초성 이벤트
 *  작   성   자 : 백규원
 *  작   성   일 : 2017/10/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : EV_INITIAL_TB
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC PUT_EV_INITIAL '123123', '명박이', '홍길동', '01023234545', 'wb', '127.0.0.1', 'IOS'
*************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_EV_INITIAL]
		@CUID							INT						= 0
	, @INITIAL					VARCHAR(12)		= ''
	, @USERNAME					VARCHAR(25)		= ''
	, @HP								VARCHAR(20)		= ''
	, @ROUTE_CHANNEL		VARCHAR(2)		= ''
	, @IP_ADDR					VARCHAR(15)		= ''
	, @DEVICE						VARCHAR(20)		= ''
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @ATTENDANCE_COUNT_HP			INT = 0
	DECLARE @ATTENDANCE_COUNT_CUID		INT = 0

	IF CONVERT(VARCHAR(10), GETDATE(), 120) >= '2017-11-13'
	BEGIN
		RETURN 2
	END
	ELSE
	BEGIN
		SELECT @ATTENDANCE_COUNT_HP = COUNT(*)
		FROM EV_INITIAL_TB
		WHERE HP = @HP

		/*
		IF @ATTENDANCE_COUNT_HP < 1
		BEGIN
			IF @CUID > 0
			BEGIN
				SELECT @ATTENDANCE_COUNT_CUID = COUNT(*)
				FROM EV_INITIAL_TB
				WHERE (CUID != 0 OR CUID != '')
					AND CUID = @CUID
			END
		END
		*/

		IF @ATTENDANCE_COUNT_HP > 0
		BEGIN
			RETURN 3
		END
		/*
		ELSE IF @ATTENDANCE_COUNT_CUID > 0
		BEGIN
			RETURN 1
		END
		*/
		ELSE
		BEGIN
			INSERT INTO EV_INITIAL_TB (CUID, INITIAL, USERNAME, HP, ROUTE_CHANNEL, IP_ADDR, DEVICE)
			VALUES (@CUID, @INITIAL, @USERNAME, @HP, @ROUTE_CHANNEL, @IP_ADDR, @DEVICE)
			RETURN 0
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_JOB_NEWDOWNLOAD_TB_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 신규다운로드기념이벤트
 *  작   성   자 : 조 재 성
 *  작   성   일 : 2016/11/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC PUT_EV_JOB_NEWDOWNLOAD_TB_PROC '조재성','01087798662'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_EV_JOB_NEWDOWNLOAD_TB_PROC]
(
	@USERNAME varchar(25),
	@CELLPHONE varchar(20)
)
AS
BEGIN

	SET NOCOUNT ON

	IF EXISTS (SELECT * FROM EV_JOB_NEWDOWNLOAD_20161108_TB WITH(NOLOCK) WHERE CELLPHONE=@CELLPHONE)
	BEGIN
		RETURN 1
	END
	ELSE
	BEGIN
		INSERT INTO EV_JOB_NEWDOWNLOAD_20161108_TB (USERNAME,CELLPHONE) VALUES (@USERNAME,@CELLPHONE)
		RETURN 0
	END
	

END



GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_JOBRENEW_201309_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 이벤트 > 구인개편 이벤트
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013/09/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 구인개편 이벤트
 *  사 용  예 제 : EXEC DBO.PUT_EV_JOBRENEW_201309_PROC 'SEBILIA'
 *************************************************************************************/
CREATE PROC [dbo].[PUT_EV_JOBRENEW_201309_PROC]
       @USERID    VARCHAR(50)
     , @ARG       INT
     , @CUID	  INT = NULL
AS

SET NOCOUNT ON       

IF EXISTS (SELECT * FROM EV_JOBRENEW_201309_TB WITH (NOLOCK) 
            WHERE EVT_DT=CONVERT(VARCHAR(10),GETDATE(),111) 
              AND USERID = @USERID
              AND CUID = @CUID
              )       
BEGIN
    --'1일 1회만 참여가능합니다.내일 다시 참여해 주세요.'
    RETURN (100)
END

INSERT EV_JOBRENEW_201309_TB
     ( EVT_DT, USERID, ARG,CUID )
VALUES
     ( CONVERT(VARCHAR(10),GETDATE(),111) , @USERID, @ARG,@CUID)
--응모가 완료되었습니다.     
RETURN (0)
GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_MOBILE_ATTENDANCE_PROMOTION_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 출석체크이벤트 
 *  작   성   자 : 최승범
 *  작   성   일 : 2016/09/09
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC PUT_EV_MOBILE_ATTENDANCE_PROMOTION_PROC 111113, 'kkam1234', 2, '111.1111.1111'
 select * FROm 
 If @TYPE = 1	-- 총 출책 카운트
  Return valuse : ATTENDANCE_COUNT(해당 회원의 총 출책 카운트), FIRST_WIN(1일차 출책 당첨 여부 0:False 1:True )
 If @TYPE = 2	-- 출책 처리
  Return valuse : ATTEND_SUCCESS(출책성공여부 True, False), ATTENDANCE_COUNT(해당 회원의 총 출책 카운트), FIRST_WIN( 1회차 출책 당첨여부 0:False 1:True )
	
*************************************************************************************/
CREATE PROC [dbo].[PUT_EV_MOBILE_ATTENDANCE_PROMOTION_PROC]
  
  @CUID				INT				= NULL
, @USERID           VARCHAR(50)     = ''
, @TYPE				INT				= NULL		--1: 총 출책 카운트 2: 출책 처리
, @IP				VARCHAR(20)		= NULL

AS 
  
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON
  
  DECLARE @TODAY_ATTENDANCE_COUNT INT = 0 			-- 해당 회원의 오늘 출첵 COUNT
  DECLARE @TOTAL_ATTENDANCE_COUNT INT = 0 			-- 해당 회원의 전체 출첵 COUNT
  DECLARE @TODAY_TOTAL_ATTENDANCE_COUNT INT = 0 	-- 오늘 처음 출첵한 회원들의 TOTAL COUNT
  DECLARE @TODAY VARCHAR(10)		= CONVERT(VARCHAR(10), GETDATE(), 120)
  DECLARE @MAXCOUNT INT				= 140	-- 평일 당첨 인원 * 4 35명? (주말은 25명)
  
  IF @TYPE = 1			-- 총 출책 카운트
  BEGIN
	--// 총출책 카운트, 1일차 출책 당첨 여부(0:False 1:True) ==========================
	SELECT COUNT(*) AS ATTENDANCE_COUNT, ISNULL(MAX(FIRST_WIN),0) AS FIRST_WIN	
	  FROM EV_MOBILE_ATTENDANCE_PROMOTION_TB
	 WHERE CUID = @CUID
	--//================================================================================
  
  END
  ELSE IF @TYPE = 2		-- 출책 처리
  BEGIN
	
	--// 오늘 출책 COUNT ============================================

	SELECT	 @TOTAL_ATTENDANCE_COUNT = COUNT(*)
			,@TODAY_ATTENDANCE_COUNT = SUM(CASE WHEN CONVERT(VARCHAR(10), REG_DT, 120) = @TODAY THEN 1 ELSE 0 END )
	  FROM EV_MOBILE_ATTENDANCE_PROMOTION_TB
	 WHERE CUID = @CUID

	--//=============================================================
	  
	IF @TODAY_ATTENDANCE_COUNT > 0	-- 오늘 출첵을 했다면(중복 참여)
	BEGIN
		--SELECT 'False' AS ATTEND_SUCCESS, 0 AS ATTENDANCE_COUNT, 0 AS FIRST_WIN	-- ATTEND_SUCCESS:출책성공여부, ATTENDANCE_COUNT:전체출책Count, FIRST_WIN:1회차 출책 당첨여부(0:False 1:True)
		SELECT 'False' AS ATTEND_SUCCESS, COUNT(*) AS ATTENDANCE_COUNT, ISNULL(MAX(FIRST_WIN),0) AS FIRST_WIN	-- ATTEND_SUCCESS:출책성공여부, ATTENDANCE_COUNT:전체출책Count, FIRST_WIN:1회차 출책 당첨여부(0:False 1:True)
		  FROM EV_MOBILE_ATTENDANCE_PROMOTION_TB
		 WHERE CUID = @CUID
	END
	ELSE							-- 오늘 첫 출첵이면
	BEGIN
		
		IF @TOTAL_ATTENDANCE_COUNT = 0	-- 첫 출책이면
		BEGIN
			--// 오늘 처음 출책한 회원들의 TOTAL COUNT =================
			SELECT @TODAY_TOTAL_ATTENDANCE_COUNT = COUNT(*)
			  FROM EV_MOBILE_ATTENDANCE_PROMOTION_TB
			 WHERE CONVERT(VARCHAR(10), REG_DT, 120) = @TODAY
			   AND FIRST_JOIN = 1
			   
			--//========================================================
			IF DATEPART(DW, GETDATE()) IN (1, 7)  --토,일은 25명만?
				SET @MAXCOUNT = 100
			
			-- 첫 출책 이벤트 당첨자 이면
--			IF @TODAY_TOTAL_ATTENDANCE_COUNT IN (3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63, 67, 71, 75, 79, 83, 87, 91, 95, 99)
			IF (@TODAY_TOTAL_ATTENDANCE_COUNT + 1) % 4 = 0 and @TODAY_TOTAL_ATTENDANCE_COUNT < @MAXCOUNT
				INSERT INTO EV_MOBILE_ATTENDANCE_PROMOTION_TB (CUID, USER_ID, FIRST_JOIN, FIRST_WIN, USER_IP) VALUES (@CUID, @USERID, 1, 1, @IP)
			ELSE	
			-- 첫 출책 이벤트 당첨자가 아니면
				INSERT INTO EV_MOBILE_ATTENDANCE_PROMOTION_TB (CUID, USER_ID, FIRST_JOIN, FIRST_WIN, USER_IP) VALUES (@CUID, @USERID, 1, 0, @IP)
		END
		ELSE							-- 첫 출책이 아니면
		BEGIN
			INSERT INTO EV_MOBILE_ATTENDANCE_PROMOTION_TB (CUID, USER_ID, FIRST_JOIN, FIRST_WIN, USER_IP)
			VALUES (@CUID, @USERID, 0, 0, @IP)
		END
		
		SELECT 'True' AS ATTEND_SUCCESS, COUNT(*) AS ATTENDANCE_COUNT, ISNULL(MAX(FIRST_WIN),0) AS FIRST_WIN	-- ATTEND_SUCCESS:출책성공여부, ATTENDANCE_COUNT:전체출책Count, FIRST_WIN:1회차 출책 당첨여부(0:False 1:True)
		  FROM EV_MOBILE_ATTENDANCE_PROMOTION_TB
		 WHERE CUID = @CUID
	 
	END
	
  END
END
	


GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_MOBILE_ATTENDANCE_PROMOTION_PROC2]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 모바일결제 오픈 프로모션 
 *  작   성   자 : 최승범
 *  작   성   일 : 2016/10/10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC PUT_EV_MOBILE_ATTENDANCE_PROMOTION_PROC2 111113, 'kkam1234', '111.1111.1111'

 Return valuse : (해당 회원의 출책 여부 0:중복출책, 1:출책성공), (당첨선물여부 0:미당첨(출책) 1:오로나민C 2:백화점상품권 3:미당첨(중복출책))	
 
*************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_EV_MOBILE_ATTENDANCE_PROMOTION_PROC2]
	-- Add the parameters for the stored procedure here
  @CUID				INT				= NULL
, @USERID           VARCHAR(50)     = ''
, @IP				VARCHAR(20)		= NULL

AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
  
	DECLARE @TODAY_ATTENDANCE_COUNT	INT = 0 			-- 해당 회원의 오늘 출첵 COUNT
	DECLARE @TODAY_TOTAL_ATTENDANCE_COUNT INT = 0 		-- 오늘 출책한 회원들의 TOTAL COUNT
	DECLARE @TOTAL_WIN_COUNT INT = 0 					-- 해당 회원의 당첨 COUNT
	DECLARE @TODAY VARCHAR(10)			= CONVERT(VARCHAR(10), GETDATE(), 120)
	DECLARE @MAXCOUNT1 INT				= 200		-- 첫날 당첨인원 *5 40개 오로나민 당첨 인원
	DECLARE @MAXCOUNT INT							-- 당첨인원
	DECLARE @MAXCOUNT2 INT				= 104		-- 104개 오로나민
	DECLARE @STODAY VARCHAR(10)			= '2016-10-17'
	
	IF @TODAY > '2016-11-06'	--이벤트 종료일
	BEGIN
		SELECT '4' AS Result
	END
	ELSE
	BEGIN
		--// 출책 회원의 오늘 출책 COUNT ============================================
		SELECT @TODAY_ATTENDANCE_COUNT = COUNT(*)
		  FROM EV_MOBILE_ATTENDANCE_PROMOTION_TB2
		 WHERE REG_DT = @TODAY AND CUID = @CUID
		 
		IF @TODAY_ATTENDANCE_COUNT > 0	-- 오늘 출첵을 했다면(중복 참여)
		BEGIN
			SELECT '3' AS Result
		END
		ELSE							-- 오늘 첫 출첵이면
		BEGIN
			
			--// 출책 회원의 전체 당첨내역 COUNT ============================================
			SELECT @TOTAL_WIN_COUNT = COUNT(*)
			  FROM EV_MOBILE_ATTENDANCE_PROMOTION_TB2
			 WHERE CUID = @CUID AND WIN > 0
			 
			IF @TOTAL_WIN_COUNT > 0			-- 해당 회원이 당첨 내역이 있다면
			BEGIN
				INSERT INTO EV_MOBILE_ATTENDANCE_PROMOTION_TB2 (CUID, USER_ID, WIN, USER_IP) VALUES (@CUID, @USERID, 0, @IP)
				SELECT '0' AS Result
			END
			ELSE							-- 당첨내역이 없다면
			BEGIN
				
				--// 오늘 출책한 회원들의 TOTAL COUNT =================
				SELECT @TODAY_TOTAL_ATTENDANCE_COUNT = COUNT(*)
				  FROM EV_MOBILE_ATTENDANCE_PROMOTION_TB2
				 WHERE REG_DT = @TODAY
				--SELECT @TODAY_TOTAL_ATTENDANCE_COUNT = COUNT(*) 
				--FROM [EVENT].[dbo].[EV_MOBILE_ATTENDANCE_PROMOTION_TB2]
				--WHERE REG_DT = @TODAY  
				--AND CUID NOT IN (SELECT CUID FROM [EVENT].[dbo].[EV_MOBILE_ATTENDANCE_PROMOTION_TB2] WHERE WIN > 0) 
				
				SELECT @MAXCOUNT = COUNT(*)
				  FROM EV_MOBILE_ATTENDANCE_PROMOTION_TB2
				 WHERE REG_DT = @TODAY AND WIN = 1

				IF  @TODAY = @STODAY	--이벤트 첫날이면
				BEGIN
					IF (@TODAY_TOTAL_ATTENDANCE_COUNT + 1) % 2 = 0 and @MAXCOUNT < @MAXCOUNT2
					BEGIN
						-- 이벤트 당첨자 이면
						INSERT INTO EV_MOBILE_ATTENDANCE_PROMOTION_TB2 (CUID, USER_ID, WIN, USER_IP) VALUES (@CUID, @USERID, 1, @IP)
						SELECT '1' AS Result
					END
					ELSE	
					BEGIN
						-- 이벤트 당첨자가 아니면
						INSERT INTO EV_MOBILE_ATTENDANCE_PROMOTION_TB2 (CUID, USER_ID, WIN, USER_IP) VALUES (@CUID, @USERID, 0, @IP)
						SELECT '0' AS Result
					END
				END
				ELSE					--이벤트 첫날이 아니면
				BEGIN
					IF (@TODAY_TOTAL_ATTENDANCE_COUNT + 1) % 2 = 0 and @MAXCOUNT < @MAXCOUNT2
					BEGIN
						-- 이벤트 당첨자 이면
						IF (@TODAY_TOTAL_ATTENDANCE_COUNT + 1) IN (30,60,90,120,150,180,210,240,270,300)	-- 백화점 상품권 당첨자
						BEGIN
							INSERT INTO EV_MOBILE_ATTENDANCE_PROMOTION_TB2 (CUID, USER_ID, WIN, USER_IP) VALUES (@CUID, @USERID, 2, @IP)
							SELECT '2' AS Result
						END
						ELSE															-- 오로나민C 당첨자
						BEGIN
							INSERT INTO EV_MOBILE_ATTENDANCE_PROMOTION_TB2 (CUID, USER_ID, WIN, USER_IP) VALUES (@CUID, @USERID, 1, @IP)
							SELECT '1' AS Result
						END
					END
					ELSE	
					BEGIN
						-- 이벤트 당첨자가 아니면
						INSERT INTO EV_MOBILE_ATTENDANCE_PROMOTION_TB2 (CUID, USER_ID, WIN, USER_IP) VALUES (@CUID, @USERID, 0, @IP)
						SELECT '0' AS Result
					END
				END
			END
		END
	END
END

GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_NEWYEAR_MONEY]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 캘린더, 다이어리 새뱃돈 이벤트
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/12/22
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : EV_NEWYEAR_MONEY_TB
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC PUT_EV_NEWYEAR_MONEY '123123', '홍길동', '01023234545', 'wb', '127.0.0.1', 'IOS'



exec [EVENT].[dbo].[PUT_EV_NEWYEAR_MONEY] @CUID=0,@USERNAME='홍길동',@HP='11122223333',@ROUTE_CHANNEL='na',@IP_ADDR='127.0.0.1',@DEVICE='ANDROID'

select * from EV_NEWYEAR_MONEY_TB

*************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_EV_NEWYEAR_MONEY]
		@CUID							INT						= 0
	, @USERNAME					VARCHAR(25)		= ''
	, @HP								VARCHAR(20)		= ''
	, @ROUTE_CHANNEL		VARCHAR(2)		= ''
	, @IP_ADDR					VARCHAR(15)		= ''
	, @DEVICE						VARCHAR(20)		= ''
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @ATTENDANCE_COUNT_HP			INT = 0
	DECLARE @ATTENDANCE_COUNT_CUID		INT = 0

	IF CONVERT(VARCHAR(10), GETDATE(), 120) < '2018-01-01'
	BEGIN
		RETURN 2
	END
	ELSE IF CONVERT(VARCHAR(10), GETDATE(), 120) > '2018-01-31'
	BEGIN
		RETURN 4
	END
	ELSE
	BEGIN
		SELECT @ATTENDANCE_COUNT_HP = COUNT(*)
		FROM EV_NEWYEAR_MONEY_TB
		WHERE HP = @HP

		/*
		IF @ATTENDANCE_COUNT_HP < 1
		BEGIN
			IF @CUID > 0
			BEGIN
				SELECT @ATTENDANCE_COUNT_CUID = COUNT(*)
				FROM EV_NEWYEAR_MONEY_TB
				WHERE (CUID != 0 OR CUID != '')
					AND CUID = @CUID
			END
		END
		*/

		IF @ATTENDANCE_COUNT_HP > 0
		BEGIN
			RETURN 3
		END
		/*
		ELSE IF @ATTENDANCE_COUNT_CUID > 0
		BEGIN
			RETURN 1
		END
		*/
		ELSE
		BEGIN
			INSERT INTO EV_NEWYEAR_MONEY_TB (CUID, USERNAME, HP, ROUTE_CHANNEL, IP_ADDR, DEVICE)
			VALUES (@CUID, @USERNAME, @HP, @ROUTE_CHANNEL, @IP_ADDR, @DEVICE)
			RETURN 0
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_PROMOTION_1803]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 3월 프로모션
 *  작   성   자 : 백규원
 *  작   성   일 : 2018/03/27
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : EV_PROMOTION_1803_TB
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC PUT_EV_PROMOTION_1803 '123123', '홍길동', '01023234545', 'wb', '127.0.0.1', 'IOS'
*************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_EV_PROMOTION_1803]
		@CUID							INT						= 0
	, @USERNAME					VARCHAR(25)		= ''
	, @HP								VARCHAR(20)		= ''
	, @ROUTE_CHANNEL		VARCHAR(2)		= ''
	, @IP_ADDR					VARCHAR(15)		= ''
	, @DEVICE						VARCHAR(20)		= ''
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @ATTENDANCE_COUNT_HP			INT = 0
	DECLARE @ATTENDANCE_COUNT_CUID		INT = 0

	IF CONVERT(VARCHAR(10), GETDATE(), 120) < '2018-08-01'
	BEGIN
		RETURN 2
	END
	ELSE IF CONVERT(VARCHAR(10), GETDATE(), 120) > '2018-08-31'
	BEGIN
		RETURN 4
	END
	ELSE
	BEGIN
		SELECT @ATTENDANCE_COUNT_HP = COUNT(*)
		FROM EV_PROMOTION_1803_TB
		WHERE HP = @HP

		/*
		IF @ATTENDANCE_COUNT_HP < 1
		BEGIN
			IF @CUID > 0
			BEGIN
				SELECT @ATTENDANCE_COUNT_CUID = COUNT(*)
				FROM EV_PROMOTION_1803_TB
				WHERE (CUID != 0 OR CUID != '')
					AND CUID = @CUID
			END
		END
		*/

		IF @ATTENDANCE_COUNT_HP > 0
		BEGIN
			RETURN 3
		END
		/*
		ELSE IF @ATTENDANCE_COUNT_CUID > 0
		BEGIN
			RETURN 1
		END
		*/
		ELSE
		BEGIN
			INSERT INTO EV_PROMOTION_1803_TB (CUID, USERNAME, HP, ROUTE_CHANNEL, IP_ADDR, DEVICE)
			VALUES (@CUID, @USERNAME, @HP, @ROUTE_CHANNEL, @IP_ADDR, @DEVICE)
			RETURN 0
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_PROMOTION_FINDALL_FORTUNE_SERVICE_TB_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 운세서비스 설정값 셋팅
 *  작   성   자 : 신 장 순 (jssin@mediawill.com)
 *  작   성   일 : 2016/09/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 SELECT * FROM PROMOTION_FINDALL_FORTUNE_SERVICE_TB (NOLOCK)
 EXEC DBO.PUT_EV_PROMOTION_FINDALL_FORTUNE_SERVICE_TB_PROC 11343563, 1983, 7, 19, 2, 2, 1, 0, 0, 'M401'
exec [EVENT].[dbo].[PUT_EV_PROMOTION_FINDALL_FORTUNE_SERVICE_TB_PROC] @CUID=11343563,@BIRTH_YYYY=1983,@BIRTH_MM=7,@BIRTH_DD=19,@LIFE_TIME=2,@LEAP_MONTH=2,@GENDER=1,@ALRAM_HH=4,@ALRAM_MM=0,@SECTION_CD='M401'
 *************************************************************************************/
CREATE PROC [dbo].[PUT_EV_PROMOTION_FINDALL_FORTUNE_SERVICE_TB_PROC]
  @CUID				INT
, @BIRTH_YYYY	SMALLINT
, @BIRTH_MM		TINYINT
, @BIRTH_DD		TINYINT
, @LIFE_TIME	TINYINT
, @LEAP_MONTH	TINYINT
, @GENDER			TINYINT
, @ALRAM_HH		TINYINT
, @ALRAM_MM		TINYINT
, @SECTION_CD	CHAR(4)
, @MID				VARCHAR(200)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON
	
	DECLARE @RTN_NUMBER TINYINT = 0

	IF NOT EXISTS(SELECT 'X' FROM PROMOTION_FINDALL_FORTUNE_SERVICE_TB WHERE MID = @MID)
		BEGIN
	
			INSERT INTO PROMOTION_FINDALL_FORTUNE_SERVICE_TB
			(
				CUID
			, BIRTH_YYYY
			, BIRTH_MM
			, BIRTH_DD
			, LIFE_TIME
			, LEAP_MONTH
			, GENDER
			, ALRAM_HH
			, ALRAM_MM
			, SECTION_CD
			, MID
			)
			VALUES
			(
				@CUID
			, @BIRTH_YYYY
			, @BIRTH_MM
			, @BIRTH_DD
			, @LIFE_TIME
			, @LEAP_MONTH
			, @GENDER
			, @ALRAM_HH
			, @ALRAM_MM
			, @SECTION_CD
			, @MID
			)

			SET @RTN_NUMBER = 1

		END
	ELSE
		BEGIN

			UPDATE A SET
									A.BIRTH_YYYY	= @BIRTH_YYYY
								, A.BIRTH_MM		= @BIRTH_MM	
								, A.BIRTH_DD		= @BIRTH_DD
								, A.LIFE_TIME		= @LIFE_TIME
								, A.LEAP_MONTH	= @LEAP_MONTH
								, A.GENDER			= @GENDER
								, A.ALRAM_HH		= @ALRAM_HH
								, A.ALRAM_MM		= @ALRAM_MM
								, A.SECTION_CD	= @SECTION_CD
								, A.CUID				= @CUID
								, A.MOD_DT			= GETDATE()
			FROM PROMOTION_FINDALL_FORTUNE_SERVICE_TB A
			WHERE A.MID = @MID

			SET @RTN_NUMBER = 2
			
		END

		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1
		BEGIN
			SET @RTN_NUMBER = -1
		END
		--SELECT @RTN_NUMBER
		RETURN @RTN_NUMBER

END
GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_TVCF_EVENT_201311_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 이벤트 > TVCF 이벤트 3차
 *  작   성   자 : 이 근 우(stari@mediawill.com)
 *  작   성   일 : 2013/11/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : TVCF 이벤트 3차
 *  사 용  예 제 : EXEC DBO.PUT_EV_TVCF_EVENT_201311_PROC 'COWTO76', '확률을높인다'
 *************************************************************************************/
CREATE PROC [dbo].[PUT_EV_TVCF_EVENT_201311_PROC]
       @USERID    VARCHAR(50)
     , @ARG       VARCHAR(50)
     , @CUID	  INT	= NULL
AS

SET NOCOUNT ON       

IF EXISTS (SELECT * FROM EV_TVCF_EVENT_201311_TB WITH (NOLOCK) 
            WHERE EVT_DT=CONVERT(VARCHAR(10),GETDATE(),111) 
              AND USERID = @USERID AND CUID = @CUID)       
BEGIN
    --'1일 1회만 참여가능합니다.내일 다시 참여해 주세요.'
    RETURN (100)
END

INSERT EV_TVCF_EVENT_201311_TB
     ( EVT_DT, USERID, ARG , CUID)
VALUES
     ( CONVERT(VARCHAR(10),GETDATE(),111) , @USERID, @ARG,@CUID)
--응모가 완료되었습니다.     
RETURN (0)
GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_TVCF_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : TV CF캠페인 이벤트 
 *  작   성   자 : 최승범
 *  작   성   일 : 2016/11/94
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
*************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_EV_TVCF_PROC]
  @NAME				VARCHAR(25)		= ''
, @HP	            VARCHAR(20)     = ''
, @Event_CD			INT				= 0

AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
  
	DECLARE @ATTENDANCE_COUNT	INT = 0 
	
	SELECT @ATTENDANCE_COUNT = COUNT(*)
	FROM EV_TVCF_TB
	WHERE HP = @HP
	
	IF @ATTENDANCE_COUNT > 0	
	BEGIN
		RETURN 1
	END
	Else
	BEGIN
		
		INSERT INTO EV_TVCF_TB (Name,HP,Event_CD) VALUES (@NAME, @HP, @Event_CD)
		RETURN 0
		
	END
END


GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_TVCF_PROMOTION_201309_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 이벤트 > TVCF PROMOTIOM 이벤트
 *  작   성   자 : 이근우
 *  작   성   일 : 2013/10/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : TVCF PROMOTIOM 이벤트
 *  사 용  예 제 : EXEC DBO.PUT_EV_TVCF_PROMOTION_201309_PROC 'COWTO76', 1
 *************************************************************************************/
CREATE PROC [dbo].[PUT_EV_TVCF_PROMOTION_201309_PROC]
       @USERID    VARCHAR(50)
     , @ARG       INT
     , @CUID	  INT = NULL
AS

SET NOCOUNT ON       

IF EXISTS (SELECT * FROM EV_TVCF_PROMOTION_201310_TB WITH (NOLOCK) 
            WHERE EVT_DT=CONVERT(VARCHAR(10),GETDATE(),111) 
              AND USERID = @USERID AND CUID = @CUID )       
BEGIN
    --'1일 1회만 참여가능합니다.내일 다시 참여해 주세요.'
    RETURN (100)
END

INSERT EV_TVCF_PROMOTION_201310_TB
     ( EVT_DT, USERID, ARG ,CUID)
VALUES
     ( CONVERT(VARCHAR(10),GETDATE(),111) , @USERID, @ARG,@CUID)
--응모가 완료되었습니다.     
RETURN (0)
GO
/****** Object:  StoredProcedure [dbo].[PUT_EV_WeArea_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
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
 *  사 용  예 제 : 
*************************************************************************************/
create PROCEDURE [dbo].[PUT_EV_WeArea_PROC]
  @NAME				VARCHAR(50)		= ''
, @HP	            VARCHAR(12)     = ''
, @AREA	            VARCHAR(50)     = ''
, @Contents	            VARCHAR(700)     = ''
 ,@Result       INT  = 0   OUTPUT
 
AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
	
	DECLARE @ATTENDANCE_COUNT	INT = 0 
	
	SELECT @ATTENDANCE_COUNT = COUNT(*)
	FROM EV_WeArea
	WHERE HP = @HP
	
	IF @ATTENDANCE_COUNT > 0	
	BEGIN
		Set @Result = 1
	END
	Else
	BEGIN
		
		INSERT INTO EV_WeArea (Name,HP,Area,Contents) VALUES (@NAME, @HP, @Area, @Contents)
		Set @Result =  0
		
	END
	
END


GO
/****** Object:  StoredProcedure [dbo].[PUT_F_ALLPOINT_EVENT_ENTRY_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 올포인트 소진 이벤트 응모 처리
 *  작   성   자 : 이 경 덕 (laplance@mediawill.com)
 *  작   성   일 : 2012/09/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.PUT_F_ALLPOINT_EVENT_ENTRY_PROC 2, 'cbk08'
 *************************************************************************************/


CREATE PROC [dbo].[PUT_F_ALLPOINT_EVENT_ENTRY_PROC]

   @EVENT_SEQ INT
  ,@USERID VARCHAR(50)
  ,@CUID	INT = NULL

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- 이벤트 응모 내역 등록
  INSERT INTO  dbo.EV_MY_ALLPOINT_ENTRY_TB
    (EVENT_SEQ, USERID,CUID)
  VALUES
    (@EVENT_SEQ, @USERID,@CUID)
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_ATTENDANCE_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 메인 > 출석체크 처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.PUT_F_ATTENDANCE_PROC 'cbk08'
 *************************************************************************************/


CREATE PROC [dbo].[PUT_F_ATTENDANCE_PROC]

  @USERID VARCHAR(50)
  ,@CUID	INT = NULL

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @CNT TINYINT
  
  SELECT @CNT = COUNT(*)
    FROM EV_ATTENDANCE_TB
   WHERE USERID = @USERID
	 AND CUID = @CUID
     AND CONVERT(VARCHAR(10),REG_DT,120) = CONVERT(VARCHAR(10),GETDATE(),120)

  IF @CNT = 0
    BEGIN
      BEGIN TRAN
    
        INSERT INTO EV_ATTENDANCE_TB
          (REG_DT, USERID,CUID)
        VALUES
          (GETDATE(), @USERID,@CUID)
    
      COMMIT TRAN
    END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_BI_FIND_COUNT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이 근 우(stari@mediawill.com)
-- Create date: 2013.09.30
-- Description:	이벤트 > BI찾기 이벤트 > BI 찾기 증가
-- Exam: EXEC PUT_F_BI_FIND_COUNT_PROC 'cowto76'
-- =============================================
CREATE PROCEDURE [dbo].[PUT_F_BI_FIND_COUNT_PROC]
		@USERID         VARCHAR(50)
		,@CUID			INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
  DECLARE @MAX_ENTRY_DT SMALLDATETIME

  SELECT @MAX_ENTRY_DT = MAX(ENTRY_DT)
    FROM EV_BI_FIND_ENTRY_TB WITH (NOLOCK)
   WHERE USER_ID = @USERID
	 AND CUID = @CUID
     AND ENTRY_YN = 'Y'

  IF CONVERT(VARCHAR(10), @MAX_ENTRY_DT, 120) < CONVERT(VARCHAR(10), GETDATE(), 120) OR @MAX_ENTRY_DT IS NULL
  BEGIN

    IF NOT EXISTS (SELECT * FROM EV_BI_FIND_ENTRY_TB WITH (NOLOCK) WHERE USER_ID = @USERID AND ENTRY_YN = 'N' AND CUID = @CUID)
    BEGIN
      INSERT INTO EV_BI_FIND_ENTRY_TB (USER_ID, ENTRY_COUNT, ENTRY_YN,CUID)
      VALUES(@USERID, 1, 'N',@CUID)
    END

    ELSE
    BEGIN
      UPDATE TB
         SET ENTRY_COUNT = ENTRY_COUNT + 1
      -- SELECT *
        FROM EV_BI_FIND_ENTRY_TB TB
       WHERE USER_ID = @USERID
         AND CUID = @CUID
         AND ENTRY_YN = 'N'
         AND ENTRY_COUNT < 5
    END
  END

  SELECT ENTRY_COUNT
    FROM EV_BI_FIND_ENTRY_TB WITH (NOLOCK)
   WHERE USER_ID = @USERID
     AND CUID = @CUID
     AND ENTRY_YN = 'N'
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_EV_EVENT_DATA_SUB_TB_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 이벤트 SUB 데이터 INSERET
 *  작   성   자 : 조재성
 *  작   성   일 : 2018/02/20
 *  설        명 : EV_EVENT_DATA_SUB_TB 테이블 INSERT
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 *************************************************************************************/
 
CREATE PROC [dbo].[PUT_F_EV_EVENT_DATA_SUB_TB_PROC]
(
	@DATAIDX INT=0 --참여자IDX
	,@GBN  VARCHAR(MAX)='' --참여자,피참여자등의 구분 --share, visit
	,@GCODE SMALLINT=0 --그룹코드
	,@ICODE INT=0 --개별코드
	,@REGIP VARCHAR(15)='' -- 참여자 IP
	,@DEVICE INT=10000 --디바이스정보 --10000 웹,10001 모바일웹(안드로이드), 10002 모바일웹(아이폰), 10003 모바일어플(안드로이드), 10004	모바일어플(아이폰)
)
AS
BEGIN	
	SET NOCOUNT ON	

	INSERT INTO EV_EVENT_DATA_SUB_TB (DATAIDX,GBN,GCODE,ICODE,REGIP,DEVICE)
			VALUES (@DATAIDX,@GBN,@GCODE,@ICODE,@REGIP,@DEVICE)

END


GO
/****** Object:  StoredProcedure [dbo].[PUT_F_EV_EVENT_DATA_TB_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 이벤트 로그인한 사용자 참여 기록
 *  작   성   자 : 김선호
 *  작   성   일 : 2018/02/14
 *  설        명 : 이벤트에 참여했는지 EVENT_SEQ, CUID 로 확인 
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC PUT_F_EV_EVENT_DATA_TB_PROC 0,609,'','','','',13998358,'121.166.161.23'
 *************************************************************************************/
 
CREATE PROC [dbo].[PUT_F_EV_EVENT_DATA_TB_PROC]
(
	@DATAIDX INT=0 OUTPUT
	,@EVENT_SEQ INT = 0 --이벤트번호
	,@REGNAME VARCHAR(20)='' -- 참여자 이름
	,@REGPHONE VARCHAR(13)='' -- 참여자 이름
	,@REGEMAIL VARCHAR(50)='' -- 참여자 이메일
	,@REGID VARCHAR(30)='' -- 참여자 아이디
	,@CUID INT=0 --참여자 회원번호
	,@REGIP VARCHAR(15)='' -- 참여자 IP 
)
AS
BEGIN	
	SET NOCOUNT ON	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF @EVENT_SEQ > 0 BEGIN
		/*SELECT TOP(1) @DATAIDX=DATAIDX FROM EV_EVENT_DATA_TB WHERE EVENT_SEQ=@EVENT_SEQ AND CUID=@CUID
		IF @DATAIDX>0 BEGIN
			INSERT INTO EV_EVENT_DATA_TB (EVENT_SEQ,REGNAME,REGPHONE,REGEMAIL,REGID,CUID,REGIP)
			VALUES (@EVENT_SEQ,@REGNAME,@REGPHONE,@REGEMAIL,@REGID,@CUID,@REGIP)
			
			SET @DATAIDX= @@IDENTITY 
		END*/
		
	
		UPDATE EV_EVENT_DATA_TB
			/*SET EVENT_SEQ=@EVENT_SEQ
			,REGNAME=@REGNAME
			,REGPHONE=@REGPHONE
			,REGEMAIL=@REGEMAIL
			,REGID=@REGID
			,CUID=@CUID
			,REGIP=@REGIP
			,MODDATE=GETDATE()*/
			SET @DATAIDX=DATAIDX
			,MODDATE=GETDATE() --이미 기본 정보가 입력되있는 경우 : 최종수정일 변경
		WHERE EVENT_SEQ=@EVENT_SEQ
		AND CUID=@CUID
			
		IF @@ROWCOUNT = 0 BEGIN --@@ROWCOUNT 로 건수 없을때 입력
			INSERT INTO EV_EVENT_DATA_TB (EVENT_SEQ,REGNAME,REGPHONE,REGEMAIL,REGID,CUID,REGIP)
			VALUES (@EVENT_SEQ,@REGNAME,@REGPHONE,@REGEMAIL,@REGID,@CUID,@REGIP)
			
			SET @DATAIDX= @@IDENTITY 
		END
	END
	
	RETURN @DATAIDX
END


GO
/****** Object:  StoredProcedure [dbo].[PUT_F_EVENT_COMMENT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 이벤트 댓글등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.PUT_F_EVENT_COMMENT_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_F_EVENT_COMMENT_PROC]

  @EVENT_SEQ INT
  ,@USERID VARCHAR(50)
  ,@COMMENT NVARCHAR(250)
  ,@CUID	INT = NULL

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN

    INSERT EV_COMMENT_TB
      (EVENT_SEQ, USERID, COMMENT,CUID)
    VALUES
      (@EVENT_SEQ, @USERID, @COMMENT,@CUID)

  COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_EVENT_ENTRY_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 이벤트 응모 처리
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.PUT_F_EVENT_ENTRY_PROC 2, 'cbk08'
 *************************************************************************************/


CREATE PROC [dbo].[PUT_F_EVENT_ENTRY_PROC]

  @EVENT_SEQ INT
  ,@USERID VARCHAR(50)
  ,@CUID	INT = NULL

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

/*
  -- 포인트 사용 내역 등록
  DECLARE @USE_POINT INT       -- 사용포인트
  DECLARE @POINT_TYPE TINYINT  -- 포인트 형태 (0: 해당없음, 1:적립, 2:차감)

  SELECT @USE_POINT = POINT_VALUE
        ,@POINT_TYPE = POINT_TYPE
    FROM dbo.EV_EVENT_TB
   WHERE EVENT_SEQ = @EVENT_SEQ

  -- 포인트 적립/차감 처리 (김민석 과장 프로시저 작업 완료후 적용)
  IF @POINT_TYPE > 0
    BEGIN
      FINDDB2.POINT.DBO.[프로시저]
    END
*/

  -- 이벤트 응모 내역 등록
  INSERT INTO  dbo.EV_MY_ENTRY_TB
    (EVENT_SEQ, USERID, CUID)
  VALUES
    (@EVENT_SEQ, @USERID, @CUID)
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_EVENT_SAMSUNG_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PUT_F_EVENT_SAMSUNG_PROC]
	@mem_id		varchar(50)
,	@name		varchar(50)	
,	@sex		char(1)	
,	@birth		varchar(10)
,	@CI			varchar(200)
,	@sitegubun	char(1)	 -- S :써브 F: 벼룩시장
,	@result		char(1) output
,   @CUID		INT = NULL
AS
set nocount on
BEGIN
	DECLARE @D_CI  varchar

	select userid from EVENT.dbo.EV_SAMSUNG_TB where userid = @mem_id  AND CUID = @CUID

	SET @D_CI = @@ROWCOUNT
	
	IF @D_CI = 0 BEGIN
	
		insert into EVENT.dbo.EV_SAMSUNG_TB
		(CI,userid,name,sex,birth,sitegubun,regdt,CUID)
		values
		(@CI,@mem_id,@name,@sex,@birth,@sitegubun,getdate(),@CUID)	
		SET @result ='Y'
	END
	ELSE BEGIN

		SET @result ='N'
	END


END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_EVENT_SCRAP_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 이벤트 스크랩 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/03/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.PUT_F_EVENT_SCRAP_PROC 2, 'cbk08', ''
 *************************************************************************************/


CREATE PROC [dbo].[PUT_F_EVENT_SCRAP_PROC]

  @EVENT_SEQ INT
  ,@USERID VARCHAR(50)
  ,@RESULT TINYINT OUTPUT  -- 0: 스크랩된 이벤트, 1: 스크랩 성공
  ,@CUID	INT = NULL

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  IF (SELECT COUNT(*)
        FROM EV_MY_SCRAP_TB
       WHERE EVENT_SEQ = @EVENT_SEQ
         AND USERID = @USERID AND CUID = @CUID) > 0
    BEGIN
      SET @RESULT = 0
    END
  ELSE
    BEGIN
      BEGIN TRAN
    
        INSERT EV_MY_SCRAP_TB
          (EVENT_SEQ, USERID, CUID)
        VALUES
          (@EVENT_SEQ, @USERID,@CUID)
    
      COMMIT TRAN  

      SET @RESULT = 1
    END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_MAIN_SEARCH_RENEWAL_PROMOTION_COMMENT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 메인/검색 리뉴얼 프로모션 타입 1, 2 참여 및 당첨확인
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016/06/21
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC PUT_F_MAIN_SEARCH_RENEWAL_PROMOTION_COMMENT_PROC 'cowto7602', '수정할꺼 많아요!!! 정말 많아요!!!'
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_MAIN_SEARCH_RENEWAL_PROMOTION_COMMENT_PROC]

  @USERID           VARCHAR(50)     = ''
, @COMMENT          VARCHAR(2000)   = ''
, @CUID				INT				= NULL

AS 
  
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  IF @USERID != '' OR @COMMENT != ''
  BEGIN

    INSERT INTO EV_MAIN_SEARCH_RENEWAL_PROMOTION_COMMENT_TB (USERID, COMMENT, CUID)
    VALUES (@USERID, @COMMENT, @CUID)

  END

END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 메인/검색 리뉴얼 프로모션 타입 1, 2 참여 및 당첨확인
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016/06/21
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC PUT_F_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_PROC 2, 'cowto7602', '58.76.233.106'

 EXEC PUT_F_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_PROC @EVENT_TYPE, @USERID, @USER_IP
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_PROC]

  @EVENT_TYPE       TINYINT         = 0
, @USERID           VARCHAR(50)     = ''
, @USER_IP          VARCHAR(20)     = ''
, @CUID				INT				= NULL

AS 
  
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  DECLARE @NOWDATE VARCHAR(10)
  DECLARE @JOIN_CNT INT
  DECLARE @WIN_CNT INT
  DECLARE @WIN_PRIZE_IDX INT
  DECLARE @EVENT_TYPE1_WIN_NUM TINYINT
  DECLARE @EVENT_TYPE2_WIN_NUM TINYINT
  DECLARE @WIN_NUM INT
  DECLARE @RESULT CHAR(1)                 -- Y:참여_당첨, N:참여_미당첨, C:이미참여
  DECLARE @RESULT_PRIZE_CODE CHAR(1)      -- 1:사이다, 2:스타벅스아메리카노, 3:백화점상품권  
  DECLARE @INNER_JOINER CHAR(1)
  DECLARE @WINNER CHAR(1)


  SET @NOWDATE = CONVERT(VARCHAR(10), GETDATE(), 120)
  SET @EVENT_TYPE1_WIN_NUM = 8
  SET @EVENT_TYPE2_WIN_NUM = 6
  SET @RESULT_PRIZE_CODE = '0'
  SET @RESULT = 'C'                       -- 기본값으로 "이미참여" 로
  SET @INNER_JOINER = 'N'                 -- 회사 내부 회원
  SET @WINNER = 'N'                       -- 이전 당첨여부


  /*

  DECLARE @DATE DATETIME
        , @DATE_HOUR TINYINT
        , @NUM INT

  SET @DATE = GETDATE()
  SET @NUM = 0
  SET @DATE_HOUR = DATEPART(HOUR, @DATE)

  IF @DATE_HOUR >= 21 AND @DATE_HOUR < 3
    SET @NUM = 14
  ELSE IF @DATE_HOUR >= 3 AND @DATE_HOUR < 9
    SET @NUM = 7
  ELSE IF @DATE_HOUR >= 9 AND @DATE_HOUR < 16
    SET @NUM = 14
  ELSE IF @DATE_HOUR >= 16 AND @DATE_HOUR < 21
    SET @NUM = 7


  SELECT @NUM

  */

  -- 금일 참여 여부 확인
  SELECT @JOIN_CNT = COUNT(*)
    FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_TB
   WHERE EVENT_DT = @NOWDATE
     AND EVENT_TYPE = @EVENT_TYPE
     AND USERID = @USERID
	 AND CUID = @CUID
  -- 경로가 PC 일 경우 IP를 받고 있으니, 회사 IP인 경우는 미당첨처리
  --IF @USER_IP <> ''
  --BEGIN
  --  IF @USER_IP LIKE '58.76.23%' OR @USER_IP LIKE '118.129.209.%'
  --  BEGIN
  --    SET @INNER_JOINER = 'Y'
  --  END
  --END

  -- 당첨된 사람이라면, 이미참여로
  IF EXISTS (SELECT * FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_TB WHERE EVENT_TYPE = @EVENT_TYPE AND  WIN_GBN = 'Y' AND USERID = @USERID AND CUID = @CUID )
  BEGIN
    SET @WINNER = 'Y'
  END
  
  -- 참여를 않했으면
  IF @JOIN_CNT = 0
  BEGIN
  
    -- 결과값 
    SET @RESULT = 'N'                     -- 참여의 기본값을 "미당첨"으로
    SET @WIN_NUM = 99

    INSERT INTO EV_MAIN_SEARCH_RENEWAL_PROMOTION_TB (EVENT_DT, EVENT_TYPE, USERID, USER_IP, CUID)
    VALUES (@NOWDATE, @EVENT_TYPE, @USERID, @USER_IP, @CUID)
  
    IF @WINNER = 'N' AND @INNER_JOINER = 'N'
    BEGIN
      SELECT @WIN_CNT = COUNT(*)
        FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_TB
       WHERE EVENT_DT = @NOWDATE
         AND EVENT_TYPE = @EVENT_TYPE    

      IF @EVENT_TYPE = 1
        SET @WIN_NUM = @WIN_CNT % @EVENT_TYPE1_WIN_NUM
      ELSE IF @EVENT_TYPE = 2
        SET @WIN_NUM = @WIN_CNT % @EVENT_TYPE2_WIN_NUM

      -- 당첨자일 경우
      IF @WIN_NUM = 0
      BEGIN
        -- 금일/해당이벤트 남은 경품 중 랜덤하게 선택
        --SELECT TOP 1 
        --       @WIN_PRIZE_IDX = PRIZE_IDX
        --     , @RESULT_PRIZE_CODE = PRIZE_CODE
        --  FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_TB
        -- WHERE PRIZE_IDX IN (
        --                      SELECT PRIZE_IDX
        --                        FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_TB
        --                       WHERE EVENT_DT = @NOWDATE
        --                         AND EVENT_TYPE = @EVENT_TYPE
        --                         AND PRIZE_REST_CNT > 0
        --                     )
        -- ORDER BY NEWID()

        SELECT TOP 1 
               @WIN_PRIZE_IDX = PRIZE_IDX
             , @RESULT_PRIZE_CODE = PRIZE_CODE
          FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_TB
         WHERE PRIZE_IDX IN (
                              SELECT PRIZE_IDX
                                FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_TB
                               WHERE EVENT_DT = @NOWDATE
                                 AND EVENT_TYPE = @EVENT_TYPE
                                 AND PRIZE_REST_CNT > 0
                                 AND PRIZE_CODE IN (
                                                    SELECT PRIZE_CODE
                                                      FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_TB
                                                     WHERE EVENT_DT = @NOWDATE
                                                       AND EVENT_TYPE = @EVENT_TYPE
                                                       AND PRIZE_CODE = 1
                                                    UNION ALL
                                                    SELECT PRIZE_CODE
                                                      FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_TB
                                                     WHERE EVENT_DT = @NOWDATE
                                                       AND EVENT_TYPE = @EVENT_TYPE
                                                       AND PRIZE_CODE = CASE WHEN GETDATE() > EVENT_DT + ' 01:45:00' THEN 2 ELSE 0 END
                                                    UNION ALL
                                                    SELECT PRIZE_CODE
                                                      FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_TB
                                                     WHERE EVENT_DT = @NOWDATE
                                                       AND EVENT_TYPE = @EVENT_TYPE
                                                       AND PRIZE_CODE = CASE WHEN GETDATE() > EVENT_DT + ' 12:15:00' THEN 3 ELSE 0 END
                                     )
               )
         ORDER BY NEWID()


        IF @RESULT_PRIZE_CODE > 0
        BEGIN    
          -- 이벤트 참여목록에 당첨여부 업데이트
          UPDATE A
             SET A.WIN_GBN = 'Y'
               , A.WIN_PRIZE = @RESULT_PRIZE_CODE
            FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_TB A
           WHERE A.EVENT_DT = @NOWDATE
             AND A.EVENT_TYPE = @EVENT_TYPE
             AND A.USERID = @USERID
             AND A.CUID = @CUID 
    
          -- 경품 목록에서 해당 경품수 차감
          UPDATE A
             SET A.PRIZE_REST_CNT = PRIZE_REST_CNT - 1
            FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_PRIZE_TB A
           WHERE A.PRIZE_IDX = @WIN_PRIZE_IDX

          SET @RESULT = 'Y'                    -- 참여_당첨 값으로 변경
        END
        ELSE
        BEGIN
          SET @RESULT = 'N'                    -- 당일 경품이 없으면 참여_미당첨
        END
      END
    END
  END

  SELECT @RESULT AS RESULT, @RESULT_PRIZE_CODE AS RESULT_PRIZE_CODE

END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PROMOTION_HOUSE_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프로모션(2011.11) > 응모 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/10/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.PUT_F_PROMOTION_HOUSE_PROC
 *************************************************************************************/

CREATE PROC [dbo].[PUT_F_PROMOTION_HOUSE_PROC]

  @USERID          varchar (50)
  ,@AD_TYPE        char    (1)  -- P: 신문, H: 파인드하우스
  ,@ADID           int
  ,@AD_CATEGORY_NM varchar (100)
  ,@AD_ADDRESS     varchar (200)
  ,@AD_PRICE_JUN   int
  ,@AD_PRICE_BO    int
  ,@AD_PRICE_WOL   int
  ,@ETC_CONTENTS   varchar (500)
  ,@REG_NAME       varchar (30)
  ,@REG_PHONE      varchar (30)
  ,@REG_TITLE      varchar (250)
  ,@REG_CONTENTS   nvarchar(3000)
  ,@RESULT         BIT OUTPUT  -- 0: 기존참여로 인한 미등록처리, 1: 등록완료
  ,@CUID			INT = NULL

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  IF(SELECT COUNT(*) FROM PROMOTION_HOUSE_TB WHERE USERID = @USERID AND DEL_YN = 0) = 0
    BEGIN

      INSERT INTO dbo.PROMOTION_HOUSE_TB
        (USERID
        ,AD_TYPE
        ,ADID
        ,AD_CATEGORY_NM
        ,AD_ADDRESS
        ,AD_PRICE_JUN
        ,AD_PRICE_BO
        ,AD_PRICE_WOL
        ,ETC_CONTENTS
        ,REG_NAME
        ,REG_PHONE
        ,REG_TITLE
        ,REG_CONTENTS
        ,CUID )
      VALUES
        (@USERID
        ,@AD_TYPE
        ,@ADID
        ,@AD_CATEGORY_NM
        ,@AD_ADDRESS
        ,@AD_PRICE_JUN
        ,@AD_PRICE_BO
        ,@AD_PRICE_WOL
        ,@ETC_CONTENTS
        ,@REG_NAME
        ,@REG_PHONE
        ,@REG_TITLE
        ,@REG_CONTENTS
        ,@CUID
        )

      SET @RESULT = 1

    END
  ELSE
    BEGIN

      SET @RESULT = 0

    END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PROMOTION_HOUSE_RECOM_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프로모션(2011.11) > 응모내용 추천
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/10/21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.PUT_F_PROMOTION_HOUSE_RECOM_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_F_PROMOTION_HOUSE_RECOM_PROC]

  @IDX           INT
  ,@USERID       VARCHAR(50)
  ,@RESULT       BIT OUTPUT  -- 0: 추천 미처리(기존 추천시), 1: 추천처리
  ,@CUID		INT = NULL

AS

  SET NOCOUNT ON

  -- 같은광고에 같은 회원의 기존 추천내역이 있는지 체크
  IF (SELECT COUNT(*) FROM dbo.PROMOTION_HOUSE_RECOM_TB WHERE IDX = @IDX AND USERID = @USERID AND CUID =@CUID ) = 0
    BEGIN

      BEGIN TRAN
    
        INSERT INTO dbo.PROMOTION_HOUSE_RECOM_TB
          (IDX, USERID, CUID)
        VALUES
          (@IDX, @USERID, @CUID)
    
      COMMIT TRAN

      SET @RESULT = 1

    END
  ELSE
    BEGIN

      SET @RESULT = 0

    END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PROMOTION_JOB_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 구인구직 드림프로젝트 (개인회원 취업일기 등록)
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2011/10/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.PUT_F_PROMOTION_JOB_PROC 'findjob', '면접 보러 갑니다. 오늘도..', '0'
 *************************************************************************************/
 
CREATE PROC [dbo].[PUT_F_PROMOTION_JOB_PROC]
(
   	@User_ID		VARCHAR(50)
,   @Contents       VARCHAR(280)
,	@Job_Status		CHAR(1)
,	@CUID			INT = NULL
)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @REG_SEQ INT

BEGIN TRAN

-- 취업일기 등록
INSERT INTO PROMOTION_JOB_TB
(
   USER_ID
  ,CONTENTS
  ,REG_DT
  ,DEL_YN
  ,CUID
)
VALUES
(
   @User_ID
  ,@Contents
  ,GETDATE()
  ,'N'
  ,@CUID
)

IF @@ERROR <> 0 OR @@ROWCOUNT < 1
  BEGIN
    ROLLBACK TRAN
    RETURN (-1)
  END
ELSE
  BEGIN
    -- 취업상태 등록하지 않은 상태이면 취업상태 등록 또는 업데이트
    IF (SELECT JOB_STATUS FROM PROMOTION_JOB_STATUS_TB WHERE USER_ID = @User_ID) IS NULL
      BEGIN
        INSERT INTO PROMOTION_JOB_STATUS_TB
	    ( USER_ID, JOB_STATUS, REG_DT, CUID) 
        VALUES 
	    ( @User_ID, @Job_Status, GETDATE(),@CUID)
	       
        IF @@ERROR <> 0 OR @@ROWCOUNT < 1
          BEGIN
	        ROLLBACK TRAN
            RETURN (-1)
          END
        ELSE
		  BEGIN
	        COMMIT TRAN
	        RETURN (1)
	      END
       END	
    ELSE
      BEGIN
	    UPDATE PROMOTION_JOB_STATUS_TB
	    SET JOB_STATUS = @Job_Status
	    WHERE USER_ID = @User_ID
		  AND CUID = @CUID 
	   
	    IF @@ERROR <> 0 OR @@ROWCOUNT < 1
	      BEGIN
	        ROLLBACK TRAN
		    RETURN (-1)
	      END
	    ELSE
		  BEGIN
	        COMMIT TRAN
	        RETURN (1)
	      END
	 END
  END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_PROMOTION_RESUME_OPEN_EVENT]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 이력서 공개설정 응모자 입력
 *  작   성   자 : 
 *  작   성   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC PUT_F_PROMOTION_RESUME_OPEN_EVENT
************************************************************************************/
CREATE PROC [dbo].[PUT_F_PROMOTION_RESUME_OPEN_EVENT]
(
  @USERID       VARCHAR(50)    
  ,@CUID		INT = NULL         
)
AS
SET NOCOUNT ON

INSERT INTO PROMOTION_RESUME_OPEN_TB
(USERID,CUID) VALUES (@USERID,@CUID)
   
IF @@ERROR <> 0
BEGIN
	RETURN (-1)
END

RETURN(1)
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_TVCF_BANNER_VIEW_COUNT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : TVCF BANNER VIEW 카운트
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2014/04/04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC PUT_F_TVCF_BANNER_VIEW_COUNT_PROC
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_TVCF_BANNER_VIEW_COUNT_PROC]
  @POSITION     INT = 1
AS

SET NOCOUNT ON       

IF EXISTS (SELECT * FROM EV_TVCF_BANNER_VIEW_COUNT WITH (NOLOCK) WHERE POSITION = @POSITION AND REG_DT=CONVERT(VARCHAR(10),GETDATE(),120))
BEGIN
  UPDATE TB
     SET CNT = CNT + 1
    FROM EV_TVCF_BANNER_VIEW_COUNT AS TB
   WHERE POSITION = @POSITION 
     AND REG_DT = CONVERT(VARCHAR(10),GETDATE(),120)
END
ELSE
BEGIN
  INSERT INTO EV_TVCF_BANNER_VIEW_COUNT(POSITION, REG_DT, CNT)
  VALUES(@POSITION, CONVERT(VARCHAR(10),GETDATE(),120), 1)
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_TVCF_PROMOTION_JOIN_LIKE_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : TVCF 프로모션 좋아요 카운트
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2014/04/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC PUT_F_TVCF_PROMOTION_JOIN_LIKE_PROC 1, 'stari'
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_TVCF_PROMOTION_JOIN_LIKE_PROC]
  @SEQ                      INT  
  ,@USERID                  VARCHAR(50)
  ,@CUID					INT = NULL
AS

BEGIN
  SET NOCOUNT ON

  DECLARE @USERID_CHK INT
  DECLARE @CNT_CHK INT
  DECLARE @NOW_DAY_CNT INT
  DECLARE @NOW_CONTENT_CNT INT
  DECLARE @TODAY VARCHAR(10)
  

  SET @TODAY = CONVERT(VARCHAR(10), GETDATE(), 120)


  SELECT @USERID_CHK = CASE WHEN USERID = @USERID THEN 1 ELSE 0 END
    FROM EV_TVCF_PROMOTION_201404_TB
   WHERE SEQ = @SEQ


  IF @USERID_CHK = 0
  BEGIN
  
    IF EXISTS (SELECT * FROM EV_TVCF_PROMOTION_LIKE_JOIN_COUNT_TB WITH (NOLOCK) WHERE EVT_DT = @TODAY AND USERID = @USERID AND CUID = @CUID)
    BEGIN

      IF NOT EXISTS (SELECT * FROM EV_TVCF_PROMOTION_LIKE_JOIN_COUNT_TB WITH (NOLOCK) WHERE EVT_DT = @TODAY AND USERID = @USERID  AND CUID = @CUID AND LIKE_JOIN_SEQ = @SEQ )
      BEGIN

        SELECT @NOW_DAY_CNT = COUNT(*)
          FROM EV_TVCF_PROMOTION_LIKE_JOIN_COUNT_TB WITH (NOLOCK)
          WHERE EVT_DT = @TODAY 
            AND USERID = @USERID
            AND CUID = @CUID
            
        IF @NOW_DAY_CNT < 5
        BEGIN
      
          UPDATE TB
              SET EVT_LIKE_CNT = EVT_LIKE_CNT + 1
            FROM EV_TVCF_PROMOTION_201404_TB AS TB
            WHERE SEQ = @SEQ

          INSERT INTO EV_TVCF_PROMOTION_LIKE_JOIN_COUNT_TB (EVT_DT, USERID, LIKE_JOIN_SEQ,CUID )
          VALUES (@TODAY, @USERID, @SEQ,@CUID )

      
          SELECT @CNT_CHK = EVT_LIKE_CNT
            FROM EV_TVCF_PROMOTION_201404_TB
            WHERE SEQ = @SEQ
          
        END
        ELSE
        BEGIN
          SET @CNT_CHK = -1       -- 일일 좋아요 카운트 모두 사용
        END

      END
      ELSE
      BEGIN
        -- 해당컨텐츠 좋아요 했지만, 날짜가 틀릴경우?
        SET @CNT_CHK = -3     -- 이미 좋아요 한 컨텐츠        
      END

    END
    ELSE
    BEGIN

      UPDATE TB
          SET EVT_LIKE_CNT = EVT_LIKE_CNT + 1
        FROM EV_TVCF_PROMOTION_201404_TB AS TB
        WHERE SEQ = @SEQ

      INSERT INTO EV_TVCF_PROMOTION_LIKE_JOIN_COUNT_TB (EVT_DT, USERID, LIKE_JOIN_SEQ, CUID)
      VALUES(@TODAY, @USERID, @SEQ,@CUID)

      SELECT @CNT_CHK = EVT_LIKE_CNT
        FROM EV_TVCF_PROMOTION_201404_TB
        WHERE SEQ = @SEQ
      
    END

    SELECT @CNT_CHK
  END
  ELSE
  BEGIN
    SELECT -2         -- 본인 게시물
  END
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_TVCF_PROMOTION_JOIN_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : TVCF 프로모션 참여
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2014/04/09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC PUT_F_TVCF_PROMOTION_JOIN_PROC 'cowto76', 1, 2, '굿잡'
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_TVCF_PROMOTION_JOIN_PROC]
  @USERID                   VARCHAR(50)
  ,@WEEKKIND                 TINYINT
  ,@EVT_PROPOSE_KIND        TINYINT
  ,@EVT_PROPOSE_COMMENT     VARCHAR(500)
  ,@CUID					INT = NULL
AS

BEGIN
  SET NOCOUNT ON

  DECLARE @TODAY VARCHAR(10)
  DECLARE @NOW_CNT INT  

  SET @TODAY = CONVERT(VARCHAR(10), GETDATE(), 120)

  --SELECT @NOW_CNT = COUNT(*)
  --  FROM EV_TVCF_PROMOTION_201404_TB WITH (NOLOCK)
  -- WHERE EVT_DT = @TODAY 
  --   AND USERID = @USERID
  --   AND EVT_WEEKEND = @WEEKKIND

  SELECT @NOW_CNT = COUNT(*)
    FROM EV_TVCF_PROMOTION_201404_TB WITH (NOLOCK)
   WHERE USERID = @USERID
     AND EVT_WEEKEND = @WEEKKIND  
     AND CUID = @CUID

  IF @NOW_CNT < 4
  BEGIN
    INSERT INTO EV_TVCF_PROMOTION_201404_TB (EVT_DT, USERID, REG_DT, EVT_WEEKEND, EVT_PROPOSE_KIND, EVT_PROPOSE_COMMENT, EVT_LIKE_CNT,CUID)
    VALUES(@TODAY, @USERID, GETDATE(), @WEEKKIND, @EVT_PROPOSE_KIND, @EVT_PROPOSE_COMMENT, 0,@CUID)

    SELECT '1|^|' + LTRIM(RTRIM(STR(@@IDENTITY)))
  END
  ELSE
  BEGIN
    SELECT '0|^|0'
  END

END
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_EVENT_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 이벤트 등록
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/02/24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.PUT_M_EVENT_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_M_EVENT_PROC]

  @PUB_LOCAL          TINYINT
  ,@PUB_FA            BIT
  ,@PUB_MAIN          BIT
  ,@TITLE             VARCHAR(200)
	,@SURVEY						CHAR(1)
  ,@INTRODUCTION      VARCHAR(100)
  ,@PUB_TYPE          TINYINT
  ,@CONTENTS          TEXT
  ,@START_DT          DATETIME
  ,@END_DT            DATETIME
  ,@STATUS            TINYINT
  ,@ANNOUNCE_DT       DATETIME
  ,@POINT_TYPE        TINYINT
  ,@POINT_VALUE       INT = 0
  ,@COMMENT_YN        BIT
  ,@PROGRESSION_SITE  VARCHAR(50) = NULL
  ,@EVENT_SEQ         INT OUTPUT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  BEGIN TRAN

    -- 이벤트 정보 INSERT
    INSERT INTO EV_EVENT_TB
      (PUB_LOCAL, PUB_FA, PUB_MAIN, TITLE, INTRODUCTION, PUB_TYPE, CONTENTS, START_DT, END_DT, STATUS, ANNOUNCE_DT, POINT_TYPE, POINT_VALUE, COMMENT_YN, PROGRESSION_SITE, SURVEY)
    VALUES
      (@PUB_LOCAL
      ,@PUB_FA
      ,@PUB_MAIN
      ,@TITLE
      ,@INTRODUCTION
      ,@PUB_TYPE
      ,@CONTENTS
      ,@START_DT
      ,@END_DT
      ,@STATUS
      ,@ANNOUNCE_DT
      ,@POINT_TYPE
      ,@POINT_VALUE
      ,@COMMENT_YN
      ,@PROGRESSION_SITE
			,@SURVEY
			)

    SET @EVENT_SEQ = @@IDENTITY

    -- 당첨안내 ROW INSERT
    INSERT INTO EV_WIN_INFO_TB
      (EVENT_SEQ)
    VALUES
      (@EVENT_SEQ)

  COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[USERID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:39:25 ******/
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
	UPDATE A SET USERID=@RE_USERID FROM EV_ATTENDANCE_TB A  where CUID=@CUID
	UPDATE A SET USER_ID=@RE_USERID FROM EV_BI_FIND_ENTRY_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_COMMENT_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_JOBRENEW_201309_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_COMMENT_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_MAIN_SEARCH_RENEWAL_PROMOTION_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_MY_ALLPOINT_ENTRY_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_MY_ENTRY_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_MY_SCRAP_TB A  where CUID=@CUID
	UPDATE A SET userid=@RE_USERID FROM EV_SAMSUNG_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_TVCF_EVENT_201311_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_TVCF_PROMOTION_201310_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_TVCF_PROMOTION_201404_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM EV_TVCF_PROMOTION_LIKE_JOIN_COUNT_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM PROMOTION_HOUSE_RECOM_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM PROMOTION_HOUSE_TB A  where CUID=@CUID
	UPDATE A SET USER_ID=@RE_USERID FROM PROMOTION_JOB_STATUS_TB A  where CUID=@CUID
	UPDATE A SET USER_ID=@RE_USERID FROM PROMOTION_JOB_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM PROMOTION_RESUME_OPEN_TB A  where CUID=@CUID


/*
	INSERT LOGDB.DBO.USERID_CHANGE_HISTORY_TB (B_USERID,N_USERID,DB_NM,USERIP) 
	SELECT @USERID,@RE_USERID,DB_NAME(),@CLIENT_IP
*/	
END
GO
