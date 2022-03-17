    
/*************************************************************************************    
 *  단위 업무 명 : 구인 > 구인광고관리 > 상세화면 > 입사 지원 내역 등록    
 *  작   성   자 : 김 성 준    
 *  작   성   일 : 2013/11/15    
 *  수   정   자 : 김선호       
 *  수   정   일 : 2021/08/27      
 *  설        명 : 로그인한경우에 테이블에 CUID 파라미터 및 컬럼 추가, 비로그인인경우 CUID: 0    
 *  주 의  사 항 :    
 *  사 용  소 스 :    
 *  사 용  예 제 : EXEC DBO.PUT_F_PG_APP_MAIN_TB_PROC    
    
 exec PUT_F_PG_APP_MAIN_TB_PROC 46733,1010116,180,180,1,'N','Y','stari@mediawill.com','010-3393-1420','1,2,3,4','찐짜 열심히 일하겠습니다.',NULL,NULL,'cowto76','Y','online',10504169,'별나라 공이','이근우'    
    
    
 exec PUT_F_PG_APP_MAIN_TB_PROC 46733,1010116,180,180,2,'N','Y','stari@mediawill.com','010-3393-1420','1,2,3,4','찐짜 열심히 일하겠습니다.',NULL,NULL,'cowto76','Y','email',10504169,'이근우','별나라 공이','010-3393-1420'    
 *************************************************************************************/    
    
ALTER PROC [dbo].[PUT_F_PG_APP_MAIN_TB_PROC]    
    
 @RESUME_ID INT,    
 @LINEADID INT,    
 @INPUT_BRANCH TINYINT,    
 @LAYOUT_BRANCH TINYINT,    
 @APP_TYPE TINYINT,    
 @OPEN_YN CHAR(1),    
 @APP_STATUS CHAR(1),    
 @EMAIL VARCHAR(256) = NULL,    
 @TEL VARCHAR(16) = NULL,    
 @CONTACT_TYPE VARCHAR(7),    
 @APP_TITLE VARCHAR(80),    
 @APP_CONTENTS VARCHAR(200),    
 @APP_SMS_CONTENTS VARCHAR(1000),    
 @USER_ID VARCHAR(50),    
 @APP_QUICK CHAR(1) = NULL,    
 @APP_GBN VARCHAR(10) = NULL,    
 @CUID INT,    
  @USER_NM VARCHAR(50) = NULL,    
  @COM_NM VARCHAR(50) = NULL,    
  @COM_HPHONE VARCHAR(16) = NULL,    
  @SECTION_CD VARCHAR(10) = 'S102',    
  @PERSON_AGREE_Y VARCHAR(1) = NULL    
