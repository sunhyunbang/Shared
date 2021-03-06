USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[__DEL__ SP_MASTER_JOIN]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[__DEL__ SP_MASTER_JOIN]
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
 *************************************************************************************/
 -- 개인 정보
@USERID  varchar(50),
@PWD  VARCHAR(30),
@FLOW  varchar(100),
@ADULT_YN  char(1),
@MEMBER_CD  char(1),
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@EMAIL  varchar(50),
@GENDER  char(1),
@BIRTH  varchar(8),
@SNS_TYPE  char(1),
@SNS_ID  varchar(25),
@DI  char(64),
@CI  char(88),
-- 기업 정보
@COM_NM  varchar(50),
@CEO_NM  varchar(30),
@MAIN_PHONE  varchar(14),
@PHONE  varchar(14),
@FAX  varchar(14),
@HOMEPAGE  varchar(100),
@REGISTER_NO  varchar(12),
@LAT  decimal(16, 14),
@LNG  decimal(17, 14),
@ZIP_SEQ  int,
@CITY  varchar(50),
@GU  varchar(50),
@DONG  varchar(50),
@ADDR1  varchar(100),
@ADDR2  varchar(100),
@LAW_DONGNO  char(10),
@MAN_NO  varchar(25),
@ROAD_ADDR_DETAIL  varchar(100),
--이력 정보
@SITE_CD  char(1),
@JOIN_PATH varchar(50),
@JOIN_DOMAIN varchar(50),
@JOIN_OBJECT INT ,
@CUID int = 0 output,
@COM_ID int = 0 output
AS
	SET NOCOUNT ON;
	--DECLARE @CUID INT, @ID_COUNT BIT, @COM_ID INT
	DECLARE @ID_COUNT BIT
		
		BEGIN
		

			INSERT INTO CST_MASTER ( USERID,  USER_NM, BAD_YN, JOIN_DT,   MOD_DT,    MOD_ID , PWD , MEMBER_CD, SITE_CD, REST_YN, OUT_YN)
							VALUES (@USERID, @USER_NM, 'N',   GETDATE(), GETDATE(), @USERID, DBO.FN_MD5(LOWER(@PWD)), @MEMBER_CD ,@SITE_CD ,  'N' ,   'N')

			UPDATE CST_MASTER SET ADULT_YN = @ADULT_YN, HPHONE = @HPHONE, EMAIL = @EMAIL, GENDER = @GENDER, BIRTH = @BIRTH, 
								  LAST_LOGIN_DT = GETDATE()
				   WHERE CUID = @CUID
			
			IF @SNS_TYPE IS NOT NULL
				BEGIN
				UPDATE CST_MASTER SET SNS_TYPE = @SNS_TYPE, SNS_ID = @SNS_ID
						WHERE CUID = @CUID
				END

			IF @MEMBER_CD = 2
				BEGIN
				SELECT @COM_ID = MAX(COM_ID) + 1 FROM CST_COMPANY
				UPDATE CST_MASTER SET DI = @DI, CI = @CI, MEMBER_CD = @MEMBER_CD, COM_ID = @COM_ID
						WHERE CUID = @CUID
				-- CST_COMPANY
				INSERT INTO CST_COMPANY (COM_NM, CEO_NM, MAIN_PHONE , PHONE, FAX , HOMEPAGE , REGISTER_NO ,
										LAT , LNG , ZIP_SEQ, CITY,
										GU , DONG , ADDR1 , ADDR2 , LAW_DONGNO , MAN_NO , ROAD_ADDR_DETAIL, CUID )
					             VALUES (@COM_NM, @CEO_NM, @MAIN_PHONE, @PHONE, @FAX , @HOMEPAGE , @REGISTER_NO , 
										@LAT ,@LNG, @ZIP_SEQ , @CITY ,
										@GU ,@DONG ,@ADDR1 , @ADDR2 , @LAW_DONGNO , @MAN_NO , @ROAD_ADDR_DETAIL, @CUID)
				/*왜 따로??? 2016-08-24 정헌수*/
				UPDATE CST_COMPANY SET REG_ID = @USERID , REG_DT = GETDATE() , MOD_ID = @USERID , MOD_DT = GETDATE()
									WHERE COM_ID = @COM_ID
				
				RETURN(@COM_ID)
				
				END
				-- 이력을 남기자...
				INSERT INTO CST_JOIN_INFO (CUID, USERID, JOIN_DOMAIN, JOIN_OBJECT)
								   VALUES (@CUID, @USERID, @JOIN_DOMAIN, @JOIN_OBJECT)		
								   
		END
		

GO
/****** Object:  StoredProcedure [dbo].[__DEL__20190131__PUT_MM_HP_AUTH_CODE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013-03-04
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 회원가입 및 ID 찾기 핸드폰 인증 번호 발송
 *  수   정   자 : 여운영
 *  수   정   일 : 2015-10-21
 *  설        명 : 문자발송로그 추가
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 PUT_MM_HP_AUTH_CODE_PROC '1', '이근우', '19760925', 'M', '01033931420', '', 'P', 'S101'
************************************************************************************/
CREATE   PROC [dbo].[__DEL__20190131__PUT_MM_HP_AUTH_CODE_PROC]
       @MEMBER_CD   CHAR(1)
     , @USERNAME    VARCHAR(30)
     , @JUMINNO     CHAR(8)
     , @GENDER      CHAR(1)
     , @HP          VARCHAR(14)
     , @BIZNO       CHAR(12)=NULL
     , @TYPE        CHAR(1)='R'
     , @SECTION_CD  CHAR(4)='S101'
     , @SNS_TYPE    CHAR(1)=NULL
     , @SNS_ID      VARCHAR(25)=NULL
     , @CUID		INT=NULL
AS

SET NOCOUNT ON

DECLARE @ROWCOUNT INT
DECLARE @RANDOMCHAR   CHAR(6)

DECLARE @RANDOM INT
SELECT @RANDOM=RAND()*1000000
SET @RANDOMCHAR=REPLICATE('0',6-LEN(@RANDOM))+CAST(@RANDOM AS VARCHAR)

IF @MEMBER_CD='1' AND @SNS_TYPE<>'' AND @SNS_TYPE IS NOT NULL   --SNS 회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
     WHERE MEMBER_CD='1' 
       AND USERNAME=@USERNAME
			 AND JUMINNO=@JUMINNO
			 AND GENDER=@GENDER
       AND HP=@HP
       AND SNS_TYPE=@SNS_TYPE
       AND SNS_ID=@SNS_ID
END
ELSE IF @MEMBER_CD='1'  --개인회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
     WHERE MEMBER_CD='1' 
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
	  AND ISNULL(SNS_TYPE, '') = ''
	  AND ISNULL(SNS_ID, '') = ''
END
ELSE    --기업회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
     WHERE MEMBER_CD='2' 
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
       AND BIZNO=@BIZNO
END

SELECT @ROWCOUNT=@@ROWCOUNT
IF @ROWCOUNT=0
BEGIN
    INSERT MM_HP_AUTH_CODE_TB
         ( CUID, USERNAME, JUMINNO, GENDER, HP, BIZNO, DT, IDCODE, TYPE, MEMBER_CD, SNS_TYPE, SNS_ID)
    VALUES
         ( @CUID, @USERNAME, @JUMINNO, @GENDER, @HP, @BIZNO, GETDATE(), @RANDOMCHAR, @TYPE, @MEMBER_CD, @SNS_TYPE, @SNS_ID)
END

--// 비밀번호 찾기(메일인증번호 발송시 사용)
SELECT IDCODE, DT
FROM MM_HP_AUTH_CODE_TB (NOLOCK)
WHERE USERNAME = @USERNAME
  AND JUMINNO = @JUMINNO
	AND GENDER = @GENDER
	AND HP = @HP
	AND IDCODE = @RANDOMCHAR
	AND TYPE = @TYPE
	AND MEMBER_CD = @MEMBER_CD
	AND CASE WHEN @MEMBER_CD = '2' THEN BIZNO ELSE 'BIZNO' END = CASE WHEN @MEMBER_CD = '2' THEN @BIZNO ELSE 'BIZNO' END

--불량 회원 전화번호 목록에 존재하면 SMS 발송 안됨
IF NOT EXISTS (SELECT HP FROM MM_BAD_HP_TB WHERE HP=@HP)
BEGIN
  DECLARE @MSG VARCHAR(80)
  DECLARE @TEXT VARCHAR(20)
  IF @TYPE = 'I'
    SET @TEXT = '아이디찾기'
  ELSE IF @TYPE = 'P' 
    SET @TEXT = '비밀번호찾기'  
  ELSE IF @TYPE = 'M' 
    SET @TEXT = '회원정보수정'
  ELSE
    SET @TEXT = '회원가입'

  IF @SECTION_CD='S101'
  BEGIN
	  SET @MSG='[벼룩시장] ' + @TEXT + ' 휴대폰 인증번호 ['+@RANDOMCHAR+']'
	  EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '02-3019-1590','벼룩시장',@USERNAME ,@HP ,@MSG ,'FINDALL'
	  
	   --SMS로깅 (2015.10.19)
	   EXECUTE FINDDB1.MWDB.DBO.PUT_MMSDATA_STAT_LOG_PROC '00','s','','',16,0,'',@MSG
  END
  IF @SECTION_CD='H001'
  BEGIN
	  SET @MSG='[부동산써브] ' + @TEXT + ' 휴대폰 인증번호 ['+@RANDOMCHAR+']'
	  EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '080-269-0011','써브',@USERNAME ,@HP ,@MSG ,'SERVE'
  END
  IF @SECTION_CD='S116'
  BEGIN
	  SET @MSG='[야알바] ' + @TEXT + ' 휴대폰 인증번호 ['+@RANDOMCHAR+']'
	  EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '080-269-0011','야알바',@USERNAME ,@HP ,@MSG ,'FINDALL'
  END

  IF @SECTION_CD='S117'
  BEGIN
	  SET @MSG='[테니스코리아] ' + @TEXT + ' 휴대폰 인증번호 ['+@RANDOMCHAR+']'
	  EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-1433','테니스코리아',@USERNAME ,@HP ,@MSG ,'M&B'
  END

  IF @SECTION_CD='S118'
  BEGIN
	  SET @MSG='[포포투] ' + @TEXT + ' 휴대폰 인증번호 ['+@RANDOMCHAR+']'
	  EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-6924','포포투',@USERNAME ,@HP ,@MSG ,'M&B'
  END
END
GO
/****** Object:  StoredProcedure [dbo].[__DEL__20190131_GET_MM_MEMBER_FINDID_SENDSMS_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디찾기>선택한 회원 핸드폰 SMS 보내기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 뒷자리 확인하기 SMS
 *  주 의  사 항 :
 *  사 용  소 스 :
 *************************************************************************************/
CREATE  PROC [dbo].[__DEL__20190131_GET_MM_MEMBER_FINDID_SENDSMS_PROC]
  @CUID     INT
  ,@SECTION_CD CHAR(4)
AS

  SET NOCOUNT ON

  DECLARE @SMSMSG   NVARCHAR(4000)  = ''
  DECLARE @HP       VARCHAR(14)     = ''
  DECLARE @USERNAME VARCHAR(30)     = ''
  DECLARE @USERID   VARCHAR(50)     = ''

  SELECT @USERNAME=USER_NM
        ,@HP = CASE WHEN LEFT(HPHONE,3) IN ('010','011','016','017','018','019') THEN HPHONE
         END
        ,@USERID = USERID
    FROM CST_MASTER WITH (NOLOCK)
   WHERE CUID = @CUID

  IF @SECTION_CD='S101'
    BEGIN
      SET @SMSMSG='[벼룩시장] 요청하신 아이디는 '+ @USERID +'입니다.'
      EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '02-3019-1590','벼룩시장',@USERNAME ,@HP ,@SMSMSG ,'FINDALL'
    END

  IF @SECTION_CD='S112'
    BEGIN
      SET @SMSMSG='[M25] 요청하신 아이디는 '+@USERID+'입니다.'
      EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-1448','M25',@USERNAME ,@HP ,@SMSMSG ,'M&B'
    END

  IF @SECTION_CD='S116'
    BEGIN
	    SET @SMSMSG='[야알바] 요청하신 아이디는 '+@USERID+'입니다.'
	    EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '080-269-0011','야알바',@USERNAME ,@HP ,@SMSMSG ,'FINDALL'
    END

  IF @SECTION_CD='S117'
    BEGIN
	    SET @SMSMSG='[테니스코리아] 요청하신 아이디는 '+@USERID+'입니다.'
	    EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-1433','테니스코리아',@USERNAME ,@HP ,@SMSMSG ,'M&B'
    END

  IF @SECTION_CD='S118'
    BEGIN
	    SET @SMSMSG='[포포투] 요청하신 아이디는 '+@USERID+'입니다.'
	    EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-6924','포포투',@USERNAME ,@HP ,@SMSMSG ,'M&B'
    END

  IF @SECTION_CD='S119'
    BEGIN
	    SET @SMSMSG='[톱기어] 요청하신 아이디는 '+@USERID+'입니다.'
	    EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-1438','톱기어',@USERNAME ,@HP ,@SMSMSG ,'M&B'
    END

  IF @SECTION_CD='H001'
    BEGIN
	    SET @SMSMSG='[부동산써브] 요청하신 아이디는 '+@USERID+'입니다.'
	    EXEC FINDDB7.COMDB1.DBO.PUT_SENDSMS_PROC '070-7123-1438','부동산써브',@USERNAME ,@HP ,@SMSMSG ,'SERVE'
    END
GO
/****** Object:  StoredProcedure [dbo].[__DEL__GET_AD_MM_MEMBER_SEARCH_PROC_BK_ORG_20180730]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > Ajax 회원리스트
 *  작   성   자 :
 *  작   성   일 :
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
exec DBO.GET_AD_MM_MEMBER_SEARCH_PROC 1,10,'C.REGISTER_NO','2208528967'
*************************************************************************************/
CREATE PROCEDURE [dbo].[__DEL__GET_AD_MM_MEMBER_SEARCH_PROC_BK_ORG_20180730]
	 @PAGE			INT		-- 페이지
	,@PAGESIZE		INT		-- 페이지사이즈
	,@KEY_CLS		VARCHAR(30)	-- 검색키	[아이디:M.USERID, 이름:M.USER_NM, 사업자번호:C.REGISTER_NO, 핸드폰:M.HPHONE , 이메일:M.EMAIL]
	,@KEYWORD		VARCHAR(50)	-- 검색어

AS
  SET NOCOUNT ON
  
	DECLARE	@SQL	NVARCHAR(4000)
	DECLARE @WHERE	NVARCHAR(1000)

	SET @SQL = ''
	SET @WHERE = ''

----------------------------------------
-- 검색
----------------------------------------
	-- 검색어
	IF @KEY_CLS <> '' AND @KEYWORD <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' LIKE ''' + @KEYWORD + '%'' '
		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' <> '''' '
	END


----------------------------------------
-- 리스트
----------------------------------------
	SET @SQL =	'SELECT COUNT(M.USERID) AS CNT '+
				'  FROM	DBO.CST_MASTER M WITH (NOLOCK)'+
				'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
				'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
				' WHERE 1=1 ' + @WHERE + ';' +

				'SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) +
				' M.CUID'+
				',M.USERID'+
				',ISNULL(M.USER_NM,'''')+''/''+ISNULL(C.COM_NM,'''') AS NAME'+
				',ISNULL(M.HPHONE,'''') AS HPHONE'+
				',ISNULL(C.REGISTER_NO,'''') AS NUMBER'+
				',M.JOIN_DT'+
				',B.SECTION_CD'+
				',M.MEMBER_CD'+
				',M.OUT_YN'+
				',M.REST_YN'+
				',ISNULL(M.SNS_TYPE,'''') AS SNS_TYPE'+
				',ISNULL(C.MEMBER_TYPE,'''') AS COMPANY_TYPE'+
				',ISNULL(M.STATUS_CD,'''') AS STATUS_CD'+
				',ISNULL(M.MASTER_ID,'''') AS MASTER_ID'+
				',M.BAD_YN'+
			'  FROM	DBO.CST_MASTER M WITH (NOLOCK) '+
			'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
			'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
			' WHERE 1=1 ' + @WHERE +
			'ORDER BY M.JOIN_DT DESC';
--print @sql
EXECUTE SP_EXECUTESQL @Sql
GO
/****** Object:  StoredProcedure [dbo].[__DEL__GET_MM_MEMBER_FINDID_LIST_PROC_BK_ORG_20180730]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디 찾기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 찾기(동일한 정보의 ID 목록 가져오기)
 *  주 의  사 항 :
 *  사 용  소 스 : EXEC DBO.GET_MM_MEMBER_FINDID_LIST_PROC 'H','1','성소영','','','206-85-26551','01022170355'
 *************************************************************************************/

CREATE   PROC [dbo].[__DEL__GET_MM_MEMBER_FINDID_LIST_PROC_BK_ORG_20180730]
  @SEARCHTYPE  CHAR(1)     --H:휴대폰 E:Email
  ,@MEMBER_CD   CHAR(1)
  ,@USERNAME    VARCHAR(30)
  ,@JUMINNO     CHAR(8)  = ''
  ,@GENDER      CHAR(1)  = ''
  ,@BIZNO       CHAR(12) = ''
  ,@SEARCHVAL   VARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)
SET @SQL=''

IF @MEMBER_CD='1'  --개인회원
BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',USERID) > 0 THEN SUBSTRING(USERID, 1, PATINDEX(''%@%'',USERID)-3)+''***''+SUBSTRING(USERID, PATINDEX(''%@%'',USERID), LEN(USERID)-PATINDEX(''%@%'',USERID)+1) ELSE SUBSTRING(USERID, 1 , LEN(USERID)-3)+''***'' END AS USERID_HINT
         , REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),''/'',''.'') AS JOIN_DT
         , CUID	
      FROM CST_MASTER WITH (NOLOCK)
     WHERE MEMBER_CD=''1''
       AND USER_NM='''+@USERNAME+'''
       AND BIRTH='''+@JUMINNO+'''
       AND OUT_YN=''N''
       AND GENDER='''+@GENDER+''''

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(HPHONE,''-'','''')='''+@SEARCHVAL+''' )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND EMAIL='''+@SEARCHVAL+''' '
    END

		SET @SQL=@SQL+' ORDER BY JOIN_DT DESC '
END
ELSE    --기업회원
BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',T.USERID) > 0 THEN SUBSTRING(T.USERID, 1, PATINDEX(''%@%'',T.USERID)-3)+''***''+SUBSTRING(T.USERID, PATINDEX(''%@%'',T.USERID), LEN(T.USERID)-PATINDEX(''%@%'',T.USERID)+1) ELSE SUBSTRING(T.USERID, 1 , LEN(T.USERID)-3)+''***'' END AS USERID_HINT
         , REPLACE(CONVERT(VARCHAR(10), T.JOIN_DT, 111),''/'',''.'') AS JOIN_DT
         , T.CUID   
      FROM ( 
						SELECT M.USERID, M.JOIN_DT, M.CUID 
							FROM CST_MASTER AS M WITH (NOLOCK)
							JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID = M.COM_ID
						 WHERE M.MEMBER_CD=''2''
							 AND M.USER_NM='''+@USERNAME+'''
							 AND M.OUT_YN=''N''
							 AND C.REGISTER_NO='''+@BIZNO+''' '

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(M.HPHONE,''-'','''')='''+@SEARCHVAL+''' )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND M.EMAIL='''+@SEARCHVAL+''''
    END

		SET @SQL=@SQL+'
						GROUP BY M.USERID, M.JOIN_DT, M.CUID 
		) AS T
		ORDER BY JOIN_DT DESC '
END

--PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[__DEL__GET_MM_MEMBER_FINDPW_INFO_PROC_BK_ORG_20180730]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 찾기>선택한 회원의 정보 노출
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 찾기(회원정보로 찾기)
 *  주 의  사 항 :
 *  사 용  소 스 : 
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'H', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', '01033931420'
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'E', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', 'stari@mediawill.com'

 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'H', '1', 'cowto7602', '이근우', '19760925', '206-85-26551', '01033931420'
 *************************************************************************************/
CREATE PROC [dbo].[__DEL__GET_MM_MEMBER_FINDPW_INFO_PROC_BK_ORG_20180730]
  @SEARCHTYPE  CHAR(1)     --H:휴대폰 E:Email
, @MEMBER_CD   CHAR(1)
, @USERID      VARCHAR(50)
, @USERNAME    VARCHAR(30)
, @JUMINNO     CHAR(8)=''
, @BIZNO       CHAR(12)=''
, @SEARCHVAL   VARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)

SET @SQL=''

IF @MEMBER_CD='1'  --개인회원
BEGIN
    SET @SQL='
    SELECT CASE
                WHEN LEFT(HPHONE,3) IN (''010'',''011'',''016'',''017'',''018'',''019'') THEN SUBSTRING(HPHONE, 1 , LEN(HPHONE)-4)+''****''
                ELSE ''''
           END AS HPHONE
         , CASE WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-1))> 3 THEN SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-4)+''***''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           ELSE SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-3)+''**''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           END AS EMAIL
				 , HPHONE AS HPHONE1
				 , EMAIL AS EMAIL1
         , CUID
      FROM CST_MASTER WITH (NOLOCK)
     WHERE MEMBER_CD=''1''
       AND USER_NM='''+@USERNAME+'''
       AND USERID='''+@USERID+'''
       AND OUT_YN=''N''
       AND BIRTH='''+@JUMINNO+''''

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(HPHONE,''-'','''')='''+@SEARCHVAL+''' )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND EMAIL='''+@SEARCHVAL+''' '
    END
END
ELSE    --기업회원
BEGIN
    SET @SQL='
    SELECT CASE
                WHEN LEFT(M.HPHONE,3) IN (''010'',''011'',''016'',''017'',''018'',''019'') THEN SUBSTRING(M.HPHONE, 1 , LEN(M.HPHONE)-4)+''****''
                ELSE ''''
           END AS HPHONE
         , CASE WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-1))> 3 THEN SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-4)+''***''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           ELSE SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-3)+''**''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           END AS EMAIL
				 , HPHONE AS HPHONE1
				 , EMAIL AS EMAIL1
         , M.CUID
      FROM CST_MASTER AS M WITH (NOLOCK)
      JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID=M.COM_ID
     WHERE M.MEMBER_CD=''2''
       --AND M.USER_NM='''+@USERNAME+'''
       AND M.USERID='''+@USERID+'''
       AND M.OUT_YN=''N''
       AND C.REGISTER_NO='''+@BIZNO+''' '

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(M.HPHONE,''-'','''')='''+@SEARCHVAL+''' )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND M.EMAIL='''+@SEARCHVAL+''''
    END
END

--PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[__DEL__SP_LOGIN_20160812]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[__DEL__SP_LOGIN_20160812]
/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * EXEC SP_LOGIN 'ju990728' , '03294fe0baa3519b3f389015802b6067'   -- ID , PWD
 * CUID ,USERID, USER_NM, 이메일, 회사명, 휴대폰, 회원타입(개인/기업), 성별, 연령, 휴면여부, 생년월일, 비번 변경일로부터 90일 지난여부(Y/N)
 *************************************************************************************/
@USERID varchar(50) 
,@PWD VARCHAR(30)
,@SECTION_CD CHAR(4)
AS
	SET NOCOUNT ON;
	DECLARE  @SELECT_PASSWORD VARCHAR(255) 
	,@ID_COUNT bit
	,@LOGIN_FAIL_CNT INT
	,@TRUE CHAR(1)
	,@CUID INT
	,@MD5PWD VARCHAR(100)
	,@REST_YN CHAR(1)
	,@SEQ INT
	,@SITE_CD CHAR(1)
	,@_login_pwd INT
	,@LOGIN_S INT  -- 로그인 성공 값 0 실패 1은 성공
	,@SUCCESS_YN CHAR(1)
	,@PWD_CHANGE_YN CHAR(1)
	,@PWD_NEXT_ALARM_DT DATETIME
	
	SELECT @REST_YN =  REST_YN FROM CST_MASTER WHERE USERID = @USERID
	IF @REST_YN = 'Y'
	BEGIN 
		RETURN(100)     -- 휴면 고객 확인
	END
	ELSE  
	BEGIN
		SET @ID_COUNT = 0
		SELECT @ID_COUNT = COUNT(USERID) FROM CST_MASTER WHERE USERID = @USERID AND OUT_YN='N' AND REST_YN = 'N'
	
		IF @ID_COUNT = 1
		BEGIN
			SET @MD5PWD = DBO.FN_MD5(LOWER(@PWD))
			SELECT @SELECT_PASSWORD = PWD FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @USERID 
			SELECT @_login_pwd = PwdCompare(@PWD, login_pwd_enc) FROM CST_MASTER WHERE USERID = @USERID 
			IF @SELECT_PASSWORD = @MD5PWD SET @LOGIN_S = 1 ELSE IF @_login_pwd = 1 SET @LOGIN_S = 1 ELSE SET @LOGIN_S = 0
			
			IF  @LOGIN_S = 1
			BEGIN
			SELECT @TRUE = 'T'
			SELECT @PWD_NEXT_ALARM_DT = PWD_NEXT_ALARM_DT  FROM CST_MASTER WHERE USERID = @USERID 
				IF @PWD_NEXT_ALARM_DT > getdate()
				BEGIN
					SELECT @PWD_CHANGE_YN = 'N'
				END ELSE IF @PWD_NEXT_ALARM_DT <= getdate()
				BEGIN
					SELECT @PWD_CHANGE_YN = 'Y'
				END
			SELECT M.CUID, M.USERID, M.USER_NM , M.EMAIL, M.HPHONE , M.MEMBER_CD, M.GENDER, 
			M.REST_YN, M.BIRTH, C.COM_NM, M.CONFIRM_YN, M.MASTER_ID, M.STATUS_CD , @TRUE AS TRUE_YN, @PWD_CHANGE_YN AS PWD_CHANGE_YN
			FROM CST_MASTER M LEFT OUTER JOIN CST_COMPANY C ON M.COM_ID = C.COM_ID
			WHERE M.USERID = @USERID AND M.OUT_YN='N'

				IF @TRUE = 'T'
				BEGIN
				SELECT @CUID = CUID FROM CST_MASTER WHERE USERID = @USERID
				SELECT @SEQ = MAX(SEQ) + 1 FROM CST_LOGIN_LOG
					IF @SEQ IS NULL
					BEGIN
						SELECT @SEQ = 1
					END
					SELECT @SITE_CD = SITE_CD FROM CST_MASTER WHERE USERID = @USERID
				BEGIN
					UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()  WHERE USERID = @USERID AND CUID = @CUID  -- 마지막 로그인 시간 
					INSERT INTO CST_LOGIN_LOG (CUID, SEQ, USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN) 
										VALUES (@CUID ,@SEQ,@USERID,getdate(),@SECTION_CD,'Y')    -- 로그인 이력 남기기
				END 
			END
		END
		ELSE
			BEGIN
			SELECT 'PWD FAIL' AS MESSAGE
			SELECT @CUID = CUID FROM CST_MASTER WHERE USERID = @USERID
			SELECT @SEQ = MAX(SEQ) + 1 FROM CST_LOGIN_LOG
		 		IF @SEQ IS NULL
				BEGIN
					SELECT @SEQ = 1
				END
			SELECT @SITE_CD = SITE_CD FROM CST_MASTER WHERE USERID = @USERID
			SELECT @SUCCESS_YN = 'N'
			INSERT INTO CST_LOGIN_LOG (CUID, SEQ, USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN) VALUES
									   (@CUID ,@SEQ,@USERID,getdate(),@SECTION_CD,@SUCCESS_YN)
		 
			SELECT @LOGIN_FAIL_CNT = LOGIN_FAIL_CNT FROM CST_MASTER WHERE USERID = @USERID
				IF @LOGIN_FAIL_CNT IS NULL
				SET @LOGIN_FAIL_CNT = 0
				IF @LOGIN_FAIL_CNT >= 0
				BEGIN
					UPDATE CST_MASTER SET LOGIN_FAIL_CNT = LOGIN_FAIL_CNT + 1, LOGIN_FAIL_DT = getdate() WHERE USERID = @USERID
				END
				 /* ELSE IF @LOGIN_FAIL_CNT >= 5
					BEGIN     -- 5번 일때 어떤 액션으로 풀어 줄것인가에 대해서 룰 적용 필요
					UPDATE CST_MASTER SET LOGIN_FAIL_CNT = 1  , LOGIN_FAIL_DT = getdate() WHERE USERID = @USERID
				END 
				*/
			END
		END
		ELSE
			BEGIN 
			SELECT 'ID AND PWD FAIL'  AS MESSAGE
		END
	END
GO
/****** Object:  StoredProcedure [dbo].[__DEL__SP_LOGIN_BK20160816]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[__DEL__SP_LOGIN_BK20160816]
/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
 * DECLARE @RET INT
 * EXEC @RET=SP_CON 'nadu81@naver.com' , 'A' , '','IP','HOST'
 * SELECT @RET  -- 성공
 *************************************************************************************/
@USERID varchar(50) 
,@PWD VARCHAR(30)
,@SECTION_CD CHAR(4)
,@IP VARCHAR(14)
,@HOST VARCHAR(50)
AS
	SET NOCOUNT ON;
	DECLARE  
		@CUID INT
		,@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@MASTER_ID INT
		,@STATUS_CD CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		


		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = AA.USER_NM,
			@EMAIL = AA.EMAIL,
			@HPHONE = AA.HPHONE,
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = AA.COM_NM,
			@CONFIRM_YN = AA.CONFIRM_YN,
			@MASTER_ID = AA.MASTER_ID,
			@STATUS_CD = AA.STATUS_CD,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
		WHERE M.OUT_YN='N'
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/
		AND M.USERID = @USERID 
			AND (PWD = DBO.FN_MD5(LOWER(@PWD)) OR PwdCompare(@PWD, login_pwd_enc) = 1)
		) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
			
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음

		/* 2순위 계정 체크 시작 {계정 변환 로직으로 ~!!! 300 }*/
		EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC @CUID
		
		IF @DUPLICATE_YN = 1
		BEGIN
			SET @COUNT = 2
		END
		/* 2순위 계정 체크  끝*/
		
	
		IF @REST_YN = 'Y' 
		BEGIN
			RETURN(500) -- 휴면 고객
		END ELSE IF @CUID IS NULL
		BEGIN
			RETURN(400) -- 사용자가 없음
		END ELSE IF @COUNT > 1 
		BEGIN 
			RETURN(300) -- 복수의 아이디
		END ELSE IF @TRUE_YN = 'N'
		BEGIN
			INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									  (@CUID ,@USERID, getdate(), @SECTION_CD,'N', @IP, @HOST)
			RETURN(200) -- 비밀 번호 틀림
		END ELSE IF @COUNT = 1
		BEGIN 
			SET @PWD_CHANGE_YN = 'N'
			IF @PWD_NEXT_ALARM_DT < GETDATE() SET @PWD_CHANGE_YN = 'Y'
			SELECT
				-- @COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				@GENDER AS GENDER,
				@REST_YN AS REST_YN,
				@BIRTH AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				@MASTER_ID AS MASTER_ID,
				@STATUS_CD AS STATUS_CD,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN

				UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()  WHERE CUID = @CUID			  -- 마지막 로그인 시간 
				INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									  (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기
			RETURN(0) -- 정상 정상
		END	

GO
/****** Object:  StoredProcedure [dbo].[__DEL__SP_REST_MASTER_BK20160820]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[__DEL__SP_REST_MASTER_BK20160820]
/*************************************************************************************
 *  단위 업무 명 : 회원 휴먼 상태 만들기
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0)  -- 정상
 * RETURN(500)  -- 갯수가 없을 경우
 * DECLARE @RET INT
 * EXEC @RET=SP_REST_MASTER
 * SELECT @RET
 
 select * FROM CST_REST_MASTER where userid ='kkam1234'
 delete CST_REST_MASTER where userid ='kkam1234'
		
	INSERT CST_REST_MASTER (CUID ,USERID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI, ADD_DT)  
			select 	   C.CUID, C.USERID, C.USER_NM, C.HPHONE, C.EMAIL, C.BIRTH, C.DI, C.CI, GETDATE()  FROM CST_MASTER C
			where USERID ='kkam1234' and CUID = 11682400
			
 *************************************************************************************/
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT, @LAST_LOGIN_DT DATETIME
		
		SELECT @ID_COUNT = COUNT(LAST_LOGIN_DT) 
		FROM CST_MASTER WITH(NOLOCK)
		WHERE LAST_LOGIN_DT <= GETDATE() - 365 
				AND REST_YN='N' 
				AND OUT_YN='N' 

		IF @ID_COUNT > 0
		BEGIN
			/*
				INSERT INTO CST_REST_MASTER (CUID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI,   ADD_DT )
									  SELECT CUID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI,   GETDATE() FROM 
											 CST_MASTER WITH(NOLOCK) WHERE LAST_LOGIN_DT <= GETDATE() - 365 
											 AND REST_YN = 'N' -- 마지막 접속 시간을 계산

			*/
			
			MERGE  CST_REST_MASTER AS M USING 
				(SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE REST_YN='N' AND OUT_YN = 'N' AND LAST_LOGIN_DT <= GETDATE() - 365 ) AS C
			ON M.CUID = C.CUID
			WHEN MATCHED THEN 
				UPDATE SET M.USER_NM = C.USER_NM , M.HPHONE = C.HPHONE , EMAIL = C.EMAIL, 
						   M.BIRTH = C.BIRTH, DI = C.DI, CI = C.CI, ADD_DT = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (CUID ,USERID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI, ADD_DT) VALUES 
					   (C.CUID, C.USERID, C.USER_NM, C.HPHONE, C.EMAIL, C.BIRTH, C.DI, C.CI, GETDATE() ) ;
			
			UPDATE CST_MASTER SET USER_NM = '', HPHONE = '', EMAIL = '',
							BIRTH =  REPLACE(REPLACE(SUBSTRING(BIRTH,1,4),'-',''),' ',''), DI = '' ,CI = '', REST_YN = 'Y' , REST_DT = GETDATE()
							WHERE LAST_LOGIN_DT <= GETDATE() - 365  -- 사용자 정보 업데이트
			RETURN(0)
		END
		ELSE	
		BEGIN
			RETURN(500)
		END
		
		
GO
/****** Object:  StoredProcedure [dbo].[_BAT_MM_MEMBER_STAT_PROC_20210712]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원통계 > 일별누적(신규,탈퇴,누적)
 *  작   성   자 : 여운영
 *  작   성   일 : 2015/09/18
 *  수   정   자 : 배진용
 *  수   정   일 : 2021-01-04(회원가입대행 추가)
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC BAT_MM_MEMBER_STAT_PROC
 SELECT * FROM [MEMBER].[dbo].[MM_STAT_MEMBER_TB]

 BAT_MM_MEMBER_STAT_PROC '2020-06-27'
 *************************************************************************************/
create PROC [dbo].[_BAT_MM_MEMBER_STAT_PROC_20210712]

  @PRE_DT DATETIME = NULL

AS 
  
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


	--DECLARE @PRE_DT DATETIME	/* 전날 일자 */
  IF @PRE_DT IS NULL
	  SET @PRE_DT = CONVERT(CHAR(10),DATEADD(D,-1,GETDATE()),120)

/* #### 탈퇴 대상 #### */
	SELECT CUID
	  INTO #TEMP_OUT_CUID
	  FROM MWMEMBER.DBO.CST_OUT_MASTER WITH(NOLOCK)
	 WHERE OUT_APPLY_DT > @PRE_DT --AND OUT_PROC_DT IS NULL
	 

/* #### 탈퇴회원의 개인/기업 구분 #### */
	SELECT A.CUID,A.MEMBER_CD INTO #TEMP_OUT_CUID_TG2
	FROM	(

		SELECT CUID, MEMBER_CD FROM MWMEMBER.DBO.CST_MASTER  WHERE CUID IN (SELECT CUID FROM #TEMP_OUT_CUID)
--		UNION
--		SELECT CUID, MEMBER_CD FROM MWMEMBER.DBO.CST_REST_MASTER WHERE CUID IN (SELECT CUID FROM #TEMP_OUT_CUID)

	) AS A
	JOIN #TEMP_OUT_CUID B ON A.CUID = B.CUID

	--SELECT * FROM #TEMP_OUT_CUID_TG2

/* #### 신규가입 #### */
	-- 2021-01-04 회원가입대행 AGENCY_YN 컬럼 추가
	SELECT * INTO #NEW_JOIN 
	FROM (
		SELECT DISTINCT CONVERT(VARCHAR(10), JOIN_DT, 120) AS DT, MEMBER_CD, COUNT(MEMBER_CD) '신규가입', ISNULL(AGENCY_YN,'N') as AGENCY_YN
		  FROM	MWMEMBER.DBO.CST_MASTER AS A WITH(NOLOCK)		
				--LEFT JOIN MM_JOIN_INFO_TB AS B ON A.CUID=B.CUID 
		 WHERE --(SECTION_CD<>'S111' AND SECTION_CD<>'S112' AND SECTION_CD<>'S117' AND SECTION_CD<>'S118') AND
		    OUT_YN='N' 
		   AND (JOIN_DT>=CONVERT(VARCHAR(10), GETDATE()-1, 120)
		   AND JOIN_DT<CONVERT(VARCHAR(10), GETDATE(), 120))
		GROUP BY CONVERT(VARCHAR(10), JOIN_DT, 120), MEMBER_CD,ISNULL(AGENCY_YN,'N')
		--ORDER BY CONVERT(VARCHAR(10), JOIN_DT, 120)

	) Y

/*
	SELECT DISTINCT CONVERT(VARCHAR(10), JOIN_DT, 120) AS DT, MEMBER_CD, COUNT(MEMBER_CD) '신규가입' INTO #NEW_JOIN
	  FROM	DBO.MM_MEMBER_TB AS A WITH(NOLOCK)		
			LEFT JOIN MM_JOIN_INFO_TB AS B ON A.CUID=B.CUID 
	 WHERE (SECTION_CD<>'S111' AND SECTION_CD<>'S112' AND SECTION_CD<>'S117' AND SECTION_CD<>'S118') 
	   AND OUT_APPLY_YN='N' 
	   AND (JOIN_DT>=CONVERT(VARCHAR(10), GETDATE()-1, 120)
	   AND JOIN_DT<CONVERT(VARCHAR(10), GETDATE(), 120))
	GROUP BY CONVERT(VARCHAR(10), JOIN_DT, 120), MEMBER_CD
	ORDER BY CONVERT(VARCHAR(10), JOIN_DT, 120)
*/

/* #### 탈퇴 #### */
	SELECT CONVERT(VARCHAR(10),GETDATE()-1, 120) AS DT, B.MEMBER_CD, COUNT(*) AS '탈퇴' INTO #OUT
	FROM #TEMP_OUT_CUID_TG2 B
	GROUP BY B.MEMBER_CD


/* #### 회원누적(휴면제외) #### */
	-- 2021-01-04 회원가입대행 AGENCY_YN 컬럼 추가
	SELECT * INTO #TOTAL_MEM 
	FROM (
		SELECT CONVERT(VARCHAR(10), GETDATE()-1, 120) AS DT, MEMBER_CD, count(*) AS '전체회원수', ISNULL(AGENCY_YN,'N') as AGENCY_YN
		FROM	DBO.CST_MASTER  AS A WITH(NOLOCK)		
		where  OUT_YN='N' 
		AND REST_YN='N'
		and JOIN_DT< CONVERT(VARCHAR(10), GETDATE()-1, 120)
		GROUP BY MEMBER_CD, ISNULL(AGENCY_YN,'N')

/*
		UNION ALL	

		SELECT X.DT,
		CASE X.SECTION_CD WHEN 'S102' THEN '8' WHEN 'S103' THEN '9' ELSE '0' END AS MEMBER_CD
		,X.[전체회원수] FROM (
			SELECT DISTINCT C.SECTION_CD, CONVERT(VARCHAR(10), GETDATE()-1, 120) AS DT, COUNT(C.SECTION_CD) '전체회원수' 	
			FROM	DBO.MM_MEMBER_TB AS A WITH(NOLOCK)		
					LEFT JOIN MM_JOIN_INFO_TB AS B ON A.CUID=B.CUID 
					LEFT JOIN MM_COMPANY_TB AS C ON A.CUID=C.CUID
			where (B.SECTION_CD<>'S111' and B.SECTION_CD<>'S112' and B.SECTION_CD<>'S117' and B.SECTION_CD<>'S118') 
			and A.OUT_APPLY_YN='N' 
			AND A.REST_YN='N'
			and A.JOIN_DT< CONVERT(VARCHAR(10), GETDATE()-1, 120)
			AND C.SECTION_CD IN ('S102','S103')
			GROUP BY C.SECTION_CD
		) X
		
*/
	) Y
/*
	SELECT CONVERT(VARCHAR(10), GETDATE()-1, 120) AS DT, MEMBER_CD, count(*) AS '전체회원수' INTO #TOTAL_MEM
	FROM	DBO.MM_MEMBER_TB AS A WITH(NOLOCK)		
			LEFT JOIN MM_JOIN_INFO_TB AS B ON A.CUID=B.CUID 
	where (SECTION_CD<>'S111' and SECTION_CD<>'S112' and SECTION_CD<>'S117' and SECTION_CD<>'S118') 
	and OUT_APPLY_YN='N' 
	AND REST_YN='N'
	and JOIN_DT< CONVERT(VARCHAR(10), GETDATE()-1, 120)
	GROUP BY MEMBER_CD
*/

/* #### 통계테이블 추가 #### */
	DELETE FROM MM_STAT_MEMBER_TB WHERE REG_DT=(CONVERT([varchar](10),dateadd(day,(-1),getdate()),(120)))
	-- 2021-01-04 회원가입대행 컬럼 추가 및 SELECT 조건추가 'AGENCY_YN'
	INSERT INTO [MM_STAT_MEMBER_TB](
		 REG_DT
		,NEW_JOIN_COMPANY
		,NEW_AGENCY_JOIN_COMPANY	-- 회원가입대행 추가
		,NEW_JOIN_PERSON
		,OUT_COMPANY
		,OUT_PERSON
		,TOTAL_MEM_COMPANY
		,TOTAL_AGENCY_JOIN_COMPANY	-- 회원가입대행 추가
		,TOTAL_MEM_PERSON
		)
	SELECT CONVERT(VARCHAR(10), GETDATE()-1, 120)
	, isNULL((SELECT [신규가입] FROM #NEW_JOIN WHERE MEMBER_CD=2 AND AGENCY_YN = 'N'),0) -- 회원가입대행 조건 수정
	, isNULL((SELECT [신규가입] FROM #NEW_JOIN WHERE MEMBER_CD=2 AND AGENCY_YN = 'Y'),0) -- 회원가입대행 추가
	,isNULL((SELECT [신규가입] FROM #NEW_JOIN WHERE MEMBER_CD=1),0)
	,isNULL((SELECT [탈퇴] FROM #OUT WHERE MEMBER_CD=2),0)
	,isNULL((SELECT [탈퇴] FROM #OUT WHERE MEMBER_CD=1),0)
	,isNULL((SELECT [전체회원수] FROM #TOTAL_MEM WHERE MEMBER_CD=2 AND AGENCY_YN = 'N'),0)	-- 회원가입대행 조건 수정
	, isNULL((SELECT [전체회원수] FROM #TOTAL_MEM WHERE MEMBER_CD=2 AND AGENCY_YN = 'Y'),0) -- 회원가입대행 추가
	,isNULL((SELECT [전체회원수] FROM #TOTAL_MEM WHERE MEMBER_CD=1 ),0)

	
	--,isNULL((SELECT [신규가입] FROM #NEW_JOIN WHERE MEMBER_CD=8),0),isNULL((SELECT [신규가입] FROM #NEW_JOIN WHERE MEMBER_CD=9),0)
	--,isNULL((SELECT [전체회원수] FROM #TOTAL_MEM WHERE MEMBER_CD=8),0),isNULL((SELECT [전체회원수] FROM #TOTAL_MEM WHERE MEMBER_CD=9),0)
	
	EXEC FINDDB1.[STATS].DBO.BAT_DASHBOARD_DATA_MEMBER_STAT_INS_PROC @PRE_DT

/* #### 임시테이블 삭제 #### */
	DROP TABLE #TEMP_OUT_CUID
	DROP TABLE #TEMP_OUT_CUID_TG2
	
	DROP TABLE #NEW_JOIN
	DROP TABLE #OUT
	DROP TABLE #TOTAL_MEM

END
GO
/****** Object:  StoredProcedure [dbo].[_BAT_OUT_MEMBER_ONEMONTH_AGO_LMS_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 탈퇴 30일전 
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016/09/30
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_OUT_MEMBER_ONEMONTH_AGO_LMS_PROC
 *************************************************************************************/
CREATE PROC [dbo].[_BAT_OUT_MEMBER_ONEMONTH_AGO_LMS_PROC]

AS

SET NOCOUNT ON

DECLARE @LMS_MSG VARCHAR(4000)
DECLARE @LMS_TITLE VARCHAR(160)
DECLARE @KKO_MSG VARCHAR(4000)
DECLARE @URL_BUTTON_TXT VARCHAR(160)
DECLARE @URL VARCHAR(1000)

DECLARE @CALLBACK  VARCHAR(14)
SET @CALLBACK='0802690011'

SELECT @LMS_MSG = LMS_MSG, @LMS_TITLE = LMS_TITLE, @KKO_MSG= KKO_MSG, @URL_BUTTON_TXT = URL_BUTTON_TXT, @URL = URL FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWsms05'')') 

INSERT FINDDB1.COMDB1.DBO.MMS_MSG
      (REQDATE, STATUS, TYPE, PHONE, CALLBACK, SUBJECT, MSG, FILE_CNT, ETC1)
SELECT 
       GETDATE()
      ,'1'
      ,'0'
      ,REPLACE(ISNULL(A.HPHONE,''),'-','')
      ,@CALLBACK
      ,@LMS_TITLE
      ,REPLACE(REPLACE(REPLACE(@LMS_MSG,'#{ID}',B.USERID) , '#{한달후/3일후}','한달후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10), DATEADD(YEAR, 2, ISNULL(B.LAST_LOGIN_DT, B.JOIN_DT)) , 111), '/', '-'))
      ,'1'
      ,'FINDALL'
  FROM CST_REST_MASTER AS A WITH (NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE B.OUT_YN='N'
   AND B.REST_YN='Y'
   AND DATEADD(YEAR, 2, CONVERT(VARCHAR(10), ISNULL(LAST_LOGIN_DT,JOIN_DT), 111)) = DATEADD(MONTH, 1, CONVERT(VARCHAR(10), GETDATE(), 111))
GO
/****** Object:  StoredProcedure [dbo].[_BAT_OUT_MEMBER_THREEDAY_AGO_LMS_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 탈퇴 3일전 
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016/09/30
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_OUT_MEMBER_THREEDAY_AGO_LMS_PROC
 *************************************************************************************/
CREATE PROC [dbo].[_BAT_OUT_MEMBER_THREEDAY_AGO_LMS_PROC]

AS

SET NOCOUNT ON

DECLARE @LMS_MSG VARCHAR(4000)
DECLARE @LMS_TITLE VARCHAR(160)
DECLARE @KKO_MSG VARCHAR(4000)
DECLARE @URL_BUTTON_TXT VARCHAR(160)
DECLARE @URL VARCHAR(1000)

DECLARE @CALLBACK  VARCHAR(14)
SET @CALLBACK='0802690011'

SELECT @LMS_MSG = LMS_MSG, @LMS_TITLE = LMS_TITLE, @KKO_MSG= KKO_MSG, @URL_BUTTON_TXT = URL_BUTTON_TXT, @URL = URL FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWsms05'')') 

INSERT FINDDB1.COMDB1.DBO.MMS_MSG
      (REQDATE, STATUS, TYPE, PHONE, CALLBACK, SUBJECT, MSG, FILE_CNT, ETC1)
SELECT 
       GETDATE()
      ,'1'
      ,'0'
      ,REPLACE(ISNULL(A.HPHONE,''),'-','')
      ,@CALLBACK
      ,@LMS_TITLE
      ,REPLACE(REPLACE(REPLACE(@LMS_MSG,'#{ID}',B.USERID) , '#{한달후/3일후}','3일후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10), DATEADD(YEAR, 2, ISNULL(B.LAST_LOGIN_DT, B.JOIN_DT)) , 111), '/', '-'))
      ,'1'
      ,'FINDALL'
  FROM CST_REST_MASTER AS A WITH (NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE B.OUT_YN='N'
   AND B.REST_YN='Y'
   AND DATEADD(YEAR, 2, CONVERT(VARCHAR(10), ISNULL(LAST_LOGIN_DT,JOIN_DT), 111)) = DATEADD(DAY, 3, CONVERT(VARCHAR(10), GETDATE(), 111))
GO
/****** Object:  StoredProcedure [dbo].[_BAT_REST_MEMBER_LMS_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 휴면 처리 당일 SMS 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016/09/30
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_REST_MEMBER_LMS_PROC
 *************************************************************************************/
CREATE PROC [dbo].[_BAT_REST_MEMBER_LMS_PROC]

AS

SET NOCOUNT ON

DECLARE @LMS_MSG VARCHAR(4000)
DECLARE @LMS_TITLE VARCHAR(160)
DECLARE @KKO_MSG VARCHAR(4000)
DECLARE @URL_BUTTON_TXT VARCHAR(160)
DECLARE @URL VARCHAR(1000)

DECLARE @CALLBACK  VARCHAR(14)
SET @CALLBACK='0802690011'

SELECT @LMS_MSG = LMS_MSG, @LMS_TITLE = LMS_TITLE, @KKO_MSG= KKO_MSG, @URL_BUTTON_TXT = URL_BUTTON_TXT, @URL = URL FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWsms04'')') 

INSERT FINDDB1.COMDB1.DBO.MMS_MSG
      (REQDATE, STATUS, TYPE, PHONE, CALLBACK, SUBJECT, MSG, FILE_CNT, ETC1)
SELECT 
       GETDATE()
      ,'1'
      ,'0'
      ,REPLACE(ISNULL(A.HPHONE,''),'-','')
      ,@CALLBACK
      ,@LMS_TITLE
      ,REPLACE(@LMS_MSG,'#{ID}',B.USERID)
      ,'1'
      ,'FINDALL'
  FROM CST_REST_MASTER AS A WITH(NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE CONVERT(VARCHAR(10), A.ADD_DT, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)
GO
/****** Object:  StoredProcedure [dbo].[_BAT_REST_MEMBER_ONEMONTH_AGO_LMS_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 개인회원, SMS 수신동의하지 않은 기업회원 휴면 처리 한달전 SMS 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016/09/30
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_REST_MEMBER_ONEMONTH_AGO_LMS_PROC
 *************************************************************************************/
CREATE PROC [dbo].[_BAT_REST_MEMBER_ONEMONTH_AGO_LMS_PROC]

AS

SET NOCOUNT ON

DECLARE @LMS_MSG VARCHAR(4000)
DECLARE @LMS_TITLE VARCHAR(160)
DECLARE @KKO_MSG VARCHAR(4000)
DECLARE @URL_BUTTON_TXT VARCHAR(160)
DECLARE @URL VARCHAR(1000)

DECLARE @CALLBACK  VARCHAR(14)
SET @CALLBACK='0802690011'

SELECT @LMS_MSG = LMS_MSG, @LMS_TITLE = LMS_TITLE, @KKO_MSG= KKO_MSG, @URL_BUTTON_TXT = URL_BUTTON_TXT, @URL = URL FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWsms03'')') 


INSERT FINDDB1.COMDB1.DBO.MMS_MSG
      (REQDATE, STATUS, TYPE, PHONE, CALLBACK, SUBJECT, MSG, FILE_CNT, ETC1)
SELECT 
       GETDATE()
      ,'1'
      ,'0'
      ,REPLACE(ISNULL(A.HPHONE,''),'-','')
      ,@CALLBACK
      ,@LMS_TITLE
      ,REPLACE(REPLACE(REPLACE(@LMS_MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','한달후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-'))
      ,'1'
      ,'FINDALL'
  FROM DBO.CST_MASTER AS A WITH(NOLOCK)
  WHERE MEMBER_CD = 1
    AND A.REST_YN = 'N'		--휴면회원 제외
    AND A.BAD_YN = 'N' 		--불량회원 제외
    AND A.OUT_YN = 'N'   --회원탈퇴 제외
    AND (
          (A.LAST_LOGIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
          OR 
          (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
        )
UNION ALL
SELECT 
       GETDATE()
      ,'1'
      ,'0'
      ,REPLACE(ISNULL(A.HPHONE,''),'-','')
      ,@CALLBACK
      ,@LMS_TITLE
      ,REPLACE(REPLACE(REPLACE(@LMS_MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','한달후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-'))
      ,'1'
      ,'FINDALL'
  FROM DBO.CST_MASTER AS A WITH(NOLOCK)
 WHERE NOT EXISTS 
       (
       SELECT * from DBO.CST_MSG_SECTION D (NOLOCK) WHERE A.CUID = D.CUID AND D.MEDIA_CD = 'S' AND D.SECTION_CD = 'S101'
       )
   AND MEMBER_CD = 2
   AND A.REST_YN = 'N'		--휴면회원 제외
   AND A.BAD_YN = 'N' 		--불량회원 제외
   AND A.OUT_YN = 'N'   --회원탈퇴 제외
   AND (
        (A.LAST_LOGIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
        OR 
        (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
       )
GO
/****** Object:  StoredProcedure [dbo].[_BAT_REST_MEMBER_THREEDAY_AGO_LMS_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 휴면 처리 3일전 SMS 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016/09/30
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_REST_MEMBER_THREEDAY_AGO_LMS_PROC
 *************************************************************************************/
CREATE PROC [dbo].[_BAT_REST_MEMBER_THREEDAY_AGO_LMS_PROC]

AS

SET NOCOUNT ON

DECLARE @LMS_MSG VARCHAR(4000)
DECLARE @LMS_TITLE VARCHAR(160)
DECLARE @KKO_MSG VARCHAR(4000)
DECLARE @URL_BUTTON_TXT VARCHAR(160)
DECLARE @URL VARCHAR(1000)

DECLARE @CALLBACK  VARCHAR(14)
SET @CALLBACK='0802690011'

SELECT @LMS_MSG = LMS_MSG, @LMS_TITLE = LMS_TITLE, @KKO_MSG= KKO_MSG, @URL_BUTTON_TXT = URL_BUTTON_TXT, @URL = URL FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWsms03'')') 

INSERT FINDDB1.COMDB1.DBO.MMS_MSG
      (REQDATE, STATUS, TYPE, PHONE, CALLBACK, SUBJECT, MSG, FILE_CNT, ETC1)
SELECT 
       GETDATE()
      ,'1'
      ,'0'
      ,REPLACE(ISNULL(A.HPHONE,''),'-','')
      ,@CALLBACK
      ,@LMS_TITLE
      ,REPLACE(REPLACE(REPLACE(@LMS_MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','3일후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-'))
      ,'1'
      ,'FINDALL'
  FROM DBO.CST_MASTER AS A WITH(NOLOCK)
  WHERE A.REST_YN = 'N'		--휴면회원 제외
    AND A.BAD_YN = 'N' 		--불량회원 제외
    AND A.OUT_YN = 'N'   --회원탈퇴 제외
    AND (
          (A.LAST_LOGIN_DT < DATEADD(DD,3,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,2,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
          OR 
          (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,3,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,2,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
        )
GO
/****** Object:  StoredProcedure [dbo].[_cst_master_update_serve_20211005]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
JMG@20190117 통합회원 DB 업데이트
select * from good.dbo.tbl_naverclosebizno with(nolock) 

-- exec good.dbo.AG_NAVERCLOSEBIZNO_S1 @bizNo='2068526551'
exec good.dbo.AG_NAVERCLOSEBIZNO_S1 @bizNo='2068526551'

*/
CREATE PROCEDURE [dbo].[_cst_master_update_serve_20211005]
	@mem_seq		int = 0,
	@hphone			varchar(30) = '',
	@user_nm		varchar(50) = '',
	@email			varchar(50) = '',
	@pwd			varchar(50) = '',
	@main_phone		varchar(30) = '',
	@com_nm			varchar(50) = '',
	@ceo_nm			varchar(50) = '',
	@fax			varchar(30) = '',
	@register_no	varchar(50) = '',
	@reg_number		varchar(50) = ''
AS
BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @COM_ID INT	
	DECLARE @USER_ID varchar(50)	

	SELECT @COM_ID = COM_ID
	,@USER_ID = USERID 
	FROM MWMEMBER.DBO.CST_MASTER
	WHERE CUID = @MEM_SEQ

	IF @pwd <> ''  AND @pwd <> 'd41d8cd98f00b204e9800998ecf8427e' BEGIN --공백일경우 업데이트 안함 2019-01-21 조민기

		UPDATE DBO.CST_MASTER
		SET HPHONE = @hphone 
		, USER_NM = @user_nm
		, EMAIL = @email
		, PWD_MOD_DT = GETDATE()
		, pwd_sha2 = master.DBO.fnGetStringToSha256(@PWD)
		WHERE CUID = @mem_seq
		
		UPDATE CST_LOGIN_FAIL_COUNT 
		SET FAIL_CNT = 0
		, FAIL_DATE = ''
		WHERE USERID = @USER_ID

	END ELSE BEGIN

		UPDATE DBO.CST_MASTER
		SET HPHONE = @hphone 
		, USER_NM = @user_nm
		, EMAIL = @email
		, PWD_MOD_DT = GETDATE()
		WHERE CUID = @mem_seq

	END

	UPDATE DBO.CST_COMPANY
	SET MAIN_PHONE = @main_phone
	, COM_NM = @com_nm
	, CEO_NM = @ceo_nm
	, FAX = @FAX
	, REGISTER_NO = @register_no
	WHERE COM_ID = @COM_ID

	UPDATE DBO.CST_COMPANY_LAND
	SET REG_NUMBER = @reg_number
	WHERE COM_ID = @COM_ID
	
END
GO
/****** Object:  StoredProcedure [dbo].[_GET_AD_MM_MEMBER_TB_DETAIL_PROC_20210708]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원리스트 > 회원 상세
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015.02.15
 *  수   정   자 : 도정민
 *  수   정   일 : 2019.10.01
 *  설        명 : 마케팅·이벤트정보 수신 동의 추가
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_MM_MEMBER_TB_DETAIL_PROC 'SEBILIA'

 *************************************************************************************/

CREATE PROCEDURE [dbo].[_GET_AD_MM_MEMBER_TB_DETAIL_PROC_20210708]
	@CUID		INT
AS

SET NOCOUNT ON

	SELECT	M.USERID
		,CASE
		      WHEN MEMBER_CD=2 THEN '비즈니스'
		      WHEN MEMBER_CD=1 AND SNS_TYPE='N' THEN '일반(네이버)'
		      WHEN MEMBER_CD=1 AND SNS_TYPE='F' THEN '일반(페이스북)'
		      WHEN MEMBER_CD=1 AND SNS_TYPE='K' THEN '일반(카카오톡)'
		      WHEN MEMBER_CD=1 THEN '일반'
		 END AS MEMBER_CD
		,J.SECTION_CD
		,M.JOIN_DT
		,M.USER_NM
		,M.MOD_DT
		,M.HPHONE
		,CASE
		      WHEN M.DI IS NOT NULL THEN 'Y'
		      ELSE 'N'
		 END AS REAL_CHK_YN
		,M.REST_YN
		,M.EMAIL		
		,M.OUT_YN
	    ,M.BAD_YN
		,M.BIRTH AS JUMINNO	
	    , NULL AS SECTION_CD_ETC
        ,CM.AGREE_DT AS MK_AGREE_DT             -- 20191001 추가 
		,ISNULL(CM.AGREEF,'0') AS MK_AGREEF     -- 20191001 추가
	  FROM	DBO.CST_MASTER M WITH(NOLOCK)
	  LEFT JOIN CST_JOIN_INFO AS J WITH (NOLOCK) ON M.CUID = J.CUID
	  LEFT OUTER JOIN CST_MARKETING_AGREEF_TB AS CM ON CM.CUID = M.CUID       -- 20191001 추가
	 WHERE	M.CUID = @CUID
GO
/****** Object:  StoredProcedure [dbo].[_GET_MM_COMPANY_SECTION_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 가입한 기업회원 섹션 가져오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015.3.6
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 

 *************************************************************************************/
CREATE PROCEDURE [dbo].[_GET_MM_COMPANY_SECTION_PROC]
	 @CUID		INT
AS
	
	SELECT ISNULL(COM_NM,'') AS COM_NM
	  FROM CST_MASTER AS A WITH (NOLOCK) 
	  INNER JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID 
	 WHERE A.CUID= @CUID
GO
/****** Object:  StoredProcedure [dbo].[_GET_MM_MEMBER_INFO_BY_USERID_PROC_20210708]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 /기업 구분 없이 회원 기본 정보 값 가져 오기
 *  작   성   자 : 안상미
 *  작   성   일 : 2008.07.03
 *  수   정   자 : 정헌수 
 *  수   정   일 : 2015-04-14
 *  설        명 : 오류 발생으로 GET_F_MM_MEMBER_TB_INFO_PROC => GET_MM_MEMBER_INFO_PROC 변경 및 필드 추가
					 http://www.findall.co.kr/survey/survey_poll.asp
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 부동산 불량광고 처리 메일 발송 페이지/FindJob 신문문 신문줄광고 신청페이지
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /BService/JobOffer/PaperInsert.asp
 GET_MM_MEMBER_INFO_PROC 'kkam1234'
 *************************************************************************************/


CREATE PROCEDURE [dbo].[_GET_MM_MEMBER_INFO_BY_USERID_PROC_20210708] 

	 @USERID			varchar(50) = ''
AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 기본정보
	SELECT TOP 1
        A.USERID	-- 회원아이디
        ,A.MEMBER_CD -- 회원구분
        ,A.USER_NM AS USERNAME	-- 회원명
        ,A.EMAIL		-- 이메일
        ,'' AS PHONE
        ,A.HPHONE		-- 휴대폰
        ,A.MOD_DT		-- 수정일
        ,A.JOIN_DT	
        ,A.GENDER
        ,A.BIRTH  AS JUMINNO
        ,A.CUID
        ,A.BAD_YN
	  FROM CST_MASTER AS A WITH(NOLOCK)
   WHERE A.OUT_YN ='N'
     AND A.BAD_YN ='N'
	 AND A.USERID = @USERID
  --      AND A.CUID = @CUID
   ORDER BY A.SITE_CD ASC   -- 사이트코드 (F:FindAll, S:부동산서브, M: MWPLUS)

END
GO
/****** Object:  StoredProcedure [dbo].[_GET_MM_MEMBER_PROC_20210708]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원 기본 정보 가져오기(공통)
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015.3.9
 *  수   정   자 : 이근우
 *  수   정   일 : 2018.05.03
 *  설        명 : 불량여부, 휴면여부, 탈퇴여부 추가
 *  주 의  사 항 : 
 *  사 용  소 스 :
 EXEC GET_MM_MEMBER_PROC 14342567
 *************************************************************************************/
CREATE PROCEDURE [dbo].[_GET_MM_MEMBER_PROC_20210708]
	 @CUID		INT

AS

	SET NOCOUNT ON 
	-- 기본정보
	SELECT
		   A.USERID
		 , A.USER_NM
		 , A.MEMBER_CD
		 , A.HPHONE
		 , A.EMAIL
		 , A.SNS_TYPE    
		 , A.SNS_ID 
		 , A.BIRTH	-- 회원정보 수정시 필요
		 , A.GENDER	-- 회원정보 수정시 필요
		 , CASE	WHEN A.REALHP_YN ='Y' THEN 'Y'
				WHEN (SELECT COUNT(*) FROM CST_MASTER AS B WITH (NOLOCK) WHERE B.HPHONE = A.HPHONE AND B.MEMBER_CD='1') = 1  THEN 'Y' 
				ELSE 'N' 
				END AS REALHP_YN
     , A.BAD_YN
     , A.REST_YN
     , A.REST_DT
     , A.OUT_YN
     , A.OUT_DT
	 , M.AGREE_DT AS MK_AGREE_DT
     , ISNULL(M.AGREEF,0) AS MK_AGREEF	
	  FROM CST_MASTER AS A WITH (NOLOCK)
	  LEFT OUTER JOIN CST_MARKETING_AGREEF_TB AS M ON M.CUID = A.CUID
	 WHERE A.CUID=@CUID

	-- 수신 동의 섹션 가져오기
	--EXEC DBO.GET_MSG_SECTION @CUID

GO
/****** Object:  StoredProcedure [dbo].[_PUT_F_CST_SERVICE_USE_AGREE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 공통 > 서비스이용동의
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2018/09/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 
 declare @RESULT INT 
 EXEC dbo.PUT_F_CST_SERVICE_USE_AGREE_PROC 0 ,@RESULT OUTPUT
 select @RESULT
 
truncate table CST_SERVICE_USE_AGREE
 
 declare @RESULT INT 
 exec MWMEMBER.dbo.PUT_F_CST_SERVICE_USE_AGREE_PROC 10370929,'S102','9','','',' ',@RESULT OUTPUT
 select @RESULT

 exec MWMEMBER.dbo._PUT_F_CST_SERVICE_USE_AGREE_PROC 13878784,'S103','13','조재성','19760829','1','MC0GCCqGSIb3DQIJAyEAjmNU/wbUOm1MJO/6CbNPH3HRKXapNufhHkQkkFlqV6g=',@p8 output,'1','010-8779-8662'
 *************************************************************************************/

 
CREATE PROC [dbo].[_PUT_F_CST_SERVICE_USE_AGREE_PROC]

  @CUID         INT
  ,@SECTION_CD	CHAR(4)       -- 섹션코드 (CC_SECTION_TB 참고)
  ,@AGREE_CD	  VARCHAR(10)     -- 서비스코드 (SELECT * FROM CMN_CODE WHERE CODE_GROUP_ID = 'SERVICE_CD' 참고)

  ,@USER_NM     VARCHAR(30) = ''
  ,@BIRTH       VARCHAR(8)  = ''
  ,@GENDER      CHAR(1)     = ''

  ,@DI          VARCHAR(70) = ''

  ,@RESULT INT = 999 OUTPUT

  ,@MEMBER_CD CHAR(1)
  ,@HPHONE VARCHAR(14)  = ''

AS

  SET NOCOUNT ON

  SET @HPHONE = REPLACE(@HPHONE,'-','')

  DECLARE @DUP_CNT INT

  DECLARE @VAL_DI CHAR(64)
  DECLARE @VAL_MEMBER_CD CHAR(1)
  DECLARE @VAL_SNSF CHAR(1)
  DECLARE @VAL_USER_NM VARCHAR(30)
  DECLARE @VAL_BIRTH VARCHAR(8)
  DECLARE @VAL_HPHONE VARCHAR(14)
  DECLARE @VAL_GENDER CHAR(1)

  -- 기존 정보
  SELECT @VAL_DI = DI
        ,@VAL_USER_NM = USER_NM
        ,@VAL_MEMBER_CD = MEMBER_CD
        ,@VAL_SNSF = CASE ISNULL(SNS_TYPE,'') WHEN '' THEN '0'
                          ELSE '1'
                          END
        ,@VAL_BIRTH   = BIRTH
        ,@VAL_HPHONE  = REPLACE(HPHONE,'-','')
        ,@VAL_GENDER  = GENDER
    FROM CST_MASTER
   WHERE CUID = @CUID

  IF @DI <> ''   -- 휴대폰 본인인증을 통하면서 기존 ID값이 있는 경우
    BEGIN
      -- 성별값 치환
      IF @GENDER = '1'
        BEGIN
          SET @GENDER = 'M'
        END
      ELSE
        BEGIN
          SET @GENDER = 'F'
        END

      -- 일치하는 회원정보가 있는지 확인
      --IF NOT EXISTS(SELECT * FROM CST_MASTER WHERE CUID = @CUID AND DI = @DI AND OUT_YN = 'N')
      IF @VAL_SNSF = '1'  -- SNS 회원
        BEGIN
          IF @VAL_HPHONE <> @HPHONE
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END 
        END

      IF @VAL_MEMBER_CD = '1' AND @VAL_SNSF = '0'  -- 개인회원
        BEGIN
          IF (@VAL_USER_NM != @USER_NM OR @VAL_GENDER != @GENDER OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END
        END


      IF @VAL_MEMBER_CD = '2'   -- 기업회원
        BEGIN
          IF (@VAL_USER_NM != @USER_NM OR @VAL_GENDER != @GENDER OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END
        END
/*
      SELECT @DUP_CNT = COUNT(*)
        FROM CST_SERVICE_USE_AGREE
       WHERE CUID IN (SELECT CUID FROM CST_MASTER WHERE DI = @DI AND MEMBER_CD = @MEMBER_CD  AND OUT_YN = 'N')
*/
      SELECT @DUP_CNT = COUNT(*)
        FROM CST_MASTER AS A
       WHERE DI = @DI AND MEMBER_CD = @MEMBER_CD  AND OUT_YN = 'N'
         AND CUID IN (SELECT DISTINCT CUID FROM CST_SERVICE_USE_AGREE WHERE AGREE_CD = @AGREE_CD)

      IF @DUP_CNT > 2
        BEGIN
          SET @RESULT = 1     -- 서비스이용동의한 동일정보의 회원이 3개이상 존재하는 경우
          RETURN
        END

      -- 개인회원인 경우 DI값 갱신
      IF @VAL_MEMBER_CD = '1'
        BEGIN
          UPDATE CST_MASTER
             SET DI = @DI
           WHERE CUID = @CUID    
        END

      -- SNS회원인 경우 회원정보 갱신 (본인인증처에서 보낸 정보로)
      IF @VAL_SNSF = '1'
        BEGIN
          UPDATE CST_MASTER
             SET USER_NM = @USER_NM
                ,BIRTH = @BIRTH
                ,GENDER = @GENDER
                --,HPHONE = @HPHONE
           WHERE CUID = @CUID
        END

    END

  -- 동의코드 중복되지 않는다면 등록
  IF NOT EXISTS(SELECT * FROM CST_SERVICE_USE_AGREE WHERE AGREE_CD = @AGREE_CD AND CUID = @CUID)
    BEGIN
      INSERT INTO CST_SERVICE_USE_AGREE
        (CUID
        ,SECTION_CD
        ,AGREE_CD)
      VALUES
        (@CUID
        ,@SECTION_CD
        ,@AGREE_CD)
    END

    SET @RESULT = 0     -- 이용동의 처리 완료


GO
/****** Object:  StoredProcedure [dbo].[_PUT_F_CST_SERVICE_USE_AGREE_PROC_20190411]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 공통 > 서비스이용동의
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2018/09/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 
 declare @RESULT INT 
 EXEC dbo.PUT_F_CST_SERVICE_USE_AGREE_PROC 0 ,@RESULT OUTPUT
 select @RESULT
 
truncate table CST_SERVICE_USE_AGREE
 
 declare @RESULT INT 
 exec MWMEMBER.dbo.PUT_F_CST_SERVICE_USE_AGREE_PROC 10370929,'S102','9','','',' ',@RESULT OUTPUT
 select @RESULT
 
 *************************************************************************************/

 
CREATE PROC [dbo].[_PUT_F_CST_SERVICE_USE_AGREE_PROC_20190411]

  @CUID         INT
  ,@SECTION_CD	CHAR(4)       -- 섹션코드 (CC_SECTION_TB 참고)
  ,@AGREE_CD	  VARCHAR(10)     -- 서비스코드 (SELECT * FROM CMN_CODE WHERE CODE_GROUP_ID = 'SERVICE_CD' 참고)

  ,@USER_NM     VARCHAR(30) = ''
  ,@BIRTH       VARCHAR(8)  = ''
  ,@GENDER      CHAR(1)     = ''

  ,@DI          VARCHAR(70) = ''

  ,@RESULT INT = 999 OUTPUT

  ,@MEMBER_CD CHAR(1) = '1'
  ,@HPHONE VARCHAR(14)  = ''

AS

  SET NOCOUNT ON

  SET @HPHONE = REPLACE(@HPHONE,'-','')

  DECLARE @DUP_CNT INT

  DECLARE @VAL_DI CHAR(64)
  DECLARE @VAL_MEMBER_CD CHAR(1)
  DECLARE @VAL_SNSF CHAR(1)
  DECLARE @VAL_USER_NM VARCHAR(30)
  DECLARE @VAL_BIRTH VARCHAR(8)
  DECLARE @VAL_HPHONE VARCHAR(14)
  DECLARE @VAL_GENDER CHAR(1)

  -- 기존 정보
  SELECT @VAL_DI = DI
        ,@VAL_USER_NM = USER_NM
        ,@VAL_MEMBER_CD = MEMBER_CD
        ,@VAL_SNSF = CASE ISNULL(SNS_TYPE,'') WHEN '' THEN '0'
                          ELSE '1'
                          END
        ,@VAL_BIRTH   = BIRTH
        ,@VAL_HPHONE  = REPLACE(HPHONE,'-','')
        ,@VAL_GENDER  = GENDER
    FROM CST_MASTER
   WHERE CUID = @CUID

  IF @DI <> ''   -- 휴대폰 본인인증을 통하면서 기존 ID값이 있는 경우
    BEGIN
      -- 성별값 치환
      IF @GENDER = '1'
        BEGIN
          SET @GENDER = 'M'
        END
      ELSE
        BEGIN
          SET @GENDER = 'F'
        END

      -- 일치하는 회원정보가 있는지 확인
      --IF NOT EXISTS(SELECT * FROM CST_MASTER WHERE CUID = @CUID AND DI = @DI AND OUT_YN = 'N')
      IF @VAL_SNSF = '1'  -- SNS 회원
        BEGIN
          IF @VAL_HPHONE <> @HPHONE
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END 
        END

      IF @VAL_MEMBER_CD = '1' AND @VAL_SNSF = '0'  -- 개인회원
        BEGIN
          IF (@VAL_USER_NM != @USER_NM OR @VAL_GENDER != @GENDER OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END
        END


      IF @VAL_MEMBER_CD = '2'   -- 기업회원
        BEGIN
          IF (@VAL_USER_NM != @USER_NM OR @VAL_GENDER != @GENDER OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END
        END
/*
      SELECT @DUP_CNT = COUNT(*)
        FROM CST_SERVICE_USE_AGREE
       WHERE CUID IN (SELECT CUID FROM CST_MASTER WHERE DI = @DI AND MEMBER_CD = @MEMBER_CD  AND OUT_YN = 'N')
*/
      SELECT @DUP_CNT = COUNT(*)
        FROM CST_MASTER AS A
       WHERE DI = @DI AND MEMBER_CD = @MEMBER_CD  AND OUT_YN = 'N'
         AND CUID IN (SELECT DISTINCT CUID FROM CST_SERVICE_USE_AGREE WHERE AGREE_CD = @AGREE_CD)

      IF @DUP_CNT > 2
        BEGIN
          SET @RESULT = 1     -- 서비스이용동의한 동일정보의 회원이 3개이상 존재하는 경우
          RETURN
        END

      -- 개인회원인 경우 DI값 갱신
      IF @VAL_MEMBER_CD = '1'
        BEGIN
          UPDATE CST_MASTER
             SET DI = @DI
           WHERE CUID = @CUID    
        END

      -- SNS회원인 경우 회원정보 갱신 (본인인증처에서 보낸 정보로)
      IF @VAL_SNSF = '1'
        BEGIN
          UPDATE CST_MASTER
             SET USER_NM = @USER_NM
                ,BIRTH = @BIRTH
                ,GENDER = @GENDER
                --,HPHONE = @HPHONE
           WHERE CUID = @CUID
        END

    END

  -- 동의코드 중복되지 않는다면 등록
  IF NOT EXISTS(SELECT * FROM CST_SERVICE_USE_AGREE WHERE AGREE_CD = @AGREE_CD AND CUID = @CUID)
    BEGIN
      INSERT INTO CST_SERVICE_USE_AGREE
        (CUID
        ,SECTION_CD
        ,AGREE_CD)
      VALUES
        (@CUID
        ,@SECTION_CD
        ,@AGREE_CD)
    END

    SET @RESULT = 0     -- 이용동의 처리 완료


GO
/****** Object:  StoredProcedure [dbo].[_PUT_F_CST_SERVICE_USE_AGREE_PROC_20190429]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 공통 > 서비스이용동의
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2018/09/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 
 declare @RESULT INT 
 EXEC dbo.PUT_F_CST_SERVICE_USE_AGREE_PROC 0 ,@RESULT OUTPUT
 select @RESULT
 
truncate table CST_SERVICE_USE_AGREE
 
 declare @RESULT INT 
 exec MWMEMBER.dbo.PUT_F_CST_SERVICE_USE_AGREE_PROC 10370929,'S102','9','','',' ',@RESULT OUTPUT
 select @RESULT
 
 *************************************************************************************/

 
CREATE PROC [dbo].[_PUT_F_CST_SERVICE_USE_AGREE_PROC_20190429]

  @CUID         INT
  ,@SECTION_CD	CHAR(4)       -- 섹션코드 (CC_SECTION_TB 참고)
  ,@AGREE_CD	  VARCHAR(10)     -- 서비스코드 (SELECT * FROM CMN_CODE WHERE CODE_GROUP_ID = 'SERVICE_CD' 참고)

  ,@USER_NM     VARCHAR(30) = ''
  ,@BIRTH       VARCHAR(8)  = ''
  ,@GENDER      CHAR(1)     = ''

  ,@DI          VARCHAR(70) = ''

  ,@RESULT INT = 999 OUTPUT

  ,@MEMBER_CD CHAR(1) = '1'
  ,@HPHONE VARCHAR(14)  = ''

AS

  SET NOCOUNT ON

  SET @HPHONE = REPLACE(@HPHONE,'-','')

  DECLARE @DUP_CNT INT

  DECLARE @VAL_DI CHAR(64)
  DECLARE @VAL_MEMBER_CD CHAR(1)
  DECLARE @VAL_SNSF CHAR(1)
  DECLARE @VAL_USER_NM VARCHAR(30)
  DECLARE @VAL_BIRTH VARCHAR(8)
  DECLARE @VAL_HPHONE VARCHAR(14)
  DECLARE @VAL_GENDER CHAR(1)

  -- 기존 정보
  SELECT @VAL_DI = DI
        ,@VAL_USER_NM = USER_NM
        ,@VAL_MEMBER_CD = MEMBER_CD
        ,@VAL_SNSF = CASE ISNULL(SNS_TYPE,'') WHEN '' THEN '0'
                          ELSE '1'
                          END
        ,@VAL_BIRTH   = BIRTH
        ,@VAL_HPHONE  = REPLACE(HPHONE,'-','')
        ,@VAL_GENDER  = GENDER
    FROM CST_MASTER
   WHERE CUID = @CUID

  IF @DI <> ''   -- 휴대폰 본인인증을 통하면서 기존 ID값이 있는 경우
    BEGIN
      -- 성별값 치환
      IF @GENDER = '1'
        BEGIN
          SET @GENDER = 'M'
        END
      ELSE IF @GENDER = '0'
        BEGIN
          SET @GENDER = 'F'
        END

      -- 일치하는 회원정보가 있는지 확인
      --IF NOT EXISTS(SELECT * FROM CST_MASTER WHERE CUID = @CUID AND DI = @DI AND OUT_YN = 'N')
      IF @VAL_SNSF = '1'  -- SNS 회원
        BEGIN
          IF @VAL_HPHONE <> @HPHONE
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END 
        END

      IF @VAL_MEMBER_CD = '1' AND @VAL_SNSF = '0'  -- 개인회원
        BEGIN
          IF (@VAL_USER_NM != @USER_NM OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END
        END


      IF @VAL_MEMBER_CD = '2'   -- 기업회원
        BEGIN
          IF (@VAL_USER_NM != @USER_NM OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END
        END
/*
      SELECT @DUP_CNT = COUNT(*)
        FROM CST_SERVICE_USE_AGREE
       WHERE CUID IN (SELECT CUID FROM CST_MASTER WHERE DI = @DI AND MEMBER_CD = @MEMBER_CD  AND OUT_YN = 'N')
*/
      SELECT @DUP_CNT = COUNT(*)
        FROM CST_MASTER AS A
       WHERE DI = @DI AND MEMBER_CD = @MEMBER_CD  AND OUT_YN = 'N'
         AND CUID IN (SELECT DISTINCT CUID FROM CST_SERVICE_USE_AGREE WHERE AGREE_CD = @AGREE_CD)

      IF @DUP_CNT > 2
        BEGIN
          SET @RESULT = 1     -- 서비스이용동의한 동일정보의 회원이 3개이상 존재하는 경우
          RETURN
        END

      -- 개인회원인 경우 DI값, GENDER값 갱신
      IF @VAL_MEMBER_CD = '1'
        BEGIN
          UPDATE CST_MASTER
             SET DI = @DI
                ,GENDER = @GENDER
           WHERE CUID = @CUID    
        END

      -- SNS회원인 경우 회원정보 갱신 (본인인증처에서 보낸 정보로)
      IF @VAL_SNSF = '1'
        BEGIN
          UPDATE CST_MASTER
             SET USER_NM = @USER_NM
                ,BIRTH = @BIRTH
                ,GENDER = @GENDER
                --,HPHONE = @HPHONE
           WHERE CUID = @CUID
        END

    END

  -- 동의코드 중복되지 않는다면 등록
  IF NOT EXISTS(SELECT * FROM CST_SERVICE_USE_AGREE WHERE AGREE_CD = @AGREE_CD AND CUID = @CUID)
    BEGIN
      INSERT INTO CST_SERVICE_USE_AGREE
        (CUID
        ,SECTION_CD
        ,AGREE_CD)
      VALUES
        (@CUID
        ,@SECTION_CD
        ,@AGREE_CD)
    END

    SET @RESULT = 0     -- 이용동의 처리 완료


GO
/****** Object:  StoredProcedure [dbo].[_SP_LOGIN_20210708]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 : 배진용
 *  수   정   일 : 2020-10-27
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
  DECLARE @RET INT
  EXEC @RET=SP_LOGIN 'mwmobile01','11111111' , 'S101' ,'IP','HOST'
  SELECT @RET  -- 성공
  declare @DUPLICATE_YN INT 
  		EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160
	SELECT @DUPLICATE_YN

* 2020-10-27 -> 회원가입대행 여부 컬럼 추가 AGENCY_YN : 회원가입대행 여부,  LAST_SIGNUP_YN : 회원가입대행 최종 가입 여부

 *************************************************************************************/
CREATE PROCEDURE [dbo].[_SP_LOGIN_20210708]
@USERID VARCHAR(50) 
,@PWD VARCHAR(30)
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
AS
	SET NOCOUNT ON;
	DECLARE  
		@CUID INT
		,@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)
		,@ISADULT  CHAR(1)
		,@JOIN_DT VARCHAR(10)
		,@REALHP_YN	CHAR(1)
		,@ROWCOUNT INT
		,@LAND_CLASS_CD VARCHAR(30)
		,@REST_DT VARCHAR(10)
		-- 2020-10-27 회원가입대행 컬럼 추가
		,@AGENCY_YN		 CHAR(1)	-- 회원가입대행 여부
		,@LAST_SIGNUP_YN CHAR(1) -- 회원가입대행 최종 가입 여부
		,@REGISTER_NO VARCHAR(30) -- 사업자번호
		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = ISNULL(AA.USER_NM,''),
			@EMAIL = ISNULL(AA.EMAIL,''),
			@HPHONE = ISNULL(AA.HPHONE,''),
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = ISNULL(AA.COM_NM,''),
			@CONFIRM_YN = AA.CONFIRM_YN,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = AA.REALHP_YN,
			@LAND_CLASS_CD = AA.LAND_CLASS_CD,
			@REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END),
			-- 2020-10-27 회원가입대행 컬럼 추가
			@AGENCY_YN			= AA.AGENCY_YN,
			@LAST_SIGNUP_YN		= AA.LAST_SIGNUP_YN,
			@REGISTER_NO	= AA.REGISTER_NO
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			ISNULL(M.ADULT_YN,'N') AS ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'N') AS REALHP_YN,
			CL.LAND_CLASS_CD,
			M.REST_DT,
			-- 2020-10-27 회원가입대행 컬럼 추가
			ISNULL(M.AGENCY_YN,'N') AS AGENCY_YN,
			M.LAST_SIGNUP_YN,
			C.REGISTER_NO
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
			 LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID
		WHERE M.OUT_YN='N'
		  AND M.USERID = @USERID 
			AND  pwd_sha2 = master.DBO.fnGetStringToSha256(dbo.FN_MD5(LOWER(@PWD)))
			AND (M.STATUS_CD <> 'D' OR M.STATUS_CD IS NULL) --2018.01.26 추가
		) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/			
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음
		set @ROWCOUNT = @@ROWCOUNT
		
		
		IF @ROWCOUNT = 0 
		BEGIN
			IF EXISTS(SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @USERID) 
			BEGIN
			INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									  (@CUID ,@USERID, getdate(), @SECTION_CD,'N', @IP, @HOST)
			
			RETURN(200) -- 비밀 번호 틀림
			END
		END 
		ELSE IF @ROWCOUNT <> 2 
		BEGIN 
			/* 2순위 계정 체크 시작 {계정 변환 로직으로 ~!!! 300 }*/
			EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC @CUID
			IF @DUPLICATE_YN = 1
			BEGIN
				SET @COUNT = 3
			END
			/* 2순위 계정 체크  끝*/
		END 
		
		IF @REST_YN = 'Y' AND @ROWCOUNT <> 2  -- 중복회원 체크가 우선 
		BEGIN
			RETURN(500) -- 휴면 고객
		END ELSE IF @CUID IS NULL
		BEGIN
			INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									  (@CUID,@USERID,getdate(),@SECTION_CD,'N', @IP, 'ERR')    -- 로그인 이력 남기기
		
			RETURN(400) -- 사용자가 없음
		END ELSE IF @COUNT > 1 
		BEGIN 
			IF @COUNT = 3 
			BEGIN
			  SELECT 
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				ISNULL(@GENDER,'') AS GENDER,
				@REST_YN AS REST_YN,
				ISNULL(@BIRTH,'') AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				'N' AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAD_YN,
				ISNULL(@DI,'') AS DI,
				ISNULL(@ISADULT,'') AS ISADULT,
				'' AS SNSTYPE,
				@JOIN_DT AS JOIN_DT,
				ISNULL(@REALHP_YN,'') as REALHP_YN,
				@PWD AS PWD,
				DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,
				@USER_NM AS USERNAME,
				'' AS SECTION_CD,
				ISNULL(@LAND_CLASS_CD,'') AS LAND_CLASS_CD,
				@REST_DT AS REST_DT,
				-- 2020-10-27 회원가입대행 컬럼 추가
				@AGENCY_YN AS AGENCY_YN,
				@LAST_SIGNUP_YN AS LAST_SIGNUP_YN,
				@REGISTER_NO AS REGISTER_NO
				RETURN(300) -- 2순위 아이디
			END
			ELSE
			BEGIN -- @COUNT = 2
				RETURN(900) -- 복수의 아이디(아이디/비번 중복됨)
			END
		END ELSE IF @COUNT = 1
		BEGIN 
			SET @PWD_CHANGE_YN = 'N'
			IF @PWD_NEXT_ALARM_DT < GETDATE() SET @PWD_CHANGE_YN = 'Y'

			/*전화번호 중복 alert 확인용*/
			IF @MEMBER_CD  = 1  AND ISNULL(@REALHP_YN,'N') <> 'Y'
			BEGIN
				SELECT @DUPLICATE_PHONE = COUNT(*) 
				FROM CST_MASTER WITH(NOLOCK) 
				where HPHONE = @HPHONE and MEMBER_CD = 1 

				IF @DUPLICATE_PHONE  > 1 
				BEGIN
					SET @REALHP_YN ='N'
					SET @DUPLICATE_PHONE = 1
				END 
				ELSE BEGIN
					SET @REALHP_YN ='Y'
					SET @DUPLICATE_PHONE = 0
				END

			END
			ELSE 
			BEGIN
				SET @REALHP_YN = 'Y'
			END
			
      /*순서 변경하지 마세요. 뒷부분에 추가*/
			SELECT
				-- @COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				ISNULL(@GENDER,'') AS GENDER,
				@REST_YN AS REST_YN,
				ISNULL(@BIRTH,'') AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAD_YN,
				ISNULL(@DI,'') AS DI,
				ISNULL(@ISADULT,'') AS ISADULT,
				'' AS SNSTYPE,
				@JOIN_DT AS JOIN_DT,
				ISNULL(@REALHP_YN,'') as REALHP_YN,
				@PWD AS PWD,
				DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,
				@USER_NM AS USERNAME,
				'' AS SECTION_CD,
				ISNULL(@LAND_CLASS_CD,'') AS LAND_CLASS_CD,
				@REST_DT AS REST_DT,
        		-- 2020-10-27 회원가입대행 컬럼 추가
				@AGENCY_YN AS AGENCY_YN,
				@LAST_SIGNUP_YN AS LAST_SIGNUP_YN,
				@REGISTER_NO AS REGISTER_NO

				UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()
				  WHERE CUID = @CUID			  -- 마지막 로그인 시간 
				  
				INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									  (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기
									  
			RETURN(0) -- 정상 정상
		END	
		
		

GO
/****** Object:  StoredProcedure [dbo].[_SP_LOGIN_20211005]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************      
 *  단위 업무 명 : 로그인 및 이력      
 *  작   성   자 : J&J      
 *  작   성   일 : 2016-07-25      
 *  수   정   자 : 배진용      
 *  수   정   일 : 2020-10-27      
 *  수   정   자 : 안대희*
 *  수   정   일 : 2021-05-24
 *  설        명 :       
 * RETURN(500) -- 휴면 고객      
 * RETURN(400) -- 사용자가 없음      
 * RETURN(300) -- 복수의 아이디      
 * RETURN(200) -- 비밀 번호 틀림      
 * RETURN(0) -- 정상 정상      
  DECLARE @RET INT      
  EXEC @RET=SP_LOGIN 'mwmobile01','11111111' , 'S101' ,'IP','HOST'      
  SELECT @RET  -- 성공      
  declare @DUPLICATE_YN INT       
    EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160      
 SELECT @DUPLICATE_YN      
      
  * 2020-10-27 -> 회원가입대행 여부 컬럼 추가 AGENCY_YN : 회원가입대행 여부,  LAST_SIGNUP_YN : 회원가입대행 최종 가입 여부      
  * 2021-05-24: 회원가입대행 컬럼 추가      
  C.MEMBER_TYPE, -- 회원타입(CST_COMPANY)    
  CL.REG_NUMBER  -- 등록번호(CST_COMPANY_LAND)    
 *************************************************************************************/      
CREATE PROCEDURE [dbo].[_SP_LOGIN_20211005]      
@USERID VARCHAR(50)       
,@PWD VARCHAR(30)      
,@SECTION_CD CHAR(4)      
,@IP VARCHAR(15)      
,@HOST VARCHAR(50)      
AS      
 SET NOCOUNT ON;      
 DECLARE        
  @CUID INT      
  ,@USER_NM varchar(30)      
  ,@EMAIL varchar(50)      
  ,@HPHONE varchar(14)      
  ,@MEMBER_CD CHAR(1)      
  ,@GENDER CHAR(1)      
  ,@REST_YN CHAR(1)      
  ,@BIRTH varchar(8)      
  ,@COM_NM varchar(50)      
  ,@CONFIRM_YN CHAR(1)      
  ,@PWD_NEXT_ALARM_DT DATETIME      
  ,@SITE_CD CHAR(1)      
  ,@TRUE_YN CHAR(1)      
  ,@PWD_CHANGE_YN CHAR(1)      
  ,@COUNT INT      
  ,@DUPLICATE_YN  INT = 0       
  ,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인      
  ,@BAD_YN  CHAR(1)      
  ,@DI  CHAR(64)      
  ,@ISADULT  CHAR(1)      
  ,@JOIN_DT VARCHAR(10)      
  ,@REALHP_YN CHAR(1)      
  ,@ROWCOUNT INT      
  ,@LAND_CLASS_CD VARCHAR(30)      
  ,@REST_DT VARCHAR(10)      
  -- 2020-10-27 회원가입대행 컬럼 추가      
  ,@AGENCY_YN   CHAR(1) -- 회원가입대행 여부      
  ,@LAST_SIGNUP_YN CHAR(1) -- 회원가입대행 최종 가입 여부      
  ,@REGISTER_NO VARCHAR(30) -- 사업자번호    
  -- 2021-05-24 회원가입대행 > 공인중계사 - 등록번호컬럼 추가      
  ,@MEMBER_TYPE TINYINT -- 회원타입(CST_COMPANY)    
  ,@REG_NUMBER VARCHAR(50) -- 등록번호(CST_COMPANY_LAND)    
  SELECT      
   @COUNT = AA.ROW,      
   @CUID = AA.CUID,      
   @USER_NM = ISNULL(AA.USER_NM,''),      
   @EMAIL = ISNULL(AA.EMAIL,''),      
   @HPHONE = ISNULL(AA.HPHONE,''),      
   @GENDER = AA.GENDER,      
   @REST_YN = AA.REST_YN,      
   @BIRTH = AA.BIRTH,      
   @COM_NM = ISNULL(AA.COM_NM,''),      
   @CONFIRM_YN = AA.CONFIRM_YN,      
   @PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,      
   @SITE_CD = AA.SITE_CD,      
   @MEMBER_CD = AA.MEMBER_CD,      
   @TRUE_YN = AA.TRUE_YN,      
   @BAD_YN = AA.BAD_YN,      
   @DI = AA.DI,      
   @USERID = AA.USERID,      
   @ISADULT = AA.ADULT_YN,      
   @JOIN_DT = AA.JOIN_DT,      
   @REALHP_YN = AA.REALHP_YN,      
   @LAND_CLASS_CD = AA.LAND_CLASS_CD,      
   @REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END),      
   -- 2020-10-27 회원가입대행 컬럼 추가      
   @AGENCY_YN   = AA.AGENCY_YN,      
   @LAST_SIGNUP_YN  = AA.LAST_SIGNUP_YN,      
   @REGISTER_NO = AA.REGISTER_NO,    
   @MEMBER_TYPE = ISNULL(AA.MEMBER_TYPE, 1),    
   @REG_NUMBER  = ISNULL(AA.REG_NUMBER, '')    
   FROM       
   (      
   SELECT      
   ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,      
   M.CUID,      
   M.USER_NM,      
   M.EMAIL,      
   M.HPHONE,      
   M.GENDER,      
   M.REST_YN,      
   M.BIRTH,      
   C.COM_NM,      
   M.CONFIRM_YN,      
   M.MASTER_ID,      
   M.STATUS_CD,      
   M.PWD_NEXT_ALARM_DT,      
   M.SITE_CD,      
   M.MEMBER_CD,      
   'Y' AS TRUE_YN,      
   M.BAD_YN,      
   M.DI,      
   M.USERID,      
   ISNULL(M.ADULT_YN,'N') AS ADULT_YN,      
   CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,      
   ISNULL(REALHP_YN,'N') AS REALHP_YN,      
   CL.LAND_CLASS_CD,      
   M.REST_DT,      
   -- 2020-10-27 회원가입대행 컬럼 추가      
   ISNULL(M.AGENCY_YN,'N') AS AGENCY_YN,      
   M.LAST_SIGNUP_YN,      
   C.REGISTER_NO,    
   -- 2021-05-24 회원가입대행 컬럼 추가      
   C.MEMBER_TYPE, -- 회원타입(CST_COMPANY)    
   CL.REG_NUMBER  -- 등록번호(CST_COMPANY_LAND)    
  FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID      
    LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID      
  WHERE M.OUT_YN='N'      
    AND M.USERID = @USERID       
   AND  pwd_sha2 = master.DBO.fnGetStringToSha256(dbo.FN_MD5(LOWER(@PWD)))      
   AND (M.STATUS_CD <> 'D' OR M.STATUS_CD IS NULL) --2018.01.26 추가      
  ) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL      
   /* NULL : 통합 전    로그인 가능      
   W : 통합 승인대기중  로그인 가능      
   A : 통합 후 마스터계정   로그인 가능      
   D : 통합 후 서브계정  로그인 불가능      
   */         
  -- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음      
  set @ROWCOUNT = @@ROWCOUNT      
        
        
  IF @ROWCOUNT = 0       
  BEGIN      
   IF EXISTS(SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @USERID)       
   BEGIN      
   INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES      
           (@CUID ,@USERID, getdate(), @SECTION_CD,'N', @IP, @HOST)      
         
   RETURN(200) -- 비밀 번호 틀림      
   END      
  END       
  ELSE IF @ROWCOUNT <> 2       
  BEGIN       
   /* 2순위 계정 체크 시작 {계정 변환 로직으로 ~!!! 300 }*/      
   EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC @CUID      
   IF @DUPLICATE_YN = 1      
   BEGIN      
    SET @COUNT = 3      
   END      
   /* 2순위 계정 체크  끝*/      
  END       
        
  IF @REST_YN = 'Y' AND @ROWCOUNT <> 2  -- 중복회원 체크가 우선       
  BEGIN      
   RETURN(500) -- 휴면 고객      
  END ELSE IF @CUID IS NULL      
  BEGIN      
   INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES      
           (@CUID,@USERID,getdate(),@SECTION_CD,'N', @IP, 'ERR')    -- 로그인 이력 남기기      
        
   RETURN(400) -- 사용자가 없음      
  END ELSE IF @COUNT > 1       
  BEGIN       
   IF @COUNT = 3       
   BEGIN      
     SELECT       
    @CUID AS CUID,      
    @USER_NM AS USER_NM,      
    @EMAIL AS EMAIL,      
    @HPHONE AS HPHONE,      
    ISNULL(@GENDER,'') AS GENDER,      
    @REST_YN AS REST_YN,      
    ISNULL(@BIRTH,'') AS BIRTH,      
    @COM_NM AS COM_NM,      
    @CONFIRM_YN AS CONFIRM_YN,      
    --@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,      
    @SITE_CD AS SITE_CD,      
    @MEMBER_CD AS MEMBER_CD,      
    'N' AS TRUE_YN,      
    @PWD_CHANGE_YN AS PWD_CHANGE_YN,      
    @DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임      
    @USERID AS USERID,      
    @BAD_YN AS BAD_YN,      
    ISNULL(@DI,'') AS DI,      
    ISNULL(@ISADULT,'') AS ISADULT,      
    '' AS SNSTYPE,      
    @JOIN_DT AS JOIN_DT,      
    ISNULL(@REALHP_YN,'') as REALHP_YN,      
    @PWD AS PWD,      
    DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,      
    @USER_NM AS USERNAME,      
    '' AS SECTION_CD,      
    ISNULL(@LAND_CLASS_CD,'') AS LAND_CLASS_CD,      
    @REST_DT AS REST_DT,      
    -- 2020-10-27 회원가입대행 컬럼 추가      
    @AGENCY_YN AS AGENCY_YN,      
    @LAST_SIGNUP_YN AS LAST_SIGNUP_YN,      
    @REGISTER_NO AS REGISTER_NO,    
    @MEMBER_TYPE AS MEMBER_TYPE,    
    @REG_NUMBER  AS REG_NUMBER    
    RETURN(300) -- 2순위 아이디      
   END      
   ELSE      
   BEGIN -- @COUNT = 2      
    RETURN(900) -- 복수의 아이디(아이디/비번 중복됨)      
   END      
  END ELSE IF @COUNT = 1      
  BEGIN       
   SET @PWD_CHANGE_YN = 'N'      
   IF @PWD_NEXT_ALARM_DT < GETDATE() SET @PWD_CHANGE_YN = 'Y'      
      
   /*전화번호 중복 alert 확인용*/      
   IF @MEMBER_CD  = 1  AND ISNULL(@REALHP_YN,'N') <> 'Y'      
   BEGIN      
    SELECT @DUPLICATE_PHONE = COUNT(*)       
    FROM CST_MASTER WITH(NOLOCK)       
    where HPHONE = @HPHONE and MEMBER_CD = 1       
      
    IF @DUPLICATE_PHONE  > 1       
    BEGIN      
     SET @REALHP_YN ='N'      
     SET @DUPLICATE_PHONE = 1      
    END       
    ELSE BEGIN      
     SET @REALHP_YN ='Y'      
     SET @DUPLICATE_PHONE = 0      
    END      
      
   END      
   ELSE       
   BEGIN      
    SET @REALHP_YN = 'Y'      
   END      
         
   /* 순서 변경하지 마세요. 뒷부분에 추가 */      
   SELECT      
    -- @COUNT AS ROW,         
    @CUID AS CUID,      
    @USER_NM AS USER_NM,      
    @EMAIL AS EMAIL,      
    @HPHONE AS HPHONE,      
    ISNULL(@GENDER,'') AS GENDER,      
    @REST_YN AS REST_YN,      
    ISNULL(@BIRTH,'') AS BIRTH,      
    @COM_NM AS COM_NM,      
    @CONFIRM_YN AS CONFIRM_YN,      
    --@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,      
    @SITE_CD AS SITE_CD,      
    @MEMBER_CD AS MEMBER_CD,      
    @TRUE_YN AS TRUE_YN,      
    @PWD_CHANGE_YN AS PWD_CHANGE_YN,      
    @DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임      
    @USERID AS USERID,      
    @BAD_YN AS BAD_YN,      
    ISNULL(@DI,'') AS DI,      
    ISNULL(@ISADULT,'') AS ISADULT,      
    '' AS SNSTYPE,      
    @JOIN_DT AS JOIN_DT,      
    ISNULL(@REALHP_YN,'') as REALHP_YN,      
    @PWD AS PWD,      
    DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,      
    @USER_NM AS USERNAME,      
    '' AS SECTION_CD,      
    ISNULL(@LAND_CLASS_CD,'') AS LAND_CLASS_CD,      
    @REST_DT AS REST_DT,      
          -- 2020-10-27 회원가입대행 컬럼 추가      
    @AGENCY_YN AS AGENCY_YN,      
    @LAST_SIGNUP_YN AS LAST_SIGNUP_YN,   
    @REGISTER_NO AS REGISTER_NO,    
    -- 2021-05-24 회원가입대행 컬럼 추가  
    @MEMBER_TYPE AS MEMBER_TYPE,    
    @REG_NUMBER  AS REG_NUMBER    
      
    UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()      
      WHERE CUID = @CUID     -- 마지막 로그인 시간       
            
    INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES      
           (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기      
                 
   RETURN(0) -- 정상 정상      
  END 
GO
/****** Object:  StoredProcedure [dbo].[_SP_MASTER_SELECT_20190429]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 개인/비즈니스 회원 정보
 *  작   성   자 : JMG
 *  작   성   일 : 2016-08-17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 EXEC SP_MASTER_SELECT '13310360'
 exec sp_master_select 13825469 exec mwmember.dbo.sp_master_select 13818837
exec mwmember.dbo.sp_master_select 13822885

 *************************************************************************************/

CREATE PROCEDURE [dbo].[_SP_MASTER_SELECT_20190429]
 @CUID  int

AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON;
	DECLARE @MEMBER_CD CHAR
	DECLARE @CNT INT
	
	SET @MEMBER_CD = ''
	SET @CNT = 0
	
	SELECT @MEMBER_CD = MEMBER_CD
	FROM CST_MASTER WITH (NOLOCK)
	WHERE CUID = @CUID AND OUT_YN = 'N'
	   
     create table #tb (cuid int null, s varchar(100) null, m varchar(100) null, t varchar(100) null, AGREE_DT datetime)
     insert into #tb
     SELECT CUID
     ,MAX(CASE WHEN MEDIA_CD = 'S' THEN SECTION_CD ELSE '' END )  AS 'S'
     ,MAX(CASE WHEN MEDIA_CD = 'M' THEN SECTION_CD ELSE '' END )  AS 'M'
     ,MAX(CASE WHEN MEDIA_CD = 'T' THEN SECTION_CD ELSE '' END )  AS 'T'
	 ,MAX(AGREE_DT) AGREE_DT
     FROM (
	    SELECT DISTINCT T.CUID,T.MEDIA_CD,
		   STUFF(( SELECT ',' + P.SECTION_CD
		   FROM CST_MSG_SECTION P WITH(NOLOCK)
		   WHERE (P.CUID = T.CUID AND P.MEDIA_CD = T.MEDIA_CD)
		   FOR XML PATH ('')),1,1,'') AS SECTION_CD
		   , AGREE_DT
	    FROM CST_MSG_SECTION T WITH(NOLOCK)
	    JOIN CST_MASTER CM WITH(NOLOCK) ON CM.CUID = T.CUID
	    WHERE CM.CUID = @CUID
     ) S 
     GROUP BY CUID 

	IF @MEMBER_CD = '1'
	BEGIN
	    SELECT CM.CUID, COM_ID, USERID, MEMBER_CD, USER_NM, HPHONE, EMAIL, GENDER, BIRTH, DI, CI, COM_ID
	    , ISNULL(S,'') SMS, ISNULL(M,'') MAIL, ISNULL(T,'') TM
	    , SNS_TYPE, SNS_ID
	    , case when CM.REALHP_YN ='Y' then 'Y'
		  when (SELECT COUNT(*) FROM CST_MASTER AS B WITH (NOLOCK) WHERE B.HPHONE = CM.HPHONE AND B.MEMBER_CD='1')  = 1  then 'Y' else 'N' end as REALHP_YN, '' MEMBER_TYPE
		, t.AGREE_DT
    , NULL AS SECTION_CD_ETC
    , M.AGREE_DT AS MK_AGREE_DT
    , ISNULL(M.AGREEF,0) AS MK_AGREEF
	, CM.SITE_CD
	    FROM CST_MASTER CM WITH (NOLOCK)
	    LEFT OUTER JOIN #tb t with(nolock) on t.cuid = CM.CUID
      LEFT OUTER JOIN CST_MARKETING_AGREEF_TB AS M ON M.CUID = CM.CUID
	    WHERE CM.CUID = @CUID AND CM.OUT_YN = 'N' AND CM.MEMBER_CD = '1'
	    
	END
	
	IF @MEMBER_CD = '2'
	BEGIN
	    SELECT CM.CUID, CM.COM_ID, CM.USERID, MEMBER_CD, USER_NM, HPHONE, EMAIL, GENDER, BIRTH, DI, CI, CM.COM_ID
	    , CC.REGISTER_NO, CC.MAIN_PHONE, CC.PHONE, CC.COM_NM, CC.CEO_NM, CC.FAX, CC.HOMEPAGE, CC.LAT, CC.LNG, CC.CITY, CC.GU, CC.DONG, CC.ADDR1, CC.ADDR2, CC.LAW_DONGNO, CC.MAN_NO, CC.ROAD_ADDR_DETAIL
	    , ISNULL(CL.REG_NUMBER,'') REG_NUMBER, ISNULL(CA.MANAGER_NM,'') MANAGER_NM, ISNULL(CA.MANAGER_NUMBER,'') MANAGER_NUMBER, CM.SNS_TYPE, CM.SNS_ID
	    , ISNULL(S,'') SMS, ISNULL(M,'') MAIL, ISNULL(T,'') TM
	    , '' as REALHP_YN, CC.MEMBER_TYPE
		, t.AGREE_DT
    , CC.SECTION_CD_ETC
    , M.AGREE_DT AS MK_AGREE_DT
    , ISNULL(M.AGREEF,0) AS MK_AGREEF
	, CM.SITE_CD
	    FROM CST_MASTER CM WITH(NOLOCK)
	    LEFT OUTER JOIN CST_COMPANY CC WITH(NOLOCK) ON CC.COM_ID = CM.COM_ID
	    LEFT OUTER JOIN #tb t with(nolock) on t.cuid = CM.CUID
	    LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON CL.COM_ID = CM.COM_ID
	    LEFT OUTER JOIN CST_COMPANY_AUTO CA WITH(NOLOCK) ON CA.COM_ID = CM.COM_ID	    
      LEFT OUTER JOIN CST_MARKETING_AGREEF_TB AS M ON M.CUID = CM.CUID
	    WHERE CM.CUID = @CUID AND CM.OUT_YN = 'N' AND CM.MEMBER_CD = '2'
	END	
GO
/****** Object:  StoredProcedure [dbo].[_SP_PWD_CHANGE_20211005]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_SP_PWD_CHANGE_20211005]
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 변경
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 변경 및 180일 뒤에 수정일 변경 일자 업데이트
 * RETURN(0) 성공
 * RETURN(500)  실패
 * DECLARE @RET INT
 * EXEC @RET=SP_PWD_CHANGE 'nadu81@naver.com', 'a', 'aa', 11217636
 * SELECT @RET
 *************************************************************************************/
@USERID varchar(50), 
@NEWPWD VARCHAR(20),
@OLDPWD VARCHAR(20),
@CUID INT
AS
	SET NOCOUNT ON;
	DECLARE @MD5PWD_NEW varbinary(128), @MD5PWD_OLD varbinary(128), @ID_COUNT bit
		
		SET @MD5PWD_OLD = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@OLDPWD)))  -- 소문자 변경 및 MD5로 변경
		SET @MD5PWD_NEW = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@NEWPWD)))  -- 소문자 변경 및 MD5로 변경

		SET @ID_COUNT = 0
		SELECT @ID_COUNT = COUNT(CUID) FROM CST_MASTER WITH(NOLOCK) 
			WHERE pwd_sha2 = @MD5PWD_OLD -- 관리자 체크	
				  AND CUID = @CUID

		--PRINT(@ID_COUNT)
													
		IF @ID_COUNT = 1
		BEGIN
			UPDATE CST_MASTER SET pwd_sha2 = @MD5PWD_NEW , PWD_MOD_DT = getdate(), 
								  PWD_NEXT_ALARM_DT = getdate() + 180,
								  login_pwd_enc = NULL
								  WHERE CUID = @CUID  -- 비밀 번호 업데이트 및 비번 수정 날짜 부동산 서브 비번 NULL 처리
			-- 써브 비번 변경 호출
			exec [221.143.23.211,8019].rserve.dbo.SV_PWD_SYNC @CUID, @NEWPWD
			
				/*2016-09-06 써브 체크용 임시 추후 삭제~!!*/			  
			--	INSERT CST_MASTER_LOGIN_SUCCESS (cuid,pwd,GBN ) 
			--	SELECT @CUID,@NEWPWD, 2 
				
			
			INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, PWD_CHANGE_YN) VALUES 
										   (@CUID,@USERID, getdate(), 'Y')  -- 이력을 남기자
			RETURN(0)
		END ELSE
		BEGIN
			RETURN(500)
		END
		
		

GO
/****** Object:  StoredProcedure [dbo].[_SP_REST_OUT_20200512]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_SP_REST_OUT_20200512]
/*************************************************************************************
 *  단위 업무 명 : 회원 탈퇴 상태 만들기 - 휴면 상태에서 탈퇴로
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
AS 
	SET NOCOUNT ON;
	DECLARE @DOTIME VARCHAR(10), @LOG_ID INT, @ROWS INT
	SET @DOTIME = CONVERT(VARCHAR(10), GETDATE() - 365, 111)


			INSERT INTO CST_BATCH_LOG 
			            (BATCH_NM, BATCH_DETAIL, CONDITION) 
					 VALUES ('CST_REST_OUT', 'OUT', 'ADD_DT < '+CAST(@DOTIME AS VARCHAR) ) ;
			SET @LOG_ID = @@IDENTITY;

			INSERT INTO CST_OUT_MASTER 
			              (
							 CUID
							,OUT_APPLY_DT
							,OUT_PROC_DT
							,OUT_CAUSE
						  )  -- 탈퇴 이력을 남긴다.
				SELECT 
							 CUID
							,GETDATE() AS OUT_APPLY_DT
							,GETDATE() AS OUT_PROC_DT
							,'장기미이용 고객 자동 탈퇴(로그인한지 2년)' AS OUT_CAUSE
				  FROM CST_REST_MASTER WITH(NOLOCK) 
				 WHERE ADD_DT < @DOTIME
				   AND RESTORATION_DT IS NULL -- 복구 하지 않아서 날짜가 없다.

			SET @ROWS = @@ROWCOUNT;
			UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;	

		
			INSERT INTO CST_BATCH_LOG 
			            (BATCH_NM, BATCH_DETAIL, CONDITION) 
					 VALUES ('CST_MASTER', 'OUT', 'OUT_YN = Y , OUT_DT = '+ CAST(GETDATE() AS VARCHAR));
			SET @LOG_ID = @@IDENTITY;
			
				UPDATE CST_MASTER 
				   SET OUT_YN = 'Y' , OUT_DT = GETDATE(), MOD_DT = GETDATE() 
				  FROM   -- 마스터 테이블에서 탈퇴 업데이트
							 CST_REST_MASTER RM 
					LEFT OUTER JOIN CST_MASTER M ON RM.CUID = M.CUID 
				 WHERE RM.ADD_DT < @DOTIME 
				   AND RM.RESTORATION_DT IS NULL
				   
			SET @ROWS = @@ROWCOUNT;
			UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;


			INSERT INTO CST_BATCH_LOG 
			            (BATCH_NM, BATCH_DETAIL, CONDITION) 
					 VALUES ('CST_REST_OUT', 'OUT', 'ADD_DT < '+CAST(@DOTIME AS VARCHAR) +' AND RESTORATION_DT IS NULL');
			SET @LOG_ID = @@IDENTITY;
			
			DELETE FROM CST_REST_MASTER 
			 WHERE ADD_DT < @DOTIME  AND RESTORATION_DT IS NULL  -- 휴면 테이블에서 삭제

			SET @ROWS = @@ROWCOUNT;
			UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;

GO
/****** Object:  StoredProcedure [dbo].[BAT_INTEGRATION_MEMBER_OUT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 통합 처리한 회원 -> 탈퇴 회원 처리(일주일 이전 데이터)
 *  작   성   자 : 최병찬
 *  작   성   일 : 2016-10-14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
CREATE PROC [dbo].[BAT_INTEGRATION_MEMBER_OUT_PROC]

AS

SELECT DISTINCT A.CUID 
  INTO #AAA
  FROM CST_MASTER AS A
  JOIN CST_ADMISSION AS B ON A.CUID=B.S_CUID
 WHERE A.STATUS_CD='D'
   AND A.OUT_YN='N'
   AND B.APP_DT> CONVERT(VARCHAR(10), DATEADD(DAY, -7, GETDATE()), 111)
   AND B.APP_DT< CONVERT(VARCHAR(10), DATEADD(DAY, -6, GETDATE()), 111)


DELETE CST_REST_MASTER
  FROM CST_REST_MASTER AS A
  JOIN #AAA AS B ON A.CUID=B.CUID 

--탈퇴 테이블 정보 입력
INSERT INTO CST_OUT_MASTER 
       (
				 CUID
				,OUT_APPLY_DT
				,OUT_PROC_DT
				,OUT_CAUSE
			  )  -- 탈퇴 이력을 남긴다.
SELECT
				 A.CUID 
				,GETDATE() AS OUT_APPLY_DT
				,GETDATE() AS OUT_PROC_DT
				,'회원 통합 미이용 ID 삭제 처리' AS OUT_CAUSE
  FROM #AAA AS A


UPDATE CST_MASTER 
  SET USER_NM = ''
    , HPHONE = ''
    , EMAIL = ''
    , BIRTH =  REPLACE(REPLACE(SUBSTRING(BIRTH,1,4),'-',''),' ','')
    , DI = '' 
    , CI = ''
    , MOD_DT = GETDATE()
    , OUT_YN = 'Y'
    , OUT_DT = GETDATE()
 FROM CST_MASTER AS A
 JOIN #AAA AS B ON A.CUID=B.CUID
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_LONGTERM_UNUSED_SENDMAIL_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 통합회원 > 장기미이용 회원 메일 발송(2년 되기 1달 전)
' 작    성    자	: 최 병 찬
' 작    성    일	: 2016/8/26
' 수    정    자	: 최병찬
' 수    정    일	: 2015/08/06
' 설          명	: 2년 동안 로그인 하지 않은 회원 1달전에 메일 발송(2년이 되는날 탈퇴 처리해야함)
'					  1달전 COMMON DB의 MM_LONGTERM_UNUSED_TB 테이블에 INSERT후 메일 발송
' 탈퇴 기간 변경 기존 3년에서 2년으로 변경
' 주  의  사  항	: 
' 사  용  소  스 	: 스케줄 작업 
' 예          제	: 
******************************************************************************/
CREATE PROC [dbo].[BAT_MM_LONGTERM_UNUSED_SENDMAIL_PROC]

AS

SET NOCOUNT ON

INSERT FINDDB2.COMMON.DBO.MM_LONGTERM_UNUSED_TB
     ( USERID, USERNAME, EMAIL, JOIN_DT, LOGIN_DT, REST_DT, OUT_DT, CUID)
SELECT 
       A.USERID
     , A.USER_NM
     , A.EMAIL
     , B.JOIN_DT
     , ISNULL(B.LAST_LOGIN_DT, B.JOIN_DT) AS LOGIN_DT
     , ISNULL(A.ADD_DT, DATEADD(YEAR, 1, CONVERT(VARCHAR(10), ISNULL(LAST_LOGIN_DT,JOIN_DT), 111)))  AS REST_DT
     , DATEADD(YEAR, 2, ISNULL(B.LAST_LOGIN_DT, B.JOIN_DT)) AS OUT_DT
     , A.CUID
  FROM CST_REST_MASTER AS A WITH (NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE B.OUT_YN='N'
   AND B.REST_YN='Y'
   AND DATEADD(YEAR, 2, CONVERT(VARCHAR(10), ISNULL(LAST_LOGIN_DT,JOIN_DT), 111)) = DATEADD(MONTH, 1, CONVERT(VARCHAR(10), GETDATE(), 111))
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_MARKETING_EVENT_MEMBER_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 마케팅/이벤트 수신동의 이메일 발송(2년에 한번)
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016-11-15
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  예        제 :  EXEC BAT_MM_MARKETING_EVENT_MEMBER_PROC
 *************************************************************************************/
CREATE PROC [dbo].[BAT_MM_MARKETING_EVENT_MEMBER_PROC]
AS

DELETE FROM FINDDB2.COMMON.DBO.MM_MAEKETING_EVENT_MEMBER_TB

INSERT FINDDB2.COMMON.DBO.MM_MAEKETING_EVENT_MEMBER_TB
     ( CUID, USERID, EMAIL, USER_NM, AGREE_DT, FA_SMS, FA_TM, FA_EMAIL, SERVE_SMS, SERVE_TM, SERVE_MAIL )
SELECT 
       A.CUID
     , A.USERID
     , A.EMAIL
     , A.USER_NM
     , REPLACE(CONVERT(VARCHAR(20),AGREE_DT, 120),'-','.') AS AGREE_DT
     , CASE
            WHEN FA_SMS='SMS' THEN 'Y'
            ELSE 'N'
       END AS FA_SMS     
     , CASE 
            WHEN FA_TM='TM' THEN 'Y'
            ELSE 'N'
       END AS FA_TM
     , CASE WHEN FA_JOB + FA_LAND + FA_AUTO + FA_GOODS <> '' THEN 'Y' ELSE 'N' END FA_EMAIL
     , CASE
            WHEN SERVE_SMS='SMS' THEN 'Y'
            ELSE 'N'
       END AS SERVE_SMS
     , CASE
            WHEN SERVE_TM='TM' THEN 'Y'
            ELSE 'N'
       END AS SERVE_TM
     , CASE
            WHEN SERVE_MAIL='이메일' THEN 'Y'
            ELSE 'N'
       END AS SERVE_MAIL
  FROM (
    SELECT 
           A.CUID
         , A.USERID
         , A.EMAIL
         , A.USER_NM
         , MAX(B.AGREE_DT) AS AGREE_DT
         , MAX(FA_SMS) AS FA_SMS
         , MAX(FA_TM) AS FA_TM
         , MAX(FA_JOB) AS FA_JOB
         , MAX(FA_LAND) AS FA_LAND
         , MAX(FA_AUTO) AS FA_AUTO
         , MAX(FA_GOODS) AS FA_GOODS

         , MAX(SERVE_SMS) AS SERVE_SMS
         , MAX(SERVE_TM) AS SERVE_TM
         , MAX(SERVE_MAIL) AS SERVE_MAIL

      FROM (
        SELECT A.CUID
             , A.USERID
             , A.EMAIL
             , ISNULL(A.USER_NM,'') AS USER_NM
             , CASE
                    WHEN B.MEDIA_CD='S' AND B.SECTION_CD='S101' THEN 'SMS'
                    ELSE ''
               END AS FA_SMS
             , CASE
                    WHEN B.MEDIA_CD='T' AND B.SECTION_CD='S101' THEN 'TM'
                    ELSE ''
               END AS FA_TM
             , CASE
                    WHEN B.MEDIA_CD='M' AND B.SECTION_CD='S102' THEN '구인구직'
                    ELSE ''
               END AS FA_JOB
             , CASE
                    WHEN B.MEDIA_CD='M' AND B.SECTION_CD='S103' THEN '부동산'
                    ELSE ''
               END AS FA_LAND
             , CASE
                    WHEN B.MEDIA_CD='M' AND B.SECTION_CD='S104' THEN '자동차'
                    ELSE ''
               END AS FA_AUTO
             , CASE
                    WHEN B.MEDIA_CD='M' AND B.SECTION_CD='S105' THEN '상품&서비스'
                    ELSE ''
               END AS FA_GOODS
             , CASE
                    WHEN B.MEDIA_CD='S' AND B.SECTION_CD='H001' THEN 'SMS'
                    ELSE ''
               END AS SERVE_SMS
             , CASE
                    WHEN B.MEDIA_CD='T' AND B.SECTION_CD='H001' THEN 'TM'
                    ELSE ''
               END AS SERVE_TM
             , CASE
                    WHEN B.MEDIA_CD='M' AND B.SECTION_CD='H001' THEN '이메일'
                    ELSE ''
               END AS SERVE_MAIL
          FROM CST_MASTER AS A WITH (NOLOCK)
          JOIN CST_MSG_SECTION AS B WITH (NOLOCK) ON A.CUID=B.CUID
         WHERE A.REST_YN='N'
           AND A.OUT_YN='N'
    ) AS A    
      JOIN CST_MSG_SECTION AS B WITH (NOLOCK) ON A.CUID=B.CUID   
     GROUP BY A.CUID, A.USERID, A.EMAIL, A.USER_NM
) AS A
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_MEMBER_STAT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원통계 > 일별누적(신규,탈퇴,누적)
                  -- 확인결과 (2021-07-12)
                  -- [신문] > [온라인사업실 대시보드] > [데이터 관리] > 회원(벼룩시장)
 *  작   성   자 : 여운영
 *  작   성   일 : 2015/09/18
 *  수   정   자 : 배진용
 *  수   정   일 : 2021-01-04(회원가입대행 추가)
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC BAT_MM_MEMBER_STAT_PROC
 SELECT * FROM [MEMBER].[dbo].[MM_STAT_MEMBER_TB]

 BAT_MM_MEMBER_STAT_PROC '2020-06-27'
 *************************************************************************************/
CREATE PROC [dbo].[BAT_MM_MEMBER_STAT_PROC]

  @PRE_DT DATETIME = NULL

AS 
  
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


	--DECLARE @PRE_DT DATETIME	/* 전날 일자 */
  IF @PRE_DT IS NULL
	  SET @PRE_DT = CONVERT(CHAR(10),DATEADD(D,-1,GETDATE()),120)

/* #### 탈퇴 대상 #### */
	SELECT CUID
	  INTO #TEMP_OUT_CUID
	  FROM MWMEMBER.DBO.CST_OUT_MASTER WITH(NOLOCK)
	 WHERE OUT_APPLY_DT > @PRE_DT --AND OUT_PROC_DT IS NULL
	 

/* #### 탈퇴회원의 개인/기업 구분 #### */
	SELECT A.CUID
       , A.MEMBER_CD 
    INTO #TEMP_OUT_CUID_TG2
	  FROM ( SELECT CUID
                , MEMBER_CD 
             FROM MWMEMBER.DBO.CST_MASTER WITH(NOLOCK) 
            WHERE CUID IN (SELECT CUID FROM #TEMP_OUT_CUID)
--		UNION
--		SELECT CUID, MEMBER_CD FROM MWMEMBER.DBO.CST_REST_MASTER WHERE CUID IN (SELECT CUID FROM #TEMP_OUT_CUID)
	) AS A
	JOIN #TEMP_OUT_CUID B ON A.CUID = B.CUID

	--SELECT * FROM #TEMP_OUT_CUID_TG2

/* #### 신규가입 #### */
	-- 2021-01-04 회원가입대행 AGENCY_YN 컬럼 추가
	SELECT * 
    INTO #NEW_JOIN 
	  FROM ( SELECT DISTINCT CONVERT(VARCHAR(10), JOIN_DT, 120) AS DT
                , MEMBER_CD
                , COUNT(MEMBER_CD) '신규가입'
                , ISNULL(AGENCY_YN,'N') as AGENCY_YN
		         FROM	MWMEMBER.DBO.CST_MASTER AS A WITH(NOLOCK)		
				--LEFT JOIN MM_JOIN_INFO_TB AS B ON A.CUID=B.CUID 
		 WHERE --(SECTION_CD<>'S111' AND SECTION_CD<>'S112' AND SECTION_CD<>'S117' AND SECTION_CD<>'S118') AND
		    OUT_YN='N' 
		   AND (JOIN_DT>=CONVERT(VARCHAR(10), GETDATE()-1, 120)
		   AND JOIN_DT<CONVERT(VARCHAR(10), GETDATE(), 120))
		GROUP BY CONVERT(VARCHAR(10), JOIN_DT, 120), MEMBER_CD,ISNULL(AGENCY_YN,'N')
		--ORDER BY CONVERT(VARCHAR(10), JOIN_DT, 120)
	) Y

/*
	SELECT DISTINCT CONVERT(VARCHAR(10), JOIN_DT, 120) AS DT, MEMBER_CD, COUNT(MEMBER_CD) '신규가입' INTO #NEW_JOIN
	  FROM	DBO.MM_MEMBER_TB AS A WITH(NOLOCK)		
			LEFT JOIN MM_JOIN_INFO_TB AS B ON A.CUID=B.CUID 
	 WHERE (SECTION_CD<>'S111' AND SECTION_CD<>'S112' AND SECTION_CD<>'S117' AND SECTION_CD<>'S118') 
	   AND OUT_APPLY_YN='N' 
	   AND (JOIN_DT>=CONVERT(VARCHAR(10), GETDATE()-1, 120)
	   AND JOIN_DT<CONVERT(VARCHAR(10), GETDATE(), 120))
	GROUP BY CONVERT(VARCHAR(10), JOIN_DT, 120), MEMBER_CD
	ORDER BY CONVERT(VARCHAR(10), JOIN_DT, 120)
*/

/* #### 탈퇴 #### */
	SELECT CONVERT(VARCHAR(10),GETDATE()-1, 120) AS DT
       , B.MEMBER_CD, COUNT(*) AS '탈퇴' 
    INTO #OUT
	  FROM #TEMP_OUT_CUID_TG2 B
GROUP BY B.MEMBER_CD


/* #### 회원누적(휴면제외) #### */
	-- 2021-01-04 회원가입대행 AGENCY_YN 컬럼 추가
	SELECT * 
    INTO #TOTAL_MEM 
	  FROM ( SELECT CONVERT(VARCHAR(10)
		            , GETDATE()-1, 120) AS DT
			          , MEMBER_CD
			          , count(*) AS '전체회원수'
			          , ISNULL(AGENCY_YN,'N') as AGENCY_YN
		         FROM MWMEMBER.DBO.CST_MASTER AS A WITH(NOLOCK)		
		        where A.OUT_YN='N' 
		          AND A.REST_YN='N'
		          and A.JOIN_DT < CONVERT(VARCHAR(10), GETDATE()-1, 120)
	       GROUP BY A.MEMBER_CD, A.AGENCY_YN

        
/*
		UNION ALL	

		SELECT X.DT,
		CASE X.SECTION_CD WHEN 'S102' THEN '8' WHEN 'S103' THEN '9' ELSE '0' END AS MEMBER_CD
		,X.[전체회원수] FROM (
			SELECT DISTINCT C.SECTION_CD, CONVERT(VARCHAR(10), GETDATE()-1, 120) AS DT, COUNT(C.SECTION_CD) '전체회원수' 	
			FROM	DBO.MM_MEMBER_TB AS A WITH(NOLOCK)		
					LEFT JOIN MM_JOIN_INFO_TB AS B ON A.CUID=B.CUID 
					LEFT JOIN MM_COMPANY_TB AS C ON A.CUID=C.CUID
			where (B.SECTION_CD<>'S111' and B.SECTION_CD<>'S112' and B.SECTION_CD<>'S117' and B.SECTION_CD<>'S118') 
			and A.OUT_APPLY_YN='N' 
			AND A.REST_YN='N'
			and A.JOIN_DT< CONVERT(VARCHAR(10), GETDATE()-1, 120)
			AND C.SECTION_CD IN ('S102','S103')
			GROUP BY C.SECTION_CD
		) X
		
*/
	) Y
/*
	SELECT CONVERT(VARCHAR(10), GETDATE()-1, 120) AS DT, MEMBER_CD, count(*) AS '전체회원수' INTO #TOTAL_MEM
	FROM	DBO.MM_MEMBER_TB AS A WITH(NOLOCK)		
			LEFT JOIN MM_JOIN_INFO_TB AS B ON A.CUID=B.CUID 
	where (SECTION_CD<>'S111' and SECTION_CD<>'S112' and SECTION_CD<>'S117' and SECTION_CD<>'S118') 
	and OUT_APPLY_YN='N' 
	AND REST_YN='N'
	and JOIN_DT< CONVERT(VARCHAR(10), GETDATE()-1, 120)
	GROUP BY MEMBER_CD
*/

/* #### 통계테이블 추가 #### */
	DELETE FROM MM_STAT_MEMBER_TB WHERE REG_DT=(CONVERT([varchar](10),dateadd(day,(-1),getdate()),(120)))
	-- 2021-01-04 회원가입대행 컬럼 추가 및 SELECT 조건추가 'AGENCY_YN'
	INSERT INTO [MM_STAT_MEMBER_TB](
		 REG_DT
		,NEW_JOIN_COMPANY
		,NEW_AGENCY_JOIN_COMPANY	-- 회원가입대행 추가
		,NEW_JOIN_PERSON
		,OUT_COMPANY
		,OUT_PERSON
		,TOTAL_MEM_COMPANY
		,TOTAL_AGENCY_JOIN_COMPANY	-- 회원가입대행 추가
		,TOTAL_MEM_PERSON
		)
	SELECT   
   CONVERT(VARCHAR(10), GETDATE()-1, 120) AS REG_DT
	,isNULL((SELECT SUM(신규가입) FROM #NEW_JOIN WHERE MEMBER_CD=2  AND AGENCY_YN = 'N'),0) -- 회원가입대행 조건 수정
               AS NEW_JOIN_COMPANY
	,isNULL((SELECT SUM(신규가입) FROM #NEW_JOIN WHERE MEMBER_CD=2  AND AGENCY_YN = 'Y'),0) -- 회원가입대행 추가
               AS NEW_AGENCY_JOIN_COMPANY
  ,isNULL((SELECT SUM(신규가입) FROM #NEW_JOIN WHERE MEMBER_CD=1),0)
               AS NEW_JOIN_PERSON   
	,isNULL((SELECT SUM(탈퇴) FROM #OUT WHERE MEMBER_CD=2),0)
               AS OUT_COMPANY
	,isNULL((SELECT SUM(탈퇴) FROM #OUT WHERE MEMBER_CD=1),0)
               AS OUT_PERSON
  ,isNULL((SELECT SUM(전체회원수) FROM #TOTAL_MEM WHERE MEMBER_CD=2 AND AGENCY_YN = 'N' ),0)	-- 회원가입대행 조건 수정
               AS TOTAL_MEM_COMPANY
	,isNULL((SELECT SUM(전체회원수) FROM #TOTAL_MEM WHERE MEMBER_CD=2 AND AGENCY_YN = 'Y'),0) -- 회원가입대행 추가
               AS TOTAL_AGENCY_JOIN_COMPANY 
  ,isNULL((SELECT SUM(전체회원수) FROM #TOTAL_MEM WHERE MEMBER_CD=1),0)
               AS TOTAL_MEM_PERSON
	
	--,isNULL((SELECT [신규가입] FROM #NEW_JOIN WHERE MEMBER_CD=8),0),isNULL((SELECT [신규가입] FROM #NEW_JOIN WHERE MEMBER_CD=9),0)
	--,isNULL((SELECT [전체회원수] FROM #TOTAL_MEM WHERE MEMBER_CD=8),0),isNULL((SELECT [전체회원수] FROM #TOTAL_MEM WHERE MEMBER_CD=9),0)
	
	EXEC FINDDB1.[STATS].DBO.BAT_DASHBOARD_DATA_MEMBER_STAT_INS_PROC @PRE_DT

/* #### 임시테이블 삭제 #### */
	DROP TABLE #TEMP_OUT_CUID
	DROP TABLE #TEMP_OUT_CUID_TG2
	
	DROP TABLE #NEW_JOIN
	DROP TABLE #OUT
	DROP TABLE #TOTAL_MEM

END
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_OUT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 탈퇴 처리(전날 탈퇴 신청 회원 정보 삭제 및 탈퇴 처리)
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016-08-28
 *  설        명 : 
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
                     SP_REST_OUT 프로시저에서 휴면회원 처리
                     사용자가 신청한 탈퇴 회원만 처리한다
 *  사 용  소 스 :

 *************************************************************************************/
CREATE PROCEDURE [dbo].[BAT_MM_OUT_PROC]

AS
-- 전날 일자
DECLARE @PRE_DT DATETIME
DECLARE @RETURN INT
DECLARE @ROWS INT
DECLARE @LOG_ID INT

SET @PRE_DT = CONVERT(CHAR(10),DATEADD(D,-1,GETDATE()),120)
SET @RETURN = 0

BEGIN TRANSACTION
--------------------------------------------
-- 1. 전날 탈퇴 신청 아이디 가져오기
--------------------------------------------
SELECT CUID
  INTO #TEMP_OUT_CUID
  FROM CST_OUT_MASTER WITH(NOLOCK)
 WHERE OUT_APPLY_DT > @PRE_DT AND OUT_PROC_DT IS NULL

IF (@@ERROR <> 0) 
BEGIN
	ROLLBACK TRANSACTION;
	SET	@RETURN = 1;
END

INSERT INTO CST_BATCH_LOG 
            (BATCH_NM, BATCH_DETAIL, CONDITION) 
		 VALUES ('BAT_MM_OUT_PROC', 'OUT', '회원 신청 탈퇴' ) ;
SET @LOG_ID = @@IDENTITY;

IF (@@ERROR <> 0) 
BEGIN
	ROLLBACK TRANSACTION;
	SET	@RETURN = 1;
END
--------------------------------------------
-- 2. 회원 정보 업데이트
--------------------------------------------
UPDATE CST_MASTER 
  SET USER_NM = ''
    , HPHONE = ''
    , EMAIL = ''
    , BIRTH =  REPLACE(REPLACE(SUBSTRING(BIRTH,1,4),'-',''),' ','')
    , DI = '' 
    , CI = ''
    , MOD_DT = GETDATE()
    , PWD = ''
 FROM #TEMP_OUT_CUID AS A
 JOIN CST_MASTER AS B ON A.CUID = B.CUID

SET @ROWS = @@ROWCOUNT;

IF (@@ERROR <> 0) 
BEGIN
	ROLLBACK TRANSACTION;
	SET	@RETURN = 1;
END

UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;	

-- 탈퇴 테이블
UPDATE	A
   SET	A.OUT_PROC_DT = GETDATE()
  FROM	CST_OUT_MASTER A
	JOIN #TEMP_OUT_CUID B ON A.CUID = B.CUID

IF (@@ERROR <> 0) 
BEGIN
	ROLLBACK TRANSACTION;
	SET	@RETURN = 1;
END		

	
COMMIT TRANSACTION

SELECT @RETURN;
GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_REST_CONFIRM_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 휴면회원 처리된 회원에게 메일 발송하기 위해 COMMON DB테이블로 이동
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016-08-28
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  예        제 :  
 *************************************************************************************/
CREATE PROCEDURE [dbo].[BAT_MM_REST_CONFIRM_PROC]
	 
AS 
SET NOCOUNT ON

DELETE FROM FINDDB2.COMMON.DBO.MM_REST_CONFIRM_TB

INSERT FINDDB2.COMMON.DBO.MM_REST_CONFIRM_TB	 
     ( USERID, MEMBER_CD, USERNAME, EMAIL, JOIN_DT, LOGIN_DT, INSERT_DT, CUID)
SELECT B.USERID, B.MEMBER_CD, A.USER_NM, A.EMAIL, B.JOIN_DT, B.LAST_LOGIN_DT, A.ADD_DT, A.CUID
  FROM CST_REST_MASTER AS A WITH(NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE CONVERT(VARCHAR(10), A.ADD_DT, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)


GO
/****** Object:  StoredProcedure [dbo].[BAT_MM_SENDMAIL_REST_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 공통회원 > 휴면예정회원 메일 발송
' 작    성    자	: 최 병찬
' 작    성    일	: 2016/08/28
' 수    정    자	:
' 수    정    일	: 
' 설          명	: 1년 동안 로그인 안한 회원 30일전 메일발송
'					  30일전 COMMON DB의 MM_SENDMAIL_REST_TB 테이블에 INSERT후 메일 발송
' 주  의  사  항	: 
' 사  용  소  스 	: 스케줄 작업 
' 예          제	: 
******************************************************************************/
CREATE PROCEDURE [dbo].[BAT_MM_SENDMAIL_REST_PROC]
AS 

SET NOCOUNT ON
BEGIN 

------------------------------------------------------------------------------
-- 1년 동안 로그인 안한 회원 30일전 메일 발송
------------------------------------------------------------------------------


execute FINDDB1.PAPER_NEW.DBO.BAT_VERSION_M_2MONTH_PHONE_LIST_SAVE_PROC --최근 2개월 등록대행 공고 전화번호 생성


SELECT PHONE
INTO #TMP_PHONE
FROM FINDDB1.LOGDB.DBO.TEMP_VERSION_M_2MONTH_PHONE_LIST_TB


DELETE FROM FINDDB2.COMMON.DBO.MM_SENDMAIL_REST_TB


INSERT FINDDB2.COMMON.DBO.MM_SENDMAIL_REST_TB
      (
       USERID
	    ,MEMBER_CD	
		,USERNAME
	    ,EMAIL
	    ,JOIN_DT
	    ,LOGIN_DT
	    ,INSERT_DT
	    ,CUID
	    )
SELECT 
       A.USERID
      ,A.MEMBER_CD
      ,A.USER_NM
      ,A.EMAIL
      ,A.JOIN_DT
      ,ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT) AS LAST_LOGIN_DT
      ,DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) AS INSERT_DT
      ,A.CUID
  FROM DBO.CST_MASTER AS A WITH(NOLOCK)
 WHERE A.REST_YN = 'N'		--휴면회원 제외
   AND A.BAD_YN = 'N' 		--불량회원 제외
   AND A.OUT_YN = 'N'   --회원탈퇴 제외
   AND (
        (A.LAST_LOGIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
        OR 
        (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
       )

	AND HPHONE NOT IN(
		SELECT PHONE FROM #TMP_PHONE
	)

END


GO
/****** Object:  StoredProcedure [dbo].[BAT_MW_ECOMM_VESTED_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 :
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2016/09/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 매일 "(8시 5분) 이컴 기득권데이터 취합"을 통해 실행
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.BAT_MW_ECOMM_VESTED_PROC
 *************************************************************************************/


CREATE PROC [dbo].[BAT_MW_ECOMM_VESTED_PROC]

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  -- 파인드올 전섹션 결제데이터 취합   (부동산써브는 SERVE_ECOMM_PAYDATE에 별도로 취합 오전 7시)
  TRUNCATE TABLE FINDALL_ECOMM_PAYDATE    

  INSERT INTO FINDALL_ECOMM_PAYDATE
    (CUID, MAX_PAYDATE)
  SELECT CUID
        ,MAX(CONVERT(DATETIME,LEFT(PAY_REG_DT,8),120)) AS MAX_PAYDATE
    FROM FINDDB2.FINDCOMMON.dbo.SM_SALE_TB
   WHERE CUID IS NOT NULL
   GROUP BY CUID


  /******************************* 기득권 데이터 처리 *******************************/
  BEGIN TRAN
    
    -- 0. 기득권데이터 초기화
    TRUNCATE TABLE ECOMM_VESTED_TB

    -- 1. 파인드올
    INSERT INTO [dbo].[ECOMM_VESTED_TB]
      (CUID, FA_PAYDATE)
    SELECT CUID, MAX_PAYDATE AS FA_PAYDATE
      FROM FINDALL_ECOMM_PAYDATE

    -- 2. SERVE (부동산써브)
    INSERT INTO [dbo].[ECOMM_VESTED_TB]
      (CUID, SV_PAYDATE)
    SELECT CUID, MAX_PAYDATE AS SV_PAYDATE
      FROM SERVE_ECOMM_PAYDATE AS A
     WHERE NOT EXISTS(SELECT CUID FROM FINDALL_ECOMM_PAYDATE WHERE CUID = A.CUID) -- 파인드올과 중복되지 않는 데이터

    -- 3. 부동산써브 결제일
    UPDATE T
       SET T.SV_PAYDATE = A.MAX_PAYDATE
      FROM ECOMM_VESTED_TB AS T
      JOIN SERVE_ECOMM_PAYDATE AS A ON A.CUID = T.CUID
     WHERE T.SV_PAYDATE IS NULL

    -- 4. 기득권 FLAG 갱신
    UPDATE A
       SET VESTEDF = '0'
    --SELECT B.CUID, B.MAX_PAYDATE, DATEADD("d",70,B.MAX_PAYDATE)      FROM ECOMM_VESTED_TB AS A        JOIN (SELECT A.CUID, MAX(MAX_PAYDATE) AS MAX_PAYDATE                FROM (SELECT * FROM MWMEMBER.DBO.FINDALL_ECOMM_PAYDATE                      UNION ALL                      SELECT * FROM MWMEMBER.DBO.SERVE_ECOMM_PAYDATE) AS A               GROUP BY A.CUID) AS B ON B.CUID = A.CUID
      WHERE DATEADD("d",70,B.MAX_PAYDATE) < GETDATE()     -- 최종결제일 기준 70일이전에 결제된건

  COMMIT TRAN


GO
/****** Object:  StoredProcedure [dbo].[BAT_OUT_MEMBER_ONEMONTH_AGO_KKO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 탈퇴 30일전 
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2017/01/05
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_OUT_MEMBER_ONEMONTH_AGO_KKO_PROC
 *************************************************************************************/
CREATE PROC [dbo].[BAT_OUT_MEMBER_ONEMONTH_AGO_KKO_PROC]

AS

SET NOCOUNT ON

DECLARE @PHONE	varchar	(24)
DECLARE @MSG	nvarchar	(4000)
DECLARE @URL	varchar	(1000)
DECLARE @URL_BUTTON_TXT	varchar	(160)
DECLARE @FAIL_SUBJECT	varchar	(160)
DECLARE @FAIL_MSG	nvarchar	(4000)

DECLARE @PROFILE_KEY VARCHAR(100)     = '5c211bc7dcb8c6a1ee4c7b7ac865389e1115ffe2'
DECLARE @CALLBACK	varchar	(24)        = '0802690011'        -- 발신자번호
DECLARE @TEMPLATE_CODE	varchar	(10)  = 'AAFa083'           -- 카카오알림톡 템플릿 코드

SELECT @MSG = KKO_MSG
      ,@URL = URL
      ,@URL_BUTTON_TXT = URL_BUTTON_TXT
      ,@FAIL_SUBJECT = LMS_TITLE
      ,@FAIL_MSG = LMS_MSG
  FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWFa083'')') 
  
  
INSERT FINDDB1.COMDB1.DBO.KKO_MSG
      (STATUS, PHONE, CALLBACK, REQDATE, MSG, TEMPLATE_CODE, PROFILE_KEY, URL, URL_BUTTON_TXT, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, ETC1)
SELECT 
       1 AS [STATUS]
      ,REPLACE(A.HPHONE,'-','') AS PHONE
      ,@CALLBACK AS CALLBACK
      ,GETDATE() AS REQDATE
      ,REPLACE(REPLACE(REPLACE(@MSG,'#{ID}',B.USERID) , '#{한달후/3일후}','한달후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(B.LAST_LOGIN_DT, B.JOIN_DT)) , 111), '/', '-')) AS MSG
      ,@TEMPLATE_CODE AS TEMPLATE_CODE
      ,@PROFILE_KEY AS PROFILE_KEY
      ,@URL AS URL
      ,@URL_BUTTON_TXT AS URL_BUTTON_TXT
      ,'LMS' AS FAILED_TYPE
      ,@FAIL_SUBJECT AS FAILED_SUBJECT
      ,REPLACE(REPLACE(REPLACE(@FAIL_MSG,'#{ID}',B.USERID) , '#{한달후/3일후}','한달후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(B.LAST_LOGIN_DT, B.JOIN_DT)) , 111), '/', '-')) AS FAILED_MSG
      ,'FINDALL' AS ETC1       
  FROM CST_REST_MASTER AS A WITH (NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE B.OUT_YN='N'
   AND B.REST_YN='Y'
   AND DATEADD(YEAR, 2, CONVERT(VARCHAR(10), ISNULL(LAST_LOGIN_DT,JOIN_DT), 111)) = DATEADD(MONTH, 1, CONVERT(VARCHAR(10), GETDATE(), 111))
   AND A.HPHONE IS NOT NULL
GO
/****** Object:  StoredProcedure [dbo].[BAT_OUT_MEMBER_THREEDAY_AGO_KKO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 탈퇴 3일전 
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2017/01/05
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_OUT_MEMBER_THREEDAY_AGO_KKO_PROC
 *************************************************************************************/
CREATE PROC [dbo].[BAT_OUT_MEMBER_THREEDAY_AGO_KKO_PROC]

AS

SET NOCOUNT ON

DECLARE @PHONE	varchar	(24)
DECLARE @MSG	nvarchar	(4000)
DECLARE @URL	varchar	(1000)
DECLARE @URL_BUTTON_TXT	varchar	(160)
DECLARE @FAIL_SUBJECT	varchar	(160)
DECLARE @FAIL_MSG	nvarchar	(4000)

DECLARE @PROFILE_KEY VARCHAR(100)     = '5c211bc7dcb8c6a1ee4c7b7ac865389e1115ffe2'
DECLARE @CALLBACK	varchar	(24)        = '0802690011'        -- 발신자번호
DECLARE @TEMPLATE_CODE	varchar	(10)  = 'AAFa083'           -- 카카오알림톡 템플릿 코드

SELECT @MSG = KKO_MSG
      ,@URL = URL
      ,@URL_BUTTON_TXT = URL_BUTTON_TXT
      ,@FAIL_SUBJECT = LMS_TITLE
      ,@FAIL_MSG = LMS_MSG
  FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWFa083'')') 

INSERT FINDDB1.COMDB1.DBO.KKO_MSG
      (STATUS, PHONE, CALLBACK, REQDATE, MSG, TEMPLATE_CODE, PROFILE_KEY, URL, URL_BUTTON_TXT, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, ETC1)
SELECT 
       1 AS [STATUS]
      ,REPLACE(A.HPHONE,'-','') AS PHONE
      ,@CALLBACK AS CALLBACK
      ,GETDATE() AS REQDATE
      ,REPLACE(REPLACE(REPLACE(@MSG,'#{ID}',B.USERID) , '#{한달후/3일후}','3일후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(B.LAST_LOGIN_DT, B.JOIN_DT)) , 111), '/', '-')) AS MSG
      ,@TEMPLATE_CODE AS TEMPLATE_CODE
      ,@PROFILE_KEY AS PROFILE_KEY
      ,@URL AS URL
      ,@URL_BUTTON_TXT AS URL_BUTTON_TXT
      ,'LMS' AS FAILED_TYPE
      ,@FAIL_SUBJECT AS FAILED_SUBJECT
      ,REPLACE(REPLACE(REPLACE(@FAIL_MSG,'#{ID}',B.USERID) , '#{한달후/3일후}','3일후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(B.LAST_LOGIN_DT, B.JOIN_DT)) , 111), '/', '-')) AS FAILED_MSG
      ,'FINDALL' AS ETC1  
  FROM CST_REST_MASTER AS A WITH (NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE B.OUT_YN='N'
   AND B.REST_YN='Y'
   AND DATEADD(YEAR, 2, CONVERT(VARCHAR(10), ISNULL(LAST_LOGIN_DT,JOIN_DT), 111)) = DATEADD(DAY, 3, CONVERT(VARCHAR(10), GETDATE(), 111))
   AND A.HPHONE IS NOT NULL
GO
/****** Object:  StoredProcedure [dbo].[BAT_REST_MEMBER_KKO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 휴면 처리 당일 KKO 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2017/01/04
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_REST_MEMBER_KKO_PROC
 *************************************************************************************/
CREATE PROC [dbo].[BAT_REST_MEMBER_KKO_PROC]

AS

SET NOCOUNT ON

DECLARE @PHONE	varchar	(24)
DECLARE @MSG	nvarchar	(4000)
DECLARE @URL	varchar	(1000)
DECLARE @URL_BUTTON_TXT	varchar	(160)
DECLARE @FAIL_SUBJECT	varchar	(160)
DECLARE @FAIL_MSG	nvarchar	(4000)

DECLARE @PROFILE_KEY VARCHAR(100)     = '5c211bc7dcb8c6a1ee4c7b7ac865389e1115ffe2'
DECLARE @CALLBACK	varchar	(24)        = '0802690011'        -- 발신자번호
DECLARE @TEMPLATE_CODE	varchar	(10)  = 'AAFa082'           -- 카카오알림톡 템플릿 코드
--DECLARE @SENDTIME DATETIME = CONVERT(VARCHAR(10),GETDATE(),120) + ' 13:20:00.000' -- 전송일(시간) = 금일 오전 10시

SELECT @MSG = KKO_MSG
      ,@URL = URL
      ,@URL_BUTTON_TXT = URL_BUTTON_TXT
      ,@FAIL_SUBJECT = LMS_TITLE
      ,@FAIL_MSG = LMS_MSG
  FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWFa082'')') 

INSERT FINDDB1.COMDB1.dbo.KKO_MSG
      (STATUS, PHONE, CALLBACK, REQDATE, MSG, TEMPLATE_CODE, PROFILE_KEY, URL, URL_BUTTON_TXT, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, ETC1)
SELECT 
       1 AS [STATUS]
      ,REPLACE(A.HPHONE,'-','') AS PHONE
      ,@CALLBACK AS CALLBACK
      ,GETDATE() AS REQDATE
      ,REPLACE(@MSG,'#{ID}',B.USERID) AS MSG
      ,@TEMPLATE_CODE AS TEMPLATE_CODE
      ,@PROFILE_KEY AS PROFILE_KEY
      ,@URL AS URL
      ,@URL_BUTTON_TXT AS URL_BUTTON_TXT
      ,'LMS' AS FAILED_TYPE
      ,@FAIL_SUBJECT AS FAILED_SUBJECT
      ,REPLACE(@FAIL_MSG,'#{ID}',B.USERID) AS FAILED_MSG
      ,'FINDALL' AS ETC1
  FROM CST_REST_MASTER AS A WITH(NOLOCK)
  JOIN CST_MASTER AS B WITH (NOLOCK) ON A.CUID = B.CUID
 WHERE CONVERT(VARCHAR(10), A.ADD_DT, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)
   AND A.HPHONE IS NOT NULL
GO
/****** Object:  StoredProcedure [dbo].[BAT_REST_MEMBER_ONEMONTH_AGO_KKO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 개인회원, SMS 수신동의하지 않은 기업회원 휴면 처리 한달전 KKO 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2017/01/04
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_REST_MEMBER_ONEMONTH_AGO_KKO_PROC
 *************************************************************************************/
CREATE PROC [dbo].[BAT_REST_MEMBER_ONEMONTH_AGO_KKO_PROC]

AS

SET NOCOUNT ON

DECLARE @PHONE	varchar	(24)
DECLARE @MSG	nvarchar	(4000)
DECLARE @URL	varchar	(1000)
DECLARE @URL_BUTTON_TXT	varchar	(160)
DECLARE @FAIL_SUBJECT	varchar	(160)
DECLARE @FAIL_MSG	nvarchar	(4000)

DECLARE @PROFILE_KEY VARCHAR(100)     = '5c211bc7dcb8c6a1ee4c7b7ac865389e1115ffe2'
DECLARE @CALLBACK	varchar	(24)        = '0802690011'        -- 발신자번호
DECLARE @TEMPLATE_CODE	varchar	(10)  = 'AAFa081'           -- 카카오알림톡 템플릿 코드

SELECT @MSG = KKO_MSG
      ,@URL = URL
      ,@URL_BUTTON_TXT = URL_BUTTON_TXT
      ,@FAIL_SUBJECT = LMS_TITLE
      ,@FAIL_MSG = LMS_MSG
  FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWFa081'')') 


INSERT FINDDB1.COMDB1.dbo.KKO_MSG
      (STATUS, PHONE, CALLBACK, REQDATE, MSG, TEMPLATE_CODE, PROFILE_KEY, URL, URL_BUTTON_TXT, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, ETC1)
SELECT 
       1 AS [STATUS]
      ,REPLACE(A.HPHONE,'-','') AS PHONE
      ,@CALLBACK AS CALLBACK
      ,GETDATE() AS REQDATE
      ,REPLACE(REPLACE(REPLACE(@MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','한달후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-')) AS MSG
      ,@TEMPLATE_CODE AS TEMPLATE_CODE
      ,@PROFILE_KEY AS PROFILE_KEY
      ,@URL AS URL
      ,@URL_BUTTON_TXT AS URL_BUTTON_TXT
      ,'LMS' AS FAILED_TYPE
      ,@FAIL_SUBJECT AS FAILED_SUBJECT
      ,REPLACE(REPLACE(REPLACE(@FAIL_MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','한달후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-')) AS FAILED_MSG
      ,'FINDALL' AS ETC1       
  FROM DBO.CST_MASTER AS A WITH(NOLOCK)
  WHERE MEMBER_CD = 1
    AND A.REST_YN = 'N'		--휴면회원 제외
    AND A.BAD_YN = 'N' 		--불량회원 제외
    AND A.OUT_YN = 'N'   --회원탈퇴 제외
    AND (
          (A.LAST_LOGIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
          OR 
          (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
        )
    AND A.HPHONE IS NOT NULL
UNION ALL
SELECT 
       1 AS [STATUS]
      ,REPLACE(A.HPHONE,'-','') AS PHONE
      ,@CALLBACK AS CALLBACK
      ,GETDATE() AS REQDATE
      ,REPLACE(REPLACE(REPLACE(@MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','한달후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-')) AS MSG
      ,@TEMPLATE_CODE AS TEMPLATE_CODE
      ,@PROFILE_KEY AS PROFILE_KEY
      ,@URL AS URL
      ,@URL_BUTTON_TXT AS URL_BUTTON_TXT
      ,'LMS' AS FAILED_TYPE
      ,@FAIL_SUBJECT AS FAILED_SUBJECT
      ,REPLACE(REPLACE(REPLACE(@FAIL_MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','한달후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-')) AS FAILED_MSG
      ,'FINDALL' AS ETC1       
  FROM DBO.CST_MASTER AS A WITH(NOLOCK)
 WHERE NOT EXISTS 
       (
       SELECT * from DBO.CST_MSG_SECTION D (NOLOCK) WHERE A.CUID = D.CUID AND D.MEDIA_CD = 'S' AND D.SECTION_CD = 'S101'
       )
   AND MEMBER_CD = 2
   AND A.REST_YN = 'N'		--휴면회원 제외
   AND A.BAD_YN = 'N' 		--불량회원 제외
   AND A.OUT_YN = 'N'   --회원탈퇴 제외
   AND (
        (A.LAST_LOGIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
        OR 
        (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,30,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,29,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
       )
   AND A.HPHONE IS NOT NULL
GO
/****** Object:  StoredProcedure [dbo].[BAT_REST_MEMBER_THREEDAY_AGO_KKO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 배치 작업 -> 벼룩시장 휴면 처리 3일전 KKO 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2017/01/04
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 배치 스케줄
 *  사 용  예 제 : EXEC BAT_REST_MEMBER_THREEDAY_AGO_KKO_PROC
 *************************************************************************************/
CREATE PROC [dbo].[BAT_REST_MEMBER_THREEDAY_AGO_KKO_PROC]

AS

SET NOCOUNT ON

DECLARE @PHONE	varchar	(24)
DECLARE @MSG	nvarchar	(4000)
DECLARE @URL	varchar	(1000)
DECLARE @URL_BUTTON_TXT	varchar	(160)
DECLARE @FAIL_SUBJECT	varchar	(160)
DECLARE @FAIL_MSG	nvarchar	(4000)

DECLARE @PROFILE_KEY VARCHAR(100)     = '5c211bc7dcb8c6a1ee4c7b7ac865389e1115ffe2'
DECLARE @CALLBACK	varchar	(24)        = '0802690011'        -- 발신자번호
DECLARE @TEMPLATE_CODE	varchar	(10)  = 'AAFa081'           -- 카카오알림톡 템플릿 코드

SELECT @MSG = KKO_MSG
      ,@URL = URL
      ,@URL_BUTTON_TXT = URL_BUTTON_TXT
      ,@FAIL_SUBJECT = LMS_TITLE
      ,@FAIL_MSG = LMS_MSG
  FROM OPENQUERY(FINDDB1,'SELECT * FROM COMDB1.DBO.FN_GET_KKO_TEMPLATE_INFO(''MWFa081'')') 

INSERT FINDDB1.COMDB1.DBO.KKO_MSG
      (STATUS, PHONE, CALLBACK, REQDATE, MSG, TEMPLATE_CODE, PROFILE_KEY, URL, URL_BUTTON_TXT, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, ETC1)
SELECT 
       1 AS [STATUS]
      ,REPLACE(A.HPHONE,'-','') AS PHONE
      ,@CALLBACK AS CALLBACK
      ,GETDATE() AS REQDATE
      ,REPLACE(REPLACE(REPLACE(@MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','3일후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-')) AS MSG
      ,@TEMPLATE_CODE AS TEMPLATE_CODE
      ,@PROFILE_KEY AS PROFILE_KEY
      ,@URL AS URL
      ,@URL_BUTTON_TXT AS URL_BUTTON_TXT
      ,'LMS' AS FAILED_TYPE
      ,@FAIL_SUBJECT AS FAILED_SUBJECT
      ,REPLACE(REPLACE(REPLACE(@FAIL_MSG,'#{ID}',A.USERID) , '#{한달후/3일후}','3일후'),'#{yyyymmdd}',REPLACE(CONVERT(VARCHAR(10),DATEADD(YEAR, 1, ISNULL(A.LAST_LOGIN_DT, A.JOIN_DT)) , 111), '/', '-')) AS FAILED_MSG
      ,'FINDALL' AS ETC1       
  FROM DBO.CST_MASTER AS A WITH(NOLOCK)
  WHERE A.REST_YN = 'N'		--휴면회원 제외
    AND A.BAD_YN = 'N' 		--불량회원 제외
    AND A.OUT_YN = 'N'   --회원탈퇴 제외
    AND (
          (A.LAST_LOGIN_DT < DATEADD(DD,3,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.LAST_LOGIN_DT >= DATEADD(DD,2,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
          OR 
          (A.LAST_LOGIN_DT IS NULL AND A.JOIN_DT < DATEADD(DD,3,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) AND A.JOIN_DT >= DATEADD(DD,2,DATEADD(YY,-1,CONVERT(VARCHAR(10),GETDATE(),120))) )
        )
    AND A.HPHONE IS NOT NULL --2017-01-09 정헌수 추가 
GO
/****** Object:  StoredProcedure [dbo].[BIZ_SENDBILL_HIST_I01]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************************
* 단위 업무명: 센드빌 사업자번호 조회 저장
* 작  성  자: 안대희
* 작  성  일: 2021-09-07
* 설      명: 센드빌 사업자번호 조회 저장
* 사용  예제: EXEC DBO.BIZ_SENDBILL_HIST_I01 '106-23-91981', 'S', '04', '[폐업]상태입니다.', '20210907'
*************************************************************************************************/
/*  
    ** 수정 내역
    1. 수 정 자: 
    1-1. 수 정 일: 
    1-2. 수정 내역: 
*/  
CREATE PROCEDURE [dbo].[BIZ_SENDBILL_HIST_I01]
    @hist_biz_no     VARCHAR(30),  /* 사업자번호 */
    @hist_site_cd    VARCHAR(2),  /* SITE_CD */
    @hist_res_code   VARCHAR(5),  /* 결과코드(구분값) */
    @hist_res_msg    NVARCHAR(200),  /* 결과 메세지 */
    @hist_close_dt   VARCHAR(10)  /* 폐업일자 */
AS	
BEGIN
	SET NOCOUNT ON
	
    INSERT INTO BIZ_SENDBILL_HIST (hist_biz_no, hist_site_cd, hist_res_code, hist_res_msg, hist_close_dt)
    VALUES (@hist_biz_no, @hist_site_cd, @hist_res_code, @hist_res_msg, @hist_close_dt) 
END;

GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_HP_AUTH_CODE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013-03-04
 *  수   정   자 : 김 준 홍
 *  수   정   일 : 2015-06-17
 *  수   정      : @P_IDCODE 변수의 데이터타입을 int 에서 char(6)으로 변경함
 *  설        명 : 회원가입 및 ID 찾기 핸드폰 인증 번호 확인
 *  주 의  사 항 :
 *  사 용  소 스 :
 EXEC DBO.CHK_MM_HP_AUTH_CODE_PROC '1','김준홍2','19790522','M','01020500865','','053413','R','','' 
 select top 10 * from MM_HP_AUTH_CODE_TB where username = '김준홍2' order by dt desc
 
************************************************************************************/
CREATE  PROC [dbo].[CHK_MM_HP_AUTH_CODE_PROC]
       @MEMBER_CD   CHAR(1)
     , @USERNAME    VARCHAR(30)
     , @JUMINNO     CHAR(8) = ''
     , @GENDER      CHAR(1) = ''
     , @HP          VARCHAR(14)
     , @BIZNO       CHAR(12)=NULL
     , @IDCODE      CHAR(6)
     , @TYPE        CHAR(1)   --R:회원등록 I:ID찾기
     , @SNS_TYPE    CHAR(1)=NULL
     , @SNS_ID      VARCHAR(100)=NULL
     
AS

SET NOCOUNT ON

DECLARE @CNT  INT
DECLARE @P_IDCODE   CHAR(6)

IF @MEMBER_CD='1' AND @SNS_TYPE<>''   --SNS 회원
BEGIN
    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       AND USERNAME=@USERNAME
       AND HP=@HP
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE
       AND SNS_TYPE=@SNS_TYPE
       AND SNS_ID=@SNS_ID
       AND DATEDIFF(mi,DT,GETDATE()) < 30

    SELECT TOP 1 @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       AND USERNAME=@USERNAME
       AND HP=@HP
       AND TYPE=@TYPE
       AND SNS_TYPE=@SNS_TYPE
       AND SNS_ID=@SNS_ID
       AND DATEDIFF(mi,DT,GETDATE()) < 30
    ORDER BY DT DESC
       
END
ELSE IF @MEMBER_CD='1'  --개인회원
BEGIN

    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       --AND USERNAME=@USERNAME
       --AND JUMINNO=@JUMINNO
       --AND GENDER=@GENDER
       AND HP=@HP
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE
	   AND ISNULL(SNS_TYPE, '') = ''
	   AND ISNULL(SNS_ID, '') = ''
     AND DATEDIFF(mi,DT,GETDATE()) < 30

    SELECT TOP 1 @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       --AND USERNAME=@USERNAME
       --AND JUMINNO=@JUMINNO
       --AND GENDER=@GENDER
       AND HP=@HP
       AND TYPE=@TYPE
	   AND ISNULL(SNS_TYPE, '') = ''
	   AND ISNULL(SNS_ID, '') = ''
     AND DATEDIFF(mi,DT,GETDATE()) < 30
    ORDER BY DT DESC

END
ELSE    --기업회원
BEGIN

    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='2'
       AND USERNAME=@USERNAME
       --AND JUMINNO=@JUMINNO
       --AND GENDER=@GENDER
       AND HP=@HP
       AND BIZNO=@BIZNO
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE
       AND DATEDIFF(mi,DT,GETDATE()) < 30

    SELECT TOP 1 @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='2'
       AND USERNAME=@USERNAME
       --AND JUMINNO=@JUMINNO
       --AND GENDER=@GENDER
       AND HP=@HP
       AND BIZNO=@BIZNO
       AND TYPE=@TYPE
       AND DATEDIFF(mi,DT,GETDATE()) < 30
    ORDER BY DT DESC
END

--로그 기록
INSERT TEMP_HP_AUTH_CODE_TB
     ( USERID, USERNAME, JUMINNO, GENDER, HP, BIZNO, IDCODE, TYPE, MEMBER_CD)
VALUES 
     ( '', @USERNAME, @JUMINNO, @GENDER, @HP, @BIZNO, @IDCODE, @TYPE, @MEMBER_CD)

IF @CNT > 0
  BEGIN
    SELECT @CNT, @P_IDCODE
  END
ELSE
  BEGIN
    DECLARE @TMP TABLE(TMP CHAR(1))
    SELECT @CNT, @P_IDCODE FROM @TMP
  END

--SELECT 1, @P_IDCODE     -- 주의!!!! 인증을 우회하기 위해 테스트서버에서만 적용 (운영에서는 SELECT @CNT, @P_IDCODE )
GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_HP_AUTH_CODE_PROC_EDIT]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013-03-04
 *  수   정   자 : 김 준 홍
 *  수   정   일 : 2015-06-17
 *  수   정      : @P_IDCODE 변수의 데이터타입을 int 에서 char(6)으로 변경함
 *  설        명 : 회원가입 및 ID 찾기 핸드폰 인증 번호 확인
 *  주 의  사 항 :
 *  사 용  소 스 :
 EXEC DBO.CHK_MM_HP_AUTH_CODE_PROC '1','김준홍2','19790522','M','01020500865','','053413','R','','' 
 select top 10 * from MM_HP_AUTH_CODE_TB where username = '김준홍2' order by dt desc
 
************************************************************************************/
CREATE  PROC [dbo].[CHK_MM_HP_AUTH_CODE_PROC_EDIT]
       @MEMBER_CD   CHAR(1)
     , @CUID		INT
     , @HP          VARCHAR(14)
     , @IDCODE      CHAR(6)
     , @TYPE        CHAR(1)   --R:회원등록 I:ID찾기
     
AS

SET NOCOUNT ON

DECLARE @CNT  INT
DECLARE @P_IDCODE   CHAR(6)


IF @MEMBER_CD='1'  --개인회원
BEGIN
    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       AND HP=@HP
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE
       AND CUID = @CUID

    SELECT TOP 1 @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       AND HP=@HP
       AND TYPE=@TYPE
	   AND CUID = @CUID
    ORDER BY DT DESC

END
ELSE    --기업회원
BEGIN
    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='2'
       AND HP=@HP
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE
       AND CUID = @CUID

    SELECT TOP 1 @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='2'
       AND HP=@HP
       AND TYPE=@TYPE
       AND CUID = @CUID
       ORDER BY DT DESC
END

--로그 기록
INSERT TEMP_HP_AUTH_CODE_TB
     ( HP,IDCODE, TYPE, MEMBER_CD)
VALUES 
     ( @HP, @IDCODE, @TYPE, @MEMBER_CD)
     
SELECT @CNT, @P_IDCODE


GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_HP_AUTH_CODE_PROC_S01]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013-03-04
 *  수   정   자 : 김 준 홍
 *  수   정   일 : 2015-06-17
 *  수   정      : @P_IDCODE 변수의 데이터타입을 int 에서 char(6)으로 변경함
 *  설        명 : 회원가입 및 ID 찾기 핸드폰 인증 번호 확인
 *  주 의  사 항 :
 *  사 용  소 스 :
 EXEC DBO.CHK_MM_HP_AUTH_CODE_PROC '1','김준홍2','19790522','M','01020500865','','053413','R','','' 
 select top 10 * from MM_HP_AUTH_CODE_TB where username = '김준홍2' order by dt desc
 
************************************************************************************/
CREATE  PROC [dbo].[CHK_MM_HP_AUTH_CODE_PROC_S01]
       @MEMBER_CD   CHAR(1)
     , @USERNAME    VARCHAR(30)
     , @JUMINNO     CHAR(8)
     , @GENDER      CHAR(1)
     , @HP          VARCHAR(14)
     , @BIZNO       CHAR(12)=NULL
     , @IDCODE      CHAR(6)
     , @TYPE        CHAR(1)   --R:회원등록 I:ID찾기
     , @SNS_TYPE    CHAR(1)=NULL
     , @SNS_ID      VARCHAR(25)=NULL
     
AS

SET NOCOUNT ON

DECLARE @CNT  INT
DECLARE @P_IDCODE   CHAR(6)

IF @MEMBER_CD='1' AND @SNS_TYPE<>''   --SNS 회원
BEGIN
    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       AND USERNAME=@USERNAME
       AND HP=@HP
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE
       AND SNS_TYPE=@SNS_TYPE
       AND SNS_ID=@SNS_ID

    SELECT TOP 1 @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       AND USERNAME=@USERNAME
       AND HP=@HP
       AND TYPE=@TYPE
       AND SNS_TYPE=@SNS_TYPE
       AND SNS_ID=@SNS_ID
    ORDER BY DT DESC
END
ELSE IF @MEMBER_CD='1'  --개인회원
BEGIN
    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE
			 AND ISNULL(SNS_TYPE, '') = ''
			 AND ISNULL(SNS_ID, '') = ''

    SELECT TOP 1  @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='1'
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
       AND TYPE=@TYPE
			 AND ISNULL(SNS_TYPE, '') = ''
			 AND ISNULL(SNS_ID, '') = ''
    ORDER BY DT DESC

END
ELSE    --기업회원
BEGIN
    SELECT @CNT=COUNT(*)
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='2'
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
       AND BIZNO=@BIZNO
       AND IDCODE=@IDCODE
       AND TYPE=@TYPE

    SELECT TOP 1 @P_IDCODE=IDCODE
      FROM MM_HP_AUTH_CODE_TB WITH (NOLOCK)
     WHERE MEMBER_CD='2'
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
       AND BIZNO=@BIZNO
       AND TYPE=@TYPE
       ORDER BY DT DESC
END

--로그 기록
INSERT TEMP_HP_AUTH_CODE_TB
     ( USERID, USERNAME, JUMINNO, GENDER, HP, BIZNO, IDCODE, TYPE, MEMBER_CD)
VALUES 
     ( '', @USERNAME, @JUMINNO, @GENDER, @HP, @BIZNO, @IDCODE, @TYPE, @MEMBER_CD)
     
SELECT @CNT, @P_IDCODE

GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_LOGIN_NOPWD_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 기업, 일반 회원 로그인 및 전환(비번 없이 로그인)
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-3-11
 *  수   정   자 : 배진용
 *  수   정   일 : 2020-10-23 
 *  설        명 : 최종 회원가입 컬럼 추가 (2020-10-23)
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * DECLARE @RET INT
 * EXEC @RET=CHK_MM_LOGIN_NOPWD_PROC 'sebilia'
 * SELECT @RET
   
 *************************************************************************************/
CREATE PROCEDURE [dbo].[CHK_MM_LOGIN_NOPWD_PROC]
    @USERID                VARCHAR(50)  -- 회원아이디
AS

	SET NOCOUNT ON

  DECLARE @ERROR INT
  DECLARE @ROWCOUNT INT

----------------------------------
-- 회원코드 가져오기
----------------------------------
  DECLARE @MEMBER_CD    CHAR(1)
  DECLARE @REST_YN      CHAR(1)

  SELECT TOP 1 
         @MEMBER_CD = MEMBER_CD
       , @REST_YN = REST_YN
    FROM DBO.CST_MASTER WITH(NOLOCK)
   WHERE USERID = @USERID
   ORDER BY REST_YN 

  SELECT @ERROR=@@ERROR
  IF @ERROR<>0            --조회 에러
  BEGIN
      RETURN (100)
  END

  IF @REST_YN = 'Y' 
  BEGIN
    --휴면 회원 ID는 휴면 회원 페이지로 이동
    RETURN (99)
  END   

  IF @MEMBER_CD IS NULL   --로그인 실패
  BEGIN
      RETURN (1)
  END

  --기업 관련 정보를 가져올 수 없음
  --해당 섹션별 정보가 다를 수 있다는 전제로 출발
  SELECT
         M.USERID
       , M.USER_NM    -- 개인이름
       , M.MEMBER_CD
       , ISNULL(J.COM_NM,'') AS COM_NM    -- 기업명(기업만 사용)
       , ISNULL(M.EMAIL,'') AS EMAIL
       , ISNULL(M.HPHONE,'') AS HPHONE
       , '' AS PHONE
       , '' AS ADDR_A
       , '' AS ADDR_B
       , M.BAD_YN
       , M.BIRTH AS JUMINNO_A        --주민번호_A
       , M.DI
       , M.REST_YN
       , ISNULL(M.ADULT_YN,'') AS ISADULT
       , ISNULL(M.SNS_TYPE,'') as SNS_TYPE
       , DATEDIFF(DAY, M.PWD_NEXT_ALARM_DT, GETDATE()) AS PWD_ALARM_YN
       , CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT
       , CASE
              WHEN LEN(M.BIRTH)=8 AND ISNUMERIC(M.BIRTH)=1 THEN YEAR(GETDATE())-LEFT(M.BIRTH,4)
              ELSE 0
         END AGE
       , CASE
              WHEN M.GENDER IN ('M','A','0') THEN 'man'
              WHEN M.GENDER IN ('F','B','1') THEN 'woman'
         END AS GENDER
       , M.CUID  
	   -- 2020-10-27 회원가입대행 컬럼 추가
		,M.AGENCY_YN
	   ,M.LAST_SIGNUP_YN
    FROM DBO.CST_MASTER AS M WITH(NOLOCK)        
    LEFT OUTER JOIN DBO.CST_COMPANY J WITH(NOLOCK) ON M.COM_ID = J.COM_ID
   WHERE M.USERID = @USERID
     AND M.OUT_YN='N'

  SELECT @ERROR=@@ERROR
  IF @ERROR<>0            --조회 에러
  BEGIN
      RETURN (101)
  END

  RETURN (0)
GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_MEMBER_HP_COUNT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 동일 휴대폰으로 3개까지만 가능
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2014-05-20
 *  수   정   자 : 정헌수
 *  수   정   일 : 2014-08-20 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 개인회원 : 동일 휴대폰 번호 3개까지만 체크
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC CHK_MM_MEMBER_HP_COUNT_PROC '0','01087798662'
************************************************************************************/
CREATE PROC [dbo].[CHK_MM_MEMBER_HP_COUNT_PROC]
       @MEMBER_CD   CHAR(1)
     , @HP          VARCHAR(14)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @HP_TYPE2          VARCHAR(14)
	IF LEN(@HP) = 11 
		SET @HP_TYPE2 = LEFT(@HP,3) +'-' + RIGHT(LEFT(@HP,7),4) +'-' + RIGHT(@HP,4)
	ELSE IF LEN(@HP) = 10
		SET @HP_TYPE2 = LEFT(@HP,3) +'-' + RIGHT(LEFT(@HP,7),3) +'-' + RIGHT(@HP,4)
	ELSE 
		SET @HP_TYPE2 = '9999999999999'
	
			IF LEN(@HP) > 0 AND @HP_TYPE2 <> '9999999999999'
				BEGIN
					SELECT COUNT(*) AS CNT
						FROM CST_MASTER WITH (NOLOCK)
				WHERE MEMBER_CD = (CASE @MEMBER_CD WHEN '0' THEN MEMBER_CD ELSE @MEMBER_CD END)
						 AND HPHONE IN (@HP, @HP_TYPE2)
						 AND OUT_YN = 'N'
		END
	ELSE
		BEGIN
			SELECT 999 AS CNT
		END
END

GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_MEMBER_SNS_UNIQUE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : SNS 회원 가입 > SNS_TYPE, SNS_ID 확인 및 이메일(회원ID) 중복 체크
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-03-04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :  SNS 회원 중복체크 조건(SNS_TYPE, SNS_ID) 으로 중복가입 체크, 이메일 중복 체크
 *  주 의  사 항 :
 *  사 용  소 스 :
 EXEC DBO.CHK_MM_MEMBER_SNS_UNIQUE_PROC 'N', '23598650', 'bird3325@gmail.com'
************************************************************************************/
CREATE  PROC [dbo].[CHK_MM_MEMBER_SNS_UNIQUE_PROC]
       @SNS_TYPE    CHAR(1)
     , @SNS_ID      VARCHAR(25)
     , @USERID      VARCHAR(50)   --회원 ID
AS
--RECORDSET이 반환되지 않는 경우는 없음
SET NOCOUNT ON

DECLARE @CNT  INT

SELECT @CNT = COUNT(*) 
  FROM CST_MASTER WITH (NOLOCK)
 WHERE SNS_TYPE=@SNS_TYPE 
   AND SNS_ID = @SNS_ID
   AND MEMBER_CD='1'
   AND OUT_YN='N'
   
IF @CNT=0   --아이디 중복 체크(EMAIL 중복)
BEGIN
  SELECT @CNT = COUNT(*)
  FROM CST_MASTER WITH (NOLOCK)
 WHERE SNS_ID <> ''
   AND MEMBER_CD='1'
   AND USERID = @USERID
END   

SELECT @CNT

GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_REST_MEMBER_HP_AUTH_CODE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 휴면회원 계정 해제 > 핸드폰 인증 코드 체크
 *  작   성   자 : 신 장 순
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 휴면회원 계정 해제를 위한 핸드폰 인증번호를 체크 함
 *  주 의  사 항 :
 *  사 용  소 스 :
************************************************************************************/
CREATE PROC [dbo].[CHK_MM_REST_MEMBER_HP_AUTH_CODE_PROC]
       @USERID      VARCHAR(50)
     , @HP          VARCHAR(14)
	 , @JUMINNO			CHAR(8)
     , @IDCODE      CHAR(6)
     , @TYPE        CHAR(1)			= 'R'   --R:휴면회원 계정 해제
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @CNT  INT
	DECLARE @DT DATETIME

	SET @DT = DATEADD(MI, -10, GETDATE())

	SELECT COUNT(*)
		FROM CST_REST_HP_AUTH_CODE_TB WITH (NOLOCK)
	 WHERE USERID = @USERID
	   AND HP = @HP
	   AND JUMINNO = @JUMINNO
		 AND IDCODE = @IDCODE
		 AND TYPE = @TYPE
		 AND DT >= @DT

END
GO
/****** Object:  StoredProcedure [dbo].[CST_MASTER_AGENCY_CHECK_S1]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************    
 *  단위 업무 명 : 회원 가입 대행 > 가입 이력 CHECK  
 *  작   성   자 : 안대희  
 *  작   성   일 : 2021-07-13    
 *  설        명 : 벼룩시장 부동산 > 정회원 회원가입시 휴대폰 번호 기준 가입이력 체크
 *  TEST         : EXEC dbo.CST_MASTER_AGENCY_CHECK_S1 '1', '010-1234-5623'
************************************************************************************/    
CREATE PROCEDURE [dbo].[CST_MASTER_AGENCY_CHECK_S1]  
    @MEMBER_CD  CHAR(1),    /* 회원구분(1:개인, 2:기업) */  
    @HPHONE       VARCHAR(14)  /* 휴대폰번호 */  
AS  
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT CUID, USERID
    FROM CST_MASTER  WITH(NOLOCK)  
    WHERE MEMBER_CD = @MEMBER_CD 
    AND HPHONE = @HPHONE 
    AND OUT_YN = 'N'  
    AND AGENCY_YN = 'Y'
    AND LAST_SIGNUP_YN = 'Y'
    ORDER BY CUID DESC

    SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[CST_MASTER_AGENCY_U1]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************      
 *  단위 업무 명 : 회원 가입 대행 > 정회원 등록처리    
 *  작   성   자 : 안대희    
 *  작   성   일 : 2021-05-26      
 *  설        명 : 벼룩시장 부동산 > 회원가입대행 후 정회원 가입시 회원 정보 업데이트    
 *  주 의  사 항 :       
 *  사 용  소 스 :      
    RETURN(500)  -- 실패    
    RETURN(0) -- 성공    
    EXEC dbo.CST_MASTER_AGENCY_U1 14213738, '1', 'find000001', '1234!@', 'dev25@mediawill.com', '010-1234-5678',    
        '', '', '', '', '', '', ''    
    EXEC dbo.CST_MASTER_AGENCY_U1 14213741, '2', 'find000002', '1234!@', 'dev25@mediawill.com', '010-1234-5678',    
        '111-22-33333', 'Y', '1', '880101', '홍길동', '123124', '341252435', 2, '123-4568'    
************************************************************************************/      
CREATE PROCEDURE [dbo].[CST_MASTER_AGENCY_U1]    
    @CUID       INT,    /* key */    
    @MEMBER_CD  CHAR(1),    /* 회원구분(1:개인, 2:기업) */    
    @USERID     VARCHAR(50),    /* 아이디 */    
    @PASSWORD     VARCHAR(30),  /* 비밀번호 */    
    @EMAIL        VARCHAR(50),  /* 이메일 */    
    @HPHONE       VARCHAR(14),  /* 휴대폰번호 */    
    @RETISTER_NO    VARCHAR(12) = '',  /* 사업자 번호 */    
    @ADULT_YN VARCHAR(2) = '',  /* 성인 인증 */    
    @GENDER  VARCHAR(2) = '',  /* 성별 */    
    @BIRTHDATE VARCHAR(10) = '',  /* 생일 */    
    @NAME  VARCHAR(20) = '',  /* 이름 */    
    @DI          VARCHAR(70) = '',      
    @CI          VARCHAR(88) = '',      
    @MEMBER_TYPE TINYINT = 0,      
    @REG_NUMBER VARCHAR(70) = ''    /* 공인중개사 등록 번호 */    
AS    
    SET NOCOUNT ON    
    DECLARE @ID_COUNT BIT    
    DECLARE @REALHP_YN CHAR(1)  /* 휴대폰 인증(Y) */    
    DECLARE @COM_ID INT /* 사업자 ID */    
    SET @REALHP_YN = ''    
    
    /* 회원 체크 */    
    SELECT @ID_COUNT = COUNT(CUID),  @COM_ID = ISNULL(COM_ID, 0)    
    FROM CST_MASTER WITH(NOLOCK)     
    WHERE CUID = @CUID    
    GROUP BY COM_ID    
        
    -- SELECT @ID_COUNT, @COM_ID    
    
    IF (@MEMBER_CD = 1)    
    BEGIN    
        SET @REALHP_YN = 'Y'    
    END    
    
    IF (@ID_COUNT = 1)    
    BEGIN    
        EXEC DBO.SP_CST_MASTER_BACKUP  @CUID --회원정보 백업 2016-11-10 정헌수    
      
        /* 기업 회원 */    
        IF (@MEMBER_CD = 2)    
        BEGIN    
            UPDATE CST_MASTER     
            SET USERID   = @USERID    
            , EMAIL  = @EMAIL    
            , HPHONE = @HPHONE    
            , MOD_DT = GETDATE()    
            , REALHP_YN  = @REALHP_YN    
            , PWD_MOD_DT = GETDATE()    
            , PWD_NEXT_ALARM_DT = (GETDATE() + 180)    
            , LAST_SIGNUP_YN = 'Y'    -- 회원가입대행 최종 가입 여부    
            , pwd_sha2   = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PASSWORD)))    
            , ADULT_YN = @ADULT_YN    
            , GENDER = @GENDER    
            , BIRTH = @BIRTHDATE    
            , USER_NM = @NAME    
            , DI = @DI    
            , CI = @CI    
            WHERE CUID = @CUID    
            AND MEMBER_CD = @MEMBER_CD    
            ;    
    
            /* 담당자 이메일 수정 */    
            UPDATE CST_COMPANY_JOB     
            SET MANAGER_EMAIL = @EMAIl     
            WHERE COM_ID = @COM_ID    
            ;    
    
            -- 사업자번호가 변경 되었으면 수정    
            IF (@RETISTER_NO != '')    
            BEGIN    
                UPDATE CST_COMPANY    
                SET REGISTER_NO = @RETISTER_NO, MOD_DT = GETDATE()    
                WHERE COM_ID = @COM_ID    
                ;    
            END    
    
            /* 공인중개사 번호 */    
           IF (@MEMBER_TYPE = 2)    
           BEGIN    
                UPDATE CST_COMPANY_LAND    
                SET LAND_CLASS_CD = 'A', REG_NUMBER = @REG_NUMBER,     
                ETCINFO_SYNC = 0, SECTION_CD = 'S103', MOD_DT = GETDATE()    
                WHERE COM_ID = @COM_ID    
                ;    
           END    
        END    
    
        ELSE    
            
        BEGIN    
            UPDATE CST_MASTER     
            SET USERID     = @USERID    
            , EMAIL     = @EMAIL    
            , HPHONE     = @HPHONE    
            , MOD_DT     = GETDATE()    
            , REALHP_YN    = @REALHP_YN    
            , PWD_MOD_DT = GETDATE()    
            , PWD_NEXT_ALARM_DT = (GETDATE() + 180)    
            , LAST_SIGNUP_YN = 'Y'    -- 회원가입대행 최종 가입 여부    
            , pwd_sha2   = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PASSWORD)))    
            WHERE CUID = @CUID    
            AND MEMBER_CD = @MEMBER_CD    
            ;    
        END    
    
        /* 회원 변경 이력 */    
        INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, HPHONE, PWD_CHANGE_YN)     
        VALUES (@CUID, @USERID, GETDATE(), @HPHONE, 'Y')    
        ;    
    
        /* 회원가입대행 최종 가입 이력 */    
        INSERT INTO [CST_MASTER_AGENCY_HISTORY] ([CUID], [USERID], [MOD_DT], [EMAIL], [BIZNO], [LAST_SIGNUP_YN], [AGENCY_YN] )    
        VALUES(@CUID, @USERID, GETDATE(), @EMAIl, @RETISTER_NO, 'Y', 'Y')    
        ;    
    
        RETURN(0) -- 성공    
    END    
    ELSE    
    BEGIN    
        RETURN(500)  -- 실패    
    END    
    
    SET NOCOUNT OFF 
GO
/****** Object:  StoredProcedure [dbo].[cst_master_update_serve]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
JMG@20190117 통합회원 DB 업데이트
select * from good.dbo.tbl_naverclosebizno with(nolock) 

-- exec good.dbo.AG_NAVERCLOSEBIZNO_S1 @bizNo='2068526551'
exec good.dbo.AG_NAVERCLOSEBIZNO_S1 @bizNo='2068526551'

*/
CREATE PROCEDURE [dbo].[cst_master_update_serve]
	@mem_seq		int = 0,
	@hphone			varchar(30) = '',
	@user_nm		varchar(50) = '',
	@email			varchar(50) = '',
	@pwd			varchar(50) = '',
	@main_phone		varchar(30) = '',
	@com_nm			varchar(50) = '',
	@ceo_nm			varchar(50) = '',
	@fax			varchar(30) = '',
	@register_no	varchar(50) = '',
	@reg_number		varchar(50) = ''
AS
BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @COM_ID INT	
	DECLARE @USER_ID varchar(50)	

	SELECT @COM_ID = COM_ID
	,@USER_ID = USERID 
	FROM MWMEMBER.DBO.CST_MASTER
	WHERE CUID = @MEM_SEQ

	IF @pwd <> ''  AND @pwd <> 'd41d8cd98f00b204e9800998ecf8427e' 
    BEGIN --공백일경우 업데이트 안함 2019-01-21 조민기
    	UPDATE DBO.CST_MASTER
		SET HPHONE = @hphone 
		, USER_NM = @user_nm
		, EMAIL = @email
		, PWD_MOD_DT = GETDATE()
		, pwd_sha2 = master.DBO.fnGetStringToSha256(@PWD)
		WHERE CUID = @mem_seq
		;

		UPDATE CST_LOGIN_FAIL_COUNT 
		SET FAIL_CNT = 0
		, FAIL_DATE = ''
		WHERE USERID = @USER_ID
    	;

		--. edit by 안대희 2021-09-29
		--. 로그인 history > login_status 2(비밀번호 변경)로 변경
		UPDATE CST_LOGIN_LOG
		SET login_status = 2
		WHERE CUID = @mem_seq
    	;
	END 
    ELSE 
    BEGIN
		UPDATE DBO.CST_MASTER
		SET HPHONE = @hphone 
		, USER_NM = @user_nm
		, EMAIL = @email
		, PWD_MOD_DT = GETDATE()
		WHERE CUID = @mem_seq
	END

	UPDATE DBO.CST_COMPANY
	SET MAIN_PHONE = @main_phone
	, COM_NM = @com_nm
	, CEO_NM = @ceo_nm
	, FAX = @FAX
	, REGISTER_NO = @register_no
	WHERE COM_ID = @COM_ID

	UPDATE DBO.CST_COMPANY_LAND
	SET REG_NUMBER = @reg_number
	WHERE COM_ID = @COM_ID
	
END
GO
/****** Object:  StoredProcedure [dbo].[CST_SERVICE_USE_AGREE_TRANS_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CST_SERVICE_USE_AGREE_TRANS_PROC] (

/*************************************************************************************
 *  단위 업무 명 : 서비스 이용동의 데이터 이관 (일일 / 벼부DB -> 통합회원DB)
 *  작   성   자 : 이정원
 *  작   성   일 : 2021-10-08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 일일 부동산 서비스 이용동의 데이터 이관 처리
 *************************************************************************************/

  @RESULT INT OUTPUT  

        
)
AS
  DECLARE @strDate datetime    
  DECLARE @endDate datetime    
  DECLARE @oCnt INT            
  DECLARE @nCnt INT    

SET @strDate = CAST(CONCAT(CONVERT(VARCHAR(10), DATEADD(DAY, -1, GETDATE()), 23), ' 00:00:00') AS DATETIME)
SET @endDate = CAST(CONCAT(CONVERT(VARCHAR(10), DATEADD(DAY, -1, GETDATE()), 23), ' 23:59:59') AS DATETIME)
SET @RESULT = 1   -- 결과 초기값 
-- 1. 전날 데이터 중복확인 (통합회원DB) 	
SELECT 
	@oCnt = COUNT(*)      
FROM  MWMEMBER.dbo.CST_SERVICE_USE_AGREE WITH (NOLOCK)
WHERE REG_DT >= @strDate
  AND REG_DT <= @endDate
  AND SECTION_CD = 'S103'	 
  
IF @oCnt = 0 BEGIN 
		-- 2. INSERT할 데이터 확인 (벼부DB)
		SELECT @nCnt = COUNT(*) FROM OPENQUERY
		(
			AWS_ET, ' SELECT 
					  IDX, CUID, SECTION_CD, AGREE_CD, REG_DT
					  FROM findalldb.tu_cst_service_use_agree
					  WHERE SECTION_CD = ''S103''
						AND REG_DT >= CONCAT(DATE_ADD(DATE_FORMAT(NOW(), ''%Y-%m-%d''), interval -1 day), '' 00:00:00'')
						AND REG_DT <= CONCAT(DATE_ADD(DATE_FORMAT(NOW(), ''%Y-%m-%d''), interval -1 day), '' 23:59:59'')
					'
		)	
		
		IF @nCnt > 0 BEGIN 			
                -- 3. 데이터 이관 (INSERT / 벼부DB -> 통합회원DB)
		BEGIN TRY
			BEGIN TRAN			
			INSERT INTO MWMEMBER.dbo.CST_SERVICE_USE_AGREE (CUID, SECTION_CD, AGREE_CD, REG_DT)
				SELECT 
			      C.CUID
			    , C.SECTION_CD
			 	, C.AGREE_CD
				, C.REG_DT
				FROM (								
					   SELECT * 
					   FROM 
					   OPENQUERY (		
					   AWS_ET,
					   'SELECT
					     A.CUID
					   , A.SECTION_CD 
					   , A.AGREE_CD 
					   , A.REG_DT 
					   FROM FINDALLDB.TU_CST_SERVICE_USE_AGREE A
					   WHERE A.REG_DT >= CONCAT(DATE_ADD(DATE_FORMAT(NOW(), ''%Y-%m-%d''), interval -1 day), '' 00:00:00'')
						 AND A.REG_DT <= CONCAT(DATE_ADD(DATE_FORMAT(NOW(), ''%Y-%m-%d''), interval -1 day), '' 23:59:59'')
						 AND A.SECTION_CD = ''S103''
					   ORDER BY a.REG_DT ASC'
					)
				) C			
		
			COMMIT TRAN						
			SET @RESULT = 0			
		END TRY
			
		BEGIN CATCH			
			ROLLBACK TRAN					
			SET @RESULT = -1								
		END CATCH
		END	
END
GO
/****** Object:  StoredProcedure [dbo].[DEL_MM_SSO_CERT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : SSO 로그인 인증 TOKEN 삭제
 *  작   성   자 : 최 병 찬 (sebilia@mediawill.com)
 *  작   성   일 : 2017/08/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.DEL_MM_SSO_CERT_PROC 
 *************************************************************************************/
CREATE PROC [dbo].[DEL_MM_SSO_CERT_PROC]
AS
--10분이전 기록 삭제
DELETE FROM MM_SSO_CERT_TB
 WHERE DT<DATEADD(MI,-10,GETDATE())
GO
/****** Object:  StoredProcedure [dbo].[EDIT_AD_MM_MEMBER_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원리스트 >  상세 > 수정처리
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015.02.24
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :

 *************************************************************************************/

CREATE PROCEDURE [dbo].[EDIT_AD_MM_MEMBER_PROC]
     @CUID         INT
   , @USERID       VARCHAR(50)        -- 아이디
   , @USERNAME     VARCHAR(30)        -- 이름
   , @PASSWORD     VARCHAR(30) = ''   -- 비밀번호
   , @EMAIL        VARCHAR(50)        -- 이메일
   , @HPHONE       VARCHAR(14)        -- 휴대폰번호
   , @ADMIN_ID     VARCHAR(30) = ''    -- 관리자아이디
AS

DECLARE @PWDCHANGEYN  CHAR(1)
SET @PWDCHANGEYN='N'
--------------------------------
-- 공통 테이블
--------------------------------
IF @PASSWORD=''
BEGIN
		--패스워드 제외
    UPDATE DBO.CST_MASTER
       SET USER_NM = @USERNAME
         , EMAIL    = @EMAIL
         , HPHONE   = @HPHONE
         , MOD_DT   = GETDATE()
         , MOD_ID   = @ADMIN_ID
     WHERE USERID   = @USERID
       AND CUID = @CUID
END
ELSE
BEGIN
    SET @PWDCHANGEYN='Y'
    
    UPDATE DBO.CST_MASTER
       SET 
       --PWD        = DBO.FN_MD5(LOWER(@PASSWORD))         , 
         PWD_MOD_DT = GETDATE()
         , PWD_NEXT_ALARM_DT = GETDATE()
         , USER_NM   = @USERNAME
         , EMAIL      = @EMAIL
         , HPHONE     = @HPHONE
         , MOD_DT     = GETDATE()
         , MOD_ID     = @ADMIN_ID
         ,pwd_sha2	  = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PASSWORD)))	
     WHERE USERID = @USERID
       AND CUID = @CUID
       
	UPDATE CST_LOGIN_FAIL_COUNT 
	SET FAIL_CNT = 0
	, FAIL_DATE = ''
	WHERE USERID = @USERID
END

	INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, HPHONE, COM_ID, USER_NM, PWD_CHANGE_YN) 
	     VALUES (@CUID, @ADMIN_ID, getdate(), @HPHONE, NULL, @USERNAME, @PWDCHANGEYN)
GO
/****** Object:  StoredProcedure [dbo].[EDIT_BIZ_REG_MASTER_CloseYN_CHANGE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위업무명: 사업자 번호 기준 폐업 여부 저장
 *  작  성  자: 이현석
 *  작  성  일: 2021/05/17
 *  수  정  자: 
 *  수  정  일: 
 *  주의 사항:
 *  사용 소스:
 *  사용 예제: 예시 [MWMEMBER].[DBO].[EDIT_BIZ_REG_MASTER_CloseYN_Change_PROC]
               execute [MWMEMBER].[DBO].[EDIT_BIZ_REG_MASTER_CloseYN_Change_PROC] '829-81-00791', '주식회사 LOVE';

execute [MWMEMBER].[DBO].[EDIT_BIZ_REG_MASTER_CloseYN_CHANGE_PROC] 
        @BizNo = '829-81-00791'
	  , @BizName = '주식회사 LOVE'
*************************************************************************************/
CREATE PROC [dbo].[EDIT_BIZ_REG_MASTER_CloseYN_CHANGE_PROC]
        @BizNo varchar(12)
      , @BizName varchar(50) 
AS
--DECLARE @BizNo varchar(12) = '829-81-00791'
--DECLARE @BizName varchar(50) = '주식회사 LOVE'

--1. 관련 테이블 확인
SELECT * 
  FROM MWMEMBER.DBO.BIZ_REG_MASTER A WITH(NOLOCK)
 WHERE 1=1
   AND A.BizNo = @BizNo;

--SELECT A.BizNo
--     , A.BizName
--	 , A.MakeDate
--	 , A.Origin
--	 , A.CloseYN
--	 , A.CloseDate
--  FROM MWMEMBER.DBO.BIZ_REG_MASTER A WITH(NOLOCK)
-- WHERE 1=1
--   AND A.BizNo = @BizNo;

--2. 변경 하려는 데이터 확인
MERGE MWMEMBER.DBO.BIZ_REG_MASTER A
USING (SELECT '1' COL)  B
   ON A.BizNo = @BizNo
  -- AND A.BizName = @BizName
 WHEN MATCHED THEN
    UPDATE 
	   SET CloseYN = ('Y')
	     , closeDate = (getdate())
 WHEN NOT MATCHED THEN 
    INSERT (BizNo, BizName, MakeDate, Origin, CloseYN,CloseDate)
    VALUES (@BizNo, @BizName, GETDATE(), 'B','Y', GETDATE())

OUTPUT $ACTION AS result_string;

--3. 변경 된 내용 확인
DECLARE @Full_SQL VARCHAR(MAX)
SET @Full_SQL =
 'SELECT A.BizNo, A.BizName, A.MakeDate, A.Origin, A.CloseYN, A.CloseDate
    FROM MWMEMBER.DBO.BIZ_REG_MASTER A WITH(NOLOCK)
   WHERE 1=1 AND A.BizNo = ('''+ @BizNo +''');'

PRINT @Full_SQL;
GO
/****** Object:  StoredProcedure [dbo].[EDIT_CST_LOGIN_FAIL_COUNT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위업무명: 로그인 실패 횟수 초기화 프로시저
 *  작  성  자: 이현석
 *  작  성  일: 2021/07/06
 *  수  정  자: 
 *  수  정  일: 
 *  주의 사항:
 *  사용 소스:
 *  사용 예제: 예시 [MWMEMBER].[dbo].[EDIT_CST_LOGIN_FAIL_COUNT_PROC]  
               execute [MWMEMBER].[dbo].[EDIT_CST_LOGIN_FAIL_COUNT_PROC]  'find894917';

execute [MWMEMBER].[dbo].[EDIT_CST_LOGIN_FAIL_COUNT_PROC] 
        @USERID = 'find894917'
*************************************************************************************/     
CREATE PROCEDURE [dbo].[EDIT_CST_LOGIN_FAIL_COUNT_PROC]    
     @USERID VARCHAR(50)
AS    
    SET NOCOUNT ON    
     UPDATE MWMEMBER.DBO.CST_LOGIN_FAIL_COUNT
		    SET FAIL_CNT = ('0') -- 실패 횟수 초기화
          , FAIL_DATE = GETDATE()
	    WHERE USERID = @USERID; 
    
    SET NOCOUNT OFF 
GO
/****** Object:  StoredProcedure [dbo].[EDIT_CST_MARKETING_AGREEF_MAILSEND_DT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅 수신동의내역 알림메일 발송일 업데이트
 *  작   성   자 : 조재성
 *  작   성   일 : 2021-03-25 
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EDIT_CST_MARKETING_AGREEF_MAILSEND_DT_PROC
 *************************************************************************************/

CREATE PROC [dbo].[EDIT_CST_MARKETING_AGREEF_MAILSEND_DT_PROC]
	@TARGET_ID INT
AS
BEGIN
	SET NOCOUNT ON

	UPDATE CST_MARKETING_AGREEF_TB
	SET MAILSEND_DT = GETDATE()
	FROM CST_MARKETING_AGREEF_TB A
		INNER JOIN (SELECT CUID,RESULT_CODE FROM MM_AD_AGREE_EMAIL_SEND_LOG_TB WHERE TARGET_ID=@TARGET_ID) B
			ON A.CUID=B.CUID
	WHERE B.RESULT_CODE='0000'


END
GO
/****** Object:  StoredProcedure [dbo].[EDIT_F_COMPANY_INFO_JOB_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
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
/****** Object:  StoredProcedure [dbo].[EDIT_INS_MM_BAD_HP_TB_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위업무명: 보이스피싱 차단번호 입력
 *  작  성  자: 이현석
 *  작  성  일: 2021/01/13
 *  수  정  자: 
 *  수  정  일: 
 *  주의 사항:
 *  사용 소스:
 *  사용 예제:  execute MWMEMBER.DBO.EDIT_INS_MM_BAD_HP_TB_PROC '01000000000', '박영묘대리요청'
                   exec MWMEMBER.DBO.EDIT_INS_MM_BAD_HP_TB_PROC '01000000000', '박영묘대리요청'
*************************************************************************************/
CREATE PROC [dbo].[EDIT_INS_MM_BAD_HP_TB_PROC]
       @HP VARCHAR(13)  
     , @MEMO VARCHAR(500) 
AS

		INSERT INTO [MWMEMBER].[dbo].[MM_BAD_HP_TB] (HP,MEMO) VALUES (@HP,@MEMO);
GO
/****** Object:  StoredProcedure [dbo].[EDIT_MARKETING_AGREEF_CLEAR_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅 수신동의 해제
 *  작   성   자 : 이근우
 *  작   성   일 : 2020.03.17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 *************************************************************************************/
CREATE PROC [dbo].[EDIT_MARKETING_AGREEF_CLEAR_PROC]
  @CUID     INT
AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  UPDATE M
     SET M.AGREEF = 0
       , M.AGREE_DT = GETDATE()
  -- SELECT M.*
    FROM CST_MASTER AS CM WITH(NOLOCK)
    JOIN CST_MARKETING_AGREEF_TB AS M WITH(NOLOCK) ON M.CUID = CM.CUID
   WHERE CM.CUID = @CUID

END
GO
/****** Object:  StoredProcedure [dbo].[EDIT_MEMBER_HPHONE_CHANGE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 휴대폰번호 중복 체크
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016.08.28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 :
 EDIT_MEMBER_HPHONE_CHANGE_PROC '10503845', '010-3393-1420'
 *************************************************************************************/
CREATE PROC [dbo].[EDIT_MEMBER_HPHONE_CHANGE_PROC]
  @CUID       INT
, @HP         VARCHAR(13)
AS

BEGIN  

  SET NOCOUNT ON

  UPDATE A
     SET REALHP_YN = 'N'
  -- SELECT *
    FROM CST_MASTER A
   WHERE MEMBER_CD = 1
     AND HPHONE = @HP

  UPDATE A
     SET REALHP_YN = 'Y'
       , HPHONE = @HP
  -- SELECT *
    FROM CST_MASTER A
   WHERE MEMBER_CD = 1
 --    AND HPHONE = @HP
     AND CUID = @CUID  
  
  -- LOG남기기
  
END



GO
/****** Object:  StoredProcedure [dbo].[EDIT_MM_AD_AGREE_EMAIL_SEND_LOG_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅 수신동의내역 알림메일 발송 로그 수정
 *  작   성   자 : 조재성
 *  작   성   일 : 2021-03-24 
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EDIT_MM_AD_AGREE_EMAIL_SEND_LOG_PROC
 *************************************************************************************/

CREATE PROC [dbo].[EDIT_MM_AD_AGREE_EMAIL_SEND_LOG_PROC]
	@TARGET_ID INT,
	@CUID INT,
	@EMAIL VARCHAR(100),
	@RESULT_CODE VARCHAR(50),
	@RESULT_MESSAGE VARCHAR(500)
AS
BEGIN
	SET NOCOUNT ON

	UPDATE MM_AD_AGREE_EMAIL_SEND_LOG_TB
	SET 
		RESULT_CODE = @RESULT_CODE
		,RESULT_MESSAGE = @RESULT_MESSAGE
		,UPDATE_DT = GETDATE()
	WHERE	  TARGET_ID = @TARGET_ID
		  AND CUID = @CUID 
		  AND EMAIL = @EMAIL 


END
GO
/****** Object:  StoredProcedure [dbo].[EDIT_MM_MEMBER_ISADULT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 > 성인 인증 등록
 *  작   성   자 : 장재웅 (rainblue1@mediawill.com)
 *  작   성   일 : 2013/03/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_MM_MEMBER_ISADULT_PROC
 *************************************************************************************/


CREATE   PROC [dbo].[EDIT_MM_MEMBER_ISADULT_PROC]

  @CUID		INT
  ,@ISADULT		CHAR(1)			-- 성인 인증 여부

AS

  SET NOCOUNT ON

    UPDATE CST_MASTER
    SET		ADULT_YN = @ISADULT
    WHERE	CUID	= @CUID

GO
/****** Object:  StoredProcedure [dbo].[EDIT_MM_MEMBER_PASSWORD_CHANGE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 찾기>비밀번호 변경
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 변경
 *  주 의  사 항 :
 *  사 용  소 스 :
 EDIT_MM_MEMBER_PASSWORD_CHANGE_PROC 'cowto76', '11111', '12807058'
 *************************************************************************************/
CREATE PROC [dbo].[EDIT_MM_MEMBER_PASSWORD_CHANGE_PROC]
  @USERID     VARCHAR(50)
, @PASSWORD   VARCHAR(20)
, @CUID       INT
AS

BEGIN
  DECLARE @ROWCOUNT INT

  SET NOCOUNT ON
  DECLARE @MD5PWD VARCHAR(100)

  SET @MD5PWD = DBO.FN_MD5(LOWER(@PASSWORD))  -- 소문자 변경 및 MD5로 변경

  UPDATE A
     SET --PWD = @MD5PWD       , 
		 PWD_MOD_DT = GETDATE()
       , PWD_NEXT_ALARM_DT = GETDATE() + 180
       , login_pwd_enc = NULL
       , pwd_sha2	  = master.DBO.fnGetStringToSha256(@MD5PWD)	
    FROM CST_MASTER A
   WHERE CUID = @CUID
  	AND USERID = @USERID

	--jmg@20190103 비밀번호 실패 카운터 초기화
	UPDATE CST_LOGIN_FAIL_COUNT 
	SET FAIL_CNT = 0
	, FAIL_DATE = ''
	WHERE USERID = @USERID
  
  INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, PWD_CHANGE_YN) 
  VALUES (@CUID, @USERID, GETDATE(), 'Y')  -- 이력을 남기자
    
  SELECT @ROWCOUNT = @@ROWCOUNT

  IF @ROWCOUNT <> 1
  BEGIN
    SELECT 1
    RETURN;
  END
  ELSE
  BEGIN
    SELECT 0
    RETURN;
  END 
END



GO
/****** Object:  StoredProcedure [dbo].[GET_AD_EPAPER_SUBC_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 ePAPER 정기구독 여부
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_EPAPER_SUBC_PROC '140060'

 *************************************************************************************/
CREATE	PROCEDURE [dbo].[GET_AD_EPAPER_SUBC_PROC]
	 @CUID		INT
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
  DECLARE @READINGFLAG CHAR(1)
  DECLARE @EPAPERYN    CHAR(1)
	
	SELECT	 
	        @READINGFLAG = READINGFLAG
	  FROM	FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB WITH (NOLOCK)
	 WHERE	CUID= @CUID
	 
  IF @READINGFLAG IS NULL OR @READINGFLAG='0'
  BEGIN
    SET @EPAPERYN='N'
  END
  ELSE
  BEGIN
    SET @EPAPERYN='Y'  
  END

  SELECT @EPAPERYN AS EPAPER_YN
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_EPAPER_SUBC_PROC_BK01]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 ePAPER 정기구독 여부
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_EPAPER_SUBC_PROC_BK01 13105888

 *************************************************************************************/
CREATE	PROCEDURE [dbo].[GET_AD_EPAPER_SUBC_PROC_BK01]
	 @CUID		INT
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
  DECLARE @READINGFLAG CHAR(1)
  DECLARE @EPAPERYN    CHAR(1)
	

	 
	 EXEC @READINGFLAG =  FINDDB1.PAPER_NEW.DBO.MEMBERDB_GET_AD_EPAPER_SUBC_PROC @CUID
	 
  IF @READINGFLAG IS NULL OR @READINGFLAG='0'
  BEGIN
    SET @EPAPERYN='N'
  END
  ELSE
  BEGIN
    SET @EPAPERYN='Y'  
  END

  SELECT @EPAPERYN AS EPAPER_YN
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_COMPANY_TB_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 기업 회원 정보 가져오기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_MM_COMPANY_TB_INFO_PROC 'SEBILIA'

 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_AD_MM_COMPANY_TB_INFO_PROC]
	 @CUID		    INT
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
SET NOCOUNT ON

SELECT 
       A.CUID
     , B.COM_ID
     , A.USERID 
     , B.REGISTER_NO
     , B.COM_NM
     , B.CEO_NM
     , B.MAIN_PHONE
     , B.FAX
     , B.PHONE
     , B.HOMEPAGE
     , B.REG_DT
     , B.MOD_DT
     , B.CITY
     , B.GU
     , B.DONG
     , B.ADDR1 AS AREA_DETAIL
     , B.ADDR2 AS AREA_DETAIL2
     , B.LAW_DONGNO As LAW_DONGNO
     , B.MAN_NO As MAN_NO
     , B.ROAD_ADDR_DETAIL As ROAD_ADDR_DETAIL
     , B.LAT AS GMAP_X
     , B.LNG AS GMAP_Y
     , B.ZIP_SEQ 
     , B.MEMBER_TYPE
     , ISNULL(C.REG_NUMBER, '') AS REG_NUMBER
  FROM CST_MASTER AS A WITH (NOLOCK)
  JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
  LEFT JOIN CST_COMPANY_LAND AS C WITH (NOLOCK) ON B.COM_ID=C.COM_ID
 WHERE A.CUID = @CUID
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_HISTORY_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 개인회원상세 > 고객관리 현황 입력
 *  작   성   자 : 안상미
 *  작   성   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : 

 *************************************************************************************/


CREATE	PROCEDURE [dbo].[GET_AD_MM_HISTORY_PROC]
	 @CUID		INT
	
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
	
	SELECT	 A.HISTORY_CD
			,A.USERID
			,A.ADUSERNAME
			,CONVERT(CHAR(10),A.REG_DT,120) AS REG_DT
			,A.MEMO
			,A.BRANCHCODE
	  FROM DBO.MM_AD_HISTORY_TB AS A WITH (NOLOCK)
	 WHERE CUID = @CUID
	ORDER BY HISTORY_CD DESC
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_LOGIN_LOG_TB_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 마지막 로그인 기록 가져오기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_MM_LOGIN_LOG_TB_PROC 'SEBILIA'

 *************************************************************************************/
CREATE	PROCEDURE [dbo].[GET_AD_MM_LOGIN_LOG_TB_PROC]
	 @CUID		    INT		-- 회원아이디
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
SET NOCOUNT ON

SELECT 
       TOP 1 
       A.USERID
     , A.SECTION_CD
     , A.LOGIN_DT
     , A.HOST
     , A.IP
  FROM CST_LOGIN_LOG AS A WITH (NOLOCK)
 WHERE A.CUID = @CUID
 ORDER BY LOGIN_DT DESC
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_MEMBER_HISTORY_TB_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 섹션별 수정 로그 기록
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_MM_MEMBER_HISTORY_TB_PROC 'SEBILIA','S101'

 *************************************************************************************/
CREATE	PROCEDURE [dbo].[GET_AD_MM_MEMBER_HISTORY_TB_PROC]
	 @CUID		      INT,	 		-- CUID
	 @SECTION_CD    CHAR(4)
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
SET NOCOUNT ON

SELECT 
       A.REG_DT
     , A.MAG_NAME
     , B.BranchName
     , A.COMMENT
  FROM MM_MEMBER_HISTORY_TB AS A WITH (NOLOCK)
  LEFT JOIN FINDDB2.FINDCOMMON.DBO.Branch AS B WITH (NOLOCK) ON A.MAG_BRANCH=B.BranchCode
 WHERE A.CUID = @CUID
   AND A.SECTION_CD = @SECTION_CD
 ORDER BY PKEY DESC
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_MEMBER_SEARCH_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > Ajax 회원리스트
 *  작   성   자 :
 *  작   성   일 :
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
exec DBO.GET_AD_MM_MEMBER_SEARCH_PROC_BK01 1,10,'C.REGISTER_NO','2208528967'
exec DBO.GET_AD_MM_MEMBER_SEARCH_PROC 1,10,'C.REGISTER_NO','2208528967'
*************************************************************************************/
CREATE PROCEDURE [dbo].[GET_AD_MM_MEMBER_SEARCH_PROC]
	 @PAGE			INT		-- 페이지
	,@PAGESIZE		INT		-- 페이지사이즈
	,@KEY_CLS		VARCHAR(30)	-- 검색키	[아이디:M.USERID, 이름:M.USER_NM, 사업자번호:C.REGISTER_NO, 핸드폰:M.HPHONE , 이메일:M.EMAIL]
	,@KEYWORD		VARCHAR(50)	-- 검색어

AS
  SET NOCOUNT ON
  
	DECLARE	@SQL		NVARCHAR(4000)
	DECLARE	@SQL_PARAM	NVARCHAR(2000)
	DECLARE @WHERE		NVARCHAR(1000)

	SET @SQL = ''
	SET @WHERE = ''
SET @SQL_PARAM ='
	 @PAGE			INT		
	,@PAGESIZE		INT		
	,@KEY_CLS		VARCHAR(30)	
	,@KEYWORD		VARCHAR(50)	
'
----------------------------------------
-- 검색
----------------------------------------
	-- 검색어
--	IF @KEY_CLS <> '' AND @KEYWORD <> ''
--	BEGIN
	
--		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' LIKE @KEYWORD + ''%'' '
--		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' <> '''' '
--	END
-- 2019.04.17 변경

IF @KEY_CLS = 'C.COM_NM' AND @KEYWORD <> ''
 BEGIN
  SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' LIKE @KEYWORD + ''%'' '
 END
 ELSE
 BEGIN
  IF @KEY_CLS <> '' AND @KEYWORD <> ''
  BEGIN
 
   SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' = ' + '''' + @KEYWORD + ''''
   SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' <> '''' '
  END
 END


----------------------------------------
-- 리스트
----------------------------------------
	SET @SQL =	'SELECT COUNT(*) AS CNT '+
				'  FROM	DBO.CST_MASTER M WITH (NOLOCK)'+
				'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
				'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
				' WHERE 1=1 ' + @WHERE + ';' +

				'SELECT TOP (@PAGE * @PAGESIZE) '+
				' M.CUID'+
				',M.USERID'+
				',dbo.FN_GET_USERNM_SECURE(ISNULL(M.USER_NM,''''),1,''M'')+''/''+ISNULL(C.COM_NM,'''') AS NAME'+
				',dbo.FN_GET_USERPHONE_SECURE(ISNULL(M.HPHONE,''''), ''M'') AS HPHONE'+
				',ISNULL(C.REGISTER_NO,'''') AS NUMBER'+
				',M.JOIN_DT'+
				',B.SECTION_CD'+
				',M.MEMBER_CD'+
				',M.OUT_YN'+
				',M.REST_YN'+
				',ISNULL(M.SNS_TYPE,'''') AS SNS_TYPE'+
				',ISNULL(C.MEMBER_TYPE,'''') AS COMPANY_TYPE'+
				',ISNULL(M.STATUS_CD,'''') AS STATUS_CD'+
				',ISNULL(M.MASTER_ID,'''') AS MASTER_ID'+
				',M.BAD_YN'+
			'  FROM	DBO.CST_MASTER M WITH (NOLOCK) '+
			'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
			'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
			' WHERE 1=1 ' + @WHERE +
			'ORDER BY M.JOIN_DT DESC';
--print @sql
EXECUTE SP_EXECUTESQL @Sql,@SQL_PARAM,
	 @PAGE			
	,@PAGESIZE		
	,@KEY_CLS		
	,@KEYWORD		
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_MEMBER_SEARCH_PROC_BK01]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > Ajax 회원리스트
 *  작   성   자 :
 *  작   성   일 :
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
exec DBO.GET_AD_MM_MEMBER_SEARCH_PROC_BK01 1,10,'C.REGISTER_NO','2208528967'
exec DBO.GET_AD_MM_MEMBER_SEARCH_PROC 1,10,'C.REGISTER_NO','2208528967'
*************************************************************************************/
CREATE PROCEDURE [dbo].[GET_AD_MM_MEMBER_SEARCH_PROC_BK01]
	 @PAGE			INT		-- 페이지
	,@PAGESIZE		INT		-- 페이지사이즈
	,@KEY_CLS		VARCHAR(30)	-- 검색키	[아이디:M.USERID, 이름:M.USER_NM, 사업자번호:C.REGISTER_NO, 핸드폰:M.HPHONE , 이메일:M.EMAIL]
	,@KEYWORD		VARCHAR(50)	-- 검색어

AS
  SET NOCOUNT ON
  
	DECLARE	@SQL		NVARCHAR(4000)
	DECLARE	@SQL_PARAM	NVARCHAR(2000)
	DECLARE @WHERE		NVARCHAR(1000)

	SET @SQL = ''
	SET @WHERE = ''
SET @SQL_PARAM ='
	 @PAGE			INT		
	,@PAGESIZE		INT		
	,@KEY_CLS		VARCHAR(30)	
	,@KEYWORD		VARCHAR(50)	
'
----------------------------------------
-- 검색
----------------------------------------
	-- 검색어
	IF @KEY_CLS <> '' AND @KEYWORD <> ''
	BEGIN
	
		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' LIKE @KEYWORD + ''%'' '
		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' <> '''' '
	END


----------------------------------------
-- 리스트
----------------------------------------
	SET @SQL =	'SELECT COUNT(*) AS CNT '+
				'  FROM	DBO.CST_MASTER M WITH (NOLOCK)'+
				'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
				'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
				' WHERE 1=1 ' + @WHERE + ';' +

				'SELECT TOP (@PAGE * @PAGESIZE) '+
				' M.CUID'+
				',M.USERID'+
				',ISNULL(M.USER_NM,'''')+''/''+ISNULL(C.COM_NM,'''') AS NAME'+
				',ISNULL(M.HPHONE,'''') AS HPHONE'+
				',ISNULL(C.REGISTER_NO,'''') AS NUMBER'+
				',M.JOIN_DT'+
				',B.SECTION_CD'+
				',M.MEMBER_CD'+
				',M.OUT_YN'+
				',M.REST_YN'+
				',ISNULL(M.SNS_TYPE,'''') AS SNS_TYPE'+
				',ISNULL(C.MEMBER_TYPE,'''') AS COMPANY_TYPE'+
				',ISNULL(M.STATUS_CD,'''') AS STATUS_CD'+
				',ISNULL(M.MASTER_ID,'''') AS MASTER_ID'+
				',M.BAD_YN'+
			'  FROM	DBO.CST_MASTER M WITH (NOLOCK) '+
			'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
			'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
			' WHERE 1=1 ' + @WHERE +
			'ORDER BY M.JOIN_DT DESC';
--print @sql
EXECUTE SP_EXECUTESQL @Sql,@SQL_PARAM,
	 @PAGE			
	,@PAGESIZE		
	,@KEY_CLS		
	,@KEYWORD		

GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_MEMBER_TB_DETAIL_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원리스트 > 회원 상세
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015.02.15
 *  수   정   자 : 도정민
 *  수   정   일 : 2019.10.01
 *  설        명 : 마케팅·이벤트정보 수신 동의 추가
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC GET_AD_MM_MEMBER_TB_DETAIL_PROC 'SEBILIA'

 *************************************************************************************/

CREATE PROCEDURE [dbo].[GET_AD_MM_MEMBER_TB_DETAIL_PROC]
	@CUID		INT
AS

SET NOCOUNT ON

	SELECT	M.USERID
		,CASE
		      WHEN MEMBER_CD=2 THEN '비즈니스'
		      WHEN MEMBER_CD=1 AND SNS_TYPE='N' THEN '일반(네이버)'
		      WHEN MEMBER_CD=1 AND SNS_TYPE='F' THEN '일반(페이스북)'
		      WHEN MEMBER_CD=1 AND SNS_TYPE='K' THEN '일반(카카오톡)'
		      WHEN MEMBER_CD=1 THEN '일반'
		 END AS MEMBER_CD
		,J.SECTION_CD
		,M.JOIN_DT
		,M.USER_NM
		,M.MOD_DT
		,M.HPHONE
		,CASE
		      WHEN M.DI IS NOT NULL AND M.DI <> '' THEN 'Y' -- DI ='' 인경우 추가
		      ELSE 'N'
		 END AS REAL_CHK_YN
		,M.REST_YN
		,M.EMAIL		
		,M.OUT_YN
	    ,M.BAD_YN
		,M.BIRTH AS JUMINNO	
	    , NULL AS SECTION_CD_ETC
        ,CM.AGREE_DT AS MK_AGREE_DT             -- 20191001 추가 
		,ISNULL(CM.AGREEF,'0') AS MK_AGREEF     -- 20191001 추가
		,CASE
		      WHEN ISNULL(AGENCY_YN, 'N') = 'Y' THEN 'Y' -- 회원가입대행 여부 추가 2021-06-07
		      ELSE 'N'
		 END AS AGENCY_YN
		,ISNULL(LAST_SIGNUP_YN, 'Y') AS LAST_SIGNUP_YN
	  FROM	DBO.CST_MASTER M WITH(NOLOCK)
	  LEFT JOIN CST_JOIN_INFO AS J WITH (NOLOCK) ON M.CUID = J.CUID
	  LEFT OUTER JOIN CST_MARKETING_AGREEF_TB AS CM ON CM.CUID = M.CUID       -- 20191001 추가
	 WHERE	M.CUID = @CUID
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_MSG_AGREE_DETAIL_N1_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원리스트 > 회원 상세 > 메일 및 sms 수신 여부
 *  작   성   자 : 최병찬
 *  작   성   일 : 2011.11.11
 *  수   정   자 : 안상미
 *  수   정   일 : 2008.03.05
 *  설        명 : 이용동의 날짜가 필요하여 이용동의 테이블 JOIN함
 *  주 의  사 항 : 
 *  사 용  소 스 : 

EXEC GET_AD_MM_MSG_AGREE_DETAIL_N1_PROC 11555456
*************************************************************************************/

CREATE	PROCEDURE [dbo].[GET_AD_MM_MSG_AGREE_DETAIL_N1_PROC]
	@CUID		 INT

AS


select 
A.SECTION_CD ,A.SECTION_NM
,max(case when MEDIA_CD='M' then AGREE_DT else null end ) as MAILAGREE_DT
,max(case when MEDIA_CD='S' then AGREE_DT else null end ) as SMSAGREE_DT
,max(case when MEDIA_CD='T' then AGREE_DT else null end ) as TMAGREE_DT
FROM CC_SECTION_TB A LEFT OUTER JOIN CST_MSG_SECTION B WITH(NOLOCK)
ON A.SECTION_CD = B.SECTION_CD AND CUID = @CUID
where      A.SECTION_CD IN ('S101','S102','S103','S104','S105')
GROUP BY A.SECTION_CD ,A.SECTION_NM
ORDER BY A.SECTION_CD


	
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_OUT_DETAIL_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GET_AD_MM_OUT_DETAIL_PROC]
       @CUID    INT
AS

SET NOCOUNT ON

SELECT OUT_APPLY_DT
     , OUT_CAUSE
     , SECTION_CD
  FROM CST_OUT_MASTER AS C WITH (NOLOCK)
 WHERE CUID = @CUID
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_STATISTIC_DAILY_LIST_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 일별 회원리스트
 *  작   성   자 : 여운영
 *  작   성   일 : 2015.09.18
 *  수   정   자 : 
 *  수   정   일 : 2015.11.16
 *  설        명 : 구인부동산 필드추가
 *  주 의  사 항 : 
 *  사 용  소 스 : 
EXEC GET_AD_MM_STATISTIC_DAILY_LIST_PROC 1,15,'2015-09-10'
 *************************************************************************************/
CREATE         PROCEDURE [dbo].[GET_AD_MM_STATISTIC_DAILY_LIST_PROC]
	 @PAGE			INT		      -- 페이지
	,@PAGESIZE		INT		    -- 페이지사이즈
	,@STDATE		VARCHAR(10)=''	-- 시작일	
AS
  SET NOCOUNT ON

	DECLARE	@SQL	NVARCHAR(4000)
	DECLARE @WHERE	NVARCHAR(1000)
	DECLARE @JOIN	NVARCHAR(1000)
	

	SET @SQL = ''
	SET @WHERE = ''
	SET @JOIN = ''

----------------------------------------
-- 검색
----------------------------------------
	-- 날짜
	IF @STDATE = ''
		SET @STDATE =CONVERT(VARCHAR(10),GETDATE()-15,120)
	
	IF @STDATE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND REG_DT >= CAST('''+ @STDATE + ''' AS DATETIME) '
		SET @WHERE = @WHERE + ' AND REG_DT < CAST('''+ @STDATE + ''' AS DATETIME)+15 '
	END



----------------------------------------
-- 리스트
----------------------------------------
	SET @SQL =	'SELECT COUNT(*) AS CNT '+
			'  FROM DBO.MM_STAT_MEMBER_TB M WITH(NOLOCK) ' +
			' WHERE 1 = 1 ' + @WHERE + ';' 
		
	IF @Page  = 0 
		SET @SQL = @SQL + 'SELECT '
	ELSE
		SET @SQL = @SQL + 'SELECT TOP ' + CONVERT(VARCHAR(10),@PAGE * @PAGESIZE) 
	SET @SQL = @SQL +
					' REG_DT
					  ,NEW_JOIN_COMPANY
					  ,NEW_JOIN_PERSON
					  ,OUT_COMPANY
					  ,OUT_PERSON
					  ,TOTAL_MEM_COMPANY
					  ,TOTAL_MEM_PERSON
					  ,NEW_JOIN_JOB
					  ,NEW_JOIN_LAND
					  ,TOTAL_MEM_COMPANY_JOB 
					  ,TOTAL_MEM_COMPANY_LAND
				FROM	DBO.MM_STAT_MEMBER_TB M WITH (NOLOCK)
				WHERE 1 = 1 ' + @WHERE +
				'ORDER BY REG_DT DESC;'

	--PRINT @SQL
	EXECUTE SP_EXECUTESQL @Sql
GO
/****** Object:  StoredProcedure [dbo].[GET_CM_COMPANY_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원DB > 회사 정보 가져오기
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2015/03/13
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
 EXEC GET_CM_COMPANY_INFO_PROC 13821570, 'S102'
 *************************************************************************************/
CREATE PROC [dbo].[GET_CM_COMPANY_INFO_PROC]
  @CUID               INT
, @SECTION_CD             VARCHAR(4)        = ''
AS

BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  /* 회원 개편 후는 아래 주석으로 변경

  IF @SECTION_CD = 'S102'
  BEGIN

    SELECT C.CEO                                  -- 대표자명
         , C.COM_NM                               -- 회사명
         , C.PHONE                                -- 회사전화변호
         , C.CITY                                 -- 시/도
         , C.GU                                   -- 구/군
         , C.DONG                                 -- 동읍면
         , C.ADDR_B AS AREA_DETAIL                -- 상세
         , C.MAIN_BIZ                             -- 주요사업
         , C.EMP_CNT                              -- 직원수
         , C.HOMEPAGE                             -- 홈페이지
         , C.GMAP_X                               -- 지도좌표 X
         , C.GMAP_Y                               -- 지도좌표 Y
         , C.ONESNAME AS MANAGER_NM               -- 담당자
         , M.HPHONE AS MANAGER_PHONE              -- 담당자 연락처
         , M.EMAIL AS MANAGER_EMAIL               -- 담당자 이메일
         , '' AS LOGO_IMG                         -- 회사로고
         , '' AS EX_IMAGE_1                       -- 이미지1
         , '' AS EX_IMAGE_2                       -- 이미지2
         , '' AS EX_IMAGE_3                       -- 이미지3
         , '' AS EX_IMAGE_4                       -- 이미지4
      FROM MEMBER.DBO.MM_COMPANY_TB AS C (NOLOCK)
      JOIN MEMBER.DBO.MM_MEMBER_TB AS M (NOLOCK) ON C.USERID = M.USERID
     WHERE C.USERID = @USER_ID


  END

  */





  IF @SECTION_CD = 'S102'
  BEGIN

    SELECT C.CEO_NM AS CEO              -- 대표자명
         , C.COM_NM                     -- 회사명
         , C.PHONE                      -- 회사전화변호
         , C.CITY                       -- 시/도
         , C.GU                         -- 구/군
         , C.DONG                       -- 동읍면
         , C.ADDR2 AS AREA_DETAIL       -- 상세
         , CM.MAIN_BIZ                  -- 주요사업
         , CM.EMP_CNT                   -- 직원수
         , C.HOMEPAGE                   -- 홈페이지
         , C.LAT AS GMAP_X              -- 지도좌표 X
         , C.LNG AS GMAP_Y              -- 지도좌표 Y
         , CM.MANAGER_NM                -- 담당자
         , CM.MANAGER_PHONE             -- 담당자 연락처
         , CM.MANAGER_EMAIL             -- 담당자 이메일
         , CM.LOGO_IMG                  -- 회사로고
         , CM.EX_IMAGE_1                -- 이미지1
         , CM.EX_IMAGE_2                -- 이미지2
         , CM.EX_IMAGE_3                -- 이미지3
         , CM.EX_IMAGE_4                -- 이미지4
         , C.REGISTER_NO
      FROM MWMEMBER.DBO.CST_MASTER	AS A 
      INNER JOIN MWMEMBER.DBO.CST_COMPANY AS C (NOLOCK) ON A.COM_ID=C.COM_ID
      LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY_JOB AS CM (NOLOCK) ON C.COM_ID = CM.COM_ID
     WHERE A.CUID = @CUID

  END



END


GO
/****** Object:  StoredProcedure [dbo].[GET_CMN_CODE_RETUN_PATH_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 공통코드 리턴 경로 가져오기
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2019/04/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 해당 스토어드 프로시저를 사용하는 asp 파일을 기재한다.
 *  사 용  예 제 : EXEC dbo.GET_CMN_CODE_RETUN_PATH_PROC 1
 *************************************************************************************/


CREATE PROC [dbo].[GET_CMN_CODE_RETUN_PATH_PROC]

  @CODE_ID VARCHAR(10)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT RETURN_PATH
    FROM CMN_CODE
   WHERE CODE_GROUP_ID = 'SERVICE_CD'
     AND USE_YN = 'Y'
     AND CODE_ID = @CODE_ID

GO
/****** Object:  StoredProcedure [dbo].[GET_COMPANY_ETC_EX_IMG_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 기업정보 추가 이미지 불러오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015/3/30
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_COMPANY_ETC_EX_IMG_PROC 'SEBILIA123','S102'
 *************************************************************************************/
CREATE PROC [dbo].[GET_COMPANY_ETC_EX_IMG_PROC]
       @CUID		INT
AS

SET NOCOUNT ON       

SELECT EX_IMAGE_1
     , EX_IMAGE_2
     , EX_IMAGE_3
     , EX_IMAGE_4 
  FROM CST_MASTER AS A WITH (NOLOCK) 
  JOIN CST_COMPANY_JOB AS C WITH (NOLOCK) ON A.COM_ID=C.COM_ID
 WHERE CUID = @CUID

GO
/****** Object:  StoredProcedure [dbo].[GET_COMPANY_ETC_LOGO_IMG_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 기업정보 로고 이미지 불러오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015/3/30
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_COMPANY_ETC_LOGO_IMG_PROC 'SEBILIA123','S102'
 *************************************************************************************/
CREATE PROC [dbo].[GET_COMPANY_ETC_LOGO_IMG_PROC]
       @CUID		INT
AS

SET NOCOUNT ON       

SELECT LOGO_IMG 
  FROM CST_MASTER AS A WITH (NOLOCK) 
  JOIN CST_COMPANY_JOB AS C WITH (NOLOCK) ON A.COM_ID=C.COM_ID
 WHERE CUID = @CUID

GO
/****** Object:  StoredProcedure [dbo].[GET_COMPANY_INFO_EX_IMG_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 기업정보 추가 이미지 불러오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013/8/31
 *  수   정   자 :
 *  수   정   일 :
 *  수 정  내 용 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_COMPANY_INFO_EX_IMG_PROC 'SEBILIA123'
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_COMPANY_INFO_EX_IMG_PROC] 
       @CUID    INT
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT 
		EX_IMAGE_1, EX_IMAGE_2, EX_IMAGE_3, EX_IMAGE_4
	FROM DBO.CST_MASTER	AS A  WITH(NOLOCK)
	LEFT JOIN DBO.CST_COMPANY_JOB AS B  WITH(NOLOCK) ON A.COM_ID=B.COM_ID
	WHERE A.CUID = @CUID

END
GO
/****** Object:  StoredProcedure [dbo].[GET_COMPANY_INFO_LOGO_IMG_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 기업정보 로고 이미지 불러오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013/8/31
 *  수   정   자 :
 *  수   정   일 :
 *  수 정  내 용 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.GET_COMPANY_INFO_LOGO_IMG_PROC 'SEBILIA123'
 *************************************************************************************/
CREATE PROC [dbo].[GET_COMPANY_INFO_LOGO_IMG_PROC]
       @CUID    INT
AS

SET NOCOUNT ON

SELECT TOP 1 B.LOGO_IMG
  FROM MWMEMBER.DBO.CST_MASTER	AS A INNER JOIN MWMEMBER.DBO.CST_COMPANY_LAND AS B ON A.COM_ID=B.COM_ID
 WHERE A.CUID = @CUID


GO
/****** Object:  StoredProcedure [dbo].[GET_CST_BAD_USER_HISTORY]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 불량 유저 처리 히스토리
 *  작   성   자 : 최병찬
 *  작   성   일 : 2017-09-19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 불량 유저 처리 히스토리
 EXEC GET_CST_BAD_USER_HISTORY 12096777

 *************************************************************************************/
CREATE PROC [dbo].[GET_CST_BAD_USER_HISTORY]
@CUID   INT
AS

SET NOCOUNT ON

SELECT CUID, BAD_YN, APP_USER, CONTENTS, APP_DT FROM CST_BAD_USER_HISTORY
 WHERE CUID = @CUID
 ORDER BY SEQ DESC
GO
/****** Object:  StoredProcedure [dbo].[GET_CST_MASTER_SEARCH_BY_PHONE_OR_ID_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 아이디, 전화번호로 회원 검색
 *  작   성   자 :
 *  작   성   일 :
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
exec DBO.GET_CST_MASTER_SEARCH_BY_PHONE_OR_ID_PROC 'M.HPHONE','010-4671-3335'
*************************************************************************************/
CREATE PROCEDURE [dbo].[GET_CST_MASTER_SEARCH_BY_PHONE_OR_ID_PROC]
	@KEY_CLS		VARCHAR(30)	-- 검색키	[아이디:M.USERID, 핸드폰:M.HPHONE]
	,@KEYWORD		VARCHAR(50)	-- 검색어
AS
  SET NOCOUNT ON
  
	DECLARE	@SQL	NVARCHAR(4000)
	DECLARE @WHERE	NVARCHAR(1000)

	SET @SQL = ''
	SET @WHERE = ''

----------------------------------------
-- 검색
----------------------------------------
	-- 검색어
	IF @KEY_CLS <> '' AND @KEYWORD <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' LIKE ''' + @KEYWORD + '%'' '
		SET @WHERE = @WHERE + ' AND ' + @KEY_CLS + ' <> '''' '
	END
----------------------------------------
-- 리스트
----------------------------------------
	SET @SQL = 'SELECT COUNT(M.USERID) AS CNT '+
				'  FROM	DBO.CST_MASTER M WITH (NOLOCK)'+
				'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
				'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
				' WHERE 1=1 ' + @WHERE + ';' +

				' SELECT ' +
				' M.CUID'+
				',M.USERID'+
				',ISNULL(M.USER_NM,'''') AS USER_NM'+
				',ISNULL(C.COM_NM,'''') AS COM_NM'+
				',ISNULL(M.USER_NM,'''')+''/''+ISNULL(C.COM_NM,'''') AS NAME'+
				',ISNULL(M.HPHONE,'''') AS HPHONE'+
				',ISNULL(C.REGISTER_NO,'''') AS NUMBER'+
				',M.JOIN_DT'+
				',B.SECTION_CD'+
				',M.MEMBER_CD'+
				',M.OUT_YN'+
				',M.REST_YN'+
				',ISNULL(M.SNS_TYPE,'''') AS SNS_TYPE'+
				',ISNULL(C.MEMBER_TYPE,'''') AS COMPANY_TYPE'+
				',ISNULL(C.MAIN_PHONE,'''') AS CPHONE'+
			'  FROM	DBO.CST_MASTER M WITH (NOLOCK) '+
			'	LEFT OUTER JOIN DBO.CST_JOIN_INFO B WITH (NOLOCK) ON M.CUID = B.CUID '+
			'	LEFT OUTER JOIN DBO.CST_COMPANY C WITH (NOLOCK) ON M.COM_ID = C.COM_ID '+
			' WHERE 1=1 ' + @WHERE +
			'ORDER BY M.JOIN_DT DESC';
--print @sql
EXECUTE SP_EXECUTESQL @Sql



GO
/****** Object:  StoredProcedure [dbo].[GET_CST_PERSON_HP_DUPLICATE_TB_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 핸드폰 중복 체크 
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-08-17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 :
 
 DECLARE @SS INT
 exec @SS = GET_CST_PERSON_HP_DUPLICATE_TB_PROC 13222380,'010-2139-8258'
 select @SS
 
 go
 DECLARE @SS INT
 exec @SS = GET_CST_PERSON_HP_DUPLICATE_TB_PROC 13222381,'010-2139-8258'
 select @SS
 go
 
 select COUNT(*),
		MAX(ISNULL(B.STAT,0))
		 FROM CST_MASTER A
 	LEFT OUTER JOIN  CST_PERSON_HP_DUPLICATE_TB B WITH(NOLOCK)  ON A.CUID = B.CUID AND B.STAT = 1 AND B.CUID = 13222381
	where A.hphone = '010-2139-8258' AND A.MEMBER_CD = 1

 *************************************************************************************/

CREATE PROC [dbo].[GET_CST_PERSON_HP_DUPLICATE_TB_PROC]
	 @CUID		INT	-- 회원명
	,@HPHONE	varchar(14)
AS
BEGIN
	SET NOCOUNT ON
	-- 기본정보
	DECLARE @CNT VARCHAR(50) = NULL
	DECLARE @STAT INT = 0 
	SELECT 
		@CNT = COUNT(*),
		@STAT = MAX(ISNULL(B.STAT,0))
	 FROM CST_MASTER A WITH(NOLOCK) 
	LEFT OUTER JOIN  CST_PERSON_HP_DUPLICATE_TB B WITH(NOLOCK)  ON A.CUID = B.CUID AND B.STAT = 1 AND B.CUID = @CUID
	where A.hphone = @HPHONE AND A.MEMBER_CD = 1
	
	SET @STAT = CASE WHEN @CNT = 1 THEN 1 ELSE @STAT END 
	--SELECT @CNT, @STAT
	--중복 전화번호 있고 상태값이 0일때는 변경대상
	IF @CNT > 1 AND @STAT = 0 
	BEGIN
		RETURN 1
	END
	ELSE
	BEGIN
		RETURN 0
	END
	 
END
GO
/****** Object:  StoredProcedure [dbo].[GET_CST_REST_MASTER_INFO_BY_USERID_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 휴면회원 기본정보 가져오기(아이디 기준)
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-08-16
 *  설        명 : 
 *  수   정   자 :  
 *  수   정   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 GET_CST_REST_MASTER_INFO_BY_USERID_PROC 'kkam1234'
 
 https://test.member.findall.co.kr/login/userrest_guide.asp
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_CST_REST_MASTER_INFO_BY_USERID_PROC] 

	 @USERID			varchar(50)
AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 기본정보
	SELECT TOP 1
        A.USERID	-- 회원아이디
        ,A.ADD_DT	--휴면전환일
        ,USER_NM
	  FROM CST_REST_MASTER AS A WITH(NOLOCK)
   WHERE A.USERID = @USERID	
     AND A.RESTORATION_DT IS NULL


END





GO
/****** Object:  StoredProcedure [dbo].[GET_CST_REST_MASTER_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 /기업 구분 없이 회원 기본 정보 값 가져 오기
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-08-16
 *  설        명 : 
 *  수   정   자 :  
 *  수   정   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 GET_CST_REST_MASTER_INFO_PROC 'kkam1234','정헌수','19760207','010-3127-3287'
 
 https://test.member.findall.co.kr/login/userrest_infocheck.asp
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_CST_REST_MASTER_INFO_PROC] 

	 @USERID			varchar(50)
	 ,@USERNM			varchar(50)
 	 ,@BIRTH			char(8)
 	 ,@HPHONE			varchar(50)
 

AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 기본정보
	SELECT TOP 1
        A.USERID	-- 회원아이디
        ,A.ADD_DT	--휴면전환일
        ,USER_NM
        ,CUID		
	  FROM CST_REST_MASTER AS A WITH(NOLOCK)
   WHERE A.USERID = @USERID	
		AND USER_NM =@USERNM
		AND replace(HPHONE,'-','') = replace(@HPHONE,'-','') --파생테이블로??
		AND RESTORATION_DT IS NULL 


END





GO
/****** Object:  StoredProcedure [dbo].[GET_CST_SERVICE_USE_AGREE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원 이용동의 여부 조회
 *  작   성   자 : 배진용
 *  작   성   일 : 2021.08.30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : admin - 회원관리 - 회원상세화면
 *  주 의  사 항 : 
 *  사 용  소 스 :
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_CST_SERVICE_USE_AGREE]
	 @CUID		INT

AS
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	-- 이용동의 여부 조회
	SELECT 
				(SELECT MWMEMBER.DBO.FN_SERVICE_USE_AGGRE_SECTION(ISNULL(A.SECTION_CD,''))) AS SECTION_NM ,
				(CASE (SELECT DBO.FN_SERVICE_USE_AGGRE_SECTION(ISNULL(A.SECTION_CD,'')))
					WHEN '벼룩시장'			THEN A.REG_DT
					WHEN '구인구직'			THEN A.REG_DT
					WHEN '부동산'				THEN A.REG_DT
					WHEN '부동산써브'		THEN A.REG_DT
					WHEN '상품/서비스'	THEN A.REG_DT
					WHEN '자동차'				THEN A.REG_DT
					ELSE ''
        END) AS REG_DT
	 FROM MWMEMBER.DBO.CST_SERVICE_USE_AGREE AS A WITH(NOLOCK) 
	 INNER JOIN MWMEMBER.DBO.CC_SECTION_TB  AS B WITH(NOLOCK)
		ON A.SECTION_CD = B.SECTION_CD
	 WHERE CUID = @CUID


GO
/****** Object:  StoredProcedure [dbo].[GET_DUPLICATE_USERID_TB_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 중복아이디 체크 
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-08-17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 2순위 아이디 체크 
 *  주 의  사 항 :
 *  사 용  소 스 :
 *************************************************************************************/

CREATE PROC [dbo].[GET_DUPLICATE_USERID_TB_PROC]
	 @CUID		INT	-- 회원명

AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
	-- 기본정보
	DECLARE @USERID VARCHAR(50) = NULL
	DECLARE @USERID_COUNT INT = 0 
	
	SELECT	@USERID = USERID
		FROM DBO.DUPLICATE_USERID_TB M WITH(NOLOCK)
		WHERE M.CUID = @CUID 
	
	IF @USERID IS NOT NULL 
	BEGIN
		SELECT @USERID_COUNT = COUNT(*) FROM DUPLICATE_USERID_TB WITH(NOLOCK) WHERE USERID = @USERID 
		IF @USERID_COUNT = 2 
		BEGIN
			DELETE DUPLICATE_USERID_TB WHERE CUID = @CUID --우선순위 접속
			UPDATE DUPLICATE_USERID_TB SET ORD = 2 WHERE USERID = @USERID 
			RETURN 0
		END
		ELSE
		BEGIN
			RETURN 1	--후순위 아이디(변경 필요)
		END
	END
	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_AD_COMPANY_DETAIL_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 구인광고 등록 기업정보 조회 팝업
 *  작   성   자 : 김 성 준
 *  작   성   일 : 2013/12/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :	EXEC GET_F_AD_COMPANY_DETAIL_PROC 'calendar72', 262305, 180, 180
										EXEC GET_F_AD_COMPANY_DETAIL_PROC NULL, 55060, 80, 20
exec GET_F_AD_COMPANY_DETAIL_PROC 'kkam1234',default,default,default WITH RECOMPILE
 PG_APP_MAIN_TB

 select top 10 * FROM dbo.PP_LINE_RESUME_APP_VI
 exec GET_F_AD_COMPANY_DETAIL_PROC '',1014407623,18,18
 exec GET_F_AD_COMPANY_DETAIL_PROC '',50758089,80,80
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_F_AD_COMPANY_DETAIL_PROC]
	@CUID INT = NULL
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
		SELECT
	        B.COM_ID AS USERID
	      , B.COM_NM AS COMPANY_NM
	      , B.MAIN_PHONE AS PHONE
	      , C.MANAGER_PHONE AS HPHONE
		    , CASE WHEN B.CEO_NM IS NULL OR B.CEO_NM = '' THEN C. MANAGER_NM ELSE B.CEO_NM END AS CEO
		    , B.HOMEPAGE
		    , C.EMP_CNT
		    , C.MAIN_BIZ
		    , B.CITY
		    , B.GU
		    , B.DONG
		    , B.ADDR1+' '+B.ADDR2 AS ADDR_B
        , CASE WHEN C.LOGO_IMG = '' OR C.LOGO_IMG IS NULL THEN '' ELSE  C.LOGO_IMG END AS LOGO_IMG
        , CASE WHEN C.EX_IMAGE_1 = '' OR C.EX_IMAGE_1 IS NULL THEN '' ELSE  C.EX_IMAGE_1 END AS EX_IMAGE_1
        , CASE WHEN C.EX_IMAGE_2 = '' OR C.EX_IMAGE_2 IS NULL THEN '' ELSE  C.EX_IMAGE_2 END AS EX_IMAGE_2
        , CASE WHEN C.EX_IMAGE_3 = '' OR C.EX_IMAGE_3 IS NULL THEN '' ELSE  C.EX_IMAGE_3 END AS EX_IMAGE_3
        , CASE WHEN C.EX_IMAGE_4 = '' OR C.EX_IMAGE_4 IS NULL THEN '' ELSE  C.EX_IMAGE_4 END AS EX_IMAGE_4
		FROM MWMEMBER.DBO.CST_MASTER	AS A WITH(NOLOCK) 
		INNER JOIN MWMEMBER.DBO.CST_COMPANY AS B WITH(NOLOCK) ON A.COM_ID=B.COM_ID
		LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY_JOB AS C WITH(NOLOCK) ON B.COM_ID = C.COM_ID
   WHERE A.CUID = @CUID

END


GO
/****** Object:  StoredProcedure [dbo].[GET_F_COMPANY_EX_IMAGE_VIEW_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프론트 > 기업회원 이미지 보여주기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013/08/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC GET_F_COMPANY_EX_IMAGE_VIEW_PROC  193887
 *************************************************************************************/

CREATE PROC [dbo].[GET_F_COMPANY_EX_IMAGE_VIEW_PROC]
  @CUID       INT
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT EX_IMAGE_1
        ,EX_IMAGE_2
        ,EX_IMAGE_3
        ,EX_IMAGE_4
    FROM MWMEMBER.dbo.CST_MASTER A WITH (NOLOCK)
    LEFT JOIN MWMEMBER.dbo.CST_COMPANY_JOB B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
   WHERE CUID=@CUID
GO
/****** Object:  StoredProcedure [dbo].[GET_F_COMPANY_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************  
 *  단위 업무 명 : 기업서비스 홈 > 기업정보 불러오기  
 *  작   성   자 : 최 병찬  
 *  작   성   일 : 2013/08/12  
 *  수   정   자 : 정헌수  
 *  수   정   일 : 2015-04-20  
 *  설        명 : RPC CALL 로 변경  
 *  주 의  사 항 :  
 *  사 용  소 스 : 기업서비스 홈  
 *  사 용  예 제 : EXEC DBO.GET_F_COMPANY_INFO_PROC 14129771  
 *************************************************************************************/  
CREATE PROC [dbo].[GET_F_COMPANY_INFO_PROC]  
  @CUID INT  
AS  
  
SET NOCOUNT ON  
  
  SELECT TOP 1 B.CEO_NM  AS CEO                -- 대표자명  
       , B.REGISTER_NO  AS  BIZNO                    -- 사업자번호  
       , B.COM_NM                     -- 회사명  
       , replace(B.MAIN_PHONE,' ','')  AS PHONE1      -- 회사전화변호  
       , B.CITY                       -- 시/도  
       , B.GU                         -- 구/군  
       , B.DONG                       -- 동읍면  
       --, B.ADDR1 + ' ' + B.ADDR2 AS AREA_DETAIL                -- 상세  
       , B.ADDR1 AS AREA_DETAIL                -- 상세  
       , C.MAIN_BIZ                  -- 주요사업  
       , C.EMP_CNT                   -- 직원수  
       , B.HOMEPAGE                   -- 홈페이지  
       , B.LAT AS GMAP_X                     -- 지도좌표 X  
       , B.LNG AS GMAP_Y                     -- 지도좌표 Y  
       , C.MANAGER_NM AS ONESNAME    -- 담당자  
       , C.MANAGER_PHONE AS PHONE2   -- 담당자 연락처  
       , C.MANAGER_EMAIL AS EMAIL    -- 담당자 이메일  
       , C.LOGO_IMG                  -- 회사로고  
       , C.EX_IMAGE_1                -- 이미지1  
       , C.EX_IMAGE_2                -- 이미지2  
       , C.EX_IMAGE_3                -- 이미지3  
       , C.EX_IMAGE_4                -- 이미지4  
			 , ISNULL(B.ADDR2, '') AS AREA_DETAIL2      -- 상세2
    FROM MWMEMBER.dbo.CST_MASTER AS A  
    JOIN MWMEMBER.dbo.CST_COMPANY AS B ON B.COM_ID = A.COM_ID  
    LEFT JOIN MWMEMBER.dbo.CST_COMPANY_JOB AS C ON C.COM_ID = B.COM_ID  
   WHERE A.USERID NOT IN ('a2013', 'NoMember')      -- NoMember : 비회원 계정, a2013 : 간편구인등록 등록대행 계정  
     AND A.CUID NOT IN (1001, 1002)  
     AND A.CUID = @CUID  
  
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[GET_F_CST_SERVICE_USE_AGREE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 공통 > 서비스이용동의 여부 확인
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2018/10/01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 서비스 이용동의가 되어있으면 1, 안되어있으면 0
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_F_CST_SERVICE_USE_AGREE_PROC 1111, 'S102'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_CST_SERVICE_USE_AGREE_PROC]

  @CUID INT = 0
  ,@SECTION_CD	CHAR(4)       -- 섹션코드 (CC_SECTION_TB 참고)

  ,@RTN_VALUE TINYINT OUTPUT

AS

  SET NOCOUNT ON

  SET @RTN_VALUE = 0

  IF EXISTS(SELECT *
              FROM CST_SERVICE_USE_AGREE WITH(NOLOCK)
             WHERE SECTION_CD = @SECTION_CD
               AND CUID = @CUID)
    BEGIN
      SET @RTN_VALUE = 1
    END

    --PRINT   @RTN_VALUE
GO
/****** Object:  StoredProcedure [dbo].[GET_F_CYBER_MEMBER_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 사이버 벼룩시장 - 프론트 > 회원정보
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/05/28
 *  수   정   자 : 신장순
 *  수   정   일 : 2014.05.20
 *  설        명 : POST 사용안함, ADDR_A 사용안함 (CITY, GU, DONG 으로 변경)
 *  주 의  사 항 :
 *  사 용  소 스 : /advitiser/cyber/Cyber_ApplyProcess_02.asp
 *  사 용  예 제 : EXEC DBO.GET_F_CYBER_MEMBER_INFO_PROC 'jjangssoon'
 *************************************************************************************/


CREATE PROC [dbo].[GET_F_CYBER_MEMBER_INFO_PROC]

  @CUID       INT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT A.USER_NM AS USERNAME
        ,'' AS PHONE
        ,A.HPHONE
        ,'' AS METRO
        ,'' AS CITY
        ,'' AS DONG
        ,'' AS HOMEPAGE
        ,A.EMAIL
    FROM MWMEMBER.dbo.CST_MASTER AS A
   WHERE A.CUID = @CUID




GO
/****** Object:  StoredProcedure [dbo].[GET_F_JOB_CARE_MEMBER_SEND_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 미디어윌 케어 회원정보 연동
 *  작   성   자 : 조재성
 *  작   성   일 : 2021-06-28
 *  설        명 : 미디어윌 케어 회원정보 연동
 *  주 의  사 항 :
 *  사 용  소 스 : EXEC GET_F_JOB_CARE_MEMBER_SEND_INFO_PROC '20210630','20210630'
************************************************************************************/
create  PROC [dbo].[GET_F_JOB_CARE_MEMBER_SEND_INFO_PROC]
       @STARTDATE	VARCHAR(8)
	   ,@ENDDATE	VARCHAR(8)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT
		ROW_NUMBER() OVER (ORDER BY A.IDX ASC) AS cnt
		,B.USER_NM unm
		,B.HPHONE unum
		,CONVERT(CHAR(8),A.REG_DT,112) cdate
FROM CST_CARE_PROVIDE_MEMBER_TB A
	INNER JOIN CST_MASTER B ON A.CUID=B.CUID
	INNER JOIN CST_MARKETING_AGREEF_TB C ON A.CUID=C.CUID
WHERE C.AGREEF='1'
	AND A.REG_DT BETWEEN @STARTDATE AND @ENDDATE + ' 23:59:59'

GO
/****** Object:  StoredProcedure [dbo].[GET_F_JOB_COMPANY_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013-03-04
 *  수   정   자 : 김 준 홍
 *  수   정   일 : 2015-06-17
 *  수   정      : @P_IDCODE 변수의 데이터타입을 int 에서 char(6)으로 변경함
 *  설        명 : 회원가입 및 ID 찾기 핸드폰 인증 번호 확인
 *  주 의  사 항 :
 *  사 용  소 스 :
 EXEC DBO.CHK_MM_HP_AUTH_CODE_PROC '1','김준홍2','19790522','M','01020500865','','053413','R','','' 
 select top 10 * from MM_HP_AUTH_CODE_TB where username = '김준홍2' order by dt desc
 SELECT * FROM CST_MASTER WHERE USERID = 'cowto7602'
 GET_F_JOB_COMPANY_INFO_PROC 10621983
 exec [dbo].[GET_F_JOB_COMPANY_INFO_PROC] @CUID=13924991
************************************************************************************/
CREATE  PROC [dbo].[GET_F_JOB_COMPANY_INFO_PROC]

  @CUID  INT
     
AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT B.CEO_NM AS CEO              -- 대표자명
       , B.REGISTER_NO AS BIZNO       -- 사업자번호
       , B.COM_NM                     -- 회사명
       , B.MAIN_PHONE AS PHONE1       -- 회사전화변호
       , B.CITY                       -- 시/도
       , B.GU                         -- 구/군
       , B.DONG                       -- 동읍면
       , B.ADDR1 AS AREA_DETAIL       -- 상세
       , C.MAIN_BIZ                   -- 주요사업
       , C.EMP_CNT                    -- 직원수
       , B.HOMEPAGE                   -- 홈페이지
       , B.LAT AS GMAP_X              -- 지도좌표 X
       , B.LNG AS GMAP_Y              -- 지도좌표 Y
       , C.MANAGER_NM AS ONESNAME     -- 담당자
       , C.MANAGER_PHONE AS PHONE2    -- 담당자 연락처
       , C.MANAGER_EMAIL AS EMAIL     -- 담당자 이메일
       , C.LOGO_IMG                   -- 회사로고
       , C.EX_IMAGE_1                 -- 이미지1
       , C.EX_IMAGE_2                 -- 이미지2
       , C.EX_IMAGE_3                 -- 이미지3
       , C.EX_IMAGE_4                 -- 이미지4
       , B.FAX
			 , ISNULL(B.ADDR2, '') AS AREA_DETAIL2      -- 상세2
    FROM MWMEMBER.dbo.CST_MASTER AS A (NOLOCK)
    JOIN MWMEMBER.dbo.CST_COMPANY AS B (NOLOCK) ON B.COM_ID = A.COM_ID
    LEFT JOIN MWMEMBER.dbo.CST_COMPANY_JOB AS C ON B.COM_ID = C.COM_ID
   WHERE A.CUID = @CUID
     -- AND C.SECTION_CD = 'S102'
     
     
END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MARKETING_AGREE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅.이벤트 수신동의 여부
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2018/12/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
   -- 마케팅 이용동의 회원 가져오기
   SELECT * FROM CST_MASTER AS A JOIN CST_MARKETING_AGREEF_TB AS B ON B.CUID = A.CUID WHERE B.AGREEF = 1
 *************************************************************************************/

 --GET_F_MARKETING_AGREE_PROC 111, 0

CREATE PROC [dbo].[GET_F_MARKETING_AGREE_PROC]

  @CUID INT
  ,@RETURN INT OUTPUT   -- 0: 미동의, 1: 동의, 99: 동의여부안함

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON



	SELECT @RETURN = B.AGREEF
	FROM CST_MASTER AS A WITH(NOLOCK)
	  JOIN CST_MARKETING_AGREEF_TB AS B WITH(NOLOCK) ON B.CUID = A.CUID
	WHERE A.CUID = @CUID

	set @RETURN = ISNULL (@RETURN,99)
	-- 이용동의 여부를 선택하지 않은 경우 99 리턴



GO
/****** Object:  StoredProcedure [dbo].[GET_F_MEMBER_CHECK_ROLE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 공통 > 회원정보값 비교
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2019/01/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 *************************************************************************************/

 
CREATE PROC [dbo].[GET_F_MEMBER_CHECK_ROLE_PROC]

  @CUID         INT

  ,@USER_NM     VARCHAR(30)
  ,@BIRTH       VARCHAR(8)
  ,@GENDER      CHAR(1)
  ,@HPHONE VARCHAR(14)
  ,@DI          VARCHAR(70)

  ,@RESULT INT = 999 OUTPUT


AS

  SET NOCOUNT ON

  SET @HPHONE = REPLACE(@HPHONE,'-','')

  DECLARE @VAL_DI CHAR(64)
  DECLARE @VAL_MEMBER_CD CHAR(1)
  DECLARE @VAL_SNSF CHAR(1)
  DECLARE @VAL_USER_NM VARCHAR(30)
  DECLARE @VAL_BIRTH VARCHAR(8)
  DECLARE @VAL_HPHONE VARCHAR(14)
  DECLARE @VAL_GENDER CHAR(1)

  -- 기존 정보
  SELECT @VAL_DI = DI
        ,@VAL_USER_NM = USER_NM
        ,@VAL_MEMBER_CD = MEMBER_CD
        ,@VAL_SNSF = CASE ISNULL(SNS_TYPE,'') WHEN '' THEN '0'
                          ELSE '1'
                          END
        ,@VAL_BIRTH   = BIRTH
        ,@VAL_HPHONE  = REPLACE(HPHONE,'-','')
        ,@VAL_GENDER  = GENDER
    FROM CST_MASTER
   WHERE CUID = @CUID

  -- 성별값 치환
  IF @GENDER = '1'
    BEGIN
      SET @GENDER = 'M'
    END
  ELSE IF  @GENDER = '2'
    BEGIN
      SET @GENDER = 'F'
    END

  IF @VAL_SNSF = '1'    -- SNS 회원인 경우
    BEGIN
      IF @VAL_HPHONE <> @HPHONE
        BEGIN
          SET @RESULT = 1     -- 휴대폰 번호가 회원정보와 일치하지 않습니다. 휴대폰 번호 변경은 회원정보수정에서 가능합니다.
          RETURN
        END
    END

  IF @VAL_MEMBER_CD = '1' AND @VAL_SNSF = '0'    -- SNS 회원인 경우
    BEGIN
      -- IF (@VAL_USER_NM != @USER_NM OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
	  IF (@VAL_USER_NM != @USER_NM OR @VAL_HPHONE != @HPHONE) --2020.02.14 
        BEGIN
          SET @RESULT = 2     -- 인증정보가 회원정보와 일치하지 않습니다.회원정보수정에서 정보를 확인해 주세요.
          RETURN
        END
    END

  IF @VAL_MEMBER_CD = '2'
    BEGIN
      -- IF (@VAL_USER_NM != @USER_NM OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE) 
	  IF (@VAL_USER_NM != @USER_NM OR @VAL_HPHONE != @HPHONE) --2020.02.14 
        BEGIN
          SET @RESULT = 3     -- 인증정보가 회원정보와 일치하지 않습니다. 회원정보수정에서 정보를 확인해 주세요.
          RETURN
        END
    END

  SET @RESULT = 0     -- 이상무
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MEMBERINFO_SSO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력 (SS0 전용)
 *  작   성   자 : 최봉기
 *  작   성   일 : 2018-12-27
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :  @PWD를 평문이 아닌 MD
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
  DECLARE @RET INT
  EXEC @RET=SP_LOGIN 'mwmobile01','11111111' , 'S101' ,'IP','HOST'
  SELECT @RET  -- 성공
  declare @DUPLICATE_YN INT 
  		EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160
	SELECT @DUPLICATE_YN
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_F_MEMBERINFO_SSO_PROC]
  @USERID VARCHAR(50) 
  ,@PWD CHAR(32)
  ,@SECTION_CD CHAR(4)
  ,@IP VARCHAR(15)
  ,@HOST VARCHAR(50)
AS
	SET NOCOUNT ON;
	DECLARE  
		@CUID INT
		,@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)
		,@ISADULT  CHAR(1)
		,@JOIN_DT VARCHAR(10)
		,@REALHP_YN	CHAR(1)
		,@ROWCOUNT INT
		,@LAND_CLASS_CD VARCHAR(30)
		,@REST_DT VARCHAR(10)
		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = ISNULL(AA.USER_NM,''),
			@EMAIL = ISNULL(AA.EMAIL,''),
			@HPHONE = ISNULL(AA.HPHONE,''),
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = ISNULL(AA.COM_NM,''),
			@CONFIRM_YN = AA.CONFIRM_YN,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = AA.REALHP_YN,
			@LAND_CLASS_CD = AA.LAND_CLASS_CD,
			@REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END)
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			ISNULL(M.ADULT_YN,'N') AS ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'N') AS REALHP_YN,
			CL.LAND_CLASS_CD,
			M.REST_DT
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
			 LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID
		WHERE M.OUT_YN='N'
		  AND M.USERID = @USERID 
      	  AND pwd_sha2 = master.DBO.fnGetStringToSha256(@PWD)
			AND (M.STATUS_CD <> 'D' OR M.STATUS_CD IS NULL) --2018.01.26 추가
		) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/			
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음
		set @ROWCOUNT = @@ROWCOUNT
		
		
		IF @ROWCOUNT = 0 
		BEGIN
			IF EXISTS(SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @USERID) 
			BEGIN
			INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									  (@CUID ,@USERID, getdate(), @SECTION_CD,'N', @IP, @HOST)
			RETURN(200) -- 비밀 번호 틀림
			END
		END 
		ELSE IF @ROWCOUNT <> 2 
		BEGIN 
			/* 2순위 계정 체크 시작 {계정 변환 로직으로 ~!!! 300 }*/
			EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC @CUID
			IF @DUPLICATE_YN = 1
			BEGIN
				SET @COUNT = 3
			END
			/* 2순위 계정 체크  끝*/
		END 
		
		IF @REST_YN = 'Y' AND @ROWCOUNT <> 2  -- 중복회원 체크가 우선 
		BEGIN
			RETURN(500) -- 휴면 고객
		END ELSE IF @CUID IS NULL
		BEGIN
			INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									  (@CUID,@USERID,getdate(),@SECTION_CD,'N', @IP, 'ERR')    -- 로그인 이력 남기기
		
			RETURN(400) -- 사용자가 없음
		END ELSE IF @COUNT > 1 
		BEGIN 
			IF @COUNT = 3 
			BEGIN
			  SELECT 
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				ISNULL(@GENDER,'') AS GENDER,
				@REST_YN AS REST_YN,
				ISNULL(@BIRTH,'') AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				'N' AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAD_YN,
				ISNULL(@DI,'') AS DI,
				ISNULL(@ISADULT,'') AS ISADULT,
				'' AS SNSTYPE,
				@JOIN_DT AS JOIN_DT,
				ISNULL(@REALHP_YN,'') as REALHP_YN

				RETURN(300) -- 2순위 아이디
			END
			ELSE
			BEGIN -- @COUNT = 2
				RETURN(900) -- 복수의 아이디(아이디/비번 중복됨)
			END
		END ELSE IF @COUNT = 1
		BEGIN 
			SET @PWD_CHANGE_YN = 'N'
			IF @PWD_NEXT_ALARM_DT < GETDATE() SET @PWD_CHANGE_YN = 'Y'

			/*전화번호 중복 alert 확인용*/
			IF @MEMBER_CD  = 1  AND ISNULL(@REALHP_YN,'N') <> 'Y'
			BEGIN
				SELECT @DUPLICATE_PHONE = COUNT(*) 
				FROM CST_MASTER WITH(NOLOCK) 
				where HPHONE = @HPHONE and MEMBER_CD = 1 

				IF @DUPLICATE_PHONE  > 1 
				BEGIN
					SET @REALHP_YN ='N'
					SET @DUPLICATE_PHONE = 1
				END 
				ELSE BEGIN
					SET @REALHP_YN ='Y'
					SET @DUPLICATE_PHONE = 0
				END

			END
			ELSE 
			BEGIN
				SET @REALHP_YN = 'Y'
			END
			
      /*순서 변경하지 마세요. 뒷부분에 추가*/
			SELECT
				-- @COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				ISNULL(@GENDER,'') AS GENDER,
				@REST_YN AS REST_YN,
				ISNULL(@BIRTH,'') AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAD_YN,
				ISNULL(@DI,'') AS DI,
				ISNULL(@ISADULT,'') AS ISADULT,
				'' AS SNSTYPE,
				@JOIN_DT AS JOIN_DT,
				ISNULL(@REALHP_YN,'') as REALHP_YN
        
				INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									  (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기
									  
			RETURN(0) -- 정상 정상
		END	
		
		
GO
/****** Object:  StoredProcedure [dbo].[GET_F_MM_MEMBER_TB_SIMPLE_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************
* Description
*
*  내용 : 이력서 등록 개인 심플 정보
*  EXEC : DBO.GET_F_MM_MEMBER_TB_SIMPLE_INFO_PROC 'test'
*********************************************************************/
/*********************************************************************
* Work History
*
* 1) 정태운(2010/12/07) : 신규작성
* 2) 신장순(2014/04/20) : 수정 - POST 사용안함, ADDR_A 사용안함 (CITY, GU, DONG 으로 변경)
*********************************************************************/
CREATE    PROCEDURE [dbo].[GET_F_MM_MEMBER_TB_SIMPLE_INFO_PROC]
(
		@CUID			INT
)
AS
SET NOCOUNT ON

  --참여자 기본 정보
  SELECT TOP 10 A.USER_NM
       , A.BIRTH AS JUMINNO_A
       , A.GENDER
       , '' AS PHONE	--A.PHONE
       , A.HPHONE
       , A.EMAIL
       , '' AS 'POST'
       , (CASE A.MEMBER_CD WHEN 2 THEN 
           (SELECT ISNULL(CITY, '') + ' ' + ISNULL(GU, '') + ' ' + ISNULL(DONG, '') FROM CST_COMPANY WITH(NOLOCK) WHERE COM_ID = A.COM_ID) 
          END) AS 'ADDR_A'
       , (CASE A.MEMBER_CD WHEN 2 THEN
            (SELECT CASE WHEN CITY IS NULL AND GU IS NULL AND DONG IS NULL THEN '' ELSE ADDR1 END FROM CST_COMPANY WITH(NOLOCK)  WHERE COM_ID = A.COM_ID)
          END) AS 'ADDR_B'
       , A.REALHP_YN
    FROM CST_MASTER AS A WITH(NOLOCK) 
   WHERE CUID = @CUID
GO
/****** Object:  StoredProcedure [dbo].[GET_F_NEWS_LETTER_SEND_LIST_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************  
 *  단위 업무 명 : [마케팅 전략실] 개인회원 대상 뉴스레터 발송 데이터 추출 
 *  작   성   자 : 이 현 석
 *  작   성   일 : 2020/12/16  
 *  수   정   자 :
 *  수   정   일 :   
 *  설        명 :
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC MWMEMBER.DBO.GET_F_NEWS_LETTER_SEND_LIST_PROC
 *************************************************************************************/  
CREATE PROC [dbo].[GET_F_NEWS_LETTER_SEND_LIST_PROC]  
 
AS   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON
 
             SELECT A.CUID
                     , A.USERID
                     , A.USER_NM
                     , A.EMAIL
             FROM MWMEMBER.DBO.CST_MASTER A WITH(INDEX=PK_CST_MASTER)
       INNER JOIN MWMEMBER.DBO.CST_MARKETING_AGREEF_TB B WITH(INDEX=PK_CST_MARKETING_AGREEF_TB) ON B.CUID=A.CUID
            WHERE A.REST_YN='N' --- 휴면회원 제외
	            AND A.OUT_YN='N'  --- 탈퇴회원 제외
              AND A.BAD_YN='N'  --- 불량회원 제외
	            AND A.MEMBER_CD = 1 --- 1.개인회원 2.기업회원
              AND B.AGREEF=1    --- 수신동의 및 마케팅 동의 1 비동의 0
	            AND A.EMAIL NOT IN ('@','', '@gmail.com', '@naver.com')
	            AND A.EMAIL NOT LIKE ('%@%@%@%')
	            AND A.EMAIL NOT LIKE ('%@%@%')
	            AND A.EMAIL NOT LIKE ('.%@%')
	            AND A.EMAIL NOT LIKE (',%@%')
         ORDER BY A.CUID ASC 
  
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[GET_F_PP_AD_AGREE_EMAIL_RECEIVE_LIST_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅,이벤트 정보 수신 동의 안내 메일 대상자 목록
 *  작   성   자 : 조재성
 *  작   성   일 : 2021/03/23
 *  수   정   자 :
 *  수   정   일 :
 *  설         명 : 
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : GET_F_PP_AD_AGREE_EMAIL_RECEIVE_LIST_PROC
 *************************************************************************************/ 
CREATE PROCEDURE [dbo].[GET_F_PP_AD_AGREE_EMAIL_RECEIVE_LIST_PROC]
AS	

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
	
	SELECT	A.CUID
			,(CASE WHEN CHARINDEX('%',B.USER_NM) > 0 THEN B.USERID ELSE B.USER_NM END) USER_NM
			,B.EMAIL
			,(CASE WHEN A.MAILSEND_DT IS NULL OR A.AGREE_DT > A.MAILSEND_DT THEN A.AGREE_DT ELSE A.MAILSEND_DT END) AGREE_DT
	FROM CST_MARKETING_AGREEF_TB A 
		INNER JOIN CST_MASTER B
			ON A.CUID = B.CUID
	WHERE
			A.AGREEF = '1'
		AND B.REST_YN = 'N'
		AND B.OUT_YN = 'N'
		AND (B.EMAIL IS NOT NULL AND B.EMAIL <> '')
		AND DATEADD(D,730,(CASE WHEN A.MAILSEND_DT IS NULL OR A.AGREE_DT > A.MAILSEND_DT THEN A.AGREE_DT ELSE A.MAILSEND_DT END)) < CONVERT(CHAR(10),GETDATE(),21) + ' 23:59:59'

		
GO
/****** Object:  StoredProcedure [dbo].[GET_F_REGIST_PHONENUMBER_CONFIRM_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 특정사용자 체크
 *  작   성   자 : 황민수
 *  작   성   일 : 2020-04-06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 특정사용자 번호 체크
 -- RETURN(0) -- 성공
 -- RETURN(500) -- 실패
 
 [dbo].[GET_F_REGIST_PHONENUMBER_CONFIRM_PROC] '010-1234-5678', '010-7890-1234', 0

 010-9704-5466, 010-9549-1908, 010-9704-5466
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GET_F_REGIST_PHONENUMBER_CONFIRM_PROC]
@TS_PHONE1 varchar(15), -- 대표번호
@TS_PHONE2 varchar(15) -- 담당자번호
,@RESULT TINYINT OUTPUT     -- 결과 (0: 비매칭, 1: 매칭)
AS	
BEGIN
	SET NOCOUNT ON;

	DECLARE @RESULTCOUNT INT

	SELECT @RESULTCOUNT = COUNT(*) 
	  FROM MM_BAD_HP_TB WITH(NOLOCK)
	WHERE HP IN (REPLACE(@TS_PHONE1,'-',''), REPLACE(@TS_PHONE2,'-',''))

	IF @RESULTCOUNT > 0 
	BEGIN
		SET @RESULT = 1  -- 매칭
	END
	ELSE 
	BEGIN
		SET @RESULT = 0  -- 비매칭
	END

	PRINT @RESULT

END
GO
/****** Object:  StoredProcedure [dbo].[GET_F_SNS_MEMBER_REG_CHK_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 프론트 > SNS 회원가입 여부 확인
 *  작   성   자 : 최승범
 *  작   성   일 : 2016.08.12
 *  수   정   자 : 배진용
 *  수   정   일 : 2021-02-04
 *  설        명 : SNS_ID 길이 수정
 *  주 의  사 항 : 
 *  사 용  소 스 : 

 *************************************************************************************/
CREATE PROC [dbo].[GET_F_SNS_MEMBER_REG_CHK_PROC]
       @SNS_TYPE  CHAR(1)='N'
     , @SNS_ID    VARCHAR(100)
AS
     
DECLARE @COUNT INT
     
SELECT @COUNT = COUNT(*) 
  FROM CST_MASTER WITH (NOLOCK)
 WHERE SNS_TYPE = @SNS_TYPE
   AND SNS_ID = @SNS_ID
   AND OUT_YN='N'
   
IF @COUNT=1 
BEGIN
  RETURN 1
END   
ELSE
BEGIN
  RETURN 100
END
GO
/****** Object:  StoredProcedure [dbo].[GET_M_BRAND_DATA_REG_MEMBER_ID_OVERLAP_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 구인관리자 > 브랜드 일괄 등록 > 회원 아이디 중복 확인
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2015/07/27
 *  수   정   자 :
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC GET_M_BRAND_DATA_REG_MEMBER_ID_OVERLAP_PROC
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_BRAND_DATA_REG_MEMBER_ID_OVERLAP_PROC]
AS 
  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

  DECLARE @RESULT CHAR(1)
  DECLARE @CNT INT

  SET @RESULT = '0'


  SELECT @CNT = COUNT(*)
    FROM CST_MASTER
   WHERE USERID IN (SELECT USERID FROM TEMP_REG_BIZMEMBER_TB)
              
  IF @CNT > 0
  BEGIN
    SET @RESULT = '2'
  END
  ELSE
  BEGIN
    SET @RESULT = '1'
  END
  
  SELECT @RESULT
  
  IF @RESULT = '2'
  BEGIN
    SELECT USERID
      FROM CST_MASTER
     WHERE USERID IN (SELECT USERID FROM TEMP_REG_BIZMEMBER_TB)
  END
END
GO
/****** Object:  StoredProcedure [dbo].[GET_M_E_CS_STAT]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 
 *  작   성   자 : 최 승 범
 *  작   성   일 : 2017/02/10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC MWMEMBER.DBO.GET_M_E_CS_STAT '2016-02-01','','F'
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_E_CS_STAT]
	@START_DT VARCHAR(10) = ''	-- 기간 선택 시작 strStartDate
	,@END_DT VARCHAR(10) = ''	-- 기간 선택 끝 strEndDate
	,@SITECODE VARCHAR(5) =''
AS
SET NOCOUNT ON

	DECLARE	@SQL	NVARCHAR(4000)
	DECLARE @SQL_WHERE NVARCHAR(2000)
	DECLARE @SQL_WHERE2 NVARCHAR(1000)
	
	SET @SQL = ''
	SET @SQL_WHERE = ''
	SET @SQL_WHERE2 = ''
	
	IF @START_DT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND REGDATE >= CONVERT(DATETIME, ''' + @START_DT + ''') '
	END
	
    IF @END_DT <> ''
	BEGIN
		SET @SQL_WHERE = @SQL_WHERE + ' AND REGDATE <= CONVERT(DATETIME, ''' + @END_DT + ''')'
	END
	
	IF @SITECODE <> ''
	BEGIN
		SET @SQL_WHERE2 = ' AND SITECODE='''+@SITECODE+''' '
	END

	SET @SQL =	'SELECT '+
				'GROUP_CODE, '+
				'MAX(CSCODENAME) AS CSCODENAME,  '+
				'MAX(CALLCODENAME) AS CALLCODENAME,  '+
				'MAX(CODE_DESC) AS CODE_DESC,  '+
				'MAX(ISNULL([04],0)) AS [기업회원], '+
				'MAX(ISNULL([05],0)) AS [개인회원], '+
				'MAX(ISNULL([06],0)) AS [비회원], '+
				'MAX(ISNULL([07],0)) AS [지점사문의],  '+
				'MAX(ISNULL(TOTAL_COUNT,0)) AS TOTAL_COUNT '+
				'FROM( '+
				'	SELECT A.GROUP_CODE, A.CSCODENAME, A.CALLCODENAME, A.CODE_DESC, A.MEMBERCODE, ISNULL(B.[COUNT],0) AS [COUNT], ISNULL(B.[SUM],0) AS TOTAL_COUNT '+
				'	FROM [MWMEMBER].[dbo].[TBL_CSCODE] AS A '+
				'	LEFT OUTER JOIN ( '+
				'			SELECT CASE WHEN MEMBERCLASS IN (1,3,6) THEN ''04'' WHEN MEMBERCLASS = 2 THEN ''05'' WHEN MEMBERCLASS IN (4,7) THEN ''07''  '+
				'			WHEN MEMBERCLASS = 5 THEN ''06'' ELSE '''' END AS MEMBERCODE ,  '+
				'			CS_CODE, CALL_CODE, COUNT(*) AS [COUNT], GROUP_CODE ,  '+
				'			( '+
				'			SELECT COUNT(*)  '+
				'			FROM [MWMEMBER].[dbo].[TBL_CALLMASTER] AS A1 '+
				'			INNER JOIN [MWMEMBER].[dbo].[TBL_CSCODE] AS B1  '+
				'			ON A1.CALL_CODE=B1.CALLCODE '+
				'			WHERE  B1.GROUP_CODE = B.GROUP_CODE ' + @SQL_WHERE + @SQL_WHERE2 +
				'			) AS [SUM] '+
				'			FROM [MWMEMBER].[dbo].[TBL_CALLMASTER] AS A '+
				'			INNER JOIN [MWMEMBER].[dbo].[TBL_CSCODE] AS B '+
				'			ON A.CALL_CODE=B.CALLCODE '+
				'			WHERE 1=1 ' + @SQL_WHERE + @SQL_WHERE2 +
				'			GROUP BY MEMBERCLASS, CS_CODE, CALL_CODE, B.GROUP_CODE '+
				'			) AS B '+
				'	ON A.MEMBERCODE = B.MEMBERCODE AND A.GROUP_CODE = B.GROUP_CODE '+
				'	WHERE 1=1 ' + @SQL_WHERE2 +
				') T '+
				'PIVOT ( SUM([COUNT]) FOR MEMBERCODE IN ([04],[05],[06],[07]) ) AS PVT '+
				'GROUP BY GROUP_CODE ';
	
				print @Sql
				EXECUTE SP_EXECUTESQL @Sql



GO
/****** Object:  StoredProcedure [dbo].[GET_M_JOIN_SEARCH_LIST_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 관리자 - 등록대행 - 공고등록 - ************************************
 *  단위 업무 명 : 관리자 - 등록대행 - 공고등록 - 기업회원 가입여부 조회
 *  작   성   자 : 배진용
 *  작   성   일 : 2020/12/03
 *  설		  명 : 탈퇴(OUT_YN = 'N')가 아니고 휴면(REST_YN = N)이 아니고 일반회원(MEMBER_TYPE = 1)이면서 기업 회원(MEMBER_CODE = 2)인 계정 조회
 *  수   정   자 :
 *  수   정   일 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
EXEC DBO.[GET_M_JOIN_SEARCH_LIST_PROC] @PAGE=1, @PAGE_SIZE=10, @SEARCH_KEY='4', @SEARCH_WORD='1234567890'
EXEC DBO.[GET_M_JOIN_SEARCH_LIST_PROC] @PAGE=1, @PAGE_SIZE=10, @SEARCH_KEY='4', @SEARCH_WORD='123-45-67890'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_M_JOIN_SEARCH_LIST_PROC]
(
	  @PAGE				INT				    = 1
	, @PAGE_SIZE		INT				    = 10
	, @SEARCH_KEY		VARCHAR(1)		     = NULL
	, @KEYWORD		 VARCHAR(50)		      = NULL
)
AS

BEGIN
	SET NOCOUNT ON

	DECLARE @SQL NVARCHAR(4000)
	DECLARE @SQL_WHERE NVARCHAR(1000)

	SET @SQL = ''
	SET @SQL_WHERE = ''

	IF @SEARCH_KEY = '1'  -- 대표번호
	BEGIN
		SET @SQL_WHERE = ' AND REPLACE(B.MAIN_PHONE, ''-'', '''') LIKE ''%' + @KEYWORD + '%'''
	END

	IF @SEARCH_KEY = '2'  -- 회원 휴대폰 번호
	BEGIN
		SET @SQL_WHERE = ' AND REPLACE(A.HPHONE, ''-'', '''') LIKE ''%' + @KEYWORD + '%'''
	END

	IF @SEARCH_KEY = '3'  -- 회사명
	BEGIN
		SET @SQL_WHERE = ' AND B.COM_NM LIKE ''%' + @KEYWORD + '%'''
	END

	IF @SEARCH_KEY = '4'  -- 사업자등록번호
	BEGIN
		SET @SQL_WHERE = ' AND REPLACE(B.REGISTER_NO, ''-'', '''') LIKE ''%' + @KEYWORD + '%'''
	END

	SET @SQL =
				'SELECT	count(*)
				  FROM CST_MASTER AS A WITH (NOLOCK) 
				  JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
				 WHERE A.MEMBER_CD = ''2'' 
				   AND A.REST_YN = ''N''
				   AND B.MEMBER_TYPE = 1
				   AND A.OUT_YN=''N''' + @SQL_WHERE

	EXECUTE SP_EXECUTESQL @SQL

	SET @SQL = 'SELECT * 
				  FROM
						(SELECT
							   A.USERID   -- 아이디
							 , B.COM_NM -- 회사명 
							 , b.CEO_NM	-- 대표자명
							 , B.REGISTER_NO AS BIZNO
							 , B.MAIN_PHONE AS MAIN_NUMBER -- 대표번호
							 , A.HPHONE -- 회원 핸드폰번호
							 , A.USER_NM -- 회원 이름
							 , CASE WHEN AGENCY_YN = ''Y'' AND LAST_SIGNUP_YN =''N'' THEN ''N''
                 ELSE ''Y'' END AS LAST_SIGNUP_YN -- 최종가입여부
							 ,ROW_NUMBER() OVER (ORDER BY A.JOIN_DT DESC) AS ROWNUM
						  FROM CST_MASTER AS A WITH (NOLOCK) 
						  JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
						 WHERE A.MEMBER_CD = ''2'' 
						   AND A.REST_YN = ''N''
						   AND B.MEMBER_TYPE = 1
						   AND A.OUT_YN=''N'' ' + @SQL_WHERE  + ') AS row 
					WHERE row.ROWNUM > ' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGE_SIZE) + ' AND row.ROWNUM <= ' + CONVERT(VARCHAR(10), (@PAGE) * @PAGE_SIZE)

	 EXECUTE SP_EXECUTESQL @SQL
END
GO
/****** Object:  StoredProcedure [dbo].[GET_M_USER_SEARCH_BY_COUPON_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 개인회원상세 > 고객관리 현황 입력
 *  작   성   자 : 안상미
 *  작   성   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : 

GET_M_USER_SEARCH_BY_COUPON_PROC 'USERID','kkam1234'

 *************************************************************************************/


CREATE	PROCEDURE [dbo].[GET_M_USER_SEARCH_BY_COUPON_PROC]
	 @SEARCHTYPE		VARCHAR(20)
	 ,@SEARCHTEXT		VARCHAR(50)
	
AS		
	set nocount on
---------------------------------
-- 데이타 처리
---------------------------------
	IF @SEARCHTYPE ='USERID' 
	BEGIN
	SELECT	top 100
			 A.cuid
			,A.USERID 
			,A.USER_NM
			,A.REST_YN
			,A.MEMBER_CD
	  FROM DBO.CST_MASTER  AS A WITH (NOLOCK)
	 WHERE USERID like  @SEARCHTEXT +'%'
		AND OUT_YN='N'
	END
	ELSE BEGIn
	SELECT	top 100
			 A.cuid
			,A.USERID 
			,A.USER_NM
			,A.REST_YN
			,A.MEMBER_CD
	  FROM DBO.CST_MASTER  AS A WITH (NOLOCK)
	 WHERE USER_NM like @SEARCHTEXT +'%'
		AND OUT_YN='N'
	END
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_COMPANY_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 기업 정보 가져오기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-3-12
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * EXEC GET_MM_COMPANY_INFO_PROC 10621983,'S103'
   
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_COMPANY_INFO_PROC]
       @CUID         INT
     , @SECTION_CD   CHAR(4) = 'S102'
AS

SET NOCOUNT ON

IF @SECTION_CD='S103'
BEGIN
SELECT
       A.USERID   --0
     , B.REGISTER_NO AS BIZNO
     , B.COM_NM
     , B.CEO_NM AS CEO
     , B.MAIN_PHONE AS MAIN_NUMBER
     , ISNULL(B.PHONE,'') PHONE    --5
     , B.FAX
     , B.HOMEPAGE
     , B.CITY
     , B.GU
     , B.DONG     --10
     , B.ADDR1 AS AREA_DETAIL
     , B.LNG AS GMAP_X
     , B.LAT AS GMAP_Y
     
     , '' AS MANAGER_NM
     , '' AS MANAGER_PHONE  --15
     , '' AS MANAGER_EMAIL
     , '' AS MANAGER_NUMBER
     , '' AS MANAGER_IMG_F
     , '' AS MANAGER_IMG_B
     , '' AS MANAGER_KAKAO_ID    --20
     
     , '' AS BIZ_CLASS
     , '' AS BIZ_CODE
     , '' AS EMP_CNT
     , '' AS MAIN_BIZ
     , case when REG_NUMBER > '' then 'A' ELSE '' end  AS LAND_CLASS        --25
     , ISNULL(C.REG_NUMBER,'') AS REG_NUMBER
     , C.INTRO
     , C.LOGO_IMG
     , '' AS EX_IMAGE_1
     , '' AS EX_IMAGE_2       --30
     , '' AS EX_IMAGE_3
     , '' AS EX_IMAGE_4
     , C.ETCINFO_SYNC
     , A.CUID
     , A.EMAIL as EMAIL		--35
     , A.HPHONE 
     , B.ADDR2 AS AREA_DETAIL2
     , B.ZIP_SEQ AS ZIP_SEQ
     , B.LAW_DONGNO As LAW_DONGNO
     , B.MAN_NO As MAN_NO		--40
     , B.ROAD_ADDR_DETAIL As ROAD_ADDR_DETAIL
     , A.USER_NM AS USERNAME
     FROM CST_MASTER AS A WITH (NOLOCK) 
  JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
  LEFT JOIN CST_COMPANY_LAND AS C WITH (NOLOCK) ON B.COM_ID=C.COM_ID
 WHERE A.CUID = @CUID
   AND A.OUT_YN='N'
   
END

ELSE --부동산 아니면 나머지는 구인에서 가져옮
BEGIN
SELECT
       A.USERID   --0
     , B.REGISTER_NO AS BIZNO
     , B.COM_NM
     , B.CEO_NM AS CEO
     , B.MAIN_PHONE AS MAIN_NUMBER
     , ISNULL(B.PHONE,'') PHONE    --5
     , B.FAX
     , B.HOMEPAGE
     , B.CITY
     , B.GU
     , B.DONG     --10
     , B.ADDR1 AS AREA_DETAIL
     , B.LAT AS GMAP_X
     , B.LNG AS GMAP_Y
     
     , C.MANAGER_NM
     , C.MANAGER_PHONE  --15
     , C.MANAGER_EMAIL
     , '' AS MANAGER_NUMBER
     , '' AS MANAGER_IMG_F
     , '' AS MANAGER_IMG_B
     , '' AS MANAGER_KAKAO_ID    --20
     
     , C.BIZ_CLASS
     , C.BIZ_CD AS BIZ_CODE
     , C.EMP_CNT
     , C.MAIN_BIZ
     , case when REG_NUMBER > '' then 'A' ELSE '' end  AS LAND_CLASS        --25
     , D.REG_NUMBER
     , '' AS INTRO
     , C.LOGO_IMG
     , C.EX_IMAGE_1
     , C.EX_IMAGE_2       --30
     , C.EX_IMAGE_3
     , C.EX_IMAGE_4
     , '' AS ETCINFO_SYNC		
     , A.CUID
     , A.EMAIL as EMAIL	--35
     , A.HPHONE 
     , B.ADDR2 AS AREA_DETAIL2
     , B.ZIP_SEQ AS ZIP_SEQ
     , B.LAW_DONGNO As LAW_DONGNO
     , B.MAN_NO As MAN_NO		--40
     , B.ROAD_ADDR_DETAIL As ROAD_ADDR_DETAIL
		 , A.USER_NM AS USERNAME
  FROM CST_MASTER AS A WITH (NOLOCK) 
  JOIN CST_COMPANY AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
  LEFT JOIN CST_COMPANY_JOB AS C WITH (NOLOCK) ON B.COM_ID=C.COM_ID
  LEFT OUTER JOIN CST_COMPANY_LAND AS D WITH (NOLOCK) ON B.COM_ID=D.COM_ID
 WHERE A.CUID = @CUID
   AND A.OUT_YN='N'
END



GO
/****** Object:  StoredProcedure [dbo].[GET_MM_COMPANY_INFO_REGDT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비지니스 회원 가입일
 *  작   성   자 : 정헌수
 *  작   성   일 : 2018-7-06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * EXEC GET_MM_COMPANY_INFO_PROC 10621983,'S103'
   
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_COMPANY_INFO_REGDT_PROC]
	@CUID         INT
	,@REG_DT DATETIME OUTPUT
AS

	SET NOCOUNT ON
	SELECT
		@REG_DT = B.REG_DT
		FROM MWMEMBER.dbo.CST_MASTER AS A WITH(NOLOCK)
		JOIN MWMEMBER.dbo.CST_COMPANY AS B WITH(NOLOCK) ON B.COM_ID = A.COM_ID 
		WHERE A.CUID = @CUID


GO
/****** Object:  StoredProcedure [dbo].[GET_MM_COMPANY_MEMBER_YN_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 기업회원 여부 가져오기
 *  작   성   자 : 최 봉 기
 *  작   성   일 : 2013-08-27
 *  수   정   자 : 최 승 범
 *  수   정   일 : 2016-07-18
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 각 섹션별 동의를 해야만 해당 섹션을 이용 할 수 있음.
 *  사 용  소 스 : GET_MM_COMPANY_MEMBER_YN_PROC 'SKY80COM','',13

 GET_MM_COMPANY_MEMBER_YN_PROC 'bizjob01','',14
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_MM_COMPANY_MEMBER_YN_PROC]
  @USERID		      VARCHAR(50)		-- 회원아이디
, @SECTION_CD     CHAR(4) = ''			-- 섹션 CD, 해당 섹션 CD가 없을 경우 기업회원으로 판단여부(쿠폰에서 필요)
, @GROUP_CD	      INT = 14				-- 부동산의 경우 일반회원도 쿠폰 발급 가능

AS

IF @SECTION_CD = 'S102'
BEGIN
	SELECT TOP 1 M.CUID
	  FROM DBO.CST_MASTER M WITH(NOLOCK)
		JOIN DBO.CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
	 WHERE M.USERID = @USERID
     AND M.OUT_YN = 'N'
   ORDER BY M.SITE_CD ASC
END
ELSE
BEGIN
  --신문관리 > 쿠폰에서 사용(기업회원 판단여부는 추후 결정, 현재는 기업회원이면 무조건 발송가능)
	SELECT TOP 1 M.CUID
	  FROM DBO.CST_MASTER M WITH(NOLOCK)
	 WHERE M.USERID = @USERID
     AND (M.MEMBER_CD=2 OR @GROUP_CD = 13)
     AND M.OUT_YN = 'N'
   ORDER BY M.SITE_CD ASC
END

GO
/****** Object:  StoredProcedure [dbo].[GET_MM_DISTINGUISH_MEMBER_TYPE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*************************************************************************************
 *  단위 업무 명 : 모바일 리뉴얼 - 회원 구분 판별 (일반, 비즈니스, 공인중개사)
 *  작   성   자 : 백규원
 *  작   성   일 : 2017-06-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * 
EXEC GET_MM_DISTINGUISH_MEMBER_TYPE_PROC '11631083', '127.0.0.1'
EXEC GET_MM_DISTINGUISH_MEMBER_TYPE_PROC '11121212', '127.0.0.1'
MEMBER_TYPE = 1 : 비즈니스, 2 : 중개업소, 없으면 : 일반
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_DISTINGUISH_MEMBER_TYPE_PROC]
		@CUID         INT
	, @IPADDR				VARCHAR(15) = ''
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF @CUID != 0
BEGIN
	SELECT TOP 1
		B.MEMBER_TYPE, B.CUID
	FROM CST_MASTER A
		INNER JOIN CST_COMPANY B
			ON A.COM_ID=B.COM_ID
	WHERE A.CUID = @CUID
		--AND B.USE_YN = 'Y'
END



GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_CD_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
새로 추가한 프로시저

회원의 MEMBER_CD를 조회해 옴

2009년 2월 20일 추가 최병찬

신문 자동 등록 관리자 페이지에서 사용
*/
CREATE PROC [dbo].[GET_MM_MEMBER_CD_PROC]
	 @USERID		VARCHAR(50)	-- 회원명

AS
SET NOCOUNT ON

	-- 기본정보
	SELECT  ISNULL(M.MEMBER_CD,1) AS MEMBER_CD
	  FROM dbo.CST_MASTER M WITH(NOLOCK)
	 WHERE M.USERID = @USERID
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDID_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디찾기>선택한 회원의 정보 노출(USERID,JOIN_DT,HP,PHONE,EMAIL
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-05
 *  수   정   자 : 최봉기
 *  수   정   일 : 2016-08-16
 *  설        명 : 아이디 찾기(동일한 정보의 ID 목록 가져오기)
 *  주 의  사 항 :
 *  사 용  소 스 : EXEC [GET_MM_MEMBER_FINDID_INFO_PROC] 11237489
 *************************************************************************************/
CREATE  PROC [dbo].[GET_MM_MEMBER_FINDID_INFO_PROC]
  @CUID     INT
AS

  SET NOCOUNT ON

  SELECT CASE WHEN PATINDEX('%@%',USERID) > 0 THEN SUBSTRING(USERID, 1, PATINDEX('%@%',USERID)-3)+'***'+SUBSTRING(USERID, PATINDEX('%@%',USERID), LEN(USERID)-PATINDEX('%@%',USERID)+1) ELSE SUBSTRING(USERID, 1 , LEN(USERID)-3)+'***' END AS ENCUSERID
       , REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),'/','.') AS JOIN_DT
       , CASE
              WHEN LEFT(HPHONE,3) IN ('010','011','016','017','018','019') THEN SUBSTRING(HPHONE, 1 , LEN(HPHONE)-4)+'****'
              ELSE ''
         END AS HPHONE
       , CASE 
			  WHEN LEN(EMAIL)=0 OR EMAIL=NULL THEN ''
              WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX('%@%',EMAIL)-1))> 3 
					THEN SUBSTRING(EMAIL, 1, PATINDEX('%@%',EMAIL)-4)+'***'+SUBSTRING(EMAIL, PATINDEX('%@%',EMAIL), LEN(EMAIL)-PATINDEX('%@%',EMAIL)+1)
              ELSE SUBSTRING(EMAIL, 1, PATINDEX('%@%',EMAIL)-3)+'**'+SUBSTRING(EMAIL, PATINDEX('%@%',EMAIL), LEN(EMAIL)-PATINDEX('%@%',EMAIL)+1)
         END AS EMAIL
       , CUID
    FROM CST_MASTER WITH (NOLOCK)
   WHERE CUID=@CUID
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDID_LIST_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디 찾기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 찾기(동일한 정보의 ID 목록 가져오기)
 *  주 의  사 항 :
 *  사 용  소 스 : EXEC DBO.GET_MM_MEMBER_FINDID_LIST_PROC 'H','1','성소영','','','206-85-26551','01022170355'
 EXEC DBO.GET_MM_MEMBER_FINDID_LIST_PROC 'H','1','김영훈','','','','01050016099'
 exec dbo.GET_MM_MEMBER_FINDID_LIST_PROC 'H','1','박인지','19801101','F','            ','01073577221'
 exec dbo.GET_MM_MEMBER_FINDID_LIST_PROC 'H','1','조민기','19770713','M','            ','01063930923'
 exec dbo.GET_MM_MEMBER_FINDID_LIST_PROC 'H','2','박인지','19801101','M','206-85-26551','01073577221'
 *************************************************************************************/

CREATE   PROC [dbo].[GET_MM_MEMBER_FINDID_LIST_PROC]
  @SEARCHTYPE  CHAR(1)     --H:휴대폰 E:Email
  ,@MEMBER_CD   CHAR(1)
  ,@USERNAME    VARCHAR(30)
  ,@JUMINNO     CHAR(8)  = ''
  ,@GENDER      CHAR(1)  = ''
  ,@BIZNO       CHAR(12) = ''
  ,@SEARCHVAL   VARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)
DECLARE @SQL_PARAM NVARCHAR(1000)
SET @SQL=''
SET @SQL_PARAM = '
  @SEARCHTYPE  CHAR(1)   
  ,@MEMBER_CD   CHAR(1)
  ,@USERNAME    VARCHAR(30)
  ,@JUMINNO     CHAR(8)
  ,@GENDER      CHAR(1)
  ,@BIZNO       CHAR(12)
  ,@SEARCHVAL   VARCHAR(50)
'

IF @MEMBER_CD='1'  --개인회원
BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',USERID) > 0 THEN SUBSTRING(USERID, 1, PATINDEX(''%@%'',USERID)-3)+''***''+SUBSTRING(USERID, PATINDEX(''%@%'',USERID), LEN(USERID)-PATINDEX(''%@%'',USERID)+1) ELSE SUBSTRING(USERID, 1 , LEN(USERID)-3)+''***'' END AS USERID_HINT
         , ''['' + ISNULL(CO.CODE_VALUE,''일반'') + ''] '' +  + REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),''/'',''.'') AS JOIN_DT
         , CUID	
		 , JOIN_DT JOINDT
	 FROM CST_MASTER A WITH (NOLOCK)
	 LEFT OUTER JOIN CMN_CODE  CO ON  CODE_GROUP_ID =''SNS_TYPE'' AND CO.CODE_ID = ISNULL(A.SNS_TYPE,'''')
     WHERE MEMBER_CD=''1''
       AND USER_NM=@USERNAME
       --AND BIRTH=@JUMINNO
       --AND GENDER=@GENDER
       AND OUT_YN=''N''
       '

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(HPHONE,''-'','''')=@SEARCHVAL )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND EMAIL=@SEARCHVAL '
    END

		SET @SQL=@SQL+' ORDER BY JOINDT DESC '
END
ELSE    --기업회원
BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',T.USERID) > 0 THEN SUBSTRING(T.USERID, 1, PATINDEX(''%@%'',T.USERID)-3)+''***''+SUBSTRING(T.USERID, PATINDEX(''%@%'',T.USERID), LEN(T.USERID)-PATINDEX(''%@%'',T.USERID)+1) ELSE SUBSTRING(T.USERID, 1 , LEN(T.USERID)-3)+''***'' END AS USERID_HINT
         , ''['' + ISNULL(CO.CODE_VALUE,''일반'') + ''] '' +  + REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),''/'',''.'') AS JOIN_DT
         , T.CUID   
		 , T.JOINDT
      FROM ( 
						SELECT M.USERID, M.JOIN_DT, M.CUID, M.SNS_TYPE, M.JOIN_DT JOINDT
							FROM CST_MASTER AS M WITH (NOLOCK)
							JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID = M.COM_ID
						 WHERE M.MEMBER_CD=''2''
							 AND M.USER_NM=@USERNAME
							 AND M.OUT_YN=''N''
							 AND C.REGISTER_NO=@BIZNO '

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(M.HPHONE,''-'','''')= @SEARCHVAL )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND M.EMAIL=@SEARCHVAL '
    END

		SET @SQL=@SQL+'
						GROUP BY M.USERID, M.JOIN_DT, M.CUID ,M.SNS_TYPE
		) AS T
	 LEFT OUTER JOIN CMN_CODE  CO ON  CODE_GROUP_ID =''SNS_TYPE'' AND CO.CODE_ID = ISNULL(T.SNS_TYPE,'''')
		
		ORDER BY T.JOINDT DESC '
END

PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM,
  @SEARCHTYPE  
  ,@MEMBER_CD  
  ,@USERNAME   
  ,@JUMINNO    
  ,@GENDER     
  ,@BIZNO      
  ,@SEARCHVAL  
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDID_SENDEMAIL_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디찾기>선택한 회원 이메일 보내기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 뒷자리 확인하기 이메일
 *  주 의  사 항 :
 *  사 용  소 스 :
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_FINDID_SENDEMAIL_PROC]

  @CUID   INT

AS

  SET NOCOUNT ON

  DECLARE @EMAIL    VARCHAR(50)

  SELECT EMAIL
       , GETDATE() AS DT
       , USERID
    FROM CST_MASTER WITH (NOLOCK)
   WHERE CUID = @CUID
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDID_SENDSMS_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디찾기>선택한 회원 핸드폰 SMS 보내기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-06
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 뒷자리 확인하기 SMS
 *  주 의  사 항 :
 *  사 용  소 스 :
 *************************************************************************************/
CREATE  PROC [dbo].[GET_MM_MEMBER_FINDID_SENDSMS_PROC]

  @CUID     INT
  ,@SECTION_CD CHAR(4)

AS

  SET NOCOUNT ON

  DECLARE @SMSMSG   NVARCHAR(4000)  = ''
  DECLARE @HP       VARCHAR(14)     = ''
  DECLARE @USERNAME VARCHAR(30)     = ''
  DECLARE @USERID   VARCHAR(50)     = ''

  DECLARE @MSG	nvarchar	(4000)
  DECLARE @SUBJECT	varchar	(160)

  DECLARE @CALLBACK	varchar	(24)        = '0221877867'        -- 발신자번호


  -- 회원 정보 추출
  SELECT @USERNAME = USER_NM
        ,@HP = CASE WHEN LEFT(HPHONE,3) IN ('010','011','016','017','018','019') THEN HPHONE
         END
        ,@USERID = USERID
    FROM CST_MASTER WITH (NOLOCK)
   WHERE CUID = @CUID

  -- 카카오 알림톡 템플릿 정보 가져오기 / 전송 메시지 가공
  SELECT @SUBJECT = LMS_TITLE
        ,@MSG = REPLACE(LMS_MSG,'#{ID}',@USERID)
    FROM OPENQUERY(FINDDB1,'SELECT LMS_MSG, LMS_TITLE FROM COMDB1.dbo.FN_GET_KKO_TEMPLATE_INFO(''MWsms01'')')

  -- SMS 발송
  EXEC FINDDB1.COMDB1.dbo.PUT_SENDSMS_PROC @CALLBACK,'','',@HP,@MSG
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDPW_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 찾기>선택한 회원의 정보 노출
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 찾기(회원정보로 찾기)
 *  주 의  사 항 :
 *  사 용  소 스 : 
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'H', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', '01033931420'
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC_BK01 'H', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', '01033931420'
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'E', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', 'stari@mediawill.com'

 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'H', '1', 'cowto7602', '이근우', '19760925', '206-85-26551', '01033931420'
 exec GET_MM_MEMBER_FINDPW_INFO_PROC 'H', '2', 'ksd9434', '권상덕', '', '139-94-04491', '01025303364'
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_FINDPW_INFO_PROC]
  @SEARCHTYPE  CHAR(1)     --H:휴대폰 E:Email
, @MEMBER_CD   CHAR(1)
, @USERID      VARCHAR(50)
, @USERNAME    VARCHAR(30)
, @JUMINNO     CHAR(8)=''
, @BIZNO       CHAR(12)=''
, @SEARCHVAL   VARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)
DECLARE @SQL_PARAM NVARCHAR(4000)
set @SQL_PARAM = '
  @SEARCHTYPE  CHAR(1)  
, @MEMBER_CD   CHAR(1)
, @USERID      VARCHAR(50)
, @USERNAME    VARCHAR(30)
, @JUMINNO     CHAR(8)
, @BIZNO       CHAR(12)
, @SEARCHVAL   VARCHAR(50)
'

SET @SQL=''

IF @MEMBER_CD='1'  --개인회원
BEGIN
    SET @SQL='
    SELECT CASE
                WHEN LEFT(HPHONE,3) IN (''010'',''011'',''016'',''017'',''018'',''019'') THEN SUBSTRING(HPHONE, 1 , LEN(HPHONE)-4)+''****''
                ELSE ''''
           END AS HPHONE
         , CASE WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-1))> 3 THEN SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-4)+''***''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           ELSE SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-3)+''**''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           END AS EMAIL
				 , HPHONE AS HPHONE1
				 , EMAIL AS EMAIL1
         , CUID
      FROM CST_MASTER WITH (NOLOCK)
     WHERE MEMBER_CD=''1''
       AND USER_NM=@USERNAME
       AND USERID=@USERID
       --AND BIRTH=@JUMINNO
       AND OUT_YN=''N'''

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(HPHONE,''-'','''')=@SEARCHVAL  )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND EMAIL=@SEARCHVAL '
    END
END
ELSE    --기업회원
BEGIN
    SET @SQL='
    SELECT CASE
                WHEN LEFT(M.HPHONE,3) IN (''010'',''011'',''016'',''017'',''018'',''019'') THEN SUBSTRING(M.HPHONE, 1 , LEN(M.HPHONE)-4)+''****''
                ELSE ''''
           END AS HPHONE
         , CASE WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-1))> 3 THEN SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-4)+''***''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           ELSE SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-3)+''**''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           END AS EMAIL
				 , HPHONE AS HPHONE1
				 , EMAIL AS EMAIL1
         , M.CUID
      FROM CST_MASTER AS M WITH (NOLOCK)
      JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID=M.COM_ID
     WHERE M.MEMBER_CD=''2''
       --AND M.USER_NM= @USERNAME 
       AND M.USERID=@USERID 
       AND M.OUT_YN=''N''
       AND C.REGISTER_NO=@BIZNO '

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(M.HPHONE,''-'','''')= @SEARCHVAL )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND M.EMAIL= @SEARCHVAL'
    END
END

PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM,
  @SEARCHTYPE  
, @MEMBER_CD   
, @USERID      
, @USERNAME    
, @JUMINNO     
, @BIZNO       
, @SEARCHVAL   

GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_FINDPW_INFO_PROC_BK01]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 찾기>선택한 회원의 정보 노출
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 찾기(회원정보로 찾기)
 *  주 의  사 항 :
 *  사 용  소 스 : 
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'H', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', '01033931420'
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC_BK01 'H', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', '01033931420'
 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'E', '2', 'cowto7602', '이근우', '19760925', '206-85-26551', 'stari@mediawill.com'

 EXEC GET_MM_MEMBER_FINDPW_INFO_PROC 'H', '2', 'WLRKQ60', '', '', '440-18-01158', '01031389699'
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_FINDPW_INFO_PROC_BK01]
  @SEARCHTYPE  CHAR(1)     --H:휴대폰 E:Email
, @MEMBER_CD   CHAR(1)
, @USERID      VARCHAR(50)
, @USERNAME    VARCHAR(30)
, @JUMINNO     CHAR(8)=''
, @BIZNO       CHAR(12)=''
, @SEARCHVAL   VARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)
DECLARE @SQL_PARAM NVARCHAR(4000)
set @SQL_PARAM = '
  @SEARCHTYPE  CHAR(1)  
, @MEMBER_CD   CHAR(1)
, @USERID      VARCHAR(50)
, @USERNAME    VARCHAR(30)
, @JUMINNO     CHAR(8)
, @BIZNO       CHAR(12)
, @SEARCHVAL   VARCHAR(50)
'

SET @SQL=''

IF @MEMBER_CD='1'  --개인회원
BEGIN
    SET @SQL='
    SELECT CASE
                WHEN LEFT(HPHONE,3) IN (''010'',''011'',''016'',''017'',''018'',''019'') THEN SUBSTRING(HPHONE, 1 , LEN(HPHONE)-4)+''****''
                ELSE ''''
           END AS HPHONE
         , CASE WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-1))> 3 THEN SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-4)+''***''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           ELSE SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-3)+''**''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           END AS EMAIL
				 , HPHONE AS HPHONE1
				 , EMAIL AS EMAIL1
         , CUID
      FROM CST_MASTER WITH (NOLOCK)
     WHERE MEMBER_CD=''1''
       AND USER_NM=@USERNAME
       AND USERID=@USERID
       --AND BIRTH=@JUMINNO
       AND OUT_YN=''N'''

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(HPHONE,''-'','''')=@SEARCHVAL  )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND EMAIL=@SEARCHVAL '
    END
END
ELSE    --기업회원
BEGIN
    SET @SQL='
    SELECT CASE
                WHEN LEFT(M.HPHONE,3) IN (''010'',''011'',''016'',''017'',''018'',''019'') THEN SUBSTRING(M.HPHONE, 1 , LEN(M.HPHONE)-4)+''****''
                ELSE ''''
           END AS HPHONE
         , CASE WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-1))> 3 THEN SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-4)+''***''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           ELSE SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-3)+''**''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           END AS EMAIL
				 , HPHONE AS HPHONE1
				 , EMAIL AS EMAIL1
         , M.CUID
      FROM CST_MASTER AS M WITH (NOLOCK)
      JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID=M.COM_ID
     WHERE M.MEMBER_CD=''2''
       --AND M.USER_NM= @USERNAME 
       AND M.USERID=@USERID 
       AND M.OUT_YN=''N''
       AND C.REGISTER_NO=@BIZNO '

    IF @SEARCHTYPE='H'
    BEGIN
        SET @SQL=@SQL+' AND ( REPLACE(M.HPHONE,''-'','''')= @SEARCHVAL )'
    END
    ELSE
    BEGIN
        SET @SQL=@SQL+' AND M.EMAIL= @SEARCHVAL'
    END
END

PRINT @SQL
--EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM,
--  @SEARCHTYPE  
--, @MEMBER_CD   
--, @USERID      
--, @USERNAME    
--, @JUMINNO     
--, @BIZNO       
--, @SEARCHVAL   

GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_HP_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : ADMIN - 회원가입 대행 - 해당 전화번호로 등로된 ID 불러오기
 *  작   성   자 : 배진용
 *  작   성   일 : 2020-10-07
 *  수   정   자 : 
 *  수   정   일 :  
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 기업회원 : 동일 휴대폰 번호 3개까지만 체크
 *  주 의  사 항 : 
 *  사 용  소 스 :
 EXEC GET_MM_MEMBER_HP_PROC '2','01063930923'
************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_HP_PROC]
       @MEMBER_CD   CHAR(1)
     , @HP          VARCHAR(14)
	 , @USERID		VARCHAR(30) = ''
AS
SET NOCOUNT ON
BEGIN
	DECLARE @HP_TYPE2          VARCHAR(14)
	IF LEN(@HP) = 11 
		SET @HP_TYPE2 = LEFT(@HP,3) +'-' + RIGHT(LEFT(@HP,7),4) +'-' + RIGHT(@HP,4)
	ELSE IF LEN(@HP) = 10
		SET @HP_TYPE2 = LEFT(@HP,3) +'-' + RIGHT(LEFT(@HP,7),3) +'-' + RIGHT(@HP,4)
	ELSE 
		SET @HP_TYPE2 = '9999999999999'
	
	IF LEN(@HP) > 0 AND @HP_TYPE2 <> '9999999999999'
	BEGIN
			SELECT A.CUID, A.USERID,
			   (CASE ISNULL(B.hp,'N') WHEN 'N' THEN 'N' ELSE 'Y' END) AS BAD_YN , 
			   ISNULL(A.REST_YN, 'N') as REST_YN
		  FROM CST_MASTER AS A WITH (NOLOCK)
		 LEFT OUTER JOIN MM_BAD_HP_TB AS B WITH (NOLOCK)
		    ON A.HPHONE = B.HP  AND B.DEL_YN = 'N'
		 WHERE A.HPHONE IN (@HP, @HP_TYPE2) 
		   AND A.OUT_YN = 'N' AND MEMBER_CD = '2' AND A.USERID != @USERID
		   OR A.CUID IN ( SELECT A.CUID FROM CST_REST_MASTER AS A WITH(NOLOCK)
		   INNER JOIN CST_MASTER  AS B WITH(NOLOCK)
		   ON A.CUID = B.CUID
		   WHERE A.HPHONE IN (@HP, @HP_TYPE2) 
		   AND B.OUT_YN = 'N' AND B.MEMBER_CD = '2' AND A.USERID != @USERID)

		   
	END
END



GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_INFO_AGE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 나이 가져오기
 *  작   성   자 : 최승범
 *  작   성   일 : 2016-07-19
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GET_MM_MEMBER_INFO_AGE_PROC]

     @CUID	INT
     
AS		

	SELECT	(DATEDIFF(DD, CONVERT(DATETIME, BIRTH), GETDATE()) /365) AS AGE
	FROM DBO.CST_MASTER WITH(NOLOCK)
	WHERE CUID = @CUID
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_INFO_BY_USERID_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 /기업 구분 없이 회원 기본 정보 값 가져 오기
 *  작   성   자 : 안상미
 *  작   성   일 : 2008.07.03
 *  수   정   자 : 정헌수 
 *  수   정   일 : 2015-04-14
 *  설        명 : 오류 발생으로 GET_F_MM_MEMBER_TB_INFO_PROC => GET_MM_MEMBER_INFO_PROC 변경 및 필드 추가
					 http://www.findall.co.kr/survey/survey_poll.asp
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 부동산 불량광고 처리 메일 발송 페이지/FindJob 신문문 신문줄광고 신청페이지
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /BService/JobOffer/PaperInsert.asp
 GET_MM_MEMBER_INFO_PROC 'kkam1234'
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_MM_MEMBER_INFO_BY_USERID_PROC] 

	 @USERID			varchar(50) = ''
AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 기본정보
	SELECT TOP 1
        A.USERID	-- 회원아이디
        ,A.MEMBER_CD -- 회원구분
        ,A.USER_NM AS USERNAME	-- 회원명
        ,A.EMAIL		-- 이메일
        ,'' AS PHONE
        ,A.HPHONE		-- 휴대폰
        ,A.MOD_DT		-- 수정일
        ,A.JOIN_DT	
        ,A.GENDER
        ,A.BIRTH  AS JUMINNO
        ,A.CUID
        ,A.BAD_YN
				,ISNULL(AGENCY_YN,'N') AS AGENCY_YN
				,ISNULL(LAST_SIGNUP_YN,'Y') AS LAST_SIGNUP_YN
	  FROM CST_MASTER AS A WITH(NOLOCK)
   WHERE A.OUT_YN ='N'
     --AND A.BAD_YN ='N'
	 AND A.USERID = @USERID
  --      AND A.CUID = @CUID
   ORDER BY A.SITE_CD ASC   -- 사이트코드 (F:FindAll, S:부동산서브, M: MWPLUS)

END
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_INFO_CONTRACT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 다량등록권 회원 검색 후 개인/기업 구분에 따른 회원 정보 값 가져 오기
 *  작   성   자 : 이경덕
 *  작   성   일 : 2014.07.14
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : GET_MM_MEMBER_INFO_CONTRACT_PROC 'dfdf'
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_MM_MEMBER_INFO_CONTRACT_PROC] 

	 @USERID		VARCHAR(50)	-- 회원명

AS
	-- 기본정보
	SELECT USERID	-- 회원아이디
		 , USERNAME	-- 고객명/상호명
		 , isnull(PHONE,'')	as PHONE --연락처
		 , isnull(HPHONE,'')as HPHONE	--휴대폰		 
		 , ISNULL(ADDRESS1,'') +' '+ISNULL(ADDRESS2,'') AS ADDR-- 주소
	  FROM DBO.[USERCOMMON_VI] WITH(NOLOCK)
     WHERE USERID = @USERID
		--AND DELCANNEL IS NULL

GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_INFO_HAS_COMPANY_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원정보 (기업/일반 구분)  (일단 부동산만{LAND_CLASS 로 구분함 A:중개,B:임대/사업,공백:개인}
												, 다른 섹션 추가해도 무관)
 *  작   성   자 : 정헌수
 *  작   성   일 : 2015-04-03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * 
 EXEC [GET_MM_MEMBER_INFO_HAS_COMPANY_PROC] 'kkam123456789','S103'   
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_INFO_HAS_COMPANY_PROC]
       @USERID       VARCHAR(50)
     , @SECTION_CD   CHAR(4)
AS
BEGIN

	SET NOCOUNT ON

	SELECT
				 M.USERID   --0
			 , M.USER_NM AS USERNAME
			 , M.HPHONE        
			 , D.BIZ_CD AS BIZNO
			 , C.COM_NM
			 , C.CEO_NM AS CEO
			 , CASE WHEN DBO.FN_GETSPLITSEPARATORCOUNT(C.MAIN_PHONE ,'-')=2 THEN '000-' + C.MAIN_PHONE 
					ELSE C.MAIN_PHONE  
			   END  AS MAIN_NUMBER
			 , C.PHONE
			 , C.FAX
			 , ISNULL(C.HOMEPAGE,'') as HOMEPAGE
			 , C.CITY
			 , C.GU			--10
			 , C.DONG     
			 , C.ADDR1 AS AREA_DETAIL
			 , C.LAT AS GMAP_X
			 , C.LNG AS GMAP_Y     
			 , D.BIZ_CLASS AS BIZ_CLASS        --15
			 , D.BIZ_CD AS BIZ_CODE
			 , D.EMP_CNT
			 , D.MAIN_BIZ	
			 , case when D.REG_NUMBER > '' then  'A' 
					when C.REGISTER_NO > '' then 'B'
					else''	
			   end  as LAND_CLASS
			 , D.REG_NUMBER
			 , D.INTRO
			 , isnull(D.LOGO_IMG,'') as LOGO_IMG
			 , M.CUID
			 , M.REST_YN 
		FROM DBO.CST_MASTER M WITH(NOLOCK)
		LEFT OUTER JOIN  DBO.CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
		LEFT OUTER JOIN  DBO.CST_COMPANY_ETC_VI D WITH(NOLOCK) ON C.COM_ID = D.COM_ID
	 WHERE M.USERID = @USERID
--     AND D.SECTION_CD = @SECTION_CD
     AND M.OUT_YN = 'N'
     AND ISNULL(M.STATUS_CD,'') <> 'D'
	ORDER BY M.REST_YN ,  M.SITE_CD ASC --  휴면후순위, 벼룩화원우선 검색되게..
END


GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 /기업 구분 없이 회원 기본 정보 값 가져 오기
 *  작   성   자 : 안상미
 *  작   성   일 : 2008.07.03
 *  수   정   자 : 정헌수 
 *  수   정   일 : 2015-04-14
 *  설        명 : 오류 발생으로 GET_F_MM_MEMBER_TB_INFO_PROC => GET_MM_MEMBER_INFO_PROC 변경 및 필드 추가
					 http://www.findall.co.kr/survey/survey_poll.asp
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 부동산 불량광고 처리 메일 발송 페이지/FindJob 신문문 신문줄광고 신청페이지
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /BService/JobOffer/PaperInsert.asp
 GET_MM_MEMBER_INFO_PROC 'kkam1234'
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_MM_MEMBER_INFO_PROC] 

	 --@USERID VARCHAR(50)
	 @CUID INT

AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 기본정보
	SELECT TOP 1
        A.USERID	-- 회원아이디
        ,A.MEMBER_CD -- 회원구분
        ,A.USER_NM AS USERNAME	-- 회원명
        ,A.EMAIL		-- 이메일
        ,'' AS PHONE
        ,A.HPHONE		-- 휴대폰
        ,A.MOD_DT		-- 수정일
        ,A.JOIN_DT	
        ,A.GENDER
        ,A.BIRTH  AS JUMINNO
        ,A.CUID
        ,A.BAD_YN
		,'' as POST_A 
		,'' as POST_B
		,'' as ADDR_B 
		,'' as CITY 
		,'' as GU 
		,'' as DONG
	  FROM CST_MASTER AS A WITH(NOLOCK)
   WHERE A.OUT_YN ='N'
     AND A.BAD_YN ='N'
     --AND A.USERID = @USERID
     AND A.CUID = @CUID
   ORDER BY A.SITE_CD ASC   -- 사이트코드 (F:FindAll, S:부동산서브, M: MWPLUS)

END
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_INFO_PROC2]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 /기업 구분 없이 회원 기본 정보 값 가져 오기
 *  작   성   자 : 안상미
 *  작   성   일 : 2008.07.03
 *  수   정   자 : 정헌수 
 *  수   정   일 : 2015-04-14
 *  설        명 : 오류 발생으로 GET_F_MM_MEMBER_TB_INFO_PROC => GET_MM_MEMBER_INFO_PROC 변경 및 필드 추가
					 http://www.findall.co.kr/survey/survey_poll.asp
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 부동산 불량광고 처리 메일 발송 페이지/FindJob 신문문 신문줄광고 신청페이지
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /BService/JobOffer/PaperInsert.asp
 GET_MM_MEMBER_INFO_PROC 'kkam1234'
 *************************************************************************************/


CREATE PROCEDURE [dbo].[GET_MM_MEMBER_INFO_PROC2] 

	 @USERID VARCHAR(50)

AS
BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	-- 기본정보
	SELECT TOP 1
        A.USERID	-- 회원아이디
        ,A.MEMBER_CD -- 회원구분
        ,A.USER_NM AS USERNAME	-- 회원명
        ,A.EMAIL		-- 이메일
        ,'' AS PHONE
        ,A.HPHONE		-- 휴대폰
        ,A.MOD_DT		-- 수정일
        ,A.JOIN_DT	
        ,A.GENDER
        ,A.BIRTH  AS JUMINNO
        ,A.CUID
        ,A.BAD_YN
        ,A.REST_YN
	  FROM CST_MASTER AS A WITH(NOLOCK)
   WHERE A.OUT_YN ='N'
     AND A.BAD_YN ='N'
     AND A.USERID = @USERID
     AND ISNULL(A.STATUS_CD,'') <> 'D'
     --AND A.CUID = @CUID
   ORDER BY A.SITE_CD ASC   -- 사이트코드 (F:FindAll, S:부동산서브, M: MWPLUS)

END
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_IPIN_FINDID_LIST_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 아이디 찾기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2013-03-05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 아이디 찾기(동일한 정보의 ID 목록 가져오기)
 *  주 의  사 항 :
 *  사 용  소 스 : EXEC GET_MM_MEMBER_IPIN_FINDID_LIST_PROC '2', 'MC0GCCqGSIb3DQIJAyEAUjIzO8ukISnslSboZf74ugv63xd5uHbIpd0OJG9eqRU=', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_IPIN_FINDID_LIST_PROC]
   @MEMBER_CD   CHAR(1)  = ''
  ,@DI          CHAR(64)
  ,@BIZNO       CHAR(12) = ''
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)
DECLARE @SQL_PARAM NVARCHAR(4000)
SET @SQL_PARAM = '
   @MEMBER_CD   CHAR(1)
  ,@DI          CHAR(64)
  ,@BIZNO       CHAR(12)
'
SET @SQL=''

IF @MEMBER_CD='1'  --개인회원
  BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',USERID) > 0 THEN SUBSTRING(USERID, 1, PATINDEX(''%@%'',USERID)-3)+''***''+SUBSTRING(USERID, PATINDEX(''%@%'',USERID), LEN(USERID)-PATINDEX(''%@%'',USERID)+1) ELSE SUBSTRING(USERID, 1 , LEN(USERID)-3)+''***'' END AS USERID_HINT
          , REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),''/'',''.'') AS JOIN_DT
          , CUID
      FROM CST_MASTER WITH (NOLOCK)
      WHERE MEMBER_CD=''1''
        AND OUT_YN=''N''
        AND DI= @DI
		  ORDER BY JOIN_DT DESC '

  END
ELSE IF @MEMBER_CD='2'    --기업회원
  BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',T.USERID) > 0 THEN SUBSTRING(T.USERID, 1, PATINDEX(''%@%'',T.USERID)-3)+''***''+SUBSTRING(T.USERID, PATINDEX(''%@%'',T.USERID), LEN(T.USERID)-PATINDEX(''%@%'',T.USERID)+1) ELSE SUBSTRING(T.USERID, 1 , LEN(T.USERID)-3)+''***'' END USERID_HINT
          , REPLACE(CONVERT(VARCHAR(10), T.JOIN_DT, 111),''/'',''.'') AS JOIN_DT
          , T.CUID    
      FROM (
						SELECT M.USERID, M.JOIN_DT, M.CUID
							FROM CST_MASTER AS M WITH (NOLOCK)
							JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID = M.COM_ID
						  WHERE M.MEMBER_CD = ''2''
							  AND M.OUT_YN = ''N''
							  AND M.DI = @DI
							  AND C.REGISTER_NO = @BIZNO
						GROUP BY M.USERID, M.JOIN_DT, M.CUID
			) AS T
		ORDER BY JOIN_DT DESC '
  END
ELSE
  BEGIN
    SET @SQL='
		SELECT CASE WHEN PATINDEX(''%@%'',USERID) > 0 THEN SUBSTRING(USERID, 1, PATINDEX(''%@%'',USERID)-3)+''***''+SUBSTRING(USERID, PATINDEX(''%@%'',USERID), LEN(USERID)-PATINDEX(''%@%'',USERID)+1) ELSE SUBSTRING(USERID, 1 , LEN(USERID)-3)+''***'' END AS USERID_HINT
          , REPLACE(CONVERT(VARCHAR(10),JOIN_DT,111),''/'',''.'') AS JOIN_DT
          , CUID
      FROM CST_MASTER WITH (NOLOCK)
      WHERE MEMBER_CD IN (''1'',''2'')
        AND OUT_YN=''N''
        AND DI= @DI 
		  ORDER BY JOIN_DT DESC '

  END

--PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL,@SQL_PARAM
  , @MEMBER_CD  
  ,@DI         
  ,@BIZNO      
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_IPIN_FINDPW_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 찾기>선택한 회원의 정보 노출
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2016-08-12
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 찾기(본인인증으로 찾기)
 *  주 의  사 항 :
 *  사 용  소 스 :
 GET_MM_MEMBER_IPIN_FINDPW_INFO_PROC '2', 'cowto7602', 'MC0GCCqGSIb3DQIJAyEAXp0R0iksNDa5CISpI/nssxqZj6pDwnw5l4S9yonyXWY=', '206-85-26551'
 *************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_IPIN_FINDPW_INFO_PROC]
  @MEMBER_CD   CHAR(1)
, @USERID      VARCHAR(50)
, @DI          CHAR(64)
, @BIZNO       CHAR(12)=''
AS

SET NOCOUNT ON

DECLARE @SQL NVARCHAR(4000)

SET @SQL=''

IF @MEMBER_CD='1'  --개인회원
BEGIN
    SET @SQL='
    SELECT CASE
                WHEN LEFT(HPHONE,3) IN (''010'',''011'',''016'',''017'',''018'',''019'') THEN SUBSTRING(HPHONE, 1 , LEN(HPHONE)-4)+''****''
                ELSE ''''
           END AS HPHONE
         , CASE WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-1))> 3 THEN SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-4)+''***''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           ELSE SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-3)+''**''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           END AS EMAIL
				 , HPHONE AS HPHONE1
				 , EMAIL AS EMAIL1
         , CUID
      FROM CST_MASTER WITH (NOLOCK)
     WHERE MEMBER_CD=''1''
       AND USERID='''+@USERID+'''
       AND OUT_YN=''N''
       AND DI='''+@DI+''''
END
ELSE    --기업회원
BEGIN
    SET @SQL='
    SELECT CASE
                WHEN LEFT(M.HPHONE,3) IN (''010'',''011'',''016'',''017'',''018'',''019'') THEN SUBSTRING(M.HPHONE, 1 , LEN(M.HPHONE)-4)+''****''
                ELSE ''''
           END AS HPHONE
         , CASE WHEN LEN(SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-1))> 3 THEN SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-4)+''***''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           ELSE SUBSTRING(EMAIL, 1, PATINDEX(''%@%'',EMAIL)-3)+''**''+SUBSTRING(EMAIL, PATINDEX(''%@%'',EMAIL), LEN(EMAIL)-PATINDEX(''%@%'',EMAIL)+1)
           END AS EMAIL
				 , HPHONE AS HPHONE1
				 , EMAIL AS EMAIL1
         , M.CUID
      FROM CST_MASTER AS M WITH (NOLOCK)
      JOIN CST_COMPANY AS C WITH (NOLOCK) ON C.COM_ID=M.COM_ID
     WHERE M.MEMBER_CD=''2''
       AND M.USERID='''+@USERID+'''
       AND M.OUT_YN=''N''
       AND M.DI='''+@DI+'''
       AND C.REGISTER_NO='''+@BIZNO+''' '

END

PRINT @SQL
EXECUTE SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원 기본 정보 가져오기(공통)
 *  작   성   자 : 최병찬
 *  작   성   일 : 2015.3.9
 *  수   정   자 : 이근우
 *  수   정   일 : 2018.05.03
 *  설        명 : 불량여부, 휴면여부, 탈퇴여부 추가
 *  주 의  사 항 : 
 *  사 용  소 스 :
 EXEC GET_MM_MEMBER_PROC 10504172
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_MM_MEMBER_PROC]
	 @CUID		INT

AS

	SET NOCOUNT ON 
	-- 기본정보
	SELECT
		   A.USERID
		 , A.USER_NM
		 , A.MEMBER_CD
		 , A.HPHONE
		 , A.EMAIL
		 , A.SNS_TYPE 
		 , A.SNS_ID    
		 , A.BIRTH	-- 회원정보 수정시 필요
		 , A.GENDER	-- 회원정보 수정시 필요
		 , CASE	WHEN A.REALHP_YN ='Y' THEN 'Y'
				WHEN (SELECT COUNT(*) FROM CST_MASTER AS B WITH (NOLOCK) WHERE B.HPHONE = A.HPHONE AND B.MEMBER_CD='1') = 1  THEN 'Y' 
				ELSE 'N' 
				END AS REALHP_YN
     , A.BAD_YN
     , A.REST_YN
     , A.REST_DT
     , A.OUT_YN
     , A.OUT_DT
	 , M.AGREE_DT AS MK_AGREE_DT
     , ISNULL(M.AGREEF,0) AS MK_AGREEF
		 ,ISNULL(AGENCY_YN,'N') AS  AGENCY_YN						-- 회원가입대행 추가 2021-06-08
		 ,ISNULL(LAST_SIGNUP_YN,'Y') AS LAST_SIGNUP_YN	-- 회원가입대행 추가 2021-06-08
	  FROM CST_MASTER AS A WITH (NOLOCK)
	  LEFT OUTER JOIN CST_MARKETING_AGREEF_TB AS M ON M.CUID = A.CUID
	 WHERE A.CUID=@CUID

	-- 수신 동의 섹션 가져오기
	--EXEC DBO.GET_MSG_SECTION @CUID

GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_UNIQUE_USERID_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 회원 아이디 중복 중복체크
 *  작   성   자 : 문해린
 *  작   성   일 : 2007-12-20
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 해당 스토어드 프로시저를 사용하는 asp 파일을 기재한다.
 *************************************************************************************/



CREATE       PROCEDURE [dbo].[GET_MM_MEMBER_UNIQUE_USERID_PROC]
	@USERID		VARCHAR(50)	-- 회원아이디
AS

	SELECT	COUNT(USERID) AS INTMEMBERCNT 
	  FROM	DBO.CST_MASTER	 WITH(NOLOCK)
	 WHERE  USERID = @USERID

GO
/****** Object:  StoredProcedure [dbo].[GET_MM_PERSON_BASEINFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 개인회원 기본정보 가져오기
 *  작   성   자 : 최병찬
 *  작   성   일 : 2018-01-04
 *  설        명 : 회원 개편후 중고장터에서 사용되어 미사용 필드 없음 처리 
 *  주 의  사 항 : 각 섹션별 동의를 해야만 해당 섹션을 이용 할 수 있음.
 *  사 용  소 스 : GET_MM_PERSON_BASEINFO_PROC 'UNME80'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_MM_PERSON_BASEINFO_PROC]
	 @USERID		VARCHAR(50)	-- 회원아이디

AS
		
	SELECT	
	   M.USERID
		,M.USER_NM AS USERNAME
		,M.EMAIL
		,M.HPHONE
		,''  PHONE
		,'' HOMEPAGE
		,'' POST_A
		,'' POST_B
		,'' CITY
		,'' ADDR_A
		,'' ADDR_B
		,M.BAD_YN
		,M.JOIN_DT
		,M.MOD_DT
		,'' AS CITY		-- 시
		,'' AS GU
		,'' AS DONG		
	  FROM	DBO.CST_MASTER M WITH(NOLOCK)
	 WHERE	M.USERID = @USERID 
	   AND	M.MEMBER_CD = '1'
	   AND M.SITE_CD='F'
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_PERSON_COMPANY_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 개인/기업 회원 정보 가져오기
 *  작   성   자 : 최승범
 *  작   성   일 : 2016.07.20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 :
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_MM_PERSON_COMPANY_PROC]
	 @CUID		INT
AS
	-- 기본정보
	SELECT   M.USERID	-- 회원아이디
		,M.USER_NM AS USERNAME	-- 회원명
		,M.EMAIL	-- 이메일
		,'' AS PHONE	-- 전화번호
		,M.HPHONE	-- 휴대폰
		,'' AS POST_A	-- 우편번호
		,'' AS POST_B
		,'' AS CITY		-- 시
		,'' AS GU	-- 주소
		,'' AS DONG
		,M.MOD_DT	-- 수정일
		,'' AS HOMEPAGE	-- 홈페이지
		,M.JOIN_DT
		,'' AS JOIN_DOMAIN
		,C.COM_NM AS COM_NM
		,C.REGISTER_NO AS BIZNO
	 FROM	DBO.CST_MASTER M WITH(NOLOCK)
	 LEFT OUTER JOIN DBO.CST_COMPANY C ON M.COM_ID = C.COM_ID
	WHERE	M.CUID = @CUID

GO
/****** Object:  StoredProcedure [dbo].[GET_MM_PERSON_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*************************************************************************************
 *  단위 업무 명 : 개인 회원 정보 가져오기
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.12.26
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 :
 GET_MM_PERSON_PROC 'jjangssoon6'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_MM_PERSON_PROC]
	 @USERID		VARCHAR(50)	-- 회원명
AS
	-- 기본정보
	SELECT   USER_NM AS USERID	-- 회원아이디
		,USER_NM AS USERNAME	-- 회원명
		,EMAIL AS EMAIL	-- 이메일
		,'' AS PHONE	-- 전화번호
		,HPHONE AS HPHONE	-- 휴대폰
		,'' AS POST_A	-- 우편번호
		,'' AS POST_B
		,'' AS CITY		-- 시
		,'' AS GU	-- 주소
		,'' AS DONG
		,MOD_DT	-- 수정일
		,'' AS HOMEPAGE	-- 홈페이지
		,JOIN_DT
		,'' AS JOIN_DOMAIN
	 FROM CST_MASTER
	WHERE USERID = @USERID

	-- 이용동의 섹션 가져오기
	--EXEC	DBO.GET_MM_JOIN_PROC @USERID,''

	-- 메일 수신 동의 섹션 가져오기
	--EXEC	DBO.GET_MM_MSG_AGREE_PROC @USERID,''

GO
/****** Object:  StoredProcedure [dbo].[GET_MM_SSO_CERT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : SSO 로그인 인증 TOKEN 확인
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2017/01/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_MM_SSO_CERT_PROC '32d52fd0ee59cac0f2d055dc3867950c'
 *************************************************************************************/


CREATE PROC [dbo].[GET_MM_SSO_CERT_PROC]

  @TOKEN_KEY VARCHAR(32)

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  SELECT USERID
        ,PWD
        ,SECTION_CD
        ,IP
        ,HOST
        ,KEEPLOGIN
        ,SNS_TYPE
        ,SNS_ID
    FROM MM_SSO_CERT_TB
   WHERE TOKEN_KEY = @TOKEN_KEY

  -- 조회후 데이터 삭제 (보안을 위해 한번 인증받은 데이터는 삭제처리)
  DELETE FROM MM_SSO_CERT_TB WHERE TOKEN_KEY = @TOKEN_KEY
GO
/****** Object:  StoredProcedure [dbo].[GET_MSG_SECTION]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원 마케팅, 이벤트 수신 동의
 *  작   성   자 : 최승범
 *  작   성   일 : 2016.08.16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 *************************************************************************************/
CREATE PROCEDURE [dbo].[GET_MSG_SECTION]
	 @CUID		INT

AS
  

	-- 기본정보
SELECT
       A.SECTION_CD
       ,A.MEDIA_CD
       ,A.AGREE_DT
  FROM CST_MSG_SECTION AS A WITH (NOLOCK)
 WHERE A.CUID=@CUID
 
 UNION ALL
  
 SELECT
       'S101'
       ,'P'
       ,B.REGDATE
  FROM [FINDDB1].[PAPER_NEW].[dbo].[PP_USER_EPAPERMAIL_TB] AS B WITH (NOLOCK)
 WHERE B.CUID=@CUID
GO
/****** Object:  StoredProcedure [dbo].[GET_MWSALES_API_MEMBER_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 영업시스템 > API > 벼룩시장 회원
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2016/04/08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_MWSALES_API_MEMBER_PROC 'bluesky','' ,'' ,'' ,'' ,'' ,''
 *************************************************************************************/


CREATE PROC [dbo].[GET_MWSALES_API_MEMBER_PROC]

  @CUSTOMERID     VARCHAR(50) = ''
  ,@CORPNO        VARCHAR(50) = ''
  ,@CORPNAME      VARCHAR(50) = ''
  ,@TELNO         VARCHAR(50) = ''
  ,@MOBILENO      VARCHAR(50) = ''
  ,@NAME          VARCHAR(50) = ''
  ,@CUSTOMERNO    VARCHAR(50) = ''

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL NVARCHAR(MAX)  = ''
  DECLARE @SQL_WHERE VARCHAR(1000)  = ''
  
  -- 아이디
  IF LEN(@CUSTOMERID) > 0
    SET @SQL_WHERE += ' AND A.USERID = '''+ @CUSTOMERID +''''

  -- 사업자등록번호
  IF LEN(@CORPNO) > 0
    SET @SQL_WHERE += ' AND B.REGISTER_NO = '''+ @CORPNO +''''

  -- 상호명(회사명)
  IF LEN(@CORPNAME) > 0
    SET @SQL_WHERE += ' AND B.COM_NM LIKE ''%'+ @CORPNAME +'%'''

  -- 전화번호 (회원은 전화번호가 없으므로 휴대폰번호로 조회)
  IF LEN(@TELNO) > 0
    SET @SQL_WHERE += ' AND B.MAIN_PHONE LIKE ''%'+ @TELNO +'%'''

  -- 휴대폰
  IF LEN(@MOBILENO) > 0
    SET @SQL_WHERE += ' AND A.HPHONE LIKE ''%'+ @MOBILENO +'%'''

  -- 대표이름(사용자이름)
  IF LEN(@NAME) > 0
    SET @SQL_WHERE += ' AND B.CEO_NM LIKE ''%'+ @NAME +'%'''

  -- 고객번호 (해당없음)


  -- Result   (본서버 적용시 _MM 앞에 "_" 제거!!!!!!!!!!!!!!!!!!!!!!!)
  SET @SQL = 'SELECT A.USERID AS customerId
        ,0 AS customerNo
        ,B.REGISTER_NO AS corpNo
        ,B.COM_NM AS corpName
        ,B.PHONE AS telNo
        ,A.HPHONE AS MobileNo
        ,A.CUID
    FROM CST_MASTER AS A
      LEFT JOIN CST_COMPANY AS B ON B.COM_ID = A.COM_ID
   WHERE A.REST_YN = ''N''
     '+ @SQL_WHERE

  EXECUTE SP_EXECUTESQL @SQL
  --PRINT @SQL
GO
/****** Object:  StoredProcedure [dbo].[GET_S_CST_LOGIN_CHK_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 로그인
 *  작   성   자 : JMG
 *  작   성   일 : 2020/05/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 매물등록이나 전용창에 접속시 로그인으로 간주하고 LAST_LOGIN_DT 를 저장함.
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_S_CST_LOGIN_CHK_PROC 13621996
 *************************************************************************************/


CREATE PROC [dbo].[GET_S_CST_LOGIN_CHK_PROC]

	@CUID			INT = 0

AS
BEGIN
	SET NOCOUNT ON

	IF EXISTS(SELECT * FROM CST_MASTER WITH(NOLOCK)	WHERE CUID = @CUID)
	BEGIN

		UPDATE CST_MASTER
		SET LAST_LOGIN_DT = GETDATE()
		WHERE CUID = @CUID

	END

END

GO
/****** Object:  StoredProcedure [dbo].[GET_TOKEN_KEEP_LOGIN_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 로그인 유지> 로그인 유지 TOKEN 쌓기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016-08-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :

declare @outtoken varchar(36) 
SET @outtoken = '6220E8F8-49B1-400F-A617-53FC80A0B0B7'
EXEC [GET_TOKEN_KEEP_LOGIN_PROC] 'sebilia','T', @TOKEN = @outtoken OUTPUT
SELECT @outtoken
 *************************************************************************************/
CREATE PROC [dbo].[GET_TOKEN_KEEP_LOGIN_PROC]
   @CUID        INT
	,@USERID		  VARCHAR(50)	-- 회원아이디
	,@KEEPLOGIN   CHAR(1)='F'     --로그인 유지여부
  ,@TOKEN       VARCHAR(36)=''  OUTPUT
AS

DECLARE @NEWTOKEN VARCHAR(36)
SET @NEWTOKEN=''
--로그인 유지일시 TOKEN 값 바꾸기
IF @KEEPLOGIN='T'
BEGIN
  SET @NEWTOKEN = NEWID()
  IF EXISTS (
    SELECT * FROM MM_TOKEN_TB WITH (NOLOCK)
     WHERE CUID = @CUID
  )
  BEGIN
    UPDATE MM_TOKEN_TB
       SET TOKEN = CAST(@NEWTOKEN AS UNIQUEIDENTIFIER)
         , LAST_LOGIN_DT = GETDATE()
     WHERE CUID = @CUID
  END
  ELSE
  BEGIN
    INSERT MM_TOKEN_TB
         ( CUID, USERID, TOKEN, LAST_LOGIN_DT)
    VALUES
         ( @CUID, @USERID, CAST(@NEWTOKEN AS UNIQUEIDENTIFIER), GETDATE() )
  END
END

SET @TOKEN=@NEWTOKEN 
GO
/****** Object:  StoredProcedure [dbo].[MB_APP_LOGIN]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
*  단위 업무 명 : 모바일 어플 기업, 일반 회원 로그인 체크
*  작   성   자 : 함창훈(innerspace@mediawill.com)
*  작   성   일 : 
*  수   정   자 :
*  수   정   일 :
*  설        명 : 
*  주 의  사 항 : 
*  사 용  소 스 : EXEC [MEMBER].[dbo].[MB_APP_LOGIN] 회원아이디, 비밀번호, 서비스섹션코드, 디바이스아이디, 모바일섹션코드

* RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
 * RETURN(900) -- 복수의 아이디(아이디/비번 중복됨)

EXEC [MEMBER].[dbo].[MB_APP_LOGIN] mediawilltest, '1Q2W3E!q@w#e', 'S101', 'TESTID', 'TESTKEY', 'A404'
EXEC [MEMBER].[dbo].[MB_APP_LOGIN] mediawilltest, '1Q2W3E!q@w#e', '', 'TESTID', 'TESTKEY2', 'A404'

EXEC [MEMBER].[dbo].[MB_APP_LOGIN] mediawilltest, '1234', 'S101', 'TESTID', 'TESTKEY', 'A404'
EXEC [MB_APP_LOGIN] 'dfds', '1234', 'S101', 'TESTID', 'TESTKEY', 'A404','',''

EXEC [MB_APP_LOGIN] 'mwmobile', 'mw4758!!', 'S101', 'TESTID', 'TESTKEY', 'A404','',''
mwmobile / mw4758!!



SELECT * FROM MM_MEMBER_TB WHERE USERID = 'mediawilltest'
SELECT * FROM MM_JOIN_TB WHERE USERID = 'mediawilltest'
SELECT * FROM MEMBER.dbo.MM_MB_APP_LOGIN_TB WHERE MID = 'TESTID'
UPDATE MEMBER.dbo.MM_MB_APP_LOGIN_TB SET MKEY = 'TESTKEY' WHERE MID = 'TESTID'
*************************************************************************************/
--DROP PROCEDURE [dbo].[MB_APP_LOGIN]
CREATE PROCEDURE [dbo].[MB_APP_LOGIN]
	@USERID				VARCHAR(50)				-- 회원아이디
	, @PASSWORD			VARCHAR(32)			-- 비번
	, @SECTION_CD		CHAR(4) = 'S101'	-- 서비스섹션코드(S101 : 벼룩시장 -> MEMBER.dbo.CC_SECTION_TB 참조)
	, @MID				NVARCHAR(400)		-- 디바이스아이디
	, @MKEY				NVARCHAR(100)		-- 디바이스암호화키
	, @MB_SECTION_CD	NVARCHAR(10)		-- 모바일섹션코드(A404 : 요리음식전문앱 -> MEMBER.dbo.CC_SECTION_TB 참조)
	, @IP				VARCHAR(15)
	, @HOST				VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	
	DECLARE @RET INT
	EXEC @RET=SP_LOGIN @USERID, @PASSWORD, @MB_SECTION_CD, @IP, @HOST

/*	
	SELECT
		M.CUID
		, M.USERID
		, M.PWD
		, DBO.FN_MD5(LOWER(@PASSWORD)) AS USER_PWD
		, M.USER_NM AS USERNAME    -- 개인이름
		, M.MEMBER_CD
		, '' AS COM_NM    -- 기업명(기업만 사용)
		, ISNULL(M.EMAIL,'') AS EMAIL
		, ISNULL(M.HPHONE,'') AS HPHONE
		, '' AS PHONE
		, '' AS ADDR_A
		, '' AS ADDR_B
		, '' AS SECTION_CD     -- 섹션별 동의 해야 이용가능
		, M.BAD_YN
		, CASE WHEN LEN(M.BIRTH) = 8 THEN SUBSTRING(M.BIRTH,3,6) ELSE M.BIRTH END AS JUMINNO_A        --주민번호_A
		, M.DI
		, M.REST_YN
		, ISNULL(M.ADULT_YN,'') AS ISADULT
		, '' AS SNS_TYPE
		, DATEDIFF(DAY, M.PWD_NEXT_ALARM_DT, GETDATE()) AS PWD_ALARM_YN
		, M.JOIN_DT
		, OUT_YN AS OUT_APPLY_YN

	FROM 
		CST_MASTER M
	WHERE 
		M.USERID = @USERID AND M.OUT_YN='N'
*/	
	-- 어플 로그인 처리를 위한 리턴 값
	DECLARE @RTN_MKEY NVARCHAR(100)
	IF(@RET = 0) SET @RTN_MKEY = '200'
	ELSE IF(@RET = 200) SET @RTN_MKEY = '401'
	ELSE IF(@RET = 300) SET @RTN_MKEY = '406'
	ELSE IF(@RET = 400) SET @RTN_MKEY = '404'
	ELSE IF(@RET = 500) SET @RTN_MKEY = '405'
	ELSE IF(@RET = 900) SET @RTN_MKEY = '407'
	ELSE SET @RTN_MKEY = ''


	IF ( @RTN_MKEY = '200' )
		BEGIN
			IF EXISTS(SELECT * FROM MM_MB_APP_LOGIN_TB WITH(NOLOCK) WHERE MID = @MID AND MB_SECTION_CD = @MB_SECTION_CD)
				BEGIN
					UPDATE MM_MB_APP_LOGIN_TB SET MKEY = @MKEY, last_access_date = GETDATE() WHERE MID = @MID AND MB_SECTION_CD = @MB_SECTION_CD
				END
			ELSE
				BEGIN
					INSERT INTO MM_MB_APP_LOGIN_TB (MID, MKEY, MB_SECTION_CD, reg_date, last_access_date) VALUES ( @MID, @MKEY, @MB_SECTION_CD, GETDATE(), GETDATE() )
				END

			SET @RTN_MKEY = @MKEY
		END

	SELECT @RTN_MKEY AS MKEY

GO
/****** Object:  StoredProcedure [dbo].[MB_APP_LOGIN_AUTO]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
*  단위 업무 명 : 모바일 어플 기업, 일반 회원 로그인 체크
*  작   성   자 : 함창훈(innerspace@mediawill.com)
*  작   성   일 : 
*  수   정   자 :
*  수   정   일 :
*  설        명 : 
*  주 의  사 항 : 
*  사 용  소 스 : EXEC [MEMBER].[dbo].[MB_APP_LOGIN_AUTO] 회원아이디, 서비스섹션코드, 디바이스아이디, 디바이스이전암호화키, 디바이스업데이트암호화키, 모바일섹션코드

EXEC [MEMBER].[dbo].[MB_APP_LOGIN_AUTO] mediawilltest, 'S101', 'TESTID', 'TESTKEY2', 'TESTKEY', 'A404'
EXEC [MEMBER].[dbo].[MB_APP_LOGIN_AUTO] mediawilltest, 'S101', 'TESTID', 'TESTKEY', 'TESTKEY2', 'A404'

SELECT * FROM MM_MEMBER_TB WHERE USERID = 'mediawilltest'
SELECT * FROM MM_JOIN_TB WHERE USERID = 'mediawilltest'
SELECT * FROM MEMBER.dbo.MM_MB_APP_LOGIN_TB WHERE MID = 'TESTID'
UPDATE MEMBER.dbo.MM_MB_APP_LOGIN_TB SET MKEY = 'TESTKEY' WHERE MID = 'TESTID'
*************************************************************************************/
--DROP PROCEDURE [dbo].[MB_APP_LOGIN_AUTO]
CREATE PROCEDURE [dbo].[MB_APP_LOGIN_AUTO]
	@CUID				INT			-- CUID
	, @SECTION_CD		CHAR(4) = 'S101'	-- 서비스섹션코드(S101 : 벼룩시장 -> MEMBER.dbo.CC_SECTION_TB 참조)
	, @MID				NVARCHAR(400)		-- 디바이스아이디
	, @MKEY				NVARCHAR(100)		-- 디바이스이전암호화키
	, @UPDATE_MKEY		NVARCHAR(100)		-- 업데이트할 디바이스암호화키
	, @MB_SECTION_CD	NVARCHAR(10)		-- 모바일섹션코드(A404 : 요리음식전문앱 -> MEMBER.dbo.CC_SECTION_TB 참조)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	--기업 관련 정보를 가져올 수 없음
	--해당 섹션별 정보가 다를 수 있다는 전제로 출발
	SELECT
		M.CUID
		, M.USERID
		, M.PWD
		, M.PWD AS USER_PWD
		, USER_NM AS USERNAME    -- 개인이름
		, M.MEMBER_CD
		, '' AS COM_NM    -- 기업명(기업만 사용)
		, ISNULL(M.EMAIL,'') AS EMAIL
		, ISNULL(M.HPHONE,'') AS HPHONE
		, '' AS PHONE
		, '' AS ADDR_A
		, '' AS ADDR_B
		, '' AS SECTION_CD     -- 섹션별 동의 해야 이용가능
		, M.BAD_YN
		, CASE WHEN LEN(M.BIRTH) = 8 THEN SUBSTRING(M.BIRTH,3,6) ELSE M.BIRTH END AS JUMINNO_A        --주민번호_A
		, M.DI
		, M.REST_YN
		, ISNULL(M.ADULT_YN,'') AS ISADULT
		, '' AS SNS_TYPE
		, DATEDIFF(DAY, M.PWD_NEXT_ALARM_DT, GETDATE()) AS PWD_ALARM_YN
		, M.JOIN_DT
		, OUT_YN AS OUT_APPLY_YN
	FROM 
		CST_MASTER M
	WHERE 
		M.CUID = @CUID AND M.OUT_YN='N'
	
	
	-- 어플 로그인 위한 키 발급
	DECLARE @MKEY_ORG NVARCHAR(100)		--이전 입력된 키값
	DECLARE @RTN_MKEY NVARCHAR(100)		--조회후 리턴할 키값
	SET @MKEY_ORG = ''
	SET @RTN_MKEY = ''

	SELECT TOP 1 @MKEY_ORG = MKEY FROM MM_MB_APP_LOGIN_TB WHERE MID = @MID AND MB_SECTION_CD = @MB_SECTION_CD

	IF ( @MKEY_ORG = @MKEY )
		BEGIN
			UPDATE MM_MB_APP_LOGIN_TB SET MKEY = @UPDATE_MKEY, last_access_date = GETDATE() WHERE MID = @MID AND MB_SECTION_CD = @MB_SECTION_CD
			SET @RTN_MKEY = @UPDATE_MKEY
		END
	ELSE
		BEGIN
			SET @RTN_MKEY = '401'
		END

	SELECT @RTN_MKEY AS MKEY
GO
/****** Object:  StoredProcedure [dbo].[MB_APP_LOGIN_NEW]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
*  단위 업무 명 : 모바일 어플 기업, 일반 회원 로그인 체크
*  작   성   자 : 함창훈(innerspace@mediawill.com)
*  작   성   일 : 
*  수   정   자 :
*  수   정   일 :
*  설        명 : 
*  주 의  사 항 : 
*  사 용  소 스 : 
-- EXEC [dbo].[MB_APP_LOGIN_NEW] [회원아이디], [비밀번호], [디바이스아이디], [디바이스암호화키], [모바일섹션코드]
-- EXEC [dbo].[MB_APP_LOGIN_NEW] 'entjssin', 'jjss0486', '', '', 'A404'
*************************************************************************************/
CREATE PROCEDURE [dbo].[MB_APP_LOGIN_NEW]
	@USERID					VARCHAR(50)				-- 회원아이디
, @PASSWORD				VARCHAR(32)				-- 비번
, @MID						NVARCHAR(400)			-- 디바이스아이디
, @MKEY						NVARCHAR(100)			-- 디바이스암호화키
, @MB_SECTION_CD	NVARCHAR(4)				-- 모바일섹션코드(A404 : 요리음식전문앱 -> MEMBER.dbo.CC_SECTION_TB 참조)
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @RTN INT = 400 -- 기본 (400:사용자가없음)
	EXEC @RTN = [dbo].[SP_LOGIN] @USERID, @PASSWORD, @MB_SECTION_CD, '', ''

	--IF @RTN = 0
	--	BEGIN

	--	END

END
GO
/****** Object:  StoredProcedure [dbo].[MB_CHK_LOGIN_PROC_NOPWD]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 기업, 일반 회원 로그인 체크(비번 없음)
 *  작   성   자 : 김 준 홍
 *  작   성   일 : 
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * EXEC MB_CHK_LOGIN_PROC_NOPWD NULL
 
 select * FROM CST_MASTER where userid ='kkam1234'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[MB_CHK_LOGIN_PROC_NOPWD]
    @CUID    INT
AS
BEGIN

	SET NOCOUNT ON
		
	DECLARE @RTN INT
	SET @RTN = 0
	
	DECLARE @ERROR INT

	SELECT
		ROW_NUMBER()  OVER( ORDER BY M.CUID DESC) AS ROW,
		M.USERID,
		M.USER_NM AS USERNAME,
		M.MEMBER_CD,
		ISNULL(C.COM_NM, '') AS COM_NM,
		ISNULL(M.EMAIL, '') AS EMAIL,
		ISNULL(M.HPHONE, '') AS HPHONE,
		ISNULL(C.PHONE, '') AS PHONE,
		ISNULL(C.ADDR1, '') AS ADDR_A,
		ISNULL(C.ADDR2, '') AS ADDR_B,
		'S101' AS SECTION_CD, /* 회원통합 후 의미없어짐 */
		M.BAD_YN,
		M.BIRTH AS JUMINNO_A,
		M.DI,		
		M.REST_YN,
		M.ADULT_YN AS ISADULT,
		M.SNS_TYPE,
		DATEDIFF(DAY, M.PWD_NEXT_ALARM_DT, GETDATE()) AS PWD_ALARM_YN,
		M.JOIN_DT,
		M.GENDER
	FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
	WHERE M.OUT_YN='N'			
		AND M.CUID = @CUID
		AND ( M.STATUS_CD IN ('W','A') OR M.STATUS_CD IS NULL ) 

	/* NULL : 통합 전    로그인 가능
				W : 통합 승인대기중  로그인 가능
				A : 통합 후 마스터계정   로그인 가능
				D : 통합 후 서브계정  로그인 불가능
				*/
		
	SELECT @ERROR=@@ERROR
	IF @ERROR<>0            --조회 에러
	BEGIN
		SET @RTN = 101
	END

	--회원 휴면 여부 판단
	DECLARE @REST_YN CHAR(1)  
	SELECT @REST_YN = REST_YN
	FROM CST_MASTER WITH (NOLOCK)
	WHERE CUID = @CUID AND OUT_YN='N'

	IF @REST_YN = 'Y' 
	BEGIN
		--휴면 회원 ID는 휴면 회원 페이지로 이동
		SET @RTN = 99
	END
	
	DECLARE @MEMBER_CD    CHAR(1)
	SELECT
		@MEMBER_CD = MEMBER_CD
	FROM CST_MASTER WITH(NOLOCK)
	WHERE CUID = @CUID
		AND OUT_YN='N'   

	SELECT @ERROR=@@ERROR
	IF @ERROR<>0            --조회 에러
	BEGIN
		SET @RTN = 100
	END

	IF @MEMBER_CD IS NULL   --로그인 실패
	BEGIN
		SET @RTN = 1
	END	
  
	SELECT @RTN AS RTN

END
GO
/****** Object:  StoredProcedure [dbo].[MB_LAND_DETAIL_GET_LOGO_INFO]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 부동산 모바일 상세 로고 이미지 콜
 *  작   성   자 : 정헌수
 *  작   성   일 : 2017-03-29
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 MB_LAND_DETAIL_GET_LOGO_INFO 0
************************************************************************************/
CREATE   PROC [dbo].[MB_LAND_DETAIL_GET_LOGO_INFO]
      @CUID		INT=NULL
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT isnull(B.LOGO_IMG, '') AS AGENCY_LOGO
	FROM MWMEMBER.DBO.CST_MASTER A WITH(NOLOCK)
	JOIN MWMEMBER.DBO.CST_COMPANY_LAND B WITH(NOLOCK) ON B.COM_ID = A.COM_ID
	WHERE CUID = @CUID
END
GO
/****** Object:  StoredProcedure [dbo].[MW_CST_MASTER_S2]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
*객체이름 : 통합회원DB로 써브회원DB 조회 - 회원정보
*파라미터 : 
*제작자 : kjh
*버젼 :
*제작일 : 2016.08.17
*변경일 :
*그외 :		
*실행예제 : 
			exec dbo.MW_CST_MASTER_S2 13783576
****************************************************************************************************/

CREATE PROCEDURE [dbo].[MW_CST_MASTER_S2]

	@CUID		int = 0

AS
	set nocount on
	SET TRANSACTION ISOLATION LEVEL READ uncommitted
BEGIN


	SELECT	e.emp_seq
			, e.name, m.name br_name, m.phone br_phone, isnull(m.homepage,'') br_homepage
			, m.mem_type
			, (select top 1 main_svc_code from [221.143.23.211,8019].cont.dbo.contract c with(nolock) 
				join [221.143.23.211,8019].rserve.dbo.service s with(nolock) on s.svc_code = c.main_svc_code 
				where c.mem_seq = m.mem_seq and (c.svc_type in (101202,101211,101219,101227,101229,101230) or c.main_svc_code = 100004) and c.stat = 'O' and convert(varchar(10),getdate(),121) between convert(varchar(10),c.svc_sdate,121) and convert(varchar(10),c.svc_edate,121) order by serve_svc_code desc) svc_code
			, agencyYN
	FROM
		MWMEMBER.DBO.CST_MASTER A with(nolock) 
		join [221.143.23.211,8019].rserve.dbo.member m with (nolock)on A.CUID=m.mem_seq
		join [221.143.23.211,8019].rserve.dbo.member_employee e with (nolock) ON m.mem_seq = e.mem_seq and e.type = '100901' and e.stat = '101101'	--사장
		left outer join [221.143.23.211,8019].rserve.dbo.member_branch mb with (nolock) ON m.mem_seq = mb.mem_seq	--가맹점
	WHERE m.mem_seq = @CUID	

END




GO
/****** Object:  StoredProcedure [dbo].[PUT_AD_EPAPER_SUBC_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 ePAPER 정기구독 여부
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/17
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC PUT_AD_EPAPER_SUBC_PROC '11555456',1

 *************************************************************************************/
CREATE	PROCEDURE [dbo].[PUT_AD_EPAPER_SUBC_PROC]
   @CUID          INT,
	 @READINGFLAG   CHAR(1)
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
  DECLARE @ROWCOUNT   INT

  IF @READINGFLAG='1' 
  BEGIN
    UPDATE FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB
       SET READINGFLAG = '1'
         , MODDATE = GETDATE()
     WHERE CUID = @CUID
     
    SELECT @ROWCOUNT=@@ROWCOUNT
    
    IF @ROWCOUNT=0
    BEGIN
      INSERT FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB
           ( USERID, USERNAME, USERPHONE, USEREMAIL1, READINGFLAG, REGDATE, CUID )
      SELECT USERID, USER_NM, HPHONE, EMAIL, '1', GETDATE(), @CUID
        FROM CST_MASTER WITH (NOLOCK)
       WHERE CUID = @CUID
    END
  END
  ELSE
  BEGIN
    UPDATE FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB
       SET READINGFLAG = '0'
         , DELDATE = GETDATE()
     WHERE CUID = @CUID
  END
GO
/****** Object:  StoredProcedure [dbo].[PUT_AD_MM_COMPANY_TB_INFO_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
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
/****** Object:  StoredProcedure [dbo].[PUT_AD_MM_HISTORY_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 개인회원상세 > 고객관리 현황 입력
 *  작   성   자 : 안상미
 *  작   성   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : 

 *************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_AD_MM_HISTORY_PROC]
   @CUID        INT
	,@USERID		  VARCHAR(50)		-- 회원아이디
	,@ADUSERID		VARCHAR(20)		-- 섹션코드
	,@MEMBER_CD		CHAR(1)			-- 불량회원여부
	,@MEMGBN		  VARCHAR(30)		-- 회원상태구분
	,@MEMO			  VARCHAR(500)	-- 불량처리아이디
	
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
	

	INSERT INTO DBO.MM_AD_HISTORY_TB(
				 USERID
				,ADUSERID
				,ADUSERNAME
				,BRANCHCODE
				,MEMBER_CD
				,MEMGBN
				,REG_DT
				,MOD_DT
				,MEMO
				,CUID
				)	

		SELECT	@USERID
				,@ADUSERID
				,MAGNAME
				,BRANCHCODE
				,@MEMBER_CD
				,@MEMGBN
				,GETDATE()
				,GETDATE()
				,@MEMO
			  ,@CUID
		  FROM	FINDDB2.FINDCOMMON.DBO.COMMONMAGUSER WITH(NOLOCK)
		 WHERE	MAGID = @ADUSERID
GO
/****** Object:  StoredProcedure [dbo].[PUT_AD_MM_MEMBER_HISTORY_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 정보 수정 로그
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015/02/24
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 :  
 *  주 의  사 항 : 
 *  사 용  소 스 : EXEC PUT_AD_MM_MEMBER_HISTORY_PROC 'SEBILIA','S101','SEBILIA','테스트'

 *************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_AD_MM_MEMBER_HISTORY_PROC]
      @CUID         INT,
	    @USERID		    VARCHAR(50),		-- 회원아이디
	    @SECTION_CD   CHAR(4),
	    @MAG_ID       VARCHAR(30),
	    @COMMENT      VARCHAR(100)
AS		
	
---------------------------------
-- 데이타 처리
---------------------------------
SET NOCOUNT ON

INSERT MM_MEMBER_HISTORY_TB
     ( USERID, SECTION_CD, MAG_ID, MAG_NAME, MAG_BRANCH, COMMENT, CUID )
SELECT @USERID, @SECTION_CD, @MAG_ID, MagName, BranchCode, @COMMENT, @CUID
  FROM FINDDB2.FINDCOMMON.DBO.COMMONMAGUSER WITH (NOLOCK)
 WHERE MagID = @MAG_ID
GO
/****** Object:  StoredProcedure [dbo].[PUT_BIZ_JOB_AGENCY_UPDATE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원가입대행 최종 업데이트 및 이력
 *  작   성   자 : 배진용
 *  작   성   일 : 2020/10/26
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 :  
 *  사 용  소 스 :
 *  사 용  예 제 :

 exec dbo.[PUT_BIZ_JOB_AGENCY_UPDATE_PROC] '14208605','bjy@mediawill.com','yong89'

*************************************************************************************/

create PROCEDURE [dbo].[PUT_BIZ_JOB_AGENCY_UPDATE_PROC]
	@CUID		VARCHAR(50) = '',
	@EMAIl		VARCHAR(50) = '',
	@USERID		VARCHAR(50) = '',
	@BIZNO		VARCHAR(50) = '',
	@ADULT_YN	VARCHAR(2) = '',
	@GENDER		VARCHAR(2) = '',
	@BIRTHDATE	VARCHAR(10) = '',
	@NAME		VARCHAR(20) = ''
AS
BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- 사업자 ID 가져오기
	DECLARE @COM_ID VARCHAR(20)
	SELECT TOP 1 @COM_ID =COM_ID FROM CST_MASTER with(NOLOCK)
	WHERE CUID = @CUID
	
	-- 회원가입대행 최종 가입및 이메일 저장
	UPDATE DBO.CST_MASTER
	   SET LAST_SIGNUP_YN = 'Y'
		 , EMAIL = @EMAIl
		 , MOD_DT = GETDATE()
		 , ADULT_YN = @ADULT_YN
		 , GENDER = @GENDER
		 , BIRTH = @BIRTHDATE
		 , USER_NM = @NAME
	 WHERE CUID = @CUID

	-- 담당자 이메일 수정
	UPDATE CST_COMPANY_JOB 
	   SET MANAGER_EMAIL = @EMAIl 
	 WHERE COM_ID = @COM_ID

	 -- 사업자번호가 변경 되었으면 수정
	IF @BIZNO <> '' 
		BEGIN
			UPDATE CST_COMPANY
			SET REGISTER_NO = @BIZNO
			  , MOD_DT = GETDATE()
			WHERE COM_ID = @COM_ID
		END

	-- 최종회원가입 대행 이력 테이블에 사업자 번호 변수
	SELECT TOP 1 @BIZNO = REGISTER_NO FROM CST_COMPANY with(NOLOCK)
	WHERE COM_ID = @COM_ID
		

	-- 회원가입대행 최종 가입 이력 
	INSERT INTO [CST_MASTER_AGENCY_HISTORY] ([CUID], [USERID], [MOD_DT], [EMAIL], [BIZNO], [LAST_SIGNUP_YN], [AGENCY_YN] )
	VALUES(@CUID, @USERID, GETDATE(), @EMAIl, @BIZNO, 'Y', 'Y')
END




GO
/****** Object:  StoredProcedure [dbo].[PUT_CST_CARE_PROVIDE_MEMBER_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 벼룩시장 케어 회원 연동 저장
 *  작   성   자 : 조재성
 *  작   성   일 : 2021-07-08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 :
 
 *************************************************************************************/

CREATE PROC [dbo].[PUT_CST_CARE_PROVIDE_MEMBER_PROC]
	 @CUID		INT
	 ,@INFLOW_ROUTE	CHAR(4)
AS
BEGIN
	SET NOCOUNT ON
	
	IF NOT EXISTS(SELECT IDX FROM CST_CARE_PROVIDE_MEMBER_TB WITH(NOLOCK) WHERE CUID = @CUID)
	BEGIN
		INSERT INTO CST_CARE_PROVIDE_MEMBER_TB (CUID,INFLOW_ROUTE) VALUES (@CUID,@INFLOW_ROUTE)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_CST_PERSON_HP_DUPLICATE_TB_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 핸드폰 중복 체크 
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-08-17
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  주 의  사 항 :
 *  사 용  소 스 :
 
 DECLARE @SS INT
 exec @SS = GET_CST_PERSON_HP_DUPLICATE_TB_PROC 13222380,'010-2139-8258'
 select @SS
 
 go
 DECLARE @SS INT
 exec @SS = GET_CST_PERSON_HP_DUPLICATE_TB_PROC 13222381,'010-2139-8258'
 select @SS
 go
 
 select COUNT(*),
		MAX(ISNULL(B.STAT,0))
		 FROM CST_MASTER A
 	LEFT OUTER JOIN  CST_PERSON_HP_DUPLICATE_TB B WITH(NOLOCK)  ON A.CUID = B.CUID AND B.STAT = 1 AND B.CUID = 13222381
	where A.hphone = '010-2139-8258' AND A.MEMBER_CD = 1

 *************************************************************************************/

CREATE PROC [dbo].[PUT_CST_PERSON_HP_DUPLICATE_TB_PROC]
	 @CUID		INT	-- 회원명
	,@HPHONE	varchar(14)
AS
BEGIN
	SET NOCOUNT ON
	UPDATE A
	SET STAT = 0
	, MODDT = GETDATE()
	FROm CST_PERSON_HP_DUPLICATE_TB A 
	WHERE HPHONE = @HPHONE AND STAT = 1 AND CUID <> @CUID 
	
	IF NOT EXISTS(SELECT * FROM CST_PERSON_HP_DUPLICATE_TB WITH(NOLOCK)
					WHERE CUID = @CUID AND STAT = 1)
	INSERT  CST_PERSON_HP_DUPLICATE_TB (CUID
		,HPHONE
		,REGDT
		,STAT
		,MODDT)
	SELECT @CUID, @HPHONE,GETDATE(),1,NULL 
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_CST_REST_MEMBER_HP_AUTH_CODE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 휴면회원 계정 해제 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 신 장 순
 *  작   성   일 : 2015-08-10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 휴면회원 계정 해제를 위한 핸드폰 인증을 함
 *  주 의  사 항 :
 *  사 용  소 스 :
EXEC PUT_MM_MEMBER_HP_AUTH_CODE_PROC '011sos0113','신장순','010-7377-9770','19830719','R'
SELECT * FROM MM_REST_HP_AUTH_CODE_TB
************************************************************************************/
CREATE PROC [dbo].[PUT_CST_REST_MEMBER_HP_AUTH_CODE_PROC]
       @USERID      VARCHAR(50)
     , @USERNAME    VARCHAR(30)
     , @HP          VARCHAR(14)
	 , @JUMINNO			CHAR(8)
     , @TYPE        CHAR(1) = 'R'	-- R:휴면회원 계정 해제     
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ROWCOUNT INT
	DECLARE @RANDOMCHAR   CHAR(6)

	DECLARE @RANDOM INT
	SELECT @RANDOM = RAND() * 1000000
	SET @RANDOMCHAR = REPLICATE('0', 6 - LEN(@RANDOM)) + CAST(@RANDOM AS VARCHAR)

	UPDATE CST_REST_HP_AUTH_CODE_TB
		 SET IDCODE = @RANDOMCHAR
			 , DT = GETDATE()
			 , TYPE = @TYPE
			 , HP = @HP
			 , USERNAME = @USERNAME
			 , JUMINNO = @JUMINNO
	 WHERE USERID = @USERID
		 AND TYPE = @TYPE

	SELECT @ROWCOUNT = @@ROWCOUNT

	IF @ROWCOUNT = 0
		BEGIN
				INSERT CST_REST_HP_AUTH_CODE_TB
						 ( USERID, USERNAME, HP, JUMINNO, DT, IDCODE, TYPE)
				VALUES
						 ( @USERID, @USERNAME, @HP, @JUMINNO, GETDATE(), @RANDOMCHAR, @TYPE)
		END


	DECLARE @MSG VARCHAR(80)
	
	SET @MSG='[벼룩시장] 휴면계정 해제 인증번호 ['+@RANDOMCHAR+']를 입력해 주세요.'
	EXEC FINDDB1.COMDB1.DBO.PUT_SENDSMS_PROC '02-2187-7867','벼룩시장',@USERNAME ,@HP ,@MSG ,'FINDALL'

END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_COMPANY_INFO_JOB_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 구인 기업 정보 변경
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-03-14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *  사 용  소 스 :
 select * from cst_master where userid= 'cowto7602'
 select * from cst_company where com_id = 10007475
*************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_F_COMPANY_INFO_JOB_PROC]
	 @CUID				        INT
	,@USERID		          VARCHAR(50)	  -- 회원아이디
	,@SECTION_CD          CHAR(4)       -- 구인(S102)
	,@COM_NM		          VARCHAR(50)	  -- 회사명
	,@CEO			            VARCHAR(30)	  -- 대표자
	,@MAIN_NUMBER         VARCHAR(14)	  -- 대표번호
	,@FAX                 VARCHAR(14)
	,@HOMEPAGE		        VARCHAR(100)	-- 홈페이지
	,@LAT                 DECIMAL(16, 14)
	,@LNG                 DECIMAL(17, 14)
	,@ZIP_SEQ             INT
	,@CITY			          VARCHAR(50) 	-- 시
	,@GU			            VARCHAR(50) 	-- 구
	,@DONG		            VARCHAR(50)	  -- 동
	,@ADDR1	              VARCHAR(100)	-- 번지
	,@ADDR2	              VARCHAR(100)	-- 상세주소	
	,@LAW_DONGNO		      CHAR(10)
	,@MAN_NO				      VARCHAR(25)	
	,@ROAD_ADDR_DETAIL		VARCHAR(100)	
	,@MANAGER_NM          VARCHAR(30)
	,@MANAGER_PHONE       VARCHAR(15)
	,@MANAGER_EMAIL       VARCHAR(50)
	,@EMP_CNT		          VARCHAR(7)	  -- 종업원수
	,@MAIN_BIZ		        VARCHAR(100)	-- 주요사업내용
	,@BIZ_CLASS		        VARCHAR(100)	  -- 업종
	,@BIZ_CODE		        VARCHAR(100)	-- 기업분류
	,@LOGO_IMG		        VARCHAR(200)	-- 로고이미지
	,@EX_IMAGE_1	        VARCHAR(200)	-- 기타 이미지
	,@EX_IMAGE_2	        VARCHAR(200)	-- 기타 이미지
	,@EX_IMAGE_3	        VARCHAR(200)	-- 기타 이미지
	,@EX_IMAGE_4	        VARCHAR(200)	-- 기타 이미지
AS

DECLARE @COM_ID INT
DECLARE @COUNT INT

SELECT @COM_ID = COM_ID
  FROM CST_MASTER
 WHERE CUID = @CUID

IF @ZIP_SEQ = 0 
BEGIN
	SET @ZIP_SEQ = NULL
END		  
	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한
		  
--------------------------------
--벼룩시장 기업회원 테이블
--------------------------------
UPDATE CST_COMPANY
   SET COM_NM = @COM_NM
     , CEO_NM = @CEO
     , MAIN_PHONE = @MAIN_NUMBER
     , FAX = @FAX
     , HOMEPAGE   = @HOMEPAGE
     , LAT = @LAT
     , LNG = @LNG
     , ZIP_SEQ = @ZIP_SEQ
	   , CITY		= @CITY
	   , GU			= @GU
     , DONG   = @DONG
     , ADDR1  = @ADDR1
     , ADDR2  = @ADDR2
     , LAW_DONGNO		= @LAW_DONGNO
     , MAN_NO				= @MAN_NO
     , ROAD_ADDR_DETAIL  = @ROAD_ADDR_DETAIL
     , MOD_DT     = GETDATE()
     , MOD_ID	=	@USERID
 WHERE COM_ID = @COM_ID
 
 SELECT @COUNT = COUNT(*)
 FROM CST_COMPANY_JOB
 WHERE COM_ID = @COM_ID
 
IF @COUNT = 0
BEGIN
	INSERT
    INTO CST_COMPANY_JOB
        (MANAGER_NM
        ,MANAGER_PHONE
        ,MANAGER_EMAIL
        ,EMP_CNT
        ,MAIN_BIZ
        ,BIZ_CLASS
        ,BIZ_CD
        ,LOGO_IMG
        ,EX_IMAGE_1
        ,EX_IMAGE_2
        ,EX_IMAGE_3
        ,EX_IMAGE_4
        ,COM_ID
        ,USERID
        ,SECTION_CD
		)
  VALUES
        (@MANAGER_NM
        ,@MANAGER_PHONE
        ,@MANAGER_EMAIL
        ,@EMP_CNT
        ,@MAIN_BIZ
        ,@BIZ_CLASS
        ,@BIZ_CODE
        ,@LOGO_IMG
        ,@EX_IMAGE_1
        ,@EX_IMAGE_2
        ,@EX_IMAGE_3
        ,@EX_IMAGE_4
        ,@COM_ID
        ,@USERID
        ,@SECTION_CD
        )
END
ELSE
BEGIN
	UPDATE CST_COMPANY_JOB
	   SET MANAGER_NM = @MANAGER_NM
		 , MANAGER_PHONE = @MANAGER_PHONE
		 , MANAGER_EMAIL = @MANAGER_EMAIL
		 , EMP_CNT    = @EMP_CNT
		 , MAIN_BIZ   = @MAIN_BIZ   
		 , BIZ_CLASS  = @BIZ_CLASS
		 , BIZ_CD	  = @BIZ_CODE
		 , LOGO_IMG   = @LOGO_IMG
		 , EX_IMAGE_1 = @EX_IMAGE_1
		 , EX_IMAGE_2 = @EX_IMAGE_2
		 , EX_IMAGE_3 = @EX_IMAGE_3
		 , EX_IMAGE_4 = @EX_IMAGE_4         
	 WHERE COM_ID = @COM_ID
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_COMPANY_INFO_LAND_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
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
/****** Object:  StoredProcedure [dbo].[PUT_F_CST_SERVICE_USE_AGREE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 회원 공통 > 서비스이용동의
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2018/09/28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 
 declare @RESULT INT 
 EXEC dbo.PUT_F_CST_SERVICE_USE_AGREE_PROC 0 ,@RESULT OUTPUT
 select @RESULT
 
truncate table CST_SERVICE_USE_AGREE
 
 declare @RESULT INT 
 exec MWMEMBER.dbo.PUT_F_CST_SERVICE_USE_AGREE_PROC 10370929,'S102','9','','',' ',@RESULT OUTPUT
 select @RESULT
 
 *************************************************************************************/

 
CREATE PROC [dbo].[PUT_F_CST_SERVICE_USE_AGREE_PROC]

  @CUID         INT
  ,@SECTION_CD	CHAR(4)       -- 섹션코드 (CC_SECTION_TB 참고)
  ,@AGREE_CD	  VARCHAR(10)     -- 서비스코드 (SELECT * FROM CMN_CODE WHERE CODE_GROUP_ID = 'SERVICE_CD' 참고)

  ,@USER_NM     VARCHAR(30) = ''
  ,@BIRTH       VARCHAR(8)  = ''
  ,@GENDER      CHAR(1)     = ''

  ,@DI          VARCHAR(70) = ''

  ,@RESULT INT = 999 OUTPUT

  ,@MEMBER_CD CHAR(1) = '1'
  ,@HPHONE VARCHAR(14)  = ''

  ,@CI          VARCHAR(88) = ''

AS

  SET NOCOUNT ON

  SET @HPHONE = REPLACE(@HPHONE,'-','')

  DECLARE @DUP_CNT INT

  DECLARE @VAL_DI CHAR(64)
  DECLARE @VAL_MEMBER_CD CHAR(1)
  DECLARE @VAL_SNSF CHAR(1)
  DECLARE @VAL_USER_NM VARCHAR(30)
  DECLARE @VAL_BIRTH VARCHAR(8)
  DECLARE @VAL_HPHONE VARCHAR(14)
  DECLARE @VAL_GENDER CHAR(1)

  -- 기존 정보
  SELECT @VAL_DI = ISNULL(DI,'')
        ,@VAL_USER_NM = USER_NM
        ,@VAL_MEMBER_CD = MEMBER_CD
        ,@VAL_SNSF = CASE ISNULL(SNS_TYPE,'') WHEN '' THEN '0'
                          ELSE '1'
                          END
        ,@VAL_BIRTH   = BIRTH
        ,@VAL_HPHONE  = REPLACE(HPHONE,'-','')
        ,@VAL_GENDER  = GENDER
    FROM CST_MASTER
   WHERE CUID = @CUID

  IF @DI <> ''   -- 휴대폰 본인인증을 통하면서 기존 ID값이 있는 경우
    BEGIN
      -- 성별값 치환
      IF @GENDER = '1'
        BEGIN
          SET @GENDER = 'M'
        END
      ELSE IF @GENDER = '0'
        BEGIN
          SET @GENDER = 'F'
        END

    -- 일치하는 회원정보가 있는지 확인
    IF @VAL_HPHONE <> @HPHONE
		BEGIN
			SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
			RETURN
		END 
/*
      --IF NOT EXISTS(SELECT * FROM CST_MASTER WHERE CUID = @CUID AND DI = @DI AND OUT_YN = 'N')
      IF @VAL_SNSF = '1'  -- SNS 회원
        BEGIN
          IF @VAL_HPHONE <> @HPHONE
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END 
        END
      ELSE
        BEGIN
          -- 성명/휴대폰 번호 일치여부 확인 (성별,생년월일은 저장하지 않음으로 비교 대상이 아님.)
          IF (@VAL_USER_NM != @USER_NM OR @VAL_HPHONE != @HPHONE)
            BEGIN
              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
              RETURN
            END
        END

--      IF @VAL_MEMBER_CD = '1' AND @VAL_SNSF = '0'  -- 개인회원
--        BEGIN
--          IF (@VAL_USER_NM != @USER_NM OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
--            BEGIN
--              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
--              RETURN
--            END
--        END
--
--
--      IF @VAL_MEMBER_CD = '2'   -- 기업회원
--        BEGIN
--          IF (@VAL_USER_NM != @USER_NM OR @VAL_BIRTH != @BIRTH OR @VAL_HPHONE != @HPHONE)
--            BEGIN
--              SET @RESULT = 2     -- 회원가입정보가 일치하지 않는 경우
--              RETURN
--            END
--        END
*/

/*
      SELECT @DUP_CNT = COUNT(*)
        FROM CST_SERVICE_USE_AGREE
       WHERE CUID IN (SELECT CUID FROM CST_MASTER WHERE DI = @DI AND MEMBER_CD = @MEMBER_CD  AND OUT_YN = 'N')
*/
      SELECT @DUP_CNT = COUNT(*)
        FROM CST_MASTER AS A
       WHERE DI = @DI AND MEMBER_CD = @MEMBER_CD  AND OUT_YN = 'N'
         AND CUID IN (SELECT DISTINCT CUID FROM CST_SERVICE_USE_AGREE WHERE AGREE_CD = @AGREE_CD)

      IF @DUP_CNT > 2
        BEGIN
          SET @RESULT = 1     -- 서비스이용동의한 동일정보의 회원이 3개이상 존재하는 경우
          RETURN
        END

      -- 개인회원인 경우 DI값, GENDER값 갱신
      IF @VAL_MEMBER_CD = '1'
        BEGIN
          UPDATE CST_MASTER
             SET DI = @DI
                ,CI = @CI
                ,BIRTH = @BIRTH
                ,GENDER = @GENDER
                ,USER_NM = @USER_NM
           WHERE CUID = @CUID
        END

      -- 기업회원이면서 DI값이 없었던 경우 DI,CI값 갱신
      IF @VAL_MEMBER_CD = '2' AND @VAL_DI = ''
        BEGIN
          UPDATE CST_MASTER
             SET DI = @DI
                ,CI = @CI
           WHERE CUID = @CUID
        END

      -- SNS회원인 경우 회원정보 갱신 (본인인증처에서 보낸 정보로)
      IF @VAL_SNSF = '1'
        BEGIN
          UPDATE CST_MASTER
             SET USER_NM = @USER_NM
                ,BIRTH = @BIRTH
                ,GENDER = @GENDER
                --,HPHONE = @HPHONE
           WHERE CUID = @CUID
        END

    END

  -- 동의코드 중복되지 않는다면 등록
  IF NOT EXISTS(SELECT * FROM CST_SERVICE_USE_AGREE WHERE AGREE_CD = @AGREE_CD AND CUID = @CUID)
    BEGIN
      INSERT INTO CST_SERVICE_USE_AGREE
        (CUID
        ,SECTION_CD
        ,AGREE_CD)
      VALUES
        (@CUID
        ,@SECTION_CD
        ,@AGREE_CD)
    END

    SET @RESULT = 0     -- 이용동의 처리 완료


GO
/****** Object:  StoredProcedure [dbo].[PUT_F_MARKETING_AGREE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 마케팅.이벤트 수신동의
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2018/12/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
   -- 마케팅 이용동의 회원 가져오기
   SELECT * FROM CST_MASTER AS A JOIN CST_MARKETING_AGREEF_TB AS B ON B.CUID = A.CUID WHERE B.AGREEF = 1
 *************************************************************************************/


CREATE PROC [dbo].[PUT_F_MARKETING_AGREE_PROC]

  @CUID INT
  ,@AGREEF TINYINT = 0

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  IF @AGREEF = 1 AND EXISTS(SELECT * FROM CST_MARKETING_AGREEF_TB WITH(NOLOCK) WHERE CUID=@CUID AND AGREEF = 1)    -- 이미 동의한 이력이 있다면 동의일자 유지를 위해 아무것도 안함.
    BEGIN
      RETURN
    END
  ELSE
    BEGIN
      DELETE FROM CST_MARKETING_AGREEF_TB WHERE CUID = @CUID

      INSERT INTO CST_MARKETING_AGREEF_TB
        (CUID,AGREEF)
      VALUES
        (@CUID,@AGREEF)
    END
GO
/****** Object:  StoredProcedure [dbo].[PUT_F_SENDBILL_BIZNO_ACCESS_ERROR_LOG_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 센드빌 사업자등록번호체크 API 접근오류 로그 수집 저장
 *  작   성   자 : 조 재 성
 *  작   성   일 : 2021/09/07
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : 
 *************************************************************************************/
CREATE PROC [dbo].[PUT_F_SENDBILL_BIZNO_ACCESS_ERROR_LOG_PROC]
	@BIZNO CHAR(10),
	@DOMAIN VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO MWMEMBER.DBO.PP_SENDBILL_BIZNO_ACCESS_ERROR_LOG_TB
(BIZNO,DOMAIN) 
VALUES
(@BIZNO,@DOMAIN);
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_BRAND_DATA_REG_MEMBER_REGIST_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 구인관리자 > 브랜드 일괄 등록 > 회원 등록
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2015/07/27
 *  수   정   자 :
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC PUT_M_BRAND_DATA_REG_MEMBER_REGIST_PROC
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_BRAND_DATA_REG_MEMBER_REGIST_PROC]
AS 
  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

  UPDATE TEMP_REG_BIZMEMBER_TB
  SET CITY = dbo.FN_CITY(CITY)

  DECLARE @ERROR INT

  SET @ERROR = 0

  SET	XACT_ABORT ON
  BEGIN TRAN

  --------------------------------
  -- 회원 공통테이블
  --------------------------------
	  INSERT INTO	DBO.CST_MASTER (
      USERID
    , USER_NM
    , BAD_YN
    , JOIN_DT
    , MOD_DT
    , MOD_ID
    , pwd_sha2
    , PWD_NEXT_ALARM_DT
    , MEMBER_CD
    , ADULT_YN
    , HPHONE
    , EMAIL
    , GENDER
    , BIRTH
    , DI
    , CI
    , SITE_CD
    , REST_YN
    , OUT_YN
    , LAST_LOGIN_DT
    )    
	  SELECT
      USERID
		, USERNAME
    , 'N'
    , GETDATE()
    , GETDATE()
    , USERID
    , master.DBO.fnGetStringToSha256(dbo.FN_MD5(LOWER(PASSWORD))) 
    , DATEADD(DAY, 180, GETDATE())
    , '2'
    , NULL
    , HPHONE
    , EMAIL		  
    , GENDER
		, JUMINNO
    , NULL
    , NULL
    , 'J'
    , 'N'
    , 'N'
    , GETDATE()
    FROM TEMP_REG_BIZMEMBER_TB


    UPDATE A
       SET A.CUID = B.CUID
    -- SELECT *
      FROM TEMP_REG_BIZMEMBER_TB A
      JOIN DBO.CST_MASTER B ON A.USERID = B.USERID

    IF @@ERROR > 0
      SET @ERROR = @ERROR + 1

  --------------------------------
  -- 기업회원 테이블
  --------------------------------
  --> 기업메인
	  INSERT INTO	DBO.CST_COMPANY (
      REG_ID
    , COM_NM
    , CEO_NM
    , MAIN_PHONE
    , PHONE
    , FAX
    , REGISTER_NO
    , HOMEPAGE
    , LAT
    , LNG
    , CITY
    , GU
    , DONG
    , ADDR1
    , ADDR2
    , LAW_DONGNO
    , MAN_NO
    , ROAD_ADDR_DETAIL
    , REG_DT
    , MOD_ID
    , MOD_DT
    , MEMBER_TYPE
    )
	  SELECT
      A.USERID
    , A.COM_NM
    , A.CEO
    , A.PHONE
    , A.PHONE
    , NULL
    , A.BIZNO
    , A.HOMEPAGE
    , NULL
    , NULL
    , A.CITY
    , A.GU
    , A.DONG
    , A.ADDR_A
    , A.ADDR_B
    , NULL
    , NULL
    , NULL
    , GETDATE()
    , A.USERID
    , GETDATE()
    , 1
    FROM TEMP_REG_BIZMEMBER_TB A    

    UPDATE A
       SET A.COM_ID = B.COM_ID
    -- SELECT *
      FROM TEMP_REG_BIZMEMBER_TB A
      JOIN DBO.CST_COMPANY B ON A.USERID = B.REG_ID

    UPDATE A
       SET A.COM_ID = B.COM_ID
    -- SELECT *
    --  FROM CST_MASTER A
    --  JOIN DBO.CST_COMPANY B ON A.USERID = B.REG_ID
      FROM CST_MASTER A
      JOIN DBO.TEMP_REG_BIZMEMBER_TB B ON A.CUID = B.CUID


    IF @@ERROR > 0
      SET @ERROR = @ERROR + 1

  --> 기업구인 기타정보
	  INSERT INTO	DBO.CST_COMPANY_JOB (
      COM_ID
    , USERID
    , MANAGER_NM
    , MANAGER_PHONE
    , MANAGER_EMAIL
    , EMP_CNT
    , MAIN_BIZ
    , SECTION_CD
    , MOD_DT
    )
    SELECT
      COM_ID
    , USERID
    , USERNAME
    , HPHONE
    , EMAIL
    , EMP_CNT
    , MAIN_BIZ
    , SECTION_CD
    , GETDATE()
    FROM TEMP_REG_BIZMEMBER_TB A

    IF @@ERROR > 0
      SET @ERROR = @ERROR + 1

  ------------------------------------------------------------------------------------------------
  -- 메일수신동의(현재 EMAIL/SMS값을 하나로 입력 받으나 언제든지 분리할 수도 있기 때문)
  ------------------------------------------------------------------------------------------------
    INSERT INTO CST_MSG_SECTION (
      CUID
    , SECTION_CD
    , MEDIA_CD
    , AGREE_DT
    )
    SELECT 
      CUID
    , SECTION_CD
		, 'M' AS MEDIA_CD
		, GETDATE() AS AGREE_DT
    FROM TEMP_REG_BIZMEMBER_TB

    IF @@ERROR > 0
      SET @ERROR = @ERROR + 1

  ------------------------------------------------------------------------------------------------
  -- SMS 수신동의
  ------------------------------------------------------------------------------------------------
    INSERT INTO CST_MSG_SECTION (
      CUID
    , SECTION_CD
    , MEDIA_CD
    , AGREE_DT
    )
    SELECT 
      CUID
    , 'S101' AS SECTION_CD
		, 'S' AS MEDIA_CD
		, GETDATE() AS AGREE_DT
    FROM TEMP_REG_BIZMEMBER_TB

    IF @@ERROR > 0
      SET @ERROR = @ERROR + 1
  
  COMMIT TRAN

  SET	XACT_ABORT OFF

  SELECT @ERROR
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_M_BRAND_DATA_REG_MEMBER_TEMP_TABLE_REGIST_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 구인관리자 > 브랜드 일괄 등록 > TEMP 테이블 등록
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2015/07/27
 *  수   정   자 :
 *  수   정   일 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
 EXEC PUT_M_BRAND_DATA_REG_MEMBER_TEMP_TABLE_REGIST_PROC
 *************************************************************************************/
CREATE PROC [dbo].[PUT_M_BRAND_DATA_REG_MEMBER_TEMP_TABLE_REGIST_PROC]  
  @CNT                SMALLINT            = 0                 
, @USERID             VARCHAR(30)         = ''
, @PASSWORD           VARCHAR(30)         = ''
, @USERNAME           VARCHAR(30)         = ''
, @JUMINNO            CHAR(8)             = ''
, @EMAIL              VARCHAR(50)         = ''
, @PHONE              VARCHAR(14)         = ''
, @HPHONE             VARCHAR(14)         = ''
, @CITY               VARCHAR(50)         = ''
, @GU                 VARCHAR(50)         = ''
, @DONG               VARCHAR(50)         = ''
, @ADDR_A             VARCHAR(100)        = ''
, @ADDR_B             VARCHAR(100)        = ''
, @JOIN_PATH          VARCHAR(50)         = ''
, @JOIN_DOMAIN        VARCHAR(50)         = ''
, @JOIN_SECTION       VARCHAR(200)        = ''
, @MSG_SECTION        VARCHAR(200)        = ''
, @SMS_SECTION        VARCHAR(200)        = ''
, @BIZNO              CHAR(12)            = ''
, @COM_NM             VARCHAR(50)         = ''
, @CEO                VARCHAR(30)         = ''
, @MAIN_BIZ           VARCHAR(100)        = ''
, @SECTION_CD         CHAR(4)             = ''
, @GENDER             CHAR(1)             = ''
, @AUTHTYPE           CHAR(1)             = ''
, @EMP_CNT            VARCHAR(7)          = ''
, @HOMEPAGE           VARCHAR(100)        = ''
AS 
  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

  IF @CNT = 0
  BEGIN
    TRUNCATE TABLE TEMP_REG_BIZMEMBER_TB
  END

  -- 아이디가 없거나
  IF @USERID IS NULL OR LTRIM(RTRIM(@USERID)) = '' BEGIN
    RETURN;
  END

  -- 아이디가 3자 이하거나
  IF LEN(@USERID) < 4 BEGIN
    RETURN;
  END

  INSERT INTO TEMP_REG_BIZMEMBER_TB (
    USERID
  , PASSWORD
  , USERNAME
  , JUMINNO
  , EMAIL
  , PHONE
  , HPHONE
  , CITY
  , GU
  , DONG
  , ADDR_A
  , ADDR_B
  , JOIN_PATH
  , JOIN_DOMAIN
  , JOIN_SECTION
  , MSG_SECTION
  , SMS_SECTION
  , BIZNO
  , COM_NM
  , CEO
  , MAIN_BIZ
  , SECTION_CD
  , GENDER
  , AUTHTYPE
  , EMP_CNT
  , HOMEPAGE
  )
  VALUES (
    @USERID
  , @PASSWORD
  , @USERNAME
  , @JUMINNO
  , @EMAIL
  , @PHONE
  , @HPHONE
  , @CITY
  , @GU
  , @DONG
  , @ADDR_A
  , @ADDR_B
  , @JOIN_PATH
  , @JOIN_DOMAIN
  , @JOIN_SECTION
  , @MSG_SECTION
  , @SMS_SECTION
  , @BIZNO
  , @COM_NM
  , @CEO
  , @MAIN_BIZ
  , @SECTION_CD
  , @GENDER
  , @AUTHTYPE
  , @EMP_CNT
  , @HOMEPAGE
  )



END
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_AD_AGREE_EMAIL_SEND_LOG_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 마케팅 수신동의내역 알림메일 발송 로그 저장
 *  작   성   자 : 조재성
 *  작   성   일 : 2021-03-24 
 *  수   정   자 : 
 *  수   정   일 : 
 *  수 정  내 용 : 
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : PUT_MM_AD_AGREE_EMAIL_SEND_LOG_PROC
 *************************************************************************************/
CREATE PROC [dbo].[PUT_MM_AD_AGREE_EMAIL_SEND_LOG_PROC]
	@TARGET_ID INT,
	@CUID INT,
	@EMAIL VARCHAR(100),
	@RESULT_CODE VARCHAR(50),
	@RESULT_MESSAGE VARCHAR(500)
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO MM_AD_AGREE_EMAIL_SEND_LOG_TB (TARGET_ID,	CUID, EMAIL, RESULT_CODE, RESULT_MESSAGE)
	VALUES (@TARGET_ID, @CUID, @EMAIL, @RESULT_CODE, @RESULT_MESSAGE)

	IF @@error = 0 
		RETURN (0)
	ELSE
		RETURN (1)

END

GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_AD_MSG_AGREE_N1_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 메일 수신 동의 (관리자)
 *  작   성   자 : 안상미
 *  작   성   일 : 2007-12-20
 *  수   정   자 : 최병찬
 *  수   정   일 : 2011-11-11
 *  설        명 : 메일 및 SMS 로 분리 UPDATE
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE PROCEDURE [dbo].[PUT_MM_AD_MSG_AGREE_N1_PROC]
   @CUID          INT
	,@USERID			  VARCHAR(50) 	-- 회원아이디
	,@SECTION_CD		CHAR(4)			-- 섹션코드
	,@AGREEFLAG			CHAR(1)			-- 수신/수신거부 Y:수신 N:수신거부
	,@AGREE_DT			DATETIME		-- 동의날짜
	,@MEDIA_CD			CHAR(1)			-- M:메일 S:SMS
AS		

-- 중복 입력 체크
DECLARE @INTCNT	TINYINT

IF @AGREEFLAG = 'Y'
BEGIN	
	SELECT @INTCNT = COUNT(USERID) 
	  FROM CST_MSG_SECTION WITH(NOLOCK)
	 WHERE CUID = @CUID
	   AND SECTION_CD = @SECTION_CD
     AND MEDIA_CD = @MEDIA_CD

	IF @INTCNT = 0 
	BEGIN
		-- 동의 날짜 없으면 현재시각으로..
		IF @AGREE_DT = '1900-01-01 00:00:00.000'
			SET @AGREE_DT = GETDATE()
	
		INSERT CST_MSG_SECTION (
		           CUID
             , SECTION_CD
             , MEDIA_CD
             , USERID
             , AGREE_DT
		) 
		SELECT	 
		         @CUID
           , @SECTION_CD
			     , @MEDIA_CD
			     , @USERID
			     , @AGREE_DT
	END

END
ELSE
BEGIN	
	DELETE CST_MSG_SECTION
	 WHERE CUID = @CUID
	   AND SECTION_CD = @SECTION_CD
     AND MEDIA_CD = @MEDIA_CD

END
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_ADMIN_LOGIN_LOG_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 프론트 회원 로그인 > 로그쌓기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-6-3
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 :

 *************************************************************************************/
CREATE PROCEDURE [dbo].[PUT_MM_ADMIN_LOGIN_LOG_PROC]
   @CUID        INT
	,@USERID		  VARCHAR(50)	-- 회원아이디
	,@MAGID       VARCHAR(30)
	,@HOST			  VARCHAR(30)	-- 호스트(WWW.FINDALL.CO.KR)
	,@IP			    VARCHAR(15)	-- 회원PC_IP

AS
	-- 로그 쌓기
	INSERT DBO.MM_ADMIN_LOGIN_LOG_TB
	       (USERID, MAGID, LOGIN_DT, IP, HOST, CUID )
	VALUES 
	       (@USERID, @MAGID, GETDATE(), @IP ,@HOST, @CUID)

GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_HP_AUTH_CODE_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 핸드폰 인증 코드 입력 및 발송
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2013-03-04
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 회원가입 및 ID 찾기 핸드폰 인증 번호 발송
 *  수   정   자 : 여운영
 *  수   정   일 : 2015-10-21
 *  설        명 : 문자발송로그 추가
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 PUT_MM_HP_AUTH_CODE_PROC '2', '최병찬', '', '', '01032134592', '206-85-26551', 'P', 'S101'
************************************************************************************/
CREATE   PROC [dbo].[PUT_MM_HP_AUTH_CODE_PROC]
       @MEMBER_CD   CHAR(1)
     , @USERNAME    VARCHAR(30)
     , @JUMINNO     CHAR(8)
     , @GENDER      CHAR(1)
     , @HP          VARCHAR(14)
     , @BIZNO       CHAR(12)=NULL
     , @TYPE        CHAR(1)='R'
     , @SECTION_CD  CHAR(4)='S101'
     , @SNS_TYPE    CHAR(1)=NULL
     , @SNS_ID      VARCHAR(100)=NULL
     , @CUID		    INT=NULL
AS

SET NOCOUNT ON

DECLARE @ROWCOUNT INT
DECLARE @RANDOMCHAR   CHAR(6)

DECLARE @RANDOM INT

SELECT @RANDOM=RAND()*1000000
SET @RANDOMCHAR=REPLICATE('0',6-LEN(@RANDOM))+CAST(@RANDOM AS VARCHAR)

/***************** 인증코드 고정 (테스트서버에서만) *****************/
--IF @@SERVERNAME = 'WIN-RUU8V04D675'
IF @@SERVERNAME = 'ONLINEFINDTEST\FINDALL_DEV_DB'
  BEGIN
    SET @RANDOMCHAR = '000000'
  END
/***************** 인증코드 고정 (테스트서버에서만) *****************/

IF @MEMBER_CD='1' AND @SNS_TYPE<>'' AND @SNS_TYPE IS NOT NULL   --SNS 회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
         , CUID = @CUID 
     WHERE MEMBER_CD='1' 
       AND USERNAME=@USERNAME
		   AND JUMINNO=@JUMINNO
		   AND GENDER=@GENDER
       AND HP=@HP
       AND SNS_TYPE=@SNS_TYPE
       AND SNS_ID=@SNS_ID
       AND CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN CUID
                ELSE 1
           END = 
           CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN @CUID
                ELSE 1
           END

END
ELSE IF @MEMBER_CD='1'  --개인회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
         , CUID = @CUID 
     WHERE MEMBER_CD='1' 
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
       AND ISNULL(SNS_TYPE, '') = ''
       AND ISNULL(SNS_ID, '') = ''
       AND CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN CUID
                ELSE 1
           END = 
           CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN @CUID
                ELSE 1
           END

END
ELSE    --기업회원
BEGIN
    UPDATE MM_HP_AUTH_CODE_TB
       SET IDCODE=@RANDOMCHAR
         , DT=GETDATE()
         , TYPE=@TYPE
         , CUID = @CUID 
     WHERE MEMBER_CD='2' 
       AND USERNAME=@USERNAME
       AND JUMINNO=@JUMINNO
       AND GENDER=@GENDER
       AND HP=@HP
       AND BIZNO=@BIZNO
       AND CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN CUID
                ELSE 1
           END = 
           CASE 
                WHEN @CUID IS NOT NULL AND @TYPE='M' THEN @CUID
                ELSE 1
           END
END


SELECT @ROWCOUNT=@@ROWCOUNT
IF @ROWCOUNT=0
BEGIN
    INSERT MM_HP_AUTH_CODE_TB
         ( CUID, USERNAME, JUMINNO, GENDER, HP, BIZNO, DT, IDCODE, TYPE, MEMBER_CD, SNS_TYPE, SNS_ID)
    VALUES
         ( @CUID, @USERNAME, @JUMINNO, @GENDER, @HP, @BIZNO, GETDATE(), @RANDOMCHAR, @TYPE, @MEMBER_CD, @SNS_TYPE, @SNS_ID)
END

--// 비밀번호 찾기(메일인증번호 발송시 사용)
SELECT TOP 1 IDCODE, DT
FROM MM_HP_AUTH_CODE_TB (NOLOCK)
WHERE USERNAME = @USERNAME
  AND JUMINNO = @JUMINNO
	AND GENDER = @GENDER
	AND HP = @HP
	AND IDCODE = @RANDOMCHAR
	AND TYPE = @TYPE
	AND MEMBER_CD = @MEMBER_CD
	AND CASE WHEN @MEMBER_CD = '2' THEN BIZNO ELSE 'BIZNO' END = CASE WHEN @MEMBER_CD = '2' THEN @BIZNO ELSE 'BIZNO' END
  AND CASE 
           WHEN @CUID IS NOT NULL AND @TYPE='M' THEN CUID
           ELSE 1
      END = 
      CASE 
           WHEN @CUID IS NOT NULL AND @TYPE='M' THEN @CUID
           ELSE 1
      END
ORDER BY DT DESC       
--불량 회원 전화번호 목록에 존재하면 SMS 발송 안됨
IF NOT EXISTS (SELECT HP FROM MM_BAD_HP_TB WHERE HP=@HP)
BEGIN

  DECLARE @MSG NVARCHAR(4000)
  DECLARE @TEXT VARCHAR(20)

  IF @TYPE = 'I'
    SET @TEXT = '아이디찾기'
  ELSE IF @TYPE = 'P' 
    SET @TEXT = '비밀번호찾기'  
  ELSE IF @TYPE = 'M' 
    SET @TEXT = '회원정보수정'
  ELSE
    SET @TEXT = '회원가입'

  -- 카카오 알림톡 템플릿 정보 가져오기 / 전송 메시지 가공
  DECLARE @SUBJECT	varchar	(160)
  DECLARE @CALLBACK	varchar	(24)        = '0221877867'        -- 발신자번호

  SELECT @SUBJECT = LMS_TITLE
        ,@MSG = REPLACE(REPLACE(LMS_MSG,'#{구분}',@TEXT),'#{인증번호}',@RANDOMCHAR)
  -- SELECT *
    FROM OPENQUERY(FINDDB1,'SELECT LMS_MSG, LMS_TITLE FROM COMDB1.dbo.FN_GET_KKO_TEMPLATE_INFO(''MWsms02'')')

  -- SMS 발송
  EXEC FINDDB1.COMDB1.dbo.PUT_SENDSMS_PROC @CALLBACK,'','',@HP,@MSG
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_KEEP_LOGIN_LOG_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 로그인 유지> 로그쌓기
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2016-03-23
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :

declare @outtoken varchar(36) 
SET @outtoken = '6220E8F8-49B1-400F-A617-53FC80A0B0B7'
EXEC [PUT_MM_KEEP_LOGIN_LOG_PROC] 'sebilia','S101','2','www.findall.co.kr','123.111.230.51',@TOKEN = @outtoken OUTPUT
SELECT @outtoken
 *************************************************************************************/

CREATE PROCEDURE [dbo].[PUT_MM_KEEP_LOGIN_LOG_PROC]
   @CUID        INT
	,@USERID		  VARCHAR(50)	-- 회원아이디
	,@SECTION_CD	CHAR(4)		-- 섹션코드
	,@MEMBER_CD		CHAR(1)		-- 회원구분
	,@HOST			  VARCHAR(30)	-- 호스트(WWW.FINDJOB.CO.KR, 051.FINDJOB.CO.KR..)
	,@IP			    VARCHAR(15)	-- 회원PC_IP
	,@TOKEN       VARCHAR(36) OUTPUT
 
AS

IF LEN(@TOKEN)<>36
BEGIN
  --로그인 유지 쿠키 삭제
  SET @TOKEN = 'LOGOUT'
  RETURN (0)
END

IF EXISTS (
  SELECT * FROM MM_TOKEN_TB WITH (NOLOCK)
   WHERE CUID = @CUID AND TOKEN = @TOKEN
)
BEGIN     
  DECLARE @NEWTOKEN VARCHAR(36)
  
  SET @NEWTOKEN = NEWID()
  UPDATE MM_TOKEN_TB
     SET TOKEN = CAST(@NEWTOKEN AS UNIQUEIDENTIFIER)
       , LAST_LOGIN_DT = GETDATE()
   WHERE CUID = @CUID

  UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()
    WHERE CUID = @CUID			  -- 마지막 로그인 시간 

  -- 로그 쌓기
  INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) 
                     VALUES (@CUID ,@USERID, getdate(), @SECTION_CD,'Y', @IP, @HOST)

  SET @TOKEN = @NEWTOKEN

END
ELSE
BEGIN
  --로그인 유지 쿠키 삭제
  SET @TOKEN = 'LOGOUT'
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_KEEP_MOBILE_APP_LOGIN_LOG_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일 앱 회원 로그인 유지> 로그쌓기
 *  작   성   자 : 조재성
 *  작   성   일 : 2017-03-21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :

 *************************************************************************************/

CREATE PROCEDURE [dbo].[PUT_MM_KEEP_MOBILE_APP_LOGIN_LOG_PROC]
   @CUID        INT
	,@USERID		  VARCHAR(50)	-- 회원아이디
	,@SECTION_CD	CHAR(4)		-- 섹션코드
	,@MEMBER_CD		CHAR(1)		-- 회원구분
	,@HOST			  VARCHAR(30)	-- 호스트(WWW.FINDJOB.CO.KR, 051.FINDJOB.CO.KR..)
	,@IP			    VARCHAR(15)	-- 회원PC_IP
	,@STR_RETURN       VARCHAR(10) = '' OUTPUT
AS
SET NOCOUNT ON

IF EXISTS (SELECT * FROM CST_MASTER WITH (NOLOCK) WHERE CUID = @CUID AND ISNULL(REST_YN,'')<>'Y' AND ISNULL(OUT_YN,'')<>'Y')
BEGIN     

  UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()
    WHERE CUID = @CUID			  -- 마지막 로그인 시간 

  -- 로그 쌓기
  INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) 
  VALUES (@CUID ,@USERID, getdate(), @SECTION_CD,'Y', @IP, @HOST)

END
ELSE
BEGIN
  --로그인 유지 쿠키 삭제
  SET @STR_RETURN = 'LOGOUT'
END
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_MSG_AGREE_N1_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 메일 및 SMS 수신 동의
 *  작   성   자 : 최승범
 *  작   성   일 : 2016-07-19
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE PROCEDURE [dbo].[PUT_MM_MSG_AGREE_N1_PROC]
	 @USERID		VARCHAR(50) 	-- 회원아이디
	,@SECTION_CD	CHAR(4)		-- 섹션코드
	,@AGREE_DT		DATETIME	-- 동의날짜
    ,@MEDIA_CD      CHAR(1)     -- S:SMS M:MAIL
    ,@CUID			INT

AS		

	-- 중복 입력 체크
	DECLARE @INTCNT	TINYINT

	IF @SECTION_CD > ''
		BEGIN
			SELECT @INTCNT = COUNT(USERID) 
				FROM CST_MSG_SECTION WITH(NOLOCK)
				WHERE CUID = @CUID
				AND SECTION_CD = @SECTION_CD
				AND MEDIA_CD = @MEDIA_CD

			IF @INTCNT = 0 
			BEGIN
				-- 동의 날짜 없으면 현재시각으로..
				IF @AGREE_DT = '1900-01-01 00:00:00.000'
					SET @AGREE_DT = GETDATE()
	
				INSERT INTO CST_MSG_SECTION(
					 SECTION_CD
					,MEDIA_CD
					,USERID
					,AGREE_DT
					,CUID
				) 
				SELECT	 
					@SECTION_CD
					,@MEDIA_CD
					,@USERID
					,@AGREE_DT
					,@CUID
			END
		END

GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_SSO_CERT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : SSO 로그인 인증 TOKEN 생성
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2017/01/30
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.PUT_MM_SSO_CERT_PROC
 *************************************************************************************/


CREATE PROC [dbo].[PUT_MM_SSO_CERT_PROC]

  @USERID	VARCHAR	(50) = ''
  ,@PWD	VARCHAR	(30)  = ''
  ,@SECTION_CD	CHAR	(4)
  ,@IP	VARCHAR	(15)
  ,@HOST	VARCHAR	(50)
  ,@KEEPLOGIN CHAR(1) = 'N'
  ,@SNS_TYPE CHAR(1) = NULL
  ,@SNS_ID VARCHAR(100) = NULL

  ,@TOKEN VARCHAR(32) = ''  OUTPUT

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  DECLARE @NEWID VARCHAR(36)
  DECLARE @NOW VARCHAR(18) = GETDATE()
  DECLARE @TOKEN_KEY VARCHAR(32)

  SET @NEWID = NEWID()

  SET @TOKEN_KEY = dbo.FN_MD5(@NEWID + CAST(@USERID AS VARCHAR) + @NOW)

  --BEGIN TRAN

    DELETE FROM MM_SSO_CERT_TB WHERE USERID = @USERID

    INSERT INTO MM_SSO_CERT_TB
      (TOKEN_KEY
      ,USERID
      ,PWD
      ,SECTION_CD
      ,IP
      ,HOST
      ,KEEPLOGIN
      ,SNS_TYPE
      ,SNS_ID)
    VALUES
      (@TOKEN_KEY
      ,@USERID
      ,dbo.FN_MD5(LOWER(@PWD))
      ,@SECTION_CD
      ,@IP
      ,@HOST
      ,@KEEPLOGIN
      ,@SNS_TYPE
      ,@SNS_ID)

  --COMMIT TRAN

  SET @TOKEN = @TOKEN_KEY
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_USER_LOG_VIEW_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************
 *  단위 업무 명 : 관리자 페이지 회원 정보 조회 로그 기록 프로시저
 *  작   성   자 : 최병찬
 *  작   성   일 : 2011-11-29
 *  사 용  소 스 : exec PUT_MM_USER_LOG_VIEW_PROC 'S101', 'sebilia', 'sebilia', 12566407, '58.76.233.71' ,  'V'
***************************************************************/
CREATE PROC [dbo].[PUT_MM_USER_LOG_VIEW_PROC]
       @SECTION_CD    CHAR(4)
     , @ADMINID       VARCHAR(30)
     , @USERID        VARCHAR(50)
     , @CUID          INT
     , @IP            VARCHAR(15)=''
     , @ACT           CHAR(1)='V'
     , @PAGE          INT = NULL
     , @SEARCHARG     VARCHAR(50) = NULL
     , @KEYWORD       VARCHAR(50) = NULL
AS

SET NOCOUNT ON

EXEC FINDDB1.MAGUSER.DBO.PUT_MM_USER_LOG_VIEW_PROC  @SECTION_CD, @ADMINID, @USERID, @CUID, @IP, @ACT, @PAGE, @SEARCHARG, @KEYWORD
GO
/****** Object:  StoredProcedure [dbo].[PUT_PP_USER_REASON_INSERT_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PUT_PP_USER_REASON_INSERT_PROC]
/*************************************************************************************
 *  단위 업무 명 : 개인 회원 가입 계기
 *  작   성   자 : 조민기
 *  작   성   일 : 2019-09-19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
 --mwmember.dbo.PUT_PP_USER_REASON_INSERT_PROC '1,2', 13621996
 -- 개인 정보
@ETC_CHECK  varchar(50),
@CUID		INT

AS
	SET	XACT_ABORT	ON
	SET NOCOUNT ON;
BEGIN
	
	IF NOT EXISTS (SELECT * FROM CST_JOIN_REASON WHERE CUID = @CUID)
	BEGIN
		INSERT INTO CST_JOIN_REASON (CUID, REASON_CD, ORD, REGDT)
		SELECT @CUID, VALUE, 0, GETDATE() FROM DBO.FN_SPLIT_TB(@ETC_CHECK,',')
	END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_AD_MM_MEMBER_HISTORY_PROC]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************  
 *  단위 업무 명 : 관리자 > 회원 상세 > 회원 정보 수정 로그  
 *  작   성   자 : 배진용  
 *  작   성   일 : 2021/09/01  
 *  수   정   자 :   
 *  수   정   일 :   
 *  설        명 :    
 *  주 의  사 항 :   
 *  사 용  소 스 : EXEC SP_AD_MM_MEMBER_HISTORY_PROC 14208605,'S101','010-1111-1111', '1234@mediawill.com', 'PC'  
									 EXEC SP_AD_MM_MEMBER_HISTORY_PROC 14208605,'S101','010-1231-3213', 'bjy@mediawill.com', '모바일'  	
 *************************************************************************************/  
CREATE PROCEDURE [dbo].[SP_AD_MM_MEMBER_HISTORY_PROC]  
		@CUID         INT, 
		@SECTION_CD   CHAR(10),
		@HPHONE				VARCHAR(30),
		@EMAIL				VARCHAR(50),
		@DIVICE_TYPE	VARCHAR(10)
AS    

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON 
---------------------------------  
-- 데이타 처리  
---------------------------------  
		DECLARE @PRE_HPHONE	VARCHAR(30)
		DECLARE @PRE_EMAIL	VARCHAR(30)
		DECLARE @COMMENT		VARCHAR(100)  
		DECLARE @CHANGE_CMT	VARCHAR(100)
		DECLARE @MAG_ID			VARCHAR(50)
		DECLARE @MAG_NM			VARCHAR(50)
		DECLARE @DEVICE_NM	VARCHAR(50)
		SET @COMMENT = ''
		SET @CHANGE_CMT = ''
	
		-- 기존 이메일 핸드폰 데이터 가져오기
		SELECT @PRE_HPHONE = HPHONE, 
					 @PRE_EMAIL  = EMAIL,
					 @MAG_ID = USERID,
					 @MAG_NM = USER_NM
		 FROM MWMEMBER.DBO.CST_MASTER WITH (NOLOCK)
		 WHERE CUID = @CUID

		 -- 휴대폰, 이메일 기존 데이터와 비교 하여 수정 여부 확인
		 IF @PRE_HPHONE != @HPHONE AND @PRE_EMAIL != @EMAIL
			 BEGIN
				SET @CHANGE_CMT = '휴대폰 번호, 이메일'
			 END
		 ELSE
			 BEGIN
				IF @PRE_HPHONE = @HPHONE AND @PRE_EMAIL != @EMAIL
					BEGIN
						SET @CHANGE_CMT = '이메일'
					END
				IF @PRE_HPHONE != @HPHONE AND @PRE_EMAIL = @EMAIL
					BEGIN
						SET @CHANGE_CMT = '휴대폰 번호'
					END
			 END

			-- PC/모바일(앱) 여부
		  SET @DEVICE_NM = 'PC'
			IF  @DIVICE_TYPE = 'M'
			BEGIN
			 SET @DEVICE_NM = '모바일'
			END

		 -- 휴대폰 또는 이메일 변경이 있을경우만 이력 저장
		 IF @CHANGE_CMT	<> ''
		 BEGIN
			SET @COMMENT = '회원('+ @MAG_ID +')이 ' + @DEVICE_NM  + '에서 ' + @CHANGE_CMT + ' 변경 / ' + (SELECT [MWMEMBER].[dbo].[FN_SERVICE_USE_AGGRE_SECTION](@SECTION_CD))
			INSERT MWMEMBER.DBO.MM_MEMBER_HISTORY_TB  
				(USERID, SECTION_CD, MAG_ID, MAG_NAME, MAG_BRANCH, COMMENT, CUID)  
			VALUES(@MAG_ID, 'S101', @MAG_ID, @MAG_NM, '180', @COMMENT, @CUID) -- SECTION_CD의 값을 S101로 변경해야 회원정보에서 노출됨 
		 END
GO
/****** Object:  StoredProcedure [dbo].[SP_AGENCY_PWD_CHANGE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_AGENCY_PWD_CHANGE]
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 변경 - 관리자>공고등록 임시회원 SMS 문자전송 에서 비밀번호 변경 하기
 *  작   성   자 : 배진용
 *  작   성   일 : 2021-06-09
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0) 성공
 * RETURN(500)  실패
 * DECLARE @RET INT
 * EXEC [SP_AGENCY_PWD_CHANGE]  'yong89','14213766','1234','bjy89','관리자담당자'
 *
 *************************************************************************************/
@CUID			INT,
@USERID		VARCHAR(50),
@PWD			VARCHAR(50),
@MOD_ID		VARCHAR(50),
@MOD_NAME VARCHAR(50)

AS
	SET NOCOUNT ON;
	DECLARE  @ID_COUNT bit
	
	SET @ID_COUNT = 0
	-- 회원가입대행이고 임시회원인 경우에만 비밀번호 초기화
	SELECT @ID_COUNT = COUNT(USERID) FROM CST_MASTER WITH(NOLOCK) WHERE CUID = @CUID AND AGENCY_YN = 'Y' AND LAST_SIGNUP_YN='N'

	IF @ID_COUNT = 1
	BEGIN
		UPDATE CST_MASTER SET 
		PWD_MOD_DT = getdate() 
		,PWD_NEXT_ALARM_DT = getdate() + 90
		,pwd_sha2= master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD))) 
		WHERE CUID = @CUID
	
	-- SMS전송으로 인한 비밀번호 변경 이력
	INSERT INTO CST_MASTER_PWD_CHANGE_ADMIN_HISTORY 
							(CUID, 
							USERID, 
							MOD_DT, 
							MOD_ID, 
							MOD_NAME) 
					VALUES 
							(@CUID, 
							@USERID, 
							getdate(), 
							@MOD_ID, 
							@MOD_NAME)
		RETURN(0)
		
	END 
	ELSE
	BEGIN
		RETURN(500)
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_BAD_USER]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 나쁜 사용자 입력 및 수정
 *  작   성   자 : J&J
 *  작   성   일 : 2016-08-04
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 나쁜 사용자 지정 및 지정헤체, 내용 저장 및 이력 
 -- RETURN(0) -- 성공
 -- RETURN(500) -- 실패
 DECLARE @RET INT
 EXEC @RET=SP_BAD_USER 12096777 , 관리자id , 'Y' , '나쁜 사람입니다.'
 SELECT @RET
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_BAD_USER]
@CUID INT,             -- 사용자 고유 넘버
@APP_USER varchar(50), -- 관리자 로그인 정보
@BAD_YN CHAR(1),       -- 나쁜사용자 등록   Y/N
@CONTENTS varchar(4000) -- 사유
AS	
	SET NOCOUNT ON;
	IF @BAD_YN = 'Y' OR @BAD_YN = 'N'
	BEGIN
		INSERT INTO CST_BAD_USER_HISTORY (CUID, APP_USER, CONTENTS, BAD_YN, APP_DT)  -- 이력 테이블
								 VALUES (@CUID, @APP_USER, @CONTENTS, @BAD_YN, GETDATE() )
		
		UPDATE CST_MASTER 
		   SET BAD_YN = @BAD_YN 
		     , MOD_DT = GETDATE()
		 WHERE CUID = @CUID   -- 마스터 테이블에도 업데이트
		RETURN(0)  -- 성공
	END
	ELSE 
	BEGIN
		RETURN(500)  -- 실패
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_BIZ_REG]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_BIZ_REG]
/*************************************************************************************
 *  단위 업무 명 : 사업자번호 조회
 *  작   성   자 : JMG
 *  작   성   일 : 2016-08-10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * EXEC SP_BIZ_REG '101-01-16777'
 *************************************************************************************/
@BIZ_NO varchar(50)
AS
	SET NOCOUNT ON;
	
	SELECT BizNo, BizName, BizPresident, case CloseYN when 'Y' then case isnull(CloseDate,'') when '' then 'H' else 'Y' end else 'N' end CloseYN
	FROM dbo.BIZ_REG_MASTER WITH(NOLOCK) 
	WHERE BizNo = @BIZ_NO
		
	
GO
/****** Object:  StoredProcedure [dbo].[SP_BIZ_SERVE_UPDATE]    Script Date: 2021-11-04 오전 11:00:45 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_BIZ_UPDATE]    Script Date: 2021-11-04 오전 11:00:45 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_AUTO_SELECT]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 기업 부가 정보 입력 및 수정,이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
-- RETURN(0)  -- 정상
-- RETURN(500) -- 에러
DECLARE @RET INT
EXEC @RET=SP_COMPANY_AUTO_SELECT 123123
SELECT @RET
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_COMPANY_AUTO_SELECT]
@COM_ID	INT
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT
		SET @ID_COUNT = 0
		SELECT @ID_COUNT = COUNT(COM_ID) FROM CST_COMPANY_AUTO WHERE COM_ID = @COM_ID
	
		IF @ID_COUNT = 1
		BEGIN
			SELECT COM_ID, 
				   USERID, 
				   MANAGER_NM, 
				   MANAGER_PHONE, 
				   MANAGER_EMAIL, 
				   MANAGER_NUMBER, 
				   MANAGER_IMG_F,					 
				   MANAGER_IMG_B, 
				   MANAGER_KAKAO_ID FROM CST_COMPANY_AUTO WITH(NOLOCK) WHERE COM_ID = @COM_ID
			RETURN(0)  -- 정상
		END
		ELSE 
		BEGIN
			RETURN(500) -- 에러
		END
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_AUTO_UPDATE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_COMPANY_AUTO_UPDATE]
/*************************************************************************************
 *  단위 업무 명 : 기업 부가 정보 입력 및 수정,이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 * RETURN(0) -- INSERT
 * RETURN(0)  -- UPDATE
 * RETURN(500)   -- 에러, COM_ID 가 복수이거나..
 * DECLARE @RET INT
 * EXEC @RET=SP_COMPANY_AUTO_UPDATE 1231412,'USERID','MANAGER_NM','MANAGER_PHONE','MANAGER_EMAIL',
 *									'MANAGER_NUMBER','MANAGER_IMG_F','MANAGER_IMG_B','MANAGER_KAKAO_ID'
 * SELECT @RET
 *************************************************************************************/
@COM_ID	INT,
@USERID	varchar(50),
@MANAGER_NM	varchar(30),
@MANAGER_PHONE	varchar(15),
@MANAGER_EMAIL	varchar(50),
@MANAGER_NUMBER	varchar(20),
@MANAGER_IMG_F	varchar(200),
@MANAGER_IMG_B	varchar(200),
@MANAGER_KAKAO_ID	varchar(50)
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT
		
		SET @ID_COUNT = 0
		SELECT @ID_COUNT = COUNT(COM_ID) FROM CST_COMPANY_AUTO WHERE COM_ID = @COM_ID
		
		IF @ID_COUNT = 0
		BEGIN
			INSERT INTO CST_COMPANY_AUTO (COM_ID, USERID, MANAGER_NM, MANAGER_PHONE, MANAGER_EMAIL, MANAGER_NUMBER, MANAGER_IMG_F,
										 MANAGER_IMG_B, MANAGER_KAKAO_ID, MOD_DT)
								  VALUES (@COM_ID, @USERID, @MANAGER_NM, @MANAGER_PHONE, @MANAGER_EMAIL, @MANAGER_NUMBER, @MANAGER_IMG_F,
										 @MANAGER_IMG_B, @MANAGER_KAKAO_ID, GETDATE())
			INSERT INTO CST_COMPANY_AUTO_HISTORY (COM_ID, USERID, MOD_ID, MOD_DT, MANAGER_NM, MANAGER_PHONE, MANAGER_EMAIL, MANAGER_NUMBER, MANAGER_IMG_F,
										 MANAGER_IMG_B, MANAGER_KAKAO_ID) 
								  VALUES (@COM_ID, @USERID, @USERID, GETDATE(), @MANAGER_NM, @MANAGER_PHONE, @MANAGER_EMAIL, @MANAGER_NUMBER, @MANAGER_IMG_F,
										 @MANAGER_IMG_B, @MANAGER_KAKAO_ID)
			RETURN(100) -- INSERT
		END
		ELSE IF @ID_COUNT = 1
		BEGIN
			UPDATE CST_COMPANY_AUTO SET USERID = @USERID, MANAGER_NM = @MANAGER_NM, MANAGER_PHONE = @MANAGER_PHONE,
										MANAGER_EMAIL = @MANAGER_EMAIL, MANAGER_NUMBER = @MANAGER_NUMBER,
										MANAGER_IMG_F = @MANAGER_IMG_F, MANAGER_IMG_B = @MANAGER_IMG_B, MANAGER_KAKAO_ID = @MANAGER_KAKAO_ID, MOD_DT = GETDATE()
										WHERE COM_ID = @COM_ID
			INSERT INTO CST_COMPANY_AUTO_HISTORY (COM_ID, USERID, MOD_ID, MOD_DT, MANAGER_NM, MANAGER_PHONE, MANAGER_EMAIL, MANAGER_NUMBER, MANAGER_IMG_F,
										 MANAGER_IMG_B, MANAGER_KAKAO_ID) 
								  VALUES (@COM_ID, @USERID, @USERID, GETDATE(), @MANAGER_NM, @MANAGER_PHONE, @MANAGER_EMAIL, @MANAGER_NUMBER, @MANAGER_IMG_F,
										 @MANAGER_IMG_B, @MANAGER_KAKAO_ID)
			RETURN(0)  -- UPDATE
		END
		ELSE
		BEGIN
			RETURN(500)   -- 에러 COM_ID 가 복수이거나..
		END
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_CHECK]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_COMPANY_CHECK]
/*************************************************************************************
 *  단위 업무 명 : 중복 사업자 체크
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 사업자 체크
 * RETURN(500)  3개 이상
 * RETURN(0)  성공
 * DECLARE @RET INT
 * EXEC @RET=SP_COMPANY_CHECK '조민기', '010-6393-0923', 'M', '19770713'
 * SELECT @RET
 exec mwmember.dbo.SP_COMPANY_CHECK '조민기', '010-6393-0923', 'M', '19770713'
 **************************************************************************************/
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@GENDER  char(1),
@BIRTH  varchar(8)
AS 
	DECLARE @NO_CHK INT
	IF @USER_NM ='' AND @HPHONE = '' AND @GENDER = '' AND @BIRTH='' 
	BEGIN
		RETURN 500
	END
	SELECT @NO_CHK = COUNT(*) FROM CST_MASTER WITH(NOLOCK) 
					 WHERE USER_NM = @USER_NM  
					 AND GENDER = @GENDER  
					 AND HPHONE = [DBO].[FN_PHONE_STRING](@HPHONE)
					 AND BIRTH = @BIRTH
					 AND MEMBER_CD = '2'
					 AND OUT_YN='N'
					 
	IF @NO_CHK > 2
	BEGIN
--		print(500)
		RETURN(500)
	END ELSE
	BEGIN
--		print(0)
		RETURN(0)
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_JOB_SELECT]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_COMPANY_JOB_SELECT]
/*************************************************************************************
 *  단위 업무 명 : 기업 부가 정보 입력 및 수정, 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 * RETURN(0)  -- 정상
 * RETURN(500) -- 에러
 * DECLARE @RET INT
 * EXEC @RET=SP_COMPANY_JOB_SELECT 123123
 * SELECT @RET
 *************************************************************************************/
@COM_ID	INT
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT
		SET @ID_COUNT = 0
		SELECT @ID_COUNT = COUNT(COM_ID) FROM CST_COMPANY_AUTO WITH(NOLOCK) WHERE COM_ID = @COM_ID

	IF @ID_COUNT = 1
	BEGIN
		SELECT COM_ID, 
		       USERID,
			   MANAGER_NM, 
			   MANAGER_PHONE, 
			   MANAGER_EMAIL, 
			   BIZ_CD, 
			   BIZ_CLASS, 
			   EMP_CNT, 
			   MAIN_BIZ,
			   LOGO_IMG, 
			   EX_IMAGE_1, 
			   EX_IMAGE_2, 
			   EX_IMAGE_3, 
			   EX_IMAGE_4 FROM CST_COMPANY_JOB WITH(NOLOCK) WHERE COM_ID = @COM_ID
		RETURN(0)  -- 정상
	END
	ELSE
	BEGIN
		RETURN(500) -- 에러
	END


GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_JOB_UPDATE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_COMPANY_JOB_UPDATE]
/*************************************************************************************
 *  단위 업무 명 : 기업 부가 정보 입력 및 수정, 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0) -- INSERT
 * RETURN(0)  -- UPDATE
 * RETURN(500)   -- 에러, COM_ID 가 복수이거나..
 * DECLARE @RET INT
 * EXEC @RET=SP_COMPANY_JOB_UPDATE 123123,'USERID','MANAGER_NM','MANAGER_PHONE','MANAGER_EMAIL'
									,'BIZ_CD','BIZ_CLASS','EMP_CNT','MAIN_BIZ','LOGO_IMG',
									'EX_IMAGE_1','EX_IMAGE_2','EX_IMAGE_3','EX_IMAGE_4'
 * SELECT @RET
 *************************************************************************************/
@COM_ID	INT,
@USERID	varchar(50),
@MANAGER_NM	varchar(30),
@MANAGER_PHONE	varchar(15),
@MANAGER_EMAIL	varchar(50),
@BIZ_CD		varchar(100),
@BIZ_CLASS	varchar(6),
@EMP_CNT	varchar(7),
@MAIN_BIZ	varchar(100),
@LOGO_IMG	varchar(200),
@EX_IMAGE_1	varchar(200),
@EX_IMAGE_2	varchar(200),
@EX_IMAGE_3	varchar(200),
@EX_IMAGE_4	varchar(200)
AS 
	SET NOCOUNT ON;
	DECLARE @CUID INT, @ID_COUNT BIT
		SET @ID_COUNT = 0
		SELECT @ID_COUNT = COUNT(COM_ID) FROM CST_COMPANY_JOB WHERE COM_ID = @COM_ID
		
		IF @ID_COUNT = 0
		BEGIN
			INSERT INTO CST_COMPANY_JOB (COM_ID, USERID, MANAGER_NM, MANAGER_PHONE, MANAGER_EMAIL, BIZ_CD, BIZ_CLASS, EMP_CNT, MAIN_BIZ,
										 LOGO_IMG, EX_IMAGE_1, EX_IMAGE_2, EX_IMAGE_3, EX_IMAGE_4, MOD_DT)
								  VALUES (@COM_ID, @USERID, @MANAGER_NM, @MANAGER_PHONE, @MANAGER_EMAIL, @BIZ_CD, @BIZ_CLASS, @EMP_CNT, @MAIN_BIZ,
										 @LOGO_IMG, @EX_IMAGE_1, @EX_IMAGE_2, @EX_IMAGE_3, @EX_IMAGE_4, GETDATE())
			INSERT INTO CST_COMPANY_JOB_HISTORY (COM_ID, USERID, MOD_ID, MOD_DT, MANAGER_NM, MANAGER_PHONE, MANAGER_EMAIL, BIZ_CD, BIZ_CLASS, EMP_CNT, MAIN_BIZ,
										 LOGO_IMG, EX_IMAGE_1, EX_IMAGE_2, EX_IMAGE_3, EX_IMAGE_4)
								  VALUES (@COM_ID, @USERID,@USERID, GETDATE(), @MANAGER_NM, @MANAGER_PHONE, @MANAGER_EMAIL, @BIZ_CD, @BIZ_CLASS, @EMP_CNT, @MAIN_BIZ,
										 @LOGO_IMG, @EX_IMAGE_1, @EX_IMAGE_2, @EX_IMAGE_3, @EX_IMAGE_4)
			RETURN(0) -- INSERT
		END
		ELSE IF @ID_COUNT = 1
		BEGIN
			UPDATE CST_COMPANY_JOB SET USERID = @USERID, MANAGER_NM = @MANAGER_NM, MANAGER_PHONE = @MANAGER_PHONE,
										MANAGER_EMAIL = @MANAGER_EMAIL, BIZ_CD = @BIZ_CD, BIZ_CLASS = @BIZ_CLASS, EMP_CNT = @EMP_CNT,
										MAIN_BIZ = @MAIN_BIZ, LOGO_IMG = @LOGO_IMG, EX_IMAGE_1 =  @EX_IMAGE_1, 
										EX_IMAGE_2 = @EX_IMAGE_2, EX_IMAGE_3 = @EX_IMAGE_3, EX_IMAGE_4 = @EX_IMAGE_4 , MOD_DT = GETDATE() WHERE COM_ID = @COM_ID
			INSERT INTO CST_COMPANY_JOB_HISTORY (COM_ID, USERID,  MOD_ID, MOD_DT, MANAGER_NM, MANAGER_PHONE, MANAGER_EMAIL, BIZ_CD, BIZ_CLASS, EMP_CNT, MAIN_BIZ,
										 LOGO_IMG, EX_IMAGE_1, EX_IMAGE_2, EX_IMAGE_3, EX_IMAGE_4)
								  VALUES (@COM_ID, @USERID,  @USERID, GETDATE(), @MANAGER_NM, @MANAGER_PHONE, @MANAGER_EMAIL, @BIZ_CD, @BIZ_CLASS, @EMP_CNT, @MAIN_BIZ,
										 @LOGO_IMG, @EX_IMAGE_1, @EX_IMAGE_2, @EX_IMAGE_3, @EX_IMAGE_4)
			RETURN(0)  -- UPDATE
		END
		ELSE
		BEGIN
			RETURN(500)   -- 에러, COM_ID 가 복수이거나..
		END
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_LAND_SELECT]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_COMPANY_LAND_SELECT]
/*************************************************************************************
 *  단위 업무 명 : 기업 부가 정보 입력 및 수정, 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0)  -- 정상
 * RETURN(500) -- 에러
 * DECLARE @RET INT
 * EXEC @RET=SP_COMPANY_LAND_SELECT 123123
 * SELECT @RET
 *************************************************************************************/
@COM_ID	INT
AS 
	SET NOCOUNT ON;
	DECLARE @CUID INT, @ID_COUNT BIT, @SEQ INT
		SET @ID_COUNT = 0
		SELECT @ID_COUNT = COUNT(COM_ID) FROM CST_COMPANY_LAND WITH(NOLOCK) WHERE COM_ID = @COM_ID

		IF @ID_COUNT = 1
		BEGIN
			SELECT COM_ID, 
			       USERID, 
				   LAND_CLASS_CD, 
				   REG_NUMBER, 
				   INTRO, 
				   LOGO_IMG,
				   PF_IMG, 
				   DESCRIPT, 
				   PROFILE, 
				   ETCINFO_SYNC	FROM CST_COMPANY_LAND WITH(NOLOCK) WHERE COM_ID = @COM_ID
			RETURN(0)  -- 정상
		END
		ELSE
		BEGIN
			RETURN(500) -- 에러
		END
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_LAND_UPDATE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_COMPANY_LAND_UPDATE]
/*************************************************************************************
 *  단위 업무 명 : 기업 부가 정보 입력 및 수정, 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0) -- INSERT
 * RETURN(0)  -- UPDATE
 * RETURN(500)   -- 에러, COM_ID 가 복수이거나..
 * DECLARE @RET INT
 * EXEC @RET=SP_COMPANY_LAND_UPDATE 132132,'USERID','LAND_CLASS_CD','REG_NUMBER','INTRO',
								    'LOGO_IMG','PF_IMG','DESCRIPT','PROFILE',1
 * SELECT @RET
 *************************************************************************************/
@COM_ID	INT,
@USERID varchar(50),
@LAND_CLASS_CD	varchar(30),
@REG_NUMBER	varchar(50),
@INTRO	varchar(50),
@LOGO_IMG	varchar(20),
@PF_IMG	varchar(200),
@DESCRIPT	varchar(200),
@PROFILE	varchar(50),
@ETCINFO_SYNC	TINYINT
AS 
	SET NOCOUNT ON;
	DECLARE @CUID INT, @ID_COUNT BIT
		SET @ID_COUNT = 0
		SELECT @ID_COUNT = COUNT(COM_ID) FROM CST_COMPANY_LAND WHERE COM_ID = @COM_ID

		IF @ID_COUNT = 0
		BEGIN
			INSERT INTO CST_COMPANY_LAND (COM_ID, USERID, LAND_CLASS_CD, REG_NUMBER, INTRO, LOGO_IMG, PF_IMG, DESCRIPT, PROFILE, ETCINFO_SYNC, MOD_DT)
								  VALUES (@COM_ID, @USERID, @LAND_CLASS_CD, @REG_NUMBER, @INTRO, @LOGO_IMG, @PF_IMG, @DESCRIPT, @PROFILE, @ETCINFO_SYNC, GETDATE())
			
			INSERT INTO CST_COMPANY_LAND_HISTORY (COM_ID, USERID,MOD_ID, MOD_DT, LAND_CLASS_CD, REG_NUMBER, INTRO, LOGO_IMG, PF_IMG, DESCRIPT, PROFILE, ETCINFO_SYNC)
								  VALUES (@COM_ID, @USERID, @USERID, GETDATE(), @LAND_CLASS_CD, @REG_NUMBER, @INTRO, @LOGO_IMG, @PF_IMG, @DESCRIPT, @PROFILE, @ETCINFO_SYNC)		
			RETURN(0) -- INSERT
		END
		ELSE IF @ID_COUNT = 1
		BEGIN
			UPDATE CST_COMPANY_LAND SET LAND_CLASS_CD = @LAND_CLASS_CD, REG_NUMBER = @REG_NUMBER, INTRO = @INTRO,
										LOGO_IMG = @LOGO_IMG, PF_IMG = @PF_IMG, DESCRIPT = @DESCRIPT, PROFILE = @PROFILE,
										ETCINFO_SYNC = @ETCINFO_SYNC , MOD_DT = GETDATE() WHERE COM_ID = @COM_ID
			INSERT INTO CST_COMPANY_LAND_HISTORY (COM_ID, USERID, MOD_ID, MOD_DT, LAND_CLASS_CD, REG_NUMBER, INTRO, LOGO_IMG, PF_IMG, DESCRIPT, PROFILE, ETCINFO_SYNC)
								  VALUES (@COM_ID, @USERID,  @USERID, GETDATE(), @LAND_CLASS_CD, @REG_NUMBER, @INTRO, @LOGO_IMG, @PF_IMG, @DESCRIPT, @PROFILE, @ETCINFO_SYNC)		
			RETURN(200)  -- UPDATE
		END ELSE
		BEGIN
			RETURN(500)
		END
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPANY_UPDATE]    Script Date: 2021-11-04 오전 11:00:45 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CON]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CON]--[SP_LOGIN_SNS]
/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력 SNS
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * CUID ,USERID, USER_NM, 이메일, 회사명, 휴대폰, 회원타입(개인/기업), 성별, 연령, 휴면여부, 생년월일, 비번 변경일로부터 90일 지난여부(Y/N)
 *************************************************************************************/
@USERID varchar(50)
,@SNS_TYPE CHAR(1)  --K
,@SNS_ID VARCHAR(25) -- 207053388
,@SECTION_CD CHAR(4)
,@IP VARCHAR(14)
,@HOST VARCHAR(50)
,@PKEY INT
AS
	SET NOCOUNT ON;
	DECLARE  
		@CUID INT
		,@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@MASTER_ID INT
		,@STATUS_CD CHAR(1)
		--,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT


		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = AA.USER_NM,
			@EMAIL = AA.EMAIL,
			@HPHONE = AA.HPHONE,
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = AA.COM_NM,
			@CONFIRM_YN = AA.CONFIRM_YN,
			@MASTER_ID = AA.MASTER_ID,
			@STATUS_CD = AA.STATUS_CD,
			--@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			--M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD
		FROM CST_MASTER M LEFT OUTER JOIN CST_COMPANY C ON M.COM_ID = C.COM_ID
		WHERE M.OUT_YN='N' AND M.USERID = @USERID AND M.SNS_TYPE = @SNS_TYPE AND SNS_ID = @SNS_ID) AA
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음

		IF @REST_YN = 'Y' 
		BEGIN
			RETURN(500) -- 휴면 고객
		END ELSE IF @CUID IS NULL
		BEGIN
			RETURN(400) -- 사용자가 없음
			/*
		END ELSE IF @COUNT > 1 
		BEGIN 
			RETURN(300) -- 복수의 아이디
			
		END ELSE IF @TRUE_YN = 'N'
		BEGIN
			INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST, PKEY) VALUES
									  (@CUID ,@USERID, getdate(), @SECTION_CD,'N', @IP, @HOST, @PKEY)
			RETURN(200) -- 비밀 번호 틀림
			*/
		END ELSE IF @COUNT = 1
		BEGIN 
			--SET @PWD_CHANGE_YN = 'N'
			--IF @PWD_NEXT_ALARM_DT < GETDATE() - 90 SET @PWD_CHANGE_YN = 'Y'
			SELECT
				-- @COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				@GENDER AS GENDER,
				@REST_YN AS REST_YN,
				@BIRTH AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				@MASTER_ID AS MASTER_ID,
				@STATUS_CD AS STATUS_CD,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD
				--@TRUE_YN AS TRUE_YN
				--@PWD_CHANGE_YN AS PWD_CHANGE_YN

				--UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()  WHERE CUID = @CUID			  -- 마지막 로그인 시간 
				INSERT INTO CST_LOGIN_LOG (CUID, USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST, PKEY) VALUES
									      (@CUID, @USERID, getdate(),@SECTION_CD,'Y', @IP, @HOST, @PKEY)    -- 로그인 이력 남기기
			RETURN(0) -- 정상 정상
		END	
GO
/****** Object:  StoredProcedure [dbo].[SP_CST_MASTER_BACKUP]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원정보 수정전 정보 백업
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-11-10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 

 *************************************************************************************/

CREATE PROCEDURE [dbo].[SP_CST_MASTER_BACKUP]
@CUID   int
AS
	INSERT CST_MASTER_MOD_BACKUP
	(
		 CUID
		,USERID
		,BAD_YN
		,PWD
		,PWD_MOD_DT
		,PWD_NEXT_ALARM_DT
		,LOGIN_FAIL_CNT
		,LOGIN_FAIL_DT
		,JOIN_DT
		,FLOW
		,MOD_DT
		,MOD_ID
		,ADULT_YN
		,MEMBER_CD
		,USER_NM
		,HPHONE
		,EMAIL
		,GENDER
		,BIRTH
		,SNS_TYPE
		,SNS_ID
		,COM_ID
		,DI
		,CI
		,REST_YN
		,REST_DT
		,OUT_YN
		,SITE_CD
		,INPUTBRANCH
		,CUSTCODE
		,CUSTTYPE
		,MEM_SEQ
		,CONFIRM_YN
		,STATUS_CD
		,MASTER_ID
		,OUT_DT
		,LAST_LOGIN_DT
		,LOGIN_PWD_ENC
		,REALHP_YN
		,SYS_DT
		,pwd_sha2
	)
	select 
		 CUID
		,USERID
		,BAD_YN
		,PWD
		,PWD_MOD_DT
		,PWD_NEXT_ALARM_DT
		,LOGIN_FAIL_CNT
		,LOGIN_FAIL_DT
		,JOIN_DT
		,FLOW
		,MOD_DT
		,MOD_ID
		,ADULT_YN
		,MEMBER_CD
		,USER_NM
		,HPHONE
		,EMAIL
		,GENDER
		,BIRTH
		,SNS_TYPE
		,SNS_ID
		,COM_ID
		,DI
		,CI
		,REST_YN
		,REST_DT
		,OUT_YN
		,SITE_CD
		,INPUTBRANCH
		,CUSTCODE
		,CUSTTYPE
		,MEM_SEQ
		,CONFIRM_YN
		,STATUS_CD
		,MASTER_ID
		,OUT_DT
		,LAST_LOGIN_DT
		,LOGIN_PWD_ENC
		,REALHP_YN
		,GETDATE() SYS_DT
		,pwd_sha2
	 FROM CST_MASTER WITH(NOLOCK)
	 WHERE CUID  = @CUID 
GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOMER_INTEGRATION_APP]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CUSTOMER_INTEGRATION_APP]
/*************************************************************************************
 *  단위 업무 명 : 통합 요청
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
@M_CUID  INT,  -- MASTER CUID
@M_USRID VARCHAR(50),   -- MASTER LOGIN ID
@S_CUID  INT,    -- S
@IP  VARCHAR(20),   -- IP
@USERID VARCHAR(50)   -- 신청한 ID 관리자 페이지에서는 관리자 로그인 한 사람의 ID

AS
	SET NOCOUNT ON;
--	DECLARE @RE_YES_CUID VARCHAR(4000), @RE_NO_CUID VARCHAR(4000), @SQL nvarchar(4000)
--PWD null 처리 추가(통합 회원 비번 동일할시 문제 발생. 비번을 null 로 변경
	UPDATE CST_MASTER SET MASTER_ID = @M_CUID, STATUS_CD = 'D', PWD_SHA2=null WHERE CUID = @S_CUID  -- 마스터 아이디로 귀속
	UPDATE CST_MASTER SET MASTER_ID = @M_CUID ,STATUS_CD = 'A' WHERE CUID = @M_CUID  -- 마스터는 마스터로!
	
	INSERT INTO CST_ADMISSION (M_CUID, S_CUID, CONFIRM_ID, APP_DT, IP)
					   VALUES (@M_CUID, @S_CUID, @USERID, GETDATE(),@IP)
	
	 --EXEC PAPER_NEW.DBO.CUID_CHANGE_ALL_PROC @M_CUID, @M_USRID, @S_CUID, @IP
	 /* 
			 @MASTER_CUID   INT         =  0      -- 기존아이디
			,@MASTER_USERID  VARCHAR(50) =  ''     -- 기존아이디
			,@SLAVE_CUID   INT   =  0      --  변경 아이디
			,@CLIENT_IP   VARCHAR(20) = '사용자 아이디'
	*/
	 
	 --벼룩시장
	 EXEC FINDDB1.PAPER_NEW.DBO.CUID_CHANGE_ALL_PROC  @M_CUID, @M_USRID, @S_CUID, @IP
	 
	 --부동산써브
	 EXEC dbo.SP_MEMBER_CHANGE  @S_CUID, @M_CUID, @IP
GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOMER_INTEGRATION_CON]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CUSTOMER_INTEGRATION_CON]
/*************************************************************************************
 *  단위 업무 명 : 승인 관리자 페이지 검색
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
@USER_NM VARCHAR(30),
@HPHONE varchar(14),
@USERID	varchar(50),
@M_USERID varchar(50)
AS 
	SET NOCOUNT ON;
	DECLARE @SQL nvarchar(4000)

		
		SET @SQL ='SELECT * FROM (
					SELECT [SEQ]
					,'+'''M'''+' AS M_ST
					,(SELECT SITE_CD FROM CST_MASTER M WITH(NOLOCK) WHERE A.M_CUID = M.CUID) AS  M_SITE_CD
					,(SELECT USERID FROM CST_MASTER M WITH(NOLOCK) WHERE A.M_CUID = M.CUID) AS M_USERID
					,(SELECT USER_NM FROM CST_MASTER M WITH(NOLOCK) WHERE A.M_CUID = M.CUID) AS M_USER_NM
					,(SELECT HPHONE FROM CST_MASTER M WITH(NOLOCK) WHERE A.M_CUID = M.CUID) AS M_HPHONE
					,(SELECT EMAIL FROM CST_MASTER M WITH(NOLOCK) WHERE A.M_CUID = M.CUID) AS M_EMAIL
					,(SELECT COM_NM FROM CST_COMPANY C WITH(NOLOCK) WHERE A.M_CUID = C.CUID) AS M_COM_NM
					,(SELECT REGISTER_NO FROM CST_COMPANY C WITH(NOLOCK) WHERE A.M_CUID = C.CUID) AS M_REGISTER_NO
					,'+'''S'''+' AS S_ST
					,(SELECT SITE_CD FROM CST_MASTER M WITH(NOLOCK) WHERE A.S_CUID = M.CUID) AS S_SITE_CD
					,(SELECT USERID FROM CST_MASTER M WITH(NOLOCK) WHERE A.S_CUID = M.CUID) AS S_USERID
					,(SELECT USER_NM FROM CST_MASTER M WITH(NOLOCK) WHERE A.S_CUID = M.CUID) AS S_USER_NM
					,(SELECT HPHONE FROM CST_MASTER M WITH(NOLOCK) WHERE A.S_CUID = M.CUID) AS S_HPHONE
					,(SELECT EMAIL FROM CST_MASTER M WITH(NOLOCK) WHERE A.S_CUID = M.CUID) AS S_EMAIL
					,(SELECT COM_NM FROM CST_COMPANY C WITH(NOLOCK) WHERE A.S_CUID = C.CUID) AS S_COM_NM
					,(SELECT REGISTER_NO FROM CST_COMPANY C WITH(NOLOCK) WHERE A.S_CUID = C.CUID) AS S_REGISTER_NO
					,[CONFIRM_ID]
					,[APP_DT]
					,[S_CUID] AS CUID FROM [CST_ADMISSION] A WITH(NOLOCK) ) AA '

	IF @USER_NM != ''
	BEGIN
		SET @SQL = @SQL + ' WHERE M_USER_NM LIKE ' + '''%'+@USER_NM+ '%'''+ 'OR S_USER_NM LIKE' + '''%'+@USER_NM+'%'''+ 'ORDER BY SEQ'
	END
	ELSE IF @HPHONE != ''
	BEGIN
		SET @SQL = @SQL + ' WHERE M_HPHONE LIKE ' + '''%'+@HPHONE+ '%'''+ 'OR S_HPHONE LIKE ' + '''%'+@HPHONE+'%'''+ ' ORDER BY SEQ'
	END
	ELSE IF @USERID != ''
	BEGIN
		SET @SQL = @SQL + ' WHERE M_USERID LIKE ' + '''%'+@USERID+ '%'''+ 'OR S_USERID LIKE ' + '''%'+@USERID+'%'''+ ' ORDER BY SEQ'
	END
	ELSE IF @M_USERID != ''
	BEGIN
		SET @SQL = @SQL + ' WHERE M_USERID LIKE ' + '''%'+@USERID+ '%'''+ 'OR S_USERID LIKE ' + '''%'+@USERID+'%'''+ ' ORDER BY SEQ'
	END 

	EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOMER_INTEGRATION_LIST]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CUSTOMER_INTEGRATION_LIST]
/*************************************************************************************
 *  단위 업무 명 : 통합 회원 확인
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0) 정상
 * RETURN(500)  에러..
 * DECLARE RET INT
 * EXEC @RET=SP_CUSTOMER_INTEGRATION_LIST  'nadu81@naver.com' , 'AA' , 'F'
 * SELECT @RET
 *************************************************************************************/
@SELECT_USERID VARCHAR(50),  -- 찾을 유져아이디
@SELECT_PWD VARCHAR(20),     -- 
@SEELCT_SITE_CD CHAR(1),
@MEMBER_CD CHAR(1)     -- 현재 로그인 한 회원 상태 값
AS	
	SET NOCOUNT ON;
	DECLARE @USER_NM varchar(30),
			@EMAIL varchar(50),
			@HPHONE varchar(14),
			@MAIN_PHONE varchar(14),
			@CEO_NM varchar(30),
			@COM_NM varchar(50),
			@JOIN_DT DATETIME,
			@LAST_LOGIN_DT DATETIME,
			@REGISTER_NO varchar(12)
		
		SELECT @USER_NM = USER_NM
		   ,@EMAIL = EMAIL
		   ,@HPHONE = HPHONE
		   ,@MAIN_PHONE = CO.MAIN_PHONE
		   ,@JOIN_DT = M.JOIN_DT
		   ,@LAST_LOGIN_DT = M.LAST_LOGIN_DT
--		   ,CO.CITY 
--		   ,CO.GU
--		   ,CO.DONG
		   ,@REGISTER_NO = CO.REGISTER_NO
		   ,@MEMBER_CD = M.MEMBER_CD
		   ,@CEO_NM = CO.CEO_NM
		   ,@COM_NM = CO.COM_NM
			FROM CST_MASTER M WITH(NOLOCK) LEFT JOIN CST_COMPANY CO  WITH(NOLOCK) ON 
			M.COM_ID = CO.COM_ID
			WHERE USERID = @SELECT_USERID
			AND M.SITE_CD = @SEELCT_SITE_CD
			AND  pwd_sha2 = master.DBO.fnGetStringToSha256(dbo.FN_MD5(LOWER(@SELECT_PWD)))
			AND M.MEMBER_CD = @MEMBER_CD 
			AND REST_YN = 'N' AND OUT_YN = 'N'


	IF @MEMBER_CD = 1
	BEGIN
	SELECT  @USER_NM AS USER_NM
		   ,@EMAIL AS EMAIL
		   ,@HPHONE AS  HPHONE

		RETURN(0)
	END ELSE IF @MEMBER_CD = 2
	BEGIN
		SELECT
			@USER_NM AS USER_NM
		   ,@EMAIL AS EMAIL
		   ,@HPHONE AS HPHONE
		   ,@MAIN_PHONE AS MAIN_PHONE
		   ,@CEO_NM AS CEO_NM
		   ,@COM_NM AS COM_NM
		   ,@REGISTER_NO AS REGISTER_NO
		RETURN(0)
	END ELSE
		BEGIN
			RETURN(500)
		END
GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOMER_INTEGRATION_SEL]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CUSTOMER_INTEGRATION_SEL]
/*************************************************************************************
 *  단위 업무 명 : 관리자 승인 대상 검색
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
@HPHONE varchar(14),
@USERID	varchar(50),
@EMAIL varchar(50),
@USER_NM VARCHAR(30)
AS 
	SET NOCOUNT ON;
	DECLARE @SQL nvarchar(4000)
		
		SET @SQL ='  SELECT 
					 M.CUID
					,M.SITE_CD
					,M.USERID
					,M.USER_NM
					,M.HPHONE
					,M.MEMBER_CD
					,M.EMAIL
					,C.COM_NM
					,C.REGISTER_NO 
					FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON
					M.COM_ID = C.COM_ID WHERE M.OUT_YN = ' +'''N''' + ' AND M.REST_YN = ' +'''N''' + ' 
					AND STATUS_CD IS NULL '

	IF @HPHONE != ''
	BEGIN
		SET @SQL = @SQL + ' AND HPHONE LIKE ' + '''%'+@HPHONE+ '%'''
	END
	ELSE IF @USERID != ''
	BEGIN
		SET @SQL = @SQL + ' AND USERID LIKE ' + '''%'+@USERID+ '%'''
	END
	ELSE IF @EMAIL != ''
	BEGIN
		SET @SQL = @SQL + ' AND EMAIL LIKE ' + '''%'+@EMAIL+ '%'''
	END
	ELSE IF @USER_NM != ''
	BEGIN
		SET @SQL = @SQL + ' AND USER_NM LIKE ' + '''%'+@USER_NM+ '%'''
	END 

	EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[SP_DUPLICATE_USERID]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_DUPLICATE_USERID]
/*************************************************************************************
 *  단위 업무 명 : 중복 아이디 체크
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 아이디 체크
 * RETURN(500)  -- 중복아이디
 * RETURN(0)    --  중복 아이디 없음
  *************************************************************************************/
@USERID VARCHAR(50)
AS 

--	DECLARE @NO_CHK INT
		DECLARE @SQL nvarchar(4000)
		SET @SQL = 'SELECT TB.*,
				CASE TB.ORD  
				WHEN '+ '''0''' + ' THEN ''' + '선 접속 시 먼저 아이디를 사용 할수 있음' +'''
				WHEN '+'''2''' +'THEN '''+'관리자가 변경 해줘야 함'+'''
				ELSE '''' END ORD_MSG,
				--M.CUID, 
				--M.USERID, 
				M.REST_YN, 
				CASE M.SITE_CD 
				WHEN '''+'F'+''' THEN '''+'파인드올'+'''
				WHEN '''+'S'+''' THEN '''+'부동산써브'+'''
				ELSE '''' END SITE_CD,
				M.EMAIL ,
				CASE M.MEMBER_CD
				WHEN '''+'1'+''' THEN '''+'개인'+'''
				WHEN '''+'2'+''' THEN '''+'기업'+'''
				ELSE '''' END MEMBER_CD,
				M.USER_NM
		FROM [DUPLICATE_USERID_TB] TB WITH(NOLOCK) LEFT JOIN CST_MASTER M WITH(NOLOCK) ON
		TB.CUID = M.CUID -- 1955
		WHERE TB.USERID LIKE ' 
		SET @SQL = @SQL +  '''%' +@USERID +'%'''
		SET @SQL = @SQL +'ORDER BY TB.USERID'
		/*
			아이디 변경 시 호출 해야 줘야 하는 PROC  90번 서버
			CUID_CHANGE_ALL_PROC  

			 @MASTER_CUID   INT         =  0      -- 기존아이디
			 ,@MASTER_USERID  VARCHAR(50) =  ''     -- 기존아이디
			 ,@SLAVE_CUID   INT   =  0      --  변경 아이디
			 ,@CLIENT_IP   VARCHAR(20) = '사용자 아이디'

		 USERID 를 변경 하는 [dbo].[SP_USERID_ADMIN_CHANGE]
		 EXEC SP_DUPLICATE_USERID '97328422'
		*/
		EXEC(@SQL)
GO
/****** Object:  StoredProcedure [dbo].[SP_ID_CHECK]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ID_CHECK]
/*************************************************************************************
 *  단위 업무 명 : 중복 아이디 체크
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 아이디 체크
 * RETURN(500)  -- 중복아이디
 * RETURN(0)    --  중복 아이디 없음
  *************************************************************************************/
@USERID VARCHAR(25)
AS 

	SELECT COUNT(USERID) idchk FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @USERID
GO
/****** Object:  StoredProcedure [dbo].[SP_JOININFO_CHECK]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_JOININFO_CHECK]
/*************************************************************************************
 *  단위 업무 명 : 중복 인증정보 체크
 *  작   성   자 : JMG
 *  작   성   일 : 2019-01-14
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 인증정보 체크
 * RETURN(500)  3개 이상
 * RETURN(0)  성공
 * DECLARE @RET INT
 * EXEC @RET=SP_JOININFO_CHECK 'MC0GCCqGSIb3DQIJAyEActtpjaNTuHntREaitYRGxqwzecHEwbwNX4bWviXJtxI='
 * SELECT @RET

 **************************************************************************************/
@DI  varchar(70) 
AS 
	DECLARE @NO_CHK INT
	IF @DI ='' 
	BEGIN
		RETURN 500
	END
	SELECT @NO_CHK = COUNT(*) FROM CST_MASTER WITH(NOLOCK) 
					 WHERE DI = @DI 
					 AND MEMBER_CD = '2'
					 AND OUT_YN='N'

	IF @NO_CHK > 2
	BEGIN
		print(500)
		RETURN(500)
	END ELSE
	BEGIN
		print(0)
		RETURN(0)
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************      
 *  단위 업무 명 : 로그인 및 이력      
 *  작   성   자 : J&J      
 *  작   성   일 : 2016-07-25      
 *  수   정   자 : 배진용      
 *  수   정   일 : 2020-10-27      
 *  수   정   자 : 안대희*
 *  수   정   일 : 2021-05-24
 *  설        명 :       
 * RETURN(500) -- 휴면 고객      
 * RETURN(400) -- 사용자가 없음      
 * RETURN(300) -- 복수의 아이디      
 * RETURN(200) -- 비밀 번호 틀림      
 * RETURN(0) -- 정상 정상      
  DECLARE @RET INT      
  EXEC @RET=SP_LOGIN 'mwmobile01','11111111' , 'S101' ,'IP','HOST'      
  SELECT @RET  -- 성공      
  declare @DUPLICATE_YN INT       
    EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160      
 SELECT @DUPLICATE_YN      
      
  * 2020-10-27 -> 회원가입대행 여부 컬럼 추가 AGENCY_YN : 회원가입대행 여부,  LAST_SIGNUP_YN : 회원가입대행 최종 가입 여부      
  * 2021-05-24: 회원가입대행 컬럼 추가      
  C.MEMBER_TYPE, -- 회원타입(CST_COMPANY)    
  CL.REG_NUMBER  -- 등록번호(CST_COMPANY_LAND)    
 *************************************************************************************/      
CREATE PROCEDURE [dbo].[SP_LOGIN]      
@USERID VARCHAR(50)       
,@PWD VARCHAR(30)      
,@SECTION_CD CHAR(4)      
,@IP VARCHAR(15)      
,@HOST VARCHAR(50)      
AS      
 SET NOCOUNT ON;      
 DECLARE        
  @CUID INT      
  ,@USER_NM varchar(30)      
  ,@EMAIL varchar(50)      
  ,@HPHONE varchar(14)      
  ,@MEMBER_CD CHAR(1)      
  ,@GENDER CHAR(1)      
  ,@REST_YN CHAR(1)      
  ,@BIRTH varchar(8)      
  ,@COM_NM varchar(50)      
  ,@CONFIRM_YN CHAR(1)      
  ,@PWD_NEXT_ALARM_DT DATETIME      
  ,@SITE_CD CHAR(1)      
  ,@TRUE_YN CHAR(1)      
  ,@PWD_CHANGE_YN CHAR(1)      
  ,@COUNT INT      
  ,@DUPLICATE_YN  INT = 0       
  ,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인      
  ,@BAD_YN  CHAR(1)      
  ,@DI  CHAR(64)      
  ,@ISADULT  CHAR(1)      
  ,@JOIN_DT VARCHAR(10)      
  ,@REALHP_YN CHAR(1)      
  ,@ROWCOUNT INT      
  ,@LAND_CLASS_CD VARCHAR(30)      
  ,@REST_DT VARCHAR(10)      
  -- 2020-10-27 회원가입대행 컬럼 추가      
  ,@AGENCY_YN   CHAR(1) -- 회원가입대행 여부      
  ,@LAST_SIGNUP_YN CHAR(1) -- 회원가입대행 최종 가입 여부      
  ,@REGISTER_NO VARCHAR(30) -- 사업자번호    
  -- 2021-05-24 회원가입대행 > 공인중계사 - 등록번호컬럼 추가      
  ,@MEMBER_TYPE TINYINT -- 회원타입(CST_COMPANY)    
  ,@REG_NUMBER VARCHAR(50) -- 등록번호(CST_COMPANY_LAND)    
  SELECT      
   @COUNT = AA.ROW,      
   @CUID = AA.CUID,      
   @USER_NM = ISNULL(AA.USER_NM,''),      
   @EMAIL = ISNULL(AA.EMAIL,''),      
   @HPHONE = ISNULL(AA.HPHONE,''),      
   @GENDER = AA.GENDER,      
   @REST_YN = AA.REST_YN,      
   @BIRTH = AA.BIRTH,      
   @COM_NM = ISNULL(AA.COM_NM,''),      
   @CONFIRM_YN = AA.CONFIRM_YN,      
   @PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,      
   @SITE_CD = AA.SITE_CD,      
   @MEMBER_CD = AA.MEMBER_CD,      
   @TRUE_YN = AA.TRUE_YN,      
   @BAD_YN = AA.BAD_YN,      
   @DI = AA.DI,      
   @USERID = AA.USERID,      
   @ISADULT = AA.ADULT_YN,      
   @JOIN_DT = AA.JOIN_DT,      
   @REALHP_YN = AA.REALHP_YN,      
   @LAND_CLASS_CD = AA.LAND_CLASS_CD,      
   @REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END),      
   -- 2020-10-27 회원가입대행 컬럼 추가      
   @AGENCY_YN   = AA.AGENCY_YN,      
   @LAST_SIGNUP_YN  = AA.LAST_SIGNUP_YN,      
   @REGISTER_NO = AA.REGISTER_NO,    
   @MEMBER_TYPE = ISNULL(AA.MEMBER_TYPE, 1),    
   @REG_NUMBER  = ISNULL(AA.REG_NUMBER, '')    
   FROM       
   (      
   SELECT      
   ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,      
   M.CUID,      
   M.USER_NM,      
   M.EMAIL,      
   M.HPHONE,      
   M.GENDER,      
   M.REST_YN,      
   M.BIRTH,      
   C.COM_NM,      
   M.CONFIRM_YN,      
   M.MASTER_ID,      
   M.STATUS_CD,      
   M.PWD_NEXT_ALARM_DT,      
   M.SITE_CD,      
   M.MEMBER_CD,      
   'Y' AS TRUE_YN,      
   M.BAD_YN,      
   M.DI,      
   M.USERID,      
   ISNULL(M.ADULT_YN,'N') AS ADULT_YN,      
   CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,      
   ISNULL(REALHP_YN,'N') AS REALHP_YN,      
   CL.LAND_CLASS_CD,      
   M.REST_DT,      
   -- 2020-10-27 회원가입대행 컬럼 추가      
   ISNULL(M.AGENCY_YN,'N') AS AGENCY_YN,      
   M.LAST_SIGNUP_YN,      
   C.REGISTER_NO,    
   -- 2021-05-24 회원가입대행 컬럼 추가      
   C.MEMBER_TYPE, -- 회원타입(CST_COMPANY)    
   CL.REG_NUMBER  -- 등록번호(CST_COMPANY_LAND)    
  FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID      
    LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID      
  WHERE M.OUT_YN='N'      
    AND M.USERID = @USERID       
   AND  pwd_sha2 = master.DBO.fnGetStringToSha256(dbo.FN_MD5(LOWER(@PWD)))      
   AND (M.STATUS_CD <> 'D' OR M.STATUS_CD IS NULL) --2018.01.26 추가      
  ) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL      
   /* NULL : 통합 전    로그인 가능      
   W : 통합 승인대기중  로그인 가능      
   A : 통합 후 마스터계정   로그인 가능      
   D : 통합 후 서브계정  로그인 불가능      
   */         
  -- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음      
  set @ROWCOUNT = @@ROWCOUNT      
        
        
  IF @ROWCOUNT = 0       
  BEGIN      
   IF EXISTS(SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @USERID)       
   BEGIN      
   INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES      
           (@CUID ,@USERID, getdate(), @SECTION_CD,'N', @IP, @HOST)      
         
   RETURN(200) -- 비밀 번호 틀림      
   END      
  END       
  ELSE IF @ROWCOUNT <> 2       
  BEGIN       
   /* 2순위 계정 체크 시작 {계정 변환 로직으로 ~!!! 300 }*/      
   EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC @CUID      
   IF @DUPLICATE_YN = 1      
   BEGIN      
    SET @COUNT = 3      
   END      
   /* 2순위 계정 체크  끝*/      
  END       
        
  IF @REST_YN = 'Y' AND @ROWCOUNT <> 2  -- 중복회원 체크가 우선       
  BEGIN      
   RETURN(500) -- 휴면 고객      
  END ELSE IF @CUID IS NULL      
  BEGIN      
   INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES      
           (@CUID,@USERID,getdate(),@SECTION_CD,'N', @IP, 'ERR')    -- 로그인 이력 남기기      
        
   RETURN(400) -- 사용자가 없음      
  END ELSE IF @COUNT > 1       
  BEGIN       
   IF @COUNT = 3       
   BEGIN      
     SELECT       
    @CUID AS CUID,      
    @USER_NM AS USER_NM,      
    @EMAIL AS EMAIL,      
    @HPHONE AS HPHONE,      
    ISNULL(@GENDER,'') AS GENDER,      
    @REST_YN AS REST_YN,      
    ISNULL(@BIRTH,'') AS BIRTH,      
    @COM_NM AS COM_NM,      
    @CONFIRM_YN AS CONFIRM_YN,      
    --@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,      
    @SITE_CD AS SITE_CD,      
    @MEMBER_CD AS MEMBER_CD,      
    'N' AS TRUE_YN,      
    @PWD_CHANGE_YN AS PWD_CHANGE_YN,      
    @DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임      
    @USERID AS USERID,      
    @BAD_YN AS BAD_YN,      
    ISNULL(@DI,'') AS DI,      
    ISNULL(@ISADULT,'') AS ISADULT,      
    '' AS SNSTYPE,      
    @JOIN_DT AS JOIN_DT,      
    ISNULL(@REALHP_YN,'') as REALHP_YN,      
    @PWD AS PWD,      
    DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,      
    @USER_NM AS USERNAME,      
    '' AS SECTION_CD,      
    ISNULL(@LAND_CLASS_CD,'') AS LAND_CLASS_CD,      
    @REST_DT AS REST_DT,      
    -- 2020-10-27 회원가입대행 컬럼 추가      
    @AGENCY_YN AS AGENCY_YN,      
    @LAST_SIGNUP_YN AS LAST_SIGNUP_YN,      
    @REGISTER_NO AS REGISTER_NO,    
    @MEMBER_TYPE AS MEMBER_TYPE,    
    @REG_NUMBER  AS REG_NUMBER    
    RETURN(300) -- 2순위 아이디      
   END      
   ELSE      
   BEGIN -- @COUNT = 2      
    RETURN(900) -- 복수의 아이디(아이디/비번 중복됨)      
   END      
  END ELSE IF @COUNT = 1      
  BEGIN       
   SET @PWD_CHANGE_YN = 'N'      
   IF @PWD_NEXT_ALARM_DT < GETDATE() SET @PWD_CHANGE_YN = 'Y'      
      
   /*전화번호 중복 alert 확인용*/      
   IF @MEMBER_CD  = 1  AND ISNULL(@REALHP_YN,'N') <> 'Y'      
   BEGIN      
    SELECT @DUPLICATE_PHONE = COUNT(*)       
    FROM CST_MASTER WITH(NOLOCK)       
    where HPHONE = @HPHONE and MEMBER_CD = 1       
      
    IF @DUPLICATE_PHONE  > 1       
    BEGIN      
     SET @REALHP_YN ='N'      
     SET @DUPLICATE_PHONE = 1      
    END       
    ELSE BEGIN      
     SET @REALHP_YN ='Y'      
     SET @DUPLICATE_PHONE = 0      
    END      
      
   END      
   ELSE       
   BEGIN      
    SET @REALHP_YN = 'Y'      
   END      
         
   /* 순서 변경하지 마세요. 뒷부분에 추가 */      
   SELECT      
    -- @COUNT AS ROW,         
    @CUID AS CUID,      
    @USER_NM AS USER_NM,      
    @EMAIL AS EMAIL,      
    @HPHONE AS HPHONE,      
    ISNULL(@GENDER,'') AS GENDER,      
    @REST_YN AS REST_YN,      
    ISNULL(@BIRTH,'') AS BIRTH,      
    @COM_NM AS COM_NM,      
    @CONFIRM_YN AS CONFIRM_YN,      
    --@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,      
    @SITE_CD AS SITE_CD,      
    @MEMBER_CD AS MEMBER_CD,      
    @TRUE_YN AS TRUE_YN,      
    @PWD_CHANGE_YN AS PWD_CHANGE_YN,      
    @DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임      
    @USERID AS USERID,      
    @BAD_YN AS BAD_YN,      
    ISNULL(@DI,'') AS DI,      
    ISNULL(@ISADULT,'') AS ISADULT,      
    '' AS SNSTYPE,      
    @JOIN_DT AS JOIN_DT,      
    ISNULL(@REALHP_YN,'') as REALHP_YN,      
    @PWD AS PWD,      
    DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,      
    @USER_NM AS USERNAME,      
    '' AS SECTION_CD,      
    ISNULL(@LAND_CLASS_CD,'') AS LAND_CLASS_CD,      
    @REST_DT AS REST_DT,      
          -- 2020-10-27 회원가입대행 컬럼 추가      
    @AGENCY_YN AS AGENCY_YN,      
    @LAST_SIGNUP_YN AS LAST_SIGNUP_YN,   
    @REGISTER_NO AS REGISTER_NO,    
    -- 2021-05-24 회원가입대행 컬럼 추가  
    @MEMBER_TYPE AS MEMBER_TYPE,    
    @REG_NUMBER  AS REG_NUMBER    
      
    UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()      
    WHERE CUID = @CUID     -- 마지막 로그인 시간       
    ;

    -- 2021-10-05 LOGIN_STATUS 컬럼 추가        
    INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST, LOGIN_STATUS) VALUES      
           (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST, 1)    -- 로그인 이력 남기기      
                 
   RETURN(0) -- 정상 정상      
  END 
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_ADMIN]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
  DECLARE @RET INT
  EXEC @RET=SP_LOGIN 'mwmobile01','11111111' , 'S101' ,'IP','HOST'
  SELECT @RET  -- 성공
  declare @DUPLICATE_YN INT 
  		EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160
	SELECT @DUPLICATE_YN
exec mwmember.dbo.SP_LOGIN_ADMIN 'soliamor20', '', 'H001', '58.76.233.113', 'member.serve.co.kr', 'intranet' 
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_ADMIN]
@USERID VARCHAR(50) 
,@PWD VARCHAR(30)
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
,@loginFrom varchar(25) = ''
AS
	SET NOCOUNT ON;
	DECLARE  
		@CUID INT
		,@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)
		,@ISADULT  CHAR(1)
		,@JOIN_DT VARCHAR(10)
		,@REALHP_YN	CHAR(1)
		,@ROWCOUNT INT
		,@LAND_CLASS_CD VARCHAR(30)
		,@REST_DT VARCHAR(10)
		SELECT TOP 1
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = ISNULL(AA.USER_NM,''),
			@EMAIL = AA.EMAIL,
			@HPHONE = ISNULL(AA.HPHONE,''),
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = ISNULL(AA.COM_NM,''),
			@CONFIRM_YN = AA.CONFIRM_YN,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = AA.REALHP_YN,
			@LAND_CLASS_CD = AA.LAND_CLASS_CD,
			@REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END)
			FROM 
			(
			SELECT 
			ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			ISNULL(M.ADULT_YN,'N') AS ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'N') AS REALHP_YN,
			CL.LAND_CLASS_CD,
			M.REST_DT
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
			 LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID
		WHERE M.OUT_YN='N'
		  AND M.USERID = @USERID 
			AND (pwd_sha2 = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD))) OR @loginFrom = 'intranet')
			AND M.USERID <> ''
			AND M.USERID is not null
		) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
		ORDER BY AA.SITE_CD DESC		
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/			
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음

			IF @@ROWCOUNT > 0 BEGIN
      /*순서 변경하지 마세요. 뒷부분에 추가*/
			SELECT
				-- @COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				@GENDER AS GENDER,
				@REST_YN AS REST_YN,
				@BIRTH AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAD_YN,
				@DI AS DI,
				@ISADULT AS ISADULT,
				'' AS SNSTYPE,
				@JOIN_DT AS JOIN_DT,
				@REALHP_YN as REALHP_YN,
				@PWD AS PWD,
				DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,
				@USER_NM AS USERNAME,
				'' AS section_cd,
				@LAND_CLASS_CD AS LAND_CLASS_CD,
				@REST_DT AS REST_DT
        
				--UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()
				--	,PWD = DBO.FN_MD5(LOWER(@PWD))
				--	,login_pwd_enc = NULL
				--  WHERE CUID = @CUID			  -- 마지막 로그인 시간 
				  
				IF @loginFrom <> 'intranet' 
				BEGIN				  
					INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
											  (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기
				END
				ELSE
				BEGIN
					--. edit by 안대희 2021-10-14 admin 이력 추가
					INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST, LOGIN_STATUS) VALUES
											  (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, 'admin.serve.co.kr', 1)    -- 로그인 이력 남기기
				END
													  
				RETURN(0) -- 정상 정상
		
			END
			ELSE BEGIN
			
				RETURN(1)
			
			END
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_ADMIN_T]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
  DECLARE @RET INT
  EXEC @RET=SP_LOGIN 'mwmobile01','11111111' , 'S101' ,'IP','HOST'
  SELECT @RET  -- 성공
  declare @DUPLICATE_YN INT 
  		EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160
	SELECT @DUPLICATE_YN
exec mwmember.dbo.SP_LOGIN_ADMIN_T 'soliamor20', '', 'H001', '58.76.233.113', 'member.serve.co.kr', '' 
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_ADMIN_T]
@USERID VARCHAR(50) 
,@PWD VARCHAR(30)
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
,@loginFrom varchar(25) = ''
AS
	SET NOCOUNT ON;
	DECLARE  
		@CUID INT
		,@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)
		,@ISADULT  CHAR(1)
		,@JOIN_DT VARCHAR(10)
		,@REALHP_YN	CHAR(1)
		,@ROWCOUNT INT
		,@LAND_CLASS_CD VARCHAR(30)
		,@REST_DT VARCHAR(10)
		
		SELECT TOP 1
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = ISNULL(AA.USER_NM,''),
			@EMAIL = AA.EMAIL,
			@HPHONE = ISNULL(AA.HPHONE,''),
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = ISNULL(AA.COM_NM,''),
			@CONFIRM_YN = AA.CONFIRM_YN,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = AA.REALHP_YN,
			@LAND_CLASS_CD = AA.LAND_CLASS_CD,
			@REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END)
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			ISNULL(M.ADULT_YN,'N') AS ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'N') AS REALHP_YN,
			CL.LAND_CLASS_CD,
			M.REST_DT
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
			 LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID
		WHERE M.OUT_YN='N'
		  AND M.USERID = @USERID 
			AND (PWD = DBO.FN_MD5(LOWER(@PWD)) OR PwdCompare(@PWD, login_pwd_enc) = 1 OR @loginFrom = 'intranet')
--			AND M.SITE_CD = case when @loginFrom = 'intranet' then M.SITE_CD else 'S' end
			AND M.USERID <> ''
			AND M.USERID is not null
		) AA 
		WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
		ORDER BY AA.SITE_CD DESC
		
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/			
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음

			IF @@ROWCOUNT > 0 BEGIN
      /*순서 변경하지 마세요. 뒷부분에 추가*/
			SELECT
				-- @COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				@GENDER AS GENDER,
				@REST_YN AS REST_YN,
				@BIRTH AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAD_YN,
				@DI AS DI,
				@ISADULT AS ISADULT,
				'' AS SNSTYPE,
				@JOIN_DT AS JOIN_DT,
				@REALHP_YN as REALHP_YN,
				@PWD AS PWD,
				DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,
				@USER_NM AS USERNAME,
				'' AS section_cd,
				@LAND_CLASS_CD AS LAND_CLASS_CD,
				@REST_DT AS REST_DT
        
				--UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()
				--	,PWD = DBO.FN_MD5(LOWER(@PWD))
				--	,login_pwd_enc = NULL
				--  WHERE CUID = @CUID			  -- 마지막 로그인 시간 
				
				IF @loginFrom <> 'intranet' BEGIN				  
					INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
											  (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기
				END 
												  
				RETURN(0) -- 정상 정상
		
			END
			ELSE BEGIN
			
				RETURN(1)
			
			END
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_BK01]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
  DECLARE @RET INT
  EXEC @RET=SP_LOGIN 'sebilia','hs7410!!' , 'S101' ,'60.209.90.89','land.findall.co.kr'
  SELECT @RET  -- 성공
  declare @DUPLICATE_YN INT 
  		EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160
	SELECT @DUPLICATE_YN
	
	exec DBO.SP_LOGIN_BK01 'kkamang1234','hs7410!!','S101','121.166.161.13','www.findall.co.kr'
	
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_BK01]
@USERID VARCHAR(50) 
,@PWD VARCHAR(30)
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
AS
	SET NOCOUNT ON;
	DECLARE  
		@CUID INT
		,@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)
		,@ISADULT  CHAR(1)
		,@JOIN_DT VARCHAR(10)
		,@REALHP_YN	CHAR(1)
		,@ROWCOUNT INT
		,@LAND_CLASS_CD VARCHAR(30)
		,@REST_DT VARCHAR(10)
		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = ISNULL(AA.USER_NM,''),
			@EMAIL = ISNULL(AA.EMAIL,''),
			@HPHONE = ISNULL(AA.HPHONE,''),
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = ISNULL(AA.COM_NM,''),
			@CONFIRM_YN = AA.CONFIRM_YN,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = AA.REALHP_YN,
			@LAND_CLASS_CD = AA.LAND_CLASS_CD,
			@REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END)
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			ISNULL(M.ADULT_YN,'N') AS ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'N') AS REALHP_YN,
			CL.LAND_CLASS_CD,
			M.REST_DT
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
			 LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID
		WHERE M.OUT_YN='N'
		  AND M.USERID = 'kkam1234' 
			AND (PWD = DBO.FN_MD5(LOWER(@PWD)) OR PwdCompare(@PWD, login_pwd_enc) = 1)
		) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
		
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/			
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음
		set @ROWCOUNT = @@ROWCOUNT
		
		
		
		SELECT @CUID,@ROWCOUNT
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_FAIL_COUNT]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 실패 로그
 *  작   성   자 : JMG
 *  작   성   일 : 2019-01-02
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
exec sp_login_fail_count 'bird4567', 'T'
exec sp_login_fail_count 'bird4567', 'F'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_FAIL_COUNT]
@USERID VARCHAR(50) ,
@TANDF  VARCHAR(2)
AS
	SET NOCOUNT ON;

	IF @TANDF = 'T' 
	BEGIN
		
		IF EXISTS(SELECT FAIL_CNT FROM CST_LOGIN_FAIL_COUNT	WHERE USERID = @USERID AND FAIL_CNT <= 5)
		BEGIN
			UPDATE CST_LOGIN_FAIL_COUNT 
			SET FAIL_CNT = 0
			, FAIL_DATE = ''
			WHERE USERID = @USERID
		END 

	END ELSE BEGIN

		--로그인 실패 횟수 체크
		IF EXISTS(SELECT * FROM CST_LOGIN_FAIL_COUNT WITH(NOLOCK) WHERE USERID = @USERID) 
		BEGIN
			UPDATE CST_LOGIN_FAIL_COUNT
			SET FAIL_CNT = FAIL_CNT + 1
			, FAIL_DATE = GETDATE()
			WHERE USERID = @USERID
		END ELSE BEGIN
			INSERT INTO CST_LOGIN_FAIL_COUNT (USERID, FAIL_CNT, FAIL_DATE) VALUES
			(@USERID, 1, GETDATE())
		END
	END 

	SELECT FAIL_CNT
	FROM CST_LOGIN_FAIL_COUNT
	WHERE USERID = @USERID

	
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_LOG]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 이력
 *  작   성   자 : KJH
 *  작   성   일 : 2016-08-31
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 

 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_LOG]
 @CUID int
,@USERID varchar(50) 
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
AS
	SET NOCOUNT ON;

	select top 1 @USERID = userid
	from dbo.CST_MASTER with(nolock)
	where CUID = @CUID
			  
	INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
	(@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기

	UPDATE CST_MASTER 
     SET LAST_LOGIN_DT = getdate()
	 WHERE CUID = @CUID	

GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_NOPWD_ADMIN]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
  DECLARE @RET INT
  EXEC @RET=[SP_LOGIN_NOPWD_ADMIN] 'sebilia'
  SELECT @RET  -- 성공
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_NOPWD_ADMIN]
 @USERID VARCHAR(50) 
AS
	SET NOCOUNT ON;
	DECLARE  
		@CUID INT
		,@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)
		,@ISADULT  CHAR(1)
		,@JOIN_DT VARCHAR(10)
		,@REALHP_YN	CHAR(1)
		,@ROWCOUNT INT
		
		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = ISNULL(AA.USER_NM,''),
			@EMAIL = AA.EMAIL,
			@HPHONE = ISNULL(AA.HPHONE,''),
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = ISNULL(AA.COM_NM,''),
			@CONFIRM_YN = AA.CONFIRM_YN,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = AA.REALHP_YN
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			ISNULL(M.ADULT_YN,'N') AS ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'N') AS REALHP_YN
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
		WHERE M.OUT_YN='N'
		  AND M.USERID = @USERID 
		) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/			

		SET @ROWCOUNT = @@ROWCOUNT
		IF @ROWCOUNT = 2
		BEGIN 
      RETURN(900)
		END 

		IF @REST_YN = 'Y' 
		BEGIN
			RETURN(500) -- 휴면 고객
		END ELSE IF @CUID IS NULL
		BEGIN
			RETURN(400) -- 사용자가 없음
		END ELSE
		BEGIN
		
      /*순서 변경하지 마세요. 뒷부분에 추가*/
			SELECT
				-- @COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				@GENDER AS GENDER,
				@REST_YN AS REST_YN,
				@BIRTH AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAR_YN,
				@DI AS DI,
				@ISADULT AS ISADULT,
				'' AS SNSTYPE,
				@JOIN_DT AS JOIN_DT,
				@REALHP_YN as REALHP_YN
        
								  
			RETURN(0) -- 정상 정상
		END	
		
		
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_RETS]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
  DECLARE @RET INT
  EXEC @RET=SP_LOGIN_RETS 'mwmobile01','11111111' , 'S101' ,'IP','HOST'
  SELECT @RET  -- 성공
  declare @DUPLICATE_YN INT 
  		EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160
	SELECT @DUPLICATE_YN
exec mwmember.dbo.SP_LOGIN_RETS 'soliamor20', '', 'H001', '58.76.233.113', 'member.serve.co.kr', 'intranet' 
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_RETS]
@CUID		int = 0
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
AS
	SET NOCOUNT ON;
	DECLARE  
		@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)
		,@ISADULT  CHAR(1)
		,@JOIN_DT VARCHAR(10)
		,@REALHP_YN	CHAR(1)
		,@ROWCOUNT INT
		,@LAND_CLASS_CD VARCHAR(30)
		,@REST_DT VARCHAR(10)
		,@USERID VARCHAR(50) 
		,@PWD VARCHAR(30)
		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = ISNULL(AA.USER_NM,''),
			@EMAIL = ISNULL(AA.EMAIL,''),
			@HPHONE = ISNULL(AA.HPHONE,''),
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = ISNULL(AA.COM_NM,''),
			@CONFIRM_YN = AA.CONFIRM_YN,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = AA.REALHP_YN,
			@LAND_CLASS_CD = AA.LAND_CLASS_CD,
			@REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END)
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			M.ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'N') AS REALHP_YN,
			CL.LAND_CLASS_CD,
			M.REST_DT
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
			 LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID
		WHERE M.OUT_YN='N'
--			AND M.SITE_CD = 'S'
			AND M.USERID <> ''
			AND M.USERID is not null
			AND M.CUID = @CUID
		) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/			
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음

			IF @@ROWCOUNT > 0 BEGIN
      /*순서 변경하지 마세요. 뒷부분에 추가*/
			SELECT
				-- @COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				@GENDER AS GENDER,
				@REST_YN AS REST_YN,
				@BIRTH AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAD_YN,
				@DI AS DI,
				@ISADULT AS ISADULT,
				'' AS SNSTYPE,
				@JOIN_DT AS JOIN_DT,
				@REALHP_YN as REALHP_YN,
				@PWD AS PWD,
				DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,
				@USER_NM AS USERNAME,
				'' AS section_cd,
				@LAND_CLASS_CD AS LAND_CLASS_CD,
				@REST_DT AS REST_DT
        
				UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()
				--	,PWD = DBO.FN_MD5(LOWER(@PWD))
				--	,login_pwd_enc = NULL
				  WHERE CUID = @CUID			  -- 마지막 로그인 시간 
				

					INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
											  (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기
												  
				RETURN(0) -- 정상 정상
		
			END
			ELSE BEGIN
			
				RETURN(1)
			
			END
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_RETS_BAK01]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(300) -- 복수의 아이디
 * RETURN(200) -- 비밀 번호 틀림
 * RETURN(0) -- 정상 정상
  DECLARE @RET INT
  EXEC @RET=SP_LOGIN_RETS 'mwmobile01','11111111' , 'S101' ,'IP','HOST'
  SELECT @RET  -- 성공
  declare @DUPLICATE_YN INT 
  		EXEC @DUPLICATE_YN = GET_DUPLICATE_USERID_TB_PROC 13818160
	SELECT @DUPLICATE_YN
exec mwmember.dbo.SP_LOGIN_RETS_BAK01 '13819002', 'H001', '58.76.233.113', 'member.serve.co.kr'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_LOGIN_RETS_BAK01]
@CUID		int = 0
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
AS
	SET NOCOUNT ON;
	DECLARE  
		@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@PWD_NEXT_ALARM_DT DATETIME
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)
		,@ISADULT  CHAR(1)
		,@JOIN_DT VARCHAR(10)
		,@REALHP_YN	CHAR(1)
		,@ROWCOUNT INT
		,@LAND_CLASS_CD VARCHAR(30)
		,@REST_DT VARCHAR(10)
		,@USERID VARCHAR(50) 
		,@PWD VARCHAR(30)
		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = ISNULL(AA.USER_NM,''),
			@EMAIL = ISNULL(AA.EMAIL,''),
			@HPHONE = ISNULL(AA.HPHONE,''),
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = ISNULL(AA.COM_NM,''),
			@CONFIRM_YN = AA.CONFIRM_YN,
			@PWD_NEXT_ALARM_DT = AA.PWD_NEXT_ALARM_DT,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = AA.REALHP_YN,
			@LAND_CLASS_CD = AA.LAND_CLASS_CD,
			@REST_DT = (CASE WHEN AA.REST_DT IS NULL THEN '' ELSE CONVERT(CHAR(10),@REST_DT,21) END)
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY M.USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			C.COM_NM,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.PWD_NEXT_ALARM_DT,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			M.ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'N') AS REALHP_YN,
			CL.LAND_CLASS_CD,
			M.REST_DT
		FROM CST_MASTER M WITH(NOLOCK) LEFT OUTER JOIN CST_COMPANY C WITH(NOLOCK) ON M.COM_ID = C.COM_ID
			 LEFT OUTER JOIN CST_COMPANY_LAND CL WITH(NOLOCK) ON M.COM_ID = CL.COM_ID
		WHERE M.OUT_YN='N'
--			AND M.SITE_CD = 'S'
			AND M.USERID <> ''
			AND M.USERID is not null
			AND M.CUID = @CUID
		) AA WHERE AA.STATUS_CD IN ('W','A') OR AA.STATUS_CD IS NULL
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/			
		-- kim1277 ( 중복 아이디 ) 서브에도 살아 있고 벼룩시장에도 살아 있음

			IF @@ROWCOUNT > 0 BEGIN
      /*순서 변경하지 마세요. 뒷부분에 추가*/
			SELECT
				-- @COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				@GENDER AS GENDER,
				@REST_YN AS REST_YN,
				@BIRTH AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				--@PWD_NEXT_ALARM_DT AS PWD_NEXT_ALARM_DT,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAD_YN,
				@DI AS DI,
				@ISADULT AS ISADULT,
				'' AS SNSTYPE,
				@JOIN_DT AS JOIN_DT,
				@REALHP_YN as REALHP_YN,
				@PWD AS PWD,
				DBO.FN_MD5(LOWER(@PWD)) AS USER_PWD,
				@USER_NM AS USERNAME,
				'' AS section_cd,
				@LAND_CLASS_CD AS LAND_CLASS_CD,
				@REST_DT AS REST_DT

				UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()
				--	,PWD = DBO.FN_MD5(LOWER(@PWD))
				--	,login_pwd_enc = NULL
				  WHERE CUID = @CUID			  -- 마지막 로그인 시간 
				

					INSERT INTO CST_LOGIN_LOG (CUID,  USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
											  (@CUID,@USERID,getdate(),@SECTION_CD,'Y', @IP, @HOST)    -- 로그인 이력 남기기
												  
				RETURN(0) -- 정상 정상
		
			END
			ELSE BEGIN
			
				RETURN(1)
			
			END
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_SNS]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_LOGIN_SNS]
/*************************************************************************************
 *  단위 업무 명 : 로그인 및 이력 SNS
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500) -- 휴면 고객
 * RETURN(400) -- 사용자가 없음
 * RETURN(0) -- 정상 정상
 * DECLARE @RET INT
 * EXEC @RET=SP_LOGIN_SNS 'nadu81@naver.com' , 'K' ,'207053388', '','IP','HOST'
 * SELECT @RET
 *************************************************************************************/
@SNS_TYPE CHAR(1)  
,@SNS_ID VARCHAR(100) 
,@SECTION_CD CHAR(4)
,@IP VARCHAR(15)
,@HOST VARCHAR(50)
,@USERID  varchar(50) OUTPUT
AS
	SET NOCOUNT ON;
	DECLARE  
		@CUID INT
		,@USER_NM varchar(30)
		,@EMAIL varchar(50)
		,@HPHONE varchar(14)
		,@MEMBER_CD CHAR(1)
		,@GENDER CHAR(1)
		,@REST_YN CHAR(1)
		,@BIRTH varchar(8)
		,@COM_NM varchar(50)
		,@CONFIRM_YN CHAR(1)
		,@SITE_CD CHAR(1)
		,@TRUE_YN CHAR(1)
		,@PWD_CHANGE_YN CHAR(1)
		,@COUNT INT
		,@DUPLICATE_YN  INT = 0 
		,@DUPLICATE_PHONE INT = 0 --개인 전화번호 중복 여부 확인
		,@BAD_YN  CHAR(1)
		,@DI  CHAR(64)		
		,@ISADULT CHAR(1)
		,@JOIN_DT VARCHAR(10)
    ,@REALHP_YN	CHAR(1)
		SELECT
			@COUNT = AA.ROW,
			@CUID = AA.CUID,
			@USER_NM = ISNULL(AA.USER_NM,''),
			@EMAIL = ISNULL(AA.EMAIL,''),
			@HPHONE = ISNULL(AA.HPHONE,''),
			@GENDER = AA.GENDER,
			@REST_YN = AA.REST_YN,
			@BIRTH = AA.BIRTH,
			@COM_NM = ISNULL(AA.COM_NM,''),
			@CONFIRM_YN = AA.CONFIRM_YN,
			@SITE_CD = AA.SITE_CD,
			@MEMBER_CD = AA.MEMBER_CD,
			@TRUE_YN = AA.TRUE_YN,			
			@BAD_YN = AA.BAD_YN,
			@DI = AA.DI,
			@USERID = AA.USERID,
			@ISADULT = AA.ADULT_YN,
			@JOIN_DT = AA.JOIN_DT,
			@REALHP_YN = IsNULL(AA.REALHP_YN,'N')
			FROM 
			(
			SELECT
			ROW_NUMBER()  OVER( ORDER BY USERID DESC) AS ROW,
			M.CUID,
			M.USER_NM,
			M.EMAIL,
			M.HPHONE,
			M.GENDER,
			M.REST_YN,
			M.BIRTH,
			M.CONFIRM_YN,
			M.MASTER_ID,
			M.STATUS_CD,
			M.SITE_CD,
			M.MEMBER_CD,
			'Y' AS TRUE_YN,
			M.BAD_YN,
			M.DI,
			M.USERID,
			ISNULL(M.ADULT_YN,'N') AS ADULT_YN,
			CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT,
			ISNULL(REALHP_YN,'Y') AS REALHP_YN ,
      C.COM_NM
	 FROM CST_MASTER M WITH(NOLOCK) 
   LEFT JOIN CST_COMPANY AS C WITH(NOLOCK) ON C.COM_ID = M.COM_ID
	WHERE M.OUT_YN='N' 
	  AND M.SNS_TYPE = @SNS_TYPE 
	  AND SNS_ID = @SNS_ID 
		) AA WHERE  AA.STATUS_CD IN ('W', 'A') OR AA.STATUS_CD IS NULL
			/* NULL : 통합 전    로그인 가능
			W : 통합 승인대기중  로그인 가능
			A : 통합 후 마스터계정   로그인 가능
			D : 통합 후 서브계정  로그인 불가능
			*/
		IF @REST_YN = 'Y' 
		BEGIN
			RETURN(500) -- 휴면 고객
		END ELSE IF @CUID IS NULL
		BEGIN
			RETURN(400) -- 사용자가 없음
		END ELSE IF @COUNT = 1
		BEGIN 
			SET @PWD_CHANGE_YN = 'N'

			/*전화번호 중복 alert 확인용*/
			IF @MEMBER_CD  = 1  AND ISNULL(@REALHP_YN,'N') <> 'Y'
			BEGIN
				SELECT @DUPLICATE_PHONE = COUNT(*) 
				FROM CST_MASTER WITH(NOLOCK) 
				where HPHONE = @HPHONE and MEMBER_CD = 1 

				IF @DUPLICATE_PHONE  > 1 
				BEGIN
					SET @REALHP_YN ='N'
					SET @DUPLICATE_PHONE = 1
				END 
				ELSE BEGIN
					SET @REALHP_YN ='Y'
					SET @DUPLICATE_PHONE = 0
				END
			END
			BEGIN
				SET @REALHP_YN = 'Y'
			END

		  /*순서 변경하지 마세요. 뒷부분에 추가*/
			SELECT
				--@COUNT AS ROW,			
				@CUID AS CUID,
				@USER_NM AS USER_NM,
				@EMAIL AS EMAIL,
				@HPHONE AS HPHONE,
				ISNULL(@GENDER,'') AS GENDER,
				@REST_YN AS REST_YN,
				ISNULL(@BIRTH,'') AS BIRTH,
				@COM_NM AS COM_NM,
				@CONFIRM_YN AS CONFIRM_YN,
				@SITE_CD AS SITE_CD,
				@MEMBER_CD AS MEMBER_CD,
				@TRUE_YN AS TRUE_YN,
				@PWD_CHANGE_YN AS PWD_CHANGE_YN,
				@DUPLICATE_PHONE as PERSON_PHONE_DUPLICATE, --1일경우 중복임
				@USERID AS USERID,
				@BAD_YN AS BAR_YN,
				ISNULL(@DI,'') AS DI,
				ISNULL(@ISADULT,'') AS ISADULT,
				@SNS_TYPE AS SNS_TYPE,
				@JOIN_DT AS JOIN_DT,
				ISNULL(@REALHP_YN,'') as REALHP_YN
				
				UPDATE CST_MASTER SET LAST_LOGIN_DT = getdate()  WHERE CUID = @CUID			  -- 마지막 로그인 시간
				 
				INSERT INTO CST_LOGIN_LOG (CUID, USERID, LOGIN_DT, SECTION_CD, SUCCESS_YN,IP, HOST) VALUES
									      (@CUID, @USERID, getdate(),@SECTION_CD,'Y', @IP, @HOST )    -- 로그인 이력 남기기
									      
			RETURN(0) -- 정상 정상
		END
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_STS_S1]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************************
* 단위 업무명: 회원 비밀번호 변경 확인
* 작  성  자: 안대희
* 작  성  일: 2021-09-29
* 설      명: 회원 비밀번호 변경상태 확인
* 사용  예제: EXEC MWMEMBER.DBO.SP_LOGIN_STS_S1 13621996, '127.0.0.1', 0
*************************************************************************************************/
/*  
    ** 수정 내역 **
    1. 수 정 자: 
    1-1. 수 정 일: 
    1-2. 수정 내역: 
*/  
CREATE PROCEDURE [dbo].[SP_LOGIN_STS_S1]
    @cuid           INT,            /* 회원번호 */
    @reg_ip         VARCHAR(30),    /* 사용자 IP ADDR */
    @return_value   INT OUTPUT
AS	
BEGIN
	IF EXISTS (
        SELECT CUID
        FROM CST_LOGIN_LOG
        WHERE CUID = @cuid
        AND success_yn = 'Y'
        AND IP = @reg_ip
    )
    Begin
        SELECT TOP 1 @return_value = ISNULL(login_status, 1)
        FROM CST_LOGIN_LOG
        WHERE CUID = @cuid
        AND success_yn = 'Y'
        AND IP = @reg_ip
        ORDER BY login_dt DESC
    End
    ELSE
    Begin
        SET @return_value = 0;
    End

    -- Return(@return_value)
END;

GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_BIZ_JOIN]    Script Date: 2021-11-04 오전 11:00:45 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_MASTER_CHANGE_JOIN]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_MASTER_CHANGE_JOIN]
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
 *************************************************************************************/
 -- 개인 정보
  @CUID INT,
  @USERID VARCHAR(50),
  @USER_NM  varchar(30) ,
  @HPHONE  varchar(14),
  @GENDER  char(1),
  @BIRTH  varchar(8),
  @DI  char(64),
  @CI  char(88),
  -- 기업 정보
  @COM_NM  varchar(50),
  @CEO_NM  varchar(30),
  @MAIN_PHONE  varchar(14),
  @PHONE  varchar(14),
  @FAX  varchar(14),
  @HOMEPAGE  varchar(100),
  @REGISTER_NO  varchar(12),
  @LAT  decimal(16, 14),
  @LNG  decimal(17, 14),
  @ZIP_SEQ  int,
  @CITY  varchar(50),
  @GU  varchar(50),
  @DONG  varchar(50),
  @ADDR1  varchar(100),
  @ADDR2  varchar(100),
  @LAW_DONGNO  char(10),
  @MAN_NO  varchar(25),
  @ROAD_ADDR_DETAIL  varchar(100),
  @COM_ID int output,
  @MEMBER_TYPE char(1)

--이력 정보
AS
	SET NOCOUNT ON;
		
	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한
		INSERT INTO CST_COMPANY (COM_NM, CEO_NM, MAIN_PHONE , PHONE, FAX , HOMEPAGE , REGISTER_NO ,
								LAT , LNG , ZIP_SEQ, CITY,
								GU , DONG , ADDR1 , ADDR2 , LAW_DONGNO , MAN_NO , ROAD_ADDR_DETAIL, 
								REG_ID, REG_DT, MOD_ID, MOD_DT, MEMBER_TYPE
								)
							VALUES (@COM_NM, @CEO_NM, @MAIN_PHONE, @PHONE, @FAX , @HOMEPAGE , @REGISTER_NO , 
								@LAT ,@LNG, @ZIP_SEQ , @CITY ,
								@GU ,@DONG ,@ADDR1 , @ADDR2 , @LAW_DONGNO , @MAN_NO , @ROAD_ADDR_DETAIL, 
								@USERID, GETDATE() ,@USERID,  GETDATE(), @MEMBER_TYPE)
		SET @COM_ID = SCOPE_IDENTITY()
	

		UPDATE CST_MASTER 
       SET USER_NM = @USER_NM
          ,DI = @DI
          ,CI = @CI
          ,ADULT_YN = 'Y'
          ,HPHONE = dbo.FN_PHONE_STRING(@HPHONE)
          ,MEMBER_CD = '2'
          ,COM_ID = @COM_ID
          ,BIRTH = @BIRTH
          ,GENDER = @GENDER
          ,MOD_DT = GETDATE()
		 WHERE CUID = @CUID

    -- 구인기업회원으로 전환하는 경우 담당자 정보 개인정보로 대체 등록 (2018.04.02)
    IF @MEMBER_TYPE = '1'
      BEGIN
        INSERT INTO CST_COMPANY_JOB
          (COM_ID, USERID, MANAGER_NM, MANAGER_PHONE, MANAGER_EMAIL, SECTION_CD)
        SELECT @COM_ID AS COM_ID
              ,USERID
              ,@USER_NM AS MANAGER_NM
              ,dbo.FN_PHONE_STRING(@HPHONE) AS MANAGER_PHONE
              ,EMAIL AS MANAGER_EMAIL
              ,'S102' AS SECTION_CD
          FROM CST_MASTER 
         WHERE CUID = @CUID
      END
      

--		SELECT @CUID
		-- 이력을 남기자...
		INSERT INTO CST_CHANGE_HISTORY (CUID,   USERID, CHANGE_DT )
						        VALUES (@CUID, @USERID, GETDATE() )					   

GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_HISTORY_SELECT]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_MASTER_HISTORY_SELECT]
/*************************************************************************************
 *  단위 업무 명 : 개인 정보 수정 이력 보기
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 개인 
 *************************************************************************************/
@CUID INT,
@START_DT VARCHAR(10),
@END_DT VARCHAR(10)
AS	
	DECLARE  @SQL nvarchar(4000)

	SET @SQL = 'SELECT * FROM CST_MASTER_HISTORY WITH(NOLOCK) WHERE CUID = '+  CONVERT(nvarchar,@CUID)
	IF @START_DT != ''
		BEGIN
		SET @START_DT = REPLACE(REPLACE(REPLACE(@START_DT, '-' , ''),':',''),' ','')
		SET @END_DT = REPLACE(REPLACE(REPLACE(@END_DT, '-' , ''),':',''),' ','')
		SET @SQL = @SQL + ' AND MOD_DT between ''' + CONVERT(nvarchar,@START_DT) + ''' AND ''' + CONVERT(nvarchar,@END_DT)+''''
		END

	EXEC(@SQL)

GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_JOIN_COMPANY]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MASTER_JOIN_COMPANY]
/*************************************************************************************
 *  단위 업무 명 : 기업 회원 가입 및 이력
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-28
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(500)  -- 에러
 * RETURN(0)  -- 정상
 * DECLARE @RET INT
 * EXEC @RET=SP_MASTER_JOIN_COMPANY 'USERID','PWD','Y','2','USER_NM','010-0000-0000','EMAIL@EMAIL.EL','M','19802510','DI','CI',  -- 개인정보
         'COM_NM','CEO_NM','MAIN_PHONE','PHONE','FAX','HOMEPAGE','REGISTER_NO',33.47773717697358 ,124.84925073212366,'123','CITY',    
         'GU','DONG','ADDR1','ADDR2','LAW_DONGNO','MAN_NO','ROAD_ADDR_DETAIL',    -- 기업 정보
         'F','JOIN_PATH','JOIN_DOMAIN',1  -- 이력
 * SELECT @RET    -- CUID  
 *************************************************************************************/
 -- 개인 정보
@USERID  varchar(50),
@PWD  VARCHAR(30),
@ADULT_YN  char(1),
@MEMBER_CD  char(1),
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@EMAIL  varchar(50),
@GENDER  char(1),
@BIRTH  varchar(8),
@DI  char(64),
@CI  char(88),
-- 기업 정보
@COM_NM  varchar(50),
@CEO_NM  varchar(30),
@MAIN_PHONE  varchar(14),
@PHONE  varchar(14),
@FAX  varchar(14),
@HOMEPAGE  varchar(100),
@REGISTER_NO  varchar(12),
@LAT  decimal(16, 14),
@LNG  decimal(17, 14),
@ZIP_SEQ  int,
@CITY  varchar(50),
@GU  varchar(50),
@DONG  varchar(50),
@ADDR1  varchar(100),
@ADDR2  varchar(100),
@LAW_DONGNO  char(10),
@MAN_NO  varchar(25),
@ROAD_ADDR_DETAIL  varchar(100),
--이력 정보
@SITE_CD  char(1),
@JOIN_PATH varchar(50),
@JOIN_DOMAIN varchar(50),
@JOIN_OBJECT INT  
AS
	SET	XACT_ABORT	ON
	SET NOCOUNT ON;
	DECLARE @CUID INT, @COM_ID INT, @PWD_NEXT_ALARM_DT DATETIME, @COUNT INT
	SET @PWD_NEXT_ALARM_DT = GETDATE() + 180
	
	SELECT @COUNT = COUNT(*)  
	  FROM CST_MASTER WITH (NOLOCK)
	 WHERE USERID = @USERID
		
	SET  @CITY = DBO.FN_AREA_A_SHORTNAME(@CITY)-- 주소지 2글자로 제한
		IF @SITE_CD = 'S'
		BEGIN
			RETURN(500)
		END ELSE IF @SITE_CD = 'F'
		BEGIN
			RETURN(500)
		END
		ELSE IF @COUNT > 0
		BEGIN
			RETURN(500)
		END
		ELSE IF @COUNT = 0
		BEGIN
		INSERT INTO CST_MASTER ( USERID,  USER_NM,  ADULT_YN,   MOD_ID , pwd_sha2 ,                   MEMBER_CD ,HPHONE,
							EMAIL, GENDER ,  BIRTH, DI, CI, 
							BAD_YN, JOIN_DT, MOD_DT , REST_YN, OUT_YN , LAST_LOGIN_DT, PWD_NEXT_ALARM_DT) 
					VALUES ( @USERID, @USER_NM, @ADULT_YN,  @USERID, master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD))),  @MEMBER_CD, @HPHONE,
							@EMAIL,@GENDER,   @BIRTH, @DI, @CI ,
							'N', GETDATE(),GETDATE(),'N' ,'N' ,GETDATE(), @PWD_NEXT_ALARM_DT)  -- 기본 정보 INSERT
		
		SELECT @CUID = CUID FROM CST_MASTER WITH(NOLOCK)  
		WHERE USERID = @USERID AND REST_YN ='N' AND OUT_YN = 'N' -- 기본 정보를 저장 하고 CUID를 구해 온다

		INSERT INTO CST_COMPANY (COM_NM, CEO_NM, MAIN_PHONE , PHONE, FAX , HOMEPAGE , REGISTER_NO ,
								LAT , LNG , ZIP_SEQ, CITY,
								GU , DONG , ADDR1 , ADDR2 , LAW_DONGNO , MAN_NO , ROAD_ADDR_DETAIL, 
								REG_ID, REG_DT, MOD_ID, MOD_DT, USE_YN
								)
							VALUES (@COM_NM, @CEO_NM, @MAIN_PHONE, @PHONE, @FAX , @HOMEPAGE , @REGISTER_NO , 
								@LAT ,@LNG, @ZIP_SEQ , @CITY ,
								@GU ,@DONG ,@ADDR1 , @ADDR2 , @LAW_DONGNO , @MAN_NO , @ROAD_ADDR_DETAIL, 
								@USERID, GETDATE() ,@USERID,  GETDATE(), 'Y' )
		
		SET  @COM_ID = SCOPE_IDENTITY() 
		
		UPDATE CST_MASTER SET COM_ID = @COM_ID WHERE CUID = @CUID
		-- 이력을 남기자...
		INSERT INTO CST_JOIN_INFO (CUID, USERID, JOIN_DOMAIN, JOIN_OBJECT)
						   VALUES (@CUID, @USERID, @JOIN_DOMAIN, @JOIN_OBJECT)
						   
		SELECT @CUID AS CUID	
		RETURN(0)				   
		END
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_PERSON_JOIN]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_MASTER_PERSON_JOIN]
/*************************************************************************************
 *  단위 업무 명 : 개인 회원 가입 및 이력
 *  작   성   자 : 최승범
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 DBO.SP_MASTER_PERSON_JOIN 'bird3325@naver.com', '', 'N', '1', '조민기', '010-6393-0923', 'bird3325@naver.com', 'M', '19970706', 'N', '23598650', '', '','www.findall.co.kr', '0', 'F', 'S101', 'N'
 DBO.SP_MASTER_PERSON_JOIN '','','N', '1', '조민기', '010-6393-0923', '', 'M', '1990713', 'K', '41197063', '', '', 'WWW.FINDALL.CO.KR', 0, 'F', 'S101', 'N'
 *************************************************************************************/
 -- 개인 정보
@USERID  varchar(50),
@PWD  VARCHAR(30) = NULL,
@ADULT_YN  char(1),
@MEMBER_CD  char(1),
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@EMAIL  varchar(50),
@GENDER  char(1),
@BIRTH  varchar(8),
@SNS_TYPE  char(1),
@SNS_ID  varchar(100),
@DI  char(64),
@CI  char(88),
--이력 정보
--@JOIN_PATH varchar(50),
@JOIN_DOMAIN varchar(50),
@JOIN_OBJECT INT ,
@SITE_CD char(1),
@SECTION_CD char(4),
@HPCHECK char(1),
@JOIN_IP	varchar(20),
@CUID int = 0 output

AS
	SET	XACT_ABORT	ON
	SET NOCOUNT ON;

	DECLARE @COUNT INT, @PWD_NEXT_ALARM_DT DATETIME
	SET @PWD_NEXT_ALARM_DT = GETDATE() + 180
	
	-- SNS 가입자이면
	IF @PWD='' AND @SNS_TYPE<>''
	BEGIN
		SET @PWD = NULL
		SET @PWD_NEXT_ALARM_DT = NULL
		SET @DI = NULL
		SET @CI = NULL

		SELECT @COUNT = COUNT(*)  
		  FROM CST_MASTER WITH (NOLOCK)
		 WHERE SNS_ID  = @SNS_ID
		 AND SNS_TYPE = @SNS_TYPE
		 AND OUT_YN='N'

	END	
	ElSE 
	BEGIN
		SELECT @COUNT = COUNT(*)  
		  FROM CST_MASTER WITH (NOLOCK)
		 WHERE USERID = @USERID
	END
	 
	IF @COUNT=0
	BEGIN

			INSERT INTO CST_MASTER ( 
									USERID,  
									USER_NM, 
									BAD_YN, 
									JOIN_DT,   
									MOD_DT,    
									MOD_ID , 
									pwd_sha2 , 
									PWD_NEXT_ALARM_DT ,
									MEMBER_CD,  
									REST_YN, 
									OUT_YN, 
									ADULT_YN, 
									HPHONE, 
									EMAIL, 
									GENDER, 
									BIRTH, 
									SNS_TYPE, 
									SNS_ID , 
									CI, 
									DI,
									LAST_LOGIN_DT,
									SITE_CD,
									REALHP_YN,
									JOIN_IP)
			VALUES (@USERID, 
					@USER_NM, 
					'N',   
					GETDATE(), 
					GETDATE(), 
					@USERID, 
					master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD))), 
					@PWD_NEXT_ALARM_DT ,
					--@MEMBER_CD ,  
					'1',
					'N' ,   
					'N', 
					@ADULT_YN, 
					@HPHONE, 
					@EMAIL, 
					@GENDER, 
					@BIRTH, 
					@SNS_TYPE, 
					@SNS_ID, 
					@CI, 
					@DI,
					GETDATE(),
					@SITE_CD,
					@HPCHECK,
					@JOIN_IP)
			
			SET @CUID = SCOPE_IDENTITY() 
			
			 -- 써브 비번 변경 호출 2016.09.07 jmg
			 --exec [221.143.23.211,8019].rserve.dbo.SV_PWD_SYNC @CUID, @PWD
			
			IF @HPCHECK = 'Y'
			BEGIN
				UPDATE CST_MASTER 
				SET REALHP_YN = 'N'
				WHERE CUID <> @CUID AND HPHONE = @HPHONE AND MEMBER_CD = '1' AND @HPHONE > ''
			END
			
			IF  @SNS_ID <> '' AND (@SNS_TYPE = 'K' OR @SNS_TYPE = 'N' OR @SNS_TYPE = 'F' OR @SNS_TYPE = 'A' )
			BEGIN
				UPDATE CST_MASTER
				SET USERID = @CUID
				WHERE CUID = @CUID
			END

			-- 이력을 남기자...
			INSERT INTO CST_JOIN_INFO (CUID, USERID, JOIN_DOMAIN, JOIN_OBJECT, SECTION_CD)
			VALUES (@CUID, @USERID, @JOIN_DOMAIN, @JOIN_OBJECT, @SECTION_CD)	
			
			SELECT @CUID
		END
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_PERSON_JOIN_BAK01]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MASTER_PERSON_JOIN_BAK01]
/*************************************************************************************
 *  단위 업무 명 : 개인 회원 가입 및 이력
 *  작   성   자 : 최승범
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
 -- 개인 정보
@USERID  varchar(50),
@PWD  VARCHAR(30),
@ADULT_YN  char(1),
@MEMBER_CD  char(1),
@USER_NM  varchar(30) ,
@HPHONE  varchar(14),
@EMAIL  varchar(50),
@GENDER  char(1),
@BIRTH  varchar(8),
@SNS_TYPE  char(1),
@SNS_ID  varchar(25),
@DI  char(64),
@CI  char(88),
--이력 정보
@JOIN_PATH varchar(50),
@JOIN_DOMAIN varchar(50),
@JOIN_OBJECT INT ,
@CUID int = 0 output

AS
	SET NOCOUNT ON;
	--DECLARE @CUID INT
		
		SELECT @CUID = MAX(CUID) + 1 FROM CST_MASTER
		BEGIN

			INSERT INTO CST_MASTER (CUID , 
									USERID,  
									USER_NM, 
									BAD_YN, 
									JOIN_DT,   
									MOD_DT,    
									MOD_ID , 
									PWD , 
									MEMBER_CD,  
									REST_YN, 
									OUT_YN, 
									ADULT_YN, 
									HPHONE, 
									EMAIL, 
									GENDER, 
									BIRTH, 
									SNS_TYPE, 
									SNS_ID , 
									CI, 
									DI)
			VALUES (@CUID, 
					@USERID, 
					@USER_NM, 
					'N',   
					GETDATE(), 
					GETDATE(), 
					@USERID, 
					DBO.FN_MD5(LOWER(@PWD)), 
					@MEMBER_CD ,  
					'N' ,   
					'N', 
					@ADULT_YN, 
					@HPHONE, 
					@EMAIL, 
					@GENDER, 
					@BIRTH, 
					@SNS_TYPE, 
					@SNS_ID, 
					@CI, 
					@DI)

			-- 이력을 남기자...
			INSERT INTO CST_JOIN_INFO (CUID, USERID, JOIN_PATH, JOIN_DOMAIN, JOIN_OBJECT)
			VALUES (@CUID, @USERID, @JOIN_PATH, @JOIN_DOMAIN, @JOIN_OBJECT)					   
		END

	     SELECT @CUID
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_SELECT]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 개인/비즈니스 회원 정보
 *  작   성   자 : JMG
 *  작   성   일 : 2016-08-17
 *  수   정   자 : BJY
 *  수   정   일 : 2021-09-02
 *  설        명 : 2021-09-02 -> 이용동의 여부 확인을 위한 서브쿼리 추가
 EXEC SP_MASTER_SELECT '13310360'
 exec sp_master_select 13825469 
exec mwmember.dbo.sp_master_select 13818837
exec MWMEMBER.DBO.SP_MASTER_SELECT 13822885

 *************************************************************************************/

CREATE PROCEDURE [dbo].[SP_MASTER_SELECT]

 @CUID  int

AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON;
	DECLARE @MEMBER_CD CHAR
	DECLARE @CNT INT
	
	SET @MEMBER_CD = ''
	SET @CNT = 0
	
	SELECT @MEMBER_CD = MEMBER_CD
	FROM MWMEMBER.DBO.CST_MASTER WITH (NOLOCK)
	WHERE CUID = @CUID AND OUT_YN = 'N'
	   
     create table #tb (cuid int null, s varchar(100) null, m varchar(100) null, t varchar(100) null, AGREE_DT datetime)
     insert into #tb
     SELECT CUID
     ,MAX(CASE WHEN MEDIA_CD = 'S' THEN SECTION_CD ELSE '' END )  AS 'S'
     ,MAX(CASE WHEN MEDIA_CD = 'M' THEN SECTION_CD ELSE '' END )  AS 'M'
     ,MAX(CASE WHEN MEDIA_CD = 'T' THEN SECTION_CD ELSE '' END )  AS 'T'
	 ,MAX(AGREE_DT) AGREE_DT
     FROM (
	    SELECT DISTINCT T.CUID,T.MEDIA_CD,
		   STUFF(( SELECT ',' + P.SECTION_CD
		   FROM MWMEMBER.DBO.CST_MSG_SECTION P WITH(NOLOCK)
		   WHERE (P.CUID = T.CUID AND P.MEDIA_CD = T.MEDIA_CD)
		   FOR XML PATH ('')),1,1,'') AS SECTION_CD
		   , AGREE_DT
	    FROM MWMEMBER.DBO.CST_MSG_SECTION T WITH(NOLOCK)
	    JOIN MWMEMBER.DBO.CST_MASTER CM WITH(NOLOCK) ON CM.CUID = T.CUID
	    WHERE CM.CUID = @CUID
     ) S 
     GROUP BY CUID 

	IF @MEMBER_CD = '1'
	BEGIN
	    SELECT CM.CUID, COM_ID, USERID, MEMBER_CD, USER_NM, HPHONE, EMAIL, GENDER, BIRTH, DI, CI, COM_ID
	    , ISNULL(S,'') SMS, ISNULL(M,'') MAIL, ISNULL(T,'') TM
	    , SNS_TYPE, SNS_ID
	    , case when CM.REALHP_YN ='Y' then 'Y'
		  when (SELECT COUNT(*) FROM CST_MASTER AS B WITH (NOLOCK) WHERE B.HPHONE = CM.HPHONE AND B.MEMBER_CD='1')  = 1  then 'Y' else 'N' end as REALHP_YN, '' MEMBER_TYPE
		, t.AGREE_DT
        , NULL AS SECTION_CD_ETC
        , M.AGREE_DT AS MK_AGREE_DT
        , ISNULL(M.AGREEF,0) AS MK_AGREEF
	    , CM.SITE_CD
        , CASE ISNULL(CM.CI,'') WHEN '' THEN 0
                                    ELSE 1
                                    END AS CI_F
		, (SELECT COUNT(*) FROM MWMEMBER.DBO.CST_SERVICE_USE_AGREE AS AG WITH(NOLOCK) WHERE AG.CUID = @CUID) AS SECTION_AGREE -- 이용동의 여부 2021-09-02
	    FROM MWMEMBER.DBO.CST_MASTER CM WITH (NOLOCK)
	    LEFT OUTER JOIN #tb t with(nolock) on t.cuid = CM.CUID
        LEFT OUTER JOIN MWMEMBER.DBO.CST_MARKETING_AGREEF_TB AS M ON M.CUID = CM.CUID
	    WHERE CM.CUID = @CUID AND CM.OUT_YN = 'N' AND CM.MEMBER_CD = '1'
	    
	END
	
	IF @MEMBER_CD = '2'
	BEGIN
	    SELECT CM.CUID, CM.COM_ID, CM.USERID, MEMBER_CD, USER_NM, HPHONE, EMAIL, GENDER, BIRTH, DI, CI, CM.COM_ID
	    , CC.REGISTER_NO, CC.MAIN_PHONE, CC.PHONE, CC.COM_NM, CC.CEO_NM, CC.FAX, CC.HOMEPAGE, CC.LAT, CC.LNG, CC.CITY, CC.GU, CC.DONG, CC.ADDR1, CC.ADDR2, CC.LAW_DONGNO, CC.MAN_NO, CC.ROAD_ADDR_DETAIL
	    , ISNULL(CL.REG_NUMBER,'') REG_NUMBER, ISNULL(CA.MANAGER_NM,'') MANAGER_NM, ISNULL(CA.MANAGER_NUMBER,'') MANAGER_NUMBER, CM.SNS_TYPE, CM.SNS_ID
	    , ISNULL(S,'') SMS, ISNULL(M,'') MAIL, ISNULL(T,'') TM
	    , '' as REALHP_YN, CC.MEMBER_TYPE
		, t.AGREE_DT
    , CC.SECTION_CD_ETC
    , M.AGREE_DT AS MK_AGREE_DT
    , ISNULL(M.AGREEF,0) AS MK_AGREEF
	  , CM.SITE_CD
    , CASE ISNULL(CM.CI,'') WHEN '' THEN 0
                                    ELSE 1
                                    END AS CI_F
		, (SELECT COUNT(*) FROM CST_SERVICE_USE_AGREE AS AG WITH(NOLOCK) WHERE AG.CUID = @CUID) AS SECTION_AGREE -- 이용동의 여부 2021-09-02
	    FROM MWMEMBER.DBO.CST_MASTER CM WITH(NOLOCK)
	    LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY CC WITH(NOLOCK) ON CC.COM_ID = CM.COM_ID
	    LEFT OUTER JOIN #tb t with(nolock) on t.cuid = CM.CUID
	    LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY_LAND CL WITH(NOLOCK) ON CL.COM_ID = CM.COM_ID
	    LEFT OUTER JOIN MWMEMBER.DBO.CST_COMPANY_AUTO CA WITH(NOLOCK) ON CA.COM_ID = CM.COM_ID	    
        LEFT OUTER JOIN MWMEMBER.DBO.CST_MARKETING_AGREEF_TB AS M ON M.CUID = CM.CUID
	    WHERE CM.CUID = @CUID AND CM.OUT_YN = 'N' AND CM.MEMBER_CD = '2'
	END	
GO
/****** Object:  StoredProcedure [dbo].[SP_MASTER_UPDATE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_MASTER_UPDATE]
/*************************************************************************************
 *  단위 업무 명 : 개인 정보 수정
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 개인 정보 수정시 이력 및 업데이트를 친다.
 *  RETURN(0) -- 성공
 * RETURN(500)  -- 실패
 * DECLARE @RET INT
 * EXEC @RET=SP_MASTER_UPDATE '11876008' , 'ju990728' , '주해선1' , '110-3027-3315', '10027042'  
 * SELECT @RET
 *************************************************************************************/
@CUID INT,
@USERID varchar(50),
@NEWUSER_NM varchar(30),
@NEWHPHONE varchar(14),
@NEWEMAIL varchar(50),
@NEWCOM_ID int,
@HPCHECK char(1)
AS	
	DECLARE @ID_COUNT bit,  @USER_NM varchar(30) , @COM_ID int , @HPHONE varchar(14)
	
	SET @ID_COUNT = 0
	SELECT @ID_COUNT = COUNT(USERID) FROM CST_MASTER WITH(NOLOCK) WHERE CUID = @CUID --AND USERID = @USERID
	
	SELECT @USERID = USERID
	  FROM CST_MASTER
	 WHERE CUID = @CUID
	
	IF @ID_COUNT = 1
	BEGIN
		UPDATE CST_MASTER SET MOD_DT = getdate() , 
							MOD_ID = @USERID , 
--							COM_ID = @NEWCOM_ID ,
							USER_NM = @NEWUSER_NM , 
							HPHONE = @NEWHPHONE,
							EMAIL = @NEWEMAIL,
							REALHP_YN = @HPCHECK
							WHERE CUID = @CUID
							
		IF @HPCHECK = 'Y'
		BEGIN
			UPDATE CST_MASTER
			SET REALHP_YN = 'N'
			WHERE CUID <> @CUID AND HPHONE = @NEWHPHONE AND MEMBER_CD = '1'
		END

		INSERT INTO CST_MASTER_HISTORY (CUID,   MOD_ID,  MOD_DT,   HPHONE ,  COM_ID, USER_NM, PWD_CHANGE_YN) VALUES 
									   (@CUID  ,@USERID, getdate(),@HPHONE, @COM_ID, @USER_NM, 'N')
			RETURN(0)
	END
	ELSE 
	BEGIN
		RETURN(500)
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_MD5]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_MD5]
/*************************************************************************************
 *  단위 업무 명 : 승인 이력 및 관리자 전달
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : @S_CUID , @C_CUID 구분값 " ,  "
 *************************************************************************************/
@CUID INT,
@PWD VARCHAR(25)
AS 
	SET NOCOUNT ON;
	DECLARE @SELECTPWD varbinary(128), 
			@MD5PWD varbinary(128)

	SET @MD5PWD = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD)))
	PRINT(@MD5PWD)

	SELECT @SELECTPWD = pwd_sha2 FROM CST_MASTER WHERE CUID = @CUID 

	IF @SELECTPWD = @MD5PWD
	BEGIN
		PRINT(@SELECTPWD)	
		PRINT(@MD5PWD)
	SELECT '맞아'
	END ELSE
	BEGIN 
	
	PRINT(@SELECTPWD)	
	PRINT(@MD5PWD)
	
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_MEM_UPDATE]    Script Date: 2021-11-04 오전 11:00:45 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_MEMBER_CHANGE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****************************************************************************************************
*객체이름 : 회원 이동 
*파라미터 : 	
*제작자 : KJH
*버젼 :
*제작일 : 2016.08.30
*변경일 :
*그외 : 
*실행예제 : exec dbo.SP_MEMBER_CHANGE 11111,22222,''
****************************************************************************************************/

CREATE PROC [dbo].[SP_MEMBER_CHANGE]
	@AS_CUID	int
,	@TO_CUID	int
,	@IP			varchar(20)
AS
	SET nocount ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	--히스토리 남김
	
	insert into MWMEMBER.dbo.MEMBER_CHANGE_HIST (AS_CUID,TO_CUID,IP,regdate) values (@AS_CUID,@TO_CUID,@IP,GETDATE())
	


	--1. cont
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].cont.dbo.Contract A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE B.CUID=@AS_CUID

	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].cont.dbo.Contract_payment A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].cont.dbo.tbl_promo_history A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].cont.dbo.vest_staff_hist A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID

	--2. rserve
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.agency_calendar A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.agency_info A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
		
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_board A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_countVisitor A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_countVisitor_history A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
					
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_etc A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_log_daily A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_manage_link A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_mapxy_hist A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_menu A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_notice A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_popup A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_startpage A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
					
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.homepage_svcMenu A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
		
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.iso_member_mail A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.manageLinkData A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_addr A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_branch A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_employee A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_memo A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_message A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
		
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_mobile_apikey A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_newbrn_Active A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_newbrn_Active A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_person A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_staff A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_url A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_photo A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].rserve.dbo.member_terms A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
					
	
	--3. good
	
	
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_Bestgood A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_branchgoodcnt A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
		
	UPDATE A SET goodreg_id=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_checkgood A JOIN mwmember.dbo.cst_master B On A.goodreg_id = B.CUID WHERE CUID=@AS_CUID
		
	UPDATE A SET goodreg_id=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_good A JOIN mwmember.dbo.cst_master B On A.goodreg_id = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_good_cont A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_good_jehu_notin A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.TBL_MEMTYPE A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET goodReg_id=@TO_CUID FROM  [221.143.23.211,8019].good.dbo.tbl_scrap_complex A JOIN mwmember.dbo.cst_master B On A.goodReg_id = B.CUID WHERE CUID=@AS_CUID
			

	--4. iso_member

	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].iso_member.dbo.iso_history A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].iso_member.dbo.member A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].iso_member.dbo.member_branch A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].iso_member.dbo.member_employee A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
						

	--5. naver
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_chkmaemul_ngood A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_fax_contract A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_fax_hist A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_faxfail_sms A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
				
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_ngood A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_ngood_clean_info A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_ngood_variation_hist A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].naver.dbo.tbl_promo_paydate A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID
			
	
	
	--6. banner
		
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].banner.dbo.BranchBanner_confirm A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID		
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].banner.dbo.BranchBanner A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID		
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].banner.dbo.bannerInfo A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID		
	
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].banner.dbo.advertiserInfo A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID	
	
	
	--7. chk
		
	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].chk.dbo.member_email A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID	
	
	--8. db_Serve
		
	UPDATE A SET goodreg_id=@TO_CUID FROM  [221.143.23.211,8019].db_serve.dbo.tbl_scrap_complex A JOIN mwmember.dbo.cst_master B On A.goodreg_id = B.CUID WHERE CUID=@AS_CUID	
	
	--9. sendbill	

	UPDATE A SET mem_seq=@TO_CUID FROM  [221.143.23.211,8019].sendbill.dbo.TaxRequest A JOIN mwmember.dbo.cst_master B On A.mem_seq = B.CUID WHERE CUID=@AS_CUID	

GO
/****** Object:  StoredProcedure [dbo].[SP_MSG_SECTION]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 마케팅/이벤트 수신동의
 *  작   성   자 : JMG
 *  작   성   일 : 2016-11-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
exec dbo.SP_MSG_SECTION 13821488, 2
exec dbo.SP_MSG_SECTION 13822240, 2
exec dbo.SP_MSG_SECTION 13822218

exec dbo.SP_MSG_SECTION 13957850,2
 *************************************************************************************/

CREATE PROCEDURE [dbo].[SP_MSG_SECTION]
 @CUID	  int,
 @S_TYPE	  int

AS
    SET NOCOUNT ON;

    if @S_TYPE = 1 begin	   --회원가입시
    
	   SELECT CUID
	   , MAX(CASE WHEN MEDIA_CD = 'S' THEN SECTION_CD ELSE '' END )  AS 'S'
	   , MAX(CASE WHEN MEDIA_CD = 'M' THEN SECTION_CD ELSE '' END )  AS 'M'
	   , MAX(CASE WHEN MEDIA_CD = 'T' THEN SECTION_CD ELSE '' END )  AS 'T'
	   --, ('S101,H001') AS 'S'
	   --, ('S103,S104,H001') AS 'M'
	   --, ('S101,H001') AS 'T'
	   , (SELECT TOP 1 READINGFLAG FROM FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB WITH (NOLOCK) WHERE CUID=CUID ORDER BY REGDATE DESC ) AS 'F'
	   --, '1' AS 'F'
	   , (SELECT TOP 1 AGREE_DT FROM CST_MSG_SECTION WITH (NOLOCK) WHERE CUID = S.CUID ORDER BY AGREE_DT DESC ) AGREE_DT
	   FROM (
		  SELECT DISTINCT T.CUID,T.MEDIA_CD,
		  STUFF(( SELECT ',' + P.SECTION_CD
		  FROM CST_MSG_SECTION P WITH(NOLOCK)
		  WHERE (P.CUID = T.CUID AND P.MEDIA_CD = T.MEDIA_CD)
		  FOR XML PATH ('')),1,1,'') AS SECTION_CD
		  , T.AGREE_DT
		  FROM CST_MSG_SECTION T WITH(NOLOCK)
		  JOIN CST_MASTER CM WITH(NOLOCK) ON CM.CUID = T.CUID
		  WHERE CM.CUID = @CUID
	   ) S 
	   GROUP BY CUID
	   
    end 
    
    if @S_TYPE = 2 begin		  --회원수정시
	   DECLARE @HISTORY_CD INT
	   SET     @HISTORY_CD = 0
    
	   CREATE TABLE #TB (HISTORY_ID INT NULL, OLD_ID INT NULL)
	   INSERT INTO #TB
	   SELECT TOP 1 HISTORY_ID, HISTORY_ID-1 AS OLD_ID
	   FROM CST_MSG_SECTION_HIST
	   WHERE CUID = @CUID
	   GROUP BY HISTORY_ID
	   ORDER BY HISTORY_ID DESC 
	   
	   SELECT TOP 1 @HISTORY_CD = ISNULL(SECTION_CD,1) 
	   FROM (
		  SELECT MH.SECTION_CD
		  FROM #TB T
		  LEFT OUTER JOIN CST_MSG_SECTION_HIST SH ON SH.HISTORY_ID = T.OLD_ID
		  LEFT OUTER JOIN CST_MSG_SECTION_HIST MH ON MH.HISTORY_ID = T.HISTORY_ID AND MH.SECTION_CD = SH.SECTION_CD AND MH.MEDIA_CD = SH.MEDIA_CD AND MH.AGREE_DT = SH.AGREE_DT
		  WHERE MH.SECTION_CD IS NULL
    	   
		  UNION ALL
    	   
		  SELECT MH.SECTION_CD
		  FROM #TB T
		  LEFT OUTER JOIN CST_MSG_SECTION_HIST SH ON SH.HISTORY_ID = T.HISTORY_ID
		  LEFT OUTER JOIN CST_MSG_SECTION_HIST MH ON MH.HISTORY_ID = T.OLD_ID AND MH.SECTION_CD = SH.SECTION_CD AND MH.MEDIA_CD = SH.MEDIA_CD AND SH.AGREE_DT = MH.AGREE_DT
		  WHERE MH.SECTION_CD IS NULL  
	   )A
	   OPTION(MAXDOP 1)
	   SELECT CUID
	   , MAX(CASE WHEN MEDIA_CD = 'S' THEN SECTION_CD ELSE '' END )  AS 'S'
	   , MAX(CASE WHEN MEDIA_CD = 'M' THEN SECTION_CD ELSE '' END )  AS 'M'
	   , MAX(CASE WHEN MEDIA_CD = 'T' THEN SECTION_CD ELSE '' END )  AS 'T'
	   --, ('S101,H001') AS 'S'
	   --, ('S103,S104,H001') AS 'M'
	   --, ('S101,H001') AS 'T'
	   , (SELECT TOP 1 READINGFLAG FROM FINDDB1.PAPER_NEW.DBO.PP_USER_EPAPERMAIL_TB WITH (NOLOCK) WHERE CUID=CUID ORDER BY REGDATE DESC ) AS 'F'
	   --, '1' AS 'F'
	   , (SELECT TOP 1 HISTORY_DT FROM CST_MSG_SECTION_HIST WITH (NOLOCK) WHERE CUID = S.CUID ORDER BY HISTORY_DT DESC ) AGREE_DT
	   , @HISTORY_CD HISTORY_CD
	   FROM (
		  SELECT DISTINCT T.CUID,T.MEDIA_CD,
		  STUFF(( SELECT ',' + P.SECTION_CD
		  FROM CST_MSG_SECTION P WITH(NOLOCK)
		  WHERE (P.CUID = T.CUID AND P.MEDIA_CD = T.MEDIA_CD)
		  FOR XML PATH ('')),1,1,'') AS SECTION_CD
		  , T.AGREE_DT
		  FROM CST_MSG_SECTION T WITH(NOLOCK)
		  JOIN CST_MASTER CM WITH(NOLOCK) ON CM.CUID = T.CUID
		  WHERE CM.CUID = @CUID
	   ) S 
	   GROUP BY CUID
	   
	   drop table #TB
    end 
    
    



GO
/****** Object:  StoredProcedure [dbo].[SP_MSG_SECTION_AD]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_MSG_SECTION_AD]
/*************************************************************************************
 *  단위 업무 명 : 마케팅ㆍ이벤트 수신 동의
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :  구분은 필히 , 로 한다.
 *************************************************************************************/
@CUID INT,
@SMS CHAR(1),
@S_SECTION VARCHAR(50),
@EMAIL CHAR(1),  
@M_SECTION VARCHAR(50),  
@TM CHAR(1),  
@T_SECTION VARCHAR(50)
AS 


--미수신 섹션 삭제
  DELETE CST_MSG_SECTION
	--SELECT *
	  FROM CST_MSG_SECTION AS A
	  LEFT JOIN 
	  (
	  SELECT CUID,  SECTION_CD, MEDIA_CD, AGREE_DT FROM  -- 저장
	    (SELECT @CUID AS CUID ,rtrim(LTRIM(VALUE)) AS SECTION_CD, @SMS AS MEDIA_CD, GETDATE() AS AGREE_DT FROM dbo.FN_STRING_TO_TABLE(@S_SECTION,',')
		    UNION ALL  -- SMS 
	    SELECT @CUID AS CUID , rtrim(LTRIM(VALUE)) AS SECTION_CD, @EMAIL AS MEDIA_CD, GETDATE() AS AGREE_DT FROM dbo.FN_STRING_TO_TABLE(@M_SECTION,',')
		    UNION ALL -- MAIL	
	    SELECT @CUID AS CUID , rtrim(LTRIM(VALUE)) AS SECTION_CD, @TM AS MEDIA_CD, GETDATE() AS AGREE_DT FROM dbo.FN_STRING_TO_TABLE(@T_SECTION,',')
		    --TM
	    ) AS AA WHERE AA.MEDIA_CD IS NOT NULL AND AA.SECTION_CD IS NOT NULL AND AA.MEDIA_CD != '' AND AA.SECTION_CD !=''
	  ) AS B ON A.CUID = B.CUID AND A.SECTION_CD = B.SECTION_CD AND A.MEDIA_CD = B.MEDIA_CD
	WHERE A.CUID = @CUID AND B.CUID IS NULL

--신규 수신 섹션 추가
  INSERT INTO CST_MSG_SECTION (CUID,  SECTION_CD, MEDIA_CD, AGREE_DT)
	SELECT A.CUID, A.SECTION_CD, A.MEDIA_CD, A.AGREE_DT
	  FROM 
	  (
	  SELECT CUID,  SECTION_CD, MEDIA_CD, AGREE_DT FROM  -- 저장
	   (SELECT @CUID AS CUID ,rtrim(LTRIM(VALUE)) AS SECTION_CD, @SMS AS MEDIA_CD, GETDATE() AS AGREE_DT FROM dbo.FN_STRING_TO_TABLE(@S_SECTION,',')
		    UNION ALL  -- SMS 
	    SELECT @CUID AS CUID , rtrim(LTRIM(VALUE)) AS SECTION_CD, @EMAIL AS MEDIA_CD, GETDATE() AS AGREE_DT FROM dbo.FN_STRING_TO_TABLE(@M_SECTION,',')
		    UNION ALL -- MAIL	
	    SELECT @CUID AS CUID , rtrim(LTRIM(VALUE)) AS SECTION_CD, @TM AS MEDIA_CD, GETDATE() AS AGREE_DT FROM dbo.FN_STRING_TO_TABLE(@T_SECTION,',')
		    --TM
	    ) AS AA WHERE AA.MEDIA_CD IS NOT NULL AND AA.SECTION_CD IS NOT NULL AND AA.MEDIA_CD != '' AND AA.SECTION_CD !=''
	  ) AS A
	  LEFT JOIN CST_MSG_SECTION AS B WITH(NOLOCK) ON A.CUID = B.CUID AND A.SECTION_CD = B.SECTION_CD AND A.MEDIA_CD = B.MEDIA_CD
	WHERE A.CUID = @CUID AND B.CUID IS NULL

-- 섹션 히스토리
  INSERT INTO CST_MSG_SECTION_HIST (CUID,  SECTION_CD, MEDIA_CD, AGREE_DT, HISTORY_DT, HISTORY_ID)
	SELECT CUID, SECTION_CD, MEDIA_CD, AGREE_DT, GETDATE(), ISNULL(A.HISTORY_ID,0) +1
	  FROM CST_MSG_SECTION MS 
	   outer apply
		  ( 
			 select top 1 HISTORY_ID from CST_MSG_SECTION_HIST 
			 where CUID = MS.CUID
			 order by HISTORY_DT desc
		  ) A 
	WHERE CUID = @CUID 
/*
EXEC SP_MSG_SECTION_AD_CBC  10748927 , 'S' , 'S101' , 'M', 'S102,S103,S104,S105', 'T', 'H001,S101'

*/
GO
/****** Object:  StoredProcedure [dbo].[SP_OUT_MASTER]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_OUT_MASTER]
/*************************************************************************************
 *  단위 업무 명 : 회원 탈퇴 상태 만들기 - 회원 신청용
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 * RETURN(0) 성공
 * RETURN(500)  실패
 * DECLARE @RET INT
 * EXEC @RET=SP_OUT_MASTER  '14052056' , 'macmoc','e프라이버시 클린서비스 통한 요청','kkam1234'
 * SELECT @RET 


 
 select  * FROM CST_MASTER WITH(NOLOCK) where userid='macmoc'
 
 exec SP_OUT_MASTER  '14052056' , 'macmoc','e프라이버시 클린서비스 통한 요청','kkam1234'
 
 
 *************************************************************************************/
@CUID INT,
@USERID VARCHAR(50),
@OUT_CAUSE VARCHAR(1000),
@ADMINID   VARCHAR(50) = ''   --관리자 페이지 탈퇴 인자 추가(2016.09.08 최병찬 추가)
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT
	
	SELECT @ID_COUNT = COUNT(CUID) 
	  FROM CST_MASTER WITH(NOLOCK) 
	 WHERE CUID = @CUID AND USERID = @USERID
		
	IF @ID_COUNT = 1
	BEGIN
		INSERT INTO CST_OUT_MASTER  
		            (CUID,  OUT_APPLY_DT, OUT_CAUSE)
				 VALUES (@CUID, GETDATE(),   @OUT_CAUSE)	

		UPDATE CST_MASTER 
		   SET OUT_YN = 'Y' , OUT_DT = GETDATE()
		     , MOD_DT = CASE 
		                     WHEN @ADMINID <> '' THEN GETDATE()
		                     ELSE MOD_DT
		                END
		     , MOD_ID = CASE 
		                     WHEN @ADMINID <> '' THEN @ADMINID
		                     ELSE MOD_ID
		                END
	 	 WHERE CUID = @CUID AND USERID = @USERID

		DELETE DUPLICATE_USERID_TB WHERE CUID = @CUID --탈퇴시 중복관련 테이블 삭제
		
		RETURN(0)						
	END
	ELSE	
	BEGIN
		RETURN(500)	
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_PHONE_CHECK]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_PHONE_CHECK]
/*************************************************************************************
 *  단위 업무 명 : 중복 전화번호 체크
 *  작   성   자 : JMG
 *  작   성   일 : 2016-08-16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 전화번호 체크
 * RETURN(500)  -- 중복전화번호
 * RETURN(0)    --  중복 전화번호 없음
 exec mwmember.dbo.sp_phone_check '010-6393-0923'
 exec mwmember.dbo.sp_phone_check '010-8779-8662' 
  *************************************************************************************/
@hphone VARCHAR(25)
,@member_cd char(1) ='1'
AS 
	
	SELECT COUNT(HPHONE) phonechk 
	FROM CST_MASTER  WITH(NOLOCK)
	WHERE HPHONE = @hphone
	AND MEMBER_CD = @member_cd
	and @hphone <> ''
	and OUT_YN = 'N'
GO
/****** Object:  StoredProcedure [dbo].[SP_PWD_CHANGE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_PWD_CHANGE]
    /*************************************************************************************
     *  단위 업무 명 : 비밀번호 변경
     *  작   성   자 : J&J
     *  작   성   일 : 2016-07-25
     *  수   정   자 :
     *  수   정   일 :
     *  설        명 : 비밀번호 변경 및 180일 뒤에 수정일 변경 일자 업데이트
     * RETURN(0) 성공
     * RETURN(500)  실패
     * DECLARE @RET INT
     * EXEC @RET=SP_PWD_CHANGE 'nadu81@naver.com', 'a', 'aa', 11217636, '127.0.0.1'
     * SELECT @RET
     *************************************************************************************/
    @USERID varchar(50), 
    @NEWPWD VARCHAR(20),
    @OLDPWD VARCHAR(20),
    @CUID INT,
    @MOD_REG_IP VARCHAR(30) = NULL
AS
	SET NOCOUNT ON;
	DECLARE @MD5PWD_NEW varbinary(128), @MD5PWD_OLD varbinary(128), @ID_COUNT bit
		
	SET @MD5PWD_OLD = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@OLDPWD)))  -- 소문자 변경 및 MD5로 변경
	SET @MD5PWD_NEW = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@NEWPWD)))  -- 소문자 변경 및 MD5로 변경

	SET @ID_COUNT = 0
	SELECT @ID_COUNT = COUNT(CUID) FROM CST_MASTER WITH(NOLOCK) 
	WHERE pwd_sha2 = @MD5PWD_OLD -- 관리자 체크	
	AND CUID = @CUID

	--PRINT(@ID_COUNT)
													
	IF @ID_COUNT = 1
	BEGIN
		UPDATE CST_MASTER
        SET pwd_sha2 = @MD5PWD_NEW , PWD_MOD_DT = getdate(), 
		PWD_NEXT_ALARM_DT = getdate() + 180,
		login_pwd_enc = NULL
		WHERE CUID = @CUID  -- 비밀 번호 업데이트 및 비번 수정 날짜 부동산 서브 비번 NULL 처리

        /* !! 운영반영시 운영(REAL)으로 변경 !!*/
        --. DEV
		--. EXEC [192.168.184.51,8019].rserve.dbo.SV_PWD_SYNC @CUID, @NEWPWD

        --. REAL > 써브 비번 변경 호출
		EXEC [221.143.23.211,8019].rserve.dbo.SV_PWD_SYNC @CUID, @NEWPWD

		/*2016-09-06 써브 체크용 임시 추후 삭제~!!*/			  
		--	INSERT CST_MASTER_LOGIN_SUCCESS (cuid,pwd,GBN ) 
		--	SELECT @CUID,@NEWPWD, 2 
			
        -- 이력을 남기자
		INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, PWD_CHANGE_YN, MOD_REG_IP)
        VALUES(@CUID, @USERID, GETDATE(), 'Y', @MOD_REG_IP)
        ;

        --. edit by 안대희 2021-09-29
        --. 로그인 history > login_status 2(비밀번호 변경)로 변경
        UPDATE CST_LOGIN_LOG
        SET login_status = 2
		WHERE CUID = @CUID
        ;

		RETURN(0)
	END ELSE
	BEGIN
		RETURN(500)
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_PWD_CHANGE_LATER]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 나중에 변경
 *  작   성   자 : J&J
 *  작   성   일 : 2016-08-22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 비밀번호 변경 및 180일 뒤에 수정일 변경 일자 업데이트
 * RETURN(0) 성공
 * RETURN(500)  실패
 * DECLARE @RET INT
 * EXEC @RET=SP_PWD_CHANGE 'nadu81@naver.com', 'a', 'aa', 11217636
 * SELECT @RET
 *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_PWD_CHANGE_LATER]
@CUID INT
,@DURATION INT  = 90
AS
	SET NOCOUNT ON;
	DECLARE @USERID Varchar(50)	
	UPDATE CST_MASTER 
	SET 
	PWD_NEXT_ALARM_DT = getdate() + @DURATION
	WHERE CUID = @CUID  -- 비밀 번호 업데이트 및 비번 수정 날짜 부동산 서브 비번 NULL 처리
	SELECT @USERID = USERID FROM CST_MASTER  WITH(NOLOCK) where CUID = @CUID 
	INSERT INTO CST_MASTER_HISTORY (CUID, MOD_ID, MOD_DT, PWD_CHANGE_YN) VALUES 
	(@CUID,@USERID, getdate(), 'N')  -- 이력을 남기자
	RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SP_PWD_CHECK]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 중복 비번 체크 체크
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-08-20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 아이디 체크
 * RETURN(500)  -- 중복아이디
 * RETURN(0)    --  중복 아이디 없음

  *************************************************************************************/
CREATE PROCEDURE [dbo].[SP_PWD_CHECK]
@CUID INT
,@PASS varchar(50)
AS 
	DECLARE @CNT INT
	SELECT @CNT = COUNT(USERID)  FROM CST_MASTER WITH(NOLOCK) WHERE CUID = @CUID
	and pwd_sha2 = master.DBO.fnGetStringToSha256(dbo.FN_MD5(LOWER(@PASS)))
	
	IF @CNT = 1 
		RETURN 1
	else
		RETURN 0
	
GO
/****** Object:  StoredProcedure [dbo].[SP_PWD_RESET]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_PWD_RESET]
/*************************************************************************************
 *  단위 업무 명 : 비밀번호 변경 - 관리자 화면에서 비밀번호 리셋 하기
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0) 성공
 * RETURN(500)  실패
 * DECLARE @RET INT
 * EXEC @RET=SP_PWD_RESET  'nadd','11217636'
 *
 *************************************************************************************/
@APP_USER varchar(50),
@CUID INT
AS
	SET NOCOUNT ON;
	DECLARE  @ID_COUNT bit
	
	SET @ID_COUNT = 0
	SELECT @ID_COUNT = COUNT(USERID) FROM CST_MASTER WITH(NOLOCK) WHERE CUID = @CUID

	IF @ID_COUNT = 1
	BEGIN
		UPDATE CST_MASTER SET 
		PWD_MOD_DT = getdate() 
		,PWD_NEXT_ALARM_DT = getdate() + 90
		,pwd_sha2= master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER('111111')))      -- 변경 되어야 할 값 넣어야 함(111111 으로 초기화 변경)
		WHERE CUID = @CUID
	
	INSERT INTO CST_MASTER_HISTORY (CUID,    MOD_ID,    MOD_DT,    PWD_CHANGE_YN) VALUES 
								   (@CUID,   @APP_USER, getdate(), 'Y')
		RETURN(0)
		
	END 
	ELSE
	BEGIN
		RETURN(500)
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_REST_MASTER]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REST_MASTER]
/*************************************************************************************
 *  단위 업무 명 : 회원 휴면 상태 만들기
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0)  -- 정상
 * RETURN(500)  -- 갯수가 없을 경우
 * DECLARE @RET INT
 * EXEC @RET=SP_REST_MASTER
 * SELECT @RET
 *************************************************************************************/
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT,  @LOG_ID INT, @ROWS INT;
		
   /* 01. 부동산 써브 예외 정책 */
   CREATE TABLE #NOT_EXSIST
	 ( 
	   mem_seq INT PRIMARY KEY,
	   svc_edate DATETIME NOT NULL
	  )

    INSERT into #NOT_EXSIST (mem_seq, svc_edate)
	       select A.mem_seq, min(A.svc_edate) 'svc_edate'
           from [221.143.23.211,8019].cont.dbo.contract A with(nolock)
          where A.svc_edate not in ('1900-01-01 00:00:00.000', '1913-07-04 00:00:00.000', '1999-12-31 00:00:00.000', '9999-12-31 00:00:00.000')
            -- and A.svc_edate > (GETDATE() - 365)
            AND A.STAT IN ('O','P')
       GROUP BY A.mem_seq
       ORDER BY 2 DESC

    /* 구인구직 예외 처리 */
	CREATE TABLE #TMP_REST (
      CUID INT PRIMARY KEY
     )

    CREATE TABLE #TMP_FINDALL_NOT_REST (
      CUID INT PRIMARY KEY
     )

	 INSERT INTO #TMP_REST (CUID)
     SELECT CUID  
       FROM CST_MASTER CS WITH(NOLOCK) 
      WHERE CS.REST_YN = 'N' 
        AND CS.OUT_YN = 'N' 
        AND (LAST_LOGIN_DT <= GETDATE() - 365 OR ( LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 ))

     INSERT INTO #TMP_FINDALL_NOT_REST (CUID)
     SELECT X.CUID
	   FROM (
           /* 구인구직 공고 기준 */
	         SELECT CUID, MAX(REG_DT) AS REG_DT
	           FROM [192.168.5.32].PAPER_NEW.DBO.PP_AD_TB WITH(NOLOCK)
	          WHERE CUID IN (SELECT CUID FROM #TMP_REST)           
	          GROUP BY CUID
			      UNION ALL
           /* 구인구직 정액권 기준*/
			     SELECT CUID, MAX(REG_DT) AS REG_DT
	           FROM [192.168.5.32].PAPER_NEW.DBO.CY_FAT_REGIST_TB WITH(NOLOCK)
	          WHERE CUID IN (SELECT CUID FROM #TMP_REST)           
	          GROUP BY CUID
			      UNION ALL
            /* 구인구직 이력서 열람권 기준*/
			     SELECT CUID, MAX(REG_DT) AS REG_DT
	           FROM [192.168.5.32].PAPER_NEW.DBO.PP_RESUME_READ_GOODS_REGIST_TB WITH(NOLOCK)
	          WHERE CUID IN (SELECT CUID FROM #TMP_REST)           
	          GROUP BY CUID
	        ) X
      WHERE X.REG_DT >= DATEADD(YEAR, -1, GETDATE()) 

		SELECT @ID_COUNT = COUNT(LAST_LOGIN_DT)  
		  FROM CST_MASTER CS WITH(NOLOCK) 
  	     WHERE CS.REST_YN = 'N' 
  	       AND CS.OUT_YN = 'N' 
	       AND (LAST_LOGIN_DT <= GETDATE() - 365 OR (LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 ))
           AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE CS.CUID = NE.mem_seq) -- 01. 부동산 써브 예외 정책
	       AND NOT EXISTS (SELECT FN.CUID FROM #TMP_FINDALL_NOT_REST FN WHERE CS.CUID = FN.CUID) -- 02. 구인 구직 예외정책 




		IF @ID_COUNT > 0
		BEGIN
		/*
			INSERT INTO CST_REST_MASTER (CUID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI,   ADD_DT )
								  SELECT CUID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI,   GETDATE() FROM 
										 CST_MASTER WITH(NOLOCK) WHERE LAST_LOGIN_DT <= GETDATE() - 365 
										 AND REST_YN = 'N' -- 마지막 접속 시간을 계산

		*/

			INSERT INTO CST_BATCH_LOG (BATCH_NM, BATCH_DETAIL, CONDITION) 
					VALUES ('CST_REST_MASTER', 
					'REST', 
					'REST_YN=N AND OUT_YN = N AND (LAST_LOGIN_DT <= GETDATE() - 365 OR (LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 ))');
			SET @LOG_ID = @@IDENTITY;


			MERGE  CST_REST_MASTER AS M 
			USING 
				(SELECT * FROM CST_MASTER CS WITH(NOLOCK) 
				  WHERE CS.REST_YN = 'N' 
				    AND CS.OUT_YN = 'N' 
					  AND (LAST_LOGIN_DT <= GETDATE() - 365 OR ( LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 ))
            AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE CS.CUID = NE.mem_seq)
				) AS C
			ON M.CUID = C.CUID
			WHEN MATCHED THEN 
				UPDATE SET M.USER_NM = C.USER_NM 
						  ,M.HPHONE = C.HPHONE
						  ,M.EMAIL = C.EMAIL
						  ,M.BIRTH = C.BIRTH
						  ,M.DI = C.DI
						  ,M.CI = C.CI
						  ,M.ADD_DT = GETDATE()
						  ,M.RESTORATION_DT = NULL   -- 휴면에서 풀린 상태에 값이 들어가 있으면 초기화
						  ,M.GENDER = C.GENDER
			WHEN NOT MATCHED THEN
				INSERT (CUID
				       ,USERID
				       ,SITE_CD
				       ,USER_NM
				       ,HPHONE
				       ,EMAIL
				       ,BIRTH
				       ,DI
				       ,CI
				       ,ADD_DT
					   ,GENDER
					   ) 
				VALUES 
				       (C.CUID
				       ,C.USERID
				       ,C.SITE_CD
				       ,C.USER_NM
				       ,C.HPHONE
				       ,C.EMAIL
				       ,C.BIRTH
				       ,C.DI
				       ,C.CI
				       ,GETDATE()
					   ,C.GENDER 
					   ) ;


		
			UPDATE CST_MASTER 
			  SET USER_NM = ''
			    , HPHONE = ''
			    , EMAIL = ''
			    , BIRTH = '' -- REPLACE(REPLACE(SUBSTRING(BIRTH,1,4),'-',''),' ','')
			    , DI = '' 
			    , CI = ''
			    , REST_YN = 'Y' 
			    , REST_DT = GETDATE()
				, GENDER = ''
		  WHERE REST_YN='N' AND OUT_YN = 'N' 
			 AND ( LAST_LOGIN_DT <= GETDATE() - 365 
				     OR (LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 )
				   )
       AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE CUID = NE.mem_seq)
	    -- 사용자 정보 업데이트
		  SET @ROWS = @@ROWCOUNT;
		  UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;			  
		
      -- 임시 테이블 삭제
      DROP TABLE #NOT_EXSIST
	  DROP TABLE #TMP_REST
      DROP TABLE #TMP_FINDALL_NOT_REST

      --대상 회원 메일 발송 데이터 입력
    	EXEC BAT_MM_REST_CONFIRM_PROC
    					  
			RETURN(0)
		END
		ELSE	
		BEGIN
			RETURN(500)
		END
GO
/****** Object:  StoredProcedure [dbo].[SP_REST_MASTER_RESTORATION]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REST_MASTER_RESTORATION]  
/*************************************************************************************
 *  단위 업무 명 : 회원 휴면에서 살리기
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0)  -- 정상 
 * RETURN(400)  -- MASTER 에 정보 없음
 * RETURN(500)  -- 휴면 테이블에 정보 없음
 * DECLARE @RET INT
 EXEC @RET=SP_REST_MASTER_RESTORATION 13707608
 * SELECT @RET
 *************************************************************************************/
@CUID INT 
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT ,
		    @ID_REST_COUNT BIT,
			@RE_CUID INT, 
			@RE_USER_NM VARCHAR(50), 
			@RE_HPHONE varchar(14), 
			@RE_EMAIL varchar(50), 
			@RE_BIRTH varchar(8), 
			@RE_DI char(64), 
			@RE_CI char(88),
			@RE_GENDER char(1)

		SELECT @ID_COUNT = COUNT(@CUID) FROM CST_MASTER WITH(NOLOCK) WHERE CUID = @CUID AND REST_YN = 'Y'
		SELECT @ID_REST_COUNT = COUNT(@CUID) FROM CST_REST_MASTER WITH(NOLOCK) WHERE CUID = @CUID  
		
		IF @ID_REST_COUNT = 1 
		BEGIN
			SELECT @RE_CUID = CUID , 
				   @RE_USER_NM = USER_NM, 
				   @RE_HPHONE =HPHONE, 
				   @RE_EMAIL = EMAIL, 
				   @RE_BIRTH = BIRTH, 
				   @RE_DI = DI, 
				   @RE_CI = CI,
				   @RE_GENDER = GENDER  
				   FROM CST_REST_MASTER WITH(NOLOCK) WHERE CUID = @CUID
			
			IF @ID_COUNT = 1
			BEGIN
			UPDATE CST_MASTER SET USER_NM = @RE_USER_NM, HPHONE = @RE_HPHONE, EMAIL = @RE_EMAIL,
							BIRTH = @RE_BIRTH, DI = @RE_DI ,CI = @RE_CI, REST_YN = 'N', 
							LAST_LOGIN_DT = GETDATE(),
							REST_DT = NULL, 
							GENDER = @RE_GENDER
							WHERE CUID = @CUID

			UPDATE CST_REST_MASTER SET RESTORATION_DT = GETDATE() WHERE CUID = @CUID
			RETURN(0)  -- 정상 
			END ELSE
			BEGIN
				RETURN(400)  -- MASTER 에 정보 없음
			END
		END ELSE
		BEGIN
			RETURN(500)  -- 휴면 테이블에 정보 없음
		END	
GO
/****** Object:  StoredProcedure [dbo].[SP_REST_OUT]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_REST_OUT]
/*************************************************************************************
 *  단위 업무 명 : 회원 탈퇴 상태 만들기 - 휴면 상태에서 탈퇴로
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 exec SP_REST_OUT
 *************************************************************************************/
AS 
	SET NOCOUNT ON;
	DECLARE @DOTIME VARCHAR(10), @LOG_ID INT, @ROWS INT
	SET @DOTIME = CONVERT(VARCHAR(10), GETDATE() - 365, 111)


    CREATE TABLE #NOT_EXSIST
	(mem_seq INT PRIMARY KEY, svc_edate DATETIME NOT NULL)

    INSERT into #NOT_EXSIST (mem_seq, svc_edate)
	     select A.mem_seq, min(A.svc_edate) 'svc_edate'
           from [221.143.23.211,8019].cont.dbo.contract A with(nolock)
          where A.svc_edate not in ('1900-01-01 00:00:00.000', '1913-07-04 00:00:00.000', '1999-12-31 00:00:00.000', '9999-12-31 00:00:00.000')
            -- and A.svc_edate > (GETDATE() - 365)
            AND A.STAT IN ('O','P')
       GROUP BY A.mem_seq
       ORDER BY 2 DESC


			INSERT INTO CST_BATCH_LOG 
			            (BATCH_NM, BATCH_DETAIL, CONDITION) 
					 VALUES ('CST_REST_OUT', 'OUT', 'ADD_DT < '+CAST(@DOTIME AS VARCHAR) ) ;
			SET @LOG_ID = @@IDENTITY;

			INSERT INTO CST_OUT_MASTER 
			              (
							 CUID
							,OUT_APPLY_DT
							,OUT_PROC_DT
							,OUT_CAUSE
						  )  -- 탈퇴 이력을 남긴다.
				SELECT 
							 CUID
							,GETDATE() AS OUT_APPLY_DT
							,GETDATE() AS OUT_PROC_DT
							,'장기미이용 고객 자동 탈퇴(로그인한지 2년)' AS OUT_CAUSE
				  FROM CST_REST_MASTER CS WITH(NOLOCK) 
				 WHERE CS.ADD_DT < @DOTIME
				   AND CS.RESTORATION_DT IS NULL -- 복구 하지 않아서 날짜가 없다.
				   AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE CS.CUID = NE.mem_seq)

			SET @ROWS = @@ROWCOUNT;
			UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;	

		
			INSERT INTO CST_BATCH_LOG 
			            (BATCH_NM, BATCH_DETAIL, CONDITION) 
					 VALUES ('CST_MASTER', 'OUT', 'OUT_YN = Y , OUT_DT = '+ CAST(GETDATE() AS VARCHAR));
			SET @LOG_ID = @@IDENTITY;
			
				UPDATE CST_MASTER 
				   SET OUT_YN = 'Y' , OUT_DT = GETDATE(), MOD_DT = GETDATE() 
				  FROM   -- 마스터 테이블에서 탈퇴 업데이트
							 CST_REST_MASTER RM 
					LEFT OUTER JOIN CST_MASTER M ON RM.CUID = M.CUID 
				 WHERE RM.ADD_DT < @DOTIME 
				   AND RM.RESTORATION_DT IS NULL
				   AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE RM.CUID = NE.mem_seq)
				   
			SET @ROWS = @@ROWCOUNT;
			UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;


			INSERT INTO CST_BATCH_LOG 
			            (BATCH_NM, BATCH_DETAIL, CONDITION) 
					 VALUES ('CST_REST_OUT', 'OUT', 'ADD_DT < '+CAST(@DOTIME AS VARCHAR) +' AND RESTORATION_DT IS NULL');
			SET @LOG_ID = @@IDENTITY;

			DELETE FROM CST_REST_MASTER
			 WHERE ADD_DT < @DOTIME  AND RESTORATION_DT IS NULL  -- 휴면 테이블에서 삭제
			   AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE CUID = NE.mem_seq)

			SET @ROWS = @@ROWCOUNT;
			UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;
 
            -- 임시 테이블 삭제
            DROP TABLE #NOT_EXSIST;
GO
/****** Object:  StoredProcedure [dbo].[SP_SERVE_ECOMM_PAYDATE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SERVE_ECOMM_PAYDATE]
/*************************************************************************************
 *  단위 업무 명 : 써브 이컴 정보 업데이트(스케줄)
 *  작   성   자 : KJH
 *  작   성   일 : 2016-09-01
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :

 *************************************************************************************/

AS 
	SET NOCOUNT ON;
	
	truncate table MWMEMBER.DBO.SERVE_ECOMM_PAYDATE
	
	insert into MWMEMBER.DBO.SERVE_ECOMM_PAYDATE
	select B.mem_seq,convert(datetime,left(max(B.pay_date),8)) as max_pay_date from 
	[221.143.23.211,8019].cont.dbo.contract A join
	[221.143.23.211,8019].cont.dbo.contract_payment B on A.cont_seq=B.cont_seq
	where B.STAT='100802' and B.pay_msg2<>'' 
	and A.stat='O'
	group by B.mem_seq
	
	
GO
/****** Object:  StoredProcedure [dbo].[SP_SERVICE_AGREE_BIZ_UPDATE]    Script Date: 2021-11-04 오전 11:00:45 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TEST]    Script Date: 2021-11-04 오전 11:00:45 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TEST_PWD]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_TEST_PWD]
/*************************************************************************************
 *  단위 업무 명 : 승인 이력 및 관리자 전달
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : @S_CUID , @C_CUID 구분값 " ,  "
 *************************************************************************************/
@USERID varchar(50)
AS 
	SET NOCOUNT ON;
	DECLARE @CUID INT
	SELECT @CUID = CUID FROM CST_MASTER WHERE USERID = @USERID
	RETURN(@CUID)
GO
/****** Object:  StoredProcedure [dbo].[SP_USERID_ADMIN_CHANGE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_USERID_ADMIN_CHANGE]
/*************************************************************************************
 *  단위 업무 명 : ID 변경
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 아이디 변경 및 비밀번호 변경
 *************************************************************************************/
@CUID INT,
@USERID VARCHAR(50),
@NEW_USERID VARCHAR(50),
@IP VARCHAR(20)
AS
	SET NOCOUNT ON;
	DECLARE @CKECK INT
  
	SELECT @CKECK = COUNT(CUID) FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @NEW_USERID

	IF @CKECK > 0
	BEGIN
		SELECT 2 AS RESULT
	END
	ELSE IF @CKECK = 0
	BEGIN
		IF EXISTS (SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE  CUID = @CUID )
		BEGIN	
			UPDATE CST_MASTER SET 
								USERID = @NEW_USERID 
								WHERE CUID = @CUID

			DELETE DUPLICATE_USERID_TB WHERE CUID = @CUID 
			EXEC FINDDB1.PAPER_NEW.DBO.USERID_CHANGE_ALL_PROC  @CUID, @USERID, @NEW_USERID, @IP
/*
ALTER PROCEDURE [dbo].[USERID_CHANGE_ALL_PROC]
  @CUID             INT
, @USERID           VARCHAR(50)       = ''      -- 기존아이디
, @RE_USERID        VARCHAR(50)       = ''      -- 변경아이디
, @CLIENT_IP      VARCHAR(20)       = ''
AS
*/
			-- USREID 변경 시 이력을 만들자..
			INSERT INTO CST_MASTER_HISTORY (CUID,   MOD_ID,  MOD_DT, NEW_USERID, PWD_CHANGE_YN) VALUES 
										   (@CUID  ,@USERID, getdate(),@NEW_USERID, 'N')
			SELECT 1 AS RESULT
		END
		ELSE
		BEGIN
			SELECT 2 AS RESULT
		END
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_USERID_CHANGE]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_USERID_CHANGE]
/*************************************************************************************
 *  단위 업무 명 : ID 변경
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 아이디 변경 및 비밀번호 변경
 *************************************************************************************/
@CUID INT,
@USERID VARCHAR(50),
@NEW_USERID VARCHAR(50),
@PWD VARCHAR(20)
AS
  SET NOCOUNT ON;

  IF EXISTS (SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE USERID = @USERID AND CUID = @CUID AND  
		pwd_sha2	  = master.DBO.fnGetStringToSha256(DBO.FN_MD5(LOWER(@PWD))))	
  BEGIN	
	  UPDATE CST_MASTER SET 
			   USERID = @NEW_USERID 
	  WHERE CUID = @CUID

    -- 중복ID 테이블에서 삭제
    DELETE
    -- SELECT *
      FROM DUPLICATE_USERID_TB
     WHERE CUID = @CUID
	INSERT INTO CST_MASTER_HISTORY (CUID,   MOD_ID,  MOD_DT, NEW_USERID, PWD_CHANGE_YN) VALUES 
									(@CUID  ,@USERID, getdate(),@NEW_USERID, 'N')
	  SELECT 1 AS RESULT
  END
  ELSE
  BEGIN
    SELECT 2 AS RESULT
  END
GO
/****** Object:  StoredProcedure [dbo].[sv_find_staff]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
--직원찾기
--@step=2, @step=3 튜닝함. junesang_cho20100604
*/
CREATE    procedure [dbo].[sv_find_staff]
	@step int=1,	--검색단계
	@c_id int=0	--상위부서코드
as
begin
	set nocount on

	if @step = 1
	begin
		--회사.
		SELECT DISTINCT 2 step, c.c1_id c_id, c.c1_name c_name 
		FROM [221.143.23.211,8019].intranet.dbo.sv_company c with (readuncommitted) 
		WHERE c.c1_level = 1 and (c.c1_id=1  or c.c1_id=141 or c.c1_id=190 or c.c1_id=203) order by c.c1_name --  or c.c1_id=40 부동산써브와 벼룩시장 만 나오도록 추가		
	end
	else if @step = 2
	begin
		--부서1
--		SELECT DISTINCT case when (SELECT count(*) from intranet.dbo.sv_company with (readuncommitted) WHERE c1_level = 1 and c3_id is not null and c2_id = c.c2_id)=0 then 9 else 3 end step,
		SELECT DISTINCT case when not exists(SELECT * from [221.143.23.211,8019].intranet.dbo.sv_company with (readuncommitted) WHERE c1_level = 1 and c3_id is not null and c2_id = c.c2_id) then 9 else 3 end step,
			c.c2_id c_id, c.c2_name c_name 
		FROM [221.143.23.211,8019].intranet.dbo.sv_company c with (readuncommitted) 
		WHERE c.c1_level = 1 and c.c1_id = @c_id order by c.c2_name
	end
	else if @step = 3
	begin
		--부서2
--		SELECT DISTINCT case when (SELECT count(*) from intranet.dbo.sv_company with (readuncommitted) WHERE c1_level = 1 and c4_id is not null and c3_id = c.c3_id)=0 then 9 else 4 end step,
		SELECT DISTINCT case when not exists(SELECT * from [221.143.23.211,8019].intranet.dbo.sv_company with (readuncommitted) WHERE c1_level = 1 and c4_id is not null and c3_id = c.c3_id) then 9 else 4 end step,
			c.c3_id c_id, c.c3_name c_name 
		FROM [221.143.23.211,8019].intranet.dbo.sv_company c with (readuncommitted) 
		WHERE c.c1_level = 1 and c.c2_id = @c_id order by c.c3_name
	end
	else if @step = 4
	begin
		--부서3
		--select distinct case when (select count(*) from intranet.dbo.sv_company where c1_level = 1 and c5_id is not null and c4_id = c.c4_id)=0 then 9 else 5 end step,
		SELECT DISTINCT 9 step,	--추후 하위단계가 추가된다면 이부분을 주석으로 돌리고 위 주석을 풉니다.
			c.c4_id c_id, c.c4_name c_name 
		FROM [221.143.23.211,8019].intranet.dbo.sv_company c with (readuncommitted) WHERE c.c1_level = 1 and c.c3_id = @c_id order by c.c4_name
	end
/*	--추후 하위단계가 추가된다면 옆의 주석을 풀어주십시오. 2005.11.18 Jonathan
	else if @step = 5
	begin
		--부서5
		select distinct 9 step, c.c4_id c_id, c.c4_name c_name 
		from intranet.dbo.sv_company c where c.c1_level = 1 and c.c4_id = @c_id order by c.c5_name
	end
*/
	else if @step = 9
	begin
		if @c_id>108 
		--부서내 직원
		SELECT staff_seq, name FROM [221.143.23.211,8019].intranet.dbo.login_member  with (readuncommitted) where c_id = @c_id and yn_client>0
		else
		SELECT staff_seq, name FROM [221.143.23.211,8019].intranet.dbo.login_member  with (readuncommitted) where c_id = @c_id and yn_client>0
		
	end
	else 
	begin
		--해당조건이 없을때
		print '해당조건으로 검색된 데이터가 없습니다.'
	end
end





GO
/****** Object:  StoredProcedure [dbo].[sv_rets_login_log]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 렛츠 로그인 로그
 *  작   성   자 : skh
 *  작   성   일 : 2016-09-21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 

 *************************************************************************************/
CREATE PROCEDURE [dbo].[sv_rets_login_log]
	@CUID			int = 0
,	@ip				VARCHAR(15) = ''
,	@referer		VARCHAR(100) = ''
,	@host			VARCHAR(100) = ''
,	@script_name	VARCHAR(200) = ''
,	@param			VARCHAR(1000) = ''
,	@islogin		char(1) = ''
AS
	SET NOCOUNT ON;

	insert into [221.143.23.211,8019].serveplus.dbo.rets_login_log (mem_seq, ip, referer, host, script_name, [param], islogin)
	values (@CUID, @ip, @referer, @host, @script_name, @param, @islogin)
GO
/****** Object:  StoredProcedure [dbo].[sv_rets_login_pwd_rdm]    Script Date: 2021-11-04 오전 11:00:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : 렛츠 패스워드 키 인증
 *  작   성   자 : skh
 *  작   성   일 : 2016-09-21
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 exec mwmember.dbo.sv_rets_login_pwd_rdm 13621996, '123456789abcdefghijklmnopqrstuvwxyz'
 *************************************************************************************/
CREATE PROCEDURE [dbo].[sv_rets_login_pwd_rdm]
	@CUID			int = 0
,	@login_pwd_rdm	VARCHAR(50) = ''
AS
	SET NOCOUNT ON;

	SELECT mem_seq as CUID
	from [221.143.23.211,8019].rserve.dbo.member_employee me with(nolock)
	where mem_seq = @cuid
	and login_pwd_rdm = @login_pwd_rdm
	and type = '100901'
--	and exists(select mem_seq from [221.143.23.211,8019].cont.dbo.contract c with(nolock) where c.mem_seq = me.mem_seq and c.stat = 'O' and (c.main_svc_code in (100004,100001,100038) or (c.svc_type = '101215' and sale_price - dc_price > 0)) and convert(varchar(10),getdate(),121) between convert(varchar(10),svc_sdate,121) and convert(varchar(10),svc_edate,121))

GO
