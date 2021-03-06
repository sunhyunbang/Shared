USE [MWMEMBER]
GO
/****** Object:  View [dbo].[__CST_COMPANY_ETC_VI]    Script Date: 2021-11-04 오전 10:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/****** SSMS의 SelectTopNRows 명령 스크립트 ******/

CREATE VIEW [dbo].[__CST_COMPANY_ETC_VI]
as 
SELECT A.[COM_ID]
      , 'S102' AS SECTION_CD
      , C.[MANAGER_NM]
      , C.[MANAGER_PHONE]
      , C.[MANAGER_EMAIL]
      , '' AS [MANAGER_NUMBER]
      , '' AS [MANAGER_IMG_F]
      , '' AS [MANAGER_IMG_B]
      , '' AS [MANAGER_KAKAO_ID]
      , C.[BIZ_CD]
      , C.[BIZ_CLASS]
      , C.[EMP_CNT]
      , C.[MAIN_BIZ]
      , '' AS [LAND_CLASS_CD]
      , '' AS [REG_NUMBER]
      , '' AS [INTRO]
      , C.[LOGO_IMG]
      , C.[EX_IMAGE_1]
      , C.[EX_IMAGE_2]
      , C.[EX_IMAGE_3]
      , C.[EX_IMAGE_4]
      , '' AS [PF_IMG]
      , '' AS [DESCRIPT]
      , '' AS [PROFILE]
      , '' AS [ETCINFO_SYNC]
      , B.USERID
      , B.CUID  AS CUID
  FROM [MWMEMBER].[dbo].[CST_COMPANY] AS A WITH (NOLOCK)
  LEFT OUTER JOIN CST_MASTER AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
  LEFT OUTER JOIN [CST_COMPANY_JOB] AS C WITH (NOLOCK) ON B.COM_ID = C.COM_ID  
UNION ALL
SELECT 
        A.[COM_ID] 
      , 'S103' AS SECTION_CD
      , '' AS [MANAGER_NM]
      , '' AS [MANAGER_PHONE]
      , '' AS [MANAGER_EMAIL]
      , '' AS [MANAGER_NUMBER]
      , '' AS [MANAGER_IMG_F]
      , '' AS [MANAGER_IMG_B]
      , '' AS [MANAGER_KAKAO_ID]
      , '' AS [BIZ_CD]
      , '' AS [BIZ_CLASS]
      , '' AS [EMP_CNT]
      , '' AS [MAIN_BIZ]
      , C.[LAND_CLASS_CD]
      , C.[REG_NUMBER]
      , C.[INTRO]
      , C.[LOGO_IMG]
      , '' AS [EX_IMAGE_1]
      , '' AS [EX_IMAGE_2]
      , '' AS [EX_IMAGE_3]
      , '' AS [EX_IMAGE_4]
      , C.[PF_IMG]
      , C.[DESCRIPT]
      , C.[PROFILE]
      , C.[ETCINFO_SYNC]
      , B.USERID
      , B.CUID  AS CUID
  FROM [MWMEMBER].[dbo].[CST_COMPANY] AS A WITH (NOLOCK)
  LEFT OUTER JOIN CST_MASTER AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
  LEFT OUTER JOIN [CST_COMPANY_LAND] AS C WITH (NOLOCK) ON B.COM_ID = C.COM_ID  

UNION ALL
SELECT 
        A.[COM_ID] 
      , 'S104' AS SECTION_CD
      , C.[MANAGER_NM]
      , C.[MANAGER_PHONE]
      , C.[MANAGER_EMAIL]
      , C.[MANAGER_NUMBER]
      , C.[MANAGER_IMG_F]
      , C.[MANAGER_IMG_B]
      , C.[MANAGER_KAKAO_ID]
      , '' AS [BIZ_CD]
      , '' AS [BIZ_CLASS]
      , '' AS [EMP_CNT]
      , '' AS [MAIN_BIZ]
      , '' AS [LAND_CLASS_CD]
      , '' AS [REG_NUMBER]
      , '' AS [INTRO]
      , '' AS [LOGO_IMG]
      , '' AS [EX_IMAGE_1]
      , '' AS [EX_IMAGE_2]
      , '' AS [EX_IMAGE_3]
      , '' AS [EX_IMAGE_4]
      , '' AS [PF_IMG]
      , '' AS [DESCRIPT]
      , '' AS [PROFILE]
      , '' AS [ETCINFO_SYNC]
      , B.USERID
      , B.CUID  AS CUID
  FROM [MWMEMBER].[dbo].[CST_COMPANY] AS A WITH (NOLOCK)
  LEFT OUTER JOIN CST_MASTER AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
  LEFT OUTER JOIN [CST_COMPANY_AUTO] AS C WITH (NOLOCK) ON B.COM_ID = C.COM_ID  
  
  
  




