--USE COMMON
/*************************************************************************************  
 *  ���� ���� �� : �޸�ȸ��_�������_��� ���� ����Ʈ ��������  [3��]
 *  ��   ��   �� :  
 *  ��   ��   �� : 2021/12/3  
 *  ��        �� :  
 *  �� ��  �� �� :  
 *  �� ��  �� �� : EXEC DBO.GET_DORMANT_TRANS_COM_LIST_PROC
 *************************************************************************************/  
CREATE PROCEDURE [dbo].[GET_DORMANT_TRANS_COM_LIST_PROC]

AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 SET NOCOUNT ON;

-- �޸�ȸ��_�������_��� 3��
SELECT
EMAIL , USERID , MEMBER_CD , USERNAME , SECTION_CD , JOIN_DT , LOGIN_DT , INSERT_DT
FROM  [COMMON].[DBO].[GET_MM_CONFIRM_SENDMAIL_REST_VI]
WHERE MEMBER_CD = '2' --���
AND SECTION_CD = 'S101' --�������

END

