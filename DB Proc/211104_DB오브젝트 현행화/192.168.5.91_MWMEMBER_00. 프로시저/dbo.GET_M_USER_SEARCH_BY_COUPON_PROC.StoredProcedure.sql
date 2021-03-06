USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_M_USER_SEARCH_BY_COUPON_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 개인회원상세 > 고객관리 현황 입력
 *  작   성   자 : 안상미
 *  작   성   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : 

GET_M_USER_SEARCH_BY_COUPON_PROC 'USERID','kkam1234'

 *************************************************************************************/


CREATE	PROCEDURE [dbo].[GET_M_USER_SEARCH_BY_COUPON_PROC]
	 @SEARCHTYPE		VARCHAR(20)
	 ,@SEARCHTEXT		VARCHAR(50)
	
AS		
	set nocount on
---------------------------------
-- 데이타 처리
---------------------------------
	IF @SEARCHTYPE ='USERID' 
	BEGIN
	SELECT	top 100
			 A.cuid
			,A.USERID 
			,A.USER_NM
			,A.REST_YN
			,A.MEMBER_CD
	  FROM DBO.CST_MASTER  AS A WITH (NOLOCK)
	 WHERE USERID like  @SEARCHTEXT +'%'
		AND OUT_YN='N'
	END
	ELSE BEGIn
	SELECT	top 100
			 A.cuid
			,A.USERID 
			,A.USER_NM
			,A.REST_YN
			,A.MEMBER_CD
	  FROM DBO.CST_MASTER  AS A WITH (NOLOCK)
	 WHERE USER_NM like @SEARCHTEXT +'%'
		AND OUT_YN='N'
	END
GO
