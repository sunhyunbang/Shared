USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_MARKETING_EVENT_MEMBER_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
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
 *  예        제 :  EXEC BAT_MM_MARKETING_EVENT_MEMBER_PROC
 *************************************************************************************/
CREATE PROC [dbo].[BAT_MM_MARKETING_EVENT_MEMBER_PROC]
AS

DELETE FROM FINDDB2.COMMON.DBO.MM_MAEKETING_EVENT_MEMBER_TB

INSERT FINDDB2.COMMON.DBO.MM_MAEKETING_EVENT_MEMBER_TB
     ( CUID, USERID, EMAIL, USER_NM, AGREE_DT, FA_SMS, FA_TM, FA_EMAIL, SERVE_SMS, SERVE_TM, SERVE_MAIL )
SELECT 
       A.CUID
     , A.USERID
     , A.EMAIL
     , A.USER_NM
     , REPLACE(CONVERT(VARCHAR(20),AGREE_DT, 120),'-','.') AS AGREE_DT
     , CASE
            WHEN FA_SMS='SMS' THEN 'Y'
            ELSE 'N'
       END AS FA_SMS     
     , CASE 
            WHEN FA_TM='TM' THEN 'Y'
            ELSE 'N'
       END AS FA_TM
     , CASE WHEN FA_JOB + FA_LAND + FA_AUTO + FA_GOODS <> '' THEN 'Y' ELSE 'N' END FA_EMAIL
     , CASE
            WHEN SERVE_SMS='SMS' THEN 'Y'
            ELSE 'N'
       END AS SERVE_SMS
     , CASE
            WHEN SERVE_TM='TM' THEN 'Y'
            ELSE 'N'
       END AS SERVE_TM
     , CASE
            WHEN SERVE_MAIL='이메일' THEN 'Y'
            ELSE 'N'
       END AS SERVE_MAIL
  FROM (
    SELECT 
           A.CUID
         , A.USERID
         , A.EMAIL
         , A.USER_NM
         , MAX(B.AGREE_DT) AS AGREE_DT
         , MAX(FA_SMS) AS FA_SMS
         , MAX(FA_TM) AS FA_TM
         , MAX(FA_JOB) AS FA_JOB
         , MAX(FA_LAND) AS FA_LAND
         , MAX(FA_AUTO) AS FA_AUTO
         , MAX(FA_GOODS) AS FA_GOODS

         , MAX(SERVE_SMS) AS SERVE_SMS
         , MAX(SERVE_TM) AS SERVE_TM
         , MAX(SERVE_MAIL) AS SERVE_MAIL

      FROM (
        SELECT A.CUID
             , A.USERID
             , A.EMAIL
             , ISNULL(A.USER_NM,'') AS USER_NM
             , CASE
                    WHEN B.MEDIA_CD='S' AND B.SECTION_CD='S101' THEN 'SMS'
                    ELSE ''
               END AS FA_SMS
             , CASE
                    WHEN B.MEDIA_CD='T' AND B.SECTION_CD='S101' THEN 'TM'
                    ELSE ''
               END AS FA_TM
             , CASE
                    WHEN B.MEDIA_CD='M' AND B.SECTION_CD='S102' THEN '구인구직'
                    ELSE ''
               END AS FA_JOB
             , CASE
                    WHEN B.MEDIA_CD='M' AND B.SECTION_CD='S103' THEN '부동산'
                    ELSE ''
               END AS FA_LAND
             , CASE
                    WHEN B.MEDIA_CD='M' AND B.SECTION_CD='S104' THEN '자동차'
                    ELSE ''
               END AS FA_AUTO
             , CASE
                    WHEN B.MEDIA_CD='M' AND B.SECTION_CD='S105' THEN '상품&서비스'
                    ELSE ''
               END AS FA_GOODS
             , CASE
                    WHEN B.MEDIA_CD='S' AND B.SECTION_CD='H001' THEN 'SMS'
                    ELSE ''
               END AS SERVE_SMS
             , CASE
                    WHEN B.MEDIA_CD='T' AND B.SECTION_CD='H001' THEN 'TM'
                    ELSE ''
               END AS SERVE_TM
             , CASE
                    WHEN B.MEDIA_CD='M' AND B.SECTION_CD='H001' THEN '이메일'
                    ELSE ''
               END AS SERVE_MAIL
          FROM CST_MASTER AS A WITH (NOLOCK)
          JOIN CST_MSG_SECTION AS B WITH (NOLOCK) ON A.CUID=B.CUID
         WHERE A.REST_YN='N'
           AND A.OUT_YN='N'
    ) AS A    
      JOIN CST_MSG_SECTION AS B WITH (NOLOCK) ON A.CUID=B.CUID   
     GROUP BY A.CUID, A.USERID, A.EMAIL, A.USER_NM
) AS A
GO
