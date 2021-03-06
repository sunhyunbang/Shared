USE [FINDCONTENTS]
GO
/****** Object:  View [dbo].[_Event]    Script Date: 2021-11-04 오전 10:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[_Event]
As
select top 10 a.*,b.username from PollRespondent a, FindDB2.Common.dbo.UserCommon b Where a.PollNo = 6 AND a.UserID = b.UserID Order By NewId()

GO
/****** Object:  View [dbo].[_kvi_K_Question]    Script Date: 2021-11-04 오전 10:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE   VIEW [dbo].[_kvi_K_Question]
	AS
SELECT Top 500000 A.Adid,
	A.Code1,
	A.Code2,
	CodeNm1 = (Select CodeNm1 From k_Category where Code2 = A.Code2),
	CodeNm2 = (Select CodeNm2 From k_Category where Code2 = A.Code2),
	A.UserID,
	CAST(CONVERT(char(8), A.RegDate, 12) AS int) AS RegDate,
	A.Title,
	A.Content,
	A.ReplyCnt,
	Abs(A.ChoiceSerial) ChoiceSerial
FROM k_Question A with (NoLock)
Order By A.AdId


GO
/****** Object:  View [dbo].[_kvi_K_Question_B]    Script Date: 2021-11-04 오전 10:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*

select * from  dbo.kvi_K_Question_B with(NoLock) 


*/

CREATE    VIEW [dbo].[_kvi_K_Question_B]
	AS
--질문 
SELECT Top 500000 A.Adid,
	'0' AS Gubun, 
	A.Code1,
	A.Code2,
	B.CodeNm1 ,
	B.CodeNm2 ,
	A.UserID,
	CAST(CONVERT(char(8), A.RegDate, 12) AS int) AS RegDate,
	A.Title,
	A.Content,
	A.ReplyCnt,
	Abs(A.ChoiceSerial) ChoiceSerial
FROM k_Question A with (NoLock) , K_Category b With(NoLock) 
Where 
a.code2 = b.code2
AND A.DelFlag='0' 

Union All
--노하우
SELECT  top 500000 a.Adid, 
'1' As Gubun,
b.Code1, 
b.Code2, 
b.CodeNm1, 
b.CodeNm2, 
a.UserID,
CAST(CONVERT(char(8), A.RegDate, 12) AS int) AS RegDate,
a.Title, 
a.Content,
0 As ReplyCnt,
0 As ChoiceSerial

FROM k_Knowhow a With(NoLock) , k_Category b With(NoLock)
Where a.code2 = b.code2
AND A.DelFlag='0' 


Order By RegDate










GO
/****** Object:  View [dbo].[_kvi_K_Question_W]    Script Date: 2021-11-04 오전 10:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE    VIEW [dbo].[_kvi_K_Question_W]
	AS
SELECT A.Adid,
	Gubun =	'0',
	A.Code1,
	A.Code2,
	CodeNm1 = (Select CodeNm1 From k_Category where Code2 = A.Code2),
	CodeNm2 = (Select CodeNm2 From k_Category where Code2 = A.Code2),
	A.UserID,
	CAST(CONVERT(char(8), A.RegDate, 12) AS int) AS RegDate,
	A.Title,
	A.Content,
	A.ReplyCnt,
	Abs(A.ChoiceSerial) ChoiceSerial
FROM k_Question A with (NoLock)
Where A.DelFlag='0' 






GO
/****** Object:  View [dbo].[_vw_MagQueKnow]    Script Date: 2021-11-04 오전 10:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     VIEW
[dbo].[_vw_MagQueKnow]
(Adid, Gubun, Code1, Code2, CodeNm1, CodeNm2, Title, Content, ReplyCnt, ChoiceSerial, ReplyTerm, ReChk, UserID, UserNm, RegDate, viewCnt, DelFlag)
AS

SELECT a.Adid, '질문' As Gubun, b.Code1, b.Code2, b.CodeNm1, b.CodeNm2, a.Title, a.Content,
Convert(VarChar,(Select Count(*) From k_Answer Where queAdid = a.Adid And DelFlag = 0)) As ReplyCnt, a.ChoiceSerial, a.ReplyTerm,
Case When a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.RegDate) > Getdate() Then '신규'
	 When a.ChoiceSerial = 0 And DateAdd(dd,a.ReplyTerm,a.RegDate) < Getdate() Then '미해결'
	When a.ChoiceSerial <> 0 Then '해결' Else '' End as ReChk,
a.UserID, a.UserNm, a.RegDate, a.viewCnt, a.DelFlag
FROM k_Question a, k_Category b
Where a.code2 = b.code2

Union All
SELECT a.Adid, '노하우' As Gubun, b.Code1, b.Code2, b.CodeNm1, b.CodeNm2, a.Title, a.Content,
'-' As ReplyCnt, '' As ChoiceSerial, 0 As ReplyTerm,
'-' As ReChk,
a.UserID, a.UserNm, a.RegDate, a.viewCnt, a.DelFlag
FROM k_Knowhow a, k_Category b
Where a.code2 = b.code2




GO
/****** Object:  View [dbo].[V_KONAN_SEARCH_BOARDPLUS]    Script Date: 2021-11-04 오전 10:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
SELECT  * FROM V_KONAN_SEARCH_BOARDPLUS
*/
CREATE VIEW [dbo].[V_KONAN_SEARCH_BOARDPLUS]
AS
	
	SELECT IDX, TB.CODE, TITLE, TB.DESCRIPTION SUMMARY, CONTENT, dbo.FN_DATE_TO_CHAR12(REG_DATE) AS REGDATE
	, LNAME, MNAME
	, 'http://www.findall.co.kr/New_Event/Life_Detail.asp?IDX='+CAST(TB.IDX AS VARCHAR) URL
	, '' SEARCH_FIELDS, HIST CNT
	, TB.IMG_PATH2
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_ESSAY_TB TB WITH(NOLOCK)
	LEFT JOIN DBO.NESSAYCODE N WITH(NOLOCK) ON N.CODE=TB.CODE 
	WHERE TB.DEL_YN = 'N' AND TB.CODE NOT IN (5018)
	



