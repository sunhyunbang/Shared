USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[SP_CTI_I1]    Script Date: 2021-11-03 오후 4:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/****************************************************************************
	설명		: CIT Insert
	제작자		: kjh
	제작일		: 20170209
	수정자		: 
	수정일		: 
	실행예제	:
 
 ******************************************************************************/
CREATE       PROCEDURE [dbo].[SP_CTI_I1]

	@callType	char(1) = '',
	@membercode	char(1) = '',
	@CSCODE		char(2) = '',
	@CALLCODE	char(3) = '',
	@customer_nm	varchar(50) = '',	
	@company_nm	varchar(50) = '',
	@CUID		int	= 0 ,	
	@userid		varchar(50) = '',
	@phone		varchar(20) = '',
	@bizno		varchar(20) = '',
	@callno		varchar(20) = '',
	@c_id		int = 0,
	@c_name		varchar(50) = '',
	@cs_text	varchar(max) = '',
	@remark		varchar(400) = '',
	@STAFF_SEQ	int = 0,
	@stat		char(1) = '',
	@good_id	int = 0,
	@blackyn	char(1) = '',
	@black_txt	varchar(200)
	
	
AS
BEGIN

	declare @blackregcnt int	

	SET NOCOUNT ON

	INSERT INTO memberdb.cti.dbo.tbl_callmaster
           (
			INOUT, 
			MEMBERCLASS, 
			CS_CODE, 
			CALL_CODE, 
			CUSTOMER_NM, 
			COMPANY_NM, 
			CUID, 
			USERID, 
			BIZNO, 
			C_ID, 
			C_NAME, 
			PHONE, 
			CALL_PHONE, 
			CS_TEXT, 
			REMARK, 
			REGDATE, 
			STAFF_SEQ,
			SITE_CD, 
			STAT, 
			AD_NO
           )
     VALUES
           (
			@callType,
			@membercode,			
			@CSCODE,
			@CALLCODE,
			@customer_nm,
			@company_nm,
			@CUID,			
			@userid,
			@bizno,
			@c_id,
			@c_name,			
			@phone,
			@callno,
			@cs_text,
			@remark,
			getdate(),
			@STAFF_SEQ,
			'S',
			@stat,
			@good_id
           )
           
      IF  @blackyn ='Y' BEGIN
		select @blackregcnt=count(*) from memberdb.cti.dbo.tbl_blacklist where cuid=@CUID and remark=@black_txt
		if @blackregcnt =0 begin
			INSERT INTO memberdb.cti.dbo.tbl_blacklist (cuid,regdate,staff_seq,remark,site_cd) values (@CUID,getdate(),@STAFF_SEQ,@black_txt,'S')
		end 
      END     
END
GO
