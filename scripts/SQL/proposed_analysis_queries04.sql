-- Question 16 (proposed), Step 1: Headcount gap per branch
SELECT
  cp.Branch_ID,
  cp.Estimated_Headcount,
  COUNT(ce.Employee_ID) AS actual_enrolled,
  cp.Estimated_Headcount - COUNT(ce.Employee_ID) AS headcount_gap
FROM `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
  ON cp.Corporate_ID = ce.Corporate_ID
GROUP BY cp.Branch_ID, cp.Estimated_Headcount
ORDER BY headcount_gap DESC;


-- Question 16 (proposed), Step 2: Headcount gap vs. branch profitability
WITH headcount_gap AS (
  SELECT
    cp.Branch_ID,
    cp.Estimated_Headcount,
    COUNT(ce.Employee_ID) AS actual_enrolled,
    cp.Estimated_Headcount - COUNT(ce.Employee_ID) AS gap
  FROM `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
    ON cp.Corporate_ID = ce.Corporate_ID
  GROUP BY cp.Branch_ID, cp.Estimated_Headcount
),
branch_premiums AS (
  SELECT
    cp.Branch_ID,
    SUM(pp.Amount_GHS) AS total_premiums
  FROM `akwaaba-insurance-500201.akwaaba_insurance.premium_payments` pp
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
    ON pp.Corporate_ID = cp.Corporate_ID
  GROUP BY cp.Branch_ID
),
branch_claims AS (
  SELECT
    cp.Branch_ID,
    SUM(c.Claim_Amount_GHS) AS total_claims
  FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
    ON c.Employee_ID = ce.Employee_ID
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
    ON ce.Corporate_ID = cp.Corporate_ID
  GROUP BY cp.Branch_ID
)
SELECT
  hg.Branch_ID,
  hg.gap AS headcount_gap,
  ROUND(bp.total_premiums - bc.total_claims, 2) AS net_position
FROM headcount_gap hg
JOIN branch_premiums bp ON hg.Branch_ID = bp.Branch_ID
JOIN branch_claims bc ON hg.Branch_ID = bc.Branch_ID
ORDER BY hg.gap DESC