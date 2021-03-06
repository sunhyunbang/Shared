USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_CST_SERVICE_USE_AGREE]    Script Date: 2021-11-03 오후 4:50:51 ******/
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
