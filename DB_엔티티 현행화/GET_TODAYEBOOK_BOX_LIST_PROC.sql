--USE PAPERCOMMON
/*************************************************************************************  
 *  단위 업무 명 : 박스광고주 종이신문정기구독정보 리스트 가져오기  
 *  작   성   자 :  
 *  작   성   일 : 2021/12/3  
 *  설        명 :  
 *  사 용  소 스 :  
 *  사 용  예 제 : EXEC DBO.GET_TODAYEBOOK_BOX_LIST_PROC  
 *************************************************************************************/  
CREATE PROCEDURE [dbo].[GET_TODAYEBOOK_BOX_LIST_PROC]

AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 SET NOCOUNT ON;

    SELECT 
       USERNAME
     , USEREMAIL
     , BRANCHNAME
     , BOXTEL
     , SENDYEAR
     , SENDMONTH
     , SENDDAY
     , INPUTBRANCH
     , EMAILRECVF
     , USERFLAG 
  FROM CM_TODAYEBOOK_BOX_TB



END
