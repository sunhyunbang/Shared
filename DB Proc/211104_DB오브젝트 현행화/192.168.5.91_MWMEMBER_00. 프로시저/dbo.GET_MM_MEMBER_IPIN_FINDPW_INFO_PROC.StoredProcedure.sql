USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_IPIN_FINDPW_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 찾기>선택한 회원의 정보 노출
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016-08-12
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 찾기(본인인증으로 찾기)
 *  주 의  사 항 :
 *  사 용  소 스 :
 GET_MM_MEMBER_IPIN_FINDPW_INFO_PROC '2', 'cowto7602', 'MC0GCCqGSIb3DQIJAyEAXp0R0iksNDa5CISpI/nssxqZj6pDwnw5l4S9yonyXWY=', '206-85-26551'
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_IPIN_FINDPW_INFO_PROC]
  @MEMBER_CD   CHAR(1)
, @USERID      VARCHAR(50)
, @DI          CHAR(64)
, @BIZNO       CHAR(12)=''
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)

SET @SQL=''

IF @MEMBER_CD='1'  --개인회원
BEGIN
    SET @SQL='
    SELECT CASE
                WHEN LEFT(HPHONE,3) IN (''010'',''011'',''016'',''017'',''018'',''019'') THEN SUBSTRING(HPHONE, 1 , LEN(HPHONE)-4)+''****''
                ELSE ''''
           END AS HPHONE
         , CASE WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-1))> 3 THEN SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-4)+''***''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           ELSE SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-3)+''**''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           END AS EMAIL
				 , HPHONE AS HPHONE1
				 , EMAIL AS EMAIL1
         , CUID
      FROM CST_MASTER WITH (NOLOCK)
     WHERE MEMBER_CD=''1''
       AND USERID='''+@USERID+'''
       AND OUT_YN=''N''
       AND DI='''+@DI+''''
END
ELSE    --기업회원
BEGIN
    SET @SQL='
    SELECT CASE
                WHEN LEFT(M.HPHONE,3) IN (''010'',''011'',''016'',''017'',''018'',''019'') THEN SUBSTRING(M.HPHONE, 1 , LEN(M.HPHONE)-4)+''****''
                ELSE ''''
           END AS HPHONE
         , CASE WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-1))> 3 THEN SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-4)+''***''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           ELSE SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-3)+''**''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           END AS EMAIL
				 , HPHONE AS HPHONE1
				 , EMAIL AS EMAIL1
         , M.CUID
      FROM CST_MASTER AS M WITH (NOLOCK)
      JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID=M.COM_ID
     WHERE M.MEMBER_CD=''2''
       AND M.USERID='''+@USERID+'''
       AND M.OUT_YN=''N''
       AND M.DI='''+@DI+'''
       AND C.REGISTER_NO='''+@BIZNO+''' '

END

PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL
GO
