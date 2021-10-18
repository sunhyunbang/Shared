      
      
/*************************************************************************************      
 *  단위 업무 명 : 구인광고관리 > 광고 리스트      
 *  작   성   자 : 이 근 우(stari@mediawill.com)      
 *  작   성   일 : 2013/08/15      
 *  수   정   자 : 주 기 찬      
 *  수   정   일 : 2020/10/15      
 *  설        명 : 일자리 등록 개선에 추가된 컬럼들을 추가   
 *  수   정   자 : 방순현        
 *  수   정   일 : 2021/10/12 
 *  수 정 내  용 : 로고검수 프로세스 개선 
 *  주 의  사 항 :      
 *  사 용  소 스 :      
 *  사 용  예 제 :      
  041 041      
       
  EXEC  GET_F_JOB_AD_DETAIL_PROC NULL,1008167949,41,41,'PaperJob','FrontAdDetail','192.168.77.196'      
  EXEC GET_F_JOB_AD_DETAIL_PROC '', '1123', '183', '180', 'PaperJob', 'FrontAdDetail'      
    EXEC  GET_F_JOB_AD_DETAIL_PROC_BK20181121 NULL,3520605,181,180,'PaperJob','FrontAdDetail','192.168.77.196'      
 *************************************************************************************/      
ALTER PROCEDURE [dbo].[GET_F_JOB_AD_DETAIL_PROC]      
  @CUID             INT           = NULL      
