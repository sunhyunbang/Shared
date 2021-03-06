USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[__DEL__GET_MM_MEMBER_FINDID_LIST_PROC_BK_ORG_20180730]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디 찾기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 찾기(동일한 정보의 ID 목록 가져오기)
 *  주 의  사 항 :
 *  사 용  소 스 : EXEC DBO.GET_MM_MEMBER_FINDID_LIST_PROC 'H','1','성소영','','','206-85-26551','01022170355'
 *************************************************************************************/

CREATE   PROC [dbo].[__DEL__GET_MM_MEMBER_FINDID_LIST_PROC_BK_ORG_20180730]
  @SEARCHTYPE  CHAR(1)     --H:휴대폰 E:Email
  ,@MEMBER_CD   CHAR(1)
  ,@USERNAME    VARCHAR(30)
  ,@JUMINNO     CHAR(8)  = ''
  ,@GENDER      CHAR(1)  = ''
  ,@BIZNO       CHAR(12) = ''
  ,@SEARCHVAL   VARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)
SET @SQL=''

IF @MEMBER_CD='1'  --개인회원
BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',USERID) > 0 THEN SUBSTRING(USERID, 1, PATINDEX(''%@%'',USERID)-3)+''***''+SUBSTRING(USERID, PATINDEX(''%@%'',USERID), LEN(USERID)-PATINDEX(''%@%'',USERID)+1) ELSE SUBSTRING(USERID, 1 , LEN(USERID)-3)+''***'' END AS USERID_HINT
         , REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),''/'',''.'') AS JOIN_DT
         , CUID	
      FROM CST_MASTER WITH (NOLOCK)
     WHERE MEMBER_CD=''1''
       AND USER_NM='''+@USERNAME+'''
       AND BIRTH='''+@JUMINNO+'''
       AND OUT_YN=''N''
       AND GENDER='''+@GENDER+''''

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(HPHONE,''-'','''')='''+@SEARCHVAL+''' )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND EMAIL='''+@SEARCHVAL+''' '
    END

		SET @SQL=@SQL+' ORDER BY JOIN_DT DESC '
END
ELSE    --기업회원
BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',T.USERID) > 0 THEN SUBSTRING(T.USERID, 1, PATINDEX(''%@%'',T.USERID)-3)+''***''+SUBSTRING(T.USERID, PATINDEX(''%@%'',T.USERID), LEN(T.USERID)-PATINDEX(''%@%'',T.USERID)+1) ELSE SUBSTRING(T.USERID, 1 , LEN(T.USERID)-3)+''***'' END AS USERID_HINT
         , REPLACE(CONVERT(VARCHAR(10), T.JOIN_DT, 111),''/'',''.'') AS JOIN_DT
         , T.CUID   
      FROM ( 
						SELECT M.USERID, M.JOIN_DT, M.CUID 
							FROM CST_MASTER AS M WITH (NOLOCK)
							JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID = M.COM_ID
						 WHERE M.MEMBER_CD=''2''
							 AND M.USER_NM='''+@USERNAME+'''
							 AND M.OUT_YN=''N''
							 AND C.REGISTER_NO='''+@BIZNO+''' '

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(M.HPHONE,''-'','''')='''+@SEARCHVAL+''' )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND M.EMAIL='''+@SEARCHVAL+''''
    END

		SET @SQL=@SQL+'
						GROUP BY M.USERID, M.JOIN_DT, M.CUID 
		) AS T
		ORDER BY JOIN_DT DESC '
END

--PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL
GO
