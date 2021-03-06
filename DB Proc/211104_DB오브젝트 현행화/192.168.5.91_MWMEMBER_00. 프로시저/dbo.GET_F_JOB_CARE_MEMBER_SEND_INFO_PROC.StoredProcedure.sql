USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_F_JOB_CARE_MEMBER_SEND_INFO_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
