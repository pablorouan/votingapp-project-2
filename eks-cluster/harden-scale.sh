#!/bin/bash
set -euo pipefail

CLUSTER="pablorouan-eks-lab"
REGION="ap-northeast-2"

echo "🔐 Enabling IAM OIDC provider..."
eksctl utils associate-iam-oidc-provider \
  --region $REGION \
  --cluster $CLUSTER \
  --approve

echo "🔐 Restricting API server access to your IP..."
MYIP=$(curl -s ifconfig.me)
eksctl utils update-cluster-vpc-config \
  --cluster $CLUSTER \
  --region $REGION \
  --public-access=true \
  --public-access-cidrs="${MYIP}/32" \
  --private-access=true

echo "📜 Enabling CloudWatch logging..."
eksctl utils update-cluster-logging \
  --enable-types all \
  --region $REGION \
  --cluster $CLUSTER

echo "🔧 Creating IAM policy for Cluster Autoscaler..."
curl -s -o cluster-autoscaler-policy.json https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-policy.json

aws iam create-policy \
  --policy-name AmazonEKSClusterAutoscalerPolicy \
  --policy-document file://cluster-autoscaler-policy.json || true

echo "🔐 Creating service account with IRSA for Cluster Autoscaler..."
eksctl create iamserviceaccount \
  --cluster $CLUSTER \
  --region $REGION \
  --namespace kube-system \
  --name cluster-autoscaler \
  --attach-policy-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):policy/AmazonEKSClusterAutoscalerPolicy \
  --approve

echo "📈 Installing Cluster Autoscaler via Helm with IRSA..."
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo update

helm upgrade --install cluster-autoscaler autoscaler/cluster-autoscaler-chart \
  --namespace kube-system \
  --set autoDiscovery.clusterName=$CLUSTER \
  --set awsRegion=$REGION \
  --set cloudProvider=aws \
  --set rbac.serviceAccount.create=false \
  --set rbac.serviceAccount.name=cluster-autoscaler \
  --set extraArgs.balance-similar-node-groups=true \
  --set extraArgs.skip-nodes-with-system-pods=false \
  --set extraArgs.skip-nodes-with-local-storage=false \
  --set fullnameOverride=cluster-autoscaler

echo "✅ Cluster hardened & Cluster Autoscaler installed using best practices."
