    
/*************************************************************************************    
 *  단위 업무 명 : 프론트/관리자 > 플래티넘 로고 수정대기 등록/수정 처리    
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)    
 *  작   성   일 : 2012/08/29    
 *  수   정   자 : 신 장 순    
 *  수   정   일 : 2014.10.14    
 *  수 정  내 용 : PP_LOGO_OPTION_TB 테이블에 INSERT시 LINEADNO 추가    
 *  수   정   자 : 방 순 현            
 *  수   정   일 : 2021.10.12     
 *  수 정 내  용 : 로고검수 프로세스 개선    
 *  설        명 :    
 *  주 의  사 항 :    
 *  사 용  소 스 :    
 *  사 용  예 제 : EXEC DBO.PUT_CM_PP_LOGO_WAIT_PROC    
    
 exec PUT_CM_PP_LOGO_WAIT_PROC 3164359,181,180,'/UploadFilesJob/Job/Platinum/2019/07/16/0003164359181180_Logo_I5ME5RG804QMDRTD9WAL.jpg','',106103    
    
 exec PUT_CM_PP_LOGO_WAIT_PROC 3164378,181,180,'/UploadFilesJob/Job/Platinum/2019/07/16/0003164378181180_Logo_UYRHIQCAS5NTYLM752CW.jpg','',104163,0,null,null    
 *************************************************************************************/    
ALTER PROC [dbo].[PUT_CM_PP_LOGO_WAIT_PROC]    
    
  @LINEADID               INT    
, @INPUT_BRANCH           TINYINT    
, @LAYOUT_BRANCH          TINYINT    
, @LOGO_IMAGE             VARCHAR(200)    
, @MAIN_LOGO_IMAGE        VARCHAR(200)  = NULL    
, @LOGO_IMAGE_BYTE        INT           = 0    
, @LOGO_MAIN_IMAGE_BYTE   INT           = 0    
, @FAT_ID                 INT           = 0    
, @REGIST_ID              INT           = 0    
AS    
    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  SET NOCOUNT ON    
    
  -- UNIQUEKEY(LINEADNO) 생성    
  DECLARE @LINEADNO CHAR(16)    
  SET @LINEADNO = dbo.FN_LINEADNO(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH)    
  
  /* 21.11.09 재수정 대상 추가 */
  DECLARE @MOD_COUNT INT

  SELECT @MOD_COUNT = COUNT(PP_AD.LINEADID) FROM PP_AD_TB AS PP_AD  
  INNER JOIN PP_LOGO_OPTION_TB AS PP_LOGO  
  ON PP_AD.LINEADID = PP_LOGO.LINEADID  
  WHERE PP_AD.LINEADID = @LINEADID  AND PP_AD.INPUT_BRANCH = @INPUT_BRANCH AND PP_AD.LAYOUT_BRANCH = @LAYOUT_BRANCH
  AND (PP_AD.TITLE <> PP_LOGO.WAIT_TITLE  
  OR PP_AD.FIELD_6 <> PP_LOGO.WAIT_COMPANY  
  OR DBO.FN_ISNULL(PP_LOGO.PUB_LOGO,'') <> @LOGO_IMAGE  ) 
  /* 21.11.09 END */
    
  IF (SELECT COUNT(*) FROM PP_LOGO_OPTION_TB WHERE LINEADNO = @LINEADNO ) > 0    
    BEGIN -- 수정    
    
      IF @MOD_COUNT > 0 -- 21.11.09 재수정 대상 추가
        BEGIN
      
          /* 21.10.12 로고검수 프로세스 개선 */    
          IF dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y'     
            BEGIN    
              UPDATE PP_LOGO_OPTION_TB    
                 SET WAIT_LOGO      = @LOGO_IMAGE    
                    ,WAIT_DT        = GETDATE()    
                    ,PUB_CONFIRM    = 2    
                    ,WAIT_NEW       = 'Y'    
                    ,WAIT_LOGO_BYTE = @LOGO_IMAGE_BYTE    
               WHERE LINEADNO = @LINEADNO    
            END    
          ELSE    
            BEGIN    
              UPDATE PP_LOGO_OPTION_TB    
                 SET PUB_LOGO       = @LOGO_IMAGE    
                    ,WAIT_LOGO      = @LOGO_IMAGE    
                    ,WAIT_DT        = GETDATE()    
                    ,PUB_CONFIRM    = 1    -- 21.11.09 검수상태 값 추가
                    ,WAIT_LOGO_BYTE = @LOGO_IMAGE_BYTE    
               WHERE LINEADNO = @LINEADNO    
            END    
        END
        /* END 21.10.12 */    
    END    
  ELSE    
    BEGIN -- 등록    
      IF @INPUT_BRANCH = 181 AND @FAT_ID > 0 AND @REGIST_ID > 0 BEGIN --2019.07.17, 유료 상품 정액권 일 경우 메인로고 승인 처리    
        IF EXISTS (SELECT * FROM CY_FAT_MASTER_TB A WITH(NOLOCK)    
                            JOIN CY_FAT_REGIST_TB B WITH(NOLOCK) ON B.FAT_ID = A.FAT_ID WHERE B.FAT_ID = @FAT_ID AND B.REGIST_ID = @REGIST_ID AND A.FAT_TYPE = 3) BEGIN    
          SET @MAIN_LOGO_IMAGE = @LOGO_IMAGE    
        END    
      END             
      /* 21.10.12 로고검수 프로세스 개선 */    
      IF dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y'     
        BEGIN     
          INSERT INTO PP_LOGO_OPTION_TB    
          (LINEADID, INPUT_BRANCH, LAYOUT_BRANCH, MAIN_LOGO, WAIT_LOGO, WAIT_DT, WAIT_NEW, LINEADNO, WAIT_LOGO_BYTE, MAIN_LOGO_BYTE)    
          VALUES    
          (@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH, @MAIN_LOGO_IMAGE, @LOGO_IMAGE, GETDATE(), 'Y', @LINEADNO, @LOGO_IMAGE_BYTE, @LOGO_MAIN_IMAGE_BYTE)    
        END    
      ELSE    
        BEGIN    
          INSERT INTO PP_LOGO_OPTION_TB    
          (LINEADID, INPUT_BRANCH, LAYOUT_BRANCH, MAIN_LOGO, WAIT_LOGO, PUB_LOGO, PUB_CONFIRM , WAIT_DT, WAIT_NEW, LINEADNO, WAIT_LOGO_BYTE, MAIN_LOGO_BYTE)    
          VALUES    
          (@LINEADID, @INPUT_BRANCH, @LAYOUT_BRANCH, @MAIN_LOGO_IMAGE, @LOGO_IMAGE, @LOGO_IMAGE, '1', GETDATE(), 'Y', @LINEADNO, @LOGO_IMAGE_BYTE, @LOGO_MAIN_IMAGE_BYTE)    
        END    
        /*END 21.10.12 */    
    
    END 