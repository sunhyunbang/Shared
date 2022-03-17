  
/*************************************************************************************  
 *  단위 업무 명 : 구인 > 구인광고관리 > 상세화면 > 문자 입사 지원 발송  
 *  작   성   자 : 김 성 준  
 *  작   성   일 : 2013/11/15  
 *  수   정   자 : 김 도 연  
 *  수   정   일 : 2018/05/09  
 *  설        명 : 근무 형태 변경  
 *  주 의  사 항 :  
 *  사 용  소 스 :  
 *  사 용  예 제 :   
  
exec PUT_F_APP_MMS_SEND_PROC '010-3393-1420','010-3393-1420','[벼룩시장 구인구직 지원자 : 이근우] 구인정보 보고 문자 드립니다. 통화 가능한 시간대를 알려주시면 전화 드리겠습니다.','[벼룩시장 구인구직:지원 완료 안내] 이근우님이 지원하신 별나라 공이에 입사지원이 완료 되었습니다. 좋은 결과 있으시길 바랍니다.','Y','[벼룩시장 구인구직 전화연락 전 문의]','tel',10504169,46733,
'별나라 공이','추가내용ㅁㅁㅁ'  
  
exec PUT_F_APP_MMS_SEND_PROC '010-3393-1420','010-3393-1420','[벼룩시장 구인구직 지원자 : 이근우(남/41세), 주방장, 서울 강남구, 급여 연봉50,000,000원, , 경력13년]','[벼룩시장 구인구직:지원 완료 안내] 이근우님이 지원하신 별나라 공이에 입사지원이 완료 되었습니다. 좋은 결과 있으시길 바랍니다.','Y','[벼룩시장 구인구직 문자지원]','sms',10504169,46733,'별나라
 공이c','추가내용ㅁㅁㅁff'  
  
exec PUT_F_APP_MMS_SEND_PROC '010-3393-1420','010-3393-1420','[벼룩시장 구인구직 지원자 : 이근우(남/41세), 주방장, 서울 강남구, 급여 연봉50,000,000원, , 경력13년]','[벼룩시장 구인구직:지원 완료 안내] 이근우님이 지원하신 별나라 공이에 입사지원이 완료 되었습니다. 좋은 결과 있으시길 바랍니다.','Y','[벼룩시장 구인구직 문자지원]','sms',10504169,46733,'별나라
 공이',''  
  
exec PUT_F_APP_MMS_SEND_PROC '010-3393-1420','010-3393-1420','[벼룩시장 구인구직 지원자 : 이근우(남/41세), 주방장, 서울 강남구, 급여 협의후 결정, 대학원졸업, 경력13년]','[벼룩시장 구인구직:지원 완료 안내] 이근우님이 지원하신 별나라 공이에 입사지원이 완료 되었습니다. 좋은 결과 있으시길 바랍니다.','Y','[벼룩시장 구인구직 문자지원]','sms',10504169,46733,'별나라 공
이',''  
 *************************************************************************************/  
  
ALTER PROC [dbo].[PUT_F_APP_MMS_SEND_PROC]  
  @SND_HPHONE               VARCHAR(16)             -- 입사지원자 휴대폰 번호  
