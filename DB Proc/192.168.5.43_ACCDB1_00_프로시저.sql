USE [ACCDB1]
GO
/****** Object:  StoredProcedure [dbo].[USP_BILL_ONLINE_ENCODE]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************/
/* TITLE  : USP_BILL_ONLINE_ENCODE                 */
/* 내  용 : BILL_TRANS 암호화 처리 저장 프로시져   */
/* 목  적 : 파인드올(온라인) 암호화 전용으로 사용  */
/* 작성일 : 2012.12.14 PSH                         */
/***************************************************/
--EXEC USP_BILL_ONLINE_ENCODE 구분(update : 1, insert : 2), BILLSEQ, SVENDERNO, RVENDERNO, DT, SUPMONEY, TAXMONEY, GUBUN, BIGO, BILLTYPE, SCOMPANY, SCEONAME, SUPTAE, SUPJONG, SADDRESS, SADDRESS2, SUSER, STELNO, SEMAIL, RCOMPANY, RCEONAME, RUPTAE, RUPJONG, RADDRESS, RADDRESS2, RUSER, RTELNO, REMAIL, SERIAL_NO, SENDID, USER_SET_DIV, 리턴변수
--Insert 시
--EXEC USP_BILL_ONLINE_ENCODE '2','X999-9999','1298112602','8103031234567', '2012-12-14', '1000', '100', '2', '테스트자료입니다123', '61', '미디어윌(테스트)', '박성현', '서비스', '기술', '서울시 강남구 역삼동 테스트', '공급자주소2', '테스터', '070-222-2222', 'test@mediawill.com', '카페24(주)', '김개동', '전산', '테스트', '서울시 관악구 신림동 롯데', '공급받는자주소2', '아이유', '001-112-3132', 'aiu@aiu.com', '999-99999', 'test1234', '3000', ''
--공급자 주소1,2 변경 및 공급받는자 전화번호 변경 시(update)
--EXEC USP_BILL_ONLINE_ENCODE '1','X999-9999','','', '', '', '', '', '', '', '', '', '', '', '서울시 강남구 역삼동 허바허바빌딩', '공급자주소2 변경', '', '', '', '', '', '', '', '', '', '', '123455677', '', '', '', '', ''

create	PROCEDURE [dbo].[USP_BILL_ONLINE_ENCODE] (
                                                  @PRGU         VARCHAR(2),   --프로세스 구분 UPDATE : 1, INSERT 구분 : 2
                                                  @BILLSEQ      VARCHAR(25),  --세금계산서번호
												  @SVENDERNO    VARCHAR(10),  --공급자사업자번호.'-'없이입력.
												  @RVENDERNO    VARCHAR(13),  --공급받는자사업자번호.'-'없이입력
												  @DT           VARCHAR(10),  -- 금계산서작성일(yyyy-mm-dd)
												  @SUPMONEY     BIGINT,       -- 공급가총액
												  @TAXMONEY     BIGINT,       --세액총액
												  
												  @GUBUN        CHAR(1),      --영수(1)/청구(2)
												  @BIGO         VARCHAR(150), --비고
												  @BILLTYPE     VARCHAR(2),   -- 세금계산서종류(사업자분 : 11, 주민분 : 61)

												  @SCOMPANY     VARCHAR(70),  --공급자업체명
												  @SCEONAME     VARCHAR(30),  --공급자대표자명
												  @SUPTAE       VARCHAR(40),  --공급자업태
												  @SUPJONG      VARCHAR(40),  --공급자종목
												  @SADDRESS     VARCHAR(150), --공급자주소
												  @SADDRESS2    VARCHAR(80), --공급자주소2
												  @SUSER        VARCHAR(30),  --공급자담당자명
												  @STELNO       VARCHAR(20),  --공급자전화번호
												  @SEMAIL       VARCHAR(40),  --공급자e-mail 

												  @RCOMPANY     VARCHAR(70),  --공급받는자업체명
												  @RCEONAME     VARCHAR(30),  --공급받는자대표자명
												  @RUPTAE       VARCHAR(40),  --공급받는자업태
												  @RUPJONG      VARCHAR(40),  --공급받는자업종
												  @RADDRESS     VARCHAR(150), --공급받는자주소
												  @RADDRESS2    VARCHAR(80), --공급받는자주소2
												  @RUSER        VARCHAR(30),  --공급받는자담당자명
												  @RTELNO       VARCHAR(20),  --공급받는자전화번호
												  @REMAIL       VARCHAR(40),  --공급받는자e-mail

												  @SERIAL_NO    VARCHAR(25),  --계산서번호
												  @SENDID       VARCHAR(20),  --공급자SENDBILL_ID
												  @REPORT_AMEND_CD VARCHAR(2),--2013.12.16 수정세금계산서 사유코드
												  @USER_SET_DIV VARCHAR(4),   --
												  @REPORT_ETC01 VARCHAR(24),  --2013.12.16 수정 발행 시 당초세금계산서 국세청승인번호 기입												  
                                                  
												  @return         INT    OUTPUT
												) AS

BEGIN

-- 사업자 세금계산서와 개인 세금계산서에 대한 타입이 잘못 기입됐을 때 수정 처리
	IF @BILLTYPE = '11' AND LEN(@RVENDERNO) = 13
	BEGIN
		SET @BILLTYPE = '61'
	END		
	ELSE IF @BILLTYPE = '61' AND LEN(@RVENDERNO) = 10
	BEGIN
		SET @BILLTYPE = '11'
	END
-------------------------------------------------------------------------------

