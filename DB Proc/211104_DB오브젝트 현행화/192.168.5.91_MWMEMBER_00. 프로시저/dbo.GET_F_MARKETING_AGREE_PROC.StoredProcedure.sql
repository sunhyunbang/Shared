USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MARKETING_AGREE_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅.이벤트 수신동의 여부
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

 --GET_F_MARKETING_AGREE_PROC 111, 0

CREATE PROC [dbo].[GET_F_MARKETING_AGREE_PROC]

  @CUID INT
  ,@RETURN INT OUTPUT   -- 0: 미동의, 1: 동의, 99: 동의여부안함

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON



	SELECT @RETURN = B.AGREEF
	FROM CST_MASTER AS A WITH(NOLOCK)
	  JOIN CST_MARKETING_AGREEF_TB AS B WITH(NOLOCK) ON B.CUID = A.CUID
	WHERE A.CUID = @CUID

	set @RETURN = ISNULL (@RETURN,99)
	-- 이용동의 여부를 선택하지 않은 경우 99 리턴



GO
