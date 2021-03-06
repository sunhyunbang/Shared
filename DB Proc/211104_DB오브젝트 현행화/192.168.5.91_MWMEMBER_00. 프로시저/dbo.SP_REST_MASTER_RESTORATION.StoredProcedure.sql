USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_REST_MASTER_RESTORATION]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REST_MASTER_RESTORATION]  
/*************************************************************************************
 *  단위 업무 명 : 회원 휴면에서 살리기
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0)  -- 정상 
 * RETURN(400)  -- MASTER 에 정보 없음
 * RETURN(500)  -- 휴면 테이블에 정보 없음
 * DECLARE @RET INT
 EXEC @RET=SP_REST_MASTER_RESTORATION 13707608
 * SELECT @RET
 *************************************************************************************/
@CUID INT 
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT ,
		    @ID_REST_COUNT BIT,
			@RE_CUID INT, 
			@RE_USER_NM VARCHAR(50), 
			@RE_HPHONE varchar(14), 
			@RE_EMAIL varchar(50), 
			@RE_BIRTH varchar(8), 
			@RE_DI char(64), 
			@RE_CI char(88),
			@RE_GENDER char(1)

		SELECT @ID_COUNT = COUNT(@CUID) FROM CST_MASTER WITH(NOLOCK) WHERE CUID = @CUID AND REST_YN = 'Y'
		SELECT @ID_REST_COUNT = COUNT(@CUID) FROM CST_REST_MASTER WITH(NOLOCK) WHERE CUID = @CUID  
		
		IF @ID_REST_COUNT = 1 
		BEGIN
			SELECT @RE_CUID = CUID , 
				   @RE_USER_NM = USER_NM, 
				   @RE_HPHONE =HPHONE, 
				   @RE_EMAIL = EMAIL, 
				   @RE_BIRTH = BIRTH, 
				   @RE_DI = DI, 
				   @RE_CI = CI,
				   @RE_GENDER = GENDER  
				   FROM CST_REST_MASTER WITH(NOLOCK) WHERE CUID = @CUID
			
			IF @ID_COUNT = 1
			BEGIN
			UPDATE CST_MASTER SET USER_NM = @RE_USER_NM, HPHONE = @RE_HPHONE, EMAIL = @RE_EMAIL,
							BIRTH = @RE_BIRTH, DI = @RE_DI ,CI = @RE_CI, REST_YN = 'N', 
							LAST_LOGIN_DT = GETDATE(),
							REST_DT = NULL, 
							GENDER = @RE_GENDER
							WHERE CUID = @CUID

			UPDATE CST_REST_MASTER SET RESTORATION_DT = GETDATE() WHERE CUID = @CUID
			RETURN(0)  -- 정상 
			END ELSE
			BEGIN
				RETURN(400)  -- MASTER 에 정보 없음
			END
		END ELSE
		BEGIN
			RETURN(500)  -- 휴면 테이블에 정보 없음
		END	
GO
