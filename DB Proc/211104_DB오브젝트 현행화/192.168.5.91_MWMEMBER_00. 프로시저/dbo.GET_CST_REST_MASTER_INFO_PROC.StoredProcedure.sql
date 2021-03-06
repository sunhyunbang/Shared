USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_CST_REST_MASTER_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 /기업 구분 없이 회원 기본 정보 값 가져 오기
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-08-16
 *  설        명 : 
 *  수   정   자 :  
 *  수   정   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 GET_CST_REST_MASTER_INFO_PROC 'kkam1234','정헌수','19760207','010-3127-3287'
 
 https://test.member.findall.co.kr/login/userrest_infocheck.asp
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_CST_REST_MASTER_INFO_PROC] 

	 @USERID			varchar(50)
	 ,@USERNM			varchar(50)
 	 ,@BIRTH			char(8)
 	 ,@HPHONE			varchar(50)
 

AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 기본정보
	SELECT TOP 1
        A.USERID	-- 회원아이디
        ,A.ADD_DT	--휴면전환일
        ,USER_NM
        ,CUID		
	  FROM CST_REST_MASTER AS A WITH(NOLOCK)
   WHERE A.USERID = @USERID	
		AND USER_NM =@USERNM
		AND replace(HPHONE,'-','') = replace(@HPHONE,'-','') --파생테이블로??
		AND RESTORATION_DT IS NULL 


END





GO
