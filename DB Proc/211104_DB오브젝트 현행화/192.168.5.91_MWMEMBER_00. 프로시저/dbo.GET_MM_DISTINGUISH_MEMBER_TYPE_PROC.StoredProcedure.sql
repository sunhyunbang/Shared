USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_DISTINGUISH_MEMBER_TYPE_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 모바일 리뉴얼 - 회원 구분 판별 (일반, 비즈니스, 공인중개사)
 *  작   성   자 : 백규원
 *  작   성   일 : 2017-06-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * 
EXEC GET_MM_DISTINGUISH_MEMBER_TYPE_PROC '11631083', '127.0.0.1'
EXEC GET_MM_DISTINGUISH_MEMBER_TYPE_PROC '11121212', '127.0.0.1'
MEMBER_TYPE = 1 : 비즈니스, 2 : 중개업소, 없으면 : 일반
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_DISTINGUISH_MEMBER_TYPE_PROC]
		@CUID         INT
	, @IPADDR				VARCHAR(15) = ''
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF @CUID != 0
BEGIN
	SELECT TOP 1
		B.MEMBER_TYPE, B.CUID
	FROM CST_MASTER A
		INNER JOIN CST_COMPANY B
			ON A.COM_ID=B.COM_ID
	WHERE A.CUID = @CUID
		--AND B.USE_YN = 'Y'
END



GO
