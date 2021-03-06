USE [USEDCOMMON]
GO
/****** Object:  StoredProcedure [dbo].[CUID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:19:47 ******/
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
	
	UPDATE A SET CUID=@MASTER_CUID FROM DIRECT_BOARD_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM DIRECT_MEMO_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM EscrowReject A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM GoodsInterest A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM KnowHow A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM KnowHowRe A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM OrderMail A  where CUID=@SLAVE_CUID
	UPDATE A SET SALE_CUID=@MASTER_CUID FROM OrderMail A  where SALE_CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM RecStore A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM RecStoreRequest A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM UsrCnt A  where CUID=@SLAVE_CUID
	UPDATE A SET FIND_CUID=@MASTER_CUID FROM UsrCnt A  where FIND_CUID=@SLAVE_CUID
	UPDATE A SET REC_CUID=@MASTER_CUID FROM SendMessage A  where REC_CUID=@SLAVE_CUID
	UPDATE A SET SEND_CUID=@MASTER_CUID FROM SendMessage A  where SEND_CUID=@SLAVE_CUID
	UPDATE A SET SELLER_CUID=@MASTER_CUID FROM GoodsBargain A  where SELLER_CUID=@SLAVE_CUID
	UPDATE A SET BUYER_CUID=@MASTER_CUID FROM GoodsBargain A  where BUYER_CUID=@SLAVE_CUID
/*
	INSERT CUID_CHANGE_HISTORY_TB (B_CUID, N_CUID, USERID, DB_NAME, USERIP)
		SELECT @MASTER_CUID , @SLAVE_CUID,@MASTER_USERID,DB_NAME(),@CLIENT_IP
*/		
END







GO
/****** Object:  StoredProcedure [dbo].[procBannerInsert]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
제목	  : 배너광고 입력처리
작성자	: 김경희 2003.05.19

*******************************************************************/
--drop PROCEDURE procBannerInsert
CREATE PROC [dbo].[procBannerInsert]
		@cboCode1	int
		,@cboCode2 int
		,@cboLocalSite int
		,@cboType int
		,@txtLinkUrl varchar(100)
		,@txtLinkTarget varchar(10)
		,@txtBannerText varchar(1000)
		,@txtWidth int
		,@txtHeight int
AS

	Insert into Banner(Code1, Code2, LocalSite, Type, LinkUrl, LinkTarget, BannerText, SizeWidth, SizeHeight) 
	values(@cboCode1,@cboCode2,@cboLocalSite,@cboType,@txtLinkUrl,@txtLinkTarget,@txtBannerText,@txtWidth,@txtHeight)

	Select @@IDENTITY As Serial
GO
/****** Object:  StoredProcedure [dbo].[procBannerList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
제목	  : 배너광고 리스트
작성자	: 김경희 2003.05.20
Exec procBannerList '1','15','','','1','2003-05-13','2003-05-20' 
*******************************************************************/
--drop PROCEDURE procBannerList
CREATE PROC [dbo].[procBannerList]
	  @Page int
	, @PageSize int	
	, @Local	varchar(2)
	, @Code2	varchar(10)
	, @DateFlag char(1)
	, @StDate	datetime
	, @EnDate	datetime

AS

	DECLARE @Sql nvarchar(1000)
	
	--지역 검색 
	DECLARE @LocalSql nvarchar(100)
	IF @Local = ''
		SET @LocalSql = ''
	ELSE
		BEGIN
			IF @Local = '99'
				SET @LocalSql = ' And LocalSite='	+ @Local
			ELSE
				SET @LocalSql = ' And (LocalSite='	+ @Local + ' OR LocalSite=99) '
		
		END

	--배너 종류 검색
	DECLARE @CodeSql nvarchar(100)
	IF @Code2 = ''
		SET @CodeSql = ''
	ELSE
		SET @CodeSql = ' And A.Code2=' + @Code2

	--접수일 검색
	DECLARE @DateSql nvarchar(200)
	IF @DateFlag = '1'
		SET @DateSql = ' And Convert(varchar(10),RegDate, 120) Between ''' + convert(varchar(10),@StDate,120) + ''' And ''' + convert(varchar(10),@EnDate,120) + ''''
	ELSE
		SET @DateSql = ''		
		
	
	--모든 조건 통합
	DECLARE @Where nvarchar(500)
	SET @Where = @LocalSql + @CodeSql + @DateSql
		

	SET @Sql = '' +
	'Select Count(Serial) ' +
	'From Banner A with (Nolock) , BannerCode B with (Nolock) Where A.Code2=B.Code2 ' + @Where + '  ;' +
	'SET ROWCOUNT ' + Convert(varchar(10),@Page*@PageSize) +
	'Select Serial, A.Code2, B.CodeNm1, B.CodeNm2, LocalSite, Type, LinkUrl, BannerFile, BannerText, SizeWidth, SizeHeight, PrnFlag, RegDate ' +
	'From Banner A with (Nolock) , BannerCode B with (Nolock) Where A.Code2=B.Code2 ' + @Where + ' Order by Serial Desc;' +
	'SET ROWCOUNT 0 ' 

	print @Sql
	EXEC sp_executesql  @Sql
GO
/****** Object:  StoredProcedure [dbo].[ProcEMNormal]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: Emoney-입급처리리스트 - Emoney 관리자페이지  프로시저
	제작자	: 이창연
	제작일	: 2002-04-15
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcEMNormal]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrUseGbn		char(2)	--사용자구분(0/1/2/3/4/5/6/7)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(입금자명/회원명/회원ID)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlUseGbn varchar(200)
	IF @StrUseGbn ='0'
		BEGIN			
			SET 	@SqlUseGbn= ''
		END
	ELSE 
		BEGIN
			SET 	@SqlUseGbn= 'AND E.UseGbn='+@strUseGbn +''
		END
--2.기간
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
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),E.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),E.RegDate,112) <= ''' +@PlusDay+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord = ''
		BEGIN
			SET 	@SqlKeyWord=''
		END
	ELSE IF @StrCboKeyWord ='입금자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND E.InputName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원명'
		BEGIN
			SET 	@SqlKeyWord= 'AND U.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND E.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlUseGbn + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(E.Serial) FROM UsedCommon.dbo.Emoney E, FindDB2.Common.dbo.UserCommon U, FindDB2.FindCommon.dbo.BankAccount B  ' +
			'WHERE E.StateFlag Not In (1,6) And E.UserID = U.UserID And E.BankNo = B.BankCode ' + @SqlAll + ';  ' +
			' SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  E.Serial, Convert(varchar(10),E.RegDate,120) as RegDate, Convert(varchar(10),E.ProcDate,120) as ProcDate, E.UserID,  ' +
			'  E.BankNo, E.SaveAmt, E.InputName, E.StateFlag, E.UseGbn, U.UserName, B.BankName ' +
			'  FROM UsedCommon.dbo.Emoney E, FindDB2.Common.dbo.UserCommon U, FindDB2.FindCommon.dbo.BankAccount B ' +
			'  WHERE E.StateFlag Not In (1,6) And E.UserID=U.UserID And E.BankNo=B.BankCode ' + @SqlAll + 
			'  ORDER BY E.Serial ASC ' 
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcEMPaying]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: Emoney-출금요청리스트 - Emoney 관리자페이지  프로시저
	제작자	: 이창연
	제작일	: 2002-04-15
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcEMPaying]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrUseGbn		char(2)	--사용자구분(0/1/2/3/4/5/6/7)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(입금자명/회원명/회원ID)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlUseGbn varchar(200)
	IF @StrUseGbn ='0'
		BEGIN			
			SET 	@SqlUseGbn= ''
		END
	ELSE 
		BEGIN
			SET 	@SqlUseGbn= 'AND E.UseGbn='+@strUseGbn +''
		END
