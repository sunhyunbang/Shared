--USE MOBILE_SERVICE


--��ü ���
SELECT * INTO _MOBILE_PUSH_DEVICE_INFO_211027
FROM MOBILE_PUSH_DEVICE_INFO

--�κ� ���
SELECT TOP 10000 *
  INTO MOBILE_PUSH_DEVICE_INFO_211027_PART1
  FROM MOBILE_PUSH_DEVICE_INFO WITH(NOLOCK)
 WHERE DeviceID IN (
        SELECT DeviceID
          FROM MOBILE_PUSH_DEVICE_INFO WITH(NOLOCK)
         WHERE SiteCD = 'JOB' AND DeviceType='ANDROID'  
           AND (AppVersion = '2.8.0' OR AppVersion = '2.8.1')
           --AND Date_Upt > '2021-10-25'
         GROUP BY DeviceID
         HAVING COUNT(*) > 1
       )
 ORDER BY Date_Upt DESC

-- 1.��� ���
SELECT TOP 10000 *
  INTO #TMP_1
  FROM MOBILE_PUSH_DEVICE_INFO WITH(NOLOCK)
 WHERE DeviceID IN (
        SELECT DeviceID
          FROM MOBILE_PUSH_DEVICE_INFO WITH(NOLOCK)
         WHERE SiteCD = 'JOB' AND DeviceType='ANDROID'  
           AND (AppVersion = '2.8.0' OR AppVersion = '2.8.1')
           --AND Date_Upt > '2021-10-25'
         GROUP BY DeviceID
         HAVING COUNT(*) > 1
       )
 ORDER BY Date_Upt DESC

-- 2.����� �ӽ����̺� ����
SELECT *
  INTO #TMP_2
  FROM #TMP_1

-- 3.����� ���� �ֱ� ������ ����
SELECT DeviceID, MAX(AppVersion) AS AppVersion, MAX(OpenCnt) AS OpenCnt, MAX(CUID) AS CUID, MAX(CUID_UPDATE_DT) AS CUID_UPDATE_DT
  INTO #TMP_3
  FROM #TMP_2
 GROUP BY DeviceID
 ORDER BY DeviceID

-- 4.��� ��� ���� �ֱ� ������ ������Ʈ
UPDATE A
   SET A.DeviceID       = B.DeviceID
     , A.AppVersion     = B.AppVersion
     , A.OpenCnt        = B.OpenCnt
     , A.CUID           = B.CUID
     , A.CUID_UPDATE_DT = B.CUID_UPDATE_DT
-- SELECT A.DeviceID, A.AppVersion, A.OpenCnt, A.CUID, A.CUID_UPDATE_DT, B.*
  FROM #TMP_2 A
  JOIN #TMP_3 B ON B.DeviceID = A.DeviceID

SELECT * FROM #TMP_2 ORDER BY DeviceID
 
-- 5.��� �� ���� ó�� ��� �� Ű�� ����  (���ܾ� �� Ű��)
SELECT DeviceID, MIN(Idx) AS IDX
  INTO #TMP_4
  FROM #TMP_2
 GROUP BY DeviceID

-- 6. ��� �� 5������ ���� Ű�� �̿� Ű������ ���� (�����ؾ� �� Ű��)
SELECT *
  INTO #TMP_5
  FROM #TMP_2 A
 WHERE Idx NOT IN (SELECT IDX FROM #TMP_4)

-- 7. 5�� ��� �������� ���� ��� ������Ʈ
UPDATE A
   SET A.DeviceID       = B.DeviceID
     , A.AppVersion     = B.AppVersion
     , A.OpenCnt        = B.OpenCnt
     , A.CUID           = B.CUID
     , A.CUID_UPDATE_DT = B.CUID_UPDATE_DT
-- SELECT A.IDX, A.DeviceID, A.AppVersion, A.OpenCnt, A.CUID, A.CUID_UPDATE_DT, B.*
  FROM MOBILE_PUSH_DEVICE_INFO A
  JOIN #TMP_2 B ON B.Idx = A.Idx
 WHERE A.Idx IN (SELECT IDX FROM #TMP_4)

-- 8. 6�� ������� ����
DELETE A
-- SELECT *
  FROM MOBILE_PUSH_DEVICE_INFO A
 WHERE Idx IN (SELECT IDX FROM #TMP_5)











-- �������� ��� �ߺ� Ȯ�� ����
 CREATE TABLE #TAGET_TABLE 
 (  
  IDX   INT  
  , DEVICE_ID VARCHAR(400)  
  , PUSH_KEY VARCHAR(400)  
 )  
  
 INSERT INTO #TAGET_TABLE (IDX, DEVICE_ID, PUSH_KEY)  
 SELECT  
  D.Idx, D.DeviceID, D.PushKey  
 FROM  
  MOBILE_SERVICE.dbo.MOBILE_PUSH_DEVICE_INFO AS D WITH(NOLOCK)  
   INNER JOIN (SELECT DeviceID FROM PAPER_NEW.DBO.PP_MATCH_AD_TB WITH(NOLOCK) WHERE DeviceID <> '' GROUP BY DeviceID) AS L   
   ON L.DeviceID = D.DeviceID  
 WHERE D.SiteCD = 'JOB' AND D.Push_YN_Match = 'Y' AND D.DeviceType='ANDROID' AND D.CUID IS NOT NULL


SELECT DEVICE_ID, COUNT(*)
  FROM #TAGET_TABLE
 GROUP BY DEVICE_ID
 HAVING COUNT(*) > 1

DROP TABLE #TAGET_TABLE