USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[PUT_AD_MM_COMPANY_TB_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 기업 회원 정보 업데이트
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC PUT_AD_MM_COMPANY_TB_INFO_PROC 'SEBILIA'

 *************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_AD_MM_COMPANY_TB_INFO_PROC]
		@CUID			INT,
	  @USERID		    VARCHAR(50),	
	  @BIZNO        CHAR(12),
	  @COM_NM       VARCHAR(50)=NULL,
	  @CEO          VARCHAR(30)=NULL,
	  @MAIN_NUMBER  VARCHAR(14)=NULL,
	  @FAX          VARCHAR(14)=NULL,
	  @PHONE        VARCHAR(14)=NULL,
	  @HOMEPAGE     VARCHAR(100)=NULL,
	  @LAT  decimal(16, 14),
		@LNG  decimal(17, 14),
	  @CITY         VARCHAR(50)=NULL,
	  @GU           VARCHAR(50)=NULL,
	  @DONG         VARCHAR(50)=NULL,
	  @ADDR1	  VARCHAR(100),	
		@ADDR2	  VARCHAR(100),	
		@LAW_DONGNO			CHAR(10),
		@MAN_NO				VARCHAR(25),	
		@ROAD_ADDR_DETAIL		VARCHAR(100),
		@ZIP_SEQ			INT,
		@REG_NUMBER		VARCHAR(50)=NULL
AS	
	
DECLARE @COM_ID INT

SELECT @COM_ID = COM_ID
  FROM CST_MASTER
 WHERE CUID = @CUID
 
IF @ZIP_SEQ = 0 
BEGIN
	SET @ZIP_SEQ = NULL
END
---------------------------------
-- 데이타 처리
---------------------------------
SET NOCOUNT ON

	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한

UPDATE CST_COMPANY
   SET REGISTER_NO = LTRIM(RTRIM(@BIZNO))
	, COM_NM = @COM_NM
	, CEO_NM = @CEO
	, MAIN_PHONE = @MAIN_NUMBER
	, FAX = @FAX
	, PHONE = LTRIM(RTRIM(@PHONE))
	, HOMEPAGE   = @HOMEPAGE
	, LAT = @LAT
	, LNG = @LNG
	, CITY		= dbo.FN_AREA_A_SHORTNAME(@CITY)
	, GU			= @GU
	, DONG   = @DONG
	, ADDR1  = @ADDR1
	, ADDR2  = @ADDR2
	, LAW_DONGNO		= @LAW_DONGNO
	, MAN_NO				= @MAN_NO
	, ROAD_ADDR_DETAIL  = @ROAD_ADDR_DETAIL
	, ZIP_SEQ	= @ZIP_SEQ
	, MOD_DT = GETDATE()
 WHERE COM_ID = @COM_ID
 
 IF @REG_NUMBER IS NOT NULL OR @REG_NUMBER <> ''
 BEGIN
	UPDATE CST_COMPANY_LAND
	   SET REG_NUMBER = @REG_NUMBER
	 WHERE COM_ID = @COM_ID

	exec FINDDB1.Paper_New.dbo.p_SyncMemberToHouseData @CUID --벼룩시장 부동산 sync용
	 
 END 
 ELSE BEGIN
	exec FINDDB1.Paper_New.dbo.p_SyncMemberToHouseData_IMDAE @CUID --임대사업자용 업데이트 처리
 END
 
   


GO
