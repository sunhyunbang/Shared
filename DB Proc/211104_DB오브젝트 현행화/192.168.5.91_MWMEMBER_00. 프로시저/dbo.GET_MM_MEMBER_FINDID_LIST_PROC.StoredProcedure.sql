USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDID_LIST_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
 EXEC DBO.GET_MM_MEMBER_FINDID_LIST_PROC 'H','1','김영훈','','','','01050016099'
 exec dbo.GET_MM_MEMBER_FINDID_LIST_PROC 'H','1','박인지','19801101','F','            ','01073577221'
 exec dbo.GET_MM_MEMBER_FINDID_LIST_PROC 'H','1','조민기','19770713','M','            ','01063930923'
 exec dbo.GET_MM_MEMBER_FINDID_LIST_PROC 'H','2','박인지','19801101','M','206-85-26551','01073577221'
 *************************************************************************************/

CREATE   PROC [dbo].[GET_MM_MEMBER_FINDID_LIST_PROC]
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
DECLARE @SQL_PARAM NVARCHAR(1000)
SET @SQL=''
SET @SQL_PARAM = '
  @SEARCHTYPE  CHAR(1)   
  ,@MEMBER_CD   CHAR(1)
  ,@USERNAME    VARCHAR(30)
  ,@JUMINNO     CHAR(8)
  ,@GENDER      CHAR(1)
  ,@BIZNO       CHAR(12)
  ,@SEARCHVAL   VARCHAR(50)
'

IF @MEMBER_CD='1'  --개인회원
BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',USERID) > 0 THEN SUBSTRING(USERID, 1, PATINDEX(''%@%'',USERID)-3)+''***''+SUBSTRING(USERID, PATINDEX(''%@%'',USERID), LEN(USERID)-PATINDEX(''%@%'',USERID)+1) ELSE SUBSTRING(USERID, 1 , LEN(USERID)-3)+''***'' END AS USERID_HINT
         , ''['' + ISNULL(CO.CODE_VALUE,''일반'') + ''] '' +  + REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),''/'',''.'') AS JOIN_DT
         , CUID	
		 , JOIN_DT JOINDT
	 FROM CST_MASTER A WITH (NOLOCK)
	 LEFT OUTER JOIN CMN_CODE  CO ON  CODE_GROUP_ID =''SNS_TYPE'' AND CO.CODE_ID = ISNULL(A.SNS_TYPE,'''')
     WHERE MEMBER_CD=''1''
       AND USER_NM=@USERNAME
       --AND BIRTH=@JUMINNO
       --AND GENDER=@GENDER
       AND OUT_YN=''N''
       '

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(HPHONE,''-'','''')=@SEARCHVAL )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND EMAIL=@SEARCHVAL '
    END

		SET @SQL=@SQL+' ORDER BY JOINDT DESC '
END
ELSE    --기업회원
BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',T.USERID) > 0 THEN SUBSTRING(T.USERID, 1, PATINDEX(''%@%'',T.USERID)-3)+''***''+SUBSTRING(T.USERID, PATINDEX(''%@%'',T.USERID), LEN(T.USERID)-PATINDEX(''%@%'',T.USERID)+1) ELSE SUBSTRING(T.USERID, 1 , LEN(T.USERID)-3)+''***'' END AS USERID_HINT
         , ''['' + ISNULL(CO.CODE_VALUE,''일반'') + ''] '' +  + REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),''/'',''.'') AS JOIN_DT
         , T.CUID   
		 , T.JOINDT
      FROM ( 
						SELECT M.USERID, M.JOIN_DT, M.CUID, M.SNS_TYPE, M.JOIN_DT JOINDT
							FROM CST_MASTER AS M WITH (NOLOCK)
							JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID = M.COM_ID
						 WHERE M.MEMBER_CD=''2''
							 AND M.USER_NM=@USERNAME
							 AND M.OUT_YN=''N''
							 AND C.REGISTER_NO=@BIZNO '

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(M.HPHONE,''-'','''')= @SEARCHVAL )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND M.EMAIL=@SEARCHVAL '
    END

		SET @SQL=@SQL+'
						GROUP BY M.USERID, M.JOIN_DT, M.CUID ,M.SNS_TYPE
		) AS T
	 LEFT OUTER JOIN CMN_CODE  CO ON  CODE_GROUP_ID =''SNS_TYPE'' AND CO.CODE_ID = ISNULL(T.SNS_TYPE,'''')
		
		ORDER BY T.JOINDT DESC '
END

PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM,
  @SEARCHTYPE  
  ,@MEMBER_CD  
  ,@USERNAME   
  ,@JUMINNO    
  ,@GENDER     
  ,@BIZNO      
  ,@SEARCHVAL  
GO
