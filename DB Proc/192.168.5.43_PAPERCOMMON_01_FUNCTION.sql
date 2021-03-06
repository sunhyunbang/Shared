USE [PAPERCOMMON]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERID_SECURE]    Script Date: 2021-11-04 오전 10:42:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*



select dbo.FN_GET_USERID_SECURE('kkamang')
select dbo.FN_GET_USERID_SECURE('kkamang@naver.com')

*/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERNM_SECURE]    Script Date: 2021-11-04 오전 10:42:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

select replicate('*',3)

select dbo.FN_GET_USERNM_SECURE('',1,'R')
select dbo.FN_GET_USERNM_SECURE('정헌',1,'M')
select dbo.FN_GET_USERNM_SECURE('정수수/수헌수',1,'M')


*/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SEARCH]    Script Date: 2021-11-04 오전 10:42:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 전화번호 검색
 *  작   성   자 : 도 정 민
 *  작   성   일 : 2019/05/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 다중 전화번호 검색 가능(전화번호 컬럼값이 3개 이상 일때 사용하는 함수) 
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 *************************************************************************************/
CREATE FUNCTION [dbo].[FN_GET_USERPHONE_SEARCH](
	 @VAL varchar(1000)
	,@searchword varchar(1000) =''  
	,@str CHAR(1) = ',' -- 구분기호(Default ',')
)

RETURNS VARCHAR(1000)

AS
BEGIN
	DECLARE @VAL1 varchar(1000)
	DECLARE @VAL2 varchar(1000)
	DECLARE @RETURNVALUE varchar(1000) 
	DECLARE @cnt int
	DECLARE @i int

	SET @i = 0

	/* -를 공백처리 */
	SET @VAL = REPLACE(@VAL,'-','')
	SET @searchword = REPLACE(@searchword,'-','')

	/* 전화번호 갯수 구하기 */
	SET @cnt  = LEN(@VAL) - LEN(REPLACE(@VAL,@str,'')) + 1

	IF @cnt > 1 
	BEGIN 
		WHILE(@i < @cnt)
		BEGIN 
				IF(CHARINDEX(@str,@VAL) > 0) 
				BEGIN	
					SET @VAL1 = SUBSTRING(@VAL, 1, CHARINDEX(@str,@VAL) - 1)  

					IF @VAL1 = @searchword 
					BEGIN
					   SET @RETURNVALUE = @VAL1
					   RETURN @RETURNVALUE
					END
					ELSE
					BEGIN
					   SET @VAL2 = SUBSTRING(@VAL, LEN(@VAL1) + 2, LEN(@VAL))
					END 
				
					SET @VAL = @VAL2
				END
				ELSE
				BEGIN
				    IF @VAL2 = @searchword 
					BEGIN
						SET @RETURNVALUE = @VAL2
						RETURN @RETURNVALUE
					END
					ELSE
					BEGIN
						SET @RETURNVALUE = NULL
						RETURN @RETURNVALUE
					END
				END
				
				SET @i = @i + 1
		END				
	END
	ELSE
	BEGIN
	    IF  @VAL = @searchword
		BEGIN 
			SET @RETURNVALUE = @VAL
			RETURN @RETURNVALUE
		END
		ELSE
		BEGIN
			SET @RETURNVALUE = NULL
			RETURN @RETURNVALUE
		END
	END

	RETURN @RETURNVALUE
END			



GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE]    Script Date: 2021-11-04 오전 10:42:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

select replicate('*',3)

select dbo.FN_GET_USERPHONE_SECURE('01031273287','R')


*/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE_V2]    Script Date: 2021-11-04 오전 10:42:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 전화번호 반환V2
 *  작   성   자 : 도 정 민
 *  작   성   일 : 2019/05/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 다중 전화번호 마스킹 처리 및 반환 가능(전화번호 컬럼값이 3개 이상 일때 사용하는 함수) 
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 *************************************************************************************/
CREATE FUNCTION [dbo].[FN_GET_USERPHONE_SECURE_V2](
	 @VAL varchar(1000)
	,@OPT char(1) ='M'  --R : 오른쪽* 처리,M : 중간* 처리
	,@str CHAR(1) = ',' -- 구분기호(Default ',')
)

RETURNS VARCHAR(1000)

