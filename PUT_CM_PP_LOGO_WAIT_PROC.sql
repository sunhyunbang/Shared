    
/*************************************************************************************    
 *  ���� ���� �� : ����Ʈ/������ > �÷�Ƽ�� �ΰ� ������� ���/���� ó��    
 *  ��   ��   �� : �� �� �� (virtualman@mediawill.com)    
 *  ��   ��   �� : 2012/08/29    
 *  ��   ��   �� : �� �� ��    
 *  ��   ��   �� : 2014.10.14    
 *  �� ��  �� �� : PP_LOGO_OPTION_TB ���̺� INSERT�� LINEADNO �߰�    
 *  ��   ��   �� : �� �� ��            
 *  ��   ��   �� : 2021.10.12     
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����    
 *  ��        �� :    
 *  �� ��  �� �� :    
 *  �� ��  �� �� :    
 *  �� ��  �� �� : EXEC DBO.PUT_CM_PP_LOGO_WAIT_PROC    
    
 exec PUT_CM_PP_LOGO_WAIT_PROC 3164359,181,180,'/UploadFilesJob/Job/Platinum/2019/07/16/0003164359181180_Logo_I5ME5RG804QMDRTD9WAL.jpg','',106103    
    
 exec PUT_CM_PP_LOGO_WAIT_PROC 3164378,181,180,'/UploadFilesJob/Job/Platinum/2019/07/16/0003164378181180_Logo_UYRHIQCAS5NTYLM752CW.jpg','',104163,0,null,null    
 *************************************************************************************/    
ALTER PROC [dbo].[PUT_CM_PP_LOGO_WAIT_PROC]    
    
  @LINEADID               INT    
, @INPUT_BRANCH           TINYINT    
, @LAYOUT_BRANCH          TINYINT    
, @LOGO_IMAGE             VARCHAR(200)    
, @MAIN_LOGO_IMAGE        VARCHAR(200)  = NULL    
, @LOGO_IMAGE_BYTE        INT           = 0    
, @LOGO_MAIN_IMAGE_BYTE   INT           = 0    
, @FAT_ID                 INT           = 0    
, @REGIST_ID              INT           = 0    
AS    
    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  SET NOCOUNT ON    
    
  -- UNIQUEKEY(LINEADNO) ����    
  DECLARE @LINEADNO CHAR(16)    
  SET @LINEADNO = dbo.FN_LINEADNO(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH)    
  
  /* 21.11.09 ����� ��� �߰� */
  DECLARE @MOD_COUNT INT

  SELECT @MOD_COUNT = COUNT(PP_AD.LINEADID) FROM PP_AD_TB AS PP_AD  
  INNER JOIN PP_LOGO_OPTION_TB AS PP_LOGO  
  ON PP_AD.LINEADID = PP_LOGO.LINEADID  
  WHERE PP_AD.LINEADID = @LINEADID  AND PP_AD.INPUT_BRANCH = @INPUT_BRANCH AND PP_AD.LAYOUT_BRANCH = @LAYOUT_BRANCH
  AND (PP_AD.TITLE <> PP_LOGO.WAIT_TITLE  
  OR PP_AD.FIELD_6 <> PP_LOGO.WAIT_COMPANY  
  OR DBO.FN_ISNULL(PP_LOGO.PUB_LOGO,'') <> @LOGO_IMAGE  ) 
  /* 21.11.09 END */
    
  IF (SELECT COUNT(*) FROM PP_LOGO_OPTION_TB WHERE LINEADNO = @LINEADNO ) > 0    
    BEGIN -- ����    
    
      IF @MOD_COUNT > 0 -- 21.11.09 ����� ��� �߰�
        BEGIN
      
          /* 21.10.12 �ΰ�˼� ���μ��� ���� */    
          IF dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y'     
            BEGIN    
              UPDATE PP_LOGO_OPTION_TB    
                 SET WAIT_LOGO      = @LOGO_IMAGE    
                    ,WAIT_DT        = GETDATE()    
                    ,PUB_CONFIRM    = 2    
                    ,WAIT_NEW       = 'Y'    
                    ,WAIT_LOGO_BYTE = @LOGO_IMAGE_BYTE    
               WHERE LINEADNO = @LINEADNO    
            END    
          ELSE    
            BEGIN    
              UPDATE PP_LOGO_OPTION_TB    
                 SET PUB_LOGO       = @LOGO_IMAGE    
                    ,WAIT_LOGO      = @LOGO_IMAGE    
                    ,WAIT_DT        = GETDATE()    
                    ,PUB_CONFIRM    = 1    -- 21.11.09 �˼����� �� �߰�
                    ,WAIT_LOGO_BYTE = @LOGO_IMAGE_BYTE    
               WHERE LINEADNO = @LINEADNO    
            END    
        END
        /* END 21.10.12 */    
    END    
  ELSE    
    BEGIN -- ���    
      IF @INPUT_BRANCH = 181 AND @FAT_ID > 0 AND @REGIST_ID > 0 BEGIN --2019.07.17, ���� ��ǰ ���ױ� �� ��� ���ηΰ� ���� ó��    
        IF EXISTS (SELECT * FROM CY_FAT_MASTER_TB A WITH(NOLOCK)    
                            JOIN CY_FAT_REGIST_TB B WITH(NOLOCK) ON B.FAT_ID = A.FAT_ID WHERE B.FAT_ID = @FAT_ID AND B.REGIST_ID = @REGIST_ID AND A.FAT_TYPE = 3) BEGIN    
          SET @MAIN_LOGO_IMAGE = @LOGO_IMAGE    
        END    
      END             
      /* 21.10.12 �ΰ�˼� ���μ��� ���� */    
      IF dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y'     
        BEGIN     
          INSERT INTO PP_LOGO_OPTION_TB    
          (LINEADID, INPUT_BRANCH, LAYOUT_BRANCH, MAIN_LOGO, WAIT_LOGO, WAIT_DT, WAIT_NEW, LINEADNO, WAIT_LOGO_BYTE, MAIN_LOGO_BYTE)    
          VALUES    
          (@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH, @MAIN_LOGO_IMAGE, @LOGO_IMAGE, GETDATE(), 'Y', @LINEADNO, @LOGO_IMAGE_BYTE, @LOGO_MAIN_IMAGE_BYTE)    
        END    
      ELSE    
        BEGIN    
          INSERT INTO PP_LOGO_OPTION_TB    
          (LINEADID, INPUT_BRANCH, LAYOUT_BRANCH, MAIN_LOGO, WAIT_LOGO, PUB_LOGO, PUB_CONFIRM , WAIT_DT, WAIT_NEW, LINEADNO, WAIT_LOGO_BYTE, MAIN_LOGO_BYTE)    
          VALUES    
          (@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH, @MAIN_LOGO_IMAGE, @LOGO_IMAGE, @LOGO_IMAGE, '1', GETDATE(), 'Y', @LINEADNO, @LOGO_IMAGE_BYTE, @LOGO_MAIN_IMAGE_BYTE)    
        END    
        /*END 21.10.12 */    
    
    END 