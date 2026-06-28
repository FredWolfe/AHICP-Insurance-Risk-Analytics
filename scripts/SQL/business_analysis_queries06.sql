-- Business Question 8 (Part 1): Claim frequency outliers — employees with abnormally many claims

SELECT
  Employee_ID,
  COUNT(*) AS claim_count
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims`
GROUP BY Employee_ID
ORDER BY claim_count DESC
LIMIT 20;

-- Business Question 8 (Part 2): Claim amount outliers — claims far above average for their type
WITH type_avg AS (
  SELECT
    Claim_Type,
    AVG(Claim_Amount_GHS) AS avg_amount_for_type
  FROM `akwaaba-insurance-500201.akwaaba_insurance.claims`
  GROUP BY Claim_Type
)
SELECT
  c.Claim_ID,
  c.Employee_ID,
  c.Claim_Type,
  c.Claim_Amount_GHS,
  ROUND(t.avg_amount_for_type, 2) AS avg_amount_for_type,
  ROUND(c.Claim_Amount_GHS / t.avg_amount_for_type, 2) AS times_above_average
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
JOIN type_avg t ON c.Claim_Type = t.Claim_Type
ORDER BY times_above_average DESC
LIMIT 20;


-- Business Question 8 (Part 3): Rapid-fire claims — same employee, claims close together in time
WITH ordered_claims AS (
  SELECT
    Employee_ID,
    Claim_ID,
    PARSE_DATE('%Y-%m-%d',Claim_Date) AS Claim_Date,
    LAG(PARSE_DATE('%Y-%m-%d',Claim_Date)) OVER (PARTITION BY Employee_ID ORDER BY PARSE_DATE('%Y-%m-%d',Claim_Date)) AS previous_claim_date
  FROM `akwaaba-insurance-500201.akwaaba_insurance.claims`
)
SELECT
  Employee_ID,
  Claim_ID,
  Claim_Date,
  previous_claim_date,
  DATE_DIFF(Claim_Date, previous_claim_date, DAY) AS days_since_last_claim
FROM ordered_claims
WHERE previous_claim_date IS NOT NULL
ORDER BY days_since_last_claim ASC
LIMIT 20;


-- Business Question 8 (Part 4): Approved claims with no workflow record
SELECT
  c.Claim_ID,
  c.Employee_ID,
  c.Claim_Type,
  c.Claim_Amount_GHS,
  c.Claim_Status,
  cw.Workflow_ID
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
LEFT JOIN `akwaaba-insurance-500201.akwaaba_insurance.claim_workflow` cw
  ON c.Claim_ID = cw.Claim_ID
WHERE c.Claim_Status = 'Approved'
  AND cw.Workflow_ID IS NULL
ORDER BY c.Claim_Amount_GHS DESC
LIMIT 20


