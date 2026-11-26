--Sobia Pervaiz

--Part 1.c — Bank Analysis Task: KPI Summary Report
--You are given two datasets for bank XYZ (shown below). 
--Create the tables, insert the data, then build the summary report.

----------------------------------------------------------------------
--1. Create Table and Index for XYZ_Activity_checking
----------------------------------------------------------------------

CREATE TABLE XYZ_Activity_checking (
	Obs INT Identity(1,1) PRIMARY KEY, --Create Clustered index
	Client_ID INT NOT NULL,  -- allowing duplicates
	Account_ID INT NOT NULL, -- allowing duplicates
	Open_Date Date NOT NULL,
	Assets DECIMAL(18,2), --Handle negative values
	[Status] VARCHAR(15));  -- Status is a reserved word, so using []

-- Create non-clustered index for Client_ID
CREATE NONCLUSTERED INDEX IX_Activity_checking_Client_ID
ON XYZ_Activity_checking(Client_ID);

-- Create non-clustered index for Account_ID
CREATE NONCLUSTERED INDEX IX_Activity_checking_Account_ID
ON XYZ_Activity_checking(Account_ID);

----------------------------------------------------------------------
--2. Create Table and Index for XYZ_Activity_creditcard
----------------------------------------------------------------------

CREATE TABLE XYZ_Activity_creditcard (
	Obs INT IDENTITY(1,1) PRIMARY KEY,  --Create Clustered index
	Client_ID INT NOT NULL, --allowing duplicates
	Account_ID INT NOT NULL,  --Create Clustered index
	Open_Date Date NOT NULL,
	Credit_Status VARCHAR(50),
	Assests DECIMAL(18,2) --Handle negative values
	);

-- Create Index for Client_ID to access information quickly
CREATE NONCLUSTERED INDEX IX_Activity_creditcard_Client_ID
ON XYZ_Activity_creditcard(Client_ID);

CREATE NONCLUSTERED INDEX IX_Activity_creditcard_Account_ID 
ON XYZ_Activity_creditcard(Account_ID);

----------------------------------------------------------------------
--3. Insert Values into tables
----------------------------------------------------------------------

INSERT INTO XYZ_Activity_checking(Client_ID,Account_ID,Open_Date,Assets,[Status])
VALUES (1001,20032,'2019-11-02',7744,'Active'),
	(1002,20056,'2020-12-12',-12451,'Inactive'),
	(1003,20032,'2019-01-12',1274,'Active'),
	(1003,20074,'2019-01-19',7683,'Active'),
	(1002,20793,'2017-09-17',-591,'Active'),
	(1004,20142,'2017-02-16',14144,'Active'),
	(1005,21943,'2016-10-24',13981,'Active'),
	(1006,29371,'2008-06-09',14049,'Inactive'),
	(1002,29081,'2018-04-05',2092,'Active')

	----------------------------------------------------------------------
--3. Insert Values into tables
----------------------------------------------------------------------

INSERT INTO XYZ_Activity_creditcard(Client_ID,Account_ID,Open_Date,Credit_Status,Assests)
VALUES (1003,313058,'2015-12-17','Active',-4059),
	(1004,339524,'2019-01-16','Active',-4327),
	(1002,330572,'2019-09-26','Active',15392),
	(1003,396821,'2020-02-07','Inactive',-1359),
	(1004,375271,'2018-03-15','Active',-1601),
	(1003,373859,'2020-09-09','Active',16515),
	(1006,383733,'2017-11-08','Inactive',5226),
	(1006,353413,'2018-03-16','Inactive',13741),
	(1005,365605,'2017-06-25','Active',-4110)

	SELECT * FROM XYZ_Activity_checking;
	SELECT * FROM XYZ_Activity_creditcard;

	----------------------------
	--XYZ_Since_Date: the first date the customer started a relationship 
	--with XYZ (earliest Open_Date across both datasets).

----------------------------------------------------------------

SELECT Client_ID, min(Earliest_Date) as XYZ_Since_Date
FROM
(SELECT Client_ID, min(Open_Date) as Earliest_Date 
FROM XYZ_Activity_checking
WHERE Status='Active'
GROUP BY Client_ID
UNION ALL 
SELECT Client_ID,MIN(Open_Date) AS Earliest_Date 
FROM XYZ_Activity_creditcard
WHERE Credit_Status='Active'
GROUP BY Client_ID)
AS Combined_Dates
GROUP BY Client_ID;

--------------------------------------------------------------------
--Product1_Since_Date: the first date the customer joined Product1 (checking accounts).
--------------------------------------------------------------------

SELECT Client_ID,MIN(Open_Date) as Product1_Since_Date
FROM XYZ_Activity_checking
WHERE Status='Active'
GROUP BY Client_ID;

-----------------------------------------------------------------
--Product2_Since_Date: the first date the customer joined Product2 (credit card accounts).
-----------------------------------------------------------------
	
SELECT Client_ID,MIN(Open_Date) as Product2_Since_Date
FROM XYZ_Activity_creditcard
WHERE Credit_Status='Active'
GROUP BY Client_ID;

-------------------------------------------------------------------
--Total_Actives: the total number of active accounts held by the customer.
-------------------------------------------------------------------

SELECT Client_ID, 
SUM(TotalAccounts) as TotalActiveAccounts
FROM
(SELECT Client_ID,
COUNT(Account_ID) AS TotalAccounts
FROM XYZ_Activity_checking
WHERE Status='Active'
GROUP BY Client_ID

UNION ALL
SELECT Client_ID,
COUNT(Account_ID) AS TotalAccounts
FROM XYZ_Activity_creditcard
WHERE Credit_Status='Active'
GROUP BY Client_ID) 
AS ActiveAccounts
GROUP BY Client_ID;

-----------------------------------------------------------------------------
--Total_Assets: the total assets for the customer (across both products).
-----------------------------------------------------------------------------
SELECT Client_ID,SUM(TotalAssests) AS TotalAssets
FROM
(SELECT Client_ID,SUM(Assets) as TotalAssests 
FROM XYZ_Activity_checking
WHERE Status='Active'
GROUP BY Client_ID
UNION ALL
SELECT Client_ID,SUM(Assests) AS TotalAssets
FROM XYZ_Activity_creditcard
WHERE Credit_Status='Active'
GROUP BY Client_ID)
AS TotalAssetsCust
GROUP BY Client_ID;