AS
BEGIN
	DECLARE @VAL1 varchar(1000)
	DECLARE @VAL2 varchar(1000)
	DECLARE @VAL_ENC varchar(1000) = ''
	DECLARE @VAL_ENC1 varchar(1000) = ''
	DECLARE @cnt int
	DECLARE @i int

	SET @i = 0

	/* 전화번호 갯수 구하기 */
	SET @cnt  = LEN(@VAL) - LEN(REPLACE(@VAL,@str,'')) + 1

	IF @cnt > 1 
	BEGIN 

		--전화번호 마스킹 적용
		WHILE(@i < @cnt)
		BEGIN 
				IF(CHARINDEX(@str,@VAL) > 0) 
				BEGIN	
					SET @VAL1 = SUBSTRING(@VAL, 1, CHARINDEX(@str,@VAL) - 1)  
					SET @VAL2 = SUBSTRING(@VAL, LEN(@VAL1) + 2, LEN(@VAL))

					IF LEN(@VAL1) < 11   
					BEGIN    
						IF LEN(@VAL1) < 4	  
						BEGIN 
							SET @VAL_ENC1 = @VAL1 + @str
							SET @VAL_ENC = @VAL_ENC + @VAL_ENC1
						END
						ELSE
						BEGIN
							SET @VAL_ENC1 = (SELECT dbo.FN_GET_USERID_SECURE(@VAL1)) + @str	
							SET @VAL_ENC = @VAL_ENC + @VAL_ENC1
						END
					END 
					ELSE
					BEGIN
						SET @VAL_ENC1 = dbo.FN_GET_USERPHONE_SECURE(@VAL1,@OPT) + @str 
						SET @VAL_ENC = @VAL_ENC + @VAL_ENC1
					END

					SET @i = @i + 1
					SET @VAL = @VAL2
				END
				ELSE
				BEGIN
				    SET @VAL2 = SUBSTRING(@VAL, 1, LEN(@VAL))
				 
				    IF LEN(@VAL2) < 11
					BEGIN
					    IF LEN(@VAL2) < 4	 
						BEGIN
						    SET @VAL_ENC = @VAL_ENC + @VAL2
						END
						ELSE
						BEGIN
						    SET @VAL_ENC = @VAL_ENC + dbo.FN_GET_USERID_SECURE(@VAL2)
						END
					END
					ELSE
					BEGIN
					     SET @VAL_ENC = @VAL_ENC + dbo.FN_GET_USERPHONE_SECURE(@VAL2,@OPT)
					END
							
					SET @i = @i + 1
					SET @VAL2 = ''
					SET @VAL = @VAL2
				END
		END
	END
	ELSE
	BEGIN
			IF LEN(@VAL) < 11  
			BEGIN    
				  IF LEN(@VAL) < 4	  
				  BEGIN 
						SET @VAL_ENC = @VAL 
				  END
				  ELSE
				  BEGIN
						SET @VAL_ENC = (SELECT dbo.FN_GET_USERID_SECURE(@VAL))
				  END
			END 
			ELSE
			BEGIN
				SET @VAL_ENC = (SELECT dbo.FN_GET_USERPHONE_SECURE(@VAL,@OPT)) 
			END
	END

	RETURN @VAL_ENC
END			



GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE_V2_BACKUP]    Script Date: 2021-11-04 오전 10:42:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 전화번호 반환V2
 *  작   성   자 : 도 정 민
 *  작   성   일 : 2019/04/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 전화번호 2개까지 마스킹 처리해서 반환 가능  
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 *************************************************************************************/
CREATE FUNCTION [dbo].[FN_GET_USERPHONE_SECURE_V2_BACKUP](
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
		
		IF LEN(@VAL) < 10   
		BEGIN              
			SET @VAL_ENC = (SELECT dbo.FN_GET_USERID_SECURE(@VAL))			
		END
		ELSE
		BEGIN
			WHILE  @i < 3
			BEGIN
				IF @i = 1
				BEGIN
				    SET @VAL1 = SUBSTRING(@VAL,0,CHARINDEX(@str,@VAL))                -- 앞번호 추출
				   
				    IF LEN(@VAL1) < 10   
					BEGIN              
						SET @VAL_ENC1 = (SELECT dbo.FN_GET_USERID_SECURE(@VAL1))			
					END
					ELSE
					BEGIN
						SET @VAL_ENC1 = (SELECT dbo.FN_GET_USERPHONE_SECURE(@VAL1,@OPT)) 
					END		   
				END
				ELSE
				BEGIN
					SET @VAL2 = SUBSTRING(@VAL,CHARINDEX(@str,@VAL) + 1, LEN(@VAL))   -- 뒷번호 추출

					IF LEN(@VAL2) < 10   
					BEGIN              
						SET @VAL_ENC2 = (SELECT dbo.FN_GET_USERID_SECURE(@VAL2))			
					END
					ELSE
					BEGIN
						SET @VAL_ENC2 = (SELECT dbo.FN_GET_USERPHONE_SECURE(@VAL2,@OPT)) 
					END
				END
				
				SET @i = @i + 1  
			END
	
			SET @VAL_ENC = @VAL_ENC1 + '' + @str + ''  + @VAL_ENC2
		END
	
    END
	ELSE
	BEGIN
	    IF LEN(@VAL) < 10   
		BEGIN              
			SET @VAL_ENC = (SELECT dbo.FN_GET_USERID_SECURE(@VAL))			
		END
		ELSE
		BEGIN
			SET @VAL_ENC = (SELECT dbo.FN_GET_USERPHONE_SECURE(@VAL,@OPT)) 
		END
	END

	RETURN @VAL_ENC
END			



GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE_V3]    Script Date: 2021-11-04 오전 10:42:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 전화번호 반환V3
 *  작   성   자 : 도 정 민
 *  작   성   일 : 2019/05/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 다중 전화번호 마스킹 처리 및 반환 가능(전화번호 컬럼값이 3개 이상 일때 사용하는 함수) 
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 *************************************************************************************/
CREATE FUNCTION [dbo].[FN_GET_USERPHONE_SECURE_V3](
	 @VAL varchar(1000)
	,@OPT char(1) ='M'  --R : 오른쪽* 처리,M : 중간* 처리
	,@str CHAR(1) = ',' -- 구분기호(Default ',')
)

