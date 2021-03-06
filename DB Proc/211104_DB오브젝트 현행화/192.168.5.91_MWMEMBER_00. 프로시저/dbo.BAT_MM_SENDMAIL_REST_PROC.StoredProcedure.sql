USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_SENDMAIL_REST_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 공통회원 > 휴면예정회원 메일 발송
' 작    성    자	: 최 병찬
' 작    성    일	: 2016/08/28
' 수    정    자	:
' 수    정    일	: 
' 설          명	: 1년 동안 로그인 안한 회원 30일전 메일발송
'					  30일전 COMMON DB의 MM_SENDMAIL_REST_TB 테이블에 INSERT후 메일 발송
' 주  의  사  항	: 
' 사  용  소  스 	: 스케줄 작업 
' 예          제	: 
******************************************************************************/
CREATE PROCEDURE [dbo].[BAT_MM_SENDMAIL_REST_PROC]
AS 

SET NOCOUNT ON
BEGIN 

------------------------------------------------------------------------------
-- 1년 동안 로그인 안한 회원 30일전 메일 발송
------------------------------------------------------------------------------


execute FINDDB1.PAPER_NEW.DBO.BAT_VERSION_M_2MONTH_PHONE_LIST_SAVE_PROC --최근 2개월 등록대행 공고 전화번호 생성


SELECT PHONE
INTO #TMP_PHONE
FROM FINDDB1.LOGDB.DBO.TEMP_VERSION_M_2MONTH_PHONE_LIST_TB


DELETE FROM FINDDB2.COMMON.DBO.MM_SENDMAIL_REST_TB


INSERT FINDDB2.COMMON.DBO.MM_SENDMAIL_REST_TB
      (
       USERID
	    ,MEMBER_CD	
		,USERNAME
	    ,EMAIL
	    ,JOIN_DT
	    ,LOGIN_DT
	    ,INSERT_DT
	    ,CUID
	    )
SELECT 
       A.USERID
      ,A.MEMBER_CD
      ,A.USER_NM
      ,A.EMAIL
      ,A.JOIN_DT
      ,ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT) AS LAST_LOGIN_DT
      ,DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) AS INSERT_DT
      ,A.CUID
  FROM DBO.CST_MASTER AS A WITH(NOLOCK)
 WHERE A.REST_YN = 'N'		--휴면회원 제외
   AND A.BAD_YN = 'N' 		--불량회원 제외
   AND A.OUT_YN = 'N'   --회원탈퇴 제외
   AND (
        (A.LAST_LOGIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
        OR 
        (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
       )

	AND HPHONE NOT IN(
		SELECT PHONE FROM #TMP_PHONE
	)

END


GO
