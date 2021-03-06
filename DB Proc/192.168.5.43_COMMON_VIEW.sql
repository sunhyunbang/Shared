USE [COMMON]
GO
/****** Object:  View [dbo].[_GET_MAILER_COMMON_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE      VIEW [dbo].[_GET_MAILER_COMMON_VI]
AS

	SELECT 	M.EMAIL,
	       	M.USERNAME,
	       	M.USERID,
	       	M.MEMBER_CD AS UserGbn,
	       	CASE WHEN M.MEMBER_CD = 1 AND LEN(ISNULL(M.JUMINNO,''))=14  THEN
			CASE WHEN SUBSTRING(M.JUMINNO,8,1) ='1' OR SUBSTRING(M.JUMINNO,8,1) ='3' OR SUBSTRING(M.JUMINNO,8,1) ='5' THEN '남'
			ELSE '여' END
		ELSE '' END AS Sex,
		CASE WHEN M.MEMBER_CD = 1 AND LEN(ISNULL(M.JUMINNO,''))=14  THEN
			CASE WHEN SUBSTRING(M.JUMINNO,8,1) IN ('3','4','7','8') THEN YEAR(GETDATE()) - CAST('20' + LEFT(M.JUMINNO,2) AS INT)
			ELSE YEAR(GETDATE()) - CAST('19' + LEFT(JuminNo,2) AS INT) END
		ELSE 0 END AS Age,

		SUM(CASE WHEN A.SECTION_CD = 'S101' THEN 1 ELSE 0 END) AS 'FINDALL', 
		SUM(CASE WHEN A.SECTION_CD = 'S102' THEN 1 ELSE 0 END) AS 'PAPER',     
		SUM(CASE WHEN A.SECTION_CD = 'S103' THEN 1 ELSE 0 END) AS 'FINDJOB', 
		SUM(CASE WHEN A.SECTION_CD = 'S105' THEN 1 ELSE 0 END) AS 'HOUSE',   
		SUM(CASE WHEN A.SECTION_CD = 'S106' THEN 1 ELSE 0 END) AS 'AUTO',   
		SUM(CASE WHEN A.SECTION_CD = 'S107' THEN 1 ELSE 0 END) AS 'USED', 
		SUM(CASE WHEN A.SECTION_CD = 'S108' THEN 1 ELSE 0 END) AS 'LOCAL', 
		SUM(CASE WHEN A.SECTION_CD = 'S109' THEN 1 ELSE 0 END) AS 'GANHOJOB',   
		SUM(CASE WHEN A.SECTION_CD = 'S111' THEN 1 ELSE 0 END) AS 'COCOFUN',   
		SUM(CASE WHEN A.SECTION_CD = 'S112' THEN 1 ELSE 0 END) AS 'M25',   

		A.LOCAL_CD AS CouponLocal,
		M.JOIN_DT AS RegDate
	  FROM 	MEMBER.dbo.MM_MSG_AGREE_TB A 
		LEFT JOIN MEMBER.dbo.MM_MEMBER_TB M ON A.USERID = M.USERID
	 WHERE 	A.SECTION_CD IN ('S101','S102','S103','S105','S106','S107','S108','S109','S111','S112')
	   AND 	M.SECTION_CD IN ('S101','S102','S103','S105','S106','S107','S108','S109','S111','S112')
	   AND  M.REST_YN = 'N' 
 	   AND 	M.BAD_YN ='N'
	   AND 	M.OUT_APPLY_YN ='N' 
	   AND 	M.EMAIL IS NOT NULL 
	   AND 	M.EMAIL <> ''
           AND 	M.EMAIL NOT IN (SELECT EMAIL FROM MM_REJECT_EMAIL_TB WITH(NOLOCK))	
	 GROUP  BY M.EMAIL, M.USERNAME, M.USERID, M.MEMBER_CD, M.JUMINNO, A.LOCAL_CD, M.JOIN_DT

/*
	SELECT 	M.EMAIL,
	       	M.USERNAME,
	       	M.USERID,
	       	M.MEMBER_CD AS UserGbn,
	       	CASE WHEN M.MEMBER_CD = 1 AND LEN(ISNULL(M.JUMINNO,''))=14  THEN
			CASE WHEN SUBSTRING(M.JUMINNO,8,1) ='1' OR SUBSTRING(M.JUMINNO,8,1) ='3' OR SUBSTRING(M.JUMINNO,8,1) ='5' THEN '남'
			ELSE '여' END
		ELSE '' END AS Sex,
		CASE WHEN M.MEMBER_CD = 1 AND LEN(ISNULL(M.JUMINNO,''))=14  THEN
			CASE WHEN SUBSTRING(M.JUMINNO,8,1) IN ('3','4','7','8') THEN YEAR(GETDATE()) - CAST('20' + LEFT(M.JUMINNO,2) AS INT)
			ELSE YEAR(GETDATE()) - CAST('19' + Left(JuminNo,2) AS INT) END
		ELSE 0 END AS Age,

		SUM(CASE WHEN A.SECTION_CD = 'S101' THEN 1 ELSE 0 END) AS 'FINDALL', 
		SUM(CASE WHEN A.SECTION_CD = 'S102' THEN 1 ELSE 0 END) AS 'PAPER',     
		SUM(CASE WHEN A.SECTION_CD = 'S103' THEN 1 ELSE 0 END) AS 'FINDJOB', 
		SUM(CASE WHEN A.SECTION_CD = 'S105' THEN 1 ELSE 0 END) AS 'HOUSE',   
		SUM(CASE WHEN A.SECTION_CD = 'S106' THEN 1 ELSE 0 END) AS 'AUTO',   
		SUM(CASE WHEN A.SECTION_CD = 'S107' THEN 1 ELSE 0 END) AS 'USED', 
		SUM(CASE WHEN A.SECTION_CD = 'S108' THEN 1 ELSE 0 END) AS 'LOCAL', 
		SUM(CASE WHEN A.SECTION_CD = 'S109' THEN 1 ELSE 0 END) AS 'GANHOJOB',   
		SUM(CASE WHEN A.SECTION_CD = 'S111' THEN 1 ELSE 0 END) AS 'COCOFUN',   
		SUM(CASE WHEN A.SECTION_CD = 'S112' THEN 1 ELSE 0 END) AS 'M25',   

		A.LOCAL_CD AS CouponLocal,
		ISNULL(B.SchoolGbn,'') AS SchoolGbn,
		M.JOIN_DT AS RegDate
	  FROM 	MEMBER.dbo.MM_MSG_AGREE_TB A 
		LEFT JOIN MEMBER.dbo.MM_MEMBER_TB M ON A.USERID = M.USERID
		LEFT JOIN (		
				SELECT 	UserID, ISNULL(SchoolGbn,'') AS SchoolGbn
				  FROM 	FINDDB4.JobMain.dbo.Resume C,
					(SELECT Max(Adid) AS Adid  FROM FINDDB4.JobMain.dbo.Resume WHERE RecProxyGbn = 0 GROUP BY UserID) D
				 WHERE 	C.Adid=D.Adid
		) B ON A.UserID = B.UserID
	 WHERE 	A.SECTION_CD IN ('S101','S102','S103','S105','S106','S107','S108','S109','S111','S112')
	   AND 	M.SECTION_CD IN ('S101','S102','S103','S105','S106','S107','S108','S109','S111','S112')
	   AND 	M.OUT_APPLY_YN ='N' 
	   AND 	M.EMAIL IS NOT NULL 
	   AND 	M.EMAIL <> ''
           AND 	M.EMAIL NOT IN (SELECT EMAIL FROM MM_REJECT_EMAIL_TB WITH(NOLOCK))	
	 GROUP  BY M.EMAIL, M.USERNAME, M.USERID, M.MEMBER_CD, M.JUMINNO, A.LOCAL_CD, B.SchoolGbn, M.JOIN_DT
*/




