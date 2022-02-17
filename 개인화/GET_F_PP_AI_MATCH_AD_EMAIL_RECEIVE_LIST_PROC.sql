--USE PAPER_NEW      
/*************************************************************************************      
 *  ���� ���� �� : ������� ���α��� �������� �̸��� ������ ���      
 *  ��   ��   �� : �����      
 *  ��   ��   �� : 2021/12/29                
 *  ��        �� : ���� �߰� - �ֱ�90�� �̳� �α��� �̷��� �ִ� ȸ�� 21.12.29 (����ȭ��õ �ý���)      
 *  �� ��  �� �� :      
 *  �� ��  �� �� :      
 *  �� ��  �� �� : GET_F_PP_AI_MATCH_AD_EMAIL_RECEIVE_LIST_PROC      
 *************************************************************************************/       
CREATE PROCEDURE [dbo].[GET_F_PP_AI_MATCH_AD_EMAIL_RECEIVE_LIST_PROC]      
AS       
      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
 SET NOCOUNT ON      
      
       
 SELECT CM.CUID, CM.USER_NM, CM.EMAIL      
 FROM PP_PERSONALIZATION_FINDJOB_EMAIL_YN_TB AS PMAT       
 INNER JOIN MEMBERDB.MWMEMBER.dbo.CST_MASTER AS CM  ON PMAT.CUID = CM.CUID        
  INNER JOIN MEMBERDB.MWMEMBER.dbo.CST_MARKETING_AGREEF_TB AS M ON M.CUID = CM.CUID      
 WHERE M.AGREEF = 1 -- �����ü��ŵ���       
 AND CM.REST_YN = 'N' -- �޸�ȸ�� ����      
 AND CM.OUT_YN = 'N' -- Ż��ȸ�� ����      
 AND CM.MEMBER_CD = 1 -- ����ȸ����       
 AND PMAT.EMAIL_YN ='Y'      
 AND NOT (CM.EMAIL NOT LIKE '%@%' OR RTRIM(CM.EMAIL) = '') -- �������� ���� ����       
 AND DATEDIFF(DAY , ISNULL(LAST_LOGIN_DT , JOIN_DT) , GETDATE()) <= 90 --�ֱ�90�� �̳� �α��� �̷��� �ִ� ȸ�� 21.12.29 (����ȭ��õ �ý���)      
 --AND CM.cuid in ('14221905') --������ �ּ�ó��      
 ORDER BY PMAT.CUID      
      
