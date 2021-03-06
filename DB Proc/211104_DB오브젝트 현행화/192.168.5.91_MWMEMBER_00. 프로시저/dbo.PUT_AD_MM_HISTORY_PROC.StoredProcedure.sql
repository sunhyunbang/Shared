USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_AD_MM_HISTORY_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
CREATE PROCEDURE [dbo].[PUT_AD_MM_HISTORY_PROC]
   @CUID        INT
	,@USERID		  VARCHAR(50)		-- 회원아이디
	,@ADUSERID		VARCHAR(20)		-- 섹션코드
	,@MEMBER_CD		CHAR(1)			-- 불량회원여부
	,@MEMGBN		  VARCHAR(30)		-- 회원상태구분
	,@MEMO			  VARCHAR(500)	-- 불량처리아이디
	
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
	

	INSERT INTO DBO.MM_AD_HISTORY_TB(
				 USERID
				,ADUSERID
				,ADUSERNAME
				,BRANCHCODE
				,MEMBER_CD
				,MEMGBN
				,REG_DT
				,MOD_DT
				,MEMO
				,CUID
				)	

		SELECT	@USERID
				,@ADUSERID
				,MAGNAME
				,BRANCHCODE
				,@MEMBER_CD
				,@MEMGBN
				,GETDATE()
				,GETDATE()
				,@MEMO
			  ,@CUID
		  FROM	FINDDB2.FINDCOMMON.DBO.COMMONMAGUSER WITH(NOLOCK)
		 WHERE	MAGID = @ADUSERID
GO