, @LINEADID             INT               = 0      
, @INPUT_BRANCH         TINYINT          = 0      
, @LAYOUT_BRANCH        TINYINT          = 0      
, @ADGBN                VARCHAR(10)       = ''      -- 광고구분(1:E-COMM, 2:등록대행, PaperJob:신문)      
, @PAGE_MODE            VARCHAR(15)       = ''      -- 페이지 구분(AdminUserMag : 관리자에서 상세보기, 그외는 프론트 구인광고관리, 유저용 상세화면)      
, @CLIENT_IP            VARCHAR(20)       = ''      
AS      
BEGIN      
      
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;      
 SET NOCOUNT ON;      
      
  IF EXISTS(SELECT * FROM LOGDB.DBO.BAD_CLICK_IP_NOW_TB WITH(NOLOCK)  WHERE CLIENT_IP = @CLIENT_IP)   BEGIN    SELECT 1 WHERE 1=2    RETURN    END      
      
  -- UNIQUEKEY(LINEADNO) 생성      
  DECLARE @LINEADNO CHAR(16)      
  SET @LINEADNO = dbo.FN_LINEADNO(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH)      
      
      
  IF (@ADGBN = '1' OR @ADGBN = '2') AND @PAGE_MODE != 'AdminUserMag'      
  BEGIN      
    IF @CUID = 0 OR @CUID IS NULL      
    BEGIN      
      RETURN;      
    END      
  END      
      
  -- E-COMM 광고      
  IF @ADGBN = '1'      
  BEGIN      
    SELECT ISNULL(D.WAIT_TITLE , A.TITLE) AS TITLE      
          ,REPLACE(ISNULL(D.WAIT_COMPANY , A.FIELD_6), CHAR(13) + CHAR(10), '') AS FIELD_6      
          ,C.URL      
          ,A.START_DT      
          ,A.END_DT      
          ,C.RECRUIT_END_DT      
          ,A.ORDER_NAME      
          ,C.PHONE1_VIEWF      
          ,C.PHONE1      
          ,C.PHONE2_VIEWF      
          ,C.PHONE2      
          ,NULL AS VNSNO     -- 신문데이터에는 존재함      
          ,C.EMAIL_VIEWF      
          ,C.EMAIL      
          ,C.PHONEF      
          ,C.PHONE      
          ,C.MOBILEF      
          ,C.MOBILE      
          ,C.EMAILF      
          ,C.URLF      
          ,C.VISITF      
          ,B.EX_IMAGE_1      
          ,B.EX_IMAGE_2      
          ,B.EX_IMAGE_3      
          ,B.EX_IMAGE_4      
          ,D.PUB_LOGO      
          ,C.PARTTIMEF      
          ,C.WORK_MAIN      
          ,C.WORK_SUB      
          ,C.WORK_OUT      
          ,C.PAYF      
          ,C.PAYFROM      
          ,C.PAYTO      
          ,C.PAY_POSSIBLE      
          ,C.PAYTYPE      
          ,C.WORKTIMEF      
          ,C.WORKTIMEFROM      
          ,C.WORKTIMETO      
          ,C.CAREERF      
          ,C.CAREERFROM      
          ,C.CAREERTO      
          ,C.EDULEVEL      
          ,C.AGEF      
          ,C.AGE      
          ,C.AGEFROM      
          ,C.AGETO      
          ,C.AGESUB_JUBU      
          ,C.AGESUB_MIDDLE      
          ,C.AGESUB_MINORITY      
          ,C.SEXF      
          ,E.EC_CHOBO      
          ,E.EC_JUBU      
          ,E.EC_JANGNYUN      
          ,E.EC_JANGAE      
          ,E.EC_HUHAK      
          ,E.EC_WOIKUK      
          ,E.EC_GYOPO      
          ,E.EC_DONGJONG      
          ,E.EC_ENGLISH      
          ,E.EC_CHINESE      
          ,E.EC_AUTOLICENSE      
          ,E.EC_BIKELICENSE      
          ,E.EC_CAROWNER      
          ,E.EC_COMPUTER      
          ,E.EC_LONGTIME      
          ,E.EC_INGUNE      
          ,E.EC_ABOUTLICENSE      
          ,E.EC_ARMY      
          ,E.EC_SUKSIK      
          ,E.EX_SUBWORK      
      ,CASE WHEN ISNUMERIC(A.FIELD_3) = 1 THEN A.FIELD_3 ELSE '' END AS FIELD_3      
          ,B.HTML_FLAG      
          ,ISNULL(A.CONTENTS,'') AS CONTENTS      
          ,ISNULL(B.EX_CONTENTS,'') AS EX_CONTENTS      
          ,A.USER_ID      
     ,A.AREA_A      
          ,A.AREA_B      
          ,A.AREA_C      
          ,A.AREA_DETAIL      
          ,B.MAP_X      
          ,B.MAP_Y      
          ,B.GMAP_X      
          ,B.GMAP_Y      
          ,A.PHONE AS BASE_PHONE      
          ,A.ORDER_EMAIL      
          ,D.WAIT_LOGO      
          ,A.FIELD_2      
          ,dbo.FN_AD_PUBLISH_NEW(      
                                  A.LINEADID,       
                                  A.INPUT_BRANCH,       
                                  A.LAYOUT_BRANCH,       
                                  A.START_DT,       
                                  A.END_DT,       
                                  C.RECRUIT_END_DT,       
                                  G.STATUS,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.PrnAmtOk END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.ChargeKind END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.InipayTid END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.CancelDate END,       
                                  A.ENDYN,       
                                  A.DELYN,      
                                  PL.lineadid      
                                  ) AS PUBLISH_KIND      
          ,C.HOMEF      
          ,NULL AS BOX_IMAGE      
          ,A.FINDCODE      
          ,H.CodeNm1 + ' > ' + H.CodeNm2 + ' > ' + H.CodeNm3 + ' > ' + H.CodeNm4 AS FINDCODENAME      
          ,NULL AS LAYOUTCODENAME      
          ,NULL AS LAYOUTCODE      
        ,I.ORDER_DT      
          ,NULL AS [VERSION]      
          ,C.MAINBIZ      
          ,C.REGULAREMPF      
          ,C.ONLINEF      
          -- 신매체 영업 요청 회사정보 항목 (2013.11.18)      
          ,C.CI_ZIPID      
          ,J.Metro AS CI_AREA_A      
          ,J.City AS CI_AREA_B      
          ,J.Dong AS CI_AREA_C      
          ,C.CI_ADDRDETAIL      
          ,A.FIELD_11      
          -- 브랜드관 항목      
          ,BR.BRAND_NAME      
          ,BR.SUBDOMAIN      
          ,A.MOD_DT      
          ,C.SERVICE_PERIOD      
          ,C.SUBMIT_DOC      
          ,0 AS VNSUSEF      
          ,C.WORK_APPOINT      
     ,DBO.FN_GET_JOB_BENEFIT_NAME(E.JOB_BENEFIT) AS JOB_BENEFIT -- 복리후생 추가(2015.05.21)      
     ,C.PTN_COMPANY_NM      
     ,C.PTN_WORKER_NUM      
     ,CASE WHEN SC.ADID IS NOT NULL THEN 'on' ELSE '' END AS SCRAP_YN      
     ,B.RV_PANOID      
     ,B.RV_ANGLEID      
       ,A.AREA_A + ' ' + A.AREA_B + ' ' + A.AREA_C + ' ' +       
     STUFF( ( SELECT ', ' + CODENM4 FROM (       
       SELECT DISTINCT       
       ISNULL(CASE WHEN C.IDX = 1 THEN CODENM2      
        WHEN C.IDX = 2 THEN CODENM3      
        WHEN C.IDX = 3 THEN CODENM4      
       END ,'') AS CODENM4      
        FROM DBO.PP_FINDCODE_TB A1 WITH(NOLOCK)      
        INNER JOIN PP_LINE_AD_FINDCODE_TB A2 WITH(NOLOCK) ON A1.CODE4 = A2.FINDCODE AND A1.USEFLAG ='Y'      
        INNER JOIN COPY_T_TB C WITH(NOLOCK) ON C.IDX < 4      
        WHERE A2.LINEADID = @LINEADID  AND A2.INPUT_BRANCH  = @INPUT_BRANCH  AND A2.LAYOUT_BRANCH  =  @LAYOUT_BRANCH      
      )S FOR XML PATH ('')),1,2,'') AS METAKEYWORD      
          ,A.LINEADID AS PARTNERSHIP_NO      
          ,A.CUID      
          ,C.UPRIGHT_AGREE      
          ,C.WORK_FREELANCER      
          ,C.PAY_COMPANY_RULES      
          ,C.PAY_COMPANY_RULES_ETC      
          ,C.FAXF      
          ,C.FAX      
          ,C.DAY_WEEK      
          ,C.DAY_WEEK_OPTION      
          ,C.DAY_WEEK_OPTION_ETC      
          ,C.CI_BIZNO      
      
        
  /*일자리 등록 프로세스 개선 관련 추가 사항*/      
  ,C.WORK_TAKE_CHARGE       
  ,ISNULL(C.ADDRESS_JIBUN,'  ') as ADDRESS_JIBUN      
  ,C.ADDRESS_ROAD      
  ,C.ADDRESS_DETAIL      
  ,C.ADDRESS_AREA_CODE      
  ,C.DAY_WEEK_OPTION2      
  ,C.RESTTIMEF      
  ,C.REAL_WORKTIME      
  ,C.REAL_WORKTIMEDISPLAY      
  ,C.CI_ADDRESS_JIBUN      
  ,C.CI_ADDRESS_ROAD      
  ,C.WORKTIME_CODE      
  ,C.PAYTO_OVERF      
  ,C.COMPANY_URL          
  ,(CASE WHEN ISNULL(C.REAL_WORKTIME, 0) > 0 THEN CONVERT(FLOAT, C.REAL_WORKTIME) / 60 ELSE 0 END) AS REAL_WORKTIME2 --실제 근무시간 분단위에서 시간단위로 변환      
  ,C.MAP_VIEW_YN --지도노출여부  
  ,C.OUTF -- 외근직추가  
    FROM PP_AD_TB A WITH (NOLOCK)      
      JOIN PP_LINE_AD_EXTEND_DETAIL_TB B WITH (NOLOCK)      
        ON A.LINEADID = B.LINEADID AND A.INPUT_BRANCH = B.INPUT_BRANCH AND A.LAYOUT_BRANCH = B.LAYOUT_BRANCH      
      JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_TB C WITH (NOLOCK)      
        ON A.LINEADID = C.LINEADID AND A.INPUT_BRANCH = C.INPUT_BRANCH AND A.LAYOUT_BRANCH = C.LAYOUT_BRANCH      
      LEFT JOIN PP_LOGO_OPTION_TB D WITH (NOLOCK)      
        ON A.LINEADID = D.LINEADID AND A.INPUT_BRANCH = D.INPUT_BRANCH AND A.LAYOUT_BRANCH = D.LAYOUT_BRANCH      
      LEFT JOIN PP_AD_EC_DATA_JOB_TB E WITH (NOLOCK)      
        ON A.LINEADID = E.LINEADID AND A.INPUT_BRANCH = E.INPUT_BRANCH AND A.LAYOUT_BRANCH = E.LAYOUT_BRANCH      
      LEFT JOIN PP_ECOMM_RECCHARGE_TB F WITH (NOLOCK)      
        ON A.LINEADID = F.ADID AND F.PRODUCT_GBN = 1      
      LEFT JOIN PP_FREE_AD_CONFIRM_TB G WITH (NOLOCK)      
        ON A.LINEADID = G.LINEADID AND A.INPUT_BRANCH = G.INPUT_BRANCH AND A.LAYOUT_BRANCH = G.LAYOUT_BRANCH      
      LEFT JOIN DBO.PP_FINDCODE_TB AS H WITH (NOLOCK)      
        ON A.FINDCODE = H.CODE4      
      LEFT JOIN PP_LISTUP_ORDER_JOB_TB I WITH (NOLOCK)      
        ON A.LINEADID = I.LINEADID AND A.INPUT_BRANCH = I.INPUT_BRANCH AND A.LAYOUT_BRANCH = I.LAYOUT_BRANCH      
      LEFT JOIN PAPERREG.DBO.ZIPCODE AS J WITH (NOLOCK)      
        ON  J.ZipId = C.CI_ZIPID      
      LEFT JOIN (SELECT B.LINEADID, B.INPUT_BRANCH, B.LAYOUT_BRANCH, A.BRAND_NAME, A.SUBDOMAIN, B.LINEADNO      
                   FROM PP_BRAND_TB AS A WITH (NOLOCK)      
                   JOIN PP_BRAND_AD_TB AS B WITH (NOLOCK)      
                     ON B.BR_SEQ = A.BR_SEQ      
                  WHERE A.USE_YN = 'Y') AS BR      
        ON A.LINEADID = BR.LINEADID AND A.INPUT_BRANCH = BR.INPUT_BRANCH AND A.LAYOUT_BRANCH = BR.LAYOUT_BRANCH      
   LEFT JOIN PP_USER_SCRAP_TB AS SC WITH (NOLOCK)      
    ON SC.CUID = @CUID AND SC.ADID = A.LINEADID AND SC.INPUT_BRANCH = A.INPUT_BRANCH AND SC.LAYOUT_BRANCH = A.LAYOUT_BRANCH      
      LEFT JOIN PP_LINE_AD_TB PL WITH (NOLOCK)      
        ON A.LINEADID = PL.LINEADID AND A.INPUT_BRANCH = PL.INPUT_BRANCH AND A.LAYOUT_BRANCH = PL.LAYOUT_BRANCH      
     WHERE A.LINEADNO = @LINEADNO      
      
  END      
      
  -- 등록대행 광고      
  ELSE IF @ADGBN = '2'      
  BEGIN      
      
    SELECT ISNULL(D.WAIT_TITLE , A.TITLE) AS TITLE      
          ,REPLACE(ISNULL(D.WAIT_COMPANY , A.FIELD_6), CHAR(13) + CHAR(10), '') AS FIELD_6          
          ,C.URL      
          ,A.START_DT      
          ,A.END_DT      
          ,C.RECRUIT_END_DT      
          ,A.ORDER_NAME      
          ,C.PHONE1_VIEWF      
          ,C.PHONE1      
          ,C.PHONE2_VIEWF      
          ,C.PHONE2      
          ,NULL AS VNSNO     -- 신문데이터에는 존재함      
          ,C.EMAIL_VIEWF      
          ,C.EMAIL      
          ,C.PHONEF      
          ,C.PHONE      
          ,C.MOBILEF      
          ,C.MOBILE      
          ,C.EMAILF      
          ,C.URLF      
          ,C.VISITF      
          ,B.EX_IMAGE_1      
          ,B.EX_IMAGE_2      
          ,B.EX_IMAGE_3      
          ,B.EX_IMAGE_4      
          ,D.PUB_LOGO      
          ,C.PARTTIMEF      
          ,C.WORK_MAIN      
          ,C.WORK_SUB      
          ,C.WORK_OUT      
          ,C.PAYF      
          ,C.PAYFROM      
          ,C.PAYTO      
          ,C.PAY_POSSIBLE      
          ,C.PAYTYPE      
          ,C.WORKTIMEF      
          ,C.WORKTIMEFROM      
          ,C.WORKTIMETO      
          ,C.CAREERF      
          ,C.CAREERFROM      
          ,C.CAREERTO      
          ,C.EDULEVEL      
          ,C.AGEF      
          ,C.AGE      
          ,C.AGEFROM      
          ,C.AGETO      
          ,C.AGESUB_JUBU      
          ,C.AGESUB_MIDDLE      
          ,C.AGESUB_MINORITY      
          ,C.SEXF      
          ,E.EC_CHOBO      
          ,E.EC_JUBU      
          ,E.EC_JANGNYUN      
          ,E.EC_JANGAE      
          ,E.EC_HUHAK      
          ,E.EC_WOIKUK      
          ,E.EC_GYOPO      
          ,E.EC_DONGJONG      
          ,E.EC_ENGLISH      
          ,E.EC_CHINESE      
          ,E.EC_AUTOLICENSE      
          ,E.EC_BIKELICENSE      
          ,E.EC_CAROWNER      
          ,E.EC_COMPUTER      
          ,E.EC_LONGTIME      
          ,E.EC_INGUNE      
     ,E.EC_ABOUTLICENSE      
          ,E.EC_ARMY      
          ,E.EC_SUKSIK      
          ,E.EX_SUBWORK      
          ,CASE WHEN ISNUMERIC(A.FIELD_3) = 1 THEN A.FIELD_3 ELSE '' END AS FIELD_3      
          ,B.HTML_FLAG      
          ,ISNULL(A.CONTENTS,'') AS CONTENTS      
          ,ISNULL(B.EX_CONTENTS,'') AS EX_CONTENTS      
          ,ISNULL(A.USER_ID, J.USERID) AS USER_ID      
          ,A.AREA_A      
          ,A.AREA_B      
          ,A.AREA_C      
          ,A.AREA_DETAIL      
          ,B.MAP_X      
          ,B.MAP_Y      
          ,B.GMAP_X      
          ,B.GMAP_Y      
          ,A.PHONE AS BASE_PHONE      
          ,A.ORDER_EMAIL      
          ,D.WAIT_LOGO      
          ,A.FIELD_2      
