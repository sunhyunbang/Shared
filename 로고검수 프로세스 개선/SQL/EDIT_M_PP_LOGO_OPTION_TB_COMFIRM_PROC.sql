--USE PAPER_NEW  
/*************************************************************************************  
 *  단위 업무 명 : 관리자 - 회사 로고 검수완료  
 *  작   성   자 : 이근우  
 *  작   성   일 : 2012/08/27  
 *  수   정   자 : 김문화  
 *  수   정   일 : 2013/10/28  
 *  주 의  사 항 : 로고이원화 작업 반영  
 *  수   정   자 : 신장순  
 *  수   정   일 : 2014/06/09  
 *  내        용 : WAIT_NEW = 'N' 추가 (담당자 메일 발송 관련 신규검수대기 FLAG값 변경) 
 *  수   정   자 : 방순현        
 *  수   정   일 : 2021/10/12 
 *  수 정 내  용 : 로고검수 프로세스 개선
 *  사 용  소 스 :  
 *  사 용  예 제 : EXEC DBO.EDIT_M_PP_LOGO_OPTION_TB_COMFIRM_PROC 41853, 80, 17  
 *************************************************************************************/  
ALTER PROC [dbo].[EDIT_M_PP_LOGO_OPTION_TB_COMFIRM_PROC]  
(  
  @LINEADID         INT           = 0  
, @INPUTBRANCH      TINYINT       = 0  
, @LAYOUTBRANCH     TINYINT       = 0  
, @WAIT_LOGO        VARCHAR(200)  = ''  
, @MAIN_LOGO        VARCHAR(200)  = ''  
, @WAIT_LOGO_BYTE   INT           = 0  
, @MAIN_LOGO_BYTE   INT           = 0  
)  
AS  
  
SET NOCOUNT ON  
DECLARE @COMFIRM_DT DATETIME  
  
DECLARE @TITLE VARCHAR(500)  
DECLARE @FIELD_6 VARCHAR(100)  
  
SET @COMFIRM_DT = GETDATE()  
  
