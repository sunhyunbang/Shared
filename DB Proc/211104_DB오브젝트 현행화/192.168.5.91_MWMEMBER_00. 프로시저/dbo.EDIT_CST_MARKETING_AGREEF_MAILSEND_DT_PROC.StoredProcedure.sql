USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_CST_MARKETING_AGREEF_MAILSEND_DT_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅 수신동의내역 알림메일 발송일 업데이트
 *  작   성   자 : 조재성
 *  작   성   일 : 2021-03-25 
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EDIT_CST_MARKETING_AGREEF_MAILSEND_DT_PROC
 *************************************************************************************/

CREATE PROC [dbo].[EDIT_CST_MARKETING_AGREEF_MAILSEND_DT_PROC]
	@TARGET_ID INT
AS
BEGIN
	SET NOCOUNT ON

	UPDATE CST_MARKETING_AGREEF_TB
	SET MAILSEND_DT = GETDATE()
	FROM CST_MARKETING_AGREEF_TB A
		INNER JOIN (SELECT CUID,RESULT_CODE FROM MM_AD_AGREE_EMAIL_SEND_LOG_TB WHERE TARGET_ID=@TARGET_ID) B
			ON A.CUID=B.CUID
	WHERE B.RESULT_CODE='0000'


END
GO
