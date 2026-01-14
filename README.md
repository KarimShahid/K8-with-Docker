# 🚀 Kubernetes Deployment with Private Docker Hub Image

This project demonstrates how to deploy a **Dockerized web application** to **Kubernetes (Minikube)** using a **private Docker Hub repository**.

It covers the complete flow from building a Docker image to securely pulling it inside a Kubernetes cluster using `imagePullSecrets`.

---

## 🎯 Objectives

- Dockerize a web application
- Push the image to a **private Docker Hub repository**
- Create a Kubernetes **Deployment**
- Expose the app using a Kubernetes **Service**
- Verify that everything works end-to-end

---

## 📁 Repository Structure

```
K8-with-Docker/
├── Dockerfile
├── css
│   └── style.css
├── docker-compose.yml
├── images
│   └── crying-jordan.jpg
├── index.html
└── k8s
    ├── deployment.yml
    └── service.yml
```

---

## ✅ Pre-requisites

- A working web application
- Docker installed and logged in
- Kubernetes cluster (Minikube)
- Docker Hub account with a **private repository**

---

## 🐳 Upload Web App to Docker Hub

### 1️⃣ Create a Private Docker Hub Repository

Create a **private repository** in Docker Hub (example: `nba-memes`).

---

### 2️⃣ Login to Docker Hub

```bash
docker login
```

---

### 3️⃣ Build Docker Image Locally

Tags must match the image name used in Kubernetes.

```bash
docker compose build
```

---

### 4️⃣ Push Image to Docker Hub

```bash
docker push karimshahid/nba-memes:latest
```

**Image format:**
- `karimshahid` → Docker Hub username
- `nba-memes` → repository name
- `latest` → image tag

---

## ☸️ Kubernetes Setup

### Create Docker Hub Secret

Kubernetes needs credentials to pull from a **private registry**.

```bash
kubectl create secret docker-registry my-dockerhub-secret   --docker-username=karimshahid   --docker-password=<DOCKER_HUB_PAT>   --docker-email=<your-email@example.com>
```

> ❗ Always use a **Personal Access Token (PAT)** instead of your Docker Hub password.

---

## 📦 Kubernetes Deployment

### `deployment.yml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nba-memes-deployment
  labels:
    app: nba-memes
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nba-memes
  template:
    metadata:
      labels:
        app: nba-memes
    spec:
      containers:
        - name: nba-memes
          image: karimshahid/nba-memes:latest
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "500m"
              memory: "512Mi"
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 10
            periodSeconds: 20
      imagePullSecrets:
        - name: my-dockerhub-secret
```

### Why This Matters

- **Deployment** ensures the desired number of pods are running
- **imagePullSecrets** allows Kubernetes to authenticate to Docker Hub
- **Readiness probe** controls when traffic is sent to the pod
- **Liveness probe** restarts unhealthy containers automatically
- **Resource limits** protect cluster stability

---

## 🌐 Kubernetes Service

### `service.yml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nba-memes-service
spec:
  selector:
    app: nba-memes
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
```

### Service Explanation

- **NodePort** exposes the app outside the cluster
- **Selector** must match pod labels
- Traffic is routed from the node → service → pod

---

## 🚀 Deploy to Kubernetes

```bash
kubectl apply -f deployment.yml
kubectl apply -f service.yml
```

---

## 🔍 Verify Deployment

### Check Deployment

```bash
kubectl get deployments
```

### Check Pods

```bash
kubectl get pods
```

### Check Services

```bash
kubectl get svc
```

---

## 🌍 Access the Application

Using Minikube:

```bash
minikube service nba-memes-service
```

This opens the application in your browser.

---

## 🔄 How Everything Works Together

1. Docker image is built and pushed to **private Docker Hub**
2. Kubernetes pulls the image using **imagePullSecret**
3. Deployment ensures the pod is always running
4. Service exposes the application externally
5. Users can access the app via NodePort

---

## 🧠 Key Learnings

- How Kubernetes authenticates with private container registries
- Proper use of Deployments and Services
- Secure image pulling using secrets
- Real-world Kubernetes deployment workflow

---

## 📌 Future Improvements

- Use `LoadBalancer` service in cloud environments
- Add Horizontal Pod Autoscaling (HPA)
- Move secrets to a secrets manager
- Add CI/CD automation with Jenkins or GitHub Actions

---

## 🪪 License

This project is for learning and demonstration purposes.
