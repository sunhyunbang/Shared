--use PAPER_NEW
/*************************************************************************************
 *  단위 업무 명 : 메일 발송 대상 로그 업데이트
 *  작   성   자 : 방 순 현 
 *  작   성   일 : 2021-12-03 
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC EDIT_SEND_MAIL_DAILY_LOG_PROC '1','ADInfoEnd','0189875@NAVER.COM','2021-12-03','0000','발송신청 성공'
 *************************************************************************************/

CREATE PROC [dbo].[EDIT_SEND_MAIL_DAILY_LOG_PROC] 
 @TARGET_ID INT,
 @SENDMAIL_TYPE NVARCHAR(50),
 @EMAIL VARCHAR(100),
 @INSERT_DT VARCHAR(10),
 @RESULT_CODE VARCHAR(50),
 @RESULT_MESSAGE VARCHAR(500)
AS
BEGIN
 SET NOCOUNT ON

 
 UPDATE SEND_MAIL_DAILY_LOG_TB
 SET  
  [RESULT_CODE] = @RESULT_CODE
 ,[RESULT_MESSAGE] = @RESULT_MESSAGE
  ,[UPDATE_DT] = GETDATE()
 WHERE [TARGET_ID] = @TARGET_ID
    AND [SENDMAIL_TYPE] = @SENDMAIL_TYPE 
    AND [EMAIL] = @EMAIL 
    AND [INSERT_DT] = @INSERT_DT


END