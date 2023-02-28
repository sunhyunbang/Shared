USE PAPER_NEW
GO
/*************************************************************************************  
 *  ���� ���� �� : ������� ��� ���� �������� 
 *  ��   ��   �� : �� �� ��  
 *  ��   ��   �� : 2023/02/28
 *  ��        �� :   
 *  ��   ��   �� :   
 *  ��   ��   �� :   
 *  �� ��  �� �� :   
 *  �� ��  �� �� :  
 *  �� ��  �� �� :  
 *  �� ��  �� �� :  
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


