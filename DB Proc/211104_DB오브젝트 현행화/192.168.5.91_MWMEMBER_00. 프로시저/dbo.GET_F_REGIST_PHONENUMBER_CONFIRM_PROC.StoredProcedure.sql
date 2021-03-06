USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_REGIST_PHONENUMBER_CONFIRM_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 특정사용자 체크
 *  작   성   자 : 황민수
 *  작   성   일 : 2020-04-06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 특정사용자 번호 체크
 -- RETURN(0) -- 성공
 -- RETURN(500) -- 실패
 
 [dbo].[GET_F_REGIST_PHONENUMBER_CONFIRM_PROC] '010-1234-5678', '010-7890-1234', 0

 010-9704-5466, 010-9549-1908, 010-9704-5466
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GET_F_REGIST_PHONENUMBER_CONFIRM_PROC]
@TS_PHONE1 varchar(15), -- 대표번호
@TS_PHONE2 varchar(15) -- 담당자번호
,@RESULT TINYINT OUTPUT     -- 결과 (0: 비매칭, 1: 매칭)
AS	
BEGIN
	SET NOCOUNT ON;

	DECLARE @RESULTCOUNT INT

	SELECT @RESULTCOUNT = COUNT(*) 
	  FROM MM_BAD_HP_TB WITH(NOLOCK)
	WHERE HP IN (REPLACE(@TS_PHONE1,'-',''), REPLACE(@TS_PHONE2,'-',''))

	IF @RESULTCOUNT > 0 
	BEGIN
		SET @RESULT = 1  -- 매칭
	END
	ELSE 
	BEGIN
		SET @RESULT = 0  -- 비매칭
	END

	PRINT @RESULT

END
GO
