USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[BAT_INTEGRATION_MEMBER_OUT_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 통합 처리한 회원 -> 탈퇴 회원 처리(일주일 이전 데이터)
 *  작   성   자 : 최병찬
 *  작   성   일 : 2016-10-14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
CREATE PROC [dbo].[BAT_INTEGRATION_MEMBER_OUT_PROC]

AS

SELECT DISTINCT A.CUID 
  INTO #AAA
  FROM CST_MASTER AS A
  JOIN CST_ADMISSION AS B ON A.CUID=B.S_CUID
 WHERE A.STATUS_CD='D'
   AND A.OUT_YN='N'
   AND B.APP_DT> CONVERT(VARCHAR(10), DATEADD(DAY, -7, GETDATE()), 111)
   AND B.APP_DT< CONVERT(VARCHAR(10), DATEADD(DAY, -6, GETDATE()), 111)


DELETE CST_REST_MASTER
  FROM CST_REST_MASTER AS A
  JOIN #AAA AS B ON A.CUID=B.CUID 

--탈퇴 테이블 정보 입력
INSERT INTO CST_OUT_MASTER 
       (
				 CUID
				,OUT_APPLY_DT
				,OUT_PROC_DT
				,OUT_CAUSE
			  )  -- 탈퇴 이력을 남긴다.
SELECT
				 A.CUID 
				,GETDATE() AS OUT_APPLY_DT
				,GETDATE() AS OUT_PROC_DT
				,'회원 통합 미이용 ID 삭제 처리' AS OUT_CAUSE
  FROM #AAA AS A


UPDATE CST_MASTER 
  SET USER_NM = ''
    , HPHONE = ''
    , EMAIL = ''
    , BIRTH =  REPLACE(REPLACE(SUBSTRING(BIRTH,1,4),'-',''),' ','')
    , DI = '' 
    , CI = ''
    , MOD_DT = GETDATE()
    , OUT_YN = 'Y'
    , OUT_DT = GETDATE()
 FROM CST_MASTER AS A
 JOIN #AAA AS B ON A.CUID=B.CUID
GO
