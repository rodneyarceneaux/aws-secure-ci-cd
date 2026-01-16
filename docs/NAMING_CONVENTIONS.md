# Naming Conventions

This document defines standardized naming patterns used across AWS resources to ensure consistency, clarity, and governance.

---

## Format

```
<env>-<app>-<resource>-<purpose>
```

### Example

```
prod-ci-iam-oidc-role
dev-ci-s3-artifacts
prod-api-lambda-handler
```

---

## Environments

| Environment | Prefix |
| ----------- | ------ |
| Development | dev    |
| Staging     | stg    |
| Production  | prod   |

---

## Resource Abbreviations

| Resource  | Abbreviation |
| --------- | ------------ |
| IAM Role  | iam          |
| S3 Bucket | s3           |
| Lambda    | lambda       |
| VPC       | vpc          |
| KMS Key   | kms          |

---

## Rules

* Lowercase only
* Hyphens instead of underscores
* No spaces
* Resource purpose must be descriptive
* Environment prefix is required

---

## Why This Matters

* Improves operational clarity
* Simplifies incident response
* Enables automation
* Supports audit readiness

---

## Owner

Rodney Arceneaux
