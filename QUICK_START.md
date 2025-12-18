# 🚀 Quick Start Guide

## ✅ Setup Complete!

Your configuration is ready:

- **Docker Hub Username:** `29edu` ✅
- **Docker Desktop:** Installed ✅
- **Kubernetes:** Enabled ✅
- **All files configured:** ✅

---

## 🎯 3-Step Deployment

### STEP 1: Test Locally (2 minutes)

```powershell
# Start services
docker-compose up --build

# Open browser: http://localhost
# Test the task manager app

# Stop services (Ctrl+C, then:)
docker-compose down
```

---

### STEP 2: Push to Docker Hub (5 minutes)

```powershell
# Login
docker login
# Username: 29edu
# Password: [your password]

# Build and push backend
cd backend
docker build -t 29edu/fullstack-backend:latest .
docker push 29edu/fullstack-backend:latest

# Build and push frontend
cd ..\frontend
docker build -t 29edu/fullstack-frontend:latest .
docker push 29edu/fullstack-frontend:latest

cd ..
```

---

### STEP 3: Deploy to Kubernetes (3 minutes)

```powershell
# Deploy everything
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/backend.yml
kubectl apply -f k8s/frontend.yml

# Wait for pods to be ready
kubectl get pods -w
# Press Ctrl+C when all are Running

# Access the app
kubectl port-forward service/frontend-service 8080:80
```

**Open browser:** http://localhost:8080

---

## 🎨 Your Application

**Task Manager Features:**

- ➕ Add new tasks
- ✅ Mark tasks as complete
- 🗑️ Delete tasks
- 📋 View all tasks

---

## 📝 Useful Commands

```powershell
# View logs
kubectl logs -l app=backend -f
kubectl logs -l app=frontend -f

# Check status
kubectl get pods
kubectl get services

# Stop port forward
# Press Ctrl+C

# Delete everything
kubectl delete -f k8s/
```

---

## 🆘 Troubleshooting

**Pods not starting?**

```powershell
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

**Can't access app?**

```powershell
# Make sure port-forward is running
kubectl port-forward service/frontend-service 8080:80

# Check if port 8080 is available
netstat -ano | findstr :8080
```

**Images not pulling?**

```powershell
# Make sure you pushed images
docker push 29edu/fullstack-backend:latest
docker push 29edu/fullstack-frontend:latest

# Verify on Docker Hub
# Visit: https://hub.docker.com/u/29edu
```

---

## 📚 Full Guide

See **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** for:

- Detailed explanations
- Monitoring and debugging
- Making updates
- CI/CD with Jenkins
- Production deployment tips

---

## ✅ Checklist

- [x] Docker Desktop installed
- [x] Kubernetes enabled
- [x] Docker Hub username configured (29edu)
- [ ] Tested with docker-compose
- [ ] Images pushed to Docker Hub
- [ ] Deployed to Kubernetes
- [ ] Application accessible at http://localhost:8080

---

## 🎉 Success!

Once deployed, your app will be running in Kubernetes with:

- 3 backend pods (auto-healing, load-balanced)
- 3 frontend pods (auto-healing, load-balanced)
- Health checks and resource limits
- Production-ready architecture

### 1. Docker Hub Username

Replace `YOUR_DOCKERHUB_USERNAME` in these files:

- [ ] **jenkinsfile** (line 5)
- [ ] **k8s/backend.yml** (line 19)
- [ ] **k8s/frontend.yml** (line 19)

**Your Docker Hub username:** **\*\*\*\***\_**\*\*\*\***

### 2. Domain Name (Optional)

Replace `YOUR_DOMAIN.com` in:

- [ ] **k8s/ingress.yaml** (lines 12, 13, 16, 26)

**Your domain:** **\*\*\*\***\_**\*\*\*\***

_Skip this if you don't have a domain - use LoadBalancer or NodePort instead_

---

## 🚀 QUICK START OPTIONS

### OPTION A: Use PowerShell Script (Easiest)

```powershell
.\setup.ps1
```

This script will prompt for your values and update all files automatically.

---

### OPTION B: Manual Update

1. Open each file listed above
2. Find and replace the placeholder text
3. Save the files

---

## 📝 Example

If your Docker Hub username is **"johndoe"**:

**Before:**

```yaml
image: YOUR_DOCKERHUB_USERNAME/fullstack-backend:latest
```

**After:**

```yaml
image: johndoe/fullstack-backend:latest
```

---

## 🧪 Test Locally First

```powershell
# 1. Build and start services
docker-compose up --build

# 2. Open browser to http://localhost

# 3. Test the task manager app

# 4. Stop services
docker-compose down
```

---

## 📚 Full Documentation

See **DEPLOYMENT_GUIDE.md** for:

- Complete deployment steps
- Kubernetes setup
- Jenkins CI/CD configuration
- Troubleshooting tips
- Production deployment

---

## ✅ Deployment Checklist

- [ ] Replaced Docker Hub username
- [ ] Replaced domain name (if applicable)
- [ ] Tested locally with docker-compose
- [ ] Docker login completed
- [ ] Images pushed to Docker Hub
- [ ] Kubernetes cluster ready
- [ ] Deployed to Kubernetes
- [ ] Application accessible and working
