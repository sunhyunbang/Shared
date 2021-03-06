USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDID_SENDEMAIL_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디찾기>선택한 회원 이메일 보내기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 뒷자리 확인하기 이메일
 *  주 의  사 항 :
 *  사 용  소 스 :
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_FINDID_SENDEMAIL_PROC]

  @CUID   INT

AS

  SET NOCOUNT ON

  DECLARE @EMAIL    VARCHAR(50)

  SELECT EMAIL
       , GETDATE() AS DT
       , USERID
    FROM CST_MASTER WITH (NOLOCK)
   WHERE CUID = @CUID
GO
