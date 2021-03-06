USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_AD_MM_MEMBER_HISTORY_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************  
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 정보 수정 로그  
 *  작   성   자 : 배진용  
 *  작   성   일 : 2021/09/01  
 *  수   정   자 :   
 *  수   정   일 :   
 *  설        명 :    
 *  주 의  사 항 :   
 *  사 용  소 스 : EXEC SP_AD_MM_MEMBER_HISTORY_PROC 14208605,'S101','010-1111-1111', '1234@mediawill.com', 'PC'  
									 EXEC SP_AD_MM_MEMBER_HISTORY_PROC 14208605,'S101','010-1231-3213', 'bjy@mediawill.com', '모바일'  	
 *************************************************************************************/  
CREATE PROCEDURE [dbo].[SP_AD_MM_MEMBER_HISTORY_PROC]  
		@CUID         INT, 
		@SECTION_CD   CHAR(10),
		@HPHONE				VARCHAR(30),
		@EMAIL				VARCHAR(50),
		@DIVICE_TYPE	VARCHAR(10)
AS    

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON 
---------------------------------  
-- 데이타 처리  
---------------------------------  
		DECLARE @PRE_HPHONE	VARCHAR(30)
		DECLARE @PRE_EMAIL	VARCHAR(30)
		DECLARE @COMMENT		VARCHAR(100)  
		DECLARE @CHANGE_CMT	VARCHAR(100)
		DECLARE @MAG_ID			VARCHAR(50)
		DECLARE @MAG_NM			VARCHAR(50)
		DECLARE @DEVICE_NM	VARCHAR(50)
		SET @COMMENT = ''
		SET @CHANGE_CMT = ''
	
		-- 기존 이메일 핸드폰 데이터 가져오기
		SELECT @PRE_HPHONE = HPHONE, 
					 @PRE_EMAIL  = EMAIL,
					 @MAG_ID = USERID,
					 @MAG_NM = USER_NM
		 FROM MWMEMBER.DBO.CST_MASTER WITH (NOLOCK)
		 WHERE CUID = @CUID

		 -- 휴대폰, 이메일 기존 데이터와 비교 하여 수정 여부 확인
		 IF @PRE_HPHONE != @HPHONE AND @PRE_EMAIL != @EMAIL
			 BEGIN
				SET @CHANGE_CMT = '휴대폰 번호, 이메일'
			 END
		 ELSE
			 BEGIN
				IF @PRE_HPHONE = @HPHONE AND @PRE_EMAIL != @EMAIL
					BEGIN
						SET @CHANGE_CMT = '이메일'
					END
				IF @PRE_HPHONE != @HPHONE AND @PRE_EMAIL = @EMAIL
					BEGIN
						SET @CHANGE_CMT = '휴대폰 번호'
					END
			 END

			-- PC/모바일(앱) 여부
		  SET @DEVICE_NM = 'PC'
			IF  @DIVICE_TYPE = 'M'
			BEGIN
			 SET @DEVICE_NM = '모바일'
			END

		 -- 휴대폰 또는 이메일 변경이 있을경우만 이력 저장
		 IF @CHANGE_CMT	<> ''
		 BEGIN
			SET @COMMENT = '회원('+ @MAG_ID +')이 ' + @DEVICE_NM  + '에서 ' + @CHANGE_CMT + ' 변경 / ' + (SELECT [MWMEMBER].[dbo].[FN_SERVICE_USE_AGGRE_SECTION](@SECTION_CD))
			INSERT MWMEMBER.DBO.MM_MEMBER_HISTORY_TB  
				(USERID, SECTION_CD, MAG_ID, MAG_NAME, MAG_BRANCH, COMMENT, CUID)  
			VALUES(@MAG_ID, 'S101', @MAG_ID, @MAG_NM, '180', @COMMENT, @CUID) -- SECTION_CD의 값을 S101로 변경해야 회원정보에서 노출됨 
		 END
GO
