    
    
/*************************************************************************************    
 *  단위　업무　명 : 프론트 > 구인구직 > 일반광고리스트 (지역별, 업직종별, 대상별, 근무시간별)(전국판용)    
 *  작　　성　　자 : 송 이 현    
 *  작　　성　　일 : 2019-07-30    
 *  수　　정　　자 : 주기찬    
 *  수　　정　　일 : 20201117     
 *  설　　　　　명 : 공통 리스트 오류 관련해서 WEEK_OPTION2 를 추가    
 *  수　　정　　자 : 김선호    
 *  수　　정　　일 : 2021/02/09     
 *  설　　　　　명 : 공고의 노출지역 총 갯수 AREA_COUNT 추가    
 *  수    정    자 : 방순현        
 *  수    정    일 : 2021/10/12 
 *  수  정  내  용 : 로고검수 프로세스 개선
 *  주　의　사　항 :    
 *  사　용　소　스 :    
 *  사　용　예　제 :     
 exec GET_F_JOB_NORMAL_AD_RENEW_PROC 1,25,'',0,'서울','강남구','',0,0,1,'',default,0,'192.168.170.111',NULL,'WJ010305'    
 exec GET_F_JOB_NORMAL_AD_RENEW_PROC 1,25,'',1,'서울','','',0,0,1,'',default,0,'192.168.170.111',NULL,'WJ010305'    
 exec GET_F_JOB_NORMAL_AD_RENEW_PROC 1,25,'',0,'12,13','1201,','1201001,',0,0,1,'',default,0,'192.168.170.111',NULL,'WJ010305'    
 exec GET_F_JOB_NORMAL_AD_RENEW_PROC 1,25,'',0,'경기','부천시','',0,0,1,'',default,0,'192.168.170.111',NULL,'WJ010305'    
 exec GET_F_JOB_NORMAL_AD_RENEW_PROC 1,25,'',0,'서울,서울,경기','강남구,강남구,가평군','개포동,대치동,가평읍',0,0,1,'',default,0,'192.168.170.111',NULL,'WJ010305'    
 exec GET_F_JOB_NORMAL_AD_PROC 1,25,'401,406',1,'','','',0,0,1,'',default,0,'192.168.170.111',NULL,'WJ010304'    
 *************************************************************************************/     
     
ALTER PROC [dbo].[GET_F_JOB_NORMAL_AD_RENEW_PROC]    
    
 @PAGE             INT,                      -- 페이지번호    
 @PAGESIZE          INT,                      -- 페이지별 게시물 수    
 @FINDCODE          VARCHAR(50)     = '',           -- 업직종(인터넷분류코드)    
  @LEVEL           INT             = 0,        -- 분류레벨 (1:대분류[3자리] 2:중분류[5자리] 3:소분류[7자리]) .건수만 가져올수있게 분기처리    
 @METRO           VARCHAR(100)     = '',           -- 검색 시,도    
 @CITY             VARCHAR(100)     = '',           -- 검색 구,군    
 @DONG             VARCHAR(100)     = '',           -- 검색 동,읍,면    
  @TARGET           TINYINT         = 0,         -- 1: 중장년 2:주부 3:아르바이트    
  @TIME               TINYINT         = 0,            -- 1:오전(06:00~12:00) 2:오후(12:00~18:00) 3:저녁(18:00~24:00) 4:새벽(00:00~06:00) 5:시간협의 6:풀타임(8시간 이상)    
  @REGTERM          INT             = 1,         -- 등록일기간 (1:전체기간 0:오늘등록 3:3일내등록 7:7일내등록)    
 @ORDER           VARCHAR(100)    = '',           -- 정렬순서    
  @LAYOUT_BRANCH      TINYINT         = 0,            -- LAYOUT_BRANCH  (기존 지점코드)    
  @SUB_BRANCH         INT             = 0,             -- SubBranchCode  (신지점코드)    
  @IPADDR           VARCHAR(20)     = '',    
  @CUID               INT             = '',    
  @POSITION_CODE      VARCHAR(15)     = ''            -- 상품 노출 위치    
