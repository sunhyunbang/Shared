/*************************************************************************************  
 *  단위 업무 명 : 구인관리자 > 등록대행 > 줄광고 기본정보 등록  
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)  
 *  작   성   일 : 2013/07/24  
 *  수   정   자 : 이 근 우 (stari@mediawill.com)  
 *  수   정   일 : 2013/11/21  
 *  수 정  내 용 : 옵션코드 변경에 따른 수정  
 *  수   정   자 : 방 순 현        
 *  수   정   일 : 2021/10/12 
 *  수 정 내  용 : 로고검수 프로세스 개선
 *  설        명 :  
 *  주 의  사 항 :  
 *  사 용  소 스 : 구인관리자/onlinemanage/Agency_Regist_Proc.asp  
 *  사 용  예 제 : EXEC DBO.PUT_M_JOB_ONLINE_LINEAD_PROC  
  
declare @p28 int  
set @p28=111529111  
exec PUT_M_JOB_ONLINE_LINEAD_PROC 111529111,80,80,'cowto7602','0000000000',0,4020101,1400001,14,'14','1401','14010001','213','채용담당자','02-1111-1111,02-3333-3333','','','별나라 공이','www.findall.co.kr','2019-01-07','2019-02-06','stari','관리자 등록테스트 1/7','0','star
i@mediawill.com','','Modify',@p28 output,0,'N','','',10504172,0,1,''  
select @p28  

@LINEADID : 0
@INPUT_BRANCH: 80
@LAYOUT_BRANCH: 80
@USER_ID:
@LAYOUTCODE: 0000000000
@CLASSCODE: 0
@FINDCODE: 4050101
@DETAILADCODE: 1400001
@GROUP_CD: 14
@AREA_A: 11
@AREA_B: 1119
@AREA_C: 11190000
@AREA_DETAIL:
@ORDER_NAME: 채용담당자
@PHONE: 010-6231-8117,02-2061-0031
@CONTENTS:
@FIELD_3: 00
@FIELD_6: 창대파출
@FIELD_11:
@START_DT: 2020-07-21
@END_DT: 2020-08-20
@MAG_ID: kafka84
@TITLE: 홀서빙전문.가입비 없음.일많음.남여 주방보조,파출,가사도우미,청소
@MWPLUS: 0
@ORDER_EMAIL:
@HPHONE: 010-6231-8117
@PRC_TYPE: Regist
@PARTNERF: 1
@RESERVE_YN : N
@RESERVE_START_DT:
@RESERVE_END_DT:
@CUID:
@FEDERATIONF: 0
@KINFAF: 1
@TEMPACPTID:

exec PUT_M_JOB_ONLINE_LINEAD_PROC 
0,80,80,'','0000000000',0,4050101,1400001,14,'11','1119','11190000','','채용담당자',
'010-6231-8117,02-2061-0031',
'',
'00',
'창대파출',
'',
'2020-07-21',
'2020-08-20',
'kafka84',
'홀서빙전문.가입비 없음.일많음.남여 주방보조,파출,가사도우미,청소',
'0',
'',
'010-6231-8117',
'Regist',
0,
1,
'N',
'',
'',
'',
0,
1,
''   
 *************************************************************************************/  
  
  
ALTER PROC [dbo].[PUT_M_JOB_ONLINE_LINEAD_PROC]  
  
  @LINEADID                 INT = 0  
