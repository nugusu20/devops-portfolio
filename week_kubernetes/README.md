# Kubernetes App Deployment Project

This project demonstrates a real-world simulation of deploying a Python Flask application on Kubernetes. It includes containerization, environment configuration, persistent storage, and live testing.

---

## 📁 Project Structure

```
.
├── k8s/
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── hello-deployment.yaml
│   ├── hello-service.yaml
│   ├── pv.yaml
│   └── pvc.yaml
├── manifests/
├── src/
│   ├── hello.py
│   └── Dockerfile
├── README.md
```

---

<details>
<summary>1️⃣ Step 1: Build Docker Image</summary>

### ✅ What it does:

Builds the application image locally from the Dockerfile to be used in Kubernetes.

### 🔧 Commands:

```bash
cd src
docker build -t hello-app:v11 .
```

</details>

---

<details>
<summary>2️⃣ Step 2: Create ConfigMap and Secret</summary>

### ✅ What it does:

Creates environment configuration (APP_MODE, etc.) and sensitive variables (e.g. DB_PASSWORD) to be injected into the pod.

### 🔧 Commands:

```bash
cd ../k8s
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
```

</details>

---

<details>
<summary>3️⃣ Step 3: Create Persistent Volume & Claim</summary>

### ✅ What it does:

Provision static storage that survives restarts, to simulate real-world stateful behavior.

### 🔧 Commands:

```bash
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
```

</details>

---

<details>
<summary>4️⃣ Step 4: Deploy the Application</summary>

### ✅ What it does:

Creates a deployment with 3 replicas using the built image, attaching config, secret, and volume.

### 🔧 Commands:

```bash
kubectl apply -f hello-deployment.yaml
kubectl apply -f hello-service.yaml
```

</details>

---

<details>
<summary>5️⃣ Step 5: Validate Resources</summary>

### ✅ What it does:

Checks that all resources are correctly running and bound.

### 🔧 Commands:

```bash
kubectl get pods
kubectl get svc
kubectl get pv
kubectl get pvc
```

</details>

---

<details>
<summary>6️⃣ Step 6: Test Application</summary>

### ✅ What it does:

Send requests to ensure the application is running properly via service NodePort.

### 🔧 Commands:

```bash
minikube ip
curl http://<minikube-ip>:30001/
curl http://<minikube-ip>:30001/env
```

</details>

---

<details>
<summary>7️⃣ Step 7: Rollback or Debug</summary>

### ✅ What it does:

Rollback to a previous working version or inspect a broken deployment.

### 🔧 Rollback

```bash
kubectl rollout undo deployment hello-deployment
```

### 🧪 Debugging

```bash
kubectl logs <pod-name>
kubectl describe pod <pod-name>
```

</details>
