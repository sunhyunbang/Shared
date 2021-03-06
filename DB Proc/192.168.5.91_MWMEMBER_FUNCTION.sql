USE [MWMEMBER]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_AREA_A_SHORTNAME]    Script Date: 2021-11-04 오전 11:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 지역 명칭 변환 (Full Name)
 *  작   성   자 : 신 장 순 (jssin@mediawill.com)
 *  작   성   일 : 2015/01/26
 *  설        명 : - 야알바 주소갱신때 사용
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : SELECT DBO.[FN_AREA_A_FULLNAME]('서울')
 *************************************************************************************/
CREATE FUNCTION [dbo].[FN_AREA_A_SHORTNAME](
  @AREA_A VARCHAR(20)
)
RETURNS VARCHAR(50)
AS
BEGIN

  DECLARE @RESULT VARCHAR(50)
  SET @RESULT = ''

  IF @AREA_A = '강원도'
		BEGIN
			SET @RESULT = '강원'
		END
	ELSE IF @AREA_A = '경기도'
		BEGIN
			SET @RESULT = '경기'
		END
	ELSE IF @AREA_A = '경상남도'
		BEGIN
			SET @RESULT = '경남'
		END
	ELSE IF @AREA_A = '경상북도'
		BEGIN
			SET @RESULT = '경북'
		END
	ELSE IF @AREA_A = '전라남도'
		BEGIN
			SET @RESULT = '전남'
		END
	ELSE IF @AREA_A = '전라북도'
		BEGIN
			SET @RESULT = '전북'
		END
	ELSE IF @AREA_A = '제주도'
		BEGIN
			SET @RESULT = '제주'
		END
	ELSE IF @AREA_A = '제주특별자치도'
		BEGIN
			SET @RESULT = '제주'
		END
	ELSE IF @AREA_A = '충청남도'
		BEGIN
			SET @RESULT = '충남'
		END
	ELSE IF @AREA_A = '충청북도'
		BEGIN
			SET @RESULT = '충북'
		END
	ELSE IF @AREA_A = '광주광역시'
		BEGIN
			SET @RESULT = '광주'
		END
	ELSE IF @AREA_A = '대구광역시'
		BEGIN
			SET @RESULT = '대구'
		END
	ELSE IF @AREA_A = '대전광역시' OR @AREA_A = '대전시'
		BEGIN
			SET @RESULT = '대전'
		END
	ELSE IF @AREA_A = '부산광역시'
		BEGIN
			SET @RESULT = '부산'
		END
	ELSE IF @AREA_A = '서울특별시'
		BEGIN
			SET @RESULT = '서울'
		END
	ELSE IF @AREA_A = '세종특별자치시'
		BEGIN
			SET @RESULT = '세종'
		END
	ELSE IF @AREA_A = '울산광역시'
		BEGIN
			SET @RESULT = '울산'
		END
	ELSE IF @AREA_A = '인천광역시'
		BEGIN
			SET @RESULT = '인천'
		END
	ELSE
		BEGIN
			SET @RESULT = @AREA_A
		END

  RETURN @RESULT

END








GO
/****** Object:  UserDefinedFunction [dbo].[FN_CITY]    Script Date: 2021-11-04 오전 11:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 성별 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2012/11/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : SELECT DBO.FN_CITY('전라남도')
 *************************************************************************************/

create FUNCTION [dbo].[FN_CITY](
  @CITY VARCHAR(50)
)
RETURNS VARCHAR(50)

AS

