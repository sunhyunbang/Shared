USE [KEYWORDSHOP]
GO
/****** Object:  UserDefinedFunction [dbo].[dn_f_payState]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[dn_f_payState]
	(
		@db_f_payState	char(1) = ''
	)
RETURNS varchar(12)
AS
	BEGIN
	RETURN (
		Case @db_f_payState
			When 'Y' Then 'YY'
			When 'N' Then 'NN'
			When 'C' Then 'CC'
			When 'I' Then 'II'
		End
	)
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_Add_etcMode]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 가격 가중치 적용 (임의조건에 의한 가중치 가져오기)
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_Add_etcMode]
	(
	@etcmode_1		char(1),
	@etcmode_2		char(1),
	@etcmode_3		char(1),
	@etcadd_1		float,
	@etcadd_2		float,
	@etcadd_3		float
	)
RETURNS float
AS
	BEGIN
	DECLARE
	@retData		float
	/* sql statement ... */

	SELECT
	@retData =
	(
	CASE @etcmode_1
		When 1 Then @etcadd_1
		Else 1
	END
	) *
	(
	CASE @etcmode_2
		When 1 Then @etcadd_2
		Else 1
	END
	) *
	(
	CASE @etcmode_3
		When 1 Then @etcadd_3
		Else 1
	END
	)

	RETURN @retData	/* value */
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_Add_goodGubun]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 가격 가중치 (광고 구분별 가중치 가져오기)
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_Add_goodGubun]
	(
	@goodGubun		char(1)='1',
	@goods_B		float,
	@goods_H		float,
	@goods_P		float
	)
RETURNS float
AS
	BEGIN
	DECLARE
	@retData		float
	/* sql statement ... */

	SELECT
	@retData =
	CASE @goodGubun
		When 1 Then @goods_B
		When 2 Then @goods_H
		When 3 Then @goods_P
		Else 1
	END

	RETURN @retData	/* value */
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_Add_goodRank]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 가격 가중치 적용(광고 순위별 적용하여 가중치 가져오기)
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_Add_goodRank]
	(
	@goodRank		char(1)='1',
	@step_1			float,
	@step_2			float,
	@step_3			float,
	@step_4			float,
	@step_5			float
	)
RETURNS float
AS
	BEGIN
	DECLARE
	@retData		float
	/* sql statement ... */

	SELECT
	@retData =
	CASE @goodRank
		When 1 Then @step_1
		When 2 Then @step_2
		When 3 Then @step_3
		When 4 Then @step_4
		When 5 Then @step_5
		Else 1
	END

	RETURN @retData	/* value */
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_Add_kwGrade]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 가격 가중치 적용(키워드 등급에 따른 가중치 가져오기)
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_Add_kwGrade]
	(
	@kwGrade		tinyint=1,
	@level_1		float,
	@level_2		float,
	@level_3		float,
	@level_4		float,
	@level_5		float,
	@level_6		float,
	@level_7		float,
	@level_8		float,
	@level_9		float,
	@level_10		float
	)
RETURNS float
AS
	BEGIN
	DECLARE
	@retData		float
	/* sql statement ... */

	SELECT
	@retData =
	CASE @kwGrade
		When 1 Then @level_1
		When 2 Then @level_2
		When 3 Then @level_3
		When 4 Then @level_4
		When 5 Then @level_5
		When 6 Then @level_6
		When 7 Then @level_7
		When 8 Then @level_8
		When 9 Then @level_9
		When 10 Then @level_10
		Else 1
	END

	RETURN @retData	/* value */
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_Add_kwSection]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 가격 가중치 적용 (섹션 적용하여 가중치 가져오기)
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_Add_kwSection]
	(
	@kwSection		char(1)='1',
	@section_1		float,
	@section_2		float,
	@section_3		float,
	@section_4		float,
	@section_5		float,
	@section_6		float,
	@section_7		float,
	@section_8		float
	)
