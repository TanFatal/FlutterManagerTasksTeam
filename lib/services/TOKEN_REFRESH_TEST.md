# Token Refresh Fix - Test Instructions

## 🔧 **Vấn đề đã fix:**

### **Nguyên nhân lỗi 401 không tự động refresh:**
1. **Infinite Loop**: ApiService sử dụng cùng `dio` instance có interceptor để gọi refresh token
2. **Interceptor Conflict**: Khi refresh API trả về 401, interceptor lại bắt và tạo loop
3. **Missing Logs**: Không có logging để debug token refresh process

### **Giải pháp đã áp dụng:**
1. **Separate Dio Instance**: Tạo `refreshDio` riêng KHÔNG có interceptor
2. **Enhanced Logging**: Thêm logs chi tiết cho từng bước
3. **Proper Error Handling**: Clear tokens khi refresh fail

## 🧪 **Cách test fix:**

### **1. Test Token Refresh Flow:**
```
1. Đăng nhập app → Lấy access token
2. Đợi token expire hoặc manually invalidate
3. Gọi bất kỳ API nào → Trigger 401
4. Xem logs để verify refresh process
```

### **2. Expected Logs khi 401:**
```
[log] DIO ERROR: [error message]
[log] 401 ERROR DETECTED - Attempting token refresh
[log] Calling refresh token API with token: abc123...
[log] ✅ Token refresh successful! New token saved.
[log] 🔄 Retrying original request with new token...
[log] ✅ Original request successful after token refresh!
```

### **3. Expected Logs khi refresh fail:**
```
[log] DIO ERROR: [error message]
[log] 401 ERROR DETECTED - Attempting token refresh
[log] Calling refresh token API with token: abc123...
[log] ❌ REFRESH TOKEN FAILED: [error details]
[log] 🔐 Tokens cleared - user needs to login again
```

## 🔍 **Debug Commands:**

### **Check current tokens:**
```dart
final accessToken = await StorageService.getAccessToken();
final refreshToken = await StorageService.getRefreshToken();
print('Access Token: ${accessToken?.substring(0, 10)}...');
print('Refresh Token: ${refreshToken?.substring(0, 10)}...');
```

### **Manual token clear (for testing):**
```dart
await StorageService.clearTokens();
print('Tokens cleared - next API call should require login');
```

## 📱 **Test Scenarios:**

### **Scenario 1: Valid Refresh Token**
1. Login successfully
2. Wait for access token to expire
3. Make API call (e.g., get projects)
4. Should see refresh logs and successful retry

### **Scenario 2: Invalid Refresh Token**
1. Login successfully  
2. Manually corrupt refresh token in storage
3. Make API call
4. Should see refresh fail logs and token clear

### **Scenario 3: No Refresh Token**
1. Clear all tokens
2. Make API call
3. Should see "No refresh token available" log

## ✅ **Success Criteria:**

- [ ] 401 errors trigger refresh attempt
- [ ] Refresh API called with separate Dio instance
- [ ] New tokens saved after successful refresh
- [ ] Original request retried with new token
- [ ] Tokens cleared when refresh fails
- [ ] Detailed logs for debugging
- [ ] No infinite loops

## 🚨 **If Still Not Working:**

1. **Check refresh token endpoint**: Verify `/auth/refresh` is correct
2. **Check token format**: Ensure refresh token format matches API expectation
3. **Check storage**: Verify tokens are properly saved/retrieved
4. **Check API response**: Verify refresh API returns expected format
5. **Check interceptor order**: Ensure interceptor is properly registered

## 📝 **Next Steps:**

1. Test the fix with real API calls
2. Monitor logs for token refresh behavior
3. Verify user experience (seamless token refresh)
4. Add additional error handling if needed
