USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_BIZ_JOIN]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_MASTER_BIZ_JOIN]
/*************************************************************************************
 *  단위 업무 명 : 기업 회원 가입 및 이력
 *  작   성   자 : JMG
 *  작   성   일 : 2016-08-17
 *  수   정   자 : 배진용
 *  수   정   일 : 2020-10-07 
 *  설        명 : ADMIN 회원가입 대행 프로세스 추가( [CST_MASTER] 테이블에 컬럼 추가) - 2020-10-07
                     1. AGENCY_YN: 회원가입 대행 여부 (Y:회원가입 대행, N:일반 회원가입)
                     2. LAST_SIGNUP_YN: 최종 회원가입 여부 (Y:최종 회원가입 완료, N:최종회원가입 미완료 -> 미완료시 로그인할경우 최종회원가입 페이지로 이동)
 
 exec mwmember.dbo.sp_master_biz_join 'bird3325334', 'solip79!', 'Y', '2', '2', '조민기', '010-6393-0923', 'bird3325@hanmail.net', 'M', '19770713', '', '', 'MC0GCCqGSIb3DQIJAyEActtpjaNTuHntREaitYRGxqwzecHEwbwNX4bWviXJtxI=', 'JOUJUr8hLNW05kex2bmzmLJyLkENLUnlvOzersngAEvLEbQ8xcfivK2clAWQT0LIkURW5AHNRhmJ9NSHsdI1iw==', '이리로 부동산', '이리로', '02-1231-2312', '', '', '123-12-31231', '37.53381894677408', '127.00149798244381', '서울', '용산구', '한남동', '657-34', '1F', '1117013100', '1117013100106570034005346', '', '가-45121512', '', '', '', 'member.serve.co.kr', 0, 0, 0
 exec mwmember.dbo.sp_master_biz_join 'bird5896', 'solip79!', 'Y', '2', '1', '조민기', '010-6393-0923', 'bird3325@hanmail.net', 'M', '19770713', '', '', 'MC0GCCqGSIb3DQIJAyEActtpjaNTuHntREaitYRGxqwzecHEwbwNX4bWviXJtxI=', 'JOUJUr8hLNW05kex2bmzmLJyLkENLUnlvOzersngAEvLEbQ8xcfivK2clAWQT0LIkURW5AHNRhmJ9NSHsdI1iw==', '황제 라이팅', '홍길동', '02-1231-2312', '', '', '123-12-31231', '37.53379371552779', '127.0017333144492', '서울', '용산구', '한남동', '657-37', '', '1117013100', '1117013100106570037005350', '', '', '', '', 'S', '2016.serve.co.kr', 0, 'H001', 0, 0	
 *************************************************************************************/
@USERID  varchar(50),
@PWD  VARCHAR(30),
@ADULT_YN  char(1),
@MEMBER_CD  char(1),
@MEMBER_TYPE char(1),
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@EMAIL  varchar(50),
@GENDER  char(1),
@BIRTH  varchar(8),
@SNS_TYPE  char(1),
@SNS_ID  varchar(25),
@DI  char(64),
@CI  char(88),
@COM_NM  varchar(50),
@CEO_NM  varchar(30),
@MAIN_PHONE  varchar(14),
@PHONE  varchar(14),
@FAX  varchar(14),
@REGISTER_NO  varchar(12),
@LAT  decimal(16, 14),
@LNG  decimal(17, 14),
@CITY  varchar(50),
@GU  varchar(50),
@DONG  varchar(50),
@ADDR1  varchar(100),
@ADDR2  varchar(100),
@LAW_DONGNO  char(10),
@MAN_NO  varchar(25),
@ROAD_ADDR_DETAIL  varchar(100),
@REG_NUMBER  varchar(50),
@MANAGER_NM  varchar(30),
@MANAGER_NUMBER  varchar(20),
--이력 정보
@SITE_CD char(1),
--@JOIN_PATH varchar(50),
@JOIN_DOMAIN varchar(50),
@JOIN_OBJECT INT ,
@Section_CD varchar(10),
@JOIN_IP	varchar(20),
@CUID int = 0 output,
@COM_ID int = 0 output,
@AGENCY_YN char(1) = 'N',
@LAST_SIGNUP_YN char(1) = 'Y'

AS
SET NOCOUNT ON;
--DECLARE @CUID INT, @ID_COUNT BIT, @COM_ID INT
DECLARE @ID_COUNT BIT, @LAND_SEQ INT, @AUTO_SEQ INT, @PWD_NEXT_ALARM_DT DATETIME

SET @PWD_NEXT_ALARM_DT = GETDATE() + 180
	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한

