# 🚀 Quick Commands - Copy & Paste

Your Docker Hub username: **29edu**

---

## Option 1: Use Interactive Script (Easiest)

```powershell
.\deploy.ps1
```

Then follow the menu!

---

## Option 2: Manual Commands

### 🧪 Test Locally

```powershell
docker-compose up --build
```

Access: http://localhost

Stop: `Ctrl+C` then `docker-compose down`

---

### 🐳 Build & Push to Docker Hub

```powershell
# Login
docker login

# Build & Push Backend
cd backend
docker build -t 29edu/fullstack-backend:latest .
docker push 29edu/fullstack-backend:latest

# Build & Push Frontend
cd ..\frontend
docker build -t 29edu/fullstack-frontend:latest .
docker push 29edu/fullstack-frontend:latest

cd ..
```

---

### ☸️ Deploy to Kubernetes

```powershell
# Deploy all
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/backend.yml
kubectl apply -f k8s/frontend.yml

# Check status
kubectl get pods -w
```

Wait until all pods show `Running` (press `Ctrl+C` to exit watch mode)

---

### 🌐 Access Application

```powershell
kubectl port-forward service/frontend-service 8080:80
```

Open: http://localhost:8080

(Keep terminal open while using the app)

---

### 📊 Monitor

```powershell
# View all resources
kubectl get all

# View logs (live)
kubectl logs -l app=backend -f
kubectl logs -l app=frontend -f

# Check pod status
kubectl get pods
kubectl describe pod <pod-name>
```

---

### 🔄 Update After Code Changes

```powershell
# Rebuild & push
docker build -t 29edu/fullstack-backend:latest ./backend
docker push 29edu/fullstack-backend:latest

# Restart deployment
kubectl rollout restart deployment/backend-deployment

# Check rollout
kubectl rollout status deployment/backend-deployment
```

---

### 🗑️ Delete Everything

```powershell
kubectl delete -f k8s/
```

---

## 🆘 Troubleshooting

### Pods not starting?

```powershell
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Can't access app?

```powershell
# Make sure port-forward is running
kubectl port-forward service/frontend-service 8080:80

# Or try different port
kubectl port-forward service/frontend-service 9090:80
```

### Need to reset?

```powershell
# Delete and redeploy
kubectl delete -f k8s/
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/backend.yml
kubectl apply -f k8s/frontend.yml
```

---

## 📚 Documentation

- **Full Guide:** [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- **Quick Start:** [QUICK_START.md](QUICK_START.md)

---

## ✅ Success Checklist

- [ ] Docker Desktop running
- [ ] Kubernetes enabled
- [ ] Tested with `docker-compose up`
- [ ] Logged in: `docker login`
- [ ] Built images
- [ ] Pushed to Docker Hub
- [ ] Deployed: `kubectl apply -f k8s/`
- [ ] Pods running: `kubectl get pods`
- [ ] Accessed app: `kubectl port-forward service/frontend-service 8080:80`
- [ ] App works at http://localhost:8080

Done! 🎉
