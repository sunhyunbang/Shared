USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_LOGIN_LOG_TB_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 마지막 로그인 기록 가져오기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_MM_LOGIN_LOG_TB_PROC 'SEBILIA'

 *************************************************************************************/
CREATE	PROCEDURE [dbo].[GET_AD_MM_LOGIN_LOG_TB_PROC]
	 @CUID		    INT		-- 회원아이디
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
SET NOCOUNT ON

SELECT 
       TOP 1 
       A.USERID
     , A.SECTION_CD
     , A.LOGIN_DT
     , A.HOST
     , A.IP
  FROM CST_LOGIN_LOG AS A WITH (NOLOCK)
 WHERE A.CUID = @CUID
 ORDER BY LOGIN_DT DESC
GO
