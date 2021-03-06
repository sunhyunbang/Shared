USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_MARKETING_AGREEF_CLEAR_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅 수신동의 해제
 *  작   성   자 : 이근우
 *  작   성   일 : 2020.03.17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 *************************************************************************************/
CREATE PROC [dbo].[EDIT_MARKETING_AGREEF_CLEAR_PROC]
  @CUID     INT
AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  UPDATE M
     SET M.AGREEF = 0
       , M.AGREE_DT = GETDATE()
  -- SELECT M.*
    FROM CST_MASTER AS CM WITH(NOLOCK)
    JOIN CST_MARKETING_AGREEF_TB AS M WITH(NOLOCK) ON M.CUID = CM.CUID
   WHERE CM.CUID = @CUID

END
GO
