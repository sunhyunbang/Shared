USE [COMMON]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_FindPhone]    Script Date: 2021-11-04 오전 10:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[Fun_FindPhone]  (@Phone varchar (100))
RETURNS varchar(100)
AS
BEGIN

DECLARE @StrPhone int
DECLARE @StrPhone2 int
DECLARE @PhoneText varchar(100)
Set @StrPhone = 1
Set @StrPhone2 = 0
Set @PhoneText = ''

	WHILE  (@StrPhone <= Len(@Phone))

		IF (SUBSTRING(@Phone,@StrPhone,1) <> '0'

			AND SUBSTRING(@Phone,@StrPhone,1) <> '1'
			AND SUBSTRING(@Phone,@StrPhone,1) <> '2'
			AND SUBSTRING(@Phone,@StrPhone,1) <> '3'
			AND SUBSTRING(@Phone,@StrPhone,1) <> '4'
			AND SUBSTRING(@Phone,@StrPhone,1) <> '5'
			AND SUBSTRING(@Phone,@StrPhone,1) <> '6'
			AND SUBSTRING(@Phone,@StrPhone,1) <> '7'
			AND SUBSTRING(@Phone,@StrPhone,1) <> '8'
			AND SUBSTRING(@Phone,@StrPhone,1) <> '9'
			AND SUBSTRING(@Phone,@StrPhone,1) <> '-'
			AND SUBSTRING(@Phone,@StrPhone,1) <> ',')
	
		BEGIN
				SET	@PhoneText = '1'
				--SET @StrPhone = @StrPhone + 1
				BREAK
			END
		ELSE
			BEGIN
--				SET @PhoneText = @PhoneText + SUBSTRING(@Phone,@StrPhone,1)
				SET @PhoneText = '0'
				SET @StrPhone = @StrPhone + 1
			END

		RETURN(@PhoneText)
