## EXECUTIVE SUMMARY
This report focuses on an AB Test. The AB test is used to analyze a new referral program aimed at increasing referrals. The collected result is analyzed using multivariate and cost benefit methodology. Based on the outcome of the analysis, the report develops recommendations and next step for further improvement of the referral program. The following are the recommended solutions:

•	I would recommend stopping the test and roll out the $50 0-day referral program, which will increase the total number of referrals by 68%, increase total revenue by 120%, and boost the profit by 55%. 

•	Increase the frequency of reminder messages sent to the users. Upon increasing the number of promotional messages to users (ex. sending the promo again after 5 days), we could test whether it will increase the volume of referrals. 

•	We could also get real feedback from users who got a quote but eventually did not buy our policy and find out if there are other product and service attributes that require improvement.

## INTRODUCTION
The current referral program offers our customers a cash reward for referring their friends to our company. We typically give both sender and receiver $25 when the receiver gets a quote. Recently, a research revealed that more than half of the respondents said that they got 70% of their customers through referrals. Hence, referral has become an essential part of business growth. Additionally, it is cheaper for our company to pay for referrals than it is for us to advertise on websites like Google and Facebook.

To enhance market positioning, we came up with an idea about a new referral program, which is to increase the $25 incentive to $50. Both sender and receiver will receive $50 if the receiver opens an account in our mobile app within the sender’s 30-day window and then eventually gets a quote. To test if the new referral program will increase referrals, we designed an A/B Testing. As shown below, we have two variations in our AB Test. The first variation is to increase the incentive from $25 to $50. The second variation is to have users receive promotion messages 0 day, 2 days, and 7 days after buying a policy. As the control group, the users never receive the $50 promotion bonus, as shown below.

<img src='image/1. control and variation.png' width="550" height="250">



## Methodology

### Assumption

To guarantee reliability and validity of the AB Test result, this report will operate on the following assumptions.  

•	The sample is randomly and equally selected

•	The external environment is constant and stable during the test (e.x. the economy and competitor)

•	All of the receivers who finally got a quote but did not receive rewards are considered as fraud and are not counted as a referral 

•	Before the test begins, the control and variation groups should be the same

•	There are few outliers in some test groups with many more references than others before the test starts. They have been excluded from the analysis

•	The analysis will assume the average Premium per policy is $600 / 6 months (for revenue estimation)

### Test Flow

<img src='image/Figure 2.Test Flow.png'>

### Metrics
Since the sample size is not equal for each group, using the percentage number will offer a more reliable comparison. For this analysis, I used several metrics to track the performance of the test. Because increasing referrals is our goal, which is defined by the receiver creating an account, the primary metric is the referral rate (hereinafter called ‘Refer%’). To track the whole business flow, I used the Quote rate (hereinafter called ‘Quote%’), Policy rate (hereinafter called ‘Policy%’), Quote%_relative and Policy%_relative in the analysis.

Refer% = Total Account / Total Sender

Quote% = Total Quote / Total Sender

Policy% = Total Policy / Total Sender

Quote%_relative = Total Quote / Total Account

Policy%_relative = Total Policy / Total Quote

### Total Traffic Calculation
To get statistical significance, we need to calculate the minimum sample size. The current Refer% (within 30 days after promo starts) is 18%. I estimated the Minimum Expected Refer% detected is 25%, with a significant level of 5%. The total traffic needed from this test is about 3000, which meets the current total traffic we have tested.


## OVERALL ANALYSIS

### Multivariate Analysis

There are two variables in our test. The first variable is the reward amount ($25 vs. $50). For the reward amount test analysis, I compared the 30-day duration referral performance between the groups with $25 and $50 reward, with the promo test started 0/2/7 days after the sender buys a policy. Here is the result:

<img src='image/table 1.png'>

<img src='image/table 2.png'>

<img src='image/table 3.png'>


For a promotion message that starts immediately after sender buying a policy (0 day), a $50 incentive makes the Refer% significantly increase by 12.5% (absolute increase). Eventually, this massive number of referrals significantly increases the Policy% by 2%. The 2-day and 7-day test both have a better performance than their control group, respectively. Therefore, a $50 incentive has a significant positive effect on referral activity. However, the referral does not significantly increase the Policy%_relative, which means that referred users with higher incentive do not tend to be more likely to buy our policy.

The other variable is promotion start time (0/2/7 days). Because there is no current control group, I compared the three groups horizontally. From the figure below, we can see the 0-day test group outperforms other groups significantly, with the Refer% 31%, 12% Quote%, and 4% Policy%. Therefore, when the promotion starts immediately, it will generate more referrals than others which begins later. 


<img src='image/Figure 3.Promo Begin-Time Test.png' width="300" height="180">

After comparing each variable, respectively, the next analysis examines the combined impact. This approach seeks to identify the group having better performance with combined effect of  promotion reward amount and promo start time. Below is the result: 

<img src='image/table 4.png'>


We can see that only the $50, 0-day test group has a significant increase compared to the control group when it comes to combined impact. This result forms an integral finding that should help the company make a decision on the way forward. At this point, I recommend we could roll out the $50 0-day test group. Policy%_relative does not have significantly directional change. With this result, we can draw a conclusion that increasing the incentive will not increase the receiver’s willingness to buy a policy. Hence, I recommend that we could try to offer the cash reward after receiver buy a policy to see if it will increase policy conversions. Then we can compare the total profit between the $50 0-day group and this new variation group and decide which group has a better performance. Also, we could send questionnaire to the receivers who did not convert despite receiving $50 reward and collect their concerns and issues. 

### Cost & Benefit Analysis
In the analysis, I assumed the average premium to be $600 / 6 months to allow for the ease of calculation of revenue and cost. Because the company is paying more money for each referred quote, we need to a perform cost and benefit analysis to determine how much cash flow it brings and how it performs compared with the control group. Since each group has a different sample size, to make the comparison more accurate and reliable, I use average values for both revenue and cost. From the chart below, we can see that although the $50 0-day group costs us more per referred quote, the average revenue almost doubles,  compared to the control group. Moreover, the average profit earned from the $50 0-day test group is 55% higher than the control group.

<img src='image/Figure 3.Avg. Revenue and Cost.png'>

<img src='image/Figure 5 Avg. Profit.png'>



Then I calculated the ROI for each group, and the result is shown below. Although the ROI goes  down from $2.1 to $0.9, it is worthwhile because the promotion is attracting more customers, which could boost the company’s revenue volumes and market share. Based on these benefits, the total profit increases by 55% (estimated).


<img src='image/Figure 6 Business Growth.png' width="400" height="220">

## RECOMMENDATION

Based on the analysis above, my recommendation is to roll out the $50 0-day referral program, since it will generate more profit and customers, which is essential for our business to grow. Moreover, as the chart shown below, the analysis reveals that over 45% of referrals have been made within five days after receiving the promotion message. The effect of the promotion campaign drops significantly after that and has a small increase towards the end. It shows that the senders are more likely to forget promotion message after five days. Therefore, I recommend that we could send a follow-up promotion email after 5 days to keep them on the knowledge of our promotion. It can be tested by running another AB Test and comparing the referrals between control and variation groups.

In addition, since the analysis has showed that more incentive will not make referred quote have a positive directional change in the final policy-buying process, I recommend to collect feedback from the users to determine if  there are other product and service attributes which need to improve. By doing so, it will also enhance the unique value position.

<img src='image/Figure 7 Referral Distribution.png'>