IF @LINEADID > 0 AND @INPUTBRANCH > 0 AND @LAYOUTBRANCH > 0  
  BEGIN  

    BEGIN /** 검수완료 처리시 제목,회사명을 PP_AD_TB 기준으로 업데이트한다 **/
      SELECT @TITLE =  TITLE 
            ,@FIELD_6 = FIELD_6 
      FROM  PP_AD_TB 
      WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUTBRANCH AND LAYOUT_BRANCH = @LAYOUTBRANCH
    END /** 검수 **/

    BEGIN TRAN  
  
    IF (SELECT COUNT(*) FROM PP_LOGO_OPTION_TB WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUTBRANCH AND LAYOUT_BRANCH = @LAYOUTBRANCH) > 0  
      BEGIN  
        IF @WAIT_LOGO = NULL OR @WAIT_LOGO = ''  
          BEGIN  
            UPDATE PP_LOGO_OPTION_TB  
                SET PUB_LOGO = WAIT_LOGO  
                , PUB_CONFIRM_DT = @COMFIRM_DT  
                , PUB_CONFIRM = 1  
                , WAIT_NEW = 'N'  
                , MOD_DT = GETDATE()          -- 검색엔진 증분처리를 위해서 필요함  
                , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
                , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
            WHERE LINEADID = @LINEADID  
            AND INPUT_BRANCH = @INPUTBRANCH  
            AND LAYOUT_BRANCH = @LAYOUTBRANCH  
          END  
        ELSE  
          BEGIN  
            --E-Comm 의 경우 재수정건 검수완료 시 메인로고를 상세로고로  
            IF @INPUTBRANCH = 180 AND (SELECT PUB_CONFIRM FROM PP_LOGO_OPTION_TB WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUTBRANCH AND LAYOUT_BRANCH = @LAYOUTBRANCH) = 2  
              BEGIN  
                IF @MAIN_LOGO = NULL OR @MAIN_LOGO = ''  
                  BEGIN  
                    UPDATE PP_LOGO_OPTION_TB  
                        SET MAIN_LOGO = CASE WHEN ISNULL(MAIN_LOGO , '') = '' THEN MAIN_LOGO ELSE WAIT_LOGO END
                          , MAIN_LOGO_BYTE = CASE WHEN ISNULL(MAIN_LOGO_BYTE , '') ='' THEN MAIN_LOGO_BYTE ELSE WAIT_LOGO END
                          , PUB_CONFIRM_DT = @COMFIRM_DT  
                          , PUB_CONFIRM = 1  
                          , WAIT_NEW = 'N'  
                          , PUB_LOGO_BYTE = WAIT_LOGO_BYTE  
                          , PUB_LOGO = WAIT_LOGO  
                          , MOD_DT = GETDATE()          -- 검색엔진 증분처리를 위해서 필요함  
                          , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
                          , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
                      WHERE LINEADID = @LINEADID  
                        AND INPUT_BRANCH = @INPUTBRANCH  
                        AND LAYOUT_BRANCH = @LAYOUTBRANCH  
                  END  
                ELSE  
                  BEGIN  
                    UPDATE PP_LOGO_OPTION_TB  
                        SET MAIN_LOGO = CASE WHEN ISNULL(MAIN_LOGO , '') = '' THEN MAIN_LOGO ELSE @MAIN_LOGO END
                          , MAIN_LOGO_BYTE = CASE WHEN ISNULL(MAIN_LOGO_BYTE , '') ='' THEN MAIN_LOGO_BYTE ELSE @MAIN_LOGO END
                          , PUB_CONFIRM_DT = @COMFIRM_DT  
                          , PUB_CONFIRM = 1  
                          , WAIT_NEW = 'N'  
                          , PUB_LOGO_BYTE = WAIT_LOGO_BYTE
                          , PUB_LOGO = WAIT_LOGO  
                          , MOD_DT = GETDATE()          -- 검색엔진 증분처리를 위해서 필요함  
                          , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
                          , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
                      WHERE LINEADID = @LINEADID  
                        AND INPUT_BRANCH = @INPUTBRANCH  
                        AND LAYOUT_BRANCH = @LAYOUTBRANCH  
                  END  
  
              END  
            ELSE  
              BEGIN  
                UPDATE PP_LOGO_OPTION_TB  
                    SET PUB_LOGO = @WAIT_LOGO  
                      , MAIN_LOGO = CASE WHEN ISNULL(MAIN_LOGO , '') = '' THEN MAIN_LOGO ELSE @MAIN_LOGO END  
                      , MAIN_LOGO_BYTE = CASE WHEN ISNULL(MAIN_LOGO_BYTE , '') ='' THEN MAIN_LOGO_BYTE ELSE @MAIN_LOGO END
                      , PUB_CONFIRM_DT = @COMFIRM_DT  
                      , PUB_CONFIRM = 1  
                      , WAIT_LOGO = @WAIT_LOGO  
                      , WAIT_NEW = 'N'  
                      , WAIT_LOGO_BYTE = @WAIT_LOGO_BYTE  
                      , PUB_LOGO_BYTE = WAIT_LOGO_BYTE 
                      , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
                      , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
                      , MOD_DT = GETDATE()          -- 검색엔진 증분처리를 위해서 필요함  
                  WHERE LINEADID = @LINEADID  
                    AND INPUT_BRANCH = @INPUTBRANCH  
                    AND LAYOUT_BRANCH = @LAYOUTBRANCH  
              END  
            END  
       END  
     ELSE  
       BEGIN  
          --신문 또는 등록대행의 경우 등록 시 검수완료, 메인로고를 상세로고로  
          IF @INPUTBRANCH <> 180 And @WAIT_LOGO <> ''  
            BEGIN  
              EXEC PUT_CM_PP_LOGO_WAIT_PROC @LINEADID, @INPUTBRANCH, @LAYOUTBRANCH, @WAIT_LOGO, @MAIN_LOGO, @WAIT_LOGO_BYTE, @MAIN_LOGO_BYTE  
  
              UPDATE PP_LOGO_OPTION_TB  
                 SET PUB_LOGO = WAIT_LOGO  
                   , MAIN_LOGO = CASE WHEN ISNULL(MAIN_LOGO , '') = '' THEN MAIN_LOGO ELSE WAIT_LOGO END 
                   , MAIN_LOGO_BYTE = CASE WHEN ISNULL(MAIN_LOGO_BYTE , '') ='' THEN MAIN_LOGO_BYTE ELSE @WAIT_LOGO_BYTE END
                   , PUB_CONFIRM_DT = @COMFIRM_DT  
                   , PUB_CONFIRM = 1  
                   , WAIT_NEW = 'N'  
                   , PUB_LOGO_BYTE = WAIT_LOGO_BYTE
                   , MOD_DT = GETDATE()          -- 검색엔진 증분처리를 위해서 필요함  
                   , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
                   , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
               WHERE LINEADID = @LINEADID  
                 AND INPUT_BRANCH = @INPUTBRANCH  
                 AND LAYOUT_BRANCH = @LAYOUTBRANCH  
            END  
          ELSE  
           BEGIN  
             EXEC PUT_CM_PP_LOGO_WAIT_PROC @LINEADID, @INPUTBRANCH, @LAYOUTBRANCH, @WAIT_LOGO, '', @WAIT_LOGO_BYTE, @MAIN_LOGO_BYTE  
  
              UPDATE PP_LOGO_OPTION_TB  
                 SET PUB_LOGO = WAIT_LOGO  
                   , PUB_CONFIRM_DT = @COMFIRM_DT  
                   , PUB_CONFIRM = 1  
                   , WAIT_NEW = 'N'  
                   , MOD_DT = GETDATE()          -- 검색엔진 증분처리를 위해서 필요함  
                   , MAIN_TITLE = CASE WHEN ISNULL(MAIN_TITLE,'') = '' THEN MAIN_TITLE ELSE @TITLE END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
                   , MAIN_COMPANY = CASE WHEN ISNULL(MAIN_COMPANY,'') = '' THEN MAIN_COMPANY ELSE @FIELD_6 END --21.09.17 MAIN_TITLE/MAIN_COMPANY 값이 있을경우 PP_AD_TB기준으로 업데이트 한다
               WHERE LINEADID = @LINEADID  
                 AND INPUT_BRANCH = @INPUTBRANCH  
                 AND LAYOUT_BRANCH = @LAYOUTBRANCH  
            END  
       END  
  
  /* 검수 완료시 검수대기값을 업데이트한다 21.09.23*/
  IF (SELECT COUNT(LINEADID) FROM PP_AD_TB WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUTBRANCH AND LAYOUT_BRANCH = @LAYOUTBRANCH) > 0 
    BEGIN
      UPDATE PP_AD_TB 
         SET TITLE = ISNULL(PP_LOGO.WAIT_TITLE , AD.TITLE)
            ,FIELD_6 = ISNULL(PP_LOGO.WAIT_COMPANY , FIELD_6) 
        FROM PP_AD_TB AS AD 
        JOIN PP_LOGO_OPTION_TB AS PP_LOGO
          ON AD.LINEADID = PP_LOGO.LINEADID
       WHERE AD.LINEADID = @LINEADID  
         AND AD.INPUT_BRANCH = @INPUTBRANCH  
         AND AD.LAYOUT_BRANCH = @LAYOUTBRANCH

      --검수대기 정보 갱신    
      
      EXEC [DBO].[p_SyncIssueData] @LINEADID, @INPUTBRANCH, @LAYOUTBRANCH, 'L','E'   
    END
  
   -- 에러가 발생했을 경우는 에러번호를 리턴해주고  
   IF ( @@ERROR <> 0 )  
     BEGIN  
      SET NOCOUNT OFF  
      ROLLBACK TRAN  
      RETURN (2)  
     END  
   -- 성공한 경우는 1을 리턴  
   ELSE  
     BEGIN  
      COMMIT TRAN  
      RETURN (1)  
     END  
  END  
  
  
  
  
  