------------------------------------------------------------------------
--Part 1.d — Product Sales Analysis Task
------------------------------------------------------------------------
--Product_Sales1
CREATE TABLE Product_Sales1 (product INT, no INT, q INT, price DECIMAL(10,2));

INSERT INTO Product_Sales1 VALUES
(23, 3, 12, 250.00), (23, 15, 24, 450.00),
(23, 25, 16, 346.00), (46, 45, 25, 560.00); 

--Product_Sales2
CREATE TABLE Product_Sales2 (product INT, no INT, price DECIMAL(10,2));
INSERT INTO Product_Sales2 VALUES
(46, 23, 250.00), (27, 15, 450.00),
(37, 25, 36.00), (46, 50, 700.00); 

--POS1
CREATE TABLE POS1 (date DATE, sales DECIMAL(10,2), product INT, no INT);

INSERT INTO POS1 VALUES ('2001-01-22', 250.00, 23, 3), 
('2002-01-22', 300.00, 27, 15); 

--POS2
CREATE TABLE POS2 (date DATE, sales DECIMAL(10,2), product INT, no INT);

INSERT INTO POS2 VALUES ('2001-01-22', 280.00, 23, 3), 
('2002-01-22', 150.00, 37, 25); 
CREATE TABLE POS3 (date DATE, sales DECIMAL(10,2), product INT, no INT);
INSERT INTO POS3 VALUES ('2001-01-22', 280.00, 23, 3), 
('2002-01-22', 400.00, 27, 15);


SELECT * FROM Product_Sales1
SELECT * FROM Product_Sales2
SELECT * FROM POS1
SELECT * FROM POS2
SELECT * FROM POS3

------------------------------------------------------------------
--1.	Find Duplicates: identify common products and records
-- duplicated between Product_Sales1 and Product_Sales2.
------------------------------------------------------------
SELECT Distinct p1.product
FROM Product_Sales1 P1
JOIN Product_Sales2 P2
ON P1.product=P2.product

--duplicates
SELECT product, no, price 
FROM Product_Sales1

INTERSECT

SELECT product, no, price 
FROM Product_Sales2;
------------------------------------------------------------
--2. Merge Tables: merge the two product tables, including
--duplicate records, into a new table (Merged_Table).
-------------------------------------------------



SELECT product, no, q, price 
INTO Merged_Table
FROM Product_Sales1

UNION ALL

SELECT product, no, NULL AS q, price 
FROM Product_Sales2;
SELECT * FROM Merged_Table;

SELECT DISTINCT product, no, q, price
INTO Cleaned_Table
FROM Merged_Table;


SELECT * FROM Cleaned_Table;
----------------------------------------------------------------
--Sales Summary: create a temporary table calculating
--the sum of sales for each product on each date, using POS1, POS2, and POS3.
-----------------------------------------------------------------
SELECT * FROM POS1
SELECT * FROM POS2
SELECT * FROM POS3
SELECT product,date,SUM(Sales) as TotalSales
INTO #SalesSummary
FROM (SELECT date, sales,product FROM POS1
UNION ALL
SELECT date,sales,product FROM POS2
UNION ALL
SELECT date,sales,product FROM POS3
) AS CombinedPOS
GROUP BY date,product;

SELECT * FROM #SalesSummary;

------------------------------------------------------------------
-- Sales Aggregation: calculate total sales for each product 
-- across all dates, using the temporary table from the previous step.
---------------------------------------------------------------------
SELECT 
    product,
    SUM(TotalSales) AS Lifetime_Total_Sales
FROM #SalesSummary
GROUP BY product
ORDER BY Lifetime_Total_Sales DESC;

-------------------------------------------------------------
--Sales Report: list each product with: total sales (all POS tables),
--total distinct transaction dates, and average sales per transaction.
-----------------------------------------------------------------

SELECT 
    product,
    -- 1. Total sales across all POS tables
    SUM(sales) AS Total_Sales,
    
    -- 2. Total distinct transaction dates
    COUNT(DISTINCT [date]) AS Total_Distinct_Dates,
    
    -- 3. Average sales per transaction
    AVG(sales) AS Average_Sales_Per_Transaction
FROM (
    SELECT [date], sales, product FROM POS1
    UNION ALL
    SELECT [date], sales, product FROM POS2
    UNION ALL
    SELECT [date], sales, product FROM POS3
) AS ConsolidatedPOS
GROUP BY product
ORDER BY Total_Sales DESC;

---------------------------------------------------------------
--Part 1.e — Bank Analysis: Transaction & Account Management
--Create the two tables below with the sample data, then answer the six questions.
-------------------------------------------------------------------


-- Create Txn_tbl
CREATE TABLE Txn_tbl (
    Obs INT PRIMARY KEY,
    customer_id INT NOT NULL, -- null not allowed
    txn_id INT NOT NULL UNIQUE,
    Txn_type_key INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

-- Populate Txn_tbl
INSERT INTO Txn_tbl (Obs, customer_id, txn_id, Txn_type_key, amount) VALUES
(1, 1, 1001, 3125, 100.00),
(2, 1, 1002, 3124, 50.00),
(3, 2, 1003, 3546, 200.00),
(4, 1, 1004, 3543, 50.00),
(5, 3, 1005, 14, 30.00),
(6, 2, 1006, 3125, 20.00),
(7, 2, 1007, 3600, 10.00),
(8, 1, 1008, 1600, 20.00);

-- Create Account_tbl
CREATE TABLE Account_tbl (
    customer_id INT NOT NULL,
    account_id INT NOT NULL PRIMARY KEY,
    create_date DATE NOT NULL    
);

-- Populate Account_tbl
INSERT INTO Account_tbl (customer_id, account_id, create_date) VALUES
(1, 101, '2022-09-01'),
(1, 102, '2023-11-15'),
(1, 103, '2025-01-01'),
(2, 104, '2018-10-22'),
(3, 105, '2020-09-18');


SELECT * FROM Txn_tbl;
SELECT * FROM Account_tbl;
--------------------------------------------------------------
--1.Write a query to find the most recent account_id for each customer based on create_date.
-------------------------------------------------------------------
WITH RankedAccounts AS (
    SELECT 
        customer_id,
        account_id,
        create_date,
        -- Assigns a rank of 1 to the newest account per customer
        ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY create_date DESC, account_id DESC
        ) AS AccountRank
    FROM Account_tbl
)
SELECT 
    customer_id,
    account_id AS Most_Recent_Account_ID,
    create_date AS Account_Created_Date
