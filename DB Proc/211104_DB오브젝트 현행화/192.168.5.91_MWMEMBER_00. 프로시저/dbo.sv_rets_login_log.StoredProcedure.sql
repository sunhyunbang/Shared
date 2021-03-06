USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[sv_rets_login_log]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 렛츠 로그인 로그
 *  작   성   자 : skh
 *  작   성   일 : 2016-09-21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 

 *************************************************************************************/
CREATE PROCEDURE [dbo].[sv_rets_login_log]
	@CUID			int = 0
,	@ip				VARCHAR(15) = ''
,	@referer		VARCHAR(100) = ''
,	@host			VARCHAR(100) = ''
,	@script_name	VARCHAR(200) = ''
,	@param			VARCHAR(1000) = ''
,	@islogin		char(1) = ''
AS
	SET NOCOUNT ON;

	insert into [221.143.23.211,8019].serveplus.dbo.rets_login_log (mem_seq, ip, referer, host, script_name, [param], islogin)
	values (@CUID, @ip, @referer, @host, @script_name, @param, @islogin)
GO
