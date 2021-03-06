USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_CHECK]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_COMPANY_CHECK]
/*************************************************************************************
 *  단위 업무 명 : 중복 사업자 체크
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 사업자 체크
 * RETURN(500)  3개 이상
 * RETURN(0)  성공
 * DECLARE @RET INT
 * EXEC @RET=SP_COMPANY_CHECK '조민기', '010-6393-0923', 'M', '19770713'
 * SELECT @RET
 exec mwmember.dbo.SP_COMPANY_CHECK '조민기', '010-6393-0923', 'M', '19770713'
 **************************************************************************************/
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@GENDER  char(1),
@BIRTH  varchar(8)
AS 
	DECLARE @NO_CHK INT
	IF @USER_NM ='' AND @HPHONE = '' AND @GENDER = '' AND @BIRTH='' 
	BEGIN
		RETURN 500
	END
	SELECT @NO_CHK = COUNT(*) FROM CST_MASTER WITH(NOLOCK) 
					 WHERE USER_NM = @USER_NM  
					 AND GENDER = @GENDER  
					 AND HPHONE = [DBO].[FN_PHONE_STRING](@HPHONE)
					 AND BIRTH = @BIRTH
					 AND MEMBER_CD = '2'
					 AND OUT_YN='N'
					 
	IF @NO_CHK > 2
	BEGIN
--		print(500)
		RETURN(500)
	END ELSE
	BEGIN
--		print(0)
		RETURN(0)
	END
GO