FROM RankedAccounts
WHERE AccountRank = 1; 
-----------------------------------------------------------------------
--2.Join Txn_tbl with Account_tbl and return the transaction
--details along with the most recent account_id for each customer.
---------------------------------------------------------------------
WITH MostRecentAccount AS (
    SELECT 
        customer_id,
        account_id,
        create_date,
        -- Rank accounts per customer, prioritizing the newest date
        ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY create_date DESC, account_id DESC
        ) AS AccountRank
    FROM Account_tbl
)
SELECT 
    t.Obs,
    t.customer_id,
    t.txn_id,
    t.Txn_type_key,
    t.amount,
    m.account_id AS Most_Recent_Account_ID,
    m.create_date AS Account_Created_Date
FROM Txn_tbl t
LEFT JOIN MostRecentAccount m 
    ON t.customer_id = m.customer_id 
   AND m.AccountRank = 1 -- Only joins the absolute newest account row
ORDER BY t.Obs;

-------------------------------------------------------------------------
--7.Write a query that returns one row per customer with: number of credit transactions,
--total credit amount, number of debit transactions, and total debit amount. 
-------------------------------------------------------------------------------


SELECT customer_id,
COUNT(CASE 
WHEN Txn_type_key IN (3125, 3124, 3600, 4500, 6577, 8900)
    THEN 1 END) AS Credit_Txn_Count,
SUM(CASE WHEN Txn_type_key IN (3125, 3124, 3600, 4500, 6577, 8900)
    THEN AMOUNT ELSE 0 END) AS Total_Credit_Amount,
COUNT(CASE WHEN Txn_type_key IN (3546, 3543, 14, 1600, 8700, 8888) 
    THEN 1 END) AS Debit_Txn_Count,
SUM(CASE WHEN Txn_type_key IN (3546, 3543, 14, 1600, 8700, 8888) 
    THEN amount ELSE 0 END) AS Total_Debit_Amount

FROM Txn_tbl
GROUP BY customer_id;

------------------------------------------------------------
--Phase II: Library Management System
------------------------------------------------------------

create database db_libraryManagment
go

/*==========================Tables==========================*/
/*•	tbl_publisher
•	tbl_book
•	tbl_library_branch
•	tbl_borrower
•	tbl_book_loans
•	tbl_book_copies
•	tbl_book_authors*/

/*=============================Create Table tbl_publisher===========================*/


CREATE TABLE tbl_publisher(
	publisher_PublisherName VARCHAR(150) PRIMARY KEY,
	publisher_PublisherAddress VARCHAR(250) ,
	publisher_PublisherPhone VARCHAR(20));
/*=============================Populate tables=======================*/


INSERT INTO tbl_publisher
		(publisher_PublisherName, publisher_PublisherAddress, publisher_PublisherPhone)
		VALUES
		('DAW Books','375 Hudson Street, New York, NY 10014','212-366-2000'),
		('Viking','375 Hudson Street, New York, NY 10014','212-366-2000'),
		('Signet Books','375 Hudson Street, New York, NY 10014','212-366-2000'),
		('Chilton Books','Not Available','Not Available'),
		('George Allen & Unwin','83 Alexander Ln, Crows Nest NSW 2065, Australia','+61-2-8425-0100'),
		('Alfred A. Knopf','The Knopf Doubleday Group Domestic Rights, 1745 Broadway, New York, NY 10019','212-940-7390'),		
		('Bloomsbury','Bloomsbury Publishing Inc., 1385 Broadway, 5th Floor, New York, NY 10018','212-419-5300'),
		('Shinchosa','Oga Bldg. 8, 2-5-4 Sarugaku-cho, Chiyoda-ku, Tokyo 101-0064 Japan','+81-3-5577-6507'),
		('Harper and Row','HarperCollins Publishers, 195 Broadway, New York, NY 10007','212-207-7000'),
		('Pan Books','175 Fifth Avenue, New York, NY 10010','646-307-5745'),
		('Chalto & Windus','375 Hudson Street, New York, NY 10014','212-366-2000'),
		('Harcourt Brace Jovanovich','3 Park Ave, New York, NY 10016','212-420-5800'),
		('W.W. Norton',' W. W. Norton & Company, Inc., 500 Fifth Avenue, New York, New York 10110','212-354-5500'),
		('Scholastic','557 Broadway, New York, NY 10012','800-724-6527'),
		('Bantam','375 Hudson Street, New York, NY 10014','212-366-2000'),
		('Picador USA','175 Fifth Avenue, New York, NY 10010','646-307-5745')		
	;

	SELECT * FROM tbl_publisher

	
/*=============================Create Table tbl_book===========================*/


CREATE TABLE tbl_book(book_BookID INT IDENTITY(1,1) PRIMARY KEY,
	book_Title VARCHAR(150) NOT NULL, --NULL NOT ALLOWED
	book_PublisherName VARCHAR(150) NOT NULL,

	FOREIGN KEY(book_PublisherName) 
	REFERENCES tbl_publisher(publisher_PublisherName)
	);
