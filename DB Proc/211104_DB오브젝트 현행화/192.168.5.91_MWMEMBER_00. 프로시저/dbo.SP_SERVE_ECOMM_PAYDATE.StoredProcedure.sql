USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_SERVE_ECOMM_PAYDATE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SERVE_ECOMM_PAYDATE]
/*************************************************************************************
 *  단위 업무 명 : 써브 이컴 정보 업데이트(스케줄)
 *  작   성   자 : KJH
 *  작   성   일 : 2016-09-01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :

 *************************************************************************************/

AS 
	SET NOCOUNT ON;
	
	truncate table MWMEMBER.DBO.SERVE_ECOMM_PAYDATE
	
	insert into MWMEMBER.DBO.SERVE_ECOMM_PAYDATE
	select B.mem_seq,convert(datetime,left(max(B.pay_date),8)) as max_pay_date from 
	[221.143.23.211,8019].cont.dbo.contract A join
	[221.143.23.211,8019].cont.dbo.contract_payment B on A.cont_seq=B.cont_seq
	where B.STAT='100802' and B.pay_msg2<>'' 
	and A.stat='O'
	group by B.mem_seq
	
	
GO
