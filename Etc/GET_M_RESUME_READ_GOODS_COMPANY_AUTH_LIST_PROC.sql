USE [PAPER_NEW]
GO

/****** Object:  StoredProcedure [dbo].[GET_M_RESUME_READ_GOODS_COMPANY_AUTH_LIST_PROC]    Script Date: 2022-11-25 ���� 9:04:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************************
 *  ���� ���� �� : ���ΰ����� > �̷¼����� > ����������� ����Ʈ
 *  ��   ��   �� : �� �� ��
 *  ��   ��   �� : 2015/02/24
 *  ��   ��   �� :
 *  ��   ��   �� :
 *  ��        �� :
 *  �� ��  �� �� :
 *  �� ��  �� �� :
 *  �� ��  �� �� :
 EXEC GET_M_RESUME_READ_GOODS_COMPANY_AUTH_LIST_PROC 1, 10, '', '', '', '', 80, '', '', ''
 EXEC GET_M_RESUME_READ_GOODS_COMPANY_AUTH_LIST_PROC 1, 10, '0', '2015-01-26', '2015-02-26', '', '80', '1', '', ''
 EXEC GET_M_RESUME_READ_GOODS_COMPANY_AUTH_LIST_PROC 1, 10, '0', '2015-03-01', '2015-04-16', '', '80', '', '7', '206-85-26551'
 EXEC GET_M_RESUME_READ_GOODS_COMPANY_AUTH_LIST_PROC 1, 8, '0', '2015-03-22', '2015-04-22', '', 80, '1', '', ''
 EXEC GET_M_RESUME_READ_GOODS_COMPANY_AUTH_LIST_PROC 1, 10, '0', '2021-08-02', '2021-09-02', '', 80, '0', '', ''

 EXEC GET_M_RESUME_READ_GOODS_COMPANY_AUTH_LIST_PROC 1, 10, '0', '2021-08-02', '2021-09-02', '', 80, '0', '', ''
 *************************************************************************************/
CREATE PROC [dbo].[GET_M_RESUME_READ_GOODS_COMPANY_AUTH_LIST_PROC]
  @PAGE                   INT               = 1
, @PAGESIZE               INT               = 10
, @DT_DIV                 CHAR(1)           = ''
, @START_DT               VARCHAR(10)       = ''
, @END_DT                 VARCHAR(10)       = ''
, @ADGBN                  CHAR(1)           = ''
, @MAG_BRANCHCODE         TINYINT           = 0
, @STATUS                 CHAR(1)           = ''
, @SEARCH_KEY             CHAR(1)           = ''
, @SEARCH_WORD            VARCHAR(50)       = ''
AS

BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @SQL_COUNT NVARCHAR(4000)
  DECLARE @SQL_SELECT NVARCHAR(4000)
  DECLARE @SQL_WHERE NVARCHAR(4000)
  DECLARE @SQL_WHERE_TEMP NVARCHAR(4000) =''

  SET @SQL_WHERE = ''

  IF @MAG_BRANCHCODE = 80
  BEGIN

    -- �Ⱓ����
    IF @DT_DIV != ''
    BEGIN
      IF @DT_DIV = '0'          -- �����
      BEGIN
        IF @START_DT != '' AND @END_DT != ''
          SET @SQL_WHERE = @SQL_WHERE + ' AND A.REG_DT > ''' + @START_DT + ''' AND A.REG_DT < DATEADD(DAY, 1, ''' + @END_DT + ''') '
        ELSE IF @START_DT != '' AND @END_DT = ''
          SET @SQL_WHERE = @SQL_WHERE + ' AND A.REG_DT > ''' + @START_DT + ''''
        ELSE IF @START_DT = '' AND @END_DT != ''
          SET @SQL_WHERE = @SQL_WHERE + ' AND A.REG_DT < DATEADD(DAY, 1, ''' + @END_DT + ''') '
      END
      IF @DT_DIV = '1'          -- ������
      BEGIN
        IF @START_DT != '' AND @END_DT != ''
          SET @SQL_WHERE = @SQL_WHERE + ' AND A.CONFIRM_DT > ''' + @START_DT + ''' AND A.CONFIRM_DT < DATEADD(DAY, 1, ''' + @END_DT + ''') '
        ELSE IF @START_DT != '' AND @END_DT = ''
          SET @SQL_WHERE = @SQL_WHERE + ' AND A.CONFIRM_DT > ''' + @START_DT + ''''
        ELSE IF @START_DT = '' AND @END_DT != ''
          SET @SQL_WHERE = @SQL_WHERE + ' AND A.CONFIRM_DT < DATEADD(DAY, 1, ''' + @END_DT + ''') '
      END
    END

    -- ��ϰ��
    IF @ADGBN != ''
      SET @SQL_WHERE = @SQL_WHERE + ' AND A.ADGBN = ''' + @ADGBN + ''''

    -- �ɻ����
    IF @STATUS != ''
    BEGIN
      IF @STATUS = '2'
        SET @SQL_WHERE = @SQL_WHERE + ' AND A.STATUS >= 2 '
      ELSE
        SET @SQL_WHERE = @SQL_WHERE + ' AND A.STATUS = ' + LTRIM(RTRIM(STR(@STATUS)))

    END

    -- Ű���� �˻�
    IF @SEARCH_WORD != '' AND @SEARCH_KEY != ''
    BEGIN
      IF @SEARCH_KEY = '1'      -- USER_ID
        --SET @SQL_WHERE = @SQL_WHERE + ' AND A.USER_ID LIKE ''' + @SEARCH_WORD + '%'' '
  SET @SQL_WHERE = @SQL_WHERE + ' AND A.USER_ID = ''' + @SEARCH_WORD + ''' '
      ELSE IF @SEARCH_KEY = '2' -- ��û��ȣ
        --SET @SQL_WHERE = @SQL_WHERE + ' AND A.REGIST_ID = ' + LTRIM(RTRIM(STR(@SEARCH_WORD)))
  SET @SQL_WHERE = @SQL_WHERE + ' AND A.COMPANY_ID = ' + LTRIM(RTRIM(STR(@SEARCH_WORD)))
      ELSE IF @SEARCH_KEY = '3' -- ��ȣ��
   BEGIN
  --SET @SQL_WHERE_TEMP = 'SELECT CUID INTO #TMP FROM PP_COMPANY_INFO_JOB_VI CIJ WITH(NOLOCK) WHERE  CIJ.COM_NM = ''' + @SEARCH_WORD + '%'' ;'
  SET @SQL_WHERE_TEMP = 'SELECT CUID INTO #TMP FROM PP_COMPANY_INFO_JOB_VI CIJ WITH(NOLOCK) WHERE  CIJ.COM_NM LIKE ''%' + @SEARCH_WORD + '%'' ;'
        SET @SQL_WHERE = @SQL_WHERE + ' AND A.CUID IN (select CUID FROM #TMP)'
   END
      ELSE IF @SEARCH_KEY = '4' -- ��û ����ڸ�
        --SET @SQL_WHERE = @SQL_WHERE + ' AND A.ONESNAME LIKE ''' + @SEARCH_WORD + '%'''
  SET @SQL_WHERE = @SQL_WHERE + ' AND A.ONESNAME = ''' + @SEARCH_WORD + ''''
      ELSE IF @SEARCH_KEY = '5' -- ��ȭ��ȣ(��û��)
        --SET @SQL_WHERE = @SQL_WHERE + ' AND ((A.SEARCH_HPHONE LIKE ''' + @SEARCH_WORD + '%'') OR (A.SEARCH_PHONE LIKE ''' + @SEARCH_WORD + '%'')) '
  SET @SQL_WHERE = @SQL_WHERE + ' AND ((A.SEARCH_HPHONE = ''' + replace(@SEARCH_WORD,'-','') + ''') OR (A.SEARCH_PHONE = ''' + replace(@SEARCH_WORD,'-','') + ''')) '
      ELSE IF @SEARCH_KEY = '6' -- �̸���(��û��)
        --SET @SQL_WHERE = @SQL_WHERE + ' AND A.EMAIL LIKE ''' + @SEARCH_WORD + '%'''
  SET @SQL_WHERE = @SQL_WHERE + ' AND A.EMAIL = ''' + @SEARCH_WORD + ''''
      ELSE IF @SEARCH_KEY = '7' -- ����ڹ�ȣ
   BEGIN
  --SET @SQL_WHERE_TEMP = 'SELECT CUID INTO #TMP FROM PP_COMPANY_INFO_JOB_VI CIJ WITH(NOLOCK) WHERE  CIJ.BIZNO LIKE ''' + @SEARCH_WORD + '%'' ;'
  SET @SQL_WHERE_TEMP = 'SELECT CUID INTO #TMP FROM PP_COMPANY_INFO_JOB_VI CIJ WITH(NOLOCK) WHERE  CIJ.BIZNO = ''' + @SEARCH_WORD + ''' ;'
          SET @SQL_WHERE = @SQL_WHERE + ' AND A.CUID IN (select CUID FROM #TMP)'
      
      END
    END

    IF @PAGE = 1
    BEGIN
      SET @SQL_COUNT = @SQL_WHERE_TEMP + '
      SELECT COUNT(A.COMPANY_ID) AS CNT
        FROM PP_RESUME_READ_GOODS_COMPANY_AUTH_TB AS A WITH(NOLOCK)
        '
  
       SET @SQL_COUNT = @SQL_COUNT + ' WHERE A.DEL_YN = ''N''
       ' + @SQL_WHERE

      PRINT @SQL_COUNT
      EXECUTE SP_EXECUTESQL @SQL_COUNT
    END

    SET @SQL_SELECT = @SQL_WHERE_TEMP + '
    SELECT X.COMPANY_ID
         , X.REG_DT
         , X.COM_NM
         --, X.USER_ID
   , dbo.FN_GET_USERID_SECURE(X.USER_ID) AS USER_ID
         , X.USER_STATUS
         , X.ADGBN
         , X.BIZNO
         , X.MAG_ID
         , X.MAG_BRANCHCODE
         , X.MagName
         , X.STATUS
         , ISNULL(X.PAPER_CNT,0) as PAPER_CNT
         , ISNULL(X.BOX_CNT,0) as BOX_CNT
         , ISNULL(X.ECOMM_CNT,0)as ECOMM_CNT
         , ISNULL(X.ONLINE_CNT,0) as ONLINE_CNT
         , X.REJECT_COMMENT
         , X.START_DT
         , X.END_DT
         , X.COMPULSION_YN
         , X.PAY_STATUS
         , X.CUID
         , X.BIZ_IMAGE
		 , X.ISSTORAGE	
      FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY A.REG_DT DESC) AS ROWNUM
                 , A.COMPANY_ID
                 , A.REG_DT
                 , CIJ.COM_NM
                 , A.USER_ID
                 , CASE WHEN B.USER_ID IS NULL THEN ''Y'' ELSE ''N'' END AS USER_STATUS
                 , A.ADGBN
                 , CIJ.BIZNO
                 , A.MAG_ID
                 , A.MAG_BRANCHCODE
                 , C.MagName
                 , A.STATUS
                 , D.PAPER_CNT
                 , D.BOX_CNT
                 , D.ECOMM_CNT
                 , D.ONLINE_CNT
                 , A.REJECT_COMMENT
                 , E.START_DT
                 , E.END_DT
                 , E.COMPULSION_YN
                 , E.PAY_STATUS
                 , A.CUID
                 , ISNULL(A.BIZ_IMAGE, '''') AS BIZ_IMAGE
				 , E.ISSTORAGE	
              FROM PP_RESUME_READ_GOODS_COMPANY_AUTH_TB AS A WITH(NOLOCK)
              LEFT JOIN PG_RESUME_REJECT_MEMBER_TB AS B WITH(NOLOCK) ON A.CUID = B.CUID
              LEFT JOIN MWDB.DBO.CommonMagUser AS C WITH(NOLOCK) ON A.MAG_ID = C.MagID
              LEFT JOIN PP_RESUME_READ_GOODS_USER_AD_COUNT AS D WITH(NOLOCK) ON A.CUID = D.CUID
              LEFT JOIN (SELECT COMPANY_ID, START_DT, END_DT, COMPULSION_YN, PAY_STATUS, ISSTORAGE FROM PP_RESUME_READ_GOODS_REGIST_TB AS N WITH(NOLOCK) WHERE N.ISSTORAGE = 0 AND N.REGIST_ID IN (SELECT REGIST_ID FROM (SELECT COMPANY_ID, MAX(REGIST_ID) AS REGIST_ID FROM PP_RESUME_READ_GOODS_REGIST_TB (NOLOCK) WHERE ISSTORAGE = 0 AND DEL_YN = ''N'' GROUP BY COMPANY_ID ) R)) AS E ON A.COMPANY_ID = E.COMPANY_ID
              JOIN PP_COMPANY_INFO_JOB_VI AS CIJ WITH(NOLOCK) ON A.CUID = CIJ.CUID
             WHERE A.DEL_YN = ''N''
             ' + @SQL_WHERE + '
           ) X
     WHERE X.ROWNUM > ' + CONVERT(VARCHAR(10), (@PAGE - 1) * @PAGESIZE) + ' AND X.ROWNUM <= ' + CONVERT(VARCHAR(10), (@PAGE) * @PAGESIZE)


    PRINT @SQL_SELECT
    EXECUTE SP_EXECUTESQL @SQL_SELECT
  END
END



GO


