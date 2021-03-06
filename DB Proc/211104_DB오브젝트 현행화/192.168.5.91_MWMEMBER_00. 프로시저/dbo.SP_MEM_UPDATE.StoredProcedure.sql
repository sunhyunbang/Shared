USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_MEM_UPDATE]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MEM_UPDATE]
/*************************************************************************************
 *  단위 업무 명 : 회원정보 수정 및 이력
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
 *************************************************************************************/
@CUID   int,
@MEMBER_CD char(1),
@USER_ID varchar(50),
@HPHONE varchar(14),
@EMAIL varchar(50) ,
@GEN char(1) ,
@BIRTH varchar(8) ,
@DUPINFO char(64) ,
@CONNINFO char(88),
@REALHP_YN char(1) 
AS
    SET NOCOUNT ON;
    DECLARE @ID_COUNT bit, @PWD_CHANGE_YN char(1)

    -- 관리자 체크
    SET @ID_COUNT = 0
    SELECT @ID_COUNT = COUNT(CUID) FROM CST_MASTER WITH(NOLOCK) 
    WHERE CUID = @CUID 
    
    if @MEMBER_CD = 2 
    begin
	   SET @REALHP_YN = ''
    end

    IF @ID_COUNT = 1
    BEGIN
		EXEC DBO.SP_CST_MASTER_BACKUP  @CUID --회원정보 백업 2016-11-10 정헌수
	   UPDATE CST_MASTER 
	   SET MEMBER_CD		   = @MEMBER_CD
		  , HPHONE		   = @HPHONE
		  , EMAIL			   = @EMAIL
		  , GENDER		   = @GEN
		  , BIRTH			   = @BIRTH
		  , DI			   = @DUPINFO
		  , CI		   	   = @CONNINFO
		  , MOD_ID		   = @USER_ID
		  , MOD_DT		   = GETDATE()
		  , REALHP_YN		   = @REALHP_YN
	   WHERE CUID = @CUID 

	   INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, HPHONE) 
        VALUES (@CUID, @USER_ID, GETDATE(), @HPHONE)
	   
	   RETURN(0) -- 성공
    END ELSE
    BEGIN
	   RETURN(500)  -- 실패
    END
GO
