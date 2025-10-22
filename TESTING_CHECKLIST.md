# NXOLand Website Testing Checklist

## 📋 Complete Page-by-Page Testing Guide

**Date:** _______________  
**Tester:** _______________  
**Browser:** _______________  
**Device:** _______________

---

## 🏠 **PUBLIC PAGES**

### ✅ Home Page (/)
- Browse by Platform : it should show our added platforms in website "Social Accounts, Gaming Accounts"
- the prodcut square is too big make it smaller "implement this for all product view".
- add to cart doesn't work "make sure it works well everywhere in website".
- our platform social accounts down in footer remove them and keep only Discord "https://discord.gg/Jk3zxyDb".
in arabic version of my website some emojies are taking the text color fix it like "تصفح حسب المنصة 🖥️". "حسابات مميزة 🌟".

**Notes:** _______________________________________________

---

### ✅ Products Page (/products)
- filters button doesn't work and there is no way to implement filtering.
- all products tab should show only our platform product i added.
- list view buttons doesn't work.

**Notes:** _______________________________________________

---

### ✅ Product Detail Page (/products/:id)
- add to cart button not work.
- add to favorate button not work.
- share button not work.

**Notes:** _______________________________________________

---

### ✅ Cart Page (/cart)
- delete button doesn't work.
- apply button doesn't work.
- remove increase and decrease buttons our platform support 1 product sell only. 

**Notes:** _______________________________________________

---

### ✅ Checkout Page (/checkout)
- we will use https://www.tap.company/en-sa as our payment so implement  it as sandbox for now for testing.
- expiry date example : 01/25 this is the correct formation. 
- I agree to the Terms of Service, Refund Policy, and understand that all sales are final once the product is delivered. is mandatory and add a red * to it.
- complete purchase button doesn't work.

**Notes:** _______________________________________________

---

### ✅ Pricing Page (/pricing)
- upgrade now button doesn't work.
- make sure user can upgrade well for example if use have pro plan and  he want to upgrade to elite there should be a proper calculation system to deducte the diffrence depending on days of subscription etc.. make it proper.
 

**Notes:** _______________________________________________

---

### ✅ About Page (/about)
- no issues.

**Notes:** _______________________________________________

---

### ✅ Help/FAQ Page (/help)
- remove email support and live chat only support way is via Discord.
- Getting Started not working.
- Orders & Delivery not working.
- Payments & Refunds not working.
- Account Management not working.
- Security & Privacy not working.
- Seller Tools not working.

**Notes:** _______________________________________________

---

### ✅ Privacy Policy (/privacy)
- Contact Us : should be via discord only.

**Notes:** _______________________________________________

---

### ✅ Terms of Service (/terms)
- Contact Us : should be via discord only.

**Notes:** _______________________________________________

---

## 🔐 **AUTHENTICATION PAGES**

### ✅ Login Page (/login)
- continue with phone number is not working , also add it to register page also so user can log in or register via phone number also user should be able to login using username as well not only email.
- forget password not working.
- mark all fields as required with a red *.
- make sure "remember me" is working as it suppose to work.

**Notes:** _______________________________________________

---

### ✅ Register Page (/register)
- mark all fields as required with a red * even the I agree to the Terms of Service and Privacy Policy.


**Notes:** _______________________________________________

---

## 👤 **ACCOUNT PAGES** (Requires Login)

### ✅ Account Dashboard (/account/dashboard)
- make sure the message "Identity Verification Required" is only shows to unverified users.
- lock View Analytics only supsciped Elite plan users can access it.

**Notes:** _______________________________________________

---

### ✅ Profile Page (/account/profile)
- uploaded picture is not beign saved and implemented correctly.
- once user registered he cannot change username ever!.
- add country code and flag for phone number as we did with kyc.
- enable 2FA not working.
- change password not working also make sure if user wants to change password he should get a verification code via phone.


**Notes:** _______________________________________________

---

### ✅ Orders Page (/account/orders)
- All Orders, Completed, Pending are not working.
- remove download button we do not offer any downloadable products.
- View Details, Contact Seller, Leave Review, Track Order not working.


**Notes:** _______________________________________________

---

### ✅ Order Detail Page (/account/orders/:id)
- i don't have an order to check this page.

**Notes:** _______________________________________________

---

### ✅ Wishlist Page (/account/wishlist)
- the page loads a 404
Oops! Page not found

Return to Home

**Notes:** _______________________________________________

---

### ✅ Billing Page (/account/billing)
- check Cancel Subscription button for issues.
- add Card not working.
- Delete Payment Method is not working.
- Set as Default not working.
- Download not working.
- View All not working.


**Notes:** _______________________________________________

---

### ✅ Wallet Page (/account/wallet)
- Add Funds, Withdraw not working.
- Deposit, Request Payout, Withdraw not working.
- View All not working.
**Notes:** _______________________________________________

---

### ✅ Notifications Page (/account/notifications)
- Mark All as Read not working.
- Notification Preferences : make sure all of them work as it suppose to.

**Notes:** _______________________________________________

---

### ✅ KYC Verification Page (/account/kyc)
- make sure once use complete the verification that it is saved and he doesn't have to do it or see it again even if he log out and in.

