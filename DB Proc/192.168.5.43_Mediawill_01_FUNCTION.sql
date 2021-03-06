USE [Mediawill]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_SPLITER_INT_FNC]    Script Date: 2021-11-04 오전 10:42:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 문자열을 분리해서 정수형으로 변환 하는 함수
' 작    성    자	: 
' 작    성    일	: 
' 수    정    자	:
' 수    정    일	:
' 설          명	: 
' 주  의  사  항	: 
' 사  용  소  스 	:  
' 예          제	: SELECT IDX FROM dbo.GET_SPLITER_INT_FNC('1,2,3',',')
******************************************************************************/
CREATE FUNCTION [dbo].[GET_SPLITER_INT_FNC](
	 @string VARCHAR(4000)
	,@delimiter CHAR(1)
)
RETURNS  @results TABLE(IDX INT)
AS
BEGIN 
	DECLARE @index	INT
	DECLARE @slice	VARCHAR(30)

	SET @index=1

	IF(@string IS NULL OR @string = '') RETURN

	WHILE @index !=0
	BEGIN
		SET @string = LTRIM(RTRIM(@string))
		SET @index = CHARINDEX(@delimiter,@string)
		IF @index !=0
		   SET @slice = left(@string,@index-1)
		ELSE
		   SET @slice=@string
		INSERT INTO @results(IDX) VALUES(CONVERT(INT,LTRIM(RTRIM(@slice))))
		SET @string = RIGHT(@string, LEN(@string)-@index)
		IF LEN(@string)=0 BREAK
	END
	RETURN
END


GO
