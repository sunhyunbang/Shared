USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_TEST]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TEST]
/*************************************************************************************
 *  단위 업무 명 : 개인/기업 회원 가입 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-28
 *  수   정   자 :
 *  수   정   일 : 
 *  설        명 : 
 *
 * RETURN(@COM_ID)
 * DECLARE @COM_ID
 * EXEC @COM_ID=SP_MASTER_JOIN
 * SELECT @COM_ID
 
 declare @COM_ID INT 
 exec SP_TEST 0,'',@COM_ID OUTPUT
 select @COM_ID
 
 create table TMP_TB(
 aa int identity(1,1)
 ,bb varchar(10)
 )
 insert tmp_tb(bb) select  '1'
 select * FROm tmp_tb
 *************************************************************************************/
 -- 개인 정보
@CUID INT,
@USERID VARCHAR(50),

@COM_ID int output

--이력 정보
AS
	SET NOCOUNT ON;
	declare @CITY varchar(20)
	set @CITY ='경기'
	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한
		
		INSERT INTO __DEL__CST_PERSON_HP_DUPLICATE_TB (CUID,HPHONE ,REGDT ,STAT ,MODDT )
		select 10000000000,'010-000-0000',GETDATE(),0,GETDATE()
		SET @COM_ID = @@IDENTITY



GO
