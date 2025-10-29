# 🚀 Render MCP Server Setup Guide

**Date:** October 28, 2025  
**Status:** Configuration file created ✅

---

## ✅ **WHAT'S ALREADY DONE:**

1. ✅ MCP configuration file created at `C:\Users\p5l\.cursor\mcp.json`
2. ✅ Render server URL configured
3. ✅ Authorization header added

---

## 🔍 **VERIFICATION CHECKLIST**

### **1. Verify API Key Format** ⚠️ IMPORTANT

The token in your config (`rnd_iE9BOGeZPkWLODLjLPL7ZskBR0Uj`) should be:

- ✅ **Render API Key** (starts with `rnd_` and is 32+ characters)
- ✅ Created from Render Dashboard → Account Settings → API Keys
- ❌ NOT a service-specific token
- ❌ NOT an OAuth token

**To verify/regenerate:**
1. Go to: https://dashboard.render.com/account/api-keys
2. Check if the key `rnd_iE9BOGeZPkWLODLjLPL7ZskBR0Uj` exists
3. If not, create a new API key and update `mcp.json`

---

### **2. Restart Cursor** 🔄 REQUIRED

**After creating/editing `mcp.json`, you MUST:**

1. **Close Cursor completely**
   - File → Exit (or close all windows)
   - Don't just reload window

2. **Reopen Cursor**
   - The MCP server connection is established on startup

3. **Verify Connection**
   - Look for MCP connection status in Cursor
   - Check for any error messages in Cursor's output/console

---

### **3. Check MCP Server Status**

After restarting Cursor:

1. **Open Cursor Settings/Preferences**
   - Look for "MCP Servers" or "Extensions" section

2. **Check Console/Output**
   - View → Output → Look for "MCP" or "Render" messages
   - Should see: "Render MCP Server connected" or similar

3. **Test MCP Functions**
   - Try asking Cursor to list Render services
   - Example: "Show me my Render services"

---

### **4. Required Permissions**

Your Render API key needs permissions to:

- ✅ Read services (web services, databases, etc.)
- ✅ Create services
- ✅ Update environment variables
- ✅ Read logs and metrics
- ✅ Access your Render account

**Note:** The API key inherits permissions from your Render account role.

---

## 📋 **CONFIGURATION FILE LOCATION**

**Current config:** `C:\Users\p5l\.cursor\mcp.json`

```json
{
  "mcpServers": {
    "render": {
      "url": "https://mcp.render.com/mcp",
      "headers": {
        "Authorization": "Bearer rnd_iE9BOGeZPkWLODLjLPL7ZskBR0Uj"
      }
    }
  }
}
```

---

## ✅ **SETUP VERIFICATION STEPS**

### **Step 1: Verify API Key**

```bash
# Test API key with curl (optional)
curl -H "Authorization: Bearer rnd_iE9BOGeZPkWLODLjLPL7ZskBR0Uj" \
     https://api.render.com/v1/services

# Should return your services (JSON response)
# If you get 401 Unauthorized, the key is invalid
```

### **Step 2: Restart Cursor**

1. Close all Cursor windows
2. Reopen Cursor
3. Wait for initialization

### **Step 3: Test MCP Connection**

In Cursor, try these commands:
- "List my Render services"
- "Show Render database details"
- "What Render services do I have?"

If MCP is working, Cursor should be able to query Render and provide information.

---

## 🚨 **TROUBLESHOOTING**

### **Problem: MCP Server Not Connecting**

**Solutions:**
1. ✅ Verify API key is correct and active
2. ✅ Check API key hasn't expired (Render API keys don't expire, but can be revoked)
3. ✅ Ensure Cursor was fully restarted
4. ✅ Check Cursor console for error messages
5. ✅ Verify JSON syntax in `mcp.json` is valid

### **Problem: "Unauthorized" or "401"**

**Solutions:**
1. Regenerate API key from Render Dashboard
2. Update `mcp.json` with new key
3. Restart Cursor

### **Problem: MCP Functions Not Available**

**Solutions:**
1. Check Cursor MCP feature is enabled
2. Verify configuration file is in correct location
3. Ensure no typos in configuration
4. Check Cursor version supports MCP

---

## 📊 **RENDER MCP CAPABILITIES**

Once connected, you can use Cursor to:

### **✅ Supported Operations:**
- 📊 List all services (web services, databases, static sites)
- 🔍 Get service details
- 📈 View metrics and logs
- 🔧 Update environment variables
- ➕ Create new services:
  - Web services
  - Static sites
  - Postgres databases
  - Key Value stores
- 📋 List deployments
- 📥 Query databases (read-only)

### **❌ Not Yet Supported:**
- 🚫 Modify service settings (except env vars)
- 🚫 Delete services
- 🚫 Trigger manual deploys
- 🚫 Scale services
- 🚫 Modify other operational settings

---

## 🎯 **FINAL CHECKLIST**

Before using Render MCP, ensure:

- [x] ✅ `mcp.json` file created at correct location
- [ ] ⏳ API key is valid Render API key (verify in dashboard)
- [ ] ⏳ Cursor fully restarted after config creation
- [ ] ⏳ MCP connection status verified in Cursor
- [ ] ⏳ Test query works (e.g., "list my Render services")

---

## 🔐 **SECURITY NOTES**

1. **Protect Your API Key**
   - Never commit `mcp.json` to Git
   - Add to `.gitignore` if needed
   - Store key securely

2. **Rotate Keys Regularly**
   - Generate new API keys periodically
   - Revoke old keys
   - Update `mcp.json` accordingly

3. **File Permissions**
   - Keep `mcp.json` readable only by you
   - On Linux/Mac: `chmod 600 ~/.cursor/mcp.json`

---

## 📞 **NEXT STEPS**

1. **Verify API Key:**
   - Go to: https://dashboard.render.com/account/api-keys
   - Confirm your key exists and is active

2. **Restart Cursor:**
   - Close completely
   - Reopen
   - Wait for MCP connection

3. **Test Connection:**
   - Try: "List my Render services"
   - Should get response from Render MCP

4. **Start Using:**
   - Ask Cursor to manage Render resources
   - View logs, metrics, create services
   - Update environment variables

---

## 🎉 **YOU'RE READY!**

Once you've:
- ✅ Verified the API key
- ✅ Restarted Cursor
- ✅ Confirmed MCP connection

**You can now manage your Render infrastructure directly from Cursor!** 🚀

---

**For more info:** https://render.com/docs/mcp-server

