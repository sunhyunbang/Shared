--use COMDB1

/*************************************************************************************  
 *  ���� ���� �� : īī���˸���/LMS/SMS �޽��� ���ø� ��������  
 *  ��   ��   �� : �� �� �� (virtualman@mediawill.com)  
 *  ��   ��   �� : 2016/09/27  
 *  ��   ��   �� :  
 *  ��   ��   �� :  
 *  ��        �� :  
 *  �� ��  �� �� :  
 *  �� ��  �� �� :   
 *  �� ��  �� �� : EXEC GET_KKO_TEMPLATE_INFO_PROC 'MWFa024'  
 *************************************************************************************/  
ALTER PROC [dbo].[GET_KKO_TEMPLATE_INFO_PROC]  
  
  @TEMPLATE_CODE VARCHAR(10)  
  
AS  
  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SET NOCOUNT ON  
  
  -- ���α׷��� �ڵ� ��ȯ�� �����ڵ�� ȥ���� ���� ó�� (2019.06.05)  
  IF LEFT(@TEMPLATE_CODE,2) = 'AA' OR LEFT(@TEMPLATE_CODE,2) = 'AB'  
    BEGIN  
      SET @TEMPLATE_CODE = 'MW'+ SUBSTRING(@TEMPLATE_CODE,3,10)  
    END  
  
  SELECT TEMPLATE_NAME  
        ,LMS_MSG  
        ,LMS_TITLE  
        ,KKO_MSG  
        ,URL_BUTTON_TXT  
        ,URL  
    FROM KKO_MSG_TEMPLATE  
   WHERE TEMPLATE_CODE = @TEMPLATE_CODE  
  