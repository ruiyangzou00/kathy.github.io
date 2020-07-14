USE mmm;
SELECT * from mmm_sales_raw;

SELECT `customer ID`, SUM(sales) AS total
FROM mmm_sales_raw
WHERE LEFT(`ORDER DATE`,7)='2014-01'
GROUP BY `customer ID`
HAVING total > 1000;

/*MMM_Offline_raw*/

SELECT * FROM mmm_offline_raw;
SELECT * FROM mmm_dma_hh;

CREATE TABLE mmm_offline_transformed
SELECT date, ROUND(100*SUM(`TV GRP`/100 * `TOTAL HH`)/SUM(`TOTAL HH`),1) AS `National TV GRP`,
			 ROUND(100*SUM(`Magazine GRP`/100 * `TOTAL HH`)/SUM(`TOTAL HH`),1) AS `National Magazine GRP`
FROM mmm_offline_raw a LEFT JOIN mmm_dma_hh b ON a.DMA=b.`DMA Name`
GROUP BY Date;



/*mmm_dcmdisplay*/
SELECT * FROM mmm_dcmdisplay_2015_raw; 

--  impressions (4 type / 4 columns)
CREATE TABLE mmm_dcmdisplay_transformed
SELECT `date`, 
    SUM(CONVERT(REPLACE(`Served Impressions`,',',''),SIGNED INTEGER)) AS `DisplayImpressions`,
	SUM(IF(`Campaign name` LIKE '%Always-On%', CONVERT(REPLACE(`served impressions`,',',''), signed integer), 0)) AS `Always-On_impressions`,
	SUM(IF(`Campaign name` LIKE '%Website%', CONVERT(REPLACE(`served impressions`,',',''), signed integer), 0)) AS `Website_impressions`,
    SUM(IF(`Campaign name` IN ('Branding Campaign','New Product Launch'), CONVERT(REPLACE(`served impressions`,',',''), signed integer), 0)) AS `brand_prod_impressions`,
    SUM(IF(`Campaign name` IN ('Holiday','July 4th'), CONVERT(REPLACE(`served impressions`,',',''), signed integer), 0)) AS `holiday_impressions`
FROM mmm_dcmdisplay_2015_raw
GROUP BY `date`;


CREATE temporary TABLE mmm_dcmdisplay_transformed_2017
SELECT `date`, 
    SUM(CONVERT(REPLACE(`Served Impressions`,',',''),SIGNED INTEGER)) AS `DisplayImpressions`,
	SUM(IF(`Campaign name` LIKE '%Always-On%', CONVERT(REPLACE(`served impressions`,',',''), signed integer), 0)) AS `Always-On_impressions`,
	SUM(IF(`Campaign name` LIKE '%Website%', CONVERT(REPLACE(`served impressions`,',',''), signed integer), 0)) AS `Website_impressions`,
    SUM(IF(`Campaign name` IN ('Branding Campaign','New Product Launch'), CONVERT(REPLACE(`served impressions`,',',''), signed integer), 0)) AS `brand_prod_impressions`,
    SUM(IF(`Campaign name` IN ('Holiday','July 4th'), CONVERT(REPLACE(`served impressions`,',',''), signed integer), 0)) AS `holiday_impressions`
FROM mmm_dcmdisplay_2017_raw
GROUP BY `date`;


-- OVERLAP 'DATE'
SELECT DISTINCT a.date
FROM mmm_dcmdisplay_2015_raw a JOIN mmm_dcmdisplay_2017_raw b ON a.date=b.date;

--  delete insert --
DELETE a
FROM mmm_dcmdisplay_transformed a JOIN mmm_dcmdisplay_transformed_2017 b ON a.date=b.date;

INSERT INTO mmm_dcmdisplay_transformed
SELECT * 
FROM mmm_dcmdisplay_transformed_2017;


/* VIEW !!! */
CREATE VIEW af AS
SELECT a.week, a.`comp spend`, b.`hasevent`, c.`cci`, d.`total_sales`, e.`National TV GRP`, e.`National Magazine GRP`, f.`displayimpressions`
FROM mmm_comp_media_spend_transformed a 
JOIN mmm_event_transformed b ON a.week=b.week
JOIN mmm_cci_transformed c ON a.week=c.week
JOIN mmm_sales_transformed d ON a.week=d.week
JOIN mmm_offline_transformed e ON a.week=e.date
JOIN mmm_dcmdisplay_transformed f ON a.week=f.date;


