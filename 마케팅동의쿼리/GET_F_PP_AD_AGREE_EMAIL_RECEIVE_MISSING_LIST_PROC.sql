/*************************************************************************************              
 *  ���� ���� �� : ������,�̺�Ʈ ���� ���� ���� �ȳ� ���� ���� ����� ���              
 *  ��   ��   �� : �����              
 *  ��   ��   �� : 2022/04/29              
 *  ��   ��   �� :              
 *  ��   ��   �� :              
 *  ��         �� :               
 *  �� ��  �� �� :              
 *  �� ��  �� �� :              
 *  �� ��  �� �� : GET_F_PP_AD_AGREE_EMAIL_RECEIVE_MISSING_LIST_PROC              
 *************************************************************************************/               
alter PROCEDURE [dbo].[GET_F_PP_AD_AGREE_EMAIL_RECEIVE_MISSING_LIST_PROC]              
AS               
              
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
 SET NOCOUNT ON              
            
 SELECT A.CUID        
   , AGREE_DT        
   ,B.USER_NM             
   ,B.EMAIL        
 FROM CST_MARKETING_AGREEF_TB A               
   INNER JOIN CST_MASTER B              
   ON A.CUID = B.CUID              
 WHERE A.AGREEF = '1'              
 AND B.REST_YN = 'N'              
 AND B.OUT_YN = 'N'            
 AND B.BAD_YN = 'N'    
 AND (B.EMAIL IS NOT NULL AND B.EMAIL <> '')         
 AND MAILSEND_DT IS NULL        
 AND A.AGREE_DT < DATEADD(D,-730,GETDATE())              
