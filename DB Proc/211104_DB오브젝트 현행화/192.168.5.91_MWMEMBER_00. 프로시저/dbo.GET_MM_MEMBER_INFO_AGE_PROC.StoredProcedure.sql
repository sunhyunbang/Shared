USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_INFO_AGE_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 나이 가져오기
 *  작   성   자 : 최승범
 *  작   성   일 : 2016-07-19
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GET_MM_MEMBER_INFO_AGE_PROC]

     @CUID	INT
     
AS		

	SELECT	(DATEDIFF(DD, CONVERT(DATETIME, BIRTH), GETDATE()) /365) AS AGE
	FROM DBO.CST_MASTER WITH(NOLOCK)
	WHERE CUID = @CUID
GO
