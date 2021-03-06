USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_JOININFO_CHECK]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_JOININFO_CHECK]
/*************************************************************************************
 *  단위 업무 명 : 중복 인증정보 체크
 *  작   성   자 : JMG
 *  작   성   일 : 2019-01-14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 인증정보 체크
 * RETURN(500)  3개 이상
 * RETURN(0)  성공
 * DECLARE @RET INT
 * EXEC @RET=SP_JOININFO_CHECK 'MC0GCCqGSIb3DQIJAyEActtpjaNTuHntREaitYRGxqwzecHEwbwNX4bWviXJtxI='
 * SELECT @RET

 **************************************************************************************/
@DI  varchar(70) 
AS 
	DECLARE @NO_CHK INT
	IF @DI ='' 
	BEGIN
		RETURN 500
	END
	SELECT @NO_CHK = COUNT(*) FROM CST_MASTER WITH(NOLOCK) 
					 WHERE DI = @DI 
					 AND MEMBER_CD = '2'
					 AND OUT_YN='N'

	IF @NO_CHK > 2
	BEGIN
		print(500)
		RETURN(500)
	END ELSE
	BEGIN
		print(0)
		RETURN(0)
	END
GO
