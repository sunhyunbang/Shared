USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_USER_LOG_VIEW_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************
 *  단위 업무 명 : 관리자 페이지 회원 정보 조회 로그 기록 프로시저
 *  작   성   자 : 최병찬
 *  작   성   일 : 2011-11-29
 *  사 용  소 스 : exec PUT_MM_USER_LOG_VIEW_PROC 'S101', 'sebilia', 'sebilia', 12566407, '58.76.233.71' ,  'V'
***************************************************************/
CREATE PROC [dbo].[PUT_MM_USER_LOG_VIEW_PROC]
       @SECTION_CD    CHAR(4)
     , @ADMINID       VARCHAR(30)
     , @USERID        VARCHAR(50)
     , @CUID          INT
     , @IP            VARCHAR(15)=''
     , @ACT           CHAR(1)='V'
     , @PAGE          INT = NULL
     , @SEARCHARG     VARCHAR(50) = NULL
     , @KEYWORD       VARCHAR(50) = NULL
AS

SET NOCOUNT ON

EXEC FINDDB1.MAGUSER.DBO.PUT_MM_USER_LOG_VIEW_PROC  @SECTION_CD, @ADMINID, @USERID, @CUID, @IP, @ACT, @PAGE, @SEARCHARG, @KEYWORD
GO
