USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_SENDBILL_BIZNO_ACCESS_ERROR_LOG_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 센드빌 사업자등록번호체크 API 접근오류 로그 수집 저장
 *  작   성   자 : 조 재 성
 *  작   성   일 : 2021/09/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_SENDBILL_BIZNO_ACCESS_ERROR_LOG_PROC]
	@BIZNO CHAR(10),
	@DOMAIN VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO MWMEMBER.DBO.PP_SENDBILL_BIZNO_ACCESS_ERROR_LOG_TB
(BIZNO,DOMAIN) 
VALUES
(@BIZNO,@DOMAIN);
GO
