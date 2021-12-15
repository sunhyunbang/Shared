--USE PAPER_NEW
/*************************************************************************************  
 *  단위 업무 명 : 벼룩시장 구인광고 게재종료 안내정보 리스트 가져오기  
 *  작   성   자 :  
 *  작   성   일 : 2021/12/3  
 *  설        명 :  
 *  사 용  소 스 :  
 *  사 용  예 제 : EXEC DBO.GET_ADINFO_END_LIST_PROC  
 *************************************************************************************/  
CREATE PROCEDURE [dbo].[GET_ADINFO_END_LIST_PROC]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
  LTRIM(USERNAME) AS USERNAME
	,EMAIL
	,REG_DT
	,TITLE
	,LIST_TERM
	,OPT_NAME
	,OPT_TERM
	,LINEADID
	,OPT_START_DT
	,OPT_END_DT
	,PUB_STATUS
	,ACCMETHOD
	,CODENM3
  FROM [PAPER_NEW].[DBO].[PP_LINE_AD_PUB_END_LIST_VI]
  ORDER BY USERNAME DESC

END
GO