RETURNS float
AS
	BEGIN
	DECLARE
	@retData		float
	/* sql statement ... */

	SELECT
	@retData =
	CASE @kwSection
		When 1 Then @section_1
		When 2 Then @section_2
		When 3 Then @section_3
		When 4 Then @section_4
		When 5 Then @section_5
		When 6 Then @section_6
		When 7 Then @section_7
		When 8 Then @section_8
		Else 1
	END

	RETURN @retData	/* value */
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_Add_ReturnPrice]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 가격 가중치 적용 하여 가격 가져오기(가중치 관련 모든함수 호출 함수임)
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_Add_ReturnPrice]
	(
	/*
	@parameter1 datatype = default value,
	@parameter2 datatype
	*/
	@kwcode			int,
	@goodGubun		char(1),
	@goodRank		char(1),
	@kwGrade		tinyint,
	@kwSection		char(1),
	@readCnt		int,
	@getDate		smalldatetime,
	@level_1		float,
	@level_2		float,
	@level_3		float,
	@level_4		float,
	@level_5		float,
	@level_6		float,
	@level_7		float,
	@level_8		float,
	@level_9		float,
	@level_10		float,
	@goods_B		float,
	@goods_H		float,
	@goods_P		float,
	@step_1			float,
	@step_2			float,
	@step_3			float,
	@step_4			float,
	@step_5			float,
	@section_1		float,
	@section_2		float,
	@section_3		float,
	@section_4		float,
	@section_5		float,
	@section_6		float,
	@section_7		float,
	@section_8		float,
	@sale_1			float,
	@sale_2			float,
	@sale_3			float,
	@etcmode_1		char(1),
	@etcmode_2		char(1),
	@etcmode_3		char(1),
	@etcadd_1		float,
	@etcadd_2		float,
	@etcadd_3		float,
	@multiplyKey	tinyint
	)
RETURNS money/* datatype */
AS
	BEGIN
	DECLARE
	@retData		money,
	@multiplyData	float
		/* sql statement ... */
	IF @goodGubun = 3
		BEGIN
			IF @multiplyKey = 1
				BEGIN
					SET @multiplyData = 0.35
				END
			ELSE IF @multiplyKey = 2
				BEGIN
					SET @multiplyData = 0.6
				END
			ELSE
				BEGIN
					SET @multiplyData = 1
				END
		END
	ELSE
		BEGIN
			SET @multiplyData = @multiplyKey
		END

		-- 천원이하 숫자 절사(Rhee, 040521)

		SELECT
		@retData = round(
		(Case When @readCnt>0 Then @readCnt Else 1 End *
		dbo.F_Add_kwGrade(@kwGrade, @level_1, @level_2, @level_3, @level_4, @level_5, @level_6, @level_7, @level_8, @level_9, @level_10) *
		dbo.F_Add_goodGubun(@goodGubun,@goods_B,@goods_H,@goods_P) *
		dbo.F_Add_goodRank(@goodRank,@step_1,@step_2,@step_3,@step_4,@step_5) *
		dbo.F_Add_kwSection(@kwSection,@section_1,@section_2,@section_3,@section_4,@section_5,@section_6,@section_7,@section_8) *
		dbo.F_Add_Sales(@kwcode,@getDate,@sale_1,@sale_2,@sale_3) *
		dbo.F_Add_etcMode(@etcmode_1,@etcmode_2,@etcmode_3,@etcadd_1,@etcadd_2,@etcadd_3) *
		@multiplyData),-3,1)

	RETURN /* value */
		@retData
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_Add_Sales]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 가격 가중치 계산시 광고 갯수에 의해 가중치 적용
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_Add_Sales]
	(
	@kwcode			int=0,
	@getDate		smalldatetime,
	@sale_1			float,
	@sale_2			float,
	@sale_3			float
	)
RETURNS float
AS
	BEGIN
	DECLARE
	@month_1		int,
	@month_2		int,
	@month_3		int,
	@retData		float

	/* sql statement ... */
	SET @month_1 = 0
	SET @month_2 = 0
	SET @month_3 = 0

	SELECT top 1 @month_1 = kwcode from tbl_adMonthCnt with (nolock) where kwcode = @kwcode and datediff(m,regDate,@getDate) = 1
	SELECT top 1 @month_2 = kwcode from tbl_adMonthCnt with (nolock) where kwcode = @kwcode and datediff(m,regDate,@getDate) = 2
	SELECT top 1 @month_3 = kwcode from tbl_adMonthCnt with (nolock) where kwcode = @kwcode and datediff(m,regDate,@getDate) = 3

	SELECT
	@retData = (
		(
		CASE When @month_1 > 0 Then @sale_1
			Else 0
		END
		) +
		(
		CASE When @month_2 > 0 Then @sale_2
			Else 0
		END
		) +
		(
		CASE When @month_3 > 0 Then @sale_3
			Else 0
		END
		)
	)
	SELECT @retData = (
		CASE WHEN @retData = 0 Then 1
			Else 0
		End
		)

	RETURN 	/* value */
		@retData
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_AdDate]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 광고 조회시 광고 날짜표시 (2004-04-01~2004-05-02)
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/


CREATE function [dbo].[F_AdDate]
	(
	@adState	char(1) = '',
	@startDate	smallDateTime,
	@endDate	smallDateTime
	)