/*=============================Populate table=======================*/
	

	INSERT INTO tbl_book
		(book_Title, book_PublisherName)
		VALUES 
		('The Name of the Wind', 'DAW Books'),
		('It', 'Viking'),
		('The Green Mile', 'Signet Books'),
		('Dune', 'Chilton Books'),
		('The Hobbit', 'George Allen & Unwin'),
		('Eragon', 'Alfred A. Knopf'),
		('A Wise Mans Fear', 'DAW Books'),
		('Harry Potter and the Philosophers Stone', 'Bloomsbury'),
		('Hard Boiled Wonderland and The End of the World', 'Shinchosa'),
		('The Giving Tree', 'Harper and Row'),
		('The Hitchhikers Guide to the Galaxy', 'Pan Books'),
		('Brave New World', 'Chalto & Windus'),
		('The Princess Bride', 'Harcourt Brace Jovanovich'),
		('Fight Club', 'W.W. Norton'),
		('Holes', 'Scholastic'),
		('Harry Potter and the Chamber of Secrets', 'Bloomsbury'),
		('Harry Potter and the Prisoner of Azkaban', 'Bloomsbury'),
		('The Fellowship of the Ring', 'George Allen & Unwin'),
		('A Game of Thrones', 'Bantam'),
		('The Lost Tribe', 'Picador USA');

	SELECT * FROM tbl_book WHERE book_PublisherName = 'George Allen & Unwin'

	/*=============================Create Table tbl_library_branch===========================*/


CREATE TABLE tbl_library_branch(library_branch_BranchID INT IDENTITY(1,1) PRIMARY KEY,
	library_branch_BranchName VARCHAR(150) NOT NULL, 
	library_branch_BranchAddress VARCHAR(250) NOT NULL
	);

	/*=============================Populate table=======================*/

	INSERT INTO tbl_library_branch
		(library_branch_BranchName, library_branch_BranchAddress)
		VALUES
		('Sharpstown','32 Corner Road, New York, NY 10012'),
		('Central','491 3rd Street, New York, NY 10014'),
		('Saline','40 State Street, Saline, MI 48176'),
		('Ann Arbor','101 South University, Ann Arbor, MI 48104');

SELECT * FROM tbl_library_branch

/*=============================Create Table tbl_borrower===========================*/
CREATE TABLE tbl_borrower (borrower_CardNo INT IDENTITY(100,1) PRIMARY KEY, 
	borrower_BorrowerName VARCHAR(150) NOT NULL, --NULL NOT ALLOWED
	borrower_BorrowerAddress VARCHAR(250) NOT NULL,
	borrower_BorrowerPhone VARCHAR(25) NOT NULL)

/*=============================Populate table=======================*/
	INSERT INTO tbl_borrower
		(borrower_BorrowerName, borrower_BorrowerAddress, borrower_BorrowerPhone)
		VALUES
		('Joe Smith','1321 4th Street, New York, NY 10014','212-312-1234'),
		('Jane Smith','1321 4th Street, New York, NY 10014','212-931-4124'),
		('Tom Li','981 Main Street, Ann Arbor, MI 48104','734-902-7455'),
		('Angela Thompson','2212 Green Avenue, Ann Arbor, MI 48104','313-591-2122'),
		('Harry Emnace','121 Park Drive, Ann Arbor, MI 48104','412-512-5522'),
		('Tom Haverford','23 75th Street, New York, NY 10014','212-631-3418'),
		('Haley Jackson','231 52nd Avenue New York, NY 10014','212-419-9935'),
		('Michael Horford','653 Glen Avenue, Ann Arbor, MI 48104','734-998-1513');
	
	SELECT * FROM tbl_borrower

