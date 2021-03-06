USE [FINDCOMMON]
GO
/****** Object:  View [dbo].[ACC_BILL_STAT]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ACC_BILL_STAT]

AS
--연결된 서버 생성시
--데이타 정렬 호환 체크
--원격데이타 정렬 사용 체크
--연결된 서버 SENDBILL 과 연결 IP는 동일하나 연결된서버 생성시 옵션 다름
--SENDBILL_BILL_STAT 와 링크드 서버 설정 다름
SELECT * FROM [116.120.56.64].ACCDB1.dbo.BILL_STAT
GO
/****** Object:  View [dbo].[ACC_BILL_TRANS]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ACC_BILL_TRANS]

AS
--연결된 서버 생성시
--데이타 정렬 호환 체크
--원격데이타 정렬 사용 체크
--연결된 서버 SENDBILL 과 연결 IP는 동일하나 연결된서버 생성시 옵션 다름
SELECT * FROM [116.120.56.64].ACCDB1.dbo.BILL_TRANS
GO
/****** Object:  View [dbo].[ACC_BUNRYU_MASTER_VI]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ACC_BUNRYU_MASTER_VI]

AS
  
  -- 벼룩시장
  SELECT 1 AS SERVICE_CODE, '벼룩시장' AS [SERVICE_NAME], CODE2, CODENM2 
    FROM CC_ACCOUNT_CODE_TB
   WHERE CODE1 = 'A'
    AND SERVICEF & 1 = 1

  UNION ALL

  -- 야알바
  SELECT 2 AS SERVICE_CODE, '야알바' AS [SERVICE_NAME], CODE2, CODENM2 
    FROM CC_ACCOUNT_CODE_TB
   WHERE CODE1 = 'A'
    AND SERVICEF & 2 = 2

  UNION ALL

  -- 중고장터
  SELECT 4 AS SERVICE_CODE, '중고장터' AS [SERVICE_NAME], CODE2, CODENM2 
    FROM CC_ACCOUNT_CODE_TB
   WHERE CODE1 = 'A'
    AND SERVICEF & 4 = 4
GO
/****** Object:  View [dbo].[DATA_SALE_SUM]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DATA_SALE_SUM]
AS

select  pay_reg_Dt  , sum(section_AmTSUM) as section_AmTSUM 
FROM TMP_DATA_SALE_20151207 group by pay_reg_Dt
GO
/****** Object:  View [dbo].[DEVELOPER_ACCOUNT_VI]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DEVELOPER_ACCOUNT_VI]
AS

  SELECT A.MagID, A.MagName, A.HP
       , B.MANAGER, B.SECTION_CD
    FROM CommonMagUser A WITH(NOLOCK)
    JOIN CommonMagUserDev B WITH(NOLOCK) ON B.MAG_ID = A.MagID
   WHERE A.UseFlag = 1
     AND A.DelFlag = 0
     AND A.JOBPAPER = 1

GO
/****** Object:  View [dbo].[GET_COMMONMAGUSER_CHANGE_LOG_VI]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[GET_COMMONMAGUSER_CHANGE_LOG_VI]
AS

	
	SELECT  SSS.*,B.MagName as magname,C.MagName  as adminname
	,DBO.FN_SECTION_NM(SECTIONCODE) as SECTION_NM
	 FROM (
		SELECT  * FROM (
			SELECT *
			,ISNULL((SELECT TOP 1 CAST(GROUPMENU AS VARCHAR(100)) GROUPMENU  FROM DBO.COMMONMAGUSERSUBLOG S WHERE S.MAGID = A.MAGID AND S.SECTIONCODE  = A.SECTIONCODE  AND A.PKEY > S.PKEY ORDER BY PKEY DESC ),'신규') AS bigo
			,'권한' as GBN
			FROM DBO.COMMONMAGUSERSUBLOG A WITH(NOLOCK)
		)SS
		WHERE  (SS.GROUPMENU NOT LIKE SS.bigo +'%' )

		UNION ALL 

		SELECT 
		PKEY,	MAGID,	SECTIONCODE,	LOCALSITE,	BRANCHCODE,	LOGINTIME,	USEFLAG,	GROUPCODE,	GROUPMENU,	REG_DT,	ADMINID
			,'권한삭제'	,'권한 변경'
		 FROM (
			SELECT *
			,isnull(( SELECT TOP 1  cast(USEFLAG  as varchar) USEFLAG FROM DBO.COMMONMAGUSERSUBLOG B WITH(NOLOCK) WHERE A.MAGID = B.MAGID AND B.SECTIONCODE  = A.SECTIONCODE AND B.PKEY < A.PKEY ORDER BY PKEY DESC ),'신규') OLD_USEFLAG
			FROM DBO.COMMONMAGUSERSUBLOG A WITH(NOLOCK) 
			WHERE USEFLAG = '0' 
		)SS
		WHERE OLD_USEFLAG  <> cast(isnull(USEFLAG,'') as varchar)  and OLD_USEFLAG <> '신규'
		
		UNION ALL
		
		select PKEY,	MAGID,	NULL,	NULL,	BRANCHCODE,	NULL,	NULL,	NULL,	NULL,	REG_DT,	ADMINID ,'계정삭제','계정'
		FROM dbo.COMMONMAGUSERLOG where ACT ='D'
		union all
		select SEQ,	APPLY_ID,	NULL,	NULL,	INPUT_BRANCH ,	NULL,	NULL,	NULL,	NULL,	REG_DT,	MAG_ID ,COMMENT ,'수정'
		FROM 		CommonApplyAuthHistory
	)SSS
	LEFT OUTER JOIN COMMONMAGUSER B ON SSS.MAGID = B.MagID 
	LEFT OUTER JOIN COMMONMAGUSER C ON SSS.ADMINID = C.MagID 
	
	--WHERE MAGID='SUN1004'




	
	





GO
/****** Object:  View [dbo].[GET_COMMONMAGUSER_LOGIN_FAIL_VI]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[GET_COMMONMAGUSER_LOGIN_FAIL_VI]
AS

		
	SELECT  C.BNAME, CM.MAGID,CM.MAGNAME ,S.REG_DT,S.IP,FAIL_CNT
	FROM (
	SELECT  MAGID,IP,REG_DT 
	,(
		SELECT COUNT(*)+1 FROM ADMIN_ACCESS_LOG_TB B WITH(NOLOCK) WHERE  B.MAGID = A.MAGID 
			AND B.IDX < A.IDX 
			AND B.IDX >=(SELECT TOP 1 IDX  FROM ADMIN_ACCESS_LOG_TB C WITH(NOLOCK) WHERE C.IDX <= A.IDX AND SUCCESS_YN='Y' AND C.MAGID = B.MAGID ORDER BY IDX DESC)
	 AND B.SUCCESS_YN ='N'
	 ) AS FAIL_CNT
	FROM DBO.ADMIN_ACCESS_LOG_TB  A WITH(NOLOCK)
	WHERE A.SUCCESS_YN ='N'
	) S  
	LEFT OUTER JOIN DBO.COMMONMAGUSER CM ON S.MAGID = CM.MAGID 
	LEFT OUTER JOIN PAPERJOB.DBO.CC_BRANCH_TB C ON CM.BRANCHCODE = C.BRANCHCODE
	WHERE  REG_DT > '2019-01-22'
	--AND MAGID ='KKAM1234'



GO
/****** Object:  View [dbo].[GET_STATIONCODE_VI]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GET_STATIONCODE_VI]
AS
	SELECT 	CODE1
		,CODE2
		,CODE3
		,CITYNM
		,LINENUM
		,STATIONNM
	  FROM	DBO.STATIONNM WITH(NOLOCK)
GO
/****** Object:  View [dbo].[GET_ZIPCODE_VI]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GET_ZIPCODE_VI]
AS

	SELECT 	 ZIPCODE1
		,ZIPCODE2
		,ADDRESS
		,CITY		
	  FROM	DBO.ZIPCODE WITH(NOLOCK)
GO
/****** Object:  View [dbo].[SENDBILL_BILL_STAT]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SENDBILL_BILL_STAT]

AS

SELECT * FROM SENDBILL.ACCDB1.dbo.BILL_STAT
GO
/****** Object:  View [dbo].[SENDBILL_BILL_TRANS]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SENDBILL_BILL_TRANS]

AS

SELECT * FROM SENDBILL.ACCDB1.dbo.BILL_TRANS
GO
/****** Object:  View [dbo].[TAX_TODAY_SENDBILL_NOT_SEND_VI]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 세금계산서 자동발행 > 금일자 세금계산서 샌드빌 자동 전송 누락건 VIEW
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2014/06/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 세금계산서 자동신청 스케쥴 적용이후 샌드빌전송에 누락된건
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : SELECT * FROM TAX_TODAY_SENDBILL_NOT_SEND_VI
 
 CUID	USERID	BAD_YN	PWD	PWD_MOD_DT	PWD_NEXT_ALARM_DT	LOGIN_FAIL_CNT	LOGIN_FAIL_DT	JOIN_DT	FLOW	MOD_DT	MOD_ID	ADULT_YN	MEMBER_CD	USER_NM	HPHONE	EMAIL	GENDER	BIRTH	SNS_TYPE	SNS_ID	COM_ID	DI	CI	REST_YN	REST_DT	OUT_YN	SITE_CD	InputBranch	CustCode	CustType	mem_seq	STATUS_CD	MASTER_ID
29947	tjswls0339	N	                                                                                                                                                                                                                                                               	2015-04-07 22:27:24.957	2015-10-04 22:27:24.957	NULL	NULL	NULL	NULL	NULL	NULL	N	NULL				 	 	NULL	NULL	NULL	NULL	NULL	Y	2015-08-18 11:21:45.977	N	F	NULL	NULL	NULL	NULL	NULL	NULL
 *************************************************************************************/

