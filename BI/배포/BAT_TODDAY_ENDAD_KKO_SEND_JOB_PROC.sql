  
  
/*************************************************************************************  
 *  단위 업무 명 : 구인 금일 종료공고 카카오 알림톡 발송  
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)  
 *  작   성   일 : 2016/09/28  
 *  수   정   자 :  
 *  수   정   일 :  
 *  설        명 :  
 *  주 의  사 항 :  
 *  사 용  소 스 :   
 *  사 용  예 제 : EXEC dbo.BAT_TODDAY_ENDAD_KKO_SEND_JOB_PROC  
 *************************************************************************************/  
  
  
alter PROC [dbo].[BAT_TODDAY_ENDAD_KKO_SEND_JOB_PROC]  
  
  
AS  
  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SET NOCOUNT ON  
  
  DECLARE @PHONE varchar (24)  
  DECLARE @MSG nvarchar (4000)  
  DECLARE @URL varchar (1000)  
  DECLARE @URL_BUTTON_TXT varchar (160)  
  DECLARE @FAIL_SUBJECT varchar (160)  
  DECLARE @FAIL_MSG nvarchar (4000)  
  
  DECLARE @PROFILE_KEY VARCHAR(100)     = '5c211bc7dcb8c6a1ee4c7b7ac865389e1115ffe2'  
  DECLARE @CALLBACK varchar (24)        = '0802690011'        -- 발신자번호  
  DECLARE @TEMPLATE_CODE varchar (10)  = 'MWFa021'           -- 카카오알림톡 템플릿 코드  
  DECLARE @SENDTIME DATETIME = CONVERT(VARCHAR(10),GETDATE(),120) + ' 13:10:00.000' -- 전송일(시간) = 금일 오전 10시  
  
  -- 금일 유료옵션 종료 공고 추출  
 SELECT A.LINEADID  
        ,CONVERT(VARCHAR(10),B.OPT_END_DT,120) AS OPT_END_DT  
        ,dbo.FN_INETOPTNAME(B.OPT_CODE,B.MOBILE_OPT_CODE,0,14) AS INETOPTNAME  
        ,A.CUID  
        ,A.TITLE  
        ,MB.COM_NM  
        ,MA.HPHONE  
        ,A.REG_DT
        ,A.START_DT
        ,A.END_DT
    INTO #MMS_TMP_TB  
  FROM PP_AD_TB A WITH(NOLOCK)  
   JOIN PP_OPTION_TB B WITH(NOLOCK) ON A.LINEADNO = B.LINEADNO  
   JOIN PP_ECOMM_RECCHARGE_TB C WITH(NOLOCK) ON A.LINEADID = C.ADID AND PRODUCT_GBN = 1  
   JOIN MEMBERDB.MWMEMBER.dbo.CST_MASTER AS MA WITH(NOLOCK) ON MA.CUID = A.CUID  
   JOIN MEMBERDB.MWMEMBER.dbo.CST_COMPANY AS MB WITH(NOLOCK) ON MB.COM_ID = MA.COM_ID  
  WHERE GROUP_CD = 14  
   AND [VERSION] ='E'  
   AND C.PRNAMTOK = 1  
   AND A.INPUT_BRANCH <> 181 --정액권제외  
   AND (A.USER_ID != 'NOMEMBER' AND A.USER_ID != 'A2013' AND A.USER_ID != '')  
   AND B.OPT_END_DT >= CONVERT(VARCHAR(10),GETDATE(),120)  
   AND B.OPT_END_DT < CONVERT(VARCHAR(10),GETDATE()+1,120)  
   AND A.DELYN ='N'  
   AND A.ENDYN='N'  
  
  -- 전송 메시지 가공  
  SELECT @MSG = KKO_MSG  
        ,@URL = URL  
        ,@URL_BUTTON_TXT = URL_BUTTON_TXT  
        ,@FAIL_SUBJECT = LMS_TITLE  
        ,@FAIL_MSG = LMS_MSG  
    FROM COMDB1.dbo.FN_GET_KKO_TEMPLATE_INFO(@TEMPLATE_CODE)  

  
  -- 카카오 알림톡 저장  
  INSERT COMDB1.dbo.KKO_MSG  
    (STATUS, PHONE, CALLBACK, REQDATE, MSG, TEMPLATE_CODE, PROFILE_KEY, URL, URL_BUTTON_TXT, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, ETC1)  
  SELECT 1 AS [STATUS]  
        ,REPLACE(HPHONE,'-','') AS PHONE  
        ,@CALLBACK AS CALLBACK  
        ,@SENDTIME AS REQDATE  
        ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@MSG,'#{회사명}', COM_NM),'#{제목}',TITLE),'#{광고번호}',LINEADID), '#{공고제목}',TITLE),'#{공고번호}',LINEADID),'#{등록일}',REG_DT),'#{YYYY-MM-DD ~ YYYY-MM-DD}',CONVERT(VARCHAR(10), START_DT ,120) + ' ~ ' +CONVERT(VARCHAR(10), END_DT ,120)),'#{day}',DATEDIFF(D,START_DT,END_DT))  AS MSG  
        ,'AA'+RIGHT(@TEMPLATE_CODE,5) AS TEMPLATE_CODE  
        ,@PROFILE_KEY AS PROFILE_KEY  
        ,@URL AS URL  
        ,@URL_BUTTON_TXT AS URL_BUTTON_TXT  
        ,'LMS' AS FAILED_TYPE  
        ,@FAIL_SUBJECT AS FAILED_SUBJECT  
        ,REPLACE(REPLACE(REPLACE(@FAIL_MSG,'#{회사명}', COM_NM),'#{title}',TITLE),'#{광고번호}',LINEADID) AS FAILED_MSG  
        ,'FINDALL' AS ETC1  
    FROM #MMS_TMP_TB  
