USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[CHK_MM_LOGIN_NOPWD_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 기업, 일반 회원 로그인 및 전환(비번 없이 로그인)
 *  작   성   자 : 최 병찬
 *  작   성   일 : 2015-3-11
 *  수   정   자 : 배진용
 *  수   정   일 : 2020-10-23 
 *  설        명 : 최종 회원가입 컬럼 추가 (2020-10-23)
 *  주 의  사 항 : 
 *  사 용  소 스 :
 * DECLARE @RET INT
 * EXEC @RET=CHK_MM_LOGIN_NOPWD_PROC 'sebilia'
 * SELECT @RET
   
 *************************************************************************************/
CREATE PROCEDURE [dbo].[CHK_MM_LOGIN_NOPWD_PROC]
    @USERID                VARCHAR(50)  -- 회원아이디
AS

	SET NOCOUNT ON

  DECLARE @ERROR INT
  DECLARE @ROWCOUNT INT

----------------------------------
-- 회원코드 가져오기
----------------------------------
  DECLARE @MEMBER_CD    CHAR(1)
  DECLARE @REST_YN      CHAR(1)

  SELECT TOP 1 
         @MEMBER_CD = MEMBER_CD
       , @REST_YN = REST_YN
    FROM DBO.CST_MASTER WITH(NOLOCK)
   WHERE USERID = @USERID
   ORDER BY REST_YN 

  SELECT @ERROR=@@ERROR
  IF @ERROR<>0            --조회 에러
  BEGIN
      RETURN (100)
  END

  IF @REST_YN = 'Y' 
  BEGIN
    --휴면 회원 ID는 휴면 회원 페이지로 이동
    RETURN (99)
  END   

  IF @MEMBER_CD IS NULL   --로그인 실패
  BEGIN
      RETURN (1)
  END

  --기업 관련 정보를 가져올 수 없음
  --해당 섹션별 정보가 다를 수 있다는 전제로 출발
  SELECT
         M.USERID
       , M.USER_NM    -- 개인이름
       , M.MEMBER_CD
       , ISNULL(J.COM_NM,'') AS COM_NM    -- 기업명(기업만 사용)
       , ISNULL(M.EMAIL,'') AS EMAIL
       , ISNULL(M.HPHONE,'') AS HPHONE
       , '' AS PHONE
       , '' AS ADDR_A
       , '' AS ADDR_B
       , M.BAD_YN
       , M.BIRTH AS JUMINNO_A        --주민번호_A
       , M.DI
       , M.REST_YN
       , ISNULL(M.ADULT_YN,'') AS ISADULT
       , ISNULL(M.SNS_TYPE,'') as SNS_TYPE
       , DATEDIFF(DAY, M.PWD_NEXT_ALARM_DT, GETDATE()) AS PWD_ALARM_YN
       , CONVERT(varchar(10), M.JOIN_DT, 120) AS JOIN_DT
       , CASE
              WHEN LEN(M.BIRTH)=8 AND ISNUMERIC(M.BIRTH)=1 THEN YEAR(GETDATE())-LEFT(M.BIRTH,4)
              ELSE 0
         END AGE
       , CASE
              WHEN M.GENDER IN ('M','A','0') THEN 'man'
              WHEN M.GENDER IN ('F','B','1') THEN 'woman'
         END AS GENDER
       , M.CUID  
	   -- 2020-10-27 회원가입대행 컬럼 추가
		,M.AGENCY_YN
	   ,M.LAST_SIGNUP_YN
    FROM DBO.CST_MASTER AS M WITH(NOLOCK)        
    LEFT OUTER JOIN DBO.CST_COMPANY J WITH(NOLOCK) ON M.COM_ID = J.COM_ID
   WHERE M.USERID = @USERID
     AND M.OUT_YN='N'

  SELECT @ERROR=@@ERROR
  IF @ERROR<>0            --조회 에러
  BEGIN
      RETURN (101)
  END

  RETURN (0)
GO
