USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[MW_CST_MASTER_S2]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
*객체이름 : 통합회원DB로 써브회원DB 조회 - 회원정보
*파라미터 : 
*제작자 : kjh
*버젼 :
*제작일 : 2016.08.17
*변경일 :
*그외 :		
*실행예제 : 
			exec dbo.MW_CST_MASTER_S2 13783576
****************************************************************************************************/

CREATE PROCEDURE [dbo].[MW_CST_MASTER_S2]

	@CUID		int = 0

AS
	set nocount on
	SET TRANSACTION ISOLATION LEVEL READ uncommitted
BEGIN


	SELECT	e.emp_seq
			, e.name, m.name br_name, m.phone br_phone, isnull(m.homepage,'') br_homepage
			, m.mem_type
			, (select top 1 main_svc_code from [221.143.23.211,8019].cont.dbo.contract c with(nolock) 
				join [221.143.23.211,8019].rserve.dbo.service s with(nolock) on s.svc_code = c.main_svc_code 
				where c.mem_seq = m.mem_seq and (c.svc_type in (101202,101211,101219,101227,101229,101230) or c.main_svc_code = 100004) and c.stat = 'O' and convert(varchar(10),getdate(),121) between convert(varchar(10),c.svc_sdate,121) and convert(varchar(10),c.svc_edate,121) order by serve_svc_code desc) svc_code
			, agencyYN
	FROM
		MWMEMBER.DBO.CST_MASTER A with(nolock) 
		join [221.143.23.211,8019].rserve.dbo.member m with (nolock)on A.CUID=m.mem_seq
		join [221.143.23.211,8019].rserve.dbo.member_employee e with (nolock) ON m.mem_seq = e.mem_seq and e.type = '100901' and e.stat = '101101'	--사장
		left outer join [221.143.23.211,8019].rserve.dbo.member_branch mb with (nolock) ON m.mem_seq = mb.mem_seq	--가맹점
	WHERE m.mem_seq = @CUID	

END




GO
