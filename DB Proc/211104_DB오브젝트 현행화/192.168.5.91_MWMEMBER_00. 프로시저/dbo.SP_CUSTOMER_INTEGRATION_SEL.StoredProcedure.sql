USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOMER_INTEGRATION_SEL]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
