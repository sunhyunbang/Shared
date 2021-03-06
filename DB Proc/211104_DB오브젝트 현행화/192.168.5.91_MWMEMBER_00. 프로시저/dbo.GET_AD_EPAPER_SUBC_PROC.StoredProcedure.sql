USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_EPAPER_SUBC_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 ePAPER 정기구독 여부
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_EPAPER_SUBC_PROC '140060'

 *************************************************************************************/
CREATE	PROCEDURE [dbo].[GET_AD_EPAPER_SUBC_PROC]
	 @CUID		INT
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
  DECLARE @READINGFLAG CHAR(1)
  DECLARE @EPAPERYN    CHAR(1)
	
	SELECT	 
	        @READINGFLAG = READINGFLAG
	  FROM	FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB WITH (NOLOCK)
	 WHERE	CUID= @CUID
	 
  IF @READINGFLAG IS NULL OR @READINGFLAG='0'
  BEGIN
    SET @EPAPERYN='N'
  END
  ELSE
  BEGIN
    SET @EPAPERYN='Y'  
  END

  SELECT @EPAPERYN AS EPAPER_YN
GO
