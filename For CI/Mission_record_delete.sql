 -- Mission records delete and it's child table

 USE CIPlatform;

ALTER PROCEDURE DeleteAllMissionData
 (
	@missionId BIGINT
 )
 AS
 BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
			
			-- Delete records
			DELETE FROM mission_application WHERE mission_id = @missionId;
			DELETE FROM mission_document WHERE mission_id = @missionId;
			DELETE FROM mission_invite WHERE mission_id = @missionId;
			DELETE FROM mission_media WHERE mission_id = @missionId;
			DELETE FROM mission_rating WHERE mission_id = @missionId;
			DELETE FROM mission_skill WHERE mission_id = @missionId;
			DELETE FROM goal_mission WHERE mission_id = @missionId;
			DELETE FROM favourite_mission WHERE mission_id = @missionId;
			DELETE FROM comment WHERE mission_id = @missionId;
			DELETE FROM STORY WHERE mission_id = @missionId;
			DELETE FROM timesheet WHERE mission_id = @missionId;
			DELETE FROM mission WHERE mission_id = @missionId;

		COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;
		PRINT 'Error';
		THROW;
	END CATCH;
 END;

EXEC DeleteAllMissionData
	@missionId = 106;


SELECT * FROM mission;
SELECT * FROM mission_application;	
SELECT * FROM mission_document;
SELECT * FROM mission_invite;
SELECT * FROM mission_media;
SELECT * FROM mission_rating;
SELECT * FROM mission_skill;
SELECT * FROM goal_mission;
SELECT * FROM favourite_mission;
SELECT * FROM comment;
SELECT * FROM  story;
SELECT * FROM timesheet;

EXEC sp_databases;
SELECT * FROM master.sys.databases ORDER BY name;  