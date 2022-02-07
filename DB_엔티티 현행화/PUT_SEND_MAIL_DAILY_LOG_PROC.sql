--use PAPER_NEW

/*************************************************************************************
 *  ���� ���� �� : ���� �߼� ��� �α�
 *  ��   ��   �� : �� �� �� 
 *  ��   ��   �� : 2021-12-03 
 *  ��   ��   �� : 
 *  ��   ��   �� : 
 *  �� ��  �� �� : 
 *  ��        �� :
 *  �� ��  �� �� :
 *  �� ��  �� �� :
 *  �� ��  �� �� : EXEC PUT_SEND_MAIL_DAILY_LOG_PROC '1','ADInfoEnd','�����','0189875@NAVER.COM','0000','�߼۽�û ����'
 *************************************************************************************/
CREATE PROC [dbo].[PUT_SEND_MAIL_DAILY_LOG_PROC]
 @TARGET_ID INT,
 @SENDMAIL_TYPE VARCHAR(50),
 @USER_NM VARCHAR(50),
 @EMAIL VARCHAR(100),
 @RESULT_CODE VARCHAR(50),
 @RESULT_MESSAGE VARCHAR(500)
AS
BEGIN
 SET NOCOUNT ON


 DECLARE @V_INSERT_DT VARCHAR(10)
 SET @V_INSERT_DT =  CONVERT(CHAR(10), GETDATE(), 23)

 BEGIN TRAN

  INSERT INTO SEND_MAIL_DAILY_LOG_TB ([TARGET_ID],[USER_NM],[EMAIL],[SENDMAIL_TYPE],[INSERT_DT],[RESULT_CODE],[RESULT_MESSAGE])
  VALUES (@TARGET_ID,  @USER_NM, @EMAIL, @SENDMAIL_TYPE, @V_INSERT_DT, @RESULT_CODE, @RESULT_MESSAGE)



 -- ������ �߻����� ���� ������ȣ�� �������ְ�
 IF ( @@ERROR <> 0 )
 BEGIN
  SET NOCOUNT OFF
  ROLLBACK TRAN
  RETURN (2)
 END
 -- �׷��� ���� ���� 0�� ����
 ELSE
 BEGIN
  SET NOCOUNT OFF
  COMMIT TRAN
  RETURN (1)
 END
END

