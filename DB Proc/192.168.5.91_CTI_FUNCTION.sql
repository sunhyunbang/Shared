USE [CTI]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERID_SECURE]    Script Date: 2021-11-04 오전 11:02:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[FN_GET_USERID_SECURE](
	@VAL varchar(50)
)

RETURNS VARCHAR(50)

AS
BEGIN
	SET @VAL = ISNULL(@VAL,'')
	DECLARE @MAIL1 VARCHAR(50) = @VAL
	DECLARE @MAIL2 VARCHAR(50)=''
	DECLARE @GBN INT = 0 
	IF @VAL = ''
		RETURN  @VAL
	
	IF @VAL LIKE '%@%' 
	BEGIN
		SET @GBN = 1
		SELECT @MAIL1  = DBO.FN_SPLIT(@VAL,'@',1)
			,@MAIL2  = DBO.FN_SPLIT(@VAL,'@',2)
	END
	SET @MAIL1 = LEFT(@MAIL1 ,LEN(@MAIL1) - 3) + '***'
	IF @GBN = 1 BEGIN
		SET @MAIL1 = @MAIL1 + '@' + @MAIL2
	END
	RETURN @MAIL1
END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERNM_SECURE]    Script Date: 2021-11-04 오전 11:02:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[FN_GET_USERNM_SECURE](
	@VAL varchar(50)
	,@LEN INT = 1
	,@OPT char(1) ='R' --R : 오른쪽* 처리,L : 왼쪽* 처리,M : 중간* 처리
)

RETURNS VARCHAR(50)

AS
BEGIN
	SET @VAL = ISNULL(@VAL,'')
   IF LEN(@VAL) = 0 
	SET @VAL = ''
   ELSE IF LEN(@VAL) = 2 
	SET @VAL = LEFT(@VAL ,@LEN) + '*'
   ELSE IF @OPT = 'R'
	SET @VAL = LEFT(@VAL ,@LEN) + replicate('*',len(@VAL) - @LEN)  
   ELSE IF @OPT = 'L'
	SET @VAL =  replicate('*',len(@VAL) - @LEN)  + RIGHT(@VAL ,@LEN)
   ELSE IF @OPT = 'M'
	SET @VAL = LEFT(@VAL ,@LEN) + replicate('*',len(@VAL) - @LEN * 2 )  + RIGHT(@VAL ,@LEN)
   

	RETURN @VAL
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE]    Script Date: 2021-11-04 오전 11:02:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[FN_GET_USERPHONE_SECURE](
	@VAL varchar(50)
	,@OPT char(1) ='M' --R : 오른쪽* 처리,M : 중간* 처리
)

RETURNS VARCHAR(50)

AS
BEGIN
	IF @VAL ='' 
	RETURN @VAL

	SET @VAL = ISNULL(@VAL,'')
	declare @TEL1 varchar(10)
	declare @TEL2 varchar(10)
	declare @TEL3 varchar(10)
	IF len(replace(@VAL,'-','')) = len(@VAL) 
	BEGIN
		SET @TEL1 = left(@VAL,3)
		SET @TEL2 = RIGHT(left(@VAL ,len(@VAL) - 4),len(@VAL) - 7)
		SET @TEL3 = RIGHT(@VAL,4)
	END
	ELSE 
	BEGIN
		SET @VAL = @VAL + '--'
		SET @TEL1 = DBO.FN_SPLIT( @VAL,'-',1)
		SET @TEL2 = DBO.FN_SPLIT( @VAL,'-',2)
		SET @TEL3 = DBO.FN_SPLIT( @VAL,'-',3)

	END
		IF @OPT='R' 
			SET @TEL3 = '****'
		ELSE 
			SET @TEL2 = '****'
		
	RETURN @TEL1 + '-' + @TEL2 + '-' + @TEL3 
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE_V2]    Script Date: 2021-11-04 오전 11:02:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GET_USERPHONE_SECURE_V2](
	 @VAL varchar(50)
	,@OPT char(1) ='M'  --R : 오른쪽* 처리,M : 중간* 처리
	,@str CHAR(1) = '|' -- 구분기호(Default '|')
)

RETURNS VARCHAR(50)

AS
BEGIN
	IF @VAL = '' 
	RETURN @VAL

	DECLARE @strcnt INT
	DECLARE @i INT    
	DECLARE @VAL1 varchar(20)
	DECLARE @VAL2 varchar(20)
	DECLARE @VAL_ENC1 varchar(20)
	DECLARE @VAL_ENC2 varchar(20)
	DECLARE @VAL_ENC varchar(50)
	SET @strcnt = 0
	
	SET @strcnt = (SELECT CHARINDEX(@str,@VAL))
	IF @strcnt > 0 
	BEGIN
    	   
		SET @i = 1

		WHILE  @i < 3
		BEGIN
		    IF @i = 1
			BEGIN
				SET @VAL1 = SUBSTRING(@VAL,0,CHARINDEX(@str,@VAL))                -- 앞번호 추출
				SET @VAL_ENC1 = (SELECT dbo.FN_GET_USERPHONE_SECURE(@VAL1,@OPT))	    
			END
			ELSE
			BEGIN
				SET @VAL2 = SUBSTRING(@VAL,CHARINDEX(@str,@VAL) + 1, LEN(@VAL))   -- 뒷번호 추출
				SET @VAL_ENC2 = (SELECT dbo.FN_GET_USERPHONE_SECURE(@VAL2,@OPT))	
			END
				
			SET @i = @i + 1  
	    END
	
	    SET @VAL_ENC = @VAL_ENC1 + '' + @str + ''  + @VAL_ENC2
	
    END
	ELSE
	BEGIN
		SET @VAL_ENC = (SELECT dbo.FN_GET_USERPHONE_SECURE(@VAL,@OPT)) 
	END

	RETURN @VAL_ENC
END			
GO
/****** Object:  UserDefinedFunction [dbo].[FN_SPLIT]    Script Date: 2021-11-04 오전 11:02:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_SPLIT](    
 @sText  VARCHAR(max),  -- 대상 문자열    
 @str   CHAR(1) = '|',       -- 구분기호(Default '|')    
 @idx  INT                       -- 배열 인덱스    
    
    
)    
RETURNS VARCHAR(max)    
AS    
BEGIN    
 DECLARE @word    varchar(max),    -- 반환할 문자    
      @sTextData  VARCHAR(600),    
      @num    SMALLINT;    
    
 SET @num = 1;    
 SET @str = LTRIM(RTRIM(@str));    
 SET @sTextData = LTRIM(RTRIM(@sText)) + @str;    
    
 WHILE @idx >= @num    
 BEGIN    
    
    
  IF CHARINDEX(@str, @sTextData) > 0    
  BEGIN    
   -- 문자열의 인덱스 위치의 요소를 반환    
   SET @word = SUBSTRING(@sTextData, 1, CHARINDEX(@str, @sTextData) - 1);    
   SET @word = LTRIM(RTRIM(@word));    
    
    
   -- 반환된 문자는 버린후 좌우공백 제거    
   SET @sTextData = LTRIM(RTRIM(RIGHT(@sTextData, LEN(@sTextData) - (LEN(@word) + 1))))    
  END ELSE BEGIN    
   SET @word = NULL;    
  END    
  SET @num = @num + 1    
 END    
    
 IF LEN(RTRIM(@word)) = 0    
  BEGIN    
    SET @word = NULL;    
  END    
    
 RETURN(@word);    
    
END    
    
GO
