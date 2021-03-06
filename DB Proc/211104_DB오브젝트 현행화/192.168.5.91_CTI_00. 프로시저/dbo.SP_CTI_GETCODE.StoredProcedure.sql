USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[SP_CTI_GETCODE]    Script Date: 2021-11-03 오후 4:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
*객체이름 : CTI 코드 검색
*제작자   : KJH
*버젼     :
*제작일   : 2017.02.08
EXEC SP_CTI_GETCODE 'S','1','01'
****************************************************************************************************/
CREATE	PROCEDURE [dbo].[SP_CTI_GETCODE]
	@SITECODE		CHAR(1)	= '',	
	@CODECLASS		VARCHAR(3)	= '',
	@CODE			CHAR(2)		= ''	

AS
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN

	IF @CODECLASS ='1' BEGIN --문의유형	
		SELECT CSCODE,CSCODENAME FROM TBL_CSCODE WITH(NOLOCK) WHERE SITECODE=@SITECODE AND MEMBERCODE=@CODE GROUP BY CSCODE,CSCODENAME
	END 
	
	IF @CODECLASS ='2' BEGIN --콜유형
		SELECT CALLCODE,CALLCODENAME FROM TBL_CSCODE WITH(NOLOCK) WHERE SITECODE=@SITECODE AND CSCODE=@CODE GROUP BY CALLCODE,CALLCODENAME
	END 
	
END


GO
