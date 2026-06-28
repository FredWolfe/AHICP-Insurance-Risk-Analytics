-- Business Question 3: Which corporate organizations generate the highest financial exposure?

SELECT
  co.Company_Name,
  COUNT(c.Claim_ID) AS total_claims,
  SUM(c.Claim_Amount_GHS) AS total_claim_amount
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
  ON c.Employee_ID = ce.Employee_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
  ON ce.Corporate_ID = cp.Corporate_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.companies` co
  ON cp.Company_ID = co.Company_ID
GROUP BY co.Company_Name
ORDER BY total_claim_amount DESC;


-- Business Question 3 (follow-up): Financial exposure per employee, to control for company size

SELECT
  co.Company_Name,
  COUNT(DISTINCT ce.Employee_ID) AS total_employees,
  COUNT(c.Claim_ID) AS total_claims,
  SUM(c.Claim_Amount_GHS) AS total_claim_amount,
  ROUND(SUM(c.Claim_Amount_GHS) / COUNT(DISTINCT ce.Employee_ID), 2) AS claim_amount_per_employee
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
  ON c.Employee_ID = ce.Employee_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
  ON ce.Corporate_ID = cp.Corporate_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.companies` co
  ON cp.Company_ID = co.Company_ID
GROUP BY co.Company_Name
ORDER BY claim_amount_per_employee DESC