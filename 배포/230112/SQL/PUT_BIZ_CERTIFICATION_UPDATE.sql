USE MWMEMBER
GO

ALTER PROCEDURE [dbo].[PUT_BIZ_CERTIFICATION_UPDATE]            
/*************************************************************************************            
 *  단위 업무 명 : 사업자등록증 인증페이지 등록           
 *  작   성   자 : 방순현            
 *  작   성   일 : 2022-12-21            
 *  수   정   자 :            
 *  수   정   일 :            
 *  설        명 :             
 * RETURN(500)  -- 실패            
 * RETURN(0) -- 성공            
 * DECLARE @RET INT            
 *************************************************************************************/            
  @CUID             int            
, @COM_ID           int          
, @USERID           varchar(50)           
, @MAIN_PHONE       varchar(14)          
, @FAX              varchar(14)            
, @LAT              decimal(16, 14)            
, @LNG              decimal(17, 14)            
, @CITY             varchar(50)             
, @GU               varchar(50)            
, @DONG             varchar(50)            
, @ADDR1            varchar(100)            
, @ADDR2            varchar(100)             
, @LAW_DONGNO       char(10)             
, @MAN_NO           varchar(25)             
, @ROAD_ADDR_DETAIL varchar(100)            
, @CEO_NM           varchar(30)           
, @COM_NM           varchar(50)            
, @ISSUANCE_DATE    VARCHAR(30) =''              
, @BIZ_IMAGE        VARCHAR(50)            
, @HANDLE_ID        VARCHAR(30) = 'AUTO'           
, @BROWSER          VARCHAR(10) = 'PC'          
, @BIZ_OPENDT       VARCHAR(30)        
, @AUTH_TYPE        CHAR(1)        
AS            
            
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED            
SET NOCOUNT ON               
        
DECLARE @CM_USERID  VARCHAR(50)          
DECLARE @FINAL_MEMO   VARCHAR(100)          
DECLARE @FINAL_MAGID  VARCHAR(30)          
DECLARE @MAG_NM       VARCHAR(30)      
DECLARE @HANDEL_NM  VARCHAR(30)         
        
SELECT           
@CM_USERID = USERID          
,@MAG_NM = USER_NM          
FROM CST_MASTER WITH(NOLOCK)          
WHERE CUID = @CUID          
        
IF @HANDLE_ID <> 'AUTO' -- 어드민 등록시          
BEGIN       
  IF @AUTH_TYPE = 'O'    
  BEGIN    
    SET @FINAL_MEMO = 'Admin 에서 기업정보 인증 -인증 서류- 완료'     
  END    
  ELSE    
  BEGIN    
    SET @FINAL_MEMO = 'Admin 에서 기업정보 인증 -국세청 인증- 완료'     
  END    
           
  SET @FINAL_MAGID = @HANDLE_ID     
  --SELECT @HANDEL_NM = MAGNAME FROM FINDDB2.FINDCOMMON.DBO.COMMONMAGUSER WITH (NOLOCK)      
  --WHERE MagID = @HANDLE_ID          
END          
ELSE -- 프론트 등록시         
BEGIN        
  --SET @FINAL_MEMO = '회원(' + @CM_USERID + ')이 '+ @BROWSER +'에서 기업정보 인증 -인증 서류- 완료' 
  
  IF @AUTH_TYPE = 'O'    
  BEGIN    
    SET @FINAL_MEMO = '회원(' + @CM_USERID + ')이 '+ @BROWSER +'에서 기업정보 인증 -인증 서류- 완료' 
  END    
  ELSE    
  BEGIN    
    SET @FINAL_MEMO = '회원(' + @CM_USERID + ')이 '+ @BROWSER +'에서 기업정보 인증 -국세청 인증- 완료' 
  END  

  SET @FINAL_MAGID = @CM_USERID        
  --SET @HANDEL_NM = @HANDLE_ID      
END            
        
            
SET @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한            
            
IF (SELECT COUNT(COM_ID) FROM CST_COMPANY WHERE COM_ID =@COM_ID ) > 0            
BEGIN            
  UPDATE A             
    SET A.MAIN_PHONE      = @MAIN_PHONE            
    ,A.CEO_NM             = @CEO_NM            
    ,A.FAX                = @FAX            
    ,A.LAT                = @LAT            
    ,A.LNG                = @LNG            
    ,A.CITY               = @CITY            
    ,A.GU                 = @GU            
    ,A.DONG               = @DONG            
    ,A.ADDR1              = @ADDR1            
    ,A.ADDR2              = @ADDR2            
    ,A.LAW_DONGNO         = @LAW_DONGNO            
    ,A.MAN_NO             = @MAN_NO            
    ,A.ROAD_ADDR_DETAIL   = @ROAD_ADDR_DETAIL            
    ,A.MOD_ID             = @USERID            
    ,A.MOD_DT             = GETDATE()            
    ,A.COM_NM             = @COM_NM          
    ,A.BIZLICENSE_IMGNM   = @BIZ_IMAGE        
    ,A.BIZLICENSE_CERTIFICATION_YN  = 'Y'            
    ,A.BIZLICENSE_ISSUANCEDATE      = CASE WHEN @ISSUANCE_DATE = '' THEN BIZLICENSE_ISSUANCEDATE ELSE @ISSUANCE_DATE END            
    ,A.BIZLICENSE_REGDATE           = GETDATE()            
    ,A.BIZLICENSE_HANDLE_ID         = 'AUTO'            
    ,A.BIZ_CERTIFICATION_TYPE       = @AUTH_TYPE        
    ,A.BIZ_OPENDT                   = CASE WHEN @BIZ_OPENDT = '' THEN BIZ_OPENDT ELSE @BIZ_OPENDT END        
  FROM CST_COMPANY AS A        
  WHERE COM_ID = @COM_ID            
            
  INSERT INTO CST_COMPANY_HISTORY (COM_ID,COM_NM ,CEO_NM,MOD_ID, MOD_DT, MAIN_PHONE, PHONE, FAX, HOMEPAGE, LAT, LNG, CITY, GU,DONG, ADDR1, ADDR2, LAW_DONGNO, MAN_NO, ROAD_ADDR_DETAIL, CUID)             
  VALUES (@COM_ID,@COM_NM,@CEO_NM , @USERID, GETDATE(), @MAIN_PHONE, '', @FAX, '', @LAT, @LNG, @CITY, @GU,@DONG, @ADDR1, @ADDR2, @LAW_DONGNO, @MAN_NO, @ROAD_ADDR_DETAIL, @CUID)            
             
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
          
          
  IF NOT EXISTS (SELECT CUID FROM FINDDB1.PAPER_NEW.DBO.PP_RESUME_READ_GOODS_COMPANY_AUTH_TB WHERE CUID = @CUID)          
  BEGIN          
  -- 등록          
    INSERT INTO FINDDB1.PAPER_NEW.DBO.PP_RESUME_READ_GOODS_COMPANY_AUTH_TB (          
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
    FROM CST_COMPANY AS CC WITH(NOLOCK)          
    JOIN CST_MASTER AS CM ON CC.COM_ID = CM.COM_ID           
    WHERE CC.COM_ID = @COM_ID          
  END          
  ELSE          
  BEGIN          
    UPDATE FINDDB1.PAPER_NEW.DBO.PP_RESUME_READ_GOODS_COMPANY_AUTH_TB          
    SET [STATUS] = '1'          
    WHERE CUID = @CUID          
  END        
        
  RETURN(0) -- 성공            
END             
              
ELSE            
BEGIN            
  RETURN(500)  -- 실패            
END            
            