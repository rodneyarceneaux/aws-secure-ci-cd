🥇 AWS OIDC Setup Documentation
1. Overview

This document outlines the setup of GitHub → AWS authentication using OpenID Connect (OIDC) for secure, keyless access to AWS resources during CI/CD pipeline runs.

By using OIDC, GitHub Actions can request temporary credentials from AWS without storing static access keys, significantly reducing credential exposure risks.

🔐 Benefits

No long-lived IAM user access keys.

Role assumption scoped to a specific GitHub repo and branch.

Ephemeral credentials managed via AWS STS.

Simplifies compliance with least-privilege and rotation policies.

2. Architecture Overview
GitHub Actions Runner
        │
        ▼
   OIDC Token Request
        │
        ▼
AWS IAM OIDC Provider (token.actions.githubusercontent.com)
        │
        ▼
IAM Role (Trusts the provider + specific repo/branch)
        │
        ▼
AWS STS issues short-lived credentials


📘 In this setup, only the specified GitHub repository and branch can assume the AWS role via OIDC.

3. Create OIDC Provider in AWS
3.1 Provider Configuration

Provider URL: https://token.actions.githubusercontent.com

Audience: sts.amazonaws.com

✅ This establishes AWS as a trusted consumer of GitHub’s OIDC tokens.

Screenshot:

<img width="1843" height="750" alt="01_oidc_provider" src="https://github.com/user-attachments/assets/691de370-71fe-4f9a-ae92-64e816ed901d" />

4. Create IAM Role for GitHub Actions
4.1 Role Trust Relationship

This trust policy allows the specific GitHub repo (and branch) to assume the AWS role via OIDC.

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:rodneyarceneaux/aws-secure-ci-cd:ref:refs/heads/main"
        }
      }
    }
  ]
}


✅ This ensures only the main branch of your aws-secure-ci-cd repo can assume this role.

Screenshot:
<img width="1820" height="1116" alt="02_trust_policy" src="https://github.com/user-attachments/assets/33b380a7-06a9-4bf9-b4fa-14728e8f39b7" />


5. Test the OIDC Connection from GitHub Actions
5.1 Workflow: test-oidc.yml
name: Test AWS OIDC Connection

on:
  workflow_dispatch:

jobs:
  oidc-test:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Configure AWS credentials via OIDC
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<ACCOUNT_ID>:role/aws-secure-ci-cd-terraform-dev-gha-oidc
          aws-region: us-east-1

      - name: Verify AWS identity
        run: aws sts get-caller-identity

5.2 Successful Authentication Result

When the connection works, you’ll see an output like this:

{
  "UserId": "AROAEXAMPLE:botocore-session-123",
  "Account": "123456789012",
  "Arn": "arn:aws:sts::123456789012:assumed-role/aws-secure-ci-cd-terraform-dev-gha-oidc/github-actions"
}


✅ Indicates GitHub successfully assumed the AWS role with OIDC.

Screenshot:
<img width="1827" height="1327" alt="03_actions_success" src="https://github.com/user-attachments/assets/a1ff01fd-4422-45f0-8a47-82dd8b9af427" />


6. Security Validation Checklist
Control	Status	Description
OIDC Provider URL is correct	✅	Matches GitHub endpoint
Audience set to sts.amazonaws.com	✅	Matches GitHub token audience
Trust policy scoped to repo and branch	✅	Follows least privilege
No IAM access keys used	✅	Authentication via OIDC only
Role permissions limited to Terraform + Lambda actions	✅	Least privilege
7. Lessons Learned

The ARN mismatch issue reminded me that exact string matching matters for OIDC trust conditions.

The aud and sub claims are the heart of OIDC security in AWS.

Always test OIDC setup with a minimal workflow before integrating with Terraform.

8. Next Steps

Integrate this OIDC role into Terraform workflows (plan.yml, apply.yml).

Enforce security gates (tfsec, Checkov, Conftest).

Migrate Terraform state to S3 with DynamoDB locking.

✅ Deliverable Summary

OIDC provider registered and verified.

IAM role with least-privilege trust policy.

GitHub Action validated OIDC-based authentication.
