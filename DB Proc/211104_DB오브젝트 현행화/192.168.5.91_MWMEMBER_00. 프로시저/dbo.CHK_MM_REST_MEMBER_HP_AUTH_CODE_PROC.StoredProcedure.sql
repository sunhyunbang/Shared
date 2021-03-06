USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_REST_MEMBER_HP_AUTH_CODE_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 휴면회원 계정 해제 > 핸드폰 인증 코드 체크
 *  작   성   자 : 신 장 순
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 휴면회원 계정 해제를 위한 핸드폰 인증번호를 체크 함
 *  주 의  사 항 :
 *  사 용  소 스 :
************************************************************************************/
CREATE PROC [dbo].[CHK_MM_REST_MEMBER_HP_AUTH_CODE_PROC]
       @USERID      VARCHAR(50)
     , @HP          VARCHAR(14)
	 , @JUMINNO			CHAR(8)
     , @IDCODE      CHAR(6)
     , @TYPE        CHAR(1)			= 'R'   --R:휴면회원 계정 해제
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @CNT  INT
	DECLARE @DT DATETIME

	SET @DT = DATEADD(MI, -10, GETDATE())

	SELECT COUNT(*)
		FROM CST_REST_HP_AUTH_CODE_TB WITH (NOLOCK)
	 WHERE USERID = @USERID
	   AND HP = @HP
	   AND JUMINNO = @JUMINNO
		 AND IDCODE = @IDCODE
		 AND TYPE = @TYPE
		 AND DT >= @DT

END
GO