RETURNS varchar(25)
AS
	BEGIN
	DECLARE
		@ReturnDate		varchar(25)
		/* sql statement ... */
		IF @adState = 'Y' OR @adState = 'M' OR @adState = 'N'
		BEGIN
			SET @ReturnDate = Cast(DatePart(year,@startDate) as char(4))+'.'+Cast(DatePart(month,@startDate) as char(2))+'.'+Cast(DatePart(day,@startDate) as char(2))+'~'+
			Cast(DatePart(year,@endDate) as char(4))+'.'+Cast(DatePart(month,@endDate) as char(2))+'.'+Cast(DatePart(day,@endDate) as char(2))
		END
		ELSE
		BEGIN
			SET @ReturnDate = '-'
		END
	RETURN /* value */
		@ReturnDate
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_AdState]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 광고 조회시 광고 상태표시
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_AdState]
	(
	@adState	char(1) = '',
	@authState	char(1) = '',
	@goodGubun	char(1) = '',
	@goodRank	char(1) = ''
	)
RETURNS varchar(8)
AS
	BEGIN
	DECLARE
	@ReturnAdMode	varchar(8)
		/* sql statement ... */
		IF ISNULL(@goodGubun,'') <> '' AND ISNULL(@goodRank,'') <> ''
		BEGIN
			SET @ReturnAdMode = '신청중'
		END
		ELSE
		BEGIN
			SET @ReturnAdMode =
			Case @adState
				When 'N' Then
					'판매완료'--'신청중'
				When 'Y' Then
					Case When @authState = 'Y' Then '구매신청'
						Else '판매완료'
					End
				When 'M' Then '대기중'
				When 'E' Then '구매신청'
				When 'C' Then '신청중'
				Else '구매신청'
			END
		END
	RETURN /* value */
		@ReturnAdMode
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_BizMan_AdState]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드 광고 조회시 광고 상태표시
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_BizMan_AdState]
	(
	@adState	char(1) = '',
	@authState	char(1) = ''

	)
RETURNS varchar(8)
AS
	BEGIN
	DECLARE
	@ReturnAdMode	varchar(8)
		/* sql statement ... */

		BEGIN
			SET @ReturnAdMode =
			Case @adState
				When 'N' Then
					'판매완료'--'신청중'
				When 'Y' Then
					Case When @authState = 'Y' Then '구매신청'
						Else '판매완료'
					End
				When 'M' Then '대기중'
				When 'E' Then '구매신청'
				When 'C' Then '신청중'
				Else '구매신청'
			END
		END

	RETURN /* value */
		@ReturnAdMode
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_DateFormat2]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 날짜형태 출력 (2004년4월)
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_DateFormat2]
	(
	@szDate		smalldatetime
	/*
	@parameter1 datatype = default value,
	@parameter2 datatype
	*/
	)
RETURNS varchar(20)/* datatype */
AS
	BEGIN
	DECLARE
		@ReturnDate		varchar(20)
		/* sql statement ... */
		SET @ReturnDate = Cast(DATEPART(year,@szDate) as varchar)+'년 '+Cast(DATEPART(month,@szDate) as varchar)+'월'
	RETURN /* value */
		@ReturnDate
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_isNewReport]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 광고리포트 범주 내 신청 가능 여부 판별
	제작자		: 정윤정
	제작일		: 2004.12.17
	수정자		:
	수정일		:
	파라미터

	** 마지막 신청 가능 기회를 놓친 사람에 한해, 광고가 종료됐을시, 종료일로부터
       ** 30일 안에 신청가능 기회를 준다!!!!!!!!!!!!!!!!!!!!!!!!!!!!
******************************************************************************/
CREATE function [dbo].[F_isNewReport]
	(
	@goodGubun char(1) = '',
	@period int = 0,
	@startDay smalldatetime,
	@regDate datetime,
	@today datetime
	)
