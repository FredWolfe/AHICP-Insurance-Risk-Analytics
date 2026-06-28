-- Business Question 11: Claims processing bottlenecks — overall and by claim type

SELECT
  c.Claim_Type,
  COUNT(cw.Workflow_ID) AS workflow_count,
  ROUND(AVG(DATE_DIFF(
    PARSE_DATE('%Y-%m-%d', cw.Reviewed_Date),
    PARSE_DATE('%Y-%m-%d', cw.Submitted_Date),
    DAY
  )), 1) AS avg_review_days,
  ROUND(AVG(DATE_DIFF(
    PARSE_DATE('%Y-%m-%d', cw.Payout_Date),
    PARSE_DATE('%Y-%m-%d', cw.Reviewed_Date),
    DAY
  )), 1) AS avg_payout_delay_days
FROM `akwaaba-insurance-500201.akwaaba_insurance.claim_workflow` cw
JOIN `akwaaba-insurance-500201.akwaaba_insurance.claims` c
  ON cw.Claim_ID = c.Claim_ID
GROUP BY c.Claim_Type
ORDER BY avg_review_days DESC