



/*************************************************************************************
 *  ���� ���� �� : ������� ���� > ���� �⺻ ���� ��������
 *  ��   ��   �� : �� �� �� (virtualman@mediawill.com)
 *  ��   ��   �� : 2013/07/31
 *  ��   ��   �� : �� �� �� (stari@mediawill.com)
 *  ��   ��   �� : 2013/11/21
 *  �� ��  �� �� : �ɼ��ڵ� ���濡 ���� ����
 *  ��   ��   �� : �輱ȣ
 *  ��   ��   �� : 2021/04/27
 *  �� ��  �� �� : ����� �߰�
 *  ��   ��   �� : �� �� ��        
 *  ��   ��   �� : 2021/10/12 
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����
 *  ��        �� :
 *  �� ��  �� �� :
 *  �� ��  �� �� :
 *  �� ��  �� �� :
 EXEC DBO.GET_M_JOB_AD_BASIC_INFO_PROC 111529111, 80, 80, ''
 *************************************************************************************/


ALTER PROC [dbo].[GET_M_JOB_AD_BASIC_INFO_PROC]

  @LINEADID INT
  ,@INPUT_BRANCH TINYINT
  ,@LAYOUT_BRANCH TINYINT
  ,@AD_TYPE VARCHAR(8)   = ''

  ,@ADMINID varchar (30) = ''
  ,@IP varchar (15) = ''

AS

BEGIN

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  -- UNIQUEKEY(LINEADNO) ����
  DECLARE @LINEADNO CHAR(16)
  SET @LINEADNO = dbo.FN_LINEADNO(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH)

  SELECT ISNULL(B.PAPER_OPT, 0) AS PAPER_OPT
    ,A.AREA_A
    ,A.AREA_B
    ,A.AREA_C
    ,A.AREA_DETAIL
    ,A.ORDER_NAME
    ,A.PHONE
    ,A.FIELD_3
    ,CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN ISNULL(PLO.WAIT_COMPANY , A.FIELD_6)  ELSE A.FIELD_6 END AS FIELD_6
    ,A.FIELD_11
    ,A.START_DT
    ,A.END_DT
    ,A.USER_ID
    ,A.MAG_ID
    ,ISNULL(B.ICON_OPT, 0) AS ICON_OPT
    ,CASE WHEN dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUT_BRANCH,@LAYOUT_BRANCH) ='Y' THEN ISNULL(PLO.WAIT_TITLE , A.TITLE)  ELSE A.TITLE END AS TITLE
    ,A.LAYOUTCODE
    ,A.ORDER_EMAIL
    ,NULL AS HPHONE
    ,A.CONTENTS
    ,A.PRE_IMAGE
    ,A.INPUTCUST
    ,ISNULL(A.VNSNO,'') AS VNSNO
    ,A.CLASSCODE
    ,ISNULL(PBA.BR_SEQ,0) AS BR_SEQ
    ,ISNULL(PB.BRANCH_CODE,'') AS BRANCH_CODE
    ,ISNULL(LP.IssueCount,0) AS PAPERAD_ISSUECOUNT
    ,LP.StartDate AS PAPERAD_START_DT
    ,LP.EndDate AS PAPERAD_END_DT
    ,LP.LayoutBranch AS PAPERAD_PUB_BRANCHS
    ,A.VNSUSEF
    ,A.DELYN
    ,A.ENDYN
    ,PAPT.PARTNERF
    ,CASE WHEN PR.LINEADNO IS NOT NULL THEN 'Y' ELSE 'N' END AS RESERVE_YN
    ,PR.RESERVE_START_DT
    ,PR.RESERVE_END_DT
    ,A.CUID
    ,PAPT.FEDERATIONF
    ,PAPT.KINFAF
    ,PAPT.SENIORTVF
    ,ISNULL(WILLIANT.temp_key, '') AS TEMPADID
    ,A.REG_DT
  FROM PP_AD_TB A WITH(NOLOCK)
  LEFT JOIN PP_OPTION_TB B WITH(NOLOCK) ON A.LINEADID = B.LINEADID AND A.INPUT_BRANCH = B.INPUT_BRANCH AND A.LAYOUT_BRANCH = B.LAYOUT_BRANCH
  LEFT JOIN PP_BRAND_AD_TB AS PBA WITH(NOLOCK) ON PBA.LINEADID = A.LINEADID AND PBA.INPUT_BRANCH = A.INPUT_BRANCH AND PBA.LAYOUT_BRANCH = A.LAYOUT_BRANCH
  LEFT JOIN PP_BRAND_BRANCH_TB AS PB WITH(NOLOCK) ON PB.SEQ = PBA.BRANCH_SEQ
  LEFT JOIN PAPERREG.dbo.PP_ECOMM_LINEAD_LIST_VI AS LP WITH(NOLOCK) ON LP.ECOMM_LINEADID = A.LINEADID
  LEFT JOIN CY_FAT_AD_MAPPING_TB AS CM WITH(NOLOCK) ON CM.LINEADID = A.LINEADID AND CM.INPUT_BRANCH = A.INPUT_BRANCH AND CM.LAYOUT_BRANCH = A.LAYOUT_BRANCH
  LEFT JOIN PP_AD_RESERVE_TB AS PR WITH(NOLOCK) ON A.LINEADNO = PR.LINEADNO
  LEFT JOIN PP_AD_PARTNER_TB AS PAPT WITH(NOLOCK) ON A.LINEADNO = PAPT.LINEADNO
  LEFT JOIN PP_AD_WILLS_RELATION_TB AS WILLIANT WITH(NOLOCK) ON WILLIANT.lineadno = A.LINEADNO
  LEFT JOIN PP_LOGO_OPTION_TB AS PLO WITH(NOLOCK) ON A.LINEADID = PLO.LINEADID
  WHERE A.LINEADNO = @LINEADNO


    /* ��ȸ�α� ���� */
    IF @IP <> ''
      BEGIN

        DECLARE @USERID VARCHAR(50)
        DECLARE @CUID INT

        SELECT @USERID = CASE VERSION WHEN 'E' THEN USER_ID
                                      WHEN 'M' THEN USER_ID
                                      ELSE ''
                                      END
               ,@CUID = CASE VERSION WHEN 'E' THEN CUID
                                     WHEN 'M' THEN ISNULL(CUID,0)
                                     ELSE 0
                                     END
          FROM PP_AD_TB
         WHERE LINEADNO = @LINEADNO

        EXEC MAGUSER.DBO.PUT_MM_USER_LOG_VIEW_PROC
              'S122'
              , @ADMINID
              , @USERID
              , @CUID
              , @IP
              , 'V'
              , 0
              , 'LINEADNO'
              , @LINEADNO

      END

END