GO
/****** Object:  View [dbo].[_GET_MEMBER_INFOMAIL_M25_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	VIEW [dbo].[_GET_MEMBER_INFOMAIL_M25_VI]
AS
	
SELECT
	Email,
	UserName,
	UserGbn, 
	LEFT(regdate,4) + '년 ' + SUBSTRING(RegDate,6,2) +'월 ' +Right(RegDate,2) +'일' AS RegDate,
	CASE WHEN CHARINDEX('event',MailKind) > 0 OR CHARINDEX('m25',MailKind) > 0 THEN 1 ELSE 0 END AS M25_Event,
	CASE WHEN CHARINDEX('m25',MailKind) > 0 THEN 1 ELSE 0 END AS M25,
	CASE WHEN CHARINDEX('event',MailKind) > 0 THEN 1 ELSE 0 END AS EVENT,
	CouponLocal,
	CASE WHEN UserGbn = 1 AND LEN(ISNULL(JuMinNo,''))=14  THEN
		CASE WHEN SubString(JuminNo,8,1) IN ('3','4','7','8') THEN YEAR(GETDATE()) - CAST('20' + Left(JuminNo,2) AS INT)
		ELSE YEAR(GETDATE()) - CAST('19' + Left(JuminNo,2) AS INT) END
	ELSE 0 END AS Age
FROM 
	UserCommon with(NoLock) 
WHERE
	Email <> '' AND
	(CHARINDEX('m25',MailKind) > 0 OR CHARINDEX('event',MailKind) > 0)

GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_ALL_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	VIEW [dbo].[_GET_MM_MEMBER_ALL_VI]
AS

	SELECT DISTINCT EMAIL,
		   USERNAME,
		   USERID,
		   INSCHANNEL
	  FROM UserCommon WITH(NOLOCK)
     WHERE DelFlag <> '1' 
       AND PartnerGbn = '0' 
       AND Email IS NOT NULL 
       AND Email <> ''
	   AND Email <> 'dhkim@hyunwoostar.com'


GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_COCOFUN_MEDIAWILL_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      VIEW [dbo].[_GET_MM_MEMBER_COCOFUN_MEDIAWILL_VI]
AS
	SELECT DISTINCT B.EMAIL,
		B.USERNAME,
		B.USERID,
		CASE A.LOCAL_CD
			WHEN 1 THEN '서울'
			WHEN 7 THEN '인천 경기'
			WHEN 2 THEN '부산 경남'
			WHEN 6 THEN '대구 경북'
			ELSE '그 외'
		END AS LOCAL_CD,
		CASE WHEN B.GENDER = 'M' THEN '남'
			WHEN B.GENDER = 'F' THEN '여'
			ELSE '' 
		END AS SEX,
		CONVERT(CHAR(10),A.AGREE_DT,120) AS AGREE_DT
	 FROM MEMBER.dbo.MM_MSG_AGREE_TB A  WITH(NOLOCK)
		LEFT JOIN MEMBER.dbo.MM_MEMBER_TB B  WITH(NOLOCK) ON A.USERID = B.USERID
	WHERE A.SECTION_CD = 'S111'
		AND B.SECTION_CD = 'S111'
		AND B.REST_YN = 'N' 
		AND B.BAD_YN ='N' 
		AND B.OUT_APPLY_YN ='N' 
		AND B.EMAIL IS NOT NULL 
		AND B.EMAIL <> ''
		AND B.EMAIL NOT IN (SELECT EMAIL FROM MM_REJECT_EMAIL_TB WITH(NOLOCK))




GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_COCOFUN_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      VIEW [dbo].[_GET_MM_MEMBER_COCOFUN_VI]
AS
/*
	SELECT 	DISTINCT B.EMAIL,
	       	B.USERNAME,
	       	B.USERID,
	       	CASE A.LOCAL_CD
			WHEN 1 THEN '서울'
			WHEN 7 THEN '인천 경기'
			WHEN 2 THEN '부산 경남'
			WHEN 6 THEN '대구 경북'
			ELSE '그 외'
		END AS LOCAL_CD,
		CASE WHEN B.MEMBER_CD = 1 AND LEN(ISNULL(B.JUMINNO,''))=14  THEN
			CASE WHEN SUBSTRING(B.JUMINNO,8,1) ='1' OR SUBSTRING(B.JUMINNO,8,1) ='3' OR SUBSTRING(B.JUMINNO,8,1) ='5' THEN '남'
			ELSE '여' END
		ELSE '' END AS SEX,
		CONVERT(CHAR(10),A.AGREE_DT,120) AS AGREE_DT
	  FROM 	MEMBER.dbo.MM_MSG_AGREE_TB A  WITH(NOLOCK)
		LEFT JOIN MEMBER.dbo.MM_MEMBER_TB B  WITH(NOLOCK) ON A.USERID = B.USERID
         WHERE 	A.SECTION_CD = 'S111'
	   AND  B.SECTION_CD = 'S111'
	   AND B.REST_YN = 'N' 
 	   AND 	B.BAD_YN ='N' 
	   AND 	B.OUT_APPLY_YN ='N' 
       	   AND 	B.EMAIL IS NOT NULL 
	   AND 	B.EMAIL <> ''
	   AND 	B.EMAIL NOT IN (SELECT EMAIL FROM MM_REJECT_EMAIL_TB WITH(NOLOCK))
*/

	SELECT DISTINCT B.EMAIL,
		B.USERNAME,
		B.USERID,
		CASE A.LOCAL_CD
			WHEN 1 THEN '서울'
			WHEN 7 THEN '인천 경기'
			WHEN 2 THEN '부산 경남'
			WHEN 6 THEN '대구 경북'
			ELSE '그 외'
		END AS LOCAL_CD,
		CASE WHEN B.GENDER = 'M' THEN '남'
			WHEN B.GENDER = 'F' THEN '여'
			ELSE '' 
		END AS SEX,
		CONVERT(CHAR(10),A.AGREE_DT,120) AS AGREE_DT
	 FROM MEMBER.dbo.MM_MSG_AGREE_TB A  WITH(NOLOCK)
		LEFT JOIN MEMBER.dbo.MM_MEMBER_TB B  WITH(NOLOCK) ON A.USERID = B.USERID
	WHERE A.SECTION_CD = 'S111' AND B.SECTION_CD = 'S111'
		AND B.REST_YN = 'N' 
		AND B.BAD_YN ='N' 
		AND B.OUT_APPLY_YN ='N' 
		AND B.EMAIL IS NOT NULL 
		AND B.EMAIL <> ''
		AND B.EMAIL NOT IN (SELECT EMAIL FROM MM_REJECT_EMAIL_TB WITH(NOLOCK))



GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_COMPANY_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE     VIEW [dbo].[_GET_MM_MEMBER_COMPANY_VI]
AS

SELECT 	 U.USERID
	,U.PASSWORD
	,U.USERGBN
	,U.USERNAME
	,U.JUMINNO
	,U.EMAIL
	,U.URL
	,U.PHONE
	,U.HPHONE
	,U.POST1
	,U.POST2
	,U.CITY
	,U.ADDRESS1
	,U.ADDRESS2
	,U.REGDATE
	,U.MODDATE
	,U.DELDATE
	,U.VISITDAY
	,U.VISITCNT
	,U.IPADDR
	,U.DELFLAG
	,U.INSCHANNEL
	,U.INSCHANNEL2
	,U.DELCHANNEL
	,U.BADFLAG
	,U.BADSITE
	,U.BADREASON
	,U.BADETC
	,U.BADDATE
	,U.INSLOCALSITE
	,U.DELLOCALSITE
	,U.ADDRESSBUNJI
	,U.LOGINTIME
	,U.LOGINSITE
	,U.EMAILFLAG
	,U.SMSFLAG
	,U.COUPONLOCAL
	,U.MAILKIND         
	,B.BUSERGBN    
	,B.ONESNAME    
	,B.CAPITAL     
	,B.SELLINGPRICE
	,B.STAFF       
	,B.PRESIDENT   
	,B.BIZTYPE     
	,B.WELFAREPGM  
	,B.CONTENTS    
	,B.DELREASON   
	,B.DELETC      
	,B.FAXNO       
	,B.FOUNDYEAR   
	,B.LISTSTOCKS  
	,B.LEADBIZSUB  
	,B.PAYSYSTEM   
	,B.SUBWAYAREA  
	,B.DETAILLOCATE
	,B.VIEWCNT     
	,B.INJAEFLAG   
	,B.INJAEDATE   
	,B.BIZCODE1    
	,B.BIZCODE2    
	,B.BIZCODE3    
  FROM	COMMON.DBO.USERCOMMON U WITH(NOLOCK)
	LEFT OUTER JOIN COMMON.DBO.USERJOBCOMPANY B WITH(NOLOCK)	ON U.USERID = B.USERID

 




GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_GANHOJOB_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    VIEW [dbo].[_GET_MM_MEMBER_GANHOJOB_VI]
AS
	SELECT 	DISTINCT B.EMAIL,
	       	B.USERNAME,
	       	B.USERID,
	       	B.MEMBER_CD AS USERGBN,
	       	CASE WHEN B.MEMBER_CD = 1 AND LEN(ISNULL(B.JUMINNO,''))=14  THEN
			CASE WHEN SUBSTRING(B.JUMINNO,8,1) ='1' OR SUBSTRING(B.JUMINNO,8,1) ='3' OR SUBSTRING(B.JUMINNO,8,1) ='5' THEN '남'
			ELSE '여' END
		ELSE '' END AS SEX,
		CASE WHEN B.MEMBER_CD = 1 AND LEN(ISNULL(B.JUMINNO,''))=14  THEN
			CASE WHEN SUBSTRING(B.JUMINNO,8,1) IN ('3','4','7','8') THEN YEAR(GETDATE()) - CAST('20' + LEFT(B.JUMINNO,2) AS INT)
			ELSE YEAR(GETDATE()) - CAST('19' + LEFT(B.JUMINNO,2) AS INT) END
		ELSE 0 END AS AGE
	  FROM 	MEMBER.dbo.MM_MSG_AGREE_TB A  WITH(NOLOCK)
		LEFT JOIN MEMBER.dbo.MM_MEMBER_TB B  WITH(NOLOCK) ON A.USERID = B.USERID
         WHERE 	A.SECTION_CD = 'S109'
	   AND  B.SECTION_CD = 'S109'
	   AND B.REST_YN = 'N' 
 	   AND 	B.BAD_YN ='N' 
	   AND 	B.OUT_APPLY_YN ='N' 
       	   AND 	B.EMAIL IS NOT NULL 
	   AND 	B.EMAIL <> ''
	   AND 	B.EMAIL NOT IN (SELECT EMAIL FROM MM_REJECT_EMAIL_TB WITH(NOLOCK))


GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_JOB_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE     VIEW [dbo].[_GET_MM_MEMBER_JOB_VI]
AS
	SELECT 	DISTINCT B.EMAIL,
	       	B.USERNAME,
	       	B.USERID,
	       	B.MEMBER_CD AS USERGBN,
	       	CASE WHEN B.MEMBER_CD = 1 AND LEN(ISNULL(B.JUMINNO,''))=14  THEN
			CASE WHEN SUBSTRING(B.JUMINNO,8,1) ='1' OR SUBSTRING(B.JUMINNO,8,1) ='3' OR SUBSTRING(B.JUMINNO,8,1) ='5' THEN '남'
			ELSE '여' END
		ELSE '' END AS SEX,
		CASE WHEN B.MEMBER_CD = 1 AND LEN(ISNULL(B.JUMINNO,''))=14  THEN
			CASE WHEN SUBSTRING(B.JUMINNO,8,1) IN ('3','4','7','8') THEN YEAR(GETDATE()) - CAST('20' + LEFT(B.JUMINNO,2) AS INT)
			ELSE YEAR(GETDATE()) - CAST('19' + LEFT(B.JUMINNO,2) AS INT) END
		ELSE 0 END AS AGE
	  FROM 	MEMBER.dbo.MM_MSG_AGREE_TB A WITH(NOLOCK)
		LEFT JOIN MEMBER.dbo.MM_MEMBER_TB B WITH(NOLOCK) ON A.USERID = B.USERID
         WHERE 	A.SECTION_CD = 'S103'
	   AND  B.SECTION_CD = 'S103'
	   AND B.REST_YN = 'N' 
 	   AND 	B.BAD_YN ='N'
	   AND 	B.OUT_APPLY_YN ='N' 
       	   AND 	B.EMAIL IS NOT NULL 
	   AND 	B.EMAIL <> ''
	   AND 	B.EMAIL NOT IN (SELECT EMAIL FROM MM_REJECT_EMAIL_TB WITH(NOLOCK))


GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_LIST_REF_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 병원검색결과
 *  작   성   자 : 김지연
 *  작   성   일 : 2008.01.09
 *  수   정   자 : 
 *  수   정   일 : 
 *  설         명 : 간호잡 > 간호자료실 > 병원정보검색하기
 *  주 의  사 항 : 참조 프로시져 [간호잡].ganhojob.dbo.MM_MEMBER_HOSPITAL_LIST_PROC
 *  사 용  소 스 : /job_pds/phtoinfo_list.asp
 *************************************************************************************/
