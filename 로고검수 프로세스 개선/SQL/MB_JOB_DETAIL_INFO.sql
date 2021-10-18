  
/*************************************************************************************              
 *  단위 업무 명 : 구인구직 상세정보              
 *  작   성   자 : 김준홍(juuun@mediawill.com)              
 *  작   성   일 : 2015/08/03              
 *  수   정   자 : 배진용              
 *  수   정   일 : 2021-01-13              
 *  설        명 : 일자리 상세정보 -> 이 일자리 합격에 도움이 되는정보 추가에 따른 연령필드 추가           
 *  수   정   자 : 김 성 윤               
 *  수   정   일 : 2021-09-27               
 *  설        명 : 구글잡스 공고 노출을 위한 공고 개제일 컬럼 추가    
 *  수   정   자 : 방 순 현        
 *  수   정   일 : 2021/10/12 
 *  수 정 내  용 : 로고검수 프로세스 개선
 *  주 의  사 항 :              
 *  사 용  소 스 :              
 *  사 용  예 제 :              
                  EXEC MB_JOB_DETAIL_INFO '0113001707080080'              
 *************************************************************************************/              
 ALTER PROCEDURE [dbo].[MB_JOB_DETAIL_INFO]              
 @LINEADNO   CHAR(16) = ''              
