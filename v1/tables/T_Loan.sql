-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Loan'
    )
    DROP EXTERNAL TABLE Loan

-- create external table
CREATE EXTERNAL TABLE Loan
    WITH (
        LOCATION = 'Loan/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
WITH All_loan
AS
(
    SELECT Distinct
        Respondent_Serial AS id_owner,
        main_Q74_1 AS eco_loan,
        main_Q74_2 AS bank,
        main_Q74_3 AS consumption,
        main_Q74_4 AS other,
        main_Q75 AS amount,
        main_Q76 AS rate,
        main_q77 AS duration
    FROM
        dbo.Tremi 
    WHERE
        -- has taken a loan and has responded
        Tremi.main_Q74_5 <> 1 AND
        Tremi.main_q74_6 <> 1
)
SELECT id_owner, loan_name, amount, rate, duration
FROM 
   (SELECT id_owner, eco_loan, bank, consumption, other, amount, rate, duration
    FROM All_loan) l
UNPIVOT
   (loan_answer FOR loan_name IN 
      (eco_loan, bank, consumption, other)
)AS unpvt
WHERE
    -- select only taken loans
    loan_answer = 1

