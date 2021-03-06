USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_MM_MEMBER_ISADULT_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 > 성인 인증 등록
 *  작   성   자 : 장재웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2013/03/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_MM_MEMBER_ISADULT_PROC
 *************************************************************************************/


CREATE   PROC [dbo].[EDIT_MM_MEMBER_ISADULT_PROC]

  @CUID		INT
  ,@ISADULT		CHAR(1)			-- 성인 인증 여부

AS

  SET NOCOUNT ON

    UPDATE CST_MASTER
    SET		ADULT_YN = @ISADULT
    WHERE	CUID	= @CUID

GO
