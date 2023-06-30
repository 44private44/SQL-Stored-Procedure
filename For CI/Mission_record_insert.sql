-- Mission Records insert and it's child table

ALTER PROCEDURE InsertAllMissionData
(
  @themeId BIGINT,
  @cityId BIGINT,
  @countryId BIGINT,
  @title VARCHAR(128),
  @shortDescription TEXT = NULL,
  @description TEXT = NULL,
  @startDate DATETIME = NULL,
  @endDate DATETIME = NULL,
  @missionType VARCHAR(20),
  @status VARCHAR(20),
  @organizationName VARCHAR(255) = NULL,
  @organizationDetail TEXT = NULL,
  @availability VARCHAR(25),
  @userId BIGINT,
  @approvalStatus VARCHAR(20),
  @multiMissionDoc dbo.MultiMissionDocument READONLY,
  @toUserId BIGINT,
  @multiMissionMediaData dbo.MultiMissionMediaData READONLY,
  @rating INT,
  @skillId BIGINT,
  @goalText VARCHAR(255),
  @goalValue INT,
  @approveStatus VARCHAR(10),
  @comment VARCHAR(50) = NULL,
  @storyTitle VARCHAR(255) = NULL,
  @storyDesc VARCHAR(255) = NULL,
  @storyStatus VARCHAR(20),
  @storyViews BIGINT,
  @hours INT,
  @minutes INT,
  @timesheetDate DATETIME,
  @timesheetAction INT,
  @timesheetNotes TEXT,
  @timesheetSTATUS VARCHAR(20),
  @missionIdOut BIGINT OUTPUT
)
AS
BEGIN

  BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Insert into mission table
    INSERT INTO mission (theme_id, city_id, country_id, title, short_description, [description], [start_date], end_date, mission_type, [status], organization_name, organization_detail, [availability])
    VALUES (@themeId, @cityId, @countryId, @title, @shortDescription, @description, @startDate, @endDate, @missionType, @status, @organizationName, @organizationDetail, @availability);
    
    SET @missionIdOut = SCOPE_IDENTITY();

    -- Insert into mission_application table
    INSERT INTO mission_application (mission_id, [user_id], applied_at, approval_status)
    VALUES (@missionIdOut, @userId, CURRENT_TIMESTAMP, @approvalStatus);

	-- Insert into mission_document table
	INSERT INTO mission_document(mission_id,[document_name],document_type,document_path)
	SELECT @missionIdOut, document_name, document_type, document_path
	FROM @multiMissionDoc;

	--Insert into mision_invite table
	INSERT INTO mission_invite (mission_id, from_user_id, to_user_id)
	VALUES(@missionIdOut, @userId, @toUserId)

	--Insert into mission_media table
	INSERT INTO mission_media(mission_id, media_name, media_type, media_path)
	SELECT @missionIdOut, media_name, media_type, media_path
    FROM @multiMissionMediaData;

	--Insert into mision_rating table
	INSERT INTO mission_rating([user_id],mission_id,rating)
	VALUES(@userId, @missionIdOut, @rating)

	--Insert into mission_skill table
	INSERT INTO mission_skill(skill_id, mission_id)
	VALUES(@skillId, @missionIdOut)
	
	--Insert into goal_mission table
	IF @missionType = 'GOAL'
		BEGIN
			INSERT INTO goal_mission (mission_id, goal_objective_text, goal_value)
			VALUES (@missionIdOut, @goalText, @goalValue);
		END

	--Insert into favourite_mission table
	INSERT INTO favourite_mission([user_id], mission_id)
	VALUES(@userId, @missionIdOut)

	--Insert into comment table
	INSERT INTO comment([user_id], mission_id, approval_status,Comment)
	VALUES(@userId, @missionIdOut, @approveStatus, @comment)

	--Insert into story table
	INSERT INTO story([user_id], mission_id, title, [description], [status], [views])
	VALUES(@userId, @missionIdOut, @storyTitle, @storyDesc, @storyStatus, @storyViews) 

	DECLARE @timeValue TIME = CAST(CONCAT(@hours, ':', @minutes) AS TIME);

	--Insert into timesheet table
	INSERT INTO timesheet([user_id], mission_id, [time], date_volunteered, [action], notes, [status])
	VALUES(@userId, @missionIdOut, @timeValue, @timesheetDate, @timesheetAction, @timesheetNotes, @timesheetStatus) 

    -- Commit the transaction
    COMMIT;
  END TRY
  BEGIN CATCH
    -- Rollback the transaction if an error occurs
    IF @@TRANCOUNT > 0
      ROLLBACK;

    -- Propagate the error
	PRINT 'Error';
    THROW;
  END CATCH;
END;

DECLARE @missionId BIGINT;
-- custome datatype
DECLARE @multiMissionDoc dbo.MultiMissionDocument;
DECLARE @multiMissionMediaData dbo.MultiMissionMediaData;

INSERT INTO @multiMissionMediaData (media_name, media_type, media_path)
VALUES
    ('Mission2-Photo1', 'jpg', 'IMAGES/CI Platform Assets/K1tech_Cover.jpg'),
    ('Mission3-Photo2', 'jpg', 'IMAGES/CI Platform Assets/Grow-Trees-On-the-path-to-environment-sustainability-1.png'),
    ('Mission2-Photo1', 'jpg', 'IMAGES/CI Platform Assets/K1tech_Cover.jpg');

INSERT INTO @multiMissionDoc (document_name, document_type, document_path)
VALUES
	('Education', 'docx', 'Documents/Importance Of Education.docx'),
	('Save Animals', 'pdf', 'Documents/Animals.pdf');

