/****** Object:  StoredProcedure [dbo].[BOBU001]    Script Date: 4/24/2023 3:18:19 PM ******/
DROP PROCEDURE [dbo].[BOBU001]
GO

/****** Object:  StoredProcedure [dbo].[BOBU001]    Script Date: 4/24/2023 3:18:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[BOBU001] 
(@METHOD VARCHAR(1) = '', @LOGLEVEL INT = 1)

AS

/* VERSION 4.6.1 */

DECLARE @V_LOGLEVEL INT


SET @V_LOGLEVEL = @LOGLEVEL

/* LOGLEVEL 0 NO LOGGING */
/* LOGLEVEL 1 BASIC */
/* LOGLEVEL 2 DETAILED */
/* LOGLEVEL 3 CHECKPOINTS FOR PERFORMANCE CHECK */
/* LOGLEVEL 4 DEBUG */

IF @V_LOGLEVEL > 0 
INSERT INTO BO_DM_ACTIVITY_LOG (  ACTIVITY_TIMESTAMP, SCRIPT_ID, ACTION, DESCRIPTION, DM_BATCH_NO)
SELECT GETDATE(),'BOBU001','SCRIPT START','4.6.1 INCREMENTAL',CURRENT_BATCH 
FROM BOAC_STATUS


--DROP INDEX BO_PREM_CURR.BO_PRM_CURR_F_COND;

--TRUNCATE TABLE BO_PREM_CURR;

MERGE BO_PREM_CURR as TARGET
USING v_BOAC_PREM_CURR as SOURCE
on (target.fk_condition = source.fk_condition and target.pc_object_id = source.pc_object_id)
when not matched by target then
  insert 
  values (source.fk_condition, source.exch_rate_excess, source.exch_rate_limit,
          source.exch_rate_premium, source.exch_rate_reinstat, source.fk_currency,
          source.pc_object_id, source.pc_subclass, source.annual_amount,
          source.historic_amount, source.insured_amount, source.is_added, 
          source.is_sum, source.min_amount, source.min_hist_amount,
          source.min_insu_amount, source.dp_object_id, source.premium_amount,
          source.dp_subclass)
when not matched by source then
    delete
when matched and (target.fk_condition <> source.fk_condition or 
                    target.exch_rate_excess <> source.exch_rate_excess or 
                    target.exch_rate_limit      <>      source.exch_rate_limit or
                    target.exch_rate_premium  <>  source.exch_rate_premium or
                    target.exch_rate_reinstat <>  source.exch_rate_reinstat or
                    target.fk_currency  <>   source.fk_currency or
                    target.pc_object_id   <>   source.pc_object_id or
                    target.pc_subclass <>  source.pc_subclass or
                    target.annual_amount <>  source.annual_amount or
                    target.historic_amount  <>    source.historic_amount or
                    target.insured_amount <>     source.insured_amount or
                    target.is_added  <>  source.is_added or
                    target.is_sum  <>  source.is_sum or
                    target.min_amount <>  source.min_amount or 
                    target.min_hist_amount <>  source.min_hist_amount or
                    target.min_insu_amount <>    source.min_insu_amount or 
                    target.dp_object_id <> source.dp_object_id or
                    target.premium_amount  <>  source.premium_amount or
                    target.dp_subclass  <>   source.dp_subclass)  THEN
update set         target.fk_condition = source.fk_condition , 
                    target.exch_rate_excess = source.exch_rate_excess , 
                    target.exch_rate_limit      =      source.exch_rate_limit ,
                    target.exch_rate_premium  =  source.exch_rate_premium ,
                    target.exch_rate_reinstat =  source.exch_rate_reinstat ,
                    target.fk_currency  =   source.fk_currency ,
                    target.pc_object_id   =   source.pc_object_id ,
                    target.pc_subclass =  source.pc_subclass ,
                    target.annual_amount =  source.annual_amount,
                    target.historic_amount  =    source.historic_amount ,
                    target.insured_amount =     source.insured_amount ,
                    target.is_added  =  source.is_added ,
                    target.is_sum  =  source.is_sum ,
                    target.min_amount =  source.min_amount , 
                    target.min_hist_amount =  source.min_hist_amount,
                    target.min_insu_amount =    source.min_insu_amount , 
                    target.dp_object_id = source.dp_object_id ,
                    target.premium_amount  =  source.premium_amount ,
                    target.dp_subclass  =   source.dp_subclass            
                    ;

--CREATE INDEX BO_PRM_CURR_F_COND ON BO_PREM_CURR(FK_CONDITION);

IF @V_LOGLEVEL > 0 
INSERT INTO BO_DM_ACTIVITY_LOG (  ACTIVITY_TIMESTAMP, SCRIPT_ID, ACTION, DESCRIPTION, DM_BATCH_NO)
SELECT GETDATE(),'BOBU001','SCRIPT END','',CURRENT_BATCH 
FROM BOAC_STATUS
GO

