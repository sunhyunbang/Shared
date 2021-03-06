USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_MM_AD_AGREE_EMAIL_SEND_LOG_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅 수신동의내역 알림메일 발송 로그 수정
 *  작   성   자 : 조재성
 *  작   성   일 : 2021-03-24 
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EDIT_MM_AD_AGREE_EMAIL_SEND_LOG_PROC
 *************************************************************************************/

CREATE PROC [dbo].[EDIT_MM_AD_AGREE_EMAIL_SEND_LOG_PROC]
	@TARGET_ID INT,
	@CUID INT,
	@EMAIL VARCHAR(100),
	@RESULT_CODE VARCHAR(50),
	@RESULT_MESSAGE VARCHAR(500)
AS
BEGIN
	SET NOCOUNT ON

	UPDATE MM_AD_AGREE_EMAIL_SEND_LOG_TB
	SET 
		RESULT_CODE = @RESULT_CODE
		,RESULT_MESSAGE = @RESULT_MESSAGE
		,UPDATE_DT = GETDATE()
	WHERE	  TARGET_ID = @TARGET_ID
		  AND CUID = @CUID 
		  AND EMAIL = @EMAIL 


END
GO
