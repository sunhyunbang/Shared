--use COMDB1
/*************************************************************************************  
 *  ���� ���� �� : īī�� �޽��� �߼�  
 *  ��   ��   �� : �� �� �� (sebilia@mediawill.com)  
 *  ��   ��   �� : 2016/09/27  
 *  ��   ��   �� : �輱ȣ  
 *  ��   ��   �� : 2022/01/19  
 *  ��        �� :   
 *  �� ��  �� �� :  
 *  �� ��  �� �� :   
 *  �� ��  �� �� : EXEC PUT_SENDKAKAO_PROC_BK02 '01097710323','0802690011','MWFa084','[�������]   
[�׽�Ʈ]ȸ����, �̷¼� ������ ���� ��������� ���� [����-����] �ǰ� �ֽ��ϴ�.   
* �ѽ���ȣ : 070-4275-5167   
* �̸��� : info@findall.co.kr   
�� ������ 080-269-0011   
�� ������� �ٷΰ��� : https://cqc39.app.goo.gl/JSJA','https://cqc39.app.goo.gl/Ueky','������� �ٷΰ���','[���ͳݺ������]',  
'[�������]   
[�׽�Ʈ]ȸ����, �̷¼� ������ ���� ��������� ���� [����-����] �ǰ� �ֽ��ϴ�.   
* �ѽ���ȣ : 070-4275-5167   
* �̸��� : info@findall.co.kr   
�� ������ 080-269-0011   
�� ������� �ٷΰ��� : https://cqc39.app.goo.gl/JSJA'   
  
  
 *************************************************************************************/  
ALTER PROC [dbo].[PUT_SENDKAKAO_PROC]  
        @PHONE           VARCHAR(24)  --������ ��ȭ��ȣ  
      , @CALLBACK        VARCHAR(24)  --�۽��� ��ȭ��ȣ  
      , @TEMPLATE_CODE   VARCHAR(10)  --�˸��� ���ø� �ڵ�  
      , @MSG             VARCHAR(4000) --�˸��� �߼� �޽���  
      , @URL             VARCHAR(1000)  --�˸��� ��ư URL  
      , @URL_BUTTON_TXT  VARCHAR(160)   --�˸��� ��ư TEXT  
  
      , @FAIL_SUBJECT    VARCHAR(160)   --�˸��� ���н� ���� ����  
      , @FAIL_MSG        VARCHAR(4000)  --�˸��� ���н� ���� ����  
  
      , @PROFILE_KEY     VARCHAR(100) = ''   --���ο� ���̵� ��������Ű  
      , @REQDATE         DATETIME     = NULL  
      , @SENDID          VARCHAR(50)  = '' --�߽���  
AS  
  
SET NOCOUNT ON  
  
IF @PROFILE_KEY = '' OR @PROFILE_KEY IS NULL  
  SET @PROFILE_KEY = '5c211bc7dcb8c6a1ee4c7b7ac865389e1115ffe2'  
  
IF @SENDID = '' OR @SENDID IS NULL  
  SET @SENDID = 'FINDALL'  
  
IF @REQDATE = '' OR @REQDATE IS NULL   
  SET @REQDATE = GETDATE()  
  
DECLARE @TEMP_CODE VARCHAR(10)  

IF LEFT(@TEMPLATE_CODE,2) = 'AA' OR LEFT(@TEMPLATE_CODE,2) = 'AB'  
BEGIN  
  SET @TEMPLATE_CODE = 'MW'+ SUBSTRING(@TEMPLATE_CODE,3,10)  
END  
  
SELECT @TEMP_CODE = TEMPLATE_CODE_2019  
  FROM KKO_MSG_TEMPLATE A WITH(NOLOCK)  
 WHERE TEMPLATE_CODE = @TEMPLATE_CODE  


  
IF NOT EXISTS(SELECT * FROM KKO_MSG_USER_EXCEPTION_TB WITH(NOLOCK) WHERE PHONE  = REPLACE(@PHONE,'-','') AND TEMPLATE_CODE = @TEMPLATE_CODE)   
BEGIN  
 INSERT KKO_MSG  
   ( STATUS, PHONE, CALLBACK, REQDATE, MSG, TEMPLATE_CODE, PROFILE_KEY, URL, URL_BUTTON_TXT, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, ETC1)  
 VALUES  
   ( 1, REPLACE(@PHONE,'-',''), REPLACE(@CALLBACK,'-',''), @REQDATE, @MSG, @TEMP_CODE, @PROFILE_KEY, @URL, @URL_BUTTON_TXT, 'LMS', @FAIL_SUBJECT, @FAIL_MSG, @SENDID )  
END  
ELSE  
BEGIN  
 INSERT KKO_MSG_EXCEPTION  
   ( STATUS, PHONE, CALLBACK, REQDATE, MSG, TEMPLATE_CODE, PROFILE_KEY, URL, URL_BUTTON_TXT, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, ETC1)  
 VALUES  
   ( 1, REPLACE(@PHONE,'-',''), REPLACE(@CALLBACK,'-',''), @REQDATE, @MSG, @TEMP_CODE, @PROFILE_KEY, @URL, @URL_BUTTON_TXT, 'LMS', @FAIL_SUBJECT, @FAIL_MSG, @SENDID )  
END