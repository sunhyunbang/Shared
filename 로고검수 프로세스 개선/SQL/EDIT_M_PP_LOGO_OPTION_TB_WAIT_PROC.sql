/*************************************************************************************
 *  ���� ���� �� : ������ - ȸ�� �ΰ� �˼����
 *  ��   ��   �� : �̱ٿ�
 *  ��   ��   �� : 2012/08/27
 *  ��   ��   �� : �� �� ȭ (�ΰ��̿�ȭ �۾�)
 *  ��   ��   �� : 2013/10/21
 *  ��   ��   �� : �����        
 *  ��   ��   �� : 2021/10/12 
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����
 *  �� ��  �� �� :
 *  �� ��  �� �� :
 *  �� ��  �� �� : EXEC DBO.EDIT_M_PP_LOGO_OPTION_TB_WAIT_PROC 28492, 180, 21
 *************************************************************************************/
ALTER PROC [dbo].[EDIT_M_PP_LOGO_OPTION_TB_WAIT_PROC]
(
  @LINEADID         INT       = 0
, @INPUTBRANCH      TINYINT   = 0
, @LAYOUTBRANCH     TINYINT   = 0
, @PAGE_GBN         CHAR(1)   = ''   -- D:���α��� ���� ��/���� ������
)
AS

SET NOCOUNT ON

IF @LINEADID > 0 AND @INPUTBRANCH > 0 AND @LAYOUTBRANCH > 0
BEGIN
 BEGIN TRAN

  IF @PAGE_GBN = 'D'
    BEGIN
      UPDATE PP_LOGO_OPTION_TB
         SET PUB_LOGO = NULL
            ,PUB_CONFIRM_DT = NULL
            ,PUB_CONFIRM = 0
            ,WAIT_LOGO = NULL
            ,WAIT_DT = NULL
            ,REG_DT = GETDATE()
            ,WAIT_NEW = 'Y'
       WHERE LINEADID = @LINEADID
         AND INPUT_BRANCH = @INPUTBRANCH
         AND LAYOUT_BRANCH = @LAYOUTBRANCH
    END
  --������� ���� ������� ���
  ELSE IF @PAGE_GBN = 'R'
    BEGIN
      IF dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUTBRANCH,@LAYOUTBRANCH) ='Y'
        BEGIN
          UPDATE PP_LOGO_OPTION_TB
             SET PUB_CONFIRM_DT = NULL
                ,PUB_CONFIRM = 2
                ,REG_DT = GETDATE()
                ,WAIT_NEW = 'Y'
           WHERE LINEADID = @LINEADID
             AND INPUT_BRANCH = @INPUTBRANCH
             AND LAYOUT_BRANCH = @LAYOUTBRANCH
        END
      ELSE
        BEGIN
          UPDATE PP_LOGO_OPTION_TB
             SET PUB_CONFIRM_DT = GETDATE()
                ,REG_DT = GETDATE()
           WHERE LINEADID = @LINEADID
             AND INPUT_BRANCH = @INPUTBRANCH
             AND LAYOUT_BRANCH = @LAYOUTBRANCH
        END
    END
  ELSE
    BEGIN
      UPDATE PP_LOGO_OPTION_TB
         SET PUB_LOGO = NULL
            ,PUB_CONFIRM_DT = NULL
            ,PUB_CONFIRM = 0
            ,REG_DT = GETDATE()
            ,WAIT_NEW = 'Y'
       WHERE LINEADID = @LINEADID
         AND INPUT_BRANCH = @INPUTBRANCH
         AND LAYOUT_BRANCH = @LAYOUTBRANCH
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




