USE MWMEMBER
go
/*************************************************************************************    
 *  단위 업무 명 : 사업자등록증 인증정보 업데이트    
 *  작   성   자 : 방 순 현    
 *  작   성   일 : 2022/11/04    
 *  수   정   자 : 황 민 수  
 *  수   정   일 : 2022/12/30    
 *  설        명 :     
 *  주 의  사 항 :    
 *  사 용  소 스 :    
 *  사 용  예 제 :    
 exec PUT_MM_UPDATE_BIZLICENSE_PROC '2022-11-1','Y',123123123,'KY8GDUZ94BMB8E7DZPYF.jpg','AUTO','PC'  
 *************************************************************************************/    
    
ALTER PROC [dbo].[PUT_MM_UPDATE_BIZLICENSE_PROC]    
  @ISSUANCE_DATE     VARCHAR(20)    
, @CERTIFICATIO_YN   CHAR(1)    
, @CUID      INT    
, @BIZ_IMAGE    VARCHAR(50)    
, @HANDLE_ID    VARCHAR(30) = 'AUTO'   
, @BROWSER      VARCHAR(10) = 'PC'  
AS    
    
BEGIN    
    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  SET NOCOUNT ON    
      
  DECLARE @COM_ID     INT    
  DECLARE @CM_USERID  VARCHAR(50)  
  DECLARE @FINAL_MEMO   VARCHAR(100)  
  DECLARE @FINAL_MAGID  VARCHAR(30)  
  DECLARE @MAG_NM       VARCHAR(30)  
  DECLARE @HANDEL_NM  VARCHAR(30)   
    
 SELECT   
 @COM_ID = COM_ID  
 ,@CM_USERID = USERID  
  ,@MAG_NM = USER_NM  
 FROM CST_MASTER WITH(NOLOCK)  
 WHERE CUID = @CUID  
 --AND MEMBER_CD = '2'  
  
  IF @HANDLE_ID <> 'AUTO' -- 어드민 등록시  
  BEGIN  
 SET @FINAL_MEMO = 'Admin 에서 기업정보 인증 -인증 서류- 완료'  
    SET @FINAL_MAGID = @HANDLE_ID  
  
 --SELECT @HANDEL_NM = MAGNAME FROM FINDDB2.FINDCOMMON.DBO.COMMONMAGUSER WITH (NOLOCK)    
    --WHERE MagID = @HANDLE_ID   
  
  END  
  ELSE -- 프론트 등록시  
  BEGIN  
    SET @FINAL_MEMO = '회원(' + @CM_USERID + ')이 '+ @BROWSER +'에서 기업정보 인증 -인증 서류- 완료'  
    SET @FINAL_MAGID = @CM_USERID  
 --SET @HANDEL_NM = @HANDLE_ID  
  END    
  
  IF @COM_ID IS NOT NULL AND @COM_ID <> ''    
  BEGIN    
    UPDATE A    
  SET A.BIZLICENSE_IMGNM = @BIZ_IMAGE    
  , A.BIZLICENSE_CERTIFICATION_YN = @CERTIFICATIO_YN    
  ,A.BIZLICENSE_ISSUANCEDATE = @ISSUANCE_DATE    
  ,A.BIZLICENSE_REGDATE = GETDATE()    
  ,A.BIZLICENSE_HANDLE_ID = 'AUTO'    
    ,A.BIZ_CERTIFICATION_TYPE = 'O'  
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
        -- 등록  
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
   , @BIZ_IMAGE  
   , @MAG_NM  
   , ''  
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
     
  
  END    
END  
  