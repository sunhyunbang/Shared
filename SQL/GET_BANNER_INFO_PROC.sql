USE PAPER_NEW
GO
/*************************************************************************************  
 *  단위 업무 명 : 맞춤메일 배너 정보 가져오기 
 *  작   성   자 : 방 순 현  
 *  작   성   일 : 2023/02/28
 *  설        명 :   
 *  수   정   자 :   
 *  수   정   일 :   
 *  수 정  사 항 :   
 *  주 의  사 항 :  
 *  사 용  소 스 :  
 *  사 용  예 제 :  
exec dbo.GET_BANNER_INFO_PROC  
*************************************************************************************/  
CREATE PROC [dbo].[GET_BANNER_INFO_PROC]  
 
AS  
BEGIN  
 SET NOCOUNT ON  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
 SELECT TOP 1
  IMG
 ,TITLE
 ,LINK
 ,STR_ALT
 FROM PP_MYINFO_BANNER_TB WITH(NOLOCK)  
 WHERE CONVERT(VARCHAR(10) , GETDATE() , 120) >= CONVERT(VARCHAR(10) , START_DT , 120) 
 AND CONVERT(VARCHAR(10) , GETDATE() , 120) <= CONVERT(VARCHAR(10) , END_DT , 120)
 ORDER BY IDX DESC
END  


