


/*************************************************************************************
 *  ���� ���� �� : ������� ������ > E-Comm ���/����
 *  ��   ��   �� : �� �� �� (virtualman@mediawill.com)
 *  ��   ��   �� : 2016/03/10
 *  ��   ��   �� : �� �� ��        
 *  ��   ��   �� : 2021/10/12 
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����
 *  ��        �� :
 *  �� ��  �� �� :
 *  �� ��  �� �� : ���ΰ�����/emanage/Ecomm_Regist_Proc.asp
 *  �� ��  �� �� : EXEC DBO.PUT_M_JOB_CY_LINEAD_PROC
 *************************************************************************************/

ALTER PROC [dbo].[PUT_M_JOB_CY_LINEAD_PROC]

  @LINEADID             INT            = 0
  ,@INPUT_BRANCH        TINYINT
  ,@LAYOUT_BRANCH       TINYINT
  ,@FINDCODE            INT
  ,@DETAILADCODE        INT
  ,@GROUP_CD            TINYINT
  ,@AREA_A              VARCHAR(30)
  ,@AREA_B              VARCHAR(30)
  ,@AREA_C              VARCHAR(30)
  ,@AREA_DETAIL         VARCHAR(60)
  ,@ORDER_NAME          VARCHAR(30)
  ,@PHONE               VARCHAR(127)
  ,@FIELD_3             VARCHAR(100)
  ,@FIELD_6             VARCHAR(100)
  ,@FIELD_11            VARCHAR(100)
  ,@START_DT            VARCHAR(10)   = ''
  ,@END_DT              VARCHAR(10)   = ''
  ,@USER_ID             VARCHAR(50)
  ,@MAG_ID              VARCHAR(30)
  ,@TITLE               VARCHAR(500)
  ,@LAYOUTCODE          VARCHAR(10)
  ,@ORDER_EMAIL         VARCHAR(50)   = NULL
  ,@HPHONE              VARCHAR(127)  = NULL
  ,@OUTPUT_LINEADID     INT OUTPUT
  ,@REG_SUB_BRANCH      INT           = 0       -- ��������ڵ� (SUB_BRANCH)
  ,@PARTNERF            TINYINT       = 0  
  ,@RESERVE_YN          VARCHAR(1)    = 'N'
  ,@RESERVE_START_DT    VARCHAR(20)   = NULL
  ,@RESERVE_END_DT      VARCHAR(20)   = NULL
  ,@CUID                INT           = NULL
  ,@FEDERATIONF         TINYINT       = 0
  ,@KINFAF              TINYINT       = 0
  ,@SENIORTVF              TINYINT       = 0
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @AREA_A_NAME VARCHAR(30)
  DECLARE @AREA_B_NAME VARCHAR(30)
  DECLARE @AREA_C_NAME VARCHAR(30)

  SET @AREA_A_NAME = DBO.FN_AREA_CODE_NAME(1, @AREA_A)
  SET @AREA_B_NAME = DBO.FN_AREA_CODE_NAME(2, @AREA_B)
  SET @AREA_C_NAME = DBO.FN_AREA_CODE_NAME(3, @AREA_C)

  -- ����� ��� @LINEADID ����
  IF @LINEADID = 0
    BEGIN
      -- �����ȣ ä�� ��� ����
      SET @LINEADID = dbo.FN_GETLINEADID('E')
      --EXEC @LINEADID = PUT_CM_PP_AD_LINEADID_PROC
    END

  -- UNIQUEKEY(LINEADNO) ����
  DECLARE @LINEADNO CHAR(16)
  SET @LINEADNO = dbo.FN_LINEADNO(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH)

  -- ����
  IF @LINEADID > 0 AND EXISTS(SELECT LINEADID FROM PP_AD_TB WHERE LINEADNO = @LINEADNO)
  BEGIN
  /* ������ ��� ������ ���� ���� --2016-02-12  ����� */
  IF EXISTS(SELECT * FROM PP_AD_HOLDOFF_TB WHERE LINEADNO = @LINEADNO)
  BEGIN
   SET @END_DT = NULL
  END

    DECLARE @ORG_END_DT DATETIME
    SET @ORG_END_DT = (SELECT END_DT FROM PP_AD_TB WHERE LINEADNO = @LINEADNO)

    -- �����ÿ��� �����ھ��̵� ���� ����.
    UPDATE PP_AD_TB
       SET FINDCODE     = @FINDCODE
          ,DETAILADCODE = @DETAILADCODE
          ,GROUP_CD     = @GROUP_CD
          ,AREA_A       = @AREA_A_NAME
          ,AREA_B       = @AREA_B_NAME
          ,AREA_C       = @AREA_C_NAME
          ,AREA_DETAIL  = @AREA_DETAIL
          ,ORDER_NAME   = @ORDER_NAME
          ,PHONE        = dbo.fn_MakeNomalPhone(@PHONE, @INPUT_BRANCH, @LAYOUT_BRANCH)
          ,FIELD_3      = @FIELD_3
          --,FIELD_6      = dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')
          ,FIELD_11     = @FIELD_11
          ,START_DT     = CASE WHEN @START_DT = '' OR @START_DT IS NULL THEN START_DT ELSE @START_DT END
          ,END_DT       = CASE WHEN @END_DT = '' OR @END_DT IS NULL THEN END_DT ELSE @END_DT END
          ,[USER_ID]    = @USER_ID
          --,TITLE        = dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')
          ,LAYOUTCODE   = @LAYOUTCODE
          ,ORDER_EMAIL  = @ORDER_EMAIL
          ,PARTNERF     = @PARTNERF
          ,MOD_DT       = GETDATE()
          ,CUID          = @CUID
          ,TITLE = CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN TITLE ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T') END
          ,FIELD_6 = CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN FIELD_6 ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C') END
     WHERE LINEADNO = @LINEADNO

  /* ��������(����,ȸ���) �׸� ������Ʈ 21.09.23*/
  IF EXISTS(SELECT LINEADID FROM PP_LOGO_OPTION_TB WHERE LINEADNO = @LINEADNO)    
  BEGIN
    UPDATE PP_LOGO_OPTION_TB
      SET WAIT_TITLE = CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T') ELSE NULL END     
          ,WAIT_COMPANY = CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C') ELSE NULL END  
          ,PUB_LOGO = CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN PUB_LOGO ELSE WAIT_LOGO END
    WHERE LINEADNO = @LINEADNO
  END
  
  /*�� 3�� �������� ��*/
  UPDATE PP_AD_PARTNER_TB 
     SET PARTNERF = @PARTNERF,
         FEDERATIONF = @FEDERATIONF,
         KINFAF = @KINFAF,
         SENIORTVF = @SENIORTVF
   WHERE LINEADNO = @LINEADNO    

    -- ��������
    IF @RESERVE_YN = 'Y'
    BEGIN
      IF EXISTS (SELECT * FROM PP_AD_RESERVE_TB WHERE LINEADNO = @LINEADNO)
      BEGIN
        -- LOG ����
        INSERT INTO PP_AD_RESERVE_LOG_TB (LINEADNO, RESERVE_START_DT, RESERVE_END_DT, REG_DT, RESERVE_STAT, MODIFY_DT)
        SELECT LINEADNO, RESERVE_START_DT, RESERVE_END_DT, REG_DT, RESERVE_STAT, MODIFY_DT
          FROM PP_AD_RESERVE_TB
         WHERE LINEADNO = @LINEADNO
           AND RESERVE_STAT IN ('���', '����')

       UPDATE A
          SET A.RESERVE_START_DT = @RESERVE_START_DT
            , A.RESERVE_END_DT = @RESERVE_END_DT
         FROM PP_AD_RESERVE_TB AS A
        WHERE A.LINEADNO = @LINEADNO
          AND A.RESERVE_STAT IN ('���', '����')
      END
    END

  END
  ELSE
  BEGIN

    INSERT INTO PP_AD_TB
      (LINEADID
      ,INPUT_BRANCH
      ,LAYOUT_BRANCH
      ,FINDCODE
      ,DETAILADCODE
      ,GROUP_CD
      ,AREA_A
      ,AREA_B
      ,AREA_C
      ,AREA_DETAIL
      ,ORDER_NAME
      ,PHONE
      ,FIELD_3
      ,FIELD_6
      ,FIELD_11
      ,START_DT
      ,END_DT
      ,USER_ID
      ,MAG_ID
      ,TITLE
      ,LAYOUTCODE
      ,ORDER_EMAIL
      ,[VERSION]
      ,REG_SUB_BRANCH
      ,LINEADNO
      ,PAY_FREE
      ,PREFCLOSE
      ,PARTNERF
      ,CUID)
    VALUES
      (@LINEADID
      ,@INPUT_BRANCH
      ,@LAYOUT_BRANCH
      ,@FINDCODE
      ,@DETAILADCODE
      ,@GROUP_CD
      ,@AREA_A_NAME
      ,@AREA_B_NAME
      ,@AREA_C_NAME
      ,@AREA_DETAIL
      ,@ORDER_NAME
      ,dbo.fn_MakeNomalPhone(@PHONE, @INPUT_BRANCH, @LAYOUT_BRANCH)
      ,@FIELD_3
      ,dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')
      ,@FIELD_11
      ,@START_DT
      ,@END_DT
      ,@USER_ID
      ,@MAG_ID
      ,dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')
      ,@LAYOUTCODE
      ,@ORDER_EMAIL
      ,'E'
      ,@REG_SUB_BRANCH
      ,@LINEADNO
      ,0    -- PAY_FREE
      ,0    -- PREFCLOSE
      ,@PARTNERF
      ,@CUID)

    /*�� 3�� �������� ��*/
    INSERT PP_AD_PARTNER_TB (LINEADNO, PARTNERF, FEDERATIONF, KINFAF, SENIORTVF)
    VALUES(@LINEADNO, @PARTNERF, @FEDERATIONF, @KINFAF, @SENIORTVF)


    IF @RESERVE_YN ='Y'
    BEGIN
      INSERT PP_AD_RESERVE_TB (
               LINEADNO
              ,RESERVE_START_DT
              ,RESERVE_END_DT
              ,REG_DT
              ,RESERVE_STAT
              ,MODIFY_DT
            )
      SELECT @LINEADNO
           , @RESERVE_START_DT
           , @RESERVE_END_DT
           , GETDATE()
           , '����'
           , NULL
    END

  END

  IF @@ERROR = 0
  BEGIN
    -- ��ȭ��ȣ TABLE�� ���
    EXECUTE EDIT_PP_AD_PHONE_PROC @LINEADNO, @PHONE

    SET @OUTPUT_LINEADID = @LINEADID
  END
  ELSE
  BEGIN
    SET @OUTPUT_LINEADID = 0
  END
