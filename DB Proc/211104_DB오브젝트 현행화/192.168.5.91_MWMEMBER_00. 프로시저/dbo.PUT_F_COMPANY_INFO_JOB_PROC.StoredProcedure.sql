USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_COMPANY_INFO_JOB_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 구인 기업 정보 변경
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-03-14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  사 용  소 스 :
 select * from cst_master where userid= 'cowto7602'
 select * from cst_company where com_id = 10007475
*************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_F_COMPANY_INFO_JOB_PROC]
	 @CUID				        INT
	,@USERID		          VARCHAR(50)	  -- 회원아이디
	,@SECTION_CD          CHAR(4)       -- 구인(S102)
	,@COM_NM		          VARCHAR(50)	  -- 회사명
	,@CEO			            VARCHAR(30)	  -- 대표자
	,@MAIN_NUMBER         VARCHAR(14)	  -- 대표번호
	,@FAX                 VARCHAR(14)
	,@HOMEPAGE		        VARCHAR(100)	-- 홈페이지
	,@LAT                 DECIMAL(16, 14)
	,@LNG                 DECIMAL(17, 14)
	,@ZIP_SEQ             INT
	,@CITY			          VARCHAR(50) 	-- 시
	,@GU			            VARCHAR(50) 	-- 구
	,@DONG		            VARCHAR(50)	  -- 동
	,@ADDR1	              VARCHAR(100)	-- 번지
	,@ADDR2	              VARCHAR(100)	-- 상세주소	
	,@LAW_DONGNO		      CHAR(10)
	,@MAN_NO				      VARCHAR(25)	
	,@ROAD_ADDR_DETAIL		VARCHAR(100)	
	,@MANAGER_NM          VARCHAR(30)
	,@MANAGER_PHONE       VARCHAR(15)
	,@MANAGER_EMAIL       VARCHAR(50)
	,@EMP_CNT		          VARCHAR(7)	  -- 종업원수
	,@MAIN_BIZ		        VARCHAR(100)	-- 주요사업내용
	,@BIZ_CLASS		        VARCHAR(100)	  -- 업종
	,@BIZ_CODE		        VARCHAR(100)	-- 기업분류
	,@LOGO_IMG		        VARCHAR(200)	-- 로고이미지
	,@EX_IMAGE_1	        VARCHAR(200)	-- 기타 이미지
	,@EX_IMAGE_2	        VARCHAR(200)	-- 기타 이미지
	,@EX_IMAGE_3	        VARCHAR(200)	-- 기타 이미지
	,@EX_IMAGE_4	        VARCHAR(200)	-- 기타 이미지
AS

DECLARE @COM_ID INT
DECLARE @COUNT INT

SELECT @COM_ID = COM_ID
  FROM CST_MASTER
 WHERE CUID = @CUID

IF @ZIP_SEQ = 0 
BEGIN
	SET @ZIP_SEQ = NULL
END		  
	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한
		  
--------------------------------
--벼룩시장 기업회원 테이블
--------------------------------
UPDATE CST_COMPANY
   SET COM_NM = @COM_NM
     , CEO_NM = @CEO
     , MAIN_PHONE = @MAIN_NUMBER
     , FAX = @FAX
     , HOMEPAGE   = @HOMEPAGE
     , LAT = @LAT
     , LNG = @LNG
     , ZIP_SEQ = @ZIP_SEQ
	   , CITY		= @CITY
	   , GU			= @GU
     , DONG   = @DONG
     , ADDR1  = @ADDR1
     , ADDR2  = @ADDR2
     , LAW_DONGNO		= @LAW_DONGNO
     , MAN_NO				= @MAN_NO
     , ROAD_ADDR_DETAIL  = @ROAD_ADDR_DETAIL
     , MOD_DT     = GETDATE()
     , MOD_ID	=	@USERID
 WHERE COM_ID = @COM_ID
 
 SELECT @COUNT = COUNT(*)
 FROM CST_COMPANY_JOB
 WHERE COM_ID = @COM_ID
 
IF @COUNT = 0
BEGIN
	INSERT
    INTO CST_COMPANY_JOB
        (MANAGER_NM
        ,MANAGER_PHONE
        ,MANAGER_EMAIL
        ,EMP_CNT
        ,MAIN_BIZ
        ,BIZ_CLASS
        ,BIZ_CD
        ,LOGO_IMG
        ,EX_IMAGE_1
        ,EX_IMAGE_2
        ,EX_IMAGE_3
        ,EX_IMAGE_4
        ,COM_ID
        ,USERID
        ,SECTION_CD
		)
  VALUES
        (@MANAGER_NM
        ,@MANAGER_PHONE
        ,@MANAGER_EMAIL
        ,@EMP_CNT
        ,@MAIN_BIZ
        ,@BIZ_CLASS
        ,@BIZ_CODE
        ,@LOGO_IMG
        ,@EX_IMAGE_1
        ,@EX_IMAGE_2
        ,@EX_IMAGE_3
        ,@EX_IMAGE_4
        ,@COM_ID
        ,@USERID
        ,@SECTION_CD
        )
END
ELSE
BEGIN
	UPDATE CST_COMPANY_JOB
	   SET MANAGER_NM = @MANAGER_NM
		 , MANAGER_PHONE = @MANAGER_PHONE
		 , MANAGER_EMAIL = @MANAGER_EMAIL
		 , EMP_CNT    = @EMP_CNT
		 , MAIN_BIZ   = @MAIN_BIZ   
		 , BIZ_CLASS  = @BIZ_CLASS
		 , BIZ_CD	  = @BIZ_CODE
		 , LOGO_IMG   = @LOGO_IMG
		 , EX_IMAGE_1 = @EX_IMAGE_1
		 , EX_IMAGE_2 = @EX_IMAGE_2
		 , EX_IMAGE_3 = @EX_IMAGE_3
		 , EX_IMAGE_4 = @EX_IMAGE_4         
	 WHERE COM_ID = @COM_ID
END
GO
