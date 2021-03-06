USE [PAPERJOB]
GO
/****** Object:  View [dbo].[KONAN_PJ_AD_SEARCH_NEW_VI]    Script Date: 2021-11-04 오전 10:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[KONAN_PJ_AD_SEARCH_NEW_VI]
AS

SELECT P.ADID AS DOCID
     , P.CO_NAME
     , REPLACE(LTRIM(ISNULL(REPLACE(P.PHONE,')','-'),'')+' '+ISNULL(REPLACE(P.HPHONE,')','-'),'')),',',' ') AS PHONE
     , P.TITLE
     , P.CONTENTS
     , P.AREA_A
     , P.AREA_B
     , P.AREA_C
     , P.AREA_DETAIL
     , CONVERT(VARCHAR(10),P.START_DT,111) AS REG_DT
     , P.BIZ_CD
     , CASE
            WHEN P.BIZ_CD='40100' THEN '마담/종업원'
            WHEN P.BIZ_CD='40200' THEN '단란주점'
            WHEN P.BIZ_CD='40300' THEN '노래주점'
            WHEN P.BIZ_CD='40400' THEN '다방'
            WHEN P.BIZ_CD='40500' THEN '카페/Bar'
            WHEN P.BIZ_CD='40600' THEN '서빙/웨이터'
       END AS BIZ_NAME
     , P.SORT_ID AS [SORT_ORDER]
     , P.AD_KIND
     , P.CONTENTS AS CONTENTS2
     , PAY_CD
     , PAY_AMT
		 , [dbo].[FN_DATE_TO_CHAR12](P.START_DT) AS REG_DT2
  FROM PJ_AD_PUBLISH_TB AS P
  LEFT JOIN PJ_OPTION_TB AS O ON O.ADID=P.ADID
 --WHERE P.START_DT<GETDATE() AND P.END_DT>GETDATE()  -- PJ_AD_PUBLISH_TB에 들어가는 데이터는 게재일자 체크 안해도 됨.





GO
/****** Object:  View [dbo].[PJ_AD_SEARCH_NEW_VI]    Script Date: 2021-11-04 오전 10:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PJ_AD_SEARCH_NEW_VI]
AS

SELECT P.ADID AS DOCID
     , P.CO_NAME
     , REPLACE(LTRIM(ISNULL(REPLACE(P.PHONE,')','-'),'')+' '+ISNULL(REPLACE(P.HPHONE,')','-'),'')),',',' ') AS PHONE
     , P.TITLE
     , P.CONTENTS
     , P.AREA_A
     , P.AREA_B
     , P.AREA_C
     , P.AREA_DETAIL
     , CONVERT(VARCHAR(10),P.START_DT,111) AS REG_DT
     , P.BIZ_CD
     , CASE
            WHEN P.BIZ_CD='40100' THEN '마담/종업원'
            WHEN P.BIZ_CD='40200' THEN '단란주점'
            WHEN P.BIZ_CD='40300' THEN '노래주점'
            WHEN P.BIZ_CD='40400' THEN '다방'
            WHEN P.BIZ_CD='40500' THEN '카페/Bar'
            WHEN P.BIZ_CD='40600' THEN '서빙/웨이터'
       END AS BIZ_NAME
     , P.SORT_ID AS [ORDER]
     , P.AD_KIND
     , P.CONTENTS AS CONTENTS2
     , PAY_CD
     , PAY_AMT
  FROM PJ_AD_PUBLISH_TB AS P
  LEFT JOIN PJ_OPTION_TB AS O ON O.ADID=P.ADID
 --WHERE P.START_DT<GETDATE() AND P.END_DT>GETDATE()  -- PJ_AD_PUBLISH_TB에 들어가는 데이터는 게재일자 체크 안해도 됨.













GO
/****** Object:  View [dbo].[PJ_AD_SEARCH_VI]    Script Date: 2021-11-04 오전 10:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[PJ_AD_SEARCH_VI]
AS

SELECT P.ADID AS DOCID
     , P.CO_NAME
     , REPLACE(LTRIM(ISNULL(REPLACE(P.PHONE,')','-'),'')+' '+ISNULL(REPLACE(P.HPHONE,')','-'),'')),',',' ') AS PHONE
     , P.TITLE
     , P.CONTENTS
     , P.AREA_A
     , P.AREA_B
     , P.AREA_C
     , P.AREA_DETAIL
     , CONVERT(VARCHAR(10),P.START_DT,111) AS REG_DT
     , P.BIZ_CD
     , CASE
            WHEN P.BIZ_CD='40100' THEN '마담/종업원'
            WHEN P.BIZ_CD='40200' THEN '단란주점'
            WHEN P.BIZ_CD='40300' THEN '노래주점'
            WHEN P.BIZ_CD='40400' THEN '다방'
            WHEN P.BIZ_CD='40500' THEN '카페/Bar'
            WHEN P.BIZ_CD='40600' THEN '서빙/웨이터'
       END AS BIZ_NAME
     , P.SORT_ID AS [ORDER]
     , P.AD_KIND
     , P.CONTENTS AS CONTENTS2
  FROM PJ_AD_PUBLISH_TB AS P
  LEFT JOIN PJ_OPTION_TB AS O ON O.ADID=P.ADID
 --WHERE P.START_DT<GETDATE() AND P.END_DT>GETDATE()  -- PJ_AD_PUBLISH_TB에 들어가는 데이터는 게재일자 체크 안해도 됨.












GO
/****** Object:  View [dbo].[PJ_AGENCY_AD_LIST_VI]    Script Date: 2021-11-04 오전 10:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PJ_AGENCY_AD_LIST_VI]
AS
SELECT A.ADID, A.CO_NAME, A.PHONE, A.HPHONE, A.BIZ_CD, A.AREA_A, A.AREA_B, A.AREA_C, A.AREA_DETAIL, A.HOMEPAGE, A.TITLE, A.CONTENTS, A.THEME_CD,
		A.PAY_CD, A.PAY_AMT, A.BIZ_NUMBER, A.LOGO_IMG, A.START_DT, A.END_DT, A.MWPLUS_LINEADID, A.MWPLUS_OPTION, ISNULL(B.AD_KIND, 'A') AS AD_KIND, A.M_STATUS,
		A.REG_DT, A.AMOUNT_ONLINE, A.AMOUNT_MWPLUS, A.REG_KIND, A.PAUSE_YN, A.END_YN, A.STOP_DT, ISNULL(B.LOCAL_CD, 0) AS LOCAL_CD,
		ISNULL(B.OPTION_MAIN_CD, 0) AS OPTION_MAIN_CD, ISNULL(B.TEMPLATE_CD, 0) AS TEMPLATE_CD, ISNULL(B.OPT_SUB_A, 0) AS OPT_SUB_A,
		B.OPT_SUB_A_START_DT, B.OPT_SUB_A_END_DT, ISNULL(B.OPT_SUB_B, 0) AS OPT_SUB_B, B.OPT_SUB_B_START_DT, B.OPT_SUB_B_END_DT,
		ISNULL(B.OPT_SUB_C, 0) AS OPT_SUB_C, B.OPT_SUB_C_START_DT, B.OPT_SUB_C_END_DT, ISNULL(B.OPT_SUB_D, 0) AS OPT_SUB_D,
		B.OPT_SUB_D_START_DT, B.OPT_SUB_D_END_DT, ISNULL(B.OPT_SUB_E, 0) AS OPT_SUB_E, B.OPT_SUB_E_START_DT, B.OPT_SUB_E_END_DT, ISNULL(C.HIT, 0) AS HIT,
		A.MAGBRANCH AS MAG_BRANCHCODE, A.MAGID, E.MagName, A.REASON, A.MAP_X, A.MAP_Y, A.GRAND_IMG, A.MOD_DT, A.CONFIRM_YN,
		ISNULL(CAST(A.MOD_REQ_DT AS VARCHAR), '') AS MOD_REQ_DT, A.REG_NAME
FROM dbo.PJ_AD_AGENCY_TB AS A WITH (NOLOCK) LEFT OUTER JOIN
		dbo.PJ_OPTION_TB AS B WITH (NOLOCK) ON B.ADID = A.ADID AND B.AD_KIND = 'A' LEFT OUTER JOIN
		dbo.PJ_AD_COUNT_TB AS C WITH (NOLOCK) ON C.ADID = A.ADID AND C.AD_KIND = 'A' LEFT OUTER JOIN -- INNER JOIN
		FINDCOMMON.dbo.CommonMagUserSub AS D ON D.MagID = A.MAGID AND D.SectionCode = 12 LEFT OUTER JOIN -- INNER JOIN
		/*
		dbo.PJ_AD_COUNT_TB AS C WITH (NOLOCK) ON C.ADID = A.ADID AND C.AD_KIND = 'A' INNER JOIN
		FINDCOMMON.dbo.CommonMagUserSub AS D ON D.MagID = A.MAGID AND D.SectionCode = 12 INNER JOIN
		*/											
		FINDCOMMON.dbo.CommonMagUser AS E ON E.MagID = A.MAGID


