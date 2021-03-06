USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_BAD_USER]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 나쁜 사용자 입력 및 수정
 *  작   성   자 : J&J
 *  작   성   일 : 2016-08-04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 나쁜 사용자 지정 및 지정헤체, 내용 저장 및 이력 
 -- RETURN(0) -- 성공
 -- RETURN(500) -- 실패
 DECLARE @RET INT
 EXEC @RET=SP_BAD_USER 12096777 , 관리자id , 'Y' , '나쁜 사람입니다.'
 SELECT @RET
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_BAD_USER]
@CUID INT,             -- 사용자 고유 넘버
@APP_USER varchar(50), -- 관리자 로그인 정보
@BAD_YN CHAR(1),       -- 나쁜사용자 등록   Y/N
@CONTENTS varchar(4000) -- 사유
AS	
	SET NOCOUNT ON;
	IF @BAD_YN = 'Y' OR @BAD_YN = 'N'
	BEGIN
		INSERT INTO CST_BAD_USER_HISTORY (CUID, APP_USER, CONTENTS, BAD_YN, APP_DT)  -- 이력 테이블
								 VALUES (@CUID, @APP_USER, @CONTENTS, @BAD_YN, GETDATE() )
		
		UPDATE CST_MASTER 
		   SET BAD_YN = @BAD_YN 
		     , MOD_DT = GETDATE()
		 WHERE CUID = @CUID   -- 마스터 테이블에도 업데이트
		RETURN(0)  -- 성공
	END
	ELSE 
	BEGIN
		RETURN(500)  -- 실패
	END
GO
