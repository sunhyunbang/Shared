USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_ADMIN_LOGIN_LOG_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 프론트 회원 로그인 > 로그쌓기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-6-3
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 :

 *************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_MM_ADMIN_LOGIN_LOG_PROC]
   @CUID        INT
	,@USERID		  VARCHAR(50)	-- 회원아이디
	,@MAGID       VARCHAR(30)
	,@HOST			  VARCHAR(30)	-- 호스트(WWW.FINDALL.CO.KR)
	,@IP			    VARCHAR(15)	-- 회원PC_IP

AS
	-- 로그 쌓기
	INSERT DBO.MM_ADMIN_LOGIN_LOG_TB
	       (USERID, MAGID, LOGIN_DT, IP, HOST, CUID )
	VALUES 
	       (@USERID, @MAGID, GETDATE(), @IP ,@HOST, @CUID)

GO
