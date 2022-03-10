  
/*************************************************************************************  
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 휴면 처리 3일전 KKO 발송  
 *  작   성   자 : 최 병찬  
 *  작   성   일 : 2017/01/04  
 *  설        명 :   
 *  주 의  사 항 :  
 *  사 용  소 스 : 배치 스케줄  
 *  사 용  예 제 : EXEC BAT_REST_MEMBER_THREEDAY_AGO_KKO_PROC  
 *************************************************************************************/  
ALTER PROC [dbo].[BAT_REST_MEMBER_THREEDAY_AGO_KKO_PROC]  
  
AS  
  
SET NOCOUNT ON  
  
DECLARE @PHONE varchar (24)  
DECLARE @MSG nvarchar (4000)  
DECLARE @URL varchar (1000)  
DECLARE @URL_BUTTON_TXT varchar (160)  
DECLARE @FAIL_SUBJECT varchar (160)  
DECLARE @FAIL_MSG nvarchar (4000)  
  
DECLARE @PROFILE_KEY VARCHAR(100)     = '5c211bc7dcb8c6a1ee4c7b7ac865389e1115ffe2'  
DECLARE @CALLBACK varchar (24)        = '0802690011'        -- 발신자번호  
DECLARE @TEMPLATE_CODE varchar (10)  = 'ABFa081'           -- 카카오알림톡 템플릿 코드  
  
SELECT @MSG = KKO_MSG  
      ,@URL = URL  
      ,@URL_BUTTON_TXT = URL_BUTTON_TXT  
      ,@FAIL_SUBJECT = LMS_TITLE  
      ,@FAIL_MSG = LMS_MSG  
  FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWFa081'')')   

/* 01. 부동산 써브 ,구인구직 예외 정책 */   
/* 01. 부동산 써브 예외 정책 */  
CREATE TABLE #NOT_EXSIST  
(   
  mem_seq INT PRIMARY KEY,  
  svc_edate DATETIME NOT NULL  
)  
  
INSERT into #NOT_EXSIST (mem_seq, svc_edate)  
  select A.mem_seq, min(A.svc_edate) 'svc_edate'  
      from [192.168.184.51,8019].cont.dbo.contract A with(nolock)  
    where A.svc_edate not in ('1900-01-01 00:00:00.000', '1913-07-04 00:00:00.000', '1999-12-31 00:00:00.000', '9999-12-31 00:00:00.000')  
      -- and A.svc_edate > (GETDATE() - 365)  
      AND A.STAT IN ('O','P')  
  GROUP BY A.mem_seq  
  ORDER BY 2 DESC  
  
/* 구인구직 예외 처리 */  
CREATE TABLE #TMP_REST (  
  CUID INT PRIMARY KEY  
)  
  
CREATE TABLE #TMP_FINDALL_NOT_REST (  
  CUID INT PRIMARY KEY  
)  
  
INSERT INTO #TMP_REST (CUID)  
SELECT CUID    
FROM CST_MASTER CS WITH(NOLOCK)   
WHERE CS.REST_YN = 'N'   
AND CS.OUT_YN = 'N'   
AND (LAST_LOGIN_DT <= GETDATE() - 365 OR ( LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 ))  
  
INSERT INTO #TMP_FINDALL_NOT_REST (CUID)  
SELECT DISTINCT X.CUID  
FROM (  
  /* 구인구직 공고 기준 */  
  SELECT CUID, MAX(REG_DT) AS REG_DT  
  FROM PAPER_NEW.DBO.PP_AD_TB WITH(NOLOCK)  
  WHERE CUID IN (SELECT CUID FROM #TMP_REST)             
  GROUP BY CUID 

  UNION ALL  

  /* 구인구직 정액권 기준*/  
  SELECT CUID, MAX(REG_DT) AS REG_DT  
  FROM PAPER_NEW.DBO.CY_FAT_REGIST_TB WITH(NOLOCK)  
  WHERE CUID IN (SELECT CUID FROM #TMP_REST)             
  GROUP BY CUID  

  UNION ALL  

  /* 구인구직 이력서 열람권 기준*/  
  SELECT CUID, MAX(REG_DT) AS REG_DT  
  FROM PAPER_NEW.DBO.PP_RESUME_READ_GOODS_REGIST_TB WITH(NOLOCK)  
  WHERE CUID IN (SELECT CUID FROM #TMP_REST)             
  GROUP BY CUID  
) X  
WHERE X.REG_DT >= DATEADD(YEAR, -1, GETDATE())

/*End 01. 부동산 써브 ,구인구직 예외 정책 */ 
  
INSERT FINDDB1.COMDB1.DBO.KKO_MSG  
      (STATUS, PHONE, CALLBACK, REQDATE, MSG, TEMPLATE_CODE, PROFILE_KEY, URL, URL_BUTTON_TXT, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, ETC1)  
SELECT   
       1 AS [STATUS]  
      ,REPLACE(A.HPHONE,'-','') AS PHONE  
      ,@CALLBACK AS CALLBACK  
      ,GETDATE() AS REQDATE  
      ,REPLACE(REPLACE(REPLACE(@MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','3일후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-')) AS MSG  
      ,@TEMPLATE_CODE AS TEMPLATE_CODE  
      ,@PROFILE_KEY AS PROFILE_KEY  
      ,@URL AS URL  
      ,@URL_BUTTON_TXT AS URL_BUTTON_TXT  
      ,'LMS' AS FAILED_TYPE  
      ,@FAIL_SUBJECT AS FAILED_SUBJECT  
      ,REPLACE(REPLACE(REPLACE(@FAIL_MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','3일후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-')) AS FAILED_MSG  
      ,'FINDALL' AS ETC1         
  FROM DBO.CST_MASTER AS A WITH(NOLOCK)  
  WHERE A.REST_YN = 'N'  --휴면회원 제외  
    AND A.BAD_YN = 'N'   --불량회원 제외  
    AND A.OUT_YN = 'N'   --회원탈퇴 제외  
    AND (  
          (A.LAST_LOGIN_DT < DATEADD(DD,3,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,2,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )  
          OR   
          (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,3,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,2,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )  
        )  
    AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE A.CUID = NE.mem_seq) -- 01. 부동산 써브 예외 정책  
    AND NOT EXISTS (SELECT FN.CUID FROM #TMP_FINDALL_NOT_REST FN WHERE A.CUID = FN.CUID) -- 02. 구인 구직 예외정책
    AND A.HPHONE IS NOT NULL --2017-01-09 정헌수 추가   