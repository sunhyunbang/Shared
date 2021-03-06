USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[sv_rets_login_pwd_rdm]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 렛츠 패스워드 키 인증
 *  작   성   자 : skh
 *  작   성   일 : 2016-09-21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 exec mwmember.dbo.sv_rets_login_pwd_rdm 13621996, '123456789abcdefghijklmnopqrstuvwxyz'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[sv_rets_login_pwd_rdm]
	@CUID			int = 0
,	@login_pwd_rdm	VARCHAR(50) = ''
AS
	SET NOCOUNT ON;

	SELECT mem_seq as CUID
	from [221.143.23.211,8019].rserve.dbo.member_employee me with(nolock)
	where mem_seq = @cuid
	and login_pwd_rdm = @login_pwd_rdm
	and type = '100901'
--	and exists(select mem_seq from [221.143.23.211,8019].cont.dbo.contract c with(nolock) where c.mem_seq = me.mem_seq and c.stat = 'O' and (c.main_svc_code in (100004,100001,100038) or (c.svc_type = '101215' and sale_price - dc_price > 0)) and convert(varchar(10),getdate(),121) between convert(varchar(10),svc_sdate,121) and convert(varchar(10),svc_edate,121))

GO
