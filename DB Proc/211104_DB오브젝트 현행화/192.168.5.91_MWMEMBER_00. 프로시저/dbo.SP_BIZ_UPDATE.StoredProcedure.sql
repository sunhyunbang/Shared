USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_BIZ_UPDATE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_BIZ_UPDATE]
/*************************************************************************************
 *  단위 업무 명 : 기업 수정 및 이력
 *  작   성   자 : JMG
 *  작   성   일 : 2016-08-18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500)  -- 실패
 * RETURN(0) -- 성공
 * DECLARE @RET INT
 * EXEC @RET=SP_COMPANY_UPDATE  3310506 , 49826 ,  'zxc75090' ,'진주공인중개사무소' ,'김은경','010-2267-5828', '02-000-0000', 
 * '054-475-5401','http://cyber.serve.co.kr/zxc75090'
 * , '513-11-38522', '33.47773717697358','124.84925073212366','','','','','경상북도 구미시 옥계동','789-3','4719012800','4719012800107890003036225', ''
 * SELECT @RET

 exec mwmember.dbo.sp_biz_update 11240821, 10135230, 'jacemin79', '', '02-1231-2312', '02-123-1234', '', '37.48571903953583', '126.98727305567036', '서울', '서초구', '방배동', '945-1', '1', '1165', '1165010100109450001011860', '', '', ''
 exec mwmember.dbo.sp_biz_update 13822888, 10135814, 'cbkland01', '', '02-1354-8648', '', '', '0', '0', '경기', '하남시', '학암동', '673', '123', '4145011600', '4145011600104310002000001', '위례그린파크 푸르지오', '123123', '', '', '대표자'
 *************************************************************************************/
@CUID int,
@COM_ID int ,
@USERID varchar(50),
@PHONE varchar(14),
@MAIN_PHONE varchar(14),
@FAX varchar(14) ,
@HOMEPAGE varchar(100) ,
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
@REG_NUMBER varchar(50) ,
@MANAGER_NM varchar(30) ,
@MANAGER_NUMBER varchar(20),
@CEO_NM varchar(30) 
AS
    SET NOCOUNT ON;
    DECLARE @ID_COUNT bit
	DECLARE @MEMBER_TYPE INT

    -- 관리자 체크
    SET @ID_COUNT = 0
    SELECT @ID_COUNT = COUNT(COM_ID) FROM CST_COMPANY WITH(NOLOCK) 
    WHERE COM_ID = @COM_ID

	SELECT @MEMBER_TYPE = MEMBER_TYPE
	FROM CST_COMPANY WITH(NOLOCK)
	WHERE COM_ID = @COM_ID

	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한

    IF @ID_COUNT = 1
    BEGIN
	   UPDATE CST_COMPANY 
	   SET MAIN_PHONE		   = @MAIN_PHONE
		  , CEO_NM		   = @CEO_NM
		  , PHONE			   = @PHONE
		  , FAX			   = @FAX
		  , HOMEPAGE		   = @HOMEPAGE
		  , LAT			   = @LAT
		  , LNG			   = @LNG
		  , CITY			   = @CITY
		  , GU			   = @GU
		  , DONG			   = @DONG
		  , ADDR1			   = @ADDR1
		  , ADDR2			   = @ADDR2
		  , LAW_DONGNO		   = @LAW_DONGNO
		  , MAN_NO		   = @MAN_NO
		  , ROAD_ADDR_DETAIL   = @ROAD_ADDR_DETAIL
		  , MOD_ID		   = @USERID
		  , MOD_DT		   = GETDATE()
	   WHERE COM_ID = @COM_ID

	   INSERT INTO CST_COMPANY_HISTORY (COM_ID,MOD_ID, MOD_DT, MAIN_PHONE, PHONE, FAX, HOMEPAGE, LAT, LNG, CITY, GU,DONG, ADDR1, ADDR2, LAW_DONGNO, MAN_NO, ROAD_ADDR_DETAIL, CUID) 
        VALUES (@COM_ID, @USERID, GETDATE(), @MAIN_PHONE, @PHONE, @FAX, @HOMEPAGE, @LAT, @LNG, @CITY, @GU,@DONG, @ADDR1, @ADDR2, @LAW_DONGNO, @MAN_NO, @ROAD_ADDR_DETAIL, @CUID)
	   
	   IF @MEMBER_TYPE = 2 
		  BEGIN
			  
			  IF EXISTS(select * FROM CST_COMPANY_LAND WITH(NOLOCK) where COM_ID = @COM_ID )
			  BEGIN
				  UPDATE CST_COMPANY_LAND
				  SET REG_NUMBER = @REG_NUMBER			
				  WHERE COM_ID = @COM_ID
			  END ELSE BEGIN
				  INSERT INTO CST_COMPANY_LAND (COM_ID, USERID, REG_NUMBER, MOD_DT)
				  VALUES (@COM_ID, @USERID, @REG_NUMBER, GETDATE())
			  END

			  INSERT INTO CST_COMPANY_LAND_HISTORY (COM_ID, USERID, REG_NUMBER, MOD_DT)
			  VALUES (@COM_ID, @USERID,  @REG_NUMBER, GETDATE())
		  END 
		  

	   IF @MEMBER_TYPE = 4 
	   BEGIN
		  UPDATE CST_COMPANY_AUTO
		  SET MANAGER_NM		   = @MANAGER_NM
			 , MANAGER_NUMBER	   = @MANAGER_NUMBER
		  WHERE COM_ID = @COM_ID

		  INSERT INTO CST_COMPANY_AUTO_HISTORY (COM_ID, USERID, MANAGER_NM, MANAGER_NUMBER) 
		  VALUES (@COM_ID, @USERID, @MANAGER_NM, @MANAGER_NUMBER)
	   END	
	   
	   IF EXISTS(select * FROM CST_COMPANY_LAND WITH(NOLOCK) where COM_ID = @COM_ID AND REG_NUMBER > '' )
	   BEGIN
		exec FINDDB1.Paper_New.dbo.p_SyncMemberToHouseData @cuid --벼룩시장 부동산 sync용
	   END 
	   ELSE BEGIN
		exec FINDDB1.Paper_New.dbo.p_SyncMemberToHouseData_IMDAE @cuid --임대사업자용 업데이트 처리
	   END  
  
	   RETURN(0) -- 성공
    END ELSE
    BEGIN
	   RETURN(500)  -- 실패
    END


GO
