USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_USERID_CHANGE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_USERID_CHANGE]
/*************************************************************************************
 *  단위 업무 명 : ID 변경
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 아이디 변경 및 비밀번호 변경
 *************************************************************************************/
@CUID INT,
@USERID VARCHAR(50),
@NEW_USERID VARCHAR(50),
@PWD VARCHAR(20)
AS
  SET NOCOUNT ON;

  IF EXISTS (SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @USERID AND CUID = @CUID AND  
		pwd_sha2	  = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD))))	
  BEGIN	
	  UPDATE CST_MASTER SET 
			   USERID = @NEW_USERID 
	  WHERE CUID = @CUID

    -- 중복ID 테이블에서 삭제
    DELETE
    -- SELECT *
      FROM DUPLICATE_USERID_TB
     WHERE CUID = @CUID
	INSERT INTO CST_MASTER_HISTORY (CUID,   MOD_ID,  MOD_DT, NEW_USERID, PWD_CHANGE_YN) VALUES 
									(@CUID  ,@USERID, getdate(),@NEW_USERID, 'N')
	  SELECT 1 AS RESULT
  END
  ELSE
  BEGIN
    SELECT 2 AS RESULT
  END
GO
