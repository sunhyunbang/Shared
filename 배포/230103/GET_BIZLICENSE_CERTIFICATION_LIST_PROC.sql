USE MWMEMBER
GO
/*************************************************************************************    
 *  단위 업무 명 : 회원관리 > 기업정보 인증관리 리스트    
 *  작   성   자 : 황 민 수    
 *  작   성   일 : 2022/11/22    
 *  수   정   자 :    
 *  수   정   일 :    
 *  설        명 :    
 *  주 의  사 항 :    
 *  사 용  소 스 :    
 *  사 용  예 제 : EXEC GET_BIZLICENSE_CERTIFICATION_LIST_PROC 1, 20, '', '', '', '', '', '', '', 'E'  
   
 exec DBO.GET_BIZLICENSE_CERTIFICATION_LIST_PROC 1,20,'1','2022-11-16','2022-11-23',' ',' ',' ',''  
  
  exec DBO.GET_BIZLICENSE_CERTIFICATION_LIST_PROC 1,20,'1','2022-11-16','2022-11-23',' ',' ','2','894-22-01425'  
  
  exec DBO.GET_BIZLICENSE_CERTIFICATION_LIST_PROC 1,20,'1','2022-12-14','2022-12-21','Y',' ','3','slhong'  
  
*************************************************************************************/    
ALTER PROC [dbo].[GET_BIZLICENSE_CERTIFICATION_LIST_PROC]    
(    
  @PAGE INT = 1    
, @PAGESIZE INT = 20    
, @DATETYPE CHAR(1)   -- 기간 타입 ('':전체, 1:인증일, 2:취소일)    
, @STARTDATE VARCHAR(10) -- 시작일    
, @ENDTDATE VARCHAR(10)  -- 종료일    
, @CERT_YN CHAR(1)      -- 처리여부 ('': 전체, 'Y':인증완료, 'N':'인증취소')   
, @AUTO_HANDLE VARCHAR(1) -- 처리상태 ('': 전체, 'Y':자동처리)    
, @SEARCHTYPE CHAR(1) -- 검색타입 ('': 전체, 1:회사명(COM_NM), 2:사업자등록번호, 3:ID(USER_ID), 3:처리자(MAG_NM) )    
, @KEYWORD VARCHAR(100)  -- 검색어    
, @CERTTYPE_YN CHAR(1)  -- 인증방식 ( O : 인증서류 , N : 국세청)
, @SELTYPE CHAR(1)  = 'L'  
)    
As  
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
DECLARE @STR_SQL NVARCHAR(MAX)  
DECLARE @CNT_SQL NVARCHAR(MAX)  
DECLARE @WHERE_SQL NVARCHAR(MAX)  
DECLARE @PASING_SQL NVARCHAR(MAX)  
  
----------------------------------------------------------------------------------------------------------------------------------------- 검색조건   
SET @PASING_SQL = ''  
IF @SELTYPE = 'L'  
BEGIN  
  SET @PASING_SQL = + ' WHERE ROWNUM BETWEEN ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE - @PAGESIZE + 1) + ' AND ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE)  
 + ' ORDER BY ROWNUM ASC'  
END  
       
SET @WHERE_SQL = ''  
  
-- 1:인증일, 2:취소일   
IF @DATETYPE <> ''    
BEGIN    
  
  IF @DATETYPE = '1'   
  BEGIN  
 SET @WHERE_SQL = @WHERE_SQL + ' AND (CC.BIZLICENSE_REGDATE >= '''+ @STARTDATE +' 00:00:00'' AND CC.BIZLICENSE_REGDATE <= '''+ @ENDTDATE +' 23:59:59'')'    
  END  
  ELSE  
  BEGIN  
 SET @WHERE_SQL = @WHERE_SQL + ' AND (CC.BIZLICENSE_CANCELDATE >= '''+ @STARTDATE +' 00:00:00'' AND CC.BIZLICENSE_CANCELDATE <= '''+ @ENDTDATE +' 23:59:59'')'    
  END  
  
END    
  
-- 처리 여부  
IF @CERT_YN <> ''    
BEGIN    
  
  IF @CERT_YN = 'Y'   
  BEGIN  
 SET @WHERE_SQL = @WHERE_SQL + ' AND CC.BIZLICENSE_CERTIFICATION_YN = ''Y'' '    
  END  
  ELSE  
  BEGIN  
 SET @WHERE_SQL = @WHERE_SQL + ' AND CC.BIZLICENSE_CERTIFICATION_YN = ''N'' '    
  END  
  
END    
  
