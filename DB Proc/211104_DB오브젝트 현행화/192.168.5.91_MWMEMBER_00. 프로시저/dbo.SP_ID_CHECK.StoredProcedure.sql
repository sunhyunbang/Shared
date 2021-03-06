USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_ID_CHECK]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ID_CHECK]
/*************************************************************************************
 *  단위 업무 명 : 중복 아이디 체크
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 아이디 체크
 * RETURN(500)  -- 중복아이디
 * RETURN(0)    --  중복 아이디 없음
  *************************************************************************************/
@USERID VARCHAR(25)
AS 

	SELECT COUNT(USERID) idchk FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @USERID
GO
