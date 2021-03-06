USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_BIZ_SERVE_UPDATE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_BIZ_SERVE_UPDATE]
/*************************************************************************************
 *  단위 업무 명 : 기업 수정 및 이력(부동산써브 용)
 *  작   성   자 : KJH
 *  작   성   일 : 2018-10-10
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
 
 exec dbo.SP_BIZ_SERVE_UPDATE @cuid=13621996, @MAIN_PHONE='02-747-9945', @FAX='02-12-3123', @CEO_NM='테스트', @addr1='1692-1 11f', @addr2='1692-1 11f', @law_dongno='1171010300', @REG_NUMBER='12224343', @CITY='서울', @GU='송파구', @DONG='풍납동' 
 *************************************************************************************/
@CUID int,
@MAIN_PHONE varchar(14),
@FAX varchar(14) ,
@CEO_NM varchar(50),
@ADDR1 varchar(100) ,
@ADDR2 varchar(100) ,
@LAW_DONGNO char(10) ,
@REG_NUMBER varchar(50),
@CITY VARCHAR(50),
@GU VARCHAR(50),
@DONG VARCHAR(50),
@MAN_NO varchar(25),
@ROAD_ADDR_DETAIL varchar(100)
AS
    SET NOCOUNT ON;

	declare @COM_ID int

	
	
	select @COM_ID=com_id from dbo.cst_master with(nolock) where cuid=@CUID
	
	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한

	   UPDATE CST_COMPANY 
	   SET MAIN_PHONE		= @MAIN_PHONE
		  , FAX			    = @FAX
		  , CEO_NM			= @CEO_NM		  
		  , ADDR2			= @ADDR2
		  , LAW_DONGNO		= @LAW_DONGNO
		  , CITY			= @CITY
		  , GU				= @GU		  
		  , DONG			= @DONG		  
		  , MOD_DT		    = GETDATE()
		  , MAN_NO			= @MAN_NO
		  , ROAD_ADDR_DETAIL =@ROAD_ADDR_DETAIL
	   WHERE COM_ID = @COM_ID
	   
	   
	   UPDATE CST_COMPANY_LAND
	   SET REG_NUMBER =@REG_NUMBER
	   WHERE COM_ID = @COM_ID

	   INSERT INTO CST_COMPANY_HISTORY ( MOD_DT, MAIN_PHONE,  FAX,  ADDR2, LAW_DONGNO,   CUID) 
       VALUES (  GETDATE(), @MAIN_PHONE,  @FAX, @ADDR2, @LAW_DONGNO, @CUID)



GO
