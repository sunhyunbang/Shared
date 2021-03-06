USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_REST_MASTER]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REST_MASTER]
/*************************************************************************************
 *  단위 업무 명 : 회원 휴면 상태 만들기
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
 *************************************************************************************/
AS 
	SET NOCOUNT ON;
	DECLARE @ID_COUNT BIT,  @LOG_ID INT, @ROWS INT;
		
   /* 01. 부동산 써브 예외 정책 */
   CREATE TABLE #NOT_EXSIST
	 ( 
	   mem_seq INT PRIMARY KEY,
	   svc_edate DATETIME NOT NULL
	  )

    INSERT into #NOT_EXSIST (mem_seq, svc_edate)
	       select A.mem_seq, min(A.svc_edate) 'svc_edate'
           from [221.143.23.211,8019].cont.dbo.contract A with(nolock)
          where A.svc_edate not in ('1900-01-01 00:00:00.000', '1913-07-04 00:00:00.000', '1999-12-31 00:00:00.000', '9999-12-31 00:00:00.000')
            -- and A.svc_edate > (GETDATE() - 365)
            AND A.STAT IN ('O','P')
       GROUP BY A.mem_seq
       ORDER BY 2 DESC

    /* 구인구직 예외 처리 */
	CREATE TABLE #TMP_REST (
      CUID INT PRIMARY KEY
     )

    CREATE TABLE #TMP_FINDALL_NOT_REST (
      CUID INT PRIMARY KEY
     )

	 INSERT INTO #TMP_REST (CUID)
     SELECT CUID  
       FROM CST_MASTER CS WITH(NOLOCK) 
      WHERE CS.REST_YN = 'N' 
        AND CS.OUT_YN = 'N' 
        AND (LAST_LOGIN_DT <= GETDATE() - 365 OR ( LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 ))

     INSERT INTO #TMP_FINDALL_NOT_REST (CUID)
     SELECT X.CUID
	   FROM (
           /* 구인구직 공고 기준 */
	         SELECT CUID, MAX(REG_DT) AS REG_DT
	           FROM [192.168.5.32].PAPER_NEW.DBO.PP_AD_TB WITH(NOLOCK)
	          WHERE CUID IN (SELECT CUID FROM #TMP_REST)           
	          GROUP BY CUID
			      UNION ALL
           /* 구인구직 정액권 기준*/
			     SELECT CUID, MAX(REG_DT) AS REG_DT
	           FROM [192.168.5.32].PAPER_NEW.DBO.CY_FAT_REGIST_TB WITH(NOLOCK)
	          WHERE CUID IN (SELECT CUID FROM #TMP_REST)           
	          GROUP BY CUID
			      UNION ALL
            /* 구인구직 이력서 열람권 기준*/
			     SELECT CUID, MAX(REG_DT) AS REG_DT
	           FROM [192.168.5.32].PAPER_NEW.DBO.PP_RESUME_READ_GOODS_REGIST_TB WITH(NOLOCK)
	          WHERE CUID IN (SELECT CUID FROM #TMP_REST)           
	          GROUP BY CUID
	        ) X
      WHERE X.REG_DT >= DATEADD(YEAR, -1, GETDATE()) 

		SELECT @ID_COUNT = COUNT(LAST_LOGIN_DT)  
		  FROM CST_MASTER CS WITH(NOLOCK) 
  	     WHERE CS.REST_YN = 'N' 
  	       AND CS.OUT_YN = 'N' 
	       AND (LAST_LOGIN_DT <= GETDATE() - 365 OR (LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 ))
           AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE CS.CUID = NE.mem_seq) -- 01. 부동산 써브 예외 정책
	       AND NOT EXISTS (SELECT FN.CUID FROM #TMP_FINDALL_NOT_REST FN WHERE CS.CUID = FN.CUID) -- 02. 구인 구직 예외정책 




		IF @ID_COUNT > 0
		BEGIN
		/*
			INSERT INTO CST_REST_MASTER (CUID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI,   ADD_DT )
								  SELECT CUID, USER_NM, HPHONE, EMAIL, BIRTH, DI, CI,   GETDATE() FROM 
										 CST_MASTER WITH(NOLOCK) WHERE LAST_LOGIN_DT <= GETDATE() - 365 
										 AND REST_YN = 'N' -- 마지막 접속 시간을 계산

		*/

			INSERT INTO CST_BATCH_LOG (BATCH_NM, BATCH_DETAIL, CONDITION) 
					VALUES ('CST_REST_MASTER', 
					'REST', 
					'REST_YN=N AND OUT_YN = N AND (LAST_LOGIN_DT <= GETDATE() - 365 OR (LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 ))');
			SET @LOG_ID = @@IDENTITY;


			MERGE  CST_REST_MASTER AS M 
			USING 
				(SELECT * FROM CST_MASTER CS WITH(NOLOCK) 
				  WHERE CS.REST_YN = 'N' 
				    AND CS.OUT_YN = 'N' 
					  AND (LAST_LOGIN_DT <= GETDATE() - 365 OR ( LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 ))
            AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE CS.CUID = NE.mem_seq)
				) AS C
			ON M.CUID = C.CUID
			WHEN MATCHED THEN 
				UPDATE SET M.USER_NM = C.USER_NM 
						  ,M.HPHONE = C.HPHONE
						  ,M.EMAIL = C.EMAIL
						  ,M.BIRTH = C.BIRTH
						  ,M.DI = C.DI
						  ,M.CI = C.CI
						  ,M.ADD_DT = GETDATE()
						  ,M.RESTORATION_DT = NULL   -- 휴면에서 풀린 상태에 값이 들어가 있으면 초기화
						  ,M.GENDER = C.GENDER
			WHEN NOT MATCHED THEN
				INSERT (CUID
				       ,USERID
				       ,SITE_CD
				       ,USER_NM
				       ,HPHONE
				       ,EMAIL
				       ,BIRTH
				       ,DI
				       ,CI
				       ,ADD_DT
					   ,GENDER
					   ) 
				VALUES 
				       (C.CUID
				       ,C.USERID
				       ,C.SITE_CD
				       ,C.USER_NM
				       ,C.HPHONE
				       ,C.EMAIL
				       ,C.BIRTH
				       ,C.DI
				       ,C.CI
				       ,GETDATE()
					   ,C.GENDER 
					   ) ;


		
			UPDATE CST_MASTER 
			  SET USER_NM = ''
			    , HPHONE = ''
			    , EMAIL = ''
			    , BIRTH = '' -- REPLACE(REPLACE(SUBSTRING(BIRTH,1,4),'-',''),' ','')
			    , DI = '' 
			    , CI = ''
			    , REST_YN = 'Y' 
			    , REST_DT = GETDATE()
				, GENDER = ''
		  WHERE REST_YN='N' AND OUT_YN = 'N' 
			 AND ( LAST_LOGIN_DT <= GETDATE() - 365 
				     OR (LAST_LOGIN_DT IS NULL AND JOIN_DT <= GETDATE() - 365 )
				   )
       AND NOT EXISTS (SELECT * FROM #NOT_EXSIST NE WHERE CUID = NE.mem_seq)
	    -- 사용자 정보 업데이트
		  SET @ROWS = @@ROWCOUNT;
		  UPDATE CST_BATCH_LOG SET END_DT=GETDATE(), ROWS=@ROWS WHERE ID=@LOG_ID;			  
		
      -- 임시 테이블 삭제
      DROP TABLE #NOT_EXSIST
	  DROP TABLE #TMP_REST
      DROP TABLE #TMP_FINDALL_NOT_REST

      --대상 회원 메일 발송 데이터 입력
    	EXEC BAT_MM_REST_CONFIRM_PROC
    					  
			RETURN(0)
		END
		ELSE	
		BEGIN
			RETURN(500)
		END
GO
