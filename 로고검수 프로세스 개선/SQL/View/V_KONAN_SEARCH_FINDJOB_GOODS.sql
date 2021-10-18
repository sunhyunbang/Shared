    
/*************************************************************************************    
 *  ���� ���� �� : ���� ��ǰ    
 *  ��   ��   �� : �̱ٿ�    
 *  ��   ��   �� : 2019/07/29    
 *  ��   ��   �� : �� �� ��        
 *  ��   ��   �� : 2021/10/12 
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����
 *  ��        �� : �з� �˻���    
 *  �� ��  �� �� :    
 *  �� ��  �� �� :    
 *  �� ��  �� �� :     
 SELECT TOP 10 * FROM V_KONAN_SEARCH_FINDJOB_GOODS    
 SELECT TOP 1000 * FROM V_KONAN_SEARCH_FINDJOB_GOODS WHERE POSITION_CODE = 'WJ010101' ORDER BY DISPLAY_ORDER ASC, NEWID()    
 SELECT COUNT(*) FROM V_KONAN_SEARCH_FINDJOB_GOODS    
 *************************************************************************************/    
    
ALTER VIEW [dbo].[V_KONAN_SEARCH_FINDJOB_GOODS]    
AS    
     
  SELECT POSITION_CODE + A.LINEADNO AS PK_VALUE    
       , POSITION_CODE    
       , A.LINEADNO    
       , A.LINEADID    
       , A.INPUT_BRANCH    
       , A.LAYOUT_BRANCH    
       , A.AD_KIND    
       , CASE WHEN A.POSITION_CODE IN('WJ010301','MJ010301','MJ010302') THEN ISNULL(L.WAIT_TITLE , A.TITLE) ELSE A.TITLE END TITLE --���ǵ�,M���� ������ ��ΰ�/�ΰ� �ڽ� �ϰ�� ��ùݿ�  
       , A.CONTENTS    
       , A.AREA_A    
       , A.AREA_B    
       , A.AREA_C    
       , A.AREA_DONG    
       , CASE WHEN A.POSITION_CODE IN('WJ010301','MJ010301','MJ010302') THEN ISNULL(L.WAIT_COMPANY , A.FIELD_6) ELSE A.FIELD_6 END FIELD_6 --���ǵ�,M���� ������ ��ΰ�/�ΰ� �ڽ� �ϰ�� ��ùݿ�  
       , A.REG_DT    
       , A.PAYF    
       , A.PAYFROM    
       , A.PAYTO    
       , A.START_DT    
       , A.FINDCODE    
       , CASE WHEN A.POSITION_CODE IN('WJ010301','MJ010301','MJ010302') THEN ISNULL(L.WAIT_LOGO , A.PUB_LOGO) ELSE A.PUB_LOGO END PUB_LOGO  --���ǵ�,M���� ������ ��ΰ�/�ΰ� �ڽ� �ϰ�� ��ùݿ�  
       , A.PUB_CONFIRM    
       , A.BR_SEQ    
       , A.SUBDOMAIN    
       , A.COMPANY_NAME    
       , A.BR_TITLE    
       , A.BR_AREA    
       , A.PAYAMOUT    
       , A.PAY_TYPE    
       , A.LOGO_IMAGE    
       , A.DISPLAY_OPT    
       , A.RECRUIT_END_DT    
       , A.IMPACT_LOGO    
       , A.ICON_OPT    
       , A.USER_ID    
       , A.BRAND_NAME    
       , A.W_MAIN_BG_COLOR    
       , A.W_MAIN_MOUSEOVER_IMG    
       , A.THEME_IMG    
       , A.CUID    
       , A.VERSION    
       , A.MOD_DT    
       , A.GMAP_X    
       , A.GMAP_Y    
       , A.PAY_POSSIBLE    
       , A.PAY_COMPANY_RULES    
       , A.WORKTIMEF    
       , A.WORKTIMEFROM    
       , A.WORKTIMETO    
       , A.REGULAREMPF    
       , A.UPRIGHT_AGREE    
       , A.AGEF    
       , A.AGEFROM    
       , A.AGETO    
       --, A.SUBWAY_CODE    
       --, A.GATE_NUMBER    
       , A.OPT_CODE    
       , A.MOBILE_OPT_CODE    
       , A.PAPER_OPT    
       , A.GROUP_CD    
       , A.DISPLAY_ORDER    
       , A.DAY_WEEK    
       , A.SERVICE_PERIOD    
       , A.OPT_START_DT    
       , A.OPT_END_DT    
       , A.SEXF    
       --, dbo.FN_DATE_TO_CHAR12(A.OPT_START_DT) AS REP_OPT_START_DT    
       --, dbo.FN_DATE_TO_CHAR12(A.OPT_END_DT) AS REP_OPT_END_DT    
       , dbo.FN_DATE_TO_CHAR12(A.REG_DT) AS REP_REG_DT    
       --, ISNULL(F1.GMAP_X, '0') AS REP_A_GMAP_X      -- �� X��ǥ    
       --, ISNULL(F1.GMAP_Y, '0') AS REP_A_GMAP_Y      -- �� Y��ǥ    
       --, ISNULL(F2.GMAP_X, '0') AS REP_B_GMAP_X      -- �� X��ǥ    
       --, ISNULL(F2.GMAP_Y, '0') AS REP_B_GMAP_Y      -- �� Y��ǥ    
       --, ISNULL(F3.GMAP_X, '0') AS REP_C_GMAP_X      -- �� X��ǥ    
       --, ISNULL(F3.GMAP_Y, '0') AS REP_C_GMAP_Y      -- �� Y��ǥ    
       --, CAST(LEFT(REPLACE(A.GMAP_X, '.', ''), 9) AS INT) AS REP_GMAP_X    
       --, CAST(LEFT(REPLACE(A.GMAP_Y, '.', ''), 8) AS INT) AS REP_GMAP_Y    
       , A.ARR_FINDCODE_NM    
       , A.ARR_FINDCODE     
       , A.ARR_AREA    
       , A.ARR_AREACODE    
       , CASE WHEN A.DAY_WEEK IN (1, 2, 4, 5, 6) THEN 1       -- �ٹ���: ��4~6��    
              WHEN A.DAY_WEEK IN (7, 8, 9) THEN 2             -- �ٹ���: ��1~3��    
              WHEN A.DAY_WEEK = 3 THEN 3                      -- �ٹ���: �ָ�    
              ELSE A.DAY_WEEK                                 -- �ٹ���: ���ǰ��� (=10)    
              END AS DAY_WEEK_MB    
       , CASE WHEN (ISNULL(A.WORKTIMETO,0) - ISNULL(A.WORKTIMEFROM,0)) >= 500 THEN 1    
              WHEN (ISNULL(A.WORKTIMETO,0) - ISNULL(A.WORKTIMEFROM,0)) <= 400 AND (ISNULL(A.WORKTIMETO,0) - ISNULL(A.WORKTIMEFROM,0)) > 0 THEN 2    
              ELSE 0    
              END AS WORKTIME_TERMF    
       , (ISNULL(A.WORKTIMETO,0) - ISNULL(A.WORKTIMEFROM,0)) / 100 AS WORKTIME_TERM    
       , CASE WHEN A.WORKTIMEFROM > A.WORKTIMETO THEN CASE WHEN (A.WORKTIMETO + 2400) - A.WORKTIMEFROM > 400 THEN 1 ELSE 0 END     
              ELSE CASE WHEN A.WORKTIMETO - A.WORKTIMEFROM > 400 THEN 1 ELSE 0 END     
              END AS TIME_LONG       -- ��Ⱓ �ٹ�    
       , CASE WHEN A.WORKTIMEFROM > A.WORKTIMETO THEN CASE WHEN (A.WORKTIMETO + 2400) - A.WORKTIMEFROM <= 400 THEN 1 ELSE 0 END     
              ELSE CASE WHEN A.WORKTIMETO - A.WORKTIMEFROM <= 400 THEN 1 ELSE 0 END     
              END AS TIME_SHORT      -- �ܱⰣ �ٹ�    
       ,E.AREA_COUNT  
       ,D.DAY_WEEK_OPTION2 AS WEEK_OPTION2
    FROM PP_LINE_AD_GOODS_TB A WITH(NOLOCK)    
    LEFT JOIN CC_LOCATION_CENTER_COORDINATE_TB AS F1 ON F1.AREA_A = A.AREA_A AND F1.AREA_B IS NULL    
    LEFT JOIN CC_LOCATION_CENTER_COORDINATE_TB AS F2 ON F2.AREA_A = A.AREA_A AND F2.AREA_B = A.AREA_B AND F2.AREA_C IS NULL    
    LEFT JOIN CC_LOCATION_CENTER_COORDINATE_TB AS F3 ON F3.AREA_A = A.AREA_A AND F3.AREA_B = A.AREA_B AND F3.AREA_C = A.AREA_DONG    
    LEFT JOIN PP_LOGO_OPTION_TB AS L ON L.LINEADID = A.LINEADID AND L.INPUT_BRANCH = A.INPUT_BRANCH AND L.LAYOUT_BRANCH = A.LAYOUT_BRANCH  
    LEFT JOIN PP_LINE_AD_AREA_1DAY_TB AS E WITH(NOLOCK) ON E.LINEADID = A.LINEADID AND E.INPUT_BRANCH = A.INPUT_BRANCH AND E.LAYOUT_BRANCH = A.LAYOUT_BRANCH AND E.[ORDER] =1  
    LEFT JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB D WITH(NOLOCK) ON D.LINEADID = A.LINEADID AND D.INPUT_BRANCH = A.INPUT_BRANCH AND D.LAYOUT_BRANCH = A.LAYOUT_BRANCH

  