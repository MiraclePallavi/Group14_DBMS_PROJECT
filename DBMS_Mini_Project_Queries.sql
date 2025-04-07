-- QUERIES

-- 1. Retrieve the top 5 highest-scoring students in a subject
SELECT S.Name, R.Score 
FROM Results R 
JOIN Students S ON R.StudentID = S.StudentID 
WHERE R.ExamID = 101 
ORDER BY R.Score DESC 
LIMIT 5;

-- 2. Find students who failed an exam (assuming pass mark is 40)
SELECT S.Name, R.Score, E.Subject 
FROM Results R 
JOIN Students S ON R.StudentID = S.StudentID 
JOIN Exams E ON R.ExamID = E.ExamID 
WHERE R.Score < 40;

-- 3. Calculate the average marks for each exam
SELECT E.Subject, AVG(R.Score) AS Average_Score 
FROM Results R 
JOIN Exams E ON R.ExamID = E.ExamID 
GROUP BY R.ExamID;

-- 4. Get the number of students enrolled in a specific course
SELECT Course, COUNT(*) AS Total_Students 
FROM Students 
WHERE Course = 'Computer Science' 
GROUP BY Course;

-- 5. List students who scored above 90 in any exam
SELECT DISTINCT S.Name, R.Score 
FROM Results R 
JOIN Students S ON R.StudentID = S.StudentID 
WHERE R.Score > 90;

-- 6. Identify students who improved their scores the most between two exams (assuming top 5)
-- This assumes each student appeared for both exams (e.g., 101 and 102)
SELECT S.Name, (R2.Score - R1.Score) AS Improvement 
FROM Results R1 
JOIN Results R2 ON R1.StudentID = R2.StudentID 
JOIN Students S ON R1.StudentID = S.StudentID 
WHERE R1.ExamID = 101 AND R2.ExamID = 102 
ORDER BY Improvement DESC 
LIMIT 5;

-- 7. Retrieve the exam with the lowest average score
SELECT E.Subject, AVG(R.Score) AS Average_Score 
FROM Results R 
JOIN Exams E ON R.ExamID = E.ExamID 
GROUP BY R.ExamID 
ORDER BY Average_Score ASC 
LIMIT 1;

-- 8. Find the pass percentage for each exam
SELECT 
  E.Subject, 
  100.0 * SUM(CASE WHEN R.Score >= 40 THEN 1 ELSE 0 END) / COUNT(*) AS Pass_Percentage 
FROM Results R 
JOIN Exams E ON R.ExamID = E.ExamID 
GROUP BY R.ExamID;

-- 9. List students who appeared in all exams
SELECT S.Name 
FROM Students S 
JOIN Results R ON S.StudentID = R.StudentID 
GROUP BY S.StudentID 
HAVING COUNT(DISTINCT R.ExamID) = (SELECT COUNT(*) FROM Exams);

-- 10. Identify the most difficult subject based on failure rate
SELECT E.Subject, 
       100.0 * SUM(CASE WHEN R.Score < 40 THEN 1 ELSE 0 END) / COUNT(*) AS Failure_Rate 
FROM Results R 
JOIN Exams E ON R.ExamID = E.ExamID 
GROUP BY E.ExamID 
ORDER BY Failure_Rate DESC 
LIMIT 1;