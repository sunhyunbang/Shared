--USE PAPER_NEW  
/*************************************************************************************  
 *  ���� ���� �� : ������ - ȸ�� �ΰ� �˼��Ϸ�  
 *  ��   ��   �� : �̱ٿ�  
 *  ��   ��   �� : 2012/08/27  
 *  ��   ��   �� : �蹮ȭ  
 *  ��   ��   �� : 2013/10/28  
 *  �� ��  �� �� : �ΰ��̿�ȭ �۾� �ݿ�  
 *  ��   ��   �� : �����  
 *  ��   ��   �� : 2014/06/09  
 *  ��        �� : WAIT_NEW = 'N' �߰� (����� ���� �߼� ���� �ű԰˼���� FLAG�� ����) 
 *  ��   ��   �� : �����        
 *  ��   ��   �� : 2021/10/12 
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����
 *  �� ��  �� �� :  
 *  �� ��  �� �� : EXEC DBO.EDIT_M_PP_LOGO_OPTION_TB_COMFIRM_PROC 41853, 80, 17  
 *************************************************************************************/  
ALTER PROC [dbo].[EDIT_M_PP_LOGO_OPTION_TB_COMFIRM_PROC]  
(  
  @LINEADID         INT           = 0  
, @INPUTBRANCH      TINYINT       = 0  
, @LAYOUTBRANCH     TINYINT       = 0  
, @WAIT_LOGO        VARCHAR(200)  = ''  
, @MAIN_LOGO        VARCHAR(200)  = ''  
, @WAIT_LOGO_BYTE   INT           = 0  
, @MAIN_LOGO_BYTE   INT           = 0  
)  
AS  
  
SET NOCOUNT ON  
DECLARE @COMFIRM_DT DATETIME  
  
DECLARE @TITLE VARCHAR(500)  
DECLARE @FIELD_6 VARCHAR(100)  
  
SET @COMFIRM_DT = GETDATE()  
  
