🥇 Phase 1 – AWS OIDC Authentication Setup

🎯 Objective

Establish a secure, passwordless authentication channel between GitHub Actions and AWS using OpenID Connect (OIDC) — eliminating the need for static AWS access keys in CI/CD pipelines.

🧠 Why This Matters
Old Way	New (OIDC) Way
Long-lived IAM access keys stored in GitHub Secrets	No secrets stored — GitHub Actions authenticates directly with AWS
Requires manual rotation	Uses short-lived tokens issued per job
Broad permissions often reused	Scopes access to specific repo + branch
Risk of accidental key exposure	Zero-trust, ephemeral credentials

This is the foundational step for building a secure, auditable CI/CD pipeline.

🧱 Prerequisites

An AWS account with IAM admin or role-creation privileges.

A GitHub repository (public or private).

Terraform installed locally (>= 1.7).

AWS CLI configured for testing (aws sts get-caller-identity).

🔹 Step 1 — Add GitHub as an OIDC Identity Provider in AWS
Actions:

Navigate to IAM → Identity Providers → Add Provider.

Select OpenID Connect as the provider type.

Fill in the following:

Provider URL: https://token.actions.githubusercontent.com

Audience: sts.amazonaws.com

Click Add Provider.

Screenshot Placeholder:

📸 Add a screenshot here showing your Identity Provider configuration in AWS IAM.

🔹 Step 2 — Create the IAM Role Trusted by GitHub Actions
Actions:

Go to IAM → Roles → Create Role.

Select Web Identity.

Choose:

Provider: token.actions.githubusercontent.com

Audience: sts.amazonaws.com

Specify your GitHub details:

Organization/User: rodneyarceneaux

Repository: aws-secure-ci-cd

Branch: main

Click Next, and attach the permissions policy below (for testing).

{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }]
}


🧠 You’ll later replace this with least-privilege permissions for Terraform.

Screenshot Placeholder:

📸 Add a screenshot of the IAM Role creation screen showing the GitHub repo and branch fields.

🔹 Step 3 — Review and Add Metadata
Recommended naming convention:
aws-secure-ci-cd-terraform-dev-gha-oidc

Example description:

Allows GitHub Actions from rodneyarceneaux/aws-secure-ci-cd (main branch) to assume this role via OIDC for Terraform deployments in the dev environment.

Example tags:
Key	Value
Project	aws-secure-ci-cd
Environment	dev
Owner	rodney.arceneaux
Source	github-actions
Repository	rodneyarceneaux/aws-secure-ci-cd
ManagedBy	Terraform
Purpose	GitHub OIDC role for Terraform CI/CD
Screenshot Placeholder:

📸 Capture the AWS IAM Role overview showing Description + Tags.

🔹 Step 4 — Verify Trust Policy

After creating the role, AWS automatically generates this trust relationship:

{
  "Version": "2012-10-17",
  "Statement": [{
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
  }]
}


✅ Verification Checklist

 aud equals sts.amazonaws.com

 sub matches your repo and branch
(repo:rodneyarceneaux/aws-secure-ci-cd:ref:refs/heads/main)

 The role name matches your YAML workflow config

Screenshot Placeholder:

📸 Include the IAM Role → Trust Relationships tab showing this JSON.

🔹 Step 5 — Test the OIDC Connection in GitHub

Create the workflow:
📄 .github/workflows/test-oidc.yml

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

Screenshot Placeholder:

📸 Add a screenshot of this YAML file in your GitHub repo.

🔹 Step 6 — Run and Verify

Push the file to GitHub.

Go to Actions → Test AWS OIDC Connection → Run workflow.

When successful, you’ll see output similar to:

{
  "UserId": "AROAEXAMPLE:GitHubActions",
  "Account": "123456789012",
  "Arn": "arn:aws:sts::123456789012:assumed-role/aws-secure-ci-cd-terraform-dev-gha-oidc/github-actions"
}


✅ This confirms that:

GitHub → AWS trust is valid

OIDC token exchange succeeded

AWS issued temporary credentials

Screenshot Placeholder:

📸 Add the GitHub Actions log showing “Authenticated as assumedRoleId ...:GitHubActions.”

🔍 Step 7 — (Optional) Confirm in AWS CloudTrail

In CloudTrail → Event History, filter for:

Event name: AssumeRoleWithWebIdentity

User Agent: GitHubActions

This provides audit evidence that the authentication occurred correctly.

Screenshot Placeholder:

📸 Capture the CloudTrail event details showing GitHubActions as the source.

🧩 Result

You have successfully established a secure OIDC-based authentication between GitHub and AWS.

Component	Purpose
OIDC Provider	Allows GitHub to present signed identity tokens
IAM Role	Defines which repo + branch can assume AWS credentials
GitHub Workflow	Requests short-lived credentials automatically
CloudTrail Logs	Provides audit trail for every authentication event
🧠 Key Lessons Learned

Always copy the exact role ARN from AWS (avoid typos).

The aud and sub claims are the core of AWS trust evaluation.

OIDC eliminates the need for long-lived secrets — ideal for secure CI/CD.

Adding descriptions and tags makes IAM roles auditable and readable.

Testing incrementally (with a minimal workflow) helps isolate setup issues.
