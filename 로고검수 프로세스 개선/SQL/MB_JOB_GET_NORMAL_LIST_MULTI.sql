    
/*************************************************************************************    
 *  ���� ���� �� : ���α��� ���ǰ˻� �⺻����Ʈ    
 *  ��   ��   �� : �� �� �� (jssin@mediawill.com)    
 *  ��   ��   �� : 2017/05/27    
 *  ��   ��   �� : �輱ȣ  
 *  ��   ��   �� : 2021/02/16  
 *  �� ��  �� �� : ������ �������� �� ���� ������Ʈ(AREA_COUNT)   
 *  ��   ��   �� : �� �� ��        
 *  ��   ��   �� : 2021/10/12 
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����
 *  ��        �� :    
 *  �� ��  �� �� :    
 *  �� ��  �� �� :    
 *  �� ��  �� �� :    
 exec MB_JOB_GET_NORMAL_LIST_MULTI 0,1,15,'','','',0,0,0,0,0,0,0,0,0,0,0    
 go    
 exec MB_JOB_GET_NORMAL_LIST_MULTI 0,1,15,'','','',1,0,0,0,0,0,0,0,0,0,0    
 go    
     
 exec MB_JOB_GET_NORMAL_LIST_MULTI 0,2,15,'12','','0',0,0,0,0,0,0,0,0,0,0,0    
    
 exec [dbo].[MB_JOB_GET_NORMAL_LIST_MULTI] @TOTAL_COUNT=0,@PAGE=1,@PAGESIZE=15,@AREA='27',@CATE='',@TERM='',@SORT=0,@DAY_WEEK=0,@DAY_WEEK_NEGO=0,@TIME=0,@TIME_FROM=0,@TIME_TO=0,@TIME_NEGO=0,@AGE=0,@AGE_N=0,@SEX=0,@SEX_N=0,@IPADDR='',@CUID=''    
    
 EXEC sp_recompile 'MB_JOB_GET_NORMAL_LIST_MULTI'    
    
*************************************************************************************/    
ALTER PROC [dbo].[MB_JOB_GET_NORMAL_LIST_MULTI]    
 @TOTAL_COUNT INT = 0     /* ��üī��Ʈ (���� 0�϶��� ī��Ʈ���� ����) */    
, @PAGE INT = 1    
, @PAGESIZE TINYINT = 15    
, @AREA VARCHAR(100) = ''    /* �����ڵ� */    
, @CATE VARCHAR(100) = ''    /* ��/�����ڵ� */    
, @TERM VARCHAR(10) = ''    /* ����ϰ��� TERM('':��ü, 0:����, 3:������) */    
, @SORT TINYINT = 0       /* ���� (0:�ֽż�, 1:������) */    
, @DAY_WEEK TINYINT = 0     /* �ٹ��� �˻� (0:�ٹ��� ��ü, 1:��4~6��, 2:��1~3��, 3:�ָ�) */    
, @DAY_WEEK_NEGO TINYINT = 0  /* �ٹ��� ���� (1:����) */    
, @TIME TINYINT = 0       /* �ٹ��ð�(0:�ٹ��ð� ��ü, 1:��ð��ٹ�(4�ð��ʰ�), 2:�ܽð��ٹ�(4�ð��̸�), 3:�������� */    
, @TIME_FROM INT = 0      /* 3:�������� - ���۽ð� */    
, @TIME_TO INT = 0       /* 3:�������� - ����ð� */    
, @TIME_NEGO TINYINT = 0    /* �ٹ��ð� ���� (1:����) */    
, @AGE INT = 0         /* ����(�����Է�) */    
, @AGE_N TINYINT = 0      /* ���ɹ���(1:����) */    
, @SEX TINYINT = 0       /* ����(0:��ü, 1:����, 2:����) */    
, @SEX_N TINYINT = 0      /* ��������(1:����) */    
, @IPADDR VARCHAR(50) = NULL    
, @CUID INT = NULL    
AS    
BEGIN     
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
 --SET ARITHABORT ON;    
 --SET ARITHABORT OFF;    
