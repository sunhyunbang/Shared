USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_AD_MM_MEMBER_HISTORY_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 정보 수정 로그
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/24
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC PUT_AD_MM_MEMBER_HISTORY_PROC 'SEBILIA','S101','SEBILIA','테스트'

 *************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_AD_MM_MEMBER_HISTORY_PROC]
      @CUID         INT,
	    @USERID		    VARCHAR(50),		-- 회원아이디
	    @SECTION_CD   CHAR(4),
	    @MAG_ID       VARCHAR(30),
	    @COMMENT      VARCHAR(100)
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
SET NOCOUNT ON

INSERT MM_MEMBER_HISTORY_TB
     ( USERID, SECTION_CD, MAG_ID, MAG_NAME, MAG_BRANCH, COMMENT, CUID )
SELECT @USERID, @SECTION_CD, @MAG_ID, MagName, BranchCode, @COMMENT, @CUID
  FROM FINDDB2.FINDCOMMON.DBO.COMMONMAGUSER WITH (NOLOCK)
 WHERE MagID = @MAG_ID
GO
