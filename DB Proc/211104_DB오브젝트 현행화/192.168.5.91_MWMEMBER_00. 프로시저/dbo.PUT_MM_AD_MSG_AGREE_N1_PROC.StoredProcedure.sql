USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_AD_MSG_AGREE_N1_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 메일 수신 동의 (관리자)
 *  작   성   자 : 안상미
 *  작   성   일 : 2007-12-20
 *  수   정   자 : 최병찬
 *  수   정   일 : 2011-11-11
 *  설        명 : 메일 및 SMS 로 분리 UPDATE
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE PROCEDURE [dbo].[PUT_MM_AD_MSG_AGREE_N1_PROC]
   @CUID          INT
	,@USERID			  VARCHAR(50) 	-- 회원아이디
	,@SECTION_CD		CHAR(4)			-- 섹션코드
	,@AGREEFLAG			CHAR(1)			-- 수신/수신거부 Y:수신 N:수신거부
	,@AGREE_DT			DATETIME		-- 동의날짜
	,@MEDIA_CD			CHAR(1)			-- M:메일 S:SMS
AS		

-- 중복 입력 체크
DECLARE @INTCNT	TINYINT

IF @AGREEFLAG = 'Y'
BEGIN	
	SELECT @INTCNT = COUNT(USERID) 
	  FROM CST_MSG_SECTION WITH(NOLOCK)
	 WHERE CUID = @CUID
	   AND SECTION_CD = @SECTION_CD
     AND MEDIA_CD = @MEDIA_CD

	IF @INTCNT = 0 
	BEGIN
		-- 동의 날짜 없으면 현재시각으로..
		IF @AGREE_DT = '1900-01-01 00:00:00.000'
			SET @AGREE_DT = GETDATE()
	
		INSERT CST_MSG_SECTION (
		           CUID
             , SECTION_CD
             , MEDIA_CD
             , USERID
             , AGREE_DT
		) 
		SELECT	 
		         @CUID
           , @SECTION_CD
			     , @MEDIA_CD
			     , @USERID
			     , @AGREE_DT
	END

END
ELSE
BEGIN	
	DELETE CST_MSG_SECTION
	 WHERE CUID = @CUID
	   AND SECTION_CD = @SECTION_CD
     AND MEDIA_CD = @MEDIA_CD

END
GO
