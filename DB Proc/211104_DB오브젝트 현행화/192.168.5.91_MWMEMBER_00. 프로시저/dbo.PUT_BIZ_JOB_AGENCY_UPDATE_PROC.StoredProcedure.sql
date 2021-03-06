USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_BIZ_JOB_AGENCY_UPDATE_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원가입대행 최종 업데이트 및 이력
 *  작   성   자 : 배진용
 *  작   성   일 : 2020/10/26
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :  
 *  사 용  소 스 :
 *  사 용  예 제 :

 exec dbo.[PUT_BIZ_JOB_AGENCY_UPDATE_PROC] '14208605','bjy@mediawill.com','yong89'

*************************************************************************************/

create PROCEDURE [dbo].[PUT_BIZ_JOB_AGENCY_UPDATE_PROC]
	@CUID		VARCHAR(50) = '',
	@EMAIl		VARCHAR(50) = '',
	@USERID		VARCHAR(50) = '',
	@BIZNO		VARCHAR(50) = '',
	@ADULT_YN	VARCHAR(2) = '',
	@GENDER		VARCHAR(2) = '',
	@BIRTHDATE	VARCHAR(10) = '',
	@NAME		VARCHAR(20) = ''
AS
BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- 사업자 ID 가져오기
	DECLARE @COM_ID VARCHAR(20)
	SELECT TOP 1 @COM_ID =COM_ID FROM CST_MASTER with(NOLOCK)
	WHERE CUID = @CUID
	
	-- 회원가입대행 최종 가입및 이메일 저장
	UPDATE DBO.CST_MASTER
	   SET LAST_SIGNUP_YN = 'Y'
		 , EMAIL = @EMAIl
		 , MOD_DT = GETDATE()
		 , ADULT_YN = @ADULT_YN
		 , GENDER = @GENDER
		 , BIRTH = @BIRTHDATE
		 , USER_NM = @NAME
	 WHERE CUID = @CUID

	-- 담당자 이메일 수정
	UPDATE CST_COMPANY_JOB 
	   SET MANAGER_EMAIL = @EMAIl 
	 WHERE COM_ID = @COM_ID

	 -- 사업자번호가 변경 되었으면 수정
	IF @BIZNO <> '' 
		BEGIN
			UPDATE CST_COMPANY
			SET REGISTER_NO = @BIZNO
			  , MOD_DT = GETDATE()
			WHERE COM_ID = @COM_ID
		END

	-- 최종회원가입 대행 이력 테이블에 사업자 번호 변수
	SELECT TOP 1 @BIZNO = REGISTER_NO FROM CST_COMPANY with(NOLOCK)
	WHERE COM_ID = @COM_ID
		

	-- 회원가입대행 최종 가입 이력 
	INSERT INTO [CST_MASTER_AGENCY_HISTORY] ([CUID], [USERID], [MOD_DT], [EMAIL], [BIZNO], [LAST_SIGNUP_YN], [AGENCY_YN] )
	VALUES(@CUID, @USERID, GETDATE(), @EMAIl, @BIZNO, 'Y', 'Y')
END




GO
