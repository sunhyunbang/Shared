USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MM_MEMBER_TB_SIMPLE_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************
* Description
*
*  내용 : 이력서 등록 개인 심플 정보
*  EXEC : DBO.GET_F_MM_MEMBER_TB_SIMPLE_INFO_PROC 'test'
*********************************************************************/
/*********************************************************************
* Work History
*
* 1) 정태운(2010/12/07) : 신규작성
* 2) 신장순(2014/04/20) : 수정 - POST 사용안함, ADDR_A 사용안함 (CITY, GU, DONG 으로 변경)
*********************************************************************/
CREATE    PROCEDURE [dbo].[GET_F_MM_MEMBER_TB_SIMPLE_INFO_PROC]
(
		@CUID			INT
)
AS
SET NOCOUNT ON

  --참여자 기본 정보
  SELECT TOP 10 A.USER_NM
       , A.BIRTH AS JUMINNO_A
       , A.GENDER
       , '' AS PHONE	--A.PHONE
       , A.HPHONE
       , A.EMAIL
       , '' AS 'POST'
       , (CASE A.MEMBER_CD WHEN 2 THEN 
           (SELECT ISNULL(CITY, '') + ' ' + ISNULL(GU, '') + ' ' + ISNULL(DONG, '') FROM CST_COMPANY WITH(NOLOCK) WHERE COM_ID = A.COM_ID) 
          END) AS 'ADDR_A'
       , (CASE A.MEMBER_CD WHEN 2 THEN
            (SELECT CASE WHEN CITY IS NULL AND GU IS NULL AND DONG IS NULL THEN '' ELSE ADDR1 END FROM CST_COMPANY WITH(NOLOCK)  WHERE COM_ID = A.COM_ID)
          END) AS 'ADDR_B'
       , A.REALHP_YN
    FROM CST_MASTER AS A WITH(NOLOCK) 
   WHERE CUID = @CUID
GO
