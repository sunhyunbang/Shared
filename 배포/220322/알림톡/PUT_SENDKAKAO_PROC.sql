--use COMDB1
/*************************************************************************************  
 *  단위 업무 명 : 카카오 메시지 발송  
 *  작   성   자 : 최 병 찬 (sebilia@mediawill.com)  
 *  작   성   일 : 2016/09/27  
 *  수   정   자 : 김선호  
 *  수   정   일 : 2022/01/19  
 *  설        명 :   
 *  주 의  사 항 :  
 *  사 용  소 스 :   
 *  사 용  예 제 : EXEC PUT_SENDKAKAO_PROC_BK02 '01097710323','0802690011','MWFa084','[벼룩시장]   
[테스트]회원님, 이력서 열람을 위한 기업인증이 지연 [사유-거절] 되고 있습니다.   
* 팩스번호 : 070-4275-5167   
* 이메일 : info@findall.co.kr   
※ 고객센터 080-269-0011   
※ 벼룩시장 바로가기 : https://cqc39.app.goo.gl/JSJA','https://cqc39.app.goo.gl/Ueky','벼룩시장 바로가기','[인터넷벼룩시장]',  
'[벼룩시장]   
[테스트]회원님, 이력서 열람을 위한 기업인증이 지연 [사유-거절] 되고 있습니다.   
* 팩스번호 : 070-4275-5167   
* 이메일 : info@findall.co.kr   
※ 고객센터 080-269-0011   
※ 벼룩시장 바로가기 : https://cqc39.app.goo.gl/JSJA'   
  
  
 *************************************************************************************/  
ALTER PROC [dbo].[PUT_SENDKAKAO_PROC]  
        @PHONE           VARCHAR(24)  --수신자 전화번호  
      , @CALLBACK        VARCHAR(24)  --송신자 전화번호  
      , @TEMPLATE_CODE   VARCHAR(10)  --알림톡 템플릿 코드  
      , @MSG             VARCHAR(4000) --알림톡 발송 메시지  
      , @URL             VARCHAR(1000)  --알림톡 버튼 URL  
      , @URL_BUTTON_TXT  VARCHAR(160)   --알림톡 버튼 TEXT  
  
      , @FAIL_SUBJECT    VARCHAR(160)   --알림톡 실패시 문자 제목  
      , @FAIL_MSG        VARCHAR(4000)  --알림톡 실패시 문자 내용  
  
      , @PROFILE_KEY     VARCHAR(100) = ''   --옐로우 아이디 프로파일키  
      , @REQDATE         DATETIME     = NULL  
      , @SENDID          VARCHAR(50)  = '' --발신자  
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