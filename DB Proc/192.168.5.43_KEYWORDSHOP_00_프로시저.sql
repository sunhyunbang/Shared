USE [KEYWORDSHOP]
GO
/****** Object:  StoredProcedure [dbo].[_procBizManSendMailLog01_Insert_20191001]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: [비즈맨]키워드샵 연장 안내 메일 발송 대상 추출 하는 프로시저
	제작자	: 정윤정
	제작일	: 2004-11-24


select * from finddb2.common.dbo.usercommon where userid='yomico'
*************************************************************************************/

CREATE PROCEDURE [dbo].[_procBizManSendMailLog01_Insert_20191001]

AS

INSERT INTO tbl_BizManSendMailLog01  (tbl_adinfo_Code ,  UserId , UserEmail,UserName,SendDate,SendGbn )
SELECT
       Ad.Code  ,
       Ad.UserId ,
       UC.Email AS  UserEMail ,
       UC.UserName AS UserName,
       GetDate() ,
       0
  from dbo.tbl_bizman_adinfo AS Ad  with(NoLock)
  JOIN FINDDB2.Member.dbo.UserCommon_VI  UC ON Ad.UserID = UC.UserID
  LEFT JOIN FINDDB2.Member.dbo.MM_MSG_AGREE_TB AS MM ON MM.USERID = UC.USERID AND SECTION_CD = 'S101'
 WHERE
       DateDiff(dd, GetDate(), Ad.EndDay ) = 10  -- 마감일 10일   남은 거
   AND DateDiff(dd, Ad.StartDay, Ad.EndDay ) > 14  -- 광고 기간이 2주 이상 인거
   AND Ad.AdState ='Y'     --검수 완료 된 광고
   AND ISNULL(UC.Email, '') <> ''     --이메일이 공백이 아닌 것
   AND Ad.Code NOT IN ( SeLect tbl_Adinfo_Code FROM  tbl_BizManSendMailLog01  With(NoLock) )   --기존에 발송한 내역이 없는 데이터
   AND MM.SECTION_CD IS NOT NULL


GO
/****** Object:  StoredProcedure [dbo].[_procBizManSendMailLog02_Insert_20191001]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
	설명	: 키워드샵 마감 안내 메일 발송 대상 추출 하는 프로시저
	제작자	: 정윤정
	제작일	: 2004-11-24

sp_help tbl_BizManpSendMailLog
Truncate Table tbl_BizManSendmailLog02
select * from tbl_BizManSendMailLOg with(NoLock)
sp_help tbl_bizman_adinfo
*************************************************************************************/

CREATE PROCEDURE [dbo].[_procBizManSendMailLog02_Insert_20191001]

AS

INSERT INTO tbl_BizManSendMailLog02  (tbl_adinfo_Code ,  UserId , UserEmail, UserName, SendDate,SendGbn )
SELECT Ad.Code,
       Ad.UserId ,
       UC.Email As UserEMail ,
       UC.UserName AS UserName ,
       GetDate() ,
       0
  from dbo.tbl_bizman_adinfo  AS  Ad  with(NoLock)
  JOIN FINDDB2.Member.dbo.UserCommon_VI  UC ON Ad.UserID = UC.UserID
  LEFT JOIN FINDDB2.Member.dbo.MM_MSG_AGREE_TB AS MM ON MM.USERID = UC.USERID AND SECTION_CD = 'S101'
 WHERE
       DateDiff(dd ,GetDate() , Ad.EndDay  ) = 2 -- 마감일 2일   남은 거
   AND Ad.AdState ='Y'     --검수 완료 된 광고
   AND ISNULL(UC.Email , '') <> ''     --이메일이 공백이 아닌 것
   AND Ad.Code NOT IN (SeLect tbl_Adinfo_Code FROM  tbl_BizManSendMailLog02  With(NoLock) )   --기존에 발송한 내역이 없는 데이터
   AND MM.SECTION_CD IS NOT NULL   --이메일 수신 동의
   AND Ad.IsExtendMode ='N'   ;
GO
/****** Object:  StoredProcedure [dbo].[_procKShopSendMailLog01_Insert_20191001]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*************************************************************************************
	설명	: 키워드샵 연장 안내 메일 발송 대상 추출 하는 프로시저
	제작자	: 박준희
	제작일	: 2004-07-22


select * from finddb2.common.dbo.usercommon where userid='kjbug'
*************************************************************************************/

CREATE PROCEDURE [dbo].[_procKShopSendMailLog01_Insert_20191001]

AS

INSERT INTO tbl_KShopSendMailLog01  (tbl_adinfo_Code ,  UserId , UserEmail,UserName,SendDate,SendGbn )
SELECT Ad.Code  , Ad.UserId , UC.Email AS  UserEMail , UC.UserName AS UserName, GetDate() ,0   from dbo.tbl_keyword_adinfo AS   Ad  with(NoLock)
 JOIN FINDDB2.Member.dbo.UserCommon_VI  UC ON Ad.UserID = UC.UserID
LEFT JOIN FINDDB2.Member.dbo.MM_MSG_AGREE_TB AS MM ON MM.USERID = UC.USERID AND SECTION_CD = 'S101'
Where
        DateDiff(dd ,GetDate() , Ad.EndDay  )  = 10  -- 마감일 10일   남은 거
AND DateDiff(dd,Ad.StartDay , Ad.EndDay ) > 14  -- 광고 기간이 2주 이상 인거
AND Ad.AdState ='Y'     --검수 완료 된 광고
AND ISNULL(UC.Email , '') <> ''     --이메일이 공백이 아닌 것
AND Ad.Code NOT IN (SeLect tbl_Adinfo_Code FROM  tbl_KShopSendMailLog01  With(NoLock) )   --기존에 발송한 내역이 없는 데이터
AND MM.SECTION_CD IS NOT NULL   --이메일 수신 동의
GO
/****** Object:  StoredProcedure [dbo].[_procKShopSendMailLog02_Insert_20191001]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*************************************************************************************
	설명	: 키워드샵 연장 안내 메일 발송 대상 추출 하는 프로시저
	제작자	: 박준희
	제작일	: 2004-07-22

sp_help tbl_KShopSendMailLog
Truncate Table tbl_KshopSendmailLog02
select * from tbl_KshopSendMailLOg with(NoLock)
sp_help tbl_keyword_adinfo
*************************************************************************************/

CREATE PROCEDURE [dbo].[_procKShopSendMailLog02_Insert_20191001]

AS

INSERT INTO tbl_KShopSendMailLog02  (tbl_adinfo_Code ,  UserId , UserEmail, UserName, SendDate,SendGbn )
SELECT Ad.Code  , Ad.UserId , UC.Email As UserEMail , UC.UserName AS UserName ,  GetDate() ,0   from dbo.tbl_keyword_adinfo  AS  Ad  with(NoLock)
 JOIN FINDDB2.Member.dbo.UserCommon_VI  UC ON Ad.UserID = UC.UserID
LEFT JOIN FINDDB2.Member.dbo.MM_MSG_AGREE_TB AS MM ON MM.USERID = UC.USERID AND SECTION_CD = 'S101'
Where
       DateDiff(dd ,GetDate() , Ad.EndDay  ) = 2 -- 마감일 2일   남은 거
AND Ad.AdState ='Y'     --검수 완료 된 광고
AND ISNULL(UC.Email , '') <> ''     --이메일이 공백이 아닌 것
AND Ad.Code NOT IN (SeLect tbl_Adinfo_Code FROM  tbl_KShopSendMailLog02  With(NoLock) )   --기존에 발송한 내역이 없는 데이터
AND MM.SECTION_CD IS NOT NULL   --이메일 수신 동의
AND Ad.IsExtendMode ='N'   ;

GO
/****** Object:  StoredProcedure [dbo].[admin_main_gongji_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 메인화면-공지사항 리스트
	제작자		: 고병호
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터
******************************************************************************/
CREATE PROCEDURE [dbo].[admin_main_gongji_list_01]

	@sYY			int	= 0
	,@sMM			int = 0
	,@sDD			int = 0
	,@eYY			int = 0
	,@eMM			int = 0
	,@eDD			int = 0
	,@s_date		varchar(10) = ''
	,@e_date		varchar(10) = ''
	,@gotopage		int = 0
	,@sText			varchar(30) = ''
	,@sSearch		varchar(10) = ''
	,@toppage		int = 1
	,@check_cnt		int = 1
	,@userlevel		char(1) = ''

AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(1000)



	if @check_cnt = '1'
		begin
			SET @Sql = 'select count(num) from tbl_gongji with (noLock)  '
		end
	else
		begin
			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' * from tbl_gongji with (noLock)  '
		end

-------------------------------------------------------------------------------------------------------------------------


	SET @Sql = @Sql + ' where title <> '''' '



	if @userlevel <> ''	--// 레벨에 따라서 보여주는 것을 달리 하기 위해서, 3은 지점관리, 4는 등록대행자.
		begin
			if @userlevel = '3'
				begin
					SET @Sql = @Sql + ' and view_admin1 = ''1'' '
				end
			else
				begin
					SET @Sql = @Sql + ' and view_admin2 = ''1'' '
				end

		end



	if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
		begin
			SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
		end


	if @s_date <> '' and @e_date <> ''
			begin
				SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
				SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
			end
		else
			begin
				if @s_date <> '' and @e_date = ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
					end
				else
					begin
						if @s_date = '' and @e_date = ''
							begin
								SET @sql = @sql + ' '
							end
						else
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
							end
					end
			end


--// -----------------------------------------------------------------------------------------------------------------
	if @check_cnt = '0'
		begin
			SET @Sql = @Sql +' order by num desc'
		end


--print(@sql)
	EXECUTE(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_OUT_FINDDB7_PROC]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BAT_MM_OUT_FINDDB7_PROC]
AS

-- 전날 일자
DECLARE @PRE_DT DATETIME
SET @PRE_DT = CONVERT(CHAR(10),DATEADD(D,-1,GETDATE()),120)

--------------------------------------------
-- 1. 전날 탈퇴 신청 아이디 가져오기
--------------------------------------------
	SELECT USERID
	  INTO #TEMP_OUT_USERID
	  FROM MEMBER.DBO.MM_OUT_TB
	 WHERE OUT_APPLY_DT > @PRE_DT


-- FINDDB7.KeyWordShop
	UPDATE A
       SET A.ADSTATE= 'E'
	  FROM TBL_KEYWORD_ADINFO A
      JOIN #TEMP_OUT_USERID	B ON A.USERID = B.USERID


	UPDATE A
       SET A.ADSTATE= 'E'
	  FROM TBL_BIZMAN_ADINFO A
      JOIN #TEMP_OUT_USERID	B ON A.UserID = B.UserID
GO
/****** Object:  StoredProcedure [dbo].[BAT_SM_SALE_RAW_FINDALLKEYWORD_PROC]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BAT_SM_SALE_RAW_FINDALLKEYWORD_PROC]
AS

SET NOCOUNT ON
--키워드

SELECT
       A.KWCODE AS ADID,
       A.CODE AS PAYMENT_ID,
       A.USERID,
       A.PAYDATE,
       A.INIPAYTID AS PAY_ID,
       A.ORIGINPRICE AS TOTALAMT,
       CASE
            WHEN A.INIPAYTID IS NULL THEN '통장입금'
            WHEN A.PAYMETHOD=1 THEN '가상계좌'
            WHEN A.PAYMETHOD=2 THEN '카드'
            WHEN A.PAYMETHOD=3 THEN '휴대폰'
       END AS PAYMENTTYPECODE,
       'P'+CAST(K.KWGRADE AS VARCHAR)+CAST(A.GOODGUBUN AS VARCHAR)+CAST(A.PERIOD AS VARCHAR) AS PROD_CD
  INTO #EEE
  FROM FINDDB7.KEYWORDSHOP.DBO.TBL_KEYWORD_ADINFO AS A
  LEFT JOIN FINDDB7.KEYWORDSHOP.DBO.TBL_KEYWORD AS K ON K.KWCODE=A.KWCODE
 WHERE A.PAYSTATE='Y'
   AND A.PAYMETHOD IN ('1','2','3')
   AND A.BRANCHCODE IS NULL
   AND DATEDIFF(DAY,A.PAYDATE, GETDATE())=1
   --AND A.PAYDATE>'2008/01/01'
   --AND A.PAYDATE<CONVERT(VARCHAR(10),GETDATE(),111)


--추출
INSERT FINDDB2.FINDCOMMON.DBO.SM_SALE_RAW_TB (
       SECTION_CD,
       SUB_SECTION_CD,
       PROD_TYPE_CD,
       PROD_CD,
       PROD_NM,
       PAY_CONDITION_NM,
       ORDER_ID,
       ADID,
       USERID,
       PAY_REG_DT,
       SALEPATH_CD,
       PAY_TYPE_NM,
       CNT,
       AMT,
       TOTAL_AMT,
       PAY_ID )
SELECT
       'S101' AS SECTION_CD,
       'www' AS SUB_SECTION_CD,
       P.PROD_TYPE_CD,
       A.PROD_CD AS PROD_CD,
       P.PROD_NM AS PROD_NM,
       '정상' AS PAY_CONDITION_NM,
       A.PAYMENT_ID AS ORDER_ID,
       A.ADID AS ADID,
       A.USERID AS USERID,
       CAST(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(20),A.PAYDATE,120),':',''),'-',''),' ','') AS CHAR(12)) AS PAY_REG_DT,
       'SP01' AS SALEPATH_CD,
       A.PAYMENTTYPECODE AS PAY_TYPE_NM,
       1 AS CNT,
       P.PRICE AS AMT,
       A.TOTALAMT AS TOTAL_AMT,
       A.PAY_ID AS PAY_ID
  FROM #EEE AS A
  LEFT JOIN CC_PRODUCT_TB AS P ON P.PROD_CD=A.PROD_CD
 WHERE P.USE_YN='Y' AND A.TOTALAMT>0
 ORDER BY A.ORDER_ID DESC


--비즈맨

SELECT
       A.CODE AS ADID,
       A.CODE AS PAYMENT_ID,
       A.USERID,
       A.PAYDATE,
       A.INIPAYTID AS PAY_ID,
       A.ORIGINPRICE AS TOTALAMT,
       CASE
            WHEN A.INIPAYTID IS NULL THEN '통장입금'
            WHEN A.PAYMETHOD=1 THEN '가상계좌'
            WHEN A.PAYMETHOD=2 THEN '카드'
            WHEN A.PAYMETHOD=3 THEN '휴대폰'
       END AS PAYMENTTYPECODE,
       'P001' AS PROD_CD
  INTO #FFF
  FROM FINDDB7.KEYWORDSHOP.DBO.TBL_BIZMAN_ADINFO AS A
 WHERE A.PAYSTATE='Y'
   AND A.PAYMETHOD IN ('1','2','3')
   AND A.BRANCHCODE IS NULL
   AND DATEDIFF(DAY,A.PAYDATE, GETDATE())=1
   --AND A.PAYDATE>'2008/01/01'
   --AND A.PAYDATE<CONVERT(VARCHAR(10),GETDATE(),111)



--추출
INSERT FINDDB2.FINDCOMMON.DBO.SM_SALE_RAW_TB (
       SECTION_CD,
       SUB_SECTION_CD,
       PROD_TYPE_CD,
       PROD_CD,
       PROD_NM,
       PAY_CONDITION_NM,
       ORDER_ID,
       ADID,
       USERID,
       PAY_REG_DT,
       SALEPATH_CD,
       PAY_TYPE_NM,
       CNT,
       AMT,
       TOTAL_AMT,
       PAY_ID )
SELECT
       'S101' AS SECTION_CD,
       'www' AS SUB_SECTION_CD,
       P.PROD_TYPE_CD,
       A.PROD_CD AS PROD_CD,
       P.PROD_NM AS PROD_NM,
       '정상' AS PAY_CONDITION_NM,
       A.PAYMENT_ID AS ORDER_ID,
       A.ADID AS ADID,
       A.USERID AS USERID,
       CAST(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(20),A.PAYDATE,120),':',''),'-',''),' ','') AS CHAR(12)) AS PAY_REG_DT,
       'SP01' AS SALEPATH_CD,
       A.PAYMENTTYPECODE AS PAY_TYPE_NM,
       1 AS CNT,
       P.PRICE AS AMT,
       A.TOTALAMT AS TOTAL_AMT,
       A.PAY_ID AS PAY_ID
  FROM #FFF AS A
  LEFT JOIN CC_PRODUCT_TB AS P ON P.PROD_CD=A.PROD_CD
 WHERE P.USE_YN='Y' AND A.TOTALAMT>0
 ORDER BY A.ORDER_ID DESC
GO
/****** Object:  StoredProcedure [dbo].[CUID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:22:57 ******/
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
	
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_tax A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_BizManSendMailLog01 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_BizManSendMailLog A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_BizManSendMailLog02 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_RecmAd A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_bizman_adinfo A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_keyword_adinfo A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_keyword_adinfo2 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_KShopSendMailLog A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_KShopSendMailLog01 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_KShopSendMailLog02 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM tbl_qna A  where CUID=@SLAVE_CUID
	/*
	INSERT CUID_CHANGE_HISTORY_TB (B_CUID, N_CUID, USERID, DB_NAME, USERIP)
		SELECT @MASTER_CUID , @SLAVE_CUID,@MASTER_USERID,DB_NAME(),@CLIENT_IP
*/		
END







GO
/****** Object:  StoredProcedure [dbo].[dn_gongji_list]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 닷넷-테스트
	제작자		: 고병호
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터
******************************************************************************/
CREATE PROCEDURE [dbo].[dn_gongji_list]


	@sYY	int = 0,
	@sMM	int = 0,
	@sDD	int = 0,
	@eYY	int = 0,
	@eMM	int = 0,
	@eDD	int = 0
	,@s_date		varchar(10) = ''
	,@e_date		varchar(10) = ''


	,@gotopage		int = 0
	,@sText			varchar(30) = ''
	,@sSearch		varchar(10) = ''

	,@toppage		int = 1
	,@check_cnt		int = 1



AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(1000)



	if @check_cnt = '0'
		begin
			SET @Sql = 'select count(num) from tbl_gongji with (noLock)  '
		end
	else
		begin
			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' * from tbl_gongji with (noLock)  '
		end

-------------------------------------------------------------------------------------------------------------------------


	SET @Sql = @Sql + ' where title <> '''' '



	if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
		begin
			SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
		end


	if @s_date <> '' and @e_date <> ''
			begin
				SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
				SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
			end
		else
			begin
				if @s_date <> '' and @e_date = ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
					end
				else
					begin
						if @s_date = '' and @e_date = ''
							begin
								SET @sql = @sql + ' '
							end
						else
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
							end
					end
			end


--// -----------------------------------------------------------------------------------------------------------------
	if @check_cnt = '1'
		begin
			SET @Sql = @Sql +' order by num desc'
		end


--print(@sql)
	EXECUTE(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[dn_mag_login]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dn_mag_login]
	(
		@txtAdminID			varchar(15),
		@txtAdminPassword	varchar(15)

	)
AS
	--SET NOCOUNT ON

	DECLARE @TempID varchar(15)
	set @tempID = ''
	SELECT @TempID = id FROM tbl_admin with (noLock)
			WHERE id = @txtAdminID and pwd = @txtAdminPassword

  IF @TempID IS NULL or @TempID = ''
	RETURN 0
     ELSE
	RETURN 2
GO
/****** Object:  StoredProcedure [dbo].[dn_postbanner_keyword_detail]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dn_postbanner_keyword_detail]

	@hclass		char(1) = ''
	,@code		int = 1

AS
	SET NOCOUNT ON

	DECLARE @Sql		varchar(1000)


	SET @Sql = 'select top 1 '
	SET @Sql = @Sql + ' a.code, a.branchcode,  a.userid, a.username, a.id, a.name, a.kwcode, a.kwname, a.goodgubun, a.goodRank, '
	SET @Sql = @Sql + '	a.startday, a.endday,a.adTitle, a.adContent, a.adimg, a.adUrl,a.usedType,'
	SET @Sql = @Sql + ' a.note, a.adState, a.payState, a.authDate, a.regDate,'
	SET @Sql = @Sql + ' a.isService, a.serviceNm, a.authState,'

	if @hclass ='f'
		begin
			SET @Sql = @Sql + ' c.readCnt '
		end
	else
		begin
			SET @Sql = @Sql + ' c.readCnt, a.clickCnt '
		end

	SET @Sql = @Sql + ' from tbl_keyword_adinfo a '



	if @hclass <> 'f'
		begin
			SET @Sql = @Sql + ' INNER JOIN tbl_keyword k ON a.kwcode = k.kwcode '
		end


	SET @Sql = @Sql + ' left outer JOIN tbl_kwcnt c ON a.kwcode = c.kwcode '
	SET @Sql = @Sql + ' where a.code = '''+CAST(@code AS varCHAR(5)) + ''' '

	--print(@sql)

	Execute(@sql)
GO
/****** Object:  StoredProcedure [dbo].[dn_postbanner_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고관리 리스트
	제작자		: 고병호
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터

******************************************************************************/
CREATE PROCEDURE [dbo].[dn_postbanner_list_01]

	@sYY			char(4) = ''
	,@sMM			char(2) = ''
	,@sDD			char(4) = ''
	,@eYY			char(4) = ''
	,@eMM			char(2) = ''
	,@eDD			char(2) = ''
	,@s_date		char(10) = ''
	,@e_date		char(10) = ''
	,@gotopage		int = 0
	,@DateSearch	varchar(10)	= ''
	,@sText			varchar(30)	= ''
	,@sSearch		varchar(10)	= ''
	,@toppage		int = 1
	,@check_cnt		int = 1
	,@hclass		char(1)
	,@sgoodRank		char(1)
	,@sAdState		char(1)
	,@sPayState		char(1)
	,@smember		char(1)
	,@sUsedType		char(1)
	,@sgoodGubun	char(1)

AS
	SET NOCOUNT ON

	BEGIN
	DECLARE
		@Sql		varchar(1000)

	--	@TempID		int
	--	SET @TempID = 1


	if @check_cnt = '1'
		begin
			SET @Sql = 'select count(code) as totalCnt from tbl_keyword_adinfo a with (noLock)  '
		end
	else
		begin








			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' '
			--SET @Sql = 'select top 20 '
			SET @Sql = @sql + ' a.code, a.adUrl, a.userid, a.username, a.id, a.name, a.kwcode, a.goodgubun, a.goodRank, '

			SET @Sql = @sql + ' Convert(varchar(10), a.startday, 102) as startday, Convert(varchar(10), a.endday, 102) as endday,  '
			SET @Sql = @sql + ' a.adTitle, a.usedType,  (Case  when a.isExtend = 0 then ''신규'' when a.isExtend = 1 then ''연장'' end) as isExtend, '
			SET @Sql = @sql + ' a.payMethod, dbo.dn_f_payState(a.payState) as payState, a.adState, a.authState, '
			SET @Sql = @sql + ' CONVERT(varchar(10), a.authDate, 102) as authDate,  CONVERT(varchar(10), a.regDate, 120) as regDAte, '
			SET @Sql = @sql + ' a.branchcode, a.kwname, a.isService '
			SET @Sql = @sql + ' from tbl_keyword_adinfo a with (noLock) '


		end

-------------------------------------------------------------------------------------------------------------------------


		SET @Sql = @Sql + ' where a.code <> '''' '

		SET @Sql = @Sql + ' and goodgubun = '''+@sgoodgubun+''' '

		if @sgoodRank <> ''		-- 위치
			begin
				SET @Sql = @Sql + ' and goodRank = '''+@sgoodRank+''' '

			end

		if @sAdState <> ''		-- 광고 상태
			begin
				SET @Sql = @Sql + ' and adState = '''+@sAdState+''' '
			end


		if @sPayState <> ''		-- 결제상태
			begin
				SET @Sql = @Sql + ' and payState = '''+@spayState+''' '
			end

		if @smember <> ''		-- 등록자
			begin
				if @smember = '1'		-- 회원
					begin
						SET @Sql = @Sql + ' and userid <> '''' and (branchcode = '''' or branchcode is null) '
					end
				else
					begin
						SET @Sql = @Sql + ' and  branchcode <> '''' '
					end
			end


		if @susedType <> ''		--// 생활광고에 대한 찾기
			begin
				SET @Sql = @Sql + ' and  UsedType = '''+@sUsedType+''' '
			end


		if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
			begin
				SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
			end


	if @s_date <> '' and @e_Date <> ''
		begin

			if @DateSearch  = 'regdate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
		end

--// -----------------------------------------------------------------------------------------------------------------
		if @check_cnt = '0'

		--	if @hclass = 'f'
				begin
					SET @Sql = @Sql +' order by a.regdate desc'
				end
		--	else
		--		begin
		--			SET @Sql = @Sql +' order by a.paydate desc'
		--		end

/*
		if @check_cnt = '1'
			begin
				IF @TempID is Null or @TempID < 1
					RETURN 0
				else
					RETURN @TempID
			end
*/
	END

--print(@sql)
	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[dn_postbanner_list_call_action]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dn_postbanner_list_call_action]
	(
		@cb_num			varchar(50),
		@call_action	varchar(10)
	)
AS
	SET NOCOUNT ON
	DECLARE @sql	varchar(100)


	SET @sql = 'update tbl_keyword_adinfo '

	IF (@call_action = 'b_submit')
		BEGIN
			SET @sql = @sql + ' set adState = ''Y'' '
		END
	--ELSE IF (

	SET @sql = @sql + 'where code in (@cb_num)'
GO
/****** Object:  StoredProcedure [dbo].[F_GET_TAXKEYWORD_LIST]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--키워드 세금계산서 프론트
CREATE PROC [dbo].[F_GET_TAXKEYWORD_LIST]
    @USERID     VARCHAR(30)
AS

DECLARE @ERROR 		INT
DECLARE @ROWCOUNT 	INT

SET NOCOUNT ON

SELECT
    ADID,
    GOODNAME,
    PAYMENTDATE,
    PRICE,
    CHARGEKIND,
    CHECKDATE,
    TAXRESDATE,
    IDX,
    TAXFLAG,
    GOODSTYPE,
    USERID,
    ADGBN,
    PAYMENTID,
    STDATE,
    ENDATE,
    MONTHCLOSE,
    EDTPRICE,
    ISSUEKEY
INTO #AAA
FROM
(
	SELECT
		K.CODE AS ADID,
		CASE
			WHEN K.GOODGUBUN='1' THEN '스폰서 배너'
			WHEN K.GOODGUBUN='2' THEN '스폰서 홈페이지'
			WHEN K.GOODGUBUN='3' THEN '생활 광고'
		END AS GOODNAME,
		CASE
			WHEN K.PAYDATE IS NOT NULL THEN K.PAYDATE
			ELSE K.REGDATE
		END AS PAYMENTDATE,
		K.ORIGINPRICE							AS PRICE,
		K.PAYMETHOD								AS CHARGEKIND,
		R.TAXCHECKDATE 							AS CHECKDATE,
		R.TAXRESDATE 							AS TAXRESDATE,
		R.IDX									AS IDX,
		R.TAXFLAG								AS TAXFLAG,
		'K' 									AS GOODSTYPE,
		K.USERID 								AS USERID,
		1 										AS ADGBN, 								--ADGBN
		K.CODE		 							AS PAYMENTID,
		K.STARTDAY								AS STDATE,
		K.ENDDAY								AS ENDATE,
        DBO.FN_CHKMONTH(CONVERT(VARCHAR(10),COALESCE(K.PAYDATE, K.REGDATE),112),CONVERT(VARCHAR(10),GETDATE(),112)) AS MONTHCLOSE,
        ISNULL(L.PRICE,0)                       AS EDTPRICE,
        ISNULL(L.PKEY,0)                        AS ISSUEKEY
	FROM TBL_KEYWORD_ADINFO AS K WITH (NOLOCK)
	LEFT JOIN RECEIPTREQUEST AS RR WITH (NOLOCK) ON RR.GRPSERIAL=K.CODE AND RR.ADGBN=2 AND RR.DELFLAG=0
	LEFT JOIN FINDDB2.FINDCOMMON.DBO.TAXREQUEST AS R ON R.ADID=K.CODE AND K.CODE=R.GRPSERIAL AND R.SITEGBN IN ('KEYWORD','MAGKEYWORD') AND R.ADGBN=1
    LEFT JOIN FINDDB2.FINDCOMMON.DBO.TAXISSUE_LOG AS L ON L.TAXREQUESTKEY=R.IDX
	WHERE
--		K.PAYSTATE='Y'
--		AND K.PAYMETHOD IN ('1','2','3')
--		AND K.BRANCHCODE IS NULL
--		AND K.USERID=@USERID
		K.USERID=@USERID
--		AND RR.GRPSERIAL IS NULL
--		AND COALESCE(K.PAYDATE, K.REGDATE) BETWEEN DBO.QUARTER_STARTDT(CONVERT(VARCHAR(10),GETDATE(),111)) AND GETDATE()




	UNION ALL

	SELECT
		B.CODE AS ADID,
		'비즈맨 광고' AS GOODNAME,
		CASE
			WHEN B.PAYDATE IS NOT NULL THEN B.PAYDATE
			ELSE B.REGDATE
		END AS PAYMENTDATE,
		B.ORIGINPRICE							AS PRICE,
		B.PAYMETHOD								AS CHARGEKIND,
		R.TAXCHECKDATE 							AS CHECKDATE,
		R.TAXRESDATE 							AS TAXRESDATE,
		R.IDX									AS IDX,
		R.TAXFLAG								AS TAXFLAG,
		'B' 									AS GOODSTYPE,
		B.USERID 								AS USERID,
		2 										AS ADGBN, 								--ADGBN
		B.CODE		 							AS PAYMENTID,
		B.STARTDAY								AS STDATE,
		B.ENDDAY								AS ENDATE,
        DBO.FN_CHKMONTH(CONVERT(VARCHAR(10),COALESCE(B.PAYDATE, B.REGDATE),112),CONVERT(VARCHAR(10),GETDATE(),112)) AS MONTHCLOSE,
        ISNULL(L.PRICE,0)                       AS EDTPRICE,
        ISNULL(L.PKEY,0)                        AS ISSUEKEY
	FROM TBL_BIZMAN_ADINFO AS B WITH (NOLOCK)
	LEFT JOIN RECEIPTREQUEST AS RR WITH (NOLOCK) ON RR.GRPSERIAL=B.CODE AND RR.ADGBN=3 AND RR.DELFLAG=0
	LEFT JOIN FINDDB2.FINDCOMMON.DBO.TAXREQUEST AS R ON R.ADID=B.CODE AND B.CODE=R.GRPSERIAL AND R.SITEGBN IN ('KEYWORD','MAGKEYWORD') AND R.ADGBN=2
    LEFT JOIN FINDDB2.FINDCOMMON.DBO.TAXISSUE_LOG AS L ON L.TAXREQUESTKEY=R.IDX
   WHERE
	 	B.PAYSTATE='Y'
		AND B.PAYMETHOD IN ('1','2','3')
--		AND B.BRANCHCODE IS NULL
--		AND B.USERID=@USERID
		AND RR.GRPSERIAL IS NULL
		AND COALESCE(B.PAYDATE, B.REGDATE) BETWEEN DBO.QUARTER_STARTDT(CONVERT(VARCHAR(10),GETDATE(),111)) AND GETDATE()
) AS T
WHERE PRICE>0

SELECT @ERROR=@@ERROR,@ROWCOUNT=@@ROWCOUNT
IF @ERROR<>0
BEGIN
	RETURN (2)
END

--SELECT @ROWCOUNT	--레코드 카운트

DECLARE @STRSQL NVARCHAR(4000)

SELECT
	   ADID
	 , GOODNAME
         , RIGHT(REPLACE(CONVERT(VARCHAR(10), PAYMENTDATE, 111), '-', '/'), 8) AS PAYMENTDATE
	 , PRICE
	 , CHARGEKIND
         , RIGHT(REPLACE(CONVERT(VARCHAR(10), CHECKDATE, 111), '-', '/'), 8) AS CHECKDATE
	 , IDX
	 , TAXFLAG
         , RIGHT(REPLACE(CONVERT(VARCHAR(10), TAXRESDATE, 111), '-', '/'), 8) AS TAXRESDATE
	 , GOODSTYPE
	 , USERID
	 , ADGBN
	 , PAYMENTID
	 , CONVERT(VARCHAR(10), STDATE, 111) AS STDATE
	 , CONVERT(VARCHAR(10), ENDATE, 111) AS ENDATE
	 , MONTHCLOSE
	 , EDTPRICE
	 , ISSUEKEY
  FROM #AAA
 ORDER BY PAYMENTDATE DESC

SELECT @ERROR=@@ERROR,@ROWCOUNT=@@ROWCOUNT
IF @ERROR<>0
BEGIN
	RETURN (3)
END


RETURN (0)
GO
/****** Object:  StoredProcedure [dbo].[GET_CM_KEYWORD_SELECT_PROC]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: 검색 페이지 스폰서 광고 가져오기
	제작자		: 최병찬
	제작일		: 2008.04.28
	example     : GET_CM_KEYWORD_SELECT_PROC '선원'
******************************************************************************/

CREATE PROC [dbo].[GET_CM_KEYWORD_SELECT_PROC]
(
	@KWNAME	    VARCHAR(30)	= '',
	@OUTPRM		INT 		= 0
)

AS

SET NOCOUNT ON
BEGIN
	SET @KWNAME = REPLACE(@KWNAME , ' ', '')

	DECLARE
		@SQL		  VARCHAR(500),
		@SZKWNAME	  VARCHAR(30),
		@KWCODE	      INT

	SET @SZKWNAME	= ''
	SET @KWCODE = 0

	IF @KWNAME = ''
	BEGIN
		SET @OUTPRM = 0
		RETURN
	END

	-- 유의어 검색
	SELECT TOP 1 @KWCODE = KWCODE FROM TBL_SIMILARKW WITH (NOLOCK) WHERE SIMILARKWNAME = ''+@KWNAME+''

	IF (@KWCODE IS NULL) OR (@KWCODE = 0)
		BEGIN
			SELECT TOP 1 @KWCODE = KWCODE FROM TBL_KEYWORD WITH (NOLOCK) WHERE KWNAME = ''+@KWNAME+''
			SET @OUTPRM = @KWCODE
		END
	ELSE
		BEGIN
			SELECT TOP 1 @KWCODE = KWCODE FROM TBL_KEYWORD WITH (NOLOCK) WHERE KWCODE = @KWCODE
			SET @OUTPRM = @KWCODE
		END

	SET @SZKWNAME = @KWNAME

	IF (@KWCODE IS NULL) OR (@KWCODE = 0)
		BEGIN
			SET @KWCODE = 0
		END
	ELSE
		BEGIN
			--노출수 증가
			UPDATE TBL_KEYWORD SET READCNT = READCNT + 1 WHERE KWCODE = @KWCODE
			UPDATE TBL_KEYWORD_ADINFO SET READCNT = READCNT + 1 WHERE KWCODE = @KWCODE AND ADSTATE = 'Y' AND GOODGUBUN < '4'		--노출수 증가
	END

	--스폰서 배너
	SELECT CODE,KWNAME,GOODGUBUN,GOODRANK,ADTITLE,ADCONTENT,ADURL,ADIMG,KWCODE,REGDATE,ICONFILENAME,ISNULL(DTLTITLE,'') DTLTITLE  FROM TBL_KEYWORD_ADINFO WITH (NOLOCK)
	 WHERE KWCODE = @KWCODE AND ADSTATE = 'Y' AND GOODGUBUN = '1'
         ORDER BY GOODRANK
	--스폰서 홈페이지
	SELECT CODE,KWNAME,GOODGUBUN,GOODRANK,ADTITLE,ADCONTENT,ADURL,ADIMG,KWCODE,REGDATE,ICONFILENAME,ISNULL(DTLTITLE,'') DTLTITLE  FROM TBL_KEYWORD_ADINFO WITH (NOLOCK)
	WHERE KWCODE = @KWCODE AND ADSTATE = 'Y' AND GOODGUBUN = '2'
         ORDER BY GOODRANK
	--스폰서 생활광고
	SELECT CODE,KWNAME,GOODGUBUN,GOODRANK,ADTITLE,ADCONTENT,ADURL,ADIMG,KWCODE,REGDATE,ICONFILENAME,ISNULL(DTLTITLE,'') DTLTITLE  FROM TBL_KEYWORD_ADINFO WITH (NOLOCK)
	WHERE KWCODE = @KWCODE AND ADSTATE = 'Y' AND GOODGUBUN = '3'
         ORDER BY GOODRANK

END
GO
/****** Object:  StoredProcedure [dbo].[Proc_TaxVill_BizManView]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_TaxVill_BizManView]
@Adid 		int,
@StartDate	varchar(10),
@EndDate	varchar(10)
as
DECLARE @ERROR 		int
DECLARE @ROWCOUNT 	int

SET NOCOUNT ON

select
	B.Code as ADID,
	'비즈맨 광고' as GoodName,
	Case
		when B.PayDate is not null then B.PayDate
		else B.RegDate
	end as PaymentDate,
	B.OriginPrice							as Price,
	B.PayMethod								as ChargeKind,
	R.TaxCheckDate 							as CheckDate,
	R.TaxResDate 							as TaxResDate,
	R.Idx									as Idx,
	R.TaxFlag								as TaxFlag,
	'B' 									as GoodsType,
	B.Userid 								as Userid,
	2 										as ADGbn, 								--Adgbn
	B.Code		 							as PaymentID,
	B.StartDay								as StDate,
	B.EndDay								as EnDate
from tbl_BizMan_AdInfo as B WITH (NOLOCK)
left join ReceiptRequest as RR WITH (NOLOCK) on RR.GrpSerial=B.Code and RR.AdGbn=3 and RR.DelFlag=0
left join FindDB2.FindCommon.dbo.TaxRequest as R on R.Adid=B.Code and B.Code=R.GrpSerial and R.SiteGbn in ('KeyWord','MagKeyWord') and R.AdGbn=2
where
	B.PayState='Y'
	AND B.PayMethod IN ('1','2','3')
	AND B.BranchCode IS Null
	AND B.Code=@Adid
	AND RR.GrpSerial is Null
	AND COALESCE(B.PayDate, B.RegDate)>@STARTDATE
	AND COALESCE(B.PayDate, B.RegDate)<@ENDDATE


select @ERROR=@@ERROR,@ROWCOUNT=@@ROWCOUNT
if @ERROR<>0
begin
	RETURN (2)
end
if @ROWCOUNT=0
begin
	RETURN (1)
	--현금영수증 발행했거나 분기별 신청시한이 지났거나 둘 중 하나
end


RETURN (0)
GO
/****** Object:  StoredProcedure [dbo].[Proc_TaxVill_KeyWordView]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_TaxVill_KeyWordView]
@Adid 		int,
@StartDate	varchar(10),
@EndDate	varchar(10)
as
DECLARE @ERROR 		int
DECLARE @ROWCOUNT 	int

SET NOCOUNT ON

select
	K.Code as ADID,
	CASE
		WHEN K.goodGubun='1' THEN '스폰서 배너'
		WHEN K.goodGubun='2' THEN '스폰서 홈페이지'
		WHEN K.goodGubun='3' THEN '생활 광고'
	END As GoodName,
	Case
		when K.PayDate is not null then K.PayDate
		else K.RegDate
	end as PaymentDate,
	K.OriginPrice							as Price,
	K.PayMethod								as ChargeKind,
	R.TaxCheckDate 							as CheckDate,
	R.TaxResDate 							as TaxResDate,
	R.Idx									as Idx,
	R.TaxFlag								as TaxFlag,
	'K' 									as GoodsType,
	K.Userid 								as Userid,
	1 										as ADGbn, 								--Adgbn
	K.Code		 							as PaymentID,
	K.StartDay								as StDate,
	K.EndDay								as EnDate
from tbl_KeyWord_AdInfo as K WITH (NOLOCK)
left join ReceiptRequest as RR WITH (NOLOCK) on RR.GrpSerial=K.Code and RR.AdGbn=2 and RR.DelFlag=0
left join FindDB2.FindCommon.dbo.TaxRequest as R on R.Adid=K.Code and K.Code=R.GrpSerial and R.SiteGbn in ('KeyWord','MagKeyWord') and R.AdGbn=1
where
	K.PayState='Y'
	AND K.PayMethod IN ('1','2','3')
	AND K.BranchCode IS Null
	AND K.Code=@Adid
	AND RR.GrpSerial is Null
	AND COALESCE(K.PayDate, K.RegDate)>@STARTDATE
	AND COALESCE(K.PayDate, K.RegDate)<@ENDDATE


select @ERROR=@@ERROR,@ROWCOUNT=@@ROWCOUNT
if @ERROR<>0
begin
	RETURN (2)
end
if @ROWCOUNT=0
begin
	RETURN (1)
	--현금영수증 발행했거나 분기별 신청시한이 지났거나 둘 중 하나
end


RETURN (0)
GO
/****** Object:  StoredProcedure [dbo].[Proc_TaxVillView_KeyWord]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_TaxVillView_KeyWord]
@Page		int,
@PageSize	int,
@Userid 	varchar(30),
@StartDate	varchar(10),
@EndDate	varchar(10)
as
DECLARE @ERROR 		int
DECLARE @ROWCOUNT 	int

SET NOCOUNT ON

select
ADID,
GoodName,
PaymentDate,
Price,
ChargeKind,
CheckDate,
TaxResDate,
Idx,
TaxFlag,
GoodsType,
UserID,
AdGbn,
PaymentID,
StDate,
EnDate
into #AAA
From
(
	select
		K.Code as ADID,
		CASE
			WHEN K.goodGubun='1' THEN '스폰서 배너'
			WHEN K.goodGubun='2' THEN '스폰서 홈페이지'
			WHEN K.goodGubun='3' THEN '생활 광고'
		END As GoodName,
		Case
			when K.PayDate is not null then K.PayDate
			else K.RegDate
		end as PaymentDate,
		K.OriginPrice							as Price,
		K.PayMethod								as ChargeKind,
		R.TaxCheckDate 							as CheckDate,
		R.TaxResDate 							as TaxResDate,
		R.Idx									as Idx,
		R.TaxFlag								as TaxFlag,
		'K' 									as GoodsType,
		K.Userid 								as Userid,
		1 										as ADGbn, 								--Adgbn
		K.Code		 							as PaymentID,
		K.StartDay								as StDate,
		K.EndDay								as EnDate
	from tbl_KeyWord_AdInfo as K WITH (NOLOCK)
	left join ReceiptRequest as RR WITH (NOLOCK) on RR.GrpSerial=K.Code and RR.AdGbn=2 and RR.DelFlag=0
	left join FindDB2.FindCommon.dbo.TaxRequest as R on R.Adid=K.Code and K.Code=R.GrpSerial and R.SiteGbn in ('KeyWord','MagKeyWord') and R.AdGbn=1
	where
		K.PayState='Y'
		AND K.PayMethod IN ('1','2','3')
		AND K.BranchCode IS Null
		AND K.Userid=@Userid
		AND RR.GrpSerial is Null
		AND COALESCE(K.PayDate, K.RegDate)>@STARTDATE
		AND COALESCE(K.PayDate, K.RegDate)<@ENDDATE
	Union All
	select
		B.Code as ADID,
		'비즈맨 광고' as GoodName,
		Case
			when B.PayDate is not null then B.PayDate
			else B.RegDate
		end as PaymentDate,
		B.OriginPrice							as Price,
		B.PayMethod								as ChargeKind,
		R.TaxCheckDate 							as CheckDate,
		R.TaxResDate 							as TaxResDate,
		R.Idx									as Idx,
		R.TaxFlag								as TaxFlag,
		'B' 									as GoodsType,
		B.Userid 								as Userid,
		2 										as ADGbn, 								--Adgbn
		B.Code		 							as PaymentID,
		B.StartDay								as StDate,
		B.EndDay								as EnDate
	from tbl_BizMan_AdInfo as B WITH (NOLOCK)
	left join ReceiptRequest as RR WITH (NOLOCK) on RR.GrpSerial=B.Code and RR.AdGbn=3 and RR.DelFlag=0
	left join FindDB2.FindCommon.dbo.TaxRequest as R on R.Adid=B.Code and B.Code=R.GrpSerial and R.SiteGbn in ('KeyWord','MagKeyWord') and R.AdGbn=2
	where
		B.PayState='Y'
		AND B.PayMethod IN ('1','2','3')
		AND B.BranchCode IS Null
		AND B.Userid=@Userid
		AND RR.GrpSerial is Null
		AND COALESCE(B.PayDate, B.RegDate)>@STARTDATE
		AND COALESCE(B.PayDate, B.RegDate)<@ENDDATE
) as T
where Price>0

select @ERROR=@@ERROR,@ROWCOUNT=@@ROWCOUNT
if @ERROR<>0
begin
	RETURN (2)
end

SELECT @ROWCOUNT	--레코드 카운트

DECLARE @STRSQL nvarchar(4000)

SET @STRSQL='SELECT Top ' +  CONVERT(varchar(10),@Page * @PageSize) +
			'ADID, GoodName, Convert(varchar(10),PaymentDate,111) as PaymentDate, Price, ChargeKind, convert(varchar(10), CheckDate, 11) as CheckDate, Idx, TaxFlag, convert(varchar(10), TaxResDate, 11) as TaxResDate, GoodsType, UserID, AdGbn, PaymentID, convert(varchar(10), StDate, 111) as StDate, convert(varchar(10), EnDate, 111) as EnDate '+
			'From #AAA Order by PaymentDate DESC'

EXEC sp_EXECUTESQL @STRSQL

RETURN (0)
GO
/****** Object:  StoredProcedure [dbo].[procBizManSendMailLog01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: [비즈맨]키워드샵 연장 안내 메일 발송 대상리스트 출력 하는 프로시저
	제작자	: 정윤정
	제작일	: 2004-11-24

select * from  tbl_BizManSendMailLog01

select * from tbl_bizman_adinfo with(NoLock) where userid='yomico'
update tbl_BizManSendmailLog01 Set sendGbn='0' , useremail='yjcheong@mediawill-tech.com' where idx='42'
select * from tbl_bizman_adinfo with(NoLock) where userid='yomico'
*************************************************************************************/

CREATE PROCEDURE [dbo].[procBizManSendMailLog01]

AS

SELECT ML.Idx, Ad.Code, Ad.UserId ,ML.UserName, Ad.KwName,  ML.UserEmail ,
Ad.StartDay , Ad.EndDay
FROM  tbl_BizManSendMailLog01 AS ML  With(NoLock)
LEFT OUTER JOIN tbl_bizman_adinfo AS Ad With(NoLock)  ON ML.tbl_adinfo_Code = Ad.Code
JOIN tbl_bizman  As Kwd With(NOLock) ON Ad.kwCode =Kwd.kwCode
WHERE ML.SendGbn='0'
GO
/****** Object:  StoredProcedure [dbo].[procBizManSendMailLog02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: [비즈맨]키워드샵 마감 안내 메일 발송 대상리스트 출력 하는 프로시저
	제작자	: 정윤정
	제작일	: 2004-11-24

select * from  tbl_BizManSendMailLog02
select * from tbl_bizman with(NoLock) where userid='yomico'
update tbl_BizManSendMailLog02 Set sendGbn='0' , useremail='yjcheong@mediawill-tech.com' where idx='42'
select * from tbl_bizman with(NoLock) where userid='yomico'
*************************************************************************************/

CREATE PROCEDURE [dbo].[procBizManSendMailLog02]

AS

SELECT ML.Idx, Ad.Code, Ad.UserId ,ML.UserName,  Ad.KwName,  ML.UserEmail ,
Ad.StartDay , Ad.EndDay
FROM  tbl_BizManSendMailLog02 AS ML  With(NoLock)
LEFT OUTER JOIN tbl_bizman_adinfo AS Ad With(NoLock)  ON ML.tbl_adinfo_Code = Ad.Code
JOIN tbl_bizman  As Kwd With(NOLock) ON Ad.kwCode =Kwd.kwCode
WHERE ML.SendGbn='0'
GO
/****** Object:  StoredProcedure [dbo].[procKShopSendMailLog01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 키워드샵 연장 안내 메일 발송 대상리스트 출력 하는 프로시저
	제작자	: 박준희
	제작일	: 2004-07-22

select * from  tbl_KShopSendMailLog01

select * from tbl_keyword_adinfo with(NoLock) where userid='pcercle'
update tbl_kshopSendmailLog01 Set sendGbn='0' , useremail='juneep@mediawill-tech.com' where idx='42'
select * from tbl_keyword_adinfo with(NoLock) where userid='pcercle'
*************************************************************************************/

CREATE PROCEDURE [dbo].[procKShopSendMailLog01]

AS

SELECT ML.Idx, Ad.Code, Ad.UserId ,ML.UserName, Ad.GoodGubun, Ad.KwName,  ML.UserEmail ,
Ad.StartDay , Ad.EndDay,ISNULL(Ad.ServiceNm , '') ServiceNm  ,Kwd.RelationKw
FROM  tbl_KShopSendMailLog01 AS ML  With(NoLock)
LEFT OUTER JOIN tbl_Keyword_adinfo AS Ad With(NoLock)  ON ML.tbl_adinfo_Code = Ad.Code
JOIN tbl_keyword  As Kwd With(NOLock) ON Ad.kwCode =Kwd.kwCode
WHERE ML.SendGbn='0'
GO
/****** Object:  StoredProcedure [dbo].[procKShopSendMailLog02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 키워드샵 마감 안내 메일 발송 대상리스트 출력 하는 프로시저
	제작자	: 박준희
	제작일	: 2004-07-22

select * from  tbl_KShopSendMailLog02
select * from tbl_keyword_adinfo with(NoLock) where userid='pcercle'
update tbl_kshopSendmailLog02 Set sendGbn='0' , useremail='juneep@mediawill-tech.com' where idx='42'
select * from tbl_keyword_adinfo with(NoLock) where userid='pcercle'
*************************************************************************************/

CREATE PROCEDURE [dbo].[procKShopSendMailLog02]

AS

SELECT ML.Idx, Ad.Code, Ad.UserId ,ML.UserName, Ad.GoodGubun, Ad.KwName,  ML.UserEmail ,
Ad.StartDay , Ad.EndDay,ISNULL(Ad.ServiceNm , '') ServiceNm  ,Kwd.RelationKw
FROM  tbl_KShopSendMailLog02 AS ML  With(NoLock)
LEFT OUTER JOIN tbl_Keyword_adinfo AS Ad With(NoLock)  ON ML.tbl_adinfo_Code = Ad.Code
JOIN tbl_keyword  As Kwd With(NOLock) ON Ad.kwCode =Kwd.kwCode
WHERE ML.SendGbn='0'
GO
/****** Object:  StoredProcedure [dbo].[procUserCommon_Cancel_FINDDB7]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procUserCommon_Cancel_FINDDB7]
AS

-- FINDDB2 에 있는 탈퇴회원 아이디 테이블을 가져온다.
-- FINDDB2 의 선행 프로시저 (procUserCommon_Cancel) 가 정상실행되지 않았을 경우 어제 데이터로 다시 업데이트를 하게 되므로 (동일한 아이디로 다른 사람이 가입한 경우 또 지워질 수도 있음)
-- 그런 경우를 방지하기 위해 오늘 날짜로 들어간 데이터만을 가져온다.
	SELECT UserID, Del_ID INTO #Temp_DelUserID FROM FINDDB2.Common.dbo.DelUserID_Daily WHERE RegDate > CONVERT(char(10),GETDATE(),120)


-- FINDDB7.KeyWordShop
	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	tbl_keyword_adinfo	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	dbo.tbl_bizman_adinfo A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID
GO
/****** Object:  StoredProcedure [dbo].[sp_AdCickCntPlus]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 검색 후 클릭수 증가
	제작자		: 정윤정
	제작일		: 2004.04.07
	수정자		:
	수정일		:
	수정내용	:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_AdCickCntPlus]
@code int,
@kwCode int
AS
SET NOCOUNT ON
	BEGIN
		UPDATE tbl_keyword_adinfo SET clickCnt = clickCnt + 1 WHERE code = @code
		UPDATE tbl_keyword SET clickCnt = clickCnt + 1 WHERE kwCode = @kwCode
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_AdFHallSearch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 무료홈페이지 통합검색 전체 결과
	제작자		: 정윤정
	제작일		: 2004.04.08
	수정자		:
	수정일		:
	수정내용	:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_AdFHallSearch]
(
	@topCnt int,
	@kwName	varchar(30)	= ''

)
AS
BEGIN
		declare @sql varchar(3000)
--		Set @sql = 'SELECT Top ' + @topCnt + ' Code,kwName,goodGubun,goodRank,adTitle,adContent,adUrl,adimg,kwCode,regdate from tbl_keyword_adinfo with (nolock) '
		Set @sql = 'SELECT Top ' + cast(@topCnt as varchar(20)) + ' adTitle,adContent,adUrl from tbl_keyword_adinfo with (nolock) '
		Set @sql = @sql + ' WHERE goodGubun = 4 AND (adTitle like ''%'+@kwName+'%'' OR adContent like ''%'+@kwName+'%'') AND adState = ''Y'' ORDER BY code desc'

		execute(@sql)
--		print @sql
END
GO
/****** Object:  StoredProcedure [dbo].[sp_AdFHallSearchCnt]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 무료홈페이지 통합검색 전체 결과 개수
	제작자		: 정윤정
	제작일		: 2004.04.13
	수정자		:
	수정일		:
	수정내용	:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_AdFHallSearchCnt]
(
	@kwName	varchar(30)	= ''

)
AS
BEGIN
		declare @sql varchar(3000)
--		Set @sql = 'SELECT Top ' + @topCnt + ' Code,kwName,goodGubun,goodRank,adTitle,adContent,adUrl,adimg,kwCode,regdate from tbl_keyword_adinfo with (nolock) '
		Set @sql = 'SELECT count(code) from tbl_keyword_adinfo with (nolock) '
		Set @sql = @sql + ' WHERE goodGubun = 4 AND (adTitle like ''%'+@kwName+'%'' OR adContent like ''%'+@kwName+'%'') AND adState = ''Y'''

		execute(@sql)
--		print @sql
END
GO
/****** Object:  StoredProcedure [dbo].[sp_AdListinfo]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 검색 및 광고 신청 가능 검사
	제작자		: 이기운
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_AdListinfo]
(
	@kwCode		int			= 0,
	@kwName		varchar(30)	= '',
	@outprm		int 		= 0
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(1000)


	SET @Sql = 'SELECT p.kwcode,p.goodGubun,p.goodRank,'''+@kwName+''' as kwName,'
	SET @Sql = @Sql + ' dbo.F_AdState(adState,authState,s.goodGubun,s.goodRank) as AdMode,dbo.F_AdDate(adState,startDay,endDay) as adDay,IsNULL(endDay,'''') as endDay,cutPrice1,cutPrice3'
	SET @Sql = @Sql + ' FROM tbl_kwPrice as p WITH (NOLOCK) '
	SET @Sql = @Sql + ' LEFT OUTER JOIN (SELECT code, kwCode,goodGubun,goodRank,startDay,endDay,adState,authState FROM tbl_keyword_adinfo WITH (NOLOCK) where kwcode = '+Cast(@kwCode as varchar)+' and adState in (''N'',''Y'',''C'',''M'')) as a '
	SET @Sql = @Sql + ' ON p.kwcode = a.kwcode and p.goodGubun = a.goodGubun and p.goodRank = a.goodRank'
	SET @Sql = @Sql + ' LEFT OUTER JOIN (SELECT kwCode,goodGubun,goodRank FROM tbl_Session WITH (NOLOCK) WHERE kwcode = '+Cast(@kwCode as varchar)+' and datediff(minute,startTime, getdate()) < 30) as s '
	SET @Sql = @Sql + ' ON p.kwcode = s.kwcode and p.goodGubun = s.goodGubun and p.goodRank = s.goodRank'
	SET @Sql = @Sql + ' WHERE p.kwcode = '+Cast(@kwCode as varchar)+' AND datediff(m,p.regdate,getdate()) = 0  AND NOT  ( (p.GoodGubun=''1'' AND p.GoodRank=''4'') OR p.GoodGubun=''3'' ) '
	SET @Sql = @Sql + ' ORDER BY p.goodGubun, p.goodRank, a.code DESC'

	PRINT (@Sql)
	EXECUTE (@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_AdListinfo_Section]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 검색 및 광고 신청 가능 검사
	제작자		: 이기운
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터
use keywordshop
******************************************************************************/

CREATE PROC [dbo].[sp_AdListinfo_Section]
(
	@kwCode		int			= 0,
	@kwName		varchar(30)	= '',
	@outprm		int 		= 0
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(1000)


	SET @Sql = 'SELECT p.kwcode,p.goodGubun,p.goodRank,'''+@kwName+''' as kwName,'
	SET @Sql = @Sql + ' dbo.F_AdState(adState,authState,s.goodGubun,s.goodRank) as AdMode,cutPrice1,cutPrice2,cutPrice3'
	SET @Sql = @Sql + ' FROM tbl_kwPrice as p WITH (NOLOCK) '
	SET @Sql = @Sql + ' LEFT OUTER JOIN (SELECT code, kwCode,goodGubun,goodRank,startDay,endDay,adState,authState FROM tbl_keyword_adinfo WITH (NOLOCK) where kwcode = '+Cast(@kwCode as varchar)+' and adState in (''N'',''Y'',''C'',''M'')) as a '
	SET @Sql = @Sql + ' ON p.kwcode = a.kwcode and p.goodGubun = a.goodGubun and p.goodRank = a.goodRank'
	SET @Sql = @Sql + ' LEFT OUTER JOIN (SELECT kwCode,goodGubun,goodRank FROM tbl_Session WITH (NOLOCK) WHERE kwcode = '+Cast(@kwCode as varchar)+' and datediff(minute,startTime, getdate()) < 30) as s '
	SET @Sql = @Sql + ' ON p.kwcode = s.kwcode and p.goodGubun = s.goodGubun and p.goodRank = s.goodRank'
	-- SET @Sql = @Sql + ' WHERE datediff(m,p.regdate,getdate()) = 0 AND p.kwcode = '+Cast(@kwCode as varchar)
	SET @Sql = @Sql + ' WHERE p.kwcode = '+Cast(@kwCode as varchar)+' AND datediff(m,p.regdate,getdate()) = 0  AND NOT(p.GoodGubun=''1'' AND p.GoodRank=''4'' ) '
	--SET @Sql = @Sql + ' WHERE p.kwcode = '+Cast(@kwCode as varchar)+' AND month(p.regdate)=7'
	SET @Sql = @Sql + ' ORDER BY p.goodGubun, p.goodRank, a.code DESC'

	--PRINT (@Sql)
	EXECUTE (@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_AdListinfoNone]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 검색 및 광고 신청 가능 검사
	제작자		: 이기운
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_AdListinfoNone]
(
	@kwCode	int		= 0,
	@kwName	varchar(30)	= '',
	@outprm		int 		= 0
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(500)


	SET @Sql = 'SELECT 0 as kwcode,p.goodGubun,p.goodRank, '''+@kwName+''' as kwName,'
	SET @Sql = @Sql + ' dbo.F_AdState('''','''','''','''') as AdMode, ''-'' as adDay,'''' as endDay,cutPrice1,cutPrice3'
	SET @Sql = @Sql + ' FROM tbl_kwNonePrice as p WITH (NOLOCK) '
	SET @Sql = @Sql + ' Where regDate in (SELECT max(regDate) FROM tbl_kwNonePrice WITH (NOLOCK))  AND NOT  ( (p.GoodGubun=''1'' AND p.GoodRank=''4'') OR p.GoodGubun=''3'' ) '
	SET @Sql = @Sql + ' ORDER BY goodGubun, goodRank'

	-- PRINT (@Sql)
	EXECUTE (@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_AdListinfoNone_Section]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 검색 및 광고 신청 가능 검사
	제작자		: 이기운
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터
sp_AdListinfoNone_Section
use keywordshop
******************************************************************************/

CREATE PROC [dbo].[sp_AdListinfoNone_Section]
(
	@kwCode	int		= 0,
	@kwName	varchar(30)	= '',
	@outprm		int 		= 0
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(500)


	SET @Sql = 'SELECT 0 as kwcode,p.goodGubun,p.goodRank, '''+@kwName+''' as kwName,'
	SET @Sql = @Sql + ' dbo.F_AdState('''','''','''','''') as AdMode, cutPrice1,cutPrice2,cutPrice3'
	SET @Sql = @Sql + ' FROM tbl_kwNonePrice as p WITH (NOLOCK) '
	SET @Sql = @Sql + ' Where regDate in (SELECT max(regDate) FROM tbl_kwNonePrice WITH (NOLOCK))  AND NOT (p.GoodGubun =''1'' AND p.GoodRank =''4'' )  '
	SET @Sql = @Sql + ' ORDER BY goodGubun, goodRank'

	-- PRINT (@Sql)
	EXECUTE (@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_admin_cnt]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: 관리자 총 레코드수 구하기
	제작자		: 김종현
	제작일		: 2004.03.25
	수정자		: 이기운
	수정일		: 2004.03.27
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_admin_cnt]
(
	@pagesize		int 		= 20,
	@isuse			char(1)		='',
	@level			char(1)		= '',
	@branchcode		VARchar(3)		= '',
	@srh_item		varchar(4)	= '',
	@keyword		varchar(30)	= ''
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(1000)
	DECLARE @szPrice	varchar(10)


	SET @Sql = 'Select count(idx) from  tbl_admin with (nolock) where 1=1'

IF @isuse<>''
	Begin
		SET @Sql = @Sql + ' and isuse ='''+CAST(@isuse AS CHAR(1)) + ''''
	End

IF @level<>''
	Begin
		SET @Sql = @Sql + ' and level ='''+CAST(@level AS CHAR(1)) + ''''
	End

IF @branchcode<>''
	Begin
		SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS VARCHAR(3)) + ''''
	End

IF @keyword<>''
	Begin
		SET @Sql = @Sql + ' and '+CAST(@srh_item as VARCHAR)+' like ''%'+CAST(@keyword AS VARCHAR) + '%'''
	End


	EXECUTE(@Sql)
--	Print(@Sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_admin_detail]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		:  관리자 상세보기
	제작자		: 김종현
	제작일		: 2004-05-03
	수정자		:
	수정일		:
	파라미터		: idx - 고유 번호

******************************************************************************/
CREATE PROCEDURE [dbo].[sp_admin_detail]
(
	@idx		int
)
AS
BEGIN

	SET NOCOUNT OFF
		SELECT * FROM tbl_admin WHERE idx =@idx

END
GO
/****** Object:  StoredProcedure [dbo].[sp_admin_edit]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		:  관리자 수정
	제작자		: 김종현
	제작일		: 2004-05-03
	수정자		:
	수정일		:
	파라미터		: idx - 고유 번호

******************************************************************************/
CREATE PROCEDURE [dbo].[sp_admin_edit]
(
	@idx		Int,
	@pwd		VarChar(30),
	@name		VarChar(30),
	@branchcode	VARChar(3),
	@branchgubun	Char(1),
	@level		Char(1),
	@note		VarChar(1000)	='',
	@isuse		Char(1)



)
AS
SET NOCOUNT ON
BEGIN
DECLARE
	@rowCnt			int,				--영향받은 행갯수
	@error_var		int

         BEGIN TRAN
		UPDATE tbl_admin SET pwd=@pwd,name=@name,branchcode=@branchcode,
		branchGubun=@branchgubun,level=@level,note=@note,isuse=@isuse,
		regdate=getdate() WHERE idx=@idx

	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN(1)
			END
	--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				RETURN(1)
			END
      COMMIT TRAN

RETURN(0)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_admin_idchk]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		:  관리자 아이디 중복체크
	제작자		: 김종현
	제작일		: 2004-05-03
	수정자		:
	수정일		:
	파라미터		:

******************************************************************************/
CREATE PROCEDURE [dbo].[sp_admin_idchk]
(
	@id		VarChar(30)




)
AS

BEGIN
DECLARE
	@CompID		varchar(30)
SET @CompID	=	''


		SELECT  @CompID = id FROM tbl_admin with (noLock) WHERE id=@id

	IF @CompID IS Null or @CompID = ''
		RETURN(0)
	ELSE
		RETURN(1)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_admin_list]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 관리자 리스트
	제작자		: 김종현
	제작일		: 2004.03.25
	수정자		:  이기운
	수정일		: 2004.03.27
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_admin_list]
(
	@topCnt			int 		= 20,
	@isuse			char(1)		='',
	@level			char(1)		= '',
	@branchcode		VARchar(3)		= '',
	@srh_item		varchar(4)	= '',
	@keyword		varchar(30)	= ''
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(1000)
	DECLARE @szPrice	varchar(10)

	SET @Sql = 'Select top '+Cast(@topcnt as varchar)+' idx,id,name,branchcode,level,isuse,regdate  from tbl_admin With ( NoLock ) where 1=1 '

IF @isuse<>''
	Begin
		SET @Sql = @Sql + ' and isuse ='''+CAST(@isuse AS CHAR(1)) + ''''
	End

IF @level<>''
	Begin
		SET @Sql = @Sql + ' and level ='''+CAST(@level AS CHAR(1)) + ''''
	End

IF @branchcode<>''
	Begin
		SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS VARCHAR(3)) + ''''
	End

IF @keyword<>''
	Begin
		SET @Sql = @Sql + ' and '+CAST(@srh_item as VARCHAR)+' like ''%'+CAST(@keyword AS VARCHAR) + '%'''
	End


	SET @Sql = @Sql + ' ORDER BY regdate desc'

	EXECUTE(@Sql)
--Print(@Sql)
--return(@Sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_admin_main_gongji_view_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_admin_main_gongji_view_01]
	@num	int = 1
AS
	SET NOCOUNT ON

	select top 1 * from tbl_gongji with (noLock) where num = @num
GO
/****** Object:  StoredProcedure [dbo].[sp_admin_reg]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		:  관리자 등록
	제작자		: 김종현
	제작일		: 2004-05-03
	수정자		:
	수정일		:
	파라미터		:

******************************************************************************/
CREATE PROCEDURE [dbo].[sp_admin_reg]
(
	@id		VarChar(30),
	@pwd		VarChar(30),
	@name		VarChar(30),
	@branchcode	VARChar(3),
	@branchgubun	Char(1),
	@level		Char(1),
	@note		VarChar(1000)	='',
	@isuse		Char(1)



)
AS
SET NOCOUNT ON
BEGIN
DECLARE
	@rowCnt			int,				--영향받은 행갯수
	@error_var		int

         BEGIN TRAN
		INSERT INTO tbl_admin(id,pwd,name,branchcode,branchgubun,level,note,isuse)
		VALUES(@id,@pwd,@name,@branchcode,@branchgubun,@level,@note,@isuse)

	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN(1)
			END
	--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				RETURN(1)
			END
      COMMIT TRAN

RETURN(0)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_AdNewSearch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 검색 및 광고 신청 가능 검사
	제작자		: 이기운
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_AdNewSearch]
(
	@kwName	varchar(30)	= '',
	@outprm		int 		= 0
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(100),
		@szkwName	varchar(30),
		@kwCode	int

	SET @szkwName	= ''
	SET @kwCode = 0

	if @kwName = ''
	BEGIN
		SET @outprm = 0
		RETURN
	END

	SELECT top 1 @kwCode = kwCode from tbl_similarkw with (nolock) where similarkwname = ''+@kwName+''

	IF (@kwCode is null) or (@kwCode = 0)
	BEGIN
		SELECT top 1 @szkwName = kwname, @kwCode = kwCode from tbl_keyword with (nolock) where kwname = ''+@kwName+''
		SET @outprm = @kwCode
	END
	ELSE
	BEGIN
		SELECT top 1 @szkwName = kwname, @kwCode = kwCode from tbl_keyword with (nolock) where kwCode = @kwCode
		SET @outprm = @kwCode
	END

	-- select @kwCode,@szkwName,@szTableName
	IF (@kwCode is null) or (@kwCode = 0)
	BEGIN
		SET @szkwName	= @kwName
		SET @kwCode = 0

		EXECUTE sp_AdListinfoNone  @kwCode, @szkwName
	END
	ELSE
	BEGIN
		EXECUTE sp_AdListinfo @kwCode, @szkwName
	END




END
GO
/****** Object:  StoredProcedure [dbo].[sp_AdNewSearch_Section]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 검색 및 광고 신청 가능 검사
	제작자		: 이기운
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터
use keywordshop

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_AdNewSearch_Section]
(
	@kwName	varchar(30)	= '',
	@outprm		int 		= 0
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(100),
		@szkwName	varchar(30),
		@kwCode	int

	SET @szkwName	= ''
	SET @kwCode = 0

	if @kwName = ''
	BEGIN
		SET @outprm = 0
		RETURN
	END

	SELECT top 1 @kwCode = kwCode from tbl_similarkw with (nolock) where similarkwname = ''+@kwName+''

	IF (@kwCode is null) or (@kwCode = 0)
	BEGIN
		SELECT top 1 @szkwName = kwname, @kwCode = kwCode from tbl_keyword with (nolock) where kwname = ''+@kwName+''
		SET @outprm = @kwCode
	END
	ELSE
	BEGIN
		SELECT top 1 @szkwName = kwname, @kwCode = kwCode from tbl_keyword with (nolock) where kwCode = @kwCode
		SET @outprm = @kwCode
	END

	-- select @kwCode,@szkwName,@szTableName
	IF (@kwCode is null) or (@kwCode = 0)
	BEGIN
		SET @szkwName	= @kwName
		SET @kwCode = 0

		EXECUTE sp_AdListinfoNone_Section  @kwCode, @szkwName
	END
	ELSE
	BEGIN
		EXECUTE sp_AdListinfo_Section  @kwCode, @szkwName
	END




END
GO
/****** Object:  StoredProcedure [dbo].[sp_adPlusPrice]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고연장신청시 광고기간별 가격정보
	제작자		: 정윤정
	제작일		: 2004.04.06
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_adPlusPrice]
@kwCode int,
@goodGubun char(1),
@goodRank char(1)
AS
BEGIN
	DECLARE @sql varchar(500)
	Set @sql = 'SELECT cutPrice1, cutPrice2, cutPrice3 FROM tbl_kwPrice With(NOLOCK)  WHERE kwCode=' + cast(@kwCode as varchar(20)) + ' and goodGubun = ' + @goodGubun + ' and goodRank = ' + @goodRank + ' and datediff(month,regdate,getdate())=0'
--	print @sql
	execute(@sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_adReport_Detail]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고리포트 신청자 리스트
	제작자		: 박준희
	제작일		: 2004.12.20
	수정자		:
	수정일		:
	파라미터



******************************************************************************/
CREATE PROCEDURE [dbo].[sp_adReport_Detail]

	@idx    int

AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(1000)





	SET	@Sql 	=	'SELECT   R.RegDate,R.MailDate,R.During , R.Period,R.MailState,A.Code,A.UserID,A.UserName,A.UserTel1,A.UserTel2, A.UserEMail,A.KwName, A.GoodGubun, A.GoodRank,A.StartDay,A.EndDay,A.AdState'
	SET 	@Sql	=	@Sql + ' FROM tbl_keyword_Report AS R  Inner Join tbl_Keyword_AdInfo A With(NoLock) On R.AdCode=A.Code '
	SET 	@Sql	=	@Sql + ' Where R.idx=' +Convert(varchar,  @idx )


	EXECUTE(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[sp_adReport_history]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명			: 키워드 리포트 발송내역 검사
	제작자		: 정윤정
	제작일		: 2004.12.20
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_adReport_history]
(
	@adCode		int		= 0
)
AS
SET NOCOUNT ON
BEGIN
	SELECT maildate, period FROM tbl_keyword_report
	WHERE adCode = @adCode and mailState = 'Y'
	ORDER BY maildate DESC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_adReport_isNewReport]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명			: 키워드 리포트 신청 가능 여부 검사
	제작자		: 정윤정
	제작일		: 2004.12.17
	수정자		:
	수정일		:
	파라미터
outprm : Y - 신청, M - 발송대기, N - 발송완료
******************************************************************************/

CREATE PROC [dbo].[sp_adReport_isNewReport]
(
	@adCode		int		= 0,
	@goodGubun 	char(1) 	= '',
	@period			int		= 0,
	@startDay 		smalldatetime,
	@outprm			char(1) 	= '' OUTPUT
)
AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@strReturn char(1) ,
		@regDate   datetime,
		@today 	    datetime,
		@more20    int

	SET @today = getdate()

	SET @more20 = DATEDIFF(day, @startDay, @today)

	SELECT regdate FROM tbl_keyword_report WITH (NOLOCK) WHERE adCode = @adCode

	IF @@ROWCOUNT = 0 -- 광고 번호로 등록된 발송내역이 아예 없을때 : 무조건 신청 가능
	BEGIN
		IF @more20 > 20
			SET @strReturn = 'Y'
		ELSE
			SET @strReturn = 'S'
	END
	ELSE
	BEGIN
		SELECT TOP 1 regdate FROM tbl_keyword_report WITH (NOLOCK) WHERE adCode = @adCode AND mailState = 'N' ORDER BY idx DESC

		IF @@ROWCOUNT = 0 -- 발송대기인 껀수가 없는 경우 : 모두 발송완료이므로, 기간으로 판가름한다.
		BEGIN
			SELECT TOP 1 @regDate = regdate FROM tbl_keyword_report WITH (NOLOCK) WHERE adCode = @adCode ORDER BY idx DESC
			SET @strReturn =  dbo.F_isNewReport(@goodGubun, @period, @startDay, @regDate, @today)
		END
		ELSE
			SET @strReturn =  'M'
	END

	SET @outprm = @strReturn

	RETURN
END
GO
/****** Object:  StoredProcedure [dbo].[sp_adReport_isNewReport_End]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명			: 키워드 리포트 신청 가능 여부 검사(종료된 광고)
	제작자		: 정윤정
	제작일		: 2004.12.21
	수정자		:
	수정일		:
	파라미터

	** 마지막 신청 가능 기회를 놓친 사람에 한해, 광고가 종료됐을시, 종료일로부터
       ** 30일 안에 신청가능 기회를 준다!!!!!!!!!!!!!!!!!!!!!!!!!!!!

outprm : Y - 신청, M - 발송대기, N - 발송완료
******************************************************************************/

CREATE PROC [dbo].[sp_adReport_isNewReport_End]
(
	@adCode		int		= 0,
	@goodGubun 	char(1) 	= '',
	@period			int		= 0,
	@startDay 		smalldatetime,
	@endDay 		smalldatetime,
	@outprm			char(1) 	= '' OUTPUT
)
AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@strReturn char(1),
		@mailstate char(1),
		@today 	    datetime,
		@num1		  int,
		@num2  		  int,
		@num3  	 	  int

	SET @today = getdate()

	IF (@goodGubun = 1 or @goodGubun = 2)
	BEGIN
		SET @num1 = 20
		SET @num2 = 50
		SET @num3 = 80
	END
	ELSE IF(@goodGubun = 3)
	BEGIN
		SET @num1 = 5
		SET @num2 = 10
		SET @num3 = 20
	END

	IF @period = 1
		SELECT * FROM tbl_keyword_report WITH (NOLOCK) WHERE adCode = @adCode and (DATEDIFF(day, @startDay, regDate) > @num1) and (DATEDIFF(day, @startDay, regDate) <= @num2)
	ELSE IF @period = 2
		SELECT * FROM tbl_keyword_report WITH (NOLOCK) WHERE adCode = @adCode and (DATEDIFF(day, @startDay, regDate) > @num2) and (DATEDIFF(day, @startDay, regDate) <= @num3)
	ELSE IF @period = 3
		SELECT * FROM tbl_keyword_report WITH (NOLOCK) WHERE adCode = @adCode and (DATEDIFF(day, @startDay, regDate) > @num3)

	IF @@ROWCOUNT = 0 -- 마지막 신청 가능 기회를 놓쳤는지 검사 : 종료일로부터 30일 내라면 신청기회 부여
	BEGIN
		SELECT @mailstate = mailstate FROM tbl_keyword_report WITH (NOLOCK) WHERE adCode = @adCode and (DATEDIFF(day, @endDay, regdate) < 30)

		IF @@ROWCOUNT = 0
		BEGIN
			IF DATEDIFF(day, @endDay, getdate()) < 30
				SET @strReturn =  'Y'
			ELSE
				SET @strReturn =  'E'
		END
		ELSE
		BEGIN
			IF @mailstate = 'N'
				SET @strReturn =  'M'
			ELSE IF @mailstate = 'Y'
				SET @strReturn =  'N'
		END
	END
	ELSE
	BEGIN
		SET @strReturn =  'N'
	END

	SET @outprm = @strReturn

	RETURN
END
GO
/****** Object:  StoredProcedure [dbo].[sp_adReport_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고리포트 신청자 리스트
	제작자		: 박준희
	제작일		: 2004.12.20
	수정자		:
	수정일		:
	파라미터


select * from tbl_keyword_adinfo With(NoLock)
where userid='pcercle'
insert into tbl_keyword_report
values(3048, GetDate(), DateAdd(d , 1, GetDate()), 2,

select * from tbl_keyword_report

sp_AdReport_list_01
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_adReport_list_01]

	@sYY			char(4) = ''
	,@sMM			char(2) = ''
	,@sDD			char(2) = ''
	,@eYY			char(4) = ''
	,@eMM			char(2) = ''
	,@eDD			char(2) = ''
	,@s_date		char(10) = ''
	,@e_date		char(10) = ''
	,@gotopage		int = 0
	,@DateSearch	varchar(10) = ''
	,@sState		varchar(10) = ''
	,@sText			varchar(30)	= ''
	,@sSearch		varchar(10) = ''
	,@toppage		int = 1
	,@check_cnt		int = 1

AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(1000)



	if @check_cnt = '1'
		begin
			SET 	@Sql 	=	'SELECT Count(idx) FROM dbo.tbl_Keyword_Report R With(NoLock) '
		end
	else
		begin
			SET	@Sql 	=	'SELECT Top ' + Cast(@topPage as VarChar	) + ' R.Idx,R.RegDate,R.MailDate,R.During , R.Period,R.MailState,A.UserID,A.UserName,A.UserEMail,A.KwName'+
						',A.Code,A.GoodGubun,A.GoodRank  FROM tbl_Keyword_Report  R With(NoLock) '
		end

  	SET 	@Sql	=	@Sql + '  Inner Join tbl_Keyword_AdInfo A With(NoLock) On R.AdCode=A.Code '
	SET 	@Sql	=	@Sql + ' Where 1=1 '




-------------------------------------------------------------------------------------------------------------------------

	if @sState <> ''			-- 상태에 따른 찾기
		begin
			SET @Sql = @Sql + ' and R.MailState = '''+@sState+''' '
		end

	if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
		begin
			SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
		end


	if @s_date <> '' and @e_date <> ''
		begin
			if @DateSearch  = 'R.RegDate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), R.regdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), R.regdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10),R. regdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), R.regdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), R.MailDate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), R.MailDate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), R.MailDate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), R.MailDate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end

		end

--// -----------------------------------------------------------------------------------------------------------------
	if @check_cnt = '0'
		begin
			SET @Sql = @Sql +' order by idx desc'
		end

	EXECUTE(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[sp_adReport_list_action]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 세금계산서 actio 프로그램
	제작자		: 고병호
	제작일		: 2004.03.25
	수정자		:
	수정일		:
	파라미터
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_adReport_list_action]
	@idx	int = 1
AS
	SET NOCOUNT ON
	BEGIN
		update dbo.tbl_Keyword_Report set  MailDate = getdate(), MailState = 'Y' Where  idx = @idx;
		SELECT AdCode From 	dbo.tbl_Keyword_Report With(NoLock)
		WHERE Idx=@Idx
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_adReport_MailForm]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************

	설명		: 광고리포트 메일보낼 데이터 출력
	제작자		: 박준희
	제작일		: 2004.12.20
	수정자		:
	수정일		:
	파라미터		:tbl_keyword_report 테이블의 idx , 광고번호


******************************************************************************/
CREATE PROCEDURE [dbo].[sp_adReport_MailForm]

	@idx    int ,
	@AdCode int

AS
SET NOCOUNT ON

BEGIN


	SELECT
	R.RegDate,
	R.MailDate,
	R.During ,
	R.Period,
	R.MailState,
	A.Code ,
	IsNULL(A.UserID , '') UserID,
	IsNULL(A.UserName , '') UserName,
	A.UserTel1,
	A.UserTel2,
	IsNULL(A.UserEMail, '') UserEMail,
	A.KwName,
	A.GoodGubun,
	A.GoodRank,
	A.StartDay,
	A.EndDay,
	A.AdState,
	IsNULL(A.PayDate , '') PayDate ,
	CASE WHEN (A.BranchCode = '' OR A.BranchCode IS NULL)  THEN A.OriginPrice ELSE I.Real_Price END RealPrice,
	ISNULL(U.U_FindAll , 0) 	U_FindAll,
	ISNULL(U.U_Naver , 0)	U_Naver,
	ISNULL(U.U_Daum ,0) 	U_Daum,
	F.ReadCnt,
	Month(F.RegDate) BasicMonth
	FROM
	tbl_keyword_Report AS R With(NoLock)  Left outer Join tbl_Keyword_AdInfo AS  A With(NoLock) On R.AdCode=A.Code
	Left Outer Join tbl_keyword_Income  As I With(NoLock)  On A.Code= I.Code
	Left Outer Join tbl_AdReport_UnitPrice As U With(NoLock)  On A.Code= U.AdCode
	Left Outer Join tbl_kwCnt_Front As F With(NoLock) ON A.KwCode = F.KwCode
	Where R.idx=@Idx
	AND YEAR(F.RegDate) = YEAR(GETDate()) AND Month(F.RegDate) = Month(GetDate())-1 ;

--광고아이디의 총 클릭수
	SELECT Sum(ClickCnt) TotClickCnt   FROM  dbo.tbl_AdReport_ClickCnt_Day With(NoLock)
	Where
	AdCode	= @AdCode;
--광고리포트 데이 마지막날
	SELECT Top 1 ClickDay LastReportDay  FROM  dbo.tbl_AdReport_ClickCnt_Day With(NoLock)
	Where
	AdCode	= @AdCode
	ORDER BY ClickDay DESC ;

--광고아이디의 날짜별 클릭수 데이터들 가져오기
	SELECT AdCode,ClickDay,ClickCnt,DatePart(week,ClickDay) DayWeek , DatePart(Month,ClickDay) DayMonth  FROM  dbo.tbl_AdReport_ClickCnt_Day With(NoLock)
	Where
	AdCode	= @AdCode
	ORDER BY ClickDay;
--광고아이디의 주간별 클릭수 통계 데이터 가져 오기
	SELECT Sum(ClickCnt) WeekCnt ,DatePart(week,ClickDay) DayWeek , DatePart(Month,ClickDay) DayMonth , DatePart(Year , ClickDay) DayYear  FROM  dbo.tbl_AdReport_ClickCnt_Day With(NoLock)
	Where
	AdCode	= @AdCode
	Group BY DatePart(Year,ClickDay) ,DatePart(Month,ClickDay), DatePart(week,ClickDay)










END
GO
/****** Object:  StoredProcedure [dbo].[sp_AdSearch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 검색 및 광고 검사
	제작자		: 이기운
	제작일		: 2004.04.06
	수정자		: 이기운
	수정일		: 2004.04.07
	수정내용	: 무료 홈페이지 광고 검색 추가
	파라미터

use keywordshop_test3
******************************************************************************/

CREATE PROC [dbo].[sp_AdSearch]
(
	@kwName	varchar(30)	= '',
	@outprm		int 		= 0
)


AS
SET NOCOUNT ON
BEGIN
	SET @kwName = Replace(@kwName , ' ', '')
	DECLARE
		@Sql		varchar(100),
		@szkwName	varchar(30),
		@kwCode	int

	SET @szkwName	= ''
	SET @kwCode = 0

	if @kwName = ''
	BEGIN
		SET @outprm = 0
		RETURN
	END
	-- 유의어 검색
	SELECT top 1 @kwCode = kwCode from tbl_similarkw with (nolock) where similarkwname = ''+@kwName+''

	IF (@kwCode is null) or (@kwCode = 0)
		BEGIN
		-- SELECT top 1 @szkwName = kwname, @kwCode = kwCode from tbl_keyword with (nolock) where kwname = ''+@kwName+''
		SELECT top 1 @kwCode = kwCode from tbl_keyword with (nolock) where kwname = ''+@kwName+''
		SET @outprm = @kwCode
		END
	ELSE
		BEGIN
		-- SELECT top 1 @szkwName = kwname, @kwCode = kwCode from tbl_keyword with (nolock) where kwCode = @kwCode
		SELECT top 1 @kwCode = kwCode from tbl_keyword with (nolock) where kwCode = @kwCode
		SET @outprm = @kwCode
	END

	SET @szkwName = @kwName
	-- select @kwCode,@szkwName,@szTableName
	IF (@kwCode is null) or (@kwCode = 0)
		BEGIN
			SET @kwCode = 0
		END
	ELSE
		BEGIN
			--노출수 증가
			UPDATE tbl_keyword SET readCnt = readCnt + 1 WHERE kwCode = @kwCode
			UPDATE tbl_keyword_adinfo SET readCnt = readCnt + 1 WHERE kwCode = @kwCode AND adState = 'Y' AND goodGubun < '4'		--노출수 증가
	END
	--	SELECT Code,kwName,goodGubun,goodRank,adTitle,adContent,adUrl,adimg,kwCode,regdate from tbl_keyword_adinfo with (nolock)
	--	WHERE (kwCode = @kwCode  OR  (goodGubun = 4 AND (adTitle like ''+@szkwName+'%'+'' OR adContent like ''+@szkwName+'%'+''))) AND adState = 'Y'
	--	ORDER BY goodGubun,goodRank

	SELECT Code,kwName,goodGubun,goodRank,adTitle,adContent,adUrl,adimg,kwCode,regdate,iconFileName,IsNull(DtlTitle,'') DtlTitle  FROM tbl_keyword_adinfo with (nolock)
	WHERE kwCode = @kwCode AND adState = 'Y' AND goodGubun < '4'
	UNION
	SELECT TOP 5 Code,kwName,goodGubun,goodRank,adTitle,adContent,adUrl,adimg,kwCode,regdate,iconFileName,IsNull(DtlTitle,'') DtlTitle   FROM tbl_keyword_adinfo with (nolock)
	WHERE goodGubun = '4' AND adState = 'Y' AND (adTitle like '%'+@szkwName+'%'+'' OR adContent like '%'+@szkwName+'%'+'')
	ORDER BY goodGubun,goodRank









END
GO
/****** Object:  StoredProcedure [dbo].[sp_adSessionPrice]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고신청시 광고기간별 가격정보
	제작자		: 정윤정
	제작일		: 2004.04.03
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_adSessionPrice]
@idx int
AS
SET NOCOUNT ON
BEGIN
	DECLARE @kwcode int
	DECLARE @goodGubun char(1)
	DECLARE @goodRank char(1)
	DECLARE @sql varchar(2000)

	SELECT @kwcode = isNull(kwcode, 0), @goodGubun = goodGubun, @goodRank = goodRank FROM tbl_session WHERE idx = @idx

	If @kwcode is null or @kwcode = 0
		Set @sql = 'SELECT cutPrice1, cutPrice2, cutPrice3 FROM tbl_kwNonePrice WHERE goodGubun = ' + @goodGubun + ' and goodRank = ' + @goodRank +' and datediff(month,regdate,getdate())=0 '
	else
		Set @sql = 'SELECT cutPrice1, cutPrice2, cutPrice3 FROM tbl_kwPrice WHERE kwCode=' + cast(@kwCode as varchar(20)) + ' and goodGubun = ' + @goodGubun + ' and goodRank = ' + @goodRank + '  and datediff(month,regdate,getdate())=0 '

--	print @sql
	execute(@sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_cnt]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: 등록대행 총 레코드수 구하기
	제작자		: 김종현
	제작일		: 2004.03.30
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_agent_cnt]
(

	@level			char(1)		= '',
	@agent_id		varchar(20)	= '',
	@branchcode		VARchar(3)		= '',
	@DateSearch		char(1)		= '',
	@StartDay		char(10)		= '',
	@EndDay		char(10)		= '',
	@goodgubun		char(1)		= '',
	@usedtype		char(1)		= '',
	@goodrank		char(1)		= '',
	@adstate		char(1)		= '',
	@isdc			char(1)		= '',
	@payKind		char(1)		= '',
	@srh_item		varchar(10)	= '',
	@keyword		varchar(30)	= ''
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(1000)
	DECLARE @szPrice	varchar(10)


	SET @Sql = 'Select count(code) from  tbl_keyword_adinfo with (nolock) where branchcode is not null and branchcode<>'''''

IF @level < '3'
	Begin
		IF @branchcode='aa'
			BEGIN
				SET @Sql = @Sql + ' and branchgubun =1'
			END

		ELSE IF @branchcode='bb'
			BEGIN
				SET @Sql = @Sql + ' and branchgubun =2'
			END
		ELSE IF @branchcode ='81'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''16'' or branchCode =''17'' or branchCode =''18'' or branchCode =''21'' or branchCode =''10''  or branchCode =''81'' )'
			End

		Else IF @branchcode ='82'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''19'' or branchCode =''20'' or branchCode =''22'' or branchCode =''23'' or branchCode =''82'' )'
			End

		Else IF @branchcode ='83'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='84'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''25'' or branchCode =''49'' or branchCode =''84'' )'
			End

		Else IF @branchcode ='85'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''12'' or branchCode =''13'' or branchCode =''14'' or branchCode=''15'' or branchCode=''85'' )'
			End

		Else IF @branchcode ='87'
			Begin
				SET @Sql = @Sql + ' and (branchCode IN ( ''10'',''81'',''82'',''87'',''201'',''202'',''203'',''204'' ) )'
			End

		Else IF @branchcode ='204'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
			End

		ELSE
			BEGIN
				IF @branchcode<>''
					Begin
						SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS VARCHAR(3)) + ''''
					End
			END
	End

ELSE IF @level = '3'
	IF @branchcode ='204'
	Begin
		SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
	End
	else
             Begin
		SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS CHAR(2)) + ''''
	End
ELSE IF @level = '6'
	Begin
		IF @branchcode ='81'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''16'' or branchCode =''17'' or branchCode =''18'' or branchCode =''21'' or branchCode =''10''  or branchCode =''81'' )'
			End

		Else IF @branchcode ='82'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''19'' or branchCode =''20'' or branchCode =''22'' or branchCode =''23'' or branchCode =''82'' )'
			End

		Else IF @branchcode ='83'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='84'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''25'' or branchCode =''49'' or branchCode =''84'' )'
			End

		Else IF @branchcode ='85'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''12'' or branchCode =''13'' or branchCode =''14'' or branchCode=''15'' or branchCode=''85'' )'
			End
		Else IF @branchcode ='87'
			Begin
				SET @Sql = @Sql + ' and (branchCode IN ( ''10'',''81'',''82'',''87'',''201'',''202'',''203'',''204'' ) )'
			End
		Else IF @branchcode ='204'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
			End
		Else
			Begin
				SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS VARCHAR(3)) + ''''
			End
	End
ELSE
	Begin
		SET @Sql = @Sql + ' and id ='''+CAST(@agent_id AS VARCHAR(20)) + ''''
	End

IF @DateSearch='1'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@endDay+''' '
	End
ELSE IF @DateSearch='2'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), prePayDate,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), prePayDate,120) <= '''+@endDay+''' '
	End

IF @goodgubun<>''
	Begin
		SET @Sql = @Sql + ' and goodgubun ='''+CAST(@goodgubun AS CHAR(1)) + ''''
	End

IF @usedtype<>''
	Begin
		SET @Sql = @Sql + ' and usedtype ='''+CAST(@usedtype AS CHAR(1)) + ''''
	End

IF @goodrank<>''
	Begin
		SET @Sql = @Sql + ' and goodrank ='''+CAST(@goodrank AS CHAR(1)) + ''''
	End

IF @adstate<>'A'
	Begin
		if @adState ='G'
			begin
				SET @Sql = @Sql + ' and adState <> ''E'' '
			end
		else
			Begin
				SET @Sql = @Sql + ' and adstate ='''+CAST(@adstate AS CHAR(1)) + ''''
			End
	End
/*
IF @adstate<>''
	Begin
		SET @Sql = @Sql + ' and adstate ='''+CAST(@adstate AS CHAR(1)) + ''''
	End
*/
IF @isdc<>''
	Begin
		if @isdc='2'
			SET @Sql = @Sql + ' and (isdc =2 or  isdc =3 or isdc =4 or isdc =5)'
		else if @isdc='9'
			SET @Sql = @Sql + ' and (isdc =6 or  isdc =7 or isdc =8)'
		else
			SET @Sql = @Sql + ' and isdc ='''+CAST(@isdc AS CHAR(1)) + ''''
	End

IF @payKind<>''
	Begin
		SET @Sql = @Sql + ' and paykind ='''+CAST(@payKind AS CHAR(1)) + ''''
	End

IF @keyword<>''
	Begin
		SET @Sql = @Sql + ' and '+CAST(@srh_item as VARCHAR)+' like ''%'+CAST(@keyword AS VARCHAR) + '%'''
	End


	EXECUTE(@Sql)
	Print(@Sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_detail]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 등록대행 광고 상세보기
	제작자		: 김종현
	제작일		: 2004.04.5
	수정자		:
	수정일		:
	파라미터
use keywordshop_test3
******************************************************************************/

CREATE PROCEDURE [dbo].[sp_agent_detail]
(
	@code		int = 0,
	@output		int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT a.code, a.userID, a.userName, a.chargeName, a.userAddr, a.userTel1, a.userTel2, a.userEmail, a.branchGubun, a.branchCode
	, a.id, a.name, a.kwCode, a.kwName, a.goodGubun, a.goodRank, a.period, a.startDay, a.endDay, a.originPrice, a.isDC, a.isService, a.serviceNm, a.adTitle, a.adContent,
	a.adImg, a.adUrl, a.usedType, a.freeType1, a.freeType2, a.readCnt, a.clickCnt, a.isExtend, a.isExtendMode, a.isTax, a.payMethod, a.payKind, a.prePayDate, a.inipayTid,
	a.payDate, a.payName, a.payState, a.adState, a.authState, a.authDate, a.regdate, a.note, a.ModDate, iconFileName, spLifeAdEnDate, noteState, IsNull(a.DtlHtmlYn, '') DtlHtmlYn, IsNull(a.DtlTitle, '') DtlTitle, IsNull(a.DtlContents, '') DtlContents ,b.* FROM tbl_keyword_adinfo as a With(NoLock)  inner join tbl_keyword_income as b With(NoLock)
	on a.code=b.code where a.code=@code

END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_edit]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 등록대행 광고 수정
	제작자		: 김종현
	제작일		: 2004.04.07
	수정자		:
	수정일		:
	파라미터

select * from tbl_keyword_income with(NoLock)
sp_help tbl_keyword_income
AlTER table tbl_keyword_income Add  Pay_Money  money  , Remain_Money money

sp_agent_detail
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_agent_edit]
(
@code		int=0,
@level		char(1)		='',
@goodGubun	char(1)		='',
@userName	varchar(30)	='',
@userAddr	varchar(100)	='',
@userTel1	varchar(13)	='',
@userTel2	varchar(13)	='',
@userEmail	varchar(50)	='',
@originPrice	int=0,
@isDc		char(1)		='',
@adTitle		varchar(100)	= '',
@adContent	varchar(100)	= '',
@adimg		varchar(300)	= '',
@adUrl		varchar(200)	= '',
@spLifeAdEnDate smalldatetime    ,
@adIcon		char(3)		='',
@usedType	char(1)		='',
@paymethod	char(1)		='',
@payKind	char(1)		='',
@prePayDate	smalldatetime,
@note		varchar(1000)	= '',
@freetype1	char(2)		='',
@freetype2	char(2)		='',
@firm_name	varchar(30)	= '',
@firm_tel		varchar(30)	= '',
@boxnum	int=0,
@boxPrice	money		=0,
@service_price	money		=0,
@real_price	money		=0,
@Pay_Money	money		=0 ,
@Remain_Money money		=0 ,
@noteState	varchar(1)	= '',
@DtlHtmlYn	tinyint		= 0,
@DtlTitle		varchar(50)	= '',
@DtlContents	text		= '',
@outparm	int  OUTPUT			--출력값(good_id)
)
AS
SET NOCOUNT ON
BEGIN
DECLARE
	@Sql			varchar(8000),
	@rowCnt			int,				--영향받은 행갯수
	@error_var		int,				--오류 번호
	@adCode		int				--생성된 identity 값
         BEGIN TRAN
		SET @Sql = 'UPDATE tbl_keyword_adinfo SET '
		SET @Sql = @Sql + 'userName ='''+CAST(@userName AS VARCHAR(30)) + ''''
		SET @Sql = @Sql + ',userAddr ='''+CAST(@userAddr AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',userTel1 ='''+CAST(@userTel1 AS VARCHAR(13)) + ''''
		SET @Sql = @Sql + ',userTel2 ='''+CAST(@userTel2 AS VARCHAR(13)) + ''''
		SET @Sql = @Sql + ',userEmail ='''+CAST(@userEmail AS VARCHAR(50)) + ''''
		SET @Sql = @Sql + ',adtitle ='''+CAST(@adtitle AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adcontent ='''+CAST(@adcontent AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adUrl ='''+CAST(@adUrl AS VARCHAR(200)) + ''''
		SET @Sql = @Sql + ',spLifeAdEnDate ='''+ CAST (@spLifeAdEnDate AS VARCHAR) + ''''
		SET @Sql = @Sql + ',iconFileName ='''+CAST(@adIcon AS CHAR(3)) + ''''
		SET @Sql = @Sql + ',adImg ='''+CAST(@adimg AS VARCHAR(30)) + ''''
		SET @Sql = @Sql + ',usedtype ='''+CAST(@usedtype AS CHAR(1)) + ''''
		SET @Sql = @Sql + ',freetype1 ='''+CAST(@freetype1 AS VARCHAR(2)) + ''''
		SET @Sql = @Sql + ',freetype2 ='''+CAST(@freetype2 AS CHAR(2)) + ''''
		SET @Sql = @Sql + ',modDate=getdate()'
		SET @Sql = @Sql + ',noteState = '''+@noteState+''''
		SET @Sql = @Sql + ',DtlHtmlYn ='''+CAST(@DtlHtmlYn AS VarCHAR) + ''''
		SET @Sql = @Sql + ',DtlTitle ='''+CAST(@DtlTitle AS VarCHAR(50)) + ''''
		SET @Sql = @Sql + ',DtlContents ='''+CAST(@DtlContents AS VarCHAR(8000)) + ''''
		IF @level < 3
			BEGIN
				SET @Sql = @Sql + ',isdc ='''+CAST(@isDc AS CHAR(1)) + ''''
				SET @Sql = @Sql + ',note ='''+CAST(@note AS VARCHAR(1000)) + ''''
				SET @Sql = @Sql + ',paymethod ='''+CAST(@paymethod AS CHAR(1)) + ''''
				SET @Sql = @Sql + ',payKind ='''+CAST(@payKind AS CHAR(1)) + ''''
			if @payKind<>'1'
				BEGIN
					SET @Sql = @Sql + ',prepaydate ='''+CAST(@prepaydate AS VARCHAR) + ''''
				END
				SET @Sql = @Sql + ' WHERE code='+Cast(@code as varchar)
				SET @Sql = @Sql + '; UPDATE tbl_keyword_income SET '
				SET @Sql = @Sql + 'firm_name ='''+CAST(@firm_name AS VARCHAR(30)) + ''''
				SET @Sql = @Sql + ',firm_tel ='''+CAST(@firm_tel AS VARCHAR(30)) + ''''
				SET @Sql = @Sql + ',boxnum ='''+CAST(@boxnum AS VARCHAR) + ''''
				SET @Sql = @Sql + ',boxPrice ='+CAST(@boxPrice AS varchar)
				SET @Sql = @Sql + ',service_price ='+CAST(@service_price AS VARCHAR)
				SET @Sql = @Sql + ',real_price ='+CAST(@real_price AS VARCHAR)
				SET @Sql = @Sql + ',Pay_Money ='+CAST(@Pay_Money AS VARCHAR)
				SET @Sql = @Sql + ',Remain_Money ='+CAST(@Remain_Money AS VARCHAR)
				SET @Sql = @Sql + ' WHERE code='+Cast(@code as varchar)
			END
		ELSE
			BEGIN
				SET @Sql = @Sql + ' WHERE code='+Cast(@code as varchar)
			END
		EXECUTE(@Sql)
--		Print(@Sql)
	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
	--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
--커밋
      COMMIT TRAN
RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_extend]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 연장기간 보기
	제작자		: 김종현
	제작일		: 2004.04.5
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_agent_extend]
(
	@isExtend		int = 0,
	@output		int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT startDay,endDay,adState FROM tbl_keyword_adinfo
	WHERE code=@isExtend

END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_extend_reg]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 등록대행 연장광고 등록
	제작자		: 김종현
	제작일		: 2004.04.07
	수정자		:
	수정일		:
	파라미터

sp_help tbl_keyword_adinfo
******************************************************************************/


CREATE PROCEDURE [dbo].[sp_agent_extend_reg]
(
@code		int,
@userID		varchar(50)	= '',
@userName	varchar(30)	= '',
@BranchCode	varchar(3)		='',
@id		varchar(50)	= '',
@name		varchar(30)	= '',
@chargeName     varchar(30) 	= '',
@userAddr	varchar(100)	= '',
@userTel1	varchar(13) 	= '',
@userTel2	varchar(13) 	= '',
@userEmail	varchar(50)	= '',
@kwcode	int=0,
@kwname	varchar(25)	= '',
@goodGubun	char(1)		='',
@goodRank	char(1)		='',
@period		char(1)		='',
@startDay	smalldatetime,
@endDay	smalldatetime,
@spLifeAdEnDate  smalldatetime	,
@originPrice	int=0,
@isDc		char(1)		='',
@adTitle		varchar(100)	= '',
@adContent	varchar(100)	= '',
@adimg		varchar(300)	= '',
@adUrl		varchar(200)	= '',
@adIcon		varchar(10) 	= '',
@usedType	char(1)		='',
@paymethod	char(1)		='',
@PayKind	Char(1) 		= '',
@PrePayDate	smalldatetime	,
@note		varchar(1000)	= '',
@firm_name	varchar(30)	= '',
@firm_tel		varchar(30)	= '',
@boxnum	int=0,
@boxPrice	money		=0,
@service_price	money		=0,
@real_price	money		=0,
@Pay_Money	money		=0,
@Remain_Money	money		=0,
@DtlHtmlYn	tinyint		= 0,
@DtlTitle		varchar(50)	= '',
@DtlContents	text		= '',
@outparm	int  OUTPUT			--출력값(good_id)

)

AS
SET NOCOUNT ON
BEGIN
DECLARE
	@Sql			varchar(1000),
	@rowCnt			int,				--영향받은 행갯수
	@error_var		int,				--오류 번호
	@adCode		int				--생성된 identity 값

         BEGIN TRAN
	INSERT INTO tbl_keyword_adinfo (userID,userName,chargeName,userAddr,userTel1,userTel2,userEmail,BranchCode,id,name,kwcode,kwname,goodGubun,goodRank,
  	period,startDay,endDay,spLifeAdEnDate,originPrice,isDc,adTitle,adContent,adimg,adUrl,usedType,paymethod,PayKind,PrePayDate, isExtend,payState,adState,authState,note, iconFileName, DtlHtmlYn, DtlTitle, DtlContents)
	VALUES (@userID,@userName,@chargeName,@userAddr,@userTel1,@userTel2,@userEmail, @BranchCode,@id,@name,@kwcode,@kwname,@goodGubun,@goodRank,
  	@period,@startDay,@endDay,@spLifeAdEnDate,@originPrice,@isDc,@adTitle,@adContent,@adimg,@adUrl,@usedType,@paymethod,@PayKind,@PrePayDate, @code,'I','N','N',@note,@adIcon, @DtlHtmlYn, @DtlTitle, @DtlContents )

	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
	--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END

	--정상적으로 입력되었으면 아이덴티티 셋팅
		SELECT @adCode = @@identity

-- 수금정보 등록
	INSERT INTO tbl_keyword_income(code,firm_name,firm_tel,boxnum,boxprice,service_price,real_price , Pay_Money , Remain_Money)
	VALUES (@adCode,@firm_name,@firm_tel,@boxnum,@boxprice,@service_price,@real_price , @Pay_Money , @Remain_Money)

--연장 부모광고에 구분값 업데이트
	UPDATE tbl_keyword_adinfo SET isExtendMode='Y' WHERE code=@code

--커밋
      COMMIT TRAN

RETURN(0)


END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_free_detail]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 등록대행 무료홈페이지 광고 상세보기
	제작자		: 김종현
	제작일		: 2004.04.07
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_agent_free_detail]
(
	@code		int = 0,
	@output		int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT userid,username,chargename,useraddr,usertel1,usertel2,useremail,branchcode,name,adtitle,adcontent,adurl,freetype1,freetype2 FROM tbl_keyword_adinfo where code=@code

END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_free_edit]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 등록대행 무료홈페이지 광고 수정하기
	제작자		: 김종현
	제작일		: 2004.04.07
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_agent_free_edit]
(
	@code		int = 0,
	@adTitle		varchar(100)	= '',
	@adContent	varchar(100)	= '',
	@adimg		varchar(30)	= '',
	@adUrl		varchar(100)	= '',
	@freetype1	char(2)		='',
	@freetype2	char(2)		='',
	@output		int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	UPDATE  tbl_keyword_adinfo set
	adtitle=@adtitle,adcontent=@adcontent,adurl=@adurl,freetype1=@freetype1,freetype2=@freetype2
	WHERE code=@code

END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_free_reg]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: 등록대행 광고 등록
	제작자		: 김종현
	제작일		: 2004.04.05
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_agent_free_reg]
(
@userID		varchar(30)	= '',
@userName	varchar(30)	= '',
@chargeName	varchar(30)	= '',
@userAddr	varchar(100)	= '',
@userTel1	varchar(13)	= '',
@userTel2	varchar(13)	= '',
@userEmail	varchar(50)	= '',
@BranchCode	VARchar(3)		='',
@BranchGubun	char(1)		='',
@id		varchar(30)	= '',
@name		varchar(30)	= '',
@goodGubun	char(1)		='',
@originPrice	int		=0,
@isDc		char(1)		='',
@adTitle		varchar(100)	= '',
@adContent	varchar(100)	= '',
@adUrl		varchar(100)	= '',
@freeType1	char(2)		='',
@freeType2	char(2)		='',
@outparm	int  OUTPUT			--출력값(good_id)

)

AS
SET NOCOUNT ON
BEGIN
DECLARE
	@rowCnt			int,				--영향받은 행갯수
	@error_var		int,				--오류 번호
	@adCode		int				--생성된 identity 값

         BEGIN TRAN
	INSERT INTO tbl_keyword_adinfo(userID,userName,chargeName,userAddr,userTel1,userTel2,userEmail,BranchCode,BranchGubun,id,name,goodGubun,adTitle,adContent,adUrl,freeType1,freeType2,isdc,originPrice,payState,adState,authState)
	VALUES (@userID,@userName,@chargeName,@userAddr,@userTel1,@userTel2,@userEmail,@BranchCode,@BranchGubun,@id,@name,@goodGubun,@adTitle,@adContent,@adUrl,@freeType1,@freeType2,@isDc,@originPrice,'I','N','N')


	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
	--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END

--커밋
      COMMIT TRAN

RETURN(0)


END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_list]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: 키워드샵 등록대행 리스트
	제작자		: 김종현
	제작일		: 2004.03.30
	수정자		:
	수정일		:
	파라미터
sp_agent_list '20', '1', ' pcercle', '','','','','','','','G','','','ChargeName','김지훈'
Select  top 20 code,userID,userName,kwcode,kwName,goodgubun,usedType,goodrank,goodrank,isDC,isService,startDay,endDay,spLifeAdEnDate,regDate,paykind,prepaydate,branchcode,adstate from  tbl_keyword_adinfo with (nolock) where branchcode is not null and branchcode<>'' and adState <> 'E'  and ChargeName like '%김지훈%' ORDER BY  RegDate desc
sp_agent_list '20', '1', ' pcercle', '','','','','','','','A','','','ChargeName','김지훈'
select top 10 * from tbl_keyword_adinfo with(NoLock)
******************************************************************************/


CREATE PROCEDURE [dbo].[sp_agent_list]
(
	@topCnt			int		=20,
	@level			char(1)		= '',
	@agent_id		varchar(20)	= '',
	@DateSearch		char(1)		= '',
	@branchcode		VARCHAR(3)	= '',
	@StartDay		char(10)		= '',
	@EndDay		char(10)		= '',
	@goodgubun		char(1)		= '',
	@usedtype		char(1)		= '',
	@goodrank		char(1)		= '',
	@adstate		char(1)		= '',
	@isdc			char(1)		= '',
	@payKind		char(1)		= '',
	@srh_item		varchar(10)	= '',
	@keyword		varchar(30)	= ''
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(1000)


	SET @Sql = 'Select  top '+Cast(@topcnt as varchar)+' code,userID,userName,kwcode,kwName,goodgubun,usedType,goodrank,goodrank,isDC,isService,startDay,endDay,spLifeAdEnDate,regDate,paykind,prepaydate,branchcode,Name, adstate, noteState from  tbl_keyword_adinfo with (nolock) where branchcode is not null and branchcode<>'''''


IF @level < '3'
	Begin
		IF @branchcode='aa'
			BEGIN
				SET @Sql = @Sql + ' and branchgubun =1'
			END

		ELSE IF @branchcode='bb'
			BEGIN
				SET @Sql = @Sql + ' and branchgubun =2'
			END

		Else IF @branchcode ='83'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='87'
			Begin
				SET @Sql = @Sql + ' and (branchCode IN ( ''10'',''81'',''82'',''87'',''201'',''202'',''203'',''204'' ) )'

			End
		Else IF @branchcode ='204'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
			End

		ELSE
			BEGIN
				IF @branchcode<>''
					Begin
						SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS varchar(3)) + ''''
					End
			END
	End

ELSE IF @level = '3'
            IF @branchcode ='204'
	Begin
		SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
	End
             else
	Begin
		SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS varchar(3)) + ''''
	End


ELSE IF @level = '6'
	Begin

		IF @branchcode ='83'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='87'
			Begin
				SET @Sql = @Sql + ' and (branchCode IN ( ''10'',''81'',''82'',''87'',''201'',''202'',''203'',''204'' ) )'
			End
		Else IF @branchcode ='204'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
			End
		Else
			Begin
				SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS varchar(3)) + ''''
			End
	End

ELSE
	Begin
		SET @Sql = @Sql + ' and id ='''+CAST(@agent_id AS VARCHAR(20)) + ''''
	End



IF @DateSearch='1'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@endDay+''' '
	End
ELSE IF @DateSearch='2'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), prePayDate,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), prePayDate,120) <= '''+@endDay+''' '
	End

ELSE IF @DateSearch='3'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), StartDay,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), StartDay,120) <= '''+@endDay+''' '
	End
ELSE IF @DateSearch='4'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), EndDay,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), EndDay,120) <= '''+@endDay+''' '
	End
ELSE IF @DateSearch='5'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), spLifeAdEnDate,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), spLifeAdEnDate,120) <= '''+@endDay+''' '
	End






IF @goodgubun<>''
	Begin
		SET @Sql = @Sql + ' and goodgubun ='''+CAST(@goodgubun AS CHAR(1)) + ''''
	End

IF @usedtype<>''
	Begin
		SET @Sql = @Sql + ' and usedtype ='''+CAST(@usedtype AS CHAR(1)) + ''''
	End

IF @goodrank<>''
	Begin
		SET @Sql = @Sql + ' and goodrank ='''+CAST(@goodrank AS CHAR(1)) + ''''
	End

IF @adstate<>'A'
	Begin
		if @adState ='G'
			begin
				SET @Sql = @Sql + ' and adState <> ''E'' '
			end
		else
			Begin
				SET @Sql = @Sql + ' and adstate ='''+CAST(@adstate AS CHAR(1)) + ''''
			End
	End

IF @isdc<>''
	Begin
		if @isdc='2'
			SET @Sql = @Sql + ' and (isdc =2 or  isdc =3 or isdc =4 or isdc =5)'
		else if @isdc='9'
			SET @Sql = @Sql + ' and (isdc =6 or  isdc =7 or isdc =8)'
		else
			SET @Sql = @Sql + ' and isdc ='''+CAST(@isdc AS CHAR(1)) + ''''
	End


IF @payKind<>''
	Begin
		SET @Sql = @Sql + ' and paykind ='''+CAST(@payKind AS CHAR(1)) + ''''
	End



IF @keyword<>''
	Begin
		SET @Sql = @Sql + ' and '+CAST(@srh_item as VARCHAR)+' like ''%'+CAST(@keyword AS VARCHAR) + '%'''
	End

SET @Sql = @Sql + ' ORDER BY  RegDate desc'


	EXECUTE(@Sql)
	--Print(@Sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_Price]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고신청시 광고기간별 가격정보
	제작자		: 김종현
	제작일		: 2004.04.07
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_agent_Price]
(
	@kwcode 	int,
	@goodGubun 	char(1),
	@goodRank 	char(1)
)



AS
SET NOCOUNT ON
BEGIN

	SELECT cutPrice1, cutPrice2, cutPrice3 FROM tbl_kwPrice WHERE kwCode=@kwCode and goodGubun = @goodGubun  and goodRank = @goodRank and datediff(m,regDate,getdate()) = 0

END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_reg]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 등록대행 광고 등록
	제작자		: 김종현
	제작일		: 2004.04.05
	수정자		:
	수정일		:
	파라미터
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_agent_reg]
(
@userID		varchar(50)	= '',
@userName	varchar(30)	= '',
@chargeName	varchar(30)	= '',
@userAddr	varchar(100)	= '',
@userTel1	varchar(13)	= '',
@userTel2	varchar(13)	= '',
@userEmail	varchar(50)	= '',
@BranchCode	VARCHAR(3)		='',
@BranchGubun	char(1)		='',
@id		varchar(50)	= '',
@name		varchar(30)	= '',
@kwcode	int=0,
@kwname	varchar(25)	= '',
@goodGubun	char(1)		='',
@goodRank	char(1)		='',
@period		char(1)		='',
@startDay	smalldatetime,
@endDay	smalldatetime,
@spLifeAdEnDate smalldatetime,
@originPrice	int=0,
@isDc		char(1)		='',
@adTitle		varchar(100)	= '',
@adContent	varchar(100)	= '',
@adimg		varchar(300)	= '',
@adUrl		varchar(200)	= '',
@adIcon		char(3)		= '',
@usedType	char(1)		='',
@paymethod	char(1)		='',
@payKind	char(1)		='',
@prePayDate	smalldatetime,
@note		varchar(1000)	= '',
@firm_name	varchar(30)	= '',
@firm_tel		varchar(30)	= '',
@boxnum	int=0,
@boxPrice	money		=0,
@service_price	money		=0,
@real_price	money		=0,
@Pay_Money	money		=0,
@Remain_Money	money		=0,
@session_idx	int,
@DtlHtmlYn	tinyint		=0,
@DtlTitle		varchar(50)	='',
@DtlContents	text		='',
@outparm	int  OUTPUT			--출력값(good_id)
)
AS
SET NOCOUNT ON
BEGIN
DECLARE
	@Sql			varchar(1000),
	@rowCnt			int,				--영향받은 행갯수
	@error_var		int,				--오류 번호
	@adCode		int				--생성된 identity 값
         BEGIN TRAN
	INSERT INTO tbl_keyword_adinfo (userID,userName,chargeName,userAddr,userTel1,userTel2,userEmail,BranchCode,BranchGubun,id,name,kwcode,kwname,goodGubun,goodRank,
  	period,startDay,endDay,originPrice,isDc,adTitle,adContent,adimg,adUrl,usedType,paymethod,paykind,prePayDate,payState,adState,authState,note,iconFileName, spLifeAdEnDate,DtlHtmlYn,DtlTitle,DtlContents)
	VALUES (@userID,@userName,@chargeName,@userAddr,@userTel1,@userTel2,@userEmail,@BranchCode,@BranchGubun,@id,@name,@kwcode,@kwname,@goodGubun,@goodRank,
  	@period,@startDay,@endDay,@originPrice,@isDc,@adTitle,@adContent,@adimg,@adUrl,@usedType,@paymethod,@payKind,@prePayDate,'I','N','N',@note,@adIcon , @spLifeAdEnDate,@DtlHtmlYn,@DtlTitle,@DtlContents)
	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
	--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
	--정상적으로 입력되었으면 아이덴티티 셋팅
		SELECT @adCode = @@identity
-- 수금정보 등록
	INSERT INTO tbl_keyword_income(code,firm_name,firm_tel,boxnum,boxprice,service_price,real_price , Pay_Money, Remain_Money)
	VALUES (@adCode,@firm_name,@firm_tel,@boxnum,@boxprice,@service_price,@real_price , @Pay_Money , @Remain_Money)
-- 세션삭제
	DELETE FROM tbl_session WHERE idx=@session_idx
--커밋
      COMMIT TRAN
RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_Session]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고신청시 광고세션 체크
	제작자		: 김종현
	제작일		: 2004.04.07
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_agent_Session]
(
	@kwcode 	int,
	@goodGubun 	char(1),
	@goodRank 	char(1)
)



AS
SET NOCOUNT ON
BEGIN

	SELECT idx FROM tbl_session WHERE kwcode=@KwCode  and goodGubun=@GoodGubun and goodRank=@GoodRank and datediff(minute,startTime, getdate()) < 30

END
GO
/****** Object:  StoredProcedure [dbo].[sp_agent_URL_Check]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 무료홈페이지 url 조회
	제작자		: 김종현
	제작일		: 2004.04.07
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_agent_URL_Check]
(
	@adurl 		varchar(100)
)



AS
SET NOCOUNT ON
BEGIN

	SELECT adurl,adtitle,goodgubun FROM tbl_keyword_adinfo WHERE adurl=@adurl and goodgubun='4'

END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_AdList]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 비즈맨 키워드 검색 및 광고 검사
	제작자		: 이기운
	제작일		: 2004.04.06
	수정자		: 이기운
	수정일		: 2004.04.07
	수정내용	: 무료 홈페이지 광고 검색 추가
	파라미터
sp_BizMan_AdList 20,'adPart','부동산'

'SELECT Top 10 Code,kwName,adName,adPart, adBelong,adDuty,adHp,adPhone,adEmail,adTextTitle1,adTextContent1,adTextTitle2,adTextContent2,adTextTitle3,adTextContent3,adHomePage,adBlog,adMsgTitle,adMsgContent1,adMsgUrl1,adMsgContent2,adMsgUrl2,adMsgContent3,adMsgUrl3, adimg,kwCode,regdate FROM tbl_BizMan_adinfo With (Nolock) Where '1'='1'

sp_help tbl_bizman_adinfo
sp_BizMan_AdList 10,'adPhone','0105550495'

******************************************************************************/

CREATE PROC [dbo].[sp_BizMan_AdList]
(
	@TopCnt		int	= 1,
	@ColumnNm	varchar(25) = '',
	@SrchTxt	varchar(25) = ''


)


AS
SET NOCOUNT ON
BEGIN


	DECLARE
		@AllSql		varchar(1000),
		@CntSql		varchar(300),
		@Sql		varchar(500),
		@WhereSql	varchar(150),
		@OrderSql	varchar(100),
		@SrchTxt2	varchar(25)
	SET @AllSql		=	''
	SET @WhereSql		=	''
	SET @OrderSql		=	''
	SET @SrchTxt2		=	Replace(@SrchTxt , '-','')


	SET @CntSql  =	'SELECT Count( Code) ' +
			' FROM tbl_BizMan_adinfo With (Nolock)  ' +
			' Where adState=''Y'' ' +
			' And CONVERT(varchar(10), GetDate(),120) >=CONVERT(varchar(10), StartDay,120)  ' +
			' And CONVERT(varchar(10), GetDate(),120) <=CONVERT(varchar(10), EndDay ,120)  '

	SET @Sql  =	'SELECT Top '+ Cast ( @TopCnt as varchar )  + '  Code,kwName,adName,adPart, adBelong,adDuty,adHp,adPhone,'+
			'adEmail,adTextTitle1,adTextContent1,adTextTitle2,adTextContent2,'+
			'adTextTitle3,adTextContent3,adHomePage,adBlog,adMsgTitle,'+
			'adMsgContent1,adMsgUrl1,adMsgContent2,adMsgUrl2,adMsgContent3,'+
			'adMsgUrl3, adimg,kwCode,regdate ' +
			' FROM tbl_BizMan_adinfo With (Nolock)  ' +
			' Where adState=''Y'' ' +
			' And CONVERT(varchar(10), GetDate(),120) >=CONVERT(varchar(10), StartDay,120)  ' +
			' And CONVERT(varchar(10), GetDate(),120) <=CONVERT(varchar(10), EndDay ,120)  '
	IF (@ColumnNm <>'' AND @SrchTxt <> '')
		BEGIN
			SET @WhereSql = ' AND (' + @ColumnNm + '  Like  ''%' + @SrchTxt + '%'' OR Replace( ' +@ColumnNm + ' , ''-'','''')  Like ''%' +@SrchTxt2 + '%'' ) '

		END
	SET @OrderSql	=  ' Order By Code Desc '


	SET @AllSql	=	@CntSql + @WhereSql + ';' + @Sql + @WhereSql + @OrderSql
	Print @AllSql
	Execute  ( @AllSql )












END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_AdNewSearch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: [비즈맨]키워드 검색 및 광고 신청 가능 검사
	제작자		: 정윤정
	제작일		: 2004.11.10
	수정자		:
	수정일		:
	파라미터
sp_BizMan_AdNewSearch 326

******************************************************************************/

CREATE PROC [dbo].[sp_BizMan_AdNewSearch]
(
	@kwCode	int	= 0,
	@outprm		varchar(1) = '' OUTPUT,
	@outEndDay	varchar(30) = '' OUTPUT
)

AS
BEGIN
	if @kwCode = '0'
	BEGIN
		SET @outprm = ''
		SET @outEndDay = ''
		RETURN
	END

	DECLARE @strReturn varchar(1)
	DECLARE @strEndday varchar(30)

 	--신청중인 광고 있나?
	SELECT idx FROM tbl_bizman_session WITH (NOLOCK) WHERE kwCode = @kwCode and datediff(minute,startTime, getdate()) < 30

	IF @@ROWCOUNT = 0 -- 신청중인 광고가 없으므로 광고테이블 검사로 들어간다.
	BEGIN
		SELECT code FROM tbl_bizman_adinfo WITH (NOLOCK) WHERE kwCode = @kwCode and (adState in ('N', 'M', 'C'))

		IF @@ROWCOUNT = 0 -- 신규,광고대기,보류인 광고가 없다
		BEGIN
			SELECT code FROM tbl_bizman_adinfo WITH (NOLOCK) WHERE kwCode = @kwCode and adState = 'Y'
			IF @@ROWCOUNT = 0 -- 승인중인 광고가 없다 : 등록가능
			BEGIN
				SET @strReturn = 'Y'
				SET @strEndday = ''
			END
			ELSE -- 승인중인 광고중 등록가능 기간에 있는 데이타가 있는지 검사
			BEGIN
				SELECT code FROM tbl_bizman_adinfo WITH (NOLOCK) WHERE kwCode = @kwCode and (adState = 'Y' and (DateDiff(hour, getdate(), endDay) >= 61 and DateDiff(day, getdate(), endDay) <= 10))

				IF @@ROWCOUNT = 0 -- 승인된 광고중 오늘날짜가 등록가능 기간에 있는 데이타가 없다 : 등록 불가능
				BEGIN
					SET @strReturn = 'N'
					SET @strEndday = ''
				END
				ELSE -- 승인됐는데 오늘날짜가 등록가능 기간에 있다 : 등록 가능
				BEGIN
					SET @strReturn = 'Y'
					SELECT @strEndDay = endDay FROM tbl_bizman_adinfo WITH (NOLOCK) WHERE code in (SELECT code FROM tbl_bizman_adinfo WITH (NOLOCK) WHERE kwCode = @kwCode and (adState = 'Y' and (DateDiff(hour, getdate(), endDay) >= 61 and DateDiff(day, getdate(), endDay) <= 10)))
				END
			END
		END
		ELSE -- 신청중이거나 게재대기 또는 보류인 광고가 있으므로 등록불가능
		BEGIN
			SET @strReturn = 'N'
			SET @strEndday = ''
		END
	END
	ELSE
	BEGIN
		SET @strReturn = 'N'
		SET @strEndday = ''
	END

	SET	@outprm = @strReturn
	SET @outEndDay = @strEndday

--	PRINT(@strReturn)
	RETURN
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_AdSearch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 비즈맨 키워드 검색 및 광고 검사
	제작자		: 이기운
	제작일		: 2004.04.06
	수정자		: 이기운
	수정일		: 2004.04.07
	수정내용	: 무료 홈페이지 광고 검색 추가
	파라미터
select * from tbl_bizMan_adinfo Where adstate='y'

update tbl_bizman_adinfo set adstate='y' where code='12'

select * from tbl_bizMan where kwname='019-4894417'
sp_BizMan_AdSearch '02-1544-1961',''
******************************************************************************/

CREATE PROC [dbo].[sp_BizMan_AdSearch]
(
	@kwName	varchar(30)	= '',
	@outprm		int 		= 0
)


AS
SET NOCOUNT ON
BEGIN
	SET @kwName = Replace(@kwName , ' ', '')

	DECLARE
		@Sql		varchar(100),
		@szkwName	varchar(30),
		@kwCode	int ,
		@KwName2	varchar(30)

	SET @szkwName	= ''
	SET @kwCode = 0

	if @kwName = ''
	BEGIN
		SET @outprm = 0
		RETURN
	END



	DECLARE @cntFor int,
			  @txtFor varchar(1),
			  @resultFor varchar(50)

	SET @cntFor = 1
	SET @txtFor = ''
	SET	@resultFor = ''

	WHILE (@cntFor <= LEN(@kwName))
	BEGIN
		SET @txtFor = SUBSTRING(@kwName, @cntFor, 1)
		IF (ISNUMERIC(@txtFor) = 1) or (@txtFor = '-')
			SET @resultFor = @resultFor + ''
		ELSE
			SET @resultFor = @resultFor + 'N'

		SET @cntFor = @cntFor + 1
	END

	IF @resultFor = ''   --전화번호형식(검색시 '-' 을 REPLACE한다)
		-- SELECT top 1 @szkwName = kwname, @kwCode = kwCode from tbl_keyword with (nolock) where kwname = ''+@kwName+''
		SELECT top 1 @kwCode = kwCode from tbl_BizMan with (nolock) where kwname = @kwName  OR Replace(KwName , '-', '') = Replace(@KwName , '-', '')
	ELSE
		SELECT top 1 @kwCode = kwCode from tbl_BizMan with (nolock) where kwname = @kwName
--	print @kwCode


	SET @outprm = @kwCode



	SET @szkwName = @kwName
	-- select @kwCode,@szkwName,@szTableName
	IF (@kwCode is null) or (@kwCode = 0)
		BEGIN
			SET @kwCode = 0
		END
	ELSE
		BEGIN
			--노출수 증가
			UPDATE tbl_BizMan SET readCnt = readCnt + 1 WHERE kwCode = @kwCode
			UPDATE tbl_BizMan_adinfo SET readCnt = readCnt + 1 WHERE kwCode = @kwCode AND adState = 'Y' 		--노출수 증가
	END
	--	SELECT Code,kwName,goodGubun,goodRank,adTitle,adContent,adUrl,adimg,kwCode,regdate from tbl_keyword_adinfo with (nolock)
	--	WHERE (kwCode = @kwCode  OR  (goodGubun = 4 AND (adTitle like ''+@szkwName+'%'+'' OR adContent like ''+@szkwName+'%'+''))) AND adState = 'Y'
	--	ORDER BY goodGubun,goodRank

	SELECT Code,kwName,adName,adPart, adBelong,adDuty,adHp,adPhone,adEmail,adTextTitle1,adTextContent1,adTextTitle2,adTextContent2,adTextTitle3,adTextContent3,adHomePage,adBlog,adMsgTitle,adMsgContent1,adMsgUrl1,adMsgContent2,adMsgUrl2,adMsgContent3,adMsgUrl3, adimg,kwCode,regdate,Img1,Img2,Img3,Img1Title,Img2Title,Img3Title FROM tbl_BizMan_adinfo with (nolock)
	WHERE kwCode = @kwCode AND adState = 'Y'










END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_agent_cnt]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: 등록대행 총 레코드수 구하기
	제작자		: 김종현
	제작일		: 2004.03.30
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_BizMan_agent_cnt]
(

	@level			char(1)		= '',
	@agent_id		varchar(20)	= '',
	@branchcode		VARCHAR(3)		= '',
	@DateSearch		char(1)		= '',
	@StartDay		char(10)		= '',
	@EndDay		char(10)		= '',
	@goodgubun		char(1)		= '',
	@usedtype		char(1)		= '',
	@goodrank		char(1)		= '',
	@adstate		char(1)		= '',
	@isdc			char(1)		= '',
	@payKind		char(1)		= '',
	@srh_item		varchar(10)	= '',
	@keyword		varchar(30)	= ''
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(1000)
	DECLARE @szPrice	varchar(10)


	SET @Sql = 'Select count(code) from  tbl_BizMan_AdInfo with (nolock) where branchcode is not null and branchcode<>'''''

IF @level < '3'
	Begin
		IF @branchcode='aa'
			BEGIN
				SET @Sql = @Sql + ' and branchgubun =1'
			END

		ELSE IF @branchcode='bb'
			BEGIN
				SET @Sql = @Sql + ' and branchgubun =2'
			END
		ELSE IF @branchcode ='81'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''16'' or branchCode =''17'' or branchCode =''18'' or branchCode =''21'' or branchCode =''10''  or branchCode =''81'' )'
			End

		Else IF @branchcode ='82'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''19'' or branchCode =''20'' or branchCode =''22'' or branchCode =''23'' or branchCode =''82'' )'
			End

		Else IF @branchcode ='83'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='84'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''25'' or branchCode =''49'' or branchCode =''84'' )'
			End

		Else IF @branchcode ='85'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''12'' or branchCode =''13'' or branchCode =''14'' or branchCode=''15'' or branchCode=''85'' )'
			End

		Else IF @branchcode ='87'
			Begin
				SET @Sql = @Sql + ' and (branchCode IN ( ''10'',''81'',''82'',''87'',''201'',''202'',''203'',''204'') )'
			End

		Else IF @branchcode ='204'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
			End

		ELSE
			BEGIN
				IF @branchcode<>''
					Begin
						SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS VARCHAR(3)) + ''''
					End
			END
	End

ELSE IF @level = '3'
            IF @branchcode ='204'
	Begin
		SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
	End
             else
	Begin
		SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS CHAR(2)) + ''''
	End
ELSE IF @level = '6'
	Begin
		IF @branchcode ='81'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''16'' or branchCode =''17'' or branchCode =''18'' or branchCode =''21'' or branchCode =''10''  or branchCode =''81'' )'
			End

		Else IF @branchcode ='82'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''19'' or branchCode =''20'' or branchCode =''22'' or branchCode =''23'' or branchCode =''82'' )'
			End

		Else IF @branchcode ='83'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='84'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''25'' or branchCode =''49'' or branchCode =''84'' )'
			End

		Else IF @branchcode ='85'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''12'' or branchCode =''13'' or branchCode =''14'' or branchCode=''15'' or branchCode=''85'' )'
			End
		Else IF @branchcode ='87'
			Begin
				SET @Sql = @Sql + ' and (branchCode IN (''10'',''81'',''82'',''87'',''201'',''202'',''203'',''204'' ) )'
			End
		Else IF @branchcode ='204'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
			End
		Else
			Begin
				SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS VARCHAR(3)) + ''''
			End
	End
ELSE
	Begin
		SET @Sql = @Sql + ' and id ='''+CAST(@agent_id AS VARCHAR(20)) + ''''
	End

IF @DateSearch='1'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@endDay+''' '
	End
ELSE IF @DateSearch='2'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), prePayDate,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), prePayDate,120) <= '''+@endDay+''' '
	End

IF @goodgubun<>''
	Begin
		SET @Sql = @Sql + ' and goodgubun ='''+CAST(@goodgubun AS CHAR(1)) + ''''
	End

IF @usedtype<>''
	Begin
		SET @Sql = @Sql + ' and usedtype ='''+CAST(@usedtype AS CHAR(1)) + ''''
	End

IF @goodrank<>''
	Begin
		SET @Sql = @Sql + ' and goodrank ='''+CAST(@goodrank AS CHAR(1)) + ''''
	End

IF @adstate<>'A'
	Begin
		if @adState ='G'
			begin
				SET @Sql = @Sql + ' and adState <> ''E'' '
			end
		else
			Begin
				SET @Sql = @Sql + ' and adstate ='''+CAST(@adstate AS CHAR(1)) + ''''
			End
	End
/*
IF @adstate<>''
	Begin
		SET @Sql = @Sql + ' and adstate ='''+CAST(@adstate AS CHAR(1)) + ''''
	End
*/
IF @isdc<>''
	Begin
		if @isdc='2'
			SET @Sql = @Sql + ' and (isdc =2 or  isdc =3 or isdc =4 or isdc =5)'
		else if @isdc='9'
			SET @Sql = @Sql + ' and (isdc =6 or  isdc =7 or isdc =8)'
		else
			SET @Sql = @Sql + ' and isdc ='''+CAST(@isdc AS CHAR(1)) + ''''
	End

IF @payKind<>''
	Begin
		SET @Sql = @Sql + ' and paykind ='''+CAST(@payKind AS CHAR(1)) + ''''
	End

IF @keyword<>''
	Begin
		SET @Sql = @Sql + ' and '+CAST(@srh_item as VARCHAR)+' like ''%'+CAST(@keyword AS VARCHAR) + '%'''
	End


	EXECUTE(@Sql)
	Print(@Sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_agent_detail]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 등록대행 광고 상세보기
	제작자		: 김종현
	제작일		: 2004.04.5
	수정자		:
	수정일		:
	파라미터
	sp_BizMan_agent_detail
sp_BizMan_agent_edit
sp_BizMan_agent_reg
sp_BizMan_agent_Extend_reg
sp_BizMan_AdSearch

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_BizMan_agent_detail]
(
	@code		int = 0,
	@output		int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT a.*,b.* FROM tbl_BizMan_adinfo as a With(NoLock)  inner join tbl_BizMan_income as b With(NoLock)
	on a.code=b.code where a.code=@code

END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_agent_edit]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: 등록대행 광고 수정
	제작자		: 김종현
	제작일		: 2004.04.07
	수정자		:
	수정일		:
	파라미터

use keywordshop_test3
use keywordshop
select * from tbl_keyword_adinfo
Where kwname='대리점'
delete from tbl_keyword_adinfo where code='4902'


select top 10 * from tbl_keyword_income
delete from tbl_keyword_income where code='4902'

use keywordshop_test3
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_BizMan_agent_edit]
(
@code		int=0,
@level		char(1)		='',
@userName	varchar(30)	='',
@userAddr	varchar(100)	='',
@userTel1	varchar(13)	='',
@userTel2	varchar(13)	='',
@userEmail	varchar(50)	='',
@originPrice	int=0,
@isDc		char(1)		='',

@adimg		varchar(100)	= '',
@adName	varchar(20)	= '',
@adPart		varchar(100)	= '',
@adBelong	varchar(100)	= '',
@adDuty		varchar(100)	= '',
@adPhone	varchar(14)	= '',
@adHp		varchar(14)	= '',
@adEmail	varchar(100)	= '',
@Img1		varchar(100)	= '',
@Img2		varchar(100)	= '',
@Img3		varchar(100)	= '',
@Img1Title	varchar(50)	= '',
@Img2Title	varchar(50)	= '',
@Img3Title	varchar(50)	= '',


@adTextTitle1	varchar(30)	= '',
@adTextContent1	varchar(600)	= '',
@adTextTitle2	varchar(30)	= '',
@adTextContent2	varchar(600)	= '',
@adTextTitle3	varchar(30)	= '',
@adTextContent3	varchar(600)	= '',
@adHomepage	varchar(100)	= '',
@adblog		varchar(100)	= '',
@adMsgTitle	varchar(40)	= '',

@adMsgContent1	varchar(100)	= '',
@adMsgUrl1	varchar(100)	= '',
@adMsgContent2	varchar(100)	= '',
@adMsgUrl2	varchar(100)	= '',
@adMsgContent3	varchar(100)	= '',
@adMsgUrl3	varchar(100)	= '',

@paymethod	char(1)		='',
@payKind	char(1)		='',
@prePayDate	smalldatetime,
@note		varchar(1000)	= '',


@firm_name	varchar(30)	= '',
@firm_tel		varchar(30)	= '',
@boxnum	int=0,
@boxPrice	money		=0,
@service_price	money		=0,
@real_price	money		=0,
@Pay_Money	money		=0 ,
@Remain_Money money		=0 ,
@outparm	varchar(1500)	output	--출력값(good_id)
)
AS
SET NOCOUNT ON
BEGIN
DECLARE
	@Sql			varchar(8000),
	@rowCnt			int,				--영향받은 행갯수
	@error_var		int,				--오류 번호
	@adCode		int				--생성된 identity 값

 BEGIN TRAN
		SET @Sql = 'UPDATE tbl_BizMan_adinfo SET '
		SET @Sql = @Sql + 'userName ='''+CAST(@userName AS VARCHAR(30)) + ''''
		SET @Sql = @Sql + ',userAddr ='''+CAST(@userAddr AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',userTel1 ='''+CAST(@userTel1 AS VARCHAR(13)) + ''''
		SET @Sql = @Sql + ',userTel2 ='''+CAST(@userTel2 AS VARCHAR(13)) + ''''
		SET @Sql = @Sql + ',userEmail ='''+CAST(@userEmail AS VARCHAR(50)) + ''''

		SET @Sql = @Sql + ',adImg ='''+CAST(@adimg AS VARCHAR(100)) + ''''

		SET @Sql = @Sql + ',adName ='''+CAST(@adName AS VARCHAR(30)) + ''''
		SET @Sql = @Sql + ',adPart ='''+CAST(@adPart AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adBelong ='''+CAST(@adBelong AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adDuty ='''+CAST(@adDuty AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adPhone ='''+CAST(@adPhone AS VARCHAR(14)) + ''''
		SET @Sql = @Sql + ',adHp ='''+CAST(@adHp AS VARCHAR(14)) + ''''
		SET @Sql = @Sql + ',adEmail ='''+CAST(@adEmail AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adTextTitle1 ='''+CAST(@adTextTitle1 AS VARCHAR(30)) + ''''
		SET @Sql = @Sql + ',adTextContent1 ='''+CAST(@adTextContent1 AS VARCHAR(600)) + ''''
		SET @Sql = @Sql + ',adTextTitle2 ='''+CAST(@adTextTitle2 AS VARCHAR(30)) + ''''
		SET @Sql = @Sql + ',adTextContent2 ='''+CAST(@adTextContent2 AS VARCHAR(600)) + ''''
		SET @Sql = @Sql + ',adTextTitle3 ='''+CAST(@adTextTitle3 AS VARCHAR(30)) + ''''
		SET @Sql = @Sql + ',adTextContent3 ='''+CAST(@adTextContent3 AS VARCHAR(600)) + ''''
		SET @Sql = @Sql + ',adHomepage ='''+CAST(@adHomepage AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adblog ='''+CAST(@adblog AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adMsgTitle ='''+CAST(@adMsgTitle AS VARCHAR(40)) + ''''
		SET @Sql = @Sql + ',adMsgContent1 ='''+CAST(@adMsgContent1 AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adMsgContent2 ='''+CAST(@adMsgContent2 AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adMsgContent3 ='''+CAST(@adMsgContent3 AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adMsgUrl1 ='''+CAST(@adMsgUrl1 AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adMsgUrl2 ='''+CAST(@adMsgUrl2 AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',adMsgUrl3 ='''+CAST(@adMsgUrl3 AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',Img1Title = ''' + CAST (@Img1Title AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',Img2Title = ''' + CAST (@Img2Title AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',Img3Title = ''' + CAST (@Img3Title AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',Img1 = ''' + CAST (@Img1 AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',Img2 = ''' + CAST (@Img2 AS VARCHAR(100)) + ''''
		SET @Sql = @Sql + ',Img3 = ''' + CAST (@Img3 AS VARCHAR(100)) + ''''

		SET @Sql = @Sql + ',modDate=getdate()'
		IF @level < 3
			BEGIN
				SET @Sql = @Sql + ',isdc ='''+CAST(@isDc AS CHAR(1)) + ''''
				SET @Sql = @Sql + ',note ='''+CAST(@note AS VARCHAR(1000)) + ''''
				SET @Sql = @Sql + ',paymethod ='''+CAST(@paymethod AS CHAR(1)) + ''''
				SET @Sql = @Sql + ',payKind ='''+CAST(@payKind AS CHAR(1)) + ''''
			if @payKind<>'1'
				BEGIN
					SET @Sql = @Sql + ',prepaydate ='''+CAST(@prepaydate AS VARCHAR) + ''''
				END
				SET @Sql = @Sql + ' WHERE code='+Cast(@code as varchar)
				SET @Sql = @Sql + '; UPDATE tbl_BizMan_income SET '
				SET @Sql = @Sql + 'firm_name ='''+CAST(@firm_name AS VARCHAR(30)) + ''''
				SET @Sql = @Sql + ',firm_tel ='''+CAST(@firm_tel AS VARCHAR(30)) + ''''
				SET @Sql = @Sql + ',boxnum ='''+CAST(@boxnum AS VARCHAR) + ''''
				SET @Sql = @Sql + ',boxPrice ='+CAST(@boxPrice AS varchar)
				SET @Sql = @Sql + ',service_price ='+CAST(@service_price AS VARCHAR)
				SET @Sql = @Sql + ',real_price ='+CAST(@real_price AS VARCHAR)
				SET @Sql = @Sql + ',Pay_Money ='+CAST(@Pay_Money AS VARCHAR)
				SET @Sql = @Sql + ',Remain_Money ='+CAST(@Remain_Money AS VARCHAR)
				SET @Sql = @Sql + ' WHERE code='+Cast(@code as varchar)
			END
		ELSE
			BEGIN
				SET @Sql = @Sql + ' WHERE code='+Cast(@code as varchar)
			END
			--Print(@Sql)
		EXECUTE(@Sql)
/*--	Print(@Sql)
	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
	--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
*/
--커밋
	SET @outparm	= @Sql

      COMMIT TRAN
RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_agent_extend]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 연장기간 보기
	제작자		: 김종현
	제작일		: 2004.04.5
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_BizMan_agent_extend]
(
	@isExtend		int = 0,
	@output		int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT startDay,endDay,adState FROM tbl_BizMan_adinfo With(NoLock)
	WHERE code=@isExtend

END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_agent_Extend_reg]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: 비즈맨 등록대행  광고 등록
	제작자		: 박준희
	제작일		: 2004.11.16
	수정자		:
	수정일		:
	파라미터


select * from tbl_bizMan_adinfo
use keywordshop_test3

sp_lock

******************************************************************************/
CREATE PROCEDURE [dbo].[sp_BizMan_agent_Extend_reg]
(
@code		int,
@userID		varchar(50)	= '',
@userName	varchar(30)	='',
@chargeName	varchar(30)	= '',
@userAddr	varchar(100)	='',
@userTel1	varchar(13)	='',
@userTel2	varchar(13)	='',
@userEmail	varchar(50)	='',
@BranchGubun	char(1)		='',
@BranchCode	varchar(3)		='',
@id		varchar(50)	= '',
@name		varchar(30)	= '',

@KwCode	int		=0,
@KwName	varchar(25)	='',
@Period		char(1)		= '',
@startDay	smalldatetime,
@endDay	smalldatetime,
@originPrice	int=0,
@isDc		char(1)		='',
@isService	char(1)		='',
@ServiceNm	varchar(30)	= '',

@adName	varchar(20)	= '',
@adPart		varchar(100)	= '',
@adBelong	varchar(100)	= '',
@adDuty		varchar(100)	= '',

@adHp		varchar(14)	= '',
@adPhone	varchar(14)	= '',
@adEmail	varchar(100)	= '',

@Img1		varchar(100)	='',
@Img2		varchar(100)	='',
@Img3		varchar(100)	='',
@Img1Title	varchar(100)	='',
@Img2Title	varchar(100)	='',
@Img3Title	varchar(100)	='',

@adTextTitle1	varchar(30)	= '',
@adTextContent1	varchar(600)	= '',
@adTextTitle2	varchar(30)	= '',
@adTextContent2	varchar(600)	= '',
@adTextTitle3	varchar(30)	= '',
@adTextContent3	varchar(600)	= '',
@adHomepage	varchar(100)	= '',
@adblog		varchar(100)	= '',

@adMsgTitle	varchar(40)	= '',
@adMsgContent1	varchar(100)	= '',
@adMsgUrl1	varchar(100)	= '',
@adMsgContent2	varchar(100)	= '',
@adMsgUrl2	varchar(100)	= '',
@adMsgContent3	varchar(100)	= '',
@adMsgUrl3	varchar(100)	= '',
@adimg		varchar(100)	= '',



@paymethod	char(1)		='',
@payKind	char(1)		='',
@prePayDate	smalldatetime,
@note		varchar(1000)	= '',


@firm_name	varchar(30)	= '',
@firm_tel		varchar(30)	= '',
@boxnum	int=0,
@boxPrice	money		=0,
@service_price	money		=0,
@real_price	money		=0,
@Pay_Money	money		=0 ,
@Remain_Money money		=0 ,
@outparm	int	output	--출력값(good_id)
)
AS
SET NOCOUNT ON
BEGIN
DECLARE
	@Sql			varchar(8000),
	@rowCnt			int,				--영향받은 행갯수
	@error_var		int,				--오류 번호
	@adCode		int				--생성된 identity 값

 BEGIN TRAN
		SET @Sql = 'Insert INTO  tbl_BizMan_adinfo ('+
		'UserId,UserName,ChargeName,UserAddr , UserTel1,UserTel2, UserEmail, BranchGubun,BranchCode,Id,Name,'+
		' KwCode,KwName,Period,StartDay,EndDay,OriginPrice,adName,adPart, adBelong,AdDuty,adPhone, adHp, adEmail, adTextTitle1, ' +
		'adTextContent1, adTextTitle2, adTextContent2, adTextTitle3, adTextContent3,adHomePage, adBlog,'+
		'adMsgTitle,adMsgContent1,adMsgContent2, adMsgContent3, adMsgUrl1, adMsgUrl2, adMsgUrl3,adImg,'+
		'RegDate,ModDate,isDC, Note, PayMethod , PayKind, PrePayDate,isExtend,payState,adState,authState,Img1,Img2,Img3,Img1Title,Img2Title,Img3Title )'+
		' Values('''+
		CAST(@userId AS VARCHAR(30)) + '''' +
		', '''+CAST(@userName AS VARCHAR(30)) + ''''+
		', '''+CAST(@ChargeName AS VARCHAR(30)) + ''''+
		', '''+CAST(@userAddr AS VARCHAR(100)) + ''''+
		','''+CAST(@userTel1 AS VARCHAR(13)) + '''' +
		','''+CAST(@userTel2 AS VARCHAR(13)) + '''' +
		','''+CAST(@userEmail AS VARCHAR(50)) + '''' +
		','''+CAST(@BranchGubun AS CHAR(1)) + '''' +
		','''+CAST(@BranchCode AS varCHAR(3)) + '''' +
		','''+CAST(@ID AS VARCHAR(30)) + '''' +
		','''+CAST(@Name AS CHAR(30)) + '''' +


		','''+CAST(@KwCode AS VARCHAR) + ''''		+
		','''+CAST(@KwName AS VARCHAR(25)) + ''''		+
		','''+CAST(@Period AS CHAR(1)) + ''''		+
		','''+CAST(@StartDay AS VARCHAR(30)) + '''' +
		','''+CAST(@EndDay AS VARCHAR(30)) + '''' +
		','+CAST(@originPrice AS VARCHAR(30))  +
		','''+CAST(@adName AS VARCHAR(30)) + '''' +
		','''+CAST(@adPart AS VARCHAR(100)) + '''' +
		','''+CAST(@adBelong AS VARCHAR(100)) + '''' +
		','''+CAST(@adDuty AS VARCHAR(100)) + '''' +
		','''+CAST(@adPhone AS VARCHAR(14)) + '''' +
		','''+CAST(@adHp AS VARCHAR(14)) + '''' +
		','''+CAST(@adEmail AS VARCHAR(100)) + '''' +
		','''+CAST(@adTextTitle1 AS VARCHAR(30)) + '''' +

		','''+CAST(@adTextContent1 AS VARCHAR(600)) + '''' +
		','''+CAST(@adTextTitle2 AS VARCHAR(30)) + '''' +
		','''+CAST(@adTextContent2 AS VARCHAR(600)) + '''' +
		','''+CAST(@adTextTitle3 AS VARCHAR(30)) + '''' +
		','''+CAST(@adTextContent3 AS VARCHAR(600)) + '''' +
		','''+CAST(@adHomepage AS VARCHAR(100)) + '''' +
		','''+CAST(@adblog AS VARCHAR(100)) + '''' +

		','''+CAST(@adMsgTitle AS VARCHAR(40)) + '''' +
		','''+CAST(@adMsgContent1 AS VARCHAR(100)) + '''' +
		','''+CAST(@adMsgContent2 AS VARCHAR(100)) + '''' +
		','''+CAST(@adMsgContent3 AS VARCHAR(100)) + '''' +
		','''+CAST(@adMsgUrl1 AS VARCHAR(100)) + '''' +
		','''+CAST(@adMsgUrl2 AS VARCHAR(100)) + ''''   +
		','''+CAST(@adMsgUrl3 AS VARCHAR(100)) + '''' +
		','''+CAST(@adimg AS VARCHAR(100)) + ''''		+

		',    getdate() ' +
		',    getdate() ' +
		','''+CAST(@isDc AS CHAR(1)) + '''' +
		','''+CAST(@note AS VARCHAR(1000)) + '''' +
		','''+CAST(@paymethod AS CHAR(1)) + '''' +
		','''+CAST(@payKind AS CHAR(1)) + '''' +
	  	','''+CAST(@prepaydate AS VARCHAR) + ''''+
		','''+CAST(@Code AS VARCHAR)+''',''I'',''N'',''N'', ''' +
		CAST(@Img1 AS VARCHAR(100)) + ''' , ''' +
		CAST(@Img2 AS VARCHAR(100)) + ''' , ''' +
		CAST(@Img3 AS VARCHAR(100)) + ''' , ''' +
		CAST(@Img1Title AS VARCHAR(100)) + ''' , '''	+
		CAST(@Img2Title AS VARCHAR(100)) + ''' , ''' +
		CAST(@Img3Title AS VARCHAR(100)) + '''  ) ;'



		EXECUTE(@Sql)
		--Print(@Sql)
		SET @adCode =  @@Identity ;

				SET @Sql =  'InSERT INTO tbl_BizMan_income ( ' +
				          ' Code,Firm_Name , Firm_Tel, BoxNum, BoxPrice, Service_Price , Real_Price, Pay_Money, Remain_Money)'+
				          'Values (' +
				           CAST (@AdCode AS VARCHAR) +
			           	          ','''+CAST(@firm_name AS VARCHAR(30)) + '''' +
				          ','''+CAST(@firm_tel AS VARCHAR(30)) + '''' +
				          ','''+CAST(@boxnum AS VARCHAR) + '''' +
				          ','+CAST(@boxPrice AS varchar) +
				          ','+CAST(@service_price AS VARCHAR) +
				          ','+CAST(@real_price AS VARCHAR) +
				          ','+CAST(@Pay_Money AS VARCHAR) +
				          ','+CAST(@Remain_Money AS VARCHAR) + ' ) ;' +
				         'UpDate tbl_BizMan_AdInfo SET  isExtendMode=''Y'' WHERE code='+ CAST(@code  AS VARCHAR)



			--Print(@Sql)
		EXECUTE(@Sql)
--	Print(@Sql)
	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
	--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END

--커밋
	SET @outparm	=  @AdCode

    COMMIT TRAN
RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_agent_list]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드샵 등록대행 리스트
	제작자		: 김종현
	제작일		: 2004.03.30
	수정자		:
	수정일		:
	파라미터
sp_agent_list '20', '1', ' pcercle', '','','','','','','','G','','','ChargeName','김지훈'
Select  top 20 code,userID,userName,kwcode,kwName,goodgubun,usedType,goodrank,goodrank,isDC,isService,startDay,endDay,spLifeAdEnDate,regDate,paykind,prepaydate,branchcode,adstate from  tbl_keyword_adinfo with (nolock) where branchcode is not null and branchcode<>'' and adState <> 'E'  and ChargeName like '%김지훈%' ORDER BY  RegDate desc
sp_agent_list '20', '1', ' pcercle', '','','','','','','','A','','','ChargeName','김지훈'
select top 10 * from tbl_keyword_adinfo with(NoLock)
******************************************************************************/


CREATE PROCEDURE [dbo].[sp_BizMan_agent_list]
(
	@topCnt			int		=20,
	@level			char(1)		= '',
	@agent_id		varchar(20)	= '',
	@branchcode		VARCHAR(3)		= '',
	@DateSearch		char(1)		= '',
	@StartDay		char(10)		= '',
	@EndDay		char(10)		= '',
	@adstate		char(1)		= '',
	@isdc			char(1)		= '',
	@payKind		char(1)		= '',
	@srh_item		varchar(10)	= '',
	@keyword		varchar(30)	= ''
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(1000)


	SET @Sql = 'Select  top '+Cast(@topcnt as varchar)+' code,userID,userName,kwcode,kwName,isDC,isService,startDay,endDay,regDate,paykind,prepaydate,branchcode,Name, adstate from  tbl_BizMan_adinfo with (nolock) where branchcode is not null and branchcode<>'''''


IF @level < '3'
	Begin
		IF @branchcode='aa'
			BEGIN
				SET @Sql = @Sql + ' and branchgubun =1'
			END

		ELSE IF @branchcode='bb'
			BEGIN
				SET @Sql = @Sql + ' and branchgubun =2'
			END

		Else IF @branchcode ='83'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='87'
			Begin
				SET @Sql = @Sql + ' and (branchCode IN ( ''10'',''81'',''82'',''87'',''201'',''202'',''203'',''204'' ) )'
			End

		Else IF @branchcode ='204'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
			End
		ELSE
			BEGIN
				IF @branchcode<>''
					Begin
						SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS varchar(3)) + ''''
					End
			END
	End

ELSE IF @level = '3'
            IF @branchcode ='204'
	Begin
		SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
	End
             else
	Begin
		SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS varchar(3)) + ''''
	End


ELSE IF @level = '6'
	Begin

		IF @branchcode ='83'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='87'
			Begin
				SET @Sql = @Sql + ' and (branchCode IN ( ''10'',''81'',''82'',''87'',''201'',''202'',''203'',''204'' ) )'
			End
		Else IF @branchcode ='204'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''24'' or branchCode =''204'')'
			End
		Else
			Begin
				SET @Sql = @Sql + ' and branchcode ='''+CAST(@branchcode AS varchar(3)) + ''''
			End
	End

ELSE
	Begin
		SET @Sql = @Sql + ' and id ='''+CAST(@agent_id AS VARCHAR(20)) + ''''
	End



IF @DateSearch='1'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@endDay+''' '
	End
ELSE IF @DateSearch='2'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), prePayDate,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), prePayDate,120) <= '''+@endDay+''' '
	End

ELSE IF @DateSearch='3'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), StartDay,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), StartDay,120) <= '''+@endDay+''' '
	End
ELSE IF @DateSearch='4'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), EndDay,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), EndDay,120) <= '''+@endDay+''' '
	End
ELSE IF @DateSearch='5'
	Begin
		SET @sql = @sql + ' and CONVERT(varchar(10), spLifeAdEnDate,120) >= '''+@startDay+''' '
		SET @sql = @sql + ' and CONVERT(varchar(10), spLifeAdEnDate,120) <= '''+@endDay+''' '
	End





IF @adstate<>'A'
	Begin
		if @adState ='G'
			begin
				SET @Sql = @Sql + ' and adState <> ''E'' '
			end
		else
			Begin
				SET @Sql = @Sql + ' and adstate ='''+CAST(@adstate AS CHAR(1)) + ''''
			End
	End

IF @isdc<>''
	Begin
		if @isdc='2'
			SET @Sql = @Sql + ' and (isdc =2 or  isdc =3 or isdc =4 or isdc =5)'
		else if @isdc='9'
			SET @Sql = @Sql + ' and (isdc =6 or  isdc =7 or isdc =8)'
		else
			SET @Sql = @Sql + ' and isdc ='''+CAST(@isdc AS CHAR(1)) + ''''
	End


IF @payKind<>''
	Begin
		SET @Sql = @Sql + ' and paykind ='''+CAST(@payKind AS CHAR(1)) + ''''
	End



IF @keyword<>''
	Begin
		SET @Sql = @Sql + ' and '+CAST(@srh_item as VARCHAR)+' like ''%'+CAST(@keyword AS VARCHAR) + '%'''
	End

SET @Sql = @Sql + ' ORDER BY  RegDate desc'


	EXECUTE(@Sql)
	--Print(@Sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_agent_reg]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 비즈맨 등록대행  광고 등록
	제작자		: 박준희
	제작일		: 2004.11.16
	수정자		:
	수정일		:
	파라미터


select * from tbl_bizMan_adinfo
use keywordshop_test3

select * from finddb2.common.dbo.usercommon Where userid='doong8'
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_BizMan_agent_reg]
(

@level		char(1)		='',
@userID		varchar(50)	= '',
@userName	varchar(30)	='',
@chargeName	varchar(30)	= '',
@userAddr	varchar(100)	='',
@userTel1	varchar(13)	='',
@userTel2	varchar(13)	='',
@userEmail	varchar(50)	='',
@BranchGubun	char(1)		='',
@BranchCode	VARCHAR(3)		='',
@id		varchar(50)	= '',
@name		varchar(30)	= '',

@KwCode	int		=0,
@KwName	varchar(25)	='',
@Period		char(1)		= '',
@startDay	smalldatetime,
@endDay	smalldatetime,
@originPrice	int=0,
@isDc		char(1)		='',
@isService	char(1)		='',
@ServiceNm	varchar(30)	= '',

@adName	varchar(20)	= '',
@adPart		varchar(100)	= '',
@adBelong	varchar(100)	= '',
@adDuty		varchar(100)	= '',

@adHp		varchar(14)	= '',
@adPhone	varchar(14)	= '',
@adEmail	varchar(100)	= '',
@Img1		varchar(100)	= '',
@Img2		varchar(100)	= '',
@Img3		varchar(100)	= '',
@Img1Title	varchar(100)	= '',
@Img2Title	varchar(100)	= '',
@Img3Title	varchar(100)	= '',
@adTextTitle1	varchar(30)	= '',
@adTextContent1	varchar(600)	= '',
@adTextTitle2	varchar(30)	= '',
@adTextContent2	varchar(600)	= '',
@adTextTitle3	varchar(30)	= '',
@adTextContent3	varchar(600)	= '',
@adHomepage	varchar(100)	= '',
@adblog		varchar(100)	= '',

@adMsgTitle	varchar(40)	= '',
@adMsgContent1	varchar(100)	= '',
@adMsgUrl1	varchar(100)	= '',
@adMsgContent2	varchar(100)	= '',
@adMsgUrl2	varchar(100)	= '',
@adMsgContent3	varchar(100)	= '',
@adMsgUrl3	varchar(100)	= '',
@adimg		varchar(100)	= '',



@paymethod	char(1)		='',
@payKind	char(1)		='',
@prePayDate	smalldatetime,
@note		varchar(1000)	= '',


@firm_name	varchar(30)	= '',
@firm_tel		varchar(30)	= '',
@boxnum	int=0,
@boxPrice	money		=0,
@service_price	money		=0,
@real_price	money		=0,
@Pay_Money	money		=0 ,
@Remain_Money money		=0 ,
@outparm	int	output	--출력값(good_id)
)
AS
SET NOCOUNT ON
BEGIN
DECLARE
	@Sql			varchar(8000),
	@rowCnt			int,				--영향받은 행갯수
	@error_var		int,				--오류 번호
	@adCode		int				--생성된 identity 값

 BEGIN TRAN
		SET @Sql = 'Insert INTO  tbl_BizMan_adinfo ('+
		'UserId,UserName,ChargeName,UserAddr , UserTel1,UserTel2, UserEmail, BranchGubun,BranchCode,Id,Name,'+
		' KwCode,KwName,Period,StartDay,EndDay,OriginPrice,adName,adPart,adBelong,adDuty, adPhone, adHp, adEmail, adTextTitle1, ' +
		'adTextContent1, adTextTitle2, adTextContent2, adTextTitle3, adTextContent3,adHomePage, adBlog,'+
		'adMsgTitle,adMsgContent1,adMsgContent2, adMsgContent3, adMsgUrl1, adMsgUrl2, adMsgUrl3,adImg,'+
		'RegDate,ModDate,isDC, Note, PayMethod , PayKind, PrePayDate,payState,adState,authState,Img1,Img2,Img3,Img1Title,Img2Title,Img3Title )'+
		' Values('''+
		CAST(@userId AS VARCHAR(30)) + '''' +
		', '''+CAST(@userName AS VARCHAR(30)) + ''''+
		', '''+CAST(@ChargeName AS VARCHAR(30)) + ''''+
		', '''+CAST(@userAddr AS VARCHAR(100)) + ''''+
		','''+CAST(@userTel1 AS VARCHAR(13)) + '''' +
		','''+CAST(@userTel2 AS VARCHAR(13)) + '''' +
		','''+CAST(@userEmail AS VARCHAR(50)) + '''' +
		','''+CAST(@BranchGubun AS CHAR(1)) + '''' +
		','''+CAST(@BranchCode AS varchar(3)) + '''' +
		','''+CAST(@ID AS VARCHAR(30)) + '''' +
		','''+CAST(@Name AS CHAR(30)) + '''' +


		','''+CAST(@KwCode AS VARCHAR) + ''''		+
		','''+CAST(@KwName AS VARCHAR(25)) + ''''		+
		','''+CAST(@Period AS CHAR(1)) + ''''		+
		','''+CAST(@StartDay AS VARCHAR(30)) + '''' +
		','''+CAST(@EndDay AS VARCHAR(30)) + '''' +
		','+CAST(@originPrice AS VARCHAR(30))  +
		','''+CAST(@adName AS VARCHAR(30)) + '''' +
		','''+CAST(@adPart AS VARCHAR(100)) + '''' +
		','''+CAST(@adBelong AS VARCHAR(100)) + '''' +
		','''+CAST(@adDuty AS VARCHAR(100)) + '''' +
		','''+CAST(@adPhone AS VARCHAR(14)) + '''' +
		','''+CAST(@adHp AS VARCHAR(14)) + '''' +
		','''+CAST(@adEmail AS VARCHAR(100)) + '''' +
		','''+CAST(@adTextTitle1 AS VARCHAR(30)) + '''' +

		','''+CAST(@adTextContent1 AS VARCHAR(600)) + '''' +
		','''+CAST(@adTextTitle2 AS VARCHAR(30)) + '''' +
		','''+CAST(@adTextContent2 AS VARCHAR(600)) + '''' +
		','''+CAST(@adTextTitle3 AS VARCHAR(30)) + '''' +
		','''+CAST(@adTextContent3 AS VARCHAR(600)) + '''' +
		','''+CAST(@adHomepage AS VARCHAR(100)) + '''' +
		','''+CAST(@adblog AS VARCHAR(100)) + '''' +

		','''+CAST(@adMsgTitle AS VARCHAR(40)) + '''' +
		','''+CAST(@adMsgContent1 AS VARCHAR(100)) + '''' +
		','''+CAST(@adMsgContent2 AS VARCHAR(100)) + '''' +
		','''+CAST(@adMsgContent3 AS VARCHAR(100)) + '''' +
		','''+CAST(@adMsgUrl1 AS VARCHAR(100)) + '''' +
		','''+CAST(@adMsgUrl2 AS VARCHAR(100)) + ''''   +
		','''+CAST(@adMsgUrl3 AS VARCHAR(100)) + '''' +
		','''+CAST(@adimg AS VARCHAR(100)) + ''''		+

		',    getdate() ' +
		',    getdate() ' +
		','''+CAST(@isDc AS CHAR(1)) + '''' +
		','''+CAST(@note AS VARCHAR(1000)) + '''' +
		','''+CAST(@paymethod AS CHAR(1)) + '''' +
		','''+CAST(@payKind AS CHAR(1)) + '''' +
	  	','''+CAST(@prepaydate AS VARCHAR) + ''',''I'',''N'',''N'' , ''' +
		CAST(@Img1 AS VARCHAR(100)) + ''' , ''' +
		CAST(@Img2 AS VARCHAR(100)) + ''' , ''' +
		CAST(@Img3 AS VARCHAR(100)) + ''' , ''' +
		CAST(@Img1Title AS VARCHAR(100)) + ''' , '''	+
		CAST(@Img2Title AS VARCHAR(100)) + ''' , ''' +
		CAST(@Img3Title AS VARCHAR(100)) + '''  ) ;'


		EXECUTE(@Sql)
		--Print(@Sql)
		SET @adCode =  @@Identity ;

				SET @Sql =  'InSERT INTO tbl_BizMan_income ( ' +
				          ' Code,Firm_Name , Firm_Tel, BoxNum, BoxPrice, Service_Price , Real_Price, Pay_Money, Remain_Money)'+
				          'Values (' +
				           CAST (@AdCode AS VARCHAR) +
			           	          ','''+CAST(@firm_name AS VARCHAR(30)) + '''' +
				          ','''+CAST(@firm_tel AS VARCHAR(30)) + '''' +
				          ','''+CAST(@boxnum AS VARCHAR) + '''' +
				          ','+CAST(@boxPrice AS varchar) +
				          ','+CAST(@service_price AS VARCHAR) +
				          ','+CAST(@real_price AS VARCHAR) +
				          ','+CAST(@Pay_Money AS VARCHAR) +
				          ','+CAST(@Remain_Money AS VARCHAR) + ' ) '


			--Print(@Sql)
		EXECUTE(@Sql)
--	Print(@Sql)
	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
	--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END

--커밋
	SET @outparm	=  @AdCode

    COMMIT TRAN
RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_existKw]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명			: [비즈맨] 키워드 존재여부 검사
	제작자		: 정윤정
	제작일		: 2004.11.09
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_BizMan_existKw]
@kwName varchar(25) = ''
AS
SET NOCOUNT ON
	BEGIN
		--SELECT kwCode FROM tbl_bizman WITH (NOLOCK) WHERE Replace(kwName, '-', '') = Replace(@kwName, '-', '')
		SELECT kwCode FROM tbl_bizman WITH (NOLOCK) WHERE kwName = @kwName
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_insertKw]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: [비즈맨]키워드 등록 SP
	제작자		: 정윤정
	제작일		: 2004.11.10
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_BizMan_insertKw]
@kwName				varchar(25) ='',	-- 키워드명
@readCnt			int = 0,			-- 노출수
@ClickCnt			int = 0,			-- 클릭수
@flag				tinyint = 2,		-- 키워드 상태
@outparm			int  OUTPUT			--출력값(good_id)
AS
SET NOCOUNT ON
BEGIN

DECLARE
@rowCnt			int,				--영향받은 행갯수
@error_var		int,				--오류 번호
@tmpKwCode		int				--생성된 identity 값

	--트랜잭션 시작
	BEGIN TRAN

	if @kwName = ''
	BEGIN
		ROLLBACK TRAN
		SET @outparm = 0
		RETURN(1)
	END

	--키워드 등록 tbl_bizman
	INSERT INTO tbl_bizman (kwName, readCnt, clickCnt, Flag) VALUES (@kwName, 0, 0, @flag)

	--오류번호, 적용 행 갯수 셋팅
	SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
	--에러 발생시
	IF @error_var <> 0
		BEGIN
			ROLLBACK TRAN
			SET @outparm = 0
			--SET @outparm = '키워드가 입력되지 않았습니다.'
			--PRINT 'Error 번호: ' + CAST(@error_var AS VARCHAR(5))
			RETURN(1)
		END
	--입력이 되지 않았으면
	IF @rowCnt = 0
		BEGIN
			ROLLBACK TRAN
			SET @outparm = 0
			--SET @outparm = '키워드가 입력되지 않았습니다.'
			--PRINT 'Warning: No rows were inserted'
			RETURN(1)
		END

	--정상적으로 입력되었으면 아이덴티티 셋팅
	SELECT @tmpKwCode = @@identity

	--커밋
	COMMIT TRAN
	SET @outparm = @tmpKwCode
	RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_postbanner_contract_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BizMan_postbanner_contract_list_01]

	@kwname		varchar(25) = ''
	,@s_date	varchar(10) = ''
	,@e_date	varchar(10) = ''
	,@adState	char(1) = ''
	,@payState	char(1) = ''
	,@code		int = 1

AS
	SET NOCOUNT ON

	DECLARE
	@Sql		varchar(1000)

	SET @Sql = 'select kwname, startday, endday, adState, payState from tbl_bizman_adinfo with (NoLock) '

	if @kwname <> ''
		begin
			SET @Sql = @Sql + ' where kwname = '''+@kwname+''' '
		end


	SET @Sql = @Sql + ' and (( '
	SET @Sql = @Sql + ' CONVERT(varchar(10), startday,120) >= '''+@s_date+''' '
	SET @Sql = @Sql + ' and '
	SET @Sql = @Sql + ' CONVERT(varchar(10), startday,120) <= '''+@e_date+''' '
	SET @Sql = @Sql + ' ) or ( '
	SET @Sql = @Sql + ' CONVERT(varchar(10), endday,120) >= '''+@s_date+''' '
	SET @Sql = @Sql + ' and '
	SET @Sql = @Sql + ' CONVERT(varchar(10), endday,120) <= '''+@e_date+''' '
	SET @Sql = @Sql + ' )) '


	if @adState <> ''
		begin
			SET @Sql = @Sql + ' and adState = '''+@adState+''' '
		end

	if @payState <> ''
		begin
			SET @Sql = @Sql + ' and payState = '''+@payState+''' '
		end

	SET @Sql = @Sql + ' and code <> '''+CAST(@code AS VARCHAR(5)) + ''' '

		--print(@sql)
	Execute(@sql)
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_postbanner_edit_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BizMan_postbanner_edit_01]

	@code		int = 1
AS
	SET NOCOUNT ON

	DECLARE @Sql		varchar(1000)

	SET @Sql = 'select top 1 a.*,  i.firm_name ,i.firm_tel ,i.BoxNum,i.boxPrice,i.service_price,i.real_price,i.Pay_Money, i.Remain_Money, c.readCnt  '
	SET @Sql = @Sql + ' from tbl_bizman_adinfo a '
	SET @Sql = @Sql + ' INNER JOIN tbl_bizman k ON a.kwcode = k.kwcode '
	SET @Sql = @Sql + ' Left OUTER JOIN   tbl_bizman_income i ON a.code = i.Code '
	SET @Sql = @Sql + ' left outer JOIN tbl_bizman_kwcnt c ON a.kwcode = c.kwcode  '
	SET @Sql = @Sql + ' where a.code = '''+CAST(@code AS varCHAR(5)) + ''' '
	--print(@sql)

	Execute(@sql)
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_postbanner_list_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: [비즈맨]광고관리 리스트
	제작자		: 정윤정
	제작일		: 2004.11.18
	수정자		:
	수정일		:
	파라미터
use keywordshop
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_BizMan_postbanner_list_02]
	@sYY			char(4) = ''
	,@sMM			char(2) = ''
	,@sDD			char(4) = ''
	,@eYY			char(4) = ''
	,@eMM			char(2) = ''
	,@eDD			char(2) = ''
	,@s_date		char(10) = ''
	,@e_date		char(10) = ''
	,@gotopage		int = 0
	,@DateSearch		varchar(10)	= ''
	,@sText			varchar(30)	= ''
	,@sSearch		varchar(10)	= ''
	,@toppage		int = 1
	,@check_cnt		int = 1
	,@sAdState		char(1)
	,@sPayState		char(1)
	,@sSectionGbn		tinyint = 0
	,@sMember		char(3)
AS
	SET NOCOUNT ON

	BEGIN
	DECLARE
		@Sql		varchar(1000)

	if @check_cnt = '1'
		begin
			SET @Sql = 'select count(code) from tbl_bizman_adinfo a with (noLock)  '
		end
	else
		begin
			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' '
			SET @Sql = @sql + ' a.code, a.userid, a.username, a.id, a.name, a.kwcode, a.period, a.startday, a.endday,  '
			SET @Sql = @sql + ' a.originPrice, a.isExtend, a.payMethod, a.prePayDate, a.payDate, a.payState, a.adState, a.authState, a.authDate,  '
			SET @Sql = @sql + ' a.regDate, a.branchcode, a.kwname, a.isService,a.SectionGbn, b.real_price '
			SET @Sql = @sql + ' from tbl_bizman_adinfo a with (noLock) LEFT OUTER JOIN tbl_bizman_income b with (noLock) ON a.code=b.code '
		end

-------------------------------------------------------------------------------------------------------------------------


		SET @Sql = @Sql + ' where a.code <> '''' '

		if @sAdState <> 'A'		-- 광고 상태
			begin
				if @sAdState ='G'
					begin
						SET @Sql = @Sql + ' and adState <> ''E'' '
					end
				else
					begin
						SET @Sql = @Sql + ' and adState = '''+@sAdState+''' '
					end
			end


		if @sPayState <> ''		-- 결제상태
			begin
				SET @Sql = @Sql + ' and payState = '''+@spayState+''' '
			end
		if @sSectionGbn <> 99 AND @sSectionGbn <> 0 AND @sSectionGbn <> '' AND @sSectionGbn <> 100
			Begin
				SET @Sql= @Sql + ' AND SectionGbn= '''+Convert(varchar , @sSectionGbn)  + ''' '
			End
		Else If @sSectionGbn = 100
			Begin
				SET @Sql = @Sql + ' AND (SectionGbn <> 0 AND SectionGbn <> 99 AND SectionGbn Is NOT NULL) '
			End

		if @sMember <> ''		-- 등록자
			begin
				if @sMember = '100'		-- 회원
					begin
						SET @Sql = @Sql + ' and userid <> '''' and (branchcode = '''' or branchcode is null) '
					end
				else if @sMember = '200'		-- 등록대행 (전체)
					begin
						SET @Sql = @Sql + ' and branchcode <> '''' and branchcode is not null '
					end
				else if @sMember = '300'		-- 지점 (전체)
					begin
						SET @Sql = @Sql + ' and branchGubun=1 '
					end
				else if @sMember = '400'		-- 지사 (전체)
					begin
						SET @Sql = @Sql + ' and branchGubun=2 '
					end
				else if @sMember = '500'		-- 지점사 (전체)
					begin
						SET @Sql = @Sql + ' and (branchGubun=1 or branchGubun=2) '
					end
				else
					begin
						SET @Sql = @Sql + ' and  branchcode ='+@sMember
					end
			end


		if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
			begin
				SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
			end


	if @s_date <> '' and @e_Date <> ''
		begin

			if @DateSearch  = 'regdate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else if @DateSearch  = 'StartDate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), startDay,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), startDay,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), startDay,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), startDay,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else if @DateSearch  = 'EndDate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), endDay,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), endDay,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), endDay,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), endDay,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else if @DateSearch  = 'P_EndDate'
				begin
					SET @sql = @sql + ' '
				end
			else
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
		end

--// -----------------------------------------------------------------------------------------------------------------
		if @check_cnt = '0'

		--	if @hclass = 'f'
				begin
					SET @Sql = @Sql +' order by a.regdate desc'
				end
		--	else
		--		begin
		--			SET @Sql = @Sql +' order by a.paydate desc'
		--		end

	END
--print(@sql)
	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_postbanner_list_action_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BizMan_postbanner_list_action_01]
	(
		@key		char(1) = ''
		,@code		int = 0
		,@outparm	int	= '0'  OUTPUT			--출력값(good_id)
	)

AS
	SET NOCOUNT ON

	DECLARE
	@error_var		int				--오류 번호
	,@adCode		int				--생성된 identity 값
	,@rowCnt		int				--영향받은 행갯수

	BEGIN TRAN

		if @key = 'Y'
			begin
				update tbl_bizman_adinfo set adState = 'Y',authDate = getdate() where code = @code
			end
		else
			begin
				if @key = 'E'
					begin
						update tbl_bizman_adinfo set adState = 'E', authDate = getdate() where code = @code

					end
				else
					begin
						if @key = 'C'
							begin
								update tbl_bizman_adinfo set adState = 'C', authDate = getdate() where code = @code
							end
					end
			end

	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR

	--에러 발생시
	IF @error_var <> 0
		BEGIN
			ROLLBACK TRAN
		END
	--입력이 되지 않았으면

	IF @error_var = 0
		begin
			COMMIT TRAN
		end
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_postbanner_proxy_detail_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: 비즈맨 대행자 정보보기
	제작자		: 정윤정
	제작일		: 2004.12.09
	수정자		:
	수정일		:
	파라미터
*****************************************************************************/
CREATE PROCEDURE [dbo].[sp_BizMan_postbanner_proxy_detail_01]

	@id		varchar(15)
	,@code	int = 0

AS
	SET NOCOUNT ON

	select a.id, a.name, a.branchcode, a.paymethod, a.originPrice,
		a.isDC, a.note,  i.real_Price
		from tbl_bizman_adinfo a with (noLock)
		left outer JOIN tbl_bizman_income i ON a.code = i.code

		where a.id = @id and a.code = @code
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_readCnt_Front]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
use keywordshop_test
	설명		:프론트  노출수  정보
	제작자		: 박준희
	제작일		: 2004.09.02
	수정자		:
	수정일		:
	파라미터   @kwName   : 검색키워드명
	설명 		:
			실제 키워드별 노출수가 아닌 기획팀에서 준 자료를
			임포팅한 테이블에서 데이터 가져와서 프론트페이지
			(광고 신청전 키워드 검색결과 페이지)에서 사용함
select * from tbl_kwCnt_Front with(NoLock)
******************************************************************************/

CREATE PROC [dbo].[sp_BizMan_readCnt_Front]
@kwName varchar(25) = ''
AS
	BEGIN
		DECLARE @sql	varchar(2000)
		DECLARE @today_y int
		DECLARE @today_m int
		DECLARE @today_d int
		DECLARE @regday_y int
		DECLARE @regday_m int
		DECLARE @readCnt int
		DECLARE @kwCode int

		Set @today_y = DATEPART(year, getdate())
		Set @today_m = DATEPART(month, getdate())
		Set @today_d =  DATEPART(day, getdate())



		SELECT @kwCode = kwCode, @regday_y = DATEPART(year, kwRegDate), @regday_m = DATEPART (month, kwRegDate), @readCnt = readCnt FROM tbl_BizMan WITH (NOLOCK) WHERE kwName = @kwName

		IF @kwCode is null
			Set @sql = 'SELECT 0 as readCnt'
		ELSE
			BEGIN
				IF (@today_y = @regday_y) and (@today_m = @regday_m )
					begin
--					Set @sql = 'SELECT isNull(CAST(' + RTRIM(CAST(@readCnt as varchar(20))) + ' as int), 0) as readCnt'
					Set @sql = 'SELECT 0 as readCnt'
					end
				ELSE
					IF @today_d >= 10    --10일 이후엔. 그달  날짜
						BEGIN
						Set @sql = 'SELECT isNull(readCnt, 0) as readCnt FROM tbl_BizManCnt_Front WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) = 0) AND kwCode = CAST(' + RTRIM(CAST(@kwCode as varchar(20))) + ' as int)'
						END
					ELSE
						BEGIN	   -- 10일 이전엔 그 전달 날짜
						Set @sql = 'SELECT isNull(readCnt, 0) as readCnt FROM tbl_BizManCnt_Front WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) =0) AND kwCode = CAST(' + RTRIM(CAST(@kwCode as varchar(20))) + ' as int)'
						END


			END

		EXECUTE(@sql)
--		Print(@sql)
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_bizman_Repay_Reg]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: [비즈맨]광고 판매 리스트
	제작자		: 정윤정
	제작일		: 2004.11.19
	수정자		: 정윤정
	수정일		:
	파라미터
select * from tbl_bizman_repay with(NoLock)



*************************************************************************/

CREATE PROCEDURE [dbo].[sp_bizman_Repay_Reg]
(
	@AdCode			int  = 0  ,
	@RepayMoney			int =0  ,
	@RepayReason			varchar(300)= '' ,
	@Magid				varchar(30) ='' ,
	@RepayDate			smalldatetime
)



AS
SET NOCOUNT ON
BEGIN
	DEClare @CntAdCode int

	SELECT  Count(AdCode) From tbl_bizman_Repay With(NOLOCK)  WHERE AdCode= @AdCode ;
	SELECT  @CntAdCode = Count(AdCode) From tbl_bizman_Repay WHERE AdCode= @AdCode ;

	IF @CntAdCode <=0
	BEGIN
	Insert Into tbl_bizman_Repay(AdCode, RepayMoney, RepayReason, Magid, RepayDate, RegDate )
	Values(@Adcode , @RepayMoney , @RepayReason , @MagId , @RepayDate , GETDATE() ) ;
	UPDATE tbl_bizman_Adinfo SET payState ='R' WHERE Code=@AdCode
	END




END
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_service_keyword_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BizMan_service_keyword_01]
	(
		@key		char(1)
		,@sText		varchar(25)
	)
AS
	SET NOCOUNT ON

	if @key = '1'
		begin
			select kwcode, kwname from tbl_BizMan with (noLock) where kwname = @sText
		end
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_service_keyword_action_03]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BizMan_service_keyword_action_03]
	(
		@key			char(1) = ''
		,@sText			varchar(25) = ''

	)
AS
	SET NOCOUNT ON

	if @key = '1'
		begin
			select count(code)
				from tbl_BizMan_adinfo a with (NOLOCK)
				where  kwName = @sText  and adState in ('Y','N','C')
		end
	else
		begin
			select count(idx)
				from tbl_session  with (NOLOCK)
				where  kwName = @sText
		end
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_service_keyword_search_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BizMan_service_keyword_search_01]


	@code			int
	,@sText			varchar(25)

AS
	SET NOCOUNT ON


	DECLARE @Sql		varchar(1000)

	SET @Sql = 'select top 10 a.kwname, a.kwcode  from tbl_BizMan  w  With(NoLock) '
	SET @Sql = @sql + ' left outer join tbl_BizMan_adinfo a '
	SET @Sql = @sql + ' ON w.kwname = a.kwname '

	SET @Sql = @sql + ' where a.code <> '''' and adState in (''Y'',''N'') '




	if @code <> '' and @sText <> ''
		begin
			SET @Sql = @sql + ' and a.kwName = '''+@sText+''' '
		end
	else		-- code <>'' and sText = ''
		begin
			SET @Sql = @sql + ' and a.code = '''+CAST(@code AS VARCHAR(5)) +''' '
		end


	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[sp_BizMan_sessionTime]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: [비즈맨]세션 30분 카운터
	제작자		: 정윤정
	제작일		: 2004.11.11
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROC [dbo].[sp_BizMan_sessionTime]
@idx int
AS
BEGIN
	DECLARE @kwCode int
	DECLARE @endDate datetime

	SELECT @kwCode = isNull(kwCode, 0), @endDate = DATEADD (minute , 30, startTime) FROM tbl_BizMan_session WITH (NOLOCK) WHERE idx = @idx

	IF @kwCode = 0
		BEGIN
			SELECT ''  as 'todayYear',
			''  as 'todayMonth',
			''  as 'todayDay',
			''  as 'todayHour',
			''  as 'todayMinute',
			''  as 'todaySecond',
			''  as 'endYear',
			''  as 'endMonth',
			''  as 'endDay',
			''  as 'endHour',
			'' as 'endMinute',
			''  as 'endSecond'
		END
	ELSE
		BEGIN
			SELECT DATEPART (year , getdate())  as 'todayYear',
			DATEPART (month , getdate())  as 'todayMonth',
			DATEPART (day , getdate())  as 'todayDay',
			DATEPART (hour , getdate())  as 'todayHour',
			DATEPART (minute , getdate())  as 'todayMinute',
			DATEPART (second , getdate())  as 'todaySecond',
			DATEPART (year , @endDate)  as 'endYear',
			DATEPART (month , @endDate)  as 'endMonth',
			DATEPART (day , @endDate)  as 'endDay',
			DATEPART (hour , @endDate)  as 'endHour',
			DATEPART (minute , @endDate)  as 'endMinute',
			DATEPART (second , @endDate)  as 'endSecond'
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_bothKeyword]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 유의어 검색
	제작자		: 정윤정
	제작일		: 2004.04.22
	수정자		:
	수정일		:
	수정내용	:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_bothKeyword]
(
	@searchKwName	varchar(30)	= ''
)
AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(300),
		@kwName	varchar(30),
		@kwCode	int

	SET @kwName	= ''
	SET @kwCode = 0

	-- 유의어 검색
	SELECT @kwCode = kwCode from tbl_similarkw with (nolock) where similarkwname = ''+@searchKwName+''

	IF (@kwCode is null) or (@kwCode = 0)
		BEGIN
			SELECT @kwCode = kwCode, @kwName = kwName from tbl_keyword with (nolock) where kwname = ''+@searchKwName+''
		END
	ELSE
		BEGIN
			SELECT @kwName = kwName from tbl_keyword with (nolock) where kwCode = @kwCode
		END

	Set @sql = 'SELECT ''' + @kwName + ''' as kwName,  similarkwname from tbl_similarkw with (nolock) where kwCode = ' + cast(@kwCode as varchar(20))

	Execute(@sql)
--print(@sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ContentsSearch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 컨텐츠 키워드 검색
	제작자		: 이기운
	제작일		: 2004.03.27
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_ContentsSearch]
(
	@kwName	varchar(30)	= '',
	@Idx		int = 0
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(100)
	if @kwName <> ''
	BEGIN
		SET @Sql = 'select top 1 kwname,Idx from dbo.tbl_Contents with (nolock) where kwname = '''+@kwName+''''
	END
	if @Idx > 0
	BEGIN
		SET @Sql = 'select top 1 kwname,Idx from dbo.tbl_Contents with (nolock) where Idx = '+Cast(@Idx as varchar)
	END


	EXECUTE(@Sql)
	--Print(@Sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CtnDtlSearch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 컨텐츠용 키워드 검색 - 팝업용 상세정보
	제작자		: 정윤정
	제작일		: 2005.03.21
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_CtnDtlSearch]
(
	@idx 	int = 0
)
AS
SET NOCOUNT ON
BEGIN
	SELECT adSerial, dtlTitle, dtlContents
	FROM tbl_DtlContents WITH (NOLOCK)
	WHERE idx = @idx
	ORDER BY adSerial ASC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CtnImgSearch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 컨텐츠용 키워드 검색 - 팝업용 이미지정보
	제작자		: 정윤정
	제작일		: 2005.03.21
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_CtnImgSearch]
(
	@idx 	int = 0
)
AS
SET NOCOUNT ON
BEGIN
	SELECT title, isNull(img2, '') as img2, isNull(img3, '') as img3, isNull(img4, '') as img4, isNull(img5, '') as img5
	FROM tbl_Contents WITH (NOLOCK)
	WHERE idx = @idx
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Ctnkwlist]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 컨텐츠용 키워드 리스트
	제작자		: 정윤정
	제작일		: 2005.03.16
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_Ctnkwlist]
(
	@top				int = 0,
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = '',
	@DateGbn			varchar(10) = '',
	@kwSection			char(1) = '8',
	@kwSelect			char(1) = '0',
	@kwName				varchar(25) = '',
	@kwFlag				char(1) = 'A',
	@kwLink				char(1) = '0',

	@outparam		int=0	OUTPUT
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(500)

	Set @Sql='SELECT '

	IF @top > 0
	BEGIN
		SET @Sql = @Sql + ' top '+Cast(@top as varchar)+' '
	END
	SET @Sql = @Sql + ' idx, KwName, SectionGbn, Title, LinkUrl, RegDate, AdStatus '
	SET @Sql = @Sql + ' FROM tbl_Contents WITH (NOLOCK) '
	SET @Sql = @Sql + ' WHERE 1=1 '

	SET @Sql = @Sql + ' '

	IF @DateGbn = 'kwRegDate'
	BEGIN
		SET @Sql = @Sql + ' AND RegDate BETWEEN '''+@sDate+''' AND '''+@eDate+''''
	END

	-- 상태
	IF @kwFlag <> 'A'
	BEGIN
		SET @Sql = @Sql + ' AND AdStatus = ''' + Cast(@kwFlag as varchar) + ''' '
	END

	IF @kwLink = '1'
	BEGIN
		SET @Sql = @Sql + ' AND (LinkUrl is NOT NULL AND LinkUrl <> '''' )'
	END

	IF @kwLink = '2'
	BEGIN
		SET @Sql = @Sql + ' AND (LinkUrl is NULL OR LinkUrl = '''' )'
	END


	IF @kwSection <> '8'
	BEGIN
		SET @Sql = @Sql + ' AND SectionGbn = '+@kwSection
	END

	IF @kwSelect <> '0'
	BEGIN
		SET @Sql = @Sql + ' AND (kwName = '''+@kwName+''' OR idx in (SELECT DISTINCT idx FROM tbl_SimilarContents WHERE SimilarKwName = ''' + @kwName + ''')) '
	END

	SET @Sql = @Sql + ' ORDER BY idx DESC'

	--PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CtnkwlistCnt]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 컨텐츠용 키워드 리스트 카운터
	제작자		: 정윤정
	제작일		: 2005.03.16
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_CtnkwlistCnt]
(
	@top				int = 0,
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = '',
	@DateGbn			varchar(10) = '',
	@kwSection			char(1) = '8',
	@kwSelect			char(1) = '0',
	@kwName			varchar(25) = '',
	@kwFlag				char(1) = 'A',
	@kwLink				char(1) = '0',

	@outparam		int=0	OUTPUT
)

AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(500)

	Set @Sql='SELECT count(idx) as Cnt '
	SET @Sql = @Sql + ' FROM tbl_Contents WITH (NOLOCK) '
	SET @Sql = @Sql + ' WHERE 1=1 '


	IF @DateGbn = 'kwRegDate'
	BEGIN
		SET @Sql = @Sql + ' AND RegDate BETWEEN '''+@sDate+''' AND '''+@eDate+''''
	END

	-- 상태
	IF @kwFlag <> 'A'
	BEGIN
		SET @Sql = @Sql + ' AND AdStatus = '''+Cast(@kwFlag as varchar)+''' '
	END

	IF @kwLink = '1'
	BEGIN
		SET @Sql = @Sql + ' AND (LinkUrl is NOT NULL AND LinkUrl <> '''' )'
	END

	IF @kwLink = '2'
	BEGIN
		SET @Sql = @Sql + ' AND (LinkUrl is NULL OR LinkUrl = '''' )'
	END


	IF @kwSection <> '8'
	BEGIN
		SET @Sql = @Sql + ' AND SectionGbn = '+@kwSection
	END

	IF @kwSelect <> '0'
	BEGIN
		SET @Sql = @Sql + ' AND (kwName = '''+@kwName+''' OR idx in (SELECT DISTINCT idx FROM tbl_SimilarContents WHERE SimilarKwName = ''' + @kwName + ''')) '
	END

	--PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CtnkwStatusUpdate]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

----------------------------------------------------------------
작성일자	: 2005년 03월 17일
작성자	: 정윤정
내용	: 키워드 상태 변경
수정일자	:
수정자	:
수정내용	:
기타	:
----------------------------------------------------------------

*/


CREATE PROC 	[dbo].[sp_CtnkwStatusUpdate]

@KwCode		int = 0			-- 키워드 코드

AS
SET NOCOUNT ON
BEGIN
	UPDATE tbl_Contents
	SET adStatus = CASE WHEN  adStatus = 'Y' THEN 'N' ELSE 'Y' END
	Where idx = @KwCode
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CtnSearch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 컨텐츠용 키워드 검색
	제작자		: 정윤정
	제작일		: 2005.03.21
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_CtnSearch]
(
	@kwName				varchar(25) = ''
)
AS
SET NOCOUNT ON
BEGIN
	DECLARE @idx int

	SET @idx = 0

	SELECT @idx = idx FROM tbl_SimilarContents WITH (NOLOCK) WHERE similarKwName = @kwName

	IF @idx = 0
	BEGIN
		SELECT idx, title, img1, linkUrl, target, contents
		FROM tbl_contents WITH (NOLOCK)
		WHERE kwName = @kwName	AND adStatus = 'Y'
	END
	ELSE
	BEGIN
		SELECT idx, title, img1, linkUrl, target, contents
		FROM tbl_contents WITH (NOLOCK)
		WHERE idx = @idx	AND adStatus = 'Y'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CtnSimilarkwName]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 컨텐츠용 유의키워드 조회
	제작자		: 정윤정
	제작일		: 2005.03.17
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_CtnSimilarkwName]
(
	@kwCode		int = 0,
	@output			int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT similarkwName FROM  tbl_SimilarContents  WITH (NOLOCK)  WHERE idx = @kwCode

END
GO
/****** Object:  StoredProcedure [dbo].[sp_gongji_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 공지사항 리스트
	제작자		: 고병호
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_gongji_list_01]

	@sYY			int	= 0
	,@sMM			int = 0
	,@sDD			int = 0
	,@eYY			int = 0
	,@eMM			int = 0
	,@eDD			int = 0
	,@s_date		varchar(10) = ''
	,@e_date		varchar(10) = ''
	,@gotopage		int = 0
	,@sText			varchar(30) = ''
	,@sSearch		varchar(10) = ''
	,@toppage		int = 1
	,@check_cnt		int = 1
	,@s_view		char(1)
	,@s_view_main	char(1)

AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(1000)



	if @check_cnt = '1'
		begin
			SET @Sql = 'select count(num) from tbl_gongji with (noLock)  '
		end
	else
		begin
			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' * from tbl_gongji with (noLock)  '
		end

-------------------------------------------------------------------------------------------------------------------------


	SET @Sql = @Sql + ' where title <> '''' '

	if @s_view_main <> ''
		begin
			SET @sql = @sql + ' and view_main = '''+@s_view_main+''' '
		End


	if @s_view <> ''
		begin
			SET @sql = @sql + case @s_view
				when '1' then ' and view_user = 1 '--''1'' '
				when '2' then ' and view_admin1 = 1' --''1'' '
				when '3' then ' and view_admin2 = 1' --''1'' '
			end

		end


	if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
		begin
			SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
		end


	if @s_date <> '' and @e_date <> ''
			begin
				SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
				SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
			end
		else
			begin
				if @s_date <> '' and @e_date = ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
					end
				else
					begin
						if @s_date = '' and @e_date = ''
							begin
								SET @sql = @sql + ' '
							end
						else
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
							end
					end
			end

--// -----------------------------------------------------------------------------------------------------------------
	if @check_cnt = '0'
		begin
			SET @Sql = @Sql +' order by num desc'
		end


--print(@sql)
	EXECUTE(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[sp_hotKw]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 인기키워드 정보
	제작자		: 정윤정
	제작일		: 2004.03.30
	수정자		: 이상무
	수정일		: 2004.07.14
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_hotKw]
AS
	BEGIN
		DECLARE @sql	varchar(250)

		--SET @sql = 'SELECT a.kwName, b.lineNum, b.rowNum FROM tbl_keyword a WITH (NOLOCK) JOIN tbl_hotkw b ON a.kwCode = b.kwCode WHERE a.kwHotChk = ''1'' and a.kwHotViewChk = ''1'' ORDER BY b.lineNum, b.rowNum'

		--EXECUTE(@sql)
		--Print(@sql)

		SELECT lineNum,rowNum,isNull(k.kwName,'') as kwName,h.kwCode
		FROM tbl_hotkw as h with (nolock) LEFT OUTER JOIN tbl_keyword as k with (nolock) ON h.kwcode = k.kwcode
		WHERE lineNum <= 3 and rowNum <=10
		order by lineNum, rowNum
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_keywordSearch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 검색
	제작자		: 이기운
	제작일		: 2004.03.27
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_keywordSearch]
(
	@kwName	varchar(30)	= '',
	@kwCode	int = 0
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(100)
	if @kwName <> ''
	BEGIN
		SET @Sql = 'select top 1 kwname,kwCode from tbl_keyword with (nolock) where kwname = '''+@kwName+''''
	END
	if @kwCode > 0
	BEGIN
		SET @Sql = 'select top 1 kwname,kwCode from tbl_keyword with (nolock) where kwCode = '+Cast(@kwCode as varchar)
	END


	EXECUTE(@Sql)
	--Print(@Sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwAddFieldRead]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 등급별 가중치 조회
	제작자		: 이기운
	제작일		: 2004.04.8
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_kwAddFieldRead]
(
	@FieldName		varchar(20),
	@output			int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

DECLARE @sql	varchar(200)

	SET @sql = 'select top 1 '+@FieldName+' from tbl_add with (nolock) Where datediff(m,regdate,getdate()) = 0'
	EXECUTE(@sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_KwCnt_Front_Insert]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 리스트 카운터
	제작자		: 이기운
	제작일		: 2004.04.04
	수정자		:
	수정일		:
	파라미터
sp_readCnt_Front

use keywordshop

select * from tbl_kwcnt_front  where month(regdate) ='10'

select * from tbl_keyword where kwname='쏘나타'
******************************************************************************/


CREATE PROCEDURE [dbo].[sp_KwCnt_Front_Insert]


AS


insert into dbo.tbl_KwCnt_Front ( kwcode, readCnt , YearMonth, regDate)

select k.kwCode ,  isnull(r.readcnt, 6900)  as readCnt ,  '2004-10' , GetDate()
From tbl_keyword as k  left outer join  keywordshop_test3.dbo.tbl_kwcnt_front_temp   as R on K.kwName = R.kwname
GO
/****** Object:  StoredProcedure [dbo].[sp_kwlist]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 리스트
	제작자		: 이기운
	제작일		: 2004.03.27
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_kwlist]
(
	@top				int = 0,
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = '',
	@DateGbn			varchar(10) = '',
	@kwGrade			tinyint = 0,
	@kwSection			char(1) = '8',
	@kwHotSubName		varchar(25) = '',
	@kwHotViewchk		char(1) = '2',
	@kwHotSubNameChk	char(1) = '2',
	@kwSelect			char(1) = '0',
	@kwName				varchar(25) = '',
	@kwFlag				int = 0,
	@kwHotChk			char(1) = '0',

	@outparam		int=0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(500)

	Set @Sql='SELECT '

	IF @top > 0
	BEGIN
		SET @Sql = @Sql + ' top '+Cast(@top as varchar)+' '
	END
	SET @Sql = @Sql + ' kwCode,kwName,kwGrade,dbo.F_Section(kwSection) as kwSection,isNULL(kwHotSubName,'''') as kwHotSubName,kwHotSubNameChk,kwHotViewchk,kwRegDate,kwHotChk'
	SET @Sql = @Sql + ' FROM tbl_keyword WITH (NOLOCK) WHERE 1=1'

	-- 검색날짜 선택
	IF @DateGbn = 'kwModDate'
	BEGIN
		SET @Sql = @Sql + ' AND kwModDate BETWEEN '''+@sDate+''' AND '''+@eDate+''''
	END
	IF @DateGbn = 'kwRegDate'
	BEGIN
		SET @Sql = @Sql + ' AND kwRegDate BETWEEN '''+@sDate+''' AND '''+@eDate+''''
	END

	-- 등급
	IF @kwGrade > 0
	BEGIN
		SET @Sql = @Sql + ' AND kwGrade = '+Cast(@kwGrade as varchar)+' '
	END

	-- 상태
	IF @kwFlag > 0
	BEGIN
		SET @Sql = @Sql + ' AND flag = '+Cast(@kwFlag as varchar)+' '
	END

	IF @kwSection <> '8'
	BEGIN
		SET @Sql = @Sql + ' AND kwSection = '''+@kwSection+''''
	END

	IF @kwHotChk = '1'
	BEGIN
		SET @Sql = @Sql + ' AND kwHotChk = '+Cast(1 as char(1))+' '
	END

	IF @kwHotSubName = '분류없음'
	BEGIN
		SET @Sql = @Sql + ' AND kwHotSubName = '''' '
	END
	ELSE IF @kwHotSubName <> ''
	BEGIN
		SET @Sql = @Sql + ' AND kwHotSubName = '''+@kwHotSubName+''''
	END

	IF @kwHotViewchk <> '2'
	BEGIN
		SET @Sql = @Sql + ' AND kwHotViewchk = '''+@kwHotViewchk+''''
	END
	IF @kwHotSubNameChk <> '2'
	BEGIN
		SET @Sql = @Sql + ' AND kwHotSubNameChk = '''+@kwHotSubNameChk+''''
	END

	IF @kwSelect = '1'
	BEGIN
		SET @Sql = @Sql + ' AND kwName = '''+@kwName+''''
	END
	IF @kwSelect = '3'
	BEGIN
		SET @Sql = @Sql + ' AND RelationKw like ''%'+@kwName+'%'''
	END
	IF @kwSelect = '2'
	BEGIN
		SET @Sql = @Sql + ' AND kwCode = (select top 1 kwCode from tbl_SimilarKw WITH (NOLOCK) WHERE similarkwName = '''+@kwName+''' )'
	END
	SET @Sql = @Sql + ' ORDER BY kwcode DESC'

	--PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwlistCnt]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 리스트 카운터
	제작자		: 이기운
	제작일		: 2004.04.04
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_kwlistCnt]
(
	@top				int = 0,
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = '',
	@DateGbn			varchar(10) = '',
	@kwGrade			tinyint = 0,
	@kwSection			char(1) = '8',
	@kwHotSubName		varchar(25) = '',
	@kwHotViewchk		char(1) = '2',
	@kwHotSubNameChk	char(1) = '2',
	@kwSelect			char(1) = '0',
	@kwName				varchar(25) = '',
	@kwFlag				int = 0,
	@kwHotChk			char(1) = '0',

	@outparam		int=0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(500)

	Set @Sql='SELECT count(KwCode) as Cnt'
	SET @Sql = @Sql + ' FROM tbl_keyword WITH (NOLOCK) WHERE 1=1'

	-- 검색날짜 선택
	IF @DateGbn = 'kwModDate'
	BEGIN
		SET @Sql = @Sql + ' AND kwModDate BETWEEN '''+@sDate+''' AND '''+@eDate+''''
	END
	IF @DateGbn = 'kwRegDate'
	BEGIN
		SET @Sql = @Sql + ' AND kwRegDate BETWEEN '''+@sDate+''' AND '''+@eDate+''''
	END

	-- 등급
	IF @kwGrade > 0
	BEGIN
		SET @Sql = @Sql + ' AND kwGrade = '+Cast(@kwGrade as varchar)+' '
	END

	-- 상태
	IF @kwFlag > 0
	BEGIN
		SET @Sql = @Sql + ' AND flag = '+Cast(@kwFlag as varchar)+' '
	END

	IF @kwSection <> '8'
	BEGIN
		SET @Sql = @Sql + ' AND kwSection = '''+@kwSection+''''
	END

	IF @kwHotChk = '1'
	BEGIN
		SET @Sql = @Sql + ' AND kwHotChk = '+Cast(1 as char(1))+' '
	END

	IF @kwHotSubName = '분류없음'
	BEGIN
		SET @Sql = @Sql + ' AND kwHotSubName = '''' '
	END
	ELSE IF @kwHotSubName <> ''
	BEGIN
		SET @Sql = @Sql + ' AND kwHotSubName = '''+@kwHotSubName+''''
	END

	IF @kwHotViewchk <> '2'
	BEGIN
		SET @Sql = @Sql + ' AND kwHotViewchk = '''+@kwHotViewchk+''''
	END
	IF @kwHotSubNameChk <> '2'
	BEGIN
		SET @Sql = @Sql + ' AND kwHotSubNameChk = '''+@kwHotSubNameChk+''''
	END
	IF @kwSelect = '1'
	BEGIN
		SET @Sql = @Sql + ' AND kwName = '''+@kwName+''''
	END
	IF @kwSelect = '3'
	BEGIN
		SET @Sql = @Sql + ' AND RelationKw = '''+@kwName+''''
	END
	IF @kwSelect = '2'
	BEGIN
		SET @Sql = @Sql + ' AND kwCode = (select top 1 kwCode from tbl_SimilarKw WITH (NOLOCK) WHERE similarkwName = '''+@kwName+''' )'
	END


	--PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwNonePriceEdit]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 미지정 키워드 가격 가져오기
	제작자		: 이기운
	제작일		: 2004.04.8
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_kwNonePriceEdit]
(
	@szDate					varchar(10),
	@szDateKey				int = -1
)



AS
SET NOCOUNT ON
BEGIN

	-- 미지정키워드 가격 가져오기 다음달(기본)과 지정한달 가격
	SELECT cutPrice1, cutPrice2, cutPrice3 , dbo.F_DateFormat2(regdate) as szDate
	FROM tbl_kwNonePrice with (nolock) WHERE datediff(m,regdate,getdate()) = @szDateKey OR datediff(m,regdate,''+@szDate+'') = 0
	ORDER by szDate,goodGubun,goodRank


END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwOldReadCnt]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 과거 조회수
	제작자		: 이기운
	제작일		: 2004.04.5
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_kwOldReadCnt]
(
	@kwCode		int = 0,
	@output			int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT TOP 3  readCnt,clickCnt,dbo.F_DateFormat2(regdate) as regDate  FROM tbl_kwCnt WITH (NOLOCK) WHERE kwcode = @kwCode
	AND datediff(m,regdate,getdate()) <= 3 ORDER BY regdate DESC

END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwPriceAddList]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 가중치 목록 조회
	제작자		: 이기운
	제작일		: 2004.04.7
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_kwPriceAddList]
(
	@szDateKey		int = 0,
	@output			int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT level_1, level_2, level_3, level_4, level_5, level_6, level_7, level_8, level_9, level_10, 	--9
	goods_B, goods_H, goods_P, step_1, step_2, step_3, step_4, step_5,			 						--17
	section_1, section_2, section_3, section_4, section_5, section_6, section_7, section_8, 			--25
	sale_1, sale_2, sale_3, 																			--28
	etcmode_1, etcmode_2, etcmode_3, etcadd_1, etcadd_2, etcadd_3, 										--34
	etc_1, etc_2, etc_3
	FROM tbl_add with (nolock)
	WHERE datediff(m,regDate,getdate()) = @szDateKey

END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwPriceAddUpdate]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 가중치 목록 수정
	제작자		: 이기운
	제작일		: 2004.04.7
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_kwPriceAddUpdate]
(
	@level_1		float,
	@level_2		float,
	@level_3		float,
	@level_4		float,
	@level_5		float,
	@level_6		float,
	@level_7		float,
	@level_8		float,
	@level_9		float,
	@level_10		float,
	@goods_B		float,
	@goods_H		float,
	@goods_P		float,
	@step_1			float,
	@step_2			float,
	@step_3			float,
	@step_4			float,
	@step_5			float,
	@section_1		float,
	@section_2		float,
	@section_3		float,
	@section_4		float,
	@section_5		float,
	@section_6		float,
	@section_7		float,
	@section_8		float,
	@sale_1			float,
	@sale_2			float,
	@sale_3			float,
	@etcmode_1		char(1) = '0',
	@etcmode_2		char(1) = '0',
	@etcmode_3		char(1) = '0',
	@etcadd_1		float,
	@etcadd_2		float,
	@etcadd_3		float,
	@etc_1			varchar(100) = '',
	@etc_2			varchar(100) = '',
	@etc_3			varchar(100) = '',
	@output			int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	UPDATE tbl_add SET level_1 = @level_1, level_2 = @level_2, level_3 = @level_3, level_4 = @level_4, level_5 = @level_5,
	level_6 = @level_6, level_7 = @level_7, level_8 = @level_8, level_9 = @level_9, level_10 = @level_10, goods_B = @goods_B,
	goods_H = @goods_H, goods_P = @goods_P, step_1 = @step_1, step_2 =@step_2, step_3 = @step_3, step_4 = @step_4, step_5 = @step_5,
	section_1 = @section_1, section_2 = @section_2, section_3 = @section_3, section_4 = @section_4, section_5 = @section_5,
	section_6 = @section_6, section_7 = @section_7, section_8 = @section_8, sale_1 = @sale_1, sale_2 = @sale_2, sale_3 = @sale_3,
	etcmode_1 = @etcmode_1, etcadd_1 = @etcadd_1, etcmode_2 = @etcmode_2, etcadd_2 = @etcadd_2, etcmode_3 =@etcmode_3, etcadd_3 = @etcadd_3,
	etc_1 = @etc_1, etc_2 = @etc_2, etc_3 = @etc_3
	WHERE datediff(m,regDate,getdate()) = 0

END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwPriceEdit]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 가격 가져오기
	제작자		: 이기운
	제작일		: 2004.04.8
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_kwPriceEdit]
(
	@szDate					varchar(10),
	@kwCode					int,
	@szDatekey				int = -1
)



AS
SET NOCOUNT ON
BEGIN

	-- 키워드 가격 가져오기 다음달(기본)과 지정한달 가격과 지정 코드
	SELECT cutPrice1, cutPrice2, cutPrice3, netPrice1, netPrice2, netPrice3, dbo.F_DateFormat2(regdate) as szDate
	FROM tbl_kwprice with (nolock) WHERE ( datediff(m,regdate,getdate()) = @szDatekey OR datediff(m,regdate,''+@szDate+'') = 0  ) AND  kwcode = @kwCode
	ORDER by regdate,kwcode,goodGubun,goodRank
END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwPricelist]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 가격조회용 리스트
	제작자		: 이기운
	제작일		: 2004.04.7
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_kwPricelist]
(
	@top				int = 0,
--	@sDate				varchar(10) = '',
--	@eDate				varchar(10) = '',
--	@DateGbn			varchar(10) = '',
	@kwGrade			tinyint = 0,
--	@kwSection			char(1) = '8',
--	@kwHotSubName		varchar(25) = '',
--	@kwHotViewchk		char(1) = '2',
--	@kwHotSubNameChk	char(1) = '2',
	@kwSelect			char(1) = '0',
	@kwName				varchar(25) = '',
--	@kwFlag				int = 0,

	@outparam		int=0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(500)

	Set @Sql='SELECT '

	IF @top > 0
	BEGIN
		SET @Sql = @Sql + ' top '+Cast(@top as varchar)+' '
	END
	SET @Sql = @Sql + ' k.kwcode, kwname, isNull(c.readCnt,0) as oldCnt, k.readCnt, kwGrade, kwModDate'
	SET @Sql = @Sql + ' FROM tbl_keyword as k with (nolock) LEFT OUTER JOIN tbl_kwcnt as c with (nolock)'
	SET @Sql = @Sql + ' ON k.kwcode = c.kwcode and datediff(m,c.regdate,getdate()) = 1 WHERE 1=1'

	-- 등급
	IF @kwGrade > 0
	BEGIN
		SET @Sql = @Sql + ' AND kwGrade = '+Cast(@kwGrade as varchar)+' '
	END

	IF @kwSelect = '1'
	BEGIN
		SET @Sql = @Sql + ' AND kwName = '''+@kwName+''''
	END
	IF @kwSelect = '3'
	BEGIN
		SET @Sql = @Sql + ' AND RelationKw = '''+@kwName+''''
	END
	IF @kwSelect = '2'
	BEGIN
		SET @Sql = @Sql + ' AND k.kwCode = (select top 1 kwCode from tbl_SimilarKw WITH (NOLOCK) WHERE similarkwName = '''+@kwName+''' )'
	END
	-- SET @Sql = @Sql + ' ORDER BY kwcode DESC'

	--PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwPricelistCnt]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 가격조회용 리스트
	제작자		: 이기운
	제작일		: 2004.04.7
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_kwPricelistCnt]
(
	@top				int = 0,
--	@sDate				varchar(10) = '',
--	@eDate				varchar(10) = '',
--	@DateGbn			varchar(10) = '',
	@kwGrade			tinyint = 0,
--	@kwSection			char(1) = '8',
--	@kwHotSubName		varchar(25) = '',
--	@kwHotViewchk		char(1) = '2',
--	@kwHotSubNameChk	char(1) = '2',
	@kwSelect			char(1) = '0',
	@kwName				varchar(25) = '',
--	@kwFlag				int = 0,

	@outparam		int=0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(500)

	Set @Sql='SELECT count(k.kwcode) as Cnt'
	SET @Sql = @Sql + ' FROM tbl_keyword as k with (nolock) LEFT OUTER JOIN tbl_kwcnt as c with (nolock)'
	SET @Sql = @Sql + ' ON k.kwcode = c.kwcode and datediff(m,c.regdate,getdate()) = 1 WHERE 1=1'

	-- 등급
	IF @kwGrade > 0
	BEGIN
		SET @Sql = @Sql + ' AND kwGrade = '+Cast(@kwGrade as varchar)+' '
	END

	IF @kwSelect = '1'
	BEGIN
		SET @Sql = @Sql + ' AND kwName = '''+@kwName+''''
	END
	IF @kwSelect = '3'
	BEGIN
		SET @Sql = @Sql + ' AND RelationKw = '''+@kwName+''''
	END
	IF @kwSelect = '2'
	BEGIN
		SET @Sql = @Sql + ' AND k.kwCode = (select top 1 kwCode from tbl_SimilarKw WITH (NOLOCK) WHERE similarkwName = '''+@kwName+''' )'
	END
	-- SET @Sql = @Sql + ' ORDER BY kwcode DESC'

	--PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwReadCnt]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 조회수
	제작자		: 이기운
	제작일		: 2004.04.5
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_kwReadCnt]
(
	@kwCode		int = 0,
	@output			int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT readCnt,clickCnt,Cast(DATEPART(year,getdate()) as varchar)+'년 '+Cast(DATEPART(month,getdate()) as varchar)+'월' as regDate  FROM tbl_keyword  WITH (NOLOCK)  WHERE kwcode = @kwCode

END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwsub_list]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 분류
	제작자		: 이기운
	제작일		: 2004.03.27
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_kwsub_list]
(
	@subChk			char(1)		= '',
	@kwHotSubNameChk		char(1)		= ''
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(150)

	SET @Sql = 'select kwhotcode,subName,subChk,kwHotSubNameChk from tbl_hotkwsub with (nolock) where 1=1  '

	IF @subChk <> ''
		Begin
			SET @Sql = @Sql + ' and subChk ='''+ @subChk + ''''
		End

	IF @kwHotSubNameChk <> ''
		Begin
			SET @Sql = @Sql + ' and kwHotSubNameChk ='''+ @kwHotSubNameChk + ''''
		End
SET @Sql = @Sql + ' order by subname'

	EXECUTE(@Sql)
	--Print(@Sql)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_kwView]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 상세
	제작자		: 이기운
	제작일		: 2004.04.5
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_kwView]
(
	@kwCode		int = 0,
	@output			int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT kwSection, kwGrade, kwName, kwhotchk, kwhotviewChk, kwhotsubname, kwhotsubnameChk, relationkw, flag
	FROM  tbl_keyword  WITH (NOLOCK)  WHERE kwcode = @kwCode

END
GO
/****** Object:  StoredProcedure [dbo].[sp_MonthPopKwd_List]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 월별 인기키워드 정보
	제작자		: 박준희
	제작일		: 2004.03.30
	수정자		: 박준희
	수정일		: 2004.07.14
	파라미터
use keywordshop
******************************************************************************/

CREATE PROC [dbo].[sp_MonthPopKwd_List]
AS
	BEGIN
		--DECLARE @sql	varchar(250)
		Select Top 1 DefaultMonth  From
			dbo.tbl_DefaultMonthPop With(NoLock) ;
		Select

			MonthId, KeyWord From
			dbo.tbl_MonthPopKwd With(NoLock)

			Order By MonthId , OrderNo
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_phone_edit_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_phone_edit_01]
	@idx		int = 0
AS
	SET NOCOUNT ON

	BEGIN

	SELECT	idx, kwName, kwCode, company, master, phone, goodGubun, inputPrice, inputName, adState, payState, regDate, authDate
	FROM tbl_keyword_phone
	WHERE idx = @idx

	END
GO
/****** Object:  StoredProcedure [dbo].[sp_phone_list_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 전화등록대행 리스트
	제작자		: 정윤정
	제작일		: 2005.01.31
	수정자		:
	수정일		:
	파라미터
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_phone_list_02]
	@sYY			char(4) = ''
	,@sMM			char(2) = ''
	,@sDD			char(4) = ''
	,@eYY			char(4) = ''
	,@eMM			char(2) = ''
	,@eDD			char(2) = ''
	,@s_date		char(10) = ''
	,@e_date		char(10) = ''
	,@gotopage		int = 0
	,@DateSearch		varchar(10)	= ''
	,@sText			varchar(30)	= ''
	,@sSearch		varchar(10)	= ''
	,@toppage		int = 1
	,@check_cnt		int = 1
	,@hclass		char(1)
	,@sAdState		char(1)
	,@sPayState		char(1)
	,@sgoodGubun	char(1)
AS
	SET NOCOUNT ON

	BEGIN
	DECLARE
		@Sql		varchar(1000)

	if @check_cnt = '1'
		begin
			SET @Sql = 'select count(idx) from tbl_keyword_phone with (noLock)  '
		end
	else
		begin
			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' '
			SET @Sql = @sql + ' idx,kwName,company,master,phone,goodGubun, inputPrice,inputName,regDate,authDate,payState,adState '
			SET @Sql = @sql + ' from tbl_keyword_phone with (noLock) '
		end

-------------------------------------------------------------------------------------------------------------------------


		SET @Sql = @Sql + ' where idx <> '''' '

		if @sgoodgubun <>'5'
			begin
				SET @Sql = @Sql + ' and goodgubun = '''+@sgoodgubun+''' '
			end

		if @sAdState <> 'A'		-- 광고 상태
			begin
				SET @Sql = @Sql + ' and adState = '''+@sAdState+''' '
			end


		if @sPayState <> ''		-- 결제상태
			begin
				SET @Sql = @Sql + ' and payState = '''+@spayState+''' '
			end

		if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
			begin
				SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
			end


	if @s_date <> '' and @e_Date <> ''
		begin

			if @DateSearch  = 'regdate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
		end

--// -----------------------------------------------------------------------------------------------------------------
		if @check_cnt = '0'
		begin
			SET @Sql = @Sql +' order by idx desc'
		end


	END
--print(@sql)
	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[sp_phone_list_action_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_phone_list_action_01]
	(
		@key		char(1) = ''
		,@idx		int = 0
	)

AS
	SET NOCOUNT ON

	DECLARE
	@adCode		int				--생성된 identity 값

	if @key = 'Y'
	begin
		update tbl_keyword_phone set adState = 'Y',authDate = getdate() where idx = @idx
	end
	else if @key = 'C'
	begin
		update tbl_keyword_phone set adState = 'C', authDate = getdate() where idx = @idx
	end
	else if @key = 'D'
	begin
		update tbl_keyword_phone set adState = 'D', authDate = getdate() where idx = @idx
	end
GO
/****** Object:  StoredProcedure [dbo].[sp_postbaner_service_keyword_kwgrade_list]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 서비스키워드에서 돌아감
	제작자		: 고병호
	제작일		: 2004.03.25
	수정자		:
	수정일		:
	파라미터


*****************************************************************************/
CREATE PROCEDURE [dbo].[sp_postbaner_service_keyword_kwgrade_list]

AS
	SET NOCOUNT ON

	select top 1
		gradechk1, gradechk2, gradechk3, gradechk4, gradechk5,
		gradechk6, gradechk7, gradechk8, gradechk9, gradechk10
		from tbl_kwgrade with (NOLOCK)
		order by code desc
GO
/****** Object:  StoredProcedure [dbo].[sp_postbaner_service_keyword_session_list]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 서비스키워드에서 돌아감-세션에 있나 없나.
	제작자		: 고병호
	제작일		: 2004.03.25
	수정자		:
	수정일		:
	파라미터


*****************************************************************************/
CREATE PROCEDURE [dbo].[sp_postbaner_service_keyword_session_list]
		@kwName		varchar(20)
		,@goodgubun	char(1)

AS
	SET NOCOUNT ON

		select goodRank from tbl_session with (noLock)
		where kwname = @kwName and goodgubun = @goodgubun
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_contract_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_contract_list_01]

	@kwname		varchar(30) = ''
	,@goodRank	char(1) = ''
	,@s_date	varchar(10) = ''
	,@e_date	varchar(10) = ''
	,@adState	char(1) = ''
	,@payState	char(1) = ''
	,@code		int = 1

AS
	SET NOCOUNT ON

	DECLARE
	@Sql		varchar(1000)

	SET @Sql = 'select kwname, goodRank, startday, endday, adState, payState from tbl_keyword_adinfo with (NoLock) '

	if @kwname <> ''
		begin
			SET @Sql = @Sql + ' where kwname = '''+@kwname+''' '
		end

	if @goodRank <> ''
		begin
			SET @Sql = @Sql + ' and goodRank = '''+@goodRank+''' '
		end



	SET @Sql = @Sql + ' and (( '
	SET @Sql = @Sql + ' CONVERT(varchar(10), startday,120) >= '''+@s_date+''' '
	SET @Sql = @Sql + ' and '
	SET @Sql = @Sql + ' CONVERT(varchar(10), startday,120) <= '''+@e_date+''' '
	SET @Sql = @Sql + ' ) or ( '
	SET @Sql = @Sql + ' CONVERT(varchar(10), endday,120) >= '''+@s_date+''' '
	SET @Sql = @Sql + ' and '
	SET @Sql = @Sql + ' CONVERT(varchar(10), endday,120) <= '''+@e_date+''' '
	SET @Sql = @Sql + ' )) '


	if @adState <> ''
		begin
			SET @Sql = @Sql + ' and adState = '''+@adState+''' '
		end

	if @payState <> ''
		begin
			SET @Sql = @Sql + ' and payState = '''+@payState+''' '
		end

	SET @Sql = @Sql + ' and code <> '''+CAST(@code AS VARCHAR(5)) + ''' '

		--print(@sql)
	Execute(@sql)
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_edit_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_edit_01]

	@hclass		char(1) = ''
	,@code		int = 1
AS
	SET NOCOUNT ON

	DECLARE @Sql		varchar(1000)


	SET @Sql = 'select top 1 '
	SET @Sql = @Sql + ' a.code, a.branchcode,  a.userid, a.username, a.id, a.name, a.kwcode, a.kwname, a.goodgubun, a.goodRank, '
	SET @Sql = @Sql + 'a.Period,a.startday, a.endday,a.originPrice, a.isDC, a.adTitle, a.adContent, a.adimg, a.adUrl,a.PayMethod, a.payKind, a.prePayDate ,a.usedType,'
	SET @Sql = @Sql + ' a.note, a.adState, a.payState, a.authDate, a.regDate,'
	SET @Sql = @Sql + ' a.isService, a.serviceNm, a.authState, a.iconFileName,a.spLifeAdEnDate,IsNull(a.DtlHtmlYn , 0) DtlHtmlYn ,IsNull(a.DtlTitle, '''') DtlTitle ,IsNull(a.DtlContents, '''') DtlContents , i.firm_name ,i.firm_tel ,i.BoxNum,i.boxPrice,i.service_price,i.real_price,i.Pay_Money, i.Remain_Money, '
	if @hclass ='f'
		begin
			SET @Sql = @Sql + ' c.readCnt '
		end
	else
		begin
			SET @Sql = @Sql + ' c.readCnt, a.clickCnt '
		end

	SET @Sql = @Sql + ', a.noteState from tbl_keyword_adinfo a '



	if @hclass <> 'f'
		begin
			SET @Sql = @Sql + ' INNER JOIN tbl_keyword k ON a.kwcode = k.kwcode '
		end

	SET @Sql = @Sql + ' Left OUTER JOIN   tbl_keyword_income i ON a.code = i.Code '
	SET @Sql = @Sql + ' left outer JOIN tbl_kwcnt c ON a.kwcode = c.kwcode  '

	SET @Sql = @Sql + ' where a.code = '''+CAST(@code AS varCHAR(5)) + ''' '
	--print(@sql)

	Execute(@sql)
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_id_info]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 사용자 정보보기
	제작자		: 고병호
	제작일		: 2004.03.25
	수정자		:
	수정일		:
	파라미터

	정상적이지 않은 SP임. 지워도 됨.

*****************************************************************************/
CREATE PROCEDURE [dbo].[sp_postbanner_id_info]
	@id		varchar(15)
AS
	SET NOCOUNT ON



	select top 1 userid, password, username, juminno, email, phone, hphone, address1, address2
		,addressbunji, post1, post2
		from usercommon with (nolock) where userid = @id
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고관리 리스트
	제작자		: 고병호
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터

******************************************************************************/
CREATE PROCEDURE [dbo].[sp_postbanner_list_01]

	@sYY			char(4) = ''
	,@sMM			char(2) = ''
	,@sDD			char(4) = ''
	,@eYY			char(4) = ''
	,@eMM			char(2) = ''
	,@eDD			char(2) = ''
	,@s_date		char(10) = ''
	,@e_date		char(10) = ''
	,@gotopage		int = 0
	,@DateSearch	varchar(10)	= ''
	,@sText			varchar(30)	= ''
	,@sSearch		varchar(10)	= ''
	,@toppage		int = 1
	,@check_cnt		int = 1
	,@hclass		char(1)
	,@sgoodRank		char(1)
	,@sAdState		char(1)
	,@sPayState		char(1)
	,@smember		char(1)
	,@sUsedType		char(1)
	,@sgoodGubun	char(1)

AS
	SET NOCOUNT ON

	BEGIN
	DECLARE
		@Sql		varchar(1000)


	if @check_cnt = '1'
		begin
			SET @Sql = 'select count(code) from tbl_keyword_adinfo a with (noLock)  '
		end
	else
		begin

			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' '
			SET @Sql = @sql + ' a.code, a.adUrl, a.userid, a.username, a.id, a.name, a.kwcode, a.goodgubun, a.goodRank, a.startday, a.endday,  '
			SET @Sql = @sql + ' a.adTitle, a.usedType, a.isExtend, a.payMethod, a.payState, a.adState, a.authState, a.authDate,  '
			SET @Sql = @sql + ' a.regDate, a.branchcode, a.kwname, a.isService '
			SET @Sql = @sql + ' from tbl_keyword_adinfo a with (noLock) '


		end

-------------------------------------------------------------------------------------------------------------------------


		SET @Sql = @Sql + ' where a.code <> '''' '
		SET @Sql = @Sql + ' and goodgubun = '''+@sgoodgubun+''' '

		if @sgoodRank <> ''		-- 위치
			begin
				SET @Sql = @Sql + ' and goodRank = '''+@sgoodRank+''' '

			end

		if @sAdState <> ''		-- 광고 상태
			begin
				SET @Sql = @Sql + ' and adState = '''+@sAdState+''' '
			end


		if @sPayState <> ''		-- 결제상태
			begin
				SET @Sql = @Sql + ' and payState = '''+@spayState+''' '
			end

		if @smember <> ''		-- 등록자
			begin
				if @smember = '1'		-- 회원
					begin
						SET @Sql = @Sql + ' and userid <> '''' and (branchcode = '''' or branchcode is null) '
					end
				else
					begin
						SET @Sql = @Sql + ' and  branchcode <> '''' '
					end
			end


		if @susedType <> ''		--// 생활광고에 대한 찾기
			begin
				SET @Sql = @Sql + ' and  UsedType = '''+@sUsedType+''' '
			end


		if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
			begin
				SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
			end


	if @s_date <> '' and @e_Date <> ''
		begin

			if @DateSearch  = 'regdate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
		end

--// -----------------------------------------------------------------------------------------------------------------
		if @check_cnt = '0'

		--	if @hclass = 'f'
				begin
					SET @Sql = @Sql +' order by a.regdate desc'
				end
		--	else
		--		begin
		--			SET @Sql = @Sql +' order by a.paydate desc'
		--		end

	END

--print(@sql)
	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_list_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고관리 리스트
	제작자		: 고병호
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터
******************************************************************************/

--sp_postbanner_list_02 '2006' ,'10', '01','2006','10','31','2006-10-01','2006-10-31',10,'regdate','','','20',1,'5','','G','','20','','5'

CREATE PROCEDURE [dbo].[sp_postbanner_list_02]
	@sYY			char(4) = ''
	,@sMM			char(2) = ''
	,@sDD			char(4) = ''
	,@eYY			char(4) = ''
	,@eMM			char(2) = ''
	,@eDD			char(2) = ''
	,@s_date		char(10) = ''
	,@e_date		char(10) = ''
	,@gotopage		int = 0
	,@DateSearch		varchar(10)	= ''
	,@sText			varchar(30)	= ''
	,@sSearch		varchar(10)	= ''
	,@toppage		int = 1
	,@check_cnt		int = 1
	,@hclass		char(1)
	,@sgoodRank		char(1)
	,@sAdState		char(1)
	,@sPayState		char(1)
	,@sMember		char(3)
	,@sUsedType		char(1)
	,@sgoodGubun	char(1)
AS
	SET NOCOUNT ON

	BEGIN
	DECLARE
		@Sql		varchar(1000)

	if @check_cnt = '1'
		begin
			SET @Sql = 'select count(code) from tbl_keyword_adinfo a with (noLock)  '
		end
	else
		begin

			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' '
			SET @Sql = @sql + ' a.code, a.adUrl, a.userid, a.username, a.id, a.name, a.kwcode, a.goodgubun, a.goodRank, a.period, a.startday, a.endday,a.spLifeAdEnDate,   '
			SET @Sql = @sql + ' a.originPrice, a.adTitle, a.usedType, a.isExtend, a.payMethod, a.prePayDate, a.payDate, a.payState, a.adState, a.authState, a.authDate,  '
			SET @Sql = @sql + ' a.regDate, a.branchcode, a.kwname, a.isService, b.real_price, a.noteState '
			SET @Sql = @sql + ' from tbl_keyword_adinfo a with (noLock) LEFT OUTER JOIN tbl_keyword_income b with (noLock) ON a.code=b.code '


		end

-------------------------------------------------------------------------------------------------------------------------


		SET @Sql = @Sql + ' where a.code <> '''' '
		if @sgoodgubun <>'5'
			begin
				SET @Sql = @Sql + ' and goodgubun = '''+@sgoodgubun+''' '
			end
		if @sgoodRank <> ''		-- 위치
			begin
				SET @Sql = @Sql + ' and goodRank = '''+@sgoodRank+''' '

			end

		if @sAdState <> 'A'		-- 광고 상태
			begin
				if @sAdState ='G'
					begin
						SET @Sql = @Sql + ' and adState <> ''E'' '
					end
				else
					begin
						SET @Sql = @Sql + ' and adState = '''+@sAdState+''' '
					end
			end


		if @sPayState <> ''		-- 결제상태
			begin
				SET @Sql = @Sql + ' and payState = '''+@spayState+''' '
			end

		if @sMember <> ''		-- 등록자
			begin
				if @sMember = '100'		-- 회원
					begin
						SET @Sql = @Sql + ' and userid <> '''' and (branchcode = '''' or branchcode is null) '
					end
				else if @sMember = '200'		-- 등록대행 (전체)
					begin
						SET @Sql = @Sql + ' and branchcode <> '''' and branchcode is not null '
					end
				else if @sMember = '300'		-- 지점 (전체)
					begin
						SET @Sql = @Sql + ' and branchGubun=1 '
					end
				else if @sMember = '400'		-- 지사 (전체)
					begin
						SET @Sql = @Sql + ' and branchGubun=2 '
					end
				else if @sMember = '500'		-- 지점사 (전체)
					begin
						SET @Sql = @Sql + ' and (branchGubun=1 or branchGubun=2) '
					end
				else
					begin
						SET @Sql = @Sql + ' and  branchcode ='''+@sMember+''' '
					end
			end


		if @susedType <> ''		--// 생활광고에 대한 찾기
			begin
				SET @Sql = @Sql + ' and  UsedType = '''+@sUsedType+''' '
			end


		if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
			begin
				SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
			end


	if @s_date <> '' and @e_Date <> ''
		begin

			if @DateSearch  = 'regdate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else if @DateSearch  = 'StartDate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), startDay,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), startDay,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), startDay,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), startDay,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else if @DateSearch  = 'EndDate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), endDay,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), endDay,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), endDay,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), endDay,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else if @DateSearch  = 'P_EndDate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), spLifeAdEnDate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), spLifeAdEnDate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), spLifeAdEnDate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), spLifeAdEnDate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), authdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
		end

--// -----------------------------------------------------------------------------------------------------------------
		if @check_cnt = '0'

		--	if @hclass = 'f'
				begin
					SET @Sql = @Sql +' order by a.regdate desc'
				end
		--	else
		--		begin
		--			SET @Sql = @Sql +' order by a.paydate desc'
		--		end

	END
print(@sql)
	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_list_action_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_list_action_01]
	(
		@key		char(1) = ''
		,@code		int = 0
		,@outparm	int	= '0'  OUTPUT			--출력값(good_id)
	)

AS
	SET NOCOUNT ON

	DECLARE
	@error_var		int				--오류 번호
	,@adCode		int				--생성된 identity 값
	,@rowCnt		int				--영향받은 행갯수

	BEGIN TRAN

		if @key = 'Y'
			begin
				update tbl_keyword_adinfo set adState = 'Y',authDate = getdate() where code = @code
			end
		else
			begin
				if @key = 'E'
					begin

						update tbl_keyword_adinfo set adState = 'E', authDate = getdate() where code = @code
						update tbl_keyword_serviceNM set flag = '0' where adcode = @code
					end
				else
					begin
						if @key = 'C'
							begin
								update tbl_keyword_adinfo set adState = 'C', authDate = getdate() where code = @code
							end
					end
			end

	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR

	--에러 발생시
	IF @error_var <> 0
		BEGIN
			ROLLBACK TRAN
		END
	--입력이 되지 않았으면

	IF @error_var = 0
		begin
			COMMIT TRAN
		end
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_proxy_detail_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 대행자 정보보기
	제작자		: 고병호
	제작일		: 2004.03.25
	수정자		:
	수정일		:
	파라미터
*****************************************************************************/
CREATE PROCEDURE [dbo].[sp_postbanner_proxy_detail_01]

	@id		varchar(15)
	,@code	int = 0

AS
	SET NOCOUNT ON

	select a.id, a.name, a.branchcode, a.paymethod, a.originPrice,
		a.isDC, a.note, a.goodgubun, i.real_Price
		from tbl_keyword_adinfo a with (noLock)
		left outer JOIN tbl_keyword_income i ON a.code = i.code

		where a.id = @id and a.code = @code
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_01]
	(
		@key		char(1)
		,@sText		varchar(25)
	)
AS
	SET NOCOUNT ON

	if @key = '1'
		begin
			select kwcode, kwname, kwGrade from tbl_keyword with (noLock) where kwname = @sText
		end
	else
		begin
			if @key = '2'
				begin
					select kwcode, similarkwname from tbl_similarkw with (noLock) where similarkwname = @sText
				end
		end
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_02]
	(
		@key			char(1) = ''
		,@org_goodgubun	char(1) = ''
		,@ex_kwname		varchar(25) = ''

	)
AS
	SET NOCOUNT ON
	if @key = '1'
		begin
			select goodRank from tbl_keyword_adinfo with (Nolock) where goodgubun = @org_goodgubun and kwName = @ex_kwname and adState in ('Y','N','C')
		end
	else
		begin
			if @key = '2'
				begin
					select goodRank from tbl_session with (noLock) where goodgubun = @org_goodgubun and  kwName = @ex_kwname
				end
		end
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_03]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_03]
	(
		@rs4_kwcode		int = 0
	)

AS
	SET NOCOUNT ON

	select top 1 kwname, kwcode, kwGrade from tbl_keyword with (noLock) where kwcode = @rs4_kwcode
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_04]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_04]

AS
	SET NOCOUNT ON
	select top 1 * from tbl_kwgrade with (noLock) order by code desc
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_action_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
use keywordshop
exec sp_postbanner_service_keyword_action_01 '','거가개발인력(신기민)','12', 'dlatjsdud','임선영','4856','박다은','3', '3','3','2004-10-04','2004-11-04', '0','7','1','4','건설조선인부대모집','미장 목수 조적 타일공 잡부 긴급대모집 기숙사완비 일당7만이상 근무지:경남거제','http://042.job.findall.co.kr/GuinInfo/GuinInfoDetail.asp?Local=3&AdId=1558240','', '4','','','Y','N','N', '','','0', '0','박다은', '10월5일오후입금예정', '', '','2004-11-04';



*/


CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_action_01]
	(
		@userid			varchar(30) = ''
		,@username		varchar(35) = ''
		,@branchcode	VARchar(3) = ''
		,@id			varchar(30) = ''
		,@name			varchar(30) = ''
		,@kwcode		int = 0
		,@kwname		varchar(25) = ''
		,@goodgubun		char(1) = ''
		,@goodRank		char(1) = ''
		,@period		char(1) = ''
		,@startday		smalldatetime
		,@endday		smalldatetime
		,@originprice	int = 0
		,@isDC			char(1) = ''
		,@isService		char(1) = ''
		,@payMethod		char(1) = ''
		,@adTitle		varchar(100) = ''
		,@adContent		varchar(100) = ''
		,@adUrl			varchar(100) = ''
		,@adImg			varchar(300) = ''
		,@usedType		char(1) = ''
		,@freeType1		char(2) = ''
		,@freeType2		char(2) = ''
		,@payState		char(1) = ''
		,@adState		char(1) = ''
		,@authState		char(1) = ''
		,@firm_name		varchar(30) = ''
		,@firm_tel		varchar(30) = ''
		,@service_price	int = 0
		,@real_price	int = 0
		,@sText			varchar(25) = ''
		,@note			varchar(100) = ''
		,@iconFileName		char(3) = ''
		,@new_keyword	varchar(25) = ''
		,@spLifeAdEnDate	smallDateTime
		,@outparm		int	= '0'  OUTPUT			--출력값(good_id)

	)

AS
	SET NOCOUNT ON
	DECLARE
	@error_var		int				--오류 번호
	,@adCode		int				--생성된 identity 값
	,@rowCnt		int				--영향받은 행갯수
	,@sz_kwcode		int
	,@sz_kwname		varchar(20)
	,@sz_kwGrade	char(1)


	BEGIN TRAN
	IF @spLifeAdEnDate ='1900-01-01'
		BEGIN
			SET @spLifeAdEnDate = NULL
		END


	select @sz_kwcode = kwcode, @sz_kwname = kwname from tbl_keyword with (noLock) where kwname = @sText
	IF (@sz_kwcode is null)
		BEGIN
			select @sz_kwcode = kwcode from tbl_similarkw with (noLock) where similarkwname = @sText
			IF (@sz_kwcode is null)
				BEGIN
					exec up_keywordInsert '10','8',@new_keyword, '0','0','','0','0','0','2','','',2,''
					select @sz_kwcode = kwcode from tbl_keyword with (noLock) where kwName = @new_keyword
					--select @sz_kwcode = @@identity
				END
		END
	ELSE
		BEGIN
			select @sz_kwcode = kwcode from tbl_keyword with (noLock) where kwName = @sText
		END
	IF @Period ='1'
	BEGIN
		SELECT @OriginPrice = CutPrice1 FROM tbl_KwPrice Where KwCode=@sz_KwCode AND GoodGubun=@GoodGubun AND GoodRank=@GoodRank
	End
	ELSE IF @Period='2'
		BEGIN
		SELECT @OriginPrice = CutPrice2 FROM tbl_KwPrice Where KwCode=@sz_KwCode AND GoodGubun=@GoodGubun AND GoodRank=@GoodRank
	End
	ELSE
	BEGIN
		SELECT @OriginPrice = CutPrice3 FROM tbl_KwPrice Where KwCode=@sz_KwCode AND GoodGubun=@GoodGubun AND GoodRank=@GoodRank

	END

	print(@OriginPrice)


	insert into tbl_keyword_adinfo(userid,username,branchcode,id,name,kwcode,kwname,goodgubun,goodRank,period,startday,
			endday,originprice,isDC, isService,payMethod,adTitle, adContent, adUrl, adImg, usedType, freeType1, freeType2,
			payState,adState,authState,usertel1, usertel2,prePayDate,payKind, note, iconFileName,spLifeAdEnDate)
	values(@userid,@username, @branchcode, @id, @name, @sz_kwcode,@sText, @goodgubun, @goodRank, @period, @startday,
		@endday, @OriginPrice, '7', '1', '4', @adTitle, @adContent, @adUrl, @adImg, @usedType, @freeType1, @freeType2,'Y','N','N',
		'--','--', '','', @note, @iconFileName,@spLifeAdEnDate)


	--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT

	--정상적으로 입력되었으면 아이덴티티 셋팅
		SELECT @adCode = @@identity

	if @branchcode <> ''
		begin
			insert into tbl_keyword_income(code, firm_name, firm_tel, service_price, real_price )
				values (@adCode, @firm_name, @firm_tel, @service_price, @real_price)

			SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
		end

		insert into tbl_keyword_serviceNM(adcode, kwcode, kwname, rank, flag, regdate)
			values( @adCode, @kwCode, @sText, @goodRank, '1', getdate())

		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT



	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END
	--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				RETURN(1)
			END

	IF @error_var = 0
		begin
			COMMIT TRAN
		end
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_action_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
use keywordshop
select * from tbl_keyword_adinfo Where code='4092'


*/



CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_action_02]

	(
		@code	int = 0
	)

AS
	SET NOCOUNT ON


	select a.userid,a.username,a.branchcode,a.id,a.name,a.kwcode,a.kwname,a.goodgubun,a.goodRank,a.period,a.startday,
		 a.endday,a.originprice,a.isDC,a.isService,a.serviceNm,a.adTitle,a.adContent,a.adImg,a.adUrl,a.usedType,
		 a.freeType1,a.freeTYpe2,a.isExtend,a.isTax,a.payMethod,a.inipayTid,a.payDate,a.payName,a.payState,
		 a.adState,a.authDate,a.authState, a.code, a.note, a.iconFileName,
		 i.firm_name, i.firm_tel, i.boxnum, i.service_price, i.real_price ,a.spLifeAdEnDate
		 from tbl_keyword_adinfo a with (nolock)
		 left outer join tbl_keyword_income i with (noLock) ON a.code = i.code
		 where a.code = @code
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_action_03]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_action_03]
	(
		@key			char(1) = ''
		,@goodgubun		char(1) = ''
		,@sText			varchar(25) = ''
		,@goodRank		varchar(7)	= ''
	)
AS
	SET NOCOUNT ON

	if @key = '1'
		begin
			select count(code)
				from tbl_keyword_adinfo a with (NOLOCK)
				where goodgubun = @goodgubun and kwName = @sText and goodRank in (@goodRank) and adState in ('Y','N','C')
		end
	else
		begin
			select count(idx)
				from tbl_session  with (NOLOCK)
				where goodgubun = @goodgubun and kwName = @sText and goodRank in (@goodRank)
		end
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 서비스키워드에서 돌아감-처음에 찾을떄.
	제작자		: 고병호
	제작일		: 2004.03.25
	수정자		:
	수정일		:
	파라미터


*****************************************************************************/
CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_list_01]
	@code			int = 0
	,@sText			varchar(20)
	,@hgoodgubun	char(1)
AS
	SET NOCOUNT ON

	DECLARE @Sql		varchar(1000)

	SET @Sql = 'select top 10 a.kwname, a.goodgubun, a.kwcode, a.goodRank, w.kwgrade from tbl_keyword_adinfo a with (NOLOCK) INNER JOIN tbl_keyword w with (NOLOCK)'

	SET @Sql = @sql +' ON a.kwcode = w.kwcode '


	SET @Sql = @sql + ' where a.code <> '''' '
	if @hgoodgubun <> ''
		begin
			SET @Sql = @sql + ' and goodgubun = '''+@hgoodgubun+''' '
		end

	if @code <> '' and @sText <> ''
		begin
			SET @Sql = @sql +' and a.code = '''+@code+''' '
		end
	else
		begin
			SET @Sql = @sql +' and a.kwName = '''+@sText+''' '
		end


	print @sql
	EXECUTE(@sql)
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_search_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_search_01]

	@hgoodgubun		char(1)
	,@code			int
	,@sText			varchar(25)

AS
	SET NOCOUNT ON


	DECLARE @Sql		varchar(1000)

	SET @Sql = 'select top 10 a.kwname, a.goodgubun, a.kwcode, a.goodRank, w.kwgrade from tbl_keyword w '
	SET @Sql = @sql + ' left outer join tbl_keyword_adinfo a '
	SET @Sql = @sql + ' ON w.kwname = a.kwname '

	SET @Sql = @sql + ' where a.code <> '''' and adState in (''Y'',''N'') '

	if @hgoodGubun <> ''
		begin
			SET @Sql = @sql + ' and goodgubun = '''+@hgoodgubun+''' '
		end


	if @code <> '' and @sText <> ''
		begin
			SET @Sql = @sql + ' and a.kwName = '''+@sText+''' '
		end
	else		-- code <>'' and sText = ''
		begin
			SET @Sql = @sql + ' and a.code = '''+CAST(@code AS VARCHAR(5)) +''' '
		end


	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_search_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_search_02]

	@sText	varchar(20)
	,@flag	char(1)

AS
	SET NOCOUNT ON


	if @flag = '2'
		begin
			select kwGrade, kwcode from tbl_keyword with (noLock)
			where kwname = @sText and flag = '2'
		end
	else
		begin
			if @flag = '0'
				begin
					select kwGrade, kwcode, flag from tbl_keyword with (noLock)
					where kwname = @sText
				end

		end
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_service_keyword_search_grade]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_service_keyword_search_grade]

AS
	SET NOCOUNT ON
	select top 1 * from tbl_kwgrade order by code desc
GO
/****** Object:  StoredProcedure [dbo].[sp_postbanner_servicekeyword_action_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_postbanner_servicekeyword_action_01]
	(
		@userid			varchar(30) = ''
		,@username		varchar(35) = ''
		,@branchcode	VARchar(3) = ''
		,@id			varchar(30) = ''
		,@name			varchar(30) = ''
		,@kwcode		int = 0
		,@kwname		varchar(25) = ''
		,@goodgubun		char(1) = ''
		,@goodRank		char(1) = ''
		,@period		char(1) = ''
		,@startday		smalldatetime
		,@endday		smalldatetime
		,@originprice	int = 0
		,@isDC			char(1) = ''
		,@isService		char(1) = ''
		,@payMethod		char(1) = ''
		,@adTitle		varchar(100) = ''
		,@adContent		varchar(100) = ''
		,@adUrl			varchar(100) = ''
		,@adImg			varchar(30) = ''
		,@usedType		char(1) = ''
		,@freeType1		char(2) = ''
		,@freeType2		char(2) = ''
		,@payState		char(1) = ''
		,@adState		char(1) = ''
		,@authState		char(1) = ''
		,@firm_name		varchar(30) = ''
		,@firm_tel		varchar(30) = ''
		,@service_price	int = 0
		,@real_price	int = 0
		,@sText			varchar(10) = ''


	)

AS
	SET NOCOUNT ON
	DECLARE
	@error_var		int				--오류 번호
	,@adCode		int				--생성된 identity 값
	,@rowCnt		int				--영향받은 행갯수
	,@sz_kwcode		int
	,@sz_kwname		varchar(20)
	,@sz_kwGrade	char(1)
	,@sy_kwcode		int


	BEGIN TRAN

	insert into tbl_keyword_adinfo(userid,username,branchcode,id,name,kwcode,kwname,goodgubun,goodRank,period,startday,
			endday,originprice,isDC, isService,payMethod,adTitle, adContent, adUrl, adImg, usedType, freeType1, freeType2,
			payState,adState,authState)
	values(@userid,@username, @branchcode, @id, @name, @kwcode,@sText, @goodgubun, @goodRank, @period, @startday,
		@endday, '0', '7', '1', '4', @adTitle, @adContent, @adUrl, @adImg, @usedType, @freeType1, @freeType2,'Y','N','N')


	--오류번호, 적용 행 갯수 셋팅
--		SELECT @error_var = @@ERROR

	--정상적으로 입력되었으면 아이덴티티 셋팅
		SELECT @adCode = @@identity

	if @branchcode <> ''
		begin
			insert into tbl_keyword_income(code, firm_name, firm_tel, service_price, real_price )
				values (@adCode, @firm_name, @firm_tel, @service_price, @real_price)

--			SELECT @error_var = @@ERROR
		end

		insert into tbl_keyword_serviceNM(adcode, kwcode, kwname, rank, flag, regdate)
			values( @adCode, @kwCode, @sText, @goodRank, '1', getdate())

--		SELECT @error_var = @@ERROR

--	select @sz_kwcode = kwcode, @sz_kwname = kwname from tbl_keyword with (noLock) where kwname = @sText

--	IF (@sz_kwcode is not null)
--		BEGIN
--			select @sy_kwcode = kwcode from tbl_similarkw with (noLock) where similarkwname = @sText
--			IF (@sy_kwcode is not null)
--				BEGIN
--					exec up_keywordInsert '10','8','"& new_keyword &"', '0','0','','0','0','0','2','','',''
--				END
--		END

	--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
			END

	COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[sp_priceForPhone]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명			: 전화등록대행 키워드 가격 조회
	제작자		: 정윤정
	제작일		: 2005.02.01
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_priceForPhone]
(
	@kwName	varchar(30)	= ''
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(100),
		@kwCode	int

	SET @kwCode = 0

	SELECT top 1 @kwCode = kwCode from tbl_keyword with (nolock) where kwname = @kwName

	IF (@kwCode is null) or (@kwCode = 0) -- NonPrice 가격 조회
	BEGIN
		SELECT @kwCode as 'kwCode', CASE WHEN goodGubun = '3' THEN cutPrice3 ELSE cutPrice1 END as 'Price', goodGubun FROM tbl_kwNonePrice WITH (NOLOCK)
		WHERE DATEDIFF(m, regDate, getdate()) = 0 AND goodRank = '1'
		ORDER BY goodGubun ASC
	END
	ELSE -- Price 조회
	BEGIN
		SELECT  @kwCode as 'kwCode', CASE WHEN goodGubun = '3' THEN cutPrice3 ELSE cutPrice1 END as 'Price', goodGubun FROM tbl_kwPrice WITH (NOLOCK)
		WHERE kwCode = @kwCode AND DATEDIFF(m, regDate, getdate()) = 0 AND goodRank = '1'
		ORDER BY goodGubun ASC
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_PriceUpdate_2005]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_PriceUpdate_2005]

--4월 가격 업데이트
/*

select * from tbl_kwNonePrice Where (year(regdate) ='2005'  AND (month(regdate)='4' or month(regdate)='5'))

*/

AS

-- 1등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=1) and (month(regdate)='4' or month(regdate)='5')
--8


-- 1등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1= 140000, cutPrice2=140000*2 , cutPrice3= 140000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=1) and (month(regdate)='4' or month(regdate)='5')
--10

-- 1등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=44000, cutPrice2=60000, cutPrice3=100000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=1) and (month(regdate)='4' or month(regdate)='5')
--10




-- 2등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=80000, cutPrice2=80000*2, cutPrice3=80000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=2) and (month(regdate)='4' or month(regdate)='5')
--12

-- 2등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=120000, cutPrice2=120000*2, cutPrice3=120000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=2) and (month(regdate)='4' or month(regdate)='5')
--15

-- 2등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=36000, cutPrice2=54000, cutPrice3=90000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=2) and (month(regdate)='4' or month(regdate)='5')
--15


-- 3등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=70000*2, cutPrice3=70000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=3) and (month(regdate)='4' or month(regdate)='5')
--108

-- 3등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=100000, cutPrice2=100000*2, cutPrice3=100000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=3) and (month(regdate)='4' or month(regdate)='5')
--135

-- 3등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=32000, cutPrice2=48000, cutPrice3=80000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=3) and (month(regdate)='4' or month(regdate)='5')
--135





-- 4등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=4) and (month(regdate)='4' or month(regdate)='5')
--64

-- 4등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=4) and (month(regdate)='4' or month(regdate)='5')
--80

-- 4등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=28000, cutPrice2=42000, cutPrice3=70000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=4) and (month(regdate)='4' or month(regdate)='5')
--80




-- 5등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=50000, cutPrice2=50000*2, cutPrice3=50000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=5) and (month(regdate)='4' or month(regdate)='5')
--20

-- 5등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=80000, cutPrice2=80000*2, cutPrice3=80000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=5) and (month(regdate)='4' or month(regdate)='5')
--25

-- 5등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=24000, cutPrice2=36000, cutPrice3=60000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=5) and (month(regdate)='4' or month(regdate)='5')
--25




-- 6등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=50000, cutPrice2=50000*2, cutPrice3=50000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=6) and (month(regdate)='4' or month(regdate)='5')
--104

-- 6등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=6) and (month(regdate)='4' or month(regdate)='5')
--130

-- 6등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=16000, cutPrice2=24000, cutPrice3=40000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=6) and (month(regdate)='4' or month(regdate)='5')
--130




-- 7등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=40000, cutPrice2=40000*2, cutPrice3=40000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=7) and (month(regdate)='4' or month(regdate)='5')
--168

-- 7등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=50000, cutPrice2=50000*2, cutPrice3=50000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=7) and (month(regdate)='4' or month(regdate)='5')
--210

-- 7등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=12000, cutPrice2=18000, cutPrice3=30000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=7) and (month(regdate)='4' or month(regdate)='5')
--210




-- 8등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=35000, cutPrice2=35000*2, cutPrice3=35000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=8) and (month(regdate)='4' or month(regdate)='5')
--17440

-- 8등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=40000, cutPrice2=40000*2, cutPrice3=40000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=8) and (month(regdate)='4' or month(regdate)='5')
--21800

-- 8등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=12000, cutPrice2=18000, cutPrice3=30000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=8) and (month(regdate)='4' or month(regdate)='5')
--21800



-- 9등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=30000, cutPrice2=30000*2, cutPrice3=30000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=9) and (month(regdate)='4' or month(regdate)='5')
--17440

-- 9등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=35000, cutPrice2=35000*2, cutPrice3=35000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=9) and (month(regdate)='4' or month(regdate)='5')
--21800

-- 9등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=10000, cutPrice2=15000, cutPrice3=25000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=9) and (month(regdate)='4' or month(regdate)='5')
--21800





-- 10등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=25000, cutPrice2=25000*2, cutPrice3=25000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=10) and (month(regdate)='4' or month(regdate)='5')
--17440

-- 10등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=30000, cutPrice2=30000*2, cutPrice3=30000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=10) and (month(regdate)='4' or month(regdate)='5')
--21800


-- 10등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=8000, cutPrice2=12000, cutPrice3=20000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=10 ) and (month(regdate)='4' or month(regdate)='5')
--21800


/*-- 등급 미지정 키워드 , 스폰서배너
update tbl_kwNonePrice
set cutPrice1=25000, cutPrice2=25000*2, cutPrice3=25000*3
where goodGubun=1  and (year(regdate) ='2005'  AND (month(regdate)='4' or month(regdate)='5'))
--17440

-- 등급 미지정 키워드 , 스폰서홈페이지
update tbl_kwNonePrice
set cutPrice1=30000, cutPrice2=30000*2, cutPrice3=30000*3
where goodGubun=2  and (year(regdate) ='2005'  AND (month(regdate)='4' or month(regdate)='5'))
--21800

--등급 미지정 키워드 , 스폰서생활광고
update tbl_kwNonePrice
set cutPrice1=8000, cutPrice2=12000, cutPrice3=20000
where goodGubun=3 and (year(regdate) ='2005'  AND (month(regdate)='4' or month(regdate)='5'))
--21800
*/





-----------------#   등급별 가격 세팅 끝




-----------------# 특정 키워드별 가격 세팅 시작

/*
-- 1등급 원룸 배너광고

update tbl_kwPrice
set cutPrice1=280000, cutPrice2=280000*2, cutPrice3=280000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='원룸') and (month(regdate)='4' or month(regdate)='5')


-- 1등급원룸 홈페이지 광고
update tbl_kwPrice
set cutPrice1=420000, cutPrice2=420000*2, cutPrice3=420000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='원룸') and (month(regdate)='4' or month(regdate)='5')
--21800

-- 1등급 원룸 -생활광고
update tbl_kwPrice
set cutPrice1=124000, cutPrice2=186000, cutPrice3=310000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='원룸') and (month(regdate)='4' or month(regdate)='5')
--21800


-- 1등급 간호조무사  배너광고

update tbl_kwPrice
set cutPrice1=110000, cutPrice2=110000*2, cutPrice3=110000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='간호조무사') and (month(regdate)='4' or month(regdate)='5')


-- 1등급 간호조무사 홈페이지 광고
update tbl_kwPrice
set cutPrice1=180000, cutPrice2=180000*2, cutPrice3=180000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='간호조무사') and (month(regdate)='4' or month(regdate)='5')
--21800

-- 1등급 간호조무사  -생활광고
update tbl_kwPrice
set cutPrice1=52000, cutPrice2=78000, cutPrice3=130000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='간호조무사') and (month(regdate)='4' or month(regdate)='5')
--21800


-- 1등급 운전 배너 광고
update tbl_kwPrice
set cutPrice1=100000, cutPrice2=100000*2, cutPrice3=100000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='운전') and (month(regdate)='4' or month(regdate)='5')


-- 1등급 운전 홈페이지 광고
update tbl_kwPrice
set cutPrice1=150000, cutPrice2=150000*2, cutPrice3=150000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='운전') and (month(regdate)='4' or month(regdate)='5')
--21800

-- 1등급 운전 생활광고
update tbl_kwPrice
set cutPrice1=44000, cutPrice2=66000, cutPrice3=110000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='운전') and (month(regdate)='4' or month(regdate)='5')

*/
GO
/****** Object:  StoredProcedure [dbo].[sp_PriceUpdate_Month]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

----------------------------------------------------------------
작성일자	: 2004년 10월 08일
작성자	: 박준희
내용	: 키워드 가격 업데이트 예약 작업
수정일자	:
수정자	:  박준희
수정내용	:  10일 이후만 내달 가격 넣기
기타	:
----------------------------------------------------------------

*/

--########################### 키워드 가격 일괄변경 시작 ###################################



CREATE PROCEDURE [dbo].[sp_PriceUpdate_Month]
--use keywordshop


AS




--########################### 키워드 가격 일괄변경 시작 ###################################






begin tran




--미등록키워드 가격 업데이트
update tbl_kwNonePrice SET
cutprice1=25000 , cutprice2=50000, cutprice3=75000
Where goodgubun='1' and month(regdate) = '11'


update tbl_kwNonePrice SET
cutprice1=30000 , cutprice2=60000, cutprice3=90000
Where goodgubun='2' and month(regdate) = '11'

update tbl_kwNonePrice SET
cutprice1=8000 , cutprice2=12000, cutprice3=20000
Where goodgubun='3' and month(regdate) = '11'
--미등록키워드 가격 업데이트



-- 1등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=110000, cutPrice2=220000, cutPrice3=330000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=1) and month(regdate)='11'
--8

-- 1등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=160000, cutPrice2=320000, cutPrice3=480000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=1) and month(regdate)='11'
--10

-- 1등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=44000, cutPrice2=66000, cutPrice3=110000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=1) and month(regdate)='11'
--10









-- 2등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=180000, cutPrice3=270000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=2) and month(regdate)='11'
--12

-- 2등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=130000, cutPrice2=260000, cutPrice3=390000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=2) and month(regdate)='11'
--15

-- 2등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=36000, cutPrice2=54000, cutPrice3=90000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=2) and month(regdate)='11'
--15






-- 3등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=80000, cutPrice2=160000, cutPrice3=240000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=3) and month(regdate)='11'
--108


-- 3등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=110000, cutPrice2=220000, cutPrice3=330000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=3) and month(regdate)='11'
--135



-- 3등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=32000, cutPrice2=48000, cutPrice3=80000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=3) and month(regdate)='11'
--135





-- 4등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=120000, cutPrice3=180000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=4) and month(regdate)='11'
--64

-- 4등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=180000, cutPrice3=270000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=4) and month(regdate)='11'
--80

-- 4등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=24000, cutPrice2=36000, cutPrice3=60000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=4) and month(regdate)='11'
--80






-- 5등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=50000, cutPrice2=100000, cutPrice3=150000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=5) and month(regdate)='11'
--20

-- 5등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=140000, cutPrice3=210000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=5) and month(regdate)='11'
--25

-- 5등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=20000, cutPrice2=30000, cutPrice3=50000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=5) and month(regdate)='11'
--25






-- 6등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=50000, cutPrice2=100000, cutPrice3=150000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=6) and month(regdate)='11'
--104

-- 6등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=120000, cutPrice3=180000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=6) and month(regdate)='11'
--130

-- 6등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=16000, cutPrice2=24000, cutPrice3=40000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=6) and month(regdate)='11'
--130





-- 7등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=40000, cutPrice2=80000, cutPrice3=120000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=7) and month(regdate)='11'
--168

-- 7등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=50000, cutPrice2=100000, cutPrice3=150000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=7) and month(regdate)='11'
--210

-- 7등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=12000, cutPrice2=18000, cutPrice3=30000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=7) and month(regdate)='11'
--210





-- 8등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=35000, cutPrice2=70000, cutPrice3=105000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=8) and month(regdate)='11'
--17440

-- 8등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=40000, cutPrice2=80000, cutPrice3=120000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=8) and month(regdate)='11'
--21800

-- 8등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=12000, cutPrice2=18000, cutPrice3=30000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=8) and month(regdate)='11'
--21800


-- 9등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=30000, cutPrice2=60000, cutPrice3=90000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=9) and month(regdate)='11'
--17440

-- 9등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=35000, cutPrice2=70000, cutPrice3=105000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=9) and month(regdate)='11'
--21800

-- 9등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=10000, cutPrice2=15000, cutPrice3=25000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=9) and month(regdate)='11'
--21800







-- 10등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=25000, cutPrice2=50000, cutPrice3=75000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=10) and month(regdate)='11'
--17440

-- 10등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=30000, cutPrice2=60000, cutPrice3=90000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=10) and month(regdate)='11'
--21800

-- 10등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=8000, cutPrice2=12000, cutPrice3=20000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=10) and month(regdate)='11'
--21800



-----------------#   등급별 가격 세팅 끝



-----------------# 특정 키워드별 가격 세팅 시작


-- 1등급 원룸 배너광고

update tbl_kwPrice
set cutPrice1=280000, cutPrice2=560000, cutPrice3=840000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='원룸') and month(regdate)='11'


-- 1등급원룸 홈페이지 광고
update tbl_kwPrice
set cutPrice1=420000, cutPrice2=840000, cutPrice3=1260000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='원룸') and month(regdate)='11'
--21800



-- 1등급 원룸 -생활광고
update tbl_kwPrice
set cutPrice1=124000, cutPrice2=186000, cutPrice3=310000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='원룸') and month(regdate)='11'
--21800



-- 1등급 디젤 배너광고

update tbl_kwPrice
set cutPrice1=150000, cutPrice2=300000, cutPrice3=450000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='디젤') and month(regdate)='11'


-- 1등급 디젤 홈페이지 광고
update tbl_kwPrice
set cutPrice1=230000, cutPrice2=460000, cutPrice3=690000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='디젤') and month(regdate)='11'
--21800



-- 1등급 디젤 -생활광고
update tbl_kwPrice
set cutPrice1=68000, cutPrice2=102000, cutPrice3=170000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='디젤') and month(regdate)='11'
--21800









-- 1등급 월세 배너광고

update tbl_kwPrice
set cutPrice1=220000, cutPrice2=440000, cutPrice3=660000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='월세') and month(regdate)='11'


-- 1등급월세 홈페이지 광고
update tbl_kwPrice
set cutPrice1=340000, cutPrice2=680000, cutPrice3=1020000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='월세') and month(regdate)='11'
--21800

-- 1등급 월세 -생활광고
update tbl_kwPrice
set cutPrice1=100000, cutPrice2=150000, cutPrice3=250000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='월세') and month(regdate)='11'
--21800








-- 1등급 전세 배너광고

update tbl_kwPrice
set cutPrice1=190000, cutPrice2=380000, cutPrice3=570000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='전세') and month(regdate)='11'


-- 1등급 전세 홈페이지 광고
update tbl_kwPrice
set cutPrice1=290000, cutPrice2=580000, cutPrice3=870000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='전세') and month(regdate)='11'
--21800

-- 1등급 전세  -생활광고
update tbl_kwPrice
set cutPrice1=84000, cutPrice2=126000, cutPrice3=210000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='전세') and month(regdate)='11'
--21800








-- 1등급 간호조무사  배너광고

update tbl_kwPrice
set cutPrice1=170000, cutPrice2=340000, cutPrice3=510000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='간호조무사') and month(regdate)='11'


-- 1등급 간호조무사 홈페이지 광고
update tbl_kwPrice
set cutPrice1=240000, cutPrice2=480000, cutPrice3=720000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='간호조무사') and month(regdate)='11'
--21800

-- 1등급 간호조무사  -생활광고
update tbl_kwPrice
set cutPrice1=72000, cutPrice2=108000, cutPrice3=180000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='간호조무사') and month(regdate)='11'
--21800











-- 2등급 lpg 홈페이지 광고
update tbl_kwPrice
set cutPrice1=150000, cutPrice2=300000, cutPrice3=450000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='LPG') and month(regdate)='11'
--21800





-- 2등급 원룸월세 홈페이지 광고
update tbl_kwPrice
set cutPrice1=150000, cutPrice2=300000, cutPrice3=450000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='원룸월세') and month(regdate)='11'
--21800



-- 2등급 고시원  -생활광고
update tbl_kwPrice
set cutPrice1=40000, cutPrice2=60000, cutPrice3=100000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='고시원') and month(regdate)='11'
--21800




--아반떼
-- 3등급 아반떼 배너 광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=140000, cutPrice3=210000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='아반떼') and month(regdate)='11'
--21800



--아반떼
-- 3등급 아반떼 생활  광고
update tbl_kwPrice
set cutPrice1=28000, cutPrice2=42000, cutPrice3=70000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='아반떼') and month(regdate)='11'
--21800

--
--빌라전세
-- 3등급 빌라전세 배너 광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=140000, cutPrice3=210000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='빌라전세') and month(regdate)='11'



--빌라전세
-- 3등급 빌라전세 홈페이지  광고
update tbl_kwPrice
set cutPrice1=100000, cutPrice2=200000, cutPrice3=300000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='빌라전세') and month(regdate)='11'

--빌라전세
-- 3등급 빌라전세   생활   광고
update tbl_kwPrice
set cutPrice1=28000, cutPrice2=42000, cutPrice3 = 70000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='빌라전세') and month(regdate)='11'



--냉장고
-- 3등급 냉장고 배너 광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=140000, cutPrice3=210000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='냉장고') and month(regdate)='11'

--냉장고
-- 3등급 냉장고 홈페이지  광고
update tbl_kwPrice
set cutPrice1=100000, cutPrice2=200000, cutPrice3=300000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='냉장고') and month(regdate)='11'

--냉장고
-- 3등급 냉장고   생활광고
update tbl_kwPrice
set cutPrice1=28000, cutPrice2=42000, cutPrice3 = 70000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='냉장고') and month(regdate)='11'





--오토바이
-- 3등급 오토바이  배너 광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=140000, cutPrice3=210000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='오토바이') and month(regdate)='11'

--오토바이
-- 3등급 오토바이 홈페이지  광고
update tbl_kwPrice
set cutPrice1=100000, cutPrice2=200000, cutPrice3=300000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='오토바이') and month(regdate)='11'

--오토바이
-- 3등급 오토바이   생활광고
update tbl_kwPrice
set cutPrice1=28000, cutPrice2=42000, cutPrice3 = 70000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='오토바이') and month(regdate)='11'




--독서실
-- 3등급 독서실  배너 광고
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=180000, cutPrice3=270000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='독서실') and month(regdate)='11'

--독서실
-- 3등급 독서실 홈페이지  광고
update tbl_kwPrice
set cutPrice1=100000, cutPrice2=200000, cutPrice3=300000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='독서실') and month(regdate)='11'

--독서실
-- 3등급 독서실   생활광고
update tbl_kwPrice
set cutPrice1=36000, cutPrice2=54000, cutPrice3 = 90000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='독서실') and month(regdate)='11'




--재택
-- 3등급 재택  배너 광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=140000, cutPrice3=210000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='재택') and month(regdate)='11'

--재택
-- 3등급 재택 홈페이지  광고
update tbl_kwPrice
set cutPrice1=100000, cutPrice2=200000, cutPrice3=300000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='재택') and month(regdate)='11'

--재택
-- 3등급 재택   생활광고
update tbl_kwPrice
set cutPrice1=28000, cutPrice2=42000, cutPrice3 = 70000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='재택') and month(regdate)='11'


--배달
-- 3등급 배달  배너 광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=140000, cutPrice3=210000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='배달') and month(regdate)='11'

--배달
-- 3등급 재택 홈페이지  광고
update tbl_kwPrice
set cutPrice1=100000, cutPrice2=200000, cutPrice3=300000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='배달') and month(regdate)='11'

--배달
-- 3등급 배달   생활광고
update tbl_kwPrice
set cutPrice1=28000, cutPrice2=42000, cutPrice3 = 70000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='배달') and month(regdate)='11'

--경차
-- 3등급 경차   생활광고
update tbl_kwPrice
set cutPrice1=28000, cutPrice2=42000, cutPrice3 = 70000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='경차') and month(regdate)='11'





--주말
-- 4등급 주말 홈페이지 광고
update tbl_kwPrice
set cutPrice1=80000, cutPrice2=160000, cutPrice3=240000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='주말') and month(regdate)='11'
--21800



--경리

-- 4등급 경리 홈페이지 광고
update tbl_kwPrice
set cutPrice1=80000, cutPrice2=160000, cutPrice3=240000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='경리') and month(regdate)='11'
--21800



--오피스텔

--오피스텔
-- 3등급 오피스텔  배너 광고
update tbl_kwPrice
set cutPrice1=50000, cutPrice2=100000, cutPrice3=150000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='오피스텔') and month(regdate)='11'

--오피스텔
-- 3등급 오피스텔 홈페이지  광고
update tbl_kwPrice
set cutPrice1=80000, cutPrice2=160000, cutPrice3=240000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='오피스텔') and month(regdate)='11'

--오피스텔
-- 3등급 오피스텔   생활광고
update tbl_kwPrice
set cutPrice1=20000, cutPrice2=30000, cutPrice3 = 50000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='오피스텔') and month(regdate)='11'



--매장관리


--매장관리
-- 3등급 매장관리 홈페이지  광고
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=120000, cutPrice3=180000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='매장관리') and month(regdate)='11'

--매장관리
-- 3등급 매장관리   생활광고
update tbl_kwPrice
set cutPrice1=16000, cutPrice2=24000, cutPrice3 = 40000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='매장관리') and month(regdate)='11'



--대리운전
-- 3등급 대리운전   생활광고
update tbl_kwPrice
set cutPrice1=16000, cutPrice2=24000, cutPrice3 = 40000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='대리운전') and month(regdate)='11'


--PC방
-- 5등급 PC방  -홈페이지
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=140000, cutPrice3=210000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='PC방') and month(regdate)='11'




--노트북
-- 7등급 노트북  -배너
update tbl_kwPrice
set cutPrice1=40000, cutPrice2=80000, cutPrice3=120000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='노트북') and month(regdate)='11'


--엑센트

-- 3등급 엑센트   생활광고
update tbl_kwPrice
set cutPrice1=16000, cutPrice2=24000, cutPrice3 = 40000
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='엑센트') and month(regdate)='11'

--중고오토바이

-- 3등급 중고오토바이  배너 광고
update tbl_kwPrice
set cutPrice1=35000, cutPrice2=70000, cutPrice3=105000
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='중고오토바이') and month(regdate)='11'

--중고오토바이
-- 3등급 중고오토바이 홈페이지  광고
update tbl_kwPrice
set cutPrice1=40000, cutPrice2=80000, cutPrice3=120000
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='중고오토바이') and month(regdate)='11'
























		IF (@@error <> 0)
			BEGIN
				ROLLBACK TRAN
				--SET @outparm = '0'
				--print @outparm
				RETURN(1)
			END
		Else
			Begin
				COMMIT TRAN
				--SET @outparm = '1'
				--print @outparm
				RETURN(0)
			END
GO
/****** Object:  StoredProcedure [dbo].[sp_qna_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: qna 리스트
	제작자		: 고병호
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터

******************************************************************************/
CREATE PROCEDURE [dbo].[sp_qna_list_01]

	@sYY			int	= 0
	,@sMM			int = 0
	,@sDD			int = 0
	,@eYY			int = 0
	,@eMM			int = 0
	,@eDD			int = 0
	,@s_date		varchar(10)
	,@e_date		varchar(10)
	,@gotopage		int = 0
	,@DateSearch	varchar(10)
	,@sText			varchar(30)
	,@sTitle		varchar(10)
	,@toppage		int = 1
	,@check_cnt		int = 1
	,@sGubun		char(1) = ''
	,@sCheck		char(1) = ''
	,@sRead			char(1) = ''


AS
	SET NOCOUNT ON
	BEGIN

	DECLARE
		@Sql		varchar(1000)

	if @check_cnt = '1'
		begin
			SET @Sql = 'select count(idx) from tbl_qna with (noLock)  '
		end
	else
		begin
			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' '
			SET @Sql = @Sql + ' idx, username, userid, gubun, title, regdate, re_regdate, qna_Read, qna_check'
			SET @Sql = @Sql + ' from tbl_qna with (noLock)  '

		end

--------------------------------------------------------------------------------------------------------------


	SET @Sql = @Sql + ' where title <> '''' '


	if @sRead <> ''
		begin
			if @sRead = '1'
				begin
					SET @Sql = @Sql + ' and qna_read = ''1'' '
				end
			else
				begin
					SET @Sql = @Sql + ' and qna_read = ''0'' '
				end

		end



	if @sGubun <> ''		--'// 분류에 따른 찾기
		begin
			SET @Sql = @Sql + ' and gubun = '''+@sGubun+''' '
		end

	if @sCheck <> ''		--	'// 처리에 따른 찾기
		begin
			SET @Sql = @Sql + ' and qna_check = '''+@sCheck+''' '
		end

	if @sTitle <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
		begin
			SET @Sql = @Sql + ' and '+@sTitle+' like ''%'+@sText+'%'' '
		end


	if @DateSearch  = 'regdate'
		begin
			if @s_date <> '' and @e_date <> ''
			begin
				SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
				SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
			end
		else
			begin
				if @s_date <> '' and @e_date = ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
					end
				else
					begin
						if @s_date = '' and @e_date = ''
							begin
								SET @sql = @sql + ' '
							end
						else
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
							end
					end
			end
		end
	else
		begin
			if @s_date <> '' and @e_date <> ''
			begin
				SET @sql = @sql + ' and CONVERT(varchar(10), re_regdate,120) >= '''+@s_Date+''' '
				SET @sql = @sql + ' and CONVERT(varchar(10), re_regdate,120) <= '''+@e_Date+''' '
			end
		else
			begin
				if @s_date <> '' and @e_date = ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), re_regdate,120) >= '''+@s_Date+''' '
					end
				else
					begin
						if @s_date = '' and @e_date = ''
							begin
								SET @sql = @sql + ' '
							end
						else
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), re_regdate,120) <= '''+@e_Date+''' '
							end
					end
			end
		end


--// -----------------------------------------------------------------------------------------------------------------
	if @check_cnt = '0'
		begin
			SET @Sql = @Sql +' order by idx desc'
		end

	print(@sql)
	EXECUTE(@SQL)


	END
GO
/****** Object:  StoredProcedure [dbo].[sp_qna_write_action_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_qna_write_action_01]
	@re_name	varchar(20) = ''
	,@re_email	varchar(50) = ''
	,@reply		varchar(3000) = ''
	,@qna_check	char(1) = ''
	,@idx	int
AS
	SET NOCOUNT ON

	BEGIN

	update tbl_qna set
		re_name	= '''+@re_name+'''
		,re_email	= '''+@re_email+'''
		,reply	= '''+@reply+'''
		,qna_check = '''+@qna_check+'''
		where idx = @idx


	END
GO
/****** Object:  StoredProcedure [dbo].[sp_readCnt]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 노출수 정보
	제작자		: 정윤정
	제작일		: 2004.03.30
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_readCnt]
@kwName varchar(25) = ''
AS
	BEGIN
		DECLARE @sql	varchar(2000)
		DECLARE @today_y int
		DECLARE @today_m int
		DECLARE @regday_y int
		DECLARE @regday_m int
		DECLARE @readCnt int
		DECLARE @kwCode int

		Set @today_y = DATEPART(year, getdate())
		Set @today_m = DATEPART(month, getdate())

		SELECT @kwCode = kwCode FROM tbl_similarkw WITH (NOLOCK) WHERE similarkwName = @kwName

		IF @kwCode is null
			SELECT @kwCode = kwCode, @regday_y = DATEPART(year, kwRegDate), @regday_m = DATEPART (month, kwRegDate), @readCnt = readCnt FROM tbl_keyword WITH (NOLOCK) WHERE kwName = @kwName

		IF @kwCode is null
			Set @sql = 'SELECT 0 as readCnt'
		ELSE
			BEGIN
				IF (@today_y = @regday_y) and (@today_m = @regday_m )
					begin
--					Set @sql = 'SELECT isNull(CAST(' + RTRIM(CAST(@readCnt as varchar(20))) + ' as int), 0) as readCnt'
					Set @sql = 'SELECT 0 as readCnt'
					end
				ELSE
					Set @sql = 'SELECT isNull(readCnt, 0) as readCnt FROM tbl_kwcnt WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) = 1) AND kwCode = CAST(' + RTRIM(CAST(@kwCode as varchar(20))) + ' as int)'
			END

		EXECUTE(@sql)
--		Print(@sql)
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_readCnt_Front]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
use keywordshop_test
	설명		:프론트  노출수  정보
	제작자		: 박준희
	제작일		: 2004.09.02
	수정자		:
	수정일		:
	파라미터   @kwName   : 검색키워드명
	설명 		:
			실제 키워드별 노출수가 아닌 기획팀에서 준 자료를
			임포팅한 테이블에서 데이터 가져와서 프론트페이지
			(광고 신청전 키워드 검색결과 페이지)에서 사용함
select * from tbl_kwCnt_Front with(NoLock)
******************************************************************************/

CREATE PROC [dbo].[sp_readCnt_Front]
@kwName varchar(25) = ''
AS
	BEGIN
		DECLARE @sql	varchar(2000)
		DECLARE @today_y int
		DECLARE @today_m int
		DECLARE @today_d int
		DECLARE @regday_y int
		DECLARE @regday_m int
		DECLARE @readCnt int
		DECLARE @kwCode int

		Set @today_y = DATEPART(year, getdate())
		Set @today_m = DATEPART(month, getdate())
		Set @today_d =  DATEPART(day, getdate())



		SELECT @kwCode = kwCode FROM tbl_similarkw WITH (NOLOCK) WHERE similarkwName = @kwName

		IF @kwCode is null
			SELECT @kwCode = kwCode, @regday_y = DATEPART(year, kwRegDate), @regday_m = DATEPART (month, kwRegDate), @readCnt = readCnt FROM tbl_keyword WITH (NOLOCK) WHERE kwName = @kwName

		IF @kwCode is null
			Set @sql = 'SELECT 0 as readCnt'
		ELSE
			BEGIN
				IF (@today_y = @regday_y) and (@today_m = @regday_m )
					begin
--					Set @sql = 'SELECT isNull(CAST(' + RTRIM(CAST(@readCnt as varchar(20))) + ' as int), 0) as readCnt'
					Set @sql = 'SELECT 0 as readCnt'
					end
				ELSE
					IF @today_d >= 10    --10일 이후엔. 그달  날짜
						BEGIN
						Set @sql = 'SELECT isNull(readCnt, 6900) as readCnt FROM tbl_kwcnt_Front WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) = 0) AND kwCode = CAST(' + RTRIM(CAST(@kwCode as varchar(20))) + ' as int)'
						END
					ELSE
						BEGIN	   -- 10일 이전엔 그 전달 날짜
						Set @sql = 'SELECT isNull(readCnt, 6900) as readCnt FROM tbl_kwcnt_Front WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) = 1) AND kwCode = CAST(' + RTRIM(CAST(@kwCode as varchar(20))) + ' as int)'
						END


			END

		EXECUTE(@sql)
--		Print(@sql)
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_RecmAd_edit_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_RecmAd_edit_01]

	@idx		int = 0
AS
	SET NOCOUNT ON

	DECLARE @Sql		varchar(1000)


	SET @Sql = 'select top 1 '
	SET @Sql = @Sql + ' idx, SiteGbn,Rank , OwnerName,UserID, AdStartDay, AdEndDay, AdStatus, AdUrl, '
	SET @Sql = @Sql + ' AdImg, Target, PopWidth, PopHeight, Cont1, Cont2, Note, ClickCnt, RegDate, ModDate from tbl_RecmAd With(NoLock) '
	SET @Sql = @Sql + ' where idx = '''+CAST(@idx AS varCHAR(5)) + ''' '
	--print(@sql)

	Execute(@sql)
GO
/****** Object:  StoredProcedure [dbo].[sp_RecmAd_list_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 텍스트이미지관리 리스트
	제작자		: 박준희
	제작일		: 2005.02.24
	수정자		:
	수정일		:
	파라미터

use keywordshop
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_RecmAd_list_02]
	@gotopage		int = 0
	,@sSiteGbn		varchar(1) 	= ''
	,@sText			varchar(30)	= ''
	,@sSearch		varchar(10)	= ''
	,@toppage		int = 1
	,@check_cnt		int = 1
AS
	SET NOCOUNT ON

	BEGIN
		DECLARE @Sql varchar(1000)

		if @check_cnt = '1'
		begin
			SET @Sql = 'select count(idx) from dbo.tbl_RecmAd with (noLock)  '
		end
		else
		begin

			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' '
			SET @Sql = @sql + ' idx, SiteGbn,Rank, OwnerName, adStartDay, adEndDay, adStatus, target, ClickCnt, regDate '
			SET @Sql = @sql + ' from dbo.tbl_RecmAd with (noLock) '
		end


		SET @Sql = @Sql + ' where idx <> '''' '

		IF @sSiteGbn <> ''
		BEGIN
			SET @Sql = @Sql + ' and SiteGbn = ' + @sSiteGbn
		END


		if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
		begin
			SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
		end

		if @check_cnt = '0'
		begin
			SET @Sql = @Sql +' order by regdate desc'
		end

	END
--print(@sql)
	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[sp_RecmAd_list_action_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_RecmAd_list_action_01]
	(
		@key		char(1) = ''
		,@idx		int = 0
	)

AS
	SET NOCOUNT ON
	BEGIN
		update tbl_RecmAd set adStatus = @key where idx = @idx
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_RecmAdClickCntPlus]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 텍스트이미지광고  클릭수 증가
	제작자		: 박준희
	제작일		: 2005.01.25
	수정자		:
	수정일		:
	수정내용	:
	파라미터 :고유키 Idx
use keywordshop_test3

******************************************************************************/

CREATE PROC [dbo].[sp_RecmAdClickCntPlus]
@Idx int

AS
SET NOCOUNT ON
	BEGIN
		UPDATE tbl_RecmAd  SET clickCnt = clickCnt + 1 WHERE Idx = @Idx

	END
GO
/****** Object:  StoredProcedure [dbo].[sp_relationKw]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 관련키워드 정보
	제작자		: 정윤정
	제작일		: 2004.03.30
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[sp_relationKw]
@kwName varchar(25) = ''
AS
	BEGIN
		DECLARE @sql	varchar(1000)
		DECLARE @kwCode int

		SELECT @kwCode = kwCode FROM tbl_similarKw WHERE similarKwName = @kwName

		IF @kwCode is null or @kwCode = 0
			SET @sql = 'SELECT relationKw,kwCode,kwgrade FROM tbl_keyword WITH (NOLOCK) WHERE kwName = ''' + @kwName + ''''
		ELSE
			SET @sql = 'SELECT relationKw,kwCode,kwgrade FROM tbl_keyword WITH (NOLOCK)  WHERE kwCode = ' + CAST(@kwCode AS varchar(20))

		EXECUTE(@sql)
--   Print(@sql)
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_RelationKwd_ReadCnt_SpPrice]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
sp_AdNewSearch_Section
use keywordshop_test
	설명		:추천키워드 리스트
	제작자		: 박준희
	제작일		: 2005.02.01
	수정자		:
	수정일		:
	파라미터   @kwName   : 검색키워드명
	설명 		:
			실제 키워드별 노출수가 아닌 기획팀에서 준 자료를
			임포팅한 테이블에서 데이터 가져와서 프론트페이지
			(광고 신청전 키워드 검색결과 페이지)에서 사용함


******************************************************************************/

CREATE PROCEDURE  [dbo].[sp_RelationKwd_ReadCnt_SpPrice]
@kwName varchar(25) = ''
AS
	BEGIN
		DECLARE @sql	varchar(2000)
		DECLARE @today_y int
		DECLARE @today_m int
		DECLARE @today_d int
		DECLARE @regday_y int
		DECLARE @regday_m int
		DECLARE @readCnt int
		DECLARE @kwCode int

		Set @today_y = DATEPART(year, getdate())
		Set @today_m = DATEPART(month, getdate())
		Set @today_d =  DATEPART(day, getdate())



		SELECT @kwCode = kwCode FROM tbl_similarkw WITH (NOLOCK) WHERE similarkwName = @kwName

		IF @kwCode is null
			SELECT @kwCode = kwCode, @regday_y = DATEPART(year, kwRegDate), @regday_m = DATEPART (month, kwRegDate), @readCnt = readCnt FROM tbl_keyword WITH (NOLOCK) WHERE kwName = @kwName

		IF @kwCode is null
			Begin
			Set @sql = 'SELECT 0 as readCnt;'
			Set @sql = @Sql + 'SELECT Top 1 CutPrice3  FROM tbl_kwPrice WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) = 0) AND  GoodGubun=''3'' ;'
			END
		ELSE
			BEGIN
				IF (@today_y = @regday_y) and (@today_m = @regday_m )
					begin
--					Set @sql = 'SELECT isNull(CAST(' + RTRIM(CAST(@readCnt as varchar(20))) + ' as int), 0) as readCnt'
					Set @sql = 'SELECT 0 as readCnt;'
					Set @sql = @Sql + 'SELECT Top 1 CutPrice3  FROM tbl_kwPrice WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) = 0) AND kwCode = CAST(' + RTRIM(CAST(@kwCode as varchar(20))) + ' as int) AND GoodGubun=''3'' ;'

					end
				ELSE
					IF @today_d >= 10    --10일 이후엔. 그달  날짜
						BEGIN
						Set @sql = 'SELECT isNull(readCnt, 0) as readCnt FROM tbl_kwcnt_Front WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) = 0) AND kwCode = CAST(' + RTRIM(CAST(@kwCode as varchar(20))) + ' as int);'
						Set @sql = @Sql + 'SELECT Top 1 CutPrice3  FROM tbl_kwPrice WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) = 0) AND kwCode = CAST(' + RTRIM(CAST(@kwCode as varchar(20))) + ' as int) AND GoodGubun=''3'' ;'
						END
					ELSE
						BEGIN	   -- 10일 이전엔 그 전달 날짜
						Set @sql = 'SELECT isNull(readCnt, 0) as readCnt FROM tbl_kwcnt_Front WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) =1) AND kwCode = CAST(' + RTRIM(CAST(@kwCode as varchar(20))) + ' as int);'
						Set @sql = @Sql + 'SELECT Top 1 CutPrice3  FROM tbl_kwPrice WITH (NOLOCK) WHERE (DATEDIFF(month , regdate , getdate()) = 0) AND kwCode = CAST(' + RTRIM(CAST(@kwCode as varchar(20))) + ' as int) AND GoodGubun=''3'' ;'
						END


			END


		EXECUTE(@sql)
		--Print(@sql)
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_Repay_Reg]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고 판매 리스트
	제작자		: 이기운
	제작일		: 2004.04.14
	수정자		: 박준희
	수정일		:
	파라미터
select * from tbl_keyword_repay with(NoLock)



*************************************************************************/

CREATE PROCEDURE [dbo].[sp_Repay_Reg]
(

	@AdCode			int  = 0  ,
	@RepayMoney			int =0  ,
	@RepayReason			varchar(300)= '' ,
	@Magid				varchar(30) ='' ,
	@RepayDate			smalldatetime




)



AS
SET NOCOUNT ON
BEGIN
	DEClare @CntAdCode int

	SELECT  Count(AdCode) From tbl_keyword_Repay With(NOLOCK)  WHERE AdCode= @AdCode ;
	SELECT  @CntAdCode = Count(AdCode) From tbl_keyword_Repay WHERE AdCode= @AdCode ;

	IF @CntAdCode <=0
	BEGIN
	Insert Into tbl_keyword_Repay(AdCode, RepayMoney, RepayReason, Magid, RepayDate, RegDate )
	Values(@Adcode , @RepayMoney , @RepayReason , @MagId , @RepayDate , GETDATE() ) ;
	UPDATE tbl_keyword_Adinfo SET payState ='R' WHERE Code=@AdCode
	END




END
GO
/****** Object:  StoredProcedure [dbo].[sp_Report_Posting_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고 게재현황 리스트 01
	제작자		: 박준희
	제작일		: 2004.08.24
	수정자		: 박준희
	수정일		:
	파라미터
	/Mag/report/report_posting_01.asp 파일의 데이터 카운팅과 리스트


******************************************************************************/


CREATE PROCEDURE [dbo].[sp_Report_Posting_01]
(

	@top				int = 0,
	@DateField			varchar(20) = '',
	@Period				varchar(15) = '',
	@sDate				varchar(10) = '',
	@goodGubun			char(1) = '',
	@goodRank			char(1) = '',
	@kwSection			char(1) = '8',		-- 8:섹션무관, 1:벼룩시장신문, 2:상품직거래, 3:자동차, 4:부동산, 5:구인구직, 6:아르바이트, 7:YP
	@branchCode			int = 0 ,		-- 0:전체,1:지점, 2:지사, 10이상: 지점및지사코드
	@isDc				char(1) = '',
	@sSearch			varchar(18) = '',
	@sText				varchar(30) = '',
	@outparam			varchar(2000)='0'	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(5000)
	DECLARE @CountSql 	varchar(300)
	DECLARE @ListSql 	varchar(500)
	DECLARE @SumSql 	varchar(2000)
	DECLARE @FromSql 	varchar(500)
	DECLARE @WhereSql 	varchar(600)
	DECLARE @OrderSql 	varchar(100)

	SET 	@Sql=' '
	SET 	@CountSql=' '
	SET 	@ListSql=' '
	SET 	@SumSql =''
	SET 	@FromSql = ''
	SET	@WhereSql=' '
	SET 	@OrderSql = ''


			SET @CountSql = @CountSql + 'SELECT  count(a.code), sum(a.OriginPrice) as OriginPriceTot , sum(Case When a.branchcode > ''0'' and a.branchcode <> NULL Then i.real_Price Else a.originPrice End) AS Real_PriceTot   '


			SET @ListSql = @ListSql + 'SELECT  top '+Cast(@top as varchar)+' '
			SET @ListSql = @ListSql + ' a.code,  k.kwName, k.kwSection, k.kwGrade, a.goodGubun, a.goodRank, '
			SET @ListSql = @ListSql + ' a.branchCode, isNULL(a.isDC,''1'') isDC, a.id,a.PayMethod, a.PayKind,  a.PayDate,a.Period,  a.StartDay , a.EndDay ,'
			SET @ListSql = @ListSql + ' a.regDate, a.OriginPrice ,i.Real_Price ,'
			SET @ListSql = @ListSql + ' isNULL(isService,0) isService, price = Case When a.branchcode > ''0'' and a.branchcode <> NULL Then i.real_Price Else a.originPrice End ,a.startDay'

			--회원 통계
			SET @SumSql = @SumSql + 'SELECT Count(Case When (a.branchcode = ''0'' Or  a.branchcode Is NULL Or a.branchCode='''' ) AND (a.IsDC =''1'' OR a.ISDC Is NULL)   Then a.Code  End) AS Cnt_Member_NoDC  , Count(Case When (a.branchcode = ''0'' Or  a.branchcode Is NULL Or a.branchCode='''' ) AND (a.IsDC  IN (''2'', ''3'', ''4'',''5'',''6'', ''8'') ) Then a.Code  End) AS Cnt_Member_DC  , Count(Case When (a.branchcode = ''0'' Or  a.branchcode Is NULL Or a.branchCode='''' ) AND a.IsDC =''7''  Then a.Code  End) AS Cnt_Member_Free  ,  '
			--80   인본
			SET @SumSql = @SumSql + 'Count(Case When a.branchcode = ''80'' AND  (a.IsDC =''1'' OR a.ISDC Is NULL)  Then a.Code  End) AS Cnt_80_NoDC  ,  Count(Case When a.branchcode = ''80'' AND a.isDC IN (''2'' , ''3'', ''4'', ''5'', ''6'', ''8'')   Then a.Code  End) AS Cnt_80_DC  , Count(Case When a.branchcode = ''80'' AND a.isDC =''7''  Then a.Code  End) AS Cnt_80_Free  ,     '
			--86   인본_ TM
			SET @SumSql = @SumSql + 'Count(Case When a.branchcode = ''86'' AND  (a.IsDC =''1'' OR a.ISDC Is NULL)  Then a.Code  End) AS Cnt_86_NoDC  ,  Count(Case When a.branchcode = ''86'' AND a.isDC IN (''2'' , ''3'', ''4'', ''5'', ''6'', ''8'')   Then a.Code  End) AS Cnt_86_DC  , Count(Case When a.branchcode = ''86'' AND a.isDC =''7''  Then a.Code  End) AS Cnt_86_Free  ,     '

			--지점 (회원도 인본도  인본 TM도  아닌 것)
			SET @SumSql = @SumSql + ' Count(CASE WHEN  (( a.branchCode <> ''80'' AND a.branchCode <> ''86''  AND a.branchCode<>''0'' AND a.branchCode is Not NULL AND a.BranchCode <> '''')  AND (a.isDC =''1'' OR a.isDC IS NULL) )  THEN a.Code  END ) AS Cnt_Branch_NODC ,  Count(CASE WHEN  (( a.branchCode <> ''80'' AND a.branchCode <> ''86''  AND a.branchCode<>''0'' AND a.branchCode is Not NULL AND a.BranchCode <> '''' )  AND a.isDC IN (''2'' , ''3'', ''4'', ''5'', ''6'' , ''8'' )  )  THEN a.Code  END ) AS Cnt_Branch_DC,   Count(CASE WHEN  (( a.branchCode <> ''80'' AND a.branchCode <> ''86''  AND a.branchCode<>''0'' AND a.branchCode is Not NULL AND a.BranchCode <> '''' ) AND a.isDC =''7'' )  THEN a.Code  END ) AS Cnt_Branch_Free   '




	SET @FromSql = @FromSql + ' FROM tbl_keyword_adinfo2 as a with (nolock) left outer join tbl_keyword_income as i with (nolock) on a.code = i.code  left outer join tbl_keyword_Repay  as R   With(NoLock)  on a.Code = R.AdCode  left outer join tbl_keyword k With(NoLock)  on a.kwcode = k.kwcode'
	SET @FromSql = @FromSql + ' WHERE (AdState = ''Y'' )  and a.goodgubun <> ''4'' '  --원래 이걸로 한다.



	-- 기준일 선택
	IF @sDate  <> '' AND @DateField <> ''  --시작일/종료일이 존재하고, 검색필드가 존재할 경우에만 날짜 검색
		BEGIN
		IF @DateField ='EndDay-2'
			BEGIN
			--'SET @Sql = @Sql + ' AND a.startDay BETWEEN '''+@sDate+''' AND '''+@eDate+''''
				SET @Wheresql =  @Wheresql + '  and (CONVERT(varchar(10), a.EndDay , 120) = Convert(varchar(10) , DateAdd(d , 2 ,'''+ @sdate +''' ) ) )   '
			END
		ELSE
			BEGIN
				SET @Wheresql =  @Wheresql + '  and (CONVERT(varchar(10), a.'+@DateField+', 120) = '''+@sdate+''' ) '
			END
		END

	-- 섹션
	IF @kwSection <> ''
		BEGIN
			SET @WhereSql = @WhereSql + ' AND k.kwSection = '''+@kwSection+''''
		END


	-- 상품구분
	IF @goodGubun <> ''
		BEGIN
			SET @WhereSql = @WhereSql + ' AND a.goodGubun = '''+@goodgubun+''''
		END


	-- 상품순위
	IF @goodRank <> ''
		BEGIN
			SET @WhereSql = @WhereSql + ' AND a.goodRank = '''+@goodRank+''''
		END




	-- 지점


	IF @branchCode <> ''
	BEGIN
		IF @branchCode = '1'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.branchGubun = ''1'' '
			END
		ELSE IF @branchCode = '2'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.branchGubun = ''2'' '
			END
		ELSE IF @branchcode ='81'   --강남
			Begin
				SET @WhereSql = @WhereSql + ' and (branchCode =''16'' or branchCode =''17'' or branchCode =''18'' or branchCode =''21'' or branchCode =''10''  or branchCode =''81'' )'
			End

		Else IF @branchcode ='82'    --강북
			Begin
				SET @WhereSql = @WhereSql + ' and (branchCode =''19'' or branchCode =''20'' or branchCode =''22'' or branchCode =''23'' or branchCode =''82'' )'
			End

		Else IF @branchcode ='83'   --경북
			Begin
				SET @WhereSql = @WhereSql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='84'   --경남
			Begin
				SET @WhereSql = @WhereSql + ' and (branchCode =''25'' or branchCode =''49'' or branchCode =''84'' )'
			End

		Else IF @branchcode ='85'    --서부
			Begin
				SET @WhereSql = @WhereSql + ' and (branchCode =''12'' or branchCode =''13'' or branchCode =''14'' or branchCode=''15'' or branchCode=''85'' )'
			End
		Else IF @BranchCode='100'   --회원
			BEGIN
				SET @WhereSql = @WhereSql + ' AND Userid<> '''' AND (BranChCode IS NULL OR BranchCode =''''  ) '
			END
		Else IF @BranchCode='200'    -- 등록대행전체
			BEGIN
				SET @WhereSql = @WhereSql + ' AND (BranChCode IS NOT  NULL  AND BranchCode <> ''''   ) '
			END
		Else IF @BranchCode='300'    -- 지점(전체)
			BEGIN
				SET @WhereSql = @WhereSql + ' AND ( BranchGubun=''1''  ) '
			END
		Else IF @BranchCode='400'    -- 지사 (전체)
			BEGIN
				SET @WhereSql = @WhereSql + ' AND (BranChGubun=''2''    ) '
			END
		Else IF @BranchCode='500'    -- 지점사 (전체)
			BEGIN
				SET @WhereSql = @WhereSql + ' AND (BranChGubun =''1'' Or BranchGubun =''2'' ) '
			END

		ELSE
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.branchCode = '''+CAST(@branchcode AS VARCHAR(3))+''' '
			END
	END



	-- 수주유형
	IF @isDc <> ''
	BEGIN
		IF @isDc = '1'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc = ''1'' '
			END
		ELSE IF @isDc = '2'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc in (''2'',''3'',''4'',''5'') '
			END
		ELSE IF @isDc = '3'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc in (''6'',''7'',''8'') '
			END
		ELSE IF @isDc = '4'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc = ''6'' '
			END
		ELSE IF @isDc = '5'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc = ''7'' '
			END
		ELSE IF @isDc = '6'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc = ''8'' '
			END
	END
	--기간
	IF @Period <> ''

	BEGIN
		IF @Period ='1'
			BEGIN
				SET  @WhereSql = @WhereSql + ' AND Period=''1''  AND GoodGubun=''3''  '
			END
		ELSE IF @Period ='2'
			BEGIN
				SET  @WhereSql = @WhereSql + ' AND Period =''2'' AND GoodGubun=''3'' '
			END
		ELSE IF @Period ='3'
			BEGIN
				SET  @WhereSql = @WhereSql + ' AND ((Period =''3'' AND GoodGubun=''3'' )  OR (Period =''1'' AND GoodGubun IN (''1'', ''2'') ) ) '
			END
		ELSE IF @Period ='4'
			BEGIN
				SET  @WhereSql = @WhereSql + ' AND (Period =''2'' AND GoodGubun IN (''1'', ''2'') ) ) '
			END

		ELSE IF @Period ='5'
			BEGIN
				SET  @WhereSql = @WhereSql + ' AND (Period =''3'' AND GoodGubun IN (''1'', ''2'')  ) '
			END

	END


	IF @sSearch <> '' AND  @sText <> ''
	BEGIN
		SET @WhereSql = @WhereSql +' AND  ' + @sSearch +  ' = '''+@sText +''' '
	END



	--리스트 출력이면


			SET @Sql = @Sql + ' ORDER BY a.kwname, a.goodGubun, a.goodRank'
	SET @Sql =	@CountSql + @FromSql + @WhereSql + ';' + @ListSql + @FromSql + @WhereSql + @OrderSql +';'+
			@SumSql +@FromSql + @WhereSql




	set @outparam=@Sql

	 PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_Report_Posting_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고 게재현황 리스트 02
	제작자		: 박준희
	제작일		: 2004.08.24
	수정자		: 박준희
	수정일		:
	파라미터

sp_Report_Posting_02 '28', '2004-08-25', '', '', '', ''

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_Report_Posting_02]
(

	@top				int = 0,
	@sDate				varchar(10) = '',
	@kwSection			char(1) = '8',		-- 8:섹션무관, 1:벼룩시장신문, 2:상품직거래, 3:자동차, 4:부동산, 5:구인구직, 6:아르바이트, 7:YP
	@kwGrade			varchar(2) ='' ,
	@sSearch 			varchar(15) ='' ,
	@sText				varchar(30) ='',

	@outparam			varchar(8000)='0'	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql1		varchar(5000)
	DECLARE @Sql2 		varchar(8000)
	DECLARE @Sql3		varchar(4000)
	DECLARE @CountSql	varchar(100)
	DECLARE @ListSql	varchar(6000)
	DECLARE @SumSql	varchar(500)
	DECLARE @FromSql	varchar(1500)
	DECLARE @WhereSql  	varchar(1500)
	DECLARE @OrderSql	varchar(500)


	SET @Sql1 =''
	SET @Sql2 = ''
	SET @Sql3 = ''
	SET @CountSql = ''
	SET @ListSql = ''
	SET @SumSql = ''
	SET @FromSql = ''
	SET @WhereSql =''
	SET @OrderSql = ''


			SET @CountSql = @CountSql + 'SELECT Count(distinct ISNULL(a.kwcode , '''') )   '

			SET @ListSql = @ListSql + 'SELECT  top '+Cast(@top as varchar)+' '	+
					  ' A.kwCode , A.kwName , K.KwSection, K.KwGrade , count(A.Code) sum_Cnt  , '+
					  ' Count(CASE WHEN   A.GoodGubun IN(''1'', ''2'', ''3'') AND  A.isDC =''7''  THEN A.Code END  ) AS Cnt_Free , '+
					  ' Count(CASE WHEN   A.GoodGubun IN(''1'', ''2'', ''3'') AND  A.isDC <>''7''  THEN A.Code END  )  AS Cnt_NotFree , '+

					  ' Count(CASE WHEN  A.GoodGubun=''1'' AND A.GoodRank=''1'' AND A.IsDC =''7''   THEN  A.Code  END )  AS GoodGbn1Rank1_Free ,'+
					  ' Count(CASE WHEN  A.GoodGubun=''1'' AND A.GoodRank=''1'' AND A.IsDC <>''7''  THEN  A.Code  END )  AS GoodGbn1Rank1_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''1'' AND A.GoodRank=''2'' AND A.IsDC =''7''   THEN  A.Code  END )  AS GoodGbn1Rank2_Free , '+
					  ' Count(CASE WHEN  A.GoodGubun=''1'' AND A.GoodRank=''2'' AND A.IsDC <>''7''  THEN  A.Code  END )  AS GoodGbn1Rank2_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''1'' AND A.GoodRank=''3'' AND A.IsDC =''7''   THEN  A.Code  END )  AS GoodGbn1Rank3_Free ,'+
					  ' Count(CASE WHEN  A.GoodGubun=''1'' AND A.GoodRank=''3'' AND A.IsDC <>''7''  THEN  A.Code  END )  AS GoodGbn1Rank3_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''1'' AND A.GoodRank=''4'' AND A.IsDC =''7''   THEN  A.Code  END )  AS GoodGbn1Rank4_Free , ' +
					  ' Count(CASE WHEN  A.GoodGubun=''1'' AND A.GoodRank=''4'' AND A.IsDC <>''7''  THEN  A.Code  END )  AS GoodGbn1Rank4_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''2'' AND A.GoodRank=''1'' AND A.isDC = ''7''    THEN A.Code  END  )  AS GoodGbn2Rank1_Free ,'+
					  ' Count(CASE WHEN  A.GoodGubun=''2'' AND A.GoodRank=''1'' AND A.isDC <> ''7''   THEN A.Code  END  )  AS GoodGbn2Rank1_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''2'' AND A.GoodRank=''2'' AND A.isDC = ''7''    THEN A.Code   END )  AS GoodGbn2Rank2_Free , '+
				     	  ' Count(CASE WHEN  A.GoodGubun=''2'' AND A.GoodRank=''2'' AND A.isDC <> ''7''   THEN A.Code   END )  AS GoodGbn2Rank2_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''2'' AND A.GoodRank=''3'' AND A.isDC = ''7''    THEN A.Code   END )  AS GoodGbn2Rank3_Free , '+
					  ' Count(CASE WHEN  A.GoodGubun=''2'' AND A.GoodRank=''3'' AND A.isDC <> ''7''   THEN A.Code   END )  AS GoodGbn2Rank3_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''2'' AND A.GoodRank=''4'' AND A.isDC = ''7''    THEN A.Code   END )  AS GoodGbn2Rank4_Free ,'+
					  ' Count(CASE WHEN  A.GoodGubun=''2'' AND A.GoodRank=''4'' AND A.isDC <> ''7''   THEN A.Code   END )  AS GoodGbn2Rank4_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''2'' AND A.GoodRank=''5'' AND A.isDC = ''7''    THEN A.Code   END )  AS GoodGbn2Rank5_Free ,'+
					  ' Count(CASE WHEN  A.GoodGubun=''2'' AND A.GoodRank=''5'' AND A.isDC <> ''7''   THEN A.Code   END )  AS GoodGbn2Rank5_NotFree ,'+

					  ' Count(CASE WHEN A.GoodGubun=''3''  AND A.isDC = ''7''   THEN A.Code END )  AS Cnt_GoodGbn3_Free      ,'+
					  ' Count(CASE WHEN A.GoodGubun=''3''  AND A.isDC <> ''7''  THEN A.Code END) AS Cnt_GoodGbn3_NotFree   ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''3'' AND A.GoodRank=''1'' AND A.isDC = ''7''    THEN A.Code   END )  AS GoodGbn3Rank1_Free ,'+
					  ' Count(CASE WHEN  A.GoodGubun=''3'' AND A.GoodRank=''1'' AND A.isDC <> ''7''   THEN A.Code   END )  AS GoodGbn3Rank1_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''3'' AND A.GoodRank=''2'' AND A.isDC = ''7''    THEN A.Code   END )  AS GoodGbn3Rank2_Free ,' +
					  ' Count(CASE WHEN  A.GoodGubun=''3'' AND A.GoodRank=''2'' AND A.isDC <> ''7''   THEN A.Code   END )  AS GoodGbn3Rank2_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''3'' AND A.GoodRank=''3'' AND A.isDC = ''7''   THEN A.Code   END )   AS GoodGbn3Rank3_Free , '+
					  ' Count(CASE WHEN  A.GoodGubun=''3'' AND A.GoodRank=''3'' AND A.isDC <> ''7''  THEN A.Code   END )   AS GoodGbn3Rank3_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''3'' AND A.GoodRank=''4'' AND A.isDC = ''7''   THEN A.Code   END )   AS GoodGbn3Rank4_Free ,'+
					  ' Count(CASE WHEN  A.GoodGubun=''3'' AND A.GoodRank=''4'' AND A.isDC <> ''7''  THEN A.Code   END )   AS GoodGbn3Rank4_NotFree ,'+

					  ' Count(CASE WHEN  A.GoodGubun=''3'' AND A.GoodRank=''5'' AND A.isDc = ''7''   THEN A.Code   END )   AS GoodGbn3Rank5_Free, ' +
					  ' Count(CASE WHEN  A.GoodGubun=''3'' AND A.GoodRank=''5'' AND A.isDC <> ''7''  THEN A.Code   END )   AS GoodGbn3Rank5_NotFree  '


		SET @SumSql = 		@SumSql + 	' SELECT  count( CASE WHEN a.ISDC =''7'' THEN a.Code END) AS Cnt_Free , '+
					 	'count( CASE WHEN a.ISDC <> ''7'' OR a.ISDC IS NULL  THEN a.Code END ) AS Cnt_NotFree , Count(A.Code) As Cnt_Tot   '







	   	SET @FromSql = @FromSql +' From tbl_keyword_adinfo2  AS A   With(NoLock)  Left outer Join dbo.tbl_keyword AS K With(NoLock)  On A.KwCode = K.KwCode    '
	   	SET @FromSql = @FromSql + ' WHERE (AdState = ''Y'' )  and a.goodgubun <> ''4'' '  --원래 이걸로 한다.




	-- 기준일 선택
	IF @sDate  <> ''    --   날짜 검색
		BEGIN


			SET @Wheresql =  @Wheresql + '  AND CONVERT(Varchar(10) , A.StartDay , 120) <= '''+@SDate + '''   AND (CONVERT(varchar(10), a.EndDay,  120)  >= '''+@SDate+'''  ) '

		END



	-- 섹션
	IF @kwSection <> ''
		BEGIN
			SET @WhereSql = @WhereSql + ' AND k.kwSection = '''+@kwSection+''''
		END
	-- 등급
	IF @kwGrade  <> ''
		BEGIN
			SET @WhereSql = @WhereSql + ' AND k.kwGrade = '''+@kwGrade+''''
		END
	--@sSearch  , @sText
	IF @sSearch  <> ''   AND @sText <> ''
		BEGIN
			SET @WhereSql = @WhereSql + ' AND k.kwName =LTrim(RTrim('''+@sText + ''')) '
		END





	SET @OrderSql =  ' Group by  A.kwCode ,A.kwName , k.KwSection , K.KwGrade  ORDER BY A.KwName   '




	SET @Sql1 = @Sql1+ @CountSql +@FromSql + @WhereSql  +';'   --카운팅

	SET @Sql2 = @Sql2+@ListSql + @FromSql +  @WhereSql + @OrderSql  + ';'   --리스트
	SET @Sql3 = @Sql3 + @SumSql +@FromSql +  @WhereSql 		--통계







	set @outparam=@Sql1

	 PRINT @Sql1+@Sql2 + @Sql3
	EXECUTE(@Sql1+@Sql2 +@Sql3)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_Report_SUM_Sale_Branch]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고 판매 리스트
	제작자		: 박준희
	제작일		: 2004.08.30
	수정자		:
	수정일		:
	파라미터
use keywordshop
******************************************************************************/


CREATE PROCEDURE [dbo].[sp_Report_SUM_Sale_Branch]
(


	@DateField			varchar(20) = '',
	@Period				varchar(15) = '',
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = '',
	@goodGubun			char(1) = '',
	@goodRank			char(1) = '',
	@kwSection			char(1) = '8',		-- 8:섹션무관, 1:벼룩시장신문, 2:상품직거래, 3:자동차, 4:부동산, 5:구인구직, 6:아르바이트, 7:YP
	@branchCode			int = 0 ,		-- 0:전체,1:지점, 2:지사, 10이상: 지점및지사코드
	@branchType			char(1) = '0',		-- 0:전체, 1:온라인, 2:등록대행
	@isDc				char(1) = '',
	@PayState			char(1) = '',
	@sSearch			varchar(15)='' ,
	@sText				varchar(15)='' ,
	@outparam			varchar(2000)='0'	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(5000)

	Set @Sql='SELECT '


		BEGIN

			SET @Sql = @Sql + ' sum(Case When a.branchcode > ''0'' and a.branchcode <> NULL Then i.real_Price  End) AS Sum_Branch  ,  '
			--"16" , "17" , "18" , "21", "10" , "81"   강남본부
			SET @Sql = @Sql + ' sum( CASE WHEN   a.branchCode=''10'' Or a.branchCode= ''16'' Or a.branchCode= ''17''  Or  a.branchCode=''18'' Or a.branchCode=''21''  Or a.branchCode =''81'' THEN i.Real_Price END ) As Sum_81 ,  '
			--"19" , "20" , "22", "23" , "82"      강북본부
			SET @Sql = @Sql + ' sum (CASE WHEN   a.branchCode=''19'' Or a.branchCode= ''20''  Or a.branchCode= ''22'' Or a.branchCode= ''23''  Or a.branchCode= ''82'' THEN i.Real_Price END ) AS Sum_82 , '
			--11" , "26", "39" , "83"   경북본부
			SET @Sql = @Sql + ' sum( CASE WHEN   a.branchCode=''11'' Or a.branchCode= ''26''  Or a.branchCode= ''39'' Or a.branchCode= ''83''   THEN i.Real_Price END ) AS Sum_83 , '
			--"25" , "49" , "84"    경남 본부
			SET @Sql = @Sql + ' sum(CASE WHEN    a.branchCode=''25'' Or a.branchCode= ''49''  Or a.branchCode= ''84''  THEN i.Real_Price END ) AS Sum_84 , '
			--"12" , "13" , "14" , "15" , "85"   서부지역본부
			SET @Sql = @Sql + ' sum(  CASE WHEN  a.branchCode=''12'' Or a.branchCode= ''13''  Or a.branchCode= ''14'' Or a.branchCode= ''15''  Or a.branchCode= ''85'' THEN i.Real_Price END ) AS Sum_85, '
			--각지점들
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''10'' THEN i.Real_Price END) AS Sum_10 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''11'' THEN i.Real_Price END) AS Sum_11 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''12'' THEN i.Real_Price END) AS Sum_12 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''13'' THEN i.Real_Price END) AS Sum_13 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''14'' THEN i.Real_Price END) AS Sum_14 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''15'' THEN i.Real_Price END) AS Sum_15 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''16'' THEN i.Real_Price END) AS Sum_16 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''17'' THEN i.Real_Price END) AS Sum_17 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''18'' THEN i.Real_Price END) AS Sum_18 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''19'' THEN i.Real_Price END) AS Sum_19 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''20'' THEN i.Real_Price END) AS Sum_20 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''21'' THEN i.Real_Price END) AS Sum_21 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''22'' THEN i.Real_Price END) AS Sum_22 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''23'' THEN i.Real_Price END) AS Sum_23 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''24'' THEN i.Real_Price END) AS Sum_24 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''25'' THEN i.Real_Price END) AS Sum_25 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''26'' THEN i.Real_Price END) AS Sum_26 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''27'' THEN i.Real_Price END) AS Sum_27 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''28'' THEN i.Real_Price END) AS Sum_28 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''29'' THEN i.Real_Price END) AS Sum_29 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''30'' THEN i.Real_Price END) AS Sum_30 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''31'' THEN i.Real_Price END) AS Sum_31 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''32'' THEN i.Real_Price END) AS Sum_32 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''33'' THEN i.Real_Price END) AS Sum_33 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''34'' THEN i.Real_Price END) AS Sum_34 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''35'' THEN i.Real_Price END) AS Sum_35 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''36'' THEN i.Real_Price END) AS Sum_36 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''37'' THEN i.Real_Price END) AS Sum_37 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''38'' THEN i.Real_Price END) AS Sum_38 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''39'' THEN i.Real_Price END) AS Sum_39 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''40'' THEN i.Real_Price END) AS Sum_40 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''41'' THEN i.Real_Price END) AS Sum_41 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''42'' THEN i.Real_Price END) AS Sum_42 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''43'' THEN i.Real_Price END) AS Sum_43 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''44'' THEN i.Real_Price END) AS Sum_44 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''45'' THEN i.Real_Price END) AS Sum_45 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''46'' THEN i.Real_Price END) AS Sum_46 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''47'' THEN i.Real_Price END) AS Sum_47 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''48'' THEN i.Real_Price END) AS Sum_48 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''49'' THEN i.Real_Price END) AS Sum_49 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''50'' THEN i.Real_Price END) AS Sum_50 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''51'' THEN i.Real_Price END) AS Sum_51 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''52'' THEN i.Real_Price END) AS Sum_52 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''53'' THEN i.Real_Price END) AS Sum_53 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''54'' THEN i.Real_Price END) AS Sum_54 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''55'' THEN i.Real_Price END) AS Sum_55 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''56'' THEN i.Real_Price END) AS Sum_56 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''57'' THEN i.Real_Price END) AS Sum_57 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''58'' THEN i.Real_Price END) AS Sum_58 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''59'' THEN i.Real_Price END) AS Sum_59 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''80'' THEN i.Real_Price END) AS Sum_80 , '
			SET @Sql = @Sql + ' sum( Case When a.BranchCode=''86'' THEN i.Real_Price END) AS Sum_86 '

		END



	SET @Sql = @Sql + ' FROM tbl_keyword_adinfo2 as a with (nolock) left outer join tbl_keyword_income as i with (nolock) on a.code = i.code  left outer join tbl_keyword_Repay as R With(NoLock)  on a.Code = R.AdCode  left outer join tbl_keyword k With(NoLock)  on a.kwcode = k.kwcode'
	SET @Sql = @Sql + ' WHERE payState = ''y'' and a.goodgubun <> ''4'' '  --원래 이걸로 한다.



	-- 검색날짜 선택
	IF @sDate <> '' AND @eDate <> '' AND @DateField <> ''  --시작일/종료일이 존재하고, 검색필드가 존재할 경우에만 날짜 검색
		BEGIN
			--'SET @Sql = @Sql + ' AND a.startDay BETWEEN '''+@sDate+''' AND '''+@eDate+''''
			SET @sql =  @sql + '  and (CONVERT(varchar(10), a.'+@DateField+', 120) >= '''+@sdate+'''  and Convert(varchar(10), a.'+@DateField+', 120) <= '''+@eDate+''') '
		END

	-- 상품구분
	IF @goodGubun <> ''
		BEGIN
			SET @Sql = @Sql + ' AND a.goodGubun = '''+@goodgubun+''''
		END

	-- 섹션
	IF @kwSection <> ''
		BEGIN
			SET @Sql = @Sql + ' AND k.kwSection = '''+@kwSection+''''
		END

	-- 상품순위
	IF @goodRank <> ''
		BEGIN
			SET @Sql = @Sql + ' AND a.goodRank = '''+@goodRank+''''
		END


	-- 판매경로
	IF @branchType <> ''
	BEGIN
		IF @branchType = '2'
			BEGIN
				SET @Sql = @Sql + ' AND a.branchcode > ''0'' and a.branchCode is not NULL'
			END
		ELSE
			BEGIN
				SET @Sql = @Sql + ' AND a.branchCode is NULL'
			END
	END

	-- 지점


	IF @branchCode <> ''
	BEGIN
		IF @branchCode = '1'
			BEGIN
				SET @Sql = @Sql + ' AND a.branchGubun = ''1'' '
			END
		ELSE IF @branchCode = '2'
			BEGIN
				SET @Sql = @Sql + ' AND a.branchGubun = ''2'' '
			END
		ELSE IF @branchcode ='81'   --강남
			Begin
				SET @Sql = @Sql + ' and (branchCode =''16'' or branchCode =''17'' or branchCode =''18'' or branchCode =''21'' or branchCode =''10''  or branchCode =''81'' )'
			End

		Else IF @branchcode ='82'    --강북
			Begin
				SET @Sql = @Sql + ' and (branchCode =''19'' or branchCode =''20'' or branchCode =''22'' or branchCode =''23'' or branchCode =''82'' )'
			End

		Else IF @branchcode ='83'   --경북
			Begin
				SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='84'   --경남
			Begin
				SET @Sql = @Sql + ' and (branchCode =''25'' or branchCode =''49'' or branchCode =''84'' )'
			End

		Else IF @branchcode ='85'    --서부
			Begin
				SET @Sql = @Sql + ' and (branchCode =''12'' or branchCode =''13'' or branchCode =''14'' or branchCode=''15'' or branchCode=''85'' )'
			End
		Else IF @BranchCode='100'   --회원
			BEGIN
				SET @Sql = @Sql + ' AND Userid<> '''' AND (BranChCode IS NULL OR BranchCode =''''  ) '
			END
		Else IF @BranchCode='200'    -- 등록대행전체
			BEGIN
				SET @Sql = @Sql + ' AND (BranChCode IS NOT  NULL  AND BranchCode <> ''''   ) '
			END
		Else IF @BranchCode='300'    -- 지점(전체)
			BEGIN
				SET @Sql = @Sql + ' AND ( BranchGubun=''1''  ) '
			END
		Else IF @BranchCode='400'    -- 지사 (전체)
			BEGIN
				SET @Sql = @Sql + ' AND (BranChGubun=''2''    ) '
			END
		Else IF @BranchCode='500'    -- 지점사 (전체)
			BEGIN
				SET @Sql = @Sql + ' AND (BranChGubun =''1'' Or BranchGubun =''2'' ) '
			END

		ELSE
			BEGIN
				SET @Sql = @Sql + ' AND a.branchCode = '''+CAST(@branchcode AS VARCHAR(3))+''' '
			END
	END





	-- 수주유형
	IF @isDc <> ''
	BEGIN
		IF @isDc = '1'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc = ''1'' '
			END
		ELSE IF @isDc = '2'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc in (''2'',''3'',''4'',''5'') '
			END
		ELSE IF @isDc = '3'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc in (''6'',''7'',''8'') '
			END
		ELSE IF @isDc = '4'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc = ''6'' '
			END
		ELSE IF @isDc = '5'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc = ''7'' '
			END
		ELSE IF @isDc = '6'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc = ''8'' '
			END
	END
	--기간
	IF @Period <> ''

	BEGIN
		IF @Period ='1'
			BEGIN
				SET  @Sql = @Sql + ' AND Period=''1''  AND GoodGubun=''3''  '
			END
		ELSE IF @Period ='2'
			BEGIN
				SET  @Sql = @Sql + ' AND Period =''2'' AND GoodGubun=''3'' '
			END
		ELSE IF @Period ='3'
			BEGIN
				SET  @Sql = @Sql + ' AND ((Period =''3'' AND GoodGubun=''3'' )  OR (Period =''1'' AND GoodGubun IN (''1'', ''2'') ) ) '
			END
		ELSE IF @Period ='4'
			BEGIN
				SET  @Sql = @Sql + ' AND (Period =''2'' AND GoodGubun IN (''1'', ''2'') ) ) '
			END

		ELSE IF @Period ='5'
			BEGIN
				SET  @Sql = @Sql + ' AND (Period =''3'' AND GoodGubun IN (''1'', ''2'')  ) '
			END

	END


	IF @PayState =''
	BEGIN
		SET  @Sql = @Sql + ' AND PayState=''Y'' OR PayState= ''R''  '
	END
	ELSE
	BEGIN

		SET  @Sql = @Sql + ' AND PayState=''' + @PayState + ''' '
	END

	--검색어
	IF   @sText <> ''
		BEGIN
			SET @Sql = @Sql + ' AND ' + @sSearch + ' = ''' + @sText + ''' '
		END











	set @outparam=@Sql

	 PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_ReportKeywordSaleAdList]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드별 광고 판매수 및 조회수 리스트
	제작자		: 이기운
	제작일		: 2004.04.24
	수정자		: 수정시 필히 말하시오.
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_ReportKeywordSaleAdList]
(
	@key				char(1) = '0',
	@top				int = 0,
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = '',
	@kwSection			char(1) = '',			-- 8:섹션무관, 1:벼룩시장신문, 2:상품직거래, 3:자동차, 4:부동산, 5:구인구직, 6:아르바이트, 7:YP
	@kwGrade			char(1) = '',			-- 0:전체, 1~10등급
	@isDc				char(1) = '',			-- 1: 유료, 2: 무료
	@sort				char(1) = '',			-- 0: 노출순, 1: 클릭순, 2: 키워드순, 3:유료광고순, 4: 무료광고순
	--@kwCode			int	= 0,
	--@sDate				varchar(10) = '',
	--@eDate				varchar(10) = '',
	@outparam			int=0	OUTPUT
)


AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(8000)

	--Set @Sql='SELECT '

	IF @key = '0'
		BEGIN


			SET @Sql = 'select distinct (select count(k.kwcode)  FROM tbl_keyword k) as cnt,
					(select count(code) from tbl_keyword_adinfo2 with (nolock) where (isDC <6)	--  유료
					and
						(
							(datediff(d,startDay,'''+@sDate+''') >= 0 and datediff(d,startDay,'''+@sDate+''')<= 0) or
							(datediff(d,endDay,'''+@eDate+''') <= 0 and datediff(d,endDay,'''+@eDate+''') <= 0))
						) as TotaladdCnt,
				      (select count(code) from tbl_keyword_adinfo2 with (nolock) where (isDC > 5 or  isDC is NULL)	--  무료
					and
						(
							(datediff(d,startDay,'''+@sDate+''') >= 0 and datediff(d,startDay,'''+@sDate+''')<= 0) or
							(datediff(d,endDay,'''+@eDate+''') <= 0 and datediff(d,endDay,'''+@eDate+''') <= 0) )
						) as totalfreeaddcnt'





			--SET @Sql = @Sql + ' count(k.kwcode) as Cnt,sum(dbo.F_ReportAddCnt(k.kwcode, '''+@sDate+''', '''+@eDate+''')) as totaladdCnt'
			--SET @Sql = @Sql + ', sum(dbo.F_ReportFreeAddCnt(k.kwcode, '''+@sDate+''', '''+@eDate+''')) as totalfreeAddCnt'
		END
	ELSE
		BEGIN
			IF @top > 0
			BEGIN
				SET @Sql = 'Select  top '+Cast(@top as varchar)+' '
			END
			SET @Sql = @Sql + ' k.kwCode,kwName,dbo.F_Section(kwSection) as kwSection,kwGrade'
			SET @Sql = @Sql + ',dbo.F_ReportAddCnt(k.kwcode, '''+@sDate+''', '''+@eDate+''') as addCnt'
			SET @Sql = @Sql + ',dbo.F_ReportFreeAddCnt(k.kwcode, '''+@sDate+''', '''+@eDate+''') as freeAddCnt'
			SET @Sql = @Sql + ',dbo.F_ReportSumCnt(k.kwcode, '''+@sDate+''', '''+@eDate+''',''r'') as readTCnt'
			SET @Sql = @Sql + ',dbo.F_ReportSumCnt(k.kwcode, '''+@sDate+''', '''+@eDate+''',''c'') as clickCnt'
		END

	SET @Sql = @Sql + ' FROM tbl_keyword as k with (nolock)'

	IF @isDC <> ''
	BEGIN
		SET @Sql = @Sql + 'RIGHT OUTER JOIN (select distinct kwcode from tbl_keyword_adinfo2 with (nolock) WHERE 1=1'
		--  유료이거나 무료일때
		--IF @isDC <> ''
		IF @isDC = '1' or @isDC = '2'
		BEGIN
			SET @Sql = @Sql + 'AND (datediff(d,startDay,'''+@sDate+''') >= 0 and datediff(d,startDay,'''+@eDate+''')<= 0) or  (datediff(d,endDay,'''+@sDate+''') <= 0 and datediff(d,endDay,'''+@eDate+''') <= 0)'
		END
		--  유료
		IF @isDC = '1'
		BEGIN
			SET @Sql = @Sql + 'AND isDC < 6'
		END
		--  무료
		IF @isDC = '2'
		BEGIN
			SET @Sql = @Sql + 'AND (isDC > 5 or  isDC is NULL)'
		END

		SET @Sql = @Sql + ') as a ON k.kwCode = a.kwCode'
	END

	SET @Sql = @Sql + ' WHERE 1=1'

	-- 섹션
	IF @kwSection <> ''
		BEGIN
			SET @Sql = @Sql + ' AND kwSection = '''+@kwSection+''''
		END

	-- 등급
	IF @kwGrade <> ''
		BEGIN
			SET @Sql = @Sql + ' AND kwGrade = '''+@kwGrade+''''
		END



	-- 정렬======================================================================================================================
	IF @key <> '0'
		BEGIN
		IF @sort = '0'
			BEGIN
				SET @Sql = @Sql + ' ORDER BY readCnt DESC'
			END
		ELSE IF @sort = '1'
			BEGIN
				SET @Sql = @Sql + ' ORDER BY clickCnt DESC'
			END
		ELSE IF @sort = '2'
			BEGIN
				SET @Sql = @Sql + ' ORDER BY kwname'
			END
		ELSE IF @sort = '3'
			BEGIN
				SET @Sql = @Sql + ' ORDER BY addCnt DESC'
			END
		ELSE
			BEGIN
				SET @Sql = @Sql + ' ORDER BY freeAddCnt DESC'
			END
	END
	 PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_ReportSaleAdList]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고 판매 리스트
	제작자		: 이기운
	제작일		: 2004.04.14
	수정자		: 고병호
	수정일		:
	파라미터

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_ReportSaleAdList]
(
	@key				char(1) = '0',
	@top				int = 0,
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = '',
	@goodGubun			char(1) = '',
	@goodRank			char(1) = '',
	@kwSection			char(1) = '8',		-- 8:섹션무관, 1:벼룩시장신문, 2:상품직거래, 3:자동차, 4:부동산, 5:구인구직, 6:아르바이트, 7:YP
	@branchCode			tinyint = '0',		-- 0:전체,1:지점, 2:지사, 10이상: 지점및지사코드
	@branchType			char(1) = '0',		-- 0:전체, 1:온라인, 2:등록대행
	@isDc				char(1) = '',
	@outparam			varchar(2000)=0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql		varchar(1000)

	Set @Sql='SELECT '

	IF @key = '0'
		BEGIN
			SET @Sql = @Sql + ' count(a.code), sum(Case When a.branchcode > ''0'' and a.branchcode <> NULL Then i.real_Price Else a.originPrice End)  '
		END
	ELSE
		BEGIN
			SET @Sql = @Sql + ' top '+Cast(@top as varchar)+' '
			SET @Sql = @Sql + ' a.code, k.kwName, k.kwSection, k.kwGrade, a.goodGubun, a.goodRank, '
			SET @Sql = @Sql + ' a.branchCode, isNULL(a.isDC,''1'') isDC, a.id, '
			SET @Sql = @Sql + ' a.regDate, '
			SET @Sql = @Sql + ' isNULL(isService,0) isService, price = Case When a.branchcode > ''0'' and a.branchcode <> NULL Then i.real_Price Else a.originPrice End ,a.startDay'

		END

	SET @Sql = @Sql + ' FROM tbl_keyword_adinfo2 as a with (nolock) left outer join tbl_keyword_income as i with (nolock) on a.code = i.code left outer join tbl_keyword k on a.kwcode = k.kwcode'
	SET @Sql = @Sql + ' WHERE payState = ''y'' and a.goodgubun <> ''4'' '  --원래 이걸로 한다.



	-- 검색날짜 선택
	IF @sDate <> '' AND @eDate <> ''
		BEGIN
		--	'SET @Sql = @Sql + ' AND a.startDay BETWEEN '''+@sDate+''' AND '''+@eDate+''''
			SET @sql =  @sql + '  and (CONVERT(varchar(10), a.regDate, 120) >= '''+@sdate+''' and Convert(varchar(10), a.regDate, 120) <= '''+@eDate+''') '
		END

	-- 상품구분
	IF @goodGubun <> ''
		BEGIN
			SET @Sql = @Sql + ' AND a.goodGubun = '''+@goodgubun+''''
		END

	-- 섹션
	IF @kwSection <> ''
		BEGIN
			SET @Sql = @Sql + ' AND k.kwSection = '''+@kwSection+''''
		END

	-- 상품순위
	IF @goodRank <> ''
		BEGIN
			SET @Sql = @Sql + ' AND a.goodRank = '''+@goodRank+''''
		END


	-- 판매경로
	IF @branchType <> ''
	BEGIN
		IF @branchType = '2'
			BEGIN
				SET @Sql = @Sql + ' AND a.branchcode > ''0'' and a.branchcode is not NULL'
			END
		ELSE
			BEGIN
				SET @Sql = @Sql + ' AND a.branchcode is NULL'
			END
	END

	-- 지점

	IF @branchCode <> ''
	BEGIN
		IF @branchCode = '1'
			BEGIN
				SET @Sql = @Sql + ' AND a.branchGubun = ''1'' '
			END
		ELSE IF @branchCode = '2'
			BEGIN
				SET @Sql = @Sql + ' AND a.branchGubun = ''2'' '
			END
		ELSE IF @branchcode ='81'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''16'' or branchCode =''17'' or branchCode =''18'' or branchCode =''21'' or branchCode =''10''  or branchCode =''81'' )'
			End

		Else IF @branchcode ='82'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''19'' or branchCode =''20'' or branchCode =''22'' or branchCode =''23'' or branchCode =''82'' )'
			End

		Else IF @branchcode ='83'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='84'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''25'' or branchCode =''49'' or branchCode =''84'' )'
			End

		Else IF @branchcode ='85'
			Begin
				SET @Sql = @Sql + ' and (branchCode =''12'' or branchCode =''13'' or branchCode =''14'' or branchCode=''15'' or branchCode=''85'' )'
			End
		ELSE
			BEGIN
				SET @Sql = @Sql + ' AND a.branchCode = '''+CAST(@branchcode AS VARCHAR(3))+''' '
			END
	END


	-- 수주유형
	IF @isDc <> ''
	BEGIN
		IF @isDc = '1'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc = ''1'' '
			END
		ELSE IF @isDc = '2'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc in (''2'',''3'',''4'',''5'') '
			END
		ELSE IF @isDc = '3'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc in (''6'',''7'',''8'') '
			END
		ELSE IF @isDc = '4'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc = ''6'' '
			END
		ELSE IF @isDc = '5'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc = ''7'' '
			END
		ELSE IF @isDc = '6'
			BEGIN
				SET @Sql = @Sql + ' AND a.isDc = ''8'' '
			END
	END

	IF @key = '1'
		BEGIN
			SET @Sql = @Sql + ' ORDER BY a.kwname, a.goodGubun, a.goodRank'
		END

	set @outparam=@Sql

	 PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_ReportSaleAdList_New]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고 판매 리스트
	제작자		: 이기운
	제작일		: 2004.04.14
	수정자		: 박준희
	수정일		:
	파라미터
sp_ReportSaleAdList_New '1','28','','2004-08-09','2004-08-16','','','','0','',''
use keywordshop

******************************************************************************/


CREATE PROCEDURE [dbo].[sp_ReportSaleAdList_New]
(

	@top				int = 0,
	@DateField			varchar(20) = '',
	@Period				varchar(15) = '',
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = '',
	@goodGubun			char(1) = '',
	@goodRank			char(1) = '',
	@kwSection			char(1) = '8',		-- 8:섹션무관, 1:벼룩시장신문, 2:상품직거래, 3:자동차, 4:부동산, 5:구인구직, 6:아르바이트, 7:YP
	@branchCode			int = 0 ,		-- 0:전체,1:지점, 2:지사, 10이상: 지점및지사코드
	@branchType			char(1) = '0',		-- 0:전체, 1:온라인, 2:등록대행
	@isDc				char(1) = '',
	@PayState			char(1) = '',
	@sSearch			varchar(15)='' ,
	@sText				varchar(15)='' ,
	@outparam			varchar(2000)='0'	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN
	DECLARE @Sql	varchar(6000)
	DECLARE @CountSql	varchar(500)   --데이터의 카운팅
	DECLARE @ListSql	varchar(500)   --데이터리스트
	DECLARE @SumSql	varchar(3500) -- 합계 통계
	DECLARE @FromSql	varchar(500) 	--From
	DECLARE @WhereSql      	varchar(1000)     --Where절 이하 Sql


	Set @Sql=''
	SET @CountSql = ''
	SET @ListSql	=''
	SET @SumSql 	=''
	SET @FromSql 	=''
	SET @WhereSql = ''



			SET @CountSql = @CountSql + 'SELECT  count(a.code), sum(a.OriginPrice) as OriginPriceTot , sum(Case When a.branchcode > ''0'' and a.branchcode <> NULL Then i.real_Price Else a.originPrice End) AS Real_PriceTot   '



			SET @ListSql = @ListSql + ' SELECT top '+Cast(@top as varchar)+' '
			SET @ListSql = @ListSql + ' a.code,  k.kwName, k.kwSection, k.kwGrade, a.goodGubun, a.goodRank, '
			SET @ListSql = @ListSql + ' a.branchCode, isNULL(a.isDC,''1'') isDC, a.id,a.PayMethod, a.PayKind,  a.PayDate,a.PayState,a.Period,  a.StartDay , a.EndDay ,'
			SET @ListSql = @ListSql + ' a.regDate, a.OriginPrice ,i.Real_Price , R.RepayMoney , '
			SET @ListSql = @ListSql + ' isNULL(isService,0) isService, price = Case When a.branchcode > ''0'' and a.branchcode <> NULL Then i.real_Price Else a.originPrice End ,a.startDay'

			--회원 통계
			SET @SumSql = @SumSql + 'SELECT Count(Case When a.branchcode = ''0'' Or  a.branchcode Is NULL Then a.Code  End) AS Cnt_Member  , '+
						  ' sum(Case When a.branchcode = ''0'' Or  a.branchcode Is NULL Then a.OriginPrice  End) AS Sum_Member_OriginPrice  , '+
						  ' sum(Case When a.branchcode = ''0'' Or  a.branchcode Is NULL Then a.OriginPrice  End) AS Sum_Member_RealPrice  , ' +
						  ' Count(Case When a.PayState = ''R''  AND (a.branchcode = ''0'' Or  a.branchcode Is NULL)   Then a.Code  End) AS Cnt_Member_Repay ,'+
						  ' sum(Case When a.PayState = ''R'' AND  ( A.branchCode=''0'' OR A.branchcode Is NULL) Then R.RepayMoney  End) AS Sum_Member_RepayPrice ,  '
			--80   인본
			SET @SumSql = @SumSql + 'Count(Case When a.branchcode = ''80''  Then a.Code  End) AS Cnt_80  ,  '+
						  ' sum(Case When a.branchcode = ''80''   Then a.OriginPrice  End) AS Sum_80_OriginPrice  , '+
						  ' sum(Case When a.branchcode = ''80''  Then i.Real_Price  End) AS Sum_80_RealPrice  , '+
						  ' Count(Case When a.PayState = ''R''  AND (a.branchcode = ''80'' )   Then a.Code  End) AS Cnt_80_Repay , '+
						  ' sum(Case When a.PayState = ''R'' AND  ( A.branchCode=''80'' ) Then R.RepayMoney  End) AS Sum_80_RepayPrice , '
			--86   인본_ TM
			SET @SumSql = @SumSql + 'Count(Case When a.branchcode = ''86''  Then a.Code  End) AS Cnt_86  ,'+
						  'sum(Case When a.branchcode = ''86''   Then a.OriginPrice  End) AS Sum_86_OriginPrice  , sum(Case When a.branchcode = ''86''  Then i.Real_Price  End) AS Sum_86_RealPrice   , Count(Case When a.PayState = ''R''  AND (a.branchcode = ''86'' )   Then a.Code  End) AS Cnt_86_Repay , sum(Case When a.PayState = ''R'' AND  ( A.branchCode=''86'' ) Then R.RepayMoney  End) AS Sum_86_RepayPrice , '

			--지점 (회원도 인본도  인본 TM도  아닌 것)
			SET @SumSql = @SumSql + ' Count(CASE WHEN  ( a.branchCode <> ''80'' AND a.branchCode <> ''86''  AND a.branchCode<>''0'' AND a.branchCode is Not NULL)  THEN a.Code  END ) AS Cnt_Branch , Sum (CASE WHEN  ( a.branchCode <> ''80'' AND a.branchCode <> ''86''  AND a.branchCode<>''0'' AND a.branchCode is Not NULL)  THEN a.OriginPrice END ) AS Sum_Branch_OriginPrice , Sum (CASE WHEN  ( a.branchCode <> ''80'' AND a.branchCode <> ''86''  AND a.branchCode<>''0'' AND a.branchCode is Not NULL)  THEN i.Real_Price END ) AS Sum_Branch_RealPrice, Count(Case When a.PayState = ''R''  AND (a.branchcode <> ''80'' AND a.branchCode<> ''86'' AND a.BranchCode <> ''0'' AND a.BranchCode is Not NULL  )   Then a.Code  End) AS Cnt_Branch_Repay , sum(Case When a.PayState = ''R'' AND  ( A.branchCode<>''80'' AND A.BranchCode <>''86'' AND A.BranchCode<>''0'' AND A.BranchCode Is Not NULL  ) Then R.RepayMoney  End) AS Sum_Branch_RepayPrice ,  '
			--금일 매출 통계
			SET @SumSql = @SumSql + ' Count(CASE WHEN  ( Convert(varchar(10) , a.PayDate , 120) = Convert(varchar(10) , getDate() , 120) ) THEN a.Code  END ) AS Cnt_Today , Sum (CASE WHEN  ( Convert(varchar(10) , a.PayDate , 120) = Convert(varchar(10) , getDate() , 120) )  THEN  a.OriginPrice END ) AS Sum_Today_OriginPrice , Sum (CASE WHEN  ( Convert(varchar(10) , a.PayDate , 120) = Convert(varchar(10) , getDate() , 120) )   THEN i.Real_Price END ) AS Sum_Today_RealPrice ,Count  (CASE WHEN  ( A.PayState=''R'' AND  Convert(varchar(10) , a.PayDate , 120) = Convert(varchar(10) , getDate() , 120)  ) THEN a.Code  END ) AS Cnt_Today_Repay , Sum (CASE WHEN  ( A.PayState=''R'' AND Convert(varchar(10) , a.PayDate , 120) = Convert(varchar(10) , getDate() , 120) )   THEN R.RepayMoney END ) AS Sum_Today_RepayPrice  '






	SET @FromSql = @FromSql + ' FROM tbl_keyword_adinfo2 as a with (nolock) left outer join tbl_keyword_income as i with (nolock) on a.code = i.code  left outer join tbl_keyword_Repay  as R   With(NoLock)  on a.Code = R.AdCode  left outer join tbl_keyword k With(NoLock)  on a.kwcode = k.kwcode'
	SET @FromSql = @FromSql + ' WHERE (payState = ''y'' OR PayState = ''R'' )  and a.goodgubun <> ''4'' '  --원래 이걸로 한다.



	-- 검색날짜 선택
	IF @sDate <> '' AND @eDate <> '' AND @DateField <> ''  --시작일/종료일이 존재하고, 검색필드가 존재할 경우에만 날짜 검색
		BEGIN
			--'SET @Sql = @Sql + ' AND a.startDay BETWEEN '''+@sDate+''' AND '''+@eDate+''''
			SET @WhereSql =  @WhereSql + '  and (CONVERT(varchar(10), a.'+@DateField+', 120) >= '''+@sdate+'''  and Convert(varchar(10), a.'+@DateField+', 120) <= '''+@eDate+''') '
		END

	-- 상품구분
	IF @goodGubun <> ''
		BEGIN
			SET @WhereSql = @WhereSql + ' AND a.goodGubun = '''+@goodgubun+''''
		END

	-- 섹션
	IF @kwSection <> ''
		BEGIN
			SET @WhereSql = @WhereSql + ' AND k.kwSection = '''+@kwSection+''''
		END

	-- 상품순위
	IF @goodRank <> ''
		BEGIN
			SET @WhereSql = @WhereSql + ' AND a.goodRank = '''+@goodRank+''''
		END


	-- 판매경로
	IF @branchType <> ''
	BEGIN
		IF @branchType = '2'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.branchcode > ''0'' and a.branchCode is not NULL'
			END
		ELSE
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.branchCode is NULL'
			END
	END

	-- 지점


	IF @branchCode <> ''
	BEGIN
		IF @branchCode = '1'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.branchGubun = ''1'' '
			END
		ELSE IF @branchCode = '2'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.branchGubun = ''2'' '
			END
		ELSE IF @branchcode ='81'   --강남
			Begin
				SET @WhereSql = @WhereSql + ' and (branchCode =''16'' or branchCode =''17'' or branchCode =''18'' or branchCode =''21'' or branchCode =''10''  or branchCode =''81'' )'
			End

		Else IF @branchcode ='82'    --강북
			Begin
				SET @WhereSql = @WhereSql + ' and (branchCode =''19'' or branchCode =''20'' or branchCode =''22'' or branchCode =''23'' or branchCode =''82'' )'
			End

		Else IF @branchcode ='83'   --경북
			Begin
				SET @WhereSql = @WhereSql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
			End

		Else IF @branchcode ='84'   --경남
			Begin
				SET @WhereSql = @WhereSql + ' and (branchCode =''25'' or branchCode =''49'' or branchCode =''84'' )'
			End

		Else IF @branchcode ='85'    --서부
			Begin
				SET @WhereSql = @WhereSql + ' and (branchCode =''12'' or branchCode =''13'' or branchCode =''14'' or branchCode=''15'' or branchCode=''85'' )'
			End
		Else IF @BranchCode='100'   --회원
			BEGIN
				SET @WhereSql = @WhereSql + ' AND Userid<> '''' AND (BranChCode IS NULL OR BranchCode =''''  ) '
			END
		Else IF @BranchCode='200'    -- 등록대행전체
			BEGIN
				SET @WhereSql = @WhereSql + ' AND (BranChCode IS NOT  NULL  AND BranchCode <> ''''   ) '
			END
		Else IF @BranchCode='300'    -- 지점(전체)
			BEGIN
				SET @WhereSql = @WhereSql + ' AND ( BranchGubun=''1''  ) '
			END
		Else IF @BranchCode='400'    -- 지사 (전체)
			BEGIN
				SET @WhereSql = @WhereSql + ' AND (BranChGubun=''2''    ) '
			END
		Else IF @BranchCode='500'    -- 지점사 (전체)
			BEGIN
				SET @WhereSql = @WhereSql + ' AND (BranChGubun =''1'' Or BranchGubun =''2'' ) '
			END

		ELSE
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.branchCode = '''+CAST(@branchcode AS VARCHAR(3))+''' '
			END
	END



	-- 수주유형
	IF @isDc <> ''
	BEGIN
		IF @isDc = '1'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc = ''1'' '
			END
		ELSE IF @isDc = '2'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc in (''2'',''3'',''4'',''5'') '
			END
		ELSE IF @isDc = '3'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc in (''6'',''7'',''8'') '
			END
		ELSE IF @isDc = '4'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc = ''6'' '
			END
		ELSE IF @isDc = '5'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc = ''7'' '
			END
		ELSE IF @isDc = '6'
			BEGIN
				SET @WhereSql = @WhereSql + ' AND a.isDc = ''8'' '
			END
	END
	--기간
	IF @Period <> ''

	BEGIN
		IF @Period ='1'
			BEGIN
				SET  @WhereSql = @WhereSql + ' AND Period=''1''  AND GoodGubun=''3''  '
			END
		ELSE IF @Period ='2'
			BEGIN
				SET  @WhereSql = @WhereSql + ' AND Period =''2'' AND GoodGubun=''3'' '
			END
		ELSE IF @Period ='3'
			BEGIN
				SET  @WhereSql = @WhereSql + ' AND ((Period =''3'' AND GoodGubun=''3'' )  OR (Period =''1'' AND GoodGubun IN (''1'', ''2'') ) ) '
			END
		ELSE IF @Period ='4'
			BEGIN
				SET  @WhereSql = @WhereSql + ' AND (Period =''2'' AND GoodGubun IN (''1'', ''2'') ) ) '
			END

		ELSE IF @Period ='5'
			BEGIN
				SET  @WhereSql = @WhereSql + ' AND (Period =''3'' AND GoodGubun IN (''1'', ''2'')  ) '
			END

	END


	--결제 완료 / 환불
	IF @PayState =''
		BEGIN
			SET  @WhereSql = @WhereSql + ' AND PayState=''Y'' OR PayState= ''R''  '
		END
	ELSE
		BEGIN

			SET  @WhereSql = @WhereSql + ' AND PayState=''' + @PayState + ''' '
		END

	--검색어
	IF @sSearch <> ''  AND  @sText <> ''
		BEGIN
			SET @WhereSql = @WhereSql + ' AND ' + @sSearch + ' = ''' + @sText + ''' '
		END



	SET @Sql = @CountSql + @FromSql + @WhereSql +';'+ @ListSql+@FromSql + @WhereSql 	+ ' ORDER BY a.kwname, a.goodGubun, a.goodRank  ; ' +
		     @SumSql +@FromSql + @WhereSql



	set @outparam=@Sql

	 PRINT @Sql
	EXECUTE(@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_sale_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_sale_list_01]

	@gotopage		int = 1
	,@sText			varchar(20)
	,@sSearch		varchar(20)
	,@toppage		int = 1
	,@check_cnt		char(1) = '1'
	,@skWgrade		varchar(2) = ''
	,@sgoodRank		char(1) = ''

AS
	SET NOCOUNT ON
	DECLARE
	@Sql		varchar(1000)

	if @check_cnt = '0'
		begin
			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' k.kwname, k.kwgrade '
		end
	else
		begin
			SET @Sql = 'select count(*) from (select count(k.kwname) as cnt  '
		end


	SET @Sql = @Sql + ' from tbl_keyword k with (NOLOCK) '
	SET @Sql = @Sql + ' INNER JOIN tbl_keyword_adinfo a ON k.kwcode = a.kwcode '

------------------------------------------------------------------------------------------------------------------------

	SET @Sql = @Sql + '	where a.adState = ''y'' '

	if @skWgrade <> ''
		begin
			SET @Sql = @Sql + '	and kwGrade = '''+@skWgrade+''' '
		end

	if @sGoodRank <> ''
		begin
			SET @Sql = @Sql + '	and a.goodRank = '''+@sgoodRank+''' '
		end

	if @sSearch <> '' and @sText <> ''
		begin
			SET @Sql = @Sql + ' and '''+@sSearch+''' like ''%'+@sText+'%'' '
		end

--//----------------------------------------------------------------------------------------------------------------
	if @check_cnt = '0'
		begin
			SET @Sql = @Sql + ' group by k.kwname, k.kwgrade '
			SET @Sql = @Sql + ' order by k.kwname desc '
		end
	else
		begin
			SET @Sql = @Sql + ' group by k.kwname, k.kwgrade) a '
		end

	EXECUTE(@sql)
GO
/****** Object:  StoredProcedure [dbo].[sp_sale_list_in]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_sale_list_in]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/

	@goodgubun	int	= 1
	,@kwName		varchar(20)
	,@i			int = 0

AS
	 SET NOCOUNT ON
	DECLARE
		@Sql		varchar(1000)

	SET @Sql = 'select top 1 a.goodRank '
	SET @Sql = @Sql + '	from tbl_keyword_adinfo a '
	SET @Sql = @Sql + '	INNER JOIN tbl_keyword w ON a.kwcode = w.kwcode  '
	SET @Sql = @Sql + '	where a.goodGubun = '''+Cast(@goodgubun as varchar)+''' and adState = ''Y'' and a.kwname = '''+@kwName+''' '--and w.kwGrade = '''+Cast(@kwGrade as varchar)+''' '
	SET @Sql = @Sql + '	and a.goodRank = '''+Cast(@i as varchar)+''' '

	EXECUTE(@sql)
GO
/****** Object:  StoredProcedure [dbo].[sp_Section_BizManList]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 비즈맨 키워드 검색 및 광고 검사
	제작자		: 박준희
	제작일		: 2005.01.19
	수정자		: 박준희
	수정일		: 2005.01.20
	수정내용	: 각 섹션별 비즈맨 키워드 노출 데이터 출력
	파라미터              :
use keywordshop
******************************************************************************/

CREATE PROCEDURE  [dbo].[sp_Section_BizManList]
--(
	--@SectionGbn	tinyint		= 0,
	--@outprm		int 		= 0
--)


AS
SET NOCOUNT ON
BEGIN




	SELECT SectionGbn, kwName , TextLink, TextLink2  FROM tbl_BizMan_adinfo With (NoLock)
	WHERE
	adState = 'Y'
	AND (TextLink IS NOT NULL OR TextLink2 IS NOT NULL )
	AND (TextLink <> ''  OR TextLink2 <> '')
	AND SectionGbn IS NOT NULL
	AND SectionGbn <> 99    --섹션구분이 없음이 99 , 0은 파인드올
	ORDER BY SectionGbn, RegDate ASC










END
GO
/****** Object:  StoredProcedure [dbo].[sp_Section_RecmAdList]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 텍스트이미지 키워드 리스트(섹션메인 노출용)
	제작자		: 박준희
	제작일		: 2005.01.24
	수정자		: 박준희
	수정일		: 2005.01.24
	수정내용	: 각 섹션별 텍스트이미지 키워드 노출 데이터 출력
	파라미터              :

use keywordshop
******************************************************************************/

CREATE PROCEDURE  [dbo].[sp_Section_RecmAdList]
--(
	@SectionGbn	tinyint		= 9
	--@outprm		int 		= 0
--)


AS
SET NOCOUNT ON
BEGIN



	Declare @Sql varchar(1000)
	SET @Sql='Select  Idx , SiteGbn,AdUrl,AdImg,Target,PopWidth,PopHeight,Cont1,Cont2 '+
		   ' From  ' +
		   ' dbo.tbl_RecmAd With(NoLock) '+
		   ' Where AdStatus=''Y'' '+
		   ' AND AdStartDay <= GetDate() '+
		   ' AND AdEndDay >=GetDate() '
	IF @SectionGbn <> 9
	BEGIN
		  	SET @Sql	=	@Sql + ' AND SiteGbn='+Convert(varchar(10), @SectionGbn	)
	END

	SET @Sql = @Sql + ' Order By SiteGbn , Rank '

	Execute (@Sql)




END
GO
/****** Object:  StoredProcedure [dbo].[sp_Section_TextImgKwdList]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 텍스트이미지 키워드 리스트(섹션메인 노출용)
	제작자		: 박준희
	제작일		: 2005.01.24
	수정자		: 박준희
	수정일		: 2005.01.24
	수정내용	: 각 섹션별 텍스트이미지 키워드 노출 데이터 출력
	파라미터              :

use keywordshop
******************************************************************************/

CREATE PROCEDURE  [dbo].[sp_Section_TextImgKwdList]
--(
	--@SectionGbn	tinyint		= 0,
	--@outprm		int 		= 0
--)


AS
SET NOCOUNT ON
BEGIN




	Select  Idx , SiteGbn,AdUrl,TextImg,Target,PopWidth,PopHeight
	From
	dbo.tbl_TextImgKwd With(NoLock)
	Where AdStatus='Y'
	AND AdStartDay <= GetDate()
	AND AdEndDay >=GetDate()
	Order By SiteGbn





END




select * From tbl_TextImgKwd where idx=144

begin tran
UPdate tbl_TextImgKwd
set AdStatus='Y'
where idx=144

Commit



select Top 10 * From dbo.tbl_keyword_adinfo WHere Code=9068
GO
/****** Object:  StoredProcedure [dbo].[sp_sessionTime]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 세션 30분 카운터
	제작자		: 정윤정
	제작일		: 2004.03.30
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE PROC [dbo].[sp_sessionTime]
@idx int
AS
BEGIN
	DECLARE @kwCode int
	DECLARE @endDate datetime

	SELECT @kwCode = isNull(kwCode, 0), @endDate = DATEADD (minute , 30, startTime) FROM tbl_session WITH (NOLOCK) WHERE idx = @idx

	IF @kwCode = 0
		BEGIN
			SELECT ''  as 'todayYear',
			''  as 'todayMonth',
			''  as 'todayDay',
			''  as 'todayHour',
			''  as 'todayMinute',
			''  as 'todaySecond',
			''  as 'endYear',
			''  as 'endMonth',
			''  as 'endDay',
			''  as 'endHour',
			'' as 'endMinute',
			''  as 'endSecond'
		END
	ELSE
		BEGIN
			SELECT DATEPART (year , getdate())  as 'todayYear',
			DATEPART (month , getdate())  as 'todayMonth',
			DATEPART (day , getdate())  as 'todayDay',
			DATEPART (hour , getdate())  as 'todayHour',
			DATEPART (minute , getdate())  as 'todayMinute',
			DATEPART (second , getdate())  as 'todaySecond',
			DATEPART (year , @endDate)  as 'endYear',
			DATEPART (month , @endDate)  as 'endMonth',
			DATEPART (day , @endDate)  as 'endDay',
			DATEPART (hour , @endDate)  as 'endHour',
			DATEPART (minute , @endDate)  as 'endMinute',
			DATEPART (second , @endDate)  as 'endSecond'
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SimilarkwName]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 유의키워드 조회
	제작자		: 이기운
	제작일		: 2004.04.5
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROCEDURE [dbo].[sp_SimilarkwName]
(
	@kwCode		int = 0,
	@output			int = 0	OUTPUT
)



AS
SET NOCOUNT ON
BEGIN

	SELECT similarkwName FROM  tbl_Similarkw  WITH (NOLOCK)  WHERE kwcode = @kwCode

END
GO
/****** Object:  StoredProcedure [dbo].[sp_taxpaper_detail]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 세금계산서 상세보기
	제작자		: 고병호
	제작일		: 2004.03.25
	수정자		:
	수정일		:
	파라미터
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_taxpaper_detail]
	@idx	int = 1
AS
	SET NOCOUNT ON
	BEGIN
		select top 1 userid,company,compnum,compaddr,username,comptype,comppart,master,phone,cell,email,regdate,checkdate,state	from tbl_tax with (NOLOCK) where idx = @idx
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_taxpaper_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 세금계산서 리스트
	제작자		: 고병호
	제작일		: 2004.04.02
	수정자		:
	수정일		:
	파라미터

******************************************************************************/
CREATE PROCEDURE [dbo].[sp_taxpaper_list_01]

	@sYY			char(4) = ''
	,@sMM			char(2) = ''
	,@sDD			char(2) = ''
	,@eYY			char(4) = ''
	,@eMM			char(2) = ''
	,@eDD			char(2) = ''
	,@s_date		char(10) = ''
	,@e_date		char(10) = ''
	,@gotopage		int = 0
	,@DateSearch	varchar(10) = ''
	,@sState		varchar(10) = ''
	,@sText			varchar(30)	= ''
	,@sSearch		varchar(10) = ''
	,@toppage		int = 1
	,@check_cnt		int = 1

AS
SET NOCOUNT ON
BEGIN
	DECLARE
		@Sql		varchar(1000)



	if @check_cnt = '1'
		begin
			SET @Sql = 'select count(idx) from tbl_tax with (noLock)  '
		end
	else
		begin
			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' * from tbl_tax with (noLock)  '
		end

-------------------------------------------------------------------------------------------------------------------------


	SET @Sql = @Sql + ' where idx <> '''' '


	if @sState <> ''			-- 상태에 따른 찾기
		begin
			SET @Sql = @Sql + ' and state = '''+@sState+''' '
		end

	if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
		begin
			SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
		end


	if @s_date <> '' and @e_date <> ''
		begin
			if @DateSearch  = 'regdate'
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), regdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end
			else
				begin
					if @s_date <> '' and @e_date <> ''
					begin
						SET @sql = @sql + ' and CONVERT(varchar(10), checkdate,120) >= '''+@s_Date+''' '
						SET @sql = @sql + ' and CONVERT(varchar(10), checkdate,120) <= '''+@e_Date+''' '
					end
				else
					begin
						if @s_date <> '' and @e_date = ''
							begin
								SET @sql = @sql + ' and CONVERT(varchar(10), checkdate,120) >= '''+@s_Date+''' '
							end
						else
							begin
								if @s_date = '' and @e_date = ''
									begin
										SET @sql = @sql + ' '
									end
								else
									begin
										SET @sql = @sql + ' and CONVERT(varchar(10), checkdate,120) <= '''+@e_Date+''' '
									end
							end
					end
				end

		end

--// -----------------------------------------------------------------------------------------------------------------
	if @check_cnt = '0'
		begin
			SET @Sql = @Sql +' order by idx desc'
		end

	EXECUTE(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[sp_taxpaper_list_action]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 세금계산서 actio 프로그램
	제작자		: 고병호
	제작일		: 2004.03.25
	수정자		:
	수정일		:
	파라미터
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_taxpaper_list_action]
	@idx	int = 1
AS
	SET NOCOUNT ON
	BEGIN
		update tbl_tax set  checkdate = getdate(), state = '1' where idx = @idx
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_TextImgKwdClickCntPlus]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 텍스트이미지광고  클릭수 증가
	제작자		: 박준희
	제작일		: 2005.01.25
	수정자		:
	수정일		:
	수정내용	:
	파라미터 :고유키 Idx
use keywordshop

******************************************************************************/

CREATE PROC [dbo].[sp_TextImgKwdClickCntPlus]
@Idx int

AS
SET NOCOUNT ON
	BEGIN
		UPDATE tbl_TextImgKwd SET clickCnt = clickCnt + 1 WHERE Idx = @Idx

	END
GO
/****** Object:  StoredProcedure [dbo].[sp_txt_edit_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 텍스트이미지관리 수정
	제작자		: 정윤정
	제작일		: 2005.01.24
	수정자		:
	수정일		:
	파라미터
use keywordshop
******************************************************************************/


CREATE PROCEDURE [dbo].[sp_txt_edit_01]

	@idx		int = 0
AS
	SET NOCOUNT ON

	DECLARE @Sql		varchar(1000)


	SET @Sql = 'select top 1 '
	SET @Sql = @Sql + ' idx, SiteGbn, OwnerName, AdStartDay, AdEndDay, AdStatus, AdUrl, '
	SET @Sql = @Sql + ' TextImg, Target, PopWidth, PopHeight, Note, ClickCnt, RegDate, ModDate from tbl_TextImgKwd '
	SET @Sql = @Sql + ' where idx = '''+CAST(@idx AS varCHAR(5)) + ''' '
	--print(@sql)

	Execute(@sql)
GO
/****** Object:  StoredProcedure [dbo].[sp_txt_list_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 텍스트이미지관리 리스트
	제작자		: 정윤정
	제작일		: 2005.01.24
	수정자		:
	수정일		:
	파라미터
use keywordshop_test3
select distinct adstatus  from tbl_textimgKwd
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_txt_list_02]
	@gotopage		int = 0
	,@sSiteGbn		varchar(1) 	= ''
	,@sAdStatus		varchar(1)	= ''
	,@sText			varchar(30)	= ''
	,@sSearch		varchar(10)	= ''
	,@toppage		int = 1
	,@check_cnt		int = 1
AS
	SET NOCOUNT ON

	BEGIN
		DECLARE @Sql varchar(1000)

		if @check_cnt = '1'
		begin
			SET @Sql = 'select count(idx) from tbl_TextImgKwd with (noLock)  '
		end
		else
		begin

			SET @Sql = 'select top '+Cast(@toppage as Varchar)+' '
			SET @Sql = @sql + ' idx, SiteGbn, OwnerName, adStartDay, adEndDay, adStatus, target, ClickCnt, regDate '
			SET @Sql = @sql + ' from tbl_TextImgKwd with (noLock) '
		end


		SET @Sql = @Sql + ' where idx <> '''' '

		IF @sSiteGbn <> ''
		BEGIN
			SET @Sql = @Sql + ' and SiteGbn = ' + @sSiteGbn
		END

		--디폴트 광고 상태 마감 제외
		IF @sAdStatus =''
		BEGIN
			SET @Sql = @Sql + ' and AdStatus <> ''E'' '
		END
		-- 광고 상태 전체도 아니고 특정 상태인 경우에 따라
		IF @sAdStatus <> 'A'  AND @sAdStatus<>''
		BEGIN
			SET @Sql = @Sql + ' and AdStatus= ''' + @sAdStatus + ''''
		END


		if @sSearch <> '' and @sText <> ''		-- 검색어 선택에 따른 찾기
		begin
			SET @Sql = @Sql + ' and '+@sSearch+' like ''%'+@sText+'%'' '
		end

		if @check_cnt = '0'
		begin
			SET @Sql = @Sql +' order by regdate desc'
		end

	END
print(@sql)
	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[sp_txt_list_action_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 텍스트이미지관리 리스트 광고상태 변경
	제작자		: 정윤정
	제작일		: 2005.01.24
	수정자		:
	수정일		:
	파라미터
use keywordshop
******************************************************************************/
CREATE PROCEDURE [dbo].[sp_txt_list_action_01]
	(
		@key		char(1) = ''
		,@idx		int = 0
	)

AS
	SET NOCOUNT ON
	BEGIN
		update tbl_TextImgKwd set adStatus = @key where idx = @idx
	END
GO
/****** Object:  StoredProcedure [dbo].[up_BizManInsert]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 및 유의어 등록 SP
	제작자		: 이기운
	제작일		: 2004.03.30
	수정자		:
	수정일		: 2004.03.31
	파라미터

******************************************************************************/

CREATE PROC [dbo].[up_BizManInsert]

@kwGrade			tinyint = 10,		-- 등급
@kwSection			char(1) = 8,		-- 섹션
@kwName				varchar(25) ='',	-- 키워드명
@kwHotChk			char(1) = '0',		-- 인기키워드 여부
@kwHotViewChk		char(1) = '0',		-- 인기키워드 노출
@kwHotSubName		varchar(25) = '',		-- 인기키워드 분류명
@kwHotsubNameChk	char(1) = '0',		-- 인기키워드 분류명 노출
@readCnt			int = 0,			-- 노출수
@ClickCnt			int = 0,			-- 클릭수
@flag				tinyint = 2,		-- 키워드 상태
@relationkw			varchar(100) = '',		-- 관련키워드
@similarkwName		varchar(25) = '',		-- 유의어
@location		tinyint,			-- 키워드 등록 경로 (1:프런트, 2:관리자)
@outparm			int  OUTPUT			--출력값(good_id)


AS
SET NOCOUNT ON
BEGIN

DECLARE
@rowCnt			int,				--영향받은 행갯수
@error_var		int,				--오류 번호
@tmpKwCode		int				--생성된 identity 값


	if @kwHotViewChk = ''
	BEGIN
		SET @kwHotViewChk = '0'
	END
	if @kwHotsubNameChk = ''
	BEGIN
		SET @kwHotsubNameChk = '0'
	END
	--트랜잭션 시작
	BEGIN TRAN

	if @kwName = ''
	BEGIN
		ROLLBACK TRAN
		SET @outparm = 0
		RETURN(1)
	END

	--키워드 등록 tbl_BizMan
	INSERT INTO tbl_BizMan (  kwName,  readCnt, clickCnt, Flag)
		VALUES (  @kwName,  0, 0, @flag)

		--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
		--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = 0
				--SET @outparm = '키워드가 입력되지 않았습니다.'
				--PRINT 'Error 번호: ' + CAST(@error_var AS VARCHAR(5))
				RETURN(1)
			END
		--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = 0
				--SET @outparm = '키워드가 입력되지 않았습니다.'
				--PRINT 'Warning: No rows were inserted'
				RETURN(1)
			END

		--정상적으로 입력되었으면 아이덴티티 셋팅
		SELECT @tmpKwCode = @@identity

	--키워드 가격 등록
	--EXEC up_Priceinsert @@identity

	--유의어 등록 tbl_SimilarKw
	--IF @similarkwName <> ''
	--BEGIN
	--	EXEC up_SimilarkwInsert @tmpKwCode,@similarkwName,''
	--END

	--커밋
	COMMIT TRAN
	SET @outparm = @tmpKwCode
	RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[up_keywordInsert]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 및 유의어 등록 SP
	제작자		: 이기운
	제작일		: 2004.03.30
	수정자		:
	수정일		: 2004.03.31
	파라미터

******************************************************************************/

CREATE PROC [dbo].[up_keywordInsert]

@kwGrade			tinyint = 3,		-- 등급
@kwSection			char(1) = 8,		-- 섹션
@kwName				varchar(25) ='',	-- 키워드명
@kwHotChk			char(1) = '0',		-- 인기키워드 여부
@kwHotViewChk		char(1) = '0',		-- 인기키워드 노출
@kwHotSubName		varchar(25) = '',		-- 인기키워드 분류명
@kwHotsubNameChk	char(1) = '0',		-- 인기키워드 분류명 노출
@readCnt			int = 0,			-- 노출수
@ClickCnt			int = 0,			-- 클릭수
@flag				tinyint = 2,		-- 키워드 상태
@relationkw			varchar(100) = '',		-- 관련키워드
@similarkwName		varchar(25) = '',		-- 유의어
@location		tinyint,			-- 키워드 등록 경로 (1:프런트, 2:관리자)
@outparm			int  OUTPUT			--출력값(good_id)


AS
SET NOCOUNT ON
BEGIN

if @kwGrade=10 or @kwGrade=5
begin
	SET @kwGrade=3
end

DECLARE
@rowCnt			int,				--영향받은 행갯수
@error_var		int,				--오류 번호
@tmpKwCode		int				--생성된 identity 값


	if @kwHotViewChk = ''
	BEGIN
		SET @kwHotViewChk = '0'
	END
	if @kwHotsubNameChk = ''
	BEGIN
		SET @kwHotsubNameChk = '0'
	END
	--트랜잭션 시작
	BEGIN TRAN

	if @kwName = ''
	BEGIN
		ROLLBACK TRAN
		SET @outparm = 0
		RETURN(1)
	END

	--키워드 등록 tbl_keyword
	INSERT INTO tbl_keyword (kwSection, kwGrade, kwName, kwHotChk, kwHotViewChk, kwhotSubName, kwHotSubNameChk
		, readCnt, clickCnt, Flag, relationKw, location)
		VALUES (@kwSection, @kwGrade, @kwName, @kwHotChk, @kwHotViewChk,  @kwHotSubName, @kwHotsubNameChk
		, 0, 0, @flag, @relationkw, @location)

		--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
		--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = 0
				--SET @outparm = '키워드가 입력되지 않았습니다.'
				--PRINT 'Error 번호: ' + CAST(@error_var AS VARCHAR(5))
				RETURN(1)
			END
		--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = 0
				--SET @outparm = '키워드가 입력되지 않았습니다.'
				--PRINT 'Warning: No rows were inserted'
				RETURN(1)
			END

		--정상적으로 입력되었으면 아이덴티티 셋팅
		SELECT @tmpKwCode = @@identity

	--키워드 가격 등록
	EXEC up_Priceinsert @@identity

	--유의어 등록 tbl_SimilarKw
	IF @similarkwName <> ''
	BEGIN
		EXEC up_SimilarkwInsert @tmpKwCode,@similarkwName,''
	END

	--커밋
	COMMIT TRAN
	SET @outparm = @tmpKwCode
	RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[up_keywordUpdate]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 수정 및 유의어 등록 SP
	제작자		: 이기운
	제작일		: 2004.04.6
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE PROC [dbo].[up_keywordUpdate]

@kwCode				int	= 0,			-- 키워드 코드
@kwGrade			tinyint = 3,		-- 등급
@kwSection			char(1) = 8,		-- 섹션
@kwName				varchar(25),		-- 키워드명
@kwHotChk			char(1) = '0',		-- 인기키워드 여부
@kwHotViewChk		char(1) = '0',		-- 인기키워드 노출
@kwHotSubName		varchar(25) = '',		-- 인기키워드 분류명
@kwHotsubNameChk	char(1) = '0',		-- 인기키워드 분류명 노출
@readCnt			int = 0,			-- 노출수
@ClickCnt			int = 0,			-- 클릭수
@flag				tinyint = 1,		-- 키워드 상태
@relationkw			varchar(100) = '',		-- 관련키워드
@similarkwName		varchar(25) = '',		-- 유의어
@outparm			int  OUTPUT			--출력값(good_id)


AS
SET NOCOUNT ON
BEGIN

if @kwGrade=10 or @kwGrade=5
begin
	SET @kwGrade=3
end

DECLARE
@rowCnt			int,				--영향받은 행갯수
@error_var		int,				--오류 번호
@tmpKwCode		int					--생성된 identity 값


	if @kwHotViewChk = ''
	BEGIN
		SET @kwHotViewChk = '0'
	END
	if @kwHotsubNameChk = ''
	BEGIN
		SET @kwHotsubNameChk = '0'
	END
	--트랜잭션 시작
	BEGIN TRAN

	--키워드 등록 tbl_keyword
	UPDATE tbl_keyword SET kwSection = @kwSection, kwGrade = @kwGrade, kwName = @kwName, kwHotChk = @kwHotChk, kwHotViewChk = @kwHotViewChk
		, kwhotSubName = @kwHotSubName, kwHotSubNameChk = @kwHotsubNameChk, Flag = @flag, relationKw = @relationkw, kwModDate = getdate()
	WHERE kwCode = @kwCode

		--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
		--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				--SET @outparm = '키워드가 입력되지 않았습니다.'
				--PRINT 'Error 번호: ' + CAST(@error_var AS VARCHAR(5))
				RETURN(1)
			END
		--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				--SET @outparm = '키워드가 입력되지 않았습니다.'
				--PRINT 'Warning: No rows were inserted'
				RETURN(1)
			END

	--유의어 선삭제 후 등록 tbl_SimilarKw
	Delete tbl_Similarkw WHERE kwCode = @kwCode

	IF @similarkwName <> ''
	BEGIN
		EXEC up_SimilarkwInsert @kwCode,@similarkwName,''
	END

	--커밋
	COMMIT TRAN
	SET @outparm = @kwCode
	RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[up_kwFrontFormUpdate]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

----------------------------------------------------------------
작성일자	: 2004년 04월 8일
작성자		: 이기운
내용		: 인기 키워드 프론트 폼 수정
수정일자	:
수정자		:
수정내용	:
기타		:
----------------------------------------------------------------

*/


CREATE PROC 	[dbo].[up_kwFrontFormUpdate]

@kwCode				int,
@lineNum			int,
@rowNum				int,
@outparm		int = 0	 OUTPUT	--출력값

AS
SET NOCOUNT ON
BEGIN

	BEGIN TRAN

		UPDATE tbl_hotkw SET kwCode = @kwCode WHERE lineNum = @lineNum AND rowNum = @rowNum

		IF (@@error <> 0)
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				--print @outparm
				RETURN(1)
			END
		Else
			Begin
				COMMIT TRAN
				SET @outparm = '1'
				--print @outparm
				RETURN(0)
			END
END
GO
/****** Object:  StoredProcedure [dbo].[up_kwNonePriceUpdate]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

----------------------------------------------------------------
작성일자	: 2004년 04월 8일
작성자	: 이기운
내용	: 미등록 키워드 수정
수정일자	:
수정자	:
수정내용	:
기타	:
----------------------------------------------------------------

*/


CREATE PROC 	[dbo].[up_kwNonePriceUpdate]

@goodGubun			char(1),
@goodRank			char(1),
@szDate				int,
@cutPrice1			money,
@cutPrice2			money,
@cutPrice3			money,

@outparm		int = 0	 OUTPUT	--출력값

AS
SET NOCOUNT ON
BEGIN

	BEGIN TRAN

	UPDATE tbl_kwNonePrice SET cutPrice1 = @cutPrice1, cutPrice2 = @cutPrice2, cutPrice3 = @cutPrice3
	WHERE  goodGubun = ''+@goodGubun+'' AND goodRank = ''+@goodRank+'' AND datediff(m,regdate,getdate()) = @szDate

		IF (@@error <> 0)
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				--print @outparm
				RETURN(1)
			END
		Else
			Begin
				COMMIT TRAN
				SET @outparm = '1'
				--print @outparm
				RETURN(0)
			END
END
GO
/****** Object:  StoredProcedure [dbo].[up_kwPriceBackup]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

----------------------------------------------------------------
작성일자	: 2004년 04월 12일
작성자		: 이기운
내용		: 키워드 가격 넣기( 매월 10일 )
수정일자	:
수정자		:
수정내용	:
기타		:
use keywordshop
----------------------------------------------------------------

*/


CREATE PROC 	[dbo].[up_kwPriceBackup]

@outparm		int = 0	 OUTPUT	--출력값

AS
SET NOCOUNT ON
BEGIN
	DECLARE
	@level_1		float,
	@level_2		float,
	@level_3		float,
	@level_4		float,
	@level_5		float,
	@level_6		float,
	@level_7		float,
	@level_8		float,
	@level_9		float,
	@level_10		float,
	@goods_B		float,
	@goods_H		float,
	@goods_P		float,
	@step_1			float,
	@step_2			float,
	@step_3			float,
	@step_4			float,
	@step_5			float,
	@section_1		float,
	@section_2		float,
	@section_3		float,
	@section_4		float,
	@section_5		float,
	@section_6		float,
	@section_7		float,
	@section_8		float,
	@sale_1			float,
	@sale_2			float,
	@sale_3			float,
	@etcmode_1		char(1),
	@etcadd_1		float,
	@etcmode_2		char(1),
	@etcadd_2		float,
	@etcmode_3		char(1),
	@etcadd_3		float


	BEGIN TRAN

		select  @level_1=level_1, @level_2=level_2, @level_3=level_3, @level_4=level_4, @level_5=level_5, @level_6=level_6, @level_7=level_7,
			@level_8=level_8, @level_9=level_9, @level_10=level_10, @goods_B=goods_B, @goods_H=goods_H, @goods_P=goods_P, @step_1=step_1,
			@step_2=step_2, @step_3=step_3, @step_4=step_4, @step_5=step_5, @section_1=section_1, @section_2=section_2, @section_3=section_3,
			@section_4=section_4, @section_5=section_5, @section_6=section_6, @section_7=section_7, @section_8=section_8, @sale_1=sale_1,
			@sale_2=sale_2, @sale_3=sale_3, @etcmode_1=etcmode_1, @etcadd_1=etcadd_1, @etcmode_2=etcmode_2, @etcadd_2=etcadd_2,
			@etcmode_3=etcmode_3, @etcadd_3=etcadd_3
		from tbl_add with (nolock) Where datediff(m,regDate,getdate()) = 0


	insert into tbl_kwPrice	(
		kwcode
		, goodGubun
		, goodRank
		, netPrice1
		, netPrice2
		, netPrice3
		, cutPrice1
		, cutPrice2
		, cutPrice3
		, regdate
	)
	(
	Select
		p.kwcode
		, goodGubun
		, goodRank
		, netPrice1 --= dbo.F_Add_ReturnPrice(k.kwGrade,goodGubun,goodRank,k.kwGrade,k.kwSection,c.readCnt,getdate(),@level_1,@level_2,@level_3,@level_4,@level_5,@level_6,@level_7,@level_8,@level_9,@level_10,@goods_B,@goods_H,@goods_P,@step_1,@step_2,@step_3,@step_4,@step_5,@section_1,@section_2,@section_3,@section_4,@section_5,@section_6,@section_7,@section_8,@sale_1,@sale_2,@sale_3,@etcmode_1,@etcmode_2,@etcmode_3,@etcadd_1,@etcadd_2,@etcadd_3,1)
		, netPrice2 -- = dbo.F_Add_ReturnPrice(k.kwGrade,goodGubun,goodRank,k.kwGrade,k.kwSection,c.readCnt,getdate(),@level_1,@level_2,@level_3,@level_4,@level_5,@level_6,@level_7,@level_8,@level_9,@level_10,@goods_B,@goods_H,@goods_P,@step_1,@step_2,@step_3,@step_4,@step_5,@section_1,@section_2,@section_3,@section_4,@section_5,@section_6,@section_7,@section_8,@sale_1,@sale_2,@sale_3,@etcmode_1,@etcmode_2,@etcmode_3,@etcadd_1,@etcadd_2,@etcadd_3,2)
		, netPrice3 -- = dbo.F_Add_ReturnPrice(k.kwGrade,goodGubun,goodRank,k.kwGrade,k.kwSection,c.readCnt,getdate(),@level_1,@level_2,@level_3,@level_4,@level_5,@level_6,@level_7,@level_8,@level_9,@level_10,@goods_B,@goods_H,@goods_P,@step_1,@step_2,@step_3,@step_4,@step_5,@section_1,@section_2,@section_3,@section_4,@section_5,@section_6,@section_7,@section_8,@sale_1,@sale_2,@sale_3,@etcmode_1,@etcmode_2,@etcmode_3,@etcadd_1,@etcadd_2,@etcadd_3,3)
		, cutPrice1 --= dbo.F_Add_ReturnPrice(k.kwGrade,goodGubun,goodRank,k.kwGrade,k.kwSection,c.readCnt,getdate(),@level_1,@level_2,@level_3,@level_4,@level_5,@level_6,@level_7,@level_8,@level_9,@level_10,@goods_B,@goods_H,@goods_P,@step_1,@step_2,@step_3,@step_4,@step_5,@section_1,@section_2,@section_3,@section_4,@section_5,@section_6,@section_7,@section_8,@sale_1,@sale_2,@sale_3,@etcmode_1,@etcmode_2,@etcmode_3,@etcadd_1,@etcadd_2,@etcadd_3,1)
		, cutPrice2 --= dbo.F_Add_ReturnPrice(k.kwGrade,goodGubun,goodRank,k.kwGrade,k.kwSection,c.readCnt,getdate(),@level_1,@level_2,@level_3,@level_4,@level_5,@level_6,@level_7,@level_8,@level_9,@level_10,@goods_B,@goods_H,@goods_P,@step_1,@step_2,@step_3,@step_4,@step_5,@section_1,@section_2,@section_3,@section_4,@section_5,@section_6,@section_7,@section_8,@sale_1,@sale_2,@sale_3,@etcmode_1,@etcmode_2,@etcmode_3,@etcadd_1,@etcadd_2,@etcadd_3,2)
		, cutPrice3 --= dbo.F_Add_ReturnPrice(k.kwGrade,goodGubun,goodRank,k.kwGrade,k.kwSection,c.readCnt,getdate(),@level_1,@level_2,@level_3,@level_4,@level_5,@level_6,@level_7,@level_8,@level_9,@level_10,@goods_B,@goods_H,@goods_P,@step_1,@step_2,@step_3,@step_4,@step_5,@section_1,@section_2,@section_3,@section_4,@section_5,@section_6,@section_7,@section_8,@sale_1,@sale_2,@sale_3,@etcmode_1,@etcmode_2,@etcmode_3,@etcadd_1,@etcadd_2,@etcadd_3,3)
		, dateadd(m,1,getdate()) as regdate
		--,c.readCnt, k.kwGrade, k.kwSection
	From tbl_kwPrice as p with (nolock) LEFT OUTER JOIN tbl_kwCnt c with (nolock) ON p.kwcode = c.kwcode
	LEFT OUTER JOIN tbl_keyword k with (nolock) ON p.kwcode = k.kwcode
	WHERE datediff(m,p.regdate,getdate()) = 0 and datediff(m,c.regDate,getdate()) = 1
	)

		IF (@@error <> 0)
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				--print @outparm
				RETURN(1)
			END
		Else
			Begin
				COMMIT TRAN
				SET @outparm = '1'
				--print @outparm
				RETURN(0)
			END
END
GO
/****** Object:  StoredProcedure [dbo].[up_kwPriceChangeByMonth]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[up_kwPriceChangeByMonth]

AS

begin tran

--월별로 바꾸어야함
DECLARE @CURYEAR CHAR(4)
DECLARE @NEXTYEAR CHAR(4)
DECLARE @CURMONTH VARCHAR(2)
DECLARE @NEXTMONTH VARCHAR(2)

SET @CURYEAR=YEAR(GETDATE())
SET @CURMONTH=MONTH(GETDATE())

SET @NEXTYEAR=YEAR(DATEADD(M,1,GETDATE()))
SET @NEXTMONTH=MONTH(DATEADD(M,1,GETDATE()))


-- 1등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=1) and ((year(regdate)=@CURYEAR and month(regdate)=@CURMONTH) or (year(regdate)=@NEXTYEAR and month(regdate)=@NEXTMONTH))

-- 1등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1= 120000, cutPrice2=120000*2 , cutPrice3= 120000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=1) and ((year(regdate)=@CURYEAR and month(regdate)=@CURMONTH) or (year(regdate)=@NEXTYEAR and month(regdate)=@NEXTMONTH))

-- 1등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=100000, cutPrice2=100000*2, cutPrice3=100000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=1) and ((year(regdate)=@CURYEAR and month(regdate)=@CURMONTH) or (year(regdate)=@NEXTYEAR and month(regdate)=@NEXTMONTH))




-- 2등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=2) and ((year(regdate)=@CURYEAR and month(regdate)=@CURMONTH) or (year(regdate)=@NEXTYEAR and month(regdate)=@NEXTMONTH))

-- 2등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=2) and ((year(regdate)=@CURYEAR and month(regdate)=@CURMONTH) or (year(regdate)=@NEXTYEAR and month(regdate)=@NEXTMONTH))

-- 2등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=70000*2, cutPrice3=70000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=2) and ((year(regdate)=@CURYEAR and month(regdate)=@CURMONTH) or (year(regdate)=@NEXTYEAR and month(regdate)=@NEXTMONTH))




-- 3등급, 스폰서배너
update tbl_kwPrice
set cutPrice1=20000, cutPrice2=20000*2, cutPrice3=20000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwGrade=3) and ((year(regdate)=@CURYEAR and month(regdate)=@CURMONTH) or (year(regdate)=@NEXTYEAR and month(regdate)=@NEXTMONTH))

-- 3등급, 스폰서홈페이지
update tbl_kwPrice
set cutPrice1=40000, cutPrice2=40000*2, cutPrice3=40000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwGrade=3) and ((year(regdate)=@CURYEAR and month(regdate)=@CURMONTH) or (year(regdate)=@NEXTYEAR and month(regdate)=@NEXTMONTH))

-- 3등급, 스폰서생활광고
update tbl_kwPrice
set cutPrice1= 30000, cutPrice2=30000*2, cutPrice3=30000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwGrade=3) and ((year(regdate)=@CURYEAR and month(regdate)=@CURMONTH) or (year(regdate)=@NEXTYEAR and month(regdate)=@NEXTMONTH))




-----------------#   등급별 가격 세팅 끝

-----------------# 특정 키워드별 가격 세팅 시작

/*

-- 3등급 야간 배너광고
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='야간' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 야간 홈페이지 광고
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='야간' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 야간 생활광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=70000*2, cutPrice3=70000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='야간' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))




-- 3등급 자전거 배너광고
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='자전거' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 자전거 홈페이지 광고
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='자전거' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 자전거 생활광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=70000*2, cutPrice3=70000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='자전거' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))



-- 3등급 아르바이트 배너광고
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='아르바이트' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 아르바이트 홈페이지 광고
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='아르바이트' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 아르바이트 생활광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=70000*2, cutPrice3=70000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='아르바이트' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))





-- 3등급 영업 배너광고
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='영업' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 영업 홈페이지 광고
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='영업' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 영업 생활광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=70000*2, cutPrice3=70000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='영업' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))





-- 3등급 지게차 배너광고
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='지게차' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 지게차 홈페이지 광고
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='지게차' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 지게차 생활광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=70000*2, cutPrice3=70000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='지게차' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))





-- 3등급 학습지교사 배너광고
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='학습지교사' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 학습지교사 홈페이지 광고
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='학습지교사' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 학습지교사 생활광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=70000*2, cutPrice3=70000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='학습지교사' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))






-- 3등급 용접 배너광고
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='용접' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 용접 홈페이지 광고
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='용접' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 용접 생활광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=70000*2, cutPrice3=70000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='용접' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))







-- 3등급 아반떼 배너광고
update tbl_kwPrice
set cutPrice1=60000, cutPrice2=60000*2, cutPrice3=60000*3
where goodGubun=1 and kwcode in (select kwcode from tbl_keyword where kwName='아반떼' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 아반떼 홈페이지 광고
update tbl_kwPrice
set cutPrice1=90000, cutPrice2=90000*2, cutPrice3=90000*3
where goodGubun=2 and kwcode in (select kwcode from tbl_keyword where kwName='아반떼' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))

-- 3등급 아반떼 생활광고
update tbl_kwPrice
set cutPrice1=70000, cutPrice2=70000*2, cutPrice3=70000*3
where goodGubun=3 and kwcode in (select kwcode from tbl_keyword where kwName='아반떼' and kwGrade=3) and ((year(regdate)=2007 and month(regdate)=08) or (year(regdate)=2007 and month(regdate)=09))




*/

commit tran



















-----------------# 특정 키워드별 가격 세팅 시작
GO
/****** Object:  StoredProcedure [dbo].[up_kwPriceUpdate]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

----------------------------------------------------------------
작성일자	: 2004년 04월 8일
작성자	: 이기운
내용	: 등록 키워드 수정
수정일자	:
수정자	:
수정내용	:
기타	:
----------------------------------------------------------------

*/


CREATE PROC 	[dbo].[up_kwPriceUpdate]

@kwCode				int,
@goodGubun			char(1),
@goodRank			char(1),
@szDate				int,
@cutPrice1			money,
@cutPrice2			money,
@cutPrice3			money,

@outparm		int = 0	 OUTPUT	--출력값

AS
SET NOCOUNT ON
BEGIN

	BEGIN TRAN

	UPDATE tbl_kwPrice SET cutPrice1 = @cutPrice1, cutPrice2 = @cutPrice2, cutPrice3 = @cutPrice3
	WHERE  kwCode = @kwCode AND goodGubun = ''+@goodGubun+'' AND goodRank = ''+@goodRank+'' AND datediff(m,regdate,getdate()) = @szDate

		IF (@@error <> 0)
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				--print @outparm
				RETURN(1)
			END
		Else
			Begin
				COMMIT TRAN
				SET @outparm = '1'
				--print @outparm
				RETURN(0)
			END
END
GO
/****** Object:  StoredProcedure [dbo].[up_kwStatusUpdate]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

----------------------------------------------------------------
작성일자	: 2004년 04월 5일
작성자	: 이기운
내용	: 키워드 상태 변경
수정일자	:
수정자	:
수정내용	:
기타	:
----------------------------------------------------------------

*/


CREATE PROC 	[dbo].[up_kwStatusUpdate]

@KwCode		int = 0,			-- 키워드 코드
@kwHotSubNameChk	char(1) = '0',		-- 키워드 분류 노출 여부
@kwHotViewChk		char(1) = '0',		-- 키워드 노출여부
@outparm		int = 0	 OUTPUT	--출력값

AS
SET NOCOUNT ON
BEGIN

	BEGIN TRAN

	UPDATE tbl_keyword
	SET kwHotViewChk = @kwHotViewChk, kwHotSubNameChk = @kwHotSubNameChk, kwModDate = getdate()
	Where kwCode = @KwCode

		IF (@@error <> 0)
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				--print @outparm
				RETURN(1)
			END
		Else
			Begin
				COMMIT TRAN
				SET @outparm = '1'
				--print @outparm
				RETURN(0)
			END
END
GO
/****** Object:  StoredProcedure [dbo].[up_Priceinsert]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

----------------------------------------------------------------
작성일자	: 2004년 04월 31일
작성자	: 이기운
내용	: 키워드 등록시 가격 등록
수정일자	:
수정자	: 이기운
수정내용	:  10일 이후만 내달 가격 넣기
기타	:
----------------------------------------------------------------

*/


CREATE PROC 	[dbo].[up_Priceinsert]

@tmpKwCode		int = 0,			-- 키워드 코드
@outparm		int = 0	 OUTPUT	--출력값

AS
SET NOCOUNT ON
BEGIN
	DECLARE
	@szDate		tinyint

	select @szDate = day(getdate())

	BEGIN TRAN

	INSERT INTO tbl_kwPrice (
		kwcode, goodGubun, goodRank, netPrice1, netPrice2, netPrice3, cutPrice1, cutPrice2, cutPrice3
	)

	(
	SELECT 	@tmpKwCode, goodGubun, goodRank, netPrice1, netPrice2, netPrice3, cutPrice1, cutPrice2, cutPrice3
		from tbl_kwNonePrice WITH (NOLOCK) WHERE datediff(m,regdate,getdate()) = 0
	)
	-- 매월 10일날 내달가격 입력 하므로 10일 이후에만 키워드 등록시 넣는다.
	IF (@szDate > 9 )
	BEGIN
		INSERT INTO tbl_kwPrice (
			kwcode, goodGubun, goodRank, netPrice1, netPrice2, netPrice3, cutPrice1, cutPrice2, cutPrice3, regdate
		)

		(
		SELECT 	@tmpKwCode, goodGubun, goodRank, netPrice1, netPrice2, netPrice3, cutPrice1, cutPrice2, cutPrice3, dateadd(m,1,getdate()) as regdate
			from tbl_kwNonePrice WITH (NOLOCK) WHERE datediff(m,regdate,getdate()) = 0
		)
	END

		IF (@@error <> 0)
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				--print @outparm
				RETURN(1)
			END
		Else
			Begin
				COMMIT TRAN
				SET @outparm = '1'
				--print @outparm
				RETURN(0)
			END
END
GO
/****** Object:  StoredProcedure [dbo].[up_report_day_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_day_list_01]
	(
		@code		int = 0
	)
AS
	SET NOCOUNT ON

select a.code, a.kwcode, a.userid, a.username, a.code, a.originPrice, i.service_Price,
	sum(readCnt) as readCnt,
	price = Case When a.branchcode > '0' and a.branchcode <> NULL Then i.real_Price Else a.originPrice End
	from tbl_keyword_adinfo2 a with (NOLOCK) left OUTER JOIN tbl_keyword_income i with (NOLOCK) ON a.code = i.code
	left outer JOIN tbl_adCnt c with (NOLOCK) ON a.kwcode = c.kwcode
	where a.code = @code
	group by a.code, a.kwcode, a.userid, a.username, a.code, a.kwname, a.originprice, i.service_price, i.real_Price, a.branchcode
GO
/****** Object:  StoredProcedure [dbo].[up_report_day_list_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_day_list_02]
	(
		@code		int = 0
	)
AS
	SET NOCOUNT ON

	select sum(clickcnt) as sum_clickcnt from tbl_adCnt c with (NOLOCK)
		where c.adCode = @code
GO
/****** Object:  StoredProcedure [dbo].[up_report_day_list_03]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_day_list_03]
	(
		@code		int = 0
	)
AS
	SET NOCOUNT ON

	select clickCnt, regDate, sum(clickcnt) as sum_clickcnt from tbl_adCnt c with (NOLOCK)
		where c.adCode = @code
		group by clickcnt, regdate
GO
/****** Object:  StoredProcedure [dbo].[up_report_keyword_click_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_keyword_click_01]

	(
		@key			int = 0,
		@toppage		int	= 0,
		@sKwGrade		char(1) = '',
		@sViewOption	char(1) = '',
		@s_date			char(10) = '',
		@e_date			char(10) = ''

	)

AS
	SET NOCOUNT ON

	DECLARE	@SQL	VARCHAR(1000)

	IF @key = '0'
		BEGIN
			SET @SQL = 'select count(a.code) as tcount from (select '
		END
	else
		begin
			SET @SQL = ' select top '+cast(@toppage as varchar)+' '
		end

	SET @SQL = @SQL + ' a.code, '
	SET @SQL = @SQL + ' a.kwname, a.goodRank, a.goodgubun, a.period, a.kwcode, a.userid, a.username, k.kwGrade,  '
	SET @SQL = @SQL + ' a.regdate, a.authdate, isnull(sum(c.clickcnt), ''0'') as clickcnt, isNull(sum(c.readcnt), ''0'') as readcnt  '
	SET @SQL = @SQL + ' from tbl_keyword_adinfo2 a with (NOLOCK) INNER JOIN tbl_keyword k with (NOLOCK) ON a.kwcode = k.kwcode '
	SET @SQL = @SQL + ' left outer JOIN tbl_adCnt c with (NOLOCK) ON a.code = c.adcode '

	SET @SQL = @SQL + '  where a.code <> '''' '



	if @sKwGrade <> ''
		BEGIN
			SET @SQL = @SQL + ' and kwGrade = '''+@sKwGrade+''' '
		END

	IF @s_date <> '' and @e_date <> ''
		BEGIN
			SET @SQL = @SQL + '  and (CONVERT(varchar(10), a.regDate, 120) >= '''+@s_date+''' and Convert(varchar(10), a.regDate, 120) <= '''+@e_Date+''') '
		END



	SET @SQL = @SQL + '  group by a.kwname, a.goodRank, a.goodgubun, a.period, a.kwcode, a.userid, a.username, k.kwgrade, '
	SET @SQL = @SQL + '  a.code, a.regdate, a.authdate '

	IF @KEY = '0'
		BEGIN
			SET @SQL = @SQL + ' ) as a'
		END



	IF @KEY = '1' and @sViewOption <> ''
		BEGIN
			IF @sViewOption = '1'
				BEGIN
					SET @SQL = @SQL + '	order by a.kwname asc'        -- 키워드
				END
			ELSE IF @sViewOption = '2'
				BEGIN
					SET @SQL = @SQL + ' order by a.userid asc '        -- 광고주 아이디
				END

		END

	EXECUTE(@SQL)
	Print(@sql)
GO
/****** Object:  StoredProcedure [dbo].[up_report_name_price_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_name_price_01]
	(
		@key		char(1) = '',
		@toppage	int = 0,
		@sSearch	varchar(10) = '',
		@sText		varchar(20) = '',
		@s_Date		char(10) = '',
		@e_date		char(10) = ''

	)
AS
	SET NOCOUNT ON
	DECLARE @SQL	VARCHAR(1000)

	IF @key = '0'
		BEGIN
			SET @sql = ' select count(a.kwcode) as totalCount, sum(Price) as totalPrice from ( '
			SET @sql = @sql + ' select '
		END
	ELSE IF @key = '1'
		BEGIN
			SET @sql = ' select top '+CAST(@toppage as varchar)+' '
		END

	SET @SQL = @SQL + ' a.kwcode, a.userid, a.username, a.code, a.kwname, a.originPrice, i.service_Price, '
	SET @SQL = @SQL + ' isNull(sum(readCnt), ''0'') as readCnt,  isnull(sum(clickCnt), ''0'') as clickCnt, '
	SET @SQL = @SQL + ' price = Case When a.branchcode > ''0'' and a.branchcode <> NULL Then i.real_Price Else a.originPrice End '
	SET @SQL = @SQL + ' from tbl_keyword_adinfo2 a with (NOLOCK) left OUTER JOIN tbl_keyword_income i with (NOLOCK) ON a.code = i.code '
	SET @SQL = @SQL + 'left outer JOIN tbl_adCnt c with (NOLOCK) ON a.code = c.adcode '
	SET @SQL = @SQL + ' where a.kwcode <> '''' '




	IF @s_date <> '' and @e_date <> ''
		BEGIN
			SET @SQL = @SQL + '  and (CONVERT(varchar(10), a.regDate, 120) >= '''+@s_date+''' and Convert(varchar(10), a.regDate, 120) <= '''+@e_Date+''') '
		END

	IF @sSearch <> ''  and @sText <> ''
		BEGIN
			SET @SQL = @SQL + ' and '+@sSearch+' like ''%'+@sText+'%'' '

		END



	SET @SQL = @SQL + ' group by a.kwcode, a.userid, a.username, a.code, a.kwname, a.originprice, i.service_price, i.real_Price, a.branchcode '

	IF @key = '1'
		BEGIN
			SET @SQL = @SQL + ' order by a.code desc'
		END
	ELSE IF @key = '0'
		BEGIN
			SET @SQL = @SQL + ' ) as a '
		END

	EXECUTE(@sql)
	--print @sql
GO
/****** Object:  StoredProcedure [dbo].[up_report_postbanner_branchcode_list_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_postbanner_branchcode_list_01]
	(
		@branchcode		int = 0
	)
AS
	SET NOCOUNT ON
	select code, kwname, goodRank, startday, endday, authDate, adState, payState, regdate
	from tbl_keyword_adinfo2 with (NOLOCK) where branchcode = @branchcode
	order by code desc
GO
/****** Object:  StoredProcedure [dbo].[up_report_postpoint_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_postpoint_01]

	(
		@key			char(1) = '1',	-- 0: cnt 1:list	2: 통계쪽.
		@toppage		int = 0,
		@sSaleHouse		char(2)	= '00',
		@sDateSearch	char(1) = '',
		@s_Date			char(10) = '',
		@e_Date			char(10) = ''

	)

AS
	SET NOCOUNT ON

	Declare @sql varchar(1000)

	IF @key = '0'
		BEGIN
			SET @SQL = 'select count(a.branchcode) as ccount from( '
			SET @SQL = @sql + 'select a.branchcode from tbl_keyword_adinfo2 a with (NOLOCK) '
		END
	ELSE IF @key = '1'	-- 리스트
		begin
			SET @SQL = 'select top '+CAST(@toppage as varchar)+' a.branchcode from tbl_keyword_adinfo2 a WITH (NOLOCK)'
		end
	ELSE IF @key = '2'		-- 통계쪽 돌리는거
		BEGIN
			SET @sql = 'select a.branchcode from tbl_keyword_adinfo2 a with (NOLOCK) '
		END

	SET @sql =  @sql + ' where a.branchcode <> '''' '


	IF @sSaleHouse <> ''
		BEGIN
			IF @sSaleHouse = '1'
				BEGIN
					SET @sql =  @sql + ' and a.branchgubun = ''1'' '
				END
			ELSE IF @sSaleHouse = '2'
				BEGIN
					SET @sql =  @sql + ' and a.branchgubun = ''2'' '
				END
			ELSE IF @sSaleHouse ='81'
				Begin
					SET @Sql = @Sql + ' and (branchCode =''16'' or branchCode =''17'' or branchCode =''18'' or branchCode =''21'' or branchCode =''10''  or branchCode =''81'' )'
				End

			Else IF @sSaleHouse ='82'
				Begin
					SET @Sql = @Sql + ' and (branchCode =''19'' or branchCode =''20'' or branchCode =''22'' or branchCode =''23'' or branchCode =''82'' )'
				End

			Else IF @sSaleHouse ='83'
				Begin
					SET @Sql = @Sql + ' and (branchCode =''11'' or branchCode =''26'' or branchCode =''39'' or branchCode =''83'' )'
				End

			Else IF @sSaleHouse ='84'
				Begin
					SET @Sql = @Sql + ' and (branchCode =''25'' or branchCode =''49'' or branchCode =''84'' )'
				End

			Else IF @sSaleHouse ='85'
				Begin
					SET @Sql = @Sql + ' and (branchCode =''12'' or branchCode =''13'' or branchCode =''14'' or branchCode=''15'' or branchCode=''85'' )'
				End
			ELSE
				BEGIN
					SET @sql =  @sql + ' and a.branchcode = '''+@sSaleHouse+''' '
				END

		END



	IF @sDateSearch <> ''
		BEGIN
			IF @sDateSearch = '1'
				BEGIN
					SET @sql =  @sql + '  and ( (CONVERT(varchar(10), a.startday, 120) >= '''+@s_date+''' and (Convert(varchar(10),a.startday, 120) <= '''+@e_Date+'''  ) or '
					SET @sql =  @sql + '  (CONVERT(varchar(10), a.endday, 120) >= '''+@s_Date+''' ) and (Convert(varchar(10),a.endday, 120) <= '''+@e_Date+''' ) ))  '
				END
			ELSE IF @sDateSearch = '2'
				BEGIN
					SET @sql =  @sql + '  and (CONVERT(varchar(10), a.regDate, 120) >= '''+@s_date+''' and Convert(varchar(10), a.regDate, 120) <= '''+@e_Date+''') '
				END

		END



	SET @sql =  @sql + ' group by a.branchcode '

	IF @key = '0'
		BEGIN
			SET @sql = @sql + ')as a '
		END


	EXECUTE(@SQL)
	--PRINT(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[up_report_postpoint_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_postpoint_02]

	(
		@key			char(1) = '1',
		@t_branchcode	int = 0

	)

AS
	SET NOCOUNT ON

	DECLARE @SQL	varchar(500)

	SET @SQL = 'select isNull(count(a.code),''0'') as code_count, sum(i.real_price) from tbl_keyword_adinfo2 a with (NOLOCK)'
	SET @SQL = @SQL + ' INNER JOIN tbl_keyword_income i with (NOLOCK) ON a.code = i.code'


	IF @KEY = '1'
		BEGIN
			SET @SQL = @SQL + ' where goodgubun in (''1'',''2'',''3'') and isDC in (''1'',''2'',''3'',''4'',''5'') and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END
	ELSE IF @KEY = '2'
		BEGIN
			SET @SQL = @SQL + '  where goodgubun = ''1'' and isDC in (''1'',''2'',''3'',''4'',''5'')  and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END
	ELSE IF @KEY = '3'
		BEGIN
			SET @SQL = @SQL + '  where goodgubun = ''2'' and isDC in (''1'',''2'',''3'',''4'',''5'') and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END
	ELSE IF @KEY = '4'
		BEGIN
			SET @SQL = @SQL + '  where goodgubun = ''3'' and isDC in (''1'',''2'',''3'',''4'',''5'') and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END
	ELSE IF @KEY = '5'
		BEGIN
			SET @SQL = @SQL + '  where goodgubun = ''4'' and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END
	ELSE IF @KEY = '6'
		BEGIN
			SET @SQL = @SQL + '  where isDC in (''6'',''7'',''8'') and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END
	ELSE IF @KEY = '7'
		BEGIN
			SET @SQL = @SQL + '  where isDC = ''6'' and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END
	ELSE IF @KEY = '8'
		BEGIN
			SET @SQL = @SQL + '  where isDC = ''7'' and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END
	ELSE IF @KEY = '9'
		BEGIN
			SET @SQL = @SQL + '  where isDC = ''8'' and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END


	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[up_report_postpoint_03]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_postpoint_03]

	(
		@key			char(1) = '1',
		@t_branchcode	int = 0
	)

AS
	SET NOCOUNT ON

	DECLARE @sql	varchar(300)


	SET @sql = 'select isNull(count(a.code),''0'') as code_count, sum(i.real_price) from tbl_keyword_adinfo2 a with (NOLOCK)'
	SET @sql = @sql + ' INNER JOIN tbl_keyword_income i with (NOLOCK) ON a.code = i.code'


	IF @key	= '1'
		BEGIN
			SET @sql = @sql + ' where goodgubun in (''1'',''2'',''3'') and isDC in (''1'',''2'',''3'',''4'',''5'') and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END
	ELSE IF @key = '2'
		BEGIN
			SET @sql = @sql + ' where isDC in (''6'',''7'',''8'') and a.branchcode = '+CAST(@t_branchcode as varchar)+' '
		END



	EXECUTE(@sql)
GO
/****** Object:  StoredProcedure [dbo].[up_report_read_keyword_01]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_read_keyword_01]
	(
		@key		char(1) = '',
		@toppage	int = 0,
		@sSection	char(1) = '',
		@sKwGrade	char(1) = '',
		@sSaleMoney	char(1) = '',
		@s_Date		varchar(10) = '',
		@e_date		varchar(10) = '',
		@kwCode		int = 0

	)

AS
	SET NOCOUNT ON

	DECLARE @SQL	varchar(1000)


	IF @key = '0' or @key = '2' or @key = '3'
		BEGIN
			SET @SQL = 'select count(k.kwcode) '
		END
	ELSE if @key = '1'
		BEGIN
			SET @SQL = 'select top '+CAST(@toppage as varchar)+' k.kwcode, k.kwname, k.kwsection, k.kwGrade '
		END



	SET @SQL = @SQL + ' from tbl_keyword k with (NOLOCK) '

	IF @key = '2' or @key = '3'
		BEGIN
			SET @SQL = @SQL + ' LEFT OUTER JOIN tbl_keyword_adinfo2 a with (NOLOCK) ON k.kwcode = a.kwcode '

		END


	SET @SQL = @SQL + ' where k.kwcode <> '''' '



	IF @key = '2' or @key = '3'
		BEGIN

			SET @sql =  @sql + '  and ( (CONVERT(varchar(10), a.startday, 120) >= '''+@s_date+''' and (Convert(varchar(10),a.startday, 120) <= '''+@e_Date+'''  ) or '
					SET @sql =  @sql + '  (CONVERT(varchar(10), a.endday, 120) >= '''+@s_Date+''' ) and (Convert(varchar(10),a.endday, 120) <= '''+@e_Date+''' ) ))  '
		END


	IF @sSection <> ''
		BEGIN
			SET @SQL = @SQL + '	and k.kwSection = '''+@sSection+''' '
		END

	IF @sKwGrade <> ''
		BEGIN
			SET @SQL = @SQL + '	and k.kwGrade = '''+@sKwGrade+''' '
		END

	IF @key = '2'
		BEGIN
			SET @SQL = @SQL + '	and isDC not in (''6'',''7'',''8'') and payState in (''I'',''Y'',''N'')'
		END
	else IF @key = '3'
		BEGIN
			SET @SQL = @SQL + '	and isDC in (''6'',''7'',''8'') and payState in (''I'',''Y'',''N'')'
		END


	IF @kwCode <> 0
		BEGIN
				SET @SQL = @SQL + '	and a.kwcode = '+CAST(@kwcode as varchar)+' '
		END




	IF @key = '1'
		BEGIN
			SET @SQL = @SQL + ' order by k.kwname asc'
		END

	EXECUTE(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[up_report_read_keyword_02]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[up_report_read_keyword_02]
	(
		@t_kwcode	int = 0
	)
AS
	SET NOCOUNT ON
	select sum(readCnt), sum(clickCnt) from tbl_adCnt where kwcode = @t_kwcode
GO
/****** Object:  StoredProcedure [dbo].[up_SimilarkwInsert]    Script Date: 2021-11-04 오전 10:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 유의어 등록 SP
	제작자		: 이기운
	제작일		: 2004.03.30
	수정자		:
	수정일		: 2004.03.31
	파라미터

******************************************************************************/



CREATE PROC [dbo].[up_SimilarkwInsert]

@tmpKwCode		int = 0,			-- 키워드 코드
@similarkwName		varchar(25) = '0',		-- 유의어
@outparm		int  OUTPUT		--출력값(good_id)


AS
SET NOCOUNT ON
BEGIN

DECLARE
@rowCnt			int,				--영향받은 행갯수
@error_var		int				--오류 번호


	--트랜잭션 시작
	BEGIN TRAN

	--유의어 등록 tbl_SimilarKw
	INSERT INTO tbl_SimilarKw (kwCode, similarkwName, regDate)
		VALUES (@tmpKwCode, @similarkwName, getdate() )

		--오류번호, 적용 행 갯수 셋팅
		SELECT @error_var = @@ERROR, @rowCnt = @@ROWCOUNT
		--에러 발생시
		IF @error_var <> 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				--SET @outparm = '유의어가 입력되지 않았습니다.'
				--PRINT 'Error 번호: ' + CAST(@error_var AS VARCHAR(5))
				RETURN(1)
			END
		--입력이 되지 않았으면
		IF @rowCnt = 0
			BEGIN
				ROLLBACK TRAN
				SET @outparm = '0'
				--SET @outparm = '유의어가 입력되지 않았습니다.'
				--PRINT 'Warning: No rows were inserted'
				RETURN(1)
			END


	--커밋
	COMMIT TRAN
	SET @outparm = @tmpKwCode
	RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[USERID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:22:57 ******/
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
	UPDATE A SET userID=@RE_USERID FROM tbl_tax A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM tbl_BizManSendMailLog01 A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM tbl_BizManSendMailLog A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM tbl_BizManSendMailLog02 A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM tbl_RecmAd A  where CUID=@CUID
	UPDATE A SET userID=@RE_USERID FROM tbl_bizman_adinfo A  where CUID=@CUID
	UPDATE A SET userID=@RE_USERID FROM tbl_keyword_adinfo A  where CUID=@CUID
	UPDATE A SET userID=@RE_USERID FROM tbl_keyword_adinfo2 A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM tbl_KShopSendMailLog A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM tbl_KShopSendMailLog01 A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM tbl_KShopSendMailLog02 A  where CUID=@CUID
	UPDATE A SET userID=@RE_USERID FROM tbl_qna A  where CUID=@CUID
/*
	INSERT LOGDB.DBO.USERID_CHANGE_HISTORY_TB (B_USERID,N_USERID,DB_NM,USERIP)
	SELECT @USERID,@RE_USERID,DB_NAME(),@CLIENT_IP
*/
END
GO
