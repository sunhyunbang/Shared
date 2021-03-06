USE [FINDCONTENTS]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ClearHTMLTags]    Script Date: 2021-11-04 오전 10:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
*  단위 업무 명 : 문자열에서 html 태그 삭제
*  작   성   자 : 여운영
*  작   성   일 : 2015/06/03
*  설        명 :
*  주 의  사 항 :
*  사 용  소 스 :
*  사 용  예 제 :
SELECT DBO.FN_ClearHTMLTags('<font>4한글this부동map</font>')
SELECT DBO.FN_AlphaRemove(DBO.FN_ClearHTMLTags('<font>4한글this부동map</font>'))	--영문제거

*************************************************************************************/
CREATE FUNCTION [dbo].[FN_ClearHTMLTags]
(@String NVARCHAR(MAX))

RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Start INT,
            @End INT,
            @Length INT

    WHILE CHARINDEX('<', @String) > 0 AND CHARINDEX('>', @String, CHARINDEX('<', @String)) > 0
    BEGIN
        SELECT  @Start  = CHARINDEX('<', @String),
                @End    = CHARINDEX('>', @String, CHARINDEX('<', @String))
        SELECT @Length = (@End - @Start) + 1

        IF @Length > 0
        BEGIN
            SELECT @String = STUFF(@String, @Start, @Length, '')
         END
     END

    RETURN @String
END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_DATE_TO_CHAR12]    Script Date: 2021-11-04 오전 10:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
날짜형식을 'yyyyMMddHHmm' 형식으로 변경
*/
CREATE FUNCTION [dbo].[FN_DATE_TO_CHAR12](
  @VALUE DATETIME
)
RETURNS CHAR(12)
AS
BEGIN

  DECLARE @RESULT CHAR(12)

  SET @RESULT = CONVERT(CHAR(12), REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(16), @VALUE, 120), '-', ''), ':', ''), ' ', ''))

  RETURN @RESULT

END

GO
/****** Object:  UserDefinedFunction [dbo].[Fun_FindPhone]    Script Date: 2021-11-04 오전 10:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Fun_FindPhone]  (@Phone varchar (100))
RETURNS varchar(100)
AS
BEGIN

DECLARE @StrPhone int
DECLARE @StrPhone2 int
DECLARE @PhoneText varchar(100)
Set @StrPhone = 1
Set @StrPhone2 = 0
Set @PhoneText = ''

	WHILE  (@StrPhone <= Len(@Phone))

		IF (SUBSTRING(@Phone,@StrPhone,1) = '0'

			OR SUBSTRING(@Phone,@StrPhone,1) = '1'
			OR SUBSTRING(@Phone,@StrPhone,1) = '2'
			OR SUBSTRING(@Phone,@StrPhone,1) = '3'
			OR SUBSTRING(@Phone,@StrPhone,1) = '4'
			OR SUBSTRING(@Phone,@StrPhone,1) = '5'
			OR SUBSTRING(@Phone,@StrPhone,1) = '6'
			OR SUBSTRING(@Phone,@StrPhone,1) = '7'
			OR SUBSTRING(@Phone,@StrPhone,1) = '8'
			OR SUBSTRING(@Phone,@StrPhone,1) = '9'
			OR (ASCII(SUBSTRING(@Phone,@StrPhone,1)) >=  65 AND ASCII(SUBSTRING(@Phone,@StrPhone,1)) <= 122)
		)

			BEGIN
				SET @PhoneText = @PhoneText + SUBSTRING(@Phone,@StrPhone,1)
				SET @StrPhone = @StrPhone + 1
			END
		ELSE
			BEGIN
				SET	@PhoneText = @PhoneText
				SET @StrPhone = @StrPhone + 1
			END

		RETURN(@PhoneText)
END

GO
/****** Object:  UserDefinedFunction [dbo].[Fun_YHNews]    Script Date: 2021-11-04 오전 10:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Fun_YHNews]  (@Cate text)
RETURNS char(3)
AS
BEGIN

DECLARE @Cate1 char(1)
DECLARE @Cate2 char(1)
DECLARE @Cate3 char(1)
DECLARE @CateReturn char(3)

Set @Cate1 = '0'
Set @Cate2 = '0'
Set @Cate3 = '0'


IF PATINDEX('%취업%',@Cate) > 0  OR  PATINDEX('%채용%',@Cate) > 0 OR PATINDEX('%구인%',@Cate) > 0 OR  PATINDEX('%구직%',@Cate) > 0 OR  PATINDEX('%아르바이트%',@Cate) > 0
	BEGIN
		SET @Cate1 = '1'
	END

IF PATINDEX('%부동산%',@Cate) > 0  OR  PATINDEX('%집값%',@Cate) > 0 OR PATINDEX('%전세%',@Cate) > 0 OR  PATINDEX('%월세%',@Cate) > 0 OR  PATINDEX('%아파트%',@Cate) > 0 OR  PATINDEX('%상가%',@Cate) > 0 OR  PATINDEX('%빌라%',@Cate) > 0
	BEGIN
		SET @Cate2 = '1'
	END

IF PATINDEX('%자동차%',@Cate) > 0  OR  PATINDEX('%중고차%',@Cate) > 0
	BEGIN
		SET @Cate3 = '1'
	END


SET @CateReturn = @Cate1 + @Cate2 + @Cate3

	RETURN(@CateReturn)
END

GO
