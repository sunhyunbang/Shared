USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[__DEL__SP_REST_MASTER_BK20160820]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[__DEL__SP_REST_MASTER_BK20160820]
/*************************************************************************************
 *  단위 업무 명 : 회원 휴먼 상태 만들기
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 * RETURN(0)  -- 정상
 * RETURN(500)  -- 갯수가 없을 경우
 * DECLARE @RET INT
 * EXEC @RET=SP_REST_MASTER
 * SELECT @RET
 
 select * FROM CST_REST_MASTER where userid ='kkam1234'
 delete CST_REST_MASTER where userid ='kkam1234'
		
	INSERT CST_REST_MASTER (CUID ,USERID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI, ADD_DT)  
			select 	   C.CUID, C.USERID, C.USER_NM, C.HPHONE, C.EMAIL, C.BIRTH, C.DI, C.CI, GETDATE()  FROM CST_MASTER C
			where USERID ='kkam1234' and CUID = 11682400
			
 *************************************************************************************/
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT, @LAST_LOGIN_DT DATETIME
		
		SELECT @ID_COUNT = COUNT(LAST_LOGIN_DT) 
		FROM CST_MASTER WITH(NOLOCK)
		WHERE LAST_LOGIN_DT <= GETDATE() - 365 
				AND REST_YN='N' 
				AND OUT_YN='N' 

		IF @ID_COUNT > 0
		BEGIN
			/*
				INSERT INTO CST_REST_MASTER (CUID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI,   ADD_DT )
									  SELECT CUID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI,   GETDATE() FROM 
											 CST_MASTER WITH(NOLOCK) WHERE LAST_LOGIN_DT <= GETDATE() - 365 
											 AND REST_YN = 'N' -- 마지막 접속 시간을 계산

			*/
			
			MERGE  CST_REST_MASTER AS M USING 
				(SELECT * FROM CST_MASTER WITH(NOLOCK) WHERE REST_YN='N' AND OUT_YN = 'N' AND LAST_LOGIN_DT <= GETDATE() - 365 ) AS C
			ON M.CUID = C.CUID
			WHEN MATCHED THEN 
				UPDATE SET M.USER_NM = C.USER_NM , M.HPHONE = C.HPHONE , EMAIL = C.EMAIL, 
						   M.BIRTH = C.BIRTH, DI = C.DI, CI = C.CI, ADD_DT = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (CUID ,USERID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI, ADD_DT) VALUES 
					   (C.CUID, C.USERID, C.USER_NM, C.HPHONE, C.EMAIL, C.BIRTH, C.DI, C.CI, GETDATE() ) ;
			
			UPDATE CST_MASTER SET USER_NM = '', HPHONE = '', EMAIL = '',
							BIRTH =  REPLACE(REPLACE(SUBSTRING(BIRTH,1,4),'-',''),' ',''), DI = '' ,CI = '', REST_YN = 'Y' , REST_DT = GETDATE()
							WHERE LAST_LOGIN_DT <= GETDATE() - 365  -- 사용자 정보 업데이트
			RETURN(0)
		END
		ELSE	
		BEGIN
			RETURN(500)
		END
		
		
GO
