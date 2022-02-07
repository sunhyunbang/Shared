USE [PAPER_NEW]
GO

/****** Object:  Table [dbo].[SEND_MAIL_DAILY_LOG_TB]    Script Date: 2021-12-03 ¿ÀÈÄ 4:38:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SEND_MAIL_DAILY_LOG_TB](
	[TARGET_ID] [int] NOT NULL,
	[USER_NM] [nvarchar](50) NULL,
	[EMAIL] [nvarchar](50) NOT NULL,
  [SENDMAIL_TYPE] [nvarchar](50) NULL,
	[INSERT_DT] [varchar](10) NOT NULL,
  [UPDATE_DT] [datetime] null,
	[RESULT_CODE] [nvarchar](50) NULL,
	[RESULT_MESSAGE] [nvarchar](500) NULL
) ON [PRIMARY]
GO