CREATE VIEW [dbo].[_GET_MM_MEMBER_LIST_REF_VI] AS
SELECT 
	t1.UserId, 	--회원ID
	t1.UserName,	--병원명
	t1.Url, 	--홈페이지
	t1.Phone,	--연락처
	t1.HPhone,	--핸드폰
	t1.Address1,	--주소
	t2.COMP_KIND_CD,	--병원구분
	t2.MAJOR_CD,		--전공
	t1.RegDate
FROM dbo.UserCommon 		t1 with (NoLock) 
	INNER JOIN dbo.UserJobCompany 	t2 with (NoLock) 
	ON t1.UserID = t2.UserID
WHERE
	t2.UserID <> '' 
	AND  t1.USerGbn =2  --구분코드(1:일반 2:기업 3:딜러 4:관리자대행)
	AND t2.BizType <>'' AND t2.BizCode1 <>''
	AND t2.ListStocks <>'' AND t2.WelfarePgm <> ''  AND charindex(',' ,t2.ListStocks) =0
	AND t2.COMP_KIND_CD <> '' AND t2.MAJOR_CD <>''



GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_M25_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE        VIEW [dbo].[_GET_MM_MEMBER_M25_VI]
AS
	SELECT B.EMAIL,
	       B.USERNAME,
	       B.USERID
	  FROM MEMBER.dbo.MM_MSG_AGREE_TB A LEFT JOIN MEMBER.dbo.MM_MEMBER_TB B ON A.USERID = B.USERID
         WHERE A.SECTION_CD = 'S112'
	   AND B.SECTION_CD = 'S112'
	   AND B.REST_YN = 'N' 
 	   AND B.BAD_YN ='N'
	   AND B.OUT_APPLY_YN ='N' 
       	   AND B.EMAIL IS NOT NULL 
	   AND B.EMAIL <> ''
	   AND B.EMAIL NOT IN (SELECT EMAIL FROM MM_REJECT_EMAIL_TB WITH(NOLOCK))


GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_OUT_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE      VIEW [dbo].[_GET_MM_MEMBER_OUT_VI]
AS

SELECT 	 SERIAL
	,USERID
	,DEL_ID
	,REGDATE
	,DELDATE
	,INSCHANNEL
	,DELCHANNEL
	,DELAGE
	,DELREASON
	,DELETC
  FROM	DBO.USERALLPERSON_DEL U WITH(NOLOCK) 



GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_PERSON_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE     VIEW [dbo].[_GET_MM_MEMBER_PERSON_VI]
AS

SELECT 	 U.USERID
	,U.PASSWORD
	,U.USERGBN
	,U.USERNAME
	,U.JUMINNO
	,U.EMAIL
	,U.URL
	,U.PHONE
	,U.HPHONE
	,U.POST1
	,U.POST2
	,U.CITY
	,U.ADDRESS1
	,U.ADDRESS2
	,U.REGDATE
	,U.MODDATE
	,U.DELDATE
	,U.VISITDAY
	,U.VISITCNT
	,U.IPADDR
	,U.DELFLAG
	,U.INSCHANNEL
	,U.INSCHANNEL2
	,U.DELCHANNEL
	,U.BADFLAG
	,U.BADSITE
	,U.BADREASON
	,U.BADETC
	,U.BADDATE
	,U.INSLOCALSITE
	,U.DELLOCALSITE
	,U.ADDRESSBUNJI
	,U.LOGINTIME
	,U.LOGINSITE
	,U.EMAILFLAG
	,U.SMSFLAG
	,U.COUPONLOCAL
	,U.MAILKIND         
  FROM	COMMON.DBO.USERCOMMON U WITH(NOLOCK)
	LEFT OUTER JOIN COMMON.DBO.USERJOBCOMPANY B WITH(NOLOCK)	ON U.USERID = B.USERID

 




