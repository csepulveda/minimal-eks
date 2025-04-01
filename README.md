# minimal-eks

## Instructions to init the environment

1. Initialize the Project
Run the following command to initialize the project:
```bash
tofu init
```

2. Plan the Changes
Generate an execution plan to preview the changes
```bash
tofu plan
```

3. Create the EKS cluster and Karpenter Only
If the plan looks correct, apply the changes to deploy the resources: (take aproximatly 10 to 15 minutes.)
```bash
tofu apply -target="module.vpc" -target="module.eks" -target="module.karpenter" -target="helm_release.karpenter" -target="kubectl_manifest.karpenter_node_class" -target="kubectl_manifest.karpenter_node_pool"
```

4. Apply all the changes (5 to 10 minutes )
If the Karpenter Install runs well, continue.
```bash
tofu apply
```

5. Update you kubectl config 
After apple the tofu configuration, update you kubeconfig to allow the usage of kubectl command and other utilities.
```bash
aws eks update-kubeconfig --region us-east-1 --name my-test-cluster --alias my-test-cluster
```
---

## Cleaning Up the Environment

### Option 1: Using OpenTofu
To destroy the resources created by the project, execute:
```bash
tofu destroy
```

### Option 2: Using aws-nuke (Alternative)
Follow these steps to clean up resources using `aws-nuke`:

1. Install `aws-nuke`:
Install the tool via Homebrew:
```bash
brew install aws-nuke
```

2. Configure `nuke-example.yaml`:
- Add your AWS account ID to the configuration file.
- Specify any IAM users or resources you want to exclude from deletion.

3. Run `aws-nuke`:
Execute the following command to clean up resources:
```bash
aws-nuke nuke -c nuke-example.yaml --no-dry-run
```

**Important:** Ensure your AWS account has an active account alias before running `aws-nuke` to avoid errors.
