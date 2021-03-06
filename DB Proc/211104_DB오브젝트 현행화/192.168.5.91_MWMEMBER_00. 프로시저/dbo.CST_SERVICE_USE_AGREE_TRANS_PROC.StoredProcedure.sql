USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[CST_SERVICE_USE_AGREE_TRANS_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CST_SERVICE_USE_AGREE_TRANS_PROC] (

/*************************************************************************************
 *  단위 업무 명 : 서비스 이용동의 데이터 이관 (일일 / 벼부DB -> 통합회원DB)
 *  작   성   자 : 이정원
 *  작   성   일 : 2021-10-08
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 일일 부동산 서비스 이용동의 데이터 이관 처리
 *************************************************************************************/

  @RESULT INT OUTPUT  

        
)
AS
  DECLARE @strDate datetime    
  DECLARE @endDate datetime    
  DECLARE @oCnt INT            
  DECLARE @nCnt INT    

SET @strDate = CAST(CONCAT(CONVERT(VARCHAR(10), DATEADD(DAY, -1, GETDATE()), 23), ' 00:00:00') AS DATETIME)
SET @endDate = CAST(CONCAT(CONVERT(VARCHAR(10), DATEADD(DAY, -1, GETDATE()), 23), ' 23:59:59') AS DATETIME)
SET @RESULT = 1   -- 결과 초기값 
-- 1. 전날 데이터 중복확인 (통합회원DB) 	
SELECT 
	@oCnt = COUNT(*)      
FROM  MWMEMBER.dbo.CST_SERVICE_USE_AGREE WITH (NOLOCK)
WHERE REG_DT >= @strDate
  AND REG_DT <= @endDate
  AND SECTION_CD = 'S103'	 
  
IF @oCnt = 0 BEGIN 
		-- 2. INSERT할 데이터 확인 (벼부DB)
		SELECT @nCnt = COUNT(*) FROM OPENQUERY
		(
			AWS_ET, ' SELECT 
					  IDX, CUID, SECTION_CD, AGREE_CD, REG_DT
					  FROM findalldb.tu_cst_service_use_agree
					  WHERE SECTION_CD = ''S103''
						AND REG_DT >= CONCAT(DATE_ADD(DATE_FORMAT(NOW(), ''%Y-%m-%d''), interval -1 day), '' 00:00:00'')
						AND REG_DT <= CONCAT(DATE_ADD(DATE_FORMAT(NOW(), ''%Y-%m-%d''), interval -1 day), '' 23:59:59'')
					'
		)	
		
		IF @nCnt > 0 BEGIN 			
                -- 3. 데이터 이관 (INSERT / 벼부DB -> 통합회원DB)
		BEGIN TRY
			BEGIN TRAN			
			INSERT INTO MWMEMBER.dbo.CST_SERVICE_USE_AGREE (CUID, SECTION_CD, AGREE_CD, REG_DT)
				SELECT 
			      C.CUID
			    , C.SECTION_CD
			 	, C.AGREE_CD
				, C.REG_DT
				FROM (								
					   SELECT * 
					   FROM 
					   OPENQUERY (		
					   AWS_ET,
					   'SELECT
					     A.CUID
					   , A.SECTION_CD 
					   , A.AGREE_CD 
					   , A.REG_DT 
					   FROM FINDALLDB.TU_CST_SERVICE_USE_AGREE A
					   WHERE A.REG_DT >= CONCAT(DATE_ADD(DATE_FORMAT(NOW(), ''%Y-%m-%d''), interval -1 day), '' 00:00:00'')
						 AND A.REG_DT <= CONCAT(DATE_ADD(DATE_FORMAT(NOW(), ''%Y-%m-%d''), interval -1 day), '' 23:59:59'')
						 AND A.SECTION_CD = ''S103''
					   ORDER BY a.REG_DT ASC'
					)
				) C			
		
			COMMIT TRAN						
			SET @RESULT = 0			
		END TRY
			
		BEGIN CATCH			
			ROLLBACK TRAN					
			SET @RESULT = -1								
		END CATCH
		END	
END
GO
