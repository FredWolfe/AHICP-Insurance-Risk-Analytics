-- Question 15 (proposed): Claim cost by employee tenure (branch-level Application_Date as proxy)

WITH employee_tenure AS (
  SELECT
    ce.Employee_ID,
    cp.Application_Date,
    c.Claim_Date,
    c.Claim_Amount_GHS,
    DATE_DIFF(
      PARSE_DATE('%Y-%m-%d', c.Claim_Date),
      PARSE_DATE('%Y-%m-%d', cp.Application_Date),
      DAY
    ) AS days_since_application
  FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
    ON c.Employee_ID = ce.Employee_ID
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
    ON ce.Corporate_ID = cp.Corporate_ID
)
SELECT
  CASE
    WHEN days_since_application < 180 THEN 'Under 6 months'
    WHEN days_since_application < 365 THEN '6-12 months'
    WHEN days_since_application < 730 THEN '1-2 years'
    ELSE '2+ years'
  END AS tenure_bucket,
  COUNT(*) AS claim_count,
  ROUND(AVG(Claim_Amount_GHS), 2) AS avg_claim_amount
FROM employee_tenure
GROUP BY tenure_bucket
ORDER BY MIN(days_since_application) ASC