CREATE VIEW [dbo].[TAX_TODAY_SENDBILL_NOT_SEND_VI]

AS


    -- 벼룩시장 EComm
    SELECT --TOP 2
           A.ADID
          ,M.USER_NM as USERNAME
          ,M.USERID
          ,'' AS PHONE
          ,M.HPHONE
          ,CONVERT(VARCHAR(10),A.SettleDate,120) AS SETTLEDATE
          ,R.PRNAMT AS PRNAMT
          ,CASE R.CHARGEKIND WHEN 1 THEN '온라인입금'
                             WHEN 2 THEN '신용카드'
                             WHEN 3 THEN '휴대폰'
                             WHEN 4 THEN '통장입금'
                             END AS CHARGEKIND
          ,CASE AD.GROUP_CD WHEN 14 THEN 'E-Comm(구인)'
                            WHEN 13 THEN 'E-Comm(부동산)'
                            WHEN 12 THEN 'E-Comm(자동차)'
                            WHEN 10 THEN 'E-Comm(상품서비스)'
                            END AS AD_KIND
          ,NULL AS IC_CENTER
          ,M.CUID
      FROM TaxRequest AS A
        JOIN MEMBERDB.MWMEMBER.dbo.CST_MASTER AS M
          ON M.USERID = A.UserID
        JOIN FINDDB1.PAPER_NEW.dbo.PP_ECOMM_RECCHARGE_TB AS R
          ON R.SERIAL = A.GRPSERIAL
        JOIN FINDDB1.PAPER_NEW.dbo.PP_AD_TB AS AD
          ON AD.LINEADID = A.ADID
        LEFT JOIN RESUME_TAXREQUEST_TOTAL AS  B
          ON B.IDX = A.IDX
         AND B.GRPSERIAL = A.GrpSerial
      WHERE (B.IDX IS NULL OR B.[STATUS] = 0)
        AND R.PRODUCT_GBN = 1
        AND A.SiteGbn IN ('Paper','MagPaper')
        AND A.TaxCheckDate IS NULL
        AND A.TaxCancelDate IS NULL
        AND A.RegDate >= CONVERT(VARCHAR(10),GETDATE(),120)
        AND AD.[VERSION] = 'E'  -- 이컴광고만

  UNION ALL

    -- 구인다량등록권
    SELECT --TOP 2 
          A.ADID
          ,M.USER_NM as USERNAME
          ,M.USERID
          ,'' AS PHONE
          ,M.HPHONE
          ,CONVERT(VARCHAR(10),A.SettleDate,120) AS SETTLEDATE
          ,R.PRNAMT AS PRNAMT
          ,CASE R.CHARGEKIND WHEN 1 THEN '온라인입금'
                             WHEN 2 THEN '신용카드'
                             WHEN 3 THEN '휴대폰'
                             WHEN 4 THEN '통장입금'
                             END AS CHARGEKIND
          ,CASE R.PRODUCT_GBN WHEN 2 THEN '구인 정액권'
                              WHEN 3 THEN '부동산 다량등록권'
                              WHEN 5 THEN '구인 후결제'
                              WHEN 6 THEN '이력서 열람'
                              END AS AD_KIND
          ,NULL AS IC_CENTER
          ,A.CUID
      FROM TaxRequest AS A
        JOIN MEMBERDB.MWMEMBER.dbo.CST_MASTER AS M
          ON M.USERID = A.UserID
        JOIN FINDDB1.PAPER_NEW.dbo.PP_ECOMM_RECCHARGE_TB AS R
          ON R.SERIAL = A.GRPSERIAL
        LEFT JOIN RESUME_TAXREQUEST_TOTAL AS  B
          ON B.IDX = A.IDX
         AND B.GRPSERIAL = A.GrpSerial
      WHERE (B.IDX IS NULL OR B.[STATUS] = 0)
        AND R.PRODUCT_GBN <> 1
        AND A.SiteGbn IN ('Paper','MagPaper')
        AND A.TaxCheckDate IS NULL
        AND A.TaxCancelDate IS NULL
        AND A.RegDate >= CONVERT(VARCHAR(10),GETDATE(),120)

  UNION ALL

    -- 야알바
    SELECT --TOP 2 
          A.ADID
          ,M.USER_NM as USERNAME
          ,M.USERID
          ,'' AS PHONE
          ,M.HPHONE
          ,CONVERT(VARCHAR(10),A.SettleDate,120) AS SETTLEDATE
          ,R.PRNAMT AS PRNAMT
          ,CASE R.CHARGE_KIND WHEN 1 THEN '온라인입금'
                             WHEN 2 THEN '신용카드'
                             WHEN 3 THEN '휴대폰'
                             WHEN 4 THEN '통장입금'
                             END AS CHARGEKIND
          ,'야알바' AS AD_KIND
          ,NULL AS IC_CENTER
          ,M.CUID
      FROM TaxRequest AS A
        JOIN MEMBERDB.MWMEMBER.dbo.CST_MASTER AS M
          ON M.USERID = A.UserID
        JOIN YAALBA.PAPERJOB.dbo.PJ_RECCHARGE_TB AS R
          ON R.SERIAL = A.GRPSERIAL
        JOIN YAALBA.PAPERJOB.dbo.PJ_AD_USERREG_TB AS AD
          ON AD.ADID = R.ADID
        LEFT JOIN RESUME_TAXREQUEST_TOTAL AS  B
          ON B.IDX = A.IDX
         AND B.GRPSERIAL = A.GrpSerial
      WHERE (B.IDX IS NULL OR B.[STATUS] = 0)
        AND A.SiteGbn IN ('JOB','MAGJOB')
        AND A.TaxCheckDate IS NULL
        AND A.TaxCancelDate IS NULL
        AND A.RegDate >= CONVERT(VARCHAR(10),GETDATE(),120)

  UNION ALL

    -- 벼룩시장 직접등록
    SELECT --TOP 2
          A.ADID
          ,M.USER_NM as USERNAME
          ,M.USERID
          ,'' AS PHONE
          ,M.HPHONE
          ,CONVERT(VARCHAR(10),A.SettleDate,120) AS SETTLEDATE
          ,R.PRNAMT AS PRNAMT
          ,CASE R.CHARGEKIND WHEN 1 THEN '온라인입금'
                             WHEN 2 THEN '신용카드'
                             WHEN 3 THEN '휴대폰'
                             WHEN 4 THEN '통장입금'
                             END AS CHARGEKIND
          ,'직접등록' AS AD_KIND
          ,CASE AD.CLOSEBRANCH WHEN 25 THEN '부산'
                               WHEN 11 THEN '대구'
                               WHEN 12 THEN '대전'
                               ELSE '서울IC'
                               END AS IC_CENTER
          ,M.CUID
      FROM FINDDB1.PAPERREG.dbo.TAXREQUEST AS A
        JOIN MEMBERDB.MWMEMBER.dbo.CST_MASTER AS M
          ON M.USERID = A.UserID
        JOIN FINDDB1.PAPERREG.dbo.RECCHARGE AS R
          ON R.SERIAL = A.GRPSERIAL
        JOIN (SELECT LINEADID, MAX(CLOSEBRANCH) AS CLOSEBRANCH FROM FINDDB1.PAPERREG.dbo.LINEAD GROUP BY LINEADID) AS AD
          ON AD.LINEADID = A.ADID
        LEFT JOIN RESUME_TAXREQUEST_TOTAL AS  B
          ON B.IDX = A.IDX
         AND B.GRPSERIAL = A.GrpSerial
      WHERE (B.IDX IS NULL OR B.[STATUS] = 0)
        AND A.SiteGbn IN ('Paper','MagPaper')
        AND R.InputBranch = 80
        AND A.TaxCheckDate IS NULL
        AND A.TaxCancelDate IS NULL
        AND A.RegDate >= CONVERT(VARCHAR(10),GETDATE(),120)

  UNION ALL

    -- 중개거래 패키지
    SELECT --TOP 2 
          A.ADID
          ,M.USER_NM as USERNAME
          ,M.USERID
          ,'' AS PHONE
          ,M.HPHONE
          ,CONVERT(VARCHAR(10),A.SettleDate,120) AS SETTLEDATE
          ,R.PRNAMT AS PRNAMT
          ,CASE R.CHARGEKIND WHEN 1 THEN '온라인입금'
                             WHEN 2 THEN '신용카드'
                             WHEN 3 THEN '휴대폰'
                             WHEN 4 THEN '통장입금'
                             END AS CHARGEKIND
          ,'중개거래 패키지' AS AD_KIND
          ,CASE AD.BRANCHCODE WHEN 25 THEN '부산'
                               WHEN 11 THEN '대구'
                               WHEN 90 THEN '서울'
                               END AS IC_CENTER
          ,M.CUID
      FROM FINDDB1.PAPERREG.dbo.TAXREQUEST AS A
        JOIN MEMBERDB.MWMEMBER.dbo.CST_MASTER AS M
          ON M.USERID = A.UserID
        JOIN FINDDB1.PAPERREG.dbo.RECCHARGE AS R
          ON R.SERIAL = A.GRPSERIAL
        JOIN FINDDB1.PAPERREG.dbo.PackageInfo AS AD
          ON AD.PackageId = A.ADID
        LEFT JOIN RESUME_TAXREQUEST_TOTAL AS  B
          ON B.IDX = A.IDX
         AND B.GRPSERIAL = A.GrpSerial
      WHERE (B.IDX IS NULL OR B.[STATUS] = 0)
        AND A.SiteGbn IN ('Paper','MagPaper')
        AND R.InputBranch = 80
        AND A.TaxCheckDate IS NULL
        AND A.TaxCancelDate IS NULL
        AND A.RegDate >= CONVERT(VARCHAR(10),GETDATE(),120)
