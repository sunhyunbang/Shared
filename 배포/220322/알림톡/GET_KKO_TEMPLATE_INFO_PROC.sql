--use COMDB1

/*************************************************************************************  
 *  단위 업무 명 : 카카오알림톡/LMS/SMS 메시지 템플릿 가져오기  
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)  
 *  작   성   일 : 2016/09/27  
 *  수   정   자 :  
 *  수   정   일 :  
 *  설        명 :  
 *  주 의  사 항 :  
 *  사 용  소 스 :   
 *  사 용  예 제 : EXEC GET_KKO_TEMPLATE_INFO_PROC 'MWFa024'  
 *************************************************************************************/  
ALTER PROC [dbo].[GET_KKO_TEMPLATE_INFO_PROC]  
  
  @TEMPLATE_CODE VARCHAR(10)  
  
AS  
  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SET NOCOUNT ON  
  
  -- 프로그램단 코드 변환전 기존코드와 혼용을 위한 처리 (2019.06.05)  
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
  