--          ,dbo.FN_AD_PUBLISH_NEW(A.LINEADID, A.INPUT_BRANCH, A.LAYOUT_BRANCH, A.START_DT, A.END_DT, C.RECRUIT_END_DT, G.STATUS, F.PrnAmtOk, F.ChargeKind, F.InipayTid, F.CancelDate) AS PUBLISH_KIND      
          ,dbo.FN_AD_PUBLISH_NEW(      
                                  A.LINEADID,       
                                  A.INPUT_BRANCH,       
                                  A.LAYOUT_BRANCH,       
                                  A.START_DT,       
                                  A.END_DT,       
                                  C.RECRUIT_END_DT,       
                                  G.STATUS,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.PrnAmtOk END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.ChargeKind END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.InipayTid END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.CancelDate END,       
                                  A.ENDYN,       
                                  A.DELYN,      
                                  PL.lineadid      
                                  ) AS PUBLISH_KIND      
          ,C.HOMEF      
          ,NULL AS BOX_IMAGE      
          ,A.FINDCODE      
          ,H.CodeNm1 + ' > ' + H.CodeNm2 + ' > ' + H.CodeNm3 + ' > ' + H.CodeNm4 AS FINDCODENAME      
          ,NULL AS LAYOUTCODENAME      
          ,NULL AS LAYOUTCODE      
        ,I.ORDER_DT      
          ,NULL AS [VERSION]      
          ,C.MAINBIZ      
          ,C.REGULAREMPF      
          ,C.ONLINEF      
          -- 신매체 영업 요청 회사정보 항목 (2013.11.18)      
          ,C.CI_ZIPID      
          ,K.Metro AS CI_AREA_A      
          ,K.City AS CI_AREA_B      
          ,K.Dong AS CI_AREA_C      
          ,C.CI_ADDRDETAIL      
          ,A.FIELD_11      
          -- 브랜드관 항목 (E-Comm외 광고는 NULL값)      
          ,NULL AS BRAND_NAME      
          ,NULL AS SUBDOMAIN      
          ,A.MOD_DT      
          ,C.SERVICE_PERIOD      
          ,C.SUBMIT_DOC      
          ,0 AS VNSUSEF      
          ,C.WORK_APPOINT      
     ,DBO.FN_GET_JOB_BENEFIT_NAME(E.JOB_BENEFIT) AS JOB_BENEFIT -- 복리후생 추가(2015.05.21)      
     ,C.PTN_COMPANY_NM      
     ,C.PTN_WORKER_NUM      
     ,CASE WHEN SC.ADID IS NOT NULL THEN 'on' ELSE '' END AS SCRAP_YN      
     ,B.RV_PANOID      
     ,B.RV_ANGLEID      
       ,A.AREA_A + ' ' + A.AREA_B + ' ' + A.AREA_C + ' ' +       
     STUFF( ( SELECT ', ' + CODENM4 FROM (       
       SELECT DISTINCT       
       ISNULL(CASE WHEN C.IDX = 1 THEN CODENM2      
        WHEN C.IDX = 2 THEN CODENM3      
        WHEN C.IDX = 3 THEN CODENM4      
       END ,'') AS CODENM4      
        FROM DBO.PP_FINDCODE_TB A1 WITH(NOLOCK)      
        INNER JOIN PP_LINE_AD_FINDCODE_TB A2 WITH(NOLOCK) ON A1.CODE4 = A2.FINDCODE AND A1.USEFLAG ='Y'      
        INNER JOIN COPY_T_TB C WITH(NOLOCK) ON C.IDX < 4      
        WHERE A2.LINEADID = @LINEADID  AND A2.INPUT_BRANCH  = @INPUT_BRANCH  AND A2.LAYOUT_BRANCH  =  @LAYOUT_BRANCH      
      )S FOR XML PATH ('')),1,2,'') AS METAKEYWORD      
          ,A.LINEADID AS PARTNERSHIP_NO      
          ,A.CUID      
          ,C.UPRIGHT_AGREE      
          ,C.WORK_FREELANCER      
          ,C.PAY_COMPANY_RULES      
          ,C.PAY_COMPANY_RULES_ETC      
          ,C.FAXF      
          ,C.FAX      
          ,C.DAY_WEEK      
          ,C.DAY_WEEK_OPTION      
          ,C.DAY_WEEK_OPTION_ETC      
          ,C.CI_BIZNO      
         
   /*일자리 등록 프로세스 개선 관련 추가 사항*/      
   ,C.WORK_TAKE_CHARGE       
   ,ISNULL(C.ADDRESS_JIBUN,'  ') AS ADDRESS_JIBUN      
   ,C.ADDRESS_ROAD      
   ,C.ADDRESS_DETAIL      
   ,C.ADDRESS_AREA_CODE      
   ,C.DAY_WEEK_OPTION2      
   ,C.RESTTIMEF      
   ,C.REAL_WORKTIME      
   ,C.REAL_WORKTIMEDISPLAY      
   ,C.CI_ADDRESS_JIBUN      
   ,C.CI_ADDRESS_ROAD      
   ,C.WORKTIME_CODE      
   ,C.PAYTO_OVERF      
   ,C.COMPANY_URL          
   ,(CASE WHEN ISNULL(C.REAL_WORKTIME, 0) > 0 THEN CONVERT(FLOAT, C.REAL_WORKTIME) / 60 ELSE 0 END) AS REAL_WORKTIME2 --실제 근무시간 분단위에서 시간단위로 변환      
   ,C.MAP_VIEW_YN --지도노출여부      
   ,C.OUTF -- 외근직추가  
      FROM PP_AD_TB A WITH (NOLOCK)      
      JOIN PP_LINE_AD_EXTEND_DETAIL_TB B WITH (NOLOCK) ON A.LINEADID = B.LINEADID AND A.INPUT_BRANCH = B.INPUT_BRANCH AND A.LAYOUT_BRANCH = B.LAYOUT_BRANCH      
      JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_TB C WITH (NOLOCK) ON A.LINEADID = C.LINEADID AND A.INPUT_BRANCH = C.INPUT_BRANCH AND A.LAYOUT_BRANCH = C.LAYOUT_BRANCH      
      LEFT JOIN PP_LOGO_OPTION_TB D WITH (NOLOCK) ON A.LINEADID = D.LINEADID AND A.INPUT_BRANCH = D.INPUT_BRANCH AND A.LAYOUT_BRANCH = D.LAYOUT_BRANCH      
      LEFT JOIN PP_AD_EC_DATA_JOB_TB E WITH (NOLOCK) ON A.LINEADID = E.LINEADID AND A.INPUT_BRANCH = E.INPUT_BRANCH AND A.LAYOUT_BRANCH = E.LAYOUT_BRANCH      
      LEFT JOIN PP_ECOMM_RECCHARGE_TB F WITH (NOLOCK) ON A.LINEADID = F.ADID AND F.PRODUCT_GBN = 1      
      LEFT JOIN PP_FREE_AD_CONFIRM_TB G WITH (NOLOCK) ON A.LINEADID = G.LINEADID AND A.INPUT_BRANCH = G.INPUT_BRANCH AND A.LAYOUT_BRANCH = G.LAYOUT_BRANCH      
      LEFT JOIN DBO.PP_FINDCODE_TB AS H  WITH (NOLOCK) ON A.FINDCODE = H.CODE4      
      LEFT JOIN PP_LISTUP_ORDER_JOB_TB I WITH (NOLOCK) ON A.LINEADID = I.LINEADID AND A.INPUT_BRANCH = I.INPUT_BRANCH AND A.LAYOUT_BRANCH = I.LAYOUT_BRANCH      
      LEFT JOIN PP_AD_USER_MATCHING_TB J WITH (NOLOCK) ON A.LINEADID = J.LINEADID AND A.INPUT_BRANCH = J.INPUT_BRANCH AND A.LAYOUT_BRANCH = J.LAYOUT_BRANCH      
      LEFT JOIN PAPERREG.DBO.ZIPCODE AS K  WITH (NOLOCK) ON  K.ZipId = C.CI_ZIPID      
   LEFT JOIN PP_USER_SCRAP_TB AS SC WITH (NOLOCK)      
    ON SC.CUID = @CUID AND SC.ADID = A.LINEADID AND SC.INPUT_BRANCH = A.INPUT_BRANCH AND SC.LAYOUT_BRANCH = A.LAYOUT_BRANCH      
      LEFT JOIN PP_LINE_AD_TB PL WITH (NOLOCK)      
        ON A.LINEADID = PL.LINEADID AND A.INPUT_BRANCH = PL.INPUT_BRANCH AND A.LAYOUT_BRANCH = PL.LAYOUT_BRANCH      
     WHERE A.LINEADNO = @LINEADNO      
      
  END      
      
  -- 신문 광고      
  ELSE IF @ADGBN = 'PaperJob'      
  BEGIN      
  IF NOT EXISTS (SELECT LINEADID FROM PP_LINE_AD_TB WITH(NOLOCK) WHERE LINEADNO = @LINEADNO) AND EXISTS (SELECT APP_ID FROM dbo.PG_APP_MAIN_TB WITH(NOLOCK) WHERE LINEADNO = @LINEADNO AND CUID = @CUID)      
    --IF EXISTS (SELECT APP_ID FROM dbo.PG_APP_MAIN_TB WITH(NOLOCK) WHERE LINEADNO = @LINEADNO AND USER_ID = @USER_ID)      
    BEGIN      
   SELECT ISNULL(D.WAIT_TITLE , A.TITLE) AS TITLE      
      ,REPLACE(ISNULL(D.WAIT_COMPANY , A.FIELD_6), CHAR(13) + CHAR(10), '') AS FIELD_6      
      ,C.URL      
      ,A.START_DT      
      ,A.END_DT      
      ,C.RECRUIT_END_DT      
      ,A.ORDER_NAME      
      ,C.PHONE1_VIEWF      
      ,C.PHONE1      
      ,C.PHONE2_VIEWF      
      ,C.PHONE2      
      ,A.VNSNO     -- 신문데이터에는 존재함      
      ,C.EMAIL_VIEWF      
      ,C.EMAIL      
      ,C.PHONEF      
      ,C.PHONE      
      ,C.MOBILEF      
      ,C.MOBILE      
      ,C.EMAILF      
      ,C.URLF      
      ,C.VISITF      
      ,B.EX_IMAGE_1      
      ,B.EX_IMAGE_2      
      ,B.EX_IMAGE_3      
      ,B.EX_IMAGE_4      
      ,D.PUB_LOGO      
      ,C.PARTTIMEF      
      ,C.WORK_MAIN      
      ,C.WORK_SUB      
      ,C.WORK_OUT      
      ,C.PAYF      
      ,C.PAYFROM      
      ,C.PAYTO      
            ,C.PAY_POSSIBLE      
      ,C.PAYTYPE      
      ,C.WORKTIMEF      
      ,C.WORKTIMEFROM      
      ,C.WORKTIMETO      
      ,C.CAREERF      
      ,C.CAREERFROM      
      ,C.CAREERTO      
      ,C.EDULEVEL      
      ,C.AGEF      
      ,C.AGE      
      ,C.AGEFROM      
      ,C.AGETO      
      ,C.AGESUB_JUBU      
      ,C.AGESUB_MIDDLE      
      ,C.AGESUB_MINORITY      
      ,C.SEXF      
      ,E.EC_CHOBO      
      ,E.EC_JUBU          ,E.EC_JANGNYUN      
      ,E.EC_JANGAE      
      ,E.EC_HUHAK      
      ,E.EC_WOIKUK      
      ,E.EC_GYOPO      
      ,E.EC_DONGJONG      
      ,E.EC_ENGLISH      
      ,E.EC_CHINESE      
      ,E.EC_AUTOLICENSE      
      ,E.EC_BIKELICENSE      
      ,E.EC_CAROWNER      
      ,E.EC_COMPUTER      
      ,E.EC_LONGTIME      
      ,E.EC_INGUNE      
      ,E.EC_ABOUTLICENSE      
      ,E.EC_ARMY      
      ,E.EC_SUKSIK      
      ,E.EX_SUBWORK      
      ,CASE WHEN ISNUMERIC(A.FIELD_3) = 1 THEN A.FIELD_3 ELSE '' END AS FIELD_3      
      ,B.HTML_FLAG      
      ,ISNULL(A.CONTENTS,'') AS CONTENTS      
      ,ISNULL(B.EX_CONTENTS,'') AS EX_CONTENTS      
      ,NULL AS USER_ID      
      ,A.AREA_A      
      ,A.AREA_B      
      ,A.AREA_C      
      ,A.AREA_DETAIL      
      ,B.MAP_X      
      ,B.MAP_Y      
      ,B.GMAP_X      
      ,B.GMAP_Y      
      ,A.PHONE AS BASE_PHONE      
      ,A.ORDER_EMAIL      
      ,D.WAIT_LOGO      
      ,A.FIELD_2      
