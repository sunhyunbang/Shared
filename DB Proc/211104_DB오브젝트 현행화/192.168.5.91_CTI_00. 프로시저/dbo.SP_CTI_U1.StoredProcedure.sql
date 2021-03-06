USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[SP_CTI_U1]    Script Date: 2021-11-03 오후 4:49:03 ******/
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
 exec rserve.dbo.SP_CTI_U1 '1', '1', '09', '031', '중개업소', '', 0, '', '', '', '010-9543-2616', 0, '', '모바일2 등기부 파일명 숫자로 변환후 재첨부해보실것 안내111', '', 1038, '1', 0, 61821 
 ******************************************************************************/
CREATE       PROCEDURE [dbo].[SP_CTI_U1]

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
	@callseq	int = 0

	
	
AS
BEGIN

	SET NOCOUNT ON

	UPDATE cti.dbo.tbl_callmaster
    SET
			INOUT = @callType, 
			MEMBERCLASS = @membercode, 
			CS_CODE = @CSCODE, 
			CALL_CODE = @CALLCODE, 
			CUSTOMER_NM = @customer_nm, 
			COMPANY_NM = @company_nm, 
			CUID = @CUID, 
			USERID = @userid, 
			BIZNO = @bizno, 
			C_ID = @c_id, 
			C_NAME = @c_name, 
			PHONE = @phone, 
			CALL_PHONE = @callno, 
			CS_TEXT = @cs_text, 
			REMARK = @remark, 
			MODDATE = getdate(), 
			MODSTAFF_SEQ = @STAFF_SEQ,
			AD_NO = @good_id
     WHERE  SITE_CD ='S' and seq=@callseq
           
   
END

GO