--    SELECT @CUID = MAX(CUID) + 1 FROM CST_MASTER
  BEGIN
	  -- 2020-10-07 ADMIN회원가입 대행 AGENCY_YN 컬럼 추가 
	  INSERT INTO CST_MASTER (USERID, USER_NM, BAD_YN, JOIN_DT, MOD_DT, MOD_ID, pwd_sha2, PWD_NEXT_ALARM_DT, MEMBER_CD, ADULT_YN, HPHONE, EMAIL, GENDER, BIRTH, DI, CI, SITE_CD, REST_YN, OUT_YN, LAST_LOGIN_DT, JOIN_IP, AGENCY_YN, LAST_SIGNUP_YN)
	  VALUES (@USERID, @USER_NM, 'N',   GETDATE(), GETDATE(), @USERID, master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD))), @PWD_NEXT_ALARM_DT, @MEMBER_CD, @ADULT_YN, @HPHONE, @EMAIL, @GENDER, @BIRTH, @DI, @CI, @SITE_CD, 'N', 'N', GETDATE(), @JOIN_IP, @AGENCY_YN, @LAST_SIGNUP_YN)
	  SET @CUID = SCOPE_IDENTITY() 
	  
	   -- 써브 비번 변경 호출 2016.09.07 jmg
	  --exec [221.143.23.211,8019].rserve.dbo.SV_PWD_SYNC @CUID, @PWD
	  	  
	  INSERT INTO lawdongno_history (CUID, LAW_DONGNO, M_TYPE)
	  VALUES (@CUID, @LAW_DONGNO, 'I')
	   
	  IF len(@LAW_DONGNO) = 4
	  BEGIN     
		SET @LAW_DONGNO = LEFT(@MAN_NO,10)		
	  END 
	   
	  IF @MEMBER_CD = 2
	  BEGIN
		  -- CST_COMPANY
		  INSERT INTO CST_COMPANY (REG_ID, COM_NM, CEO_NM, MAIN_PHONE, PHONE, FAX, REGISTER_NO, LAT, LNG, CITY, GU, DONG, ADDR1, ADDR2, LAW_DONGNO, MAN_NO, ROAD_ADDR_DETAIL,  REG_DT, MOD_ID, MOD_DT, MEMBER_TYPE)
		  VALUES (@USERID, @COM_NM, @CEO_NM, @MAIN_PHONE, @PHONE, @FAX, @REGISTER_NO, @LAT, @LNG, @CITY, @GU, @DONG, @ADDR1, @ADDR2, @LAW_DONGNO, @MAN_NO, @ROAD_ADDR_DETAIL,  GETDATE(), @USERID, GETDATE(),@MEMBER_TYPE)
		  
		  SET @COM_ID = SCOPE_IDENTITY() 
		  
		  UPDATE CST_MASTER SET COM_ID = @COM_ID
		  WHERE CUID = @CUID
		  
		  IF @MEMBER_TYPE = 2 
		  BEGIN
			  INSERT INTO CST_COMPANY_LAND (COM_ID, USERID, REG_NUMBER, MOD_DT)
			  VALUES (@COM_ID, @USERID, @REG_NUMBER, GETDATE())
			
			  INSERT INTO CST_COMPANY_LAND_HISTORY (COM_ID, USERID, REG_NUMBER, MOD_DT)
			  VALUES (@COM_ID, @USERID,  @REG_NUMBER, GETDATE())
		  END 
		  
		  IF @MEMBER_TYPE = 4 
		  BEGIN
			  INSERT INTO CST_COMPANY_AUTO (COM_ID, USERID, MANAGER_NM, MANAGER_NUMBER, MOD_DT)
			  VALUES (@COM_ID, @USERID, @MANAGER_NM, @MANAGER_NUMBER, GETDATE())
/*			 
			SELECT @AUTO_SEQ = MAX(SEQ) + 1 FROM CST_COMPANY_AUTO_HISTORY
			IF @AUTO_SEQ IS NULL 
			BEGIN
			  SET @AUTO_SEQ = 1
			END
*/			
			  INSERT INTO CST_COMPANY_AUTO_HISTORY (COM_ID, USERID, MANAGER_NM, MANAGER_NUMBER, MOD_DT) --SEQ
			  VALUES (@COM_ID, @USERID, @MANAGER_NM, @MANAGER_NUMBER, GETDATE()) --@AUTO_SEQ ,
		  END 

		/* 구인 기업 기본정보 입력(담당자 )*/
		
		INSERT CST_COMPANY_JOB(COM_ID,USERID,MANAGER_NM,MANAGER_PHONE,MANAGER_EMAIL,section_CD)
			SELECT 
			B.COM_ID,A.USERID,A.USER_NM,A.HPHONE,A.EMAIL,'S102'
			 FROM CST_MASTER A 
			INNER JOIN CST_COMPANY B ON A.COM_ID = B.COM_ID  
			LEFT OUTER JOIN CST_COMPANY_JOB C ON A.COM_ID = C.COM_ID 
			WHERE C.COM_ID IS NULL
			AND A.OUT_YN ='N'
			AND A.CUID = @CUID	
			
		
	   IF EXISTS(select * FROM CST_COMPANY_LAND WITH(NOLOCK) where COM_ID = @COM_ID AND REG_NUMBER > '' )
	   BEGIN
		exec FINDDB1.Paper_New.dbo.p_SyncMemberToHouseData @CUID --벼룩시장 부동산 sync용
	   END 
		
	  END
	   -- 이력을 남기자...
	  INSERT INTO CST_JOIN_INFO (CUID, USERID, JOIN_DOMAIN, JOIN_OBJECT, SECTION_CD)
	  VALUES (@CUID, @USERID, @JOIN_DOMAIN, @JOIN_OBJECT, @Section_CD)					   
	  
	  RETURN(@COM_ID)
  END
		


GO
