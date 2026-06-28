-- Business Question 9: Gender vs claim cost (new test, not covered in Q2)

SELECT
  ce.Gender,
  COUNT(c.Claim_ID) AS total_claims,
  ROUND(AVG(c.Claim_Amount_GHS), 2) AS avg_claim_amount
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
  ON c.Employee_ID = ce.Employee_ID
GROUP BY ce.Gender
ORDER BY avg_claim_amount DESC