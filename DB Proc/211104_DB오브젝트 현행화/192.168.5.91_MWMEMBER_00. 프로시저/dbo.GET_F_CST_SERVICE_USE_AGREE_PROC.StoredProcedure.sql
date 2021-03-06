USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_CST_SERVICE_USE_AGREE_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 공통 > 서비스이용동의 여부 확인
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2018/10/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 서비스 이용동의가 되어있으면 1, 안되어있으면 0
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_F_CST_SERVICE_USE_AGREE_PROC 1111, 'S102'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_CST_SERVICE_USE_AGREE_PROC]

  @CUID INT = 0
  ,@SECTION_CD	CHAR(4)       -- 섹션코드 (CC_SECTION_TB 참고)

  ,@RTN_VALUE TINYINT OUTPUT

AS

  SET NOCOUNT ON

  SET @RTN_VALUE = 0

  IF EXISTS(SELECT *
              FROM CST_SERVICE_USE_AGREE WITH(NOLOCK)
             WHERE SECTION_CD = @SECTION_CD
               AND CUID = @CUID)
    BEGIN
      SET @RTN_VALUE = 1
    END

    --PRINT   @RTN_VALUE
GO
