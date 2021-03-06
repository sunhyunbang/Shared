USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_MEMBER_HPHONE_CHANGE_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 휴대폰번호 중복 체크
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016.08.28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 :
 EDIT_MEMBER_HPHONE_CHANGE_PROC '10503845', '010-3393-1420'
 *************************************************************************************/
CREATE PROC [dbo].[EDIT_MEMBER_HPHONE_CHANGE_PROC]
  @CUID       INT
, @HP         VARCHAR(13)
AS

BEGIN  

  SET NOCOUNT ON

  UPDATE A
     SET REALHP_YN = 'N'
  -- SELECT *
    FROM CST_MASTER A
   WHERE MEMBER_CD = 1
     AND HPHONE = @HP

  UPDATE A
     SET REALHP_YN = 'Y'
       , HPHONE = @HP
  -- SELECT *
    FROM CST_MASTER A
   WHERE MEMBER_CD = 1
 --    AND HPHONE = @HP
     AND CUID = @CUID  
  
  -- LOG남기기
  
END



GO
