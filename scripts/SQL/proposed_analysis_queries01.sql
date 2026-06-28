-- Question 13 (proposed): Month-over-month claim-to-premium ratio, company-wide

WITH monthly_premiums AS (
  SELECT
    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y-%m-%d', Payment_Date)) AS month,
    SUM(Amount_GHS) AS total_premiums
  FROM `akwaaba-insurance-500201.akwaaba_insurance.premium_payments`
  GROUP BY month
),
monthly_claims AS (
  SELECT
    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y-%m-%d', Claim_Date)) AS month,
    SUM(Claim_Amount_GHS) AS total_claims
  FROM `akwaaba-insurance-500201.akwaaba_insurance.claims`
  GROUP BY month
)
SELECT
  mp.month,
  mp.total_premiums,
  mc.total_claims,
  ROUND(mc.total_claims / mp.total_premiums, 2) AS claim_to_premium_ratio
FROM monthly_premiums mp
JOIN monthly_claims mc ON mp.month = mc.month
ORDER BY mp.month ASC