GO
/****** Object:  View [dbo].[V_MagUser_Excel]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
dbo.sp_CommonMagUser_List_Excel '1','10000','','2005-05-22','2005-06-22','','' ,'','','', '','' 

select * from commonMagUserSub where magid='autotest01'
pcercle0000
select * from  dbo.V_MagUser_Excel 

*/

--select MagID , SectionCode , U.MagName , U.PassWord ,
--Case When 
CREATE             View  [dbo].[V_MagUser_Excel] 
AS 
SELECT distinct  Top 100000  U.MagID, 
S.SectionCode,
SectionName = (
	Select SectionName From dbo.CommonMagGroupCode 
	Where SectionCode = S.SectionCode AND GroupCode = S.GroupCode
	) , 
U.MagName, 
'' as PassWord, U.PartNm, U.Phone, U.Email, U.RegDate ,

--계정관리 
U.AdminChk , 
AdminGbn = Case  When AdminChk =1 THEN '관리자관리' Else '권한없슴' END , 
U.FindAll,
U.FindJob,
U.GanhoJob,
U.FindHouse,
U.FindAuto,
U.FindUsed,
U.FindLocal,
U.KeyWord,
U.PaperNew,
U.IpJoo,
U.CoCoFun,
U.Description, 

IsNull(T.BranchName, '')  MagBranchName, 
S.LocalSite,  
L.LocalSiteNm,
S.GroupCode, 
GroupName=(
	Select GroupName From  CommonMagGroupCode 
	Where S.SectionCode=SectionCode AND S.GroupCode = GroupCode
       )      , 
