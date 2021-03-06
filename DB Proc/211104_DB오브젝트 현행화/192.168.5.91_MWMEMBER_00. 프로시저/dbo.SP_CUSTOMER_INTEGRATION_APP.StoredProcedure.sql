USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOMER_INTEGRATION_APP]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CUSTOMER_INTEGRATION_APP]
/*************************************************************************************
 *  단위 업무 명 : 통합 요청
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
@M_CUID  INT,  -- MASTER CUID
@M_USRID VARCHAR(50),   -- MASTER LOGIN ID
@S_CUID  INT,    -- S
@IP  VARCHAR(20),   -- IP
@USERID VARCHAR(50)   -- 신청한 ID 관리자 페이지에서는 관리자 로그인 한 사람의 ID

AS
	SET NOCOUNT ON;
--	DECLARE @RE_YES_CUID VARCHAR(4000), @RE_NO_CUID VARCHAR(4000), @SQL nvarchar(4000)
--PWD null 처리 추가(통합 회원 비번 동일할시 문제 발생. 비번을 null 로 변경
	UPDATE CST_MASTER SET MASTER_ID = @M_CUID, STATUS_CD = 'D', PWD_SHA2=null WHERE CUID = @S_CUID  -- 마스터 아이디로 귀속
	UPDATE CST_MASTER SET MASTER_ID = @M_CUID ,STATUS_CD = 'A' WHERE CUID = @M_CUID  -- 마스터는 마스터로!
	
	INSERT INTO CST_ADMISSION (M_CUID, S_CUID, CONFIRM_ID, APP_DT, IP)
					   VALUES (@M_CUID, @S_CUID, @USERID, GETDATE(),@IP)
	
	 --EXEC PAPER_NEW.DBO.CUID_CHANGE_ALL_PROC @M_CUID, @M_USRID, @S_CUID, @IP
	 /* 
			 @MASTER_CUID   INT         =  0      -- 기존아이디
			,@MASTER_USERID  VARCHAR(50) =  ''     -- 기존아이디
			,@SLAVE_CUID   INT   =  0      --  변경 아이디
			,@CLIENT_IP   VARCHAR(20) = '사용자 아이디'
	*/
	 
	 --벼룩시장
	 EXEC FINDDB1.PAPER_NEW.DBO.CUID_CHANGE_ALL_PROC  @M_CUID, @M_USRID, @S_CUID, @IP
	 
	 --부동산써브
	 EXEC dbo.SP_MEMBER_CHANGE  @S_CUID, @M_CUID, @IP
GO