, @RCV_HPHONE               VARCHAR(16)             -- 광고주 휴대폰 번호  
, @RCV_APP_SMS_CONTENTS     VARCHAR(4000)           -- 문자 지원 내용(광고주용)  
, @SND_APP_SMS_CONTENTS     VARCHAR(4000)           -- 문자 지원 내용(지원자용)  
, @RESUME_CHECK             CHAR(1)         = 'Y'   -- 전화전 문자지원  
, @SUBJECT                  VARCHAR(160)    = ''    -- MMS제목  
, @GBN                      VARCHAR(20)     = ''    -- 구분  
, @CUID                     INT  
, @RESUME_ID                INT             = 0  
, @COM_NM                   VARCHAR(50)     = ''    -- 회사명  
, @CONTENTS                 VARCHAR(500)    = ''    -- 추가내용  
AS  
BEGIN  
  
  SET NOCOUNT ON  
  
  DECLARE @REQTIME VARCHAR(20)  
  SET @REQTIME = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(20), DATEADD(SS, 5, GETDATE()), 120), '-', ''), ' ', ''), ':', '')  
  
  -- 전화전 문자문의(이력서 첨부 않함)  
  IF @GBN = 'tel'  
  BEGIN  
    --set @RCV_APP_SMS_CONTENTS = @RCV_APP_SMS_CONTENTS + 'a1'  
    --set @SND_APP_SMS_CONTENTS = @SND_APP_SMS_CONTENTS + 'a1'  
      
    -- 광고주용 문자전송  
    -- 실서버 적용시 아래 주석 해제  
    EXECUTE FINDDB1.COMDB1.dbo.PUT_SENDMMS_PROC @SND_HPHONE,@RCV_HPHONE,@SUBJECT,@RCV_APP_SMS_CONTENTS,@REQTIME  
    
    IF @RESUME_CHECK = 'Y'  
      -- 지원자용 문자전송  
      -- 실서버 적용시 아래 주석 해제  
      EXECUTE FINDDB1.COMDB1.dbo.PUT_SENDMMS_PROC '02-2187-7867',@SND_HPHONE,@SUBJECT,@SND_APP_SMS_CONTENTS,@REQTIME        
  END  
  
  ELSE  
  BEGIN  
    
    IF @RESUME_CHECK = 'Y'  
    BEGIN  
  
      DECLARE @KKO_MSG          VARCHAR(4000)  
            , @KKO_URL          VARCHAR(1000)  
            , @KKO_URL_BTN_TXT  VARCHAR(160)  
            , @USER_NM          VARCHAR(50)  
            , @HPHONE           VARCHAR(14)  
            , @FINAL_EDU_LVL    VARCHAR(100)  
            , @WORK_TYPE        VARCHAR(200)  
            , @JICJONG          VARCHAR(100)  
            , @AREA             VARCHAR(100)  
            , @SALARY_DIV       VARCHAR(50)  
            , @SIMPLESELFINTRO  VARCHAR(200)  
  
      SELECT @USER_NM = USER_NM  
           , @HPHONE = HPHONE  
           , @FINAL_EDU_LVL = FINAL_EDU_LVL + (SELECT TOP 1 FINAL_EDU_LVL_STATUS FROM PG_RESUME_FINAL_EDU_TB C WITH(NOLOCK) WHERE C.RESUME_ID = M.RESUME_ID ORDER BY FINAL_EDU_ID)  
           , @WORK_TYPE = (SELECT DISTINCT WORK_TYPE = STUFF(  
                     /*(SELECT ',' + WORK_TYPE*/  
                       (SELECT (CASE WHEN WORK_MAIN = 1 THEN ',정규직' ELSE '' END) + (CASE WHEN WORK_SUB = 1 THEN ',계약직' ELSE '' END) + (CASE WHEN WORK_OUT = 1 THEN ',파견직' ELSE '' END)  
                        + (CASE WHEN PARTTIMEF = 1 THEN ',파트타임(아르바이트)' ELSE '' END)+ (CASE WHEN WORK_APPOINT = 1 THEN ',위촉직' ELSE '' END) + (CASE WHEN WORK_FREELANCER = 1 THEN ',프리랜서' ELSE '' END)  
                        FROM DBO.PG_RESUME_WORK_TYPE_TB AS B  WITH (NOLOCK)  
                       WHERE B.RESUME_ID = A.RESUME_ID  
                       FOR XML PATH('')),1,1,'')  
                FROM DBO.PG_RESUME_WORK_TYPE_TB AS A  WITH (NOLOCK)  
               WHERE A.RESUME_ID = M.RESUME_ID)  
           , @JICJONG = (SELECT TOP 1 CODENM3   
                FROM DBO.PG_RESUME_HOPE_JICJONG_TB A WITH(NOLOCK)   
                JOIN PP_FINDCODE_TB B WITH(NOLOCK) ON A.CODE_B = B.CODE3  
               WHERE A.RESUME_ID = M.RESUME_ID)  
           , @AREA = (SELECT TOP 1 AREA_SI + ' ' + AREA_GU FROM dbo.PG_RESUME_HOPE_AREA_TB D WITH(NOLOCK) WHERE D.RESUME_ID = M.RESUME_ID)  
           , @SALARY_DIV = CASE SALARY_DIV WHEN 0 THEN '협의후 결정'   
                                           WHEN 1 THEN '시급 ' + DBO.FN_WON(SALARY) + '원'  
                                           WHEN 2 THEN '월급 ' + DBO.FN_WON(SALARY) + '원'  
                                           WHEN 3 THEN '연봉 ' + DBO.FN_WON(SALARY) + '원'  
                       END  
           , @SIMPLESELFINTRO = ISNULL(SIMPLESELFINTRO, '')  
        FROM PG_RESUME_MAIN_TB M WITH(NOLOCK)  
       WHERE CUID = @CUID  
         AND DEL_YN = 'N'  
         AND CASE WHEN @RESUME_ID = 0 THEN 0 ELSE RESUME_ID END = @RESUME_ID  
       ORDER BY DEL_YN ASC, DEFAULT_YN DESC, RESUME_ID DESC  
  
      IF @FINAL_EDU_LVL IS NULL OR @FINAL_EDU_LVL = ''  
        SET @FINAL_EDU_LVL = ''  
    END  
  
      
  
    IF @GBN = 'sms'  
    BEGIN  
      SELECT @SUBJECT = LMS_TITLE  
           , @RCV_APP_SMS_CONTENTS = LMS_MSG  
           , @KKO_MSG = KKO_MSG  
           , @KKO_URL = URL  
           , @KKO_URL_BTN_TXT = URL_BUTTON_TXT  
         FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO('MWFa065')  
          
      --SELECT @SUBJECT, @KKO_MSG  
      --SELECT @COM_NM, @USER_NM, @HPHONE, @FINAL_EDU_LVL, @WORK_TYPE, @JICJONG, @AREA, @SALARY_DIV, @SIMPLESELFINTRO, @CONTENTS  

        IF ISNULL(@USER_NM, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* 이름 : #{지원자명}   ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{지원자명}', ISNULL(@USER_NM, ''))
        END

        IF ISNULL(@HPHONE, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* 연락처 : #{지원자 연락처}  ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{지원자 연락처}', ISNULL(@HPHONE, ''))
        END

        IF ISNULL(@JICJONG, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* 희망 업직종 : #{희망업직종} ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{희망업직종}', ISNULL(@JICJONG, ''))
        END

        IF ISNULL(@AREA, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* 희망 근무지 : #{희망근무지} ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{희망근무지}', ISNULL(@AREA, ''))  
        END

        IF ISNULL(@SIMPLESELFINTRO, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* 간단한 자기소개 : #{간단 자기소개}  ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{간단 자기소개}', ISNULL(@SIMPLESELFINTRO, ''))   
        END

        IF ISNULL(@FINAL_EDU_LVL, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* 최종 학력 : #{지원자 최종학력}   ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{지원자 최종학력}', ISNULL(@FINAL_EDU_LVL, ''))    
        END

        IF ISNULL(@WORK_TYPE, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* 근무 형태 : #{근무형태}   ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{근무형태}', ISNULL(@WORK_TYPE, ''))    
        END

        IF ISNULL(@SALARY_DIV, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* 희망 급여 : #{희망 급여}     ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{희망 급여}', ISNULL(@SALARY_DIV, ''))    
        END

        IF ISNULL(@CONTENTS, '') =''
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '* 지원내용 : #{문자 직접입력}  ', '')
        END
        ELSE 
        BEGIN
          SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{문자 직접입력}', ISNULL(@CONTENTS, ''))  
        END

      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{회사명}', ISNULL(@COM_NM, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{지원자명}', ISNULL(@USER_NM, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{지원자 연락처}', ISNULL(@HPHONE, ''))        
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{지원자 최종학력}', ISNULL(@FINAL_EDU_LVL, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{근무형태}', ISNULL(@WORK_TYPE, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{희망업직종}', ISNULL(@JICJONG, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{희망근무지}', ISNULL(@AREA, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{희망 급여}', ISNULL(@SALARY_DIV, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{간단 자기소개}', ISNULL(@SIMPLESELFINTRO, ''))  
      --SET @RCV_APP_SMS_CONTENTS = REPLACE(@RCV_APP_SMS_CONTENTS, '#{문자 직접입력}', ISNULL(@CONTENTS, ''))  
  
      IF ISNULL(@USER_NM, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* 이름 : #{지원자명}   ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원자명}', ISNULL(@USER_NM, ''))
      END

      IF ISNULL(@HPHONE, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* 연락처 : #{지원자 연락처}  ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원자 연락처}', ISNULL(@HPHONE, ''))
      END

      IF ISNULL(@JICJONG, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* 희망 업직종 : #{희망업직종} ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{희망업직종}', ISNULL(@JICJONG, ''))
      END

      IF ISNULL(@AREA, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* 희망 근무지 : #{희망근무지} ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{희망근무지}', ISNULL(@AREA, ''))  
      END

      IF ISNULL(@SIMPLESELFINTRO, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* 간단한 자기소개 : #{간단 자기소개}  ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{간단 자기소개}', ISNULL(@SIMPLESELFINTRO, ''))   
      END

      IF ISNULL(@FINAL_EDU_LVL, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* 최종 학력 : #{지원자 최종학력}   ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원자 최종학력}', ISNULL(@FINAL_EDU_LVL, ''))    
      END

      IF ISNULL(@WORK_TYPE, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* 근무 형태 : #{근무형태}   ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{근무형태}', ISNULL(@WORK_TYPE, ''))    
      END

      IF ISNULL(@SALARY_DIV, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* 희망 급여 : #{희망 급여}     ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{희망 급여}', ISNULL(@SALARY_DIV, ''))    
      END

      IF ISNULL(@CONTENTS, '') =''
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '* 지원내용 : #{문자 직접입력}  ', '')
      END
      ELSE 
      BEGIN
        SET @KKO_MSG = REPLACE(@KKO_MSG, '#{문자 직접입력}', ISNULL(@CONTENTS, ''))  
      END

      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{회사명}', ISNULL(@COM_NM, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원자명}', ISNULL(@USER_NM, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원자 연락처}', ISNULL(@HPHONE, ''))        
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{지원자 최종학력}', ISNULL(@FINAL_EDU_LVL, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{근무형태}', ISNULL(@WORK_TYPE, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{희망업직종}', ISNULL(@JICJONG, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{희망근무지}', ISNULL(@AREA, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{희망 급여}', ISNULL(@SALARY_DIV, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{간단 자기소개}', ISNULL(@SIMPLESELFINTRO, ''))  
      --SET @KKO_MSG = REPLACE(@KKO_MSG, '#{문자 직접입력}', ISNULL(@CONTENTS, ''))  
  
      --SELECT @SUBJECT, @KKO_MSG  
  
      -- 문자 발송  
      -- EXECUTE COMDB1.dbo.PUT_SENDMMS_PROC @SND_HPHONE, @RCV_HPHONE, @SUBJECT, @RCV_APP_SMS_CONTENTS, @REQTIME  
      -- EXECUTE COMDB1.dbo.PUT_SENDMMS_PROC '0802690011', '01033931420', @SUBJECT, @RCV_APP_SMS_CONTENTS, @REQTIME  
  
      -- 카카오톡 발송        
      EXEC COMDB1.dbo.PUT_SENDKAKAO_PROC @RCV_HPHONE, @SND_HPHONE, 'MWFa065', @KKO_MSG, @KKO_URL, @KKO_URL_BTN_TXT, @SUBJECT, @RCV_APP_SMS_CONTENTS, '', '', ''  
    END  
  
  END  
  
  
  /*  
  IF @SUBJECT = ''  
  BEGIN  
    SET @SUBJECT = ':::::: 만나야 할 일과 사람 ::::::'  
  END  
  
  -- 광고주용 문자전송  
  EXECUTE FINDDB1.COMDB1.dbo.PUT_SENDMMS_PROC @SND_HPHONE,@RCV_HPHONE,@SUBJECT,@RCV_APP_SMS_CONTENTS,@REQTIME  
  
  IF @RESUME_CHECK = 'Y'  
  BEGIN  
    -- 지원자용 문자전송  
    EXECUTE FINDDB1.COMDB1.dbo.PUT_SENDMMS_PROC '02-2187-7867',@SND_HPHONE,@SUBJECT,@SND_APP_SMS_CONTENTS,@REQTIME  
  END  
  */  
  
END  