USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_LOG]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 이력
 *  작   성   자 : KJH
 *  작   성   일 : 2016-08-31
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 

 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_LOG]
 @CUID int
,@USERID varchar(50) 
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
AS
	SET NOCOUNT ON;

	select top 1 @USERID = userid
	from dbo.CST_MASTER with(nolock)
	where CUID = @CUID
			  
	INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
	(@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기

	UPDATE CST_MASTER 
     SET LAST_LOGIN_DT = getdate()
	 WHERE CUID = @CUID	

GO
