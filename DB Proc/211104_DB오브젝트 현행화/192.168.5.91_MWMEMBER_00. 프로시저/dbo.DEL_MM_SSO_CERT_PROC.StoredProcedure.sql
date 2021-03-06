USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[DEL_MM_SSO_CERT_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : SSO 로그인 인증 TOKEN 삭제
 *  작   성   자 : 최 병 찬 (sebilia@mediawill.com)
 *  작   성   일 : 2017/08/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.DEL_MM_SSO_CERT_PROC 
 *************************************************************************************/
CREATE PROC [dbo].[DEL_MM_SSO_CERT_PROC]
AS
--10분이전 기록 삭제
DELETE FROM MM_SSO_CERT_TB
 WHERE DT<DATEADD(MI,-10,GETDATE())
GO
