USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[_SP_LOGIN_20211005]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************      
 *  단위 업무 명 : 로그인 및 이력      
 *  작   성   자 : J&J      
 *  작   성   일 : 2016-07-25      
 *  수   정   자 : 배진용      
 *  수   정   일 : 2020-10-27      
 *  수   정   자 : 안대희*
 *  수   정   일 : 2021-05-24
 *  설        명 :       
 * RETURN(500) -- 휴면 고객      
 * RETURN(400) -- 사용자가 없음      
 * RETURN(300) -- 복수의 아이디      
 * RETURN(200) -- 비밀 번호 틀림      
 * RETURN(0) -- 정상 정상      
  DECLARE @RET INT      
  EXEC @RET=SP_LOGIN 'mwmobile01','11111111' , 'S101' ,'IP','HOST'      
  SELECT @RET  -- 성공      
  declare @DUPLICATE_YN INT       
    EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160      
 SELECT @DUPLICATE_YN      
      
  * 2020-10-27 -> 회원가입대행 여부 컬럼 추가 AGENCY_YN : 회원가입대행 여부,  LAST_SIGNUP_YN : 회원가입대행 최종 가입 여부      
  * 2021-05-24: 회원가입대행 컬럼 추가      
  C.MEMBER_TYPE, -- 회원타입(CST_COMPANY)    
  CL.REG_NUMBER  -- 등록번호(CST_COMPANY_LAND)    
 *************************************************************************************/      
