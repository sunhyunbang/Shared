/*************************************************************************************  
 *  ���� ���� �� : ���ΰ����� > ��ϴ��� > �ٱ��� �⺻���� ���  
 *  ��   ��   �� : �� �� �� (virtualman@mediawill.com)  
 *  ��   ��   �� : 2013/07/24  
 *  ��   ��   �� : �� �� �� (stari@mediawill.com)  
 *  ��   ��   �� : 2013/11/21  
 *  �� ��  �� �� : �ɼ��ڵ� ���濡 ���� ����  
 *  ��   ��   �� : �� �� ��        
 *  ��   ��   �� : 2021/10/12 
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����
 *  ��        �� :  
 *  �� ��  �� �� :  
 *  �� ��  �� �� : ���ΰ�����/onlinemanage/Agency_Regist_Proc.asp  
 *  �� ��  �� �� : EXEC DBO.PUT_M_JOB_ONLINE_LINEAD_PROC  
  
declare @p28 int  
set @p28=111529111  
exec PUT_M_JOB_ONLINE_LINEAD_PROC 111529111,80,80,'cowto7602','0000000000',0,4020101,1400001,14,'14','1401','14010001','213','ä������','02-1111-1111,02-3333-3333','','','������ ����','www.findall.co.kr','2019-01-07','2019-02-06','stari','������ ����׽�Ʈ 1/7','0','star
i@mediawill.com','','Modify',@p28 output,0,'N','','',10504172,0,1,''  
select @p28  

@LINEADID : 0
@INPUT_BRANCH: 80
@LAYOUT_BRANCH: 80
@USER_ID:
@LAYOUTCODE: 0000000000
@CLASSCODE: 0
@FINDCODE: 4050101
@DETAILADCODE: 1400001
@GROUP_CD: 14
@AREA_A: 11
@AREA_B: 1119
@AREA_C: 11190000
@AREA_DETAIL:
@ORDER_NAME: ä������
@PHONE: 010-6231-8117,02-2061-0031
@CONTENTS:
@FIELD_3: 00
@FIELD_6: â������
@FIELD_11:
@START_DT: 2020-07-21
@END_DT: 2020-08-20
@MAG_ID: kafka84
@TITLE: Ȧ��������.���Ժ� ����.�ϸ���.���� �ֹ溸��,����,���絵���,û��
@MWPLUS: 0
@ORDER_EMAIL:
@HPHONE: 010-6231-8117
@PRC_TYPE: Regist
@PARTNERF: 1
@RESERVE_YN : N
@RESERVE_START_DT:
@RESERVE_END_DT:
@CUID:
@FEDERATIONF: 0
@KINFAF: 1
@TEMPACPTID:

exec PUT_M_JOB_ONLINE_LINEAD_PROC 
0,80,80,'','0000000000',0,4050101,1400001,14,'11','1119','11190000','','ä������',
'010-6231-8117,02-2061-0031',
'',
'00',
'â������',
'',
'2020-07-21',
'2020-08-20',
'kafka84',
'Ȧ��������.���Ժ� ����.�ϸ���.���� �ֹ溸��,����,���絵���,û��',
'0',
'',
'010-6231-8117',
'Regist',
0,
1,
'N',
'',
'',
'',
0,
1,
''   
 *************************************************************************************/  
  
  
ALTER PROC [dbo].[PUT_M_JOB_ONLINE_LINEAD_PROC]  
  
  @LINEADID                 INT = 0  