/*=============================Create Table tbl_book_loans===========================*/
CREATE TABLE tbl_book_loans (book_loans_LoansID INT IDENTITY(1,1) PRIMARY KEY,
	book_loans_BookID INT NOT NULL,
	book_loans_BranchID INT NOT NULL,
	book_loans_CardNo INT NOT NULL,
	book_loans_DateOut VARCHAR(20) NOT NULL,
	book_loans_DueDate VARCHAR(20) NOT NULL,

	FOREIGN KEY(book_loans_BookID) 
	REFERENCES tbl_book(book_BookID),

	FOREIGN KEY(book_loans_BranchID) 
	REFERENCES tbl_library_branch(library_branch_BranchID),
	
	FOREIGN KEY (book_loans_CardNo)
	REFERENCES tbl_borrower(borrower_CardNo));

	/*=============================Populate table=======================*/
	INSERT INTO tbl_book_loans
		(book_loans_BookID, book_loans_BranchID, book_loans_CardNo, book_loans_DateOut, book_loans_DueDate)
		VALUES
		('1','1','100','1/1/18','2/2/18'),
		('2','1','100','1/1/18','2/2/18'),
		('3','1','100','1/1/18','2/2/18'),
		('4','1','100','1/1/18','2/2/18'),
		('5','1','102','1/3/18','2/3/18'),
		('6','1','102','1/3/18','2/3/18'),
		('7','1','102','1/3/18','2/3/18'),
		('8','1','102','1/3/18','2/3/18'),
		('9','1','102','1/3/18','2/3/18'),
		('11','1','102','1/3/18','2/3/18'),
		('12','2','105','12/12/17','1/12/18'),
		('10','2','105','12/12/17','1/12/17'),
		('20','2','105','2/3/18','3/3/18'),
		('18','2','105','1/5/18','2/5/18'),
		('19','2','105','1/5/18','2/5/18'),
		('19','2','100','1/3/18','2/3/18'),
		('11','2','106','1/7/18','2/7/18'),
		('1','2','106','1/7/18','2/7/18'),
		('2','2','100','1/7/18','2/7/18'),
		('3','2','100','1/7/18','2/7/18'),
		('5','2','105','12/12/17','1/12/18'),
		('4','3','103','1/9/18','2/9/18'),
		('7','3','102','1/3/18','2/3/18'),
		('17','3','102','1/3/18','2/3/18'),
		('16','3','104','1/3/18','2/3/18'),
		('15','3','104','1/3/18','2/3/18'),
		('15','3','107','1/3/18','2/3/18'),
		('14','3','104','1/3/18','2/3/18'),
		('13','3','107','1/3/18','2/3/18'),
		('13','3','102','1/3/18','2/3/18'),
		('19','3','102','12/12/17','1/12/18'),
		('20','4','103','1/3/18','2/3/18'),
		('1','4','102','1/12/18','2/12/18'),
		('3','4','107','1/3/18','2/3/18'),
		('18','4','107','1/3/18','2/3/18'),
		('12','4','102','1/4/18','2/4/18'),
		('11','4','103','1/15/18','2/15/18'),
		('9','4','103','1/15/18','2/15/18'),
		('7','4','107','1/1/18','2/2/18'),
		('4','4','103','1/1/18','2/2/18'),
		('1','4','103','2/2/17','3/2/18'),
		('20','4','103','1/3/18','2/3/18'),
		('1','4','102','1/12/18','2/12/18'),
		('3','4','107','1/13/18','2/13/18'),
		('18','4','107','1/13/18','2/13/18'),
		('12','4','102','1/14/18','2/14/18'),
		('11','4','103','1/15/18','2/15/18'),
		('9','4','103','1/15/18','2/15/18'),
		('7','4','107','1/19/18','2/19/18'),
		('4','4','103','1/19/18','2/19/18'),
		('1','4','103','1/22/18','2/22/18');

		
	SELECT * FROM tbl_book_loans
	/*=============================Create Table tbl_book_copies===========================*/

	CREATE TABLE tbl_book_copies (book_copies_CopiesID INT IDENTITY PRIMARY KEY,
	book_copies_BookID INT NOT NULL, 
	book_copies_BranchID INT NOT NULL,
	book_copies_No_Of_Copies INT NULL,
	
	FOREIGN KEY (book_copies_BookID)
	REFERENCES tbl_book(book_BookID),
	
	FOREIGN KEY (book_copies_BranchID)
	REFERENCES tbl_library_branch(library_branch_BranchID));

		/*=============================Populate table=======================*/
	INSERT INTO tbl_book_copies
		(book_copies_BookID, book_copies_BranchID, book_copies_No_Of_Copies)
		VALUES
		('1','1','5'),
		('2','1','5'),
		('3','1','5'),
		('4','1','5'),
		('5','1','5'),
		('6','1','5'),
		('7','1','5'),
		('8','1','5'),
		('9','1','5'),
		('10','1','5'),
		('11','1','5'),
		('12','1','5'),
		('13','1','5'),
		('14','1','5'),
		('15','1','5'),
		('16','1','5'),
		('17','1','5'),
		('18','1','5'),
		('19','1','5'),
		('20','1','5'),
		('1','2','5'),
		('2','2','5'),
		('3','2','5'),
		('4','2','5'),
		('5','2','5'),
		('6','2','5'),
		('7','2','5'),
		('8','2','5'),
		('9','2','5'),
		('10','2','5'),
		('11','2','5'),
		('12','2','5'),
		('13','2','5'),
		('14','2','5'),
		('15','2','5'),
		('16','2','5'),
		('17','2','5'),
		('18','2','5'),
		('19','2','5'),
		('20','2','5'),
		('1','3','5'),
		('2','3','5'),
		('3','3','5'),
		('4','3','5'),
		('5','3','5'),
		('6','3','5'),
		('7','3','5'),
		('8','3','5'),
		('9','3','5'),
		('10','3','5'),
		('11','3','5'),
		('12','3','5'),
		('13','3','5'),
		('14','3','5'),
		('15','3','5'),
		('16','3','5'),
		('17','3','5'),
		('18','3','5'),
		('19','3','5'),
		('20','3','5'),
		('1','4','5'),
		('2','4','5'),
		('3','4','5'),
		('4','4','5'),
		('5','4','5'),
		('6','4','5'),
		('7','4','5'),
		('8','4','5'),
		('9','4','5'),
		('10','4','5'),
		('11','4','5'),
		('12','4','5'),
		('13','4','5'),
		('14','4','5'),
		('15','4','5'),
		('16','4','5'),
		('17','4','5'),
		('18','4','5'),
		('19','4','5'),
		('20','4','5');

	SELECT * FROM tbl_book_copies
 
 /*=============================Create Table tbl_book_authors===========================*/
 CREATE TABLE tbl_book_authors (book_authors_AuthorID INT IDENTITY(1,1) PRIMARY KEY,
	book_authors_BookID INT NOT NULL, 
	book_authors_AuthorName VARCHAR(100))
	INSERT INTO tbl_book_authors
		(book_authors_BookID,book_authors_AuthorName)
		VALUES
		('1','Patrick Rothfuss'),
		('2','Stephen King'),
		('3','Stephen King'),
		('4','Frank Herbert'),
		('5','J.R.R. Tolkien'),
		('6','Christopher Paolini'),
		('6','Patrick Rothfuss'),
		('8','J.K. Rowling'),
		('9','Haruki Murakami'),
		('10','Shel Silverstein'),
		('11','Douglas Adams'),
		('12','Aldous Huxley'),
		('13','William Goldman'),
		('14','Chuck Palahniuk'),
		('15','Louis Sachar'),
		('16','J.K. Rowling'),
		('17','J.K. Rowling'),
		('18','J.R.R. Tolkien'),
		('19','George R.R. Martin'),
		('20','Mark Lee');

	SELECT * FROM tbl_book_authors
	-----------------------------------------------------
	--Step 3 — Queries
	------------------------------------------------------
--Write one query for each of the following:
-- 1.Find the titles of all books published by "Bloomsbury."
SELECT book_Title 
FROM tbl_book
WHERE book_PublisherName='Bloomsbury';

-------------------------------------------------------
--2. List the names of borrowers whose phone numbers start with the area code "212."
-------------------------------------------------------------
SELECT borrower_BorrowerName, borrower_BorrowerPhone
FROM tbl_borrower
WHERE borrower_BorrowerPhone LIKE '212%';

---------------------------------------------------------
--3. Retrieve the titles of books with more than 10 copies available.
-----------------------------------------------------------
SELECT book_Title 
FROM tbl_book
WHERE book_BookID 
IN
(SELECT book_copies_BookID 
FROM tbl_book_copies
WHERE book_copies_No_Of_Copies>10);

----------------------------------------------------------------
--4. Display the names of borrowers who have borrowed books from the "Central" branch.
-------------------------------------------------------------------

