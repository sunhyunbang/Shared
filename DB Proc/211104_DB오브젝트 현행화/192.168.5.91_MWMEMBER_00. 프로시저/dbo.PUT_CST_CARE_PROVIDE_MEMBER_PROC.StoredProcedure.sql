USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_CST_CARE_PROVIDE_MEMBER_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 벼룩시장 케어 회원 연동 저장
 *  작   성   자 : 조재성
 *  작   성   일 : 2021-07-08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 :
 
 *************************************************************************************/

CREATE PROC [dbo].[PUT_CST_CARE_PROVIDE_MEMBER_PROC]
	 @CUID		INT
	 ,@INFLOW_ROUTE	CHAR(4)
AS
BEGIN
	SET NOCOUNT ON
	
	IF NOT EXISTS(SELECT IDX FROM CST_CARE_PROVIDE_MEMBER_TB WITH(NOLOCK) WHERE CUID = @CUID)
	BEGIN
		INSERT INTO CST_CARE_PROVIDE_MEMBER_TB (CUID,INFLOW_ROUTE) VALUES (@CUID,@INFLOW_ROUTE)
	END
END
GO
