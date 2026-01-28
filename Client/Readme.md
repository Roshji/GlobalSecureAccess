# Global Secure Access Installation Scripts

# Registry Configuration Summary

This section outlines the registry keys configured by the script. These settings adjust Windows security behavior, Kerberos timeout handling, and DNS policies for Microsoft Edge and Google Chrome.

---

## 🔐 Global Secure Access Client

**Path:**  
`HKLM:\SOFTWARE\Microsoft\Global Secure Access Client`

### **RestrictNonPrivilegedUsers** (DWORD)
Controls whether non‑privileged users are restricted from accessing Global Secure Access Client features.

---

## 🔑 Kerberos Timeout Adjustment

**Path:**  
`HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters`

### **FarKdcTimeout** (DWORD = `0`)
Disables fallback timeout behavior when attempting to contact a Key Distribution Center (KDC).

---

## 🌐 Microsoft Edge DNS Configuration

**Path:**  
`HKLM:\SOFTWARE\Policies\Microsoft\Edge`

### **DnsOverHttpsMode** (String = `off`)
Disables DNS‑over‑HTTPS (DoH) for Microsoft Edge.

### **BuiltInDnsClientEnabled** (DWORD)
Enables or disables the built‑in DNS client in Edge.  
Value is provided via the script variable: **`$disableBuiltInDNS`**.

---

## 🌐 Google Chrome DNS Configuration

**Path:**  
`HKLM:\SOFTWARE\Policies\Google\Chrome`

### **DnsOverHttpsMode** (String = `off`)
Disables DNS‑over‑HTTPS (DoH) for Google Chrome.

### **BuiltInDnsClientEnabled** (DWORD)
Enables or disables Chrome’s built‑in DNS client.  
Value is provided via **`$disableBuiltInDNS`**.

---

