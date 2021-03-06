USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDID_SENDSMS_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
CREATE  PROC [dbo].[GET_MM_MEMBER_FINDID_SENDSMS_PROC]

  @CUID     INT
  ,@SECTION_CD CHAR(4)

AS

  SET NOCOUNT ON

  DECLARE @SMSMSG   NVARCHAR(4000)  = ''
  DECLARE @HP       VARCHAR(14)     = ''
  DECLARE @USERNAME VARCHAR(30)     = ''
  DECLARE @USERID   VARCHAR(50)     = ''

  DECLARE @MSG	nvarchar	(4000)
  DECLARE @SUBJECT	varchar	(160)

  DECLARE @CALLBACK	varchar	(24)        = '0221877867'        -- 발신자번호


  -- 회원 정보 추출
  SELECT @USERNAME = USER_NM
        ,@HP = CASE WHEN LEFT(HPHONE,3) IN ('010','011','016','017','018','019') THEN HPHONE
         END
        ,@USERID = USERID
    FROM CST_MASTER WITH (NOLOCK)
   WHERE CUID = @CUID

  -- 카카오 알림톡 템플릿 정보 가져오기 / 전송 메시지 가공
  SELECT @SUBJECT = LMS_TITLE
        ,@MSG = REPLACE(LMS_MSG,'#{ID}',@USERID)
    FROM OPENQUERY(FINDDB1,'SELECT LMS_MSG, LMS_TITLE FROM COMDB1.dbo.FN_GET_KKO_TEMPLATE_INFO(''MWsms01'')')

  -- SMS 발송
  EXEC FINDDB1.COMDB1.dbo.PUT_SENDSMS_PROC @CALLBACK,'','',@HP,@MSG
GO
