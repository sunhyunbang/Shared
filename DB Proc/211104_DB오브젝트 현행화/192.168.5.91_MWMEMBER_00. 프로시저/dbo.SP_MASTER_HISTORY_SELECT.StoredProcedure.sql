USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_HISTORY_SELECT]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_MASTER_HISTORY_SELECT]
/*************************************************************************************
 *  단위 업무 명 : 개인 정보 수정 이력 보기
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 개인 
 *************************************************************************************/
@CUID INT,
@START_DT VARCHAR(10),
@END_DT VARCHAR(10)
AS	
	DECLARE  @SQL nvarchar(4000)

	SET @SQL = 'SELECT * FROM CST_MASTER_HISTORY WITH(NOLOCK) WHERE CUID = '+  CONVERT(nvarchar,@CUID)
	IF @START_DT != ''
		BEGIN
		SET @START_DT = REPLACE(REPLACE(REPLACE(@START_DT, '-' , ''),':',''),' ','')
		SET @END_DT = REPLACE(REPLACE(REPLACE(@END_DT, '-' , ''),':',''),' ','')
		SET @SQL = @SQL + ' AND MOD_DT between ''' + CONVERT(nvarchar,@START_DT) + ''' AND ''' + CONVERT(nvarchar,@END_DT)+''''
		END

	EXEC(@SQL)

GO