--      ,dbo.FN_AD_PUBLISH(A.LINEADID, A.INPUT_BRANCH, A.LAYOUT_BRANCH, A.START_DT, A.END_DT, C.RECRUIT_END_DT, G.STATUS, F.PrnAmtOk, F.ChargeKind, F.InipayTid, F.CancelDate) AS PUBLISH_KIND      
               ,dbo.FN_AD_PUBLISH_NEW(      
                                  A.LINEADID,       
                                  A.INPUT_BRANCH,       
                                  A.LAYOUT_BRANCH,       
                                  A.START_DT,       
                                  A.END_DT,       
                                  C.RECRUIT_END_DT,       
                                  G.STATUS,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.PrnAmtOk END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.ChargeKind END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.InipayTid END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.CancelDate END,       
                                  A.ENDYN,       
                                  A.DELYN,      
                                  PL.lineadid      
                                  ) AS PUBLISH_KIND      
      ,C.HOMEF      
      ,A.BOX_IMAGE      
      ,A.FINDCODE      
            ,H.CodeNm1 + ' > ' + H.CodeNm2 + ' > ' + H.CodeNm3 + ' > ' + H.CodeNm4 AS FINDCODENAME      
            ,NULL AS LAYOUTCODENAME      
      ,A.LAYOUTCODE      
         ,I.ORDER_DT      
      ,A.VERSION      
      ,C.MAINBIZ      
      ,C.REGULAREMPF      
      ,C.ONLINEF      
      ,C.CI_ZIPID      
      ,K.Metro AS CI_AREA_A      
      ,K.City AS CI_AREA_B      
      ,K.Dong AS CI_AREA_C      
      ,C.CI_ADDRDETAIL      
      ,A.FIELD_11      
            -- 브랜드관 항목 (E-Comm외 광고는 NULL값)      
            ,BR.BRAND_NAME      
            ,BR.SUBDOMAIN      
            ,A.MOD_DT      
            ,C.SERVICE_PERIOD      
            ,C.SUBMIT_DOC      
        ,A.VNSUSEF      
            ,C.WORK_APPOINT      
      ,DBO.FN_GET_JOB_BENEFIT_NAME(E.JOB_BENEFIT) AS JOB_BENEFIT -- 복리후생 추가(2015.05.21)      
      ,C.PTN_COMPANY_NM      
      ,C.PTN_WORKER_NUM      
      ,CASE WHEN SC.ADID IS NOT NULL THEN 'on' ELSE '' END AS SCRAP_YN      
      ,B.RV_PANOID      
      ,B.RV_ANGLEID      
       ,A.AREA_A + ' ' + A.AREA_B + ' ' + A.AREA_C + ' ' +       
     STUFF( ( SELECT ', ' + CODENM4 FROM (       
       SELECT DISTINCT       
       ISNULL(CASE WHEN C.IDX = 1 THEN CODENM2      
        WHEN C.IDX = 2 THEN CODENM3      
        WHEN C.IDX = 3 THEN CODENM4      
       END ,'') AS CODENM4      
        FROM DBO.PP_FINDCODE_TB A1 WITH(NOLOCK)      
        INNER JOIN PP_LINE_AD_FINDCODE_TB A2 WITH(NOLOCK) ON A1.CODE4 = A2.FINDCODE AND A1.USEFLAG ='Y'      
        INNER JOIN COPY_T_TB C WITH(NOLOCK) ON C.IDX < 4      
        WHERE A2.LINEADID = @LINEADID  AND A2.INPUT_BRANCH  = @INPUT_BRANCH  AND A2.LAYOUT_BRANCH  =  @LAYOUT_BRANCH      
      )S FOR XML PATH ('')),1,2,'') AS METAKEYWORD      
            ,A.LINEADID AS PARTNERSHIP_NO      
            ,A.CUID      
            ,C.UPRIGHT_AGREE      
            ,C.WORK_FREELANCER      
            ,C.PAY_COMPANY_RULES      
            ,C.PAY_COMPANY_RULES_ETC                ,C.FAXF      
            ,C.FAX      
            ,C.DAY_WEEK      
            ,C.DAY_WEEK_OPTION      
            ,C.DAY_WEEK_OPTION_ETC      
            ,C.CI_BIZNO      
      
         
   /*일자리 등록 프로세스 개선 관련 추가 사항*/      
   ,C.WORK_TAKE_CHARGE       
   ,ISNULL(C.ADDRESS_JIBUN,'  ') AS ADDRESS_JIBUN      
   ,C.ADDRESS_ROAD      
   ,C.ADDRESS_DETAIL      
   ,C.ADDRESS_AREA_CODE      
   ,C.DAY_WEEK_OPTION2      
   ,C.RESTTIMEF      
   ,C.REAL_WORKTIME      
   ,C.REAL_WORKTIMEDISPLAY      
   ,C.CI_ADDRESS_JIBUN      
   ,C.CI_ADDRESS_ROAD      
   ,C.WORKTIME_CODE      
   ,C.PAYTO_OVERF      
   ,C.COMPANY_URL          
   ,(CASE WHEN ISNULL(C.REAL_WORKTIME, 0) > 0 THEN CONVERT(FLOAT, C.REAL_WORKTIME) / 60 ELSE 0 END) AS REAL_WORKTIME2 --실제 근무시간 분단위에서 시간단위로 변환      
   ,C.MAP_VIEW_YN --지도노출여부      
   ,C.OUTF -- 외근직추가
    FROM PP_AD_TB A WITH (NOLOCK)      
        JOIN PP_LINE_AD_EXTEND_DETAIL_TB B WITH (NOLOCK) ON A.LINEADID = B.LINEADID AND A.INPUT_BRANCH = B.INPUT_BRANCH AND A.LAYOUT_BRANCH = B.LAYOUT_BRANCH      
    JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_TB C WITH (NOLOCK) ON A.LINEADID = C.LINEADID AND A.INPUT_BRANCH = C.INPUT_BRANCH AND A.LAYOUT_BRANCH = C.LAYOUT_BRANCH      
    LEFT JOIN PP_LOGO_OPTION_TB D WITH (NOLOCK) ON A.LINEADID = D.LINEADID AND A.INPUT_BRANCH = D.INPUT_BRANCH AND A.LAYOUT_BRANCH = D.LAYOUT_BRANCH      
    LEFT JOIN PP_AD_EC_DATA_JOB_TB E WITH (NOLOCK) ON A.LINEADID = E.LINEADID AND A.INPUT_BRANCH = E.INPUT_BRANCH AND A.LAYOUT_BRANCH = E.LAYOUT_BRANCH      
    --LEFT JOIN PP_ECOMM_RECCHARGE_TB F WITH (NOLOCK) ON A.LINEADID = F.ADID AND F.PRODUCT_GBN = 1      
        LEFT JOIN PP_ECOMM_RECCHARGE_TB F WITH (NOLOCK) ON A.LINEADID = F.ADID AND F.PRODUCT_GBN = 1 AND A.VERSION <> 'A'      
    LEFT JOIN PP_FREE_AD_CONFIRM_TB G WITH (NOLOCK) ON A.LINEADID = G.LINEADID AND A.INPUT_BRANCH = G.INPUT_BRANCH AND A.LAYOUT_BRANCH = G.LAYOUT_BRANCH      
        LEFT JOIN DBO.PP_FINDCODE_TB AS H ON A.FINDCODE = H.CODE4      
    LEFT JOIN PP_LISTUP_ORDER_JOB_TB I WITH (NOLOCK) ON A.LINEADID = I.LINEADID AND A.INPUT_BRANCH = I.INPUT_BRANCH AND A.LAYOUT_BRANCH = I.LAYOUT_BRANCH      
    LEFT JOIN PAPERREG.DBO.ZIPCODE AS K ON K.ZipId = C.CI_ZIPID      
        LEFT JOIN (SELECT B.LINEADID, B.INPUT_BRANCH, B.LAYOUT_BRANCH, A.BRAND_NAME, A.SUBDOMAIN, B.LINEADNO      
                     FROM PP_BRAND_TB AS A WITH (NOLOCK)      
                     JOIN PP_BRAND_AD_TB AS B WITH (NOLOCK)      
                       ON B.BR_SEQ = A.BR_SEQ      
                    WHERE A.USE_YN = 'Y') AS BR      
          ON A.LINEADID = BR.LINEADID AND A.INPUT_BRANCH = BR.INPUT_BRANCH AND A.LAYOUT_BRANCH = BR.LAYOUT_BRANCH      
    LEFT JOIN PP_USER_SCRAP_TB AS SC WITH (NOLOCK)      
     ON SC.CUID = @CUID AND SC.ADID = A.LINEADID AND SC.INPUT_BRANCH = A.INPUT_BRANCH AND SC.LAYOUT_BRANCH = A.LAYOUT_BRANCH      
        LEFT JOIN PP_LINE_AD_TB PL WITH(NOLOCK)      
          ON A.LINEADID = PL.LINEADID AND A.INPUT_BRANCH = PL.INPUT_BRANCH AND A.LAYOUT_BRANCH = PL.LAYOUT_BRANCH      
    WHERE A.LINEADNO = @LINEADNO      
    END      
    ELSE      
    BEGIN      
   SELECT ISNULL(D.WAIT_TITLE , A.TITLE) AS TITLE      
      ,REPLACE(ISNULL(D.WAIT_COMPANY , A.FIELD_6), CHAR(13) + CHAR(10), '') AS FIELD_6        
      ,C.URL      
      ,A.START_DT      
      ,A.END_DT      
      ,C.RECRUIT_END_DT      
      ,A.ORDER_NAME      
      ,C.PHONE1_VIEWF      
      ,C.PHONE1      
      ,C.PHONE2_VIEWF      
      ,C.PHONE2      
      ,A.VNSNO     -- 신문데이터에는 존재함      
      ,C.EMAIL_VIEWF      
      ,C.EMAIL      
      ,C.PHONEF      
      ,C.PHONE      
      ,C.MOBILEF      
      ,C.MOBILE      
      ,C.EMAILF      
      ,C.URLF      
      ,C.VISITF      
      ,A.EX_IMAGE_1      
      ,A.EX_IMAGE_2      
      ,A.EX_IMAGE_3      
      ,A.EX_IMAGE_4      
      ,D.PUB_LOGO      
      ,C.PARTTIMEF      
      ,C.WORK_MAIN      
      ,C.WORK_SUB      
      ,C.WORK_OUT      
      ,C.PAYF      
      ,C.PAYFROM      
      ,C.PAYTO      
            ,C.PAY_POSSIBLE      
      ,C.PAYTYPE      
      ,C.WORKTIMEF      
      ,C.WORKTIMEFROM      
      ,C.WORKTIMETO      
      ,C.CAREERF      
      ,C.CAREERFROM      
      ,C.CAREERTO      
      ,C.EDULEVEL      
      ,C.AGEF      
      ,C.AGE      
      ,C.AGEFROM      
      ,C.AGETO          ,C.AGESUB_JUBU      
      ,C.AGESUB_MIDDLE      
      ,C.AGESUB_MINORITY      
      ,C.SEXF      
      ,E.EC_CHOBO      
      ,E.EC_JUBU      
      ,E.EC_JANGNYUN      
      ,E.EC_JANGAE      
      ,E.EC_HUHAK      
      ,E.EC_WOIKUK      
      ,E.EC_GYOPO      
      ,E.EC_DONGJONG      
      ,E.EC_ENGLISH      
      ,E.EC_CHINESE      
      ,E.EC_AUTOLICENSE      
      ,E.EC_BIKELICENSE      
      ,E.EC_CAROWNER      
      ,E.EC_COMPUTER      
      ,E.EC_LONGTIME      
      ,E.EC_INGUNE      
      ,E.EC_ABOUTLICENSE      
      ,E.EC_ARMY      
      ,E.EC_SUKSIK      
      ,E.EX_SUBWORK      
      ,CASE WHEN ISNUMERIC(A.FIELD_3) = 1 THEN A.FIELD_3 ELSE '' END AS FIELD_3      
      ,A.HTML_FLAG      
      ,ISNULL(A.CONTENTS,'') AS CONTENTS      
      ,ISNULL(A.EX_CONTENTS,'') AS EX_CONTENTS      
      ,NULL AS USER_ID      
      ,A.AREA_A      
      ,A.AREA_B      
      ,A.AREA_C      
      ,A.AREA_DETAIL      
      ,A.MAP_X      
      ,A.MAP_Y      
      ,A.GMAP_X      
      ,A.GMAP_Y      
      ,A.PHONE AS BASE_PHONE      
      ,A.ORDER_EMAIL      
      ,D.WAIT_LOGO      
      ,A.FIELD_2      