, @INPUT_BRANCH             TINYINT  
, @LAYOUT_BRANCH            TINYINT  
, @USER_ID                  VARCHAR(50)  
, @LAYOUTCODE               VARCHAR(10)  
, @CLASSCODE                INT  
, @FINDCODE                 INT  
, @DETAILADCODE             INT  
, @GROUP_CD                 TINYINT  
, @AREA_A                   VARCHAR(30) = NULL
, @AREA_B                   VARCHAR(30) = NULL
, @AREA_C                   VARCHAR(30) = NULL
, @AREA_DETAIL              VARCHAR(60) = NULL
, @ORDER_NAME               VARCHAR(20)  
, @PHONE                    VARCHAR(127)  
, @CONTENTS                 VARCHAR(1000)  
, @FIELD_3                  VARCHAR(100)  
, @FIELD_6                  VARCHAR(100)  
, @FIELD_11                 VARCHAR(100)  
, @START_DT                 VARCHAR(10)  
, @END_DT                   VARCHAR(10)  
, @MAG_ID                   VARCHAR(30)  
, @TITLE                    VARCHAR(500)  
, @MWPLUS                   CHAR(1)       = '0'  
, @ORDER_EMAIL              VARCHAR(50)   = NULL  
, @HPHONE                   VARCHAR(127)  = NULL  
, @PRC_TYPE                 VARCHAR(6)    = ''      -- ó������ (Regist: ���, Modify: ����)   
, @OUTPUT_LINEADID          INT OUTPUT  
, @PARTNERF                 TINYINT       = 0  
, @RESERVE_YN               VARCHAR(1)    = 'N'  
, @RESERVE_START_DT         VARCHAR(20)   = NULL  
, @RESERVE_END_DT           VARCHAR(20)   = NULL  
, @CUID                     INT           = NULL  
, @FEDERATIONF              TINYINT       = 0  
, @KINFAF                   TINYINT       = 0 
, @TEMPACPTID               VARCHAR(25)   = NULL  
, @SENIORTVF                TINYINT       = 0 

AS  
  