--2.기간
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
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),E.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),E.RegDate,112) <= ''' +@PlusDay+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord = ''
		BEGIN
			SET 	@SqlKeyWord=''
		END
	ELSE IF @StrCboKeyWord ='입금자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND E.InputName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원명'
		BEGIN
			SET 	@SqlKeyWord= 'AND U.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND E.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlUseGbn + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(E.Serial) FROM UsedCommon.dbo.Emoney E, FindDB2.Common.dbo.UserCommon U, FindDB2.FindCommon.dbo.UserBankInfo B ' +
			'WHERE E.StateFlag=3 And E.UserID = U.UserID And E.UserID=B.UserID ' + @SqlAll + ';  ' +
			' SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  E.Serial, Convert(varchar(10),E.RegDate,120) as RegDate, Convert(varchar(10),E.ProcDate,120) as ProcDate, E.UserID,  ' +
			'  E.SumAmt,  Sum(E.SaveAmt) As TotSaveAmt, E.SaveAmt, E.StateFlag, E.UseGbn, U.UserName, B.BankNm, B.Account  ' +
			'  FROM UsedCommon.dbo.Emoney E, FindDB2.Common.dbo.UserCommon U, FindDB2.FindCommon.dbo.UserBankInfo B ' +
			' Group By E.Serial,Convert(varchar(10),E.RegDate,120),Convert(varchar(10),E.ProcDate),E.UserID,E.SumAmt,E.SaveAmt,E.SaveAmt,E.StateFlag,E.UseGbn, U.UserName,B.BankNm, B.Account  ' +
			'  WHERE E.StateFlag= 3  And E.UserID=U.UserID And E.UserID=B.UserID ' + @SqlAll + 
			'  ORDER BY E.Serial ASC ' 
	END
PRINT(@strQuery)
EXEC(@strQuery)
EXEC ProcEMPaying 1, 15,'20020401','20020415','2','',''
GO
/****** Object:  StoredProcedure [dbo].[ProcEMReDelay]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: Emoney-입급보류리스트 - Emoney 관리자페이지  프로시저
	제작자	: 이창연
	제작일	: 2002-04-15
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcEMReDelay]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrUseGbn		char(2)	--사용자구분(0/1/2/3/4/5/6/7)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(입금자명/회원명/회원ID)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlUseGbn varchar(200)
	IF @StrUseGbn ='0'
		BEGIN			
			SET 	@SqlUseGbn= ''
		END
	ELSE 
		BEGIN
			SET 	@SqlUseGbn= 'AND E.UseGbn='+@strUseGbn +''
		END
--2.기간
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
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),E.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),E.RegDate,112) <= ''' +@PlusDay+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord = ''
		BEGIN
			SET 	@SqlKeyWord=''
		END
	ELSE IF @StrCboKeyWord ='입금자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND E.InputName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원명'
		BEGIN
			SET 	@SqlKeyWord= 'AND U.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND E.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlUseGbn + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(E.Serial) FROM UsedCommon.dbo.Emoney E, FindDB2.Common.dbo.UserCommon U, FindDB2.FindCommon.dbo.BankAccount B  ' +
			'WHERE E.StateFlag=6 And E.UserID = U.UserID And E.BankNo = B.BankCode ' + @SqlAll + ';  ' +
			' SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  E.Serial, Convert(varchar(10),E.RegDate,120) as RegDate, Convert(varchar(10),E.ProcDate,120) as ProcDate, E.UserID,  ' +
			'  E.BankNo, E.SaveAmt, E.InputName, E.StateFlag, E.UseGbn, U.UserName, B.BankName ' +
			'  FROM UsedCommon.dbo.Emoney E, FindDB2.Common.dbo.UserCommon U, FindDB2.FindCommon.dbo.BankAccount B ' +
			'  WHERE E.StateFlag= 6  And E.UserID=U.UserID And E.BankNo=B.BankCode ' + @SqlAll + 
			'  ORDER BY E.Serial ASC ' 
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcEReqRec]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: Emoney-입급확인요망 - Emoney 관리자페이지  프로시저
	제작자	: 이창연
	제작일	: 2002-04-09
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcEReqRec]
(
	@Page			int
,	@PageSize		int
,	@StrStartDt		varchar(10)
,	@StrLastDt		varchar(10)
,	@StrUseGbn		char(2)	--사용자구분(0/1/2/3/4/5/6/7)
,	@StrCboKeyWord		varchar(10)	-- 키워드 검색조건(입금자명/회원명/회원ID)
,	@StrTxtKeyWord		varchar(50)	-- 키워드
)
AS
-- 전체 검색쿼리 시작
--1.결제방법검색
	DECLARE @SqlUseGbn varchar(200)
	IF @StrUseGbn ='0'
		BEGIN			
			SET 	@SqlUseGbn= ''
		END
	ELSE 
		BEGIN
			SET 	@SqlUseGbn= 'AND E.UseGbn='+@strUseGbn +''
		END
