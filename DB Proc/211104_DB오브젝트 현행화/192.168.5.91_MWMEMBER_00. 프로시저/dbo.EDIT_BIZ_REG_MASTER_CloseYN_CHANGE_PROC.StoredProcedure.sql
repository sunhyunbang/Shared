USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_BIZ_REG_MASTER_CloseYN_CHANGE_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위업무명: 사업자 번호 기준 폐업 여부 저장
 *  작  성  자: 이현석
 *  작  성  일: 2021/05/17
 *  수  정  자: 
 *  수  정  일: 
 *  주의 사항:
 *  사용 소스:
 *  사용 예제: 예시 [MWMEMBER].[DBO].[EDIT_BIZ_REG_MASTER_CloseYN_Change_PROC]
               execute [MWMEMBER].[DBO].[EDIT_BIZ_REG_MASTER_CloseYN_Change_PROC] '829-81-00791', '주식회사 LOVE';

execute [MWMEMBER].[DBO].[EDIT_BIZ_REG_MASTER_CloseYN_CHANGE_PROC] 
        @BizNo = '829-81-00791'
	  , @BizName = '주식회사 LOVE'
*************************************************************************************/
CREATE PROC [dbo].[EDIT_BIZ_REG_MASTER_CloseYN_CHANGE_PROC]
        @BizNo varchar(12)
      , @BizName varchar(50) 
AS
--DECLARE @BizNo varchar(12) = '829-81-00791'
--DECLARE @BizName varchar(50) = '주식회사 LOVE'

--1. 관련 테이블 확인
SELECT * 
  FROM MWMEMBER.DBO.BIZ_REG_MASTER A WITH(NOLOCK)
 WHERE 1=1
   AND A.BizNo = @BizNo;

--SELECT A.BizNo
--     , A.BizName
--	 , A.MakeDate
--	 , A.Origin
--	 , A.CloseYN
--	 , A.CloseDate
--  FROM MWMEMBER.DBO.BIZ_REG_MASTER A WITH(NOLOCK)
-- WHERE 1=1
--   AND A.BizNo = @BizNo;

--2. 변경 하려는 데이터 확인
MERGE MWMEMBER.DBO.BIZ_REG_MASTER A
USING (SELECT '1' COL)  B
   ON A.BizNo = @BizNo
  -- AND A.BizName = @BizName
 WHEN MATCHED THEN
    UPDATE 
	   SET CloseYN = ('Y')
	     , closeDate = (getdate())
 WHEN NOT MATCHED THEN 
    INSERT (BizNo, BizName, MakeDate, Origin, CloseYN,CloseDate)
    VALUES (@BizNo, @BizName, GETDATE(), 'B','Y', GETDATE())

OUTPUT $ACTION AS result_string;

--3. 변경 된 내용 확인
DECLARE @Full_SQL VARCHAR(MAX)
SET @Full_SQL =
 'SELECT A.BizNo, A.BizName, A.MakeDate, A.Origin, A.CloseYN, A.CloseDate
    FROM MWMEMBER.DBO.BIZ_REG_MASTER A WITH(NOLOCK)
   WHERE 1=1 AND A.BizNo = ('''+ @BizNo +''');'

PRINT @Full_SQL;
GO
