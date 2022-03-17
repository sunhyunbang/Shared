  
/*************************************************************************************  
 *  ���� ���� �� : ���� > ���α������ > ��ȭ�� > ���� �Ի� ���� �߼�  
 *  ��   ��   �� : �� �� ��  
 *  ��   ��   �� : 2013/11/15  
 *  ��   ��   �� : �� �� ��  
 *  ��   ��   �� : 2018/05/09  
 *  ��        �� : �ٹ� ���� ����  
 *  �� ��  �� �� :  
 *  �� ��  �� �� :  
 *  �� ��  �� �� :   
  
exec PUT_F_APP_MMS_SEND_PROC '010-3393-1420','010-3393-1420','[������� ���α��� ������ : �̱ٿ�] �������� ���� ���� �帳�ϴ�. ��ȭ ������ �ð��븦 �˷��ֽø� ��ȭ �帮�ڽ��ϴ�.','[������� ���α���:���� �Ϸ� �ȳ�] �̱ٿ���� �����Ͻ� ������ ���̿� �Ի������� �Ϸ� �Ǿ����ϴ�. ���� ��� �����ñ� �ٶ��ϴ�.','Y','[������� ���α��� ��ȭ���� �� ����]','tel',10504169,46733,
'������ ����','�߰����뤱����'  
  
exec PUT_F_APP_MMS_SEND_PROC '010-3393-1420','010-3393-1420','[������� ���α��� ������ : �̱ٿ�(��/41��), �ֹ���, ���� ������, �޿� ����50,000,000��, , ���13��]','[������� ���α���:���� �Ϸ� �ȳ�] �̱ٿ���� �����Ͻ� ������ ���̿� �Ի������� �Ϸ� �Ǿ����ϴ�. ���� ��� �����ñ� �ٶ��ϴ�.','Y','[������� ���α��� ��������]','sms',10504169,46733,'������
 ����c','�߰����뤱����ff'  
  
exec PUT_F_APP_MMS_SEND_PROC '010-3393-1420','010-3393-1420','[������� ���α��� ������ : �̱ٿ�(��/41��), �ֹ���, ���� ������, �޿� ����50,000,000��, , ���13��]','[������� ���α���:���� �Ϸ� �ȳ�] �̱ٿ���� �����Ͻ� ������ ���̿� �Ի������� �Ϸ� �Ǿ����ϴ�. ���� ��� �����ñ� �ٶ��ϴ�.','Y','[������� ���α��� ��������]','sms',10504169,46733,'������
 ����',''  
  
exec PUT_F_APP_MMS_SEND_PROC '010-3393-1420','010-3393-1420','[������� ���α��� ������ : �̱ٿ�(��/41��), �ֹ���, ���� ������, �޿� ������ ����, ���п�����, ���13��]','[������� ���α���:���� �Ϸ� �ȳ�] �̱ٿ���� �����Ͻ� ������ ���̿� �Ի������� �Ϸ� �Ǿ����ϴ�. ���� ��� �����ñ� �ٶ��ϴ�.','Y','[������� ���α��� ��������]','sms',10504169,46733,'������ ��
��',''  
 *************************************************************************************/  
  
ALTER PROC [dbo].[PUT_F_APP_MMS_SEND_PROC]  
  @SND_HPHONE               VARCHAR(16)             -- �Ի������� �޴��� ��ȣ  
