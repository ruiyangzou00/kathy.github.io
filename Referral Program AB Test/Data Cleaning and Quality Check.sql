#--------------------------------------------------------------- IMPORT DATA FILE --------------------------------------------------------------------------
USE root;

# Create  referral_promo_participants table
CREATE TABLE referral_promo_participants (
	user_id VARCHAR(50) PRIMARY KEY, 
    bucket VARCHAR(6), 
	bucket_timestamp VARCHAR(50)
);

# Create promo_referrals table
CREATE TABLE promo_referrals (
	sender_user_id VARCHAR(50),
    receiver_account TINYINT(1),
    receiver_account_timestamp VARCHAR(25),
    receiver_quote TINYINT(1) DEFAULT NULL,
	receiver_quote_timestamp VARCHAR(25) DEFAULT NULL,
    receiver_policy TINYINT(1) DEFAULT NULL,
    receiver_policy_timestamp VARCHAR(25) DEFAULT NULL,
    sender_earned_amount_in_dollars INT(2) DEFAULT NULL,
    receiver_earned_amount_in_dollars INT(2) DEFAULT NULL
);

# Find the path to store csv file
SHOW VARIABLES LIKE "secure_file_priv";

# load 'referral_promo_participants.csv'
LOAD DATA INFILE 
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/referral_promo_participants.csv'
INTO TABLE root.referral_promo_participants
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

# load 'promo_referrals.csv'
LOAD DATA INFILE 
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/promo_referrals.csv'
INTO TABLE root.promo_referrals
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

# Change the data type to timestamp
UPDATE referral_promo_participants SET bucket_timestamp=STR_TO_DATE(bucket_timestamp, "%m/%d/%Y %h:%i:%s %p");
UPDATE promo_referrals SET receiver_account_timestamp=STR_TO_DATE(receiver_account_timestamp, "%m/%d/%Y %h:%i:%s %p");
UPDATE promo_referrals SET receiver_quote_timestamp=STR_TO_DATE(receiver_quote_timestamp, "%m/%d/%Y %h:%i:%s %p");
UPDATE promo_referrals SET receiver_policy_timestamp=STR_TO_DATE(receiver_policy_timestamp, "%m/%d/%Y %h:%i:%s %p");

# Data Quality Check
# Check the total sample / traffic
SELECT bucket, COUNT(*) 
FROM referral_promo_participants
GROUP BY 1;

# Duration of Promo test - the bucket time (2018-02-09 to 2018-05-08)
SELECT MAX(bucket_timestamp), MIN(bucket_timestamp)
from referral_promo_participants;
# ACTION! Tease out users who haven't received our Promo Test email

# Check the time users open their account after get referrals
SELECT MAX(receiver_account_timestamp), min(receiver_account_timestamp)
from promo_referrals;

# Create JOINED table (which is the combined table joined by the two raw tables)
CREATE TABLE joined_promo_test_transformed
SELECT user_id,bucket, bucket_timestamp, receiver_account,receiver_account_timestamp,receiver_quote, receiver_quote_timestamp, 
	receiver_policy, receiver_policy_timestamp, sender_earned_amount_in_dollars, receiver_earned_amount_in_dollars,
	DATE_ADD(a.bucket_timestamp, INTERVAL (CASE WHEN bucket ='0hr' THEN 0 WHEN bucket='48hr' THEN 2 WHEN bucket = '168hr' THEN 7 ELSE Null END) DAY) AS `start`,
 	DATE_ADD(a.bucket_timestamp, INTERVAL (CASE WHEN bucket ='0hr' THEN 30 WHEN bucket='48hr' THEN 32 WHEN bucket = '168hr' THEN 37 ELSE Null END) DAY) AS `end` 
FROM referral_promo_participants a LEFT JOIN promo_referrals b ON a.user_id=b.sender_user_id;


#--------------------------------------------------------------- DEAL WITH OUTLIERS --------------------------------------------------------------------------
# Tease out records for which the Promo have not started yet but has been included in Variation groups (112)rows
DELETE FROM joined_promo_test_transformed
WHERE `start`>'2018-05-08 14:15:00';

# Check the distribution of traffic which are still whithin the promo test (1000+ rows) - evenly distributed (don't drop)
SELECT bucket, COUNT(*) 
FROM root.joined_promo_test_transformed
WHERE  bucket <> 'off' AND (('2018-05-08 14:15:00' BETWEEN `start` AND `end`) OR receiver_account IS NULL)
GROUP BY buckeT
UNION
SELECT bucket, COUNT(*)
FROM root.joined_promo_test_transformed
WHERE bucket = 'off' 
AND (receiver_account IS NULL OR ('2018-05-08 14:15:00' BETWEEN bucket_timestamp AND DATE_ADD(bucket_timestamp, INTERVAL 30 DAY)))
GROUP BY bucket;


# Fraud Detection (I assume we identify the receivers as fraud who did not receive cash rewards but have create account within 30 days window and finally got a quote) (5 rows)
DELETE FROM joined_promo_test_transformed
WHERE receiver_quote=1 AND receiver_policy<>1 AND ( receiver_earned_amount_in_dollars IS NULL AND  sender_earned_amount_in_dollars IS NULL);