GO
/****** Object:  View [dbo].[V_KONAN_SEARCH_BOARDPLUS_BAK]    Script Date: 2021-11-04 오전 10:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
SELECT  * FROM V_KONAN_SEARCH_BOARDPLUS
*/
create VIEW [dbo].[V_KONAN_SEARCH_BOARDPLUS_BAK]
AS
SELECT
       TA.SERIAL AS IDX
     , TA.CODE
     , TA.TITLE
     , TA.SUMMARY
     , replace(cast(TA.DESCRIPTION as varchar(MAX)),'&nbsp;','') AS CONTENTS
--     , replace(replace(ltrim(replace(DBO.FN_ClearHTMLTags(cast(TA.DESCRIPTION as varchar(2000))),'&nbsp;','')),char(10),''),char(13),'') AS CONTENTS
     , dbo.FN_DATE_TO_CHAR12(TA.MODDATE) AS REGDATE
     , TB.LName AS LNAME
     , TB.MName AS MNAME
     , 'http://www.findall.co.kr/boardplus/boardView.asp?Serial='+CAST(TA.SERIAL AS VARCHAR)+'&code='+CAST(TA.CODE AS VARCHAR) AS URL
	 , '' AS SEARCH_FIELDS
	 , TA.CNT
	 , '' IMG_PATH2
  FROM DBO.NESSAY TA(NOLOCK)
  LEFT JOIN DBO.NESSAYCODE TB(NOLOCK) ON TA.CODE=TB.CODE
 WHERE TB.DisFlag=1




GO
/****** Object:  View [dbo].[V_KONAN_SEARCH_BOARDPLUS_BAK01]    Script Date: 2021-11-04 오전 10:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
SELECT  * FROM V_KONAN_SEARCH_BOARDPLUS_BAK01
*/
CREATE VIEW [dbo].[V_KONAN_SEARCH_BOARDPLUS_BAK01]
AS
	
	SELECT IDX, TB.CODE, TITLE, TB.DESCRIPTION SUMMARY, CONTENT, REG_DATE REGDATE
	, LNAME, MNAME
	, 'http://www.findall.co.kr/New_Event/Life_Detail.asp?IDX='+CAST(TB.IDX AS VARCHAR) URL
	, '' SEARCH_FIELDS, HIST CNT
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_ESSAY_TB TB WITH(NOLOCK)
	LEFT JOIN DBO.NESSAYCODE N WITH(NOLOCK) ON N.CODE=TB.CODE 
	WHERE TB.DEL_YN = 'N' AND TB.CODE NOT IN (5018)
	
GO
/****** Object:  View [dbo].[V_KONAN_SEARCH_BOARDPLUS_NEW]    Script Date: 2021-11-04 오전 10:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
SELECT  * FROM V_KONAN_SEARCH_BOARDPLUS_NEW
*/
CREATE VIEW [dbo].[V_KONAN_SEARCH_BOARDPLUS_NEW]
AS
	
	SELECT IDX, TB.CODE, TITLE, TB.DESCRIPTION SUMMARY, CONTENT, REG_DATE REGDATE
	, LNAME, MNAME
	, 'http://www.findall.co.kr/New_Event/Life_Detail.asp?IDX='+CAST(TB.IDX AS VARCHAR) URL
	, '' SEARCH_FIELDS, HIST CNT
	, TB.IMG_PATH2
	FROM FINDDB1.PAPER_NEW.DBO.EVENT_ESSAY_TB TB WITH(NOLOCK)
	LEFT JOIN DBO.NESSAYCODE N WITH(NOLOCK) ON N.CODE=TB.CODE 
	WHERE TB.DEL_YN = 'N' AND TB.CODE NOT IN (5018)
	


GO
