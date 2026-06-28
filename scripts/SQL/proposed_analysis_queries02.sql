-- Question 14 (proposed): Claim frequency by calendar month (seasonality check)

SELECT
  FORMAT_DATE('%m', PARSE_DATE('%Y-%m-%d', Claim_Date)) AS month_number,
  COUNT(*) AS claim_count,
  ROUND(AVG(Claim_Amount_GHS), 2) AS avg_claim_amount
FROM `akwaaba-insurance-500201.akwaaba_insurance.claims`
GROUP BY month_number
ORDER BY month_number ASC