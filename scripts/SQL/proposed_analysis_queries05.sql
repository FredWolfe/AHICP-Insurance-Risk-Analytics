-- Question 17 (proposed): Claims behavior by industry

SELECT
  co.Industry,
  COUNT(c.Claim_ID) AS total_claims,
  ROUND(AVG(c.Claim_Amount_GHS), 2) AS avg_claim_amount,
  SUM(c.Claim_Amount_GHS) AS total_claim_amount
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims` c
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
  ON c.Employee_ID = ce.Employee_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
  ON ce.Corporate_ID = cp.Corporate_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.companies` co
  ON cp.Company_ID = co.Company_ID
GROUP BY co.Industry
ORDER BY avg_claim_amount DESC