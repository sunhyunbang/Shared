USE [STATS]
GO

/****** Object:  Table [dbo].[BOARD_MAIN_TB]    Script Date: 2023-04-11 ¿ÀÀü 9:56:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BOARD_MAIN_TB](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[bidx] [int] NOT NULL,
	[code] [int] NOT NULL,
	[title] [varchar](500) NOT NULL,
	[content] [varchar](max) NOT NULL,
	[regdt] [datetime] NOT NULL,
	[regid] [varchar](50) NOT NULL,
	[regnm] [varchar](50) NULL,
	[regip] [varchar](20) NOT NULL,
	[delyn] [char](1) NOT NULL,
	[moddt] [datetime] NULL,
	[stat] [varchar](20) NOT NULL,
	[assign_nm] [varchar](20) NOT NULL,
	[GROUP_CD] [int] NULL,
	[email] [varchar](100) NULL,
	[ACCESSTYPE] [int] NULL,
 CONSTRAINT [PK_BOARD_MAIN_TB] PRIMARY KEY CLUSTERED 
(
	[idx] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BOARD_MAIN_TB] ADD  DEFAULT (getdate()) FOR [regdt]
GO

ALTER TABLE [dbo].[BOARD_MAIN_TB] ADD  DEFAULT ('n') FOR [delyn]
GO

ALTER TABLE [dbo].[BOARD_MAIN_TB] ADD  DEFAULT ('') FOR [stat]
GO

ALTER TABLE [dbo].[BOARD_MAIN_TB] ADD  DEFAULT ('') FOR [assign_nm]
GO


