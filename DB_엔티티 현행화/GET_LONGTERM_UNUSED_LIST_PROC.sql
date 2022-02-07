--USE COMMON  
/*************************************************************************************    
 *  ���� ���� �� : �����̿�ȸ�� ���� ����Ʈ ��������  [2��01��]  
 *  ��   ��   �� :    
 *  ��   ��   �� : 2021/12/10    
 *  ��        �� :    
 *  �� ��  �� �� :    
 *  �� ��  �� �� : EXEC DBO.GET_LONGTERM_UNUSED_LIST_PROC  
 *************************************************************************************/    
CREATE PROCEDURE [dbo].[GET_LONGTERM_UNUSED_LIST_PROC]  
  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
 SET NOCOUNT ON;  
  
-- �����̿�ȸ�� ���� 2��01��
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
  