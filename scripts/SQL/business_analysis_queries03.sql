-- Business Question 4: Are premium payments sufficient to cover claim expenses across organizations?

WITH premiums AS (
  SELECT
    cp.Company_ID,
    SUM(pp.Amount_GHS) AS total_premiums
  FROM `akwaaba-insurance-500201.akwaaba_insurance.premium_payments` pp
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
    ON pp.Corporate_ID = cp.Corporate_ID
  GROUP BY cp.Company_ID
),
claims_total AS (
  SELECT
    cp.Company_ID,
    SUM(c.Claim_Amount_GHS) AS total_claims
  FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
    ON c.Employee_ID = ce.Employee_ID
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
    ON ce.Corporate_ID = cp.Corporate_ID
  GROUP BY cp.Company_ID
)
SELECT
  co.Company_Name,
  p.total_premiums,
  ct.total_claims,
  ROUND(p.total_premiums - ct.total_claims, 2) AS net_position,
  ROUND(ct.total_claims / p.total_premiums, 2) AS claim_to_premium_ratio
FROM premiums p
JOIN claims_total ct ON p.Company_ID = ct.Company_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.companies` co ON p.Company_ID = co.Company_ID
ORDER BY claim_to_premium_ratio DESC