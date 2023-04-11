USE [STATS]
GO

/****** Object:  Table [dbo].[BOARD_CODE_TB]    Script Date: 2023-04-11 ¿ÀÀü 9:56:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BOARD_CODE_TB](
	[BIDX] [int] NOT NULL,
	[CODE] [int] NOT NULL,
	[CODE_NAME] [varchar](100) NOT NULL,
	[ord] [int] NOT NULL,
	[email] [varchar](100) NULL,
	[Template] [varchar](max) NULL,
	[description] [varchar](200) NULL,
	[REGID] [varchar](30) NULL,
	[REGDATE] [datetime] NULL,
	[USEYN] [char](1) NOT NULL,
	[CODE2] [int] NULL,
	[CODE_NAME2] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BOARD_CODE_TB] ADD  DEFAULT ((0)) FOR [ord]
GO

ALTER TABLE [dbo].[BOARD_CODE_TB] ADD  CONSTRAINT [Template]  DEFAULT ('') FOR [Template]
GO

ALTER TABLE [dbo].[BOARD_CODE_TB] ADD  CONSTRAINT [DF_BOARD_CODE_TB_Content]  DEFAULT ('') FOR [description]
GO

ALTER TABLE [dbo].[BOARD_CODE_TB] ADD  CONSTRAINT [DF_BOARD_CODE_TB_REGDATE]  DEFAULT (getdate()) FOR [REGDATE]
GO

ALTER TABLE [dbo].[BOARD_CODE_TB] ADD  CONSTRAINT [USEYN]  DEFAULT ('Y') FOR [USEYN]
GO