AS    
BEGIN    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  SET NOCOUNT ON    
    
 DECLARE @SQLCOUNT           NVARCHAR(MAX)    
 DECLARE @SQL                NVARCHAR(MAX)    
 DECLARE @SQLTEMP            NVARCHAR(MAX)    
 DECLARE @WHERESQL           NVARCHAR(MAX)    
 DECLARE @JOINSQL            NVARCHAR(MAX)    
  DECLARE @JOINSQL_COUNT      NVARCHAR(MAX)    
  DECLARE @DISPLAY_DT         NVARCHAR(20)        = 'ORDER_DT'    
  DECLARE @DISPLAY_CASE       NVARCHAR(MAX)    
  DECLARE @DISPLAY_CASE_FAT   NVARCHAR(MAX)    
 DECLARE @SQL_PARAM          NVARCHAR(MAX)    
  DECLARE @MAXLOOP_COUNT      INT    
  DECLARE @LOOP_COUNT         INT    
  DECLARE @WHEREMULTI         NVARCHAR(MAX)    
  DECLARE @__FINDCODE         INT    
  DECLARE @__FINDCODE1YN      CHAR(1)    
  DECLARE @__FINDCODE2YN      CHAR(1)     
  DECLARE @__AREA_A           VARCHAR(20)    
  DECLARE @__AREA_B           VARCHAR(20)    
  DECLARE @__AREA_C           VARCHAR(20)    
     
  IF (EXISTS(SELECT * FROM LOGDB.DBO.BAD_CLICK_IP_NOW_TB WITH(NOLOCK)  WHERE CLIENT_IP = @IPADDR)     
     AND GETDATE() >= '2018-07-09') OR @IPADDR = '193.164.202.153'--크롤링 의심아이피 (해외?)    
  BEGIN    
  SELECT 0 AS CNT;    
  SELECT 1 AS LINEADID  WHERE 1=2    
  RETURN ;    
  END      
    
 SET @SQLCOUNT = ''    
 SET @SQL = ''    
 SET @SQLTEMP = ''    
 SET @WHERESQL = ''    
 SET @JOINSQL = ''    
  SET @JOINSQL_COUNT=''     
  SET @DISPLAY_CASE = ''    
  SET @DISPLAY_CASE_FAT = ''    
  SET @MAXLOOP_COUNT = 0    
  SET @LOOP_COUNT = 1    
  SET @WHEREMULTI = ''    
  SET @__FINDCODE = ''    
  SET @__FINDCODE1YN = 'N'    
  SET @__FINDCODE2YN = 'N'    
  SET @__AREA_A = ''    
  SET @__AREA_B = ''     
  SET @__AREA_C = ''     
    
  -- 강조옵션 옵션기간에 따른 처리    
  IF @SUB_BRANCH > 0    
  BEGIN    
    SET @DISPLAY_CASE = 'CASE WHEN TA.OPT_AREA&2=2 THEN TA.DISPLAY_OPT ELSE 0 END'    
    SET @DISPLAY_CASE_FAT = '0'    
  END    
  ELSE    
  BEGIN    
    SET @DISPLAY_CASE = 'CASE WHEN TA.OPT_AREA&1=1 THEN TA.DISPLAY_OPT ELSE 0 END'    
    SET @DISPLAY_CASE_FAT = 'CASE WHEN TA.OPT_AREA&1=1 THEN DG.DISPLAY_GOODS_ID ELSE 0 END'    
  END      
    
  --FJ001-102 주소 다중 선택    
  IF @METRO <> ''     
  BEGIN        
    IF CHARINDEX(',', @METRO) > 0    
    BEGIN    
      SET @WHEREMULTI = ' AND ('    
      SET @MAXLOOP_COUNT = DBO.FN_CHAR_COUNT(@METRO, ',') + 1    
      WHILE @LOOP_COUNT <= @MAXLOOP_COUNT    
      BEGIN    
        SET @__AREA_A = DBO.FN_SPLIT_NEW(@METRO, @LOOP_COUNT, ',')    
        SET @__AREA_B = DBO.FN_SPLIT_NEW(@CITY, @LOOP_COUNT, ',')    
        SET @__AREA_C = DBO.FN_SPLIT_NEW(@DONG, @LOOP_COUNT, ',')    
        SET @WHEREMULTI = @WHEREMULTI + '('    
        IF @__AREA_C <> ''    
            SET @WHEREMULTI = @WHEREMULTI + 'PA.AREA_C_GROUP = ''' + @__AREA_C + ''''    
        ELSE IF @__AREA_B <> ''    
            SET @WHEREMULTI = @WHEREMULTI + 'PA.AREA_B_CODE = ''' + @__AREA_B + ''' '    
        ELSE IF @__AREA_A <> ''    
            SET @WHEREMULTI = @WHEREMULTI + 'PA.AREA_A_CODE = ''' + @__AREA_A + ''' '    
              
        SET @WHEREMULTI = @WHEREMULTI + ')'    
        SET @LOOP_COUNT += 1    
        IF @LOOP_COUNT <= @MAXLOOP_COUNT            
          SET @WHEREMULTI = @WHEREMULTI + ' OR '    
        ELSE    
          SET @WHEREMULTI = @WHEREMULTI + ') '            
      END    
    END    
    ELSE    
    BEGIN    
      IF @DONG <> ''    
        SET @WHEREMULTI = @WHEREMULTI + 'AND PA.AREA_C_GROUP = @DONG '          
      ELSE IF @CITY <> ''    
        SET @WHEREMULTI = @WHEREMULTI + 'AND PA.AREA_B_CODE = @CITY '    
      ELSE IF @METRO <> ''    
        SET @WHEREMULTI = ' AND PA.AREA_A_CODE = @METRO '            
    END    
    SET @WHERESQL = @WHERESQL + @WHEREMULTI     
  END    
  ELSE    
  BEGIN    
    IF @SUB_BRANCH > 0    
    BEGIN    
      -- 시/도 매핑 지역    
      IF ISNULL((SELECT TOP 1 AREA_B FROM CC_BRANCH_AREA_TB WHERE SUB_BRANCHCODE = @SUB_BRANCH),'') = ''    
       SET @JOINSQL = @JOINSQL + ' JOIN CC_BRANCH_AREA_TB AS BA WITH(NOLOCK) ON BA.AREA_A = PA.AREA_A AND BA.SUB_BRANCHCODE = @SUB_BRANCH '    
      ELSE  -- 시/도 + 구/군 매핑 지역    
       SET @JOINSQL = @JOINSQL + ' JOIN CC_BRANCH_AREA_TB AS BA WITH(NOLOCK) ON BA.AREA_A = PA.AREA_A AND BA.AREA_B = PA.AREA_B AND BA.SUB_BRANCHCODE = @SUB_BRANCH '    
    END    
  END    
    
      
    
  -- 등록일 기간    
  IF @REGTERM <> 1    
  BEGIN        
    IF @REGTERM = 0 -- 오늘등록인 경우 오늘포함 1일전 광고까지 노출    
    SET @REGTERM = 1      
   SET @REGTERM = @REGTERM * -1     
    SET @WHERESQL = @WHERESQL + ' AND L.PC_LISTUP_DT>=CONVERT(VARCHAR(10),DATEADD(DAY,@REGTERM,GETDATE()),120)'      
  END       
    
  --FJ001-102 업직종 다중 선택    
  IF @FINDCODE <> ''    
  BEGIN    
    IF CHARINDEX(',', @FINDCODE) > 0    
    BEGIN    
      SET @WHEREMULTI = ' AND ('    
      SET @MAXLOOP_COUNT = DBO.FN_CHAR_COUNT(@FINDCODE, ',') + 1    
      SET @LOOP_COUNT = 1    
    
      WHILE @LOOP_COUNT <= @MAXLOOP_COUNT    
      BEGIN    
        SET @__FINDCODE = DBO.FN_SPLIT_NEW(@FINDCODE, @LOOP_COUNT, ',')    
    
        --JOIN 추가체크    
        IF LEN(@__FINDCODE) = 3     
        BEGIN    
          IF @__FINDCODE1YN = 'N'    
          BEGIN                
            SET @JOINSQL = @JOINSQL + ' JOIN PP_LINE_AD_FINDCODE_STEP1_1DAY_TB AS PS WITH (NOLOCK) ON PS.LINEADID = L.LINEADID AND PS.INPUT_BRANCH = L.INPUT_BRANCH AND PS.LAYOUT_BRANCH = L.LAYOUT_BRANCH '    
            SET @__FINDCODE1YN = 'Y'    
          END    
        END    
        ELSE IF LEN(@__FINDCODE) = 5 OR LEN(@__FINDCODE) = 7    
        BEGIN    
          IF @__FINDCODE2YN = 'N'    
          BEGIN                
            SET @JOINSQL = @JOINSQL + ' JOIN PP_LINE_AD_FINDCODE_1DAY_TB AS PF WITH (NOLOCK) ON PF.LINEADID = L.LINEADID AND PF.INPUT_BRANCH = L.INPUT_BRANCH AND PF.LAYOUT_BRANCH = L.LAYOUT_BRANCH '    
            SET @__FINDCODE2YN = 'Y'    
          END    
        END    
    
        IF LEN(@__FINDCODE) = 3 --대분류    
     SET @WHEREMULTI = @WHEREMULTI + '(PS.FINDCODE = ' + CONVERT(VARCHAR, @__FINDCODE) + ')'    
        ELSE IF LEN(@__FINDCODE) = 5 --중분류    
          SET @WHEREMULTI = @WHEREMULTI + '(PF.FINDCODE BETWEEN ' + CONVERT(VARCHAR, @__FINDCODE * 100)  + ' AND ' + CONVERT(VARCHAR, @__FINDCODE * 100 + 99) + ')'    
        ELSE IF LEN(@__FINDCODE) = 7 --소분류    
          SET @WHEREMULTI = @WHEREMULTI + '(PF.FINDCODE = ' + CONVERT(VARCHAR, @__FINDCODE) + ')'    
    
        SET @LOOP_COUNT += 1    
        IF @LOOP_COUNT <= @MAXLOOP_COUNT            
          SET @WHEREMULTI = @WHEREMULTI + ' OR '    
        ELSE    
          SET @WHEREMULTI = @WHEREMULTI + ') '            
      END    
    END    
    ELSE    
    BEGIN    
      --JOIN 추가체크    
      IF LEN(@FINDCODE) = 3     
        SET @JOINSQL = @JOINSQL + ' JOIN PP_LINE_AD_FINDCODE_STEP1_1DAY_TB AS PS WITH (NOLOCK) ON PS.LINEADID = L.LINEADID AND PS.INPUT_BRANCH = L.INPUT_BRANCH AND PS.LAYOUT_BRANCH = L.LAYOUT_BRANCH '             
      ELSE IF LEN(@FINDCODE) = 5 OR LEN(@FINDCODE) = 7    
        SET @JOINSQL = @JOINSQL + ' JOIN PP_LINE_AD_FINDCODE_1DAY_TB AS PF WITH (NOLOCK) ON PF.LINEADID = L.LINEADID AND PF.INPUT_BRANCH = L.INPUT_BRANCH AND PF.LAYOUT_BRANCH = L.LAYOUT_BRANCH '            
    
      SET @WHEREMULTI = ''    
      IF LEN(@FINDCODE) = 3 --대분류    
        SET @WHEREMULTI = @WHEREMULTI + 'AND PS.FINDCODE = @FINDCODE '    
      ELSE IF LEN(@FINDCODE) = 5 --중분류    
        SET @WHEREMULTI = @WHEREMULTI + 'AND PF.FINDCODE BETWEEN @FINDCODE * 100 AND @FINDCODE * 100 + 99 '    
      ELSE IF LEN(@FINDCODE) = 7 --소분류    
        SET @WHEREMULTI = @WHEREMULTI + 'AND PF.FINDCODE = @FINDCODE '    
    END    
    SET @WHERESQL = @WHERESQL + @WHEREMULTI    
  END    
    
        
    
  IF @TARGET > 0 OR @TIME > 0    
    SET @JOINSQL = @JOINSQL+ 'JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB AS J WITH (NOLOCK) ON J.LINEADID=L.LINEADID AND J.INPUT_BRANCH=L.INPUT_BRANCH AND J.LAYOUT_BRANCH=L.LAYOUT_BRANCH '    
    
  -- 대상별    
 IF @TARGET > 0    
 BEGIN    
    --중장년 : 중장년가능(1)    
   IF @TARGET = 1    
    SET @WHERESQL = @WHERESQL + ' AND J.AGESUB_MIDDLE = 1 '    
   --주부 : 주부가능(1)    
   ELSE IF @TARGET = 2    
    SET @WHERESQL = @WHERESQL + ' AND J.AGESUB_JUBU = 1 '    
  END    
    
  -- 근무시간    
  IF @TIME > 0    
  BEGIN    
    IF @TIME=1    
      SET @WHERESQL = @WHERESQL+' AND ( J.WORKTIMEFROM>=500 AND J.WORKTIMEFROM<=1200 ) AND ( J.WORKTIMETO>=600 AND J.WORKTIMETO<=1500 ) '    
    ELSE IF @TIME=2    
      SET @WHERESQL = @WHERESQL+' AND ( J.WORKTIMEFROM>=1100 AND J.WORKTIMEFROM<=1800 ) AND ( J.WORKTIMETO>=1200 AND J.WORKTIMETO<=2100 ) '    
    ELSE IF @TIME=3    
      SET @WHERESQL = @WHERESQL+' AND ( J.WORKTIMEFROM>=1700 AND J.WORKTIMEFROM<=2300 ) AND ( J.WORKTIMETO>=1800 OR J.WORKTIMETO<=300 ) '    
    ELSE IF @TIME=4    
      SET @WHERESQL = @WHERESQL+' AND ( J.WORKTIMEFROM>=2300 OR J.WORKTIMEFROM<=600 ) AND ( J.WORKTIMETO>=100 AND J.WORKTIMETO<=900 ) '    
    ELSE IF @TIME=5    
      SET @WHERESQL = @WHERESQL+' AND J.WORKTIMEF=0 '    
    ELSE IF @TIME=6    
      SET @WHERESQL = @WHERESQL + ' AND CASE WHEN J.WORKTIMEFROM > J.WORKTIMETO THEN CASE WHEN (J.WORKTIMETO+2400)-J.WORKTIMEFROM >= 800 THEN 1 ELSE 0 END ELSE CASE WHEN J.WORKTIMETO-J.WORKTIMEFROM >= 800 THEN 1 ELSE 0 END END = 1 '    
  END    
    
  IF @POSITION_CODE = 'WJ010104' BEGIN    
    SET @WHERESQL = @WHERESQL + ' AND PNA.PARTNERSHIP_NO IS NOT NULL '    
  END    
    
  --정렬순서 (리스트A형은 프리미엄>긴급>일반(게재시작일>등록일)순    
  IF @SUB_BRANCH = 0    
  BEGIN    
    IF @ORDER = 'END_DT'    
    BEGIN    
      SET @DISPLAY_DT = @ORDER    
      SET @ORDER = 'ORDER BY TA.END_DT ASC, TA.START_DT DESC, TA.REG_DT DESC, TA.LINEADID '    
    
      --게제종료일 (D-2)    
      SET @WHERESQL = @WHERESQL + ' AND DATEDIFF(DAY,GETDATE(), L.END_DT) <= 2 AND DATEDIFF(DAY,GETDATE(), L.END_DT) >=0 '    
    END    
    ELSE    
    BEGIN    
      SET @ORDER = 'ORDER BY TA.ORDER_DT DESC,TA.START_DT DESC,TA.REG_DT DESC,TA.LINEADID '    
    END    
  END    
  ELSE  -- (기본: 자점 > 리스트업 > 게재시작일 > 등록일 > 접수번호)    
  BEGIN    
    IF @ORDER = ''    
    BEGIN    
     IF @SUB_BRANCH = 52 /* 2015.03.30 부산예외 */    
     SET @ORDER = 'ORDER BY TA.ORDER_DT DESC,TA.START_DT DESC,TA.REG_DT DESC,TA.LINEADID '    
   ELSE    
     SET @ORDER = 'ORDER BY TA.SORT DESC,TA.ORDER_DT DESC,TA.START_DT DESC,TA.REG_DT DESC,TA.LINEADID DESC '    
    END    
    ELSE    
    BEGIN    
      SET @DISPLAY_DT = @ORDER    
     SET @ORDER = 'ORDER BY TA.'+ @ORDER +' DESC '    
    END    
  END    
    
 --페이징을 위한 카운트    
 SET @SQLCOUNT='    
   SELECT COUNT(*)  AS CNT    
    FROM (    
         SELECT L.LINEADID, L.INPUT_BRANCH, L.LAYOUT_BRANCH    
           FROM MOBILE_JOB_TB AS L WITH (NOLOCK)    
            LEFT JOIN PP_PUBLIC_AUTHNO_TB AS PNA WITH(NOLOCK) ON PNA.LINEADNO = L.LINEADNO
           ' + @JOINSQL_COUNT     
 IF @METRO <> '' OR @SUB_BRANCH  <> 0 BEGIN              
  SET @SQLCOUNT=@SQLCOUNT + 'JOIN PP_LINE_AD_AREA_1DAY_TB AS PA WITH (NOLOCK) ON PA.LINEADID = L.LINEADID AND PA.INPUT_BRANCH = L.INPUT_BRANCH AND PA.LAYOUT_BRANCH = L.LAYOUT_BRANCH '    
 END    
               
 SET @SQLCOUNT=@SQLCOUNT + @JOINSQL + '    
     WHERE 10006=10006    
           ' + @WHERESQL + '    
           GROUP BY L.LINEADID, L.INPUT_BRANCH, L.LAYOUT_BRANCH    
         ) X OPTION(MAXDOP 2)  '    
    
    
    
 SET @SQLTEMP='SELECT   *   FROM (SELECT ROW_NUMBER() OVER ('+@ORDER+') AS ROWNUM, * FROM (    
      SELECT L.LINEADNO, L.LINEADID, L.INPUT_BRANCH, L.LAYOUT_BRANCH, L.START_DT, L.REG_DT    
     --, REPLACE(L.PC_LISTUP_DT, ''1900-01-01 00:00:00.000'', NULL) AS ORDER_DT    
     , CASE WHEN L.PC_LISTUP_DT = ''1900-01-01 00:00:00.000'' THEN NULL ELSE L.PC_LISTUP_DT END AS ORDER_DT
     , MIN(PA.[ORDER]) AS [ORDER], L.MOD_DT, L.END_DT, CASE WHEN L.INPUT_BRANCH = @LAYOUT_BRANCH THEN 3 WHEN L.LAYOUT_BRANCH = @LAYOUT_BRANCH THEN 2 ELSE 1 END AS SORT, L.OPT_CODE    
     FROM MOBILE_JOB_TB AS L WITH (NOLOCK)    
          JOIN PP_LINE_AD_AREA_1DAY_TB AS PA WITH (NOLOCK) ON PA.LINEADID = L.LINEADID AND PA.INPUT_BRANCH = L.INPUT_BRANCH AND PA.LAYOUT_BRANCH = L.LAYOUT_BRANCH    
          LEFT JOIN PP_PUBLIC_AUTHNO_TB AS PNA WITH(NOLOCK) ON PNA.LINEADNO = L.LINEADNO
     '+@JOINSQL+'    
       WHERE 10006=10006 '+@WHERESQL +'    
       GROUP BY L.LINEADNO,L.LINEADID,L.INPUT_BRANCH,L.LAYOUT_BRANCH,L.START_DT,L.REG_DT,L.PC_LISTUP_DT,L.MOD_DT,L.END_DT,L.OPT_CODE    
       ) AS TA ) AS TTA    
  WHERE TTA.ROWNUM> (@PAGE-1) * @PAGESIZE AND TTA.ROWNUM<= (@PAGE) * @PAGESIZE'    
    
  SET @SQL = '    
SELECT TA.LINEADID ,TA.INPUT_BRANCH ,TA.LAYOUT_BRANCH    
      ,CASE WHEN TA.DETAILADCODE = ''1400002'' OR TA.DETAILADCODE = ''1411000'' THEN REPLACE(REPLACE(TA.FIELD_2,''<'',''&lt;''),''>'',''&gt;'')    
        ELSE REPLACE(REPLACE(dbo.fn_DelSpecCharTitle(ISNULL(L.WAIT_COMPANY , TA.FIELD_6),TA.[VERSION]),''<'',''&lt;''),''>'',''&gt;'') END AS AD_NAME    
      ,E.AREA_A + '' '' + E.AREA_B AS AREA    
      ,CASE WHEN LEN(LTRIM(RTRIM(ISNULL(TA.TITLE,'''')))) = 0 THEN    
            CASE WHEN LEN(LTRIM(RTRIM(ISNULL(TA.FIELD_2,'''')))) = 0 THEN    
                  CASE WHEN LEN(LTRIM(RTRIM(ISNULL(TA.CONTENTS,'''')))) = 0 THEN DBO.FN_SPLIT(TA.FINDCODENAME,''>'',4) + '' 구함''    
                  ELSE TA.CONTENTS END    
            ELSE TA.FIELD_2 END    
        ELSE DBO.fn_DelSpecCharTitle(ISNULL(L.WAIT_TITLE , TA.TITLE), TA.[VERSION]) END AS TITLE    
 ,CASE WHEN TA.ICON_OPT>1000 THEN CASE WHEN NOT (TA.OPT_START_DT<=CONVERT(VARCHAR(10),GETDATE(),121) AND TA.OPT_END_DT>=DATEADD(DAY,-1,GETDATE())) THEN 0 ELSE TA.ICON_OPT END ELSE TA.ICON_OPT END ICON_OPT    
      ,CASE WHEN TA.PAPER_OPT = 1 THEN 1 WHEN TA.PAPER_OPT&7=7 THEN 7 WHEN TA.PAPER_OPT&6=6 THEN 6 WHEN TA.PAPER_OPT&5=5 THEN 5 WHEN TA.PAPER_OPT&4=4 THEN 4 WHEN TA.PAPER_OPT&3=3 THEN 3 WHEN TA.PAPER_OPT&2=2 THEN 2 ELSE 0 END AS PAPER_OPT    
      ,CASE WHEN TA.PAPER_OPT&8=8 THEN 1 ELSE 0 END AS ACCENT_OPT    
      ,CASE WHEN TA.PAPER_OPT&16=16 THEN 1 ELSE 0 END AS COLOR_OPT    
      ,CASE WHEN TA.PAPER_OPT&32=32 THEN 1 WHEN TA.PAPER_OPT&64=64 THEN 2 ELSE 0 END BG_OPT    
'    
IF @DISPLAY_DT = 'END_DT'      
  SET @SQL = @SQL + ',CASE WHEN DATEDIFF(D, A.'+ @DISPLAY_DT +', GETDATE()) = 0 THEN ''오늘 마감'' WHEN DATEDIFF(D, A.'+ @DISPLAY_DT +', GETDATE()) = -1 THEN ''내일 마감'' WHEN DATEDIFF(D, A.'+ @DISPLAY_DT +', GETDATE()) = -2 THEN ''모레 마감'''    
ELSE    
  SET @SQL = @SQL + ',CASE WHEN DATEDIFF(MINUTE,A.'+ @DISPLAY_DT +',GETDATE())<=59 THEN CAST(DATEDIFF(MINUTE,A.'+ @DISPLAY_DT +',GETDATE()) AS VARCHAR) + ''분전'' '    
    
SET @SQL = @SQL +'    
ELSE CONVERT(VARCHAR(5), ISNULL(A.'+ @DISPLAY_DT +',A.REG_DT), 1)    
END AS TODAY    
        ,TA.SORT_ID ,E.AREA_A ,E.AREA_B    
        ,CASE WHEN TA.OPT_CODE = 69 THEN 4 WHEN PAPER_OPT&128=128 AND PAPER_OPT&256=256 THEN 3 WHEN PAPER_OPT&128=128 THEN 1 WHEN PAPER_OPT&256=256 THEN 2 ELSE 0 END PREFCLOSE    
        ,A.REG_DT ,A.START_DT ,A.ORDER_DT ,E.AREA_C ,TA.AD_KIND ,TB.PAYF ,TB.PAYFROM ,TB.PAYTO    
        ,CASE WHEN DG.DISPLAY_GOODS_ID IS NOT NULL THEN    
            CASE WHEN DG.START_DT<=CONVERT(VARCHAR(10),GETDATE(),121) AND DG.END_DT>=DATEADD(DAY,-1,GETDATE()) THEN ' + @DISPLAY_CASE_FAT + ' ELSE 0 END     
         ELSE    
            CASE WHEN TA.OPT_START_DT<=CONVERT(VARCHAR(10),GETDATE(),121) AND TA.OPT_END_DT>=DATEADD(DAY,-1,GETDATE()) THEN ' + @DISPLAY_CASE + ' ELSE 0 END                 
         END AS DISPLAY_OPT    
        ,TA.VERSION    
        ,TA.LINEADNO    
    ,TA.USER_ID    
        ,TA.CUID    
        ,TB.UPRIGHT_AGREE    
        ,TB.PAY_COMPANY_RULES    
        ,'''' AS SUBWAYLINE    
        ,'''' AS SUBWAYNAME    
        ,TB.WORKTIMEF    
        ,TB.WORKTIMEFROM    
        ,TB.WORKTIMETO    
        ,TB.SERVICE_PERIOD    
        ,TB.DAY_WEEK    
    ,TB.DAY_WEEK_OPTION2 AS WEEK_OPTION2  --일자리 개편 관련 일반 리스트 오류 관련     
        ,CASE WHEN US.LINEADNO IS NOT NULL THEN 1 ELSE 0 END AS US_SCRAP    
    ,CONVERT(VARCHAR(5), TA.END_DT, 1) AS END_DT    
    ,CONVERT(VARCHAR(5), TA.MOD_DT, 1) AS MOD_DT    
    ,E.AREA_COUNT    
  FROM ('+@SQLTEMP+') AS  A    
  JOIN MOBILE_JOB_TB AS TA WITH (NOLOCK) ON TA.LINEADID = A.LINEADID AND TA.INPUT_BRANCH = A.INPUT_BRANCH AND TA.LAYOUT_BRANCH = A.LAYOUT_BRANCH    
  JOIN PP_LINE_AD_AREA_1DAY_TB AS E WITH(NOLOCK) ON E.LINEADID = A.LINEADID AND E.INPUT_BRANCH = A.INPUT_BRANCH AND E.LAYOUT_BRANCH = A.LAYOUT_BRANCH AND E.[ORDER]=A.[ORDER]    
  JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB AS TB WITH (NOLOCK) ON TB.LINEADID = A.LINEADID AND TB.INPUT_BRANCH = A.INPUT_BRANCH AND TB.LAYOUT_BRANCH = A.LAYOUT_BRANCH    
  LEFT JOIN PP_USER_SCRAP_TB AS US WITH(NOLOCK) ON US.LINEADNO = A.LINEADNO AND US.CUID = @CUID    
  LEFT JOIN CY_FAT_AD_DISPLAY_GOOD_TB AS DG WITH(NOLOCK) ON DG.LINEADNO = TA.LINEADNO    
  LEFT JOIN PP_LOGO_OPTION_TB AS L WITH(NOLOCK) ON TA.LINEADID = L.LINEADID AND TA.INPUT_BRANCH = L.INPUT_BRANCH AND TA.LAYOUT_BRANCH = L.LAYOUT_BRANCH 
 ORDER BY A.ROWNUM OPTION(MAXDOP 2) '    
    
  --PRINT @SQLTEMP    
  --PRINT @SQLCOUNT    
  --PRINT LEN(@SQL)    
  --PRINT @SQL    
      
 --PRINT @WHEREMULTI    
 SET @SQL_PARAM = '    
  @PAGE             INT,    
 @PAGESIZE          INT,    
 @FINDCODE          VARCHAR(30),     
 @LEVEL           INT,    
 @METRO           VARCHAR(30),    
 @CITY             VARCHAR(30),    
 @DONG             VARCHAR(100),    
 @REGTERM          INT,    
 @ORDER           VARCHAR(100),    
  @LAYOUT_BRANCH      TINYINT,    
  @SUB_BRANCH         INT,    
  @IPADDR             VARCHAR(20),    
  @CUID               INT,    
  @POSITION_CODE      VARCHAR(15)    
'    
    
  EXECUTE SP_EXECUTESQL @SQLCOUNT,@SQL_PARAM,    
  @PAGE,    
 @PAGESIZE,    
 @FINDCODE,     
 @LEVEL,    
 @METRO,    
 @CITY,    
 @DONG,    
 @REGTERM,    
 @ORDER,    
  @LAYOUT_BRANCH,    
  @SUB_BRANCH,    
  @IPADDR,    
  @CUID,    
  @POSITION_CODE    
    
    
  EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM,    
  @PAGE,    
 @PAGESIZE,    
 @FINDCODE,     
 @LEVEL,    
 @METRO,    
 @CITY,    
 @DONG,    
 @REGTERM,    
 @ORDER,    
  @LAYOUT_BRANCH,    
  @SUB_BRANCH,    
  @IPADDR,    
  @CUID,    
  @POSITION_CODE    
      
 PRINT @SQLTEMP    
    
END 