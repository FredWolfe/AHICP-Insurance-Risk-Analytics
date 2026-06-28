-- Business Question 7 (Part 1): Branch profitability — premiums vs claims

WITH branch_premiums AS (
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
  br.Branch_ID,
  br.Region,
  co.Company_Name,
  bp.total_premiums,
  bc.total_claims,
  ROUND(bp.total_premiums - bc.total_claims, 2) AS net_position
FROM branch_premiums bp
JOIN branch_claims bc ON bp.Branch_ID = bc.Branch_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.branches` br ON bp.Branch_ID = br.Branch_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.companies` co ON br.Company_ID = co.Company_ID
ORDER BY net_position DESC;



-- Business Question 7 (Part 2): Customer retention by branch — policy status
SELECT
  br.Branch_ID,
  br.Region,
  co.Company_Name,
  pt.Policy_Status
FROM `akwaaba-insurance-500201.akwaaba_insurance.policy_table` pt
JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
  ON pt.Corporate_ID = cp.Corporate_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.branches` br
  ON cp.Branch_ID = br.Branch_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.companies` co
  ON br.Company_ID = co.Company_ID
ORDER BY pt.Policy_Status, br.Branch_ID;


-- Business Question 7 (Part 3): Operational efficiency — avg review & payout time by branch
SELECT
  br.Branch_ID,
  br.Region,
  co.Company_Name,
  COUNT(cw.Workflow_ID) AS workflow_count,
  ROUND(AVG(DATE_DIFF(PARSE_DATE('%Y-%m-%d',cw.Reviewed_Date), PARSE_DATE('%Y-%m-%d',cw.Submitted_Date), DAY)), 1) AS avg_review_days,
  ROUND(AVG(DATE_DIFF(PARSE_DATE('%Y-%m-%d',cw.Payout_Date), PARSE_DATE('%Y-%m-%d',cw.Reviewed_Date), DAY)), 1) AS avg_payout_delay_days
FROM `akwaaba-insurance-500201.akwaaba_insurance.claim_workflow` cw
JOIN `akwaaba-insurance-500201.akwaaba_insurance.claims` c
  ON cw.Claim_ID = c.Claim_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.covered_employees` ce
  ON c.Employee_ID = ce.Employee_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.corporate_policies` cp
  ON ce.Corporate_ID = cp.Corporate_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.branches` br
  ON cp.Branch_ID = br.Branch_ID
JOIN `akwaaba-insurance-500201.akwaaba_insurance.companies` co
  ON br.Company_ID = co.Company_ID
GROUP BY br.Branch_ID, br.Region, co.Company_Name
ORDER BY workflow_count DESC