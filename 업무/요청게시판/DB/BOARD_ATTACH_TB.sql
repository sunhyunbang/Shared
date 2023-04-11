USE [STATS]
GO

/****** Object:  Table [dbo].[BOARD_ATTACH_TB]    Script Date: 2023-04-11 ¿ÀÀü 9:53:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BOARD_ATTACH_TB](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[b_idx] [int] NOT NULL,
	[attachurl] [varchar](200) NOT NULL,
	[attachtxt] [varchar](200) NOT NULL,
	[ORD] [int] NULL
) ON [PRIMARY]
GO