/*    
    
 select 1 where 1=2    
 return     
*/    
    
    
     
 DECLARE @SQL NVARCHAR(MAX) = ''    
     
 DECLARE @SQL_JOIN NVARCHAR(MAX) = ''    
 DECLARE @SQL_JOIN_AREA NVARCHAR(1000) = ''    
 DECLARE @SQL_JOIN_CATE NVARCHAR(1000) = ''    
 DECLARE @SQL_JOIN_WORK NVARCHAR(1000) = ''    
    
 DECLARE @SQL_WHERE NVARCHAR(MAX) = ''    
 DECLARE @SQL_WHERE_AREA NVARCHAR(4000) = ''    
 DECLARE @SQL_WHERE_CATE NVARCHAR(4000) = ''    
 DECLARE @SQL_WHERE_WORK NVARCHAR(4000) = ''    
    
 DECLARE @SQL_PARAM NVARCHAR(MAX) = ''    
     
 DECLARE @SQL_ORDERBY VARCHAR(400) = ''    
    
 -- ���� ���� �˻��� ���    
 DECLARE @AREA_COUNT INT = 0    
 DECLARE @IDX_AREA_A_CODE_1 TINYINT, @IDX_AREA_B_CODE_1 SMALLINT, @IDX_AREA_C_CODE_1 INT    
 DECLARE @IDX_AREA_A_CODE_2 TINYINT, @IDX_AREA_B_CODE_2 SMALLINT, @IDX_AREA_C_CODE_2 INT    
 DECLARE @IDX_AREA_A_CODE_3 TINYINT, @IDX_AREA_B_CODE_3 SMALLINT, @IDX_AREA_C_CODE_3 INT    
 DECLARE @IDX_AREA_A_CODE_4 TINYINT, @IDX_AREA_B_CODE_4 SMALLINT, @IDX_AREA_C_CODE_4 INT    
 DECLARE @IDX_AREA_A_CODE_5 TINYINT, @IDX_AREA_B_CODE_5 SMALLINT, @IDX_AREA_C_CODE_5 INT    
    
 -- ���� ��/���� �˻��� ���    
 DECLARE @CATE_COUNT INT = 0    
 DECLARE @IDX_CODE2_1 INT, @IDX_CODE3_1 INT, @IDX_CODE4_1 INT    
 DECLARE @IDX_CODE2_2 INT, @IDX_CODE3_2 INT, @IDX_CODE4_2 INT    
 DECLARE @IDX_CODE2_3 INT, @IDX_CODE3_3 INT, @IDX_CODE4_3 INT    
 DECLARE @IDX_CODE2_4 INT, @IDX_CODE3_4 INT, @IDX_CODE4_4 INT    
 DECLARE @IDX_CODE2_5 INT, @IDX_CODE3_5 INT, @IDX_CODE4_5 INT    
     
 DECLARE @TIME_TERM INT = 0 --�ٹ��ð�    
 DECLARE @MAXDOP char(1) = '4'    
 DECLARE @DBA_START_TIME  datetime = getdate()    
 DECLARE @DBA_END_TIME INT       
 /* �����˻� */    
 IF @AREA <> '' BEGIN    
    
  --SET @SQL_JOIN_AREA = ' INNER JOIN PP_LINE_AD_AREA_1DAY_TB AS PA WITH(NOLOCK) ON PA.LINEADID = A.LINEADID AND PA.INPUT_BRANCH = A.INPUT_BRANCH AND PA.LAYOUT_BRANCH = A.LAYOUT_BRANCH ' + CHAR(10)    
    
  --// ������������ üũ �� ����ó���� ���� ���̺� ����    
  DECLARE @AREA_TMP_TABLE TABLE (IDX INT, VALUE INT)    
  INSERT INTO @AREA_TMP_TABLE    
  SELECT * FROM DBO.FN_SPLIT_TO_TB(@AREA, ',')    
       
  SET @AREA_COUNT = (SELECT COUNT(*) FROM @AREA_TMP_TABLE)    
    
  IF @AREA_COUNT = 1 BEGIN    
   --// ���ϰ˻�    
    
      /* 2020.01.15, ����� �˻� ���� �� ������ ���� �α� ����    
   -- 2020.02.17, �α� ���� �Ϸ�    
      INSERT INTO LOGDB.DBO.PP_JOB_MOBILE_AREA_ROWS_LOG_TB(AREA_CODE) VALUES(LEFT(CAST(@AREA AS VARCHAR) + '00000000', 8))    
   */    
    
   IF LEN(@AREA) = 2 BEGIN    
    --��/��    
    SET @SQL_WHERE_AREA += ' PA.AREA_A_CODE = @AREA ' + CHAR(10)    
   END    
   ELSE IF LEN(@AREA) = 4 BEGIN    
    --��/��/��    
    IF @SQL_WHERE_AREA <> '' BEGIN    
     SET @SQL_WHERE_AREA += ' AND '    
    END    
    SET @SQL_WHERE_AREA += ' PA.AREA_B_CODE = @AREA ' + CHAR(10)    
   END    
   ELSE IF LEN(@AREA) = 8 BEGIN    
    --��/��/��    
    IF @SQL_WHERE_AREA <> '' BEGIN    
     SET @SQL_WHERE_AREA += ' AND '    
    END    
    SET @SQL_WHERE_AREA += ' PA.AREA_C_GROUP = @AREA ' + CHAR(10)    
   END    
    
  END    
  ELSE BEGIN    
   --// ���߰˻�    
   DECLARE @INNER_OR_AREA NVARCHAR(2000) = ''    
   DECLARE @TMP_AREA_CODE INT    
   DECLARE @I_AREA INT = 0    
   --//�˻� ������ŭ..    
   SET @MAXDOP = '1'    
   WHILE @I_AREA < @AREA_COUNT BEGIN    
        
    SELECT @TMP_AREA_CODE = VALUE    
    FROM @AREA_TMP_TABLE    
    WHERE IDX = @I_AREA    
    
  /* 2020.01.15, ����� �˻� ���� �� ������ ���� �α� ����    
  -- 2020.02.17, �α� ���� �Ϸ�    
        INSERT INTO LOGDB.DBO.PP_JOB_MOBILE_AREA_ROWS_LOG_TB(AREA_CODE) VALUES(LEFT(CAST(@TMP_AREA_CODE AS VARCHAR) + '00000000', 8))    
  */    
    
    IF LEN(@TMP_AREA_CODE) = 2 BEGIN    
     --�Ķ���ͺ��� ó��    
     IF @I_AREA = 0 BEGIN    
      SET @IDX_AREA_A_CODE_1 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 1 BEGIN    
      SET @IDX_AREA_A_CODE_2 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 2 BEGIN    
      SET @IDX_AREA_A_CODE_3 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 3 BEGIN    
      SET @IDX_AREA_A_CODE_4 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 4 BEGIN    
      SET @IDX_AREA_A_CODE_5 = @TMP_AREA_CODE    
     END    
         
    END    
    ELSE IF LEN(@TMP_AREA_CODE) = 4 BEGIN    
     --�Ķ���ͺ��� ó��    
     IF @I_AREA = 0 BEGIN    
      SET @IDX_AREA_B_CODE_1 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 1 BEGIN    
      SET @IDX_AREA_B_CODE_2 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 2 BEGIN    
      SET @IDX_AREA_B_CODE_3 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 3 BEGIN    
      SET @IDX_AREA_B_CODE_4 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 4 BEGIN    
      SET @IDX_AREA_B_CODE_5 = @TMP_AREA_CODE    
     END    
    
    END    
    ELSE IF LEN(@TMP_AREA_CODE) = 8 BEGIN    
     --�Ķ���ͺ��� ó��    
     IF @I_AREA = 0 BEGIN    
      SET @IDX_AREA_C_CODE_1 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 1 BEGIN    
      SET @IDX_AREA_C_CODE_2 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 2 BEGIN    
      SET @IDX_AREA_C_CODE_3 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 3 BEGIN    
      SET @IDX_AREA_C_CODE_4 = @TMP_AREA_CODE    
     END    
     ELSE IF @I_AREA = 4 BEGIN    
      SET @IDX_AREA_C_CODE_5 = @TMP_AREA_CODE    
     END    
    
    END       
    
    SET @I_AREA = @I_AREA + 1    
   END    
    
   --��/��    
   IF @IDX_AREA_A_CODE_1 IS NOT NULL OR @IDX_AREA_A_CODE_2 IS NOT NULL OR @IDX_AREA_A_CODE_3 IS NOT NULL OR @IDX_AREA_A_CODE_4 IS NOT NULL OR @IDX_AREA_A_CODE_5 IS NOT NULL BEGIN    
        
    SET @SQL_WHERE_AREA += ' ('    
    IF @IDX_AREA_A_CODE_1 IS NOT NULL BEGIN    
     SET @INNER_OR_AREA += ' PA.AREA_A_CODE = @IDX_AREA_A_CODE_1 '    
    END    
    IF @IDX_AREA_A_CODE_2 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_A_CODE = @IDX_AREA_A_CODE_2 '    
    END    
    IF @IDX_AREA_A_CODE_3 IS NOT NULL BEGIN    
   IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_A_CODE = @IDX_AREA_A_CODE_3 '    
    END    
    IF @IDX_AREA_A_CODE_4 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_A_CODE = @IDX_AREA_A_CODE_4 '    
    END    
    IF @IDX_AREA_A_CODE_5 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_A_CODE = @IDX_AREA_A_CODE_5 '    
    END    
    SET @SQL_WHERE_AREA += @INNER_OR_AREA + ') '    
    
   END    
   --��/��/��    
   IF @IDX_AREA_B_CODE_1 IS NOT NULL OR @IDX_AREA_B_CODE_2 IS NOT NULL OR @IDX_AREA_B_CODE_3 IS NOT NULL OR @IDX_AREA_B_CODE_4 IS NOT NULL OR @IDX_AREA_B_CODE_5 IS NOT NULL BEGIN    
    IF @SQL_WHERE_AREA <> '' BEGIN    
     SET @SQL_WHERE_AREA += ' OR '    
    END    
    
    SET @INNER_OR_AREA = ''    
    
    SET @SQL_WHERE_AREA += ' ('        
    IF @IDX_AREA_B_CODE_1 IS NOT NULL BEGIN    
     SET @INNER_OR_AREA += ' PA.AREA_B_CODE = @IDX_AREA_B_CODE_1 '    
    END    
    IF @IDX_AREA_B_CODE_2 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_B_CODE = @IDX_AREA_B_CODE_2 '    
    END    
    IF @IDX_AREA_B_CODE_3 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_B_CODE = @IDX_AREA_B_CODE_3 '    
    END    
    IF @IDX_AREA_B_CODE_4 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_B_CODE = @IDX_AREA_B_CODE_4 '    
    END    
    IF @IDX_AREA_B_CODE_5 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_B_CODE = @IDX_AREA_B_CODE_5 '    
    END    
    SET @SQL_WHERE_AREA += @INNER_OR_AREA + ') '    
    
   END    
   --��/��/��    
   IF @IDX_AREA_C_CODE_1 IS NOT NULL OR @IDX_AREA_C_CODE_2 IS NOT NULL OR @IDX_AREA_C_CODE_3 IS NOT NULL OR @IDX_AREA_C_CODE_4 IS NOT NULL OR @IDX_AREA_C_CODE_5 IS NOT NULL BEGIN    
    IF @SQL_WHERE_AREA <> '' BEGIN    
     SET @SQL_WHERE_AREA += ' OR '    
    END    
        
    SET @INNER_OR_AREA = ''    
    
    SET @SQL_WHERE_AREA += ' ('    
    IF @IDX_AREA_C_CODE_1 IS NOT NULL BEGIN    
     SET @INNER_OR_AREA += ' PA.AREA_C_GROUP = @IDX_AREA_C_CODE_1 '    
    END    
    IF @IDX_AREA_C_CODE_2 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_C_GROUP = @IDX_AREA_C_CODE_2 '    
    END    
    IF @IDX_AREA_C_CODE_3 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_C_GROUP = @IDX_AREA_C_CODE_3 '    
    END    
    IF @IDX_AREA_C_CODE_4 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_C_GROUP = @IDX_AREA_C_CODE_4 '    
    END    
    IF @IDX_AREA_C_CODE_5 IS NOT NULL BEGIN    
     IF @INNER_OR_AREA <> '' BEGIN    
      SET @INNER_OR_AREA += ' OR '    
     END    
     SET @INNER_OR_AREA += ' PA.AREA_C_GROUP = @IDX_AREA_C_CODE_5 '    
    END    
    SET @SQL_WHERE_AREA += @INNER_OR_AREA + ') '    
    
   END    
    
  END    
    
  --��������    
  IF @SQL_WHERE_AREA <> '' BEGIN    
       
   --SET @SQL_WHERE += ' AND (' + @SQL_WHERE_AREA + ') ' + CHAR(10)    
    
   SET @SQL_JOIN_AREA = '    
    INNER JOIN     
    (SELECT PA.LINEADID, PA.INPUT_BRANCH, PA.LAYOUT_BRANCH     
     FROM PP_LINE_AD_AREA_1DAY_TB AS PA WITH(NOLOCK)     
     WHERE ' + @SQL_WHERE_AREA + '    
     GROUP BY PA.LINEADID, PA.INPUT_BRANCH, PA.LAYOUT_BRANCH) AS TMP_AREA    
    ON TMP_AREA.LINEADID = A.LINEADID AND TMP_AREA.INPUT_BRANCH = A.INPUT_BRANCH AND TMP_AREA.LAYOUT_BRANCH = A.LAYOUT_BRANCH    
   '    
    
  END    
    
 END    
    
 /* ��/�����˻� */    
 IF @CATE <> '' BEGIN    
    
  --SET @SQL_JOIN_CATE = ' INNER JOIN PP_LINE_AD_FINDCODE_1DAY_TB AS PC WITH(NOLOCK) ON PC.LINEADID = A.LINEADID AND PC.INPUT_BRANCH = A.INPUT_BRANCH AND PC.LAYOUT_BRANCH = A.LAYOUT_BRANCH ' + CHAR(10)    
    
  --// ������������ üũ �� ����ó���� ���� ���̺� ����    
  DECLARE @FINDCODE_JOIN NVARCHAR(200) = ''    
  DECLARE @CATE_TMP_TABLE TABLE (IDX INT, VALUE INT)    
  INSERT INTO @CATE_TMP_TABLE    
  SELECT * FROM DBO.FN_SPLIT_TO_TB(@CATE, ',')    
    
  SET @CATE_COUNT = (SELECT COUNT(*) FROM @CATE_TMP_TABLE)    
      
  IF @CATE_COUNT = 1 BEGIN    
   --// ���ϰ˻�    
       
   IF LEN(@CATE) = 7 BEGIN    
    SET @SQL_WHERE_CATE += ' PC.FINDCODE = @CATE ' + CHAR(10)    
   END    
   ELSE IF LEN(@CATE) = 5 BEGIN    
    --SET @SQL_JOIN_CATE += ' INNER JOIN PP_FINDCODE_TB AS F WITH(NOLOCK) ON F.CODE4 = PC.FINDCODE ' + CHAR(10)    
       --SET @SQL_WHERE_CATE += '  PC.FINDCODE  IN (SELECT CODE4 FROM PP_FINDCODE_TB AS F WITH(NOLOCK) WHERE F.CODE3 = @CATE ) ' + CHAR(10)    
       SET @SQL_WHERE_CATE += '  PC.FINDCODE  BETWEEN  @CATE * 100 AND @CATE * 100 + 99 ' + CHAR(10)    
    
    --SET @FINDCODE_JOIN = ' INNER JOIN PP_FINDCODE_TB AS F WITH(NOLOCK) ON F.CODE4 = PC.FINDCODE ' + CHAR(10)    
    --SET @SQL_WHERE_CATE += ' F.CODE3 = @CATE ' + CHAR(10)    
   END    
   ELSE BEGIN    
    -- ���� ����(���ؿ�)    
    SET @SQL_WHERE_CATE += ' PC.FINDCODE >= @CATE + ''0000'' AND PC.FINDCODE <  @CATE + ''9999'' ' + CHAR(10)    
   END    
    
  END    
  ELSE BEGIN    
   --// ���߰˻�    
   DECLARE @INNER_OR_CATE NVARCHAR(2000) = ''    
   DECLARE @TMP_CATE_CODE INT    
   DECLARE @I_CATE INT = 0    
   --//�˻� ������ŭ..    
   WHILE @I_CATE < @CATE_COUNT BEGIN    
        
    SELECT @TMP_CATE_CODE = VALUE    
    FROM @CATE_TMP_TABLE    
    WHERE IDX = @I_CATE    
    
    IF LEN(@TMP_CATE_CODE) = 3 BEGIN    
     --�Ķ���ͺ��� ó��    
     IF @I_CATE = 0 BEGIN    
      SET @IDX_CODE2_1 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 1 BEGIN    
      SET @IDX_CODE2_2 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 2 BEGIN    
      SET @IDX_CODE2_3 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 3 BEGIN    
      SET @IDX_CODE2_4 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 4 BEGIN    
      SET @IDX_CODE2_5 = @TMP_CATE_CODE    
     END    
    
    END    
    ELSE IF LEN(@TMP_CATE_CODE) = 5 BEGIN    
     --�Ķ���ͺ��� ó��    
     IF @I_CATE = 0 BEGIN    
      SET @IDX_CODE3_1 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 1 BEGIN    
      SET @IDX_CODE3_2 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 2 BEGIN    
      SET @IDX_CODE3_3 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 3 BEGIN    
      SET @IDX_CODE3_4 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 4 BEGIN    
      SET @IDX_CODE3_5 = @TMP_CATE_CODE    
     END    
    
    END    
    ELSE IF LEN(@TMP_CATE_CODE) = 7 BEGIN    
     --�Ķ���ͺ��� ó��    
     IF @I_CATE = 0 BEGIN    
      SET @IDX_CODE4_1 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 1 BEGIN    
      SET @IDX_CODE4_2 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 2 BEGIN    
      SET @IDX_CODE4_3 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 3 BEGIN    
      SET @IDX_CODE4_4 = @TMP_CATE_CODE    
     END    
     ELSE IF @I_CATE = 4 BEGIN    
      SET @IDX_CODE4_5 = @TMP_CATE_CODE    
     END    
    
    END    
    
    SET @I_CATE = @I_CATE + 1    
   END    
    
   --��з�       
   IF @IDX_CODE2_1 IS NOT NULL OR @IDX_CODE2_2 IS NOT NULL OR @IDX_CODE2_3 IS NOT NULL OR @IDX_CODE2_4 IS NOT NULL OR @IDX_CODE2_5 IS NOT NULL BEGIN    
        
    SET @SQL_WHERE_CATE += ' ('    
    IF @IDX_CODE2_1 IS NOT NULL BEGIN    
     SET @INNER_OR_CATE += ' (PC.FINDCODE BETWEEN (@IDX_CODE2_1 * 10000) AND ((@IDX_CODE2_1 * 10000) + 10000)) '    
    END    
    IF @IDX_CODE2_2 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
 SET @INNER_OR_CATE += ' (PC.FINDCODE BETWEEN (@IDX_CODE2_2 * 10000) AND ((@IDX_CODE2_2 * 10000) + 10000)) '    
    END    
    IF @IDX_CODE2_3 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' (PC.FINDCODE BETWEEN (@IDX_CODE2_3 * 10000) AND ((@IDX_CODE2_3 * 10000) + 10000)) '    
    END    
    IF @IDX_CODE2_4 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' (PC.FINDCODE BETWEEN (@IDX_CODE2_4 * 10000) AND ((@IDX_CODE2_4 * 10000) + 10000)) '    
    END    
    IF @IDX_CODE2_5 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' (PC.FINDCODE BETWEEN (@IDX_CODE2_5 * 10000) AND ((@IDX_CODE2_5 * 10000) + 10000)) '    
    END    
    SET @SQL_WHERE_CATE += @INNER_OR_CATE + ') '    
   END    
   --�ߺз�    
   IF @IDX_CODE3_1 IS NOT NULL OR @IDX_CODE3_2 IS NOT NULL OR @IDX_CODE3_3 IS NOT NULL OR @IDX_CODE3_4 IS NOT NULL OR @IDX_CODE3_5 IS NOT NULL BEGIN    
    IF @SQL_WHERE_CATE <> '' BEGIN    
     SET @SQL_WHERE_CATE += ' OR '         
    END    
    
    SET @INNER_OR_CATE = ''    
    
    SET @SQL_WHERE_CATE += ' ('    
    IF @IDX_CODE3_1 IS NOT NULL BEGIN    
     SET @INNER_OR_CATE += ' (PC.FINDCODE BETWEEN (@IDX_CODE3_1 * 100) AND ((@IDX_CODE3_1 * 100) + 100)) '    
    END    
    IF @IDX_CODE3_2 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' (PC.FINDCODE BETWEEN (@IDX_CODE3_2 * 100) AND ((@IDX_CODE3_2 * 100) + 100)) '    
    END    
    IF @IDX_CODE3_3 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' (PC.FINDCODE BETWEEN (@IDX_CODE3_3 * 100) AND ((@IDX_CODE3_3 * 100) + 100)) '    
    END    
    IF @IDX_CODE3_4 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' (PC.FINDCODE BETWEEN (@IDX_CODE3_4 * 100) AND ((@IDX_CODE3_4 * 100) + 100)) '    
    END    
    IF @IDX_CODE3_5 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' (PC.FINDCODE BETWEEN (@IDX_CODE3_5 * 100) AND ((@IDX_CODE3_5 * 100) + 100)) '    
    END    
    SET @SQL_WHERE_CATE += @INNER_OR_CATE + ') '    
    
   END    
   --�Һз�    
   IF @IDX_CODE4_1 IS NOT NULL OR @IDX_CODE4_2 IS NOT NULL OR @IDX_CODE4_3 IS NOT NULL OR @IDX_CODE4_4 IS NOT NULL OR @IDX_CODE4_5 IS NOT NULL BEGIN    
    IF @SQL_WHERE_CATE <> '' BEGIN    
     SET @SQL_WHERE_CATE += ' OR '    
    END    
        
    SET @INNER_OR_CATE = ''    
    
    SET @SQL_WHERE_CATE += ' ('    
    IF @IDX_CODE4_1 IS NOT NULL BEGIN    
     SET @INNER_OR_CATE += ' PC.FINDCODE = @IDX_CODE4_1 '    
    END    
    IF @IDX_CODE4_2 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' PC.FINDCODE = @IDX_CODE4_2 '    
    END    
    IF @IDX_CODE4_3 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' PC.FINDCODE = @IDX_CODE4_3 '    
    END    
    IF @IDX_CODE4_4 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' PC.FINDCODE = @IDX_CODE4_4 '    
    END    
    IF @IDX_CODE4_5 IS NOT NULL BEGIN    
     IF @INNER_OR_CATE <> '' BEGIN    
      SET @INNER_OR_CATE += ' OR '    
     END    
     SET @INNER_OR_CATE += ' PC.FINDCODE = @IDX_CODE4_5 '    
    END    
    SET @SQL_WHERE_CATE += @INNER_OR_CATE + ') '    
    
   END    
    
  END    
    
  --��/���� ����       
  IF @SQL_WHERE_CATE <> '' BEGIN    
       
   --SET @SQL_WHERE += ' AND (' + @SQL_WHERE_CATE + ') ' + CHAR(10)    
    
   SET @SQL_JOIN_CATE = '    
    INNER JOIN     
    (SELECT PC.LINEADID, PC.INPUT_BRANCH, PC.LAYOUT_BRANCH     
     FROM PP_LINE_AD_FINDCODE_1DAY_TB AS PC WITH(NOLOCK) ' + @FINDCODE_JOIN + '    
     WHERE ' + @SQL_WHERE_CATE + '    
     GROUP BY PC.LINEADID, PC.INPUT_BRANCH, PC.LAYOUT_BRANCH) AS TMP_CATE    
    ON TMP_CATE.LINEADID = A.LINEADID AND TMP_CATE.INPUT_BRANCH = A.INPUT_BRANCH AND TMP_CATE.LAYOUT_BRANCH = A.LAYOUT_BRANCH    
   '    
    
  END    
    
 END    
    
 /* ##�ٹ�����## - �ٹ��� �˻� (0:�ٹ��� ��ü, 1:��4~6��, 2:��1~3��, 3:�ָ�) */    
 IF @DAY_WEEK = 1 OR @DAY_WEEK = 2 OR @DAY_WEEK = 3 BEGIN      
  IF @DAY_WEEK = 1 BEGIN    
   SET @SQL_WHERE_WORK += ' AND DD.DAY_WEEK IN (1, 2, 4, 5, 6 '     
    
   IF @DAY_WEEK_NEGO = 1 BEGIN    
    --����    
    SET @SQL_WHERE_WORK += ' , 10 '    
   END    
    
   SET @SQL_WHERE_WORK += ' ) ' + CHAR(10)    
  END    
  ELSE IF @DAY_WEEK = 2 BEGIN    
   SET @SQL_WHERE_WORK += ' AND DD.DAY_WEEK IN (7, 8, 9 '     
    
   IF @DAY_WEEK_NEGO = 1 BEGIN    
    --����    
    SET @SQL_WHERE_WORK += ' , 10 '    
   END    
    
   SET @SQL_WHERE_WORK += ' ) ' + CHAR(10)    
  END    
  ELSE IF @DAY_WEEK = 3 BEGIN    
   SET @SQL_WHERE_WORK += ' AND DD.DAY_WEEK IN (3 '     
    
   IF @DAY_WEEK_NEGO = 1 BEGIN    
    --����    
    SET @SQL_WHERE_WORK += ' , 10 '    
   END    
    
   SET @SQL_WHERE_WORK += ' ) ' + CHAR(10)    
  END    
 END    
    
 /* ##�ٹ�����## - �ٹ��ð�(0:�ٹ��ð� ��ü, 1:��ð��ٹ�(4�ð��ʰ�), 2:�ܽð��ٹ�(4�ð��̸�), 3:�������� */    
 IF @TIME = 1 OR @TIME = 2 OR @TIME = 3 BEGIN    
    
  --�ð�����    
  IF @TIME_NEGO = 1 BEGIN    
   SET @SQL_WHERE_WORK += ' AND ('    
  END    
  ELSE BEGIN    
   SET @SQL_WHERE_WORK += ' AND '    
  END    
    
  IF @TIME = 1 BEGIN    
   SET @TIME_TERM = 400    
   SET @SQL_WHERE_WORK += ' CASE WHEN DD.WORKTIMEFROM >= DD.WORKTIMETO THEN CASE WHEN (DD.WORKTIMETO + 2400) - DD.WORKTIMEFROM > @TIME_TERM THEN 1 ELSE 0 END ELSE CASE WHEN DD.WORKTIMETO - DD.WORKTIMEFROM > @TIME_TERM THEN 1 ELSE 0 END END = 1 '    
  END    
  ELSE IF @TIME = 2 BEGIN    
   SET @TIME_TERM = 400    
   SET @SQL_WHERE_WORK += ' CASE WHEN DD.WORKTIMEFROM >= DD.WORKTIMETO THEN CASE WHEN (DD.WORKTIMETO + 2400) - DD.WORKTIMEFROM <= @TIME_TERM THEN 1 ELSE 0 END ELSE CASE WHEN DD.WORKTIMETO - DD.WORKTIMEFROM <= @TIME_TERM THEN 1 ELSE 0 END END = 1 '    
  END    
  ELSE IF @TIME = 3 BEGIN     
    
   SET @TIME_FROM = (@TIME_FROM * 100)    
   SET @TIME_TO = (@TIME_TO * 100)    
    
   IF @TIME_FROM >= @TIME_TO BEGIN    
    
    SET @TIME_TERM = (@TIME_TO + 2400) - @TIME_FROM    
        
    SET @SQL_WHERE_WORK += ' (    
    DD.WORKTIMEF = 0 AND DD.WORKTIMEFROM > 0 AND DD.WORKTIMETO > 0         
    AND ( (((DD.WORKTIMEFROM >= @TIME_FROM OR DD.WORKTIMEFROM <= @TIME_TO) AND DD.WORKTIMETO <= @TIME_TO)     
    AND (CASE WHEN DD.WORKTIMEFROM >= DD.WORKTIMETO THEN CASE WHEN (DD.WORKTIMETO + 2400) - DD.WORKTIMEFROM < @TIME_TERM THEN 1 ELSE 0 END ELSE 0 END = 1))    
     OR (DD.WORKTIMEFROM < DD.WORKTIMETO AND DD.WORKTIMETO >= 0 AND DD.WORKTIMETO <= @TIME_TO) )    
    ) '    
        
   END     
   ELSE BEGIN    
    SET @SQL_WHERE_WORK += ' (DD.WORKTIMEF = 0 AND DD.WORKTIMEFROM > 0 AND DD.WORKTIMETO > 0 AND DD.WORKTIMEFROM < DD.WORKTIMETO AND DD.WORKTIMEFROM >= @TIME_FROM AND DD.WORKTIMETO <= @TIME_TO) '    
   END    
       
  END    
    
  --�ð�����    
  IF @TIME_NEGO = 1 BEGIN    
   SET @SQL_WHERE_WORK += ' OR DD.WORKTIMEF = 0 )' + CHAR(10)    
  END    
  ELSE BEGIN    
   SET @SQL_WHERE_WORK += '' + CHAR(10)    
  END    
 END    
    
 /* ##�ٹ�����## - ����(�����Է�) */    
 IF @AGE > 0 BEGIN    
  SET @SQL_WHERE_WORK += ' AND ((CASE WHEN DD.AGEFROM = 0 THEN 1 ELSE DD.AGEFROM END <= @AGE AND CASE WHEN DD.AGETO = 0 THEN 80 ELSE DD.AGETO END >= @AGE) '    
    
  --��������    
  IF @AGE_N = 1 BEGIN    
   SET @SQL_WHERE_WORK += ' OR DD.AGEF = 0) ' + CHAR(10)    
  END    
  ELSE BEGIN    
   SET @SQL_WHERE_WORK += ' AND DD.AGEF = 1) ' + CHAR(10)    
  END    
 END    
    
 /* ##�ٹ�����## - ����(0:��ü, 1:����, 2:����) */    
 IF @SEX = 1 OR @SEX = 2 BEGIN      
  IF @SEX_N = 1 BEGIN    
   SET @SQL_WHERE_WORK += ' AND  DD.SEXF IN (@SEX, 3) ' + CHAR(10)    
  END    
  ELSE BEGIN    
   SET @SQL_WHERE_WORK += ' AND  DD.SEXF = @SEX ' + CHAR(10)    
  END    
 END    
    
 --�ٹ�����    
 IF @SQL_WHERE_WORK <> '' BEGIN    
  SET @SQL_JOIN_WORK += ' INNER JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB AS DD WITH(NOLOCK) ON DD.LINEADID = A.LINEADID AND DD.INPUT_BRANCH = A.INPUT_BRANCH AND DD.LAYOUT_BRANCH = A.LAYOUT_BRANCH '    
  SET @SQL_WHERE += ' ' + @SQL_WHERE_WORK + ' '    
 END    
    
 /* ��ϱⰣ ���� - ('':��ü, 0:����, -3:������) */    
 IF @TERM != '' BEGIN    
    SET @SQL_WHERE = @SQL_WHERE + ' AND A.LISTUP_DT >= CONVERT(DATETIME, CONVERT(VARCHAR(10), DATEADD(DAY, CAST(@TERM AS INT), GETDATE()) ,120)) ' + CHAR(10)    
  END    
    
  IF @CUID IS NOT NULL AND @CUID <> '' BEGIN    
    SET @SQL_WHERE = @SQL_WHERE + ' AND CUID = @CUID '    
  END    
    
 -- JOIN    
 SET @SQL_JOIN = @SQL_JOIN_AREA + @SQL_JOIN_CATE + @SQL_JOIN_WORK    
    
 /* ��ü������ ���� ù�������ÿ��� ī��Ʈ���� �̽����ϵ��� @TOTAL_COUNT�� @PAGESIZE�� ���� ���� */    
 IF @TOTAL_COUNT = 0 AND @PAGE = 1 BEGIN    
  SET @PAGESIZE = @PAGESIZE + 1    
  SET @TOTAL_COUNT = @PAGESIZE    
 END    
    
 /* �Ķ���� ���� */    
 SET @SQL_PARAM = '@TOTAL_COUNT INT, @PAGE INT, @PAGESIZE TINYINT, @AREA VARCHAR(100), @CATE VARCHAR(100), @TERM VARCHAR(10), @TIME_FROM INT, @TIME_TO INT, @AGE INT, @SEX TINYINT, @IDX_AREA_A_CODE_1 TINYINT, @IDX_AREA_B_CODE_1 SMALLINT, @IDX_AREA_C_CODE_1 INT  , @IDX_AREA_A_CODE_2 TINYINT, @IDX_AREA_B_CODE_2 SMALLINT, @IDX_AREA_C_CODE_2 INT, @IDX_AREA_A_CODE_3 TINYINT, @IDX_AREA_B_CODE_3 SMALLINT, @IDX_AREA_C_CODE_3 INT, @IDX_AREA_A_CODE_4 TINYINT, @IDX_AREA_B_CODE_4 SMALLINT, @IDX_AREA_C_CODE_4 INT, @IDX_AREA_A_CODE_5 TINYINT , @IDX_AREA_B_CODE_5 SMALLINT, @IDX_AREA_C_CODE_5 INT, @IDX_CODE2_1 INT, @IDX_CODE3_1 INT, @IDX_CODE4_1 INT, @IDX_CODE2_2 INT, @IDX_CODE3_2 INT, @IDX_CODE4_2 INT, @IDX_CODE2_3 INT, @IDX_CODE3_3 INT, @IDX_CODE4_3 INT, @IDX_CODE2_4 INT,   @IDX_CODE3_4 INT, @IDX_CODE4_4 INT, @IDX_CODE2_5 INT, @IDX_CODE3_5 INT, @IDX_CODE4_5 INT, @TIME_TERM INT, @CUID INT'    
    
 /* ���� ���� */    
 SET @SQL_ORDERBY = ' A.LISTUP_DT DESC, A.START_DT DESC, A.REG_DT DESC '    
 /* ���� (0:�ֽż�, 1:�����ϼ�) */    
 IF @SORT = 1 BEGIN    
  SET @SQL_ORDERBY = ' CASE WHEN A.RECRUIT_END_DT < CONVERT(VARCHAR(10), GETDATE(), 120) THEN 1 ELSE A.RECRUIT_ALLWAYS_F END ASC, A.RECRUIT_END_DT ASC, A.LISTUP_DT DESC, A.START_DT DESC, A.REG_DT DESC '    
 END    
    
 /* ���� ���� */    
 SET @SQL += '    
 ;WITH LIST_CTE AS    
 (    
  SELECT    
 '    
      
 IF @TOTAL_COUNT > 0 BEGIN    
  SET @SQL += ' TOP  (@PAGE * @PAGESIZE) '    
 END    
      
 SET @SQL += '     
         A.LINEADID    
    , A.INPUT_BRANCH    
    , A.LAYOUT_BRANCH    
    , ROW_NUMBER() OVER (ORDER BY' + @SQL_ORDERBY + ') AS ROWNUM    
  FROM MOBILE_JOB_TB AS  A WITH(NOLOCK)    
  ' + @SQL_JOIN + '    
  WHERE 10001=10001    
  ' + @SQL_WHERE + '    
  /* GROUP BY A.LINEADID, A.INPUT_BRANCH, A.LAYOUT_BRANCH,' + REPLACE(REPLACE(@SQL_ORDERBY, 'ASC', ''), 'DESC', '') + ' */    
 )    
 SELECT TOP (@PAGESIZE)    
 '    
     
 IF @TOTAL_COUNT > 0 BEGIN    
  SET @SQL += ' @TOTAL_COUNT AS [TOTAL] '    
 END    
 ELSE BEGIN    
  SET @SQL += ' (SELECT   COUNT(*)   FROM LIST_CTE) AS [TOTAL] '    
  --SET @SQL += ' (SELECT MAX(ROWNUM) FROM LIST_CTE) AS [TOTAL] '    
 END    
    
 SET @SQL += '       
   , A.LINEADNO, A.LINEADID, A.INPUT_BRANCH, A.LAYOUT_BRANCH, A.AD_KIND, A.GROUP_CD, A.[VERSION]    
   ,  A.OPT_CODE, A.MOBILE_OPT_CODE, A.PAPER_OPT    
   , A.FIELD_2, dbo.fn_DelSpecCharTitle(ISNULL(L.WAIT_COMPANY , A.FIELD_6),A.[VERSION]) AS FIELD_6, A.DETAILADCODE, A.ORDER_NAME    
   , A.FINDCODE, A.FINDCODENAME2 AS CODENM2, A.FINDCODENAME3 AS CODENM3, A.FINDCODENAME4 AS CODENM4    
   , dbo.fn_DelSpecCharTitle(ISNULL(L.WAIT_TITLE , A.TITLE),A.[VERSION]) AS TITLE, A.CONTENTS    
   , A.AREA_A, A.AREA_B, A.AREA_C, A.AREA_DONG    
   , A.RECRUIT_END_DT    
   , DATEDIFF(DAY, A.RECRUIT_END_DT, GETDATE()) AS DDAY    
   , A.PAYF, A.PAYFROM, A.PAYTO    
   , E.REGULAREMPF    
   , A.RECRUIT_ALLWAYS_F    
   , E.DAY_WEEK        
   , E.DAY_WEEK_OPTION    
   , ISNULL(E.DAY_WEEK_OPTION_ETC, '''') AS DAY_WEEK_OPTION_ETC    
   , E.WORKTIMEF    
   , ISNULL(E.WORKTIMEFROM, 0) AS WORKTIMEFROM    
   , ISNULL(E.WORKTIMETO, 0) AS WORKTIMETO    
   , ISNULL(E.UPRIGHT_AGREE, 0) AS UPRIGHT_AGREE    
   , ISNULL(E.PAY_POSSIBLE, 0) AS PAY_POSSIBLE    
   , ISNULL(E.PAY_COMPANY_RULES, 0) AS PAY_COMPANY_RULES    
   , ISNULL(E.PAY_COMPANY_RULES_ETC, '''') AS PAY_COMPANY_RULES_ETC    
   , ISNULL(P.EX_IMAGE_1, '''') AS EX_IMAGE_1    
   , ISNULL(P.EX_IMAGE_2, '''') AS EX_IMAGE_2    
   , ISNULL(P.EX_IMAGE_3, '''') AS EX_IMAGE_3    
   , ISNULL(P.EX_IMAGE_4, '''') AS EX_IMAGE_4    
   , E.WORKTIMEDISPLAY    
   , E.REAL_WORKTIMEDISPLAY   
   , E.WORKTIME_CODE  
   , E.DAY_WEEK_OPTION2  
   ,(CASE WHEN ISNULL(E.REAL_WORKTIME, 0) > 0 THEN CONVERT(FLOAT, E.REAL_WORKTIME) / 60 ELSE 0 END) AS REAL_WORKTIME2 --���� �ٹ��ð� �д������� �ð������� ��ȯ      
  , B.AREA_COUNT  
 FROM LIST_CTE TA      
 INNER JOIN MOBILE_JOB_TB AS A WITH(NOLOCK) ON A.LINEADID = TA.LINEADID AND A.INPUT_BRANCH = TA.INPUT_BRANCH AND A.LAYOUT_BRANCH = TA.LAYOUT_BRANCH  
 INNER JOIN PP_LINE_AD_AREA_1DAY_TB AS B WITH(NOLOCK) ON B.LINEADID = A.LINEADID AND B.INPUT_BRANCH = A.INPUT_BRANCH AND B.LAYOUT_BRANCH = A.LAYOUT_BRANCH AND B.[ORDER] = 1  
 INNER JOIN PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB AS E WITH(NOLOCK) ON E.LINEADID = TA.LINEADID AND E.INPUT_BRANCH = TA.INPUT_BRANCH AND E.LAYOUT_BRANCH = TA.LAYOUT_BRANCH    
 INNER JOIN PP_LINE_AD_TB AS P WITH(NOLOCK) ON P.LINEADID = TA.LINEADID AND P.INPUT_BRANCH = TA.INPUT_BRANCH AND P.LAYOUT_BRANCH = TA.LAYOUT_BRANCH    
 LEFT JOIN PP_LOGO_OPTION_TB AS L WITH(NOLOCK) ON L.LINEADID = TA.LINEADID AND L.INPUT_BRANCH = TA.INPUT_BRANCH AND L.LAYOUT_BRANCH = TA.LAYOUT_BRANCH    
 WHERE TA.ROWNUM > ((@PAGE-1) * @PAGESIZE) AND TA.ROWNUM <= ((@PAGE) * @PAGESIZE)    
 --WHERE TA.ROWNUM BETWEEN ((@PAGE-1) * @PAGESIZE) AND ((@PAGE) * @PAGESIZE)    
 OPTION (MAXDOP '+@MAXDOP+')    
 '    
      
 -- PRINT convert(text,@SQL)    
    
 SET @SQL_PARAM = REPLACE(@SQL_PARAM, 'OUTPUT' ,'') --//����¡������ OUTPUT �� �����Ƿ� REPLACE ó��    
 EXEC SP_EXECUTESQL @SQL, @SQL_PARAM, @TOTAL_COUNT, @PAGE, @PAGESIZE, @AREA, @CATE, @TERM, @TIME_FROM, @TIME_TO, @AGE, @SEX, @IDX_AREA_A_CODE_1, @IDX_AREA_B_CODE_1, @IDX_AREA_C_CODE_1, @IDX_AREA_A_CODE_2, @IDX_AREA_B_CODE_2, @IDX_AREA_C_CODE_2, @IDX_AREA_A_CODE_3, @IDX_AREA_B_CODE_3, @IDX_AREA_C_CODE_3, @IDX_AREA_A_CODE_4, @IDX_AREA_B_CODE_4, @IDX_AREA_C_CODE_4, @IDX_AREA_A_CODE_5, @IDX_AREA_B_CODE_5, @IDX_AREA_C_CODE_5, @IDX_CODE2_1, @IDX_CODE3_1, @IDX_CODE4_1, @IDX_CODE2_2, @IDX_CODE3_2, @IDX_CODE4_2, @IDX_CODE2_3, @IDX_CODE3_3, @IDX_CODE4_3, @IDX_CODE2_4, @IDX_CODE3_4, @IDX_CODE4_4, @IDX_CODE2_5, @IDX_CODE3_5, @IDX_CODE4_5, @TIME_TERM, @CUID    
 PRINT @MAXDOP  
   PRINT @SQL  
 SET @DBA_END_TIME = DATEDIFF(SS,@DBA_START_TIME,GETDATE())     
     
 IF  @DBA_END_TIME >  3 BEGIN    
  EXEC STATS.dbo.DBA_EXECUTE_PLAN_ERROR_LOG_INS 1,@DBA_END_TIME,@IPADDR    
 END     
     
     
END    
    
  
  
  
   