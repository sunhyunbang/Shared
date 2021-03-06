USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_PWD_CHECK]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 중복 비번 체크 체크
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-08-20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 아이디 체크
 * RETURN(500)  -- 중복아이디
 * RETURN(0)    --  중복 아이디 없음

  *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_PWD_CHECK]
@CUID INT
,@PASS varchar(50)
AS 
	DECLARE @CNT INT
	SELECT @CNT = COUNT(USERID)  FROM CST_MASTER WITH(NOLOCK) WHERE CUID = @CUID
	and pwd_sha2 = master.DBO.fnGetStringToSha256(dbo.FN_MD5(LOWER(@PASS)))
	
	IF @CNT = 1 
		RETURN 1
	else
		RETURN 0
	
GO