--2.기간
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
			SET 	@SqlSMakDt= ' AND Convert(varchar(10),E.RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(10),E.RegDate,112) <= ''' +@PlusDay+ ''''
		END
--3.키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @StrCboKeyWord = ''
		BEGIN
			SET 	@SqlKeyWord=''
		END
	ELSE IF @StrCboKeyWord ='입금자명'		
		BEGIN			
			SET 	@SqlKeyWord= 'AND E.InputName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원명'
		BEGIN
			SET 	@SqlKeyWord= 'AND U.UserName Like ''%' + @strTxtKeyWord+'%'' '
		END
	ELSE IF @StrCboKeyWord='회원ID'
		BEGIN
			SET 	@SqlKeyWord= 'AND E.UserID Like ''%' + @strTxtKeyWord+'%'' '
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll = @SqlUseGbn + @SqlSMakDt + @SqlEMakDt + @SqlKeyWord
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1000)
	BEGIN
		SET @strQuery =
			'SELECT  COUNT(E.Serial) FROM UsedCommon.dbo.Emoney E, FindDB2.Common.dbo.UserCommon U, FindDB2.FindCommon.dbo.BankAccount B  ' +
			'WHERE E.StateFlag=1 And E.UserID = U.UserID And E.BankNo = B.BankCode ' + @SqlAll + ';  ' +
			' SELECT TOP '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  E.Serial, Convert(varchar(10),E.RegDate,120) as RegDate, Convert(varchar(10),E.ProcDate,120) as ProcDate, E.UserID,  ' +
			'  E.BankNo, E.SaveAmt, E.InputName, E.StateFlag, E.UseGbn, U.UserName, B.BankName ' +
			'  FROM UsedCommon.dbo.Emoney E, FindDB2.Common.dbo.UserCommon U, FindDB2.FindCommon.dbo.BankAccount B ' +
			'  WHERE E.StateFlag= 1  And E.UserID=U.UserID And E.BankNo=B.BankCode ' + @SqlAll + 
			'  ORDER BY E.Serial ASC ' 
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procLoginHot]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
제목	  : 로그인 핫 관리 정보 가져오기
작성자	: 김경희 2003.06.17

*******************************************************************/
--drop PROCEDURE dbo.procLoginHot
CREATE PROC [dbo].[procLoginHot]
		@LocalSite	int
AS

	IF @LocalSite = 0
	BEGIN
		SELECT Seq, LocalSite, Subject, Link, Target, Contents, RegDate, PrnFlag
		FROM LoginNotice 
		WHERE PrnFlag='Y' AND LocalSite=@LocalSite
		ORDER BY RegDate DESC 
	END
	ELSE
	BEGIN
		SELECT Seq, LocalSite, Subject, Link, Target, Contents, RegDate, PrnFlag
		FROM LoginNotice 
		WHERE PrnFlag='Y' AND (LocalSite=@LocalSite OR Localsite=0)
		ORDER BY RegDate DESC 
	END
GO
/****** Object:  StoredProcedure [dbo].[procMagAskList]    Script Date: 2021-11-04 오전 10:19:47 ******/
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
CREATE PROC [dbo].[procMagAskList] (
@PAGE		int,
@PAGESIZE	int,
@FLAG                   as varchar(1),
@STARTDATE        as  varchar(12),
@ENDDATE            as  varchar(12),
@SEARCHSELECT as  varchar(100)
)
AS


DECLARE @SearchSql	varchar(100)
IF @FLAG = '1'
	SET @SearchSql = ' AND QueryType = ''' + REPLACE(@SEARCHSELECT,'''','''''') + ''' '
ELSE
	SET @SearchSql = ''


DECLARE @SQL		varchar(2000)
SET         @SQL =
		'SELECT COUNT(serial) FROM  USRCNT WHERE '  +  
		' 	CNTFLAG = ''1''  AND   CONVERT(char(10),regdate,120) BETWEEN ''' + CONVERT(char(10), @STARTDATE,120) + ''' ' +
		' 	and ''' + CONVERT(char(10), @ENDDATE,120) +  ''' ' + @SearchSql + ' ;' + ' ' +
		'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + ' serial, CONVERT(char(10) , RegDate , 120) as  RegDate , userid,title,sended,   CONVERT(char(10) , SendDate , 120)  as  SendDate,  userNM,Email,Phone,Contents,QueryType  ' + ' ' +
		'	FROM  USRCNT' + ' ' +
                            '	WHERE  CNTFLAG = ''1''  AND  CONVERT(char(10),regdate,120) BETWEEN ''' + CONVERT(char(10), @STARTDATE,120) + ''' ' + 
		' 	and ''' + CONVERT(char(10), @ENDDATE,120)  + ''' ' + @SearchSql + ' ORDER BY  Serial  DESC'
print(@sql)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagBanAskList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 배너광고 문의  리스트
제작자		: 강홍석
제작일		: 2002-07-15
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[procMagBanAskList] (
@PAGE		int,
@PAGESIZE	int,
@FLAG		as varchar(1),
@STARTDATE	as  varchar(12),
@ENDDATE	as  varchar(12),
@SEARCHSELECT	as  varchar(100),
@strLocal	int
)
AS
DECLARE @SQL		varchar(2000)
DECLARE @SEARCHSELECT2	varchar(500)
SET 	@SEARCHSELECT2 			='''' +  REPLACE(@SEARCHSELECT,'''','''''') + ''''
SET         @SQL =
          CASE   
              WHEN   @FLAG = 0  THEN       --검색어가 없는 경우
			'SELECT COUNT(serial) FROM  USRCNT  WHERE regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND  CNTFLAG = ''4'' AND LocalSite = '+CONVERT(varchar(10), @strLocal) + ' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' serial,  CONVERT(char(10) , RegDate , 120) as  RegDate , UserNm,Email,Phone,sended,  CONVERT(char(10) , SendDate , 120)  as  SendDate , Contents,QueryType,LocalSite,CompanyNm,PrnLocate ' + ' ' +
			'FROM  USRCNT  WHERE  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND  CNTFLAG = ''4''  AND LocalSite = '+CONVERT(varchar(10), @strLocal) + '  ORDER BY   Serial  DESC '
              ELSE 		--검색어가 있는 경우
			'SELECT COUNT(serial) FROM  USRCNT WHERE PrnLocate = ' + @SEARCHSELECT2  +  
			'  and  CNTFLAG = ''4''  AND   regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND LocalSite = '+CONVERT(varchar(10), @strLocal) + ' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + ' serial, CONVERT(char(10) , RegDate , 120) as  RegDate , UserNm,Email,Phone,sended,  CONVERT(char(10) , SendDate , 120)  as  SendDate , Contents,QueryType,LocalSite,CompanyNm,PrnLocate  ' + ' ' +
			'FROM  USRCNT' + ' ' +
			'WHERE  PrnLocate = ' + @SEARCHSELECT2  +  '  and  CNTFLAG = ''4''  AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110)  + ''' AND LocalSite = '+CONVERT(varchar(10), @strLocal) + '  ORDER BY  Serial  DESC'
           END
print(@SEARCHSELECT2)
print(@sql)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagBannerAccList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 배너광고취소리스트
제작자		: 이지만
제작일		: 2002-03-13
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[procMagBannerAccList] (
@PAGE				int,
@PAGESIZE			int,
@FLAG                   	as 	varchar(1),
@STARTDATE        	as 	varchar(12),
@ENDDATE            	as  	varchar(12),
@intLocate		as  	varchar(5),
@intType		as	varchar(5),
@BOXSTATE2		as	varchar(5),
@strLocal		int  	    	    
)
AS
DECLARE @SQL	varchar(2000)
DECLARE @BOXSTATE3	varchar(500)
SET         @SQL =
          CASE   
              WHEN   @FLAG = 0  THEN       --검색어가 없는 경우
	--	WHEN @flag = 0  THEN
			'SELECT COUNT(serial) FROM  BANNER  WHERE   BoxState1=''2''    AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND LocalSite = ' + CONVERT(char(10), @strLocal) + '  ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' Serial,UserNM ,  LinkUrl,  PrnLocate,PrnType,PrnCnt,PrnAmt, RegDate,BoxState1,BoxState2,PrnDay  ' + ' ' +
			'FROM  BANNER  WHERE  BoxState1=''2''      AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''   AND LocalSite = ' + CONVERT(char(10), @strLocal) + '   ORDER BY  Serial  DESC '
              ELSE 		--검색어가 있는 경우
			'SELECT COUNT(serial) FROM  BANNER  WHERE BoxState1=''2''      AND  PrnLocate=''' + @intLocate + '''  and  PrnType=''' + @intType + ''' AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + ''' AND LocalSite = ' + CONVERT(char(10), @strLocal) + '  ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + ' Serial,UserNM ,  LinkUrl,  PrnLocate,PrnType,PrnCnt,PrnAmt, RegDate,BoxState1,BoxState2,PrnDay  ' + ' ' +
			'FROM  BANNER' + ' ' +
                                          'WHERE  BoxState1=''2''     AND  PrnLocate=''' + @intLocate + '''  and  PrnType=''' + @intType + ''' AND   regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110)  + '''  AND LocalSite = ' + CONVERT(char(10), @strLocal) + ' ORDER BY  Serial DESC'
           END
print(@sql)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagBannerCancelList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 배너광고취소리스트
제작자		: 이지만
제작일		: 2002-03-13
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[procMagBannerCancelList] (
@PAGE				int,
@PAGESIZE			int,
@FLAG                   	as 	varchar(1),
@STARTDATE        	as 	varchar(12),
@ENDDATE            	as  	varchar(12),
@intLocate		as  	varchar(5),
@intType		as	varchar(5),
@BOXSTATE2		as	varchar(5),
@strLocal		int  	    
)
AS
DECLARE @SQL	varchar(2000)
DECLARE @BOXSTATE3	varchar(500)
SET         @SQL =
          CASE   
              WHEN   @FLAG = 0  THEN       --검색어가 없는 경우
	--	WHEN @flag = 0  THEN
			'SELECT COUNT(serial) FROM  BANNER  WHERE   BoxState2=''2''   AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND LocalSite = ' + CONVERT(char(10), @strLocal) + '  ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' Serial,UserNM ,  LinkUrl,  PrnLocate,PrnType,PrnCnt,PrnAmt, RegDate,BoxState1,BoxState2,PrnDay  ' + ' ' +
			'FROM  BANNER  WHERE  BoxState2=''2''     AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND LocalSite = ' + CONVERT(char(10), @strLocal) + '    ORDER BY  Serial  DESC '
              ELSE 		--검색어가 있는 경우
			'SELECT COUNT(serial) FROM  BANNER  WHERE  BoxState2=''2''    AND  PrnLocate=''' + @intLocate + '''  and  PrnType=''' + @intType + ''' AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''  AND LocalSite = ' + CONVERT(char(10), @strLocal) + ' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + ' Serial,UserNM ,  LinkUrl,  PrnLocate,PrnType,PrnCnt,PrnAmt, RegDate,BoxState1,BoxState2,PrnDay  ' + ' ' +
			'FROM  BANNER' + ' ' +
                                          'WHERE  BoxState2=''2''    AND  PrnLocate=''' + @intLocate + '''  and  PrnType=''' + @intType + ''' AND   regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110)  + ''' AND LocalSite = ' + CONVERT(char(10), @strLocal) + '  ORDER BY  Serial DESC'
           END
print(@sql)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagBannerList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 배너광고신청리스트
제작자		: 이지만
제작일		: 2002-03-13
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[procMagBannerList] (
@PAGE				int,
@PAGESIZE			int,
@FLAG                   	as 	varchar(1),
@STARTDATE        	as 	varchar(12),
@ENDDATE            	as  	varchar(12),
@intLocate		as  	varchar(5),
@intType		as	varchar(5),
@BOXSTATE2		as	varchar(5),
@strLocal		int  
)
AS
DECLARE @SQL	varchar(2000)
SET         @SQL =
          CASE   
              WHEN   @FLAG = 0  THEN       --검색어가 없는 경우
	--	WHEN @flag = 0  THEN
			'SELECT COUNT(serial) FROM  BANNER  WHERE  ( BoxState2=''1''  or  BoxState2=''3'')     AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + ''' AND LocalSite = ' + CONVERT(char(10), @strLocal) + ' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' Serial,UserNM ,  LinkUrl,  PrnLocate,PrnType,PrnCnt,PrnAmt, RegDate,BoxState1,BoxState2,PrnDay  ' + ' ' +
			'FROM  BANNER  WHERE  (BoxState2=''1''  or  BoxState2=''3'' )    AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''   AND LocalSite = ' + CONVERT(char(10), @strLocal) + '   ORDER BY  Serial  DESC '
              ELSE 		--검색어가 있는 경우
			'SELECT COUNT(serial) FROM  BANNER  WHERE  (BoxState2=''1''  or  BoxState2=''3'' )    AND  PrnLocate=''' + @intLocate + '''  and  PrnType=''' + @intType + ''' AND  regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + ''' AND LocalSite = ' + CONVERT(char(10), @strLocal) + '  ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + ' Serial,UserNM ,  LinkUrl,  PrnLocate,PrnType,PrnCnt,PrnAmt, RegDate,BoxState1,BoxState2,PrnDay  ' + ' ' +
			'FROM  BANNER' + ' ' +
                                          'WHERE  (BoxState2=''1''  or  BoxState2=''3'' )   AND  PrnLocate=''' + @intLocate + '''  and  PrnType=''' + @intType + ''' AND   regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110)  + ''' AND LocalSite = ' + CONVERT(char(10), @strLocal) + '  ORDER BY  Serial DESC'
           END
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagBannerList_HS]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 배너광고리스트
제작자		: 강홍석
제작일		: 2002-07-18
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
*************************************************************************************/
CREATE PROC [dbo].[procMagBannerList_HS] (
@PAGE		int,
@PAGESIZE	int,
@STARTDATE	as 	varchar(12),	--접수일검색 시작일자
@ENDDATE	as  	varchar(12),	--접수일검색 종료일자
@PRNLOCATE	as	varchar(20),
@PRNTYPE	as  	varchar(10),
@BOXSTATE1	as	varchar(5),
@SEARCHKEYWORD	varchar(50),		-- 키워드
@SEARCHTEXT	varchar(30),		-- 검색어
@strLOCAL		int  
)
AS
--접수일
	DECLARE @SqlDate varchar(100)
	IF @STARTDATE ='' OR @ENDDATE = ''
		BEGIN			
			SET 	@SqlDate= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlDate= ' AND regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + ''' and ''' + CONVERT(char(10), @ENDDATE,110) + ''''
		END
