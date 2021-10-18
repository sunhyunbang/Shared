--USE PAPER_NEW    
/*************************************************************************************    
 *  단위 업무 명 : 일자리등록 TEMP > 실데이터 등록(PayProcess)    
 *  작   성   자 : 김봉수    
 *  작   성   일 : 2020/06/17    
 *  수   정   자 : 김선호    
 *  수   정   일 : 2021/03/29    
 *  설        명 : 키워드 상품 정보가 있을 경우 처리
 *  수   정   자 : 방 순 현        
 *  수   정   일 : 2021/10/12 
 *  수 정 내  용 : 로고검수 프로세스 개선
 *  사 용  소 스 :    
 *  사 용  예 제 :    
 EXEC [SET_FJ_JOB_AD_TEMP_TO_REAL_PAY_PROC]    
*************************************************************************************/    
ALTER PROCEDURE [dbo].[SET_FJ_JOB_AD_TEMP_TO_REAL_PROC]    
 @LINEADID     INT            = 0      
,@INPUT_BRANCH    TINYINT      
,@LAYOUT_BRANCH    TINYINT      
,@FINDCODE     INT    
,@AREA_A     VARCHAR(30)      
,@AREA_B     VARCHAR(30)      
,@AREA_C     VARCHAR(30)      
,@AREA_DETAIL    VARCHAR(60)      
,@ORDER_NAME    VARCHAR(30)      
,@PHONE      VARCHAR(127)      
,@FIELD_3     VARCHAR(100)      
,@FIELD_6     VARCHAR(100)      
,@FIELD_11     VARCHAR(100)      
,@START_DT     VARCHAR(10)   = ''      
,@END_DT     VARCHAR(10)   = ''      
,@USER_ID     VARCHAR(50)      
,@MAG_ID     VARCHAR(30)      
,@TITLE      VARCHAR(500)      
,@LAYOUTCODE    VARCHAR(10)      
,@ORDER_EMAIL    VARCHAR(50)   = NULL      
,@HPHONE     VARCHAR(127)  = NULL      
,@REG_SUB_BRANCH   INT           = 0         
,@PARTNERF     TINYINT       = 0      
,@RESERVE_YN    VARCHAR(1)    = 'N'      
,@RESERVE_START_DT   VARCHAR(20)   = NULL      
,@RESERVE_END_DT   VARCHAR(20)   = NULL      
,@CUID      INT      
,@FEDERATIONF    TINYINT       = 0      
,@KINFAF     TINYINT    = 0      
-- 구인상세    
,@SUBWAYF     TINYINT      
,@SEXF      TINYINT      
,@PAYF      TINYINT      
,@PAYFROM     INT      
,@PAYTO      INT      
,@WORKTIMEF     TINYINT      
,@WORKTIMEFROM    INT      
,@WORKTIMETO    INT      
,@HOMEF      TINYINT      
,@PARTTIMEF     TINYINT      
,@PHONEF     TINYINT      
,@EMAILF     TINYINT      
,@EMAIL      VARCHAR(60) = NULL      
,@MOBILEF     TINYINT      
,@MOBILE     VARCHAR(127) = NULL      
,@URLF      TINYINT      
,@URL      VARCHAR(60) = NULL      
,@RECRUIT_END_DT   VARCHAR(10) = ''        
,@PHONE1_VIEWF    TINYINT      
,@PHONE1     VARCHAR(127) = NULL      
,@PHONE2_VIEWF    TINYINT      
,@PHONE2     VARCHAR(127) = NULL      
,@EMAIL_VIEWF    TINYINT      
,@AGEF      TINYINT      
,@AGEFROM     INT      
,@AGETO      INT      
,@AGESUB_JUBU    TINYINT      
,@AGESUB_MIDDLE    TINYINT      
,@AGESUB_MINORITY   TINYINT      
,@MAINBIZ     VARCHAR(100)      
,@EDULEVEL     TINYINT      
,@CAREERF     TINYINT      
,@CAREERFROM    INT      
,@CAREERTO     INT      
,@WORK_MAIN     TINYINT      
,@WORK_SUB     TINYINT      
,@WORK_OUT     TINYINT      
,@PAYTYPE     TINYINT      
,@REGULAREMPF    TINYINT      
,@VISITF     TINYINT      
,@ONLINEF     TINYINT = 0      
,@CI_ZIPID     INT = 0      
,@CI_ADDRDETAIL    VARCHAR(100) = NULL      
,@SERVICE_PERIOD   TINYINT = 100      
,@SUBMIT_DOC    TINYINT = 0      
,@WORK_APPOINT    TINYINT = 0      
,@PAY_POSSIBLE    TINYINT = 0      
,@UPRIGHT_AGREE    TINYINT = 0      
,@WORK_FREELANCER   TINYINT = 0      
,@PAY_COMPANY_RULES   TINYINT = 0      
,@PAY_COMPANY_RULES_ETC  VARCHAR(50) = NULL      
,@FAXF      TINYINT = 1      
,@FAX      VARCHAR(127) = ''      
,@DAY_WEEK     TINYINT = 0      
,@DAY_WEEK_OPTION   INT     = 0      
,@DAY_WEEK_OPTION_ETC  VARCHAR(50) = ''      
,@THEME_ID     INT     = 0      
,@CI_BIZNO     VARCHAR(10) = ''      
,@WORKTIMEDISPLAY   TINYINT = 0        
,@ADDRESS_JIBUN    VARCHAR(200) = ''      
,@ADDRESS_ROAD    VARCHAR(200) = ''      
,@ADDRESS_DETAIL   VARCHAR(200) = ''      
,@ADDRESS_AREA_CODE   INT = 0      
,@DAY_WEEK_OPTION2   INT = 0      
,@RESTTIMEF     TINYINT = 0      
,@REAL_WORKTIME    SMALLINT = 0      
,@REAL_WORKTIMEDISPLAY  TINYINT = 0      
,@CI_ADDRESS_JIBUN   VARCHAR(200) = ''      
,@CI_ADDRESS_ROAD   VARCHAR(200) = ''      
,@WORKTIME_CODE    TINYINT = 0      
,@PAYTO_OVERF    TINYINT = 0      
,@WORK_TAKE_CHARGE   VARCHAR(200) = ''      
,@COMPANY_URL    VARCHAR(250) = ''     
--다중직종    
,@FINDCODE1     INT = 0      
,@FINDCODE2     INT = 0      
,@FINDCODE3     INT = 0      
,@FINDCODE4     INT = 0      
,@FINDCODE5     INT = 0      
,@FINDCODE6     INT = 0      
,@FINDCODE7     INT = 0      
,@FINDCODE8     INT = 0      
,@FINDCODE9     INT = 0      
,@FINDCODE10    INT = 0      
-- 다중 지역    
,@AREA_FULL1    INT       = 0      
,@AREA_FULL2    INT       = 0      
,@AREA_FULL3    INT   = 0        
,@AREA_DETAIL1    VARCHAR(150)      
,@AREA_DETAIL2    VARCHAR(150)      
,@AREA_DETAIL3    VARCHAR(150)      
--자격조건     
,@EC_CHOBO     CHAR(1)      
,@EC_JUBU     CHAR(1)      
,@EC_JANGNYUN    CHAR(1)      
,@EC_JANGAE     CHAR(1)      
,@EC_HUHAK     CHAR(1)      
,@EC_WOIKUK     CHAR(1)      
,@EC_GYOPO     CHAR(1)      
,@EC_SUKSIK     CHAR(1)      
,@EX_SUBWORK    CHAR(1)      
,@EC_DONGJONG    CHAR(1)      
,@EC_ENGLISH    CHAR(1)      
,@EC_CHINESE    CHAR(1)      
,@EC_AUTOLICENSE   CHAR(1)      
,@EC_BIKELICENSE   CHAR(1)      
,@EC_CAROWNER    CHAR(1)      
,@EC_COMPUTER    CHAR(1)      
,@EC_LONGTIME    CHAR(1)      
,@EC_INGUNE     CHAR(1)      
,@EC_ABOUTLICENSE   CHAR(1)      
,@EC_ARMY     CHAR(1)      
,@JOB_BENEFIT    INT = 0  -- 복리후생 추가(2015.05.21)       
,@ADVANTAGE_CD    VARCHAR(200) = ''  -- 지원자 성향 추가(2020.07.21)      
    