-- 1:인증일, 2:취소일   
IF @KEYWORD <> ''    
BEGIN    
  
  IF @SEARCHTYPE = '1'  -- 회사명  
  BEGIN  
 SET @WHERE_SQL = @WHERE_SQL + ' AND CC.COM_NM = ''' + @KEYWORD + ''''    
  END  
  ELSE IF @SEARCHTYPE = '2' -- 사업자등록번호    
  BEGIN    
   SET @WHERE_SQL = @WHERE_SQL + ' AND CC.REGISTER_NO = ''' + @KEYWORD + ''''  
  END   
  ELSE IF @SEARCHTYPE = '3' -- ID    
  BEGIN    
   SET @WHERE_SQL = @WHERE_SQL + ' AND CM.USERID = ''' + @KEYWORD + ''''  
  END     
  ELSE -- 처리자  
  BEGIN  
 SET @WHERE_SQL = @WHERE_SQL + ' AND CC.BIZLICENSE_HANDLE_ID = ''' + @KEYWORD + ''''  
  END  
  
END    
  
-- 자동 처리 여부  
IF @AUTO_HANDLE = 'Y'   
BEGIN  
 SET @WHERE_SQL = @WHERE_SQL + ' AND CC.BIZLICENSE_HANDLE_ID = ''AUTO'' '    
END  

--인증 방식  
IF @CERTTYPE_YN <> ''    
BEGIN    
  
  IF @CERTTYPE_YN = 'O'   -- 인증서류(OCR 인증)
  BEGIN  
    SET @WHERE_SQL = @WHERE_SQL + ' AND CC.BIZ_CERTIFICATION_TYPE = ''O'' '    
  END  
  ELSE  -- 국세청 인증
  BEGIN  
    SET @WHERE_SQL = @WHERE_SQL + ' AND CC.BIZ_CERTIFICATION_TYPE = ''N'' '    
  END  
  
END    

--PRINT @WHERE_SQL  
  
----------------------------------------------------------------------------------------------------------------------------------------- 검색조건     
  
  
    
    
SET @CNT_SQL = '  
   SELECT COUNT(CC.COM_ID) AS CNT  
   FROM CST_COMPANY AS CC WITH(NOLOCK)  
 JOIN CST_MASTER AS CM ON CC.COM_ID = CM.COM_ID   
 LEFT JOIN CST_JOIN_INFO AS CJI ON CM.CUID = CJI.CUID  
 LEFT JOIN PAPER_NEW.DBO.PP_BRAND_BRANCH_TB AS BBT ON CM.CUID = BBT.CUID AND BBT.CANCEL_YN = ''N''  
 WHERE BIZLICENSE_CERTIFICATION_YN IS NOT NULL   
 '+ @WHERE_SQL  
  
PRINT @CNT_SQL  
EXECUTE SP_EXECUTESQL @CNT_SQL  
  
SET @STR_SQL = '  
SELECT A.*   
FROM (  
 SELECT   
   ROW_NUMBER() OVER (ORDER BY CC.BIZLICENSE_REGDATE DESC) AS ROWNUM  
 , CC.BIZLICENSE_CERTIFICATION_YN  
 , CC.BIZLICENSE_REGDATE  
 , CC.COM_NM  
 , CC.REGISTER_NO  
 , CC.BIZLICENSE_ISSUANCEDATE  
 , CC.BIZLICENSE_IMGNM  
 , CC.MOD_ID   
 , CM.CUID  
 , CM.USERID  
 , CM.REST_YN  
 , CM.BAD_YN  
 , CM.OUT_YN  
 , CM.JOIN_DT  
 , CJI.SECTION_CD  
 , BBT.BRANCH_CODE  
 , CC.COM_ID  
 , CC.BIZLICENSE_HANDLE_ID  
 , CC.BIZ_OPENDT  
 , CC.BIZ_CERTIFICATION_TYPE  
 FROM CST_COMPANY AS CC WITH(NOLOCK)  
 JOIN CST_MASTER AS CM ON CC.COM_ID = CM.COM_ID   
 LEFT JOIN CST_JOIN_INFO AS CJI ON CM.CUID = CJI.CUID  
 LEFT JOIN PAPER_NEW.DBO.PP_BRAND_BRANCH_TB AS BBT ON CM.CUID = BBT.CUID AND BBT.CANCEL_YN = ''N''  
 WHERE CC.BIZLICENSE_CERTIFICATION_YN IS NOT NULL  
 ' + @WHERE_SQL + ') AS A ' + @PASING_SQL  
   
  
--PRINT @STR_SQL  
EXECUTE SP_EXECUTESQL @STR_SQL  
    
                                   
  