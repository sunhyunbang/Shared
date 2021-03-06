USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_NEWS_LETTER_SEND_LIST_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************  
 *  단위 업무 명 : [마케팅 전략실] 개인회원 대상 뉴스레터 발송 데이터 추출 
 *  작   성   자 : 이 현 석
 *  작   성   일 : 2020/12/16  
 *  수   정   자 :
 *  수   정   일 :   
 *  설        명 :
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC MWMEMBER.DBO.GET_F_NEWS_LETTER_SEND_LIST_PROC
 *************************************************************************************/  
CREATE PROC [dbo].[GET_F_NEWS_LETTER_SEND_LIST_PROC]  
 
AS   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON
 
             SELECT A.CUID
                     , A.USERID
                     , A.USER_NM
                     , A.EMAIL
             FROM MWMEMBER.DBO.CST_MASTER A WITH(INDEX=PK_CST_MASTER)
       INNER JOIN MWMEMBER.DBO.CST_MARKETING_AGREEF_TB B WITH(INDEX=PK_CST_MARKETING_AGREEF_TB) ON B.CUID=A.CUID
            WHERE A.REST_YN='N' --- 휴면회원 제외
	            AND A.OUT_YN='N'  --- 탈퇴회원 제외
              AND A.BAD_YN='N'  --- 불량회원 제외
	            AND A.MEMBER_CD = 1 --- 1.개인회원 2.기업회원
              AND B.AGREEF=1    --- 수신동의 및 마케팅 동의 1 비동의 0
	            AND A.EMAIL NOT IN ('@','', '@gmail.com', '@naver.com')
	            AND A.EMAIL NOT LIKE ('%@%@%@%')
	            AND A.EMAIL NOT LIKE ('%@%@%')
	            AND A.EMAIL NOT LIKE ('.%@%')
	            AND A.EMAIL NOT LIKE (',%@%')
         ORDER BY A.CUID ASC 
  
  
  
  
  
GO