# AA Test: The referral% should be the same before the Promo Test starts
# 0hr-control and variation group: Check the control & variation group differences before test
WITH cte AS (
    SELECT * FROM root.joined_promo_test_transformed
    WHERE bucket IN ('off', '0hr') AND (receiver_account IS NULL OR (receiver_account_timestamp < bucket_timestamp ))
    )
SELECT bucket, 
    COUNT(DISTINCT user_id) AS sender,
    SUM(CASE WHEN receiver_account = 1 THEN 1 ELSE 0 END) AS account, 
    SUM(CASE WHEN receiver_quote = 1 THEN 1 ELSE 0 END) AS quote,
    SUM(CASE WHEN receiver_policy = 1 THEN 1 ELSE 0 END) AS policy
FROM cte
GROUP BY bucket;
# Notes: there are the difference between the control group and variation group even before the test

# Find the outliers in the samples
WITH cte AS (
    SELECT * FROM root.joined_promo_test_transformed
    WHERE bucket IN ('off', '0hr') AND (receiver_account IS NULL OR (receiver_account_timestamp < bucket_timestamp ))
    )
SELECT user_id, COUNT(*), bucket FROM cte GROUP BY user_id order by COUNT(*) DESC;

# There are three receivers should have been identified as outliers
DELETE FROM root.joined_promo_test_transformed
WHERE user_id IN ('3de76c3d-453d-4cf0-ad43-a59e6804299e','ad2989a0-dda7-425c-b722-3082569e2844','bfd82ec4-73ec-494e-8c44-c8f2b3cc92e3','5a6e3c3f-aca2-42d8-91f0-cdcf958b7fbd');


# Same process for 48hr - control and test groups
WITH cte AS (
    SELECT * 
    FROM root.joined_promo_test_transformed
    WHERE bucket IN ('off', '48hr') 
    AND (receiver_account IS NULL 
    OR (
        receiver_account_timestamp < DATE_ADD(bucket_timestamp, INTERVAL 2 DAY) )
        )
    )
# There are 3 outliers
-- SELECT user_id, COUNT(*), bucket FROM cte GROUP BY user_id order by COUNT(*) DESC;
SELECT bucket, 
    COUNT(DISTINCT user_id) AS sender,
    SUM(CASE WHEN receiver_account = 1 THEN 1 ELSE 0 END) AS account, 
    SUM(CASE WHEN receiver_quote = 1 THEN 1 ELSE 0 END) AS quote,
    SUM(CASE WHEN receiver_policy = 1 THEN 1 ELSE 0 END) AS policy
FROM cte
-- WHERE user_id NOT IN ('89532f35-c603-4e96-b3c6-f9c739d9ef4c','c94a3cbf-9570-480c-9a66-aab8fb81ddf5','6095fba7-bbe9-4a46-8a1a-d73d80496872')
GROUP BY bucket;


# Same process for 168hr - control and variation groups
# Find outliers
WITH cte AS (
    SELECT * 
    FROM root.joined_promo_test_transformed
    WHERE bucket IN ('off', '168hr') 
    AND (receiver_account IS NULL OR (receiver_account_timestamp < DATE_ADD(bucket_timestamp, INTERVAL 7 DAY) ))
    )
SELECT user_id, COUNT(*), bucket FROM cte GROUP BY user_id ORDER BY COUNT(*) DESC;

# Check the difference after teasing out outliers
WITH cte AS (
    SELECT * 
    FROM root.joined_promo_test_transformed
    WHERE bucket IN ('off', '168hr') 
    AND (receiver_account IS NULL OR (receiver_account_timestamp < DATE_ADD(bucket_timestamp, INTERVAL 7 DAY) ))
    )
SELECT bucket, 
    COUNT(DISTINCT user_id) AS sender,
    SUM(CASE WHEN receiver_account = 1 THEN 1 ELSE 0 END) AS account, 
    SUM(CASE WHEN receiver_quote = 1 THEN 1 ELSE 0 END) AS quote,
    SUM(CASE WHEN receiver_policy = 1 THEN 1 ELSE 0 END) AS policy
FROM cte
WHERE user_id NOT IN ('e19587e5-49f6-4bae-b5b1-7a2a4676e96b')
GROUP BY bucket;



# Delete all the records which are outliers
DELETE FROM joined_promo_test_transformed
WHERE user_id IN ('3de76c3d-453d-4cf0-ad43-a59e6804299e',
'ad2989a0-dda7-425c-b722-3082569e2844','bfd82ec4-73ec-494e-8c44-c8f2b3cc92e3','5a6e3c3f-aca2-42d8-91f0-cdcf958b7fbd',
'89532f35-c603-4e96-b3c6-f9c739d9ef4c','c94a3cbf-9570-480c-9a66-aab8fb81ddf5','6095fba7-bbe9-4a46-8a1a-d73d80496872',
'e19587e5-49f6-4bae-b5b1-7a2a4676e96b');




# Data is clean and ready to use.
# Please see the rest of code in Python...
