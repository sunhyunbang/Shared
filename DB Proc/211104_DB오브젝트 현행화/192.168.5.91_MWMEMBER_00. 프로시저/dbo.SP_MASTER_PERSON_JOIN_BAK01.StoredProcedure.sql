USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_PERSON_JOIN_BAK01]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MASTER_PERSON_JOIN_BAK01]
/*************************************************************************************
 *  단위 업무 명 : 개인 회원 가입 및 이력
 *  작   성   자 : 최승범
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
 -- 개인 정보
@USERID  varchar(50),
@PWD  VARCHAR(30),
@ADULT_YN  char(1),
@MEMBER_CD  char(1),
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@EMAIL  varchar(50),
@GENDER  char(1),
@BIRTH  varchar(8),
@SNS_TYPE  char(1),
@SNS_ID  varchar(25),
@DI  char(64),
@CI  char(88),
--이력 정보
@JOIN_PATH varchar(50),
@JOIN_DOMAIN varchar(50),
@JOIN_OBJECT INT ,
@CUID int = 0 output

AS
	SET NOCOUNT ON;
	--DECLARE @CUID INT
		
		SELECT @CUID = MAX(CUID) + 1 FROM CST_MASTER
		BEGIN

			INSERT INTO CST_MASTER (CUID , 
									USERID,  
									USER_NM, 
									BAD_YN, 
									JOIN_DT,   
									MOD_DT,    
									MOD_ID , 
									PWD , 
									MEMBER_CD,  
									REST_YN, 
									OUT_YN, 
									ADULT_YN, 
									HPHONE, 
									EMAIL, 
									GENDER, 
									BIRTH, 
									SNS_TYPE, 
									SNS_ID , 
									CI, 
									DI)
			VALUES (@CUID, 
					@USERID, 
					@USER_NM, 
					'N',   
					GETDATE(), 
					GETDATE(), 
					@USERID, 
					DBO.FN_MD5(LOWER(@PWD)), 
					@MEMBER_CD ,  
					'N' ,   
					'N', 
					@ADULT_YN, 
					@HPHONE, 
					@EMAIL, 
					@GENDER, 
					@BIRTH, 
					@SNS_TYPE, 
					@SNS_ID, 
					@CI, 
					@DI)

			-- 이력을 남기자...
			INSERT INTO CST_JOIN_INFO (CUID, USERID, JOIN_PATH, JOIN_DOMAIN, JOIN_OBJECT)
			VALUES (@CUID, @USERID, @JOIN_PATH, @JOIN_DOMAIN, @JOIN_OBJECT)					   
		END

	     SELECT @CUID
GO
