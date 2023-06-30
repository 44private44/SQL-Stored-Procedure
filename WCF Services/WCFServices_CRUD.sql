
USE [CIPlatform]

SELECT * FROM admin;

-- Getting All Admin Data
ALTER PROCEDURE Admin_Alldata
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY 
		BEGIN TRANSACTION
			select a.admin_id, a.first_name AS FirstName ,a.last_name AS LastName, a.email, a.[password] from admin as a;
		COMMIT;
	END TRY
	BEGIN CATCH
	END CATCH;
END;

EXEC Admin_alldata;

-- Insert Admin Data
ALTER PROCEDURE Insert_Admin_data
	@FirstName VARCHAR(16),
	@LastName VARCHAR(16),
	@Email VARCHAR(128),
	@Password VARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION
			Insert into admin(first_name, last_name, email , password) VALUES(@FirstName, @LastName, @Email , @Password);
		COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;
		THROW;
	END CATCH;
END;

EXEC Insert_admin_data
	@FirstName = 'Soham',
	@LastName = 'Patel',
	@Email = 'sohamkenvi99@gmail.com',
	@Password = 'Kenvi';

-- Update Admin Data
ALTER PROCEDURE Update_adminData
	@FirstName VARCHAR(16),
	@LastName VARCHAR(16),
	@Admin_id BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION
			
			UPDATE admin SET first_name = @FirstName, last_name = @LastName 
				WHERE admin_id = @Admin_id;
		COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;
		THROW;
	END CATCH;
END;

EXEC Update_adminData
	@FirstName = 'rushi',
	@LastName = 'patel',
	@Admin_id = 10


-- Delete Admin Data
ALTER PROCEDURE Delete_adminData
	@Admin_id BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM admin WHERE admin_id = @Admin_id;
		COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;
		THROW;
	END CATCH;
END;

exec Delete_adminData
	@Admin_id = 10;