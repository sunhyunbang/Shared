USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_UNIQUE_USERID_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 회원 아이디 중복 중복체크
 *  작   성   자 : 문해린
 *  작   성   일 : 2007-12-20
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 해당 스토어드 프로시저를 사용하는 asp 파일을 기재한다.
 *************************************************************************************/



CREATE       PROCEDURE [dbo].[GET_MM_MEMBER_UNIQUE_USERID_PROC]
	@USERID		VARCHAR(50)	-- 회원아이디
AS

	SELECT	COUNT(USERID) AS INTMEMBERCNT 
	  FROM	DBO.CST_MASTER	 WITH(NOLOCK)
	 WHERE  USERID = @USERID

GO
