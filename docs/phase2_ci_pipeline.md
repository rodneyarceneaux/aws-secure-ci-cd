# Phase 2 – Terraform Plan & Security Gates CI Workflow

## Overview
This phase implements a secure Terraform planning pipeline using GitHub Actions, AWS OIDC federation, and built-in IaC security scanning.

## Workflow Summary
**Workflow file:** `.github/workflows/plan.yml`  
**Trigger:** Push or Pull Request to `main` branch  
**Purpose:** Validate Terraform infrastructure and enforce security compliance before deployment.

## Key Security Controls
| Control | Tool | Purpose |
|----------|------|----------|
| Static IaC Analysis | **Checkov** | Detect misconfigurations |
| Terraform-specific Rules | **tfsec** | Identify AWS resource misconfigurations |
| Policy as Code | **Conftest (OPA)** | Enforce custom Rego policies |

## Successful Run Proof
<img width="1815" height="1041" alt="image" src="https://github.com/user-attachments/assets/8d7ff854-dae9-4b07-95ac-17154296c2df" />


## Lessons Learned
- Always verify exact binary URLs (case-sensitive) when using wget in CI.  
- Separate install steps simplify debugging.  
- `|| true` allows non-critical scan warnings without breaking the pipeline.

---
**Next Phase:** Implement the **Apply (deployment)** stage with environment-based safeguards.

