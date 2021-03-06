USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_AGENCY_PWD_CHANGE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_AGENCY_PWD_CHANGE]
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 변경 - 관리자>공고등록 임시회원 SMS 문자전송 에서 비밀번호 변경 하기
 *  작   성   자 : 배진용
 *  작   성   일 : 2021-06-09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0) 성공
 * RETURN(500)  실패
 * DECLARE @RET INT
 * EXEC [SP_AGENCY_PWD_CHANGE]  'yong89','14213766','1234','bjy89','관리자담당자'
 *
 *************************************************************************************/
@CUID			INT,
@USERID		VARCHAR(50),
@PWD			VARCHAR(50),
@MOD_ID		VARCHAR(50),
@MOD_NAME VARCHAR(50)

AS
	SET NOCOUNT ON;
	DECLARE  @ID_COUNT bit
	
	SET @ID_COUNT = 0
	-- 회원가입대행이고 임시회원인 경우에만 비밀번호 초기화
	SELECT @ID_COUNT = COUNT(USERID) FROM CST_MASTER WITH(NOLOCK) WHERE CUID = @CUID AND AGENCY_YN = 'Y' AND LAST_SIGNUP_YN='N'

	IF @ID_COUNT = 1
	BEGIN
		UPDATE CST_MASTER SET 
		PWD_MOD_DT = getdate() 
		,PWD_NEXT_ALARM_DT = getdate() + 90
		,pwd_sha2= master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD))) 
		WHERE CUID = @CUID
	
	-- SMS전송으로 인한 비밀번호 변경 이력
	INSERT INTO CST_MASTER_PWD_CHANGE_ADMIN_HISTORY 
							(CUID, 
							USERID, 
							MOD_DT, 
							MOD_ID, 
							MOD_NAME) 
					VALUES 
							(@CUID, 
							@USERID, 
							getdate(), 
							@MOD_ID, 
							@MOD_NAME)
		RETURN(0)
		
	END 
	ELSE
	BEGIN
		RETURN(500)
	END
GO
