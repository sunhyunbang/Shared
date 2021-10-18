  
  
  
      
      
/*************************************************************************************      
 *  단위 업무 명 : E-COMM /등록대행 / 광고주 광고 리스트      
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)      
 *  작   성   일 : 2015/01/17      
 *  수   정   자 : 김성윤     
 *  수   정   일 : 2021/05/31  
 *  수 정  내 용 : 정액권 이름 추가  
 *  수   정   자 : 방 순 현        
 *  수   정   일 : 2021/10/12 
 *  수 정 내  용 : 로고검수 프로세스 개선 
 *  주 의  사 항 :      
 *  사 용  소 스 :      
 *  사 용  예 제 : SELECT * FROM PP_CUST_AD_JOB_VI WHERE USER_ID = 'cbk09'      
 *************************************************************************************/      
      
ALTER VIEW [dbo].[PP_CUST_AD_JOB_VI]      
      
AS      
      
  -- ECOMM / 등록대행      
  SELECT A.LINEADNO      
       , A.LINEADID, A.INPUT_BRANCH, A.LAYOUT_BRANCH, A.FINDCODE, A.DETAILADCODE, A.GROUP_CD      
       , CASE WHEN B.PAPER_OPT = 1 THEN 1      
              WHEN B.PAPER_OPT & 7 = 7 THEN 7      
              WHEN B.PAPER_OPT & 6 = 6 THEN 6      
              WHEN B.PAPER_OPT & 5 = 5 THEN 5      
              WHEN B.PAPER_OPT & 4 = 4 THEN 4      
              WHEN B.PAPER_OPT & 3 = 3 THEN 3      
              WHEN B.PAPER_OPT & 2 = 2 THEN 2      
         ELSE 0      
         END AS PAPER_OPT      
       , A.AREA_A, A.AREA_B, A.AREA_C, A.AREA_DETAIL, A.ORDER_NAME, A.PHONE, A.CONTENTS, A.BUY_PRICE      
       , A.SALE_PRICE, A.FIELD_1, A.FIELD_2, A.FIELD_3, A.FIELD_4, A.FIELD_5, ISNULL(L.WAIT_COMPANY,A.FIELD_6) AS FIELD_6, A.FIELD_7      
       , A.FIELD_8, A.FIELD_9, A.FIELD_10, A.FIELD_11, A.START_DT, A.END_DT, A.VERSION, A.[USER_ID]      
       , A.MAG_ID, B.ICON_OPT, A.REG_DT, A.MOD_DT, A.DELYN, ISNULL(L.WAIT_TITLE , A.TITLE) AS TITLE
       , ''  AS MWPLUS, A.LAYOUTCODE, A.ORDER_EMAIL      
       , A.PAY_FREE      
       , CASE WHEN A.[VERSION] = 'E' THEN 1      
              WHEN A.[VERSION] = 'M' THEN 2      
         END AS ADGBN      
       , '' AS  WLOCAL      
       , NULL AS HPHONE      
       , B.OPT_START_DT      
       , B.OPT_END_DT      
       , B.OPT_AREA      
       , B.OPT_PATH      
       , B.OPT_CODE      
       , B.MOBILE_OPT_CODE      
       , B.DISPLAY_OPT      
       , B.OPT_I_PRICE      
       , A.ISSTORAGE      
       , PR.RESERVE_START_DT      
       , PR.RESERVE_END_DT      
       , A.INPUTCUST      
       , 0 AS TOTAMOUNT      
       , A.ENDYN      
       , ISNULL(PAP.PARTNERF, 0) AS PARTNERF      
       , A.CUID      
    , ISNULL(PAP.FEDERATIONF, 0) AS FEDERATIONF      
    , ISNULL(PAP.KINFAF, 0) AS KINFAF      
    , ISNULL(PAP.SENIORTVF, 0) AS SENIORTVF      
       , CM.FAT_ID      
     ,CM.REGIST_ID    
       , CMM.FAT_TYPE      
       , DG.FAT_ID AS DG_FAT_ID      
       , DGM.FAT_TYPE AS DG_FAT_TYPE      
       , DG.DISPLAY_GOODS_ID      
       , DG.DISPLAY_GOODS_ID_CNT      
       , DG.USE_CNT AS DG_USE_CNT      
       , DG.START_DT AS DG_START_DT      
       , DG.END_DT AS DG_END_DT      
  ,CMM.FAT_NM   --정액권 이름 추가   
    FROM PP_AD_TB A (NOLOCK)      
    JOIN PP_OPTION_TB B (NOLOCK) ON A.LINEADID = B.LINEADID AND A.INPUT_BRANCH = B.INPUT_BRANCH AND A.LAYOUT_BRANCH = B.LAYOUT_BRANCH      
    LEFT JOIN CY_FAT_AD_MAPPING_TB CM (NOLOCK) ON A.LINEADID = CM.LINEADID AND A.INPUT_BRANCH = CM.INPUT_BRANCH AND A.LAYOUT_BRANCH = CM.LAYOUT_BRANCH      
    LEFT JOIN PP_AD_RESERVE_TB PR (NOLOCK) ON A.LINEADNO = PR.LINEADNO      
   LEFT JOIN PP_AD_PARTNER_TB PAP (NOLOCK) ON A.LINEADNO = PAP.LINEADNO      
    LEFT JOIN CY_FAT_AD_DISPLAY_GOOD_TB DG WITH(NOLOCK) ON DG.LINEADNO = A.LINEADNO      
    LEFT JOIN CY_FAT_MASTER_TB CMM WITH(NOLOCK) ON CMM.FAT_ID = CM.FAT_ID      
    LEFT JOIN CY_FAT_MASTER_TB DGM WITH(NOLOCK) ON DGM.FAT_ID = DG.FAT_ID  
    LEFT JOIN PP_LOGO_OPTION_TB L (NOLOCK) ON A.LINEADID = L.LINEADID AND A.INPUT_BRANCH = L.INPUT_BRANCH AND A.LAYOUT_BRANCH = L.LAYOUT_BRANCH     
   WHERE A.GROUP_CD = 14      
     AND NEWMEDIA = 0           -- 신매체영업관리로 재등록된 무료광고는 빼고...      
     AND A.VERSION IN ('E','M')   -- 등록대행/이컴      
     --OR (A.VERSION = 'N' AND A.INPUT_BRANCH = 80) -- 신문 직접등록      
      
  UNION ALL      
      
  -- 광고주인증 줄광고      
  SELECT A.LINEADNO      
        ,A.LINEADID, A.INPUT_BRANCH, A.LAYOUT_BRANCH, A.FINDCODE, A.DETAILADCODE, A.GROUP_CD      
        ,CASE      
          WHEN B.PAPER_OPT = 1 THEN 1      
          WHEN B.PAPER_OPT & 7 = 7 THEN 7   
          WHEN B.PAPER_OPT & 6 = 6 THEN 6      
          WHEN B.PAPER_OPT & 5 = 5 THEN 5      
          WHEN B.PAPER_OPT & 4 = 4 THEN 4      
          WHEN B.PAPER_OPT & 3 = 3 THEN 3      
          WHEN B.PAPER_OPT & 2 = 2 THEN 2      