EXEC InsertAllMissionData
  @themeId = 1,
  @cityId = 1,
  @countryId = 1,
  @title = 'Teaching Computer Skills to Senior Citizens',
  @shortDescription = 'Volunteers will teach computer skills to senior citizens',
  @description = 'We are looking for volunteers to teach computer skills...',
  @startDate = '2023-05-23',
  @endDate = '2023-05-24',
  @missionType = 'TIME',
  @status = 1,
  @organizationName = 'Greenpeace',
  @organizationDetail = 'Greenpeace is a non-profit organization that works...',
  @availability = 'DAILY',
  @userId = 13,
  @approvalStatus = 'PENDING',
  @multiMissionDoc = @multiMissionDoc,
  @toUserId = 5,
  @multiMissionMediaData = @multiMissionMediaData,
  @rating = 4,
  @skillId = 8,
  @goalText = 'Plant 10,000 Trees',
  @goalValue = '5000',
  @approveStatus = 'Pending',
  @comment = 'I liked this mission',
  @storyTitle = 'Teaching English in Rural Schools',
  @storyDesc = 'We live in a global world where our existence...',
  @storyStatus = 'DRAFT',
  @storyViews = 404,
  @hours = 12,
  @minutes = 44,
  @timesheetDate = '2023-07-06',
  @timesheetAction = 1,
  @timesheetNotes = 'Good time invest',
  @timesheetStatus = 'APPROVED',
  @missionIdOut = @missionId OUTPUT;

  --user defined table type

  CREATE TYPE MultiMissionDocument AS TABLE
(
	document_name VARCHAR(255),
	document_type VARCHAR(255),
	document_path VARCHAR(255)
);

  CREATE TYPE MultiMissionMediaData AS TABLE
(
    media_name VARCHAR(64),
    media_type VARCHAR(4),
	media_path VARCHAR(255)
);

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

DELETE FROM mission
WHERE mission_id BETWEEN 108 AND 190;

delete from mission_application
where mission_id between 108 and 190;

delete from mission_media
where mission_id between 108 and 190;

delete from goal_mission
where mission_id between 108 and 190;
-- Mission insert

ALTER PROCEDURE InsertMissionData
(
  @themeId BIGINT,
  @cityId BIGINT,
  @countryId BIGINT,
  @title VARCHAR(128),
  @shortDescription TEXT = NULL,
  @description TEXT = NULL,
  @startDate DATETIME = NULL,
  @endDate DATETIME = NULL,
  @missionType VARCHAR(20),
  @status VARCHAR(20),
  @organizationName VARCHAR(255) = NULL,
  @organizationDetail TEXT = NULL,
  @availability VARCHAR(25),
  @userId BIGINT,
  @deadline DATE = NULL,
  @seatleft NCHAR(10) = 0,
  @goalText VARCHAR(255) = null,
  @goalValue INT = 0,
  @multiMissionMediaData dbo.MultiMissionMediaData READONLY,
  @missionIdOut BIGINT OUTPUT
)
AS
BEGIN

  BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Insert into mission table
    INSERT INTO mission (theme_id, city_id, country_id, title, short_description, [description], [start_date], end_date, mission_type, [status], organization_name, organization_detail, [availability], deadline,seat_left)
    VALUES (@themeId, @cityId, @countryId, @title, @shortDescription, @description, @startDate, @endDate, @missionType, @status, @organizationName, @organizationDetail, @availability, @deadline, @seatleft);
    
    SET @missionIdOut = SCOPE_IDENTITY();

	--Insert into goal_mission table
	IF @missionType = 'GOAL'
		BEGIN
			INSERT INTO goal_mission (mission_id, goal_objective_text, goal_value)
			VALUES (@missionIdOut, @goalText, @goalValue);
		END
	
	-- Insert into missioin application table
	INSERT INTO mission_application (mission_id, [user_id], applied_at, approval_status)
	VALUES (@missionIdOut, @userId, GETDATE(), 'PENDING');
		
	--Insert into mission_media table
	INSERT INTO mission_media(mission_id, media_name, media_type, media_path)
	SELECT @missionIdOut, media_name, media_type, media_path
    FROM @multiMissionMediaData;

    -- Commit the transaction
    COMMIT;
  END TRY
  BEGIN CATCH
    -- Rollback the transaction if an error occurs
    IF @@TRANCOUNT > 0
      ROLLBACK;

    -- Propagate the error
	PRINT 'Error';
    THROW;
  END CATCH;
END;

DECLARE @missionId BIGINT;
DECLARE @multiMissionMediaData dbo.MultiMissionMediaData;

EXEC InsertMissionData
  @themeId = 1,
  @cityId = 1,
  @countryId = 1,
  @title = 'Teaching Computer Skills to Senior Citizens',
  @shortDescription = 'Volunteers will teach computer skills to senior citizens',
  @description = 'We are looking for volunteers to teach computer skills...',
  @startDate = '2023-05-23',
  @endDate = '2023-05-24',
  @missionType = 'TIME',
  @status = 1,
  @organizationName = 'Greenpeace',
  @organizationDetail = 'Greenpeace is a non-profit organization that works...',
  @availability = 'DAILY',
  @userId = 13, 
  @deadline = '2025-05-23',
  @seatleft = '100',
  @goalText = 'Plant 10,000 Trees',
  @goalValue = '5000',
  @multiMissionMediaData = @multiMissionMediaData,
  @missionIdOut = @missionId OUTPUT;
