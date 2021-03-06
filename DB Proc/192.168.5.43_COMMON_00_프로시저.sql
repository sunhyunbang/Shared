USE [COMMON]
GO
/****** Object:  StoredProcedure [dbo].[_Common_FindIdPwd_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
	제목		:	회원 아이디, 패스워드 찾기 
	작성자	: 김경희	2003.07.07
*******************************************************************/
--drop PROCEDURE dbo.Common_FindIdPwd
CREATE PROCEDURE [dbo].[_Common_FindIdPwd_20191001]
	@UserName	varchar(30)
	,@JuminNo	varchar(15)
	,@UserType	char(1)		--[P:개인회원, B:기업회원]
AS
	IF @UserType = 'P'
	BEGIN
		SELECT UserID, UserName, PassWord, Email
		FROM Common.dbo.UserCommon 
		WHERE UserName=@UserName 
			AND JuminNo = @JuminNo 
			And UserGbn IN ('1', '3', '4') 
			And PartnerGbn = 0 
			And DelFlag = '0' 
	END
	ELSE
	BEGIN
		SELECT UserID, UserName, PassWord, Email
		FROM Common.dbo.UserCommon 
		WHERE UserName=@UserName
			AND JuminNo =@JuminNo
			And UserGbn = '2' 
			And PartnerGbn = 0 
			And DelFlag = '0' 
	END
GO
/****** Object:  StoredProcedure [dbo].[_Common_MemberFindId_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
	제목		:	회원 아이디, 패스워드 찾기 
	작성자	: 김경희	2003.07.07
	수정자 : 김준범  2003.11.11
*******************************************************************/
--drop PROCEDURE dbo.Common_MemberFindId
CREATE      PROCEDURE [dbo].[_Common_MemberFindId_20191001]
	 @JuminNo	varchar(15)
	,@UserType	char(1)		--[P:개인회원, B:기업회원]
AS

	IF @UserType = 'P'
	BEGIN
		SELECT UserID, UserName
		FROM Common.dbo.UserCommon with(nolock)
		WHERE JuminNo = @JuminNo 
			And UserGbn IN ('1', '3', '4') 
			And PartnerGbn = 0 
			And DelFlag = '0' 
	END
	ELSE
	BEGIN
		SELECT UserID, UserName
		FROM Common.dbo.UserCommon with(nolock)
		WHERE JuminNo =@JuminNo
			And UserGbn = '2' 
			And PartnerGbn = 0 
			And DelFlag = '0' 

	END
GO
/****** Object:  StoredProcedure [dbo].[_Common_MemberFindPwd_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
	제목		: 패스워드 찾기 
	작성자	: 김경희	2003.07.07
	수정자 : 김준범	2004.11.11
*******************************************************************/

CREATE        PROCEDURE [dbo].[_Common_MemberFindPwd_20191001]
 	@JuminNo	varchar(15)
AS

		SELECT Top 1 UserID, UserName,PassWord,Email
		FROM Common.dbo.UserCommon 
		WHERE JuminNo = @JuminNo 
			And PartnerGbn = 0 
			And DelFlag = '0'
GO
/****** Object:  StoredProcedure [dbo].[_Common_MemberInfoSelectId_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*******************************************************************
	제목		:	회원 아이디로 정보 가지고 오기, m25 회원 연동으로 만듦
	작성자	: 이수지	2007.06.11
*******************************************************************/
CREATE     PROCEDURE [dbo].[_Common_MemberInfoSelectId_20191001]
	@id		varchar(30)
AS
	SELECT UserID, juminno, Password, Email, Phone, HPhone, Post1, Post2, Address1, 
		Address2, RegDate, UserGbn, BadFlag , AllDelFlag, UserName, emailFlag, smsFlag
	FROM Common.dbo.UserCommon with (Nolock)
	WHERE UserId =@id And DelFlag='0' AND PartnerGbn = 0
GO
/****** Object:  StoredProcedure [dbo].[_Common_MemberJuminNoCheck_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*******************************************************************
	제목		:	회원 주민번호 중복 검사 
	작성자	: 김준범	2005.04.04
*******************************************************************/
--drop PROCEDURE dbo.Common_MemberJuminNoCheck
CREATE   PROCEDURE [dbo].[_Common_MemberJuminNoCheck_20191001]
	@JuminNo		varchar(15)
AS
	SELECT Count(JuminNo) As JuminNoCnt
	FROM Common.dbo.UserCommonDel_Log with (Nolock)
	WHERE JuminNo=@JuminNo
GO
/****** Object:  StoredProcedure [dbo].[_Common_MemberLoginCheck_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*******************************************************************
	제목		:	회원 로그인 체크 
	작성자	:  김경희	2003.07.07
	수정자 : 김준범 2004.11.11
*******************************************************************/

CREATE            PROCEDURE [dbo].[_Common_MemberLoginCheck_20191001]
	@UserID		varchar(50),
	@FaHost		varchar(30)

AS

DECLARE @InsChannel varchar(10)

SET @InsChannel = (SELECT IsNull(InsChannel,'') FROM Common.dbo.FindAllHost WHERE Host = @FaHost)

IF @InsChannel = '' 
	BEGIN
		SET @InsChannel = 'FindAll'
	END


SELECT UserID, PassWord, UserName, ISNULL(Email,'') As Email, IsNull(DelFlag,0) As DelFlag,
	ISNULL(BadFlag,'0') AS BadFlag, ISNULL(JuminNo,'') AS JuminNo, ISNULL(Phone,'') AS Phone, ISNULL(HPhone,'') AS HPhone, 
	ISNULL(Post1,'') AS Post1, ISNULL(Post2,'') AS Post2, ISNULL(Address1,'') AS Address1, ISNULL(Address2,'') AS Address2, ISNULL(AddressBunji,'') AS AddressBunji,
	ISNULL(VisitCnt,0) AS VisitCnt, ISNULL(PartnerCode,'0') AS PartnerCode, ISNULL(UserGbn,0) AS UserGbn,
	RegDate, LoginTime, IpAddr, ISNULL(LoginTime,'') AS LoginTime, ISNULL(PartnerGbn,0) AS PartnerGbn, @InsChannel As InsChannel
FROM Common.dbo.UserCommon with (Nolock)
WHERE UserID=@UserID
GO
/****** Object:  StoredProcedure [dbo].[_Common_MemberLoginCheck_Multi_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*******************************************************************
	제목		:	FindJob, FindAll 다중 로그인 
	작성자	:	조성훈	
				2007. 01. 05

*******************************************************************/

CREATE                     PROCEDURE [dbo].[_Common_MemberLoginCheck_Multi_20191001]
	@UserID		varchar(50),
	@IPAddr		varchar(30)

AS

DECLARE @IsTrue AS	VARCHAR(30)
SET @IsTrue = ''


IF @UserID <> ''
BEGIN
	SELECT @IsTrue = ISNULL(UserID,'') FROM Common.dbo.MultiLogin WHERE UserID = @UserID --AND IPAddr = @IPAddr 
END

--print(@IsTrue)

IF @IsTrue <> '' 
BEGIN

	DELETE FROM Common.dbo.MultiLogin  WHERE UserID = @UserID

	SELECT UserID, PassWord, UserName, ISNULL(Email,'') As Email, IsNull(DelFlag,0) As DelFlag,
		ISNULL(BadFlag,'0') AS BadFlag, ISNULL(JuminNo,'') AS JuminNo, ISNULL(Phone,'') AS Phone, 
		ISNULL(HPhone,'') AS HPhone, ISNULL(Post1,'') AS Post1, ISNULL(Post2,'') AS Post2, 
		ISNULL(Address1,'') AS Address1, ISNULL(Address2,'') AS Address2, ISNULL(AddressBunji,'') AS AddressBunji,
		ISNULL(VisitCnt,0) AS VisitCnt, ISNULL(PartnerCode,'0') AS PartnerCode, ISNULL(UserGbn,0) AS UserGbn,
		RegDate, IpAddr, ISNULL(LoginTime,'') AS LoginTime, ISNULL(PartnerGbn,0) AS PartnerGbn
	FROM Common.dbo.UserCommon with (Nolock)
	WHERE UserID=@UserID
END
ELSE	-- LoginProc_FindJob.asp OR LoginProc_FindAll.asp 에서 RS.EOF 인 조건에 오류나는것을 방지하기 위해
BEGIN
	SELECT TOP 0 * FROM Common.dbo.UserCommon
END
GO
/****** Object:  StoredProcedure [dbo].[_Common_MemberLoginInfo_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*****************************************************************
	제목		: 로그인 정보 남기기
	작성자	: 김경희 2003.07.07
	수정자 : 김준범 2004.11.11
*****************************************************************/
CREATE          PROCEDURE [dbo].[_Common_MemberLoginInfo_20191001]
	 @UserID	varchar(50)
	,@InsChannel	varchar(10)
	,@IpAddr 	varchar(20)
AS


IF (@InsChannel = '')										
	BEGIN
		SET @InsChannel = 'FindAll'
	END


	UPDATE UserCommon
	SET LoginTime = Getdate()
			, LoginSite = @InsChannel
			, IPAddr		= @IpAddr
			, VisitDay = Convert(varchar(10),GetDate())
			, VisitCnt = VisitCnt + 1
	WHERE UserID=@UserID


	-- 파인드올 + 파인드잡 다중 로그인 처리
	INSERT INTO Common.dbo.MultiLogin VALUES(@UserID,@IpAddr, GetDate())


GO
/****** Object:  StoredProcedure [dbo].[_Common_MemberOutChk_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
	제목		:	회원 탈퇴시 회원 인증
	작성자	: 김준범	2004.11.24

	2005.04.04 UserName 추가
*******************************************************************/

CREATE       PROCEDURE [dbo].[_Common_MemberOutChk_20191001]
	 @UserID	varchar(50)
--	,@UserName	varchar(30)
--	,@JuminNo	varchar(15)
--	,@PassWord	varchar(30)
AS

	SELECT UserID, UserName, JuminNo, PassWord, Email
	FROM Common.dbo.UserCommon 
	WHERE UserID=@UserID
--		AND UserName = @UserName
--		AND JuminNo = @JuminNo
--		AND PassWord = @PassWord
		AND PartnerGbn = 0
GO
/****** Object:  StoredProcedure [dbo].[_Common_UniqueCheckJuminNo_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*******************************************************************
	제목		:	회원 주민번호 중복 검사 
	작성자	: 김경희	2003.07.07
*******************************************************************/
--drop PROCEDURE dbo.Common_UniqueCheckJuminNo
CREATE   PROCEDURE [dbo].[_Common_UniqueCheckJuminNo_20191001]
	@JuminNo		varchar(15)
AS
	SELECT UserID, Password, Email, Phone, HPhone, Post1, Post2, Address1, Address2, RegDate, UserGbn, BadFlag , AllDelFlag, UserName
	FROM Common.dbo.UserCommon with (Nolock)
	WHERE JuminNo=@JuminNo And DelFlag='0' AND PartnerGbn = 0
GO
/****** Object:  StoredProcedure [dbo].[_Common_UserLoginCheck_1_DelAN_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*******************************************************************
	제목		:	회원 로그인 체크 
	작성자	:  김경희	2003.07.07
	수정자 : 김준범 2004.01.28
*******************************************************************/
--Drop PROCEDURE dbo.Common_UserLoginCheck_1
CREATE    PROCEDURE [dbo].[_Common_UserLoginCheck_1_DelAN_20191001]
	@UserID		varchar(30)
	,@PartnerGbn	int


AS

DECLARE @JuminNoChk int

	--[PartnerGbn이 0 보다 큰값을 가지는 경우는 우리회원과 공유를 하지 않을 경우임.]
	IF @PartnerGbn > 0		--[하이텔, 한미르, 메가패스...]
	BEGIN
		SELECT UserID, PassWord, UserName, ISNULL(Email,'') Email, ISNULL(DelFlag,'0') DelFlag,  
			ISNULL(BadFlag,'0') BadFlag, ISNULL(JuminNo,'') JuminNo, ISNULL(Phone,'') Phone, ISNULL(HPhone,'') HPhone, 
			ISNULL(Post1,'') Post1, ISNULL(Post2,'') Post2, ISNULL(Address1,'') Address1, ISNULL(Address2,'') Address2, 
			ISNULL(VisitCnt,0) VisitCnt, ISNULL(PartnerCode,'0')PartnerCode, UserGbn,
			ISNULL(AllDelFlag,'0')	AllDelFlag,	
			ISNULL(UsedDelFlag,'0')	UsedDelFlag,	
			ISNULL(ShopDelFlag,'0')	ShopDelFlag,
			ISNULL(JobDelFlag,'0') JobDelFlag,
			ISNULL(AlbaDelFlag,'0') AlbaDelFlag,
			ISNULL(CarDelFlag,'0') CarDelFlag,
			ISNULL(LandDelFlag,'0') LandDelFlag,
			ISNULL(YellowDelFlag,'0') YellowDelFlag,RegDate,IpAddr,LoginTime
			
		FROM Common.dbo.UserCommon with (Nolock)
		WHERE UserID=@UserID AND DelFlag = '0' --AND PartnerGbn =	@PartnerGbn 		

	END
	ELSE
	BEGIN
				SET @JuminNoChk = (
					SELECT Count(UserId) FROM UserCommon 
					WHERE JuMinNo In (SELECT JuMinNo FROM UserCommon WHERE UserID = @UserID) 
								AND DelFlag = 0 AND PartnerGbn = 0 AND UserGbn <> '2'
					)

		SELECT UserID, PassWord, UserName, ISNULL(Email,'') Email, ISNULL(DelFlag,'0') DelFlag,  
			ISNULL(BadFlag,'0') BadFlag, ISNULL(JuminNo,'') JuminNo, ISNULL(Phone,'') Phone, ISNULL(HPhone,'') HPhone, 
			ISNULL(Post1,'') Post1, ISNULL(Post2,'') Post2, ISNULL(Address1,'') Address1, ISNULL(Address2,'') Address2, 
			ISNULL(VisitCnt,0) VisitCnt, ISNULL(PartnerCode,'0')PartnerCode, UserGbn,
			ISNULL(AllDelFlag,'0')	AllDelFlag,	
			ISNULL(UsedDelFlag,'0')	UsedDelFlag,	
			ISNULL(ShopDelFlag,'0')	ShopDelFlag,
			ISNULL(JobDelFlag,'0') JobDelFlag,
			ISNULL(AlbaDelFlag,'0') AlbaDelFlag,
			ISNULL(CarDelFlag,'0') CarDelFlag,
			ISNULL(LandDelFlag,'0') LandDelFlag,
			ISNULL(YellowDelFlag,'0') YellowDelFlag,RegDate,IpAddr,LoginTime, @JuminNoChk AS JuminNoChk
		FROM Common.dbo.UserCommon with (Nolock)
		WHERE UserID=@UserID AND DelFlag = '0' AND PartnerGbn = 0 
	END
GO
/****** Object:  StoredProcedure [dbo].[_Common_UserLoginCheck_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*******************************************************************
	제목		:	회원 로그인 체크 
	작성자	: 김경희	2003.07.07
*******************************************************************/
--Drop PROCEDURE dbo.Common_UserLoginCheck
CREATE   PROCEDURE [dbo].[_Common_UserLoginCheck_20191001]
	@UserID		varchar(50)
	,@PartnerGbn	int
AS
	--[PartnerGbn이 0 보다 큰값을 가지는 경우는 우리회원과 공유를 하지 않을 경우임.]
	IF @PartnerGbn > 0		--[하이텔, 한미르, 메가패스...]
	BEGIN
		SELECT UserID, PassWord, UserName, ISNULL(Email,'') Email, ISNULL(DelFlag,'0') DelFlag,  
			ISNULL(BadFlag,'0') BadFlag, ISNULL(JuminNo,'') JuminNo, ISNULL(Phone,'') Phone, ISNULL(HPhone,'') HPhone, 
			ISNULL(Post1,'') Post1, ISNULL(Post2,'') Post2, ISNULL(Address1,'') Address1, ISNULL(Address2,'') Address2, 
			ISNULL(VisitCnt,0) VisitCnt, ISNULL(PartnerCode,'0')PartnerCode, UserGbn,
			ISNULL(AllDelFlag,'0')	AllDelFlag,	
			ISNULL(UsedDelFlag,'0')	UsedDelFlag,	
			ISNULL(ShopDelFlag,'0')	ShopDelFlag,
			ISNULL(JobDelFlag,'0') JobDelFlag,
			ISNULL(AlbaDelFlag,'0') AlbaDelFlag,
			ISNULL(CarDelFlag,'0') CarDelFlag,
			ISNULL(LandDelFlag,'0') LandDelFlag,
			ISNULL(YellowDelFlag,'0') YellowDelFlag,RegDate,AddressBunji
			
		FROM Common.dbo.UserCommon with (Nolock)
		WHERE UserID=@UserID AND DelFlag = '0' AND PartnerGbn =	@PartnerGbn 		

	END
	ELSE
	BEGIN
		SELECT UserID, PassWord, UserName, ISNULL(Email,'') Email, ISNULL(DelFlag,'0') DelFlag,  
			ISNULL(BadFlag,'0') BadFlag, ISNULL(JuminNo,'') JuminNo, ISNULL(Phone,'') Phone, ISNULL(HPhone,'') HPhone, 
			ISNULL(Post1,'') Post1, ISNULL(Post2,'') Post2, ISNULL(Address1,'') Address1, ISNULL(Address2,'') Address2, 
			ISNULL(VisitCnt,0) VisitCnt, ISNULL(PartnerCode,'0')PartnerCode, UserGbn,
			ISNULL(AllDelFlag,'0')	AllDelFlag,	
			ISNULL(UsedDelFlag,'0')	UsedDelFlag,	
			ISNULL(ShopDelFlag,'0')	ShopDelFlag,
			ISNULL(JobDelFlag,'0') JobDelFlag,
			ISNULL(AlbaDelFlag,'0') AlbaDelFlag,
			ISNULL(CarDelFlag,'0') CarDelFlag,
			ISNULL(LandDelFlag,'0') LandDelFlag,
			ISNULL(YellowDelFlag,'0') YellowDelFlag,RegDate,AddressBunji
		FROM Common.dbo.UserCommon with (Nolock)
		WHERE UserID=@UserID AND DelFlag = '0' AND PartnerGbn = 0 
	END
GO
/****** Object:  StoredProcedure [dbo].[_GJ_GET_MM_MEMBER_COMPANY_PROC_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 회원 정보 가져오기
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.11.09
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : GJ_GET_ZIPCODE_PROC '역삼'

 *************************************************************************************/


CREATE                     PROCEDURE [dbo].[_GJ_GET_MM_MEMBER_COMPANY_PROC_20191001]
	 @USERID		VARCHAR(50)	-- 회원명

AS
	SELECT   U.USERID
		,U.PASSWORD
		,U.USERNAME
 		,U.JUMINNO
		,U.EMAIL
		,U.URL
		,U.PHONE
		,U.HPHONE
		,U.POST1
		,U.POST2
		,U.CITY
		,U.ADDRESS1
		,U.ADDRESS2		
		,U.EMAILFLAG
		,U.SMSFLAG
		,U.MAILKIND
		,C.ONESNAME	-- 담당자
		,C.CAPITAL	-- 자본금
		,C.FAXNO	
		,C.FOUNDYEAR	-- 설립년도
		,C.SELLINGPRICE	-- 매출액
		,C.STAFF	-- 직원
		,C.PRESIDENT	-- 대표자
		,C.BIZTYPE	-- 기업형태
		,C.BUSERGBN	-- 기업상세구분
		,C.LISTSTOCKS	-- 상장여부
		,C.BIZCODE1	-- 업종
		,C.BIZCODE2	-- 업종
		,C.BIZCODE3	-- 업종
		,C.LEADBIZSUB	-- 주요사업내용
		,C.PAYSYSTEM	-- 급여
		,C.WELFAREPGM	-- 복리후생
		,IsNull(C.SUBWAYAREA,'') AS SUBWAYAREA -- 지하철
		,C.DETAILLOCATE	-- 상세지역
		,C.CONTENTS	-- 회사소개
		,MODDATE -- 수정일
		,COMP_KIND_CD	-- 병원
		,MAJOR_CD	-- 전공	
		,AUTH_NO
		,SUBWAYEXITNO
		,C.MAP_X
		,C.MAP_Y
		,C.MAP_RESULT_CD
	 FROM	DBO.USERCOMMON U WITH(NOLOCK)
		LEFT JOIN DBO.USERJOBCOMPANY C WITH(NOLOCK) ON U.USERID = C.USERID 
	WHERE	U.USERID = @USERID
GO
/****** Object:  StoredProcedure [dbo].[_GJ_GET_MM_MEMBER_LOGIN_PROC_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 로그인 체크 
 *  작   성   자 : 김경희 
 *  작   성   일 : 2003.07.07
 *  수   정   자 : 김준범 
 *  수   정   일 : 2004.11.11
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /MEMBER/LOGIN/LOGINPROC.ASP
 *************************************************************************************/


CREATE              PROCEDURE [dbo].[_GJ_GET_MM_MEMBER_LOGIN_PROC_20191001]
	 @USERID		VARCHAR(50)	-- 회원아이디
	,@FAHOST		VARCHAR(30)	-- 호스트명(WWW.FINDJOB.CO.KR)

AS

	DECLARE @INSCHANNEL VARCHAR(10)
	SET @INSCHANNEL = 'FINDALL'
	
	-- 등록채널 가져오기
	SET @INSCHANNEL = (SELECT ISNULL(INSCHANNEL,'') FROM COMMON.DBO.FINDALLHOST WHERE HOST = @FAHOST)		
	
	SELECT	USERID
		,PASSWORD
		,USERNAME
		,ISNULL(EMAIL,'') AS EMAIL
		,ISNULL(DELFLAG,0) AS DELFLAG
		,ISNULL(BADFLAG,'0') AS BADFLAG
		,ISNULL(JUMINNO,'') AS JUMINNO
		,ISNULL(PHONE,'') AS PHONE
		,ISNULL(HPHONE,'') AS HPHONE
		,ISNULL(POST1,'') AS POST1
		,ISNULL(POST2,'') AS POST2
		,ISNULL(ADDRESS1,'') AS ADDRESS1
		,ISNULL(ADDRESS2,'') AS ADDRESS2
		,ISNULL(ADDRESSBUNJI,'') AS ADDRESSBUNJI
		,ISNULL(VISITCNT,0) AS VISITCNT
		,ISNULL(PARTNERCODE,'0') AS PARTNERCODE
		,CASE	WHEN ISNULL(USERGBN,0) <> 2 THEN '1'
			ELSE '2'
		 END AS USERGBN
		,REGDATE
		,LOGINTIME
		,IPADDR
		,ISNULL(LOGINTIME,'') AS LOGINTIME
		,ISNULL(PARTNERGBN,0) AS PARTNERGBN
		,@INSCHANNEL AS INSCHANNEL
	  FROM	COMMON.DBO.USERCOMMON WITH(NOLOCK)
	 WHERE	USERID=@USERID
GO
/****** Object:  StoredProcedure [dbo].[_GJ_GET_MM_MEMBER_OUTCHK_PROC_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 탈퇴시 회원 인증
 *  작   성   자 : 김준범
 *  작   성   일 : 2004.11.24
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 회원 탈퇴시 회원 인증
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE      PROCEDURE [dbo].[_GJ_GET_MM_MEMBER_OUTCHK_PROC_20191001]
	 @USERID	VARCHAR(50)	-- 회원아이디
AS		

	SELECT	 USERID
		,USERNAME
		,JUMINNO
		,PASSWORD
		,EMAIL
		,AUTH_NO
		,(SELECT ONESNAME FROM DBO.USERJOBCOMPANY WHERE USERID = @USERID) AS ONESNAME		
	  FROM	COMMON.DBO.USERCOMMON WITH(NOLOCK)
	 WHERE	USERID = @USERID
		AND PARTNERGBN = 0
GO
/****** Object:  StoredProcedure [dbo].[_GJ_GET_MM_MEMBER_UNIQUE_NO_PROC_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 주민번호 / 사업자등록번호 중복체크
 *  작   성   자 : 김경희 
 *  작   성   일 : 2003.07.07
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 주민번호 / 사업자등록번호 중복체크
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 

 *************************************************************************************/


CREATE      PROCEDURE [dbo].[_GJ_GET_MM_MEMBER_UNIQUE_NO_PROC_20191001]
	 @USERGBN		CHAR(1)		-- 1(개인) / 2(기업)
	,@JUMINNO		VARCHAR(15)	-- 회원 주민번호 (사업자등록번호/주민등록번호)
	,@AUTH_NO		CHAR(14)	-- 담당자 : 주민등록번호(기업만 사용)

AS		
	IF @USERGBN = '1'
	BEGIN
		SELECT	USERID
			,PASSWORD
			,EMAIL
			,PHONE
			,HPHONE
			,POST1
			,POST2
			,ADDRESS1
			,ADDRESS2
			,REGDATE
			,USERGBN
			,BADFLAG
			,AllDELFLAG
			,USERNAME
		  FROM	COMMON.DBO.USERCOMMON WITH (NOLOCK)
		 WHERE 	JUMINNO = @JUMINNO 
		   AND	DELFLAG = '0' 
		   AND	PARTNERGBN = 0

	END
	ELSE
	BEGIN
		SELECT	 U.USERID
			,U.PASSWORD
			,U.EMAIL
			,U.PHONE
			,U.HPHONE
			,U.POST1
			,U.POST2
			,U.ADDRESS1
			,U.ADDRESS2
			,U.REGDATE
			,U.USERGBN
			,U.BADFLAG
			,U.AllDELFLAG
			,U.USERNAME
			,B.ONESNAME
		  FROM	COMMON.DBO.USERCOMMON U WITH (NOLOCK)
			LEFT JOIN DBO.USERJOBCOMPANY B WITH (NOLOCK) ON U.USERID = B.USERID
		 WHERE 	JUMINNO = @JUMINNO 
		   AND	AUTH_NO = @AUTH_NO
		   AND	DELFLAG = '0' 
		   AND	PARTNERGBN = 0

	END
GO
/****** Object:  StoredProcedure [dbo].[_GJ_PUT_MM_MEMBER_COMPANY_PROC_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 기업 회원
 *  작   성   자 : 김경희 
 *  작   성   일 : 2003.07.07
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 기업 회원 가입
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /MEMBER/JOIN/BIZ_INSERT.ASP
*************************************************************************************/


CREATE                  PROCEDURE [dbo].[_GJ_PUT_MM_MEMBER_COMPANY_PROC_20191001]
(
--	@OldUSERID			VARCHAR(30)	-- 사용안함
--,	@ReInsert			CHAR(1)		-- 사용안함		
	 @BUSERGBN			INT		-- 기업회원 구분(0:일반, 1:파견)
	,@USERID			VARCHAR(30)	-- 회원아이디
	,@PASSWORD			VARCHAR(30)	-- 패스워드
	,@USERGBN			CHAR(1)		-- 회원구분(0:개인,2:기업,3:딜러회원,4:개인등록대행)	
	,@USERNAME			VARCHAR(30)	-- 회원명
	,@JUMINNO			VARCHAR(15)	-- 회원번호(주민번호/사업자등록번호)
	,@REALNAMECHK			CHAR(1)		-- 실명인증여부
	,@EMAIL				VARCHAR(50)	-- 이메일주소
	,@URL				VARCHAR(100)	-- 홈페이지주소
	,@PHONE				VARCHAR(30)	-- 전화번호
	,@HPHONE			VARCHAR(30)	-- 휴대폰번호
	--,@AddrFlag			CHAR(1)		-- 주소종류(1:자택,2:직장) --> 현재입력X
	,@POST1				VARCHAR(5)	-- 우편번호
	,@POST2				VARCHAR(5)	-- 우편번호
	,@METRO				VARCHAR(20) 	-- 지역
	,@CITY				VARCHAR(20) 	-- 시/군/구
	,@DONG				VARCHAR(20)	-- 동
	,@LOCALBRANCH			VARCHAR(10)	-- 지점코드
	,@ADDRESS1			VARCHAR(100)	-- 주소1
	,@ADDRESS2			VARCHAR(100)	-- 주소2
	,@REGDATE			VARCHAR(10)	-- 등록일
	,@IPADDR			VARCHAR(20)	-- 회원 로컬IP
	,@INSCHANNEL			VARCHAR(10)	-- 등록채널
	--,@INSCHANNEL2			VARCHAR(10)	-- 등록채널2 -->사용안함
	,@MAILCHK			TINYINT		-- 이메일수신여부
	,@SMSCHK			TINYINT		-- SMS수신여부
	,@ONESNAME			VARCHAR(30)	-- 담당자
	,@CAPITAL			VARCHAR(30)	-- 자본금
	,@SELLINGPRICE			VARCHAR(30)	-- 매출액
	,@STAFF				VARCHAR(30)	-- 직원수
	,@PRESIDENT			VARCHAR(30)	-- 대표자
	,@BIZTYPE			VARCHAR(30)	-- 기업형태 (SELECT SRVGBN, SRVCODE,SRVNAME FROM JOBCOMMON.DBO.SERVICECODE WHERE SRVGBN=130)
	,@BIZCODE1          		VARCHAR(10)    	-- 업종코드1 (배치파일 사용 -> JOBCOMMON.DBO.BIZCODE_NA)
	,@BIZCODE2         		VARCHAR(10)    	-- 업종코드2 
	,@BIZCODE3          		VARCHAR(10)   	-- 업종코드3 
	,@WELFAREPGM			VARCHAR(200)	-- 복리후생(기타내용도 포함됨 EX)4대보험,기타,[기타내용])
	,@CONTENTS			VARCHAR(5000)	-- 회사소개
	--,@MailPeriod			VARCHAR(10)	-- 메일발송주기 -->사용안함
	,@INSLOCALSITE			VARCHAR(10)	-- 가입경로 (0,1,2,3) --> 간호잡은 지역싸이트가 없기 때문에 '0'
	,@FAXNO				VARCHAR(20)	-- 팩스번호
	,@FOUNDYEAR			VARCHAR(4)	-- 설립년도
	,@LISTSTOCKS			VARCHAR(10)	-- 상장구분
	,@LEADBIZSUB			VARCHAR(100)	-- 주요사업내용
	,@PAYSYSTEM			VARCHAR(10)	-- 급여제도
	,@SUBWAYCODE			VARCHAR(10)	-- 상세교통_지하철노선 (배치파일 사용 -> FINDCOMMON.DBO.STATIONNM)
	,@DETAILLOCATE			VARCHAR(200)	-- 상세교통_추가설명
	,@ADDRESS3 			VARCHAR(200)	-- 주소_번지
	--,@CouponFlag			TINYINT = 0	-- 코코펀 메일 수신 여부 -->사용안함
	,@COUPONLOCAL			TINYINT = 0	-- 이메일 수신 지역
	,@MAILKIND			VARCHAR(50)	-- 이메일 수신 섹션[MC] (JOB,HOUSE,AUTO,USED,ALL,PAPER,GANHO)
	,@AUTH_NO			CHAR(14)	-- 인증번호(기업)
	,@COMP_KIND_CD			VARCHAR(30)	-- 병원
	,@MAJOR_CD			VARCHAR(30)	-- 전공
	,@MAP_X				VARCHAR(10)		-- X좌표
	,@MAP_Y				VARCHAR(10)		-- Y좌표
	,@MAP_RESULT_CD		CHAR(2)			-- 좌표결과
)
AS

--지역정보에서 주소지 구분으로 LOCALSITE 정의
	DECLARE @LOCALSITE int
	SET @LOCALSITE = CASE @METRO	WHEN '서울' THEN	1
					WHEN '경기' THEN	2
					WHEN '인천' THEN	2
					WHEN '대전' THEN	3
					WHEN '충남' THEN	3
					WHEN '충북' THEN	3
					WHEN '광주' THEN	4
					WHEN '전남' THEN	4
					WHEN '전북' THEN	4
					WHEN '경북' THEN	5
					WHEN '대구' THEN	5
					WHEN '경남' THEN	6
					WHEN '부산' THEN	6
					WHEN '울산' THEN	6
					WHEN '강원' THEN	7
					WHEN '제주' THEN	8
					WHEN '해외' THEN	9
					ELSE 0 
			  END


-- 회원테이블에 입력
	INSERT	INTO	FINDDB2.COMMON.DBO.USERCOMMON (
							 USERID
							,PASSWORD	
							,USERGBN		
							,USERNAME
							,JUMINNO
							,REALNAMECHK
							,EMAIL
							,URL
							,PHONE
							,HPHONE
							--,AddrFlag
							,POST1
							,POST2
							,CITY
							,ADDRESS1
							,ADDRESS2
				   			,ADDRESSBUNJI
							,REGDATE	
							,IPADDR	
							,INSCHANNEL
							--,INSCHANNEL2
							,INSLOCALSITE
							,EMAILFlag                            
							,SMSFlag
							--,CouponFlag
							,COUPONLOCAL
							,MAILKIND
							,AUTH_NO
							,LoginTime
						) VALUES (
							 @USERID	
							,@PASSWORD
							,@USERGBN
							,@USERNAME
							,@JUMINNO
							,@REALNAMECHK
							,@EMAIL
							,@URL
							,@PHONE
							,@HPHONE
							--,@AddrFlag
							,@POST1
							,@POST2
							,@CITY
							,@ADDRESS1
							,@ADDRESS2
					 		,@ADDRESS3
							,@REGDATE
							,@IPADDR
							,@INSCHANNEL
							--,@INSCHANNEL2
							,@INSLOCALSITE
							,@MAILCHK
							,@SMSCHK
							--,@CouponFlag
							,@COUPONLOCAL
							,@MAILKIND
							,@AUTH_NO
							,GETDATE()

						)

	IF @@ERROR = 0 
	BEGIN
		INSERT	INTO FINDDB2.COMMON.DBO.USERJOBCOMPANY (
								USERID
								,BUSERGBN
								,ONESNAME
								,CAPITAL
								,SELLINGPRICE
								,STAFF
								,PRESIDENT
								,BIZTYPE
								,WELFAREPGM
								,CONTENTS
								,DelReason
								,FAXNO
								,FOUNDYEAR
								,LISTSTOCKS
								,LEADBIZSUB
								,PAYSYSTEM
								,SubwayArea
								,DETAILLOCATE	
								,BIZCODE1
								,BIZCODE2
								,BIZCODE3	
								,COMP_KIND_CD
								,MAJOR_CD
								,MAP_X
								,MAP_Y
								,MAP_RESULT_CD		
							) VALUES (
								 @USERID	
								,@BUSERGBN
								,@ONESNAME
								,@CAPITAL
								,@SELLINGPRICE
								,@STAFF
								,@PRESIDENT
								,@BIZTYPE
								,@WELFAREPGM
								,@CONTENTS
								,0
								,@FAXNO
								,@FOUNDYEAR
								,@LISTSTOCKS
								,@LEADBIZSUB
								,@PAYSYSTEM
								,@SUBWAYCODE
								,@DETAILLOCATE	
								,@BIZCODE1
								,@BIZCODE2
								,@BIZCODE3
								,@COMP_KIND_CD
								,@MAJOR_CD			
								,@MAP_X
								,@MAP_Y
								,@MAP_RESULT_CD		
								)

		INSERT	INTO FINDDB4.JOBMAIN.DBO.USERJOBCOMPANY (
								 USERID
								,BUSERGBN
								,ONESNAME
								,CAPITAL
								,SELLINGPRICE
								,STAFF
								,PRESIDENT
								,BIZTYPE
								,WELFAREPGM
								,CONTENTS
								,DelReason
								,FAXNO
								,FOUNDYEAR
								,LISTSTOCKS
								,LEADBIZSUB
								,PAYSYSTEM
								,SubwayArea
								,DETAILLOCATE
								,BIZCODE1
								,BIZCODE2
								,BIZCODE3
								,COMP_KIND_CD
								,MAJOR_CD					
								,MAP_X
								,MAP_Y
								,MAP_RESULT_CD		
							) VALUES (
								 @USERID	
								,@BUSERGBN
								,@ONESNAME
								,@CAPITAL
								,@SELLINGPRICE
								,@STAFF
								,@PRESIDENT
								,@BIZTYPE
								,@WELFAREPGM
								,@CONTENTS
								,0
								,@FAXNO
								,@FOUNDYEAR
								,@LISTSTOCKS
								,@LEADBIZSUB
								,@PAYSYSTEM
								,@SUBWAYCODE
								,@DETAILLOCATE
								,@BIZCODE1
								,@BIZCODE2
								,@BIZCODE3	
								,@COMP_KIND_CD
								,@MAJOR_CD				
								,@MAP_X
								,@MAP_Y
								,@MAP_RESULT_CD		
							)
      			--추가 작업 (작성자:안상미)
		INSERT	INTO FINDDB4.LocalMain.DBO.StoreInfo (
								 USERID
								,BUSERGBN
								,STORENM		--기업명				
								,REGNO             	--사업자등록번호
								,ONESNAME      		--담당자명(대표자명)	
								,REALNAMECHK 		--실명확인			
								,EMAIL               	--EMAIL
								,PHONE             	--전화번호
								,HPHONE           	--핸드폰번호
								,POST1               	--우편번호1
								,POST2               	--우편번호2
								,METRO                  --도
								,CITY			--시
								,DONG			--동
								,LOCALBRANCH		--도에따른 Branch 값
								,ADDRESS1         	--주소1
								,ADDRESS2         	--상세주소
								,ADDRESSBUNJI       	--상세주소
								,REGDATE	        --등록일자
								,LOCALSITE    		--등록사이트
						   		,BIZCODE1         	--업종코드1
						  		,BIZCODE2         	--업종코드2
						    		,BIZCODE3         	--업종코드3
								,SUBWAYCODE       	--지하철 코드
								,STORESUMMARY		--주요사업내용
								,COMUSERGBN		--회원유형
							) VALUES (
								 @USERID
								,@BUSERGBN
								,@USERNAME
								,@JUMINNO
								,@ONESNAME
								,@REALNAMECHK
								,@EMAIL
								,@PHONE
								,@HPHONE
								,@POST1
								,@POST2
								,@METRO
								,@CITY
								,@DONG
								,@LOCALBRANCH
								,@ADDRESS1
								,@ADDRESS2
								,@ADDRESS3
								,CONVERT(CHAR(10),GETDATE(),120)
								,@LOCALSITE
						    		,@BIZCODE1
								,@BIZCODE2
								,@BIZCODE3
								,@SUBWAYCODE
								,@LEADBIZSUB
								,@INSCHANNEL
							)
	END














GO
/****** Object:  StoredProcedure [dbo].[_GJ_PUT_MM_MEMBER_LOGIN_INFO_PROC_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
 *  단위 업무 명 : 회원 로그인 > 로그인 정보 남기기
 *  작   성   자 : 김경희 
 *  작   성   일 : 2003.07.07
 *  수   정   자 : 김준범 
 *  수   정   일 : 2004.11.11
 *  설        명 : 
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /MEMBER/LOGIN/LOGINPROC.ASP
 *************************************************************************************/


CREATE           PROCEDURE [dbo].[_GJ_PUT_MM_MEMBER_LOGIN_INFO_PROC_20191001]
	 @USERID	VARCHAR(50)	--회원아이디
	,@INSCHANNEL	VARCHAR(10)	--로그인채널
	,@IPADDR 	VARCHAR(20)	--회원로컬IP
AS

	-- 로그인 채널
	IF (@INSCHANNEL = '')										
	BEGIN
		SET @INSCHANNEL = 'FINDALL'
	END

	-- 로그인 정보 남기기
	UPDATE	DBO.USERCOMMON
	   SET	 LOGINTIME	= GETDATE()
		,LOGINSITE	= @INSCHANNEL
		,IPADDR		= @IPADDR
		,VISITDAY 	= CONVERT(VARCHAR(10),GETDATE())
		,VISITCNT 	= VISITCNT + 1
	WHERE USERID=@USERID

	
	-- 파인드올 + 파인드잡 다중 로그인 처리
	IF (@INSCHANNEL <> 'GANHO')
	BEGIN 
		INSERT	INTO COMMON.DBO.MULTILOGIN 
		VALUES(
			 @USERID
			,@IPADDR
			,GETDATE()
		)
	END




GO
/****** Object:  StoredProcedure [dbo].[_Proc_ParanCommonID_Covt_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--파란통합이이디로 각각의 매물테이블 및 결제테이블등 중요 테이블의 회원ID를 업데이트
--회원테이블 및 제휴테이블의 정보 업데이트

CREATE     	Proc [dbo].[_Proc_ParanCommonID_Covt_20191001]
AS
DECLARE	@Msg	varchar(100)
DECLARE   @RowCnt int
SET		@Msg = ''

--##############################################
--변경할 아이디 추출하기
--##############################################

--오늘 자료가 있는지 확인한다
SET @RowCnt = (SELECT Count(*) FROM Common.dbo.CooperCovtUserID_Save
WHERE CovtDate = Convert(varchar(10),GetDate(),120) )
--오늘날짜의 데이터가 이미 들어가 있다면.. (수작업으로 해준다)

IF	@RowCnt > 0
BEGIN
	SET	@Msg = '현재 CooperCovtUserID_Save테이블에 오늘 데이터가 들어가 있습니다.'	
	GOTO	LAST_PROC

END


--매칭테이블과 비교해서 변경될 아이디를 Save 테이블에 넣는다.
INSERT INTO Common.dbo.CooperCovtUserID_Save (UserID, PartnerID, PartnerUserNo, PartnerGbn, UserNo_New, UserID_New, UserNo_Old, UserID_Old, Domain_Old, MasterYN, CovtDate, IdentyFlag)
	SELECT A.UserID,A.PartnerID,A.PartnerUserNo,A.PartnerGbn,B.*,Convert(varchar(10),GetDate(),120) As CovtDate, 0 As IdentyFlag 
	FROM Common.dbo.Cooperation A with(nolock), Common.dbo.CooperCovtUserID B with(nolock)
	WHERE A.PartnerID = B.UserID_Old AND A.PartnerCode = B.Domain_Old AND PartnerGbn < 3
	ORDER BY B.UserNo_New


--매칭테이블과 매칭되는 자료가 없다면 그냥 끝낸다
IF	@@ROWCOUNT = 0
BEGIN
	SET	@Msg = '변경할 아이디가 없습니다.'	
	GOTO	LAST_PROC
END


--중복사용자 체크해서 수정(여러개의 아이디가 하나로 통합될 경우)
UPDATE A
SET IdentyFlag = 1
FROM Common.dbo.CooperCovtUserID_Save A, 
			(Select Max(Serial) As Serial,UserNo_New,UserID_New
				FROM Common.dbo.CooperCovtUserID_Save 
				WHERE CovtDate=Convert(varchar(10),GetDate(),120)
				GROUP BY UserNo_New,UserID_New ) B
WHERE A.Serial = B.Serial



--##############################################


--##############################################
--벼룩시장 신문 아이디 업데이트
--##############################################

UPDATE A		
SET A.UserID = B.UserID_New + '@paran.com'
--Select *
FROM 	FindDB2.PaperCommon.dbo.OrderMail A, Common.dbo.CooperCovtUserID_Save B
WHERE A.UserID = B.UserID
	AND B.PartnerGbn In (1,2)
	AND B.CovtDate = Convert(varchar(10),GetDate(),120)

UPDATE A
SET A.UserID = B.UserID_New + '@paran.com'
--Select *
FROM	FindDB2.PaperCommon.dbo.RecPaper A, Common.dbo.CooperCovtUserID_Save B
WHERE A.UserID = B.UserID
	AND B.PartnerGbn In (1,2)
	AND B.CovtDate = Convert(varchar(10),GetDate(),120)


UPDATE A
SET A.UserID = B.UserID_New + '@paran.com'
--Select *
FROM	FindDB2.PaperCommon.dbo.UserSaveAd A, Common.dbo.CooperCovtUserID_Save B
WHERE A.UserID = B.UserID
	AND B.PartnerGbn In (1,2)
	AND B.CovtDate = Convert(varchar(10),GetDate(),120)

--##############################################



--##############################################
--파인드유즈드 아이디 업데이트
--##############################################

UPDATE A
SET A.UserID = B.UserID_New + '@paran.com'
--Select Count(*)
FROM	FindDB13.UsedMain.dbo.GoodsMain A, Common.dbo.CooperCovtUserID_Save B
WHERE A.UserID = B.UserID
	AND B.PartnerGbn In (1,2)
	AND B.CovtDate = Convert(varchar(10),GetDate(),120)

UPDATE A
SET A.UserID = B.UserID_New + '@paran.com'
--Select Count(*)
FROM	FindDB13.UsedMain.dbo.Sale_BuyerInfo A, Common.dbo.CooperCovtUserID_Save B		--안전거래 결제건
WHERE A.UserID = B.UserID
	AND B.PartnerGbn In (1,2)
	AND B.CovtDate = Convert(varchar(10),GetDate(),120)

--##############################################


--##############################################
--파인드오토 아이디 업데이트
--##############################################

exec FINDDB3.AutoMain.dbo.Proc_ParanCommonID_Covt_Auto

--##############################################


--##############################################
--파인드잡 아이디 업데이트
--##############################################

UPDATE A
SET A.UserID = B.UserID_New + '@paran.com'
--Select Count(*)
FROM	FindDB4.JobMain.dbo.JobOffer A, Common.dbo.CooperCovtUserID_Save B
WHERE A.UserID = B.UserID
	AND B.PartnerGbn In (1,2)
	AND B.CovtDate = Convert(varchar(10),GetDate(),120)

UPDATE A
SET A.UserID = B.UserID_New + '@paran.com'
--Select Count(*)
FROM	FindDB4.JobMain.dbo.Resume A, Common.dbo.CooperCovtUserID_Save B
WHERE A.UserID = B.UserID
	AND B.PartnerGbn In (1,2)
	AND B.CovtDate = Convert(varchar(10),GetDate(),120)

UPDATE A
SET A.UserID = B.UserID_New + '@paran.com'
--Select Count(*)
FROM	FindDB4.JobMain.dbo.JobOfferOrderInJae A, Common.dbo.CooperCovtUserID_Save B  -- 인재정보
WHERE A.UserID = B.UserID
	AND B.PartnerGbn In (1,2)
	AND B.CovtDate = Convert(varchar(10),GetDate(),120)

UPDATE A
SET A.UserID = B.UserID_New + '@paran.com'
--Select Count(*)
FROM	FindDB4.JobMain.dbo.JobOfferOrderWap A, Common.dbo.CooperCovtUserID_Save B   -- Wap 서비스
WHERE A.UserID = B.UserID
	AND B.PartnerGbn In (1,2)
	AND B.CovtDate = Convert(varchar(10),GetDate(),120)

--##############################################



--##############################################
--파인드하우스 아이디 업데이트
--##############################################
	
	exec FINDDB11.HouseMain.dbo.Proc_ParanCommonID_Covt_House

--##############################################


--##############################################
--회원서브테이블 업데이트 및 삭제하기
--##############################################

--회원서브테이블 업데이트 (UserAllPerson)253
UPDATE A
SET A.UserID = B.UserID_New + '@paran.com'
--Select Count(*)
FROM	Common.dbo.UserAllPerson	A with(nolock),   Common.dbo.CooperCovtUserID_Save B
WHERE	B.PartnerGbn In (1,2)
			AND A.UserID =  B.UserID
			AND B.IdentyFlag = 1
			AND B.CovtDate = Convert(varchar(10),GetDate(),120)


--##############################################


--##############################################
--회원테이블 아이디 업데이트 및 삭제하기
--##############################################

--회원테이블 업데이트 (UserCommon)253
UPDATE A
SET A.UserID = B.UserID_New + '@paran.com', A.PartnerGbn = 4
--Select Count(*)
FROM	Common.dbo.UserCommon	A with(nolock),   Common.dbo.CooperCovtUserID_Save B
WHERE	A.PartnerGbn = B.PartnerGbn
			AND A.UserID =  B.UserID
			AND B.IdentyFlag = 1
			AND B.CovtDate = Convert(varchar(10),GetDate(),120)
			AND A.PartnerGbn In (1,2)

--##############################################


--##############################################
--제휴 매칭테이블 아이디 업데이트 및 삭제하기
--##############################################

UPDATE	A 
SET A.UserID = CASE WHEN PATINDEX('%hitel.net%',A.UserID) > 0 THEN UserID_New + '@paran.com'
										WHEN PATINDEX('%hanmir.com%',A.UserID) > 0 THEN  UserID_New + '@paran.com'
							ELSE A.UserID END
			, A.PartnerUserNo = B.UserNo_New
			, A.PartnerID = B.UserID_New
			, A.PartnerGbn = CASE WHEN B.PartnerGbn = 0 THEN 0
													 WHEN B.PartnerGbn In (1,2) THEN 4
										  END
			, A.PartnerCode = 'paran.com'
--Select Count(*)
FROM	Common.dbo.Cooperation	A,   Common.dbo.CooperCovtUserID_Save B
WHERE	A.PartnerID = B.UserID_Old
			AND A.PartnerGbn = B.PartnerGbn
			AND B.IdentyFlag = 1
			AND B.CovtDate = Convert(varchar(10),GetDate(),120)


--기존 서브테이블에 아이디가 통합된 자료는 삭제
DELETE A
FROM	Common.dbo.UserAllPerson	A,   Common.dbo.CooperCovtUserID_Save B
WHERE A.UserID = B.UserID 
			AND B.PartnerGbn In (1,2)
			AND B.CovtDate = Convert(varchar(10),GetDate(),120)


--기존 회원테이블에 아이디가 통합된 자료는 삭제
DELETE A
FROM	Common.dbo.UserCommon	A,   Common.dbo.CooperCovtUserID_Save B
WHERE A.UserID = B.UserID 
			AND B.PartnerGbn In (1,2)
			AND B.CovtDate = Convert(varchar(10),GetDate(),120)


--기존 매칭테이블에 아이디가 통합된 자료는 삭제
DELETE A
FROM	Common.dbo.Cooperation	A,   Common.dbo.CooperCovtUserID_Save B
WHERE A.UserID = B.UserID 
			AND B.PartnerGbn In (1,2)
			AND B.CovtDate = Convert(varchar(10),GetDate(),120)


--##############################################


LAST_PROC:
PRINT	@Msg
return(0)









GO
/****** Object:  StoredProcedure [dbo].[_procDelUserEnd_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	PROCEDURE [dbo].[_procDelUserEnd_20191001] 
AS

/*************************************************************************************
  자동탈퇴처리 예정 Temp Table
*************************************************************************************/

TRUNCATE TABLE DelUserEnd_Daily

INSERT INTO DelUserEnd_Daily (UserID, PassWord, UserGbn, UserName, JuminNo, RealNameChk, Email, Url, Phone, HPhone, AddrFlag, Post1, Post2, City, Address1, Address2, RegDate, ModDate, DelDate, VisitDay, VisitCnt, IPAddr, AllDelFlag, DelFlag, InsChannel, DelChannel, BadFlag, BadSite, BadReason, BadEtc, BadDate, InsLocalSite, DelLocalSite, PartnerCode, PartnerGbn, AddressBunji, LoginTime, LoginSite, emailFlag, smsFlag, CouponFlag, CouponLocal)
SELECT UserID, PassWord, UserGbn, UserName, JuminNo, RealNameChk, Email, Url, Phone, HPhone, AddrFlag, Post1, Post2, City, Address1, Address2, RegDate, ModDate, DelDate, VisitDay, VisitCnt, IPAddr, AllDelFlag, DelFlag, InsChannel, DelChannel, BadFlag, BadSite, BadReason, BadEtc, BadDate, InsLocalSite, DelLocalSite, PartnerCode, PartnerGbn, AddressBunji, LoginTime, LoginSite, emailFlag, smsFlag, CouponFlag, CouponLocal
  FROM UserCommon
 WHERE PartnerGbn = 0 
   AND DelFlag = '2' 
   AND CONVERT(varchar(10),DATEADD(dd,0,VisitDay),120) >= '2006-09-01'
   AND CONVERT(varchar(10),DATEADD(yy,1,DATEADD(dd,0,DelDate)),120) <= CONVERT(varchar(10),getdate(),120)

--탈퇴 처리
UPDATE A SET 
       DelFlag='1',
       DelDate=getdate(),
       DelChannel='FindAll',
       DelLocalSite = '0'
  FROM UserCommon A, DelUserEnd_Daily B
 WHERE A.UserID = B.UserID

--UserAllPerson_Del 해당 아이디, 등록일, 탈퇴사유, 가입사이트, 탈퇴사이트를 넣어준다.
INSERT INTO UserAllPerson_Del (UserID, RegDate, DelDate, InsChannel, DelChannel, DelReason, SiteNm)
SELECT UserID, CONVERT(varchar(10),getdate(),120), getdate(), InsChannel, DelChannel, '휴면계정자동탈퇴', '휴면계정자동탈퇴'
  FROM DelUserEnd_Daily

--1개월간 탈퇴회원 재가입 방지를 위한 주민번호저장
INSERT INTO UserCommonDel_Log (JuminNo) 
SELECT JuminNO
  FROM DelUserEnd_Daily
GO
/****** Object:  StoredProcedure [dbo].[_procJobCompanyInfoButt_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************
	설명	: 기업홍보관에 정보가 있는 회사인지 검색하여 정보 버튼 보여줌
	제작자	: 최지원
	제작일	: 2003-03-13

	-- EXEC procJobCompanyInfoButt 'deco9' 
*************************************************************************************/




CREATE        proc [dbo].[_procJobCompanyInfoButt_20191001]

(
	@strUserId	varchar(30)
)
AS

BEGIN

	Select 	count(UserId) 
	From 	FindDb4.JobMain.dbo.UserJobCompany 
	where 	UserId = @strUserId 
		AND ( Staff <> '' 
		Or President <> ''
		Or BizType<>''
		Or CategoryBiz <>''
		Or ListStocks <>''
		Or WelfarePgm <>'' 
		Or Contents <> ''		--[20040130]김현정대리 요청
		Or DetailLocate <>'' )

END





GO
/****** Object:  StoredProcedure [dbo].[_procMagOptionList_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 옵션정보 리스트
	제작자	: 남선희
	제작일	: 2002-03-29
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE  PROCEDURE [dbo].[_procMagOptionList_20191001] 
(
	@Page		int		-- Jump할 페이지
,	@PageSize	int		-- 페이지당 게시물 개수
,	@cboAdGbn	varchar(10)	-- 검색할 테이블명
,	@cboOptGbn	char(1)		-- 옵션종류
,	@cboStatus	char(1)		-- 게재구분
,	@cboTerm	varchar(10)	-- 검색기간구분
,	@FromDate	datetime	-- 검색시작일
,	@ToDate	datetime	-- 검색종료일
,	@cboPeriod	varchar(10)
,	@txtKeyword	varchar(40)
)
AS

-- 테이블에 따른 UserNm, ShopNm 구분
DECLARE @UserNm	varchar(10)
SET @UserNm = 
CASE
	WHEN @cboAdGbn = 'JobOffer' THEN 'ShopNm'
	WHEN @cboAdGbn = 'Resume' THEN 'UserName'
	ELSE 'ShopNm'
END

-- 옵션종류구분
DECLARE @OptGbnSql	varchar(100)
IF @cboOptGbn <> ''
	SET	@OptGbnSql =
	CASE
		WHEN @cboOptGbn = '1' THEN -- 핫
			'AND J.OptGbn IN (1, 4) '
		ELSE
			'AND J.OptGbn = ' + @cboOptGbn
	END
ELSE
	BEGIN
		SET	@OptGbnSql = ''
	END

-- 게재구분 쿼리
DECLARE @StatusSql	varchar(500)
IF @cboStatus <> ''
	SET	@StatusSql =
	CASE
		WHEN @cboStatus = '1' THEN	-- 게재전
			'AND CONVERT(varchar(10), GetDate(), 120) < CONVERT(varchar(10), J.OptStDate, 120) '
		WHEN @cboStatus = '2' THEN	-- 게재중
			'AND (CONVERT(varchar(10), GetDate(), 120) >= CONVERT(varchar(10), J.OptStDate, 120) AND CONVERT(varchar(10), GetDate(), 120) <= CONVERT(varchar(10), J.OptEnDate, 120)) '
		WHEN @cboStatus = '3' THEN	-- 마감
			'AND CONVERT(varchar(10), GetDate(), 120) > CONVERT(varchar(10), J.OptEnDate, 120) '
	END
ELSE
	BEGIN
		SET	@StatusSql = ''
	END

-- 검색기간 쿼리
DECLARE @TermSql	varchar(300)
IF @cboTerm <> ''
	BEGIN
		SET	@TermSql = 'AND (CONVERT(varchar(10), J.' + @cboTerm + ', 120) >= ' + '''' + CONVERT(varchar(10), @FromDate, 120) + '''' +
				' AND CONVERT(varchar(10), J.' + @cboTerm + ', 120) <= ' + '''' + CONVERT(varchar(10), @ToDate, 120) + ''') '
	END
ELSE
	BEGIN
		SET	@TermSql = ''
	END

-- 키워드 검색쿼리
DECLARE @KeyWordSql varchar(200)
SET	@cboPeriod =
CASE
	WHEN @cboAdGbn = 'JobOffer' AND @cboPeriod = 'UserName' THEN 'ShopNm'
	WHEN @cboAdGbn = 'Resume' AND @cboPeriod = 'UserName' THEN 'UserName'
	ELSE @cboPeriod
END

IF @cboPeriod <> '' AND @txtKeyWord <> ''
	BEGIN
		SET	@KeyWordSql = 'AND J.' + @cboPeriod + ' LIKE ''%' + @txtKeyWord + '%'' '
	END
ELSE
	BEGIN
		SET	@KeyWordSql = ''
	END

-- 모든 쿼리
DECLARE @AllSql	varchar(4000)
SET @AllSql =  @OptGbnSql + ' ' + @StatusSql + ' ' + @TermSql + ' ' + @KeyWordSql

DECLARE @Sql		varchar(6000)
SET	@Sql =
CASE
	WHEN @cboAdGbn = 'JobOffer' THEN
		'SELECT COUNT(J.AdId) FROM  ' + @cboAdGbn + ' J, RecCharge R, FindDb2.Common.dbo.UserCommon U ' +
		'WHERE J.UserId = U.UserId AND J.AdId *= R.AdId AND J.OptGbn > 0 AND J.DelFlag <> 1 AND R.AdGbn = 1 ' + @AllSql + '; ' + 
		'SELECT TOP ' + CONVERT(varchar(10), @Page*@PageSize) + ' J.AdId, J.UserID, U.UserName, J.' + @UserNm + ' AS ShopNm, J.Title, ' +
		'J.OptGbn, J.OptKind, J.OptAmt, J.DelFlag, J.RecProxyGbn, '+
		'J.OptEnDate, J.OptStDate, J.RegDate, ' +
		'RecCheck = CASE WHEN R.AdId IS NULL THEN ''N'' ELSE ''Y'' END, ' +
		'ChargeKind = CASE WHEN R.ChargeKind IS NULL THEN ''N'' ELSE R.ChargeKind END, ' +
		'CASE ' +
		' WHEN CONVERT(varchar(10), GetDate(), 120) < CONVERT(varchar(10), J.OptStDate, 120) THEN ''게재전'' ' +
		' WHEN CONVERT(varchar(10), GetDate(), 120) > CONVERT(varchar(10), J.OptEnDate, 120) THEN ''마감'' ' +
		' WHEN (CONVERT(varchar(10), GetDate(), 120) >= CONVERT(varchar(10), J.OptStDate, 120) AND CONVERT(varchar(10), GetDate(), 120) <= CONVERT(varchar(10), J.OptEnDate, 120)) THEN ''게재중'' ' +
		'END AS OptStatus ' +
		'FROM  ' + @cboAdGbn + ' J, RecCharge R, FindDb2.Common.dbo.UserCommon U ' +
		'WHERE J.UserId = U.UserId AND J.AdId *= R.AdId AND J.OptGbn > 0 AND J.DelFlag <> 1 AND R.AdGbn = 1 ' + @AllSql +
		'ORDER BY J.RegDate DESC '

	WHEN @cboAdGbn = 'Resume' THEN

		'SELECT COUNT(J.AdId) FROM  ' + @cboAdGbn + ' J, RecCharge R ' +
		'WHERE J.OptGbn > 0 AND J.DelFlag <> 1 ' + @AllSql +
		'AND R.AdGbn = 2 AND R.AdId =* J.AdId ;' +
		'SELECT TOP ' + CONVERT(varchar(10), @Page*@PageSize) + ' J.AdId, J.UserID, J.' + @UserNm + ' AS UserName, '''' AS ShopNm, J.Title, ' +
		'J.OptGbn, J.OptKind, J.OptAmt, J.DelFlag, J.RecProxyGbn, '+
		'J.OptEnDate, J.OptStDate, J.RegDate, ' +
		'RecCheck = CASE WHEN R.AdId IS NULL THEN ''N'' ELSE ''Y'' END, ' +
		'ChargeKind = CASE WHEN R.ChargeKind IS NULL THEN ''N'' ELSE R.ChargeKind END, ' +
		'CASE ' +
		' WHEN CONVERT(varchar(10), GetDate(), 120) < CONVERT(varchar(10), J.OptStDate, 120) THEN ''게재전'' ' +
		' WHEN CONVERT(varchar(10), GetDate(), 120) > CONVERT(varchar(10), J.OptEnDate, 120) THEN ''마감'' ' +
		' WHEN (CONVERT(varchar(10), GetDate(), 120) >= CONVERT(varchar(10), J.OptStDate, 120) AND CONVERT(varchar(10), GetDate(), 120) <= CONVERT(varchar(10), J.OptEnDate, 120)) THEN ''게재중'' ' +
		'END AS OptStatus ' +
		'FROM  ' + @cboAdGbn + ' J, RecCharge R ' +
		'WHERE J.AdId *= R.AdId AND J.OptGbn > 0 AND J.DelFlag <> 1 AND R.AdGbn = 2 ' + @AllSql +
		'ORDER BY J.RegDate DESC '

END

PRINT(@Sql)
EXECUTE(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[_procMagUserJobComMod_TEST_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*************************************************************************************
 *  단위 업무 명 : 
 *  작   성   자 : 
 *  작   성   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE                          PROCEDURE [dbo].[_procMagUserJobComMod_TEST_20191001]
(
	@intAdid			int
,	@strUserID			VARCHAR(30)
,	@strUrl				VARCHAR(100)
,	@strCapital			VARCHAR(30)
,	@strSellingPrice		VARCHAR(30)
,	@strStaff			VARCHAR(30)
,	@strPresident			VARCHAR(30)
,	@strBizType			VARCHAR(50)
,	@strBizCode1			CHAR(2)
,	@strBizCode2			CHAR(4)
,	@strBizCode3			CHAR(8)
,	@strLeadBizSub			VARCHAR(100)
,	@strWelfarePgm			VARCHAR(200)
,	@strContents			VARCHAR(5000)

)
AS
BEGIN

	DECLARE @intCount int

	IF @strUserID <> ''
	BEGIN				

		UPDATE FindDB2.Common.dbo.UserJobCompany 
		SET	Capital 	= @strCapital,
			SellingPrice 	= @strSellingPrice,
			Staff 		= @strStaff,
			President 	= @strPresident,
			BizType 	= @strBizType,
			BizCode1	= @strBizCode1,
			BizCode2	= @strBizCode2,
			BizCode3	= @strBizCode3,
			LeadBizSub	= @strLeadBizSub,
			WelfarePgm 	= @strWelfarePgm,
			Contents	= @strContents			
		WHERE UserID=@strUserID
	END
END




GO
/****** Object:  StoredProcedure [dbo].[_procPUserModify_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 개인회원 정보수정 프로시저
	제작자	: 남선희
	제작일	: 2002. 3. 8
	프로시저명 : procUserCancel
	설 명 : UserCommon 테이블과 UserJobCompany테이블 동시에 수정
*************************************************************************************/
CREATE PROCEDURE [dbo].[_procPUserModify_20191001]
(
	@strUserID	VARCHAR(30)
,	@strPassword	VARCHAR(30)
,	@strEmail	VARCHAR(50)
,	@strUrl		VARCHAR(50)
,	@strPhone	VARCHAR(30)
,	@strHPhone	VARCHAR(30)
,	@strPost1	VARCHAR(5)
,	@strPost2	VARCHAR(5)
,	@strCity		VARCHAR(100)
,	@strAddress1	VARCHAR(100)
,	@strAddress2	VARCHAR(100)
,	@strModDate	VARCHAR(10)
,	@strIPAddr	VARCHAR(20)
,	@strMailChk	CHAR(1)
,	@Flag	  	char(1)            
)
AS


BEGIN	
--BEGIN distributed TRANSACTION
	IF @strPassword <> ' ' 
	BEGIN
			UPDATE	FINDDB2.Common.dbo.UserCommon	SET
			PassWord		= 	@strPassword
		,	Email			= 	@strEmail
		,	Url			=	@strUrl
		,	Phone			= 	@strPhone
		,	HPhone			= 	@strHPhone
		,	Post1			= 	@strPost1
		,	Post2			= 	@strPost2
		,	City			= 	@strCity
		,	Address1		= 	@strAddress1
		,	Address2		= 	@strAddress2
		,	ModDate		=	@strModDate
		,	IPAddr			=	@strIPAddr
	
			WHERE UserID = @strUserID 
	END
	Else
	BEGIN
			UPDATE	FINDDB2.Common.dbo.UserCommon	SET
			Email			= 	@strEmail
		,	Url			=	@strUrl
		,	Phone			= 	@strPhone
		,	HPhone			= 	@strHPhone
		,	Post1			= 	@strPost1
		,	Post2			= 	@strPost2
		,	City			= 	@strCity
		,	Address1		= 	@strAddress1
		,	Address2		= 	@strAddress2
		,	ModDate		=	@strModDate
		,	IPAddr			=	@strIPAddr
	
			WHERE UserID = @strUserID 
	END

	IF @Flag = '2'
		BEGIN
				UPDATE	FINDDB2.Common.dbo.UserJobPerson  SET  	--UserJobPerson테이블의 메일체크 수정
				MailChk = @strMailChk
				WHERE UserID = @strUserID
		END
	IF @Flag = '1'
		BEGIN
				INSERT INTO  FINDDB2.Common.dbo.UserJobPerson(MailChk,UserID )  VALUES( @strMailChk,@strUserID)
		END

 print(@strUserID)
 print(@strPassword)

--IF @@ERROR = 0
--	BEGIN
--		Commit transaction
--	end
--else
--	begin
--		rollback
--	end

END
GO
/****** Object:  StoredProcedure [dbo].[_procUserCommon_Cancel_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[_procUserCommon_Cancel_20191001]
AS

--=========================================================================================
--  회원탈퇴정책에 따른 회원탈퇴 처리 
--  작성일 	: 2003. 6. 19
--  수정일	: 2003. 7.   8
--  작업내용 	: 탈퇴신청한 회원들을 대상으로 24시간 이내에 탈퇴처리를 하되
--		  매물등록을 한번이라도 한적이 있는 회원인지 아닌지를 판단하고
--		  모든 테이블의 ID값과 DelFlag값을 변경해 준다
--  처리 프로세스	: ① UserCommon의 DelFlag = '1' 인 대상들만 작업 
--		  ② UserCommon_Del 테이블에
--		      - 그냥  Insert를  하고  (Serial 생성)
--		      - 각  사이트 매물 DB와 DelTargetUser 테이블 조인하여  CheckFlag와 Del_ID 값 Update함
--		  ③ 모든 관련 테이블의 UserID 값에  UserCommon_Del.Del_ID 값으로, DelFlag, DelDate 값 변경해 줌
--		  ④ UserCommon의 DelFlag = '1'인 위에서 작업한 자료 Delete 
--   		  ⑤ UserAllPerson_Del 의 Del_ID값 변경
--=========================================================================================


--=========================================================================================
-- ① UserCommon의 DelFlag = '1' 인 대상들만 작업
--=========================================================================================

	CREATE	TABLE	#Temp_DelUserID
	(UserID		varchar(30),
	 Del_ID		varchar(30))	


	INSERT	INTO	#Temp_DelUserID
		(UserID)	
	SELECT 	UserID	
	FROM	Common.dbo.UserCommon	
	WHERE	DelFlag = '1'
	
--=========================================================================================
--  ② UserCommon_Del 테이블에
--      - 그냥  Insert를  하고  (Serial 생성)
--      - 각  사이트 매물 DB와 DelTargetUserID 테이블 조인하여  CheckFlag와 Del_ID 값 Update함
--=========================================================================================

-- 각 매물 DB와 DelTargetUserID 테이블 조인하여 매물을 하나라도 등록한 UserID 검색

	SELECT 	DISTINCT  A.UserID	
	INTO	#Temp_RegUserID 
	FROM   (SELECT	DISTINCT  UserID
		FROM	Common.dbo.DelTargetUserID
		UNION	
		SELECT	DISTINCT  UserID
		FROM	FindDB13.UsedMain.dbo.GoodsMain
		UNION	
		SELECT	DISTINCT  UserID
		FROM	FindDB3.AutoMain.dbo.SellAuto
		UNION	
		SELECT	DISTINCT  UserID
		FROM	FindDB3.AutoMain.dbo.BuyAd
		UNION	
		SELECT	DISTINCT  UserID
		FROM	FindDB3.AutoMain.dbo.NewAuto
		UNION	
		SELECT	DISTINCT  UserID
		FROM	FindDB4.JobMain.dbo.JobOffer
		UNION	
		SELECT	DISTINCT  UserID
		FROM	FindDB4.JobMain.dbo.Resume
		UNION	
		SELECT	DISTINCT  UserID
		FROM	FindDB4.JobMain.dbo.Education
		UNION	
		/*
		SELECT	DISTINCT  UserID
		FROM	FindDB5.AlbaMain.dbo.JobOffer
		UNION	
		SELECT	DISTINCT  UserID
		FROM	FindDB5.AlbaMain.dbo.Resume
		UNION	
		*/
		SELECT	DISTINCT  UserID
		FROM	FINDDB11.HouseMain.dbo.tbl_goodMain)  A,
		#Temp_DelUserID	B
	WHERE  A.UserID  =  B.UserID 


-- Serial, Del_ID, CheckFlag,  #Temp_userID..Del_ID값들은  Fetch Next 돌리면서 반영할 것임
-- UserCommon_Del..UserID 값이  중복해서 들어가 있을수 있으므로, 건건이 Serial 받으면서 
-- 작업 해야함

 	DECLARE @Serial		    	int
 	DECLARE @UserID		varchar(30)
	DECLARE Cur_UserID_Delete	SCROLL CURSOR 

	FOR 	SELECT UserID
	 	   FROM #Temp_DelUserID
	FOR READ ONLY

	OPEN Cur_UserID_Delete
	FETCH FROM Cur_UserID_Delete  
 		INTO @UserID
	SET NOCOUNT ON

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		-- 그냥  Insert를  하고  (Serial 생성)
		INSERT	INTO	Common.dbo.UserCommon_Del
			(UserID, PassWord, UserGbn, UserName, JuminNo, RealNameChk, 
			Email, Url, Phone, HPhone, AddrFlag, Post1, Post2, City, Address1, 
			Address2, RegDate, ModDate, DelDate, VisitDay, VisitCnt, 
			IPAddr, UsedDelFlag, ShopDelFlag, JobDelFlag, AlbaDelFlag, CarDelFlag, 
			LandDelFlag, YellowDelFlag, AllDelFlag, InsChannel, InsChannel2, 
			DelChannel, BadFlag, BadSite, BadReason, BadEtc, BadDate, InsLocalSite, 
			DelLocalSite, PartnerCode, PartnerGbn, AddressBunji)
		SELECT	UserID, PassWord, UserGbn, UserName, JuminNo, RealNameChk, 
			Email, Url, Phone, HPhone, AddrFlag, Post1, Post2, City, Address1, 
			Address2, RegDate, ModDate, DelDate, VisitDay, VisitCnt, 
			IPAddr, UsedDelFlag, ShopDelFlag, JobDelFlag, AlbaDelFlag, CarDelFlag, 
			LandDelFlag, YellowDelFlag, AllDelFlag, InsChannel, InsChannel2, 
			DelChannel, BadFlag, BadSite, BadReason, BadEtc, BadDate, InsLocalSite, 
			DelLocalSite, PartnerCode, PartnerGbn, AddressBunji
		FROM	Common.dbo.UserCommon
		WHERE	UserID		=  @UserID
	   
		-- 생성된 Serial 값 받구
		SELECT	@Serial = @@IDENTITY 

		-- 해당 Serial 값의 Row에 Del_ID 값 반영
		UPDATE	Common.dbo.UserCommon_Del
		SET	Del_ID = 'Del_' + convert(varchar(10), Serial)
		WHERE	Serial  =  @Serial

		-- 매물을 한번이라도 등록한 회원들의 CheckFlag값 반영
		UPDATE	A
		SET	A.CheckFlag = '1'
		FROM	Common.dbo.UserCommon_Del	A,
			#Temp_RegUserID		B
		WHERE	A.UserID  =  B.UserID
		AND	A.Serial	 =  @Serial 
		
		-- #Temp_DelUserID의 Del_ID값 반영 
		UPDATE	A
		SET	A.Del_ID	=  B.Del_ID
		FROM	#Temp_DelUserID		A,
			Common.dbo.UserCommon_Del	B
		WHERE	A.UserID	 = @UserID
		AND	B.Serial	 = @Serial
		
		-- 다음건 처리
		FETCH FROM Cur_UserID_Delete  
		INTO @UserID

	END
	CLOSE Cur_UserID_Delete
	DEALLOCATE Cur_UserID_Delete


--=========================================================================================
-- ③ 모든 관련 테이블의 UserID 값에  UserCommon_Del.Del_ID 값으로, DelFlag, DelDate 값 변경해 줌
-- 2006.01.18 일 수정 -> DelUserID_Daily 테이블에 탈퇴아이디 넣고, 각 메인 디비에서 조인하여 업데이트
--=========================================================================================


	TRUNCATE TABLE DelUserID_Daily

	INSERT INTO DelUserID_Daily (UserID, Del_ID, RegDate)
	SELECT UserID, Del_ID, GETDATE() FROM #Temp_DelUserID


--=========================================================================================
--   ④ UserCommon의 DelFlag = '1'인 위에서 작업한 자료 Delete 
--=========================================================================================

	DELETE	A
	FROM	Common.dbo.UserCommon	A,
		#Temp_DelUserID		B
	WHERE	A.UserID		=  B.UserID

--=========================================================================================
--   ⑤ UserAllPerson_Del 의 Del_ID값 변경
--=========================================================================================

	UPDATE  A	SET  A.Del_ID  =  B.Del_ID
	FROM	Common.dbo.UserAllPerson_Del	A,
		#Temp_DelUserID		B
	WHERE	A.UserID		=  B.UserID
	AND	(A.Del_ID	=  ''  OR  A.Del_ID  is Null)





GO
/****** Object:  StoredProcedure [dbo].[_procUserCommon_Delete_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[_procUserCommon_Delete_20191001] 
AS

/* ====================================================================================
       삭제회원들중 6개월 지난 회원들을 완전히 삭제하는 작업 
 ====================================================================================*/

-- 1. 6개월 이전에 삭제한 회원들 검색 	
	SELECT  UserID	INTO	#Temp_UserCommon
	FROM	FINDDB2.Common.dbo.UserCommon_Del
	WHERE	Convert(varchar(10), dateadd(mm, -6, getdate()), 120) >  DelDate   

-- 2. UserCommon_6mm_Delete  테이블로 대상자 이동
	INSERT 	INTO	FINDDB2.Common.dbo.UserCommon_6mm_Delete
	SELECT	A.*
	FROM	FINDDB2.COmmon.dbo.UserCommon_Del	A,
		#Temp_UserCommon			B
	WHERE	A.UserID		=  B.UserID

-- 3. UserCommon_Del  테이블  삭제
	DELETE	A
	FROM	FINDDB2.COmmon.dbo.UserCommon_Del	A,
		#Temp_UserCommon			B
	WHERE	A.UserID		=  B.UserID


GO
/****** Object:  StoredProcedure [dbo].[_procUserCommon_Save_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[_procUserCommon_Save_20191001] AS

BEGIN
BEGIN TRANSACTION
	SELECT  * INTO #Temp_UserCommon  
	   FROM Common.dbo.UserCommon
	WHERE UserID not in (SELECT UserId FROM Common.dbo.UserCommon_Save)


	
	INSERT INTO Common.dbo.UserCommon_Save
	SELECT * FROM #Temp_UserCommon

	IF @@ERROR = 0
		BEGIN
		    COMMIT TRAN
		END
	ELSE
		BEGIN
		    ROLLBACK
		END
END
GO
/****** Object:  StoredProcedure [dbo].[_procYPUserDetail_DelAN_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: Yellow회원 수정 프로시저
	수정자	: 김선미
	수정일	: 2002-12-06
*************************************************************************************/
CREATE       PROC [dbo].[_procYPUserDetail_DelAN_20191001]
	@strUserId	  varchar(30)
      
						      
AS						      
						      
BEGIN							
	set nocount on
    	
	Select	A.UserId,
		A.password,
		A.UserGbn,
		A.UserName,
		A.JuminNo,
		A.Email,
		A.Post1,
		A.Post2,
		A.Address1,
		A.Address2,
		A.City,
		A.Phone,
		A.HPhone,
		A.ModDate,
		A.emailFlag as MailChk,
		A.smsFlag as SMSChk
	  From	Common.dbo.UserCommon A,  Common.dbo.UserTown B With (NoLock, ReadUnCommitted) 
	Where	A.UserId = @strUserId
	    And    A.UserId*= B.UserId
	 --And	A.YellowDelFlag = '0'
					
END
GO
/****** Object:  StoredProcedure [dbo].[_procYPUserIDSelect_DelAN_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROC [dbo].[_procYPUserIDSelect_DelAN_20191001]
	@strUserName	  varchar(30),
	@strJuminNo 	  varchar(15)
AS
BEGIN
	SELECT UserID,UserName,PassWord, Email  FROM Common.dbo.UserCommon  With (NoLock, ReadUnCommitted)   --아이디, 패스워드,이메일 검색
	WHERE UserName=@strUserName and JuminNo=@strJuminNo and PartnerGbn = 0 and (IsNull(YellowDelFlag,'') <> '1' AND DelChannel <> 'Yellow')
End
GO
/****** Object:  StoredProcedure [dbo].[_procYPUserMod_DelAN_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: Yellow개인회원 정보 수정
	수정자	: 김선미
	수정일	: 2002-12-06
	@strFlag 에 따라 UserTown 에 INSERT,UPDATE 한다
*************************************************************************************/
CREATE          PROC [dbo].[_procYPUserMod_DelAN_20191001]
	@strUserId	  	varchar(30),				
	@strPassWord	 	varchar(30),      	            	      
	@strEmail	  	varchar(50),	      	            	      
	@strPost1	  	char(3),	      	      
	@strPost2	  	char(3),	      	            	      
	@strAddress1	  	varchar(100),	      	      
	@strAddress2	  	varchar(100),	
	@strCity			varchar(100),   
	@strPhone	  	varchar(30),	      	
	@strHPhone	  	varchar(30),	  
	@strIPAddr          	            	varchar(20),      
	@strMailChk	  	char(1),
	@strSMSChk	  	char(1),
	@strFlag	  		char(1)		      
AS						      
						      
BEGIN							

	--회원정보 수정일 경우
	
		Update   	Common.dbo.UserCommon
		      Set		PassWord	=	@strPassWord,
				Email		=	@strEmail,
				Post1		=	@strPost1,
				Post2		=	@strPost2,
				Address1	=	@strAddress1,
				Address2	=	@strAddress2,
				City		=	@strCity,
				Phone		=	@strPhone,
				HPhone		=	@strHPhone,
				IPAddr		=	@strIPAddr,	
				emailFlag	=	@strMailChk,	
				smsFlag		=	@strSMSChk,				
				ModDate		=	getdate()
		  Where		UserId		=	@strUserId
		    --And		YellowDelFlag	=	'0'

	IF @strFlag = '2' 
			BEGIN
				UPDATE		Common.dbo.UserTown	 	--UserYellow테이블의 메일체크 수정
				      SET  	MailChk = @strMailChk
				WHERE 		UserID = @strUserID
			END

	IF @strFlag = '1'								--UserYellow테이블의 신규입력
			BEGIN
				INSERT INTO  	Common.dbo.UserTown(MailChk,UserID )  VALUES(@strMailChk,@strUserID)
			END

END
GO
/****** Object:  StoredProcedure [dbo].[_UserCommonCovt_DelAN_20191001]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[_UserCommonCovt_DelAN_20191001] AS

-- 반영 안된 회원들 Temp 테이블에 반영
SELECT UserID into #Temp_UserInfo FROM Common.dbo.UserInfo WHERE UserID not in (SELECT UserID FROM  Common.dbo.UserCommon)


-- 반영 안된 회원들만  반영함 	
insert into Common.dbo.UserCommon (UserID, PassWord, UserGbn, UserName, JuminNo, RealNameChk, 
	Email, Url, Phone, HPhone, AddrFlag, Post1, Post2, City, Address1, Address2, RegDate, 
	ModDate, VisitDay, VisitCnt, IPAddr, InsChannel) 
select 
	UserID, PassWord, '1', UserName, JuminNo, RealNameChk, 
	Email, URL, Phone, HPhone, '1',  Post1, Post2,  City,  Address, '',  
	RegDate, ModDate, VisitDay, VisitCnt, IPAddr, 
	'FindAll'
from Common.dbo.UserInfo  A,  #Temp_UserInfo  B
where A.DelFlag = 0
  and  A.UserID  =  B.UserID 



Update A set  A.City = B.City,  
                      A.Address2 = Replace(A.Address1, B.Address, '')
from Common.dbo.UserCommon  A,  FINDDB3.Post2000.dbo.ZipCode  B,  #Temp_UserInfo  C
where A.Post1 = ZipCode1 and A.Post2 = ZipCode2 and charindex(B.Address, A.Address1) > 0
  and  A.UserID = C.UserID 



Update A set A.Address1 = B.Address 
from Common.dbo.UserCommon  A,  FINDDB3.Post2000.dbo.ZipCode  B, #Temp_UserInfo  C
where A.Post1 = ZipCode1 and A.Post2 = ZipCode2 and charindex(B.Address, A.Address1) > 0
  and  A.UserID = C.UserID
GO
/****** Object:  StoredProcedure [dbo].[BAT_MT_DBERROR_TB_INS_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : DB 오류 로그
 *  작   성   자 : 정헌수 (HSKKA@MEDIAWILL.COM)
 *  작   성   일 : 2014/04/15
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC PAPER_NEW.DBO.BAT_MT_DBERROR_TB_INS_PROC
	--PAPER_NEW.DBO.BAT_MT_DBJOB_FAILURE_TB_INS_PROC에서 실행됨
 *************************************************************************************/


CREATE PROC [dbo].[BAT_MT_DBERROR_TB_INS_PROC]


AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @ROWCOUNT INT
	DECLARE @MSG	VARCHAR(200)
	
	/* 임시 테이블 생성 */ 
	SELECT TOP 0 
		LOGDATE
		,PROCESSINFO
		,MESSAGE
	INTO #TMP_TBL
	FROM  MT_DBERROR_TB
	 
	/* 오류로그 취합 */ 
	INSERT INTO #TMP_TBL
	EXEC ('EXEC XP_READERRORLOG 0,1')


	/* 이전백업데이터 삭제 */ 
	DELETE #TMP_TBL WHERE LOGDATE <= (SELECT MAX(LOGDATE) FROM MT_DBERROR_TB)

	/*신규 백업 데이터 입력 */
	INSERT INTO MT_DBERROR_TB (LOGDATE,PROCESSINFO,MESSAGE)
	SELECT *FROM #TMP_TBL WHERE LOGDATE > (SELECT isnull(MAX(LOGDATE),'') FROM MT_DBERROR_TB)

	/* 에러 발생시 메세지 전달 요망*/
	SELECT @ROWCOUNT = COUNT(*) FROM #TMP_TBL WITH(NOLOCK) 
	WHERE MESSAGE NOT LIKE 'LOG WAS BACKED UP%'	--트랜잭션 로그 백업
	AND MESSAGE NOT LIKE 'DBCC TRACEON%'		--??
	AND MESSAGE NOT LIKE 'DATABASE BACKED UP%'	--DB 백업
	AND MESSAGE NOT LIKE 'SQL TRACE STOPPED.%'	--profiler 실행
	AND MESSAGE NOT LIKE 'SQL TRACE ID %'		--profiler 실행
	AND MESSAGE NOT LIKE 'THIS INSTANCE OF SQL SERVER HAS BEEN USING %'--단순메세지
	AND MESSAGE NOT LIKE 'Setting database option%'	--재부팅시 실행시 옵션 세팅
	AND MESSAGE NOT LIKE 'Database was restored:%'  -- 리스토어
	AND MESSAGE NOT LIKE '%This is an informational message only%'  -- 메세지 전용
	AND MESSAGE NOT LIKE 'A possible infinite recompile was%'  -- recompile


	IF @ROWCOUNT > 0 
	BEGIN
		DECLARE @ERRORNM VARCHAR(40)	
		SELECT TOP 1 @ERRORNM = LEFT(MESSAGE,30) FROM #TMP_TBL WITH(NOLOCK)  
		WHERE MESSAGE NOT LIKE 'Log was backed up.%' ORDER BY LOGDATE  DESC

		SET @MSG = 'MWMEMBERDB:' + CAST(@ROWCOUNT AS VARCHAR(10)) + '건 DB오류발생 MT_DBERROR_TB[' + @ERRORNM +']'
		--EXECUTE FINDDB1.COMDB1.DBO.PUT_SENDKAKAO_PROC '01031273287', '0230190213', 'MWsms16', @MSG, NULL, NULL, '벼룩시장 DB오류메세지' 		  , @MSG	
--		EXECUTE TAX.COMDB1.DBO.PUT_SENDSMS_PROC '0230190213','FA SYSTEM','개발담당','01031273287',@MSG  -- 정헌수
	END
END
GO
/****** Object:  StoredProcedure [dbo].[BAT_MT_DBJOB_FAILURE_TB_INS_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 스케쥴 오류 로그
 *  작   성   자 : 정헌수 (hskka@mediawill.com)
 *  작   성   일 : 2014/06/11
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.BAT_MT_DBJOB_FAILURE_TB_INS_PROC
	SELECT TOP 100 * FROM PAPER_NEW.DBO.MT_DBJOB_FAILURE_TB WITH(NOLOCK) order by instance_id desc
 *************************************************************************************/


CREATE PROC [dbo].[BAT_MT_DBJOB_FAILURE_TB_INS_PROC]


AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON
/******************************************************************************
  * DECLARE & INITIALIZE
 ******************************************************************************/
	DECLARE @ROWCOUNT varchar(10)
	DECLARE @MSG varchar(100)

	-- 취합로그가 없을경우 최대 12시간이전 로그를 취합
	DECLARE @date CHAR(8)
	SET @date = CONVERT(CHAR(8),DATEADD(DD, - 0.1,GETDATE()),112)

	-- DECLARE
	DECLARE @ID_DBJOB  INT


/*
	기존 수집된 에러 최신번호  (만약 에러 번호가 초기화 되었다면?)
*/	
	PRINT @ID_DBJOB
	SELECT @ID_DBJOB = ISNULL(MAX(INSTANCE_ID) ,0)
	FROM FINDDB1.LOGDB.DBO.MT_DBJOB_FAILURE_TB WITH(NOLOCK) 
	WHERE	SERVERNM = 'MEMBERDB'
		AND REGDT > GETDATE() - 1

	
 /******************************************************************************
  * CASE NO DATA SET
 ******************************************************************************/


	IF @ID_DBJOB = 0 
	BEGIN
		SELECT @ID_DBJOB = ISNULL(max(instance_id),0)-1
		FROM MSDB.DBO.SYSJOBHISTORY WITH(NOLOCK)
		WHERE run_status = 0 
			AND step_id>0 
			AND run_date >= @date
	END
	IF @ID_DBJOB <= 0 --오류 없으면..
	RETURN 
	PRINT @ID_DBJOB

 /******************************************************************************
  * TEMP TABLE GATHERING
  drop table #TMP
 ******************************************************************************/
 SELECT *
   INTO #TMP
   FROM (
   -- 195번 쿼리
   SELECT 'MEMBERDB' as servernm
     ,j.name as jobnm
     ,jh.step_name as jobstep
     ,jh.run_date
     ,jh.run_time
     ,jh.run_duration as duration
     ,jh.message as contents
     ,instance_id 
     FROM MSDB.DBO.SYSJOBHISTORY JH WITH(NOLOCK)
     INNER JOIN MSDB.DBO.SYSJOBS J WITH(NOLOCK) ON jh.job_id=j.job_id
    WHERE run_status = 0 
     AND step_id>0 
     AND instance_id > @ID_DBJOB

   ) A

INSERT FINDDB1.LOGDB.DBO.MT_DBJOB_FAILURE_TB   
SELECT servernm
	,jobnm
	,jobstep
	,LEFT(CAST(run_date AS VARCHAR(20)),4) +'-'+ SUBSTRING(CAST(run_date AS VARCHAR(20)),5,2) +'-'+ SUBSTRING(CAST(run_date AS VARCHAR(20)),7,2) +' '+ISNULL( SUBSTRING(CONVERT(varchar(7),run_time+1000000),2,2) + ':' + SUBSTRING(CONVERT(varchar(7),run_time+1000000),4,2),'') as regdt
	,duration
	,contents
	,instance_id
FROM #TMP
	ORDER BY servernm, instance_id
	
set @ROWCOUNT = @@ROWCOUNT
	IF @ROWCOUNT > 0 
	BEGIN
		DECLARE @JOBNM VARCHAR(40)	
		SELECT TOP 1 @JOBNM = JOBNM FROM FINDDB1.LOGDB.dbo.MT_DBJOB_FAILURE_TB  WITH(NOLOCK)  WHERE servernm = 'MEMBERDB' ORDER BY regdt DESC
		SET @MSG = 'MEMBERDB:' + CAST(@ROWCOUNT AS VARCHAR(10)) + '건 스케쥴 오류 발생[' + @JOBNM +']'

		EXECUTE FINDDB1.COMDB1.DBO.PUT_SENDKAKAO_PROC '01052321799', '0230190213', 'MWsms16', @MSG, NULL, NULL, '벼룩시장 DB오류메세지' 		  , @MSG	-- 이현석
		EXECUTE FINDDB1.COMDB1.DBO.PUT_SENDKAKAO_PROC '01087798662', '0230190213', 'MWsms16', @MSG, NULL, NULL, '벼룩시장 DB오류메세지' 		  , @MSG	-- 조재성
		EXECUTE FINDDB1.COMDB1.DBO.PUT_SENDKAKAO_PROC '01049388846', '0230190213', 'MWsms16', @MSG, NULL, NULL, '벼룩시장 DB오류메세지' 		  , @MSG	-- 배정민

--		EXECUTE TAX.COMDB1.DBO.PUT_SENDSMS_PROC '0230190213','FA SYSTEM','개발담당','01031273287',@MSG  -- 정헌수

	END

/* DB 에러로그 취합 및 메세지 발송 */	
	EXEC COMMON.DBO.BAT_MT_DBERROR_TB_INS_PROC
END
GO
/****** Object:  StoredProcedure [dbo].[BAT_TRACESQL_DEV_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : DB 오류 로그
 *  작   성   자 : 정헌수 (HSKKA@MEDIAWILL.COM)
 *  작   성   일 : 2018/12/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC PAPER_NEW.DBO.BAT_MT_DBERROR_TB_INS_PROC
	--PAPER_NEW.DBO.BAT_MT_DBJOB_FAILURE_TB_INS_PROC에서 실행됨
 *************************************************************************************/


CREATE PROC [dbo].[BAT_TRACESQL_DEV_PROC]


AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON




/*
-- Trace 종료
exec sp_trace_setstatus 6, 0	--지정한 추적을 중지
exec sp_trace_setstatus 6, 2	--지정한 추적을 닫고 서버에서 해당 정의를 삭제
go

-- 현재 Trace 정보 확인
SELECT * FROM ::fn_trace_getinfo(default)
*/
BEGIN

	DECLARE @rc INT
	DECLARE @TraceID INT
	DECLARE @TraceFileOver INT = 2
	DECLARE @MaxFileSize BIGINT = 300
	DECLARE @StopTime DATETIME = DATEADD(MI, 1, GETDATE())
	DECLARE @File NVARCHAR(245)
	DECLARE @on BIT = 1

	SET @StopTime = CONVERT(CHAR(10), GETDATE(), 121) + ' 23:59:59'		--종료시간
	SET @File = 'H:\profiler\Mon\TraceSQL_Dev43_' + REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(24), GETDATE(), 120), ':', ''), '-', ''), ' ', '-')

	-- Trace 생성                                                          
	EXEC @rc = sp_trace_create @TraceID OUTPUT, @TraceFileOver, @File, @MaxFileSize, @StopTime                               

	IF (@rc != 0) GOTO ERROR
	
	BEGIN TRY

		-- eventid(10) -  RPC:Completed - RPC(원격 프로시저 호출)가 완료되면 발생
		-- eventid(11) -  RPC:Starting - RPC(원격 프로시저 호출)가 시작되면 발생
		exec sp_trace_setevent @TraceID, 10, 1, @on				-- TextData	
		exec sp_trace_setevent @TraceID, 10, 2, @on				-- BinaryData
		exec sp_trace_setevent @TraceID, 10, 3, @on				-- DatabaseID
		exec sp_trace_setevent @TraceID, 10, 6, @on				-- NTUserName
		exec sp_trace_setevent @TraceID, 10, 8, @on				-- HostName
		exec sp_trace_setevent @TraceID, 10, 9, @on				-- ClientProcessID
		exec sp_trace_setevent @TraceID, 10, 10, @on			-- ApplicationName
		exec sp_trace_setevent @TraceID, 10, 11, @on			-- LoginName
		exec sp_trace_setevent @TraceID, 10, 12, @on			-- SPID
		exec sp_trace_setevent @TraceID, 10, 18, @on			-- CPU
		exec sp_trace_setevent @TraceID, 10, 16, @on			-- Reads
		exec sp_trace_setevent @TraceID, 10, 17, @on			-- Writes
		exec sp_trace_setevent @TraceID, 10, 13, @on			-- Duration
		exec sp_trace_setevent @TraceID, 10, 14, @on			-- StartTime
		exec sp_trace_setevent @TraceID, 10, 15, @on			-- EndTime
		exec sp_trace_setevent @TraceID, 10, 22, @on			-- ObjectID
		exec sp_trace_setevent @TraceID, 10, 25, @on			-- ServerName
		exec sp_trace_setevent @TraceID, 10, 27, @on			-- EventClass
		exec sp_trace_setevent @TraceID, 10, 35, @on			-- DatabaseName

		-- eventid(12) - SQL:BatchCompleted - Transact-SQL 일괄 처리가 완료되면 발생
		-- eventid(13) - SQL:BatchStarting - Transact-SQL 일괄 처리가 시작되면 발생
		exec sp_trace_setevent @TraceID, 12, 1, @on
		exec sp_trace_setevent @TraceID, 12, 2, @on
		exec sp_trace_setevent @TraceID, 12, 3, @on
		exec sp_trace_setevent @TraceID, 10, 6, @on
		exec sp_trace_setevent @TraceID, 12, 8, @on
		exec sp_trace_setevent @TraceID, 12, 9, @on
		exec sp_trace_setevent @TraceID, 12, 10, @on
		exec sp_trace_setevent @TraceID, 12, 11, @on
		exec sp_trace_setevent @TraceID, 12, 12, @on
		exec sp_trace_setevent @TraceID, 12, 18, @on
		exec sp_trace_setevent @TraceID, 12, 16, @on
		exec sp_trace_setevent @TraceID, 12, 17, @on
		exec sp_trace_setevent @TraceID, 12, 13, @on
		exec sp_trace_setevent @TraceID, 12, 14, @on
		exec sp_trace_setevent @TraceID, 12, 15, @on
		exec sp_trace_setevent @TraceID, 12, 22, @on
		exec sp_trace_setevent @TraceID, 12, 25, @on
		exec sp_trace_setevent @TraceID, 10, 27, @on
		exec sp_trace_setevent @TraceID, 10, 35, @on
                              
                              
                              
		exec sp_trace_setevent @TraceID, 14, 1, @on
		exec sp_trace_setevent @TraceID, 14, 9, @on
		exec sp_trace_setevent @TraceID, 14, 2, @on
		exec sp_trace_setevent @TraceID, 14, 6, @on
		exec sp_trace_setevent @TraceID, 14, 10, @on
		exec sp_trace_setevent @TraceID, 14, 14, @on
		exec sp_trace_setevent @TraceID, 14, 11, @on
		exec sp_trace_setevent @TraceID, 14, 12, @on
		exec sp_trace_setevent @TraceID, 20, 1, @on
		exec sp_trace_setevent @TraceID, 20, 9, @on
		exec sp_trace_setevent @TraceID, 20, 6, @on
		exec sp_trace_setevent @TraceID, 20, 10, @on
		exec sp_trace_setevent @TraceID, 20, 14, @on
		exec sp_trace_setevent @TraceID, 20, 11, @on
		exec sp_trace_setevent @TraceID, 20, 12, @on
		exec sp_trace_setevent @TraceID, 15, 15, @on
		exec sp_trace_setevent @TraceID, 15, 16, @on
		exec sp_trace_setevent @TraceID, 15, 9, @on
		exec sp_trace_setevent @TraceID, 15, 17, @on
		exec sp_trace_setevent @TraceID, 15, 6, @on
		exec sp_trace_setevent @TraceID, 15, 10, @on
		exec sp_trace_setevent @TraceID, 15, 14, @on
		exec sp_trace_setevent @TraceID, 15, 18, @on
		exec sp_trace_setevent @TraceID, 15, 11, @on
		exec sp_trace_setevent @TraceID, 15, 12, @on
		exec sp_trace_setevent @TraceID, 15, 13, @on                              
		-- 필요없는 명령어 필터링
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_reset_connection%'
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_execute%'
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_unprepare%'
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_oledb_ro_usrname%'
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'select collationname(0x1204D00000)%'
		--exec sp_trace_setfilter @TraceID, 11, 0, 0, N'sqlmonitor'		--column_ID = LoginName 지정


		exec sp_trace_setfilter @TraceID, 11, 0, 6, N'dev%'
		--exec sp_trace_setfilter @TraceID, 18, 0, 4, 1000					--column_ID = CPU
		--exec sp_trace_setfilter @TraceID, 3, 0, 0, 28					--column_ID = DatabaseID         

		/*                              
		exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Profiler'		--column_ID = ApplicationName                     
		exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL 프로필러'                              
		exec sp_trace_setfilter @TraceID, 10, 0, 7, N'MS SQLEM'                              
		exec sp_trace_setfilter @TraceID, 12, 0, 4, 50					--column_ID = SPID                  
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'select 504%'		--column_ID = TextData                
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'select @@%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'SET TEXTSIZE%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'set showplan%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'set NOEXEC%'             
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'set nocount%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'set lock_timeout% '                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'select IS_SRVROLEMEMBER%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_reset%'                 
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%sp_MS%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%sp_help%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%dbo.sysindexes%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%dbo.syscolumns%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%sysobjects%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'%dbo.sysusers%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'select SERVERPROPERTY%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'dbcc%'                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N'exec sp_cursorfetch%'
		*/

		-- Trace 실행
		EXEC sp_trace_setstatus @TraceID, 1
		   
	END TRY
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT
			@ErrorMessage = ERROR_MESSAGE()
		,	@ErrorSeverity = ERROR_SEVERITY()
		,	@ErrorState = ERROR_STATE();

		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

	END CATCH
                           

	SELECT 'ID=' + CAST(@TraceID AS VARCHAR(10))
	GOTO FINISH

	ERROR:                               
		SELECT 'Err=' + CAST(@rc AS VARCHAR(10))
	FINISH:                              
		RETURN

END




END  




GO
/****** Object:  StoredProcedure [dbo].[Common_MemberActProc]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Common_MemberActProc]
(
		@strUserID			varchar(30)
)
AS

/*************************************************************************************
  휴면계정 Active상태로 변경
*************************************************************************************/
	UPDATE UserCommon SET
			DelFlag	=	 '0'
		,	DelDate	= NULL
	WHERE 	UserID = @strUserID
GO
/****** Object:  StoredProcedure [dbo].[Common_MemberCompanyBUserGbn]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************
	프로시저 명 	: Common_MemberCompanyBUserGbn
	작성자				: 김경희 
	작성일				: 2003.02.25
	내용					: 기업회원 구분, 유료회원등급 가져오기
***************************************************************/

--DROP PROC dbo.Common_MemberCompanyBUserGbn
CREATE PROC [dbo].[Common_MemberCompanyBUserGbn]
	@UserID varchar(50)

AS

	SELECT BUserGbn
	FROM Common.dbo.UserJobCompany with (Nolock)
	WHERE UserID=@UserID
GO
/****** Object:  StoredProcedure [dbo].[Common_MemberInActProc]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE			PROCEDURE [dbo].[Common_MemberInActProc]
(
		@strUserID			varchar(30)
)
AS

/*************************************************************************************
  휴면계정상태로 변경
*************************************************************************************/
	UPDATE A SET 
		DelFlag='2',
		DelDate='getdate()'
	FROM UserCommon A, RestUserEnd_Daily B
	WHERE A.UserID = B.UserID
		AND B.UserID = @strUserID
GO
/****** Object:  StoredProcedure [dbo].[Common_MemberLoginInfo_cocofun]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************
	제목		: 로그인 정보 남기기
	작성자	: 김경희 2003.07.07
	수정자 : 김준범 2004.11.11
*****************************************************************/
CREATE PROCEDURE [dbo].[Common_MemberLoginInfo_cocofun]
	 @UserID	varchar(50)
	,@InsChannel	varchar(10)
	,@IpAddr 	varchar(20)
AS


IF (@InsChannel = '')										
	BEGIN
		SET @InsChannel = 'FindAll'
	END


	UPDATE UserCommon
	SET LoginTime = Getdate()
			, LoginSite = @InsChannel
			, IPAddr		= @IpAddr
			, VisitDay = Convert(varchar(10),GetDate())
			, VisitCnt = VisitCnt + 1
	WHERE UserID=@UserID
GO
/****** Object:  StoredProcedure [dbo].[Common_MemberOutProc]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
	제목		:	회원 탈퇴
	작성자	: 김준범	2004.11.25
	수정자	: 이혜민	2005.03.30 (UserAllPerson_Del 테이블에 Insert부분.. 수정)
	실행예	: Exec dbo.Common_MemberOutProc 'pocrow','local.findall.co.kr', '2', ''

*******************************************************************/

CREATE PROCEDURE [dbo].[Common_MemberOutProc]
	 @UserID	varchar(50)
	,@FaHost	varchar(50)
	,@DelReason	varchar(10)
	,@SiteNm	varchar(40)
	,@JuminNo	varchar(20)

AS

DECLARE @DelChannel varchar(10)		--탈퇴섹션
DECLARE @DelLocalSite int		--탈퇴지역
DECLARE @InsChannel varchar(10)		--현재Host의 섹션
DECLARE @FaHostYN tinyint		--호스트의 존재 유무

SET @FaHostYN = (SELECT Count(Host) FROM FindAllHost WHERE Host = @FaHost)

IF (@FaHostYN = 0)										--받은 인자값의 Host가 없을 경우
	BEGIN
		SET @FaHost = 'www.findall.co.kr'
	END

	--탈퇴 처리
	UPDATE UserCommon
	SET DelChannel = CASE B.InsChannel WHEN '' THEN 'FindAll' ELSE B.InsChannel END, 
			DelLocalSite= CASE B.LocalSite WHEN '' THEN '0' ELSE B.LocalSite END, 
			DelFlag = 1, 
			DelDate = Convert(varchar(10),GetDate(),120)
	FROM UserCommon A, (SELECT InsChannel,LocalSite FROM FindAllHost WHERE Host = @FaHost ) B
	WHERE A.UserID = @UserID


	-- 현재Host의 섹션을 UserAllPerson_Del 테이블에 insert시키기 위해 변수에 담아둔다.
	SELECT @InsChannel = InsChannel FROM UserCommon WHERE UserId = @UserID

	-- 탈퇴섹션을 UserAllPerson_Del 테이블에 insert시키기 위해 변수에 담아둔다.
	SELECT @DelChannel = InsChannel FROM FindAllHost WHERE Host = @FaHost


	--UserAllPerson_Del 해당 아이디, 등록일, 탈퇴사유, 가입사이트, 탈퇴사이트를 넣어준다.
	INSERT INTO UserAllPerson_Del (UserID, RegDate, DelDate, InsChannel, DelChannel, DelReason, SiteNm)
	VALUES (@UserID, Convert(varchar(10),GetDate(),120), GetDate() , @InsChannel , @DelChannel , @DelReason , @SiteNm )

	--1개월간 탈퇴회원 재가입 방지를 위한 주민번호저장
	INSERT INTO UserCommonDel_Log (JuminNo) VALUES (@JuminNo)
GO
/****** Object:  StoredProcedure [dbo].[Common_UniqueCheckUserID]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
	제목		:	회원 아이디 중복 검사 
	작성자	: 김경희	2003.07.07
*******************************************************************/
--drop PROCEDURE dbo.Common_UniqueCheckUserID
CREATE PROCEDURE [dbo].[Common_UniqueCheckUserID]
	@UserID		varchar(50)
AS
/* 업소회원 ---> 기업회원으로 전환하면서 임시로 막아 놓았음 2003.12.29 김준범

	SELECT count(UserID) AS intMemberCnt
	FROM Common.dbo.UserCommon with (Nolock)
	WHERE UserID=@UserID AND PartnerGbn = 0
*/

/*
	SELECT count(UserID) AS intMemberCnt
	FROM Common.dbo.vi_UserCommon
	WHERE UserID=@UserID
*/

	SELECT count(UserID) AS intMemberCnt FROM UserCommon
	WHERE  UserID=@UserID
GO
/****** Object:  StoredProcedure [dbo].[Common_UserLoginInfo]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************
	제목		: 로그인 정보 남기기
	작성자	:	김경희 2003.07.07
*****************************************************************/
CREATE PROCEDURE [dbo].[Common_UserLoginInfo]
	@UserID	varchar(50)
	,@Channel	varchar(20)
AS
	Update UserCommon
	Set LoginTime = getdate()
		, LoginSite = @Channel
	Where UserID=@UserID
GO
/****** Object:  StoredProcedure [dbo].[CUID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  단위 업무 명 : 회원통합 > 아이디 변경
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016/08/03
 *  설       명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 :
                 EXEC USERID_CHANGE_ALL_PROC 'ANYCALL512', 'ANYCALL512','111.111.111.111'

 *************************************************************************************/
CREATE PROCEDURE [dbo].[CUID_CHANGE_PROC]
  @MASTER_CUID			INT         =  0      -- 기존아이디
  ,@MASTER_USERID		VARCHAR(50) =  ''     -- 기존아이디
  ,@SLAVE_CUID			INT			=  0      --  변경 아이디
  ,@CLIENT_IP			VARCHAR(20) = ''

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	UPDATE A SET CUID=@MASTER_CUID FROM BadUserCheck A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM m25event A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM MM_SENDMAIL_REST_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM BadUser A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM MM_REST_CONFIRM_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM MM_LONGTERM_UNUSED_TB A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM CompanyHistory A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM DelUserID_Daily A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM UserHouse A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM TEMP_USERCOMMON_M25 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM TEMP_USERCOMMON_PARTNER A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM UserAlba A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM UserJobPerson A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM DelUserPre_Daily A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM RestUserPre_Daily A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM UserCommPusan1 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM UserCommPusan2 A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM MultiLogin A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM DelTargetUserID A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM UserTown A  where CUID=@SLAVE_CUID
	UPDATE A SET CUID=@MASTER_CUID FROM UserJobPayHistory A  where CUID=@SLAVE_CUID

/*
	INSERT PAPER_NEW.DBO.CUID_CHANGE_HISTORY_TB (B_CUID, N_CUID, USERID, DB_NAME, USERIP)
		SELECT @MASTER_CUID , @SLAVE_CUID,@MASTER_USERID,DB_NAME(),@CLIENT_IP
*/		
END







GO
/****** Object:  StoredProcedure [dbo].[FA_BranchBank_Insert_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FA_BranchBank_Insert_DelAN]
(
	@Branch int,
	@BankNm   varchar(20),
            @Account   varchar(100),
	@Depositor varchar(20),
	@AdCheck char(1)
)AS
INSERT  INTO BranchBank
	(
	Branch,
	BankNm,
            Account,
	Depositor
--            AdCheck
	)
VALUES
	(
	@Branch,
	@BankNm,
            @Account,
	@Depositor
--	@AdCheck
	)
GO
/****** Object:  StoredProcedure [dbo].[FA_DivStat_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 회원통계 >> 지역별 회원통계 프로시저
	제작자	: 최기원
	제작일	: 2002-04-01
	셜명	: 전체총회원수/지역별
*************************************************************************************/
CREATE PROCEDURE [dbo].[FA_DivStat_DelAN]
(
	@Division	varchar(100)		-- 전국/지역
)
AS
-- 쿼리 시작
DECLARE @strQuery varchar(1000)
SET @strQuery = 
	CASE
		WHEN @Division <> '' AND @Division <> '- 전 국 -' Then
			'SELECT COUNT(*) FROM zipcode A, UserCommon B WHERE A.ZipCode1 = B.Post1 AND A.ZipCode2 = B.Post2  AND A.metro = ''' + @Division + ''';' +
			'SELECT A.city AS metro, COUNT(*) AS CNT ' +
			'FROM zipcode A, UserCommon B ' +
			'WHERE A.ZipCode1 = B.Post1 AND A.ZipCode2 = B.Post2 AND A.metro = ''' + @Division + ''' ' +
			'GROUP BY A.city ' +
			'ORDER BY A.city; '
		ELSE
			'SELECT COUNT( userid ) FROM userCommon; ' +
			'SELECT COUNT(*) FROM zipcode A, UserCommon B WHERE A.ZipCode1 = B.Post1 AND A.ZipCode2 = B.Post2; ' +
			'SELECT metro, COUNT(*) AS CNT ' +
			'FROM zipcode A, UserCommon B ' +
			'WHERE A.ZipCode1 = B.Post1 AND A.ZipCode2 = B.Post2 '+
			'GROUP BY metro '+
			'ORDER BY metro;'
		
	END
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[FA_MagUser_Insert_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FA_MagUser_Insert_DelAN]
(
	@Branch int,
	@MagID varchar(20),
            @MagName varchar(20),
	@PassWord varchar(10),
	@Email varchar(50),
	@MagGbn char(1)
)AS
INSERT  INTO MagUser
	(
	Branch,
	MagID,
            MagName,
	PassWord,
            Email,
	MagGbn
	)
VALUES
	(
	@Branch,
	@MagID,
            @MagName,
	@PassWord,
	@Email,
	@MagGbn
	)
GO
/****** Object:  StoredProcedure [dbo].[FA_MagUser_Mod_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FA_MagUser_Mod_DelAN]
(
  @Serial	int,
  @MagID	varchar(20),
  @MagName	varchar(20),
  @PassWord	varchar(10),
  @Email	varchar(50),
  @MagGbn        char(1)
)
AS
UPDATE MagUser SET
  MagID	            = @MagID,
  MagName	= @MagName,
  PassWord	= @PassWord,
  Email		= @Email,
  MagGbn          = @MagGbn
WHERE Serial	= @Serial
GO
/****** Object:  StoredProcedure [dbo].[FA_MagUser_Mod1_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FA_MagUser_Mod1_DelAN]
(
  @Serial	int,
  @MagName	varchar(20),
  @PassWord	varchar(10),
  @Email	varchar(50),
  @MagGbn        char(1)
)
AS
UPDATE MagUser SET
  MagName	= @MagName,
  PassWord	= @PassWord,
  Email		= @Email,
  MagGbn          = @MagGbn
WHERE Serial	= @Serial
GO
/****** Object:  StoredProcedure [dbo].[FA_SexStat_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 회원통계 >> 성별 회원통계 프로시저
	제작자	: 최기원
	제작일	: 2002-03-30
	셜명	: 총회원수/남/여
*************************************************************************************/
CREATE PROCEDURE [dbo].[FA_SexStat_DelAN]
AS
-- 성별 변수
DECLARE @strMParm varchar(10)
SET @strMParm = 1
DECLARE @strFParm varchar(10)
SET @strFParm = 2
-- 쿼리 시작
DECLARE @strQuery varchar(1000)
SET @strQuery = 'SELECT COUNT( userid ) FROM userCommon; ' +
			' SELECT COUNT( userid ) FROM userCommon WHERE AllDelflag = 0 ' +
			' AND Len( LTRIM(juminno) ) = 14' + 
			' AND Substring( juminno, 8, 1 ) = CONVERT( varchar, ' + @strMParm + ') ; ' +
			' SELECT COUNT( userid ) FROM userCommon WHERE AllDelflag = 0 ' +
			' AND Len( LTRIM(juminno) ) = 14' + 
			' AND Substring( juminno, 8, 1 ) = CONVERT( varchar, ' + @strFParm + ') ; '
--PRINT(@strQuery)
EXEC(@strQuery)
GO
/****** Object:  StoredProcedure [dbo].[GET_APP_BRANCH_INFO_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일벼룩시장 지역별 보기(앱)
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2012/11/05
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_APP_BRANCH_INFO_LIST_PROC 1
 *************************************************************************************/


CREATE    PROC [dbo].[GET_APP_BRANCH_INFO_LIST_PROC]
@AREA AS INT
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

--서울
IF @AREA = 1 
   SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(REPLACE(BRANCHAREA,'/','|'),',','|'),'') AS BRANCHAREA, LineTel
    FROM DBO.BRANCH(NOLOCK)
   WHERE BICBRANCH = 2 AND BRANCHCODE<>88
     AND USEYN = 'Y' 
	ORDER BY BRANCHNAME
--경기/인천	 
ELSE IF @AREA = 2	
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(REPLACE(BRANCHAREA,'/','|'),',','|'),'') AS BRANCHAREA, LineTel
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 3 
	 AND BRANCHCODE NOT IN (120,121,124,201,202,203,204)
     AND USEYN = 'Y'
	ORDER BY BRANCHNAME
--경남/부산	 
ELSE IF @AREA = 3
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(REPLACE(BRANCHAREA,'/','|'),',','|'),'') AS BRANCHAREA, LineTel
    FROM DBO.BRANCH(NOLOCK)
	WHERE BICBRANCH = 6 AND BRANCHCODE IN (34,35,25,49,47,79,48,46)
     AND USEYN = 'Y'
	ORDER BY BRANCHNAME
--경북/대구	 
ELSE IF @AREA = 4	 
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(REPLACE(BRANCHAREA,'/','|'),',','|'),'') AS BRANCHAREA, LineTel
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 6 AND BRANCHCODE IN (41,11,39,60,26)
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME
--전라
ELSE IF @AREA = 5 
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(REPLACE(BRANCHAREA,'/','|'),',','|'),'') AS BRANCHAREA, LineTel
    FROM DBO.BRANCH(NOLOCK)
	 WHERE (BICBRANCH = 7 OR BRANCHCODE = 121) AND BRANCHCODE NOT IN (50,121)  --익산/제주제외
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME  
--충청
ELSE IF @AREA = 6	
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(REPLACE(BRANCHAREA,'/','|'),',','|'),'') AS BRANCHAREA, LineTel
    FROM DBO.BRANCH(NOLOCK)
	 WHERE (BICBRANCH = 5 OR BRANCHCODE IN (120,124))
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME
--강원	 
ELSE IF @AREA = 7	
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(REPLACE(BRANCHAREA,'/','|'),',','|'),'') AS BRANCHAREA, LineTel
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 4 
     AND USEYN = 'Y'
    ORDER BY BRANCHNAME
ELSE IF @AREA = 8
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(REPLACE(BRANCHAREA,'/','|'),',','|'),'') AS BRANCHAREA, LineTel
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BRANCHCODE = 121 
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME 
ELSE
  SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(REPLACE(BRANCHAREA,'/','|'),',','|'),'') AS BRANCHAREA, LineTel
    FROM DBO.BRANCH(NOLOCK)
	 WHERE 1 <> 1
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME
GO
/****** Object:  StoredProcedure [dbo].[GET_F_BRANCH_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 안내 - 지점별안내
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_F_BRANCH_DETAIL_PROC '10'

 *************************************************************************************/
CREATE        PROC [dbo].[GET_F_BRANCH_DETAIL_PROC]

	@BRANCHCODE VARCHAR(3) = '0'

AS

	-- 지점정보
	SELECT 
		TOP 1
		BRANCHCODE, 
		BRANCHNAME, 
		ISNULL(BRANCHAREA,'') AS AREA,
		ISNULL(PHONE,'') AS PHONE,
		ISNULL(ENDTIME,'') AS ENDTIME,
		ISNULL(LINETEL,'') AS LINETEL,
		ISNULL(FAX,'') AS LINEFAX,
		ISNULL(BOXTEL,'') AS BOXTEL,
		ISNULL(BOXFAX,'') AS BOXFAX
	FROM 
		DBO.BRANCH TA(NOLOCK)
	WHERE
		TA.BRANCHCODE=@BRANCHCODE
	
	--줄광고 접수용 계좌번호
	SELECT
		BANKNM, ACCOUNT, SUBBANKNO, DEPOSITOR, BANKGBN
	FROM 
		BRANCHBANK (NOLOCK)
	WHERE 
		BRANCH=@BRANCHCODE AND
		BANKGBN IN (1,3)
		
	--박스광고 접수용 계좌번호
	SELECT
		BANKNM, ACCOUNT, SUBBANKNO, DEPOSITOR, BANKGBN
	FROM 
		BRANCHBANK (NOLOCK)
	WHERE 
		BRANCH=@BRANCHCODE AND
		BANKGBN IN (2,3)
GO
/****** Object:  StoredProcedure [dbo].[GET_F_BRANCH_INFO_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 광고신청 - 지점정보 가져오기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/02/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC GET_F_BRANCH_INFO_PROC '16' 

 *************************************************************************************/

CREATE PROC [dbo].[GET_F_BRANCH_INFO_PROC]

	@BRANCHCODE		VARCHAR(3)

AS

	SELECT
		TOP 1
		BRANCHCODE, BRANCHNAME,
		PHONE, FAX,
		LINETEL, EMAIL,
		ISNULL(BOXTEL,'') AS BOXTEL, 
		BOXEMAIL
	FROM 
		FINDDB1.PAPER_NEW.DBO.PP_BRANCH_INFO_TB
	WHERE
		--USEYN = 'Y' AND
		BRANCHCODE = @BRANCHCODE
GO
/****** Object:  StoredProcedure [dbo].[GET_F_BRANCH_PHONE_INFO_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 좌단 - 지점별 전화번호 안내
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_F_BRANCH_PHONE_INFO_PROC 16

 *************************************************************************************/
CREATE        PROC [dbo].[GET_F_BRANCH_PHONE_INFO_PROC]
	@BRANCHCODE	INT
AS
	
	SELECT 
		TOP 1
		LINETEL,	--줄광고전화
		BOXTEL,		--박스광고전화
		PHONE			--고객센터
	FROM
		DBO.BRANCH(NOLOCK)
	WHERE
		BRANCHCODE = @BRANCHCODE
GO
/****** Object:  StoredProcedure [dbo].[GET_F_BRANCH_PHONE_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 벼룩시장 안내 - 전화번호 안내
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_F_BRANCH_PHONE_PROC

 *************************************************************************************/
CREATE         PROC [dbo].[GET_F_BRANCH_PHONE_PROC]
AS

	--서울
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,''), ISNULL(LINETEL,''), ISNULL(BOXTEL,'')
    FROM DBO.BRANCH(NOLOCK)
   WHERE BICBRANCH = 2 AND BRANCHCODE<>73
     AND PLINEYN = 'Y'
	 ORDER BY BRANCHNAME
	
	--경기
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,''), ISNULL(LINETEL,''), ISNULL(BOXTEL,'')
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 3
	 AND BRANCHCODE NOT IN (201,202,203,204)
     AND PLINEYN = 'Y'
	 ORDER BY BRANCHNAME
	
	--강원
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,''), ISNULL(LINETEL,''), ISNULL(BOXTEL,'')
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 4 AND BRANCHCODE NOT IN (57,62)
     AND PLINEYN = 'Y'
   ORDER BY BRANCHNAME
	
	--충청
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,''), ISNULL(LINETEL,''), ISNULL(BOXTEL,'')
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 5 AND BRANCHCODE<>44 AND BRANCHCODE<>45
     AND PLINEYN = 'Y'
	 ORDER BY BRANCHNAME
	
	--경상(영남)
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,''), ISNULL(LINETEL,''), ISNULL(BOXTEL,'')
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 6 AND BRANCHCODE<>61 AND BRANCHCODE <> 26
     AND PLINEYN = 'Y'
	 ORDER BY BRANCHNAME
	
	--전라(호남)
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,''), ISNULL(LINETEL,''), ISNULL(BOXTEL,'')
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 7 AND BRANCHCODE<>51 AND BRANCHCODE<>59 AND BRANCHCODE<>50
     AND PLINEYN = 'Y'
	 ORDER BY BRANCHNAME
	
	--해외
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,''), ISNULL(LINETEL,''), ISNULL(BOXTEL,'')
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 8 AND BRANCHCODE<>51 AND BRANCHCODE<>59
     AND PLINEYN = 'Y'
	 ORDER BY BRANCHNAME
GO
/****** Object:  StoredProcedure [dbo].[GET_F_FOOTER_INFO_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - FOOTER - 지점별 정보 가져오기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/23
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_F_FOOTER_INFO_PROC '16'
 *************************************************************************************/
CREATE     PROC [dbo].[GET_F_FOOTER_INFO_PROC]
	@BRANCHCODE	VARCHAR(3)
AS

	SELECT
		TOP 1
		BIZREGISTNO,
		COMMSERVICENO,
		JOBINFOSERVICENO,
		REPRESENTATIVE,
		PRIVACYOFFICER,
		TAXADDRESS,
		LINETEL,
		BOXTEL,
    CONAME
	FROM 
		DBO.BRANCH
	WHERE
		BRANCHCODE = @BRANCHCODE
GO
/****** Object:  StoredProcedure [dbo].[GET_F_ZIPMAIN_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 광고신청 - 줄/박스광고 게재신청관리 - 광역시도 리스트
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/02/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_F_ZIPMAIN_PROC

 *************************************************************************************/

CREATE    PROC [dbo].[GET_F_ZIPMAIN_PROC]
AS

	SELECT 
		METRO, METROCODE 
	FROM 
		SUBZIPCODE(NOLOCK) 
	GROUP BY 
		METRO, METROCODE
	ORDER BY
		METROCODE
GO
/****** Object:  StoredProcedure [dbo].[GET_F_ZIPSUB_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 프런트 - 광고신청 - 줄/박스광고 게재신청관리 - 시군구 리스트
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/02/18
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_F_ZIPSUB_PROC '11'

 *************************************************************************************/

CREATE    PROC [dbo].[GET_F_ZIPSUB_PROC]
	@METROCODE AS CHAR(2)
AS

	SELECT
		CITYCODE, CITY, BRANCH
	FROM 
		SUBZIPCODE(NOLOCK)
	WHERE
		CITYCODE LIKE @METROCODE+'__'
	GROUP BY
		CITYCODE, CITY, BRANCH
	ORDER BY
		CITYCODE
GO
/****** Object:  StoredProcedure [dbo].[GET_M_BRANCH_CODENAME_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리단 - 광고신청관리 - 줄/박스광고 게재신청관리 - 지점리스트 가져오기
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/02/016
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC GET_M_BRANCH_CODENAME_PROC

 *************************************************************************************/
CREATE    PROC [dbo].[GET_M_BRANCH_CODENAME_PROC]

AS

	SELECT 
		BRANCHCODE, BRANCHNAME
	FROM
		DBO.BRANCH(NOLOCK)
	WHERE
		BRANCHNAME IS NOT NULL
	ORDER BY
		BRANCHNAME ASC
GO
/****** Object:  StoredProcedure [dbo].[GET_M_BRANCH_DETAIL_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 - 벼룩시장정보관리 - 지역벼룩시장안내
 *  작   성   자 : 김동협 (kdhwarfare@mediawill.com)
 *  작   성   일 : 2009/03/03
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC dbo.GET_M_BRANCH_DETAIL_PROC '19'

 *************************************************************************************/
CREATE         PROC [dbo].[GET_M_BRANCH_DETAIL_PROC]
	@BRANCHCODE VARCHAR(3)
AS

	SELECT 
		B.BranchName, 
		B.BranchArea, 
		B.IssuePerWeek, 
		B.TaxAddress, 
		B.LineTel, 
		B.BoxTel, 
		B.Phone, 
		B.Fax, 
		B.BoxFax, 
		B.EndTime, 
		B.Email, 
		B.BoxEmail, 
		B.ReportEmail, 
	
		B.DEADLINEWEEKDAY,
		B.DEADLINEWEEKEND,
		B.BIZREGISTNO,
		B.COMMSERVICENO,
		B.JOBINFOSERVICENO,
		B.REPRESENTATIVE,
		B.PRIVACYOFFICER,
		B.CONAME,

		BB.BankNm, 
		BB.Account, 
		BB.SubBankNo, 
		BB.Depositor, 
		BB.BankGbn,

    B.BRANCHORDER,
    B.CUST_LINE_TEL,
    B.CUST_BOX_TEL
	FROM 
		dbo.Branch B(NOLOCK), dbo.BranchBank BB(NOLOCK)
	WHERE 
		B.BranchCode *= BB.Branch AND 
		B.BranchCode = @BRANCHCODE 
	ORDER BY 
		B.BranchCode
GO
/****** Object:  StoredProcedure [dbo].[GET_M_BRANCH_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 관리자 > 지점별 재취합 리스트
 *  작   성   자 : 김 문 화
 *  작   성   일 : 2012/11/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_M_BRANCH_LIST_PROC 
 *************************************************************************************/


CREATE    PROC [dbo].[GET_M_BRANCH_LIST_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  SELECT BRANCHCODE
        ,BRANCHNAME
    FROM BRANCH
   WHERE USEYN = 'Y'
     AND NOT (BRANCHCODE BETWEEN 120 AND 124) -- e벼룩시장 제외
     AND NOT (BRANCHCODE BETWEEN 200 AND 204) -- 연합지점(중부/서부/남부/북부) 제외
     AND BRANCHCODE <> 50
  ORDER BY BRANCHNAME
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_AUTH_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 본인인증
 *  작   성   자 : 
 *  작   성   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *************************************************************************************/
	
CREATE PROCEDURE [dbo].[GET_MM_MEMBER_AUTH_PROC]

	@MEMBER_ID	VARCHAR(30)	--개인회원아이디

AS

	SELECT COUNT(MEMBER_ID) AS CNT
	  FROM DBO.MM_AUTH_ID_TB 
	 WHERE MEMBER_ID = @MEMBER_ID
GO
/****** Object:  StoredProcedure [dbo].[GET_MO_ALL_BRANCH_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일벼룩시장_전화번호 안내
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2009/04/15
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_MO_ALL_BRANCH_LIST_PROC
 *************************************************************************************/


CREATE    PROC [dbo].[GET_MO_ALL_BRANCH_LIST_PROC]

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


	--서울
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
   WHERE BICBRANCH = 2 AND BRANCHCODE<>88
     AND USEYN = 'Y' 
	 ORDER BY BRANCHNAME
	
	--경기/인천
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 3 
	 AND BRANCHCODE NOT IN (120,121,124,201,202,203,204)
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME
	
	--강원
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 4 
     AND USEYN = 'Y'
    ORDER BY BRANCHNAME
	
	--충청
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE (BICBRANCH = 5 OR BRANCHCODE IN (120,124))
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME
	
	--부산/경남
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 6 AND BRANCHCODE IN (34,35,25,49,47,79,48,46)
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME

	--대구/경북
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 6 AND BRANCHCODE IN (41,11,39,60,26)
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME	 
	
	--전라/제주
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE (BICBRANCH = 7 OR BRANCHCODE = 121) AND BRANCHCODE<>50  --익산제외
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME
	
	--해외
	SELECT BRANCHCODE, BRANCHNAME, ISNULL(BRANCHAREA,'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 8 
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME
GO
/****** Object:  StoredProcedure [dbo].[GET_MO_BANK_INFO_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일벼룩시장_지점 계좌번호 (서울외 지역)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2009/04/15
 *  수   정   자 :
 *  수   정   일 : 2010/11/16
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_MO_BANK_INFO_PROC 16
 *************************************************************************************/


CREATE  PROC [dbo].[GET_MO_BANK_INFO_PROC]

  @BRANCHCODE TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	--줄광고 접수용 계좌번호
  SELECT BANKNM
        ,ACCOUNT
    FROM BRANCHBANK
   WHERE BRANCH = @BRANCHCODE
     AND BANKGBN IN (1,3)
		
	--박스광고 접수용 계좌번호
  SELECT BANKNM
        ,ACCOUNT
    FROM BRANCHBANK
   WHERE BRANCH = @BRANCHCODE
     AND BANKGBN IN (2,3)
GO
/****** Object:  StoredProcedure [dbo].[GET_MO_BANK_INFO_SEOUL_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일벼룩시장_지점 계좌번호 (서울만)
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2010/11/16
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_MO_BANK_INFO_SEOUL_PROC 16
 *************************************************************************************/


CREATE  PROC [dbo].[GET_MO_BANK_INFO_SEOUL_PROC]

  @BRANCHCODE TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	--줄광고 접수용 계좌번호
  SELECT BANKNM
        ,ACCOUNT
    FROM BRANCHBANK
   WHERE BRANCH = @BRANCHCODE
     AND BANKGBN = 3;
		
	--줄광고 접수용 계좌번호 (레크드셋에 의해 한번더...)
  SELECT BANKNM
        ,ACCOUNT
    FROM BRANCHBANK
   WHERE BRANCH = @BRANCHCODE
     AND BANKGBN = 3
GO
/****** Object:  StoredProcedure [dbo].[GET_MO_BRANCH_INFO_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일벼룩시장 지역별 보기
 *  작   성   자 : 
 *  작   성   일 : 2012/09/22
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_MO_BRANCH_INFO_LIST_PROC 2
 *************************************************************************************/


CREATE    PROC [dbo].[GET_MO_BRANCH_INFO_LIST_PROC]
@BICBRANCH AS TINYINT
AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

--서울
IF @BICBRANCH = 1 
   SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(BRANCHAREA,'/','|'),'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
   WHERE BICBRANCH = 2 AND BRANCHCODE<>88
     AND USEYN = 'Y' 
	ORDER BY BRANCHNAME
--경기/인천	 
ELSE IF @BICBRANCH = 2	
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(BRANCHAREA,'/','|'),'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 3 
	 AND BRANCHCODE NOT IN (120,121,124,201,202,203,204)
     AND USEYN = 'Y'
	ORDER BY BRANCHNAME
--경남/부산	 
ELSE IF @BICBRANCH = 3
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(BRANCHAREA,'/','|'),'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	WHERE BICBRANCH = 6 AND BRANCHCODE IN (34,35,25,49,47,79,48,46)
     AND USEYN = 'Y'
	ORDER BY BRANCHNAME
--경북/대구	 
ELSE IF @BICBRANCH = 4	 
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(BRANCHAREA,'/','|'),'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 6 AND BRANCHCODE IN (41,11,39,60,26)
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME
--전라/제주
ELSE IF @BICBRANCH = 5 
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(BRANCHAREA,'/','|'),'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE (BICBRANCH = 7 OR BRANCHCODE = 121) AND BRANCHCODE<>50  --익산제외
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME  
--충청
ELSE IF @BICBRANCH = 6	
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(BRANCHAREA,'/','|'),'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE (BICBRANCH = 5 OR BRANCHCODE IN (120,124))
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME
--강원	 
ELSE IF @BICBRANCH = 7	
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(BRANCHAREA,'/','|'),'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 4 
     AND USEYN = 'Y'
    ORDER BY BRANCHNAME
ELSE 	 
	SELECT BRANCHCODE, REPLACE(BRANCHNAME,'벼룩시장',''), ISNULL(REPLACE(BRANCHAREA,'/','|'),'') AS BRANCHAREA
    FROM DBO.BRANCH(NOLOCK)
	 WHERE BICBRANCH = 8 
     AND USEYN = 'Y'
	 ORDER BY BRANCHNAME
GO
/****** Object:  StoredProcedure [dbo].[GET_MO_BRANCH_LIST_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일벼룩시장_전화번호 안내
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2009/04/15
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_MO_BRANCH_LIST_PROC 2
 *************************************************************************************/


CREATE    PROC [dbo].[GET_MO_BRANCH_LIST_PROC]

  @BICBRANCH TINYINT  -- 2:서울, 3:경기, 4:강원, 5:충청, 6:영남, 7:호남, 8:해외

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON


  SELECT BRANCHCODE
        ,BRANCHNAME
        ,BRANCHAREA
        ,LINETEL
        ,BOXTEL
    FROM BRANCH
   WHERE BICBRANCH = @BICBRANCH
     AND USEYN = 'Y'
     AND NOT (BRANCHCODE BETWEEN 120 AND 124) -- e벼룩시장 제외
     AND BRANCHCODE <> 50
GO
/****** Object:  StoredProcedure [dbo].[GET_MO_BRANCH_PHONE_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 모바일벼룩시장_지점별 대표번호
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2009/04/20
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : EXEC DBO.GET_MO_BRANCH_PHONE_PROC 16
 *************************************************************************************/


CREATE  PROC [dbo].[GET_MO_BRANCH_PHONE_PROC]

  @BRANCHCODE TINYINT

AS

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

	--줄광고 접수용 계좌번호
  SELECT REPLACE(LINETEL,')','-') AS LINETEL
    FROM BRANCH
   WHERE BRANCHCODE = @BRANCHCODE
GO
/****** Object:  StoredProcedure [dbo].[GJ_EDIT_MM_COMPANY_HOSPITAL_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 정보 수정 > 기업 회원
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.10.10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 기업 회원 정보 수정
 *  주 의  사 항 : 기업정보 보유 디비 1)회원DB, 2)파인드잡DB, 3)지역정보DB
		   그러므로 소스상에서 FINDDB4디비 프로시져를 DB연결해서 실행시켜줘야함.

		   --> FINDDB2.DBO.GJ_EDIT_MM_COMPANY_HOSPITAL_PROC
		   --> FINDDB4.JOBMAIN.DBO.EDIT_MM_COMPANY_HOSPITAL_PROC_FINDDB4_PROC)

 *  사 용  소 스 : /MEMBER/JOIN/BIZ_MODIFY.ASP
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GJ_EDIT_MM_COMPANY_HOSPITAL_PROC]
	 @USERID			VARCHAR(50)	-- 회원아이디
	,@COMP_KIND_CD			VARCHAR(30)	-- 병원
	,@MAJOR_CD			VARCHAR(30)	-- 전공	

AS	

	UPDATE	DBO.USERJOBCOMPANY
	   SET  COMP_KIND_CD	= @COMP_KIND_CD
	     ,	MAJOR_CD	= @MAJOR_CD
	 WHERE	USERID = @USERID
GO
/****** Object:  StoredProcedure [dbo].[GJ_EDIT_MM_MEMBER_COMPANY_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 정보 수정 > 기업 회원
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.10.10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 기업 회원 정보 수정
 *  주 의  사 항 : 기업정보 보유 디비 1)회원DB, 2)파인드잡DB, 3)지역정보DB
		   그러므로 소스상에서 FINDDB4디비 프로시져를 DB연결해서 실행시켜줘야함.

		   --> FINDDB2.DBO.EDIT_MM_MEMBER_COMPANY_PROC
		   --> FINDDB4.JOBMAIN.DBO.EDIT_MM_MEMBER_COMPANY_FINDDB4_PROC)

 *  사 용  소 스 : /MEMBER/JOIN/BIZ_MODIFY.ASP
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GJ_EDIT_MM_MEMBER_COMPANY_PROC]
	 @USERID			VARCHAR(50)	-- 회원아이디
	,@PASSWORD			VARCHAR(30)	-- 패스워드		
	,@EMAIL				VARCHAR(50)	-- 이메일주소
	,@URL				VARCHAR(100)	-- 홈페이지주소
	,@PHONE				VARCHAR(30)	-- 전화번호
	,@HPHONE			VARCHAR(30)	-- 휴대폰번호
	,@POST1				VARCHAR(5)	-- 우편번호
	,@POST2				VARCHAR(5)	-- 우편번호
	,@CITY				VARCHAR(20) 	-- 시/군/구
	,@ADDRESS1			VARCHAR(100)	-- 주소1
	,@ADDRESS2			VARCHAR(100)	-- 주소2
	,@REGDATE			VARCHAR(10)	-- 등록일
	,@IPADDR			VARCHAR(20)	-- 회원 로컬IP
	,@MAILCHK			TINYINT		-- 이메일수신여부
	,@SMSCHK			TINYINT		-- SMS수신여부
	,@ONESNAME			VARCHAR(30)	-- 담당자
	,@CAPITAL			VARCHAR(30)	-- 자본금
	,@SELLINGPRICE			VARCHAR(30)	-- 매출액
	,@STAFF			VARCHAR(30)	-- 직원수
	,@PRESIDENT			VARCHAR(30)	-- 대표자
	,@BIZTYPE			VARCHAR(30)	-- 기업형태 (SELECT SRVGBN, SRVCODE,SRVNAME FROM JOBCOMMON.DBO.SERVICECODE WHERE SRVGBN=130)
	,@BIZCODE1          		VARCHAR(10)    	-- 업종코드1 (배치파일 사용 -> JOBCOMMON.DBO.BIZCODE_NA)
	,@BIZCODE2         		VARCHAR(10)    	-- 업종코드2 
	,@BIZCODE3          		VARCHAR(10)   	-- 업종코드3 
	,@WELFAREPGM			VARCHAR(200)	-- 복리후생[MC](기타내용도 포함됨 EX)4대보험,기타,[기타내용])
	,@CONTENTS			VARCHAR(5000)	-- 회사소개
	,@FAXNO				VARCHAR(20)	-- 팩스번호
	,@FOUNDYEAR			VARCHAR(4)	-- 설립년도
	,@LISTSTOCKS			VARCHAR(10)	-- 상장구분
	,@LEADBIZSUB			VARCHAR(100)	-- 주요사업내용
	,@PAYSYSTEM			VARCHAR(10)	-- 급여제도
	,@SUBWAYCODE			VARCHAR(10)	-- 상세교통_지하철노선 (배치파일 사용 -> FINDCOMMON.DBO.STATIONNM)
	,@DETAILLOCATE			VARCHAR(200)	-- 상세교통_추가설명
	,@ADDRESS3 			VARCHAR(200)	-- 주소_번지
	,@COUPONLOCAL			TINYINT = 0	-- 이메일 수신 지역
	,@MAILKIND			VARCHAR(50)	-- 이메일 수신 섹션[MC] (JOB,HOUSE,AUTO,USED,ALL,PAPER,GANHO)
	,@COMP_KIND_CD			VARCHAR(30)	-- 병원
	,@MAJOR_CD			VARCHAR(30)	-- 전공	
	,@SUBWAYEXITNO			VARCHAR(5)	-- 지하철출구
	,@MAP_X				VARCHAR(10)	-- X좌표
	,@MAP_Y				VARCHAR(10)	-- Y좌표
	,@MAP_RESULT_CD		CHAR(2)			-- 좌표결과
AS	

-- 회원디비 업데이트
	UPDATE	DBO.USERCOMMON 
	   SET	 PASSWORD	= @PASSWORD		
		,EMAIL		= @EMAIL			
		,PHONE		= @PHONE			
		,HPHONE		= @HPHONE			
		,POST1		= @POST1			
		,POST2		= @POST2			
		,CITY		= @CITY			
		,ADDRESS1	= @ADDRESS1		
		,ADDRESS2	= @ADDRESS2		
	  	,ADDRESSBUNJI	= @ADDRESS3		
		,URL		= @URL	
		,IPADDR		= @IPADDR			
		,MODDATE	= CONVERT(VARCHAR(10),GETDATE(),120)				
		,EMAILFLAG	= @MAILCHK		
		,SMSFLAG	= @SMSCHK			
		,COUPONLOCAL	= @COUPONLOCAL
		,MAILKIND	= @MAILKIND 	
	 WHERE	USERID = @USERID		       				
	

	UPDATE	DBO.USERJOBCOMPANY
	   SET  ONESNAME	= @ONESNAME			 
		,FAXNO		= @FAXNO				 
		,FOUNDYEAR	= @FOUNDYEAR		 
		,CAPITAL	= @CAPITAL			 
		,SELLINGPRICE 	= @SELLINGPRICE	 
		,STAFF		= @STAFF				 
		,PRESIDENT	= @PRESIDENT		 
		,BIZTYPE	= @BIZTYPE			 
		,LISTSTOCKS	= @LISTSTOCKS		 
		,PAYSYSTEM	= @PAYSYSTEM		 				 
		,BIZCODE1	= @BIZCODE1			
		,BIZCODE2	= @BIZCODE2			 
		,BIZCODE3	= @BIZCODE3			 
		,LEADBIZSUB	= @LEADBIZSUB		 
		,WELFAREPGM	= @WELFAREPGM		 
		,SUBWAYAREA	= @SUBWAYCODE		 
		,DETAILLOCATE	= @DETAILLOCATE	 
		,CONTENTS	= @CONTENTS		
		,COMP_KIND_CD	= @COMP_KIND_CD
		,MAJOR_CD	= @MAJOR_CD
		,SUBWAYEXITNO	= @SUBWAYEXITNO
		,MAP_X = @MAP_X
		,MAP_Y = @MAP_Y
		,MAP_RESULT_CD = @MAP_RESULT_CD

	 WHERE	USERID = @USERID

/*
위치 : FINDDB4.JOBMAIN.DBO.EDIT_MM_MEMBER_COMPANY_FINDDB4_PROC
-- 파인드잡/지역정보 업데이트
	UPDATE	JOBMAIN.DBO.USERJOBCOMPANY
	   SET  ONESNAME	= @ONESNAME			 
		,FAXNO		= @FAXNO				 
		,FOUNDYEAR	= @FOUNDYEAR		 
		,CAPITAL	= @CAPITAL			 
		,SELLINGPRICE 	= @SELLINGPRICE	 
		,STAFF		= @STAFF				 
		,PRESIDENT	= @PRESIDENT		 
		,BIZTYPE	= @BIZTYPE			 
		,LISTSTOCKS	= @LISTSTOCKS		 
		,PAYSYSTEM	= @PAYSYSTEM		 				 
		,BIZCODE1	= @BIZCODE1			
		,BIZCODE2	= @BIZCODE2			 
		,BIZCODE3	= @BIZCODE3			 
		,LEADBIZSUB	= @LEADBIZSUB		 
		,WELFAREPGM	= @WELFAREPGM		 
		,SUBWAYAREA	= @SUBWAYCODE		 
		,DETAILLOCATE	= @DETAILLOCATE	 
		,CONTENTS	= @CONTENTS			 
	 WHERE	USERID = @USERID

	UPDATE	LOCALMAIN.DBO.STOREINFO 
	   SET 	 URL		= @URL					 
		,ONESNAME	= @PRESIDENT		 
		,BIZCODE1    	= @BIZCODE1			 
		,BIZCODE2    	= @BIZCODE2			 
		,BIZCODE3    	= @BIZCODE3			 
		,FAX		= @FAXNO				 
		,CONTENTS	= @CONTENTS			 
		,SUBWAYCODE	= @SUBWAYCODE		 
		,STORESUMMARY	= @LEADBIZSUB		    	
		,MODDATE	= GETDATE() 
	 WHERE	USERID = @USERID			 
*/
GO
/****** Object:  StoredProcedure [dbo].[GJ_EDIT_MM_MEMBER_PERSON_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 정보 수정 > 개인 회원
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.10.10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 개인 회원 정보 수정
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /MEMBER/JOIN/PERSON_MODIFY.ASP
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GJ_EDIT_MM_MEMBER_PERSON_PROC]
	 @USERID			VARCHAR(50)	-- 회원아이디
	,@PASSWORD			VARCHAR(30)	-- 패스워드		
	,@EMAIL				VARCHAR(50)	-- 이메일주소	
	,@PHONE				VARCHAR(30)	-- 전화번호
	,@HPHONE			VARCHAR(30)	-- 휴대폰번호
	,@POST1				VARCHAR(5)	-- 우편번호
	,@POST2				VARCHAR(5)	-- 우편번호
	,@CITY				VARCHAR(20) 	-- 시/군/구
	,@ADDRESS1			VARCHAR(100)	-- 주소1
	,@ADDRESS2			VARCHAR(100)	-- 주소2	
	,@IPADDR			VARCHAR(20)	-- 회원 로컬IP
	,@MAILCHK			TINYINT		-- 이메일수신여부
	,@SMSCHK			TINYINT		-- SMS수신여부
	,@COUPONLOCAL			TINYINT = 0	-- 이메일 수신 지역
	,@MAILKIND			VARCHAR(50)	-- 이메일 수신 섹션[MC] (JOB,HOUSE,AUTO,USED,ALL,PAPER,GANHO)		
		
AS


	UPDATE	DBO.USERCOMMON 
	   SET	 PASSWORD	= @PASSWORD		
		,EMAIL		= @EMAIL			
		,PHONE		= @PHONE			
		,HPHONE		= @HPHONE			
		,POST1		= @POST1			
		,POST2		= @POST2			
		,CITY		= @CITY			
		,ADDRESS1	= @ADDRESS1		
		,ADDRESS2	= @ADDRESS2		
		,IPADDR		= @IPADDR			
		,MODDATE	= CONVERT(VARCHAR(10),GETDATE(),120)
		,EMAILFlag	= @MailChk		
		,SMSFlag	= @SMSChk			
		,COUPONLOCAL	= @COUPONLOCAL
		,MAILKIND	= @MAILKIND 	
	 WHERE	USERID = @USERID
GO
/****** Object:  StoredProcedure [dbo].[GJ_GET_CC_FINDALLHOST_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 가입시 호스트별 구분값 가져오기
 *  작   성   자 : 문해린
 *  작   성   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /MEMBER/LOGIN/LOGINPROC.ASP
 *************************************************************************************/


CREATE              PROCEDURE [dbo].[GJ_GET_CC_FINDALLHOST_PROC]	
	@FAHOST		VARCHAR(30)	-- 호스트명(WWW.FINDJOB.CO.KR)

AS
	SELECT	INSCHANNEL
		,LOCALSITE
	  FROM	DBO.FINDALLHOST WITH(NOLOCK)
	 WHERE	DELFLAG='0'
	   AND	HOST = @FAHOST
GO
/****** Object:  StoredProcedure [dbo].[GJ_GET_MEMBER_FINDID_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
	제목	:	회원 아이디, 패스워드 찾기 
	작성자	: 김경희	2003.07.07
	수정자  : 김준범  2003.11.11
*******************************************************************/
--drop PROCEDURE dbo.GJ_GET_MEMBER_FINDID
CREATE PROCEDURE [dbo].[GJ_GET_MEMBER_FINDID_PROC]
	 @JUMINNO	VARCHAR(15)
	,@USERTYPE	CHAR(1)		--[P:개인회원, B:기업회원]
AS

	IF @USERTYPE = 'P'
	BEGIN
		SELECT	 USERID
			,USERNAME
		  FROM 	DBO.USERCOMMON WITH(NOLOCK)
		 WHERE	JUMINNO = @JUMINNO 
		   AND	USERGBN IN ('1', '3', '4') 
		   AND	PARTNERGBN = 0 
		   AND	DELFLAG = '0' 
	END
	ELSE
	BEGIN
		SELECT 	 U.USERID
			,U.USERNAME 
			,C.ONESNAME
		  FROM 	DBO.USERCOMMON U WITH(NOLOCK)
			JOIN DBO.USERJOBCOMPANY C WITH(NOLOCK) ON U.USERID = C.USERID
		 WHERE 	U.JUMINNO =@JUMINNO
		   AND	U.USERGBN = '2' 
		   AND	U.PARTNERGBN = 0 
		   AND	U.DELFLAG = '0' 

	END
GO
/****** Object:  StoredProcedure [dbo].[GJ_GET_MEMBER_FINDPW_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************
	제목	: 패스워드 찾기 
	작성자	: 김경희	2003.07.07
	수정자	: 김준범	2004.11.11

GJ_GET_MEMBER_FINDPW_PROC '800810-2224125'

SELECT * FROM USERCOMMON WHERE JUMINNO='800810-2224125'
*******************************************************************/

CREATE PROCEDURE [dbo].[GJ_GET_MEMBER_FINDPW_PROC]
 	@JUMINNO	VARCHAR(15)
AS	

		SELECT 	 U.USERID
			,U.USERNAME
			,U.PASSWORD
			,U.EMAIL 
			,ISNULL(C.ONESNAME,'') AS ONESNAME
		  FROM 	DBO.USERCOMMON U WITH(NOLOCK)
			LEFT JOIN DBO.USERJOBCOMPANY C WITH(NOLOCK) ON U.USERID = C.USERID
		 WHERE 	U.JUMINNO =@JUMINNO
		   AND	U.PARTNERGBN = 0 
		   AND	U.DELFLAG = '0'
GO
/****** Object:  StoredProcedure [dbo].[GJ_GET_MM_MEMBER_LOGIN_BUSERGBN_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 로그인 > 기업회원 상세구분 가져오기
 *  작   성   자 : 김경희 
 *  작   성   일 : 2003.07.07
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 기업회원일 경우 상세회원구분 값 가져오기
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /MEMBER/LOGIN/LOGINPROC.ASP
 *************************************************************************************/

CREATE PROC [dbo].[GJ_GET_MM_MEMBER_LOGIN_BUSERGBN_PROC]
	@USERID varchar(50)	-- 회원아이디

AS

	SELECT	BUSERGBN
	  FROM	COMMON.DBO.USERJOBCOMPANY WITH (NOLOCK)
	 WHERE	USERID=@USERID
GO
/****** Object:  StoredProcedure [dbo].[GJ_GET_MM_MEMBER_PERSON_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 개인 회원 정보 가져오기
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.11.09
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 설명을 기재한다.
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *************************************************************************************/


CREATE                   PROCEDURE [dbo].[GJ_GET_MM_MEMBER_PERSON_PROC]
	 @USERID		VARCHAR(50)	-- 회원명

AS
	SELECT   USERID	
		,PASSWORD
		,USERNAME	-- 회원명
 		,JUMINNO	-- 주민번호
		,EMAIL		-- 이메일
		,PHONE		-- 전화번호
		,HPHONE		-- 휴대폰
		,POST1		-- 우편번호
		,POST2
		,CITY		-- 시
		,ADDRESS1	-- 주소
		,ADDRESS2			
		,EMAILFLAG	-- 이메일 수신여부
		,SMSFLAG	-- SMS 수신여부	
		,MAILKIND	-- 이메일 수신 사이트 (간호잡에서 가입시 디폴트 'GANHO'
		,MODDATE	-- 수정일
		,URL		-- 홈페이지
	 FROM	DBO.USERCOMMON WITH(NOLOCK)
	WHERE	USERID = @USERID
GO
/****** Object:  StoredProcedure [dbo].[GJ_GET_MM_MEMBER_UNIQUE_NO_DELLOG_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*******************************************************************
	제목		: 회원 주민번호 중복 검사 
	작성자		: 김준범	2005.04.04
*******************************************************************/
--drop PROCEDURE dbo.GET_MM_MEMBER_UNIQUE_NO_DELLOG_PROC

CREATE PROCEDURE [dbo].[GJ_GET_MM_MEMBER_UNIQUE_NO_DELLOG_PROC]
	@JUMINNO		VARCHAR(15) -- 주민번호
AS
	SELECT	COUNT(JUMINNO) AS JUMINNOCNT
	  FROM	COMMON.DBO.USERCOMMONDEL_LOG WITH(NOLOCK)
	 WHERE	JUMINNO = @JUMINNO
GO
/****** Object:  StoredProcedure [dbo].[GJ_GET_MM_MEMBER_UNIQUE_USERID_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 회원 아이디 중복 중복체크
 *  작   성   자 : 김경희 
 *  작   성   일 : 2003.07.07
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 회원 아이디 중복 중복체크
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GJ_GET_MM_MEMBER_UNIQUE_USERID_PROC]
	@USERID		varchar(50)	-- 회원아이디
AS
/* 업소회원 ---> 기업회원으로 전환하면서 임시로 막아 놓았음 2003.12.29 김준범

	SELECT count(USERID) AS intMemberCnt
	FROM Common.dbo.UserCommon with (Nolock)
	WHERE USERID=@USERID AND PartnerGbn = 0
*/

/*
	SELECT count(USERID) AS intMemberCnt
	FROM Common.dbo.vi_UserCommon
	WHERE USERID=@USERID
*/

	SELECT	COUNT(USERID) AS INTMEMBERCNT 
	  FROM	DBO.USERCOMMON WITH(NOLOCK)
	 WHERE  USERID = @USERID
GO
/****** Object:  StoredProcedure [dbo].[GJ_PUT_BLOCKRESUME_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 개인회원 > 열람차단 기업 설정
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.10.10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 기업 회원 정보 수정 > 연혁
 *  주 의  사 항 : 
 *  사 용  소 스 : /PSERVICE/RESUME/BLOCKRESUME\RESUMEBLOCKON.ASP
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GJ_PUT_BLOCKRESUME_PROC]
	 @PUSERID	VARCHAR(30)	-- 개인회원아이디
	,@BUSERID	VARCHAR(30)	-- 기업회원아이디
AS	
	INSERT INTO	RESUMEBLOCKLIST (
					 PUSERID
					,BUSERID
					,REGDATE
				) VALUES (
					 @PUSERID
					,@BUSERID
					,GETDATE()
				)
GO
/****** Object:  StoredProcedure [dbo].[GJ_PUT_MM_MEMBER_BADUSER_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 불량회원 등록
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.10.10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 불량회원 등록
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GJ_PUT_MM_MEMBER_BADUSER_PROC]
	 @USERID		VARCHAR(50)
	,@CAUTIONFLAG		TINYINT		-- 1:경고, 2:불량
	,@SITE			VARCHAR(20)	-- JOB/HOUSE/AUTO/USED/ALL/PAPER/GANHO
	,@MAGID			VARCHAR(30)
AS	
	
	DECLARE @GETUSERID	TINYINT
	
	-- 존재 여부 체크
	SELECT	@GETUSERID  = COUNT(USERID)
	  FROM	DBO.BADUSER 
	 WHERE	USERID=@USERID
	
	IF ( @GETUSERID = 0 )
	BEGIN 
		INSERT INTO DBO.BADUSER (
					UserID
					,CAUTIONFLAG
					,SITE
					,PROCAGENT
				) VALUES (
					@USERID
					,@CAUTIONFLAG
					,@SITE
					,@MAGID
				)
	END
	ELSE
	BEGIN
		UPDATE	DBO.BADUSER
		   SET   USERID	= @USERID
			,CAUTIONFLAG	= @CAUTIONFLAG   
			,SITE		= @SITE  
			,PROCAGENT	= @MAGID   
		 WHERE	USERID = @USERID
	END

-- 회원디비 > 불량회원 처리
	IF @@ERROR = 0 
	BEGIN
		UPDATE	DBO.USERCOMMON  
		   SET	BADFLAG 	= '1'
			,BADSITE	= @SITE
			,BADDATE	= GETDATE()
			,EMAILFLAG	= 0
			,SMSFLAG	= 0
		 WHERE  UserID = @USERID
	END

----------------------------
-- 히스토리 기록																			
----------------------------		


----------------------------
GO
/****** Object:  StoredProcedure [dbo].[GJ_PUT_MM_MEMBER_COMPANYHISTORY_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 정보 수정 > 기업 회원 > 연혁
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.10.10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 기업 회원 정보 수정 > 연혁
 *  주 의  사 항 : 
 *  사 용  소 스 : /MEMBER/JOIN/BIZ_MODIFY.ASP
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GJ_PUT_MM_MEMBER_COMPANYHISTORY_PROC]
	 @USERID	VARCHAR(50)	-- 회원아이디
	,@I		VARCHAR(10)	-- 리스팅순선
	,@SAVHISYY	VARCHAR(4)	-- 년	
	,@SAVHISMM	VARCHAR(2)	-- 월
	,@SAVHISCONT	VARCHAR(200)	-- 상세내용

AS	
	-- 연혁 첫번째 데이타 입력 시 기존 데이타 삭제
	IF (@I = 0) 
	BEGIN
		DELETE	 
		  FROM	DBO.COMPANYHISTORY
		 WHERE	USERID = @USERID
	END

							
	INSERT INTO DBO.COMPANYHISTORY (		
 					 USERID
					,HISTORYNUM
					,HISTORYYY
					,HISTORYMM
					,HISTORYCONT
				) VALUES (
					 @USERID
					,@I
					,@SAVHISYY
					,@SAVHISMM
					,@SAVHISCONT
				)
GO
/****** Object:  StoredProcedure [dbo].[GJ_PUT_MM_MEMBER_OUT_MAG_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GJ_PUT_MM_MEMBER_OUT_MAG_PROC] 
(
	 @USERID	VARCHAR(50)
	,@DELCHANNEL	VARCHAR(10)		-- 'ganho'
	,@DELREASON  	VARCHAR(40) = ' ' 	-- '관리자삭제('+실제삭제내용+')'
	,@DELETCREASON 	VARCHAR(300) = ' '
	,@DELREASONCHK  VARCHAR(2)		-- '1'
)

AS
	DECLARE @strPassword varchar(20)
	DECLARE @strJuminNo varchar(20)
	DECLARE @strInsChannel varchar(20)
	DECLARE @strUserName varchar(20)
	DECLARE @strEmail varchar(20)
	DECLARE @UserGbn varchar(1)
	DECLARE @DelYear varchar(3)
	DECLARE @UserRegDate varchar(20)
	DECLARE @DelAge int
	
	SELECT	 @strUserName = USERNAME
		,@strPassword = PASSWORD
		,@strJuminNo = JUMINNO
		,@strInsChannel = INSCHANNEL
		,@strEmail = EMAIL
		,@UserRegDate = REGDATE
		,@UserGbn = USERGBN 
	  FROM	USERCOMMON WITH (Nolock)  
	 WHERE	USERID = @USERID


	IF  ( @UserGbn  !=  '2' ) 	--개인 또는 딜러회원만 계산 (기업회원제외)
		BEGIN 		
			SET @DelYear = substring(@strJuminNo,8,1)

			IF  (@DelYear = '1') or (@DelYear = '2')	
				SET @DelAge  = 1900
			ELSE			
				SET @DelAge = 2000

				
			SET @DelAge = @DelAge + Convert(int,substring(@strJuminNo,1,2))
		
			IF ( IsNumeric(@DelAge) = 1 )  AND (@DelAge > '0') 
				SET @DelAge =  datepart(year,getdate()) - @DelAge + 1

			ELSE
				SET @DelAge = 0			
		END
	ELSE
		BEGIN
			SET @DelAge = 0
		END


	--탈퇴 처리	
	IF @DELREASONCHK = '1'
		UPDATE	USERCOMMON 
		   SET	 DelDate = GETDATE()
			,DelFlag = 1
			,DELCHANNEL = @DELCHANNEL
			,DELLOCALSITE = 0 
		 WHERE	USERID = @USERID
	ELSE
		UPDATE	USERCOMMON 
		   SET	 DelDate=getdate()
			,DelFlag=1
			,AllDelFlag=1
			,DELCHANNEL=@DELCHANNEL
			,DELLOCALSITE=0 
		 WHERE	USERID = @USERID

	--UserAllPerson_Del Insert (모든 전문화사이트 공통 사용)

	INSERT 	INTO 	DBO.USERALLPERSON_DEL (
						USERID
						,REGDATE
						,INSCHANNEL
						,DELCHANNEL
						,DELAGE
						,DELREASON
						,DELETC
	) VALUES ( 
						convert(varchar,@USERID)
						,@UserRegDate 
						,@strInsChannel 
						,@DELCHANNEL, convert(int,@DelAge)
						,@DELREASON 
						,@DELETCREASON 
	)
GO
/****** Object:  StoredProcedure [dbo].[GJ_PUT_MM_MEMBER_OUT_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 탈퇴시 회원 인증
 *  작   성   자 : 김준범
 *  작   성   일 : 2004.11.24
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 회원 탈퇴시 회원 인증
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GJ_PUT_MM_MEMBER_OUT_PROC]
	 @USERID	VARCHAR(50)	-- 회원아이디
	,@FAHOST	VARCHAR(50)	-- 호스트 (WWW.FINDALL.CO.KR/WWW.FINDJOB.CO.KR...)
	,@DELREASON	VARCHAR(10)	-- 탈퇴사유
	,@SITENM	VARCHAR(40)	-- 이용예정사이트명(탈퇴사유4번선택시)
	,@JUMINNO	VARCHAR(20)	-- 회원번호(주민번호, 사업자번호)
AS		

	DECLARE @DELCHANNEL VARCHAR(10)		--탈퇴섹션
	DECLARE @DELLOCALSITE INT		--탈퇴지역
	DECLARE @INSCHANNEL VARCHAR(10)		--현재HOST의 섹션
	DECLARE @FAHOSTYN TINYINT		--호스트의 존재 유무
	
	SET @FAHOSTYN = (SELECT COUNT(HOST) FROM FINDALLHOST WHERE HOST = @FAHOST)
	
	-- 받은 인자값의 HOST가 없을 경우
	IF (@FAHOSTYN = 0)	
	BEGIN
		SET @FAHOST = 'www.findall.co.kr'
	END
	
	-- 탈퇴 처리
	UPDATE	DBO.USERCOMMON
	   SET	DELCHANNEL = CASE B.INSCHANNEL	WHEN '' THEN 'FindAll' 
						ELSE B.INSCHANNEL 
						END
		,DELLOCALSITE= CASE B.LOCALSITE WHEN '' THEN '0' 
						ELSE B.LOCALSITE 
						END
		,DELFLAG = 1
		,DELDATE = Convert(VARCHAR(10),GetDate(),120)
	  FROM	DBO.USERCOMMON A 
		,(SELECT INSCHANNEL,LOCALSITE FROM DBO.FINDALLHOST  WHERE HOST = @FAHOST ) B
	 WHERE	A.USERID = @USERID


	-- 현재HOST의 섹션을 UserAllPerson_Del 테이블에 insert시키기 위해 변수에 담아둔다.
	SELECT	@INSCHANNEL = INSCHANNEL 
	  FROM	DBO.USERCOMMON 
	 WHERE	USERID = @USERID

	-- 탈퇴섹션을 UserAllPerson_Del 테이블에 insert시키기 위해 변수에 담아둔다.
	SELECT	@DELCHANNEL = INSCHANNEL 
	  FROM	FINDALLHOST 
	 WHERE	HOST = @FAHOST


	-- USERALLPERSON_DEL 해당 아이디, 등록일, 탈퇴사유, 가입사이트, 탈퇴사이트를 넣어준다.
	INSERT INTO USERALLPERSON_DEL (
					USERID
					,RegDate
					,DelDate
					,INSCHANNEL
					,DELCHANNEL
					,DELREASON
					,SITENM
				) VALUES (
					@USERID
					,Convert(VARCHAR(10),GetDate(),120), GetDate() 
					,@INSCHANNEL 
					,@DELCHANNEL 
					,@DELREASON 
					,@SITENM 	
				)

	-- 1개월간 탈퇴회원 재가입 방지를 위한 주민번호저장
	INSERT INTO DBO.USERCOMMONDEL_Log (JUMINNO) VALUES (@JUMINNO)
GO
/****** Object:  StoredProcedure [dbo].[GJ_PUT_MM_MEMBER_PERSON_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원 가입 > 개인 회원
 *  작   성   자 : 문해린
 *  작   성   일 : 2007.10.10
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 개인 회원 가입
 *  주 의  사 항 : 해당 스토어드 프로시저를 사용함에 있어서의 유의사항을 기재한다.
 *  사 용  소 스 : /MEMBER/JOIN/PERSON_INSERT.ASP
 *************************************************************************************/

CREATE PROCEDURE [dbo].[GJ_PUT_MM_MEMBER_PERSON_PROC]	
	 @USERID			VARCHAR(50)	-- 회원아이디
	,@PASSWORD			VARCHAR(30)	-- 패스워드		
	,@USERNAME			VARCHAR(30)	-- 회원명
	,@JUMINNO			VARCHAR(15)	-- 회원번호(주민번호/사업자등록번호)
	,@REALNAMECHK			CHAR(1)		-- 실명인증여부
	,@EMAIL				VARCHAR(50)	-- 이메일주소	
	,@PHONE				VARCHAR(30)	-- 전화번호
	,@HPHONE			VARCHAR(30)	-- 휴대폰번호
	,@POST1				VARCHAR(5)	-- 우편번호
	,@POST2				VARCHAR(5)	-- 우편번호
	,@CITY				VARCHAR(20) 	-- 시/군/구
	,@ADDRESS1			VARCHAR(100)	-- 주소1
	,@ADDRESS2			VARCHAR(100)	-- 주소2	
	,@IPADDR			VARCHAR(20)	-- 회원 로컬IP
	,@INSCHANNEL			VARCHAR(10)	-- 등록채널	
	,@INSLOCALSITE			VARCHAR(10)	-- 가입경로 (0,1,2,3) --> 간호잡은 지역싸이트가 없기 때문에 '0'	
	,@PARTNERCODE			INT 	-- 제휴사코드	
	,@MAILCHK			TINYINT		-- 이메일수신여부
	,@SMSCHK			TINYINT		-- SMS수신여부
	,@COUPONLOCAL			TINYINT = 0	-- 이메일 수신 지역
	,@MAILKIND			VARCHAR(50)	-- 이메일 수신 섹션[MC] (JOB,HOUSE,AUTO,USED,ALL,PAPER,GANHO)			
AS



  	INSERT INTO UserCommon (
				USERID
				,PASSWORD
				,USERGBN
				,USERNAME
				,JUMINNO
				,REALNAMECHK
				,EMAIL
				,PHONE
				,HPHONE
				,POST1
				,POST2
				,CITY
				,ADDRESS1
				,ADDRESS2
				,REGDATE
				,IPADDR
				,INSCHANNEL
				,INSLOCALSITE
				,PARTNERCODE
				,EMAILFLAG
				,SMSFLAG
--				,COUPONFLAG
				,COUPONLOCAL
				,MAILKIND

			) VALUES (
				 @USERID
				,@PASSWORD
				,'1'
				,@USERNAME
				,@JUMINNO 
				,'1'
				,@EMAIL
				,@PHONE
				,@HPHONE
				,@POST1 
				,@POST2
				,@CITY
				,@ADDRESS1
				,@ADDRESS2
				,CONVERT(VARCHAR(10),GETDATE(),120) 
				,@IPADDR
				,@INSCHANNEL
				,@INSLOCALSITE 
				,@PARTNERCODE 
				,@MAILCHK 
				,@SMSCHK
--				,@COUPONCHK
				,@COUPONLOCAL 
				,@MAILKIND
			)
GO
/****** Object:  StoredProcedure [dbo].[Proc_FreeSpace]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_FreeSpace]
AS

--임시테이블 생성
CREATE TABLE #FreeSpace(
Server varchar(10),
RegDate varchar(10),
Drive char(1), 
MB_Free int)

--FINDDB1 (신문DB)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB1.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB1',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null

--FINDDB2 (공통DB)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB2.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB2',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null


--FINDDB3 (파인드오토/옐로페이지)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB3.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB3',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null


--FINDDB4 (파인드잡)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB4.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB4',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null


--FINDDB5 (파인드알바)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB5.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB5',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null



--FINDDB6 (신문)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB6.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB6',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null


--FINDDB7 (파인드하우스/키워드샵)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB7.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB7',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null


--FINDDB9 (잡/알바 구독서버)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB9.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB9',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null


--FINDDB10 (잡/알바 배포서버)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB10.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB10',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null


--FINDDB11 (파인드하우스)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB11.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB11',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null


--FINDDB12 (파인드하우스 복제)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB12.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB12',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null


--FINDDB13 (파인드유즈드)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec FINDDB13.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'FINDDB13',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null


--CLICKMIND (로그분석서버)
INSERT INTO #FreeSpace (Drive,MB_Free)
exec CLICKMIND.Master.dbo.xp_fixeddrives

UPDATE #FreeSpace
SET Server = 'CLICKMIND',RegDate = Convert(varchar(10),GetDate(),120)
WHERE Server is Null



--10일 이전 자료는 삭제
DELETE FROM FreeSpace
WHERE RegDate < DATEADD(dd,-10,GetDate())

--당일 자료 삭제
DELETE FROM FreeSpace
WHERE RegDate = Convert(varchar(10),GetDate(),120)


INSERT INTO FreeSpace
SELECT * FROM  #FreeSpace

/*
--DB서버 사용량 체크
--각서버DB 서버에 있는 디스크 용량이 @MinSize 보다 작을 경우 관리자(@MagUser) 에게 메세지 보냄 
--하루에 한번 설정되어 있음 (오전 8시)
--FINDDB2.Common.dbo.Proc_FreeSpace (각서버 디스크 사용량 추출)
--여기선 단지 기준치 이하일 경우 메세지 보내기만 함

DECLARE @Msg varchar(100)
DECLARE @SerialMax int
DECLARE @SerialMin int
DECLARE @MagUser1 varchar(10)
DECLATE @MinSize int

SET @MagUser1 = 'jbkim'
SET @MinSize = 4000

SET @SerialMax = (SELECT Max(Serial) FROM FINDDB2_IDC.Common.dbo.FreeSpace Where RegDate = Convert(varchar(10),GetDate(),120))
SET @SerialMin = (SELECT Min(Serial) FROM FINDDB2_IDC.Common.dbo.FreeSpace Where RegDate = Convert(varchar(10),GetDate(),120))


WHILE @SerialMax >= @SerialMin
	BEGIN
		SET @Msg = IsNull(@Msg,'') +  IsNull((SELECT '  [' + Server + ' '  + Drive + ' : '  + Convert(varchar(10),MB_Free ) + 'MB 남음]'
							FROM FreeSpace 
							WHERE RegDate = Convert(varchar(10),GetDate(),120) AND MB_Free < @MinSize AND Serial = @SerialMax),'')
		SET @SerialMax = @SerialMax -1
	END

	IF @Msg = ''
		SET @Msg = '모두 정상입니다.'


		SELECT @Msg



SET @MagUser1 = 'NET SEND ' + @MagUser1 + ' ' + @Msg
EXEC master..xp_cmdshell  @MagUser1



*/
GO
/****** Object:  StoredProcedure [dbo].[procAlbaMain_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: Main 구인정보 리스트
	제작자	: 이창국
	제작일	: 2002-04-13
	셜명	:
*************************************************************************************/

CREATE PROCEDURE [dbo].[procAlbaMain_DelAN] 

@strGbn	char(1) --건수만 구할때와 핫, 프리미엄 리스트 출력할때 구분

AS
BEGIN
	/*
	유료구분 옵션 (OptGbn) - '0' : 일반 , '1' : 핫 , '2' : 프리미엄 , '3' : 엑센트
	*/
	DECLARE @DATE VARCHAR(10)
	SET @DATE = CONVERT(VARCHAR(10), GetDate(),120)
	
	IF @strGbn='1'--핫, 프리미엄 리스트 출력할때 구분
		BEGIN
	
			--지역 코드출력
			SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro 
			FROM FindCommon.dbo.AreaCode; 
		
			--핫, 프리미엄 리스트 출력
			SELECT 	 AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex,
					CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate,
					CONVERT(VARCHAR(10), RegDate, 112) AS RegDate,
					ViewCnt,
					CONVERT(VARCHAR(10), ModDate, 112) AS ModDate,
					OptGbn, 	--OptGbn (유료옵션구분) ==> 0:일반  1:핫정보  2:프리미엄  3:액센트
					OptKind		--OptKind( 리스트옵션구분) ==> 1 : 선택반전 2 : 아이콘 3 : 볼드 4 : 컬러 5 : 블링크
		
			FROM 		JobOffer 
			WHERE 	(OptGbn IN (1, 4) )
				AND CONVERT(VARCHAR(10),OptStDate,120) <= @DATE 
				AND CONVERT(VARCHAR(10),OptEnDate,120) >= @DATE
				AND (DelFlag <> 1)
			ORDER BY RegDate DESC
		END		
	ELSE	---건수
		BEGIN
			--등록된 이력서건수
			SELECT 		Top 1 COUNT(*) AS ResumeCnt 
			FROM 		Resume 
			WHERE 		(DelFlag='0' OR DelFlag='2') AND OpenFlag<>4;
			
			-- 등록된 구인건수
			SELECT 		Top 1 COUNT(*) AS JobOfferCnt 
			FROM 		JobOffer 
			WHERE 	CONVERT(VARCHAR(10), RecEnDate,120) >= @DATE
					AND (DelFlag='0' OR DelFlag='2');
		END		
END
GO
/****** Object:  StoredProcedure [dbo].[procAppCompanytList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 지원업체 리스트
	제작자	: 김종진
	제작일	: 2002-03-29
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procAppCompanytList_DelAN] 
(
	 @PageSize	INT		-- 페이지당 게시물 개수
	,@Page		INT		-- Jump할 페이지
	,@strCkUserID	varchar(30) 	
	,@NowDate	varchar(30)	
	,@strOrderBy	varchar(200)	

)
AS
BEGIN
/*
유료구분 옵션 (OptGbn) -0:일반, 1: 핫정보, 2: 프리미엄, 3: 엑센트
*/
DECLARE @strQuery1 varchar(2000)


BEGIN

	SET @strQuery1=

		'SELECT ' +
		'T1.Serial,T1.JobAdId, T1.RecAdId, T1.AppDate,T1.ProcFlag, T2.AdId,T2.UserID, ' +
		'T2.ShopNm,T2.Title,T2.PayType,T2.Pay,T2.RecEnDate, T2.ViewCnt FROM AppInfo T1, JobOffer T2 '+
		'WHERE T1.PDelFlag= 0 And T1.JobAdId=T2.AdId and T1.UserID='+' '''+@strCkUserID+''' '+
		' AND T2.RecEnDate >= '''+@NowDate+''' '+@strOrderBy+''+ ';'  +' '+	
		
		'SELECT TOP 1 COUNT(T1.Serial) AS Count FROM AppInfo T1, JobOffer T2 WHERE T1.JobAdId = T2.AdId  AND T1.UserID='+' '''+@strCkUserID+''' '+
		'AND T1.PDelFlag= 0  AND T2.RecEnDate < '''+@NowDate+''''+ ';'  +' '+	
		
		'SELECT TOP  ' +  CONVERT(varchar(10), @Page*@PageSize) + ' ' +
		'T1.Serial,T1.JobAdId, T1.RecAdId, T1.AppDate,T1.ProcFlag, T2.AdId,T2.UserID, ' +
		'T2.ShopNm,T2.Title,T2.PayType,T2.Pay,T2.RecEnDate, T2.ViewCnt FROM AppInfo T1, JobOffer T2 '+
		'WHERE T1.PDelFlag= 0 And T1.JobAdId=T2.AdId and T1.UserID='+' '''+@strCkUserID+''' '+
		' AND T2.RecEnDate < '''+@NowDate+''' '+@strOrderBy

END

END
EXEC(@strQuery1)
GO
/****** Object:  StoredProcedure [dbo].[procBookMarkInfo_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/**************************************************************************************************************
	설명	: 북마크 관리
	제작자	: 송혁
	제작일	: 2002-04-30
	셜명	:
		ProcessGubun	 : 이 파라메터의 구분을 통해 각 구문을 실행하게 된다.
				 : NIN	:	INSERT DATA(BookMarkInfoInsertData)
				 : NLP	:	List
				 : NDP	:	DELETE DATA(BookMarkInfoDeleteData)
**************************************************************************************************************/
CREATE PROCEDURE [dbo].[procBookMarkInfo_DelAN]
	@ProcessGubun	CHAR(3),
	@Serial			INT		= NULL,
	@UserID		VARCHAR(50)	= NULL,
	@AdGbn1		CHAR(1)	= NULL,
	@AdGbn2		CHAR(1)	= NULL,
	@AdID			INT		= NULL
AS

	IF @ProcessGubun = 'NIN' GOTO BookMarkInfoInsertData
	IF @ProcessGubun = 'NLP' GOTO BookMarkInfoList
	IF @ProcessGubun = 'NDP' GOTO BookMarkInfoDeleteData
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 변수 선언 @Query(쿼리 스트링) @Where(WHERE 조건절 쿼리 스트링)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @Query VARCHAR(2000),@Where VARCHAR(500)
BEGIN
	BEGIN TRANSACTION
----------------------------------------------------------------------------------------------------------------------------------------------------
-- NIN : INSERT DATA(BookMarkInfoInsertData)
----------------------------------------------------------------------------------------------------------------------------------------------------
BookMarkInfoInsertData:
	IF NOT EXISTS(SELECT Serial FROM BookMarkInfo WHERE AdGbn1=@AdGbn1 AND AdGbn2=@AdGbn2 AND AdID=@AdID)
	BEGIN
		INSERT INTO BookMarkInfo(UserID,AdGbn1,AdGbn2,AdId,RegDate)
		VALUES(@UserID,@AdGbn1,@AdGbn2,@AdId,GETDATE())
	END

	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
-- NLP : List(BookMarkInfoList)
----------------------------------------------------------------------------------------------------------------------------------------------------
BookMarkInfoList:
	SELECT COUNT(B.Serial)
	FROM BookMarkInfo B,JobPds..AlbaPds A
	WHERE A.Serial =* B.AdID
	AND B.UserID = @UserID
	AND B.AdGbn1 = '3'	
	SELECT Gubun=CASE B.AdGbn2 WHEN '1' THEN '알바상식' WHEN '2' THEN '알바풍속도' END,Serial=B.Serial,Subject1=ISNULL(A.Subject1,''),RegDate=B.RegDate,ViewCnt=ISNULL(A.ViewCnt,0),PdsCls=B.AdGbn2,PdsSerial=ISNULL(A.Serial,'')
	FROM BookMarkInfo B,JobPds..AlbaPds A
	WHERE A.Serial =* B.AdID
	AND B.UserID = @UserID
	AND B.AdGbn1 = '3'
	ORDER BY B.RegDate DESC

	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
-- NDP : DELETE DATA(BookMarkInfoDeleteData)
----------------------------------------------------------------------------------------------------------------------------------------------------
BookMarkInfoDeleteData:
	DELETE BookMarkInfo WHERE Serial=@Serial

	RETURN


----------------------------------------------------------------------------------------------------------------------------------------------------
------------			 	COMMIT & ROLLBACK                                              ------------
----------------------------------------------------------------------------------------------------------------------------------------------------
	IF @@ERROR = 0
	BEGIN
		COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procCandidateList]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 지원자 관리 리스트
	제작자	: 김종진
	제작일	: 2002-03-29
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procCandidateList] 
(
	 @SQLOpt	CHAR(1)	--'1':지원자 리스트,'2':1차 합격자
	,@PageSize	INT		-- 페이지당 게시물 개수
	,@Page		INT		-- Jump할 페이지
--	,@strCkUserID	varchar(30) 	
	,@strAdId	varchar(30) 	
	,@strOrderBy	varchar(200)	
	

)
AS
BEGIN
/*
유료구분 옵션 (OptGbn) -0:일반, 1: 핫정보, 2: 프리미엄, 3: 엑센트
*/
DECLARE @strQuery1 varchar(2000)


BEGIN
	IF @SQLOpt = '1' --지원자 리스트

		SET @strQuery1=
			' SELECT COUNT(T1.Serial) AS Count ' +
			'FROM AppInfo T1, Resume T2 '+  
			'WHERE T1.RecAdId *= T2.AdId AND T1.BDelFlag=0 AND T1.JobAdid ='''+@strAdId+''' ' +
			
			'SELECT TOP  ' +  CONVERT(varchar(10), @Page*@PageSize) + ' ' +
			'T1.Serial, T1.AppDate, T1.BDelFlag,T1.PDelFlag,T2.AdId,T2.WorkPlace2,T2.UserID,T2.UserName, '+
			'T2.JuminNo,T2.PayType,T2.Pay,T2.Title,T1.ProcFlag '+ 
			'FROM AppInfo T1, Resume T2 '+  
			'WHERE T1.RecAdId *= T2.AdId AND T1.BDelFlag=0 AND T1.JobAdid ='''+@strAdId+''' '+@strOrderBy

ELSE IF @SQLOpt = '2' --1차합격자

		SET @strQuery1=
			' SELECT COUNT(T1.Serial) AS Count ' +
			'FROM AppInfo T1, Resume T2 '+  
			'WHERE T1.RecAdId *= T2.AdId AND T1.ProcFlag =1 AND T1.BDelFlag=0 AND T1.JobAdid ='''+@strAdId+''' ' +
			
			'SELECT TOP  ' +  CONVERT(varchar(10), @Page*@PageSize) + ' ' +
			'T1.Serial, T1.AppDate, T1.BDelFlag,T1.PDelFlag,T2.AdId,T2.WorkPlace2,T2.UserID,T2.UserName, '+
			'T2.JuminNo,T2.PayType,T2.Pay,T2.Title,T1.ProcFlag '+ 
			'FROM AppInfo T1, Resume T2 '+  
			'WHERE T1.RecAdId *= T2.AdId AND T1.ProcFlag =1 AND T1.BDelFlag=0 AND T1.JobAdid ='''+@strAdId+''' '+@strOrderBy

END

END

EXEC(@strQuery1)
GO
/****** Object:  StoredProcedure [dbo].[procCFUserIns]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
=====================================================================================
'	프 로 시 저 명  : procCFUserIns
'	주          제  : 파인드올&코코펀 회원 통합 
'	작    성    자  : 오 은 주
'	작    성    일  : 2005.05.12
'	프로시저  내용	: 파인드올 회원 Insert
                     
=====================================================================================
*/

CREATE PROCEDURE [dbo].[procCFUserIns]
	@UserId	  		varchar(50),				
	@PassWord	 	  varchar(30),
	@UserGbn	  	char(1),	      	      
	@UserName	  	varchar(30),	      	      
	@JuminNo 	  	varchar(15),	      	      
	@RealNameChk 	char(1),	    
	@Email	  		varchar(50),	      	    
	@Phone	  		varchar(30),	      	      
	@HPhone	  		varchar(30) = null,	      	      
	@Post1	  		varchar(5),	      	      
	@Post2	  		varchar(5),	      	      
	@Address1	  	varchar(100),	      	      
	@Address2	  	varchar(100),	      	      
	@IPAddr	  		varchar(20), 	      
	@InsChannel		varchar(10),	
	@MailChk	  	tinyint,
	@SMSChk	  	  tinyint						      
AS						      
BEGIN							
		INSERT INTO	UserCommon
		            (UserId, PassWord, UserGbn, UserName, JuminNo, RealNameChk, Email, Phone, HPhone, Post1, Post2,
		            Address1,	Address2,	RegDate, IPAddr,	InsChannel, emailFlag, smsFlag)
		VALUES
            		(@UserId, @PassWord, @UserGbn, @UserName, @JuminNo,	@RealNameChk, @Email,	@Phone,	@HPhone,	@Post1,	@Post2,
		            @Address1, @Address2, convert(varchar(10), getdate(), 120), @IPAddr,	@InsChannel, @MailChk, @SMSChk)
END
GO
/****** Object:  StoredProcedure [dbo].[procCFUserIns_m25]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
=====================================================================================
'	프 로 시 저 명  : procCFUserIns_m25
'	주          제  : 파인드올 회원 통합 
'	작    성    자  : 이 수지 
'	작    성    일  : 2007.6.12
'	프로시저  내용	: 파인드올 회원 Insert
                     
=====================================================================================
*/

CREATE PROCEDURE [dbo].[procCFUserIns_m25]
	@UserId	  		varchar(50),				
	@PassWord	 	  varchar(30),
	@UserGbn	  	char(1),	      	      
	@UserName	  	varchar(30),	      	      
	@JuminNo 	  	varchar(15),	      	      
	@RealNameChk 	char(1),	    
	@Email	  		varchar(50),	
	@HPhone	  	varchar(30),      	    
	@Phone	  		varchar(30),	      	      
	@Post1	  		varchar(5),	      	      
	@Post2	  		varchar(5),	      	      
	@Address1	  	varchar(100),	      	      
	@Address2	  	varchar(100),	      	      
	@IPAddr	  		varchar(20), 	      
	@InsChannel		varchar(10),	
	@MailChk	  	tinyint,
	@SMSChk	  	  tinyint						      
AS						      
BEGIN							
	INSERT INTO	UserCommon
	            (UserId, PassWord, UserGbn, UserName, JuminNo, RealNameChk, Email, Phone,HPhone,  Post1, Post2,
	            Address1,	Address2,	RegDate, IPAddr,	InsChannel, emailFlag, smsFlag)
	VALUES
    		(@UserId, @PassWord, @UserGbn, @UserName, @JuminNo,	@RealNameChk, @Email,	@Phone, @HPhone, @Post1,	@Post2,
	            @Address1, @Address2, convert(varchar(10), getdate(), 120), @IPAddr,	@InsChannel, @MailChk, @SMSChk)

	-- 2007-6-15 : 메일 발송을 위해 추가 
	if @MailChk = 1
	     begin
		update UserCommon
		set MailKind = 'm25'
		where userid = @UserId
	      end
END
GO
/****** Object:  StoredProcedure [dbo].[procCFUserIns_m25_test_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
=====================================================================================
'	프 로 시 저 명  : procCFUserIns_m25
'	주          제  : 파인드올 회원 통합 
'	작    성    자  : 이 수지 
'	작    성    일  : 2007.6.12
'	프로시저  내용	: 파인드올 회원 Insert
                     
=====================================================================================
*/

CREATE PROCEDURE [dbo].[procCFUserIns_m25_test_DelAN]
	@UserId	  		varchar(30),				
	@PassWord	 	  varchar(30),
	@UserGbn	  	char(1),	      	      
	@UserName	  	varchar(30),	      	      
	@JuminNo 	  	varchar(15),	      	      
	@RealNameChk 	char(1),	    
	@Email	  		varchar(50),	
	@HPhone	  	varchar(30),      	    
	@Phone	  		varchar(30),	      	      
	@Post1	  		varchar(5),	      	      
	@Post2	  		varchar(5),	      	      
	@Address1	  	varchar(100),	      	      
	@Address2	  	varchar(100),	      	      
	@IPAddr	  		varchar(20), 	      
	@InsChannel		varchar(10),	
	@MailChk	  	tinyint,
	@SMSChk	  	  tinyint
							      
AS						      
BEGIN					

	INSERT INTO	UserCommon
	            (UserId, PassWord, UserGbn, UserName, JuminNo, RealNameChk, Email, Phone,HPhone,  Post1, Post2,
	            Address1,	Address2,	RegDate, IPAddr,	InsChannel, emailFlag, smsFlag)
	VALUES
    		(@UserId, @PassWord, @UserGbn, @UserName, @JuminNo,	@RealNameChk, @Email,	@Phone, @HPhone, @Post1, @Post2,
	            @Address1, @Address2, convert(varchar(10), getdate(), 120), @IPAddr,	@InsChannel, @MailChk, @SMSChk)

	if @MailChk = 1
	     begin
		update UserCommon
		set MailKind = 'm25'
		where userid = @UserId
	      end


END
GO
/****** Object:  StoredProcedure [dbo].[procCFUserMod]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/********************************************************************************************************
        명        칭        :       procCFUserMod
        주        제        :      코코펀 통합 회원정보  수정시 UPDATE
        작   성   자        :       황연주
        작   성   일        :      2005. 5. 12
        프로그램내용        :
********************************************************************************************************/
CREATE PROCEDURE [dbo].[procCFUserMod]
(
        @JuminNo             VARCHAR(15)
,       @PassWord           VARCHAR(30)
,       @Email              VARCHAR(50)
,       @Phone              VARCHAR(30)
,       @HPhone              VARCHAR(30) = null
,       @Post1              VARCHAR(5)
,       @Post2              VARCHAR(5)
,       @Address1           VARCHAR(100)
,       @Address2           VARCHAR(100)
,       @IPAddr             VARCHAR(20)
,       @EmailFlag           TINYINT
,       @CouponFlag       TINYINT
,       @CouponLocal     TINYINT
,       @SMS	           TINYINT
)
AS
BEGIN
        UPDATE UserCommon
           SET PassWord = @PassWord
               , Email  = @Email
               , Phone  = @Phone
	  , HPhone  = @HPhone
               , Post1  = @Post1
               , Post2  = @Post2
               , Address1   = @Address1
               , Address2   = @Address2
               , ModDate    = CONVERT(VARCHAR(10), GETDATE(), 120)
               , IPAddr     = @IPAddr
               , EmailFlag  = @EmailFlag
	  ,CouponFlag = @CouponFlag
  	  ,CouponLocal = @CouponLocal
               ,SmsFlag         = @SMS
         WHERE JuminNo = @JuminNo
END
GO
/****** Object:  StoredProcedure [dbo].[procCFUserMod_m25]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/********************************************************************************************************
        명        칭        :       procCFUserMod_m25
        주        제        :      회원정보  수정시 UPDATE
        작   성   자        :      이수지
        작   성   일        :      2007.06.15
        프로그램내용        :
********************************************************************************************************/
CREATE PROCEDURE [dbo].[procCFUserMod_m25]
(
        @JuminNo             VARCHAR(15)
,       @PassWord           VARCHAR(30)
,       @Email              VARCHAR(50)
,       @Phone              VARCHAR(30)
,       @HPhone              VARCHAR(30)
,       @Post1              VARCHAR(5)
,       @Post2              VARCHAR(5)
,       @Address1           VARCHAR(100)
,       @Address2           VARCHAR(100)
,       @IPAddr             VARCHAR(20)
,       @EmailFlag           TINYINT
,       @CouponFlag       TINYINT
,       @CouponLocal     TINYINT
,       @SMS	           TINYINT
)
AS
BEGIN

        declare @strMailKindCnt   varchar(50)

        UPDATE UserCommon
           SET PassWord = @PassWord
               , Email  = @Email
               , Phone  = @Phone
               , HPhone  = @HPhone
               , Post1  = @Post1
               , Post2  = @Post2
               , Address1   = @Address1
               , Address2   = @Address2
               , ModDate    = CONVERT(VARCHAR(10), GETDATE(), 120)
               , IPAddr     = @IPAddr
               , EmailFlag  = @EmailFlag
	  ,CouponFlag = @CouponFlag
  	  ,CouponLocal = @CouponLocal
                ,SmsFlag         = @SMS
         WHERE JuminNo = @JuminNo


     
           if  @EmailFlag  = 1
            begin
	     select  @strMailKindCnt = MailKind from UserCommon WHERE JuminNo = @JuminNo --and MailKind like '%m25%'


	    if  len(@strMailKindCnt) = 0  -- null 

			begin
			   UPDATE UserCommon   SET MailKind =   'm25'  WHERE JuminNo = @JuminNo
			end

	    else   			-- 

		if patindex('%m25%', @strMailKindCnt) = 0 -- m25 없음 : 다른 사이트 
			begin
			   UPDATE UserCommon   SET MailKind =   MailKind + ', m25'  WHERE JuminNo = @JuminNo
			end
		end
	

	end
	   







--END
GO
/****** Object:  StoredProcedure [dbo].[procCFUserMod_m25_test_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/********************************************************************************************************
        명        칭        :       procCFUserMod_m25
        주        제        :      회원정보  수정시 UPDATE
        작   성   자        :      이수지
        작   성   일        :      2005. 5. 12
        프로그램내용        :
********************************************************************************************************/
CREATE PROCEDURE [dbo].[procCFUserMod_m25_test_DelAN]
(
        @JuminNo             VARCHAR(15)
,       @PassWord           VARCHAR(30)
,       @Email              VARCHAR(50)
,       @Phone              VARCHAR(30)
,       @HPhone              VARCHAR(30)
,       @Post1              VARCHAR(5)
,       @Post2              VARCHAR(5)
,       @Address1           VARCHAR(100)
,       @Address2           VARCHAR(100)
,       @IPAddr             VARCHAR(20)
,       @EmailFlag           TINYINT
,       @CouponFlag       TINYINT
,       @CouponLocal     TINYINT
,       @SMS	           TINYINT
)
AS
BEGIN
        declare @strMailKindCnt   varchar(50)

        UPDATE UserCommon
           SET PassWord = @PassWord
               , Email  = @Email
               , Phone  = @Phone
               , HPhone  = @HPhone
               , Post1  = @Post1
               , Post2  = @Post2
               , Address1   = @Address1
               , Address2   = @Address2
               , ModDate    = CONVERT(VARCHAR(10), GETDATE(), 120)
               , IPAddr     = @IPAddr
               , EmailFlag  = @EmailFlag
	  ,CouponFlag = @CouponFlag
  	  ,CouponLocal = @CouponLocal
                ,SmsFlag         = @SMS
         WHERE JuminNo = @JuminNo


     
           if  @EmailFlag  = 1
            begin
	     select  @strMailKindCnt = MailKind from UserCommon WHERE JuminNo = @JuminNo --and MailKind like '%m25%'


	    if  len(@strMailKindCnt) = 0  -- null 

			begin
			   UPDATE UserCommon   SET MailKind =   'm25'  WHERE JuminNo = @JuminNo
			end

	    else   			-- 

		if patindex('%m25%', @strMailKindCnt) = 0 -- m25 없음 : 다른 사이트 
			begin
			   UPDATE UserCommon   SET MailKind =   MailKind + ', m25'  WHERE JuminNo = @JuminNo
			end
		end
	

	end
GO
/****** Object:  StoredProcedure [dbo].[procCFUserOut]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************************************************
        명        칭        :       procCFUserOut
        주        제        :      코코펀 통합 회원탈퇴시 UPDATE
        작   성   자        :       황연주
        작   성   일        :      2005. 5. 12
        프로그램내용        :
********************************************************************************************************/
CREATE PROCEDURE [dbo].[procCFUserOut]
(
        @JuminNo             VARCHAR(30)
)
AS
BEGIN
        UPDATE UserCommon
           SET DelDate      = CONVERT(VARCHAR(10), GETDATE(), 120)
               , DelFlag    = 1
               , DelChannel = 'Cocopun'
         WHERE JuminNo = @JuminNo
END
GO
/****** Object:  StoredProcedure [dbo].[procDelUserPre]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	PROCEDURE [dbo].[procDelUserPre] 
AS

/*************************************************************************************
  자동탈퇴처리 예정 Temp Table
*************************************************************************************/

TRUNCATE TABLE DelUserPre_Daily

INSERT INTO DelUserPre_Daily (UserID, UserName, Email, RegDate, VisitDay, DelDate)
SELECT UserID, UserName, Email,
	CONVERT(varchar(10), RegDate, 120) AS RegDate, 
	CONVERT(varchar(10), DATEADD(dd,0,VisitDay), 120) AS VisitDay,
	CONVERT(varchar(10), DATEADD(dd,0,DelDate), 120) AS DelDate
  FROM UserCommon
 WHERE PartnerGbn = 0 
   AND DelFlag = '2' 
   AND CONVERT(varchar(10),DATEADD(dd,0,VisitDay),120) >= '2006-09-01'
   AND CONVERT(varchar(10),DATEADD(dd,-10,DATEADD(yy,1,DATEADD(dd,0,DelDate))),120) <= CONVERT(varchar(10),getdate(),120)
 ORDER BY UserID
GO
/****** Object:  StoredProcedure [dbo].[procFindAlbaDetail_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	:맞춤메일 확인
	제작자	: 김종진
	제작일	: 2002-03-21
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procFindAlbaDetail_DelAN]
	 @strUserID		varchar(30)       

AS
BEGIN
	
	SELECT 	OrderMailGbn	
			,JobCode				
			,WorkPlace1		
			,WorkPlace2		
			,LocalBranch	
			,WorkType			
			,WorkTime			
			,PayType				
			,Pay						
			,Sex						
	FROM 		OrderMail

	WHERE 		
			(SendCycle Is Null  Or  RTrim(SendCycle) = '') --맞춤메일은 SendCycle의 데이터가 존재있는것만 출력
			AND  UserID=@strUserID

END
GO
/****** Object:  StoredProcedure [dbo].[procFindAlbaIns_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	:맞춤메일 입력
	제작자	: 김종진
	제작일	: 2002-03-21
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procFindAlbaIns_DelAN]

               
	 @strUserID		varchar(30)        
	,@strOrderMailGbn	char(1)      
	,@strJobCode2		varchar(100)       
	,@strWorkPlace1	varchar(100)    
	,@strWorkPlace2	varchar(100)    
	,@strLocalBranch	varchar(200) 
	,@strWorkType		varchar(100)     
	,@strWorkTime		varchar(100)     
	,@strPayType		varchar(10)        
	,@strPay		varchar(10)            
	,@strSex		varchar(10)            
	,@strRegDate		datetime      
AS
BEGIN
BEGIN TRANSACTION
INSERT	INTO OrderMail
(
			
	UserID				
,	OrderMailGbn	
,	JobCode			
,	WorkPlace1		
,	WorkPlace2		
,	LocalBranch	
,	WorkType			
,	WorkTime			
,	PayType			
,	Pay					
,	Sex	
,	SendCycle
,	RegDate			
)
VALUES
(

	 @strUserID				
	,@strOrderMailGbn	
	,@strJobCode2			
	,@strWorkPlace1		
	,@strWorkPlace2		
	,@strLocalBranch
	,@strWorkType			
	,@strWorkTime			
	,@strPayType			
	,@strPay					
	,@strSex	
	,null				
	,@strRegDate			
)

IF @@ERROR = 0 
	BEGIN
		COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procFindAlbaList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 맞춤검색 리스트
	제작자	: 김종진
	제작일	: 2002-03-19
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/
CREATE PROC [dbo].[procFindAlbaList_DelAN]
	
	@KeyWordSql	varchar(2000)
	,@strTableName  varchar(30)
	
	
	
AS

DECLARE @Sql	varchar(2000)

IF @strTableName='JobOffer'

SET @Sql =

'SELECT  Adid,ModDate,shopNm,Title, pay,RecEnDate, ViewCnt,'  +
' JobCode2, WorkPlace1,WorkPlace2, LocalBranch, WorkType, WorkTime, PayType, Pay, Sex,ViewCnt FROM '+@strTableName +' '+ 
''+ @KeyWordSql +'  ORDER BY AdId'

IF @strTableName='Resume'

SET @Sql =
'SELECT  Adid,ModDate,UserName,JuminNo,Title, pay,RegDate, ViewCnt,PayType, Pay, ViewCnt' +
' FROM '+@strTableName +' ' + @KeyWordSql +' ORDER BY AdId'



EXEC(@Sql)
PRINT(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[procFindAlbaModify_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	:맞춤메일 수정
	제작자	: 김종진
	제작일	: 2002-03-21
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procFindAlbaModify_DelAN]

               
	 @strUserID		varchar(30)        
	,@strOrderMailGbn	char(1)      
	,@strJobCode2		varchar(100)       
	,@strWorkPlace1	varchar(100)    
	,@strWorkPlace2	varchar(100)    
	,@strLocalBranch	varchar(200) 
	,@strWorkType		varchar(100)     
	,@strWorkTime		varchar(100)     
	,@strPayType		varchar(10)        
	,@strPay		varchar(10)            
	,@strSex		varchar(10)            
	,@strRegDate		datetime      
AS
BEGIN
BEGIN TRANSACTION
UPDATE  OrderMail
SET

			
	 OrderMailGbn=@strOrderMailGbn
	,JobCode=@strJobCode2
	,WorkPlace1=@strWorkPlace1
	,WorkPlace2=@strWorkPlace2
	,LocalBranch=@strLocalBranch
	,WorkType=@strWorkType
	,WorkTime=@strWorkTime
	,PayType=@strPayType
	,Pay=@strPay
	,Sex=@strSex
	,SendCycle=null
	,RegDate=@strRegDate
WHERE
	(SendCycle Is Null  Or  RTrim(SendCycle) = '') --맞춤메일은 SendCycle의 데이터가 존재있는것만 출력
	AND	
	UserID= @strUserID				

IF @@ERROR = 0 
	BEGIN
		COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procGuinFind]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구인정보 상세검색
	제작자	: 이창국
	제작일	: 2002-03-13
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGuinFind]
(
	@Page		int
,	@PageSize	int
,	@SubSql	varchar(2000)	-- 검색 쿼리
,	@SortSql	varchar(200)	-- 정렬순서
)
AS

BEGIN

DECLARE @strQuery1 VARCHAR(3000)

--지역 코드출력
SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro 
FROM FindCommon.dbo.AreaCode; 

--첫페이지 핫, 프리미엄 리스트 출력
IF @Page  = 1 
	BEGIN
	SET @strQuery1 = 
			-- 핫 구인정보 리스트
			'SELECT AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, ' +
			'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
			'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
			'ViewCnt, ' +
			'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
			'OptGbn, OptKind ' +
			'FROM   JobOffer ' +
			'WHERE  OptGbn in (1) ' + 
			'AND DelFlag in (0) ' +
			'AND PrnAmtOK in (1) ' +
			'AND CONVERT(VARCHAR(10), RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
			'AND CONVERT(VARCHAR(10), RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' +
			'AND CONVERT(VARCHAR(10),OptStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
			'AND CONVERT(VARCHAR(10),OptEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' + @SubSql +
			'ORDER BY ModDate DESC; ' +
			-- 프리미엄 구인정보 리스트
			'SELECT AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, ' +
			'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
			'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
			'ViewCnt, ' +
			'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
			'OptGbn, OptKind ' +
			'FROM   JobOffer ' +
			'WHERE  OptGbn in (2) ' + 
			'AND DelFlag in (0) ' +
			'AND PrnAmtOK in (1) ' +
			'AND CONVERT(VARCHAR(10), RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
			'AND CONVERT(VARCHAR(10), RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' +
			'AND CONVERT(VARCHAR(10),OptStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
			'AND CONVERT(VARCHAR(10),OptEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' + @SubSql +
			'ORDER BY ModDate DESC; '
	EXEC(@strQuery1)
	END


DECLARE @strQuery2 VARCHAR(2000)
	
--일반정보 출력
	SET @strQuery2 =	
			'SELECT COUNT(*) FROM JobOffer ' +
--기본조건
			'WHERE CONVERT(VARCHAR(10), RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
			'AND CONVERT(VARCHAR(10), RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' +
-- 일반 광고인  경우
			'AND (OptGbn  Not in (1, 2) AND DelFlag in (0,2)  ' +
-- 핫,프리미엄 광고였는데 게재기간이 지난것들
			'OR  (OptGbn   in (1, 2) AND DelFlag = 0 ' +
		            	'AND  (CONVERT(VARCHAR(10),OptStDate,120)  > CONVERT(VARCHAR(10), GetDate(), 120) ' +
			'OR   CONVERT(VARCHAR(10),OptEnDate,120) < CONVERT(VARCHAR(10), GetDate(), 120))) ' +
-- 핫,프리미엄 광고였는데 취소한 것들
			'OR  (OptGbn   in (1, 2) AND DelFlag = 2) ' +
-- 핫,프리미엄 광고였는데 결제 안 한것들
			'OR  (OptGbn   in (1, 2) AND DelFlag = 0 AND PrnAmtOK not in (1))) ' + @SubSql + ' ; ' +
-- 리스트 종류별 조건

			'SELECT Top ' + CONVERT(varchar(10), @Page*@PageSize)  + ' ' + 
			'AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, '  +
			'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
			'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
			'ViewCnt, ' +
			'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
			'OptGbn, OptKind, PrnAmtOk,DelFlag ' +
			'FROM JobOffer ' +
--기본조건
			'WHERE CONVERT(VARCHAR(10), RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
			'AND CONVERT(VARCHAR(10), RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' +
-- 일반 광고인  경우
			'AND ((OptGbn  Not in (1, 2) AND DelFlag in (0,2))  ' +  
-- 핫,프리미엄 광고였는데 게재기간이 지난것들
			'OR  (OptGbn   in (1, 2) AND DelFlag = 0 ' +
			'AND  (CONVERT(VARCHAR(10),OptStDate,120)  > CONVERT(VARCHAR(10), GetDate(), 120) ' +
    		             'OR   CONVERT(VARCHAR(10),OptEnDate,120) < CONVERT(VARCHAR(10), GetDate(), 120))) ' +
-- 핫,프리미엄 광고였는데 취소한 것들
			'OR  (OptGbn   in (1, 2) AND DelFlag = 2) ' +
-- 핫,프리미엄 광고였는데 결제 안 한것들
			'OR  (OptGbn   in (1, 2) AND DelFlag = 0 AND PrnAmtOK not in (1))) ' + @SubSql + ' ' + @SortSql
-- 리스트 종류별 조건
	PRINT(@strQuery2)
	EXEC(@strQuery2)
END
GO
/****** Object:  StoredProcedure [dbo].[procGuinFind_Back_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구인정보 상세검색
	제작자	: 이창국
	제작일	: 2002-04-05
	셜명	:
	PageSize	: 페이지당 게시물 개수
	Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGuinFind_Back_DelAN]
(
@PageSize		INT		-- 페이지당 게시물 개수
,@Page			INT		-- Jump할 페이지
,@FindOpt		CHAR(1)		-- 검색('1':초기화면출력, '2':검색화면 출력)
,@HotOpt		CHAR(1)		-- 핫,프리미엄출력여부조건('1':핫,프리미엄화면출력, '2':검색검색화면출력)
,@UserID		VARCHAR(1000)	-- 사용자ID
,@SQLItem		VARCHAR(1500)	-- WHERE절에 들어갈 검색조건
,@Sort			VARCHAR(100)	-- 정렬
)
AS

BEGIN

	DECLARE @DATE VARCHAR(10)
	SET @DATE = CONVERT(VARCHAR(10), GetDate(),120)

	DECLARE @strQuery varchar(3000)

	IF @FindOpt  = '1' --초기화면 출력
		BEGIN 
			--검색조건 출력
			SET @strQuery = 'SELECT JobCode, WorkPlace1, WorkPlace2, ' +
					'LocalBranch, WorkType, ' +
					'WorkTime, PayType, Pay, Sex ' +
					'FROM OrderMail ' +
					'WHERE (SendCycle Is Null OR RTrim(SendCycle)='''') AND ' + 
					'OrderMailGbn =  ''1'' AND UserID=''' + @UserID + '''  ; '
			EXEC(@strQuery)

		END


		--지역 코드출력
		SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro 
		FROM FindCommon.dbo.AreaCode; 

	IF @HotOpt  = '1' --핫,프리미엄화면출력
		BEGIN
			--핫, 프리미엄 리스트 출력	
			SELECT 	 AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex,
					CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate,
					CONVERT(VARCHAR(10), RegDate, 112) AS RegDate,
					ViewCnt,
					CONVERT(VARCHAR(10), ModDate, 112) AS ModDate,
					OptGbn, OptKind 
			FROM 		JobOffer 
			WHERE 	(OptGbn='1' Or  OptGbn='2') AND
					(CONVERT(VARCHAR(10),OptStDate,120) <= @DATE And CONVERT(VARCHAR(10),OptEnDate,120) >= @DATE)  AND
					(DelFlag = '0') AND PrnAmtOk = '1'
			ORDER BY 	OptGbn;
		END
	ELSE-- 검색검색화면출력
		BEGIN

			--검색조건 출력
			SET @strQuery =	
					'SELECT Top 1 COUNT(*) FROM JobOffer ' +
					'WHERE ' +
					' CONVERT(VARCHAR(10), RecEnDate,120) >= '''+@DATE+ '''' +
					'AND (DelFlag=''0'' OR DelFlag=''2'') '+@SQLItem+' ; ' +
					
					'SELECT Top ' + CONVERT(varchar(10), @Page*@PageSize)  + ' ' + 
					' AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex,  '  +
					'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
					'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate,' +
					'ViewCnt, ' +
					'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
					'OptGbn, OptKind, PrnAmtOk,DelFlag  ' +
					'FROM JobOffer ' +
					'WHERE ' +
					' CONVERT(VARCHAR(10), RecEnDate,120) >= '''+@DATE+ '''' +
					' AND (DelFlag=''0'' OR DelFlag=''2'') ' + 
					@SQLItem + ' ' +
					@Sort

			PRINT(@strQuery)
			EXEC(@strQuery)
		END


END
GO
/****** Object:  StoredProcedure [dbo].[procGuinInfoDetatil_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구인정보 상세보기
	제작자	: 이창국
	제작일	: 2002-04-12
	셜명	:
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGuinInfoDetatil_DelAN] 
(
@AdId	INT
)
AS
BEGIN

BEGIN TRANSACTION

	DECLARE @ViewCnt INT

	--View카운트 올리기
	UPDATE JobOffer SET ViewCnt = ISNULL(ViewCnt,0) + 1 WHERE AdId = @AdId

	SELECT 	UserID
		,ShopNm
		,Manager
		,Email
		,Phone
		,HPhone
		,ZipCode
		,Address1
		,Address2
		,ShopUrl
		,AppDesk
		,RecStDate
		,RecEnDate
		,Title
		,JobCode1
		,JobCode2
		,WorkPlace1
		,WorkPlace2
		,LocalBranch
		,WorkType
		,WorkTime
		,PayType
		,Pay
		,Sex
		,AgeLimit
		,Age1
		,Age2
		,School
		,Career
		,ViewCnt
		,RegDate
		,ModDate
		,EtcData
		,RecProxyGbn
	FROM 	JobOffer 
	WHERE 	AdId = @AdId

	IF @@ERROR = 0 
		BEGIN
		    	COMMIT TRAN
		END
	ELSE
		BEGIN
			ROLLBACK
		END
END
GO
/****** Object:  StoredProcedure [dbo].[procGuinJobKind_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 직종별 구인정보 리스트
	제작자	: 이창국
	제작일	: 2002-03-13
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGuinJobKind_DelAN] 
(
@PageSize		INT		-- 페이지당 게시물 개수
,@Page			INT		-- Jump할 페이지
,@SQLItem		VARCHAR(2000)	-- WHERE절에 들어갈 조건
,@Sort			VARCHAR(100)	-- 정렬
)
AS

BEGIN
/*
유료구분 옵션 (OptGbn) - '0' : 일반 , '1' : 핫 , '2' : 프리미엄 , '3' : 엑센트
*/
	DECLARE @strQuery1 VARCHAR(3000)

	
	--지역 코드출력
	SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro 
	FROM FindCommon.dbo.AreaCode;


	IF @Page  = 1 --첫페이지 핫, 프리미엄 리스트 출력
		BEGIN
	
			--핫, 프리미엄 리스트 출력	
			SET @strQuery1 = 'SELECT AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, ' +
				  	'	     CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
 			             	   	'	     CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
					' 	     ViewCnt, ' +
				    	'	     CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
				 	'	     OptGbn, OptKind ' +
					' FROM   JobOffer  ' +
					'WHERE  OptGbn in (1, 2) ' + 
					'    AND   DelFlag in (0) ' +
					'    AND   PrnAmtOK in (1) ' +
					'    AND   CONVERT(VARCHAR(10), RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
				              '    AND   CONVERT(VARCHAR(10), RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' +
					'    AND   CONVERT(VARCHAR(10),OptStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
    		                                       	'    AND   CONVERT(VARCHAR(10),OptEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' +
					@SQLItem + '' +
 		  			' ORDER BY OptGbn ASC, ModDate DESC; '
			EXEC(@strQuery1)
		END


	DECLARE @strQuery2 VARCHAR(2000)
	
	--일반정보 출력
	SET @strQuery2 =	'SELECT COUNT(*) FROM JobOffer ' +
--기본조건
				'WHERE CONVERT(VARCHAR(10), RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
				'AND CONVERT(VARCHAR(10), RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' +
-- 일반 광고인  경우
				'AND (OptGbn  Not in (1, 2) AND DelFlag in (0,2)  ' +  
-- 핫,프리미엄 광고였는데 게재기간이 지난것들
				'OR  (OptGbn   in (1, 2) AND DelFlag = 0 ' +
			            	'AND  (CONVERT(VARCHAR(10),OptStDate,120)  > CONVERT(VARCHAR(10), GetDate(), 120) ' +
    		                       	'OR   CONVERT(VARCHAR(10),OptEnDate,120) < CONVERT(VARCHAR(10), GetDate(), 120))) ' +
-- 핫,프리미엄 광고였는데 취소한 것들
				'OR  (OptGbn   in (1, 2) AND DelFlag = 2) ' +
-- 핫,프리미엄 광고였는데 결제 안 한것들
				'OR  (OptGbn   in (1, 2) AND DelFlag = 0 AND PrnAmtOK not in (1))) ' +
-- 리스트 종류별 조건
				@SQLItem + '; ' +


				'SELECT Top   ' + CONVERT(varchar(10), @Page*@PageSize)  + ' ' + 
				'AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, '  +
				'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
				'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
				'ViewCnt, ' +
				'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
				'OptGbn, OptKind, PrnAmtOk,DelFlag ' +
				'FROM JobOffer ' +
--기본조건
				'WHERE CONVERT(VARCHAR(10), RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
				'AND CONVERT(VARCHAR(10), RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' +
-- 일반 광고인  경우
				'AND ((OptGbn  Not in (1, 2) AND DelFlag in (0,2))  ' +  
-- 핫,프리미엄 광고였는데 게재기간이 지난것들
				'OR  (OptGbn   in (1, 2) AND DelFlag = 0 ' +
			            	'AND  (CONVERT(VARCHAR(10),OptStDate,120)  > CONVERT(VARCHAR(10), GetDate(), 120) ' +
    		                        	'OR   CONVERT(VARCHAR(10),OptEnDate,120) < CONVERT(VARCHAR(10), GetDate(), 120))) ' +
-- 핫,프리미엄 광고였는데 취소한 것들
				'OR  (OptGbn   in (1, 2) AND DelFlag = 2) ' +
-- 핫,프리미엄 광고였는데 결제 안 한것들
				'OR  (OptGbn   in (1, 2) AND DelFlag = 0 AND PrnAmtOK not in (1))) ' +
-- 리스트 종류별 조건
				@SQLItem + ' ' +
				@Sort
	EXEC(@strQuery2)
	print(@strQuery2)
END
GO
/****** Object:  StoredProcedure [dbo].[procGuinList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구인정보 리스트
	제작자	: 이창국
	제작일	: 2002-03-12
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGuinList_DelAN] 
(
@SQLOpt	CHAR(1)		--'1':직종,'2':지역별,'3':급여별,'4':시간대별,'5':근무형태별,'6':상세검색 
)
AS
BEGIN
	DECLARE @DATE VARCHAR(10)
	SET @DATE = CONVERT(VARCHAR(10), GetDate(),120)
	DECLARE @SQL VARCHAR(1000)

	IF @SQLOpt = '1' --직종검색
		BEGIN
			SET @SQL = 	'SELECT DiSTINCT Code1, CodeNm1, Count(Code1) AS Cnt , OrderNo1 '+
					'FROM AlbaCommon.dbo.JobCode ' +
					'WHERE UseFlag = ''Y'' ' +
					'GROUP BY Code1, CodeNm1, OrderNo1 ' +
					'ORDER BY OrderNo1;  ' +
					'SELECT JobCode1, JobCode2 FROM JobOffer '+
					'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') '+
					' AND CONVERT(VARCHAR(10), RecEnDate,120) >= '''+@DATE+ '''; '+
					'SELECT Code1, Code2, CodeNm1, CodeNm2 ' +
					'FROM AlbaCommon.dbo.JobCode ' +
					'WHERE UseFlag = ''Y'' ' +
					'ORDER BY OrderNo1, OrderNo2 '
		END
	ElSE IF  @SQLOpt = '2' --지역별검색
		BEGIN
			SET @SQL = 	'SELECT LCode, Metro, City  ' +
					'FROM FindCommon.dbo.AreaCode ' +
					'WHERE  UseFlag = ''Y''  ' +
					'ORDER BY LCode ;' + 
					'SELECT WorkPlace1 FROM JobOffer '+
					'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') '+
					' AND CONVERT(VARCHAR(10), RecEnDate,120) >= '''+@DATE+ '''; ' +

					'SELECT AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, ' +
					'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
					'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
					'ViewCnt, ' +
					'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM JobOffer ' +
					'WHERE (OptGbn=''1'' Or  OptGbn=''2'')  ' +
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <= '''+ @DATE+ 
					''' AND CONVERT(VARCHAR(10), OptEnDate,120) >= '''+@DATE+ ''' '+
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn; '
		END
	ElSE IF  @SQLOpt = '3' --급여별검색
		BEGIN
			SET @SQL = 	'SELECT PayType, Pay FROM JobOffer ' +
					'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') '+
					' AND CONVERT(VARCHAR(10), RecEnDate,120) >= '''+@DATE+ '''; '
		END
	ElSE IF  @SQLOpt = '4' --시간대별검색
		BEGIN
			SET @SQL =	'SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro ' +
					'FROM FindCommon.dbo.AreaCode; ' + 
					'SELECT WorkTime FROM JobOffer ' +
					'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') '+
					' AND CONVERT(VARCHAR(10), RecEnDate,120) >= '''+@DATE+ ''' ; '+
					'SELECT AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, ' +
					'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
					'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
					'ViewCnt, ' +
					'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM JobOffer ' +
					'WHERE (OptGbn=''1'' Or  OptGbn=''2'')  ' +
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <= '''+ @DATE+ 
					''' AND CONVERT(VARCHAR(10), OptEnDate,120) >= '''+@DATE+ ''' '+
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn; '

		END
	ElSE IF  @SQLOpt = '5' --근무형태별검색
		BEGIN
			SET @SQL =	'SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro ' +
					'FROM FindCommon.dbo.AreaCode; ' + 
					'SELECT WorkType FROM JobOffer ' +
					'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') '+
					' AND CONVERT(VARCHAR(10), RecEnDate,120) >= '''+@DATE+ ''' ; '+
					'SELECT AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, ' +
					'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
					'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
					'ViewCnt, ' +
					'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM JobOffer ' +
					'WHERE (OptGbn=''1'' Or  OptGbn=''2'')  ' +
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <= '''+ @DATE+ 
					''' AND CONVERT(VARCHAR(10), OptEnDate,120) >= '''+@DATE+ ''' '+
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn; '
		END

	EXEC(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[procGuinList_New]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구인정보 리스트
	제작자	: 이창국
	제작일	: 2002-03-12
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGuinList_New] 
(
@SQLOpt	CHAR(1)		--'1':직종,'2':지역별,'3':급여별,'4':시간대별,'5':근무형태별,'6':상세검색 
)
AS
BEGIN
	DECLARE @SQL VARCHAR(5000)

	IF @SQLOpt = '1' --직종검색
		BEGIN
			SET @SQL = 	'SELECT B.Code1, B.Code2,   B.CodeNm1,  B.CodeNm2, B.OrderNo1,  B.OrderNo2, IsNull(Sum(A.Count), 0) as Cnt ' +
					'FROM  (SELECT B.Code1, B.Code2 as JobCode,  count(*) as Count  ' +
					'	 FROM  AlbaMain.dbo.JobOffer  A,  AlbaCommon.dbo.JobCode  B ' + 
					'	WHERE A.DelFlag  in (0, 2) ' +
					'	     AND B.UseFlag  =  ''Y''' + 
					'	     AND CHARINDEX(CONVERT(VARCHAR(6), B.Code2),  A.JobCode2) > 0 ' +
					'       	     AND  CONVERT(VARCHAR(10), A.RecStDate,120) <=  CONVERT(VARCHAR(10), GetDate(),120) ' +
					'                AND  CONVERT(VARCHAR(10), A.RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) ' +
					' 	group by B.Code1, B.Code2)  A, ' +
					'	AlbaCommon.dbo.JobCode  B ' +
					' WHERE   B.Code2  *=  A.JobCode ' +
					'      AND  B.UseFlag  =  ''Y''' + 
					' Group by B.Code1, B.Code2,   B.CodeNm1,  B.CodeNm2, B.OrderNo1,  B.OrderNo2 ' +
					' Order by B.OrderNo1,  B.OrderNo2, B.Code2,   B.CodeNm1,  B.CodeNm2 ;' 

		END
	ElSE IF  @SQLOpt = '2' --지역별검색
		BEGIN
			SELECT DISTINCT  LEFT(LCode, 2) AS LCode, Metro into #AreaCode
			FROM    FindCommon.dbo.AreaCode

			SET @SQL = 	'SELECT LCode, Metro, City  ' +
					'FROM FindCommon.dbo.AreaCode ' +
					'WHERE  UseFlag = ''Y''  ' +
					'ORDER BY LCode ;' + 

					'SELECT B.LCode,   B.Metro, IsNull(Sum(A.Count), 0) as Cnt ' +
					' FROM  (SELECT B.LCode as LCode, Count(*) as Count ' +
					'	 FROM  AlbaMain.dbo.JobOffer  A, #AreaCode  B ' +
					'	WHERE A.DelFlag  in (0, 2) ' +
					'	     AND CHARINDEX(B.LCode,  A.WorkPlace1) > 0 ' +
					'       	     AND  CONVERT(VARCHAR(10), A.RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(),120) ' +
					'                AND  CONVERT(VARCHAR(10), A.RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) ' +
					'	group by B.Lcode)  A, ' +
					'	#AreaCode  B ' +
					' WHERE   B.LCode  *=  A.LCode  ' +
					' Group by B.LCode,  B.Metro ' +
					' Order by  B.LCode,  B.Metro; ' +

					'SELECT AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, ' +
					'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
					'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
					'ViewCnt, ' +
					'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM JobOffer ' +
					'WHERE OptGbn in (1, 2)  ' +
					' AND  CONVERT(VARCHAR(10), RecStDate,120) <=  CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND  CONVERT(VARCHAR(10), RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <= CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND CONVERT(VARCHAR(10), OptEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1'' ' +
					'ORDER BY OptGbn, ModDate desc ; '
		END
	ElSE IF  @SQLOpt = '3' --급여별검색
		BEGIN
			SET @SQL = 	'SELECT B.PayType, B.Pay, B.PayTypeNm, B.PayNm, count(A.Pay) AS Cnt ' +
					'FROM AlbaMain.dbo.JobOffer  A,   AlbaCommon.dbo.PayTypeCode  B '+
					'WHERE    A.DelFlag  in (0, 2) ' +
					'       AND B.PayType  *=  A.PayType '+
					'       AND B.Pay	         *=  A.Pay	 '+
					'       AND  CONVERT(VARCHAR(10), A.RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(),120) '  +
					'       AND  CONVERT(VARCHAR(10), A.RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) '  +
					'    group by B.PayType, B.Pay, B.PayTypeNm, B.PayNm '  +
					'     order by B.PayType, B.Pay, B.PayTypeNm, B.PayNm ; '
		END
	ElSE IF  @SQLOpt = '4' --시간대별검색
		BEGIN
			SET @SQL =	'SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro ' +
					'FROM FindCommon.dbo.AreaCode; ' + 

					'SELECT B.WorkTime,  B.WorkTimeNm, IsNull(Sum(A.Count), 0) AS Cnt ' +
					'   FROM  (SELECT B.WorkTime as WorkTime, Count(B.WorkTime) as Count  ' +
					'    	      FROM  AlbaMain.dbo.JobOffer  A, AlbaCommon.dbo.WorkTimeCode  B ' +
					'	    WHERE A.DelFlag  in (0, 2) ' +
					'  	           AND CHARINDEX(B.WorkTime,  A.WorkTime) > 0 ' +
					'                      AND  CONVERT(VARCHAR(10), A.RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(),120) ' +
					'                      AND  CONVERT(VARCHAR(10), A.RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) ' +
					'   	    GROUP BY  B.WorkTime)  A, ' + 
					' 	    AlbaCommon.dbo.WorkTimeCode  B ' +
					'WHERE   B.WorkTime  *=  A.WorkTime ' +
					' Group by B.WorkTime,  B.WorkTimeNm ' +
					' Order by  B.WorkTime ; ' +

					'SELECT AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, ' +
					'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
					'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
					'ViewCnt, ' +
					'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM JobOffer ' +
					'WHERE OptGbn in (1,2) ' +
					' AND  CONVERT(VARCHAR(10), RecStDate,120) <=  CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND  CONVERT(VARCHAR(10), RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <= CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND CONVERT(VARCHAR(10), OptEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn, ModDate desc; '

		END
	ElSE IF  @SQLOpt = '5' --근무형태별검색
		BEGIN
			SET @SQL =	'SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro ' +
					'FROM FindCommon.dbo.AreaCode; ' + 

					'SELECT B.WorkType,  B.WorkTypeNm, IsNull(Sum(A.Count), 0) AS Cnt ' +
					'   FROM  (SELECT B.WorkType as WorkType, Count(B.WorkType) as Count  ' +
					'    	      FROM  AlbaMain.dbo.JobOffer  A, AlbaCommon.dbo.WorkTypeCode  B ' +
					'	    WHERE A.DelFlag  in (0, 2) ' +
					'  	          AND CHARINDEX(B.WorkType,  A.WorkType) > 0 ' +
					'                      AND  CONVERT(VARCHAR(10), A.RecStDate,120) <= CONVERT(VARCHAR(10), GetDate(),120) ' +
					'                     AND  CONVERT(VARCHAR(10), A.RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) ' +
					'   	    GROUP BY  B.WorkType)  A, ' + 
					' 	    AlbaCommon.dbo.WorkTypeCode  B ' +
					'WHERE   B.WorkType  *=  A.WorkType ' +
					' Group by B.WorkType,  B.WorkTypeNm ' +
					' Order by  B.WorkType ; ' +

					'SELECT AdId, UserID, ShopNm, Title, WorkPlace1, PayType, Pay, Sex, ' +
					'CONVERT(VARCHAR(10), RecEnDate, 112) AS RecEnDate, ' +
					'CONVERT(VARCHAR(10), RegDate, 112) AS RegDate, ' +
					'ViewCnt, ' +
					'CONVERT(VARCHAR(10), ModDate, 112) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM JobOffer ' +
					'WHERE OptGbn in (1,2)  ' +
					' AND  CONVERT(VARCHAR(10), RecStDate,120) <=  CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND  CONVERT(VARCHAR(10), RecEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <= CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND CONVERT(VARCHAR(10), OptEnDate,120) >= CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn, ModDate desc; '
		END

	EXEC(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[procGujikFind_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구직정보 상세검색
	제작자	: 이창국
	제작일	: 2002-04-05
	셜명	:
	PageSize	: 페이지당 게시물 개수
	Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGujikFind_DelAN]
(
@PageSize		INT		-- 페이지당 게시물 개수
,@Page			INT		-- Jump할 페이지
,@FindOpt		CHAR(1)		-- 검색('1':검색저장출력, '2':핫,프리미엄,검색결과 출력)
,@HotOpt		CHAR(1)		-- 핫,프리미엄출력여부조건('1':핫,프리미엄화면출력, '2':검색검색화면출력)
,@UserID		VARCHAR(1000)	-- 사용자ID
,@SQLItem		VARCHAR(1000)	-- WHERE절에 들어갈 검색조건
,@Sort			VARCHAR(100)	-- 정렬
)
AS

BEGIN

	DECLARE @DATE VARCHAR(10)
	SET @DATE = CONVERT(VARCHAR(10), GetDate(),120)

	DECLARE @strQuery varchar(2000)

	IF @FindOpt  = '1' --초기화면 출력
		BEGIN 
			--검색조건 출력
			SET @strQuery = 'SELECT JobCode, WorkPlace1, WorkPlace2, ' +
					'LocalBranch, WorkType, ' +
					'WorkTime, PayType, Pay, Sex ' +
					'FROM OrderMail ' +
					'WHERE (SendCycle Is Null OR RTrim(SendCycle)='''') AND ' + 
					'OrderMailGbn =  ''2'' AND UserID=''' + @UserID + '''  ; '
			EXEC(@strQuery)
		END
	ELSE --핫,프리미엄,검색결과 출력
		BEGIN

			--지역 코드출력
			SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro 
			FROM FindCommon.dbo.AreaCode; 
		
			IF @HotOpt  = '1' --핫,프리미엄화면출력
				BEGIN
					--핫, 프리미엄 리스트 출력
					SELECT 	AdId, UserID, UserName, JuminNo, Title, PayType, Pay,  ViewCnt, WorkPlace1, 
						CONVERT(VARCHAR(10), RegDate, 120) AS RegDate,
						CONVERT(VARCHAR(10), ModDate, 120) AS ModDate,
						OptGbn, OptKind
					FROM Resume 
					WHERE 	(OptGbn='1' Or  OptGbn='2') AND
							(CONVERT(VARCHAR(10),OptStDate,120) <= @DATE And CONVERT(VARCHAR(10),OptEnDate,120) >= @DATE)  AND
							(DelFlag = '0') AND PrnAmtOk = '1'
					ORDER BY OptGbn;
				END
			ELSE--검색화면출력
				BEGIN
					SET @strQuery =	'SELECT Top 1 COUNT(*) FROM Resume ' +
								'WHERE  (DelFlag = ''0'' OR DelFlag = ''2'')  '+@SQLItem+' ; ' +
								'SELECT Top ' + CONVERT(varchar(10), @Page*@PageSize)  + ' ' + 
								'AdId, UserID, UserName, JuminNo, Title, PayType, Pay,  ViewCnt, WorkPlace1,  '  +
								'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate, ' +
								'CONVERT(VARCHAR(10), ModDate, 120) AS ModDate, ' +
								'OptGbn, OptKind, PrnAmtOk,DelFlag  ' +
								'FROM Resume ' +
								'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') '+
								@SQLItem + ' ' +
								@Sort
					EXEC(@strQuery)
				END

		END


END
GO
/****** Object:  StoredProcedure [dbo].[procGujikInfoDetatil_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구직정보 상세보기
	제작자	: 이창국
	제작일	: 2002-04-12
	셜명	:
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGujikInfoDetatil_DelAN] 
(
@AdId	INT
)
AS
BEGIN

BEGIN TRANSACTION

	DECLARE @ViewCnt INT

	--View카운트 올리기
	SELECT @ViewCnt = ViewCnt FROM Resume WHERE AdId = @AdId

	SET @ViewCnt = (ISNULL (@ViewCnt, 0))
	SET @ViewCnt = @ViewCnt + 1

	UPDATE Resume SET ViewCnt = @ViewCnt WHERE AdId = @AdId

	SELECT 	UserID
		,UserName
		,JuminNo
		,Phone
		,HPhone
		,Email
		,ZipCode
		,Address1
		,Address2
		,Title
		,JobCode1
		,JobCode2
		,WorkPlace1
		,WorkPlace2
		,LocalBranch
		,WorkType
		,WorkTime
		,PayType
		,Pay
		,BeAtWork
		,AtWorkDate
		,OpenFlag
		,SchoolGbn
		,SchoolRecord
		,Career
		,CareerRecord
		,ViewCnt
		,OptGbn
		,OptKind
		,OptStDate
		,OptEnDate
		,OptAmt
		,ChargeKind
		,PrnAmtOk
		,DelFlag
		,RecProxyGbn
		,RecProxy
		,BasicGbn
		,RegDate
		,ModDate
		,MergeText
		,EtcData
		,SelfIntro
	FROM 	Resume 
	WHERE 	AdId = @AdId;

	IF @@ERROR = 0 
		BEGIN
		    	COMMIT TRAN
		END
	ELSE
		BEGIN
			ROLLBACK
		END
END
GO
/****** Object:  StoredProcedure [dbo].[procGujikJobKind_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명		: 직종별 구직정보 리스트
	제작자		: 이창국 
	제작일		: 2002-03-13
	셜명		:
	PageSize	: 페이지당 게시물 개수
	Page		: Jump할 페이지
-------------------------------------------------------------------------------------
	수정자		: 김수정 
	수정일		: 2002-05-12


	 유료구분 옵션 (OptGbn) - '0' : 일반 , '1' : 핫 , '2' : 프리미엄 , '3' : 엑센트 
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGujikJobKind_DelAN]
(
	 @PageSize		INT		-- 페이지당 게시물 개수
	,@Page			INT		-- Jump할 페이지
	,@SQLItem		VARCHAR(1000)	-- WHERE절에 들어갈 조건
	,@Sort			VARCHAR(100)	-- 정렬
)
AS

BEGIN
	DECLARE @strQuery1 varchar(3000)
	DECLARE @strQuery2 varchar(3000)

	--지역 코드출력
	SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro 
	FROM FindCommon.dbo.AreaCode; 


--	IF @Page  = 1 --첫페이지 핫, 프리미엄 리스트 출력
--	BEGIN
		--핫, 프리미엄 리스트 출력	
		SET @strQuery1 = 
				'SELECT AdId, UserID, UserName, JuminNo, Title, PayType, Pay,  ViewCnt, WorkPlace1, ' +
		             	   	'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate, ' +
			    	'CONVERT(VARCHAR(10), ModDate, 120) AS ModDate, ' +
			 	'OptGbn, OptKind ' +
				'FROM   Resume  ' +
				'WHERE  OptGbn in (1, 2) ' + 
				'AND   DelFlag in (0) ' +
				'AND   OpenFlag in (1,2,3) ' +
			 	'AND   PrnAmtOk  in (1) ' +
				'AND   CONVERT(VARCHAR(10),OptStDate,120) <= CONVERT(VARCHAR(10), GetDate(), 120) ' +
    	                                          'AND   CONVERT(VARCHAR(10),OptEnDate,120) >= CONVERT(VARCHAR(10), GetDate(), 120) ' +
				 @SQLItem + '' +
 	  			'ORDER BY OptGbn ASC,ModDate DESC; '
		EXEC(@strQuery1)
		PRINT(@strQuery1)

		--일반정보 출력
		SET @strQuery2 = 
				'SELECT Top 1 COUNT(*) FROM Resume ' +
-- 일반 광고인  경우
				'WHERE OpenFlag in (1,2,3)  AND ((OptGbn  Not in (1, 2) AND DelFlag in (0,2))  ' +  
-- 핫,프리미엄 광고였는데 게재기간이 지난것들
				'OR  (OptGbn   in (1, 2) AND DelFlag = 0 ' +
			            	'AND  (CONVERT(VARCHAR(10),OptStDate,120)  > CONVERT(VARCHAR(10), GetDate(), 120) ' +
    		                        	'OR   CONVERT(VARCHAR(10),OptEnDate,120) < CONVERT(VARCHAR(10), GetDate(), 120))) ' +
-- 핫,프리미엄 광고였는데 취소한 것들
				'OR  (OptGbn   in (1, 2) AND DelFlag = 2) ' +
-- 핫,프리미엄 광고였는데 결제 안 한것들
				'OR  (OptGbn   in (1, 2) AND prnAmtOK not in (1))) ' +

-- 리스트 종류별 조건
				@SQLItem + '; ' +


				'SELECT Top   ' + CONVERT(varchar(10), @Page*@PageSize)  + ' ' + 
				'AdId, UserID, UserName, JuminNo, Title, PayType, Pay,  ViewCnt, WorkPlace1,  '  +
				'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate, ' +
				'CONVERT(VARCHAR(10), ModDate, 120) AS ModDate, ' +
				'OptGbn, OptKind, PrnAmtOk,DelFlag  ' +
				'FROM Resume ' +
-- 일반 광고인  경우
				'WHERE OpenFlag in (1,2,3)  AND ((OptGbn  Not in (1, 2) AND DelFlag in (0,2))  ' +  
-- 핫,프리미엄 광고였는데 게재기간이 지난것들
				'OR  (OptGbn   in (1, 2) AND DelFlag = 0 ' +
			            	'AND  (CONVERT(VARCHAR(10),OptStDate,120)  > CONVERT(VARCHAR(10), GetDate(), 120) ' +
    		                        	'OR   CONVERT(VARCHAR(10),OptEnDate,120) < CONVERT(VARCHAR(10), GetDate(), 120))) ' +
-- 핫,프리미엄 광고였는데 취소한 것들
				'OR  (OptGbn   in (1, 2) AND DelFlag = 2) ' +
-- 핫,프리미엄 광고였는데 결제 안 한것들
				'OR  (OptGbn   in (1, 2) AND prnAmtOK not in (1))) ' +
-- 리스트 종류별 조건
				@SQLItem + ' ' +
				@Sort

		EXEC(@strQuery2)
		PRINT(@strQuery1)
--	END
END
GO
/****** Object:  StoredProcedure [dbo].[procGujikList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구직정보 리스트
	제작자	: 이창국
	제작일	: 2002-04-01
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGujikList_DelAN] 
(
@SQLOpt	CHAR(1)		--'1':직종,'2':지역별,'3':급여별,'4':시간대별,'5':근무형태별,'6':상세검색 
)
AS
BEGIN
	DECLARE @DATE VARCHAR(10)
	SET @DATE = CONVERT(VARCHAR(10), GetDate(),120)
	DECLARE @SQL VARCHAR(1000)

	IF @SQLOpt = '1' --직종검색
		BEGIN
			SET @SQL = 	'SELECT DiSTINCT Code1, CodeNm1, Count(Code1) AS Cnt , OrderNo1 '+
					'FROM AlbaCommon.dbo.JobCode ' +
					'WHERE UseFlag = ''Y'' ' +
					'GROUP BY Code1, CodeNm1, OrderNo1 ' +
					'ORDER BY OrderNo1;  ' +
					'SELECT JobCode1, JobCode2 FROM Resume '+
					'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') ; '+
					'SELECT Code1, Code2, CodeNm1, CodeNm2 ' +
					'FROM AlbaCommon.dbo.JobCode ' +
					'WHERE UseFlag = ''Y'' ' +
					'ORDER BY OrderNo1, OrderNo2 '
		END
	ElSE IF  @SQLOpt = '2' --지역별검색
		BEGIN
			SET @SQL = 	'SELECT LCode, Metro, City  ' +
					'FROM FindCommon.dbo.AreaCode ' +
					'WHERE  UseFlag = ''Y''  ' +
					'ORDER BY LCode ;' + 
					'SELECT WorkPlace1 FROM Resume '+
					'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') ; ' +

					'SELECT AdId, UserID, UserName, JuminNo, Title, PayType, Pay,  ViewCnt, WorkPlace1, ' +
					'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate, ' +
					'CONVERT(VARCHAR(10), ModDate, 120) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM Resume  ' +
					' WHERE (OptGbn=''1'' Or  OptGbn=''2'')  ' +
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <= '''+ @DATE+ 
					''' AND CONVERT(VARCHAR(10), OptEnDate,120) >= '''+@DATE+ ''' '+
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn; '
		END
	ElSE IF  @SQLOpt = '3' --급여별검색
		BEGIN
			SET @SQL = 	'SELECT PayType, Pay FROM Resume ' +
					'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') ; '
		END
	ElSE IF  @SQLOpt = '4' --시간대별검색
		BEGIN
			SET @SQL =	'SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro ' +
					'FROM FindCommon.dbo.AreaCode; ' + 
					'SELECT WorkTime FROM Resume ' +
					'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') ; '+
					'SELECT AdId, UserID, UserName, JuminNo, Title, PayType, Pay,  ViewCnt, WorkPlace1, ' +
					'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate, ' +
					'CONVERT(VARCHAR(10), ModDate, 120) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM Resume  ' +
					' WHERE (OptGbn=''1'' Or  OptGbn=''2'')  ' +
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <= '''+ @DATE+ 
					''' AND CONVERT(VARCHAR(10), OptEnDate,120) >= '''+@DATE+ ''' '+
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn; '
		END
	ElSE IF  @SQLOpt = '5' --근무형태별검색
		BEGIN
			SET @SQL =	'SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro ' +
					'FROM FindCommon.dbo.AreaCode; ' + 
					'SELECT WorkType FROM Resume ' +
					'WHERE (DelFlag = ''0'' OR DelFlag = ''2'') ; '+
					'SELECT AdId, UserID, UserName, JuminNo, Title, PayType, Pay,  ViewCnt, WorkPlace1, ' +
					'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate, ' +
					'CONVERT(VARCHAR(10), ModDate, 120) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM Resume  ' +
					' WHERE (OptGbn=''1'' Or  OptGbn=''2'')  ' +
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <= '''+ @DATE+ 
					''' AND CONVERT(VARCHAR(10), OptEnDate,120) >= '''+@DATE+ ''' '+
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn; '
		END

	EXEC(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[procGujikList_New]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구직정보 리스트
	제작자	: 이창국
	제작일	: 2002-04-01
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procGujikList_New] 
(
@SQLOpt	CHAR(1)		--'1':직종,'2':지역별,'3':급여별,'4':시간대별,'5':근무형태별,'6':상세검색 
)
AS
BEGIN
	DECLARE @DATE VARCHAR(10)
	SET @DATE = CONVERT(VARCHAR(10), GetDate(),120)
	DECLARE @SQL VARCHAR(1200)

	IF @SQLOpt = '1' --직종검색
		BEGIN
			SET @SQL = 	'SELECT B.Code1, B.Code2,   B.CodeNm1,  B.CodeNm2, B.OrderNo1,  B.OrderNo2, IsNull(Sum(A.Count), 0) as Cnt ' +
					'FROM  (SELECT B.Code2 as JobCode,  count(*) as Count  ' +
					'	 FROM  AlbaMain.dbo.Resume  A,  AlbaCommon.dbo.JobCode  B ' + 
					'	WHERE A.DelFlag  in (0, 2) ' +
					'	     AND B.UseFlag  =  ''Y''' + 
					'                  AND A.OpenFlag in (1,2,3) ' +
					'	     AND CHARINDEX(CONVERT(VARCHAR(6), B.Code2),  A.JobCode2) > 0 ' +
					' 	group by B.Code2)  A, ' +
					'	AlbaCommon.dbo.JobCode  B ' +
					' WHERE   B.Code2  *=  A.JobCode ' +
					' AND  B.UseFlag  =  ''Y''' + 
					' Group by B.Code1, B.Code2,   B.CodeNm1,  B.CodeNm2, B.OrderNo1,  B.OrderNo2 ' +
					' Order by B.OrderNo1,  B.OrderNo2, B.Code2,   B.CodeNm1,  B.CodeNm2 ;' 

		END
	ElSE IF  @SQLOpt = '2' --지역별검색
		BEGIN
			SELECT DISTINCT  LEFT(LCode, 2) AS LCode, Metro into #AreaCode
			FROM    FindCommon.dbo.AreaCode

			SET @SQL = 	'SELECT LCode, Metro, City  ' +
					'FROM FindCommon.dbo.AreaCode ' +
					'WHERE  UseFlag = ''Y''  ' +
					'ORDER BY LCode ;' + 


					'SELECT B.LCode,   B.Metro, IsNull(Sum(A.Count), 0) as Cnt ' +
					' FROM  (SELECT B.LCode as LCode, Count(*) as Count ' +
					'	 FROM  AlbaMain.dbo.Resume  A,  #AreaCode  B ' +
					'	WHERE A.DelFlag  in (0, 2) ' +
					'                  AND  A.OpenFlag in (1,2,3) ' +		
					'	     AND CHARINDEX(B.LCode,  A.WorkPlace1) > 0 ' +
					'	group by B.Lcode)  A, ' +
					'	#AreaCode  B ' +
					' WHERE   B.LCode  *=  A.LCode  ' +
					' Group by B.LCode,  B.Metro ' +
					' Order by  B.LCode,  B.Metro; ' +



					'SELECT AdId, UserID, UserName, JuminNo, Title, PayType, Pay,  ViewCnt, WorkPlace1, ' +
					'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate, ' +
					'CONVERT(VARCHAR(10), ModDate, 120) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM Resume  ' +
					' WHERE (OptGbn=''1'' Or  OptGbn=''2'')  ' +
					' AND  OpenFlag in (1,2,3) ' +		
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <=  CONVERT(VARCHAR(10), GetDate(),120) ' + 
					' AND CONVERT(VARCHAR(10), OptEnDate,120) >=  CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn, ModDate desc; '
		END
	ElSE IF  @SQLOpt = '3' --급여별검색
		BEGIN
			SET @SQL = 	'SELECT B.PayType, B.Pay, B.PayTypeNm, B.PayNm, count(A.Pay) As Cnt ' +
					'FROM AlbaMain.dbo.Resume  A,   AlbaCommon.dbo.PayTypeCode  B '+
					'WHERE    A.DelFlag  in (0, 2) ' +
					'       AND B.PayType  *=  A.PayType '+
					'       AND B.Pay	         *=  A.Pay	 '+
					'      AND  A.OpenFlag in (1,2,3) ' +		
					'    group by B.PayType, B.Pay, B.PayTypeNm, B.PayNm '  +
					'     order by B.PayType, B.Pay, B.PayTypeNm, B.PayNm ; '
		END
	ElSE IF  @SQLOpt = '4' --시간대별검색
		BEGIN
			SET @SQL =	'SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro ' +
					'FROM FindCommon.dbo.AreaCode; ' + 


					'SELECT B.WorkTime,  B.WorkTimeNm, IsNull(Sum(A.Count), 0) AS Cnt ' +
					'   FROM  (SELECT B.WorkTime as WorkTime, Count(B.WorkTime) as Count  ' +
					'    	      FROM  AlbaMain.dbo.Resume  A, AlbaCommon.dbo.WorkTimeCode  B ' +
					'	    WHERE A.DelFlag  in (0, 2) ' +
					'                        AND A.OpenFlag in (1,2,3) ' +		
					'  	           AND CHARINDEX(B.WorkTime,  A.WorkTime) > 0 ' +
					'   	    GROUP BY  B.WorkTime)  A, ' + 
					' 	    AlbaCommon.dbo.WorkTimeCode  B ' +
					'WHERE   B.WorkTime  *=  A.WorkTime ' +
					' Group by B.WorkTime,  B.WorkTimeNm ' +
					' Order by  B.WorkTime ; ' +


					'SELECT AdId, UserID, UserName, JuminNo, Title, PayType, Pay,  ViewCnt, WorkPlace1, ' +
					'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate, ' +
					'CONVERT(VARCHAR(10), ModDate, 120) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM Resume  ' +
					' WHERE (OptGbn=''1'' Or  OptGbn=''2'')  ' +
					'  AND  OpenFlag in (1,2,3) ' +		
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <=  CONVERT(VARCHAR(10), GetDate(),120) ' + 
					' AND CONVERT(VARCHAR(10), OptEnDate,120) >=  CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn, ModDate desc; '
		END
	ElSE IF  @SQLOpt = '5' --근무형태별검색
		BEGIN
			SET @SQL =	'SELECT DISTINCT SUBSTRING(LCode,1,2) AS LCode1, Metro ' +
					'FROM FindCommon.dbo.AreaCode; ' + 

					'SELECT B.WorkType,  B.WorkTypeNm, IsNull(Sum(A.Count), 0) AS Cnt ' +
					'   FROM  (SELECT B.WorkType as WorkType, Count(B.WorkType) as Count  ' +
					'    	      FROM  AlbaMain.dbo.Resume  A, AlbaCommon.dbo.WorkTypeCode  B ' +
					'	    WHERE A.DelFlag  in (0, 2) ' +
					'                       AND  A.OpenFlag in (1,2,3) ' +		
					'  	          AND CHARINDEX(B.WorkType,  A.WorkType) > 0 ' +
					'   	    GROUP BY  B.WorkType)  A, ' + 
					' 	    AlbaCommon.dbo.WorkTypeCode  B ' +
					'WHERE   B.WorkType  *=  A.WorkType ' +
					' Group by B.WorkType,  B.WorkTypeNm ' +
					' Order by  B.WorkType ; ' +


					'SELECT AdId, UserID, UserName, JuminNo, Title, PayType, Pay,  ViewCnt, WorkPlace1, ' +
					'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate, ' +
					'CONVERT(VARCHAR(10), ModDate, 120) AS ModDate, ' +
					'OptGbn, OptKind ' +
					'FROM Resume  ' +
					' WHERE (OptGbn=''1'' Or  OptGbn=''2'')  ' +
					' AND  OpenFlag in (1,2,3) ' +		
					' AND  CONVERT(VARCHAR(10),OptStDate,120) <=  CONVERT(VARCHAR(10), GetDate(),120) ' + 
					' AND CONVERT(VARCHAR(10), OptEnDate,120) >=  CONVERT(VARCHAR(10), GetDate(),120) ' +
					' AND DelFlag = ''0''  AND PrnAmtOk = ''1''' +
					'ORDER BY OptGbn, ModDate desc; '
		END

	EXEC(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[procJobBizList]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 업종 리스트 출력
	제작자	: 강지연
	제작일	: 2002. 4. 22
*************************************************************************************/

CREATE PROCEDURE [dbo].[procJobBizList] 
AS
BEGIN

	DECLARE @SQL VARCHAR(1000)

	SET @SQL = 	'SELECT DiSTINCT BizCode1, BizCodeNm1, Count(BizCode1) AS Cnt  '+
			'FROM FindDB4.JobCommon.dbo.BizCode ' +
			'WHERE UseFlag = ''Y'' AND CodeDepth=''2''  ' +
			'GROUP BY BizCode1, BizCodeNm1 ; ' +
			'SELECT BizCode1, BizCode2, BizCodeNm1, BizCodeNm2, CodeDepth ' +
			'FROM FindDB4.JobCommon.dbo.BizCode ' +
			'WHERE UseFlag = ''Y'' AND CodeDepth=''2'' ' 

	EXEC(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[procJobCode]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 직종코드
	제작자	: 김종진
	제작일	: 2002-03-17
	셜명	:
*************************************************************************************/
CREATE PROCEDURE [dbo].[procJobCode] 

AS
BEGIN

	DECLARE @SQL VARCHAR(1000)

		BEGIN
			SET @SQL = 	'SELECT DiSTINCT Code1, CodeNm1, Count(Code1) AS Cnt , OrderNo1 '+
					'FROM AlbaCommon.dbo.JobCode ' +
					'WHERE UseFlag = ''Y'' ' +
					'GROUP BY Code1, CodeNm1, OrderNo1 ' +
					'ORDER BY OrderNo1;  ' +
					'SELECT JobCode1, JobCode2 FROM JobOffer; '+
					'SELECT Code1, Code2, CodeNm1, CodeNm2 ' +
					'FROM AlbaCommon.dbo.JobCode ' +
					'WHERE UseFlag = ''Y'' ' +
					'ORDER BY OrderNo1, OrderNo2 '
		END
	

	EXEC(@SQL)


END
GO
/****** Object:  StoredProcedure [dbo].[procJobComInfoButt_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[procJobComInfoButt_DelAN]
AS
BEGIN
DECLARE @Sql nvarchar(1000)
set @Sql = 'Select UserID From UserJobCompany ' +
	   ' where Staff <> '''' AND President <> '''' AND BizType<>'''' AND CategoryBiz <>'''' AND ListStocks <>'''' AND WelfarePgm <>'''' AND DetailLocate <>'''''
print(@Sql)
EXECUTE sp_executesql @Sql
END



SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  StoredProcedure [dbo].[procJobOfferDelete_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	:구인광고 삭제
	제작자	: 김종진
	제작일	: 2002-03-15
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procJobOfferDelete_DelAN]
	
	@strAdid		int
,	@strDelFlag		char(1)

AS
BEGIN
BEGIN DISTRIBUTED TRANSACTION

	UPDATE  JobOffer
		SET
			DelFlag=@strDelFlag

		WHERE
			Adid=@strAdid
IF @@ERROR = 0 
	BEGIN
	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procJobOfferIns]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	:구인광고 입력
	제작자	: 김종진
	제작일	: 2002-03-13
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procJobOfferIns]


		@strUserID		varchar(30) 
	,	@strShopNm		varchar(50) 
	,	@strManager		varchar(30) 
	,	@strEmail		varchar(50) 
	,	@strPhone		varchar(50) 
	,	@strHPhone		varchar(50) 
	,	@strZipCode		varchar(6)  
	,	@strAddress1		varchar(100)
	,	@strAddress2		varchar(100)
	,	@strShopUrl		varchar(50) 
	,	@strAppDesk		varchar(50) 
	,	@strRecStDate		datetime    
	,	@strRecEnDate		datetime    
	,	@strTitle		varchar(200)
	,	@strJobCode1		varchar(50) 
	,	@strJobCode2		varchar(50) 
	,	@strWorkPlace1	varchar(100) 
	,	@strWorkPlace2	varchar(100) 
	,	@strLocalBranch	varchar(100) 
	,	@strWorkType		varchar(10)
	,	@strWorkTime		varchar(10)
	,	@strPayType		varchar(10) 
	,	@strPay		varchar(10) 
	,	@strSex		varchar(10) 
	,	@strAgeLimit		char(1)     
	,	@intAge1		int         
	,	@intAge2		int         
	,	@strSchool		varchar(30) 
	,	@strCareer		varchar(30) 
	,	@strEtcData		text        
	,	@intViewCnt		int         
	,	@strOptGbn		char(1) 
	,	@strOptKind    		char(10) 
	,	@strOptStDate		datetime    
	,	@strOptEnDate		datetime    
	,	@intOptAmt		int         
	,	@strChargeKind		char(1) 
	,	@strPrnAmtOk		char(1)
	,	@strDelFlag		char(1)   
	,	@strRecProxyGbn	char(1)     
	,	@strRecProxy		varchar(30) 
	,	@strRegDate		datetime  
	,	@strMergeText		varchar(6000)  
		
	
AS						      
						      
BEGIN							

BEGIN DISTRIBUTED TRANSACTION
IF @strOptStDate='' 
BEGIN
	SET @strOptStDate = NULL
END

IF @strOptEnDate='' 
BEGIN
	SET @strOptEnDate = NULL
END


	INSERT	INTO	JobOffer
(

		UserID	
,		ShopNm	
,		Manager	
,		Email	
,		Phone	
,		HPhone	
,		ZipCode	
,		Address1
,		Address2
,		ShopUrl	
,		AppDesk	
,		RecStDate
,		RecEnDate
,		Title	
,		JobCode1	
,		JobCode2
,		WorkPlace1
,		WorkPlace2
,		LocalBranch
,		WorkType
,		WorkTime
,		PayType	
,		Pay	
,		Sex	
,		AgeLimit
,		Age1	
,		Age2	
,		School	
,		Career	
,		EtcData	
,		ViewCnt	
,		OptGbn	
,		OptKind
,		OptStDate
,		OptEnDate
,		OptAmt	
,		ChargeKind
,		PrnAmtOk
,		DelFlag
,		RecProxyGbn
,		RecProxy
,		RegDate	
,		MergeText


)
VALUES
(
			  
		@strUserID		  
	,	@strShopNm		  
	,	@strManager		  
	,	@strEmail			  
	,	@strPhone			  
	,	@strHPhone		  
	,	@strZipCode		  
	,	@strAddress1	  
	,	@strAddress2	  
	,	@strShopUrl		  
	,	@strAppDesk		  
	,	@strRecStDate	  
	,	@strRecEnDate	  
	,	@strTitle			  
	,	@strJobCode1	  
	,	@strJobCode2	  
	,	@strWorkPlace1	
	,	@strWorkPlace2
	,	@strLocalBranch
	,	@strWorkType	  
	,	@strWorkTime	  
	,	@strPayType		  
	,	@strPay			    
	,	@strSex			    
	,	@strAgeLimit	  
	,	@intAge1		    
	,	@intAge2		    
	,	@strSchool		  
	,	@strCareer		  
	,	@strEtcData		  
	,	@intViewCnt		  
	,	@strOptGbn
	,	@strOptKind		  
	,	@strOptStDate	  
	,	@strOptEnDate	  
	,	@intOptAmt		  
	,	@strChargeKind	
	,	@strPrnAmtOk
	,	@strDelFlag
	,	@strRecProxyGbn	
	,	@strRecProxy		
	,	@strRegDate	
	,	@strMergeText		  

)

IF @@ERROR = 0 
	BEGIN			
			DECLARE	@i			int	--결재위한 구인광고 순번		
			SET @i = @@IDENTITY
			SELECT @i AS AdId

	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procJobOfferList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구인광고 리스트
	제작자	: 김종진
	제작일	: 2002-03-29
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
		SQLOpt		: 해당 리스트 구분 Flag
*************************************************************************************/

CREATE PROCEDURE [dbo].[procJobOfferList_DelAN] 
(
	@SQLOpt	CHAR(1)	
,	@strUserID	 varchar(30)	
,	@NowDate	varchar(30)		
		

)
AS
BEGIN

DECLARE @strQuery1 varchar(2000)


BEGIN

IF @SQLOpt = '1' --구인광고 리스트

	SET @strQuery1=

		'SELECT	AdId,CONVERT(varchar(10),RegDate,120) AS RegDate, ' +
		'CONVERT(varchar(10),RecEnDate,120) AS RecEnDate,Title,ViewCnt,OptGbn,DelFlag ' +	
		'FROM JobOffer  WHERE UserID='+' '''+@strUserID+''' '+' And RecEnDate >='+' '''+@NowDate+''' '+' AND DelFlag  <> 1  AND RecProxyGbn<>2 ORDER BY AdId'+ ';'  +' '+
		
		'SELECT  AdId,CONVERT(varchar(10),RegDate,120) AS RegDate, ' +
		'CONVERT(varchar(10),RecEnDate,120) AS RecEnDate,Title,ViewCnt,OptGbn,DelFlag ' +	
		'FROM JobOffer  WHERE UserID='+' '''+@strUserID+''' '+' And RecEnDate < '+' '''+@NowDate+''' '+'AND DelFlag <> 1  AND RecProxyGbn<>2   ORDER BY AdId'

ELSE IF @SQLOpt = '2' --옵션리스트

	SET @strQuery1=
		'SELECT	AdId,CONVERT(varchar(10),RegDate,120) AS RegDate,CONVERT(varchar(10),RecEnDate,120) AS RecEnDate,Title,ViewCnt,OptGbn,DelFlag' +	
		' FROM JobOffer  WHERE UserID='+' '''+@strUserID+''' '+' And RecEnDate >='+' '''+@NowDate+''' '+' AND DelFlag <> 1  AND RecProxyGbn<>2  AND PrnAmtOk = '+' ''0'' '+' ORDER BY AdId'

ELSE IF @SQLOpt = '3' --지원자리스트

	SET @strQuery1=

		'SELECT	T1.AdId,CONVERT(varchar(10),T1.RegDate,120) AS RegDate,CONVERT(varchar(10),T1.RecEnDate,120) AS RecEnDate,T1.Title,T1.ViewCnt,T1.OptGbn,T1.DelFlag' +	
		' FROM JobOffer T1, AppInfo T2 WHERE T1.UserID='+' '''+@strUserID+''' '+' And T1.RecEnDate >='+' '''+@NowDate+''' '+' AND T1.AdId=T2.JobAdId AND T1.DelFlag <> 1  AND T2.BDelFlag= '+' ''0'' '+ ' '+
		' GROUP BY T1.AdId,T1.RegDate,T1.RecEnDate,T1.Title,T1.ViewCnt,T1.OptGbn,T1.DelFlag   ORDER BY T1.AdId'+ ';'  +' '+

		'SELECT	T1.AdId,CONVERT(varchar(10),T1.RegDate,120) AS RegDate,CONVERT(varchar(10),T1.RecEnDate,120) AS RecEnDate,T1.Title,T1.ViewCnt,T1.OptGbn,T1.DelFlag' +	
		' FROM JobOffer T1, AppInfo T2 WHERE T1.UserID='+' '''+@strUserID+''' '+' And T1.RecEnDate <'+' '''+@NowDate+''' '+' AND T1.AdId=T2.JobAdId AND T1.DelFlag <> 1AND T2.BDelFlag= '+' ''0'' '+' '+
		' GROUP BY T1.AdId,T1.RegDate,T1.RecEnDate,T1.Title,T1.ViewCnt,T1.OptGbn,T1.DelFlag   ORDER BY T1.AdId'
END

END

EXEC(@strQuery1)
GO
/****** Object:  StoredProcedure [dbo].[procJobOfferModForm_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	:구인광고 수정 폼
	제작자	: 김종진
	제작일	: 2002-03-15
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procJobOfferModForm_DelAN]

	@strAdid		int


AS

BEGIN
	SELECT 
		AdId		    
,		UserID		  
,		ShopNm		  
,		Manager		  
,		Email	
,		ShopUrl	    
,		Phone		    
,		HPhone		  
,		ZipCode		  
,		Address1	  
,		Address2	  
,		ShopUrl		  
,		AppDesk		  
,		RecStDate	  
,		RecEnDate	  
,		Title		    
,		JobCode1
,		JobCode2		  
,		WorkPlace1	  
,		WorkPlace2
,		LocalBranch 
,		WorkType	  
,		WorkTime	  
,		PayType		  
,		Pay		      
,		Sex		      
,		AgeLimit	  
,		Age1		    
,		Age2		    
,		School		  
,		Career		  
,		EtcData		  
,		OptGbn	
,		OptKind	  
,		OptStDate	  
,		OptEnDate	  
,		OptAmt		  
,		ChargeKind	
,		RecProxyGbn	
,		RecProxy	  
,		DelFlag



 FROM JobOffer 
	
WHERE Adid=@strAdid


END
GO
/****** Object:  StoredProcedure [dbo].[procJobOfferModify]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	:구인광고 수정
	제작자	: 김종진
	제작일	: 2002-03-15
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procJobOfferModify]
		@strAdid			int
	,	@strShopNm		varchar(50) 
	,	@strManager		varchar(30) 
	,	@strEmail		varchar(50) 
	,	@strPhone		varchar(50) 
	,	@strHPhone		varchar(50) 
	,	@strZipCode		varchar(6)  
	,	@strAddress1		varchar(100)
	,	@strAddress2		varchar(100)
	,	@strShopUrl		varchar(50) 
	,	@strAppDesk		varchar(50) 
	,	@strRecStDate		datetime    
	,	@strRecEnDate		datetime    
	,	@strTitle		varchar(200)
	,	@strJobCode1		varchar(50) 
	,	@strJobCode2		varchar(50) 
	,	@strWorkPlace1	varchar(100) 
	,	@strWorkPlace2	varchar(100) 
	,	@strLocalBranch	varchar(100) 
	,	@strWorkType		varchar(10)
	,	@strWorkTime		varchar(10)
	,	@strPayType		varchar(10) 
	,	@strPay		varchar(10) 
	,	@strSex		varchar(10) 
	,	@strAgeLimit		char(1)     
	,	@intAge1		int         
	,	@intAge2		int         
	,	@strSchool		varchar(30) 
	,	@strCareer		varchar(30) 
	,	@strEtcData		text        
	,	@strModDate		datetime  
	,	@strMergeText		varchar(6000)  

AS
BEGIN

BEGIN  TRANSACTION

	UPDATE JobOffer
		SET
			ShopNm			=@strShopNm			
			,Manager		=@strManager		
			,Email			=@strEmail			
			,Phone			=@strPhone			
			,HPhone			=@strHPhone			
			,ZipCode		=@strZipCode		
			,Address1		=@strAddress1		
			,Address2		=@strAddress2		
			,ShopUrl			=@strShopUrl		
			,AppDesk		=@strAppDesk		
			,RecStDate		=@strRecStDate	
			,RecEnDate		=@strRecEnDate	
			,Title			=@strTitle			
			,JobCode1		=@strJobCode1		
			,JobCode2		=@strJobCode2		
			,WorkPlace1		=@strWorkPlace1	
			,WorkPlace2		=@strWorkPlace2	
			,LocalBranch		=@strLocalBranch
			,WorkType		=@strWorkType		
			,WorkTime		=@strWorkTime		
			,PayType		=@strPayType		
			,Pay			=@strPay				
			,Sex			=@strSex				
			,AgeLimit		=@strAgeLimit		
			,Age1			=@intAge1				
			,Age2			=@intAge2				
			,School			=@strSchool			
			,Career			=@strCareer			
			,EtcData		=@strEtcData		
			,RegDate		=@strModDate		
			,MergeText		=@strMergeText

		WHERE
			Adid=@strAdid

IF @@ERROR = 0 
	BEGIN

	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procJobOfferOptModify_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	:구인광고 수정
	제작자	: 김종진
	제작일	: 2002-03-15
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procJobOfferOptModify_DelAN]
		@strAdid			int
	,	@strShopNm		varchar(50) 
	,	@strManager		varchar(30) 
	,	@strEmail		varchar(50) 
	,	@strPhone		varchar(50) 
	,	@strHPhone		varchar(50) 
	,	@strZipCode		varchar(6)  
	,	@strAddress1		varchar(100)
	,	@strAddress2		varchar(100)
	,	@strShopUrl		varchar(50) 
	,	@strAppDesk		varchar(50) 
	,	@strRecStDate		datetime    
	,	@strRecEnDate		datetime    
	,	@strTitle		varchar(200)
	,	@strJobCode1		varchar(50) 
	,	@strJobCode2		varchar(50) 
	,	@strWorkPlace1	varchar(100) 
	,	@strWorkPlace2	varchar(100) 
	,	@strLocalBranch	varchar(100) 
	,	@strWorkType		varchar(10)
	,	@strWorkTime		varchar(10)
	,	@strPayType		varchar(10) 
	,	@strPay		varchar(10) 
	,	@strSex		varchar(10) 
	,	@strAgeLimit		char(1)     
	,	@intAge1		int         
	,	@intAge2		int         
	,	@strSchool		varchar(30) 
	,	@strCareer		varchar(30) 
	,	@strEtcData		text        
	,	@strOptGbn		char(1) 
	,	@strOptKind    		char(10) 
	,	@strOptStDate		datetime    
	,	@strOptEnDate		datetime    
	,	@strOptAmt		int         
	,	@strModDate		datetime  
	,	@strMergeText		varchar(6000)  

AS
BEGIN

BEGIN  TRANSACTION
IF @strOptStDate='' 
BEGIN
	SET @strOptStDate = NULL
END

IF @strOptEnDate='' 
BEGIN
	SET @strOptEnDate = NULL
END

	UPDATE JobOffer
		SET
			ShopNm			=@strShopNm			
			,Manager		=@strManager		
			,Email			=@strEmail			
			,Phone			=@strPhone			
			,HPhone			=@strHPhone			
			,ZipCode		=@strZipCode		
			,Address1		=@strAddress1		
			,Address2		=@strAddress2		
			,ShopUrl			=@strShopUrl		
			,AppDesk		=@strAppDesk		
			,RecStDate		=@strRecStDate	
			,RecEnDate		=@strRecEnDate	
			,Title			=@strTitle			
			,JobCode1		=@strJobCode1		
			,JobCode2		=@strJobCode2		
			,WorkPlace1		=@strWorkPlace1	
			,WorkPlace2		=@strWorkPlace2	
			,LocalBranch		=@strLocalBranch
			,WorkType		=@strWorkType		
			,WorkTime		=@strWorkTime		
			,PayType		=@strPayType		
			,Pay			=@strPay				
			,Sex			=@strSex				
			,AgeLimit		=@strAgeLimit		
			,Age1			=@intAge1				
			,Age2			=@intAge2				
			,School			=@strSchool			
			,Career			=@strCareer			
			,EtcData		=@strEtcData		
			,OptGbn		=@strOptGbn			
			,OptKind    		=@strOptKind    
			,OptStDate		=@strOptStDate	
			,OptEnDate		=@strOptEnDate	
			,OptAmt			=@strOptAmt			
			,ModDate		=@strModDate		
			,MergeText		=@strMergeText

		WHERE
			Adid=@strAdid

IF @@ERROR = 0 
	BEGIN

	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procMagAccountList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 결제정보 리스트
	제작자	: 김종진
	제작일	: 2002-03-29
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procMagAccountList_DelAN] 
(
	@PageSize	INT		-- 페이지당 게시물 개수
	, @Page		INT		-- Jump할 페이지
	,@strTable	char(1)	
	,@strBankNm	varchar(30) 	--은행명
	,@strOnlineStatus	char(1)		--입금여부
--	,@strOrderBy	varchar(200)	--Order By 절
	,@strSort	char(1)	
	,@cboyear1	ChAR(4)	--날짜	
	,@cboyear2	ChAR(4)	
	,@cboMonth1	ChAR(2)
	,@cboMonth2	ChAR(2)
	,@cboDay1	ChAR(2)
	,@cboDay2	ChAR(2)	--날짜	
	,@cboSearch	VARCHAR(15)   --검색선택(아이디,이름별등등)
	,@txtSearch	VARCHAR(100)	--검색키워드	
		





)
AS
BEGIN
/*
유료구분 옵션 (OptGbn) -0:일반, 1: 핫정보, 2: 프리미엄, 3: 엑센트
*/
DECLARE @strQuery1 varchar(2000)
DECLARE @strWhere1 varchar(2000)
DECLARE @strWhere2 varchar(2000)
DECLARE @strWhere3 varchar(2000)
DECLARE @strWhere4 varchar(2000)
DECLARE @DATE VARCHAR(10)
SET @DATE = CONVERT(VARCHAR(10), GetDate(),120)
	BEGIN
		IF @strBankNm <> ''
			BEGIN	
			SET @strWhere1 = 'And T2.BankNm='''+@strBankNm+''''
			END	
		ELSE	
			BEGIN
			SET @strWhere1 =''
			END
		 IF @strOnlineStatus <>''
			BEGIN
			SET @strWhere2 = 'And T2.OnlineStatus='''+@strOnlineStatus+''''
			END
		ELSE
			BEGIN
			SET @strWhere2 =''
			END	

		IF @strSort='1'	--구인광고 신청일
		BEGIN
				 IF  @cboyear1<>'' Or @cboMonth1 <>''  Or  @cboDay1 <>'' Or @cboyear2<>'' Or @cboMonth2 <>''  Or  @cboDay2 <>''  -- 구인광고신청일
						BEGIN 
						SET @strWhere3 = 
						 ' AND T1.RegDate BETWEEN ''' + @cboyear1+'-'+@cboMonth1+'-'+@cboDay1+ ''' AND '''  +@cboyear2+'-'+@cboMonth2+'-'+@cboDay2+''''
						END
				ELSE
						BEGIN 
						SET @strWhere3 = ''
						END
		END

		IF @strSort='2'	--입금확인일
		BEGIN
				 IF  @cboyear1<>'' Or @cboMonth1 <>''  Or  @cboDay1 <>'' Or @cboyear2<>'' Or @cboMonth2 <>''  Or  @cboDay2 <>''  -- 구인광고신청일
						BEGIN 
						SET @strWhere3 = 
						 ' AND T2.BankInputDate BETWEEN ''' + @cboyear1+'-'+@cboMonth1+'-'+@cboDay1+ ''' AND '''  +@cboyear2+'-'+@cboMonth2+'-'+@cboDay2+''''
						END
				ELSE
						BEGIN 
						SET @strWhere3 = ''
						END
		END
	
		IF @strSort=''
		BEGIN
		SET @strWhere3 = ''
		END		
		IF @cboSearch <> ''
			BEGIN
				IF @cboSearch ='UserID' --아이디
					BEGIN 
					SET @strWhere4 = 
						' AND T1.UserID =''' +@txtSearch+ ''''
					END
				ELSE IF @cboSearch = 'UserName' --이름
					BEGIN
					SET @strWhere4 = 
						' AND T1.ShopNm  =''' +@txtSearch+ ''''
					END
				ELSE IF @cboSearch = 'BankAcName' --이름
					BEGIN
					SET @strWhere4 = 
						' AND T2.RecNm  =''' +@txtSearch+ ''''
					END
				
			END
		ELSE	
			BEGIN	
				SET @strWhere4 = '' 
			END	


	END

	BEGIN
			IF @strTable = '1'

			SET @strQuery1 =
					'SELECT TOP 1 COUNT(T2.AdId) FROM JobOffer T1,  RecCharge T2 WHERE T1.AdId =T2.AdId' +' '+@strWhere1+' '+@strWhere2+' '+@strWhere3+' '+@strWhere4+ ';'  +' '+	
					'SELECT TOP  ' +  CONVERT(varchar(10), @Page*@PageSize) + ' ' +
					' T1.AdId,T1.UserID, T1.ShopNm,T1.OptGbn, T1.RegDate,T1.RecStDate,T1.RecEnDate,T1.OptStDate,T1.OptEnDate,T1.OptAmt, '+
					'T2.AdId,T2.BankInputDate,T2.BankNm,T2.RecNm,T2.OnlineStatus  from JobOffer T1, RecCharge T2  ' +
					' Where T1.OptGbn <> '+' '' 0'' '+' AND T1.OptKind <>'+' '' 0'' '+' AND T1.AdId =T2.AdId ' +' '+@strWhere1+' '+@strWhere2+' '+@strWhere3+' '+@strWhere4+'  ORDER BY T2.AdId DESC'

			ELSE IF @strTable='2'

			SET @strQuery1 =
					'SELECT TOP 1 COUNT(T2.AdId) FROM Resume T1,  RecCharge T2 WHERE T1.AdId =T2.AdId' +' '+@strWhere1+' '+@strWhere2+' '+@strWhere3+' '+@strWhere4+ ';'  +' '+	
					'SELECT TOP  ' +  CONVERT(varchar(10), @Page*@PageSize) + ' ' +
					' T1.AdId,T1.UserID, T1.UserName AS ShopNm,T1.OptGbn, T1.RegDate,T1.OptStDate,T1.OptEnDate,T1.OptAmt, '+
					'T2.AdId,T2.BankInputDate,T2.BankNm,T2.RecNm,T2.OnlineStatus  from Resume T1, RecCharge T2  ' +
					' Where T1.OptGbn <> '+' '' 0'' '+' AND T1.OptKind <>'+' '' 0'' '+' AND T1.AdId =T2.AdId ' +' '+@strWhere1+' '+@strWhere2+' '+@strWhere3+' '+@strWhere4+' ORDER BY T2.AdId DESC'
			
	END




		-- IF @strBankNm = ''

			
		
	
	
	

END
Print(@strWhere1)
Print(@strQuery1)
EXEC(@strQuery1)
GO
/****** Object:  StoredProcedure [dbo].[procMagAgencyJobOfferList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구인광고등록대행 리스트
	제작자	: 김종진
	제작일	: 2002-04-03
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procMagAgencyJobOfferList_DelAN] 
(
@PageSize	INT		-- 페이지당 게시물 개수
, @Page	INT		-- Jump할 페이지
,@cboUserGbn	CHAR(1) --게재전/게재중/마감 검색
,@cboRegDate  CHAR(1) --옵션신청일/구인광고등록일/회원가입일/최종수정일
,@cboyear1	ChAR(4)	
,@cboyear2	ChAR(4)	
,@cboMonth1	ChAR(2)
,@cboMonth2	ChAR(2)
,@cboDay1	ChAR(2)
,@cboDay2	ChAR(2)
,@cboSearch	VARCHAR(15)   --검색선택(아이디,이름별등등)
,@txtSearch	VARCHAR(100)	--검색키워드
,@Search	CHAR(1)	

)
AS

BEGIN
/*
유료구분 옵션 (OptGbn) -0:일반, 1: 핫정보, 2: 프리미엄, 3: 엑센트
*/
DECLARE @strQuery1 varchar(2000)
DECLARE @strQuery2 varchar(2000)
DECLARE @strQuery3 varchar(2000)
DECLARE @strWhere1 varchar(2000)
DECLARE @strWhere2 varchar(2000)
DECLARE @strWhere3 varchar(2000)
DECLARE @DATE VARCHAR(10)
SET @DATE = CONVERT(VARCHAR(10), GetDate(),120)

IF @cboUserGbn = 1 --전체
		BEGIN 
		SET @strWhere1 = 
			' '
		END

ELSE IF @cboUserGbn =2 --게재전
		BEGIN 
		SET @strWhere1 = 
			' AND CONVERT(VARCHAR(10),RecStDate,120) > '''+@DATE+ ''' '
		END
ELSE IF @cboUserGbn =3 -- 게재중인 광고
		BEGIN 
		SET @strWhere1 = 
			' AND (CONVERT(VARCHAR(10),RecEnDate,120) >= '''+@DATE+ ''' '+
			' AND CONVERT(VARCHAR(10),RecStDate,120) <= '''+@DATE+  '''' +')' 
		END

ELSE  --마감된 광고
		BEGIN  
		SET @strWhere1 = 
			' AND  CONVERT(VARCHAR(10),RecEnDate,120) < '''+@DATE+ ''' '
		END


IF  @cboRegDate = 1
		BEGIN 
		SET @strWhere2 =''
		END
Else IF  @cboRegDate = 2 -- 이력서등록일
		BEGIN 
		SET @strWhere2 = 
		 ' AND CONVERT(VARCHAR(10), RegDate, 120)  BETWEEN ''' + @cboyear1+'-'+@cboMonth1+'-'+@cboDay1+ ''' AND '''  +@cboyear2+'-'+@cboMonth2+'-'+@cboDay2+''''
		END


ELSE   -- 최종수정일
		BEGIN  
		SET @strWhere2 = 
		' AND ModDate BETWEEN ''' + @cboyear1+'-'+@cboMonth1+'-'+@cboDay1+'''  AND '''  + @cboyear2+'-'+@cboMonth2+'-'+@cboDay2+''''

		END


	IF @cboSearch ='UserID' --아이디
		BEGIN 
		SET @strWhere3 = 
			' AND UserID =''' +@txtSearch+ ''''
		END
	
	ELSE IF @cboSearch = 'UserName' --이름
		BEGIN 
		SET 	@strWhere3 = 
			' AND ShopNm  =''' +@txtSearch+ ''''
		END
	
	ELSE IF @cboSearch = 'JuminNo' -- 주민번호
		BEGIN 
		SET 
			@strWhere3 = 
			' AND JuminNo =''' +@txtSearch+ ''''
		END
	
	ELSE  IF @cboSearch = 'Email' -- 이메일
		BEGIN  
		SET @strWhere3 = 
			' AND  Email  =''' +@txtSearch+ ''''
		END
	ELSE  IF @cboSearch = 'Title' -- 제목
		BEGIN  
		SET @strWhere3 = 
			' AND  Title  LIKE  ''%'+@txtSearch+'%'''
		END
	ELSE  IF @cboSearch = 'MergeText' -- 내용
		BEGIN  
		SET @strWhere3 = 
			' AND  MergeText  LIKE  ''%'+@txtSearch+'%'''
		END
	ELSE  IF @cboSearch = 'All' -- 내용
		BEGIN  
		SET @strWhere3 = 
			' AND  MergeText  LIKE  ''%'+@txtSearch+'%'''
		END


	ELSE
			BEGIN  
			SET @strWhere3 = 
				' AND  RecProxyGbn IN(1,2) AND DelFlag = 0'
			END	
	

	IF @search =''
			BEGIN
			SET @strQuery1 =
				'SELECT AdId, UserID,RecEnDate, Title, OptGbn,ViewCnt, RecProxyGbn, '+
					'CONVERT(VARCHAR(10), OptEnDate, 120) AS OptEnDate, ' +
					'CONVERT(VARCHAR(10), OptStDate, 120) AS OptStDate, ' +
					'DelFlag,'+	
					'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate ' +
					'FROM JobOffer WHERE DelFlag=''0'' and RecProxyGbn IN(1,2) '+' ORDER BY RegDate DESC, AdId DESC '
		
			  
			END
	ELSE

			BEGIN
			SET @strQuery1 =
				'SELECT AdId, UserID, Title,RecEnDate, OptGbn, ViewCnt, RecProxyGbn, '+
					'CONVERT(VARCHAR(10), OptEnDate, 120) AS OptEnDate, ' +
					'CONVERT(VARCHAR(10), OptStDate, 120) AS OptStDate, ' +
					'DelFlag,'+	
					'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate ' +
					'FROM JobOffer WHERE DelFlag=''0'' and RecProxyGbn IN(1,2)'+ @strWhere1 + @strWhere2 + @strWhere3 +' ORDER BY RegDate DESC, AdId DESC '
		
			  
			END


END

EXEC(@strQuery1)
GO
/****** Object:  StoredProcedure [dbo].[procMagAgencyResumeList]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 이력서등록대행 리스트
	제작자	: 김종진
	제작일	: 2002-04-03
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procMagAgencyResumeList] 
(
	 @PageSize	INT		-- 페이지당 게시물 개수
	,@Page		INT		-- Jump할 페이지
	,@cboUserGbn	CHAR(1)		 --게재전/게재중/마감 검색
	,@cboRegDate  	CHAR(1)		 --옵션신청일/구인광고등록일/회원가입일/최종수정일
	,@cboyear1	ChAR(4)	
	,@cboyear2	ChAR(4)	
	,@cboMonth1	ChAR(2)
	,@cboMonth2	ChAR(2)
	,@cboDay1	ChAR(2)
	,@cboDay2	ChAR(2)
	,@cboSearch	VARCHAR(15)	--검색선택(아이디,이름별등등)
	,@txtSearch	VARCHAR(100)	--검색키워드
	,@Search	CHAR(1)	

)
AS

BEGIN
/*
유료구분 옵션 (OptGbn) -0:일반, 1: 핫정보, 2: 프리미엄, 3: 엑센트
*/
DECLARE @strQuery1 varchar(2000)
DECLARE @strQuery2 varchar(2000)
DECLARE @strQuery3 varchar(2000)
DECLARE @strWhere1 varchar(2000)
DECLARE @strWhere2 varchar(2000)
DECLARE @strWhere3 varchar(2000)
DECLARE @DATE VARCHAR(10)
SET @DATE = CONVERT(VARCHAR(10), GetDate(),120)

IF @cboUserGbn = 1 --전체
		BEGIN 
		SET @strWhere1 = 
			' '
		END

ELSE IF @cboUserGbn =2 --게재전
		BEGIN 
		SET @strWhere1 = 
			' AND CONVERT(VARCHAR(10),OptStDate,120) > '''+@DATE+ ''' '
		END
ELSE IF @cboUserGbn =3 -- 게재중인 광고
		BEGIN 
		SET @strWhere1 = 
			' AND (CONVERT(VARCHAR(10),OptEnDate,120) >= '''+@DATE+ ''' '+
			' AND CONVERT(VARCHAR(10),OptStDate,120) <= '''+@DATE+  '''' +')' 
		END

ELSE  --마감된 광고
		BEGIN  
		SET @strWhere1 = 
			' AND  CONVERT(VARCHAR(10),OptEnDate,120) < '''+@DATE+ ''' '
		END


IF  @cboRegDate = 1
		BEGIN 
		SET @strWhere2 =''
		END
Else IF  @cboRegDate = 2 -- 이력서등록일
		BEGIN 
		SET @strWhere2 = 
		 ' AND CONVERT(VARCHAR(10), RegDate, 120)  BETWEEN ''' + @cboyear1+'-'+@cboMonth1+'-'+@cboDay1+ ''' AND '''  +@cboyear2+'-'+@cboMonth2+'-'+@cboDay2+''''
		END


ELSE   -- 최종수정일
		BEGIN  
		SET @strWhere2 = 
		' AND ModDate BETWEEN ''' + @cboyear1+'-'+@cboMonth1+'-'+@cboDay1+'''  AND '''  + @cboyear2+'-'+@cboMonth2+'-'+@cboDay2+''''

		END


	IF @cboSearch ='UserID' --아이디
		BEGIN 
		SET @strWhere3 = 
			' AND UserID LIKE  ''%'+@txtSearch+'%'''
		END
	
	ELSE IF @cboSearch = 'UserName' --이름
		BEGIN 
		SET 	@strWhere3 = 
			' AND UserName  LIKE  ''%'+@txtSearch+'%'''
		END
	
	ELSE IF @cboSearch = 'JuminNo' -- 주민번호
		BEGIN 
		SET 
			@strWhere3 = 
			' AND JuminNo LIKE  ''%'+@txtSearch+'%'''
		END
	
	ELSE  IF @cboSearch = 'Email' -- 이메일
			BEGIN  
			SET @strWhere3 = 
				' AND  Email  LIKE  ''%'+@txtSearch+'%'''
			END
	ELSE  IF @cboSearch = 'Title' -- 이력서 제목
			BEGIN  
			SET @strWhere3 = 
				' AND  Title  LIKE  ''%'+@txtSearch+'%'''
			END
	ELSE  IF @cboSearch = 'MergeText' --내용
			BEGIN  
			SET @strWhere3 = 
				' AND  MergeText  LIKE  ''%'+@txtSearch+'%'''
			END
	ELSE  IF @cboSearch ='All' --전체
			BEGIN  
			SET @strWhere3 = 
				' AND  MergeText  LIKE  ''%'+@txtSearch+'%'''
			END

	ELSE
			BEGIN  
			SET @strWhere3 = 
				' AND  RecProxyGbn=1 AND DelFlag = 0'
			END	
	

	IF @search =''
			BEGIN
			SET @strQuery1 =
				'SELECT AdId, UserID, Title, OptGbn, OpenFlag,ViewCnt, RecProxyGbn, '+
					'CONVERT(VARCHAR(10), OptEnDate, 120) AS OptEnDate, ' +
					'CONVERT(VARCHAR(10), OptStDate, 120) AS OptStDate, ' +
					'DelFlag,'+	
					'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate ' +
					'FROM Resume WHERE DelFlag=0 and RecProxyGbn=1'+' ORDER BY RegDate DESC'
		
			  
			END
	ELSE

			BEGIN
			SET @strQuery1 =
				'SELECT AdId, UserID, Title, OptGbn, OpenFlag, ViewCnt, RecProxyGbn, '+
					'CONVERT(VARCHAR(10), OptEnDate, 120) AS OptEnDate, ' +
					'CONVERT(VARCHAR(10), OptStDate, 120) AS OptStDate, ' +
					'DelFlag,'+	
					'CONVERT(VARCHAR(10), RegDate, 120) AS RegDate ' +
					'FROM Resume WHERE DelFlag=0 and RecProxyGbn=1'+ @strWhere1 + @strWhere2 + @strWhere3 +' ORDER BY RegDate DESC'
		
			  
			END


END
Print(@strWhere1)
Print(@strQuery1)
EXEC(@strQuery1)
GO
/****** Object:  StoredProcedure [dbo].[procMagCardList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 결제정보 리스트
	제작자	: 이창국
	제작일	: 2002-03-29
	셜명	:
	PageSize	: 페이지당 게시물 개수
	Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procMagCardList_DelAN] 
(
	@PageSize	INT		-- 페이지당 게시물 개수
	, @Page		INT		-- Jump할 페이지
	, @AdGbn	CHAR(1)		-- 구분(1:구인 2: 구직)
	, @ChargeKind	CHAR(1)		-- 결재종류
	,@txtSearch	VARCHAR(1000)	--검색키워드	
		
)
AS

BEGIN

DECLARE @SQL varchar(2000)

DECLARE @DATE VARCHAR(10)
SET @DATE = CONVERT(VARCHAR(10), GetDate(),120)

IF @AdGbn = '1'
	BEGIN
		SET @SQL = 	'SELECT TOP 1 COUNT(T1.AdGbn) FROM RecCharge T1, JobOffer T2 ' +
				'WHERE T1.AdGbn='+@AdGbn+' AND T1.AdId = T2.AdId AND ' +
				'T1.ChargeKind=' +@ChargeKind + ' ' +
				@txtSearch + '; ' + 

				'SELECT TOP  ' +  CONVERT(varchar(10), @Page*@PageSize) + ' ' +
				'T2.AdId,T2.UserID, T2.ShopNm,T2.OptGbn, T2.OptKind,  ' +
				'T2.RegDate, T2.OptStDate,T2.OptEnDate, ' +
				'T2.OptAmt, T1.AdId,T1.CardIStatusDate, T1.CardStatus ' +
				'FROM RecCharge T1, JobOffer T2 ' +
				'WHERE T1.AdGbn='+@AdGbn+' AND T1.AdId = T2.AdId AND ' +
				'T1.ChargeKind=' +@ChargeKind + ' ' +
				@txtSearch + ' ORDER BY T2.RegDate DESC '
	END
ElSE
	BEGIN
		SET @SQL = 	'SELECT TOP 1 COUNT(T1.AdGbn) FROM RecCharge T1, Resume T2 ' +
				'WHERE T1.AdGbn='+@AdGbn+' AND T1.AdId = T2.AdId AND ' +
				'T1.ChargeKind=' +@ChargeKind + ' ' +
				@txtSearch + '; ' + 

				'SELECT TOP  ' +  CONVERT(varchar(10), @Page*@PageSize) + ' ' +
				'T2.AdId,T2.UserID, T2.UserName,T2.OptGbn, T2.OptKind, ' +
				'T2.RegDate, T2.OptStDate,T2.OptEnDate, ' +
				'T2.OptAmt, T1.AdId, T1.CardIStatusDate, T1.CardStatus ' +
				'FROM RecCharge T1, Resume T2 ' +
				'WHERE T1.AdGbn='+@AdGbn+' AND T1.AdId = T2.AdId AND ' +
				'T1.ChargeKind=' +@ChargeKind + ' ' +
				@txtSearch + ' ORDER BY T2.RegDate DESC '

	END

EXEC(@SQL)

END
GO
/****** Object:  StoredProcedure [dbo].[procMagEtcInsert]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 카테고리관리 입력
	제작자	: 이창국
	제작일	: 2002-03-06
*************************************************************************************/

CREATE PROCEDURE [dbo].[procMagEtcInsert]
(
@InsertOpt	varchar(1),		-- '1':카테토리추가, '2':소분류추가
@SrvGbn	int,		-- 카테토리 코드
@SrvName1	varchar(100),		-- 카테토리명
@SrvName2	varchar(100),		-- 소분류명
@UseFlag	char(1)		-- 상태
)
AS

BEGIN

	SET NOCOUNT ON

	BEGIN TRANSACTION

	IF @InsertOpt = '1'		-- 카테토리추가
		BEGIN

			DECLARE @SrvGbnCnt int	--카테고리의 SrvGbn Max 값

			--카테고리의 SrvGbn Max 값 구하기
			SELECT		@SrvGbnCnt = MAX(SrvCode)
			FROM		ServiceCode
			WHERE 		SrvGbn = 999
	
			SET @SrvGbnCnt = (ISNULL (@SrvGbnCnt, 90))
			SET @SrvGbnCnt = @SrvGbnCnt + 10
	
			--카테고리 추가
			INSERT	INTO	ServiceCode
			(
			SrvGbn
			,SrvCode     
			,SrvName
			,UseFlag 
			)
			VALUES
			(
			999
			,@SrvGbnCnt     
			,@SrvName1
			,@UseFlag 
			)

			IF @@ERROR = 0 
				BEGIN
				    	COMMIT TRAN
					SELECT @SrvGbnCnt
				END
			ELSE
				BEGIN
					ROLLBACK
					SELECT ''
				END

		END

	ELSE-- @InsertOpt = '2'		-- 소분류추가

		BEGIN

			DECLARE @SrvCodeCnt int	--소분류의 SrvCode Max 값

			--카테고리의 SrvGbn Max 값 구하기
			SELECT		@SrvCodeCnt = MAX(SrvCode)
			FROM		ServiceCode
			WHERE 		SrvGbn <> 999  AND SrvGbn = @SrvGbn
	
			SET @SrvCodeCnt = (ISNULL (@SrvCodeCnt, 9))
			SET @SrvCodeCnt = @SrvCodeCnt + 1

			--소분류 추가
			INSERT	INTO	ServiceCode
			(
			SrvGbn
			,SrvCode     
			,SrvName
			,UseFlag
			)
			VALUES
			(
			@SrvGbn
			,@SrvCodeCnt     
			,@SrvName2
			,@UseFlag 
			)
	
			IF @@ERROR = 0 
				BEGIN
				    	COMMIT TRAN
					SELECT @SrvGbn
				END
			ELSE
				BEGIN
					ROLLBACK
					SELECT ''
				END


		END


	SET NOCOUNT OFF


END
GO
/****** Object:  StoredProcedure [dbo].[procMagEtcList]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 카테고리관리 리스트
	제작자	: 이창국
	제작일	: 2002-03-06
	PageSize	: 페이지당 게시물 개수
	Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procMagEtcList]
(
@SrvGbn	int,		-- 대분류코드
@SrvName	varchar(100),	-- 소분류 검색	
@UseFlag	char(1),		-- 상태 검색
@PageSize	int,
@Page	int
)
AS
BEGIN

SET NOCOUNT ON

	DECLARE @KeyWordSql varchar(100)
	SET	@KeyWordSql = ''

	IF @SrvGbn <> 0
		BEGIN
			SET	@KeyWordSql = ' AND SrvGbn = ' +  CONVERT(varchar(10), @SrvGbn) + ' '
		END

	IF @SrvName <> ''
		BEGIN
			SET	@KeyWordSql = @KeyWordSql + ' AND SrvName LIKE ''%' + @SrvName + '%'' '
		END

	IF @UseFlag <> ''
		BEGIN
			SET	@KeyWordSql = @KeyWordSql + ' AND UseFlag = ''' + @UseFlag + ''' '
		END


	DECLARE @strQuery varchar(1000)
	SET @strQuery = 	'SELECT TOP 1 COUNT(Serial) FROM ServiceCode WHERE SrvGbn <> 999 ' + @KeyWordSql + ' ; ' +
			'SELECT Serial, SrvGbn, SrvCode, SrvName, UseFlag FROM ServiceCode WHERE SrvGbn = 999  ORDER BY SrvCode; ' +
			'SELECT TOP ' + CONVERT(varchar(10), @Page*@PageSize) + ' Serial, SrvGbn, SrvCode, SrvName, UseFlag ' +
			'FROM ServiceCode WHERE SrvGbn <> 999  '+@KeyWordSql + ' ORDER BY SrvGbn, SrvCode '


EXEC(@strQuery)

SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [dbo].[procMagEtcModify]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 기타분류관리 중분류 수정 프로시저
	제작자	: 이창국
	제작일	: 2002-03-12
*************************************************************************************/

CREATE PROCEDURE [dbo].[procMagEtcModify]
(
	@Serial			INT   		--시리얼 번호
,	@SrvName		VARCHAR(30)	--중분류명

)
AS

BEGIN
BEGIN TRANSACTION


	UPDATE	ServiceCode  SET
		SrvName	=	@SrvName
	WHERE Serial= @Serial 


	IF @@ERROR = 0 
		BEGIN
		    	COMMIT TRAN
		END
	ELSE
		BEGIN
			ROLLBACK
		END

END
GO
/****** Object:  StoredProcedure [dbo].[procMagGuinList]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 구인광고관리 리스트
	제작자	: 이창국
	제작일	: 2002-03-29
	PageSize	: 페이지당 게시물 개수
	Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procMagGuinList]
(
@SQLOpt	CHAR(1),		--'1':전체,'2':불량,'3':직종별,'4':지역별,'5':급여별,'6':시간대별,'7':근무형태별 
@Query		VARCHAR(1000),	--WHERE절
@PageSize	INT,
@Page		INT
)
AS
BEGIN

SET NOCOUNT ON

--	DECLARE @CNTQuery VARCHAR(500)--조건이 존재할시 전체이력서에서의 AND를 빼고 WHERE 를 넣기 위한 변수
	DECLARE @DATE VARCHAR(10)--날짜

	SET @DATE = CONVERT(VARCHAR(10), GETDATE(), 120)

--	IF @Query <> ''
--		BEGIN
--			 SET @CNTQuery  = ' WHERE ' + SUBSTRING(@Query, 4, (LEN(@Query)-3) )
--		END

	DECLARE @SQL VARCHAR(2000)

	IF @SQLOpt = '1' --전체 이력서
		BEGIN
			SET @SQL = 	'SELECT TOP 1 COUNT(T1.AdId) ' +
					'FROM JobOffer T1 WHERE ' + 
					'CONVERT(VARCHAR(10), T1.RecEnDate,120)  >= ''' + @DATE + '''  ' + 
					@Query + '; ' +
					'SELECT TOP ' +  CONVERT(varchar(10), @Page*@PageSize) + ' ' +
					'	T1.AdId AS AdId, T1.UserID AS UserID, ' +
					'	T1.Title, T1.OptGbn,  T1.OptKind,  ' +
					'	CONVERT(VARCHAR(10),T1.RecEnDate,120) AS RecEnDate,  ' +
					'	CONVERT(VARCHAR(10),T1.RegDate,120) AS RegDate,  ' +
					'	T1.ViewCnt AS ViewCnt, ' +
					'	COUNT(T2.Serial) AS AppInfoCnt  ' +
					'FROM JobOffer T1, AppInfo T2 ' +
					'WHERE T1.AdId *= T2.JobAdId AND ' +
					'CONVERT(VARCHAR(10), T1.RecEnDate,120)  >= ''' + @DATE + '''  ' + 
					@Query +
					'GROUP BY T1.RegDate, T1.AdId, T1.UserID, T1.Title, T1.RecEnDate, T1.ViewCnt, T1.OptGbn,  T1.OptKind  ' +
					'ORDER BY T1.RegDate DESC ' 
		END
	ELSE IF @SQLOpt = '2' --불량 이력서
		BEGIN
			SET @SQL = 	' '
		END
	ELSE IF @SQLOpt = '3' --직종별 이력서
		BEGIN
			SET @SQL = 	'SELECT DiSTINCT Code1, CodeNm1, Count(Code1) AS Cnt , OrderNo1 '+
					'FROM AlbaCommon.dbo.JobCode ' +
					'WHERE UseFlag = ''Y'' ' +
					'GROUP BY Code1, CodeNm1, OrderNo1 ' +
					'ORDER BY OrderNo1;  ' +
					'SELECT JobCode1, JobCode2 FROM JobOffer WHERE DelFlag = ''0''  AND ' +
					'CONVERT(VARCHAR(10),RecEnDate,120)  >= ''' + @DATE + ''' ; ' +
					'SELECT Code1, Code2, CodeNm1, CodeNm2 ' +
					'FROM AlbaCommon.dbo.JobCode ' +
					'WHERE UseFlag = ''Y'' ' +
					'ORDER BY OrderNo1, OrderNo2 '
		END
	ELSE IF @SQLOpt = '4' --지역별 이력서
		BEGIN
			SET @SQL = 	'SELECT LCode, Metro, City  ' +
					'FROM FindCommon.dbo.AreaCode ' +
					'WHERE  UseFlag = ''Y''  ' +
					'ORDER BY LCode ; ' + 
					'SELECT WorkPlace2 FROM Resume WHERE DelFlag = ''0''; ' 
		END
	ELSE IF @SQLOpt = '5' --급여별 이력서
		BEGIN
			SET @SQL = 	'SELECT PayType, Pay FROM JobOffer WHERE DelFlag = ''0'' AND ' +
					'CONVERT(VARCHAR(10),RecEnDate,120)  >= ''' + @DATE + ''' ; ' 
		END
	ELSE IF @SQLOpt = '6' --시간대별 이력서
		BEGIN
			SET @SQL =	'SELECT WorkTime FROM JobOffer WHERE DelFlag = ''0'' AND ' +
					'CONVERT(VARCHAR(10),RecEnDate,120)  >= ''' + @DATE + ''' ; ' 
		END
	ELSE IF @SQLOpt = '7' --근무형태별 이력서
		BEGIN
			SET @SQL =	'SELECT WorkType FROM JobOffer WHERE DelFlag = ''0'' AND ' +
					'CONVERT(VARCHAR(10),RecEnDate,120)  >= ''' + @DATE + ''' ; ' 
		END

	PRINT(@SQL)
	EXEC(@SQL)

END
GO
/****** Object:  StoredProcedure [dbo].[procMagJobCodeInsert]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 카테고리관리 입력
	제작자	: 이창국
	제작일	: 2002-03-11
	
	rdoCode		:대분류추가인지 소분류 추가인지 구분
	txtCodeNm1	:대분류추가시 대분류명
	txtCodeNm2	:대분류추가시 소분류명
	rdoUseFlag	:대분류추가시 상태
	cboCode1	:소분류추가시 대분류선택
	rdoUseFlag2	:소분류추가시 상태
*************************************************************************************/

CREATE PROCEDURE [dbo].[procMagJobCodeInsert]
(
	@rdoCode	CHAR(1)	
,	@txtCodeNm1	VARCHAR(100)
,	@txtCodeNm2	VARCHAR(100)
,	@txtCodeNm3	VARCHAR(100)
,	@rdoUseFlag	CHAR(1)
,	@cboCode1	INT
,	@rdoUseFlag2	CHAR(1)

)
AS

BEGIN

	SET NOCOUNT ON

	BEGIN TRANSACTION

	IF @rdoCode = 'B'		-- 대분류 추가라면
		BEGIN

			DECLARE @MAXCode1	 INT
			DECLARE @MAXCode2 	 VARCHAR(10)
			DECLARE @MAXOrderNo1 	 INT
			
			SELECT  @MAXCode1=MAX(Code1) FROM JobCode

			SET @MAXCode1 = ISNULL(@MAXCode1,90)  
			SET @MAXCode1 = @MAXCode1 + 10
			
			SET @MAXCode2 = CONVERT(VARCHAR(10),@MAXCode1) +'100'
		
			SELECT @MAXOrderNo1=MAX(OrderNo1) FROM JobCode
			SET @MAXOrderNo1 = ISNULL(@MAXOrderNo1, 0)
			SET @MAXOrderNo1 = @MAXOrderNo1 + 1

			--카테고리 추가
			INSERT	INTO JobCode (Code1, Code2, CodeNm1, CodeNm2, OrderNo1, OrderNo2, UseFlag)
			VALUES
			(@MAXCode1, @MAXCode2, @txtCodeNm1,@txtCodeNm2, @MAXOrderNo1,1,@rdoUseFlag)
	

			IF @@ERROR = 0 
				BEGIN
				    	COMMIT TRAN
				END
			ELSE
				BEGIN
					ROLLBACK
				END

		END

	ELSE	-- 소분류추가

		BEGIN

			DECLARE @Code2	 INT
			DECLARE @CodeNm1	 VARCHAR(100)
			DECLARE @OrderNo1 	 INT
			DECLARE @MaxOrderNo2 	 INT
		
			SELECT @Code2=MAX(Code2) , @CodeNm1=CodeNm1 ,@OrderNo1=OrderNo1 FROM JobCode 
			WHERE Code1=@cboCode1 GROUP BY CodeNm1,OrderNo1
	
			SET @Code2 = ISNULL(@Code2, @cboCode1+90)  
			SET @Code2 = @Code2 + 10
			
			SELECT @MaxOrderNo2=MAX(OrderNo2) FROM JobCode WHERE Code1=@cboCode1
			SET @MaxOrderNo2 = ISNULL(@MaxOrderNo2, 0)
			SET @MaxOrderNo2 = @MaxOrderNo2 + 1

			--소분류 추가
			INSERT	INTO JobCode(Code1, Code2, CodeNm1, CodeNm2, OrderNo1, OrderNo2, UseFlag)
			VALUES(@cboCode1,@Code2,@CodeNm1,@txtCodeNm3,@OrderNo1, @MaxOrderNo2,@rdoUseFlag2)
	
			IF @@ERROR = 0 
				BEGIN
				    	COMMIT TRAN
				END
			ELSE
				BEGIN
					ROLLBACK
				END


			END


	SET NOCOUNT OFF


END
GO
/****** Object:  StoredProcedure [dbo].[procMagJobCodeList]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 카테고리 관리 게시판 리스트 프로시저
	제작자	: 이창국
	제작일	: 2002-03-11
	셜명	:
		PageSize	: 페이지당 게시물 개수
		Page		: Jump할 페이지
		cboCode1          	: 분류별검색
		cboUseFlag         : 분류별검색
		txtCodeNm2	: 분류별검색
*************************************************************************************/
CREATE PROCEDURE [dbo].[procMagJobCodeList] 
(
	@Page		int
,	@PageSize	int
,	@cboCode1	int 		
,	@cboUseFlag	CHAR(1) 	
,	@txtCodeNm2	VARCHAR(100)	
)
AS

--  검색쿼리 시작
DECLARE @SerCodeNm2 varchar(100)
DECLARE @SerUseFlagl varchar(100)

IF @cboCode1<>0 
BEGIN
	IF @txtCodeNm2 <> ''
		BEGIN
			SET	@SerCodeNm2 = 'AND CodeNm2 LIKE ''%' + @txtCodeNm2 + '%'' '
		END
	ELSE
		BEGIN
			SET	@SerCodeNm2 = ''
		END


	IF @cboUseFlag <> ''
		BEGIN
			SET	@SerUseFlagl = 'AND UseFlag=''' + @cboUseFlag + ''' '
		END
	ELSE
		BEGIN
			SET	@SerUseFlagl = ''
		END
END

IF @cboCode1=0 
BEGIN
	IF @txtCodeNm2 <> '' AND @cboUseFlag <> ''
		BEGIN
			SET	@SerCodeNm2 = ' WHERE CodeNm2 LIKE ''%' + @txtCodeNm2 + '%'' '
			SET	@SerUseFlagl = 'AND UseFlag=''' + @cboUseFlag + ''' '
		END

	IF @txtCodeNm2 <> '' AND @cboUseFlag=''
		BEGIN
		
			SET	@SerCodeNm2 = ' WHERE CodeNm2 LIKE ''%' + @txtCodeNm2 + '%'' '
			SET	@SerUseFlagl = ''
		END
	IF @txtCodeNm2 = '' AND @cboUseFlag <>''
		BEGIN
		
			SET	@SerCodeNm2 = ''
			SET	@SerUseFlagl = ' WHERE UseFlag=''' + @cboUseFlag + ''' '
		END
	IF @txtCodeNm2 = '' AND @cboUseFlag =''
		BEGIN
		
			SET	@SerCodeNm2 = ''
			SET	@SerUseFlagl = ''
		END
		

END
-- 검색쿼리 끝

-- 등록된 카테고리  갯수/리스트 가져오기
	
DECLARE @Sql	varchar(2000)
SET @Sql =

	CASE
		WHEN @cboCode1 = 0 THEN
			'SELECT COUNT(Code1) FROM JobCode' + @SerCodeNm2 + ' ' + @SerUseFlagl + ' ' + ';'  +
			'SELECT TOP ' + CONVERT(varchar(10), @Page*@PageSize) + ' Code1, Code2, CodeNm1,' + ' ' +
			'CodeNm2, OrderNo1, OrderNo2, UseFlag'  + ' ' +	
			'FROM JobCode' + ' ' +	
			@SerCodeNm2 + ' ' + @SerUseFlagl + ' ' +
			'Order by OrderNo1, OrderNo2'

		ELSE
			'SELECT COUNT(Code1) FROM JobCode Where Code1=' + CONVERT(varchar(10),@cboCode1) +	@SerCodeNm2 + ' ' + @SerUseFlagl + ' ' + ';'  +
			'SELECT TOP ' + CONVERT(varchar(10), @Page*@PageSize) + ' Code1, Code2, CodeNm1, '  +
			'CodeNm2, OrderNo1, OrderNo2, UseFlag ' +	
			'FROM JobCode ' +
			'Where Code1=' + CONVERT(varchar(10),@cboCode1)  + ' ' +	@SerCodeNm2 + ' ' + @SerUseFlagl + ' ' +
			'Order by OrderNo1, OrderNo2'

	END


EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[procMagJobCodeModify]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 직종별 카테고리관리 중분류 수정 프로시저
	제작자	: 이창국
	제작일	: 2002-03-12
*************************************************************************************/
CREATE PROCEDURE [dbo].[procMagJobCodeModify]
(
@Code2		INT		--수정될 대분류 코드
,@CodeNm2	VARCHAR(100)	--수정될 중분류명
)
AS

BEGIN
	BEGIN TRANSACTION
	--[수정시작]

	UPDATE	JobCode  SET
		CodeNm2	=	@CodeNm2
	WHERE Code2=@Code2
	
	IF @@ERROR = 0 
		BEGIN
		    	COMMIT TRAN
		END
	ELSE
		BEGIN
			ROLLBACK
		END

END
GO
/****** Object:  StoredProcedure [dbo].[procMagJobOfferInsForm_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	:구인광고 등록 대행 입력
	제작자	: 김종진
	제작일	: 2002-04-08
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procMagJobOfferInsForm_DelAN]


		@strUserID		varchar(30) 
	,	@strShopNm		varchar(50) 
	,	@strManager		varchar(30) 
	,	@strEmail		varchar(50) 
	,	@strPhone		varchar(50) 
	,	@strHPhone		varchar(50) 
	,	@strZipCode		varchar(6)  
	,	@strAddress1		varchar(100)
	,	@strAddress2		varchar(100)
	,	@strShopUrl		varchar(50) 
	,	@strAppDesk		varchar(50) 
	,	@strRecStDate		datetime    
	,	@strRecEnDate		datetime    
	,	@strTitle			varchar(200)
	,	@strJobCode1		varchar(50) 
	,	@strJobCode2		varchar(50) 
	,	@strWorkPlace1		varchar(100) 
	,	@strWorkPlace2		varchar(100) 
	,	@strLocalBranch		varchar(100) 
	,	@strWorkType		varchar(10)
	,	@strWorkTime		varchar(10)
	,	@strPayType		varchar(10) 
	,	@strPay			varchar(10) 
	,	@strSex			varchar(10) 
	,	@strAgeLimit		char(1)     
	,	@intAge1		int         
	,	@intAge2		int         
	,	@strSchool		varchar(30) 
	,	@strCareer		varchar(30) 
	,	@strEtcData		text        
	,	@intViewCnt		int         
	,	@strOptGbn		char(1) 
	,	@strOptKind    		char(10) 
	,	@strOptStDate		datetime    
	,	@strOptEnDate		datetime    
	,	@intOptAmt		int         
	,	@strChargeKind		char(1) 
	,	@strDelFlag		char(1)   
	,	@strRecProxyGbn	char(1)     
	,	@strRecProxy		varchar(30) 
	,	@strRegDate		datetime    
	,	@strMergeText		varchar(6000)		
	
AS						      
						      
BEGIN							

BEGIN DISTRIBUTED TRANSACTION

	INSERT	INTO	JobOffer
(

		UserID	
,		ShopNm	
,		Manager	
,		Email	
,		Phone	
,		HPhone	
,		ZipCode	
,		Address1
,		Address2
,		ShopUrl	
,		AppDesk	
,		RecStDate
,		RecEnDate
,		Title	
,		JobCode1	
,		JobCode2
,		WorkPlace1
,		WorkPlace2
,		LocalBranch
,		WorkType
,		WorkTime
,		PayType	
,		Pay	
,		Sex	
,		AgeLimit
,		Age1	
,		Age2	
,		School	
,		Career	
,		EtcData	
,		ViewCnt	
,		OptGbn	
,		OptKind
,		OptStDate
,		OptEnDate
,		OptAmt	
,		ChargeKind
,		DelFlag
,		RecProxyGbn
,		RecProxy
,		RegDate	
,		MergeText

)
VALUES
(
			  
		@strUserID		  
	,	@strShopNm		  
	,	@strManager		  
	,	@strEmail			  
	,	@strPhone			  
	,	@strHPhone		  
	,	@strZipCode		  
	,	@strAddress1	  
	,	@strAddress2	  
	,	@strShopUrl		  
	,	@strAppDesk		  
	,	@strRecStDate	  
	,	@strRecEnDate	  
	,	@strTitle			  
	,	@strJobCode1	  
	,	@strJobCode2	  
	,	@strWorkPlace1	
	,	@strWorkPlace2
	,	@strLocalBranch
	,	@strWorkType	  
	,	@strWorkTime	  
	,	@strPayType		  
	,	@strPay			    
	,	@strSex			    
	,	@strAgeLimit	  
	,	@intAge1		    
	,	@intAge2		    
	,	@strSchool		  
	,	@strCareer		  
	,	@strEtcData		  
	,	@intViewCnt		  
	,	@strOptGbn
	,	@strOptKind		  
	,	@strOptStDate	  
	,	@strOptEnDate	  
	,	@intOptAmt		  
	,	@strChargeKind	
	,	@strDelFlag
	,	@strRecProxyGbn	
	,	@strRecProxy		
	,	@strRegDate		
	,	@strMergeText  

)

IF @@ERROR = 0 
	BEGIN

	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procMagOptionList_Old_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	:	옵션정보	리스트
	제작자	:	김종진
	제작일	:	2002-03-29
	셜명	:
		PageSize	:	페이지당	게시물	개수
		Page		:	Jump할	페이지
*************************************************************************************/

CREATE PROCEDURE	[dbo].[procMagOptionList_Old_DelAN]	
(
	@PageSize	int		-- 페이지당 게시물 개수
,	@Page		int		-- Jump할 페이지
,	@cboAdGbn	varchar(10)	-- 검색할 테이블명
,	@cboOptGbn	char(1)		-- 옵션종류
,	@cboStatus	char(1)		-- 게재구분
,	@cboTerm	varchar(10)	-- 검색기간구분
,	@FromDate	datetime	-- 검색시작일
,	@ToDate	datetime	-- 검색종료일
,	@cboPeriod	varchar(10)
,	@txtKeyword	varchar(40)
)
AS

-- 테이블에 따른 UserNm, ShopNm 구분
DECLARE @UserNm	varchar(10)
SET @UserNm = 
CASE
	WHEN @cboAdGbn = 'JobOffer' THEN 'ShopNm'
	WHEN @cboAdGbn = 'Resume' THEN 'UserName'
	ELSE 'ShopNm'
END

-- 옵션종류구분
DECLARE @OptGbnSql	varchar(100)
IF @cboOptGbn <> ''
	BEGIN
		SET	@OptGbnSql = 'AND OptGbn = ' + @cboOptGbn
	END
ELSE
	BEGIN
		SET	@OptGbnSql = ''
	END

-- 게재구분 쿼리
DECLARE @StatusSql	varchar(100)
IF @cboStatus <> ''
	SET	@StatusSql =
	CASE
		WHEN @cboStatus = '1' THEN	-- 게재전
			'AND GetDate() < OptStDate '
		WHEN @cboStatus = '2' THEN	-- 게재중
			'AND (GetDate() >= OptStDate AND GetDate() <= OptEnDate) '
		WHEN @cboStatus = '3' THEN	-- 마감
			'AND GetDate() > OptEnDate '
	END
ELSE
	BEGIN
		SET	@StatusSql = ''
	END

-- 검색기간 쿼리
DECLARE @TermSql	varchar(300)
IF @cboTerm <> ''
	BEGIN
		SET	@TermSql = 'AND (CONVERT(varchar(10), ' + @cboTerm + ', 120) >= ' + '''' + CONVERT(varchar(10), @FromDate, 120) + '''' +
				' AND CONVERT(varchar(10), ' + @cboTerm + ', 120) <= ' + '''' + CONVERT(varchar(10), @ToDate, 120) + ''') '
	END
ELSE
	BEGIN
		SET	@TermSql = ''
	END

-- 키워드 검색쿼리
DECLARE @KeyWordSql varchar(200)
SET	@cboPeriod =
CASE
	WHEN @cboAdGbn = 'JobOffer' AND @cboPeriod = 'UserName' THEN 'ShopNm'
	WHEN @cboAdGbn = 'Resume' AND @cboPeriod = 'UserName' THEN 'UserName'
	ELSE @cboPeriod
END

IF @cboPeriod <> '' AND @txtKeyWord <> ''
	BEGIN
		SET	@KeyWordSql = 'AND REPLACE(' + @cboPeriod + ', '' '', '''') LIKE ''%' + @txtKeyWord + '%'' '
	END
ELSE
	BEGIN
		SET	@KeyWordSql = ''
	END

-- 모든 쿼리
DECLARE @AllSql	varchar(4000)
SET @AllSql =  @OptGbnSql + @StatusSql + @TermSql + @KeyWordSql

DECLARE @Sql		varchar(6000)
SET @Sql =
		'SELECT COUNT(AdId) FROM ' + @cboAdGbn + ' WHERE OptGbn > 0 AND DelFlag = 0 ' + @AllSql + '; ' +
		'SELECT TOP ' + CONVERT(varchar(10), @Page*@PageSize) + ' AdId, UserID, ' + @UserNm + ' AS UserNm, Title, OptGbn, OptKind, OptAmt, '+
		'OptStDate, OptEnDate, RegDate, DelFlag, ' +
		'CASE ' +
		' WHEN GetDate() < OptStDate THEN ''게재전'' ' +
		' WHEN GetDate() > OptEnDate THEN ''마감'' ' +
		' WHEN (GetDate() >= OptStDate AND GetDate() <= OptEnDate) THEN ''게재중'' ' +
		'END AS OptStatus ' +
		'FROM ' + @cboAdGbn + ' WHERE OptGbn > 0 AND DelFlag = 0 ' + @AllSql + ' ORDER BY AdId DESC'

Print(@Sql)
EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[procMagResumeInsForm_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 이력서 등록
	제작자	: 김종진
	제작일	: 2002-03-22
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procMagResumeInsForm_DelAN]
	 @strUserID			  varchar(30)	 												
	,@strUserName		  	  varchar(30)	 												
	,@strJuminNo			  varchar(20)	 												
	,@strPhone			  varchar(50)	 													
	,@strHPhone			  varchar(50)	 													
	,@strEmail			  varchar(50)	 													
	,@strZipCode			  varchar(6)	 													
	,@strAddress1			  varchar(100) 													
	,@strAddress2			  varchar(100) 													
	,@strTitle			  varchar(200) 													
	,@strJobCode1			  varchar(50)	 
	,@strJobCode2		 	  varchar(50)	 
	,@strWorkPlace1	    	  varchar(20)	 
	,@strWorkPlace2	   	  varchar(20)	 
	,@strLocalBranch  	 	  varchar(100) 
	,@strWorkType		  	  varchar(100) 
	,@strWorkTime		  	  varchar(100) 
	,@strPayType			  varchar(10)	 
	,@strPay			  varchar(20)	 
	,@strBeAtWork		    	 char(1)	     
	,@strAtWorkDate	    	 varchar(10)	 
	,@strOpenFlag		    	 char(1)		   
	,@strSchoolGbn		  	 varchar(50)	 
	,@strSchoolRecord   		 varchar(200) 
	,@strCareer			 varchar(50)	 
	,@strCareerRecord   		 varchar(200) 
	,@strEtcData			 text	       
	,@strSelfIntro		  	 text	       
	,@strOptGbn			 char(1)
	,@strOptKind	         		char(10)	
	,@strOptStDate		  	datetime       
	,@strOptEnDate		 	 datetime	   
	,@strOptAmt			int 	
	,@strDelFlag   			char(1)
	,@strRegDate			datetime 
	,@strRecProxyGbn		char(1)	
	,@strRecProxy			varchar(30) 
	,@strMergeText			varchar(6000) 
   
AS
BEGIN							

BEGIN DISTRIBUTED TRANSACTION
IF @strOptStDate='' 
BEGIN
	SET @strOptStDate = NULL
END

IF @strOptEnDate='' 
BEGIN
	SET @strOptEnDate = NULL
END

	INSERT	INTO	Resume
(
	 UserID			  
	,UserName		  
	,JuminNo			
	,Phone				
	,HPhone				
	,Email				
	,ZipCode			
	,Address1			
	,Address2			
	,Title				
	,JobCode1		  
	,JobCode2		  
	,WorkPlace1	  
	,WorkPlace2	  
	,LocalBranch 
	,WorkType		  
	,WorkTime		  
	,PayType			
	,Pay					
	,BeAtWork		  
	,AtWorkDate	  
	,OpenFlag		  
	,SchoolGbn		
	,SchoolRecord 
	,Career			  
	,CareerRecord 
	,EtcData			
	,SelfIntro		
	,OptGbn
	,OptKind			  
	,OptStDate		
	,OptEnDate		
	,OptAmt	
	,DelFlag		  
	,RegDate	
	,RecProxyGbn
	,RecProxy	
	,MergeText	



		
)

VALUES
(
	 @strUserID			  
	,@strUserName		  
	,@strJuminNo			
	,@strPhone				
	,@strHPhone				
	,@strEmail				
	,@strZipCode			
	,@strAddress1			
	,@strAddress2			
	,@strTitle				
	,@strJobCode1		  
	,@strJobCode2		  
	,@strWorkPlace1	  
	,@strWorkPlace2	  
	,@strLocalBranch 
	,@strWorkType		  
	,@strWorkTime		  
	,@strPayType			
	,@strPay					
	,@strBeAtWork		  
	,@strAtWorkDate	  
	,@strOpenFlag		  
	,@strSchoolGbn		
	,@strSchoolRecord 
	,@strCareer			  
	,@strCareerRecord 
	,@strEtcData			
	,@strSelfIntro		
	,@strOptGbn
	,@strOptKind			  
	,@strOptStDate		
	,@strOptEnDate		
	,@strOptAmt	
	,@strDelFlag		  
	,@strRegDate	
	,@strRecProxyGbn
	,@strRecProxy	
	,@strMergeText	
		
)

IF @@ERROR = 0 
	BEGIN

	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procMagResumeList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 이력서관리 리스트
	제작자	: 이창국
	제작일	: 2002-03-22
	PageSize	: 페이지당 게시물 개수
	Page		: Jump할 페이지
*************************************************************************************/

CREATE PROCEDURE [dbo].[procMagResumeList_DelAN]
(
@SQLOpt	CHAR(1),		--'1':전체,'2':불량,'3':직종별,'4':지역별,'5':급여별,'6':시간대별,'7':근무형태별 
@Query		VARCHAR(1000),	--WHERE절
@PageSize	INT,
@Page		INT
)
AS
BEGIN

SET NOCOUNT ON


	DECLARE @SQL VARCHAR(1000)

	IF @SQLOpt = '1' --전체 이력서
		BEGIN
			SET @SQL = 	'SELECT TOP 1 COUNT(AdId) FROM Resume' + @Query + ' ;  ' +
					'SELECT  TOP ' + CONVERT(varchar(10), @Page*@PageSize) + ' ' +
					'AdId, UserID, Title, OpenFlag, ViewCnt, OptGbn, OptKind, ' +
					'CONVERT(VARCHAR(10),RegDate,120) AS RegDate FROM Resume  ' +
					@Query +
					' ORDER BY RegDate DESC , ModDate DESC '
		END
	ELSE IF @SQLOpt = '2' --불량 이력서
		BEGIN
			SET @SQL = 	' '
		END
	ELSE IF @SQLOpt = '3' --직종별 이력서
		BEGIN
			SET @SQL = 	'SELECT DiSTINCT Code1, CodeNm1, Count(Code1) AS Cnt , OrderNo1 '+
					'FROM AlbaCommon.dbo.JobCode ' +
					'WHERE UseFlag = ''Y'' ' +
					'GROUP BY Code1, CodeNm1, OrderNo1 ' +
					'ORDER BY OrderNo1;  ' +
					'SELECT JobCode1, JobCode2 FROM Resume WHERE DelFlag = ''0'' ; ' +
					'SELECT Code1, Code2, CodeNm1, CodeNm2 ' +
					'FROM AlbaCommon.dbo.JobCode ' +
					'WHERE UseFlag = ''Y'' ' +
					'ORDER BY OrderNo1, OrderNo2 '
		END
	ELSE IF @SQLOpt = '4' --지역별 이력서
		BEGIN
			SET @SQL = 	'SELECT LCode, Metro, City  ' +
					'FROM FindCommon.dbo.AreaCode ' +
					'WHERE  UseFlag = ''Y''  ' +
					'ORDER BY LCode ; ' + 
					'SELECT WorkPlace2 FROM Resume WHERE DelFlag = ''0''; ' 
		END
	ELSE IF @SQLOpt = '5' --급여별 이력서
		BEGIN
			SET @SQL = 	'SELECT PayType, Pay FROM Resume WHERE DelFlag = ''0''; ' 
		END
	ELSE IF @SQLOpt = '6' --시간대별 이력서
		BEGIN
			SET @SQL =	'SELECT WorkTime FROM Resume WHERE DelFlag = ''0''; ' 
		END
	ELSE IF @SQLOpt = '7' --근무형태별 이력서
		BEGIN
			SET @SQL =	'SELECT WorkType FROM Resume WHERE DelFlag = ''0''; ' 
		END


	EXEC(@SQL)

END
GO
/****** Object:  StoredProcedure [dbo].[procMagUserDelete]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[procMagUserDelete] 
(
	@UserId	varchar(50),
	@DelChannel	varchar(10),
	@strDelReason  varchar(40) = ' ',
	@strDelEtcReason varchar(300) = ' ',
	@strDelReasonChk  varchar(2)
)
AS


	DECLARE @strPassword varchar(20)
	DECLARE @strJuminNo varchar(20)
	DECLARE @strInsChannel varchar(20)
	DECLARE @strUserName varchar(20)
	DECLARE @strEmail varchar(20)
	DECLARE @UserGbn varchar(1)
	DECLARE @DelYear varchar(3)
	DECLARE @UserRegDate varchar(20)
	DECLARE @DelAge int


	-- UserCommon 테이블에서 UserCommon_Del 테이블로 정보를 이동
	--INSERT INTO UserCommon_Del
	--	SELECT * FROM UserCommon WHERE UserId = @UserId
	-- UserCommon 테이블의 정보 삭제
	--DELETE FROM UserCommon WHERE UserId = @UserId

	
	SELECT @strUserName = UserName,  @strPassword = Password, @strJuminNo = JuminNo,  @strInsChannel = InsChannel, @strEmail=Email,  @UserRegDate=RegDate, @UserGbn=UserGbn FROM UserCommon WITH (Nolock)  WHERE UserID=@UserId

	IF  ( @UserGbn  !=  '2' ) 	--개인 또는 딜러회원만 계산 (기업회원제외)
		BEGIN 		
			SET @DelYear = substring(@strJuminNo,8,1)

			IF  (@DelYear = '1') or (@DelYear = '2')	
				BEGIN
					SET @DelAge  = 1900
				END
			ELSE		
				BEGIN		
					SET @DelAge = 2000
				END
				
			SET @DelAge = @DelAge + Convert(int,substring(@strJuminNo,1,2))
		
			IF ( IsNumeric(@DelAge) = 1 )  AND (@DelAge > '0') 
				BEGIN
					SET @DelAge =  datepart(year,getdate()) - @DelAge + 1
				END
			ELSE
				BEGIN
					SET @DelAge = 0
				END
			
		END
	ELSE
		BEGIN
			SET @DelAge = 0
		END


	--탈퇴 처리
	
	IF @strDelReasonChk = '1'
		UPDATE UserCommon SET DelDate=getdate(), DelFlag=1, DelChannel=@DelChannel, DelLocalSite=0 WHERE UserID=@UserId
	ELSE
		UPDATE UserCommon SET DelDate=getdate(), DelFlag=1, AllDelFlag=1, DelChannel=@DelChannel, DelLocalSite=0 WHERE UserID=@UserId

	--UserAllPerson_Del Insert (모든 전문화사이트 공통 사용)

	INSERT INTO UserAllPerson_Del (UserID,RegDate,InsChannel,DelChannel,DelAge,DelReason,DelETC) VALUES ( convert(varchar,@UserId), @UserRegDate , @strInsChannel ,@DelChannel, convert(int,@DelAge), @strDelReason , @strDelEtcReason )
GO
/****** Object:  StoredProcedure [dbo].[procMemoSend_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	:합격/불합격 메모처리
	제작자	: 김종진
	제작일	: 2002-03-28
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procMemoSend_DelAN]

	 @strJobAdId	int          			--구인광고 순번
	,@strRecUserID	varchar(30)  		--이력서 아이디
	,@strMemoGbn	char(1)      
	,@strTitle	varchar(200) 
	,@strContents	varchar(6000)
	,@strSendDate	datetime     




AS
BEGIN
BEGIN DISTRIBUTED TRANSACTION

INSERT INTO MemoSend
(
	JobAdId
	,RecUSerID
	,MemoGbn
	,Title
	,Contents
	,SendDate
)
VALUES
(
	 @strJobAdId	
	,@strRecUserID
	,@strMemoGbn	
	,@strTitle		
	,@strContents	
	,@strSendDate	
)

IF @@ERROR = 0 
	BEGIN			
UPDATE AppInfo SET ProcFlag = @strMemoGbn, ProcDate=@strSendDate
WHERE JobAdId=@strJobAdId AND UserID=@strRecUserID


	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procNewBIDInsert]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procNewBIDInsert]
(
	@OldUserID			VARCHAR(30)
,	@ReInsert			CHAR(1)
,	@strUserID			VARCHAR(30)
,	@strPassword			VARCHAR(30)
,	@strUserGbn			CHAR(1)
,	@strUserName			VARCHAR(30)
,	@strJuminNo			VARCHAR(15)
,	@strRealNameChk		CHAR(1)
,	@strEmail			VARCHAR(50)
,	@strUrl				VARCHAR(50)
,	@strPhone			VARCHAR(30)
,	@strHPhone			VARCHAR(30)
,	@strAddrFlag			CHAR(1)
,	@strPost1			VARCHAR(5)
,	@strPost2			VARCHAR(5)
,	@strCity				VARCHAR(100)
,	@strAddress1			VARCHAR(100)
,	@strAddress2			VARCHAR(100)
,	@strRegDate			VARCHAR(10)
,	@strIPAddr			VARCHAR(20)
,	@strInsChannel			VARCHAR(10)
,	@strInsChannel2		VARCHAR(50)
,	@strMailChk			CHAR(1)
,	@strOnesName			VARCHAR(30)
,	@strCapital			VARCHAR(30)
,	@strSellingPrice			VARCHAR(30)
,	@strStaff			VARCHAR(30)
,	@strPresident			VARCHAR(30)
,	@strBizType			VARCHAR(30)
,	@strCategoryBiz			VARCHAR(50)
,	@strWelfarePgm		VARCHAR(200)
,	@strContents			VARCHAR(5000)
,	@strMailPeriod			VARCHAR(10)
,	@strInsLocalSite		VARCHAR(10)
)
AS
IF @ReInsert <> '1' 
	BEGIN	
			INSERT	INTO	UserCommon
			(
			UserID
		,	PassWord	
		,	UserGbn		
		,	UserName
		,	JuminNo
		, 	RealNameChk
		,	Email
		,	Url
		,	Phone
		,	HPhone
		,	AddrFlag
		,	Post1
		,	Post2
		,	City
		,	Address1
		,	Address2
		,	 RegDate	
		,	 IPAddr	
		, 	InsChannel
		, 	InsChannel2
		, 	InsLocalSite
		, 	VisitDay
		, 	VisitCnt
			)
			VALUES
			(
			@strUserID	
		,	@strPassword
		,	@strUserGbn
		,	@strUserName
		,	@strJuminNo
		,	@strRealNameChk
		,	@strEmail
		,	@strUrl
		,	@strPhone
		,	@strHPhone
		,	@strAddrFlag
		,	@strPost1
		,	@strPost2
		,	@strCity
		,	@strAddress1
		,	@strAddress2
		,	CONVERT(varchar(10), GetDate(), 120)
		,	@strIPAddr
		, 	@strInsChannel
		, 	@strInsChannel2
		, 	@strInsLocalSite
		, 	CONVERT(varchar(10), GetDate(), 120)
		, 	1
			)
	
		IF @@ERROR = 0 
			BEGIN
			INSERT	INTO	UserJobCompany
				(
					UserID
				,	MailChk
				,	OnesName
				,	Capital
				,	SellingPrice
				,	Staff
				,	President
				,	BizType
				,	CategoryBiz
				,	WelfarePgm
				, 	Contents
				,	DelReason
				)
				VALUES
				(
					@strUserID	
				,	@strMailChk
				,	@strOnesName
				,	@strCapital
				,	@strSellingPrice
				,	@strStaff
				,	@strPresident
				,	@strBizType
				,	@strCategoryBiz
				,	@strWelfarePgm
				,	@strContents
				, 	0
				)
			END
		END
		ELSE	
		BEGIN
			UPDATE UserCommon SET
			UserID		= @strUserID
		,	PassWord	=@strPassWord
		,	UserGbn	=@strUserGbn		
		,	UserName	=@strUserName
		, 	RealNameChk	=@strRealNameChk
		,	Email		=@strEmail
		,	Url		=@strUrl
		,	Phone		=@strPhone
		,	HPhone		=@strHPhone
		,	AddrFlag		=@strAddrFlag
		,	Post1		=@strPost1
		,	Post2		=@strPost2
		,	City		=@strCity
		,	Address1	=@strAddress1
		,	Address2	=@strAddress2
		,	 IPAddr		=@strIPAddr
		, 	InsChannel	=@strInsChannel
	
			UPDATE	UserJobCompany SET
					UserID 		= @strUserID
				,	MailChk		= @strMailChk
				,	OnesName	= @strOnesName
				,	Capital 		= @strOnesName
				,	SellingPrice 	= @strSellingPrice
				,	Staff 		= @strStaff
				,	President 	= @strPresident
				,	BizType 		= @strBizType
				,	CategoryBiz 	= @strCategoryBiz
				,	WelfarePgm 	= @strWelfarePgm
				, 	Contents 	= @strContents
				,	DelReason 	= 0
		END
GO
/****** Object:  StoredProcedure [dbo].[procOptionInsert]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 결재 정보 입력
	제작자	: 이창국
	제작일	: 2002-04-12
	셜명	:
*************************************************************************************/

CREATE PROCEDURE [dbo].[procOptionInsert] 
(
	@strAdGbn		char(1)		--광고구분			
,	@strAdId		int	        	--광고접수번호	
,	@strChargeKind		char(1)     	--대금결재종류	(0:무료 1:온라인 2:신용카드 3:휴대폰 4:이머니 5:ARS)
,	@intOptCharge		int	     	--옵션요금
,	@intTotCharge		int	     	--게재요금(총광고료)
,	@strOnlineStatus	char(1)	     	--온라인 입금여부 (1:미입금 2:입금 3:입금취소)
,	@strBankCd		char(4)	    	--입금은행코드	
,	@strBankNm		varchar(30)	--입금은행			
,	@strRecNm		varchar(30)	--입금자이름		
,	@strRecPhone		varchar(50)	--입금자연락처	
,	@strCardStatus		char(1)	        	--카드&휴대폰 입금상태
)

AS
BEGIN

BEGIN TRANSACTION

	DECLARE @RecCnt int

	--결재도중 RecCharge에 값은 입력되고 미결재 되는경우 확인(INSERT, UPDATE)
	SELECT @RecCnt = COUNT(AdGbn) FROM RecCharge WHERE AdGbn = @strAdGbn AND AdId = @strAdId

	IF @RecCnt > 0 --UPDATE
		BEGIN
			IF @strChargeKind = '1'--	온라인
				BEGIN
		
					UPDATE	RecCharge 
					SET	ChargeKind = @strChargeKind, 
						OptCharge = @intOptCharge, 
						TotCharge = @intTotCharge,
						OnlineStatus = @strOnlineStatus,
						BankCd = @strBankCd, 
						BankNm = @strBankNm, 
						RecNm = @strRecNm, 
						RecPhone = @strRecPhone
					WHERE	AdGbn = @strAdGbn AND AdId = @strAdId
		
				END
			ELSE-- 카드, 휴대폰, ARS
				BEGIN
					UPDATE	RecCharge 
					SET	ChargeKind = @strChargeKind, 
						OptCharge = @intOptCharge, 
						TotCharge = @intTotCharge,
						CardStatus = @strCardStatus
					WHERE	AdGbn = @strAdGbn AND AdId = @strAdId
				END

		END
	ELSE --INSERT
		BEGIN
			IF @strChargeKind = '1'--	온라인
				BEGIN
		
					INSERT 	RecCharge 
						(AdGbn, AdId, ChargeKind, OptCharge, TotCharge, OnlineStatus, BankCd, BankNm, RecNm, RecPhone ) 
					VALUES	( @strAdGbn, @strAdId, @strChargeKind, @intOptCharge, @intTotCharge,@strOnlineStatus,@strBankCd, @strBankNm, @strRecNm, @strRecPhone)
		
				END
			ELSE-- 카드, 휴대폰, ARS
				BEGIN
		
					INSERT 	RecCharge 
						(AdGbn, AdId, ChargeKind, OptCharge, TotCharge, CardStatus) 
					VALUES	( @strAdGbn, @strAdId, @strChargeKind, @intOptCharge, @intTotCharge,@strCardStatus)
				END
	
		END


	IF @strAdGbn='1' --구인광고(결재종류업데이트)
		BEGIN
			UPDATE JobOffer SET ChargeKind=@strChargeKind WHERE AdId = @strAdId
		END
	ELSE--구직광고
		BEGIN
			UPDATE Resume SET ChargeKind=@strChargeKind WHERE AdId = @strAdId
		END

IF @@ERROR = 0 
	BEGIN
	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END

END
GO
/****** Object:  StoredProcedure [dbo].[procOptionUpdate_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	: 결재 정보 입력
	제작자	: 이창국
	제작일	: 2002-04-22
	셜명	:
*************************************************************************************/

CREATE PROCEDURE [dbo].[procOptionUpdate_DelAN] 
(
	@AdGbn		char(1)		--광고구분			
,	@AdId		int	        	--광고접수번호	
)

AS
BEGIN

BEGIN TRANSACTION

	IF @AdGbn='1' --알바구직광고
		BEGIN
			UPDATE RecCharge SET CardStatus ='1', CardIStatusDate=GETDATE() WHERE AdGbn='1' AND AdId = @AdId
			UPDATE JobOffer SET PrnAmtOk='1' WHERE AdId = @AdId
		END
	ELSE IF @AdGbn='2' --알바구직광고
		BEGIN
			UPDATE RecCharge SET CardStatus ='1', CardIStatusDate=GETDATE() WHERE AdGbn='2' AND AdId = @AdId
			UPDATE Resume SET PrnAmtOk='1' WHERE AdId = @AdId
		END


IF @@ERROR = 0 
	BEGIN
	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END

END
GO
/****** Object:  StoredProcedure [dbo].[procOrderMailDetail]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	:맞춤메일 확인
	제작자	: 김종진
	제작일	: 2002-03-21
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procOrderMailDetail]
	 @strUserID		varchar(30)       

AS
BEGIN
	
	SELECT 	T1.OrderMailGbn	
	,		T1.JobCode				
	,		T1.WorkPlace1		
	,		T1.WorkPlace2		
	,		T1.LocalBranch	
	,		T1.WorkType			
	,		T1.WorkTime			
	,		T1.PayType				
	,		T1.Pay						
	,		T1.Sex						
	,		T1.SendCycle			
	,		T2.MailChk

	FROM 		OrderMail T1,  FindDb2.Common.dbo.UserAlba T2

	WHERE 	(T1.SendCycle Is Not Null  AND RTrim(T1.SendCycle)<>'') --맞춤메일은 SendCycle의 데이터가 존재있는것만 출력
			AND T1.UserID *= T2.UserID AND T1.UserID=@strUserID

END
GO
/****** Object:  StoredProcedure [dbo].[procOrderMailIns_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	:맞춤메일 입력
	제작자	: 김종진
	제작일	: 2002-03-21
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procOrderMailIns_DelAN]

               
	 @strUserID		varchar(30)        
	,@strOrderMailGbn	char(1)      
	,@strJobCode2		varchar(100)       
	,@strWorkPlace1	varchar(100)    
	,@strWorkPlace2	varchar(100)    
	,@strLocalBranch	varchar(200) 
	,@strWorkType		varchar(100)     
	,@strWorkTime		varchar(100)     
	,@strPayType		varchar(10)        
	,@strPay		varchar(10)            
	,@strSex		varchar(10)            
	,@strSendCycle		varchar(10)      
	,@strRegDate		datetime      
	,@strMailChk		char(1)
	,@Flag			char(1)
AS
BEGIN
BEGIN TRANSACTION
INSERT	INTO OrderMail
(
			
	UserID				
,	OrderMailGbn	
,	JobCode			
,	WorkPlace1		
,	WorkPlace2		
,	LocalBranch	
,	WorkType			
,	WorkTime			
,	PayType			
,	Pay					
,	Sex					
,	SendCycle		
,	RegDate			
)
VALUES
(

	 @strUserID				
	,@strOrderMailGbn	
	,@strJobCode2			
	,@strWorkPlace1		
	,@strWorkPlace2		
	,@strLocalBranch
	,@strWorkType			
	,@strWorkTime			
	,@strPayType			
	,@strPay					
	,@strSex					
	,@strSendCycle		
	,@strRegDate			
)


IF @@ERROR = 0 
	BEGIN
		IF @Flag = '2'
			BEGIN
			UPDATE FindDb2.Common.dbo.UserAlba  SET  MailChk=@strMailChk WHERE UserID=@strUserID
			END
		IF @Flag = '1'
			BEGIN
			INSERT INTO  FindDb2.Common.dbo.UserAlba(MailChk,UserID )  VALUES( @strMailChk,@strUserID)
			END

		COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procOrderMailModify_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
	설명	:맞춤메일 수정
	제작자	: 김종진
	제작일	: 2002-03-21
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procOrderMailModify_DelAN]

               
	 @strUserID		varchar(30)        
	,@strOrderMailGbn	char(1)      
	,@strJobCode2		varchar(100)       
	,@strWorkPlace1	varchar(100)    
	,@strWorkPlace2	varchar(100)    
	,@strLocalBranch	varchar(200) 
	,@strWorkType		varchar(100)     
	,@strWorkTime		varchar(100)     
	,@strPayType		varchar(10)        
	,@strPay		varchar(10)            
	,@strSex		varchar(10)            
	,@strSendCycle		varchar(10)      
	,@strRegDate		datetime      
	,@strMailChk		char(1)
AS
BEGIN
BEGIN TRANSACTION
UPDATE  OrderMail
SET

			
	 OrderMailGbn=@strOrderMailGbn
	,JobCode=@strJobCode2
	,WorkPlace1=@strWorkPlace1
	,WorkPlace2=@strWorkPlace2
	,LocalBranch=@strLocalBranch
	,WorkType=@strWorkType
	,WorkTime=@strWorkTime
	,PayType=@strPayType
	,Pay=@strPay
	,Sex=@strSex
	,SendCycle=@strSendCycle
	,RegDate=@strRegDate

WHERE 
	(SendCycle Is Not Null AND RTrim(SendCycle)<>'')  --맞춤메일은 SendCycle의 데이터가 존재있는것만 출력
	AND UserID= @strUserID				

IF @@ERROR = 0 
	BEGIN
			BEGIN
			UPDATE FindDb2.Common.dbo.UserAlba  SET  MailChk=@strMailChk WHERE UserID=@strUserID
			END

		COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procPaperAutoRegUserMod]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
설명	: 신문자동등록 매물등록전 개인회원 정보 수정
수정자	: 
수정일	: 2006-12-01
*************************************************************************************/
CREATE            PROC [dbo].[procPaperAutoRegUserMod]
	@UserId	  		varchar(50),				
	@strEmail	  	varchar(50),
	@strPhone	  	varchar(30),
	@strHPhone	  	varchar(30),
	@strPost1	  	char(3),
	@strPost2	  	char(3),
	@strCity			varchar(100),
	@strAddress1	  	varchar(100),
	@strAddress2	  	varchar(100),
	@strIPAddr          	            	varchar(20)
AS						      
						      
	BEGIN							

	--회원정보 수정
	
		UPDATE UserCommon SET
			Email = @strEmail,
			Phone = @strPhone,
			HPhone = @strHPhone,
			Post1 = @strPost1,
			Post2 = @strPost2,
			City = @strCity,
			Address1 = @strAddress1,
			Address2 = @strAddress2,
			IPAddr = @strIPAddr,
			ModDate = GetDate()
		 WHERE UserID = @UserId


	END
GO
/****** Object:  StoredProcedure [dbo].[procRestUserEnd]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	PROCEDURE [dbo].[procRestUserEnd] 
AS

/*************************************************************************************
  휴면계정처리 Temp Table
*************************************************************************************/

TRUNCATE TABLE RestUserEnd_Daily

INSERT INTO RestUserEnd_Daily (UserID, PassWord, UserGbn, UserName, JuminNo, RealNameChk, Email, Url, Phone, HPhone, AddrFlag, Post1, Post2, City, Address1, Address2, RegDate, ModDate, DelDate, VisitDay, VisitCnt, IPAddr, AllDelFlag, DelFlag, InsChannel, DelChannel, BadFlag, BadSite, BadReason, BadEtc, BadDate, InsLocalSite, DelLocalSite, PartnerCode, PartnerGbn, AddressBunji, LoginTime, LoginSite, emailFlag, smsFlag, CouponFlag, CouponLocal)
SELECT UserID, PassWord, UserGbn, UserName, JuminNo, RealNameChk, Email, Url, Phone, HPhone, AddrFlag, Post1, Post2, City, Address1, Address2, RegDate, ModDate, DelDate, VisitDay, VisitCnt, IPAddr, AllDelFlag, DelFlag, InsChannel, DelChannel, BadFlag, BadSite, BadReason, BadEtc, BadDate, InsLocalSite, DelLocalSite, PartnerCode, PartnerGbn, AddressBunji, LoginTime, LoginSite, emailFlag, smsFlag, CouponFlag, CouponLocal
  FROM UserCommon
 WHERE PartnerGbn = 0 
   AND DelFlag = '0' 
   AND CONVERT(varchar(10),DATEADD(dd,0,VisitDay),120) >= '2006-09-01'
   AND CONVERT(varchar(10),DATEADD(yy,2,DATEADD(dd,0,VisitDay)),120) <= CONVERT(varchar(10),getdate(),120)

UPDATE A SET 
       DelFlag='2',
       DelDate=getdate()
  FROM UserCommon A, RestUserEnd_Daily B
 WHERE A.UserID = B.UserID
GO
/****** Object:  StoredProcedure [dbo].[procRestUserPre]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	PROCEDURE [dbo].[procRestUserPre] 
AS

/*************************************************************************************
  휴면계정처리 예정 Temp Table
*************************************************************************************/

TRUNCATE TABLE RestUserPre_Daily

INSERT INTO RestUserPre_Daily (UserID, UserName, Email, RegDate, VisitDay)
SELECT UserID, UserName, Email,
	CONVERT(varchar(10), RegDate, 120) AS RegDate, 
	CONVERT(varchar(10), DATEADD(dd,0,VisitDay), 120) AS VisitDay
  FROM UserCommon
 WHERE PartnerGbn = 0 
   AND DelFlag = '0' 
   AND CONVERT(varchar(10),DATEADD(dd,0,VisitDay),120) >= '2006-09-01'
   AND CONVERT(varchar(10),DATEADD(dd,-10,DATEADD(yy,2,DATEADD(dd,0,VisitDay))),120) <= CONVERT(varchar(10),getdate(),120)
 ORDER BY UserID
GO
/****** Object:  StoredProcedure [dbo].[procResumeInsForm]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 이력서 등록
	제작자	: 김종진
	제작일	: 2002-03-22
	셜명	:
	   AdId 	: 	결재위한 이력서 순번		
			
*************************************************************************************/
CREATE PROC [dbo].[procResumeInsForm]
	 @strUserID			  varchar(30)	 												
	,@strUserName		  	  varchar(30)	 												
	,@strJuminNo			  varchar(20)	 												
	,@strPhone			  varchar(50)	 													
	,@strHPhone			  varchar(50)	 													
	,@strEmail			  varchar(50)	 													
	,@strZipCode			  varchar(6)	 													
	,@strAddress1			  varchar(100) 													
	,@strAddress2			  varchar(100) 													
	,@strTitle			  varchar(200) 													
	,@strJobCode1			  varchar(50)	 
	,@strJobCode2		 	  varchar(50)	 
	,@strWorkPlace1	    	  varchar(20)	 
	,@strWorkPlace2	   	  varchar(20)	 
	,@strLocalBranch  	 	  varchar(100) 
	,@strWorkType		  	  varchar(100) 
	,@strWorkTime		  	  varchar(100) 
	,@strPayType			  varchar(10)	 
	,@strPay			  varchar(20)	 
	,@strBeAtWork		    	 char(1)	     
	,@strAtWorkDate	    	 varchar(10)	 
	,@strOpenFlag		    	 char(1)		   
	,@strSchoolGbn		  	 varchar(50)	 
	,@strSchoolRecord   		 varchar(200) 
	,@strCareer			 varchar(50)	 
	,@strCareerRecord   		 varchar(200) 
	,@strEtcData			 text	       
	,@strSelfIntro		  	 text	
	,@strOptGbn			 char(1)
	,@strOptKind	         		char(10)	
	,@strOptStDate		  	datetime       
	,@strOptEnDate		 	datetime	   
	,@strOptAmt			int 	
	,@strChargeKind		char(1) 
	,@strPrnAmtOk			char(1)
	,@strDelFlag   			char(1)
	,@strRegDate			datetime   
	,@strRecProxyGbn		char(1)
	,@strRecProxy			varchar(30)	
	,@strMergeText			varchar(6000)
	,@strViewCnt			 int       
	,@strBasicGbn			char(1)




      

AS
BEGIN							

BEGIN TRANSACTION


IF @strOptStDate='' 
BEGIN
	SET @strOptStDate = NULL
END

IF @strOptEnDate='' 
BEGIN
	SET @strOptEnDate = NULL
END

	INSERT	INTO	Resume
(
	 UserID			  
	,UserName		  
	,JuminNo			
	,Phone				
	,HPhone				
	,Email				
	,ZipCode			
	,Address1			
	,Address2			
	,Title				
	,JobCode1		  
	,JobCode2		  
	,WorkPlace1	  
	,WorkPlace2	  
	,LocalBranch 
	,WorkType		  
	,WorkTime		  
	,PayType			
	,Pay					
	,BeAtWork		  
	,AtWorkDate	  
	,OpenFlag		  
	,SchoolGbn		
	,SchoolRecord 
	,Career			  
	,CareerRecord 
	,EtcData			
	,SelfIntro	
	,OptGbn
	,OptKind			  
	,OptStDate		
	,OptEnDate		
	,OptAmt	
	,ChargeKind
	,PrnAmtOk
	,DelFlag		  
	,RegDate	
	,RecProxyGbn
	,RecProxy		
	,MergeText	
	,ViewCnt	
	,BasicGbn
)

VALUES
(
	 @strUserID			  
	,@strUserName		  
	,@strJuminNo			
	,@strPhone				
	,@strHPhone				
	,@strEmail				
	,@strZipCode			
	,@strAddress1			
	,@strAddress2			
	,@strTitle				
	,@strJobCode1		  
	,@strJobCode2		  
	,@strWorkPlace1	  
	,@strWorkPlace2	  
	,@strLocalBranch 
	,@strWorkType		  
	,@strWorkTime		  
	,@strPayType			
	,@strPay					
	,@strBeAtWork		  
	,@strAtWorkDate	  
	,@strOpenFlag		  
	,@strSchoolGbn		
	,@strSchoolRecord 
	,@strCareer			  
	,@strCareerRecord 
	,@strEtcData			
	,@strSelfIntro	
	,@strOptGbn
	,@strOptKind			  
	,@strOptStDate		
	,@strOptEnDate		
	,@strOptAmt	
	,@strChargeKind
	,@strPrnAmtOk
	,@strDelFlag		
	,@strRegDate		
	,@strRecProxyGbn
	,@strRecProxy		
	,@strMergeText	
	,@strViewCnt	
	,@strBasicGbn
)

IF @@ERROR = 0 
	BEGIN			DECLARE	@i			int	--결재위한 이력서 순번		
					SET @i = @@IDENTITY
					SELECT @i AS AdId

	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END

END
GO
/****** Object:  StoredProcedure [dbo].[procResumeList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 이력서 리스트
	제작자	: 김종진
	제작일	: 2002-03-29
	셜명	:
	@SQLOpt 1 : -이력서  리스트
		 	2 :  유료옵션 리스트	

*************************************************************************************/

CREATE PROCEDURE [dbo].[procResumeList_DelAN] 
(
	@SQLOpt	CHAR(1)	
,	@strUserID	 varchar(30)	
	
		

)
AS
BEGIN

DECLARE @strQuery1 varchar(2000)


BEGIN

IF @SQLOpt = '1' --이력서  리스트

	SET @strQuery1=

		'SELECT AdId, Title, OptGbn, ViewCnt, OpenFlag, DelFlag,BasicGbn,ConVert(varchar(10),RegDate,111) as RegDate,' +
		'ConVert(varchar(10),ModDate,111) as ModDate FROM Resume Where DelFlag= 0 AND  UserID='+' '''+@strUserID+''' ' + 'ORDER BY ModDate '


IF @SQLOpt = '2' --유료옵션 리스트

	SET @strQuery1=

		'SELECT AdId, Title, OptGbn, ViewCnt, OpenFlag, DelFlag,BasicGbn,ConVert(varchar(10),RegDate,111) as RegDate,' +
		'ConVert(varchar(10),ModDate,111) as ModDate FROM Resume Where DelFlag= 0 AND  UserID='+' '''+@strUserID+''' '+
		'AND OptAmt = 0 ORDER BY ModDate '


END

END
EXEC(@strQuery1)
GO
/****** Object:  StoredProcedure [dbo].[procResumeModForm_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 이력서 수정/확인 
	제작자	: 김종진
	제작일	: 2002-03-22
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procResumeModForm_DelAN]
	 @intAdId	int
AS
BEGIN							

SELECT
	UserId
	,UserName		  
	,JuminNo			
	,Phone				
	,HPhone				
	,Email				
	,ZipCode			
	,Address1			
	,Address2			
	,Title				
	,JobCode1		  
	,JobCode2		  
	,WorkPlace1	  
	,WorkPlace2	  
	,LocalBranch 
	,WorkType		  
	,WorkTime		  
	,PayType			
	,Pay					
	,BeAtWork		  
	,AtWorkDate	  
	,OpenFlag		  
	,SchoolGbn		
	,Career			  
	,OptGbn
	,OptKind		  
	,OptStDate		
	,OptEnDate		
	,OptAmt			  
	,RegDate		
	,SchoolRecord 
	,CareerRecord 
	,SelfIntro		
	,EtcData			
FROM 
Resume WHERE AdId=@intAdId


END
GO
/****** Object:  StoredProcedure [dbo].[procResumeModify_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 이력서 수정/확인 
	제작자	: 김종진
	제작일	: 2002-03-23
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procResumeModify_DelAN]
	
	 @intAdId			  int	
	,@strPhone			  varchar(50)	 													
	,@strHPhone			  varchar(50)	 													
	,@strEmail			  varchar(50)	 													
	,@strZipCode			  varchar(6)	 													
	,@strAddress1			  varchar(100) 													
	,@strAddress2			  varchar(100) 													
	,@strTitle			  varchar(200) 													
	,@strJobCode1			  varchar(50)	 
	,@strJobCode2		 	  varchar(50)	 
	,@strWorkPlace1	    	  varchar(20)	 
	,@strWorkPlace2	   	  varchar(20)	 
	,@strLocalBranch  	 	  varchar(100) 
	,@strWorkType		  	  varchar(100) 
	,@strWorkTime		  	  varchar(100) 
	,@strPayType			  varchar(10)	 
	,@strPay			  varchar(20)	 
	,@strBeAtWork		    	 char(1)	     
	,@strAtWorkDate	    	 varchar(10)	 
	,@strOpenFlag		    	 char(1)		   
	,@strSchoolGbn		  	 varchar(50)	 
	,@strSchoolRecord   		 varchar(200) 
	,@strCareer			 varchar(50)	 
	,@strCareerRecord   		 varchar(200) 
	,@strEtcData			 text	       
	,@strSelfIntro		  	 text	       
	,@strModDate			datetime     
	,@strMergeText    		varchar(6000)

AS
BEGIN							

BEGIN TRANSACTION

UPDATE Resume
SET

	 Phone		=	@strPhone			  
	,HPhone	=	@strHPhone			
	,Email		=	@strEmail			  
	,ZipCode	=	@strZipCode			
	,Address1	=	@strAddress1		
	,Address2	=	@strAddress2		
	,Title		=	@strTitle			  
	,JobCode1	=	@strJobCode1		
	,JobCode2	=	@strJobCode2		
	,WorkPlace1	=	@strWorkPlace1	
	,WorkPlace2	=	@strWorkPlace2	
	,LocalBranch 	=	@strLocalBranch
	,WorkType	=	@strWorkType		
	,WorkTime	=	@strWorkTime		
	,PayType	=	@strPayType			
	,Pay		=	@strPay				  
	,BeAtWork	=	@strBeAtWork		
	,AtWorkDate	=	@strAtWorkDate	
	,OpenFlag	=	@strOpenFlag		
	,SchoolGbn	=	@strSchoolGbn		
	,SchoolRecord 	=	@strSchoolRecord
	,Career		=	@strCareer			
	,CareerRecord 	=	@strCareerRecord
	,EtcData	=	@strEtcData			
	,SelfIntro	=	@strSelfIntro		
	,ModDate	=	@strModDate	
	,MergeText	=	@strMergeText	

 WHERE AdId=@intAdId

IF @@ERROR = 0 
	BEGIN

	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procResumeOptModify_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 이력서 수정/확인 
	제작자	: 김종진
	제작일	: 2002-03-23
	셜명	:
	유료옵션기간이 없을 경우 Null이 들어감
*************************************************************************************/
CREATE PROC [dbo].[procResumeOptModify_DelAN]
	
	 @intAdId			  int	
	,@strPhone			  varchar(50)	 													
	,@strHPhone			  varchar(50)	 													
	,@strEmail			  varchar(50)	 													
	,@strZipCode			  varchar(6)	 													
	,@strAddress1			  varchar(100) 													
	,@strAddress2			  varchar(100) 													
	,@strTitle			  varchar(200) 													
	,@strJobCode1			  varchar(50)	 
	,@strJobCode2		 	  varchar(50)	 
	,@strWorkPlace1	    	  varchar(20)	 
	,@strWorkPlace2	   	  varchar(20)	 
	,@strLocalBranch  	 	  varchar(100) 
	,@strWorkType		  	  varchar(100) 
	,@strWorkTime		  	  varchar(100) 
	,@strPayType			  varchar(10)	 
	,@strPay			  varchar(20)	 
	,@strBeAtWork		    	  char(1)	     
	,@strAtWorkDate	    	 varchar(10)	 
	,@strOpenFlag		    	 char(1)		   
	,@strSchoolGbn		  	 varchar(50)	 
	,@strSchoolRecord   		 varchar(200) 
	,@strCareer			 varchar(50)	 
	,@strCareerRecord   		 varchar(200) 
	,@strEtcData			 text	       
	,@strSelfIntro		  	 text	       
	,@strOptGbn			 char(1)	         
	,@strOptKind			 char(10)
	,@strOptStDate		  	datetime       
	,@strOptEnDate		 	 datetime	   
	,@strOptAmt			int 	   
	,@strModDate			datetime     
	,@strMergeText    		varchar(6000)

AS
BEGIN							

BEGIN TRANSACTION
IF @strOptStDate='' 
BEGIN
	SET @strOptStDate = NULL
END

IF @strOptEnDate='' 
BEGIN
	SET @strOptEnDate = NULL
END

UPDATE Resume
SET

	 Phone		=	@strPhone			  
	,HPhone	=	@strHPhone			
	,Email		=	@strEmail			  
	,ZipCode	=	@strZipCode			
	,Address1	=	@strAddress1		
	,Address2	=	@strAddress2		
	,Title		=	@strTitle			  
	,JobCode1	=	@strJobCode1		
	,JobCode2	=	@strJobCode2		
	,WorkPlace1	=	@strWorkPlace1	
	,WorkPlace2	=	@strWorkPlace2	
	,LocalBranch 	=	@strLocalBranch
	,WorkType	=	@strWorkType		
	,WorkTime	=	@strWorkTime		
	,PayType	=	@strPayType			
	,Pay		=	@strPay				  
	,BeAtWork	=	@strBeAtWork		
	,AtWorkDate	=	@strAtWorkDate	
	,OpenFlag	=	@strOpenFlag		
	,SchoolGbn	=	@strSchoolGbn		
	,SchoolRecord 	=	@strSchoolRecord
	,Career		=	@strCareer			
	,CareerRecord 	=	@strCareerRecord
	,EtcData	=	@strEtcData			
	,SelfIntro	=	@strSelfIntro		
	,OptGbn	=	@strOptGbn			
	,OptKind	=	@strOptKind	
	,OptStDate	=	@strOptStDate		
	,OptEnDate	=	@strOptEnDate		
	,OptAmt		=	@strOptAmt			
	,ModDate	=	@strModDate	
	,MergeText	=	@strMergeText	

 WHERE AdId=@intAdId

IF @@ERROR = 0 
	BEGIN

	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procResumeSendMail_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
	설명	: 이력서 메일보내기 
	제작자	: 김종진
	제작일	: 2002-03-22
	셜명	:
*************************************************************************************/
CREATE PROC [dbo].[procResumeSendMail_DelAN]
	 @intAdId	int
AS
BEGIN							

BEGIN TRANSACTION

SELECT
	UserID
	,UserName		  
	,JuminNo			
	,Phone				
	,HPhone				
	,Email				
	,ZipCode			
	,Address1			
	,Address2			
	,Title				
	,JobCode1		  
	,JobCode2		  
	,WorkPlace1	  
	,WorkPlace2	  
	,LocalBranch 
	,WorkType		  
	,WorkTime		  
	,PayType			
	,Pay					
	,BeAtWork		  
	,AtWorkDate	  
	,OpenFlag		  
	,SchoolGbn		
	,SchoolRecord 
	,Career			  
	,CareerRecord 
	,RegDate	
	,EtcData			
	,SelfIntro		
		
FROM 
Resume WHERE AdId=@intAdId

IF @@ERROR = 0 
	BEGIN

	    	COMMIT TRAN
	END
ELSE
	BEGIN
		ROLLBACK
	END
END
GO
/****** Object:  StoredProcedure [dbo].[procUserCommon_Cancel_FINDDB2]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procUserCommon_Cancel_FINDDB2]
AS

-- FINDDB2 에 있는 탈퇴회원 아이디 테이블을 가져온다.
-- FINDDB2 의 선행 프로시저 (procUserCommon_Cancel) 가 정상실행되지 않았을 경우 어제 데이터로 다시 업데이트를 하게 되므로 (동일한 아이디로 다른 사람이 가입한 경우 또 지워질 수도 있음)
-- 그런 경우를 방지하기 위해 오늘 날짜로 들어간 데이터만을 가져온다.
	SELECT UserID, Del_ID INTO #Temp_DelUserID FROM FINDDB2.Common.dbo.DelUserID_Daily WHERE RegDate > CONVERT(char(10),GETDATE(),120)


-- FINDDB2.Common
	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.UserAlba	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.UserAllPerson  A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.UserAuto	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.UserBankInfo  A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.UserHouse  	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.UserJobPerson  A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	
	
	/*
	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.UserTown	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	
	*/

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.UserUsed	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.UserJobCompany	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.UserJobPayHistory	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	Common.dbo.CompanyHistory	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

-- FINDDB2.FindCommon

	UPDATE A SET	A.UserID = B.Del_ID
	FROM 	FindCommon.dbo.Tbl_tax A,   #Temp_DelUserID	B
	WHERE	A.UserID =  B.UserID

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	FindCommon.dbo.PointMag	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	FindCommon.dbo.UserBankInfo   A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

-- FINDDB2.FindContents
	/*
	UPDATE	A 	SET	A.UserID	= B.Del_ID 
	FROM	FindContents.dbo.Humor	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	FindContents.dbo.NetizenBoard	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	
	*/

	UPDATE	A 	SET	A.UserID	= B.Del_ID, A.DelFlag = '1'
	FROM	FindContents.dbo.ReaderComment2  A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID, A.DelFlag = '1'
	FROM	FindContents.dbo.ReaderEvent2	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

-- FINDDB2.PaperCommon
	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	PaperCommon.dbo.OrderMail	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	PaperCommon.dbo.RecPaper	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID
	FROM	PaperCommon.dbo.UserSaveAd	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID	

	UPDATE	A 	SET	A.UserID	= B.Del_ID, A.ReadingFlag = '0'
	FROM	PaperCommon.PaperCommon.FreePaper	A,   #Temp_DelUserID	B
	WHERE	A.UserID	 =  B.UserID
GO
/****** Object:  StoredProcedure [dbo].[ProcUserCommonLog]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProcUserCommonLog]
AS
--일별 회원 등록 현황 통계 작업
--스케쥴 작업은 전체 탈퇴작업이 돌아가기 전에 실행되어야 함
--기본적으로 바로 전달 데이터를 쌓음
CREATE TABLE #LogCode
(
	LogCode tinyInt NOT NULL,
	LogNm varchar(20) NOT NULL

)

INSERT INTO #LogCode VALUES(0, '전국')
--INSERT INTO #LogCode VALUES(1, '서울')      서울은 전국으로 포함됨
INSERT INTO #LogCode VALUES(2, '수원/경기')
INSERT INTO #LogCode VALUES(3, '대전/충청')
INSERT INTO #LogCode VALUES(4, '광주/전라')
INSERT INTO #LogCode VALUES(5, '대구/경북')
INSERT INTO #LogCode VALUES(6, '부산/경남')
INSERT INTO #LogCode VALUES(20, '제휴사(야후/파란)')
INSERT INTO #LogCode VALUES(25, '전체회원')
INSERT INTO #LogCode VALUES(30, '불량회원')
INSERT INTO #LogCode VALUES(40, '탈퇴회원')


DECLARE @ResultDate    	varchar(10)
SELECT   @ResultDate 	= convert(varchar(10), dateadd(dd, -1, GetDate()), 120)


--기존 자료가 있다면 먼저 삭제

DELETE FROM UserCommonLog
WHERE REsultDate = @ResultDate

--개인(지역별 건수)
INSERT INTO UserCommonLog
SELECT @ResultDate, '1', 
		Case IsNull(LogCode,0)
				WHEN 2 THEN 2
				WHEN 3 THEN 3
				WHEN 4 THEN 4
				WHEN 5 THEN 5
				WHEN 6 THEN 6
				WHEN 20 THEN 20
				WHEN 25 THEN 25
				WHEN 30 THEN 30
				WHEN 40 THEN 40
		ELSE 0 END As LogCode,
		LogNm,Count(UserID)
FROM UserCommon As A  RIGHT OUTER JOIN #LogCode As B
ON A.InsLocalSite = B.LogCode AND UserGbn <> 2 AND RegDate = @ResultDate AND PartnerGbn = 0 AND DelFlag = 0
Group By LogCode,LogNm
Order By LogCode,LogNm

--기업(지역별 건수)
INSERT INTO UserCommonLog
SELECT @ResultDate, '2', 
		Case IsNull(LogCode,0)
				WHEN 2 THEN 2
				WHEN 3 THEN 3
				WHEN 4 THEN 4
				WHEN 5 THEN 5
				WHEN 6 THEN 6
				WHEN 20 THEN 20
				WHEN 25 THEN 25
				WHEN 30 THEN 30
				WHEN 40 THEN 40
		ELSE 0 END As LogCode,
		LogNm,Count(UserID)
FROM UserCommon As A  RIGHT OUTER JOIN #LogCode As B
ON A.InsLocalSite = B.LogCode AND InsLocalSite < 7 AND UserGbn = 2 AND RegDate = @ResultDate AND PartnerGbn = 0 AND DelFlag = 0
Group By LogCode,LogNm
Order By LogCode,LogNm	



--개인 제휴사 회원 구하기
UPDATE UserCommonLog
SET LogCnt = (Select Count(UserID) From UserCommon Where RegDate = @ResultDate AND PartnerGbn > 0 AND UserGbn = 1 AND DelFlag = 0)
WHERE ResultDate = @ResultDate AND LogGbn = '1' AND LogCode = 20


--기업 제휴사 회원 구하기
UPDATE UserCommonLog
SET LogCnt = (Select Count(UserID) From UserCommon Where RegDate = @ResultDate AND PartnerGbn > 0 AND UserGbn = 2 AND DelFlag = 0)
WHERE ResultDate = @ResultDate AND LogGbn = '2' AND LogCode = 20

--개인 회원 구하기
UPDATE UserCommonLog
SET LogCnt = (Select Count(UserID) From UserCommon Where RegDate <= @ResultDate AND UserGbn = 1 AND DelFlag = 0)
WHERE ResultDate = @ResultDate AND LogGbn = '1' AND LogCode = 25

--기업 회원 구하기
UPDATE UserCommonLog
SET LogCnt = (Select Count(UserID) From UserCommon Where RegDate <= @ResultDate AND UserGbn = 2 AND DelFlag = 0)
WHERE ResultDate = @ResultDate AND LogGbn = '2' AND LogCode = 25

--개인 불량회원 등록 구하기
UPDATE UserCommonLog
SET LogCnt = (Select Count(UserID) From UserCommon Where BadDate = @ResultDate AND UserGbn <> 2 AND PartnerGbn = 0)
WHERE ResultDate = @ResultDate AND LogGbn = '1' AND LogCode = 30


--기업 불량회원 등록 구하기
UPDATE UserCommonLog
SET LogCnt = (Select Count(UserID) From UserCommon Where BadDate = @ResultDate AND UserGbn = 2 AND PartnerGbn = 0)
WHERE ResultDate = @ResultDate AND LogGbn = '2' AND LogCode = 30



--개인 탈퇴회원
UPDATE UserCommonLog
SET LogCnt = (Select Count(UserID) From UserCommon Where DelDate = @ResultDate AND UserGbn <> 2)
WHERE ResultDate = @ResultDate AND LogGbn = '1' AND LogCode = 40


--개인 탈퇴회원
UPDATE UserCommonLog
SET LogCnt = (Select Count(UserID) From UserCommon Where DelDate = @ResultDate AND UserGbn = 2)
WHERE ResultDate = @ResultDate AND LogGbn = '2' AND LogCode = 40


--Select * From UserCommonLog
GO
/****** Object:  StoredProcedure [dbo].[procUserCommonLog_Week]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[procUserCommonLog_Week]
(
@ResultDate varchar(10)
)
AS

--주간 회원통계
--exec procUserCommonLog_Week '2004-10-28'
DECLARE @SQL varchar(1200)
DECLARE @ResultDate7 varchar(12)
DECLARE @ResultDate6 varchar(12)
DECLARE @ResultDate5 varchar(12)
DECLARE @ResultDate4 varchar(12)
DECLARE @ResultDate3 varchar(12)
DECLARE @ResultDate2 varchar(12)
DECLARE @ResultDate1 varchar(12)

SET @ResultDate7 =  Convert(varchar(10),DATEADD(dd,-7,  @ResultDate),120)
SET @ResultDate6 =  Convert(varchar(10),DATEADD(dd,-6,  @ResultDate),120)
SET @ResultDate5 =  Convert(varchar(10),DATEADD(dd,-5,  @ResultDate),120)
SET @ResultDate4 =  Convert(varchar(10),DATEADD(dd,-4,  @ResultDate),120)
SET @ResultDate3 =  Convert(varchar(10),DATEADD(dd,-3,  @ResultDate),120)
SET @ResultDate2 =  Convert(varchar(10),DATEADD(dd,-2,  @ResultDate),120)
SET @ResultDate1 =  Convert(varchar(10),DATEADD(dd,-1,  @ResultDate),120)


SET @SQL = ' SELECT A.* FROM ' +
			' (Select Top 50 CASE LogGbn WHEN 1 THEN ''개인'' ELSE ''기업'' END As LogGbn,LogCode,LogNm, ' +
			' SUM(CASE WHEN ResultDate = ''' + @ResultDate7 + ''' THEN  LogCnt ELSE 0 END) As [' + @ResultDate7 + '], ' +
			' SUM(CASE WHEN ResultDate = ''' + @ResultDate6 + ''' THEN  LogCnt ELSE 0 END) As [' + @ResultDate6 + '], ' +
			' SUM(CASE WHEN ResultDate = ''' + @ResultDate5 + ''' THEN  LogCnt ELSE 0 END) As [' + @ResultDate5 + '], ' +
			' SUM(CASE WHEN ResultDate = ''' + @ResultDate4 + ''' THEN  LogCnt ELSE 0 END) As [' + @ResultDate4 + '], ' +
			' SUM(CASE WHEN ResultDate = ''' + @ResultDate3 + ''' THEN  LogCnt ELSE 0 END) As [' + @ResultDate3 + '], ' +
			' SUM(CASE WHEN ResultDate = ''' + @ResultDate2 + ''' THEN  LogCnt ELSE 0 END) As [' + @ResultDate2 + '], ' +
			' SUM(CASE WHEN ResultDate = ''' + @ResultDate1 + ''' THEN  LogCnt ELSE 0 END) As [' + @ResultDate1 + ']' +
			' From Common.dbo.UserCommonLog  ' +
			' WHERE  ResultDate > DATEADD(dd,-8,''' + @ResultDate + ''' ) AND ResultDate < ''' + @ResultDate + '''' + 
			' Group By  LogGbn,LogCode,LogNm ' +
			' Order By  LogGbn,LogCode ) As A  ' 

print  (@SQL)
exec (@SQL)
GO
/****** Object:  StoredProcedure [dbo].[procYPMagUserList_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE                      PROC [dbo].[procYPMagUserList_DelAN]
	@StDate		varchar(10),
	@EnDate		varchar(10),
	@cboInsChannel varchar(10), --가입경로
	@cboDelFlag varchar(1), --상태(가입,탈퇴여부)
	@cboSearch	varchar(20),	-- 상호 / 전화번호
	@txtKeyWord	varchar(50),	-- 검색어
	@Page		int,		-- Jump 할 페이지
	@PageSize	int		-- 페이지당 게시물 수 	      
						      
AS						      
						      
BEGIN		

	DECLARE @Sql		varchar(3000); Set @Sql=''

	Set @Sql =  '  Select Top ' +  CONVERT(varchar(10), @Page*@PageSize) + '  UserID, '
	Set @Sql= @Sql + '		UserName, JuminNo, Address1, Address2, AddressBunji, '
	Set @Sql= @Sql + '		Phone, InsChannel, RegDate, DelFlag '
	Set @Sql= @Sql + '		From UserCommon '
	Set @Sql= @Sql + '		Where UserGbn = ''2'' '

	IF @StDate <> ''
		Begin
		Set @Sql= @Sql + '	AND (CONVERT(VARCHAR(10),RegDate,120)  >= '''+ @StDate+''') ' 
		Set @Sql= @Sql + '	AND (CONVERT(VARCHAR(10),RegDate,120)  <= '''+ @EnDate+''') ' 
		End

	IF @cboInsChannel <> ''
		Set @Sql= @Sql + ' AND InsChannel	=	''' + @cboInsChannel +''''
	
	IF @cboDelFlag <> ''
		Set @Sql= @Sql + ' AND DelFlag	=	''' + @cboDelFlag +''''

	IF @txtKeyWord <> ''
		Set @Sql= @Sql + ' AND ' + @cboSearch + '	Like	''%' + @txtKeyWord +'%'''

	Set @Sql= @Sql + '		Order By RegDate DESC, UserID '
	Set @Sql=@Sql
END

PRINT(@Sql)
EXEC(@Sql)
GO
/****** Object:  StoredProcedure [dbo].[procYPUserIns_DelAN]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--select InsLocalSite,* from usercommon where InsChannel='Yellow'

--DelLocalSite

/*************************************************************************************
	설명	: Yellow회원 입력 프로시저
	수정자	: 김선미
	수정일	: 2002-12-04
*************************************************************************************/
CREATE             PROC [dbo].[procYPUserIns_DelAN]
	@strUserId	  	varchar(30),				
	@strPassWord	 	varchar(30),
	@strUserGbn	  	char(1),	      	      
	@strUserName	  	varchar(30),	      	      
	@strJuminNo 	  	varchar(15),	      	      
	@steRealNameChk 	char(1),	    
	@strEmail	  	varchar(50),	      	    
	@strUrl		  	varchar(50),	      
	@strPhone	  	varchar(30),	      	      
	@strHPhone	  	varchar(30),	      	      
	@strPost1	  	varchar(5),	      	      
	@strPost2	  	varchar(5),	      	      
	@strCity 	   		varchar(100),	      	      
	@strAddress1	  	varchar(100),	      	      
	@strAddress2	  	varchar(100),	      	      
	@strRegDate	  	varchar(10),	      
	@strIPAddr	  	varchar(20), 	      
	@strInsChannel		varchar(10),	
	@InsLocalSite		int,		      
	@strMailChk	  	char(1),
	@strSMSChk	  	char(1),
	@ReInsert		CHAR(1),		--재가입 여부     
	@OldUserID		VARCHAR(30)		--이전 아이디
						      
AS						      
						      
BEGIN							

	IF @ReInsert <> '1'		--신규가입일 경우
	BEGIN
		INSERT	INTO	Common.dbo.UserCommon
		(
				UserId,	 	
				PassWord,
				UserGbn,
				UserName,
				JuminNo,
				RealNameChk,
				Email,
				Url,
				Phone,
				HPhone,
				Post1,
				Post2,
				City,
				Address1,
				Address2,
				RegDate,
				IPAddr,
				InsChannel,
				InsLocalSite,
				emailFlag,
				smsFlag
			
		)
		VALUES
		(
			@strUserId,
			@strPassWord,
			@strUserGbn,
			@strUserName,
			@strJuminNo,	
			@steRealNameChk,
			@strEmail,	
			@strUrl,	
			@strPhone,
			@strHPhone,	
			@strPost1,	
			@strPost2,
			@strCity,	
			@strAddress1,
			@strAddress2,
			@strRegDate,
			@strIPAddr,	
			@strInsChannel,
			@InsLocalSite,
			@strMailChk,
			@strSMSChk
			
		)

		INSERT	INTO	Common.dbo.UserTown   --메일체크까지 입력
		(
			UserID,
			MailChk
		)
		VALUES
		(
			@strUserID,
			@strMailChk
		)	
		       

	END			--기존 회원이면..
	ELSE
	BEGIN
		UPDATE Common.dbo.UserCommon SET
			UserID			= @strUserID
		,	PassWord		= @strPassWord
		,	UserGbn		= @strUserGbn		
		,	RealNameChk		= @steRealNameChk
		,	Email			= @strEmail
		,	Url			= @strUrl
		,	Phone			= @strPhone
		,	HPhone			= @strHPhone
		,	Post1			= @strPost1
		,	Post2			= @strPost2
		,	City			= @strCity
		,	Address1		= @strAddress1
		,	Address2		= @strAddress2
		, 	IPAddr			= @strIPAddr
		, 	InsChannel		= @strInsChannel
		,	InsLocalSite		= @InsLocalSite
		,	YellowDelFlag		= 0		
		,	UsedDelFlag		= 0
		,	JobDelFlag		= 0
		,	albaDelflag		= 0
		,	CardelFlag		= 0
		,	LandDelFlag		= 0
		, 	AllDelFlag		= 0
		,	DelChannel		= ''
		,	DelDate			= ''
		,	emailFlag		=@strMailChk
		,	smsFlag			=@strSMSChk
			WHERE JuminNo		= @strJuminNo
			UPDATE Common.dbo.UserTown SET
			UserID			=@strUserID
		,	MailChk			=@strMailChk
		,	DelReason		=0
			WHERE UserID = @OldUserID

	END

END
GO
/****** Object:  StoredProcedure [dbo].[PUT_MM_MEMBER_AUTH_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*************************************************************************************
 *  단위 업무 명 : 본인인증
 *  작   성   자 : 
 *  작   성   일 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  주 의  사 항 : 
 *  사 용  소 스 : 
 *************************************************************************************/

CREATE PROCEDURE [dbo].[PUT_MM_MEMBER_AUTH_PROC] 

	@MEMBER_ID	VARCHAR(30)	--개인회원아이디
       ,@AUTH_TYPE	CHAR(2)

AS

	INSERT INTO DBO.MM_AUTH_ID_TB (
			MEMBER_ID
		       ,AUTH_TYPE
		       ,REG_DT
	) 
	VALUES (
			@MEMBER_ID
		       ,@AUTH_TYPE
		       ,GETDATE()
	)
GO
/****** Object:  StoredProcedure [dbo].[USERID_CHANGE_PROC]    Script Date: 2021-11-04 오전 10:25:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원통합 > 아이디 변경
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016/08/03
 *  설       명 : 
 *  주 의  사 항 :
 *  사 용  소 스 : 
 *  사 용  예 제 : 
                 EXEC USERID_CHANGE_PROC 'anycall512', 'anycall512','111.111.111.111'
                 EXEC USERID_CHANGE_PROC 'oby5002', 'oby5002','111.111.111.111'
                 
 *************************************************************************************/
create PROCEDURE [dbo].[USERID_CHANGE_PROC]
  @CUID            VARCHAR(50)        =  ''      -- 기존아이디
  ,@USERID            VARCHAR(50)        =  ''      -- 기존아이디
  ,@RE_USERID             VARCHAR(50)        =  ''      --  변경 아이디
  ,@CLIENT_IP		varchar(20) = ''
	
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	
	UPDATE A SET UserId=@RE_USERID FROM BadUserCheck A  where CUID=@CUID
	UPDATE A SET userid=@RE_USERID FROM m25event A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM MM_SENDMAIL_REST_TB A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM BadUser A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM MM_REST_CONFIRM_TB A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM MM_LONGTERM_UNUSED_TB A  where CUID=@CUID
	UPDATE A SET UserId=@RE_USERID FROM CompanyHistory A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM DelUserID_Daily A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM UserHouse A  where CUID=@CUID
	UPDATE A SET USERID=@RE_USERID FROM TEMP_USERCOMMON_M25 A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM TEMP_USERCOMMON_PARTNER A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM UserAlba A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM UserJobPerson A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM DelUserPre_Daily A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM RestUserPre_Daily A  where CUID=@CUID
	UPDATE A SET userID=@RE_USERID FROM UserCommPusan1 A  where CUID=@CUID
	UPDATE A SET userID=@RE_USERID FROM UserCommPusan2 A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM MultiLogin A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM DelTargetUserID A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM UserTown A  where CUID=@CUID
	UPDATE A SET UserID=@RE_USERID FROM UserJobPayHistory A  where CUID=@CUID

/*
	INSERT LOGDB.DBO.USERID_CHANGE_HISTORY_TB (B_USERID,N_USERID,DB_NM,USERIP) 
	SELECT @USERID,@RE_USERID,DB_NAME(),@CLIENT_IP
*/	
END
GO
