USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[GET_MM_MEMBER_HP_PROC]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************
 *  단위 업무 명 : ADMIN - 회원가입 대행 - 해당 전화번호로 등로된 ID 불러오기
 *  작   성   자 : 배진용
 *  작   성   일 : 2020-10-07
 *  수   정   자 : 
 *  수   정   일 :  
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 기업회원 : 동일 휴대폰 번호 3개까지만 체크
 *  주 의  사 항 : 
 *  사 용  소 스 :
 EXEC GET_MM_MEMBER_HP_PROC '2','01063930923'
************************************************************************************/
CREATE PROC [dbo].[GET_MM_MEMBER_HP_PROC]
       @MEMBER_CD   CHAR(1)
     , @HP          VARCHAR(14)
	 , @USERID		VARCHAR(30) = ''
AS
SET NOCOUNT ON
BEGIN
	DECLARE @HP_TYPE2          VARCHAR(14)
	IF LEN(@HP) = 11 
		SET @HP_TYPE2 = LEFT(@HP,3) +'-' + RIGHT(LEFT(@HP,7),4) +'-' + RIGHT(@HP,4)
	ELSE IF LEN(@HP) = 10
		SET @HP_TYPE2 = LEFT(@HP,3) +'-' + RIGHT(LEFT(@HP,7),3) +'-' + RIGHT(@HP,4)
	ELSE 
		SET @HP_TYPE2 = '9999999999999'
	
	IF LEN(@HP) > 0 AND @HP_TYPE2 <> '9999999999999'
	BEGIN
			SELECT A.CUID, A.USERID,
			   (CASE ISNULL(B.hp,'N') WHEN 'N' THEN 'N' ELSE 'Y' END) AS BAD_YN , 
			   ISNULL(A.REST_YN, 'N') as REST_YN
		  FROM CST_MASTER AS A WITH (NOLOCK)
		 LEFT OUTER JOIN MM_BAD_HP_TB AS B WITH (NOLOCK)
		    ON A.HPHONE = B.HP  AND B.DEL_YN = 'N'
		 WHERE A.HPHONE IN (@HP, @HP_TYPE2) 
		   AND A.OUT_YN = 'N' AND MEMBER_CD = '2' AND A.USERID != @USERID
		   OR A.CUID IN ( SELECT A.CUID FROM CST_REST_MASTER AS A WITH(NOLOCK)
		   INNER JOIN CST_MASTER  AS B WITH(NOLOCK)
		   ON A.CUID = B.CUID
		   WHERE A.HPHONE IN (@HP, @HP_TYPE2) 
		   AND B.OUT_YN = 'N' AND B.MEMBER_CD = '2' AND A.USERID != @USERID)

		   
	END
END



GO
