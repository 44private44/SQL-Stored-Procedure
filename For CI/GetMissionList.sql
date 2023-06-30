-- get all the mission list

USE CIPlatform;

ALTER PROCEDURE allMissionData
AS
BEGIN
    SET NOCOUNT ON;

    WITH MediaCTE AS (
        SELECT 
            mm.mission_id,
            mm.media_path,
            ROW_NUMBER() OVER (PARTITION BY mm.mission_id ORDER BY mm.mission_media_id) AS firstImage
        FROM mission_media AS mm
    ),
    ApproveCTE AS (
        SELECT 
            ma.mission_id,
            ma.approval_status,
			ma.mission_application_id,
            ROW_NUMBER() OVER (PARTITION BY ma.mission_id ORDER BY ma.mission_application_id) AS rowNumber
        FROM mission_application AS ma
		WHERE ma.user_id = 13
    ),
	RatingCTE AS(
		SELECT 
		mr.mission_id,
		mr.rating,
		ROW_NUMBER() OVER (PARTITION BY mr.mission_id ORDER BY mr.mission_rating_id) AS ratingno
		FROM mission_rating AS mr
	),
	AvgratingCTE AS (
        SELECT
            mission_id,
            AVG(rating) AS average_rating
        FROM RatingCTE
        GROUP BY mission_id
    )

    SELECT 
        m.*, 
        ci.name AS city_name,
        country.name AS country_name,
        mt.title AS theme_name,
        MediaCTE.media_path,
        ApproveCTE.approval_status,
		ApproveCTE.mission_application_id,
		RatingCTE.rating,
		AvgratingCTE.average_rating,
        gm.goal_objective_text AS goal_text,
        gm.goal_value AS goal_value
    FROM mission AS m
    LEFT JOIN city AS ci ON m.city_id = ci.city_id
    LEFT JOIN country AS country ON m.country_id = country.country_id
    LEFT JOIN mission_theme AS mt ON m.theme_id = mt.mission_theme_id 
    LEFT JOIN MediaCTE ON m.mission_id = MediaCTE.mission_id AND MediaCTE.firstImage = 1
    LEFT JOIN goal_mission AS gm ON m.mission_id = gm.mission_id
    LEFT JOIN ApproveCTE ON m.mission_id = ApproveCTE.mission_id AND ApproveCTE.rowNumber = 1
	LEFT JOIN RatingCTE ON m.mission_id = RatingCTE.mission_id AND RatingCTE.ratingno = 1
	LEFT JOIN AvgratingCTE ON m.mission_id = AvgratingCTE.mission_id
END;

EXEC allMissionData
 

 -- getting the one mission accordingly pass to the mission id by user 

ALTER PROCEDURE OneMissionData
	@missionid BIGINT	
AS
BEGIN
    SET NOCOUNT ON;

    WITH MediaCTE AS (	
        SELECT 
            mm.mission_id,
            mm.media_path,
            ROW_NUMBER() OVER (PARTITION BY mm.mission_id ORDER BY mm.mission_media_id) AS firstImage
        FROM mission_media AS mm
    ),
    ApproveCTE AS (
        SELECT 
            ma.mission_id,
            ma.approval_status,
			ma.mission_application_id,
            ROW_NUMBER() OVER (PARTITION BY ma.mission_id ORDER BY ma.mission_application_id) AS rowNumber
        FROM mission_application AS ma
		WHERE ma.user_id = 13
    ),
	RatingCTE AS(
		SELECT 
		mr.mission_id,
		mr.rating,
		ROW_NUMBER() OVER (PARTITION BY mr.mission_id ORDER BY mr.mission_rating_id) AS ratingno
		FROM mission_rating AS mr
	),
	AvgratingCTE AS (
        SELECT
            mission_id,
            AVG(rating) AS average_rating
        FROM RatingCTE
        GROUP BY mission_id
    )

    SELECT 
        m.*, 
        ci.name AS city_name,
        country.name AS country_name,
        mt.title AS theme_name,
        MediaCTE.media_path,
        ApproveCTE.approval_status,
		ApproveCTE.mission_application_id,
		RatingCTE.rating,
		AvgratingCTE.average_rating,
        gm.goal_objective_text AS goal_text,
        gm.goal_value AS goal_value
    FROM mission AS m
    LEFT JOIN city AS ci ON m.city_id = ci.city_id
    LEFT JOIN country AS country ON m.country_id = country.country_id
    LEFT JOIN mission_theme AS mt ON m.theme_id = mt.mission_theme_id 
    LEFT JOIN MediaCTE ON m.mission_id = MediaCTE.mission_id AND MediaCTE.firstImage = 1
    LEFT JOIN goal_mission AS gm ON m.mission_id = gm.mission_id
    LEFT JOIN ApproveCTE ON m.mission_id = ApproveCTE.mission_id AND ApproveCTE.rowNumber = 1
	LEFT JOIN RatingCTE ON m.mission_id = RatingCTE.mission_id AND RatingCTE.ratingno = 1
	LEFT JOIN AvgratingCTE ON m.mission_id = AvgratingCTE.mission_id
	WHERE m.mission_id = @missionid
