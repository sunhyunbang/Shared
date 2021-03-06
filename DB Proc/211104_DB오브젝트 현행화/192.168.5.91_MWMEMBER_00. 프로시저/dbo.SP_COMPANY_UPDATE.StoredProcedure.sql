USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_UPDATE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_COMPANY_UPDATE]
/*************************************************************************************
 *  단위 업무 명 : 기업 수정 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
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
 *************************************************************************************/
@CUID INT,
@COM_ID int ,
@USERID varchar(50),
@NEW_COM_NM varchar(50),
@NEW_CEO_NM varchar(30) ,
@NEW_MAIN_PHONE varchar(14) ,
@NEW_PHONE varchar(14) ,
@NEW_FAX varchar(14) ,
@NEW_HOMEPAGE varchar(100) ,
--@NEW_USE_YN char(1) ,
@NEW_REGISTER_NO varchar(12) ,
@NEW_LAT decimal(16, 14) ,
@NEW_LNG decimal(17, 14) ,
@NEW_ZIP_SEQ int ,
@NEW_CITY varchar(50) ,
@NEW_GU varchar(50) ,
@NEW_DONG varchar(50) ,
@NEW_ADDR1 varchar(100) ,
@NEW_ADDR2 varchar(100) ,
@NEW_LAW_DONGNO char(10) ,
@NEW_MAN_NO varchar(25) ,
@NEW_ROAD_ADDR_DETAIL varchar(100),
@NEW_IS_MOUNT CHAR(1)
--@NEW_CUID int
AS
	SET NOCOUNT ON;
	DECLARE @ID_COUNT bit

	SET @ID_COUNT = 0
	SELECT @ID_COUNT = COUNT(COM_ID) FROM CST_COMPANY WITH(NOLOCK) WHERE CUID = @CUID -- 관리자 체크
									 AND COM_ID = @COM_ID
	SET  @NEW_CITY = DBO.FN_AREA_A_SHORTNAME(@NEW_CITY)-- 주소지 2글자로 제한
	
	IF @ID_COUNT = 1
	BEGIN
		UPDATE CST_COMPANY SET 
						COM_NM = @NEW_COM_NM 
						,CEO_NM = @NEW_CEO_NM
						,MAIN_PHONE = @NEW_MAIN_PHONE
						,PHONE = @NEW_PHONE
						,FAX = @NEW_FAX
						,HOMEPAGE = @NEW_HOMEPAGE
						,LAT = @NEW_LAT
						,LNG = @NEW_LNG
						,ZIP_SEQ = @NEW_ZIP_SEQ
						,CITY = @NEW_CITY
						,GU = @NEW_GU
						,DONG = @NEW_DONG
						,ADDR1 = @NEW_ADDR1
						,ADDR2 = @NEW_ADDR2
						,LAW_DONGNO = @NEW_LAW_DONGNO
						,MAN_NO = @NEW_MAN_NO
						,ROAD_ADDR_DETAIL = @NEW_ROAD_ADDR_DETAIL
						,MOD_ID	= @USERID
						,MOD_DT	= GETDATE()
						,IS_MOUNT = @NEW_IS_MOUNT
						WHERE CUID = @CUID AND COM_ID = @COM_ID

		INSERT INTO CST_COMPANY_HISTORY (COM_ID,MOD_ID, MOD_DT, COM_NM, CEO_NM, MAIN_PHONE, PHONE, FAX, HOMEPAGE,
										 REGISTER_NO,LAT,LNG,ZIP_SEQ,CITY,GU,DONG, ADDR1,ADDR2,LAW_DONGNO,MAN_NO,ROAD_ADDR_DETAIL,CUID,IS_MOUNT) 
								 VALUES (@COM_ID,@USERID,GETDATE(),@NEW_COM_NM,@NEW_CEO_NM,@NEW_MAIN_PHONE,@NEW_PHONE,@NEW_FAX,@NEW_HOMEPAGE,
										 @NEW_REGISTER_NO,@NEW_LAT,@NEW_LNG,@NEW_ZIP_SEQ,@NEW_CITY,@NEW_GU,@NEW_DONG,
										 @NEW_ADDR1,@NEW_ADDR2,@NEW_LAW_DONGNO,@NEW_MAN_NO,@NEW_ROAD_ADDR_DETAIL,@CUID, @NEW_IS_MOUNT)
			RETURN(0) -- 성공
		END ELSE
		BEGIN
			RETURN(500)  -- 실패
		END
GO
