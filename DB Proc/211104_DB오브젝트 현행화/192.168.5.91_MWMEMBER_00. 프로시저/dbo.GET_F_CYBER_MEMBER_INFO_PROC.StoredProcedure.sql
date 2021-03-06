USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_CYBER_MEMBER_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 사이버 벼룩시장 - 프론트 > 회원정보
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/05/28
 *  수   정   자 : 신장순
 *  수   정   일 : 2014.05.20
 *  설        명 : POST 사용안함, ADDR_A 사용안함 (CITY, GU, DONG 으로 변경)
 *  주 의  사 항 :
 *  사 용  소 스 : /advitiser/cyber/Cyber_ApplyProcess_02.asp
 *  사 용  예 제 : EXEC DBO.GET_F_CYBER_MEMBER_INFO_PROC 'jjangssoon'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_CYBER_MEMBER_INFO_PROC]

  @CUID       INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.USER_NM AS USERNAME
        ,'' AS PHONE
        ,A.HPHONE
        ,'' AS METRO
        ,'' AS CITY
        ,'' AS DONG
        ,'' AS HOMEPAGE
        ,A.EMAIL
    FROM MWMEMBER.dbo.CST_MASTER AS A
   WHERE A.CUID = @CUID




GO