**Notes:** _______________________________________________

---

## 🏪 **SELLER PAGES** (Requires Login + Seller Role)

### ✅ Seller Dashboard (/seller/dashboard)
- create a product is not working it should send user to "/seller/onboarding".
- View All buttons are not working.
- make sure this only accessable to elite users, any premium chart or benifit is only to elite.


**Notes:** _______________________________________________

---

### ✅ Seller Products Page (/seller/products)
- View, Edit, Delete are not working.
- lucide lucide-ellipsis-vertical is not working.
- All Products, Active, Draft not working.
- for delete option show a confirmation pop out before actually deleting.
- create a product is sending to /seller/products/create this page should be deleted, it should send to "/seller/onboarding".
- search product is not working "make sure every search option in my website is working 100%.
**Notes:** _______________________________________________

---

### ✅ Create Product Page (/seller/create-product)
this page is showing a user profile is it correct ?

**Notes:** _______________________________________________

---

### ✅ Edit Product Page (/seller/products/:id/edit)
- i could not access this page.

**Notes:** _______________________________________________

---

### ✅ Seller Orders Page (/seller/orders)
why there is a duplication on both account/dashboard and seller/dashboard.
seller dashboard should only have the premium things for users with elite plan.
**Notes:** _______________________________________________

---

### ✅ Seller Billing Page (/seller/billing)
why there is a duplication on both account/dashboard and seller/dashboard.
seller dashboard should only have the premium things for users with elite plan.

**Notes:** _______________________________________________

---

### ✅ Seller Profile Page (/seller/profile)
why there is a duplication on both account/dashboard and seller/dashboard.
seller dashboard should only have the premium things for users with elite plan.

**Notes:** _______________________________________________

---

### ✅ List Gaming Account (/seller/list-gaming-account)
this page is showing a user profile is it correct ?

**Notes:** _______________________________________________

---

### ✅ List Social Account (/seller/list-social-account)
this page is showing a user profile is it correct ?

**Notes:** _______________________________________________

---

## ⚖️ **DISPUTES PAGES**

### ✅ Disputes List (/disputes)
this page loads the header twice i see two headers not one!.
View Order should direct to the order which is the dispute about.



**Notes:** _______________________________________________

---

### ✅ Create Dispute (/disputes/create)
Select Files not working.
i tried creating a dispute but after creation its not showing in /dispute

**Notes:** _______________________________________________

---

### ✅ Dispute Detail (/disputes/:id)
Send Message not working.
Escalate to Admin not working.

**Notes:** _______________________________________________

---

## 🔧 **ADMIN PAGES** (Requires Admin Role)

### ✅ Admin Disputes (/admin/disputes)
404
Oops! Page not found

Return to Home

**Notes:** _______________________________________________

---

## 🌐 **GLOBAL FEATURES**

### ✅ Navigation Bar
- search bar not working
- Cart icon shows count but might not be accurate.
**Notes:** _______________________________________________

---

### ✅ Footer
- all good.

**Notes:** _______________________________________________

---

### ✅ Language Switching (EN ↔ AR)
not all texts is translated.

**Notes:** _______________________________________________

---

### ✅ Notifications/Toasts
- okay.

**Notes:** _______________________________________________

---

### ✅ Loading States
- okay

**Notes:** _______________________________________________

---

### ✅ Error Handling
- okay.

**Notes:** _______________________________________________

---

### ✅ Security Features
- check if its implemented correctly.


**Notes:** _______________________________________________

---

### ✅ Google Analytics
-check if its implemented correctly.


**Notes:** _______________________________________________

---

## 📱 **RESPONSIVE DESIGN**

### ✅ Desktop (1920x1080)
- okay.

**Notes:** _______________________________________________

---

### ✅ Laptop (1366x768)
- i didn't check yet.

**Notes:** _______________________________________________

---

### ✅ Tablet (768x1024)
- i didn't check yet.

**Notes:** _______________________________________________

---

### ✅ Mobile (375x667)
- i didn't check yet.

**Notes:** _______________________________________________

---

## 🌐 **BROWSER COMPATIBILITY**

### ✅ Chrome
- i didn't check yet.

**Notes:** _______________________________________________

---

### ✅ Firefox
- i didn't check yet.

**Notes:** _______________________________________________

---

### ✅ Safari
- i didn't check yet.

**Notes:** _______________________________________________

---

### ✅ Edge
- i didn't check yet.

**Notes:** _______________________________________________

---

## 🐛 **BUGS FOUND**

| Page | Issue Description | Severity | Status |
|------|------------------|----------|--------|
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |

---

## ✅ **OVERALL SUMMARY**

**Total Pages Tested:** ______ / 50+  
**Pages Passed:** ______  
**Pages Failed:** ______  
**Critical Issues:** ______  
**Minor Issues:** ______  

**Overall Status:** [ ] PASS [ ] FAIL [ ] NEEDS WORK

---

## 📝 **ADDITIONAL NOTES**

____________________________________________________________________________

____________________________________________________________________________

____________________________________________________________________________

____________________________________________________________________________

---

**Tested By:** _______________  
**Date Completed:** _______________  
**Sign-off:** _______________
