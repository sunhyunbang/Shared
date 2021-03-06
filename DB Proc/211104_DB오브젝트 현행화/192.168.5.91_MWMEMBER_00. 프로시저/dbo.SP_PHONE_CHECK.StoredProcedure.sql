USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_PHONE_CHECK]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