--      ,dbo.FN_AD_PUBLISH(A.LINEADID, A.INPUT_BRANCH, A.LAYOUT_BRANCH, A.START_DT, A.END_DT, C.RECRUIT_END_DT, G.STATUS, F.PrnAmtOk, F.ChargeKind, F.InipayTid, F.CancelDate) AS PUBLISH_KIND      
               ,dbo.FN_AD_PUBLISH_NEW(      
                                  A.LINEADID,       
                                  A.INPUT_BRANCH,       
                                  A.LAYOUT_BRANCH,       
                                  A.START_DT,       
                                  A.END_DT,       
                                 C.RECRUIT_END_DT,       
                                  G.STATUS,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.PrnAmtOk END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.ChargeKind END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.InipayTid END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.CancelDate END,       
                                  'N',       
                                  'N',      
                                  A.lineadid      
                                  ) AS PUBLISH_KIND      
      ,C.HOMEF      
      ,A.BOX_IMAGE      
      ,A.FINDCODE      
      ,A.FINDCODENAME      
      ,REPLACE(A.LAYOUTCODENAME,'-',' > ') AS LAYOUTCODENAME      
      ,A.LAYOUTCODE      
      ,I.ORDER_DT   
      ,A.VERSION      
      ,C.MAINBIZ      
      ,C.REGULAREMPF      
      ,C.ONLINEF      
      ,C.CI_ZIPID      
      ,K.Metro AS CI_AREA_A      
      ,K.City AS CI_AREA_B      
      ,K.Dong AS CI_AREA_C      
      ,C.CI_ADDRDETAIL      
      ,A.FIELD_11      
            -- 브랜드관 항목 (E-Comm외 광고는 NULL값)      
            ,BR.BRAND_NAME      
            ,BR.SUBDOMAIN      
            ,A.MOD_DT      
            ,C.SERVICE_PERIOD      
            ,C.SUBMIT_DOC      
            ,A.VNSUSEF      
            ,C.WORK_APPOINT      
      ,DBO.FN_GET_JOB_BENEFIT_NAME(E.JOB_BENEFIT) AS JOB_BENEFIT -- 복리후생 추가(2015.05.21)      
      ,C.PTN_COMPANY_NM      
      ,C.PTN_WORKER_NUM      
      ,CASE WHEN SC.ADID IS NOT NULL THEN 'on' ELSE '' END AS SCRAP_YN      
      ,B.RV_PANOID      
      ,B.RV_ANGLEID      
       ,A.AREA_A + ' ' + A.AREA_B + ' ' + A.AREA_C + ' ' +       
     STUFF( ( SELECT ', ' + CODENM4 FROM (       
       SELECT DISTINCT       
       ISNULL(CASE WHEN C.IDX = 1 THEN CODENM2      
        WHEN C.IDX = 2 THEN CODENM3      
        WHEN C.IDX = 3 THEN CODENM4      
       END ,'') AS CODENM4      
        FROM DBO.PP_FINDCODE_TB A1 WITH(NOLOCK)      
        INNER JOIN PP_LINE_AD_FINDCODE_TB A2 WITH(NOLOCK) ON A1.CODE4 = A2.FINDCODE AND A1.USEFLAG ='Y'      
        INNER JOIN COPY_T_TB C WITH(NOLOCK) ON C.IDX < 4      
        WHERE A2.LINEADID = @LINEADID  AND A2.INPUT_BRANCH  = @INPUT_BRANCH  AND A2.LAYOUT_BRANCH  =  @LAYOUT_BRANCH      
      )S FOR XML PATH ('')),1,2,'') AS METAKEYWORD      
            ,CASE WHEN PN.LINEADID IS NOT NULL THEN PN.PARTNERSHIP_NO ELSE CAST(A.LINEADID AS VARCHAR(10)) END AS PARTNERSHIP_NO      
      ,A.CUID      
            ,C.UPRIGHT_AGREE                  
            ,C.WORK_FREELANCER      
            ,C.PAY_COMPANY_RULES      
            ,C.PAY_COMPANY_RULES_ETC      
            ,C.FAXF      
            ,C.FAX      
            ,C.DAY_WEEK      
            ,C.DAY_WEEK_OPTION      
            ,C.DAY_WEEK_OPTION_ETC      
            ,C.CI_BIZNO      
         
   -- 2020-10-27 서수 컬렉션 오류로 인한 추가      
   /*일자리 등록 프로세스 개선 관련 추가 사항*/      
   ,C.WORK_TAKE_CHARGE       
   ,ISNULL(C.ADDRESS_JIBUN,'  ') AS ADDRESS_JIBUN      
   ,C.ADDRESS_ROAD      
   ,C.ADDRESS_DETAIL      
   ,C.ADDRESS_AREA_CODE      
   ,C.DAY_WEEK_OPTION2      
   ,C.RESTTIMEF      
   ,C.REAL_WORKTIME      
   ,C.REAL_WORKTIMEDISPLAY      
   ,C.CI_ADDRESS_JIBUN      
   ,C.CI_ADDRESS_ROAD      
   ,C.WORKTIME_CODE      
   ,C.PAYTO_OVERF      
   ,C.COMPANY_URL          
   ,(CASE WHEN ISNULL(C.REAL_WORKTIME, 0) > 0 THEN CONVERT(FLOAT, C.REAL_WORKTIME) / 60 ELSE 0 END) AS REAL_WORKTIME2 --실제 근무시간 분단위에서 시간단위로 변환      
   ,C.MAP_VIEW_YN --지도노출여부      
   ,C.OUTF -- 외근직추가
   -- 2020-10-27 서수 컬렉션 오류로 인한 추가      
      
    FROM PP_LINE_AD_TB A WITH (NOLOCK)      
    LEFT JOIN PP_LINE_AD_EXTEND_DETAIL_TB B WITH (NOLOCK) ON A.LINEADID = B.LINEADID AND A.INPUT_BRANCH = B.INPUT_BRANCH AND A.LAYOUT_BRANCH = B.LAYOUT_BRANCH      
    LEFT JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB C WITH (NOLOCK) ON A.LINEADID = C.LINEADID AND A.INPUT_BRANCH = C.INPUT_BRANCH AND A.LAYOUT_BRANCH = C.LAYOUT_BRANCH      
    LEFT JOIN PP_LOGO_OPTION_TB D WITH (NOLOCK) ON A.LINEADID = D.LINEADID AND A.INPUT_BRANCH = D.INPUT_BRANCH AND A.LAYOUT_BRANCH = D.LAYOUT_BRANCH      
    LEFT JOIN PP_AD_EC_DATA_JOB_TB E WITH (NOLOCK) ON A.LINEADID = E.LINEADID AND A.INPUT_BRANCH = E.INPUT_BRANCH AND A.LAYOUT_BRANCH = E.LAYOUT_BRANCH      
    --LEFT JOIN PP_ECOMM_RECCHARGE_TB F WITH (NOLOCK) ON A.LINEADID = F.ADID AND F.PRODUCT_GBN = 1      
        LEFT JOIN PP_ECOMM_RECCHARGE_TB F WITH (NOLOCK) ON A.LINEADID = F.ADID AND F.PRODUCT_GBN = 1 AND A.VERSION <> 'A'      
    LEFT JOIN PP_FREE_AD_CONFIRM_TB G WITH (NOLOCK) ON A.LINEADID = G.LINEADID AND A.INPUT_BRANCH = G.INPUT_BRANCH AND A.LAYOUT_BRANCH = G.LAYOUT_BRANCH      
    LEFT JOIN PP_LISTUP_ORDER_JOB_1DAY_TB I WITH (NOLOCK) ON A.LINEADID = I.LINEADID AND A.INPUT_BRANCH = I.INPUT_BRANCH AND A.LAYOUT_BRANCH = I.LAYOUT_BRANCH      
    LEFT JOIN PAPERREG.DBO.ZIPCODE AS K WITH (NOLOCK) ON  K.ZipId = C.CI_ZIPID      
        LEFT JOIN (SELECT B.LINEADID, B.INPUT_BRANCH, B.LAYOUT_BRANCH, A.BRAND_NAME, A.SUBDOMAIN, B.LINEADNO      
                     FROM PP_BRAND_TB AS A WITH (NOLOCK)      
                     JOIN PP_BRAND_AD_TB AS B WITH (NOLOCK)      
                       ON B.BR_SEQ = A.BR_SEQ      
                    WHERE A.USE_YN = 'Y') AS BR      
          ON A.LINEADID = BR.LINEADID AND A.INPUT_BRANCH = BR.INPUT_BRANCH AND A.LAYOUT_BRANCH = BR.LAYOUT_BRANCH      
    LEFT JOIN PP_USER_SCRAP_TB AS SC WITH (NOLOCK)      
     ON SC.CUID = @CUID AND SC.ADID = A.LINEADID AND SC.INPUT_BRANCH = A.INPUT_BRANCH AND SC.LAYOUT_BRANCH = A.LAYOUT_BRANCH      
        LEFT JOIN PARTNERSHIP.DBO.PN_LINEADID_AUTHNO_TB AS PN WITH (NOLOCK) ON A.LINEADID = PN.LINEADID AND A.INPUT_BRANCH = PN.INPUT_BRANCH      
    WHERE A.LINEADNO = @LINEADNO      
      
   END      
  END      
  -- 광고주인증 신문줄(영업광고)  2014.12.01 추가      
  ELSE IF @ADGBN = '3'      
    BEGIN      
      SELECT ISNULL(D.WAIT_TITLE , A.TITLE) AS TITLE      
            ,REPLACE(ISNULL(D.WAIT_COMPANY , A.FIELD_6), CHAR(13) + CHAR(10), '') AS FIELD_6           
            ,C.URL      
            ,A.START_DT      
            ,A.END_DT      
            ,C.RECRUIT_END_DT      
            ,A.ORDER_NAME      
            ,C.PHONE1_VIEWF      
            ,C.PHONE1      
            ,C.PHONE2_VIEWF      
            ,C.PHONE2      
            ,NULL AS VNSNO     -- 신문데이터에는 존재함      
            ,C.EMAIL_VIEWF      
            ,C.EMAIL      
            ,C.PHONEF      
            ,C.PHONE      
            ,C.MOBILEF      
            ,C.MOBILE      
            ,C.EMAILF      
            ,C.URLF      
            ,C.VISITF      
            ,B.EX_IMAGE_1      
            ,B.EX_IMAGE_2      
            ,B.EX_IMAGE_3      
            ,B.EX_IMAGE_4      
            ,D.PUB_LOGO      
      ,C.PARTTIMEF      
            ,C.WORK_MAIN      
            ,C.WORK_SUB      
            ,C.WORK_OUT      
            ,C.PAYF      
            ,C.PAYFROM      
            ,C.PAYTO      
            ,C.PAY_POSSIBLE      
            ,C.PAYTYPE      
            ,C.WORKTIMEF      
            ,C.WORKTIMEFROM      
            ,C.WORKTIMETO      
            ,C.CAREERF      
            ,C.CAREERFROM      
            ,C.CAREERTO      
            ,C.EDULEVEL      
            ,C.AGEF      
            ,C.AGE      
            ,C.AGEFROM      
            ,C.AGETO      
            ,C.AGESUB_JUBU      
            ,C.AGESUB_MIDDLE      
            ,C.AGESUB_MINORITY      
            ,C.SEXF      
            ,E.EC_CHOBO      
            ,E.EC_JUBU      
            ,E.EC_JANGNYUN      
            ,E.EC_JANGAE      
            ,E.EC_HUHAK      
            ,E.EC_WOIKUK      
            ,E.EC_GYOPO      
            ,E.EC_DONGJONG      
            ,E.EC_ENGLISH      
            ,E.EC_CHINESE      
            ,E.EC_AUTOLICENSE      
            ,E.EC_BIKELICENSE      
            ,E.EC_CAROWNER      
            ,E.EC_COMPUTER      
            ,E.EC_LONGTIME      
            ,E.EC_INGUNE      
            ,E.EC_ABOUTLICENSE      
            ,E.EC_ARMY      
            ,E.EC_SUKSIK      
            ,E.EX_SUBWORK      
            ,CASE WHEN ISNUMERIC(A.FIELD_3) = 1 THEN A.FIELD_3 ELSE '' END AS FIELD_3      
            ,B.HTML_FLAG      
            ,ISNULL(A.CONTENTS,'') AS CONTENTS      
            ,ISNULL(B.EX_CONTENTS,'') AS EX_CONTENTS      
            ,ISNULL(A.USER_ID, J.USERID) AS USER_ID      
            ,A.AREA_A      
            ,A.AREA_B      
            ,A.AREA_C      
            ,A.AREA_DETAIL      
            ,B.MAP_X      
            ,B.MAP_Y      
            ,B.GMAP_X      
            ,B.GMAP_Y      
            ,A.PHONE AS BASE_PHONE      
            ,A.ORDER_EMAIL      
            ,D.WAIT_LOGO      
            ,A.FIELD_2      