--게재유형
	DECLARE @SqlPrnType varchar(100)
	IF @PRNTYPE =''
		BEGIN			
			SET 	 @SqlPrnType= ''
		END                                
	ELSE 
		BEGIN
			SET 	 @SqlPrnType= ' AND PrnType = '' + @PRNTYPE + '' '
		END	
--게재위치
	DECLARE @SqlPrnLocate varchar(100)
	IF @PRNLOCATE =''
		BEGIN
			SET 	 @SqlPrnLocate= ''
		END                                
	ELSE 
		BEGIN
			SET 	 @SqlPrnLocate= ' AND PrnLocate = '' + @PRNLOCATE + '' '
		END	
--결제현황
	DECLARE @SqlBoxState1 varchar(100)
	IF @BOXSTATE1 =''
		BEGIN			
			SET 	@SqlBoxState1= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlBoxState1= ' AND BoxState1 = ''' + @BOXSTATE1 + ''' '
		END
		
--키워드검색
	DECLARE @SqlKeyWord varchar(200)
	IF @SEARCHTEXT =''
		BEGIN			
			SET 	@SqlKeyWord= ''
		END
	ELSE  
		BEGIN
			SET 	@SqlKeyWord= ' AND ' + @SEARCHKEYWORD + ' LIKE  ''%' + @SEARCHTEXT+'%'' ' 
		END
			
		
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET 	@SqlAll = @SqlDate+@SqlPrnType + @SqlPrnLocate + @SqlBoxState1 + @SqlKeyWord
		END
DECLARE @SQL	varchar(2000)
		SET @SQL = 'SELECT COUNT(serial) FROM  BANNER  WHERE LocalSite = ' + CONVERT(char(10), @strLocal) + @SqlAll + ' ;' +
			' SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' Serial,RegDate,CompanyNm,PrnType,PrnLocate,UserNM ,LinkUrl, PrnDay, PrnCnt,PrnAmt, BoxState1,BoxState2  ' +
			' FROM  BANNER  WHERE  LocalSite = ' + CONVERT(char(10), @strLocal) + @SqlAll + ' ORDER BY RegDate DESC '
PRINT(@SQL)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagBizList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 사업제휴리스트
제작자		: 이지만
제작일		: 2002-03-13
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[procMagBizList] (
@PAGE				int,
@PAGESIZE			int,
@FLAG                   	as 	varchar(1),
@STARTDATE        	as 	varchar(12),
@ENDDATE            	as  	varchar(12)
)
AS
DECLARE @SQL	varchar(2000)
SET         @SQL =
          CASE   
              WHEN   @FLAG = 0  THEN       --검색어가 없는 경우
	--	WHEN @flag = 0  THEN
			'SELECT COUNT(serial) FROM  BizRelation  WHERE   regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''  ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' Serial,RegDate, ConPart, CompanyNM, UserNM,Phone ,Title, InsFile, ProcessChk  ' + ' ' +
			'FROM  BizRelation  WHERE    regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + '''    ORDER BY  RegDate DESC '
              ELSE 		--검색어가 있는 경우
			'SELECT COUNT(serial) FROM  BizRelation  WHERE   regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110) + ''' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + ' Serial,RegDate, ConPart, CompanyNM, UserNM,Phone ,Title, InsFile, ProcessChk  ' + ' ' +
			'FROM  BizRelation ' + ' ' +
                                          'WHERE    regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,110)  + ''' ORDER BY  regdate DESC'
           END
