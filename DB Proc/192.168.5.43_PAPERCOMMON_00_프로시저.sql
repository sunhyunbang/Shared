USE [PAPERCOMMON]
GO
/****** Object:  StoredProcedure [dbo].[_FA_MagRecPaper_Insert_20191001]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[_FA_MagRecPaper_Insert_20191001]
(
	@LayoutBranch 	int,
	@Code4 		int,
	@AdGbn 	char(1),
	@UserID 	varchar(50),
	@UserName 	varchar(30),
            	@ChargePerson	Varchar(30),
	@Phone 	varchar(20),
	@HPhone 	varchar(20),
	@Email 		varchar(30),
	@URL 		varchar(50),
	@ShopNm 	varchar(30),
	@PrnStDay 	datetime,
	@PrnCnt 	int,
	@PrnAmt 	decimal(9),
	@ZipMain 	varchar(20),
	@ZipSub 	varchar(20),
            	@Address 	varchar(50),
            	@Contents 	varchar(100),
            	@PdfFile 	varchar(100),
            	@ChargeText 	varchar(50)
)
AS
DECLARE @StateChk 	char(1)
	SET @StateChk 	= '1'
DECLARE @PrnEnDay 	datetime
	SET @PrnEnDay 	= DATEADD(dd,@PrnCnt ,@PrnStDay)
DECLARE @PrnCnt1 int
	SET @PrnCnt1 = DATEDIFF(dd,@PrnStDay ,@PrnEnDay)

INSERT  INTO RecPaper
	(
	LayoutBranch,
	Code,
	AdGbn,
	UserID,
	UserName,
            	Manager,
	Phone,
	HPhone,
	Email,
	URL,
	ShopNm,
	PrnStDay,
	PrnEnDay,
	PrnCnt,
	PrnAmt,
            	StateChk,
	ZipMain,
	ZipSub,
            	Address,
            	Contents,
            	PdfFile,
            	ChargeText
	)
VALUES
	(
	@LayoutBranch,
	@Code4,
	@AdGbn,
	@UserID,
	@UserName,
	@ChargePerson,
	@Phone,
	@HPhone,
	@Email,
	@URL,
	@ShopNm,
	@PrnStDay,
	@PrnEnDay,
	@PrnCnt,
	@PrnAmt,
            	@StateChk,
	@ZipMain,
	@ZipSub,
            	@Address,
	@Contents,
	@PdfFile,
	@ChargeText
	)




GO
/****** Object:  StoredProcedure [dbo].[_FA_PaperCommon_Insert_20191001]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_FA_PaperCommon_Insert_20191001]
(
	@AdGbn 	Char(1),
	@LayoutBranch 	int,
	@Code 		int,
	@CodeNm 	varchar(20),
	@ConBranch	varchar(100),
	@UserID 	varchar(30),
	@UserName 	varchar(30),
	@ShopNm 	varchar(50),
	@Phone 	varchar(30),
	@HPhone 	varchar(30),
	@Email 		varchar(50),
	@URL 		varchar(50),
            	@Contents 	varchar(1000),
	@ZipMain 	varchar(30),
	@ZipSub 	varchar(30),
	@Address 	varchar(100),
	@Manager 	varchar(30),
	@StateChk 	char(1)
)
AS
DECLARE @LineAdId 	int
INSERT  INTO RecPaper
	(
	AdGbn,
	LayoutBranch,
	ConBranch,
	Code,
	CodeNm,
	UserID,
	UserName,
	ShopNm,
	Phone,
	HPhone,
	Email,
	Url,
	Contents,
	ZipMain,
	ZipSub,
            	Address,
            	Manager,
            	StateChk
	)
VALUES
	(
	@AdGbn,
	@LayoutBranch,
	@ConBranch,
	@Code,
	@CodeNm,
	@UserID,
	@UserName,
	@ShopNm,
	@Phone,
	@HPhone,
	@Email,
	@URL,
	@Contents,
	@ZipMain,
	@ZipSub,
            	@Address,
            	@Manager,
	@StateChk
	)
SELECT @LineAdId = @@IDENTITY
SELECT @LineAdId As LineAdId




GO
/****** Object:  StoredProcedure [dbo].[BAT_BOX_EPAPER_SUBC_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 박스광고주 메일 발송
 *  수   정   자 : 김 문 화
 *  수   정   일 : 2011-10-18
 *  설        명 : 직접등록 > E-Paper 정기구독 메일 발송 추가
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE PROC [dbo].[BAT_BOX_EPAPER_SUBC_PROC]
AS

SET NOCOUNT ON

TRUNCATE TABLE CM_TODAYEBOOK_BOX_TB

INSERT INTO CM_TODAYEBOOK_BOX_TB
     (
       INPUTBRANCH
     , USERNAME
     , USEREMAIL
     , EMAILRECVF
     , BRANCHNAME
     , BOXTEL
     , SENDYEAR
     , SENDMONTH
     , SENDDAY
     , USERFLAG
     )
SELECT
       P.INPUTBRANCH
     , P.ORDERNAME
     , P.EMAIL
     , P.EMAILRECVF
     , RTRIM(B.BRANCHNAME)
     , B.BOXTEL
     , YEAR(GETDATE()) AS SENDYEAR
     , MONTH(GETDATE()) AS SENDMONTH
     , DAY(GETDATE()) AS SENDDAY
     , P.USERFLAG
  FROM FINDDB1.PAPER_NEW.DBO.PP_BOX_EPAPER_TB AS P
  JOIN COMMON.DBO.BRANCH AS B ON B.BRANCHCODE=P.INPUTBRANCH
-- WHERE P.EMAIL IN ('sebilia@mediawill.com')

--직접등록 광고주 E-Paper 구독 메일
INSERT INTO CM_TODAYEBOOK_BOX_TB
     (
       INPUTBRANCH
     , USERNAME
     , USEREMAIL
	 , EMAILRECVF
     , BRANCHNAME
     , BOXTEL
     , SENDYEAR
     , SENDMONTH
     , SENDDAY
     , USERFLAG
     )
SELECT
       L.INPUTBRANCH
     , L.ADORDERNAME
     , L.EMAIL
	 , 1
     , RTRIM(B.BRANCHNAME) AS BRANCHNAME
     , B.BOXTEL
     , YEAR(GETDATE()) AS SENDYEAR
     , MONTH(GETDATE()) AS SENDMONTH
     , DAY(GETDATE()) AS SENDDAY
     , 2
  FROM FINDDB1.PAPERREG.DBO.LINEAD AS L
  JOIN COMMON.DBO.BRANCH AS B ON B.BRANCHCODE=L.INPUTBRANCH
  LEFT JOIN FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB AS U ON U.USEREMAIL1 = L.EMAIL
  LEFT JOIN FINDDB1.PAPER_NEW.DBO.PP_BOX_EPAPER_TB AS E ON E.EMAIL = L.EMAIL
  WHERE
		L.EPaperFlag = 0																		--E-Paper수신 (0:예 1:아니오)
		AND CONVERT(VARCHAR(8), L.STARTDATE, 112) <= CONVERT(VARCHAR(8), GETDATE(), 112)		--시작일체크(광고게재기간만 메일발송)
		AND CONVERT(VARCHAR(8), L.ENDDATE, 112) >= CONVERT(VARCHAR(8), GETDATE(), 112)			--종료일체크(광고게재기간만 메일발송)
		AND L.AdType = 1																		--직접등록 광고만
		AND L.ConfirmF = 0																		--게재진행
		AND L.CancelCode = 0																	--정상광고
		AND (U.READINGFLAG = '0' OR U.READINGFLAG IS NULL)										--정기구독메일 수신자 제외 (중복발송방지)
		AND E.EMAIL IS NULL																		--박스광고주 구독메일자 제외 (중복발송방지)
	GROUP BY  L.INPUTBRANCH, L.ADORDERNAME,  L.EMAIL, B.BRANCHNAME, B.BOXTEL					--여러광고등록시 중복메일 방지를 위해 그룹BY



--데이타 중복 제거
DELETE FROM CM_TODAYEBOOK_BOX_TB
 WHERE PKEY IN (
SELECT A.PKEY AS PKEY
  FROM CM_TODAYEBOOK_BOX_TB AS A
  JOIN (
SELECT
       MAX(PKEY) AS PKEY,
       USEREMAIL,
       COUNT(*) AS COU
  FROM CM_TODAYEBOOK_BOX_TB
 GROUP BY USEREMAIL
 HAVING COUNT(*)>1
 ) AS B ON A.USEREMAIL=B.USEREMAIL AND A.PKEY<>B.PKEY
 )






GO
/****** Object:  StoredProcedure [dbo].[CUID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
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

	UPDATE A SET CUID=@MASTER_CUID FROM BadAdCaution A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM BadAdCaution2 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM CM_TODAYEBOOK_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET ENC_CUID=@MASTER_CUID FROM CM_TODAYEBOOK_TB A  where ENC_CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM FreePaper A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM FreePaper2 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM OrderMail A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM RecPaper A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM Temp_OrderMail A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM Temp_OrderMail_Result A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM Temp_OrderMail_Result_마지막 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM TodayFreePaper A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM UserSaveAd A  where CUID=@SLAVE_CUID



/*
	INSERT PAPER_NEW.DBO.CUID_CHANGE_HISTORY_TB (B_CUID, N_CUID, USERID, DB_NAME, USERIP)
		SELECT @MASTER_CUID , @SLAVE_CUID,@MASTER_USERID,DB_NAME(),@CLIENT_IP
*/		
END







GO
/****** Object:  StoredProcedure [dbo].[EDIT_PDFSERVICE_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[EDIT_PDFSERVICE_PROC]

	@BRANCHCODE		INT
   ,@PDFCODE		INT

AS

IF @BRANCHCODE <> '' AND @PDFCODE <> ''

BEGIN

	BEGIN DISTRIBUTED TRANSACTION

	UPDATE DBO.PDFMAIN
	   SET VIEWFLAG = '1'
	 WHERE BRANCHCODE = @BRANCHCODE
	   AND PDFCODE=@PDFCODE

	UPDATE DBO.PDFCONTENTS
	   SET VIEWFLAG = '1'
	 WHERE BRANCHCODE = @BRANCHCODE
	   AND PDFCODE=@PDFCODE

	IF @@ERROR = 0
	    COMMIT TRAN
	ELSE
	    ROLLBACK TRAN

END





GO
/****** Object:  StoredProcedure [dbo].[FA_MagPdf_Mod]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[FA_MagPdf_Mod]
(
	@LayoutBranch	int
,	@LineAdId		int
,	@UserName		varchar(30)
,	@Phone			varchar(20)
,	@HPhone		varchar(20)
,	@Email			varchar(30)
,	@URL			varchar(50)
,	@ShopNm		varchar(30)
,	@Address		varchar(100)
,	@ZipMain		varchar(20)
,	@ZipSub		varchar(20)
,	@Contents 		varchar(6000)
,	@ChargePerson		varchar(30)
,	@PdfFile			varchar(100)
,	@ChargeText		varchar(50)
)
AS
BEGIN
BEGIN DISTRIBUTED TRANSACTION

--EXEC PaperCat.dbo.FA_Pdf_Mod 80, @LineAdId, @UserName, @Phone, @HPhone, @Email, @URL, @ShopNm, @Contents, @PdfFile

--본서버 반영시 아래 쿼리 적용
EXEC FINDDB1.PaperCat.dbo.FA_Pdf_Mod 80, @LineAdId, @UserName, @Phone, @HPhone, @Email, @URL, @ShopNm, @Contents, @PdfFile


UPDATE RecPaper SET
	UserName	=	@UserName
,	Phone		=	@Phone
,	HPhone		=	@HPhone
,	Email		=	@Email
,	URL		=	@URL
,	ShopNm		=	@ShopNm
,	Address		=	@Address
,	ZipMain		=	@ZipMain
,	ZipSub		=	@ZipSub
,	Contents		=	@Contents
,	Manager	=	@ChargePerson
,	PdfFile		=	@PdfFile
,	ChargeText	=	@ChargeText
,	TransDate	=	GetDate()
,	StateChk		=	2
WHERE LayoutBranch = @LayoutBranch AND LineAdId = @LineAdId


IF @@error = 0
    COMMIT TRAN
ELSE
    ROLLBACK TRAN
END









GO
/****** Object:  StoredProcedure [dbo].[FA_MyAdDetail]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FA_MyAdDetail]
(
	@LayoutBranch int,
	@LineAdId int,
	@Code int
)
AS
DECLARE @strQuery varchar(500)
SET @strQuery = 	'SELECT TOP 1 * FROM RecPaper  ' +
	  	'WHERE LayoutBranch =' + CONVERT(varchar(10),@LayoutBranch) +
		'	AND LineAdId =' + CONVERT(varchar(10),@LineAdId) +
		'	AND Code =' + CONVERT(varchar(10),@Code)
Exec(@strQuery)




GO
/****** Object:  StoredProcedure [dbo].[FA_MyAdList]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
	시스템	: 신문 줄광고 수정/삭제 리스트 프로시저
	작성자	:
	작성일	: 2002-07-19
	셜명	:
*************************************************************************************/
CREATE PROCEDURE [dbo].[FA_MyAdList]
(
	@AdGbn			char,		-- 광고구분
	@cboCate		int,		-- 분류
	@UserID 		varchar(30),
	@PageSize		int,
	@Page			int,
	@strFrDate		varchar(10),	-- 날짜 검색조건(부터)
	@strToDate		varchar(10)	-- 날짜 검색조건(까지)
)
AS
-- 광고구분 구분쿼리 시작
DECLARE @AdGbnSql varchar(50)
IF @AdGbn <> 0
	BEGIN
		SET @AdGbnSql =
			CASE
				WHEN @AdGbn = '1' THEN	-- 줄
				' And AdGbn = 1 '
				WHEN @AdGbn = '2' THEN	-- 박스
				' And AdGbn = 2 '
			END
	END
ELSE
	BEGIN
		SET @AdGbnSql = ''
	END
-- 광고구분 구분쿼리 끝
-- 분류 구분쿼리 시작
DECLARE @CateSql varchar(50)
IF @cboCate <> 0
	BEGIN
		SET @CateSql =
			CASE
				WHEN @cboCate = '1' THEN	-- 상품&서비스
				' AND Code = 1 '
				WHEN @cboCate = '2' THEN	-- 자동차
				' AND Code = 2 '
				WHEN @cboCate = '3' THEN	-- 부동산
				' AND Code = 3 '
				WHEN @cboCate = '4' THEN	-- 구인/구직
				' AND Code = 4 '
			END
	END
ELSE
	BEGIN
		SET @CateSql = ''
	END
-- 분류 구분쿼리 끝
-- 날짜 검색쿼리 시작
DECLARE @DateSql varchar(200)
IF @strFrDate <> '' AND @strToDate <> ''
	BEGIN
		SET @DateSql =
		' AND Convert(VarChar(10),RegDate,120) >= ' + '''' + @strFrDate + '''' + ' AND Convert(VarChar(10),RegDate,120) <= ' + '''' + @strToDate + ''''
	END
ELSE
	BEGIN
		SET @DateSql = ''
	END
-- 날짜 검색쿼리 끝
DECLARE @strQuery varchar(4000)
SET @strQuery =
	' SELECT TOP 1 COUNT(LineAdId) AS DataCnt FROM RecPaper ' +
	' WHERE 1=1 ' + @AdGbnSql + ' AND LayoutBranch <> 80 AND StateChk <> 3 ' + @CateSql + @DateSql +
	' AND UserID = '+ '''' + @UserID + '''' + '; ' +
	' SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) + ' LayoutBranch, LineAdId, Code, Contents,' +
	' CONVERT(varchar(10), RegDate, 120) AS RegDate ' +
	' FROM RecPaper ' +
	' WHERE 1=1 ' + @AdGbnSql + ' AND LayoutBranch <> 80 AND StateChk <> 3 ' + @CateSql + @DateSql +
	' AND UserID = '+ '''' + @UserID + '''' +
	' ORDER BY  RegDate DESC, Code ASC '
PRINT(@strQuery)
EXEC(@strQuery)








