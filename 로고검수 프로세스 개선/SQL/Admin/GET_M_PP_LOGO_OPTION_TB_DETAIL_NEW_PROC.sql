/*************************************************************************************
 *  ���� ���� �� : ������ - E-COMM �ΰ����� ��
 *  ��   ��   �� : �� �� ȭ
 *  ��   ��   �� : 2013/10/17
 *  ��   ��   �� : �� �� ��        
 *  ��   ��   �� : 2021/10/12 
 *  �� �� ��  �� : �ΰ�˼� ���μ��� ����
 *  �� ��  �� �� :
 *  �� ��  �� �� : EXEC DBO.GET_M_PP_LOGO_OPTION_TB_DETAIL_NEW_PROC 37432, 200, 122
 *************************************************************************************/
ALTER PROC [dbo].[GET_M_PP_LOGO_OPTION_TB_DETAIL_NEW_PROC]
(
  @LINEADID         INT
, @INPUTBRANCH     INT
, @LAYOUTBRANCH     INT
)
AS

BEGIN
  SET NOCOUNT ON


  SELECT ISNULL(B.MAIN_TITLE, A.TITLE) AS MAIN_TITLE
       , ISNULL(B.MAIN_COMPANY, A.FIELD_6) AS MAIN_COMPANY
       , CASE WHEN ISNULL(B.MAIN_LOGO,'')='' THEN B.PUB_LOGO ELSE B.MAIN_LOGO END AS MAIN_LOGO
       , A.TITLE
       , A.FIELD_6
       , B.WAIT_LOGO
       , B.PUB_CONFIRM
       , CONVERT(VARCHAR(10),C.OPT_START_DT,11)
       , CONVERT(VARCHAR(10),C.OPT_END_DT,11)
       , C.OPT_CODE
       , A.FINDCODE
       , B.IMPACT_LOGO
       , CASE WHEN C.PAPER_OPT & 16 = 16 THEN 1 ELSE 0 END  AS COLOR_OPT
       , CASE WHEN (CASE WHEN C.PAPER_OPT & 32 = 32 THEN 1 ELSE 0 END) = 1 THEN 1
         WHEN (CASE WHEN C.PAPER_OPT & 64 = 64 THEN 1 ELSE 0 END) = 1 THEN 2
     ELSE 0 END BG_OPT
      , C.DISPLAY_OPT
       , B.THEME_IMG
       , ISNULL(B.WAIT_LOGO_BYTE, 0) AS WAIT_LOGO_BYTE
       , ISNULL(B.MAIN_LOGO_BYTE, 0) AS MAIN_LOGO_BYTE
    FROM PP_AD_TB (NOLOCK) AS A
    LEFT JOIN PP_LOGO_OPTION_TB (NOLOCK) AS B ON A.LINEADID = B.LINEADID AND A.INPUT_BRANCH = B.INPUT_BRANCH AND A.LAYOUT_BRANCH = B.LAYOUT_BRANCH
    LEFT JOIN PP_OPTION_TB (NOLOCK) AS C ON A.LINEADID = C.LINEADID AND A.INPUT_BRANCH = C.INPUT_BRANCH AND A.LAYOUT_BRANCH = C.LAYOUT_BRANCH
   WHERE A.LINEADID = @LINEADID
     AND A.INPUT_BRANCH = @INPUTBRANCH
     AND A.LAYOUT_BRANCH = @LAYOUTBRANCH

END