AS    
BEGIN    
    
  SET NOCOUNT ON    
    
  DECLARE @APP_TYPE_ONLINE INT = 0    
  DECLARE @APP_TYPE_EMAIL INT = 0    
  DECLARE @APP_TYPE_SMS INT = 0    
  DECLARE @FLAG CHAR(1) = 'N'    
  DECLARE @RESUME_CNT INT = 0  
    
  -- UNIQUEKEY(LINEADNO) 생성    
  DECLARE @LINEADNO CHAR(16)    
  SET @LINEADNO = dbo.FN_LINEADNO(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH)    
    
    
  SELECT @APP_TYPE_ONLINE = COUNT(*)    
    FROM PG_APP_MAIN_TB    
   WHERE LINEADNO = @LINEADNO    
     AND RESUME_ID = @RESUME_ID    
     AND APP_TYPE = 1    
     AND APP_STATUS = 'Y'    
    
  SELECT @APP_TYPE_EMAIL = COUNT(*)    
    FROM PG_APP_MAIN_TB    
   WHERE LINEADNO = @LINEADNO    
     AND RESUME_ID = @RESUME_ID    
     AND APP_TYPE = 2    
     AND APP_STATUS = 'Y'    
    
  SELECT @APP_TYPE_SMS = COUNT(*)    
    FROM PG_APP_MAIN_TB    
   WHERE LINEADNO = @LINEADNO    
     AND RESUME_ID = @RESUME_ID    
     AND APP_TYPE = 3    
     AND APP_STATUS = 'Y'    
    
  SET @FLAG = 'N'    
  IF (@APP_TYPE_ONLINE = 0 AND @APP_TYPE_EMAIL = 0 AND @APP_TYPE_SMS = 0)    
    SET @FLAG = 'Y'    
  ELSE IF (@APP_TYPE_ONLINE > 0 AND @APP_TYPE_EMAIL = 0 AND @APP_TYPE_SMS = 0) AND (@APP_TYPE = 3)    
    SET @FLAG = 'Y'    
  ELSE IF (@APP_TYPE_ONLINE = 0 AND @APP_TYPE_EMAIL > 0 AND @APP_TYPE_SMS = 0) AND (@APP_TYPE = 3)    
    SET @FLAG = 'Y'    
  ELSE IF (@APP_TYPE_ONLINE = 0 AND @APP_TYPE_EMAIL = 0 AND @APP_TYPE_SMS > 0) AND (@APP_TYPE != 3)    
    SET @FLAG = 'Y'    
    
  SELECT @RESUME_CNT = COUNT(*)   
  FROM PG_RESUME_MAIN_TB WITH(NOLOCK)  
  WHERE CUID = @CUID  
  AND RESUME_ID = @RESUME_ID    
  AND DEL_YN = 'N'  

  -- 알림톡 템플릿 변경(추가 : 제목,대표번호,업직종,근무시간,근무지위치,급여)
  DECLARE @TITLE VARCHAR(500) --제목
  DECLARE @PHONE VARCHAR(100) --대표번호
  DECLARE @CODE_NAME VARCHAR(100) --업직종
  DECLARE @WORK_TIME_FROM VARCHAR(50) --근무 시작 시간
  DECLARE @WORK_TIME_TO VARCHAR(50) --근무 종료 시간
  DECLARE @WORK_AREA VARCHAR(100) --근무지
  DECLARE @PAYF VARCHAR(10) --급여종류
  DECLARE @PAYFROM VARCHAR(100) --급여

  SELECT 
     @TITLE= A.TITLE -- 제목
    ,@PHONE= CASE WHEN CHARINDEX(',',A.PHONE) > 0 THEN SUBSTRING(A.PHONE,1,CHARINDEX(',',A.PHONE)-1) ELSE A.PHONE END
    ,@CODE_NAME=  C.CodeNm3 +' > '+C.CodeNm4 -- 업직종
    ,@WORK_TIME_FROM= CASE WHEN LEN(D.WORKTIMEFROM) = 4 THEN REPLACE(D.WORKTIMEFROM,LEFT(D.WORKTIMEFROM,2),LEFT(D.WORKTIMEFROM,2)+':')
       WHEN LEN(D.WORKTIMEFROM) = 3 THEN REPLACE(D.WORKTIMEFROM,LEFT(D.WORKTIMEFROM,1),'0'+LEFT(D.WORKTIMEFROM,1)+':')
       WHEN LEN(D.WORKTIMEFROM) = 2 THEN REPLACE(D.WORKTIMEFROM,D.WORKTIMEFROM,'00:'+RIGHT(D.WORKTIMEFROM,2))
       ELSE '00:00' END -- 근무 시작 시간
    ,@WORK_TIME_TO= CASE WHEN LEN(D.WORKTIMETO) = 4 THEN REPLACE(D.WORKTIMETO,LEFT(D.WORKTIMETO,2),LEFT(D.WORKTIMETO,2)+':')
       WHEN LEN(D.WORKTIMETO) = 3 THEN REPLACE(D.WORKTIMETO,LEFT(D.WORKTIMETO,1),'0'+LEFT(D.WORKTIMETO,1)+':')
       WHEN LEN(D.WORKTIMETO) = 2 THEN REPLACE(D.WORKTIMETO,D.WORKTIMETO,'00:'+RIGHT(D.WORKTIMETO,2))
       ELSE '00:00' END -- 근무 종료 시간
    ,@WORK_AREA= AREA_A+' '+AREA_B+' '+AREA_C+' '+AREA_DETAIL --근무지
    ,@PAYF= CASE WHEN D.PAYF ='1' THEN '연봉'
       WHEN D.PAYF ='2' THEN '월급'
       WHEN D.PAYF ='3' THEN '일급'
       WHEN D.PAYF ='4' THEN '시급'
       ELSE '건별' END --급여종류
    ,@PAYFROM= D.PAYFROM --급여
  FROM PAPER_NEW.DBO.PP_AD_TB A (NOLOCK)
  INNER JOIN PAPER_NEW.DBO.PP_LINE_AD_FINDCODE_TB B (NOLOCK) ON B.LINEADNO = A.LINEADNO
  INNER JOIN PAPER_NEW.DBO.PP_FINDCODE_TB C (NOLOCK) ON C.Code4 = B.FINDCODE
  INNER JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB D (NOLOCK) ON A.LINEADID = D.LINEADID
  -- //END  알림톡 템플릿 변경(추가 : 제목,대표번호,업직종,근무시간,근무지위치,급여)


  
  IF @FLAG = 'Y' AND @CUID IS NOT NULL  AND @RESUME_CNT > 0  
  BEGIN    
    IF NOT EXISTS (SELECT APP_ID FROM PG_APP_MAIN_TB WHERE LINEADNO = @LINEADNO AND RESUME_ID = @RESUME_ID AND APP_TYPE = @APP_TYPE AND APP_STATUS = 'Y')    
    BEGIN    
      INSERT INTO dbo.PG_APP_MAIN_TB    
      (LINEADID, INPUT_BRANCH, LAYOUT_BRANCH, APP_TYPE,    
      OPEN_YN, APP_STATUS, EMAIL, TEL, CONTACT_TYPE, RESUME_ID,    
      APP_TITLE, APP_CONTENTS, APP_SMS_CONTENTS, USER_ID, LINEADNO, APP_QUICK, APP_GBN, CUID, SECTION_CD, PERSON_AGREE_Y)    
      VALUES (@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH, @APP_TYPE,    
      @OPEN_YN, @APP_STATUS, @EMAIL, @TEL, @CONTACT_TYPE, @RESUME_ID,    
      @APP_TITLE, @APP_CONTENTS, @APP_SMS_CONTENTS, @USER_ID, @LINEADNO, @APP_QUICK, @APP_GBN, @CUID, @SECTION_CD, @PERSON_AGREE_Y)    
    
     SELECT @@IDENTITY AS APP_ID    
    
      IF @APP_GBN = 'online' OR @APP_GBN = 'email'    
      BEGIN    
        DECLARE @LMS_TITLE VARCHAR(160)    
              , @LMS_MSG VARCHAR(4000)    
              , @KKO_MSG VARCHAR(4000)    
              , @KKO_URL VARCHAR(1000)    
              , @KKO_URL_BTN_TXT VARCHAR(160)    
    
        SELECT @LMS_TITLE = LMS_TITLE    
             , @LMS_MSG = LMS_MSG               , @KKO_MSG = KKO_MSG    
             , @KKO_URL = URL    
             , @KKO_URL_BTN_TXT = URL_BUTTON_TXT    
          --FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWFa067'')')    
        -- SELECT *    
          FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO('MWFa067')    

        SET @LMS_MSG = REPLACE(@LMS_MSG, '#{지원한 회사명}', @COM_NM)    
        SET @LMS_MSG = REPLACE(@LMS_MSG, '#{지원자명}', @USER_NM)    

        SET @LMS_MSG = REPLACE(@LMS_MSG, '#{제목}', @TITLE)    
        SET @LMS_MSG = REPLACE(@LMS_MSG, '#{회사대표번호}', @PHONE)    
        SET @LMS_MSG = REPLACE(@LMS_MSG, '#{업직종}', @CODE_NAME)    
        SET @LMS_MSG = REPLACE(@LMS_MSG, '#{근무시간}', @WORK_TIME_FROM +'-'+ @WORK_TIME_TO)    
        SET @LMS_MSG = REPLACE(@LMS_MSG, '#{근무지}', @WORK_AREA)    
        SET @LMS_MSG = REPLACE(@LMS_MSG, '#{급여종류}', @PAYF)
        SET @LMS_MSG = REPLACE(@LMS_MSG, '#{급여}', @PAYFROM)
    

        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원한 회사명}', @COM_NM)    
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원자명}', @USER_NM)    

        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{제목}', @TITLE)    
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{회사대표번호}', @PHONE)    
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{업직종}', @CODE_NAME)    
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{근무시간}', @WORK_TIME_FROM +'-'+ @WORK_TIME_TO)    
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{근무지}', @WORK_AREA)    
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{급여종류}', @PAYF)
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{급여}', @PAYFROM)
    
        IF @APP_GBN = 'online'    
        BEGIN    
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{지원방법}', '온라인')    
          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원방법}', '온라인')    
        END    
        IF @APP_GBN = 'email'    
        BEGIN    
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{지원방법}', '이메일')    
          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원방법}', '이메일')    
        END    
    
        -- 카카오톡 발송    
        -- 입사지원자에게 입사지원 완료 발송            
        EXEC FINDDB1.COMDB1.dbo.PUT_SENDKAKAO_PROC @TEL, '02-2187-7876', 'MWFa067', @KKO_MSG, @KKO_URL, @KKO_URL_BTN_TXT, @LMS_TITLE, @LMS_MSG, '', '', ''    
    
        IF @APP_GBN = 'email'    
        BEGIN    
          SELECT @LMS_TITLE = LMS_TITLE    
               , @LMS_MSG = LMS_MSG    
               , @KKO_MSG = KKO_MSG    
               , @KKO_URL = URL    
               , @KKO_URL_BTN_TXT = URL_BUTTON_TXT    
            --FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWFa043'')')    
          -- SELECT *    
            FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO('MWFa043')    
    
    
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{회사명}', @COM_NM)    
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{지원자명}', @USER_NM)    
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{회사 이메일}', @EMAIL)    

          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{제목}', @TITLE)    
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{회사대표번호}', @PHONE)    
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{업직종}', @CODE_NAME)    
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{근무시간}', @WORK_TIME_FROM +'-'+ @WORK_TIME_TO)    
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{근무지}', @WORK_AREA)    
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{급여종류}', @PAYF)
          SET @LMS_MSG = REPLACE(@LMS_MSG, '#{급여}', @PAYFROM)
    

          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{회사명}', @COM_NM)    
          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원자명}', @USER_NM)    
          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{회사 이메일}', @EMAIL)    

          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{제목}', @TITLE)    
          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{회사대표번호}', @PHONE)    
          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{업직종}', @CODE_NAME)    
          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{근무시간}', @WORK_TIME_FROM +'-'+ @WORK_TIME_TO)    
          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{근무지}', @WORK_AREA)    
          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{급여종류}', @PAYF)
          SET @KKO_MSG = REPLACE(@KKO_MSG, '#{급여}', @PAYFROM)
    
          -- 카카오톡 발송    
          -- 공고주에게 입사지원자 발생 알림 발송    
          EXEC FINDDB1.COMDB1.dbo.PUT_SENDKAKAO_PROC @COM_HPHONE, '02-2187-7876', 'MWFa043', @KKO_MSG, @KKO_URL, @KKO_URL_BTN_TXT, @LMS_TITLE, @LMS_MSG, '', '', ''    
        END    
      END    
    
      -- 채용보고서용 LOG    
      DECLARE @LOG_APP_TYPE TINYINT    
    
      IF @APP_TYPE = 1    
        SET @LOG_APP_TYPE = 1    
      ELSE IF @APP_TYPE = 2    
        SET @LOG_APP_TYPE = 2    
      ELSE IF @APP_TYPE = 3 AND @APP_GBN <> 'tel'    
        SET @LOG_APP_TYPE = 3    
      ELSE IF @APP_TYPE = 3 AND @APP_GBN = 'tel'    
        SET @LOG_APP_TYPE = 6    
    
      EXEC PUT_F_JOB_COMPANY_APPLICATION_LOG_PROC @LINEADNO, @LOG_APP_TYPE, 'S102', @CUID    
    
    END    
    ELSE    
    BEGIN    
      SELECT '' AS APP_ID    
    END    
  END    
  ELSE    
  BEGIN    
    SELECT '' AS APP_ID    
  END    
    
END 