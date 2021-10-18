/*************************************************************************************
 *  단위 업무 명 : 관리자 - 회사 로고 검수대기
 *  작   성   자 : 이근우
 *  작   성   일 : 2012/08/27
 *  수   정   자 : 김 문 화 (로고이원화 작업)
 *  수   정   일 : 2013/10/21
 *  수   정   자 : 방순현        
 *  수   정   일 : 2021/10/12 
 *  수 정 내  용 : 로고검수 프로세스 개선
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : EXEC DBO.EDIT_M_PP_LOGO_OPTION_TB_WAIT_PROC 28492, 180, 21
 *************************************************************************************/
ALTER PROC [dbo].[EDIT_M_PP_LOGO_OPTION_TB_WAIT_PROC]
(
  @LINEADID         INT       = 0
, @INPUTBRANCH      TINYINT   = 0
, @LAYOUTBRANCH     TINYINT   = 0
, @PAGE_GBN         CHAR(1)   = ''   -- D:구인구직 광고 상세/수정 페이지
)
AS

SET NOCOUNT ON

IF @LINEADID > 0 AND @INPUTBRANCH > 0 AND @LAYOUTBRANCH > 0
BEGIN
 BEGIN TRAN

  IF @PAGE_GBN = 'D'
    BEGIN
      UPDATE PP_LOGO_OPTION_TB
         SET PUB_LOGO = NULL
            ,PUB_CONFIRM_DT = NULL
            ,PUB_CONFIRM = 0
            ,WAIT_LOGO = NULL
            ,WAIT_DT = NULL
            ,REG_DT = GETDATE()
            ,WAIT_NEW = 'Y'
       WHERE LINEADID = @LINEADID
         AND INPUT_BRANCH = @INPUTBRANCH
         AND LAYOUT_BRANCH = @LAYOUTBRANCH
    END
  --등록폼을 통한 재수정일 경우
  ELSE IF @PAGE_GBN = 'R'
    BEGIN
      IF dbo.FN_GET_OPTINFO_YN(@LINEADID,@INPUTBRANCH,@LAYOUTBRANCH) ='Y'
        BEGIN
          UPDATE PP_LOGO_OPTION_TB
             SET PUB_CONFIRM_DT = NULL
                ,PUB_CONFIRM = 2
                ,REG_DT = GETDATE()
                ,WAIT_NEW = 'Y'
           WHERE LINEADID = @LINEADID
             AND INPUT_BRANCH = @INPUTBRANCH
             AND LAYOUT_BRANCH = @LAYOUTBRANCH
        END
      ELSE
        BEGIN
          UPDATE PP_LOGO_OPTION_TB
             SET PUB_CONFIRM_DT = GETDATE()
                ,REG_DT = GETDATE()
           WHERE LINEADID = @LINEADID
             AND INPUT_BRANCH = @INPUTBRANCH
             AND LAYOUT_BRANCH = @LAYOUTBRANCH
        END
    END
  ELSE
    BEGIN
      UPDATE PP_LOGO_OPTION_TB
         SET PUB_LOGO = NULL
            ,PUB_CONFIRM_DT = NULL
            ,PUB_CONFIRM = 0
            ,REG_DT = GETDATE()
            ,WAIT_NEW = 'Y'
       WHERE LINEADID = @LINEADID
         AND INPUT_BRANCH = @INPUTBRANCH
         AND LAYOUT_BRANCH = @LAYOUTBRANCH
    END
 -- 에러가 발생했을 경우는 에러번호를 리턴해주고
 IF ( @@ERROR <> 0 )
 BEGIN
  SET NOCOUNT OFF
  ROLLBACK TRAN
  RETURN (2)
 END
 -- 성공한 경우는 1을 리턴
 ELSE
 BEGIN
  COMMIT TRAN
  RETURN (1)
 END
END




