--use MWMEMBER    
/*******************************************************************************    
' 단 위 업 무 명 : 공통회원 > 휴면예정회원 메일 발송    
' 작    성    자 : 최 병찬    
' 작    성    일 : 2016/08/28    
' 수    정    자 :    
' 수    정    일 :     
' 설          명 : 1년 동안 로그인 안한 회원 30일전 메일발송    
'       30일전 COMMON DB의 MM_SENDMAIL_REST_TB 테이블에 INSERT후 메일 발송    
' 주  의  사  항 :     
' 사  용  소  스  : 스케줄 작업     
' 예          제 :     
******************************************************************************/    
CREATE PROCEDURE [dbo].[BAT_MM_SENDMAIL_REST_PROC]    
AS     
    
SET NOCOUNT ON    
BEGIN     
    
------------------------------------------------------------------------------    
-- 1년 동안 로그인 안한 회원 30일전 메일 발송    
------------------------------------------------------------------------------    
    
    
execute FINDDB1.PAPER_NEW.DBO.BAT_VERSION_M_2MONTH_PHONE_LIST_SAVE_PROC --최근 2개월 등록대행 공고 전화번호 생성    
    
    
SELECT PHONE    
INTO #TMP_PHONE    
FROM FINDDB1.LOGDB.DBO.TEMP_VERSION_M_2MONTH_PHONE_LIST_TB    
  
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
    
DELETE FROM FINDDB2.COMMON.DBO.MM_SENDMAIL_REST_TB    
    
    
  INSERT FINDDB2.COMMON.DBO.MM_SENDMAIL_REST_TB    
  (    
    USERID    
  ,MEMBER_CD     
  ,USERNAME    
  ,EMAIL    
  ,JOIN_DT    
  ,LOGIN_DT    
  ,INSERT_DT    
  ,CUID    
  )    
  SELECT     
       A.USERID    
      ,A.MEMBER_CD    
      ,A.USER_NM    
      ,A.EMAIL    
      ,A.JOIN_DT    
      ,ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT) AS LAST_LOGIN_DT    
      ,DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) AS INSERT_DT    
      ,A.CUID    
  FROM DBO.CST_MASTER AS A WITH(NOLOCK)    
  WHERE A.REST_YN = 'N'  --휴면회원 제외    
  AND A.BAD_YN = 'N'   --불량회원 제외    
  AND A.OUT_YN = 'N'   --회원탈퇴 제외    
  AND (    
      (A.LAST_LOGIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )    
      OR     
      (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )    
      )    
  AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE A.CUID = NE.mem_seq) -- 01. 부동산 써브 예외 정책    
  AND NOT EXISTS (SELECT FN.CUID FROM #TMP_FINDALL_NOT_REST FN WHERE A.CUID = FN.CUID) -- 02. 구인 구직 예외정책    
  AND HPHONE NOT IN(    
  SELECT PHONE FROM #TMP_PHONE    
 )    
    
END    
    