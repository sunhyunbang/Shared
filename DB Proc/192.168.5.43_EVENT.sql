USE [EVENT]
GO
/****** Object:  View [dbo].[EVENT_ENTRY_VI]    Script Date: 2021-11-04 오전 10:38:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************  
 *  단위 업무 명 : 프론트 > 나의 응모내역  
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)  
 *  작   성   일 : 2011/03/07  
 *  수   정   자 : 이 경 덕 (laplance@mediawill.com)  
 *  수   정   일 : 2012/09/14  
 *  설        명 : 올포인트 소진 내역 추가함  
 *  주 의  사 항 :  
 *  사 용  소 스 :  
 *  사 용  예 제 : SELECT TOP 10 * FROM EVENT_ENTRY_VI  
 *************************************************************************************/  
  
CREATE VIEW [dbo].[EVENT_ENTRY_VI]  
  
AS  
  
  SELECT A.EVENT_SEQ  
        ,B.PROGRESSION_SITE  
        ,B.TITLE  
        ,CONVERT(VARCHAR(10),B.START_DT,102) AS START_DT  
        ,CONVERT(VARCHAR(10),B.END_DT,102) AS END_DT  
        ,A.REG_DT AS ENTRY_DT  
        ,CONVERT(VARCHAR(10),B.ANNOUNCE_DT,102) AS ANNOUNCE_DT  
        ,A.USERID  
        ,B.PUB_TYPE  
        ,A.CUID   
    FROM EV_MY_ENTRY_TB AS A  
         JOIN EV_EVENT_TB AS B  
           ON B.EVENT_SEQ = A.EVENT_SEQ  
    
  /*
  UNION ALL  
  
  SELECT A.EVENT_SEQ  
        ,B.PROGRESSION_SITE  
        ,B.TITLE  
        ,CONVERT(VARCHAR(10),B.START_DT,102) AS START_DT  
        ,CONVERT(VARCHAR(10),B.END_DT,102) AS END_DT  
        ,A.REG_DT AS ENTRY_DT  
        ,CONVERT(VARCHAR(10),B.ANNOUNCE_DT,102) AS ANNOUNCE_DT  
        ,A.USERID  
        ,B.PUB_TYPE  
        ,A.CUID   
    FROM EV_MY_ALLPOINT_ENTRY_TB AS A  
    JOIN EV_EVENT_TB AS B ON B.EVENT_SEQ = A.EVENT_SEQ  
  
  UNION ALL  
    
  SELECT NULL AS EVENT_SEQ  
        ,'파인드올' AS PROGRESSION_SITE  
        ,'출석도장찍기' AS TITLE  
        ,NULL AS START_DT  
        ,NULL AS END_DT  
        ,A.REG_DT AS ENTRY_DT  
        ,NULL AS ANNOUNCE_DT  
        ,A.USERID  
        ,0 AS PUB_TYPE  
        ,A.CUID   
    FROM EV_ATTENDANCE_TB AS A  
    */
GO