SELECT tb.borrower_BorrowerName, tlb.library_branch_BranchName
FROM tbl_library_branch tlb JOIN tbl_book_loans tbl --JOIN Branch and book_loans
ON tlb.library_branch_BranchID=tbl.book_loans_BranchID
JOIN tbl_borrower tb -- JOIN with borrowers table
ON tbl.book_loans_CardNo=tb.borrower_CardNo
WHERE TLB.library_branch_BranchName='Central' --apply condition
GROUP BY tb.borrower_BorrowerName, tlb.library_branch_BranchName; --group by Borrower name,BranchName

---------------------------------------------------------
--5. List the titles of books borrowed by borrower "Joe Smith."
---------------------------------------------------------

SELECT tbk.book_Title, tbr.borrower_BorrowerName
FROM tbl_book tbk JOIN tbl_book_loans tbl --book and loans are joined
ON tbk.book_BookID=tbl.book_loans_BookID
JOIN tbl_borrower tbr --further joined with borrower
ON tbl.book_loans_CardNo=tbr.borrower_CardNo
WHERE tbr.borrower_BorrowerName='Joe Smith' --condition of Name
GROUP BY book_Title, tbr.borrower_BorrowerName; 


-------------------------------------------------------------
--6. Find the names of publishers for the books authored by "J.K. Rowling."
--------------------------------------------------------------
SELECT tb.book_PublisherName, tba.book_authors_AuthorName
FROM tbl_book tb --JOIN book and author table
JOIN tbl_book_authors tba
ON tb.book_BookID=tba.book_authors_BookID
WHERE tba.book_authors_AuthorName='J.K. Rowling' --apply condition
GROUP BY tb.book_PublisherName, tba.book_authors_AuthorName;

----------------------------------------------------------------
--7.Count the total number of books available in the library.
----------------------------------------------------------------
SELECT count(book_copies_No_Of_Copies) [Total Books] 
FROM tbl_book_copies;

-----------------------------------------------------------
--8. Calculate the average number of copies available per book across all branches.
------------------------------------------------------------

select 
book_copies_BookID,
[1],[2],[3],[4]
from (
select book_copies_BranchID,
book_copies_BookID,
book_copies_No_Of_Copies
from tbl_book_copies) as sourcetable
pivot
(avg(book_copies_No_Of_Copies) for 
book_copies_BranchID
IN ([1],[2],[3],[4]))
as pivotdata

-------------------------------------------------------------
--9. Find the branch with the highest number of books loaned out.
---------------------------------------------------------------
SELECT TOP 1 tlb.library_branch_BranchName,
COUNT(tbl.book_loans_LoansID) as HighestLoan
FROM tbl_library_branch tlb 
JOIN tbl_book_loans tbl
ON tlb.library_branch_BranchID=tbl.book_loans_BranchID
GROUP BY tlb.library_branch_BranchName;

-------------------------------------------------------------
--10.Insert a new book titled "The Catcher in the Rye" by "J.D. Salinger" into the database.
--------------------------------------------------------------

INSERT INTO tbl_book(book_Title, book_PublisherName)
		VALUES 
		('The Catcher in the Rye', 'DAW Books');

INSERT INTO tbl_book_authors
		(book_authors_BookID,book_authors_AuthorName)
		VALUES
		('21','J.D. Salinger');
SELECT * FROM tbl_book;
SELECT * FROM tbl_book_authors;
------------------------------------------------------------
--11.Update the address of the "Sharpstown" library branch 
--to "45 West Side Avenue, New York, NY 10012."
-------------------------------------------------------------
BEGIN TRY --TRY...CATCH block ensures that if any statement 
			--fails, the database automatically reverts (rolls back)
	BEGIN TRANSACTION -- in case if anything goes wrong, use transaction

UPDATE tbl_library_branch  --Update Address

SET library_branch_BranchAddress='45 West Side Avenue, New York, NY 10012'

WHERE library_branch_BranchName='Sharpstown';
	
	COMMIT TRANSACTION; --If updated successfully, commit transaction
	PRINT 'Transaction Commited successfully!'
END TRY

BEGIN CATCH
		-- If any error occurs, undo everything
		If @@TRANCOUNT>0 -- SQL Server tracks active transactions using a global counter called @@TRANCOUNT
		BEGIN
			ROLLBACK TRANSACTION;
			PRINT 'Error Occured. Trasaction rolled back';
		END

END CATCH; 

select * from tbl_library_branch;


-- ROLLBACK TRANSACTION -- Roll back if things messed up

-----------------------------------------------------
-- 12. Remove all books published by "Pan Books" from the database.
---------------------------------------------------------------
-- Step 1: Remove dependent author entries linked to Pan Books
DELETE FROM tbl_book_authors
WHERE book_authors_BookID IN (
    SELECT book_BookID FROM tbl_book WHERE book_PublisherName = 'Pan Books'
);

-- Step 2: Remove inventory records/copies linked to Pan Books
DELETE FROM tbl_book_copies
WHERE book_copies_BookID IN (
    SELECT book_BookID FROM tbl_book WHERE book_PublisherName = 'Pan Books'
);

-- Step 3: Remove transaction/loan history linked to Pan Books
DELETE FROM tbl_book_loans
WHERE book_loans_BookID IN (
    SELECT book_BookID FROM tbl_book WHERE book_PublisherName = 'Pan Books'
);

-- Step 4: Delete the actual book entries from the core book table
DELETE FROM tbl_book
WHERE book_PublisherName = 'Pan Books';
SELECT * FROM tbl_book;

----------------------------------------------------------------------
--13. Retrieve the names of borrowers who have borrowed the same book more than once.
----------------------------------------------------------------------

SELECT tb. borrower_BorrowerName,tbl.book_loans_BookID,
COUNT(tbl.book_loans_LoansID) AS LoanCount --Count LoanID group by BookID
FROM tbl_book_loans tbl JOIN tbl_borrower tb  --Join the two tables
ON tbl.book_loans_CardNo=tb.borrower_CardNo
GROUP BY tb. borrower_BorrowerName, tbl.book_loans_BookID --group by name and BookID
HAVING COUNT(tbl.book_loans_LoansID)>1; --borrowed more than once