SELECT * FROM af;





/*1 Paid Search*/
SELECT * FROM mmm.mmm_adwordssearch_2015_raw;

select distinct campaign_name
FROM mmm_adwordssearch_2015_raw;

CREATE TABLE mmm_adwordssearch_transformed
SELECT b.week, SUM(impressions) AS SearchImpressions, SUM(clicks) AS SearchClicks, 
		SUM(IF(campaign_name LIKE '%Always-On%', clicks, 0)) AS SearchAlwaysOnClicks,
        SUM(IF(campaign_name IN ('Landing Page', 'Retargeting'), clicks, 0)) AS SearchWebsiteClicks,
        SUM(IF(campaign_name IN ('Branding Campaign', 'New Product Launch'), clicks, 0)) AS SearchBrandingClicks
FROM mmm_adwordssearch_2015_raw a JOIN mmm_date_metadata b ON a.date_id=b.day
GROUP BY b.week;


CREATE temporary TABLE mmm_adwordssearch_transformed_temp
SELECT b.week, SUM(impressions) AS SearchImpressions, SUM(clicks) AS SearchClicks, 
		SUM(IF(campaign_name LIKE '%Always-On%', clicks, 0)) AS SearchAlwaysOnClicks,
        SUM(IF(campaign_name IN ('Landing Page', 'Retargeting'), clicks, 0)) AS SearchWebsiteClicks,
        SUM(IF(campaign_name IN ('Branding Campaign', 'New Product Launch'), clicks, 0)) AS SearchBrandingClicks
FROM mmm_adwordssearch_2017_raw a JOIN mmm_date_metadata b ON a.date_id=b.day
GROUP BY b.week;

-- DELETE
DELETE a
FROM mmm_adwordssearch_transformed a JOIN mmm_adwordssearch_transformed_temp b ON a.week=b.week;

-- INSERT
INSERT INTO mmm_adwordssearch_transformed
SELECT * FROM mmm_adwordssearch_transformed_temp;




-- 2 Facebook --
SELECT * FROM mmm.mmm_facebook;

SELECT DISTINCT `Campaign Objective` FROM mmm_facebook_raw;

CREATE TABLE mmm_facebook_transformed
SELECT Period AS week, SUM(ap_total_imps) AS FacebookImpressions, SUM(ap_total_clicks) AS FacebookClicks, SUM(ap_total_clicks)/SUM(ap_total_imps) AS CTR, 
		SUM(IF(`Campaign Objective` IN ('Branding Campaign', 'New Product Launch'), ap_total_imps, 0)) AS FBBrandingImpression,
        SUM(IF(`Campaign Objective` IN ('July 4th', 'Holiday'), ap_total_imps, 0)) AS FBHolidayImpression,
        SUM(IF(`Campaign Objective` IN ('Pride', 'Others'), ap_total_imps, 0)) AS FBOtherImpression
FROM mmm_facebook_raw
GROUP BY week;


-- 3 WECHAT --
SELECT * FROM mmm.mmm_wechat_raw;

CREATE TABLE mmm_wechat_transformed
SELECT Period AS week, 
		SUM(`Article Total Read` + `Account Total Read` + `Moments Total Read`) AS WechatTotalRead,
		SUM(IF(Campaign='New Product Launch', (`Article Total Read` + `Account Total Read` + `Moments Total Read`),0)) AS WechatNewLaunchRead
FROM mmm_wechat_raw
GROUP BY week;




-- 4 VIEW --

ALTER VIEW af AS
SELECT a.week, a.`comp spend`, b.`hasevent`, c.`cci`, d.`total_sales`, e.`National TV GRP`, e.`National Magazine GRP`, f.`displayimpressions`,
		g.SearchImpressions, g.SearchClicks, ROUND(h.CTR, 2) AS CTR, i.WechatTotalRead
FROM mmm_comp_media_spend_transformed a 
JOIN mmm_event_transformed b ON a.week=b.week
JOIN mmm_cci_transformed c ON a.week=c.week
JOIN mmm_sales_transformed d ON a.week=d.week
JOIN mmm_offline_transformed e ON a.week=e.date
JOIN mmm_dcmdisplay_transformed f ON a.week=f.date
JOIN mmm_adwordssearch_transformed g ON a.week=g.week
JOIN mmm_facebook_transformed h ON a.week=h.week
JOIN mmm_wechat_transformed i ON a.week=i.week
;


SELECT * FROM af;
