USE [ACCDB1]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_mwseeddecode]    Script Date: 2021-11-04 오전 10:38:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_mwseeddecode] (@data AS varbinary(2048))
RETURNS varchar(2048) AS
BEGIN
	IF(@data = 0x00 OR @data is NULL)
	BEGIN
		return NULL
	END
	DECLARE @outdata1 varchar(2048)
	EXEC master.dbo.xp_mwseeddecode_byte @data, @outdata1 OUTPUT, 2
	RETURN @outdata1
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_mwseeddecode_byte]    Script Date: 2021-11-04 오전 10:38:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_mwseeddecode_byte] (@data AS varbinary(2048))
RETURNS char(2048) AS
BEGIN
	DECLARE @outdata1 char(2048)
	EXEC master.dbo.xp_mwseeddecode_byte @data, @outdata1 OUTPUT
	RETURN @outdata1
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_mwseedencode]    Script Date: 2021-11-04 오전 10:38:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_mwseedencode] (@data TEXT)
RETURNS varbinary(2048) AS
BEGIN
	IF(LEN(CAST(@data as char(2048))) <= 0 OR @data is NULL)
	BEGIN
		return NULL
	END
	DECLARE @inputdata CHAR(2048)
	DECLARE @outdata1 varbinary(2048)
	SET @inputdata = @data
	EXEC master.dbo.xp_mwseedencode_byte @inputdata, @outdata1 OUTPUT
	RETURN @outdata1
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_mwseedencode_byte]    Script Date: 2021-11-04 오전 10:38:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_mwseedencode_byte] (@data TEXT)
RETURNS varbinary(2048) AS
BEGIN
	DECLARE @inputdata CHAR(2048)
	DECLARE @outdata1 varbinary(2048)
	SET @inputdata = @data
	EXEC master.dbo.xp_mwseedencode_byte @inputdata, @outdata1 OUTPUT
	RETURN @outdata1
END
GO
