## H&M A/B Testing Project

H&M is a multinational fast fashion company who emphasis on high fashion at prices significantly below those of competitors, being 'Fashion and quality at the best price'. H&M deals in fashioned apparels, shoes, dress, tops, pants and skirts

<img src='image/HM Poster.png'>

Recently, the product analyst team decided to make some UX changes on product page. For example, they wanted to test whether the product details located at the bottom of the page may be distracting users from clicking Add-to-Cart buttom. Therefore, they came up with ideas of moving the product details to various location, such as right below the Add-to-Cart buttom or making the image smaller and moving up the details a bit. After discussion with product manager and engineers, they designed an A/B Testing (hereinafter called 'Test 1') with two variation groups and a control group as shown below.

<img src='image/UI design.png'>

But they did not realize there was another test (hereinafter called 'Test 3') ran on the same page by another group until they ended the test. There is the timeline of the two tests. From the picture below, we can see that both test started at April 12, 2019. Test 1 ended at May 21, 2019, while Test 3 ended earlier at May 10, 2019. 

<img src='image/Timeline.png'>

After the meeting with the other team, they figured out the content of Test 3, which is to add a free shipping banner right above the Add-To-Cart buttom. They assumed this change will remind users to realize the shipping fee in advance and consider adding more products on the cart before checkout. Here is the design of Test 3.

<img src='image/UI test 3 design.png'>

### Executive Summary
* Test 1 performs better when it comes to specific users like customers acquired by email and returning users. Suggest rolling out variation 1.

* Returning users react better on test 3. Suggest rolling out Test 3 on returning users and test the effect when moving the banner to checkout page.

### Traffic Flow
<img src='image/Traffic flow chart.png'>
From the image above, we can see the users will finish the flow before they finally place an order.
* Land on the product page to have more information of the item they choose
* Add the items to cart if they intend to buy them
* Forward to checkout page and fill all the information to place an order
* Click place-order buttom and convert

(Users may leave without any actions on the page on the product or cart page)

### Metrics
For this analysis, I used the following metics to track the performance of the test.
* Primary Metrics: ATCR (Add-To-Cart Rate) and Rev (Average revenue for each order)
* Secondary Metrics: BR (Bounce Rate), C/O (Checkout Rate), CVR (Conversion Rate)
<img src='image/Metrics.png'>

### Overall Analysis - Session Level

<img src='image/Overall Analysis.png'>

I suggest to rolling out Variation 1 of Test 1. From the table above, we can see the Variation 1 of Test 1 have a better performance, the ATCR has a significant increase of 0.35%. Alhough there is a decrease on the average revenue, I see it as users actually read the product details and they tend to place an order more carefully. There is fewer impulse spending for each session. I see it a good sign that our customers have more information of our product. I expect it will generate a higher revenue in the future and have the brand awareness increase.


Variation 2 underperforms than Variation 1 with negative changes in metrics of BR (+11.4%), ATCR (-11.5%) and CVR (-1.19%). Therefore, I think it is not a good idea to move the product details by sacrificing the size of product image. 

As for Test 3, we can see the primary metrics like ATCR and revenue are falling. But there is an improvement on BR and C/O, which makes sense because the free shipping banner make users aware of potential shipping fee for small order in advance, making them add more items on cart and have a less abandon rate for unexpected shipping fee when checkout.

### Test 1 Deep Dive
#### Cut by Visitor Type
There are four different type of visitors, which are new users, email acquired visitors, sign up with no purchase, and users with purchase history. I caluclate the performance for each type of visitor. Below is the result.

<img src='image/test1 cut by visitor type.png'>

From the table above, I suggest rolling out variation 1 except for users with purchase history since there is no directional negative effect on metrics of these groups. And users who have purchase history have a decline on C/O because they may be discouraged for the higher value of cart. Therefore, I suggestion for the next step is to launch another test on this group. For example, we can perform user research by sending emails to useres who did not checkout and ask them the reason. 

#### Cut by Category
I performed deep dive to see how users who bought different kinds of categories react to our new changes. Here is the result:
<img src='image/test1 cut by category.png'>
I found out that products like pants and shoes have the ATCR increase since these kind of categories need more size information than others for users to make sure they fit. And for the next step, I suggestion is that we can perform clustering analysis to apply this pattern and to see if any other categories or users have the same pattern.

### Test 3 Deep Dive
#### Cut by Visitor Type










*******************************************************************************************************************************8

You can use the [editor on GitHub](https://github.com/ruiyangzou00/kathy.github.io/edit/master/README.md) to maintain and preview the content for your website in Markdown files.

Whenever you commit to this repository, GitHub Pages will run [Jekyll](https://jekyllrb.com/) to rebuild the pages in your site, from the content in your Markdown files.

### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List 

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/ruiyangzou00/kathy.github.io/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://help.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