GO
/****** Object:  StoredProcedure [dbo].[FA_MyScrap_BoxList]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[FA_MyScrap_BoxList]
	@UserID		varchar(30)
 AS
DECLARE 	@Sql			varchar(1000)
	SET @UserID	= 	' AND A.UserID = ''' + @UserID + ''''
-- 신문 박스광고 AdGbn = 2
	SET @Sql	=  	'SELECT a.UserID, a.AdGbn, b.Inputbranch, b.Layoutbranch, b.Lineadid, b.Contents, b.Phone, b.Code1, b.Code4, b.ShopNm, b.PdfFile, c.CodeNm1,  c.CodeNm3, c.CodeNm4
					FROM UserSaveAD a, FindDB1.PaperCat.dbo.CatBoxPaper  b ,  FindDB1.PaperCat.dbo.BoxCode  c
				WHERE  (a.InputBranch = b.InputBranch AND a.LayoutBranch= b.LayoutBranch AND a.LineAdId = b.LineAdId)
					AND (b.Code4 = c.Code4) ' + @UserID + ' AND a.AdGbn = ''2'' Order By a.RegDate DESC'
	BEGIN
		PRINT(@Sql)
		Exec(@Sql)
	END




GO
/****** Object:  StoredProcedure [dbo].[FA_MyScrap_LineList]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[FA_MyScrap_LineList]
	@UserID		varchar(30)
 AS
DECLARE 	@Sql			varchar(1000)
	SET @UserID	= 	' AND A.UserID = ''' + @UserID + ''''
-- 신문 줄광고 AdGbn = 1
	SET @Sql	 = 	'SELECT a.UserID, a.AdGbn, b.Inputbranch, b.Layoutbranch, b.Lineadid, b.Contents, b.Phone, b.Code,b.Metro,b.City,b.Dong, c.CodeNm1, c.CodeNm2, c.CodeNm3, c.CodeNm4
					FROM UserSaveAD a,  FINDDB1.PaperCat.dbo.CatCommon  b ,  FINDDB1.PaperCat.dbo.CatCode  c
				WHERE  (a.InputBranch = b.InputBranch AND a.LayoutBranch= b.LayoutBranch AND a.LineAdId = b.LineAdId)
					AND (b.Code = c.Code4) ' + @UserID + ' AND a.AdGbn = ''1'' Order By a.RegDate DESC'
	BEGIN
		PRINT(@Sql)
		Exec(@Sql)
	END




GO
/****** Object:  StoredProcedure [dbo].[FA_PaperCommon_Mod]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FA_PaperCommon_Mod]
(
	@LayoutBranch	int,
	@LineAdId	int,
	@Contents	varchar(500),
	@UserName	varchar(30),
	@Manager	varchar(50),
	@Phone		varchar(20),
	@HPhone	varchar(20),
	@Email		varchar(30),
	@URL		varchar(50),
	@ShopNm	varchar(30),
	@ZipMain	varchar(20),
	@ZipSub	varchar(20),
	@Address	varchar(100)
)
AS
UPDATE RecPaper SET
	UserName	=  @UserName,
	Manager	=  @Manager,
	Phone		=  @Phone,
	HPhone		=  @HPhone,
	Email		=  @Email,
	URL		=  @URL,
	ShopNm		=  @ShopNm,
	ZipMain		=  @ZipMain,
	ZipSub		=  @ZipSub,
	Address		=  @Address,
	ModDate		=  GetDate(),
	Contents		=  @Contents,
	StateChk		= '2'
WHERE 	LayoutBranch 	= @LayoutBranch AND LineAdId    = @LineAdId




GO
/****** Object:  StoredProcedure [dbo].[FA_PaperLine_Insert]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[FA_PaperLine_Insert]
(
	@AdGbn 	Char(1),
	@LayoutBranch 	int,
	@Code 		int,
	@CodeNm 	varchar(100),
	@ConBranch	varchar(100),
	@AdKind		varchar(10),
	@InputCount	varchar(20),
	@AccentF	char(1),
	@UserID 	varchar(30),
	@UserName 	varchar(30),
	@ShopNm 	varchar(50),
	@Phone 	varchar(30),
	@HPhone 	varchar(30),
	@Email 		varchar(50),
	@URL 		varchar(50),
            	@Contents 	varchar(1000),
	@ZipMain 	varchar(30),
	@ZipSub 	varchar(30),
	@Address 	varchar(100),
	@Manager 	varchar(30),
	@StateChk 	char(1),
	@CUID		INT
)
AS
DECLARE @LineAdId 	int
INSERT  INTO RecPaper
	(
	AdGbn,
	LayoutBranch,
	ConBranch,
	Code,
	CodeNm,
	AdKind,
	InputCount,
	AccentF,
	UserID,
	UserName,
	ShopNm,
	Phone,
	HPhone,
	Email,
	Url,
	Contents,
	ZipMain,
	ZipSub,
	Address,
	Manager,
	StateChk,
	CUID
	)
VALUES
	(
	@AdGbn,
	@LayoutBranch,
	@ConBranch,
	@Code,
	@CodeNm,
	@AdKind,
	@InputCount,
	@AccentF,
	@UserID,
	@UserName,
	@ShopNm,
	@Phone,
	@HPhone,
	@Email,
	@URL,
	@Contents,
	@ZipMain,
	@ZipSub,
	@Address,
	@Manager,
	@StateChk,
	@CUID
	)
SELECT @LineAdId = @@IDENTITY
SELECT @LineAdId As LineAdId







GO
/****** Object:  StoredProcedure [dbo].[FA_PdfContents_Save]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FA_PdfContents_Save]
AS

--전면PDF 서비스 관련 Save테이블로 이동
--서비스 테이블에는 1달 자료만 남아 있음
--작성자 : 김준범
--작성일 : 2003년 10월 24일
--Drop Table #PdfMain_Tmp
--Drop Table #PdfContents_Tmp

--1. PDFMain 테이블 이동 및 삭제
--한달치 레코드를 제외한 모든 데이터 Serial 값을 Tmp에 저장

Select Serial
INTO #PdfMain_Tmp
From PaperCommon.dbo.PdfMain Where
Convert(varchar(10),DATEADD(mm,1,RegDate),120) <= Convert(varchar(10),GetDate(),120)
AND BranchCode < 110


--Tmp테이블 이용해서 Save테이블로 이동
INSERT INTO  PaperCommon.dbo.PdfMain_Save
SELECT * FROM  PaperCommon.dbo.PdfMain
WHERE Serial In (Select Serial From #PdfMain_Tmp)

--Tmp테이블 이용해서 한달치 자료를 제외한 자료 모두 삭제
DELETE FROM  PaperCommon.dbo.PdfMain
WHERE Serial In (Select Serial From #PdfMain_Tmp)



--2. PDFContents 테이블 이동 및 삭제
--한달치 레코드를 제외한 모든 데이터 Serial 값을 Tmp에 저장
Select Serial
INTO #PdfContents_Tmp
FROM PdfContents
WHERE Convert(varchar(10),DATEADD(mm,1,RegDate),120) <= Convert(varchar(10),GetDate(),120)
AND BranchCode < 110

--Tmp테이블 이용해서 Save테이블로 이동
INSERT INTO  PaperCommon.dbo.PdfContents_Save
SELECT * FROM  PaperCommon.dbo.PdfContents
WHERE Serial In (Select Serial From #PdfContents_Tmp)


--Tmp테이블 이용해서 한달치 자료를 제외한 자료 모두 삭제
DELETE FROM  PaperCommon.dbo.PdfContents
WHERE Serial In (Select Serial From #PdfContents_Tmp)




GO
/****** Object:  StoredProcedure [dbo].[FA_PDFStat_List]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[FA_PDFStat_List]
(
	@Page		int
,	@PageSize	int
,	@cboBranch	int
,	@strFrDate	varchar(10)
,	@strToDate	varchar(10)
,	@rdoOrder	char(1)
,	@rdoViewCnt	char(1)
)
AS
-- 게재지점 검색쿼리 시작
DECLARE @BranchSql	varchar(100)
IF @cboBranch <> 0
	BEGIN
		SET	@BranchSql = ' AND P.BranchCode = ' + CONVERT(varchar(10), @cboBranch)
	END
ELSE
	BEGIN
		SET	@BranchSql = ''
	END
-- 게재지점 검색쿼리 끝
-- 날짜 검색쿼리 시작
DECLARE @DateSql	varchar(200)
IF @strFrDate <> ''
	BEGIN
		SET	@DateSql = ' AND CONVERT(varchar(10), P.ViewDate, 120) >= ' + '''' + @strFrDate + '''' + ' AND CONVERT(varchar(10), P.ViewDate, 120) <= ' + '''' + @strToDate + ''''
	END
ELSE
	BEGIN
		SET	@DateSql = ''
	END
-- 날짜 검색쿼리 끝
-- 레코드 정렬 쿼리 시작
DECLARE @OrderSql	varchar(200)
IF @rdoOrder = ''
	BEGIN
		SET	@OrderSql = ' ORDER BY B.BranchName, P.Code1 ASC, P.ViewCnt DESC '
	END
ELSE
	BEGIN
		SET	@OrderSql =
			CASE
				WHEN @rdoOrder = 'A' THEN	' ORDER BY P.ViewCnt DESC '
				WHEN @rdoOrder = 'B' THEN	' ORDER BY B.BranchName ASC, P.ViewCnt DESC '
				WHEN @rdoOrder = 'C' THEN	' ORDER BY B.BranchName, P.Code1 ASC, P.ViewCnt DESC '
			END
	END
-- 레코드 정렬 쿼리 끝
-- 조회수기준 쿼리 시작
DECLARE @ViewCntSql	varchar(100)
IF @rdoViewCnt = ''
	BEGIN
		SET @ViewCntSql = 'P.ViewCnt > 1 '
	END
ELSE
	BEGIN
		SET @ViewCntSql =
			CASE
				WHEN @rdoViewCnt = 'A' THEN 'P.ViewCnt = 1'
				WHEN @rdoViewCnt = 'B' THEN 'P.ViewCnt >= 2'
				ELSE 'P.ViewCnt >= ' + CONVERT(varchar(10),@rdoViewCnt)
			END
	END
-- 조회수기준 쿼리 끝
DECLARE @Sql	varchar(6000)
SET @Sql =
--	'SELECT COUNT(*) FROM PdfStat P, FINDDB2.Common.dbo.Branch B, PaperCat.dbo.BoxCode C ' +
--본서버 적용시
	'SELECT COUNT(*) FROM PdfStat P, FindDB2.Common.dbo.Branch B, FindDB1.PaperCat.dbo.BoxCode C ' +
	'WHERE ' + @ViewCntSql + ' AND P.BranchCode = B.BranchCode AND P.Code4 = C.Code4 ' + @BranchSql + ' ' + @DateSql + '; ' +
	'SELECT TOP ' + CONVERT(varchar(10),@Page*@PageSize) + ' P.BranchCode, B.BranchName, P.Code1, P.ShopNm, P.PdfFile, P.ViewCnt, ' +
	'C.CodeNm1, C.CodeNm2, C.CodeNm3, C.CodeNm4 ' +
--	'FROM PdfStat P, FINDDB2.Common.dbo.Branch B, PaperCat.dbo.BoxCode C ' +
--본서버 적용시
	'FROM PdfStat P, FindDB2.Common.dbo.Branch B, FindDB1.PaperCat.dbo.BoxCode C ' +
	'WHERE ' + @ViewCntSql + ' AND P.BranchCode = B.BranchCode AND P.Code4 = C.Code4 ' + @BranchSql + ' ' + @DateSql + + @OrderSql
--PRINT(@Sql)
EXEC(@Sql)




GO
/****** Object:  StoredProcedure [dbo].[FA_Scrap_Insert]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FA_Scrap_Insert]
(
	@UserID	varchar(30),
	@AdGbn	char(1),
	@InputBranch 	int,
	@LayoutBranch int,
    	@LineAdId 	int
)
AS
DECLARE	@ScrapChk	int
SELECT @ScrapChk = Count(*)
	FROM UserSaveAd
	WHERE UserID = @UserID AND AdGbn = @AdGbn AND InputBranch = @InputBranch AND LayoutBranch = @LayoutBranch And LineAdId = @LineAdId
IF @ScrapChk < = 0
    BEGIN
	INSERT  INTO UserSaveAd
		(
		UserID,
		AdGbn,
		InputBranch,
		LayoutBranch,
		LineAdId
		)
	VALUES
		(
		@UserID,
		@AdGbn,
		@InputBranch,
		@LayoutBranch,
		@LineAdId
		)
    END
ELSE
	PRINT(@ScrapChk)




GO
/****** Object:  StoredProcedure [dbo].[GET_EBOOK_CONFIG]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
* e-book 보기 데이터 가져오기

SELECT TOP 10 * FROM EBOOK.EBOOK2005.DBO.PREMIUM

EXEC GET_EBOOK_CONFIG 60

*/

CREATE PROC [dbo].[GET_EBOOK_CONFIG]
	@BRANCHCODE INT
AS

SET NOCOUNT ON

SELECT MEM_ID
  INTO #EBOOK_BRANCH
  FROM EBOOK.EBOOK2005.DBO.MEMBER
 WHERE FINDALL_BRANCHCODE = @BRANCHCODE
   ORDER BY MEM_ID


DECLARE @MEM_ID VARCHAR(50)

DECLARE EBOOK_CURSOR CURSOR
FOR
	SELECT MEM_ID
	  FROM #EBOOK_BRANCH

OPEN EBOOK_CURSOR

FETCH NEXT FROM EBOOK_CURSOR
INTO @MEM_ID

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT TOP 7
	       P.MEM_ID
	     , P.FOLDERNAME
	     , P.ISSUEDATE
	     , P.ISSUEHO
	  FROM EBOOK.EBOOK2005.DBO.MEMBER AS M
	  JOIN EBOOK.EBOOK2005.DBO.PREMIUM AS P ON P.MEM_ID = M.MEM_ID
	 WHERE P.MEM_ID = @MEM_ID
-- 실서버에서는 아래의 주석을 풀어야 함
--           AND P.FLAG_JOB IN (5)	--4는 이북 생성중, 5는 완료
	 ORDER BY P.ISSUEDATE DESC

	FETCH NEXT FROM EBOOK_CURSOR
	INTO @MEM_ID
END

CLOSE EBOOK_CURSOR
DEALLOCATE EBOOK_CURSOR





