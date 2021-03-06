USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_CST_BAD_USER_HISTORY]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 불량 유저 처리 히스토리
 *  작   성   자 : 최병찬
 *  작   성   일 : 2017-09-19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 불량 유저 처리 히스토리
 EXEC GET_CST_BAD_USER_HISTORY 12096777

 *************************************************************************************/
CREATE PROC [dbo].[GET_CST_BAD_USER_HISTORY]
@CUID   INT
AS

SET NOCOUNT ON

SELECT CUID, BAD_YN, APP_USER, CONTENTS, APP_DT FROM CST_BAD_USER_HISTORY
 WHERE CUID = @CUID
 ORDER BY SEQ DESC
GO