--------------------------------------------------------------------------------

	IF @PRGU = '1' -- 1. UPDATE
	BEGIN
	
		DECLARE @sSQL  NVARCHAR(4000)
		DECLARE @tmpCT INT
		
		SET @tmpCT = 0
						
		SET @sSQL = 'UPDATE ACCDB1.dbo.BILL_TRANS 
					 SET '
	    
		IF ISNULL(@DT, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  DT	= '''+@DT+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , DT	= '''+@DT+''''
			END
		END
		
		IF ISNULL(@SUPMONEY, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SUPMONEY = '''+@SUPMONEY+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SUPMONEY	= '''+@SUPMONEY+''''
			END
		END
		
		IF ISNULL(@TAXMONEY, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+' TAXMONEY	= '''+@TAXMONEY+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , TAXMONEY	= '''+@TAXMONEY+''''
			END
		END
		
		IF ISNULL(@GUBUN, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  GUBUN	= '''+@GUBUN+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , GUBUN	= '''+@GUBUN+''''
			END
		END
		
		IF ISNULL(@SCOMPANY, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SCOMPANY	= '''+@SCOMPANY+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SCOMPANY	= '''+@SCOMPANY+''''
			END
		END	
			
		IF ISNULL(@SCEONAME, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SCEONAME	= '''+@SCEONAME+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SCEONAME	= '''+@SCEONAME+''''
			END
		END	
		
		IF ISNULL(@SUPTAE, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SUPTAE	= '''+@SUPTAE+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SUPTAE	= '''+@SUPTAE+''''
			END
		END	
		
		IF ISNULL(@SUPJONG, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SUPJONG	= '''+@SUPJONG+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SUPJONG	= '''+@SUPJONG+''''
			END
		END	
		
		IF ISNULL(@SADDRESS, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SADDRESS	= '''+@SADDRESS+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SADDRESS	= '''+@SADDRESS+''''
			END
		END	
		
		IF ISNULL(@SADDRESS2, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SADDRESS2	= '''+@SADDRESS2+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SADDRESS2	= '''+@SADDRESS2+''''
			END
		END	
		
		IF ISNULL(@SUSER, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SUSER	= '''+@SUSER+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SUSER	= '''+@SUSER+''''
			END
		END	
		
		IF ISNULL(@STELNO, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  STELNO	= '''+@STELNO+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , STELNO	= '''+@STELNO+''''
			END
		END	
		
		IF ISNULL(@SUSER, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SUSER	= '''+@SUSER+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SUSER	= '''+@SUSER+''''
			END
		END	
		
		IF ISNULL(@SEMAIL, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SEMAIL	= '''+@SEMAIL+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SEMAIL	= '''+@SEMAIL+''''
			END
		END	
		
		IF ISNULL(@RVENDERNO, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  RVENDERNO	= ACCDB1.dbo.fn_mwseedencode('''+@RVENDERNO+''')'
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , RVENDERNO	= ACCDB1.dbo.fn_mwseedencode('''+@RVENDERNO+''')'
			END
		END	
		
		IF ISNULL(@RCOMPANY, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  RCOMPANY	= '''+@RCOMPANY+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , RCOMPANY	= '''+@RCOMPANY+''''
			END
		END
		
		IF ISNULL(@RCEONAME, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  RCEONAME	= '''+@RCEONAME+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , RCEONAME	= '''+@RCEONAME+''''
			END
		END
		
		IF ISNULL(@RUPTAE, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  RUPTAE	= '''+@RUPTAE+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , RUPTAE	= '''+@RUPTAE+''''
			END
		END
		
		IF ISNULL(@RUPJONG, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  RUPJONG	= '''+@RUPJONG+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , RUPJONG	= '''+@RUPJONG+''''
			END
		END
		
		IF ISNULL(@RADDRESS, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  RADDRESS	= '''+@RADDRESS+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , RADDRESS	= '''+@RADDRESS+''''
			END
		END
		
		IF ISNULL(@RADDRESS2, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  RADDRESS2	= '''+@RADDRESS2+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , RADDRESS2	= '''+@RADDRESS2+''''
			END
		END
		
		IF ISNULL(@RUSER, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  RUSER	= '''+@RUSER+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , RUSER	= '''+@RUSER+''''
			END
		END
		
		IF ISNULL(@RTELNO, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  RTELNO	= '''+@RTELNO+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , RTELNO	= '''+@RTELNO+''''
			END
		END
		
		IF ISNULL(@REMAIL, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  REMAIL	= '''+@REMAIL+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , REMAIL	= '''+@REMAIL+''''
			END
		END
		
		IF ISNULL(@SENDID, '') <> ''
		BEGIN
			IF @tmpCT = 0
			BEGIN
				SET @sSQL = @sSQL+'  SENDID	= '''+@SENDID+''''
				SET @tmpCT = @tmpCT+1
			END
			ELSE
			BEGIN
				SET @sSQL = @sSQL+' , SENDID	= '''+@SENDID+''''
			END
		END	
		
		SET @sSQL = @sSQL+' WHERE BILLSEQ = '''+@BILLSEQ+''''
		
		EXEC sp_executesql @sSQL
		
		IF @@ERROR <> 0
		BEGIN
			GOTO ERROR_RETURN
		END
	END

--------------------------------------------------------------------------------------------------------

	IF @PRGU = '2' -- 2. Insert 구문
	BEGIN

		INSERT INTO  ACCDB1.dbo.BILL_TRANS 
					( 
						BILLSEQ
				      , SVENDERNO
					  , RVENDERNO
					  , DT
					  , SUPMONEY
					  , TAXMONEY
					  , TAXRATE
					  , CASH
					  , CHECKS
					  , NOTE
					  , CREDIT
					  , GUBUN
					  , BIGO
					  , BILLTYPE
					  , SCOMPANY
					  , SCEONAME
					  , SUPTAE
					  , SUPJONG
					  , SADDRESS
					  , SADDRESS2
					  , SUSER
					  , SDIVISION
					  , STELNO
					  , SEMAIL
					  , RCOMPANY
					  , RCEONAME
					  , RUPTAE
					  , RUPJONG
					  , RADDRESS
					  , RADDRESS2
					  , RUSER
					  , RDIVISION
					  , RTELNO
					  , REMAIL
					  , REPORT_EXCEPT_YN
					  , CREATE_DT
					  , SERIAL_NO
					  , TRANSYN
					  , REVERSEYN
					  , SENDID
					  , REPORT_AMEND_CD --2013.12.16 수정세금계산서 사유코드
					  , RECVID
					  , USER_SET_DIV
					  , TEST_YN
					  , ETC01
					  , ETC02
					  , ETC03
					  , ETC04
					  , ETC05
					  , ETC06
					  , ETC07
					  , ETC08
					  , ETC09
					  , REPORT_ETC01 --2013.12.16 수정 발행 시 당초세금계산서 국세청승인번호 기입
					) 
			 VALUES 
					( 
						@BILLSEQ, 		--세금계산서번호 
						@SVENDERNO, 	--공급자사업자번호.'-'없이 입력.
						ACCDB1.dbo.fn_mwseedencode(@RVENDERNO), 	--공급받는자사업자번호.'-'없이 입력.
						@DT, 		    --세금계산서 작성일 (yyyy-mm-dd)
						@SUPMONEY, 		--공급가 총액
						@TAXMONEY, 		--세액 총액
						'0', 			    --과세율
						0,
						0,
						0,
						0,
						@GUBUN, 		--영수(1)/청구(2)
						@BIGO, 		    --비고:boxad_id,collect_id등
						@BILLTYPE, 		--세금계산서 종류
						@SCOMPANY, 		--공급자 업체명
						@SCEONAME, 		--공급자 대표자명
						@SUPTAE, 		--공급자 업태
						@SUPJONG, 		--공급자 종목
						@SADDRESS, 		--공급자 주소
						@SADDRESS2, 	--공급자 주소
						@SUSER, 		--공급자 담당자명
						NULL,           --SDIVISION
						@STELNO, 		--공급자 전화번호
						@SEMAIL, 		--공급자 e-mail 
						@RCOMPANY, 		--공급받는자 업체명 
						@RCEONAME, 		--공급받는자 대표자명
						@RUPTAE, 		--공급받는자 업태
						@RUPJONG, 		--공급받는자 업종
						@RADDRESS, 		--공급받는자 주소
						@RADDRESS2, 		--공급받는자 주소2
						@RUSER, 		--공급받는자 담당자명
						NULL,           --RDIVISION
						@RTELNO, 		--공급받는자 전화번호
						@REMAIL, 		--공급받는자 e-mail
						'Y', 		    --신고 제외 아니다.(N:즉시신고/Y:발행예정)
						CONVERT(VARCHAR(8), GETDATE(), 112), 	--생성일
						@SERIAL_NO, 	--계산서 번호 (우측 상단에 출력)
						'N', 		    --테스트 여부
						'N', 		    --전송여부
						@SENDID, 		--공급자 SENDBILL_ID
						@REPORT_AMEND_CD, --2013.12.16 수정세금계산서 사유코드
						NULL,
						@USER_SET_DIV,  --(줄:2000, 박스 :1000, 회계:3000)
						'N',            --TEST_YN
						'S', 		    --ETC01
						NULL, 		    --ETC02
						'N', 		    --ETC03
						NULL,           --ETC04
						NULL,			--ETC05
						NULL,			--ETC06
						NULL,			--ETC07
						NULL,			--ETC08
						CONVERT(VARCHAR(24), GETDATE(), 121), --ETC09
						@REPORT_ETC01  --2013.12.16 수정 발행 시 당초세금계산서 국세청승인번호 기입
					)
			
		IF @@ERROR <> 0
		BEGIN
	  			GOTO ERROR_RETURN
		END
	END
	
	
SET @return = 0
RETURN @return
END
ERROR_RETURN:
BEGIN	
	SET @return = -1
	RETURN @return
END 

/*******************************************************************/
/*****                	END OF PROCEDURE                       *****/
/*******************************************************************/
GO
/****** Object:  StoredProcedure [dbo].[USP_BILL_TRANS_ENCODE]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************/
/* TITLE  : USP_BILL_TRANS_ENCODE                */
/* 내  용 : BILL_TRANS 암호화 처리 저장 프로시져 */
/* 목  적 : 영업 통합 BOX 암호화 전용으로 사용   */
/* 작성일 : 2012.11.23 PSH                       */	
/*************************************************/
-- EXEC USP_BILL_TRANS_ENCODE 구분(update : 1, insert : 2), BILLSEQ, SVENDERNO, RVENDERNO, DT, SUPMONEY, TAXMONEY, GUBUN, BIGO, BILLTYPE, SCOMPANY, SCEONAME, SUPTAE, SUPJONG, SADDRESS, SUSER, STELNO, SEMAIL, RCOMPANY, RCEONAME, RUPTAE, RUPJONG, RADDRESS, RUSER, RTELNO, REMAIL, SERIAL_NO, SENDID, REPORT_AMEND_CD, RREG_ID, 리턴변수
-- EXEC USP_BILL_TRANS_ENCODE '2','M123-1234567','1298112602','8103031234567', '2012-11-01', '500000', '50000', '2', '테스트자료입니다123', '61', '미디어윌(테스트)', '박성현', '서비스', '기술', '서울시 강남구 역삼동 테스트', '테스터', '070-222-2222', 'test@mediawill.com', '카페24(주)', '김개동', '전산', '테스트', '서울시 관악구 신림동 롯데', '아이유', '001-112-3132', 'aiu@cafe24.com', '27-1234567', 'test1234', null, '0', ''

create	PROCEDURE [dbo].[USP_BILL_TRANS_ENCODE] (
                                                  @PRGU         VARCHAR(2),   --프로세스 구분 UPDATE : 1, INSERT 구분 : 2
                                                  @BILLSEQ      VARCHAR(25),  --세금계산서번호
												  @SVENDERNO    VARCHAR(10),  --공급자사업자번호.'-'없이입력.
												  @RVENDERNO    VARCHAR(13),  --공급받는자사업자번호.'-'없이입력
												  @DT           VARCHAR(10),  -- 금계산서작성일(yyyy-mm-dd)
												  @SUPMONEY     BIGINT,       -- 공급가총액
												  @TAXMONEY     BIGINT,       --세액총액
												  @GUBUN        CHAR(1),      --영수(1)/청구(2)
												  @BIGO         VARCHAR(150), --비고
												  @BILLTYPE     VARCHAR(2),   -- 세금계산서종류(사업자분 : 11, 주민분 : 61)

												  @SCOMPANY     VARCHAR(70),  --공급자업체명
												  @SCEONAME     VARCHAR(30),  --공급자대표자명
												  @SUPTAE       VARCHAR(40),  --공급자업태
												  @SUPJONG      VARCHAR(40),  --공급자종목
												  @SADDRESS     VARCHAR(150), --공급자주소
												  @SUSER        VARCHAR(30),  --공급자담당자명
												  @STELNO       VARCHAR(20),  --공급자전화번호
												  @SEMAIL       VARCHAR(40),  --공급자e-mail 

												  @RCOMPANY     VARCHAR(70),  --공급받는자업체명
												  @RCEONAME     VARCHAR(30),  --공급받는자대표자명
												  @RUPTAE       VARCHAR(40),  --공급받는자업태
												  @RUPJONG      VARCHAR(40),  --공급받는자업종
												  @RADDRESS     VARCHAR(150), --공급받는자주소
												  @RUSER        VARCHAR(30),  --공급받는자담당자명
												  @RTELNO       VARCHAR(20),  --공급받는자전화번호
												  @REMAIL       VARCHAR(40),  --공급받는자e-mail

												  @SERIAL_NO    VARCHAR(25),  --계산서번호
												  @SENDID       VARCHAR(20),  --공급자SENDBILL_ID
												  @REPORT_AMEND_CD VARCHAR(2),--수정코드
												  @RREG_ID      SMALLINT,     --종사업장코드
                                                  
												  @return         INT    OUTPUT
												) AS

BEGIN

-- 사업자 세금계산서와 개인 세금계산서에 대한 타입이 잘못 기입됐을 때 수정 처리
	IF @BILLTYPE = '11' AND LEN(@RVENDERNO) = 13
	BEGIN
		SET @BILLTYPE = '61'
	END		
	ELSE IF @BILLTYPE = '61' AND LEN(@RVENDERNO) = 10
	BEGIN
		SET @BILLTYPE = '11'
	END
-------------------------------------------------------------------------------

	IF @PRGU = '1' -- 1. UPDATE
	BEGIN

		UPDATE ACCDB1.dbo.BILL_TRANS 
		SET 
			  DT		= @DT
		    , SUPMONEY	= @SUPMONEY
		    , TAXMONEY	= @TAXMONEY 
			, GUBUN		= @GUBUN
			, SCOMPANY	= @SCOMPANY
			, SCEONAME	= @SCEONAME
			, SUPTAE	= @SUPTAE
			, SUPJONG   = @SUPJONG
			, SADDRESS	= @SADDRESS
			, SUSER		= @SUSER
			, STELNO	= @STELNO
			, SEMAIL	= @SEMAIL
			, RVENDERNO	= ACCDB1.dbo.fn_mwseedencode(@RVENDERNO)
			, RCOMPANY	= @RCOMPANY
			, RCEONAME	= @RCEONAME
			, RUPTAE	= @RUPTAE
			, RUPJONG	= @RUPJONG
			, RADDRESS	= @RADDRESS
			, RUSER		= @RUSER
			, RTELNO	= @RTELNO
			, REMAIL	= @REMAIL
			, SENDID	= @SENDID
			, RREG_ID	= @RREG_ID
		
		WHERE BILLSEQ = @BILLSEQ 
			
		IF @@ERROR <> 0
		BEGIN
	   		GOTO ERROR_RETURN
		END
	END

	IF @PRGU = '2' -- 2. Insert 구문
	BEGIN

		INSERT INTO  ACCDB1.dbo.BILL_TRANS 
					( 
						BILLSEQ		,	
						SVENDERNO	,	
						RVENDERNO	,	
						DT			,	
						SUPMONEY	,	
						TAXMONEY	,	
						TAXRATE		,	
						GUBUN		,	
						BIGO		,	
						BILLTYPE	,	
						SCOMPANY	,	
						SCEONAME	,	
						SUPTAE		,	
						SUPJONG		,	
						SADDRESS	,	
						SUSER		,	
						STELNO		,	
						SEMAIL		,	
						RCOMPANY	,	
						RCEONAME	,	
						RUPTAE		,	
						RUPJONG		,	
						RADDRESS	,	
						RUSER		,	
						RTELNO		,	
						REMAIL		,	
						USER_SET_DIV,	
						REPORT_EXCEPT_YN, 
						CREATE_DT	,	
						SERIAL_NO	,	
						TEST_YN		,	
						TRANSYN		,	
						SENDID		,	
						REPORT_AMEND_CD, 
						ETC01		,	
						ETC02		,	
						ETC03		,	
						ETC04		,	
						ETC05		,	
						ETC06		,	
						ETC07		,	
						ETC08		,	
						ETC09		,	
						REVERSEYN	,	
						CREAT_DIV	,	
						RREG_ID		
					) 
			 VALUES 
					( 
						@BILLSEQ, 		--세금계산서번호 
						@SVENDERNO, 	--공급자사업자번호.'-'없이 입력.
						ACCDB1.dbo.fn_mwseedencode(@RVENDERNO), 	--공급받는자사업자번호.'-'없이 입력.
						@DT, 		    --세금계산서 작성일 (yyyy-mm-dd)
						@SUPMONEY, 		--공급가 총액
						@TAXMONEY, 		--세액 총액
						0, 			    --과세율
						@GUBUN, 		--영수(1)/청구(2)
						@BIGO, 		    --비고:boxad_id,collect_id등
						@BILLTYPE, 		--세금계산서 종류
						@SCOMPANY, 		--공급자 업체명
						@SCEONAME, 		--공급자 대표자명
						@SUPTAE, 		--공급자 업태
						@SUPJONG, 		--공급자 종목
						@SADDRESS, 		--공급자 주소
						@SUSER, 		--공급자 담당자명
						@STELNO, 		--공급자 전화번호
						@SEMAIL, 		--공급자 e-mail 
						@RCOMPANY, 		--공급받는자 업체명 
						@RCEONAME, 		--공급받는자 대표자명
						@RUPTAE, 		--공급받는자 업태
						@RUPJONG, 		--공급받는자 업종
						@RADDRESS, 		--공급받는자 주소
						@RUSER, 		--공급받는자 담당자명
						@RTELNO, 		--공급받는자 전화번호
						@REMAIL, 		--공급받는자 e-mail
						'1000', 		--박스만 사용하므로 1000 고정(줄이면 2000)
						'Y', 		    --신고 제외 아니다.(N:즉시신고/Y:발행예정)
						CONVERT(VARCHAR(8), GETDATE(), 112), 	--생성일
						@SERIAL_NO, 	--계산서 번호 (우측 상단에 출력)
						'N', 		    --테스트 여부
						'N', 		    --전송여부
						@SENDID, 		--공급자 SENDBILL_ID
						@REPORT_AMEND_CD,--수정 코드
						'S', 		    --ID 구분 (S:샌드빌/I-거래처)
						'N', 		    --수정여부(Y:수정/N:신규/D:삭제)
						'Y', 		    --자동회원가입여부(Y/N)
						NULL, 
						NULL, 
						NULL, 
						NULL, 
						NULL, 
						NULL, 
						'N' , 
						'A' , 
						@RREG_ID		-- 종사업장 코드
					)
			
		IF @@ERROR <> 0
		BEGIN
	  			GOTO ERROR_RETURN
		END
	END
	
	
SET @return = 0
RETURN @return
END
ERROR_RETURN:
BEGIN	
	SET @return = -1
	RETURN @return
END 

/*******************************************************************/
/*****                	END OF PROCEDURE                       *****/
/*******************************************************************/
GO
/****** Object:  StoredProcedure [dbo].[dt_addtosourcecontrol]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_addtosourcecontrol]
    @vchSourceSafeINI varchar(255) = '',
    @vchProjectName   varchar(255) ='',
    @vchComment       varchar(255) ='',
    @vchLoginName     varchar(255) ='',
    @vchPassword      varchar(255) =''

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId = 0

declare @iStreamObjectId int
select @iStreamObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

declare @vchDatabaseName varchar(255)
select @vchDatabaseName = db_name()

declare @iReturnValue int
select @iReturnValue = 0

declare @iPropertyObjectId int
declare @vchParentId varchar(255)

declare @iObjectCount int
select @iObjectCount = 0

    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError


    /* Create Project in SS */
    exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
											'AddProjectToSourceSafe',
											NULL,
											@vchSourceSafeINI,
											@vchProjectName output,
											@@SERVERNAME,
											@vchDatabaseName,
											@vchLoginName,
											@vchPassword,
											@vchComment


    if @iReturn <> 0 GOTO E_OAError

    /* Set Database Properties */

    begin tran SetProperties

    /* add high level object */

    exec @iPropertyObjectId = dbo.dt_adduserobject_vcs 'VCSProjectID'

    select @vchParentId = CONVERT(varchar(255),@iPropertyObjectId)

    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSProjectID', @vchParentId , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSProject' , @vchProjectName , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSourceSafeINI' , @vchSourceSafeINI , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSQLServer', @@SERVERNAME, NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSQLDatabase', @vchDatabaseName, NULL

    if @@error <> 0 GOTO E_General_Error

    commit tran SetProperties
    
    select @iObjectCount = 0;

CleanUp:
    select @vchProjectName
    select @iObjectCount
    return

E_General_Error:
    /* this is an all or nothing.  No specific error messages */
    goto CleanUp

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_addtosourcecontrol_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_addtosourcecontrol_u]
    @vchSourceSafeINI nvarchar(255) = '',
    @vchProjectName   nvarchar(255) ='',
    @vchComment       nvarchar(255) ='',
    @vchLoginName     nvarchar(255) ='',
    @vchPassword      nvarchar(255) =''

as
	-- This procedure should no longer be called;  dt_addtosourcecontrol should be called instead.
	-- Calls are forwarded to dt_addtosourcecontrol to maintain backward compatibility
	set nocount on
	exec dbo.dt_addtosourcecontrol 
		@vchSourceSafeINI, 
		@vchProjectName, 
		@vchComment, 
		@vchLoginName, 
		@vchPassword
GO
/****** Object:  StoredProcedure [dbo].[dt_adduserobject]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Add an object to the dtproperties table
*/
CREATE procedure [dbo].[dt_adduserobject]
as
	set nocount on
	/*
	** Create the user object if it does not exist already
	*/
	begin transaction
		insert dbo.dtproperties (property) VALUES ('DtgSchemaOBJECT')
		update dbo.dtproperties set objectid=@@identity 
			where id=@@identity and property='DtgSchemaOBJECT'
	commit
	return @@identity
GO
/****** Object:  StoredProcedure [dbo].[dt_adduserobject_vcs]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[dt_adduserobject_vcs]
    @vchProperty varchar(64)

as

set nocount on

declare @iReturn int
    /*
    ** Create the user object if it does not exist already
    */
    begin transaction
        select @iReturn = objectid from dbo.dtproperties where property = @vchProperty
        if @iReturn IS NULL
        begin
            insert dbo.dtproperties (property) VALUES (@vchProperty)
            update dbo.dtproperties set objectid=@@identity
                    where id=@@identity and property=@vchProperty
            select @iReturn = @@identity
        end
    commit
    return @iReturn
GO
/****** Object:  StoredProcedure [dbo].[dt_checkinobject]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_checkinobject]
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255)='',
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)='',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     Text = '', /* drop stream   */ /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     Text = '', /* create stream */
    @txStream3     Text = ''  /* grant stream  */


as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0
	declare @iStreamObjectId int

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iPropertyObjectId int
	select @iPropertyObjectId  = 0

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    declare @iReturnValue	  int
    declare @pos			  int
    declare @vchProcLinePiece varchar(255)

    
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        if @iActionFlag = 1
        begin
            /* Procedure Can have up to three streams
            Drop Stream, Create Stream, GRANT stream */

            begin tran compile_all

            /* try to compile the streams */
            exec (@txStream1)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream2)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream3)
            if @@error <> 0 GOTO E_Compile_Fail
        end

        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT
        if @iReturn <> 0 GOTO E_OAError
        
        if @iActionFlag = 1
        begin
            
            declare @iStreamLength int
			
			select @pos=1
			select @iStreamLength = datalength(@txStream2)
			
			if @iStreamLength > 0
			begin
			
				while @pos < @iStreamLength
				begin
						
					select @vchProcLinePiece = substring(@txStream2, @pos, 255)
					
					exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'AddStream', @iReturnValue OUT, @vchProcLinePiece
            		if @iReturn <> 0 GOTO E_OAError
            		
					select @pos = @pos + 255
					
				end
            
				exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
														'CheckIn_StoredProcedure',
														NULL,
														@sProjectName = @vchProjectName,
														@sSourceSafeINI = @vchSourceSafeINI,
														@sServerName = @vchServerName,
														@sDatabaseName = @vchDatabaseName,
														@sObjectName = @vchObjectName,
														@sComment = @vchComment,
														@sLoginName = @vchLoginName,
														@sPassword = @vchPassword,
														@iVCSFlags = @iVCSFlags,
														@iActionFlag = @iActionFlag,
														@sStream = ''
                                        
			end
        end
        else
        begin
        
            select colid, text into #ProcLines
            from syscomments
            where id = object_id(@vchObjectName)
            order by colid

            declare @iCurProcLine int
            declare @iProcLines int
            select @iCurProcLine = 1
            select @iProcLines = (select count(*) from #ProcLines)
            while @iCurProcLine <= @iProcLines
            begin
                select @pos = 1
                declare @iCurLineSize int
                select @iCurLineSize = len((select text from #ProcLines where colid = @iCurProcLine))
                while @pos <= @iCurLineSize
                begin                
                    select @vchProcLinePiece = convert(varchar(255),
                        substring((select text from #ProcLines where colid = @iCurProcLine),
                                  @pos, 255 ))
                    exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'AddStream', @iReturnValue OUT, @vchProcLinePiece
                    if @iReturn <> 0 GOTO E_OAError
                    select @pos = @pos + 255                  
                end
                select @iCurProcLine = @iCurProcLine + 1
            end
            drop table #ProcLines

            exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
													'CheckIn_StoredProcedure',
													NULL,
													@sProjectName = @vchProjectName,
													@sSourceSafeINI = @vchSourceSafeINI,
													@sServerName = @vchServerName,
													@sDatabaseName = @vchDatabaseName,
													@sObjectName = @vchObjectName,
													@sComment = @vchComment,
													@sLoginName = @vchLoginName,
													@sPassword = @vchPassword,
													@iVCSFlags = @iVCSFlags,
													@iActionFlag = @iActionFlag,
													@sStream = ''
        end

        if @iReturn <> 0 GOTO E_OAError

        if @iActionFlag = 1
        begin
            commit tran compile_all
            if @@error <> 0 GOTO E_Compile_Fail
        end

    end

CleanUp:
	return

E_Compile_Fail:
	declare @lerror int
	select @lerror = @@error
	rollback tran compile_all
	RAISERROR (@lerror,16,-1)
	goto CleanUp

E_OAError:
	if @iActionFlag = 1 rollback tran compile_all
	exec dbo.dt_displayoaerror @iObjectId, @iReturn
	goto CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_checkinobject_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_checkinobject_u]
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255)='',
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)='',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     text = '',  /* drop stream   */ /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     text = '',  /* create stream */
    @txStream3     text = ''   /* grant stream  */

as	
	-- This procedure should no longer be called;  dt_checkinobject should be called instead.
	-- Calls are forwarded to dt_checkinobject to maintain backward compatibility.
	set nocount on
	exec dbo.dt_checkinobject
		@chObjectType,
		@vchObjectName,
		@vchComment,
		@vchLoginName,
		@vchPassword,
		@iVCSFlags,
		@iActionFlag,   
		@txStream1,		
		@txStream2,		
		@txStream3
GO
/****** Object:  StoredProcedure [dbo].[dt_checkoutobject]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_checkoutobject]
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255),
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId =0

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @vchTempText varchar(255)

	/* this is for our strings */
	declare @iStreamObjectId int
	select @iStreamObjectId = 0

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        /* Procedure Can have up to three streams
           Drop Stream, Create Stream, GRANT stream */

        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'CheckOut_StoredProcedure',
												NULL,
												@sProjectName = @vchProjectName,
												@sSourceSafeINI = @vchSourceSafeINI,
												@sObjectName = @vchObjectName,
												@sServerName = @vchServerName,
												@sDatabaseName = @vchDatabaseName,
												@sComment = @vchComment,
												@sLoginName = @vchLoginName,
												@sPassword = @vchPassword,
												@iVCSFlags = @iVCSFlags,
												@iActionFlag = @iActionFlag

        if @iReturn <> 0 GOTO E_OAError


        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #commenttext (id int identity, sourcecode varchar(255))


        select @vchTempText = 'STUB'
        while @vchTempText is not null
        begin
            exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError
            
            if (@vchTempText = '') set @vchTempText = null
            if (@vchTempText is not null) insert into #commenttext (sourcecode) select @vchTempText
        end

        select 'VCS'=sourcecode from #commenttext order by id
        select 'SQL'=text from syscomments where id = object_id(@vchObjectName) order by colid

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_checkoutobject_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_checkoutobject_u]
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255),
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

	-- This procedure should no longer be called;  dt_checkoutobject should be called instead.
	-- Calls are forwarded to dt_checkoutobject to maintain backward compatibility.
	set nocount on
	exec dbo.dt_checkoutobject
		@chObjectType,  
		@vchObjectName, 
		@vchComment,    
		@vchLoginName,  
		@vchPassword,  
		@iVCSFlags,    
		@iActionFlag
GO
/****** Object:  StoredProcedure [dbo].[dt_displayoaerror]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[dt_displayoaerror]
    @iObject int,
    @iresult int
as

set nocount on

declare @vchOutput      varchar(255)
declare @hr             int
declare @vchSource      varchar(255)
declare @vchDescription varchar(255)

    exec @hr = master.dbo.sp_OAGetErrorInfo @iObject, @vchSource OUT, @vchDescription OUT

    select @vchOutput = @vchSource + ': ' + @vchDescription
    raiserror (@vchOutput,16,-1)

    return
GO
/****** Object:  StoredProcedure [dbo].[dt_displayoaerror_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[dt_displayoaerror_u]
    @iObject int,
    @iresult int
as
	-- This procedure should no longer be called;  dt_displayoaerror should be called instead.
	-- Calls are forwarded to dt_displayoaerror to maintain backward compatibility.
	set nocount on
	exec dbo.dt_displayoaerror
		@iObject,
		@iresult
GO
/****** Object:  StoredProcedure [dbo].[dt_droppropertiesbyid]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Drop one or all the associated properties of an object or an attribute 
**
**	dt_dropproperties objid, null or '' -- drop all properties of the object itself
**	dt_dropproperties objid, property -- drop the property
*/
CREATE procedure [dbo].[dt_droppropertiesbyid]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		delete from dbo.dtproperties where objectid=@id
	else
		delete from dbo.dtproperties 
			where objectid=@id and property=@property
GO
/****** Object:  StoredProcedure [dbo].[dt_dropuserobjectbyid]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Drop an object from the dbo.dtproperties table
*/
CREATE procedure [dbo].[dt_dropuserobjectbyid]
	@id int
as
	set nocount on
	delete from dbo.dtproperties where objectid=@id
GO
/****** Object:  StoredProcedure [dbo].[dt_generateansiname]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* 
**	Generate an ansi name that is unique in the dtproperties.value column 
*/ 
CREATE procedure [dbo].[dt_generateansiname](@name varchar(255) output) 
as 
	declare @prologue varchar(20) 
	declare @indexstring varchar(20) 
	declare @index integer 
 
	set @prologue = 'MSDT-A-' 
	set @index = 1 
 
	while 1 = 1 
	begin 
		set @indexstring = cast(@index as varchar(20)) 
		set @name = @prologue + @indexstring 
		if not exists (select value from dtproperties where value = @name) 
			break 
		 
		set @index = @index + 1 
 
		if (@index = 10000) 
			goto TooMany 
	end 
 
Leave: 
 
	return 
 
TooMany: 
 
	set @name = 'DIAGRAM' 
	goto Leave
GO
/****** Object:  StoredProcedure [dbo].[dt_getobjwithprop]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Retrieve the owner object(s) of a given property
*/
CREATE procedure [dbo].[dt_getobjwithprop]
	@property varchar(30),
	@value varchar(255)
as
	set nocount on

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@value is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and value=@value
GO
/****** Object:  StoredProcedure [dbo].[dt_getobjwithprop_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Retrieve the owner object(s) of a given property
*/
CREATE procedure [dbo].[dt_getobjwithprop_u]
	@property varchar(30),
	@uvalue nvarchar(255)
as
	set nocount on

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@uvalue is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and uvalue=@uvalue
GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
CREATE procedure [dbo].[dt_getpropertiesbyid]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property
GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
CREATE procedure [dbo].[dt_getpropertiesbyid_u]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property
GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_vcs]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[dt_getpropertiesbyid_vcs]
    @id       int,
    @property varchar(64),
    @value    varchar(255) = NULL OUT

as

    set nocount on

    select @value = (
        select value
                from dbo.dtproperties
                where @id=objectid and @property=property
                )
GO
/****** Object:  StoredProcedure [dbo].[dt_getpropertiesbyid_vcs_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[dt_getpropertiesbyid_vcs_u]
    @id       int,
    @property varchar(64),
    @value    nvarchar(255) = NULL OUT

as

    -- This procedure should no longer be called;  dt_getpropertiesbyid_vcsshould be called instead.
	-- Calls are forwarded to dt_getpropertiesbyid_vcs to maintain backward compatibility.
	set nocount on
    exec dbo.dt_getpropertiesbyid_vcs
		@id,
		@property,
		@value output
GO
/****** Object:  StoredProcedure [dbo].[dt_isundersourcecontrol]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_isundersourcecontrol]
    @vchLoginName varchar(255) = '',
    @vchPassword  varchar(255) = '',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0

	declare @VSSGUID varchar(100)
	select @VSSGUID = 'SQLVersionControl.VCS_SQL'

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @iStreamObjectId int
	select @iStreamObjectId   = 0

	declare @vchTempText varchar(255)

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if (@vchProjectName = '')	set @vchProjectName		= null
    if (@vchSourceSafeINI = '') set @vchSourceSafeINI	= null
    if (@vchServerName = '')	set @vchServerName		= null
    if (@vchDatabaseName = '')	set @vchDatabaseName	= null
    
    if (@vchProjectName is null) or (@vchSourceSafeINI is null) or (@vchServerName is null) or (@vchDatabaseName is null)
    begin
        RAISERROR('Not Under Source Control',16,-1)
        return
    end

    if @iWhoToo = 1
    begin

        /* Get List of Procs in the project */
        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'GetListOfObjects',
												NULL,
												@vchProjectName,
												@vchSourceSafeINI,
												@vchServerName,
												@vchDatabaseName,
												@vchLoginName,
												@vchPassword

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #ObjectList (id int identity, vchObjectlist varchar(255))

        select @vchTempText = 'STUB'
        while @vchTempText is not null
        begin
            exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, 'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError
            
            if (@vchTempText = '') set @vchTempText = null
            if (@vchTempText is not null) insert into #ObjectList (vchObjectlist ) select @vchTempText
        end

        select vchObjectlist from #ObjectList order by id
    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_isundersourcecontrol_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_isundersourcecontrol_u]
    @vchLoginName nvarchar(255) = '',
    @vchPassword  nvarchar(255) = '',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as
	-- This procedure should no longer be called;  dt_isundersourcecontrol should be called instead.
	-- Calls are forwarded to dt_isundersourcecontrol to maintain backward compatibility.
	set nocount on
	exec dbo.dt_isundersourcecontrol
		@vchLoginName,
		@vchPassword,
		@iWhoToo
GO
/****** Object:  StoredProcedure [dbo].[dt_removefromsourcecontrol]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[dt_removefromsourcecontrol]

as

    set nocount on

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    exec dbo.dt_droppropertiesbyid @iPropertyObjectId, null

    /* -1 is returned by dt_droppopertiesbyid */
    if @@error <> 0 and @@error <> -1 return 1

    return 0
GO
/****** Object:  StoredProcedure [dbo].[dt_setpropertybyid]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		value -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
CREATE procedure [dbo].[dt_setpropertybyid]
	@id int,
	@property varchar(64),
	@value varchar(255),
	@lvalue image
as
	set nocount on
	declare @uvalue nvarchar(255) 
	set @uvalue = convert(nvarchar(255), @value) 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@value, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @value, @uvalue, @lvalue)
	end
GO
/****** Object:  StoredProcedure [dbo].[dt_setpropertybyid_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		uvalue -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
CREATE procedure [dbo].[dt_setpropertybyid_u]
	@id int,
	@property varchar(64),
	@uvalue nvarchar(255),
	@lvalue image
as
	set nocount on
	-- 
	-- If we are writing the name property, find the ansi equivalent. 
	-- If there is no lossless translation, generate an ansi name. 
	-- 
	declare @avalue varchar(255) 
	set @avalue = null 
	if (@uvalue is not null) 
	begin 
		if (convert(nvarchar(255), convert(varchar(255), @uvalue)) = @uvalue) 
		begin 
			set @avalue = convert(varchar(255), @uvalue) 
		end 
		else 
		begin 
			if 'DtgSchemaNAME' = @property 
			begin 
				exec dbo.dt_generateansiname @avalue output 
			end 
		end 
	end 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@avalue, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @avalue, @uvalue, @lvalue)
	end
GO
/****** Object:  StoredProcedure [dbo].[dt_validateloginparams]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_validateloginparams]
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)
as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchSourceSafeINI varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT

    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError

    exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
											'ValidateLoginParams',
											NULL,
											@sSourceSafeINI = @vchSourceSafeINI,
											@sLoginName = @vchLoginName,
											@sPassword = @vchPassword
    if @iReturn <> 0 GOTO E_OAError

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_validateloginparams_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_validateloginparams_u]
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)
as

	-- This procedure should no longer be called;  dt_validateloginparams should be called instead.
	-- Calls are forwarded to dt_validateloginparams to maintain backward compatibility.
	set nocount on
	exec dbo.dt_validateloginparams
		@vchLoginName,
		@vchPassword
GO
/****** Object:  StoredProcedure [dbo].[dt_vcsenabled]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_vcsenabled]

as

set nocount on

declare @iObjectId int
select @iObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iReturn int
    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 raiserror('', 16, -1) /* Can't Load Helper DLLC */
GO
/****** Object:  StoredProcedure [dbo].[dt_verstamp006]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	This procedure returns the version number of the stored
**    procedures used by legacy versions of the Microsoft
**	Visual Database Tools.  Version is 7.0.00.
*/
CREATE procedure [dbo].[dt_verstamp006]
as
	select 7000
GO
/****** Object:  StoredProcedure [dbo].[dt_verstamp007]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
**	This procedure returns the version number of the stored
**    procedures used by the the Microsoft Visual Database Tools.
**	Version is 7.0.05.
*/
CREATE procedure [dbo].[dt_verstamp007]
as
	select 7005
GO
/****** Object:  StoredProcedure [dbo].[dt_whocheckedout]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_whocheckedout]
        @chObjectType  char(4),
        @vchObjectName varchar(255),
        @vchLoginName  varchar(255),
        @vchPassword   varchar(255)

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        declare @vchReturnValue varchar(255)
        select @vchReturnValue = ''

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												'WhoCheckedOut',
												@vchReturnValue OUT,
												@sProjectName = @vchProjectName,
												@sSourceSafeINI = @vchSourceSafeINI,
												@sObjectName = @vchObjectName,
												@sServerName = @vchServerName,
												@sDatabaseName = @vchDatabaseName,
												@sLoginName = @vchLoginName,
												@sPassword = @vchPassword

        if @iReturn <> 0 GOTO E_OAError

        select @vchReturnValue

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp
GO
/****** Object:  StoredProcedure [dbo].[dt_whocheckedout_u]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[dt_whocheckedout_u]
        @chObjectType  char(4),
        @vchObjectName nvarchar(255),
        @vchLoginName  nvarchar(255),
        @vchPassword   nvarchar(255)

as

	-- This procedure should no longer be called;  dt_whocheckedout should be called instead.
	-- Calls are forwarded to dt_whocheckedout to maintain backward compatibility.
	set nocount on
	exec dbo.dt_whocheckedout
		@chObjectType, 
		@vchObjectName,
		@vchLoginName, 
		@vchPassword
GO
/****** Object:  StoredProcedure [dbo].[세금계산서이관_센터]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[세금계산서이관_센터]

  @Date_SettleStart CHAR(10)        -- '2018-07-01'
  ,@Date_SettleEnd CHAR(10)         -- '2018-08-01'
  ,@BranchCode    TINYINT           -- 83:경북, 25:경남

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  BEGIN TRAN
    --==================================================================
    -- TaxSheet에 인서트하기~~
    --==================================================================
	  INSERT INTO dbo.TaxSheet
	    ( BranchCode, TaxSheetNo, BoxLineF, Serial, TaxCheckDate, IssueDate, CustCode, CustName,
	      TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount,
	      TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId,
	      SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ )
	  SELECT
	  ---------------------
		  @BranchCode AS BranchCode,
		  RTRIM(LTRIM(SubString(TL.TAXSENDBILLNO,5,10))) AS TaxSheetNo,
		  3 AS BoxLineF,
		  1 AS Serial,
      REPLACE(CONVERT(VARCHAR(10),T.TaxCheckDate, 120),'-','') AS TaxCheckDate,
		  Replace(convert(varchar(10),T.SettleDate, 120),'-','') AS IssueDate,
		  U.IDX AS CustCode,
		  RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.SHOPNM, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))) AS CustName,
		  RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.SHOPNM, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))) AS TaxCustName,
		  dbo.fn_mwseedencode(RTRIM(CONVERT(varchar(14),RTRIM(LTRIM(TL.BUSINESSNO))))) AS ResidentNo,
		  RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(TL.ONESNAME)))) AS President,
		  RTRIM(CONVERT(varchar(20),RTRIM(LTRIM(TL.SHOPTYPE)))) AS [Type],
		  RTRIM(CONVERT(varchar(20),RTRIM(LTRIM(TL.SHOPPART)))) AS [Item],
		  RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ADDRESS, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))) AS [Address],
		  CAST(ROUND(TL.PRICE/1.1,0) AS INT) AS SupplyAmount,     -- TaxAtion
		  CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) AS TaxAmount,   -- TaxVat
		  TL.PRICE AS AskAmount,
		  '' AS AccTaxID,
		  NULL AS SysAccDate,
		  0 AS DestroyF,
		  '' AS Content,
		  T.GrpSerial AS BoxAdId,
		  GETDATE() AS SysDate,
		  0 AS ContractF,
		  @BranchCode AS InputBranch,
		  Replace(convert(varchar(10),T.SettleDate, 120),'-','') AS MakeDate,
		  1 AS EtaxF,
		  '' AS DestroyRemark,
		  TL.TAXSENDBILLNO AS BILLSEQ
    FROM FINDDB1.PaperReg.dbo.Taxrequest	T
	    JOIN FINDDB1.PaperReg.dbo.TaxUser	U ON U.UserID=T.UserID
      JOIN FINDDB1.PaperReg.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx 
	  WHERE T.TaxSndBillNo1 IS NOT NULL
	    AND		T.TransFlag in ('NC', 'UC')
	    AND		T.SettleDate >= @Date_SettleStart and		T.SettleDate < @Date_SettleEnd
      AND   TL.REG_DT >= @Date_SettleStart AND TL.REG_DT < @Date_SettleEnd
	    AND		T.TaxSheet_TransFlag IS NULL
	    AND 	T.BranchCode = @BranchCode
        AND ISNULL(TL.FLAG,'') NOT IN ('D')

		--SELECT TOP 10 * FROM FINDDB1.PaperReg.dbo.TAXISSUE_LOG 

    --=================================
    -- 신규 마감후 수정계산서 추가 마감
    --=================================
    INSERT INTO dbo.TaxSheet
	    (BranchCode, TaxSheetNo, BoxLineF, Serial, TaxCheckDate, IssueDate, CustCode, CustName
        , TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount
        , TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId
        , SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ)
	  SELECT
		  @BranchCode AS BranchCode,
		  RTRIM(LTRIM(SubString(TL.TAXSENDBILLNO,5,10))) AS TaxSheetNo,
		  3 AS BoxLineF,
		  1 AS Serial,
      REPLACE(CONVERT(VARCHAR(10),T.TaxCheckDate, 120),'-','') AS TaxCheckDate,
		  REPLACE(CONVERT(VARCHAR(10),BT.DT, 120),'-','') AS IssueDate,
		  U.IDX AS CustCode,
		  RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.SHOPNM, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))) AS CustName,
		  RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.SHOPNM, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))) AS TaxCustName,
		  dbo.fn_mwseedencode(RTRIM(CONVERT(varchar(14),RTRIM(LTRIM(TL.BUSINESSNO))))) AS ResidentNo,
		  RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(TL.ONESNAME)))) AS President,
		  RTRIM(CONVERT(varchar(20),RTRIM(LTRIM(TL.SHOPTYPE)))) AS [Type],
		  RTRIM(CONVERT(varchar(20),RTRIM(LTRIM(TL.SHOPPART)))) AS [Item],
		  RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ADDRESS, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))) AS [Address],
		  CAST(ROUND(TL.PRICE/1.1,0) AS INT) AS SupplyAmount,     -- TaxAtion
		  CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) AS TaxAmount,   -- TaxVat
		  TL.PRICE AS AskAmount,
		  '' AS AccTaxID,
		  NULL AS SysAccDate,
		  0 AS DestroyF,
		  '' AS Content,
		  T.GrpSerial AS BoxAdId,
		  GETDATE() AS SysDate,
		  0 AS ContractF,
		  @BranchCode AS InputBranch,
		  REPLACE(CONVERT(VARCHAR(10),BT.DT, 120),'-','') AS MakeDate,
		  1 AS EtaxF,
		  '' AS DestroyRemark,
		  TL.TAXSENDBILLNO AS BILLSEQ
	   FROM FINDDB1.PaperReg.dbo.TAXISSUE_LOG AS TL
     JOIN FINDDB1.PaperReg.dbo.TaxRequest AS T ON T.Idx = TL.TAXREQUESTKEY
	   JOIN FINDDB1.PaperReg.dbo.TaxUser AS U ON U.UserID=T.UserID
     JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS BT ON BT.BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS
	  WHERE T.TaxSndBillNo1 IS NOT NULL
	    AND	T.TransFlag in ('NC', 'UC')
	    AND T.BranchCode = @BranchCode
      AND	TL.REG_DT >= @Date_SettleStart
      AND ISNULL(TL.FLAG,'') NOT IN ('D')
      AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)
      AND	BT.DT >= @Date_SettleStart AND	BT.DT < @Date_SettleEnd

  --==================================================================
  -- 삭제처리된 계산서건 추출
  --==================================================================
 -- 회계이관 자료에서 삭제
  DELETE
  --SELECT *
  FROM dbo.TaxSheet
  WHERE BILLSEQ IN (SELECT A.BILLSEQ
                       From dbo.TaxSheet AS A
                       LEFT JOIN [116.120.56.64].ACCDB1.dbo.BILL_STAT AS B ON B.BILLSEQ = A.BILLSEQ --COLLATE Korean_Wansung_CI_AS
                      WHERE A.BranchCode = @BranchCode
                        AND A.SysDate >= CONVERT(CHAR(10),getdate(),120)
                        AND (B.BILLSTAT = 6 OR B.BILLSEQ IS NULL)    -- 삭제/샌드빌 미전송 된 계산서
                        )

  COMMIT TRAN

  --==================================================================
  -- FINDDB1.PaperReg.dbo.Taxrequest 테이블에 이관여부 Update하기
  --==================================================================
	  UPDATE 	A
	     SET 	A.TaxSheet_TransFlag = 'Y'
          , A.TaxSheet_TransDate = CAST(GETDATE() AS smalldatetime)
      --SELECT COUNT(*)
      FROM 	FINDDB1.PaperReg.dbo.Taxrequest AS A
      JOIN  dbo.TaxSheet AS B ON B.BILLSEQ = A.TaxSndBillNo1 COLLATE Korean_Wansung_CI_AS
    WHERE B.SysDate >= CONVERT(CHAR(10),getdate(),120)
      AND B.BranchCode = @BranchCode

  --==================================================================
  -- 자료 출력 (엑셀로 전달)
  --==================================================================
  SELECT BranchCode,TaxSheetNo,BoxLineF,Serial,IssueDate,CustCode,CustName,TaxCustName,dbo.fn_mwseeddecode(ResidentNo) AS ResidentNo,President,Type,Item,Address,CAST(SupplyAmount AS INT) AS SupplyAmount,CAST(TaxAmount AS INT) AS TaxAmount,CAST(AskAmount AS INT) AS AskAmount,AccTaxID,SysAccDate,DestroyF,Content,BoxAdId,SysDate,ContractF,InputBranch,MakeDate,EtaxF,DestroyRemark,BILLSEQ
    FROM dbo.TaxSheet 
   WHERE SysDate >= CONVERT(CHAR(10),getdate(),120)
     AND BranchCode = @BranchCode 

GO
/****** Object:  StoredProcedure [dbo].[세금계산서이관_이컴]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[세금계산서이관_이컴]

  @Date_SettleStart CHAR(10)        -- '2018-07-01'
  ,@Date_SettleEnd CHAR(10)         -- '2018-08-01'

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  BEGIN TRAN
  --==================================================================
  -- TAXSHEET에 인서트하기
  --==================================================================
  INSERT INTO dbo.TaxSheet
	  (BranchCode, TaxSheetNo, BoxLineF, Serial, TaxCheckDate, IssueDate, CustCode, CustName
      , TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount
      , TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId
      , SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ)
	SELECT
		---------------------
		BRANCHCODE		= 97,
		---------------------
		TAXSHEETNO		= RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,5,10))),
		BOXLINEF		= 3,
		SERIAL			= 1,
		TaxCheckDate = REPLACE(CONVERT(VARCHAR(10),T.TaxCheckDate, 120),'-',''),
		ISSUEDATE		= REPLACE(CONVERT(VARCHAR(10),T.SettleDate, 120),'-',''),
		CUSTCODE		= U.IDX,
		CUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		TAXCUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		RESIDENTNO		= dbo.fn_mwseedencode(RTRIM(CONVERT(VARCHAR(14),RTRIM(LTRIM(TL.BusinessNO))))),
		PRESIDENT		= RTRIM(CONVERT(VARCHAR(30),RTRIM(LTRIM(TL.OnesName)))),
		TYPE			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopType)))),
		ITEM			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopPart)))),
		Address			= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.Address, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		SUPPLYAMOUNT	= CAST(ROUND(TL.PRICE/1.1,0) AS INT),
		TAXAMOUNT		= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,
		ASKAMOUNT		= TL.PRICE,
		ACCTAXID		= '',
		SYSACCDATE		= NULL,
		DESTROYF		= 0,
		CONTENT			= '',
		BOXADID			= T.GrpSerial,
		SYSDATE			= GETDATE(),
		CONTRACTF		= 0,
		---------------------
		INPUTBRANCH		= 97,
		---------------------
		MAKEDATE		= REPLACE(CONVERT(VARCHAR(10),T.SettleDate, 120),'-',''),
		ETAXF			= 1,
		DESTROYREMARK		= '',
		BILLSEQ = TL.TAXSENDBILLNO
	 FROM FINDCOMMON.dbo.TaxRequest	T
	 JOIN FINDCOMMON.dbo.TaxUser U ON U.CUID=T.CUID
   JOIN FINDCOMMON.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
	WHERE TaxSndBillNo1 IS NOT NULL
	  AND	TransFlag IN ('NC', 'UC')
    AND	T.SettleDate >= @Date_SettleStart AND	T.SettleDate < @Date_SettleEnd
    AND TL.REG_DT >= @Date_SettleStart AND TL.REG_DT < @Date_SettleEnd
    AND U.UserID <> 'NoMember' -- 비회원 제외
	AND ISNULL(TL.FLAG,'') NOT IN ('D')
    AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)


--=================================
-- 신규 마감후 수정계산서 추가 마감
--=================================
/*
    SELECT BILLSEQ,DT 
    into #tmp  
    from     [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS BT
    WHERE BILLSEQ in (SELECT TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS  AS TAXSENDBILLNO froM FINDCOMMON.dbo.TAXISSUE_LOG)
    */

  INSERT INTO dbo.TaxSheet
	  (BranchCode, TaxSheetNo, BoxLineF, Serial, TaxCheckDate, IssueDate, CustCode, CustName
      , TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount
      , TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId
      , SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ)
	SELECT
		---------------------
		BRANCHCODE		= 97,
		---------------------
		TAXSHEETNO		= RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,5,10))),
		BOXLINEF		= 3,
		SERIAL			= 1,
		TaxCheckDate = REPLACE(CONVERT(VARCHAR(10),T.TaxCheckDate, 120),'-',''),
		ISSUEDATE		= REPLACE(CONVERT(VARCHAR(10),BT.DT, 120),'-',''),
		CUSTCODE		= U.IDX,
		CUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		TAXCUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		RESIDENTNO		= dbo.fn_mwseedencode(RTRIM(CONVERT(VARCHAR(14),RTRIM(LTRIM(TL.BusinessNO))))),
		PRESIDENT		= RTRIM(CONVERT(VARCHAR(30),RTRIM(LTRIM(TL.OnesName)))),
		TYPE			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopType)))),
		ITEM			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopPart)))),
		Address			= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.Address, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		SUPPLYAMOUNT	= CAST(ROUND(TL.PRICE/1.1,0) AS INT),
		TAXAMOUNT		= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,
		ASKAMOUNT		= TL.PRICE,
		ACCTAXID		= '',
		SYSACCDATE		= NULL,
		DESTROYF		= 0,
		CONTENT			= '',
		BOXADID			= T.GrpSerial,
		SYSDATE			= GETDATE(),
		CONTRACTF		= 0,
		---------------------
		INPUTBRANCH		= 97,
		---------------------
		MAKEDATE		= REPLACE(CONVERT(VARCHAR(10),BT.DT, 120),'-',''),  --REPLACE(CONVERT(VARCHAR(10),T.SettleDate, 120),'-',''),
		ETAXF			= 1,
		DESTROYREMARK		= '',
		BILLSEQ = TL.TAXSENDBILLNO
	 FROM FINDCOMMON.dbo.TAXISSUE_LOG AS TL
   JOIN FINDCOMMON.dbo.TaxRequest AS T ON T.Idx = TL.TAXREQUESTKEY
	 JOIN FINDCOMMON.dbo.TaxUser AS U ON U.CUID=T.CUID
   JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS BT ON BT.BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS
   --JOIN#tmp AS BT ON BT.BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS
	WHERE TaxSndBillNo1 IS NOT NULL
	  AND	TransFlag IN ('NC', 'UC')
    AND U.UserID <> 'NoMember' -- 비회원 제외
    AND	TL.REG_DT >= @Date_SettleStart
    AND ISNULL(TL.FLAG,'') NOT IN ('D')
    AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)
    AND	BT.DT >= @Date_SettleStart
    AND	BT.DT < @Date_SettleEnd

  --==================================================================
  -- 삭제처리된 계산서건 추출
  --==================================================================
  -- 삭제/샌드빌 미전송 된 계산서

  -- 회계이관 자료에서 삭제
  DELETE
  --SELECT A.*
  FROM dbo.TaxSheet
  WHERE BILLSEQ IN (SELECT A.BILLSEQ
                        FROM dbo.TaxSheet AS A
                          LEFT JOIN [116.120.56.64].ACCDB1.dbo.BILL_STAT AS B ON B.BILLSEQ = A.BILLSEQ --COLLATE Korean_Wansung_CI_AS
                       WHERE A.BranchCode = 97
                         AND A.SysDate >= CONVERT(CHAR(10),getdate(),120)
                         AND (B.BILLSTAT = 6 OR B.BILLSEQ IS NULL))


  COMMIT TRAN

  --==================================================================
  -- DBO.TAXREQUEST 테이블에 이관여부 UPDATE
  --==================================================================
	UPDATE 	A
	   SET 	A.TaxSheet_TransFlag = 'Y'
        , A.TaxSheet_TransDate = CAST(GETDATE() AS smalldatetime)
    --SELECT COUNT(*)
    FROM 	FINDCOMMON.dbo.TAXREQUEST AS A
    JOIN  dbo.TaxSheet AS B ON B.BILLSEQ = A.TaxSndBillNo1 COLLATE Korean_Wansung_CI_AS
   WHERE B.BranchCode = 97 
     AND B.SysDate >= CONVERT(CHAR(10),getdate(),120)

--==================================================================
-- 자료 출력 (엑셀로 전달)
--==================================================================
SELECT BranchCode,TaxSheetNo,BoxLineF,Serial,IssueDate,CustCode,CustName,TaxCustName,dbo.fn_mwseeddecode(ResidentNo) AS ResidentNo,President,Type,Item,Address,CAST(SupplyAmount AS INT) AS SupplyAmount,CAST(TaxAmount AS INT) AS TaxAmount,CAST(AskAmount AS INT) AS AskAmount,AccTaxID,SysAccDate,DestroyF,Content,BoxAdId,SysDate,ContractF,InputBranch,MakeDate,EtaxF,DestroyRemark,BILLSEQ
 FROM dbo.TaxSheet WHERE SysDate >= CONVERT(CHAR(10),GETDATE(),120) AND BranchCode = 97




GO
/****** Object:  StoredProcedure [dbo].[세금계산서이관_이컴_20210405]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROC [dbo].[세금계산서이관_이컴_20210405]

  @Date_SettleStart CHAR(10)        -- '2018-07-01'
  ,@Date_SettleEnd CHAR(10)         -- '2018-08-01'

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  BEGIN TRAN
  --==================================================================
  -- TAXSHEET에 인서트하기
  --==================================================================
  INSERT INTO dbo.TaxSheet
	  (BranchCode, TaxSheetNo, BoxLineF, Serial, TaxCheckDate, IssueDate, CustCode, CustName
      , TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount
      , TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId
      , SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ)
	SELECT
		---------------------
		BRANCHCODE		= 97,
		---------------------
		TAXSHEETNO		= RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))),
		BOXLINEF		= 3,
		SERIAL			= 1,
		TaxCheckDate = REPLACE(CONVERT(VARCHAR(10),T.TaxCheckDate, 120),'-',''),
		ISSUEDATE		= REPLACE(CONVERT(VARCHAR(10),T.SettleDate, 120),'-',''),
		CUSTCODE		= U.IDX,
		CUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		TAXCUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		RESIDENTNO		= dbo.fn_mwseedencode(RTRIM(CONVERT(VARCHAR(14),RTRIM(LTRIM(TL.BusinessNO))))),
		PRESIDENT		= RTRIM(CONVERT(VARCHAR(30),RTRIM(LTRIM(TL.OnesName)))),
		TYPE			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopType)))),
		ITEM			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopPart)))),
		Address			= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.Address, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		SUPPLYAMOUNT	= CAST(ROUND(TL.PRICE/1.1,0) AS INT),
		TAXAMOUNT		= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,
		ASKAMOUNT		= TL.PRICE,
		ACCTAXID		= '',
		SYSACCDATE		= NULL,
		DESTROYF		= 0,
		CONTENT			= '',
		BOXADID			= T.GrpSerial,
		SYSDATE			= GETDATE(),
		CONTRACTF		= 0,
		---------------------
		INPUTBRANCH		= 97,
		---------------------
		MAKEDATE		= REPLACE(CONVERT(VARCHAR(10),T.SettleDate, 120),'-',''),
		ETAXF			= 1,
		DESTROYREMARK		= '',
		BILLSEQ = TL.TAXSENDBILLNO
	 FROM FINDCOMMON.dbo.TaxRequest	T
	 JOIN FINDCOMMON.dbo.TaxUser U ON U.CUID=T.CUID
   JOIN FINDCOMMON.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
	WHERE TaxSndBillNo1 IS NOT NULL
	  AND	TransFlag IN ('NC', 'UC')
    AND	T.SettleDate >= @Date_SettleStart AND	T.SettleDate < @Date_SettleEnd
    AND TL.REG_DT >= @Date_SettleStart AND TL.REG_DT < @Date_SettleEnd
    AND U.UserID <> 'NoMember' -- 비회원 제외
	AND ISNULL(TL.FLAG,'') NOT IN ('D')
    AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)


--=================================
-- 신규 마감후 수정계산서 추가 마감
--=================================
/*
    SELECT BILLSEQ,DT 
    into #tmp  
    from     [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS BT
    WHERE BILLSEQ in (SELECT TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS  AS TAXSENDBILLNO froM FINDCOMMON.dbo.TAXISSUE_LOG)
    */

  INSERT INTO dbo.TaxSheet
	  (BranchCode, TaxSheetNo, BoxLineF, Serial, TaxCheckDate, IssueDate, CustCode, CustName
      , TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount
      , TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId
      , SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ)
	SELECT
		---------------------
		BRANCHCODE		= 97,
		---------------------
		TAXSHEETNO		= RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))),
		BOXLINEF		= 3,
		SERIAL			= 1,
		TaxCheckDate = REPLACE(CONVERT(VARCHAR(10),T.TaxCheckDate, 120),'-',''),
		ISSUEDATE		= REPLACE(CONVERT(VARCHAR(10),BT.DT, 120),'-',''),
		CUSTCODE		= U.IDX,
		CUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		TAXCUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		RESIDENTNO		= dbo.fn_mwseedencode(RTRIM(CONVERT(VARCHAR(14),RTRIM(LTRIM(TL.BusinessNO))))),
		PRESIDENT		= RTRIM(CONVERT(VARCHAR(30),RTRIM(LTRIM(TL.OnesName)))),
		TYPE			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopType)))),
		ITEM			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopPart)))),
		Address			= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.Address, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		SUPPLYAMOUNT	= CAST(ROUND(TL.PRICE/1.1,0) AS INT),
		TAXAMOUNT		= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,
		ASKAMOUNT		= TL.PRICE,
		ACCTAXID		= '',
		SYSACCDATE		= NULL,
		DESTROYF		= 0,
		CONTENT			= '',
		BOXADID			= T.GrpSerial,
		SYSDATE			= GETDATE(),
		CONTRACTF		= 0,
		---------------------
		INPUTBRANCH		= 97,
		---------------------
		MAKEDATE		= REPLACE(CONVERT(VARCHAR(10),BT.DT, 120),'-',''),  --REPLACE(CONVERT(VARCHAR(10),T.SettleDate, 120),'-',''),
		ETAXF			= 1,
		DESTROYREMARK		= '',
		BILLSEQ = TL.TAXSENDBILLNO
	 FROM FINDCOMMON.dbo.TAXISSUE_LOG AS TL
   JOIN FINDCOMMON.dbo.TaxRequest AS T ON T.Idx = TL.TAXREQUESTKEY
	 JOIN FINDCOMMON.dbo.TaxUser AS U ON U.CUID=T.CUID
   JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS BT ON BT.BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS
   --JOIN#tmp AS BT ON BT.BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS
	WHERE TaxSndBillNo1 IS NOT NULL
	  AND	TransFlag IN ('NC', 'UC')
    AND U.UserID <> 'NoMember' -- 비회원 제외
    AND	TL.REG_DT >= @Date_SettleStart
    AND ISNULL(TL.FLAG,'') NOT IN ('D')
    AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)
    AND	BT.DT >= @Date_SettleStart
    AND	BT.DT < @Date_SettleEnd

  --==================================================================
  -- 삭제처리된 계산서건 추출
  --==================================================================
  -- 삭제/샌드빌 미전송 된 계산서

  -- 회계이관 자료에서 삭제
  DELETE
  --SELECT A.*
  FROM dbo.TaxSheet
  WHERE BILLSEQ IN (SELECT A.BILLSEQ
                        FROM dbo.TaxSheet AS A
                          LEFT JOIN [116.120.56.64].ACCDB1.dbo.BILL_STAT AS B ON B.BILLSEQ = A.BILLSEQ --COLLATE Korean_Wansung_CI_AS
                       WHERE A.BranchCode = 97
                         AND A.SysDate >= CONVERT(CHAR(10),getdate(),120)
                         AND (B.BILLSTAT = 6 OR B.BILLSEQ IS NULL))


  COMMIT TRAN

  --==================================================================
  -- DBO.TAXREQUEST 테이블에 이관여부 UPDATE
  --==================================================================
	UPDATE 	A
	   SET 	A.TaxSheet_TransFlag = 'Y'
        , A.TaxSheet_TransDate = CAST(GETDATE() AS smalldatetime)
    --SELECT COUNT(*)
    FROM 	FINDCOMMON.dbo.TAXREQUEST AS A
    JOIN  dbo.TaxSheet AS B ON B.BILLSEQ = A.TaxSndBillNo1 COLLATE Korean_Wansung_CI_AS
   WHERE B.BranchCode = 97 
     AND B.SysDate >= CONVERT(CHAR(10),getdate(),120)

--==================================================================
-- 자료 출력 (엑셀로 전달)
--==================================================================
SELECT BranchCode,TaxSheetNo,BoxLineF,Serial,IssueDate,CustCode,CustName,TaxCustName,dbo.fn_mwseeddecode(ResidentNo) AS ResidentNo,President,Type,Item,Address,CAST(SupplyAmount AS INT) AS SupplyAmount,CAST(TaxAmount AS INT) AS TaxAmount,CAST(AskAmount AS INT) AS AskAmount,AccTaxID,SysAccDate,DestroyF,Content,BoxAdId,SysDate,ContractF,InputBranch,MakeDate,EtaxF,DestroyRemark,BILLSEQ
 FROM dbo.TaxSheet WHERE SysDate >= CONVERT(CHAR(10),GETDATE(),120) AND BranchCode = 97




GO
/****** Object:  StoredProcedure [dbo].[세금계산서이관_분기]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[세금계산서이관_분기]

  @QUARTER TINYINT
  ,@BRANCHCODE TINYINT    -- 97:이컴, 90:서울IC, 83:대구, 25:부산

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  BEGIN TRAN

/**************** IC센터 수정발행 계산서 회계이관 ****************/
DECLARE @Date_SettleStart char(10) 
DECLARE @Date_SettleEnd  char(10)

-- 분기별 기간
IF @QUARTER = 1
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-01-01'
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-04-01'
  END
ELSE IF @QUARTER = 2
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-04-01'
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-07-01'
  END
ELSE IF @QUARTER = 3
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-07-01'
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-10-01'
  END
ELSE IF @QUARTER = 4
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE())-1 AS CHAR(4)) + '-10-01'     -- 4분기는 다음해 초에 요청함으로 시작일은 작년도 10월부터
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-01-01'
  END

IF @BRANCHCODE = 97

  BEGIN
    /****************  파인드올(본부) 수정발행 계산서 회계이관 ****************/
    INSERT INTO dbo.TaxSheet
	  (BranchCode, TaxSheetNo, BoxLineF, Serial, IssueDate, CustCode, CustName
      , TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount
      , TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId
      , SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ)

	  SELECT
		  BRANCHCODE		= @BRANCHCODE,
		  TAXSHEETNO		= RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,5,10))),
		  BOXLINEF		= 3,
		  SERIAL			= 1,
		  ISSUEDATE		= REPLACE(CONVERT(VARCHAR(10),S.DT, 120),'-',''),
		  CUSTCODE		= U.IDX,
		  CUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  TAXCUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  RESIDENTNO		= dbo.fn_mwseedencode(RTRIM(CONVERT(VARCHAR(14),RTRIM(LTRIM(TL.BusinessNO))))),
		  PRESIDENT		= RTRIM(CONVERT(VARCHAR(30),RTRIM(LTRIM(TL.OnesName)))),
		  TYPE			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopType)))),
		  ITEM			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopPart)))),
		  Address			= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.Address, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  SUPPLYAMOUNT	= CAST(ROUND(TL.PRICE/1.1,0) AS INT),
		  TAXAMOUNT		= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,
		  ASKAMOUNT		= TL.PRICE,
		  ACCTAXID		= '',
		  SYSACCDATE		= NULL,
		  DESTROYF		= 0,
		  CONTENT			= '',
		  BOXADID			= T.GrpSerial,
		  SYSDATE			= GETDATE(),
		  CONTRACTF		= 0,
		  INPUTBRANCH		= @BRANCHCODE,
		  MakeDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  ETAXF			= 1,
		  DESTROYREMARK		= '',
		  BILLSEQ = TL.TAXSENDBILLNO
	    FROM 	FINDCOMMON.dbo.TaxRequest	T
	      JOIN FINDCOMMON.dbo.TaxUser U ON U.UserID=T.UserID
        JOIN FINDCOMMON.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
        JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS S ON S.BILLSEQ=TL.TAXSENDBILLNO COLLATE Korean_Wansung_BIN
	  WHERE 	TaxSndBillNo1 IS NOT NULL
	    AND	TransFlag IN ('NC', 'UC')
      AND	S.DT >= @Date_SettleStart
      AND	S.DT < @Date_SettleEnd
      AND (S.REPORT_AMEND_CD IS NOT NULL AND S.REPORT_AMEND_CD <> '')
      -- AND NOT EXISTS(SELECT * FROM dbo.TaxSheet WHERE TaxSheetNo = RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))) AND BranchCode = @BRANCHCODE)
	  AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)  -- 추가 2020-10-20
	  AND ISNULL(TL.FLAG,'') NOT IN ('D')

    UNION ALL

	  SELECT
		  BRANCHCODE		= @BRANCHCODE,
		  TAXSHEETNO		= RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,5,10))),
		  BOXLINEF		= 3,
		  SERIAL			= 1,
		  ISSUEDATE		= REPLACE(CONVERT(VARCHAR(10),S.DT, 120),'-',''),
		  CUSTCODE		= U.IDX,
		  CUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  TAXCUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  RESIDENTNO		= dbo.fn_mwseedencode(RTRIM(CONVERT(VARCHAR(14),RTRIM(LTRIM(TL.BusinessNO))))),
		  PRESIDENT		= RTRIM(CONVERT(VARCHAR(30),RTRIM(LTRIM(TL.OnesName)))),
		  TYPE			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopType)))),
		  ITEM			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopPart)))),
		  Address			= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.Address, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  SUPPLYAMOUNT	= CAST(ROUND(TL.PRICE/1.1,0) AS INT),
		  TAXAMOUNT		= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,
		  ASKAMOUNT		= TL.PRICE,
		  ACCTAXID		= '',
		  SYSACCDATE		= NULL,
		  DESTROYF		= 0,
		  CONTENT			= '',
		  BOXADID			= T.GrpSerial,
		  SYSDATE			= GETDATE(),
		  CONTRACTF		= 0,
		  INPUTBRANCH		= @BRANCHCODE,
		  MakeDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  ETAXF			= 1,
		  DESTROYREMARK		= '',
		  BILLSEQ = TL.TAXSENDBILLNO
	    FROM FINDCOMMON.dbo.TaxRequest	T
      JOIN FINDCOMMON.dbo.TaxNoMember AS U ON U.LINEADID=T.Adid     -- 비회원 발행건
      JOIN FINDCOMMON.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
      JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS S ON S.BILLSEQ=TL.TAXSENDBILLNO COLLATE Korean_Wansung_BIN
	  WHERE 	TaxSndBillNo1 IS NOT NULL
	    AND	TransFlag IN ('NC', 'UC')
      AND	S.DT >= @Date_SettleStart
      AND	S.DT < @Date_SettleEnd
      AND (S.REPORT_AMEND_CD IS NOT NULL AND S.REPORT_AMEND_CD <> '')
      -- AND NOT EXISTS(SELECT * FROM dbo.TaxSheet WHERE TaxSheetNo = RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))) AND BranchCode = @BRANCHCODE)
	  AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)  -- 추가 2020-10-20
	  AND ISNULL(TL.FLAG,'') NOT IN ('D')
  END

ELSE

  BEGIN

	  INSERT INTO dbo.TaxSheet
	    ( BranchCode, TaxSheetNo, BoxLineF, Serial, IssueDate, CustCode, CustName,
	      TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount,
	      TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId,
	      SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ )
	  SELECT
		  BranchCode			= @BRANCHCODE,
		  TaxSheetNo			= RTRIM(LTRIM(SubString(TL.TAXSENDBILLNO,5,10))),
		  BoxLineF			= 3,
		  Serial				= 1,
		  IssueDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  CustCode			= U.IDX,
		  CustName			= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.SHOPNM, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  TaxCustName			= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.SHOPNM, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  ResidentNo			= dbo.fn_mwseedencode(RTRIM(CONVERT(varchar(14),RTRIM(LTRIM(TL.BUSINESSNO))))),
		  President			= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(TL.ONESNAME)))),
		  Type				= RTRIM(CONVERT(varchar(20),RTRIM(LTRIM(TL.SHOPTYPE)))),
		  Item				= RTRIM(CONVERT(varchar(20),RTRIM(LTRIM(TL.SHOPPART)))),
		  Address				= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ADDRESS, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  SupplyAmount		= CAST(ROUND(TL.PRICE/1.1,0) AS INT),     -- TaxAtion
		  TaxAmount			= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,   -- TaxVat
		  AskAmount			= TL.PRICE,
		  AccTaxID			= '',
		  SysAccDate			= NULL,
		  DestroyF			= 0,
		  Content				= '',
		  BoxAdId				= T.GrpSerial,
		  SysDate				= GETDATE(),
		  ContractF			= 0,
		  InputBranch			= @BRANCHCODE,
		  MakeDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  EtaxF				= 1,
		  DestroyRemark		= '',
		  BILLSEQ = TL.TAXSENDBILLNO
	  FROM 	FINDDB1.PaperReg.dbo.Taxrequest	T
	    JOIN FINDDB1.PaperReg.dbo.TaxUser	U ON U.UserID=T.UserID
      JOIN FINDDB1.PaperReg.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
      JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS S ON S.BILLSEQ=TL.TAXSENDBILLNO COLLATE Korean_Wansung_BIN
	  WHERE TaxSndBillNo1 IS NOT NULL
	    AND	TransFlag in ('NC', 'UC')
	    AND BranchCode = @BRANCHCODE
      AND	S.DT >= @Date_SettleStart
      AND	S.DT < @Date_SettleEnd
      AND (S.REPORT_AMEND_CD IS NOT NULL AND S.REPORT_AMEND_CD <> '')
      -- AND NOT EXISTS(SELECT * FROM dbo.TaxSheet WHERE TaxSheetNo = RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))) AND BranchCode = @BRANCHCODE)
	  AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS) -- 추가 2020-10-20
	  AND ISNULL(TL.FLAG,'') NOT IN ('D')
  END

  COMMIT TRAN

  SELECT BranchCode,TaxSheetNo,BoxLineF,Serial,IssueDate,CustCode,CustName,TaxCustName,dbo.fn_mwseeddecode(ResidentNo) AS ResidentNo,President,Type,Item,Address,CAST(SupplyAmount AS INT) AS SupplyAmount,CAST(TaxAmount AS INT) AS TaxAmount,CAST(AskAmount AS INT) AS AskAmount,AccTaxID,SysAccDate,DestroyF,Content,BoxAdId,SysDate,ContractF,InputBranch,MakeDate,EtaxF,DestroyRemark,BILLSEQ
    FROM dbo.TaxSheet 
   WHERE BranchCode = @BRANCHCODE
     AND SysDate >= CONVERT(CHAR(10),getdate(),120)
GO
/****** Object:  StoredProcedure [dbo].[세금계산서이관_분기_20210413]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROC [dbo].[세금계산서이관_분기_20210413]

  @QUARTER TINYINT
  ,@BRANCHCODE TINYINT    -- 97:이컴, 90:서울IC, 83:대구, 25:부산

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  BEGIN TRAN

/**************** IC센터 수정발행 계산서 회계이관 ****************/
DECLARE @Date_SettleStart char(10) 
DECLARE @Date_SettleEnd  char(10)

-- 분기별 기간
IF @QUARTER = 1
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-01-01'
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-04-01'
  END
ELSE IF @QUARTER = 2
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-04-01'
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-07-01'
  END
ELSE IF @QUARTER = 3
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-07-01'
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-10-01'
  END
ELSE IF @QUARTER = 4
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE())-1 AS CHAR(4)) + '-10-01'     -- 4분기는 다음해 초에 요청함으로 시작일은 작년도 10월부터
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-01-01'
  END

IF @BRANCHCODE = 97

  BEGIN
    /****************  파인드올(본부) 수정발행 계산서 회계이관 ****************/
    INSERT INTO dbo.TaxSheet
	  (BranchCode, TaxSheetNo, BoxLineF, Serial, IssueDate, CustCode, CustName
      , TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount
      , TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId
      , SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ)

	  SELECT
		  BRANCHCODE		= @BRANCHCODE,
		  TAXSHEETNO		= RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))),
		  BOXLINEF		= 3,
		  SERIAL			= 1,
		  ISSUEDATE		= REPLACE(CONVERT(VARCHAR(10),S.DT, 120),'-',''),
		  CUSTCODE		= U.IDX,
		  CUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  TAXCUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  RESIDENTNO		= dbo.fn_mwseedencode(RTRIM(CONVERT(VARCHAR(14),RTRIM(LTRIM(TL.BusinessNO))))),
		  PRESIDENT		= RTRIM(CONVERT(VARCHAR(30),RTRIM(LTRIM(TL.OnesName)))),
		  TYPE			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopType)))),
		  ITEM			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopPart)))),
		  Address			= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.Address, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  SUPPLYAMOUNT	= CAST(ROUND(TL.PRICE/1.1,0) AS INT),
		  TAXAMOUNT		= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,
		  ASKAMOUNT		= TL.PRICE,
		  ACCTAXID		= '',
		  SYSACCDATE		= NULL,
		  DESTROYF		= 0,
		  CONTENT			= '',
		  BOXADID			= T.GrpSerial,
		  SYSDATE			= GETDATE(),
		  CONTRACTF		= 0,
		  INPUTBRANCH		= @BRANCHCODE,
		  MakeDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  ETAXF			= 1,
		  DESTROYREMARK		= '',
		  BILLSEQ = TL.TAXSENDBILLNO
	    FROM 	FINDCOMMON.dbo.TaxRequest	T
	      JOIN FINDCOMMON.dbo.TaxUser U ON U.UserID=T.UserID
        JOIN FINDCOMMON.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
        JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS S ON S.BILLSEQ=TL.TAXSENDBILLNO COLLATE Korean_Wansung_BIN
	  WHERE 	TaxSndBillNo1 IS NOT NULL
	    AND	TransFlag IN ('NC', 'UC')
      AND	S.DT >= @Date_SettleStart
      AND	S.DT < @Date_SettleEnd
      AND (S.REPORT_AMEND_CD IS NOT NULL AND S.REPORT_AMEND_CD <> '')
      -- AND NOT EXISTS(SELECT * FROM dbo.TaxSheet WHERE TaxSheetNo = RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))) AND BranchCode = @BRANCHCODE)
	  AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)  -- 추가 2020-10-20
	  AND ISNULL(TL.FLAG,'') NOT IN ('D')

    UNION ALL

	  SELECT
		  BRANCHCODE		= @BRANCHCODE,
		  TAXSHEETNO		= RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))),
		  BOXLINEF		= 3,
		  SERIAL			= 1,
		  ISSUEDATE		= REPLACE(CONVERT(VARCHAR(10),S.DT, 120),'-',''),
		  CUSTCODE		= U.IDX,
		  CUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  TAXCUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  RESIDENTNO		= dbo.fn_mwseedencode(RTRIM(CONVERT(VARCHAR(14),RTRIM(LTRIM(TL.BusinessNO))))),
		  PRESIDENT		= RTRIM(CONVERT(VARCHAR(30),RTRIM(LTRIM(TL.OnesName)))),
		  TYPE			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopType)))),
		  ITEM			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopPart)))),
		  Address			= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.Address, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  SUPPLYAMOUNT	= CAST(ROUND(TL.PRICE/1.1,0) AS INT),
		  TAXAMOUNT		= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,
		  ASKAMOUNT		= TL.PRICE,
		  ACCTAXID		= '',
		  SYSACCDATE		= NULL,
		  DESTROYF		= 0,
		  CONTENT			= '',
		  BOXADID			= T.GrpSerial,
		  SYSDATE			= GETDATE(),
		  CONTRACTF		= 0,
		  INPUTBRANCH		= @BRANCHCODE,
		  MakeDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  ETAXF			= 1,
		  DESTROYREMARK		= '',
		  BILLSEQ = TL.TAXSENDBILLNO
	    FROM FINDCOMMON.dbo.TaxRequest	T
      JOIN FINDCOMMON.dbo.TaxNoMember AS U ON U.LINEADID=T.Adid     -- 비회원 발행건
      JOIN FINDCOMMON.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
      JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS S ON S.BILLSEQ=TL.TAXSENDBILLNO COLLATE Korean_Wansung_BIN
	  WHERE 	TaxSndBillNo1 IS NOT NULL
	    AND	TransFlag IN ('NC', 'UC')
      AND	S.DT >= @Date_SettleStart
      AND	S.DT < @Date_SettleEnd
      AND (S.REPORT_AMEND_CD IS NOT NULL AND S.REPORT_AMEND_CD <> '')
      -- AND NOT EXISTS(SELECT * FROM dbo.TaxSheet WHERE TaxSheetNo = RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))) AND BranchCode = @BRANCHCODE)
	  AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)  -- 추가 2020-10-20
	  AND ISNULL(TL.FLAG,'') NOT IN ('D')
  END

ELSE

  BEGIN

	  INSERT INTO dbo.TaxSheet
	    ( BranchCode, TaxSheetNo, BoxLineF, Serial, IssueDate, CustCode, CustName,
	      TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount,
	      TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId,
	      SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ )
	  SELECT
		  BranchCode			= @BRANCHCODE,
		  TaxSheetNo			= RTRIM(LTRIM(SubString(TL.TAXSENDBILLNO,5,10))),
		  BoxLineF			= 3,
		  Serial				= 1,
		  IssueDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  CustCode			= U.IDX,
		  CustName			= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.SHOPNM, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  TaxCustName			= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.SHOPNM, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  ResidentNo			= dbo.fn_mwseedencode(RTRIM(CONVERT(varchar(14),RTRIM(LTRIM(TL.BUSINESSNO))))),
		  President			= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(TL.ONESNAME)))),
		  Type				= RTRIM(CONVERT(varchar(20),RTRIM(LTRIM(TL.SHOPTYPE)))),
		  Item				= RTRIM(CONVERT(varchar(20),RTRIM(LTRIM(TL.SHOPPART)))),
		  Address				= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ADDRESS, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  SupplyAmount		= CAST(ROUND(TL.PRICE/1.1,0) AS INT),     -- TaxAtion
		  TaxAmount			= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,   -- TaxVat
		  AskAmount			= TL.PRICE,
		  AccTaxID			= '',
		  SysAccDate			= NULL,
		  DestroyF			= 0,
		  Content				= '',
		  BoxAdId				= T.GrpSerial,
		  SysDate				= GETDATE(),
		  ContractF			= 0,
		  InputBranch			= @BRANCHCODE,
		  MakeDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  EtaxF				= 1,
		  DestroyRemark		= '',
		  BILLSEQ = TL.TAXSENDBILLNO
	  FROM 	FINDDB1.PaperReg.dbo.Taxrequest	T
	    JOIN FINDDB1.PaperReg.dbo.TaxUser	U ON U.UserID=T.UserID
      JOIN FINDDB1.PaperReg.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
      JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS S ON S.BILLSEQ=TL.TAXSENDBILLNO COLLATE Korean_Wansung_BIN
	  WHERE TaxSndBillNo1 IS NOT NULL
	    AND	TransFlag in ('NC', 'UC')
	    AND BranchCode = @BRANCHCODE
      AND	S.DT >= @Date_SettleStart
      AND	S.DT < @Date_SettleEnd
      AND (S.REPORT_AMEND_CD IS NOT NULL AND S.REPORT_AMEND_CD <> '')
      -- AND NOT EXISTS(SELECT * FROM dbo.TaxSheet WHERE TaxSheetNo = RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))) AND BranchCode = @BRANCHCODE)
	  AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS) -- 추가 2020-10-20
	  AND ISNULL(TL.FLAG,'') NOT IN ('D')
  END

  COMMIT TRAN

  SELECT BranchCode,TaxSheetNo,BoxLineF,Serial,IssueDate,CustCode,CustName,TaxCustName,dbo.fn_mwseeddecode(ResidentNo) AS ResidentNo,President,Type,Item,Address,CAST(SupplyAmount AS INT) AS SupplyAmount,CAST(TaxAmount AS INT) AS TaxAmount,CAST(AskAmount AS INT) AS AskAmount,AccTaxID,SysAccDate,DestroyF,Content,BoxAdId,SysDate,ContractF,InputBranch,MakeDate,EtaxF,DestroyRemark,BILLSEQ
    FROM dbo.TaxSheet 
   WHERE BranchCode = @BRANCHCODE
     AND SysDate >= CONVERT(CHAR(10),getdate(),120)
GO
/****** Object:  StoredProcedure [dbo].[세금계산서이관_분기_이컴_test]    Script Date: 2021-11-04 오전 10:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[세금계산서이관_분기_이컴_test]

  @QUARTER TINYINT
  ,@BRANCHCODE TINYINT    -- 97:이컴, 90:서울IC, 83:대구, 25:부산

AS

  SET XACT_ABORT ON
  SET NOCOUNT ON

  BEGIN TRAN

/**************** IC센터 수정발행 계산서 회계이관 ****************/
DECLARE @Date_SettleStart char(10) 
DECLARE @Date_SettleEnd  char(10)

-- 분기별 기간
IF @QUARTER = 1
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-01-01'
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-04-01'
  END
ELSE IF @QUARTER = 2
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-04-01'
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-07-01'
  END
ELSE IF @QUARTER = 3
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-07-01'
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-10-01'
  END
ELSE IF @QUARTER = 4
  BEGIN
    SET @Date_SettleStart = CAST(YEAR(GETDATE())-1 AS CHAR(4)) + '-10-01'     -- 4분기는 다음해 초에 요청함으로 시작일은 작년도 10월부터
    SET @Date_SettleEnd   = CAST(YEAR(GETDATE()) AS CHAR(4)) + '-01-01'
  END

IF @BRANCHCODE = 97

  BEGIN
    /****************  파인드올(본부) 수정발행 계산서 회계이관 ****************/
    INSERT INTO dbo.TaxSheet
	  (BranchCode, TaxSheetNo, BoxLineF, Serial, IssueDate, CustCode, CustName
      , TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount
      , TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId
      , SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ)

	  SELECT
		  BRANCHCODE		= @BRANCHCODE,
		  TAXSHEETNO		= RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,5,10))),
		  BOXLINEF		= 3,
		  SERIAL			= 1,
		  ISSUEDATE		= REPLACE(CONVERT(VARCHAR(10),S.DT, 120),'-',''),
		  CUSTCODE		= U.IDX,
		  CUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  TAXCUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  RESIDENTNO		= dbo.fn_mwseedencode(RTRIM(CONVERT(VARCHAR(14),RTRIM(LTRIM(TL.BusinessNO))))),
		  PRESIDENT		= RTRIM(CONVERT(VARCHAR(30),RTRIM(LTRIM(TL.OnesName)))),
		  TYPE			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopType)))),
		  ITEM			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopPart)))),
		  Address			= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.Address, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  SUPPLYAMOUNT	= CAST(ROUND(TL.PRICE/1.1,0) AS INT),
		  TAXAMOUNT		= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,
		  ASKAMOUNT		= TL.PRICE,
		  ACCTAXID		= '',
		  SYSACCDATE		= NULL,
		  DESTROYF		= 0,
		  CONTENT			= '',
		  BOXADID			= T.GrpSerial,
		  SYSDATE			= GETDATE(),
		  CONTRACTF		= 0,
		  INPUTBRANCH		= @BRANCHCODE,
		  MakeDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  ETAXF			= 1,
		  DESTROYREMARK		= '',
		  BILLSEQ = TL.TAXSENDBILLNO
	    FROM 	FINDCOMMON.dbo.TaxRequest	T
	      JOIN FINDCOMMON.dbo.TaxUser U ON U.UserID=T.UserID
        JOIN FINDCOMMON.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
        JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS S ON S.BILLSEQ=TL.TAXSENDBILLNO COLLATE Korean_Wansung_BIN
	  WHERE 	TaxSndBillNo1 IS NOT NULL
	    AND	TransFlag IN ('NC', 'UC')
      AND	S.DT >= @Date_SettleStart
      AND	S.DT < @Date_SettleEnd
      AND (S.REPORT_AMEND_CD IS NOT NULL AND S.REPORT_AMEND_CD <> '')
      -- AND NOT EXISTS(SELECT * FROM dbo.TaxSheet WHERE TaxSheetNo = RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))) AND BranchCode = @BRANCHCODE)
	  AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)  -- 추가 2020-10-20
	  AND ISNULL(TL.FLAG,'') NOT IN ('D')

    UNION ALL

	  SELECT
		  BRANCHCODE		= @BRANCHCODE,
		  TAXSHEETNO		= RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,5,10))),
		  BOXLINEF		= 3,
		  SERIAL			= 1,
		  ISSUEDATE		= REPLACE(CONVERT(VARCHAR(10),S.DT, 120),'-',''),
		  CUSTCODE		= U.IDX,
		  CUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  TAXCUSTNAME		= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ShopNm, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  RESIDENTNO		= dbo.fn_mwseedencode(RTRIM(CONVERT(VARCHAR(14),RTRIM(LTRIM(TL.BusinessNO))))),
		  PRESIDENT		= RTRIM(CONVERT(VARCHAR(30),RTRIM(LTRIM(TL.OnesName)))),
		  TYPE			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopType)))),
		  ITEM			= RTRIM(CONVERT(VARCHAR(20),RTRIM(LTRIM(TL.ShopPart)))),
		  Address			= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.Address, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  SUPPLYAMOUNT	= CAST(ROUND(TL.PRICE/1.1,0) AS INT),
		  TAXAMOUNT		= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,
		  ASKAMOUNT		= TL.PRICE,
		  ACCTAXID		= '',
		  SYSACCDATE		= NULL,
		  DESTROYF		= 0,
		  CONTENT			= '',
		  BOXADID			= T.GrpSerial,
		  SYSDATE			= GETDATE(),
		  CONTRACTF		= 0,
		  INPUTBRANCH		= @BRANCHCODE,
		  MakeDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  ETAXF			= 1,
		  DESTROYREMARK		= '',
		  BILLSEQ = TL.TAXSENDBILLNO
	    FROM FINDCOMMON.dbo.TaxRequest	T
      JOIN FINDCOMMON.dbo.TaxNoMember AS U ON U.LINEADID=T.Adid     -- 비회원 발행건
      JOIN FINDCOMMON.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
      JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS S ON S.BILLSEQ=TL.TAXSENDBILLNO COLLATE Korean_Wansung_BIN
	  WHERE 	TaxSndBillNo1 IS NOT NULL
	    AND	TransFlag IN ('NC', 'UC')
      AND	S.DT >= @Date_SettleStart
      AND	S.DT < @Date_SettleEnd
      AND (S.REPORT_AMEND_CD IS NOT NULL AND S.REPORT_AMEND_CD <> '')
      -- AND NOT EXISTS(SELECT * FROM dbo.TaxSheet WHERE TaxSheetNo = RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))) AND BranchCode = @BRANCHCODE)
	  AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS)  -- 추가 2020-10-20
	  AND ISNULL(TL.FLAG,'') NOT IN ('D')
  END

ELSE

  BEGIN

	  INSERT INTO dbo.TaxSheet
	    ( BranchCode, TaxSheetNo, BoxLineF, Serial, IssueDate, CustCode, CustName,
	      TaxCustName, ResidentNo, President, Type, Item, Address, SupplyAmount,
	      TaxAmount, AskAmount, AccTaxID, SysAccDate, DestroyF, Content, BoxAdId,
	      SysDate, ContractF, InputBranch, MakeDate, EtaxF, DestroyRemark, BILLSEQ )
	  SELECT
		  BranchCode			= @BRANCHCODE,
		  TaxSheetNo			= RTRIM(LTRIM(SubString(TL.TAXSENDBILLNO,5,10))),
		  BoxLineF			= 3,
		  Serial				= 1,
		  IssueDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  CustCode			= U.IDX,
		  CustName			= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.SHOPNM, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  TaxCustName			= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.SHOPNM, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  ResidentNo			= dbo.fn_mwseedencode(RTRIM(CONVERT(varchar(14),RTRIM(LTRIM(TL.BUSINESSNO))))),
		  President			= RTRIM(CONVERT(varchar(30),RTRIM(LTRIM(TL.ONESNAME)))),
		  Type				= RTRIM(CONVERT(varchar(20),RTRIM(LTRIM(TL.SHOPTYPE)))),
		  Item				= RTRIM(CONVERT(varchar(20),RTRIM(LTRIM(TL.SHOPPART)))),
		  Address				= RTRIM(CONVERT(varchar(80),RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TL.ADDRESS, '\','￦'), '&','＆'), '<','＜'), '>','＞'))))),
		  SupplyAmount		= CAST(ROUND(TL.PRICE/1.1,0) AS INT),     -- TaxAtion
		  TaxAmount			= CAST(ROUND(TL.PRICE - (TL.PRICE/1.1),0) AS INT) ,   -- TaxVat
		  AskAmount			= TL.PRICE,
		  AccTaxID			= '',
		  SysAccDate			= NULL,
		  DestroyF			= 0,
		  Content				= '',
		  BoxAdId				= T.GrpSerial,
		  SysDate				= GETDATE(),
		  ContractF			= 0,
		  InputBranch			= @BRANCHCODE,
		  MakeDate			= Replace(convert(varchar(10),S.DT, 120),'-',''),
		  EtaxF				= 1,
		  DestroyRemark		= '',
		  BILLSEQ = TL.TAXSENDBILLNO
	  FROM 	FINDDB1.PaperReg.dbo.Taxrequest	T
	    JOIN FINDDB1.PaperReg.dbo.TaxUser	U ON U.UserID=T.UserID
      JOIN FINDDB1.PaperReg.dbo.TAXISSUE_LOG AS TL ON TL.TAXREQUESTKEY = T.Idx
      JOIN [116.120.56.64].ACCDB1.dbo.BILL_TRANS AS S ON S.BILLSEQ=TL.TAXSENDBILLNO COLLATE Korean_Wansung_BIN
	  WHERE TaxSndBillNo1 IS NOT NULL
	    AND	TransFlag in ('NC', 'UC')
	    AND BranchCode = @BRANCHCODE
      AND	S.DT >= @Date_SettleStart
      AND	S.DT < @Date_SettleEnd
      AND (S.REPORT_AMEND_CD IS NOT NULL AND S.REPORT_AMEND_CD <> '')
      -- AND NOT EXISTS(SELECT * FROM dbo.TaxSheet WHERE TaxSheetNo = RTRIM(LTRIM(SUBSTRING(TL.TAXSENDBILLNO,4,10))) AND BranchCode = @BRANCHCODE)
	  AND NOT EXISTS (SELECT * FROM dbo.TaxSheet WHERE BILLSEQ = TL.TAXSENDBILLNO  COLLATE Korean_Wansung_CI_AS) -- 추가 2020-10-20
	  AND ISNULL(TL.FLAG,'') NOT IN ('D')
  END

  COMMIT TRAN

  SELECT BranchCode,TaxSheetNo,BoxLineF,Serial,IssueDate,CustCode,CustName,TaxCustName,dbo.fn_mwseeddecode(ResidentNo) AS ResidentNo,President,Type,Item,Address,CAST(SupplyAmount AS INT) AS SupplyAmount,CAST(TaxAmount AS INT) AS TaxAmount,CAST(AskAmount AS INT) AS AskAmount,AccTaxID,SysAccDate,DestroyF,Content,BoxAdId,SysDate,ContractF,InputBranch,MakeDate,EtaxF,DestroyRemark,BILLSEQ
    FROM dbo.TaxSheet 
   WHERE BranchCode = @BRANCHCODE
     AND SysDate >= CONVERT(CHAR(10),getdate(),120)
GO