GO
/****** Object:  View [dbo].[__PP_COMPANY_INFO_JOB_VI]    Script Date: 2021-11-04 오전 10:42:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************
 *  단위 업무 명 : 구인 기업정보 
 *  작   성   자 : 이 근 우
 *  작   성   일 : 2015/04/21
 *  설        명 : 구인 기업정보
 *  주 의  사 항 :
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 *  수   정   자 : 
 *  수   정   일 : 
 *  설        명 : 
 SELECT TOP 100 * FROM PP_COMPANY_INFO_JOB_VI WHERE USERID = 'zzzjhk'
 *************************************************************************************/
CREATE VIEW [dbo].[__PP_COMPANY_INFO_JOB_VI]
AS

  -- DBCC TRACEON(-1, 7307) 

  SELECT A.USERID
       , B.REGISTER_NO AS BIZNO
       , B.CEO_NM AS CEO
       , B.COM_NM
       , B.HOMEPAGE
       , B.MAIN_PHONE AS MAIN_NUMBER
       , B.CITY
       , B.GU
       , B.DONG
       , B.ADDR2 AS AREA_DETAIL
       , C.MANAGER_NM
       , C.MANAGER_PHONE
       , C.MANAGER_EMAIL
       , C.EMP_CNT
       , C.MAIN_BIZ
       , C.LOGO_IMG
       , C.EX_IMAGE_1
       , C.EX_IMAGE_2
       , C.EX_IMAGE_3
       , C.EX_IMAGE_4
			 , C.BIZ_CLASS
			 , A.CUID
			 , B.COM_ID
    FROM dbo.CST_MASTER AS A (NOLOCK)
    JOIN dbo.CST_COMPANY AS B (NOLOCK) ON B.COM_ID = A.COM_ID
    LEFT JOIN dbo.CST_COMPANY_JOB AS C (NOLOCK) ON C.COM_ID = B.COM_ID
   --WHERE C.SECTION_CD = 'S102'






GO
/****** Object:  View [dbo].[CST_COMPANY_ETC_VI]    Script Date: 2021-11-04 오전 10:42:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[CST_COMPANY_ETC_VI]
as 

SELECT A.[COM_ID]
      , 'S102' AS SECTION_CD
      , C.[MANAGER_NM]
      , C.[MANAGER_PHONE]
      , C.[MANAGER_EMAIL]
      , '' AS [MANAGER_NUMBER]
      , '' AS [MANAGER_IMG_F]
      , '' AS [MANAGER_IMG_B]
      , '' AS [MANAGER_KAKAO_ID]
      , C.[BIZ_CD]
      , C.[BIZ_CLASS]
      , C.[EMP_CNT]
      , C.[MAIN_BIZ]
      , '' AS [LAND_CLASS_CD]
      , D.REG_NUMBER AS [REG_NUMBER]
      , '' AS [INTRO]
      , C.[LOGO_IMG]
      , C.[EX_IMAGE_1]
      , C.[EX_IMAGE_2]
      , C.[EX_IMAGE_3]
      , C.[EX_IMAGE_4]
      , '' AS [PF_IMG]
      , '' AS [DESCRIPT]
      , '' AS [PROFILE]
      , '' AS [ETCINFO_SYNC]
      , B.USERID
      , B.CUID  AS CUID
  FROM [MWMEMBER].[dbo].[CST_COMPANY] AS A WITH (NOLOCK)
  LEFT OUTER JOIN CST_MASTER AS B WITH (NOLOCK) ON A.COM_ID = B.COM_ID
  LEFT OUTER JOIN [CST_COMPANY_JOB] AS C WITH (NOLOCK) ON B.COM_ID = C.COM_ID  
  LEFT OUTER JOIN [CST_COMPANY_LAND] AS D WITH (NOLOCK) ON B.COM_ID = D.COM_ID  

GO
/****** Object:  View [dbo].[CST_MASTER_VI]    Script Date: 2021-11-04 오전 10:42:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************************
 *  단위 업무 명 : 원격 연결용 VIEW
 *  작   성   자 :정헌수
 *  작   성   일 : 2018-07-31
 *  수   정   자 :
 *  수   정   일 :
 *  설        명 : PAPER_NEW에서 접속 사용
***************************************************************************************/
CREATE VIEW [dbo].[CST_MASTER_VI]
as 
	SELECT 
		CUID
		,USERID
		,USER_NM
		,HPHONE
		,EMAIL
		,BIRTH
		,GENDER
		,MEMBER_CD
		,COM_ID
		,JOIN_DT
		,MOD_DT
		,REST_YN
		,OUT_YN
	FROM CST_MASTER WITH(NOLOCK)
