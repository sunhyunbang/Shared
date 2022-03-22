--use paper_new
/*************************************************************************************  
 *  ���� ���� �� : ���μ��� > �Ի�������Ȳ > �Ի����� ���  
 *  ��   ��   �� : �輺��  
 *  ��   ��   �� : 2013/11/20  
 *  ��        �� :  
 *  �� ��  �� �� :  
 *  ��   ��   �� :  
 *  ��   ��   �� :  
 *  �� ��  �� �� :  
 *  �� ��  �� �� :  
 *  �� ��  �� �� : EXEC MOD_F_PG_APP_MAIN_TB_PROC 97  
   
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
  
 --���� �Ի����� ����� ��� �����ߴ� ȸ���� ����ڿ��� �Ի����� ��ҹ��� �߼�  
 --IF @APP_TYPE = 3  
  IF @APP_GBN = 'online' OR @APP_GBN = 'email' OR @APP_GBN = 'sms'  
 BEGIN  
  DECLARE @REQTIME VARCHAR(20)  
  DECLARE @MSG VARCHAR(1000)  
  
  DECLARE @USER_NM VARCHAR(30)  
  DECLARE @SEX VARCHAR(2)  
  DECLARE @JUMIN_A VARCHAR(8)  
  
  SELECT @USER_NM = USER_NM,  
   @SEX = CASE SEX WHEN 'M' THEN '��' ELSE '��' END,  
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
  
    SET @LMS_MSG = REPLACE(@LMS_MSG, '#{ȸ���}', @COM_NM)  
    SET @LMS_MSG = REPLACE(@LMS_MSG, '#{�����ڸ�}', @USER_NM)  
    SET @LMS_MSG = REPLACE(@LMS_MSG, '#{�Ի����� �����}', CONVERT(VARCHAR(20), GETDATE(), 120))  
    SET @LMS_MSG = REPLACE(@LMS_MSG, '#{��һ���}', @CANCEL_REASON)  
  
    SET @KKO_MSG = REPLACE(@KKO_MSG, '#{ȸ���}', @COM_NM)  
    SET @KKO_MSG = REPLACE(@KKO_MSG, '#{�����ڸ�}', @USER_NM)  
    SET @KKO_MSG = REPLACE(@KKO_MSG, '#{�Ի����� �����}', CONVERT(VARCHAR(20), GETDATE(), 120))  
    SET @KKO_MSG = REPLACE(@KKO_MSG, '#{��һ���}', @CANCEL_REASON)  
  
    IF @APP_GBN = 'online'  
    BEGIN  
      SET @LMS_MSG = REPLACE(@LMS_MSG, '#{�������}', '�¶���')  
      SET @KKO_MSG = REPLACE(@KKO_MSG, '#{�������}', '�¶���')  
    END  
    IF @APP_GBN = 'email'  
    BEGIN  
      SET @LMS_MSG = REPLACE(@LMS_MSG, '#{�������}', '�̸���')       SET @KKO_MSG = REPLACE(@KKO_MSG, '#{�������}', '�̸���')  
    END  
    IF @APP_GBN = 'sms'  
    BEGIN  
      SET @LMS_MSG = REPLACE(@LMS_MSG, '#{�������}', '����')       SET @KKO_MSG = REPLACE(@KKO_MSG, '#{�������}', '����')  
    END  
  
    -- īī���� �߼�  
    -- �Ի������ڿ��� �Ի����� �Ϸ� �߼�  
    EXEC FINDDB1.COMDB1.dbo.PUT_SENDKAKAO_PROC @COM_MANAGER_MOBILE_NUM, '02-2187-7867', 'MWFa066', @KKO_MSG, @KKO_URL, @KKO_URL_BTN_TXT, @LMS_TITLE, @LMS_MSG, '', '', ''  
  
 END  
  
 IF @@ERROR <> 0  
  RETURN -1  
 ELSE  
  RETURN 1  