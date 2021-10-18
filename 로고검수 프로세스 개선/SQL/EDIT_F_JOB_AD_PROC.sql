--USE PAPER_NEW      
/*************************************************************************************        
 *  ���� ���� �� : ���α������ > ������� > �⺻���� ����        
 *  ��   ��   �� : �� �� ��(stari@mediawill.com)        
 *  ��   ��   �� : 2014/12/16        
 *  ��   ��   �� : �����        
 *  ��   ��   �� : 2021/10/12 
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����
 *  ��        �� : 
 *  �� ��  �� �� :        
 *  �� ��  �� �� : ����Ʈ/job/advertiser/AdModify_Proc.asp, ����Ʈ/job/brand/advertiser/BrandAdModify_Proc.asp        
 *  �� ��  �� �� : EXEC DBO.EDIT_F_JOB_AD_PROC        
 *************************************************************************************/  
ALTER PROC [dbo].[EDIT_F_JOB_AD_PROC] @LINEADID INT = 0  
 ,@INPUT_BRANCH INT  
 ,@LAYOUT_BRANCH INT  
 ,@FINDCODE INT  
 ,@DETAILADCODE INT  
 ,@GROUP_CD INT  
 ,@AREA_A VARCHAR(30)  
 ,@AREA_B VARCHAR(30)  
 ,@AREA_C VARCHAR(30)  
 ,@AREA_DETAIL VARCHAR(60)  
 ,@ORDER_NAME VARCHAR(30)  
 ,@PHONE VARCHAR(127)  
 ,@FIELD_3 VARCHAR(100)  
 ,@FIELD_6 VARCHAR(100)  
 ,@FIELD_11 VARCHAR(100)  
 ,@START_DT VARCHAR(30)  
 ,@END_DT VARCHAR(10)  
 ,@USER_ID VARCHAR(50)  
 ,@MAG_ID VARCHAR(30)  
 ,@TITLE VARCHAR(500)  
 ,@LAYOUTCODE VARCHAR(10)  
 ,@ORDER_EMAIL VARCHAR(50) = NULL  
 ,@HPHONE VARCHAR(127) = NULL  
 ,@AD_PASSWORD VARCHAR(6) = NULL  
 ,@OUTPUT_LINEADID INT OUTPUT  
 ,@PARTNERF INT = 0  
 ,@CUID INT  
 ,@RESERVE_YN VARCHAR(1) = NULL  
 ,@RESERVE_START_DT VARCHAR(20) = NULL  
 ,@FEDERATIONF TINYINT = 0  
 ,@KINFAF TINYINT = 0  
 ,@SENIORTVF TINYINT = 0  