BEGIN

  DECLARE @RESULT VARCHAR(100)
  SET @RESULT = ''

  IF @CITY LIKE '서울%'
    SET @RESULT = '서울'
  ELSE IF @CITY LIKE '인천%'
    SET @RESULT = '인천'
  ELSE IF @CITY LIKE '부산%'
    SET @RESULT = '부산'
  ELSE IF @CITY LIKE '대구%'
    SET @RESULT = '대구'
  ELSE IF @CITY LIKE '대전%'
    SET @RESULT = '대전'
  ELSE IF @CITY LIKE '울산%'
    SET @RESULT = '울산'
  ELSE IF @CITY LIKE '광주%'
    SET @RESULT = '광주'
  ELSE IF @CITY LIKE '강원%'
    SET @RESULT = '강원'
  ELSE IF @CITY LIKE '경기%'
    SET @RESULT = '경기'
  ELSE IF @CITY LIKE '경상북%'
    SET @RESULT = '경북'
  ELSE IF @CITY LIKE '경상남%'
    SET @RESULT = '경남'
  ELSE IF @CITY LIKE '전라북%'
    SET @RESULT = '전북'
  ELSE IF @CITY LIKE '전라남%'
    SET @RESULT = '전남'
  ELSE IF @CITY LIKE '충청남%'
    SET @RESULT = '충남'
  ELSE IF @CITY LIKE '충청북%'
    SET @RESULT = '충북'
  ELSE IF @CITY LIKE '제주%'
    SET @RESULT = '제주'
  ELSE IF @CITY LIKE '세종%'
    SET @RESULT = '세종'
  ELSE
    SET @RESULT = @CITY

  
  RETURN @RESULT

END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERID_SECURE]    Script Date: 2021-11-04 오전 11:02:26 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERNM_SECURE]    Script Date: 2021-11-04 오전 11:02:26 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SEARCH]    Script Date: 2021-11-04 오전 11:02:26 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE]    Script Date: 2021-11-04 오전 11:02:26 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE_V2]    Script Date: 2021-11-04 오전 11:02:26 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE_V2_BACKUP]    Script Date: 2021-11-04 오전 11:02:26 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE_V3]    Script Date: 2021-11-04 오전 11:02:26 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_GetSplitSeparatorCount]    Script Date: 2021-11-04 오전 11:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
* 기능 : 구분자로 분리한 배열 사이즈 리턴
* 설명 : 문자열에서 구분자(@InputSeparator)로 배열의 사이즈 리턴
* 예제 : SELECT 데이터베이스명.소유자명.fn_GetSplitSeparatorCount('A|B|C','|') ==> 3

				SELECT [PAPER_NEW].[DBO].[fn_GetSplitSeparatorCount_V2]('A','|')
				SELECT [PAPER_NEW].[DBO].[fn_GetSplitSeparatorCount_V2]('A|B','|')
				SELECT [PAPER_NEW].[DBO].[fn_GetSplitSeparatorCount_V2]('A|B|C','|')
*************************************************************************************/
--DROP   FUNCTION  [DBO].[fn_GetSplitSeparatorCount]

CREATE FUNCTION  [dbo].[fn_GetSplitSeparatorCount](
	@InputText					VARCHAR(4000)		= ''
	, @InputSeparator		VARCHAR(10)			= '|'
)
RETURNS  VARCHAR(200)
AS
BEGIN
    DECLARE @ToPickOutData		VARCHAR(4000)
	SET @ToPickOutData = replace(@InputText,@InputSeparator,'')
    RETURN(len(@InputText) - len(@ToPickOutData)+ 1)
END




GO
/****** Object:  UserDefinedFunction [dbo].[FN_MD5]    Script Date: 2021-11-04 오전 11:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_MD5] (@DATA VARCHAR(100))
    RETURNS CHAR(32)
AS
BEGIN
    DECLARE @HASH CHAR(32)
    SELECT @HASH=LOWER(CONVERT(VARCHAR(32),HASHBYTES('MD5',@DATA),2))
    RETURN @HASH
END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_PHONE_STRING]    Script Date: 2021-11-04 오전 11:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
* 기능 : 구분자로 분리한 배열 사이즈 리턴
* 설명 : 문자열에서 구분자(@InputSeparator)로 배열의 사이즈 리턴
* 예제 : SELECT 데이터베이스명.소유자명.fn_GetSplitSeparatorCount('A|B|C','|') ==> 3

				SELECT [DBO].[FN_PHONE_STRING]('010-3127-3287')
				SELECT [DBO].[FN_PHONE_STRING]('01031273287')
*************************************************************************************/
--DROP   FUNCTION  [DBO].[fn_GetSplitSeparatorCount]

