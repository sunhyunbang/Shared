USE [USEDMAIN]
GO
/****** Object:  View [dbo].[BuyKeyWd]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BuyKeyWd]
AS
SELECT TOP 10000 B.Code2, B.AdId, A.BrandNmDt, A.BuyAmt AS WishAmt, 'N' AS CardYN, A.UseGbn, 'N' AS EscrowYN,
 B.ZipMain, B.ZipSub, CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.LocalBranch, LEFT(B.OptLocalBranch,2) AS OptLocalBranch, A.BrandNm +','+ A.BrandNmDt AS MergeText
FROM GoodsSubBuy A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted)
WHERE A.AdId = B.AdId
 AND B.StateChk = '1'
 AND B.DelFlag = '0' 
ORDER BY B.AdId DESC

--03/10/22 수정전
--SELECT TOP 10000 B.AdId, A.BrandNmDt, A.BuyAmt AS WishAmt, 'N' AS CardYN, A.UseGbn, 'N' AS EscrowYN, B.ZipMain, B.ZipSub, CONVERT(CHAR(10),B.RegDate,120) AS RegDate, M.MergeText, B.LocalBranch, LEFT(B.OptLocalBranch,2) AS OptLocalBranch
--FROM GoodsSubBuy A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted), GoodsMergeText M WITH (NoLock, ReadUnCommitted)
--WHERE A.AdId = B.AdId AND A.AdId = M.AdId AND B.StateChk = '1' AND B.DelFlag = '0' 
--ORDER BY B.AdId DESC

--03/12/04 수정전
--SELECT TOP 10000 B.AdId, A.BrandNmDt, A.BuyAmt AS WishAmt, 'N' AS CardYN, A.UseGbn, 'N' AS EscrowYN,
--B.ZipMain, B.ZipSub, CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.LocalBranch, LEFT(B.OptLocalBranch,2) AS OptLocalBranch, A.BrandNm +','+ A.BrandNmDt AS MergeText
--FROM GoodsSubBuy A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted)
--WHERE A.AdId = B.AdId
--AND B.StateChk = '1'
--AND B.DelFlag = '0' 
--ORDER BY B.AdId DESC
GO
/****** Object:  View [dbo].[kvi_UsedBuy]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*


select top 10 * from kvi_UsedBuy with(NoLock) 



*/



