--USE COMMON
/*************************************************************************************  
 *  ���� ���� �� : �޸� ����ȸ�� ���� ����Ʈ ��������  
 *  ��   ��   �� :  
 *  ��   ��   �� : 2021/12/3  
 *  ��        �� :  
 *  �� ��  �� �� :  
 *  �� ��  �� �� : EXEC DBO.GET_DORMANT_EXPECTED_LIST_PROC
 *************************************************************************************/  
CREATE PROCEDURE [dbo].[GET_DORMANT_EXPECTED_LIST_PROC]

AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 SET NOCOUNT ON;

SELECT 
EMAIL , USERID , MEMBER_CD , USERNAME , SECTION_CD , JOIN_DT , LOGIN_DT , INSERT_DT , RESTPREDATE	
FROM [COMMON].[DBO].[GET_MM_SENDMAIL_REST_VI]
WHERE SECTION_CD = 'S101' --�������

END

