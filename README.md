## 🚀 What is GitOps?
GitOps is an operational framework that takes DevOps best practices—like version control, collaboration, compliance, and CI/CD—and applies them to infrastructure automation.
- Declarative: The entire system state is described in files.
- Versioned & Immutable: The desired state is stored in Git, providing a full audit trail and easy rollbacks.
- Pulled Automatically: Software agents (like ArgoCD or Flux) pull the configuration from Git and apply it to the cluster, ensuring no "configuration drift."
## The Single Source of Truth (SSoT)
The SSoT is the "shared" directory in this repository. It is the definitive representation of what should be running in our cluster.
- The Golden Rule: If it isn't in Git, it doesn't exist. If it's different in the cluster than it is in Git, the cluster is "wrong."
### Why SSoT Matters:
- Drift Detection: If someone manually edits a service in the cluster using kubectl edit, the GitOps controller (Argo/Flux) sees the deviation from the SSoT and automatically reverts it.
- Disaster Recovery: If a cluster is deleted, you can point your GitOps tool at the shared/ folder, and the entire environment is recreated in minutes.
- Auditability: Every change to the infrastructure has a commit hash, a timestamp, and an author.
  
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
├── shared/                 # Common resources used by all tools
│   ├── base-apps/          # Raw K8s manifests (Tool-agnostic)
│   └── scripts/            # Setup and migration scripts
└── README.md
```

### 🛠 Getting Started
1.Clone the Repo:
 ```
   git clone https://github.com/raghvendrashrinet/GitOps.git
```
2.Add a Project: Create a new folder under apps/ with your Kubernetes manifests.
3.Commit & Push: Once pushed, the GitOps controller will automatically synchronize the state with the live environment.

### 📝 To-Do / Roadmap
[ ] Setup initial folder hierarchy.  
[ ] Integrate with ArgoCD or Flux.  
[ ] Add the first "Hello World" project deployment.  
[ ] Configure Secret management (SealedSecrets or Vault).  

