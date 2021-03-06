USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_PP_AD_AGREE_EMAIL_RECEIVE_LIST_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅,이벤트 정보 수신 동의 안내 메일 대상자 목록
 *  작   성   자 : 조재성
 *  작   성   일 : 2021/03/23
 *  수   정   자 :
 *  수   정   일 :
 *  설         명 : 
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : GET_F_PP_AD_AGREE_EMAIL_RECEIVE_LIST_PROC
 *************************************************************************************/ 
CREATE PROCEDURE [dbo].[GET_F_PP_AD_AGREE_EMAIL_RECEIVE_LIST_PROC]
AS	

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
	
	SELECT	A.CUID
			,(CASE WHEN CHARINDEX('%',B.USER_NM) > 0 THEN B.USERID ELSE B.USER_NM END) USER_NM
			,B.EMAIL
			,(CASE WHEN A.MAILSEND_DT IS NULL OR A.AGREE_DT > A.MAILSEND_DT THEN A.AGREE_DT ELSE A.MAILSEND_DT END) AGREE_DT
	FROM CST_MARKETING_AGREEF_TB A 
		INNER JOIN CST_MASTER B
			ON A.CUID = B.CUID
	WHERE
			A.AGREEF = '1'
		AND B.REST_YN = 'N'
		AND B.OUT_YN = 'N'
		AND (B.EMAIL IS NOT NULL AND B.EMAIL <> '')
		AND DATEADD(D,730,(CASE WHEN A.MAILSEND_DT IS NULL OR A.AGREE_DT > A.MAILSEND_DT THEN A.AGREE_DT ELSE A.MAILSEND_DT END)) < CONVERT(CHAR(10),GETDATE(),21) + ' 23:59:59'

		
GO
