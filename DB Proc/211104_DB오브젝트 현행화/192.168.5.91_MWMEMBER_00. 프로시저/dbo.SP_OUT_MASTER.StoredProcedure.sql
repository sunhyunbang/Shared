USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_OUT_MASTER]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_OUT_MASTER]
/*************************************************************************************
 *  단위 업무 명 : 회원 탈퇴 상태 만들기 - 회원 신청용
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 * RETURN(0) 성공
 * RETURN(500)  실패
 * DECLARE @RET INT
 * EXEC @RET=SP_OUT_MASTER  '14052056' , 'macmoc','e프라이버시 클린서비스 통한 요청','kkam1234'
 * SELECT @RET 


 
 select  * FROM CST_MASTER WITH(NOLOCK) where userid='macmoc'
 
 exec SP_OUT_MASTER  '14052056' , 'macmoc','e프라이버시 클린서비스 통한 요청','kkam1234'
 
 
 *************************************************************************************/
@CUID INT,
@USERID VARCHAR(50),
@OUT_CAUSE VARCHAR(1000),
@ADMINID   VARCHAR(50) = ''   --관리자 페이지 탈퇴 인자 추가(2016.09.08 최병찬 추가)
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT
	
	SELECT @ID_COUNT = COUNT(CUID) 
	  FROM CST_MASTER WITH(NOLOCK) 
	 WHERE CUID = @CUID AND USERID = @USERID
		
	IF @ID_COUNT = 1
	BEGIN
		INSERT INTO CST_OUT_MASTER  
		            (CUID,  OUT_APPLY_DT, OUT_CAUSE)
				 VALUES (@CUID, GETDATE(),   @OUT_CAUSE)	

		UPDATE CST_MASTER 
		   SET OUT_YN = 'Y' , OUT_DT = GETDATE()
		     , MOD_DT = CASE 
		                     WHEN @ADMINID <> '' THEN GETDATE()
		                     ELSE MOD_DT
		                END
		     , MOD_ID = CASE 
		                     WHEN @ADMINID <> '' THEN @ADMINID
		                     ELSE MOD_ID
		                END
	 	 WHERE CUID = @CUID AND USERID = @USERID

		DELETE DUPLICATE_USERID_TB WHERE CUID = @CUID --탈퇴시 중복관련 테이블 삭제
		
		RETURN(0)						
	END
	ELSE	
	BEGIN
		RETURN(500)	
	END
GO
