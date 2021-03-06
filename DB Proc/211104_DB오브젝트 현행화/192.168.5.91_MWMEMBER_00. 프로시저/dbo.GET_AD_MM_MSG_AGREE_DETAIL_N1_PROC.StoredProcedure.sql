USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_AD_MM_MSG_AGREE_DETAIL_N1_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
