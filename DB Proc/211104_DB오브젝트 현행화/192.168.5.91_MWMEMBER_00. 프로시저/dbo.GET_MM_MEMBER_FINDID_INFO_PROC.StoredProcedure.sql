USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDID_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디찾기>선택한 회원의 정보 노출(USERID,JOIN_DT,HP,PHONE,EMAIL
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-05
 *  수   정   자 : 최봉기
 *  수   정   일 : 2016-08-16
 *  설        명 : 아이디 찾기(동일한 정보의 ID 목록 가져오기)
 *  주 의  사 항 :
 *  사 용  소 스 : EXEC [GET_MM_MEMBER_FINDID_INFO_PROC] 11237489
 *************************************************************************************/
CREATE  PROC [dbo].[GET_MM_MEMBER_FINDID_INFO_PROC]
  @CUID     INT
AS

  SET NOCOUNT ON

  SELECT CASE WHEN PATINDEX('%@%',USERID) > 0 THEN SUBSTRING(USERID, 1, PATINDEX('%@%',USERID)-3)+'***'+SUBSTRING(USERID, PATINDEX('%@%',USERID), LEN(USERID)-PATINDEX('%@%',USERID)+1) ELSE SUBSTRING(USERID, 1 , LEN(USERID)-3)+'***' END AS ENCUSERID
       , REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),'/','.') AS JOIN_DT
       , CASE
              WHEN LEFT(HPHONE,3) IN ('010','011','016','017','018','019') THEN SUBSTRING(HPHONE, 1 , LEN(HPHONE)-4)+'****'
              ELSE ''
         END AS HPHONE
       , CASE 
			  WHEN LEN(EMAIL)=0 OR EMAIL=NULL THEN ''
              WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX('%@%',EMAIL)-1))> 3 
					THEN SUBSTRING(EMAIL, 1, PATINDEX('%@%',EMAIL)-4)+'***'+SUBSTRING(EMAIL, PATINDEX('%@%',EMAIL), LEN(EMAIL)-PATINDEX('%@%',EMAIL)+1)
              ELSE SUBSTRING(EMAIL, 1, PATINDEX('%@%',EMAIL)-3)+'**'+SUBSTRING(EMAIL, PATINDEX('%@%',EMAIL), LEN(EMAIL)-PATINDEX('%@%',EMAIL)+1)
         END AS EMAIL
       , CUID
    FROM CST_MASTER WITH (NOLOCK)
   WHERE CUID=@CUID
GO
