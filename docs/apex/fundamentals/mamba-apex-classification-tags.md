<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

_last update 10/04/2025_
> 🧱 @status:core | This document defines the official classification tags model for Apex services in MambaDev.  
> All modules must comply to ensure testability, observability, and platform safety.

## **1. Mamba Apex Core Guide**
**Location:** _Section: Class Header_

### Add this note at the end of the header section:
```md
> **See also:** [Apex Classification Tags](https://guides.mambadev.io/docs/apex/fundamentals/mamba-apex-classification-tags.md) for mandatory `@classification`, `@layer`, and `@category` tags in class headers.
```

---

## **2. Layered Architecture**
**Location:** _Anywhere discussing DDD layers (application, domain, infrastructure)_

### Add:
```md
> **Tip:** All classes should explicitly declare their layer using the `@layer` tag in the class header.  
> See: [Apex Classification Tags](https://guides.mambadev.io/docs/apex/fundamentals/mamba-apex-classification-tags.md)
```

---

## **3. Naming Standards**
**Location:** _Where naming examples for files/classes are given_

### Add:
```md
> Consider aligning your class name with the `@category` tag used in its header.  
> Example: a class named `LeadValidationService.cls` might have `@category: lead` in its metadata.  
> See: [Classification Tags Guide](https://guides.mambadev.io/docs/apex/fundamentals/mamba-apex-classification-tags.md)
```

---

## **4. Apex Review Checklist**
**Location:** _Near code header or documentation section_

### Add checklist item:
```md
- [ ] Class includes `@classification`, `@layer`, and `@category` tags in the header  
      [Reference guide](https://guides.mambadev.io/docs/apex/fundamentals/mamba-apex-classification-tags.md)
```