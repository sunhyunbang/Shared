          
/*************************************************************************************          
 *  단위 업무 명 : PUSH용 디바이스 정보 저장          
 *  작   성   자 : 유민호           
 *  작   성   일 : 2014/07/05          
 *  설        명 : PAPER_NEW --> MOBILE_SERVICE          
 *  수   정   자 : 방순현        
 *  수   정   일 : 2021/10/25 
 *  수 정 내  용 : Android Target SDK30 디바이스 아이디 값 변경에 따른 푸시이슈
 *  주 의  사 항 :
 *  사 용  소 스 :           
 *  사 용  예 제 :           
EXEC MOBILE_COM_PUSH_DEVICE_SET_INFO 'cook','12345','android','APA91bGvVD7zKhZ04WbIfu89krPzYDk-c_ggIERm_FE7FMZY7kegh9NWvZIeQ4Ij6MYOujfnb8vLNe6UxO0xjG-yOqAA2k5Fk2Y_pLcnZUSKM35oK6QMNZ0eFW-BHcPyZLC8qCRUBSFXo-BTonw9kGmx765fA0sJHA','3.0.1','N','Y'      
      
 *************************************************************************************/          
ALTER PROCEDURE [dbo].[MOBILE_COM_PUSH_DEVICE_SET_INFO]          
 @SiteCD    VARCHAR(20)          
 , @DeviceID   NVARCHAR(800)          
 , @DeviceType  VARCHAR(20)          
 , @PushKey   NVARCHAR(800)          
 , @AppVersion  VARCHAR(10)          
 , @Push_YN_Match VARCHAR(1)          
 , @Push_YN_Notice VARCHAR(1)          
 , @DeviceNewID NVARCHAR(800)        
 , @RETURN   VARCHAR(16) OUTPUT          
AS          
          
BEGIN          
SET NOCOUNT ON          
           
IF @SiteCD <> '' AND @DeviceID <> '' 
  BEGIN          
    IF NOT EXISTS (SELECT * FROM MOBILE_PUSH_DEVICE_INFO WITH(NOLOCK) WHERE SiteCD = @SiteCD AND DeviceNewID = @DeviceNewID) 
      BEGIN          
            
        INSERT INTO MOBILE_PUSH_DEVICE_INFO          
          (SiteCD, DeviceID, DeviceType, PushKey, AppVersion          
          , Push_YN_Match, Push_YN_Notice, OpenCnt          
          , Date_Reg, Date_Upt , DeviceNewID)          
        VALUES (@SiteCD, @DeviceNewID, @DeviceType, @PushKey, @AppVersion          
          , @Push_YN_Match, @Push_YN_Notice, 0          
          , GETDATE(), GETDATE() , @DeviceNewID)          
      END          
    ELSE 
      BEGIN          
          
        UPDATE MOBILE_PUSH_DEVICE_INFO          
           SET DeviceType       = @DeviceType          
              ,PushKey          = @PushKey          
              ,AppVersion       = @AppVersion          
              ,Push_YN_Match    = @Push_YN_Match          
              ,Push_YN_Notice   = @Push_YN_Notice          
              --, OpenCnt = OpenCnt + 1          
              ,Date_Upt         = GETDATE()          
        WHERE SiteCD = @SiteCD AND DeviceNewID = @DeviceNewID          
      END          

      SET @RETURN = (SELECT CONVERT(VARCHAR(16),GETDATE(),21))          
  END          
ELSE 
  BEGIN           
    SET @RETURN = ''          
  END           
END 