USE [FINDCOMMON]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ADDZERO]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 1자리 숫자 앞에 0 붙이기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/01/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : SELECT DBO.FN_ADDZERO(3)
 *************************************************************************************/

CREATE FUNCTION [dbo].[FN_ADDZERO](
  @VALUE INT
)
RETURNS VARCHAR(2)

AS

BEGIN

  DECLARE @RESULT VARCHAR(2)

  IF LEN(@VALUE) = 1
    SET @RESULT = '0'+ CAST(@VALUE AS VARCHAR(1))
  ELSE
    SET @RESULT = CAST(@VALUE AS VARCHAR(2))

  RETURN @RESULT

END




GO
/****** Object:  UserDefinedFunction [dbo].[FN_ADM_CHKMONTH]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_ADM_CHKMONTH]
(
       @PAY_DT  VARCHAR(10),  --convert(varchar(10),getdate(),112)형변환 필요
       @NOW     VARCHAR(10)   --convert(varchar(10),getdate(),112)형변환 필요
)
RETURNS CHAR(3)
AS
BEGIN
    DECLARE @CUR_DT    VARCHAR(10)
    DECLARE @PAY_YEAR  VARCHAR(4)
    DECLARE @PAY_MONTH VARCHAR(2)
    DECLARE @PAY_DAY   VARCHAR(2)

    DECLARE @RETURN_VAL CHAR(3)

    /*********************** 월마감 설정이 되어있다면 ***********************/
    DECLARE @YYYYMM CHAR(6) = CAST(DATEPART(year, DATEADD(dd, 1, GETDATE())) AS VARCHAR) + dbo.FN_ADDZERO(CAST(DATEPART(month, DATEADD(dd, 1, GETDATE())) AS VARCHAR))  

    IF EXISTS(SELECT *   
                FROM TAX_CLOSING_DATE_TB  
               WHERE YYYYMM = @YYYYMM  
                 AND DD = DATEPART(day, DATEADD(dd, 1, GETDATE())))  
      BEGIN  
        RETURN 'DIS'
      END  
    /*********************** 월마감 설정이 되어있다면 ***********************/

    SET @CUR_DT = @NOW
    --SET @PAY_YEAR = YEAR(DATEADD(MONTH, 2,@PAY_DT))
	SET @PAY_YEAR = YEAR(DATEADD(MONTH, 1,@PAY_DT))
	--SET @PAY_MONTH = MONTH(DATEADD(MONTH, 2,@PAY_DT))
   SET @PAY_MONTH = MONTH(DATEADD(MONTH, 1,@PAY_DT))

    IF @PAY_DT>@CUR_DT	--결제일이 현재날짜보다 크다
    BEGIN
      RETURN 'DIS'
    END

    IF LEN(@PAY_MONTH)=1
      SET @PAY_MONTH='0'+@PAY_MONTH

    SELECT @PAY_DAY=DD FROM TAX_CLOSING_DATE_TB WITH (NOLOCK)
     WHERE YYYYMM=@PAY_YEAR+@PAY_MONTH

    IF @@ROWCOUNT=0
    BEGIN
      SET @PAY_DAY='05'
    END
    ELSE
    BEGIN
      IF LEN(@PAY_DAY)=1
        SET @PAY_DAY='0'+@PAY_DAY
    END    

    IF @CUR_DT <= CAST(@PAY_YEAR+@PAY_MONTH+@PAY_DAY AS VARCHAR) 
    BEGIN
		  SET @RETURN_VAL='ENA'
    END
    ELSE
    BEGIN
		  SET @RETURN_VAL='DIS'
    END


       --SET @RETURN_VAL = 'DIS'   -- 착오에 의한 이중발급 노출시 주석해제
	  RETURN @RETURN_VAL
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ADM_CHKMONTH_20210205]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[FN_ADM_CHKMONTH_20210205]
(
       @PAY_DT  VARCHAR(10),  --convert(varchar(10),getdate(),112)형변환 필요
       @NOW     VARCHAR(10)   --convert(varchar(10),getdate(),112)형변환 필요
)
RETURNS CHAR(3)
AS
BEGIN
    DECLARE @CUR_DT    VARCHAR(10)
    DECLARE @PAY_YEAR  VARCHAR(4)
    DECLARE @PAY_MONTH VARCHAR(2)
    DECLARE @PAY_DAY   VARCHAR(2)

    DECLARE @RETURN_VAL CHAR(3)

    SET @CUR_DT = @NOW
    SET @PAY_YEAR = YEAR(DATEADD(MONTH, 1,@PAY_DT))
    SET @PAY_MONTH = MONTH(DATEADD(MONTH, 1,@PAY_DT))

    IF @PAY_DT>@CUR_DT	--결제일이 현재날짜보다 크다
    BEGIN
      RETURN 'DIS'
    END

    IF LEN(@PAY_MONTH)=1
      SET @PAY_MONTH='0'+@PAY_MONTH

    SELECT @PAY_DAY=DD FROM TAX_CLOSING_DATE_TB WITH (NOLOCK)
     WHERE YYYYMM=@PAY_YEAR+@PAY_MONTH

    IF @@ROWCOUNT=0
    BEGIN
      SET @PAY_DAY='05'
    END
    ELSE
    BEGIN
      IF LEN(@PAY_DAY)=1
        SET @PAY_DAY='0'+@PAY_DAY
    END    

    IF @CUR_DT <= CAST(@PAY_YEAR+@PAY_MONTH+@PAY_DAY AS VARCHAR) 
    BEGIN
		  SET @RETURN_VAL='ENA'
    END
    ELSE
    BEGIN
		  SET @RETURN_VAL='DIS'
    END


      -- SET @RETURN_VAL = 'DIS'   -- 착오에 의한 이중발급 노출시 주석해제
	  RETURN @RETURN_VAL
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ADM_CHKQUARTER]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_ADM_CHKQUARTER]
(
       @PAY_DT  VARCHAR(10),	--CONVERT 타입을 112로 동일하게 지정
       @NOW     VARCHAR(10)		--CONVERT(VARCHAR(8),GETDATE(),112)
)
RETURNS CHAR(3)
AS
BEGIN
  DECLARE @CUR_DT   VARCHAR(10)
	DECLARE @CUR_YEAR  VARCHAR(4)
  DECLARE @LAST_YEAR VARCHAR(4)
  DECLARE @RETURN_VAL CHAR(3)

  SET @CUR_DT = @NOW
  SET @CUR_YEAR = YEAR(@CUR_DT)
  SET @LAST_YEAR = YEAR(DATEADD(YEAR, -1 ,@PAY_DT))

  /*********************************************************************/
  --신년 개인업자 세금계산서 마감 처리 위한 예외 처리(2015/01/07)
  --신혜원 파트장 요청
  /*********************************************************************/
  --SET @RETURN_VAL = 'ENA'
  --RETURN @RETURN_VAL

  /*********************** 분기마감 설정이 되어있다면 ***********************/
  IF EXISTS (SELECT * FROM dbo.TAX_CLOSING_DATE_TB WHERE YYYYMM = LEFT(@CUR_DT, 6) AND QUARTER_YN='ENA')
    RETURN 'ENA'
  /*********************** 분기마감 설정이 되어있다면 ***********************/

	IF @CUR_DT<@PAY_DT
 		RETURN 'DIS'

	IF @CUR_DT < @CUR_YEAR+'0116'
	--IF @CUR_DT < @CUR_YEAR+'0120'
    BEGIN
    	IF @PAY_DT >= @LAST_YEAR+'1001'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT < @CUR_YEAR+'0416'
	--ELSE IF @CUR_DT < @CUR_YEAR+'0421'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'0101'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT < @CUR_YEAR+'0716'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'0401'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT < @CUR_YEAR+'1016'
	--ELSE IF @CUR_DT < @CUR_YEAR+'1020'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'0701'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT >= @CUR_YEAR+'1016'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'1001'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END

	RETURN @RETURN_VAL
  
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ADM_CHKQUARTER_20210205]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT dbo.[FN_ADM_CHKQUARTER]('2020-04-22','2020-04-23')
*/

