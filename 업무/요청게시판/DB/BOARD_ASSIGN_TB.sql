USE [STATS]
GO

/****** Object:  Table [dbo].[BOARD_ASSIGN_TB]    Script Date: 2023-04-11 ¿ÀÀü 9:55:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BOARD_ASSIGN_TB](
	[idx] [int] IDENTITY(1,1) NOT NULL,
	[board_idx] [int] NULL,
	[stat] [varchar](20) NULL,
	[assign_nm] [varchar](50) NULL,
	[assignid] [varchar](50) NULL,
	[regdt] [datetime] NULL,
 CONSTRAINT [PK_BOARD_ASSIGN_TB] PRIMARY KEY CLUSTERED 
(
	[idx] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BOARD_ASSIGN_TB] ADD  DEFAULT (getdate()) FOR [regdt]
GO


