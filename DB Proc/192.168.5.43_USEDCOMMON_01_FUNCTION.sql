USE [USEDMAIN]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ClearHTMLTags]    Script Date: 2021-11-04 오전 10:44:35 ******/
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
(@String NVARCHAR(4000))

RETURNS NVARCHAR(4000)
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
/****** Object:  UserDefinedFunction [dbo].[FN_MAGID_TO_NAME]    Script Date: 2021-11-04 오전 10:44:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 이름 
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016/07/18
 *  수   정   자 :
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : SELECT DBO.FN_MAGID_TO_NAME('kkam1234')
 *************************************************************************************/
CREATE FUNCTION [dbo].[FN_MAGID_TO_NAME]
(
  @MAGID                       VARCHAR(30)   = ''           -- 쿠폰중간 연결자
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE @RETVAL VARCHAR(50)
	IF @MAGID =''
	BEGIN
		SET	@RETVAL = '-'
	END
	ELSE 
	BEGIN
--		SELECT TOP 1 @RETVAL = MAGNAME FROM MWDB.DBO.COMMONMAGUSER WHERE MAGID = @MAGID
		SELECT @RETVAL = @MAGID
	END
	RETURN ISNULL(@RETVAL,'-')
END
GO