-- 지하철    
,@SUBWAY_VALUE1    VARCHAR(170)      
,@SUBWAY_VALUE2    VARCHAR(170)        
,@SUBWAY_VALUE3    VARCHAR(170) = ''      
,@SUBWAY_VALUE4    VARCHAR(170) = ''      
,@SUBWAY_VALUE5    VARCHAR(170) = ''      
-- 인터넷옵션     
,@OPT_CODE     SMALLINT  = 0      
,@OPT_I_PRICE    INT  = 0    
,@OPT_P_PRICE    INT  = 0    
,@OPT_START_DT    VARCHAR(10) = null     
,@OPT_END_DT    VARCHAR(10) = null     
,@MOBILE_OPT_CODE   SMALLINT  = 0        
,@ICON_OPT     SMALLINT  = 0      
,@DISPLAY_OPT    INT       = 0      
,@COMBINE_OPT    SMALLINT  = 0         
-- 로고    
,@LOGO_IMAGE    VARCHAR(200)      
,@LOGO_IMAGE_BYTE   INT           = 0      
--상세내용 및 이미지    
,@EX_CONTENTS    TEXT      
,@EX_IMAGE_1    VARCHAR(200) = ''      
,@EX_IMAGE_2    VARCHAR(200) = ''      
,@EX_IMAGE_3    VARCHAR(200) = ''      
,@EX_IMAGE_4    VARCHAR(200) = ''      
,@MAP_X      INT      
,@MAP_Y      INT           
,@GMAP_X     VARCHAR(25)      
,@GMAP_Y     VARCHAR(25)        
,@RV_PANOID     INT = NULL      
,@RV_ANGLEID    VARCHAR(25) = NULL      
,@MAP_VIEW_YN    CHAR(1) -- 지도 노출 여부 2020-07-22      
-- 임시저장정보    
,@TEMPSAVEID       INT      
-- 템플릿 정보    
,@TEMPLATE_IDX    INT     
,@TEMPLATE_IMAGE_IDX  INT    
,@COMMENT1     VARCHAR(4000)     
,@COMMENT2     VARCHAR(4000)    
,@COMMENT3     VARCHAR(4000)    
,@TEMPLATE_TITLE   VARCHAR(4000)    
,@HTML_FLAG   CHAR(1)    
,@SENIORTVF   TINYINT       = 0    
,@PCYN  CHAR(1) = ''    
,@OUTF   TINYINT = NULL -- 외근직 추가
,@KEYWORD_LIST NVARCHAR(MAX) = '' --키워드 리스트
,@KEYWORD_TERM TINYINT = 0 --키워드 일수
AS    
BEGIN    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
 SET NOCOUNT ON    
      
 DECLARE @OUTPUT_LINEADID INT = 0    
 DECLARE @RESULT    TINYINT = 0    
 DECLARE @RESULT_C   TINYINT = 0    
 DECLARE @EDIT  INT = 0  
 DECLARE @EDIT_TEXT   CHAR(20)      
 DECLARE @LINEADNO   char(16)    
 DECLARE @COMMENT  VARCHAR(200) = ''  
 DECLARE @MOD_COUNT INT =0

  
 SET @OUTPUT_LINEADID = 0    
  
 IF @SERVICE_PERIOD  = NULL  
 BEGIN  
  SET @SERVICE_PERIOD = 100    
 END
  
 BEGIN TRANSACTION    

 IF @TITLE = '' OR @TITLE IS NULL OR @FIELD_6 = '' OR @FIELD_6 IS NULL OR @START_DT = '' OR @START_DT IS NULL OR @PHONE = '' OR @PHONE IS NULL
 BEGIN
   RAISERROR('필수 값 입력 오류', 16, 1)  
   ROLLBACK   
   RETURN -1
 END
   
 -- 기본정보     
 IF ISNULL(@LINEADID, 0) = 0    
 BEGIN    
  SET @LINEADID = 0    
  SET @EDIT = 0  
  SET @EDIT_TEXT = '신규 공고 등록'  
  EXEC [DBO].[PUT_CM_JOB_CY_LINEAD_PROC] @LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH,@FINDCODE, 1400001, 14  , @AREA_A , @AREA_B , @AREA_C , @AREA_DETAIL 
  , @ORDER_NAME , @PHONE , @FIELD_3 , @FIELD_6 , @FIELD_11 , @START_DT , @END_DT , @USER_ID , @MAG_ID , @TITLE , @LAYOUTCODE , @ORDER_EMAIL , @HPHONE 
  , @OUTPUT_LINEADID Output, @REG_SUB_BRANCH , @PARTNERF , @RESERVE_YN , @RESERVE_START_DT , @RESERVE_END_DT , @CUID , @FEDERATIONF , @KINFAF,@SENIORTVF      
  IF @@ERROR <> 0    
  BEGIN  
   RAISERROR('신규 기본정보 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END  
  
  SET @LINEADID = @OUTPUT_LINEADID    
 END    
 ELSE    
 BEGIN    
 
 BEGIN /** 공고내용의 제목 OR 회사명 수정시 [관리자] 로고관리 검수상태를 업데이트(검수완료->재수정) 한다 **/
   
  SELECT @MOD_COUNT = COUNT(PP_AD.LINEADID) FROM PP_AD_TB AS PP_AD  
  INNER JOIN PP_LOGO_OPTION_TB AS PP_LOGO  
  ON PP_AD.LINEADID = PP_LOGO.LINEADID  
  WHERE PP_AD.LINEADID = @LINEADID  AND PP_AD.INPUT_BRANCH = @INPUT_BRANCH AND PP_AD.LAYOUT_BRANCH = @LAYOUT_BRANCH
  AND (PP_AD.TITLE <> @TITLE  
  OR PP_AD.FIELD_6 <> @FIELD_6  
  OR PP_LOGO.PUB_LOGO <> PP_LOGO.WAIT_LOGO  ) 
   
 END /** 로고관리 검수상태를 업데이트 **/

  SET @EDIT = 1  
  SET @EDIT_TEXT = '수정'  
  EXEC [DBO].[EDIT_F_JOB_AD_PROC] @LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH,@FINDCODE, 1400001, 14  , @AREA_A , @AREA_B , @AREA_C , @AREA_DETAIL 
  , @ORDER_NAME , @PHONE , @FIELD_3 , @FIELD_6 , @FIELD_11 , @START_DT , @END_DT , @USER_ID , @MAG_ID , @TITLE , @LAYOUTCODE , @ORDER_EMAIL , @HPHONE 
  ,'', @OUTPUT_LINEADID Output, @PARTNERF, @CUID , @RESERVE_YN , @RESERVE_START_DT , @FEDERATIONF , @KINFAF ,@SENIORTVF     
  IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('수정 기본정보 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END  
 ELSE
 BEGIN /** 공고내용의 제목 OR 회사명 수정시 [관리자] 로고관리 검수상태를 업데이트(검수완료->재수정) 한다 **/
  IF @MOD_COUNT > 0 
    BEGIN
    IF dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y'
      BEGIN
       EXEC [DBO].[EDIT_M_PP_LOGO_OPTION_TB_WAIT_PROC] @LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH ,'R'
      END
    ELSE
      BEGIN
       EXEC [DBO].[EDIT_M_PP_LOGO_OPTION_TB_COMFIRM_PROC] @LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH,@LOGO_IMAGE,'',@LOGO_IMAGE_BYTE,''
      END
  
  END
 END /** 로고관리 검수상태를 업데이트 **/
END    
    
 SET @LINEADNO = dbo.FN_LINEADNO(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH)      
    
 IF @@ERROR = 0    
 BEGIN    
 -- 상세정보    
  SET @PAYFROM = @PAYTO  
  EXEC [DBO].[PUT_CM_JOB_EXTEND_DETAIL_JOB_PROC] @LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH,@SUBWAYF,0,@SEXF,@PAYF,@PAYFROM,@PAYTO,@WORKTIMEF,@WORKTIMEFROM,@WORKTIMETO
  ,@HOMEF,@PARTTIMEF,0,@PHONEF,@PHONE,@EMAILF,@EMAIL,@MOBILEF,@MOBILE,@URLF,@URL,@RECRUIT_END_DT,'L', @PHONE1_VIEWF,@PHONE1,@PHONE2_VIEWF,@PHONE2,@EMAIL_VIEWF
  ,@AGEF,@AGEFROM,@AGETO,@AGESUB_JUBU,@AGESUB_MIDDLE,@AGESUB_MINORITY,@MAINBIZ,@EDULEVEL,@CAREERF,@CAREERFROM,@CAREERTO,@WORK_MAIN,@WORK_SUB,@WORK_OUT,@PAYTYPE
  ,@REGULAREMPF,@VISITF,@ONLINEF,@CI_ZIPID,@CI_ADDRDETAIL, @SERVICE_PERIOD,@SUBMIT_DOC,@WORK_APPOINT,@PAY_POSSIBLE,@UPRIGHT_AGREE,@WORK_FREELANCER
  ,@PAY_COMPANY_RULES,@PAY_COMPANY_RULES_ETC,@FAXF,@FAX,@DAY_WEEK,@DAY_WEEK_OPTION,@DAY_WEEK_OPTION_ETC,@THEME_ID,@CI_BIZNO ,@WORKTIMEDISPLAY
  ,@ADDRESS_JIBUN,@ADDRESS_ROAD,@ADDRESS_DETAIL,@ADDRESS_AREA_CODE,@DAY_WEEK_OPTION2,@RESTTIMEF,@REAL_WORKTIME,@REAL_WORKTIMEDISPLAY,@CI_ADDRESS_JIBUN,@CI_ADDRESS_ROAD
  ,@WORKTIME_CODE,@PAYTO_OVERF,@WORK_TAKE_CHARGE,@COMPANY_URL,@MAP_VIEW_YN,@EX_CONTENTS
  -- 외근직 추가
  ,@OUTF
  IF @@ERROR <> 0    
  BEGIN  
   RAISERROR('상세정보 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END  
    
 END   
  
    
 IF @@ERROR = 0    
 BEGIN    
 -- 다중직종    
  EXEC [DBO].[PUT_CM_MULTI_FINDCODE_PROC] @LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH,@FINDCODE1,@FINDCODE2,@FINDCODE3,@FINDCODE4,@FINDCODE5,@FINDCODE6,@FINDCODE7,@FINDCODE8,@FINDCODE9,@FINDCODE10, 'L'    
    IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('다중직종 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END  
 END    
    
 IF @@ERROR = 0    
 BEGIN    
 -- 다중 지역    
  EXEC [DBO].[PUT_CM_MULTI_AREA_PROC] @LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH,@AREA_FULL1,@AREA_FULL2,@AREA_FULL3,@AREA_DETAIL1,@AREA_DETAIL2,@AREA_DETAIL3,'L',@RESULT Output    
   IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('다중지역 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END  
 END    
     
 IF @@ERROR = 0    
 BEGIN    
 -- 자격조건    
  EXEC [DBO].[PUT_CM_JOB_EC_DATA_PROC] @LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH,@EC_CHOBO,@EC_JUBU,@EC_JANGNYUN,@EC_JANGAE,@EC_HUHAK,@EC_WOIKUK,@EC_GYOPO,@EC_SUKSIK,@EX_SUBWORK,@EC_DONGJONG,@EC_ENGLISH,@EC_CHINESE,@EC_AUTOLICENSE,@EC_BIKELICENSE,@EC_CAROWNER,@EC_COMPUTER,@EC_LONGTIME,@EC_INGUNE,@EC_ABOUTLICENSE,@EC_ARMY,'L',@JOB_BENEFIT    
   IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('자격조건 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END  
 END    
    
 IF @@ERROR = 0     
 BEGIN    
  IF ISNULL(@SUBWAY_VALUE1, '') <> ''    
  BEGIN    
 -- 지하철     
  EXEC [DBO].[PUT_CM_JOB_SUBWAY_DATA_PROC] @LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH,@SUBWAY_VALUE1,@SUBWAY_VALUE2,'L',@SUBWAY_VALUE3,@SUBWAY_VALUE4,@SUBWAY_VALUE5     
   IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('지하철 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END   
  END    
 END    
    
 IF @@ERROR = 0 AND @EDIT = 0 -- 신규 공고 일때  
 BEGIN    
 -- 인터넷옵션      
  EXEC [DBO].[PUT_CM_JOB_INTERNET_OPTION_PROC] @LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH,@OPT_CODE,3,4,@OPT_I_PRICE,@OPT_P_PRICE,'',@OPT_START_DT,@OPT_END_DT,@MOBILE_OPT_CODE,'L',0,@ICON_OPT,@DISPLAY_OPT,'','','','','',@COMBINE_OPT,'','',0,0,0,0,'',''    
    IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('인터넷옵션 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END   
 END   
   
   
 -- 수정, 예약기간 변경 발생 - 상품 기간 수정  
 IF @@ERROR = 0 AND @EDIT = 1 AND @RESERVE_YN = 'Y' AND (@OPT_CODE > 0 OR @MOBILE_OPT_CODE > 0)   
 BEGIN    
 -- 인터넷옵션  기간 수정   
  EXEC [DBO].[PUT_CM_JOB_UPDATE_OPTION_PROC] @LINEADNO, @OPT_START_DT  
    IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('인터넷옵션 기간 수정 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END   
 END   
   
     
 IF @@ERROR = 0    
 BEGIN    
 -- 로고    
  EXEC [DBO].[PUT_CM_PP_LOGO_WAIT_PROC] @LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH,@LOGO_IMAGE,'',@LOGO_IMAGE_BYTE,0,0,0    
    IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('로고 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END  
 END    
 -- 상세내용 및 이미지    
 IF @@ERROR = 0    
 BEGIN    
  EXEC [DBO].[PUT_CM_JOB_EXTEND_DETAIL_PROC] @LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH,@EX_CONTENTS,@EX_IMAGE_1,@EX_IMAGE_2,@EX_IMAGE_3,@EX_IMAGE_4,@MAP_X,@MAP_Y,'1',@GMAP_X,@GMAP_Y,@HTML_FLAG,'L',@RV_PANOID,@RV_ANGLEID,@MAP_VIEW_YN    
    IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('상세이미지 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END  
 END    
  
 -- 템플릿     
 IF @@ERROR = 0 AND ISNULL(@TEMPLATE_IDX, '') = '' AND @EDIT = 1  
 BEGIN  
 DELETE FROM [dbo].[PP_JOB_AD_TEMPLATE_TB] WHERE [LINEADNO] = @LINEADNO  
 END  
  
  
 IF @@ERROR = 0 AND ISNULL(@TEMPLATE_IDX, '') <> ''    
 BEGIN        
   EXEC [DBO].[PUT_PP_JOB_AD_TEMPLATE_TB_PROC] @LINEADNO, @TEMPLATE_IDX, @TEMPLATE_IMAGE_IDX,@COMMENT1,@COMMENT2,@COMMENT3,@TEMPLATE_TITLE    
  IF @@ERROR <> 0   
   BEGIN  
    RAISERROR('템플릿 입력 오류', 16, 1)  
    ROLLBACK    
    RETURN -1  
   END  
 END   
 -- 성격및 강점    
 IF @@ERROR = 0    
 BEGIN    
  --IF ISNULL(@ADVANTAGE_CD, '') <> ''    
  --BEGIN    
   EXEC [dbo].PUT_M_PP_JOB_ADVANTAGE_TB_PROC @LINEADID, @ADVANTAGE_CD     
     IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('성격 및 강점 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  --END    
  END    
 END  

 --키워드검색상품
 IF @@ERROR = 0 AND @EDIT = 0 -- 신규 공고 일때
 BEGIN
 EXEC dbo.PUT_M_PP_JOB_KEYWORDSEARCH_TB_PROC 0, NULL, @KEYWORD_LIST, @KEYWORD_TERM, @LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH, @CUID, null, null, 'E', 'Y',null,null,null,null,null,null,null,null,@OPT_CODE
 IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('키워드검색상품 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END    
 END
  
   
 --IF @@ERROR = 0  AND @EDIT = 1  
 --BEGIN    
 ---- 임시저장 정보 갱신    
 -- EXEC [DBO].[p_SyncIssueData] @LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH, 'L','E'    
 --   IF @@ERROR <> 0   
 -- BEGIN  
 --  RAISERROR('정보갱신 입력 오류', 16, 1)  
 --  ROLLBACK    
 --  RETURN -1  
 -- END  
 --END   
    
 IF @@ERROR = 0    
 BEGIN    
 -- 임시저장 정보 갱신    
  EXEC [DBO].[EDIT_F_JOB_TEMPSAVE_LINEADNO_PROC] @TEMPSAVEID, @CUID, @LINEADNO    
    IF @@ERROR <> 0   
  BEGIN  
   RAISERROR('임시저장 정보갱신 입력 오류', 16, 1)  
   ROLLBACK    
   RETURN -1  
  END  
 END   
   
  
 -- 공고관리 로그  
 IF @@ERROR = 0   
 BEGIN  
  IF @PCYN = 'Y'  
   BEGIN  
    SET @COMMENT = CONCAT('회원(', @USER_ID,')이 PC에서 직접 ', @EDIT_TEXT)  
   END  
  ELSE  
   BEGIN  
    SET @COMMENT = CONCAT('회원(', @USER_ID , '(', CAST(@CUID AS VARCHAR), '))이 모바일에서 직접 ', @EDIT_TEXT)  
   END  
   
  
  EXEC [DBO].[PUT_M_MAG_HISTORY_PROC] @LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH, 'front', @COMMENT  
  IF @@ERROR <> 0  ROLLBACK  
 END  
    
 IF @@ERROR = 0    
 BEGIN    
  COMMIT     
  SELECT @LINEADNO AS LINEADNO, @@ERROR AS PAYMENTSTATUS    
 END    
 ELSE    
 BEGIN    
  ROLLBACK    
 END    
     
    
END    
    
    
    


  
