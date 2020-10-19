CREATE TABLE [dbo].[WfConfiguration] (
    [ConfigurationId]                 INT           NOT NULL,
    [TokenExpirationMinutes]          INT           NOT NULL,
    [FinalQueueExpirationDays]        INT           NOT NULL,
    [DefaultFromMailAddress]          VARCHAR (255) NOT NULL,
    [BillingTemplateId]               VARCHAR (20)  NULL,
    [Current]                         BIT           NOT NULL,
    [MailSubjectPrefix]               VARCHAR (255) NOT NULL,
    [FirstNameRegex]                  VARCHAR (255) NOT NULL,
    [LastNameRegex]                   VARCHAR (255) NOT NULL,
    [MailRegex]                       VARCHAR (255) NOT NULL,
    [PhoneNumberRegex]                VARCHAR (255) NOT NULL,
    [ZipCodeRegex]                    VARCHAR (255) NOT NULL,
    [AddressRegex]                    VARCHAR (255) NOT NULL,
    [MotoreOrarioSecretKey]           VARCHAR (512) NULL,
    [StartTracesExpirationDays]       INT           NOT NULL,
    [SwapToHistoryDays]               INT           CONSTRAINT [DF_WfConfiguration_SwapToHistoryDays] DEFAULT ((90)) NOT NULL,
    [ExpiredFinalQueueExpirationDays] INT           CONSTRAINT [DF_WfConfiguration_ExpiredFinalQueueExpirationDays] DEFAULT ((90)) NOT NULL,
    [FinalizeTokenDays]               INT           NOT NULL,
    CONSTRAINT [PK__WfConfig__95AA53BBC6577618] PRIMARY KEY CLUSTERED ([ConfigurationId] ASC)
);

