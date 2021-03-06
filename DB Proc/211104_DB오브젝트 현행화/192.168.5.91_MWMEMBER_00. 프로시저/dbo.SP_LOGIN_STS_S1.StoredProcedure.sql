USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_LOGIN_STS_S1]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************************
* 단위 업무명: 회원 비밀번호 변경 확인
* 작  성  자: 안대희
* 작  성  일: 2021-09-29
* 설      명: 회원 비밀번호 변경상태 확인
* 사용  예제: EXEC MWMEMBER.DBO.SP_LOGIN_STS_S1 13621996, '127.0.0.1', 0
*************************************************************************************************/
/*  
    ** 수정 내역 **
    1. 수 정 자: 
    1-1. 수 정 일: 
    1-2. 수정 내역: 
*/  
CREATE PROCEDURE [dbo].[SP_LOGIN_STS_S1]
    @cuid           INT,            /* 회원번호 */
    @reg_ip         VARCHAR(30),    /* 사용자 IP ADDR */
    @return_value   INT OUTPUT
AS	
BEGIN
	IF EXISTS (
        SELECT CUID
        FROM CST_LOGIN_LOG
        WHERE CUID = @cuid
        AND success_yn = 'Y'
        AND IP = @reg_ip
    )
    Begin
        SELECT TOP 1 @return_value = ISNULL(login_status, 1)
        FROM CST_LOGIN_LOG
        WHERE CUID = @cuid
        AND success_yn = 'Y'
        AND IP = @reg_ip
        ORDER BY login_dt DESC
    End
    ELSE
    Begin
        SET @return_value = 0;
    End

    -- Return(@return_value)
END;

GO
