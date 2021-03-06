USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원 기본 정보 가져오기(공통)
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015.3.9
 *  수   정   자 : 이근우
 *  수   정   일 : 2018.05.03
 *  설        명 : 불량여부, 휴면여부, 탈퇴여부 추가
 *  주 의  사 항 : 
 *  사 용  소 스 :
 EXEC GET_MM_MEMBER_PROC 10504172
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_MM_MEMBER_PROC]
	 @CUID		INT

AS

	SET NOCOUNT ON 
	-- 기본정보
	SELECT
		   A.USERID
		 , A.USER_NM
		 , A.MEMBER_CD
		 , A.HPHONE
		 , A.EMAIL
		 , A.SNS_TYPE 
		 , A.SNS_ID    
		 , A.BIRTH	-- 회원정보 수정시 필요
		 , A.GENDER	-- 회원정보 수정시 필요
		 , CASE	WHEN A.REALHP_YN ='Y' THEN 'Y'
				WHEN (SELECT COUNT(*) FROM CST_MASTER AS B WITH (NOLOCK) WHERE B.HPHONE = A.HPHONE AND B.MEMBER_CD='1') = 1  THEN 'Y' 
				ELSE 'N' 
				END AS REALHP_YN
     , A.BAD_YN
     , A.REST_YN
     , A.REST_DT
     , A.OUT_YN
     , A.OUT_DT
	 , M.AGREE_DT AS MK_AGREE_DT
     , ISNULL(M.AGREEF,0) AS MK_AGREEF
		 ,ISNULL(AGENCY_YN,'N') AS  AGENCY_YN						-- 회원가입대행 추가 2021-06-08
		 ,ISNULL(LAST_SIGNUP_YN,'Y') AS LAST_SIGNUP_YN	-- 회원가입대행 추가 2021-06-08
	  FROM CST_MASTER AS A WITH (NOLOCK)
	  LEFT OUTER JOIN CST_MARKETING_AGREEF_TB AS M ON M.CUID = A.CUID
	 WHERE A.CUID=@CUID

	-- 수신 동의 섹션 가져오기
	--EXEC DBO.GET_MSG_SECTION @CUID

GO