, @INPUT_BRANCH             TINYINT  
, @LAYOUT_BRANCH            TINYINT  
, @USER_ID                  VARCHAR(50)  
, @LAYOUTCODE               VARCHAR(10)  
, @CLASSCODE                INT  
, @FINDCODE                 INT  
, @DETAILADCODE             INT  
, @GROUP_CD                 TINYINT  
, @AREA_A                   VARCHAR(30) = NULL
, @AREA_B                   VARCHAR(30) = NULL
, @AREA_C                   VARCHAR(30) = NULL
, @AREA_DETAIL              VARCHAR(60) = NULL
, @ORDER_NAME               VARCHAR(20)  
, @PHONE                    VARCHAR(127)  
, @CONTENTS                 VARCHAR(1000)  
, @FIELD_3                  VARCHAR(100)  
, @FIELD_6                  VARCHAR(100)  
, @FIELD_11                 VARCHAR(100)  
, @START_DT                 VARCHAR(10)  
, @END_DT                   VARCHAR(10)  
, @MAG_ID                   VARCHAR(30)  
, @TITLE                    VARCHAR(500)  
, @MWPLUS                   CHAR(1)       = '0'  
, @ORDER_EMAIL              VARCHAR(50)   = NULL  
, @HPHONE                   VARCHAR(127)  = NULL  
, @PRC_TYPE                 VARCHAR(6)    = ''      -- 처리형태 (Regist: 등록, Modify: 수정)   
, @OUTPUT_LINEADID          INT OUTPUT  
, @PARTNERF                 TINYINT       = 0  
, @RESERVE_YN               VARCHAR(1)    = 'N'  
, @RESERVE_START_DT         VARCHAR(20)   = NULL  
, @RESERVE_END_DT           VARCHAR(20)   = NULL  
, @CUID                     INT           = NULL  
, @FEDERATIONF              TINYINT       = 0  
, @KINFAF                   TINYINT       = 0 
, @TEMPACPTID               VARCHAR(25)   = NULL  
, @SENIORTVF                TINYINT       = 0 

AS  
  