IF @LINEADID > 0 AND @INPUTBRANCH > 0 AND @LAYOUTBRANCH > 0  
  BEGIN  

    BEGIN /** �˼��Ϸ� ó���� ����,ȸ����� PP_AD_TB �������� ������Ʈ�Ѵ� **/
      SELECT @TITLE =  TITLE 
            ,@FIELD_6 = FIELD_6 
      FROM  PP_AD_TB 
      WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUTBRANCH AND LAYOUT_BRANCH = @LAYOUTBRANCH
    END /** �˼� **/

    BEGIN TRAN  
  
    IF (SELECT COUNT(*) FROM PP_LOGO_OPTION_TB WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUTBRANCH AND LAYOUT_BRANCH = @LAYOUTBRANCH) > 0  
      BEGIN  
        IF @WAIT_LOGO = NULL OR @WAIT_LOGO = ''  
          BEGIN  
            UPDATE PP_LOGO_OPTION_TB  
                SET PUB_LOGO = WAIT_LOGO  
                , PUB_CONFIRM_DT = @COMFIRM_DT  
                , PUB_CONFIRM = 1  
                , WAIT_NEW = 'N'  
                , MOD_DT = GETDATE()          -- �˻����� ����ó���� ���ؼ� �ʿ���  
                , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
                , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
            WHERE LINEADID = @LINEADID  
            AND INPUT_BRANCH = @INPUTBRANCH  
            AND LAYOUT_BRANCH = @LAYOUTBRANCH  
          END  
        ELSE  
          BEGIN  
            --E-Comm �� ��� ������� �˼��Ϸ� �� ���ηΰ� �󼼷ΰ��  
            IF @INPUTBRANCH = 180 AND (SELECT PUB_CONFIRM FROM PP_LOGO_OPTION_TB WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUTBRANCH AND LAYOUT_BRANCH = @LAYOUTBRANCH) = 2  
              BEGIN  
                IF @MAIN_LOGO = NULL OR @MAIN_LOGO = ''  
                  BEGIN  
                    UPDATE PP_LOGO_OPTION_TB  
                        SET MAIN_LOGO = CASE WHEN ISNULL(MAIN_LOGO , '') = '' THEN MAIN_LOGO ELSE WAIT_LOGO END
                          , MAIN_LOGO_BYTE = CASE WHEN ISNULL(MAIN_LOGO_BYTE , '') ='' THEN MAIN_LOGO_BYTE ELSE WAIT_LOGO END
                          , PUB_CONFIRM_DT = @COMFIRM_DT  
                          , PUB_CONFIRM = 1  
                          , WAIT_NEW = 'N'  
                          , PUB_LOGO_BYTE = WAIT_LOGO_BYTE  
                          , PUB_LOGO = WAIT_LOGO  
                          , MOD_DT = GETDATE()          -- �˻����� ����ó���� ���ؼ� �ʿ���  
                          , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
                          , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
                      WHERE LINEADID = @LINEADID  
                        AND INPUT_BRANCH = @INPUTBRANCH  
                        AND LAYOUT_BRANCH = @LAYOUTBRANCH  
                  END  
                ELSE  
                  BEGIN  
                    UPDATE PP_LOGO_OPTION_TB  
                        SET MAIN_LOGO = CASE WHEN ISNULL(MAIN_LOGO , '') = '' THEN MAIN_LOGO ELSE @MAIN_LOGO END
                          , MAIN_LOGO_BYTE = CASE WHEN ISNULL(MAIN_LOGO_BYTE , '') ='' THEN MAIN_LOGO_BYTE ELSE @MAIN_LOGO END
                          , PUB_CONFIRM_DT = @COMFIRM_DT  
                          , PUB_CONFIRM = 1  
                          , WAIT_NEW = 'N'  
                          , PUB_LOGO_BYTE = WAIT_LOGO_BYTE
                          , PUB_LOGO = WAIT_LOGO  
                          , MOD_DT = GETDATE()          -- �˻����� ����ó���� ���ؼ� �ʿ���  
                          , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
                          , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
                      WHERE LINEADID = @LINEADID  
                        AND INPUT_BRANCH = @INPUTBRANCH  
                        AND LAYOUT_BRANCH = @LAYOUTBRANCH  
                  END  
  
              END  
            ELSE  
              BEGIN  
                UPDATE PP_LOGO_OPTION_TB  
                    SET PUB_LOGO = @WAIT_LOGO  
                      , MAIN_LOGO = CASE WHEN ISNULL(MAIN_LOGO , '') = '' THEN MAIN_LOGO ELSE @MAIN_LOGO END  
                      , MAIN_LOGO_BYTE = CASE WHEN ISNULL(MAIN_LOGO_BYTE , '') ='' THEN MAIN_LOGO_BYTE ELSE @MAIN_LOGO END
                      , PUB_CONFIRM_DT = @COMFIRM_DT  
                      , PUB_CONFIRM = 1  
                      , WAIT_LOGO = @WAIT_LOGO  
                      , WAIT_NEW = 'N'  
                      , WAIT_LOGO_BYTE = @WAIT_LOGO_BYTE  
                      , PUB_LOGO_BYTE = WAIT_LOGO_BYTE 
                      , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
                      , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
                      , MOD_DT = GETDATE()          -- �˻����� ����ó���� ���ؼ� �ʿ���  
                  WHERE LINEADID = @LINEADID  
                    AND INPUT_BRANCH = @INPUTBRANCH  
                    AND LAYOUT_BRANCH = @LAYOUTBRANCH  
              END  
            END  
       END  
     ELSE  
       BEGIN  
          --�Ź� �Ǵ� ��ϴ����� ��� ��� �� �˼��Ϸ�, ���ηΰ� �󼼷ΰ��  
          IF @INPUTBRANCH <> 180 And @WAIT_LOGO <> ''  
            BEGIN  
              EXEC PUT_CM_PP_LOGO_WAIT_PROC @LINEADID, @INPUTBRANCH, @LAYOUTBRANCH, @WAIT_LOGO, @MAIN_LOGO, @WAIT_LOGO_BYTE, @MAIN_LOGO_BYTE  
  
              UPDATE PP_LOGO_OPTION_TB  
                 SET PUB_LOGO = WAIT_LOGO  
                   , MAIN_LOGO = CASE WHEN ISNULL(MAIN_LOGO , '') = '' THEN MAIN_LOGO ELSE WAIT_LOGO END 
                   , MAIN_LOGO_BYTE = CASE WHEN ISNULL(MAIN_LOGO_BYTE , '') ='' THEN MAIN_LOGO_BYTE ELSE @WAIT_LOGO_BYTE END
                   , PUB_CONFIRM_DT = @COMFIRM_DT  
                   , PUB_CONFIRM = 1  
                   , WAIT_NEW = 'N'  
                   , PUB_LOGO_BYTE = WAIT_LOGO_BYTE
                   , MOD_DT = GETDATE()          -- �˻����� ����ó���� ���ؼ� �ʿ���  
                   , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
                   , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
               WHERE LINEADID = @LINEADID  
                 AND INPUT_BRANCH = @INPUTBRANCH  
                 AND LAYOUT_BRANCH = @LAYOUTBRANCH  
            END  
          ELSE  
           BEGIN  
             EXEC PUT_CM_PP_LOGO_WAIT_PROC @LINEADID, @INPUTBRANCH, @LAYOUTBRANCH, @WAIT_LOGO, '', @WAIT_LOGO_BYTE, @MAIN_LOGO_BYTE  
  
              UPDATE PP_LOGO_OPTION_TB  
                 SET PUB_LOGO = WAIT_LOGO  
                   , PUB_CONFIRM_DT = @COMFIRM_DT  
                   , PUB_CONFIRM = 1  
                   , WAIT_NEW = 'N'  
                   , MOD_DT = GETDATE()          -- �˻����� ����ó���� ���ؼ� �ʿ���  
                   , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
                   , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY ���� ������� PP_AD_TB�������� ������Ʈ �Ѵ�
               WHERE LINEADID = @LINEADID  
                 AND INPUT_BRANCH = @INPUTBRANCH  
                 AND LAYOUT_BRANCH = @LAYOUTBRANCH  
            END  
       END  
  
  /* �˼� �Ϸ�� �˼���Ⱚ�� ������Ʈ�Ѵ� 21.09.23*/
  IF (SELECT COUNT(LINEADID) FROM PP_AD_TB WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUTBRANCH AND LAYOUT_BRANCH = @LAYOUTBRANCH) > 0 
    BEGIN
      UPDATE PP_AD_TB 
         SET TITLE = ISNULL(PP_LOGO.WAIT_TITLE , AD.TITLE)
            ,FIELD_6 = ISNULL(PP_LOGO.WAIT_COMPANY , FIELD_6) 
        FROM PP_AD_TB AS AD 
        JOIN PP_LOGO_OPTION_TB AS PP_LOGO
          ON AD.LINEADID = PP_LOGO.LINEADID
       WHERE AD.LINEADID = @LINEADID  
         AND AD.INPUT_BRANCH = @INPUTBRANCH  
         AND AD.LAYOUT_BRANCH = @LAYOUTBRANCH

      --�˼���� ���� ����    
      
      EXEC [DBO].[p_SyncIssueData] @LINEADID, @INPUTBRANCH, @LAYOUTBRANCH, 'L','E'   
    END
  
   -- ������ �߻����� ���� ������ȣ�� �������ְ�  
   IF ( @@ERROR <> 0 )  
     BEGIN  
      SET NOCOUNT OFF  
      ROLLBACK TRAN  
      RETURN (2)  
     END  
   -- ������ ���� 1�� ����  
   ELSE  
     BEGIN  
      COMMIT TRAN  
      RETURN (1)  
     END  
  END  
  
  
  
  
  