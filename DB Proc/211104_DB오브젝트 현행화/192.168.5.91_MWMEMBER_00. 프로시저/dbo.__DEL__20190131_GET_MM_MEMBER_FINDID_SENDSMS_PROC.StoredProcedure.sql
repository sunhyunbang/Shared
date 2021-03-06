USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[__DEL__20190131_GET_MM_MEMBER_FINDID_SENDSMS_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디찾기>선택한 회원 핸드폰 SMS 보내기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 뒷자리 확인하기 SMS
 *  주 의  사 항 :
 *  사 용  소 스 :
 *************************************************************************************/
CREATE  PROC [dbo].[__DEL__20190131_GET_MM_MEMBER_FINDID_SENDSMS_PROC]
  @CUID     INT
  ,@SECTION_CD CHAR(4)
AS

  SET NOCOUNT ON

  DECLARE @SMSMSG   NVARCHAR(4000)  = ''
  DECLARE @HP       VARCHAR(14)     = ''
  DECLARE @USERNAME VARCHAR(30)     = ''
  DECLARE @USERID   VARCHAR(50)     = ''

  SELECT @USERNAME=USER_NM
        ,@HP = CASE WHEN LEFT(HPHONE,3) IN ('010','011','016','017','018','019') THEN HPHONE
         END
        ,@USERID = USERID
    FROM CST_MASTER WITH (NOLOCK)
   WHERE CUID = @CUID

  IF @SECTION_CD='S101'
    BEGIN
      SET @SMSMSG='[벼룩시장] 요청하신 아이디는 '+ @USERID +'입니다.'
      EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '02-3019-1590','벼룩시장',@USERNAME ,@HP ,@SMSMSG ,'FINDALL'
    END

  IF @SECTION_CD='S112'
    BEGIN
      SET @SMSMSG='[M25] 요청하신 아이디는 '+@USERID+'입니다.'
      EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-1448','M25',@USERNAME ,@HP ,@SMSMSG ,'M&B'
    END

  IF @SECTION_CD='S116'
    BEGIN
	    SET @SMSMSG='[야알바] 요청하신 아이디는 '+@USERID+'입니다.'
	    EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '080-269-0011','야알바',@USERNAME ,@HP ,@SMSMSG ,'FINDALL'
    END

  IF @SECTION_CD='S117'
    BEGIN
	    SET @SMSMSG='[테니스코리아] 요청하신 아이디는 '+@USERID+'입니다.'
	    EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-1433','테니스코리아',@USERNAME ,@HP ,@SMSMSG ,'M&B'
    END

  IF @SECTION_CD='S118'
    BEGIN
	    SET @SMSMSG='[포포투] 요청하신 아이디는 '+@USERID+'입니다.'
	    EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-6924','포포투',@USERNAME ,@HP ,@SMSMSG ,'M&B'
    END

  IF @SECTION_CD='S119'
    BEGIN
	    SET @SMSMSG='[톱기어] 요청하신 아이디는 '+@USERID+'입니다.'
	    EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-1438','톱기어',@USERNAME ,@HP ,@SMSMSG ,'M&B'
    END

  IF @SECTION_CD='H001'
    BEGIN
	    SET @SMSMSG='[부동산써브] 요청하신 아이디는 '+@USERID+'입니다.'
	    EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-1438','부동산써브',@USERNAME ,@HP ,@SMSMSG ,'SERVE'
    END
GO
