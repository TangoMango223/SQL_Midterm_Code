-- MIDTERM CODE REVIEW PREPARATION --
-- Written by Christine Tang


--- LECTURE #5 NOTES ---

-- Coding Practices:
-- Always end your comments with a semi-colon ;
-- Space out accordingly
-- Make sure the SQL keywords are all CAPITALIZED

-- Structure is...
-- Database > Schema > Tables
-- When dropping, make sure to drop all tables before you can drop a schema
-- We are under the tango97_db

-- Use your own database
USE tango97_db;

-- Let's create a SCHEMA for family guy
CREATE SCHEMA family_guy;

-- Create a Table
-- We need to specify PRIMARY KEY as member_id
CREATE TABLE family_guy.family_members(
    member_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    first_name NVARCHAR(30) NOT NULL,
    last_name NVARCHAR(30) NOT NULL,
    age INT
);

-- Add rows to the table. Values is single quotation marks, single brackets()
INSERT INTO family_guy.family_members (first_name, last_name, age)
VALUES
    ('Peter', 'Griffin', 35);

-- Do another insert, but don't put the age.
-- Death is a character in Family Guy, he has no age
-- Notice how "NULL" is listed for age
INSERT INTO family_guy.family_members(first_name, last_name)
VALUES('Death', 'Death');

-- Let's remove "Death" since he's not a real member
DELETE FROM family_guy.family_members
WHERE first_name = 'Death';

-- Let's modify the table
-- use the keyword ALTER. Three Alters - ALTER (existing col), DROP, ADD

-- Alter #1 - change existing column
ALTER TABLE family_guy.family_members
ALTER COLUMN first_name VARCHAR(100);

-- Alter #2 - Add NEW column. Notice how COLUMN is missing here.
ALTER TABLE family_guy.family_members
ADD gender VARCHAR(2);

-- Let's add Peter's Gender. Use "UPDATE"
UPDATE family_guy.family_members
SET gender = 'M'
WHERE first_name = 'Peter';

-- Alter #3 - Remove this new column
ALTER TABLE family_guy.family_members
DROP COLUMN gender;

-- Let's say we hate this table and this schema and we need to remove both.
-- Remember, you must remove the tables first, and then the schema
DROP TABLE family_guy.family_members;
DROP SCHEMA family_guy;

-- Let's add the rest of the family members
INSERT INTO family_guy.family_members(first_name, last_name,age)
VALUES('Lois', 'Griffin', '41'),
      ('Meg', 'Griffin', '17'),
      ('Chris', 'Griffin', 13),
      ('Stewie', 'Griffin', 1),
      ('Brian', 'Griffin', 6);

-- Suppose we accidentally added Stewie Griffin twice
INSERT INTO family_guy.family_members(first_name, last_name, age)
VALUES('Stewie', 'Griffin', 1);


-- We can remove by using either his member_id (check table), or first_name
DELETE FROM family_guy.family_members
WHERE first_name = 'Stewie';

-- This is a BAD idea, since all entries of Stewie Griffin were added.

-- What you should do is always use Member_ID for uniqueness.
-- Let's add back Stewie and delete via Member_ID (never repeats)
INSERT INTO family_guy.family_members(first_name, last_name, age)
VALUES ('Stewie', 'Griffin', 1);

-- Let's add Stewie again twice...
INSERT INTO family_guy.family_members(first_name, last_name, age)
VALUES ('Stewie', 'Griffin', 1);

-- Let's delete the 2nd Stewie, which is Member_ID = 9
DELETE FROM family_guy.family_members
WHERE member_id = 9;

-- Check table now - it's only one 1 Stewie, which is Member ID 8.
-- note - in Microsoft SQL, you cannot modify primary keys

-- Delete multiple people from the family_guy table.
-- Let's say Brian and Stewie went on a time-travelling adventure again.
-- Option #1 - use first names, Option #2 - use member ID

-- Option #1 - use first names
DELETE FROM family_guy.family_members
WHERE first_name = 'Stewie' OR first_name = 'Brian';

