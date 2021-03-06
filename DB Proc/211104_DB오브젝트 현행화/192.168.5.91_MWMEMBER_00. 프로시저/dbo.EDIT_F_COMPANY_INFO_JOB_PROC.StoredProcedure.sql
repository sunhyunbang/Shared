USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_F_COMPANY_INFO_JOB_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 구인 광고 등록 시 기업정보 / 담당자 정보 변경
 *  작   성   자 : 이근우
 *  작   성   일 : 2015-05-31
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  사 용  소 스 :

*************************************************************************************/
CREATE PROCEDURE [dbo].[EDIT_F_COMPANY_INFO_JOB_PROC]
	 @USERID		    VARCHAR(50)	          -- 회원아이디
  ,@BIZ_FLAG      CHAR(1)               -- 기업정보 저장 여부 (Y:저장, N:저장않함)
  ,@MANAGER_FLAG  CHAR(1)               -- 담당자 정보 저장 여부 (Y:저장, N:저장않함)
	,@SECTION_CD    CHAR(4)               -- 구인(S102)
	,@COM_NM		    VARCHAR(50)	  = ''    -- 회사명
  ,@MAIN_NUMBER   VARCHAR(14)	  = ''    -- 대표번호
	,@HOMEPAGE		  VARCHAR(100)	= ''    -- 홈페이지

  ,@MANAGER_NM    VARCHAR(30)   = ''
  ,@MANAGER_PHONE VARCHAR(15)   = ''
  ,@MANAGER_EMAIL VARCHAR(50)   = ''

	,@MAIN_BIZ		  VARCHAR(100)	= ''    -- 주요사업내용
	,@LOGO_IMG		  VARCHAR(200)	= ''    -- 로고이미지
	,@EX_IMAGE_1	  VARCHAR(200)	= ''    -- 기타 이미지
	,@EX_IMAGE_2	  VARCHAR(200)	= ''    -- 기타 이미지
	,@EX_IMAGE_3	  VARCHAR(200)	= ''    -- 기타 이미지
	,@EX_IMAGE_4	  VARCHAR(200)	= ''    -- 기타 이미지
  ,@CUID          INT
  ,@FAX           VARCHAR(14)   = ''
AS

BEGIN
--------------------------------
--벼룩시장 기업회원 테이블
--------------------------------

  /* 2017.01.25, 기획요청으로 구인공고 등록 시 기업정보 변경 않됨
  IF @BIZ_FLAG = 'Y'
  BEGIN    
    UPDATE B
       SET B.COM_NM = @COM_NM
         , B.MAIN_PHONE = @MAIN_NUMBER
         , B.HOMEPAGE = @HOMEPAGE
         , MOD_DT = GETDATE()
         , MOD_ID = @USERID
    --SELECT *
      FROM CST_MASTER A
      JOIN CST_COMPANY B ON A.COM_ID = B.COM_ID
     WHERE A.CUID = @CUID
    
    UPDATE B
       SET B.MAIN_BIZ = @MAIN_BIZ
         , B.LOGO_IMG = @LOGO_IMG
         , B.EX_IMAGE_1 = @EX_IMAGE_1
         , B.EX_IMAGE_2 = @EX_IMAGE_2
         , B.EX_IMAGE_3 = @EX_IMAGE_3
         , B.EX_IMAGE_4 = @EX_IMAGE_4
    --SELECT *
      FROM CST_MASTER A
      JOIN CST_COMPANY_JOB B ON A.COM_ID = B.COM_ID
     WHERE A.CUID = @CUID    
  END
  */

  IF @MANAGER_FLAG = 'Y'
  BEGIN


    UPDATE B
       SET B.MAIN_PHONE = @MAIN_NUMBER
         , B.FAX = @FAX
         , B.MOD_DT = GETDATE()
         , B.MOD_ID = @USERID
    -- SELECT *
      FROM CST_MASTER A
      JOIN CST_COMPANY B ON A.COM_ID = B.COM_ID
     WHERE A.CUID = @CUID

    UPDATE B
       SET B.MANAGER_NM = @MANAGER_NM
         , B.MANAGER_PHONE = @MANAGER_PHONE
         , B.MANAGER_EMAIL = @MANAGER_EMAIL    
    -- SELECT *
      FROM CST_MASTER A
      JOIN CST_COMPANY_JOB B ON A.COM_ID = B.COM_ID
     WHERE A.CUID = @CUID

  END

END
GO
