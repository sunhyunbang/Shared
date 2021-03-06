USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_CST_MASTER_BACKUP]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 회원정보 수정전 정보 백업
 *  작   성   자 : 정헌수
 *  작   성   일 : 2016-11-10
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 

 *************************************************************************************/

CREATE PROCEDURE [dbo].[SP_CST_MASTER_BACKUP]
@CUID   int
AS
	INSERT CST_MASTER_MOD_BACKUP
	(
		 CUID
		,USERID
		,BAD_YN
		,PWD
		,PWD_MOD_DT
		,PWD_NEXT_ALARM_DT
		,LOGIN_FAIL_CNT
		,LOGIN_FAIL_DT
		,JOIN_DT
		,FLOW
		,MOD_DT
		,MOD_ID
		,ADULT_YN
		,MEMBER_CD
		,USER_NM
		,HPHONE
		,EMAIL
		,GENDER
		,BIRTH
		,SNS_TYPE
		,SNS_ID
		,COM_ID
		,DI
		,CI
		,REST_YN
		,REST_DT
		,OUT_YN
		,SITE_CD
		,INPUTBRANCH
		,CUSTCODE
		,CUSTTYPE
		,MEM_SEQ
		,CONFIRM_YN
		,STATUS_CD
		,MASTER_ID
		,OUT_DT
		,LAST_LOGIN_DT
		,LOGIN_PWD_ENC
		,REALHP_YN
		,SYS_DT
		,pwd_sha2
	)
	select 
		 CUID
		,USERID
		,BAD_YN
		,PWD
		,PWD_MOD_DT
		,PWD_NEXT_ALARM_DT
		,LOGIN_FAIL_CNT
		,LOGIN_FAIL_DT
		,JOIN_DT
		,FLOW
		,MOD_DT
		,MOD_ID
		,ADULT_YN
		,MEMBER_CD
		,USER_NM
		,HPHONE
		,EMAIL
		,GENDER
		,BIRTH
		,SNS_TYPE
		,SNS_ID
		,COM_ID
		,DI
		,CI
		,REST_YN
		,REST_DT
		,OUT_YN
		,SITE_CD
		,INPUTBRANCH
		,CUSTCODE
		,CUSTTYPE
		,MEM_SEQ
		,CONFIRM_YN
		,STATUS_CD
		,MASTER_ID
		,OUT_DT
		,LAST_LOGIN_DT
		,LOGIN_PWD_ENC
		,REALHP_YN
		,GETDATE() SYS_DT
		,pwd_sha2
	 FROM CST_MASTER WITH(NOLOCK)
	 WHERE CUID  = @CUID 
GO