ELSE 0      
         END AS PAPER_OPT      
        ,A.AREA_A, A.AREA_B, A.AREA_C, A.AREA_DETAIL, A.ORDER_NAME, A.PHONE, A.CONTENTS, A.BUY_PRICE      
        ,A.SALE_PRICE, A.FIELD_1, A.FIELD_2, A.FIELD_3, A.FIELD_4, A.FIELD_5, ISNULL(L.WAIT_COMPANY,A.FIELD_6) AS FIELD_6, A.FIELD_7      
        ,A.FIELD_8, A.FIELD_9, A.FIELD_10, A.FIELD_11, A.START_DT, A.END_DT, A.VERSION, CU.USERID AS [USER_ID]      
        ,A.MAG_ID, B.ICON_OPT, A.REG_DT, A.MOD_DT, A.DELYN, ISNULL(L.WAIT_TITLE , A.TITLE) AS TITLE     
    , ''  AS MWPLUS, A.LAYOUTCODE, A.ORDER_EMAIL      
        ,A.PAY_FREE      
        ,3 AS ADGBN      
        ,'' AS  WLOCAL      
        ,NULL AS HPHONE      
        ,B.OPT_START_DT      
        ,B.OPT_END_DT      
        ,B.OPT_AREA      
        ,B.OPT_PATH      
        ,B.OPT_CODE      
        ,B.MOBILE_OPT_CODE      
        ,B.DISPLAY_OPT      
        ,B.OPT_I_PRICE      
        ,A.ISSTORAGE      
        ,NULL AS RESERVE_START_DT      
        ,NULL AS RESERVE_END_DT      
        ,A.INPUTCUST      
        ,ISNULL(CR.TOTAMOUNT,0) AS TOTAMOUNT      
        ,A.ENDYN      
      ,ISNULL(PAP.PARTNERF, 0) AS PARTNERF            
        ,CU.CUID      
     ,ISNULL(PAP.FEDERATIONF, 0) AS FEDERATIONF      
  ,ISNULL(PAP.KINFAF, 0) AS KINFAF      
  ,ISNULL(PAP.SENIORTVF, 0) AS SENIORTVF      
       , NULL AS FAT_ID      
    , NULL AS REGIST_ID   
       , NULL AS FAT_TYPE      
       , NULL AS DG_FAT_ID      
       , NULL AS DG_FAT_TYPE      
       , NULL AS DISPLAY_GOODS_ID      
       , NULL AS DISPLAY_GOODS_ID_CNT      
       , NULL AS DG_USE_CNT      
       , NULL AS DG_START_DT      
       , NULL AS DG_END_DT    
    , NULL AS FAT_NM  
    FROM PP_AD_TB A (NOLOCK)      
    JOIN PP_OPTION_TB B (NOLOCK) ON A.LINEADID = B.LINEADID AND A.INPUT_BRANCH = B.INPUT_BRANCH AND A.LAYOUT_BRANCH = B.LAYOUT_BRANCH      
    JOIN MWDB.dbo.MW_CUSTOMER_AUTH_TB AS CU (NOLOCK) ON CU.INPUTCUST = A.INPUTCUST      
    LEFT JOIN MWDB.dbo.MW_LINEAD_CUST_RELATION_TB AS CR (NOLOCK) ON CR.LINEADNO = A.LINEADNO      
    LEFT JOIN PP_AD_PARTNER_TB PAP (NOLOCK) ON A.LINEADNO = PAP.LINEADNO      
    LEFT JOIN PP_LOGO_OPTION_TB L (NOLOCK) ON A.LINEADID = L.LINEADID AND A.INPUT_BRANCH = L.INPUT_BRANCH AND A.LAYOUT_BRANCH = L.LAYOUT_BRANCH    
   WHERE A.GROUP_CD = 14      
     AND A.VERSION = 'N'  -- 신문줄      
     AND A.INPUT_BRANCH <> 80      
     AND A.IDENTYFLAG = 1      
      
  UNION ALL      
      
  -- 직접등록 광고      
  SELECT A.LINEADNO      
        ,A.LINEADID, A.INPUT_BRANCH, A.LAYOUT_BRANCH, A.FINDCODE, A.DETAILADCODE, A.GROUP_CD      
        ,CASE      
          WHEN B.PAPER_OPT = 1 THEN 1      
          WHEN B.PAPER_OPT & 7 = 7 THEN 7      
          WHEN B.PAPER_OPT & 6 = 6 THEN 6      
          WHEN B.PAPER_OPT & 5 = 5 THEN 5      
          WHEN B.PAPER_OPT & 4 = 4 THEN 4      
          WHEN B.PAPER_OPT & 3 = 3 THEN 3      
          WHEN B.PAPER_OPT & 2 = 2 THEN 2      
          ELSE 0      
         END AS PAPER_OPT      
        ,A.AREA_A, A.AREA_B, A.AREA_C, A.AREA_DETAIL, A.ORDER_NAME, A.PHONE, A.CONTENTS, A.BUY_PRICE      
        ,A.SALE_PRICE, A.FIELD_1, A.FIELD_2, A.FIELD_3, A.FIELD_4, A.FIELD_5, ISNULL(L.WAIT_COMPANY,A.FIELD_6) AS FIELD_6, A.FIELD_7      
        ,A.FIELD_8, A.FIELD_9, A.FIELD_10, A.FIELD_11, A.START_DT, A.END_DT, A.VERSION, RL.UserID AS [USER_ID]      
        ,A.MAG_ID, B.ICON_OPT, A.REG_DT, A.MOD_DT, A.DELYN, ISNULL(L.WAIT_TITLE , A.TITLE) AS TITLE    
        , ''  AS MWPLUS, A.LAYOUTCODE, A.ORDER_EMAIL      
        ,A.PAY_FREE      
        ,3 AS ADGBN      
        ,'' AS  WLOCAL      
        ,NULL AS HPHONE      
        ,B.OPT_START_DT      
        ,B.OPT_END_DT        
        ,B.OPT_AREA      
        ,B.OPT_PATH      
        ,B.OPT_CODE      
        ,B.MOBILE_OPT_CODE      
        ,B.DISPLAY_OPT      
        ,B.OPT_I_PRICE      
        ,A.ISSTORAGE      
        ,NULL AS RESERVE_START_DT      
        ,NULL AS RESERVE_END_DT      
        ,A.INPUTCUST      
        ,0 AS TOTAMOUNT      
        ,A.ENDYN      
        ,ISNULL(PAP.PARTNERF, 0) AS PARTNERF      
        ,RL.CUID      
      ,ISNULL(PAP.FEDERATIONF, 0) AS FEDERATIONF      
     ,ISNULL(PAP.KINFAF, 0) AS KINFAF      
        ,ISNULL(PAP.SENIORTVF, 0) AS SENIORTVF      
       , NULL AS FAT_ID      
    , NULL AS REGIST_ID   
       , NULL AS FAT_TYPE      
       , NULL AS DG_FAT_ID      
       , NULL AS DG_FAT_TYPE                
       , NULL AS DISPLAY_GOODS_ID      
       , NULL AS DISPLAY_GOODS_ID_CNT      
       , NULL AS DG_USE_CNT      
       , NULL AS DG_START_DT           , NULL AS DG_END_DT    
    , NULL AS FAT_NM  
    FROM PP_AD_TB A (NOLOCK)      
    JOIN PAPERREG.dbo.LineAd AS RL (NOLOCK) ON RL.LineAdId = A.LINEADID AND RL.InputBranch = A.INPUT_BRANCH AND RL.CloseBranch = A.LAYOUT_BRANCH      
    JOIN PP_OPTION_TB B (NOLOCK) ON A.LINEADID = B.LINEADID AND A.INPUT_BRANCH = B.INPUT_BRANCH AND A.LAYOUT_BRANCH = B.LAYOUT_BRANCH      
    LEFT JOIN PP_AD_PARTNER_TB PAP (NOLOCK) ON A.LINEADNO = PAP.LINEADNO       
    LEFT JOIN PP_LOGO_OPTION_TB L (NOLOCK) ON A.LINEADID = L.LINEADID AND A.INPUT_BRANCH = L.INPUT_BRANCH AND A.LAYOUT_BRANCH = L.LAYOUT_BRANCH    
   WHERE A.GROUP_CD = 14    