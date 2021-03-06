USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[EDIT_INS_MM_BAD_HP_TB_PROC]    Script Date: 2021-11-03 오후 4:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위업무명: 보이스피싱 차단번호 입력
 *  작  성  자: 이현석
 *  작  성  일: 2021/01/13
 *  수  정  자: 
 *  수  정  일: 
 *  주의 사항:
 *  사용 소스:
 *  사용 예제:  execute MWMEMBER.DBO.EDIT_INS_MM_BAD_HP_TB_PROC '01000000000', '박영묘대리요청'
                   exec MWMEMBER.DBO.EDIT_INS_MM_BAD_HP_TB_PROC '01000000000', '박영묘대리요청'
*************************************************************************************/
CREATE PROC [dbo].[EDIT_INS_MM_BAD_HP_TB_PROC]
       @HP VARCHAR(13)  
     , @MEMO VARCHAR(500) 
AS

		INSERT INTO [MWMEMBER].[dbo].[MM_BAD_HP_TB] (HP,MEMO) VALUES (@HP,@MEMO);
GO
