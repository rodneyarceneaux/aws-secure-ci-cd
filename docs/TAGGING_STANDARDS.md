
# Tagging Standards

This document defines mandatory AWS resource tags to support governance, security, and cost tracking.

---

## Required Tags

| Tag Key     | Example          | Purpose                 |
| ----------- | ---------------- | ----------------------- |
| Environment | prod             | Resource classification |
| Application | aws-secure-ci-cd | Service ownership       |
| Owner       | rodney.arceneaux | Accountability          |
| CostCenter  | security         | Cost tracking           |
| Compliance  | pci              | Audit mapping           |
| ManagedBy   | terraform        | IaC enforcement         |

---

## Optional Tags

| Tag Key   | Example        |
| --------- | -------------- |
| Project   | cloud-security |
| DataClass | internal       |
| Backup    | true           |

---

## Enforcement

* Tags are enforced via Terraform
* Pipeline fails if required tags are missing
* Drift detection monitors tag changes

---

## Why This Matters

* Cost allocation
* Ownership tracking
* Compliance reporting
* Asset inventory

---

## Owner

Rodney Arceneaux
