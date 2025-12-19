# Custom Domain Setup Guide for ThisByte.com

## Overview
This guide will help you set up both `thisbyte.com` and `www.thisbyte.com` to point to your Firebase Hosted website.

**Current Issue:** Your CNAME is pointing to the wrong target. Firebase custom domains require specific DNS records that are generated through the Firebase Console.

---

## Step 1: Add Custom Domain in Firebase Console

1. Open Firebase Console: https://console.firebase.google.com/project/thisbyte-com/hosting/sites
2. Click on "Add custom domain" button
3. Enter: `thisbyte.com` (enter the root domain without www)
4. Click "Continue"

---

## Step 2: Verify Domain Ownership

Firebase will provide a TXT record for verification. It will look like this:

```
Type: TXT
Name: @ (or thisbyte.com, depending on your DNS provider)
Value: [Firebase will provide a unique verification string]
```

### Add this TXT record to your DNS provider:

1. Log in to your domain registrar (GoDaddy, Namecheap, Cloudflare, etc.)
2. Go to DNS settings for thisbyte.com
3. Add a new TXT record with the exact values Firebase provides
4. **Important:** Remove or update your current incorrect CNAME record for www
5. Save the DNS changes

### Wait and Verify:

1. DNS changes can take 5-60 minutes to propagate
2. Return to Firebase Console and click "Verify"
3. If it says "pending", wait a few more minutes and try again

---

## Step 3: Configure Final DNS Records

After verification, Firebase will provide the final DNS records. You'll need to add these to your DNS provider:

### For Root Domain (thisbyte.com):

Firebase will provide A records (IP addresses). They typically look like:

```
Type: A
Name: @ (or leave blank, or thisbyte.com)
Value: 151.101.1.195

Type: A
Name: @ (or leave blank, or thisbyte.com)
Value: 151.101.65.195
```

**Note:** The actual IP addresses will be provided by Firebase. Use those, not these examples.

### For www Subdomain (www.thisbyte.com):

After the root domain is set up, go back to Firebase Console and add www.thisbyte.com as well:

1. Click "Add custom domain" again
2. Enter: `www.thisbyte.com`
3. Firebase will provide a CNAME record like:

```
Type: CNAME
Name: www
Value: [Firebase will provide the target, likely thisbyte.com or a Firebase hostname]
```

---

## Step 4: Apply DNS Changes

1. **Remove** your current CNAME record pointing to `thisbyte-com.web.com`
2. **Add** all the A records for the root domain
3. **Add** the CNAME record for www subdomain
4. Save all changes

---

## Step 5: Wait for Propagation

1. DNS changes can take 5 minutes to 48 hours (usually within 1 hour)
2. Firebase will automatically provision SSL certificates once DNS is connected
3. You can check status in Firebase Console under Hosting

---

## Step 6: Test Your Domain

Once Firebase shows "Connected" status:

1. Visit https://thisbyte.com - should load your site
2. Visit https://www.thisbyte.com - should load your site
3. Firebase will automatically redirect one to the other (you can configure which direction)

---

## Troubleshooting

### "Site Not Found" Error
- DNS hasn't propagated yet - wait longer
- DNS records are incorrect - double-check values from Firebase Console
- CNAME is pointing to wrong target - must use values from Firebase, not .web.app

### "Not Secure" Warning
- SSL certificate is still provisioning - can take 24 hours after DNS connects
- Visit Firebase Console to check SSL status

### DNS Propagation Check
You can check if your DNS has propagated:
```bash
dig thisbyte.com
dig www.thisbyte.com
```

Or use online tools:
- https://dnschecker.org
- https://www.whatsmydns.net

---

## Quick Reference: What to Delete

❌ **DELETE this from your DNS:**
```
Type: CNAME
Name: www
Value: thisbyte-com.web.com  ← WRONG TARGET
```

✅ **REPLACE with records provided by Firebase Console after verification**

---

## Need Help?

If you encounter issues:
1. Double-check all DNS records match exactly what Firebase Console shows
2. Wait at least 1 hour for DNS propagation
3. Check Firebase Console hosting status for error messages
4. Ensure you've completed domain verification (Step 2)

---

**Your temporary Firebase URL will continue to work:** https://thisbyte-com.web.app
