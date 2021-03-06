USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_UPDATE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_MASTER_UPDATE]
/*************************************************************************************
 *  단위 업무 명 : 개인 정보 수정
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 개인 정보 수정시 이력 및 업데이트를 친다.
 *  RETURN(0) -- 성공
 * RETURN(500)  -- 실패
 * DECLARE @RET INT
 * EXEC @RET=SP_MASTER_UPDATE '11876008' , 'ju990728' , '주해선1' , '110-3027-3315', '10027042'  
 * SELECT @RET
 *************************************************************************************/
@CUID INT,
@USERID varchar(50),
@NEWUSER_NM varchar(30),
@NEWHPHONE varchar(14),
@NEWEMAIL varchar(50),
@NEWCOM_ID int,
@HPCHECK char(1)
AS	
	DECLARE @ID_COUNT bit,  @USER_NM varchar(30) , @COM_ID int , @HPHONE varchar(14)
	
	SET @ID_COUNT = 0
	SELECT @ID_COUNT = COUNT(USERID) FROM CST_MASTER WITH(NOLOCK) WHERE CUID = @CUID --AND USERID = @USERID
	
	SELECT @USERID = USERID
	  FROM CST_MASTER
	 WHERE CUID = @CUID
	
	IF @ID_COUNT = 1
	BEGIN
		UPDATE CST_MASTER SET MOD_DT = getdate() , 
							MOD_ID = @USERID , 
--							COM_ID = @NEWCOM_ID ,
							USER_NM = @NEWUSER_NM , 
							HPHONE = @NEWHPHONE,
							EMAIL = @NEWEMAIL,
							REALHP_YN = @HPCHECK
							WHERE CUID = @CUID
							
		IF @HPCHECK = 'Y'
		BEGIN
			UPDATE CST_MASTER
			SET REALHP_YN = 'N'
			WHERE CUID <> @CUID AND HPHONE = @NEWHPHONE AND MEMBER_CD = '1'
		END

		INSERT INTO CST_MASTER_HISTORY (CUID,   MOD_ID,  MOD_DT,   HPHONE ,  COM_ID, USER_NM, PWD_CHANGE_YN) VALUES 
									   (@CUID  ,@USERID, getdate(),@HPHONE, @COM_ID, @USER_NM, 'N')
			RETURN(0)
	END
	ELSE 
	BEGIN
		RETURN(500)
	END
GO
