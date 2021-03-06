USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_MEMBER_CHANGE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****************************************************************************************************
*객체이름 : 회원 이동 
*파라미터 : 	
*제작자 : KJH
*버젼 :
*제작일 : 2016.08.30
*변경일 :
*그외 : 
*실행예제 : exec dbo.SP_MEMBER_CHANGE 11111,22222,''
****************************************************************************************************/

CREATE PROC [dbo].[SP_MEMBER_CHANGE]
	@AS_CUID	int
,	@TO_CUID	int
,	@IP			varchar(20)
AS
	SET nocount ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	--히스토리 남김
	
	insert into MWMEMBER.dbo.MEMBER_CHANGE_HIST (AS_CUID,TO_CUID,IP,regdate) values (@AS_CUID,@TO_CUID,@IP,GETDATE())
	


	--1. cont
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].cont.dbo.Contract A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE B.CUID=@AS_CUID

	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].cont.dbo.Contract_payment A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].cont.dbo.tbl_promo_history A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].cont.dbo.vest_staff_hist A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID

	--2. rserve
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.agency_calendar A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.agency_info A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
		
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_board A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_countVisitor A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_countVisitor_history A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
					
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_etc A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_log_daily A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_manage_link A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_mapxy_hist A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_menu A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_notice A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_popup A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_startpage A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
					
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_svcMenu A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
		
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.iso_member_mail A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.manageLinkData A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_addr A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_branch A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_employee A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_memo A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_message A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
		
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_mobile_apikey A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_newbrn_Active A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_newbrn_Active A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_person A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_staff A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_url A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_photo A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_terms A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
					
	
	--3. good
	
	
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_Bestgood A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_branchgoodcnt A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
		
	UPDATE A SET goodreg_id=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_checkgood A JOIN mwmember.dbo.cst_master B On A.goodreg_id = B.CUID WHERE CUID=@AS_CUID
		
	UPDATE A SET goodreg_id=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_good A JOIN mwmember.dbo.cst_master B On A.goodreg_id = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_good_cont A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_good_jehu_notin A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.TBL_MEMTYPE A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET goodReg_id=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_scrap_complex A JOIN mwmember.dbo.cst_master B On A.goodReg_id = B.CUID WHERE CUID=@AS_CUID
			

	--4. iso_member

	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].iso_member.dbo.iso_history A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].iso_member.dbo.member A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].iso_member.dbo.member_branch A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].iso_member.dbo.member_employee A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
						

	--5. naver
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_chkmaemul_ngood A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_fax_contract A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_fax_hist A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_faxfail_sms A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_ngood A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_ngood_clean_info A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_ngood_variation_hist A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_promo_paydate A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	
	
	--6. banner
		
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].banner.dbo.BranchBanner_confirm A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID		
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].banner.dbo.BranchBanner A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID		
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].banner.dbo.bannerInfo A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID		
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].banner.dbo.advertiserInfo A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID	
	
	
	--7. chk
		
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].chk.dbo.member_email A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID	
	
	--8. db_Serve
		
	UPDATE A SET goodreg_id=@TO_CUID FROM  [221.143.23.211,8019].db_serve.dbo.tbl_scrap_complex A JOIN mwmember.dbo.cst_master B On A.goodreg_id = B.CUID WHERE CUID=@AS_CUID	
	
	--9. sendbill	

	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].sendbill.dbo.TaxRequest A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID	

GO
