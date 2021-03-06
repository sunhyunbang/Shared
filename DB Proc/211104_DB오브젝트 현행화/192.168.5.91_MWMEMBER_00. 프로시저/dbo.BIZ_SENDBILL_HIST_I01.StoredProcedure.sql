USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[BIZ_SENDBILL_HIST_I01]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************************
* 단위 업무명: 센드빌 사업자번호 조회 저장
* 작  성  자: 안대희
* 작  성  일: 2021-09-07
* 설      명: 센드빌 사업자번호 조회 저장
* 사용  예제: EXEC DBO.BIZ_SENDBILL_HIST_I01 '106-23-91981', 'S', '04', '[폐업]상태입니다.', '20210907'
*************************************************************************************************/
/*  
    ** 수정 내역
    1. 수 정 자: 
    1-1. 수 정 일: 
    1-2. 수정 내역: 
*/  
CREATE PROCEDURE [dbo].[BIZ_SENDBILL_HIST_I01]
    @hist_biz_no     VARCHAR(30),  /* 사업자번호 */
    @hist_site_cd    VARCHAR(2),  /* SITE_CD */
    @hist_res_code   VARCHAR(5),  /* 결과코드(구분값) */
    @hist_res_msg    NVARCHAR(200),  /* 결과 메세지 */
    @hist_close_dt   VARCHAR(10)  /* 폐업일자 */
AS	
BEGIN
	SET NOCOUNT ON
	
    INSERT INTO BIZ_SENDBILL_HIST (hist_biz_no, hist_site_cd, hist_res_code, hist_res_msg, hist_close_dt)
    VALUES (@hist_biz_no, @hist_site_cd, @hist_res_code, @hist_res_msg, @hist_close_dt) 
END;

GO