END;

EXEC OneMissionData
@missionid = 4;

------------------For Dapper sued SP------------------------

ALTER PROCEDURE MissionDataByDapper
AS
BEGIN
    SET NOCOUNT ON;

    WITH MediaCTE AS (
        SELECT 
            mm.mission_id,
            mm.media_path,
            ROW_NUMBER() OVER (PARTITION BY mm.mission_id ORDER BY mm.mission_media_id) AS firstImage
        FROM mission_media AS mm
    ),
    ApproveCTE AS (
        SELECT 
            ma.mission_id,
            ma.approval_status,
			ma.mission_application_id,
            ROW_NUMBER() OVER (PARTITION BY ma.mission_id ORDER BY ma.mission_application_id) AS rowNumber
        FROM mission_application AS ma
		WHERE ma.user_id = 13
    ),
	RatingCTE AS(
		SELECT 
		mr.mission_id,
		mr.rating,
		ROW_NUMBER() OVER (PARTITION BY mr.mission_id ORDER BY mr.mission_rating_id) AS ratingno
		FROM mission_rating AS mr
	),
	AvgratingCTE AS (
        SELECT
            mission_id,
            AVG(rating) AS average_rating
        FROM RatingCTE
        GROUP BY mission_id
    )

    SELECT 
        m.mission_id AS mission_id,
		m.theme_id AS theme_id,
		m.city_id AS city_id,
		m.country_id AS country_id,
		m.title AS title,
		m.short_description AS short_description,
		m.description AS description,
		m.start_date AS start_date,
		m.end_date AS end_date,
		m.mission_type AS mission_type,
		m.status AS status,
		m.organization_name AS org_name,
		m.organization_detail AS org_details,
		m.availability AS availability,
		m.seat_left AS seat_left,
		m.deadline AS deadline,
        ci.name AS city_name,
        country.name AS country_name,
        mt.title AS theme_name,
        MediaCTE.media_path,
        ApproveCTE.approval_status,
		ApproveCTE.mission_application_id,
		RatingCTE.rating,
		AvgratingCTE.average_rating,
        gm.goal_objective_text AS goal_text,
        gm.goal_value AS goal_value
    FROM mission AS m
    LEFT JOIN city AS ci ON m.city_id = ci.city_id
    LEFT JOIN country AS country ON m.country_id = country.country_id
    LEFT JOIN mission_theme AS mt ON m.theme_id = mt.mission_theme_id 
    LEFT JOIN MediaCTE ON m.mission_id = MediaCTE.mission_id AND MediaCTE.firstImage = 1
    LEFT JOIN goal_mission AS gm ON m.mission_id = gm.mission_id
    LEFT JOIN ApproveCTE ON m.mission_id = ApproveCTE.mission_id AND ApproveCTE.rowNumber = 1
	LEFT JOIN RatingCTE ON m.mission_id = RatingCTE.mission_id AND RatingCTE.ratingno = 1
	LEFT JOIN AvgratingCTE ON m.mission_id = AvgratingCTE.mission_id
