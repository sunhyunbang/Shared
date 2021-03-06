USE [FINDALL_POINT]
GO
/****** Object:  UserDefinedFunction [dbo].[TEXT_SPLIT]    Script Date: 2021-11-04 오전 10:39:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[TEXT_SPLIT](
 @STEXT  VARCHAR(500),  -- 대상 문자열
 @STR   CHAR(1) = '|',       -- 구분기호(DEFAULT '|')
 @IDX  INT                       -- 배열 인덱스
)
RETURNS VARCHAR(20)
AS
BEGIN
 DECLARE @WORD    CHAR(20),    -- 반환할 문자
      @STEXTDATA  VARCHAR(600), 
      @NUM    SMALLINT;
     
 SET @NUM = 1;
 SET @STR = LTRIM(RTRIM(@STR));
 SET @STEXTDATA = LTRIM(RTRIM(@STEXT)) + @STR; 
 
 WHILE @IDX >= @NUM
 BEGIN
  IF CHARINDEX(@STR, @STEXTDATA) > 0
  BEGIN
   -- 문자열의 인덱스 위치의 요소를 반환
   SET @WORD = SUBSTRING(@STEXTDATA, 1, CHARINDEX(@STR, @STEXTDATA) - 1);
   SET @WORD = LTRIM(RTRIM(@WORD));
   -- 반환된 문자는 버린후 좌우공백 제거   
   SET @STEXTDATA = LTRIM(RTRIM(RIGHT(@STEXTDATA, LEN(@STEXTDATA) - (LEN(@WORD) + 1))))
  END ELSE BEGIN
   SET @WORD = NULL;
  END
  SET @NUM = @NUM + 1
 END
 RETURN(@WORD);
END
GO