-----------------------------------------------------------------------
-- 14. Find the title of the book with the earliest due date.
-----------------------------------------------------------------------
SELECT tb.book_Title,
tbl.book_loans_DueDate
FROM tbl_book tb JOIN tbl_book_loans tbl --Join tables to get title
ON tb.book_BookID=tbl.book_loans_BookID
WHERE (tbl.book_loans_DueDate) =  --apply condition on earliest due date
		(SELECT MIN(book_loans_DueDate) --find earliest due date
			FROM tbl_book_loans)
GROUP BY tb.book_Title,tbl.book_loans_DueDate;
--------------------------------------------------------------
--15. List the names of borrowers who have borrowed books authored
--by both "Stephen King" and "J.K. Rowling."
-------------------------------------------------------------
SELECT  b.borrower_BorrowerName,b.borrower_CardNo
FROM tbl_borrower b JOIN tbl_book_loans bl 
ON b.borrower_CardNo = bl.book_loans_CardNo
JOIN tbl_book_authors ba 
ON bl.book_loans_BookID = ba.book_authors_BookID
WHERE ba.book_authors_AuthorName= 'Stephen King' 
	and ba.book_authors_AuthorName='J.K. Rowling'
GROUP BY b.borrower_CardNo, b.borrower_BorrowerName;
-------------------------------------------------------------------
-- 16. Find the names of borrowers who have borrowed books published by "Bloomsbury."
-------------------------------------------------------------------------------------
SELECT DISTINCT b.borrower_BorrowerName --distinct customers
FROM tbl_borrower b JOIN tbl_book_loans bl --join three tables
ON b.borrower_CardNo = bl.book_loans_CardNo 
JOIN tbl_book bk 
ON bl.book_loans_BookID = bk.book_BookID
WHERE bk.book_PublisherName = 'Bloomsbury'; --apply condition

----------------------------------------------------------------------
--17. Retrieve the titles of books borrowed by borrowers located in New York.
----------------------------------------------------------------------
SELECT  bk.book_Title,
b.borrower_BorrowerName
FROM tbl_borrower b JOIN tbl_book_loans bl --join three tables
ON b.borrower_CardNo = bl.book_loans_CardNo 
JOIN tbl_book bk 
ON bl.book_loans_BookID = bk.book_BookID
WHERE b.borrower_BorrowerAddress like '%New York%'; --apply condition

-------------------------------------------------------------------
--18.Calculate the average number of books borrowed per borrower.
-------------------------------------------------------------------
SELECT 
    CEILING(CAST(COUNT(book_loans_LoansID) AS DECIMAL(10,2)) /  --Ceiling is used to round off
    COUNT(DISTINCT book_loans_CardNo)) AS Avg_Books_Per_Active_Borrower
FROM tbl_book_loans;

----------------------------------------------------------------------
--19. Find the branch with the highest average number of books borrowed per borrower.
--------------------------------------------------------------------------
SELECT library_branch_BranchName 
FROM tbl_library_branch
WHERE library_branch_BranchID =
(
SELECT TOP 1 book_loans_BranchID
    
FROM tbl_book_loans
GROUP BY book_loans_BranchID
ORDER BY CEILING(CAST(COUNT(book_loans_LoansID) AS DECIMAL(10,2)) /  
    COUNT(DISTINCT book_loans_CardNo)) DESC);

------------------------------------------------------------------------------
--20.Rank library branches based on the total number of books borrowed, without grouping.
-------------------------------------------------------------------------------
WITH BranchCounts AS --Store Select as a new table
(SELECT DISTINCT tlb.library_branch_BranchName,  -- Use Distinct to Retiriev info for each Branch
tlb.library_branch_BranchID,
TotalLoans=COUNT(tbl.book_loans_LoansID) -- Number of Books borrowed by Count of LoanID
	OVER (PARTITION BY tlb.library_branch_BranchID)

FROM tbl_library_branch tlb JOIN tbl_book_loans tbl  --Join the tables
ON tlb.library_branch_BranchID=tbl.book_loans_BranchID)

SELECT library_branch_BranchName,
TotalLoans,
Ranking=DENSE_RANK() OVER   --Rank Over TotalLoans
	(ORDER BY TotalLoans DESC)
FROM BranchCounts; --Use Stored Table

------------------------------------------------------------------------------
--21. Calculate the percentage of books borrowed from each branch relative 
--to the total borrowed across all branches.
-------------------------------------------------------------------------------
CREATE OR ALTER VIEW BooksBorrowed AS  --create view to avoid writing the same join

SELECT DISTINCT tlb.library_branch_BranchName, --Distinct Names
tbl.book_loans_BranchID,  
COUNT(tbl.book_loans_LoansID)     --Count of TotalLoans for each library
OVER (PARTITION BY book_loans_BranchID)AS TotalLoans
FROM tbl_book_loans tbl JOIN tbl_library_branch tlb --Join to get the name of library
ON tbl.book_loans_BranchID=tlb.library_branch_BranchID
GO

SELECT library_branch_BranchName,  --library name
TotalLoans,   --loans from each library
PercentLoans= TotalLoans*100/SUM(TotalLoans)
	OVER() --percentage loan for each library over all rows
FROM BooksBorrowed;

-------------------------------------------------------------------------
--23. Find the names of borrowers who have borrowed books authored 
--by "Stephen King" and "J.K. Rowling" from the same library branch.
-------------------------------------------------------------------------

SELECT DISTINCT tlb.library_branch_BranchName,
	tbr.borrower_BorrowerName,
	tbl.book_loans_BranchID,
	tbr.borrower_CardNo,
	tba.book_authors_AuthorNAme

FROM tbl_borrower tbr JOIN tbl_book_loans tbl
ON tbr.borrower_CardNo=tbl.book_loans_CardNo --jOIN THE FOUR TABLE

JOIN tbl_book tb 
ON tbl.book_loans_BookID=tb.book_BookID

JOIN tbl_library_branch tlb
ON tbl.book_loans_BranchID=tlb.library_branch_BranchID

JOIN
tbl_book_authors tba
ON tb.book_BookID=tba.book_authors_BookID

WHERE tba.book_authors_AuthorName in
		('Stephen King' ,'J.K. Rowling') -- Who borrowed either of the two author books