GO
/****** Object:  View [dbo].[_GET_MM_MEMBER_TENNIS_EMAIL_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE      VIEW [dbo].[_GET_MM_MEMBER_TENNIS_EMAIL_VI]
AS
	SELECT	DISTINCT *
	FROM	(
			SELECT	DISTINCT 
					LTRIM(RTRIM(B.EMAIL)) AS EMAIL,
					B.USERNAME,
					B.USERID,
					CONVERT(CHAR(10),A.AGREE_DT,120) AS AGREE_DT
			FROM	MEMBER.dbo.MM_MSG_AGREE_TB A  WITH(NOLOCK)
					LEFT JOIN MEMBER.dbo.MM_MEMBER_TB B  WITH(NOLOCK) ON A.USERID = B.USERID
			WHERE	A.SECTION_CD = 'S117'
					AND B.SECTION_CD = 'S117'
					AND B.REST_YN = 'N' 
					AND B.BAD_YN ='N' 
					AND B.OUT_APPLY_YN ='N' 
					AND B.EMAIL IS NOT NULL 
					AND B.EMAIL <> ''					
					AND (CHARINDEX(' ',LTRIM(RTRIM(EMAIL))) = 0
					AND LEFT(LTRIM(EMAIL),1) <> '@'
					AND RIGHT(RTRIM(EMAIL),1) <> '.'
					AND CHARINDEX('.',EMAIL,CHARINDEX('@',EMAIL)) - CHARINDEX('@',EMAIL) > 1 
					AND LEN(LTRIM(RTRIM(EMAIL))) - LEN(REPLACE(LTRIM(RTRIM(EMAIL)),'@','')) = 1
					AND CHARINDEX('.',REVERSE(LTRIM(RTRIM(EMAIL)))) >= 3
					AND (CHARINDEX('.@',EMAIL) = 0 AND CHARINDEX('..',EMAIL) = 0))
					AND B.EMAIL NOT IN (SELECT EMAIL FROM MM_REJECT_EMAIL_TB WITH(NOLOCK))
					
			UNION
			
			SELECT	LTRIM(RTRIM(EMAIL)) AS EMAIL, USER_NAME AS USERNAME, USER_ID AS USERID, CONVERT(CHAR(10),REG_DATE,120) AS AGREE_DT
			FROM	MEMBER.dbo.USER_INFO
			WHERE	EMAIL_YN = 'Y'
					AND EMAIL IS NOT NULL 
					AND EMAIL <> ''
					AND (CHARINDEX(' ',LTRIM(RTRIM(EMAIL))) = 0
					AND LEFT(LTRIM(EMAIL),1) <> '@'
					AND RIGHT(RTRIM(EMAIL),1) <> '.'
					AND CHARINDEX('.',EMAIL,CHARINDEX('@',EMAIL)) - CHARINDEX('@',EMAIL) > 1 
					AND LEN(LTRIM(RTRIM(EMAIL))) - LEN(REPLACE(LTRIM(RTRIM(EMAIL)),'@','')) = 1
					AND CHARINDEX('.',REVERSE(LTRIM(RTRIM(EMAIL)))) >= 3
					AND (CHARINDEX('.@',EMAIL) = 0 AND CHARINDEX('..',EMAIL) = 0))
			) X
GO
/****** Object:  View [dbo].[_vi_selectUserM25]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_vi_selectUserM25]
AS
SELECT   UserID, UserName, InsChannel, Email, emailFlag, smsFlag, MailKind, 
                RegDate
FROM      dbo.UserCommon
GO
/****** Object:  View [dbo].[_VI_USER]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE                      VIEW [dbo].[_VI_USER]
AS
	SELECT USERID, ADDRESS1, ADDRESS2, ADDRESSBUNJI AS ADDRESS3, '' AS MAP_X, '' AS MAP_Y, '' AS MAP_CODE
	FROM FINDDB2.COMMON.DBO.USERCOMMON WHERE USERGBN='2'
	AND address2 NOT IN(
	'1',
	'-',
	'0',
	'00',
	'000', 
	'0000',
	'00000',
	'0-0',
	'2', 
	'--',
	'-00',
	'..',
	'....',
	'o')
	AND addressbunji NOT IN(
	'-',
	'0',
	'00',
	'000',
	'0000',
	'00000',
	'0-0',
	'--')

GO
/****** Object:  View [dbo].[_vi_UserClickMind]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE        VIEW [dbo].[_vi_UserClickMind]
As
Select UserID As USERID, DelFlag As ALIVE_FG, 
	Case When UserGbn = 2 Then 'T'
		Else 
			Case When Substring(JuminNo,8,1) = '1' Then 'M'
						When Substring(JuminNo,8,1) = '2' Then 'F'
			Else 'T' End
		End As SEX,
	BIZ = IsNull((Select BizCode2 From UserJobCompany Where UserID = A.UserID),''),
	Case When UserGbn <> '2' AND Len(JuminNo) = 14 Then 
			Case When DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2))  < '10' Then '10'
						When  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) >= '10' And  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) < '20'  Then '11'
						When  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) >= '20' And  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) < '30'  Then '12'
						When  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) >= '30' And  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) < '40'  Then '13'
						When  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) >= '40' And  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) < '50'  Then '14'
						When  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) >= '50' And  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) < '60'  Then '15'
						When  DATEPART(YY,GETDATE()) - (1899 + Left(JuminNo,2)) >= '60'   Then '16'
			Else '99' End
	Else '' End As AGE,
	Case When Left(Address1,2) = '서울' Then '10'
				When Left(Address1,2) = '부산' Then '11'
				When Left(Address1,2) = '대구' Then '12'
				When Left(Address1,2) = '인천' Then '13'
				When Left(Address1,2) = '대전' Then '14'
				When Left(Address1,2) = '울산' Then '15'
				When Left(Address1,2) = '광주' Then '16'
				When Left(Address1,2) = '경기' Then '17'
				When Left(Address1,2) = '강원' Then '18'
				When Left(Address1,2) = '경남' Then '19'
				When Left(Address1,2) = '경북' Then '20'
				When Left(Address1,2) = '충남' Then '21'
				When Left(Address1,2) = '충북' Then '22'
				When Left(Address1,2) = '전남' Then '23'
				When Left(Address1,2) = '전북' Then '24'
				When Left(Address1,2) = '제주' Then '25'
	Else '99' End As LOCAL,
	Case When UserGbn <> '2' AND  IsNumeric(Left(JuminNo,6)) = 1 Then Left(JuminNo,6)	Else '' End As BIRTHDAY,
	Convert(varchar(10),Convert(smalldatetime,RegDate),112) As REG_DT
FROM UserCommon A with(Nolock)


--Select top 10 * From dbo.vi_UserClickMind





GO
/****** Object:  View [dbo].[_vi_UserCommon]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[_vi_UserCommon]
AS
SELECT UserID FROM UserCommon WHERE  PartnerGbn = 0 

GO
/****** Object:  View [dbo].[_vi_UserCommon_Mail]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE         VIEW [dbo].[_vi_UserCommon_Mail]
AS

SELECT
	A.UserID, 
	UserName, 
	Email, 
	UserGbn, 
	CASE WHEN UserGbn = 1 AND LEN(ISNULL(JuMinNo,''))=14  THEN
		CASE WHEN SubString(JuminNo,8,1) ='1' Or SubString(JuminNo,8,1) ='3' Or SubString(JuminNo,8,1) ='5' THEN '남'
		ELSE '여' END
	ELSE '' END AS Sex,
	CASE WHEN CHARINDEX('job',MailKind) > 0 Or CHARINDEX('alba',MailKind) > 0 THEN 0 ELSE 1 END AS Letter_JobAlba,
	CASE WHEN CHARINDEX('house',MailKind) > 0 THEN 1 ELSE 0 END AS Letter_House,
	CASE WHEN CHARINDEX('auto',MailKind) > 0 THEN 1 ELSE 0 END AS Letter_Auto,
	CASE WHEN CHARINDEX('event',MailKind) > 0 THEN 1 ELSE 0 END AS Letter_Event,
	CASE WHEN CHARINDEX('coupon',MailKind) > 0 THEN 1 ELSE 0 END AS Letter_Coupon,
	CASE WHEN CHARINDEX('m25',MailKind) > 0 THEN 1 ELSE 0 END AS Letter_M25,
	CASE WHEN UserGbn = 1 AND LEN(ISNULL(JuMinNo,''))=14  THEN
		CASE WHEN SubString(JuminNo,8,1) IN ('3','4','7','8') THEN YEAR(GETDATE()) - CAST('20' + Left(JuminNo,2) AS INT)
		ELSE YEAR(GETDATE()) - CAST('19' + Left(JuminNo,2) AS INT) END
	ELSE 0 END AS Age,
	CouponLocal,
	SchoolGbn,
	RegDate
FROM 
	UserCommon A with(NoLock) 
	LEFT OUTER JOIN (
						SELECT 
							UserID, ISNULL(SchoolGbn,'') AS SchoolGbn
						FROM
							FindDB4.JobMain.dbo.Resume C,
							(SELECT Max(Adid) AS Adid  FROM FindDB4.JobMain.dbo.Resume WHERE RecProxyGbn = 0 GROUP BY UserID) D
						WHERE 
							C.Adid=D.Adid
					) B ON A.UserID = B.UserID
WHERE
	Email <> '' AND MailKind IS NOT NULL AND MailKind <> ''








GO
/****** Object:  View [dbo].[GET_MM_CONFIRM_SENDMAIL_REST_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[GET_MM_CONFIRM_SENDMAIL_REST_VI]
AS 

	SELECT USERID
	   ,MEMBER_CD
	   ,USERNAME
	   ,EMAIL
	   ,ISNULL(SECTION_CD,'S101') AS SECTION_CD
	   ,CONVERT(VARCHAR(10),JOIN_DT,120) AS JOIN_DT
	   ,CONVERT(VARCHAR(10),LOGIN_DT,120) AS LOGIN_DT
	   ,CONVERT(VARCHAR(10),INSERT_DT,120) AS INSERT_DT
  FROM MM_REST_CONFIRM_TB
 WHERE Email <> ''
   AND Email <> 'dhkim@hyunwoostar.com'
   AND DBO.GET_MM_RIGHTEMAIL_FNC(Email) = 'OK'

GO
/****** Object:  View [dbo].[GET_MM_LONGTERM_UNUSED_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 통합회원 > 장기미이용 회원 메일 발송 목록 추출 뷰
' 작    성    자	: 최 병 찬
' 작    성    일	: 2013/1/17
' 수    정    자	:
' 수    정    일	: 
' 설          명	: 2년 동안 로그인 하지 않은 회원 1달전에 메일 발송(2년이 되는날 탈퇴 처리해야함)
'					  당일 발송 목록 View
' 주  의  사  항	: 
' 사  용  소  스 	: 스케줄 작업 
' 예          제	: 
******************************************************************************/
CREATE VIEW [dbo].[GET_MM_LONGTERM_UNUSED_VI]
AS
SELECT 
       USERID
     , USERNAME
     , EMAIL
     , REPLACE(CONVERT(VARCHAR(10), JOIN_DT, 111), '/', '.') AS JOIN_DT
     , REPLACE(CONVERT(VARCHAR(10), LOGIN_DT, 111), '/', '.') AS LOGIN_DT
     , REPLACE(CONVERT(VARCHAR(10), REST_DT, 111), '/', '.') AS REST_DT
     , REPLACE(CONVERT(VARCHAR(10), OUT_DT, 111), '/', '.') AS OUT_DT
  FROM MM_LONGTERM_UNUSED_TB WITH (NOLOCK)
 WHERE CONVERT(VARCHAR(10), REG_DT, 111) = CONVERT(VARCHAR(10), GETDATE(), 111)
