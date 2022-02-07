--use PAPER_NEW
/*************************************************************************************
 *  ���� ���� �� : ���� �߼� ��� �α� ������Ʈ
 *  ��   ��   �� : �� �� �� 
 *  ��   ��   �� : 2021-12-03 
 *  ��   ��   �� : 
 *  ��   ��   �� : 
 *  �� ��  �� �� : 
 *  ��        �� :
 *  �� ��  �� �� :
 *  �� ��  �� �� :
 *  �� ��  �� �� : EXEC EDIT_SEND_MAIL_DAILY_LOG_PROC '1','ADInfoEnd','0189875@NAVER.COM','2021-12-03','0000','�߼۽�û ����'
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