create FUNCTION [dbo].[FN_ADM_CHKQUARTER_20210205]
(
       @PAY_DT  VARCHAR(10),	--CONVERT 타입을 112로 동일하게 지정
       @NOW     VARCHAR(10)		--CONVERT(VARCHAR(10),GETDATE(),112)
)
RETURNS CHAR(3)
AS
BEGIN
  DECLARE @CUR_DT   VARCHAR(10)
	DECLARE @CUR_YEAR  VARCHAR(4)
  DECLARE @LAST_YEAR VARCHAR(4)

  DECLARE @RETURN_VAL CHAR(3)

  SET @CUR_DT = @NOW
  SET @CUR_YEAR = YEAR(@CUR_DT)
  SET @LAST_YEAR = YEAR(DATEADD(YEAR, -1,@PAY_DT))


  /*********************************************************************/
  --신년 개인업자 세금계산서 마감 처리 위한 예외 처리(2015/01/07)
  --신혜원 파트장 요청
  /*********************************************************************/

  --SET @RETURN_VAL='ENA'
  --RETURN @RETURN_VAL
  

	IF @CUR_DT<@PAY_DT
 		RETURN 'DIS'

	IF @CUR_DT < @CUR_YEAR+'0116'
	--IF @CUR_DT < @CUR_YEAR+'0120'
    BEGIN
    	IF @PAY_DT >= @LAST_YEAR+'1001'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT < @CUR_YEAR+'0416'
	--ELSE IF @CUR_DT < @CUR_YEAR+'0421'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'0101'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT < @CUR_YEAR+'0716'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'0401'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT < @CUR_YEAR+'1016'
	--ELSE IF @CUR_DT < @CUR_YEAR+'1020'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'0701'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT >= @CUR_YEAR+'1016'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'1001'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END

	RETURN @RETURN_VAL
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_CHKMONTH]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_CHKMONTH]
(
       @PAY_DT  VARCHAR(10),
       @NOW     VARCHAR(10)
)
RETURNS CHAR(3)
AS
BEGIN
    DECLARE @CUR_DT   VARCHAR(10)
    DECLARE @PAY_YEAR  VARCHAR(10)
    DECLARE @PAY_MONTH VARCHAR(2)

    DECLARE @RETURN_VAL CHAR(3)

    SET @CUR_DT = @NOW
    SET @PAY_YEAR = YEAR(DATEADD(MONTH, 1,@PAY_DT))
    SET @PAY_MONTH = MONTH(DATEADD(MONTH, 1,@PAY_DT))

    IF @PAY_DT>@CUR_DT	--결제일이 현재날짜보다 크다
    BEGIN
        RETURN 'DIS'
    END

    IF LEN(@PAY_MONTH)=1
       SET @PAY_MONTH='0'+@PAY_MONTH

    IF @CUR_DT < CAST(@PAY_YEAR+@PAY_MONTH+'06' AS VARCHAR(10))
    BEGIN
		SET @RETURN_VAL='ENA'
    END
    ELSE
    BEGIN
		SET @RETURN_VAL='DIS'
    END

	RETURN @RETURN_VAL
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_CHKQUARTER]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_CHKQUARTER]
(
       @PAY_DT  VARCHAR(10),	--CONVERT 타입을 112로 동일하게 지정
       @NOW     VARCHAR(10)		--CONVERT(VARCHAR(10),GETDATE(),112)
)
RETURNS CHAR(3)
AS
BEGIN
  DECLARE @CUR_DT   VARCHAR(10)
	DECLARE @CUR_YEAR  VARCHAR(4)
  DECLARE @LAST_YEAR VARCHAR(4)

  DECLARE @RETURN_VAL CHAR(3)

  SET @CUR_DT = @NOW
  SET @CUR_YEAR = YEAR(@CUR_DT)
  SET @LAST_YEAR = YEAR(DATEADD(YEAR, -1,@PAY_DT))

  --신년 개인업자 세금계산서 마감 처리 위한 예외 처리(2015/01/07)
  --신혜원 파트장 요청
  --SET @RETURN_VAL='ENA'

	IF @CUR_DT<@PAY_DT
 		RETURN 'DIS'

	IF @CUR_DT < @CUR_YEAR+'0116'
    BEGIN
    	IF @PAY_DT >= @LAST_YEAR+'1001'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT < @CUR_YEAR+'0416'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'0101'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT < @CUR_YEAR+'0716'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'0401'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT < @CUR_YEAR+'1016'
	--ELSE IF @CUR_DT < @CUR_YEAR+'1020'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'0701'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END
	ELSE IF @CUR_DT >= @CUR_YEAR+'1016'
    BEGIN
    	IF @PAY_DT >= @CUR_YEAR+'1001'
			SET @RETURN_VAL='ENA'
        ELSE
			SET @RETURN_VAL='DIS'
	END

	RETURN @RETURN_VAL
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ECOMM_OPTIONNAME]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_ECOMM_OPTIONNAME]
(
  @MAINOPTNAME VARCHAR(50)
  ,@DISPLAY_OPT INT

)

