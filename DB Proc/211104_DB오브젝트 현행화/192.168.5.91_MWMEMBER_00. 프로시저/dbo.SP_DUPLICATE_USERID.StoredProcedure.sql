USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[SP_DUPLICATE_USERID]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_DUPLICATE_USERID]
/*************************************************************************************
 *  단위 업무 명 : 중복 아이디 체크
 *  작   성   자 : J&J
 *  작   성   일 : 2016-07-25
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : 중복 아이디 체크
 * RETURN(500)  -- 중복아이디
 * RETURN(0)    --  중복 아이디 없음
  *************************************************************************************/
@USERID VARCHAR(50)
AS 

--	DECLARE @NO_CHK INT
		DECLARE @SQL nvarchar(4000)
		SET @SQL = 'SELECT TB.*,
				CASE TB.ORD  
				WHEN '+ '''0''' + ' THEN ''' + '선 접속 시 먼저 아이디를 사용 할수 있음' +'''
				WHEN '+'''2''' +'THEN '''+'관리자가 변경 해줘야 함'+'''
				ELSE '''' END ORD_MSG,
				--M.CUID, 
				--M.USERID, 
				M.REST_YN, 
				CASE M.SITE_CD 
				WHEN '''+'F'+''' THEN '''+'파인드올'+'''
				WHEN '''+'S'+''' THEN '''+'부동산써브'+'''
				ELSE '''' END SITE_CD,
				M.EMAIL ,
				CASE M.MEMBER_CD
				WHEN '''+'1'+''' THEN '''+'개인'+'''
				WHEN '''+'2'+''' THEN '''+'기업'+'''
				ELSE '''' END MEMBER_CD,
				M.USER_NM
		FROM [DUPLICATE_USERID_TB] TB WITH(NOLOCK) LEFT JOIN CST_MASTER M WITH(NOLOCK) ON
		TB.CUID = M.CUID -- 1955
		WHERE TB.USERID LIKE ' 
		SET @SQL = @SQL +  '''%' +@USERID +'%'''
		SET @SQL = @SQL +'ORDER BY TB.USERID'
		/*
			아이디 변경 시 호출 해야 줘야 하는 PROC  90번 서버
			CUID_CHANGE_ALL_PROC  

			 @MASTER_CUID   INT         =  0      -- 기존아이디
			 ,@MASTER_USERID  VARCHAR(50) =  ''     -- 기존아이디
			 ,@SLAVE_CUID   INT   =  0      --  변경 아이디
			 ,@CLIENT_IP   VARCHAR(20) = '사용자 아이디'

		 USERID 를 변경 하는 [dbo].[SP_USERID_ADMIN_CHANGE]
		 EXEC SP_DUPLICATE_USERID '97328422'
		*/
		EXEC(@SQL)
GO
