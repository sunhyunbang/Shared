--use paper_new
/*************************************************************************************  
 *  단위 업무 명 : 개인서비스 > 입사지원현황 > 입사지원 취소  
 *  작   성   자 : 김성준  
 *  작   성   일 : 2013/11/20  
 *  설        명 :  
 *  주 의  사 항 :  
 *  수   정   자 :  
 *  수   정   일 :  
 *  수 정  내 용 :  
 *  사 용  소 스 :  
 *  사 용  예 제 : EXEC MOD_F_PG_APP_MAIN_TB_PROC 97  
   
 exec MOD_F_PG_APP_MAIN_TB_PROC 44664  
 *************************************************************************************/  
CREATE PROCEDURE [dbo].[MOD_F_PG_APP_MAIN_TB_PROC]  
(  
 @APP_ID INT  
 , @CUID INT  
)  
AS  
SET NOCOUNT ON  
  
 DECLARE @APP_TYPE TINYINT  
 DECLARE @TEL VARCHAR(16)  
 DECLARE @RESUME_ID INT  
  DECLARE @LINEADID INT  
  DECLARE @INPUT_BRANCH TINYINT  
  DECLARE @LAYOUT_BRANCH TINYINT  
  DECLARE @COM_MANAGER_MOBILE_NUM VARCHAR(16)  
  DECLARE @COM_NM VARCHAR(50)  
  DECLARE @APP_GBN VARCHAR(20)  
  DECLARE @LINEADNO CHAR(16)  
  DECLARE @CANCEL_REASON VARCHAR(60)  
    
  
 SELECT @APP_TYPE = APP_TYPE, @TEL = TEL, @RESUME_ID = RESUME_ID, @LINEADID = LINEADID, @INPUT_BRANCH = INPUT_BRANCH, @LAYOUT_BRANCH = LAYOUT_BRANCH  
       , @APP_GBN = APP_GBN  
       , @LINEADNO = LINEADNO 
       , @CANCEL_REASON = CANCEL_REASON
 FROM dbo.PG_APP_MAIN_TB  
 WHERE APP_ID = @APP_ID  
   AND CUID = @CUID  
    
 UPDATE dbo.PG_APP_MAIN_TB  
 SET APP_STATUS = 'N',  
  MOD_DT = GETDATE()  
 WHERE APP_ID = @APP_ID  
   AND CUID = @CUID  
  
 --문자 입사지원 취소의 경우 지원했던 회사의 담당자에게 입사지원 취소문자 발송  
 --IF @APP_TYPE = 3  
  IF @APP_GBN = 'online' OR @APP_GBN = 'email' OR @APP_GBN = 'sms'  
 BEGIN  
  DECLARE @REQTIME VARCHAR(20)  
  DECLARE @MSG VARCHAR(1000)  
  
  DECLARE @USER_NM VARCHAR(30)  
  DECLARE @SEX VARCHAR(2)  
  DECLARE @JUMIN_A VARCHAR(8)  
  
  SELECT @USER_NM = USER_NM,  
   @SEX = CASE SEX WHEN 'M' THEN '남' ELSE '여' END,  
   @JUMIN_A =  
    YEAR(GETDATE()) - YEAR(CONVERT(DATETIME, JUMIN_A)) -  
    CASE  
     WHEN MONTH(GETDATE()) < MONTH(CONVERT(DATETIME, JUMIN_A)) THEN -1  
     WHEN MONTH(GETDATE()) = MONTH(CONVERT(DATETIME, JUMIN_A)) AND DAY(GETDATE()) < DAY(CONVERT(DATETIME, JUMIN_A)) THEN -1  
     ELSE 0  
    END  
  FROM dbo.PG_RESUME_MAIN_TB  
  WHERE RESUME_ID = @RESUME_ID  
  
    SELECT @COM_MANAGER_MOBILE_NUM = B.MOBILE  
         , @COM_NM = A.FIELD_6  
      FROM PP_AD_TB A (NOLOCK)  
      JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_TB B (NOLOCK) ON A.LINEADNO = B.LINEADNO  
     WHERE A.LINEADID = @LINEADID  
       AND A.INPUT_BRANCH = @INPUT_BRANCH  
       AND A.LAYOUT_BRANCH = @LAYOUT_BRANCH  
  
  SET @REQTIME = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(20), DATEADD(SS, 5, GETDATE()), 120), '-', ''), ' ', ''), ':', '')  
  
  
    DECLARE @LMS_TITLE VARCHAR(160)  
          , @LMS_MSG VARCHAR(4000)  
          , @KKO_MSG VARCHAR(4000)  
          , @KKO_URL VARCHAR(1000)  
          , @KKO_URL_BTN_TXT VARCHAR(160)  
  
    SELECT @LMS_TITLE = LMS_TITLE  
         , @LMS_MSG = LMS_MSG  
         , @KKO_MSG = KKO_MSG  
         , @KKO_URL = URL  
         , @KKO_URL_BTN_TXT = URL_BUTTON_TXT  
      FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO('MWFa066')        
  
    SET @LMS_MSG = REPLACE(@LMS_MSG, '#{회사명}', @COM_NM)  
    SET @LMS_MSG = REPLACE(@LMS_MSG, '#{지원자명}', @USER_NM)  
    SET @LMS_MSG = REPLACE(@LMS_MSG, '#{입사지원 취소일}', CONVERT(VARCHAR(20), GETDATE(), 120))  
    SET @LMS_MSG = REPLACE(@LMS_MSG, '#{취소사유}', @CANCEL_REASON)  
  
    SET @KKO_MSG = REPLACE(@KKO_MSG, '#{회사명}', @COM_NM)  
    SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원자명}', @USER_NM)  
    SET @KKO_MSG = REPLACE(@KKO_MSG, '#{입사지원 취소일}', CONVERT(VARCHAR(20), GETDATE(), 120))  
    SET @KKO_MSG = REPLACE(@KKO_MSG, '#{취소사유}', @CANCEL_REASON)  
  
    IF @APP_GBN = 'online'  
    BEGIN  
      SET @LMS_MSG = REPLACE(@LMS_MSG, '#{지원방법}', '온라인')  
      SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원방법}', '온라인')  
    END  
    IF @APP_GBN = 'email'  
    BEGIN  
      SET @LMS_MSG = REPLACE(@LMS_MSG, '#{지원방법}', '이메일')       SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원방법}', '이메일')  
    END  
    IF @APP_GBN = 'sms'  
    BEGIN  
      SET @LMS_MSG = REPLACE(@LMS_MSG, '#{지원방법}', '문자')       SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원방법}', '문자')  
    END  
  
    -- 카카오톡 발송  
    -- 입사지원자에게 입사지원 완료 발송  
    EXEC FINDDB1.COMDB1.dbo.PUT_SENDKAKAO_PROC @COM_MANAGER_MOBILE_NUM, '02-2187-7867', 'MWFa066', @KKO_MSG, @KKO_URL, @KKO_URL_BTN_TXT, @LMS_TITLE, @LMS_MSG, '', '', ''  
  
 END  
  
 IF @@ERROR <> 0  
  RETURN -1  
 ELSE  
  RETURN 1  