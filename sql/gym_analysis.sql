-- ============================================================
-- GYM MEMBERSHIP RETENTION & CHURN INTELLIGENCE
-- SQL ANALYSIS
-- Database: MySQL
-- ============================================================


-- ============================================================
-- 1. DATABASE TABLES
-- ============================================================

-- Expected tables:
-- members
-- memberships
-- attendance
-- payments


-- ============================================================
-- 2. MEMBER OVERVIEW
-- ============================================================

SELECT
    COUNT(*) AS total_members
FROM members;


-- Active vs Churned Members

SELECT
    Current_Status,
    COUNT(*) AS member_count
FROM members
GROUP BY Current_Status
ORDER BY member_count DESC;


-- Members by Gender

SELECT
    Gender,
    COUNT(*) AS member_count
FROM members
GROUP BY Gender
ORDER BY member_count DESC;


-- Members by City

SELECT
    City,
    COUNT(*) AS member_count
FROM members
GROUP BY City
ORDER BY member_count DESC;


-- Members by Fitness Goal

SELECT
    Fitness_Goal,
    COUNT(*) AS member_count
FROM members
GROUP BY Fitness_Goal
ORDER BY member_count DESC;


-- ============================================================
-- 3. MEMBERSHIP ANALYSIS
-- ============================================================

-- Memberships by Plan

SELECT
    Plan,
    COUNT(*) AS membership_count
FROM memberships
GROUP BY Plan
ORDER BY membership_count DESC;


-- Membership Revenue by Plan

SELECT
    Plan,
    COUNT(*) AS membership_count,
    SUM(Final_Price) AS total_revenue,
    AVG(Final_Price) AS average_membership_price
FROM memberships
GROUP BY Plan
ORDER BY total_revenue DESC;


-- Membership Duration Analysis

SELECT
    Duration_Months,
    COUNT(*) AS membership_count,
    SUM(Final_Price) AS total_revenue
FROM memberships
GROUP BY Duration_Months
ORDER BY Duration_Months;


-- Average Discount by Plan

SELECT
    Plan,
    ROUND(AVG(Discount_Pct), 2) AS average_discount_percentage
FROM memberships
GROUP BY Plan
ORDER BY average_discount_percentage DESC;


-- ============================================================
-- 4. REVENUE ANALYSIS
-- ============================================================

-- Total Membership Revenue

SELECT
    ROUND(SUM(Final_Price), 2) AS total_membership_revenue
FROM memberships;


-- Revenue by Month

SELECT
    DATE_FORMAT(Start_Date, '%Y-%m') AS membership_month,
    ROUND(SUM(Final_Price), 2) AS monthly_revenue
FROM memberships
GROUP BY DATE_FORMAT(Start_Date, '%Y-%m')
ORDER BY membership_month;


-- Revenue by Payment Method

SELECT
    Payment_Method,
    COUNT(*) AS payment_count,
    ROUND(SUM(Amount), 2) AS total_amount
FROM payments
GROUP BY Payment_Method
ORDER BY total_amount DESC;


-- Payment Status Analysis

SELECT
    Payment_Status,
    COUNT(*) AS payment_count,
    ROUND(SUM(Amount), 2) AS total_amount
FROM payments
GROUP BY Payment_Status
ORDER BY total_amount DESC;


-- ============================================================
-- 5. ATTENDANCE ANALYSIS
-- ============================================================

-- Total Gym Visits

SELECT
    COUNT(*) AS total_visits
FROM attendance;


-- Visits by Workout Type

SELECT
    Workout_Type,
    COUNT(*) AS total_visits
FROM attendance
GROUP BY Workout_Type
ORDER BY total_visits DESC;


-- Average Workout Duration

SELECT
    ROUND(AVG(Workout_Duration), 2) AS average_workout_duration
FROM attendance;


-- Average Workout Duration by Workout Type

SELECT
    Workout_Type,
    COUNT(*) AS total_visits,
    ROUND(AVG(Workout_Duration), 2) AS average_duration
FROM attendance
GROUP BY Workout_Type
ORDER BY average_duration DESC;


-- Visits by Member

SELECT
    Member_ID,
    COUNT(*) AS total_visits
FROM attendance
GROUP BY Member_ID
ORDER BY total_visits DESC;


-- ============================================================
-- 6. MEMBER ENGAGEMENT
-- ============================================================

-- Member Attendance with Member Details

SELECT
    m.Member_ID,
    m.Gender,
    m.Age,
    m.City,
    m.Fitness_Goal,
    m.Current_Status,
    COUNT(a.Attendance_ID) AS total_visits,
    ROUND(AVG(a.Workout_Duration), 2) AS average_workout_duration
FROM members m
LEFT JOIN attendance a
    ON m.Member_ID = a.Member_ID
GROUP BY
    m.Member_ID,
    m.Gender,
    m.Age,
    m.City,
    m.Fitness_Goal,
    m.Current_Status
ORDER BY total_visits DESC;


-- ============================================================
-- 7. ACTIVE VS CHURNED ENGAGEMENT
-- ============================================================

SELECT
    m.Current_Status,
    COUNT(DISTINCT m.Member_ID) AS total_members,
    COUNT(a.Attendance_ID) AS total_visits,
    ROUND(
        COUNT(a.Attendance_ID) /
        NULLIF(COUNT(DISTINCT m.Member_ID), 0),
        2
    ) AS average_visits_per_member
