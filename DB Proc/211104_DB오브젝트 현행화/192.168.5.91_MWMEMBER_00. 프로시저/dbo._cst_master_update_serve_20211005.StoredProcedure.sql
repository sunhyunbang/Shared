USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[_cst_master_update_serve_20211005]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
JMG@20190117 통합회원 DB 업데이트
select * from good.dbo.tbl_naverclosebizno with(nolock) 

-- exec good.dbo.AG_NAVERCLOSEBIZNO_S1 @bizNo='2068526551'
exec good.dbo.AG_NAVERCLOSEBIZNO_S1 @bizNo='2068526551'

*/
CREATE PROCEDURE [dbo].[_cst_master_update_serve_20211005]
	@mem_seq		int = 0,
	@hphone			varchar(30) = '',
	@user_nm		varchar(50) = '',
	@email			varchar(50) = '',
	@pwd			varchar(50) = '',
	@main_phone		varchar(30) = '',
	@com_nm			varchar(50) = '',
	@ceo_nm			varchar(50) = '',
	@fax			varchar(30) = '',
	@register_no	varchar(50) = '',
	@reg_number		varchar(50) = ''
AS
BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @COM_ID INT	
	DECLARE @USER_ID varchar(50)	

	SELECT @COM_ID = COM_ID
	,@USER_ID = USERID 
	FROM MWMEMBER.DBO.CST_MASTER
	WHERE CUID = @MEM_SEQ

	IF @pwd <> ''  AND @pwd <> 'd41d8cd98f00b204e9800998ecf8427e' BEGIN --공백일경우 업데이트 안함 2019-01-21 조민기

		UPDATE DBO.CST_MASTER
		SET HPHONE = @hphone 
		, USER_NM = @user_nm
		, EMAIL = @email
		, PWD_MOD_DT = GETDATE()
		, pwd_sha2 = master.DBO.fnGetStringToSha256(@PWD)
		WHERE CUID = @mem_seq
		
		UPDATE CST_LOGIN_FAIL_COUNT 
		SET FAIL_CNT = 0
		, FAIL_DATE = ''
		WHERE USERID = @USER_ID

	END ELSE BEGIN

		UPDATE DBO.CST_MASTER
		SET HPHONE = @hphone 
		, USER_NM = @user_nm
		, EMAIL = @email
		, PWD_MOD_DT = GETDATE()
		WHERE CUID = @mem_seq

	END

	UPDATE DBO.CST_COMPANY
	SET MAIN_PHONE = @main_phone
	, COM_NM = @com_nm
	, CEO_NM = @ceo_nm
	, FAX = @FAX
	, REGISTER_NO = @register_no
	WHERE COM_ID = @COM_ID

	UPDATE DBO.CST_COMPANY_LAND
	SET REG_NUMBER = @reg_number
	WHERE COM_ID = @COM_ID
	
END
GO
