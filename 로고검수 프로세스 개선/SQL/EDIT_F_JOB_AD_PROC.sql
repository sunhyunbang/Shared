--USE PAPER_NEW      
/*************************************************************************************        
 *  단위 업무 명 : 구인광고관리 > 광고수정 > 기본정보 수정        
 *  작   성   자 : 이 근 우(stari@mediawill.com)        
 *  작   성   일 : 2014/12/16        
 *  수   정   자 : 방순현        
 *  수   정   일 : 2021/10/12 
 *  수 정 내  용 : 로고검수 프로세스 개선
 *  설        명 : 
 *  주 의  사 항 :        
 *  사 용  소 스 : 프론트/job/advertiser/AdModify_Proc.asp, 프론트/job/brand/advertiser/BrandAdModify_Proc.asp        
 *  사 용  예 제 : EXEC DBO.EDIT_F_JOB_AD_PROC        
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
  
 /* 제 3자 제공 정보 수정*/  
 UPDATE PP_AD_PARTNER_TB  
 SET PARTNERF = @PARTNERF  
    ,FEDERATIONF = @FEDERATIONF  
    ,KINFAF = @KINFAF  
    ,SENIORTVF = @SENIORTVF  
 WHERE LINEADNO = @LINEADNO  
  
 /**************** 수정 ****************/  
 -- 직접등록        
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
        --,PHONE         = dbo.fn_MakeNomalPhone(@PHONE, @INPUT_BRANCH, @LAYOUT_BRANCH)     -- 줄광고는 전화번호를 수정하지 않는다.        
        ,FIELD_3 = @FIELD_3  
        ,FIELD_11 = @FIELD_11  
        ,ORDER_EMAIL = @ORDER_EMAIL  
        --,PARTNERF       = @PARTNERF       --2017.06.21, 수정UI에 해당항목이 없기 때문에 변경하지 않음        
        ,MOD_DT = GETDATE()  
        ,TITLE = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN TITLE  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
        END --21.09.28 상품별 진행상태 개선    
        ,FIELD_6 = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN FIELD_6  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
        END --21.09.28 상품별 진행상태 개선    
  WHERE LINEADNO = @LINEADNO  
  
  /* 수정내용(제목,회사명) 항목 업데이트 21.09.23*/  
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
   -- 광고주 인증 줄광고 수정인 경우        
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
        END --21.09.28 상품별 진행상태 개선    
        ,FIELD_6 = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN FIELD_6  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
        END --21.09.28 상품별 진행상태 개선    
  WHERE LINEADNO = @LINEADNO  
  
  /* 수정내용(제목,회사명) 항목 업데이트 21.09.23*/  
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
   -- 비회원 수정일 경우 비밀번호가 맞는 지 확인        
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
        --,PARTNERF       = @PARTNERF       --2017.06.21, 수정UI에 해당항목이 없기 때문에 변경하지 않음       
        ,MOD_DT = GETDATE()  
        ,TITLE = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN TITLE  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
        END --21.09.28 상품별 진행상태 개선    
        ,FIELD_6 = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN FIELD_6  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
        END --21.09.28 상품별 진행상태 개선    
  WHERE LINEADNO = @LINEADNO  
  
 
  /* 수정내용(제목,회사명) 항목 업데이트 21.09.23*/  
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
  
  -- 전화번호 TABLE에 등록        
  EXECUTE EDIT_PP_AD_PHONE_PROC @LINEADNO  
   ,@PHONE  
  
  --종료일자가 변경될 경우        
  IF CONVERT(VARCHAR(10), @ORG_END_DT, 120) <> CONVERT(VARCHAR(10), @END_DT, 120)  AND EXISTS (SELECT *  FROM PP_AD_RESERVE_TB  WHERE LINEADNO = @LINEADNO )  
  BEGIN  
   -- LOG 저장        
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
  
   --예약건에 한해, 매핑테이블 종료일자도 수정        
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
   -- 수정 (ECOMM, 등록대행 광고 수정인 경우)        
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
        --,PARTNERF       = @PARTNERF       --2017.06.21, 수정UI에 해당항목이 없기 때문에 변경하지 않음        
        ,MOD_DT = GETDATE()  
        ,TITLE = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN TITLE  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
        END --21.09.28 상품별 진행상태 개선    
        ,FIELD_6 = CASE   
        WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH) = 'Y'  
          THEN FIELD_6  
          ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
        END --21.09.28 상품별 진행상태 개선    
  WHERE LINEADNO = @LINEADNO  
        
  /* 수정내용(제목,회사명) 항목 업데이트 21.09.23*/  
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
  
  -- 전화번호 TABLE에 등록        
  EXECUTE EDIT_PP_AD_PHONE_PROC @LINEADNO  
   ,@PHONE  
  
  --종료일자가 변경될 경우        
  --예약공고면 예약일 변경        
  IF @RESERVE_YN = 'Y'  
   AND EXISTS (  
    SELECT *  
    FROM PP_AD_RESERVE_TB  
    WHERE LINEADNO = @LINEADNO  
    )  
  BEGIN  
   -- LOG 저장        
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
  
   --매핑테이블 예약일자도 수정        
   UPDATE B  
   SET RESERVE_START_DT = @RESERVE_START_DT  
    ,RESERVE_END_DT = @END_DT  
   FROM PP_AD_TB AS A  
   JOIN PP_AD_RESERVE_TB AS B ON A.LINEADNO = B.LINEADNO  
   WHERE A.DELYN = 'N'  
    AND B.RESERVE_START_DT IS NOT NULL  
    AND A.LINEADNO = @LINEADNO  
  END  
  
  
  -- 예약공고 였다가 예약을 취소할경우 예약 테이블에서 삭제        
  IF @RESERVE_YN = 'N'  
   AND EXISTS (  
    SELECT *  
    FROM PP_AD_RESERVE_TB  
    WHERE LINEADNO = @LINEADNO  
     AND RESERVE_STAT IN (  
      '등록'  
      ,'예약'  
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
 ELSE -- 위 두 조건에 맞지 않으면 @OUTPUT_LINEADID를 0으로 반환한다.        
 BEGIN  
  SET @OUTPUT_LINEADID = 0  
 END  
   --print @OUTPUT_LINEADID        
END  