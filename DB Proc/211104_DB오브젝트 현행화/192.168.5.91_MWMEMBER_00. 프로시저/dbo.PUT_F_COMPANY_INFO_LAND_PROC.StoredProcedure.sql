USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_COMPANY_INFO_LAND_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 부동산 기업 정보 변경
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-03-14
 *  수   정   자 : 여운영
 *  수   정   일 : 2015-06-09
 *  설        명 : 부동산 중개업소 프로필 이미지 필드 추가
 *  사 용  소 스 :

*************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_F_COMPANY_INFO_LAND_PROC]
	 @CUID		    INT
	,@USERID		    VARCHAR(50)	  -- 회원아이디
	,@SECTION_CD    CHAR(4)       -- 구인(S102)
	,@PHONE         VARCHAR(14)	  -- 전화번호2
	,@FAX           VARCHAR(14)
	,@HOMEPAGE		  VARCHAR(100)	-- 홈페이지


	,@REG_NUMBER    VARCHAR(50)	  -- 등록번호
	,@INTRO		      VARCHAR(1000)	-- 업소소개
	
	,@ATTACHFILE varchar(200)=''	-- 프로필 이미지
	,@ETCINFO_SYNC tinyint = 0 
AS

DECLARE @COM_ID INT

SELECT @COM_ID = COM_ID
  FROM CST_MASTER
 WHERE CUID = @CUID
 
--------------------------------
--벼룩시장 기업회원 테이블
--------------------------------
UPDATE CST_COMPANY
   SET PHONE = @PHONE
     , FAX = @FAX
     , HOMEPAGE   = @HOMEPAGE
     , MOD_DT = GETDATE()
     , MOD_ID = @USERID
 WHERE	COM_ID = @COM_ID

UPDATE CST_COMPANY_LAND		
   SET REG_NUMBER = @REG_NUMBER
     , INTRO = @INTRO
     , LOGO_IMG = @ATTACHFILE	--중개업소 프로필 사진
     , ETCINFO_SYNC = @ETCINFO_SYNC
WHERE COM_ID = @COM_ID


BEGIN TRY

	IF @SECTION_CD = 'S103'
		BEGIN			
			------------------------------------------------------------------------------------------------
			-- 기업회원전환 - 부동산
			------------------------------------------------------------------------------------------------
			EXEC [FINDDB1].[PAPER_NEW].[DBO].[p_SyncMemberToHouseData] @CUID
		END
END TRY

BEGIN CATCH

END CATCH

GO