BEGIN  
  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SET NOCOUNT ON  
  
  -- 게재대기처리를 위해 ISSTORAGE = 2 로 셋팅  
  DECLARE @ISSTORAGE INT = 0        
  IF @TEMPACPTID IS NOT NULL AND @TEMPACPTID <> '' BEGIN  
    SET @ISSTORAGE = 2  
  END  
  
  IF @PRC_TYPE = '' BEGIN   -- 처리형태값이 입력되어있지 않으면 처리 종료  
    SET @OUTPUT_LINEADID = 0  
    RETURN  
  END  
  ELSE BEGIN  
    -- LINEADID가 0이고 MWPLUS를 통한 등록대행이 아닌 경우 LINEADID 값 신규 생성  
    IF @LINEADID = 0 BEGIN
      -- 공고번호 채번 방식 변경  
      SET @LINEADID = dbo.FN_GETLINEADID('M')  
      --EXEC @LINEADID = PUT_CM_PP_AD_LINEADID_PROC
    END  
  
    -- UNIQUEKEY(LINEADNO) 생성  
    DECLARE @LINEADNO CHAR(16)  
    SET @LINEADNO = dbo.FN_LINEADNO(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH)  
  
    -- 보류중인 광고라면 일반게재 시작/종료일 유지 (2018.09.13)  
    IF EXISTS(SELECT * FROM PP_AD_HOLDOFF_TB WHERE STAT = 0 AND LINEADNO = @LINEADNO)  
      BEGIN  
        SELECT @START_DT = START_DT  
              ,@END_DT = END_DT  
          FROM PP_AD_TB  
         WHERE LINEADNO = @LINEADNO  
      END  
  
    -- 수정  
    --IF EXISTS(SELECT LINEADID FROM PP_AD_TB WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUT_BRANCH AND LAYOUT_BRANCH = @LAYOUT_BRANCH)  
    IF @PRC_TYPE = 'Modify' BEGIN  
   
      UPDATE PP_AD_TB  
         SET USER_ID        = @USER_ID  
            ,LAYOUTCODE     = @LAYOUTCODE  
            ,CLASSCODE      = @CLASSCODE  
            ,FINDCODE       = @FINDCODE  
            ,DETAILADCODE   = @DETAILADCODE  
            ,GROUP_CD       = @GROUP_CD  
            ,AREA_A         = DBO.FN_AREA_CODE_NAME(1, @AREA_A)  
            ,AREA_B         = DBO.FN_AREA_CODE_NAME(2, @AREA_B)  
            ,AREA_C         = DBO.FN_AREA_CODE_NAME(3, @AREA_C)  
            ,AREA_DETAIL    = @AREA_DETAIL  
            ,ORDER_NAME     = @ORDER_NAME  
            ,PHONE          = dbo.fn_MakeNomalPhone(@PHONE, @INPUT_BRANCH, @LAYOUT_BRANCH)  
            ,CONTENTS       = @CONTENTS  
            ,FIELD_3        = @FIELD_3  
            --,FIELD_6        = dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
            ,FIELD_11       = @FIELD_11  
            ,START_DT       = CASE WHEN @START_DT = '' OR @START_DT IS NULL THEN START_DT ELSE @START_DT END  
            ,END_DT         = CASE WHEN @END_DT = '' OR @END_DT IS NULL THEN END_DT ELSE @END_DT END  
            --,MAG_ID         = @MAG_ID            -- 수정시에는 관리자아이디 갱신 안함.  
            --,TITLE          = dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
            ,ORDER_EMAIL    = @ORDER_EMAIL  
            ,PARTNERF       = @PARTNERF  
            ,MOD_DT         = GETDATE()  
            ,CUID            = @CUID  
            ,TITLE = CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN TITLE ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T') END
            ,FIELD_6 = CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN FIELD_6 ELSE dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C') END
       WHERE LINEADNO = @LINEADNO  

    /* 수정내용(제목,회사명) 항목 업데이트 21.09.23*/
   IF EXISTS(SELECT LINEADID FROM PP_LOGO_OPTION_TB WHERE LINEADNO = @LINEADNO)    
   BEGIN
    UPDATE PP_LOGO_OPTION_TB
       SET WAIT_TITLE = CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T') ELSE NULL END     
          ,WAIT_COMPANY = CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C') ELSE NULL END  
          ,PUB_LOGO = CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN PUB_LOGO ELSE WAIT_LOGO END
     WHERE LINEADNO = @LINEADNO
   END
  
      /*제 3자 제공동의 값*/  
      UPDATE PP_AD_PARTNER_TB   
         SET PARTNERF = @PARTNERF,  
             FEDERATIONF = @FEDERATIONF,  
             KINFAF = @KINFAF,  
             SENIORTVF = @SENIORTVF
       WHERE LINEADNO = @LINEADNO  
  
      IF @RESERVE_YN = 'Y' BEGIN  
        IF EXISTS (SELECT * FROM PP_AD_RESERVE_TB WITH(NOLOCK) WHERE LINEADNO = @LINEADNO) BEGIN  
          -- LOG 저장  
          INSERT INTO PP_AD_RESERVE_LOG_TB (LINEADNO, RESERVE_START_DT, RESERVE_END_DT, REG_DT, RESERVE_STAT, MODIFY_DT)  
          SELECT LINEADNO, RESERVE_START_DT, RESERVE_END_DT, REG_DT, RESERVE_STAT, MODIFY_DT  
            FROM PP_AD_RESERVE_TB  
           WHERE LINEADNO = @LINEADNO  
             AND RESERVE_STAT IN ('등록', '예약')  
  
          UPDATE A  
             SET A.RESERVE_START_DT = @RESERVE_START_DT  
               , A.RESERVE_END_DT = @RESERVE_END_DT  
            FROM PP_AD_RESERVE_TB AS A  
           WHERE A.LINEADNO = @LINEADNO  
             AND A.RESERVE_STAT IN ('등록', '예약')  
        END  
        ELSE BEGIN  
          INSERT PP_AD_RESERVE_TB (  
                   LINEADNO  
                  ,RESERVE_START_DT  
                  ,RESERVE_END_DT  
                  ,REG_DT  
                  ,RESERVE_STAT  
                  ,MODIFY_DT  
                )  
          SELECT @LINEADNO  
               , @RESERVE_START_DT  
               , @RESERVE_END_DT  
               , GETDATE()  
               , '예약'  
               , NULL  
        END  
      END  
    END  
    ELSE IF @PRC_TYPE = 'Regist' BEGIN  
  
      INSERT INTO PP_AD_TB  
        (LINEADID  
        ,INPUT_BRANCH  
        ,LAYOUT_BRANCH  
        ,USER_ID  
        ,LAYOUTCODE  
        ,CLASSCODE  
        ,FINDCODE  
        ,DETAILADCODE  
        ,GROUP_CD  
        ,AREA_A  
        ,AREA_B  
        ,AREA_C  
        ,AREA_DETAIL  
        ,ORDER_NAME  
        ,PHONE  
        ,CONTENTS  
        ,FIELD_3  
        ,FIELD_6  
        ,FIELD_11  
        ,START_DT  
        ,END_DT  
        ,MAG_ID  
        ,TITLE  
        ,ORDER_EMAIL  
        ,[VERSION]  
        ,LINEADNO  
        ,PAY_FREE  
        ,PREFCLOSE  
        ,PARTNERF  
        ,CUID  
        ,ISSTORAGE  
        )  
      VALUES  
        (@LINEADID  
        ,@INPUT_BRANCH  
        ,@LAYOUT_BRANCH  
        ,@USER_ID  
        ,@LAYOUTCODE  
        ,@CLASSCODE  
        ,@FINDCODE  
        ,@DETAILADCODE  
        ,@GROUP_CD  
        ,DBO.FN_AREA_CODE_NAME(1, @AREA_A)  
        ,DBO.FN_AREA_CODE_NAME(2, @AREA_B)  
        ,DBO.FN_AREA_CODE_NAME(3, @AREA_C)  
        ,@AREA_DETAIL  
        ,@ORDER_NAME  
        ,dbo.fn_MakeNomalPhone(@PHONE, @INPUT_BRANCH, @LAYOUT_BRANCH)  
        ,''
        ,@FIELD_3  
        ,dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@FIELD_6, 'C')  
        ,@FIELD_11  
        ,@START_DT  
        ,@END_DT  
        ,@MAG_ID  
        ,dbo.FN_FJ_REMOVE_SPECIAL_CHARS(@TITLE, 'T')  
        ,@ORDER_EMAIL  
        ,'M'  
        ,@LINEADNO  
        ,0      -- PAY_FREE  
        ,0   -- PREFCLOSE  
        ,@PARTNERF  
        ,@CUID  
        ,@ISSTORAGE  
        )  
  
      /*제 3자 제공동의 값*/
      DELETE FROM PP_AD_PARTNER_TB WHERE LINEADNO = @LINEADNO

      INSERT PP_AD_PARTNER_TB (LINEADNO, PARTNERF, FEDERATIONF, KINFAF, SENIORTVF)  
      VALUES(@LINEADNO, @PARTNERF, @FEDERATIONF, @KINFAF, @SENIORTVF)      
  
      IF @RESERVE_YN ='Y' BEGIN  
        INSERT PP_AD_RESERVE_TB (  
                 LINEADNO  
                ,RESERVE_START_DT  
                ,RESERVE_END_DT  
                ,REG_DT  
                ,RESERVE_STAT  
                ,MODIFY_DT  
              )  
        SELECT @LINEADNO  
             , @RESERVE_START_DT  
             , @RESERVE_END_DT  
             , GETDATE()  
             , '예약'  
             , NULL  
      END  
  
      -- 신규등록이면서 Wills 임시키값이 있는 경우  (2017.03.13 최봉기)  
      IF @TEMPACPTID IS NOT NULL AND @TEMPACPTID <> '' BEGIN  
        -- 키값 매핑 데이터 등록  
        INSERT INTO PP_AD_WILLS_RELATION_TB  
          (temp_key, adid_ppad, inputbranch, adid_wills, adType, lineadno)  
        VALUES  
          (@TEMPACPTID, @LINEADID, @INPUT_BRANCH, 0, 1, @LINEADNO)  
      END  
    END  
  
    -- 전화번호 조회 TABLE에 등록  
    EXECUTE EDIT_PP_AD_PHONE_PROC @LINEADNO, @PHONE  
  
    SET @OUTPUT_LINEADID = @LINEADID  
  
  END  
  
END