AS  
BEGIN  
 SET NOCOUNT ON  
  
 DECLARE @LINEADNO CHAR(16)  
 DECLARE @VERSION CHAR(1)  
 DECLARE @ORG_END_DT DATETIME  
  
 SET @LINEADNO = dbo.FN_LINEADNO(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH)  
  
 SELECT @VERSION = [VERSION]  
       ,@ORG_END_DT = END_DT  
 FROM PP_AD_TB  
 WHERE LINEADNO = @LINEADNO  
  
 SET @START_DT = DBO.FN_DATETIME_12_TO_24(@START_DT)  
  
 /* �� 3�� ���� ���� ����*/  
 UPDATE PP_AD_PARTNER_TB  
 SET PARTNERF = @PARTNERF  
    ,FEDERATIONF = @FEDERATIONF  
    ,KINFAF = @KINFAF  
    ,SENIORTVF = @SENIORTVF  
 WHERE LINEADNO = @LINEADNO  
  
 /**************** ���� ****************/  
 -- �������        
 IF @VERSION = 'N'  AND @INPUT_BRANCH = 80 AND EXISTS (SELECT LINEADID  FROM PAPERREG.dbo.LineAd  WHERE LineAdId = @LINEADID  AND InputBranch = @INPUT_BRANCH  AND CloseBranch = @LAYOUT_BRANCH  AND CUID = @CUID )  
 BEGIN  
  UPDATE PP_AD_TB  
     SET LAYOUTCODE = @LAYOUTCODE  
        ,FINDCODE = @FINDCODE  
        ,DETAILADCODE = @DETAILADCODE  
        ,GROUP_CD = @GROUP_CD  
        ,AREA_A = DBO.FN_AREA_CODE_NAME(1, @AREA_A)  
        ,AREA_B = DBO.FN_AREA_CODE_NAME(2, @AREA_B)  
        ,AREA_C = DBO.FN_AREA_CODE_NAME(3, @AREA_C)  
        ,AREA_DETAIL = @AREA_DETAIL  
        ,ORDER_NAME = @ORDER_NAME  
        --,PHONE         = dbo.fn_MakeNomalPhone(@PHONE, @INPUT_BRANCH, @LAYOUT_BRANCH)     -- �ٱ���� ��ȭ��ȣ�� �������� �ʴ´�.        
        ,FIELD_3 = @FIELD_3  
        ,FIELD_11 = @FIELD_11  
        ,ORDER_EMAIL = @ORDER_EMAIL  
        --,PARTNERF       = @PARTNERF       --2017.06.21, ����UI�� �ش��׸��� ���� ������ �������� ����        
        ,MOD_DT = GETDATE()  
        ,TITLE = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN TITLE  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
        END --21.09.28 ��ǰ�� ������� ����    
        ,FIELD_6 = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN FIELD_6  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
        END --21.09.28 ��ǰ�� ������� ����    
  WHERE LINEADNO = @LINEADNO  
  
  /* ��������(����,ȸ���) �׸� ������Ʈ 21.09.23*/  
  IF EXISTS (SELECT LINEADID FROM PP_LOGO_OPTION_TB WHERE LINEADNO = @LINEADNO)  
  BEGIN  
    UPDATE PP_LOGO_OPTION_TB  
       SET WAIT_TITLE = CASE   
           WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
             THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
             ELSE NULL  
           END  
          ,WAIT_COMPANY = CASE   
           WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
             THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
             ELSE NULL  
           END  
          ,PUB_LOGO = CASE   
           WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
             THEN PUB_LOGO  
             ELSE WAIT_LOGO  
           END  
   WHERE LINEADNO = @LINEADNO  
  END  
  
  SET @OUTPUT_LINEADID = @LINEADID  
 END  
   -- ������ ���� �ٱ��� ������ ���        
 ELSE IF @VERSION = 'N' AND EXISTS (SELECT A.LINEADID FROM PP_AD_TB AS A JOIN MWDB.dbo.MW_CUSTOMER_AUTH_TB AS B ON B.INPUTCUST = A.INPUTCUST WHERE A.LINEADNO = @LINEADNO  AND B.CUID = @CUID)  
 BEGIN  
  UPDATE PP_AD_TB  
     SET LAYOUTCODE = @LAYOUTCODE  
        ,FINDCODE = @FINDCODE  
        ,DETAILADCODE = @DETAILADCODE  
        ,GROUP_CD = @GROUP_CD  
        ,AREA_A = DBO.FN_AREA_CODE_NAME(1, @AREA_A)  
        ,AREA_B = DBO.FN_AREA_CODE_NAME(2, @AREA_B)  
        ,AREA_C = DBO.FN_AREA_CODE_NAME(3, @AREA_C)  
        ,AREA_DETAIL = @AREA_DETAIL  
        ,ORDER_NAME = @ORDER_NAME         
        ,FIELD_3 = @FIELD_3  
        ,FIELD_11 = @FIELD_11    
        ,ORDER_EMAIL = @ORDER_EMAIL      
        ,MOD_DT = GETDATE()  
        ,TITLE = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN TITLE  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
        END --21.09.28 ��ǰ�� ������� ����    
        ,FIELD_6 = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN FIELD_6  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
        END --21.09.28 ��ǰ�� ������� ����    
  WHERE LINEADNO = @LINEADNO  
  
  /* ��������(����,ȸ���) �׸� ������Ʈ 21.09.23*/  
  IF EXISTS ( SELECT LINEADID FROM PP_LOGO_OPTION_TB WHERE LINEADNO = @LINEADNO )  
  BEGIN  
   UPDATE PP_LOGO_OPTION_TB  
      SET WAIT_TITLE = CASE   
          WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
            THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
            ELSE NULL  
          END  
         ,WAIT_COMPANY = CASE   
          WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
            THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
            ELSE NULL  
          END  
   WHERE LINEADNO = @LINEADNO  
  END  
  
  SET @OUTPUT_LINEADID = @LINEADID  
 END  
   -- ��ȸ�� ������ ��� ��й�ȣ�� �´� �� Ȯ��        
 ELSE IF ( @VERSION = 'E' AND @USER_ID = 'NoMember'  AND EXISTS (  SELECT LINEADID  FROM PP_JOB_NO_MEMBER_AD_TB  WHERE LINEADNO = @LINEADNO  AND AD_PASSWORD = @AD_PASSWORD  )  )  
 BEGIN  
  UPDATE PP_AD_TB  
     SET LAYOUTCODE = @LAYOUTCODE  
        ,FINDCODE = @FINDCODE  
        ,DETAILADCODE = @DETAILADCODE  
        ,GROUP_CD = @GROUP_CD  
        ,AREA_A = DBO.FN_AREA_CODE_NAME(1, @AREA_A)  
        ,AREA_B = DBO.FN_AREA_CODE_NAME(2, @AREA_B)  
        ,AREA_C = DBO.FN_AREA_CODE_NAME(3, @AREA_C)  
        ,AREA_DETAIL = @AREA_DETAIL  
        ,ORDER_NAME = @ORDER_NAME  
        ,PHONE = dbo.fn_MakeNomalPhone(@PHONE, @INPUT_BRANCH, @LAYOUT_BRANCH)  
        ,FIELD_3 = @FIELD_3  
        ,FIELD_11 = @FIELD_11  
        ,ORDER_EMAIL = @ORDER_EMAIL  
        ,START_DT = CASE   
        WHEN @START_DT = ''  
          OR @START_DT IS NULL  
          THEN START_DT  
          ELSE @START_DT  
        END  
        ,END_DT = CASE   
        WHEN @END_DT = ''  
          OR @END_DT IS NULL  
          THEN END_DT  
          ELSE @END_DT  
        END  
        --,PARTNERF       = @PARTNERF       --2017.06.21, ����UI�� �ش��׸��� ���� ������ �������� ����       
        ,MOD_DT = GETDATE()  
        ,TITLE = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN TITLE  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
        END --21.09.28 ��ǰ�� ������� ����    
        ,FIELD_6 = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN FIELD_6  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
        END --21.09.28 ��ǰ�� ������� ����    
  WHERE LINEADNO = @LINEADNO  
  
 
  /* ��������(����,ȸ���) �׸� ������Ʈ 21.09.23*/  
  IF EXISTS (SELECT LINEADID  FROM PP_LOGO_OPTION_TB  WHERE LINEADNO = @LINEADNO )  
  BEGIN  
   UPDATE PP_LOGO_OPTION_TB  
      SET WAIT_TITLE = CASE   
          WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
            THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
            ELSE NULL  
          END  
       ,  WAIT_COMPANY = CASE   
          WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
            THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
            ELSE NULL  
          END  
   WHERE LINEADNO = @LINEADNO  
  END  
  
  -- ��ȭ��ȣ TABLE�� ���        
  EXECUTE EDIT_PP_AD_PHONE_PROC @LINEADNO  
   ,@PHONE  
  
  --�������ڰ� ����� ���        
  IF CONVERT(VARCHAR(10), @ORG_END_DT, 120) <> CONVERT(VARCHAR(10), @END_DT, 120)  AND EXISTS (SELECT *  FROM PP_AD_RESERVE_TB  WHERE LINEADNO = @LINEADNO )  
  BEGIN  
   -- LOG ����        
   INSERT INTO PP_AD_RESERVE_LOG_TB (  
    LINEADNO  
    ,RESERVE_START_DT  
    ,RESERVE_END_DT  
    ,REG_DT  
    ,RESERVE_STAT  
    ,MODIFY_DT  
    )  
   SELECT LINEADNO  
    ,RESERVE_START_DT  
    ,RESERVE_END_DT  
    ,REG_DT  
    ,RESERVE_STAT  
    ,MODIFY_DT  
   FROM PP_AD_RESERVE_TB  
   WHERE LINEADNO = @LINEADNO  
  
   --����ǿ� ����, �������̺� �������ڵ� ����        
   UPDATE B  
   SET RESERVE_END_DT = @END_DT  
   FROM PP_AD_TB AS A  
   JOIN PP_AD_RESERVE_TB AS B ON A.LINEADNO = B.LINEADNO  
   WHERE A.DELYN = 'N'  
    AND B.RESERVE_START_DT IS NOT NULL  
    AND CONVERT(VARCHAR(10), B.RESERVE_END_DT, 120) = CONVERT(VARCHAR(10), @ORG_END_DT, 120)  
    AND A.LINEADNO = @LINEADNO  
  END  
  
  SET @OUTPUT_LINEADID = @LINEADID  
 END  
   -- ���� (ECOMM, ��ϴ��� ���� ������ ���)        
 ELSE IF (@VERSION = 'E'  OR @VERSION = 'M' ) AND EXISTS (SELECT LINEADID FROM PP_AD_TB WHERE LINEADNO = @LINEADNO AND ISNULL(CUID, '') = CASE WHEN @CUID IS NOT NULL THEN @CUID ELSE '' END )  
 BEGIN  
  UPDATE PP_AD_TB  
     SET LAYOUTCODE = @LAYOUTCODE  
        ,FINDCODE = @FINDCODE  
        ,DETAILADCODE = @DETAILADCODE  
        ,GROUP_CD = @GROUP_CD  
        ,AREA_A = DBO.FN_AREA_CODE_NAME(1, @AREA_A)  
        ,AREA_B = DBO.FN_AREA_CODE_NAME(2, @AREA_B)  
        ,AREA_C = DBO.FN_AREA_CODE_NAME(3, @AREA_C)  
        ,AREA_DETAIL = @AREA_DETAIL  
        ,ORDER_NAME = @ORDER_NAME  
        ,PHONE = dbo.fn_MakeNomalPhone(@PHONE, @INPUT_BRANCH, @LAYOUT_BRANCH)  
        ,FIELD_3 = @FIELD_3  
        ,FIELD_11 = @FIELD_11  
        ,ORDER_EMAIL = @ORDER_EMAIL  
        ,START_DT = CASE   
        WHEN @START_DT = ''  
          OR @START_DT IS NULL  
          THEN START_DT  
          ELSE @START_DT  
        END  
        ,END_DT = CASE   
        WHEN @END_DT = ''  
          OR @END_DT IS NULL  
          THEN END_DT  
          ELSE @END_DT  
        END  
        --,PARTNERF       = @PARTNERF       --2017.06.21, ����UI�� �ش��׸��� ���� ������ �������� ����        
        ,MOD_DT = GETDATE()  
        ,TITLE = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN TITLE  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
        END --21.09.28 ��ǰ�� ������� ����    
        ,FIELD_6 = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN FIELD_6  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
        END --21.09.28 ��ǰ�� ������� ����    
  WHERE LINEADNO = @LINEADNO  
        
  /* ��������(����,ȸ���) �׸� ������Ʈ 21.09.23*/  
  IF EXISTS (SELECT LINEADID FROM PP_LOGO_OPTION_TB WHERE LINEADNO = @LINEADNO )  
  BEGIN  
   UPDATE PP_LOGO_OPTION_TB  
      SET WAIT_TITLE = CASE   
          WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
            THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
            ELSE NULL  
          END  
         ,WAIT_COMPANY = CASE   
          WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
            THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
            ELSE NULL  
          END  
   WHERE LINEADNO = @LINEADNO  
  END  
  
  -- ��ȭ��ȣ TABLE�� ���        
  EXECUTE EDIT_PP_AD_PHONE_PROC @LINEADNO  
   ,@PHONE  
  
  --�������ڰ� ����� ���        
  --�������� ������ ����        
  IF @RESERVE_YN = 'Y'  
   AND EXISTS (  
    SELECT *  
    FROM PP_AD_RESERVE_TB  
    WHERE LINEADNO = @LINEADNO  
    )  
  BEGIN  
   -- LOG ����        
   INSERT INTO PP_AD_RESERVE_LOG_TB (  
    LINEADNO  
    ,RESERVE_START_DT  
    ,RESERVE_END_DT  
    ,REG_DT  
    ,RESERVE_STAT  
    ,MODIFY_DT  
    )  
   SELECT LINEADNO  
    ,RESERVE_START_DT  
    ,RESERVE_END_DT  
    ,REG_DT  
    ,RESERVE_STAT  
    ,MODIFY_DT  
   FROM PP_AD_RESERVE_TB  
   WHERE LINEADNO = @LINEADNO  
  
   --�������̺� �������ڵ� ����        
   UPDATE B  
   SET RESERVE_START_DT = @RESERVE_START_DT  
    ,RESERVE_END_DT = @END_DT  
   FROM PP_AD_TB AS A  
   JOIN PP_AD_RESERVE_TB AS B ON A.LINEADNO = B.LINEADNO  
   WHERE A.DELYN = 'N'  
    AND B.RESERVE_START_DT IS NOT NULL  
    AND A.LINEADNO = @LINEADNO  
  END  
  
  
  -- ������� ���ٰ� ������ ����Ұ�� ���� ���̺��� ����        
  IF @RESERVE_YN = 'N'  
   AND EXISTS (  
    SELECT *  
    FROM PP_AD_RESERVE_TB  
    WHERE LINEADNO = @LINEADNO  
     AND RESERVE_STAT IN (  
      '���'  
      ,'����'  
      )  
    )  
  BEGIN  
   DELETE  
   -- SELECT *        
   FROM PP_AD_RESERVE_TB  
   WHERE LINEADNO = @LINEADNO  
  END  
  
  SET @OUTPUT_LINEADID = @LINEADID  
 END  
 ELSE -- �� �� ���ǿ� ���� ������ @OUTPUT_LINEADID�� 0���� ��ȯ�Ѵ�.        
 BEGIN  
  SET @OUTPUT_LINEADID = 0  
 END  
   --print @OUTPUT_LINEADID        
END  