CREATE FUNCTION  [dbo].[FN_PHONE_STRING](
	@InputText					VARCHAR(4000)		= ''
)
RETURNS  VARCHAR(200)
AS
BEGIN
	declare @MIDLEN INT
	declare @PHONETXT varchar(20)=''
	IF replace(@InputText,'-','')  = @InputText 
	BEGIN
		SET @MIDLEN = case when len(@InputText) = 10 then 3 else 4 end 
		set @PHONETXT =  LEFT(@InputText,3) +'-' +right(LEFT(@InputText,3+@MIDLEN),@MIDLEN)  +'-' + RIGHT(@InputText,4)
	END
	ELSE BEGIN
		set @PHONETXT = @InputText
	END
	return @PHONETXT
END




GO
/****** Object:  UserDefinedFunction [dbo].[FN_SERVICE_USE_AGGRE_SECTION]    Script Date: 2021-11-04 오전 11:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 이용동의에 대한 명칭 통합하여 가져오기(구인구직, 부동산, 자동차, 상품서비스, 부동산써브) 
 *  작   성   자 : 배진용
 *  작   성   일 : 2021/08/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : https://admin.findall.co.kr:444/member/MemberDetail.asp
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : SELECT [MWMEMBER].[DBO].[FN_SERVICE_USE_AGGRE_SECTION]('S101')
 *************************************************************************************/

CREATE FUNCTION [dbo].[FN_SERVICE_USE_AGGRE_SECTION](
  @SECTION_CD VARCHAR(50)
)
RETURNS VARCHAR(50)

AS

BEGIN

  DECLARE @RESULT VARCHAR(100)
  SET @RESULT = ''
  IF @SECTION_CD = 'S102' OR @SECTION_CD = 'M401' OR @SECTION_CD = 'A401' OR @SECTION_CD = 'I401'
    SET @RESULT = '구인구직'
  ELSE IF @SECTION_CD = 'S101' OR @SECTION_CD = 'M001' OR @SECTION_CD = 'A001' OR @SECTION_CD = 'I001'
    SET @RESULT = '벼룩시장'
	ELSE IF @SECTION_CD = 'M601'
    SET @RESULT = '로컬 모바일웹'
	ELSE IF @SECTION_CD = 'A402'
    SET @RESULT = '맞춤취업'
	ELSE IF @SECTION_CD = 'S103' OR @SECTION_CD = 'M301' OR @SECTION_CD = 'A301' OR @SECTION_CD = 'I301'
    SET @RESULT = '부동산'
	ELSE IF @SECTION_CD = 'H001' OR @SECTION_CD = 'M501'
    SET @RESULT = '부동산써브'
	ELSE IF @SECTION_CD = 'S105'
    SET @RESULT = '상품/서비스'
	ELSE IF @SECTION_CD = 'A403'
    SET @RESULT = '생산/기술/건설'
	ELSE IF @SECTION_CD = 'S106'
    SET @RESULT = '야알바'
	ELSE IF @SECTION_CD = 'A404'
    SET @RESULT = '요리음식'
	ELSE IF @SECTION_CD = 'S104'
    SET @RESULT = '자동차'
	ELSE IF @SECTION_CD = 'S117'
    SET @RESULT = '테니스코리아'
	ELSE IF @SECTION_CD = 'S107'
    SET @RESULT = '파인드올로컬'
	ELSE IF @SECTION_CD = 'S118'
    SET @RESULT = '포포투'
  ELSE
    SET @RESULT = ''

  
  RETURN @RESULT

END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_SPLIT]    Script Date: 2021-11-04 오전 11:02:26 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_SPLIT_TB]    Script Date: 2021-11-04 오전 11:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 문자열을 SPLIT하여 테이블로 반환
 *  작   성   자 : 조재성
 *  작   성   일 : 2017/03/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 :
  SELECT * FROM DBO.FN_SPLIT_TB('034234^#$%$sadf1,2,3,4^#$%$', ',')
 *************************************************************************************/
