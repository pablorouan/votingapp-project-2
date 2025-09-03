🗳️ Project 2 — Cloud-Native Voting App on Amazon EKS

Welcome to the Project 2 repository, where we deploy a 3-Tier Microservices Voting App to a production-like environment using Amazon EKS, Kubernetes, and a fully automated CI/CD pipeline with GitHub Actions.

📦 What’s Inside

This repo contains:

vote/ → Python Flask frontend (vote microservice)

result/ → Node.js frontend (result microservice)

worker/ → .NET Core backend processor

k8s/ → All Kubernetes manifests (Deployments, StatefulSets, Ingress, Secrets, etc.)

.github/workflows/ci-cd-pipeline.yml → GitHub Actions pipeline

README.md → You're reading it 😎

🧱 Architecture Overview
Classic 3-Tier Setup
    🌐 Frontend Tier:
    - Vote (Python/Flask)
    - Result (Node.js/Express)

    ⚙️ Backend Tier:
    - Redis (StatefulSet)
    - Worker (.NET Core)

    🗄️ Database Tier:
    - PostgreSQL (StatefulSet)

🔁 Data Flow
Vote → Redis → Worker → PostgreSQL → Result

📶 Access via Ingress

https://vote.yourdomain.com → Vote app

https://result.yourdomain.com → Result app

☁️ Technologies Used
Tool/Service	Purpose
Amazon EKS	Kubernetes Cluster Hosting
eksctl	Cluster Provisioning
Docker Hub	Container Registry
GitHub Actions	CI/CD Pipeline
NGINX Ingress	Traffic Routing
cert-manager	HTTPS via Let's Encrypt (ClusterIssuer)
Kubernetes	Orchestration: Deployments, PVCs, Ingress
⚙️ CI/CD Pipeline Overview
Triggered by:

Any changes to source code or Kubernetes manifests

What It Does:

Builds Docker images (multi-arch: amd64, arm64)

Pushes to public Docker Hub

Configures access to EKS

Applies manifests and updates running pods using kubectl set image

🔐 Secrets You Must Configure

In your GitHub repository under Settings > Secrets and variables > Actions:

Secret Name	Description
AWS_ACCESS_KEY_ID	Your AWS access key
AWS_SECRET_ACCESS_KEY	Your AWS secret key
DOCKERHUB_USERNAME	Docker Hub username
DOCKERHUB_TOKEN	Docker Hub personal access token
🧪 Lab Objectives Achieved

✅ Provisioned secure and scalable EKS cluster
✅ Used StatefulSets for PostgreSQL & Redis
✅ Configured NGINX Ingress with host-based routing
✅ Automated HTTPS certificate provisioning via cert-manager
✅ Built full GitHub Actions CI/CD pipeline
✅ Troubleshooted environment variable issues and DB connectivity
✅ Migrated to a monorepo structure for full CI/CD compliance

📸 Gallery of Errors & Learnings

Check out /images (locally) or see our Ironhack presentation for:

Password authentication loops 🧠

Ingress style breakage when switching from path → host routing

Why Redis env var collision caused crash loops

How we fixed PersistentVolumeClaims with gp3 storage class

🧠 Lessons Learned

StatefulSet is essential when dealing with databases and persistent volumes

Secrets must match the app expectation exactly – no room for interpretation

Path-based routing is not ideal when static files are involved

CI ≠ CD — we learned it the hard way and fixed it with a monorepo merge

Automation isn’t just about deploying — it’s about recovering gracefully too

✅ Demo Live (if applicable)

🔗 https://vote.yourdomain.com

🔗 https://result.yourdomain.com

🙌 Authors

@pablorouan — DevOps & Cloud Computing @ Ironhack
