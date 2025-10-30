# 🛡️ AWS Secure CI/CD Pipeline (with OIDC Authentication)

## 🚀 Overview
This project demonstrates how to securely connect GitHub Actions to AWS using OpenID Connect (OIDC), replacing static IAM keys with short-lived, scoped credentials.

## 🔧 Tech Stack
- **AWS IAM + OIDC Federation**
- **Terraform**
- **GitHub Actions**
- **tfsec / Checkov / OPA**
- **S3, Lambda, API Gateway**

## 🧠 What You'll Learn
✅ Passwordless AWS authentication  
✅ Secure CI/CD with Terraform  
✅ IaC security scanning (tfsec, Checkov, OPA)  
✅ Drift detection and tagging standards  

## 🧩 Architecture Overview
![Architecture Diagram](./docs/images/phase1/diagram.png)

## 📚 Documentation
- [Phase 1: OIDC Setup](./docs/PHASE1_OIDC_SETUP.md)
- [Phase 2: Terraform Plan + Security Gates](./docs/PHASE2_TERRAFORM_PLAN.md)
- [Phase 3: Apply + Drift Detection](./docs/PHASE3_APPLY_AND_DRIFT.md)
- [Naming Conventions](./docs/NAMING_CONVENTIONS.md)
- [Tagging Standards](./docs/TAGGING_STANDARDS.md)

## 🧑‍💻 Author
**Rodney Arceneaux**  
Cybersecurity Engineer | Cloud & GRC Professional  
[LinkedIn](https://linkedin.com/in/rodneyarceneaux116)