CREATE PROCEDURE [dbo].[_SP_LOGIN_20211005]      
@USERID VARCHAR(50)       
,@PWD VARCHAR(30)      
,@SECTION_CD CHAR(4)      
,@IP VARCHAR(15)      
,@HOST VARCHAR(50)      
AS      
 SET NOCOUNT ON;      
 DECLARE        
  @CUID INT      
  ,@USER_NM varchar(30)      
  ,@EMAIL varchar(50)      
  ,@HPHONE varchar(14)      
  ,@MEMBER_CD CHAR(1)      
  ,@GENDER CHAR(1)      
  ,@REST_YN CHAR(1)      
  ,@BIRTH varchar(8)      
  ,@COM_NM varchar(50)      
  ,@CONFIRM_YN CHAR(1)      
  ,@PWD_NEXT_ALARM_DT DATETIME      
  ,@SITE_CD CHAR(1)      
  ,@TRUE_YN CHAR(1)      
  ,@PWD_CHANGE_YN CHAR(1)      
  ,@COUNT INT      
  ,@DUPLICATE_YN  INT = 0       
  ,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인      
  ,@BAD_YN  CHAR(1)      
  ,@DI  CHAR(64)      
  ,@ISADULT  CHAR(1)      
  ,@JOIN_DT VARCHAR(10)      
  ,@REALHP_YN CHAR(1)      
  ,@ROWCOUNT INT      
  ,@LAND_CLASS_CD VARCHAR(30)      
  ,@REST_DT VARCHAR(10)      
  -- 2020-10-27 회원가입대행 컬럼 추가      
  ,@AGENCY_YN   CHAR(1) -- 회원가입대행 여부      
  ,@LAST_SIGNUP_YN CHAR(1) -- 회원가입대행 최종 가입 여부      
  ,@REGISTER_NO VARCHAR(30) -- 사업자번호    
  -- 2021-05-24 회원가입대행 > 공인중계사 - 등록번호컬럼 추가      
  ,@MEMBER_TYPE TINYINT -- 회원타입(CST_COMPANY)    
  ,@REG_NUMBER VARCHAR(50) -- 등록번호(CST_COMPANY_LAND)    
  SELECT      
   @COUNT = AA.ROW,      
   @CUID = AA.CUID,      
   @USER_NM = ISNULL(AA.USER_NM,''),      
   @EMAIL = ISNULL(AA.EMAIL,''),      
   @HPHONE = ISNULL(AA.HPHONE,''),      
   @GENDER = AA.GENDER,      
   @REST_YN = AA.REST_YN,      
   @BIRTH = AA.BIRTH,      
   @COM_NM = ISNULL(AA.COM_NM,''),      
   @CONFIRM_YN = AA.CONFIRM_YN,      
   @PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,      
   @SITE_CD = AA.SITE_CD,      
   @MEMBER_CD = AA.MEMBER_CD,      
   @TRUE_YN = AA.TRUE_YN,      
   @BAD_YN = AA.BAD_YN,      
   @DI = AA.DI,      
   @USERID = AA.USERID,      
   @ISADULT = AA.ADULT_YN,      
   @JOIN_DT = AA.JOIN_DT,      
   @REALHP_YN = AA.REALHP_YN,      
   @LAND_CLASS_CD = AA.LAND_CLASS_CD,      
   @REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END),      
   -- 2020-10-27 회원가입대행 컬럼 추가      
   @AGENCY_YN   = AA.AGENCY_YN,      
   @LAST_SIGNUP_YN  = AA.LAST_SIGNUP_YN,      
   @REGISTER_NO = AA.REGISTER_NO,    
   @MEMBER_TYPE = ISNULL(AA.MEMBER_TYPE, 1),    
   @REG_NUMBER  = ISNULL(AA.REG_NUMBER, '')    
   FROM       
   (      
   SELECT      
   ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,      
   M.CUID,      
   M.USER_NM,      
   M.EMAIL,      
   M.HPHONE,      
   M.GENDER,      
   M.REST_YN,      
   M.BIRTH,      
   C.COM_NM,      
   M.CONFIRM_YN,      
   M.MASTER_ID,      
   M.STATUS_CD,      
   M.PWD_NEXT_ALARM_DT,      
   M.SITE_CD,      
   M.MEMBER_CD,      
   'Y' AS TRUE_YN,      
   M.BAD_YN,      
   M.DI,      
   M.USERID,      
   ISNULL(M.ADULT_YN,'N') AS ADULT_YN,      
   CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,      
   ISNULL(REALHP_YN,'N') AS REALHP_YN,      
   CL.LAND_CLASS_CD,      
   M.REST_DT,      
   -- 2020-10-27 회원가입대행 컬럼 추가      
   ISNULL(M.AGENCY_YN,'N') AS AGENCY_YN,      
   M.LAST_SIGNUP_YN,      
   C.REGISTER_NO,    
   -- 2021-05-24 회원가입대행 컬럼 추가      
   C.MEMBER_TYPE, -- 회원타입(CST_COMPANY)    
   CL.REG_NUMBER  -- 등록번호(CST_COMPANY_LAND)    
  FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID      
    LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID      
  WHERE M.OUT_YN='N'      
    AND M.USERID = @USERID       
   AND  pwd_sha2 = master.DBO.fnGetStringToSha256(dbo.FN_MD5(LOWER(@PWD)))      
   AND (M.STATUS_CD <> 'D' OR M.STATUS_CD IS NULL) --2018.01.26 추가      
  ) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL      
   /* NULL : 통합 전    로그인 가능      
   W : 통합 승인대기중  로그인 가능      
   A : 통합 후 마스터계정   로그인 가능      
   D : 통합 후 서브계정  로그인 불가능      
   */         
  -- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음      
  set @ROWCOUNT = @@ROWCOUNT      
        
        
  IF @ROWCOUNT = 0       
  BEGIN      
   IF EXISTS(SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @USERID)       
   BEGIN      
   INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES      
           (@CUID ,@USERID, getdate(), @SECTION_CD,'N', @IP, @HOST)      
         
   RETURN(200) -- 비밀 번호 틀림      
   END      
  END       
  ELSE IF @ROWCOUNT <> 2       
  BEGIN       
   /* 2순위 계정 체크 시작 {계정 변환 로직으로 ~!!! 300 }*/      
   EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC @CUID      
   IF @DUPLICATE_YN = 1      
   BEGIN      
    SET @COUNT = 3      
   END      
   /* 2순위 계정 체크  끝*/      
  END       
        
  IF @REST_YN = 'Y' AND @ROWCOUNT <> 2  -- 중복회원 체크가 우선       
  BEGIN      
   RETURN(500) -- 휴면 고객      
  END ELSE IF @CUID IS NULL      
  BEGIN      
   INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES      
           (@CUID,@USERID,getdate(),@SECTION_CD,'N', @IP, 'ERR')    -- 로그인 이력 남기기      
        
   RETURN(400) -- 사용자가 없음      
  END ELSE IF @COUNT > 1       
  BEGIN       
   IF @COUNT = 3       
   BEGIN      
     SELECT       
    @CUID AS CUID,      
    @USER_NM AS USER_NM,      
    @EMAIL AS EMAIL,      
    @HPHONE AS HPHONE,      
    ISNULL(@GENDER,'') AS GENDER,      
    @REST_YN AS REST_YN,      
    ISNULL(@BIRTH,'') AS BIRTH,      
    @COM_NM AS COM_NM,      
    @CONFIRM_YN AS CONFIRM_YN,      
    --@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,      
    @SITE_CD AS SITE_CD,      
    @MEMBER_CD AS MEMBER_CD,      
    'N' AS TRUE_YN,      
    @PWD_CHANGE_YN AS PWD_CHANGE_YN,      
    @DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임      
    @USERID AS USERID,      
    @BAD_YN AS BAD_YN,      
    ISNULL(@DI,'') AS DI,      
    ISNULL(@ISADULT,'') AS ISADULT,      
    '' AS SNSTYPE,      
    @JOIN_DT AS JOIN_DT,      
    ISNULL(@REALHP_YN,'') as REALHP_YN,      
    @PWD AS PWD,      
    DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,      
    @USER_NM AS USERNAME,      
    '' AS SECTION_CD,      
    ISNULL(@LAND_CLASS_CD,'') AS LAND_CLASS_CD,      
    @REST_DT AS REST_DT,      
    -- 2020-10-27 회원가입대행 컬럼 추가      
    @AGENCY_YN AS AGENCY_YN,      
    @LAST_SIGNUP_YN AS LAST_SIGNUP_YN,      
    @REGISTER_NO AS REGISTER_NO,    
    @MEMBER_TYPE AS MEMBER_TYPE,    
    @REG_NUMBER  AS REG_NUMBER    
    RETURN(300) -- 2순위 아이디      
   END      
   ELSE      
   BEGIN -- @COUNT = 2      
    RETURN(900) -- 복수의 아이디(아이디/비번 중복됨)      
   END      
  END ELSE IF @COUNT = 1      
  BEGIN       
   SET @PWD_CHANGE_YN = 'N'      
   IF @PWD_NEXT_ALARM_DT < GETDATE() SET @PWD_CHANGE_YN = 'Y'      
      
   /*전화번호 중복 alert 확인용*/      
   IF @MEMBER_CD  = 1  AND ISNULL(@REALHP_YN,'N') <> 'Y'      
   BEGIN      
    SELECT @DUPLICATE_PHONE = COUNT(*)       
    FROM CST_MASTER WITH(NOLOCK)       
    where HPHONE = @HPHONE and MEMBER_CD = 1       
      
    IF @DUPLICATE_PHONE  > 1       
    BEGIN      
     SET @REALHP_YN ='N'      
     SET @DUPLICATE_PHONE = 1      
    END       
    ELSE BEGIN      
     SET @REALHP_YN ='Y'      
     SET @DUPLICATE_PHONE = 0      
    END      
      
   END      
   ELSE       
   BEGIN      
    SET @REALHP_YN = 'Y'      
   END      
         
   /* 순서 변경하지 마세요. 뒷부분에 추가 */      
   SELECT      
    -- @COUNT AS ROW,         
    @CUID AS CUID,      
    @USER_NM AS USER_NM,      
    @EMAIL AS EMAIL,      
    @HPHONE AS HPHONE,      
    ISNULL(@GENDER,'') AS GENDER,      
    @REST_YN AS REST_YN,      
    ISNULL(@BIRTH,'') AS BIRTH,      
    @COM_NM AS COM_NM,      
    @CONFIRM_YN AS CONFIRM_YN,      
    --@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,      
    @SITE_CD AS SITE_CD,      
    @MEMBER_CD AS MEMBER_CD,      
    @TRUE_YN AS TRUE_YN,      
    @PWD_CHANGE_YN AS PWD_CHANGE_YN,      
    @DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임      
    @USERID AS USERID,      
    @BAD_YN AS BAD_YN,      
    ISNULL(@DI,'') AS DI,      
    ISNULL(@ISADULT,'') AS ISADULT,      
    '' AS SNSTYPE,      
    @JOIN_DT AS JOIN_DT,      
    ISNULL(@REALHP_YN,'') as REALHP_YN,      
    @PWD AS PWD,      
    DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,      
    @USER_NM AS USERNAME,      
    '' AS SECTION_CD,      
    ISNULL(@LAND_CLASS_CD,'') AS LAND_CLASS_CD,      
    @REST_DT AS REST_DT,      
          -- 2020-10-27 회원가입대행 컬럼 추가      
    @AGENCY_YN AS AGENCY_YN,      
    @LAST_SIGNUP_YN AS LAST_SIGNUP_YN,   
    @REGISTER_NO AS REGISTER_NO,    
    -- 2021-05-24 회원가입대행 컬럼 추가  
    @MEMBER_TYPE AS MEMBER_TYPE,    
    @REG_NUMBER  AS REG_NUMBER    
      
    UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()      
      WHERE CUID = @CUID     -- 마지막 로그인 시간       
            
    INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES      
           (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기      
                 
   RETURN(0) -- 정상 정상      
  END 
GO
