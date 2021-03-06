USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_REST_CONFIRM_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 휴면회원 처리된 회원에게 메일 발송하기 위해 COMMON DB테이블로 이동
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016-08-28
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  예        제 :  
 *************************************************************************************/
CREATE PROCEDURE [dbo].[BAT_MM_REST_CONFIRM_PROC]
	 
AS 
SET NOCOUNT ON

DELETE FROM FINDDB2.COMMON.DBO.MM_REST_CONFIRM_TB

INSERT FINDDB2.COMMON.DBO.MM_REST_CONFIRM_TB	 
     ( USERID, MEMBER_CD, USERNAME, EMAIL, JOIN_DT, LOGIN_DT, INSERT_DT, CUID)
SELECT B.USERID, B.MEMBER_CD, A.USER_NM, A.EMAIL, B.JOIN_DT, B.LAST_LOGIN_DT, A.ADD_DT, A.CUID
  FROM CST_REST_MASTER AS A WITH(NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE CONVERT(VARCHAR(10), A.ADD_DT, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)


GO