CREATE VIEW [dbo].[kvi_UsedBuy]
	AS
	SELECT Top 500000  A.AdId,
      	B.AdId AS pk_B_AdId,
			A.Code3, A.Code1 , 
	      	CCNm3 = (Select CAST(CodeNm3 AS varchar(30)) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	      	CCNm = (Select CAST(CodeNm2 AS varchar(30))  + ' ' + cast( CodeNm3 AS varchar(30) ) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	         	A.UserName,
	         	A.ShopName,
	         	A.ZipMain,
	   ZipCate = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '서울'
	   				  WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '제주'
	   				  ELSE '전국'
	   				  END,
		ZipCode = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '0' 
			        WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '8'
			ELSE '9'
			END,
	         	Replace(A.Phone, ',', ' ') AS Phone,
	         	Replace(A.Hphone, ',', ' ') AS HPhone,
				replace(replace(replace(A.Phone,',',' '),'-',''),')','') + Space(1) + replace(replace(replace(A.HPhone,',',' '),'-',''),')','') As PhoneText ,
	         	CONVERT(char(8), A.RegDate, 11) AS RegDate,
			A.ViewCnt,
			A.DelFlag,
			A.StateChk,
			LocalSite = ISNULL(CASE WHEN A.ShowLocalSite <0 OR  A.ShowLocalSite  IS NULL THEN  0 ELSE A.ShowLocalSite  END , 0)     , 
			B.BrandNmDt,
			B.brandNm,
			B.UseGbn,
			B.GoodsQt,
			B.BuyAmt,
			B.Contents,
			B.proCorp
	
	FROM 	UsedMain.dbo.GoodsMain A with (NoLock), UsedMain.dbo.GoodsSubBuy B with (NoLock)
	WHERE	A.Adid = B.Adid
	AND		A.AdGbn = 1
	Order By A.AdId
GO
/****** Object:  View [dbo].[kvi_UsedBuy_B]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*


LocalSite = ISNULL(CASE WHEN A.ShowLocalSite <0 OR  A.ShowLocalSite  IS NULL THEN  0 ELSE A.ShowLocalSite  END , 0)     , 
select  top 10 * from dbo.kvi_UsedBuy_B
*/

CREATE VIEW [dbo].[kvi_UsedBuy_B]
	AS
	SELECT Top 500000  A.AdId,
      	B.AdId AS pk_B_AdId,
			A.Code3, --A.Code1,
	      	CCNm3 = (Select CAST(CodeNm3 AS varchar(30)) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	      	CCNm = (Select CAST(CodeNm2 AS varchar(30))  + ' ' + cast( CodeNm3 AS varchar(30) ) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	         	A.UserName,
	         	A.ShopName,
	         	A.ZipMain,
	   ZipCate = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '서울'
	   				  WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '제주'
	   				  ELSE '전국'
	   				  END,
		ZipCode = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '0' 
			        WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '8'
			ELSE '9'
			END,
	         	Replace(A.Phone, ',', ' ') AS Phone,
	         	Replace(A.Hphone, ',', ' ') AS HPhone,
				replace(replace(replace(A.Phone,',',' '),'-',''),')','') + Space(1) + replace(replace(replace(A.HPhone,',',' '),'-',''),')','') As PhoneText ,
	         	CONVERT(char(8), A.RegDate, 11) AS RegDate,
			A.ViewCnt,
			A.DelFlag,
			A.StateChk,
			LocalSite = ISNULL(CASE WHEN A.ShowLocalSite <0 OR  A.ShowLocalSite  IS NULL THEN  0 ELSE A.ShowLocalSite  END , 0)     , 
			B.BrandNmDt,
			B.brandNm,
			B.UseGbn,
			B.GoodsQt,
			B.BuyAmt,
			B.Contents,
			B.proCorp,
			
			OptYn = CASE WHEN O.Adid is NULL then  0 Else O.OptGbn  END ,
			AllUserID	=	A.UserID ,
			RegEnDate = CASE WHEN A.PrnEnDate > A.RegEnDate THEN CONVERT(char(8), A.PrnEnDate, 11) ELSE CONVERT(char(8), A.RegEnDate, 11) END,
			CUID = A.CUID 
	FROM 	UsedMain.dbo.GoodsMain A with (NoLock), 
			UsedMain.dbo.GoodsSubBuy B with (NoLock),
			GoodsMain_KeyWord_Opt O with (NoLock)
	WHERE	A.Adid = B.Adid
	AND		A.Adid *= O.Adid
	AND		A.AdGbn = 1
	Order By OptYn, A.AdId
GO
/****** Object:  View [dbo].[kvi_UsedBuy_W]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*


select * from dbo.kvi_UsedBuy_W with(NoLock) Where Localsite <> '0'
*/

CREATE VIEW [dbo].[kvi_UsedBuy_W]
	AS
	SELECT A.AdId,
      	B.AdId AS pk_B_AdId,
			A.Code3,A.Code1 , 
	      	CCNm3 = (Select CAST(CodeNm3 AS varchar(30)) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	      	CCNm = (Select CAST(CodeNm2 AS varchar(30))  + ' ' + cast( CodeNm3 AS varchar(30) ) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	         	A.UserName,
	         	A.ShopName,
	         	A.ZipMain,
	   ZipCate = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '서울'
	   				  WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '제주'
	   				  ELSE '전국'
	   				  END,
		ZipCode = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '0' 
			        WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '8'
			ELSE '9'
			END,
	         	Replace(A.Phone, ',', ' ') AS Phone,
	         	Replace(A.Hphone, ',', ' ') AS HPhone,
				replace(replace(replace(A.Phone,',',' '),'-',''),')','') + Space(1) + replace(replace(replace(A.HPhone,',',' '),'-',''),')','') As PhoneText ,
	         	CONVERT(char(8), A.RegDate, 11) AS RegDate,
			A.ViewCnt,
			A.DelFlag,
			A.StateChk,
			LocalSite = ISNULL(CASE WHEN A.ShowLocalSite <0 OR  A.ShowLocalSite  IS NULL THEN  0 ELSE A.ShowLocalSite END , 0)     , 
			B.BrandNmDt,
			B.brandNm,
			B.UseGbn,
			B.GoodsQt,
			B.BuyAmt,
			B.Contents,
			B.proCorp,
			AllUserID	= A.UserID ,
			RegEnDate = CASE WHEN A.PrnEnDate > A.RegEnDate THEN CONVERT(char(8), A.PrnEnDate, 11) ELSE CONVERT(char(8), A.RegEnDate, 11) END,
			CUID = A.CUID 
	FROM 	UsedMain.dbo.GoodsMain A with (NoLock), UsedMain.dbo.GoodsSubBuy B with (NoLock)
	WHERE	A.Adid = B.Adid
	AND		A.AdGbn = 1
GO
/****** Object:  View [dbo].[kvi_UsedSale]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

select top 10 * from kvi_UsedSale with(NoLock) 


*/


CREATE VIEW [dbo].[kvi_UsedSale]
	AS
	SELECT Top 500000 A.AdId,
      	B.AdId AS pk_B_AdId,
			A.Code3, A.Code1, 
	      	CCNm3 = (Select CAST(CodeNm3 AS varchar(30)) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	      	CCNm = (Select CAST(CodeNm2 AS varchar(30))  + ' ' + cast( CodeNm3 AS varchar(30) ) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	         	A.UserName,
	         	A.ShopName,
	         	A.ZipMain,
	   ZipCate = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '서울'
	   				  WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '제주'
	   				  ELSE '전국'
	   				  END,
		ZipCode = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '0'
			        WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '8'
			ELSE '9'
			END,
	         	Replace(A.Phone, ',', ' ') AS Phone,
	         	Replace(A.Hphone, ',', ' ') AS HPhone,
				replace(replace(replace(A.Phone,',',' '),'-',''),')','') + Space(1) + replace(replace(replace(A.HPhone,',',' '),'-',''),')','') As PhoneText ,
	         	CONVERT(char(8), A.RegDate, 11) AS RegDate,
			A.ViewCnt,
			A.EscrowYN,
			A.DelFlag,
			A.SaleOkFlag,
			A.StateChk,
			LocalSite = ISNULL(CASE WHEN A.ShowLocalSite <0 OR  A.ShowLocalSite  IS NULL THEN  0 ELSE A.ShowLocalSite END , 0)     , 
			B.BrandNmDt,
			B.brandNm,
			B.UseYY,
			B.UseMM,
			B.UseGbn,
			ABS(B.WishAmt) AS WishAmt,
			SIGN(B.WishAmt) AS AmtSign,
			B.PicIdx1,
			B.PicIdx2,
			B.Contents
	FROM 	UsedMain.dbo.GoodsMain A with (NoLock), UsedMain.dbo.GoodsSubSale B with (NoLock)
	WHERE	A.Adid = B.Adid
	AND		A.AdGbn = 0
	Order By A.AdId
GO
/****** Object:  View [dbo].[kvi_UsedSale_B]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*


select top 10 * from dbo.kvi_UsedSale_B with(NoLock) 
*/


CREATE VIEW [dbo].[kvi_UsedSale_B]
	AS
	SELECT Top 500000 A.AdId,
      	B.AdId AS pk_B_AdId,
			A.Code3, 
	      	CCNm3 = (Select CAST(CodeNm3 AS varchar(30)) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	      	CCNm = (Select CAST(CodeNm2 AS varchar(30))  + ' ' + cast( CodeNm3 AS varchar(30) ) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	         	A.UserName,
	         	A.ShopName,
	         	A.ZipMain,
	   ZipCate = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '서울'
	   				  WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '제주'
	   				  ELSE '전국'
	   				  END,
		ZipCode = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '0'
			        WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '8'
			ELSE '9'
			END,
	         	Replace(A.Phone, ',', ' ') AS Phone,
	         	Replace(A.Hphone, ',', ' ') AS HPhone,
				replace(replace(replace(A.Phone,',',' '),'-',''),')','') + Space(1) + replace(replace(replace(A.HPhone,',',' '),'-',''),')','') As PhoneText ,
	         	CONVERT(char(8), A.RegDate, 11) AS RegDate,
			A.ViewCnt,
			A.EscrowYN,
			A.DelFlag,
			A.SaleOkFlag,
			A.StateChk,
			LocalSite = ISNULL(CASE WHEN (A.ShowLocalSite <0 OR  A.ShowLocalSite  IS NULL )  THEN  0 ELSE A.ShowLocalSite END , 0)     , 
			B.BrandNmDt,
			B.brandNm,
			B.UseYY,
			B.UseMM,
			B.UseGbn,
			ABS(B.WishAmt) AS WishAmt,
			SIGN(B.WishAmt) AS AmtSign,
			B.PicIdx1,
			B.PicIdx2,
			B.Contents,
			OptYn = 		CASE WHEN O.Adid is NULL then  0 Else  O.OptGbn  END,
			RegAmtOk =	CASE WHEN A.RegAmtOk is NULL Then 0 Else A.RegAmtOk END ,
			AllUserID = A.UserID,
			RegEnDate = CASE WHEN A.PrnEnDate > A.RegEnDate THEN CONVERT(char(8), A.PrnEnDate, 11) ELSE CONVERT(char(8), A.RegEnDate, 11) END,
			CUID = A.CUID 			
	FROM 	UsedMain.dbo.GoodsMain A with (NoLock), UsedMain.dbo.GoodsSubSale B with (NoLock),
			GoodsMain_KeyWord_Opt O with (NoLock)
	WHERE	A.Adid = B.Adid
	AND		A.Adid *= O.Adid
	AND		A.AdGbn = 0

	Order By OptYn, A.AdId
GO
/****** Object:  View [dbo].[kvi_UsedSale_W]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[kvi_UsedSale_W]
	AS
	SELECT A.AdId,
      	B.AdId AS pk_B_AdId,
			A.Code3, A.Code1, 
	      	CCNm3 = (Select CAST(CodeNm3 AS varchar(30)) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	      	CCNm = (Select CAST(CodeNm2 AS varchar(30))  + ' ' + cast( CodeNm3 AS varchar(30) ) From UsedMain.dbo.CatCode C where C.Code3 = A.Code3),
	         	A.UserName,
	         	A.ShopName,
	         	A.ZipMain,
	   ZipCate = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '서울'
	   				  WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '인천/경기'
	   				  WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '부산/경남'
	   				  WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '대구/경북'
	   				  WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '광주/전남'
	   				  WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '전주/전북'
	   				  WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '대전/충청'
	   				  WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '춘천/강원'
	   				  WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '제주'
	   				  ELSE '전국'
	   				  END,
		ZipCode = CASE WHEN CHARINDEX('서울', A.ZipMain) > 0 THEN '0'
			        WHEN CHARINDEX('인천', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('경기', A.ZipMain) > 0 THEN '1'
			        WHEN CHARINDEX('부산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('울산', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('경남', A.ZipMain) > 0 THEN '2'
			        WHEN CHARINDEX('대구', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('경북', A.ZipMain) > 0 THEN '3'
			        WHEN CHARINDEX('광주', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전남', A.ZipMain) > 0 THEN '4'
			        WHEN CHARINDEX('전주', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('전북', A.ZipMain) > 0 THEN '5'
			        WHEN CHARINDEX('대전', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충북', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('충남', A.ZipMain) > 0 THEN '6'
			        WHEN CHARINDEX('춘천', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('강원', A.ZipMain) > 0 THEN '7'
			        WHEN CHARINDEX('제주', A.ZipMain) > 0 THEN '8'
			ELSE '9'
			END,
	         	Replace(A.Phone, ',', ' ') AS Phone,
	         	Replace(A.Hphone, ',', ' ') AS HPhone,
				replace(replace(replace(A.Phone,',',' '),'-',''),')','') + Space(1) + replace(replace(replace(A.HPhone,',',' '),'-',''),')','') As PhoneText ,
	         	CONVERT(char(8), A.RegDate, 11) AS RegDate,
			A.ViewCnt,
			A.EscrowYN,
			A.DelFlag,
			A.SaleOkFlag,
			A.StateChk,
			LocalSite = ISNULL(CASE WHEN (A.ShowLocalSite <0 OR  A.ShowLocalSite  IS NULL )  THEN  0 ELSE A.ShowLocalSite END , 0)     , 
			B.BrandNmDt,
			B.brandNm,
			B.UseYY,
			B.UseMM,
			B.UseGbn,
			ABS(B.WishAmt) AS WishAmt,
			SIGN(B.WishAmt) AS AmtSign,
			B.PicIdx1,
			B.PicIdx2,
			B.Contents,
			RegAmtOk = CASE WHEN A.RegAmtOk is NULL Then 0 Else A.RegAmtOk END ,
			AllUserID =A.UserID ,
			RegEnDate = CASE WHEN A.PrnEnDate > A.RegEnDate THEN CONVERT(char(8), A.PrnEnDate, 11) ELSE CONVERT(char(8), A.RegEnDate, 11) END,
			CUID = A.CUID			
	FROM 	UsedMain.dbo.GoodsMain A with (NoLock), UsedMain.dbo.GoodsSubSale B with (NoLock)
	WHERE	A.Adid = B.Adid
	AND		A.AdGbn = 0
--	AND 	A.RegAmtOk = '1'
GO
/****** Object:  View [dbo].[SaleKeyWd]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SaleKeyWd]
AS

SELECT TOP 10000 B.Code2, B.AdId, A.BrandNmDt, A.WishAmt, A.CardYN, A.UseGbn, B.EscrowYN,
 B.ZipMain, B.ZipSub, CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.LocalBranch, LEFT(B.OptLocalBranch,2) AS OptLocalBranch, A.BrandNm +','+ A.BrandNmDt AS MergeText
FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted)
WHERE A.AdId = B.AdId
 AND B.StateChk = '1'
 AND B.DelFlag = '0' 
 AND B.SaleOkFlag = '0'
ORDER BY B.AdId DESC

--03/10/22 수정전
--SELECT TOP 10000 B.AdId, A.BrandNmDt, A.WishAmt, A.CardYN, A.UseGbn, B.EscrowYN, B.ZipMain, B.ZipSub, CONVERT(CHAR(10),B.RegDate,120) AS RegDate, M.MergeText, B.LocalBranch, LEFT(B.OptLocalBranch,2) AS OptLocalBranch
--FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted), GoodsMergeText M WITH (NoLock, ReadUnCommitted)
--WHERE A.AdId = B.AdId AND A.AdId = M.AdId AND B.StateChk = '1' AND B.DelFlag = '0' AND B.SaleOkFlag = '0'
--ORDER BY B.AdId DESC

--03/12/04 수정전
--SELECT TOP 10000 B.AdId, A.BrandNmDt, A.WishAmt, A.CardYN, A.UseGbn, B.EscrowYN,
--B.ZipMain, B.ZipSub, CONVERT(CHAR(10),B.RegDate,120) AS RegDate, B.LocalBranch, LEFT(B.OptLocalBranch,2) AS OptLocalBranch, A.BrandNm +','+ A.BrandNmDt AS MergeText
--FROM GoodsSubSale A WITH (NoLock, ReadUnCommitted), GoodsMain B WITH (NoLock, ReadUnCommitted)
--WHERE A.AdId = B.AdId
--AND B.StateChk = '1'
--AND B.DelFlag = '0' 
--AND B.SaleOkFlag = '0'
--ORDER BY B.AdId DESC
GO
/****** Object:  View [dbo].[vi_GoodsMain]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vi_GoodsMain]
AS
SELECT 
AdId, Code1, Code2, Code3, OptType, OptList, OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink, OptLocalBranch, PrnStDate, PrnEnDate, PrnCnt, UserID, UserName, ShopName, ZipMain, ZipSub, LocalBranch, Phone, HPhone, Email, Url, IPAddr, DelFlag, StateChk, RegDate, ModDate, DelDate, PrnAmtOk, RegAmtOk, EscrowYN, SpecFlag, PartnerCode, SaleOkFlag, AdGbn, MagGbn, ViewCnt, WooriID, LocalSite, Keyword, BizNum, CUID
--,PLineKeyNo
FROM GoodsMain

UNION ALL

SELECT 
AdId, Code1, Code2, Code3, OptType, OptList, OptPhoto, OptRecom, OptUrgent, OptMain, OptHot, OptPre, OptSync, OptKind, OptLink, OptLocalBranch, PrnStDate, PrnEnDate, PrnCnt, UserID, UserName, ShopName, ZipMain, ZipSub, LocalBranch, Phone, HPhone, Email, Url, IPAddr, DelFlag, StateChk, RegDate, ModDate, DelDate, PrnAmtOk, RegAmtOk, EscrowYN, SpecFlag, PartnerCode, SaleOkFlag, AdGbn, MagGbn, ViewCnt, WooriID, LocalSite, Keyword, BizNum, CUID
--,PLineKeyNo
FROM GoodsMain_Save
GO
/****** Object:  View [dbo].[vi_GoodsSubBuy]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vi_GoodsSubBuy]
AS
SELECT *
FROM GoodsSubBuy

UNION ALL

SELECT *
FROM GoodsSubBuy_Save
GO
/****** Object:  View [dbo].[vi_GoodsSubSale]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vi_GoodsSubSale]
AS
SELECT
AdId, BrandNmDt, BrandNm, ProCorp, BrandState, UseYY, UseMM, UseGbn, GoodsQt, WishAmt, BuyAmt, PicIdx1, PicIdx2, Contents, TagYN, CardYN, SendGbn, Etctext, SendAreaMain, SendAreaSub, SaleSendWay, GoodsSite, SendCharge, ReZipCode, ReAddr1, ReAddr2, RemitBank, RemitAccount, RemitName, Scratch, AfterService, Origin, OriginCountry, LossGoods
FROM GoodsSubSale

UNION ALL

SELECT
AdId, BrandNmDt, BrandNm, ProCorp, BrandState, UseYY, UseMM, UseGbn, GoodsQt, WishAmt, BuyAmt, PicIdx1, PicIdx2, Contents, TagYN, CardYN, SendGbn, Etctext, SendAreaMain, SendAreaSub, SaleSendWay, GoodsSite, SendCharge, ReZipCode, ReAddr1, ReAddr2, RemitBank, RemitAccount, RemitName, Scratch, AfterService, Origin, OriginCountry, LossGoods
FROM GoodsSubSale_Save
GO
/****** Object:  View [dbo].[VI_SEARCH_BUY_GOODS]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 구매물품정보 검색대상데이터
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/07/21
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : SELECT TOP 100 * FROM VI_SEARCH_BUY_GOODS
 *************************************************************************************/

CREATE VIEW [dbo].[VI_SEARCH_BUY_GOODS]

  AS

  SELECT TOP 500000
         M.ADID AS DOCID
         ,M.ADID						-- 물품번호
         ,S.BRANDNMDT					-- 제목
         ,S.BRANDNM					-- 물품명
         --,CONVERT(VARCHAR(8), M.REGDATE, 112) + REPLACE(CONVERT(VARCHAR(8), M.REGDATE, 114),':','') AS REGDATE	-- 등록일
         ,CONVERT(VARCHAR(8), M.REGDATE, 112) AS REGDATE	-- 등록일
         ,S.USEGBN						-- 상품구분 (0: 중고품, 1: 신고품, 2: 신품
         ,M.ZIPMAIN						-- 지역
         ,S.BUYAMT						-- 구매희망가
         ,S.CONTENTS					-- 물품설명
         ,M.CODE1
         ,M.CODE2
         ,M.CODE3
         ,S.DEALAREAMAIN
         ,S.DEALAREASUB
         ,M.PHONE
         ,M.HPHONE
         ,M.LOCALSITE
         ,CASE WHEN M.KEYWORD = '1' THEN 1
               WHEN M.OPTPRE = '1'  THEN 2
               WHEN M.OPTTYPE = '0' THEN 3
               ELSE 3 END AS ORDER_NO
    FROM GOODSMAIN AS M WITH (NOLOCK)
         LEFT JOIN GOODSSUBBUY AS S WITH (NOLOCK) ON S.ADID = M.ADID
   WHERE M.DELFLAG = '0'
     AND M.STATECHK = '1'
     AND S.BUYAMT IS NOT NULL
     AND (M.RegEnDate >= GETDATE() OR M.PrnEnDate >= GETDATE())
--     AND M.REGAMTOK = '1'
   ORDER BY M.ADID DESC
     /*
     AND (CODE1 = '' OR CODE2 = '' OR CODE3='')		-- 분류
     AND BRANDNMDT LIKE '%%'						-- 제목
     AND BRANDNM LIKE '%%'							-- 물품명
     AND USEGBN = '0'								-- 상품구분 (0: 중고품, 1: 신고품, 2: 신품)
     AND GOODSQT = 1								-- 수량
     AND BUYAMT = 10000								-- 구매희망가
     AND CONTENTS LIKE '%%'							-- 물품설명
     AND USERNAME LIKE '%%'							-- 이름
     AND (DEALAREAMAIN = '' OR DEALAREASUB = '')	-- 거래희망지역
     AND (PHONE = '' OR HPHONE = '')				-- 연락처
     AND (ADDR1 LIKE '%%' OR ADDR2 LIKE '%%')		-- 주소
     */
GO
/****** Object:  View [dbo].[VI_SEARCH_SELL_GOODS]    Script Date: 2021-11-04 오전 10:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 판매물품정보 검색대상데이터
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2008/07/21
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : SELECT TOP 100 * FROM VI_SEARCH_SELL_GOODS
 *************************************************************************************/

CREATE VIEW [dbo].[VI_SEARCH_SELL_GOODS]

  AS

  SELECT TOP 500000
          M.ADID AS DOCID
         ,M.ADID				-- 물품번호
         ,P.PICIMAGE			-- 물품이미지
         ,S.BRANDNMDT			-- 제목
         ,S.BRANDNM			-- 물품명
 --        ,CONVERT(VARCHAR(8), M.REGDATE, 112) + REPLACE(CONVERT(VARCHAR(8), M.REGDATE, 114),':','') AS REGDATE	-- 등록일
         ,CONVERT(VARCHAR(8), M.REGDATE, 112)  AS REGDATE		-- 등록일
         ,S.USEGBN							-- 상품구분 (0: 중고품, 1: 신고품, 2: 신품
         ,M.ZIPMAIN							-- 지역
         ,S.USEYY +' '+ S.USEMM AS USEPERIOD			-- 사용기간
         ,S.WISHAMT						-- 판매가격 (-1:무료)
         ,CAST(S.CONTENTS AS VARCHAR(500)) AS CONTENTS						-- 물품설명
         ,S.BRANDSTATE						-- 물품상태
         ,S.SENDGBN 						-- 배송비용
         ,M.PHONE
         ,M.HPHONE
         ,M.LOCALSITE
         ,CASE WHEN M.KEYWORD = '1' THEN 1
               WHEN M.OPTPRE = '1'  THEN 2
               WHEN M.OPTTYPE = '0' THEN 3
               ELSE 3 END AS ORDER_NO
    FROM GOODSMAIN AS M WITH (NOLOCK)
         LEFT JOIN GOODSSUBSALE AS S WITH (NOLOCK) ON S.ADID = M.ADID
         LEFT JOIN GOODSPIC AS P WITH (NOLOCK) ON M.ADID = P.ADID AND PICIDX = 1
   WHERE M.DELFLAG = '0'
     AND M.STATECHK = '1'
     AND S.WISHAMT IS NOT NULL
     AND M.SALEOKFLAG<>'1'
     AND M.REGAMTOK = '1'
     AND (M.REGENDATE >= GETDATE() OR M.PRNENDATE >= GETDATE())
   ORDER BY M.ADID DESC

     /*
     AND BRANDNMDT LIKE '%%'			-- 제목
     AND BRANDNM LIKE '%%'				-- 물품명
     AND USEGBN = '0'					-- 상품구분 (0: 중고품, 1: 신고품, 2: 신품)
     AND GOODSQT = 1					-- 수량
     AND BRANDSTATE = ''				-- 물품상태 (0: 아주좋음, 1: 상태양호, 2: 조금이상)
     AND WISHAMT = 10000				-- 판매가격 (-1 : 무료로 드림) 
     AND SENDGBN = '1'					-- 배송비용 (1: 판매자부담, 2: 구매자부담, 3: 기타, 4: 직거래가능)
     AND CONTENTS LIKE '%%'				-- 물품설명
     AND USERNAME LIKE '%%'				-- 이름
     AND (ZIPMAIN = '' OR ZIPSUB = '')	-- 거래희망지역
     AND (PHONE = '' OR HPHONE = '')	-- 연락처
     AND LOCALSITE = '0'				-- 소재지 (0: 전국, ...)
     */
GO
