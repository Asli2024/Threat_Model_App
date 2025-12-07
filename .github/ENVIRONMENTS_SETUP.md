# GitHub Environments Setup Guide

## Overview
This guide shows how to configure GitHub Environments for the Terraform Plan and Apply workflow with approval gates.

## Steps to Configure Environments

### 1. Navigate to Repository Settings
1. Go to your repository: `https://github.com/Asli2024/Threat_Model_App`
2. Click **Settings** tab
3. Click **Environments** in the left sidebar

### 2. Create Environments

Create three environments: `dev`, `staging`, and `prod`

#### For Each Environment:

**Click "New environment"** and configure:

#### **Dev Environment**
- **Name**: `dev`
- **Deployment branches**: All branches (or specify if needed)
- **Environment secrets**: (Optional) Add dev-specific secrets
- **Required reviewers**:
  - ✅ Enable "Required reviewers"
  - Add 1+ GitHub usernames who can approve dev deployments
  - Recommendation: 1 reviewer for dev (fast iteration)

#### **Staging Environment**
- **Name**: `staging`
- **Deployment branches**: `main` (recommended)
- **Required reviewers**:
  - ✅ Enable "Required reviewers"
  - Add 1-2 GitHub usernames
  - Recommendation: 1-2 reviewers for staging

#### **Prod Environment**
- **Name**: `prod`
- **Deployment branches**: `main` only (recommended)
- **Required reviewers**:
  - ✅ Enable "Required reviewers"
  - Add 2+ GitHub usernames (higher security)
  - Recommendation: 2+ reviewers for production
- **Wait timer**: (Optional) Add 5-10 minute wait before deployment
- **Deployment protection rules**: Consider branch restrictions

## How the Workflow Works

### Workflow Execution Flow:

```
1. Manual Trigger
   ├── Select environment (dev/staging/prod)
   └── Click "Run workflow"
         ↓
2. Plan Job (Automatic)
   ├── Checkout code
   ├── Configure AWS
   ├── Terraform init
   ├── Terraform fmt/validate
   ├── Trivy security scan
   ├── Terraform plan
   └── Upload plan artifact
         ↓
3. Approval Job (Manual Gate)
   ├── Waits for reviewer approval
   ├── GitHub sends notification to reviewers
   ├── Reviewer goes to Actions → Review deployment
   └── Clicks "Approve and deploy" or "Reject"
         ↓
4. Apply Job (Automatic after approval)
   ├── Download plan artifact
   ├── Configure AWS
   ├── Terraform workspace select
   ├── Terraform apply (auto-approved plan)
   └── Deployment summary
```

## Approving Deployments

### For Reviewers:

1. **Receive notification** (email/GitHub notification)
2. Go to **Actions** tab in repository
3. Click on the running workflow
4. See **"Review pending deployments"** banner
5. Review the plan output from the plan job
6. Click **"Review pending deployments"** button
7. Select environment(s) to approve
8. (Optional) Add comment
9. Click **"Approve and deploy"** or **"Reject"**

### Approval Notifications:
- Reviewers get email notifications
- Shows in GitHub notifications
- Visible in Actions UI

## Security Best Practices

### Dev Environment:
- ✅ 1 reviewer (fast feedback)
- ✅ All branches allowed
- ✅ No wait timer

### Staging Environment:
- ✅ 1-2 reviewers
- ✅ Only `main` branch
- ✅ Optional: 5-minute wait timer

### Prod Environment:
- ✅ 2+ reviewers (redundancy)
- ✅ Only `main` branch (strict)
- ✅ 10-minute wait timer (cooling period)
- ✅ Deployment windows (optional)

## Testing the Setup

1. **Trigger workflow**: Actions → Terraform Plan and Apply → Run workflow
2. **Select environment**: Choose `dev`
3. **Watch plan job**: See plan output
4. **Wait for approval request**: Notification appears
5. **Approve deployment**: Review and approve
6. **Watch apply job**: Automatic execution
7. **Verify**: Check AWS resources

## Troubleshooting

### "Environment not found" error
- Ensure environment names match exactly: `dev`, `staging`, `prod`
- Check capitalization

### Workflow skips approval
- Verify `environment:` line in approval job
- Check environment protection rules are enabled

### Reviewer not notified
- Ensure reviewer has appropriate repository permissions
- Check GitHub notification settings

## Example Screenshot Locations

When configuring, you'll see:
- **Settings → Environments → New environment**
- **Environment protection rules**
- **Required reviewers** section
- **Deployment branches** dropdown

## Additional Resources

- [GitHub Environments Documentation](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [Environment Protection Rules](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-protection-rules)

---

**Ready to use!** After setting up environments, your workflow will require approval before applying infrastructure changes. 🎯
