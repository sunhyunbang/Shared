USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[BAT_REST_MEMBER_KKO_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 휴면 처리 당일 KKO 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2017/01/04
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_REST_MEMBER_KKO_PROC
 *************************************************************************************/
CREATE PROC [dbo].[BAT_REST_MEMBER_KKO_PROC]

AS

SET NOCOUNT ON

DECLARE @PHONE	varchar	(24)
DECLARE @MSG	nvarchar	(4000)
DECLARE @URL	varchar	(1000)
DECLARE @URL_BUTTON_TXT	varchar	(160)
DECLARE @FAIL_SUBJECT	varchar	(160)
DECLARE @FAIL_MSG	nvarchar	(4000)

DECLARE @PROFILE_KEY VARCHAR(100)     = '5c211bc7dcb8c6a1ee4c7b7ac865389e1115ffe2'
DECLARE @CALLBACK	varchar	(24)        = '0802690011'        -- 발신자번호
DECLARE @TEMPLATE_CODE	varchar	(10)  = 'AAFa082'           -- 카카오알림톡 템플릿 코드
--DECLARE @SENDTIME DATETIME = CONVERT(VARCHAR(10),GETDATE(),120) + ' 13:20:00.000' -- 전송일(시간) = 금일 오전 10시

SELECT @MSG = KKO_MSG
      ,@URL = URL
      ,@URL_BUTTON_TXT = URL_BUTTON_TXT
      ,@FAIL_SUBJECT = LMS_TITLE
      ,@FAIL_MSG = LMS_MSG
  FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWFa082'')') 

INSERT FINDDB1.COMDB1.dbo.KKO_MSG
      (STATUS, PHONE, CALLBACK, REQDATE, MSG, TEMPLATE_CODE, PROFILE_KEY, URL, URL_BUTTON_TXT, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, ETC1)
SELECT 
       1 AS [STATUS]
      ,REPLACE(A.HPHONE,'-','') AS PHONE
      ,@CALLBACK AS CALLBACK
      ,GETDATE() AS REQDATE
      ,REPLACE(@MSG,'#{ID}',B.USERID) AS MSG
      ,@TEMPLATE_CODE AS TEMPLATE_CODE
      ,@PROFILE_KEY AS PROFILE_KEY
      ,@URL AS URL
      ,@URL_BUTTON_TXT AS URL_BUTTON_TXT
      ,'LMS' AS FAILED_TYPE
      ,@FAIL_SUBJECT AS FAILED_SUBJECT
      ,REPLACE(@FAIL_MSG,'#{ID}',B.USERID) AS FAILED_MSG
      ,'FINDALL' AS ETC1
  FROM CST_REST_MASTER AS A WITH(NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE CONVERT(VARCHAR(10), A.ADD_DT, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)
   AND A.HPHONE IS NOT NULL
GO
