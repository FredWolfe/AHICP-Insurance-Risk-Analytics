-- Business Question 10 (supporting check): Premium payment reliability by status

SELECT
  Payment_Status,
  COUNT(*) AS payment_count,
  SUM(Amount_GHS) AS total_amount
FROM `akwaaba-insurance-500201.akwaaba_insurance.premium_payments`
GROUP BY Payment_Status
ORDER BY total_amount DESC