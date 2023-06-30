CREATE DATABASE [CI Platform];
USE [CI Platform];

ALTER DATABASE [CI Platform] MODIFY NAME = CIPlatform;  
--admin

ALTER TABLE [admin] (
	admin_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	first_name VARCHAR(16) NULL DEFAULT NULL,
	last_name VARCHAR(16) NULL DEFAULT NULL,
	email VARCHAR(128) NOT NULL,
	[password] VARCHAR(255) NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

--banner

ALTER TABLE banner (
	banner_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	[image] VARCHAR(512) NOT NULL,
	[text] TEXT DEFAULT NULL,
	sort_order INT DEFAULT 0,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

--city

ALTER TABLE city(
	city_id BIGINT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	country_id BIGINT NOT NULL,
	[name] VARCHAR(255) NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

ALTER TABLE city ADD CONSTRAINT FK_country_city 
FOREIGN KEY (country_id) REFERENCES country(country_id);
 
--comment

ALTER TABLE comment (
	comment_id BIGINT identity(1,1) primary key,
	[user_id] BIGINT NOT NULL,
	mission_id BIGINT NOT NULL,
	approval_status varchar(10) NOT NULL CHECK (approval_status IN('Pending', 'Published')) default 'Pending',
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

ALTER TABLE comment ADD CONSTRAINT FK_user_comment
FOREIGN KEY([user_id]) REFERENCES [user]([user_id]);

ALTER TABLE comment ADD CONSTRAINT FK_mission_comment
FOREIGN KEY([mission_id]) REFERENCES mission([mission_id]);

--country

CREATE TABLE country(
	country_id BIGINT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[name] VARCHAR(255) NOT NULL,
	ISO VARCHAR(16) NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

--cms_page

ALTER TABLE cms_page (
	cms_page_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	title VARCHAR(255),
	[description] text,
	slug varchar(255) NOT NULL,
	[status] INT CHECK([status] in (0,1)) DEFAULT 1,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

--fav_mission

ALTER TABLE favourite_mission (
	favourite_mission_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	[user_id] BIGINT NOT NULL,
	mission_id BIGINT NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

ALTER TABLE favourite_mission ADD CONSTRAINT FK_user_favmis
FOREIGN KEY ([user_id]) REFERENCES [user]([user_id]);

ALTER TABLE favourite_mission ADD CONSTRAINT FK_mission_favmis
FOREIGN KEY ([mission_id]) REFERENCES mission(mission_id);

--goal_mission

ALTER TABLE goal_mission (
	goal_mission_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	mission_id BIGINT NOT NULL,
	goal_objective_text VARCHAR(255) NULL DEFAULT NULL,
	goal_value INT NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

ALTER TABLE goal_mission ADD CONSTRAINT FK_mission_goamis
FOREIGN KEY (mission_id) REFERENCES mission(mission_id);

--mission

ALTER TABLE mission (
	mission_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	theme_id BIGINT NOT NULL,
	city_id BIGINT NOT NULL,
	country_id BIGINT NOT NULL,
	title VARCHAR(128) NOT NULL,
	short_description TEXT DEFAULT NULL,
	[description] TEXT DEFAULT NULL,
	[start_date] DATETIME NULL DEFAULT NULL,
	end_date DATETIME NULL DEFAULT NULL,
	mission_type varchar(20) NOT NULL check (mission_type in('GOAL','TIME')),
	[status] varchar(20) NOT NULL check (status in('0','1')),
	organization_name varchar(255) NULL DEFAULT NULL,
	organization_detail TEXT NULL DEFAULT NULL,
	[availability] varchar(25) NOT NULL check ([availability] in('DAILY','WEEKLY','MONTHLY','WEEK-END')) ,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);
Delete from mission;

ALTER TABLE mission ADD CONSTRAINT FK_theme_mission
FOREIGN KEY (theme_id) REFERENCES mission_theme(mission_theme_id);

ALTER TABLE mission ADD CONSTRAINT FK_city_mission
FOREIGN KEY (city_id) REFERENCES city(city_id);

ALTER TABLE mission ADD CONSTRAINT FK_country_mission
FOREIGN KEY (country_id) REFERENCES country(country_id);


-- mission_application

ALTER TABLE mission_application(
  mission_application_id BIGINT IDENTITY(1, 1) PRIMARY KEY, 
  mission_id BIGINT NOT NULL,
  [user_id] BIGINT NOT NULL,
  applied_at DATETIME NOT NULL DEFAULT current_timestamp,
  approval_status varchar(20) not null check (approval_status in('PENDING','APPROVE','DECLINE')) DEFAULT 'PENDING',
  created_at DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL,
  deleted_at DATETIME NULL DEFAULT NULL
);

ALTER TABLE mission_application ADD CONSTRAINT FK_mission_misapp
FOREIGN KEY (mission_id) REFERENCES mission(mission_id);

ALTER TABLE mission_application ADD CONSTRAINT FK_user_misapp
FOREIGN KEY ([user_id]) REFERENCES [user]([user_id]);

-- mission_document
ALTER TABLE mission_document(
  mission_document_id BIGINT NOT NULL IDENTITY(1, 1) PRIMARY KEY, 
  mission_id BIGINT NOT NULL,
  document_name VARCHAR(255),
  document_type VARCHAR(255),
  document_path VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL,
  deleted_at DATETIME NULL DEFAULT NULL
);

ALTER TABLE mission_document ADD CONSTRAINT FK_mission_misdoc
FOREIGN KEY (mission_id) REFERENCES mission(mission_id);

--mission_invite

ALTER TABLE mission_invite(
	mission_invite_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	mission_id BIGINT NOT NULL,
	from_user_id BIGINT NOT NULL,
	to_user_id BIGINT NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

ALTER TABLE mission_invite ADD CONSTRAINT FK_mission_misinv
FOREIGN KEY (mission_id) REFERENCES mission(mission_id);

ALTER TABLE mission_invite ADD CONSTRAINT FK_fromuser_misinv
FOREIGN KEY (from_user_id) REFERENCES [user]([user_id]);

ALTER TABLE mission_invite ADD CONSTRAINT FK_touser_misinv
FOREIGN KEY (to_user_id) REFERENCES [user]([user_id]);

--mission_media

ALTER TABLE mission_media(
	mission_media_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	mission_id BIGINT NOT NULL,
	media_name VARCHAR(64),
	media_type VARCHAR(4),
	media_path VARCHAR(255) NULL,
	[default] VARCHAR NOT NULL CHECK([default] IN ('0','1')) DEFAULT '0',
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

ALTER TABLE mission_media ADD CONSTRAINT FK_mission_mismed
FOREIGN KEY (mission_id) REFERENCES mission(mission_id);

--mission_rating

ALTER TABLE mission_rating(
	mission_rating_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	[user_id] BIGINT NOT NULL,
	mission_id BIGINT NOT NULL,
	rating INT NOT NULL CHECK(rating IN (1,2,3,4,5)),
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

ALTER TABLE mission_rating ADD CONSTRAINT FK_user_misrat
FOREIGN KEY ([user_id]) REFERENCES [user]([user_id]);

ALTER TABLE mission_rating ADD CONSTRAINT FK_mission_misrat
FOREIGN KEY (mission_id) REFERENCES mission(mission_id);

--mission_skill

ALTER TABLE mission_skill(
	mission_skill_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	skill_id BIGINT NOT NULL,
	mission_id BIGINT NULL DEFAULT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

ALTER TABLE mission_skill ADD CONSTRAINT FK_skill_misski
FOREIGN KEY (skill_id) REFERENCES skill(skill_id);

ALTER TABLE mission_skill ADD CONSTRAINT FK_mission_misski
FOREIGN KEY (mission_id) REFERENCES mission(mission_id);

--mission_theme

ALTER TABLE mission_theme(
	mission_theme_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	title VARCHAR(255),
	[status] TINYINT NOT NULL DEFAULT 1,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL
);

--Table : password_reset
create TABLE password_reset(
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
	email VARCHAR(191) NOT NULL,
	token VARCHAR(191) NOT NULL,
	created_at DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
);

--Table : skill
ALTER TABLE skill(
	skill_id BIGINT IDENTITY(1, 1) PRIMARY KEY,
	skill_name VARCHAR(64),
	[status] TINYINT NOT NULL DEFAULT 1,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
    deleted_at DATETIME NULL DEFAULT NULL 
);

--Table : story
Create TABLE story(
	story_id BIGINT IDENTITY(1, 1) PRIMARY KEY,
	[user_id] BIGINT NOT NULL,
	mission_id BIGINT NOT NULL,
	title varchar(255) NULL DEFAULT NULL,
	description varchar(255) NULL DEFAULT NULL,
	[status] VARCHAR(20) CHECK([status] IN ('DRAFT','PENDING','PUBLISHED','DECLINED')) DEFAULT 'DRAFT',
	published_at DATETIME NULL DEFAULT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT NULL,
    deleted_at DATETIME NULL DEFAULT NULL 
);

ALTER TABLE story ADD CONSTRAINT FK_user_story
FOREIGN KEY ([user_id]) REFERENCES [user]([user_id]);

ALTER TABLE story ADD CONSTRAINT FK_mission_story
FOREIGN KEY (mission_id) REFERENCES mission(mission_id);

--Table : story_invite
ALTER TABLE story_invite(
	story_invite_id BIGINT IDENTITY(1, 1) PRIMARY KEY,
	story_id BIGINT NOT NULL,
	from_user_id BIGINT NOT NULL,
	to_user_id BIGINT NOT NULL,
	created_at DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL DEFAULT NULL,
    deleted_at DATETIME NULL DEFAULT NULL 
);

--Table : story_media
Create TABLE story_media(
	story_media_id BIGINT IDENTITY(1, 1) PRIMARY KEY,
	story_id BIGINT NOT NULL,
	[type] VARCHAR(20) NOT NULL,
	[path] TEXT NOT NULL,
	created_at DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL DEFAULT NULL,
    deleted_at DATETIME NULL DEFAULT NULL 
);

ALTER TABLE story_media ADD CONSTRAINT FK_story_stomed
FOREIGN KEY (story_id) REFERENCES story(story_id);

--Table : timesheet
alter TABLE timesheet(
	timesheet_id BIGINT IDENTITY(1, 1) PRIMARY KEY,
	[user_id] BIGINT NULL DEFAULT NULL,
	mission_id BIGINT NULL DEFAULT NULL,
	[time] TIME NULL,
	[action] INT NULL,
	date_volunteered DATETIME NOT NULL,
	notes TEXT NULL,
	[status] VARCHAR(20) CHECK([status] IN ('SUBMIT','PENDING','SUBMIT_FOR_APPROVAL','APPROVED','DECLINED')) DEFAULT 'PENDING',
	created_at DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL DEFAULT NULL,
    deleted_at DATETIME NULL DEFAULT NULL 
); 

ALTER TABLE timesheet ADD CONSTRAINT FK_user_timesheet
FOREIGN KEY ([user_id]) REFERENCES [user]([user_id]);

ALTER TABLE timesheet ADD CONSTRAINT FK_mission_timesheet
FOREIGN KEY (mission_id) REFERENCES mission(mission_id);


--Table : user
ALTER TABLE [user](
	[user_id] BIGINT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	first_name VARCHAR(16) DEFAULT NULL,
    last_name VARCHAR(16)  DEFAULT NULL,
    email VARCHAR(128) NOT NULL,
	[password] VARCHAR(255) NOT NULL,
	phone_number INT NOT NULL,
	avatar VARCHAR(2048) NULL DEFAULT NULL,
	why_i_volunteer TEXT NULL DEFAULT NULL,
	employee_id VARCHAR(16) NULL DEFAULT NULL,
	department VARCHAR(16) NULL DEFAULT NULL,
	city_id BIGINT NOT NULL,
	country_id BIGINT NOT NULL,
	profile_text TEXT NULL DEFAULT NULL,
	linked_in_url VARCHAR(255) NULL DEFAULT NULL,
	title VARCHAR(255) NULL DEFAULT NULL,
	[status] INT CHECK ([status] IN (0, 1)) DEFAULT 1,
	created_at DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL DEFAULT NULL,
    deleted_at DATETIME NULL DEFAULT NULL 
); 

ALTER TABLE [user] ADD CONSTRAINT FK_city_user
FOREIGN KEY (city_id) REFERENCES city(city_id);

ALTER TABLE [user] ADD CONSTRAINT FK_country_user
FOREIGN KEY (country_id) REFERENCES country(country_id);

--Table : user_skill
ALTER TABLE user_skill(
	user_skill_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	[user_id] BIGINT NOT NULL ,
	skill_id BIGINT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP ,
	updated_at DATETIME NULL DEFAULT NULL,
	deleted_at DATETIME NULL DEFAULT NULL 
);

ALTER TABLE user_skill ADD CONSTRAINT FK_user_userskill
FOREIGN KEY ([user_id]) REFERENCES [user]([user_id]);

ALTER TABLE user_skill ADD CONSTRAINT FK_skill_userskill
FOREIGN KEY (skill_id) REFERENCES skill(skill_id);

SELECT * FROM [user];

DELETE FROM [user];
DELETE FROM password_reset;

--Table : contactus
Create table contactus(
	contactus_id BIGINT IDENTITY(1,1) PRIMARY KEY,
	[user_id] BIGINT NOT NULL,
	[subject] VARCHAR(255) NOT NULL,
	[message] TEXT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP ,
);
ALTER TABLE contactus ADD CONSTRAINT FK_user_contactus
FOREIGN KEY ([user_id]) REFERENCES [user]([user_id]);

--data insert

INSERT INTO [User] 
    ("first_Name", "last_name", "email", "password", "phone_number", "avatar", "why_i_volunteer", "employee_id", "department", "city_id", "country_id", "profile_text", "linked_in_url", "title", "status", "created_at")
VALUES 

    ('John', 'Doe', 'johndoe@example.com', 'password123', 7890, 'https://example.com/avatar.jpg', 'I volunteer because...', '1234', 'IT', 1, 1, 'I am a software developer...', 'https://www.linkedin.com/in/johndoe', 'Software Developer', 1, GETDATE()),
    ('Jane', 'Doe', 'janedoe@example.com', 'password123', 78901, 'https://example.com/avatar.jpg', 'I volunteer because...', '2345', 'Sales', 2, 1, 'I am a sales executive...', 'https://www.linkedin.com/in/janedoe', 'Sales Executive', 0, GETDATE()),
    ('Bob', 'Smith', 'bobsmith@example.com', 'password123', 34565, 'https://example.com/avatar.jpg', 'I volunteer because...', '3456', 'HR', 3, 1, 'I am an HR manager...', 'https://www.linkedin.com/in/bobsmith', 'HR Manager', 1, GETDATE()),
    ('Alice', 'Johnson', 'alicejohnson@example.com', 'password123', 90123, 'https://example.com/avatar.jpg', 'I volunteer because...', '4567', 'Marketing', 4, 1, 'I am a marketing specialist...', 'https://www.linkedin.com/in/alicejohnson', 'Marketing Specialist', 0, GETDATE()),
    ('David', 'Lee', 'davidlee@example.com', 'password123', 567854, 'https://example.com/avatar.jpg', 'I volunteer because...', '5678', 'Finance', 5, 1, 'I am a financial analyst...', 'https://www.linkedin.com/in/davidlee', 'Financial Analyst', 1, GETDATE()),
    ('Emily', 'Chen', 'emilychen@example.com', 'password123', 12345, 'https://example.com/avatar.jpg', 'I volunteer because...', '6789', 'IT', 1, 1, 'I am a software engineer...', 'https://www.linkedin.com/in/emilychen', 'Software Engineer', 0, GETDATE()),
    ('Michael', 'Davis', 'michaeldavis@example.com', 'password123', 789045, 'https://example.com/avatar.jpg', 'I volunteer because...', '7890', 'Sales', 2, 1, 'I am a sales representative...', 'https://www.linkedin.com/in/michaeldavis', 'Sales Representative', 1, GETDATE())
	

INSERT INTO [admin]
    ("first_name", "last_name", "email", "password", "created_at")
VALUES
    ('John', 'Doe', 'johndoe@admin.com', 'password123', GETDATE()),
    ('Jane', 'Doe', 'janedoe@admin.com', 'password123', GETDATE()),
    ('Bob', 'Smith', 'bobsmith@admin.com', 'password123', GETDATE());


INSERT INTO [banner]
    ("image", "text", "sort_order", "created_at")
VALUES
    ('banner1.jpg', 'Banner 1 Text', 1, GETDATE()),
    ('banner2.jpg', 'Banner 2 Text', 2, GETDATE()),
    ('banner3.jpg', 'Banner 3 Text', 3, GETDATE()),
    ('banner4.jpg', 'Banner 4 Text', 4, GETDATE()),
    ('banner5.jpg', 'Banner 5 Text', 5, GETDATE()),
    ('banner6.jpg', 'Banner 6 Text', 6, GETDATE()),
    ('banner7.jpg', 'Banner 7 Text', 7, GETDATE()),
    ('banner8.jpg', 'Banner 8 Text', 8, GETDATE()),
    ('banner9.jpg', 'Banner 9 Text', 9, GETDATE()),
    ('banner10.jpg', 'Banner 10 Text', 10, GETDATE());


INSERT INTO [city]
    ("country_id", "name", "created_at")
VALUES
    (1, 'New York City', GETDATE()),
    (1, 'Los Angeles', GETDATE()),
    (1, 'Chicago', GETDATE()),
    (1, 'Houston', GETDATE()),
    (1, 'Phoenix', GETDATE()),
    (2, 'Toronto', GETDATE()),
    (2, 'Montreal', GETDATE()),
    (2, 'Vancouver', GETDATE()),
    (3, 'London', GETDATE()),
    (3, 'Manchester', GETDATE()),
    (3, 'Liverpool', GETDATE()),
    (4, 'Paris', GETDATE()),
    (4, 'Marseille', GETDATE()),
    (4, 'Lyon', GETDATE()),
    (5, 'Tokyo', GETDATE()),
    (5, 'Osaka', GETDATE()),
    (5, 'Yokohama', GETDATE()),
    (6, 'Sydney', GETDATE()),
    (6, 'Melbourne', GETDATE()),
    (6, 'Brisbane', GETDATE());

INSERT INTO [country]
    ( "name", "ISO", "created_at")
VALUES
    ( 'United States', 'US', GETDATE()),
    ( 'Canada', 'CA', GETDATE()),
    ( 'United Kingdom', 'UK', GETDATE()),
    ( 'France', 'FR', GETDATE()),
    ( 'Japan', 'JP', GETDATE()),
    ( 'Australia', 'AU', GETDATE()),
    ( 'Germany', 'DE', GETDATE()),
    ( 'Spain', 'ES', GETDATE()),
    ( 'Italy', 'IT', GETDATE()),
    ( 'China', 'CN', GETDATE()),
    ( 'Brazil', 'BR', GETDATE()),
    ( 'India', 'IN', GETDATE()),
    ( 'Mexico', 'MX', GETDATE()),
    ( 'South Korea', 'KR', GETDATE()),
    ( 'Netherlands', 'NL', GETDATE()),
    ( 'Switzerland', 'CH', GETDATE()),
    ( 'Sweden', 'SE', GETDATE()),
    ( 'Norway', 'NO', GETDATE()),
    ( 'Denmark', 'DK', GETDATE()),
    ( 'Finland', 'FI', GETDATE());


INSERT INTO [cms_page] ("title", "description", "slug", "status")
VALUES
('About Us', 'Learn more about our company and our mission.', 'about-us', '1'),
('Contact Us', 'Get in touch with our team and let us know how we can help.', 'contact-us', '1'),
('Terms and Conditions', 'Read our terms and conditions before using our services.', 'terms-and-conditions', '1'),
('Privacy Policy', 'Learn how we collect, use, and protect your personal information.', 'privacy-policy', '1'),
('FAQs', 'Frequently asked questions about our products and services.', 'faqs', '1'),
('Services', 'Explore the services we offer and how they can benefit you.', 'services', '1'),
('Blog', 'Read our latest blog posts for tips, advice, and insights.', 'blog', '1'),
('Career Opportunities', 'Join our team and help us make a difference.', 'careers', '1'),
('Events', 'Stay up-to-date on our upcoming events and how to participate.', 'events', '1'),
('Testimonials', 'See what our customers are saying about us.', 'testimonials', '1');

INSERT INTO [mission] ("theme_id", "city_id", "country_id", "title", "short_description", "description", "start_date", "end_date", "mission_type", "status", "organization_name", "organization_detail", "availability")
VALUES (1, 2, 3, 'Community Clean-Up Day', 'Join us in cleaning up the local park', 'We will provide gloves, trash bags, and other necessary equipment. Just bring yourself and your enthusiasm!', '2023-03-25 09:00:00', '2023-03-25 12:00:00', 'Time', 1, 'Green Earth Organization', 'We are a non-profit dedicated to preserving the environment', 'daily'),

 (2, 1, 4, 'Feed the Homeless', 'Help us provide meals to those in need', 'We will be serving hot meals to the homeless population in the city. Volunteers are needed to help prepare and distribute the meals.', '2023-04-02 10:00:00', '2023-04-02 14:00:00', 'Time', 1, 'Hope for the Homeless', 'We are a charity organization working to end homelessness', 'weekly'),

 (3, 5, 1, 'Plant Trees for the Future', 'Help us create a greener world', 'We will be planting trees in the city park to help combat climate change and provide a healthier environment for future generations.', '2023-04-22 09:00:00', '2023-04-22 12:00:00', 'Time', 1, 'Green World Initiative', 'We are a global organization dedicated to environmental conservation', 'week-end'),

 (1, 2, 3, 'Volunteer at a Local Animal Shelter', 'Help care for furry friends in need', 'We need volunteers to help us care for animals at the local shelter. Duties include walking dogs, cleaning cages, and providing love and attention to our furry residents.', '2023-04-15 13:00:00', '2023-04-15 16:00:00', 'Time', 1, 'Paws for a Cause', 'We are a non-profit organization working to find loving homes for abandoned animals', 'monthly'),

 (4, 6, 2, 'Plant Trees for the Future', 'Help us create a greener world', 'We will be planting trees in the city park to help combat climate change and provide a healthier environment for future generations.', '2023-04-22 09:00:00', '2023-04-22 12:00:00', 'Time', 1, 'Green World Initiative', 'We are a global organization dedicated to environmental conservation', 'week-end');


 INSERT INTO [mission_theme] ("title", "status") 
VALUES 
	('Education', 1),
	('Poverty', 1),
	('Healthcare', 1),
	('Environment', 1),
	('Human Rights', 1),
	('Refugees', 1),
	('Community Development', 1),
	('Disaster Relief', 1),
	('Women Empowerment', 1),
	('Youth Development', 1),
	('Economic Development', 1),
	('Food Security', 1),
	('Clean Water', 1),
	('Orphans Care', 1),
	('Animal Welfare', 1),
	('Arts and Culture', 1),
	('Sports and Recreation', 1),
	('Science and Technology', 1),
	('Faith-based Missions', 1),
	('International Relations', 1);
/*
INSERT INTO [mission_invite] ([mission_id], [from_user_id], [to_user_id], [created_at])
VALUES (1, 3, 2, GETDATE()), (2, 2, 3, GETDATE()), (3, 3, 4, GETDATE()), (4, 4, 5, GETDATE()), (5, 5, 6, GETDATE());

INSERT INTO [mission_media] ("mission_id", "media_name", "media_type", "media_path", "default")
VALUES (1, "Mission1-Photo1", "jpg", "/media/mission1/photo1.jpg", 1),
(1, "Mission1-Photo2", "jpg", "/media/mission1/photo2.jpg", 0),
(2, "Mission2-Video1", "mp4", "/media/mission2/video1.mp4", 1),
(2, "Mission2-Photo1", "jpg", "/media/mission2/photo1.jpg", 0),
(3, "Mission3-Photo1", "jpg", "/media/mission3/photo1.jpg", 1),
(3, "Mission3-Photo2", "jpg", "/media/mission3/photo2.jpg", 0),
(3, "Mission3-Photo3", "jpg", "/media/mission3/photo3.jpg", 0);

*/

INSERT INTO [mission_rating] ([user_id], [mission_id], [rating])
VALUES
(81, 3, 4),
(82, 4, 3),
(83, 5, 5),
(84, 6, 2),
(85, 7, 1);

/*
INSERT INTO mission_skill (skill_id, mission_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1),
(6, 2), (7, 2), (8, 2), (9, 2), (10, 2),
(11, 3), (12, 3), (13, 3), (14, 3), (15, 3),
(16, 4), (17, 4), (18, 4), (19, 4), (20, 4);

*/

INSERT INTO [mission_theme] ("title", "status") 
VALUES 
	('Education', 1),
	('Poverty', 1),
	('Healthcare', 1),
	('Environment', 1),
	('Human Rights', 1),
	('Refugees', 1),
	('Community Development', 1),
	('Disaster Relief', 1),
	('Women Empowerment', 1),
	('Youth Development', 1),
	('Economic Development', 1),
	('Food Security', 1),
	('Clean Water', 1),
	('Orphans Care', 1),
	('Animal Welfare', 1),
	('Arts and Culture', 1),
	('Sports and Recreation', 1),
	('Science and Technology', 1),
	('Faith-based Missions', 1),
	('International Relations', 1);


INSERT INTO Skill (skill_name) VALUES ('Project Management'),('Web Development'),
 ('Graphic Design'), ('Content Writing'),('Data Analysis'),
 ('Digital Marketing'),('Video Editing'), ('Photography'),
 ('Event Planning'), ('Public Speaking');

 /*
INSERT INTO story ("user_id", "mission_id", "title", "Status", "published_at"
VALUES
    (1, 10, 'My journey to volunteering', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sed risus vitae lectus tempor bibendum. Aliquam hendrerit, ante ut viverra auctor, augue eros elementum odio, vitae pharetra risus tellus sit amet velit.', 'PENDING', null),
    (2, 15, 'How I changed a life through volunteering', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sed risus vitae lectus tempor bibendum. Aliquam hendrerit, ante ut viverra auctor, augue eros elementum odio, vitae pharetra risus tellus sit amet velit.', 'DRAFT', null),
    (3, 8, 'My experience working with children in need', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sed risus vitae lectus tempor bibendum. Aliquam hendrerit, ante ut viverra auctor, augue eros elementum odio, vitae pharetra risus tellus sit amet velit.', 'PUBLISHED', '2022-12-15 14:30:00'),
    (4, 12, 'Teaching English in a remote village', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sed risus vitae lectus tempor bibendum. Aliquam hendrerit, ante ut viverra auctor, augue eros elementum odio, vitae pharetra risus tellus sit amet velit.', 'DECLINED', null),
    (5, 18, 'A day in the life of a volunteer', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sed risus vitae lectus tempor bibendum. Aliquam hendrerit, ante ut viverra auctor, augue eros elementum odio, vitae pharetra risus tellus sit amet velit.', 'PUBLISHED', '2023-01-10 10:00:00');
*/

/*
INSERT INTO user_skill ("user_id","skill_id", "created_at") 
VALUES (1, 5, GETDATE()),
 (1, 8, GETDATE()),
 (2, 3, GETDATE()),
 (3, 6, GETDATE()),
 (4, 2, GETDATE());
*/

DELETE FROM [admin];
DBCC CHECKIDENT ('admin', RESEED, 0);
DELETE FROM banner;
DBCC CHECKIDENT ('banner', RESEED, 0);
DELETE FROM city;
DBCC CHECKIDENT ('city', RESEED, 0);
DELETE FROM cms_page;
DBCC CHECKIDENT ('cms_page', RESEED, 0);
DELETE FROM comment;
DBCC CHECKIDENT ('comment', RESEED, 0);
DELETE FROM country;
DBCC CHECKIDENT ('country', RESEED, 0);
DELETE FROM favourite_mission;
DBCC CHECKIDENT ('favourite_mission', RESEED, 0);
DELETE FROM goal_mission;
DBCC CHECKIDENT ('goal_mission', RESEED, 0);
DELETE FROM mission;
DBCC CHECKIDENT ('mission', RESEED, 0);
DELETE FROM mission_application ;
DBCC CHECKIDENT ('mission_application', RESEED, 0);
DELETE FROM mission_document;
DBCC CHECKIDENT ('mission_document', RESEED, 0);
DELETE FROM mission_invite;
DBCC CHECKIDENT ('mission_invite', RESEED, 0);
DELETE FROM mission_media;
DBCC CHECKIDENT ('mission_media', RESEED, 0);
DELETE FROM mission_rating;
DBCC CHECKIDENT ('mission_rating', RESEED, 0);
DELETE FROM mission_skill;
DBCC CHECKIDENT ('mission_skill', RESEED, 0);
DELETE FROM mission_theme;
DBCC CHECKIDENT ('mission_theme', RESEED, 0);
DELETE FROM password_reset;
DBCC CHECKIDENT ('password_reset', RESEED, 0);
DELETE FROM skill;
DBCC CHECKIDENT ('skill', RESEED, 0);
DELETE FROM story;
DBCC CHECKIDENT ('story', RESEED, 0);
DELETE FROM story_invite;
DBCC CHECKIDENT ('story_invite', RESEED, 0);
DELETE FROM story_media;
DBCC CHECKIDENT ('story_media', RESEED, 0);
DELETE FROM timesheet;
DBCC CHECKIDENT ('timesheet', RESEED, 0);
DELETE FROM [user];
DBCC CHECKIDENT ('[user]', RESEED, 0);
DELETE FROM user_skill;
DBCC CHECKIDENT ('user_skill', RESEED, 0);


INSERT INTO [User]
("first_name", "last_name", "email", "password", "phone_number", "avatar", "why_i_volunteer", "employee_id", "department", "city_id", "country_id", "profile_text", "linked_in_url", "title", "status", "created_at")
VALUES
('John', 'Doe', 'johndoe@example.com', 'password123', 567890, 'https://example.com/avatar.jpg', 'I volunteer because...', '1234', 'IT', 1, 1, 'I am a software developer...', 'https://www.linkedin.com/in/johndoe', 'Software Developer', 1, GETDATE()),
('Jane', 'Doe', 'janedoe@example.com', 'password123', 78901, 'https://example.com/avatar.jpg', 'I volunteer because...', '2345', 'Sales', 2, 1, 'I am a sales executive...', 'https://www.linkedin.com/in/janedoe', 'Sales Executive', 0, GETDATE()),
('Bob', 'Smith', 'bobsmith@example.com', 'password123', 89012, 'https://example.com/avatar.jpg', 'I volunteer because...', '3456', 'HR', 3, 1, 'I am an HR manager...', 'https://www.linkedin.com/in/bobsmith', 'HR Manager', 1, GETDATE()),
('Alice', 'Johnson', 'alicejohnson@example.com', 'password123', 90123, 'https://example.com/avatar.jpg', 'I volunteer because...', '4567', 'Marketing', 4, 1, 'I am a marketing specialist...', 'https://www.linkedin.com/in/alicejohnson', 'Marketing Specialist', 0, GETDATE()),
('David', 'Lee', 'davidlee@example.com', 'password123', 01234, 'https://example.com/avatar.jpg', 'I volunteer because...', '5678', 'Finance', 5, 1, 'I am a financial analyst...', 'https://www.linkedin.com/in/davidlee', 'Financial Analyst', 1, GETDATE()),
('Emily', 'Chen', 'emilychen@example.com', 'password123', 12345, 'https://example.com/avatar.jpg', 'I volunteer because...', '6789', 'IT', 1, 1, 'I am a software engineer...', 'https://www.linkedin.com/in/emilychen', 'Software Engineer', 0, GETDATE()),
('Michael', 'Davis', 'michaeldavis@example.com', 'password123', 23456, 'https://example.com/avatar.jpg', 'I volunteer because...', '7890', 'Sales', 2, 1, 'I am a sales representative...', 'https://www.linkedin.com/in/michaeldavis', 'Sales Representative', 1, GETDATE()),
('Sophia', 'Wilson', 'sophiawilson@example.com', 'password123', 34567, 'https://example.com/avatar.jpg', 'I volunteer because...', '8901', 'HR', 3, 1, 'I am an HR coordinator...', 'https://www.linkedin.com/in/sophiawilson', 'HR Coordinator', 0, GETDATE()
);


INSERT INTO [admin]
("first_name", "last_name", "email", "password", "created_at")
VALUES
('John', 'Doe', 'johndoe@admin.com', 'password123', GETDATE()),
('Jane', 'Doe', 'janedoe@admin.com', 'password123', GETDATE()),
('Bob', 'Smith', 'bobsmith@admin.com', 'password123', GETDATE());


INSERT INTO [banner]
("Image", "Text", "sort_order", "created_at")
VALUES
('banner1.jpg', 'Banner 1 Text', 1, GETDATE()),
('banner2.jpg', 'Banner 2 Text', 2, GETDATE()),
('banner3.jpg', 'Banner 3 Text', 3, GETDATE()),
('banner4.jpg', 'Banner 4 Text', 4, GETDATE()),
('banner5.jpg', 'Banner 5 Text', 5, GETDATE()),
('banner6.jpg', 'Banner 6 Text', 6, GETDATE()),
('banner7.jpg', 'Banner 7 Text', 7, GETDATE()),
('banner8.jpg', 'Banner 8 Text', 8, GETDATE()),
('banner9.jpg', 'Banner 9 Text', 9, GETDATE()),
('banner10.jpg', 'Banner 10 Text', 10, GETDATE());


INSERT INTO [city]
("country_id", "name", "created_at")
VALUES
(1, 'New York City', GETDATE()),
(1, 'Los Angeles', GETDATE()),
(1, 'Chicago', GETDATE()),
(1, 'Houston', GETDATE()),
(1, 'Phoenix', GETDATE()),
(2, 'Toronto', GETDATE()),
(2, 'Montreal', GETDATE()),
(2, 'Vancouver', GETDATE()),
(3, 'London', GETDATE()),
(3, 'Manchester', GETDATE()),
(3, 'Liverpool', GETDATE()),
(4, 'Paris', GETDATE()),
(4, 'Marseille', GETDATE()),
(4, 'Lyon', GETDATE()),
(5, 'Tokyo', GETDATE()),
(5, 'Osaka', GETDATE()),
(5, 'Yokohama', GETDATE()),
(6, 'Sydney', GETDATE()),
(6, 'Melbourne', GETDATE()),
(6, 'Brisbane', GETDATE());


INSERT INTO [country]
("Name", "ISO", "created_at")
VALUES
('United States', 'US', GETDATE()),
( 'Canada', 'CA', GETDATE()),
( 'United Kingdom', 'UK', GETDATE()),
( 'France', 'FR', GETDATE()),
( 'Japan', 'JP', GETDATE()),
( 'Australia', 'AU', GETDATE()),
( 'Germany', 'DE', GETDATE()),
( 'Spain', 'ES', GETDATE()),
( 'Italy', 'IT', GETDATE()),
( 'China', 'CN', GETDATE()),
( 'Brazil', 'BR', GETDATE()),
( 'India', 'IN', GETDATE()),
( 'Mexico', 'MX', GETDATE()),
( 'South Korea', 'KR', GETDATE()),
( 'Netherlands', 'NL', GETDATE()),
( 'Switzerland', 'CH', GETDATE()),
( 'Sweden', 'SE', GETDATE()),
( 'Norway', 'NO', GETDATE()),
( 'Denmark', 'DK', GETDATE()),
( 'Finland', 'FI', GETDATE());

INSERT INTO [cms_page] ("Title", "Description", "slug", "status")
VALUES
('About Us', 'Learn more about our company and our mission.', 'about-us', '1'),
('Contact Us', 'Get in touch with our team and let us know how we can help.', 'contact-us', '1'),
('Terms and Conditions', 'Read our terms and conditions before using our services.', 'terms-and-conditions', '1'),
('Privacy Policy', 'Learn how we collect, use, and protect your personal information.', 'privacy-policy', '1'),
('FAQs', 'Frequently asked questions about our products and services.', 'faqs', '1'),
('Services', 'Explore the services we offer and how they can benefit you.', 'services', '1'),
('Blog', 'Read our latest blog posts for tips, advice, and insights.', 'blog', '1'),
('Career Opportunities', 'Join our team and help us make a difference.', 'careers', '1'),
('Events', 'Stay up-to-date on our upcoming events and how to participate.', 'events', '1'),
('Testimonials', 'See what our customers are saying about us.', 'testimonials', '1');


INSERT INTO mission(theme_id, city_id, country_id, Title, short_description, [description], [start_date], end_date, mission_type, [status], organization_name, organization_detail, [availability])
VALUES
(1, 2, 3, 'Teaching English in Rural Schools', 'Volunteers will teach English to children in rural schools', 'We are looking for volunteers to teach English to underprivileged children in rural schools. Volunteers should have experience in teaching English as a second language and be passionate about making a difference in the lives of these children.', '2023-03-01', '2023-05-30', 'Time', 1, 'Teach for Change', 'Teach for Change is a non-profit organization that aims to provide quality education to underprivileged children.', 'WEEKLY'),
(2, 3, 4, 'Building Homes for the Homeless', 'Volunteers will build homes for the homeless', 'We are looking for volunteers to help us build homes for the homeless. Volunteers will be responsible for tasks such as laying bricks, mixing cement, and painting walls. No prior experience is required, but volunteers should be physically fit.', '2023-04-01', '2023-06-30', 'Goal', 1, 'Habitat for Humanity', 'Habitat for Humanity is a non-profit organization that aims to provide affordable housing to low-income families.', 'DAILY'),
(3, 4, 5, 'Animal Welfare and Rescue', 'Volunteers will work with animals in a shelter', 'We are looking for volunteers to help us take care of animals in our shelter. Volunteers will be responsible for tasks such as feeding the animals, cleaning their cages, and taking them for walks. No prior experience is required, but volunteers should be comfortable working with animals.', '2023-05-01', '2023-08-30', 'Time', 1, 'Animal Welfare Society', 'Animal Welfare Society is a non-profit organization that works towards the welfare and protection of animals.', 'WEEK-END'),
(4, 5, 6, 'Teaching Computer Skills to Senior Citizens', 'Volunteers will teach computer skills to senior citizens', 'We are looking for volunteers to teach computer skills to senior citizens. Volunteers should have experience in teaching basic computer skills such as browsing the internet, sending emails, and using social media.', '2023-06-01', '2023-08-31', 'Time', 1, 'SeniorNet', 'SeniorNet is a non-profit organization that aims to help senior citizens learn computer skills and stay connected with their loved ones.', 'WEEKLY'),
(5, 6, 7, 'Environmental Cleanup Drive', 'Volunteers will participate in an environmental cleanup drive', 'We are looking for volunteers to participate in an environmental cleanup drive. Volunteers will be responsible for tasks such as picking up litter, planting trees, and creating awareness about environmental conservation.', '2023-07-01', '2023-07-31', 'Goal', 1, 'Greenpeace', 'Greenpeace is a non-profit organization that works towards environmental conservation and protection.', 'DAILY');


INSERT INTO [mission] ("theme_id", "city_id", "country_id", "title", "short_description", "description", "start_date", "end_date", "mission_type", "status", "organization_name", "organization_detail", "availability")
VALUES (1, 2, 3, 'Community Clean-Up Day', 'Join us in cleaning up the local park', 'We will provide gloves, trash bags, and other necessary equipment. Just bring yourself and your enthusiasm!', '2023-03-25 09:00:00', '2023-03-25 12:00:00', 'Time', 1, 'Green Earth Organization', 'We are a non-profit dedicated to preserving the environment', 'daily');

INSERT INTO [mission] ("theme_id", "city_id", "country_id", "title", "short_description", "description", "start_date", "end_date", "mission_type", "status", "organization_name", "organization_detail", "availability")
VALUES (2, 1, 4, 'Feed the Homeless', 'Help us provide meals to those in need', 'We will be serving hot meals to the homeless population in the city. Volunteers are needed to help prepare and distribute the meals.', '2023-04-02 10:00:00', '2023-04-02 14:00:00', 'Time', 1, 'Hope for the Homeless', 'We are a charity organization working to end homelessness', 'weekly');

INSERT INTO [mission] ("theme_id", "city_id", "country_id", "title", "short_description", "description", "start_date", "end_date", "mission_type", "status", "organization_name", "organization_detail", "availability")
VALUES (3, 5, 1, 'Plant Trees for the Future', 'Help us create a greener world', 'We will be planting trees in the city park to help combat climate change and provide a healthier environment for future generations.', '2023-04-22 09:00:00', '2023-04-22 12:00:00', 'Time', 1, 'Green World Initiative', 'We are a global organization dedicated to environmental conservation', 'week-end');

INSERT INTO [mission] ("theme_id", "city_id", "country_id", "title", "short_description", "description", "start_date", "end_date", "mission_type", "status", "organization_name", "organization_detail", "availability")
VALUES (1, 2, 3, 'Volunteer at a Local Animal Shelter', 'Help care for furry friends in need', 'We need volunteers to help us care for animals at the local shelter. Duties include walking dogs, cleaning cages, and providing love and attention to our furry residents.', '2023-04-15 13:00:00', '2023-04-15 16:00:00', 'Time', 1, 'Paws for a Cause', 'We are a non-profit organization working to find loving homes for abandoned animals', 'monthly');

INSERT INTO [mission] ("theme_id", "city_id", "country_id", "title", "short_description", "description", "start_date", "end_date", "mission_type", "status", "organization_name", "organization_detail", "availability")
VALUES (4, 6, 2, 'Assist with Disaster Relief Efforts', 'Help communities in need during natural disasters', 'We are currently responding to a natural disaster in the region and need volunteers to assist with relief efforts. Duties may include distributing supplies, providing.','2023-04-15 13:00:00', '2023-04-15 16:00:00', 'Time', 1, 'Paws for a Cause', 'We are a non-profit organization working to find loving homes for abandoned animals', 'monthly'); 


(1, 10, '2022-01-01', 'PENDING'),
(2, 20, '2022-02-01', 'APPROVE'),
(3, 30, '2022-03-01', 'DECLINE'),
(4, 40, '2022-04-01', 'PENDING'),
(5, 50, '2022-05-01', 'PENDING');


(1, 'Document 1', 'PDF', '/mission/documents/doc1.pdf', GETDATE()),
(1, 'Document 2', 'PDF', '/mission/documents/doc2.pdf', GETDATE()),
(2, 'Document 3', 'Image', '/mission/documents/image1.jpg', GETDATE()),
(2, 'Document 4', 'Image', '/mission/documents/image2.jpg', GETDATE()),
(3, 'Document 5', 'PDF', '/mission/documents/doc3.pdf', GETDATE());


INSERT INTO [mission_invite] ([mission_id], [from_user_id], [to_user_id], [created_at])
VALUES (1, 1, 2, GETDATE()), (2, 2, 3, GETDATE()), (3, 3, 4, GETDATE()), (4, 4, 5, GETDATE()), (5, 5, 6, GETDATE())


INSERT INTO [mission_media] ("mission_id", "media_name", "media_type", "media_path", "default")
VALUES (1, 'Mission1-Photo1', 'jpg', '/media/mission1/photo1.jpg', 1),
(1, 'Mission1-Photo2', 'jpg', '/media/mission1/photo2.jpg', 0),
(2, 'Mission2-Video1', 'mp4', '/media/mission2/video1.mp4', 1),
(2, 'Mission2-Photo1', 'jpg', '/media/mission2/photo1.jpg', 0),
(3, 'Mission3-Photo1', 'jpg', '/media/mission3/photo1.jpg', 1),
(3, 'Mission3-Photo2', 'jpg', '/media/mission3/photo2.jpg', 0),
(3, 'Mission3-Photo3', 'jpg', '/media/mission3/photo3.jpg', 0);
					 

INSERT INTO [mission_rating] ([user_id], [mission_id], [rating])
VALUES
(1, 1, 4),
(2, 1, 3),
(3, 2, 5),
(4, 3, 2),
(5, 4, 1);


INSERT INTO mission_skill (skill_id, mission_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1),
(6, 2), (7, 2), (8, 2), (9, 2), (10, 2),
(1, 3), (2, 3), (3, 3), (4, 3), (5, 3),
(6, 4), (7, 4), (8, 4), (9, 4), (10, 4);

INSERT INTO [mission_theme] ("Title", "status")
VALUES
('Education', 1),
('Poverty', 1),
('Healthcare', 1),
('Environment', 1),
('Human Rights', 1),
('Refugees', 1),
('Community Development', 1),
('Disaster Relief', 1),
('Women Empowerment', 1),
('Youth Development', 1),
('Economic Development', 1),
('Food Security', 1),
('Clean Water', 1),
('Orphans Care', 1),
('Animal Welfare', 1),
('Arts and Culture', 1),
('Sports and Recreation', 1),
('Science and Technology', 1),
('Faith-based Missions', 1),
('International Relations', 1);

INSERT INTO Skill (skill_name) VALUES ('Project Management');
INSERT INTO Skill (skill_name) VALUES ('Web Development');
INSERT INTO Skill (skill_name) VALUES ('Graphic Design');
INSERT INTO Skill (skill_name) VALUES ('Content Writing');
INSERT INTO Skill (skill_name) VALUES ('Data Analysis');
INSERT INTO Skill (skill_name) VALUES ('Digital Marketing');
INSERT INTO Skill (skill_name) VALUES ('Video Editing');
INSERT INTO Skill (skill_name) VALUES ('Photography');
INSERT INTO Skill (skill_name) VALUES ('Event Planning');
INSERT INTO Skill (skill_name) VALUES ('Public Speaking');




INSERT INTO story ([user_id], mission_id, title, [status], published_at,created_at)
VALUES
(1, 10, 'My journey to volunteering' , 'PENDING', null, GETDATE()),
(2, 5, 'How I changed a life through volunteering', 'DRAFT', null, GETDATE()),
(3, 8, 'My experience working with children in need', 'PUBLISHED', '2022-12-15 14:30:00', GETDATE()),
(4, 2, 'Teaching English in a remote village ', 'DECLINED', null, GETDATE()),
(5, 8, 'A day in the life of a volunteer', 'PUBLISHED', '2023-01-10 10:00:00', GETDATE());


INSERT INTO user_skill ([user_id], skill_id, created_at) VALUES (1, 5, GETDATE());
INSERT INTO user_skill ([user_id], skill_id, created_at) VALUES (1, 8, GETDATE());
INSERT INTO user_skill ([user_id], skill_id, created_at) VALUES (2, 3, GETDATE());
INSERT INTO user_skill ([user_id], skill_id, created_at) VALUES (3, 6, GETDATE());
INSERT INTO user_skill ([user_id], skill_id, created_at) VALUES (4, 2, GETDATE());

SELECT *
FROM mission
 JOIN mission_media ON mission.mission_id = mission_media.mission_id;

 Update mission
 Set seat_left = 10
 where mission_id = 1;

delete from mission where mission_id = 10;
delete from mission_media where mission_id = 10;


create or alter proc userdata
as
begin
select * from [user] 
end;

create or alter proc userdata
as
begin
select * from mission
end; 

exec userdata;

--DECLARE @PageNumber AS INT
--DECLARE @RowsOfPage AS INT
--SET @PageNumber=2
--SET @RowsOfPage=3
--SELECT * FROM mission
--ORDER BY mission_id 
--OFFSET (@PageNumber-1)*@RowsOfPage ROWS
--FETCH NEXT @RowsOfPage ROWS ONLY


create or alter proc sorting 
@orderBy varchar(300) = ''
as
begin
declare  @orderby_query varchar(1500) = ' order by m.MissionId '
select * from mission
		order by 
		CASE WHEN @SortingCol = 'seat_left' AND @SortType ='DESC' THEN seat_left END
end;

exec sorting 'Lowest available seats'

select * from mission
--DECLARE @PageNumber AS INT
--DECLARE @RowsOfPage AS INT
--DECLARE @SortingCol AS VARCHAR(100) ='seat_left'
--DECLARE @SortType AS VARCHAR(100) = 'DESC'
--SET @PageNumber=1
--SET @RowsOfPage=3
--SELECT * FROM mission
--ORDER BY 
--CASE WHEN @SortingCol = 'seat_left' AND @SortType ='DESC' THEN seat_left END
--OFFSET (@PageNumber-1)*@RowsOfPage ROWS
--FETCH NEXT @RowsOfPage ROWS ONLY


--ALTER TABLE [CIPlatform].[dbo].[user] 
--DROP CONSTRAINT [DF_user_flag]


---- SP Searching ----------------------

ALTER PROCEDURE SearchMissions
    @searchText VARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @matchCount INT;

    SELECT @matchCount = COUNT(*)
    FROM mission
    WHERE title LIKE '%' + @searchText + '%'
        OR short_description LIKE '%' + @searchText + '%'
        OR [description] LIKE '%' + @searchText + '%';

    IF @matchCount > 0
    BEGIN
        SELECT *
        FROM mission
        WHERE title LIKE '%' + @searchText + '%'
            OR short_description LIKE '%' + @searchText + '%'
            OR [description] LIKE '%' + @searchText + '%';
    END
    ELSE
    BEGIN
        PRINT 'Mission not found.';
    END
END

EXEC SearchMissions 'teaching computer';

------ start <= actual and end >= actual ----------------------

ALTER PROCEDURE SearchMissions
    @startDate DATETIME = NULL,
    @endDate DATETIME = NULL
AS
BEGIN
    DECLARE @matchCount INT;

    SELECT @matchCount = COUNT(*)
    FROM mission
    WHERE (@startDate IS NULL OR [start_date] >= @startDate)
        AND (@endDate IS NULL OR [end_date] <= @endDate);

    IF @matchCount > 0
    BEGIN
        SELECT *
        FROM mission
        WHERE (@startDate IS NULL OR [start_date] >= @startDate)
            AND (@endDate IS NULL OR [end_date] <= @endDate);
    END
    ELSE
    BEGIN
        PRINT 'Mission not found.';
    END
END


EXEC SearchMissions '2023-02-10', '2023-08-10';

select * from mission;

---- SP Pagination ----------------------

ALTER PROCEDURE SearchMissions
    @searchText VARCHAR(128),
    @startDate DATETIME = NULL,
    @endDate DATETIME = NULL,
    @pageNumber INT = 1,
    @pageSize INT = 10
AS
BEGIN
    DECLARE @matchCount INT;

    SELECT @matchCount = COUNT(*)
    FROM mission
    WHERE (title LIKE '%' + @searchText + '%'
        OR short_description LIKE '%' + @searchText + '%'
        OR [description] LIKE '%' + @searchText + '%')
        AND (@startDate IS NULL OR [start_date] >= @startDate)
        AND (@endDate IS NULL OR [end_date] <= @endDate);

    IF @matchCount > 0
    BEGIN
        SELECT *
        FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY mission_id) AS RowNum,
                mission_id, theme_id, city_id, country_id, title, short_description, [description],
                [start_date], end_date, mission_type, [status], organization_name,
                organization_detail, [availability], created_at, updated_at, deleted_at
            FROM mission
            WHERE (title LIKE '%' + @searchText + '%'
                OR short_description LIKE '%' + @searchText + '%'
                OR [description] LIKE '%' + @searchText + '%')
                AND (@startDate IS NULL OR [start_date] >= @startDate)
                AND (@endDate IS NULL OR [end_date] <= @endDate)
        ) AS Results
        WHERE RowNum >= ((@pageNumber - 1) * @pageSize) + 1
            AND RowNum <= @pageNumber * @pageSize;
    END
    ELSE
    BEGIN
        PRINT 'Mission not found.';
    END
END


EXEC SearchMissions 'we', '2023-02-10', '2023-08-10', 2, 4;


-- SP Practice

SELECT COUNT(mission_id) OVER (PARTITION BY [Total Mission]), city_id FROM mission

------- SP Sorting-----------------
ALTER PROCEDURE SearchMissions
    @searchText VARCHAR(128),
    @startDate DATETIME = NULL,
    @endDate DATETIME = NULL,
    @pageNumber INT = 1,
    @pageSize INT = 2,
    @sortColumn VARCHAR(50),
    @sortOrder VARCHAR(4)
AS
BEGIN
    DECLARE @missionCount INT;

    SELECT @missionCount = COUNT(*)
    FROM mission
    WHERE ((title LIKE '%' + @searchText + '%'
        OR short_description LIKE '%' + @searchText + '%'
        OR [description] LIKE '%' + @searchText + '%')
        OR @searchText = '')
        AND (@startDate IS NULL OR [start_date] >= @startDate)
        AND (@endDate IS NULL OR [end_date] <= @endDate);

    IF @missionCount > 0
    BEGIN
        DECLARE @sortDirection VARCHAR(4);
        SET @sortDirection = CASE WHEN @sortOrder = '0' THEN 'DESC' ELSE 'ASC' END;

        DECLARE @query NVARCHAR(MAX);
        SET @query = '
            SELECT *
            FROM (
                SELECT ROW_NUMBER() OVER (ORDER BY ' + @sortColumn + ' ' + @sortDirection + ') AS RowNo, mission.*
                FROM mission
                WHERE ((title LIKE ''%'' + @searchText + ''%''
                    OR short_description LIKE ''%'' + @searchText + ''%''
                    OR [description] LIKE ''%'' + @searchText + ''%'' )
                    OR @searchText = '''')
                    AND (@startDate IS NULL OR [start_date] >= @startDate)
                    AND (@endDate IS NULL OR [end_date] <= @endDate)
            ) AS GetAllMission
            WHERE RowNo BETWEEN ((@pageNumber - 1) * @pageSize) + 1 AND @pageNumber * @pageSize;
        ';

        EXEC sp_executesql @query, N'@searchText VARCHAR(128), @startDate DATETIME, @endDate DATETIME, @pageNumber INT, @pageSize INT', @searchText, @startDate, @endDate, @pageNumber, @pageSize;
    END
    ELSE
    BEGIN
        PRINT 'Mission not found.';
    END
END

EXEC SearchMissions 'we', '2023-02-10', '2023-08-10', 1, 5, 'title', '0';

-- Create View
CREATE VIEW missionData AS
SELECT * FROM 
mission WHERE mission_id BETWEEN 4 AND 6;

SELECT * FROM missionData;

DROP VIEW missionData;

-- backup and restore demo example 
CREATE DATABASE back2;

use back2;

CREATE TABLE demo
(
	[name] VARCHAR(20),
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
	[address] VARCHAR(122)
	);
		
	INSERT INTO demo
	VALUES ('soham', 'mansa'),
			('deep', 'gandhinagar');

select * from demo;
SELECT * FROM temp;
EXEC sp_databases;

create table temp(
	friend VARCHAR(40) NOT NULL,
	no BIGINT NOT NULL
);

INSERT INTO temp
VALUES ('KENVI', 34),
		('nitya', 44);
drop DATABASE back2;