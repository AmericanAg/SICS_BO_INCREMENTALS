DECLARE @Loglevel INT
       ,@RC       INT;
DECLARE @Method   VARCHAR(1);

BEGIN

-- TODO: Set parameter values here.
SET @Method   = 'B';

/* loglevel 0 No logging */
/* loglevel 1 basic */
/* loglevel 2 detailed */
/* loglevel 3 checkpoints for performance check */
/* loglevel 4 debug */
SET @Loglevel = 3

--START: MP 07/24/2013 FOR TESTING
SELECT @Method   METHOD
SELECT @Loglevel LOGLEVEL
--END: MP 07/24/2013 FOR TESTING


EXECUTE @RC = BOAC004 @Method
                     ,@Loglevel

SELECT @RC RESULT

END;