, @RCV_HPHONE               VARCHAR(16)             -- ������ �޴��� ��ȣ  
, @RCV_APP_SMS_CONTENTS     VARCHAR(4000)           -- ���� ���� ����(�����ֿ�)  
, @SND_APP_SMS_CONTENTS     VARCHAR(4000)           -- ���� ���� ����(�����ڿ�)  
, @RESUME_CHECK             CHAR(1)         = 'Y'   -- ��ȭ�� ��������  
, @SUBJECT                  VARCHAR(160)    = ''    -- MMS����  
, @GBN                      VARCHAR(20)     = ''    -- ����  
, @CUID                     INT  
, @RESUME_ID                INT             = 0  
, @COM_NM                   VARCHAR(50)     = ''    -- ȸ���  
, @CONTENTS                 VARCHAR(500)    = ''    -- �߰�����  
AS  
BEGIN  
  
  SET NOCOUNT ON  
  
  DECLARE @REQTIME VARCHAR(20)  
  SET @REQTIME = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(20), DATEADD(SS, 5, GETDATE()), 120), '-', ''), ' ', ''), ':', '')  
  
  -- ��ȭ�� ���ڹ���(�̷¼� ÷�� ����)  
  IF @GBN = 'tel'  
  BEGIN  
    --set @RCV_APP_SMS_CONTENTS = @RCV_APP_SMS_CONTENTS + 'a1'  
    --set @SND_APP_SMS_CONTENTS = @SND_APP_SMS_CONTENTS + 'a1'  
      
    -- �����ֿ� ��������  
    -- �Ǽ��� ����� �Ʒ� �ּ� ����  
    EXECUTE FINDDB1.COMDB1.dbo.PUT_SENDMMS_PROC @SND_HPHONE,@RCV_HPHONE,@SUBJECT,@RCV_APP_SMS_CONTENTS,@REQTIME  
    
    IF @RESUME_CHECK = 'Y'  
      -- �����ڿ� ��������  
      -- �Ǽ��� ����� �Ʒ� �ּ� ����  
      EXECUTE FINDDB1.COMDB1.dbo.PUT_SENDMMS_PROC '02-2187-7867',@SND_HPHONE,@SUBJECT,@SND_APP_SMS_CONTENTS,@REQTIME        
  END  
  
  ELSE  
  BEGIN  
    
    IF @RESUME_CHECK = 'Y'  
    BEGIN  
  
      DECLARE @KKO_MSG          VARCHAR(4000)  
            , @KKO_URL          VARCHAR(1000)  
            , @KKO_URL_BTN_TXT  VARCHAR(160)  
            , @USER_NM          VARCHAR(50)  
            , @HPHONE           VARCHAR(14)  
            , @FINAL_EDU_LVL    VARCHAR(100)  
            , @WORK_TYPE        VARCHAR(200)  
            , @JICJONG          VARCHAR(100)  
            , @AREA             VARCHAR(100)  
            , @SALARY_DIV       VARCHAR(50)  
            , @SIMPLESELFINTRO  VARCHAR(200)  
  
      SELECT @USER_NM = USER_NM  
           , @HPHONE = HPHONE  
           , @FINAL_EDU_LVL = FINAL_EDU_LVL + (SELECT TOP 1 FINAL_EDU_LVL_STATUS FROM PG_RESUME_FINAL_EDU_TB C WITH(NOLOCK) WHERE C.RESUME_ID = M.RESUME_ID ORDER BY FINAL_EDU_ID)  
           , @WORK_TYPE = (SELECT DISTINCT WORK_TYPE = STUFF(  
                     /*(SELECT ',' + WORK_TYPE*/  
                       (SELECT (CASE WHEN WORK_MAIN = 1 THEN ',������' ELSE '' END) + (CASE WHEN WORK_SUB = 1 THEN ',�����' ELSE '' END) + (CASE WHEN WORK_OUT = 1 THEN ',�İ���' ELSE '' END)  
                        + (CASE WHEN PARTTIMEF = 1 THEN ',��ƮŸ��(�Ƹ�����Ʈ)' ELSE '' END)+ (CASE WHEN WORK_APPOINT = 1 THEN ',������' ELSE '' END) + (CASE WHEN WORK_FREELANCER = 1 THEN ',��������' ELSE '' END)  
                        FROM DBO.PG_RESUME_WORK_TYPE_TB AS B  WITH (NOLOCK)  
                       WHERE B.RESUME_ID = A.RESUME_ID  
                       FOR XML PATH('')),1,1,'')  
                FROM DBO.PG_RESUME_WORK_TYPE_TB AS A  WITH (NOLOCK)  
               WHERE A.RESUME_ID = M.RESUME_ID)  
           , @JICJONG = (SELECT TOP 1 CODENM3   
                FROM DBO.PG_RESUME_HOPE_JICJONG_TB A WITH(NOLOCK)   
                JOIN PP_FINDCODE_TB B WITH(NOLOCK) ON A.CODE_B = B.CODE3  
               WHERE A.RESUME_ID = M.RESUME_ID)  
           , @AREA = (SELECT TOP 1 AREA_SI + ' ' + AREA_GU FROM dbo.PG_RESUME_HOPE_AREA_TB D WITH(NOLOCK) WHERE D.RESUME_ID = M.RESUME_ID)  
           , @SALARY_DIV = CASE SALARY_DIV WHEN 0 THEN '������ ����'   
                                           WHEN 1 THEN '�ñ� ' + DBO.FN_WON(SALARY) + '��'  
                                           WHEN 2 THEN '���� ' + DBO.FN_WON(SALARY) + '��'  
                                           WHEN 3 THEN '���� ' + DBO.FN_WON(SALARY) + '��'  
                       END  
           , @SIMPLESELFINTRO = ISNULL(SIMPLESELFINTRO, '')  
        FROM PG_RESUME_MAIN_TB M WITH(NOLOCK)  
       WHERE CUID = @CUID  
         AND DEL_YN = 'N'  
         AND CASE WHEN @RESUME_ID = 0 THEN 0 ELSE RESUME_ID END = @RESUME_ID  
       ORDER BY DEL_YN ASC, DEFAULT_YN DESC, RESUME_ID DESC  
  
      IF @FINAL_EDU_LVL IS NULL OR @FINAL_EDU_LVL = ''  
        SET @FINAL_EDU_LVL = ''  
    END  
  
      
  
    IF @GBN = 'sms'  
    BEGIN  
      SELECT @SUBJECT = LMS_TITLE  
           , @RCV_APP_SMS_CONTENTS = LMS_MSG  
           , @KKO_MSG = KKO_MSG  
           , @KKO_URL = URL  
           , @KKO_URL_BTN_TXT = URL_BUTTON_TXT  
         FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO('MWFa065')  
          
      --SELECT @SUBJECT, @KKO_MSG  
      --SELECT @COM_NM, @USER_NM, @HPHONE, @FINAL_EDU_LVL, @WORK_TYPE, @JICJONG, @AREA, @SALARY_DIV, @SIMPLESELFINTRO, @CONTENTS  

        IF ISNULL(@USER_NM, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* �̸� : #{�����ڸ�}   ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{�����ڸ�}', ISNULL(@USER_NM, ''))
        END

        IF ISNULL(@HPHONE, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* ����ó : #{������ ����ó}  ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{������ ����ó}', ISNULL(@HPHONE, ''))
        END

        IF ISNULL(@JICJONG, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* ��� ������ : #{���������} ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{���������}', ISNULL(@JICJONG, ''))
        END

        IF ISNULL(@AREA, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* ��� �ٹ��� : #{����ٹ���} ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{����ٹ���}', ISNULL(@AREA, ''))  
        END

        IF ISNULL(@SIMPLESELFINTRO, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* ������ �ڱ�Ұ� : #{���� �ڱ�Ұ�}  ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{���� �ڱ�Ұ�}', ISNULL(@SIMPLESELFINTRO, ''))   
        END

        IF ISNULL(@FINAL_EDU_LVL, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* ���� �з� : #{������ �����з�}   ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{������ �����з�}', ISNULL(@FINAL_EDU_LVL, ''))    
        END

        IF ISNULL(@WORK_TYPE, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* �ٹ� ���� : #{�ٹ�����}   ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{�ٹ�����}', ISNULL(@WORK_TYPE, ''))    
        END

        IF ISNULL(@SALARY_DIV, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* ��� �޿� : #{��� �޿�}     ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{��� �޿�}', ISNULL(@SALARY_DIV, ''))    
        END

        IF ISNULL(@CONTENTS, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* �������� : #{���� �����Է�}  ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{���� �����Է�}', ISNULL(@CONTENTS, ''))  
        END

      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{ȸ���}', ISNULL(@COM_NM, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{�����ڸ�}', ISNULL(@USER_NM, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{������ ����ó}', ISNULL(@HPHONE, ''))        
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{������ �����з�}', ISNULL(@FINAL_EDU_LVL, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{�ٹ�����}', ISNULL(@WORK_TYPE, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{���������}', ISNULL(@JICJONG, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{����ٹ���}', ISNULL(@AREA, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{��� �޿�}', ISNULL(@SALARY_DIV, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{���� �ڱ�Ұ�}', ISNULL(@SIMPLESELFINTRO, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{���� �����Է�}', ISNULL(@CONTENTS, ''))  
  
      IF ISNULL(@USER_NM, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* �̸� : #{�����ڸ�}   ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{�����ڸ�}', ISNULL(@USER_NM, ''))
      END

      IF ISNULL(@HPHONE, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* ����ó : #{������ ����ó}  ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{������ ����ó}', ISNULL(@HPHONE, ''))
      END

      IF ISNULL(@JICJONG, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* ��� ������ : #{���������} ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{���������}', ISNULL(@JICJONG, ''))
      END

      IF ISNULL(@AREA, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* ��� �ٹ��� : #{����ٹ���} ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{����ٹ���}', ISNULL(@AREA, ''))  
      END

      IF ISNULL(@SIMPLESELFINTRO, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* ������ �ڱ�Ұ� : #{���� �ڱ�Ұ�}  ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{���� �ڱ�Ұ�}', ISNULL(@SIMPLESELFINTRO, ''))   
      END

      IF ISNULL(@FINAL_EDU_LVL, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* ���� �з� : #{������ �����з�}   ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{������ �����з�}', ISNULL(@FINAL_EDU_LVL, ''))    
      END

      IF ISNULL(@WORK_TYPE, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* �ٹ� ���� : #{�ٹ�����}   ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{�ٹ�����}', ISNULL(@WORK_TYPE, ''))    
      END

      IF ISNULL(@SALARY_DIV, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* ��� �޿� : #{��� �޿�}     ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{��� �޿�}', ISNULL(@SALARY_DIV, ''))    
      END

      IF ISNULL(@CONTENTS, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* �������� : #{���� �����Է�}  ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{���� �����Է�}', ISNULL(@CONTENTS, ''))  
      END

      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{ȸ���}', ISNULL(@COM_NM, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{�����ڸ�}', ISNULL(@USER_NM, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{������ ����ó}', ISNULL(@HPHONE, ''))        
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{������ �����з�}', ISNULL(@FINAL_EDU_LVL, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{�ٹ�����}', ISNULL(@WORK_TYPE, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{���������}', ISNULL(@JICJONG, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{����ٹ���}', ISNULL(@AREA, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{��� �޿�}', ISNULL(@SALARY_DIV, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{���� �ڱ�Ұ�}', ISNULL(@SIMPLESELFINTRO, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{���� �����Է�}', ISNULL(@CONTENTS, ''))  
  
      --SELECT @SUBJECT, @KKO_MSG  
  
      -- ���� �߼�  
      -- EXECUTE COMDB1.dbo.PUT_SENDMMS_PROC @SND_HPHONE, @RCV_HPHONE, @SUBJECT, @RCV_APP_SMS_CONTENTS, @REQTIME  
      -- EXECUTE COMDB1.dbo.PUT_SENDMMS_PROC '0802690011', '01033931420', @SUBJECT, @RCV_APP_SMS_CONTENTS, @REQTIME  
  
      -- īī���� �߼�        
      EXEC COMDB1.dbo.PUT_SENDKAKAO_PROC @RCV_HPHONE, @SND_HPHONE, 'MWFa065', @KKO_MSG, @KKO_URL, @KKO_URL_BTN_TXT, @SUBJECT, @RCV_APP_SMS_CONTENTS, '', '', ''  
    END  
  
  END  
  
  
  /*  
  IF @SUBJECT = ''  
  BEGIN  
    SET @SUBJECT = ':::::: ������ �� �ϰ� ��� ::::::'  
  END  
  
  -- �����ֿ� ��������  
  EXECUTE FINDDB1.COMDB1.dbo.PUT_SENDMMS_PROC @SND_HPHONE,@RCV_HPHONE,@SUBJECT,@RCV_APP_SMS_CONTENTS,@REQTIME  
  
  IF @RESUME_CHECK = 'Y'  
  BEGIN  
    -- �����ڿ� ��������  
    EXECUTE FINDDB1.COMDB1.dbo.PUT_SENDMMS_PROC '02-2187-7867',@SND_HPHONE,@SUBJECT,@SND_APP_SMS_CONTENTS,@REQTIME  
  END  
  */  
  
END  