USE [STATS]
GO

/****** Object:  Table [dbo].[BOARD_MANAGER_TB]    Script Date: 2023-04-11 ���� 9:58:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BOARD_MANAGER_TB](
	[IDX] [int] IDENTITY(1,1) NOT NULL,
	[BIDX] [int] NULL,
	[CODE] [int] NULL,
	[GROUP_CD] [int] NULL,
	[MANAGERID] [varchar](30) NULL
) ON [PRIMARY]
GO