-- Option #2 - member ID
DELETE FROM family_guy.family_members
WHERE member_id = 6 OR member_id = 8;

-- Option #3 - use a mix of both
DELETE FROM family_guy.family_members
WHERE member_id = 6 OR first_name = 'Stewie';

-- Re-add Stewie and Brian Griffin
INSERT INTO family_guy.family_members(first_name, last_name, age)
VALUES ('Stewie', 'Griffin', 1),
       ('Brian', 'Griffin', 6);

-- Option #4 - use IN keyword
-- After adding them back, they are now ID 10 and 11
DELETE FROM family_guy.family_members
WHERE member_id IN (10,11);

-- Alternatively, you can use the BETWEEN keyword for deletion
-- They are now ID 12 and 13.
-- Be careful, BETWEEN is inclusive of both numbers
DELETE FROM family_guy.family_members
WHERE member_id BETWEEN 12 AND 13;

-- Another way of doing exclusive/inclusive ranges
-- Stewie and Brian are now ID 14 and 15.
-- Let's just select for now.
SELECT first_name,
       last_name,
       age
FROM family_guy.family_members
WHERE member_id = 14 OR
      member_id = 15;

-- Another way of doing this, use equality signs.
-- In this case, you should be using AND since we are restricting in truth table.
-- Only outcomes that are TRUE and TRUE (Stewie, Brian) will show up.
SELECT first_name,
       last_name,
       age
FROM family_guy.family_members
WHERE member_id >= 14 AND member_id <= 15;

-- If we use OR, everyone in the entire table will result. BAD!!
SELECT first_name,
       last_name,
       age
FROM family_guy.family_members
WHERE member_id >= 14 OR member_id <= 15;

-- Do not confuse OR and AND
-- AND is filtering on multiple conditions that must happen as well.
-- OR is putting a broad net to look for everything

-- Regex Patterns
-- Use % as a wildcard, to search for everything after Pet
UPDATE family_guy.family_members
SET age = 90
WHERE first_name LIKE 'Pet%'; -- We are updating Peter Griffin to 90 years ago

-- Importance of brackets and BEDMAS
-- We are using brackets to tell SQL to apply the age update on two conditions
-- Because we used OR, both conditions will be evaluated, and if either happens, it will execute
-- Remember Truth Table

-- In the code below, both Lois and Meg will have their ages updated
UPDATE family_guy.family_members
SET age = 100
WHERE member_id = 2 OR (first_name = 'Meg' AND last_name = 'Griffin');


-- Let's try updating Chris Griffin and Herbert's age (Herbert is not here)
UPDATE family_guy.family_members
SET age = 13
WHERE first_name = 'Chris' OR (first_name = 'Herbert'); -- Herbert is not in the table
-- Since Herbert is not here, it was never updated
-- This is using Truth Table logic, since first_name "Chris" is TRUE OR FALSE (no Herbert)

-- Let's look at an example of a failure statement TRUE and FALSE
-- This will fail, since TRUE (Meg) AND FALSE (no Quagmire)
SELECT *
FROM family_guy.family_members
WHERE (first_name = 'Meg') AND (last_name = 'Quagmire');

-- But if we used OR, it will show up, and show Meg
SELECT *
FROM family_guy.family_members
WHERE (first_name = 'Meg') OR (last_name = 'Quagmire');

-- How to do SELECTIONS
-- Remember the Mnemonic
SELECT *
FROM family_guy.family_members
WHERE last_name = 'Griffin';

-- Alias
-- You have to set the Alias
SELECT fam.first_name,
       fam.last_name,
       fam.age
FROM family_guy.family_members as fam;

-- Sorting as ASC
SELECT *
FROM family_guy.family_members
ORDER BY age ASC;

-- Sort using multiple
-- Notice this sort will prioritize first_name, and then age is not really sorted
SELECT *
FROM family_guy.family_members
ORDER BY first_name ASC, age DESC;