RETURNS char(1)
AS
BEGIN
	DECLARE
		@gapToday 	  int,
		@numToday    int,
		@gapRegdate  int,
		@numRegdate int,
		@strReturn	  char(1),
		@num1		  int,
		@num2  		  int,
		@num3  	 	  int

	IF (@goodGubun = 1 or @goodGubun = 2)
	BEGIN
		SET @num1 = 20
		SET @num2 = 50
		SET @num3 = 80
	END
	ELSE IF(@goodGubun = 3)
	BEGIN
		SET @num1 = 5
		SET @num2 = 10
		SET @num3 = 20
	END

	SET @gapToday = DATEDIFF(day, @startDay, @today)

	IF (@gapToday > @num1 and @gapToday <= @num2)
		SET @numToday = 1
	ELSE IF(@gapToday > @num2 and @gapToday <= @num3)
		SET @numToday = 2
	ELSE IF(@gapToday > @num3)
		SET @numToday = 3

	SET @gapRegdate = DATEDIFF(day, @startDay, @regDate)

	IF (@gapRegdate > @num1 and @gapRegdate <= @num2)
		SET @numRegdate = 1
	ELSE IF(@gapRegdate > @num2 and @gapRegdate <= @num3)
		SET @numRegdate = 2
	ELSE IF(@gapRegdate > @num3)
		SET @numRegdate = 3

	IF(@numToday <= @period)
	BEGIN
		IF (@numToday > @numRegdate)
			SET	@strReturn = 'Y'
		ELSE
			SET	@strReturn = 'N'
	END
	ELSE
	BEGIN
		SET	@strReturn = 'N'
	END

	RETURN @strReturn
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_ReportAddCnt]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드별 광고 유료 갯수 가져오기
	제작자		: 이기운
	제작일		: 2004.04.24
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_ReportAddCnt]
	(
	@kwCode				int	= 0,
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = ''
	)
RETURNS int
AS
	BEGIN
		DECLARE
		@readCnt		int,
		@clickCnt		int,
		@returnData		int

		select @returnData = count(code) from tbl_keyword_adinfo2 with (nolock) where kwcode = @kwCode
			and isDC < 6						--  유료
			and
				(
					(datediff(d,startDay,@sDate) >= 0 and datediff(d,startDay,@eDate)<= 0) or
					(datediff(d,endDay,@sDate) <= 0 and datediff(d,endDay,@eDate) <= 0)
				)
	RETURN
		@returnData
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_ReportFreeAddCnt]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드별 광고 무료 갯수 가져오기
	제작자		: 이기운
	제작일		: 2004.04.24
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_ReportFreeAddCnt]
	(
	@kwCode				int	= 0,
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = ''
	)
RETURNS int
AS
	BEGIN
		DECLARE
		@readCnt		int,
		@clickCnt		int,
		@returnData		int


		select @returnData = count(code) from tbl_keyword_adinfo2 with (nolock) where kwcode = @kwCode
			and (isDC > 5 or  isDC is NULL)	--  무료
			and
				(
					(datediff(d,startDay,@sDate) >= 0 and datediff(d,startDay,@eDate)<= 0) or
					(datediff(d,endDay,@sDate) <= 0 and datediff(d,endDay,@eDate) <= 0)
				)

	RETURN
		@returnData
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_ReportSumCnt]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 키워드별 광고 노출수 및 클릭수 가져오기
	제작자		: 이기운
	제작일		: 2004.04.24
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_ReportSumCnt]
	(
	@kwCode				int	= 0,
	@sDate				varchar(10) = '',
	@eDate				varchar(10) = '',
	@keySw				char(1) = 'r'
	)
RETURNS int
AS
	BEGIN
		DECLARE
		@readCnt		int,
		@clickCnt		int,
		@returnData		int

		select @readCnt	 = isNULL(sum(readCnt),0), @clickCnt = isNULL(sum(clickCnt),0) from tbl_adCnt with (nolock) where kwCode = @kwCode
		 and Convert(varchar(10),regdate,120) >= @sDate and Convert(varchar(10),regdate,120) <= @eDate
		if @keySw = 'r'
			BEGIN
				SET @returnData = @readCnt
			END
		Else
			BEGIN
				SET @returnData = @clickCnt
			END
	RETURN
		@returnData
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_Section]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************
	설명		: 섹션명 가져오기
	제작자		: 이기운
	제작일		: 2004.04.1
	수정자		:
	수정일		:
	파라미터

******************************************************************************/

CREATE function [dbo].[F_Section]
(
	@section	int = 8
)
RETURNS varchar(12)
AS
	BEGIN
	RETURN (
		Case @section
			When 1 Then '벼룩시장신문'
			When 2 Then '상품직거래'
			When 3 Then '자동차'
			When 4 Then '부동산'
			When 5 Then '구인구직'
			When 6 Then '아르바이트'
			When 7 Then 'YP'
			Else '섹션무관'
		End
	)
	END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_CHKMONTH]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FN_CHKMONTH]
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
/****** Object:  UserDefinedFunction [dbo].[FN_CHKQUARTER]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FN_CHKQUARTER]
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
/****** Object:  UserDefinedFunction [dbo].[QUARTER_STARTDT]    Script Date: 2021-11-04 오전 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[QUARTER_STARTDT](@CURDATE AS VARCHAR(10))
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