END;

EXEC MissionDataByDapper;

-------------------------------------------------------------------------------
 -- getting the one mission accordingly pass to the mission id by user 
 -- Dapper 

CREATE PROCEDURE OneMissionDataByDapper
	@missionid BIGINT	
AS
BEGIN
    SET NOCOUNT ON;

    WITH MediaCTE AS (	
        SELECT 
            mm.mission_id,
            mm.media_path,
            ROW_NUMBER() OVER (PARTITION BY mm.mission_id ORDER BY mm.mission_media_id) AS firstImage
        FROM mission_media AS mm
    ),
    ApproveCTE AS (
        SELECT 
            ma.mission_id,
            ma.approval_status,
			ma.mission_application_id,
            ROW_NUMBER() OVER (PARTITION BY ma.mission_id ORDER BY ma.mission_application_id) AS rowNumber
        FROM mission_application AS ma
		WHERE ma.user_id = 13
    ),
	RatingCTE AS(
		SELECT 
		mr.mission_id,
		mr.rating,
		ROW_NUMBER() OVER (PARTITION BY mr.mission_id ORDER BY mr.mission_rating_id) AS ratingno
		FROM mission_rating AS mr
	),
	AvgratingCTE AS (
        SELECT
            mission_id,
            AVG(rating) AS average_rating
        FROM RatingCTE
        GROUP BY mission_id
    )

    SELECT 
        m.mission_id AS mission_id,
		m.theme_id AS theme_id,
		m.city_id AS city_id,
		m.country_id AS country_id,
		m.title AS title,
		m.short_description AS short_description,
		m.description AS description,
		m.start_date AS start_date,
		m.end_date AS end_date,
		m.mission_type AS mission_type,
		m.status AS status,
		m.organization_name AS org_name,
		m.organization_detail AS org_details,
		m.availability AS availability,
		m.seat_left AS seat_left,
		m.deadline AS deadline,
        ci.name AS city_name,
        country.name AS country_name,
        mt.title AS theme_name,
        MediaCTE.media_path,
        ApproveCTE.approval_status,
		ApproveCTE.mission_application_id,
		RatingCTE.rating,
		AvgratingCTE.average_rating,
        gm.goal_objective_text AS goal_text,
        gm.goal_value AS goal_value
    FROM mission AS m
    LEFT JOIN city AS ci ON m.city_id = ci.city_id
    LEFT JOIN country AS country ON m.country_id = country.country_id
    LEFT JOIN mission_theme AS mt ON m.theme_id = mt.mission_theme_id 
    LEFT JOIN MediaCTE ON m.mission_id = MediaCTE.mission_id AND MediaCTE.firstImage = 1
    LEFT JOIN goal_mission AS gm ON m.mission_id = gm.mission_id
    LEFT JOIN ApproveCTE ON m.mission_id = ApproveCTE.mission_id AND ApproveCTE.rowNumber = 1
	LEFT JOIN RatingCTE ON m.mission_id = RatingCTE.mission_id AND RatingCTE.ratingno = 1
	LEFT JOIN AvgratingCTE ON m.mission_id = AvgratingCTE.mission_id
	WHERE m.mission_id = @missionid
END;

EXEC OneMissionDataByDapper
	@missionid = 4;
----------------------------------------------------------
-- Drag Drop sort the order SP for the Mission Data
USE CIPlatform;

SELECT * FROM mission;

ALTER TABLE mission
ADD sort_order int default 0; 

ALTER TABLE mission
DROP sort_order;