PRINT(@STARTDATE)
PRINT(@ENDDATE)
PRINT(@SQL)
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagCommList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 공지사항 리스트
제작자		: 이지만
제작일		: 2002-03-11
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[procMagCommList] (
@PAGE		int,
@PAGESIZE	int,
@strLocal	int
)
AS
DECLARE @SQL	varchar(2000)
SET         @SQL =	'SELECT COUNT(serial) FROM  SiteNews WHERE PartCode<>''1'' AND LocalSite ='+ CONVERT(varchar(10), @strLocal) + ' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' Serial,LocalSite,NewsGbn,Title,ViewFlag ' + ' ' +
			'FROM  SiteNews WHERE PartCode<>''1''  AND LocalSite ='+ CONVERT(varchar(10), @strLocal) + '  ORDER BY  Serial DESC '
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagJoinList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명		: 회원재가입 신청 리스트
제작자		: 이지만
제작일		: 2002-03-011
셜명		: 페이징,검색
		
*************************************************************************************/
CREATE PROC [dbo].[procMagJoinList] (@PAGE		int, @PAGESIZE	int, @FLAG                   as varchar(1),	@STARTDATE        as  varchar(12),	@ENDDATE            as  varchar(12) )
AS
DECLARE @SQL	varchar(2000)
SET         @SQL =
          CASE   
              WHEN   @FLAG = 0  THEN       --검색어가 없는 경우
	--	WHEN @flag = 0  THEN
			'SELECT COUNT(serial) FROM  USRCNT  WHERE  CNTFLAG = ''3'' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' serial, Convert(Char(10), regdate,120) as regdate , userid, JuminNo, password,title,sended,SendDate,userNM,Email,Phone,Contents' + ' ' +
			'FROM  USRCNT  WHERE   CNTFLAG = ''3''  ORDER BY  regdate DESC '
              ELSE 		--검색어가 있는 경우
			'SELECT COUNT(serial) FROM  USRCNT WHERE  CNTFLAG = ''3''  AND   CONVERT(char(10),regdate,120) BETWEEN ''' + 
			CONVERT(char(10), @STARTDATE,120) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,120) + ''' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' serial,  Convert(Char(10), regdate,120) as regdate ,  userid, JuminNo, password,title,sended,SendDate,userNM,Email,Phone,Contents' + ' ' +
			'FROM  USRCNT' + ' ' +
                                          'WHERE  CNTFLAG = ''3''  AND  CONVERT(char(10),regdate,120) BETWEEN ''' + CONVERT(char(10), @STARTDATE,120) + 
			''' and ''' + CONVERT(char(10), @ENDDATE,120)  + ''' ORDER BY  regdate DESC'
           END
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagNewsList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 뉴스 리스트
제작자		: 김명재
제작일		: 2002-12-20
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[procMagNewsList] (
@PAGE	int,
@PAGESIZE	int,
@strLocal	int
)
AS
DECLARE @SQL	varchar(2000)
SET         @SQL =	'SELECT COUNT(serial) FROM NewsRoom; ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' Serial,NewsGbn,Title,ViewFlag ' + ' ' +
			'FROM NewsRoom ORDER BY Serial DESC '
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagPollList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: Find Poll 리스트
제작자		: 이지만
제작일		: 2002-03-13
셜명		: 페이징,검색
PageSize	: 페이지당 게시물 개수
Page		: 페이지
		
*************************************************************************************/
CREATE PROC [dbo].[procMagPollList] (
@PAGE				int,
@PAGESIZE			int,
@FLAG                   	as 	varchar(1),
@STARTDATE        	as 	varchar(12),
@ENDDATE            	as  	varchar(12),
@strLocal			int
)
AS
DECLARE @SQL	varchar(2000)
SET         @SQL =
          CASE   
              WHEN   @FLAG = 0  THEN       --검색어가 없는 경우
			'SELECT COUNT(serial) ' +
			' FROM  Poll  ' +
			' WHERE   regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + ''' and ''' + CONVERT(char(10), @ENDDATE,110) + 
			'''  AND LocalSite =' + CONVERT(varchar(10), @strLocal) + ' ;' + ' ' +
			' SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + 
			' Serial,Title ,ResultCnt1,ResultCnt2,ResultCnt3,ResultCnt4,ResultCnt5,StDate,EnDate, IsEnd, RegDate   ' + ' ' +
			' FROM  Poll  ' + 
			' WHERE    regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + ''' and ''' + CONVERT(char(10), @ENDDATE,110) + 
			'''   AND LocalSite =' + CONVERT(varchar(10), @strLocal) + 
			' ORDER BY  RegDate DESC '
              ELSE 		--검색어가 있는 경우
			' SELECT COUNT(serial) ' +
			' FROM  BANNER  ' +
			' WHERE    regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + ''' and ''' + CONVERT(char(10), @ENDDATE,110) + 
			'''  AND LocalSite =' + CONVERT(varchar(10), @strLocal) + ' ;' + ' ' +
			' SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) + ' Serial,Title ,ResultCnt1,ResultCnt2,ResultCnt3,ResultCnt4,ResultCnt5,StDate,EnDate, IsEnd, RegDate  ' + ' ' +
			' FROM  BANNER' + ' ' +
                                          ' WHERE    regdate BETWEEN ''' + CONVERT(char(10), @STARTDATE,110) + ''' and ''' + CONVERT(char(10), @ENDDATE,110)  + 
			'''  AND LocalSite =' + CONVERT(varchar(10), @strLocal) + 
			' ORDER BY  regdate DESC'
           END
EXEC(@SQL)
PRINT(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagSuggestList]    Script Date: 2021-11-04 오전 10:19:47 ******/
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
CREATE PROC [dbo].[procMagSuggestList] (
@PAGE		int,
@PAGESIZE	int,
@FLAG		as varchar(1),
@STARTDATE	as  varchar(12),
@ENDDATE	as  varchar(12),
@strLocal       int
)
AS
DECLARE @SQL	varchar(2000)
DECLARE @LocalSQL	varchar(100)
IF @strLocal = 0
	SET @LocalSQL = ''
ELSE
	SET @LocalSQL = ' AND LocalSite = ' + CONVERT(varchar(10), @strLocal) + ' '
SET         @SQL =
          CASE   
              WHEN   @FLAG = 0  THEN
			
			'SELECT COUNT(serial) FROM  USRCNT  WHERE  CNTFLAG = ''2'' ; ' + @LocalSQL +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) 
			+ ' serial,  Convert(Char(10), regdate,120) as regdate  , userid,title,sended,SendDate,userNM,Email,Phone,Contents' + ' ' +
			'FROM  USRCNT  WHERE  CNTFLAG = ''2'' ' + @LocalSQL + ' ORDER BY  Serial DESC '
              ELSE
			
			'SELECT COUNT(serial) FROM  USRCNT WHERE  CNTFLAG = ''2'' ' + @LocalSQL + ' AND  CONVERT(char(10),regdate,120) BETWEEN ''' 
			+ CONVERT(char(10), @STARTDATE,120) 
			+ ''' and ''' + CONVERT(char(10), @ENDDATE,120) + ''' ;' + ' ' +
			'SELECT TOP ' + CONVERT(varchar(10), @PAGE*@PAGESIZE) 
			+ ' serial,  Convert(Char(10), regdate,120) as regdate , userid,title,sended,SendDate,userNM,Email,Phone,Contents' + ' ' +
			'FROM  USRCNT' + ' ' +
			'WHERE  CNTFLAG = ''2'' ' + @LocalSQL + ' AND  CONVERT(char(10),regdate,120) BETWEEN ''' 
			+ CONVERT(char(10), @STARTDATE,120) + ''' and '''
			+ CONVERT(char(10), @ENDDATE,120)  + ''' ORDER BY  Serial DESC'
           END
EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procMagUserUsedEmail]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 직거래맟춤정보
	제작자	: 이지만
	제작일	: 2002-03-21
	셜명	:
		cboCode1          	: 분류별검색
		cboUseFlag         : 분류별검색
		txtCodeNm2	: 분류별검색
*************************************************************************************/
CREATE PROC [dbo].[procMagUserUsedEmail] 
(
	@strUserID	VARCHAR(30)
)
AS
-- 등록된 카테고리  갯수/리스트 가져오기
	
DECLARE @Sql	varchar(2000)
SET @Sql =
	    'SELECT  a.UserId, a.advGbn, Detail, UseGbn, ZipMain, ZipSub,WishAmt, UseYY,SaleUserID, RegDate, SrvStDay, SrvEnDay, MailChk, '+
	    '  b.CodeNm1,b.CodeNm2,b.CodeNm3  '+	
	    ' FROM  OrderMail  a,   UsedMain.dbo.CatCode  b '+
	    ' WHERE   '+
	    '	     a.code1  = b.code1   and '+	
	    '	     a.code2  = b.code2   and '+	
	    '	     a.code3  = b.code3   and '+	
	    '              a.UserID = ''' +@strUserID+ ''''			
EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[ProcMyEmoneyExcel]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: MyShop 입출금내역 Excel 파일 프로시저
	제작자	: 이창연
	제작일	: 2002-04-09
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[ProcMyEmoneyExcel]
(
	@UserID			varchar(15)
,	@Year1			varchar(4)
,	@Month1		varchar(2)
,	@Day1			varchar(2)
,	@Year2			varchar(4)
,	@Month2		varchar(2)
,	@Day2			varchar(2)
)
AS
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
			SET 	@SqlSMakDt= ' AND Convert(varchar(8),RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(8),RegDate,112) <= ''' +@PlusDay+ ''''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt  
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1500)
	BEGIN
		SET @strQuery =
			' SELECT  Serial,Convert(varchar(10),ProcDate,120) as ProcDate,BankNo,StateFlag,SaveAmt,FundAmt,SumAmt ' +
			'  FROM Emoney ' +
			'  WHERE UserID = '''+ @UserID + ''' ' +  @SqlAll + 
			'  ORDER BY Serial ASC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[ProcMyEmoneyList]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: MyShop 입출금내역리스트 프로시저
	제작자	: 이창연
	제작일	: 2002-04-08
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[ProcMyEmoneyList]
(
	@Page			int
,	@PageSize		int
,	@UserID			varchar(15)
,	@Year1			varchar(4)
,	@Month1		varchar(2)
,	@Day1			varchar(2)
,	@Year2			varchar(4)
,	@Month2		varchar(2)
,	@Day2			varchar(2)
)
AS
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
			SET 	@SqlSMakDt= ' AND Convert(varchar(8),RegDate,112) >= ''' +@strStartDt +''''
		END
	DECLARE @SqlEMakDt	varchar(200)
	IF @StrLastDt=''
		BEGIN
			SET	@SqlEMakDt=''
		END
	ELSE 
		BEGIN
			SET 	@SqlEMakDt= ' AND Convert(varchar(8),RegDate,112) <= ''' +@PlusDay+ ''''
		END
--전체검색쿼리를 묶어서
	DECLARE @SqlAll	varchar(500)
		BEGIN
			SET	@SqlAll =  @SqlSMakDt + @SqlEMakDt  
		END
-- 키워드 검색쿼리 끝
DECLARE @strQuery varchar(1500)
	BEGIN
		SET @strQuery =
			'SELECT TOP 1 COUNT(Serial) FROM Emoney  ' +
			'  WHERE  UserID = '''+ @UserID + ''' ' +  @SqlAll + ';  ' +
			' SELECT Top '+ CONVERT(varchar(10), @Page*@PageSize) +
			'  Serial,Convert(varchar(10),RegDate,120) as RegDate,BankNo,StateFlag,SaveAmt,FundAmt,SumAmt ' +
			'  FROM Emoney ' +
			'  WHERE UserID = '''+ @UserID + ''' ' +  @SqlAll + 
			'  ORDER BY Serial ASC '
	END
PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[procThemeInsert]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
제목	  : 테마카테고리 입력처리
작성자	: 김경희 2003.006.11

*******************************************************************/
--drop PROCEDURE dbo.procThemeInsert
CREATE PROC [dbo].[procThemeInsert]
		@LocalSite	int
		, @KeyWord	varchar(200)
		, @CarNm		varchar(50)
		, @Method	char(1)
		, @CodeNm	varchar(400)
AS

	
	Insert into dbo.ThemeCat 
	(LocalSite, KeyWord, CarNm, Method, CodeNm)
	values
	(@LocalSite, @KeyWord, @CarNm, @Method, @CodeNm)
	

	Select @@IDENTITY As Serial
GO
/****** Object:  StoredProcedure [dbo].[procUserBadAsk]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 고객지원-프런트
제작자		: 이지만
제작일		: 2002-04-03
셜명		: 불량광고 문의 접수처리
		
		cntFlag=1 :물품등록
		cntFlag=2 :고객제안
		cntFlag=3 :회원재가입
		cntFlag=6 : 불량광고
		
*************************************************************************************/
CREATE PROC [dbo].[procUserBadAsk]
(
	@CntFlag		    VarChar(2)	
,	@strInUserID		    VARCHAR(20)         
,	@strInUserNm		    VARCHAR(20)         
,	@strInEMail		    VARCHAR(100)         
,	@strInPhone		    VARCHAR(20)         
,	@strInTitle		    VARCHAR(500)         
,	@strBadReadon		    VARCHAR(100)   
,	@strEtc  		     VarChar(1000)  
,	@AdId			    int 
,	@date			   varchar(20)
)
AS
BEGIN
BEGIN  TRANSACTION
	
	
	INSERT	INTO	UsrCnt
	(
	UserID
,	UserNm
,	Email
,	Phone
,	Title
,	CntFlag
,	RegDate
,	AdId
,	BadIns
,	BadReason
,	Etc
,	BadFlag
,	LocalSite
	)
	VALUES
	(
	@strInUserID	
,	@strInUserNm
,	@strInEMail
,	@strInPhone
,	@strInTitle
,	@CntFlag
,	@date
,	@AdId
,	'Used'
,	@strBadReadon
,	@strEtc
,	'0'
,	'0'
	)
END
IF @@ERROR = 0 
	BEGIN
		COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	
END
GO
/****** Object:  StoredProcedure [dbo].[procUserBannerInsert]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 배너광고 문의처리
제작자		: 이지만
제작일		: 2002-04-06
셜명		: 배너광고 문의 처리
		CntFlag	=4	----배너광고 문의	
		
*************************************************************************************/
CREATE PROC [dbo].[procUserBannerInsert]
(
	@strCompanyNm	   VARCHAR(30)
,	@strUserID		  varchar(20)
,	@strPrnLocate	   	  VARCHAR(30)
,	@strUserNm	     	VARCHAR(30)
,	@strPhone	     	VARCHAR(30)
,	@strEMail	     	VARCHAR(50)
,	@date			varchar(20)
,	@strLocal		int
)
AS
BEGIN
BEGIN  TRANSACTION
	
	INSERT	INTO	UsrCnt
	(
	UserNm
,	UserID
,	CompanyNm
,	PrnLocate
,	Phone
,	Email
,	CntFlag
,	RegDate
,	LocalSite
	)
	VALUES
	(
	@strUserNm
,	@strUserID
,	@strCompanyNm	
,	@strPrnLocate
,	@strPhone
,	@strEMail
,	'4'
,	@date
,	@strLocal
	)
	
END
IF @@ERROR = 0 
	BEGIN
		COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	
END
GO
/****** Object:  StoredProcedure [dbo].[procUserMemberAsk]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
설명		: 고객지원-프런트
제작자		: 이지만
제작일		: 2002-04-03
셜명		: 상품등록구입문의/고객제안기타/회원재가입-프런트
		
		cntFlag=1
		
*************************************************************************************/
CREATE PROC [dbo].[procUserMemberAsk]
(
	@CntFlag		    VarChar(2)	
,	@strInQueryType		    VARCHAR(30)         
,	@strInUserNm		    VARCHAR(20)         
,	@strInUserID		    VARCHAR(20)         
,	@strInEMail		    VARCHAR(100)         
,	@strInPhone		    VARCHAR(20)         
,	@strInTitle		    VARCHAR(500)         
,	@strInContents		    VARCHAR(8000)   
,	@strJuminNo  		    VarChar(20)     
,	@strFindAllID		    VarChar(20)
,	@strFindAllPwd		    VarChar(20)	
,	@date			    varchar(20)	
,	@strLocal			    int
)
AS
BEGIN
BEGIN  TRANSACTION
	
	
	INSERT	INTO	UsrCnt
	(
	UserID
,	JuminNo
,	UserNm
,	Email
,	Phone
,	Title
,	Contents
,	RegDate
,	Sended
,	CntFlag
,	QueryType
,	FindUserId
,	FindPwd
,	LocalSite
	)
	VALUES
	(
	@strInUserID	
,	@strJuminNo
,	@strInUserNm
,	@strInEMail
,	@strInPhone
,	@strInTitle
,	@strInContents
,	GETDATE()
,	'0'
,	@CntFlag
,	@strInQueryType
,	@strFindAllID
,	@strFindAllPwd
,	@strLocal
	)
END
IF @@ERROR = 0 
	BEGIN
		COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	
END
GO
/****** Object:  StoredProcedure [dbo].[USERID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:19:47 ******/
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
	UPDATE A SET UserID=@RE_USERID FROM DIRECT_BOARD_TB A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM DIRECT_MEMO_TB A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM EscrowReject A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM GoodsInterest A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM KnowHow A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM KnowHowRe A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM OrderMail A  where CUID=@CUID
	UPDATE A SET SaleUserID=@RE_USERID FROM OrderMail A  where SALE_CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM RecStore A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM RecStoreRequest A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM UsrCnt A  where CUID=@CUID
	UPDATE A SET FindUserId=@RE_USERID FROM UsrCnt A  where FIND_CUID=@CUID
	UPDATE A SET RecID=@RE_USERID FROM SendMessage A  where REC_CUID=@CUID
	UPDATE A SET SendID=@RE_USERID FROM SendMessage A  where SEND_CUID=@CUID
	UPDATE A SET SellerID=@RE_USERID FROM GoodsBargain A  where SELLER_CUID=@CUID
	UPDATE A SET BuyerID=@RE_USERID FROM GoodsBargain A  where BUYER_CUID=@CUID

/*
	INSERT LOGDB.DBO.USERID_CHANGE_HISTORY_TB (B_USERID,N_USERID,DB_NM,USERIP) 
	SELECT @USERID,@RE_USERID,DB_NAME(),@CLIENT_IP
*/	
END
GO
/****** Object:  StoredProcedure [FindUsed].[up_InsertAddress]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [FindUsed].[up_InsertAddress]
	@ID		varchar(20)	= Null
,	@Name		varchar(20)	= Null
,	@Email		varchar(100)	= Null
,	@Age		tinyint		= 0
,	@BirthDay	datetime		= Null
As
Begin
	If @ID Is Null Return -1
	If @Name Is Null Return -2
	If @Age = 0 Return -3
	If @BirthDay Is Null Return -4
	Insert Into Address(
		ID
		, Name
		, Email
		, Age
		, BirthDay
	) values (
		@ID
		, @Name
		, @Email
		, @Age
		, @BirthDay
	)
	Declare @iErr int
	Set @iErr = @@ERROR
	Return @iErr
End
GO
/****** Object:  StoredProcedure [FindUsed].[up_SelectAllAddress]    Script Date: 2021-11-04 오전 10:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [FindUsed].[up_SelectAllAddress]
AS
Begin
	Select * From Address
End
GO
