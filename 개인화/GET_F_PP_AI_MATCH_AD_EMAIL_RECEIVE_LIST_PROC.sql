--USE PAPER_NEW      
/*************************************************************************************      
 *  단위 업무 명 : 벼룩시장 구인구직 맞춤정보 이메일 수신자 목록      
 *  작   성   자 : 방순현      
 *  작   성   일 : 2021/12/29                
 *  설        명 : 조건 추가 - 최근90일 이내 로그인 이력이 있는 회원 21.12.29 (개인화추천 시스템)      
 *  주 의  사 항 :      
 *  사 용  소 스 :      
 *  사 용  예 제 : GET_F_PP_AI_MATCH_AD_EMAIL_RECEIVE_LIST_PROC      
 *************************************************************************************/       
CREATE PROCEDURE [dbo].[GET_F_PP_AI_MATCH_AD_EMAIL_RECEIVE_LIST_PROC]      
AS       
      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
 SET NOCOUNT ON      
      
       
 SELECT CM.CUID, CM.USER_NM, CM.EMAIL      
 FROM PP_PERSONALIZATION_FINDJOB_EMAIL_YN_TB AS PMAT       
 INNER JOIN MEMBERDB.MWMEMBER.dbo.CST_MASTER AS CM  ON PMAT.CUID = CM.CUID        
  INNER JOIN MEMBERDB.MWMEMBER.dbo.CST_MARKETING_AGREEF_TB AS M ON M.CUID = CM.CUID      
 WHERE M.AGREEF = 1 -- 마케팅수신동의       
 AND CM.REST_YN = 'N' -- 휴먼회원 제외      
 AND CM.OUT_YN = 'N' -- 탈퇴회원 제외      
 AND CM.MEMBER_CD = 1 -- 개인회원만       
 AND PMAT.EMAIL_YN ='Y'      
 AND NOT (CM.EMAIL NOT LIKE '%@%' OR RTRIM(CM.EMAIL) = '') -- 메일형식 오류 필터       
 AND DATEDIFF(DAY , ISNULL(LAST_LOGIN_DT , JOIN_DT) , GETDATE()) <= 90 --최근90일 이내 로그인 이력이 있는 회원 21.12.29 (개인화추천 시스템)      
 --AND CM.cuid in ('14221905') --배포시 주석처리      
 ORDER BY PMAT.CUID      
      
