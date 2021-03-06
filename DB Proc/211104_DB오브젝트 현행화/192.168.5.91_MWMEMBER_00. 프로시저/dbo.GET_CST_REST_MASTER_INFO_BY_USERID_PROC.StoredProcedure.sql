USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_CST_REST_MASTER_INFO_BY_USERID_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 휴면회원 기본정보 가져오기(아이디 기준)
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
 GET_CST_REST_MASTER_INFO_BY_USERID_PROC 'kkam1234'
 
 https://test.member.findall.co.kr/login/userrest_guide.asp
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_CST_REST_MASTER_INFO_BY_USERID_PROC] 

	 @USERID			varchar(50)
AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 기본정보
	SELECT TOP 1
        A.USERID	-- 회원아이디
        ,A.ADD_DT	--휴면전환일
        ,USER_NM
	  FROM CST_REST_MASTER AS A WITH(NOLOCK)
   WHERE A.USERID = @USERID	
     AND A.RESTORATION_DT IS NULL


END





GO
