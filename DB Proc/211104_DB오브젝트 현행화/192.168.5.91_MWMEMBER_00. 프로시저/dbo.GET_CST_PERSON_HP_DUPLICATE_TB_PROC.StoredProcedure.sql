USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_CST_PERSON_HP_DUPLICATE_TB_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 핸드폰 중복 체크 
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-08-17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 :
 
 DECLARE @SS INT
 exec @SS = GET_CST_PERSON_HP_DUPLICATE_TB_PROC 13222380,'010-2139-8258'
 select @SS
 
 go
 DECLARE @SS INT
 exec @SS = GET_CST_PERSON_HP_DUPLICATE_TB_PROC 13222381,'010-2139-8258'
 select @SS
 go
 
 select COUNT(*),
		MAX(ISNULL(B.STAT,0))
		 FROM CST_MASTER A
 	LEFT OUTER JOIN  CST_PERSON_HP_DUPLICATE_TB B WITH(NOLOCK)  ON A.CUID = B.CUID AND B.STAT = 1 AND B.CUID = 13222381
	where A.hphone = '010-2139-8258' AND A.MEMBER_CD = 1

 *************************************************************************************/

CREATE PROC [dbo].[GET_CST_PERSON_HP_DUPLICATE_TB_PROC]
	 @CUID		INT	-- 회원명
	,@HPHONE	varchar(14)
AS
BEGIN
	SET NOCOUNT ON
	-- 기본정보
	DECLARE @CNT VARCHAR(50) = NULL
	DECLARE @STAT INT = 0 
	SELECT 
		@CNT = COUNT(*),
		@STAT = MAX(ISNULL(B.STAT,0))
	 FROM CST_MASTER A WITH(NOLOCK) 
	LEFT OUTER JOIN  CST_PERSON_HP_DUPLICATE_TB B WITH(NOLOCK)  ON A.CUID = B.CUID AND B.STAT = 1 AND B.CUID = @CUID
	where A.hphone = @HPHONE AND A.MEMBER_CD = 1
	
	SET @STAT = CASE WHEN @CNT = 1 THEN 1 ELSE @STAT END 
	--SELECT @CNT, @STAT
	--중복 전화번호 있고 상태값이 0일때는 변경대상
	IF @CNT > 1 AND @STAT = 0 
	BEGIN
		RETURN 1
	END
	ELSE
	BEGIN
		RETURN 0
	END
	 
END
GO
