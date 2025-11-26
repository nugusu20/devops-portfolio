# 📦 Week Kubernetes Mini Project with Flask App

This project demonstrates a complete end-to-end deployment of a simple **Flask app** on **Kubernetes using Minikube**. It includes usage of **ConfigMaps**, **Secrets**, **PersistentVolumes**, **Readiness/Liveness probes**, and more — all through clearly defined YAML manifests.

---

## 📁 Folder Structure

```
week_kubernetes/
├── k8s/
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── hello-deployment.yaml
│   ├── hello-service.yaml
│   ├── pv.yaml
│   └── pvc.yaml
├── src/
│   ├── hello.py
│   └── Dockerfile
└── README.md
```

---

## 🚀 Project Goals

- Deploy a Flask app into Kubernetes using `kubectl apply`
- Manage configuration and secrets separately using ConfigMap & Secret
- Enable persistence using PersistentVolume & PVC
- Expose the app using NodePort service
- Demonstrate health checks using probes
- Scale and manage deployment replicas
- Simulate real-world deployment flow

---

## 🔨 Step-by-Step Setup

<details>
<summary>📌 Step 1 - Build Docker Image</summary>

### 🧾 Explanation

We build the Flask application into a Docker image locally inside Minikube's Docker environment.

```bash
# Point Docker CLI to use Minikube's Docker daemon
eval $(minikube docker-env)

# Build image with a version tag (e.g. v1, v2...)
docker build -t hello-app:v1 src/
```

</details>

<details>
<summary>📌 Step 2 - Create ConfigMap & Secret</summary>

### 🧾 Explanation

These Kubernetes resources store environment configuration and sensitive data like DB credentials.

```bash
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
```

</details>

<details>
<summary>📌 Step 3 - Create Persistent Volume</summary>

### 🧾 Explanation

Ensure data persistence even if the pod is restarted.

```bash
kubectl apply -f k8s/pv.yaml
kubectl apply -f k8s/pvc.yaml
```

</details>

<details>
<summary>📌 Step 4 - Deploy Application (Deployment + Service)</summary>

### 🧾 Explanation

Creates the actual app pods, sets up environment variables, probes, and volumes, and exposes the app via NodePort.

```bash
kubectl apply -f k8s/hello-deployment.yaml
kubectl apply -f k8s/hello-service.yaml
```

</details>

---

## 📦 Deployment Manifest Highlights

<details>
<summary>📜 Deployment File (hello-deployment.yaml)</summary>

Includes:

- Environment Variables from ConfigMap & Secret
- Mounted Persistent Volume
- Health Checks: readiness & liveness probes
- Proper tagging with versioned Docker image

</details>

<details>
<summary>🔒 Secret File</summary>

Used to inject DB_PASSWORD into the container securely.

</details>

<details>
<summary>⚙️ ConfigMap File</summary>

Defines APP_MODE, WELCOME_MESSAGE, etc., configurable without changing app code.

</details>

---

## 🧪 Useful Commands

### Deploy All Resources

```bash
kubectl apply -f k8s/
```

### Get Status

```bash
kubectl get all
kubectl get pods -o wide
kubectl describe pod <pod-name>
```

### View Logs

```bash
kubectl logs <pod-name>
```

### Scaling Pods

```bash
kubectl scale deployment hello-deployment --replicas=5
```

### Rollout Controls

```bash
kubectl rollout status deployment hello-deployment
kubectl rollout restart deployment hello-deployment
kubectl rollout undo deployment hello-deployment
kubectl rollout history deployment hello-deployment
```

---

## ✅ Testing the App

### Basic

```bash
curl http://$(minikube ip):30001/
curl http://$(minikube ip):30001/env
```

### Pod Restart Test

```bash
kubectl delete pod <pod-name>
# After restart, test again
```

---

## 🧠 Summary

- ✅ Real Flask App deployed on Kubernetes
- ✅ Secrets & ConfigMaps used securely
- ✅ Persistent volume configured
- ✅ Readiness & Liveness Probes implemented
- ✅ Proper deployment structure

---

> 🎉 You now have a **production-style** deployment experience on local **Minikube**!  
> This README is meant to help **anyone clone and deploy** this project in minutes.