ALTER PROCEDURE DragdropSortMission
AS
BEGIN
	SET NOCOUNT ON;
	
    WITH MediaCTE AS (
        SELECT 
            mm.mission_id,
            mm.media_path,
            ROW_NUMBER() OVER (PARTITION BY mm.mission_id ORDER BY mm.mission_media_id) AS firstImage
        FROM mission_media AS mm
    ),
    ApproveCTE AS (
        SELECT 
            ma.mission_id,
            ma.approval_status,
			ma.mission_application_id,
            ROW_NUMBER() OVER (PARTITION BY ma.mission_id ORDER BY ma.mission_application_id) AS rowNumber
        FROM mission_application AS ma
		WHERE ma.user_id = 13
    ),
	RatingCTE AS(
		SELECT 
		mr.mission_id,
		mr.rating,
		ROW_NUMBER() OVER (PARTITION BY mr.mission_id ORDER BY mr.mission_rating_id) AS ratingno
		FROM mission_rating AS mr
	),
	AvgratingCTE AS (
        SELECT
            mission_id,
            AVG(rating) AS average_rating
        FROM RatingCTE
        GROUP BY mission_id
    )

    SELECT 
        m.mission_id AS mission_id,
		m.theme_id AS theme_id,
		m.city_id AS city_id,
		m.country_id AS country_id,
		m.title AS title,
		m.short_description AS short_description,
		m.description AS description,
		m.start_date AS start_date,
		m.end_date AS end_date,
		m.mission_type AS mission_type,
		m.status AS status,
		m.organization_name AS org_name,
		m.organization_detail AS org_details,
		m.availability AS availability,
		m.seat_left AS seat_left,
		m.deadline AS deadline,
		m.sort_order AS [order],
        ci.name AS city_name,
        country.name AS country_name,
        mt.title AS theme_name,
        MediaCTE.media_path,
        ApproveCTE.approval_status,
		ApproveCTE.mission_application_id,
		RatingCTE.rating,
		AvgratingCTE.average_rating,
        gm.goal_objective_text AS goal_text,
        gm.goal_value AS goal_value
    FROM mission AS m
    LEFT JOIN city AS ci ON m.city_id = ci.city_id
    LEFT JOIN country AS country ON m.country_id = country.country_id
    LEFT JOIN mission_theme AS mt ON m.theme_id = mt.mission_theme_id 
    LEFT JOIN MediaCTE ON m.mission_id = MediaCTE.mission_id AND MediaCTE.firstImage = 1
    LEFT JOIN goal_mission AS gm ON m.mission_id = gm.mission_id
    LEFT JOIN ApproveCTE ON m.mission_id = ApproveCTE.mission_id AND ApproveCTE.rowNumber = 1
	LEFT JOIN RatingCTE ON m.mission_id = RatingCTE.mission_id AND RatingCTE.ratingno = 1
	LEFT JOIN AvgratingCTE ON m.mission_id = AvgratingCTE.mission_id
	ORDER BY [order] ASC;
	
END;

EXEC DragdropSortMission;


-- Create a new stored procedure to update mission orders

ALTER PROCEDURE UpdateMissionOrder
    @missionId BIGINT,
    @newOrder INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        PRINT 'Updating order of friend with ID: ' + CAST(@missionId AS VARCHAR(10));

        -- Get the current order of the specified friend
        DECLARE @currentOrder INT;
        SELECT @currentOrder = sort_order FROM mission WHERE mission_id = @missionId;

        -- Update the order of the specified friend
        UPDATE mission
        SET sort_order = @newOrder
        WHERE mission_id = @missionId;

        -- Update the order of other friends accordingly
        IF @currentOrder < @newOrder
        BEGIN
            UPDATE mission
            SET sort_order = sort_order - 1
            WHERE mission_id <> @missionId AND sort_order > @currentOrder AND sort_order <= @newOrder;
        END
        ELSE
        BEGIN
            UPDATE mission
            SET sort_order = sort_order + 1
            WHERE mission_id <> @missionId AND sort_order >= @newOrder AND sort_order < @currentOrder;
        END;

        PRINT 'Order updated for friend with ID: ' + CAST(@missionId AS VARCHAR(10));

        PRINT 'Order updated for all mission';

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;

EXEC UpdateMissionOrder 
	@missionId = 4, 
	@newOrder = 6;
	
EXEC DragdropSortMission;