GROUP BY tbr.borrower_CardNo,
	tbr.borrower_BorrowerName,
	tbl.book_loans_BranchID,
	tlb.library_branch_BranchName,
	tba.book_authors_AuthorNAme,
	tbl.book_loans_LoansID
	HAVING 
	COUNT(distinct tlb.library_branch_BranchID)=1 --from the same library
	AND COUNT(distinct tbl.book_loans_LoansID)=2 --Borrowed two different books

---------------------------------------------------------------------------
--23. Retrieve the names of borrowers who have borrowed books from
--branches located in New York and have more than 5 books checked out.
----------------------------------------------------------------------------
WITH TotalBorrowed AS  --Store as a new table as having cannot be defined here
(SELECT  tbr.borrower_BorrowerName, 
	tlb.library_branch_BranchAddress,
	COUNT(tbl.book_loans_LoansID) 
		OVER(PARTITION BY tbl.book_loans_BranchID) --window over BranchID for total borrowed
			AS TotalBorrowedBooks

FROM tbl_borrower tbr JOIN tbl_book_loans tbl  --Join tables
ON tbr.borrower_CardNo=tbl.book_loans_CardNo 

JOIN tbl_library_branch tlb
ON tbl.book_loans_BranchID=tlb.library_branch_BranchID

WHERE tlb.library_branch_BranchAddress LIKE '%New York%') --New York libraries

SELECT borrower_BorrowerName, --Display from new table
	library_branch_BranchAddress,
	TotalBorrowedBooks

FROM TotalBorrowed
GROUP BY borrower_BorrowerName,
	library_branch_BranchAddress,
	TotalBorrowedBooks
	HAVING TotalBorrowedBooks>5 --More than 5 checkout
	ORDER BY TotalBorrowedBooks DESC; --Descing Order

--------------------------------------------------------------------
--24. How many copies of "The Lost Tribe" are owned by the "Sharpstown" branch?
---------------------------------------------------------------------
SELECT DISTINCT tb.book_title,  --Distinct Book titles
	tlb.library_branch_BranchName,
	
	SUM(Book_copies_No_Of_Copies)  --total copies of each book
	OVER (PARTITION BY tb.book_title) --window of book title
		AS TotalCopies

FROM tbl_library_branch tlb JOIN tbl_book_loans tbl --join the tables
ON tlb.library_branch_BranchID=tbl.book_loans_BranchID
JOIN tbl_book tb 
ON tbl.book_loans_LoansID= tb.book_BookID
JOIN tbl_book_copies tbc
ON tb.book_BookID=tbc.book_copies_CopiesID

WHERE tlb.library_branch_BranchName='Sharpstown' --library and title conditions
  AND tb.book_title='The Lost Tribe'  

ORDER BY TotalCopies DESC; --descending order

----------------------------------------------------------------------------
--25. How many copies of "The Lost Tribe" are owned by each library branch?
-----------------------------------------------------------------------------

SELECT DISTINCT tb.book_title,  --Distinct Book titles
	tlb.library_branch_BranchName,
	
	SUM(Book_copies_No_Of_Copies)  --total copies of each book
	OVER (PARTITION BY tb.book_title) --window of book title
		AS TotalCopies

FROM tbl_library_branch tlb JOIN tbl_book_loans tbl --join the tables
ON tlb.library_branch_BranchID=tbl.book_loans_BranchID
JOIN tbl_book tb 
ON tbl.book_loans_LoansID= tb.book_BookID
JOIN tbl_book_copies tbc
ON tb.book_BookID=tbc.book_copies_CopiesID

WHERE tb.book_title='The Lost Tribe'  -- title condition

ORDER BY TotalCopies DESC;

--------------------------------------------------------------------------
--26. Retrieve the names of all borrowers who do not have any books checked out.
---------------------------------------------------------------------------
SELECT tbr.borrower_BorrowerName,
	tbl.book_loans_LoansID
FROM tbl_borrower tbr LEFT JOIN tbl_book_loans tbl  --LEFT Join tables to get all the borrowers
ON tbr.borrower_CardNo=tbl.book_loans_CardNo 
WHERE tbl.book_loans_LoansID IS NULL; --borrowers who have no loanID info

---------------------------------------------------------------------------
--27. For each book loaned out from "Sharpstown" whose DueDate is today,
--retrieve the book title, the borrower's name, and the borrower's address.
-----------------------------------
SELECT * 

INTO #DueDateLibrary  --Create Temporary Table

FROM tbl_library_branch tlb JOIN tbl_book_loans tbl --join the tables
ON tlb.library_branch_BranchID=tbl.book_loans_BranchID

JOIN tbl_borrower tbr  --Join tables
ON tbl.book_loans_CardNo = tbr.borrower_CardNo

JOIN tbl_book tb 
ON tbl.book_loans_LoansID= tb.book_BookID


SELECT DISTINCT book_title,
	borrower_BorrowerName,
	borrower_BorrowerAddress,
	library_branch_BranchName,
	book_loans_DueDate

FROM #DueDateLibrary --Use temporary table

WHERE library_branch_BranchName='Sharpstown' --Condition on Library name

GROUP  BY book_title,
	borrower_BorrowerName,
	borrower_BorrowerAddress,
	library_branch_BranchName,
	book_loans_DueDate

HAVING book_loans_DueDate IN 
				(SELECT MAX(book_loans_DueDate)  --Today is considered as MAX(DueDate)
				FROM #DueDateLibrary              --In the Database
				WHERE library_branch_BranchName='Sharpstown') --MAX(DueDate) of Sharpstown

-------------------------------------------------------------------------------
-- 28. For each library branch, retrieve the branch name and the total number 
-- of books loaned out from that branch. 
------------------------------------------------------------------------------
SELECT DISTINCT tlb.library_branch_BranchName,  --Distinct Library Name
		COUNT(tbl.book_loans_LoansID) --Counts of LoanID for TotalLoans
			OVER(PARTITION BY tlb.library_branch_BranchName) --Window over library Name
			AS TotalBooksLoaned

FROM tbl_library_branch tlb JOIN tbl_book_loans tbl --join the tables
ON tlb.library_branch_BranchID=tbl.book_loans_BranchID
ORDER BY TotalBooksLoaned DESC; --Descending Order

---------------------------------------------------------------------------------------