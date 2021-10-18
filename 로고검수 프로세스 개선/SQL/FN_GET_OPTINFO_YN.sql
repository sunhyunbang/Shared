-- =============================================
-- Author:  방순현
-- Create date: 21.09.28
-- Description: 로고관리 상품 중 검수상태값 변경 여부 값 리턴
-- Return : 홈상품일 경우 : Y,그외 : N
-- SELECT dbo.FN_GET_OPTINFO_YN('113003723','180','180')
-- =============================================
ALTER FUNCTION FN_GET_OPTINFO_YN 
(
 @LINEADID             INT
  , @INPUT_BRANCH       INT
  , @LAYOUT_BRANCH      INT
)
RETURNS CHAR(1)
AS
BEGIN
 -- Declare the return variable here
 DECLARE @OPT_YN CHAR(1) = 'N'


 -- Add the T-SQL statements to compute the return value here
 /*홈상품 여부를 파악한다 21.09.23 */
 SELECT 
 @OPT_YN = CASE WHEN COUNT(LINEADID) > 0 THEN 'Y' ELSE 'N' END 
 FROM PP_OPTION_TB
 WHERE LINEADID = @LINEADID AND INPUT_BRANCH = @INPUT_BRANCH AND LAYOUT_BRANCH = @LAYOUT_BRANCH
 AND (OPT_CODE IN ('78','76','75','74','73','72','61','60','53','52','51','87') OR MOBILE_OPT_CODE IN('10','11','12') ) --홈상품,키워드 상품

 -- Return the result of the function
 RETURN @OPT_YN

END