CREATE FUNCTION [dbo].[FN_SPLIT_TB]
(
@ARR_TEXT VARCHAR(MAX)
,@SPLIT_CHAR VARCHAR(10)
)
RETURNS @TB TABLE
( 
IDX int IDENTITY PRIMARY KEY,
VALUE varchar(200)
)
AS
/*
- '' 값도 반환한다
- 마지막은 SPLIT_CHAR로 끝낸다
SELECT * FROM  dbo.[FN_SPLIT]('^1^^333^2^222^3^333^4^444^5^555^6^666^7^777^8^888^9^999','^') A
SELECT * FROM  dbo.[FN_SPLIT]('1^^22^^^^^^444444','^^') A
*/
BEGIN
 DECLARE
  @START_INDEX INT
 ,@END_INDEX INT
 ,@COUNTER INT
 ,@SPLIT_CHAR_LEN INT
 SELECT @SPLIT_CHAR_LEN = LEN(@SPLIT_CHAR)
 
 IF RIGHT(@ARR_TEXT,@SPLIT_CHAR_LEN)!=@SPLIT_CHAR
 BEGIN
  SET @ARR_TEXT=@ARR_TEXT+@SPLIT_CHAR
 END
 SET @ARR_TEXT=@SPLIT_CHAR+@ARR_TEXT
  
 SET @START_INDEX = 1
 SELECT @END_INDEX = CHARINDEX (@SPLIT_CHAR,@ARR_TEXT ,@START_INDEX+@SPLIT_CHAR_LEN)
 SET @COUNTER = 0
 WHILE (1=1)
 BEGIN
  SET @START_INDEX = CHARINDEX (@SPLIT_CHAR,@ARR_TEXT )
  SELECT @END_INDEX = CHARINDEX (@SPLIT_CHAR,@ARR_TEXT ,@START_INDEX+@SPLIT_CHAR_LEN)
        IF @END_INDEX <= 0 BREAK
  INSERT INTO @TB(VALUE) VALUES (SUBSTRING(@ARR_TEXT,@START_INDEX+@SPLIT_CHAR_LEN,@END_INDEX-@START_INDEX-@SPLIT_CHAR_LEN))
  SELECT @ARR_TEXT = STUFF(@ARR_TEXT,@START_INDEX,@SPLIT_CHAR_LEN,'')
  SET @COUNTER = @COUNTER + 1
 END
 RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[GET_CUID]    Script Date: 2021-11-04 오전 11:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 기업 회원 정보 가져오기
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016/08/30
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : SELECT DBO.GET_CUID('hskka')

 *************************************************************************************/
CREATE FUNCTION [dbo].[GET_CUID] (@USERID VARCHAR(50))
    RETURNS INT
AS
BEGIN
    DECLARE @CUID INT
    
    SELECT @CUID = CUID FROM CST_MASTER WITH(NOLOCK) WHERE USERID  = @USERID
    IF @@ROWCOUNT > 1 
		SET @CUID =  NULL

    RETURN @CUID
END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_STRING_TO_TABLE]    Script Date: 2021-11-04 오전 11:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 문자열을 SPLIT하여 테이블로 반환 (데이터 이관용)
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016/08/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : SELECT * FROM DBO.FN_STRING_TO_TABLE('0,1,2,3,4', ',')
 *************************************************************************************/
CREATE FUNCTION [dbo].[FN_STRING_TO_TABLE] 
(
	@LIST VARCHAR(MAX)
	, @DELIMITER CHAR(1)
)
RETURNS @SHARDS TABLE (VALUE VARCHAR(8000))
WITH SCHEMABINDING
AS
BEGIN
	DECLARE @I INT;
	SET @I = 0;
	
	WHILE @I <= LEN(@LIST)
	BEGIN
		DECLARE @N INT;
		SET @N = CHARINDEX(@DELIMITER, @LIST, @I);
		
		IF 0 = @N
		BEGIN
		   SET @N = LEN(@LIST);
		END
		
		INSERT INTO @SHARDS (VALUE) VALUES (REPLACE(SUBSTRING(@LIST, @I, @N-@I+1), @DELIMITER, ''));
		SET @I = @N+1;
	END
	RETURN;
END
GO