GO
/****** Object:  View [dbo].[PJ_REG_AD_SEARCH_VI]    Script Date: 2021-11-04 오전 10:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-Comm 등록된 광고리스트 VIEW
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/08/31
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : SELECT * FROM DBO.PJ_REG_AD_SEARCH_VI
 *************************************************************************************/
CREATE VIEW [dbo].[PJ_REG_AD_SEARCH_VI]
AS
	SELECT
		 ADID
		,'A' AS AD_KIND
		,CO_NAME
		,TITLE
		,PHONE
		,HPHONE
		,START_DT
		,BIZ_CD
		,AREA_A
		,AREA_B
		,AREA_C
		,AREA_DETAIL
		,HOMEPAGE
		,PAY_CD
		,PAY_AMT
		,MAP_X
		,MAP_Y
		,CONTENTS
		,LOGO_IMG
		,REG_NAME
	FROM PJ_AD_AGENCY_TB

	UNION ALL

	SELECT
		 LINEADID AS ADID
		,'P' AS AD_KIND
		,CONAME AS CO_NAME
		,TITLE
		,PHONE
		,HPHONE
		,STARTDATE AS START_DT
		,CODE AS BIZ_CD
		,METRO AS AREA_A
		,CITY AS AREA_B
		,DONG AREA_C
		,ADDR_DETAIL AS AREA_DETAIL
		,URL AS HOMEPAGE
		,1 AS PAY_CD
		,0 AS PAY_AMT
		,MAP_X
		,MAP_Y
		,CONTENTS
		,NULL AS LOGO_IMG
		,NULL AS REG_NAME
	FROM DAILY_JOBPAPER_TB
	WHERE END_YN = 'N'

	UNION ALL

	SELECT
		 ADID
		,'U' AS AD_KIND
		,CO_NAME
		,TITLE
		,PHONE
		,HPHONE
		,START_DT
		,BIZ_CD
		,AREA_A
		,AREA_B
		,AREA_C
		,AREA_DETAIL
		,HOMEPAGE
		,PAY_CD
		,PAY_AMT
		,MAP_X
		,MAP_Y
		,CONTENTS
		,LOGO_IMG
		,NULL AS REG_NAME
	FROM PJ_AD_USERREG_TB


