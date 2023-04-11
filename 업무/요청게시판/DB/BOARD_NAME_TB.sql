USE [STATS]
GO

/****** Object:  Table [dbo].[BOARD_NAME_TB]    Script Date: 2023-04-11 ¿ÀÀü 9:58:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BOARD_NAME_TB](
	[bidx] [int] NOT NULL,
	[board_name] [varchar](100) NOT NULL,
	[stat_YN] [char](1) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BOARD_NAME_TB] ADD  DEFAULT ('N') FOR [stat_YN]
GO