-- WHERE EMAIL in ('sigolkil@mediawill.com','sebilia@mediawill.com','sebilia@naver.com')
   AND EMAIL<>''
GO
/****** Object:  View [dbo].[GET_MM_MARKETING_EVENT_MEMBER_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 마케팅/이벤트 수신동의 이메일 발송(2년에 한번)
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016-11-15
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  예        제 :  SELECT CUID, USERID, EMAIL, USER_NM, AGREE_DT, FA_SMS, FA_TM, FA_EMAIL, SERVE_SMS, SERVE_TM, SERVE_MAIL FROM GET_MM_MARKETING_EVENT_MEMBER_VI
 *************************************************************************************/
CREATE VIEW [dbo].[GET_MM_MARKETING_EVENT_MEMBER_VI]
AS

SELECT CUID, USERID, EMAIL, USER_NM, AGREE_DT, FA_SMS, FA_TM, FA_EMAIL, SERVE_SMS, SERVE_TM, SERVE_MAIL
  FROM dbo.MM_MAEKETING_EVENT_MEMBER_TB WITH (NOLOCK) 
/*
 WHERE USERID IN (
'jjungda',
'jjungda83',
'myfunny79@nate.com',
'jaceminc',
'jacemin79',
'jaceminb',
'eenzee',
'ing1101',
'gitest',
'du99@nate.com',
'eenzee00@naver.com',
'sebilia'
)
*/