END
GO
/****** Object:  UserDefinedFunction [dbo].[FUNCTION_USERID_CHECK]    Script Date: 2021-11-04 오전 10:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FUNCTION_USERID_CHECK] (@USERID VARCHAR(100))
RETURNS VARCHAR(100)
AS
BEGIN 
   DECLARE @RETURNVALUS VARCHAR(255), @TEMVALUS01 VARCHAR(100), @TEMVALUS02 VARCHAR(100), 
	     @LENGTH INTEGER, @STARTVALUS INTEGER

   SET @TEMVALUS01 = UPPER(@USERID)
   SET @TEMVALUS02 = ''
   SET @STARTVALUS = 0
   SET @LENGTH = LEN(@TEMVALUS01)

   WHILE (@STARTVALUS < @LENGTH)
   BEGIN
         SET @STARTVALUS = @STARTVALUS + 1

         IF @STARTVALUS > @LENGTH BREAK

         SET @TEMVALUS02 = SUBSTRING(@TEMVALUS01, @STARTVALUS, 1)
         
         SET @RETURNVALUS = CASE WHEN ASCII(@TEMVALUS02) >= 65 AND ASCII(@TEMVALUS02) <= 90 
THEN '정상'
                   ELSE '비정상'
          END 

         IF (@RETURNVALUS = '비정상') 
         BEGIN
           --IF (@STARTVALUS <> 1)
               IF (ASCII(@TEMVALUS02) >= 48) AND (ASCII(@TEMVALUS02) <= 57)
               BEGIN
                  SET @RETURNVALUS = '정상'
                  CONTINUE
               END
              ELSE
                  BREAK
           -- ELSE
           --    BREAK
         END
   END
   
   RETURN (@RETURNVALUS)
END
GO
/****** Object:  UserDefinedFunction [dbo].[GET_MM_RIGHTEMAIL_FNC]    Script Date: 2021-11-04 오전 10:38:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
' 단 위 업 무 명	: 공통회원 > EMAIL 유효성 체크 함수
' 작    성    자	: 안 상 미 
' 작    성    일	: 2008/07/28
' 수    정    자	:
' 수    정    일	: 
' 설          명	: 				 
' 주  의  사  항	: 
' 사  용  소  스 	:  BAT_MM_SENDMAIL_REST_PROC
' 예          제	:  SELECT * FROM 테이블명 WHERE MEMBER.DBO.GET_MM_RIGHTEMAIL_FNC(MAIL필드명) = 'OK'
******************************************************************************/

 
CREATE FUNCTION [dbo].[GET_MM_RIGHTEMAIL_FNC](@STR VARCHAR(1000))
	 
	  RETURNS VARCHAR(5) 	AS

	  BEGIN
	  	DECLARE @DD VARCHAR(800)
		DECLARE @DD1 VARCHAR(10)
		DECLARE @SS VARCHAR(40)
		DECLARE @RR VARCHAR(5)
		DECLARE @I TINYINT

		--도메인 접미사들..
		SET @DD 
				= '#COM#ORG#NET#EDU#GOV#MIL#INT#AF#AL#DZ#AS#AD#AO#AI#AQ#AG#AR#AM#AW#AC#AU#AT#AZ#BS
				#BH#BD#BB#BY#BZ#BT#BJ#BE#BM#BO#BA#BW#BV#BR#IO#BN#BG#BF#BI#KH#CM#CA#CV#KY#CF#TD#CL#
				CN#CX#CC#CO#KM#CD#CG#CK#CR#CI#HR#CU#CY#CZ#DK#DJ#DM#DO#TP#EC#EG#SV#GQ#ER#EE#ET#FK
				#FO#FJ#FI#FR#GF#PF#TF#GA#GM#GE#DE#GH#GI#GR#GL#GD#GP#GU#GT#GG#GN#GW#GY#HT#HM#VA#HN
				#HK#HU#IS#IN#ID#IR#IQ#IE#IM#IL#IT#JM#JP#JE#JO#KZ#KE#KI#KP#KR#KW#KG#LA#LV#LB#LS#LR#LY#LI#LT#
				LU#MO#MK#MG#MW#MY#MV#ML#MT#MH#MQ#MR#MU#YT#MX#FM#MD#MC#MN#MS#MA#MZ#MM#NA#N
				R#NP#NL#AN#NC#NZ#NI#NE#NG#NU#NF#MP#NO#OM#PK#PW#PA#PG#PY#PE#PH#PN#PL#PT#PR#QA#RE#R
				O#RU#RW#KN#LC#VC#WS#SM#ST#SA#SN#SC#SL#SG#SK#SI#SB#SO#ZA#GS#ES#LK#SH#PM#SD#SR#SJ#S
				Z#SE#CH#SY#TW#TJ#TZ#TH#TG#TK#TO#TT#TN#TR#TM#TC#TV#UG#UA#AE#GB#US#UM#UY#UZ#VU#VE#VN
				#VG#VI#WF#EH#YE#YU#ZR#ZM#ZW#UK#PS#BIZ#INFO#NAME#MUSEUM#COOP#AERO#'
		
		--허용금지 문자들..
		SET @SS = '!#$%^&*()=+{} []|\;:''/?>,<'

		SET @RR = ''
		SET @I = 0
		SET @DD1 = ''
		SET @STR = LTRIM(RTRIM(@STR))

		--허용금지 문자 체크
		WHILE @I<LEN(@STR)		
			BEGIN
				SET @I = @I + 1
				IF CHARINDEX(SUBSTRING(@STR,@I,1),@SS)>0
					BEGIN
						SET @RR = 'ERR'
						BREAK
					END
				ELSE
					BEGIN
						SET @RR = 'OK'
						CONTINUE
					END
			END

		--도메인 접미사 체크
		IF @RR = 'OK'			
			Begin
				SET @DD1 = Ltrim(RIGHT(@STR,5))
				SET @DD1 = SubString(@DD1,CharIndex('.',@DD1)+1,Len(@DD1))
				IF CharIndex(@DD1,@DD)>0
					SET @RR = 'OK'
				ELSE
					SET @RR = 'ERR'
			End
		RETURN @RR
	  End
GO
