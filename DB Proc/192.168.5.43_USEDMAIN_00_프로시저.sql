USE [USEDMAIN]
GO
/****** Object:  StoredProcedure [dbo].[__DEL__procUserCommon_Cancel_FINDDB13_20191001]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[__DEL__procUserCommon_Cancel_FINDDB13_20191001]
AS

-- FINDDB2 에 있는 탈퇴회원 아이디 테이블을 가져온다.
-- FINDDB2 의 선행 프로시저 (procUserCommon_Cancel) 가 정상실행되지 않았을 경우 어제 데이터로 다시 업데이트를 하게 되므로 (동일한 아이디로 다른 사람이 가입한 경우 또 지워질 수도 있음)
-- 그런 경우를 방지하기 위해 오늘 날짜로 들어간 데이터만을 가져온다.
	SELECT UserID, Del_ID INTO #Temp_DelUserID FROM FINDDB2.Common.dbo.DelUserID_Daily WHERE RegDate > CONVERT(char(10),GETDATE(),120)


--FINDDB13.UsedCommon
	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedCommon.dbo.Goodsinterest	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

/* 
	--사업부 요청으로 제외_20030929
	UPDATE	A 	SET	A.UserID	= B.Del_ID, A.DelFlag = '1'
	FROM	UsedCommon.dbo.KnowHow	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedCommon.dbo.KnowHowRe	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	
*/

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedCommon.dbo.OrderMail	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedCommon.dbo.RecStore	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedCommon.dbo.RecStoreRequest  A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedCommon.dbo.UsrCnt		A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedCommon.dbo.EscrowReject		A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	


-- FINDDB13.UsedMain
	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedMain.dbo.Auction		A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedMain.dbo.EsKiccTrans	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedMain.dbo.EsOnLine		A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID, A.DelFlag = '1'
	FROM	UsedMain.dbo.GoodsMain	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID, A.DelFlag = '1'
	FROM	UsedMain.dbo.GoodsMain_Save	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedMain.dbo.KiccTrans		A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedMain.dbo.MsgBoard		A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.SaleUserID	= B.Del_ID
	FROM	UsedMain.dbo.MsgBoard		A,   #Temp_DelUserID	B
	WHERE	A.SaleUserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID, A.DelFlag = '1'
	FROM	UsedMain.dbo.SaleAgency	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID, A.DelFlagSale = '1', A.DelFlagBuy = '1'
	FROM	UsedMain.dbo.Sale_BuyerInfo	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedMain.dbo.GoodsMainAdmin		A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	UsedMain.dbo.BadUserUsed		A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.SellerID	= B.Del_ID
	FROM	UsedMain.dbo.BuyContentChart		A,   #Temp_DelUserID	B
	WHERE	A.SellerID	 =  B.UserID	

	UPDATE	A 	SET	A.BuyerID	= B.Del_ID
	FROM	UsedMain.dbo.BuyContentChart		A,   #Temp_DelUserID	B
	WHERE	A.BuyerID	 =  B.UserID	


-- FINDDB13.PointDB
	UPDATE	A 	SET	A.DelFlag = '1', A.DelDate = getdate(), A.Remark = '회원탈퇴'
	FROM	PointDB.dbo.PointSub	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID

	UPDATE	A 	SET	A.UserID	= B.Del_ID, A.DelFlag = '1', A.DelDate = getdate()
	FROM	PointDB.dbo.PointMain	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID
GO
/****** Object:  StoredProcedure [dbo].[__procEmTran_Insert_20191001]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
	중고장터 관리자 문자메시지 발송하기
*/

CREATE   PROC [dbo].[__procEmTran_Insert_20191001]
@tran_phone		varchar(15) = '', 
@tran_callback	varchar(15) = '', 
@tran_status		char(1) = '', 
@tran_msg		varchar(255) = '', 
@tran_etc4		int = 0
AS
BEGIN

	--문자 발송하기
	INSERT	INTO TAX.DBRO.DBROUSER.EM_TRAN (	
					 TRAN_PHONE
					,TRAN_CALLBACK
					,TRAN_STATUS
					,TRAN_DATE
					,TRAN_MSG
					,TRAN_ETC4	
	) VALUES		(
					 @tran_phone
					,@tran_callback
					,@tran_status
					,GETDATE()
					,@tran_msg
					,@tran_etc4
	)

END



GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_OUT_FINDDB13_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 탈퇴 처리(전날 탈퇴 신청 회원 정보)
 *  작   성   자 : 문해린
 *  작   성   일 : 2007-12-20
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 섹션별 불량회원 관리함. 
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 

 *************************************************************************************/


CREATE             PROCEDURE [dbo].[BAT_MM_OUT_FINDDB13_PROC]

AS

-- 전날 일자
DECLARE @PRE_DT DATETIME
SET @PRE_DT = CONVERT(CHAR(10),DATEADD(D,-1,GETDATE()),120)

--------------------------------------------
-- 1. 전날 탈퇴 신청 아이디 가져오기
--------------------------------------------
SELECT CUID 
  INTO #TEMP_OUT_USERID
  FROM MEMBERDB.MWMEMBER.DBO.CST_MASTER
 WHERE OUT_DT > @PRE_DT

--------------------------------------------
-- 2. 매물 종료 처리
--------------------------------------------

-- FINDDB13.USEDMAIN
	UPDATE	A 	
	   SET	A.DELFLAG = '1'
	  FROM	DBO.GOODSMAIN A
		JOIN #TEMP_OUT_USERID B ON A.CUID  = B.CUID	

	UPDATE	A 	
	   SET	A.DELFLAG = '1'
	  FROM	DBO.SALEAGENCY A
		JOIN #TEMP_OUT_USERID B ON A.CUID = B.CUID	

	UPDATE	A 	
	   SET	A.DELFLAGSALE = '1'
		,A.DELFLAGBUY = '1'
	  FROM	DBO.SALE_BUYERINFO A
		JOIN #TEMP_OUT_USERID B ON A.CUID = B.CUID	

-- FINDDB13.POINTDB
/*
	UPDATE	A 	
	   SET	A.DELFLAG = '1'
		,A.DELDATE = GETDATE()
		,A.REMARK = '회원탈퇴'
	  FROM	POINTDB.DBO.POINTSUB A
		JOIN #TEMP_OUT_USERID B ON A.USERID	 =  B.USERID

	UPDATE	A 	
	   SET	A.DELFLAG = '1'
		,A.DELDATE = GETDATE()
	  FROM	POINTDB.DBO.POINTMAIN A
		JOIN #TEMP_OUT_USERID B ON A.USERID	 =  B.USERID


*/


GO
/****** Object:  StoredProcedure [dbo].[BAT_SM_SALE_RAW_FINDUSED_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 중고장터 정산 배치작업
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/01/31
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 

EXEC BAT_SM_SALE_RAW_FINDUSED_PROC

 *************************************************************************************/

CREATE PROC [dbo].[BAT_SM_SALE_RAW_FINDUSED_PROC]
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @DATE_YESTERDAY DATETIME
	DECLARE @DATE_TODAY		DATETIME

	SET @DATE_YESTERDAY = DATEADD(DD,-1,CONVERT(VARCHAR(10), GETDATE(),120))
	SET @DATE_TODAY		= CONVERT(VARCHAR(10), GETDATE(),120)

	/*
	-- 결재일 범위 오늘날짜기준		DATEADD(DD, @PRE_DAY,CONVERT(VARCHAR(10), GETDATE(),120))
	DECLARE @PRE_DAY	INT
	SET @PRE_DAY = -1
	*/
/* ==========================================================================================
	옵션별 테이블 생성
	==========================================================================================*/

	--// 옵션전체			#TMP_OPT_FULL
	SELECT G.ADID, G.USERID, G.LOCALSITE, CASE G.PRNCNT WHEN '10' THEN 'C01P001' WHEN '20' THEN 'C01P002' WHEN '30' THEN 'C01P003' END AS OPTNM, (SELECT OPTTOTAL FROM dbo.OptionPrice WHERE  LOCALSITE=G.LOCALSITE AND OPTPRNCNT=G.PRNCNT) AS OPTAMT
	INTO #TMP_OPT_FULL
	FROM GOODSMAIN AS G 
	WHERE G.OPTTYPE = '1' AND G.OPTPHOTO = '1' AND OPTHOT='1' AND G.OPTPRE = '1' AND G.OPTKIND='1,2,3'
	
	--// 베스트 물품		#TMP_OPT_BEST
	SELECT G.ADID, G.USERID, G.LOCALSITE, CASE G.PRNCNT WHEN '10' THEN 'C01P004' WHEN '20' THEN 'C01P005' WHEN '30' THEN 'C01P006' END AS OPTNM, (SELECT OPTPHOTO FROM OPTIONPRICE WHERE  LOCALSITE=G.LOCALSITE AND OPTPRNCNT=G.PRNCNT) AS OPTAMT
	INTO #TMP_OPT_BEST
	FROM GOODSMAIN AS G 
	WHERE G.OPTTYPE = '1' AND G.OPTPHOTO = '1' AND G.OPTPRE = '1' AND G.ADID NOT IN (SELECT ADID FROM #TMP_OPT_FULL)
	
	--// 핫물품			#TMP_OPT_HOT
	SELECT G.ADID, G.USERID, G.LOCALSITE, CASE G.PRNCNT WHEN '10' THEN 'C01P007' WHEN '20' THEN 'C01P008' WHEN '30' THEN 'C01P009' END AS OPTNM, (SELECT OPTHOT FROM OPTIONPRICE WHERE  LOCALSITE=G.LOCALSITE AND OPTPRNCNT=G.PRNCNT) AS OPTAMT
	INTO #TMP_OPT_HOT
	FROM GOODSMAIN AS G 
	WHERE G.OPTTYPE = '1' AND OPTHOT='1' AND G.ADID NOT IN (SELECT ADID FROM #TMP_OPT_FULL)
	
	--// 프리미엄			#TMP_OPT_PRE
	SELECT G.ADID, G.USERID, G.LOCALSITE, CASE G.PRNCNT WHEN '10' THEN 'C01P010' WHEN '20' THEN 'C01P011' WHEN '30' THEN 'C01P012' END AS OPTNM, (SELECT OPTPRE FROM OPTIONPRICE WHERE  LOCALSITE=G.LOCALSITE AND OPTPRNCNT=G.PRNCNT) AS OPTAMT
	INTO #TMP_OPT_PRE
	FROM GOODSMAIN AS G 
	WHERE G.OPTTYPE = '1' AND G.OPTPRE = '1' AND G.ADID NOT IN (SELECT ADID FROM #TMP_OPT_FULL UNION ALL SELECT ADID FROM #TMP_OPT_BEST)
	
	--// 제목볼드			#TMP_OPT_BOLD
	SELECT G.ADID, G.USERID, G.LOCALSITE, CASE G.PRNCNT WHEN '10' THEN 'C01P013' WHEN '20' THEN 'C01P014' WHEN '30' THEN 'C01P015' END AS OPTNM, (SELECT BOLD FROM OPTIONPRICE WHERE  LOCALSITE=G.LOCALSITE AND OPTPRNCNT=G.PRNCNT) AS OPTAMT
	INTO #TMP_OPT_BOLD
	FROM GOODSMAIN AS G 
	WHERE G.OPTTYPE = '1' AND CHARINDEX('1', G.OPTKIND) > 0  AND G.ADID NOT IN (SELECT ADID FROM #TMP_OPT_FULL)
	
	--// 형광배경			#TMP_OPT_BACKGROUND
	SELECT G.ADID, G.USERID, G.LOCALSITE, CASE G.PRNCNT WHEN '10' THEN 'C01P016' WHEN '20' THEN 'C01P017' WHEN '30' THEN 'C01P018' END AS OPTNM, (SELECT BACKGROUND FROM OPTIONPRICE WHERE  LOCALSITE=G.LOCALSITE AND OPTPRNCNT=G.PRNCNT) AS OPTAMT
	INTO #TMP_OPT_BACKGROUND
	FROM GOODSMAIN AS G 
	WHERE G.OPTTYPE = '1' AND CHARINDEX('2', G.OPTKIND) > 0  AND G.ADID NOT IN (SELECT ADID FROM #TMP_OPT_FULL)
	
	--// 깜박임			#TMP_OPT_BLINK
	SELECT G.ADID, G.USERID, G.LOCALSITE, CASE G.PRNCNT WHEN '10' THEN 'C01P019' WHEN '20' THEN 'C01P020' WHEN '30' THEN 'C01P021' END AS OPTNM, (SELECT BLINK FROM OPTIONPRICE WHERE  LOCALSITE=G.LOCALSITE AND OPTPRNCNT=G.PRNCNT) AS OPTAMT
	INTO #TMP_OPT_BLINK
	FROM GOODSMAIN AS G 
	WHERE G.OPTTYPE = '1' AND CHARINDEX('3', G.OPTKIND) > 0  AND G.ADID NOT IN (SELECT ADID FROM #TMP_OPT_FULL)
	
	--// 키워드			#TMP_OPT_KEYWORD
	SELECT G.ADID, G.USERID, G.LOCALSITE, CASE G.PRNCNT WHEN '10' THEN 'C01P022' WHEN '20' THEN 'C01P023' WHEN '30' THEN 'C01P024' END AS OPTNM, (SELECT KEYWORD FROM OPTIONPRICE WHERE  LOCALSITE=G.LOCALSITE AND OPTPRNCNT=G.PRNCNT) AS OPTAMT
	INTO #TMP_OPT_KEYWORD
	FROM GOODSMAIN AS G 
	WHERE G.OPTTYPE = '1' AND G.KEYWORD = '1'
	
	--// 상점형			#TMP_OPT_STORE
	SELECT G.ADID, G.USERID, G.LOCALSITE, 'C01P025' AS OPTNM, (SELECT STORE FROM OPTIONPRICE WHERE LOCALSITE=G.LOCALSITE AND OPTPRNCNT=G.PRNCNT) AS OPTAMT
	INTO #TMP_OPT_STORE
	FROM GOODSMAIN AS G 
	WHERE SPECFLAG='4'



/* ==========================================================================================
	최종 결재상품 입력		#TMP_AD_TB
	==========================================================================================*/

	SELECT 
		'S107' AS SECTION_CD, 							-- 섹션코드
		CASE G.LOCALSITE WHEN '0' THEN 'www' 
		WHEN '2' THEN '031'
		WHEN '3' THEN '042'
		WHEN '4' THEN '062'
		WHEN '5' THEN '053'
		WHEN '6' THEN '051'
		END AS SUB_SECTION_CD,							-- 지역코드
		LEFT(G.OPTNM,3) AS PROD_TYPE_CD,				-- 상품유형코드
		RIGHT(G.OPTNM,4) AS PROD_CD,					-- 상품코드
		'정상' AS PAY_CONDITION_NM,						-- 결재상태
		D.GRPSERIAL AS ORDER_CD,						-- 주문번호
		D.ADID AS ADID,									-- 광고번호
		G.USERID AS USERID,								-- 주문자 ID
		CONVERT(CHAR(8), R.RECDATE, 112) + REPLACE(CONVERT(CHAR(5), R.RECDATE, 108), ':', '') AS PAY_REG_DT,	-- 결재일
		'SP01' AS SALE_PATH_CD,							-- 유통경로코드
		CASE WHEN R.INIPAYTID IS NULL THEN '통장입금'
		WHEN R.CHARGEKIND='1' THEN '가상계좌'
		WHEN R.CHARGEKIND='2' THEN '카드'
		WHEN R.CHARGEKIND='3' THEN '휴대폰'
		END AS PAY_TYPE_NM,								-- 결재유형
		(SELECT PROD_NM FROM FINDCOMMON.DBO.CC_PRODUCT_TB WHERE PROD_TYPE_CD=LEFT(G.OPTNM,3) AND PROD_CD=RIGHT(OPTNM,4) AND SECTION_CD='S107') AS PROD_NM,							-- 상품명
		NULL AS COMPANY_NM,								-- 회원명 (기업회원은 회사명)
		1 AS CNT,										-- 수량
		G.OPTAMT AS AMT,								-- 단가
		D.PRNAMT AS TOTAL_AMT,							-- 결재총액
		R.INIPAYTID AS PAY_ID,							-- 결재번호
		' ' AS SALE_DEP,								-- 판매조직
		' ' AS SALE_ID									-- 판매자 ID
	INTO #TMP_AD_TB
	FROM RECCHARGE AS R
	LEFT JOIN RECCHARGEDETAIL AS D ON D.GRPSERIAL = R.GRPSERIAL
	LEFT JOIN (
		SELECT * FROM #TMP_OPT_FULL
		UNION ALL SELECT * FROM #TMP_OPT_BEST
		UNION ALL SELECT * FROM #TMP_OPT_HOT
		UNION ALL SELECT * FROM #TMP_OPT_PRE
		UNION ALL SELECT * FROM #TMP_OPT_BOLD
		UNION ALL SELECT * FROM #TMP_OPT_BACKGROUND
		UNION ALL SELECT * FROM #TMP_OPT_BLINK
		UNION ALL SELECT * FROM #TMP_OPT_KEYWORD
		UNION ALL SELECT * FROM #TMP_OPT_STORE
	) AS G ON D.ADID = G.ADID
	WHERE 
--		R.RECDATE > DATEADD(DD, @PRE_DAY,CONVERT(VARCHAR(10), GETDATE(),120)) 
		R.RECDATE >= @DATE_YESTERDAY AND R.RECDATE < @DATE_TODAY
		AND G.ADID=D.ADID
		AND R.RECSTATUS='1' AND D.PRNAMTOK='1'
--		AND R.INIPAYTID IS NOT NULL						-- 온라인 결재는 INIPAYTID에 값이 남지만 등록대행시는 INIPAYTID = NULL 이므로...

/* ==========================================================================================
	정산테이블에 데이터 입력
	==========================================================================================*/
	INSERT INTO FINDCOMMON.DBO.SM_SALE_RAW_TB
		(SECTION_CD,	SUB_SECTION_CD,	PROD_TYPE_CD,	PROD_CD,	PAY_CONDITION_NM,	ORDER_ID,	ADID,	USERID,
		PAY_REG_DT,	SALEPATH_CD,	PAY_TYPE_NM,	PROD_NM,	COMPANY_NM,	CNT,	AMT,	TOTAL_AMT, PAY_ID,	SALE_DEP,	SALE_ID	)
	SELECT * FROM	#TMP_AD_TB WHERE PAY_ID NOT IN (SELECT PAY_ID FROM FINDCOMMON.DBO.SM_SALE_RAW_TB WHERE SECTION_CD='S107')
GO
/****** Object:  StoredProcedure [dbo].[BuyingGoods_Insert]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BuyingGoods_Insert]
(
	  @Code1		int
	, @Code2		int
	, @Code3		int
	, @rdoOption		char
	, @OptUrgent		tinyint
	, @RegTerm		int
	, @cUserID		varchar(50)
	, @UserName		varchar(30)
	, @ZipMain		varchar(20)
	, @ZipSub 		varchar(20)
	, @LocalBranch		int
	, @Phone 		varchar(50)
	, @HPhone 		varchar(50)
	, @Email 		varchar(50)
	, @IPAddr 		varchar(20)
	, @PartnerGbn 		int
	, @TagYN		tinyint

	, @BrandNmDt 		varchar(100)
	, @BrandNm 		varchar(100)
	, @ProCorp 		varchar(50)
	, @UseGbn 		tinyint
	, @GoodsQt 		int
	, @BuyAmt 		int
	, @Contents 		text
	, @ZipCode 		varchar(10)
	, @AddNm01 		varchar(100)
	, @AddNm02 		varchar(100)
	, @LocalSite		int

--	, @MergeText		varchar(6000)
	, @ShowLocalSite		tinyint
	, @DealPriceYN	char(1)
	, @CUID INT = NULL
)
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

DECLARE @AdId int

INSERT INTO GoodsMain 
( 
	Code1, Code2, Code3, OptType, OptUrgent, PrnstDate, PrnEnDate, PrnCnt
	, UserID, UserName, ZipMain, ZipSub, LocalBranch, Phone, HPhone, Email, IPAddr 
	, StateChk, RegDate, EscrowYN, PartnerCode, AdGbn, LocalSite, ShowLocalSite
	, CUID 
) 
VALUES 
( 
	  @Code1
	, @Code2
	, @Code3
	, @rdoOption
	, @OptUrgent
	, Getdate() 
	, ( GetDate() + @RegTerm ) 
	, @RegTerm
	, @cUserID 
	, @UserName 
	, @ZipMain 
	, @ZipSub 
	, @LocalBranch
	, @Phone 
	, @HPhone 
	, @Email 
	, @IPAddr 
	, '6' 
	, GetDate() 
	, 'N'
	, @PartnerGbn 
	, '1'
	, @LocalSite
	, @ShowLocalSite
	, @CUID
)

SELECT @AdId = SCOPE_IDENTITY()

INSERT INTO GoodsSubBuy 
(
	Adid, BrandNmDt, BrandNm, ProCorp, UseGbn, GoodsQt
	, BuyAmt, Contents, TagYN, DealAreaMain, DealAreaSub, ZipCode, Addr1, Addr2, DealPriceYN
) 
VALUES 
(
	  @Adid 
	, @BrandNmDt 
	, @BrandNm 
	, @ProCorp 
	, @UseGbn 
	, @GoodsQt 
	, @BuyAmt 
	, @Contents 
	, @TagYN 
	, @ZipMain 
	, @ZipSub 
	, @ZipCode 
	, @AddNm01 
	, @AddNm02 
	, @DealPriceYN
)

--INSERT INTO GoodsMergeText ( AdId, MergeText ) VALUES ( @AdId, @MergeText)

SELECT @AdId
GO
/****** Object:  StoredProcedure [dbo].[CreateMainList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CreateMainList]

AS

--#Temp 테이블 생성 
--DROP TABLE #TempMain 

CREATE TABLE #TempMain 
(
	  AdId 		int
	, BrandNm	varchar(100)
	, BrandNmDt	varchar(100)
	, Opt 		tinyint
	, OptKind 	varchar(20)
	, UseGbn 	tinyint
	, WishAmt	int
	, ViewCnt 	int
	, PicIdx1 	int
	, PicIdx2 	int	
	, PicImage 	varchar(50)
	, LocalSite 	int
	, EscrowYN 	char(1)
	, SpecFlag 	char(1)	
	, Code2 		int
)

DECLARE @LocalSite int
Select LocalSite into #Temp_LocalSite From LocalSite group by LocalSite

DECLARE Cnt_Cursor CURSOR FOR
SELECT LocalSite from #Temp_LocalSite
	
OPEN Cnt_Cursor
FETCH NEXT FROM Cnt_Cursor
INTO @LocalSite
	
	WHILE @@FETCH_STATUS = 0
	
	BEGIN	
		
		--지역별 옵션 쿼리
		DECLARE @SqlLocalGoods varchar(500)
		DECLARE @SqlOptLocalGoods varchar(500)
			
		IF @LocalSite =0
			BEGIN
				SET @SqlOptLocalGoods = ' AND B.LocalSite = 0 '
				--SET @SqlOptLocalGoods = ' AND B.LocalSite=' + Convert(varchar(2),@LocalSite)	
				SET @SqlLocalGoods = '' 
			END
		ELSE
			BEGIN
				SET @SqlOptLocalGoods = ' AND (B.LocalSite = 0  OR B.LocalSite=' + Convert(varchar(2),@LocalSite) + ') '
				SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0  OR B.ShowLocalSite=' + Convert(varchar(2),@LocalSite) + ') '
				--SET @SqlLocalGoods = ' AND B.ShowLocalSite=' + Convert(varchar(2),@LocalSite)
				--SET @SqlLocalGoods = ' AND ( B.LocalBranch in (Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + Convert(varchar(2),@LocalSite) + ') OR B.ZipMain = ''전국'' ) '
			END

			DECLARE @strQuery nvarchar(4000)
-------------------------------------------------------------------------------------------------------------------------------------------				
--포토스페셜 (10개)	
-------------------------------------------------------------------------------------------------------------------------------------------										
			SET @strQuery = 
					' Insert into #TempMain ' +
					' (AdId, BrandNm, BrandNmDt, WishAmt, UseGbn, Opt, OptKind, ViewCnt, PicIdx1,PicIdx2, PicImage, LocalSite, EscrowYN, SpecFlag, Code2) ' +
					' SELECT  Distinct  ' + 
					' A.AdId, A.BrandNm, A.BrandNmDt, A.WishAmt, A.UseGbn, 1, B.OptKind, B.ViewCnt, Isnull(A.PicIdx1,0), Isnull(A.PicIdx2,0), P.PicImage, ' + Convert(varchar(2),@LocalSite) + ', B.EscrowYN, B.SpecFlag, B.Code2 ' +
					' FROM GoodsSubSale A WITH (NoLock) ' +
					' LEFT JOIN GoodsMain B WITH (NoLock) ON A.AdId = B.AdId ' +
					' LEFT JOIN (Select AdId, PicImage From GoodsPic with (Nolock) Where PicIdx = 5) AS P ON A.AdId = P.AdId ' +
					' WHERE ' +
					' B.DelFlag = ''0'' ' +
					' AND B.SpecFlag <> ''1'' ' +
					' AND B.SaleOkFlag<>''1'' ' +
					' AND B.RegAmtOk = ''1'' ' +
					' AND B.PrnAmtOk = ''1'' ' +
					' AND OptPhoto=1 ' +
					' AND B.PrnEnDate >= GETDATE() ' +
					' AND B.StateChk = ''1''  ' + @SqlOptLocalGoods 
		
			--print @strQuery
			execute sp_executesql @strQuery
		
-------------------------------------------------------------------------------------------------------------------------------------------
--추천물품(5개) : 옵션변경작업시 삭제
-------------------------------------------------------------------------------------------------------------------------------------------						
--			SET @strQuery = 
--					' Insert into #TempMain ' +
--					' (AdId, BrandNm, BrandNmDt, WishAmt, UseGbn, Opt, OptKind, ViewCnt, PicIdx1,PicIdx2, PicImage, LocalSite, EscrowYN, SpecFlag, Code2) ' +
--					' SELECT  Distinct  ' + 
--					' A.AdId, A.BrandNm, A.BrandNmDt, A.WishAmt, A.UseGbn, 2, B.OptKind, B.ViewCnt, Isnull(A.PicIdx1,0), isnull(A.PicIdx2,0), P.PicImage, ' + Convert(varchar(2),@LocalSite) + ', B.EscrowYN, B.SpecFlag, B.Code2 ' +
--					' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted) ' + 
--					' , (Select AdId, PicImage From GoodsPic with (Nolock) Where PicIdx = 5) P  ' + 
--					' WHERE A.AdId = B.AdId ' +
--					' AND A.AdId = P.AdId ' +
--					' AND B.DelFlag = ''0'' ' +
--					' AND B.SpecFlag <> ''1'' ' +
--					' AND B.SaleOkFlag<>''1'' ' +
--					' AND B.RegAmtOk = ''1'' ' +
--					' AND B.PrnAmtOk = ''1'' ' +
--					' AND OptRecom=1 ' +
--					' AND B.PrnEnDate >= GETDATE() ' +
--					' AND B.StateChk = ''1'' ' + @SqlLocalGoods 
--			print @strQuery
--			execute sp_executesql @strQuery
		
-------------------------------------------------------------------------------------------------------------------------------------------
--핫 물품(20개)
-------------------------------------------------------------------------------------------------------------------------------------------					
			SET @strQuery = 
					' Insert into #TempMain ' +
					' (AdId, BrandNm, BrandNmDt, WishAmt, UseGbn, Opt, OptKind, ViewCnt, PicIdx1,PicIdx2, LocalSite, EscrowYN, SpecFlag, Code2) ' +
					' SELECT  Distinct  ' + 
					' A.AdId, A.BrandNm, A.BrandNmDt, A.WishAmt, A.UseGbn, 0, B.OptKind,B.ViewCnt,Isnull(A.PicIdx1,0), isnull(A.PicIdx2,0), ' + Convert(varchar(2),@LocalSite) + ', B.EscrowYN, B.SpecFlag, B.Code2 ' +
					' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted) ' + 
					' WHERE A.AdId = B.AdId ' +
					' AND B.DelFlag = ''0'' ' +
					' AND B.SpecFlag <> ''1'' ' +
					' AND B.SaleOkFlag<>''1'' ' +
					' AND B.RegAmtOk = ''1'' ' +
					' AND B.PrnAmtOk = ''1'' ' +
					' AND OptHot=1 ' +
					' AND B.PrnEnDate >= GETDATE() ' +
					' AND B.StateChk = ''1'' ' + @SqlOptLocalGoods 
			--print @strQuery
			execute sp_executesql @strQuery

-------------------------------------------------------------------------------------------------------------------------------------------
--주간TOP5조회물품(5개)
-------------------------------------------------------------------------------------------------------------------------------------------					
			SET @strQuery = 
					' Insert into #TempMain ' +
					' (AdId, BrandNm, BrandNmDt, WishAmt, UseGbn, Opt, OptKind, ViewCnt, PicIdx1,PicIdx2, LocalSite, EscrowYN, SpecFlag, Code2) ' +
					' SELECT  Distinct TOP 10 ' + 
					' A.AdId, A.BrandNm, A.BrandNmDt, A.WishAmt, A.UseGbn, 3, B.OptKind,B.ViewCnt,Isnull(A.PicIdx1,0), isnull(A.PicIdx2,0), ' + Convert(varchar(2),@LocalSite) + ', B.EscrowYN, B.SpecFlag, B.Code2 ' +
					' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted) ' + 
					' WHERE A.AdId = B.AdId ' +
					' AND B.DelFlag = ''0'' ' +
					' AND B.SpecFlag <> ''1'' ' +
					' AND B.SaleOkFlag<>''1'' ' +
					' AND B.RegAmtOk = ''1'' ' +
--					' AND B.PrnAmtOk = ''1'' ' +
--					' AND B.PrnEnDate >= GETDATE() ' +
					'  AND B.RegDate > GETDATE()-7 ' +
					' AND B.StateChk = ''1'' ' + @SqlLocalGoods + ' ORDER BY B.ViewCnt DESC '
			--print @strQuery
			execute sp_executesql @strQuery
-------------------------------------------------------------------------------------------------------------------------------------------

		FETCH NEXT FROM Cnt_Cursor
		INTO @LocalSite
	
	END
	
	CLOSE Cnt_Cursor
	DEALLOCATE Cnt_Cursor

-------------------------------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE dbo.GoodsMainDisplay

	INSERT INTO dbo.GoodsMainDisplay (AdId, BrandNm, BrandNmDt, Opt, OptKind, UseGbn, WishAmt, ViewCnt, PicIdx1, PicIdx2, PicImage, LocalSite, EscrowYN, SpecFlag, Code2)
	
	SELECT AdId, BrandNm, BrandNmDt, Opt, OptKind, UseGbn, WishAmt, ViewCnt, PicIdx1, PicIdx2, PicImage,LocalSite, EscrowYN, SpecFlag, Code2 FROM #TempMain
-------------------------------------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[CreateMainListLocal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CreateMainListLocal]
	   @LocalSite int
AS
--#Temp 테이블 생성 
--DROP TABLE #TempMain 
CREATE TABLE #TempMain 
(
	 AdId 		int
	, BrandNm	varchar(100)
	, BrandNmDt	varchar(100)
	, Opt 		tinyint
	, OptKind 	varchar(20)
	, UseGbn 	tinyint
	, WishAmt	int
	, ViewCnt 	int
	, PicIdx1 	int
	, PicIdx2 	int	
	, PicImage 	varchar(50)
	, LocalSite 	int
	, EscrowYN 	char(1)
	, SpecFlag 	char(1)
	, Code2		int
		
)

--지역별 옵션 쿼리
DECLARE @SqlLocalGoods varchar(500)
DECLARE @SqlOptLocalGoods varchar(500)

IF @LocalSite =0
	BEGIN
		SET @SqlOptLocalGoods = ' AND B.LocalSite = 0 '
		SET @SqlLocalGoods = '' 
	END
ELSE
	BEGIN
		SET @SqlOptLocalGoods = ' AND (B.LocalSite = 0  OR B.LocalSite=' + Convert(varchar(2),@LocalSite) + ') '
		SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0  OR B.ShowLocalSite=' + Convert(varchar(2),@LocalSite) + ') '

	--	SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
	--	                                      ' (Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + Convert(varchar(2),@LocalSite) + ') ' +
	--			          ' OR B.ZipMain = ''전국'' ) '
	END

DECLARE @strQuery nvarchar(4000)
-------------------------------------------------------------------------------------------------------------------------------------------						
--포토스페셜 (10개)	
-------------------------------------------------------------------------------------------------------------------------------------------									
	SET @strQuery = 
			' Insert into #TempMain ' +
			' (AdId, BrandNm, BrandNmDt, WishAmt, UseGbn, Opt, OptKind, ViewCnt, PicIdx1,PicIdx2, PicImage, LocalSite, EscrowYN, SpecFlag, Code2) ' +
			' SELECT  Distinct  ' + 
			' A.AdId, A.BrandNm, A.BrandNmDt, A.WishAmt, A.UseGbn, 1, B.OptKind, B.ViewCnt, Isnull(A.PicIdx1,0), isnull(A.PicIdx2,0), P.PicImage, ' + Convert(varchar(2),@LocalSite) + ', B.EscrowYN, B.SpecFlag, B.Code2 ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted) ' + 
			' , (Select AdId, PicImage From GoodsPic with (Nolock) Where PicIdx = 5) P  ' + 
			' WHERE A.AdId = B.AdId ' +
			' AND A.AdId = P.AdId ' +
			' AND B.DelFlag = ''0'' ' +
			' AND B.SpecFlag <> ''1'' ' +
			' AND B.SaleOkFlag<>''1'' ' +
			' AND B.RegAmtOk = ''1'' ' +
			' AND B.PrnAmtOk = ''1'' ' +
			' AND OptPhoto=1 ' +
			' AND B.PrnEnDate >= GETDATE() ' +
			' AND B.StateChk = ''1'' ' + @SqlOptLocalGoods 

	print @strQuery
	execute sp_executesql @strQuery
		
-------------------------------------------------------------------------------------------------------------------------------------------							
--추천물품(5개)
-------------------------------------------------------------------------------------------------------------------------------------------						
--	SET @strQuery = 
--			' Insert into #TempMain ' +
--			' (AdId, BrandNm, BrandNmDt, WishAmt, UseGbn, Opt, OptKind, ViewCnt, PicIdx1,PicIdx2, PicImage, LocalSite, EscrowYN, SpecFlag, Code2) ' +
--			' SELECT  Distinct  ' + 
--			' A.AdId, A.BrandNm, A.BrandNmDt, A.WishAmt, A.UseGbn, 2, B.OptKind, B.ViewCnt, Isnull(A.PicIdx1,0), isnull(A.PicIdx2,0), P.PicImage, ' + Convert(varchar(2),@LocalSite) + ', B.EscrowYN, B.SpecFlag, B.Code2 ' +
--			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted) ' + 
--			' , (Select AdId, PicImage From GoodsPic with (Nolock) Where PicIdx = 5) P  ' + 
--			' WHERE A.AdId = B.AdId ' +
--			' AND A.AdId = P.AdId ' +
--			' AND B.DelFlag = ''0'' ' +
--			' AND B.SpecFlag <> ''1'' ' +
--			' AND B.SaleOkFlag<>''1'' ' +
--			' AND B.RegAmtOk = ''1'' ' +
--			' AND B.PrnAmtOk = ''1'' ' +
--			' AND OptRecom=1 ' +
--			' AND B.PrnEnDate >= GETDATE() ' +
--			' AND B.StateChk = ''1''  ' + @SqlLocalGoods 
--	print @strQuery
--	execute sp_executesql @strQuery

-------------------------------------------------------------------------------------------------------------------------------------------						
--핫 물품(20개)
-------------------------------------------------------------------------------------------------------------------------------------------								
	SET @strQuery = 
			' Insert into #TempMain ' +
			' (AdId, BrandNm, BrandNmDt, WishAmt, UseGbn, Opt, OptKind, ViewCnt, PicIdx1,PicIdx2, LocalSite, EscrowYN, SpecFlag, Code2) ' +
			' SELECT  Distinct  ' + 
			' A.AdId, A.BrandNm, A.BrandNmDt, A.WishAmt, A.UseGbn, 0, B.OptKind,B.ViewCnt,Isnull(A.PicIdx1,0), isnull(A.PicIdx2,0), ' + Convert(varchar(2),@LocalSite) + ', B.EscrowYN, B.SpecFlag, B.Code2 ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted) ' + 
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag = ''0'' ' +
			' AND B.SpecFlag <> ''1'' ' +
			' AND B.SaleOkFlag<>''1'' ' +
			' AND B.RegAmtOk = ''1'' ' +
			' AND B.PrnAmtOk = ''1'' ' +
			' AND OptHot=1 ' +
			' AND B.PrnEnDate >= GETDATE() ' +
			' AND B.StateChk = ''1''  ' + @SqlOptLocalGoods 
	print @strQuery
	execute sp_executesql @strQuery

-------------------------------------------------------------------------------------------------------------------------------------------
--주간TOP5조회물품(5개)
-------------------------------------------------------------------------------------------------------------------------------------------					
	SET @strQuery = 
			' Insert into #TempMain ' +
			' (AdId, BrandNm, BrandNmDt, WishAmt, UseGbn, Opt, OptKind, ViewCnt, PicIdx1,PicIdx2, LocalSite, EscrowYN, SpecFlag, Code2) ' +
			' SELECT  Distinct  TOP 10 ' + 
			' A.AdId, A.BrandNm, A.BrandNmDt, A.WishAmt, A.UseGbn, 3, B.OptKind,B.ViewCnt,Isnull(A.PicIdx1,0), isnull(A.PicIdx2,0), ' + Convert(varchar(2),@LocalSite) + ', B.EscrowYN, B.SpecFlag, B.Code2 ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted) ' + 
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag = ''0'' ' +
			' AND B.SpecFlag <> ''1'' ' +
			' AND B.SaleOkFlag<>''1'' ' +
			' AND B.RegAmtOk = ''1'' ' +
--			' AND B.PrnAmtOk = ''1'' ' +
--			' AND B.PrnEnDate >= GETDATE() ' +
			' AND B.RegDate > GETDATE()-7 ' +
			' AND B.StateChk = ''1'' ' + @SqlLocalGoods + ' ORDER BY B.ViewCnt DESC '
	print @strQuery
	execute sp_executesql @strQuery
-------------------------------------------------------------------------------------------------------------------------------------------							

	Delete dbo.GoodsMainDisplay where LocalSite = @LocalSite

	INSERT INTO dbo.GoodsMainDisplay (AdId, BrandNm, BrandNmDt, Opt, OptKind, UseGbn, WishAmt, ViewCnt, PicIdx1, PicIdx2, PicImage, LocalSite, EscrowYN, SpecFlag, Code2)
	
	SELECT AdId, BrandNm, BrandNmDt, Opt, OptKind, UseGbn, WishAmt, ViewCnt, PicIdx1, PicIdx2, PicImage, LocalSite, EscrowYN, SpecFlag, Code2 FROM #TempMain
-------------------------------------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[CUID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
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
	
	UPDATE A SET CUID=@MASTER_CUID FROM Auction A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM BadUserUsed A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM EsKiccTrans A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM EsOnLine A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM Event021008 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM GoodsMain A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM GoodsMain_Save A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM GoodsMain2 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM GoodsMainAdmin A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM GoodsMainCovt A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM KiccTrans A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM MsgBoard A  where CUID=@SLAVE_CUID
	UPDATE A SET SALE_CUID=@MASTER_CUID FROM MsgBoard A  where SALE_CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM NotPaperUser A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM Sale_BuyerInfo A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM SaleAgency A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM SellerMiniShop A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM TaxEtcInfo A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM USED_REG_CNT A  where CUID=@SLAVE_CUID
	/*
	INSERT CUID_CHANGE_HISTORY_TB (B_CUID, N_CUID, USERID, DB_NAME, USERIP)
		SELECT @MASTER_CUID , @SLAVE_CUID,@MASTER_USERID,DB_NAME(),@CLIENT_IP
*/		
END







GO
/****** Object:  StoredProcedure [dbo].[dt_addtosourcecontrol]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_addtosourcecontrol]
    @vchSourceSafeINI varchar(255) = '',
    @vchProjectName   varchar(255) ='',
    @vchComment       varchar(255) ='',
    @vchLoginName     varchar(255) ='',
    @vchPassword      varchar(255) =''

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId = 0

declare @iStreamObjectId int
select @iStreamObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

declare @vchDatabaseName varchar(255)
select @vchDatabaseName = db_name()

declare @iReturnValue int
select @iReturnValue = 0

declare @iPropertyObjectId int
declare @vchParentId varchar(255)

declare @iObjectCount int
select @iObjectCount = 0

    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError


    /* Create Project in SS */
    exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
											'AddProjectToSourceSafe',
											NULL,
											@vchSourceSafeINI,
											@vchProjectName output,
											@@SERVERNAME,
											@vchDatabaseName,
											@vchLoginName,
											@vchPassword,
											@vchComment


    if @iReturn <> 0 GOTO E_OAError

    /* Set Database Properties */

    begin tran SetProperties

    /* add high level object */

    exec @iPropertyObjectId = dbo.dt_adduserobject_vcs 'VCSProjectID'

    select @vchParentId = CONVERT(varchar(255),@iPropertyObjectId)

    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSProjectID', @vchParentId , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSProject' , @vchProjectName , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSourceSafeINI' , @vchSourceSafeINI , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSQLServer', @@SERVERNAME, NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSQLDatabase', @vchDatabaseName, NULL

    if @@error <> 0 GOTO E_General_Error

    commit tran SetProperties
    
    select @iObjectCount = 0;

CleanUp:
    select @vchProjectName
    select @iObjectCount
    return

E_General_Error:
    /* this is an all or nothing.  No specific error messages */
    goto CleanUp

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_addtosourcecontrol_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_addtosourcecontrol_u]
    @vchSourceSafeINI nvarchar(255) = '',
    @vchProjectName   nvarchar(255) ='',
    @vchComment       nvarchar(255) ='',
    @vchLoginName     nvarchar(255) ='',
    @vchPassword      nvarchar(255) =''

as
	-- This procedure should no longer be called;  dt_addtosourcecontrol should be called instead.
	-- Calls are forwarded to dt_addtosourcecontrol to maintain backward compatibility
	set nocount on
	exec dbo.dt_addtosourcecontrol 
		@vchSourceSafeINI, 
		@vchProjectName, 
		@vchComment, 
		@vchLoginName, 
		@vchPassword
GO
/****** Object:  StoredProcedure [dbo].[dt_adduserobject]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 탈퇴 처리(전날 탈퇴 신청 회원 정보)
 *  작   성   자 : 문해린
 *  작   성   일 : 2007-12-20
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 섹션별 불량회원 관리함. 
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 

 *************************************************************************************/


CREATE PROC [dbo].[dt_adduserobject]
as
	set nocount on
	/*
	** Create the user object if it does not exist already
	*/
	begin transaction
		insert dbo.dtproperties (property) VALUES ('DtgSchemaOBJECT')
		update dbo.dtproperties set objectid=@@identity 
			where id=@@identity and property='DtgSchemaOBJECT'
	commit
	return @@identity
GO
/****** Object:  StoredProcedure [dbo].[dt_adduserobject_vcs]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_adduserobject_vcs]
    @vchProperty varchar(64)

as

set nocount on

declare @iReturn int
    /*
    ** Create the user object if it does not exist already
    */
    begin transaction
        select @iReturn = objectid from dbo.dtproperties where property = @vchProperty
        if @iReturn IS NULL
        begin
            insert dbo.dtproperties (property) VALUES (@vchProperty)
            update dbo.dtproperties set objectid=@@identity
                    where id=@@identity and property=@vchProperty
            select @iReturn = @@identity
        end
    commit
    return @iReturn
GO
/****** Object:  StoredProcedure [dbo].[dt_checkinobject]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_checkinobject]
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255)='',
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)='',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     Text = '', /* drop stream   */ /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     Text = '', /* create stream */
    @txStream3     Text = ''  /* grant stream  */


as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0
	declare @iStreamObjectId int

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iPropertyObjectId int
	select @iPropertyObjectId  = 0

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    declare @iReturnValue	  int
    declare @pos			  int
    declare @vchProcLinePiece varchar(255)

    
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        if @iActionFlag = 1
        begin
            /* Procedure Can have up to three streams
            Drop Stream, Create Stream, GRANT stream */

            begin tran compile_all

            /* try to compile the streams */
            exec (@txStream1)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream2)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream3)
            if @@error <> 0 GOTO E_Compile_Fail
        end

        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT
        if @iReturn <> 0 GOTO E_OAError
        
        if @iActionFlag = 1
        begin
            
            declare @iStreamLength int
			
			select @pos=1
			select @iStreamLength = datalength(@txStream2)
			
			if @iStreamLength > 0
			begin
			
				while @pos < @iStreamLength
				begin
						
					select @vchProcLinePiece = substring(@txStream2, @pos, 255)
					
					exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'AddStream', @iReturnValue OUT, @vchProcLinePiece
            		if @iReturn <> 0 GOTO E_OAError
            		
					select @pos = @pos + 255
					
				end
            
				exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
														'CheckIn_StoredProcedure',
														NULL,
														@sProjectName = @vchProjectName,
														@sSourceSafeINI = @vchSourceSafeINI,
														@sServerName = @vchServerName,
														@sDatabaseName = @vchDatabaseName,
														@sObjectName = @vchObjectName,
														@sComment = @vchComment,
														@sLoginName = @vchLoginName,
														@sPassword = @vchPassword,
														@iVCSFlags = @iVCSFlags,
														@iActionFlag = @iActionFlag,
														@sStream = ''
                                        
			end
        end
        else
        begin
        
            select colid, text into #ProcLines
            from syscomments
            where id = object_id(@vchObjectName)
            order by colid

            declare @iCurProcLine int
            declare @iProcLines int
            select @iCurProcLine = 1
            select @iProcLines = (select count(*) from #ProcLines)
            while @iCurProcLine <= @iProcLines
            begin
                select @pos = 1
                declare @iCurLineSize int
                select @iCurLineSize = len((select text from #ProcLines where colid = @iCurProcLine))
                while @pos <= @iCurLineSize
                begin                
                    select @vchProcLinePiece = convert(varchar(255),
                        substring((select text from #ProcLines where colid = @iCurProcLine),
                                  @pos, 255 ))
                    exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'AddStream', @iReturnValue OUT, @vchProcLinePiece
                    if @iReturn <> 0 GOTO E_OAError
                    select @pos = @pos + 255                  
                end
                select @iCurProcLine = @iCurProcLine + 1
            end
            drop table #ProcLines

            exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
													'CheckIn_StoredProcedure',
													NULL,
													@sProjectName = @vchProjectName,
													@sSourceSafeINI = @vchSourceSafeINI,
													@sServerName = @vchServerName,
													@sDatabaseName = @vchDatabaseName,
													@sObjectName = @vchObjectName,
													@sComment = @vchComment,
													@sLoginName = @vchLoginName,
													@sPassword = @vchPassword,
													@iVCSFlags = @iVCSFlags,
													@iActionFlag = @iActionFlag,
													@sStream = ''
        end

        if @iReturn <> 0 GOTO E_OAError

        if @iActionFlag = 1
        begin
            commit tran compile_all
            if @@error <> 0 GOTO E_Compile_Fail
        end

    end

CleanUp:
	return

E_Compile_Fail:
	declare @lerror int
	select @lerror = @@error
	rollback tran compile_all
	RAISERROR (@lerror,16,-1)
	goto CleanUp

E_OAError:
	if @iActionFlag = 1 rollback tran compile_all
	exec dbo.dt_displayoaerror @iObjectId, @iReturn
	goto CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_checkinobject_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_checkinobject_u]
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255)='',
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)='',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     text = '',  /* drop stream   */ /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     text = '',  /* create stream */
    @txStream3     text = ''   /* grant stream  */

as	
	-- This procedure should no longer be called;  dt_checkinobject should be called instead.
	-- Calls are forwarded to dt_checkinobject to maintain backward compatibility.
	set nocount on
	exec dbo.dt_checkinobject
		@chObjectType,
		@vchObjectName,
		@vchComment,
		@vchLoginName,
		@vchPassword,
		@iVCSFlags,
		@iActionFlag,   
		@txStream1,		
		@txStream2,		
		@txStream3
GO
/****** Object:  StoredProcedure [dbo].[dt_checkoutobject]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_checkoutobject]
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255),
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId =0

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @vchTempText varchar(255)

	/* this is for our strings */
	declare @iStreamObjectId int
	select @iStreamObjectId = 0

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        /* Procedure Can have up to three streams
           Drop Stream, Create Stream, GRANT stream */

        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'CheckOut_StoredProcedure',
												NULL,
												@sProjectName = @vchProjectName,
												@sSourceSafeINI = @vchSourceSafeINI,
												@sObjectName = @vchObjectName,
												@sServerName = @vchServerName,
												@sDatabaseName = @vchDatabaseName,
												@sComment = @vchComment,
												@sLoginName = @vchLoginName,
												@sPassword = @vchPassword,
												@iVCSFlags = @iVCSFlags,
												@iActionFlag = @iActionFlag

        if @iReturn <> 0 GOTO E_OAError


        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #commenttext (id int identity, sourcecode varchar(255))


        select @vchTempText = 'STUB'
        while @vchTempText is not null
        begin
            exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError
            
            if (@vchTempText = '') set @vchTempText = null
            if (@vchTempText is not null) insert into #commenttext (sourcecode) select @vchTempText
        end

        select 'VCS'=sourcecode from #commenttext order by id
        select 'SQL'=text from syscomments where id = object_id(@vchObjectName) order by colid

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_checkoutobject_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_checkoutobject_u]
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255),
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

	-- This procedure should no longer be called;  dt_checkoutobject should be called instead.
	-- Calls are forwarded to dt_checkoutobject to maintain backward compatibility.
	set nocount on
	exec dbo.dt_checkoutobject
		@chObjectType,  
		@vchObjectName, 
		@vchComment,    
		@vchLoginName,  
		@vchPassword,  
		@iVCSFlags,    
		@iActionFlag
GO
/****** Object:  StoredProcedure [dbo].[dt_displayoaerror]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_displayoaerror]
    @iObject int,
    @iresult int
as

set nocount on

declare @vchOutput      varchar(255)
declare @hr             int
declare @vchSource      varchar(255)
declare @vchDescription varchar(255)

    exec @hr = master.dbo.sp_OAGetErrorInfo @iObject, @vchSource OUT, @vchDescription OUT

    select @vchOutput = @vchSource + ': ' + @vchDescription
    raiserror (@vchOutput,16,-1)

    return
GO
/****** Object:  StoredProcedure [dbo].[dt_displayoaerror_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_displayoaerror_u]
    @iObject int,
    @iresult int
as
	-- This procedure should no longer be called;  dt_displayoaerror should be called instead.
	-- Calls are forwarded to dt_displayoaerror to maintain backward compatibility.
	set nocount on
	exec dbo.dt_displayoaerror
		@iObject,
		@iresult
GO
/****** Object:  StoredProcedure [dbo].[dt_droppropertiesbyid]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Drop one or all the associated properties of an object or an attribute 
**
**	dt_dropproperties objid, null or '' -- drop all properties of the object itself
**	dt_dropproperties objid, property -- drop the property
*/
CREATE PROC [dbo].[dt_droppropertiesbyid]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		delete from dbo.dtproperties where objectid=@id
	else
		delete from dbo.dtproperties 
			where objectid=@id and property=@property
GO
/****** Object:  StoredProcedure [dbo].[dt_dropuserobjectbyid]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Drop an object from the dbo.dtproperties table
*/
CREATE PROC [dbo].[dt_dropuserobjectbyid]
	@id int
as
	set nocount on
	delete from dbo.dtproperties where objectid=@id
GO
/****** Object:  StoredProcedure [dbo].[dt_generateansiname]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* 
**	Generate an ansi name that is unique in the dtproperties.value column 
*/ 
CREATE PROC [dbo].[dt_generateansiname](@name varchar(255) output) 
as 
	declare @prologue varchar(20) 
	declare @indexstring varchar(20) 
	declare @index integer 
 
	set @prologue = 'MSDT-A-' 
	set @index = 1 
 
	while 1 = 1 
	begin 
		set @indexstring = cast(@index as varchar(20)) 
		set @name = @prologue + @indexstring 
		if not exists (select value from dtproperties where value = @name) 
			break 
		 
		set @index = @index + 1 
 
		if (@index = 10000) 
			goto TooMany 
	end 
 
Leave: 
 
	return 
 
TooMany: 
 
	set @name = 'DIAGRAM' 
	goto Leave
GO
/****** Object:  StoredProcedure [dbo].[dt_getobjwithprop]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Retrieve the owner object(s) of a given property
*/
CREATE PROC [dbo].[dt_getobjwithprop]
	@property varchar(30),
	@value varchar(255)
as
	set nocount on

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@value is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and value=@value
GO
/****** Object:  StoredProcedure [dbo].[dt_getobjwithprop_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Retrieve the owner object(s) of a given property
*/
CREATE PROC [dbo].[dt_getobjwithprop_u]
	@property varchar(30),
	@uvalue nvarchar(255)
as
	set nocount on

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@uvalue is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and uvalue=@uvalue
GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
CREATE PROC [dbo].[dt_getpropertiesbyid]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property
GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
CREATE PROC [dbo].[dt_getpropertiesbyid_u]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property
GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_vcs]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_getpropertiesbyid_vcs]
    @id       int,
    @property varchar(64),
    @value    varchar(255) = NULL OUT

as

    set nocount on

    select @value = (
        select value
                from dbo.dtproperties
                where @id=objectid and @property=property
                )
GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_vcs_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_getpropertiesbyid_vcs_u]
    @id       int,
    @property varchar(64),
    @value    nvarchar(255) = NULL OUT

as

    -- This procedure should no longer be called;  dt_getpropertiesbyid_vcsshould be called instead.
	-- Calls are forwarded to dt_getpropertiesbyid_vcs to maintain backward compatibility.
	set nocount on
    exec dbo.dt_getpropertiesbyid_vcs
		@id,
		@property,
		@value output
GO
/****** Object:  StoredProcedure [dbo].[dt_isundersourcecontrol]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_isundersourcecontrol]
    @vchLoginName varchar(255) = '',
    @vchPassword  varchar(255) = '',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @iStreamObjectId int
	select @iStreamObjectId   = 0

	declare @vchTempText varchar(255)

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if (@vchProjectName = '')	set @vchProjectName		= null
    if (@vchSourceSafeINI = '') set @vchSourceSafeINI	= null
    if (@vchServerName = '')	set @vchServerName		= null
    if (@vchDatabaseName = '')	set @vchDatabaseName	= null
    
    if (@vchProjectName is null) or (@vchSourceSafeINI is null) or (@vchServerName is null) or (@vchDatabaseName is null)
    begin
        RAISERROR('Not Under Source Control',16,-1)
        return
    end

    if @iWhoToo = 1
    begin

        /* Get List of Procs in the project */
        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'GetListOfObjects',
												NULL,
												@vchProjectName,
												@vchSourceSafeINI,
												@vchServerName,
												@vchDatabaseName,
												@vchLoginName,
												@vchPassword

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #ObjectList (id int identity, vchObjectlist varchar(255))

        select @vchTempText = 'STUB'
        while @vchTempText is not null
        begin
            exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError
            
            if (@vchTempText = '') set @vchTempText = null
            if (@vchTempText is not null) insert into #ObjectList (vchObjectlist ) select @vchTempText
        end

        select vchObjectlist from #ObjectList order by id
    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_isundersourcecontrol_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_isundersourcecontrol_u]
    @vchLoginName nvarchar(255) = '',
    @vchPassword  nvarchar(255) = '',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as
	-- This procedure should no longer be called;  dt_isundersourcecontrol should be called instead.
	-- Calls are forwarded to dt_isundersourcecontrol to maintain backward compatibility.
	set nocount on
	exec dbo.dt_isundersourcecontrol
		@vchLoginName,
		@vchPassword,
		@iWhoToo
GO
/****** Object:  StoredProcedure [dbo].[dt_removefromsourcecontrol]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_removefromsourcecontrol]

as

    set nocount on

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    exec dbo.dt_droppropertiesbyid @iPropertyObjectId, null

    /* -1 is returned by dt_droppopertiesbyid */
    if @@error <> 0 and @@error <> -1 return 1

    return 0
GO
/****** Object:  StoredProcedure [dbo].[dt_setpropertybyid]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		value -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
CREATE PROC [dbo].[dt_setpropertybyid]
	@id int,
	@property varchar(64),
	@value varchar(255),
	@lvalue image
as
	set nocount on
	declare @uvalue nvarchar(255) 
	set @uvalue = convert(nvarchar(255), @value) 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@value, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @value, @uvalue, @lvalue)
	end
GO
/****** Object:  StoredProcedure [dbo].[dt_setpropertybyid_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		uvalue -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
CREATE PROC [dbo].[dt_setpropertybyid_u]
	@id int,
	@property varchar(64),
	@uvalue nvarchar(255),
	@lvalue image
as
	set nocount on
	-- 
	-- If we are writing the name property, find the ansi equivalent. 
	-- If there is no lossless translation, generate an ansi name. 
	-- 
	declare @avalue varchar(255) 
	set @avalue = null 
	if (@uvalue is not null) 
	begin 
		if (convert(nvarchar(255), convert(varchar(255), @uvalue)) = @uvalue) 
		begin 
			set @avalue = convert(varchar(255), @uvalue) 
		end 
		else 
		begin 
			if 'DtgSchemaNAME' = @property 
			begin 
				exec dbo.dt_generateansiname @avalue output 
			end 
		end 
	end 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@avalue, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @avalue, @uvalue, @lvalue)
	end
GO
/****** Object:  StoredProcedure [dbo].[dt_validateloginparams]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_validateloginparams]
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)
as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchSourceSafeINI varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT

    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError

    exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
											'ValidateLoginParams',
											NULL,
											@sSourceSafeINI = @vchSourceSafeINI,
											@sLoginName = @vchLoginName,
											@sPassword = @vchPassword
    if @iReturn <> 0 GOTO E_OAError

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_validateloginparams_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_validateloginparams_u]
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)
as

	-- This procedure should no longer be called;  dt_validateloginparams should be called instead.
	-- Calls are forwarded to dt_validateloginparams to maintain backward compatibility.
	set nocount on
	exec dbo.dt_validateloginparams
		@vchLoginName,
		@vchPassword
GO
/****** Object:  StoredProcedure [dbo].[dt_vcsenabled]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_vcsenabled]

as

set nocount on

declare @iObjectId int
select @iObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iReturn int
    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 raiserror('', 16, -1) /* Can't Load Helper DLLC */
GO
/****** Object:  StoredProcedure [dbo].[dt_verstamp006]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	This procedure returns the version number of the stored
**    procedures used by legacy versions of the Microsoft
**	Visual Database Tools.  Version is 7.0.00.
*/
CREATE PROC [dbo].[dt_verstamp006]
as
	select 7000
GO
/****** Object:  StoredProcedure [dbo].[dt_verstamp007]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
**	This procedure returns the version number of the stored
**    procedures used by the the Microsoft Visual Database Tools.
**	Version is 7.0.05.
*/
CREATE PROC [dbo].[dt_verstamp007]
as
	select 7005
GO
/****** Object:  StoredProcedure [dbo].[dt_whocheckedout]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_whocheckedout]
        @chObjectType  char(4),
        @vchObjectName varchar(255),
        @vchLoginName  varchar(255),
        @vchPassword   varchar(255)

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        declare @vchReturnValue varchar(255)
        select @vchReturnValue = ''

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'WhoCheckedOut',
												@vchReturnValue OUT,
												@sProjectName = @vchProjectName,
												@sSourceSafeINI = @vchSourceSafeINI,
												@sObjectName = @vchObjectName,
												@sServerName = @vchServerName,
												@sDatabaseName = @vchDatabaseName,
												@sLoginName = @vchLoginName,
												@sPassword = @vchPassword

        if @iReturn <> 0 GOTO E_OAError

        select @vchReturnValue

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_whocheckedout_u]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[dt_whocheckedout_u]
        @chObjectType  char(4),
        @vchObjectName nvarchar(255),
        @vchLoginName  nvarchar(255),
        @vchPassword   nvarchar(255)

as

	-- This procedure should no longer be called;  dt_whocheckedout should be called instead.
	-- Calls are forwarded to dt_whocheckedout to maintain backward compatibility.
	set nocount on
	exec dbo.dt_whocheckedout
		@chObjectType, 
		@vchObjectName,
		@vchLoginName, 
		@vchPassword
GO
/****** Object:  StoredProcedure [dbo].[ES_Buy_Main]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ES_Buy_Main]
(
	@UserID varchar(50)
	,@CUID INT = NULL
)
AS
DECLARE @Sql varchar(4000)
DECLARE @CommonQry varchar(400)
SET @CommonQry = 'SELECT count(B.Serial) from Sale_BuyerInfo B, GoodsMain C, GoodsSubSale G ' + 
		' WHERE ' +
		'B.AdId = C.AdId  AND B.AdId = G.AdId AND ' +
		--'C.StateChk = ''1'' AND ' +
		'B.UserId = '''+@UserID+'''  AND B.CUID = '+CAST(@CUID as varchar)+' '
SET @Sql = @CommonQry +	--입금확인
		' (B.ReceiveChk = ''0'' OR B.ReceiveChk IS NULL) '+
                                ' AND (B.BuyChk = ''0'' OR B.BuyChk IS NULL) '+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL) '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL)  '+
                                ' AND B.ChargeKind = ''1'' ;' +
		@CommonQry +	--발송전
		' B.ReceiveChk = ''1'' '+
                                ' AND ( (B.SendChk = ''0'' OR B.SendChk IS NULL OR B.SendChk = '' '') OR (B.SendChk = ''1'') )  '+
                                ' AND (B.BuyChk = ''0'' OR B.BuyChk IS NULL) '+
                                'AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ;' +
		@CommonQry +	--수령확인
		' B.SendChk = ''2'' '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ;' +
		@CommonQry +	--반품확인
		' (B.SendChk = ''3'' OR B.SendChk = ''4'') '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ;' +
		@CommonQry +	--정상종료
		' B.ReceiveChk = ''1'' '+
                                ' AND B.SendChk = ''2'' '+
                                ' AND B.RemitChk = ''2'' '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ;' +
		@CommonQry +	--환불
		' ((B.ReceiveChk = ''1'' AND B.SendChk = ''4'') OR (B.ReceiveChk = ''1'' AND B.SaleChk = ''1'' ))  '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ;' +
		@CommonQry +	--구매취소
		' B.BuyChk = ''1''  '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ' 
--PRINT(@Sql)
EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[ES_Buy_MainSub]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ES_Buy_MainSub]
(
	@UserID varchar(50),
	@status int,
	@CUID INT = null 
)
AS
DECLARE @Sql varchar(4000)
DECLARE @CommonQry varchar(500)
DECLARE @OrderBy varchar(100)
SET @CommonQry = ' FROM Sale_BuyerInfo B, GoodsMain C, GoodsSubSale G ' +
		' where  ' +
		' B.AdId = C.AdId AND B.AdId = G.AdId AND ' +
		--' C.StateChk = ''1'' AND ' +
		' B.UserId = '''+@UserID+''' AND C.CUID = ' + cast(@CUID as varchar) +' AND '
SET @OrderBy = ' ORDER BY B.Serial DESC ;'
SET @Sql = 
	CASE
		WHEN @status = '1' THEN	--입금확인
		' SELECT B.Serial, CONVERT(char(8),B.RegDate,11) as RegDate,  B.AdId, G.BrandNm as InfoText, C.UserID, '+
                                ' B.WishAmt,  ISNULL(B.ReceiveChk,''0'') as ReceiveChk, C.CUID ' + @CommonQry + ' ' +
		' (B.ReceiveChk = ''0'' OR B.ReceiveChk IS NULL) '+
                                ' AND (B.BuyChk = ''0'' OR B.BuyChk IS NULL) '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL)'+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL)  '+
                                ' AND B.ChargeKind = ''1'' ' + @OrderBy
		WHEN @status = '2' THEN	--발송전
		' SELECT B.Serial, ISNULL(CONVERT(char(8),B.ReceiveDate,11),''0'') as ReceiveDate,  B.AdId, '+
                                ' G.BrandNm as InfoText, C.UserID, B.WishAmt, ISNULL(B.ReceiveChk,''0'') as ReceiveChk, '+
                                ' CASE WHEN B.SendChk = '''' THEN ''0'' WHEN B.SendChk <> '''' THEN B.SendChk END as SendChk, B.SaleChk ' + @CommonQry + ' ' +
		' B.ReceiveChk = ''1''  '+
                                ' AND ( (B.SendChk = ''0'' OR B.SendChk IS NULL OR B.SendChk = '''') '+
                                ' OR (B.SendChk = ''1'') ) '+
                                ' AND (B.BuyChk = ''0'' OR B.BuyChk IS NULL)  '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ' + @OrderBy
		WHEN @status = '3' THEN	--수령확인
		' SELECT B.Serial, CONVERT(char(8),B.SendOkDate,11) as SendOkDate,  B.AdId, G.BrandNm as InfoText, '+
                                ' C.UserID, B.WishAmt, ISNULL(B.ReceiveChk,''0'') as ReceiveChk, ISNULL(B.SendChk,''0'') as SendChk ' + @CommonQry + ' ' +
		' B.SendChk = ''2'' '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ' + @OrderBy
		WHEN @status = '4' THEN	--반품확인
		' SELECT B.Serial, CONVERT(char(8),B.ReturnStDate,11) as ReturnStDate,  B.AdId, G.BrandNm as InfoText, '+
                                ' C.UserID, B.WishAmt, ISNULL(B.ReceiveChk,''0'') as ReceiveChk, ISNULL(B.SendChk,''0'') as SendChk ' + @CommonQry + ' ' +
		' (B.SendChk = ''3'' OR B.SendChk = ''4'') '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ' + @OrderBy
		WHEN @status = '5' THEN	--정상종료
		' SELECT B.Serial, CONVERT(char(8),B.RemitEnDate,11) as RemitEnDate,  B.AdId, G.BrandNm as InfoText, '+
                                ' C.UserID, B.WishAmt, ISNULL(B.RemitChk,''0'') as RemitChk ' + @CommonQry + ' ' +
		' B.ReceiveChk = ''1'' '+
                                ' AND B.SendChk = ''2''  '+
                                ' AND B.RemitChk = ''2'' '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ' + @OrderBy
		WHEN @status = '6' THEN	--환불
		' SELECT B.Serial, CONVERT(char(8),B.SaleChkDate,11) as SaleChkDate, '+
                                ' CONVERT(char(8),B.SendChkDate,11) as SendChkDate, CONVERT(char(8),B.BuyChkDate,11) as BuyChkDate, '+
                                ' CONVERT(char(8),B.RefundEnDate,11) as RefundEnDate,CONVERT(char(8),B.RefundStDate,11) as RefundStDate, '+
                                ' CONVERT(char(8),B.ReturnStDate,11) as ReturnStDate,CONVERT(char(8),B.ReturnEnDate,11) as ReturnEnDate, '+
                                ' B.AdId, G.BrandNm as InfoText, C.UserID, B.WishAmt, ISNULL(B.ReceiveChk,''0'') as ReceiveChk, '+
                                ' CASE WHEN B.SendChk = '''' THEN ''0'' WHEN B.SendChk <> '''' THEN B.SendChk END as SendChk, '+
                                ' ISNULL(B.SaleChk,''0'') as SaleChk, ISNULL(B.BuyChk,''0'') as BuyChk, ISNULL(B.RefundChk,''0'') as RefundChk, B.ChargeKind ' + @CommonQry + ' ' +
		' ((B.ReceiveChk = ''1'' AND B.SendChk = ''4'') OR (B.ReceiveChk = ''1'' AND B.SaleChk = ''1'' )) '+
                                ' AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ' + @OrderBy
		WHEN @status = '7' THEN	--구매취소
		' SELECT B.Serial, CONVERT(char(8),B.BuyChkDate,11) as BuyChkDate,  B.AdId, G.BrandNm as InfoText, '+
                                ' C.UserID, B.WishAmt, ISNULL(B.ReceiveChk,''0'') as ReceiveChk  ' + @CommonQry + ' ' +
		' B.BuyChk = ''1'' '+
                                'AND (B.DelFlagBuy = ''0'' OR B.DelFlagbuy IS NULL) ' + @OrderBy
	END
--PRINT(@Sql)
EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[Es_EsKiccTrans_Insert]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Es_EsKiccTrans_Insert]
(
	@TerminalID varchar(10),
	@order_date varchar(8),
	@sequence_no varchar(8),
	@UserID varchar(50),
	@UserName varchar(50),
	@status_flag char(1)
)
AS
INSERT INTO EsKiccTrans
	(
	TerminalID,
	order_date,
	sequence_no,
	UserID,
	UserName,
                status_flag
	)
VALUES
	(
	@TerminalID,
	@order_date,
	@sequence_no,
	@UserID,
	@UserName,
	@status_flag
	
	)
GO
/****** Object:  StoredProcedure [dbo].[Es_EsOnLine_Insert]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Es_EsOnLine_Insert]
(
	@Serial int,
	@UserID varchar(50),
	@ChargeKind char(1),
	@BankCd char(2),
	@BankNm varchar(30),
	@RecNm varchar(30),
	@RecPhone varchar(30),
	@RecChk char(1)
)
AS
INSERT INTO EsOnLine
	(
	Serial,
	UserID,
	ChargeKind,
	BankCd,
	BankNm,
	RecNm,
	RecPhone,
	RecChk,
	RecDate
	)
VALUES
	(
	@Serial,
	@UserID,
	@ChargeKind,
	@BankCd,
	@BankNm,
	@RecNm,
	@RecPhone,
	@RecChk,
	getdate()
	)
GO
/****** Object:  StoredProcedure [dbo].[Es_OnLine_Insert]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Es_OnLine_Insert]
(
	@AdId int,
	@LocalSite int,
	@UserID varchar(50),
	@Oname varchar(30),
	--@JuminNo varchar(15),
	@OTelNum varchar(20),
	@OCelNum varchar(20),
	@OEmail varchar(30),
	@ChargeKind char(1),
	@Post varchar(10),
	@Address varchar(100),
	@RName varchar(30),
	@TelNum varchar(20),
	@CelNum varchar(20),
	@Description varchar(500),
	@EscrowCharge int,
	@CardChargeClt int,
	@CardChargeCrp int,
	@UserGbn int,
	@PartCommission int,
	@PartAmount int,
	@WishAmt int,	
	@IPaddr varchar(20)
)
AS
DECLARE @Serial int
INSERT INTO Sale_BuyerInfo
	(
	AdId,
	LocalSite,
	UserID,
	UserName,
	--JuminNo,
	Phone,
	HPhone,
	Email,
	ReceiveChk,
	RegDate,
	ChargeKind,
	GetPostNo,
	GetAddress,
	GetName,
	GetPhone,
	GetHPhone,
	GetContents,
	EscrowCharge,
	CardChargeClt,
	CardChargeCrp,
                PartnerCode,
                PartCommission,
                PartAmount,
	WishAmt,
	IPaddr		
	)
VALUES
	(
	@AdId,
	@LocalSite,
	@UserID,
	@Oname,
	--@JuminNo,
	@OTelNum,
	@OCelNum,
	@OEmail,
	0,
	getdate(),
	@ChargeKind,
	@Post,
	@Address,
	@RName,
	@TelNum,
	@CelNum,
	@Description,
	@EscrowCharge,
	@CardChargeClt,
	@CardChargeCrp,
                @UserGbn,
                @PartCommission,
                @PartAmount,
	@WishAmt,
	@IPaddr
	)
SELECT @Serial = @@IDENTITY
SELECT @Serial As Serial
GO
/****** Object:  StoredProcedure [dbo].[ES_SaleBuyerInfo_Insert]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ES_SaleBuyerInfo_Insert]
(
	@AdId 			int,
	@Local			int,
	@UserID 		varchar(50),
	@UserName 		varchar(30),
	--@JuminNo 		varchar(15),
	@Phone 		varchar(20),
	@HPhone 		varchar(20),
	@Email	 		varchar(30),
	@ChargeKind 		char(1),
	@Post 			varchar(10),
	@Address 		varchar(100),
	@Address1 		varchar(100),
	@RName 		varchar(30),
	@RPhone 		varchar(20),
	@RHPhone 		varchar(20),
	@EtcDemand 		varchar(500),
	@EscrowCharge 		int,
	@ChargeCommission 	int,
	@UserGbn 		int,
	@PartCommission	int,
	@PartAmount 		int,
	@OrderQt 		int,	
	@WishAmt 		int,	
	@SalePrice 		int,	
	@BuyReBank		varchar(20),
	@BuyReAccount		varchar(20),
	@BuyReDepositor	varchar(20),
	@IPaddr 		varchar(20)
)
AS
DECLARE @Serial int
INSERT INTO Sale_BuyerInfo
(
	AdId,
	LocalSite,
	UserID,
	UserName,
	--JuminNo,
	Phone,
	HPhone,
	Email,
	ReceiveChk,
	RegDate,
	ChargeKind,
	GetPostNo,
	GetAddress,
	GetAddress1,
	GetName,
	GetPhone,
	GetHPhone,
	GetContents,
	EscrowCharge,
	ChargeCommission,
              PartnerCode,
              PartCommission,
              PartAmount,
	OrderQt,
	WishAmt,
	SalePrice,
	BuyReBank,
	BuyReAccount,
	BuyReDepositor,
	IPaddr,
	StateChk			
)
VALUES
(
	@AdId,
	@Local,
	@UserID,
	@UserName,
	--@JuminNo,
	@Phone,
	@HPhone,
	@Email,
	0,
	GetDate(),
	@ChargeKind,
	@Post,
	@Address,
	@Address1,
	@RName,
	@RPhone,
	@RHPhone,
	@EtcDemand,
	@EscrowCharge,
	@ChargeCommission,
              @UserGbn,
              @PartCommission,
              @PartAmount,
	@OrderQt,
	@WishAmt,
	@SalePrice,
	@BuyReBank,
	@BuyReAccount,
	@BuyReDepositor,
	@IPaddr,
	6
)
SELECT @Serial = @@IDENTITY
SELECT @Serial As Serial
GO
/****** Object:  StoredProcedure [dbo].[ES_Sell_Main]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ES_Sell_Main]
(
	@UserID    varchar(50)   
)
AS
DECLARE @Sql varchar(4000)
DECLARE @CommonQry varchar(400)

SET @CommonQry = 'SELECT count(B.Serial) from Sale_BuyerInfo B, GoodsMain C ' + 
		' WHERE ' +
		'B.AdId = C.AdId AND ' +
		'C.StateChk = ''1'' AND ' +
		'C.UserId = '''+@UserID+'''  AND '

SET @Sql = @CommonQry +	--입금확인
		' (B.ReceiveChk = ''0'' OR B.ReceiveChk IS NULL) '+
                                ' AND (B.BuyChk = ''0'' OR B.BuyChk IS NULL) '+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL)  '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL)  '+
                                ' AND B.ChargeKind = ''1'' ;' +
		@CommonQry +	--발송요청
		' B.ReceiveChk = ''1''  '+
                                ' AND  (B.SendChk = ''0'' OR B.SendChk IS NULL OR B.SendChk = '' '') '+
                                ' AND (B.BuyChk = ''0'' OR B.BuyChk IS NULL) '+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL) '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ;' +
		@CommonQry +	--발송중
		' B.SendChk = ''1'' '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ;' +
		@CommonQry +	--송금요청
		' B.SendChk = ''2'' '+
                                ' AND (B.RemitChk = ''0'' OR B.RemitChk=''1'' ) '+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL) '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ;' +
		@CommonQry +	--정상종료
		' B.ReceiveChk = ''1'' '+
                                ' AND B.SendChk = ''2'' '+
                                ' AND B.RemitChk = ''2'' '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ;' +
		@CommonQry +	--반품
		' ((B.ReceiveChk = ''1'' AND B.SendChk = ''4'') OR (B.ReceiveChk = ''1'' AND B.SendChk = ''3'') OR (B.ReceiveChk = ''1'' AND B.BuyChk = ''1'' ))  '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ;' +
		@CommonQry +	--판매취소
		' B.SaleChk = ''1'' '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ' 
--PRINT(@Sql)
EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[ES_Sell_MainStatus]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCedure [dbo].[ES_Sell_MainStatus]
(
	@UserID    varchar(50),
	@Status	   int
)
AS
DECLARE @Sql varchar(4000)
DECLARE @CommonQry varchar(400)

	SET @CommonQry = 'SELECT DISTINCT C.AdId From Sale_BuyerInfo B, GoodsMain C ' + 
		' WHERE ' +
		'B.AdId = C.AdId AND ' +
		'C.StateChk = ''1'' AND ' +
		'C.UserId = '''+@UserID+'''  AND '
SET @Sql =
	CASE
	
	WHEN @Status = 1 THEN
		@CommonQry +	--입금확인
		' (B.ReceiveChk = ''0'' OR B.ReceiveChk IS NULL) '+
                                ' AND (B.BuyChk = ''0'' OR B.BuyChk IS NULL) '+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL)  '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL)  '+
                                ' AND B.ChargeKind = ''1'' '
	WHEN @Status = 2 THEN
		@CommonQry +	--발송요청
		' B.ReceiveChk = ''1''  '+
                                ' AND  (B.SendChk = ''0'' OR B.SendChk IS NULL OR B.SendChk = '' '') '+
                                ' AND (B.BuyChk = ''0'' OR B.BuyChk IS NULL) '+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL) '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) '
	WHEN @Status = 3 THEN
		@CommonQry +	--발송중
		' B.SendChk = ''1'' '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) '
	WHEN @Status = 4 THEN
		@CommonQry +	--송금요청
		' B.SendChk = ''2'' '+
                                ' AND (B.RemitChk = ''0'' OR B.RemitChk=''1'' ) '+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL) '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) '
	WHEN @Status = 5 THEN
		@CommonQry +	--정상종료
		' B.ReceiveChk = ''1'' '+
                                ' AND B.SendChk = ''2'' '+
                                ' AND B.RemitChk = ''2'' '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) '
	WHEN @Status = 6 THEN
		@CommonQry +	--반품
		' ((B.ReceiveChk = ''1'' AND B.SendChk = ''4'') OR (B.ReceiveChk = ''1'' AND B.SendChk = ''3'') OR (B.ReceiveChk = ''1'' AND B.BuyChk = ''1'' ))  '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) '
	ELSE
		@CommonQry +	--판매취소
		' B.SaleChk = ''1'' '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ' 
	END
SET @Sql = @Sql + ' ORDER BY C.AdId DESC'
--PRINT(@Sql)
EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[ES_Sell_MainSub]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCedure [dbo].[ES_Sell_MainSub]
(
	@UserID varchar(50),
                @SAdId varchar(10),
	@status int
)
AS
DECLARE @Sql varchar(4000)
DECLARE @CommonQry varchar(500)
DECLARE @OrderBy varchar(100)
SET @CommonQry = ' FROM Sale_BuyerInfo B, GoodsMain C, GoodsSubSale G ' +
		' where  ' +
		' B.AdId = C.AdId AND B.AdId = G.AdId AND ' +
		' C.StateChk = ''1'' AND ' +
		' C.UserId = '''+@UserID+'''  AND C.AdId= '''+@SAdId+'''  AND  '
SET @OrderBy = ' ORDER BY B.Serial DESC ;'
SET @Sql = 
	CASE
		WHEN @status = '1' THEN	--입금확인
		' SELECT B.Serial, CONVERT(char(8),B.RegDate,11) as RegDate,  B.AdId, G.BrandNm as InfoText, B.UserID, '+
                                ' B.WishAmt,  ISNULL(B.ReceiveChk,''0'') as ReceiveChk ' + @CommonQry + ' ' +
		' (B.ReceiveChk = ''0'' OR B.ReceiveChk IS NULL) '+
                                ' AND (B.BuyChk = ''0'' OR B.BuyChk IS NULL) '+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL) '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) '+
                                ' AND B.ChargeKind = ''1'' ' + @OrderBy
		WHEN @status = '2' THEN	--발송요청
		' SELECT B.Serial,  ISNULL(CONVERT(char(8),B.ReceiveDate,11),''0'') as ReceiveDate,   B.AdId, G.BrandNm as InfoText, '+
                                ' B.UserID, B.WishAmt, CASE WHEN B.SendChk = '''' THEN ''0'' WHEN B.SendChk <> '''' THEN B.SendChk END as SendChk, '+
                                ' B.SaleChk, ISNULL(B.ReceiveChk,''0'') as ReceiveChk ' + @CommonQry + ' ' +
		' B.ReceiveChk = ''1'' '+
                                ' AND (B.SendChk = ''0'' OR B.SendChk IS NULL OR B.SendChk = '''') '+
                                ' AND (B.BuyChk = ''0'' OR B.BuyChk IS NULL) '+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL) '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ' + @OrderBy
		WHEN @status = '3' THEN	--발송중
		' SELECT B.Serial, CONVERT(char(8),B.SendChkDate,11) as SendChkDate,  B.AdId, G.BrandNm as InfoText, '+
                                ' B.UserID, B.WishAmt, ISNULL(B.ReceiveChk,''0'') as ReceiveChk, ISNULL(B.SendChk,''0'') as SendChk ' + @CommonQry + ' ' +
		' B.SendChk = ''1'' '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ' + @OrderBy
		WHEN @status = '4' THEN	--송금요청
		' SELECT B.Serial, CONVERT(char(8),B.SendOkDate,11) as SendOkDate,  B.AdId, G.BrandNm as InfoText, '+
                                ' B.UserID, B.WishAmt, CASE WHEN B.RemitChk = '''' THEN ''0'' WHEN B.RemitChk <> '''' THEN B.RemitChk END as RemitChk, '+
                                ' ISNULL(B.ReceiveChk,''0'') as ReceiveChk, ISNULL(B.SendChk,''0'') as SendChk, B.ChargeKind,B.EscrowCharge, '+
                                ' B.CardChargeClt, B.CardChargeCrp ' + @CommonQry + ' ' +
		' B.SendChk = ''2'' '+
                                ' AND (B.RemitChk = ''0'' OR B.RemitChk=''1'') '+
                                ' AND (B.SaleChk = ''0'' OR B.SaleChk IS NULL) '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ' + @OrderBy
		WHEN @status = '5' THEN	--정상종료
		' SELECT B.Serial, CONVERT(char(8),B.RemitEnDate,11) as RemitEnDate,  B.AdId, G.BrandNm as InfoText, B.UserID, '+
                                ' B.WishAmt, ISNULL(B.RemitChk,''0'') as RemitChk, B.EscrowCharge, B.CardChargeClt, B.CardChargeCrp ' + @CommonQry + ' ' +
		' B.ReceiveChk = ''1'' '+
                                ' AND B.SendChk = ''2'' '+
                                ' AND B.RemitChk = ''2'' '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ' + @OrderBy
		WHEN @status = '6' THEN	--반품
		' SELECT B.Serial, B.Email, B.Phone, CONVERT(char(8),B.ReturnStDate,11) as ReturnStDate, '+
                                ' B.AdId, G.BrandNm as InfoText, B.UserID, B.WishAmt, ISNULL(B.ReceiveChk,''0'') as ReceiveChk, '+
                                ' CASE WHEN B.SendChk = '''' THEN ''0'' WHEN B.SendChk <> '''' THEN B.SendChk END as SendChk, '+
                                ' ISNULL(B.SaleChk,''0'') as SaleChk, ISNULL(B.BuyChk,''0'') as BuyChk, ISNULL(B.RefundChk,''0'') as RefundChk, '+
                                ' B.ChargeKind ' + @CommonQry + ' ' +
		' ((B.ReceiveChk = ''1'' AND B.SendChk = ''3'') OR (B.ReceiveChk = ''1'' AND B.SendChk = ''4'') OR (B.ReceiveChk = ''1'' AND B.BuyChk = ''1'' ))  '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL) ' + @OrderBy
		WHEN @status = '7' THEN	--판매취소
		' SELECT B.Serial, CONVERT(char(8),B.SaleChkDate,11) as SaleChkDate,  B.AdId, G.BrandNm as InfoText, '+
                                ' B.UserID, B.WishAmt, ISNULL(B.ReceiveChk,''0'') as ReceiveChk, '+
                                ' CASE WHEN B.RefundChk = '''' THEN ''0'' WHEN B.RefundChk <> '''' THEN B.RefundChk END as RefundChk  ' + @CommonQry + ' ' +
		' B.SaleChk = ''1'' '+
                                ' AND (B.DelFlagSale = ''0'' OR B.DelFlagSale IS NULL ) ' + @OrderBy
	END
--PRINT(@Sql)
EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[EXTEND_FINDUSED_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	제목	 : EXTEND_FINDUSED_PROC
	제작일	 : 2007-09-20
	설명	 : 연휴 기간연장 보너스 스케쥴
               1. 연휴 시작일은 스케쥴에서 설정 
			   2. @ENDTDATE 연휴종료일 직접입력
			   3. 다음 명절때 TRUNCATE TABLE EXTEND_GOODSMAIN_NEW 
*************************************************************************************/

CREATE PROC [dbo].[EXTEND_FINDUSED_PROC]

AS

  DECLARE @YESTERDAY	VARCHAR(10)		-- 어제  
  DECLARE @ENDTDATE		VARCHAR(10)		-- 연장종료일
  DECLARE @ENDTDATEPLUSONE		VARCHAR(10)		-- 연장종료일 다음날(종료일 등록건 연장시 사용됨)
  DECLARE @EXTEND		INT				-- 연장일수

  SET @YESTERDAY = CONVERT(VARCHAR(10), GETDATE()-1, 120)
  SET @ENDTDATE = '2018-02-18'
  SET @ENDTDATEPLUSONE = '2018-02-19'
  SET @EXTEND = DATEDIFF(D,CONVERT(VARCHAR(10), GETDATE(),120) ,@ENDTDATE)+1
	-- 9일 등록시 +1 안됨.
	if CONVERT(VARCHAR(10), GETDATE(),120) =  @ENDTDATEPLUSONE
	set @EXTEND = 1

  SELECT ADID, PRNENDATE
    INTO #TMP_EXTEND 
    FROM GOODSMAIN WITH (NOLOCK)
   WHERE PRNENDATE > @YESTERDAY		-- 게재중인지 체크
     AND OptType = '1' 
     AND StateChk = '1' 
     AND RegAmtOk = '1' 
     AND PrnAmtOk = '1' 
     AND DelFlag = '0'
     AND AdGbn = '0'
     AND ADID NOT IN (SELECT ADID FROM EXTEND_GOODSMAIN_NEW  WITH (NOLOCK))
  BEGIN TRAN
    UPDATE GOODSMAIN 
       SET PRNENDATE = DATEADD(DD, @EXTEND, PRNENDATE)
       WHERE ADID IN (SELECT ADID FROM #TMP_EXTEND)

    INSERT INTO EXTEND_GOODSMAIN_NEW 
           (ADID
           ,PRNENDATE
           ,EXT_PRNENDATE) 
    SELECT ADID
          ,PRNENDATE
          ,DATEADD(DD, @EXTEND, PRNENDATE)
      FROM #TMP_EXTEND

  COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[FINDALL_MAIN_MARKET_LIST_BATCH_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 온라인장터 메인
 *  작   성   자 : 김민석 (rocker76@mediawill.com)
 *  작   성   일 : 2010/01/11
 *  수   정   자 : 김민석 (rocker76@mediawill.com)
 *  수   정   일 :  2010/01/26
 *  설        명 : 김현정과장 요청으로 카테고리추가
 *  주 의  사 항 : 
 *  사 용  소 스 : 

EXEC DBO.FINDALL_MAIN_MARKET_LIST_BATCH_PROC

 *************************************************************************************/

CREATE PROC [dbo].[FINDALL_MAIN_MARKET_LIST_BATCH_PROC]
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	/* ==========================================================================================
	온라인장터 메인
	==========================================================================================*/

/*
		SELECT TOP 40
					  A.ADID
					, MAX(A.ZIPMAIN) ZIPMAIN
					, MAX(B.BRANDNMDT) BRANDNMDT
					, MAX(C.PICIMAGE) PICIMAGE
					, MAX(A.REGDATE) REGDATE
		--FROM DBO.GOODSMAIN A WITH(INDEX(GOODSMAIN_IDX01))
		FROM DBO.GOODSMAIN A
		INNER JOIN DBO.GOODSSUBSALE B ON A.ADID = B.ADID
		INNER JOIN DBO.GOODSPIC C ON A.ADID = C.ADID
		WHERE B.BRANDSTATE IN (0, 1)
			AND C.PICIMAGE IS NOT NULL
			AND B.USEGBN = 0
			AND A.SALEOKFLAG = 0 --판매중
			AND A.STATECHK = 1	--정상
			AND A.DELFLAG = 0	--미삭제
			AND EXISTS
			(
				SELECT '1'
				FROM DBO.CATCODE X
				WHERE X.CODE1 = A.CODE1
					AND X.CODE2 = A.CODE2
					AND X.CODE1 IN (10, 12, 15, 16, 17, 19, 20)
					AND X.CODE2 IN (1014, 1211, 1212, 1513, 1516, 1612, 1710, 1913, 1914, 1911, 1912, 1910, 2013)
			)
		GROUP BY A.ADID
		ORDER BY A.REGDATE DESC
*/

	SELECT ADID
			, ZIPMAIN
			, BRANDNMDT
			, PICIMAGE
			, REGDATE
	FROM
	(
		SELECT TOP 40 
					  A.ADID
					, MAX(A.ZIPMAIN) ZIPMAIN
					, MAX(B.BRANDNMDT) BRANDNMDT
					, MAX(C.PICIMAGE) PICIMAGE
					, MAX(A.REGDATE) REGDATE
		FROM DBO.GOODSMAIN A WITH(INDEX(GOODSMAIN_IDX01))
		INNER JOIN DBO.GOODSSUBSALE B ON A.ADID = B.ADID 
		INNER JOIN DBO.GOODSPIC C ON A.ADID = C.ADID
		WHERE B.BRANDSTATE IN (0, 1)
			AND C.PICIMAGE IS NOT NULL
			AND B.USEGBN = 0
			AND A.SALEOKFLAG = 0 --판매중
			AND A.STATECHK = 1	--정상
			AND A.DELFLAG = 0	--미삭제
			AND EXISTS

			(
				SELECT '1'
				FROM DBO.CATCODE X
				WHERE X.CODE1 = A.CODE1
					AND X.CODE2 = A.CODE2
					AND X.CODE1 IN (10, 12, 15, 16, 17, 19, 20)
					AND X.CODE2 IN (1014, 1211, 1212, 1513, 1516, 1612, 1710, 1913, 1914, 1911, 1912, 1910, 2013)
			)
		GROUP BY A.ADID
	) MA
GO
/****** Object:  StoredProcedure [dbo].[GET_BUYAD_COUNT_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 구매희망 물품등록 개수 카운터
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2009/04/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_BUYAD_COUNT_PROC 'cbk08'
 *************************************************************************************/


CREATE PROC [dbo].[GET_BUYAD_COUNT_PROC]

  @USERID VARCHAR(50)
  ,@CUID  INT = NULL

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT COUNT(A.ADID) AS CNT
    FROM GOODSMAIN AS A
    JOIN GOODSSUBBUY AS B ON A.ADID = B.ADID
   WHERE CONVERT(VARCHAR(10), A.REGENDATE, 120) > CONVERT(VARCHAR(10), GETDATE(), 120)
     AND A.STATECHK = '1'
     AND A.DELFLAG = '0'
     AND A.USERID = @USERID
	 AND A.CUID = @CUID
GO
/****** Object:  StoredProcedure [dbo].[GET_SINGLEVIEW_GOODSMAIN_LIST_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 -(등록대행/E-COMM) 다량등록권 관리 리스트
 *  작   성   자 : 이경덕(LAPLANCE@MEDIAWILL.COM)
 *  작   성   일 : 2014/07/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_M_CY_CONTRACT_TB_LIST_PROC
 
EXECUTE DBO.GET_SINGLEVIEW_GOODSMAIN_LIST_PROC 0,3,20,49446,'E'
EXECUTE DBO.GET_SINGLEVIEW_GOODSMAIN_LIST_PROC 0,3,20,49446,'M'

OptPhoto=1 베스트
OptRecom=1 추천물품
Opturgent=1 긴급매물
Optmain=1 메인노출
optHot =1 핫
optpre =1  프리미엄
optsync=1 동시노출
keyword=1 키워드

(여러개 선택 가능)
optkind=1 볼드
optkind=2 깜박임
optkind=3 형광
optkind=4 아이콘
optkind=6 쇼핑몰 주소표기
optkind=7 포토갤러리


DROP PROC GET_SINGLE_GOODSMAIN_LIST_PROC

 *************************************************************************************/


CREATE PROC [dbo].[GET_SINGLEVIEW_GOODSMAIN_LIST_PROC]
	  @TOTCNT			INT = 0 
	, @PAGE				INT = 1
	, @PAGESIZE			INT = 20
	, @CUID				INT = 0
	, @VERSION			CHAR(1) =''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON
  

  DECLARE @SQL NVARCHAR(4000)
  DECLARE @SQL_WHERE NVARCHAR(2000)
  DECLARE @SQL_JOIN  NVARCHAR(2000)
  DECLARE @SQL_COUNT NVARCHAR(4000)
  DECLARE @SQL_PARAM NVARCHAR(1000)

    SET @SQL = ''
  SET @SQL_WHERE = 'WHERE A.CUID = @CUID '
  SET @SQL_JOIN = ''
  SET @SQL_COUNT = ''
  
  IF @VERSION = 'M' 
  BEGIN
	SET @SQL_WHERE = @SQL_WHERE + ' AND C.ADID IS NOT NULL '
  END
  IF @VERSION = 'E' 
  BEGIN
	SET @SQL_WHERE = @SQL_WHERE + ' AND C.ADID IS NULL '
  END

  SET @SQL_COUNT = 'SELECT @TOTCNT = COUNT(*) 
					FROM dbo.GoodsMain A
					LEFT OUTER JOIN RecChargeDetail RD ON A.AdId = RD.AdId 
					LEFT OUTER JOIN RecCharge B ON RD.GrpSerial = B.GrpSerial 
					LEFT OUTER JOIN RegAgentHistory C ON A.AdId = C.AdId 
	  ' + @SQL_WHERE +''



  -- 리스트 
	SET @SQL = '
SELECT TOP(@PAGESIZE)  
	@TOTCNT AS TOTCNT
	,*
	,DBO.FN_MAGID_TO_NAME(MAG_ID)  as MAG_NM
FROM (
	SELECT TOP(@PAGE * @PAGESIZE)
	ROW_NUMBER() OVER(ORDER BY  A.AdId  DESC) AS RNUM
		, A.AdId
		,B.RecDate
		,OptPhoto
		,OptRecom
		,Opturgent
		,Optmain
		,optHot
		,optpre
		,optsync
		,keyword
		,optkind
		,PrnStDate 
		,PrnEnDate 
		,ISNULL(RD.PrnAmt ,0)as PrnAmt
		,A.PrnAmtOk 
		,C.MAGID as MAG_ID
	FROM dbo.GoodsMain A
	LEFT OUTER JOIN RecChargeDetail RD ON A.AdId = RD.AdId 
	LEFT OUTER JOIN RecCharge B ON RD.GrpSerial = B.GrpSerial 
	LEFT OUTER JOIN RegAgentHistory C ON A.AdId = C.AdId 
'+@SQL_WHERE+'
				) A WHERE RNUM BETWEEN (@PAGE - 1) * (@PAGESIZE ) + 1  AND ((@PAGE - 1) * (@PAGESIZE) + @PAGESIZE  ) 
					ORDER BY RNUM 
'


 SET @SQL_PARAM = N'
      @PAGE				INT 
	, @PAGESIZE			INT 
	, @CUID				INT 
	, @VERSION		CHAR(1)
	, @TOTCNT			INT OUTPUT

'	
	EXECUTE SP_EXECUTESQL @SQL_COUNT,@SQL_PARAM
	, @PAGE				
	, @PAGESIZE			
	, @CUID				
	, @VERSION		
	, @TOTCNT				OUTPUT


	SET @SQL_PARAM = REPLACE(@SQL_PARAM,'OUTPUT','')
	
	PRINT @SQL_COUNT
	PRINT @TOTCNT
	EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM
	, @PAGE				
	, @PAGESIZE			
	, @CUID				
	, @VERSION		
	, @TOTCNT
GO
/****** Object:  StoredProcedure [dbo].[GET_TOTALSEARCH_BUY_LIST_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 중고장터 통합검색
 *  작   성   자 : 정헌수
 *  작   성   일 : 2017/10/27
 *  설        명 : 
 *  수   정   자 : 
 *  수   정   일 : 

 *  사 용  소 스 :
 *  사 용  예 제 :
  EXEC DBO.GET_TOTALSEARCH_BUY_LIST_PROC 0,1,20,'주방'


USEGBN 
2:신품
0:중고품
1:(신고품)미사용신품 - 설명없음
   
 *************************************************************************************/

--쿼리가 4000자를 넘어서 공백 무시하고 붙여서 작성
CREATE PROC [dbo].[GET_TOTALSEARCH_BUY_LIST_PROC]
	@TOTCNT			INT		=0			-- 0 인경우만 COUNT 쿼리 실행처리 함.
	,@PAGE			INT		=0			-- 페이지번호
	,@PAGESIZE		INT		=0			-- 페이지별 게시물 수
	,@SEARCHTXT		VARCHAR(100) ='**'
	,@USEGBN		varchar(2)		=''			-- 구분(중고,신고품,신품)

AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @SQL_COUNT NVARCHAR(4000)
	DECLARE @SQL_SELECT NVARCHAR(4000)
	DECLARE @SQL_SELECT2 NVARCHAR(4000)

	DECLARE @SQL_WHERE NVARCHAR(4000)
	DECLARE @SQL_WHERE2 NVARCHAR(4000)

	DECLARE @SQL_PARAM NVARCHAR(4000)
	DECLARE @SQL_ORDERBY NVARCHAR(4000)
	DECLARE @OPT_SQL	 NVARCHAR(500)

	SET @SEARCHTXT = replace(@SEARCHTXT,' ' ,'*')
	IF @SEARCHTXT ='**' begin
		SET @SEARCHTXT ='*null*'
	end 

	SELECT 
		CASE	WHEN CONTAINS(CONTENTS, @SEARCHTXT ) AND  CONTAINS(BRANDNMDT, @SEARCHTXT) THEN 3 + CASe when PicImage='' or PicImage IS NULL then 0 else 2 end 
				WHEN CONTAINS(BRANDNMDT, @SEARCHTXT) THEN 2+ CASe when PicImage='' or PicImage IS NULL then 0 else 2 end 
				WHEN CONTAINS(CONTENTS, @SEARCHTXT ) THEN 1+ CASe when PicImage=''  or PicImage IS NULL then 0 else 2 end 
		 ELSE 0 END  AS CORRECT
		,M.adid 
		,replace(convert(varchar(10),REGDATE,120),'-','.') as REGDATE 
		,BRANDNMDT
		,ZipMain
		,'' as useduration
		,0 WishAmt 
		,PicImage 
		,ltrim(replace(DBO.FN_ClearHTMLTags(cast(contents as varchar(4000))),'제목 없음','')) as contents
		,usegbn 
		,goodsQt
	 ,*
	     FROM GOODSMAIN AS M WITH (NOLOCK)
			 LEFT JOIN GoodsSubBuy AS S WITH (NOLOCK) ON S.ADID = M.ADID
			 LEFT JOIN GOODSPIC AS P WITH (NOLOCK) ON M.ADID = P.ADID AND PICIDX = 1
	   WHERE M.DELFLAG = '0'
		 AND M.STATECHK = '1'
		 AND M.SALEOKFLAG<>'1'
		 AND M.REGAMTOK = '1'
		 AND (M.REGENDATE >= GETDATE() OR M.PRNENDATE >= GETDATE())
		AND( CONTAINS(CONTENTS, @SEARCHTXT )  OR CONTAINS(BRANDNMDT, @SEARCHTXT) )
		AND (@USEGBN='' OR (@USEGBN='0' AND usegbn = 0 ) OR (@USEGBN='1' AND usegbn = 1 ) OR (@USEGBN='2' AND usegbn = 2 ))
	ORDER BY 1   desc, M.ADID DESC
GO
/****** Object:  StoredProcedure [dbo].[GET_TOTALSEARCH_LIST_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 중고장터 통합검색
 *  작   성   자 : 정헌수
 *  작   성   일 : 2017/10/27
 *  설        명 : 
 *  수   정   자 : 
 *  수   정   일 : 

 *  사 용  소 스 :
 *  사 용  예 제 :
  EXEC DBO.GET_TOTALSEARCH_LIST_PROC 0,1,20,'주방'

exec dbo.GET_TOTALSEARCH_LIST_PROC 0, 1, 20, '*null*', default
USEGBN 
2:신품
0:중고품
1:(신고품)미사용신품 - 설명없음
   
 *************************************************************************************/

--쿼리가 4000자를 넘어서 공백 무시하고 붙여서 작성
CREATE PROC [dbo].[GET_TOTALSEARCH_LIST_PROC]
	@TOTCNT			INT		=0			-- 0 인경우만 COUNT 쿼리 실행처리 함.
	,@PAGE			INT		=0			-- 페이지번호
	,@PAGESIZE		INT		=0			-- 페이지별 게시물 수
	,@SEARCHTXT		VARCHAR(100)='**'
	,@USEGBN		varchar(2)		=''			-- 구분(중고,신고품,신품)

AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @SQL_COUNT NVARCHAR(4000)
	DECLARE @SQL_SELECT NVARCHAR(4000)
	DECLARE @SQL_SELECT2 NVARCHAR(4000)

	DECLARE @SQL_WHERE NVARCHAR(4000)
	DECLARE @SQL_WHERE2 NVARCHAR(4000)

	DECLARE @SQL_PARAM NVARCHAR(4000)
	DECLARE @SQL_ORDERBY NVARCHAR(4000)
	DECLARE @OPT_SQL	 NVARCHAR(500)

	SET @SEARCHTXT = replace(@SEARCHTXT,' ' ,'*')
	IF @SEARCHTXT ='**' begin
		SET @SEARCHTXT ='*null*'
	end 

	SELECT 
		CASE	WHEN CONTAINS(CONTENTS, @SEARCHTXT ) AND  CONTAINS(BRANDNMDT, @SEARCHTXT) THEN 3 + CASe when PicImage='' or PicImage IS NULL then 0 else 2 end 
				WHEN CONTAINS(BRANDNMDT, @SEARCHTXT) THEN 2+ CASe when PicImage='' or PicImage IS NULL then 0 else 2 end 
				WHEN CONTAINS(CONTENTS, @SEARCHTXT ) THEN 1+ CASe when PicImage=''  or PicImage IS NULL then 0 else 2 end 
		 ELSE 0 END  AS CORRECT
		,M.adid 
		,replace(convert(varchar(10),REGDATE,120),'-','.') as REGDATE 
		,BRANDNMDT
		,ZipMain
		,case when UseYY > 0 then cast( UseYY as varchar(10)) +'년' else '' end + cast( UseMM as varchar(10))+'개월' as useduration
		,WishAmt 
		,PicImage 
		,ltrim(replace(DBO.FN_ClearHTMLTags(cast(contents as varchar(4000))),'제목 없음','')) as contents
		,usegbn 
		,goodsQt
	 ,*
	     FROM GOODSMAIN AS M WITH (NOLOCK)
			 LEFT JOIN GOODSSUBSALE AS S WITH (NOLOCK) ON S.ADID = M.ADID
			 LEFT JOIN GOODSPIC AS P WITH (NOLOCK) ON M.ADID = P.ADID AND PICIDX = 1
	   WHERE M.DELFLAG = '0'
		 AND M.STATECHK = '1'
		 AND S.WISHAMT IS NOT NULL
		 AND M.SALEOKFLAG<>'1'
		 AND M.REGAMTOK = '1'
		 AND (M.REGENDATE >= GETDATE() OR M.PRNENDATE >= GETDATE())
		AND( CONTAINS(CONTENTS, @SEARCHTXT )  OR CONTAINS(BRANDNMDT, @SEARCHTXT) )
		AND (@USEGBN='' OR (@USEGBN='0' AND usegbn = 0 ) OR (@USEGBN='1' AND usegbn = 1 ) OR (@USEGBN='2' AND usegbn = 2 ))
	ORDER BY 1   desc, M.ADID DESC

GO
/****** Object:  StoredProcedure [dbo].[GSSTORE_GOODS_LIST_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 :
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/04/03
 *  수   정   자 : 최 봉 기
 *  수   정   일 : 2008/08/12
 *  설        명 : GS이스토어 상품제공
 *  주 의  사 항 :
 *  사 용  소 스 : /Partner/Gsestore_Goods.vbs

EXEC GSSTORE_GOODS_LIST_PROC
 *************************************************************************************/


CREATE PROC [dbo].[GSSTORE_GOODS_LIST_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

/*****************************************************************************
  등록된 매물
*****************************************************************************/
  SELECT M.ADID AS PRDID
         ,S.BRANDNM AS PRDNAME
         ,S.BRANDNMDT AS PRDEXPLAIN
         ,S.WISHAMT AS PRICE
         ,S.BUYAMT AS BUY_PRICE
         ,S.SENDAREAMAIN AS AREA_SI
         ,S.SENDAREASUB AS AREA_GU
         -- 상품상태코드 10 : 중고품, 20 : 신고품, 30 : 신품
         ,CASE S.USEGBN
               WHEN '0' THEN '10'
               WHEN '1' THEN '20'
               WHEN '2' THEN '30' END AS PRD_STATE
         -- 상품유료옵션여부 10 : 일반, 20: 베스트물품, 30: 핫물품, 40 : 프리미엄
         ,CASE WHEN M.OPTTYPE = '0' THEN '10'
               WHEN M.OPTPHOTO = '1' THEN '20'
               WHEN M.OPTHOT = '1' THEN '30'
               WHEN M.OPTPRE = '1' THEN '40'
               ELSE '10' END AS PRD_OPTION
         ,'http://123.111.230.75/Partner/DetailView.asp?AdId='+ CAST(M.ADID AS VARCHAR(10)) AS LINKURL
         ,CASE WHEN P.PICIMAGE <> '' THEN 'http://used.findall.co.kr'+ P.PICIMAGE
               ELSE '' END AS IMGURL
         ,CONVERT(VARCHAR(8),M.REGDATE,112) AS PRD_REGDATE
         ,M.VIEWCNT AS PRD_VIEWCNT
         ,M.CODE1 AS SECTID1
         ,M.CODE2 AS SECTID2
         ,M.CODE3 AS SECTID3
         ,CONVERT(VARCHAR(8),M.REGDATE,112) AS CREDATE
         ,M.USERID AS CREUSER
         ,NULL AS UPDDATE
         ,NULL AS UPDUSER
         ,'C' AS DBSTS
         ,M.CUID as CUID
    FROM GoodsMain AS M
         LEFT JOIN GoodsSubSale AS S ON M.ADID = S.ADID
         LEFT JOIN GoodsPic AS P ON M.ADID = P.ADID AND PICIDX=1
   WHERE M.DelFlag = '0'
     AND M.SaleOkFlag <> '1'
     AND M.StateChk = '1'
     AND S.WishAmt > 0
--     AND CONVERT(CHAR(8), M.REGENDATE, 112) > CONVERT(CHAR(8), GETDATE(),112)
     AND CONVERT(CHAR(8), M.RegDate,112) = CONVERT(CHAR(8), GETDATE()-1,112)

  UNION ALL
/*****************************************************************************
  수정된 매물
*****************************************************************************/
  SELECT M.ADID AS PRDID
         ,S.BRANDNM AS PRDNAME
         ,S.BRANDNMDT AS PRDEXPLAIN
         ,S.WISHAMT AS PRICE
         ,S.BUYAMT AS BUY_PRICE
         ,S.SENDAREAMAIN AS AREA_SI
         ,S.SENDAREASUB AS AREA_GU
         -- 상품상태코드 10 : 중고품, 20 : 신고품, 30 : 신품
         ,CASE S.USEGBN
               WHEN '0' THEN '10'
               WHEN '1' THEN '20'
               WHEN '2' THEN '30' END AS PRD_STATE
         -- 상품유료옵션여부 10 : 일반, 20: 베스트물품, 30: 핫물품, 30 : 프리미엄
         ,CASE WHEN M.OPTTYPE = '0' THEN '10'
               WHEN M.OPTPHOTO = '1' THEN '20'
               WHEN M.OPTHOT = '1' THEN '30'
               WHEN M.OPTPRE = '1' THEN '40'
               ELSE '10' END AS PRD_OPTION
         ,'http://123.111.230.75/Partner/DetailView.asp?AdId='+ CAST(M.ADID AS VARCHAR(10)) AS LINKURL
         ,CASE WHEN P.PICIMAGE <> '' THEN 'http://used.findall.co.kr'+ P.PICIMAGE
               ELSE '' END AS IMGURL
         ,CONVERT(VARCHAR(8),M.REGDATE,112) AS PRD_REGDATE
         ,M.VIEWCNT AS PRD_VIEWCNT
         ,M.CODE1 AS SECTID1
         ,M.CODE2 AS SECTID2
         ,M.CODE3 AS SECTID3
         ,CONVERT(VARCHAR(8),M.REGDATE,112) AS CREDATE
         ,M.USERID AS CREUSER
         ,CONVERT(VARCHAR(8),M.MODDATE,112) AS UPDDATE
         ,M.USERID AS UPDUSER
         ,'U' AS DBSTS
         ,M.CUID as CUID
    FROM GoodsMain AS M
         LEFT JOIN GoodsSubSale AS S ON M.ADID = S.ADID
         LEFT JOIN GoodsPic AS P ON M.ADID = P.ADID AND PICIDX=1
   WHERE M.DelFlag = '0'
     AND M.SaleOkFlag <> '1'
     AND M.StateChk = '1'
     AND S.WishAmt > 0
     AND CONVERT(CHAR(8), M.MODDATE,112) = CONVERT(CHAR(8), GETDATE()-1,112)

  UNION ALL
/*****************************************************************************
  삭제된 매물 (PRDID, UPDDATE, UPDUSER 만 제공)
*****************************************************************************/
  SELECT M.ADID AS PRDID
         ,NULL AS PRDNAME
         ,NULL AS PRDEXPLAIN
         ,NULL AS PRICE
         ,NULL AS BUY_PRICE
         ,NULL AS AREA_SI
         ,NULL AS AREA_GU
         ,NULL PRD_STATE
         ,NULL PRD_OPTION
         ,NULL AS LINKURL
         ,NULL AS IMGURL
         ,NULL AS PRD_REGDATE
         ,NULL AS PRD_VIEWCNT
         ,NULL AS SECTID1
         ,NULL AS SECTID2
         ,NULL AS SECTID3
         ,NULL AS CREDATE
         ,NULL AS CREUSER
         ,CONVERT(CHAR(8), M.DELDATE,112) AS UPDDATE
         ,M.USERID AS UPDUSER
         ,'D' AS DBSTS
         ,NULL AS CUID
    FROM GoodsMain AS M
         LEFT JOIN GoodsSubSale AS S ON M.ADID = S.ADID
         LEFT JOIN GoodsPic AS P ON M.ADID = P.ADID AND PICIDX=1
   WHERE M.DelFlag = '1'
     AND M.SaleOkFlag <> '1'
     AND M.StateChk = '1'
     AND S.WishAmt > 0
     AND CONVERT(CHAR(8), M.DELDATE,112) = CONVERT(CHAR(8), GETDATE()-1,112)
   ORDER BY M.ADID DESC
GO
/****** Object:  StoredProcedure [dbo].[KiccTrans_Insert]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[KiccTrans_Insert]
(
	@TerminalID		varchar(10)
,	@TotPrnAmt		int
,	@UserName		varchar(20)
,	@UserID			varchar(50)
--,	@JuminNo		varchar(15)
,	@Phone			varchar(20)
,	@Email			varchar(50)
,	@RegCount		int
,	@Grpserial		int
,	@CardCommission	float
)
AS

DECLARE @Sequence_no 	varchar(8)
DECLARE @Sequence 	int

BEGIN TRANSACTION

	INSERT INTO KiccTrans(TerminalID,Order_date, Status_flag, Approval_Amount, UserName, UserID, Phone, Email, TotPrnAmt, AdCount) 
	VALUES( 
		@TerminalID
	,	REPLACE(CONVERT(varchar(10),GETDATE(),120),'-','')
	,	'0'
	,	@TotPrnAmt
	,	@UserName
	,	@UserID
	,	@Phone
	,	@Email
	,	@TotPrnAmt
	,	@RegCount
		)

	SET @Sequence = @@IDENTITY
	SET @Sequence_no = RIGHT('00000000'+CONVERT(varchar,@Sequence),8)

	UPDATE KiccTrans 
		SET Sequence_no = @Sequence_no
		WHERE Sequence=@Sequence

	UPDATE KiccTrans 
		SET Sequence_no = @Sequence_no 
		WHERE Sequence = @Sequence
	
	INSERT INTO RecCharge (GrpSerial, ChargeKind, RecStatus, RecDate, KiccTransNo ) 
		VALUES ( @Grpserial , '2', '0',  GetDate(), @Sequence_no )
	
	UPDATE RecChargeDetail 
		SET ChargeCommission = @CardCommission
		WHERE GrpSerial = @Grpserial

	SELECT Sequence_no = @Sequence_no


IF @@ERROR = 0 
	BEGIN
		COMMIT TRANSACTION
	END
ELSE
	BEGIN
		ROLLBACK
	END
GO
/****** Object:  StoredProcedure [dbo].[MainList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[MainList]
(
	@GetCount		varchar(10)
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(10)
,	@AdultCode		char(1)
,	@WishAmtGbn		char(1)
,	@OrderCode		char(1)
,	@StrLocal		char(2)
,	@CountChk		char(1)		--카운트 Flag
)
AS
--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--사진물품
	DECLARE @SqlPicCode varchar(100) ;   SET @SqlPicCode = ''
	IF @PicCode = '1'			      SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' OR A.PicIdx2 <> '''' ) '

--UseCode : 중고품, 신고품, 신품
	DECLARE @SqlUseCode varchar(100) ;  SET @SqlUseCode = ''
	IF @UseCode <> ''		      SET @SqlUseCode = ' AND A.UseGbn = '''+@UseCode +'''  '

--AdultCode
	DECLARE @SqlAdultCode varchar(100)
	IF @AdultCode = '0' 	
		SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '
	Else
		SET @SqlAdultCode=''

--WishAmtGbn
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''	
	IF @WishAmtGbn = '0' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 '
	Else IF  @WishAmtGbn = '1' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn = '2' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '
--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode = '1'
		SET @SqlOrderCode = ' ORDER BY WishAmt Asc, A.AdId DESC '
	ELSE IF @OrderCode = '2'
		SET @SqlOrderCode = ' ORDER BY ViewCnt Desc, A.AdId DESC '
	ELSE
		SET @SqlOrderCode = ' ORDER BY A.AdId DESC '	

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = ' AND B.LocalSite = 0 ' 
	ELSE
		SET @SqlLocalGoods = ' AND (B.LocalSite = 0 OR B.LocalSite=' + @StrLocal + ')'
--		SET @SqlLocalGoods = ' AND B.ShowLocalSite=' + @StrLocal + ' '
--	ELSE	
--		SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
--		                    	          ' (Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ') ' +
--				          ' OR B.ZipMain = ''전국'' ) '


	DECLARE @strQuery varchar(3000)
	IF @CountChk = '1'
		BEGIN
			SET @strQuery = 	' SELECT  COUNT(A.AdId) Cnt' 
			SET @SqlOrderCode = ''
		END
	ELSE
		BEGIN
			SET @strQuery = 	
			' SET ROWCOUNT ' + @GetCount + ';' +
			' SELECT  ' + 
			' 	A.AdId, A.BrandNmDt, A.BrandNm, A.WishAmt, A.UseGbn ' +
			' 	, CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.OptKind, B.ZipMain, B.ZipSub, B.ViewCnt ' + 
			' 	, B.OptLocalBranch,  B.LocalBranch, Isnull(B.WooriID,'''') As WooriID , A.CardYN, A.PicIdx1, A.PicIdx2, M.CNT AS AnswerCnt, B.EscrowYN, B.SpecFlag, P.PicImage, B.LocalSite, B.PLineKeyNo, S.UserId AS MiniShop, B.Keyword, S.CUID AS CUID '
		END

	SET @strQuery = 	@strQuery +
			' FROM 	GoodsSubSale A WITH (NoLock), GoodsMain B WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock) ' + 
			'            , (Select UserId,CUID From SellerMiniShop WITH (NoLock) WHERE Delflag=''0'') S ' + 
			' WHERE	A.AdId = B.AdId AND B.AdId *=M.AdId AND B.AdId *= P.AdId AND B.UserId*=S.UserId ' +
			' AND B.OptHot = ''1'' ' +
			' AND B.DelFlag = ''0'' ' +
			' AND B.StateChk = ''1'' ' +
			' AND B.PrnAmtOK = ''1'' ' + 
			' AND B.RegAmtOK = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND P.PicIdx = 6 ' +
			' AND B.PrnEnDate >= Getdate() ' +  @SqlLocalGoods + @SqlEscrowYNCode + @SqlPicCode + @SqlUseCode + @SqlAdultCode + @SqlWishAmtGbn +@SqlOrderCode	

--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[MoneyProc]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 입금처리  프로시저
	제작자	: 이경미
	제작일	: 2002-03-10
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[MoneyProc]
(
	@StartDate		varchar(10)
,	@EndDate		varchar(10)
,	@strKey                        varchar(50)	-- 키워드 
,	@intSearch		int	            -- 키워드 검색조건
)
AS
--1.온라인 입금처리 항목
	DECLARE @SqlOnline  varchar(200)
	 IF @intSearch ='0'
		BEGIN			
			SET 	@SqlOnline= ''
		END
	ELSE IF @intSearch ='1'
		BEGIN
			SET 	@SqlOnline= 'AND S.UserID Like ''%' + @strKey+'%'' '
		END
            ELSE IF @intSearch ='2'
		BEGIN
			SET 	@SqlOnline= 'AND S.UserName Like ''%' + @strKey+'%'' '
		END
            ELSE IF @intSearch ='3'
		BEGIN
			SET 	@SqlOnline= 'AND R.UserID Like ''%' + @strKey+'%'' '
		END
            ELSE IF @intSearch ='4'
		BEGIN
			SET 	@SqlOnline= 'AND R.UserName Like ''%' + @strKey+'%'' '
		END
            ELSE IF @intSearch ='5'
		BEGIN
			SET 	@SqlOnline= 'AND E.RecNM Like ''%' + @strKey+'%'' '
		END
--2.기간
	
	DECLARE @SqlSDate	varchar(200)
	IF @StartDate = ''
		BEGIN
			SET 	@SqlSDate= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSDate= ' AND CONVERT(varchar(10),S.RegDate,120) >= ''' +@StartDate +''''
		END
	DECLARE @SqlEDate	varchar(200)
	IF @EndDate=''
		BEGIN
			SET	@SqlEDate=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEDate= ' AND CONVERT(varchar(10),S.RegDate,120) <= ''' +@EndDate + ''''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlOnline + @SqlSdate + @SqlEDate 
		END
-- 키워드 검색쿼리 끝
DECLARE @strQ varchar(1000)
SET @strQ =
                             ' SELECT  S.Serial, S.AdId, S.RegDate, S.UserId AS bUserID, S.UserName AS bUserName, '+
	                 ' R.UserId AS rUserID, R.UserName AS rUserName, E.RecNM , S.WishAmt, E.BankNM ,S.SendChk, S.ReceiveDate , R.CUID as CUID ' +
                             ' FROM GoodsMain R, Sale_BuyerInfo S, EsOnline E ' +
	                 ' WHERE R.AdId = S.AdId AND S.Serial= E.Serial AND R.StateChk Not In( ''4'' , ''5'' ) ' + 
	                 ' AND S.ChargeKind =''1'' AND S.ReceiveChk =''1''  ' + 
	                 ' AND (S.SendChk = ''0'' OR S.SendChk = ''1'' ) AND S.SaleChk =''0''  ' + 
	                 ' AND NOT S.DelFlagSale=''1'' AND NOT S.DelFlagBuy=''1''  ' + @SqlAll + ' ' +
                             ' ORDER BY S.RegDate DESC '  
		
	
PRINT(@strQ)
EXEC(@strQ)
GO
/****** Object:  StoredProcedure [dbo].[MT_WEBERROR_TB_INS_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 오류 클라이언트 로그 
 *  작   성   자 : 정 헌 수 (hskka@mediawill.com)
 *  작   성   일 : 2014/08/25
 *  수   정   자 : 
 *  수   정   일 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 select * FROM MT_WEBERROR_TB WITH(NOLOCK) ORDER BY 1 dESC
 *************************************************************************************/
CREATE PROCEDURE [dbo].[MT_WEBERROR_TB_INS_PROC]	
	@ip					VARCHAR(30)	= ''
	,@userAgent			VARCHAR(1000)	= ''
    ,@sFile				VARCHAR(1000)	= ''
    ,@line				INT				= 0
	,@referer  			VARCHAR(2000)	= ''
	,@serverIP			VARCHAR(30)		= ''	
	,@querystring		VARCHAR(4000)	= ''
	,@currentURL		VARCHAR(4000)	= ''
	,@descript			VARCHAR(4000)	= ''
	,@ERRNO				VARCHAR(100)	= ''
	,@RegSite			VARCHAR(100)	= ''
	,@domain			varchar(100)	=''
	,@methodPost		varchar(4000)	=''
AS
BEGIN
	SET NOCOUNT ON;
	
declare @IpFilter TINYINT 
set  @IpFilter = 0
/*
IF exists(select * FROM MT_WEBERROR_IP_FILTER_TB where @ip like IPADDR +'%') 
		OR  @referer = 'http://search.daum.net/'	
		OR  @referer = 'http://www.sogou.com/'	
		OR  @referer = 'http://www.bing.com'	
		OR @userAgent = 'http://www.pirst.kr:6600' -- KISA 개인정보노출 검사 확인
		OR @userAgent = 'Mozilla/5.0 (compatible; MSIE or Firefox mutant; not on Windows server; + http://tab.search.daum.net/aboutWebSearch.html) Daumoa/3.0'
		or @userAgent = 'Korea Internet & Security Agency Privacy Incident Response System Contact Us 118'
		or @userAgent = 'Java/1.6.0_04'
		or @userAgent = 'Java/1.4.1_04'
		or @userAgent = 'Java/1.8.0_65'
		
 
		or @userAgent = 'Haansoft'
		or @userAgent = 'API-Guide test program'
		OR @sFile='/include/PageContactCheck.inc'
		or @currentURL in( '/error/500Error.asp','/land_new/js/ajax_getPowerLinkList.asp')
		or ( datepart(hh,GETDATE()) = 3 and @descript = '시간 제한이 만료되었습니다.') --3시간대에 매물이관시 타이아웃 발생 2015-02-09
	SET @IpFilter = 1
*/
	IF @currentURL = '/error/NotFound.asp' BEGIN
		SET @IpFilter = 2
	END 
	--IPHONE  아이콘 notfind
	IF @querystring like '404;http://www.findall.co.kr:80/apple-touch-icon%' BEGIN
		RETURN 
	END 
		
IF   @IpFilter = 2
BEGIN 

	INSERT MT_WEBERROR_404_TB (
		Logdate
		,Userip
		,ClientAgent
		,serverIP
		,referer
		,sFile
		,Line	
		,querystring
		,[description]
		,currentURL
		,ERRNO
		,RegSite
		,IpFilter
		,domain
		,methodPost
	)
	VALUES (
		GETDATE()
		,@ip			
		,@userAgent	
		,@serverIP	
		,@referer  	
		,@sFile		
		,@line		
		,@querystring
		,@descript
		,@currentURL
		,@ERRNO
		,@RegSite
		,@IpFilter
		,@domain
		,@methodPost
	)
END
ELSE
BEGIN
	INSERT MT_WEBERROR_TB (
		Logdate
		,Userip
		,ClientAgent
		,serverIP
		,referer
		,sFile
		,Line	
		,querystring
		,[description]
		,currentURL
		,ERRNO
		,RegSite
		,IpFilter
		,domain
		,methodPost
	)
	VALUES (
		GETDATE()
		,@ip			
		,@userAgent	
		,@serverIP	
		,@referer  	
		,@sFile		
		,@line		
		,@querystring
		,@descript
		,@currentURL
		,@ERRNO
		,@RegSite
		,@IpFilter
		,@domain
		,@methodPost
	)
END

	IF @descript like '고유 인덱스%'  
	BEGIN
		DECLARE @MSG VARCHAR(200)	
		SET @MSG = '[긴급]고유 인덱스 중복키 오류 발생'
		EXECUTE TAX.COMDB1.DBO.PUT_SENDSMS_PROC '0230190213','FA SYSTEM','개발담당','01031273287',@MSG  -- 정헌수
	
	END
END
GO
/****** Object:  StoredProcedure [dbo].[PROC_FINDALL_MAIN_BEST]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 파인드올 개편(2008. 3. 24) 메인 노출상품 (베스트물품-이미지)
 *  작   성   자 : 최봉기
 *  작   성   일 : 2008-03-19
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : /BatchJob/FindAllTopMain/Create_FindAllMain.vbs

EXEC PROC_FINDALL_MAIN_BEST 1,3,0
 *************************************************************************************/


CREATE PROC [dbo].[PROC_FINDALL_MAIN_BEST]

	@PAGE		INT,		-- 페이지
	@PAGESIZE	INT,		-- 페이징크기
	@LOCAL		INT			-- 지역

AS
	DECLARE @SQL					nvarchar(4000)

	SET @SQL	 =	'SELECT TOP ' +  CONVERT(varchar(10),@PAGE * @PAGESIZE) +' ' +
					' B.Adid, ' +
					' S.BrandNm, ' +
					' CASE B.ZipMain WHEN ''전국'' THEN B.ZipMain ELSE B.ZipMain +'' ''+ B.ZipSub END AS ZipMain , ' +
					' S.WishAmt, ' +
					' B.ZipSub, ' +
					' P.PicImage ' +
					'FROM ' +
					' GoodsMain B WITH (NoLock), ' +
					' GoodsSubSale S WITH (NoLock), ' +
					' GoodsPic P WITH (NoLock) ' +
					'WHERE ' +
					' B.AdId = S.AdId ' +
					' AND B.AdId=P.AdId ' +
					' AND P.PicIdx=7 ' +
					' AND B.OptPhoto=1 ' +
					' AND B.PrnAmtOk=''1'' ' +
					' AND B.PrnEnDate >= GETDATE() ' +
					' AND B.StateChk=''1'' ' +
					' AND B.DelFlag=''0'' ' +
					' AND B.SaleOkFlag=''0'' ' +
					' AND (B.Code2 <> 2310) ' +
					' AND B.LOCALSITE = '+ CONVERT(CHAR(2), @LOCAL) +' '+
					'ORDER BY B.AdId DESC'


--PRINT (@SQL)
EXECUTE (@SQL)
GO
/****** Object:  StoredProcedure [dbo].[PROC_FINDALL_MAIN_FREE_IMG]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 파인드올 개편(2008. 3. 24) 메인 노출상품 (무료로드립니다.-이미지)
 *  작   성   자 : 최봉기
 *  작   성   일 : 2008-03-19
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : /BatchJob/FindAllTopMain/Create_FindAllMain.vbs

EXEC PROC_FINDALL_MAIN_FREE_IMG 1,2,0
 *************************************************************************************/


CREATE PROC [dbo].[PROC_FINDALL_MAIN_FREE_IMG]

	@PAGE		INT,		-- 페이지
	@PAGESIZE	INT,		-- 페이징크기
	@LOCAL		INT			-- 지역

AS
	DECLARE @SQL					nvarchar(4000)

	SET @SQL	 =	'SELECT TOP ' +  CONVERT(varchar(10),@PAGE * @PAGESIZE) +' ' +
					'	A.AdId, '+
					'	CASE A.UseGbn WHEN ''0'' THEN ''중고품'' WHEN ''1'' THEN ''신고품'' WHEN ''2'' THEN ''신품'' END AS UseGbn, '+
					'	CASE B.ZipMain WHEN ''전국'' THEN B.ZipMain ELSE B.ZipMain +'' ''+ B.ZipSub END AS ZipMain, '+
					'	A.BrandNm, '+
					'	P.PicImage '+
					'FROM '+
					'	GoodsSubSale A WITH (NoLock), '+
					'	GoodsMain B WITH (NoLock), '+
					'	GoodsPic P WITH (NoLock) '+
					'WHERE '+
					'	A.AdId = B.AdId '+
					'	AND B.AdId = P.AdId '+
					'	AND B.DelFlag = ''0'' '+
					'	AND B.StateChk=''1'' '+
					'	AND B.RegAmtOk = ''1'' '+
					'	AND P.PicIdx = 6 '+
					'	AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) '+
					'	AND B.SaleOkFlag <> ''1'' '+
					'	AND (B.Code3 <> 131015) '+
					'	AND (B.Code2 <> 2310) '+
					'	AND A.WishAmt = -1 '+
					'	AND (B.Code3 <> 131015) '+
					'	AND P.PicImage IS NOT NULL '+
					'   AND B.LOCALSITE = '+ CONVERT(CHAR(2), @LOCAL) +' '+
					'ORDER BY B.RegDate DESC'


--PRINT (@SQL)
EXECUTE (@SQL)
GO
/****** Object:  StoredProcedure [dbo].[PROC_FINDALL_MAIN_FREE_TXT]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 파인드올 개편(2008. 3. 24) 메인 노출상품 (무료로 드립니다.-텍스트)
 *  작   성   자 : 최봉기
 *  작   성   일 : 2008-03-19
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : /BatchJob/FindAllTopMain/Create_FindAllMain.vbs

EXEC PROC_FINDALL_MAIN_FREE_TXT 1,2,0
 *************************************************************************************/


CREATE PROC [dbo].[PROC_FINDALL_MAIN_FREE_TXT]

	@PAGE		INT,		-- 페이지
	@PAGESIZE	INT,		-- 페이징크기
	@LOCAL		INT			-- 지역

AS
	DECLARE @SQL					nvarchar(4000)

	SET @SQL	 =	'SELECT TOP ' +  CONVERT(varchar(10),@PAGE * @PAGESIZE) +' ' +
					'	A.AdId, '+
					'	CASE A.UseGbn WHEN ''0'' THEN ''중고품'' WHEN ''1'' THEN ''신고품'' WHEN ''2'' THEN ''신품'' END AS UseGbn, '+
					' A.BrandNm, '+
					'	B.ZipMain '+
					'FROM '+
					'	GoodsSubSale A WITH (NoLock) , '+
					'	GoodsMain B WITH (NoLock) '+
					'WHERE '+
					'	A.AdId = B.AdId '+
					'	AND B.DelFlag = ''0'' '+
					'	AND B.StateChk=''1'' '+
					'	AND B.RegAmtOk = ''1'' '+
					'	AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) '+
					'	AND B.SaleOkFlag <> ''1'' '+
					'	AND (B.Code3 <> 131015) '+
					'	AND (B.Code2 <> 2310) '+
					'	AND A.WishAmt = -1 '+
					'	AND (B.Code3 <> 131015) '+
					'   AND B.LOCALSITE = '+ CONVERT(CHAR(2), @LOCAL) +' '+
					'ORDER BY B.RegDate DESC'

--PRINT (@SQL)
EXECUTE (@SQL)
GO
/****** Object:  StoredProcedure [dbo].[PROC_FINDALL_MAIN_HOT]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 파인드올 개편(2008. 3. 24) 메인 노출상품 (핫광고-텍스트)
 *  작   성   자 : 최봉기
 *  작   성   일 : 2008-03-19
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : /BatchJob/FindAllTopMain/Create_FindAllMain.vbs

EXEC PROC_FINDALL_MAIN_HOT 1,5,0
 *************************************************************************************/


CREATE PROC [dbo].[PROC_FINDALL_MAIN_HOT]

	@PAGE		INT,		-- 페이지
	@PAGESIZE	INT,		-- 페이징크기
	@LOCAL		INT			-- 지역

AS
	DECLARE @SQL					nvarchar(4000)

	SET @SQL	 =	'SELECT TOP ' +  CONVERT(varchar(10),@PAGE * @PAGESIZE) +' ' +
					'  A.Adid, '+
					'  CASE A.UseGbn WHEN ''0'' THEN ''중고품'' WHEN ''1'' THEN ''신고품'' WHEN ''2'' THEN ''신품'' END AS UseGbn, '+
					'  A.BrandNm, '+
					'  B.ZipMain '+
					'FROM '+
					'  dbo.GoodsMainDisplay AS A WITH(NOLOCK) '+
					'  LEFT JOIN dbo.GoodsMain B WITH(NOLOCK) ON A.Adid = B.Adid '+
					'WHERE '+
					'  A.Opt = 0 '+
					'  AND A.Code2 <> 2310 ' +
					'  AND A.LOCALSITE = '+ CONVERT(CHAR(2), @LOCAL) +
					'  AND B.LOCALSITE = '+ CONVERT(CHAR(2), @LOCAL)
--					'ORDER BY A.Adid DESC'


--PRINT (@SQL)
EXECUTE (@SQL)
GO
/****** Object:  StoredProcedure [dbo].[Proc_Inipay_VBank]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_Inipay_VBank]
(
	@LEN_MSG		varchar(4)
,	@NO_TID		varchar(40)
,	@NO_OID		varchar(40)
,	@ID_MERCHANT		varchar(10)
,	@CD_BANK		varchar(8)
,	@CD_DEAL		varchar(8)
,	@DT_TRANS		varchar(8)
,	@TM_TRANS		varchar(6)
,	@NO_MSGSEQ		varchar(10)
,	@CD_JOINORG		varchar(8)
,	@DT_TRANSBASE	varchar(8)
,	@NO_TRANSEQ		varchar(7)
,	@CL_MSG		varchar(4)
,	@CL_TRANS		varchar(4)
,	@CL_CLOSE		varchar(1)
,	@CL_KOR		varchar(1)
,	@NO_MSGMANAGE	varchar(8)
,	@NO_VACCT		varchar(16)
,	@AMT_INPUT		varchar(13)
,	@AMT_CHECK		varchar(13)
,	@NM_INPUTBANK		varchar(10)
,	@NM_INPUT		varchar(20)
,	@DT_INPUTSTD		varchar(8)
,	@DT_CALCULSTD		varchar(8)
,	@FLG_CLOSE		varchar(1)

)
AS


	INSERT INTO INIpayVirtualBank(LEN_MSG, NO_TID, NO_OID, ID_MERCHANT, CD_BANK, CD_DEAL, DT_TRANS, TM_TRANS, NO_MSGSEQ, CD_JOINORG, DT_TRANSBASE, NO_TRANSEQ, CL_MSG, CL_TRANS, CL_CLOSE, CL_KOR, NO_MSGMANAGE, NO_VACCT, AMT_INPUT, AMT_CHECK, NM_INPUTBANK, NM_INPUT, DT_INPUTSTD, DT_CALCULSTD, FLG_CLOSE, RegDate) 
	VALUES ( 

		@LEN_MSG
	,	@NO_TID
	,	@NO_OID
	,	@ID_MERCHANT
	,	@CD_BANK
	,	@CD_DEAL
	,	@DT_TRANS
	,	@TM_TRANS
	,	@NO_MSGSEQ
	,	@CD_JOINORG
	,	@DT_TRANSBASE
	,	@NO_TRANSEQ
	,	@CL_MSG
	,	@CL_TRANS
	,	@CL_CLOSE
	,	@CL_KOR
	,	@NO_MSGMANAGE
	,	@NO_VACCT
	,	@AMT_INPUT
	,	@AMT_CHECK
	,	@NM_INPUTBANK
	,	@NM_INPUT
	,	@DT_INPUTSTD
	,	@DT_CALCULSTD
	,	@FLG_CLOSE
	,	GETDATE()

		)


/*

	-- 자동입금처리

	IF (@NO_OID <> '' AND CHARINDEX('_',@NO_OID) > 0 )
	BEGIN

		BEGIN TRANSACTION

		DECLARE @GrpSerial varchar(15); SET @GrpSerial = ''
		DECLARE @AdGbn varchar(30); SET @AdGbn = ''
		DECLARE @strQuery varchar(1000); SET @strQuery = ''
	
		SET @GrpSerial = RIGHT(@NO_OID, CHARINDEX( '_', REVERSE(@NO_OID) ) - 1 )
		SET @AdGbn = SUBSTRING(@NO_OID,1,LEN(@NO_OID)-CHARINDEX( '_', REVERSE(@NO_OID) ) )
	
		IF (@AdGbn = 'Sell_Regist' ) SET @AdGbn = '10'
		ELSE IF (@AdGbn = 'Buy_Regist') SET @AdGbn = '11'
		ELSE IF (@AdGbn = 'Purchase_Regist') SET @AdGbn = '2'
		ELSE IF (@AdGbn = 'Escrow_Request') SET @AdGbn = '3'
	
		IF (@AdGbn = '10' OR @AdGbn = '11' OR @AdGbn = '3') AND @GrpSerial <> ''
		BEGIN
			SET @strQuery = ' ;UPDATE GoodsMain SET EscrowYN = ''Y'' WHERE AdId IN (SELECT AdId FROM RecChargeDetail WHERE GrpSerial=' + @GrpSerial + ' AND Escrow=''Y'')' +
					' ;UPDATE RecCharge SET RecStatus = ''1'', RecDate = GetDate() WHERE GrpSerial=' + @GrpSerial +
					' ;UPDATE RecChargeDetail SET PrnAmtOK = ''1'' WHERE GrpSerial=' + @GrpSerial
		
			--유료옵션을 선택한 물품인 경우에는 유료옵션 결제여부도 1로 바꿔준다.
			SET @strQuery = ' UPDATE A SET PrnAmtOk=''1'', RegAmtOk=''1'', PrnStDate=GETDATE(), PrnEnDate=DATEADD(d,PrnCnt,GETDATE()) ' +
					' FROM GoodsMain A WITH (NoLock), RecChargeDetail B WITH (NoLock) ' +
					' WHERE A.AdId=B.AdId AND B.GrpSerial=' + @GrpSerial + ' AND B.OptYN=''1'' ' + @strQuery
	
			EXEC(@strQuery)
		END


		IF @@ERROR = 0 
			COMMIT TRANSACTION
		ELSE
			ROLLBACK
	END

*/
GO
/****** Object:  StoredProcedure [dbo].[PROC_MINISHOP_AD_COUNT]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 판매자 미니샵 관리 > 매물총개수
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/02/11
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
EXEC PROC_MINISHOP_AD_COUNT '','','',''
 *************************************************************************************/


CREATE PROC [dbo].[PROC_MINISHOP_AD_COUNT]
(
	@PRNSTDATE			varchar(10)
,	@PRNENDATE			varchar(10)
,	@QUERY				varchar(20)
,	@QUERYSTRING		varchar(30)

)
AS

	DECLARE @SQL varchar(3000)

	SET @SQL = 'SELECT COUNT(B.AdId) '+
	'FROM GoodsMain B, GoodsSubSale S, GoodsPic P WHERE B.AdId = S.AdId '+
	'AND B.AdId*=P.AdId '+
	'AND P.PicIdx=7 '

	IF @PRNSTDATE <> ''
		BEGIN
--			SET @SQL = @SQL + 'AND (CONVERT(VARCHAR(10),B.RegEnDate,120) >= '''+ @PRNENDATE +''' OR CONVERT(VARCHAR(10),B.PrnEnDate,120) >= '''+ @PRNENDATE +''') AND B.USERID IN (SELECT DISTINCT USERID FROM SellerMiniShop WHERE REGDATE BETWEEN '''+ @PRNSTDATE +''' AND '''+ @PRNENDATE +''' AND DELFLAG=''0'') '
			SET @SQL = @SQL + 'AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) AND B.CUID IN (SELECT DISTINCT CUID FROM SellerMiniShop WHERE CONVERT(CHAR(10),REGDATE , 120) BETWEEN '''+ @PRNSTDATE +''' AND '''+ @PRNENDATE +''' AND DELFLAG=''0'') '
		END
	ELSE
		BEGIN
			SET @SQL = @SQL + 'AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) AND B.CUID IN (SELECT DISTINCT CUID FROM SellerMiniShop WHERE DELFLAG=''0'') '
		END

	SET @SQL = @SQL + 'AND B.StateChk=''1'' AND RegAmtOk=''1'' AND B.DelFlag=''0'' AND B.SaleOkFlag=''0'' '
	
	IF @QUERYSTRING <> ''
		BEGIN
			SET @SQL = @SQL + 'AND '+ @QUERY +'='''+ @QUERYSTRING +''' '
		END

--PRINT (@SQL)
EXECUTE (@SQL)
GO
/****** Object:  StoredProcedure [dbo].[Proc_PaperToFindUsed]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_PaperToFindUsed]
AS

--신문매물 유즈드 반영 스케쥴

--1. 기존 신문매물 삭제

SELECT AdId INTO #Tmp_AdId 
FROM UsedMain.dbo.GoodsMain
WHERE PLineKeyNo <> ''

DELETE FROM UsedMain.dbo.GoodsMain
WHERE AdId IN (SELECT AdId FROM #Tmp_AdId)

DELETE FROM UsedMain.dbo.GoodsSubSale
WHERE AdId IN (SELECT AdId FROM #Tmp_AdId)


--2. 신문매물 goodsMain에 넣기
INSERT INTO UsedMain.dbo.goodsMain
		(Code1, Code2, Code3, OptType, OptList, OptPhoto, OptRecom, 
			OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink, 
			OptLocalBranch, PrnStDate, PrnEnDate, PrnCnt, UserID, UserName, 
			ShopName, ZipMain, ZipSub, LocalBranch, Phone, HPhone, Email, 
			A.Url, IPAddr, IPAddr2, DelFlag, StateChk, RegDate, ModDate, DelDate, 
			PrnAmtOk, RegAmtOk, EscrowYN, SpecFlag, PartnerCode, SaleOkFlag, 
			AdGbn, MagGbn, ViewCnt, WooriID, LocalSite,ShowLocalSite, PaperFlag, 
			PLineKeyNo)
Select Code1, Code2, Code3, OptType, OptList, OptPhoto, OptRecom, 
			OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink, 
			OptLocalBranch, PrnStDate, PrnEnDate, PrnCnt, UserID, UserName, 
			ShopName, ZipMain, ZipSub, LocalBranch, Phone, HPhone, Email, 
			A.Url, IPAddr, IPAddr2, DelFlag, StateChk, RegDate, ModDate, DelDate, 
			PrnAmtOk, RegAmtOk, EscrowYN, SpecFlag, PartnerCode, SaleOkFlag, 
			AdGbn, MagGbn, ViewCnt, WooriID, LocalSite,
			ShowLocalSite = CASE ZipMain 
										WHEN '강원' THEN	7
										WHEN '경기' THEN	2
										WHEN '경남' THEN	6
										WHEN '경북' THEN	5
										WHEN '광주' THEN	4
										WHEN '대구' THEN	5
										WHEN '대전' THEN	3
										WHEN '부산' THEN	6
										WHEN '서울' THEN	1
										WHEN '울산' THEN	6
										WHEN '인천' THEN	2
										WHEN '전남' THEN	4
										WHEN '전북' THEN	4
										WHEN '제주' THEN	8
										WHEN '충남' THEN	3
										WHEN '충북' THEN	3
										ELSE 0 END, PaperFlag, 
			Convert(varchar(2),BranchCd) + Convert(varchar(2),BranchCd) + Convert(varchar(10),A.LineAdId)
From 	UsedMain.dbo.goodsMain2 AS A 
	INNER JOIN UsedMain.dbo.goodsSubSale2 AS B
		ON A.AdId = B.AdId
	INNER JOIN (Select InputBranch,LineAdId From FINDDB1.UNILINEDB_NEW.dbo.OneDayLineAd Group By InputBranch, LineAdId) As  C
		ON A.LineAdId = C.LineAdId
Where A.LineAdId <> '' AND A.BranchCd = C.InputBranch

--3. 신문매물 goodsSubSale에 넣기

INSERT INTO UsedMain.dbo.goodsSubSale
		(AdId, BrandNmDt, BrandNm, ProCorp, BrandState, 
		UseYY, UseMM, UseGbn, GoodsQt, WishAmt, BuyAmt, 
		PicIdx1, PicIdx2, Contents, TagYN, CardYN, SendGbn, 
		Etctext, SendAreaMain, SendAreaSub, SaleSendWay, 
		GoodsSite, SendCharge, ReZipCode, ReAddr1, ReAddr2,
		RemitBank, RemitAccount, RemitName)
Select C.AdId, BrandNmDt, BrandNm, ProCorp, BrandState, 
		UseYY, UseMM, UseGbn, GoodsQt, WishAmt, BuyAmt, 
		PicIdx1, PicIdx2, Contents, TagYN, CardYN, SendGbn, 
		Etctext, SendAreaMain, SendAreaSub, SaleSendWay, 
		GoodsSite, SendCharge, ReZipCode, ReAddr1, ReAddr2,
		RemitBank, RemitAccount, RemitName
From 	UsedMain.dbo.goodsMain2 AS A 
	INNER JOIN UsedMain.dbo.goodsSubSale2 AS B
		ON A.AdId = B.AdId
	INNER JOIN UsedMain.dbo.goodsMain AS C
		ON C.PLineKeyNo = Convert(varchar(2),A.BranchCd) + Convert(varchar(2),A.BranchCd) + Convert(varchar(10),A.LineAdId)
GO
/****** Object:  StoredProcedure [dbo].[Proc_PointSerial_S]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_PointSerial_S] 

AS
	/*
	SELECT PointSerial AS PointSerial
	FROM RecCharge
	WHERE ChargeKind = '1'
	  AND RecStatus = '0'
	  AND Convert(varchar(10),DateAdd(d,7,RecDate),120) <= Convert(varchar(10),getdate(),120)
	  AND PointSerial <> 0 
	  AND PointSerial <> '' 
	  AND PointSerial Is Not Null
	  AND InipayTid <> '' 
	  AND InipayTid Is Not Null
	*/
	
	SELECT R.PointSerial AS PointSerial
	FROM RecCharge R INNER JOIN IniPayMain M ON R.InipayTid = M.Tid
	WHERE R.ChargeKind = '1'
	  AND R.RecStatus = '0'
	  AND R.PointSerial <> 0 
	  AND R.PointSerial <> '' 
	  AND R.PointSerial Is Not Null
	  AND M.ResultCode = '00'	
	  AND Convert(varchar(10),DateAdd(d,7,M.DtInput),120) = Convert(varchar(10),getdate(),120)
GO
/****** Object:  StoredProcedure [dbo].[ProcARSAbNormal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: ARS 결제 관리-비정상내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-04-26
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcARSAbNormal]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@strLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(2000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(Distinct G.GrpSerial) FROM GoodsMain G, RecCharge R ' +
			'WHERE  R.GrpSerial =* G.GrpSerial And G.ChargeKind=''5''  And G.PrnAmtOk <> ''1''  ' + @SqlAll + '; ' +
			' SELECT Sum(G.PrnAmt) As TotalSum From GoodsMain G, RecCharge R ' +
			'  WHERE R.GrpSerial =* G.GrpSerial And G.ChargeKind=''5''  And G.PrnAmtOk <> ''1''  ' + @SqlAll + ' ' +
			'SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  R.GrpSerial,  Convert(varchar(10),G.RegDate,120) as RegDate,Count(G.Adid) As AdCount, Sum(G.PrnAmt) As TotPrnAmt,  ' +
			'  G.UserName, G.StateChk' +
			'  FROM RecCharge R , GoodsMain G ' +
			'  WHERE R.GrpSerial =* G.GrpSerial And G.ChargeKind=''5''  And G.PrnAmtOk <> ''1''  ' + @SqlAll + ' ' +
			'  Group By R.GrpSerial,  Convert(varchar(10),G.RegDate,120), G.UserName, G.StateChk ' 
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcARSDel]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: ARS 결제 관리-게재후 삭제 내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-04-26
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcARSDel]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(Distinct G.GrpSerial) FROM GoodsMain G, RecCharge R ' +
			' WHERE R.GrpSerial =*G.GrpSerial And G.ChargeKind=''5'' And  G.DelFlag=''3''  And G.StateChk=''1'' ' + @SqlAll + '; ' +
			' SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  R.GrpSerial,  Convert(varchar(10),R.RecDate,120) as RecDate,Convert(varchar(10),R.CancelDate,120) As CancelDate, ' +
			'  Convert(varchar(10),G.PrnStDate,120) As PrnStDate, Count(G.Adid) As AdCount, Sum(G.PrnAmt) As TotPrnAmt, G.UserName ' +
			'  FROM RecCharge R , GoodsMain G ' +
			'  WHERE R.GrpSerial =* G.GrpSerial And G.ChargeKind=''5'' And G.DelFlag=''3'' And G.StateChk=''1''   ' + @SqlAll + ' ' +
			'  Group By R.GrpSerial,  Convert(varchar(10),R.RecDate,120), Convert(varchar(10),R.CancelDate,120), Convert(varchar(10),G.PrnStDate,120),G.UserName  ' 
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcARSNormal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: ARS 결제 관리-정상내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-04-26
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcARSNormal]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(2000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT( Distinct G.GrpSerial) FROM GoodsMain G, RecCharge R ' +
			'Where R.GrpSerial =*G.GrpSerial And G.ChargeKind=''5'' And G.PrnAmtOk=''1''  ' + @SqlAll + '; ' +
			' SELECT Sum(G.PrnAmt) As TotalSum From GoodsMain G, RecCharge R ' +
			'Where R.GrpSerial =* G.GrpSerial  And G.ChargeKind=''5'' And G.PrnAmtOk=''1''  ' + @SqlAll + '; ' +
			'SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  R.GrpSerial,  Convert(varchar(10),G.RegDate,120) as RegDate,Count(G.Adid) As AdCount, Sum(G.PrnAmt) As TotPrnAmt,  ' +
			'  G.UserName, G.StateChk' +
			'  FROM RecCharge R , GoodsMain G ' +
			'  WHERE R.GrpSerial =* G.GrpSerial And G.ChargeKind=''5'' And G.PrnAmtOk=''1''  ' + @SqlAll + ' ' +
			'  Group By R.GrpSerial, Convert(varchar(10), G.RegDate,120), G.UserName, G.StateChk ' 
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procAuctionList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[procAuctionList]  (
	@UserID		varchar(50)	
	,@Group		varchar(10)
	,@CUID		INT = NULL
)
AS
DECLARE  @IDSql		varchar(200)
DECLARE  @GroupSql	varchar(100)
DECLARE  @SQL 		varchar(2000)	

SET    	@IDSql     	= '''' +  REPLACE(@UserID,'''','''''') + ''''
IF @CUID IS NOT NULL
BEGIN
	SET    	@IDSql =  	@IDSql + ' AND B.CUID = ' + CAST(@CUID aS VARCHAR)
END
SET	@GroupSql	= ''

IF @Group = '2'
	SET @GroupSql	= ' AND b.Code2 IN (1610, 1612)'
ELSE IF @Group = '3'
	SET @GroupSql	= ' AND b.Code2 IN (1613, 1614)'
ELSE IF @Group = '4'
	SET @GroupSql	= ' AND b.Code2 IN (1810, 1811, 1812)'
ELSE IF @Group = '5'
	SET @GroupSql	= ' AND b.Code2 IN (1313, 1813)'
ELSE
	SET @GroupSql	= ''
	
BEGIN
	SET   @SQL =
		' SELECT	a.AdId  ,a.BrANDNmDt , b.OptType , b.OptKind , b.OptColor ,  a.CardYN , a.UseGbn ,  a.PicIdx1  ,  a.PicIdx2  ,  b.ZipMain ,   ' +
		'	  	a.WishAmt , b.UserID , b.EscrowYN , convert(char(10),b.RegDate,120) as  RegDate, a.BuyAmt , B.SaleOkFlag   ' +
		' FROM GoodsSubSale a WITH (NoLock, ReadUnCommitted), GoodsMain b WITH (NoLock, ReadUnCommitted) ' +
		' WHERE a.AdId = b.AdId	   	' +
		'AND  b.DelFlag = ''0'' 	' +
		'AND B.StateChk = ''1'' 	' + 
		'AND  b.RegAmtOK = ''1'' ' +
		--' AND B.SaleOkFlag <> ''1'' ' +
		'AND b.UserID=' + @IDSql  + @GroupSql +  
		'  Order by  a.AdId  Desc  '
END


EXEC(@SQL)
--PRINT(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[ProcBadDel]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 삭제등록상품 내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-14
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcBadDel]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	--키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	--키워드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
,	@strPLineKeyNo		char(1)		--인터넷/신문등록 구분
)
AS
--결제방법
	DECLARE @SqlChargeKind  varchar(200)

	IF @StrChargeKind ='ALL'
		SET 	@SqlChargeKind= ''
	ELSE IF @StrChargeKind ='0'
		SET 	@SqlChargeKind= 'AND C.ChargeKind IS NULL '
	ELSE
		SET 	@SqlChargeKind= 'AND C.ChargeKind='+@strChargeKind +''

--기간
	DECLARE @SqlSMakDt	varchar(200)
	DECLARE @SqlEMakDt	varchar(200)

	IF @StrStartDt = ''
		SET 	@SqlSMakDt= ''
	ELSE
	        SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
	IF @StrLastDt=''
	        SET	@SqlEMakDt=''
	ELSE
	        SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''

--키워드
	DECLARE @SqlKeyWord     varchar(200)
	SET     @SqlKeyWord = ''

	IF @StrCboKeyWord ='신청자명'
		SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='입금자명'
		SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='등록자ID'
		SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='전화번호'
		SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='접수번호' AND @strTxtKeyWord <> ''
		SET 	@SqlKeyWord= 'AND G.AdId = ' + @strTxtKeyWord+ ' '

 --개인/전문
        DECLARE @SqlSpecFlag    varchar(200)

	IF @strSpecFlag =''
		SET 	@SqlSpecFlag= ''
        ELSE IF @strSpecFlag = '0'
		SET 	@SqlSpecFlag= ' AND ( G.SpecFlag IS NULL OR G.SpecFlag IN ( ''0'', '''' ) ) '
        ELSE
		SET 	@SqlSpecFlag= ' AND G.SpecFlag='+@strSpecFlag +' '

--인터넷/신문
	DECLARE @SqlPLineKeyNo  varchar(200)

	IF @strPLineKeyNo = '0'
		SET	@SqlPLineKeyNo= ' AND (G.PLineKeyNo IS NULL OR G.PLineKeyNo = '''') '
	ELSE IF  @strPLineKeyNo = '1'
		SET	@SqlPLineKeyNo= ' AND G.PLineKeyNo <> '''' '
	ELSE
		SET	@SqlPLineKeyNo= ''

--판매물품/구매물품
	DECLARE @SqlDivInfo     varchar(20)

	IF @StrDivInfo ='SELL'
		SET @SqlDivInfo = ' And G.AdGbn = 0 '
	ELSE
		SET @SqlDivInfo = ' And G.AdGbn = 1 '

--전체검색
	DECLARE @SqlAll	        varchar(500)
	SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlSpecFlag + @SqlPLineKeyNo + @SqlDivInfo

--전체쿼리
        DECLARE @strQuery       nvarchar(2000)
        SET @strQuery =
	                --자료수 카우트
	                'Select Count(G.AdId) ' +
	                'From GoodsMain G with (Nolock) Left join  ' +
                        '	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmt2, B.PrnAmtOk ' +
	                '	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial AND (A.inipayTid IS NOT NULL OR A.ChargeKind = ''6'')) C ' +
	                '	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	                '	on G.Code1 = D.Code1 ' +
	                'Where G.DelFlag IN (''1'',''2'') ' + @SqlAll + ';' +
	                --실제 자료
	                'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
	                ' 	G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.UserName,G.StateChk,G.SpecFlag,Convert(varchar(10),G.DelDate,120) as DelDate, ' +
	                '	G.OptPhoto, G.OptRecom, G.OptUrgent, G.OptMain, G.OptHot, G.OptPre, G.OptSync, G.OptKind, G.OptLink, G.EscrowYN, G.Keyword,' +
	                '	C.PrnAmt, C.PrnAmt2, C.PrnAmtOk, C.RecNm,C.ChargeKind,Convert(varchar(10),C.RecDate,120) as RecDate,D.CodeNm1, G.PrnCnt ' +
	                'From GoodsMain G with (Nolock) Left join  ' +
	                '	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmt2, B.PrnAmtOk ' +
	                '	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial AND (A.inipayTid IS NOT NULL OR A.ChargeKind = ''6'')) C ' +
	                '	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	                '	on G.Code1 = D.Code1 ' +
	                'Where G.DelFlag IN (''1'',''2'') ' + @SqlAll +
	                'Order By G.AdId desc, C.GrpSerial DESC '
--      PRINT(@strQuery)
        Execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcBadProdSearch]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 분류별 불량광고 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-15
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcBadProdSearch]
(
	@Page			int
,	@PageSize		int
,	@Act			varchar(1)
,	@StrDivInfo		varchar(10)			--삽니다/팝니다
, @strCode			varchar(10)			--상품대분류 구분
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.상품대분류 검색
	DECLARE @SqlCode varchar(200)
	IF @strCode =''
		BEGIN			
			SET 	@SqlCode= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlCode= ' And G.Code1='+@strCode +''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrtxtKeyWord =''		
		BEGIN			
			SET 	@SqlKeyWord=''
		END
	ELSE
		BEGIN
			SET	@SqlKeyWord= 'AND (S.BrandNmDt Like ''%' + @strTxtKeyWord + '%'' ) ' --OR S.Contents Like ''%' + @strTxtKeyWord + '%'' ) '
		END

--검색 테이블, 자료 구분
	DECLARE @Table varchar(20)
	IF @StrDivInfo ='SELL'
	BEGIN
		SET @Table = ' GoodsSubSale '
	END
	ELSE
	BEGIN
		SET @Table = ' GoodsSubBuy '
	END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlCode + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝

DECLARE @strQuery nvarchar(2000)
SET @strQuery =
	--자료수 카우트
	'Select Count(G.AdId) ' +
	'From GoodsMain G with (Nolock) inner join ' + @Table + ' S with (Nolock) ' +
	' on G.AdId = S.AdId Left join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmtOk ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where G.ModDate is not null ' + @SqlAll + ';' +
	--실제 자료 
	'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
	' G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.UserName,G.UserID, G.StateChk,G.SpecFlag, ' +
	'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, ' +
	'	C.PrnAmt,C.PrnAmtOk, C.RecNm,C.ChargeKind,Convert(varchar(10),C.RecDate,120) as RecDate,D.CodeNm1 , G.CUID ' +
	'From GoodsMain G with (Nolock) inner join ' + @Table + ' S with (Nolock) ' +
	' on G.AdId = S.AdId Left join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmtOk ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where G.ModDate is not null ' + @SqlAll +
	'Order By G.AdId desc'

PRINT(@strQuery)
Execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcBadReg]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 불량등록상품 내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-14
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcBadReg]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	--키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	--키워드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
,	@strPLineKeyNo		char(1)		--인터넷/신문등록 구분
)
AS
--결제방법
	DECLARE @SqlChargeKind varchar(200)

	IF @StrChargeKind ='ALL'
		SET 	@SqlChargeKind= ''
	ELSE IF @StrChargeKind ='0'
		SET 	@SqlChargeKind= 'AND C.ChargeKind IS NULL '
	ELSE
		SET 	@SqlChargeKind= 'AND C.ChargeKind='+@strChargeKind +''

--기간
	DECLARE @SqlSMakDt	varchar(200)
        DECLARE @SqlEMakDt	varchar(200)

	IF @StrStartDt = ''
		SET 	@SqlSMakDt= ''
	ELSE
		SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
	IF @StrLastDt=''
		SET	@SqlEMakDt=''
	ELSE
		SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''

--키워드
	DECLARE @SqlKeyWord     varchar(200)
	SET     @SqlKeyWord = ''

	IF @StrCboKeyWord ='신청자명'
		SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='입금자명'
		SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='등록자ID'
		SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='전화번호'
		SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='접수번호' AND @strTxtKeyWord <> ''
		SET 	@SqlKeyWord= 'AND G.AdId = ' + @strTxtKeyWord+ ' '

--개인/전문
        DECLARE @SqlSpecFlag    varchar(200)

	IF @strSpecFlag =''
		SET 	@SqlSpecFlag= ''
        ELSE IF @strSpecFlag = '0'
		SET 	@SqlSpecFlag= ' AND ( G.SpecFlag IS NULL OR G.SpecFlag IN ( ''0'', '''' ) ) '
        ELSE
		SET 	@SqlSpecFlag= ' AND G.SpecFlag='+@strSpecFlag +' '

--인터넷/신문
	DECLARE @SqlPLineKeyNo varchar(200)

	IF @strPLineKeyNo = '0'
		SET	@SqlPLineKeyNo= ' AND (G.PLineKeyNo IS NULL OR G.PLineKeyNo = '''') '
	ELSE IF  @strPLineKeyNo = '1'
		SET	@SqlPLineKeyNo= ' AND G.PLineKeyNo <> '''' '
	ELSE
		SET	@SqlPLineKeyNo= ''

--판매물품/구매물품
	DECLARE @SqlDivInfo     varchar(20)
	IF @StrDivInfo ='SELL'
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 0 '
	END
	ELSE
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 1 '
	END

--전체검색
	DECLARE @SqlAll         varchar(500)
        SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlSpecFlag + @SqlPLineKeyNo +  @SqlDivInfo


--전체쿼리
        DECLARE @strQuery       nvarchar(2000)
        SET @strQuery =
	                --자료수 카우트
	                'Select Count(G.AdId) ' +
	                'From GoodsMain G with (Nolock) Left outer join  ' +
                        '	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmt2, B.PrnAmtOk ' +
	                '	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial AND (A.inipayTid IS NOT NULL OR A.ChargeKind = ''6'')) C ' +
	                '	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	                '	on G.Code1 = D.Code1 ' +
	                'Where G.StateChk = ''5'' ' + @SqlAll + ';' +
	                --실제 자료
	                'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
                        ' 	G.AdId, Convert(varchar(10),G.RegDate,120) as RegDate, G.UserName, G.StateChk, G.SpecFlag, ' +
	                '	G.OptPhoto, G.OptRecom, G.OptUrgent, G.OptMain, G.OptHot, G.OptPre, G.OptSync, G.OptKind, G.OptLink, G.EscrowYN, G.Keyword, ' +
	                '	C.PrnAmt, C.PrnAmt2, C.PrnAmtOk, C.RecNm, C.ChargeKind, Convert(varchar(10),C.RecDate,120) as RecDate, D.CodeNm1, G.PrnCnt ' +
	                'From GoodsMain G with (Nolock) Left outer join  ' +
	                '	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmt2, B.PrnAmtOk ' +
	                '	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial AND (A.inipayTid IS NOT NULL OR A.ChargeKind = ''6'')) C ' +
	                '	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	                '	on G.Code1 = D.Code1 ' +
	                'Where G.StateChk = ''5'' ' + @SqlAll +
	                'Order By G.AdId desc'
--      PRINT(@strQuery)
        Execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcBadReg2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 불량등록상품 내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-14
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcBadReg2]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
,	@strPLineKeyNo		char(1)		--인터넷/신문등록 구분
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE IF @StrChargeKind ='0'
		BEGIN
			SET 	@SqlChargeKind= 'AND C.ChargeKind IS NULL '
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND C.ChargeKind='+@strChargeKind +''
		END

--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
 --개인,전문구분
              DECLARE @SqlSpecFlag varchar(200)
	IF @strSpecFlag =''
		BEGIN			
			SET 	@SqlSpecFlag= ''
		END
              ELSE IF @strSpecFlag = '0'
		BEGIN
			SET 	@SqlSpecFlag= ' AND ( G.SpecFlag IS NULL OR G.SpecFlag IN ( ''0'', '''' ) ) '
		END
              ELSE  
		BEGIN
			SET 	@SqlSpecFlag= ' AND G.SpecFlag='+@strSpecFlag +' '
		END	

-- 인터넷/신문 등록구분
	DECLARE @SqlPLineKeyNo varchar(200)
	IF @strPLineKeyNo = '0'
		BEGIN
			SET	@SqlPLineKeyNo= ' AND (G.PLineKeyNo IS NULL OR G.PLineKeyNo = '''') '
		END
	ELSE IF  @strPLineKeyNo = '1'
		BEGIN
			SET	@SqlPLineKeyNo= ' AND G.PLineKeyNo <> '''' '
		END
	ELSE
		BEGIN
			SET	@SqlPLineKeyNo= ''
		END		

--검색 테이블, 자료 구분
	DECLARE @SqlDivInfo varchar(20)
	IF @StrDivInfo ='SELL'
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 0 '
	END
	ELSE
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 1 '
	END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlSpecFlag + @SqlPLineKeyNo +  @SqlDivInfo
		END
-- 키워드 검색쿼리 끝

DECLARE @strQuery nvarchar(2000)
SET @strQuery =
	--자료수 카우트
	'Select Count(G.AdId) ' +
	'From vi_GoodsMain G with (Nolock) Left outer join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial AND A.inipayTid IS NOT NULL) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where G.StateChk = ''5'' ' + @SqlAll + ';' +

	--실제 자료 
	'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
	' G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.UserName,G.StateChk,G.SpecFlag, ' +
	'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, EscrowYN, ' +
	'	C.PrnAmt,C.PrnAmtOk,C.RecNm,C.ChargeKind,Convert(varchar(10),C.RecDate,120) as RecDate,D.CodeNm1, G.PrnCnt ' +
	'From vi_GoodsMain G with (Nolock) Left outer join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmtOk ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial AND A.inipayTid IS NOT NULL) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where G.StateChk = ''5'' ' + @SqlAll +
	'Order By G.AdId desc'

--PRINT(@strQuery)
Execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcBadSpec]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcBadSpec]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND C.ChargeKind='+@strChargeKind +''
		END
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END

--검색 테이블, 자료 구분
	DECLARE @SqlDivInfo varchar(20)
	IF @StrDivInfo ='SELL'
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 0 '
	END
	ELSE
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 1 '
	END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝

DECLARE @strQuery nvarchar(2000)
SET @strQuery =
	--자료수 카우트
	'Select Count(G.AdId) ' +
	'From GoodsMain G with (Nolock) Left outer join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where G.SpecFlag in (''1'',''2'') And G.StateChk = ''6'' ' + @SqlAll + ';' +
	--실제 자료 
	'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
	' G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.UserName,G.StateChk,G.SpecFlag, ' +
	'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, ' +
	'	C.PrnAmt,C.PrnAmtOk,C.RecNm,C.ChargeKind,Convert(varchar(10),C.RecDate,120) as RecDate,D.CodeNm1 ' +
	'From GoodsMain G with (Nolock) Left outer join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmtOk ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where G.SpecFlag in (''1'',''2'') And G.StateChk = ''6'' ' + @SqlAll + 
	'Order By G.AdId desc'

PRINT(@strQuery)
Execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcBajaCount]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcBajaCount]
(
	@Option		Char(1)
,	@StrLocal		char(2)		-- 지역코드
)
AS
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
			SET @SqlLocalNew = ' ( B.OptType IN (''1'',''2'') AND ( ' +
										' ( ' + @SqlLocalGoods + ' AND ( B.PrnAmtOk <> ''1''  OR B.PrnEnDate < GETDATE() ) ) OR ' +
										' ( NOT ' + @SqlLocalGoods + ' ) ' +
									'    ) ' +
					          ' ) '
			SET @SqlCondition = ' AND ( ' +
							@SqlLocalGoods + ' OR ' +
							' ( ( NOT ' + @SqlLocalGoods + ' ) AND ( B.OptType IN (''1'', ''2'') OR B.OptKind <> '''' )  ) ' +
						'     ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') ' +
						' ) '
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
			SET @SqlLocalNew = ' ( B.OptType IN (''1'',''2'') AND ( ' +
										' ( ' + @SqlLocalGoods + ' AND ( B.PrnAmtOk <> ''1''  OR B.PrnEnDate < GETDATE() ) ) OR ' +
										' ( NOT ' + @SqlLocalGoods + ' ) ' +
									'    ) ' +
					          ' ) '
			SET @SqlCondition = ' AND  ( ' +
							'  ( L.LocalSite=' + @StrLocal + ' AND ( L.LocalBranch=B.LocalBranch OR L.LocalBranch=LEFT(B.OptLocalBranch,2) ) ) OR ' +
							'  ( B.LocalBranch=L.LocalBranch AND B.OptLocalBranch=''80'' AND B.ZipMain=''전국'' ) ' +
						'      ) ' 
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(2000)
SET @strQuery = 
CASE
  WHEN @Option ='0' THEN
			' SELECT COUNT(A.Adid) 	'+
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''2''  ' +
			' AND B.StateChk< ''4'' ' + @SqlLocalGoods +
			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' )'
          ELSE
			'SELECT  Count(A.AdId) as HotCnt  '+
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''2'' ' +
			' AND B.StateChk< ''4'' ' + ' AND ' + @SqlLocalGoods +
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE()  '
          END
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcBajaList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcBajaList]
( 	@Page			int
,	@PageSize		int
,	@Option		Char(1)
,	@StrLocal		char(2)		-- 지역코드
)
AS
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
			SET @SqlLocalNew = ' ( B.OptType IN (''1'',''2'') AND ( ' +
										' ( ' + @SqlLocalGoods + ' AND ( B.PrnAmtOk <> ''1''  OR B.PrnEnDate < GETDATE() ) ) OR ' +
										' ( NOT ' + @SqlLocalGoods + ' ) ' +
									'    ) ' +
					          ' ) '
			SET @SqlCondition = ' AND ( ' +
							@SqlLocalGoods + ' OR ' +
							' ( ( NOT ' + @SqlLocalGoods + ' ) AND ( B.OptType IN (''1'', ''2'') OR B.OptKind <> '''' )  ) ' +
						'     ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') ' +
						' ) '
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
			SET @SqlLocalNew = ' ( B.OptType IN (''1'',''2'') AND ( ' +
										' ( ' + @SqlLocalGoods + ' AND ( B.PrnAmtOk <> ''1''  OR B.PrnEnDate < GETDATE() ) ) OR ' +
										' ( NOT ' + @SqlLocalGoods + ' ) ' +
									'    ) ' +
					          ' ) '
			SET @SqlCondition = ' AND  ( ' +
							'  ( L.LocalSite=' + @StrLocal + ' AND ( L.LocalBranch=B.LocalBranch OR L.LocalBranch=LEFT(B.OptLocalBranch,2) ) ) OR ' +
							'  ( B.LocalBranch=L.LocalBranch AND B.OptLocalBranch=''80'' AND B.ZipMain=''전국'' ) ' +
						'      ) ' 
		END
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
		CASE
		WHEN @Option = '0' THEN
			' Select Distinct  TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			' A.AdId AdId, A.BrandNmDt BrandNmDt, A.WishAmt WishAmt, A.UseGbn UseGbn, '+
			' B.UserID UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
			' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
			' B.OptType OptType,  B.OptColor OptColor, B.OptLocalBranch OptLocalBranch,  B.LocalBranch LocalBranch, B.ZipMain ZipMain, B.ZipSub ZipSub,A.buyAmt buyAmt, '+
			' A.CardYN CardYN,B.EscrowYN EscrowYN, A.PicIdx1 PicIdx1, A.PicIdx2	PicIdx2, B.SaleOkFlag SaleOkFlag, B.CUID '+
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''2''  ' +
			' AND B.StateChk< ''4'' ' + @SqlCondition +
			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' ) Order by Adid Desc '
		ELSE
			' Select ' +
			' A.AdId AdId, A.BrandNmDt BrandNmDt, A.WishAmt WishAmt, A.UseGbn UseGbn, '+
			' B.UserID UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
			' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
			' B.OptType OptType,  B.OptColor OptColor, B.OptLocalBranch OptLocalBranch,  B.LocalBranch LocalBranch, B.ZipMain ZipMain, B.ZipSub ZipSub,A.buyAmt buyAmt, '+
			' A.CardYN CardYN,B.EscrowYN EscrowYN, A.PicIdx1 PicIdx1, A.PicIdx2	PicIdx2, B.SaleOkFlag SaleOkFlag , B.CUID '+
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''2'' ' +
			' AND B.StateChk< ''4'' ' + ' AND ' + @SqlLocalGoods +
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE()  Order by Adid Desc '
		END
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcBuyCateList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcBuyCateList]
(
	@GetCount		varchar(10)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option			varchar(20)	--옵션 종류
,	@UseCode		varchar(30)
,	@AdultCode		char(1)
,	@OrderCode		char(1)
,	@ZipMain		varchar(50)
,	@ZipSub		varchar(50)
,	@SearchText		varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
,	@CountChk		char(1)		--카운트 Flag
)
AS
--Code값
	DECLARE @SqlstrCode varchar(100) ; SET @SqlstrCode = ''
	IF @StrCode3 <> ''	SET @SqlstrCode = ' AND B.Code3='+@StrCode3
	ELSE IF @StrCode2 <> ''	SET @SqlstrCode = ' AND B.Code2='+@StrCode2

--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

--ZipCode
	DECLARE @SqlZipCode varchar(150); SET @SqlZipCode=''
	IF @ZipMain <> ''
	BEGIN
		SET @SqlZipCode= ' AND B.ZipMain = '''+@ZipMain+''' '
		IF @ZipSub <> ''	SET @SqlZipCode= @SqlZipCode + ' AND B.ZipSub LIKE '''+@ZipSub+'%'' '
	END

--@SearchText
	DECLARE @SqlSearchText varchar(200); SET @SqlSearchText=''
	IF @SearchText <> ''	SET @SqlSearchText= ' AND ( A.BrandNm LIKE ''%'+@SearchText+'%'' OR A.BrandNmDt LIKE ''%'+@SearchText+'%'' ) '

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode = '1'
		SET @SqlOrderCode = ' ORDER BY BuyAmt Asc, A.AdId DESC '
	ELSE IF @OrderCode = '2'
		SET @SqlOrderCode = ' ORDER BY ViewCnt Desc, A.AdId DESC '
	ELSE
		SET @SqlOrderCode = ' ORDER BY A.AdId DESC '	

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
	SET @SqlAll = @SqlstrCode + @SqlUseCode + @SqlAdultCode + @SqlZipCode + @SqlSearchText

--유료옵션시 결제완료 여부
	DECLARE @SqlCondition varchar(200) ; SET @SqlCondition = ''
	IF @Option <> ''		
		SET @SqlCondition = ' AND ' + @Option + '=1 AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() AND B.LocalSite=' + @StrLocal
	ELSE
		SET @SqlCondition = ''

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE
--		SET @SqlLocalGoods = ' AND B.ShowLocalSite=' + @StrLocal + ' '
		SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0 OR B.ShowLocalSite=' + @StrLocal + ')'	

	
	DECLARE @strQuery varchar(3000)
	IF @CountChk = '1'
	BEGIN
		SET @strQuery = 	' SELECT  COUNT(A.AdId) Cnt' 
		SET @SqlOrderCode = ''
	END
	ELSE
	BEGIN
		SET @strQuery = 	' SET ROWCOUNT ' + @GetCount + ';' +
				' SELECT  ' + 
				' A.AdId, A.BrandNmDt, A.BuyAmt, A.UseGbn, ' +
				' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, ' +
				' CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 
				' OptType,OptList,OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,' +
				' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub,B.ViewCnt, M.CNT AS AnswerCnt, B.PLineKeyNo, A.DealPriceYN '
	END

	SET @strQuery = 	@strQuery +
			
			' FROM GoodsSubBuy A WITH (NoLock), GoodsMain B WITH (NoLock), CatCode C WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M' + 
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 AND B.AdId *=M.AdId ' +
			' AND B.DelFlag = ''0'' ' +
			' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) ' +	
			' AND B.StateChk = ''1'' ' + @SqlLocalGoods + @SqlAll + @SqlCondition + @SqlOrderCode + ';' +
			' SET ROWCOUNT 0;' 
			
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcBuyUrgentList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcBuyUrgentList]
(
	@StrLocal	varchar(2)	-- 지역코드
,	@AdultCode	char(1)
)
AS

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE
		SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
		     		          '(Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ') ' +
				          ' OR B.ZipMain = ''전국'' ) '
--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2415) '

	DECLARE @strQuery varchar(3000)
	SET @strQuery = ' SELECT TOP 15 ' +
			' A.AdId, A.BrandNmDt, A.BuyAmt, A.UseGbn, ' +
			' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, ' +
			' CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 
			' OptType,OptList,OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,' +
			' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub,B.ViewCnt, M.CNT AS AnswerCnt ' +
			' FROM GoodsMain B WITH (NoLock), GoodsSubBuy A WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M ' + 
			' WHERE B.AdId = A.AdId AND B.AdId *=M.AdId ' +
			' AND B.OptUrgent=1 ' +
			' AND B.PrnAmtOk=''1'' AND B.PrnEnDate >= GETDATE() ' +
			' AND B.StateChk=''1'' AND B.DelFlag=''0'' AND B.SaleOkFlag=''0'' ' + @SqlLocalGoods + @SqlAdultCode +
			' ORDER BY B.AdId DESC '

--WAITFOR DELAY '00:00:10'
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcCateCount]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcCateCount]
(
	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option			char(1)
,	@BajaCode		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(30)
,	@OrderCode		char(1)
,	@StrSearchKeyWord	varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
)
AS
--Code값
	DECLARE @SqlstrCode varchar(100) ; SET @SqlstrCode = ''
	IF @StrCode3 <> ''	SET @SqlstrCode = ' AND B.Code3='+@StrCode3
	ELSE IF @StrCode2 <> ''	SET @SqlstrCode = ' AND B.Code2='+@StrCode2
--bajaCode바자회여부
	DECLARE @SqlbajaCode varchar(100) ; SET @SqlbajaCode = ''
	IF @bajaCode = '1'	SET @SqlbajaCode = ' AND B.SpecFlag = ''2'' '
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '
--OrderCode
--키워드검색
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @StrSearchKeyWord <> ''	SET @SqlKeyWord = ' AND ( C.CodeNm1 LIKE  ''%' + @StrSearchKeyWord+'%''  OR C.CodeNm2 LIKE ''%' + @StrSearchKeyWord+'%'' OR C.CodeNm3 LIKE  ''%' + @StrSearchKeyWord+'%'' OR A.BrandNmDt Like ''%' + @StrSearchKeyWord +'%'' ) ' 
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
	SET @SqlAll = @SqlstrCode + @SqlbajaCode + @SqlPicCode + @SqlUseCode + @SqlKeyWord
--유료옵션시 결제완료 여부
	DECLARE @SqlCondition varchar(200) ; SET @SqlCondition = ''
	IF @Option <> '0'		SET @SqlCondition = ' AND B.OptType IN (''1'',''2'') ' +
						     ' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() '
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalSite = ''
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
			IF @Option = '0'
				SET @SqlLocalGoods = ' ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND L.LocalSite=' + @StrLocal + ') OR ' +
								' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
							' ) '
			ELSE
				SET @SqlLocalGoods = ' ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ')  ' +
							' ) '
		END
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 	' SELECT COUNT(A.Adid) ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted), CatCode C WITH (NoLock, ReadUnCommitted)' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag <> ''1'' AND B.SaleOkFlag<>''1'' ' +
			' AND B.StateChk < ''4'' AND ' + @SqlLocalGoods + @SqlAll + @SqlCondition
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcCateCount_new]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcCateCount_new]
(
	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@BajaCode		Char(1)
,	@PicCode		Char(1)
,	@UseCode		Varchar(30)
,	@StrSearchKeyWord	varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
)
AS

--Code2값
	DECLARE @SqlstrCode2 varchar(100)
	IF @StrCode2 =''
		BEGIN			
			SET 	@SqlstrCode2= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode2= ' AND B.code2='+@StrCode2 +''
		END

--Code3값
	DECLARE @SqlstrCode3 varchar(100)
	IF @StrCode3 =''
		BEGIN			
			SET 	@SqlstrCode3= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode3= ' AND B.code3='+@StrCode3 +''
		END

--bajaCode바자회여부
	DECLARE @SqlbajaCode varchar(100)
	IF @bajaCode ='1'
	                BEGIN
			SET 	 @SqlbajaCode= ' AND B.SpecFlag = ''2'' '
		END
                                
               ELSE 
                                BEGIN			
			SET 	 @SqlbajaCode= ''
		END

--PicCode사진여부
	DECLARE @SqlPicCode varchar(100)
	IF @PicCode ='1'
	                BEGIN
			SET 	 @SqlPicCode= ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
		END
                                
               ELSE 
                                BEGIN			
			SET 	 @SqlPicCode= ''
		END

--UseCode
	DECLARE @SqlUseCode varchar(100)
	IF @UseCode =''
		BEGIN			
			SET 	@SqlUseCode= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlUseCode= '  AND (A.UseGbn = '''+@UseCode +''' ) '
		END

--키워드검색
	DECLARE @SqlKeyWord varchar(500)
	IF @StrSearchKeyWord =''
		BEGIN
			SET 	@SqlKeyWord= ''
		END
	ELSE  
		
		BEGIN			
			SET 	@SqlKeyWord= 'AND ( C.codeNm1 LIKE  ''%' + @StrSearchKeyWord+'%''  OR C.codeNm2 LIKE ''%' + @StrSearchKeyWord+'%'' OR C.CodeNm3 LIKE  ''%' + @StrSearchKeyWord+'%'' OR  A.BrandNmDt Like ''%' + @StrSearchKeyWord +'%'' ) ' 
                                                                                                 
		END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlstrCode2 +@SqlstrCode3+ @SqlbajaCode + @SqlPicCode + @SqlUseCode +@SqlKeyWord
		END
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)

	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') ' +
						' ) '
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
		END


	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
			' SELECT COUNT(A.Adid) FROM '+
			' GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted), CatCode C WITH (NoLock, ReadUnCommitted)' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag <> ''1'' AND B.SaleOkFlag<>''1'' ' +
			' AND B.StateChk< ''4'' AND ' + @SqlLocalGoods + @SqlAll

PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcCateCount2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcCateCount2]
(
	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option			Char(1)
,	@BajaCode		Char(1)
,	@PicCode		Char(1)
,	@UseCode		Varchar(30)
,	@OrderCode		char(1)
,	@StrSearchKeyWord	varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
)
AS
--Code2값
	DECLARE @SqlstrCode2 varchar(100)
	IF @StrCode2 =''
		BEGIN			
			SET 	@SqlstrCode2= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode2= ' AND B.code2='+@StrCode2 +''
		END
--Code3값
	DECLARE @SqlstrCode3 varchar(100)
	IF @StrCode3 =''
		BEGIN			
			SET 	@SqlstrCode3= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode3= ' AND B.code3='+@StrCode3 +''
		END
--bajaCode바자회여부
	DECLARE @SqlbajaCode varchar(100)
	IF @bajaCode ='1'
	                BEGIN
			SET 	 @SqlbajaCode= ' AND B.SpecFlag = ''2'' '
		END
                                
               ELSE 
                                BEGIN			
			SET 	 @SqlbajaCode= ''
		END
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100)
	IF @PicCode ='1'
	                BEGIN
			SET 	 @SqlPicCode= ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
		END
                                
               ELSE 
                                BEGIN			
			SET 	 @SqlPicCode= ''
		END
--UseCode
	DECLARE @SqlUseCode varchar(100)
	IF @UseCode =''
		BEGIN			
			SET 	@SqlUseCode= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlUseCode= '  AND (A.UseGbn = '''+@UseCode +''' ) '
		END
--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode ='1'
		BEGIN			
			SET 	@SqlOrderCode= '  ORDER BY WishAmt '
		END
	ELSE IF @OrderCode ='2'
		BEGIN
			SET 	@SqlOrderCode= '  ORDER BY WishAmt DESC '
		END
                ELSE
		BEGIN
			SET 	@SqlOrderCode= ' ORDER BY AdId DESC  '
		END
--키워드검색
	DECLARE @SqlKeyWord varchar(500)
		IF @StrSearchKeyWord = ''
			BEGIN			
				SET 	@SqlKeyWord= ''
	                                                                                                 
			END
		ELSE
			BEGIN			
				SET 	@SqlKeyWord= 'AND ( C.codeNm1 LIKE  ''%' + @StrSearchKeyWord+'%''  OR C.codeNm2 LIKE ''%' + @StrSearchKeyWord+'%'' OR C.CodeNm3 LIKE  ''%' + @StrSearchKeyWord+'%'' OR  A.BrandNmDt Like ''%' + @StrSearchKeyWord +'%'' ) ' 
	                                                                                                 
			END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlstrCode2 +@SqlstrCode3+ @SqlbajaCode + @SqlPicCode + @SqlUseCode +@SqlKeyWord
		END
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalSite = ''
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
			IF @Option = '0'
				SET @SqlLocalGoods = ' ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND L.LocalSite=' + @StrLocal + ') OR ' +
								' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
							' ) '
			ELSE
				SET @SqlLocalGoods = ' ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ')  ' +
							' ) '
		END
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
		CASE
		WHEN @Option = '0' THEN
			' SELECT COUNT(A.Adid) FROM '+
			' GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted), CatCode C WITH (NoLock, ReadUnCommitted)' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag <> ''1'' AND B.SaleOkFlag<>''1'' ' +
			' AND B.StateChk< ''4'' AND ' + @SqlLocalGoods + @SqlAll
--			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' )  '
		ELSE
			'SELECT  Count(A.AdId) as HotCnt  '+
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted), CatCode C WITH (NoLock, ReadUnCommitted)' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag <> ''1'' AND B.SaleOkFlag<>''1'' ' +
			' AND B.StateChk< ''4'' ' + ' AND ' + @SqlLocalGoods + @SqlAll +
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE()  '
		END
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcCateList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcCateList]
(
	@GetCount		varchar(10)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option			varchar(20)	--옵션 종류
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(30)
,	@AdultCode		char(1)
,	@WishAmtGbn		char(1)
,	@ZipMain		varchar(50)
,	@ZipSub		        varchar(50)
,	@SearchText		varchar(50)
,	@OrderCode		char(1)
,	@StrLocal		char(2)		-- 지역코드
,	@CountChk		char(1)		-- 카운트 Flag
)
AS
--Code값
	DECLARE @SqlstrCode varchar(100) ; SET @SqlstrCode = ''
	IF @StrCode3 <> ''	SET @SqlstrCode = ' AND B.Code3='+@StrCode3
	ELSE IF @StrCode2 <> ''	SET @SqlstrCode = ' AND B.Code2='+@StrCode2

--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '

--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

--WishAmtGbn
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''	
	IF       @WishAmtGbn = '0' 	SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 AND (B.Code3 <> 131015) '
	Else IF  @WishAmtGbn='1'	SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn='2' 	SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '
	Else IF  @WishAmtGbn='3' 	SET @SqlWishAmtGbn = ' AND A.WishAmt = -4 '

--ZipCode
	DECLARE @SqlZipCode varchar(150); SET @SqlZipCode=''
	IF @ZipMain <> ''
	BEGIN
		SET @SqlZipCode= ' AND B.ZipMain = '''+@ZipMain+''' '
		IF @ZipSub <> ''	SET @SqlZipCode= @SqlZipCode + ' AND B.ZipSub LIKE '''+@ZipSub+'%'' '
	END

--@SearchText
	DECLARE @SqlSearchText varchar(200); SET @SqlSearchText=''
	IF @SearchText <> ''	SET @SqlSearchText= ' AND ( A.BrandNm LIKE ''%'+@SearchText+'%'' OR A.BrandNmDt LIKE ''%'+@SearchText+'%'' ) '

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode='1'	SET @SqlOrderCode = ' ORDER BY WishAmt ASC, '
	ELSE IF @OrderCode='2'	SET @SqlOrderCode = ' ORDER BY ViewCnt DESC, '
	ELSE			SET @SqlOrderCode = ' ORDER BY '

--옵션리스트인 경우 게재 시작일 기준으로 변경
	IF @Option <> ''	SET @SqlOrderCode = @SqlOrderCode + ' B.PrnStDate DESC '
	ELSE			SET @SqlOrderCode = @SqlOrderCode + ' B.RegDate DESC '


--전체검색쿼리묶음
	DECLARE @SqlAll	varchar(700)
	SET @SqlAll = @SqlstrCode + @SqlEscrowYNCode + @SqlPicCode + @SqlUseCode + @SqlAdultCode + @SqlWishAmtGbn + @SqlZipCode + @SqlSearchText


--유료옵션시 결제완료 여부
	DECLARE @SqlCondition varchar(200) ; SET @SqlCondition = ''
	DECLARE @SqlRegDate varchar(100) ; SET @SqlRegDate = ''
	IF @Option <> ''
		BEGIN
		SET @SqlCondition = ' AND ' + @Option + '=1  AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() AND B.LocalSite=' + @StrLocal
		SET @SqlRegDate = ' CONVERT(CHAR(10),B.PrnStDate,120) AS RegDate '
		END
	ELSE
		BEGIN
		SET @SqlCondition = ' '
		SET @SqlRegDate = ' CONVERT(CHAR(10),B.RegDate,120) AS RegDate '
		END

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'	SET @SqlLocalGoods = '' 
--	ELSE			SET @SqlLocalGoods = ' AND ( B.LocalBranch in  (Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ')  OR B.ZipMain = ''전국'' ) '
	ELSE			SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0 OR B.ShowLocalSite=' + @StrLocal + ')'

	
	DECLARE @strQuery varchar(3000)
	IF @CountChk = '1'
		BEGIN
		SET @strQuery           = ' SELECT  COUNT(A.AdId) Cnt' 
		SET @SqlOrderCode       = ''
		END
	ELSE
		BEGIN
		SET @strQuery = ' SELECT TOP ' + @GetCount + '' +
				' A.AdId, A.BrandNmDt, A.BrandNm, A.WishAmt, A.UseGbn, ' +
--				' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, ' +
				@SqlRegDate + 
				', CASE WHEN B.PrnAmtOk=''1'' THEN B.SpecFlag ELSE '''' END AS SpecFlag, ' +
				'  CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 

				' OptType,OptList,OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,' +
				' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub, ' +
				' A.CardYN, A.PicIdx1, A.PicIdx2, B.ViewCnt, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, B.EscrowYN, P.PicImage, B.LocalSite, B.PLineKeyNo, S.UserId AS MiniShop, B.RegDate, B.Keyword, S.CUID ' 
		END

	SET @strQuery =	@strQuery +
				' FROM GoodsSubSale A WITH (NoLock), GoodsMain B WITH (NoLock), CatCode C WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock) ' + 
				' , (Select UserId , CUID From SellerMiniShop WITH (NoLock) WHERE Delflag=''0'') S ' + 
				' WHERE A.AdId = B.AdId  AND B.Code1 = ' + @strCode1 +
				' AND B.Code3 = C.Code3 AND B.AdId *=M.AdId AND B.AdId *= P.AdId AND B.UserId*=S.UserId  AND B.CUID *= S.CUID ' +
				' AND B.DelFlag = ''0'' ' +
--				' AND B.SpecFlag <> ''1'' ' +
				' AND B.SaleOkFlag<>''1'' ' +
				' AND B.RegAmtOk = ''1'' ' +
				' AND P.PicIdx = 6 ' +
				' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) ' + 	
				' AND B.StateChk = ''1'' ' + @SqlLocalGoods + @SqlAll + @SqlCondition + @SqlOrderCode
			
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcCateList_new]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcCateList_new]
(
	@Page			int
,	@PageSize		int
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option			Char(1)
,	@BajaCode		Char(1)
,	@PicCode		Char(1)
,	@UseCode		Varchar(30)
,	@OrderCode		char(1)
,	@StrSearchKeyWord	varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
)
AS

--Code2값
	DECLARE @SqlstrCode2 varchar(100)
	IF @StrCode2 =''
		BEGIN			
			SET 	@SqlstrCode2= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode2= ' AND B.code2='+@StrCode2 +''
		END
--Code3값
	DECLARE @SqlstrCode3 varchar(100)
	IF @StrCode3 =''
		BEGIN			
			SET 	@SqlstrCode3= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode3= ' AND B.code3='+@StrCode3 +''
		END
--bajaCode바자회여부
	DECLARE @SqlbajaCode varchar(100)
	IF @bajaCode ='1'
	                BEGIN
			SET 	 @SqlbajaCode= ' AND B.SpecFlag = ''2'' '
		END
                                
               ELSE 
                                BEGIN			
			SET 	 @SqlbajaCode= ''
		END
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100)
	IF @PicCode ='1'
	                BEGIN
			SET 	 @SqlPicCode= ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
		END
                                
               ELSE 
                                BEGIN			
			SET 	 @SqlPicCode= ''
		END

--UseCode
	DECLARE @SqlUseCode varchar(100)
	IF @UseCode =''
		BEGIN			
			SET 	@SqlUseCode= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlUseCode= '  AND (A.UseGbn = '''+@UseCode +''' ) '
		END
--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode ='1'
		BEGIN			
			SET 	@SqlOrderCode= ' WishAmt '
		END
	ELSE IF @OrderCode ='2'
		BEGIN
			SET 	@SqlOrderCode= ' WishAmt DESC '
		END
                ELSE
		BEGIN
			SET 	@SqlOrderCode= ' AdId DESC  '
		END
--키워드검색
	DECLARE @SqlKeyWord varchar(500)
	IF @StrSearchKeyWord =''
		BEGIN			
			SET 	@SqlKeyWord= ''
		END
	ELSE  
		BEGIN			
			SET 	@SqlKeyWord= 'AND ( C.codeNm1 LIKE  ''%' + @StrSearchKeyWord+'%''  OR C.codeNm2 LIKE ''%' + @StrSearchKeyWord+'%'' OR C.CodeNm3 LIKE  ''%' + @StrSearchKeyWord+'%'' OR  A.BrandNmDt Like ''%' + @StrSearchKeyWord +'%'' ) ' 
                                                                                                 
		END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlstrCode2 +@SqlstrCode3+ @SqlbajaCode + @SqlPicCode + @SqlUseCode +@SqlKeyWord
		END

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)

	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') ' +
						' ) '
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
		END


	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
		CASE
		WHEN @Option = '0' THEN
			' Select Distinct  TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			' A.AdId AdId, A.BrandNmDt BrandNmDt, A.WishAmt WishAmt, A.UseGbn UseGbn, '+
			' B.UserID UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
			' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
			' B.OptType OptType,  B.OptColor OptColor, B.OptLocalBranch OptLocalBranch,  B.LocalBranch LocalBranch, B.ZipMain ZipMain, B.ZipSub ZipSub,A.buyAmt buyAmt, '+
			' A.CardYN CardYN,B.EscrowYN EscrowYN, A.PicIdx1 PicIdx1, A.PicIdx2	PicIdx2 , B.CUID '+
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag <> ''1'' AND B.SaleOkFlag<>''1'' ' +
			' AND B.StateChk < ''4'' AND ' + @SqlLocalGoods + @SqlAll +
			' ORDER BY OptType, '+@SqlOrderCode
		ELSE
			' Select ' +
			' A.AdId AdId, A.BrandNmDt BrandNmDt, A.WishAmt WishAmt, A.UseGbn UseGbn, '+
			' B.UserID UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
			' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
			' B.OptType OptType,  B.OptColor OptColor, B.OptLocalBranch OptLocalBranch,  B.LocalBranch LocalBranch, B.ZipMain ZipMain, B.ZipSub ZipSub,A.buyAmt buyAmt, '+
			' A.CardYN CardYN,B.EscrowYN EscrowYN, A.PicIdx1 PicIdx1, A.PicIdx2	PicIdx2, B.CUID  '+
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag <> ''1'' AND B.SaleOkFlag<>''1'' ' +
			' AND B.StateChk < ''4'' ' + ' AND ' + @SqlLocalGoods + @SqlAll +
			' AND B.OptType = ' + @Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() ORDER BY OptType, ' + @SqlOrderCode
		END

PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcCateList_Test]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcCateList_Test]
(
	@GetCount		varchar(10)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option			varchar(20)	--옵션 종류
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(30)
,	@AdultCode		char(1)
,	@ListGbnCode		char(1)
,	@WishAmtGbn		char(1)
,	@OrderCode		char(1)
,	@StrLocal		char(2)		-- 지역코드
,	@CountChk		char(1)		-- 카운트 Flag
)
AS
--Code값
	DECLARE @SqlstrCode varchar(100) ; SET @SqlstrCode = ''
	IF @StrCode3 <> ''	SET @SqlstrCode = ' AND B.Code3='+@StrCode3
	ELSE IF @StrCode2 <> ''	SET @SqlstrCode = ' AND B.Code2='+@StrCode2

--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '

--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2415) '

--ListGbnCode
	DECLARE @SqlListGbnCode varchar(100); SET @SqlListGbnCode=''
	DECLARE @SqlNothingCode varchar(100); SET @SqlNothingCode=''
	
	--주간등록리스트
	IF @ListGbnCode = '1'	
		BEGIN
			SET @SqlListGbnCode = ' AND B.RegDate > GETDATE()-7 '
			SET @SqlNothingCode = ''	
		END
	--카테고리리스트
	ELSE 
		BEGIN
			SET @SqlListGbnCode = ''
			SET @SqlNothingCode = ' AND B.Code1 = ' + @strCode1
		END
--WishAmtGbn
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''	
	IF @WishAmtGbn = '0' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 '
	Else IF  @WishAmtGbn = '1' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn = '2' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode = '1'
		SET @SqlOrderCode = ' ORDER BY WishAmt Asc, A.AdId DESC '
	ELSE IF @OrderCode = '2'
		SET @SqlOrderCode = ' ORDER BY ViewCnt Desc, A.AdId DESC '
	ELSE
		SET @SqlOrderCode = ' ORDER BY A.AdId DESC '	


--전체검색쿼리묶음
	DECLARE @SqlAll	varchar(500)
	SET @SqlAll = @SqlstrCode + @SqlEscrowYNCode + @SqlPicCode + @SqlUseCode + @SqlAdultCode + @SqlListGbnCode + @SqlWishAmtGbn


--유료옵션시 결제완료 여부
	DECLARE @SqlCondition varchar(200) ; SET @SqlCondition = ''
	IF @Option <> ''		 
		SET @SqlCondition = ' AND ' + @Option + '=1  AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() '
	ELSE
		SET @SqlCondition = ' '

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		
		SET @SqlLocalGoods = '' 
	ELSE
		SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
				          ' (Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ')  OR B.ZipMain = ''전국'' ) '
	
	DECLARE @strQuery varchar(3000)

	IF @CountChk = '1'
	BEGIN
		SET @strQuery = 	' SELECT  COUNT(A.AdId) Cnt' 
		SET @SqlOrderCode = ''
	END
	ELSE
	BEGIN
		SET @strQuery = 	' SELECT TOP ' + @GetCount + '' +
				' A.AdId, A.BrandNmDt, A.WishAmt, A.UseGbn, ' +
				' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, ' +
				' CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 
				' OptType,OptList,OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,' +
				' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub, ' +
				' A.CardYN, A.PicIdx1, A.PicIdx2, B.ViewCnt, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, B.EscrowYN, P.PicImage ' 
	END

	SET @strQuery = 	@strQuery +
			' FROM GoodsSubSale A WITH (NoLock), GoodsMain B WITH (NoLock), CatCode C WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock) ' + 
			' WHERE A.AdId = B.AdId ' + @SqlNothingCode +
			' AND B.Code3 = C.Code3 AND B.AdId *=M.AdId AND B.AdId *= P.AdId ' +
			' AND B.DelFlag = ''0'' ' +
--			' AND B.SpecFlag <> ''1'' ' +
			' AND B.SaleOkFlag<>''1'' ' +
			' AND B.RegAmtOk = ''1'' ' +
			' AND P.PicIdx = 6 ' +
			' AND B.StateChk = ''1'' ' + @SqlLocalGoods + @SqlAll + @SqlCondition + @SqlOrderCode
			
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcCateList2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcCateList2]
(
	@Page			int
,	@PageSize		int
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option			Char(1)
,	@BajaCode		Char(1)
,	@PicCode		Char(1)
,	@UseCode		Varchar(30)
,	@OrderCode		char(1)
,	@StrSearchKeyWord	varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
)
AS
--Code2값
	DECLARE @SqlstrCode2 varchar(100)
	IF @StrCode2 =''
		BEGIN			
			SET 	@SqlstrCode2= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode2= ' AND B.code2='+@StrCode2 +''
		END
--Code3값
	DECLARE @SqlstrCode3 varchar(100)
	IF @StrCode3 =''
		BEGIN			
			SET 	@SqlstrCode3= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode3= ' AND B.code3='+@StrCode3 +''
		END
--bajaCode바자회여부
	DECLARE @SqlbajaCode varchar(100)
	IF @bajaCode ='1'
	                BEGIN
			SET 	 @SqlbajaCode= ' AND B.SpecFlag = ''2'' '
		END
                                
               ELSE 
                                BEGIN			
			SET 	 @SqlbajaCode= ''
		END
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100)
	IF @PicCode ='1'
	                BEGIN
			SET 	 @SqlPicCode= ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
		END
                                
               ELSE 
                                BEGIN			
			SET 	 @SqlPicCode= ''
		END
--UseCode
	DECLARE @SqlUseCode varchar(100)
	IF @UseCode =''
		BEGIN			
			SET 	@SqlUseCode= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlUseCode= '  AND (A.UseGbn = '''+@UseCode +''' ) '
		END
--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode ='1'
		BEGIN			
			SET 	@SqlOrderCode= ' WishAmt '
		END
	ELSE IF @OrderCode ='2'
		BEGIN
			SET 	@SqlOrderCode= ' WishAmt DESC '
		END
                ELSE
		BEGIN
			SET 	@SqlOrderCode= ' AdId DESC  '
		END
--키워드검색
	DECLARE @SqlKeyWord varchar(500)
	IF @StrSearchKeyWord =''
		BEGIN			
			SET 	@SqlKeyWord= ''
		END
	ELSE  
		BEGIN			
			SET 	@SqlKeyWord= 'AND ( C.codeNm1 LIKE  ''%' + @StrSearchKeyWord+'%''  OR C.codeNm2 LIKE ''%' + @StrSearchKeyWord+'%'' OR C.CodeNm3 LIKE  ''%' + @StrSearchKeyWord+'%'' OR  A.BrandNmDt Like ''%' + @StrSearchKeyWord +'%'' ) ' 
                                                                                                 
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlstrCode2 +@SqlstrCode3+ @SqlbajaCode + @SqlPicCode + @SqlUseCode +@SqlKeyWord
		END
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalSite = ''
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
			IF @Option = '0'
				SET @SqlLocalGoods = ' ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') OR ' +
								' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
							' ) '
			ELSE
				SET @SqlLocalGoods = ' ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ')  ' +
							' ) '
		END
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
		CASE
		WHEN @Option = '0' THEN
			' Select TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			' A.AdId AdId, A.BrandNmDt BrandNmDt, A.WishAmt WishAmt, A.UseGbn UseGbn, '+
			' B.UserID UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
			' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
			' B.OptType OptType,  B.OptColor OptColor, B.OptLocalBranch OptLocalBranch,  B.LocalBranch LocalBranch, B.ZipMain ZipMain, B.ZipSub ZipSub,A.buyAmt buyAmt, '+
			' A.CardYN CardYN,B.EscrowYN EscrowYN, A.PicIdx1 PicIdx1, A.PicIdx2	PicIdx2, B.CUID '+
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag <> ''1'' AND B.SaleOkFlag<>''1'' ' +
			' AND B.StateChk < ''4'' AND ' + @SqlLocalGoods + @SqlAll +
			' ORDER BY OptType, '+@SqlOrderCode
		ELSE
			' Select ' +
			' A.AdId AdId, A.BrandNmDt BrandNmDt, A.WishAmt WishAmt, A.UseGbn UseGbn, '+
			' B.UserID UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
			' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
			' B.OptType OptType,  B.OptColor OptColor, B.OptLocalBranch OptLocalBranch,  B.LocalBranch LocalBranch, B.ZipMain ZipMain, B.ZipSub ZipSub,A.buyAmt buyAmt, '+
			' A.CardYN CardYN,B.EscrowYN EscrowYN, A.PicIdx1 PicIdx1, A.PicIdx2	PicIdx2, B.CUID '+
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag <> ''1'' AND B.SaleOkFlag<>''1'' ' +
			' AND B.StateChk < ''4'' ' + ' AND ' + @SqlLocalGoods + @SqlAll +
			' AND B.OptType = ' + @Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() ORDER BY OptType, ' + @SqlOrderCode
		END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcCateList22]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcCateList22]
(
	@GetCount		varchar(10)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option			varchar(20)	--옵션 종류
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(30)
,	@AdultCode		char(1)
,	@WishAmtGbn		char(1)
,	@ZipMain		varchar(50)
,	@ZipSub		varchar(50)
,	@SearchText		varchar(50)
,	@OrderCode		char(1)
,	@StrLocal		char(2)		-- 지역코드
,	@CountChk		char(1)		-- 카운트 Flag
)
AS
--Code값
	DECLARE @SqlstrCode varchar(100) ; SET @SqlstrCode = ''
	IF @StrCode3 <> ''	SET @SqlstrCode = ' AND B.Code3='+@StrCode3
	ELSE IF @StrCode2 <> ''	SET @SqlstrCode = ' AND B.Code2='+@StrCode2

--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '

--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

--WishAmtGbn
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''	
	IF @WishAmtGbn = '0' 	SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 '
	Else IF  @WishAmtGbn='1'	SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn='2' 	SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '

--ZipCode
	DECLARE @SqlZipCode varchar(150); SET @SqlZipCode=''
	IF @ZipMain <> ''
	BEGIN
		SET @SqlZipCode= ' AND B.ZipMain = '''+@ZipMain+''' '
		IF @ZipSub <> ''	SET @SqlZipCode= @SqlZipCode + ' AND B.ZipSub= '''+@ZipSub+''' '
	END

--@SearchText
	DECLARE @SqlSearchText varchar(200); SET @SqlSearchText=''
	IF @SearchText <> ''	SET @SqlSearchText= ' AND ( A.BrandNm LIKE ''%'+@SearchText+'%'' OR A.BrandNmDt LIKE ''%'+@SearchText+'%'' ) '

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode='1'	SET @SqlOrderCode = ' ORDER BY WishAmt ASC, '
	ELSE IF @OrderCode='2'	SET @SqlOrderCode = ' ORDER BY ViewCnt DESC, '
	ELSE			SET @SqlOrderCode = ' ORDER BY '

--옵션리스트인 경우 게재 시작일 기준으로 변경
	IF @Option <> ''		SET @SqlOrderCode = @SqlOrderCode + ' B.PrnStDate DESC '
	ELSE			SET @SqlOrderCode = @SqlOrderCode + ' B.AdId DESC '


--전체검색쿼리묶음
	DECLARE @SqlAll	varchar(700)
	SET @SqlAll = @SqlstrCode + @SqlEscrowYNCode + @SqlPicCode + @SqlUseCode + @SqlAdultCode + @SqlWishAmtGbn + @SqlZipCode + @SqlSearchText


--유료옵션시 결제완료 여부
	DECLARE @SqlCondition varchar(200) ; SET @SqlCondition = ''
	DECLARE @SqlRegDate varchar(100) ; SET @SqlRegDate = ''
	IF @Option <> ''
		BEGIN
		SET @SqlCondition = ' AND ' + @Option + '=1  AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() AND B.LocalSite=' + @StrLocal
		SET @SqlRegDate = ' CONVERT(CHAR(10),B.PrnStDate,120) AS RegDate '
		END
	ELSE
		BEGIN
		SET @SqlCondition = ' '
		SET @SqlRegDate = ' CONVERT(CHAR(10),B.RegDate,120) AS RegDate '
		END

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'		SET @SqlLocalGoods = '' 
--	ELSE			SET @SqlLocalGoods = ' AND ( B.LocalBranch in  (Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ')  OR B.ZipMain = ''전국'' ) '
	ELSE			SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0 OR B.ShowLocalSite=' + @StrLocal + ')'

	
	DECLARE @strQuery varchar(3000)
	IF @CountChk = '1'
		BEGIN
		SET @strQuery = 	' SELECT  COUNT(A.AdId) Cnt' 
		SET @SqlOrderCode = ''
		END
	ELSE
		BEGIN
		SET @strQuery = 	' SELECT TOP ' + @GetCount + '' +
				' A.AdId, A.BrandNmDt, A.WishAmt, A.UseGbn, ' +
--				' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, ' +
				@SqlRegDate + ', B.SpecFlag, ' +
				' CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 
				' OptType,OptList,OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,' +
				' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub, ' +
				' A.CardYN, A.PicIdx1, A.PicIdx2, B.ViewCnt, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, B.EscrowYN, P.PicImage, B.LocalSite ' 
		END

	SET @strQuery =	@strQuery +
				' FROM GoodsSubSale A WITH (NoLock), GoodsMain B WITH (NoLock), CatCode C WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock) ' + 
				' WHERE A.AdId = B.AdId  AND B.Code1 = ' + @strCode1 +
				' AND B.Code3 = C.Code3 AND B.AdId *=M.AdId AND B.AdId *= P.AdId ' +
				' AND B.DelFlag = ''0'' ' +
--				' AND B.SpecFlag <> ''1'' ' +
				' AND B.SaleOkFlag<>''1'' ' +
				' AND B.RegAmtOk = ''1'' ' +
				' AND (regdate+30 > GETDATE() or prnendate >= GETDATE() ) ' +
				' AND P.PicIdx = 6 ' +
				' AND B.StateChk = ''1'' ' + @SqlLocalGoods + @SqlAll + @SqlCondition + @SqlOrderCode
			
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcCateListCount]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcCateListCount]
(
	@GetCount		varchar(10)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option			varchar(20)			--옵션 종류
,	@BajaCode		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(30)
,	@OrderCodeAmt		char(1)
,	@OrderCodeView		char(1)
,	@StrSearchKeyWord	varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
)
AS
--Code값
	DECLARE @SqlstrCode varchar(100) ; SET @SqlstrCode = ''
	IF @StrCode3 <> ''	SET @SqlstrCode = ' AND B.Code3='+@StrCode3
	ELSE IF @StrCode2 <> ''	SET @SqlstrCode = ' AND B.Code2='+@StrCode2
--bajaCode바자회여부
	DECLARE @SqlbajaCode varchar(100) ; SET @SqlbajaCode = ''
	IF @bajaCode = '1'	SET @SqlbajaCode = ' AND B.SpecFlag = ''2'' '
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '
--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	DECLARE @SqlOrderCodeAmt varchar(20)		--가격 정렬
	DECLARE @SqlOrderCodeView varchar(20)		--조회수 정렬
	IF @OrderCodeAmt <> '' OR @OrderCodeView <> ''
	BEGIN
		SET @SqlOrderCodeAmt = ''
		SET @SqlOrderCodeView = ''	
		SET @SqlOrderCode =''
		--가격순 정렬
		IF @OrderCodeAmt = '1'
			SET @SqlOrderCodeAmt = ',WishAmt Asc '
		ELSE IF @OrderCodeAmt = '0'
			SET @SqlOrderCodeAmt = ',WishAmt Desc '
		ELSE
			SET @SqlOrderCodeAmt = ''
		--조회수 정렬
		IF @OrderCodeView = '1'
			SET @SqlOrderCodeView = ',ViewCnt Desc '		
		ELSE IF	@OrderCodeView = '0'
			SET @SqlOrderCodeView = ',ViewCnt Asc '	
		ELSE
			SET @SqlOrderCodeView = ''	

		SET @SqlOrderCode = ' ORDER BY OptType' + @SqlOrderCodeAmt + @SqlOrderCodeView
		
	END
	ELSE
	BEGIN
		SET @SqlOrderCode = ' ORDER BY OptType, A.AdId DESC '		
	END
	
--키워드검색
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @StrSearchKeyWord <> ''	SET @SqlKeyWord = ' AND ( C.CodeNm1 LIKE  ''%' + @StrSearchKeyWord+'%''  OR C.CodeNm2 LIKE ''%' + @StrSearchKeyWord+'%'' OR C.CodeNm3 LIKE  ''%' + @StrSearchKeyWord+'%'' OR A.BrandNmDt Like ''%' + @StrSearchKeyWord +'%'' ) ' 
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
	SET @SqlAll = @SqlstrCode + @SqlbajaCode + @SqlPicCode + @SqlUseCode + @SqlKeyWord
--유료옵션시 결제완료 여부
	DECLARE @SqlCondition varchar(200) ; SET @SqlCondition = ''
	IF @Option <> ''		
		SET @SqlCondition = ' AND ' + @Option + '=1 AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() '
	ELSE
		SET @SqlCondition = ''


--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalSite = ''
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
			IF @Option = '0'
				SET @SqlLocalGoods = ' ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND L.LocalSite=' + @StrLocal + ') OR ' +
								' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
							' ) '
			ELSE
				SET @SqlLocalGoods = ' ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ')  ' +
							' ) '
		END
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 	
			
			' SELECT  COUNT(A.AdId) ' + 
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted), CatCode C WITH (NoLock, ReadUnCommitted)' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag = ''0'' ' +
			' AND B.SpecFlag <> ''1'' ' +
			' AND B.SaleOkFlag<>''1'' ' +
			' AND B.RegAmtOk = ''1'' ' +
			' AND B.StateChk = ''1'' AND ' + @SqlLocalGoods + @SqlAll + @SqlCondition + @SqlOrderCode + ';' 
			
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procCoopChargeEnd]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[procCoopChargeEnd]
(
                @strPartner		varchar(10)	--제휴사코드
,               @strStartDate		varchar(10)	-- 정산월
)
AS
CREATE TABLE #Temp_LineCount
(
	ChargeKind  	Char(1)
,  	Count    	int
,  	PrnAmt  	int 
);
			INSERT INTO #Temp_LineCount
			SELECT (CASE WHEN A.AdGbn=0 THEN ISNULL(R.ChargeKind,'0') ELSE ISNULL(R.ChargeKind,'0')+4 END) AS ChargeKind , COUNT(*), SUM(C.PrnAmt)
			FROM GoodsMain A, RecChargeDetail C, RecCharge R
			WHERE  A.AdId=C.AdId AND C.GrpSerial=R.GrpSerial AND A.PartnerCode=@strPartner
                                          AND Left(CONVERT(varchar(10), A.RegDate, 120),7)=@strStartDate
			AND C.SettleFlag='Y' AND C.SettleEndFlag='Y' AND C.SettleEndDay<>''
			GROUP BY A.AdGbn, ChargeKind

CREATE TABLE #Temp_LineCount1
(	ChargeKind		int
,	Count1		int   DEFAULT 0
,	PrnAmt1               int   DEFAULT 0
 PRIMARY KEY (ChargeKind));
INSERT INTO #Temp_LineCount1 (ChargeKind) values (0)
INSERT INTO #Temp_LineCount1 (ChargeKind) values (1)
INSERT INTO #Temp_LineCount1 (ChargeKind) values (2)
INSERT INTO #Temp_LineCount1 (ChargeKind) values (3)
INSERT INTO #Temp_LineCount1 (ChargeKind) values (4)
INSERT INTO #Temp_LineCount1 (ChargeKind) values (5)
INSERT INTO #Temp_LineCount1 (ChargeKind) values (6)
INSERT INTO #Temp_LineCount1 (ChargeKind) values (7)
UPDATE A
SET A.Count1 = B.Count, A.PrnAmt1 = B.PrnAmt
FROM #Temp_LineCount1 A, #Temp_LineCount B
WHERE  A.ChargeKind=B.ChargeKind
SELECT * FROM #Temp_LineCount1
GO
/****** Object:  StoredProcedure [dbo].[ProcEmoneyDel]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: E-Money 결제 관리-게재후 삭제 내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-21
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcEmoneyDel]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='회원이름'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(2000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(G.GrpSerial) FROM GoodsMain G, RecCharge R, UsedCommon.dbo.Emoney E  ' +
			'WHERE R.GrpSerial = G.GrpSerial And G.UserID = E.UserID  AND G.CUID = E.CUID And G.ChargeKind=''4'' And G.PrnAmtOk=''1''  And  G.StateChk=''4'' And G.ModDate >= G.PrnStDate  ' + @SqlAll + '; ' +
			' SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			' G.GrpSerial,  Convert(varchar(10),R.RecDate,120) as RecDate, Convert(varchar(10),R.CancelDate,120) As CancelDate, ' +
			' Convert(varchar(10),G.PrnStDate,120) As PrnStDate, Count(G.Adid) As AdCount, Sum(G.PrnAmt) As TotPrnAmt, E.SaveAmt, E.FundAmt, G.UserName, G.UserID, G.CUID ' +
			' FROM RecCharge R , GoodsMain G, UsedCommon.dbo.Emoney E  ' +
			' WHERE R.GrpSerial = G.GrpSerial And G.UserID = E.UserID AND G.CUID = E.CUID And G.ChargeKind=''4'' And G.PrnAmtOk=''1'' And G.StateChk=''4'' And G.ModDate >= G.PrnStDate   ' + @SqlAll + ' ' +
			' Group By G.GrpSerial,  Convert(varchar(10),R.RecDate,120), Convert(varchar(10),R.CancelDate,120), Convert(varchar(10),G.PrnStDate,120),  E.SaveAmt, E.FundAmt, G.UserName, G.UserID ' +
			' Order By G.GrpSerial DESC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcEmoneyNormal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: Emoney관리-정상내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-18
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcEmoneyNormal]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='회원이름'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(2000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(G.GrpSerial) FROM GoodsMain G, RecCharge R, UsedCommon.dbo.Emoney E  ' +
			'WHERE R.GrpSerial = G.GrpSerial And G.UserID = E.UserID And G.CUID = E.CUID And G.ChargeKind=''4'' And G.PrnAmtOk=''1'' And G.StateChk=''1'' ' + @SqlAll + ';  ' +
			'SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			' G.GrpSerial, Convert(varchar(10),G.RegDate,120) As RegDate, Count(G.Adid) As AdCount, Sum(G.PrnAmt) As TotPrnAmt, ' +
			' E.SaveAmt, E.FundAmt, G.UserName, G.UserID , G.CUID' +
			' From RecCharge R, GoodsMain G, UsedCommon.dbo.Emoney E  ' +
			' Where R.GrpSerial = G.GrpSerial And G.UserID = E.UserID And G.CUID = E.CUID And G.ChargeKind=''4'' And G.PrnAmtOk=''1'' ' + @SqlAll + ' ' +
			' Group By G.GrpSerial, Convert(varchar(10),G.RegDate,120),  E.SaveAmt, E.FundAmt, G.UserName, G.UserID ' +
			' Order By G.GrpSerial DESC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcEmoneyNormal2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: Emoney관리-정상 내역 검색 프로시저(테스트용)
	제작자	: 이창연
	제작일	: 2002-03-22
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcEmoneyNormal2]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @PlusDay varchar(10)  
		BEGIN
			SET @PlusDay = Convert(varchar(10),(Convert(int,@strLastDt) + 1))
		END
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND G.RegDate >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND G.RegDate <= ''' +@PlusDay+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(G.GrpSerial) FROM GoodsMain G, RecCharge R, UsedCommon.dbo.Emoney E  ' +
			'WHERE R.GrpSerial = G.GrpSerial And G.UserID = E.UserID And G.CUID = E.CUID  And  G.ChargeKind=''4'' And G.PrnAmtOk=''1'' And G.StateChk=''1''  ' + @SqlAll + ';  ' +
			'SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			' G.GrpSerial, Convert(varchar(10),G.RegDate,120) As RegDate,  Count(G.Adid) As AdCount, Sum(G.PrnAmt) As TotPrnAmt, ' +
			' G.UserName, G.UserID, E.SaveAmt, E.FundAmt, G.CUID  ' +
			' From RecCharge R, GoodsMain G, UsedCommon.dbo.Emoney E  ' +
			' Where R.GrpSerial = G.GrpSerial And G.UserID = E.UserID And G.CUID = E.CUID And  G.ChargeKind=''4'' And G.PrnAmtOk=''1'' And G.StateChk=''1''  ' + @SqlAll + ' ' +
			' Group By G.GrpSerial, Convert(varchar(10),G.RegDate,120),  G.UserName, G.UserID, E.SaveAmt, E.FundAmt ' +
			' Order By G.GrpSerial DESC '
	-- 또다른 테스트
	--		'SELECT  COUNT(G.GrpSerial) FROM GoodsMain G, RecCharge R, UsedCommon.dbo.Emoney E  ' +
	--		'WHERE R.GrpSerial = G.GrpSerial And G.UserID = E.UserID And  G.ChargeKind=''4'' And G.PrnAmtOk=''1'' And G.StateChk=''1''  ' + @SqlAll + ';  ' +
	--		'SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
	--		' G.GrpSerial, Convert(varchar(10),G.RegDate,120) As RegDate, G.PrnAmt, ' +
	--		' G.UserName, G.UserID, E.SaveAmt, E.FundAmt  ' +
	--		' From RecCharge R, GoodsMain G, UsedCommon.dbo.Emoney E  ' +
	--		' Where R.GrpSerial = G.GrpSerial And G.UserID = E.UserID And  G.ChargeKind=''4'' And G.PrnAmtOk=''1'' And G.StateChk=''1''  ' + @SqlAll + ' ' +
	--		' Order By G.GrpSerial DESC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcEmoneyRefund]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: Emoney관리-환불 내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-22
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcEmoneyRefund]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(회원이름/회원 ID)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='회원이름'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(2000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(G.GrpSerial) FROM GoodsMain G, RecCharge R, CatCode C, UsedCommon.dbo.Emoney E  ' +
			'WHERE R.GrpSerial = G.GrpSerial And G.UserID = E.UserID And G.CUID = E.CUID And G.Code1=C.Code1 And  G.ChargeKind=''4'' And G.PrnAmtOk=''3'' And G.StateChk=''4'' And E.SaveAmt > 0 ' + @SqlAll + ';  ' +
			'SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			' G.GrpSerial, Convert(varchar(10),G.RegDate,120) As RegDate, C.CodeNm1, Count(G.Adid) As AdCount, Sum(G.PrnAmt) As TotPrnAmt, ' +
			' Convert(varchar(10),R.CanCelDate,120) As CanCelDate, G.UserName, G.UserID, E.SaveAmt, E.FundAmt, G.CUID  ' +
			' From RecCharge R, GoodsMain G, CatCode C, UsedCommon.dbo.Emoney E  ' +
			' Where R.GrpSerial = G.GrpSerial And G.UserID = E.UserID And G.CUID = E.CUID And G.Code1=C.Code1 And  G.ChargeKind=''4'' And G.PrnAmtOk=''3'' And G.StateChk=''4'' And E.SaveAmt > 0 ' + @SqlAll + ' ' +
			' Group By G.GrpSerial, Convert(varchar(10),G.RegDate,120), C.CodeNm1, Convert(varchar(10),R.CanCelDate,120), G.UserName, G.UserID, E.SaveAmt, E.FundAmt ' +
			' Order By G.GrpSerial DESC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcEscrowTotal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 총구매내역 - 관리자페이지  프로시저
	제작자	: 이창연
	제작일	: 2002-03-20
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcEscrowTotal]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND B.ChargeKind='+@strChargeKind +''
		END
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),B.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),B.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
               
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='구매자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND B.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='구매자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND B.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND B.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1500)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(G.Adid) FROM GoodsMain G, Sale_BuyerInfo B  ' +
			' WHERE G.Adid = B.Adid AND G.PrnAmtOk<>''4'' AND G.StateChk <> ''6'' AND B.SaleChk <> ''1''  '+
                                                ' AND B.BuyChk <>''1'' AND B.DelFlagSale <> ''1'' AND B.DelFlagBuy <>''1'' AND NOT( B.ChargeKind=''2''  AND B.ReceiveChk=''0'' )  ' + @SqlAll + ';  ' +
			'  SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'   G.AdId,Convert(varchar(10),B.RegDate,120) as RegDate,G.Code1,B.WishAmt,B.UserName, G.RecNm,  ' +
			'   B.ChargeKind, B.ReceiveChk, B.SendChk, B.Serial, G.SpecFlag ' +
			'   FROM GoodsMain G, Sale_BuyerInfo B ' +
			'   WHERE G.Adid = B.Adid AND G.PrnAmtOk<>''4'' And G.StateChk <> ''6'' AND B.SaleChk <> ''1''   '+
                                                '   AND B.BuyChk <>''1''  AND B.DelFlagSale <> ''1'' AND B.DelFlagBuy <>''1'' AND NOT( B.ChargeKind=''2''  AND B.ReceiveChk=''0'' )  ' + @SqlAll +
			'  ORDER BY B.RegDate DESC ' + ';  ' +
			'  SELECT Sum(Cast(B.WishAmt as decimal)) As TotalSum ' +
			'  FROM GoodsMain G, Sale_BuyerInfo B ' +
			'  WHERE G.Adid = B.Adid  AND G.PrnAmtOk<>''4''  And G.StateChk <> ''6'' AND B.SaleChk <> ''1''  '+
                                                '  AND B.BuyChk <>''1''  AND B.DelFlagSale <> ''1'' AND B.DelFlagBuy <>''1'' AND NOT( B.ChargeKind=''2''  AND B.ReceiveChk=''0'' )  ' + @SqlAll + '  '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcEsLocal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcEsLocal]
(
	@Page			int
,	@PageSize		int
,	@StrLocal        	char(2)	--지역 코드
,	@StrChargeKind	varchar(10)	--결제방법선택(전체/온라인/신용카드)
,	@StrChargeCode            char(1)	                --정산코드(정산/미정산)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord	varchar(30)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord	varchar(50)	-- 키워드
,               @StrDayCode                   Char(1)
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND C.ChargeKind='+@strChargeKind +''
		END
--정산여부
	DECLARE @SqlChargeCode varchar(200)
	IF @StrChargeCode ='1'
		BEGIN
			SET 	@SqlChargeCode= 'AND C.SettleFlag=''Y'' '
		END
	ELSE IF @StrChargeCode ='2' 
		BEGIN
			SET 	@SqlChargeCode= 'AND C.SettleFlag=''N'' '
		END
               ELSE  
		BEGIN			
			SET 	@SqlChargeCode= ''
		END
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		IF @StrDayCode='1'
                                               BEGIN	
			          SET 	@SqlSMakDt= ' AND C.RemitEnDate > ''' +@strStartDt +''' '
		               END
                               ELSE
                                             BEGIN	
			          SET 	@SqlSMakDt= ' AND C.ReceiveDate > ''' +@strStartDt +''' '
		              END 
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		IF  @StrDayCode='1'
                                           BEGIN
			              SET 	@SqlEMakDt= ' AND C.RemitEnDate < ''' +@StrLastDt+ ''''
		            END
                                ELSE
                                            BEGIN
			              SET 	@SqlEMakDt= ' AND C.ReceiveDate < ''' +@StrLastDt+ ''''
		            END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='구매자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND C.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='구매자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--제휴사코드
	DECLARE @SqlLocal varchar(200)
	IF @StrLocal =''
		BEGIN			
			SET 	@SqlLocal= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlLocal= 'AND C.LocalSite='+ CONVERT(varchar(10),@StrLocal)
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind +@SqlChargeCode+ @SqlSMakDt + @SqlEMakDt + @SqlKeyWord+@SqlLocal+' AND C.SettleEndFlag <>''Y'' '
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(4000)
SET @strQuery = 
		'SELECT IsNull(Sum(C.PartAmount),0) FROM GoodsMain G, Sale_BuyerInfo C  ' +
		' WHERE G.Adid = C.Adid And C.LocalSite<> 0 AND ReceiveChk=''1'' AND RemitChk=''2'' AND C.SettleFlag=''Y'' ' + @SqlAll + ';  ' +
		'SELECT IsNull(Sum(C.PartAmount),0) FROM GoodsMain G, Sale_BuyerInfo C  ' +
		' WHERE G.Adid = C.Adid And C.LocalSite<> 0 AND ReceiveChk=''1'' AND RemitChk=''2'' AND C.SettleFlag=''N''  ' + @SqlAll + ';  ' +
		'SELECT  IsNull(Sum(C.EscrowCharge),0), IsNull(Sum(C.PartAmount),0) FROM GoodsMain G, Sale_BuyerInfo C  ' +
		' WHERE G.Adid = C.Adid And C.LocalSite<> 0 AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ';  ' +
		'SELECT COUNT(C.Adid) FROM GoodsMain G, Sale_BuyerInfo C  ' +
		' WHERE G.Adid = C.Adid And C.LocalSite<> 0 AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ';  ' +
		' SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
		'  C.Serial,C.AdId,Convert(varchar(10),C.ReceiveDate,120) as ReceiveDate,Convert(varchar(10),C.RemitEnDate,120) as RemitEnDate,  ' +
		'  C.WishAmt, S.CodeNm1,C.UserID,C.EscrowCharge,C.PartAmount,C.SettleFlag,Convert(varchar(10),C.SettleDay,120) as SettleDay,  ' +
		'  C.ChargeKind,C.LocalSite,G.LocalBranch,G.OptLocalBranch, C.LocalSite , C.CUID' +
		'  FROM GoodsMain G, CatCode S, Sale_buyerInfo C ' +
		'  WHERE G.Adid=C.Adid And C.LocalSite<> 0 AND G.Code1=S.Code1 AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ' ' +
		'  ORDER BY C.Adid DESC '
	
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcEsPart]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcEsPart]
(
	@Page			int
,	@PageSize		int
,	@StrPartner         	varchar(10)          --제휴사
,	@StrChargeKind	varchar(10)	--결제방법선택(전체/온라인/신용카드)
,	@StrChargeCode            char(1)	                --정산코드(정산/미정산)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord	varchar(30)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord	varchar(50)	-- 키워드
,               @StrDayCode                   Char(1)
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND C.ChargeKind='+@strChargeKind +''
		END
--정산여부
	DECLARE @SqlChargeCode varchar(200)
	IF @StrChargeCode ='1'
		BEGIN
			SET 	@SqlChargeCode= 'AND C.SettleFlag=''Y'' '
		END
	ELSE IF @StrChargeCode ='2' 
		BEGIN
			SET 	@SqlChargeCode= 'AND C.SettleFlag=''N'' '
		END
               ELSE  
		BEGIN			
			SET 	@SqlChargeCode= ''
		END
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		IF @StrDayCode='1'
                                               BEGIN	
			          SET 	@SqlSMakDt= ' AND Convert(varchar(10),C.RemitEnDate,112) >= ''' +@strStartDt +''''
		               END
                               ELSE
                                             BEGIN	
			          SET 	@SqlSMakDt= ' AND Convert(varchar(10),C.ReceiveDate,112) >= ''' +@strStartDt +''''
		              END 
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		IF  @StrDayCode='1'
                                           BEGIN
			              SET 	@SqlEMakDt= ' AND Convert(varchar(10),C.RemitEnDate,112) <= ''' +@StrLastDt+ ''''
		            END
                                ELSE
                                            BEGIN
			              SET 	@SqlEMakDt= ' AND Convert(varchar(10),C.ReceiveDate,112) <= ''' +@StrLastDt+ ''''
		            END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='구매자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND C.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='구매자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--제휴사코드
	DECLARE @SqlPart varchar(200)
	IF @StrPartner ='0'
		BEGIN			
			SET 	@SqlPart= 'AND C.PartnerCode<>''0'' '
		END
	ELSE  
		BEGIN
			SET 	@SqlPart= 'AND C.PartnerCode='''+@strPartner +''''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind +@SqlChargeCode+ @SqlSMakDt + @SqlEMakDt + @SqlKeyWord+@SqlPart+' AND C.SettleEndFlag <>''Y'' '
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(2000)
SET @strQuery = 
                                                'SELECT IsNull(Sum(C.PartAmount),0) FROM vi_GoodsMain G, Sale_BuyerInfo C  ' +
			' WHERE G.Adid = C.Adid AND ReceiveChk=''1'' AND RemitChk=''2'' AND C.SettleFlag=''Y'' ' + @SqlAll + ';  ' +
                                                'SELECT IsNull(Sum(C.PartAmount),0) FROM vi_GoodsMain G, Sale_BuyerInfo C  ' +
			' WHERE G.Adid = C.Adid AND ReceiveChk=''1'' AND RemitChk=''2'' AND C.SettleFlag=''N''  ' + @SqlAll + ';  ' +
                                                'SELECT  IsNull(Sum(C.EscrowCharge),0), IsNull(Sum(C.PartAmount),0) FROM vi_GoodsMain G, Sale_BuyerInfo C  ' +
			' WHERE G.Adid = C.Adid AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ';  ' +
			'SELECT TOP 1 COUNT(C.Adid) FROM vi_GoodsMain G, Sale_BuyerInfo C  ' +
			' WHERE G.Adid = C.Adid AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ';  ' +
			' SELECT DISTINCT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  C.Serial,C.AdId,Convert(varchar(10),C.ReceiveDate,120) as ReceiveDate,Convert(varchar(10),C.RemitEnDate,120) as RemitEnDate,  ' +
                                                '  C.WishAmt, S.CodeNm1,C.UserID,C.EscrowCharge,C.PartAmount,C.SettleFlag,Convert(varchar(10),C.SettleDay,120) as SettleDay,  ' +
			'  C.ChargeKind,C.PartnerCode, C.CUID ' +
			'  FROM vi_GoodsMain G, CatCode S, Sale_buyerInfo C ' +
			'  WHERE G.Adid=C.Adid AND G.Code1=S.Code1 AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ' ' +
			'  ORDER BY C.Adid DESC '
	
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcEtcBuyCateList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcEtcBuyCateList]
(
	@GetCount		varchar(10)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(100)
,	@StrCode3		varchar(100)
,	@whichCode		varchar(10)
,	@Option			varchar(20)	--옵션 종류
,	@UseCode		varchar(30)
,	@AdultCode		char(1)		
,	@OrderCode		char(1)
,	@StrSearchKeyWord	varchar(50)	--키워드
,	@StrLocal		char(2)		--지역코드
,	@CountChk		char(1)		--카운트 Flag
)
AS

--Code값
	DECLARE @SqlstrCode varchar(500) ; SET @SqlstrCode = ''
	IF @StrCode3 <> ''	SET @SqlstrCode = ' AND ( B.Code2 IN ('+@StrCode2 + ') OR B.Code3 IN ('+@StrCode3 + ')) '
	ELSE IF @StrCode2 <> ''	SET @SqlstrCode = ' AND B.' + @whichCode + ' IN ('+@StrCode2+')'


--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

--만원테마리스트(만원이하만)
	DECLARE @SqlstrAmt varchar(500) ; SET @SqlstrAmt = ''
	IF @StrCode2 = ''		SET @SqlstrAmt = ' AND A.BuyAmt <= 10000 '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode = '1'
		SET @SqlOrderCode = ' ORDER BY BuyAmt Asc, A.AdId DESC '
	ELSE IF @OrderCode = '2'
		SET @SqlOrderCode = ' ORDER BY ViewCnt Desc, A.AdId DESC '
	ELSE
		SET @SqlOrderCode = ' ORDER BY A.AdId DESC '	

--키워드검색
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @StrSearchKeyWord <> ''	SET @SqlKeyWord = ' AND ( C.CodeNm1 LIKE  ''%' + @StrSearchKeyWord+'%''  OR C.CodeNm2 LIKE ''%' + @StrSearchKeyWord+'%'' OR C.CodeNm3 LIKE  ''%' + @StrSearchKeyWord+'%'' OR A.BrandNmDt Like ''%' + @StrSearchKeyWord +'%'' ) ' 

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
	SET @SqlAll = @SqlstrCode + @SqlUseCode + @SqlstrAmt  + @SqlAdultCode + @SqlKeyWord

--유료옵션시 결제완료 여부
	DECLARE @SqlCondition varchar(200) ; SET @SqlCondition = ''
	IF @Option <> ''		
		SET @SqlCondition = ' AND ' + @Option + '=1 AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() AND B.LocalSite=' + @StrLocal
	ELSE
		SET @SqlCondition = ''

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE
--	ELSE
--		SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
--		              	          '(Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ') ' +
--				          ' OR B.ZipMain = ''전국'' ) '
--		SET @SqlLocalGoods = ' AND B.ShowLocalSite=' + @StrLocal + ' '
		SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0 OR B.ShowLocalSite=' + @StrLocal + ')'

--Query		
	DECLARE @strQuery varchar(3000)
	IF @CountChk = '1'
	BEGIN
		SET @strQuery = 	' SELECT  COUNT(A.AdId) Cnt' 
		SET @SqlOrderCode = ''
	END
	ELSE
	BEGIN
		SET @strQuery = 	' SET ROWCOUNT ' + @GetCount + ';' +
				' SELECT  ' + 
				' A.AdId, A.BrandNmDt, A.BuyAmt, A.UseGbn, ' +
				' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, ' +
				' CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 
				' OptType,OptList,OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,' +
				' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub,B.ViewCnt, M.CNT AS AnswerCnt, B.PLineKeyNo '
	END

	SET @strQuery = 	@strQuery +
				' FROM GoodsSubBuy A WITH (NoLock), GoodsMain B WITH (NoLock), CatCode C WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M' + 
				' WHERE A.AdId = B.AdId ' +
--				' AND B.Code1 = ' + @strCode1 +
				' AND B.Code3 = C.Code3 AND B.AdId *=M.AdId ' +
				' AND B.DelFlag = ''0'' ' +
				' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) ' +
				' AND B.StateChk = ''1'' ' + @SqlLocalGoods + @SqlAll + @SqlCondition + @SqlOrderCode + ';' +
				' SET ROWCOUNT 0;' 
			
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcEtcCateList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcEtcCateList]
(
	@GetCount		varchar(10)
,	@Search_ZipMain	varchar(50)
,	@Search_ZipSub		varchar(50)
,	@Search_StrCode1	varchar(10)
,	@Search_StrCode2	varchar(10)
,	@Search_StrCode3	varchar(10)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(100)
,	@StrCode3		varchar(100)
,	@whichCode		varchar(10)
,	@Option			varchar(20)	--옵션종류
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)		--사진물품
,	@UseCode		varchar(30)	--사용구분
,	@AdultCode		char(1)		--성인구분
,	@WishAmtGbn		char(1)
,	@OrderCode		char(1)			
,	@StrSearchKeyWord	varchar(50)	--키워드
,	@StrLocal		char(2)		--지역코드
,	@CountChk		char(1)		--카운트 Flag
)
AS


--Search_ZipCode
	DECLARE @SqlZipCode varchar(100)
	IF @Search_ZipMain=''		SET 	@SqlZipCode= ' '
	ELSE  
		BEGIN
                            IF @Search_ZipSub=''	SET 	@SqlZipCode= ' AND B.ZipMain = '''+@Search_ZipMain+''' '
		ELSE			SET 	@SqlZipCode= ' AND B.ZipMain = '''+@Search_ZipMain+''' AND B.ZipSub= '''+@Search_ZipSub+''' '
		END
		
--Search_Code1값
	DECLARE @SqlstrCode1 varchar(100)
	IF @Search_StrCode1=''		SET 	@SqlstrCode1= ''
	ELSE  				SET 	@SqlstrCode1= ' AND B.code1='+@Search_StrCode1 +''

--Search_Code2값
	DECLARE @SqlstrCode2 varchar(100)
	IF @Search_StrCode2=''		SET 	@SqlstrCode2= ''
	ELSE  				SET 	@SqlstrCode2= ' AND B.code2='+@Search_StrCode2 +''

--Search_Code3값
	DECLARE @SqlstrCode3 varchar(100)
	IF @Search_StrCode3=''		SET 	@SqlstrCode3= ''
	ELSE  				SET 	@SqlstrCode3= ' AND B.code3='+@Search_StrCode3 +''

--Code값
	DECLARE @SqlstrCode varchar(500) ; SET @SqlstrCode = ''
	IF @StrCode3 <> ''	SET @SqlstrCode = ' AND ( B.Code2 IN ('+@StrCode2 + ') OR B.Code3 IN ('+@StrCode3 + ')) '
	ELSE IF @StrCode2 <> ''	SET @SqlstrCode = ' AND B.' + @whichCode + ' IN ('+@StrCode2+') '

--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '

--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

--추석리스트(신품, 신고품만)
	DECLARE @SqlstrUseGbn varchar(500) ; SET @SqlstrUseGbn = ''
	IF @StrCode1 = '12'	SET @SqlstrUseGbn = ' AND A.UseGbn <> 0 '

--만원테마리스트(만원이하만)
	DECLARE @SqlstrAmt varchar(500) ; SET @SqlstrAmt = ''
	IF @StrCode2 = ''		SET @SqlstrAmt = ' AND A.WishAmt <= 10000 '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

--WishAmtGbn
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''	
	IF @WishAmtGbn = '0' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 '
	Else IF  @WishAmtGbn = '1' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn = '2' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '
	Else IF  @WishAmtGbn = '3' --무료,교환,가격협의 뺀 리스트 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt > 0  '
	Else IF  @WishAmtGbn = '4' --안전거래만
		BEGIN
			SET @SqlWishAmtGbn = ' AND A.WishAmt > 0  '
			SET @SqlstrAmt = ''
		END

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode = '1'
		SET @SqlOrderCode = ' ORDER BY WishAmt Asc, A.AdId DESC '
	ELSE IF @OrderCode = '2'
		SET @SqlOrderCode = ' ORDER BY ViewCnt Desc, A.AdId DESC '
	ELSE
		SET @SqlOrderCode = ' ORDER BY B.RegDate DESC '	
	
--키워드검색
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @StrSearchKeyWord <> ''	     SET @SqlKeyWord = ' AND ( C.CodeNm1 LIKE  ''%' + @StrSearchKeyWord+'%''  OR C.CodeNm2 LIKE ''%' + @StrSearchKeyWord+'%'' OR C.CodeNm3 LIKE  ''%' + @StrSearchKeyWord+'%'' OR A.BrandNmDt Like ''%' + @StrSearchKeyWord +'%'' ) ' 

--전체검색쿼리묶음
	DECLARE @SqlAll	varchar(1000)
	SET @SqlAll = @SqlstrCode  + @SqlEscrowYNCode + @SqlPicCode + @SqlUseCode + @SqlstrAmt  + @SqlAdultCode + @SqlKeyWord + @SqlstrUseGbn + @SqlWishAmtGbn + @SqlZipCode + @SqlstrCode1 + @SqlstrCode2 + @SqlstrCode3

--유료옵션시 결제완료 여부
	DECLARE @SqlCondition varchar(200) ; SET @SqlCondition = ''
	IF @Option <> ''		
		SET @SqlCondition = ' AND ' + @Option + '=1  AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() AND B.LocalSite=' + @StrLocal
	ELSE
		SET @SqlCondition = ''


--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE

--	ELSE
--		SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
--				          '(Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ') ' +
--				          ' OR B.ZipMain = ''전국'' ) '
--		SET @SqlLocalGoods = ' AND B.ShowLocalSite=' + @StrLocal + ' '

		SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0 OR B.ShowLocalSite=' + @StrLocal + ')'

--Query	
	DECLARE @strQuery varchar(3000)
	IF @CountChk = '1'
	BEGIN
		SET @strQuery = 	' SELECT  COUNT(A.AdId) Cnt' 
		SET @SqlOrderCode = ''
	END
	ELSE
	BEGIN
		SET @strQuery = 	' SET ROWCOUNT ' + @GetCount + ';' +
				' SELECT  ' + 
				' A.AdId, A.BrandNmDt, A.BrandNm, A.WishAmt, A.UseGbn, ' +
				' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, ' +
				' CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 
				' OptType,OptList,OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,' +
				' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub, ' +
				' A.CardYN, A.PicIdx1, A.PicIdx2, B.ViewCnt, B.WooriID, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, B.EscrowYN, P.PicImage, B.LocalSite, B.PLineKeyNo, S.UserId AS MiniShop, B.RegDate, S.CUID ' 
	END

	SET @strQuery = 	@strQuery +
				' FROM GoodsSubSale A WITH (NoLock), GoodsMain B WITH (NoLock), CatCode C WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock) ' + 
				'            , (Select UserId,CUID From SellerMiniShop WITH (NoLock) WHERE Delflag=''0'') S ' + 
				' WHERE A.AdId = B.AdId ' +
--				' AND B.Code1 = ' + @strCode1 +
				' AND B.Code3 = C.Code3 AND B.AdId *=M.AdId AND B.AdId *= P.AdId AND B.UserId*=S.UserId  AND B.CUID *=S.CUID ' +
				' AND B.DelFlag = ''0'' ' +
				' AND B.SaleOkFlag<>''1'' ' +
				' AND B.RegAmtOk = ''1'' ' +
				' AND P.PicIdx = 6 ' +	
				' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) ' +		
				' AND B.StateChk = ''1'' ' + @SqlLocalGoods + @SqlAll + @SqlCondition + @SqlOrderCode + ';' +
				' SET ROWCOUNT 0;' 
			
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcExpertCateCount]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcExpertCateCount]
(
	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option  		char(1)
,	@EsCode		char(1)
,	@PicCode		char(1)
,	@ZipCode		varchar(50)
,	@UseCode		varchar(30)
,	@StrSearchText		varchar(30)	-- 키워드 검색조건
,	@StrSearchKeyWord	varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
)
AS
--Code2값
	DECLARE @SqlstrCode2 varchar(100) ; SET @SqlstrCode2 = ''
	IF @StrCode2 <> ''	SET @SqlstrCode2 = ' AND B.code2='+@StrCode2
--Code3값
	DECLARE @SqlstrCode3 varchar(100) ; SET @SqlstrCode3 = ''
	IF @StrCode3 <> '' 	SET @SqlstrCode3 = ' AND B.code3='+@StrCode3
--EsCode안전거래
	DECLARE @SqlEsCode varchar(100) ; SET @SqlEsCode = ''
	IF @EsCode = '1'  	SET @SqlEsCode = ' AND B.EscrowYN = ''Y'' '
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1' 	SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
--ZipCode
	DECLARE @SqlZipCode varchar(100) ; SET @SqlZipCode = ''
	IF @ZipCode <> ''
		IF @StrLocal = '0'	SET @SqlZipCode = ' AND (B.ZipMain = '''+@ZipCode+'''  ) '
		ELSE     		SET @SqlZipCode = ' AND (B.ZipSub = '''+@ZipCode+'''  ) '
--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '
--키워드검색
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @strSearchText <> ''	SET @SqlKeyWord = 'AND ( C.codeNm1 LIKE  ''%' + @strSearchText+'%''  OR C.codeNm2 LIKE ''%' + @strSearchText+'%'' OR C.CodeNm3 LIKE  ''%' + @strSearchText+'%'' OR  A.BrandNmDt Like ''%' + @strSearchText +'%'' ) ' 
--전체검색쿼리를 묶어서
	DECLARE @SqlAll varchar(500) ; SET @SqlAll = ''
	SET @SqlAll = @SqlstrCode2 + @SqlstrCode3 + @SqlEsCode + @SqlPicCode + @SqlZipCode + @SqlUseCode + @SqlKeyWord
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') OR ' +
							' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
						' ) '
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
		END
	DECLARE @strQuery varchar(2000)
	SET @strQuery = 
		CASE
		WHEN @Option ='0' THEN
			' SELECT COUNT(A.Adid) ' + 
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') AND ' + @SqlLocalGoods + @SqlAll
--			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' ) '
		ELSE
			' SELECT COUNT(A.AdId) ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' + ' AND ' + @SqlLocalGoods + @SqlAll +
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() '
		END
                    
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcExpertCateCount2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcExpertCateCount2]
(
	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option  		char(1)
,	@EsCode		char(1)
,	@PicCode		char(1)
,	@ZipCode		varchar(50)
,	@UseCode		varchar(30)
,	@StrSearchText		varchar(30)	-- 키워드 검색조건
,	@StrSearchKeyWord	varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
)
AS
--Code2값
	DECLARE @SqlstrCode2 varchar(100) ; SET @SqlstrCode2 = ''
	IF @StrCode2 <> ''	SET @SqlstrCode2 = ' AND B.code2='+@StrCode2
--Code3값
	DECLARE @SqlstrCode3 varchar(100) ; SET @SqlstrCode3 = ''
	IF @StrCode3 <> '' 	SET @SqlstrCode3 = ' AND B.code3='+@StrCode3
--EsCode안전거래
	DECLARE @SqlEsCode varchar(100) ; SET @SqlEsCode = ''
	IF @EsCode = '1'  	SET @SqlEsCode = ' AND B.EscrowYN = ''Y'' '
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1' 	SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
--ZipCode
	DECLARE @SqlZipCode varchar(100) ; SET @SqlZipCode = ''
	IF @ZipCode <> ''
		IF @StrLocal = '0'	SET @SqlZipCode = ' AND (B.ZipMain = '''+@ZipCode+'''  ) '
		ELSE     		SET @SqlZipCode = ' AND (B.ZipSub = '''+@ZipCode+'''  ) '
--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '
--키워드검색
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @strSearchText <> ''	SET @SqlKeyWord = 'AND ( C.codeNm1 LIKE  ''%' + @strSearchText+'%''  OR C.codeNm2 LIKE ''%' + @strSearchText+'%'' OR C.CodeNm3 LIKE  ''%' + @strSearchText+'%'' OR  A.BrandNmDt Like ''%' + @strSearchText +'%'' ) ' 
--전체검색쿼리를 묶어서
	DECLARE @SqlAll varchar(500) ; SET @SqlAll = ''
	SET @SqlAll = @SqlstrCode2 + @SqlstrCode3 + @SqlEsCode + @SqlPicCode + @SqlZipCode + @SqlUseCode + @SqlKeyWord
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
			SET @SqlLocalNew = ' ( B.OptType IN (''1'',''2'') AND ( ' +
										' ( ' + @SqlLocalGoods + ' AND ( B.PrnAmtOk <> ''1''  OR B.PrnEnDate < GETDATE() ) ) OR ' +
										' ( NOT ' + @SqlLocalGoods + ' ) ' +
									'    ) ' +
					          ' ) '
			SET @SqlCondition = ' AND ( ' +
							@SqlLocalGoods + ' OR ' +
							' ( ( NOT ' + @SqlLocalGoods + ' ) AND ( B.OptType IN (''1'', ''2'') OR B.OptKind <> '''' )  ) ' +
						'     ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') ' +
						' ) '
			SET @SqlLocalSite = ' , FindDB2.FindCommon.dbo.LocalSite L '
			SET @SqlLocalNew = ' ( B.OptType IN (''1'',''2'') AND ( ' +
										' ( ' + @SqlLocalGoods + ' AND ( B.PrnAmtOk <> ''1''  OR B.PrnEnDate < GETDATE() ) ) OR ' +
										' ( NOT ' + @SqlLocalGoods + ' ) ' +
									'    ) ' +
					          ' ) '
			SET @SqlCondition = ' AND  ( ' +
							'  ( L.LocalSite=' + @StrLocal + ' AND ( L.LocalBranch=B.LocalBranch OR L.LocalBranch=LEFT(B.OptLocalBranch,2) ) ) OR ' +
							'  ( B.LocalBranch=L.LocalBranch AND B.OptLocalBranch=''80'' AND B.ZipMain=''전국'' ) ' +
						'      ) ' 
		END
	DECLARE @strQuery varchar(2000)
	SET @strQuery = 
		CASE
		WHEN @Option ='0' THEN
			' SELECT COUNT(A.Adid) ' + 
			' FROM GoodsSubSale A , GoodsMain B , CatCode C ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' + @SqlCondition + @SqlAll +
			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' ) '
		ELSE
			' SELECT COUNT(A.AdId) ' +
			' FROM GoodsSubSale A , GoodsMain B , CatCode C ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' + ' AND ' + @SqlLocalGoods + @SqlAll +
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() '
		END
                    
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcExpertCateList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcExpertCateList]
(
	@GetCount		varchar(10)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option  		char(1)
,	@EsCode		char(1)
,	@PicCode		char(1)
,	@ZipCode		varchar(50)
,	@UseCode		varchar(30)
,	@OrderCode		char(1)
,	@StrSearchText		varchar(30)	-- 키워드 검색조건
,	@StrSearchKeyWord	varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
)
AS
--Code2값
	DECLARE @SqlstrCode2 varchar(100) ; SET @SqlstrCode2 = ''
	IF @StrCode2 <> ''	SET @SqlstrCode2 = ' AND B.code2='+@StrCode2
--Code3값
	DECLARE @SqlstrCode3 varchar(100) ; SET @SqlstrCode3 = ''
	IF @StrCode3 <> '' 	SET @SqlstrCode3 = ' AND B.code3='+@StrCode3
--EsCode안전거래
	DECLARE @SqlEsCode varchar(100) ; SET @SqlEsCode = ''
	IF @EsCode = '1'  	SET @SqlEsCode = ' AND B.EscrowYN = ''Y'' '
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1' 	SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
--ZipCode
	DECLARE @SqlZipCode varchar(100) ; SET @SqlZipCode = ''
	IF @ZipCode <> ''
		IF @StrLocal = '0'	SET @SqlZipCode = ' AND (B.ZipMain = '''+@ZipCode+'''  ) '
		ELSE     		SET @SqlZipCode = ' AND (B.ZipSub = '''+@ZipCode+'''  ) '
--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '
--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode ='1'		SET @SqlOrderCode = ' ORDER BY B.OptType, A.WishAmt '
	ELSE IF @OrderCode ='2'   	SET @SqlOrderCode = ' ORDER BY B.OptType, A.WishAmt DESC '
	ELSE				SET @SqlOrderCode = ' ORDER BY B.OptType, A.AdId DESC '
--키워드검색
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @strSearchText <> ''	SET @SqlKeyWord = 'AND ( C.codeNm1 LIKE  ''%' + @strSearchText+'%''  OR C.codeNm2 LIKE ''%' + @strSearchText+'%'' OR C.CodeNm3 LIKE  ''%' + @strSearchText+'%'' OR  A.BrandNmDt Like ''%' + @strSearchText +'%'' ) ' 
--전체검색쿼리를 묶어서
	DECLARE @SqlAll varchar(500) ; SET @SqlAll = ''
	SET @SqlAll = @SqlstrCode2 + @SqlstrCode3 + @SqlEsCode + @SqlPicCode + @SqlZipCode + @SqlUseCode + @SqlKeyWord
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') OR ' +
							' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
						' ) '
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
		END
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
		CASE
		WHEN @Option = '0' THEN
			' SELECT TOP '+ @GetCount + ' A.AdId , A.BrandNmDt , A.WishAmt , A.UseGbn , ' +
			' B.UserID , CONVERT(CHAR(10),B.RegDate,120) AS RegDate , ' +
			' CASE WHEN (B.PrnEnDate >= GETDATE()  AND B.PrnAmtOk = ''1'' ) THEN B.OptKind ELSE '''' END AS OptKind , ' +
			' B.OptType , B.OptColor , B.OptLocalBranch , B.LocalBranch , B.ZipMain , B.ZipSub ,A.BuyAmt , ' +
			' A.CardYN , B.EscrowYN , A.PicIdx1 , A.PicIdx2 , B.CUID ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') AND ' + @SqlLocalGoods + @SqlAll + @SqlOrderCode
--			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' ) ' + @SqlOrderCode
		ELSE
			' SELECT A.AdId , A.BrandNmDt , A.WishAmt , A.UseGbn , ' +
			' B.UserID , CONVERT(CHAR(10),B.RegDate,120) AS RegDate , ' +
			' B.OptType , B.OptKind , B.OptColor , B.OptLocalBranch , B.LocalBranch , B.ZipMain , B.ZipSub , A.BuyAmt , ' +
			' A.CardYN , B.EscrowYN , A.PicIdx1 , A.PicIdx2, B.CUID  ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' + ' AND ' + @SqlLocalGoods + @SqlAll +
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() ' + @SqlOrderCode
		END
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcExpertCateList2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcExpertCateList2]
(
	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option  		char(1)
,	@EsCode		char(1)
,	@PicCode		char(1)
,	@ZipCode		varchar(50)
,	@UseCode		varchar(30)
,	@OrderCode		char(1)
,	@StrSearchText		varchar(30)	-- 키워드 검색조건
,	@StrSearchKeyWord	varchar(50)	-- 키워드
,	@StrLocal		char(2)		-- 지역코드
)
AS
--Code2값
	DECLARE @SqlstrCode2 varchar(100) ; SET @SqlstrCode2 = ''
	IF @StrCode2 <> ''	SET @SqlstrCode2 = ' AND B.code2='+@StrCode2
--Code3값
	DECLARE @SqlstrCode3 varchar(100) ; SET @SqlstrCode3 = ''
	IF @StrCode3 <> '' 	SET @SqlstrCode3 = ' AND B.code3='+@StrCode3
--EsCode안전거래
	DECLARE @SqlEsCode varchar(100) ; SET @SqlEsCode = ''
	IF @EsCode = '1'  	SET @SqlEsCode = ' AND B.EscrowYN = ''Y'' '
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1' 	SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
--ZipCode
	DECLARE @SqlZipCode varchar(100) ; SET @SqlZipCode = ''
	IF @ZipCode <> ''
		IF @StrLocal = '0'	SET @SqlZipCode = ' AND (B.ZipMain = '''+@ZipCode+'''  ) '
		ELSE     		SET @SqlZipCode = ' AND (B.ZipSub = '''+@ZipCode+'''  ) '
--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '
--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode ='1'		SET @SqlOrderCode = ' ORDER BY A.WishAmt '
	ELSE IF @OrderCode ='2'   	SET @SqlOrderCode = ' ORDER BY A.WishAmt DESC '
	ELSE				SET @SqlOrderCode = ' ORDER BY A.AdId DESC '
--키워드검색
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @strSearchText <> ''	SET @SqlKeyWord = 'AND ( C.codeNm1 LIKE  ''%' + @strSearchText+'%''  OR C.codeNm2 LIKE ''%' + @strSearchText+'%'' OR C.CodeNm3 LIKE  ''%' + @strSearchText+'%'' OR  A.BrandNmDt Like ''%' + @strSearchText +'%'' ) ' 
--전체검색쿼리를 묶어서
	DECLARE @SqlAll varchar(500) ; SET @SqlAll = ''
	SET @SqlAll = @SqlstrCode2 + @SqlstrCode3 + @SqlEsCode + @SqlPicCode + @SqlZipCode + @SqlUseCode + @SqlKeyWord
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
			SET @SqlLocalNew = ' ( B.OptType IN (''1'',''2'') AND ( ' +
										' ( ' + @SqlLocalGoods + ' AND ( B.PrnAmtOk <> ''1''  OR B.PrnEnDate < GETDATE() ) ) OR ' +
										' ( NOT ' + @SqlLocalGoods + ' ) ' +
									'    ) ' +
					          ' ) '
			SET @SqlCondition = ' AND ( ' +
							@SqlLocalGoods + ' OR ' +
							' ( ( NOT ' + @SqlLocalGoods + ' ) AND ( B.OptType IN (''1'', ''2'') OR B.OptKind <> '''' )  ) ' +
						'     ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') ' +
						' ) '
			SET @SqlLocalSite = ' , FindDB2.FindCommon.dbo.LocalSite L '
			SET @SqlLocalNew = ' ( B.OptType IN (''1'',''2'') AND ( ' +
										' ( ' + @SqlLocalGoods + ' AND ( B.PrnAmtOk <> ''1''  OR B.PrnEnDate < GETDATE() ) ) OR ' +
										' ( NOT ' + @SqlLocalGoods + ' ) ' +
									'    ) ' +
					          ' ) '
			SET @SqlCondition = ' AND  ( ' +
							'  ( L.LocalSite=' + @StrLocal + ' AND ( L.LocalBranch=B.LocalBranch OR L.LocalBranch=LEFT(B.OptLocalBranch,2) ) ) OR ' +
							'  ( B.LocalBranch=L.LocalBranch AND B.OptLocalBranch=''80'' AND B.ZipMain=''전국'' ) ' +
						'      ) ' 
		END
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
		CASE
		WHEN @Option = '0' THEN
			' SELECT A.AdId , A.BrandNmDt , A.WishAmt , A.UseGbn , ' +
			' B.UserID , CONVERT(CHAR(10),B.RegDate,120) AS RegDate , ' +
			' CASE WHEN (B.PrnEnDate >= GETDATE()  AND B.PrnAmtOk = ''1'' ) THEN B.OptKind ELSE '''' END AS OptKind , ' +
			' B.OptType , B.OptColor , B.OptLocalBranch , B.LocalBranch , B.ZipMain , B.ZipSub ,A.BuyAmt , ' +
			' A.CardYN , B.EscrowYN , A.PicIdx1 , A.PicIdx2, B.CUID  ' +
			' FROM GoodsSubSale A , GoodsMain B , CatCode C ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' + @SqlCondition + @SqlAll +
			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' ) ' + @SqlOrderCode
		ELSE
			' SELECT A.AdId , A.BrandNmDt , A.WishAmt , A.UseGbn , ' +
			' B.UserID , CONVERT(CHAR(10),B.RegDate,120) AS RegDate , ' +
			' B.OptType , B.OptKind , B.OptColor , B.OptLocalBranch , B.LocalBranch , B.ZipMain , B.ZipSub , A.BuyAmt , ' +
			' A.CardYN , B.EscrowYN , A.PicIdx1 , A.PicIdx2, B.CUID  ' +
			' FROM GoodsSubSale A , GoodsMain B , CatCode C ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.Code3 = C.Code3 ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' + ' AND ' + @SqlLocalGoods + @SqlAll +
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() ' + @SqlOrderCode
		END
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcExpertOtherProdList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcExpertOtherProdList]
(
	@Option  		char(1)
,	@UserID 		varchar(50)			
,	@StrLocal		char(2)		-- 지역코드
)
AS
SET @UserID = '''' + @UserID + ''''
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') OR ' +
							' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
						' ) '
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
		END
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
		CASE
		WHEN @Option = '0' THEN
			' SELECT A.AdId , A.BrandNmDt , A.WishAmt , A.UseGbn , ' +
			' B.UserID , CONVERT(CHAR(10),B.RegDate,120) AS RegDate , ' +
			' CASE WHEN (B.PrnEnDate >= GETDATE()  AND B.PrnAmtOk = ''1'' ) THEN B.OptKind ELSE '''' END AS OptKind , ' +
			' B.OptType , B.OptColor , B.OptLocalBranch , B.LocalBranch , B.ZipMain , B.ZipSub , A.BuyAmt , ' +
			' A.CardYN , B.EscrowYN , A.PicIdx1 , A.PicIdx2, B.CUID ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) ,  GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code3 = C.Code3 ' +
			' AND B.UserID=' + @UserID+
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') AND ' + @SqlLocalGoods +
--			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' ) ' +
			' ORDER BY B.OptType, A.Adid DESC'
		ELSE
			' SELECT A.AdId , A.BrandNmDt , A.WishAmt , A.UseGbn , ' +
			' B.UserID , CONVERT(CHAR(10),B.RegDate,120) AS RegDate , ' +
			' B.OptType , B.OptKind , B.OptColor , B.OptLocalBranch , B.LocalBranch , B.ZipMain , B.ZipSub , A.BuyAmt , ' +
			' A.CardYN CardYN,B.EscrowYN EscrowYN, A.PicIdx1 PicIdx1, A.PicIdx2	PicIdx2, B.CUID ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code3 = C.Code3 ' +
			' AND B.UserID=' + @UserID+
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' + ' AND ' + @SqlLocalGoods +
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() ' +
			' ORDER BY A.Adid DESC'
		END
--			' AND B.SpecFlag = "1" '+
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcExpertPowerResult]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcExpertPowerResult]
(
	@Option  		char(1)
,	@StrSearchText		varchar(30)	-- 키워드 검색조건
,	@StrLocal		char(2)		-- 지역코드
)
AS
--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	SET @SqlOrderCode = ' A.AdId DESC '
--키워드검색
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @strSearchText <> ''	SET @SqlKeyWord = ' AND B.MergeText LIKE ''%' + @strSearchText + '%'' '
--전체검색쿼리를 묶어서
	DECLARE @SqlAll varchar(500) ; SET @SqlAll = ''
--	SET @SqlAll = @SqlstrCode2 + @SqlstrCode3 + @SqlWishAmt + @SqlPicCode + @SqlZipCode + @SqlUseCode + @SqlKeyWord + @SqlUserId
	SET @SqlAll = @SqlKeyWord
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') OR ' +
							' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
						' ) '
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
		END
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
		CASE
		WHEN @Option = '0' THEN
			' SELECT A.AdId , A.BrandNmDt , A.WishAmt , A.UseGbn , ' +
			' B.UserID , CONVERT(CHAR(10),B.RegDate,120) AS RegDate , ' +
			' CASE WHEN (B.PrnEnDate >= GETDATE()  AND B.PrnAmtOk = ''1'' ) THEN B.OptKind ELSE '''' END AS OptKind , ' +
			' B.OptType , B.OptColor , B.OptLocalBranch , B.LocalBranch , B.ZipMain , B.ZipSub , A.BuyAmt , ' +
			' A.CardYN , B.EscrowYN , A.PicIdx1 , A.PicIdx2, B.CUID ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) ,  GoodsMain B WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') AND ' + @SqlLocalGoods + @SqlAll + ' ORDER BY B.OptType, ' + @SqlOrderCode
--			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' ) ' + @SqlOrderCode
		ELSE
			' SELECT A.AdId , A.BrandNmDt , A.WishAmt , A.UseGbn , ' +
			' B.UserID , CONVERT(CHAR(10),B.RegDate,120) AS RegDate , ' +
			' B.OptType , B.OptKind , B.OptColor ,  B.OptLocalBranch , B.LocalBranch , B.ZipMain , B.ZipSub , A.BuyAmt , ' +
			' A.CardYN , B.EscrowYN , A.PicIdx1 , A.PicIdx2 , B.CUID ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' + ' AND ' + @SqlLocalGoods + @SqlAll +
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() ORDER BY ' + @SqlOrderCode
		END
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcExpertSearchResult]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcExpertSearchResult]
(
	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@Option  		char(1)
,	@PicCode		char(1)
,	@WishAmt		varchar(10)
,	@ZipMain		varchar(20)
,	@ZipSub		varchar(20)
,	@UseCode		varchar(20)
,	@OrderCode		char(1)
,	@StrSearchText		varchar(30)	-- 키워드 검색조건
,	@UserID 		varchar(50)			
,	@StrLocal		char(2)		-- 지역코드
)
AS
--Code2값
	DECLARE @SqlstrCode2 varchar(100) ; SET @SqlstrCode2 = ''
	IF @StrCode2 <> ''	SET @SqlstrCode2 = ' AND B.code2='+@StrCode2
--Code3값
	DECLARE @SqlstrCode3 varchar(100) ; SET @SqlstrCode3 = ''
	IF @StrCode3 <> '' 	SET @SqlstrCode3 = ' AND B.code3='+@StrCode3
--WishAmt판매값
	DECLARE @SqlWishAmt varchar(100) ; SET @SqlWishAmt = ''
	IF @WishAmt <> '-1' AND @WishAmt <> '1000000'	SET @SqlWishAmt = ' AND A.WishAmt <= ' + @WishAmt + ' '
	ELSE IF @WishAmt = '10000000'                      	SET @SqlWishAmt = ' AND A.WishAmt >= ' + @WishAmt + ' '
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1' 	SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
--ZipCode
	DECLARE @SqlZipCode varchar(100) ; SET @SqlZipCode = ''
	IF @StrLocal = '0' AND @ZipSub <> ''	SET @SqlZipCode = ' AND A.SendAreaSub = ''' + @ZipSub + ''' '
	ELSE IF @ZipSub <> ''			SET @SqlZipCode = ' AND A.SendAreaMain = ''' + @ZipMain + ''' AND A.SendAreaSub = ''' + @ZipSub + ''' '
	ELSE IF @ZipMain <> ''			SET @SqlZipCode = ' AND A.SendAreaMain = ''' + @ZipMain + ''' '
--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> '모두' AND @UseCode <> ''   	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode + ''' ) '
--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode ='1'		SET @SqlOrderCode = ' A.WishAmt '
	ELSE IF @OrderCode ='2'   	SET @SqlOrderCode = ' A.WishAmt DESC '
	ELSE				SET @SqlOrderCode = ' A.AdId DESC '
--키워드검색
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @strSearchText <> ''	SET @SqlKeyWord = ' AND A.BrandNmDt LIKE ''%' + @strSearchText + '%'' '
--UserId검색
	DECLARE @SqlUserId varchar(500) ; SET @SqlUserId = ''
	IF @UserID <> ''		SET @SqlUserId = ' AND B.UserId LIKE ''%' + @UserID + '%'' '
--전체검색쿼리를 묶어서
	DECLARE @SqlAll varchar(500) ; SET @SqlAll = ''
	SET @SqlAll = @SqlstrCode2 + @SqlstrCode3 + @SqlWishAmt + @SqlPicCode + @SqlZipCode + @SqlUseCode + @SqlKeyWord + @SqlUserId
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') OR ' +
							' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
						' ) '
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
		END
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
		CASE
		WHEN @Option = '0' THEN
			' SELECT A.AdId , A.BrandNmDt , A.WishAmt , A.UseGbn , ' +
			' B.UserID , CONVERT(CHAR(10),B.RegDate,120) AS RegDate , ' +
			' CASE WHEN (B.PrnEnDate >= GETDATE()  AND B.PrnAmtOk = ''1'' ) THEN B.OptKind ELSE '''' END AS OptKind , ' +
			' B.OptType , B.OptColor , B.OptLocalBranch , B.LocalBranch , B.ZipMain , B.ZipSub , A.BuyAmt , ' +
			' A.CardYN , B.EscrowYN , A.PicIdx1 , A.PicIdx2 , B.CUID ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +'' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') AND ' + @SqlLocalGoods + @SqlAll + ' ORDER BY B.OptType, ' + @SqlOrderCode
--			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' ) ' + @SqlOrderCode
		ELSE
			' SELECT A.AdId , A.BrandNmDt , A.WishAmt , A.UseGbn , ' +
			' B.UserID , CONVERT(CHAR(10),B.RegDate,120) AS RegDate , ' +
			' B.OptType , B.OptKind , B.OptColor ,  B.OptLocalBranch , B.LocalBranch , B.ZipMain , B.ZipSub , A.BuyAmt , ' +
			' A.CardYN , B.EscrowYN , A.PicIdx1 , A.PicIdx2 , B.CUID ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.Code1 = ' + @strCode1 +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SpecFlag = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' + ' AND ' + @SqlLocalGoods + @SqlAll +
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() ORDER BY ' + @SqlOrderCode
		END
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcKiccAbNormal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 신용카드관리-비정상내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-15
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcKiccAbNormal]
(
	@Page			int
,	@PageSize		int
, @strDivInfo		varchar(10)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--3. 자료구분(삽니다/팝니다)
	DECLARE @SqlDivInfo varchar(200)
	IF @strDivInfo = 'SELL'		
		BEGIN			
			SET 	@SqlDivInfo= ' And G.AdGbn = 0 '
		END
	ELSE
		BEGIN
			SET 	@SqlDivInfo= ' And G.AdGbn = 1 '
		END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(4000)
	BEGIN
		SET @strQuery =
		/*
			'SELECT  COUNT(Distinct G.GrpSerial) FROM GoodsMain G, KiccTrans K ' +
			'  WHERE Convert(int,K.Sequence_no) =* G.GrpSerial  And G.ChargeKind=''2'' And K.Result <> ''0000'' And G.PrnAmtOk=''0''   ' + @SqlAll + ';  ' +
			' SELECT Sum(G.PrnAmt) As TotalSum From GoodsMain G, KiccTrans K ' +
			'Where Convert(int,K.Sequence_no) =*G.GrpSerial And G.ChargeKind=''2'' And K.Result <> ''0000''  And G.PrnAmtOk=''0'' ' + @SqlAll + ';  ' +
			'SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  K.Sequence_no, Convert(varchar(10),G.RegDate,111) as RegDate, Count(G.Adid) As AdCount, Sum(G.PrnAmt) As TotPrnAmt, G.UserName, G.ChargeKind, G.PrnAmtOk  ' +
			'  FROM  KiccTrans K, GoodsMain G ' +
			'  WHERE Convert(int,K.Sequence_no) =* G.GrpSerial  And G.ChargeKind=''2'' And K.Result <> ''0000'' And G.PrnAmtOk=''0''   ' + @SqlAll + ' ' +
			'  Group By K.Sequence_no, Convert(varchar(10),G.RegDate,111), G.UserName, G.ChargeKind, G.PrnAmtOk  '
		*/

		--자료 갯수
		'Select Count(distinct C.GrpSerial) ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId inner join KiccTrans K ' +
		'	on C.KiccTransNo = K.sequence_no ' +
		'Where C.ChargeKind=''2'' And Isnull(K.Result,'''')<>''0000'' And C.RecStatus<>''1'' ' + @SqlAll +
		
		--결제 총 금액
		'Select sum(C.PrnAmt) ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId inner join KiccTrans K ' +
		'	on C.KiccTransNo = K.sequence_no ' +
		'Where C.ChargeKind=''2'' And Isnull(K.Result,'''')<>''0000'' And C.RecStatus<>''1'' ' + @SqlAll +
		' ; ' +
		--실제자료들
		'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
		' K.Sequence_no, Convert(varchar(10),K.Approval_time,120) as Approval_time,  K.Approval_no, Count(G.Adid) As AdCount,Sum(C.PrnAmt) As TotPrnAmt, ' +
		' G.UserName,C.RecStatus,Convert(varchar(10),G.RegDate,112) RegDate, C.GrpSerial ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId inner join KiccTrans K ' +
		'	on C.KiccTransNo = K.sequence_no ' +
		'Where C.ChargeKind=''2'' And Isnull(K.Result,'''')<>''0000'' And C.RecStatus<>''1'' ' + @SqlAll +
		'Group By K.Sequence_no, Convert(varchar(10),K.Approval_time,120), K.Approval_no,G.UserName, C.RecStatus,Convert(varchar(10),G.RegDate,112), C.GrpSerial  ' + 
		'Order By K.Sequence_no DESC' 

	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcKiccDel]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 신용카드관리-게재후 삭제내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-15
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcKiccDel]
(
	@Page			int
,	@PageSize		int
, @strDivInfo		varchar(10)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--3. 자료구분(삽니다/팝니다)
	DECLARE @SqlDivInfo varchar(200)
	IF @strDivInfo = 'SELL'		
		BEGIN			
			SET 	@SqlDivInfo= ' And G.AdGbn = 0 '
		END
	ELSE
		BEGIN
			SET 	@SqlDivInfo= ' And G.AdGbn = 1 '
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(3000)
	BEGIN
		SET @strQuery =
			
			--자료 갯수
			'Select Count(distinct C.GrpSerial) ' +
			'From GoodsMain G with (Nolock) inner join  ' +
			'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
			'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
			'	on G.AdId = C.AdId inner join KiccTrans K ' +
			'	on C.KiccTransNo = K.sequence_no ' +
			'Where C.ChargeKind=''2'' And IsNull(G.DelFlag,''0'') = ''1'' And C.RecStatus = ''1'' ' + @SqlAll +
			
			--실제자료들
			'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
			'  K.Sequence_no, Convert(varchar(10),K.Approval_time,120) As Approval_time, Convert(varchar(10),G.DelDate,120) As DelDate, Convert(varchar(10),G.PrnStDate,120) As PrnStDate, Count(G.Adid) As AdCount, Sum(C.PrnAmt) As TotPrnAmt, G.UserName,Convert(varchar(10),G.RegDate,112) RegDate, C.GrpSerial  ' +
			'From GoodsMain G with (Nolock) inner join  ' +
			'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
			'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
			'	on G.AdId = C.AdId inner join KiccTrans K ' +
			'	on C.KiccTransNo = K.sequence_no ' +
			'Where C.ChargeKind=''2'' And IsNull(G.DelFlag,''0'') = ''1'' And C.RecStatus = ''1'' ' + @SqlAll +
			'  Group By K.Sequence_no, Convert(varchar(10),K.Approval_time,120), Convert(varchar(10),G.DelDate,120), Convert(varchar(10),G.PrnStDate,120),G.UserName,Convert(varchar(10),G.RegDate,112), C.GrpSerial  Order By K.Sequence_no DESC '
			

	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcKiccNormal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 신용카드관리-정상내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-15
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcKiccNormal]
(
	@Page			int
,	@PageSize		int
, @strDivInfo 	varchar(10)		--삽니다/팝니다
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END

--3. 자료구분(삽니다/팝니다)
	DECLARE @SqlDivInfo varchar(200)
	IF @strDivInfo = 'SELL'		
		BEGIN			
			SET 	@SqlDivInfo= ' And G.AdGbn = 0 '
		END
	ELSE
		BEGIN
			SET 	@SqlDivInfo= ' And G.AdGbn = 1 '
		END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(3000)
	BEGIN
		SET @strQuery =
		/*
			'SELECT  COUNT(Distinct G.GrpSerial) FROM GoodsMain G, KiccTrans K ' +
			'Where Convert(int,K.Sequence_no) =*G.GrpSerial And G.ChargeKind=''2'' And K.Result=''0000'' And G.PrnAmtOk=''1'' ' + @SqlAll + '; ' +
			' SELECT Sum(G.PrnAmt) As TotalSum From GoodsMain G, KiccTrans K ' +
			'Where Convert(int,K.Sequence_no) =*G.GrpSerial And G.ChargeKind=''2'' And K.Result=''0000''  And G.PrnAmtOk=''1'' ' + @SqlAll + ';  ' +
			'SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			' K.Sequence_no, Convert(varchar(10),K.Approval_time,120) as Approval_time,  K.Approval_no, Count(G.Adid) As AdCount,Sum(G.PrnAmt) As TotPrnAmt, ' +
			' G.UserName, G.PrnAmtOk ' +
			' From KiccTrans K, GoodsMain G ' +
			' Where Convert(int,K.Sequence_no) =*G.GrpSerial And G.ChargeKind=''2'' And K.Result=''0000'' And G.PrnAmtOk=''1'' ' + @SqlAll + ' ' +
			' Group By K.Sequence_no, Convert(varchar(10),K.Approval_time,120), K.Approval_no,G.UserName, G.PrnAmtOk  Order By K.Sequence_no DESC' 
	*/
	--자료 갯수
	'Select Count(distinct C.GrpSerial) ' +
	'From GoodsMain G with (Nolock) inner join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join KiccTrans K ' +
	'	on C.KiccTransNo = K.sequence_no ' +
	'Where C.ChargeKind=''2'' And K.Result=''0000'' And C.RecStatus=''1'' ' + @SqlAll +
	
	--결제 총 금액
	'Select sum(C.PrnAmt) ' +
	'From GoodsMain G with (Nolock) inner join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join KiccTrans K ' +
	'	on C.KiccTransNo = K.sequence_no ' +
	'Where C.ChargeKind=''2'' And K.Result=''0000'' And C.RecStatus=''1'' ' + @SqlAll +
	' ; ' +
	--실제자료들
	'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
	' K.Sequence_no, Convert(varchar(10),K.Approval_time,120) as Approval_time,  K.Approval_no, Count(G.Adid) As AdCount,Sum(C.PrnAmt) As TotPrnAmt, ' +
	' G.UserName,C.RecStatus,Convert(varchar(10),G.RegDate,112) RegDate, C.GrpSerial  ' +
	'From GoodsMain G with (Nolock) inner join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join KiccTrans K ' +
	'	on C.KiccTransNo = K.sequence_no ' +
	'Where C.ChargeKind=''2'' And Isnull(K.Result,'''')=''0000'' And C.RecStatus=''1'' ' + @SqlAll +
	'Group By K.Sequence_no, Convert(varchar(10),K.Approval_time,120), K.Approval_no,G.UserName, C.RecStatus,Convert(varchar(10),G.RegDate,112) , C.GrpSerial  ' + 
	'Order By K.Sequence_no DESC' 

	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procLocalChargeEnd]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[procLocalChargeEnd]
(
                @strLocal		varchar(2)	-- 지역코드
,               @strStartDate		varchar(10)	-- 정산월
)
AS

	CREATE TABLE #Temp_LineCount
	(
		ChargeKind  	Char(1)
	,  	Count    	int
	,  	PrnAmt  	int 
	, AdGbn int
	);

	/*2003.05.31 버젼
	INSERT INTO #Temp_LineCount
	SELECT A.chargeKind, COUNT(*), SUM(A.PrnAmt) FROM GoodsMain A, GoodsSubSale B , LocalSite L
	WHERE  A.AdId=B.AdId AND L.LocalSite=@strLocal AND L.LocalBranch = A.LocalBranch
	AND Left(CONVERT(varchar(10), A.RegDate, 120),7)=@strStartDate
	AND A.SettleFlag='Y' AND A.SettleEndFlag='Y' AND A.SettleEndDay<>''
	GROUP BY A.ChargeKind
	UNION
	SELECT 6, COUNT(*), 0  FROM GoodsMain A, GoodsSubBuy B , LocalSite L 
	WHERE  A.AdId=B.AdId AND L.LocalSite=@strLocal AND L.LocalBranch = A.LocalBranch
	AND Left(CONVERT(varchar(10), A.RegDate, 120),7)=@strStartDate
	AND A.SettleFlag='Y' AND A.SettleEndFlag='Y' AND A.SettleEndDay<>''
	*/

	--지역별 정산금액과 갯수 를 임시 테이블에 저장
	INSERT INTO #Temp_LineCount
	SELECT C.chargeKind, COUNT(*), SUM(B.PrnAmt), A.AdGbn
	FROM GoodsMain A, RecChargeDetail B , RecCharge C
	WHERE  A.AdId=B.AdId And C.GrpSerial = B.GrpSerial AND A.LocalSite=@strLocal
	AND Left(CONVERT(varchar(10), A.RegDate, 120),7)=@strStartDate
	AND B.SettleFlag='Y' AND B.SettleEndFlag='Y' AND B.SettleEndDay<>''
	AND A.AdGbn=0
	GROUP BY C.ChargeKind
	UNION
	SELECT C.chargeKind, COUNT(*), SUM(B.PrnAmt), A.AdGbn
	FROM GoodsMain A, RecChargeDetail B , RecCharge C
	WHERE  A.AdId=B.AdId And C.GrpSerial = B.GrpSerial AND A.LocalSite=@strLocal
	AND Left(CONVERT(varchar(10), A.RegDate, 120),7)=@strStartDate
	AND B.SettleFlag='Y' AND B.SettleEndFlag='Y' AND B.SettleEndDay <> ''
	AND A.AdGbn=1
	GROUP BY C.ChargeKind

	CREATE TABLE #Temp_LineCount1
	(	ChargeKind		int
	,	Count1		int   DEFAULT 0
	, AdGbn int
	,	PrnAmt1               int   DEFAULT 0
	 PRIMARY KEY (ChargeKind));

	--판매매물
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (0,0)
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (0,1)
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (0,2)
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (0,3)
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (0,4)
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (0,5)
	--구매매물
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (1,0)
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (1,1)
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (1,2)
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (1,3)
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (1,4)
	INSERT INTO #Temp_LineCount1 (AdGbn,ChargeKind) values (1,5)

	UPDATE A
	SET A.Count1 = B.Count, A.PrnAmt1 = B.PrnAmt
	FROM #Temp_LineCount1 A, #Temp_LineCount B
	WHERE  A.ChargeKind=B.ChargeKind And A.AdGbn = B.AdGbn

	SELECT * FROM #Temp_LineCount1
GO
/****** Object:  StoredProcedure [dbo].[ProcLocalEndCharge]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcLocalEndCharge]
(
 	@StrLocal	char(2)         	--제휴사
,	@StrStartDate	varchar(10)
,	@StrDivInfo	varchar(10)	--자료구분(팝니다/삽니다)
)
AS

	--제휴사 선택
	DECLARE @SqlLocal varchar(200)
	DECLARE @SqlLocalDB varchar(100)
	
	IF @StrLocal =''
		BEGIN			
			SET 	@SqlLocal= ''
			SET 	@SqlLocalDB= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlLocal= ' AND G.LocalSite = ' + CONVERT(varchar(10),@StrLocal)
			SET 	@SqlLocalDB= ' '
		END

	--날짜(월)
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDate = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Left(Convert(varchar(10),G.RegDate,120),7) = ''' +@strStartDate +''''
		END

	--검색 테이블, 자료 구분
	DECLARE @SqlDivInfo varchar(20)
	IF @StrDivInfo ='SELL'
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 0 '
	END
	ELSE
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 1 '
	END

	--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt+@SqlLocal
		END

	DECLARE @strQuery varchar(8000)
	SET @strQuery =
		/*
		'SELECT  ISNull(Sum(G.PartAmount),0) FROM GoodsMain G, GoodsSubSale S ' + @SqlLocalDB + 
		'WHERE G.Adid = S.Adid And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''  And G.PrnAmtOk=''1'' And G.StateChk<>''6''  AND G.IsUnPaid = ''N'' AND G.SettleFlag=''Y'' ' + @SqlAll + ';  ' +
		'SELECT  ISNull(Sum(G.PartAmount),0) FROM GoodsMain G, GoodsSubSale S ' + @SqlLocalDB + 
		'WHERE G.Adid = S.Adid And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''  And G.PrnAmtOk=''1'' And G.StateChk<>''6''  AND G.IsUnPaid = ''N'' AND G.SettleFlag=''N'' ' + @SqlAll + ';  ' +
		'SELECT  ISNull(Sum(G.PrnAmt2),0), ISNull(Sum(G.PartAmount),0) FROM GoodsMain G, GoodsSubSale S ' + @SqlLocalDB + 
		'WHERE G.Adid = S.Adid And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''  And G.PrnAmtOk=''1'' And G.StateChk<>''6'' AND G.IsUnPaid = ''N'' ' + @SqlAll + ';  ' +
		'SELECT  COUNT(Distinct G.Adid) FROM GoodsMain G, GoodsSubSale S ' + @SqlLocalDB + 
		'WHERE G.Adid = S.Adid And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''  And G.PrnAmtOk=''1''  And G.StateChk<>''6''  AND G.IsUnPaid = ''N'' ' + @SqlAll + ';  ' +
		' SELECT Distinct '+
		'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.PrnAmt2,C.CodeNm1,G.UserName, G.RecNm,  ' +
		'  G.OptType,G.OptKind,G.OptLocalBranch,G.ChargeKind, G.PrnAmtOK, G.StateChk,G.LocalBranch,G.PartnerCode,G.PartAmount,G.SettleFlag,Convert(varchar(10),G.SettleDay,120) as SettleDay ' +
		'  FROM GoodsMain G, GoodsSubSale S, CatCode C ' + @SqlLocalDB + 
		'  WHERE G.Adid=S.Adid And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''  And G.PrnAmtOk=''1'' And G.StateChk<>''6''  AND G.IsUnPaid = ''N'' And G.Code1=C.Code1 ' + @SqlAll + ' ' +
		'  ORDER BY G.AdId DESC,G.RegDate DESC '
		*/
		--정산한것
		'Select ISNull(Sum(ISNull(C.PartAmount,0)),0)  ' + 
		'From vi_GoodsMain G with (Nolock)  ' + @SqlLocalDB + 
		'	,(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecDate, A.RecNm, B.AdId, B.PrnAmt2, B.PrnAmtOk , B.PartAmount, B.SettleFlag, B.SettleDay ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'Where G.AdId = C.AdId  ' + 
		' And C.RecStatus=''1'' And G.LocalSite <> 0 And C.PrnAmtOk=''1'' AND C.SettleFlag=''Y'' And G.StateChk<>''6'' ' + @SqlAll + ';' + 
		--미정산한것
		'Select ISNull(Sum(ISNull(C.PartAmount,0)),0)  ' + 
		'From vi_GoodsMain G with (Nolock)  ' + @SqlLocalDB + 
		'	,(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecDate, A.RecNm, B.AdId, B.PrnAmt2, B.PrnAmtOk , B.PartAmount, B.SettleFlag, B.SettleDay ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'Where G.AdId = C.AdId  ' + 
		' And C.RecStatus=''1'' And G.LocalSite <> 0 And C.PrnAmtOk=''1'' AND C.SettleFlag=''N'' And G.StateChk<>''6'' ' + @SqlAll + ';' + 
		--모든 자료 금액		
		'Select ISNull(Sum(ISNull(C.PrnAmt2,0)),0) , ISNull(Sum(ISNull(C.PartAmount,0)),0)  ' + 
		'From vi_GoodsMain G with (Nolock)  ' + @SqlLocalDB + 
		'	,(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecDate, A.RecNm, B.AdId, B.PrnAmt2, B.PrnAmtOk , B.PartAmount, B.SettleFlag, B.SettleDay ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'Where G.AdId = C.AdId  ' + 
		' And C.RecStatus=''1'' And G.LocalSite <> 0 And C.PrnAmtOk=''1''  And G.StateChk<>''6'' ' + @SqlAll + ';' + 
		--자료 카운트
		'Select Count(Distinct G.AdId) ' + 
		'From vi_GoodsMain G with (Nolock)  ' + @SqlLocalDB + 
		'	,(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecDate, A.RecNm, B.AdId, B.PrnAmt2, B.PrnAmtOk , B.PartAmount, B.SettleFlag, B.SettleDay ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'Where G.AdId = C.AdId   ' + 
		' And G.LocalSite <> 0 And C.PrnAmtOk=''1'' And G.StateChk<>''6'' ' + @SqlAll + ';' + 
		--실제 자료
		'Select Distinct ' +
		'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,C.PrnAmt2,D.CodeNm1,G.UserName, C.RecNm,  ' +
		'	 OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, ' +		
		'  G.OptLocalBranch,C.ChargeKind, C.PrnAmtOK, G.StateChk,G.LocalBranch,G.PartnerCode,C.PartAmount,C.SettleFlag,Convert(varchar(10),C.SettleDay,120) as SettleDay, G.LocalSite ' +
		'From vi_GoodsMain G with (Nolock)  ' + @SqlLocalDB + 
		'	,(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecDate, A.RecNm, B.AdId, B.PrnAmt2, B.PrnAmtOk , B.PartAmount, B.SettleFlag, B.SettleDay ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	,(Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
		'Where G.AdId = C.AdId  And G.Code1 = D.Code1' + 
		' And G.LocalSite <> 0 And C.PrnAmtOk=''1'' And G.StateChk<>''6'' ' + @SqlAll +
		'Order By G.AdId desc'

	             
	PRINT(@strQuery)
	EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcLocalEsEndCharge]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcLocalEsEndCharge]
(
	@StrLocal         	char(2)         -- 지역코드
,	@StrStartDate		varchar(10)
)
AS
-- 전체 검색쿼리 시작
--제휴사 선택
	DECLARE @SqlLocal varchar(200)
	IF @StrLocal =''
		BEGIN			
			SET 	@SqlLocal= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlLocal= 'AND C.LocalSite='+ CONVERT(varchar(10),@StrLocal)
			
		END
		
		
		
--날짜(월)
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDate = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Left(Convert(varchar(10), C.RemitEnDate,120),7) = ''' +@strStartDate +''' '
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt+@SqlLocal+ 'AND C.SettleEndFlag <>''Y'' '
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(3000)
SET @strQuery =
		'SELECT IsNull(Sum(C.PartAmount),0) FROM GoodsMain G, Sale_BuyerInfo C  ' +
		' WHERE G.Adid = C.Adid AND C.LocalSite <> 0 AND ReceiveChk=''1'' AND RemitChk=''2'' AND C.SettleFlag=''Y'' ' + @SqlAll + ';  ' +
		'SELECT IsNull(Sum(C.PartAmount),0) FROM GoodsMain G, Sale_BuyerInfo C  ' +
		' WHERE G.Adid = C.Adid AND C.LocalSite <> 0  AND ReceiveChk=''1'' AND RemitChk=''2'' AND C.SettleFlag=''N''  ' + @SqlAll + ';  ' +
		'SELECT  IsNull(Sum(C.EscrowCharge),0), IsNull(Sum(C.PartAmount),0) FROM GoodsMain G, Sale_BuyerInfo C  ' +
		' WHERE G.Adid = C.Adid AND C.LocalSite <> 0  AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ';  ' +
		'SELECT TOP 1 COUNT(C.Adid) FROM GoodsMain G, Sale_BuyerInfo C  ' +
		' WHERE G.Adid = C.Adid AND C.LocalSite <> 0  AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ';  ' +
		' SELECT Distinct  '+ 
		'  C.Serial,C.AdId,Convert(varchar(10),C.ReceiveDate,120) as ReceiveDate,Convert(varchar(10),C.RemitEnDate,120) as RemitEnDate,  ' +
		'  C.WishAmt, S.CodeNm1,C.UserID,C.EscrowCharge,C.PartAmount,C.SettleFlag,Convert(varchar(10),C.SettleDay,120) as SettleDay,  ' +
		'  C.ChargeKind,G.LocalBranch,G.OptLocalBranch,C.LocalSite, C.CUID ' +
		'  FROM GoodsMain G, CatCode S, Sale_buyerInfo C ' +
		'  WHERE G.Adid=C.Adid AND C.LocalSite <> 0  AND G.Code1=S.Code1 AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ' ' +
		'  ORDER BY C.Serial DESC '
	
	             
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcLocalReg]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcLocalReg]
(
	@Page			int
,	@PageSize		int
,	@StrLocal        		char(2) 		--지역코드
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(30)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS

	--제휴사 선택
	DECLARE @SqlLocal varchar(200)
	DECLARE @SqlLocalDB varchar(100)
	
	IF @StrLocal =''
		BEGIN			
			SET 	@SqlLocal= ''
			SET 	@SqlLocalDB= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlLocal= ' AND G.LocalSite = ' + CONVERT(varchar(10),@StrLocal)
			SET 	@SqlLocalDB= ' '
		END

	--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND C.ChargeKind='+@strChargeKind +''
		END

	--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND G.RegDate > ''' +@strStartDt +''' '
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND G.RegDate < ''' +@StrLastDt+ ''' '
		END

	--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END

	--검색 테이블, 자료 구분
	DECLARE @SqlDivInfo varchar(20)
	IF @StrDivInfo ='SELL'
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 0 '
	END
	ELSE
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 1 '
	END

	--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord+@SqlLocal + @SqlDivInfo
		END

	DECLARE @strQuery varchar(5000)
	SET @strQuery =
	/*
	CASE
		WHEN @StrDivInfo ='SELL' THEN
			--정산한것
			'SELECT  ISNull(Sum(G.PartAmount),0) FROM GoodsMain G, GoodsSubSale S, RecCharge R ' + @SqlLocalDB + 
			'WHERE G.Adid = S.Adid AND G.GrpSerial=R.GrpSerial  And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''  AND R.RecChk=''1'' AND G.PrnAmtOk=''1''  AND G.IsUnPaid = ''N'' AND G.SettleFlag=''Y'' ' + @SqlAll + ';  ' +
			--미정산한것
			'SELECT  ISNull(Sum(G.PartAmount),0) FROM GoodsMain G, GoodsSubSale S, RecCharge R  ' + @SqlLocalDB + 
			'WHERE G.Adid = S.Adid  AND G.GrpSerial=R.GrpSerial  And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''   AND R.RecChk=''1'' And G.PrnAmtOk=''1''  AND G.IsUnPaid = ''N'' AND G.SettleFlag=''N'' ' + @SqlAll + ';  ' +
			--정산/미정산 모든 금액
			'SELECT  ISNull(Sum(G.PrnAmt2),0), ISNull(Sum(G.PartAmount),0) FROM GoodsMain G, GoodsSubSale S , RecCharge R  ' + @SqlLocalDB + 
			'WHERE G.Adid = S.Adid  AND G.GrpSerial=R.GrpSerial  And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''    AND R.RecChk=''1'' And G.PrnAmtOk=''1'' AND G.IsUnPaid = ''N'' ' + @SqlAll + ';  ' +
			--자료 카운트
			'SELECT  COUNT(Distinct G.Adid) FROM GoodsMain G, GoodsSubSale S,  CatCode C , RecCharge R ' + @SqlLocalDB + 
			'WHERE G.Adid = S.Adid  AND G.GrpSerial=R.GrpSerial  And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''   AND R.RecChk=''1'' And G.PrnAmtOk=''1''  ' + @SqlAll + ';  ' +
			--실제 자료들
			'SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.PrnAmt2,C.CodeNm1,G.UserName, G.RecNm,  ' +
			'  G.OptType,G.OptLocalBranch,G.LocalBranch,G.OptKind,G.ChargeKind, G.PrnAmtOK, G.StateChk,G.PartnerCode,G.PartAmount,G.SettleFlag,Convert(varchar(10),G.SettleDay,120) as SettleDay ' +
			'  FROM GoodsMain G, GoodsSubSale S, CatCode C, RecCharge R ' + @SqlLocalDB + 
			'  WHERE G.Adid = S.Adid  AND G.GrpSerial=R.GrpSerial  And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''   AND R.RecChk=''1''  And G.PrnAmtOk=''1''   AND G.IsUnPaid = ''N'' And G.Code1=C.Code1 ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
		ELSE
			'SELECT ISNull(Sum(G.PartAmount),0) FROM GoodsMain G, GoodsSubBuy B ' + @SqlLocalDB + 
			'WHERE G.Adid = B.Adid  And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''   And G.PrnAmtOk=''1''  AND G.IsUnPaid = ''N'' AND G.SettleFlag=''Y'' ' + @SqlAll + ';  ' +
			'SELECT ISNull(Sum(G.PartAmount),0) FROM GoodsMain G, GoodsSubBuy B ' + @SqlLocalDB + 
			'WHERE G.Adid = B.Adid  And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''   And G.PrnAmtOk=''1''   AND G.IsUnPaid = ''N'' AND G.SettleFlag=''N'' ' + @SqlAll + ';  ' +
			'SELECT ISNull(Sum(G.PrnAmt2),0),ISNull(Sum(G.PartAmount),0) FROM GoodsMain G, GoodsSubBuy B ' + @SqlLocalDB + 
			'WHERE G.Adid = B.Adid  And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''   And G.PrnAmtOk=''1''   AND G.IsUnPaid = ''N'' ' + @SqlAll + ';  ' +
			'SELECT  COUNT(Distinct G.Adid) FROM GoodsMain G, GoodsSubBuy B ' + @SqlLocalDB + 
			'WHERE G.Adid = B.Adid  And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''   And G.PrnAmtOk=''1'' AND G.IsUnPaid = ''N'' ' + @SqlAll + ';  ' +
			'  SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.PrnAmt2,C.CodeNm1,G.UserName, G.RecNm,  ' +
			'  G.OptType,G.OptLocalBranch,G.LocalBranch,G.ChargeKind, G.PrnAmtOK, G.StateChk,G.PartnerCode,G.PartAmount,G.SettleFlag,Convert(varchar(10),G.SettleDay,120) as SettleDay ' +
			'  FROM GoodsMain G, GoodsSubBuy B, CatCode C' + @SqlLocalDB + 
			'  WHERE G.Adid=B.Adid And (G.OptType <> ''0'' Or OptKind <> '''') And G.LocalBranch <> ''80''   And G.PrnAmtOk=''1''  AND G.IsUnPaid = ''N'' And G.Code1=C.Code1 ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
     	 END
	*/
		--정산한것
		'Select ISNull(Sum(ISNULL(C.PartAmount,0)),0) ' + 
		'From vi_GoodsMain G with (Nolock)  ' + @SqlLocalDB + 
		'	,(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecDate, A.RecNm, B.AdId, B.PrnAmt2, B.PrnAmtOk , B.PartAmount, B.SettleFlag, B.SettleDay ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'Where G.AdId = C.AdId  ' + 
		' And C.RecStatus=''1'' And G.LocalSite <> 0 And C.PrnAmtOk=''1'' AND C.SettleFlag=''Y'' ' + @SqlAll + ';' + 
		--미정산한것
		'Select ISNull(Sum(ISNULL(C.PartAmount,0)),0) ' + 
		'From vi_GoodsMain G with (Nolock)  ' + @SqlLocalDB + 
		'	,(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecDate, A.RecNm, B.AdId, B.PrnAmt2, B.PrnAmtOk , B.PartAmount, B.SettleFlag, B.SettleDay ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'Where G.AdId = C.AdId  ' + 
		' And C.RecStatus=''1'' And G.LocalSite <> 0 And C.PrnAmtOk=''1'' AND C.SettleFlag=''N'' ' + @SqlAll + ';' + 
		--모든 자료 금액		
		'Select ISNull(Sum(ISNULL(C.PrnAmt2,0)),0) , ISNull(Sum(ISNULL(C.PartAmount,0)),0) ' + 
		'From vi_GoodsMain G with (Nolock)  ' + @SqlLocalDB + 
		'	,(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecDate, A.RecNm, B.AdId, B.PrnAmt2, B.PrnAmtOk , B.PartAmount, B.SettleFlag, B.SettleDay ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'Where G.AdId = C.AdId  ' + 
		' And C.RecStatus=''1'' And G.LocalSite <> 0 And C.PrnAmtOk=''1''  ' + @SqlAll + ';' + 
		--자료 카운트
		'Select Count(Distinct G.AdId) ' + 
		'From vi_GoodsMain G with (Nolock)  ' + @SqlLocalDB + 
		'	,(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecDate, A.RecNm, B.AdId, B.PrnAmt2, B.PrnAmtOk , B.PartAmount, B.SettleFlag, B.SettleDay ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'Where G.AdId = C.AdId   ' + 
		' And G.LocalSite <> 0 And C.PrnAmtOk=''1'' ' + @SqlAll + ';' + 
		--실제 자료 
		'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
		'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,C.PrnAmt2,D.CodeNm1,G.UserName, C.RecNm,  ' +
		'	 OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, ' +		
		'  G.OptLocalBranch,G.LocalBranch,C.ChargeKind, C.PrnAmtOK, G.StateChk,G.PartnerCode,C.PartAmount,C.SettleFlag,Convert(varchar(10),C.SettleDay,120) as SettleDay, G.LocalSite ' +
		'From vi_GoodsMain G with (Nolock)  ' + @SqlLocalDB + 
		'	,(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecDate, A.RecNm, B.AdId, B.PrnAmt2, B.PrnAmtOk , B.PartAmount, B.SettleFlag, B.SettleDay ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	,(Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
		'Where G.AdId = C.AdId And G.Code1 = D.Code1  ' + 
		' And G.LocalSite <> 0 And C.PrnAmtOk=''1'' ' + @SqlAll +
		'Order By G.AdId desc'
--	PRINT(@SqlAll)
	EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcLoginInfo]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcLoginInfo]
(
	@UserId varchar(50)
	,@CUID	INT = NULL
)
 AS
SELECT 
-- 등록물품 갯수
	(SELECT COUNT(G.adid)
	FROM GoodsMain G, GoodsSubSale S
	WHERE G.Adid = S.AdId
	AND G.UserID = @UserId 
	AND G.CUID = @CUID 
	AND G.DelFlag = '0' AND G.StateChk = '1' AND RegAmtOK = '1' ) 
AS ProdRegCnt,
-- 판매진행 갯수
	(SELECT COUNT(B.Serial) 
	FROM Sale_BuyerInfo B, GoodsMain G
	WHERE G.Adid = B.Adid
	AND G.UserID = @UserId
	AND G.CUID = @CUID 
	AND G.DelFlag = '0' AND G.StateChk = '1' AND RegAmtOK = '1' 
	AND B.BuyChk <> '1' 					--구매취소 안된 건
	AND B.DelFlagSale <> '1'					--판매자 삭제 안된 건
	AND NOT (B.Chargekind <>'1' AND B.ReceiveChk = '0' )	--온라인입금 아니면서 결제 안된 건
	AND RemitChk<>'2' AND RefundChk<>'2') 			--입금완료나 환불완료 안된 건
AS SaleCnt,
-- 구매진행 갯수
	(SELECT COUNT(B.Serial) 
	FROM Sale_BuyerInfo B, GoodsMain G
	WHERE G.Adid = B.Adid
	AND B.UserID = @UserId
	AND G.CUID = @CUID 
	AND G.DelFlag = '0' AND G.StateChk = '1'  AND RegAmtOK = '1' 
	AND B.SaleChk <> '1' And B.DelFlagBuy <> '1'
	AND NOT (B.Chargekind <>'1' AND B.ReceiveChk = '0' )) 
AS BuyCnt,
-- 새로온 흥정갯수 구하기
	(SELECT COUNT(Serial) 
	FROM UsedCommon.dbo.GoodsBargain
	WHERE 	( SellerID = @UserId OR BuyerID = @UserId ) 
	AND (Seller_CUID = @CUID OR Buyer_CUID = @CUID)
	AND BargainResult = '0') 
AS DealCnt,
-- 새로온 쪽지갯수 구하기
	(SELECT COUNT(Serial) 
	FROM UsedCommon.dbo.SendMessage
	WHERE RecID = @UserId 
	AND REC_CUID = @CUID
	AND ReadYN = 'N') 
AS MemoCnt
GO
/****** Object:  StoredProcedure [dbo].[procMagAdStatistics]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 통계
	제작자	: 이경미
	제작일	: 2002-03-10
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procMagAdStatistics]
(
	@strFrDate		varchar(10)	-- 날짜 검색조건(부터)
,	@strToDate		varchar(10)	-- 날짜 검색조건(까지)
,	@ChargeKind		int		-- 결제구분
,               @OptType                         char(1)                   -- 옵션종류
)
AS
CREATE TABLE #Temp_LineCount
(
	Code1  		int
,  	OptType  	char(2)
,  	Count    	int
,  	PrnAmt  	int 
);
			INSERT INTO #Temp_LineCount
			SELECT A.Code1, len(A.OptKind), COUNT(*), SUM(A.PrnAmt) FROM GoodsMain A, GoodsSubSale B
			WHERE len(A.Optkind) in (0,1,4,7,10,13) AND A.AdId=B.AdId AND OptType = @OptType
			AND CONVERT(varchar(10), A.RegDate, 120) >= CONVERT(varchar(10), @strFrDate, 120)
			AND CONVERT(varchar(10), A.RegDate, 120) <= CONVERT(varchar(10), @strToDate, 120)
		-- @ChargeKind = 0 일때는 ChargeKind, PrnAmtOk 값을 비교하지 않는다
			AND A.ChargeKind		=	CASE	WHEN @ChargeKind = 0 THEN A.ChargeKind
								ELSE @ChargeKind
						            END
			AND A.PrnAmtOk		=	CASE	WHEN @ChargeKind = 0 THEN A.PrnAmtOk
								ELSE 1
						            END
			AND  NOT(A.StateChk ='4' OR A.StateChk ='5' OR A.StateChk ='6') AND DelFlag<>'3'
			GROUP BY A.Code1,len( A.Optkind)
			UNION
			SELECT A.Code1,2, COUNT(*), 0  FROM GoodsMain A, GoodsSubBuy B
			WHERE  A.AdId=B.AdId AND DelFlag<>'3'
			AND CONVERT(varchar(10), A.RegDate, 120) >= CONVERT(varchar(10), @strFrDate, 120)
			AND CONVERT(varchar(10), A.RegDate, 120) <= CONVERT(varchar(10), @strToDate, 120)
			GROUP BY A.Code1
CREATE TABLE #Temp_LineCount1
(	Code1		int
,	Count1		int   DEFAULT 0
,	PrnAmt1               int   DEFAULT 0
,	Count2		int   DEFAULT 0
,	PrnAmt2	int   DEFAULT 0
,	Count3		int   DEFAULT 0
,	PrnAmt3  	int   DEFAULT 0
,  	Count4    	int   DEFAULT 0
,  	PrnAmt4  	int   DEFAULT 0
,  	Count5    	int   DEFAULT 0
,  	PrnAmt5  	int   DEFAULT 0
,               Count6    	int   DEFAULT 0
,  	PrnAmt6  	int   DEFAULT 0
,  	Count7    	int   DEFAULT 0
,  	PrnAmt7  	int   DEFAULT 0
  	PRIMARY KEY (Code1));
INSERT INTO #Temp_LineCount1 (Code1) values (10)
INSERT INTO #Temp_LineCount1 (Code1) values (11)
INSERT INTO #Temp_LineCount1 (Code1) values (12)
INSERT INTO #Temp_LineCount1 (Code1) values (13)
INSERT INTO #Temp_LineCount1 (Code1) values (14)
INSERT INTO #Temp_LineCount1 (Code1) values (15)
INSERT INTO #Temp_LineCount1 (Code1) values (16)
INSERT INTO #Temp_LineCount1 (Code1) values (17)
INSERT INTO #Temp_LineCount1 (Code1) values (18)
INSERT INTO #Temp_LineCount1 (Code1) values (19)
INSERT INTO #Temp_LineCount1 (Code1) values (20)
INSERT INTO #Temp_LineCount1 (Code1) values (21)
INSERT INTO #Temp_LineCount1 (Code1) values (22)
INSERT INTO #Temp_LineCount1 (Code1) values (23)
INSERT INTO #Temp_LineCount1 (Code1) values (24)
UPDATE A
SET A.Count1 = B.Count, A.PrnAmt1 = B.PrnAmt
FROM #Temp_LineCount1 A, #Temp_LineCount B
WHERE A.Code1 = B.Code1
AND B.OptType = 0
UPDATE A
SET A.Count2 = B.Count, A.PrnAmt2 = B.PrnAmt
FROM #Temp_LineCount1 A, #Temp_LineCount B
WHERE A.Code1 = B.Code1
AND B.OptType = 1
UPDATE A
SET A.count3 = B.Count, A.PrnAmt3 = B.PrnAmt
FROM #Temp_LineCount1 A, #Temp_LineCount B
WHERE A.Code1 = B.Code1
AND B.OptType = 4
UPDATE A
SET A.Count4 = B.Count, A.PrnAmt4 = B.PrnAmt
FROM #Temp_LineCount1 A, #Temp_LineCount B
WHERE A.Code1 = B.Code1
AND B.OptType = 7
UPDATE A
SET A.Count5 = B.Count, A.PrnAmt5 = B.PrnAmt
FROM #Temp_LineCount1 A, #Temp_LineCount B
WHERE A.Code1 = B.Code1
AND B.OptType = 10
UPDATE A
SET A.Count6 = B.Count, A.PrnAmt6 = B.PrnAmt
FROM #Temp_LineCount1 A, #Temp_LineCount B
WHERE A.Code1 = B.Code1
AND B.OptType = 13
UPDATE A
SET A.Count7 = B.Count, A.PrnAmt7 = B.PrnAmt
FROM #Temp_LineCount1 A, #Temp_LineCount B
WHERE A.Code1 = B.Code1
AND B.OptType = 2
SELECT * FROM #Temp_LineCount1
GO
/****** Object:  StoredProcedure [dbo].[ProcMagAskList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 고객제안/문의 리스트
제작자		: 이지만
제작일		: 2002-03-08
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[ProcMagAskList] (
@PAGE		int,
@PAGESIZE	int,
@FLAG                   as varchar(1),
@STARTDATE        as  varchar(12),
@ENDDATE            as  varchar(12),
@SEARCHSELECT as  varchar(8)
)
AS
DECLARE @SQL	varchar(2000)
SET         @SQL =
          CASE   
              WHEN   @FLAG = 0  THEN       --검색어가 없는 경우
	--	WHEN @flag = 0  THEN
			'SELECT COUNT(Adid) FROM  GoodsMain  WHERE regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' AND ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND  CNTFLAG = ''1'' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			'Adid,Regdate,Code1,PrnAmt,Userid,RecNm,OptType,ChargeKind,PrnAmtOk,StateChk, CUID' + ' ' +
			'FROM  GoodsMain  WHERE  Regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' AND ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND PrnAmtOk=''0''  AND  CNTFLAG = ''1''  ORDER BY  Adid DESC '
              ELSE 		--검색어가 있는 경우
			'SELECT COUNT(Adid) FROM  GoodsMain WHERE QueryType = ''' + @SEARCHSELECT + 
			'''  AND  CNTFLAG = ''1''  AND   Regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' AND ''' + CONVERT(char(10), @ENDDATE,110) + ''' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) +
			'Adid,Regdate,Code1,PrnAmt,Userid,RecNm,OptType,ChargeKind,PrnAmtOk,StateChk, CUID' + ' ' +
			'FROM  GoodsMain' + ' ' +
                                          'WHERE  ChargeKind = ''' + @SEARCHSELECT +  
			'''  AND PrnAmtOk=''0'' AND  CNTFLAG = ''1''  AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' AND ''' + CONVERT(char(10), @ENDDATE,110)  + ''' ORDER BY  regdate DESC'
           END
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagBadAdList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 고객관리
	제작자	: 이지만
	제작일	: 2002-04-09
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[procMagBadAdList] 
(
	@Page			INT
,	@PageSize		INT
,	@cboState		VARCHAR(20)	--처리유형전체
,	@cboTerm		VARCHAR(15)	--등록일, 불량신고일,불량신고처리일 검색
,	@StDate			varChAR(20)	
,	@EnDate			varChAR(20)	
,	@cboSearch		VARCHAR(15)  	 --검색선택(아이디,이름별등등)
,	@txtSearch		VARCHAR(100)	--검색키워드
)
AS

DECLARE @RegTermSql varchar(300);	SET @RegTermSql = ''
IF @cboTerm <> ''
	SET	@RegTermSql = ' AND   ' + @cboTerm + '  BETWEEN ''' + @stDate + ''' AND ''' + @EnDate + ''' '
--	SET	@SearchTxt = ' AND   CONVERT(VARCHAR(10), ' +@cboTerm+',120) >='''+@cboyear1+'-'+@cboMonth1+'-'+@cboDay1+''''+
--		' AND CONVERT(VARCHAR(10), ' +@cboTerm+',120) <='''+@cboyear2+'-'+@cboMonth2+'-'+@cboDay2+''''
		
--처리유형
DECLARE @BadFlagSql varchar(300);	SET @BadFlagSql = ''
IF 	@cboState <> '' 
	SET	@BadFlagSql= ' AND   b.BadFlag = '''+@cboState + ''''
		
--검색선택
DECLARE @SearchSql varchar(300);	SET @SearchSql = ''
IF 	@txtSearch <> '' 
	SET	@SearchSql= ' AND ' + @cboSearch + ' LIKE  ''%' + @txtSearch + '%'' '


DECLARE @SubSql varchar(2000)
SET @SubSql = @RegTermSql + @BadFlagSql + @SearchSql



DECLARE @Sql	varchar(4000)
SET @Sql =		' SELECT 	COUNT(a.UserID)  '+
			' FROM 		vi_GoodsMain  a,   UsedCommon.dbo.UsrCnt   b ' + 
			' WHERE  	a.AdId = b.AdId   AND b.BadFlag <> ''3'' AND  b.BadIns = ''Used'' ' + @SubSql + ' ' +
			 '		  ' + ' ' +  ';'  +
			' SELECT  Top ' + CONVERT(varchar(10), @Page*@PageSize) + '  b.Serial, a.AdId  , a.UserID  AdUserID'+
			' 		, (A.OptPhoto + A.OptRecom + A.OptUrgent + A.OptMain + A.OptHot + A.OptPre + A.OptSync) AS IsOpt, A.OptKind ' +
			' 		, A.OptPhoto, A.OptRecom , A.OptUrgent, A.OptMain, A.OptHot, A.OptPre, A.OptSync  '+
			' 		,  convert(char(10),a.RegDate,120) as  AdRegDate,  ' + ' ' +
			 '		b.UserID  BUserID, b.UserNm  BUserNm, b.Email  BEmail, b.Phone  BPhone,  convert(char(10),b.Regdate,120) as  BRegdate, ' + ' ' +
			 '	 	convert(char(10),b.BadDate,120) AS BadDate ,  b.BadReason  , b.BadFlag, b.Serial , A.CUID  AdCUID , B.CUID as BCUID  ' + ' ' +
			 ' FROM   	vi_GoodsMain  a,   UsedCommon.dbo.UsrCnt   b ' + 
			 ' WHERE  	a.AdId = b.AdId  AND b.BadFlag <> ''3'' AND  b.BadIns = ''Used'' '  + @SubSql + ' ' +
			 ' ORDER BY  	b.Serial  Desc  '

--Print(@Sql)
EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[ProcMagCateCode]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 카테고리 코드
제작자		: 이지만
제작일		: 2002-04-15
		
*************************************************************************************/
CREATE PROC [dbo].[ProcMagCateCode] (
@strCode	as   varchar(20)
)
AS
DECLARE @SQL	varchar(2000)
DECLARE @strCode2	varchar(2000)
SET    	@strCode2     			='''' +  REPLACE(@strCode,'''','''''') + ''''
SET         @SQL =
		'SELECT code2,CodeNm2	FROM  CatCode	WHERE	left(code2,2)=' + @strCode2 +   '  GROUP BY  code2,CodeNm2'
print(@sql)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagCateList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 테마카테고리 리스트
제작자		: 이지만
제작일		: 2002-03-08
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[procMagCateList] (
	@SEARCHSELECT as  varchar(100)
,	@strLocal  as char(2)
)
AS
	DECLARE @SqlLocal	varchar(100)
	IF @StrLocal = '1'
		BEGIN
			SET 	@SqlLocal= ' AND B.ZipMain = ''서울'' '
		END
	ELSE IF @StrLocal = '2'
		BEGIN	
			SET 	@SqlLocal= ' AND B.ZipMain = ''부산'' '
		END
	ELSE IF @StrLocal = '3'
		BEGIN	
			SET 	@SqlLocal= ' AND B.ZipMain = ''대구'' '
		END
	ELSE
		BEGIN	
			SET 	@SqlLocal= ''
		END
DECLARE @SQL	               varchar(1000)
DECLARE @KeyWord2               varchar(1000)
SET	@KeyWord2 =  '    LIKE ''%' + @SEARCHSELECT + '%'' '
SET        @SQL =
	
		'SELECT     Count(*)	' + ' ' +
			 '	FROM  GoodsSubSale a, GoodsMain b, CatCode c					' + ' ' +
			 '	WHERE  a.Adid=b.Adid                                                                                                                 ' +
			 '		 AND b.code1=c.code1							' + ' ' +
			 '		 AND b.code2=c.code2							' + ' ' +
			 '		 AND b.code3=c.code3							' + ' ' +
			'		 AND  not(b.DelFlag =''3'' )							' + ' ' +
			'		 AND  not(b.StateChk =''4'' OR b.StateChk =''5''  OR b.StateChk =''6'') 				' + ' ' +
			 '		AND ( a.BrandNm ' + @KeyWord2 +  ' or  a.BrandNmDt  ' + @KeyWord2 +  '  or  c.codeNm1 ' + @KeyWord2 +  ' or  c.CodeNm2  ' + @KeyWord2 +  '  or  c.CodeNm3  ' +  @KeyWord2 +  '  )  '  + ' ' +
			'' + @SqlLocal +  ' '
print(@sql)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagRefundList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 환불처리 리스트
제작자		: 이지만
제작일		: 2002-03-19
셜명		: 페이징,검색
		
*************************************************************************************/
CREATE PROC [dbo].[procMagRefundList]  (
@PAGE		int,			--페이지수
@PAGESIZE	int,			--페이지사이즈
@FLAG                   as varchar(1),		--검색어가 있으면1 없으면0
@STARTDATE        as  varchar(12),		--검색날짜 시작날짜
@ENDDATE            as  varchar(12),		--검색날짜 종료날짜
@SEARCHSELECT as  varchar(8),		--검색select 박스항목
@SEARCHTEXT	 as  varchar(100),		--검색텍스트박스값
@CHARGEKIND	as   varchar(10)                 --1:온라인  2:신용카드  3:이머니
)
AS
DECLARE  @SQL			varchar(2000)
DECLARE  @STARTDATE2	 	varchar(2000)	
DECLARE  @ENDDATE2	 	varchar(2000)	
DECLARE  @SEARCHSELECT2 	varchar(2000)	
DECLARE  @SEARCHTEXT2 	varchar(2000)	
SET 	@SEARCHTEXT2 			= ' LIKE ''%' + REPLACE(@SEARCHTEXT,'''','''''') + '%''' 
SET   	@CHARGEKIND    			='''' +  REPLACE(@CHARGEKIND,'''''','''''''') + ''''
SET 	@STARTDATE2= ' AND Convert(varchar(10),a.Regdate,112) >= ''' +@STARTDATE +''''
SET 	@ENDDATE2= ' AND Convert(varchar(10),a.Regdate,112) <= ''' +@ENDDATE +''''
	IF 	@SEARCHSELECT 	= 'UserId' 
		SET @SEARCHSELECT2 	= ' and  a.UserId  ' 
	ELSE IF @SEARCHSELECT 		= 'UserName' 
		SET @SEARCHSELECT2 	= ' and  a.UserName  ' 
	ELSE IF @SEARCHSELECT 		= 'RecNm' 
		SET @SEARCHSELECT2 	= '  and  d.RecNm  ' 
	ELSE
	SET    @SEARCHSELECT2     	=''''  +  REPLACE(@SEARCHSELECT2,'''','''''') + ''''
	IF   @FLAG = 1         --검색어가 있는 경우
	     BEGIN		
	
	     SET   @SQL =	' select  TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' a.AdId	,   CONVERT(CHAR, a.RefundStDate ,111)   RefundStDate,   CONVERT(CHAR,  a.RefundEnDate ,111)     RefundEnDate,   ' + ' ' +
			' c.codeNm1  , c.CodeNm2 , c.CodeNM3  , ' + ' ' +
			' a.UserId  ,  a.UserName  , a.WishAmt , A.CUID    ' +' ' +
			' from    Sale_BuyerInfo a, GoodsMain b,  CatCode  c, EsOnLine d  ' + ' ' +
			' where             a.AdId=b.AdId  ' + ' ' +
--			' and   NOT( b.StateChk =''6'')    ' +' ' +
			' and  a.ChargeKind=' +  @CHARGEKIND + 
 			' and  a.RefundChk=''2''  ' + ' ' +
			@STARTDATE2 + @ENDDATE2 +  ' ' +
			+  @SEARCHSELECT2  +   @SEARCHTEXT2 + 
			'  and  b.Code1 =c.Code1  ' + ' ' +
			' and  b.Code2 =c.Code2  ' + ' ' +
			' and  b.Code3 =c.Code3  ' + ' ' +
			' group by  	a.AdId, a.RefundStDate, a.RefundEnDate, c.codeNm1, c.CodeNm2, c.CodeNM3, a.UserId,  a.UserName, a.WishAmt, a.WishAmt, A.CUID'
                  END
            ELSE 		--검색어가 없는 경우
                  BEGIN
	    SET   @SQL =	' select  TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' a.AdId	, CONVERT(CHAR, a.RefundStDate ,111)   RefundStDate,   CONVERT(CHAR,  a.RefundEnDate ,111)     RefundEnDate, ' + ' ' +
			' c.codeNm1  , c.CodeNm2 , c.CodeNM3  , ' + ' ' +
			' a.UserId  ,  a.UserName  , a.WishAmt    ' +' ' +
			' from    Sale_BuyerInfo a, GoodsMain b,  CatCode  c, EsOnLine d , A.CUID  ' + ' ' +
			' where             a.AdId=b.AdId  ' + ' ' +
--			' and   NOT( b.StateChk =''6'')    ' +' ' +
			' and  a.ChargeKind=' +  @CHARGEKIND + ' ' +
 			' and  a.RefundChk=''2''  ' + ' ' +
			@STARTDATE2 + @ENDDATE2 +  ' ' +
			'  and  b.Code1 =c.Code1  ' + ' ' +
			' and  b.Code2 =c.Code2  ' + ' ' +
			' and  b.Code3 =c.Code3  ' + ' ' +
			' group by  	a.AdId, a.RefundStDate, a.RefundEnDate, c.codeNm1, c.CodeNm2, c.CodeNM3, a.UserId,  a.UserName, a.WishAmt, a.WishAmt, A.CUID'
                  END  
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagRemittList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 송금처리 리스트(온라인,신용카드,이머니)
제작자		: 이지만
제작일		: 2002-03-19
셜명		: 페이징,검색
		
*************************************************************************************/
CREATE PROC [dbo].[procMagRemittList]  (
@PAGE		int,			--페이지수
@PAGESIZE	int,			--페이지사이즈
@FLAG                   as varchar(1),		--검색어가 있으면1 없으면0
@STARTDATE        as  varchar(12),		--검색날짜 시작날짜
@ENDDATE            as  varchar(12),		--검색날짜 종료날짜
@SEARCHSELECT as  varchar(8),		--검색select 박스항목
@SEARCHTEXT	 as  varchar(100),	--검색텍스트박스값
@CHARGEKIND	as   varchar(10)                 --1:온라인  2:신용카드  3:이머니
)
AS
DECLARE  @SQL			varchar(2000)
DECLARE  @STARTDATE2	 	varchar(2000)	
DECLARE  @ENDDATE2	 	varchar(2000)	
DECLARE  @SEARCHSELECT2 	varchar(2000)	
DECLARE  @SEARCHTEXT2 	varchar(2000)	
SET 	@SEARCHTEXT2 			= ' LIKE ''%' + REPLACE(@SEARCHTEXT,'''','''''') + '%''' 
SET   	@CHARGEKIND    			='''' +  REPLACE(@CHARGEKIND,'''''','''''''') + ''''
SET 	@STARTDATE2= ' AND Convert(varchar(10),a.RegDate,112) >= ''' +@STARTDATE +''''
SET 	@ENDDATE2= ' AND Convert(varchar(10),a.RegDate,112) <= ''' +@ENDDATE +''''
	IF 	@SEARCHSELECT 	= 'UserId' 
		SET @SEARCHSELECT2 	= ' and  b.UserId  ' 
	ELSE IF @SEARCHSELECT 		= 'UserName' 
		SET @SEARCHSELECT2 	= ' and  b.UserName  ' 
	ELSE IF @SEARCHSELECT 		= 'RecNm' 
		SET @SEARCHSELECT2 	= '  and  d.RecNm  ' 
	ELSE
	SET    @SEARCHSELECT2     	=''''  +  REPLACE(@SEARCHSELECT2,'''','''''') + ''''
	IF   @FLAG = 1         --검색어가 있는 경우
	     BEGIN		
		
	     SET   @SQL =	
			' select  TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' a.AdId,    CONVERT(CHAR, a.RemitStDate ,110)  RemitStDate,   CONVERT(CHAR, a.RemitEnDate ,110)    RemitEnDate, ' + ' ' +
			' c.codeNm1  , c.CodeNm2 , c.CodeNM3  , ' + ' ' +
			' b.UserId  ,  b.UserName  , a.WishAmt  , a.EscrowCharge , B.CUID  ' +' ' +
			' from    Sale_BuyerInfo a, GoodsMain b,  CatCode  c, EsOnLine d  ' + ' ' +
			' where             a.AdId=b.AdId  ' + ' ' +
--			' and   NOT( b.StateChk =''6'')    ' +' ' +
			' and  a.ChargeKind=' +  @CHARGEKIND + 
 			' and  a.RemitChk=''2''  ' + ' ' +
			@STARTDATE2 + @ENDDATE2 +  ' ' +
			+  @SEARCHSELECT2  +   @SEARCHTEXT2 + 
			'  and  b.Code1 =c.Code1  ' + ' ' +
			' and  b.Code2 =c.Code2  ' + ' ' +
			' and  b.Code3 =c.Code3  ' + ' ' +
			' group by  	a.AdId, a.RemitStDate, a.RemitEnDate, c.codeNm1, c.CodeNm2, c.CodeNM3, 	b.UserId,  b.UserName, a.WishAmt, a.EscrowCharge, B.CUID'
                  END
            ELSE 		--검색어가 없는 경우
                  BEGIN
	    SET   @SQL =	
			' select  TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) +  
			' a.AdId  ,  CONVERT(CHAR, a.RemitStDate ,110)  RemitStDate,   CONVERT(CHAR, a.RemitEnDate ,110)    RemitEnDate, ' + ' ' +
			' c.codeNm1  , c.CodeNm2 , c.CodeNM3  , ' + ' ' +
			' b.UserId  ,  b.UserName  , a.WishAmt  , a.EscrowCharge, B.CUID   ' +' ' +
			' from    Sale_BuyerInfo a, GoodsMain b,  CatCode  c  ' + ' ' +
			' where             a.AdId=b.AdId  ' + ' ' +
--			' and   NOT( b.StateChk =''6'')    ' +' ' +
			' and  a.ChargeKind=' +  @CHARGEKIND + 
			' and  a.RemitChk=''2''  ' + ' ' +
			@STARTDATE2 + @ENDDATE2 +  ' ' +
			'  and  b.Code1 =c.Code1  ' + ' ' +
			' and  b.Code2 =c.Code2  ' + ' ' +
			' and  b.Code3 =c.Code3  ' + ' ' +
			' group by   a.AdId, a.RemitStDate, a.RemitEnDate, c.codeNm1, c.CodeNm2, c.CodeNM3, b.UserId,  b.UserName, a.WishAmt, a.EscrowCharge, B.CUID'
                  END  
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagTotalList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 
제작자		: 
제작일		: 2002-03-08
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[procMagTotalList] (
@PAGE		int,
@PAGESIZE	int,
@SqlSMakDt         as varchar(100),
@SqlEMakDt        	as  varchar(100),
@SqlPrnAmtOk  	 as  varchar(100),
@SqlKeyWord  	 as  varchar(100)
)
AS
DECLARE @SQL	varchar(2000)
SET         @SQL =
	--'SELECT COUNT(*)  FROM  GoodsMain G, GoodsSubSale S, RecCharge R   Where G.AdId=S.Adid And G.GrpSerial=R.GrpSerial  Order By g.RegDate DESC;' + ' ' +
	'SELECT COUNT(*)  FROM  GoodsMain G, GoodsSubSale S, RecCharge R   Where G.AdId=S.Adid And G.GrpSerial=R.GrpSerial ;' + ' ' +
	--+  @SqlSMakDt  +  @SqlEMakDt  +  @SqlChargeKind +  @SqlPrnAmtOk + @SqlKeyWord +
	--'''  Order By G.RegDate DESC
	--' ;' + ' ' +
	'SELECT  G.ZipMain  ZipMain, G.ZipSub ZipSub  FROM GoodsMain G, GoodsSubSale S, RecCharge R  Where G.AdId=S.Adid And G.GrpSerial=R.GrpSerial ' --Order By RegDate DESC '
	--'SELECT G.AdId, G.DelDate, G.ModDate, G.StateChk, S.UseGbn, G.ZipMain, G.ZipSub, G.PrnAmt, G.UserName, G.RecNm,  G.OptType,  G.ChargeKind,  G.PrnAmtOK, G.StateChk, R.RecDate FROM GoodsMain G, GoodsSubSale S, RecCharge R  Where G.AdId=S.Adid And G.GrpSerial=R.GrpSerial  Order By g.RegDate DESC '
	--'FROM GoodsMain G, GoodsSubSale S, RecCharge R' + ' ' +
	--' Where G.AdId=S.Adid And G.GrpSerial=R.GrpSerial' + ' ' +
	--+  @SqlSMakDt +  @SqlEMakDt  +  @SqlChargeKind +  @SqlPrnAmtOk + @SqlKeyWord +
	--' Order By G.RegDate DESC '	
	--	'SELECT COUNT(serial) FROM  USRCNT  WHERE regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
	--		''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND  CNTFLAG = ''1'' ;' + ' ' +
	--		'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
	--		' serial,regdate,userid,title,sended,userNM,Email,Phone,Contents' + ' ' +
	--		'FROM  USRCNT  WHERE  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
	--		''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND  CNTFLAG = ''1''  ORDER BY  regdate DESC '
--PRINT(@STARTDATE)
--PRINT(@ENDDATE)
PRINT(@SQL)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagUsedCodeInsert]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 직종별 카테고리관리 입력
	제작자	: 김명재
	제작일	: 2003-09-02
*************************************************************************************/

CREATE PROC [dbo].[procMagUsedCodeInsert]
(
	@rdoCode	CHAR(1)	
,	@txtCodeNm1	VARCHAR(100)
,	@txtCodeNm2	VARCHAR(100)
,	@txtCodeNm3	VARCHAR(100)
,	@rdoUseFlag	CHAR(1)

)
AS

BEGIN

	BEGIN TRANSACTION

	DECLARE @cboCode1	INT
	DECLARE @cboCode2	INT
	DECLARE @Code1	INT
	DECLARE @Code2	INT
	DECLARE @Code3	INT 
	DECLARE @CodeNm1	VARCHAR(100)
	DECLARE @CodeNm2	VARCHAR(100)
	DECLARE @OrderNo1 	INT
	DECLARE @OrderNo2 	INT
	DECLARE @OrderNo3 	INT

	DECLARE @ReturnCode 	INT

	IF @rdoCode = 'B'		-- 대분류 추가라면
		BEGIN

			SELECT  @Code1=MAX(Code1) FROM CatCode With (NoLock, ReadUnCommitted)  --대분류 최대코드값

			SET @Code1 = ISNULL(@Code1,9)  
			SET @Code1 = @Code1 + 1
			
			SET @Code2 = @Code1*100+10	--대분류 입력에 따란 기본 중분류 코드값
			SET @Code3 = @Code2*100+10	--대분류 입력에 따란 기본 소분류 코드값
		
			SELECT @OrderNo1=MAX(OrderNo1) FROM CatCode With (NoLock, ReadUnCommitted)  --대분류 최대 정렬값
			SET @OrderNo1 = ISNULL(@OrderNo1, 0)
			SET @OrderNo1 = @OrderNo1 + 1

			--카테고리 추가
			INSERT	INTO CatCode (Code1, Code2, Code3, CodeNm1, CodeNm2 ,CodeNm3, OrderNo1, OrderNo2, OrderNo3, UseFlag)
			VALUES
			(@Code1, @Code2, @Code3, @txtCodeNm1, @txtCodeNm2, @txtCodeNm3, @OrderNo1,1,1,@rdoUseFlag)

			SET @ReturnCode = @Code1

		END

	ELSE IF @rdoCode = 'M'		--중분류추가

		BEGIN

			SET @cboCode1 = CONVERT(INT,@txtCodeNm1)

			--대분류 코드값, 대분류명, 정렬번호 SELECT 
	
			SELECT @Code2=MAX(Code2) , @CodeNm1=CodeNm1 , @OrderNo1=OrderNo1 FROM CatCode  With (NoLock, ReadUnCommitted)
			WHERE Code1=@cboCode1 GROUP BY CodeNm1,OrderNo1
	
			SET @Code2 = ISNULL(@Code2, @cboCode1*100+9)
			SET @Code2 = @Code2 + 1
			SET @Code3 = @Code2*100+10	--중분류 입력에 따란 기본 소분류 코드값
			
			--추가할 대분류내에서 중분류의 최대 정렬값

			SELECT @OrderNo2=MAX(OrderNo2) FROM CatCode With (NoLock, ReadUnCommitted) WHERE Code1=@cboCode1
			SET @OrderNo2 = ISNULL(@OrderNo2, 0)
			SET @OrderNo2 = @OrderNo2 + 1

			--중분류 추가
			INSERT	INTO CatCode(Code1, Code2, Code3, CodeNm1, CodeNm2, CodeNm3, OrderNo1, OrderNo2, OrderNo3, UseFlag)
			VALUES
			(@cboCode1, @Code2, @Code3, @CodeNm1, @txtCodeNm2, @txtCodeNm3, @OrderNo1, @OrderNo2, 1, @rdoUseFlag)
	
			SET @ReturnCode = @cboCode1

		END

	ELSE				-- 소분류 추가
		BEGIN

			SET @cboCode1 = CONVERT(INT,@txtCodeNm1)
			SET @cboCode2 = CONVERT(INT,@txtCodeNm2)

			SELECT @Code3 = MAX(Code3), @CodeNm1=CodeNm1, @CodeNm2=CodeNm2, @OrderNo1=OrderNo1, @OrderNo2=OrderNo2 FROM CatCode With (NoLock, ReadUnCommitted)
			WHERE Code2 = @cboCode2 GROUP BY CodeNm1,OrderNo1,CodeNm2,OrderNo2

			SET @Code3 = ISNULL(@Code3, @cboCode2*100+9)
			SET @Code3 = @Code3 + 1

			SELECT @OrderNo3=MAX(OrderNo3) FROM CatCode With (NoLock, ReadUnCommitted) WHERE Code2=@cboCode2
			SET @OrderNo3 = ISNULL(@OrderNo3, 0)
			SET @OrderNo3 = @OrderNo3 + 1


			--소분류 추가
			INSERT	INTO CatCode(Code1, Code2, Code3, CodeNm1, CodeNm2, CodeNm3, OrderNo1, OrderNo2, OrderNo3, UseFlag)
			VALUES
			(@cboCode1, @cboCode2, @Code3, @CodeNm1, @CodeNm2, @txtCodeNm3, @OrderNo1, @OrderNo2, @OrderNo3, @rdoUseFlag)

			SET @ReturnCode = @cboCode1

		END


END


	IF @@ERROR = 0 
		BEGIN
		    	COMMIT TRAN
			SELECT Code1 = @ReturnCode
		END
	ELSE
		BEGIN
			ROLLBACK
		END
GO
/****** Object:  StoredProcedure [dbo].[procMagUsedCodeList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 카테고리 관리 리스트 프로시저
	제작자	: 김명재
	제작일	: 2003-09-02
*************************************************************************************/

CREATE PROC [dbo].[procMagUsedCodeList] 
(
	@RecordCnt	varchar(10)
,	@cboCode1	varchar(10)
,	@cboCode2	varchar(10)
,	@cboUseFlag	CHAR(1) 	
,	@txtCodeNm	VARCHAR(100)	
)
AS

--  검색쿼리 시작
DECLARE @SerCode varchar(100); SET @SerCode=''
DECLARE @SerCodeNm varchar(500); SET @SerCodeNm=''
DECLARE @SerUseFlagl varchar(100); SET @SerUseFlagl=''

IF @cboCode2 <> 0	SET @SerCode = ' AND Code2=' + @cboCode2 + ' '
ELSE IF @cboCode1 <> 0	SET @SerCode = ' AND Code1=' + @cboCode1 + ' '
IF @txtCodeNm <> ''	SET @SerCodeNm = ' AND ( CodeNm1 LIKE ''%' + @txtCodeNm + '%'' OR CodeNm2 LIKE ''%' + @txtCodeNm + '%'' OR CodeNm3 LIKE ''%' + @txtCodeNm + '%'') '
IF @cboUseFlag <> ''	SET @SerUseFlagl = ' AND UseFlag=''' + @cboUseFlag + ''' '

DECLARE @Sql varchar(3000)
SET @Sql =	'SELECT COUNT(Code1) FROM CatCode WITH (NoLock, ReadUnCommitted) WHERE 1=1 ' + @SerCode + @SerCodeNm + @SerUseFlagl + ';' +
		'SELECT TOP ' + @RecordCnt + ' Code1, Code2, Code3, CodeNm1, CodeNm2, CodeNm3, OrderNo1, OrderNo2, OrderNo3, UseFlag ' +
		'FROM CatCode WITH (NoLock, ReadUnCommitted) WHERE 1=1 ' + @SerCode + @SerCodeNm + @SerUseFlagl +
		'ORDER BY OrderNo1, OrderNo2, OrderNo3'

EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[procMainList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC  [dbo].[procMainList]
	  @Local 	int
	, @Opt 		tinyint		--[0:메인, 1:포토, 2:추천, 3:조회]
	, @Cnt 		tinyint		--[불러오는 갯수]
	, @AdultCode	char(1)  		--[성인체크]	
AS

SET rowcount @Cnt    

DECLARE @SubSql varchar(1000)
SET @SubSql = ' Opt = ' + CONVERT( varchar, @Opt) + ' AND LocalSite = ' + CONVERT( varchar, @Local) 

DECLARE @OrderSql varchar(50)
IF @Opt <> 3 
	SET @OrderSql = ' ORDER  BY NEWID();'
ELSE
	SET @OrderSql = 	' ORDER BY ViewCnt DESC '

-------------------------------------------------------------
--미성년/성인구분
-------------------------------------------------------------
IF @AdultCode = '0'	SET @SubSql =  @SubSql + ' AND Code2 <> 2310 '
-------------------------------------------------------------

DECLARE @SqlQry varchar(1000)
SET @SqlQry = ' SELECT AdId, BrandNmDt, Opt, OptKind, UseGbn, WishAmt, ViewCnt, PicIdx1, PicIdx2, Isnull(PicImage,'''') As PicImage, LocalSite, EscrowYN, SpecFlag, Code2, BrandNm ' + 
	          ' FROM    dbo.GoodsMainDisplay ' + 	
	          ' WHERE ' + @SubSql + @OrderSql
	          
--Print(@SqlQry) 
EXEC (@SqlQry) 

SET rowcount 0
GO
/****** Object:  StoredProcedure [dbo].[ProcMainThemeList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcMainThemeList]
(
	@GetCount		varchar(10)
,	@Search_ZipMain	varchar(50)
,	@Search_ZipSub		varchar(50)
,	@Search_StrCode1	varchar(10)
,	@Search_StrCode2	varchar(10)
,	@Search_StrCode3	varchar(10)
,	@Option			varchar(20)	--옵션종류
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)		--사진물품
,	@UseCode		varchar(30)	--사용구분
,	@AdultCode		char(1)		--성인구분
,	@WishAmtGbn		char(1)
,	@OrderCode		char(1)			
,	@StrSearchKeyWord	varchar(50)	--키워드
,	@StrLocal		char(2)		--지역코드
,	@CountChk		char(1)		--카운트 Flag
)
AS
	
-------------------------------------------------------------
--키워드검색
-------------------------------------------------------------
	DECLARE @SqlKeyWord varchar(500) ; SET @SqlKeyWord = ''
	IF @StrSearchKeyWord <> ''	     SET @SqlKeyWord = ' AND ( C.CodeNm1 LIKE  ''%' + @StrSearchKeyWord+'%''  OR C.CodeNm2 LIKE ''%' + @StrSearchKeyWord+'%'' OR C.CodeNm3 LIKE  ''%' + @StrSearchKeyWord+'%'' OR A.BrandNmDt Like ''%' + @StrSearchKeyWord +'%'' ) ' 

-------------------------------------------------------------
--Search_ZipCode
-------------------------------------------------------------
	DECLARE @SqlZipCode varchar(100)
	IF @Search_ZipMain=''		SET 	@SqlZipCode= ' '
	ELSE  
		BEGIN
                            	IF @Search_ZipSub=''	SET 	@SqlZipCode= ' AND B.ZipMain = '''+@Search_ZipMain+''' '
			ELSE			SET 	@SqlZipCode= ' AND B.ZipMain = '''+@Search_ZipMain+''' AND B.ZipSub= '''+@Search_ZipSub+''' '
		END

-------------------------------------------------------------
--Search_Code값
-------------------------------------------------------------
--Search_Code1값
	DECLARE @SqlstrCode1 varchar(100)
	IF @Search_StrCode1=''		SET 	@SqlstrCode1= ''
	ELSE  				SET 	@SqlstrCode1= ' AND B.code1='+@Search_StrCode1 +''

--Search_Code2값
	DECLARE @SqlstrCode2 varchar(100)
	IF @Search_StrCode2=''		SET 	@SqlstrCode2= ''
	ELSE  				SET 	@SqlstrCode2= ' AND B.code2='+@Search_StrCode2 +''

--Search_Code3값
	DECLARE @SqlstrCode3 varchar(100)
	IF @Search_StrCode3=''		SET 	@SqlstrCode3= ''
	ELSE  				SET 	@SqlstrCode3= ' AND B.code3='+@Search_StrCode3 +''
-------------------------------------------------------------
--List Sort값
-------------------------------------------------------------
--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode = '1'
		SET @SqlOrderCode = ' ORDER BY WishAmt Asc, A.AdId DESC '
	ELSE IF @OrderCode = '2'
		SET @SqlOrderCode = ' ORDER BY ViewCnt Desc, A.AdId DESC '
	ELSE
		SET @SqlOrderCode = ' ORDER BY B.RegDate DESC '	
--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

-------------------------------------------------------------
--AdultCode
-------------------------------------------------------------
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

-------------------------------------------------------------
--WishAmtGbn
-------------------------------------------------------------
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''	
	IF @WishAmtGbn = '0' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 '
	Else IF  @WishAmtGbn = '1' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn = '2' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '
	Else IF  @WishAmtGbn = '3' --무료,교환,가격협의 뺀 리스트 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt > 0  '
	Else IF  @WishAmtGbn = '4' --안전거래만
		SET @SqlWishAmtGbn = ' AND A.WishAmt > 0  '

-------------------------------------------------------------
--지역에 따른 물품 출력
-------------------------------------------------------------
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE
		SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0 OR B.ShowLocalSite=' + @StrLocal + ')'

-------------------------------------------------------------
--유료옵션시 결제완료 여부
-------------------------------------------------------------
	DECLARE @SqlCondition varchar(200) ; SET @SqlCondition = ''
	IF @Option <> ''		
		SET @SqlCondition = ' AND ' + @Option + '=1  AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() AND B.LocalSite=' + @StrLocal
	ELSE
		SET @SqlCondition = ''

-------------------------------------------------------------
--전체검색쿼리묶음
-------------------------------------------------------------
	DECLARE @SqlAll	varchar(1000)
	SET @SqlAll =  @SqlEscrowYNCode + @SqlPicCode + @SqlUseCode + @SqlWishAmtGbn  + @SqlAdultCode + @SqlZipCode + @SqlstrCode1 + @SqlstrCode2 + @SqlstrCode3 + @SqlKeyWord

-------------------------------------------------------------
--Query	
-------------------------------------------------------------
	DECLARE @strQuery varchar(3000)
	IF @CountChk = '1'
	BEGIN
		SET @strQuery = 	' SELECT  COUNT(A.AdId) Cnt' 
		SET @SqlOrderCode = ''
	END
	ELSE
	BEGIN
		SET @strQuery = 	' SET ROWCOUNT ' + @GetCount + ';' +
				' SELECT  ' + 
				' A.AdId, A.BrandNmDt, A.BrandNm, A.WishAmt, A.UseGbn, ' +
				' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, ' +
				' CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 
				' OptType,OptList,OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,' +
				' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub, ' +
				' A.CardYN, A.PicIdx1, A.PicIdx2, B.ViewCnt, B.WooriID, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, B.EscrowYN, P.PicImage, B.LocalSite, B.PLineKeyNo, S.UserId AS MiniShop, B.RegDate , S.CUID' 
	END

	SET @strQuery = 	@strQuery +
				' FROM GoodsSubSale A WITH (NoLock), GoodsMain B WITH (NoLock), CatCode C WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock) ' + 
				'            , (Select UserId, CUID From SellerMiniShop WITH (NoLock) WHERE Delflag=''0'') S ' + 
				' WHERE A.AdId = B.AdId ' +
				' AND B.Code3 = C.Code3 AND B.AdId *=M.AdId AND B.AdId *= P.AdId AND B.UserId*=S.UserId AND B.CUID *=S.CUID ' +
				' AND B.DelFlag = ''0'' ' +
				' AND B.SaleOkFlag<>''1'' ' +
				' AND B.RegAmtOk = ''1'' ' +
				' AND P.PicIdx = 6 ' +	
				' AND (B.RegDate > DATEADD(dd,-31,GETDATE()) OR B.PrnEnDate >= GETDATE()) ' +		
				' AND B.StateChk = ''1'' ' + @SqlLocalGoods + @SqlAll + @SqlCondition + @SqlOrderCode + ';' +
				' SET ROWCOUNT 0;' 
			
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcMiniShopList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProcMiniShopList]
(
	@GetCount1	varchar(10)
,	@GetCount2	varchar(10)
,	@StrCode3	varchar(10)
,	@StrLocal	varchar(2)	
,	@AdultCode	char(1)
,	@OrderCode	char(1)
,	@UserID		varchar(50)
)
AS

--StrCode
	DECLARE @SqlstrCode varchar(100) ; SET @SqlstrCode = ''
	IF @StrCode3 <> ''	
		SET @SqlstrCode = ' AND G.Code3='+@StrCode3
	ELSE
		SET @SqlstrCode = ''

--StrLocal
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE
		SET @SqlLocalGoods = ' AND (G.ShowLocalSite = 0 OR G.ShowLocalSite=' + @StrLocal + ')'

--AdultCode
	DECLARE @SqlAdultCode varchar(100) 
	IF @AdultCode = '0' 	
		SET @SqlAdultCode =  ' AND (G.Code2 <> 2310) '
	ELSE
		SET @SqlAdultCode=''

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode='1'	SET @SqlOrderCode = ' ORDER BY S.WishAmt ASC '
	ELSE IF @OrderCode='2'	SET @SqlOrderCode = ' ORDER BY S.WishAmt DESC '
	ELSE			SET @SqlOrderCode = ' ORDER BY G.RegDate DESC '

--Query	
	DECLARE @strQuery varchar(5000)
	BEGIN
		SET @strQuery =  --판매자구매만족도
				' SELECT DISTINCT ' +
				' 	(SELECT COUNT(ContentFlag) FROM BuyContentChart WITH (NoLock) WHERE SellerID = '''+@UserID+''' AND  ContentFlag = ''0'') AS Satisfac, ' + 		--만족
				' 	(SELECT COUNT(ContentFlag) FROM BuyContentChart WITH (NoLock) WHERE SellerID = '''+@UserID+''' AND  ContentFlag = ''1'') AS Common, ' +	--보통
				' 	(SELECT COUNT(ContentFlag) FROM BuyContentChart WITH (NoLock) WHERE SellerID = '''+@UserID+''' AND  ContentFlag = ''2'') AS Dissatisfac' +	--불만족
				' FROM BuyContentChart WITH (NOLOCK) ' +
				' WHERE SellerID ='''+@UserID+''' ' +
					
				--판매자 총 물품 등록 수
				' ;SELECT  COUNT(G.AdId) AS TotCnt ' +
				' FROM GoodsMain G WITH (NoLock), GoodsSubSale S WITH (NoLock), GoodsPic P WITH (NoLock) ' +
				' WHERE G.AdId = S.AdId AND G.AdId*=P.AdId ' +
				'	AND G.StateChk=''1''' +
				'	AND G.RegAmtOk=''1''' + 
				'	AND G.DelFlag=''0''' +
				'	AND G.SaleOkFlag=''0''' +
				' 	AND P.PicIdx = 6 ' +
				' 	AND (G.RegEnDate >= GETDATE() OR G.PrnEnDate >= GETDATE())' +
				' 	AND G.UserId='''+@UserID+''' '  +  @SqlLocalGoods + @SqlAdultCode + 			
				
				--카테고리별 물품 등록 수
				'; SELECT C.Code3, C.CodeNm3, COUNT(G.Adid) CateCnt ' +
				' FROM CatCode C WITH (NOLOCK), GoodsMain G WITH (NOLOCK) ' +
				' WHERE C.Code3 = G.Code3  ' +
				' 	AND G.StateChk=''1'' ' +
				' 	AND G.RegAmtOk=''1''  ' +
				' 	AND G.DelFlag=''0'' ' +
				' 	AND G.SaleOkFlag=''0'' ' +
				' 	AND (G.RegEnDate >= GETDATE() OR G.PrnEnDate >= GETDATE()) ' +
				' 	AND G.UserId='''+@UserID+''' ' +  @SqlLocalGoods + @SqlAdultCode +
				' GROUP BY C.Code3, C.CodeNm3 ' +
				' ORDER BY C.Code3 ' +
				
				--베스트 조회 물품
				';SELECT TOP 4 G.Adid, G.EscrowYN, (CASE WHEN G.PrnAmtOk=''1'' THEN G.SpecFlag ELSE '''' END) AS SpecFlag, G.ViewCnt, S.BrandNm, S.UseGbn, S.WishAmt, S.SendGbn, ISNULL(P.PicImage,'''') AS PicImage ' + 
				' FROM GoodsMain G WITH (NoLock), GoodsSubSale S WITH (NoLock), GoodsPic P WITH (NoLock) ' +
				' WHERE G.AdId = S.AdId AND G.AdId*=P.AdId ' +
				' 	AND G.StateChk=''1'' ' +
				' 	AND G.RegAmtOk=''1''  ' +
				' 	AND G.DelFlag=''0'' ' +
				' 	AND G.SaleOkFlag=''0'' ' +
				' 	AND P.PicIdx = 7 ' +
				' 	AND (G.RegEnDate >= GETDATE() OR G.PrnEnDate >= GETDATE()) ' +
				' 	AND G.UserId='''+@UserID+''' ' +  @SqlLocalGoods + @SqlAdultCode +
				' ORDER BY G.ViewCnt DESC ' +

				--물품 리스트	
				';SELECT TOP ' + @GetCount1 + ' G.Adid, (CASE WHEN (G.PrnEnDate>=Getdate()  AND G.PrnAmtOk=''1'') THEN G.OptPhoto ELSE '''' END) AS OptPhoto,  (CASE WHEN (G.PrnEnDate>=Getdate()  AND G.PrnAmtOk=''1'') THEN G.OptHot ELSE '''' END) AS OptHot, (CASE WHEN (G.PrnEnDate>=Getdate()  AND G.PrnAmtOk=''1'') THEN G.OptPre ELSE '''' END) AS OptPre, CONVERT(CHAR(10),G.RegDate,120) AS RegDate, G.EscrowYN,  (CASE WHEN G.PrnAmtOk=''1'' THEN G.SpecFlag ELSE '''' END) AS SpecFlag, G.ViewCnt, '+'S.BrandNmDt, S.BrandNm, S.UseGbn, S.WishAmt, S.SendGbn, ISNULL(P.PicImage,'''') AS PicImage, M.CNT AS AnswerCnt, G.RegDate ' + 
				' FROM GoodsMain G WITH (NoLock), GoodsSubSale S WITH (NoLock), GoodsPic P WITH (NoLock), (SELECT Adid, Count(Adid) AS CNT FROM MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M ' +
				' WHERE G.AdId = S.AdId AND G.AdId*=P.AdId AND G.AdId *=M.AdId ' +
				' 	AND G.StateChk=''1'' ' +
				' 	AND G.RegAmtOk=''1''  ' +
				' 	AND G.DelFlag=''0'' ' +
				' 	AND G.SaleOkFlag=''0'' ' +
				' 	AND P.PicIdx = 7 ' +
				' 	AND (G.RegEnDate >= GETDATE() OR G.PrnEnDate >= GETDATE()) ' +
				' 	AND G.UserId='''+@UserID+''' ' +  @SqlLocalGoods + @SqlAdultCode + @SqlstrCode + @SqlOrderCode + 
				
				--판매자와의 대화
				';SELECT COUNT(*) FROM MsgBoard M WITH (NoLock)  JOIN GoodsMain G WITH (NoLock) ON M.AdId = G.AdId WHERE M.SaleUserId='''+@UserID+''' AND M.SaleFlag IN (''1'',''3'') AND G.StateChk = ''1'' AND G.DelFlag = ''0'' AND G.RegEnDate >= GetDate()'  +
				';SELECT COUNT(*) FROM MsgBoard M WITH (NoLock)  JOIN GoodsMain G WITH (NoLock) ON M.AdId = G.AdId WHERE M.SaleUserId='''+@UserID+''' AND M.SaleFlag IN (''1'',''3'') AND M.Step = 0 AND G.StateChk = ''1'' AND G.DelFlag = ''0'' AND G.RegEnDate >= GetDate()'  +
		  		';SELECT TOP ' + @GetCount2 + ' M.Serial, M.AdId, M.UserID, M.RegDate, M.Step, M.BrandNm, M.Title, M.Contents  FROM MsgBoard M WITH (NoLock)  JOIN GoodsMain G WITH (NoLock) ON M.AdId = G.AdId' + 
		  		' WHERE M.SaleUserId='''+@UserID+''' AND M.SaleFlag IN (''1'',''3'') AND G.StateChk = ''1'' AND G.DelFlag = ''0'' AND G.RegEnDate >= GetDate()  ORDER BY M.Ref DESC, M.LowRef, M.Step, M.Serial DESC'
				--';SELECT COUNT(*) FROM MsgBoard WITH (NoLock) WHERE SaleUserId='''+@UserID+''' AND SaleFlag IN (''1'',''3'')'  +
				--';SELECT COUNT(*) FROM MsgBoard WITH (NoLock) WHERE SaleUserId='''+@UserID+''' AND SaleFlag IN (''1'',''3'') AND Step = 0'  +
		  		--';SELECT TOP ' + @GetCount2 + ' Serial, AdId, UserID, RegDate, Step, BrandNm, Title, Contents FROM MsgBoard WITH (NoLock)' + 
		  		--' WHERE SaleUserId='''+@UserID+''' AND SaleFlag IN (''1'',''3'') ORDER BY Ref DESC, LowRef, Step, Serial DESC'
	END

--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcMiniShopList2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProcMiniShopList2]
(
	@GetCount1	varchar(10)
,	@GetCount2	varchar(10)
,	@StrCode3	varchar(10)
,	@StrLocal	varchar(2)	
,	@AdultCode	char(1)
,	@OrderCode	char(1)
,	@UserID		varchar(50)
)
AS

--StrCode
	DECLARE @SqlstrCode varchar(100) ; SET @SqlstrCode = ''
	IF @StrCode3 <> ''	
		SET @SqlstrCode = ' AND G.Code3='+@StrCode3
	ELSE
		SET @SqlstrCode = ''

--StrLocal
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE
		SET @SqlLocalGoods = ' AND (G.ShowLocalSite = 0 OR G.ShowLocalSite=' + @StrLocal + ')'

--AdultCode
	DECLARE @SqlAdultCode varchar(100) 
	IF @AdultCode = '0' 	
		SET @SqlAdultCode =  ' AND (G.Code2 <> 2310) '
	ELSE
		SET @SqlAdultCode=''

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode='1'	SET @SqlOrderCode = ' ORDER BY S.WishAmt ASC '
	ELSE IF @OrderCode='2'	SET @SqlOrderCode = ' ORDER BY S.WishAmt DESC '
	ELSE			SET @SqlOrderCode = ' ORDER BY G.RegDate DESC '

--Query	
	DECLARE @strQuery varchar(5000)
	BEGIN
		SET @strQuery =  --판매자구매만족도
				' SELECT DISTINCT ' +
				' 	(SELECT COUNT(ContentFlag) FROM BuyContentChart WITH (NoLock) WHERE SellerID = '''+@UserID+''' AND  ContentFlag = ''0'') AS Satisfac, ' + 		--만족
				' 	(SELECT COUNT(ContentFlag) FROM BuyContentChart WITH (NoLock) WHERE SellerID = '''+@UserID+''' AND  ContentFlag = ''1'') AS Common, ' +	--보통
				' 	(SELECT COUNT(ContentFlag) FROM BuyContentChart WITH (NoLock) WHERE SellerID = '''+@UserID+''' AND  ContentFlag = ''2'') AS Dissatisfac' +	--불만족
				' FROM BuyContentChart WITH (NOLOCK) ' +
				' WHERE SellerID ='''+@UserID+''' ' +
					
				--판매자 총 물품 등록 수
				' ;SELECT  COUNT(G.AdId) AS TotCnt ' +
				' FROM GoodsMain G WITH (NoLock), GoodsSubSale S WITH (NoLock), GoodsPic P WITH (NoLock) ' +
				' WHERE G.AdId = S.AdId AND G.AdId*=P.AdId ' +
				'	AND G.StateChk=''1''' +
				'	AND G.RegAmtOk=''1''' + 
				'	AND G.DelFlag=''0''' +
				'	AND G.SaleOkFlag=''0''' +
				' 	AND P.PicIdx = 6 ' +
				' 	AND (G.RegEnDate >= GETDATE() OR G.PrnEnDate >= GETDATE())' +
				' 	AND G.UserId='''+@UserID+''' '  +  @SqlLocalGoods + @SqlAdultCode + 			
				
				--카테고리별 물품 등록 수
				'; SELECT C.Code3, C.CodeNm3, COUNT(G.Adid) CateCnt ' +
				' FROM CatCode C WITH (NOLOCK), GoodsMain G WITH (NOLOCK) ' +
				' WHERE C.Code3 = G.Code3  ' +
				' 	AND G.StateChk=''1'' ' +
				' 	AND G.RegAmtOk=''1''  ' +
				' 	AND G.DelFlag=''0'' ' +
				' 	AND G.SaleOkFlag=''0'' ' +
				' 	AND (G.RegEnDate >= GETDATE() OR G.PrnEnDate >= GETDATE()) ' +
				' 	AND G.UserId='''+@UserID+''' ' +  @SqlLocalGoods + @SqlAdultCode +
				' GROUP BY C.Code3, C.CodeNm3 ' +
				' ORDER BY C.Code3 ' +
				
				--베스트 조회 물품
				';SELECT TOP 4 G.Adid, G.EscrowYN, (CASE WHEN G.PrnAmtOk=''1'' THEN G.SpecFlag ELSE '''' END) AS SpecFlag, G.ViewCnt, S.BrandNm, S.UseGbn, S.WishAmt, S.SendGbn, ISNULL(P.PicImage,'''') AS PicImage ' + 
				' FROM GoodsMain G WITH (NoLock), GoodsSubSale S WITH (NoLock), GoodsPic P WITH (NoLock) ' +
				' WHERE G.AdId = S.AdId AND G.AdId*=P.AdId ' +
				' 	AND G.StateChk=''1'' ' +
				' 	AND G.RegAmtOk=''1''  ' +
				' 	AND G.DelFlag=''0'' ' +
				' 	AND G.SaleOkFlag=''0'' ' +
				' 	AND P.PicIdx = 7 ' +
				' 	AND (G.RegEnDate >= GETDATE() OR G.PrnEnDate >= GETDATE()) ' +
				' 	AND G.UserId='''+@UserID+''' ' +  @SqlLocalGoods + @SqlAdultCode +
				' ORDER BY G.ViewCnt DESC ' +

				--물품 리스트	
				';SELECT TOP ' + @GetCount1 + ' G.Adid, (CASE WHEN (G.PrnEnDate>=Getdate()  AND G.PrnAmtOk=''1'') THEN G.OptPhoto ELSE '''' END) AS OptPhoto,  (CASE WHEN (G.PrnEnDate>=Getdate()  AND G.PrnAmtOk=''1'') THEN G.OptHot ELSE '''' END) AS OptHot, (CASE WHEN (G.PrnEnDate>=Getdate()  AND G.PrnAmtOk=''1'') THEN G.OptPre ELSE '''' END) AS OptPre, CONVERT(CHAR(10),G.RegDate,120) AS RegDate, G.EscrowYN,  (CASE WHEN G.PrnAmtOk=''1'' THEN G.SpecFlag ELSE '''' END) AS SpecFlag, G.ViewCnt, '+'S.BrandNmDt, S.BrandNm, S.UseGbn, S.WishAmt, S.SendGbn, ISNULL(P.PicImage,'''') AS PicImage, M.CNT AS AnswerCnt, G.RegDate ' + 
				' FROM GoodsMain G WITH (NoLock), GoodsSubSale S WITH (NoLock), GoodsPic P WITH (NoLock), (SELECT Adid, Count(Adid) AS CNT FROM MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M ' +
				' WHERE G.AdId = S.AdId AND G.AdId*=P.AdId AND G.AdId *=M.AdId ' +
				' 	AND G.StateChk=''1'' ' +
				' 	AND G.RegAmtOk=''1''  ' +
				' 	AND G.DelFlag=''0'' ' +
				' 	AND G.SaleOkFlag=''0'' ' +
				' 	AND P.PicIdx = 7 ' +
				' 	AND (G.RegEnDate >= GETDATE() OR G.PrnEnDate >= GETDATE()) ' +
				' 	AND G.UserId='''+@UserID+''' ' +  @SqlLocalGoods + @SqlAdultCode + @SqlstrCode + @SqlOrderCode + 
				
				--판매자와의 대화
				';SELECT COUNT(*) FROM MsgBoard M WITH (NoLock)  JOIN GoodsMain G WITH (NoLock) ON M.AdId = G.AdId WHERE M.SaleUserId='''+@UserID+''' AND M.SaleFlag IN (''1'',''3'') AND G.StateChk = ''1'' AND G.DelFlag = ''0'' AND G.RegEnDate >= GetDate()'  +
				';SELECT COUNT(*) FROM MsgBoard M WITH (NoLock)  JOIN GoodsMain G WITH (NoLock) ON M.AdId = G.AdId WHERE M.SaleUserId='''+@UserID+''' AND M.SaleFlag IN (''1'',''3'') AND M.Step = 0 AND G.StateChk = ''1'' AND G.DelFlag = ''0'' AND G.RegEnDate >= GetDate()'  +
		  		';SELECT TOP ' + @GetCount2 + ' M.Serial, M.AdId, M.UserID, M.RegDate, M.Step, M.BrandNm, M.Title, M.Contents  FROM MsgBoard M WITH (NoLock)  JOIN GoodsMain G WITH (NoLock) ON M.AdId = G.AdId' + 
		  		' WHERE M.SaleUserId='''+@UserID+''' AND M.SaleFlag IN (''1'',''3'') AND G.StateChk = ''1'' AND G.DelFlag = ''0'' AND G.RegEnDate >= GetDate()  ORDER BY M.Ref DESC, M.LowRef, M.Step, M.Serial DESC'
				--';SELECT COUNT(*) FROM MsgBoard WITH (NoLock) WHERE SaleUserId='''+@UserID+''' AND SaleFlag IN (''1'',''3'')'  +
				--';SELECT COUNT(*) FROM MsgBoard WITH (NoLock) WHERE SaleUserId='''+@UserID+''' AND SaleFlag IN (''1'',''3'') AND Step = 0'  +
		  		--';SELECT TOP ' + @GetCount2 + ' Serial, AdId, UserID, RegDate, Step, BrandNm, Title, Contents FROM MsgBoard WITH (NoLock)' + 
		  		--' WHERE SaleUserId='''+@UserID+''' AND SaleFlag IN (''1'',''3'') ORDER BY Ref DESC, LowRef, Step, Serial DESC'
	END

PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcMisRegProd]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 비정상 물품등록 내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-04-29
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcMisRegProd]
(
	@Page			int
,	@PageSize		int
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
SET @strQuery =
	CASE
		WHEN @StrDivInfo ='SELL' THEN
			'SELECT TOP 1 COUNT(Distinct G.Adid) FROM GoodsMain G, GoodsSubSale S, CatCode C ' +
			'WHERE G.Adid = S.Adid And G.Code1 = C.Code1  And G.StateChk=''6''  '  + @SqlAll + ';  ' +
			'SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.PrnAmt,C.CodeNm1,G.UserName, G.RecNm,  ' +
			'  G.OptType, G.PrnAmtOK, G.StateChk,G.ChargeKind, G.GrpSerial ' +
			'  FROM GoodsMain G, GoodsSubSale S,CatCode C ' +
			'WHERE G.Adid = S.Adid And G.Code1 = C.Code1 And  G.StateChk=''6''  ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
		ELSE
			'SELECT TOP 1 COUNT(Distinct G.Adid) FROM GoodsMain G, GoodsSubBuy B ' +
			'WHERE G.Adid = B.Adid And G.Code1 = C.Code1 And G.StateChk=''6''  ' + @SqlAll + ';  ' +
			'  SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.PrnAmt,C.CodeNm1,G.UserName, G.RecNm,  ' +
			'  G.OptType, G.PrnAmtOK, G.StateChk,G.ChargeKind,G.GrpSerial ' +
			'  FROM GoodsMain G, GoodsSubBuy B, CatCode C ' +
			'  WHERE G.Adid = B.Adid And G.Code1 = C.Code1  And G.StateChk=''6''  ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcMyBuyList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: MyShop 구매희망물품리스트 프로시저
	제작자	: 이창연
	제작일	: 2002-04-10
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcMyBuyList]
(
	@Page		int
,	@PageSize	int
,	@UserID		varchar(50)
,	@RdoListKind	varchar(20)	
,	@Year1		varchar(4)
,	@Month1	varchar(2)
,	@Day1		varchar(2)
,	@Year2		varchar(4)
,	@Month2	varchar(2)
,	@Day2		varchar(2)
,	@LocalSite	varchar(2)
,   @CUID		INT  = NULL 
)
AS
SET NOCOUNT ON 
-- 전체 검색쿼리 시작
IF Len(@Month1)=1 
	BEGIN
		SET @Month1 = '0'+@Month1 
	END
IF Len(@Day1)= 1 
	BEGIN
		SET @Day1 ='0'+@Day1 
	END
IF Len(@Month2)=1 
	BEGIN
		SET @Month2 = '0'+@Month2
	END
IF Len(@Day2)= 1 
	BEGIN
		SET @Day2 ='0'+@Day2 
	END
DECLARE @StrStartDt varchar(8)
	BEGIN
		SET @StrStartDt = @Year1+@Month1+@Day1
	END
DECLARE @StrLastDt varchar(8)
	BEGIN
		SET @StrLastDt = @Year2+@Month2+@Day2
	END

IF @LocalSite = ''
	BEGIN
		SET @LocalSite = '0'
	END

--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(8),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(8),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END

--2.등록상태검색
	DECLARE @SqlRdoListKind varchar(200)
	IF @RdoListKind ='전체'		
		BEGIN			
			SET 	@SqlRdoListKind= ''
		END
	ELSE IF @RdoListKind='등록중'
		BEGIN
			SET 	@SqlRdoListKind= 'AND G.PrnEnDate >= GetDate() '
		END
	ELSE IF @RdoListKind='등록기간종료'
		BEGIN
			SET 	@SqlRdoListKind= 'AND G.PrnEnDate < GetDate() '
		END
	
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt  + @SqlRdoListKind
		END
-- 키워드 검색쿼리 끝

DECLARE @strQuery varchar(2000)
	BEGIN
		SET @strQuery =
			' SELECT TOP 1 COUNT(G.Adid) FROM GoodsMain G WITH (NoLock, ReadUnCommitted) , GoodsSubBuy B WITH (NoLock, ReadUnCommitted)  ' +
			' WHERE G.Adid = B.Adid AND G.DelFlag = ''0'' AND G.StateChk=''1'' AND  G.UserID = '''+ @UserID + ''' AND G.CUID = '+CAST(@CUID as varchar) +' ' +  @SqlAll +  ' AND G.LocalSite = ' +@LocalSite + ';  ' +
			' SELECT G.Adid,  COUNT( B.Serial) As MsgCount From MsgBoard B WITH (NoLock, ReadUnCommitted), GoodsMain G WITH (NoLock, ReadUnCommitted) ' +
			' WHERE G.Adid *= B.Adid AND G.UserID = '''+@UserID+''' AND B.Step = 0 AND B.SaleUserID ='''+@UserID+''' ' +
			' GROUP BY G.Adid  ; ' +
			' SELECT Top '+ CONVERT(varchar(10), @Page*@PageSize) +
			' G.AdId,G.RegDate,G.RegEnDate,G.PrnEnDate, G.StateChk,  ' +
			' B.UseGbn, B.BrandNm, B.ChargeCard, B.ChargeCash, B.ChargeAll, B.DealAreaMain, B.DealAreaSub, B.BuyAmt,G.OptUrgent, B.Contents, G.LocalSite ' +
			' FROM GoodsMain G WITH (NoLock, ReadUnCommitted), GoodsSubBuy B WITH (NoLock, ReadUnCommitted) ' +
			' WHERE G.Adid = B.Adid AND G.DelFlag = ''0'' AND G.StateChk=''1'' AND  G.UserID = '''+ @UserID + '''  AND G.CUID = '+CAST(@CUID as varchar) +'' +  @SqlAll + ' AND G.LocalSite = ' +@LocalSite +
			' ORDER BY G.Adid DESC ; ' +
			' SELECT G.LocalSite, Count(G.Adid)  FROM GoodsMain G WITH (NoLock), GoodsSubBuy B WITH (NoLock) ' + 	
			' WHERE G.Adid = B.Adid And G.DelFlag = ''0''  AND G.StateChk=''1'' AND G.UserID = ''' + @UserID + '''  AND G.CUID = '+CAST(@CUID as varchar) +'' +  @SqlAll + ' AND G.LocalSite <> ' +@LocalSite + 
			' Group By G.LocalSite Order By G.LocalSite ' 	
	END
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcMySellList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcMySellList]
(
	@GetCount	varchar(10),
	@UserID		varchar(50),
	@LocalSite	varchar(2)	,
	@CUID		INT = NULL
)
AS
set nocount on 

IF @LocalSite = ''
	BEGIN
		SET @LocalSite = '0'
	END

DECLARE @StateQuery varchar(100)

SET @StateQuery = 'G.StateChk =''1'' '

DECLARE @strQuery varchar(1500)
	BEGIN
		SET @strQuery =
			' SELECT G.Adid,  COUNT( B.Serial) As EscrowCount From Sale_BuyerInfo B WITH (NoLock), GoodsMain G WITH (NoLock) ' +
			' Where 	G.Adid *= B.Adid AND G.UserID = '''+@UserID+''' AND G.CUID = ' + cast(@CUID as varchar) +' AND B.DelFlagSale = ''0'' AND B.StateChk=''1'' ' +
			' GROUP BY G.Adid  ' +
			' ; SELECT G.Adid,  COUNT( B.Serial) As MsgCount From MsgBoard B WITH (NoLock), GoodsMain G WITH (NoLock) ' +
			' Where 	G.Adid *= B.Adid AND G.UserID = '''+@UserID+''' AND G.CUID = ' + cast(@CUID as varchar) +' AND B.Step = 0 AND B.SaleUserID ='''+@UserID+''' ' +
			' GROUP BY G.Adid  ' +
			' ; SELECT G.Adid,  COUNT( B.Serial) As ReqEscrowCount From EscrowRequest B WITH (NoLock), GoodsMain G WITH (NoLock) ' +
			' Where 	G.Adid *= B.Adid AND G.UserID = '''+@UserID+''' ' +
			' GROUP BY G.Adid  ' +
			' ; SELECT TOP ' + @GetCount +
			' G.AdId,G.RegDate, G.PrnStDate, G.RegEnDate, G.PrnEnDate, ' +
			' S.BrandNm, G.SpecFlag ,G.PrnCnt, G.OptType, G.OptKind, ' +
			' G.OptPhoto, G.OptRecom, G.OptUrgent, G.OptMain, G.OptHot, G.OptPre, G.OptSync, G.PrnAmtOk, G.RegAmtOk, G.EscrowYN, G.LocalSite ' +
			' FROM GoodsMain G WITH (NoLock), GoodsSubSale S WITH (NoLock) ' +
			' WHERE G.Adid = S.Adid And G.DelFlag = ''0'' And ' + @StateQuery + '  And G.UserID = ''' + @UserID + ''' AND G.CUID = ' + cast(@CUID as varchar)  + ' And G.LocalSite = ' + @LocalSite +
			' ORDER BY G.Adid DESC ' +
			' ; SELECT G.LocalSite, Count(G.Adid)  FROM GoodsMain G WITH (NoLock), GoodsSubSale S WITH (NoLock) ' + 	
			' WHERE G.Adid = S.Adid And G.DelFlag = ''0'' And ' + @StateQuery + '  And G.UserID = ''' + @UserID + '''  AND G.CUID = ' + cast(@CUID as varchar) + ' And G.LocalSite <> ' + @LocalSite + 
			' Group By G.LocalSite Order By G.LocalSite ' 
	END
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcNewCount]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcNewCount]
(
	@MaxCount		varchar(5)
,	@Option  		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(30)
,	@strSpecFlag		char(1)		--개인, 전문, 바자 구분
,	@StrLocal		char(2)		-- 지역코드
)
AS
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1' 	SET @SqlPicCode = ' AND (PicIdx1 <> '''' Or PicIdx2<>'''' ) '
--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (UseGbn = '''+@UseCode +''' ) '
--개인,전문,바자구분
	DECLARE @SqlSpecFlag varchar(200)
	DECLARE @SqlBajaFlag varchar(100)
	IF @strSpecFlag = '1'		SET @SqlSpecFlag = ' AND B.SpecFlag = ''1'' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') '
	ELSE				SET @SqlSpecFlag = ' AND B.SpecFlag <> ''1'' AND B.StateChk NOT IN (''4'' , ''5'' , ''6'') '
--전체검색쿼리를 묶어서
	DECLARE @SqlAll varchar(500) ; SET @SqlAll = ''
	SET @SqlAll = @SqlPicCode + @SqlUseCode
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalSite = ''
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
			IF @Option = '0'
				SET @SqlLocalGoods = ' ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND L.LocalSite=' + @StrLocal + ') OR ' +
								' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
							' ) '
			ELSE
				SET @SqlLocalGoods = ' ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ')  ' +
							' ) '
		END
	DECLARE @SqlCondition varchar(800)
	IF @Option = '0'
		SET @SqlCondition = ''
	ELSE
		SET @SqlCondition = ' AND OptType=' + @Option + ' AND PrnAmtOk = ''1'' AND PrnEnDate >=GETDATE() '
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
			' SELECT COUNT(AdId) FROM ( ' +
			'   SELECT TOP ' + @MaxCount + ' A.AdId , A.PicIdx1 , A.PicIdx2 , A.UseGbn , B.SpecFlag ' +
			'   FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			'   WHERE A.AdId = B.AdId ' +
			'   AND B.Code3 = C.Code3 ' +
			'   AND B.SaleOkFlag <> ''1'' ' +
			'   AND B.DelFlag <> ''3'' AND ' + @SqlLocalGoods + @SqlSpecFlag + @SqlCondition + 
--			'   AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' ) ' +
--			'   AND B.UserId NOT IN (SELECT UserId FROM SaleAgency WHERE DelFlag <> ''1'') ' +
			'   ORDER BY B.OptType, A.AdId DESC ' +
			' ) AS ListTable ' +
			' WHERE 1=1 ' + @SqlAll
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcNewList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcNewList] 
(
	@GetCount		varchar(10)
,	@MaxCount		varchar(5)	--최대 갯수
,	@Option			varchar(20)	--옵션 종류
,	@BajaCode		char(1)
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(30)
,	@AdultCode		char(1)
,	@OrderCode		char(1)
,	@StrLocal		char(2)		-- 지역코드

)
AS

--bajaCode바자회여부
	DECLARE @SqlbajaCode varchar(100) ; SET @SqlbajaCode = ''
	IF @bajaCode = '1'	SET @SqlbajaCode = ' AND B.SpecFlag = ''2'' '

--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '

--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2415) '

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode = '1'
		SET @SqlOrderCode = ' ORDER BY WishAmt Asc, A.AdId DESC '
	ELSE IF @OrderCode = '2'
		SET @SqlOrderCode = ' ORDER BY ViewCnt Desc, A.AdId DESC '
	ELSE
		SET @SqlOrderCode = ' ORDER BY AdId DESC '	
	
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
	SET @SqlAll = @SqlbajaCode + @SqlEscrowYNCode + @SqlPicCode + @SqlUseCode  + @SqlAdultCode 

--유료옵션시 결제완료 여부
	DECLARE @SqlCondition varchar(200) ; SET @SqlCondition = ''
	IF @Option <> ''		
		SET @SqlCondition = ' AND ' + @Option + '=1 AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() '
	ELSE
		SET @SqlCondition = ''

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE
		SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
		                     	          ' (Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ') ' +
				          '  OR B.ZipMain = ''전국'' ) '

	DECLARE @strQuery varchar(3000)
	SET @strQuery = 	
	' SET ROWCOUNT ' + @GetCount + ';' +
	' SELECT * FROM ' +
	' (SELECT  Top ' + @MaxCount + 
	' A.AdId, A.BrandNmDt, A.WishAmt, A.UseGbn, ' +
	' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, ' +
	' CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 
	' OptType,OptList,OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,' +
	' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub, ' +
	' A.CardYN, A.PicIdx1, A.PicIdx2, B.ViewCnt, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, B.EscrowYN ' +
	' FROM GoodsSubSale A WITH (NoLock), GoodsMain B WITH (NoLock), CatCode C WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M' + 
	' WHERE A.AdId = B.AdId ' +
	' AND B.Code3 = C.Code3 AND B.AdId *=M.AdId ' +
	' AND B.DelFlag = ''0'' ' +
	' AND B.StateChk = ''1'' ' +
	' AND B.RegAmtOk = ''1'' ' +
	' AND B.SaleOkFlag<>''1'' ' +
	' ' + @SqlLocalGoods + @SqlAll + @SqlCondition + 
	' ORDER BY B.AdId Desc ) AS NewTalbe ' + @SqlOrderCode + ';' +
	' SET ROWCOUNT 0;' 

PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcOnLineReg]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 온라인신청내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-04-23
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcOnLineReg]
(
	@Page			int
,	@PageSize		int
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND G.RegDate > ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND G.RegDate < ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND A.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END

--검색 테이블, 자료 구분
	DECLARE @SqlDivInfo varchar(20)
	IF @StrDivInfo ='SELL'
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 0 '
	END
	ELSE
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 1 '
	END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(2000)
SET @strQuery =
	
	--자료수 카우트
	'Select Count(G.AdId) ' +
	'From GoodsMain G WITH (NoLock, ReadUnCommitted) ' +
	'		, RecCharge A WITH (NoLock, ReadUnCommitted) ' +
	'		, RecChargeDetail B WITH (NoLock, ReadUnCommitted) ' +
	'		, (Select Code1, CodeNm1 From CatCode WITH (NoLock, ReadUnCommitted) Group by Code1, CodeNm1) D ' +
	'Where A.GrpSerial = B.GrpSerial  ' +
	'	And G.AdId = B.AdId  ' +
	'	And G.Code1 = D.Code1 ' +
	'	And A.ChargeKind=1 And B.PrnAmtOk=''0'' And G.StateChk=''1'' And G.DelFlag = ''0'' ' +  @SqlAll +';' +

	--실제 자료
	'Select Top  ' + CONVERT(varchar(10), @Page*@PageSize) +
	' G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.UserName,G.UserID, G.StateChk,G.SpecFlag, ' +
	'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, ' +
	'	B.PrnAmt,B.PrnAmtOk, A.RecNm,A.ChargeKind,Convert(varchar(10),A.RecDate,120) as RecDate,D.CodeNm1, G.CUID ' +
	'From GoodsMain G WITH (NoLock, ReadUnCommitted) ' +
	'		, RecCharge A WITH (NoLock, ReadUnCommitted) ' +
	'		, RecChargeDetail B WITH (NoLock, ReadUnCommitted) ' +
	'		, (Select Code1, CodeNm1 From CatCode WITH (NoLock, ReadUnCommitted) Group by Code1, CodeNm1) D ' +
	'Where A.GrpSerial = B.GrpSerial  ' +
	'	And G.AdId = B.AdId  ' +
	'	And G.Code1 = D.Code1 ' +
	'	And A.ChargeKind=1 And B.PrnAmtOk=''0'' And G.StateChk=''1'' And G.DelFlag = ''0'' ' +  @SqlAll +
	'Order By G.AdId desc '


PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcOnLineRegProd]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 온라인 결제내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-04-23
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcOnLineRegProd]
(
	@Page			int
,	@PageSize		int
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND G.RegDate > ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND G.RegDate < ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END

--검색 테이블, 자료 구분
	DECLARE @SqlDivInfo varchar(20)
	IF @StrDivInfo ='SELL'
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 0 '
	END
	ELSE
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 1 '
	END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery nvarchar(2000)
SET @strQuery =
	--자료수 카우트
	'Select Count(G.AdId) ' +
	'From GoodsMain G with (Nolock) inner join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmtOk ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where C.ChargeKind=1 And C.PrnAmtOk = ''1'' ' + @SqlAll + ';' +
	--실제 자료 
	'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
	' G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.UserName,G.UserID, G.StateChk,G.SpecFlag, ' +
	'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, ' +
	'	C.PrnAmt,C.PrnAmtOk, C.RecNm,C.ChargeKind,Convert(varchar(10),C.RecDate,120) as RecDate,D.CodeNm1, G.CUID ' +
	'From GoodsMain G with (Nolock) inner join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmtOk ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where C.ChargeKind=1 And C.PrnAmtOk = ''1'' ' + @SqlAll +
	'Order By G.AdId desc'
PRINT(@strQuery)
execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcOnLineTotal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 온라인 총신청내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-04-16
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcOnLineTotal]
(
	@Page			int
,	@PageSize		int
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END

--검색 테이블, 자료 구분
	DECLARE @SqlDivInfo varchar(20)
	IF @StrDivInfo ='SELL'
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 0 '
	END
	ELSE
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 1 '
	END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery nvarchar(2000)
SET @strQuery =
	--자료수 카우트
	'Select Count(G.AdId) ' +
	'From GoodsMain G with (Nolock) inner join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmtOk ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where C.ChargeKind=1 ' + @SqlAll + ';' +
	--실제 자료 
	'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
	' G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.UserName,G.UserID, G.StateChk,G.SpecFlag, ' +
	'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, ' +
	'	C.PrnAmt,C.PrnAmtOk, C.RecNm,C.ChargeKind,Convert(varchar(10),C.RecDate,120) as RecDate,D.CodeNm1, G.CUID ' +
	'From GoodsMain G with (Nolock) inner join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmtOk ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where C.ChargeKind=1 ' + @SqlAll +
	'Order By G.AdId desc'

PRINT(@strQuery)
execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcOnLineUncollec]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 온라인 미수내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-04-23
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcOnLineUncollec]
(
	@Page			int
,	@PageSize		int
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
SET @strQuery =
	CASE
		WHEN @StrDivInfo ='SELL' THEN
			'SELECT TOP 1 COUNT(G.Adid) FROM GoodsMain G, GoodsSubSale S, RecCharge R  ' +
			'WHERE G.Adid = S.Adid And G.ChargeKind=''1'' And G.GrpSerial = R.GrpSerial And G.PrnAmtOk=''2'' And G.IsUnpaid=''Y'' And G.IsUnpaidDate is Null ' + @SqlAll + ';  ' +
			'SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.PrnAmt,C.CodeNm1,G.UserName, G.RecNm,  ' +
			'  G.OptType,G.OptKind,G.ChargeKind, G.PrnAmtOK, G.StateChk, Convert(varchar(10),R.RecDate,120) as RecDate ' +
			'  FROM GoodsMain G, GoodsSubSale S, RecCharge R, CatCode C ' +
			'  WHERE G.Adid=S.Adid And G.ChargeKind=''1'' And G.Code1=C.Code1 And  G.GrpSerial = R.GrpSerial And G.PrnAmtOk=''2'' And G.IsUnpaid=''Y'' And G.IsUnpaidDate is Null ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
		ELSE
			'SELECT TOP 1 COUNT(G.Adid) FROM GoodsMain G, GoodsSubBuy B, RecCharge R ' +
			'WHERE G.Adid = B.Adid And G.ChargeKind=''1'' And G.GrpSerial = R.GrpSerial And G.PrnAmtOk=''2'' And G.IsUnpaid=''Y'' And G.IsUnpaidDate is Null ' + @SqlAll + ';  ' +
			'  SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.PrnAmt,C.CodeNm1,G.UserName, G.RecNm,  ' +
			'  G.OptType,G.ChargeKind, G.PrnAmtOK, G.StateChk, Convert(varchar(10),R.RecDate,120) as RecDate ' +
			'  FROM GoodsMain G, GoodsSubBuy B, RecCharge R, CatCode C ' +
			'  WHERE G.Adid = B.Adid And G.ChargeKind=''1'' And G.Code1=C.Code1 And  G.GrpSerial = R.GrpSerial And G.PrnAmtOk=''2'' And G.IsUnpaid=''Y'' And G.IsUnpaidDate is Null ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcOnLineUncollecList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 온라인미수결제내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-04-23
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcOnLineUncollecList]
(
	@Page			int
,	@PageSize		int
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
SET @strQuery =
	CASE
		WHEN @StrDivInfo ='SELL' THEN
			'SELECT TOP 1 COUNT(G.Adid) FROM GoodsMain G, GoodsSubSale S ' +
			'WHERE G.Adid = S.Adid And G.ChargeKind=''1'' And G.IsUnpaid=''N'' And G.PrnAmtOk=''1'' And G.IsUnpaidDate is not Null  ' + @SqlAll + ';  ' +
			'SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate, C.CodeNm1, G.PrnAmt, G.UserName, G.RecNm,  ' +
			'  G.OptType,G.OptKind,G.ChargeKind, G.PrnAmtOK, G.StateChk, G.IsUnpaid, Convert(varchar(10),G.IsUnpaidDate,120) as IsUnpaidDate ' +
			'  FROM GoodsMain G, GoodsSubSale S, CatCode C ' +
			'  WHERE G.Adid=S.Adid And G.ChargeKind=''1'' And G.Code1=C.Code1 And G.IsUnpaid=''N'' And G.PrnAmtOk=''1'' And G.IsUnpaidDate is not Null ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
		ELSE
			'SELECT TOP 1 COUNT(G.Adid) FROM GoodsMain G, GoodsSubBuy B ' +
			'WHERE G.Adid = B.Adid And G.ChargeKind=''1'' And G.IsUnpaid=''N'' And G.PrnAmtOk=''1'' And G.IsUnpaidDate is not Null ' + @SqlAll + ';  ' +
			'  SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate, C.CodeNm1, G.PrnAmt, G.UserName, G.RecNm,  ' +
			'  G.OptType,G.ChargeKind, G.PrnAmtOK, G.StateChk, G.IsUnpaid, Convert(varchar(10),G.IsUnpaidDate,120) as IsUnpaidDate ' +
			'  FROM GoodsMain G, GoodsSubBuy B, CatCode C  ' +
			'  WHERE G.Adid = B.Adid And G.ChargeKind=''1'' And G.Code1=C.Code1 And G.IsUnpaid=''N'' And G.PrnAmtOk=''1'' And G.IsUnpaidDate is not Null ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcPartEndCharge]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcPartEndCharge]
(
              @StrPartner	varchar(10)         --제휴사
,	@StrStartDate	varchar(10)
)
AS
	-- 전체 검색쿼리 시작
	--제휴사 선택
	DECLARE @SqlPartner varchar(200)
	IF @StrPartner =''
		BEGIN			
			SET 	@SqlPartner= 'AND G.PartnerCode<>0 '
		END
	ELSE  
		BEGIN
			SET 	@SqlPartner= 'AND G.PartnerCode='+@StrPartner +''
		END
	
	--날짜(월)
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDate = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Left(Convert(varchar(10),G.RegDate,120),7) = ''' +@strStartDate +''' '
		END

	--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt+@SqlPartner+ 'AND S.PartAmount<>0 '
		END

	DECLARE @strQuery varchar(3000)
	SET @strQuery =
			'SELECT  ISNull(Sum(S.PartAmount),0) FROM vi_GoodsMain G, RecChargeDetail S  ' +
			'WHERE G.Adid = S.Adid And S.PrnAmtOk=''1'' AND S.SettleFlag=''Y'' ' + @SqlAll + ';  ' +
                                               'SELECT  ISNull(Sum(S.PartAmount),0) FROM vi_GoodsMain G, RecChargeDetail S  ' +
			'WHERE G.Adid = S.Adid And S.PrnAmtOk=''1'' AND S.SettleFlag=''N'' ' + @SqlAll + ';  ' +
                                                'SELECT  ISNull(Sum(S.PrnAmt2),0), ISNull(Sum(S.PartAmount),0) FROM vi_GoodsMain G, RecChargeDetail S  ' +
			'WHERE G.Adid = S.Adid And S.PrnAmtOk=''1'' ' + @SqlAll + ';  ' +
                                                'SELECT TOP 1 COUNT(G.Adid) FROM vi_GoodsMain G, RecChargeDetail S  ' +
			'WHERE G.Adid = S.Adid And S.PrnAmtOk=''1'' ' + @SqlAll + ';  ' +
			' SELECT DISTINCT '+
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate, S.PrnAmt2, C.CodeNm1,G.UserName, R.RecNm,  ' +
			'  G.OptPhoto, G.OptRecom, G.OptUrgent, G.OptMain, G.OptHot, G.OptPre, G.OptSync, G.OptKind,R.ChargeKind, S.PrnAmtOK, G.PartnerCode,S.PartAmount,S.SettleFlag,Convert(varchar(10),S.SettleDay,120) as SettleDay, G.AdGbn ' +
			'  FROM vi_GoodsMain G, RecChargeDetail S, CatCode C, RecCharge R ' +
			'  WHERE G.Adid=S.Adid And S.GrpSerial=R.GrpSerial AND S.PrnAmtOk=''1''  And G.Code1=C.Code1 ' + @SqlAll + ' ' +
			'  ORDER BY G.RegDate DESC '
	
	             
--	PRINT(@strQuery)
	EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcPartEsEndCharge]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcPartEsEndCharge]
(
                @StrPartner         	varchar(10)        --제휴사
,	@StrStartDate		varchar(10)
)
AS
	
	--제휴사 선택
	DECLARE @SqlPartner varchar(200)
	IF @StrPartner =''
		BEGIN			
			SET 	@SqlPartner= 'AND  C.PartnerCode<>0 '
		END
	ELSE  
		BEGIN
			SET 	@SqlPartner= 'AND  C.PartnerCode='+@StrPartner +' '
		END
	
	--날짜(월)
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDate = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Left(Convert(varchar(10), C.RemitEnDate,120),7) = ''' +@strStartDate +''' '
		END

	--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt+@SqlPartner+ 'AND C.SettleEndFlag <>''Y'' '
		END

	DECLARE @strQuery varchar(3000)
	SET @strQuery =
			 'SELECT IsNull(Sum(C.PartAmount),0) FROM GoodsMain G, Sale_BuyerInfo C  ' +
			' WHERE G.Adid = C.Adid AND ReceiveChk=''1'' AND RemitChk=''2'' AND C.SettleFlag=''Y'' ' + @SqlAll + ';  ' +
                                                'SELECT IsNull(Sum(C.PartAmount),0) FROM GoodsMain G, Sale_BuyerInfo C  ' +
			' WHERE G.Adid = C.Adid AND ReceiveChk=''1'' AND RemitChk=''2'' AND C.SettleFlag=''N''  ' + @SqlAll + ';  ' +
                                                'SELECT  IsNull(Sum(C.EscrowCharge),0), IsNull(Sum(C.PartAmount),0) FROM GoodsMain G, Sale_BuyerInfo C  ' +
			' WHERE G.Adid = C.Adid AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ';  ' +
			'SELECT TOP 1 COUNT(C.Adid) FROM GoodsMain G, Sale_BuyerInfo C  ' +
			' WHERE G.Adid = C.Adid AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ';  ' +
			' SELECT '+ 
			'  C.Serial,C.AdId,Convert(varchar(10),C.ReceiveDate,120) as ReceiveDate,Convert(varchar(10),C.RemitEnDate,120) as RemitEnDate,  ' +
                                                '  C.WishAmt, S.CodeNm1,C.UserID,C.EscrowCharge,C.PartAmount,C.SettleFlag,Convert(varchar(10),C.SettleDay,120) as SettleDay,  ' +
			'  C.ChargeKind,C.PartnerCode, C.CUID ' +
			'  FROM GoodsMain G, CatCode S, Sale_buyerInfo C ' +
			'  WHERE G.Adid=C.Adid AND G.Code1=S.Code1 AND ReceiveChk=''1'' AND RemitChk=''2''  ' + @SqlAll + ' ' +
			'  ORDER BY C.Serial DESC '
	
	             
--	PRINT(@strQuery)
	EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcPartReg]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcPartReg]
(
	@Page			int
,	@PageSize		int
,	@StrPartner         		varchar(10)          --제휴사
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(30)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
	-- 전체 검색쿼리 시작
	--제휴사 선택
	DECLARE @SqlPartner varchar(200)
	IF @StrPartner ='0'
		BEGIN			
			SET 	@SqlPartner= 'AND G.PartnerCode <> 0 '
		END
	ELSE  
		BEGIN
			SET 	@SqlPartner= 'AND G.PartnerCode='+@StrPartner +' '
		END

	--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND R.ChargeKind='+@strChargeKind +''
		END

	--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND G.RegDate > ''' +@strStartDt +''' '
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND G.RegDate < ''' +@StrLastDt+ ''' '
		END

	--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND R.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
 
	--자료구분(팝니다,삽니다)
	DECLARE @SqlDivInfo varchar(200)
	IF @StrDivInfo ='SELL'
		SET 	@SqlDivInfo= ' AND G.AdGbn=0 '
	ELSE  
		SET 	@SqlDivInfo= ' AND G.AdGbn=1 '

	--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord+@SqlPartner+@SqlDivInfo+ ' AND S.PartAmount <> 0  '
		END

	DECLARE @strQuery varchar(3000)
	SET @strQuery =
			'SELECT  ISNull(Sum(S.PartAmount),0) FROM vi_GoodsMain G, RecChargeDetail S, RecCharge R  ' +
			'WHERE G.Adid = S.Adid AND S.GrpSerial=R.GrpSerial AND S.PrnAmtOk=''1'' AND S.SettleFlag=''Y'' ' + @SqlAll + ';  ' +
      			
			'SELECT  ISNull(Sum(S.PartAmount),0) FROM vi_GoodsMain G, RecChargeDetail S, RecCharge R  ' +
			'WHERE G.Adid = S.Adid AND S.GrpSerial=R.GrpSerial AND S.PrnAmtOk=''1'' AND S.SettleFlag=''N'' ' + @SqlAll + ';  ' +
      			
			'SELECT  ISNull(Sum(S.PrnAmt2),0), ISNull(Sum(S.PartAmount),0) FROM vi_GoodsMain G, RecChargeDetail S, RecCharge R  ' +
			'WHERE G.Adid = S.Adid AND S.GrpSerial=R.GrpSerial AND S.PrnAmtOk=''1''  ' + @SqlAll + ';  ' +
      
			'SELECT  TOP 1 COUNT(G.Adid) FROM vi_GoodsMain G, RecChargeDetail S, RecCharge R  ' +
			'WHERE G.Adid = S.Adid  AND S.GrpSerial=R.GrpSerial  AND S.PrnAmtOk=''1''  ' + @SqlAll + ';  ' +
			'SELECT DISTINCT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,S.PrnAmt2,C.CodeNm1,G.UserName, R.RecNm, G.SpecFlag,  ' +
			'  G.OptPhoto, G.OptRecom, G.OptUrgent, G.OptMain, G.OptHot, G.OptPre, G.OptSync, G.OptLink, G.OptKind, R.ChargeKind, S.PrnAmtOK, G.StateChk, G.PartnerCode, S.PartAmount, S.SettleFlag,Convert(varchar(10),S.SettleDay,120) as SettleDay ' +
			'  FROM vi_GoodsMain G, RecChargeDetail S, CatCode C, RecCharge R ' +
			'  WHERE G.Adid=S.Adid  AND S.GrpSerial=R.GrpSerial AND S.PrnAmtOk=''1''  And G.Code1=C.Code1 ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
--	PRINT(@strQuery)
	EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcPhoneAbNormal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 휴대폰 결제 관리-비정상내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-16
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcPhoneAbNormal]
(
	@Page			int
,	@PageSize		int
, @strDivInfo		varchar(10)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@strLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--3. 자료구분(삽니다/팝니다)
	DECLARE @SqlDivInfo varchar(200)
	IF @strDivInfo = 'SELL'		
		BEGIN			
			SET 	@SqlDivInfo= ' And G.AdGbn = 0 '
		END
	ELSE
		BEGIN
			SET 	@SqlDivInfo= ' And G.AdGbn = 1 '
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(2000)
	BEGIN
		SET @strQuery =
		
	--자료 갯수
		'Select Count(distinct C.GrpSerial) ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId ' +
		'Where C.ChargeKind=''3'' And IsNull(G.DelFlag,''0'') = ''0'' And C.RecStatus<>''1'' ' + @SqlAll +
		' ; ' +
		--결제 총 금액
		'Select Sum(distinct C.PrnAmt) ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId  ' +
		'Where C.ChargeKind=''3'' And IsNull(G.DelFlag,''0'') = ''0'' And C.RecStatus<>''1'' ' + @SqlAll +
		'; ' +
		--실제자료들
		'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
		'  C.GrpSerial,  Convert(varchar(10),G.RegDate,112) as RegDate,Count(G.Adid) As AdCount, Sum(C.PrnAmt) As TotPrnAmt,  ' +
		'  G.UserName, C.RecStatus ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId  ' +
		'Where C.ChargeKind=''3'' And IsNull(G.DelFlag,''0'') = ''0'' And C.RecStatus<>''1'' ' + @SqlAll +
		'Group By C.GrpSerial, Convert(varchar(10), G.RegDate,112), G.UserName, C.RecStatus ' +
		'Order by C.GrpSerial DESC, Regdate DESC ' 

	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcPhoneDel]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 휴대폰 결제 관리-게재후 삭제 내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-16
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcPhoneDel]
(
	@Page			int
,	@PageSize		int
, @strDivInfo		varchar(10)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--3. 자료구분(삽니다/팝니다)
	DECLARE @SqlDivInfo varchar(200)
	IF @strDivInfo = 'SELL'		
		BEGIN			
			SET 	@SqlDivInfo= ' And G.AdGbn = 0 '
		END
	ELSE
		BEGIN
			SET 	@SqlDivInfo= ' And G.AdGbn = 1 '
		END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(3000)
	BEGIN
		SET @strQuery =
		/*
			'SELECT  COUNT(Distinct G.GrpSerial) FROM GoodsMain G, RecCharge R ' +
			' WHERE R.GrpSerial =*G.GrpSerial And G.ChargeKind=''3'' And  G.DelFlag=''3''  And G.StateChk=''1'' ' + @SqlAll + '; ' +
			' SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  R.GrpSerial,  Convert(varchar(10),R.RecDate,120) as RecDate,Convert(varchar(10),G.DelDate,120) As CanCelDate, ' +
			'  Convert(varchar(10),G.PrnStDate,120) As PrnStDate, Count(G.Adid) As AdCount, Sum(G.PrnAmt) As TotPrnAmt, G.UserName ' +
			'  FROM RecCharge R , GoodsMain G ' +
			'  WHERE R.GrpSerial =* G.GrpSerial And G.ChargeKind=''3'' And  G.DelFlag=''3'' And G.StateChk=''1''   ' + @SqlAll + ' ' +
			'  Group By R.GrpSerial,  Convert(varchar(10),R.RecDate,120), Convert(varchar(10),G.DelDate,120), Convert(varchar(10),G.PrnStDate,120),G.UserName  ' 
		*/

		--자료 갯수
		'Select Count(distinct C.GrpSerial) ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId ' +
		'Where C.ChargeKind=''3'' And IsNull(G.DelFlag,''0'') <> ''0'' And C.RecStatus=''1'' ' + @SqlAll +
		' ; ' +
		--실제자료들
		'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
		'  C.GrpSerial,  Convert(varchar(10),C.RecDate,112) as RecDate,Convert(varchar(10),G.RegDate,112) as RegDate,Convert(varchar(10),G.DelDate,112) As CanCelDate,Convert(varchar(10),G.PrnStDate,112) as PrnStDate, Count(G.Adid) As AdCount, Sum(C.PrnAmt) As TotPrnAmt,  ' +
		'  G.UserName, C.RecStatus ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, A.RecDate,B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId  ' +
		'Where C.ChargeKind=''3'' And IsNull(G.DelFlag,''0'') <> ''0'' And C.RecStatus=''1'' ' + @SqlAll +
		'Group By C.GrpSerial, Convert(varchar(10),C.RecDate,112),Convert(varchar(10), G.RegDate,112),Convert(varchar(10),G.DelDate,112) , Convert(varchar(10),G.PrnStDate,112), G.UserName, C.RecStatus ' +
		'Order by C.GrpSerial DESC, Regdate DESC ' 

	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcPhoneNormal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 휴대폰 결제 관리-정상내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-16
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcPhoneNormal]
(
	@Page			int
,	@PageSize		int
, @strDivInfo		varchar(10)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--2.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--3. 자료구분(삽니다/팝니다)
	DECLARE @SqlDivInfo varchar(200)
	IF @strDivInfo = 'SELL'		
		BEGIN			
			SET 	@SqlDivInfo= ' And G.AdGbn = 0 '
		END
	ELSE
		BEGIN
			SET 	@SqlDivInfo= ' And G.AdGbn = 1 '
		END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(4000)
	BEGIN
		SET @strQuery =
			/*
			'SELECT  COUNT(R.GrpSerial) FROM GoodsMain G, RecCharge R ' +
			'Where R.GrpSerial =*G.GrpSerial And G.ChargeKind=''3'' And  G.PrnAmtOk=''1''   ' + @SqlAll + '; ' +
			' SELECT Sum(G.PrnAmt) As TotalSum From GoodsMain G, RecCharge R ' +
			'  WHERE R.GrpSerial =* G.GrpSerial And G.ChargeKind=''3'' And G.PrnAmtOk=''1'' AND G.StateChk<>''4'' AND G.DelFlag<>''3''   ' + @SqlAll + ' ' +
			'SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  R.GrpSerial,  Convert(varchar(10),G.RegDate,120) as RegDate,Count(G.Adid) As AdCount, Sum(G.PrnAmt) As TotPrnAmt,  ' +
			'  G.UserName, G.StateChk' +
			'  FROM RecCharge R , GoodsMain G ' +
			'  WHERE R.GrpSerial =* G.GrpSerial And G.ChargeKind=''3'' And G.PrnAmtOk=''1''   ' + @SqlAll + ' ' +
			'  Group By R.GrpSerial, Convert(varchar(10), G.RegDate,120), G.UserName, G.StateChk Order by R.GrpSerial DESC, Regdate DESC ' 
			*/

		--자료 갯수
		'Select Count(distinct C.GrpSerial) ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId ' +
		'Where C.ChargeKind=''3'' And IsNull(G.DelFlag,''0'') = ''0'' And C.RecStatus=''1'' ' + @SqlAll +
		' ; ' +
		--결제 총 금액
		'Select Sum(distinct C.PrnAmt) ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId  ' +
		'Where C.ChargeKind=''3'' And IsNull(G.DelFlag,''0'') = ''0'' And C.RecStatus=''1'' ' + @SqlAll +
		'; ' +
		--실제자료들
		'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
		'  C.GrpSerial,  Convert(varchar(10),G.RegDate,112) as RegDate,Count(G.Adid) As AdCount, Sum(C.PrnAmt) As TotPrnAmt,  ' +
		'  G.UserName, C.RecStatus ' +
		'From GoodsMain G with (Nolock) inner join  ' +
		'	(Select A.GrpSerial, A.ChargeKind, A.RecStatus, A.RecNm, A.KiccTransNo, B.AdId, B.PrnAmt ' +
		'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
		'	on G.AdId = C.AdId  ' +
		'Where C.ChargeKind=''3'' And IsNull(G.DelFlag,''0'') = ''0'' And C.RecStatus=''1'' ' + @SqlAll +
		'Group By C.GrpSerial, Convert(varchar(10), G.RegDate,112), G.UserName, C.RecStatus ' +
		'Order by C.GrpSerial DESC, Regdate DESC ' 

	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcPhotoList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcPhotoList]
(
	@GetCount	varchar(10)
,	@StrCode1	varchar(10)
,	@StrLocal	varchar(2)	-- 지역코드
,	@AdultCode	char(1)
)
AS

--Code값
	DECLARE @SqlstrCode varchar(100) ; SET @SqlstrCode = ''
	IF @StrCode1 <> ''	SET @SqlstrCode = ' AND B.Code1='+@StrCode1

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500); 
--	SET @SqlLocalGoods = ' AND B.LocalSite=' + @StrLocal

	IF @StrLocal ='0'
		SET @SqlLocalGoods = ' AND B.LocalSite =0 ' 
	ELSE
		SET @SqlLocalGoods = ' AND (B.LocalSite = 0 OR B.LocalSite=' + @StrLocal + ')'

--AdultCode
	DECLARE @SqlAdultCode varchar(100) 
	IF @AdultCode = '0' 	
		SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '
	ELSE
		SET @SqlAdultCode=''

	DECLARE @strSelect varchar(300)
	DECLARE @strOrder varchar(100)
	DECLARE @strQuery varchar(3000)
	IF @GetCount = '0'
		BEGIN
			SET @strSelect = 'SELECT COUNT(B.AdId) '
			SET @strOrder = ''
		END
	ELSE
		BEGIN
			SET @strSelect = 'SELECT TOP ' + @GetCount + ' B.Adid, S.BrandNmDt, EscrowYN, S.WishAmt, S.GoodsQt, S.UseGbn, B.ZipMain, B.ZipSub, P.PicImage, M.UserId AS MiniShop , M.CUID AS MiniShopCUID '
			SET @strOrder = ' ORDER BY B.AdId DESC '
		END

	SET @strQuery =  @strSelect +
					' FROM GoodsMain B WITH (NoLock), GoodsSubSale S WITH (NoLock), GoodsPic P WITH (NoLock) ' + 
					'            , (Select UserId,CUID From SellerMiniShop WITH (NoLock) WHERE Delflag=''0'') M ' + 
					' WHERE B.AdId = S.AdId AND B.UserId*=M.UserId ' +
					' AND B.AdId=P.AdId ' +
					' AND P.PicIdx=7 ' +
					' AND B.OptPhoto=1 ' +
					' AND B.PrnAmtOk=''1'' AND B.PrnEnDate >= GETDATE() ' +
					' AND B.StateChk=''1'' AND B.DelFlag=''0'' AND B.SaleOkFlag=''0'' ' + @SqlstrCode + @SqlLocalGoods + @SqlAdultCode +
			@strOrder

--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procProdDayCharge]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[procProdDayCharge]
(
	@strFrDate	varchar(10)	-- 날짜 검색조건(부터)
,	@strToDate	varchar(10)	-- 날짜 검색조건(까지)
,	@strPartner   	varchar(10)	-- 제휴사구분
)
AS

	SET @strToDate = DateAdd(d,1,@strToDate)

	--제휴사 구분
  	DECLARE @SqlPartner varchar(200)
	IF @StrPartner =''
		BEGIN			
			SET 	@SqlPartner= 'AND A.PartnerCode <> 0 '
		END
	ELSE  
		BEGIN
			SET 	@SqlPartner= 'AND A.PartnerCode='+@StrPartner +' '
		END
		
 
	DECLARE @strQuery varchar(8000)
	SET @strQuery =
		'SELECT Q.RecDate,' + 
		'Sum(Q.C1) as Cnt1,IsNull(Sum(Q.S1),0)as Amt1,Sum(Q.C2)as Cnt2,IsNull(Sum(Q.S2),0)as Amt2,Sum(Q.C3)as Cnt3, '+
		'IsNull(Sum(Q.S3),0)as Amt3,Sum(Q.C4)as Cnt4,IsNull(Sum(Q.S4),0)as Amt4, '+
		'Sum(Q.BC1) as BCnt1,IsNull(Sum(Q.BS1),0)as BAmt1,Sum(Q.BC2)as BCnt2,IsNull(Sum(Q.BS2),0)as BAmt2,Sum(Q.BC3)as BCnt3, '+
		'IsNull(Sum(Q.BS3),0)as BAmt3,Sum(Q.BC4)as BCnt4,IsNull(Sum(Q.BS4),0)as BAmt4  '+
		'FROM(  '+ 
		--판매물품 신용카드 통계(C1, S1)
		'SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		'COUNT(A.AdId)as C1, SUM(C.PrnAmt2)as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4   '+
		'FROM vi_GoodsMain A, RecCharge B, RecChargeDetail C ' + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=0 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''2'' AND C.PartAmount <> 0 '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		'UNION all  '+
		--판매물품 휴대폰 통계(C2, S2)
		' SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		' '''' as C1,'''' as S1,COUNT(A.AdId)as C2, SUM(C.PrnAmt2) as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4   '+
		'FROM vi_GoodsMain A, RecCharge B, RecChargeDetail C ' + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=0 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''3'' AND C.PartAmount <> 0 '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		' UNION all  '+
		--판매물품 온라인 통계(C3, S3)
		' SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,COUNT(A.AdId)as C3, SUM(C.PrnAmt2) as S3,'''' as C4,'''' as S4,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4   '+
		'FROM vi_GoodsMain A, RecCharge B, RecChargeDetail C ' + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=0 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''1'' AND C.PartAmount <> 0 '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		'UNION all  '+
		--판매물품 무료매물 통계(C4, S4)
		'SELECT CONVERT(varchar(10), A.RegDate, 120) as RecDate, ''0'' As ChargeKind,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,COUNT(A.AdId)as C4, 0 as S4 ,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4   '+
		' FROM vi_GoodsMain A with (Nolock) ' + 
		'WHERE  '+
		' A.RegDate > '''+@strFrDate+''' '+
		'AND A.RegDate < '''+@strToDate+''' '+
		'AND A.AdGbn=0 '+
		'And A.AdId not in (Select AdId From RecChargeDetail with (Nolock) Where PrnAmtOk = ''1'' AND PartAmount <> 0) ' +@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), A.RegDate, 120)  '+
		'UNION all  '+

		--구매물품 신용카드 통계(BC1, BS1)
		'SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		''''' as C1, '''' as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4,COUNT(A.AdId)as BC1, SUM(C.PrnAmt2)as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4  '+
		'FROM vi_GoodsMain A, RecCharge B, RecChargeDetail C ' + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=1 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''2'' AND C.PartAmount <> 0 '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		'UNION all  '+
		--구매물품 휴대폰 통계(BC2, BS2)
		' SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		' '''' as C1,'''' as S1,'''' as C2, '''' as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4,'''' as BC1, '''' as BS1,COUNT(A.AdId)as BC2, SUM(C.PrnAmt2) as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4   '+
		'FROM vi_GoodsMain A, RecCharge B, RecChargeDetail C ' + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=1 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''3'' AND C.PartAmount <> 0 '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		' UNION all  '+
		--구매물품 온라인 통계(BC3, BS3)
		' SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,'''' as C3, '''' as S3,'''' as C4,'''' as S4,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,COUNT(A.AdId)as BC3, SUM(C.PrnAmt2) as BS3,'''' as BC4, '''' as BS4   '+
		'FROM vi_GoodsMain A, RecCharge B, RecChargeDetail C ' + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=1 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''1'' AND C.PartAmount <> 0 '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		'UNION all  '+
		--구매물품 무료매물 통계(BC4, BS4)
		'SELECT CONVERT(varchar(10), A.RegDate, 120) as RecDate, ''0'' As ChargeKind,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,'''' as C4, '''' as S4 ,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,COUNT(A.AdId)as BC4, 0 as BS4  '+
		' FROM vi_GoodsMain A with (Nolock) ' + 
		'WHERE  A.RegDate > '''+@strFrDate+''' '+
		'AND A.RegDate < '''+@strToDate+''' '+
		'AND A.AdGbn=1 '+
		'And A.AdId not in (Select AdId From RecChargeDetail with (Nolock) Where PrnAmtOk = ''1'' AND PartAmount <> 0) ' +@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), A.RegDate, 120)  '+
		
		'  )AS Q Group by RecDate Order By RecDate DESC '
	PRINT(@strQuery)
	EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procProdDaySettle]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[procProdDaySettle]
(
	@strFrDate	varchar(10)	-- 날짜 검색조건(부터)
,	@strToDate	varchar(10)	-- 날짜 검색조건(까지)
,	@strPartner   	varchar(10)	-- 제휴사구분
, 	@strKind      	char(1)         	-- 구분(상품등록:1/안전거래:2)
)
AS
	SET @strToDate = DateAdd(d,1,@strToDate)

--제휴사 구분
 	 DECLARE @SqlPartner varchar(200)
	IF @strKind='1' 
		BEGIN
		IF @StrPartner =''
			BEGIN			
				SET 	@SqlPartner= 'AND A.PartnerCode<>0 '
			END
		ELSE  
			BEGIN
				SET 	@SqlPartner= 'AND A.PartnerCode='+@StrPartner +''
			END
		END
	ELSE
   		BEGIN
		IF @StrPartner =''
			BEGIN			
				SET 	@SqlPartner= 'AND B.PartnerCode<>0 '
			END
		ELSE  
			BEGIN
				SET 	@SqlPartner= 'AND B.PartnerCode='+@StrPartner +''
			END
		END
		
		
DECLARE @strQuery varchar(3500)
SET @strQuery = 
	Case   When  @strKind='1' then
		'SELECT Q.RecDate,' + 
		'Sum(Q.C1) as Cnt1,IsNull(Sum(Q.S1),0)as Amt1,Sum(Q.C2)as Cnt2,IsNull(Sum(Q.S2),0)as Amt2,Sum(Q.C3)as Cnt3,IsNull(Sum(Q.S3),0)as Amt3 '+
		'FROM(  '+ 
		
		'SELECT CONVERT(varchar(10), C.RecDate, 120) as RecDate,  '+
		'COUNT(A.AdId)as C1, SUM(B.PartAmount)as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3   '+
		'FROM vi_GoodsMain A, RecChargeDetail B, RecCharge C  ' + 
		'WHERE A.AdId=B.AdId And B.GrpSerial=C.GrpSerial   '+
		'AND C.RecDate >'''+@strFrDate+'''  '+
		'AND C.RecDate <'''+@strToDate+''' '+
		'AND B.PrnAmtOk=''1'' AND C.RecStatus=''1''  '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), C.RecDate, 120) '+
		
		'UNION all  '+
		
		' SELECT CONVERT(varchar(10), C.RecDate, 120) as RecDate,  '+
		' '''' as C1,'''' as S1,COUNT(A.AdId)as C2, SUM(B.PartAmount) as S2,'''' as C3,'''' as S3   '+
		'FROM vi_GoodsMain A, RecChargeDetail B, RecCharge C  ' +
		'WHERE A.AdId=B.AdId And B.GrpSerial=C.GrpSerial   '+
		'AND C.RecDate >'''+@strFrDate+'''  '+
		'AND C.RecDate <'''+@strToDate+''' '+
		' AND B.PrnAmtOk=''1'' AND C.RecStatus=''1''  AND B.SettleFlag=''Y''  '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), C.RecDate, 120) '+ 
		
		'UNION all  '+
		
		'SELECT CONVERT(varchar(10), C.RecDate, 120) as RecDate,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,COUNT(A.AdId)as C3, SUM(B.PartAmount) as S3   '+
		'FROM vi_GoodsMain A, RecChargeDetail B, RecCharge C  ' + 
		'WHERE A.AdId=B.AdId And B.GrpSerial=C.GrpSerial   '+
		'AND C.RecDate >'''+@strFrDate+'''  '+
		'AND C.RecDate <'''+@strToDate+''' '+
		' AND B.PrnAmtOk=''1'' AND C.RecStatus=''1'' AND B.SettleFlag=''N''  '+@SqlPartner +' '+
		'GROUP BY  CONVERT(varchar(10), C.RecDate, 120) '+
		'  )AS Q Group by RecDate Order By RecDate DESC '
	
	ELSE
		'SELECT Q.RecDate,Sum(Q.C1) as Cnt1,IsNull(Sum(Q.S1),0)as Amt1,Sum(Q.C2)as Cnt2,IsNull(Sum(Q.S2),0)as Amt2,Sum(Q.C3)as Cnt3, '+
		'IsNull(Sum(Q.S3),0)as Amt3,Sum(Q.C4)as Cnt4,IsNull(Sum(Q.S4),0)as Amt4 '+
		'FROM(  '+ 
		'SELECT CONVERT(varchar(10),  B.RemitEnDate, 120) as RecDate,  '+
		'COUNT(A.AdId)as C1, SUM(B.WishAmt)as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4  '+
		'FROM vi_GoodsMain A, Sale_BuyerInfo B ' + 
		'WHERE  A.AdId=B.AdId  '+
		'AND B.RemitEnDate >'''+@strFrDate+'''  '+
		'AND B.RemitEnDate <'''+@strToDate+''' '+
		'AND B.ReceiveChk=''1'' AND B.RemitChk=''2'' AND B.LocalSite<>''0''  '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RemitEnDate, 120)  '+
		'UNION all  '+
		' SELECT CONVERT(varchar(10),  B.RemitEnDate, 120) as RecDate,  '+
		' '''' as C1,'''' as S1,COUNT(A.AdId)as C2, SUM(B.PartAmount) as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4  '+
		' FROM vi_GoodsMain A, Sale_BuyerInfo B ' + 
		'WHERE  A.AdId=B.AdId  '+
		'AND B.RemitEnDate >'''+@strFrDate+''' '+
		'AND B.RemitEnDate <'''+@strToDate+''' '+
		'AND B.ReceiveChk=''1'' AND B.RemitChk=''2'' AND B.LocalSite<>''0'' '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RemitEnDate, 120) '+ 
		'UNION all  '+
		'  SELECT CONVERT(varchar(10), B.RemitEnDate, 120) as RecDate,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,COUNT(A.AdId)as C3, SUM(B.PartAmount) as S3,'''' as C4,'''' as S4  '+
		' FROM vi_GoodsMain A, Sale_BuyerInfo B ' + 
		'WHERE  A.AdId=B.AdId  '+
		'AND B.RemitEnDate >'''+@strFrDate+''' '+
		'AND B.RemitEnDate <'''+@strToDate+''' '+
		'AND B.ReceiveChk=''1'' AND B.RemitChk=''2'' AND B.LocalSite<>''0'' AND B.SettleFlag=''Y''  '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RemitEnDate, 120) '+ 
		'UNION all  '+
		'SELECT CONVERT(varchar(10), B.RemitEnDate, 120) as RecDate,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,COUNT(A.AdId)as C4, SUM(B.PartAmount) as S4  '+
		' FROM vi_GoodsMain A, Sale_BuyerInfo B ' + 
		'WHERE  A.AdId=B.AdId  '+
		'AND B.RemitEnDate >'''+@strFrDate+''' '+
		'AND B.RemitEnDate <'''+@strToDate+''' '+
		'AND B.ReceiveChk=''1'' AND B.RemitChk=''2'' AND B.LocalSite<>''0'' AND B.SettleFlag=''N'' '+@SqlPartner+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RemitEnDate, 120) '+ 
		'  )AS Q Group by RecDate Order By RecDate Desc '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procProdLocalDayCharge]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[procProdLocalDayCharge]
(
	@strFrDate	varchar(10)	-- 날짜 검색조건(부터)
,	@strToDate	varchar(10)	-- 날짜 검색조건(까지)
,	@strLocal             char(2)		-- 지점구분
)
AS

	SET @strToDate = DateAdd(d,1,@strToDate)
	
	--지역 구분
	DECLARE @SqlLocal varchar(200)
	DECLARE @SqlLocalDB varchar(100)
	
	IF @StrLocal =''
		BEGIN			
			SET 	@SqlLocal= ' AND A.LocalSite <> 0 '
			SET 	@SqlLocalDB= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlLocal= ' AND A.LocalSite = ' + CONVERT(varchar(10),@StrLocal)
			SET 	@SqlLocalDB= ' '
		END
 
	DECLARE @strQuery varchar(8000)
	SET @strQuery =
		'SELECT Q.RecDate,' + 
		'Sum(Q.C1) as Cnt1,IsNull(Sum(Q.S1),0)as Amt1,Sum(Q.C2)as Cnt2,IsNull(Sum(Q.S2),0)as Amt2,Sum(Q.C3)as Cnt3, '+
		'IsNull(Sum(Q.S3),0)as Amt3,Sum(Q.C4)as Cnt4,IsNull(Sum(Q.S4),0)as Amt4, '+
		'Sum(Q.BC1) as BCnt1,IsNull(Sum(Q.BS1),0)as BAmt1,Sum(Q.BC2)as BCnt2,IsNull(Sum(Q.BS2),0)as BAmt2,Sum(Q.BC3)as BCnt3, '+
		'IsNull(Sum(Q.BS3),0)as BAmt3,Sum(Q.BC4)as BCnt4,IsNull(Sum(Q.BS4),0)as BAmt4  '+
		'FROM(  '+ 
		--판매물품 신용카드 통계(C1, S1)
		'SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		'COUNT(A.AdId)as C1, SUM(C.PrnAmt2)as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4   '+
		'FROM GoodsMain A, RecCharge B, RecChargeDetail C ' + @SqlLocalDB + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=0 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''2'' '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		'UNION all  '+
		--판매물품 휴대폰 통계(C2, S2)
		' SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		' '''' as C1,'''' as S1,COUNT(A.AdId)as C2, SUM(C.PrnAmt2) as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4   '+
		'FROM GoodsMain A, RecCharge B, RecChargeDetail C ' + @SqlLocalDB + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=0 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''3'' '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		' UNION all  '+
		--판매물품 온라인 통계(C3, S3)
		' SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,COUNT(A.AdId)as C3, SUM(C.PrnAmt2) as S3,'''' as C4,'''' as S4,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4   '+
		'FROM GoodsMain A, RecCharge B, RecChargeDetail C ' + @SqlLocalDB + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=0 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''1'' '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		'UNION all  '+
		--판매물품 무료매물 통계(C4, S4)
		'SELECT CONVERT(varchar(10), A.RegDate, 120) as RecDate, ''0'' As ChargeKind,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,COUNT(A.AdId)as C4, 0 as S4 ,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4   '+
		' FROM GoodsMain A with (Nolock) ' + @SqlLocalDB + 
		'WHERE  '+
		' A.RegDate > '''+@strFrDate+''' '+
		'AND A.RegDate < '''+@strToDate+''' '+
		'AND A.AdGbn=0 '+
		'And A.AdId not in (Select AdId From RecChargeDetail with (Nolock) Where PrnAmtOk = ''1'') ' +@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), A.RegDate, 120)  '+
		'UNION all  '+

		--구매물품 신용카드 통계(BC1, BS1)
		'SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		''''' as C1, '''' as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4,COUNT(A.AdId)as BC1, SUM(C.PrnAmt2)as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4  '+
		'FROM GoodsMain A, RecCharge B, RecChargeDetail C ' + @SqlLocalDB + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=1 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''2'' '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		'UNION all  '+
		--구매물품 휴대폰 통계(BC2, BS2)
		' SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		' '''' as C1,'''' as S1,'''' as C2, '''' as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4,'''' as BC1, '''' as BS1,COUNT(A.AdId)as BC2, SUM(C.PrnAmt2) as BS2,'''' as BC3, '''' as BS3,'''' as BC4, '''' as BS4   '+
		'FROM GoodsMain A, RecCharge B, RecChargeDetail C ' + @SqlLocalDB + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=1 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''3'' '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		' UNION all  '+
		--구매물품 온라인 통계(BC3, BS3)
		' SELECT CONVERT(varchar(10), B.RecDate, 120) as RecDate, B.ChargeKind,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,'''' as C3, '''' as S3,'''' as C4,'''' as S4,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,COUNT(A.AdId)as BC3, SUM(C.PrnAmt2) as BS3,'''' as BC4, '''' as BS4   '+
		'FROM GoodsMain A, RecCharge B, RecChargeDetail C ' + @SqlLocalDB + 
		'WHERE  C.GrpSerial=B.GrpSerial AND A.AdId=C.AdId  '+
		'AND B.RecDate> '''+@strFrDate+''' '+
		'AND B.RecDate< '''+@strToDate+''' '+
		'AND A.AdGbn=1 '+
		'AND C.PrnAmtOk=''1'' AND B.RecStatus=''1''  AND B.ChargeKind=''1'' '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RecDate, 120), B.ChargeKind  '+

		'UNION all  '+
		--구매물품 무료매물 통계(BC4, BS4)
		'SELECT CONVERT(varchar(10), A.RegDate, 120) as RecDate, ''0'' As ChargeKind,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,'''' as C4, '''' as S4 ,'''' as BC1, '''' as BS1,'''' as BC2, '''' as BS2,'''' as BC3, '''' as BS3,COUNT(A.AdId)as BC4, 0 as BS4  '+
		' FROM GoodsMain A with (Nolock) ' + @SqlLocalDB + 
		'WHERE  A.RegDate > '''+@strFrDate+''' '+
		'AND A.RegDate < '''+@strToDate+''' '+
		'AND A.AdGbn=1 '+
		'And A.AdId not in (Select AdId From RecChargeDetail with (Nolock) Where PrnAmtOk = ''1'') ' +@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), A.RegDate, 120)  '+
		
		'  )AS Q Group by RecDate Order By RecDate DESC '
	PRINT(@strQuery)
	EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procProdLocalDaySettle]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[procProdLocalDaySettle]
(
	@strFrDate		varchar(10)	-- 날짜 검색조건(부터)
,	@strToDate		varchar(10)	-- 날짜 검색조건(까지)
,	@strLocal              	Char(2)		-- 지역구분
, @strKind                Char(1)                 -- 구분(상품등록:1/안전거래:2)
)
AS
	SET @strToDate = DateAdd(d,1,@strToDate)

--지역 구분
	DECLARE @SqlLocal varchar(200)
	DECLARE @SqlLocalDB varchar(100)
	
	IF @StrLocal =''
		BEGIN			
			SET 	@SqlLocal= ' AND A.LocalSite <> 0 '
			SET 	@SqlLocalDB= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlLocal= ' AND A.LocalSite = ' + CONVERT(varchar(10),@StrLocal)
			SET 	@SqlLocalDB= ' '
		END
DECLARE @strQuery varchar(3500)
SET @strQuery = 
	Case   When  @strKind='1' then
		'SELECT Q.RecDate,' + 
		'Sum(Q.C1) as Cnt1,IsNull(Sum(Q.S1),0)as Amt1,Sum(Q.C2)as Cnt2,IsNull(Sum(Q.S2),0)as Amt2,Sum(Q.C3)as Cnt3,IsNull(Sum(Q.S3),0)as Amt3 '+
		'FROM(  '+ 
		
		'SELECT CONVERT(varchar(10), C.RecDate, 120) as RecDate,  '+
		'COUNT(A.AdId)as C1, SUM(B.PartAmount)as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3   '+
		'FROM GoodsMain A, RecChargeDetail B, RecCharge C  ' + @SqlLocalDB + 
		'WHERE A.AdId=B.AdId And B.GrpSerial=C.GrpSerial   '+
		'AND C.RecDate >'''+@strFrDate+'''  '+
		'AND C.RecDate <'''+@strToDate+''' '+
		'AND B.PrnAmtOk=''1'' AND C.RecStatus=''1''  '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), C.RecDate, 120) '+
		
		'UNION all  '+
		
		' SELECT CONVERT(varchar(10), C.RecDate, 120) as RecDate,  '+
		' '''' as C1,'''' as S1,COUNT(A.AdId)as C2, SUM(B.PartAmount) as S2,'''' as C3,'''' as S3   '+
		'FROM GoodsMain A, RecChargeDetail B, RecCharge C  ' + @SqlLocalDB + 
		'WHERE A.AdId=B.AdId And B.GrpSerial=C.GrpSerial   '+
		'AND C.RecDate >'''+@strFrDate+'''  '+
		'AND C.RecDate <'''+@strToDate+''' '+
		' AND B.PrnAmtOk=''1'' AND C.RecStatus=''1''  AND B.SettleFlag=''Y''  '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), C.RecDate, 120) '+ 
		
		'UNION all  '+
		
		'SELECT CONVERT(varchar(10), C.RecDate, 120) as RecDate,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,COUNT(A.AdId)as C3, SUM(B.PartAmount) as S3   '+
		'FROM GoodsMain A, RecChargeDetail B, RecCharge C  ' + @SqlLocalDB + 
		'WHERE A.AdId=B.AdId And B.GrpSerial=C.GrpSerial   '+
		'AND C.RecDate >'''+@strFrDate+'''  '+
		'AND C.RecDate <'''+@strToDate+''' '+
		' AND B.PrnAmtOk=''1'' AND C.RecStatus=''1'' AND B.SettleFlag=''N''  '+@SqlLocal +' '+
		'GROUP BY  CONVERT(varchar(10), C.RecDate, 120) '+
		'  )AS Q Group by RecDate Order By RecDate DESC '
	
	ELSE
		'SELECT Q.RecDate,Sum(Q.C1) as Cnt1,IsNull(Sum(Q.S1),0)as Amt1,Sum(Q.C2)as Cnt2,IsNull(Sum(Q.S2),0)as Amt2,Sum(Q.C3)as Cnt3, '+
		'IsNull(Sum(Q.S3),0)as Amt3,Sum(Q.C4)as Cnt4,IsNull(Sum(Q.S4),0)as Amt4 '+
		'FROM(  '+ 
		'SELECT CONVERT(varchar(10),  B.RemitEnDate, 120) as RecDate,  '+
		'COUNT(A.AdId)as C1, SUM(B.WishAmt)as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4  '+
		'FROM GoodsMain A, Sale_BuyerInfo B ' + @SqlLocalDB + 
		'WHERE  A.AdId=B.AdId  '+
		'AND B.RemitEnDate >'''+@strFrDate+'''  '+
		'AND B.RemitEnDate <'''+@strToDate+''' '+
		'AND B.ReceiveChk=''1'' AND B.RemitChk=''2'' AND B.LocalSite<>''0''  '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RemitEnDate, 120)  '+
		'UNION all  '+
		' SELECT CONVERT(varchar(10),  B.RemitEnDate, 120) as RecDate,  '+
		' '''' as C1,'''' as S1,COUNT(A.AdId)as C2, SUM(B.PartAmount) as S2,'''' as C3,'''' as S3,'''' as C4,'''' as S4  '+
		' FROM GoodsMain A, Sale_BuyerInfo B ' + @SqlLocalDB + 
		'WHERE  A.AdId=B.AdId  '+
		'AND B.RemitEnDate >'''+@strFrDate+''' '+
		'AND B.RemitEnDate <'''+@strToDate+''' '+
		'AND B.ReceiveChk=''1'' AND B.RemitChk=''2'' AND B.LocalSite<>''0'' '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RemitEnDate, 120) '+ 
		'UNION all  '+
		'  SELECT CONVERT(varchar(10), B.RemitEnDate, 120) as RecDate,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,COUNT(A.AdId)as C3, SUM(B.PartAmount) as S3,'''' as C4,'''' as S4  '+
		' FROM GoodsMain A, Sale_BuyerInfo B ' + @SqlLocalDB + 
		'WHERE  A.AdId=B.AdId  '+
		'AND B.RemitEnDate >'''+@strFrDate+''' '+
		'AND B.RemitEnDate <'''+@strToDate+''' '+
		'AND B.ReceiveChk=''1'' AND B.RemitChk=''2'' AND B.LocalSite<>''0'' AND B.SettleFlag=''Y''  '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RemitEnDate, 120) '+ 
		'UNION all  '+
		'SELECT CONVERT(varchar(10), B.RemitEnDate, 120) as RecDate,  '+
		'  '''' as C1,'''' as S1,'''' as C2,'''' as S2,'''' as C3,'''' as S3,COUNT(A.AdId)as C4, SUM(B.PartAmount) as S4  '+
		' FROM GoodsMain A, Sale_BuyerInfo B ' + @SqlLocalDB + 
		'WHERE  A.AdId=B.AdId  '+
		'AND B.RemitEnDate >'''+@strFrDate+''' '+
		'AND B.RemitEnDate <'''+@strToDate+''' '+
		'AND B.ReceiveChk=''1'' AND B.RemitChk=''2'' AND B.LocalSite<>''0'' AND B.SettleFlag=''N'' '+@SqlLocal+'  '+
		'GROUP BY  CONVERT(varchar(10), B.RemitEnDate, 120) '+ 
		'  )AS Q Group by RecDate Order By RecDate Desc '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcProdOptList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcProdOptList]
(
	@Page			int
,	@PageSize		int
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
, @strCboOpt				varchar(10) 	-- 옵션 종류
)
AS
-- 전체 검색쿼리 시작

--1.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.PrnStDate,120) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.PrnStDate,120) <= ''' +@StrLastDt+ ''''
		END

--2. 옵션 종류 검색
	DECLARE @SqlOpt varchar(200)
	SET @SqlOpt =	
	CASE @strCboOpt
		WHEN ''	THEN ''
		WHEN '1' THEN ' AND OptPhoto > 0 '
		WHEN '2' THEN ' AND OptReCom > 0 '
		WHEN '3' THEN ' AND OptUrgent > 0 '
		WHEN '4' THEN ' AND OptMain > 0 '
		WHEN '5' THEN ' AND OptHot > 0 '
		WHEN '6' THEN ' AND OptPre > 0 '
		WHEN '7' THEN ' AND OptSync > 0 '
		WHEN '8' THEN ' AND OptKind like ''%3%'' '
		WHEN '9' THEN ' AND OptKind like ''%2%'' '
		WHEN '10' THEN ' AND OptKind like ''%1%'' '
		WHEN '11' THEN ' AND OptKind like ''%4%'' '
		WHEN '12' THEN ' AND OptKind like ''%6%'' '
		WHEN '13' THEN ' AND OptKind like ''%7%'' '
		WHEN '14' THEN ' AND EscrowYN = ''Y'' '
		WHEN '15' THEN ' AND SpecFlag = ''4'' '
		WHEN '16' THEN ' AND Keyword = ''1'' '
		ELSE ''
	END



--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='UserName'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='UserID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='AdId'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.AdId Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END

--자료구분(삽니다/팝니다)
	DECLARE @SqlAdGbn	varchar(20)
	IF @StrDivInfo ='SELL'
		SET @SqlAdGbn = ' And AdGbn=0 '
	ELSE
		SET @SqlAdGbn = ' And AdGbn=1 '

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlOpt + @SqlAdGbn
		END
-- 키워드 검색쿼리 끝


DECLARE @strQuery nvarchar(2000)
SET @strQuery =
			'SELECT TOP 1 COUNT(G.Adid) FROM GoodsMain G  ' +
			'WHERE G.MagGbn=1  ' + @SqlAll + ';  ' +
			'SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,C.CodeNm1,G.UserName, ' +
			'  OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, EscrowYN, Keyword, ' +
			'  G.PrnAmtOK, G.StateChk, G.SpecFlag, G.PrnCnt ' +
			'  FROM GoodsMain G, ' +
			'	      (Select Code1, CodeNm1 From CatCode Group By Code1, CodeNm1) C ' +
			'  WHERE G.Code1=C.Code1 And G.MagGbn=1  ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
		

--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcRecommendList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcRecommendList]
(
       	@GetCount        	varchar(10)
,      	@StrLocal	varchar(2)        -- 지역코드
,	@AdultCode	char(1) 	          
)
AS

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'	
		SET @SqlLocalGoods = '' 
	ELSE		
		SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
				          '(Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ') ' +
				          ' OR B.ZipMain = ''전국'' ) '

--AdultCode
	DECLARE @SqlAdultCode varchar(100)
	IF @AdultCode = '0' 	
		SET @SqlAdultCode =  ' AND (B.Code2 <> 2415) '
	ELSE
		 SET @SqlAdultCode=''

	DECLARE @strSelect varchar(300)
	DECLARE @strOrder varchar(100)
	DECLARE @strQuery varchar(3000)

	IF @GetCount = '0'
		BEGIN
			SET @strSelect = 'SELECT COUNT(B.AdId) '
			SET @strOrder = ''
		END
	ELSE
		BEGIN
			SET @strSelect = 'SELECT TOP ' + @GetCount + ' B.Adid, S.BrandNmDt, S.WishAmt, S.GoodsQt, S.UseGbn, B.ZipMain, B.ZipSub, P.PicImage '
			SET @strOrder = ' ORDER BY B.AdId DESC '
		END

	SET @strQuery =  @strSelect +
					' FROM GoodsMain B, GoodsSubSale S, GoodsPic P ' + 
					' WHERE B.AdId = S.AdId ' +
					' AND B.AdId=P.AdId ' +
					' AND P.PicIdx=5 ' +
					' AND B.OptRecom=1 ' +
					' AND B.PrnAmtOk=''1'' AND B.PrnEnDate >= GETDATE() ' +
					' AND B.StateChk=''1'' AND B.DelFlag=''0'' AND B.SaleOkFlag=''0'' ' + @SqlLocalGoods +  @SqlAdultCode +
			@strOrder

--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcReg]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 등록상품 내역 검색 프로시저
	제작자	:
	제작일	:
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROC [dbo].[ProcReg]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@chkChargeKind		char(1)		-- 포인트결제 제외
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@strDateFlag		char(1)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboCategory		varchar(10)	--카테고리
,	@StrCboOption		varchar(10)	--옵션 검색조건(베스트/핫/프리미엄등등...)
,	@StrCboPrnCnt		varchar(10)	--옵션기간 검색조건(10/20/30)
,	@StrChkOptGbn		varchar(10)	--보너스 옵션 검색 구분
,	@StrCboKeyWord		varchar(10)	--키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	--키워드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
,	@strPrnAmtOk		char(1)		--결제여부
,	@strPLineKeyNo		char(1)		--인터넷/신문등록 구분
,	@strEscrowYN		char(1)		--안전/일반 구분
,	@strOrderFlag		char(1)		--정렬 순서
,	@strDelFlag		char(1)		--삭제 구분
)
AS
--결제방법
	DECLARE @SqlChkChargeKind 	varchar(100)
	DECLARE @SqlChargeKind 	varchar(200)
	
	IF @chkChargeKind = '6'
		BEGIN
			SET	@SqlChkChargeKind = ' AND A.ChargeKind <> ''6'' AND (A.PrnAmt2>0 OR (A.PrnAmt>0 AND A.PrnAmt2 IS NULL)) '
		END
	ELSE
		BEGIN
			SET	@SqlChkChargeKind = ''
		END

	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= '' + @SqlChkChargeKind
		END
	ELSE IF @StrChargeKind ='0'
		BEGIN
			SET 	@SqlChargeKind= 'AND A.ChargeKind IS NULL ' + @SqlChkChargeKind
		END
	ELSE  
		BEGIN
			IF @StrChargeKind <> '6'
				SET 	@SqlChargeKind= 'AND A.ChargeKind=' + @strChargeKind  + '' + @SqlChkChargeKind 
			ELSE
				SET 	@SqlChargeKind= 'AND A.ChargeKind=' + @strChargeKind  + ''
		END

--기간
	DECLARE @SqlSMakDt_1    varchar(100)
	DECLARE @SqlEMakDt_1	varchar(100)
	DECLARE @SqlSMakDt_2	varchar(100)
	DECLARE @SqlEMakDt_2	varchar(100)
       	SET	@SqlSMakDt_1= ' '
        	SET	@SqlEMakDt_1= ' '
        	SET	@SqlSMakDt_2= ' '
        	SET	@SqlEMakDt_2= ' '

	DECLARE @SqlUserTable	varchar(200)
	DECLARE @SqlUserJoin	varchar(100)
	DECLARE @SqlUserReg	varchar(100)
       	SET	@SqlUserTable=' '
        	SET     	@SqlUserJoin=' '
        	SET     	@SqlUserReg=' '''' '

	IF @strDateFlag = '1'
		BEGIN
			IF @StrStartDt <> ''
			        SET 	@SqlSMakDt_1= ' AND G.RegDate >= ''' + CONVERT(CHAR(10),CONVERT(DateTime,@strStartDt),120) +''''
			IF @StrLastDt <> ''
			        SET 	@SqlEMakDt_1= ' AND G.RegDate <= ''' + CONVERT(CHAR(10),CONVERT(DateTime,@StrLastDt) + 1,120) + ''''
		END
	ELSE IF @strDateFlag = '2'
		BEGIN
			IF @StrStartDt <> ''
			        SET 	@SqlSMakDt_2= ' AND A.RecDate >= ''' +@strStartDt +''''
			IF @StrLastDt <> ''
			        SET 	@SqlEMakDt_2= ' AND A.RecDate <= ''' +@StrLastDt+ ''''
		END
	ELSE IF @strDateFlag = '3'
		BEGIN
			SET	@SqlUserTable= ' , FINDDB2.MEMBER.DBO.MM_MEMBER_VI U '
			SET	@SqlUserJoin=' AND G.UserID=U.UserID '
			SET	@SqlUserReg=' ISNULL(U.JOIN_DT,'''') '

			IF @StrStartDt <> ''
			        SET 	@SqlSMakDt_1= ' AND U.JOIN_DT >= ''' + LEFT(@strStartDt,4) + '-' + SUBSTRING(@strStartDt,5,2) + '-' + RIGHT(@strStartDt,2) +''''
			IF @StrLastDt <> ''
			        SET 	@SqlEMakDt_1= ' AND U.JOIN_DT <= ''' + LEFT(@StrLastDt,4) + '-' + SUBSTRING(@StrLastDt,5,2) + '-' + RIGHT(@StrLastDt,2) +''''
		END

--카테고리
	DECLARE @SqlCategory    varchar(100)
	SET	@SqlCategory=''

	IF @StrCboCategory <> ''
	        SET 	@SqlCategory= ' AND G.Code' + CONVERT(CHAR(1),LEN(@StrCboCategory)/2) + ' = ' + @StrCboCategory + ' '

--옵션
	DECLARE @SqlOption      varchar(200)
	SET	@SqlOption=''

	IF @StrChkOptGbn = '1'
	        BEGIN
		        IF @StrCboOption='베스트'		SET 	@SqlOption= ' AND G.OptPhoto=1 '
		        ELSE IF @StrCboOption='핫'	        	SET 	@SqlOption= ' AND G.OptHot=1 '
		        ELSE IF @StrCboOption='프리미엄'        	SET 	@SqlOption= ' AND G.OptPre=1 AND G.OptPhoto=0 '
		        ELSE IF @StrCboOption='포토갤러리'	SET 	@SqlOption= ' AND G.OptKind LIKE ''%7%'' AND G.OptPhoto=0 AND G.OptHot=0 '
		        ELSE IF @StrCboOption='제목볼드'        	SET 	@SqlOption= ' AND G.OptKind LIKE ''%1%'' '
		        ELSE IF @StrCboOption='형광배경'        	SET 	@SqlOption= ' AND G.OptKind LIKE ''%3%'' '
		        ELSE IF @StrCboOption='깜박임'	SET 	@SqlOption= ' AND G.OptKind LIKE ''%2%'' '
		        ELSE IF @StrCboOption='쇼핑몰주소'	SET 	@SqlOption= ' AND G.OptKind LIKE ''%6%'' '
		        ELSE IF @StrCboOption='안전거래'        	SET 	@SqlOption= ' AND G.EscrowYN=''Y'' '
		        ELSE IF @StrCboOption='상점형거래'	SET 	@SqlOption= ' AND G.SpecFlag=''4'' '
		        ELSE IF @StrCboOption='키워드'	SET 	@SqlOption= ' AND G.Keyword=''1'' '
	        END
	ELSE
	        BEGIN
		        IF @StrCboOption='베스트'		SET 	@SqlOption= ' AND G.OptPhoto=1 '
		        ELSE IF @StrCboOption='핫'	        	SET 	@SqlOption= ' AND G.OptHot=1 '
		        ELSE IF @StrCboOption='프리미엄'        	SET 	@SqlOption= ' AND G.OptPre=1 '
		        ELSE IF @StrCboOption='포토갤러리'	SET 	@SqlOption= ' AND G.OptKind LIKE ''%7%'' '
		        ELSE IF @StrCboOption='제목볼드'        	SET 	@SqlOption= ' AND G.OptKind LIKE ''%1%'' '
		        ELSE IF @StrCboOption='형광배경'        	SET 	@SqlOption= ' AND G.OptKind LIKE ''%3%'' '
		        ELSE IF @StrCboOption='깜박임'	SET 	@SqlOption= ' AND G.OptKind LIKE ''%2%'' '
		        ELSE IF @StrCboOption='쇼핑몰주소'	SET 	@SqlOption= ' AND G.OptKind LIKE ''%6%'' '
		        ELSE IF @StrCboOption='안전거래'        	SET 	@SqlOption= ' AND G.EscrowYN=''Y'' '
		        ELSE IF @StrCboOption='상점형거래'	SET 	@SqlOption= ' AND G.SpecFlag=''4'' '
		        ELSE IF @StrCboOption='키워드'	SET 	@SqlOption= ' AND G.Keyword=''1'' '
	        END

--옵션기간
	DECLARE @SqlPrnCnt      varchar(200)
	SET	@SqlPrnCnt=''

	IF @StrCboPrnCnt='10'
	        SET 	@SqlPrnCnt= ' AND G.PrnCnt <= 10 '
	ELSE IF @StrCboPrnCnt='20'
	        SET 	@SqlPrnCnt= ' AND G.PrnCnt BETWEEN 11 AND 20 '
	ELSE IF @StrCboPrnCnt='30'
	        SET 	@SqlPrnCnt= ' AND G.PrnCnt >= 21 '

--키워드
	DECLARE @SqlKeyWord_1   varchar(200)
	DECLARE @SqlKeyWord_2   varchar(200)
	SET	@SqlKeyWord_1=''
	SET	@SqlKeyWord_2=''

	IF @StrCboKeyWord ='신청자명'
        	SET 	@SqlKeyWord_1= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='입금자명'
		SET 	@SqlKeyWord_2= 'AND A.RecNm Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='등록자ID'
		SET 	@SqlKeyWord_1= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='전화번호'
		SET 	@SqlKeyWord_1= 'AND G.HPhone Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='접수번호' AND @strTxtKeyWord <> ''
		SET 	@SqlKeyWord_1= 'AND G.AdId = ' + @strTxtKeyWord+ ' '
	ELSE IF @StrCboKeyWord='계좌번호' AND @strTxtKeyWord <> ''
		SET 	@SqlKeyWord_2= 'AND A.AccountNum = ''' + @strTxtKeyWord+ ''' '

 --개인/전문
       	DECLARE @SqlSpecFlag    varchar(200)
        	SET	@SqlSpecFlag= ''

	IF @strSpecFlag =''
		SET 	@SqlSpecFlag= ''
        	ELSE IF @strSpecFlag = '0'
		SET 	@SqlSpecFlag= ' AND ( G.SpecFlag IS NULL OR G.SpecFlag IN ( ''0'', '''' ) ) '
	ELSE
		SET 	@SqlSpecFlag= ' AND G.SpecFlag='+@strSpecFlag +' '


--인터넷/신문
	DECLARE @SqlPLineKeyNo  varchar(200)
	IF @strPLineKeyNo = '0'
                SET	@SqlPLineKeyNo= ' AND (G.PLineKeyNo IS NULL OR G.PLineKeyNo = '''') '
	ELSE IF  @strPLineKeyNo = '1'
		SET	@SqlPLineKeyNo= ' AND G.PLineKeyNo <> '''' '
	ELSE
		SET	@SqlPLineKeyNo= ''

 --결제여부
	DECLARE @SqlPrnAmtOk    varchar(200)

	IF @strPrnAmtOk = ''
                	SET 	@SqlPrnAmtOk= ''
        	ELSE
                	SET 	@SqlPrnAmtOk= ' AND A.PrnAmtOk ='+@strPrnAmtOk


 --안전/일반 구분
       	 DECLARE @SqlEscrowYN    varchar(200)

	IF @strEscrowYN = ''
               	SET 	@SqlEscrowYN= ''
        	ELSE
                	SET 	@SqlEscrowYN= ' AND G.EscrowYN = '''+@strEscrowYN+''''

 --삭제 구분
        	DECLARE @SqlDelFlag     varchar(200)
        	SET     @SqlDelFlag = ''
	
	IF @strDelFlag <> ''
                	SET 	@SqlDelFlag = ' AND G.DelFlag = '''+@strDelFlag+''''

 --정렬순서 구분
        	DECLARE @SqlOrderFlag   varchar(200)

	IF @strOrderFlag = '2'
                	SET 	@SqlOrderFlag= ' ORDER BY A.GrpSerial DESC, B.AdId DESC '
        	ELSE
                	SET 	@SqlOrderFlag= ' ORDER BY B.AdId DESC, A.GrpSerial DESC '

--판매물품/구매물품
        	DECLARE @Table          varchar(20)

        	IF @StrDivInfo ='SELL'
        		SET @Table = ' GoodsSubSale '
        	ELSE
        		SET @Table = ' GoodsSubBuy '

--전체검색
	DECLARE @SqlAll_1       varchar(500)
	DECLARE @SqlAll_2       varchar(500)
	SET	@SqlAll_1 = @SqlSpecFlag + @SqlPLineKeyNo + @SqlEscrowYN + @SqlDelFlag + @SqlSMakDt_1 + @SqlEMakDt_1 + @SqlKeyWord_1 + @SqlCategory + @SqlOption + @SqlPrnCnt
	SET	@SqlAll_2 = @SqlChargeKind + @SqlPrnAmtOk + @SqlSMakDt_2 + @SqlEMakDt_2 + @SqlKeyWord_2

--전체쿼리
        	DECLARE @strQuery       nvarchar(3000)
        	SET @strQuery =
			--자료수 카운트
			'Select Count(B.AdId) ' +
			'From '+
			'(	Select AdId,A.ChargeKind,A.RecNm,B.PrnAmt,B.PrnAmt2,B.PrnAmtOk,A.GrpSerial,Convert(char(8),A.RecDate,112) as RecDate,A.BankNm,A.AccountNum,A.inipayTid ' +
			'	From RecCharge A with (Nolock),RecChargeDetail B with (Nolock) ' +
			'	Where A.grpSerial=B.GrpSerial AND (A.inipayTid IS NOT NULL OR A.ChargeKind = ''6'') ' +
			') A right join ' +
			'(	Select Distinct G.AdId,Convert(char(8),G.RegDate,112) as RegDate,G.UserName,G.UserId,G.HPhone,'+
			'	OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,OptKind,OptLink,EscrowYN,G.Keyword,' +
			'	StateChk,G.PartnerCode,G.OptLocalBranch,G.LocalBranch,G.SpecFlag,G.PLineKeyNo,G.DelFlag,B.BrandNmDt,' + @SqlUserReg + ' AS UserRegDate,G.PrnCnt,G.LocalSite ' +
			'	From GoodsMain G with (Nolock),' + @Table + ' B with (Nolock) ' +  @SqlUserTable +
			'	Where G.AdId=B.AdId ' + @SqlUserJoin + ' AND G.StateChk =''1'' ' +  @SqlAll_1 +
			') B on A.AdId = B.AdId Where 1=1 ' + @SqlAll_2 + '; ' +
			--실제 자료
			'Select Top ' + CONVERT(varchar(10),@Page*@PageSize) +
			' 	B.AdId,B.RegDate,B.UserName,' +
			'	OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,OptKind,OptLink,EscrowYN,Keyword,'+
			'	StateChk,B.PartnerCode,OptLocalBranch,LocalBranch,SpecFlag,DelFlag,B.BrandNmDt,B.UserId,'+
			'	A.GrpSerial,A.ChargeKind,A.RecNm,A.PrnAmt,A.PrnAmt2,A.PrnAmtOk,A.RecDate,A.BankNm,A.AccountNum,A.inipayTid,B.UserRegDate,B.PrnCnt,B.LocalSite ' +
			'From '+
			'(	Select AdId,A.ChargeKind,A.RecNm,B.PrnAmt,B.PrnAmt2,B.PrnAmtOk,A.GrpSerial,Convert(char(8),A.RecDate,112) as RecDate,A.BankNm,A.AccountNum,A.inipayTid ' +
			'	From RecCharge A with (Nolock),RecChargeDetail B with (Nolock) ' +
--			'	Where A.grpSerial=B.GrpSerial AND (A.inipayTid IS NOT NULL OR A.ChargeKind = ''6'') ' +
			'	Where A.grpSerial=B.GrpSerial ' +
                       		 ') A right join ' +
			'(	Select Distinct G.AdId,Convert(char(8),G.RegDate,112) as RegDate,G.UserName,G.UserId,G.HPhone,'+
			'	G.OptPhoto,G.OptRecom,G.OptUrgent,G.OptMain,G.OptHot,G.OptPre,G.OptSync,G.OptKind,G.OptLink,G.EscrowYN,G.Keyword,' +
			'	StateChk,G.PartnerCode,G.OptLocalBranch,G.LocalBranch,G.SpecFlag,G.PLineKeyNo,G.DelFlag,B.BrandNmDt,' + @SqlUserReg + ' AS UserRegDate,G.PrnCnt,G.LocalSite ' +
			'	From GoodsMain G with (Nolock),' + @Table + ' B with (Nolock) ' +  @SqlUserTable +
			'	Where G.AdId=B.AdId ' + @SqlUserJoin + ' AND G.StateChk =''1'' ' +  @SqlAll_1 +
			') B on A.AdId = B.AdId Where 1=1 ' + @SqlAll_2 + @SqlOrderFlag
--                      		'Order By B.AdId Desc, A.GrpSerial DESC '
--     	PRINT(@strQuery)
	execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcReg2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcReg2]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@strDateFlag		char(1)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
,	@strPrnAmtOk		char(1)		--결제여부
,	@strPLineKeyNo		char(1)		--인터넷/신문등록 구분
,	@strEscrowYN		char(1)		--안전/일반 구분
,	@strOrderFlag		char(1)		--정렬 순서
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE IF @StrChargeKind ='0'
		BEGIN
			SET 	@SqlChargeKind= 'AND A.ChargeKind IS NULL '
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND A.ChargeKind='+@strChargeKind +''
		END

--2.기간
	DECLARE @SqlSMakDt_1	varchar(100); SET @SqlSMakDt_1= ' '
	DECLARE @SqlEMakDt_1	varchar(100); SET @SqlEMakDt_1= ' '
	DECLARE @SqlSMakDt_2	varchar(100); SET @SqlSMakDt_2= ' '
	DECLARE @SqlEMakDt_2	varchar(100); SET @SqlEMakDt_2= ' '

	DECLARE @SqlUserTable	varchar(200); SET @SqlUserTable=' '
	DECLARE @SqlUserJoin	varchar(100); SET @SqlUserJoin=' '
	DECLARE @SqlUserReg	varchar(100); SET @SqlUserReg=' '''' '

	IF @strDateFlag = '1'
		BEGIN
			IF @StrStartDt <> ''	SET 	@SqlSMakDt_1= ' AND G.RegDate >= ''' + CONVERT(CHAR(10),CONVERT(DateTime,@strStartDt),120) +''''
			IF @StrLastDt <> ''		SET 	@SqlEMakDt_1= ' AND G.RegDate <= ''' + CONVERT(CHAR(10),CONVERT(DateTime,@StrLastDt) + 1,120) + ''''
		END
	ELSE IF @strDateFlag = '2'
		BEGIN
			IF @StrStartDt <> ''	SET 	@SqlSMakDt_2= ' AND A.RecDate >= ''' +@strStartDt +''''
			IF @StrLastDt <> ''		SET 	@SqlEMakDt_2= ' AND A.RecDate <= ''' +@StrLastDt+ ''''
		END
	ELSE IF @strDateFlag = '3'
		BEGIN
			IF @StrStartDt <> ''	SET 	@SqlSMakDt_1= ' AND U.JOIN_DT >= ''' + LEFT(@strStartDt,4) + '-' + SUBSTRING(@strStartDt,5,2) + '-' + RIGHT(@strStartDt,2) +''''
			IF @StrLastDt <> ''		SET 	@SqlEMakDt_1= ' AND U.JOIN_DT <= ''' + LEFT(@StrLastDt,4) + '-' + SUBSTRING(@StrLastDt,5,2) + '-' + RIGHT(@StrLastDt,2) +''''
						SET	@SqlUserTable= ' , FINDDB2.MEMBER.DBO.MM_MEMBER_VI U '
						SET	@SqlUserJoin=' AND G.UserID=U.UserID '
						SET	@SqlUserReg=' ISNULL(U.JOIN_DT,'''') '
		END

--3.키워드검색
	DECLARE @SqlKeyWord_1 varchar(200); SET @SqlKeyWord_1=''
	DECLARE @SqlKeyWord_2 varchar(200); SET @SqlKeyWord_2=''
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord_1= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord_2= 'AND A.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord_1= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord_1= 'AND G.HPhone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='접수번호'
		BEGIN
			SET 	@SqlKeyWord_1= 'AND G.AdId = ' + @strTxtKeyWord+ ' '
		END

 --개인,전문구분
              DECLARE @SqlSpecFlag varchar(200);	SET 	@SqlSpecFlag= ''
/*
	IF @strSpecFlag =''
		SET 	@SqlSpecFlag= ''
          	ELSE IF @strSpecFlag = '0'
		SET 	@SqlSpecFlag= ' AND ( G.SpecFlag IS NULL OR G.SpecFlag IN ( ''0'', '''' ) ) '
	ELSE  
		SET 	@SqlSpecFlag= ' AND G.SpecFlag='+@strSpecFlag +' '
*/


-- 인터넷/신문 등록구분
	DECLARE @SqlPLineKeyNo varchar(200)
	IF @strPLineKeyNo = '0'
		BEGIN
			SET	@SqlPLineKeyNo= ' AND (G.PLineKeyNo IS NULL OR G.PLineKeyNo = '''') '
		END
	ELSE IF  @strPLineKeyNo = '1'
		BEGIN
			SET	@SqlPLineKeyNo= ' AND G.PLineKeyNo <> '''' '
		END
	ELSE
		BEGIN
			SET	@SqlPLineKeyNo= ''
		END

 --결제여부
              DECLARE @SqlPrnAmtOk varchar(200)
	IF @strPrnAmtOk = ''
		BEGIN			
			SET 	@SqlPrnAmtOk= ''
		END
              ELSE  
		BEGIN
			SET 	@SqlPrnAmtOk= ' AND A.PrnAmtOk ='+@strPrnAmtOk
		END

 --안전/일반 구분
              DECLARE @SqlEscrowYN varchar(200)
	IF @strEscrowYN = ''
		BEGIN			
			SET 	@SqlEscrowYN= ''
		END
              ELSE  
		BEGIN
			SET 	@SqlEscrowYN= ' AND G.EscrowYN = '''+@strEscrowYN+''''
		END

 --정렬순서 구분
              DECLARE @SqlOrderFlag varchar(200)
	IF @strOrderFlag = '2'
		BEGIN			
			SET 	@SqlOrderFlag= ' ORDER BY A.GrpSerial DESC, B.AdId DESC '
		END
              ELSE  
		BEGIN
			SET 	@SqlOrderFlag= ' ORDER BY B.AdId DESC, A.GrpSerial DESC '
		END

--판매물품/구매물품 
DECLARE @Table varchar(20)

IF @StrDivInfo ='SELL' 
	SET @Table = ' vi_GoodsSubSale '
ELSE
	SET @Table = ' vi_GoodsSubBuy '

--전체검색쿼리를 묶어서
	DECLARE @SqlAll_1 varchar(500)
	DECLARE @SqlAll_2 varchar(500)
		BEGIN
			SET	@SqlAll_1 = @SqlSpecFlag + @SqlPLineKeyNo + @SqlEscrowYN + @SqlSMakDt_1 + @SqlEMakDt_1 + @SqlKeyWord_1
			SET	@SqlAll_2 = @SqlChargeKind + @SqlPrnAmtOk + @SqlSMakDt_2 + @SqlEMakDt_2 + @SqlKeyWord_2
		END
-- 키워드 검색쿼리 끝

DECLARE @strQuery nvarchar(3000)
SET @strQuery =
			
			--자료수 카운트 
			'Select Count(B.AdId) ' +
			'From '+
			'(	Select AdId, A.ChargeKind, A.RecNm, B.PrnAmt,B.PrnAmtOk, A.GrpSerial, Convert(char(8),A.RecDate,112) as RecDate, A.BankNm, A.AccountNum ' +
			'	From RecCharge A with (Nolock) ' +
			'	, RecChargeDetail B with (Nolock) ' +
			'	Where A.grpSerial=B.GrpSerial AND A.inipayTid IS NOT NULL ' +
			') A right join ' +
			'(	Select Distinct G.AdId,Convert(char(8),G.RegDate,112) as RegDate, G.UserName, G.UserId, G.HPhone, '+
			'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink, EscrowYN,' +
			'	StateChk,G.PartnerCode, G.OptLocalBranch, G.LocalBranch, G.SpecFlag, G.PLineKeyNo, G.DelFlag,B.BrandNmDt, ' + @SqlUserReg + ' AS UserRegDate, G.PrnCnt ' +
			'	From vi_GoodsMain G with (Nolock) ' +
			'		, ' + @Table + ' B with (Nolock) ' +  @SqlUserTable +
			'	Where G.AdId=B.AdId ' + @SqlUserJoin + ' AND G.StateChk =''1''  And G.DelFlag IN (''0'',''1'',''2'') ' +  @SqlAll_1 +
			'		 ) B on A.AdId = B.AdId Where 1=1 ' + @SqlAll_2 + '; ' +
			--자료 Select
			'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) + 
			' B.AdId, B.RegDate, B.UserName, ' +
			'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink, EscrowYN,'+
			'	StateChk,B.PartnerCode, OptLocalBranch, LocalBranch, SpecFlag, DelFlag,B.BrandNmDt, B.UserId, '+
			'	A.GrpSerial, A.ChargeKind, A.RecNm, A.PrnAmt, A.PrnAmtOk, A.RecDate, A.BankNm, A.AccountNum, A.inipayTid, B.UserRegDate, B.PrnCnt ' +
			'From '+
			'(	Select AdId, A.ChargeKind, A.RecNm, B.PrnAmt,B.PrnAmtOk, A.GrpSerial, Convert(char(8),A.RecDate,112) as RecDate, A.BankNm, A.AccountNum, A.inipayTid ' +
			'	From RecCharge A with (Nolock) ' +
			'	, RecChargeDetail B with (Nolock) ' +
			'	Where A.grpSerial=B.GrpSerial AND A.inipayTid IS NOT NULL ' +
			') A right join ' +
			'(	Select Distinct G.AdId,Convert(char(8),G.RegDate,112) as RegDate, G.UserName, G.UserId, G.HPhone, '+
			'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink, EscrowYN,' +
			'	StateChk,G.PartnerCode, G.OptLocalBranch, G.LocalBranch, G.SpecFlag, G.PLineKeyNo, G.DelFlag,B.BrandNmDt, ' + @SqlUserReg + ' AS UserRegDate, G.PrnCnt ' +
			'	From vi_GoodsMain G with (Nolock) ' +
			'		, ' + @Table + ' B with (Nolock) ' +  @SqlUserTable +
			'	Where G.AdId=B.AdId ' + @SqlUserJoin + ' AND G.StateChk =''1''  And G.DelFlag IN (''0'',''1'',''2'') ' +  @SqlAll_1 +
			'		 ) B on A.AdId = B.AdId Where 1=1 ' + @SqlAll_2 + @SqlOrderFlag
--			'Order By B.AdId Desc, A.GrpSerial DESC '

	
--PRINT(@strQuery)
execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcRegProd]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 등록상품 내역 검색 프로시저
	제작자	:
	제작일	:
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcRegProd]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@strDateFlag		char(1)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboCategory		varchar(10)	--카테고리
,	@StrCboOption		varchar(10)	--옵션 검색조건(베스트/핫/프리미엄등등...)
,	@StrCboPrnCnt		varchar(10)	--옵션기간 검색조건(10/20/30)
,	@StrChkOptGbn		varchar(10)	--보너스 옵션 검색 구분
,	@StrCboKeyWord		varchar(10)	--키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	--키워드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
,	@strEscrowYN		char(1)		--안전/일반 구분
,	@strOrderFlag		char(1)		--정렬 순서
)
AS
--결제방법
	DECLARE @SqlChargeKind 	varchar(200)

	IF @StrChargeKind ='ALL'
                SET 	@SqlChargeKind= ''
	ELSE IF @StrChargeKind ='0'
		SET 	@SqlChargeKind= 'AND C.ChargeKind IS NULL '
	ELSE
		SET 	@SqlChargeKind= 'AND C.ChargeKind='+@strChargeKind +''


--기간
	DECLARE @SqlSMakDt      varchar(200)
	DECLARE @SqlEMakDt	varchar(200)

	IF @strDateFlag = '1'
		BEGIN
			IF @StrStartDt <> ''
			        SET 	@SqlSMakDt= ' AND CONVERT(CHAR(10),G.RegDate,112) >= ''' +@strStartDt +''''
			IF @StrLastDt <> ''
			        SET 	@SqlEMakDt= ' AND CONVERT(CHAR(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
	ELSE IF @strDateFlag = '2'
		BEGIN
			IF @StrStartDt <> ''
			        SET 	@SqlSMakDt= ' AND CONVERT(CHAR(10),C.RecDate,112) >= ''' +@strStartDt +''''
			IF @StrLastDt <> ''
			        SET 	@SqlEMakDt= ' AND CONVERT(CHAR(10),C.RecDate,112) <= ''' +@StrLastDt+ ''''
		END
	ELSE
		BEGIN
			SET 	@SqlSMakDt= ''
			SET 	@SqlEMakDt= ''
		END

--카테고리
	DECLARE @SqlCategory    varchar(100)
	SET	@SqlCategory=''

	IF @StrCboCategory <> ''
	        SET 	@SqlCategory= ' AND G.Code' + CONVERT(CHAR(1),LEN(@StrCboCategory)/2) + ' = ' + @StrCboCategory + ' '

--옵션
	DECLARE @SqlOption      varchar(200)
	SET     @SqlOption=''

	IF @StrChkOptGbn = '1'
	        BEGIN
	        	IF @StrCboOption='베스트'		SET 	@SqlOption= ' AND G.OptPhoto=1 '
	        	ELSE IF @StrCboOption='핫'	        SET 	@SqlOption= ' AND G.OptHot=1 '
	        	ELSE IF @StrCboOption='프리미엄'        SET 	@SqlOption= ' AND G.OptPre=1 AND G.OptPhoto=0 '
	        	ELSE IF @StrCboOption='포토갤러리'	SET 	@SqlOption= ' AND G.OptKind LIKE ''%7%'' AND G.OptPhoto=0 AND G.OptHot=0 '
	        	ELSE IF @StrCboOption='제목볼드'        SET 	@SqlOption= ' AND G.OptKind LIKE ''%1%'' '
	        	ELSE IF @StrCboOption='형광배경'        SET 	@SqlOption= ' AND G.OptKind LIKE ''%3%'' '
	        	ELSE IF @StrCboOption='깜박임'	        SET 	@SqlOption= ' AND G.OptKind LIKE ''%2%'' '
	        	ELSE IF @StrCboOption='쇼핑몰주소'	SET 	@SqlOption= ' AND G.OptKind LIKE ''%6%'' '
	        	ELSE IF @StrCboOption='안전거래'        SET 	@SqlOption= ' AND G.EscrowYN=''Y'' '
	        	ELSE IF @StrCboOption='상점형거래'	SET 	@SqlOption= ' AND G.SpecFlag=''4'' '
	        	ELSE IF @StrCboOption='키워드'	        SET 	@SqlOption= ' AND G.Keyword=''1'' '
	        END
	ELSE
	        BEGIN
	        	IF @StrCboOption='베스트'		SET 	@SqlOption= ' AND G.OptPhoto=1 '
	        	ELSE IF @StrCboOption='핫'	        SET 	@SqlOption= ' AND G.OptHot=1 '
	        	ELSE IF @StrCboOption='프리미엄'        SET 	@SqlOption= ' AND G.OptPre=1 '
	        	ELSE IF @StrCboOption='포토갤러리'	SET 	@SqlOption= ' AND G.OptKind LIKE ''%7%'' '
	        	ELSE IF @StrCboOption='제목볼드'        SET 	@SqlOption= ' AND G.OptKind LIKE ''%1%'' '
	        	ELSE IF @StrCboOption='형광배경'        SET 	@SqlOption= ' AND G.OptKind LIKE ''%3%'' '
	        	ELSE IF @StrCboOption='깜박임'	        SET 	@SqlOption= ' AND G.OptKind LIKE ''%2%'' '
	        	ELSE IF @StrCboOption='쇼핑몰주소'	SET 	@SqlOption= ' AND G.OptKind LIKE ''%6%'' '
	        	ELSE IF @StrCboOption='안전거래'        SET 	@SqlOption= ' AND G.EscrowYN=''Y'' '
	        	ELSE IF @StrCboOption='상점형거래'	SET 	@SqlOption= ' AND G.SpecFlag=''4'' '
	        	ELSE IF @StrCboOption='키워드'	        SET 	@SqlOption= ' AND G.Keyword=''1'' '
	        END

--5.옵션기간검색
	DECLARE @SqlPrnCnt      varchar(200)
	SET     @SqlPrnCnt=''

	IF @StrCboPrnCnt='10'
	        SET 	@SqlPrnCnt= ' AND G.PrnCnt <= 10 '
	ELSE IF @StrCboPrnCnt='20'
	        SET 	@SqlPrnCnt= ' AND G.PrnCnt BETWEEN 11 AND 20 '
	ELSE IF @StrCboPrnCnt='30'
	        SET 	@SqlPrnCnt= ' AND G.PrnCnt >= 21 '

--키워드
	DECLARE @SqlKeyWord     varchar(200)

	IF @StrCboKeyWord ='신청자명'
                SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='입금자명'
		SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='등록자ID'
		SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='전화번호'
		SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord=''
		SET	@SqlKeyWord=''


--개인/전문
        DECLARE @SqlSpecFlag    varchar(200)
        SET 	@SqlSpecFlag= ''
/*
        IF @strSpecFlag =''
        	SET 	@SqlSpecFlag= ''
        ELSE IF @strSpecFlag = '0'
        	SET 	@SqlSpecFlag= ' AND ( G.SpecFlag IS NULL OR G.SpecFlag IN ( ''0'', '''' ) ) '
        ELSE
        	SET 	@SqlSpecFlag= ' AND G.SpecFlag='+@strSpecFlag +' '
*/


--안전/일반 구분
        DECLARE @SqlEscrowYN    varchar(200)

	IF @strEscrowYN = ''
                SET 	@SqlEscrowYN= ''
        ELSE
                SET 	@SqlEscrowYN= ' AND G.EscrowYN = '''+@strEscrowYN+''''

--정렬순서 구분
        DECLARE @SqlOrderFlag   varchar(200)

	IF @strOrderFlag = '2'
		SET 	@SqlOrderFlag= ' ORDER BY C.GrpSerial DESC, G.AdId DESC '
	ELSE IF @strOrderFlag = '3'
		SET 	@SqlOrderFlag= ' ORDER BY C.RecDate DESC, G.AdId DESC '
        ELSE
		SET 	@SqlOrderFlag= ' ORDER BY G.AdId DESC, C.GrpSerial DESC '


--판매물품/구매물품
	DECLARE @SqlDivInfo     varchar(20)
	DECLARE @SqlRegAmtOk    varchar(30)

	IF @StrDivInfo ='SELL'
	        BEGIN
	        	SET @SqlDivInfo = ' And G.AdGbn = 0 '
	        	SET @SqlRegAmtOk = ' And G.RegAmtOk = ''1'' '
	        END
	ELSE
	        BEGIN
	        	SET @SqlDivInfo = ' And G.AdGbn = 1 '
	        	SET @SqlRegAmtOk = ' '
	        END

--전체검색
	DECLARE @SqlAll	        varchar(500)
	SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlSpecFlag + @SqlDivInfo  + @SqlEscrowYN + @SqlCategory + @SqlOption + @SqlPrnCnt

--전체쿼리
        DECLARE @strQuery       nvarchar(3000)
        SET @strQuery =
                        --자료수 카우트
                        'Select Count(G.AdId), SUM(C.PrnAmt2) ' +
                        'From vi_GoodsMain G with (Nolock) inner join  ' +
	                '	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmt2, B.PrnAmtOk, A.inipayTid ' +
                        '	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial AND A.inipayTid IS NOT NULL) C ' +
                        '	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
                        '	on G.Code1 = D.Code1 ' +
                        'Where C.PrnAmtOk = ''1'' ' + @SqlRegAmtOk + @SqlAll + ';' +
                        --실제 자료
                        'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
	                ' 	G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.UserName,G.StateChk,G.SpecFlag, ' +
                        '	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, EscrowYN, Keyword, ' +
	                '	C.GrpSerial, C.PrnAmt, C.PrnAmt2, C.RecNm,C.ChargeKind,Convert(varchar(10),C.RecDate,120) as RecDate,D.CodeNm1, C.inipayTid, G.PrnCnt, G.LocalSite ' +
                        'From vi_GoodsMain G with (Nolock) inner join  ' +
	                '	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmt2, B.PrnAmtOk, A.inipayTid ' +
                        '	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial AND A.inipayTid IS NOT NULL) C ' +
                        '	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
                        '	on G.Code1 = D.Code1 ' +
                        'Where C.PrnAmtOk = ''1'' ' + @SqlRegAmtOk + @SqlAll + @SqlOrderFlag
--                      'Order By G.AdId desc, C.GrpSerial DESC '
--      PRINT(@strQuery)
        Execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcSpecialList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcSpecialList]
(
	@GetCount	varchar(10)
,	@StrCode1	varchar(10)
,	@StrLocal	varchar(2)	-- 지역코드
,	@AdultCode	char(1)
,	@SpecialCode	char(1)
,	@SpecialUserId	varchar(50) = ''
)
AS
set nocount on 

--Code값
	DECLARE @SqlstrCode varchar(100) ; SET @SqlstrCode = ''
	IF @StrCode1 <> ''	SET @SqlstrCode = ' AND B.Code1='+@StrCode1

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE
		SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0 OR B.ShowLocalSite=' + @StrLocal + ')'
--AdultCode
	DECLARE @SqlAdultCode varchar(100) 
	IF @AdultCode = '0' 	
		SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '
	ELSE
		SET @SqlAdultCode=''
--SpecialCode
	DECLARE @SqlSpecial varchar(200)
	IF @SpecialCode = '0'
		SET @SqlSpecial = ' AND B.UserId=''' + @SpecialUserId + ''' '
	ELSE
		SET @SqlSpecial = ' AND B.SpecFlag=''' + @SpecialCode + ''' '
--Query	

	DECLARE @strSelect varchar(300)
	DECLARE @strOrder varchar(100)
	DECLARE @strQuery varchar(3000)
	IF @GetCount = '0'
		BEGIN
			SET @strSelect = 'SELECT COUNT(B.AdId) '
			SET @strOrder = ''
		END
	ELSE
		BEGIN
			SET @strSelect = 'SELECT TOP ' + @GetCount + ' B.Adid, S.BrandNmDt, EscrowYN, S.WishAmt, S.GoodsQt, S.UseGbn, B.ZipMain, B.ZipSub, P.PicImage, B.PLineKeyNo '
			SET @strOrder = ' ORDER BY B.RegDate DESC '
		END

	SET @strQuery =  @strSelect +
					' FROM GoodsMain B, GoodsSubSale S, GoodsPic P ' + 
					' WHERE B.AdId = S.AdId ' +
					' AND B.AdId*=P.AdId ' +
					' AND P.PicIdx=7 ' +
					' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE())' +
					' AND B.StateChk=''1'' AND RegAmtOk=''1'' AND B.DelFlag=''0'' AND B.SaleOkFlag=''0'' ' + @SqlSpecial + @SqlstrCode + @SqlLocalGoods + @SqlAdultCode + @strOrder

PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procStatistics_Used_Ing]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[procStatistics_Used_Ing] 
AS

--=============================================================================================
-- 날짜 초기화
--=============================================================================================
Update dbo.Statistics_Used_Ing SET BasisDate= getDate()

--=============================================================================================
-- 통계 초기화
--=============================================================================================
Update dbo.Statistics_Used_Ing 
SET      전체매물건수=0, 전체매출액=0, 일반매물=0, 
            옵션_베스트=0, 옵션_핫=0, 옵션_프리=0, 옵션_포토갤러리=0, 
            옵션_제목볼드=0, 옵션_형광배경=0, 옵션_깜빡임=0,
	     옵션_쇼핑몰주소표기=0, 옵션_안전거래=0

--=============================================================================================
-- 구인광고 총게재 
--=============================================================================================
UPDATE S 
SET	S.전체매물건수  = T.전체매물_건수,	S.전체매출액          = T.전체매출액, 
	S.일반매물         = T.일반매물,	 	S.옵션_베스트        = T.옵션_베스트, 
	S.옵션_핫      	    = T.옵션_핫, 	  	S.옵션_포토갤러리  = T.옵션_포토갤러리, 
	S.옵션_제목볼드 = T.옵션_제목볼드,	S.옵션_형광배경      = T.옵션_형광배경, 
	S.옵션_깜빡임    = T.옵션_깜빡임, 	S.옵션_쇼핑몰주소표기 = T.옵션_쇼핑몰주소표기,
	S.옵션_안전거래 = T.옵션_안전거래,   S.옵션_프리            = T.옵션_프리
FROM   dbo.Statistics_Used_Ing AS S , 
		(
		SELECT	G.AdGbn, G.Code1, G.Code2, G.Code3,	G.LocalSite,	RecProxyGbn,
				COUNT(DISTINCT G.AdId)	AS 전체매물_건수,
				SUM( CASE WHEN D.PrnAmt IS NOT NULL AND D.PrnAmtOk = '1' AND G.PrnEnDate >= GETDATE() THEN D.PrnAmt ELSE 0 END ) AS 전체매출액,
				COUNT( CASE WHEN (G.PrnAmtOk <> '1'	AND G.OptType = '1' ) OR ( G.OptType = '0' AND G.EscrowYN <> 'Y' ) OR (G.PrnAmtOk = '1' AND G.OptType = '1' AND G.PrnEnDate < GETDATE())	 THEN G.AdId ELSE NULL END ) AS 일반매물,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND G.OptPhoto = 1		AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_베스트,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND G.OptHot = 1			AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_핫,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND G.OptPre = 1			AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_프리,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND CHARINDEX(G.OptKind,'7') > 0	AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_포토갤러리,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND CHARINDEX(G.OptKind,'1') > 0	AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_제목볼드,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND CHARINDEX(G.OptKind,'3') > 0	AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_형광배경,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND CHARINDEX(G.OptKind,'2') > 0	AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_깜빡임,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND CHARINDEX(G.OptKind,'6') > 0	AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_쇼핑몰주소표기,
				COUNT( CASE WHEN G.EscrowYN = 'Y'												THEN G.AdId ELSE NULL END ) AS 옵션_안전거래
		FROM		
			(SELECT G.AdId, G.OptType, G.Code1, G.Code2, G.Code3, G.OptPhoto, G.OptHot, G.OptPre, G.OptKind,
					G.PrnEnDate, G.PrnAmtOk, G.EscrowYN, G.AdGbn, G.LocalSite, G.PLineKeyNo,
					CASE WHEN G.PLineKeyNo IS NULL THEN
							CASE WHEN H.AdId IS NULL THEN 0	ELSE 1	END
						ELSE 2
					END AS RecProxyGbn
			FROM 	GoodsMain G WITH (NoLock), RegAgentHistory H WITH (NoLock)
			WHERE	G.AdId*=H.AdId
			AND 	G.StateChk =  '1'
			AND 	G.DelFlag = '0'
			AND 	G.SaleOkFlag <> '1'
			) G,  
			RecChargeDetail D WITH (NoLock)		
		WHERE	G.AdId*=D.AdId		
		GROUP BY G.Code1, G.Code2, G.Code3, G.AdGbn, G.LocalSite, G.RecProxyGbn
	      )  AS T
WHERE S.CateCode1 = T.Code1 
AND      S.CateCode2 = T.Code2 
AND      S.CateCode3 = T.Code3 
AND      S.LocalSite    = T.LocalSite 
AND      S.RecProxy   = T.RecProxyGbn 
AND      S.SaleGbn     = T.AdGbn


/*
--=============================================================================================
-- 마지막 결과값 쿼리(작업 스케쥴에서 사용하는 쿼리)
--=============================================================================================
Select  Convert(Varchar(10), getDate(), 120) AS 기준일,
           '유즈드'    AS 사이트구분,
           CASE SaleGbn When 0 then '삽니다' when 1 then '팝니다' End AS 매물유형,
           CateCodeNm1 AS 대분류, CateCodeNm2 AS 중분류, CateCodeNm3 AS 소분류,
          Case LocalSite when '0' then '전국' when '1' then '서울' when '2' then '부산' when '3' then '대구' 
                                          when '4' then '부천' when '5' then '대전' when '6' then '전주' when '7' then '수원' 
                                          when '8' then '광주' when '9' then '구미'  end AS 등록경로 ,        
           Case RecProxy when '0' then '온라인' when '1' then '등록대행' when '2' then '신문'  end AS 등록자유형,
           전체매물건수, 전체매출액, 일반매물 ,  옵션_베스트, 옵션_핫,  옵션_프리,  옵션_포토갤러리,  옵션_제목볼드,
           옵션_형광배경,  옵션_깜빡임,  옵션_쇼핑몰주소표기, 옵션_안전거래

From dbo.Statistics_Used_Ing with (NoLock)


--=============================================================================================
-- 유즈드_게재중 백데이타 쌓기위한 쿼리~ 
--=============================================================================================
Truncate Table Statistics_Used_Ing

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 0, 0 FROM CatCode where UseFlag='Y') --전국 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 0, 1 FROM CatCode where UseFlag='Y') --전국 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 0, 2 FROM CatCode where UseFlag='Y') --전국 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 1, 0 FROM CatCode where UseFlag='Y') --서울 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 1, 1 FROM CatCode where UseFlag='Y') --서울 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 1, 2 FROM CatCode where UseFlag='Y') --서울 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 2, 0 FROM CatCode where UseFlag='Y') --부산 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 2, 1 FROM CatCode where UseFlag='Y') --부산 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 2, 2 FROM CatCode where UseFlag='Y') --부산 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 3, 0 FROM CatCode where UseFlag='Y') --대구 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 3, 1 FROM CatCode where UseFlag='Y') --대구 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 3, 2 FROM CatCode where UseFlag='Y') --대구 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 4, 0 FROM CatCode where UseFlag='Y') --부천 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 4, 1 FROM CatCode where UseFlag='Y') --부천 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 4, 2 FROM CatCode where UseFlag='Y') --부천 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 5, 0 FROM CatCode where UseFlag='Y') --대전 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 5, 1 FROM CatCode where UseFlag='Y') --대전 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 5, 2 FROM CatCode where UseFlag='Y') --대전 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 6, 0 FROM CatCode where UseFlag='Y') --전주 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 6, 1 FROM CatCode where UseFlag='Y') --전주 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 6, 2 FROM CatCode where UseFlag='Y') --전주 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 7, 0 FROM CatCode where UseFlag='Y') --수원 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 7, 1 FROM CatCode where UseFlag='Y') --수원 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 7, 2 FROM CatCode where UseFlag='Y') --수원 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 8, 0 FROM CatCode where UseFlag='Y') --광주 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 8, 1 FROM CatCode where UseFlag='Y') --광주 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 8, 2 FROM CatCode where UseFlag='Y') --광주 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 9, 0 FROM CatCode where UseFlag='Y') --구미 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 9, 1 FROM CatCode where UseFlag='Y') --구미 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 9, 2 FROM CatCode where UseFlag='Y') --구미 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 0, 0 FROM CatCode where UseFlag='Y') --전국 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 0, 1 FROM CatCode where UseFlag='Y') --전국 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 0, 2 FROM CatCode where UseFlag='Y') --전국 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 1, 0 FROM CatCode where UseFlag='Y') --서울 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 1, 1 FROM CatCode where UseFlag='Y') --서울 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 1, 2 FROM CatCode where UseFlag='Y') --서울 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 2, 0 FROM CatCode where UseFlag='Y') --부산 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 2, 1 FROM CatCode where UseFlag='Y') --부산 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 2, 2 FROM CatCode where UseFlag='Y') --부산 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 3, 0 FROM CatCode where UseFlag='Y') --대구 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 3, 1 FROM CatCode where UseFlag='Y') --대구 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 3, 2 FROM CatCode where UseFlag='Y') --대구 신문
                                                                                                                                                                                                   
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 4, 0 FROM CatCode where UseFlag='Y') --부천 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 4, 1 FROM CatCode where UseFlag='Y') --부천 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 4, 2 FROM CatCode where UseFlag='Y') --부천 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 5, 0 FROM CatCode where UseFlag='Y') --대전 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 5, 1 FROM CatCode where UseFlag='Y') --대전 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 5, 2 FROM CatCode where UseFlag='Y') --대전 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 6, 0 FROM CatCode where UseFlag='Y') --전주 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 6, 1 FROM CatCode where UseFlag='Y') --전주 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 6, 2 FROM CatCode where UseFlag='Y') --전주 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 7, 0 FROM CatCode where UseFlag='Y') --수원 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 7, 1 FROM CatCode where UseFlag='Y') --수원 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 7, 2 FROM CatCode where UseFlag='Y') --수원 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 8, 0 FROM CatCode where UseFlag='Y') --광주 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 8, 1 FROM CatCode where UseFlag='Y') --광주 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 8, 2 FROM CatCode where UseFlag='Y') --광주 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 9, 0 FROM CatCode where UseFlag='Y') --구미 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 9, 1 FROM CatCode where UseFlag='Y') --구미 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 9, 2 FROM CatCode where UseFlag='Y') --구미 신문

*/
GO
/****** Object:  StoredProcedure [dbo].[procStatistics_Used_New]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[procStatistics_Used_New] 
AS

--=============================================================================================
-- 날짜 초기화
--=============================================================================================
Update dbo.Statistics_Used_New SET BasisDate= getDate()

--=============================================================================================
-- 통계 초기화
--=============================================================================================
Update dbo.Statistics_Used_New 
SET      전체매물건수=0, 전체매출액=0, 일반매물=0, 
            옵션_베스트=0, 옵션_핫=0, 옵션_프리=0, 옵션_포토갤러리=0, 
            옵션_제목볼드=0, 옵션_형광배경=0, 옵션_깜빡임=0,
	     옵션_쇼핑몰주소표기=0, 옵션_안전거래=0

--=============================================================================================
-- 구인광고 총게재 
--=============================================================================================
UPDATE S 
SET	S.전체매물건수  = T.전체매물_건수,	S.전체매출액          = T.전체매출액, 
	S.일반매물         = T.일반매물,	 	S.옵션_베스트        = T.옵션_베스트, 
	S.옵션_핫      	    = T.옵션_핫, 	  	S.옵션_포토갤러리  = T.옵션_포토갤러리, 
	S.옵션_제목볼드 = T.옵션_제목볼드,	S.옵션_형광배경      = T.옵션_형광배경, 
	S.옵션_깜빡임    = T.옵션_깜빡임, 	S.옵션_쇼핑몰주소표기 = T.옵션_쇼핑몰주소표기,
	S.옵션_안전거래 = T.옵션_안전거래,   S.옵션_프리            = T.옵션_프리
FROM   dbo.Statistics_Used_New AS S , 
		(
		SELECT	G.AdGbn, G.Code1, G.Code2, G.Code3,	G.LocalSite,	RecProxyGbn,
				COUNT(DISTINCT G.AdId)	AS 전체매물_건수,
				SUM( CASE WHEN D.PrnAmt IS NOT NULL AND D.PrnAmtOk = '1' AND G.PrnEnDate >= GETDATE() THEN D.PrnAmt ELSE 0 END ) AS 전체매출액,
				COUNT( CASE WHEN (G.PrnAmtOk <> '1'	AND G.OptType = '1' ) OR ( G.OptType = '0' AND G.EscrowYN <> 'Y' ) OR (G.PrnAmtOk = '1' AND G.OptType = '1' AND G.PrnEnDate < GETDATE())	 THEN G.AdId ELSE NULL END ) AS 일반매물,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND G.OptPhoto = 1		AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_베스트,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND G.OptHot = 1			AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_핫,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND G.OptPre = 1			AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_프리,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND CHARINDEX(G.OptKind,'7') > 0	AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_포토갤러리,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND CHARINDEX(G.OptKind,'1') > 0	AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_제목볼드,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND CHARINDEX(G.OptKind,'3') > 0	AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_형광배경,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND CHARINDEX(G.OptKind,'2') > 0	AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_깜빡임,
				COUNT( CASE WHEN G.PrnAmtOk = '1' 	AND G.OptType = '1'	AND CHARINDEX(G.OptKind,'6') > 0	AND G.PrnEnDate >= GETDATE()	THEN G.AdId ELSE NULL END ) AS 옵션_쇼핑몰주소표기,
				COUNT( CASE WHEN G.EscrowYN = 'Y'												THEN G.AdId ELSE NULL END ) AS 옵션_안전거래
		FROM		
			(SELECT G.AdId, G.OptType, G.Code1, G.Code2, G.Code3, G.OptPhoto, G.OptHot, G.OptPre, G.OptKind,
					G.PrnEnDate, G.PrnAmtOk, G.EscrowYN, G.AdGbn, G.LocalSite, G.PLineKeyNo,
					CASE WHEN G.PLineKeyNo IS NULL THEN
							CASE WHEN H.AdId IS NULL THEN 0	ELSE 1	END
						ELSE 2
					END AS RecProxyGbn
			FROM 	GoodsMain G WITH (NoLock), RegAgentHistory H WITH (NoLock)
			WHERE	G.AdId*=H.AdId
			AND 	G.StateChk IN ('1','5')
			AND 	(CONVERT(CHAR(10),G.RegDate,120) = CONVERT(CHAR(10),GETDATE(),120) )
			) G,  
			RecChargeDetail D WITH (NoLock)		
		WHERE	G.AdId*=D.AdId		
		GROUP BY G.Code1, G.Code2, G.Code3, G.AdGbn, G.LocalSite, G.RecProxyGbn
	      )  AS T
WHERE S.CateCode1 = T.Code1 
AND      S.CateCode2 = T.Code2 
AND      S.CateCode3 = T.Code3 
AND      S.LocalSite    = T.LocalSite 
AND      S.RecProxy   = T.RecProxyGbn 
AND      S.SaleGbn     = T.AdGbn


/*
--=============================================================================================
-- 마지막 결과값 쿼리(작업 스케쥴에서 사용하는 쿼리)
--=============================================================================================
Select  Convert(Varchar(10), getDate(), 120) AS 기준일,
           '유즈드'    AS 사이트구분,
           CASE SaleGbn When 0 then '삽니다' when 1 then '팝니다' End AS 매물유형,
           CateCodeNm1 AS 대분류, CateCodeNm2 AS 중분류, CateCodeNm3 AS 소분류,
          Case LocalSite when '0' then '전국' when '1' then '서울' when '2' then '부산' when '3' then '대구' 
                                          when '4' then '부천' when '5' then '대전' when '6' then '전주' when '7' then '수원' 
                                          when '8' then '광주' when '9' then '구미'  end AS 등록경로 ,        
           Case RecProxy when '0' then '온라인' when '1' then '등록대행' when '2' then '신문'  end AS 등록자유형,
           전체매물건수, 전체매출액, 일반매물 ,  옵션_베스트, 옵션_핫,  옵션_프리,  옵션_포토갤러리,  옵션_제목볼드,
           옵션_형광배경,  옵션_깜빡임,  옵션_쇼핑몰주소표기, 옵션_안전거래

From dbo.Statistics_Used_New with (NoLock)


--=============================================================================================
-- 유즈드_게재중 백데이타 쌓기위한 쿼리~ 
--=============================================================================================
Truncate Table Statistics_Used_New

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 0, 0 FROM CatCode where UseFlag='Y') --전국 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 0, 1 FROM CatCode where UseFlag='Y') --전국 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 0, 2 FROM CatCode where UseFlag='Y') --전국 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 1, 0 FROM CatCode where UseFlag='Y') --서울 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 1, 1 FROM CatCode where UseFlag='Y') --서울 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 1, 2 FROM CatCode where UseFlag='Y') --서울 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 2, 0 FROM CatCode where UseFlag='Y') --부산 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 2, 1 FROM CatCode where UseFlag='Y') --부산 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 2, 2 FROM CatCode where UseFlag='Y') --부산 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 3, 0 FROM CatCode where UseFlag='Y') --대구 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 3, 1 FROM CatCode where UseFlag='Y') --대구 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 3, 2 FROM CatCode where UseFlag='Y') --대구 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 4, 0 FROM CatCode where UseFlag='Y') --부천 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 4, 1 FROM CatCode where UseFlag='Y') --부천 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 4, 2 FROM CatCode where UseFlag='Y') --부천 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 5, 0 FROM CatCode where UseFlag='Y') --대전 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 5, 1 FROM CatCode where UseFlag='Y') --대전 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 5, 2 FROM CatCode where UseFlag='Y') --대전 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 6, 0 FROM CatCode where UseFlag='Y') --전주 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 6, 1 FROM CatCode where UseFlag='Y') --전주 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 6, 2 FROM CatCode where UseFlag='Y') --전주 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 7, 0 FROM CatCode where UseFlag='Y') --수원 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 7, 1 FROM CatCode where UseFlag='Y') --수원 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 7, 2 FROM CatCode where UseFlag='Y') --수원 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 8, 0 FROM CatCode where UseFlag='Y') --광주 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 8, 1 FROM CatCode where UseFlag='Y') --광주 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 8, 2 FROM CatCode where UseFlag='Y') --광주 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 9, 0 FROM CatCode where UseFlag='Y') --구미 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 9, 1 FROM CatCode where UseFlag='Y') --구미 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 0, 9, 2 FROM CatCode where UseFlag='Y') --구미 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 0, 0 FROM CatCode where UseFlag='Y') --전국 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 0, 1 FROM CatCode where UseFlag='Y') --전국 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 0, 2 FROM CatCode where UseFlag='Y') --전국 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 1, 0 FROM CatCode where UseFlag='Y') --서울 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 1, 1 FROM CatCode where UseFlag='Y') --서울 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 1, 2 FROM CatCode where UseFlag='Y') --서울 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 2, 0 FROM CatCode where UseFlag='Y') --부산 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 2, 1 FROM CatCode where UseFlag='Y') --부산 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 2, 2 FROM CatCode where UseFlag='Y') --부산 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 3, 0 FROM CatCode where UseFlag='Y') --대구 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 3, 1 FROM CatCode where UseFlag='Y') --대구 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 3, 2 FROM CatCode where UseFlag='Y') --대구 신문
                                                                                                                                                                                                   
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 4, 0 FROM CatCode where UseFlag='Y') --부천 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 4, 1 FROM CatCode where UseFlag='Y') --부천 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 4, 2 FROM CatCode where UseFlag='Y') --부천 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 5, 0 FROM CatCode where UseFlag='Y') --대전 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 5, 1 FROM CatCode where UseFlag='Y') --대전 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 5, 2 FROM CatCode where UseFlag='Y') --대전 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 6, 0 FROM CatCode where UseFlag='Y') --전주 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 6, 1 FROM CatCode where UseFlag='Y') --전주 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 6, 2 FROM CatCode where UseFlag='Y') --전주 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 7, 0 FROM CatCode where UseFlag='Y') --수원 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 7, 1 FROM CatCode where UseFlag='Y') --수원 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 7, 2 FROM CatCode where UseFlag='Y') --수원 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 8, 0 FROM CatCode where UseFlag='Y') --광주 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 8, 1 FROM CatCode where UseFlag='Y') --광주 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 8, 2 FROM CatCode where UseFlag='Y') --광주 신문

INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 9, 0 FROM CatCode where UseFlag='Y') --구미 일반
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 9, 1 FROM CatCode where UseFlag='Y') --구미 대행
INSERT INTO dbo.Statistics_Used_New (CateCode1, CateCode2, CateCode3, CateCodeNm1, CateCodeNm2, CateCodeNm3, SaleGbn, LocalSite, RecProxy) (SELECT Code1, Code2, Code3, CodeNm1, CodeNm2,CodeNm3, 1, 9, 2 FROM CatCode where UseFlag='Y') --구미 신문

*/
GO
/****** Object:  StoredProcedure [dbo].[ProcSyncList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcSyncList]
(
	@StrLocal	varchar(2)	-- 지역코드
,	@AdultCode	char(1)		-- 성인구분
)
AS

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE
		SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
				          ' (Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ') ' +
				          ' OR B.ZipMain = ''전국'' ) '
--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2415) '

	DECLARE @strQuery varchar(3000)
	SET @strQuery = ' SELECT  TOP 10 ' +
			' A.AdId, A.BrandNmDt, A.WishAmt, A.UseGbn, ' +
			' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, ' +
			' CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 
			' OptType,OptList,OptPhoto,OptRecom,OptUrgent,OptMain,OptHot,OptPre,OptSync,' +
			' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub, ' +
			' A.CardYN, A.PicIdx1, A.PicIdx2, B.ViewCnt, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, B.EscrowYN ' +
			' FROM GoodsMain B WITH (NoLock), GoodsSubSale A WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M ' + 
			' WHERE B.AdId = A.AdId AND B.AdId *=M.AdId ' +
			' AND B.OptSync=1 ' +
			' AND B.PrnAmtOk=''1'' AND B.PrnEnDate >= GETDATE() ' +
			' AND B.StateChk=''1'' AND B.DelFlag=''0'' AND B.SaleOkFlag=''0''  ' + @SqlLocalGoods + @SqlAdultCode +
			' ORDER BY NEWID() '

PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procTaxRequestList_Used]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
제목	 : 세금계산서 신청/발행
작성자	 : 
제작일	 : 2006-05-22
설명	 : EXEC dbo.procTaxRequestList_Used 1, 20, 52, '2006-06-27','2006-09-27'   
사용 ASP : /MyShop/Tax/MyTaxList.asp
*************************************************************************************/
CREATE PROC [dbo].[procTaxRequestList_Used](
	@Page		int
,	@PageSize	int
,	@CUID		INT
,	@StartDate	varchar(10)
,	@EndDate	varchar(10)
)
AS

SET NOCOUNT ON
--==============================================================================================
-- 변수 선언
--==============================================================================================
DECLARE @FromSubSql				nvarchar(3000)	-- 해당 광고 취합
DECLARE @Sql1					nvarchar(4000)
DECLARE @Sql2					nvarchar(4000)

SET @FromSubSql = '' +	 
		'	SELECT G.AdId, G.BrandNm, G.BrandNmDt, R.GrpSerial, R.PrnAmt, R.RecDate, R.ChargeKind, R.IniPayTid ' +
		'	FROM ' +
		'	( ' +
		'		SELECT M.AdId, M.UserID, S.BrandNm, S.BrandNmDt, M.CUID ' +
		'		FROM GoodsMain M  INNER JOIN GoodsSubSale S  ON M.AdId = S.AdId ' +
		'		WHERE M.CUID = '+ cast(@CUID as varchar)+ ' ' +
		'		AND M.DelFlag = ''0'' ' + 
		'		AND M.StateChk = ''1'' ' + 
		'		AND M.RegAmtOK = ''1'' ' + 
		'		AND M.PrnAmtOK = ''1'' ' +  
		'	) G, ' + 
		'	( ' +
		'		SELECT D.AdId, D.PrnAmt, D.PrnAmtOK, C.RecDate, C.ChargeKind, C.GrpSerial, C.IniPayTid ' +
		'		FROM RecCharge C  INNER JOIN RecChargeDetail D  ON C.GrpSerial = D.GrpSerial ' +
		'	) R ' +
		'	WHERE G.CUID = '+ cast(@CUID as varchar) + ' ' +
		'		AND G.AdId = R.AdId ' +
		'		AND R.PrnAmtOK = ''1'' ' +  
		'		AND R.GrpSerial NOT IN ( SELECT Grpserial FROM ReceiptRequest WHERE Result IN (0, 1) AND DelFlag = 0 ) ' +
		'		AND R.RecDate BETWEEN ''' + @StartDate + ''' AND ''' + @EndDate + ''''

SET @Sql1	 =	' SELECT COUNT(A.AdId) ' +
			' FROM ( '  + @FromSubSql +' ) A LEFT OUTER JOIN FINDDB2.FindCommon.dbo.TaxRequest T  ON A.GrpSerial = T.GrpSerial '
SET @Sql2	 =	
			' SELECT Top ' +  CONVERT(varchar(10),@Page * @PageSize) + 
			'   A.AdId, A.BrandNm, A.BrandNmDt, A.GrpSerial, A.PrnAmt, A.ChargeKind, A.RecDate, T.Idx, T.TaxFlag, T.TaxCheckDate, A.IniPayTid ' +
			' FROM ( '  + @FromSubSql +' ) A LEFT OUTER JOIN FINDDB2.FindCommon.dbo.TaxRequest T  ON A.GrpSerial = T.GrpSerial ' +
			' ORDER BY A.RecDate DESC, T.TaxFlag ASC '
--print @sql1
--print @sql2

execute sp_executesql @Sql1 
execute sp_executesql @Sql2
GO
/****** Object:  StoredProcedure [dbo].[ProcTotal]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 등록상품 내역 검색 프로시저
	제작자	:
	제작일	:
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcTotal]
(
	@Page			int
,	@PageSize		int
,	@strLocal		char(2)
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@strDateFlag		char(1)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	--키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	--키워드
,	@StrPartner             char(10)
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
,	@strPrnAmtOk		char(1)		--결제여부
,	@strPLineKeyNo		char(1)		--인터넷/신문등록 구분
,	@strEscrowYN		char(1)		--안전/일반 구분
,	@strOrderFlag		char(1)		--정렬 순서
)
AS
--지점 구분
	DECLARE @SqlLocal       varchar(300)
	DECLARE @SqlLocalDB     varchar(100)
	DECLARE @SqlLocalGoods  varchar(500)

	IF @StrLocal ='0' or @strLocal = ''
		SET @SqlLocalGoods = ''
	ELSE
		SET @SqlLocalGoods = ' AND A.LocalSite= ' + @StrLocal + ' '
--		SET @SqlLocalGoods = ' AND (A.LocalSite= ' + @StrLocal + ' OR ( A.OptType=''0'' AND A.LocalBranch=(SELECT TOP 1 LocalBranch FROM LocalSite WHERE LocalSite=' + @StrLocal + ' ORDER BY LocalBranch DESC) ) ) '

--결제방법
	DECLARE @SqlChargeKind  varchar(200)

	IF @StrChargeKind ='ALL'
			SET 	@SqlChargeKind= ''
	ELSE IF @StrChargeKind ='0'
			SET 	@SqlChargeKind= 'AND A.ChargeKind IS NULL '
	ELSE
			SET 	@SqlChargeKind= 'AND A.ChargeKind='+@strChargeKind +''

--기간
	DECLARE @SqlSMakDt	varchar(200)
	DECLARE @SqlEMakDt	varchar(200)

	IF @strDateFlag = '1'
		BEGIN
			IF @StrStartDt <> ''
			        SET 	@SqlSMakDt= ' AND B.RegDate >= ''' +@strStartDt +''''
			IF @StrLastDt <> ''
			        SET 	@SqlEMakDt= ' AND B.RegDate <= ''' +@StrLastDt+ ''''
		END
	ELSE IF @strDateFlag = '2'
		BEGIN
			IF @StrStartDt <> ''
			        SET 	@SqlSMakDt= ' AND A.RecDate >= ''' +@strStartDt +''''
			IF @StrLastDt <> ''
			        SET 	@SqlEMakDt= ' AND A.RecDate <= ''' +@StrLastDt+ ''''
		END
	ELSE
		BEGIN
			SET 	@SqlSMakDt= ''
			SET 	@SqlEMakDt= ''
		END

--키워드
	DECLARE @SqlKeyWord     varchar(200)

	IF @StrCboKeyWord ='신청자명'
		SET 	@SqlKeyWord= 'AND B.UserName = ''' + @strTxtKeyWord+''' '
	ELSE IF @StrCboKeyWord='입금자명'
		SET 	@SqlKeyWord= 'AND A.RecNm = ''' + @strTxtKeyWord+''' '
	ELSE IF @StrCboKeyWord='등록자ID'
		SET 	@SqlKeyWord= 'AND B.UserID = ''' + @strTxtKeyWord+''' '
	ELSE IF @StrCboKeyWord='전화번호'
		SET 	@SqlKeyWord= 'AND B.HPhone Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord='물품명'
		SET 	@SqlKeyWord= 'AND B.BrandNmDt Like ''%' + @strTxtKeyWord+'%'' '
	ELSE IF @StrCboKeyWord=''
		SET	@SqlKeyWord=''


 --회원구분(제휴사)
        DECLARE @SqlPart        varchar(200)

	IF @StrPartner =''
		SET 	@SqlPart= ''
	ELSE IF @StrPartner='0'
		SET 	@SqlPart= 'AND (B.PartnerCode='+@strPartner +' Or B.PartnerCode is Null) '
        ELSE
		SET 	@SqlPart= 'AND B.PartnerCode='+@strPartner +''


 --개인/전문
        DECLARE @SqlSpecFlag    varchar(200)
        SET     @SqlSpecFlag = ' AND B.StateChk IN (''1'',''5'') '

	IF @strSpecFlag =''
                SET 	@SqlSpecFlag= ''
        ELSE IF @strSpecFlag = '0'
		SET 	@SqlSpecFlag= ' AND ( B.SpecFlag IS NULL OR B.SpecFlag IN ( ''0'', '''' ) ) '
        ELSE
		SET 	@SqlSpecFlag= ' AND B.SpecFlag='+@strSpecFlag +' '
/*
	--전문일 경우, 개인에서 전문으로 처리된 것은 빼고, 개인일 경우에는 개인에서 전문으로 처리된 것도 포함한다.
	IF @strSpecFlag ='1'
		SET 	@SqlSpecFlag= @SqlSpecFlag + ' AND B.StateChk <> ''6'' '
	ELSE IF @strSpecFlag = '0'
		SET 	@SqlSpecFlag= ' AND ( ( B.SpecFlag IS NULL OR B.SpecFlag IN ( ''0'', '''' ) ) OR ( B.SpecFlag=''1'' AND B.StateChk=''6'' ) ) '
*/

--인터넷/신문
	DECLARE @SqlPLineKeyNo  varchar(200)

	IF @strPLineKeyNo = '0'
		SET	@SqlPLineKeyNo= ' AND (B.PLineKeyNo IS NULL OR B.PLineKeyNo = '''') '
	ELSE IF  @strPLineKeyNo = '1'
		SET	@SqlPLineKeyNo= ' AND B.PLineKeyNo <> '''' '
	ELSE
		SET	@SqlPLineKeyNo= ''

--결제여부
        DECLARE @SqlPrnAmtOk    varchar(200)

	IF @strPrnAmtOk = ''
		SET 	@SqlPrnAmtOk= ''
        ELSE
		SET 	@SqlPrnAmtOk= ' AND A.PrnAmtOk ='+@strPrnAmtOk


 --안전/일반 구분
        DECLARE @SqlEscrowYN    varchar(200)

	IF @strEscrowYN = ''
		SET 	@SqlEscrowYN= ''
        ELSE
		SET 	@SqlEscrowYN= ' AND B.EscrowYN = '''+@strEscrowYN+''''

 --정렬순서 구분
        DECLARE @SqlOrderFlag   varchar(200)

	IF @strOrderFlag = '2'
		SET 	@SqlOrderFlag= ' ORDER BY A.GrpSerial DESC, B.AdId DESC '
        ELSE
		SET 	@SqlOrderFlag= ' ORDER BY B.AdId DESC, A.GrpSerial DESC '


--판매물품/구매물품
	DECLARE @Table          varchar(20)

	IF @StrDivInfo ='SELL'
		SET @Table = ' GoodsSubSale '
	ELSE
		SET @Table = ' GoodsSubBuy '

--전체검색
	DECLARE @SqlAll         varchar(1000)
        SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord +@SqlPart + @SqlSpecFlag  + @SqlPLineKeyNo + @SqlPrnAmtOk  + @SqlEscrowYN

--전체쿼리
        DECLARE @strQuery       nvarchar(3000)
        SET @strQuery =
        		--자료수 카우트
        		'Select Count(B.AdId) ' +
        		'From '+
			'(	Select AdId, A.ChargeKind, A.RecNm, B.PrnAmt, B.PrnAmt2, B.PrnAmtOk, A.GrpSerial, Convert(char(8),A.RecDate,112) as RecDate, A.BankNm, A.AccountNum, A.inipayTid ' +
        		'	From RecCharge A with (Nolock), RecChargeDetail B with (Nolock) ' +
			'	Where A.grpSerial=B.GrpSerial AND (A.inipayTid IS NOT NULL OR A.ChargeKind = ''6'') ' +
        		') A right join ' +
        		'(	Select Distinct A.AdId,Convert(char(8),A.RegDate,112) as RegDate, A.UserID,A.UserName,A.HPhone,'+
			'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink, EscrowYN, Keyword,' +
        		'	StateChk,A.PartnerCode, A.OptLocalBranch, A.LocalBranch, A.SpecFlag, A.DelFlag,B.BrandNmDt, A.PLineKeyNo, A.PrnCnt, A.CUID ' +
        		'	From GoodsMain A with (Nolock), ' + @Table + ' B with (Nolock) ' +
        		'	Where A.AdId=B.AdId ' +  @SqlLocalGoods +
        		') B on A.AdId = B.AdId Where 1=1 AND B.StateChk <> ''6'' ' + @SqlAll + '; ' +
        		--실제 자료
        		'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
        		' 	B.AdId, B.RegDate, B.UserName, ' +
        		'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink, EscrowYN,Keyword,'+
        		'	StateChk,B.PartnerCode, OptLocalBranch, LocalBranch, SpecFlag, DelFlag,B.BrandNmDt,'+
			'	A.ChargeKind, A.RecNm, A.PrnAmt, A.PrnAmt2, A.PrnAmtOk, A.GrpSerial, A.RecDate, A.BankNm, A.AccountNum, A.inipayTid, B.PLineKeyNo, B.PrnCnt, B.LocalSite ' +
        		'From '+
			'(	Select AdId, A.ChargeKind, A.RecNm, B.PrnAmt, B.PrnAmt2, B.PrnAmtOk, A.GrpSerial, Convert(char(8),A.RecDate,112) as RecDate, A.BankNm, A.AccountNum, A.inipayTid ' +
        		'	From RecCharge A with (Nolock), RecChargeDetail B with (Nolock) ' +
			'	Where A.grpSerial=B.GrpSerial AND (A.inipayTid IS NOT NULL OR A.ChargeKind = ''6'') ' +
        		') A right join ' +
        		'(	Select Distinct A.AdId,Convert(char(8),A.RegDate,112) as RegDate, A.UserID,A.UserName,A.HPhone,'+
			'	A.OptPhoto, A.OptRecom, A.OptUrgent, A.OptMain, A.OptHot, A.OptPre, A.OptSync, A.OptKind, A.OptLink, A.EscrowYN, A.Keyword,' +
        		'	StateChk,A.PartnerCode, A.OptLocalBranch, A.LocalBranch, A.SpecFlag, A.DelFlag,B.BrandNmDt, A.PLineKeyNo, A.PrnCnt, A.LocalSite,A.CUID ' +
        		'	From GoodsMain A with (Nolock), ' + @Table + ' B with (Nolock) ' +
        		'	Where A.AdId=B.AdId '  + @SqlLocalGoods +
        		') B on A.AdId = B.AdId Where 1=1 AND B.StateChk <> ''6'' ' + @SqlAll + @SqlOrderFlag
--                      ' Order by B.AdId Desc, A.GrpSerial DESC '
--      PRINT(@strQuery)
        execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcTotalList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
ProcTotalList 1,20,'ALL','SELL','2016-01-01','2016-07-01','','','',''
*/
CREATE PROC [dbo].[ProcTotalList]
(
	@Page						int
,	@PageSize				int
,	@StrChargeKind	varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo			varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt			varchar(10)
,	@StrLastDt			varchar(10)
,	@StrCboKeyWord	varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord	varchar(50)	-- 키워드
, @StrPartner			char(10)
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
)
AS

-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND A.ChargeKind='+@strChargeKind +''
		END
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),B.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),B.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND B.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND A.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND B.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND B.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END

--회원구분(제휴사)               
  DECLARE @SqlPart varchar(200)
	IF @StrPartner =''
		BEGIN			
			SET 	@SqlPart= ''
		END
	ELSE IF @StrPartner='0'  
		BEGIN
			SET 	@SqlPart= 'AND (B.PartnerCode='+@strPartner +' Or B.PartnerCode is Null) '
		END
  ELSE  
		BEGIN
			SET 	@SqlPart= 'AND B.PartnerCode='+@strPartner +''
		END

--개인,전문구분
  DECLARE @SqlSpecFlag varchar(200);	SET 	@SqlSpecFlag= ''

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord+@SqlPart+@SqlSpecFlag
		END

--판매물품/구매물품 
DECLARE @Table varchar(20)

IF @StrDivInfo ='SELL' 
	SET @Table = ' GoodsSubSale '
ELSE
	SET @Table = ' GoodsSubBuy '

-- 키워드 검색쿼리 끝


DECLARE @strQuery nvarchar(2000)
SET @strQuery =
			--자료수 카운트 
			'Select Count(B.AdId) ' +
			'From '+
			'(	Select AdId, A.ChargeKind, A.RecNm, B.PrnAmt,B.PrnAmtOk ' +
			'	From RecCharge A with (Nolock) ' +
			'	, RecChargeDetail B with (Nolock) ' +
			'	Where A.grpSerial=B.GrpSerial ' +
			') A right join ' +
			'(	Select Distinct A.AdId,Convert(varchar(10),A.RegDate,112) as RegDate, A.UserID,A.UserName,A.Phone,'+
			'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink,' +
			'	StateChk,A.PartnerCode, A.OptLocalBranch, A.LocalBranch, A.SpecFlag, A.DelFlag,B.BrandNmDt ' +
			'	From GoodsMain A with (Nolock) ' +
			'		, ' + @Table + ' B with (Nolock) ' +  
			'	Where A.AdId=B.AdId ' +  
			'		 ) B on A.AdId = B.AdId Where 1=1 ' + @SqlAll + '; ' +

			--자료 Select

			'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) + 
			' B.AdId,Convert(varchar(10),B.RegDate,112) as RegDate, B.UserName, ' +
			'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink,'+
			'	StateChk,B.PartnerCode, OptLocalBranch, LocalBranch, SpecFlag, DelFlag,B.BrandNmDt,'+
			'	A.ChargeKind, A.RecNm, A.PrnAmt, A.PrnAmtOk ' +
			'From '+
			'(	Select AdId, A.ChargeKind, A.RecNm, B.PrnAmt,B.PrnAmtOk ' +
			'	From RecCharge A with (Nolock) ' +
			'	, RecChargeDetail B with (Nolock) ' +
			'	Where A.grpSerial=B.GrpSerial ' +
			') A right join ' +
			'(	Select Distinct A.AdId,Convert(varchar(10),A.RegDate,112) as RegDate, A.UserID,A.UserName,A.Phone,'+
			'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink,' +
			'	StateChk,A.PartnerCode, A.OptLocalBranch, A.LocalBranch, A.SpecFlag, A.DelFlag,B.BrandNmDt, A.CUID  ' +
			'	From GoodsMain A with (Nolock) ' +
			'		, ' + @Table + ' B with (Nolock) ' + 
			'	Where A.AdId=B.AdId '  + 
			'		 ) B on A.AdId = B.AdId Where 1=1 ' + @SqlAll + 
			' Order by B.AdId Desc '

PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcTotalPur]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 총구매내역 - 관리자페이지  프로시저
	제작자	: 이창연
	제작일	: 2002-03-20
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcTotalPur]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND B.ChargeKind='+@strChargeKind +''
		END
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),B.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),B.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
               
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND B.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND B.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND B.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1500)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(G.Adid) FROM GoodsMain G, Sale_BuyerInfo B  ' +
			' WHERE G.Adid = B.Adid AND DelFlag = ''0'' AND G.StateChk = ''1'' AND G.RegAmtOk = ''1''  AND B.SaleChk <> ''1''  '+
                                                ' AND B.BuyChk <>''1'' AND B.DelFlagSale <> ''1'' AND B.DelFlagBuy <>''1'' AND NOT( B.ChargeKind=''2''  AND B.ReceiveChk=''0'' )  ' + @SqlAll + ';  ' +
			'  SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'   G.AdId,Convert(varchar(10),B.RegDate,120) as RegDate,G.Code1,B.WishAmt,B.UserName, G.RecNm,  ' +
			'   B.ChargeKind, B.ReceiveChk, B.SendChk, B.Serial, G.SpecFlag ' +
			'   FROM GoodsMain G, Sale_BuyerInfo B ' +
			'   WHERE G.Adid = B.Adid  AND DelFlag = ''0'' AND G.StateChk = ''1'' AND G.RegAmtOk = ''1'' AND B.SaleChk <> ''1''   '+
                                                '   AND B.BuyChk <>''1''  AND B.DelFlagSale <> ''1'' AND B.DelFlagBuy <>''1'' AND NOT( B.ChargeKind=''2''  AND B.ReceiveChk=''0'' )  ' + @SqlAll +
			'  ORDER BY B.RegDate DESC ' + ';  ' +
			'  SELECT Sum(Cast(B.WishAmt as decimal)) As TotalSum ' +
			'  FROM GoodsMain G, Sale_BuyerInfo B ' +
			'  WHERE G.Adid = B.Adid   AND DelFlag = ''0'' AND G.StateChk = ''1'' AND G.RegAmtOk = ''1'' AND B.SaleChk <> ''1''  '+
                                                '  AND B.BuyChk <>''1''  AND B.DelFlagSale <> ''1'' AND B.DelFlagBuy <>''1'' AND NOT( B.ChargeKind=''2''  AND B.ReceiveChk=''0'' )  ' + @SqlAll + '  '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcTotalReq]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 총신청내역 - 관리자페이지  프로시저
	제작자	: 이창연
	제작일	: 2002-03-20
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcTotalReq]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND G.ChargeKind='+@strChargeKind +''
		END
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1500)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(G.Adid) FROM GoodsMain G, GoodsSubSale S, CatCode C  ' +
			'WHERE G.Adid = S.Adid And G.Code3 = C.Code3 AND G.DelFlag = ''0'' AND G.StateChk = ''1'' AND G.RegAmtOk = ''1''  ' + @SqlAll + ';  ' +
			' SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.Adid, Convert(varchar(10),G.RegDate,120) as RegDate, C.Code3, C.CodeNm3,  S.WishAmt, G.UserName, G.RecNm,  ' +
			'  G.OptType, G.OptKind, G.ChargeKind, G.PrnAmtOk, G.PrnAmt  ' +
			'  FROM GoodsMain G, GoodsSubSale S, CatCode C ' +
			'  WHERE G.Adid = S.Adid And G.Code3 = C.Code3   AND G.DelFlag = ''0'' AND G.StateChk = ''1'' AND G.RegAmtOk = ''1''  ' + @SqlAll + 
			'  ORDER BY G.Adid DESC ' + '; ' +
			' SELECT Sum(G.PrnAmt) As TotalAmt ' +
			' FROM GoodsMain G, GoodsSubSale S, CatCode C ' +
			' WHERE G.Adid = S.Adid And G.Code3 = C.Code3   AND G.DelFlag = ''0'' AND G.StateChk = ''1'' AND G.RegAmtOk = ''1''  ' + @SqlAll + ' '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procTrans_Save_3mm]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC  [dbo].[procTrans_Save_3mm]
AS

--=====================================================================================
-- 1개월 지난 광고 이동
--=====================================================================================

DECLARE @bigoDate varchar(10)
--SET @bigoDate = Convert(Varchar(10), DATEADD(dd, -7, getdate()), 120)
SET @bigoDate = Convert(Varchar(10), DATEADD(dd, -30, getdate()), 120)


--임시테이블 생성

Select AdId INTO #Tmp_AdId
From GoodsMain
where RegEnDate <  @bigoDate AND PLineKeyNo is Null
AND PrnEnDate < @bigoDate
AND AdId NOT IN (
  SELECT AdId FROM Sale_BuyerInfo
    WHERE StateChk = '1' 
    AND (
      (BuyChk = '0' AND SaleChk = '0' AND RemitChk <> '2' AND RefundChk <> '2')
      OR
      (ReceiveChk = '1' AND SaleChk = '1' AND RefundChk <> '2')
    )
)


--GoodsMain 의 3개월 이전 광고 _Save 테이블로 이동
insert into GoodsMain_Save
Select *
From GoodsMain 
Where AdId IN (Select AdId From #Tmp_AdId)

-- GoodsMain 의 3개월 이전 광고 삭제
Delete
From GoodsMain
Where AdId IN (Select AdId From #Tmp_AdId)

-- GoodsMain에 없는 광고들 GoodsSubSale_Save로 이동
insert into GoodsSubSale_Save
Select *
From GoodsSubSale
Where AdId IN (Select AdId From #Tmp_AdId)


Delete 
From GoodsSubSale
Where AdId IN (Select AdId From #Tmp_AdId)


-- GoodsMain에 없는 광고들 GoodsSubBuy_Save로 이동
Insert Into GoodsSubBuy_Save
Select *
From GoodsSubBuy 
Where AdId IN (Select AdId From #Tmp_AdId)

Delete
From GoodsSubBuy 
Where AdId IN (Select AdId From #Tmp_AdId)


-- GoodsMain에 없는 광고들 GoodsMergeText_Save로 이동
Insert Into GoodsMergeText_Save
Select *
From GoodsMergeText
Where AdId IN (Select AdId From #Tmp_AdId)

Delete
From GoodsMergeText
Where AdId IN (Select AdId From #Tmp_AdId)


-- GoodsMain에 없는 광고들 GoodsPic_Save로 이동
Insert Into GoodsPic_Save
Select *
From GoodsPic 
Where AdId IN (Select AdId From #Tmp_AdId)

-- 삭제할 이미지데이터 쌓기
--TRUNCATE TABLE DELETE_GOODSPIC

Insert Into DELETE_GOODSPIC
Select AdId
,PicIdx
,PicImage
,GETDATE()
From GoodsPic 
Where AdId IN (Select AdId From #Tmp_AdId)

Delete
From GoodsPic 
Where AdId IN (Select AdId From #Tmp_AdId)
GO
/****** Object:  StoredProcedure [dbo].[procTrans_Save_3mm2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC  [dbo].[procTrans_Save_3mm2]
AS

--=====================================================================================
-- 3개월 지난 광고 이동
--=====================================================================================

DECLARE @bigoDate varchar(10)
SET @bigoDate = Convert(Varchar(10), DATEADD(mm, -3, getdate()), 120)

Select @bigoDate

--GoodsMain 의 3개월 이전 광고 _Save 테이블로 이동
insert into GoodsMain_Save
Select *
From GoodsMain
where RegDate <  @bigoDate AND PLineKeyNo is Null

-- GoodsMain 의 3개월 이전 광고 삭제
Delete
From GoodsMain
Where Adid in (Select Adid From GoodsMain_Save)

-- GoodsMain에 없는 광고들 GoodsSubSale_Save로 이동
insert into GoodsSubSale_Save
Select *
From GoodsSubSale
where Adid not in (Select Adid From GoodsMain Where PLineKeyNo is Null)

Delete 
From GoodsSubSale
where Adid not in (Select Adid From GoodsMain Where PLineKeyNo is Null)

-- GoodsMain에 없는 광고들 GoodsSubBuy_Save로 이동
Insert Into GoodsSubBuy_Save
Select *
From GoodsSubBuy 
where Adid not in (Select Adid From GoodsMain)

Delete
From GoodsSubBuy 
where Adid not in (Select Adid From GoodsMain)


-- GoodsMain에 없는 광고들 GoodsMergeText_Save로 이동
Insert Into GoodsMergeText_Save
Select *
From GoodsMergeText
where Adid not in (Select Adid From GoodsMain)

Delete
From GoodsMergeText
where Adid not in (Select Adid From GoodsMain)


-- GoodsMain에 없는 광고들 GoodsPic_Save로 이동
Insert Into GoodsPic_Save
Select *
From GoodsPic 
where Adid not in (Select Adid From GoodsMain)

Delete
From GoodsPic 
where Adid not in (Select Adid From GoodsMain)
GO
/****** Object:  StoredProcedure [dbo].[ProcUncollec]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 미수내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-14
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcUncollec]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND G.ChargeKind='+@strChargeKind +''
		END
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
 --개인,전문구분
              DECLARE @SqlSpecFlag varchar(200)
	IF @strSpecFlag =''
		BEGIN			
			SET 	@SqlSpecFlag= ''
		END
              ELSE IF @strSpecFlag = '0'
		BEGIN
			SET 	@SqlSpecFlag= ' AND ( G.SpecFlag IS NULL OR G.SpecFlag IN ( ''0'', '''' ) ) '
		END
              ELSE  
		BEGIN
			SET 	@SqlSpecFlag= ' AND G.SpecFlag='+@strSpecFlag +' '
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlSpecFlag
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
SET @strQuery =
	CASE
		WHEN @StrDivInfo ='SELL' THEN
			'SELECT TOP 1 COUNT(G.Adid) FROM GoodsMain G, GoodsSubSale S, RecCharge R  ' +
			'WHERE G.Adid = S.Adid And G.GrpSerial = R.GrpSerial And G.PrnAmtOk=''2'' And G.IsUnpaid=''Y'' And G.IsUnpaidDate is Null ' + @SqlAll + ';  ' +
			'SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.PrnAmt,C.CodeNm1,G.UserName, G.RecNm,  ' +
			'  G.OptType,G.OptKind,G.ChargeKind, G.PrnAmtOK, G.StateChk, Convert(varchar(10),R.RecDate,120) as RecDate, G.SpecFlag ' +
			'  FROM GoodsMain G, GoodsSubSale S, RecCharge R, CatCode C ' +
			'  WHERE G.Adid=S.Adid And G.Code1=C.Code1 And  G.GrpSerial = R.GrpSerial And G.PrnAmtOk=''2'' And G.IsUnpaid=''Y'' And G.IsUnpaidDate is Null ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
		ELSE
			'SELECT TOP 1 COUNT(G.Adid) FROM GoodsMain G, GoodsSubBuy B, RecCharge R ' +
			'WHERE G.Adid = B.Adid And G.GrpSerial = R.GrpSerial And G.PrnAmtOk=''2'' And G.IsUnpaid=''Y'' And G.IsUnpaidDate is Null ' + @SqlAll + ';  ' +
			'  SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.PrnAmt,C.CodeNm1,G.UserName, G.RecNm,  ' +
			'  G.OptType,G.ChargeKind, G.PrnAmtOK, G.StateChk, Convert(varchar(10),R.RecDate,120) as RecDate, G.SpecFlag ' +
			'  FROM GoodsMain G, GoodsSubBuy B, RecCharge R, CatCode C ' +
			'  WHERE G.Adid = B.Adid And G.Code1=C.Code1 And  G.GrpSerial = R.GrpSerial And G.PrnAmtOk=''2'' And G.IsUnpaid=''Y'' And G.IsUnpaidDate is Null ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcUncollecList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 미수결제내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-14
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcUncollecList]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND G.ChargeKind='+@strChargeKind +''
		END
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
 --개인,전문구분
              DECLARE @SqlSpecFlag varchar(200)
	IF @strSpecFlag =''
		BEGIN			
			SET 	@SqlSpecFlag= ''
		END
              ELSE IF @strSpecFlag = '0'
		BEGIN
			SET 	@SqlSpecFlag= ' AND ( G.SpecFlag IS NULL OR G.SpecFlag IN ( ''0'', '''' ) ) '
		END
              ELSE  
		BEGIN
			SET 	@SqlSpecFlag= ' AND G.SpecFlag='+@strSpecFlag +' '
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlSpecFlag
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
SET @strQuery =
	CASE
		WHEN @StrDivInfo ='SELL' THEN
			'SELECT TOP 1 COUNT(G.Adid) FROM GoodsMain G, GoodsSubSale S ' +
			'WHERE G.Adid = S.Adid And G.IsUnpaid=''N'' And G.PrnAmtOk=''1'' And G.IsUnpaidDate is not Null  ' + @SqlAll + ';  ' +
			'SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate, C.CodeNm1, G.PrnAmt, G.UserName, G.RecNm,  ' +
			'  G.OptType,G.OptKind,G.ChargeKind, G.PrnAmtOK, G.StateChk, G.IsUnpaid, Convert(varchar(10),G.IsUnpaidDate,120) as IsUnpaidDate, G.SpecFlag ' +
			'  FROM GoodsMain G, GoodsSubSale S, CatCode C ' +
			'  WHERE G.Adid=S.Adid And G.Code1=C.Code1 And G.IsUnpaid=''N'' And G.PrnAmtOk=''1'' And G.IsUnpaidDate is not Null ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
		ELSE
			'SELECT TOP 1 COUNT(G.Adid) FROM GoodsMain G, GoodsSubBuy B ' +
			'WHERE G.Adid = B.Adid And G.IsUnpaid=''N'' And G.PrnAmtOk=''1'' And G.IsUnpaidDate is not Null ' + @SqlAll + ';  ' +
			'  SELECT Distinct TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate, C.CodeNm1, G.PrnAmt, G.UserName, G.RecNm,  ' +
			'  G.OptType,G.ChargeKind, G.PrnAmtOK, G.StateChk, G.IsUnpaid, Convert(varchar(10),G.IsUnpaidDate,120) as IsUnpaidDate, G.SpecFlag ' +
			'  FROM GoodsMain G, GoodsSubBuy B, CatCode C  ' +
			'  WHERE G.Adid = B.Adid And G.Code1=C.Code1 And G.IsUnpaid=''N'' And G.PrnAmtOk=''1'' And G.IsUnpaidDate is not Null ' + @SqlAll + ' ' +
			'  ORDER BY G.Adid DESC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcUpdate]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 수정내역 검색 프로시저
	제작자	: 이창연
	제작일	: 2002-03-14
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcUpdate]
(
	@Page			int
,	@PageSize		int
,	@StrChargeKind		varchar(10)	--결제방법선택(전체/무료/온라인/신용카드/휴대폰/E-Money)
,	@StrDivInfo		varchar(10)	--자료구분(팝니다/삽니다)
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(신청자명/입금자명/등록자 ID/전화번호)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlChargeKind varchar(200)
	IF @StrChargeKind ='ALL'
		BEGIN			
			SET 	@SqlChargeKind= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlChargeKind= 'AND C.ChargeKind='+@strChargeKind +''
		END
--2.기간
	DECLARE @SqlSMakDt	varchar(200)
	IF @StrStartDt = ''
		BEGIN
			SET 	@SqlSMakDt= ''
		END
	ELSE 
		BEGIN	
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),G.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),G.RegDate,112) <= ''' +@StrLastDt+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord ='신청자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND G.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='입금자명'
		BEGIN
			SET 	@SqlKeyWord= 'AND C.RecNm Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='등록자ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
	
	ELSE IF @StrCboKeyWord='전화번호'
		BEGIN
			SET 	@SqlKeyWord= 'AND G.Phone Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord=''
		BEGIN
			SET	@SqlKeyWord=''
		END
 --개인,전문구분
              DECLARE @SqlSpecFlag varchar(200)
	IF @strSpecFlag =''
		BEGIN			
			SET 	@SqlSpecFlag= ''
		END
              ELSE IF @strSpecFlag = '0'
		BEGIN
			SET 	@SqlSpecFlag= ' AND ( G.SpecFlag IS NULL OR G.SpecFlag IN ( ''0'', '''' ) ) '
		END
              ELSE  
		BEGIN
			SET 	@SqlSpecFlag= ' AND G.SpecFlag='+@strSpecFlag +' '
		END

--검색 테이블, 자료 구분
	DECLARE @SqlDivInfo varchar(20)
	IF @StrDivInfo ='SELL'
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 0 '
	END
	ELSE
	BEGIN
		SET @SqlDivInfo = ' And G.AdGbn = 1 '
	END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlChargeKind + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord + @SqlSpecFlag + @SqlDivInfo
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery nvarchar(2000)
SET @strQuery =
	--자료수 카우트
	'Select Count(G.AdId) ' +
	'From GoodsMain G with (Nolock) Left join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmtOk ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where G.ModDate is not null ' + @SqlAll + ';' +
	--실제 자료 
	'Select Top ' + CONVERT(varchar(10), @Page*@PageSize) +
	' G.AdId,Convert(varchar(10),G.RegDate,120) as RegDate,G.UserName,G.StateChk,G.SpecFlag,Convert(varchar(10),G.ModDate,120) as ModDate, ' +
	'	OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, G.OptKind, OptLink, ' +
	'	C.PrnAmt,C.PrnAmtOk, C.RecNm,C.ChargeKind,Convert(varchar(10),C.RecDate,120) as RecDate,D.CodeNm1 ' +
	'From GoodsMain G with (Nolock) Left join  ' +
	'	(Select A.GrpSerial, A.ChargeKind, A.RecDate, A.RecNm, B.AdId, B.PrnAmt, B.PrnAmtOk ' +
	'	From RecCharge A with (Nolock) inner join RecChargeDetail B with (Nolock) on A.GrpSerial = B.GrpSerial) C ' +
	'	on G.AdId = C.AdId inner join (Select Code1, CodeNm1 From CatCode with (Nolock) Group by Code1, CodeNm1) D ' +
	'	on G.Code1 = D.Code1 ' +
	'Where G.ModDate is not null ' + @SqlAll +
	'Order By G.AdId desc'

PRINT(@strQuery)
Execute sp_executesql @strQuery
GO
/****** Object:  StoredProcedure [dbo].[ProcUrgentList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcUrgentList]
(
	@StrLocal	varchar(2)	-- 지역코드
,	@AdultCode	char(1)
)
AS

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
		SET @SqlLocalGoods = '' 
	ELSE
		SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
				          '(Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ') ' +
				          ' OR B.ZipMain = ''전국'' ) '	
--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2415) '

	DECLARE @strQuery varchar(3000)
	SET @strQuery = ' SELECT B.Adid, S.BrandNmDt, S.WishAmt, S.GoodsQt, S.UseGbn, B.ZipMain, B.ZipSub, P.PicImage ' +
			' FROM GoodsMain B, GoodsSubSale S, GoodsPic P ' + 
			' WHERE B.AdId = S.AdId ' +
			' AND B.AdId*=P.AdId ' +
			' AND P.PicIdx=6 ' +
			' AND B.OptUrgent=1 ' +
			' AND B.PrnAmtOk=''1'' AND B.PrnEnDate >= GETDATE() ' +
			' AND B.StateChk=''1'' AND B.DelFlag=''0'' AND B.SaleOkFlag=''0'' ' + @SqlLocalGoods +  @SqlAdultCode +
			' ORDER BY B.AdId DESC '

--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcUsedTest]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcUsedTest]
(
	@MaxCount		varchar(5)
--,	@Option  		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(30)
,	@strSpecFlag		char(1)		--개인, 전문, 바자 구분
,	@StrLocal		char(2)		-- 지역코드
)
AS
--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1' 	SET @SqlPicCode = ' AND (PicIdx1 <> '''' Or PicIdx2<>'''' ) '
--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (UseGbn = '''+@UseCode +''' ) '
--개인,전문,바자구분
	DECLARE @SqlSpecFlag varchar(200)
	DECLARE @SqlBajaFlag varchar(100)
	IF @strSpecFlag = '1'		SET @SqlSpecFlag = ' AND B.SpecFlag = ''1'' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') '
	ELSE				SET @SqlSpecFlag = ' AND B.SpecFlag <> ''1'' AND B.StateChk NOT IN (''4'' , ''5'' , ''6'') '
--전체검색쿼리를 묶어서
	DECLARE @SqlAll varchar(500) ; SET @SqlAll = ''
	SET @SqlAll = @SqlPicCode + @SqlUseCode
--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalSite = ''
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalNew = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
--			IF @Option = '0'
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND L.LocalSite=' + @StrLocal + ') OR ' +
							' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
						' ) '
--			ELSE
			SET @SqlLocalNew = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ')  ' +
						' ) '
		END
	DECLARE @strQuery varchar(3000)
	DECLARE @HotCnt	int
	DECLARE @PrmCnt	int
--	SET @strQuery = 
--핫
	SET @strQuery =
			' SELECT COUNT(AdId) AS HotCnt  FROM ( ' +
			'   SELECT TOP ' + @MaxCount + 
			'   FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) , CatCode C WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			'   WHERE A.AdId = B.AdId ' +
			'   AND B.Code3 = C.Code3 ' +
			'   AND B.SaleOkFlag <> ''1'' ' +
			'   AND B.DelFlag <> ''3'' AND ' + @SqlLocalNew + @SqlSpecFlag +
			'   AND OptType = ''1'' '  +
			'   AND PrnAmtOk = ''1'' AND PrnEnDate >=GETDATE() ' +
			'   ORDER BY A.AdId DESC ' +
			' ) AS ListTable ' +
			' WHERE 1=1 ' + @SqlAll
	Select(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procUserBuyProdDetail]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 구입희망상품(상세설명)
제작자		: 이지만
제작일		: 2002-04-08
셜명		: 구입희망상품상세페이지
		
		exec procUserBuyProdDetail 2495329
*************************************************************************************/
CREATE PROC [dbo].[procUserBuyProdDetail]  (
@AdId		int			--상품등록번호
)
AS
set nocount on
DECLARE  @AdId2			varchar(100)
DECLARE  @SQL		 	varchar(2000)	
SET    	@AdId2     		='''' +  REPLACE(@AdId,'''','''''') + ''''
	
	     BEGIN		
		
	     UPDATE GoodsMain SET ViewCnt=ViewCnt+1 WHERE AdId=@AdId

	     SET   @SQL =	'SELECT   a.AdId ,a.BrandNmDt  , a.BrandNm , a.ProCorp , ' + ' ' +
			'	c.codeNm1 ,c.codeNm2 codeNm2,c.CodeNm3 , c.Code1, c.Code2, c.Code3  ,' + ' ' +
			'               a.DealAreaMain , a.DealAreaSub  ,  a.UseGbn , a.BuyAmt, a.GoodsQt , ' + ' ' +
			'	 a.ChargeCard, a.ChargeCash, a.ChargeAll, b.ZipMain  , b.ZipSub  ,   ' + ' ' +
			'	 b.UserID , a.Addr1, b.ipAddr, a.TagYN, CONVERT(VARCHAR(8000), a.Contents) AS Contents, a.DealPriceYN, B.CUID ' + ' ' +
			'	FROM GoodsSubBuy a WITH (NoLock, ReadUnCommitted), GoodsMain b WITH (NoLock, ReadUnCommitted), CatCode c WITH (NoLock, ReadUnCommitted)       ' + ' ' +
			'	WHERE 								       ' + ' ' +
			'		a.AdId = b.AdId						       ' + ' ' +
			'		AND a. AdID=' + @AdId2 +
			'		and b.code1=c.code1					       ' + ' ' +
			'		and b.code2=c.code2					       ' + ' ' +
			'		and b.code3=c.code3					       ' 
                  END
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procUserOtherProdList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[procUserOtherProdList]  (
	@GetCount		varchar(10)
,	@UserID			varchar(50)			
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(30)
,	@AdultCode		char(1)
,	@WishAmtGbn		char(1)
,	@OrderCode		char(1)
,	@StrLocal		char(2)		-- 지역코드
,	@CountChk		char(1)		
)
AS

--UserID
	DECLARE  @SqlUser varchar(50); SET @SqlUser = '''' +  REPLACE(@UserID,'''','''''') + ''''

--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1' SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' OR A.PicIdx2 <> '''' ) '

--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> '' SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

--WishAmtGbn
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''	
	IF      @WishAmtGbn = '0' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 AND (B.Code3 <> 131015) '
	Else IF  @WishAmtGbn = '1' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn = '2' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '
	Else IF  @WishAmtGbn = '3' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -4 '

--전체검색쿼리 묶음
	DECLARE @SqlAll	varchar(500)
	SET @SqlAll = @SqlEscrowYNCode + @SqlPicCode + @SqlUseCode + @SqlAdultCode + @SqlWishAmtGbn
	
--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode = '1'
		SET @SqlOrderCode = ' ORDER BY WishAmt Asc, A.AdId DESC '
	ELSE IF @OrderCode = '2'
		SET @SqlOrderCode = ' ORDER BY ViewCnt Desc, A.AdId DESC '
	ELSE
		SET @SqlOrderCode = ' ORDER BY B.RegDate DESC '	

--전체쿼리
	DECLARE @strQuery varchar(3000)	
	IF @CountChk = '1'
		BEGIN
			SET @strQuery           = ' SELECT  COUNT(A.AdId) Cnt' 
			SET @SqlOrderCode       = ''
		END
	ELSE
		BEGIN
			SET @strQuery           = ' SELECT TOP ' + @GetCount + '' + 	
                                                  ' A.AdId, A.BrandNmDt, A.BrandNm, A.WishAmt, CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'' AND B.LocalSite=' + @StrLocal + ') THEN B.OptKind ELSE '''' END AS OptKind, A.CardYN, A.UseGbn,  B.ZipMain, B.ZipSub, B.ViewCnt ' +
                                                  ', B.OptLocalBranch,  B.LocalBranch, B.UserID, CONVERT(char(10),B.RegDate,120) as  RegDate, Isnull(B.WooriID,'''') As WooriID , A.PicIdx1, A.PicIdx2, M.CNT AS AnswerCnt, B.EscrowYN, B.SpecFlag, P.PicImage, B.LocalSite, B.PLineKeyNo, S.UserId AS MiniShop, B.RegDate, B.Keyword ' +
                                                  ', B.CUID '
		END

	SET @strQuery = @strQuery +
			' FROM GoodsSubSale A WITH (NoLock), GoodsMain B WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock)' +
			' , (Select UserId From SellerMiniShop WITH (NoLock) WHERE Delflag=''0'') S ' + 
			' WHERE A.AdId = B.AdId AND B.AdId *=M.AdId AND B.AdId *= P.AdId AND B.UserId*=S.UserId ' +
			' AND B.DelFlag =''0''  ' +
			' AND B.StateChk =''1'' ' +
			' AND B.RegAmtOK =''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
--             		' AND B.PrnEnDate >= (getDate()-7) ' +
			' AND P.PicIdx = 6 ' +	
			' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) ' +
			' AND B.UserID = ' + @SqlUser  + @SqlAll + @SqlOrderCode
			
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procUserProdDetail]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--적용
CREATE PROC [dbo].[procUserProdDetail]  
(
	@AdId	varchar(100)	--상품등록번호
)
AS

DECLARE  @SQL	varchar(2000)	
BEGIN
set nocount on 
UPDATE GoodsMain SET ViewCnt=ViewCnt+1 WHERE AdId=@AdId

SET @SQL =	'SELECT   a.AdId, a.BrandNmDt, a.BrandNm, a.ProCorp,a.BrandState, ' +
		' a.UseYY, a.UseMM, a.UseGbn, c.Code1, c.Code2, c.Code3,  c.codeNm1,c.codeNm2,c.CodeNm3, ' +
		' a.SendAreaMain, a.SendAreaSub, a.WishAmt, a.BuyAmt, ' +
		' a.GoodsQt, a.SaleSendWay,  ' +
		' b.EscrowYN, b.UserID,b.UserName, b.Email, b.ZipMain, b.ZipSub, ' +
		' a.SendGbn, a.Etctext, a.SendCharge, a.CardYN, b.SpecFlag, d.PicImage AS PicImage, ' +
		' (CASE WHEN B.PrnAmtOk=''1'' THEN B.OptLink ELSE '''' END) AS OptLink, CONVERT(CHAR(10),b.PrnEnDate,120) AS PrnEnDate, a.ReAddr1 as Addr1, b.ipAddr, ISNULL(b.WooriID,'''') AS WooriID, ' +
		' CONVERT(CHAR(19),b.RegDate,120) AS RegDate, a.TagYN, B.LocalSite, B.ViewCnt, a.Contents, a.Scratch, a.AfterService, a.Origin, a.OriginCountry, a.LossGoods, b.PrnAmtOk, b.ShopName, b.BizNum, ' +
		' B.CUID as cuid ' + 
		' FROM GoodsSubSale a WITH (NoLock), GoodsMain b WITH (NoLock), CatCode c WITH (NoLock), ' +
		' GoodsPic d WITH (NoLock) ' +
		' WHERE ' +
		' a.AdId = b.AdId ' +
		' AND b. AdId=' + @AdId +
		' AND b.code1=c.code1 ' +
		' AND b.code2=c.code2 ' +
		' AND b.code3=c.code3 ' +
		' AND a.Adid*=d.AdId AND (d.picidx BETWEEN 1 AND 4) ' +
		' ORDER BY d.PicIdx '

END

--PRINT (@SQL)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procUserProdDetail_OldAd]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
작성자: 최봉기 (2008-09-08)
내용: 보관기간이 지난 매물정보 출력
*/

--적용
CREATE PROC [dbo].[procUserProdDetail_OldAd]  
(
	@AdId	varchar(100)	--상품등록번호
)
AS

DECLARE  @SQL	varchar(2000)	
BEGIN

UPDATE GoodsMain SET ViewCnt=ViewCnt+1 WHERE AdId=@AdId

SET @SQL =	'SELECT   a.AdId, a.BrandNmDt, a.BrandNm, a.ProCorp,a.BrandState, ' +
		' a.UseYY, a.UseMM, a.UseGbn, c.Code1, c.Code2, c.Code3,  c.codeNm1,c.codeNm2,c.CodeNm3, ' +
		' a.SendAreaMain, a.SendAreaSub, a.WishAmt, a.BuyAmt, ' +
		' a.GoodsQt, a.SaleSendWay,  ' +
		' b.EscrowYN, b.UserID,b.UserName, b.Email, b.ZipMain, b.ZipSub, ' +
		' a.SendGbn, a.Etctext, a.SendCharge, a.CardYN, b.SpecFlag, d.PicImage AS PicImage, ' +
		' (CASE WHEN B.PrnAmtOk=''1'' THEN B.OptLink ELSE '''' END) AS OptLink, CONVERT(CHAR(10),b.PrnEnDate,120) AS PrnEnDate, a.ReAddr1 as Addr1, b.ipAddr, ISNULL(b.WooriID,'''') AS WooriID, ' +
		' CONVERT(CHAR(19),b.RegDate,120) AS RegDate, a.TagYN, B.LocalSite, B.ViewCnt, a.Contents, a.Scratch, a.AfterService, a.Origin, a.OriginCountry, a.LossGoods, b.PrnAmtOk ' +
		',B.CUID ' +
		' FROM GoodsSubSale_Save a WITH (NoLock), GoodsMain_Save b WITH (NoLock), CatCode c WITH (NoLock), ' +
		' GoodsPic d WITH (NoLock) ' +
		' WHERE ' +
		' a.AdId = b.AdId ' +
		' AND b. AdId=' + @AdId +
		' AND b.code1=c.code1 ' +
		' AND b.code2=c.code2 ' +
		' AND b.code3=c.code3 ' +
		' AND a.Adid*=d.AdId AND (d.picidx BETWEEN 1 AND 4) ' +
		' ORDER BY d.PicIdx '

END

--PRINT (@SQL)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procUserProdDetail2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--적용
CREATE PROC [dbo].[procUserProdDetail2]  
(
	@AdId	varchar(100)	--상품등록번호
)
AS

DECLARE  @SQL	varchar(2000)	
BEGIN

UPDATE GoodsMain SET ViewCnt=ViewCnt+1 WHERE AdId=@AdId

SET @SQL =	'SELECT   a.AdId, a.BrandNmDt, a.BrandNm, a.ProCorp,a.BrandState, ' +
		' a.UseYY, a.UseMM, a.UseGbn, c.Code1, c.Code2, c.Code3,  c.codeNm1,c.codeNm2,c.CodeNm3, ' +
		' a.SendAreaMain, a.SendAreaSub, a.WishAmt, a.BuyAmt, ' +
		' a.GoodsQt, a.SaleSendWay,  ' +
		' b.EscrowYN, b.UserID,b.UserName, b.Email, b.ZipMain, b.ZipSub, ' +
		' a.SendGbn, a.Etctext, a.SendCharge, a.CardYN, b.SpecFlag, d.PicImage AS PicImage, ' +
		' (CASE WHEN B.PrnAmtOk=''1'' THEN B.OptLink ELSE '''' END) AS OptLink, CONVERT(CHAR(10),b.PrnEnDate,120) AS PrnEnDate, a.ReAddr1 as Addr1, b.ipAddr, ISNULL(b.WooriID,'''') AS WooriID, ' +
		' CONVERT(CHAR(19),b.RegDate,120) AS RegDate, a.TagYN, B.LocalSite, B.ViewCnt, a.Contents, a.Scratch, a.AfterService, a.Origin, a.OriginCountry, a.LossGoods, b.PrnAmtOk, b.ShopName, b.BizNum, ' +
		' B.CUID as cuid ' + 
		' FROM vi_GoodsSubSale a WITH (NoLock), vi_GoodsMain b WITH (NoLock), CatCode c WITH (NoLock), ' +
		' GoodsPic d WITH (NoLock) ' +
		' WHERE ' +
		' a.AdId = b.AdId ' +
		' AND b. AdId=' + @AdId +
		' AND b.code1=c.code1 ' +
		' AND b.code2=c.code2 ' +
		' AND b.code3=c.code3 ' +
		' AND a.Adid*=d.AdId AND (d.picidx BETWEEN 1 AND 4) ' +
		' ORDER BY d.PicIdx '

END

--PRINT (@SQL)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procUserThemeCate]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: Main&List 
제작자		: 이지만
제작일		: 2002-04-08
셜명		: 테마카테고리
		
*************************************************************************************/
CREATE PROC [dbo].[procUserThemeCate]  (
	@KeyWord	 varchar(50) --키워드
)
AS
DECLARE  @KeyWord2		varchar(100)
DECLARE  @SQL		 	varchar(2000)	
SET 	@KeyWord2 		= ' LIKE ''%' + REPLACE(@KeyWord,'''','''''') + '%''' 
	
	     BEGIN		
		
	     SET   @SQL =	'SELECT    a.AdId, a.BrandNmDt, a.UseGbn,	b.ZipMain,	' + ' ' +
			 '	 c.codeNm1,c.codeNm2,c.CodeNm3,			' + ' ' +
			 '	 a.WishAmt, a.BuyAmt,a.CardYN,  a.PicIdx1, a.PicIdx2,	' + ' ' +
			 '	 b.OptType,b.PrnAmt, b.EscrowYN, convert(Char(10),b.Regdate,120) as  Regdate,  b.UserID , b.CUID ' + ' ' +
			 '	FROM GoodsSubSale a WITH (NoLock, ReadUnCommitted), GoodsMain b WITH (NoLock, ReadUnCommitted), CatCode c WITH (NoLock, ReadUnCommitted)					' + ' ' +
			 '	WHERE 									' + ' ' +
			'		a.AdId  =  b.AdId 							' + ' ' +
			 '		and  b.code1=c.code1							' + ' ' +
			 '		and b.code2=c.code2							' + ' ' +
			 '		and b.code3=c.code3							' + ' ' +
			'		and  b.DelFlag =''0'' 							' + ' ' +
			'		and  b.StateChk =''1'' 				' + ' ' +
			 '		AND ( a.BrandNm ' + @KeyWord2 +  ' or a.BrandNmDt ' + @KeyWord2 +  ' or c.codeNm1 ' + @KeyWord2 +  ' or  c.CodeNm2  ' + @KeyWord2 +  '  or  c.CodeNm3  ' +  @KeyWord2 +  ' )  '
                                         
		
                  END
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[ProcZipCount]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcZipCount]
(
	@ZipMain		Varchar(50)
,	@ZipSub		        Varchar(50)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@ListGbnCode		varchar(10)
,	@AdultCode		char(1)
,	@AdGbn			char(1)
,	@Option			Varchar(6)
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)
,	@WishAmtGbn		char(1)
,	@OrderCode		char(1)
,	@UseCode		varchar(30)
,	@StrLocal		char(2)
)
AS
--ZipCode
	DECLARE @SqlZipCode varchar(100)
	IF @ZipMain =''		SET 	@SqlZipCode= ' '
	ELSE  
		BEGIN
                            IF @ZipSub=''	SET 	@SqlZipCode = ' AND B.ZipMain = '''+@ZipMain+''' '
		                ELSE		SET 	@SqlZipCode = ' AND B.ZipMain = '''+@ZipMain+''' AND B.ZipSub LIKE '''+@ZipSub+'%'' '
		END
--Code1값
	DECLARE @SqlstrCode1 varchar(100)
	IF @StrCode1=''		SET 	@SqlstrCode1 = ''
	ELSE  			SET 	@SqlstrCode1 = ' AND B.code1='+@StrCode1 +''

--Code2값
	DECLARE @SqlstrCode2 varchar(100)
	IF @StrCode2=''		SET 	@SqlstrCode2 = ''
	ELSE  			SET 	@SqlstrCode2 = ' AND B.code2='+@StrCode2 +''

--Code3값
	DECLARE @SqlstrCode3 varchar(100)
	IF @StrCode3=''		SET 	@SqlstrCode3 = ''
	ELSE  			SET 	@SqlstrCode3 = ' AND B.code3='+@StrCode3 +''

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500); SET @SqlLocalGoods = '' 

--ListGbnCode(주간등록리스트/지역물품리스트)
	DECLARE @SqlListGbnCode varchar(100); SET @SqlListGbnCode=''
	IF @ListGbnCode='NewList'
	--BEGIN
		SET @SqlListGbnCode = ' AND B.RegDate > GETDATE()-7 '
		--IF @StrLocal ='0'	SET @SqlLocalGoods = '' 
		--ELSE			SET @SqlLocalGoods = ' AND B.ShowLocalSite=' + @StrLocal + ' '
	--END
	Else If @ListGbnCode='free'
		SET @SqlListGbnCode = ' AND (B.Code3 <> 131015) '


--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

--Option
	DECLARE @SqlCondition varchar(200); SET @SqlCondition = ''
	IF @Option <> ''		
		SET @SqlCondition = ' AND ' + @Option + '=1  AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() AND B.LocalSite=' + @StrLocal
	ELSE
		SET @SqlCondition = ''

--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode사진여부
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '

--WishAmtGbn
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''	
	IF      @WishAmtGbn='0'        	--무료	 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 AND (B.Code3 <> 131015) '
	Else IF  @WishAmtGbn='1' 	--교환 
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn='2'	--가격협의 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '
	Else IF  @WishAmtGbn='3'        --무료,교환,가격협의 뺀 리스트 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt > 0  '
	Else IF   @WishAmtGbn='4'       --만원물품(임시) 2005-07-12 추가
		SET @SqlWishAmtGbn = '  AND (A.WishAmt > 0 AND A.WishAmt <= 10000) '	
	Else IF   @WishAmtGbn='5'       --조건부무료 2007-05-28 추가
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -4 '			

--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

--AllSql
	DECLARE @SqlAll	varchar(500)
	SET @SqlAll = @SqlZipCode + @SqlstrCode1 + @SqlstrCode2  + @SqlstrCode3 + @SqlListGbnCode + @SqlAdultCode +  @SqlCondition +@SqlEscrowYNCode + @SqlPicCode + @SqlUseCode + @SqlLocalGoods

--strQuery
	DECLARE @strQuery varchar(3000)
	IF @AdGbn = '1' 
		SET @strQuery = ' Select COUNT(B.AdId) AS Cnt '+
				' FROM GoodsSubBuy A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' +
				' WHERE A.AdId = B.AdId ' +
				' AND B.DelFlag = ''0'' AND B.StateChk=''1'' ' +
				' AND (B.RegDate > DATEADD(dd,-31,GETDATE()) OR B.PrnEnDate >= GETDATE()) ' +
				' AND B.SaleOkFlag <> ''1'' ' + @SqlAll				
	ELSE
		SET @strQuery =  ' Select COUNT(B.AdId) AS Cnt '+
				' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted), GoodsPic P WITH (NoLock)  ' + 
				' WHERE A.AdId = B.AdId AND B.AdId *= P.AdId   ' +
				' AND B.DelFlag = ''0'' AND B.StateChk=''1'' AND B.RegAmtOk = ''1'' ' +
				' AND P.PicIdx = 6 ' +
				' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) ' +
				' AND B.SaleOkFlag <> ''1'' ' + @SqlAll  + @SqlWishAmtGbn

--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcZipList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcZipList]
(
	@GetCount		int
,	@ZipMain		varchar(50)
,	@ZipSub		        varchar(50)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@ListGbnCode		varchar(10)
,	@AdultCode		char(1)
,	@AdGbn			char(1)
,	@Option			varchar(6)
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)
,	@WishAmtGbn		char(1)
,	@OrderCode		char(1)
,	@UseCode		varchar(30)
,	@StrLocal		char(2)
)
AS

--ZipCode
	DECLARE @SqlZipCode varchar(100)
	IF @ZipMain=''		SET 	@SqlZipCode= ' '
	ELSE  
		BEGIN
                            IF @ZipSub=''	SET 	@SqlZipCode= ' AND B.ZipMain = '''+@ZipMain+''' '
		ELSE		SET 	@SqlZipCode= ' AND B.ZipMain = '''+@ZipMain+''' AND B.ZipSub LIKE '''+@ZipSub+'%'' '
		END
--Code1값
	DECLARE @SqlstrCode1 varchar(100)
	IF @StrCode1=''		SET 	@SqlstrCode1= ''
	ELSE  			SET 	@SqlstrCode1= ' AND B.code1='+@StrCode1 +''

--Code2값
	DECLARE @SqlstrCode2 varchar(100)
	IF @StrCode2=''		SET 	@SqlstrCode2= ''
	ELSE  			SET 	@SqlstrCode2= ' AND B.code2='+@StrCode2 +''

--Code3값
	DECLARE @SqlstrCode3 varchar(100)
	IF @StrCode3=''		SET 	@SqlstrCode3= ''
	ELSE  			SET 	@SqlstrCode3= ' AND B.code3='+@StrCode3 +''

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(500); SET @SqlLocalGoods = '' 

--ListGbnCode(주간등록리스트/지역물품리스트)
	DECLARE @SqlListGbnCode varchar(100); SET @SqlListGbnCode=''
	IF @ListGbnCode='NewList'
	--BEGIN
		SET @SqlListGbnCode = ' AND B.RegDate > GETDATE()-7 '
		--IF @StrLocal ='0'	SET @SqlLocalGoods = '' 
		--ELSE			SET @SqlLocalGoods = ' AND B.ShowLocalSite=' + @StrLocal + ' '
	--END
	Else If @ListGbnCode='free'
		SET @SqlListGbnCode = ' AND (B.Code3 <> 131015) '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode= '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

--Option
	DECLARE @SqlCondition varchar(200); SET @SqlCondition = ''
	IF @Option <> ''		
		SET @SqlCondition = ' AND ' + @Option + '=1  AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() AND B.LocalSite=' + @StrLocal
	ELSE
		SET @SqlCondition = ''

--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode='1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '

--WishAmtGbn
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''
	IF      @WishAmtGbn='0'        	--무료	 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 AND (B.Code3 <> 131015) '
	Else IF  @WishAmtGbn='1' 	--교환 
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn='2'	--가격협의 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '
	Else IF  @WishAmtGbn='3'        --무료,교환,가격협의 뺀 리스트 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt > 0  '
	Else IF   @WishAmtGbn='4'       --만원물품(임시) 2005-07-12 추가
		SET @SqlWishAmtGbn = '  AND (A.WishAmt > 0 AND A.WishAmt <= 10000) '	
	Else IF   @WishAmtGbn='5'       --조건부무료 2007-05-28 추가
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -4 '		

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	--가격	
	IF @OrderCode='1'
		BEGIN
		IF @AdGbn='1'	SET @SqlOrderCode = ' ORDER BY BuyAmt Asc, A.AdId DESC '			
		ELSE		SET @SqlOrderCode = ' ORDER BY WishAmt Asc, A.AdId DESC '
		END
	--조회	
	ELSE IF @OrderCode='2'	SET @SqlOrderCode = ' ORDER BY ViewCnt DESC '
	--RegDate
	ELSE			SET @SqlOrderCode = ' ORDER BY B.RegDate DESC ' 

--UseCode
	DECLARE @SqlUseCode varchar(100) ; SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND (A.UseGbn = '''+@UseCode +''' ) '

--SqlAll
	DECLARE @SqlAll	varchar(500)
	SET @SqlAll = @SqlZipCode + @SqlstrCode1 + @SqlstrCode2  + @SqlstrCode3 + @SqlListGbnCode + @SqlAdultCode + @SqlCondition +@SqlEscrowYNCode + @SqlPicCode + @SqlUseCode + @SqlLocalGoods

--strQuery
	DECLARE @strQuery varchar(3000)
	DECLARE @strTop varchar(100)
	
	IF @GetCount = 0 
		SET @strTop = ' Select '	
	ELSE
		SET @strTop = ' Select TOP '+ CONVERT(varchar(10), @GetCount)

	IF @AdGbn = '1'	-- 구매

		SET @strQuery =  @strTop +
				' A.AdId, A.BrandNmDt, A.BuyAmt AS WishAmt, A.UseGbn, '+
				' B.UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
				' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
				' B.OptType, B.OptList, B.OptPhoto, B.OptRecom, B.OptUrgent, B.OptMain, B.OptHot, B.OptPre, B.OptSync,' +
				' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub, B.ViewCnt, A.buyAmt, '+
				' B.EscrowYN, '''' AS PicIdx1, '''' AS PicIdx2, B.SaleOkFlag, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, B.LocalSite, B.PLineKeyNo, B.RegDate, B.Keyword, '+
				' B.CUID '+
				' FROM GoodsSubBuy A WITH (NoLock) , GoodsMain B WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M ' + 
				' WHERE A.AdId = B.AdId AND B.AdId *=M.AdId ' +
				' AND B.DelFlag = ''0'' AND B.StateChk=''1'' ' +
				' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) ' +
				' AND B.SaleOkFlag <> ''1'' ' + @SqlAll + @SqlOrderCode
		
	ELSE
		SET @strQuery =  @strTop +
				' A.AdId, A.BrandNmDt, A.BrandNm, A.WishAmt, A.UseGbn, '+
				' B.UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
				' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
				' B.OptType, B.OptList, B.OptPhoto, B.OptRecom, B.OptUrgent, B.OptMain, B.OptHot, B.OptPre, B.OptSync,' +
				' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub, B.ViewCnt, A.buyAmt, '+
				' A.CardYN, B.EscrowYN, A.PicIdx1, A.PicIdx2, B.SaleOkFlag, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, P.PicImage, B.LocalSite, B.PLineKeyNo, S.UserId AS MiniShop, B.RegDate, B.Keyword, '+
				' B.CUID '+
				' FROM GoodsSubSale A WITH (NoLock) , GoodsMain B WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock) ' + 
				'            , (Select UserId From SellerMiniShop WITH (NoLock) WHERE Delflag=''0'') S ' + 
				' WHERE A.AdId = B.AdId AND B.AdId *=M.AdId AND B.AdId *= P.AdId AND B.UserId*=S.UserId ' +
				' AND B.DelFlag = ''0'' AND B.StateChk=''1'' AND B.RegAmtOk = ''1'' ' +
				' AND P.PicIdx = 6 ' +
				' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) ' +
				' AND B.SaleOkFlag <> ''1'' ' + @SqlAll + @SqlWishAmtGbn + @SqlOrderCode		

--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcZipList_New]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcZipList_New]
(
	@Page			int
,	@PageSize		int
,	@Option			Char(1)
,	@ZipMain		Varchar(50)
,	@ZipSub		Varchar(50)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@StrLocal		char(2)		-- 지역코드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
)
AS

--Code1값
	DECLARE @SqlstrCode1 varchar(100)
	IF @StrCode1 =''		SET 	@SqlstrCode1= ''
	ELSE  			SET 	@SqlstrCode1= ' AND B.code1='+@StrCode1 +''

--Code2값
	DECLARE @SqlstrCode2 varchar(100)
	IF @StrCode2 =''		SET 	@SqlstrCode2= ''
	ELSE  			SET 	@SqlstrCode2= ' AND B.code2='+@StrCode2 +''

--Code3값
	DECLARE @SqlstrCode3 varchar(100)
	IF @StrCode3 =''		SET 	@SqlstrCode3= ''
	ELSE  			SET 	@SqlstrCode3= ' AND B.code3='+@StrCode3 +''

--ZipCode
	DECLARE @SqlZipCode varchar(100)
	IF @ZipMain =''		SET 	@SqlZipCode= ''
	ELSE  
		BEGIN
			IF @StrLocal = '0'
				BEGIN
                                                        IF @ZipSub=''	SET 	@SqlZipCode= ' AND (B.ZipMain = '''+@ZipMain+''' OR B.ZipMain=''전국''  ) '
				ELSE		SET 	@SqlZipCode= ' AND (B.ZipMain = '''+@ZipMain+''' OR B.ZipMain=''전국''  ) AND (B.ZipSub= '''+@ZipSub+''' ) '
				END	
			ELSE
				IF @ZipSub = ''	SET 	@SqlZipCode= ''
				ELSE		SET 	@SqlZipCode= ' AND (B.ZipSub = '''+@ZipSub+'''  ) '
		END

 --개인,전문구분
              DECLARE @SqlSpecFlag varchar(200)
              IF @strSpecFlag = '1'	SET 	@SqlSpecFlag= ' AND B.SpecFlag IN (''1'') AND B.StateChk NOT IN (''0'', ''4'', ''5'', ''6'') '
              ELSE  			SET 	@SqlSpecFlag= ' AND B.SpecFlag NOT IN (''1'')  AND B.StateChk NOT IN (''4'', ''5'', ''6'')  '

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
	SET	@SqlAll =@SqlstrCode1+ @SqlstrCode2 +@SqlstrCode3+ @SqlZipCode + @SqlSpecFlag

--지역에 따른 조건
	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalSite = ''
			SET @SqlLocalGoods = ' AND (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalSite = ' , LocalSite L WITH (NoLock, ReadUnCommitted) '
			IF @Option = '0'
				SET @SqlLocalGoods = ' AND ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') OR ' +
								' ( B.LocalBranch=L.LocalBranch AND B.ZipMain=''전국'' ) ' +
							' ) '
			ELSE
				SET @SqlLocalGoods = ' AND ( ' +
								' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
								' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ')  ' +
							' ) '
		END

--유료옵션시 결제완료 여부
	DECLARE @SqlCondition varchar(800)
	IF @Option = '0'		SET @SqlCondition = ' Order by OptType, Adid Desc '
	ELSE			SET @SqlCondition = ' AND B.OptType IN (''1'',''2'') ' +
	  			     		     ' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() Order by Adid Desc  '

--전체쿼리
	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
			' Select TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			' A.AdId AdId, A.BrandNmDt BrandNmDt, A.WishAmt WishAmt, A.UseGbn UseGbn, '+
			' B.UserID UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
			' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
			' B.OptType OptType,  B.OptColor OptColor, B.OptLocalBranch OptLocalBranch,  B.LocalBranch LocalBranch, B.ZipMain ZipMain, B.ZipSub ZipSub,A.buyAmt buyAmt, '+
			' A.CardYN CardYN,B.EscrowYN EscrowYN, A.PicIdx1 PicIdx1, A.PicIdx2	PicIdx2, B.SaleOkFlag SaleOkFlag ,B.CUID as CUID'+
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SaleOkFlag <> ''1'' ' + @SqlLocalGoods + @SqlAll + @SqlCondition

PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcZipList_Test]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcZipList_Test]
(
	@Page			int
,	@PageSize		int
,	@Option		Char(1)
,	@ZipMain		Varchar(50)
,	@ZipSub		Varchar(50)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
,	@StrLocal		char(2)		-- 지역코드
,	@strSpecFlag		char(1)		--개인, 전문업자 구분
)
AS
--Code1값
	DECLARE @SqlstrCode1 varchar(100)
	IF @StrCode1 =''
		BEGIN			
			SET 	@SqlstrCode1= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode1= ' AND B.code1='+@StrCode1 +''
		END

--Code2값
	DECLARE @SqlstrCode2 varchar(100)
	IF @StrCode2 =''
		BEGIN			
			SET 	@SqlstrCode2= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode2= ' AND B.code2='+@StrCode2 +''
		END
--Code3값
	DECLARE @SqlstrCode3 varchar(100)
	IF @StrCode3 =''
		BEGIN			
			SET 	@SqlstrCode3= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlstrCode3= ' AND B.code3='+@StrCode3 +''
		END

--ZipCode
	DECLARE @SqlZipCode varchar(100)
	IF @ZipMain =''
		BEGIN			
			SET 	@SqlZipCode= ''
		END
	ELSE  
		BEGIN
			IF @StrLocal = '0'
				BEGIN
                                                                      IF @ZipSub=''
					BEGIN
						SET 	@SqlZipCode= ' AND (B.ZipMain = '''+@ZipMain+''' OR B.ZipMain=''전국''  ) '
					END 
				      ELSE
					BEGIN
						SET 	@SqlZipCode= ' AND (B.ZipMain = '''+@ZipMain+''' OR B.ZipMain=''전국''  ) AND (B.ZipSub= '''+@ZipSub+''' ) '
					END 
				END	
			ELSE
				BEGIN
					SET 	@SqlZipCode= ' AND (B.ZipSub = '''+@ZipSub+'''  ) '
				END
		END

 --개인,전문구분
              DECLARE @SqlSpecFlag varchar(200)
	IF @strSpecFlag =''
		BEGIN			
			SET 	@SqlSpecFlag= ''
		END
              ELSE IF @strSpecFlag = '1'
		BEGIN
			SET 	@SqlSpecFlag= ' AND B.SpecFlag IN (''1'') AND B.StateChk <> ''0'' '
		END
              ELSE  
		BEGIN
			SET 	@SqlSpecFlag= ' AND B.SpecFlag NOT IN (''1'')  AND B.StateChk <> ''0'' '
		END

--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =@SqlstrCode1+ @SqlstrCode2 +@SqlstrCode3+ @SqlZipCode + @SqlSpecFlag
	END

	DECLARE @SqlLocalGoods varchar(500)
	DECLARE @SqlLocalSite varchar(150)
	DECLARE @SqlLocalNew varchar(600)
	DECLARE @SqlCondition varchar(800)

	IF @StrLocal ='0'
		BEGIN	
			SET @SqlLocalGoods = ' (B.LocalBranch=''80'' OR LEFT(B.OptLocalBranch,2)=''80'' ) '
			SET @SqlLocalSite = ''
			SET @SqlLocalNew = ' ( B.OptType IN (''1'',''2'') AND ( ' +
										' ( ' + @SqlLocalGoods + ' AND ( B.PrnAmtOk <> ''1''  OR B.PrnEnDate < GETDATE() ) ) OR ' +
										' ( NOT ' + @SqlLocalGoods + ' ) ' +
									'    ) ' +
					          ' ) '
			SET @SqlCondition = ' AND ( ' +
							@SqlLocalGoods + ' OR ' +
							' ( ( NOT ' + @SqlLocalGoods + ' ) AND ( B.OptType IN (''1'', ''2'') OR B.OptKind <> '''' )  ) ' +
						'     ) '
		END
	ELSE
		BEGIN
			SET @SqlLocalGoods = ' ( ' +
							' ( B.LocalBranch = L.LocalBranch AND L.LocalSite = ' + @StrLocal + ') OR ' +
							' ( LEFT(B.OptLocalBranch,2) = L.LocalBranch AND RIGHT(B.OptLocalBranch,3) = ''/80'' AND L.LocalSite=' + @StrLocal + ') ' +
						' ) '
			SET @SqlLocalSite = ' , FindDB2.FindCommon.dbo.LocalSite L '
			SET @SqlLocalNew = ' ( B.OptType IN (''1'',''2'') AND ( ' +
										' ( ' + @SqlLocalGoods + ' AND ( B.PrnAmtOk <> ''1''  OR B.PrnEnDate < GETDATE() ) ) OR ' +
										' ( NOT ' + @SqlLocalGoods + ' ) ' +
									'    ) ' +
					          ' ) '
			SET @SqlCondition = ' AND  ( ' +
							'  ( L.LocalSite=' + @StrLocal + ' AND ( L.LocalBranch=B.LocalBranch OR L.LocalBranch=LEFT(B.OptLocalBranch,2) ) ) OR ' +
							'  ( B.LocalBranch=L.LocalBranch AND B.OptLocalBranch=''80'' AND B.ZipMain=''전국'' ) ' +
						'      ) ' 
		END


	DECLARE @strQuery varchar(3000)
	SET @strQuery = 
		CASE
		WHEN @Option = '0' THEN
			' Select Distinct  TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			' A.AdId AdId, A.BrandNmDt BrandNmDt, A.WishAmt WishAmt, A.UseGbn UseGbn, '+
			' B.UserID UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
			' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
			' B.OptType OptType,  B.OptColor OptColor, B.OptLocalBranch OptLocalBranch,  B.LocalBranch LocalBranch, B.ZipMain ZipMain, B.ZipSub ZipSub,A.buyAmt buyAmt, '+
			' A.CardYN CardYN,B.EscrowYN EscrowYN, A.PicIdx1 PicIdx1, A.PicIdx2	PicIdx2, B.SaleOkFlag SaleOkFlag '+
			' ,B.CUID ' + 
			' FROM GoodsSubSale A , GoodsMain B ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk< ''4'' ' + @SqlCondition +@SqlAll+
			' AND (  ( B.OptType=' +@Option+ ' )  OR ' + @SqlLocalNew + ' ) Order by Adid Desc '
		ELSE
			' Select ' +
			' A.AdId AdId, A.BrandNmDt BrandNmDt, A.WishAmt WishAmt, A.UseGbn UseGbn, '+
			' B.UserID UserID,CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.SpecFlag, '+
			' Case When (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'')  then B.OptKind  Else '''' End as OptKind,'+ 
			' B.OptType OptType,  B.OptColor OptColor, B.OptLocalBranch OptLocalBranch,  B.LocalBranch LocalBranch, B.ZipMain ZipMain, B.ZipSub ZipSub,A.buyAmt buyAmt, '+
			' A.CardYN CardYN,B.EscrowYN EscrowYN, A.PicIdx1 PicIdx1, A.PicIdx2	PicIdx2, B.SaleOkFlag SaleOkFlag '+
			' ,B.CUID ' + 
			' FROM GoodsSubSale A , GoodsMain B ' + @SqlLocalSite +
			' WHERE A.AdId = B.AdId ' +
			' AND B.DelFlag <> ''3'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			' AND B.StateChk< ''4'' ' + ' AND ' + @SqlLocalGoods +@SqlAll+
			' AND B.OptType=' +@Option +
			' AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE()  Order by Adid Desc '
		END

PRINT(@strQuery)
--EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[PUT_TAXREQUEST_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 :
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2009/01/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 해당 스토어드 프로시저를 사용하는 asp 파일을 기재한다.
 *  사 용  예 제 : EXEC PUT_TAXREQUEST_PROC '1663946','1','158005'
 *************************************************************************************/


CREATE PROC [dbo].[PUT_TAXREQUEST_PROC]

  @ADID INT
  ,@ADGBN INT
  ,@GRPSERIAL INT
  ,@USERID VARCHAR(50)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @CNT INT

  SELECT @CNT = COUNT(*) 
    FROM FINDDB2.FINDCOMMON.DBO.TAXREQUEST 
   WHERE SITEGBN IN ('Used','MagUsed') 
     AND ADID = @ADID
     AND GRPSERIAL = @GRPSERIAL

  IF @CNT = 0
    BEGIN

      INSERT INTO FINDDB2.FINDCOMMON.DBO.TAXREQUEST (USERID, SITEGBN, ADGBN, ADID, OPTGBN, GRPSERIAL, SETTLECOST, MODFLAG, TAXATION, TAXVAT, PRNAMTOK, CHARGEKIND, SETTLEDATE, SHOPNM, BUSINESSNO, ONESNAME, SHOPTYPE, SHOPPART, ADDRESS, MANAGER, EMAIL, HPHONE, PHONE, OPTSTDATE, OPTENDATE,CUID)

      SELECT A.USERID
            ,'Used'
            ,'1'
            ,A.ADID
            ,''
            ,R.GRPSERIAL
            ,R.PRNAMT
            ,'1'
            ,CONVERT(INT, ROUND(R.PRNAMT/1.1, 0))
            ,(R.PRNAMT - CONVERT(INT, ROUND(R.PRNAMT/1.1, 0)))
            ,R.PRNAMTOK
            ,R.CHARGEKIND
            ,R.RECDATE
            ,T.SHOPNM
            ,T.BUSINESSNO
            ,T.ONESNAME
            ,T.SHOPTYPE
            ,T.SHOPPART
            ,T.ADDRESS
            ,T.MANAGER
            ,T.EMAIL
            ,T.HPHONE
            ,T.PHONE
            ,CONVERT(CHAR(10),PRNSTDATE,120) AS PRNSTDATE
            ,CASE SPECFLAG
                  WHEN '4' THEN
                       CONVERT(CHAR(10),REGENDATE,120)
                  ELSE CONVERT(CHAR(10),PRNENDATE,120)
                   END AS PRNENDATE
            , A.CUID
        FROM GOODSMAIN A,
             (SELECT D.ADID, D.PRNAMT, D.PRNAMTOK, C.RECDATE, C.CHARGEKIND, C.GRPSERIAL
                FROM RECCHARGE C, RECCHARGEDETAIL D
               WHERE C.GRPSERIAL = D.GRPSERIAL) R,
             FINDDB2.FINDCOMMON.DBO.TAXUSER T
       WHERE A.ADID = R.ADID
         AND T.USERID = @USERID
         AND A.ADID = @ADID
         AND R.GRPSERIAL = @GRPSERIAL

    END
GO
/****** Object:  StoredProcedure [dbo].[SearchList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchList]
(
	@GetCount		varchar(10)
,	@AdGbn			char(1)		--0:판매물품 1:구매물품
,	@Code1			varchar(10)
,	@Code2			varchar(20)
,	@Code3			varchar(20)
,	@KeyWord		varchar(20)
,	@Prices			varchar(10)	--가격
,	@ZipMain		varchar(10)	--거래희망지역
,	@ZipSub		varchar(10)
,	@SellerID		varchar(15)	--판매자ID
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)
,	@UseGbn		char(1)		--0:중고품 1:신고품 2:신품
,	@AdultCode		char(1)
,	@WishAmtGbn		char(1)
,	@OrderCode		char(1)
,	@StrLocal		char(2)		-- 지역코드
,	@CountChk		char(1)		--카운트 Flag
)
AS
--AdGbn
	DECLARE @SqlAdGbn varchar(100);	SET @SqlAdGbn = ''
	IF @AdGbn <> '' AND  @AdGbn <> '2'
		SET @SqlAdGbn = ' AND B.AdGbn = ''' + @AdGbn + ''' '
	ELSE IF @AdGbn <> '' AND @AdGbn='2'
		SET @SqlAdGbn = ' AND B.AdGbn = 0 '	

--Code
	DECLARE @SqlCode varchar(100); SET @SqlCode = ''
	IF @Code3 <> ''
		SET @SqlCode = ' AND B.Code3 = ''' + @Code3 + ''' '
	ELSE IF @Code2 <> ''
		SET @SqlCode = ' AND B.Code2 = ''' + @Code2 + ''' '
	ELSE IF @Code1 <> ''					
		SET @SqlCode = ' AND B.Code1 = ''' + @Code1 + ''' '

--KeyWord
	DECLARE @SqlKeyWord varchar(100) ; SET @SqlKeyWord = ''
	IF @KeyWord <> ''	 SET @SqlKeyWord = ' AND ( A.BrandNmDt LIKE ''%' + @KeyWord + '%'' OR A.BrandNm LIKE ''%' + @KeyWord + '%'' ) '

--Prices
	DECLARE @SqlWishAmt varchar(100); SET @SqlWishAmt = '';
	IF @Prices <> 0 AND @Prices < 1000000		--백만원 미만
		BEGIN
			IF @AdGbn = '1'
				SET @SqlWishAmt = ' AND A.BuyAmt <= ''' + @Prices + ''' '				
			ELSE
				SET @SqlWishAmt = ' AND A.WishAmt <= ''' + @Prices + ''' '
		END
	ELSE IF @Prices <> 0 AND @Prices >= 1000000	--백만원 이상
		BEGIN
			IF @AdGbn = '1'
				SET @SqlWishAmt = ' AND A.BuyAmt >= ''' + @Prices + ''' '					
			ELSE
				SET @SqlWishAmt = ' AND A.WishAmt >= ''' + @Prices + ''' '

		END

--ZipMain, --ZipSub
	DECLARE @SqlZipMain varchar(100); SET @SqlZipMain = ''
	DECLARE @SqlZipSub varchar(100); SET @SqlZipSub = ''
	IF @ZipMain <> ''
	BEGIN
		SET @SqlZipMain = ' AND B.ZipMain = ''' + @ZipMain + ''' '
		IF @ZipSub <> '' SET @SqlZipSub = ' AND B.ZipSub = ''' + @ZipSub + ''' '
	END

--SellerID
	DECLARE @SqlSellerID varchar(100); SET @SqlSellerID = ''
	IF @SellerID <> '' SET @SqlSellerID = ' AND B.UserID = ''' + @SellerID + ''' '

--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100) ; SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> '' SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode
	DECLARE @SqlPicCode varchar(100) ; SET @SqlPicCode = ''
	IF @PicCode = '1'	 
		IF @AdGbn = '1'
			SET @SqlPicCode = ''				
		ELSE
			SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' Or A.PicIdx2<>'''' ) '
--UseCode
	DECLARE @SqlUseCode varchar(100); SET @SqlUseCode = ''
	IF @UseGbn <> '' SET @SqlUseCode = ' AND A.UseGbn = ''' + @UseGbn + '''  '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

--WishAmtGbn
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''	
	IF @WishAmtGbn = '0' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 '
	Else IF  @WishAmtGbn = '1' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn = '2' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode = '1'
		IF @AdGbn = '1'
			SET @SqlOrderCode = ' ORDER BY BuyAmt Asc, A.AdId DESC '			
		ELSE
			SET @SqlOrderCode = ' ORDER BY WishAmt Asc, A.AdId DESC '
	ELSE IF @OrderCode = '2'
		SET @SqlOrderCode = ' ORDER BY ViewCnt DESC '
	ELSE
		SET @SqlOrderCode = ' ORDER BY B.RegDate DESC ' 

--지역에 따른 물품 출력
	DECLARE @SqlLocalGoods varchar(100)
	IF @StrLocal ='0'		SET @SqlLocalGoods = '' 
--	ELSE			SET @SqlLocalGoods = ' AND B.ShowLocalSite=' + @StrLocal + ' '
	ELSE			SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0 OR B.ShowLocalSite=' + @StrLocal + ')'			

--SqlSets
	DECLARE @SqlSets varchar(500)
	SET @SqlSets = @SqlAdGbn + @SqlCode + @SqlKeyWord + @SqlWishAmt + @SqlZipMain + @SqlZipSub + @SqlSellerID + @SqlEscrowYNCode + @SqlPicCode + @SqlUseCode  + @SqlAdultCode  + @SqlWishAmtGbn + @SqlLocalGoods

--All strQuery
	DECLARE @strQuery varchar(3000)
	DECLARE @strRegAmtQuery varchar(100)

	IF @CountChk = '1'
		BEGIN
			SET @strQuery = 	' SELECT  COUNT(A.AdId) Cnt' 
			SET @SqlOrderCode = ''
		END
	ELSE
		BEGIN
			SET @strQuery = 	' SET ROWCOUNT ' + @GetCount + ';' +
					' SELECT  ' + 
					' B.AdId, A.BrandNmDt, A.BrandNm, B.ViewCnt, A.UseGbn, B.UserID, ' +
					' CONVERT(CHAR(10),B.RegDate,120) AS RegDate, ' +
					' CASE WHEN (B.PrnEnDate>=Getdate()  AND B.PrnAmtOk=''1'') THEN B.OptKind ELSE '''' END AS OptKind, ' + 
					' B.OptLocalBranch,  B.LocalBranch, B.ZipMain, B.ZipSub, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, B.EscrowYN, B.SpecFlag, P.PicImage, B.LocalSite, B.PLineKeyNo, S.UserId AS MiniShop, B.RegDate, '					+ ',B.CUID '			
			--구매
			IF @AdGbn = '1'
				BEGIN
					SET @strQuery = 	@strQuery + ' A.BuyAmt AS BuyAmt '
				END
			--판매
			ELSE 
				BEGIN
					SET @strQuery = 	@strQuery + ' A.WishAmt '
				END
		END

	IF @AdGbn = '1'	--구매
		BEGIN
			SET @strQuery = 	@strQuery +
					' FROM GoodsSubBuy A WITH (NoLock), GoodsMain B WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock) '
			SET @strRegAmtQuery = ''
		END
		

	ELSE		--판매
		BEGIN
			SET @strQuery = 	@strQuery +
					' FROM GoodsSubSale A WITH (NoLock), GoodsMain B WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock) '
			SET @strRegAmtQuery = ' AND B.RegAmtOk = ''1'' '
		END		


	SET @strQuery = 	@strQuery +
			'            , (Select UserId,CUID From SellerMiniShop WITH (NoLock) WHERE Delflag=''0'') S ' + 
			' WHERE A.AdId = B.AdId AND B.AdId *=M.AdId AND B.AdId *= P.AdId AND B.UserId*=S.UserId  AND B.CUID *=S.CUID ' +
			' AND B.DelFlag = ''0'' ' +
			' AND B.StateChk = ''1'' ' + 
			' ' + @strRegAmtQuery + -- 구매물품은 RegAmtOk 가 1 이 아니므로...
			' AND B.SaleOkFlag<>''1'' ' +
			' AND P.PicIdx = 6 ' +
			' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE()) ' +
			' ' + @SqlSets  + @SqlOrderCode +  ';' +
			' SET ROWCOUNT 0;' 

--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[SellingGoods_Insert]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SellingGoods_Insert]
(
	  @Code1		int
	, @Code2		int
	, @Code3		int
	, @rdoOption		char
	, @OptPhoto		tinyint
	, @OptUrgent		tinyint
	, @OptRecom		tinyint
	, @OptMain		tinyint
	, @OptHot		tinyint
	, @OptPre		tinyint
	, @OptSync		tinyint
	, @OptKind 		varchar(20)
	, @OptLink 		varchar(30)
	, @RegTerm		int
	, @cUserID		varchar(50)
	, @UserName		varchar(30)
	, @ZipMain		varchar(20)
	, @ZipSub 		varchar(20)
	, @LocalBranch		int
	, @Phone 		varchar(50)
	, @HPhone 		varchar(50)
	, @Email 		varchar(50)
	, @IPAddr 		varchar(20)
	, @PartnerGbn 		int

	, @EscrowYN		char(1)
	, @SpecFlag		char(1)
	, @TagYN		tinyint
	, @CardYN		char(1)

	, @BrandNmDt 		varchar(100)
	, @BrandNm 		varchar(100)
	, @BrandState 		tinyint
	, @UseGbn 		tinyint
	, @UseYY 		varchar(10)
	, @UseMM 		varchar(10)
	, @GoodsQt 		int
	, @WishAmt  		int
	, @BuyAmt 		int
	, @Contents 		text
	, @SendAreaMain 	varchar(20)
	, @SendAreaSub 		varchar(20)		
	, @ReZipCode 		varchar(10)
	, @AddNm01 		varchar(100)
	, @AddNm02 		varchar(100)
	, @WooriID 		varchar(30)
	, @LocalSite		int

--	, @MergeText		varchar(6000)
	, @PaperFlag 		char(1)
	, @ShowLocalSite		tinyint
	, @SendGbn 		char(1)
	, @SendCharge		varchar(30)
	, @EtcText		varchar(50)

	--2005.02.22 추가
	, @Scratch		char(1)
	, @AfterService		char(1)
	, @Origin		char(1)
	, @OriginCountry		varchar(50)
	, @LossGoods		varchar(80)
	, @ProCorp		varchar(50)

	--2005.08.12 추가
	, @Keyword		char(1)

        -- 2009.04.28 추가 (사업자번호/회사명)
        , @BizNum               varchar(12)
        , @CompanyName          varchar(50)
        , @CUID					INT 
)
AS
set nocount on 
DECLARE @AdId int

IF @EscrowYN = 'Y' SET @EscrowYN = 'R'

INSERT INTO GoodsMain 
( 
	Code1, Code2, Code3, OptType, OptPhoto, OptUrgent, OptRecom, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink
	, PrnstDate, PrnEnDate, PrnCnt, UserID, UserName, ZipMain, ZipSub, LocalBranch, Phone, HPhone, Email, IPAddr 
	, StateChk, RegDate, EscrowYN, SpecFlag, PartnerCode, AdGbn, WooriID, LocalSite, ShowLocalSite, PaperFlag, Keyword
        , BizNum, ShopName,CUID 
) 
VALUES 
( 
	  @Code1
	, @Code2
	, @Code3
	, @rdoOption
	, @OptPhoto
	, @OptUrgent
	, @OptRecom
	, @OptMain
	, @OptHot
	, @OptPre
	, @OptSync
	, @OptKind 
	, @OptLink 
	, Getdate() 
	, ( GetDate() + @RegTerm ) 
	, @RegTerm
	, @cUserID 
	, @UserName 
	, @ZipMain 
	, @ZipSub 
	, @LocalBranch
	, @Phone 
	, @HPhone 
	, @Email 
	, @IPAddr 
	, '6' 
	, GetDate() 
	, @EscrowYN
	, @SpecFlag
	, @PartnerGbn 
	, '0'
	, @WooriID
	, @LocalSite
	, @ShowLocalSite
	, @PaperFlag

	--2005.08.12 추가
	, @Keyword	

	--2009.04.28 추가
        , @BizNum
        , @CompanyName
        ,@CUID
)

SELECT @AdId = SCOPE_IDENTITY()

INSERT INTO GoodsSubSale 
(
	Adid, BrandNmDt, BrandNm, ProCorp, BrandState, UseGbn, UseYY, UseMM, GoodsQt
	, WishAmt, BuyAmt, Contents, TagYN, CardYN, SendAreaMain, SendAreaSub, ReZipCode, ReAddr1, ReAddr2, SendGbn, SendCharge, EtcText
	, Scratch, AfterService, Origin, OriginCountry, LossGoods	
) 
VALUES 
(
	  @Adid 
	, @BrandNmDt 
	, @BrandNm 
	, @ProCorp
	, @BrandState 
	, @UseGbn 
	, @UseYY 
	, @UseMM 
	, @GoodsQt 
	, @WishAmt  
	, @BuyAmt 
	, @Contents 
	, @TagYN 
	, @CardYN
	, @SendAreaMain 
	, @SendAreaSub 
	, @ReZipCode 
	, @AddNm01 
	, @AddNm02 
	, @SendGbn
	, @SendCharge
	, @EtcText

	--2005.02.22 추가
	, @Scratch
	, @AfterService
	, @Origin
	, @OriginCountry
	, @LossGoods
)

--INSERT INTO GoodsMergeText ( AdId, MergeText ) VALUES ( @AdId, @MergeText)

SELECT @AdId
GO
/****** Object:  StoredProcedure [dbo].[SellingGoods_Insert2]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SellingGoods_Insert2]
(
	  @Code1		int
	, @Code2		int
	, @Code3		int
	, @rdoOption		char
	, @OptPhoto		tinyint
	, @OptUrgent		tinyint
	, @OptRecom		tinyint
	, @OptMain		tinyint
	, @OptHot		tinyint
	, @OptPre		tinyint
	, @OptSync		tinyint
	, @OptKind 		varchar(20)
	, @OptLink 		varchar(30)
	, @RegTerm		int
	, @cUserID		varchar(50)
	, @UserName		varchar(30)
	, @ZipMain		varchar(20)
	, @ZipSub 		varchar(20)
	, @LocalBranch		int
	, @Phone 		varchar(50)
	, @HPhone 		varchar(50)
	, @Email 		varchar(50)
	, @IPAddr 		varchar(20)
	, @PartnerGbn 		int

	, @EscrowYN		char(1)
	, @TagYN		tinyint
	, @CardYN		char(1)

	, @BrandNmDt 		varchar(100)
	, @BrandNm 		varchar(100)
	, @BrandState 		tinyint
	, @UseGbn 		tinyint
	, @UseYY 		varchar(10)
	, @UseMM 		varchar(10)
	, @GoodsQt 		int
	, @WishAmt  		int
	, @BuyAmt 		int
	, @Contents 		text
	, @SendAreaMain 	varchar(20)
	, @SendAreaSub 		varchar(20)		
	, @ReZipCode 		varchar(10)
	, @AddNm01 		varchar(100)
	, @AddNm02 		varchar(100)
	, @WooriID 		varchar(30)
	, @LocalSite		int

--	, @MergeText		varchar(6000)
	, @PaperFlag 		char(1)
	, @ShowLocalSite		tinyint
	, @CUID			INT
)
AS

DECLARE @AdId int

IF @EscrowYN = 'Y' SET @EscrowYN = 'R'

INSERT INTO GoodsMain2 
( 
	Code1, Code2, Code3, OptType, OptPhoto, OptUrgent, OptRecom, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink 
	, PrnstDate, PrnEnDate, PrnCnt, UserID, UserName, ZipMain, ZipSub, LocalBranch, Phone, HPhone, Email, IPAddr 
	, StateChk, RegDate, EscrowYN, PartnerCode, AdGbn, WooriID, LocalSite, ShowLocalSite, PaperFlag, CUID
) 
VALUES 
( 
	  @Code1
	, @Code2
	, @Code3
	, @rdoOption
	, @OptPhoto
	, @OptUrgent
	, @OptRecom
	, @OptMain
	, @OptHot
	, @OptPre
	, @OptSync
	, @OptKind 
	, @OptLink 
	, Getdate() 
	, ( GetDate() + @RegTerm ) 
	, @RegTerm
	, @cUserID 
	, @UserName 
	, @ZipMain 
	, @ZipSub 
	, @LocalBranch
	, @Phone 
	, @HPhone 
	, @Email 
	, @IPAddr 
	, '6' 
	, GetDate() 
	, @EscrowYN
	, @PartnerGbn 
	, '0'
	, @WooriID
	, @LocalSite
	, @ShowLocalSite
	, @PaperFlag
	, @CUID
)

SELECT @AdId = SCOPE_IDENTITY()

INSERT INTO GoodsSubSale2 
(
	Adid, BrandNmDt, BrandNm, BrandState, UseGbn, UseYY, UseMM, GoodsQt
	, WishAmt, BuyAmt, Contents, TagYN, CardYN, SendAreaMain, SendAreaSub, ReZipCode, ReAddr1, ReAddr2 
) 
VALUES 
(
	  @Adid 
	, @BrandNmDt 
	, @BrandNm 
	, @BrandState 
	, @UseGbn 
	, @UseYY 
	, @UseMM 
	, @GoodsQt 
	, @WishAmt  
	, @BuyAmt 
	, @Contents 
	, @TagYN 
	, @CardYN
	, @SendAreaMain 
	, @SendAreaSub 
	, @ReZipCode 
	, @AddNm01 
	, @AddNm02 
)

--INSERT INTO GoodsMergeText ( AdId, MergeText ) VALUES ( @AdId, @MergeText)

SELECT @AdId
GO
/****** Object:  StoredProcedure [dbo].[ThemeList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ThemeList]
(
	@GetCount		varchar(10)
,	@ThemeGbn		char(1)		--1:텍스트방식     2:링크방식     3:코드방식	4:코드(텍스트)	5:코드+텍스트
,	@KeyWord		varchar(200)	--KeyWord
,	@CodeNm 		varchar(200)	--@CodeNm
,	@Option			varchar(20)	--옵션 종류
,	@EscrowYNCode		char(1)
,	@PicCode		char(1)
,	@UseCode		varchar(10)
,	@AdultCode		char(1)
,	@WishAmtGbn		char(1)
,	@OrderCode		char(1)			
,	@StrLocal		char(2)		--지역코드
,	@CountChk		char(1)		--카운트 Flag
)
AS
--ThemeGbn + KeyWord
	DECLARE @SubKeyWord	varchar(100); SET @SubKeyWord = ''
	DECLARE @SqlKeyWord	varchar(1000); SET @SqlKeyWord = ''
	DECLARE @nIndex	int; SET @nIndex = CHARINDEX(',', @KeyWord)

	IF (@ThemeGbn = '1' OR @ThemeGbn='4' OR @ThemeGbn='5') AND @nIndex > 0
		BEGIN
			SET @SqlKeyWord = ' AND ( 1<>1 '
			WHILE @nIndex > 0
			BEGIN
				SET @nIndex = CHARINDEX(',', @KeyWord)
				IF @nIndex > 0
					SET @SubKeyWord = SUBSTRING(@KeyWord, 0, @nIndex)
				ELSE
					SET @SubKeyWord = @KeyWord
				SET @KeyWord = SUBSTRING(@KeyWord, @nIndex +1 , Len(@KeyWord) - @nIndex )
				SET @SqlKeyWord = @SqlKeyWord + ' OR A.BrandNm LIKE ''%' + @SubKeyWord + '%'' OR A.BrandNmDt LIKE ''%' + @SubKeyWord + '%'' '
			END

			IF (@ThemeGbn='5' AND @CodeNm <> '')	
				SET @SqlKeyWord = @SqlKeyWord + ' OR   B.Code3 IN ('+ @CodeNm +') '	
			ELSE IF (@ThemeGbn='4' AND @CodeNm <> '')	
				SET @SqlKeyWord = @SqlKeyWord + ' AND B.Code3 IN ('+ @CodeNm +') '
			ELSE
				SET @SqlKeyWord = @SqlKeyWord + ' ) '	

		END

	ELSE IF (@ThemeGbn = '1' OR @ThemeGbn='4' OR @ThemeGbn='5')
		BEGIN
			SET @SqlKeyWord = ' AND ( A.BrandNm LIKE ''%' + @KeyWord + '%'' OR A.BrandNmDt LIKE ''%' + @KeyWord + '%'' '
			IF (@ThemeGbn='4' AND @CodeNm <> '')	
				SET @SqlKeyWord = @SqlKeyWord + ' AND B.Code3 IN ('+ @CodeNm +') ) '	
			ELSE IF (@ThemeGbn='5' AND @CodeNm <> '')	
				SET @SqlKeyWord = @SqlKeyWord + ' OR   B.Code3 IN ('+ @CodeNm +') )'	
			ELSE
				SET @SqlKeyWord = @SqlKeyWord + ' ) '			
		END
	ELSE					
		SET @SqlKeyWord = ' AND B.Code3 IN ('+ @KeyWord +') '

--EscrowYNCode
	DECLARE @SqlEscrowYNCode varchar(100); SET @SqlEscrowYNCode = ''
	IF @EscrowYNCode <> ''	SET @SqlEscrowYNCode = ' AND (B.EscrowYN = '''+@EscrowYNCode +''' ) '

--PicCode
	DECLARE @SqlPicCode varchar(100); SET @SqlPicCode = ''
	IF @PicCode = '1'		SET @SqlPicCode = ' AND (A.PicIdx1 <> '''' OR A.PicIdx2 <> '''' ) '

--UseCode
	DECLARE @SqlUseCode varchar(100); SET @SqlUseCode = ''
	IF @UseCode <> ''	SET @SqlUseCode = ' AND A.UseGbn = '''+@UseCode +'''  '

--AdultCode
	DECLARE @SqlAdultCode varchar(100); SET @SqlAdultCode=''
	IF @AdultCode = '0' 	SET @SqlAdultCode =  ' AND (B.Code2 <> 2310) '

--WishAmtGbn
	DECLARE @SqlWishAmtGbn varchar(100); SET @SqlWishAmtGbn=''	
	IF @WishAmtGbn = '0' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -1 '
	Else IF  @WishAmtGbn = '1' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -2 '
	Else IF  @WishAmtGbn = '2' 	
		SET @SqlWishAmtGbn = ' AND A.WishAmt = -3 '

--OrderCode
	DECLARE @SqlOrderCode varchar(100)
	IF @OrderCode = '1'
		SET @SqlOrderCode = ' ORDER BY WishAmt Asc, A.AdId DESC '
	ELSE IF @OrderCode = '2'
		SET @SqlOrderCode = ' ORDER BY ViewCnt Desc, A.AdId DESC '
	ELSE
		SET @SqlOrderCode = ' ORDER BY B.RegDate DESC '

--Option
	DECLARE @SqlCondition varchar(200); SET @SqlCondition = ''
	IF @Option <> ''		
		SET @SqlCondition = ' AND ' + @Option + '=1  AND B.PrnAmtOk = ''1'' AND B.PrnEnDate >=GETDATE() AND B.LocalSite=' + @StrLocal
	ELSE
		SET @SqlCondition = ''

--strLocal
	DECLARE @SqlLocalGoods varchar(500)
	IF @StrLocal ='0'
			SET @SqlLocalGoods = '' 
	ELSE	
--	ELSE
--			SET @SqlLocalGoods = ' AND ( B.LocalBranch in ' +
--					          '(Select LocalBranch From LocalSite with (Nolock) where LocalSite=' + @StrLocal + ') ' +
--					          ' OR B.ZipMain = ''전국'' ) '
--			SET @SqlLocalGoods = ' AND B.ShowLocalSite=' + @StrLocal + ' '
			SET @SqlLocalGoods = ' AND (B.ShowLocalSite = 0 OR B.ShowLocalSite=' + @StrLocal + ')'
--Query
	DECLARE @strQuery varchar(5000)
	IF @CountChk = '1'
		BEGIN
			SET @strQuery = 	' SELECT  COUNT(A.AdId) Cnt' 
			SET @SqlOrderCode = ''
		END
	ELSE
		BEGIN
			SET @strQuery = 	
			' SET ROWCOUNT ' + @GetCount + ';' +
			' SELECT  ' + 
			' A.AdId, A.BrandNmDt, A.BrandNm, A.WishAmt, A.UseGbn ' +
		' 	, CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.OptKind, B.ZipMain, B.ZipSub, B.ViewCnt ' + 
		' 	, B.OptLocalBranch,  B.LocalBranch, Isnull(B.WooriID,'''') As WooriID, M.CNT AS AnswerCnt, B.EscrowYN, B.SpecFlag, A.PicIdx1, A.PicIdx2, P.PicImage, B.LocalSite, B.PLineKeyNo, S.UserId AS MiniShop, B.RegDate, B.Keyword , S.CUID as MiniShopCUID'
		END

	SET @strQuery = 	@strQuery +
		' FROM 	GoodsSubSale A WITH (NoLock), GoodsMain B WITH (NoLock), (Select Adid, Count(Adid) AS CNT From MsgBoard  WITH (NoLock) WHERE Step=0 GROUP BY Adid) M, GoodsPic P WITH (NoLock) ' + 
		'            , (Select UserId, CUID  From SellerMiniShop WITH (NoLock) WHERE Delflag=''0'') S ' + 
		' WHERE	A.AdId = B.AdId ' +
		' AND B.AdId *=M.AdId AND B.AdId *= P.AdId AND B.UserId*=S.UserId ' +
		' AND B.DelFlag = ''0'' ' +
		' AND B.StateChk = ''1'' ' +
		' AND B.RegAmtOK = ''1'' ' +
		' AND P.PicIdx = 6 ' +
		' AND (B.RegEnDate >= GETDATE() OR B.PrnEnDate >= GETDATE())' +		
		' AND B.SaleOkFlag <> ''1'' ' + @SqlKeyWord + @SqlCondition + @SqlEscrowYNCode+ @SqlPicCode + @SqlUseCode + @SqlAdultCode + @SqlWishAmtGbn  + @SqlLocalGoods + @SqlOrderCode

--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[Used_XML_List]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--EXEC Used_XML_List 'book', 5

CREATE PROC [dbo].[Used_XML_List]

	@KeyWord		varchar(200),
	@Scale			varchar(10)

AS

	DECLARE @Sql		varchar(1000)
	DECLARE @SubSql	varchar(200)
	DECLARE @Top		varchar(200)
	DECLARE @TotalCnt	varchar(200)

	
	SET @Top 	= ' CONVERT(Char(10),G.RegDate,11) AS RegDate, S.BrandNmDt, S.WishAmt, S.SendAreaMain, S.UseGbn, G.AdId '
	SET @TotalCnt 	= ' COUNT(*) AS CNT '	
	
	--[키워드 검색]
	IF @KeyWord <> ''
	    BEGIN
		SET @SubSql = ' AND (S.BrandNm like ''%' + @KeyWord + '%'' OR S.BrandNmDt like ''%' + @KeyWord + '%'') '
	    END
	ELSE
	    BEGIN
		SET @SubSql = '' 
	    END
	    
	    
	--[전체 쿼리]
	SET @Sql = 	' SELECT ' + @TotalCnt  + 
			' FROM GoodsMain G INNER JOIN GoodsSubSale S ON G.AdId = S.AdId ' +
			' WHERE G.StateChk = ''1'' AND G.RegAmtOK = ''1'' AND  G.DelFlag = ''0'' ' + @SubSql + ';' +
			' SELECT TOP ' + @Scale + @Top +
			' FROM GoodsMain G INNER JOIN GoodsSubSale S ON G.AdId = S.AdId ' +
			' WHERE G.StateChk = ''1'' AND G.RegAmtOK = ''1'' AND  G.DelFlag = ''0'' ' + @SubSql +
			' ORDER BY CONVERT(Char(10),G.RegDate,120) DESC; '
			
	BEGIN
		PRINT(@Sql)
		Exec(@Sql)
	END
GO
/****** Object:  StoredProcedure [dbo].[USERID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:19:13 ******/
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
	UPDATE A SET UserID=@RE_USERID FROM Auction A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM BadUserUsed A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM EsKiccTrans A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM EsOnLine A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM Event021008 A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM GoodsMain A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM GoodsMain_Save A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM GoodsMain2 A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM GoodsMainAdmin A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM GoodsMainCovt A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM KiccTrans A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM MsgBoard A  where CUID=@CUID
	UPDATE A SET SaleUserId=@RE_USERID FROM MsgBoard A  where SALE_CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM NotPaperUser A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM Sale_BuyerInfo A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM SaleAgency A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM SellerMiniShop A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM TaxEtcInfo A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM USED_REG_CNT A  where CUID=@CUID
/*
	INSERT LOGDB.DBO.USERID_CHANGE_HISTORY_TB (B_USERID,N_USERID,DB_NM,USERIP) 
	SELECT @USERID,@RE_USERID,DB_NAME(),@CLIENT_IP
*/	
END
GO
/****** Object:  StoredProcedure [dbo].[uspa_usedMain_GoodSMain_User_Cnt]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
 sp명	:	uspa_usedMain_GoodSMain_User_Cnt
 설명	:	중고장터_회원별 등록 카운트
==============================================================================*/
CREATE PROC [dbo].[uspa_usedMain_GoodSMain_User_Cnt]

	@sUserid	varchar(30),			-- userid
	@nCnt		int		OUTPUT	-- 목록 개수
AS

	SET NOCOUNT ON

	begin
		SELECT @nCnt = count(*)
		   FROM GOODSMAIN
		WHERE DelFlag = '0'
		   AND StateChk = '1' 
		   AND UserID = @sUserid
	end

	SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[WAP_List]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************		
	제목		:	WAP 리스트 생성
	작성자		:	김명재 2003.08.08	
*****************************************************************/
CREATE PROC [dbo].[WAP_List]

	@UsedCode1	varchar(10)				--상품대분류
	,@UsedCode2	varchar(10)				--상품중분류
	,@WorkPlace1	varchar(10)				--상위지역
	,@WorkPlace2	varchar(50)				--하위지역 (1010;1011;1012 멀티값가능)
	,@UseGbn	char(1)					--상품구분(0:중고품,1:신고품,2:신품)

AS

	
	DECLARE @SQL varchar(3000)
	DECLARE @WorkPlaceSQL	varchar(500); SET @WorkPlaceSQL = ''
	DECLARE @UsedCodeSQL	varchar(500); SET @UsedCodeSQL = ''
	DECLARE @UseGbnSQL varchar(500); SET @UseGbnSQL = ''

	IF @UsedCode2 <> ''
		SET @UsedCodeSQL = ' AND G.Code2 = ' + @UsedCode2 + ' '

	IF @WorkPlace2 = ''
		SET @WorkPlaceSQL = ' AND ( G.ZipMain=''전국'' OR G.ZipMain = (SELECT TOP 1 Metro FROM AreaCode WHERE LEFT(LCode,2)=' + @WorkPlace1 + ') ) '
	ELSE
		SET @WorkPlaceSQL = ' AND ( G.ZipMain=''전국'' OR G.ZipMain+'':''+G.ZipSub IN (SELECT Metro+'':''+City FROM AreaCode WHERE LCode IN (' + @WorkPlace2 + ') ) ) '

	IF @UseGbn <> ''
		SET @UseGbnSQL = ' AND S.UseGbn=' + @UseGbn

	SET @SQL = 
			
	'SELECT	G.AdId, S.BrandNm, S.WishAmt, G.ZipMain, G.ZipSub, CONVERT(CHAR(10),G.RegDate,120) AS RegDate, S.UseGbn, G.ViewCnt, G.Phone, G.HPhone ' +
	'FROM GoodsMain G WITH (NoLock, ReadUnCommitted), GoodsSubSale S WITH (NoLock, ReadUnCommitted)  ' +
	' WHERE G.AdId=S.AdId ' +
	' AND G.StateChk = ''1'' ' +
	' AND G.DelFlag = ''0'' ' +
	' AND G.SaleOkFlag = ''0'' ' +
	' AND G.RegAmtOk = ''1'' ' +
	--' AND G.PrnEnDate >= GETDATE() ' +
	' AND G.Code1 = ' + @UsedCode1 + ' ' + @UsedCodeSQL + @WorkPlaceSQL + @UseGbnSQL +
	' AND (      ( G.Phone IS NOT NULL AND G.Phone <> '''' AND G.Phone <> ''--'' ) ' +
	'          OR ( G.HPhone IS NOT NULL AND G.HPhone <> '''' AND G.HPhone <> ''--'' ) ' +
	'         ) ' +
	'ORDER BY G.AdId DESC'

	
	EXEC(@SQL)
GO
/****** Object:  StoredProcedure [FindUsed].[Proc_LocalGoodsCount]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [FindUsed].[Proc_LocalGoodsCount]
(
	@StrCode1		varchar(10)
,	@StrLocal		char(1)		-- 지역코드
)

AS
 

DECLARE @sqlCode varchar(100)

IF @StrCode1 <> '' SET @sqlCode = ' AND B.Code1 = ' + @StrCode1 + ' '
ELSE		 SET @sqlCode = ''

DECLARE @strQuery varchar(3000)

-- 지역판에 나오는 매물

SET @strQuery = 

'SELECT ( ' +

 ' SELECT COUNT(A.Adid) AS GeneralGoodsCnt ' +
 ' FROM  GoodsSubSale A , GoodsMain B  , LocalSite L  ' +
 ' WHERE A.AdId = B.AdId ' + @sqlCode +
 ' AND B.DelFlag <> ''3'' ' +
 ' AND B.SaleOkFlag <> ''1'' ' +
 ' AND B.SpecFlag <> ''1'' AND B.StateChk NOT IN (''4'' , ''5'' , ''6'') ' +
 ' AND  ( ' +
 '  ( L.LocalSite=' + @StrLocal + ' AND ( L.LocalBranch=B.LocalBranch OR L.LocalBranch=LEFT(B.OptLocalBranch,2) ) ) ' +
 '   OR ' +
 '  ( B.LocalBranch=L.LocalBranch AND B.OptLocalBranch=''80'' AND B.ZipMain=''전국'' )       ) ' +

')+(' +

 ' SELECT COUNT(A.Adid) AS ExpertGoodsCnt ' +
 ' FROM  GoodsSubSale A , GoodsMain B  , LocalSite L  ' +
 ' WHERE A.AdId = B.AdId ' + @sqlCode +
 ' AND B.DelFlag <> ''3'' ' +
 ' AND B.SaleOkFlag <> ''1'' ' +
 ' AND B.SpecFlag=''1'' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' +
 ' AND  ( ' +
 '  ( L.LocalSite=' + @StrLocal + ' AND ( L.LocalBranch=B.LocalBranch OR L.LocalBranch=LEFT(B.OptLocalBranch,2) ) ) ' +
 '   OR ' +
 '  ( B.LocalBranch=L.LocalBranch AND B.OptLocalBranch=''80'' AND B.ZipMain=''전국'' )       ) ' +

') AS TotalLocal'+@StrLocal+'GoodsCnt '

PRINT(@strQuery)
EXEC(@strQuery)


-- 순수 지역판 매물

SET @strQuery = 

'SELECT ( ' +

 ' SELECT COUNT(A.Adid) AS OriginalGeneralLocalGoodsCnt ' +
 ' FROM GoodsSubSale A , GoodsMain B , LocalSite L  ' +
 ' WHERE A.AdId = B.AdId ' + @sqlCode +
 ' AND B.DelFlag <> ''3'' ' +
 ' AND B.SaleOkFlag <> ''1'' ' +
 ' AND B.SpecFlag <> ''1'' AND B.StateChk NOT IN (''4'' , ''5'' , ''6'') ' +
 ' AND ( L.LocalSite=' + @StrLocal + ' AND ( L.LocalBranch=B.LocalBranch ) ) ' +

')+(' +

 ' SELECT COUNT(A.Adid) AS OriginalExpertLocalGoodsCnt ' +
 ' FROM GoodsSubSale A , GoodsMain B , LocalSite L  ' +
 ' WHERE A.AdId = B.AdId ' + @sqlCode +
 ' AND B.DelFlag <> ''3'' ' +
 ' AND B.SaleOkFlag <> ''1'' ' +
 ' AND B.SpecFlag=''1'' AND B.StateChk NOT IN (''0'', ''4'' , ''5'' , ''6'') ' +
 ' AND ( L.LocalSite=' + @StrLocal + ' AND ( L.LocalBranch=B.LocalBranch ) ) ' +

') AS TotalOriginal'+@StrLocal+'LocalGoodsCnt '

PRINT(@strQuery)
EXEC(@strQuery)


/*

 순수 전국 대상 매물 (전국판에서 거래희망지역도 전국)

 SELECT COUNT(A.Adid)
 FROM GoodsSubSale A , GoodsMain B
 WHERE A.AdId = B.AdId  
 AND B.DelFlag <> '3'  
 AND B.SaleOkFlag <> '1'  
 AND (
   ( B.SpecFlag <> '1' AND B.StateChk NOT IN ('4' , '5' , '6') )
   OR
   ( B.SpecFlag='1' AND B.StateChk NOT IN ('0', '4' , '5' , '6') )
 )
 AND B.OptLocalBranch='80' AND B.ZipMain='전국'

*/
GO
/****** Object:  StoredProcedure [FindUsed].[ProcPDA_ProdDetail]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [FindUsed].[ProcPDA_ProdDetail]
(
	@AdId			varchar(10)	--상품등록번호
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
)
AS
	DECLARE @SqlStrCode varchar(100)
	IF @StrCode3 <> ''	SET 	@SqlStrCode = ' AND B.Code3='+@StrCode3 + ' '
	ELSE IF @StrCode2 <> ''	SET 	@SqlStrCode = ' AND B.Code2='+@StrCode2 + ' '
	ELSE IF @StrCode1 <> ''	SET	@SqlStrCode = ' AND B.Code1='+@StrCode1 + ' '
	ELSE			SET	@SqlStrCode = ''
	DECLARE @SqlLocalGoods varchar(100)
	SET @SqlLocalGoods = ''
	DECLARE @strQuery varchar(3000)
	SET @strQuery =  'FROM (' +
			' SELECT TOP 50 A.AdId, A.BrandNmDt ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' +
			' WHERE A.AdId = B.AdId ' + @SqlStrCode +
			' AND B.DelFlag = ''0'' ' +
			' AND B.StateChk = ''1'' ' +
			' AND B.RegAmtOk = ''1'' ' +
			' AND B.SaleOkFlag <> ''1'' ' +
			'  ' + @SqlLocalGoods + 'ORDER BY A.AdId DESC' +
			') AS ListTable '
	SET @strQuery =  ' SELECT MIN(AdId) ' + @strQuery + ' WHERE AdId > ' + @AdId + ';' +
			' SELECT MAX(AdId) ' + @strQuery + ' WHERE AdId < ' + @AdId + ';'
	SET @strQuery = @strQuery + 
			' SELECT A.BrandNmDt, A.BrandNm, A.UseGbn, A.GoodsQt, A.WishAmt, A.SendGbn, ' +
			' A.SaleSendWay, A.SendCharge, A.Etctext, B.ZipMain, B.ZipSub, B.UserName, B.Email ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted) ' +
			' WHERE A.AdId = B.AdId AND A.AdId = ' + @AdId
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [FindUsed].[ProcPDA_ProdList]    Script Date: 2021-11-04 오전 10:19:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [FindUsed].[ProcPDA_ProdList]
(
	@GetCount		varchar(10)
,	@StrCode1		varchar(10)
,	@StrCode2		varchar(10)
,	@StrCode3		varchar(10)
)
AS
	DECLARE @SqlStrCode varchar(100)
	IF @StrCode3 <> ''	SET 	@SqlStrCode = ' AND B.Code3='+@StrCode3 + ' '
	ELSE IF @StrCode2 <> ''	SET 	@SqlStrCode = ' AND B.Code2='+@StrCode2 + ' '
	ELSE IF @StrCode1 <> ''	SET	@SqlStrCode = ' AND B.Code1='+@StrCode1 + ' '
	ELSE			SET	@SqlStrCode = ''
	DECLARE @SqlLocalGoods varchar(100)
	SET @SqlLocalGoods = ''
	DECLARE @strQuery varchar(3000)
	SET @strQuery =  'FROM (' +
			' SELECT TOP 50 A.AdId, A.BrandNmDt, B.RegDate ' +
			' FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted) , GoodsMain B WITH (NoLock, ReadUnCommitted) ' +
			' WHERE A.AdId = B.AdId ' + @SqlStrCode +
			' AND B.DelFlag = ''0'' ' +
			' AND B.StateChk = ''1'' ' + 
			' AND B.RegAmtOK = ''1'' ' + 
			' AND B.SaleOkFlag <> ''1'' ' +
			'  ' + @SqlLocalGoods + ' ORDER BY A.AdId DESC' +
			') AS ListTable '
	IF @GetCount = '0'	SET @strQuery = ' SELECT COUNT(AdId) ' + @strQuery
	ELSE			SET @strQuery = ' SELECT TOP ' + @GetCount + ' AdId, BrandNmDt, CONVERT(CHAR(5), RegDate, 1) AS RegDate ' + @strQuery + ' ORDER BY AdId DESC'
EXEC(@strQuery)
GO