GO
/****** Object:  View [dbo].[PJ_USERREG_AD_LIST_VI]    Script Date: 2021-11-04 오전 10:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*************************************************************************************
 *  단위 업무 명 : 관리자 > E-Comm 광고 리스트 VIEW
 *  작   성   자 : 최 봉 기 (virtualman@mediawill.com)
 *  작   성   일 : 2011/04/19
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 :
 *  주 의  사 항 :
 *  사 용  소 스 :
 *  사 용  예 제 : SELECT * FROM DBO.PJ_USERREG_AD_LIST_VI
 *************************************************************************************/


CREATE VIEW [dbo].[PJ_USERREG_AD_LIST_VI]

AS

    SELECT A.ADID
          ,A.CO_NAME
          ,A.PHONE
          ,A.HPHONE
          ,A.BIZ_CD
          ,A.AREA_A
          ,A.AREA_B
          ,A.AREA_C
          ,A.AREA_DETAIL
          ,A.HOMEPAGE
          ,A.TITLE
          ,A.CONTENTS
          ,A.THEME_CD
          ,A.PAY_CD
          ,A.PAY_AMT
          ,A.BIZ_NUMBER
          ,A.LOGO_IMG
          ,A.START_DT
          ,A.END_DT
          ,0 AS MWPLUS_LINEADID
          ,ISNULL(B.AD_KIND,'U') AS AD_KIND
          ,A.REG_DT
          ,A.PAUSE_YN
          ,A.END_YN
          ,A.STOP_DT

          ,ISNULL(B.LOCAL_CD, 0) AS LOCAL_CD
          ,ISNULL(B.OPTION_MAIN_CD,0) AS OPTION_MAIN_CD
          ,ISNULL(B.TEMPLATE_CD,0) AS TEMPLATE_CD
          ,ISNULL(B.OPT_SUB_A,0) AS OPT_SUB_A
          ,B.OPT_SUB_A_START_DT
          ,B.OPT_SUB_A_END_DT
          ,ISNULL(B.OPT_SUB_B,0) AS OPT_SUB_B
          ,B.OPT_SUB_B_START_DT
          ,B.OPT_SUB_B_END_DT
          ,ISNULL(B.OPT_SUB_C,0) AS OPT_SUB_C
          ,B.OPT_SUB_C_START_DT
          ,B.OPT_SUB_C_END_DT
          ,ISNULL(B.OPT_SUB_D,0) AS OPT_SUB_D
          ,B.OPT_SUB_D_START_DT
          ,B.OPT_SUB_D_END_DT
          ,ISNULL(B.OPT_SUB_E,0) AS OPT_SUB_E
          ,B.OPT_SUB_E_START_DT
          ,B.OPT_SUB_E_END_DT

          ,ISNULL(C.HIT,0) AS HIT

          ,A.USERID
					,A.CONFIRM_YN
					,ISNULL(A.MOD_REQ_DT, '') AS MOD_REQ_DT
      FROM PJ_AD_USERREG_TB AS A (NOLOCK)
           LEFT JOIN PJ_OPTION_TB AS B (NOLOCK)
                  ON B.ADID = A.ADID
                 AND B.AD_KIND = 'U'
           LEFT JOIN PJ_AD_COUNT_TB AS C (NOLOCK)
                  ON B.ADID = A.ADID
                 AND B.AD_KIND = 'U'










