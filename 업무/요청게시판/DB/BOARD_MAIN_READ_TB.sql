USE [STATS]
GO

/****** Object:  Table [dbo].[BOARD_MAIN_READ_TB]    Script Date: 2023-04-11 ¿ÀÀü 10:18:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BOARD_MAIN_READ_TB](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[board_idx] [int] NULL,
	[userid] [varchar](50) NULL,
	[usernm] [varchar](50) NULL,
	[regdt] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BOARD_MAIN_READ_TB] ADD  DEFAULT (getdate()) FOR [regdt]
GO


