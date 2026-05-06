

### Here are the steps to get ArgoCD running on your cluster.

1. Create the Namespace
It is best practice to keep ArgoCD isolated in its own namespace.
```
kubectl create namespace argocd
```
2. Choose your Installation Method

Option A: The "Basic" Way (Manifests)
This is the quickest way to get started. It installs all the components we discussed (API Server, Controller, Repository Server, and Dex).
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
Option B: The "Advanced" Way (Helm)  
```
# Add the repo
helm repo add argo https://argoproj.github.io/argo-helm

# Install/Upgrade
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace
```

3. Access the ArgoCD UI
Once the pods are running (kubectl get pods -n argocd), you need a way to reach the API server.

For a quick local test (Port Forward):
```
kubectl port-forward svc/argocd-server -n argocd 8080:443
https://localhost:8080.
```
4. Retrieve the Initial Password
   ArgoCD creates a default admin password during installation. It is stored in a Kubernetes Secret.
   ```
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
   ```
   Security Tip: Once you log in, you should delete this secret and change your password or set up Dex/SSO.

5. Install the ArgoCD CLI
While the UI is great for visualization, the CLI is essential for automation and advanced management.

Mac (Homebrew): brew install argocd

Linux: ```bash
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

🚀 Your First GitOps Action
Now that it's installed, you can point ArgoCD to your new repository structure. In your argocd/ folder,
we will eventually create an Application manifest that looks like this:

```
# Example: argocd/apps/hello-world-app.yaml
```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: hello-world
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/YOUR_USERNAME/GitOps.git
    targetRevision: HEAD
    path: shared/base-apps/hello-world  # Pointing to your Shared SSoT!
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    ```
