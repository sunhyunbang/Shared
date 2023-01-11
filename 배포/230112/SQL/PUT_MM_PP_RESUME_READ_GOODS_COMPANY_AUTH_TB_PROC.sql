use PAPER_NEW
GO
/*************************************************************************************    
 *  단위 업무 명 : 이력서 기업인증 추가   
 *  작   성   자 : 황 민 수   
 *  작   성   일 : 2022/12/30    
 *  수   정   자 :     
 *  수   정   일 :     
 *  설        명 :     
 *  주 의  사 항 :    
 *  사 용  소 스 :    
 *  사 용  예 제 :    
  
 *************************************************************************************/    
    
ALTER PROC [dbo].[PUT_MM_PP_RESUME_READ_GOODS_COMPANY_AUTH_TB_PROC]     
  @CUID         INT    
, @BIZ_IMAGE    VARCHAR(50) = ''   
, @HANDLE_ID    VARCHAR(30) = 'AUTO'   
AS    
    
BEGIN    
    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  SET NOCOUNT ON    
      
  DECLARE @COM_ID     INT    
  DECLARE @CM_USERID  VARCHAR(50)  
  DECLARE @FINAL_MAGID  VARCHAR(30)  
  DECLARE @MAG_NM       VARCHAR(30)  
  DECLARE @HANDEL_NM  VARCHAR(30)   
    
 SELECT   
 @COM_ID = COM_ID  
 ,@CM_USERID = USERID  
 ,@MAG_NM = USER_NM  
 FROM MEMBERDB.[MWMEMBER].DBO.CST_MASTER WITH(NOLOCK)  
 WHERE CUID = @CUID  
  
  IF @HANDLE_ID <> 'AUTO' -- 어드민 등록시  
  BEGIN  
    SET @FINAL_MAGID = @HANDLE_ID  
  END  
  ELSE -- 프론트 등록시  
  BEGIN  
    SET @FINAL_MAGID = @CM_USERID  
  END    
  
  
  
 IF NOT EXISTS (SELECT CUID FROM PP_RESUME_READ_GOODS_COMPANY_AUTH_TB WHERE CUID = @CUID)  
    BEGIN  
        -- 등록  
        INSERT INTO PP_RESUME_READ_GOODS_COMPANY_AUTH_TB (  
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
   , @BIZ_IMAGE  
   , @MAG_NM  
   , ''  
   FROM MEMBERDB.[MWMEMBER].DBO.CST_COMPANY AS CC WITH(NOLOCK)  
   JOIN MEMBERDB.[MWMEMBER].DBO.CST_MASTER AS CM ON CC.COM_ID = CM.COM_ID   
   WHERE CC.COM_ID = @COM_ID  
   END  
   ELSE  
   BEGIN  
     UPDATE PP_RESUME_READ_GOODS_COMPANY_AUTH_TB  
     SET [STATUS] = '1'  
     WHERE CUID = @CUID  
   END  
  
END  
  