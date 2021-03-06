USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_PWD_CHANGE_LATER]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 나중에 변경
 *  작   성   자 : J&J
 *  작   성   일 : 2016-08-22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 변경 및 180일 뒤에 수정일 변경 일자 업데이트
 * RETURN(0) 성공
 * RETURN(500)  실패
 * DECLARE @RET INT
 * EXEC @RET=SP_PWD_CHANGE 'nadu81@naver.com', 'a', 'aa', 11217636
 * SELECT @RET
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_PWD_CHANGE_LATER]
@CUID INT
,@DURATION INT  = 90
AS
	SET NOCOUNT ON;
	DECLARE @USERID Varchar(50)	
	UPDATE CST_MASTER 
	SET 
	PWD_NEXT_ALARM_DT = getdate() + @DURATION
	WHERE CUID = @CUID  -- 비밀 번호 업데이트 및 비번 수정 날짜 부동산 서브 비번 NULL 처리
	SELECT @USERID = USERID FROM CST_MASTER  WITH(NOLOCK) where CUID = @CUID 
	INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, PWD_CHANGE_YN) VALUES 
	(@CUID,@USERID, getdate(), 'N')  -- 이력을 남기자
	RETURN 0
GO
