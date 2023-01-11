USE MWMEMBER
go
/*************************************************************************************    
 *  ���� ���� �� : ����ڵ���� �������� ������Ʈ(����û ����)  
 *  ��   ��   �� : �� �� ��    
 *  ��   ��   �� : 2022/11/04    
 *  ��   ��   �� : Ȳ �� ��  
 *  ��   ��   �� : 2022/12/30  
 *  ��        �� :     
 *  �� ��  �� �� :    
 *  �� ��  �� �� :    
 *  �� ��  �� �� :    
 exec PUT_MM_UPDATE_BIZLICENSE_NTS_PROC 'Y','2020-05-29','�ٿ����ܰ��ǿ�','�����','139-11-04315','AUTO','PC',0  
 *************************************************************************************/    
    
ALTER PROC [dbo].[PUT_MM_UPDATE_BIZLICENSE_NTS_PROC]    
 @CERTIFICATIO_YN  CHAR(1)         
,@BIZ_OPENDT VARCHAR(20)            
,@COM_NM     VARCHAR(50)            
,@CEO_NM     VARCHAR(30)            
,@REGISTER_NO VARCHAR(12)            
,@HANDLE_ID   VARCHAR(30) = 'AUTO'            
,@BROWSER     VARCHAR(10) = 'PC'     
--,@RESULT     TINYINT OUTPUT     -- ��� (0: �����ȵ�, 1: �����Ϸ�)      
AS    
  
BEGIN  
  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  SET NOCOUNT ON    
      
  DECLARE @COM_ID     INT    
  DECLARE @CUID       INT    
  DECLARE @CM_USERID  VARCHAR(50)  
  DECLARE @FINAL_MEMO   VARCHAR(100)  
  DECLARE @FINAL_MAGID  VARCHAR(30)  
  DECLARE @MAG_NM       VARCHAR(30)  
  DECLARE @HANDEL_NM    VARCHAR(30)  
  
  SELECT   
  @COM_ID = CC.COM_ID  
  ,@CM_USERID = CM.USERID  
  ,@CUID = CM.CUID  
  ,@MAG_NM = CM.USER_NM  
  FROM CST_COMPANY AS CC WITH(NOLOCK)  
  LEFT JOIN CST_MASTER AS CM WITH(NOLOCK)   
  ON CC.COM_ID = CM.COM_ID  
  WHERE CC.CEO_NM = @CEO_NM AND CC.COM_NM = @COM_NM AND CC.REGISTER_NO = @REGISTER_NO  
    
  
  IF @HANDLE_ID <> 'AUTO' -- ���� ��Ͻ�  
  BEGIN  
   SET @FINAL_MEMO = 'Admin ���� ������� ���� -����û ����- �Ϸ�'  
      SET @FINAL_MAGID = @HANDLE_ID  
  
   --SELECT @HANDEL_NM = MAGNAME FROM FINDDB2.FINDCOMMON.DBO.COMMONMAGUSER WITH (NOLOCK)    
      --WHERE MagID = @HANDLE_ID  
  END  
  ELSE -- ����Ʈ ��Ͻ�  
  BEGIN  
    SET @FINAL_MEMO = 'ȸ��(' + @CM_USERID + ')�� '+ @BROWSER +'���� ������� ���� -����û ����- �Ϸ�'  
    SET @FINAL_MAGID = @CM_USERID  
 --SET @HANDEL_NM = @HANDLE_ID  
  END    
  
    
  IF @COM_ID IS NOT NULL AND @COM_ID <> ''    
  BEGIN    
    UPDATE A    
  SET A.BIZ_CERTIFICATION_TYPE = 'N'    
  , A.BIZLICENSE_CERTIFICATION_YN = @CERTIFICATIO_YN    
  ,A.BIZ_OPENDT = @BIZ_OPENDT    
  ,A.BIZLICENSE_REGDATE = GETDATE()    
  ,A.BIZLICENSE_HANDLE_ID = 'AUTO'    
    --,A.BIZLICENSE_ISSUANCEDATE =''  
    --,A.BIZLICENSE_IMGNM = ''  
  FROM CST_COMPANY AS A    
  WHERE COM_ID = @COM_ID    
  
    IF (SELECT COUNT(MagID) FROM FINDDB2.FINDCOMMON.DBO.COMMONMAGUSER WITH (NOLOCK) WHERE MagID = @FINAL_MAGID) > 0  
      BEGIN  
        exec PUT_AD_MM_MEMBER_HISTORY_PROC @CUID ,@CM_USERID ,'S101' ,@FINAL_MAGID ,@FINAL_MEMO  
      END  
    ELSE  
      BEGIN  
        INSERT INTO [dbo].[MM_MEMBER_HISTORY_TB]  
              ([USERID]  
              ,[SECTION_CD]  
              ,[MAG_ID]  
              ,[MAG_NAME]  
              ,[MAG_BRANCH]  
              ,[COMMENT]  
              ,[REG_DT]  
              ,[CUID])  
        VALUES  
              (@CM_USERID  
              ,'S101'  
              ,@FINAL_MAGID  
              ,@MAG_NM  
              ,'80'  
              ,@FINAL_MEMO  
              ,GETDATE()  
              ,@CUID)  
      END  
     
    IF NOT EXISTS (SELECT CUID FROM [FINDDB1].PAPER_NEW.DBO.PP_RESUME_READ_GOODS_COMPANY_AUTH_TB WHERE CUID = @CUID)  
  BEGIN  
   -- ���  
   INSERT INTO [FINDDB1].PAPER_NEW.DBO.PP_RESUME_READ_GOODS_COMPANY_AUTH_TB (  
    ADGBN  
     , USER_ID  
     , BIZNO  
     , COM_NM  
     , EMAIL  
     , HPHONE  
     , SEARCH_HPHONE  
     , PHONE  
     , SEARCH_PHONE  
     , [STATUS]  
     , REJECT_COMMENT  
     , MAG_ID  
     , MAG_AREA  
     , MAG_BRANCHCODE  
     , CUID  
     , BIZ_IMAGE  
     , ONESNAME  
     , ONESDEPART  
     )  
     SELECT '1'  
    , CM.USERID  
    , CC.REGISTER_NO  
    , CC.COM_NM  
    , CM.EMAIL  
    , CM.HPHONE
    , REPLACE(CC.MAIN_PHONE, '-', '')  
    , CC.PHONE  
    , REPLACE(CC.PHONE, '-', '')  
    , '1'  
    , ''  
    , @FINAL_MAGID  
    , '0'  
    , '0'  
    , @CUID  
    , ''  
    , @MAG_NM      , ''  
    FROM CST_COMPANY AS CC WITH(NOLOCK)  
    JOIN CST_MASTER AS CM ON CC.COM_ID = CM.COM_ID   
    WHERE CC.COM_ID = @COM_ID  
    END  
    ELSE  
    BEGIN  
   UPDATE [FINDDB1].PAPER_NEW.DBO.PP_RESUME_READ_GOODS_COMPANY_AUTH_TB  
   SET [STATUS] = '1'  
   WHERE CUID = @CUID  
    END  
      
      
    /*  
    SET @RESULT = 1  
  
  END    
  ELSE  
  BEGIN  
    SET @RESULT = 0  
 */  
  END  
END