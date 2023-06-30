 -- Search Mission with Date validate and Pagination

ALTER PROCEDURE SearchMissions
    @searchText VARCHAR(128),
    @startDate DATETIME = NULL,
    @endDate DATETIME = NULL,
    @pageNumber INT = 1,
    @pageSize INT = 2,
	@sortColName VARCHAR(128)
	--@colOrder INT = 0
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
        SELECT *
        FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY title ASC) AS RowNo,mission.*
            FROM mission
            WHERE ((title LIKE '%' + @searchText + '%'
                OR short_description LIKE '%' + @searchText + '%'
                OR [description] LIKE '%' + @searchText + '%')
				OR @searchText = '')
                AND (@startDate IS NULL OR [start_date] >= @startDate)
                AND (@endDate IS NULL OR [end_date] <= @endDate)
        ) AS GetAllMission
        WHERE RowNo BETWEEN ((@pageNumber - 1) * @pageSize) + 1 AND @pageNumber * @pageSize;
    END
    ELSE
    BEGIN
        PRINT 'Mission not found.';
    END
END

EXEC SearchMissions 'we', '2023-02-10', '2023-08-10', 1, 5, 'title' ;

select * from mission;


-------------------Use by When ----------------------------------
ALTER PROCEDURE SearchMissions
    @searchText VARCHAR(128),
    @startDate DATETIME = NULL,
    @endDate DATETIME = NULL,
    @pageNumber INT = 1,
    @pageSize INT = 2,
    @sortColumn VARCHAR(50) = 'mission_id',
    @sortOrder INT = 0
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
        SELECT *
        FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY 
				CASE WHEN @sortColumn = 'title' AND @sortOrder = 1 THEN title END ASC,
				CASE WHEN @sortColumn = 'title' AND @sortOrder = 0 THEN title END DESC,
				CASE WHEN @sortColumn = 'start_date' AND @sortOrder = 1 THEN start_date END ASC,
				CASE WHEN @sortColumn = 'start_date' AND @sortOrder = 0 THEN start_date END DESC,
				mission_id) AS RowNo, mission.*
            FROM mission
            WHERE ((title LIKE '%' + @searchText + '%'
                OR short_description LIKE '%' + @searchText + '%'
                OR [description] LIKE '%' + @searchText + '%')
				OR @searchText = '')
                AND (@startDate IS NULL OR [start_date] >= @startDate)
                AND (@endDate IS NULL OR [end_date] <= @endDate)
        ) AS GetAllMission
 WHERE RowNo BETWEEN ((@pageNumber - 1) * @pageSize) + 1 AND @pageNumber * @pageSize;
    END
    ELSE
    BEGIN
        PRINT 'Mission not found.';
    END
END

EXEC SearchMissions 'we', '2023-02-10', '2023-08-10', 1, 5, 'title', 1;
       
 -- Searching , Sorting and Pagination 
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
		-- 2 argument declare variable which you have used 
        EXEC sp_executesql @query, N'@searchText VARCHAR(128), @startDate DATETIME, @endDate DATETIME, @pageNumber INT, @pageSize INT', @searchText, @startDate, @endDate, @pageNumber, @pageSize;
    END
    ELSE
    BEGIN
        PRINT 'Mission not found.';
    END
END

EXEC SearchMissions 'we', '2023-02-10', '2023-08-10', 1,5, 'title', '1';

SELECT * FROM mission;


