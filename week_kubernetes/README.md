````markdown
# 🚀 Week: Kubernetes – Mini Project

This mini project demonstrates deploying a Flask-based Python web app in a Kubernetes cluster using Minikube. It covers Dockerizing the app, exposing it via a NodePort service, managing ConfigMaps and Secrets, mounting Persistent Volumes, and configuring liveness/readiness probes.

---

## 📁 Project Structure

```bash
week_kubernetes/
├── k8s/
│   ├── configmap.yaml
│   ├── hello-deployment.yaml
│   ├── hello-service.yaml
│   ├── secret.yaml
│   ├── pv.yaml
│   └── pvc.yaml
├── manifests/
├── src/
│   ├── hello.py
│   └── Dockerfile
└── README.md
```
````

---

## 💻 App Code: Flask (`src/hello.py`)

```python
from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    app_mode = os.getenv("APP_MODE", "not set")
    return f"Hello from K8s! App mode: {app_mode}"

@app.route("/env")
def show_env():
    vars = {k: v for k, v in os.environ.items() if k in ['APP_MODE', 'LOG_LEVEL', 'WELCOME_MESSAGE']}
    return "<h3>Environment Variables:</h3>" + "".join(f"<p>{k}: {v}</p>" for k, v in vars.items())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

---

<details>
<summary>🧱 1. Dockerize the App</summary>

### Dockerfile

```Dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY hello.py .
RUN pip install flask
EXPOSE 5000
CMD ["python", "hello.py"]
```

### Build the image

```bash
docker build -t hello-app:v1 .
```

</details>

---

<details>
<summary>📦 2. Kubernetes Configurations</summary>

### Apply all configurations

```bash
kubectl apply -f k8s/
```

</details>

---

<details>
<summary>🔐 3. Secrets & ConfigMaps</summary>

### Secret (`k8s/secret.yaml`)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  DB_PASSWORD: c3VwZXJzZWNyZXQ=
```

### ConfigMap (`k8s/configmap.yaml`)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: hello-config
data:
  APP_MODE: production
  LOG_LEVEL: debug
  WELCOME_MESSAGE: "Welcome to our K8s App!"
```

</details>

---

<details>
<summary>💾 4. Volumes (PV + PVC)</summary>

### Persistent Volume (`k8s/pv.yaml`)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: hello-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
```

### Persistent Volume Claim (`k8s/pvc.yaml`)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: hello-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

</details>

---

<details>
<summary>🚀 5. Deployment</summary>

### Deployment File (`k8s/hello-deployment.yaml`)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
        - name: hello-container
          image: hello-app:v11
          imagePullPolicy: Never
          ports:
            - containerPort: 5000
          env:
            - name: WELCOME_MESSAGE
              value: "Welcome to Kubernetes 🔥"
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: app-secret
                  key: DB_PASSWORD
            - name: APP_MODE
              valueFrom:
                configMapKeyRef:
                  name: hello-config
                  key: APP_MODE
          volumeMounts:
            - name: hello-storage
              mountPath: /app/data
          readinessProbe:
            httpGet:
              path: /
              port: 5000
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /
              port: 5000
            initialDelaySeconds: 15
            periodSeconds: 10
            failureThreshold: 3
      volumes:
        - name: hello-storage
          persistentVolumeClaim:
            claimName: hello-pvc
```

</details>

---

<details>
<summary>🌐 6. Service</summary>

### NodePort Service (`k8s/hello-service.yaml`)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-service
spec:
  type: NodePort
  selector:
    app: hello
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
      nodePort: 30001
```

### Test it

```bash
curl http://$(minikube ip):30001/
curl http://$(minikube ip):30001/env
```

</details>

---

<details>
<summary>🧪 7. Useful Commands</summary>

```bash
# Apply all manifests
kubectl apply -f k8s/

# Check status
kubectl get all
kubectl get pods -o wide
kubectl describe pod <pod-name>

# View logs
kubectl logs <pod-name>

# Restart deployment
kubectl rollout restart deployment hello-deployment

# Scale replicas
kubectl scale deployment hello-deployment --replicas=5

# Rollout history and undo
kubectl rollout history deployment hello-deployment
kubectl rollout undo deployment hello-deployment
```

</details>

---

## ✅ 8. Final QA Checklist

- [x] All YAML files tested and valid
- [x] Application returns expected data on `/` and `/env`
- [x] ConfigMap and Secret injected into pods
- [x] Probes function correctly
- [x] Volume mounts persist data
- [x] `README.md` clear, instructional, and matches course format

---

```

```