GO
/****** Object:  View [dbo].[GET_MM_MEMBER_BADUSER_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      VIEW [dbo].[GET_MM_MEMBER_BADUSER_VI]
AS

SELECT 	 SERIAL
	,USERID
	,CAUTIONFLAG
	,SITE
	,CAUTIONDATE
	,USERGBN
	,PROCAGENT
  FROM	DBO.BADUSER U WITH(NOLOCK)
GO
/****** Object:  View [dbo].[GET_MM_MEMBER_TENNIS_NEW_MEMBER_EMAIL_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      VIEW [dbo].[GET_MM_MEMBER_TENNIS_NEW_MEMBER_EMAIL_VI]
AS
	SELECT	DISTINCT 
			LTRIM(RTRIM(B.EMAIL)) AS EMAIL,
			B.USER_NM,
			B.USERID,
			CONVERT(CHAR(10),A.AGREE_DT,120) AS AGREE_DT, 
			JOIN_DT
	FROM	MEMBERDB.MWMEMBER.dbo.CST_MSG_SECTION A  WITH(NOLOCK)
			LEFT JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER B  WITH(NOLOCK) ON A.USERID = B.USERID
	WHERE	A.SECTION_CD = 'S117'
			--AND B.SECTION_CD = 'S117'
			AND B.REST_YN = 'N' 
			AND B.BAD_YN ='N' 
			AND B.OUT_YN ='N' 
			AND B.EMAIL IS NOT NULL 
			AND B.EMAIL <> ''					
			AND (CHARINDEX(' ',LTRIM(RTRIM(EMAIL))) = 0
			AND LEFT(LTRIM(EMAIL),1) <> '@'
			AND RIGHT(RTRIM(EMAIL),1) <> '.'
			AND CHARINDEX('.',EMAIL,CHARINDEX('@',EMAIL)) - CHARINDEX('@',EMAIL) > 1 
			AND LEN(LTRIM(RTRIM(EMAIL))) - LEN(REPLACE(LTRIM(RTRIM(EMAIL)),'@','')) = 1
			AND CHARINDEX('.',REVERSE(LTRIM(RTRIM(EMAIL)))) >= 3
			AND (CHARINDEX('.@',EMAIL) = 0 AND CHARINDEX('..',EMAIL) = 0))
			AND B.EMAIL NOT IN (SELECT EMAIL FROM MM_REJECT_EMAIL_TB WITH(NOLOCK))					
			AND JOIN_DT BETWEEN DATEADD(m, -1, REPLACE(STR(DATEPART(yy, GETDATE())), ' ', '') + '-' + RIGHT(REPLACE('000' + STR(DATEPART(mm, GETDATE())), ' ', ''), 2) + '-21') AND DATEADD(d, -1, REPLACE(STR(DATEPART(yy, GETDATE())), ' ', '') + '-' + RIGHT(REPLACE('000' + STR(DATEPART(mm, GETDATE())), ' ', ''), 2) + '-22')
GO
/****** Object:  View [dbo].[GET_MM_SENDMAIL_REST_VI]    Script Date: 2021-11-04 오전 10:38:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[GET_MM_SENDMAIL_REST_VI]
AS 

	SELECT USERID
	   ,MEMBER_CD
	   ,USERNAME
	   ,EMAIL
	   ,ISNULL(SECTION_CD,'S101') AS SECTION_CD
	   ,CONVERT(VARCHAR(10),JOIN_DT,120) AS JOIN_DT
	   ,CONVERT(VARCHAR(10),LOGIN_DT,120) AS LOGIN_DT
	   ,CONVERT(VARCHAR(10),INSERT_DT,120) AS INSERT_DT
       ,CONVERT(VARCHAR(10),DATEADD(D,10,INSERT_DT),120) AS RESTPREDATE
  FROM MM_SENDMAIL_REST_TB
 WHERE Email <> ''
   AND Email <> 'dhkim@hyunwoostar.com'
   AND DBO.GET_MM_RIGHTEMAIL_FNC(Email) = 'OK'

GO
