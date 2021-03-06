USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_AD_EPAPER_SUBC_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
 *  사 용  소 스 : EXEC PUT_AD_EPAPER_SUBC_PROC '11555456',1

 *************************************************************************************/
CREATE	PROCEDURE [dbo].[PUT_AD_EPAPER_SUBC_PROC]
   @CUID          INT,
	 @READINGFLAG   CHAR(1)
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
  DECLARE @ROWCOUNT   INT

  IF @READINGFLAG='1' 
  BEGIN
    UPDATE FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB
       SET READINGFLAG = '1'
         , MODDATE = GETDATE()
     WHERE CUID = @CUID
     
    SELECT @ROWCOUNT=@@ROWCOUNT
    
    IF @ROWCOUNT=0
    BEGIN
      INSERT FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB
           ( USERID, USERNAME, USERPHONE, USEREMAIL1, READINGFLAG, REGDATE, CUID )
      SELECT USERID, USER_NM, HPHONE, EMAIL, '1', GETDATE(), @CUID
        FROM CST_MASTER WITH (NOLOCK)
       WHERE CUID = @CUID
    END
  END
  ELSE
  BEGIN
    UPDATE FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB
       SET READINGFLAG = '0'
         , DELDATE = GETDATE()
     WHERE CUID = @CUID
  END
GO
