# Phase 3 – Terraform Apply & Drift Detection

## Objective

This phase demonstrates **secure production deployment** using Terraform and continuous **drift detection** to ensure infrastructure remains compliant and unchanged outside of approved CI/CD pipelines.

---

## Architecture Summary

In this phase, Terraform applies infrastructure changes using:

* GitHub Actions with OIDC authentication
* Federated IAM role (no static credentials)
* Least-privilege access controls
* Automated drift detection

---

## Step 1 – Terraform Apply (Production Deployment)

### Action

The CI/CD pipeline executes:

```bash
terraform apply
```

### Evidence

📸 Screenshot:

* Successful apply output
* Resources created (IAM roles, S3, Lambda, etc.)

**What this proves**

* Infrastructure deployed strictly via code
* No manual AWS console changes
* Secure authentication using OIDC

---

## Step 2 – Verify IAM OIDC Role

### AWS Console Validation

Navigate to:

```
IAM → Roles → github-oidc-role
```

📸 Screenshot:

* Trust policy showing:

  * `sts:AssumeRoleWithWebIdentity`
  * GitHub OIDC provider ARN
  * Repository and branch restrictions

**What this proves**

* Zero long-lived credentials
* Tight trust boundaries
* Least privilege enforcement

---

## Step 3 – CloudTrail Authentication Logs

### Validation

Filter CloudTrail:

```
eventName = AssumeRoleWithWebIdentity
```

📸 Screenshot:

* GitHub OIDC authentication event
* Source IP
* Role ARN
* Session name

**What this proves**

* Real federated authentication
* Audit logging enabled
* Full traceability

---

## Step 4 – Drift Detection

### Simulate Drift

Manually change a resource in AWS
(Example: modify S3 public access setting)

Run:

```bash
terraform plan
```

📸 Screenshot:

* Drift detected
* Planned remediation changes

**What this proves**

* Configuration drift detection
* Infrastructure governance

---

## Step 5 – Automated Drift Detection Job

Pipeline:

* Scheduled GitHub Action
* Executes `terraform plan` daily

📸 Screenshot:

* Scheduled workflow
* Drift detection step
* Notification (Slack/Jira if configured)

---

## Security Controls Enforced

* IAM least privilege
* No static credentials
* CI/CD gated deployments
* IaC security scanning
* Drift detection
* Audit logging

---

## Key Takeaways

* All infrastructure changes go through code
* GitHub OIDC prevents credential leaks
* Drift detection enforces compliance
* Logging ensures audit readiness
* Pipeline supports production-grade security
---

## Author

Rodney Arceneaux
Cloud Security Engineer
[LinkedIn](https://linkedin.com/in/rodneyarceneaux116)



