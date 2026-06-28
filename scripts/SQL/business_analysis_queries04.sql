-- Business Question 5: Which employees generate claims exceeding their share of company premium?
-- Query without adding the Company Names --

WITH employee_claims AS (
  SELECT
    ce.Employee_ID,
    ce.Corporate_ID,
    SUM(c.Claim_Amount_GHS) AS total_claims
  FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
    ON c.Employee_ID = ce.Employee_ID
  GROUP BY ce.Employee_ID, ce.Corporate_ID
),
company_premium_share AS (
  SELECT
    cp.Company_ID,
    SUM(pp.Amount_GHS) / COUNT(DISTINCT ce.Employee_ID) AS premium_per_employee
  FROM `akwaaba-insurance-500201.akwaaba_insurance.premium_payments` pp
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
    ON pp.Corporate_ID = cp.Corporate_ID
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
    ON ce.Corporate_ID = cp.Corporate_ID
  GROUP BY cp.Company_ID
)
SELECT
  ec.Employee_ID,
  ec.total_claims,
  cps.premium_per_employee,
  ROUND(ec.total_claims - cps.premium_per_employee, 2) AS excess_over_premium_share
FROM employee_claims ec
JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
  ON ec.Corporate_ID = cp.Corporate_ID
JOIN company_premium_share cps
  ON cp.Company_ID = cps.Company_ID
ORDER BY excess_over_premium_share DESC
LIMIT 20;


-- Business Question 5: Which employees generate claims exceeding their share of company premium? (with company name)
-- Query with Company Names --

WITH employee_claims AS (
  SELECT
    ce.Employee_ID,
    ce.Corporate_ID,
    SUM(c.Claim_Amount_GHS) AS total_claims
  FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
    ON c.Employee_ID = ce.Employee_ID
  GROUP BY ce.Employee_ID, ce.Corporate_ID
),
company_premium_share AS (
  SELECT
    cp.Company_ID,
    SUM(pp.Amount_GHS) / COUNT(DISTINCT ce.Employee_ID) AS premium_per_employee
  FROM `akwaaba-insurance-500201.akwaaba_insurance.premium_payments` pp
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
    ON pp.Corporate_ID = cp.Corporate_ID
  JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
    ON ce.Corporate_ID = cp.Corporate_ID
  GROUP BY cp.Company_ID
)
SELECT
  ec.Employee_ID,
  co.Company_Name,
  ec.total_claims,
  cps.premium_per_employee,
  ROUND(ec.total_claims - cps.premium_per_employee, 2) AS excess_over_premium_share
FROM employee_claims ec
JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
  ON ec.Corporate_ID = cp.Corporate_ID
JOIN company_premium_share cps
  ON cp.Company_ID = cps.Company_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.companies` co
  ON cp.Company_ID = co.Company_ID
ORDER BY excess_over_premium_share DESC
LIMIT 20