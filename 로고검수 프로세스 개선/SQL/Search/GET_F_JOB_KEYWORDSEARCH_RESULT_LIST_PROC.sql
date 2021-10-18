
/*************************************************************************************  
 *  ���� ���� �� : �˻���� Ű���� �˻����� ����Ʈ
 *  ��   ��   �� : online_dev21
 *  ��   ��   �� : 2021/03/19
 *  ��        �� : �˻���� Ű���� �˻����� ����Ʈ
 *  ��   ��   �� : �� �� ��        
 *  ��   ��   �� : 2021/10/12 
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����
 *  �� ��  �� �� :  
 *  ��   ��   �� : 
 *  ��   ��   �� : 
 *  �� ��  �� �� : 
 *  �� ��  �� �� :  /SEARCH_FINDJOB/default.asp
 *  �� ��  �� �� :   
 EXEC GET_F_JOB_KEYWORDSEARCH_RESULT_LIST_PROC '�ù�'
 EXEC GET_F_JOB_KEYWORDSEARCH_RESULT_LIST_PROC '���'
 EXEC GET_F_JOB_KEYWORDSEARCH_RESULT_LIST_PROC '���������'
   
 
 *************************************************************************************/  
ALTER PROC [dbo].[GET_F_JOB_KEYWORDSEARCH_RESULT_LIST_PROC]
  @strKeyword varchar(200) = ''              -- �˻� Ű����
AS  
BEGIN  
  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SET NOCOUNT ON  
  
  SELECT TOP 7 TBL1.LINEADNO                                                  -- �����ȣ
    , CASE WHEN TBL4.PUB_CONFIRM = 1 THEN 
      CASE WHEN ISNULL(TBL4.MAIN_LOGO,'') ='' THEN TBL4.PUB_LOGO ELSE NULL END 
      ELSE NULL END AS WAIT_LOGO  -- ȸ��ΰ�(LOGO_IMAGE)
    , ISNULL(TBL1.AREA_A,'') + ' ' + ISNULL(TBL1.AREA_B,'') AS WORK_AREA      -- �ٹ���
    , ISNULL(TBL4.WAIT_COMPANY , TBL1.FIELD_6)                                -- ȸ���(COMPANY_NAME) 
    , ISNULL(TBL4.WAIT_TITLE , TBL1.TITLE)                                    -- ��������(TITLE)
    , TBL2.WORKTIMEFROM                                                       -- �ð�
    , TBL2.WORKTIMETO                                                         -- �ð�
    , TBL2.WORKTIMEF                                                          -- �ð�
    , TBL2.DAY_WEEK                                                           -- ����
    , TBL2.DAY_WEEK_OPTION                                                    -- ����
    , TBL2.DAY_WEEK_OPTION_ETC                                                -- ����
    , TBL2.SERVICE_PERIOD                                                     -- �Ⱓ
    , TBL2.PAYF                                                               -- �޿�
    , TBL2.PAYFROM                                                            -- �޿�
    , TBL2.PAYTO                                                              -- �޿�
    , TBL2.PAY_COMPANY_RULES                                                  -- ȸ�� ���� ����
  FROM PP_LINE_AD_TB AS TBL1 WITH(NOLOCK)
  INNER JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_TB AS TBL2 WITH(NOLOCK) ON TBL1.LINEADNO=TBL2.LINEADNO
  INNER JOIN (
              SELECT DISTINCT SUB_TBL1.KEYWORD, SUB_TBL2.LINEADNO FROM PP_JOB_KEYWORDSEARCH_TB AS SUB_TBL1 WITH(NOLOCK)
              INNER JOIN PP_JOB_KEYWORDSEARCH_RELATION_TB AS SUB_TBL2 WITH(NOLOCK) ON SUB_TBL1.KEYWORDSEARCHADID=SUB_TBL2.KEYWORDSEARCHADID
              WHERE CONVERT(VARCHAR(10),GETDATE(),121) >= SUB_TBL1.START_DT AND CONVERT(VARCHAR(10),GETDATE(),121) <= SUB_TBL1.END_DT 
                AND SUB_TBL1.END_YN='N' AND SUB_TBL2.END_YN='N'
                AND SUB_TBL2.LINEADNO IS NOT NULL AND SUB_TBL1.KEYWORD=@strKeyword
              ) AS TBL3 ON TBL1.LINEADNO=TBL3.LINEADNO          -- Ű����� 7�� �������̹Ƿ� like�� ������� ����    
  LEFT OUTER JOIN PP_LOGO_OPTION_TB AS TBL4 WITH(NOLOCK) ON TBL1.LINEADNO=TBL4.LINEADNO
  
  ORDER BY NEWID()

END 