SElECT first_name AS griffin_first_name,
       last_name AS griffin_last_name
FROM family_guy.family_members;

-- You can also put singular entries
-- This adds a random column of 100
SELECT *,
       100 AS new_age
FROM family_guy.family_members;

-- Min, Max, Count
SELECT
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    AVG(age) AS avg_age,
    COUNT(age) AS count_age
FROM family_guy.family_members;

-- Note when putting aggregation facts, you'll need to groupby to include other variables.
SELECT first_name,
       last_name,
       AVG(age) AS person_age
FROM family_guy.family_members
GROUP BY first_name, last_name -- You need to put all the x-variables here
ORDER BY person_age ASC;

-- Last comment - setting up Schema
-- Use logic "IF" conditions to check if a schema already exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'carters')
    BEGIN
        EXEC('CREATE SCHEMA carters');
    END

-- Also drop if it already exists
DROP SCHEMA IF EXISTS carters;

SELECT *
FROM sys.schemas;

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'family_guy';


--- LECTURE #5.5 - Extra NOTES ---

-- Counting. There are only 6 family members
SELECT COUNT(*) AS N_Records
FROM family_guy.family_members;

-- Get Distinct values
SELECT DISTINCT(first_name) AS distinct_first_names
FROM family_guy.family_members;

-- Combine DISTINCT and COUNT
SELECT DISTINCT COUNT(first_name)
FROM family_guy.family_members;

-- Create a Matrix
SELECT DISTINCT c.first_name, c.last_name
FROM family_guy.family_members AS c;

-- Counting
-- This returns 6
SELECT DISTINCT COUNT(first_name) AS N_Records
FROM family_guy.family_members;

--This also returns 6
SELECT COUNT (DISTINCT first_name) AS N_Records
FROM family_guy.family_members;

-- Be careful of DISTINCT and COUNT order
-- Generally you want to put COUNT before DISTINCT

-- Create a new table from an existing table
-- use the INTO keyword
-- Remember to use OR keyword
SELECT *
INTO family_guy.time_travellers -- name of the table
FROM family_guy.family_members
WHERE first_name = 'Stewie' OR first_name = 'Brian'; -- We are only moving these people

-- Delete table
DROP TABLE family_guy.time_travellers;

-- Another way is using the IN keyword
SELECT *
INTO family_guy.time_travellers -- name of the table
FROM family_guy.family_members
WHERE first_name IN ('Stewie', 'Brian');


-- When would you check the min, max, average at the same time?
-- Quality control
SELECT MIN(age) as min_age,
       MAX(age) as max_age,
       AVG(age) as avg_age
FROM family_guy.family_members;

-- Let's add the Swansons briefly
INSERT INTO family_guy.family_members(first_name, last_name, age)
VALUES('Joe', 'Swanson', 56),
      ('Bonnie', 'Swanson', 52),
      ('Kevin', 'Swanson', 23);

-- Let's analyze each family uniquely
-- CASTING. In this example, we don't need to cast.
-- Let's assume age was not an integer to begin with, we need to force it to be a float
SELECT last_name, ROUND(AVG(CAST(age AS FLOAT)),1) AS avg_age
FROM family_guy.family_members
GROUP BY last_name;

-- This converts all to float
SELECT CAST(age AS FLOAT) as n_age
FROM family_guy.family_members;

-- Get minimum age by family
SELECT last_name,
       MIN(c.age)
FROM family_guy.family_members AS c
GROUP BY last_name;

-- Let's fix the Griffin Family's ages from the modifications earlier
UPDATE family_guy.family_members
SET age = 43
WHERE first_name LIKE 'Pet%'; -- Regex

-- Fix Lois and Meg's age
UPDATE family_guy.family_members
SET age = 42
WHERE first_name = 'Lois';

UPDATE family_guy.family_members
SET age = 16
WHERE first_name = 'Meg';

