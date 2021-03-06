USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[UPDATE_CS_CALLMASTER_PROC]    Script Date: 2021-11-03 오후 4:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/***************************************************************
 *  단위 업무 명 : 회원상담 게시판 Edit
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017/02/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
***************************************************************/
CREATE PROC [dbo].[UPDATE_CS_CALLMASTER_PROC]
		@SEQ INT
	,	@INOUT CHAR(1)
	, @MEMBERCLASS CHAR(1)
	, @CS_CODE CHAR(2)
	, @CALL_CODE CHAR(3)

	, @CUSTOMER_NM VARCHAR(50)
	, @COMPANY_NM VARCHAR(50)
	--, @CUID INT
	, @USERID VARCHAR(50)
	, @BIZNO VARCHAR(20)

	, @C_ID INT
	, @C_NAME VARCHAR(50)
	, @PHONE VARCHAR(20)
	, @HPHONE VARCHAR(20)
	, @CALL_PHONE VARCHAR(20)

	, @CS_TEXT VARCHAR(MAX)
	, @REMARK VARCHAR(400)
	, @SITE_CD CHAR(1)
	, @MODSTAFF_ID VARCHAR(50)
	, @STAT CHAR(1)

	, @AD_NO VARCHAR(20)
	, @CATE_CODE CHAR(1)
--	, @CHKBLACK CHAR(1)
AS

SET NOCOUNT ON

UPDATE DBO.TBL_CALLMASTER
SET 
		INOUT =	@INOUT
	, MEMBERCLASS = @MEMBERCLASS
	, CS_CODE = @CS_CODE
	, CALL_CODE = @CALL_CODE
	, CUSTOMER_NM = @CUSTOMER_NM

	, COMPANY_NM = @COMPANY_NM
--	, CUID = @CUID
	, USERID = @USERID
	, BIZNO = @BIZNO
	, C_ID = @C_ID

	, C_NAME = @C_NAME
	, PHONE = @PHONE
	, HPHONE = @HPHONE
	, CALL_PHONE = @CALL_PHONE
	, CS_TEXT = @CS_TEXT

	, REMARK = @REMARK
	, SITE_CD = @SITE_CD
	, MODSTAFF_ID = @MODSTAFF_ID
	, STAT = @STAT
	, MODDATE = GETDATE()

	, AD_NO = @AD_NO
	, CATE_CODE = @CATE_CODE
WHERE SEQ = @SEQ

--IF @CHKBLACK = 'ON'


GO
