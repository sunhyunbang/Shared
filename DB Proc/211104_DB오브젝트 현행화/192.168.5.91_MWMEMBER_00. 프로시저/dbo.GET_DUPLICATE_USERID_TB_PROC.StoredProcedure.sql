USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_DUPLICATE_USERID_TB_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 중복아이디 체크 
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-08-17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 2순위 아이디 체크 
 *  주 의  사 항 :
 *  사 용  소 스 :
 *************************************************************************************/

CREATE PROC [dbo].[GET_DUPLICATE_USERID_TB_PROC]
	 @CUID		INT	-- 회원명

AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
	-- 기본정보
	DECLARE @USERID VARCHAR(50) = NULL
	DECLARE @USERID_COUNT INT = 0 
	
	SELECT	@USERID = USERID
		FROM DBO.DUPLICATE_USERID_TB M WITH(NOLOCK)
		WHERE M.CUID = @CUID 
	
	IF @USERID IS NOT NULL 
	BEGIN
		SELECT @USERID_COUNT = COUNT(*) FROM DUPLICATE_USERID_TB WITH(NOLOCK) WHERE USERID = @USERID 
		IF @USERID_COUNT = 2 
		BEGIN
			DELETE DUPLICATE_USERID_TB WHERE CUID = @CUID --우선순위 접속
			UPDATE DUPLICATE_USERID_TB SET ORD = 2 WHERE USERID = @USERID 
			RETURN 0
		END
		ELSE
		BEGIN
			RETURN 1	--후순위 아이디(변경 필요)
		END
	END
	RETURN 0
END
GO
