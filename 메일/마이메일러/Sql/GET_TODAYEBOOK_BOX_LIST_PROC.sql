--USE PAPERCOMMON
/*************************************************************************************  
 *  ���� ���� �� : �ڽ������� ���̽Ź����ⱸ������ ����Ʈ ��������  
 *  ��   ��   �� :  
 *  ��   ��   �� : 2021/12/3  
 *  ��        �� :  
 *  �� ��  �� �� :  
 *  �� ��  �� �� : EXEC DBO.GET_TODAYEBOOK_BOX_LIST_PROC  
 *************************************************************************************/  
CREATE PROCEDURE [dbo].[GET_TODAYEBOOK_BOX_LIST_PROC]

AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 SET NOCOUNT ON;

    SELECT 
       USERNAME
     , USEREMAIL
     , BRANCHNAME
     , BOXTEL
     , SENDYEAR
     , SENDMONTH
     , SENDDAY
     , INPUTBRANCH
     , EMAILRECVF
     , USERFLAG 
  FROM CM_TODAYEBOOK_BOX_TB



END
