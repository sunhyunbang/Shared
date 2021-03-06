USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_MEMBER_HP_COUNT_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 동일 휴대폰으로 3개까지만 가능
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2014-05-20
 *  수   정   자 : 정헌수
 *  수   정   일 : 2014-08-20 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 개인회원 : 동일 휴대폰 번호 3개까지만 체크
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC CHK_MM_MEMBER_HP_COUNT_PROC '0','01087798662'
************************************************************************************/
CREATE PROC [dbo].[CHK_MM_MEMBER_HP_COUNT_PROC]
       @MEMBER_CD   CHAR(1)
     , @HP          VARCHAR(14)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @HP_TYPE2          VARCHAR(14)
	IF LEN(@HP) = 11 
		SET @HP_TYPE2 = LEFT(@HP,3) +'-' + RIGHT(LEFT(@HP,7),4) +'-' + RIGHT(@HP,4)
	ELSE IF LEN(@HP) = 10
		SET @HP_TYPE2 = LEFT(@HP,3) +'-' + RIGHT(LEFT(@HP,7),3) +'-' + RIGHT(@HP,4)
	ELSE 
		SET @HP_TYPE2 = '9999999999999'
	
			IF LEN(@HP) > 0 AND @HP_TYPE2 <> '9999999999999'
				BEGIN
					SELECT COUNT(*) AS CNT
						FROM CST_MASTER WITH (NOLOCK)
				WHERE MEMBER_CD = (CASE @MEMBER_CD WHEN '0' THEN MEMBER_CD ELSE @MEMBER_CD END)
						 AND HPHONE IN (@HP, @HP_TYPE2)
						 AND OUT_YN = 'N'
		END
	ELSE
		BEGIN
			SELECT 999 AS CNT
		END
END

GO
