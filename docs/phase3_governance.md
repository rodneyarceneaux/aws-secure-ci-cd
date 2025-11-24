# Phase 3 – Terraform Deployment & Drift Detection (Apply + Monitor)

## Overview
Phase 3 extends the CI/CD pipeline beyond static validation into **controlled deployment** and **continuous drift monitoring**.  
This ensures that all Terraform changes are applied securely, traceably, and verified against AWS configuration drift.

---

## Objectives
- ✅ Implement a manual, approval-based Terraform deployment pipeline  
- ✅ Reuse OpenID Connect (OIDC) authentication — no long-lived AWS keys  
- ✅ Automatically detect infrastructure drift weekly  
- ✅ Enforce repeatable security scans (tfsec, Checkov, Conftest) before apply  

---

## Architecture Summary

| Stage | Trigger | Purpose | Key Tools |
|--------|----------|----------|------------|
| **Plan** | Push / PR to `main` | Validate Terraform + run security gates | Terraform + tfsec + Checkov + Conftest |
| **Apply** | Manual Dispatch | Deploy infrastructure after approval | Terraform Apply + GitHub Environments |
| **Drift Detect** | Scheduled (cron) | Detect AWS → Terraform drift | Terraform Plan (refresh-only) |

---

## Workflow Files

### 1️⃣ Plan – Secure CI Validation  
**File:** `.github/workflows/plan.yml`  
**Trigger:** Push / Pull Request to `main`  

Key Steps:
- Authenticate to AWS via OIDC  
- Run `terraform fmt`, `init`, `validate`  
- Execute static security scanners  
- Generate + upload `tfplan` artifact  

---

### 2️⃣ Apply – Manual, Guarded Deployment  
**File:** `.github/workflows/apply.yml`  
**Trigger:** Manual dispatch (workflow_dispatch)  

Safety Controls:
- Requires `confirm = YES` input  
- Optional GitHub Environment approvers  
- Re-validates code + reruns scanners  
- Executes `terraform apply -auto-approve tfplan`  

This step promotes **deliberate, auditable change management** — no automatic merges to production.

---

### 3️⃣ Drift Detect – Continuous Monitoring  
**File:** `.github/workflows/drift-detect.yml`  
**Trigger:** Scheduled (Monday 3 AM UTC) + Manual  

Process:
1. Runs `terraform plan -refresh-only`
2. Parses output for `"No changes."`
3. Flags drift and uploads report
4. Optionally reruns scanners for affected modules  

Future Enhancements:
- Slack / Teams notification on drift  
- Auto-create GitHub Issue for drift review  

---

## Security Posture Highlights

| Control | Implementation | Benefit |
|----------|----------------|----------|
| **Keyless Auth** | AWS OIDC via GitHub Actions | Eliminates static AWS keys |
| **Static Analysis** | tfsec + Checkov + Conftest | Prevents misconfigurations |
| **Manual Guardrails** | GitHub Environments + Confirm Flag | Prevents accidental applies |
| **Continuous Audit** | Drift Detection + Artifact Storage | Maintains IaC state integrity |

---

## Screenshots / Evidence

Recommended screenshots to include in your README or wiki:

| Screenshot | Description |
|-------------|--------------|
| ✅ Plan Run Summary | Demonstrates successful validation pipeline |
| ✅ Apply Manual Dispatch Dialog | Shows safety confirmation inputs |
| ✅ Drift Detect Result | Shows “No drift detected” summary |
| 🧩 OIDC Provider in AWS IAM | Proves keyless trust setup |
| 🔐 IAM Role Trust Policy | Displays repo + branch scope |

---

## Lessons Learned
- Small YAML mistakes (e.g., URL case sensitivity) can break installs — validate URLs early.  
- Separate install steps and tool sections improve debugging and clarity.  
- Using `|| true` on non-critical security steps keeps pipelines resilient during tool downtime.  
- Environment approvals are the best way to introduce “human in the loop” security.

---

## Next Phase (Phase 4 – Infrastructure State & Notifications)
**Goals:**
- Move Terraform state to S3 with DynamoDB locks  
- Add Slack / Teams notifications for drift alerts  
- Implement Snyk or Trivy for dependency vulnerability scanning  
- Introduce automatic rollback on failed apply  

---

**Outcome:**  
You’ve now built a **secure, cloud-native CI/CD pipeline** that validates, applies, and monitors AWS infrastructure — all without manual keys, using IaC security best practices.