S.GroupMenu,
S.UseFlag SectionUseFlag,
U.UseFlag  ,
U.DelFlag ,
U.BranchCode,
Lo.LoginTime	
FROM    
dbo.CommonMagUser U  With(NoLock)  ,  
dbo.CommonMagUserSub S  With(NoLock)  , 
dbo.Branch B With(NoLock) ,
dbo.Branch T With(NoLock) , 
dbo.LocalSite L With(NoLock) ,
(Select U.MagID ,Max(LoginTime) LoginTime From dbo.CommonMagUser U With(NoLock) ,  dbo.CommonMagUserSub S With(NoLock)   Where U.MagID = S.MagID Group By U.MagID) Lo
Where  
U.MagID  =S.MagID AND 
U.BranchCode*= B.BranchCode AND 
S.LocalSite = L.LocalSite AND 
S.UseFlag	= 1	AND
U.DelFlag	= 0 	AND

S.BranchCode *= T.BRanchCode AND
U.MagID	=	Lo.MagID


Order By U.MagID , S.SectionCode







GO
/****** Object:  View [dbo].[viewLocalSite]    Script Date: 2021-11-04 오전 10:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewLocalSite]
AS
SELECT DISTINCT(LOCALSITENM),LOCALSITE FROM LOCALSITE
GO
