USE MWMEMBER
go

ALTER PROCEDURE [dbo].[SP_BIZLICENSE_NOAGREE_UPDATE]        
/*************************************************************************************        
 *  단위 업무 명 : 사업자등록증 인증페이지 등록/수정(수기)      
 *  작   성   자 : 방순현        
 *  작   성   일 : 2022-11-18        
 *  수   정   자 :        
 *  수   정   일 :        
 *  설        명 :         
 * RETURN(500)  -- 실패        
 * RETURN(0) -- 성공        
 * DECLARE @RET INT        
 *************************************************************************************/        
  @CUID int,        
  @COM_ID int ,        
  @MAG_ID varchar(50),        
      
  @LAT decimal(16, 14) ,        
  @LNG decimal(17, 14) ,        
  @CITY varchar(50) ,        
  @GU varchar(50) ,        
  @DONG varchar(50) ,        
  @ADDR1 varchar(100) ,        
  @ADDR2 varchar(100) ,        
  @LAW_DONGNO char(10) ,        
  @MAN_NO varchar(25) ,        
  @ROAD_ADDR_DETAIL varchar(100),        
  @CEO_NM varchar(30)  ,      
  @COM_NM varchar(50)  ,      
 @ISSUANCE_DT datetime,      
 @MEMO varchar(100) ='',      
  @BIZ_IMAGE varchar(50) ='',      
  @REGISTER_NO varchar(12),      
  @BIZ_OPENDT datetime = NULL,                  
  @BIZ_CERTIFICATION_TYPE char(1),      
  @UPDATEYN char(1) =''  
AS        
        
  SET NOCOUNT ON;        
  DECLARE @ID_COUNT bit        
        
      
 DECLARE @CM_USERID VARCHAR(30)      
 DECLARE @FUL_MEMO VARCHAR(100)      
 DECLARE @AUTH_TYPE VARCHAR(30)      
 DECLARE @UPDATE_TYPE VARCHAR(30)      
      
 SELECT @CM_USERID = USERID FROM CST_MASTER       
 WHERE CUID = @CUID       
      
  IF @BIZ_CERTIFICATION_TYPE = 'O'       
  BEGIN      
    SET @AUTH_TYPE = '인증 서류'      
  END      
  ELSE      
  BEGIN      
    SET @AUTH_TYPE = '국세청 인증'      
  END      
  
  IF @UPDATEYN ='Y'  
  BEGIN  
    SET @UPDATE_TYPE = '수정'  
  END  
  ELSE  
  BEGIN  
    SET @UPDATE_TYPE = '완료'  
  END  
      
 IF @MEMO <> ''      
 BEGIN      
  SET @FUL_MEMO = 'Admin 에서 기업정보 인증 -' + @AUTH_TYPE + '- '+@UPDATE_TYPE+'(' + @MEMO + ')'      
 END      
 ELSE      
 BEGIN      
  SET @FUL_MEMO = 'Admin 에서 기업정보 인증 -' + @AUTH_TYPE + '- '+@UPDATE_TYPE     
 END      
    
 DECLARE @MAG_NM  VARCHAR(30)    
    
 SELECT @MAG_NM = MAGNAME FROM FINDDB2.FINDCOMMON.DBO.COMMONMAGUSER WITH (NOLOCK)    
 WHERE MagID = @MAG_ID    
    
      
  -- 관리자 체크        
  SET @ID_COUNT = 0        
        
  SELECT @ID_COUNT = COUNT(COM_ID)         
  FROM CST_COMPANY WITH(NOLOCK)         
  WHERE COM_ID = @COM_ID        
        
  SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한        
        
  IF @ID_COUNT = 1        
    BEGIN        
      UPDATE A         
        SET       
          A.CEO_NM                        = @CEO_NM        
          ,A.LAT                          = @LAT        
          ,A.LNG                          = @LNG        
          ,A.CITY                         = @CITY        
          ,A.GU                           = @GU        
          ,A.DONG                         = @DONG        
          ,A.ADDR1                        = @ADDR1        
          ,A.ADDR2                        = @ADDR2        
          ,A.LAW_DONGNO                   = @LAW_DONGNO        
          ,A.MAN_NO                       = @MAN_NO        
          ,A.ROAD_ADDR_DETAIL             = @ROAD_ADDR_DETAIL        
          ,A.MOD_ID                       = @MAG_ID        
          ,A.MOD_DT                       = GETDATE()      
          ,A.BIZLICENSE_HANDLE_ID         = @MAG_NM    
          ,A.COM_NM                       = @COM_NM      
          ,A.REGISTER_NO                  = @REGISTER_NO      
          ,A.BIZLICENSE_ISSUANCEDATE      = @ISSUANCE_DT      
          ,A.BIZLICENSE_IMGNM             = @BIZ_IMAGE      
          ,A.BIZLICENSE_REGDATE           = GETDATE()      
          ,A.BIZLICENSE_CERTIFICATION_YN  = 'Y'      
          ,A.BIZ_OPENDT                   = CASE WHEN @BIZ_OPENDT = '' THEN A.BIZ_OPENDT ELSE @BIZ_OPENDT END      
          ,A.BIZ_CERTIFICATION_TYPE       = @BIZ_CERTIFICATION_TYPE      
      FROM CST_COMPANY AS A      
      WHERE COM_ID = @COM_ID     
        
      INSERT INTO CST_COMPANY_HISTORY (COM_ID,COM_NM ,CEO_NM,MOD_ID, MOD_DT,  PHONE,  HOMEPAGE, LAT, LNG, CITY, GU,DONG, ADDR1, ADDR2, LAW_DONGNO, MAN_NO, ROAD_ADDR_DETAIL,REGISTER_NO, CUID)         
        VALUES (@COM_ID,@COM_NM,@CEO_NM , @MAG_ID, GETDATE(),  '', '', @LAT, @LNG, @CITY, @GU,@DONG, @ADDR1, @ADDR2, @LAW_DONGNO, @MAN_NO, @ROAD_ADDR_DETAIL,@REGISTER_NO, @CUID)        
         
    IF @MEMO != ''      
    BEGIN      
     exec PUT_AD_MM_MEMBER_HISTORY_PROC @CUID ,@CM_USERID ,'S101',@MAG_ID,@FUL_MEMO      
    END      
    
 IF NOT EXISTS (SELECT CUID FROM PAPER_NEW.DBO.PP_RESUME_READ_GOODS_COMPANY_AUTH_TB WHERE CUID = @CUID)    
 BEGIN    
  -- 등록    
  INSERT INTO PAPER_NEW.DBO.PP_RESUME_READ_GOODS_COMPANY_AUTH_TB (    
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
   , @MAG_ID    
   , '0'    
   , '0'    
   , @CUID    
   , ''    
   , @MAG_NM    
   , ''    
   FROM CST_COMPANY AS CC WITH(NOLOCK)    
   JOIN CST_MASTER AS CM ON CC.COM_ID = CM.COM_ID     
   WHERE CC.COM_ID = @COM_ID    
  END    
  ELSE    
  BEGIN    
  UPDATE PAPER_NEW.DBO.PP_RESUME_READ_GOODS_COMPANY_AUTH_TB    
  SET [STATUS] = '1'    
  WHERE CUID = @CUID    
  END    
      
    RETURN(0) -- 성공        
    END         
          
 ELSE        
 BEGIN        
 RETURN(500)  -- 실패        
 END 