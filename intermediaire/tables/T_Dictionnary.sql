-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Dictionnary'
    )
    DROP EXTERNAL TABLE Dictionnary

-- create external table
CREATE EXTERNAL TABLE Dictionnary
    WITH (
        LOCATION = 'Dictionnary/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
WITH unpvt -- get all answers for all questions
AS
(
    SELECT 
        *
    FROM dbo.Codebook
    UNPIVOT
    (ANSWER FOR answer IN 
        (_1, _2, _3, _4, _5, _6, _7, _99, _0, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22)
    ) AS u
)
SELECT
    ROW_NUMBER() OVER(ORDER BY dico.varnum) AS id_answer,
    *
FROM
    (    
    SELECT DISTINCT
        all_dico.name AS column_name,
        all_dico.varnum,
        -- delete yes no question and replace by multiple choice question:
        -- Exemple Q: have you heard of those help (help1, help2)
        -- In the dictionnary : help1 "YES", help1 "NO", help1 "Not Answered", help2 "YES", help2 "NO", help2 "Not Answered"
        -- Replace by help1, help2
        CASE
            WHEN question_cut <> '' AND question_cut NOT IN ('Variable filtre', 'BLOCS Travaux') AND n_answer <= 3 THEN  
                multiple_question.answer
            ELSE
                all_dico.answer
            END AS answer_char,
        CASE
            WHEN question_cut <> '' AND question_cut NOT IN ('Variable filtre', 'BLOCS Travaux') AND n_answer <= 3 THEN
                multiple_question.name_cut
            ELSE
                all_dico.answer_number
            END AS answer_number,
        CASE
            WHEN question_cut <> '' AND question_cut NOT IN ('Variable filtre', 'BLOCS Travaux') AND n_answer <= 3 THEN
                multiple_question.question_cut
            ELSE
                all_dico.label
            END AS question
    FROM
        (
            -- dictionnary for questions with multiple choices
            SELECT
                varnum,
                name,
                -- take last part of initial column_name for mcq to attribute a number to the answer
                -- exemple : main_Q1_11 -> 11
                Substring(name,LEN(name) - CharIndex('_',REVERSE(name)) + 2,LEN(name)) AS name_cut,
                answer,
                question_cut
            FROM
                (
                    SELECT
                        VARNUM AS varnum,
                        NAME AS name,
                        -- mcq label always have the pattern "question - answer"
                        Substring(LABEL,CharIndex(' - ',LABEL) +  3,LEN(LABEL)) AS answer,
                        Substring(LABEL,0,CharIndex(' - ',LABEL)) COLLATE Latin1_general_CI_AI AS question_cut
                    FROM
                        dbo.Codebook
                ) AS dico
        ) AS multiple_question
        JOIN
        (
            -- dictionnary for all questions every answers
            SELECT 
                NAME AS name,
                VARNUM AS varnum,
                LABEL AS label,
                -- delete the "_" in front of answer number for every question
                -- exemple : _1 -> 1
                REPLACE(answer, '_', '') AS answer_number,
                ANSWER AS answer
            FROM 
                unpvt
        ) AS all_dico
        ON multiple_question.varnum = all_dico.varnum
        JOIN
        (
            -- counting the number of answers in the dictionnary for a question (to remove only y/n/na question)
            SELECT 
                VARNUM AS varnum,
                Count(*) AS n_answer
            FROM 
                unpvt
            GROUP BY
                VARNUM
        ) AS number_answer
        ON multiple_question.varnum = number_answer.varnum
    ) AS dico