RETURNS VARCHAR(50)

AS

BEGIN

  DECLARE @SUBOPTNAME VARCHAR(50) = ''
  DECLARE @RETURN_VAL VARCHAR(50)
/*
  IF @DISPLAY_OPT > 0
    SET @SUBOPTNAME = @SUBOPTNAME + '외 효과옵션'
*/
  IF @DISPLAY_OPT & 1 = 1
    SET @SUBOPTNAME = @SUBOPTNAME + ' 테두리'
  IF @DISPLAY_OPT & 2 = 2
    SET @SUBOPTNAME = @SUBOPTNAME + ' 깜빡로고'
  IF @DISPLAY_OPT & 4 = 4
    SET @SUBOPTNAME = @SUBOPTNAME + ' 형광펜'
  IF @DISPLAY_OPT & 16 = 16
    SET @SUBOPTNAME = @SUBOPTNAME + ' 볼드'
  IF @DISPLAY_OPT & 32 = 32
    SET @SUBOPTNAME = @SUBOPTNAME + ' 컬러'

  IF @SUBOPTNAME <> ''
    SET @RETURN_VAL = @MAINOPTNAME +'_'+ LTRIM(@SUBOPTNAME)
  ELSE
    SET @RETURN_VAL = @MAINOPTNAME

  RETURN @RETURN_VAL

