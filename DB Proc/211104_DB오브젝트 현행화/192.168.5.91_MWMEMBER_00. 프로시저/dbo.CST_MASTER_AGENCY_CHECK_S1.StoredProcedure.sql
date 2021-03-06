USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[CST_MASTER_AGENCY_CHECK_S1]    Script Date: 2021-11-03 오후 4:50:50 ******/
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
