if exists (select * from sysobjects where id = object_id('dbo.usp_Disable_SICS_BO_INCREMENTALS') and sysstat & 0xf = 4)
	drop procedure dbo.usp_Disable_SICS_BO_INCREMENTALS
GO

/******************************************************************************/
/* PROC NAME:    usp_Disable_SICS_BO_INCREMENTALS                             */
/*                                                                            */
/* DESCRIPTION:  Disables the SICS BO INCREMENTALS SQL Server Job Agent       */
/*               job.                                                         */
/* 		                                                                      */
/* CALLED FROM: This stored procedure is executed via the SICS Admin console  */
/*              by selecting Database Setup --> SQL Script Manager -->        */
/*              Reporting Tables Update Scripts tab then find the job named   */
/*              DISABLE SICS BO INCREMENTALS, right click it and select       */
/*              Execute... and click Ok to the prompt and the job should be   */
/*              enabled and email notification should be set to IS and IT.    */
/*                                                                            */
/* 		                                                                      */
/*                                                                            */
/* AUTHOR:       Mike Pappas                                                  */
/*                                                                            */
/* DATE WRITTEN: 03-04-21                                                     */
/*                                                                            */
/* REVISIONS: 03/17/2021 MP: Per Teams meeting with Steve Michels, replaced   */
/*                           all references of BOXI to BO                     */
/*                                                                            */
/* REVISIONS: 04/14/2022 MP: Added Adam Rett to email notification            */
/*                           Recipients variable.                             */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/******************************************************************************/
-- EXECUTE usp_Disable_SICS_BO_INCREMENTALS
CREATE PROCEDURE dbo.usp_Disable_SICS_BO_INCREMENTALS

AS
BEGIN

DECLARE @numIsEnabled            NUMERIC(18)

DECLARE @vcSQLServerDatabaseName VARCHAR(128) = 'SICS_TEST_CSC'
       ,@vcSQLServerDescription  VARCHAR(128) = 'SICS BO INCREMENTALS JOB'
       ,@vcSQLServerJobName      VARCHAR(128) = 'SICS BO INCREMENTALS - '
       ,@vcSQLServerName         VARCHAR(13)  = 'SICSTESTSQL02'

DECLARE @vcEmailProfileName    VARCHAR(128) = 'AAICTEST'
       ,@vcRecipients          VARCHAR(MAX) = 'smichels@aaic.com;cmiller@aaic.com;kharris@aaic.com;shaas@aaic.com;arett@aaic.com'
       ,@vcBlindCopyRecipients VARCHAR(MAX) = 'mpappas@aaic.com'
       ,@vcCopyRecipients      VARCHAR(MAX) = 'rkoster@aaic.com;akonwal@aaic.com;mpappas@aaic.com'
       ,@vcEmailSubject        VARCHAR(255) = 'SICS BO Incrementals have been DISABLED on ';
       
        SET @vcSQLServerJobName = @vcSQLServerJobName + @vcSQLServerDatabaseName;
        SET @vcEmailSubject     = @vcEmailSubject + @vcSQLServerName + ' - ' + @vcSQLServerDatabaseName + ' EOM!'

        --Get Job Enabled Job Status
        SELECT
                @numIsEnabled = enabled 
        FROM
                msdb.dbo.sysjobs
        WHERE
                name = @vcSQLServerJobName

        --If Job Enabled Status is 1 or ENABLED, then DISABLE (set it to 0) and run the job and send email
        IF @numIsEnabled = 1
        BEGIN
                --
                -- RUN THE JOB SO THE SCHEDULE WILL START AGAIN
                --
                EXEC msdb.dbo.sp_update_job @job_name    = @vcSQLServerJobName
                                           ,@description = @vcSQLServerDescription
                                           ,@enabled     = 0;  

        END;

        --
        --SEND EMAIL TO IS AND IT
        --
        EXEC msdb..sp_send_dbmail @profile_name          = @vcEmailProfileName
                                 ,@recipients            = @vcRecipients
                                 ,@copy_recipients       = @vcCopyRecipients
                                 ,@blind_copy_recipients = @vcBlindCopyRecipients
                                 ,@subject               = @vcEmailSubject
                                 ,@body                  = ''
                                 ,@body_format           = 'HTML';
END;
GRANT EXECUTE ON dbo.usp_Disable_SICS_BO_INCREMENTALS TO PUBLIC;

