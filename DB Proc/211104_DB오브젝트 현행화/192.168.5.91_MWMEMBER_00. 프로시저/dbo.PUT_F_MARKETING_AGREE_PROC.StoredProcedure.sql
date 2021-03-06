USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_MARKETING_AGREE_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅.이벤트 수신동의
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2018/12/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
   -- 마케팅 이용동의 회원 가져오기
   SELECT * FROM CST_MASTER AS A JOIN CST_MARKETING_AGREEF_TB AS B ON B.CUID = A.CUID WHERE B.AGREEF = 1
 *************************************************************************************/


CREATE PROC [dbo].[PUT_F_MARKETING_AGREE_PROC]

  @CUID INT
  ,@AGREEF TINYINT = 0

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  IF @AGREEF = 1 AND EXISTS(SELECT * FROM CST_MARKETING_AGREEF_TB WITH(NOLOCK) WHERE CUID=@CUID AND AGREEF = 1)    -- 이미 동의한 이력이 있다면 동의일자 유지를 위해 아무것도 안함.
    BEGIN
      RETURN
    END
  ELSE
    BEGIN
      DELETE FROM CST_MARKETING_AGREEF_TB WHERE CUID = @CUID

      INSERT INTO CST_MARKETING_AGREEF_TB
        (CUID,AGREEF)
      VALUES
        (@CUID,@AGREEF)
    END
GO
