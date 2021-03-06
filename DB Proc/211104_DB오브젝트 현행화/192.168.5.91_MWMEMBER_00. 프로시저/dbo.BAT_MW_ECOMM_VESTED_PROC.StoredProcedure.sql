USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[BAT_MW_ECOMM_VESTED_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 :
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2016/09/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 매일 "(8시 5분) 이컴 기득권데이터 취합"을 통해 실행
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.BAT_MW_ECOMM_VESTED_PROC
 *************************************************************************************/


CREATE PROC [dbo].[BAT_MW_ECOMM_VESTED_PROC]

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  -- 파인드올 전섹션 결제데이터 취합   (부동산써브는 SERVE_ECOMM_PAYDATE에 별도로 취합 오전 7시)
  TRUNCATE TABLE FINDALL_ECOMM_PAYDATE    

  INSERT INTO FINDALL_ECOMM_PAYDATE
    (CUID, MAX_PAYDATE)
  SELECT CUID
        ,MAX(CONVERT(DATETIME,LEFT(PAY_REG_DT,8),120)) AS MAX_PAYDATE
    FROM FINDDB2.FINDCOMMON.dbo.SM_SALE_TB
   WHERE CUID IS NOT NULL
   GROUP BY CUID


  /******************************* 기득권 데이터 처리 *******************************/
  BEGIN TRAN
    
    -- 0. 기득권데이터 초기화
    TRUNCATE TABLE ECOMM_VESTED_TB

    -- 1. 파인드올
    INSERT INTO [dbo].[ECOMM_VESTED_TB]
      (CUID, FA_PAYDATE)
    SELECT CUID, MAX_PAYDATE AS FA_PAYDATE
      FROM FINDALL_ECOMM_PAYDATE

    -- 2. SERVE (부동산써브)
    INSERT INTO [dbo].[ECOMM_VESTED_TB]
      (CUID, SV_PAYDATE)
    SELECT CUID, MAX_PAYDATE AS SV_PAYDATE
      FROM SERVE_ECOMM_PAYDATE AS A
     WHERE NOT EXISTS(SELECT CUID FROM FINDALL_ECOMM_PAYDATE WHERE CUID = A.CUID) -- 파인드올과 중복되지 않는 데이터

    -- 3. 부동산써브 결제일
    UPDATE T
       SET T.SV_PAYDATE = A.MAX_PAYDATE
      FROM ECOMM_VESTED_TB AS T
      JOIN SERVE_ECOMM_PAYDATE AS A ON A.CUID = T.CUID
     WHERE T.SV_PAYDATE IS NULL

    -- 4. 기득권 FLAG 갱신
    UPDATE A
       SET VESTEDF = '0'
    --SELECT B.CUID, B.MAX_PAYDATE, DATEADD("d",70,B.MAX_PAYDATE)      FROM ECOMM_VESTED_TB AS A        JOIN (SELECT A.CUID, MAX(MAX_PAYDATE) AS MAX_PAYDATE                FROM (SELECT * FROM MWMEMBER.DBO.FINDALL_ECOMM_PAYDATE                      UNION ALL                      SELECT * FROM MWMEMBER.DBO.SERVE_ECOMM_PAYDATE) AS A               GROUP BY A.CUID) AS B ON B.CUID = A.CUID
      WHERE DATEADD("d",70,B.MAX_PAYDATE) < GETDATE()     -- 최종결제일 기준 70일이전에 결제된건

  COMMIT TRAN


GO
