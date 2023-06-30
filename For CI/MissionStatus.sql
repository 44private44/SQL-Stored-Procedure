 -- Mission Approve & Declined 

ALTER PROCEDURE UpdateMissionStatus
    @missionApplicationId INT,
    @approvalStatus VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE mission_application
        SET approval_status = @approvalStatus
        WHERE mission_application_id = @missionApplicationId;

        COMMIT;

        SELECT @@ROWCOUNT AS [RowsAffects];
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        -- Raise an error Exception
        THROW;
    END CATCH;
END;
