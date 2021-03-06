USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_MEMBER_HISTORY_TB_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 섹션별 수정 로그 기록
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_MM_MEMBER_HISTORY_TB_PROC 'SEBILIA','S101'

 *************************************************************************************/
CREATE	PROCEDURE [dbo].[GET_AD_MM_MEMBER_HISTORY_TB_PROC]
	 @CUID		      INT,	 		-- CUID
	 @SECTION_CD    CHAR(4)
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
SET NOCOUNT ON

SELECT 
       A.REG_DT
     , A.MAG_NAME
     , B.BranchName
     , A.COMMENT
  FROM MM_MEMBER_HISTORY_TB AS A WITH (NOLOCK)
  LEFT JOIN FINDDB2.FINDCOMMON.DBO.Branch AS B WITH (NOLOCK) ON A.MAG_BRANCH=B.BranchCode
 WHERE A.CUID = @CUID
   AND A.SECTION_CD = @SECTION_CD
 ORDER BY PKEY DESC
GO
