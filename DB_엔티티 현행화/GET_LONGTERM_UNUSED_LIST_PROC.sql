--USE COMMON  
/*************************************************************************************    
 *  단위 업무 명 : 장기미이용회원 정보 리스트 가져오기  [2시01분]  
 *  작   성   자 :    
 *  작   성   일 : 2021/12/10    
 *  설        명 :    
 *  사 용  소 스 :    
 *  사 용  예 제 : EXEC DBO.GET_LONGTERM_UNUSED_LIST_PROC  
 *************************************************************************************/    
CREATE PROCEDURE [dbo].[GET_LONGTERM_UNUSED_LIST_PROC]  
  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
 SET NOCOUNT ON;  
  
-- 장기미이용회원 정보 2시01분
  SELECT  
    USERID  
    , USERNAME  
    , EMAIL  
    , JOIN_DT  
    , LOGIN_DT  
    , REST_DT  
    , OUT_DT
  FROM  [COMMON].[DBO].[GET_MM_LONGTERM_UNUSED_VI]  
  
END  
  