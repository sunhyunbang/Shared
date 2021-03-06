USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[PUT_CS_CALLMASTER_PROC]    Script Date: 2021-11-03 오후 4:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/***************************************************************
 *  단위 업무 명 : 회원상담 게시판 Insert
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017/02/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
***************************************************************/
CREATE PROC [dbo].[PUT_CS_CALLMASTER_PROC]
		@INOUT CHAR(1)
	, @MEMBERCLASS CHAR(1)
	, @CS_CODE CHAR(2)
	, @CALL_CODE CHAR(3)
	, @CUSTOMER_NM VARCHAR(50)

	, @COMPANY_NM VARCHAR(50)
	, @CUID INT
	, @USERID VARCHAR(50)
	, @BIZNO VARCHAR(20)
	, @C_ID INT
	
	, @C_NAME VARCHAR(50)
	, @PHONE VARCHAR(20)
	, @HPHONE VARCHAR(20)
	, @CALL_PHONE VARCHAR(20)
	, @CS_TEXT VARCHAR(MAX)
	
	, @REMARK VARCHAR(400)
	, @STAFF_ID VARCHAR(50)
	, @SITE_CD CHAR(1)
	--, @MODSTAFF_ID VARCHAR(50)
	, @STAT CHAR(1)
	
	, @AD_NO VARCHAR(20)
	, @CATE_CODE CHAR(1)
AS

SET NOCOUNT ON

INSERT [dbo].[TBL_CALLMASTER]
	( INOUT, MEMBERCLASS, CS_CODE, CALL_CODE, CUSTOMER_NM, COMPANY_NM, CUID, USERID, BIZNO, C_ID, C_NAME
		, PHONE, HPHONE, CALL_PHONE, CS_TEXT, REMARK, STAFF_ID, SITE_CD 
		, STAT, AD_NO, CATE_CODE )
VALUES
	( @INOUT, @MEMBERCLASS, @CS_CODE, @CALL_CODE, @CUSTOMER_NM, @COMPANY_NM, @CUID, @USERID, @BIZNO, @C_ID, @C_NAME
		, @PHONE, @HPHONE, @CALL_PHONE, @CS_TEXT, @REMARK, @STAFF_ID, @SITE_CD
		, @STAT, @AD_NO, @CATE_CODE )


GO