-- More Casting
-- Let's pretend we need to convert "age" via casting
SELECT c.first_name,
       c.last_name,
       c.age AS int_age, -- default INT
       (CAST(c.age AS FLOAT)) AS float_age
FROM family_guy.family_members AS c;

-- The order of casting and average matters
-- Let's Cast, then take the average. You will get a decimal number

-- This will give you a decimal number.
-- The last step is averaging, but cast will force float.
SELECT AVG(CAST(age AS FLOAT))
FROM family_guy.family_members;

-- This will return a whole number or integer, since we're casting.
-- Since the original data is an integer, even if you cast as FLOAT...
-- It look like an integer, with decimals hidden.
SELECT CAST(AVG(age) AS FLOAT)
FROM family_guy.family_members;

-- Tip: the last step matters. If the last step is CASTING, the result is integer
-- If the last step is averaging, then it will get a decimal number (Float)

-- Get oldest person in each family guy family.
-- We will learn how to output first_name later.
SELECT last_name,
       MAX(age) AS oldest_age
FROM family_guy.family_members
GROUP BY last_name;

-- Some casting types will not work.
-- ERROR AND FAILURE - Example: Cast VARCHAR (text) to Float

--- LECTURE #6 - Extra NOTES ---

-- Get UTC DATE:
SELECT GETUTCDATE() AS CurrentUTCDateTime;

-- Get current timestamp
SELECT CURRENT_TIMESTAMP;

-- Calculate UNIX TIME on Microsoft SQL
SELECT DATEDIFF(s, '1970-01-01', CURRENT_TIMESTAMP);

-- Get all the adults in the family guy data
SELECT *
FROM family_guy.family_members AS c
WHERE c.age > 18;

-- Using equality signs, like in Python.
-- Remember to use the AND keyword!!
-- Let's get all the young adults, 13 < age < 25
SELECT *
FROM family_guy.family_members AS c
WHERE c.age <= 25 AND c.age >= 13;

-- Be careful of brackets, they will give you different answers...
-- Without brackets, this is being evaluated from left to right.
-- the AND condition is considering all the age betweens, both components
SELECT *
FROM family_guy.family_members
WHERE last_name IN ('Griffin', 'Swanson')
    AND age BETWEEN 1 and 18 -- The Griffin Kids + Brian
    OR age BETWEEN 40 and 100; -- The Swanson parents

-- See what happens with brackets
SELECT *
FROM family_guy.family_members
WHERE last_name IN ('Griffin', 'Swanson')
    AND (age BETWEEN 1 and 18
    OR age BETWEEN 18 and 100);

-- Get a list of the oldest members of each family.
-- We also want their first_name, last_name, age too

SELECT
    first_name,
    last_name,
    age
FROM family_guy.family_members
WHERE age IN (
    SELECT MAX(age)
    FROM family_guy.family_members
    GROUP BY last_name
    );


-- Select the youngest people before
SELECT first_name,
       last_name,
       age
FROM family_guy.family_members
WHERE age IN (
    SELECT MIN(age)
    FROM family_guy.family_members
    GROUP BY last_name -- this part is important, this controls the grouping outside
    );

-- Count how many people are in each family
SELECT last_name, COUNT(last_name) AS family_count
FROM family_guy.family_members
GROUP BY last_name;

-- Average age
SELECT last_name, AVG(age)
FROM family_guy.family_members
GROUP BY last_name;

-- Use the "WITH" keyword to also get the first_name from the max or min record.
-- This creates an expression called max_age-family.
-- However, once you put the semi-colon, the expression disappears forever.
-- Unfortunately doesn't give first_name

WITH max_age_family AS(
    SELECT last_name, MAX(age) AS max_age
    FROM family_guy.family_members
    GROUP BY last_name
)
SELECT *
FROM max_age_family;

-- You can use it to return and save other information, like segment the families.
-- Separate via existing columns information instead of derived information.
-- Note that the WITH keyword will restrict based on whatever the subquery's data was.
-- The view cannot be changed.
WITH griffin_family AS(
    SELECT *
    FROM family_guy.family_members
    WHERE last_name = 'Griffin')
