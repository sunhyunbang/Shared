USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[PUT_CS_BLACK_PROC]    Script Date: 2021-11-03 오후 4:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/***************************************************************
 *  단위 업무 명 : 회원상담 게시판 블랙리스트 Insert
 *  작   성   자 : 백 규 원
 *  작   성   일 : 2017/02/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
***************************************************************/
CREATE PROC [dbo].[PUT_CS_BLACK_PROC]
		@CUID INT
	, @STAFF_ID VARCHAR(50)
	, @REMARK VARCHAR(400)
	, @USEYN CHAR(1)
	, @SITE_CD CHAR(1)
AS

SET NOCOUNT ON

INSERT [dbo].[TBL_BLACKLIST]
	( CUID, STAFF_ID, REMARK, USEYN, SITE_CD )
VALUES
	( @CUID, @STAFF_ID, @REMARK, @USEYN, @SITE_CD )


GO
