USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDPW_INFO_PROC_BK01]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 찾기>선택한 회원의 정보 노출
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 찾기(회원정보로 찾기)
 *  주 의  사 항 :
 *  사 용  소 스 : 
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'H', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', '01033931420'
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC_BK01 'H', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', '01033931420'
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'E', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', 'stari@mediawill.com'

 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'H', '2', 'WLRKQ60', '', '', '440-18-01158', '01031389699'
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_FINDPW_INFO_PROC_BK01]
  @SEARCHTYPE  CHAR(1)     --H:휴대폰 E:Email
, @MEMBER_CD   CHAR(1)
, @USERID      VARCHAR(50)
, @USERNAME    VARCHAR(30)
, @JUMINNO     CHAR(8)=''
, @BIZNO       CHAR(12)=''
, @SEARCHVAL   VARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)
DECLARE @SQL_PARAM NVARCHAR(4000)
set @SQL_PARAM = '
  @SEARCHTYPE  CHAR(1)  
, @MEMBER_CD   CHAR(1)
, @USERID      VARCHAR(50)
, @USERNAME    VARCHAR(30)
, @JUMINNO     CHAR(8)
, @BIZNO       CHAR(12)
, @SEARCHVAL   VARCHAR(50)
'

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
       AND USER_NM=@USERNAME
       AND USERID=@USERID
       --AND BIRTH=@JUMINNO
       AND OUT_YN=''N'''

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(HPHONE,''-'','''')=@SEARCHVAL  )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND EMAIL=@SEARCHVAL '
    END
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
       --AND M.USER_NM= @USERNAME 
       AND M.USERID=@USERID 
       AND M.OUT_YN=''N''
       AND C.REGISTER_NO=@BIZNO '

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(M.HPHONE,''-'','''')= @SEARCHVAL )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND M.EMAIL= @SEARCHVAL'
    END
END

PRINT @SQL
--EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM,
--  @SEARCHTYPE  
--, @MEMBER_CD   
--, @USERID      
--, @USERNAME    
--, @JUMINNO     
--, @BIZNO       
--, @SEARCHVAL   

GO
