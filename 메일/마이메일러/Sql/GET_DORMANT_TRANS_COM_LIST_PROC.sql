--USE COMMON
/*************************************************************************************  
 *  단위 업무 명 : 휴면회원_벼룩시장_기업 정보 리스트 가져오기  [3시]
 *  작   성   자 :  
 *  작   성   일 : 2021/12/3  
 *  설        명 :  
 *  사 용  소 스 :  
 *  사 용  예 제 : EXEC DBO.GET_DORMANT_TRANS_COM_LIST_PROC
 *************************************************************************************/  
CREATE PROCEDURE [dbo].[GET_DORMANT_TRANS_COM_LIST_PROC]

AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 SET NOCOUNT ON;

-- 휴면회원_벼룩시장_기업 3시
SELECT
EMAIL , USERID , MEMBER_CD , USERNAME , SECTION_CD , JOIN_DT , LOGIN_DT , INSERT_DT
FROM  [COMMON].[DBO].[GET_MM_CONFIRM_SENDMAIL_REST_VI]
WHERE MEMBER_CD = '2' --기업
AND SECTION_CD = 'S101' --벼룩시장

END