RETURNS VARCHAR(1000)

AS
BEGIN
	DECLARE @VAL1 varchar(1000)
	DECLARE @VAL2 varchar(1000)
	DECLARE @VAL_ENC varchar(1000) = ''
	DECLARE @VAL_ENC1 varchar(1000) = ''
	DECLARE @cnt int
	DECLARE @i int

	SET @i = 0

	/* 전화번호 갯수 구하기 */
	SET @cnt  = LEN(@VAL) - LEN(REPLACE(@VAL,@str,'')) + 1

	IF @cnt > 1 
	BEGIN 

		--전화번호 마스킹 적용
		WHILE(@i < @cnt)
		BEGIN 
				IF(CHARINDEX(@str,@VAL) > 0) 
				BEGIN	
					SET @VAL1 = SUBSTRING(@VAL, 1, CHARINDEX(@str,@VAL) - 1)  
					SET @VAL2 = SUBSTRING(@VAL, LEN(@VAL1) + 2, LEN(@VAL))

					IF LEN(@VAL1) < 11   
					BEGIN    
						IF LEN(@VAL1) < 4	  
						BEGIN 
							SET @VAL_ENC1 = @VAL1 + @str
							SET @VAL_ENC = @VAL_ENC + @VAL_ENC1
						END
						ELSE
						BEGIN
							SET @VAL_ENC1 = (SELECT dbo.FN_GET_USERID_SECURE(@VAL1)) + @str	
							SET @VAL_ENC = @VAL_ENC + @VAL_ENC1
						END
					END 
					ELSE
					BEGIN
						SET @VAL_ENC1 = dbo.FN_GET_USERPHONE_SECURE(@VAL1,@OPT) + @str 
						SET @VAL_ENC = @VAL_ENC + @VAL_ENC1
					END

					SET @i = @i + 1
					SET @VAL = @VAL2
				END
				ELSE
				BEGIN
				    SET @VAL2 = SUBSTRING(@VAL, 1, LEN(@VAL))
				 
				    IF LEN(@VAL2) < 11
					BEGIN
					    IF LEN(@VAL2) < 4	 
						BEGIN
						    SET @VAL_ENC = @VAL_ENC + @VAL2
						END
						ELSE
						BEGIN
						    SET @VAL_ENC = @VAL_ENC + dbo.FN_GET_USERID_SECURE(@VAL2)
						END
					END
					ELSE
					BEGIN
					     SET @VAL_ENC = @VAL_ENC + dbo.FN_GET_USERPHONE_SECURE(@VAL2,@OPT)
					END
							
					SET @i = @i + 1
					SET @VAL2 = ''
					SET @VAL = @VAL2
				END
		END
	END
	ELSE
	BEGIN
			IF LEN(@VAL) < 11  
			BEGIN    
				  IF LEN(@VAL) < 4	  
				  BEGIN 
						SET @VAL_ENC = @VAL 
				  END
				  ELSE
				  BEGIN
						SET @VAL_ENC = (SELECT dbo.FN_GET_USERID_SECURE(@VAL))
				  END
			END 
			ELSE
			BEGIN
				SET @VAL_ENC = (SELECT dbo.FN_GET_USERPHONE_SECURE(@VAL,@OPT)) 
			END
	END

	RETURN @VAL_ENC
END			



GO
/****** Object:  UserDefinedFunction [dbo].[FN_SPLIT]    Script Date: 2021-11-04 오전 10:42:33 ******/
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
      @sTextData  VARCHAR(700),
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
