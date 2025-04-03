<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🔐 Auth Token Design – MambaDev

This guide defines the **expected design, validation, and security practices** for working with access tokens in MambaDev Apex integrations.

Tokens are often the first and only layer of defense. This guide ensures:
- No hardcoded tokens
- Full logging for invalid attempts
- Semantic errors for invalid/missing tokens
- Mocking ability for token injection during tests

---

## 🧱 Token Design Principles

| Rule                              | Description                                                              |
|-----------------------------------|---------------------------------------------------------------------------|
| ✅ Token is required              | Never optional — enforced by `RestServiceHelper.validateAccessToken()`    |
| ✅ Prefix-based structure         | Expect format like `Bearer abc123...` or `Token xyz456...`                |
| ✅ Validated on every request     | Token must be checked on entry before business logic                      |
| ❌ No debug output                | Use `Logger.error()` on invalid token attempt                             |
| ✅ Environment-controlled         | Use `EnvironmentUtils.getExpectedToken()` or similar                      |

---

## 🔐 Sample Validation Pattern

```apex
public static void validateAccessToken(String headerName, String expectedTokenPrefix) {
    String accessToken = RestContext.request.headers.get(headerName);

    if (accessToken == null || !accessToken.startsWith(expectedTokenPrefix)) {
        Logger logger = new Logger().setClass('RestServiceHelper').setMethod('validateAccessToken');
        logger.warn('Missing or invalid token: ' + accessToken);
        throw new AccessException('Invalid token');
    }
}
```

Call this early in your controller:

```apex
RestServiceHelper.validateAccessToken('Access_token', 'Bearer ');
```

---

## 📁 Where to Store Tokens

Tokens should never be hardcoded in Apex classes. Instead, use:
- ✅ `Custom Metadata`: for public/static tokens (read-only)
- ✅ `Custom Settings`: for sandbox test injection (dynamic/mutable)
- ✅ Encrypted `NamedCredential` (if calling out to external service)
- ✅ `EnvironmentUtils.getExpectedToken()` (wrapped accessor)

---

## 🧪 Testing Token Logic

In unit tests:
```apex
RestContext.request = new RestRequest();
RestContext.request.addHeader('Access_token', 'Bearer VALID_FAKE_TOKEN');
```
Use `TestDataSetup.overrideLabel(...)` or inject mocks as needed.

---

## 🔗 Related Modules

- [RestServiceHelper](rest-api-guide.md)
- [EnvironmentUtils](../core/environment-utils.md)
- [Logger](../logging/logger-implementation.md)
- [Apex Testing Guide](../testing/apex-testing-guide.md)

---

> **If your API doesn’t guard its doors, someone else will open them.**
> Mamba tokens are validated, logged, and environment-aware.

**#SecureByDesign #NoHardcodedSecrets #LogBeforeYouFail**