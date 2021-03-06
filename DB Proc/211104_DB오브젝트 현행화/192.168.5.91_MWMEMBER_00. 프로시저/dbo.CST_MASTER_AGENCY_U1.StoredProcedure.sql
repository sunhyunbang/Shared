USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[CST_MASTER_AGENCY_U1]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************      
 *  단위 업무 명 : 회원 가입 대행 > 정회원 등록처리    
 *  작   성   자 : 안대희    
 *  작   성   일 : 2021-05-26      
 *  설        명 : 벼룩시장 부동산 > 회원가입대행 후 정회원 가입시 회원 정보 업데이트    
 *  주 의  사 항 :       
 *  사 용  소 스 :      
    RETURN(500)  -- 실패    
    RETURN(0) -- 성공    
    EXEC dbo.CST_MASTER_AGENCY_U1 14213738, '1', 'find000001', '1234!@', 'dev25@mediawill.com', '010-1234-5678',    
        '', '', '', '', '', '', ''    
    EXEC dbo.CST_MASTER_AGENCY_U1 14213741, '2', 'find000002', '1234!@', 'dev25@mediawill.com', '010-1234-5678',    
        '111-22-33333', 'Y', '1', '880101', '홍길동', '123124', '341252435', 2, '123-4568'    
************************************************************************************/      
CREATE PROCEDURE [dbo].[CST_MASTER_AGENCY_U1]    
    @CUID       INT,    /* key */    
    @MEMBER_CD  CHAR(1),    /* 회원구분(1:개인, 2:기업) */    
    @USERID     VARCHAR(50),    /* 아이디 */    
    @PASSWORD     VARCHAR(30),  /* 비밀번호 */    
    @EMAIL        VARCHAR(50),  /* 이메일 */    
    @HPHONE       VARCHAR(14),  /* 휴대폰번호 */    
    @RETISTER_NO    VARCHAR(12) = '',  /* 사업자 번호 */    
    @ADULT_YN VARCHAR(2) = '',  /* 성인 인증 */    
    @GENDER  VARCHAR(2) = '',  /* 성별 */    
    @BIRTHDATE VARCHAR(10) = '',  /* 생일 */    
    @NAME  VARCHAR(20) = '',  /* 이름 */    
    @DI          VARCHAR(70) = '',      
    @CI          VARCHAR(88) = '',      
    @MEMBER_TYPE TINYINT = 0,      
    @REG_NUMBER VARCHAR(70) = ''    /* 공인중개사 등록 번호 */    
AS    
    SET NOCOUNT ON    
    DECLARE @ID_COUNT BIT    
    DECLARE @REALHP_YN CHAR(1)  /* 휴대폰 인증(Y) */    
    DECLARE @COM_ID INT /* 사업자 ID */    
    SET @REALHP_YN = ''    
    
    /* 회원 체크 */    
    SELECT @ID_COUNT = COUNT(CUID),  @COM_ID = ISNULL(COM_ID, 0)    
    FROM CST_MASTER WITH(NOLOCK)     
    WHERE CUID = @CUID    
    GROUP BY COM_ID    
        
    -- SELECT @ID_COUNT, @COM_ID    
    
    IF (@MEMBER_CD = 1)    
    BEGIN    
        SET @REALHP_YN = 'Y'    
    END    
    
    IF (@ID_COUNT = 1)    
    BEGIN    
        EXEC DBO.SP_CST_MASTER_BACKUP  @CUID --회원정보 백업 2016-11-10 정헌수    
      
        /* 기업 회원 */    
        IF (@MEMBER_CD = 2)    
        BEGIN    
            UPDATE CST_MASTER     
            SET USERID   = @USERID    
            , EMAIL  = @EMAIL    
            , HPHONE = @HPHONE    
            , MOD_DT = GETDATE()    
            , REALHP_YN  = @REALHP_YN    
            , PWD_MOD_DT = GETDATE()    
            , PWD_NEXT_ALARM_DT = (GETDATE() + 180)    
            , LAST_SIGNUP_YN = 'Y'    -- 회원가입대행 최종 가입 여부    
            , pwd_sha2   = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PASSWORD)))    
            , ADULT_YN = @ADULT_YN    
            , GENDER = @GENDER    
            , BIRTH = @BIRTHDATE    
            , USER_NM = @NAME    
            , DI = @DI    
            , CI = @CI    
            WHERE CUID = @CUID    
            AND MEMBER_CD = @MEMBER_CD    
            ;    
    
            /* 담당자 이메일 수정 */    
            UPDATE CST_COMPANY_JOB     
            SET MANAGER_EMAIL = @EMAIl     
            WHERE COM_ID = @COM_ID    
            ;    
    
            -- 사업자번호가 변경 되었으면 수정    
            IF (@RETISTER_NO != '')    
            BEGIN    
                UPDATE CST_COMPANY    
                SET REGISTER_NO = @RETISTER_NO, MOD_DT = GETDATE()    
                WHERE COM_ID = @COM_ID    
                ;    
            END    
    
            /* 공인중개사 번호 */    
           IF (@MEMBER_TYPE = 2)    
           BEGIN    
                UPDATE CST_COMPANY_LAND    
                SET LAND_CLASS_CD = 'A', REG_NUMBER = @REG_NUMBER,     
                ETCINFO_SYNC = 0, SECTION_CD = 'S103', MOD_DT = GETDATE()    
                WHERE COM_ID = @COM_ID    
                ;    
           END    
        END    
    
        ELSE    
            
        BEGIN    
            UPDATE CST_MASTER     
            SET USERID     = @USERID    
            , EMAIL     = @EMAIL    
            , HPHONE     = @HPHONE    
            , MOD_DT     = GETDATE()    
            , REALHP_YN    = @REALHP_YN    
            , PWD_MOD_DT = GETDATE()    
            , PWD_NEXT_ALARM_DT = (GETDATE() + 180)    
            , LAST_SIGNUP_YN = 'Y'    -- 회원가입대행 최종 가입 여부    
            , pwd_sha2   = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PASSWORD)))    
            WHERE CUID = @CUID    
            AND MEMBER_CD = @MEMBER_CD    
            ;    
        END    
    
        /* 회원 변경 이력 */    
        INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, HPHONE, PWD_CHANGE_YN)     
        VALUES (@CUID, @USERID, GETDATE(), @HPHONE, 'Y')    
        ;    
    
        /* 회원가입대행 최종 가입 이력 */    
        INSERT INTO [CST_MASTER_AGENCY_HISTORY] ([CUID], [USERID], [MOD_DT], [EMAIL], [BIZNO], [LAST_SIGNUP_YN], [AGENCY_YN] )    
        VALUES(@CUID, @USERID, GETDATE(), @EMAIl, @RETISTER_NO, 'Y', 'Y')    
        ;    
    
        RETURN(0) -- 성공    
    END    
    ELSE    
    BEGIN    
        RETURN(500)  -- 실패    
    END    
    
    SET NOCOUNT OFF 
GO
