<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the required authentication contract for all REST APIs in MambaDev.

# 🔐 Auth Token Design – MambaDev

📎 [Shortlink: mambadev.io/auth-token](https://mambadev.io/auth-token)

This guide defines the **expected design, validation, and security practices** for working with access tokens in MambaDev Apex integrations.

Tokens are often the first and only layer of defense. This guide ensures:
- ❌ No hardcoded tokens  
- ✅ Full logging for invalid attempts  
- ✅ Semantic errors for invalid/missing tokens  
- ✅ Mocking ability for token injection during tests

---

## 🧱 Token Design Principles

| Rule                              | Description                                                              |
|-----------------------------------|---------------------------------------------------------------------------|
| ✅ Token is required              | Never optional — enforced by [`RestServiceHelper.validateAccessToken()`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/rest-service-helper.cls) |
| ✅ Prefix-based structure         | Expect format like `Bearer abc123...` or `Token xyz456...`                |
| ✅ Validated on every request     | Must be checked before business logic                                     |
| ❌ No debug output                | Use [`Logger.warn(...)`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls) |
| ✅ Environment-controlled         | Use [`EnvironmentUtils`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/environment-utils.cls) or wrapper accessor |

---

## 🔐 Sample Validation Pattern

```apex
public static void validateAccessToken(String headerName, String expectedTokenPrefix) {
    String accessToken = RestContext.request.headers.get(headerName);

    if (accessToken == null || !accessToken.startsWith(expectedTokenPrefix)) {
        Logger logger = new Logger()
            .setClass('RestServiceHelper')
            .setMethod('validateAccessToken');
        logger.warn('Missing or invalid token: ' + accessToken);
        throw new AccessException('Invalid token');
    }
}
```

✅ Use this early in your controller:

```apex
RestServiceHelper.validateAccessToken('Access_token', 'Bearer ');
```

---

## 📁 Where to Store Tokens

Never hardcode tokens inside Apex classes.  
Instead, store them in:

- ✅ **Custom Metadata** – for static sandbox/public keys  
- ✅ **Custom Settings** – for local sandbox testing  
- ✅ **NamedCredential** – if used for outbound requests  
- ✅ [`EnvironmentUtils.getExpectedToken()`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/environment-utils.cls) – for environment-aware accessors

---

## 🧪 Testing Token Logic

Use `RestContext` in test classes:

```apex
RestContext.request = new RestRequest();
RestContext.request.addHeader('Access_token', 'Bearer VALID_FAKE_TOKEN');
```

Inject token values or use:

- [`TestDataSetup.overrideLabel(...)`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-data-setup.cls)  
- Label mocks or conditional switching for full test coverage

---

## 🔗 Related Modules

- [REST API Guide](/docs/apex/integrations/rest-api-guide.md)  
- [`RestServiceHelper.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/rest-service-helper.cls)  
- [`EnvironmentUtils.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/environment-utils.cls)  
- [Logger Implementation](/docs/apex/logging/logger-implementation.md)  
- [Apex Testing Guide](/docs/apex/testing/apex-testing-guide.md)

---

> **If your API doesn’t guard its doors, someone else will open them.**  
> Mamba tokens are validated, logged, and environment-aware.

**#SecureByDesign #NoHardcodedSecrets #LogBeforeYouFail**