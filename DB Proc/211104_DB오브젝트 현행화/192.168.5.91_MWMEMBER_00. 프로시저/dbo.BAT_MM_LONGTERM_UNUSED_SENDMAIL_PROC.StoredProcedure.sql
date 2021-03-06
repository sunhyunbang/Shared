USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_LONGTERM_UNUSED_SENDMAIL_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 통합회원 > 장기미이용 회원 메일 발송(2년 되기 1달 전)
' 작    성    자	: 최 병 찬
' 작    성    일	: 2016/8/26
' 수    정    자	: 최병찬
' 수    정    일	: 2015/08/06
' 설          명	: 2년 동안 로그인 하지 않은 회원 1달전에 메일 발송(2년이 되는날 탈퇴 처리해야함)
'					  1달전 COMMON DB의 MM_LONGTERM_UNUSED_TB 테이블에 INSERT후 메일 발송
' 탈퇴 기간 변경 기존 3년에서 2년으로 변경
' 주  의  사  항	: 
' 사  용  소  스 	: 스케줄 작업 
' 예          제	: 
******************************************************************************/
CREATE PROC [dbo].[BAT_MM_LONGTERM_UNUSED_SENDMAIL_PROC]

AS

SET NOCOUNT ON

INSERT FINDDB2.COMMON.DBO.MM_LONGTERM_UNUSED_TB
     ( USERID, USERNAME, EMAIL, JOIN_DT, LOGIN_DT, REST_DT, OUT_DT, CUID)
SELECT 
       A.USERID
     , A.USER_NM
     , A.EMAIL
     , B.JOIN_DT
     , ISNULL(B.LAST_LOGIN_DT, B.JOIN_DT) AS LOGIN_DT
     , ISNULL(A.ADD_DT, DATEADD(YEAR, 1, CONVERT(VARCHAR(10), ISNULL(LAST_LOGIN_DT,JOIN_DT), 111)))  AS REST_DT
     , DATEADD(YEAR, 2, ISNULL(B.LAST_LOGIN_DT, B.JOIN_DT)) AS OUT_DT
     , A.CUID
  FROM CST_REST_MASTER AS A WITH (NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE B.OUT_YN='N'
   AND B.REST_YN='Y'
   AND DATEADD(YEAR, 2, CONVERT(VARCHAR(10), ISNULL(LAST_LOGIN_DT,JOIN_DT), 111)) = DATEADD(MONTH, 1, CONVERT(VARCHAR(10), GETDATE(), 111))
GO
