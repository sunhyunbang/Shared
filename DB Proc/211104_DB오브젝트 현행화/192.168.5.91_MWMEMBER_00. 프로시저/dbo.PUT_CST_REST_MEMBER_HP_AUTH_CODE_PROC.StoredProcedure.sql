USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_CST_REST_MEMBER_HP_AUTH_CODE_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 휴면회원 계정 해제 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 신 장 순
 *  작   성   일 : 2015-08-10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 휴면회원 계정 해제를 위한 핸드폰 인증을 함
 *  주 의  사 항 :
 *  사 용  소 스 :
EXEC PUT_MM_MEMBER_HP_AUTH_CODE_PROC '011sos0113','신장순','010-7377-9770','19830719','R'
SELECT * FROM MM_REST_HP_AUTH_CODE_TB
************************************************************************************/
CREATE PROC [dbo].[PUT_CST_REST_MEMBER_HP_AUTH_CODE_PROC]
       @USERID      VARCHAR(50)
     , @USERNAME    VARCHAR(30)
     , @HP          VARCHAR(14)
	 , @JUMINNO			CHAR(8)
     , @TYPE        CHAR(1) = 'R'	-- R:휴면회원 계정 해제     
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ROWCOUNT INT
	DECLARE @RANDOMCHAR   CHAR(6)

	DECLARE @RANDOM INT
	SELECT @RANDOM = RAND() * 1000000
	SET @RANDOMCHAR = REPLICATE('0', 6 - LEN(@RANDOM)) + CAST(@RANDOM AS VARCHAR)

	UPDATE CST_REST_HP_AUTH_CODE_TB
		 SET IDCODE = @RANDOMCHAR
			 , DT = GETDATE()
			 , TYPE = @TYPE
			 , HP = @HP
			 , USERNAME = @USERNAME
			 , JUMINNO = @JUMINNO
	 WHERE USERID = @USERID
		 AND TYPE = @TYPE

	SELECT @ROWCOUNT = @@ROWCOUNT

	IF @ROWCOUNT = 0
		BEGIN
				INSERT CST_REST_HP_AUTH_CODE_TB
						 ( USERID, USERNAME, HP, JUMINNO, DT, IDCODE, TYPE)
				VALUES
						 ( @USERID, @USERNAME, @HP, @JUMINNO, GETDATE(), @RANDOMCHAR, @TYPE)
		END


	DECLARE @MSG VARCHAR(80)
	
	SET @MSG='[벼룩시장] 휴면계정 해제 인증번호 ['+@RANDOMCHAR+']를 입력해 주세요.'
	EXEC FINDDB1.COMDB1.DBO.PUT_SENDSMS_PROC '02-2187-7867','벼룩시장',@USERNAME ,@HP ,@MSG ,'FINDALL'

END
GO
