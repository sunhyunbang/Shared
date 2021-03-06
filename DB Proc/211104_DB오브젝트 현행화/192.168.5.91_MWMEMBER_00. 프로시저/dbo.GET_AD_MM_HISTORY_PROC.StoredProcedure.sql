USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_HISTORY_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
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

 *************************************************************************************/


CREATE	PROCEDURE [dbo].[GET_AD_MM_HISTORY_PROC]
	 @CUID		INT
	
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
	
	SELECT	 A.HISTORY_CD
			,A.USERID
			,A.ADUSERNAME
			,CONVERT(CHAR(10),A.REG_DT,120) AS REG_DT
			,A.MEMO
			,A.BRANCHCODE
	  FROM DBO.MM_AD_HISTORY_TB AS A WITH (NOLOCK)
	 WHERE CUID = @CUID
	ORDER BY HISTORY_CD DESC
GO
