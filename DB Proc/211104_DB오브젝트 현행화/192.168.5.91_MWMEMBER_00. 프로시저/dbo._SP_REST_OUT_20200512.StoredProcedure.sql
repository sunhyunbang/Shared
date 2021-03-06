USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[_SP_REST_OUT_20200512]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_SP_REST_OUT_20200512]
/*************************************************************************************
 *  단위 업무 명 : 회원 탈퇴 상태 만들기 - 휴면 상태에서 탈퇴로
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 
 *************************************************************************************/
AS 
	SET NOCOUNT ON;
	DECLARE @DOTIME VARCHAR(10), @LOG_ID INT, @ROWS INT
	SET @DOTIME = CONVERT(VARCHAR(10), GETDATE() - 365, 111)


			INSERT INTO CST_BATCH_LOG 
			            (BATCH_NM, BATCH_DETAIL, CONDITION) 
					 VALUES ('CST_REST_OUT', 'OUT', 'ADD_DT < '+CAST(@DOTIME AS VARCHAR) ) ;
			SET @LOG_ID = @@IDENTITY;

			INSERT INTO CST_OUT_MASTER 
			              (
							 CUID
							,OUT_APPLY_DT
							,OUT_PROC_DT
							,OUT_CAUSE
						  )  -- 탈퇴 이력을 남긴다.
				SELECT 
							 CUID
							,GETDATE() AS OUT_APPLY_DT
							,GETDATE() AS OUT_PROC_DT
							,'장기미이용 고객 자동 탈퇴(로그인한지 2년)' AS OUT_CAUSE
				  FROM CST_REST_MASTER WITH(NOLOCK) 
				 WHERE ADD_DT < @DOTIME
				   AND RESTORATION_DT IS NULL -- 복구 하지 않아서 날짜가 없다.

			SET @ROWS = @@ROWCOUNT;
			UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;	

		
			INSERT INTO CST_BATCH_LOG 
			            (BATCH_NM, BATCH_DETAIL, CONDITION) 
					 VALUES ('CST_MASTER', 'OUT', 'OUT_YN = Y , OUT_DT = '+ CAST(GETDATE() AS VARCHAR));
			SET @LOG_ID = @@IDENTITY;
			
				UPDATE CST_MASTER 
				   SET OUT_YN = 'Y' , OUT_DT = GETDATE(), MOD_DT = GETDATE() 
				  FROM   -- 마스터 테이블에서 탈퇴 업데이트
							 CST_REST_MASTER RM 
					LEFT OUTER JOIN CST_MASTER M ON RM.CUID = M.CUID 
				 WHERE RM.ADD_DT < @DOTIME 
				   AND RM.RESTORATION_DT IS NULL
				   
			SET @ROWS = @@ROWCOUNT;
			UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;


			INSERT INTO CST_BATCH_LOG 
			            (BATCH_NM, BATCH_DETAIL, CONDITION) 
					 VALUES ('CST_REST_OUT', 'OUT', 'ADD_DT < '+CAST(@DOTIME AS VARCHAR) +' AND RESTORATION_DT IS NULL');
			SET @LOG_ID = @@IDENTITY;
			
			DELETE FROM CST_REST_MASTER 
			 WHERE ADD_DT < @DOTIME  AND RESTORATION_DT IS NULL  -- 휴면 테이블에서 삭제

			SET @ROWS = @@ROWCOUNT;
			UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;

GO
