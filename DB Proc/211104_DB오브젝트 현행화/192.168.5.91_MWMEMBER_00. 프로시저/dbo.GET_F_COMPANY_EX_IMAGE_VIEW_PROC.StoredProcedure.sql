USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_COMPANY_EX_IMAGE_VIEW_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 기업회원 이미지 보여주기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013/08/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC GET_F_COMPANY_EX_IMAGE_VIEW_PROC  193887
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_COMPANY_EX_IMAGE_VIEW_PROC]
  @CUID       INT
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT EX_IMAGE_1
        ,EX_IMAGE_2
        ,EX_IMAGE_3
        ,EX_IMAGE_4
    FROM MWMEMBER.dbo.CST_MASTER A WITH (NOLOCK)
    LEFT JOIN MWMEMBER.dbo.CST_COMPANY_JOB B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
   WHERE CUID=@CUID
GO
