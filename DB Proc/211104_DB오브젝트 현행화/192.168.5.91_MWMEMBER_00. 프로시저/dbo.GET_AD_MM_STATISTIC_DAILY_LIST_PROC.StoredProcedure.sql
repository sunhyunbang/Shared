USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_STATISTIC_DAILY_LIST_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 일별 회원리스트
 *  작   성   자 : 여운영
 *  작   성   일 : 2015.09.18
 *  수   정   자 : 
 *  수   정   일 : 2015.11.16
 *  설        명 : 구인부동산 필드추가
 *  주 의  사 항 : 
 *  사 용  소 스 : 
EXEC GET_AD_MM_STATISTIC_DAILY_LIST_PROC 1,15,'2015-09-10'
 *************************************************************************************/
CREATE         PROCEDURE [dbo].[GET_AD_MM_STATISTIC_DAILY_LIST_PROC]
	 @PAGE			INT		      -- 페이지
	,@PAGESIZE		INT		    -- 페이지사이즈
	,@STDATE		VARCHAR(10)=''	-- 시작일	
AS
  SET NOCOUNT ON

	DECLARE	@SQL	NVARCHAR(4000)
	DECLARE @WHERE	NVARCHAR(1000)
	DECLARE @JOIN	NVARCHAR(1000)
	

	SET @SQL = ''
	SET @WHERE = ''
	SET @JOIN = ''

----------------------------------------
-- 검색
----------------------------------------
	-- 날짜
	IF @STDATE = ''
		SET @STDATE =CONVERT(VARCHAR(10),GETDATE()-15,120)
	
	IF @STDATE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND REG_DT >= CAST('''+ @STDATE + ''' AS DATETIME) '
		SET @WHERE = @WHERE + ' AND REG_DT < CAST('''+ @STDATE + ''' AS DATETIME)+15 '
	END



----------------------------------------
-- 리스트
----------------------------------------
	SET @SQL =	'SELECT COUNT(*) AS CNT '+
			'  FROM DBO.MM_STAT_MEMBER_TB M WITH(NOLOCK) ' +
			' WHERE 1 = 1 ' + @WHERE + ';' 
		
	IF @Page  = 0 
		SET @SQL = @SQL + 'SELECT '
	ELSE
		SET @SQL = @SQL + 'SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) 
	SET @SQL = @SQL +
					' REG_DT
					  ,NEW_JOIN_COMPANY
					  ,NEW_JOIN_PERSON
					  ,OUT_COMPANY
					  ,OUT_PERSON
					  ,TOTAL_MEM_COMPANY
					  ,TOTAL_MEM_PERSON
					  ,NEW_JOIN_JOB
					  ,NEW_JOIN_LAND
					  ,TOTAL_MEM_COMPANY_JOB 
					  ,TOTAL_MEM_COMPANY_LAND
				FROM	DBO.MM_STAT_MEMBER_TB M WITH (NOLOCK)
				WHERE 1 = 1 ' + @WHERE +
				'ORDER BY REG_DT DESC;'

	--PRINT @SQL
	EXECUTE SP_EXECUTESQL @Sql
GO
