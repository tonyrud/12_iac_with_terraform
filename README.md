# Terraform Playground

Playground for examples and following along with Techdegree. Everything is setup for IaC, and any changes should be made via PRs and merged to deploy new resouces with Terraform

- Uses OIDC for proper assume roles
- EKS maps Roles to AWS IAM Roles
- Create EC2s with a list of names/instance types

## CMDs

Create resources in dev env. Deploys into `us-east-2` via variable

```make
make terraform_apply ENV=dev
```

```make
make terraform_destroy ENV=dev
```

## EC2s

Creating EC2s can be done easily by adding new items to the tfvars list `ec2s`.

### Example configuration

Set in local `terraform.tfvars` file

```terraform
ec2s = [
  {
    name         = "6-cd-pipeline"
    image        = "*ubuntu-noble-24.04-amd64-server-20240701.1"
    entry_script = "../../scripts/install_docker.sh"
  }
]
```

Example images

- *ubuntu-noble-24.04-amd64-server-20240701.1
- amzn2-ami-kernel-*-x86_64-gp2
- al2023-ami-2023.*-x86_64

## EKS

An EKS Cluster can be created by uncommenting the module in `live/dev/main.tf`

kubeconfig: `aws eks update-kubeconfig --name <cluster-name>`

If you're testing EKS creation, you manually delete the cluster with

```bash
terraform destroy -target module.eks
```

**NOTE:
the cluster will be redeployed on next merge to main if the resource is in main.tf**

### Testing Roles

use `external-admin` or `external-developer` to test different access

`export AWS_PROFILE=k8s-admin` or `export AWS_PROFILE=k8s-developer`

Set current profile access via IAM assume role:

```bash
eval $(aws sts assume-role \
    --role-arn arn:aws:iam::326347646211:role/external-admin \
    --role-session-name k8s-session | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=\(.AccessKeyId) AWS_SECRET_ACCESS_KEY=\(.SecretAccessKey) AWS_SESSION_TOKEN=\(.SessionToken)"')
```

Using `kubens`, you can switch to `online-boutique` and check pods, svc, etc. No deployments are running in the default config.

### Kube Metrics Server

See Node usage

```bash
kubectl top node
```

pods usage

```bash
kubectl top pod -A
```

### ArgoCD

ArgoCD deployments are installed via helm provider in Terraform

See: `modules/eks/argo.tf`

Get argocd web ui password

```bash
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Port forward Argo Web UI

```bash
kubectl port-forward -n argocd pods/argocd-server-<id> 8080:8080
```

Login

> username: admin
> password: <from clipboard above>

ArgoCD repo configuration is installed as part of CI pipeline

See: `online-boutique-argo-app.yaml`
