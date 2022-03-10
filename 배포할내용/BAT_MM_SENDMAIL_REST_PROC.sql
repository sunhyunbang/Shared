--use MWMEMBER    
/*******************************************************************************    
' �� �� �� �� �� : ����ȸ�� > �޸鿹��ȸ�� ���� �߼�    
' ��    ��    �� : �� ����    
' ��    ��    �� : 2016/08/28    
' ��    ��    �� :    
' ��    ��    �� :     
' ��          �� : 1�� ���� �α��� ���� ȸ�� 30���� ���Ϲ߼�    
'       30���� COMMON DB�� MM_SENDMAIL_REST_TB ���̺� INSERT�� ���� �߼�    
' ��  ��  ��  �� :     
' ��  ��  ��  ��  : ������ �۾�     
' ��          �� :     
******************************************************************************/    
CREATE PROCEDURE [dbo].[BAT_MM_SENDMAIL_REST_PROC]    
AS     
    
SET NOCOUNT ON    
BEGIN     
    
------------------------------------------------------------------------------    
-- 1�� ���� �α��� ���� ȸ�� 30���� ���� �߼�    
------------------------------------------------------------------------------    
    
    
execute FINDDB1.PAPER_NEW.DBO.BAT_VERSION_M_2MONTH_PHONE_LIST_SAVE_PROC --�ֱ� 2���� ��ϴ��� ���� ��ȭ��ȣ ����    
    
    
SELECT PHONE    
INTO #TMP_PHONE    
FROM FINDDB1.LOGDB.DBO.TEMP_VERSION_M_2MONTH_PHONE_LIST_TB    
  
/* 01. �ε��� ��� ���� ��å */    
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
    
/* ���α��� ���� ó�� */    
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
  /* ���α��� ���� ���� */    
  SELECT CUID, MAX(REG_DT) AS REG_DT    
  FROM PAPER_NEW.DBO.PP_AD_TB WITH(NOLOCK)    
  WHERE CUID IN (SELECT CUID FROM #TMP_REST)               
  GROUP BY CUID   
  
  UNION ALL    
  
  /* ���α��� ���ױ� ����*/    
  SELECT CUID, MAX(REG_DT) AS REG_DT    
  FROM PAPER_NEW.DBO.CY_FAT_REGIST_TB WITH(NOLOCK)    
  WHERE CUID IN (SELECT CUID FROM #TMP_REST)               
  GROUP BY CUID    
  
  UNION ALL    
  
  /* ���α��� �̷¼� ������ ����*/    
  SELECT CUID, MAX(REG_DT) AS REG_DT    
  FROM PAPER_NEW.DBO.PP_RESUME_READ_GOODS_REGIST_TB WITH(NOLOCK)    
  WHERE CUID IN (SELECT CUID FROM #TMP_REST)               
  GROUP BY CUID    
) X    
WHERE X.REG_DT >= DATEADD(YEAR, -1, GETDATE())  
  
/*End 01. �ε��� ��� ,���α��� ���� ��å */    
    
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
  WHERE A.REST_YN = 'N'  --�޸�ȸ�� ����    
  AND A.BAD_YN = 'N'   --�ҷ�ȸ�� ����    
  AND A.OUT_YN = 'N'   --ȸ��Ż�� ����    
  AND (    
      (A.LAST_LOGIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )    
      OR     
      (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )    
      )    
  AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE A.CUID = NE.mem_seq) -- 01. �ε��� ��� ���� ��å    
  AND NOT EXISTS (SELECT FN.CUID FROM #TMP_FINDALL_NOT_REST FN WHERE A.CUID = FN.CUID) -- 02. ���� ���� ������å    
  AND HPHONE NOT IN(    
  SELECT PHONE FROM #TMP_PHONE    
 )    
    
END    
    