GO
/****** Object:  StoredProcedure [dbo].[GET_F_BOXLINEAD_ASK_LIST_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : 프런트 - MY벼룩시장 - 광고관리 - 줄/박스광고 신청관리
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/02/23
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :  EXEC DBO.GET_F_BOXLINEAD_ASK_LIST_PROC 1, 15, 'devkdh', '1'
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_BOXLINEAD_ASK_LIST_PROC]

	@PAGE					INT,
	@PAGESIZE			INT,

	@USERID				VARCHAR(30),
	@ADGBN				CHAR(1)

AS
DECLARE
	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SET @WHERE = ''

  /*
  IF @ADGBN <> ''
    BEGIN
      SET @WHERE = 'AND TA.ADGBN = ''' + @ADGBN + ''''
    END
  */

	SET @SQL = '' +
			' SELECT ' +
			' 	COUNT(TA.LINEADID) AS CNT ' +
			' FROM  ' +
			' 	dbo.RecPaper TA(NOLOCK) ' +
			' 	LEFT JOIN dbo.RecPaper_Counsel TB(NOLOCK) ON TA.LINEADID=TB.LINEADID ' +
			' WHERE ' +
			'		TA.USERID = ''' + @USERID + '''' +
      '   '+ @WHERE +'' +
			' 	AND TA.ADGBN IN (1,2,4) AND LAYOUTBRANCH<>80  ' +
			'		AND TA.STATECHK IN(''1'',''2'') ; ' +

			' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
			' 	TA.LINEADID, ' +
			' 	TA.ADGBN,  ' +
			' 	TA.LAYOUTBRANCH, TA.CONBRANCH, ' +
			' 	TA.REGDATE,  ' +
			' 	TA.CODE, TA.CODENM,  ' +
			' 	TA.PAGEFLAG, TA.STATECHK, TA.REGCNCL, ' +
			' 	TB.ADFLAG, TA.CONTENTS, TB.LINEADID ' +
			' FROM  ' +
			' 	dbo.RecPaper TA(NOLOCK) ' +
			' 	LEFT JOIN dbo.RecPaper_Counsel TB(NOLOCK) ON TA.LINEADID=TB.LINEADID ' +
			' WHERE ' +
			'		TA.USERID = ''' + @USERID + '''' +
      '   '+ @WHERE +'' +
			' 	AND TA.ADGBN IN (1,2,4) AND LAYOUTBRANCH<>80 ' +
			'		AND TA.STATECHK IN(''1'',''2'')  ' +
			' ORDER BY ' +
			' 	TA.LINEADID DESC '

  --PRINT @SQL
  EXECUTE SP_EXECUTESQL @SQL








GO
/****** Object:  StoredProcedure [dbo].[GET_F_EMAILBRIDGE_EPAPERINFO_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 정기구독 이메일 - 메일에서 지점 클릭시 지점별 EBOOK정보 가져오기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : HTTP://PAPER.FINDALL.CO.KR/CATEGORY/EPAPER/EPAPER_MAIL_BRIDGE.ASP
 *  사 용  예 제 : EXEC DBO.GET_F_EMAILBRIDGE_EPAPERINFO_PROC '16'
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_EMAILBRIDGE_EPAPERINFO_PROC]
	@BRANCHCODE VARCHAR(3)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

	--## 일본벼룩시장(PDF)인 경우
	IF @BRANCHCODE='110'
		BEGIN
			SELECT
				TOP 1 PDFCODE
			FROM
				DBO.PDFMAIN(NOLOCK)
			WHERE
				BRANCHCODE=@BRANCHCODE AND
				VIEWFLAG =1
			ORDER BY
				PDFCODE DESC
		END
	ELSE
		BEGIN
			SELECT
				TOP 1
				P.FOLDERNAME,
				M.MEM_ID,
				P.MAXPAGE,
				M.FINDALL_BRANCHCODE
			FROM
				EBOOK.EBOOK2005.DBO.MEMBER M,
				EBOOK.EBOOK2005.DBO.PREMIUM P
			WHERE
				M.MEM_ID = P.MEM_ID AND
				P.MAXPAGE > 0 AND
				M.FINDALL_BRANCHCODE = @BRANCHCODE
			ORDER BY
				P.ISSUEDATE DESC
		END



GO
/****** Object:  StoredProcedure [dbo].[GET_F_MYPAGE_BOXLINEAD_ASK_LIST_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 프런트 - MY벼룩시장 - 메인 - 줄/박스광고 신청내역
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/02/26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :  EXEC DBO.GET_F_MYPAGE_BOXLINEAD_ASK_LIST_PROC 'devkdh'
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_MYPAGE_BOXLINEAD_ASK_LIST_PROC]
	@CUID	int
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

 --## 박스광고 카운트
	SELECT
		COUNT(TA.LINEADID) AS CNT
	FROM
		dbo.RecPaper TA(NOLOCK)
		LEFT JOIN dbo.RecPaper_Counsel TB(NOLOCK) ON TA.LINEADID=TB.LINEADID
	WHERE
		TA.CUID = @CUID
		AND TA.ADGBN = '2'
		AND TA.ADGBN IN (1,2,4) AND LAYOUTBRANCH<>80
		AND TA.STATECHK IN('1','2')

	--## 박스광고 리스트
	SELECT TOP 3
		TA.LINEADID,
		TA.LAYOUTBRANCH,
		TA.CONBRANCH,
		TA.REGDATE,
		TA.CODE,
		TA.CONTENTS,
		TB.LINEADID
	FROM
		dbo.RecPaper TA(NOLOCK)
		LEFT JOIN dbo.RecPaper_Counsel TB(NOLOCK) ON TA.LINEADID=TB.LINEADID
	WHERE
		TA.CUID = @CUID
		AND TA.ADGBN = '2'
		AND TA.ADGBN IN (1,2,4) AND LAYOUTBRANCH<>80
		AND TA.STATECHK IN('1','2')
	ORDER BY
		TA.LINEADID DESC

 --## 줄광고 카운트
	SELECT
		COUNT(TA.LINEADID) AS CNT
	FROM
		dbo.RecPaper TA(NOLOCK)
		LEFT JOIN dbo.RecPaper_Counsel TB(NOLOCK) ON TA.LINEADID=TB.LINEADID
	WHERE
		TA.CUID = @CUID
		AND TA.ADGBN = '1'
		AND TA.ADGBN IN (1,2,4) AND LAYOUTBRANCH<>80
		AND TA.STATECHK IN('1','2')

	--## 줄광고 리스트
	SELECT TOP 3
		TA.LINEADID,
		TA.LAYOUTBRANCH,
		TA.CONBRANCH,
		TA.REGDATE,
		TA.CODE,
		TA.CONTENTS,
		TB.LINEADID
	FROM
		dbo.RecPaper TA(NOLOCK)
		LEFT JOIN dbo.RecPaper_Counsel TB(NOLOCK) ON TA.LINEADID=TB.LINEADID
	WHERE
		TA.CUID = @CUID
		AND TA.ADGBN = '1'
		AND TA.ADGBN IN (1,2,4) AND LAYOUTBRANCH<>80
		AND TA.STATECHK IN('1','2')
	ORDER BY
		TA.LINEADID DESC






GO
/****** Object:  StoredProcedure [dbo].[GET_F_PDF_CONFIG]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*************************************************************************************
 *  단위 업무 명 : e-book 보기 데이터 가져오기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009-01-23
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :

	EXEC GET_F_PDF_CONFIG 110

 *************************************************************************************/


CREATE PROC [dbo].[GET_F_PDF_CONFIG]
	@BRANCHCODE INT
AS

SET NOCOUNT ON

	SELECT
		TOP 7
		PdfCode,
		(SELECT COUNT(*)+1 FROM dbo.PdfMain(NOLOCK) WHERE branchcode=@BRANCHCODE AND viewFlag='1') AS cnt
	FROM
		dbo.PdfMain(NOLOCK)
	WHERE
		(ViewFlag = '1') AND
		--PDFCode <= Convert(varchar(8),GetDate(),112) AND
		--PDFCode >= Convert(varchar(8),DateAdd(day,-8,GetDate()),112) AND
		BranchCode = @BRANCHCODE
	Group by
		BranchCode, PdfCode
	Order By
		PdfCode Desc











GO
/****** Object:  StoredProcedure [dbo].[GET_F_PDF_DETAIL]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*************************************************************************************
 *  단위 업무 명 : pdf 상세보기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009-01-28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :

	EXEC GET_F_PDF_DETAIL '110','20090116'

 *************************************************************************************/


CREATE PROC [dbo].[GET_F_PDF_DETAIL]
	@BRANCHCODE VARCHAR(10),
	@PDFCODE	VARCHAR(10)
AS

	SELECT
		codenm1, MIN(page) AS page
	FROM
		dbo.PdfContents(NOLOCK)
	WHERE
		viewFlag = '1' AND
		branchcode=@BRANCHCODE AND
		pdfcode=@PDFCODE
	GROUP BY
		code1, codenm1
	ORDER BY
		page








GO
/****** Object:  StoredProcedure [dbo].[GET_M_BOXLINEAD_ASK_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 - 광고신청관리 - 줄/박스광고 상세보기
 *  작   성   자 : 김동협(kdhwarfare@mediawill.com)
 *  작   성   일 : 2009-02-17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC GET_M_BOXLINEAD_ASK_DETAIL_PROC 1271583

 *************************************************************************************/

CREATE PROC [dbo].[GET_M_BOXLINEAD_ASK_DETAIL_PROC]
	@LINEADID VARCHAR(10)
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 페이지 확인 플래그를 확인으로 업데이트
	/*
	UPDATE
		DBO.RECPAPER
	SET
		PAGEFLAG = '1'
	WHERE
		LINEADID = @LINEADID
	*/

	-- 상세내역 가져오기
	SELECT
		TOP 1
		TA.LINEADID,
		TA.ADGBN,
		TA.LAYOUTBRANCH,	ISNULL(TA.CONBRANCH,'') AS CONBRANCH,
		TA.ADKIND,
		TA.INPUTCOUNT,
		TA.ACCENTF,
		TA.CODE, TA.CODENM,
		TA.ZIPMAIN, TA.ZIPSUB,
		TA.SHOPNM,
		TA.USERID, TA.USERNAME,
		TA.PHONE, TA.HPHONE, TA.EMAIL, TA.URL,
		TA.CONTENTS,
		TA.REGDATE,

		TB.COUNSELGBN,
		TB.ADFLAG,
		TB.PRNSTDATE,
		TB.PRNENDATE,
		TB.CONTENTS AS COUNSELCONTENTS
	FROM
		DBO.RECPAPER TA(NOLOCK)
		LEFT JOIN DBO.RECPAPER_COUNSEL TB(NOLOCK) ON TA.LINEADID=TB.LINEADID
	WHERE
		TA.LINEADID = @LINEADID






GO
/****** Object:  StoredProcedure [dbo].[GET_M_BOXLINEAD_ASK_LIST_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 관리단 - 광고신청관리 - 줄/박스광고 신청관리
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/02/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC GET_M_BOXLINEAD_ASK_LIST_PROC 1, 10, '','',1,1,'','','CODE','구인'

EXEC GET_M_BOXLINEAD_ASK_LIST_PROC 1,10,'2009-02-16','2009-02-16','','','','','CODE','부동산'

 *************************************************************************************/

CREATE PROC [dbo].[GET_M_BOXLINEAD_ASK_LIST_PROC]

	@PAGE					INT,
	@PAGESIZE			INT,

	@FROMDATE			VARCHAR(10)='',
	@TODATE				VARCHAR(10)='',

	@ADGBN 					CHAR(1)='',
	@COUNSELYN 			CHAR(1)='',	-- TB.LINEADID IS NOT NULL
	@ADFLAG		 			CHAR(1)='',	-- TB.ADFLAG
	@LAYOUTBRANCH		VARCHAR(3)='',

	@SEARCHFIELD	VARCHAR(10)='',
	@SEARCHTEXT		VARCHAR(30)=''
AS
DECLARE

	@SQL			NVARCHAR(4000),
	@WHERE		NVARCHAR(1000)

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	--검색절 SET
	SET @WHERE = ''
	--날짜
	IF @FROMDATE<>'' AND @TODATE<>''
		SET @WHERE = @WHERE + '   TA.REGDATE BETWEEN ''' + @FROMDATE + ' 00:00:00'' AND ''' + @TODATE + ' 23:59:59'' '
	--줄/박스광고구분
	IF @ADGBN<>''
		SET @WHERE = @WHERE + ' AND  TA.ADGBN = ''' + @ADGBN + ''' '
	--상담여부
	IF @COUNSELYN<>''
		BEGIN
			IF @COUNSELYN = '1'
				SET @WHERE = @WHERE + '  AND TB.LINEADID IS NOT NULL '
			ELSE IF @COUNSELYN = '0'
				SET @WHERE = @WHERE + '  AND TB.LINEADID IS NULL '
		END
	--광고신청여부
	IF @ADFLAG<>''
		SET @WHERE = @WHERE + '  AND TB.ADFLAG = ''' + @ADFLAG + ''' '
	--게재지점
	IF @LAYOUTBRANCH<>''
		SET @WHERE = @WHERE + '  AND TA.LAYOUTBRANCH = ''' + @LAYOUTBRANCH + ''' '
	--검색어
	IF @SEARCHFIELD<>'' AND @SEARCHTEXT<>''
		BEGIN
			IF @SEARCHFIELD='USERNAME'
				SET @WHERE = @WHERE + '  AND  TA.USERNAME LIKE ''%' + @SEARCHTEXT + '%'' '
			ELSE IF @SEARCHFIELD = 'CODE' --상품구분
				BEGIN
					--IF @SEARCHTEXT = '상품&서비스' OR @SEARCHTEXT = '상품' OR @SEARCHTEXT = '서비스'
					IF @SEARCHTEXT = '상품&서비스'
						--SET @WHERE = @WHERE + '   (TA.CODE = 1 OR LEFT(TA.CODE,2) IN (10,11)) AND '
						SET @WHERE = @WHERE + ' AND (TA.CODE = 1 OR LEFT(TA.CODE,2) IN (10,11)) '
					ELSE IF @SEARCHTEXT = '자동차'
						--SET @WHERE = @WHERE + '   (TA.CODE = 2 OR LEFT(TA.CODE,2)=12) AND '
						SET @WHERE = @WHERE + ' AND (TA.CODE = 2 OR LEFT(TA.CODE,2)=12) '
					ELSE IF @SEARCHTEXT = '부동산'
						--SET @WHERE = @WHERE + '   (TA.CODE = 3 OR LEFT(TA.CODE,2)=13) AND '
						SET @WHERE = @WHERE + ' AND (TA.CODE = 3 OR LEFT(TA.CODE,2)=13) '
					--ELSE IF @SEARCHTEXT = '구인&구직' OR @SEARCHTEXT = '구인' OR @SEARCHTEXT = '구직'
					ELSE IF @SEARCHTEXT = '구인&구직'
						--SET @WHERE = @WHERE + '   (TA.CODE = 4 OR LEFT(TA.CODE,2)=14) AND '
						SET @WHERE = @WHERE + ' AND (TA.CODE = 4 OR LEFT(TA.CODE,2)=14) '
					ELSE 
					    SET @WHERE = @WHERE + 'AND (TA.CODENM = ''' + @SEARCHTEXT + ''' )'
				END
			ELSE IF @SEARCHFIELD='USERID'
				--SET @WHERE = @WHERE + '  AND TA.USERID LIKE ''%' + @SEARCHTEXT + '%'' '
				SET @WHERE = @WHERE + '  AND TA.USERID = ''' + @SEARCHTEXT + ''' '
			ELSE IF @SEARCHFIELD='PHONE'
				--SET @WHERE = @WHERE + '  AND TA.PHONE LIKE ''%' + @SEARCHTEXT + '%'' '
				SET @WHERE = @WHERE + '  AND TA.PHONE = ''' + @SEARCHTEXT + ''' '
			ELSE IF @SEARCHFIELD='HPHONE'
				--SET @WHERE = @WHERE + '  AND TA.HPHONE LIKE ''%' + @SEARCHTEXT + '%'' '
				SET @WHERE = @WHERE + '  AND TA.HPHONE = ''' + @SEARCHTEXT + ''' '
			ELSE IF @SEARCHFIELD='LINEADID'
				SET @WHERE = @WHERE + '  AND TA.LINEADID = ''' + @SEARCHTEXT + ''' '
			ELSE
			    SET @WHERE = @WHERE + '  AND TA.' + @SEARCHFIELD + ' = ''' + @SEARCHTEXT + ''' '
		END

	SET @SQL = '' +
			' SELECT ' +
			' 	COUNT(TA.LINEADID) AS CNT ' +
			' FROM  ' +
			' 	dbo.RecPaper TA(NOLOCK) ' +
			' 	LEFT JOIN dbo.RecPaper_Counsel TB(NOLOCK) ON TA.LINEADID=TB.LINEADID ' +
			' WHERE ' +  @WHERE +
			' 	AND TA.ADGBN IN (1,2,4) AND LAYOUTBRANCH<>80 ; ' +

			' SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
			' 	TA.LINEADID, TB.LINEADID, ' +
			' 	TA.ADGBN,  ' +
			' 	TA.USERID, dbo.FN_GET_USERNM_SECURE(TA.USERNAME,1,''M'') AS USERNAME, TA.PHONE, TA.HPHONE, ' +
			' 	TA.LAYOUTBRANCH, TA.CONBRANCH, ' +
			' 	TA.REGDATE,  ' +
			' 	TA.CODE, TA.CODENM,  ' +
			' 	TA.PAGEFLAG, TA.STATECHK, TA.REGCNCL, ' +
			' 	TB.ADFLAG ' +
			' FROM  ' +
			' 	dbo.RecPaper TA(NOLOCK) ' +
			' 	LEFT JOIN dbo.RecPaper_Counsel TB(NOLOCK) ON TA.LINEADID=TB.LINEADID ' +
			' WHERE ' +  @WHERE +
			' 	AND TA.ADGBN IN (1,2,4) AND LAYOUTBRANCH<>80 ' +
			' ORDER BY ' +
			' 	TA.LINEADID DESC '

--PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL









GO
/****** Object:  StoredProcedure [dbo].[MOD_F_BOXLINEAD_ASK_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 프런트 - MY벼룩시장 - 광고관리 - 줄/박스광고 신청관리 - 리스트에서 삭제
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/02/24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
	DECLARE @IRESULT INT
	EXEC DBO.MOD_F_BOXLINEAD_ASK_PROC 'devkdh','1271606,1271605',@IRESULT OUTPUT
	PRINT @IRESULT

SELECT @@TRANCOUNT
 *************************************************************************************/

CREATE PROC [dbo].[MOD_F_BOXLINEAD_ASK_PROC]
	@CUID			INT,
	@APPLYLINEADID	INT,
	@IRESULT				INT=0	OUTPUT
AS

	BEGIN TRAN

DECLARE	@SQL NVARCHAR(300)

	UPDATE RECPAPER
	SET
		STATECHK = '3'
	WHERE
		CUID =  @CUID AND
		LINEADID = @APPLYLINEADID

	IF @@ERROR>0 Or @@ROWCOUNT>1
		BEGIN
			ROLLBACK
			SET @IRESULT = -1
		END
	ELSE
		BEGIN
			COMMIT TRAN
			SET @IRESULT = 1
		END






GO
/****** Object:  StoredProcedure [dbo].[OrderMail_FreePaper]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[OrderMail_FreePaper]
AS

DECLARE @EBookCnt int

SELECT @EBookCnt = COUNT(*) FROM Ebook.Ebook2005.dbo.Premium WHERE IssueDate = CONVERT(varchar(8),getdate(),112)

TRUNCATE TABLE PaperCommon.FreePaper2

IF @EBookCnt > 0

  BEGIN

    INSERT INTO PaperCommon.FreePaper2 (UserID, UserName, UserEmail, StDate, EnDate, SendYear, SendMonth, SendDay)
    SELECT Replace(A.UserID,' ', '') As UserID, Replace(A.UserName,' ', '') As UserName, Replace(A.UserEmail,' ', '') As UserEmail, A.StDate, A.EnDate, Year(getdate()) As SendYear, Month(getdate()) As SendMonth, Day(getdate()) As SendDay
    FROM PaperCommon.FreePaper A, FindDB2.Common.dbo.UserCommon B
    WHERE A.UserId = B.UserId
    	AND A.ReadingFlag = 1
    	AND A.FreeLocal <> ''
    	AND CONVERT(varchar(8), A.StDate, 112) <= CONVERT(varchar(8), getdate(), 112)
    	AND CONVERT(varchar(8), A.EnDate, 112) >= CONVERT(varchar(8), getdate(), 112)
    	AND B.Delflag <> 1

    DELETE FROM PaperCommon.FreePaper2
    WHERE  PATINDEX('%@%', UserEmail) =  0
	OR PATINDEX('%.%', UserEmail) =  0
	OR PATINDEX('%:%', UserEmail) <> 0
	OR PATINDEX('%;%', UserEmail) <> 0
	OR PATINDEX('%/%', UserEmail) <> 0
	OR PATINDEX('%~%', UserEmail) <> 0
	OR PATINDEX('%@',  UserEmail) <> 0
	OR PATINDEX('@%',  UserEmail) <> 0
	OR PATINDEX('%.',  UserEmail) <> 0
	OR PATINDEX('.%',  UserEmail) <> 0
	OR PATINDEX('%"%', UserEmail) <> 0
	OR PATINDEX('%#%', UserEmail) <> 0
	OR PATINDEX('%&%', UserEmail) <> 0
	OR PATINDEX('%*%', UserEmail) <> 0
	OR PATINDEX('%?%', UserEmail) <> 0
	OR PATINDEX('%>%', UserEmail) <> 0
	OR PATINDEX('%<%', UserEmail) <> 0
	OR PATINDEX('%(%', UserEmail) <> 0
	OR PATINDEX('%)%', UserEmail) <> 0
	OR PATINDEX('%^%', UserEmail) <> 0
	OR PATINDEX('%!%', UserEmail) <> 0
	OR PATINDEX('%,%', UserEmail) <> 0
	OR PATINDEX('%`%', UserEmail) <> 0
	OR PATINDEX('%\%', UserEmail) <> 0
	OR (UserEmail >= '가' AND UserEmail <= '히')
	OR (UserEmail LIKE '%www.%' )
  END


GO
/****** Object:  StoredProcedure [dbo].[OrderMail_TempWork]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE     PROCEDURE [dbo].[OrderMail_TempWork]
AS

/*************************************************************************************
 1차 Temp Table 만듬 (대상자, 조건 ...)
*************************************************************************************/

TRUNCATE TABLE Temp_OrderMail

INSERT INTO Temp_OrderMail
SELECT O.Serial, O.UserID, O.Email, O.SearchBranch, O.Code1, O.Code3, O.Code4, 
	 ISNULL(O.Year1, 0) AS Year1, ISNULL(O.Year2, 0) AS Year2, ISNULL(O.Traveling1, 0) AS Traveling1, ISNULL(O.Traveling2, 0) AS Traveling2,
	 ISNULL(O.SelCost1, 0) AS SelCost1, ISNULL(O.SelCost2, 0) AS SelCost2, O.Metro, O.City, O.Dong, 
	 ISNULL(O.WishAmt1, 0) AS WishAmt1, ISNULL(O.WishAmt2, 0) AS WishAmt2, ISNULL(O.Width1, 0) AS Width1, ISNULL(O.Width2, 0) AS Width2,
	 O.LastSchool, O.CareerGbn, O.AdoptGbn, O.SaleGbn, 
	 CONVERT(varchar(10), O.SrvStDay, 120) AS SrvStDay, CONVERT(varchar(10), O.SrvEnDay, 120) AS SrvEnDay, C.ListNo, 'N' AS IsSend
   FROM FINDDB2.PaperCommon.dbo.OrderMail O, FINDDB1.PaperCat.dbo.CatCode C, FINDDB2.Common.dbo.UserCommon U
 WHERE C.Code4 = O.Code4 
	AND (ISNULL(O.Email,'') <> '' 
     	AND PATINDEX('%@%', O.Email) <> 0
     	AND PATINDEX('%.%', O.Email) <> 0 
     	AND NOT (O.Email >= 'ㄱ' AND O.Email <= 'ㅎ'))
     	AND O.MailFlag = 1 
     	AND CONVERT(varchar(10),O.SrvStDay,120) <= CONVERT(varchar(10),GetDate() ,120)
     	AND CONVERT(varchar(10),O.SrvEnDay,120) >= CONVERT(varchar(10),GetDate() ,120)
	AND O.UserId = U.UserId AND U.AllDelFlag = 0 
ORDER BY O.Serial, O.Email, O.Code4


/*************************************************************************************
 2차 Temp Table 만듬 (조건 하나당 매물정보 최대 5건까지)
*************************************************************************************/

TRUNCATE TABLE Temp_OrderMail_Result


DECLARE @Serial		varchar(10)
DECLARE @UserID		varchar(30)
DECLARE @Email 		varchar(50)
DECLARE @SearchBranch 	varchar(200)
DECLARE @Code1		int
DECLARE @Code3		int
DECLARE @Code4		int
DECLARE @Year1		int
DECLARE @Year2		int
DECLARE @Traveling1		int
DECLARE @Traveling2		int
DECLARE @SelCost1		int
DECLARE @SelCost2		int
DECLARE @Metro		varchar(30)
DECLARE @City			varchar(30)
DECLARE @Dong		varchar(30)
DECLARE @WishAmt1		float
DECLARE @WishAmt2		float
DECLARE @Width1		int
DECLARE @Width2		int
DECLARE @LastSchool		varchar(30)
DECLARE @CareerGbn		varchar(30)
DECLARE @AdoptGbn		varchar(30)
DECLARE @SaleGbn		int
DECLARE @SrvStDay		varchar(20)
DECLARE @SrvEnDay		varchar(20)
DECLARE @ListNo		int
DECLARE @IsSend		varchar(20)

DECLARE Cur_Temp SCROLL CURSOR
FOR
	SELECT Serial, UserID, Email, SearchBranch, Code1, Code3, Code4, 
		 Year1,  Year2, Traveling1, Traveling2,
	 	 SelCost1, SelCost2, Metro, City, Dong, 
		 WishAmt1, WishAmt2, Width1, Width2,
		 LastSchool, CareerGbn, AdoptGbn, SaleGbn, 
		 SrvStDay, SrvEnDay, ListNo, IsSend
	FROM Temp_OrderMail ORDER BY Serial, Email, Code4

FOR READ ONLY

OPEN Cur_Temp
FETCH FROM Cur_Temp
	INTO @Serial,		@UserID,	@Email,		@SearchBranch, 	@Code1, 	@Code3, 	@Code4, 
	        @Year1,  	 	@Year2,   	@Traveling1,      	@Traveling2,
	        @SelCost1,	@SelCost2, 	@Metro, 	 	@City, 	        	@Dong, 
	        @WishAmt1, 	@WishAmt2, 	@Width1,   		@Width2,
	        @LastSchool, 	@CareerGbn, 	@AdoptGbn, 		@SaleGbn, 
	        @SrvStDay,     	@SrvEnDay, 	@ListNo, 		@IsSend

WHILE(@@Fetch_Status = 0)
BEGIN
	/*************************************************************************************
	분류에 따른 검색조건 Text 만들기
	*************************************************************************************/
	-- 부동산 관련 가격 검색조건
	DECLARE @SaleGbnText	varchar(100)
	SET @SaleGbnText =
	CASE
		WHEN @SaleGbn = 1 THEN '매매가:'+ CONVERT(varchar(20), @WishAmt1) + '만원~' + CONVERT(varchar(20), @WishAmt2) + '만원<br>'
		WHEN @SaleGbn = 2 THEN '전세/임대료:' + CONVERT(varchar(20), @WishAmt1) + '만원~' + CONVERT(varchar(20), @WishAmt2) + '만원<br>'
		WHEN @SaleGbn = 3 THEN '월세가:' + CONVERT(varchar(20), @WishAmt1) + '만원~' + CONVERT(varchar(20), @WishAmt2) + '만원<br>'
		ELSE ''
	END

	-- 부동산 Metro등 검색조건이 없을 경우의 예외처리
	DECLARE @MetroText		varchar(100)
	SET @MetroText =
	CASE
		WHEN ISNULL(@Metro, '') = '' AND ISNULL(@City, '') = '' AND ISNULL(@Dong, '') = '' THEN ''
		ELSE @Metro + ' ' + @City + ' ' + @Dong + '<br>'
	END

	-- 분류별 검색조건
	DECLARE @SearchTerm		varchar(200)
	SET @SearchTerm =
	CASE
		WHEN @Code1 = 1 THEN ''
		WHEN @Code1 = 2 THEN '연식:' + CONVERT(varchar(10), @Year1) + '~' + CONVERT(varchar(10), @Year2) + '<br>' +
					'주행거리:' + CONVERT(varchar(10), @Traveling1) + 'Km~' + CONVERT(varchar(10), @Traveling2) + 'Km<br>' +
					'가격대:' + CONVERT(varchar(10), @SelCost1) + '만원~' + CONVERT(varchar(10), @SelCost2) + '만원'
		WHEN @Code1 = 3 THEN @MetroText + @SaleGbnText +
					'평수:' + CONVERT(varchar(10), @Width1) + '평~' + CONVERT(varchar(10), @Width2) + '평'
		WHEN @Code1 = 4 THEN '학력구분:' + @LastSchool + '<br>' +
					'경력구분:' + @CareerGbn + '<br>' +
					'채용구분:' + @AdoptGbn
	END

	/*************************************************************************************
	 분류에 따라 참조할 테이블명
	*************************************************************************************/
	DECLARE	@strTableNm	varchar(50)

	SET @strTableNm = CASE WHEN @Code1 = 1 then 'FINDDB1.PaperCat.dbo.CatGoods '
			               WHEN @Code1 = 2 then 'FINDDB1.PaperCat.dbo.CatCar '
			               WHEN @Code1 = 3 then 'FINDDB1.PaperCat.dbo.CatHouse '
			               WHEN @Code1 = 4 then 'FINDDB1.PaperCat.dbo.CatJob '
			      END
	/*************************************************************************************
	 intListNo에 따라 가져올 필드명
	*************************************************************************************/
	DECLARE	@clsField	varchar(2000)
	SET @clsField = 
		CASE WHEN @ListNo = 11 THEN
			' (G.BrandNm + G.InfoText + (CONVERT(varchar(10),G.WishAmt) + ''만원'')) AS SearchResult '
		WHEN @ListNo = 12 THEN
			' (G.BrandNm + G.InfoText) AS SearchResult '
		WHEN @ListNo = 13 THEN
			' (G.BrandNm + G.InfoText) AS SearchResult '
		WHEN @ListNo = 21 THEN
			' (G.CarKind + G.CarKind2 + (CONVERT(varchar(10),G.BuyYY) + ''년도구입 '') + (CONVERT(varchar(10),G.Traveling) + ''Km주행 '') + G.Color + G.InfoText + (CONVERT(varchar(10),G.WishAmt) + ''만원'')) AS SearchResult '
		WHEN @ListNo = 22 THEN
			' (G.BrandNm + G.InfoText + (CONVERT(varchar(10),G.WishAmt) + ''만원''))) AS SearchResult '
		WHEN @ListNo = 23 THEN
			' (G.BizNm + G.InfoText + (CONVERT(varchar(10),G.BuyAmt) + ''만원'')) AS SearchResult '
		WHEN @ListNo = 24 THEN
			' (G.BizNm + G.InfoText + (CONVERT(varchar(10),G.BuyAmt) + ''만원'')) AS SearchResult '
		WHEN @ListNo = 31 THEN
			' (G.Address + (CONVERT(varchar(10),G.Width) + ''평 '') + (G.Direction + ''향 '') + (''방'' + CONVERT(varchar(10),G.RoomCnt) + ''개 '') + (CONVERT(varchar(10),G.Floor) + ''층 '') + G.InfoText + (CONVERT(varchar(10),G.WishAmt) + ''만원'')) AS SearchResult '
		WHEN @ListNo = 32 THEN
			' (G.IndusNm + G.Address + CONVERT(varchar(10),G.Width) + G.InfoText + (CONVERT(varchar(10),G.WishAmt) + ''만원'')) AS SearchResult '
		WHEN @ListNo = 33 THEN
			' (G.Address + G.InfoText + (CONVERT(varchar(10),G.WishAmt) + ''만원'')) AS SearchResult '
		WHEN @ListNo = 34 THEN
			' (G.AptNm + G.InfoText) AS SearchResult '
		WHEN @ListNo = 35 THEN
			' (G.BizNm + G.InfoText + G.ShopNm) AS SearchResult '
		WHEN @ListNo = 41 THEN
			' (G.RecPart + G.InfoText + G.ShopNm) AS SearchResult '
		WHEN @ListNo = 42 THEN
			' (G.RecNm + G.InfoText + G.ShopNm) AS SearchResult '
		WHEN @ListNo = 43 THEN
			' (G.RecNm + G.InfoText + G.ShopNm) AS SearchResult '
		WHEN @ListNo = 44 THEN
			' (G.RecNm + G.InfoText + G.ShopNm) AS SearchResult '
		END

	/*************************************************************************************
	 분류에 따른 검색조건
	*************************************************************************************/
	-- 검색조건(상품&서비스)
	DECLARE	@TermGoods	varchar(1000)
	SET @TermGoods = 
			' WHERE C.LineAdId = G.LineAdId AND C.LayoutBranch = G.LayoutBranch AND C.Code = ' + CONVERT(varchar(10), @Code4) + ' ' +
			' AND CONVERT(varchar(10), C.LayoutBranch) IN (' + @SearchBranch + ')'

	-- 검색조건(자동차)
	DECLARE	@TermCar	varchar(1000)
	SET @TermCar = 
			' WHERE C.LineAdId = G.LineAdId AND C.LayoutBranch = G.LayoutBranch AND C.Code = ' + CONVERT(varchar(10), @Code4) + ' ' +
			' AND CONVERT(varchar(10), C.LayoutBranch) IN (' + @SearchBranch + ')'
	-- 연식
	IF @Year1 <> 0
	BEGIN
		SET @TermCar = @TermCar + ' AND G.BuyYY >= ' + CONVERT(varchar(10),  @Year1)
	END
	IF @Year2 <> 0
	BEGIN
		SET @TermCar = @TermCar + ' AND G.BuyYY <= ' + CONVERT(varchar(10), @Year2)
	END
	-- 주행거리
	IF @Traveling1 <> 0
	BEGIN
		SET @TermCar = @TermCar + ' AND G.Traveling >= ' + CONVERT(varchar(10),  @Traveling1)
	END
	IF @Traveling2 <> 0
	BEGIN
		SET @TermCar = @TermCar + ' AND G.Traveling <= ' + CONVERT(varchar(10), @Traveling2)
	END
	-- 가격대
	IF @SelCost1 <> 0
	BEGIN
		SET @TermCar = @TermCar + ' AND G.WishAmt >= ' + CONVERT(varchar(10),  @SelCost1)
	END
	IF @SelCost2 <> 0
	BEGIN
		SET @TermCar = @TermCar + ' AND G.WishAmt <= ' + CONVERT(varchar(10), @SelCost2)
	END

	-- 검색조건(부동산)
	DECLARE	@TermHouse		varchar(1000),
			@SubTermHouse	varchar(100)
	SET @TermHouse = 
		' WHERE C.LineAdId = G.LineAdId AND C.LayoutBranch = G.LayoutBranch AND C.Code = ' + CONVERT(varchar(10), @Code4)
	-- 광역시/도
	IF @Metro <> ''
	BEGIN
		SET @TermHouse = @TermHouse + ' AND C.Metro = ' + '''' + @Metro + ''''
	END
	-- 시/군/구
	IF @City <> ''
	BEGIN
		SET @TermHouse = @TermHouse + ' AND C.City = ' + '''' + @City + ''''
	END
	-- 동/리
	IF @Dong <> ''
	BEGIN
		SET @TermHouse = @TermHouse + ' AND C.Dong = ' + '''' + @Dong + ''''
	END
	-- 가격대
	IF @WishAmt1 <> 0
	BEGIN
		SET @SubTermHouse =
		-- 매매
		CASE WHEN @SaleGbn = 1 THEN
			' AND G.WishAmt >= ' + CONVERT(varchar(10),  @WishAmt1)
		-- 전세
		WHEN @SaleGbn = 2 THEN
			' AND G.RentAmt >= ' + CONVERT(varchar(10),  @WishAmt1)
		-- 월세
		WHEN @SaleGbn = 3 THEN
			' AND G.MmAmt >= ' + CONVERT(varchar(10),  @WishAmt1)
		ELSE
			''
		END
	SET @TermHouse = @TermHouse + @SubTermHouse
	END
	IF @WishAmt2 <> 0
	BEGIN
		SET @SubTermHouse =
		-- 매매
		CASE WHEN @SaleGbn = 1 THEN
			' AND G.WishAmt <= ' + CONVERT(varchar(10),  @WishAmt1)
		-- 전세
		WHEN @SaleGbn = 2 THEN
			' AND G.RentAmt <= ' + CONVERT(varchar(10),  @WishAmt1)
		-- 월세
		WHEN @SaleGbn = 3 THEN
			' AND G.MmAmt <= ' + CONVERT(varchar(10),  @WishAmt1)
		ELSE
			''
		END
	SET @TermHouse = @TermHouse + @SubTermHouse
	END
	-- 평형
	IF @Width1 <> 0
	BEGIN
		SET @TermHouse = @TermHouse + ' AND G.Width >= ' + CONVERT(varchar(10),  @Width1)
	END
	IF @Width2 <> 0
	BEGIN
		SET @TermHouse = @TermHouse + ' AND G.Width <= ' + CONVERT(varchar(10), @Width2)
	END

	-- 검색조건(구인/구직)
	DECLARE	@TermJob	varchar(1000)
	SET @TermJob = 
			' WHERE C.LineAdId = G.LineAdId AND C.LayoutBranch = G.LayoutBranch AND C.Code = ' + CONVERT(varchar(10), @Code4) + ' ' +
			' AND CONVERT(varchar(10), C.LayoutBranch) IN (' + @SearchBranch + ')'
	-- 학력구분
	IF @LastSchool <> ''
	BEGIN
		SET @TermJob = @TermJob + ' AND G.LastSchool = ' + '''' + @LastSchool + ''''
	END
	-- 경력구분
	IF @CareerGbn <> ''
	BEGIN
		SET @TermJob = @TermJob + ' AND G.CareerGbn = ' + '''' + @CareerGbn + ''''
	END
	-- 채용구분
	IF @AdoptGbn <> ''
	BEGIN
		SET @TermJob = @TermJob + ' AND G.AdoptGbn = ' + '''' + @AdoptGbn + ''''
	END
		
	DECLARE @strQuery varchar(8000)
	SET @strQuery = 

	CASE WHEN @Code1 = 1 THEN
		'INSERT INTO Temp_OrderMail_Result ' + 
		'SELECT TOP 5 ' + @Serial + ', ' + '''' + @Email + '''' +',' + '''' + @UserId + '''' + ', ' +CONVERT(varchar(10), @Code1) + ',' + CONVERT(varchar(10),@Code4 ) + ', ' + '''' + @SearchBranch + '''' + ', ' + '''' + @SearchTerm + '''' + ', ' + @clsField + ', ' + '''' + @SrvStDay + '''' + ', ' + '''' + @SrvEnDay + '''' + ', ' +
		'(SELECT TOP 1 COUNT(C.LineAdId) FROM FINDDB1.PaperCat.dbo.CatCommon C, ' + @strTableNm + ' G ' + @TermGoods + ') AS DataCnt , Convert(varchar(50),C.Phone), C.LayoutBranch ' +
		'FROM FINDDB1.PaperCat.dbo.CatCommon C, ' + @strTableNm + ' G ' + @TermGoods + ' ' +
		'ORDER BY C.LineAdId DESC '
	WHEN @Code1 = 2 THEN
		'INSERT INTO Temp_OrderMail_Result ' + 
		'SELECT TOP 5 ' + @Serial + ', ' + '''' + @Email + '''' +',' + '''' + @UserId + '''' + ', ' +CONVERT(varchar(10), @Code1) + ',' + CONVERT(varchar(10),@Code4 ) + ', ' + '''' + @SearchBranch + '''' + ', ' + '''' + @SearchTerm + '''' + ', ' + @clsField + ', ' + '''' + @SrvStDay + '''' + ', ' + '''' + @SrvEnDay + '''' + ', ' +
		'(SELECT TOP 1 COUNT(C.LineAdId) FROM FINDDB1.PaperCat.dbo.CatCommon C, ' + @strTableNm + ' G ' + @TermCar + ') AS DataCnt , Convert(varchar(50),C.Phone), C.LayoutBranch ' +
		'FROM FINDDB1.PaperCat.dbo.CatCommon C, ' + @strTableNm + ' G ' + @TermCar + ' ' +
		'ORDER BY C.LineAdId DESC '
	WHEN @Code1 = 3 THEN
		'INSERT INTO Temp_OrderMail_Result ' + 
		'SELECT TOP 5 ' + @Serial + ', ' + '''' + @Email + '''' +',' + '''' + @UserId + '''' + ', ' +CONVERT(varchar(10), @Code1) + ',' + CONVERT(varchar(10),@Code4 ) + ', ' + '''' + @SearchBranch + '''' + ', ' + '''' + @SearchTerm + '''' + ', ' + @clsField + ', ' + '''' + @SrvStDay + '''' + ', ' + '''' + @SrvEnDay + '''' + ', ' +
		'(SELECT TOP 1 COUNT(C.LineAdId) FROM FINDDB1.PaperCat.dbo.CatCommon C, ' + @strTableNm + ' G ' + @TermHouse + ') AS DataCnt , Convert(varchar(50),C.Phone), C.LayoutBranch ' +
		'FROM FINDDB1.PaperCat.dbo.CatCommon C, ' + @strTableNm + ' G ' + @TermHouse + ' ' +
		'ORDER BY C.LineAdId DESC '
	WHEN @Code1 = 4 THEN
		'INSERT INTO Temp_OrderMail_Result ' + 
		'SELECT TOP 5 ' + @Serial + ', ' + '''' + @Email + '''' +',' + '''' + @UserId + '''' + ', ' +CONVERT(varchar(10), @Code1) + ',' + CONVERT(varchar(10),@Code4 ) + ', ' + '''' + @SearchBranch + '''' + ', ' + '''' + @SearchTerm + '''' + ', ' + @clsField + ', ' + '''' + @SrvStDay + '''' + ', ' + '''' + @SrvEnDay + '''' + ', ' +
		'(SELECT TOP 1 COUNT(C.LineAdId) FROM FINDDB1.PaperCat.dbo.CatCommon C, ' + @strTableNm + ' G ' + @TermJob + ') AS DataCnt , Convert(varchar(50),C.Phone), C.LayoutBranch ' +
		'FROM FINDDB1.PaperCat.dbo.CatCommon C, ' + @strTableNm + ' G ' + @TermJob + ' ' +
		'ORDER BY C.LineAdId DESC '
	END
				
--	PRINT('[' + @Serial + ']' + '[' + @UserID + ']')
--	PRINT(@strQuery)
	EXEC(@strQuery)

	
	FETCH FROM Cur_Temp
	INTO @Serial,		@UserID,	@Email,		@SearchBranch, 	@Code1, 	@Code3, 	@Code4, 
	        @Year1,  	 	@Year2,   	@Traveling1,      	@Traveling2,
	        @SelCost1,	@SelCost2, 	@Metro, 	 	@City, 	        	@Dong, 
	        @WishAmt1, 	@WishAmt2, 	@Width1,   		@Width2,
	        @LastSchool, 	@CareerGbn, 	@AdoptGbn, 		@SaleGbn, 
	        @SrvStDay,     	@SrvEnDay, 	@ListNo, 		@IsSend
	END

	CLOSE Cur_Temp
	DEALLOCATE Cur_Temp
GO
/****** Object:  StoredProcedure [dbo].[OrderMail_TodayFreePaper]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[OrderMail_TodayFreePaper]
AS

DECLARE @EBookCnt int

SELECT @EBookCnt = COUNT(*) FROM Ebook.Ebook2005.dbo.Premium WHERE IssueDate = CONVERT(varchar(8),getdate(),112)

-----------------------------
TRUNCATE TABLE TodayFreePaper
-----------------------------

IF @EBookCnt > 0

  BEGIN

	INSERT INTO TodayFreePaper (
		 UserEmail
		,UserID
		,UserName
		,SendYear
		,SendMonth
		,SendDay
		,IssueDate
		,Branch10
		,Branch11
		,Branch12
		,Branch13
		,Branch14
		,Branch15
		,Branch16
		,Branch17
		,Branch18
		,Branch19
		,Branch20
		,Branch21
		,Branch22
		,Branch23
		,Branch24
		,Branch25
		,Branch26
		,Branch27
		,Branch28
		,Branch29
		,Branch30
		,Branch31
		,Branch32
		,Branch33
		,Branch34
		,Branch35
		,Branch36
		,Branch39
		,Branch40
		,Branch41
		,Branch42
		,Branch43
		,Branch46
		,Branch48
		,Branch49
		,Branch53
		,Branch54
		,Branch55
		,Branch57
		,Branch60
		,Branch110
		)
	SELECT
		 Replace(A.UserEmail,' ', '') As UserEmail
		,Replace(A.UserID,' ', '') As UserID
		,Replace(B.UserName,' ', '') As UserName
		,Year(getdate()) As SendYear
		,Month(getdate()) As SendMonth
		,Day(getdate()) As SendDay
		,CONVERT(varchar(8), getdate(), 112) As IssueDate
		,Branch10 = (CASE WHEN A.FreeLocal2 LIKE '%10%' THEN 'display:' ELSE 'display:none' END)
		,Branch11 = (CASE WHEN A.FreeLocal3 LIKE '%11%' THEN 'display:' ELSE 'display:none' END)
		,Branch12 = (CASE WHEN A.FreeLocal5 LIKE '%12%' THEN 'display:' ELSE 'display:none' END)
		,Branch13 = (CASE WHEN A.FreeLocal4 LIKE '%13%' THEN 'display:' ELSE 'display:none' END)
		,Branch14 = (CASE WHEN A.FreeLocal2 LIKE '%14%' THEN 'display:' ELSE 'display:none' END)
		,Branch15 = (CASE WHEN A.FreeLocal4 LIKE '%15%' THEN 'display:' ELSE 'display:none' END)
		,Branch16 = (CASE WHEN A.FreeLocal1 LIKE '%16%' THEN 'display:' ELSE 'display:none' END)
		,Branch17 = (CASE WHEN A.FreeLocal1 LIKE '%17%' THEN 'display:' ELSE 'display:none' END)
		,Branch18 = (CASE WHEN A.FreeLocal1 LIKE '%18%' THEN 'display:' ELSE 'display:none' END)
		,Branch19 = (CASE WHEN A.FreeLocal1 LIKE '%19%' THEN 'display:' ELSE 'display:none' END)
		,Branch20 = (CASE WHEN A.FreeLocal1 LIKE '%20%' THEN 'display:' ELSE 'display:none' END)
		,Branch21 = (CASE WHEN A.FreeLocal1 LIKE '%21%' THEN 'display:' ELSE 'display:none' END)
		,Branch22 = (CASE WHEN A.FreeLocal1 LIKE '%22%' THEN 'display:' ELSE 'display:none' END)
		,Branch23 = (CASE WHEN A.FreeLocal1 LIKE '%23%' THEN 'display:' ELSE 'display:none' END)
		,Branch24 = (CASE WHEN A.FreeLocal1 LIKE '%24%' THEN 'display:' ELSE 'display:none' END)
		,Branch25 = (CASE WHEN A.FreeLocal3 LIKE '%25%' THEN 'display:' ELSE 'display:none' END)
		,Branch26 = (CASE WHEN A.FreeLocal3 LIKE '%26%' THEN 'display:' ELSE 'display:none' END)
		,Branch27 = (CASE WHEN A.FreeLocal2 LIKE '%27%' THEN 'display:' ELSE 'display:none' END)
		,Branch28 = (CASE WHEN A.FreeLocal2 LIKE '%28%' THEN 'display:' ELSE 'display:none' END)
		,Branch29 = (CASE WHEN A.FreeLocal2 LIKE '%29%' THEN 'display:' ELSE 'display:none' END)
		,Branch30 = (CASE WHEN A.FreeLocal2 LIKE '%30%' THEN 'display:' ELSE 'display:none' END)
		,Branch31 = (CASE WHEN A.FreeLocal2 LIKE '%31%' THEN 'display:' ELSE 'display:none' END)
		,Branch32 = (CASE WHEN A.FreeLocal2 LIKE '%32%' THEN 'display:' ELSE 'display:none' END)
		,Branch33 = (CASE WHEN A.FreeLocal2 LIKE '%33%' THEN 'display:' ELSE 'display:none' END)
		,Branch34 = (CASE WHEN A.FreeLocal3 LIKE '%34%' THEN 'display:' ELSE 'display:none' END)
		,Branch35 = (CASE WHEN A.FreeLocal3 LIKE '%35%' THEN 'display:' ELSE 'display:none' END)
		,Branch36 = (CASE WHEN A.FreeLocal2 LIKE '%36%' THEN 'display:' ELSE 'display:none' END)
		,Branch39 = (CASE WHEN A.FreeLocal3 LIKE '%39%' THEN 'display:' ELSE 'display:none' END)
		,Branch40 = (CASE WHEN A.FreeLocal5 LIKE '%40%' THEN 'display:' ELSE 'display:none' END)
		,Branch41 = (CASE WHEN A.FreeLocal3 LIKE '%41%' THEN 'display:' ELSE 'display:none' END)
		,Branch42 = (CASE WHEN A.FreeLocal5 LIKE '%42%' THEN 'display:' ELSE 'display:none' END)
		,Branch43 = (CASE WHEN A.FreeLocal2 LIKE '%43%' THEN 'display:' ELSE 'display:none' END)
		,Branch46 = (CASE WHEN A.FreeLocal3 LIKE '%46%' THEN 'display:' ELSE 'display:none' END)
		,Branch48 = (CASE WHEN A.FreeLocal3 LIKE '%48%' THEN 'display:' ELSE 'display:none' END)
		,Branch49 = (CASE WHEN A.FreeLocal3 LIKE '%49%' THEN 'display:' ELSE 'display:none' END)
		,Branch53 = (CASE WHEN A.FreeLocal5 LIKE '%53%' THEN 'display:' ELSE 'display:none' END)
		,Branch54 = (CASE WHEN A.FreeLocal5 LIKE '%54%' THEN 'display:' ELSE 'display:none' END)
		,Branch55 = (CASE WHEN A.FreeLocal5 LIKE '%55%' THEN 'display:' ELSE 'display:none' END)
		,Branch57 = (CASE WHEN A.FreeLocal6 LIKE '%57%' THEN 'display:' ELSE 'display:none' END)
		,Branch60 = (CASE WHEN A.FreeLocal3 LIKE '%60%' THEN 'display:' ELSE 'display:none' END)
		,Branch110 = (CASE WHEN A.FreeLocal7 LIKE '%110%' THEN 'display:' ELSE 'display:none' END)
	--FROM FreePaper A, FINDDB2.MEMBER.dbo.UserCommon_VI B
  FROM FreePaper A, MEMBERDB.MWMEMBER.dbo.UserCommon_VI B
	WHERE A.UserId = B.UserId
		AND A.ReadingFlag = 1
		AND A.FreeLocal <> ''
		AND CONVERT(varchar(8), A.StDate, 112) <= CONVERT(varchar(8), getdate(), 112)
		AND CONVERT(varchar(8), A.EnDate, 112) >= CONVERT(varchar(8), getdate(), 112)
		AND B.Delflag <> 'Y'


	DELETE FROM TodayFreePaper
	WHERE  PATINDEX('%@%', UserEmail) =  0
		OR PATINDEX('%.%', UserEmail) =  0
		OR PATINDEX('%:%', UserEmail) <> 0
		OR PATINDEX('%;%', UserEmail) <> 0
		OR PATINDEX('%/%', UserEmail) <> 0
		OR PATINDEX('%~%', UserEmail) <> 0
		OR PATINDEX('%@',  UserEmail) <> 0
		OR PATINDEX('@%',  UserEmail) <> 0
		OR PATINDEX('%.',  UserEmail) <> 0
		OR PATINDEX('.%',  UserEmail) <> 0
		OR PATINDEX('%"%', UserEmail) <> 0
		OR PATINDEX('%#%', UserEmail) <> 0
		OR PATINDEX('%&%', UserEmail) <> 0
		OR PATINDEX('%*%', UserEmail) <> 0
		OR PATINDEX('%?%', UserEmail) <> 0
		OR PATINDEX('%>%', UserEmail) <> 0
		OR PATINDEX('%<%', UserEmail) <> 0
		OR PATINDEX('%(%', UserEmail) <> 0
		OR PATINDEX('%)%', UserEmail) <> 0
		OR PATINDEX('%^%', UserEmail) <> 0
		OR PATINDEX('%!%', UserEmail) <> 0
		OR PATINDEX('%,%', UserEmail) <> 0
		OR PATINDEX('%`%', UserEmail) <> 0
		OR PATINDEX('%\%', UserEmail) <> 0
		OR (UserEmail >= '가' AND UserEmail <= '히')
		OR (UserEmail LIKE '%www.%' )
  END
GO
/****** Object:  StoredProcedure [dbo].[PAPER_BOXEMAIL_SUBCRI_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[PAPER_BOXEMAIL_SUBCRI_PROC]

AS

SET NOCOUNT ON

SELECT
       USEREMAIL
     , USERNAME
     , SENDYEAR
     , SENDMONTH
     , SENDDAY
     , INPUTBRANCH
     , BRANCHNAME
     , BOXTEL
  FROM CM_TODAYEBOOK_LINEAD_TB WITH (NOLOCK)
--WHERE USERNAME IN ('최병찬','테스트')





GO
/****** Object:  StoredProcedure [dbo].[PAPER_EMAIL_SUBCRI_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PAPER_EMAIL_SUBCRI_PROC]

AS

SET NOCOUNT ON

SELECT
       USEREMAIL
     , USERNAME
     , SENDYEAR
     , SENDMONTH
     , SENDDAY
     , STDATE
     , ENDATE
     , CNT
     , BRANCH10_1, BRANCH10_2, BRANCH10_3, BRANCH10_4, BRANCH10_5, BRANCH10_6
     , BRANCH11_1, BRANCH11_2, BRANCH11_3, BRANCH11_4, BRANCH11_5, BRANCH11_6
     , BRANCH12_1, BRANCH12_2, BRANCH12_3, BRANCH12_4, BRANCH12_5, BRANCH12_6
     , BRANCH13_1, BRANCH13_2, BRANCH13_3, BRANCH13_4, BRANCH13_5, BRANCH13_6
     , BRANCH14_1, BRANCH14_2, BRANCH14_3, BRANCH14_4, BRANCH14_5, BRANCH14_6
     , BRANCH15_1, BRANCH15_2, BRANCH15_3, BRANCH15_4, BRANCH15_5, BRANCH15_6
     , BRANCH16_1, BRANCH16_2, BRANCH16_3, BRANCH16_4, BRANCH16_5, BRANCH16_6
     , BRANCH17_1, BRANCH17_2, BRANCH17_3, BRANCH17_4, BRANCH17_5, BRANCH17_6
     , BRANCH18_1, BRANCH18_2, BRANCH18_3, BRANCH18_4, BRANCH18_5, BRANCH18_6
     , BRANCH19_1, BRANCH19_2, BRANCH19_3, BRANCH19_4, BRANCH19_5, BRANCH19_6
     , BRANCH20_1, BRANCH20_2, BRANCH20_3, BRANCH20_4, BRANCH20_5, BRANCH20_6
     , BRANCH21_1, BRANCH21_2, BRANCH21_3, BRANCH21_4, BRANCH21_5, BRANCH21_6
     , BRANCH22_1, BRANCH22_2, BRANCH22_3, BRANCH22_4, BRANCH22_5, BRANCH22_6
     , BRANCH23_1, BRANCH23_2, BRANCH23_3, BRANCH23_4, BRANCH23_5, BRANCH23_6
     , BRANCH24_1, BRANCH24_2, BRANCH24_3, BRANCH24_4, BRANCH24_5, BRANCH24_6
     , BRANCH25_1, BRANCH25_2, BRANCH25_3, BRANCH25_4, BRANCH25_5, BRANCH25_6
     , BRANCH26_1, BRANCH26_2, BRANCH26_3, BRANCH26_4, BRANCH26_5, BRANCH26_6
     , BRANCH27_1, BRANCH27_2, BRANCH27_3, BRANCH27_4, BRANCH27_5, BRANCH27_6
     , BRANCH28_1, BRANCH28_2, BRANCH28_3, BRANCH28_4, BRANCH28_5, BRANCH28_6
     , BRANCH29_1, BRANCH29_2, BRANCH29_3, BRANCH29_4, BRANCH29_5, BRANCH29_6
     , BRANCH30_1, BRANCH30_2, BRANCH30_3, BRANCH30_4, BRANCH30_5, BRANCH30_6
     , BRANCH31_1, BRANCH31_2, BRANCH31_3, BRANCH31_4, BRANCH31_5, BRANCH31_6
     , BRANCH32_1, BRANCH32_2, BRANCH32_3, BRANCH32_4, BRANCH32_5, BRANCH32_6
     , BRANCH33_1, BRANCH33_2, BRANCH33_3, BRANCH33_4, BRANCH33_5, BRANCH33_6
     , BRANCH34_1, BRANCH34_2, BRANCH34_3, BRANCH34_4, BRANCH34_5, BRANCH34_6
     , BRANCH35_1, BRANCH35_2, BRANCH35_3, BRANCH35_4, BRANCH35_5, BRANCH35_6
     , BRANCH36_1, BRANCH36_2, BRANCH36_3, BRANCH36_4, BRANCH36_5, BRANCH36_6
     , BRANCH39_1, BRANCH39_2, BRANCH39_3, BRANCH39_4, BRANCH39_5, BRANCH39_6
     , BRANCH40_1, BRANCH40_2, BRANCH40_3, BRANCH40_4, BRANCH40_5, BRANCH40_6
     , BRANCH41_1, BRANCH41_2, BRANCH41_3, BRANCH41_4, BRANCH41_5, BRANCH41_6
     , BRANCH42_1, BRANCH42_2, BRANCH42_3, BRANCH42_4, BRANCH42_5, BRANCH42_6
     , BRANCH43_1, BRANCH43_2, BRANCH43_3, BRANCH43_4, BRANCH43_5, BRANCH43_6
     , BRANCH46_1, BRANCH46_2, BRANCH46_3, BRANCH46_4, BRANCH46_5, BRANCH46_6
     , BRANCH48_1, BRANCH48_2, BRANCH48_3, BRANCH48_4, BRANCH48_5, BRANCH48_6
     , BRANCH49_1, BRANCH49_2, BRANCH49_3, BRANCH49_4, BRANCH49_5, BRANCH49_6
     , BRANCH52_1, BRANCH52_2, BRANCH52_3, BRANCH52_4, BRANCH52_5, BRANCH52_6
     , BRANCH53_1, BRANCH53_2, BRANCH53_3, BRANCH53_4, BRANCH53_5, BRANCH53_6
     , BRANCH54_1, BRANCH54_2, BRANCH54_3, BRANCH54_4, BRANCH54_5, BRANCH54_6
     , BRANCH55_1, BRANCH55_2, BRANCH55_3, BRANCH55_4, BRANCH55_5, BRANCH55_6
     , BRANCH56_1, BRANCH56_2, BRANCH56_3, BRANCH56_4, BRANCH56_5, BRANCH56_6
     , BRANCH60_1, BRANCH60_2, BRANCH60_3, BRANCH60_4, BRANCH60_5, BRANCH60_6
     , BRANCH110_1, BRANCH110_2, BRANCH110_3, BRANCH110_4, BRANCH110_5, BRANCH110_6
     , BRANCH47_1, BRANCH47_2, BRANCH47_3, BRANCH47_4, BRANCH47_5, BRANCH47_6
     , BRANCH58_1, BRANCH58_2, BRANCH58_3, BRANCH58_4, BRANCH58_5, BRANCH58_6
     , BRANCH79_1, BRANCH79_2, BRANCH79_3, BRANCH79_4, BRANCH79_5, BRANCH79_6
  FROM CM_TODAYEBOOK_TB WITH (NOLOCK)
--WHERE USERNAME IN ('최병찬','테스트')



GO
/****** Object:  StoredProcedure [dbo].[proc_EbookTrans]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*************************************************************************************
	설명		: 전면PDF 입력 후 E-Book으로 인덱스(목차) 전달 작업
	수정자	: 김준범
	수정일	: 2005.07.12
*************************************************************************************/
CREATE PROC [dbo].[proc_EbookTrans]

	@PdfCode				int,					--PDF 목록 코드
	@BranchCode		int	      	      	--지점코드


AS

DECLARE @strMsg	varchar(500)
DECLARE @LCnt		int

BEGIN

--기존 인덱스 삭제

	DELETE FROM Ebook.ebook2005.dbo.FindAllTempIndex
	WHERE Hosu = @PdfCode AND BranchCode = @BranchCode


--인덱스 전달

	INSERT INTO Ebook.ebook2005.dbo.FindAllTempIndex (Page, Depth, Title, BranchCode, Hosu)
	SELECT Page, Depth, Title, BranchCode, Hosu FROM
	(
		Select Min(Serial) As Serial,Min(Page) As Page, 1 As Depth, Convert(varchar(255),CodeNm1) As Title,  BranchCode,PdfCode As Hosu
		From PdfContents with(Nolock) Where Pdfcode = @PdfCode AND BranchCode = @BranchCode
			Group By BranchCode,PdfCode,CodeNm1

		UNION ALL

		Select Serial,Page, 2 As Depth, Convert(varchar(255),Contents) As Title,  BranchCode,PdfCode As Hosu
		From PdfContents with(Nolock) Where Pdfcode = @PdfCode AND BranchCode = @BranchCode
	) A
	Order By Page, Serial, Depth


	--분류 건수
	SET @LCnt = @@ROWCOUNT


	SET @strMsg = '총 ' + Convert(varchar(10),@LCnt) +  ' 건의 인덱스가 전달 되었습니다.'

	SELECT @strMsg


END







GO
/****** Object:  StoredProcedure [dbo].[proc_EbookTrans_Old]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*************************************************************************************
	설명		: 전면PDF 입력 후 E-Book으로 인덱스(목차) 전달 작업
	수정자	: 김준범
	수정일	: 2005.07.12
*************************************************************************************/
CREATE PROC [dbo].[proc_EbookTrans_Old]

	@PdfCode				int,					--PDF 목록 코드
	@BranchCode		int	      	      	--지점코드


AS

DECLARE @strMsg	varchar(500)
DECLARE @LCnt		int
DECLARE @SCnt		int

BEGIN

--기존 인덱스 삭제

	DELETE FROM Ebook.ebook2005.dbo.FindAllTempIndex
	WHERE Hosu = @PdfCode AND BranchCode = @BranchCode


--인덱스 전달

	INSERT INTO Ebook.ebook2005.dbo.FindAllTempIndex (Page, Depth, Title, BranchCode, Hosu)
	Select Min(Page) As Page, 1 As Depth, CodeNm1 As Title,  BranchCode,PdfCode As Hosu
	From PdfContents with(Nolock) Where Pdfcode = @PdfCode AND BranchCode = @BranchCode
		Group By BranchCode,PdfCode,CodeNm1
		Order By BranchCode,Min(Page)

	--대분류 건수
	SET @LCnt = @@ROWCOUNT

	INSERT INTO Ebook.ebook2005.dbo.FindAllTempIndex (Page, Depth, Title, BranchCode, Hosu)
	Select Page, 2 As Depth, Convert(varchar(255),Contents) As Title,  BranchCode,PdfCode As Hosu
	From PdfContents with(Nolock) Where Pdfcode = @PdfCode AND BranchCode = @BranchCode
	Order By Page,Serial

	--수분류 건수
	SET @SCnt = @@ROWCOUNT


	SET @strMsg = '대분류 ' + Convert(varchar(10),@LCnt) + ' 건과 소분류 ' + Convert(varchar(10),@SCnt) + ' 건 총 ' + Convert(varchar(10),@LCnt + @SCnt) +  ' 건이 전달 되었습니다.'

	SELECT @strMsg


END







GO
/****** Object:  StoredProcedure [dbo].[PUT_M_BOXLINEAD_ASK_INSERT_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리단 - 광고게재신청관리 - 줄/박스광고 상담내역 입력,수정
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/02/17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :

 *************************************************************************************/

CREATE PROC [dbo].[PUT_M_BOXLINEAD_ASK_INSERT_PROC]

	@LINEADID				INT,

	@COUNSELGBN 		CHAR(1),
	@ADFLAG 				CHAR(1),

	@TXTSTARTDATE 	VARCHAR(10),
	@TXTENDDATE 		VARCHAR(10),

	@CONTENTS				TEXT,

	@IRESULT	INT = 0 OUTPUT
AS

BEGIN TRAN
	IF EXISTS(SELECT NULL FROM DBO.RECPAPER_COUNSEL(NOLOCK) WHERE LINEADID=@LINEADID)
		BEGIN

			-- 기존에 상담 내역이 있으면 업데이트
			UPDATE
				DBO.RECPAPER_COUNSEL
			SET
				COUNSELGBN 	= @COUNSELGBN,
				ADFLAG 			= @ADFLAG,
				PRNSTDATE 	= @TXTSTARTDATE,
				PRNENDATE 	= @TXTENDDATE,
				CONTENTS 		= @CONTENTS
			WHERE
				LINEADID = @LINEADID

		END
	ELSE
		BEGIN

			-- 기존에 상담 내역이 없으면 인서트
			INSERT INTO DBO.RECPAPER_COUNSEL(
					LINEADID,
					COUNSELGBN,
					ADFLAG,
					PRNSTDATE,
					PRNENDATE,
					CONTENTS,
					REGDATE
				) VALUES (
					@LINEADID,
					@COUNSELGBN,
					@ADFLAG,
					@TXTSTARTDATE,
					@TXTENDDATE,
					@CONTENTS,
					GETDATE()
				)
		END

	IF @@ERROR>0 OR @@ROWCOUNT>1
		BEGIN
			ROLLBACK
			SET @IRESULT = -1
		END
	ELSE
		BEGIN
			COMMIT TRAN
			SET @IRESULT = 1
		END






GO
/****** Object:  StoredProcedure [dbo].[SUBSCRIPTION_TODAYPAPER]    Script Date: 2021-11-04 오전 10:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--조회 쿼리



CREATE PROCEDURE [dbo].[SUBSCRIPTION_TODAYPAPER]
AS

DBCC TRACEON(-1, 7307)

--PP_USER_EPAPERMAIL_TB EMAIL 컬럼 회원정보로 업데이트
EXEC FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_EMAIL_UPD_PROC

-----------------------------
TRUNCATE TABLE CM_TODAYEBOOK_TB
-----------------------------

DECLARE @ENC_KEY    VARCHAR(30)
SET @ENC_KEY='mediawill20!^paper'

INSERT INTO CM_TODAYEBOOK_TB
 (
   USERID
 , USERNAME
 , USEREMAIL
 , SENDYEAR
 , SENDMONTH
 , SENDDAY
 , STDATE
 , ENDATE
 , CNT
 , BRANCH10_1
 , BRANCH10_2
 , BRANCH10_3
 , BRANCH10_4
 , BRANCH10_5
 , BRANCH10_6
 , BRANCH11_1
 , BRANCH11_2
 , BRANCH11_3
 , BRANCH11_4
 , BRANCH11_5
 , BRANCH11_6
 , BRANCH12_1
 , BRANCH12_2
 , BRANCH12_3
 , BRANCH12_4
 , BRANCH12_5
 , BRANCH12_6
 , BRANCH13_1
 , BRANCH13_2
 , BRANCH13_3
 , BRANCH13_4
 , BRANCH13_5
 , BRANCH13_6
 , BRANCH14_1
 , BRANCH14_2
 , BRANCH14_3
 , BRANCH14_4
 , BRANCH14_5
 , BRANCH14_6
 , BRANCH15_1
 , BRANCH15_2
 , BRANCH15_3
 , BRANCH15_4
 , BRANCH15_5
 , BRANCH15_6
 , BRANCH16_1
 , BRANCH16_2
 , BRANCH16_3
 , BRANCH16_4
 , BRANCH16_5
 , BRANCH16_6
 , BRANCH17_1
 , BRANCH17_2
 , BRANCH17_3
 , BRANCH17_4
 , BRANCH17_5
 , BRANCH17_6
 , BRANCH18_1
 , BRANCH18_2
 , BRANCH18_3
 , BRANCH18_4
 , BRANCH18_5
 , BRANCH18_6
 , BRANCH19_1
 , BRANCH19_2
 , BRANCH19_3
 , BRANCH19_4
 , BRANCH19_5
 , BRANCH19_6
 , BRANCH20_1
 , BRANCH20_2
 , BRANCH20_3
 , BRANCH20_4
 , BRANCH20_5
 , BRANCH20_6
 , BRANCH21_1
 , BRANCH21_2
 , BRANCH21_3
 , BRANCH21_4
 , BRANCH21_5
 , BRANCH21_6
 , BRANCH22_1
 , BRANCH22_2
 , BRANCH22_3
 , BRANCH22_4
 , BRANCH22_5
 , BRANCH22_6
 , BRANCH23_1
 , BRANCH23_2
 , BRANCH23_3
 , BRANCH23_4
 , BRANCH23_5
 , BRANCH23_6
 , BRANCH24_1
 , BRANCH24_2
 , BRANCH24_3
 , BRANCH24_4
 , BRANCH24_5
 , BRANCH24_6
 , BRANCH25_1
 , BRANCH25_2
 , BRANCH25_3
 , BRANCH25_4
 , BRANCH25_5
 , BRANCH25_6
 , BRANCH26_1
 , BRANCH26_2
 , BRANCH26_3
 , BRANCH26_4
 , BRANCH26_5
 , BRANCH26_6
 , BRANCH27_1
 , BRANCH27_2
 , BRANCH27_3
 , BRANCH27_4
 , BRANCH27_5
 , BRANCH27_6
 , BRANCH28_1
 , BRANCH28_2
 , BRANCH28_3
 , BRANCH28_4
 , BRANCH28_5
 , BRANCH28_6
 , BRANCH29_1
 , BRANCH29_2
 , BRANCH29_3
 , BRANCH29_4
 , BRANCH29_5
 , BRANCH29_6
 , BRANCH30_1
 , BRANCH30_2
 , BRANCH30_3
 , BRANCH30_4
 , BRANCH30_5
 , BRANCH30_6
 , BRANCH31_1
 , BRANCH31_2
 , BRANCH31_3
 , BRANCH31_4
 , BRANCH31_5
 , BRANCH31_6
 , BRANCH32_1
 , BRANCH32_2
 , BRANCH32_3
 , BRANCH32_4
 , BRANCH32_5
 , BRANCH32_6
 , BRANCH33_1
 , BRANCH33_2
 , BRANCH33_3
 , BRANCH33_4
 , BRANCH33_5
 , BRANCH33_6
 , BRANCH34_1
 , BRANCH34_2
 , BRANCH34_3
 , BRANCH34_4
 , BRANCH34_5
 , BRANCH34_6
 , BRANCH35_1
 , BRANCH35_2
 , BRANCH35_3
 , BRANCH35_4
 , BRANCH35_5
 , BRANCH35_6
 , BRANCH36_1
 , BRANCH36_2
 , BRANCH36_3
 , BRANCH36_4
 , BRANCH36_5
 , BRANCH36_6
 , BRANCH39_1
 , BRANCH39_2
 , BRANCH39_3
 , BRANCH39_4
 , BRANCH39_5
 , BRANCH39_6
 , BRANCH40_1
 , BRANCH40_2
 , BRANCH40_3
 , BRANCH40_4
 , BRANCH40_5
 , BRANCH40_6
 , BRANCH41_1
 , BRANCH41_2
 , BRANCH41_3
 , BRANCH41_4
 , BRANCH41_5
 , BRANCH41_6
 , BRANCH42_1
 , BRANCH42_2
 , BRANCH42_3
 , BRANCH42_4
 , BRANCH42_5
 , BRANCH42_6
 , BRANCH43_1
 , BRANCH43_2
 , BRANCH43_3
 , BRANCH43_4
 , BRANCH43_5
 , BRANCH43_6
 , BRANCH46_1
 , BRANCH46_2
 , BRANCH46_3
 , BRANCH46_4
 , BRANCH46_5
 , BRANCH46_6
 , BRANCH47_1
 , BRANCH47_2
 , BRANCH47_3
 , BRANCH47_4
 , BRANCH47_5
 , BRANCH47_6
 , BRANCH48_1
 , BRANCH48_2
 , BRANCH48_3
 , BRANCH48_4
 , BRANCH48_5
 , BRANCH48_6
 , BRANCH49_1
 , BRANCH49_2
 , BRANCH49_3
 , BRANCH49_4
 , BRANCH49_5
 , BRANCH49_6
 , BRANCH50_1
 , BRANCH50_2
 , BRANCH50_3
 , BRANCH50_4
 , BRANCH50_5
 , BRANCH50_6
 , BRANCH52_1
 , BRANCH52_2
 , BRANCH52_3
 , BRANCH52_4
 , BRANCH52_5
 , BRANCH52_6
 , BRANCH53_1
 , BRANCH53_2
 , BRANCH53_3
 , BRANCH53_4
 , BRANCH53_5
 , BRANCH53_6
 , BRANCH54_1
 , BRANCH54_2
 , BRANCH54_3
 , BRANCH54_4
 , BRANCH54_5
 , BRANCH54_6
 , BRANCH55_1
 , BRANCH55_2
 , BRANCH55_3
 , BRANCH55_4
 , BRANCH55_5
 , BRANCH55_6
 , BRANCH56_1
 , BRANCH56_2
 , BRANCH56_3
 , BRANCH56_4
 , BRANCH56_5
 , BRANCH56_6
 , BRANCH58_1
 , BRANCH58_2
 , BRANCH58_3
 , BRANCH58_4
 , BRANCH58_5
 , BRANCH58_6
 , BRANCH60_1
 , BRANCH60_2
 , BRANCH60_3
 , BRANCH60_4
 , BRANCH60_5
 , BRANCH60_6
 , BRANCH70_1
 , BRANCH70_2
 , BRANCH70_3
 , BRANCH70_4
 , BRANCH70_5
 , BRANCH70_6
 , BRANCH79_1
 , BRANCH79_2
 , BRANCH79_3
 , BRANCH79_4
 , BRANCH79_5
 , BRANCH79_6
 , BRANCH110_1
 , BRANCH110_2
 , BRANCH110_3
 , BRANCH110_4
 , BRANCH110_5
 , BRANCH110_6
 , ENC_USERID
	 )
SELECT
	 REPLACE(A.USERID,' ', '') AS USERID
	,REPLACE(A.USERNAME,' ', '') AS USERNAME
	,REPLACE(A.USEREMAIL,' ', '') AS USEREMAIL
	,YEAR(GETDATE()) AS SENDYEAR
	,MONTH(GETDATE()) AS SENDMONTH
	,DAY(GETDATE()) AS SENDDAY
	,REPLACE(CONVERT(VARCHAR(10), A.STDATE, 120),'-','.') AS STDATE
	,REPLACE(CONVERT(VARCHAR(10), A.ENDATE, 120),'-','.') AS ENDATE
	,A.DATACNT AS CNT
	,BRANCH10_1 = (CASE WHEN A.FREELOCAL2 LIKE '%10%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH10_2 = (CASE WHEN A.FREELOCAL2 LIKE '%10%' THEN '747474' ELSE '747474' END)
	,BRANCH10_3 = (CASE WHEN A.FREELOCAL2 LIKE '%10%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH10_4 = (CASE WHEN A.FREELOCAL2 LIKE '%10%' THEN '_on' ELSE '' END)
	,BRANCH10_5 = (CASE WHEN A.FREELOCAL2 LIKE '%10%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH10_6 = (CASE WHEN A.FREELOCAL2 LIKE '%10%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH11_1 = (CASE WHEN A.FREELOCAL3 LIKE '%11%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH11_2 = (CASE WHEN A.FREELOCAL3 LIKE '%11%' THEN '747474' ELSE '747474' END)
	,BRANCH11_3 = (CASE WHEN A.FREELOCAL3 LIKE '%11%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH11_4 = (CASE WHEN A.FREELOCAL3 LIKE '%11%' THEN '_on' ELSE '' END)
	,BRANCH11_5 = (CASE WHEN A.FREELOCAL3 LIKE '%11%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH11_6 = (CASE WHEN A.FREELOCAL3 LIKE '%11%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH12_1 = (CASE WHEN A.FREELOCAL5 LIKE '%12%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH12_2 = (CASE WHEN A.FREELOCAL5 LIKE '%12%' THEN '747474' ELSE '747474' END)
	,BRANCH12_3 = (CASE WHEN A.FREELOCAL5 LIKE '%12%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH12_4 = (CASE WHEN A.FREELOCAL5 LIKE '%12%' THEN '_on' ELSE '' END)
	,BRANCH12_5 = (CASE WHEN A.FREELOCAL5 LIKE '%12%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH12_6 = (CASE WHEN A.FREELOCAL5 LIKE '%12%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH13_1 = (CASE WHEN A.FREELOCAL4 LIKE '%13%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH13_2 = (CASE WHEN A.FREELOCAL4 LIKE '%13%' THEN '747474' ELSE '747474' END)
	,BRANCH13_3 = (CASE WHEN A.FREELOCAL4 LIKE '%13%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH13_4 = (CASE WHEN A.FREELOCAL4 LIKE '%13%' THEN '_on' ELSE '' END)
	,BRANCH13_5 = (CASE WHEN A.FREELOCAL4 LIKE '%13%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH13_6 = (CASE WHEN A.FREELOCAL4 LIKE '%13%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH14_1 = (CASE WHEN A.FREELOCAL2 LIKE '%14%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH14_2 = (CASE WHEN A.FREELOCAL2 LIKE '%14%' THEN '747474' ELSE '747474' END)
	,BRANCH14_3 = (CASE WHEN A.FREELOCAL2 LIKE '%14%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH14_4 = (CASE WHEN A.FREELOCAL2 LIKE '%14%' THEN '_on' ELSE '' END)
	,BRANCH14_5 = (CASE WHEN A.FREELOCAL2 LIKE '%14%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH14_6 = (CASE WHEN A.FREELOCAL2 LIKE '%14%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH15_1 = (CASE WHEN A.FREELOCAL4 LIKE '%15%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH15_2 = (CASE WHEN A.FREELOCAL4 LIKE '%15%' THEN '747474' ELSE '747474' END)
	,BRANCH15_3 = (CASE WHEN A.FREELOCAL4 LIKE '%15%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH15_4 = (CASE WHEN A.FREELOCAL4 LIKE '%15%' THEN '_on' ELSE '' END)
	,BRANCH15_5 = (CASE WHEN A.FREELOCAL4 LIKE '%15%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH15_6 = (CASE WHEN A.FREELOCAL4 LIKE '%15%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH16_1 = (CASE WHEN A.FREELOCAL1 LIKE '%16%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH16_2 = (CASE WHEN A.FREELOCAL1 LIKE '%16%' THEN '747474' ELSE '747474' END)
	,BRANCH16_3 = (CASE WHEN A.FREELOCAL1 LIKE '%16%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH16_4 = (CASE WHEN A.FREELOCAL1 LIKE '%16%' THEN '_on' ELSE '' END)
	,BRANCH16_5 = (CASE WHEN A.FREELOCAL1 LIKE '%16%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH16_6 = (CASE WHEN A.FREELOCAL1 LIKE '%16%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH17_1 = (CASE WHEN A.FREELOCAL1 LIKE '%17%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH17_2 = (CASE WHEN A.FREELOCAL1 LIKE '%17%' THEN '747474' ELSE '747474' END)
	,BRANCH17_3 = (CASE WHEN A.FREELOCAL1 LIKE '%17%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH17_4 = (CASE WHEN A.FREELOCAL1 LIKE '%17%' THEN '_on' ELSE '' END)
	,BRANCH17_5 = (CASE WHEN A.FREELOCAL1 LIKE '%17%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH17_6 = (CASE WHEN A.FREELOCAL1 LIKE '%17%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH18_1 = (CASE WHEN A.FREELOCAL1 LIKE '%18%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH18_2 = (CASE WHEN A.FREELOCAL1 LIKE '%18%' THEN '747474' ELSE '747474' END)
	,BRANCH18_3 = (CASE WHEN A.FREELOCAL1 LIKE '%18%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH18_4 = (CASE WHEN A.FREELOCAL1 LIKE '%18%' THEN '_on' ELSE '' END)
	,BRANCH18_5 = (CASE WHEN A.FREELOCAL1 LIKE '%18%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH18_6 = (CASE WHEN A.FREELOCAL1 LIKE '%18%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH19_1 = (CASE WHEN A.FREELOCAL1 LIKE '%19%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH19_2 = (CASE WHEN A.FREELOCAL1 LIKE '%19%' THEN '747474' ELSE '747474' END)
	,BRANCH19_3 = (CASE WHEN A.FREELOCAL1 LIKE '%19%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH19_4 = (CASE WHEN A.FREELOCAL1 LIKE '%19%' THEN '_on' ELSE '' END)
	,BRANCH19_5 = (CASE WHEN A.FREELOCAL1 LIKE '%19%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH19_6 = (CASE WHEN A.FREELOCAL1 LIKE '%19%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH20_1 = (CASE WHEN A.FREELOCAL1 LIKE '%20%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH20_2 = (CASE WHEN A.FREELOCAL1 LIKE '%20%' THEN '747474' ELSE '747474' END)
	,BRANCH20_3 = (CASE WHEN A.FREELOCAL1 LIKE '%20%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH20_4 = (CASE WHEN A.FREELOCAL1 LIKE '%20%' THEN '_on' ELSE '' END)
	,BRANCH20_5 = (CASE WHEN A.FREELOCAL1 LIKE '%20%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH20_6 = (CASE WHEN A.FREELOCAL1 LIKE '%20%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH21_1 = (CASE WHEN A.FREELOCAL1 LIKE '%21%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH21_2 = (CASE WHEN A.FREELOCAL1 LIKE '%21%' THEN '747474' ELSE '747474' END)
	,BRANCH21_3 = (CASE WHEN A.FREELOCAL1 LIKE '%21%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH21_4 = (CASE WHEN A.FREELOCAL1 LIKE '%21%' THEN '_on' ELSE '' END)
	,BRANCH21_5 = (CASE WHEN A.FREELOCAL1 LIKE '%21%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH21_6 = (CASE WHEN A.FREELOCAL1 LIKE '%21%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH22_1 = (CASE WHEN A.FREELOCAL1 LIKE '%22%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH22_2 = (CASE WHEN A.FREELOCAL1 LIKE '%22%' THEN '747474' ELSE '747474' END)
	,BRANCH22_3 = (CASE WHEN A.FREELOCAL1 LIKE '%22%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH22_4 = (CASE WHEN A.FREELOCAL1 LIKE '%22%' THEN '_on' ELSE '' END)
	,BRANCH22_5 = (CASE WHEN A.FREELOCAL1 LIKE '%22%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH22_6 = (CASE WHEN A.FREELOCAL1 LIKE '%22%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH23_1 = (CASE WHEN A.FREELOCAL1 LIKE '%23%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH23_2 = (CASE WHEN A.FREELOCAL1 LIKE '%23%' THEN '747474' ELSE '747474' END)
	,BRANCH23_3 = (CASE WHEN A.FREELOCAL1 LIKE '%23%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH23_4 = (CASE WHEN A.FREELOCAL1 LIKE '%23%' THEN '_on' ELSE '' END)
	,BRANCH23_5 = (CASE WHEN A.FREELOCAL1 LIKE '%23%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH23_6 = (CASE WHEN A.FREELOCAL1 LIKE '%23%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH24_1 = (CASE WHEN A.FREELOCAL1 LIKE '%24%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH24_2 = (CASE WHEN A.FREELOCAL1 LIKE '%24%' THEN '747474' ELSE '747474' END)
	,BRANCH24_3 = (CASE WHEN A.FREELOCAL1 LIKE '%24%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH24_4 = (CASE WHEN A.FREELOCAL1 LIKE '%24%' THEN '_on' ELSE '' END)
	,BRANCH24_5 = (CASE WHEN A.FREELOCAL1 LIKE '%24%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH24_6 = (CASE WHEN A.FREELOCAL1 LIKE '%24%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH25_1 = (CASE WHEN A.FREELOCAL3 LIKE '%25%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH25_2 = (CASE WHEN A.FREELOCAL3 LIKE '%25%' THEN '747474' ELSE '747474' END)
	,BRANCH25_3 = (CASE WHEN A.FREELOCAL3 LIKE '%25%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH25_4 = (CASE WHEN A.FREELOCAL3 LIKE '%25%' THEN '_on' ELSE '' END)
	,BRANCH25_5 = (CASE WHEN A.FREELOCAL3 LIKE '%25%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH25_6 = (CASE WHEN A.FREELOCAL3 LIKE '%25%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH26_1 = (CASE WHEN A.FREELOCAL3 LIKE '%26%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH26_2 = (CASE WHEN A.FREELOCAL3 LIKE '%26%' THEN '747474' ELSE '747474' END)
	,BRANCH26_3 = (CASE WHEN A.FREELOCAL3 LIKE '%26%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH26_4 = (CASE WHEN A.FREELOCAL3 LIKE '%26%' THEN '_on' ELSE '' END)
	,BRANCH26_5 = (CASE WHEN A.FREELOCAL3 LIKE '%26%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH26_6 = (CASE WHEN A.FREELOCAL3 LIKE '%26%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH27_1 = (CASE WHEN A.FREELOCAL2 LIKE '%27%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH27_2 = (CASE WHEN A.FREELOCAL2 LIKE '%27%' THEN '747474' ELSE '747474' END)
	,BRANCH27_3 = (CASE WHEN A.FREELOCAL2 LIKE '%27%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH27_4 = (CASE WHEN A.FREELOCAL2 LIKE '%27%' THEN '_on' ELSE '' END)
	,BRANCH27_5 = (CASE WHEN A.FREELOCAL2 LIKE '%27%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH27_6 = (CASE WHEN A.FREELOCAL2 LIKE '%27%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH28_1 = (CASE WHEN A.FREELOCAL2 LIKE '%28%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH28_2 = (CASE WHEN A.FREELOCAL2 LIKE '%28%' THEN '747474' ELSE '747474' END)
	,BRANCH28_3 = (CASE WHEN A.FREELOCAL2 LIKE '%28%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH28_4 = (CASE WHEN A.FREELOCAL2 LIKE '%28%' THEN '_on' ELSE '' END)
	,BRANCH28_5 = (CASE WHEN A.FREELOCAL2 LIKE '%28%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH28_6 = (CASE WHEN A.FREELOCAL2 LIKE '%28%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH29_1 = (CASE WHEN A.FREELOCAL2 LIKE '%29%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH29_2 = (CASE WHEN A.FREELOCAL2 LIKE '%29%' THEN '747474' ELSE '747474' END)
	,BRANCH29_3 = (CASE WHEN A.FREELOCAL2 LIKE '%29%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH29_4 = (CASE WHEN A.FREELOCAL2 LIKE '%29%' THEN '_on' ELSE '' END)
	,BRANCH29_5 = (CASE WHEN A.FREELOCAL2 LIKE '%29%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH29_6 = (CASE WHEN A.FREELOCAL2 LIKE '%29%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH30_1 = (CASE WHEN A.FREELOCAL2 LIKE '%30%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH30_2 = (CASE WHEN A.FREELOCAL2 LIKE '%30%' THEN '747474' ELSE '747474' END)
	,BRANCH30_3 = (CASE WHEN A.FREELOCAL2 LIKE '%30%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH30_4 = (CASE WHEN A.FREELOCAL2 LIKE '%30%' THEN '_on' ELSE '' END)
	,BRANCH30_5 = (CASE WHEN A.FREELOCAL2 LIKE '%30%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH30_6 = (CASE WHEN A.FREELOCAL2 LIKE '%30%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH31_1 = (CASE WHEN A.FREELOCAL2 LIKE '%31%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH31_2 = (CASE WHEN A.FREELOCAL2 LIKE '%31%' THEN '747474' ELSE '747474' END)
	,BRANCH31_3 = (CASE WHEN A.FREELOCAL2 LIKE '%31%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH31_4 = (CASE WHEN A.FREELOCAL2 LIKE '%31%' THEN '_on' ELSE '' END)
	,BRANCH31_5 = (CASE WHEN A.FREELOCAL2 LIKE '%31%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH31_6 = (CASE WHEN A.FREELOCAL2 LIKE '%31%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH32_1 = (CASE WHEN A.FREELOCAL2 LIKE '%32%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH32_2 = (CASE WHEN A.FREELOCAL2 LIKE '%32%' THEN '747474' ELSE '747474' END)
	,BRANCH32_3 = (CASE WHEN A.FREELOCAL2 LIKE '%32%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH32_4 = (CASE WHEN A.FREELOCAL2 LIKE '%32%' THEN '_on' ELSE '' END)
	,BRANCH32_5 = (CASE WHEN A.FREELOCAL2 LIKE '%32%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH32_6 = (CASE WHEN A.FREELOCAL2 LIKE '%32%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH33_1 = (CASE WHEN A.FREELOCAL2 LIKE '%33%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH33_2 = (CASE WHEN A.FREELOCAL2 LIKE '%33%' THEN '747474' ELSE '747474' END)
	,BRANCH33_3 = (CASE WHEN A.FREELOCAL2 LIKE '%33%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH33_4 = (CASE WHEN A.FREELOCAL2 LIKE '%33%' THEN '_on' ELSE '' END)
	,BRANCH33_5 = (CASE WHEN A.FREELOCAL2 LIKE '%33%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH33_6 = (CASE WHEN A.FREELOCAL2 LIKE '%33%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH34_1 = (CASE WHEN A.FREELOCAL3 LIKE '%34%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH34_2 = (CASE WHEN A.FREELOCAL3 LIKE '%34%' THEN '747474' ELSE '747474' END)
	,BRANCH34_3 = (CASE WHEN A.FREELOCAL3 LIKE '%34%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH34_4 = (CASE WHEN A.FREELOCAL3 LIKE '%34%' THEN '_on' ELSE '' END)
	,BRANCH34_5 = (CASE WHEN A.FREELOCAL3 LIKE '%34%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH34_6 = (CASE WHEN A.FREELOCAL3 LIKE '%34%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH35_1 = (CASE WHEN A.FREELOCAL3 LIKE '%35%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH35_2 = (CASE WHEN A.FREELOCAL3 LIKE '%35%' THEN '747474' ELSE '747474' END)
	,BRANCH35_3 = (CASE WHEN A.FREELOCAL3 LIKE '%35%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH35_4 = (CASE WHEN A.FREELOCAL3 LIKE '%35%' THEN '_on' ELSE '' END)
	,BRANCH35_5 = (CASE WHEN A.FREELOCAL3 LIKE '%35%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH35_6 = (CASE WHEN A.FREELOCAL3 LIKE '%35%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH36_1 = (CASE WHEN A.FREELOCAL2 LIKE '%36%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH36_2 = (CASE WHEN A.FREELOCAL2 LIKE '%36%' THEN '747474' ELSE '747474' END)
	,BRANCH36_3 = (CASE WHEN A.FREELOCAL2 LIKE '%36%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH36_4 = (CASE WHEN A.FREELOCAL2 LIKE '%36%' THEN '_on' ELSE '' END)
	,BRANCH36_5 = (CASE WHEN A.FREELOCAL2 LIKE '%36%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH36_6 = (CASE WHEN A.FREELOCAL2 LIKE '%36%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH39_1 = (CASE WHEN A.FREELOCAL3 LIKE '%39%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH39_2 = (CASE WHEN A.FREELOCAL3 LIKE '%39%' THEN '747474' ELSE '747474' END)
	,BRANCH39_3 = (CASE WHEN A.FREELOCAL3 LIKE '%39%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH39_4 = (CASE WHEN A.FREELOCAL3 LIKE '%39%' THEN '_on' ELSE '' END)
	,BRANCH39_5 = (CASE WHEN A.FREELOCAL3 LIKE '%39%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH39_6 = (CASE WHEN A.FREELOCAL3 LIKE '%39%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH40_1 = (CASE WHEN A.FREELOCAL5 LIKE '%40%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH40_2 = (CASE WHEN A.FREELOCAL5 LIKE '%40%' THEN '747474' ELSE '747474' END)
	,BRANCH40_3 = (CASE WHEN A.FREELOCAL5 LIKE '%40%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH40_4 = (CASE WHEN A.FREELOCAL5 LIKE '%40%' THEN '_on' ELSE '' END)
	,BRANCH40_5 = (CASE WHEN A.FREELOCAL5 LIKE '%40%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH40_6 = (CASE WHEN A.FREELOCAL5 LIKE '%40%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH41_1 = (CASE WHEN A.FREELOCAL3 LIKE '%41%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH41_2 = (CASE WHEN A.FREELOCAL3 LIKE '%41%' THEN '747474' ELSE '747474' END)
	,BRANCH41_3 = (CASE WHEN A.FREELOCAL3 LIKE '%41%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH41_4 = (CASE WHEN A.FREELOCAL3 LIKE '%41%' THEN '_on' ELSE '' END)
	,BRANCH41_5 = (CASE WHEN A.FREELOCAL3 LIKE '%41%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH41_6 = (CASE WHEN A.FREELOCAL3 LIKE '%41%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH42_1 = (CASE WHEN A.FREELOCAL5 LIKE '%42%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH42_2 = (CASE WHEN A.FREELOCAL5 LIKE '%42%' THEN '747474' ELSE '747474' END)
	,BRANCH42_3 = (CASE WHEN A.FREELOCAL5 LIKE '%42%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH42_4 = (CASE WHEN A.FREELOCAL5 LIKE '%42%' THEN '_on' ELSE '' END)
	,BRANCH42_5 = (CASE WHEN A.FREELOCAL5 LIKE '%42%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH42_6 = (CASE WHEN A.FREELOCAL5 LIKE '%42%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH43_1 = (CASE WHEN A.FREELOCAL2 LIKE '%43%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH43_2 = (CASE WHEN A.FREELOCAL2 LIKE '%43%' THEN '747474' ELSE '747474' END)
	,BRANCH43_3 = (CASE WHEN A.FREELOCAL2 LIKE '%43%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH43_4 = (CASE WHEN A.FREELOCAL2 LIKE '%43%' THEN '_on' ELSE '' END)
	,BRANCH43_5 = (CASE WHEN A.FREELOCAL2 LIKE '%43%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH43_6 = (CASE WHEN A.FREELOCAL2 LIKE '%43%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH46_1 = (CASE WHEN A.FREELOCAL3 LIKE '%46%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH46_2 = (CASE WHEN A.FREELOCAL3 LIKE '%46%' THEN '747474' ELSE '747474' END)
	,BRANCH46_3 = (CASE WHEN A.FREELOCAL3 LIKE '%46%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH46_4 = (CASE WHEN A.FREELOCAL3 LIKE '%46%' THEN '_on' ELSE '' END)
	,BRANCH46_5 = (CASE WHEN A.FREELOCAL3 LIKE '%46%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH46_6 = (CASE WHEN A.FREELOCAL3 LIKE '%46%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH47_1 = (CASE WHEN A.FREELOCAL3 LIKE '%47%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH47_2 = (CASE WHEN A.FREELOCAL3 LIKE '%47%' THEN '747474' ELSE '747474' END)
	,BRANCH47_3 = (CASE WHEN A.FREELOCAL3 LIKE '%47%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH47_4 = (CASE WHEN A.FREELOCAL3 LIKE '%47%' THEN '_on' ELSE '' END)
	,BRANCH47_5 = (CASE WHEN A.FREELOCAL3 LIKE '%47%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH47_6 = (CASE WHEN A.FREELOCAL3 LIKE '%47%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH48_1 = (CASE WHEN A.FREELOCAL3 LIKE '%48%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH48_2 = (CASE WHEN A.FREELOCAL3 LIKE '%48%' THEN '747474' ELSE '747474' END)
	,BRANCH48_3 = (CASE WHEN A.FREELOCAL3 LIKE '%48%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH48_4 = (CASE WHEN A.FREELOCAL3 LIKE '%48%' THEN '_on' ELSE '' END)
	,BRANCH48_5 = (CASE WHEN A.FREELOCAL3 LIKE '%48%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH48_6 = (CASE WHEN A.FREELOCAL3 LIKE '%48%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH49_1 = (CASE WHEN A.FREELOCAL3 LIKE '%49%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH49_2 = (CASE WHEN A.FREELOCAL3 LIKE '%49%' THEN '747474' ELSE '747474' END)
	,BRANCH49_3 = (CASE WHEN A.FREELOCAL3 LIKE '%49%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH49_4 = (CASE WHEN A.FREELOCAL3 LIKE '%49%' THEN '_on' ELSE '' END)
	,BRANCH49_5 = (CASE WHEN A.FREELOCAL3 LIKE '%49%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH49_6 = (CASE WHEN A.FREELOCAL3 LIKE '%49%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH50_1 = (CASE WHEN A.FREELOCAL4 LIKE '%50%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH50_2 = (CASE WHEN A.FREELOCAL4 LIKE '%50%' THEN '747474' ELSE '747474' END)
	,BRANCH50_3 = (CASE WHEN A.FREELOCAL4 LIKE '%50%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH50_4 = (CASE WHEN A.FREELOCAL4 LIKE '%50%' THEN '_on' ELSE '' END)
	,BRANCH50_5 = (CASE WHEN A.FREELOCAL4 LIKE '%50%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH50_6 = (CASE WHEN A.FREELOCAL4 LIKE '%50%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH52_1 = (CASE WHEN A.FREELOCAL6 LIKE '%52%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH52_2 = (CASE WHEN A.FREELOCAL6 LIKE '%52%' THEN '747474' ELSE '747474' END)
	,BRANCH52_3 = (CASE WHEN A.FREELOCAL6 LIKE '%52%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH52_4 = (CASE WHEN A.FREELOCAL6 LIKE '%52%' THEN '_on' ELSE '' END)
	,BRANCH52_5 = (CASE WHEN A.FREELOCAL6 LIKE '%52%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH52_6 = (CASE WHEN A.FREELOCAL6 LIKE '%52%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH53_1 = (CASE WHEN A.FREELOCAL5 LIKE '%53%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH53_2 = (CASE WHEN A.FREELOCAL5 LIKE '%53%' THEN '747474' ELSE '747474' END)
	,BRANCH53_3 = (CASE WHEN A.FREELOCAL5 LIKE '%53%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH53_4 = (CASE WHEN A.FREELOCAL5 LIKE '%53%' THEN '_on' ELSE '' END)
	,BRANCH53_5 = (CASE WHEN A.FREELOCAL5 LIKE '%53%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH53_6 = (CASE WHEN A.FREELOCAL5 LIKE '%53%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH54_1 = (CASE WHEN A.FREELOCAL5 LIKE '%54%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH54_2 = (CASE WHEN A.FREELOCAL5 LIKE '%54%' THEN '747474' ELSE '747474' END)
	,BRANCH54_3 = (CASE WHEN A.FREELOCAL5 LIKE '%54%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH54_4 = (CASE WHEN A.FREELOCAL5 LIKE '%54%' THEN '_on' ELSE '' END)
	,BRANCH54_5 = (CASE WHEN A.FREELOCAL5 LIKE '%54%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH54_6 = (CASE WHEN A.FREELOCAL5 LIKE '%54%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH55_1 = (CASE WHEN A.FREELOCAL5 LIKE '%55%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH55_2 = (CASE WHEN A.FREELOCAL5 LIKE '%55%' THEN '747474' ELSE '747474' END)
	,BRANCH55_3 = (CASE WHEN A.FREELOCAL5 LIKE '%55%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH55_4 = (CASE WHEN A.FREELOCAL5 LIKE '%55%' THEN '_on' ELSE '' END)
	,BRANCH55_5 = (CASE WHEN A.FREELOCAL5 LIKE '%55%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH55_6 = (CASE WHEN A.FREELOCAL5 LIKE '%55%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH56_1 = (CASE WHEN A.FREELOCAL6 LIKE '%56%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH56_2 = (CASE WHEN A.FREELOCAL6 LIKE '%56%' THEN '747474' ELSE '747474' END)
	,BRANCH56_3 = (CASE WHEN A.FREELOCAL6 LIKE '%56%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH56_4 = (CASE WHEN A.FREELOCAL6 LIKE '%56%' THEN '_on' ELSE '' END)
	,BRANCH56_5 = (CASE WHEN A.FREELOCAL6 LIKE '%56%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH56_6 = (CASE WHEN A.FREELOCAL6 LIKE '%56%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH58_1 = (CASE WHEN A.FREELOCAL4 LIKE '%58%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH58_2 = (CASE WHEN A.FREELOCAL4 LIKE '%58%' THEN '747474' ELSE '747474' END)
	,BRANCH58_3 = (CASE WHEN A.FREELOCAL4 LIKE '%58%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH58_4 = (CASE WHEN A.FREELOCAL4 LIKE '%58%' THEN '_on' ELSE '' END)
	,BRANCH58_5 = (CASE WHEN A.FREELOCAL4 LIKE '%58%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH58_6 = (CASE WHEN A.FREELOCAL4 LIKE '%58%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH60_1 = (CASE WHEN A.FREELOCAL3 LIKE '%60%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH60_2 = (CASE WHEN A.FREELOCAL3 LIKE '%60%' THEN '747474' ELSE '747474' END)
	,BRANCH60_3 = (CASE WHEN A.FREELOCAL3 LIKE '%60%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH60_4 = (CASE WHEN A.FREELOCAL3 LIKE '%60%' THEN '_on' ELSE '' END)
	,BRANCH60_5 = (CASE WHEN A.FREELOCAL3 LIKE '%60%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH60_6 = (CASE WHEN A.FREELOCAL3 LIKE '%60%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH70_1 = (CASE WHEN A.FREELOCAL2 LIKE '%70%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH70_2 = (CASE WHEN A.FREELOCAL2 LIKE '%70%' THEN '747474' ELSE '747474' END)
	,BRANCH70_3 = (CASE WHEN A.FREELOCAL2 LIKE '%70%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH70_4 = (CASE WHEN A.FREELOCAL2 LIKE '%70%' THEN '_on' ELSE '' END)
	,BRANCH70_5 = (CASE WHEN A.FREELOCAL2 LIKE '%70%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH70_6 = (CASE WHEN A.FREELOCAL2 LIKE '%70%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH79_1 = (CASE WHEN A.FREELOCAL3 LIKE '%79%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH79_2 = (CASE WHEN A.FREELOCAL3 LIKE '%79%' THEN '747474' ELSE '747474' END)
	,BRANCH79_3 = (CASE WHEN A.FREELOCAL3 LIKE '%79%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH79_4 = (CASE WHEN A.FREELOCAL3 LIKE '%79%' THEN '_on' ELSE '' END)
	,BRANCH79_5 = (CASE WHEN A.FREELOCAL3 LIKE '%79%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH79_6 = (CASE WHEN A.FREELOCAL3 LIKE '%79%' THEN '</td></tr></table>' ELSE '' END)

	,BRANCH110_1 = (CASE WHEN A.FREELOCAL7 LIKE '%110%' THEN '<table cellpadding="0" cellspacing="0"><tr><td bgcolor="#fdffb9">' ELSE '' END)
	,BRANCH110_2 = (CASE WHEN A.FREELOCAL7 LIKE '%110%' THEN '747474' ELSE '747474' END)
	,BRANCH110_3 = (CASE WHEN A.FREELOCAL7 LIKE '%110%' THEN ' color: ##444444;' ELSE '' END)
	,BRANCH110_4 = (CASE WHEN A.FREELOCAL7 LIKE '%110%' THEN '_on' ELSE '' END)
	,BRANCH110_5 = (CASE WHEN A.FREELOCAL7 LIKE '%110%' THEN ' margin-left: 2px;' ELSE '' END)
	,BRANCH110_6 = (CASE WHEN A.FREELOCAL7 LIKE '%110%' THEN '</td></tr></table>' ELSE '' END)
  ,CONVERT(VARCHAR(256),ENCRYPTBYPASSPHRASE(@ENC_KEY,USERID),2)
FROM FINDDB1.PAPER_NEW.DBO.PP_ALLUSER_EPAPERMAIL_VI A
WHERE
	    A.READINGFLAG = 1
  AND A.USEREMAIL IS NOT NULL AND A.USEREMAIL <> ''
  --AND A.userid in ('sebilia','sebilia123','botangeco1')


DELETE FROM CM_TODAYEBOOK_TB
WHERE  PATINDEX('%@%', USEREMAIL) =  0
	OR PATINDEX('%.%', USEREMAIL) =  0
	OR PATINDEX('%:%', USEREMAIL) <> 0
	OR PATINDEX('%;%', USEREMAIL) <> 0
	OR PATINDEX('%/%', USEREMAIL) <> 0
	OR PATINDEX('%~%', USEREMAIL) <> 0
	OR PATINDEX('%@',  USEREMAIL) <> 0
	OR PATINDEX('@%',  USEREMAIL) <> 0
	OR PATINDEX('%.',  USEREMAIL) <> 0
	OR PATINDEX('.%',  USEREMAIL) <> 0
	OR PATINDEX('%"%', USEREMAIL) <> 0
	OR PATINDEX('%#%', USEREMAIL) <> 0
	OR PATINDEX('%&%', USEREMAIL) <> 0
	OR PATINDEX('%*%', USEREMAIL) <> 0
	OR PATINDEX('%?%', USEREMAIL) <> 0
	OR PATINDEX('%>%', USEREMAIL) <> 0
	OR PATINDEX('%<%', USEREMAIL) <> 0
	OR PATINDEX('%(%', USEREMAIL) <> 0
	OR PATINDEX('%)%', USEREMAIL) <> 0
	OR PATINDEX('%^%', USEREMAIL) <> 0
	OR PATINDEX('%!%', USEREMAIL) <> 0
	OR PATINDEX('%,%', USEREMAIL) <> 0
	OR PATINDEX('%`%', USEREMAIL) <> 0
	OR PATINDEX('%\%', USEREMAIL) <> 0
	OR (USEREMAIL >= '가' AND USEREMAIL <= '히')
	OR (USEREMAIL LIKE '%WWW.%' )



GO
/****** Object:  StoredProcedure [dbo].[USERID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:21:34 ******/
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

	UPDATE A SET UserId=@RE_USERID FROM BadAdCaution A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM BadAdCaution2 A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM CM_TODAYEBOOK_TB A  where CUID=@CUID
	UPDATE A SET ENC_USERID=@RE_USERID FROM CM_TODAYEBOOK_TB A  where ENC_CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM FreePaper A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM FreePaper2 A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM OrderMail A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM RecPaper A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM Temp_OrderMail A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM Temp_OrderMail_Result A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM Temp_OrderMail_Result_마지막 A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM TodayFreePaper A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM UserSaveAd A  where CUID=@CUID

/*
	INSERT LOGDB.DBO.USERID_CHANGE_HISTORY_TB (B_USERID,N_USERID,DB_NM,USERIP)
	SELECT @USERID,@RE_USERID,DB_NAME(),@CLIENT_IP
*/
END


GO