BEGIN  
  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SET NOCOUNT ON  
  
  -- ������ó���� ���� ISSTORAGE = 2 �� ����  
  DECLARE @ISSTORAGE INT = 0        
  IF @TEMPACPTID IS NOT NULL AND @TEMPACPTID <> '' BEGIN  
    SET @ISSTORAGE = 2  
  END  
  
  IF @PRC_TYPE = '' BEGIN   -- ó�����°��� �ԷµǾ����� ������ ó�� ����  
    SET @OUTPUT_LINEADID = 0  
    RETURN  
  END  
  ELSE BEGIN  
    -- LINEADID�� 0�̰� MWPLUS�� ���� ��ϴ����� �ƴ� ��� LINEADID �� �ű� ����  
    IF @LINEADID = 0 BEGIN
      -- �����ȣ ä�� ��� ����  
      SET @LINEADID = dbo.FN_GETLINEADID('M')  
      --EXEC @LINEADID = PUT_CM_PP_AD_LINEADID_PROC
    END  
  
    -- UNIQUEKEY(LINEADNO) ����  
    DECLARE @LINEADNO CHAR(16)  
    SET @LINEADNO = dbo.FN_LINEADNO(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH)  
  
    -- �������� ������ �Ϲݰ��� ����/������ ���� (2018.09.13)  
    IF EXISTS(SELECT * FROM PP_AD_HOLDOFF_TB WHERE STAT = 0 AND LINEADNO = @LINEADNO)  
      BEGIN  
        SELECT @START_DT = START_DT  
              ,@END_DT = END_DT  
          FROM PP_AD_TB  
         WHERE LINEADNO = @LINEADNO  
      END  
  
    -- ����  
    --IF EXISTS(SELECT LINEADID FROM PP_AD_TB WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUT_BRANCH AND LAYOUT_BRANCH = @LAYOUT_BRANCH)  
    IF @PRC_TYPE = 'Modify' BEGIN  
   
      UPDATE PP_AD_TB  
         SET USER_ID        = @USER_ID  
            ,LAYOUTCODE     = @LAYOUTCODE  
            ,CLASSCODE      = @CLASSCODE  
            ,FINDCODE       = @FINDCODE  
            ,DETAILADCODE   = @DETAILADCODE  
            ,GROUP_CD       = @GROUP_CD  
            ,AREA_A         = DBO.FN_AREA_CODE_NAME(1, @AREA_A)  
            ,AREA_B         = DBO.FN_AREA_CODE_NAME(2, @AREA_B)  
            ,AREA_C         = DBO.FN_AREA_CODE_NAME(3, @AREA_C)  
            ,AREA_DETAIL    = @AREA_DETAIL  
            ,ORDER_NAME     = @ORDER_NAME  
            ,PHONE          = dbo.fn_MakeNomalPhone(@PHONE, @INPUT_BRANCH, @LAYOUT_BRANCH)  
            ,CONTENTS       = @CONTENTS  
            ,FIELD_3        = @FIELD_3  
            --,FIELD_6        = dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
            ,FIELD_11       = @FIELD_11  
            ,START_DT       = CASE WHEN @START_DT = '' OR @START_DT IS NULL THEN START_DT ELSE @START_DT END  
            ,END_DT         = CASE WHEN @END_DT = '' OR @END_DT IS NULL THEN END_DT ELSE @END_DT END  
            --,MAG_ID         = @MAG_ID            -- �����ÿ��� �����ھ��̵� ���� ����.  
            --,TITLE          = dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
            ,ORDER_EMAIL    = @ORDER_EMAIL  
            ,PARTNERF       = @PARTNERF  
            ,MOD_DT         = GETDATE()  
            ,CUID            = @CUID  
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
  
      IF @RESERVE_YN = 'Y' BEGIN  
        IF EXISTS (SELECT * FROM PP_AD_RESERVE_TB WITH(NOLOCK) WHERE LINEADNO = @LINEADNO) BEGIN  
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
        ELSE BEGIN  
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
    END  
    ELSE IF @PRC_TYPE = 'Regist' BEGIN  
  
      INSERT INTO PP_AD_TB  
        (LINEADID  
        ,INPUT_BRANCH  
        ,LAYOUT_BRANCH  
        ,USER_ID  
        ,LAYOUTCODE  
        ,CLASSCODE  
        ,FINDCODE  
        ,DETAILADCODE  
        ,GROUP_CD  
        ,AREA_A  
        ,AREA_B  
        ,AREA_C  
        ,AREA_DETAIL  
        ,ORDER_NAME  
        ,PHONE  
        ,CONTENTS  
        ,FIELD_3  
        ,FIELD_6  
        ,FIELD_11  
        ,START_DT  
        ,END_DT  
        ,MAG_ID  
        ,TITLE  
        ,ORDER_EMAIL  
        ,[VERSION]  
        ,LINEADNO  
        ,PAY_FREE  
        ,PREFCLOSE  
        ,PARTNERF  
        ,CUID  
        ,ISSTORAGE  
        )  
      VALUES  
        (@LINEADID  
        ,@INPUT_BRANCH  
        ,@LAYOUT_BRANCH  
        ,@USER_ID  
        ,@LAYOUTCODE  
        ,@CLASSCODE  
        ,@FINDCODE  
        ,@DETAILADCODE  
        ,@GROUP_CD  
        ,DBO.FN_AREA_CODE_NAME(1, @AREA_A)  
        ,DBO.FN_AREA_CODE_NAME(2, @AREA_B)  
        ,DBO.FN_AREA_CODE_NAME(3, @AREA_C)  
        ,@AREA_DETAIL  
        ,@ORDER_NAME  
        ,dbo.fn_MakeNomalPhone(@PHONE, @INPUT_BRANCH, @LAYOUT_BRANCH)  
        ,''
        ,@FIELD_3  
        ,dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
        ,@FIELD_11  
        ,@START_DT  
        ,@END_DT  
        ,@MAG_ID  
        ,dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
        ,@ORDER_EMAIL  
        ,'M'  
        ,@LINEADNO  
        ,0      -- PAY_FREE  
        ,0   -- PREFCLOSE  
        ,@PARTNERF  
        ,@CUID  
        ,@ISSTORAGE  
        )  
  
      /*�� 3�� �������� ��*/
      DELETE FROM PP_AD_PARTNER_TB WHERE LINEADNO = @LINEADNO

      INSERT PP_AD_PARTNER_TB (LINEADNO, PARTNERF, FEDERATIONF, KINFAF, SENIORTVF)  
      VALUES(@LINEADNO, @PARTNERF, @FEDERATIONF, @KINFAF, @SENIORTVF)      
  
      IF @RESERVE_YN ='Y' BEGIN  
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
  
      -- �űԵ���̸鼭 Wills �ӽ�Ű���� �ִ� ���  (2017.03.13 �ֺ���)  
      IF @TEMPACPTID IS NOT NULL AND @TEMPACPTID <> '' BEGIN  
        -- Ű�� ���� ������ ���  
        INSERT INTO PP_AD_WILLS_RELATION_TB  
          (temp_key, adid_ppad, inputbranch, adid_wills, adType, lineadno)  
        VALUES  
          (@TEMPACPTID, @LINEADID, @INPUT_BRANCH, 0, 1, @LINEADNO)  
      END  
    END  
  
    -- ��ȭ��ȣ ��ȸ TABLE�� ���  
    EXECUTE EDIT_PP_AD_PHONE_PROC @LINEADNO, @PHONE  
  
    SET @OUTPUT_LINEADID = @LINEADID  
  
  END  
  
END