GO
/****** Object:  View [dbo].[CST_MEMBER_NAME_VI]    Script Date: 2021-11-04 오전 10:42:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[CST_MEMBER_NAME_VI]

AS

  SELECT A.USERID
       , CASE A.MEMBER_CD WHEN '1' THEN A.USER_NM     -- 개인
                          WHEN '2' THEN B.COM_NM      -- 기업
                          ELSE A.USER_NM
         END AS USERNAME
       , A.CUID
       , A.MEMBER_CD
       , A.USER_NM
       , B.COM_NM
       , A.EMAIL 
    FROM CST_MASTER AS A
    LEFT JOIN CST_COMPANY AS B ON A.COM_ID = B.COM_ID



GO
/****** Object:  View [dbo].[USERCOMMON_VI]    Script Date: 2021-11-04 오전 10:42:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* 수정자 : 신장순
* 내  용 : POST 사용안함, ADDR_A 사용안함 (CITY, GU, DONG 으로 변경)
*/
CREATE VIEW [dbo].[USERCOMMON_VI]
AS
SELECT     A.USERID, A.MEMBER_CD AS USERGBN, CASE A.MEMBER_CD WHEN '2' THEN B.COM_NM ELSE A.USER_NM END AS USERNAME, CASE WHEN ISNULL(A.DI, '') 
                      = '' THEN '' ELSE '1' END AS REALNAMECHK, A.BIRTH AS JUMINNO, A.EMAIL, '' AS HOMEPAGE, '' AS PHONE, A.HPHONE, '' AS POST1, '' AS POST2, 
                      CASE A.MEMBER_CD WHEN '2' THEN B.CITY ELSE '' END AS CITY, CASE A.MEMBER_CD WHEN '2' THEN ISNULL(B.CITY, '') + ' ' + ISNULL(B.GU, '') 
                      + ' ' + ISNULL(B.DONG, '') ELSE '' END AS ADDRESS1, CASE A.MEMBER_CD WHEN '2' THEN (CASE WHEN B.CITY IS NULL AND B.GU IS NULL AND B.DONG IS NULL 
                      THEN '' ELSE B.ADDR2 END) ELSE '' END AS ADDRESS2, A.JOIN_DT AS REGDATE, A.MOD_DT AS MODDATE, '' AS DELDATE, '' AS VISITDAY, '' AS VISITCNT, 
                      '' AS IPADDR, A.OUT_YN AS DELFLAG, '' AS INSCHANNEL2,
                          (SELECT     TOP (1) SECTION_CD
                            FROM          dbo.CST_MSG_SECTION
                            WHERE      (CUID = A.CUID)
                            ORDER BY AGREE_DT DESC) AS INSCHANNEL, '' AS DELCANNEL, A.BAD_YN AS BADFLAG, '' AS BADSITE, '' AS BADREASON, '' AS BADETC, '' AS BADDATE, 
                      '' AS INSLOCALSITE, '' AS PARTNERCODE, '' AS PARTNERGBN, '' AS ADDRESSBUNJI, '' AS LOGINTIME, '' AS LOGINSITE, '' AS EMAILFLAG, '' AS SMSFLAG, 
                      '' AS COUPONFLAG, '' AS COUPONLOCAL, '' AS MAILKIND, '' AS AUTH_NO, CASE A.MEMBER_CD WHEN '2' THEN B.GU ELSE '' END AS GU, 
                      CASE A.MEMBER_CD WHEN '2' THEN B.DONG ELSE '' END AS DONG, A.USER_NM AS USERREALNAME, B.REGISTER_NO AS BIZNO, A.CUID
FROM         dbo.CST_MASTER AS A LEFT OUTER JOIN
                      dbo.CST_COMPANY AS B ON B.COM_ID = A.COM_ID
WHERE     (A.OUT_YN = 'N')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[9] 2[48] 3) )"
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
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 6
               Left = 278
               Bottom = 125
               Right = 471
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'USERCOMMON_VI'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'USERCOMMON_VI'
GO
