USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MWSALES_API_MEMBER_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 영업시스템 > API > 벼룩시장 회원
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2016/04/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_MWSALES_API_MEMBER_PROC 'bluesky','' ,'' ,'' ,'' ,'' ,''
 *************************************************************************************/


CREATE PROC [dbo].[GET_MWSALES_API_MEMBER_PROC]

  @CUSTOMERID     VARCHAR(50) = ''
  ,@CORPNO        VARCHAR(50) = ''
  ,@CORPNAME      VARCHAR(50) = ''
  ,@TELNO         VARCHAR(50) = ''
  ,@MOBILENO      VARCHAR(50) = ''
  ,@NAME          VARCHAR(50) = ''
  ,@CUSTOMERNO    VARCHAR(50) = ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(MAX)  = ''
  DECLARE @SQL_WHERE VARCHAR(1000)  = ''
  
  -- 아이디
  IF LEN(@CUSTOMERID) > 0
    SET @SQL_WHERE += ' AND A.USERID = '''+ @CUSTOMERID +''''

  -- 사업자등록번호
  IF LEN(@CORPNO) > 0
    SET @SQL_WHERE += ' AND B.REGISTER_NO = '''+ @CORPNO +''''

  -- 상호명(회사명)
  IF LEN(@CORPNAME) > 0
    SET @SQL_WHERE += ' AND B.COM_NM LIKE ''%'+ @CORPNAME +'%'''

  -- 전화번호 (회원은 전화번호가 없으므로 휴대폰번호로 조회)
  IF LEN(@TELNO) > 0
    SET @SQL_WHERE += ' AND B.MAIN_PHONE LIKE ''%'+ @TELNO +'%'''

  -- 휴대폰
  IF LEN(@MOBILENO) > 0
    SET @SQL_WHERE += ' AND A.HPHONE LIKE ''%'+ @MOBILENO +'%'''

  -- 대표이름(사용자이름)
  IF LEN(@NAME) > 0
    SET @SQL_WHERE += ' AND B.CEO_NM LIKE ''%'+ @NAME +'%'''

  -- 고객번호 (해당없음)


  -- Result   (본서버 적용시 _MM 앞에 "_" 제거!!!!!!!!!!!!!!!!!!!!!!!)
  SET @SQL = 'SELECT A.USERID AS customerId
        ,0 AS customerNo
        ,B.REGISTER_NO AS corpNo
        ,B.COM_NM AS corpName
        ,B.PHONE AS telNo
        ,A.HPHONE AS MobileNo
        ,A.CUID
    FROM CST_MASTER AS A
      LEFT JOIN CST_COMPANY AS B ON B.COM_ID = A.COM_ID
   WHERE A.REST_YN = ''N''
     '+ @SQL_WHERE

  EXECUTE SP_EXECUTESQL @SQL
  --PRINT @SQL
GO