--            ,dbo.FN_AD_PUBLISH(A.LINEADID, A.INPUT_BRANCH, A.LAYOUT_BRANCH, A.START_DT, A.END_DT, C.RECRUIT_END_DT, G.STATUS, F.PrnAmtOk, F.ChargeKind, F.InipayTid, F.CancelDate) AS PUBLISH_KIND      
   ,dbo.FN_AD_PUBLISH_NEW(      
                                 A.LINEADID,       
                                  A.INPUT_BRANCH,       
                                  A.LAYOUT_BRANCH,       
                                  A.START_DT,       
                                  A.END_DT,       
                                  C.RECRUIT_END_DT,       
                                  G.STATUS,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.PrnAmtOk END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.ChargeKind END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.InipayTid END,       
                                  CASE WHEN A.INPUT_BRANCH = 181 THEN NULL ELSE F.CancelDate END,       
                                  A.ENDYN,       
                                  A.DELYN,      
                                  PL.lineadid      
                                  ) AS PUBLISH_KIND      
            ,C.HOMEF      
            ,NULL AS BOX_IMAGE      
            ,A.FINDCODE      
            ,H.CodeNm1 + ' > ' + H.CodeNm2 + ' > ' + H.CodeNm3 + ' > ' + H.CodeNm4 AS FINDCODENAME      
            ,NULL AS LAYOUTCODENAME      
            ,NULL AS LAYOUTCODE      
          ,I.ORDER_DT      
            ,A.[VERSION]      
            ,C.MAINBIZ      
            ,C.REGULAREMPF      
            ,C.ONLINEF      
            -- 신매체 영업 요청 회사정보 항목 (2013.11.18)      
            ,C.CI_ZIPID      
            ,K.Metro AS CI_AREA_A      
            ,K.City AS CI_AREA_B      
            ,K.Dong AS CI_AREA_C      
            ,C.CI_ADDRDETAIL      
            ,A.FIELD_11      
            -- 브랜드관 항목 (E-Comm외 광고는 NULL값)      
            ,NULL AS BRAND_NAME      
            ,NULL AS SUBDOMAIN      
            ,A.MOD_DT      
            ,C.SERVICE_PERIOD      
            ,C.SUBMIT_DOC      
            ,0 AS VNSUSEF      
            ,C.WORK_APPOINT      
      ,DBO.FN_GET_JOB_BENEFIT_NAME(E.JOB_BENEFIT) AS JOB_BENEFIT -- 복리후생 추가(2015.05.21)      
      ,C.PTN_COMPANY_NM      
      ,C.PTN_WORKER_NUM      
      ,CASE WHEN SC.ADID IS NOT NULL THEN 'on' ELSE '' END AS SCRAP_YN      
      ,B.RV_PANOID      
      ,B.RV_ANGLEID      
       ,A.AREA_A + ' ' + A.AREA_B + ' ' + A.AREA_C + ' ' +       
     STUFF( ( SELECT ', ' + CODENM4 FROM (       
       SELECT DISTINCT       
       ISNULL(CASE WHEN C.IDX = 1 THEN CODENM2      
        WHEN C.IDX = 2 THEN CODENM3      
        WHEN C.IDX = 3 THEN CODENM4      
       END ,'') AS CODENM4      
        FROM DBO.PP_FINDCODE_TB A1 WITH(NOLOCK)      
        INNER JOIN PP_LINE_AD_FINDCODE_TB A2 WITH(NOLOCK) ON A1.CODE4 = A2.FINDCODE AND A1.USEFLAG ='Y'      
        INNER JOIN COPY_T_TB C WITH(NOLOCK) ON C.IDX < 4      
        WHERE A2.LINEADID = @LINEADID  AND A2.INPUT_BRANCH  = @INPUT_BRANCH  AND A2.LAYOUT_BRANCH  =  @LAYOUT_BRANCH      
      )S FOR XML PATH ('')),1,2,'') AS METAKEYWORD      
            ,A.LINEADID AS PARTNERSHIP_NO      
            ,ISNULL(A.CUID, J.CUID) AS CUID                
            ,C.UPRIGHT_AGREE                  
            ,C.WORK_FREELANCER      
            ,C.PAY_COMPANY_RULES      
            ,C.PAY_COMPANY_RULES_ETC      
            ,C.FAXF      
            ,C.FAX      
            ,C.DAY_WEEK      
            ,C.DAY_WEEK_OPTION      
            ,C.DAY_WEEK_OPTION_ETC      
            ,C.CI_BIZNO      
      
   /*일자리 등록 프로세스 개선 관련 추가 사항*/      
   ,C.WORK_TAKE_CHARGE       
   ,ISNULL(C.ADDRESS_JIBUN,'  ') AS ADDRESS_JIBUN      
   ,C.ADDRESS_ROAD      
   ,C.ADDRESS_DETAIL      
   ,C.ADDRESS_AREA_CODE      
   ,C.DAY_WEEK_OPTION2      
   ,C.RESTTIMEF      
   ,C.REAL_WORKTIME      
   ,C.REAL_WORKTIMEDISPLAY      
   ,C.CI_ADDRESS_JIBUN      
   ,C.CI_ADDRESS_ROAD      
   ,C.WORKTIME_CODE      
   ,C.PAYTO_OVERF      
   ,C.COMPANY_URL          
   ,(CASE WHEN ISNULL(C.REAL_WORKTIME, 0) > 0 THEN CONVERT(FLOAT, C.REAL_WORKTIME) / 60 ELSE 0 END) AS REAL_WORKTIME2 --실제 근무시간 분단위에서 시간단위로 변환      
   ,C.MAP_VIEW_YN --지도노출여부      
   ,C.OUTF -- 외근직추가
      
      
      FROM PP_AD_TB A WITH (NOLOCK)      
      JOIN PP_LINE_AD_EXTEND_DETAIL_TB B WITH (NOLOCK)      
        ON A.LINEADNO = B.LINEADNO      
      JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_TB C WITH (NOLOCK)      
        ON A.LINEADNO = C.LINEADNO      
      JOIN MWDB.dbo.MW_CUSTOMER_AUTH_TB J WITH (NOLOCK)      
        ON A.INPUTCUST = J.INPUTCUST      
      LEFT JOIN PP_LOGO_OPTION_TB D WITH (NOLOCK)      
        ON A.LINEADNO = D.LINEADNO      
      LEFT JOIN PP_AD_EC_DATA_JOB_TB E WITH (NOLOCK)      
        ON A.LINEADNO = E.LINEADNO      
      LEFT JOIN PP_ECOMM_RECCHARGE_TB F WITH (NOLOCK)      
        ON A.LINEADID = F.ADID      
       AND F.PRODUCT_GBN = 1      
      LEFT JOIN PP_FREE_AD_CONFIRM_TB G WITH (NOLOCK)      
        ON A.LINEADNO = G.LINEADNO      
      LEFT JOIN DBO.PP_FINDCODE_TB AS H WITH (NOLOCK)      
        ON A.FINDCODE = H.CODE4      
      LEFT JOIN PP_LISTUP_ORDER_JOB_TB I WITH (NOLOCK)      
        ON A.LINEADNO = I.LINEADNO      
      LEFT JOIN PAPERREG.DBO.ZIPCODE AS K WITH (NOLOCK)      
        ON  K.ZipId = C.CI_ZIPID      
   LEFT JOIN PP_USER_SCRAP_TB AS SC WITH (NOLOCK)      
    ON SC.CUID = @CUID AND SC.ADID = A.LINEADID AND SC.INPUT_BRANCH = A.INPUT_BRANCH AND SC.LAYOUT_BRANCH = A.LAYOUT_BRANCH      
        LEFT JOIN PP_LINE_AD_TB PL WITH(NOLOCK)      
          ON A.LINEADID = PL.LINEADID AND A.INPUT_BRANCH = PL.INPUT_BRANCH AND A.LAYOUT_BRANCH = PL.LAYOUT_BRANCH      
      WHERE A.LINEADNO = @LINEADNO      
      
    END      
      
END    
    
    