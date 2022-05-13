/*************************************************************************************              
 *  단위 업무 명 : 마케팅,이벤트 정보 수신 동의 안내 메일 누락 대상자 목록              
 *  작   성   자 : 방순현              
 *  작   성   일 : 2022/04/29              
 *  수   정   자 :              
 *  수   정   일 :              
 *  설         명 :               
 *  주 의  사 항 :              
 *  사 용  소 스 :              
 *  사 용  예 제 : GET_F_PP_AD_AGREE_EMAIL_RECEIVE_MISSING_LIST_PROC              
 *************************************************************************************/               
alter PROCEDURE [dbo].[GET_F_PP_AD_AGREE_EMAIL_RECEIVE_MISSING_LIST_PROC]              
AS               
              
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
 SET NOCOUNT ON              
            
 SELECT A.CUID        
   , AGREE_DT        
   ,B.USER_NM             
   ,B.EMAIL        
 FROM CST_MARKETING_AGREEF_TB A               
   INNER JOIN CST_MASTER B              
   ON A.CUID = B.CUID              
 WHERE A.AGREEF = '1'              
 AND B.REST_YN = 'N'              
 AND B.OUT_YN = 'N'            
 AND B.BAD_YN = 'N'    
 AND (B.EMAIL IS NOT NULL AND B.EMAIL <> '')         
 AND MAILSEND_DT IS NULL        
 AND A.AGREE_DT < DATEADD(D,-730,GETDATE())              
