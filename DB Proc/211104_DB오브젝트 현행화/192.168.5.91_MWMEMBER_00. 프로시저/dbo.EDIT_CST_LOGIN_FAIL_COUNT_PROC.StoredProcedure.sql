USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_CST_LOGIN_FAIL_COUNT_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
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
