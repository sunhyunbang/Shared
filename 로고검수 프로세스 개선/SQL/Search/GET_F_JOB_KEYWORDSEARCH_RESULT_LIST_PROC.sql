
/*************************************************************************************  
 *  단위 업무 명 : 검색결과 키워드 검색광고 리스트
 *  작   성   자 : online_dev21
 *  작   성   일 : 2021/03/19
 *  설        명 : 검색결과 키워드 검색광고 리스트
 *  수   정   자 : 방 순 현        
 *  수   정   일 : 2021/10/12 
 *  수 정 내  용 : 로고검수 프로세스 개선
 *  주 의  사 항 :  
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  사 용  소 스 :  /SEARCH_FINDJOB/default.asp
 *  사 용  예 제 :   
 EXEC GET_F_JOB_KEYWORDSEARCH_RESULT_LIST_PROC '택배'
 EXEC GET_F_JOB_KEYWORDSEARCH_RESULT_LIST_PROC '배달'
 EXEC GET_F_JOB_KEYWORDSEARCH_RESULT_LIST_PROC '차량도우미'
   
 
 *************************************************************************************/  
ALTER PROC [dbo].[GET_F_JOB_KEYWORDSEARCH_RESULT_LIST_PROC]
  @strKeyword varchar(200) = ''              -- 검색 키워드
AS  
BEGIN  
  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SET NOCOUNT ON  
  
  SELECT TOP 7 TBL1.LINEADNO                                                  -- 공고번호
    , CASE WHEN TBL4.PUB_CONFIRM = 1 THEN 
      CASE WHEN ISNULL(TBL4.MAIN_LOGO,'') ='' THEN TBL4.PUB_LOGO ELSE NULL END 
      ELSE NULL END AS WAIT_LOGO  -- 회사로고(LOGO_IMAGE)
    , ISNULL(TBL1.AREA_A,'') + ' ' + ISNULL(TBL1.AREA_B,'') AS WORK_AREA      -- 근무지
    , ISNULL(TBL4.WAIT_COMPANY , TBL1.FIELD_6)                                -- 회사명(COMPANY_NAME) 
    , ISNULL(TBL4.WAIT_TITLE , TBL1.TITLE)                                    -- 모집내용(TITLE)
    , TBL2.WORKTIMEFROM                                                       -- 시간
    , TBL2.WORKTIMETO                                                         -- 시간
    , TBL2.WORKTIMEF                                                          -- 시간
    , TBL2.DAY_WEEK                                                           -- 요일
    , TBL2.DAY_WEEK_OPTION                                                    -- 요일
    , TBL2.DAY_WEEK_OPTION_ETC                                                -- 요일
    , TBL2.SERVICE_PERIOD                                                     -- 기간
    , TBL2.PAYF                                                               -- 급여
    , TBL2.PAYFROM                                                            -- 급여
    , TBL2.PAYTO                                                              -- 급여
    , TBL2.PAY_COMPANY_RULES                                                  -- 회사 내규 따름
  FROM PP_LINE_AD_TB AS TBL1 WITH(NOLOCK)
  INNER JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_TB AS TBL2 WITH(NOLOCK) ON TBL1.LINEADNO=TBL2.LINEADNO
  INNER JOIN (
              SELECT DISTINCT SUB_TBL1.KEYWORD, SUB_TBL2.LINEADNO FROM PP_JOB_KEYWORDSEARCH_TB AS SUB_TBL1 WITH(NOLOCK)
              INNER JOIN PP_JOB_KEYWORDSEARCH_RELATION_TB AS SUB_TBL2 WITH(NOLOCK) ON SUB_TBL1.KEYWORDSEARCHADID=SUB_TBL2.KEYWORDSEARCHADID
              WHERE CONVERT(VARCHAR(10),GETDATE(),121) >= SUB_TBL1.START_DT AND CONVERT(VARCHAR(10),GETDATE(),121) <= SUB_TBL1.END_DT 
                AND SUB_TBL1.END_YN='N' AND SUB_TBL2.END_YN='N'
                AND SUB_TBL2.LINEADNO IS NOT NULL AND SUB_TBL1.KEYWORD=@strKeyword
              ) AS TBL3 ON TBL1.LINEADNO=TBL3.LINEADNO          -- 키워드는 7개 제한적이므로 like를 사용하지 않음    
  LEFT OUTER JOIN PP_LOGO_OPTION_TB AS TBL4 WITH(NOLOCK) ON TBL1.LINEADNO=TBL4.LINEADNO
  
  ORDER BY NEWID()

END 