, @ACCESSCODE  VARCHAR(1) = 'B'              
, @READCOUNTYN VARCHAR(1) = 'Y'              
AS              
BEGIN              
              
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
SET NOCOUNT ON              
              
              
              
 SELECT              
  A.LINEADNO              
  , A.LINEADID              
  , A.INPUT_BRANCH              
  , A.LAYOUT_BRANCH              
  , ISNULL(L.WAIT_TITLE , A.TITLE) AS TITLE              
  , A.FIELD_2              
  ,ISNULL(T.THEME_B_NM,'')+' '+ISNULL(T.THEME_C_NM,'')+' '+ISNULL(T.THEME_D_NM,'') AS STATION_NM              
  ,E.PAYF              
  ,E.PAYFROM              
  ,E.PAYTO              
  ,A.FIELD_4              
  ,E.WORKTIMEF              
  ,E.WORKTIMETO              
  ,E.WORKTIMEFROM              
              
  ,ISNULL(E.PAY_POSSIBLE, 0) AS PAY_POSSIBLE  --2016.07.13 - 고용노동부 시정 조치로 추가 - 성소영과장 요청              
              
  ,ISNULL(E.HOMEF, 0) AS HOMEF              
  ,ISNULL(E.PARTTIMEF, 0) AS PARTTIMEF              
  ,ISNULL(E.WEEKENDF, 0) AS WEEKENDF              
  ,E.AGE              
  ,E.SEXF              
  ,A.CONTENTS              
  ,ISNULL(E.PHONEF, 0) AS PHONEF              
  ,ISNULL(E.MOBILEF, 0) AS MOBILEF              
  ,ISNULL(E.EMAILF, 0) AS EMAILF              
  ,E.URL AS HOMEPAGE            
  ,E.URL              
  ,A.ORDER_EMAIL              
  ,A.PHONE              
  --,A.EX_CONTENTS              
  ,REPLACE(CONVERT(VARCHAR(MAX), A.EX_CONTENTS), '"','''') AS EX_CONTENTS    
  ,A.BOX_IMAGE              
  ,E.RECRUIT_END_DT              
  ,A.HTML_FLAG              
  ,E.SUBWAYF              
  ,ISNULL(E.WORK_MAIN, 0) AS WORK_MAIN              
  ,ISNULL(E.WORK_OUT, 0) AS WORK_OUT              
  ,ISNULL(E.WORK_SUB, 0) AS WORK_SUB              
  ,ISNULL(E.WORK_APPOINT, 0) AS WORK_APPOINT              
  ,ISNULL(E.PAYTYPE, 0) AS PAYTYPE              
  ,ISNULL(E.CAREERF, 0) AS CAREERF              
  ,ISNULL(E.CAREERFROM, 0) AS CAREERFROM              
  ,ISNULL(E.CAREERTO, 0) AS CAREERTO              
  ,ISNULL(E.EDULEVEL, 0) AS EDULEVEL              
  ,ISNULL(E.AGEF, 0) AS AGEF              
  ,ISNULL(E.AGEFROM, 0) AS AGEFROM              
  ,ISNULL(E.AGETO, 0) AS AGETO              
  ,ISNULL(E.AGESUB_JUBU, 0) AS AGESUB_JUBU              
  ,ISNULL(E.AGESUB_MIDDLE, 0) AS AGESUB_MIDDLE              
  ,ISNULL(E.AGESUB_MINORITY, 0) AS AGESUB_MINORITY              
  ,A.FIELD_3 AS MEMBER_COUNT              
  ,ISNULL(E.REGULAREMPF, 1) AS REGULAREMPF              
  ,ISNULL(E.URLF, 0) AS URLF              
  ,ISNULL(E.VISITF, 0) AS VISITF              
  ,ISNULL(E.ONLINEF, 0) AS ONLINEF              
  ,A.ORDER_NAME              
  ,ISNULL(L.WAIT_COMPANY , A.FIELD_6) AS FIELD_6
  ,A.GMAP_X              
  ,A.GMAP_Y              
  ,A.AREA_A              
  ,A.AREA_B              
  ,A.AREA_C              
  ,A.AREA_DETAIL              
  ,A.AREA_DONG  -- 동 필드 추가              
  ,A.MAP_X              
  ,A.MAP_Y              
  ,A.AD_KIND              
  ,A.VERSION              
  ,( SELECT TOP 1 CodeNm3 FROM PP_FINDCODE_TB WITH(NOLOCK) WHERE Code3 = LEFT(A.FINDCODE, 5))   AS FINDCODE_NM_A              
  ,( SELECT TOP 1 CodeNm4 FROM PP_FINDCODE_TB WITH(NOLOCK) WHERE Code4 = A.FINDCODE)   AS FINDCODE_NM_B              
--        ,dbo.FN_FINDCODE(left(A.FINDCODE,5)) AS FINDCODE_NM_A              
--    ,dbo.FN_FINDCODE(A.FINDCODE) AS FINDCODE_NM_B              
        ,ISNULL(E.PHONE1_VIEWF,0) as PHONE1_VIEWF              
        ,E.PHONE1              
        ,ISNULL(E.PHONE2_VIEWF,0) as PHONE2_VIEWF              
        ,E.PHONE2              
        ,E.MOBILE              
        ,E.EMAIL              
        ,E.EMAIL_VIEWF              
        ,A.FINDCODE              
        ,REPLACE(A.LAYOUTCODENAME,'-',' > ') AS LAYOUTCODENAME              
        , A.VNSUSEF              
        ,a.VNSNO             
        , A.EX_IMAGE_1              
        , A.EX_IMAGE_2              
        , A.EX_IMAGE_3              
        , A.EX_IMAGE_4              
        , A.GROUP_CD              
        , E.SERVICE_PERIOD              
        , E.SUBMIT_DOC           
        , DBO.FN_GET_JOB_BENEFIT_NAME(D.JOB_BENEFIT) AS JOB_BENEFIT_NAME              
        , A.START_DT              
        , A.RV_PANOID              
        , A.RV_ANGLEID              
  , CASE WHEN (PN.LINEADID IS NOT NULL) AND (PN.LINEADID <> '') THEN PN.PARTNERSHIP_NO ELSE CONVERT(VARCHAR(10), A.LINEADID) END AS PARTNERS_CONTENTS_NO --2016.04.05 - 제휴광고 공고 추가 - 민현진 과장 요청              
  , isnull(E.UPRIGHT_AGREE, 0) AS UPRIGHT_AGREE              
  , ISNULL(E.WORK_FREELANCER, 0) AS WORK_FREELANCER              
  , ISNULL(E.PAY_COMPANY_RULES, 0) AS PAY_COMPANY_RULES              
  , ISNULL(E.PAY_COMPANY_RULES_ETC, '') AS PAY_COMPANY_RULES_ETC              
    , ISNULL(E.FAXF, '1') AS FAXF              
    , ISNULL(E.FAX, '') AS FAX              
    , ISNULL(E.DAY_WEEK, 0) AS DAY_WEEK              
    , ISNULL(E.DAY_WEEK_OPTION, 0) AS DAY_WEEK_OPTION              
    , ISNULL(E.DAY_WEEK_OPTION_ETC, '') AS DAY_WEEK_OPTION_ETC              
  , DATEDIFF(DAY, E.RECRUIT_END_DT, GETDATE()) AS DDAY              
  , E.WORKTIMEDISPLAY              
  ,B.AGESUB_MIDDLE    --중장년 2020-01-13              
  ,B.AGESUB_JUBU      --주부 2020-01-13              
  ,B.AGESUB_MINORITY  --청소년 2020-01-13              
  , DBO.FN_GET_JOB_BENEFIT_NAME(D.JOB_BENEFIT) AS JOB_BENEFIT_NAME                
    ,E.WORK_TAKE_CHARGE -- 담당업무 추가 2020-06-23                
    /*일자리 등록 프로세스 개선 관련 추가 사항*/                
    ,E.ADDRESS_JIBUN                
    ,E.ADDRESS_ROAD                
    ,E.ADDRESS_DETAIL                
    ,E.ADDRESS_AREA_CODE                
    ,E.DAY_WEEK_OPTION2                
    ,E.RESTTIMEF                
    ,E.REAL_WORKTIME                
    ,E.REAL_WORKTIMEDISPLAY                
    ,E.CI_ADDRESS_JIBUN                
    ,E.CI_ADDRESS_ROAD                
    ,E.WORKTIME_CODE                
    ,E.PAYTO_OVERF                
    ,E.COMPANY_URL            
           
    ,(CASE WHEN ISNULL(E.REAL_WORKTIME, 0) > 0 THEN CONVERT(FLOAT, E.REAL_WORKTIME) / 60 ELSE 0 END) AS REAL_WORKTIME2 --실제 근무시간 분단위에서 시간단위로 변환                
    ,E.MAP_VIEW_YN --지도노출여부          
 ,  ADVANTAGE =        
   STUFF(        
   (SELECT ', ' + CONVERT(VARCHAR(100), B.ADVANTAGE_NM )               
   FROM PP_JOB_ADVANTAGE_TB  P WITH(NOLOCK)           
   INNER JOIN DBO.PG_RESUME_ADVANTAGE_CD_TB B (NOLOCK) ON P.ADVANTAGE_CD = B.ADVANTAGE_CD        
   WHERE  P.LINEADID = A.LINEADID                
   ORDER BY P.ADVANTAGE_ID ASC         
  FOR XML PATH('')),1,1,'')         
  ,PTT.TITLE AS TEMPLATE_TITLE      
  ,PTT.COMMENT1      
  ,PTT.COMMENT2      
  ,PTT.COMMENT3      
  ,PTT.TEMPLATE_IDX      
  ,PTT.TEMPLATE_IMAGE_IDX      
  ,PTI.FINDCODE      
  ,PTI.IMAGE_TITLE      
  ,PTI.IMAGE_TOP_URL      
  ,PTI.IMAGE_URL      
  ,PTI.MOBILE_TMBNAIL_IMAGE_URL      
  ,PTI.PRIORITY      
  ,ISNULL(E.OUTF,0) AS OUTF -- 외근직 추가
  ,LO.ORDER_DT  -- 게재일 추가     
 FROM PP_LINE_AD_TB AS A WITH(NOLOCK)              
  -- 2020-01-13 연령 컬럼 추가              
  LEFT OUTER JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB AS B (NOLOCK) ON A.LINEADNO = B.LINEADNO              
  LEFT OUTER JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_TB AS E WITH(NOLOCK) ON E.LINEADID = A.LINEADID AND E.INPUT_BRANCH = A.INPUT_BRANCH AND E.LAYOUT_BRANCH = A.LAYOUT_BRANCH              
  LEFT OUTER JOIN CC_THEME_TB AS T WITH(NOLOCK) ON E.SUBWAYCODE = T.CODE              
  LEFT OUTER JOIN PP_AD_EC_DATA_JOB_TB AS D WITH(NOLOCK)  ON D.LINEADNO = A.LINEADNO            
  LEFT OUTER JOIN PARTNERSHIP.DBO.PN_LINEADID_AUTHNO_TB AS PN WITH (NOLOCK) ON A.LINEADID = PN.LINEADID AND A.INPUT_BRANCH = PN.INPUT_BRANCH     --2016.04.05 - 제휴광고 공고 추가 - 민현진 과장 요청            
  LEFT OUTER JOIN PP_JOB_AD_TEMPLATE_TB AS PTT ON PTT.LINEADNO = A.LINEADNO      
  LEFT OUTER JOIN PP_JOB_TEMPLATE_IMAGE_TB AS PTI ON PTT.TEMPLATE_IMAGE_IDX = PTI.IDX AND PTI.USE_YN = 'Y'      
  --추가 
  LEFT OUTER JOIN PP_MOBILE_LISTUP_ORDER_JOB_TB AS LO ON LO.LINEADID = A.LINEADID 
  LEFT JOIN PP_LOGO_OPTION_TB AS L ON L.LINEADID = A.LINEADID AND L.INPUT_BRANCH = A.INPUT_BRANCH AND L.LAYOUT_BRANCH = A.LAYOUT_BRANCH
 WHERE              
  A.LINEADNO = @LINEADNO              
              
 IF @READCOUNTYN = 'Y' BEGIN              
  DECLARE @LINEADID INT, @INPUT_BRANCH TINYINT, @LAYOUT_BRANCH TINYINT              
              
  --광고 조회수 증가 접속사이트구분 (A:웹, B: 모바일웹, C: 모바일어플(안드로이드), D: 모바일어플(아이폰))              
  IF EXISTS (SELECT * FROM PP_LINE_AD_TB WITH(NOLOCK) WHERE LINEADNO = @LINEADNO) BEGIN              
              
   SELECT @LINEADID = LINEADID, @INPUT_BRANCH = INPUT_BRANCH, @LAYOUT_BRANCH = LAYOUT_BRANCH              
   FROM PP_LINE_AD_TB WITH(NOLOCK)              
   WHERE LINEADNO = @LINEADNO              
              
   EXEC PUT_LINEAD_COUNT_PROC @LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH, @ACCESSCODE              
  END              
 END              
SET NOCOUNT OFF              
              
END   
  
  