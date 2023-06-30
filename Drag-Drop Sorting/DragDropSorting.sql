-- Drag Drop sort the order SP

USE imagesdb;
SELECT * FROM Friends_Data;

CREATE TABLE Friends_Data (
	friend_id BIGINT PRIMARY KEY IDENTITY(1,1),
	[name] VARCHAR(50),
	[order] INT
)

INSERT INTO Friends_Data([name], [order])
VALUES('Soham Modi', 2), ('Bharti Modi', 1), ('Praful Sagar', 5), ('Pushparaj Parmar', 3), ('Ananya Parmar', 4), ('Anand Patel', 6), ('Bansi Patel', 7);


UPDATE Friends_Data
SET [order] = 8
WHERE friend_id = 8;

ALTER PROCEDURE DragdropSort
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION
			SELECT friend_id AS Id, [name], [order] FROM Friends_Data
			ORDER BY [order] ASC;
		COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;
		THROW
	END CATCH;
END;

EXEC DragdropSort;

-- Create a new stored procedure to update friend orders

ALTER PROCEDURE UpdateFriendOrder
    @friendId BIGINT,
    @newOrder INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        PRINT 'Updating order of friend with ID: ' + CAST(@friendId AS VARCHAR(10));

        -- Get the current order of the specified friend
        DECLARE @currentOrder INT;
        SELECT @currentOrder = [order] FROM Friends_Data WHERE friend_id = @friendId;

        -- Update the order of the specified friend
        UPDATE Friends_Data
        SET [order] = @newOrder
        WHERE friend_id = @friendId;

        -- Update the order of other friends accordingly
        IF @currentOrder < @newOrder
        BEGIN
            UPDATE Friends_Data
            SET [order] = [order] - 1
            WHERE friend_id <> @friendId AND [order] > @currentOrder AND [order] <= @newOrder;
        END
        ELSE
        BEGIN
            UPDATE Friends_Data
            SET [order] = [order] + 1
            WHERE friend_id <> @friendId AND [order] >= @newOrder AND [order] < @currentOrder;
        END;

        PRINT 'Order updated for friend with ID: ' + CAST(@friendId AS VARCHAR(10));

        SELECT * FROM Friends_Data;
        PRINT 'Order updated for all friends';

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;

EXEC UpdateFriendOrder 
	@friendId = 3, 
	@newOrder = 2;
	
EXEC DragdropSort;

----------------------------------

---- TEMP----
ALTER PROCEDURE UpdateFriendOrder
    @friendId BIGINT,
    @newOrder INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Update the order of the specified friend
        UPDATE Friends_Data
        SET [order] = @newOrder
        WHERE friend_id = @friendId;

        -- Update the order of other friends accordingly
        WITH UpdatedOrders AS (
            SELECT friend_id, [order],
               ROW_NUMBER() OVER (ORDER BY [order] ASC) AS NewOrder
            FROM Friends_Data
        )
	
        UPDATE FriendOrd
        SET FriendOrd.[order] = FriendOrd.NewOrder
        FROM UpdatedOrders FriendOrd;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;


----- Sort by using the Sortable.js file--------------
			