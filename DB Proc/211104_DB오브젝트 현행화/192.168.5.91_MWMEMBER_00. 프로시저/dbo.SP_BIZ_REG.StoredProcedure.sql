USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_BIZ_REG]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_BIZ_REG]
/*************************************************************************************
 *  단위 업무 명 : 사업자번호 조회
 *  작   성   자 : JMG
 *  작   성   일 : 2016-08-10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * EXEC SP_BIZ_REG '101-01-16777'
 *************************************************************************************/
@BIZ_NO varchar(50)
AS
	SET NOCOUNT ON;
	
	SELECT BizNo, BizName, BizPresident, case CloseYN when 'Y' then case isnull(CloseDate,'') when '' then 'H' else 'Y' end else 'N' end CloseYN
	FROM dbo.BIZ_REG_MASTER WITH(NOLOCK) 
	WHERE BizNo = @BIZ_NO
		
	
GO
