## 🚀 What is GitOps?
GitOps is an operational framework that takes DevOps best practices—like version control, collaboration, compliance, and CI/CD—and applies them to infrastructure automation.
- Declarative: The entire system state is described in files.
- Versioned & Immutable: The desired state is stored in Git, providing a full audit trail and easy rollbacks.
- Pulled Automatically: Software agents (like ArgoCD or Flux) pull the configuration from Git and apply it to the cluster, ensuring no "configuration drift."

### 📂 Directory Structure
As this KB (Knowledge Base) grows, we use a structured approach to separate environmental configurations from application logic.
```
.
├── argocd/                 # ArgoCD-specific implementation
├── fluxcd/                 # FluxCD-specific implementation
├── other-tools/            # Non-controller based GitOps/CD tools
│   ├── jenkins/            # Groovy Pipelines & JCasC configs
│   ├── spinnaker/          # Halyard configs & Pipeline JSONs
│   └── crossplane/         # Control plane for infrastructure
|── shared/
| |── base-apps/               # Raw, tool-agnostic K8s manifests
│ |   ├── hello-world/         # Example App 1
│ |   │   ├── deployment.yaml
│ |   │   ├── service.yaml
│ |   │   └── ingress.yaml
│ |   └── guestbook/           # Example App 2
│ |        ├── redis-master.yaml
│ |        └── frontend.yaml
| |── scripts/                 # Utility scripts
|     ├── install-tools.sh     # Script to install kubectl, helm, etc.
|     └── validate-yamls.sh    # CI script to lint your manifests
└── README.md
```
### shared/ folder acts as your Single Source of Truth 
for the raw application definitions. By keeping them here, you avoid duplicating the same Kubernetes manifests across different tool directories.
### How the other tools will use it:
Think of the shared/ folder as the library and the other folders as the librarians:
- ArgoCD: Your argocd/apps/ manifests will point to shared/base-apps/hello-world/ as the source path.
- FluxCD: Your GitRepository and Kustomization objects in fluxcd/ will reference the shared/ path.
- Jenkins: Your Jenkinsfile in other-tools/jenkins/ will simply run kubectl apply -f shared/base-apps/hello-world/.

### Why this is a "Pro" Move:
- Consistency: If you update the containerImage version in shared/, every GitOps tool you’ve configured will pick up the change simultaneously.
- Comparison: You can easily see how ArgoCD handles a "Sync" vs. how Flux handles a "Reconciliation" for the exact same set of YAML files.
- DRY (Don't Repeat Yourself): You won't have to manage multiple copies of the same Deployment spec.

Note: If you want to get advanced later, you can add a kustomize/ folder inside shared/ to handle environment-specific overlays (like dev vs prod) while still keeping the core logic in one place.

###  the Roadmap
Since you've already categorized the tools in your README, you might want to change your "To-Do" section to reflect this new multi-tool approach:

[ ] Populate shared/ with base Kubernetes manifests.  
[ ] Configure ArgoCD to track the shared/ directory.  
[ ] Configure FluxCD to reconcile from the shared/ directory.  
[ ] Create a Jenkins Pipeline to push changes from shared/ to the cluster.
