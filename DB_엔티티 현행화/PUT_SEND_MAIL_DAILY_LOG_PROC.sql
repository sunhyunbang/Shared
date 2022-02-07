--use PAPER_NEW

/*************************************************************************************
 *  단위 업무 명 : 메일 발송 대상 로그
 *  작   성   자 : 방 순 현 
 *  작   성   일 : 2021-12-03 
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC PUT_SEND_MAIL_DAILY_LOG_PROC '1','ADInfoEnd','방순현','0189875@NAVER.COM','0000','발송신청 성공'
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



 -- 에러가 발생했을 경우는 에러번호를 리턴해주고
 IF ( @@ERROR <> 0 )
 BEGIN
  SET NOCOUNT OFF
  ROLLBACK TRAN
  RETURN (2)
 END
 -- 그렇지 않은 경우는 0을 리턴
 ELSE
 BEGIN
  SET NOCOUNT OFF
  COMMIT TRAN
  RETURN (1)
 END
END