SELECT last_name
FROM griffin_family;


-- Two Methods of Subquery covered:
-- 1) Convoluted "IN" subquery
-- 2) WITH ____ AS() method

-- Final Concept - Breaking down and Isolations
-- Notice this code looks at every person from every family.
-- So Joe Swanson, and Stewie
SELECT MAX(age) as OLDEST_PERSON,
       MIN(age) AS YOUNGEST_PERSON
FROM family_guy.family_members;

-- Let's include their last_names.
-- Look at youngest and oldest person per household.
SELECT last_name,
       MAX(age) as OLDEST_PERSON,
       MIN(age) AS YOUNGEST_PERSON
FROM family_guy.family_members
GROUP BY last_name; -- When using agg functions, you must put x-vars in GROUP BY

-- Isolation of Time and Dates:
SELECT YEAR(CURRENT_TIMESTAMP) AS current_year,
       MONTH(CURRENT_TIMESTAMP) AS current_month,
       DAY(CURRENT_TIMESTAMP) AS current_day;

-- Not in this dataset, but in the bakery dataset, you can do formulas
USE mmai_db;

SELECT YEAR(sale_datetime),
       MONTH(sale_datetime),
       SUM(quantity * unit_price) AS revenue
FROM mmai_db.assignment01.bakery_sales
GROUP BY YEAR(sale_datetime);

-- Split Month, Year, Date in the sale_datetime
SELECT YEAR(sale_datetime) AS year,
       MONTH(sale_datetime) AS month,
       DAY(sale_datetime) AS day
FROM mmai_db.assignment01.bakery_sales;

-- Time Horizon of the Bakery Data
SELECT MAX(sale_datetime) AS EARLIEST_DATE,
       MIN(sale_datetime) AS OLDEST_DATE
FROM mmai_db.assignment01.bakery_sales;

-- Distinct Min and Max Prices
-- IN this example, you'd like a subquery to look at distinct min/max
SELECT
    DISTINCT(article) AS product_name,
    unit_price AS unit_price
FROM mmai_db.assignment01.bakery_sales
WHERE unit_price IN(
    SELECT MIN(unit_price)
    FROM mmai_db.assignment01.bakery_sales
    );


-- You have to do subquery, as this will fail.
-- Distinct and other unique keywords require subqueries to work.
-- SELECT DISTINCT(article),
--        MIN(unit_price)
-- FROM mmai_db.assignment01.bakery_sales
-- GROUP BY product_name;

-- Look for all products under MOISSON
SELECT article,
       COUNT(*) AS n_count
FROM mmai_db.assignment01.bakery_sales
WHERE article = 'MOISSON'
GROUP BY article;

-- Order keyword - ORDER BY
-- You can also order by using number of the column
SELECT unit_price,
       COUNT(*)
FROM mmai_db.assignment01.bakery_sales
GROUP BY unit_price
ORDER BY 1 DESC;

-- You can also order by aggregation values too
SELECT unit_price,
       COUNT(*)
FROM mmai_db.assignment01.bakery_sales
GROUP BY unit_price
ORDER BY 2 DESC;

--- ADDTIONAL CONCEPTS FROM ALEX --
-- Add Table based on current existence. We are adding an instructor table under the SCHEMA of "Schulich"

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Schulich' AND TABLE_NAME = 'instructors')
    BEGIN
        CREATE TABLE schulich.instructors (
            instructor_id  INTEGER IDENTITY(1,1) PRIMARY KEY,
            first_name     VARCHAR(255),
            last_name      VARCHAR(255),
            date_of_birth  DATE,
            annual_salary  NUMERIC)
    END;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Schulich' AND TABLE_NAME = 'courses')
    BEGIN
        CREATE TABLE schulich.courses (
            course_id       INTEGER IDENTITY(1,1) PRIMARY KEY,
            course_name     VARCHAR(255),
            course_credits  INTEGER
        )
    END;






