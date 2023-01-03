use MWMEMBER
go
/*************************************************************************************      
 *  단위 업무 명 : 기업인증 정보 (수기)      
 *  작   성   자 : 방 순 현      
 *  작   성   일 : 2022-11-10      
 *  수   정   자 :       
 *  수   정   일 :     
 *  설        명 : 기업정보 인증시 회원정보를 가져온다    
 EXEC GET_BIZLICENSE_INFO_PROC '10257324'      
    
      
 *************************************************************************************/      
      
ALTER PROCEDURE [dbo].[GET_BIZLICENSE_INFO_PROC]      
      
 @COMID  int    
      
AS      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
 SET NOCOUNT ON;      
    
SELECT     
CM.USERID , CM.CUID    
, CC.REGISTER_NO, CC.MAIN_PHONE, CC.PHONE, CC.COM_NM, CC.CEO_NM, CC.FAX     
, CC.LNG, CC.CITY, CC.GU, CC.DONG, CC.ADDR1, CC.ADDR2, CC.LAW_DONGNO, CC.MAN_NO, CC.ROAD_ADDR_DETAIL     
, CC.BIZLICENSE_CERTIFICATION_YN      
, CC.BIZLICENSE_ISSUANCEDATE    
, CC.BIZLICENSE_IMGNM    
, CC.BIZLICENSE_REGDATE    
, CC.BIZ_CERTIFICATION_TYPE    
, CC.BIZ_OPENDT    
, (SELECT TOP 1 COMMENT FROM [MM_MEMBER_HISTORY_TB] WHERE CUID = CM.CUID ORDER BY REG_DT DESC) AS MEMO    
, CM.REST_YN  
,(CASE WHEN (SELECT COUNT(BD.IDX) CNT FROM BAD_DATA_TB BD WITH(NOLOCK) WHERE BD.USERID = CM.USERID AND (BD.DEL_YN IS NULL OR BD.DEL_YN <> 'Y')) > 0 THEN 'Y' ELSE 'N' END)  BAD_YN 
FROM CST_COMPANY CC WITH(NOLOCK)         
LEFT OUTER JOIN CST_MASTER CM WITH(NOLOCK) ON CC.COM_ID = CM.COM_ID     
WHERE CC.COM_ID = @COMID     
--AND CM.OUT_YN = 'N'     
AND CM.MEMBER_CD = '2'      
    
    