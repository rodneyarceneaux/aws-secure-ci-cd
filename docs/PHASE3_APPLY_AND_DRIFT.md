# Phase 3 – Terraform Drift Detection

## Objective

This phase demonstrates an **automated drift detection workflow** to identify unauthorized or out-of-band changes to AWS infrastructure managed by Terraform.

---

## Architecture Summary

Drift detection is implemented using:

* GitHub Actions (scheduled workflow)
* Terraform state comparison
* OIDC-authenticated AWS access
* Read-only validation permissions

---

## Step 1 – Scheduled Drift Detection Workflow

### Workflow

A GitHub Action runs on a schedule to detect drift:

```bash
terraform plan
```

### Purpose

Compares:

* Current AWS infrastructure
* Desired state in Terraform code

---

## Step 2 – Drift Detection Logic

### Process

1. Workflow authenticates to AWS using OIDC
2. Terraform initializes remote state
3. Terraform refresh + plan runs
4. Output is evaluated for changes

---

## Step 3 – Drift Detection Evidence

📸 Screenshot:

* GitHub Actions workflow run
* `terraform plan` output
* Drift identified (if present)

---

## Step 4 – Manual Drift Simulation

### Test

A resource is manually modified in AWS
(example: S3 public access setting)

Re-run:

```bash
terraform plan
```

📸 Screenshot:

* Terraform detecting configuration drift
* Planned remediation actions

---

## Step 5 – Alerting (Optional Enhancement)

If configured:

* Slack notification
* GitHub summary output
* Ticket creation

---

## What This Proves

* Infrastructure changes are monitored continuously
* Manual console changes are detected
* Terraform remains the source of truth
* Governance controls are enforced

---

## Security Controls

* Read-only drift detection role
* No static credentials
* CI/CD-based validation
* Audit logging enabled

---

## Key Takeaways

* Drift detection runs automatically
* Unauthorized changes are visible
* Infrastructure integrity is maintained

---

## Author

Rodney Arceneaux
Cloud Security Engineer
[LinkedIn](https://linkedin.com/in/rodneyarceneaux116)




