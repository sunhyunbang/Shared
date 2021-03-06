USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_SERVICE_AGREE_BIZ_UPDATE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_SERVICE_AGREE_BIZ_UPDATE]
/*************************************************************************************
 *  단위 업무 명 : 서비스이용동의 기업 수정 및 이력
 *  작   성   자 : 최봉기
 *  작   성   일 : 2018-11-27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500)  -- 실패
 * RETURN(0) -- 성공
 * DECLARE @RET INT
 *************************************************************************************/
  @CUID int,
  @COM_ID int ,
  @USERID varchar(50),
  @MAIN_PHONE varchar(14),
  @FAX varchar(14) ,
  @LAT decimal(16, 14) ,
  @LNG decimal(17, 14) ,
  @CITY varchar(50) ,
  @GU varchar(50) ,
  @DONG varchar(50) ,
  @ADDR1 varchar(100) ,
  @ADDR2 varchar(100) ,
  @LAW_DONGNO char(10) ,
  @MAN_NO varchar(25) ,
  @ROAD_ADDR_DETAIL varchar(100),

  @REG_NUMBER varchar(50) = '',       -- 중개업 개설번호
  @MANAGER_NUMBER varchar(20) = '',    -- 자동차딜러 사원증번호

  @CEO_NM varchar(30)

AS

    SET NOCOUNT ON;
    DECLARE @ID_COUNT bit

    -- 관리자 체크
    SET @ID_COUNT = 0

    SELECT @ID_COUNT = COUNT(COM_ID) 
      FROM CST_COMPANY WITH(NOLOCK) 
     WHERE COM_ID = @COM_ID

	  SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한

    IF @ID_COUNT = 1
      BEGIN
	      UPDATE CST_COMPANY 
	         SET MAIN_PHONE		   = @MAIN_PHONE
              ,CEO_NM = @CEO_NM
		          ,FAX			   = @FAX
		          ,LAT			   = @LAT
		          ,LNG			   = @LNG
		          ,CITY			   = @CITY
		          ,GU			   = @GU
		          ,DONG			   = @DONG
		          ,ADDR1			   = @ADDR1
		          ,ADDR2			   = @ADDR2
		          ,LAW_DONGNO		   = @LAW_DONGNO
		          ,MAN_NO		   = @MAN_NO
		          ,ROAD_ADDR_DETAIL   = @ROAD_ADDR_DETAIL
		          ,MOD_ID		   = @USERID
		          ,MOD_DT		   = GETDATE()
	     WHERE COM_ID = @COM_ID

	     INSERT INTO CST_COMPANY_HISTORY (COM_ID,MOD_ID, MOD_DT, MAIN_PHONE, PHONE, FAX, HOMEPAGE, LAT, LNG, CITY, GU,DONG, ADDR1, ADDR2, LAW_DONGNO, MAN_NO, ROAD_ADDR_DETAIL, CUID) 
          VALUES (@COM_ID, @USERID, GETDATE(), @MAIN_PHONE, '', @FAX, '', @LAT, @LNG, @CITY, @GU,@DONG, @ADDR1, @ADDR2, @LAW_DONGNO, @MAN_NO, @ROAD_ADDR_DETAIL, @CUID)

      -- 자동차 딜러사원증 번호가 있는 경우
	    IF @MANAGER_NUMBER <> '' 
	      BEGIN
		      UPDATE CST_COMPANY_AUTO
		          SET MANAGER_NUMBER	   = @MANAGER_NUMBER
		        WHERE COM_ID = @COM_ID

		      INSERT INTO CST_COMPANY_AUTO_HISTORY (COM_ID, USERID, MANAGER_NM, MANAGER_NUMBER) 
		      VALUES (@COM_ID, @USERID, '', @MANAGER_NUMBER)
	      END	
	   
      IF EXISTS(select * FROM CST_COMPANY_LAND WITH(NOLOCK) where COM_ID = @COM_ID)
        BEGIN
          -- 부동산 중개업개설등록번호 갱신
          UPDATE CST_COMPANY_LAND
             SET REG_NUMBER = @REG_NUMBER
           WHERE COM_ID = @COM_ID

          exec FINDDB1.Paper_New.dbo.p_SyncMemberToHouseData @cuid --벼룩시장 부동산 sync용
        END 
      ELSE
        BEGIN
		      exec FINDDB1.Paper_New.dbo.p_SyncMemberToHouseData_IMDAE @cuid --임대사업자용 업데이트 처리
        END  
  
        RETURN(0) -- 성공

      END 
    ELSE
      BEGIN
        RETURN(500)  -- 실패
      END


GO
