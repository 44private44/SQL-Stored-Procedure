
USE imagesdb;

-- create the user table 

CREATE TABLE birthday_user
(
	user_name VARCHAR(50),
	birthdate DATETIME,
	);

ALTER TABLE birthday_user
ALTER COLUMN birthdate DATE;

ALTER TABLE birthday_user
ADD user_email VARCHAR(50);

ALTER TABLE birthday_user
ADD User_id BIGINT PRIMARY KEY IDENTITY(1,1); 

INSERT INTO birthday_user([user_name], birthdate) VALUES('soham', '2001-09-30');
INSERT INTO birthday_user([user_name], [birthdate], user_email) VALUES('kenvi', '2023-06-23','goodjob3092001@gmail.com');

SELECT * FROM birthday_user;

UPDATE birthday_user
SET user_email = 'sohammodi456@gmail.com' WHERE user_id = 2;

-- Getting the all user data Whose Today Birthday.
ALTER PROCEDURE Birthday_UserData
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION
			SELECT user_name AS [Name], birthdate AS Date, user_email AS Email FROM birthday_user
				WHERE birthdate = CONVERT(DATE, GETDATE());
		COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT >0
			ROLLBACK;

		THROW;
	END CATCH;
END;

EXEC Birthday_UserData;

UPDATE birthday_user
SET birthdate = '2023-06-27' WHERE USER_ID = 3;

--  MAKE Trigger
USE imagesdb;
SELECT * FROM imgRecords;
SELECT * FROM userData;

-- insert data trigger
ALTER TRIGGER insertData
ON userData
AFTER INSERT
AS
BEGIN
	DECLARE @userno BIGINT;
	SELECT @userno =  user_id FROM inserted;
	INSERT INTO imgRecords
	VALUES('JFBJWRBFW.PnG', @userno, 2);
END

INSERT INTO userData(user_name, user_password, request_token, ExpirationTime)
VALUES('sjbwjkqb','dkjwbek','efkwjnfqjbkjbqwlffwf','2023-06-15 16:42:14.170');

-- Delete trigger

ALTER TRIGGER deleteData
ON userData
AFTER DELETE
AS
BEGIN
	DECLARE @userno BIGINT;
	SELECT @userno =  user_id FROM deleted;

	DELETE FROM imgRecords
	WHERE userno = @userno;
END;

DELETE FROM userData
WHERE user_id = 11;