END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERID_SECURE]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERNM_SECURE]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SEARCH]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE_V2]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE_V2_BACKUP]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GET_USERPHONE_SECURE_V3]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_LINEADNO]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : LINEADNO 채번
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2014/12/04
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : SELECT DBO.FN_LINEADNO(47778, 180, 180)
 *************************************************************************************/
CREATE FUNCTION [dbo].[FN_LINEADNO]
(
   @LINEADID INT
  ,@INPUT_BRANCH TINYINT
  ,@LAYOUT_BRANCH TINYINT
)
RETURNS CHAR(16)
AS
BEGIN

  DECLARE @RESULT CHAR(16)

	 SET @RESULT = right('0000000000' + CONVERT(VARCHAR(10), @LINEADID), 10)  + right('000' + CONVERT(VARCHAR(3), @INPUT_BRANCH), 3) +  right('000' + CONVERT(VARCHAR(3), @LAYOUT_BRANCH), 3)

  RETURN @RESULT

END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_MD5]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_mwseeddecode]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_mwseeddecode_byte]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_mwseedencode]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_mwseedencode_byte]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_SECTION_NM]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_SECTION_NM] (@SECTIONCODE varchar(100) )
    RETURNS VARCHAR(100)
AS
BEGIN
return 
case when @SECTIONCODE = 0 then '계정관리'
when @SECTIONCODE = 90 then '회원 관리'
when @SECTIONCODE = 91 then '정산 관리'
when @SECTIONCODE = 1 then '파인드올'
when @SECTIONCODE = 2 then '잡/알바 관리'
when @SECTIONCODE = 3 then '알바천국'

when @SECTIONCODE = 4 then '부동산'
when @SECTIONCODE = 6 then '중고장터'
when @SECTIONCODE = 7 then '구인구직 MWPLUS'
when @SECTIONCODE = 8 then '키워드'
when @SECTIONCODE = 9 then '신문 직접등록'
when @SECTIONCODE = 10 then '벼룩시장 부동산 MWPLUS'
when @SECTIONCODE = 11 then '간호잡'
when @SECTIONCODE = 12 then '야알바'
when @SECTIONCODE = 13 then '신문'
when @SECTIONCODE = 14 then 'MWPLUS OR BOX 광고 등록 프로그램'
when @SECTIONCODE = 17 then '야알바 MWPLUS'
when @SECTIONCODE = 18 then '부동산써브 MWPLUS'
when @SECTIONCODE = 19 then '업소홈피'
when @SECTIONCODE = 20 then 'BAR24'
when @SECTIONCODE = 21 then '강사닷컴'
when @SECTIONCODE = 22 then '신문박스등록'
when @SECTIONCODE = 24 then '부동산써브'
when @SECTIONCODE = 25 then '모바일 관리자'
when @SECTIONCODE = 26 then '다방'