GO
/****** Object:  View [dbo].[YAALBA_AGENCY_AD_VI]    Script Date: 2021-11-04 오전 10:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[YAALBA_AGENCY_AD_VI]

AS

  SELECT A.ADID
        ,CASE B.OPTION_MAIN_CD WHEN 1 THEN '프리미엄플러스'
                         WHEN 2 THEN '프리미엄박스'
                         WHEN 4 THEN '프리미엄리스트'
                         WHEN 8 THEN '스피드박스'
                         WHEN 16 THEN '스피드리스트'
                         WHEN 32 THEN '그랜드플러스'
                         WHEN 0 THEN '일반'
                         ELSE '다중옵션'
          END AS OPTION_NAME
        ,A.START_DT
        ,A.AMOUNT_ONLINE AS OPT_I_PRICE
        ,A.AMOUNT_MWPLUS AS OPT_P_PRICE
        ,C.BRANCHNAME
     FROM dbo.PJ_AD_AGENCY_TB AS A
      JOIN PJ_OPTION_TB AS B
      ON B.ADID = A.ADID
      AND B.AD_KIND = 'A'
      JOIN FINDDB2.COMMON.DBO.BRANCH AS C
      ON C.BRANCHCODE = MAGBRANCH






GO
/****** Object:  View [dbo].[YAALBA_ECOMM_AD_VI]    Script Date: 2021-11-04 오전 10:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[YAALBA_ECOMM_AD_VI]

AS

  SELECT A.ADID
        ,A.USERID
        ,CASE B.OPTION_MAIN_CD WHEN 1 THEN '프리미엄플러스'
                         WHEN 2 THEN '프리미엄박스'
                         WHEN 4 THEN '프리미엄리스트'
                         WHEN 8 THEN '스피드박스'
                         WHEN 16 THEN '스피드리스트'
                         WHEN 32 THEN '그랜드플러스'
                         WHEN 0 THEN '일반'
                         ELSE '다중옵션'
            END AS OPTION_NAME
        ,C.RECDATE
        ,A.START_DT
        ,C.PRNAMT
  FROM PJ_AD_USERREG_TB AS A
  JOIN PJ_OPTION_TB AS B
    ON B.ADID = A.ADID
   AND B.AD_KIND = 'U'
  JOIN PJ_RECCHARGE_TB AS C
    ON C.ADID = A.ADID
 WHERE C.PRNAMTOK = 1







GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 222
            End
            DisplayFlags = 280
            TopColumn = 31
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 6
               Left = 260
               Bottom = 125
               Right = 464
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 230
               Right = 183
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "D"
            Begin Extent = 
               Top = 126
               Left = 221
               Bottom = 245
               Right = 370
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "E"
            Begin Extent = 
               Top = 234
               Left = 38
               Bottom = 353
               Right = 196
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PJ_AGENCY_AD_LIST_VI'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PJ_AGENCY_AD_LIST_VI'
GO
