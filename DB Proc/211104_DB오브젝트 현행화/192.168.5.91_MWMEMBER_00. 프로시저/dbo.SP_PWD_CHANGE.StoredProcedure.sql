USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_PWD_CHANGE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_PWD_CHANGE]
    /*************************************************************************************
     *  단위 업무 명 : 비밀번호 변경
     *  작   성   자 : J&J
     *  작   성   일 : 2016-07-25
     *  수   정   자 :
     *  수   정   일 :
     *  설        명 : 비밀번호 변경 및 180일 뒤에 수정일 변경 일자 업데이트
     * RETURN(0) 성공
     * RETURN(500)  실패
     * DECLARE @RET INT
     * EXEC @RET=SP_PWD_CHANGE 'nadu81@naver.com', 'a', 'aa', 11217636, '127.0.0.1'
     * SELECT @RET
     *************************************************************************************/
    @USERID varchar(50), 
    @NEWPWD VARCHAR(20),
    @OLDPWD VARCHAR(20),
    @CUID INT,
    @MOD_REG_IP VARCHAR(30) = NULL
AS
	SET NOCOUNT ON;
	DECLARE @MD5PWD_NEW varbinary(128), @MD5PWD_OLD varbinary(128), @ID_COUNT bit
		
	SET @MD5PWD_OLD = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@OLDPWD)))  -- 소문자 변경 및 MD5로 변경
	SET @MD5PWD_NEW = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@NEWPWD)))  -- 소문자 변경 및 MD5로 변경

	SET @ID_COUNT = 0
	SELECT @ID_COUNT = COUNT(CUID) FROM CST_MASTER WITH(NOLOCK) 
	WHERE pwd_sha2 = @MD5PWD_OLD -- 관리자 체크	
	AND CUID = @CUID

	--PRINT(@ID_COUNT)
													
	IF @ID_COUNT = 1
	BEGIN
		UPDATE CST_MASTER
        SET pwd_sha2 = @MD5PWD_NEW , PWD_MOD_DT = getdate(), 
		PWD_NEXT_ALARM_DT = getdate() + 180,
		login_pwd_enc = NULL
		WHERE CUID = @CUID  -- 비밀 번호 업데이트 및 비번 수정 날짜 부동산 서브 비번 NULL 처리

        /* !! 운영반영시 운영(REAL)으로 변경 !!*/
        --. DEV
		--. EXEC [192.168.184.51,8019].rserve.dbo.SV_PWD_SYNC @CUID, @NEWPWD

        --. REAL > 써브 비번 변경 호출
		EXEC [221.143.23.211,8019].rserve.dbo.SV_PWD_SYNC @CUID, @NEWPWD

		/*2016-09-06 써브 체크용 임시 추후 삭제~!!*/			  
		--	INSERT CST_MASTER_LOGIN_SUCCESS (cuid,pwd,GBN ) 
		--	SELECT @CUID,@NEWPWD, 2 
			
        -- 이력을 남기자
		INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, PWD_CHANGE_YN, MOD_REG_IP)
        VALUES(@CUID, @USERID, GETDATE(), 'Y', @MOD_REG_IP)
        ;

        --. edit by 안대희 2021-09-29
        --. 로그인 history > login_status 2(비밀번호 변경)로 변경
        UPDATE CST_LOGIN_LOG
        SET login_status = 2
		WHERE CUID = @CUID
        ;

		RETURN(0)
	END ELSE
	BEGIN
		RETURN(500)
	END
GO