when @SECTIONCODE = 27 then '벼룩시장 구인구직'
when @SECTIONCODE = 28 then '벼룩시장 부동산'
when @SECTIONCODE = 29 then '벼룩시장 자동차/상품서비스 (미사용)'
when @SECTIONCODE = 30 then '통합 회원 관리자 싱글뷰'
when @SECTIONCODE = 31 then '게시판'
else @SECTIONCODE end 



END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_SHA256]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_SHA256] (@DATA VARCHAR(100))
    RETURNS varbinary(256)
AS
BEGIN
    DECLARE @HASH  varbinary(256)
    SELECT @HASH=master.DBO.fnGetStringToSha256(@DATA) 
    
    RETURN @HASH
    
    
     
     
END


GO
/****** Object:  UserDefinedFunction [dbo].[FN_SPLIT]    Script Date: 2021-11-04 오전 10:40:15 ******/
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
/****** Object:  UserDefinedFunction [dbo].[QUARTER_STARTDT]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[QUARTER_STARTDT](@CURDATE AS VARCHAR(10))
	RETURNS VARCHAR(10)
AS 

BEGIN
	--DECLARE @CURDATE VARCHAR(10)
	DECLARE @QUARTER TINYINT
	DECLARE @DAY INT
	DECLARE @MONTH INT
	DECLARE @YEAR INT
	
	DECLARE @START_DT VARCHAR(10)
	
	--SET @CURDATE = CONVERT(VARCHAR(10),GETDATE(),111)	GETDATE() 사용불가
	SET @QUARTER=DATENAME(qq,@CURDATE)
	SET @DAY = DAY(@CURDATE)
	SET @MONTH = MONTH(@CURDATE)
	SET @YEAR = YEAR(@CURDATE)
	
	
	IF @DAY<11 AND (@MONTH=1 OR @MONTH=4 OR @MONTH=7 OR @MONTH=10 )
	BEGIN
	    SET @START_DT=CAST(YEAR(DATEADD(MM,-3,@CURDATE)) AS VARCHAR)+'/'+CAST(REPLICATE('0',2-LEN( CAST(MONTH(DATEADD(MM,-3,@CURDATE)) AS VARCHAR)  ))+CAST(MONTH(DATEADD(MM,-3,@CURDATE)) AS VARCHAR) AS VARCHAR)+'/01'
	END
	ELSE --IF @DAY>10
	BEGIN
	    SET @START_DT=CAST(YEAR(@CURDATE) AS VARCHAR)+'/'+CAST(REPLICATE('0',2-LEN(@QUARTER*3-2))+CAST((@QUARTER*3-2) AS VARCHAR) AS VARCHAR)+'/01'
	END

	RETURN 	@START_DT
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_SPLIT_TB]    Script Date: 2021-11-04 오전 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 문자열을 SPLIT하여 테이블로 반환 (데이터 이관용)
 *  작   성   자 : 정헌수
 *  작   성   일 : 2014/09/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : ,
 *  사 용  소 스 : 
 *  사 용  예 제 :
  SELECT * FROM DBO.FN_SPLIT_TB('034234^#$%$sadf1,2,3,4^#$%$', ',')
  go
  SELECT * FROM DBO.FN_SPLIT_TB('034234^#$%$sadf1,2,3,4^#$%$', ',')
 *************************************************************************************/
 
 CREATE FUNCTION [dbo].[FN_SPLIT_TB](
 @ARR_TEXT VARCHAR(4000)
 ,@SPLIT_CHAR varchar(10) =','
)

RETURNS TABLE
AS

	RETURN
	WITH CTE_PIECE(IDX, START, STOP) AS (
		SELECT 
			1, 1, CHARINDEX(@SPLIT_CHAR, @ARR_TEXT)
			
		UNION ALL
		SELECT  --재귀호출
			IDX + 1, STOP + LEN(@SPLIT_CHAR), CHARINDEX(@SPLIT_CHAR, @ARR_TEXT, STOP + LEN(@SPLIT_CHAR))
		FROM CTE_PIECE
		WHERE STOP > 0
	)
	SELECT
		IDX
		, SUBSTRING(@ARR_TEXT, START, CASE WHEN STOP > 0 THEN STOP - START ELSE 4000 END ) AS VALUE
	FROM CTE_PIECE




GO
