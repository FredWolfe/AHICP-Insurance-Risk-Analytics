-- Business Question 2: What factors contribute most to increased healthcare claim costs? --

--Factor 1: Smoker Status --
SELECT
ce.Smoker,
COUNT(c.Claim_ID) AS total_claims,
ROUND(AVG(c.Claim_Amount_GHS), 2) As avg_claim_amount,
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
ON  c.Employee_ID = ce. Employee_ID
GROUP BY ce.Smoker;

--Factor 2: Age --
SELECT
  ce.Age,
  COUNT(c.Claim_ID) AS total_claims,
  ROUND(AVG(c.Claim_Amount_GHS), 2) As avg_claim_amount,
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
  ON  c.Employee_ID = ce. Employee_ID
GROUP BY ce.Age
ORDER BY avg_claim_amount DESC;

-- Factor 3: Dependents --
SELECT
  ce.Dependents,
  COUNT(c.Claim_ID) AS total_claims,
  ROUND(AVG(c.Claim_Amount_GHS), 2) As avg_claim_amount,
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
  ON  c.Employee_ID = ce. Employee_ID
GROUP BY ce.Dependents
ORDER BY avg_claim_amount DESC;


-- Factor 4: Claim Type
SELECT
  Claim_Type,
  COUNT(Claim_ID) AS total_claims,
  ROUND(AVG(Claim_Amount_GHS), 2) AS avg_claim_amount
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims`
GROUP BY Claim_Type
ORDER BY avg_claim_amount DESC;


-- Factor 5: Monthly Salary
SELECT
  CASE 
    WHEN Monthly_Salary_GHS < 10000 THEN "Under 10K"
    WHEN Monthly_Salary_GHS < 15000 THEN "10K-15K"
    WHEN Monthly_Salary_GHS < 20000 THEN "15K-20K"
    ELSE "20K+"
  END AS salary_range,
  COUNT(c.Claim_ID) AS total_claims,
  ROUND(AVG(c.Claim_Amount_GHS), 2) AS avg_claim_amount
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
  ON c.Employee_ID = ce.Employee_ID
GROUP BY salary_range
ORDER BY avg_claim_amount DESC;


-- Factor 6: Occupation
SELECT
  Occupation,
  COUNT(c.Claim_ID) AS total_claims,
  ROUND(AVG(c.Claim_Amount_GHS), 2) AS avg_claim_amount
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
  ON c.Employee_ID = ce.Employee_ID
GROUP BY Occupation
ORDER BY avg_claim_amount DESC;


-- Factor 7: Claim Status
SELECT
  Claim_Status,
  COUNT(Claim_ID) AS total_claims,
  ROUND(AVG(Claim_Amount_GHS), 2) AS avg_claim_amount
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims`
GROUP BY Claim_Status
ORDER BY avg_claim_amount DESC
