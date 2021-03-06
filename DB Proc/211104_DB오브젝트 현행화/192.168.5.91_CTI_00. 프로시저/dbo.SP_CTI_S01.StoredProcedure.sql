USE [CTI]
GO
/****** Object:  StoredProcedure [dbo].[SP_CTI_S01]    Script Date: 2021-11-03 오후 4:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
*객체이름 : CTI 리스트
*제작자   : JMG
*버젼     :
*제작일   : 2017.02.08
SP_CTI_S01 13621996
****************************************************************************************************/
CREATE	PROCEDURE [dbo].[SP_CTI_S01]
	@mem_seq		int,
	@CurrentPage	int = 1	,
	@pagesize		int = 300,
	@rowCnt			int=0 output
AS
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @sql varchar(5000)	
	SET @sql = ''
	
	CREATE TABLE #temp_list (tseq int not null identity(1,1) primary key nonclustered, seq int not null) 
	
	SET @sql = @sql + '
	INSERT INTO #temp_list(seq)
	select seq
	from dbo.tbl_callmaster with(nolock)
	where 1 = 1'
    IF @mem_seq > 0 BEGIN
		SET @sql = @sql + '	AND cuid = ''' + CAST(@mem_seq AS VARCHAR) + ''''
	END
	SET @sql = @sql + '	ORDER BY seq DESC '
		
	PRINT(@sql)
	EXEC(@sql)
	SET @rowCnt = @@rowcount

	select totalcount = @rowCnt
	, tc.seq, convert(varchar(10),regdate, 121) regdate, c_name, cs_text, call_phone, cs_code, call_code, inout, memberclass, company_nm, customer_nm, ad_no
     from dbo.tbl_callmaster tc with(nolock) 
     join #temp_list t with(nolock) on t.seq = tc.seq AND t.tseq BETWEEN (((@CurrentPage-1)*@pagesize)+1) AND (@CurrentPage*@pagesize)
     ORDER BY t.tseq	
	
END

GO