FROM members m
LEFT JOIN attendance a
    ON m.Member_ID = a.Member_ID
GROUP BY m.Current_Status
ORDER BY average_visits_per_member DESC;


-- ============================================================
-- 8. MEMBERSHIP RETENTION
-- ============================================================

-- Members with Multiple Memberships

SELECT
    Member_ID,
    COUNT(*) AS membership_count
FROM memberships
GROUP BY Member_ID
HAVING COUNT(*) > 1
ORDER BY membership_count DESC;


-- Membership Count Distribution

SELECT
    Membership_Count,
    COUNT(*) AS member_count
FROM members
GROUP BY Membership_Count
ORDER BY Membership_Count;


-- Members with Multiple Memberships and Their Status

SELECT
    m.Member_ID,
    m.Current_Status,
    m.Membership_Count,
    COUNT(ms.Membership_ID) AS actual_membership_records
FROM members m
LEFT JOIN memberships ms
    ON m.Member_ID = ms.Member_ID
GROUP BY
    m.Member_ID,
    m.Current_Status,
    m.Membership_Count
HAVING COUNT(ms.Membership_ID) > 1
ORDER BY actual_membership_records DESC;


-- ============================================================
-- 9. CHURN ANALYSIS
-- ============================================================

-- Churn Rate

SELECT
    ROUND(
        100.0 *
        SUM(CASE
            WHEN Current_Status = 'Churned' THEN 1
            ELSE 0
        END)
        / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM members;


-- Churned Members by Fitness Goal

SELECT
    Fitness_Goal,
    COUNT(*) AS churned_members
FROM members
WHERE Current_Status = 'Churned'
GROUP BY Fitness_Goal
ORDER BY churned_members DESC;


-- Churned Members by City

SELECT
    City,
    COUNT(*) AS churned_members
FROM members
WHERE Current_Status = 'Churned'
GROUP BY City
ORDER BY churned_members DESC;


-- Churned Members by Lead Source

SELECT
    Lead_Source,
    COUNT(*) AS churned_members
FROM members
WHERE Current_Status = 'Churned'
GROUP BY Lead_Source
ORDER BY churned_members DESC;


-- ============================================================
-- 10. CHURN AND ATTENDANCE
-- ============================================================

SELECT
    m.Current_Status,
    COUNT(DISTINCT m.Member_ID) AS members,
    COUNT(a.Attendance_ID) AS total_visits,
    ROUND(AVG(a.Workout_Duration), 2) AS average_workout_duration
FROM members m
LEFT JOIN attendance a
    ON m.Member_ID = a.Member_ID
GROUP BY m.Current_Status
ORDER BY m.Current_Status;


-- ============================================================
-- 11. HIGH RISK MEMBER ANALYSIS
-- ============================================================

-- Churned or Low Engagement Members

SELECT
    m.Member_ID,
    m.Age,
    m.City,
    m.Fitness_Goal,
    m.Current_Status,
    COUNT(a.Attendance_ID) AS total_visits
FROM members m
LEFT JOIN attendance a
    ON m.Member_ID = a.Member_ID
GROUP BY
    m.Member_ID,
    m.Age,
    m.City,
    m.Fitness_Goal,
    m.Current_Status
HAVING
    m.Current_Status = 'Churned'
    OR COUNT(a.Attendance_ID) <= 5
ORDER BY total_visits;


-- ============================================================
-- 12. MEMBER REVENUE ANALYSIS
-- ============================================================

SELECT
    m.Member_ID,
    m.Current_Status,
    COUNT(ms.Membership_ID) AS memberships,
    ROUND(SUM(ms.Final_Price), 2) AS total_membership_value
FROM members m
LEFT JOIN memberships ms
    ON m.Member_ID = ms.Member_ID
GROUP BY
    m.Member_ID,
    m.Current_Status
ORDER BY total_membership_value DESC;


-- ============================================================
-- 13. COMPLETE MEMBER ANALYTICS VIEW
-- ============================================================

SELECT
    m.Member_ID,
    m.Gender,
    m.Age,
    m.City,
    m.Occupation,
    m.Fitness_Goal,
    m.Lead_Source,
    m.Current_Status,
    m.Membership_Count,
    COUNT(DISTINCT ms.Membership_ID) AS actual_memberships,
    ROUND(COALESCE(SUM(ms.Final_Price), 0), 2) AS total_membership_value,
    COUNT(DISTINCT a.Attendance_ID) AS total_visits,
    ROUND(COALESCE(AVG(a.Workout_Duration), 0), 2) AS avg_workout_duration,
    COUNT(DISTINCT p.Payment_ID) AS payment_count,
    ROUND(COALESCE(SUM(p.Amount), 0), 2) AS total_paid
FROM members m
LEFT JOIN memberships ms
    ON m.Member_ID = ms.Member_ID
LEFT JOIN attendance a
    ON m.Member_ID = a.Member_ID
LEFT JOIN payments p
    ON m.Member_ID = p.Member_ID
GROUP BY
    m.Member_ID,
    m.Gender,
    m.Age,
    m.City,
    m.Occupation,
    m.Fitness_Goal,
    m.Lead_Source,
    m.Current_Status,
    m.Membership_Count
ORDER BY total_membership_value DESC;


-- ============================================================
-- END OF SQL ANALYSIS
-- ============================================================
