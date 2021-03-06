USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MSG_SECTION]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
