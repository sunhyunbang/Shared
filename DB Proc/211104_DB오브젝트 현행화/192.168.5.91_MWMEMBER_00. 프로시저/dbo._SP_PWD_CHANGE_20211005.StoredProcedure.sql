USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[_SP_PWD_CHANGE_20211005]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_SP_PWD_CHANGE_20211005]
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
 * EXEC @RET=SP_PWD_CHANGE 'nadu81@naver.com', 'a', 'aa', 11217636
 * SELECT @RET
 *************************************************************************************/
@USERID varchar(50), 
@NEWPWD VARCHAR(20),
@OLDPWD VARCHAR(20),
@CUID INT
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
			UPDATE CST_MASTER SET pwd_sha2 = @MD5PWD_NEW , PWD_MOD_DT = getdate(), 
								  PWD_NEXT_ALARM_DT = getdate() + 180,
								  login_pwd_enc = NULL
								  WHERE CUID = @CUID  -- 비밀 번호 업데이트 및 비번 수정 날짜 부동산 서브 비번 NULL 처리
			-- 써브 비번 변경 호출
			exec [221.143.23.211,8019].rserve.dbo.SV_PWD_SYNC @CUID, @NEWPWD
			
				/*2016-09-06 써브 체크용 임시 추후 삭제~!!*/			  
			--	INSERT CST_MASTER_LOGIN_SUCCESS (cuid,pwd,GBN ) 
			--	SELECT @CUID,@NEWPWD, 2 
				
			
			INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, PWD_CHANGE_YN) VALUES 
										   (@CUID,@USERID, getdate(), 'Y')  -- 이력을 남기자
			RETURN(0)
		END ELSE
		BEGIN
			RETURN(500)
		END
		
		

GO
