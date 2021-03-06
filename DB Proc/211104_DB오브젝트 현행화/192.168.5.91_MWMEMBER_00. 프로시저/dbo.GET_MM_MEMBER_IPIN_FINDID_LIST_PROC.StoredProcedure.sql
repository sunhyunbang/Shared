USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_IPIN_FINDID_LIST_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
 *  사 용  소 스 : EXEC GET_MM_MEMBER_IPIN_FINDID_LIST_PROC '2', 'MC0GCCqGSIb3DQIJAyEAUjIzO8ukISnslSboZf74ugv63xd5uHbIpd0OJG9eqRU=', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_IPIN_FINDID_LIST_PROC]
   @MEMBER_CD   CHAR(1)  = ''
  ,@DI          CHAR(64)
  ,@BIZNO       CHAR(12) = ''
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)
DECLARE @SQL_PARAM NVARCHAR(4000)
SET @SQL_PARAM = '
   @MEMBER_CD   CHAR(1)
  ,@DI          CHAR(64)
  ,@BIZNO       CHAR(12)
'
SET @SQL=''

IF @MEMBER_CD='1'  --개인회원
  BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',USERID) > 0 THEN SUBSTRING(USERID, 1, PATINDEX(''%@%'',USERID)-3)+''***''+SUBSTRING(USERID, PATINDEX(''%@%'',USERID), LEN(USERID)-PATINDEX(''%@%'',USERID)+1) ELSE SUBSTRING(USERID, 1 , LEN(USERID)-3)+''***'' END AS USERID_HINT
          , REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),''/'',''.'') AS JOIN_DT
          , CUID
      FROM CST_MASTER WITH (NOLOCK)
      WHERE MEMBER_CD=''1''
        AND OUT_YN=''N''
        AND DI= @DI
		  ORDER BY JOIN_DT DESC '

  END
ELSE IF @MEMBER_CD='2'    --기업회원
  BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',T.USERID) > 0 THEN SUBSTRING(T.USERID, 1, PATINDEX(''%@%'',T.USERID)-3)+''***''+SUBSTRING(T.USERID, PATINDEX(''%@%'',T.USERID), LEN(T.USERID)-PATINDEX(''%@%'',T.USERID)+1) ELSE SUBSTRING(T.USERID, 1 , LEN(T.USERID)-3)+''***'' END USERID_HINT
          , REPLACE(CONVERT(VARCHAR(10), T.JOIN_DT, 111),''/'',''.'') AS JOIN_DT
          , T.CUID    
      FROM (
						SELECT M.USERID, M.JOIN_DT, M.CUID
							FROM CST_MASTER AS M WITH (NOLOCK)
							JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID = M.COM_ID
						  WHERE M.MEMBER_CD = ''2''
							  AND M.OUT_YN = ''N''
							  AND M.DI = @DI
							  AND C.REGISTER_NO = @BIZNO
						GROUP BY M.USERID, M.JOIN_DT, M.CUID
			) AS T
		ORDER BY JOIN_DT DESC '
  END
ELSE
  BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',USERID) > 0 THEN SUBSTRING(USERID, 1, PATINDEX(''%@%'',USERID)-3)+''***''+SUBSTRING(USERID, PATINDEX(''%@%'',USERID), LEN(USERID)-PATINDEX(''%@%'',USERID)+1) ELSE SUBSTRING(USERID, 1 , LEN(USERID)-3)+''***'' END AS USERID_HINT
          , REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),''/'',''.'') AS JOIN_DT
          , CUID
      FROM CST_MASTER WITH (NOLOCK)
      WHERE MEMBER_CD IN (''1'',''2'')
        AND OUT_YN=''N''
        AND DI= @DI 
		  ORDER BY JOIN_DT DESC '

  END

--PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM
  , @MEMBER_CD  
  ,@DI         
  ,@BIZNO      
GO
