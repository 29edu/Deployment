# 🚀 Deployment Guide - Docker Desktop with Kubernetes

## ✅ Your Current Setup

- **Docker Desktop:** ✅ Installed
- **Kubernetes:** ✅ Enabled in Docker Desktop
- **Docker Hub Username:** `29edu`
- **All placeholder values:** ✅ Already updated!

---

## 📋 What You Have

Your DevOps project is now configured with:

- ✅ Backend API (Node.js + Express)
- ✅ Frontend UI (React + Vite)
- ✅ Docker containers for both services
- ✅ Kubernetes manifests ready to deploy
- ✅ CI/CD pipeline with Jenkins (optional)

---

## 🎯 Quick Deployment Steps

### STEP 1: Test Locally with Docker Compose (5 minutes)

This tests everything works before deploying to Kubernetes.

```powershell
# Make sure you're in the project directory
cd C:\Users\ASUS\Desktop\devops

# Start all services
docker-compose up --build
```

**What happens:**

- Backend starts on port 5000
- Frontend starts on port 80
- Services are connected via Docker network

**Test it:**

- Open browser: http://localhost
- You should see the Task Manager app
- Add a task, mark it complete, delete it
- Everything should work!

**Stop services:**

```powershell
# Press Ctrl+C to stop
# Then remove containers
docker-compose down
```

---

### STEP 2: Build and Push Docker Images (10 minutes)

Push your images to Docker Hub so Kubernetes can pull them.

#### 2.1 Login to Docker Hub

```powershell
docker login
# Username: 29edu
# Password: [your Docker Hub password]
```

#### 2.2 Build Images

```powershell
# Backend
cd backend
docker build -t 29edu/fullstack-backend:latest .
docker tag 29edu/fullstack-backend:latest 29edu/fullstack-backend:v1.0

# Frontend
cd ..\frontend
docker build -t 29edu/fullstack-frontend:latest .
docker tag 29edu/fullstack-frontend:latest 29edu/fullstack-frontend:v1.0
```

#### 2.3 Push to Docker Hub

```powershell
docker push 29edu/fullstack-backend:latest
docker push 29edu/fullstack-backend:v1.0
docker push 29edu/fullstack-frontend:latest
docker push 29edu/fullstack-frontend:v1.0
```

**Verify:** Go to https://hub.docker.com/u/29edu and you should see both images!

---

### STEP 3: Deploy to Kubernetes (5 minutes)

Now deploy to your local Kubernetes cluster in Docker Desktop.

#### 3.1 Verify Kubernetes is Running

```powershell
kubectl cluster-info
kubectl get nodes
```

**Expected output:**

```
NAME             STATUS   ROLES           AGE   VERSION
docker-desktop   Ready    control-plane   ...   ...
```

#### 3.2 Deploy Application

```powershell
# Go back to project root
cd C:\Users\ASUS\Desktop\devops

# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy backend
kubectl apply -f k8s/backend.yml

# Deploy frontend
kubectl apply -f k8s/frontend.yml

# Optional: Apply ingress (skip for now)
# kubectl apply -f k8s/ingress.yaml
```

#### 3.3 Check Deployment Status

```powershell
# Watch pods starting (wait until all are Running)
kubectl get pods -w

# Press Ctrl+C when done watching

# Check services
kubectl get services

# Check deployments
kubectl get deployments
```

**Expected output:**

```
NAME                       READY   STATUS    RESTARTS   AGE
backend-deployment-xxx     1/1     Running   0          30s
frontend-deployment-xxx    1/1     Running   0          30s
```

---

### STEP 4: Access Your Application (2 minutes)

Since you're using Docker Desktop, use port forwarding to access the app.

#### Option A: Port Forward Frontend (Recommended)

```powershell
kubectl port-forward service/frontend-service 8080:80
```

**Access:** http://localhost:8080

Keep this terminal open while using the app!

#### Option B: Port Forward Both Services

```powershell
# Terminal 1 - Frontend
kubectl port-forward service/frontend-service 8080:80

# Terminal 2 - Backend (for direct API access)
kubectl port-forward service/backend-service 5000:5000
```

**Access:**

- Frontend: http://localhost:8080
- Backend API: http://localhost:5000
- Health Check: http://localhost:5000/health

#### Option C: Change Service Type to NodePort

```powershell
# Edit frontend service
kubectl patch service frontend-service -p '{"spec":{"type":"NodePort"}}'

# Get the NodePort
kubectl get service frontend-service
```

**Access:** http://localhost:[NodePort]

---

## 🎨 Using the Application

Once you access http://localhost:8080:

1. **Add Task:** Type a task name and click "Add Task"
2. **Complete Task:** Click the checkbox to mark as done
3. **Delete Task:** Click "Delete" button
4. **View All Tasks:** Automatically loads on page load

The frontend talks to the backend API to manage tasks!

---

## 🔍 Monitoring & Debugging

### View Logs

```powershell
# Backend logs (live)
kubectl logs -l app=backend -f

# Frontend logs (live)
kubectl logs -l app=frontend -f

# Specific pod
kubectl logs <pod-name>
```

### Check Pod Details

```powershell
# Describe pod (shows events, errors)
kubectl describe pod <pod-name>

# Get all pods with more info
kubectl get pods -o wide
```

### Check Health

```powershell
# Backend health check
kubectl port-forward service/backend-service 5000:5000
# Then visit: http://localhost:5000/health
```

### Resource Usage

```powershell
kubectl top pods
kubectl top nodes
```

---

## 🔄 Making Changes & Updates

### After Code Changes

#### Method 1: Rebuild and Push

```powershell
# Make your code changes, then:

# Build new version
cd backend
docker build -t 29edu/fullstack-backend:v1.1 .
docker push 29edu/fullstack-backend:v1.1

# Update Kubernetes
kubectl set image deployment/backend-deployment backend=29edu/fullstack-backend:v1.1

# Check rollout
kubectl rollout status deployment/backend-deployment
```

#### Method 2: Delete and Reapply

```powershell
# Delete deployment
kubectl delete deployment backend-deployment

# Rebuild image
docker build -t 29edu/fullstack-backend:latest ./backend
docker push 29edu/fullstack-backend:latest

# Reapply
kubectl apply -f k8s/backend.yml
```

#### Method 3: Force Update

```powershell
# If using :latest tag
docker build -t 29edu/fullstack-backend:latest ./backend
docker push 29edu/fullstack-backend:latest

# Force pod restart
kubectl rollout restart deployment/backend-deployment
```

---

## 🧹 Cleanup Commands

### Stop Port Forwarding

Press `Ctrl+C` in the terminal running port-forward

### Delete All Kubernetes Resources

```powershell
kubectl delete -f k8s/backend.yml
kubectl delete -f k8s/frontend.yml
kubectl delete -f k8s/namespace.yaml
```

### Or Delete Everything

```powershell
kubectl delete all --all
```

### Remove Docker Images

```powershell
docker images
docker rmi 29edu/fullstack-backend:latest
docker rmi 29edu/fullstack-frontend:latest
```

### Full Cleanup

```powershell
# Remove all stopped containers
docker container prune -f

# Remove all unused images
docker image prune -a -f

# Remove all unused volumes
docker volume prune -f
```

---

## 🐛 Common Issues & Solutions

### Issue: Pods stuck in "ImagePullBackOff"

**Solution:**

```powershell
# Make sure you pushed images to Docker Hub
docker push 29edu/fullstack-backend:latest
docker push 29edu/fullstack-frontend:latest

# Verify images exist
docker images | grep 29edu

# Check pod events
kubectl describe pod <pod-name>
```

### Issue: Pods in "CrashLoopBackOff"

**Solution:**

```powershell
# Check logs for errors
kubectl logs <pod-name>

# Common causes:
# - Port already in use
# - Missing dependencies
# - Configuration errors
```

### Issue: Can't access application

**Solution:**

```powershell
# Verify pods are running
kubectl get pods

# Verify services exist
kubectl get services

# Test backend directly
kubectl port-forward service/backend-service 5000:5000
# Visit: http://localhost:5000/health

# Check if port is already in use
netstat -ano | findstr :8080
```

### Issue: Frontend can't reach backend

**Solution:**

- In Kubernetes, the frontend nginx config uses `backend-service:5000`
- This is already configured in `frontend/nginx.conf`
- Make sure backend service is running: `kubectl get service backend-service`

### Issue: Kubernetes not responding

**Solution:**

```powershell
# Restart Docker Desktop
# Or reset Kubernetes cluster:
# Docker Desktop → Settings → Kubernetes → Reset Kubernetes Cluster
```

---

## 📊 Useful Commands Reference

### Kubernetes Basics

```powershell
kubectl get all                        # See everything
kubectl get pods                       # List pods
kubectl get services                   # List services
kubectl get deployments                # List deployments
kubectl describe pod <name>           # Pod details
kubectl logs <pod-name>               # View logs
kubectl logs <pod-name> -f            # Follow logs
kubectl exec -it <pod-name> -- sh     # Shell into pod
kubectl delete pod <name>             # Delete pod (recreates)
```

### Deployment Management

```powershell
kubectl rollout status deployment/<name>   # Check rollout
kubectl rollout restart deployment/<name>  # Restart deployment
kubectl rollout undo deployment/<name>     # Rollback
kubectl scale deployment/<name> --replicas=5  # Scale
```

### Troubleshooting

```powershell
kubectl get events                         # Cluster events
kubectl get pods --all-namespaces         # All pods
kubectl describe node docker-desktop      # Node details
kubectl top pods                          # Resource usage
```

---

## 🎯 Next Steps

### 1. Make It Production-Ready

- [ ] Add persistent storage (volumes) for data
- [ ] Set up proper environment variables
- [ ] Configure resource limits
- [ ] Add monitoring (Prometheus + Grafana)
- [ ] Set up logging (ELK stack)

### 2. Add More Features

- [ ] Database (MongoDB, PostgreSQL)
- [ ] Redis cache
- [ ] Authentication (JWT)
- [ ] File uploads
- [ ] WebSockets

### 3. Setup CI/CD with Jenkins (Optional)

- Install Jenkins locally or use cloud version
- Configure credentials
- Run automated deployments
- See Jenkins section in original guide

### 4. Deploy to Cloud (When Ready)

- AWS EKS
- Google GKE
- Azure AKS
- DigitalOcean Kubernetes

---

## ✅ Success Checklist

- [ ] ✅ Docker Desktop installed and running
- [ ] ✅ Kubernetes enabled in Docker Desktop
- [ ] ✅ Docker Hub username configured (29edu)
- [ ] ✅ Tested locally with docker-compose
- [ ] ✅ Built Docker images
- [ ] ✅ Pushed images to Docker Hub
- [ ] ✅ Deployed to Kubernetes
- [ ] ✅ Pods running successfully
- [ ] ✅ Can access application via port-forward
- [ ] ✅ Application works (add/complete/delete tasks)

---

## 🎉 You're Done!

Your fullstack application is now:

- ✅ Running in Kubernetes on Docker Desktop
- ✅ Containerized with Docker
- ✅ Scalable and production-ready architecture
- ✅ Ready for cloud deployment when needed

**Quick Access:**

```powershell
kubectl port-forward service/frontend-service 8080:80
```

Then visit: http://localhost:8080

---

## 💡 Pro Tips

1. **Keep images updated:** Regularly push new versions with version tags (v1.0, v1.1, etc.)
2. **Use labels:** Already configured in your deployments for easy filtering
3. **Monitor logs:** Check logs regularly to catch issues early
4. **Test locally first:** Always test with docker-compose before Kubernetes
5. **Backup configs:** Keep your k8s/\*.yml files in git (already done!)

---

## 📚 Additional Resources

- Docker Desktop Docs: https://docs.docker.com/desktop/
- Kubernetes Docs: https://kubernetes.io/docs/
- Docker Hub: https://hub.docker.com/u/29edu
- kubectl Cheat Sheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

Need help? Check the troubleshooting section or review pod logs!

Before deploying, ensure you have:

1. **Docker Hub Account**

   - Create account at https://hub.docker.com
   - Note your username (e.g., "johndoe")

2. **Docker Desktop** (for local testing)

   - Install from https://www.docker.com/products/docker-desktop

3. **Jenkins Server** (for CI/CD)

   - Installed and running
   - Docker plugin installed
   - Kubernetes plugin installed

4. **Kubernetes Cluster** (for production deployment)

   - Options: Minikube (local), AWS EKS, Google GKE, Azure AKS, DigitalOcean
   - kubectl CLI installed and configured

5. **Domain Name** (optional, for ingress)
   - If you have a domain, configure DNS to point to your cluster
   - Otherwise, use NodePort or LoadBalancer service types

---

## 🔧 STEP 1: Replace Placeholder Values

### Files to Update:

#### 1️⃣ **jenkinsfile** (Line 5)

**Current:**

```groovy
DOCKERHUB_USERNAME = "YOUR_DOCKERHUB_USERNAME"
```

**Replace with your Docker Hub username:**

```groovy
DOCKERHUB_USERNAME = "your-dockerhub-username"
```

Example: `DOCKERHUB_USERNAME = "johndoe"`

---

#### 2️⃣ **k8s/backend.yml** (Line 19)

**Current:**

```yaml
image: YOUR_DOCKERHUB_USERNAME/fullstack-backend:latest
```

**Replace with:**

```yaml
image: your-dockerhub-username/fullstack-backend:latest
```

Example: `image: johndoe/fullstack-backend:latest`

---

#### 3️⃣ **k8s/frontend.yml** (Line 19)

**Current:**

```yaml
image: YOUR_DOCKERHUB_USERNAME/fullstack-frontend:latest
```

**Replace with:**

```yaml
image: your-dockerhub-username/fullstack-frontend:latest
```

Example: `image: johndoe/fullstack-frontend:latest`

---

#### 4️⃣ **k8s/ingress.yaml** (Lines 12, 13, 16, 26)

**If you have a domain:**
Replace all instances of `YOUR_DOMAIN.com` with your actual domain

```yaml
- your-actual-domain.com
- www.your-actual-domain.com
```

Example: `example.com` and `www.example.com`

**If you DON'T have a domain:**
You can skip using ingress and access services directly via LoadBalancer or NodePort

---

## 🧪 STEP 2: Test Locally with Docker Compose

Before deploying to production, test locally:

### 2.1 Create .env files (optional)

```powershell
# Backend
cd backend
Copy-Item .env.example .env

# Frontend
cd ../frontend
Copy-Item .env.example .env
```

### 2.2 Build and run with Docker Compose

```powershell
# From project root
docker-compose up --build
```

### 2.3 Access the application

- **Frontend:** http://localhost
- **Backend API:** http://localhost:5000
- **Backend Health:** http://localhost:5000/health

### 2.4 Test the functionality

- Add tasks in the UI
- Mark tasks as complete
- Delete tasks
- Verify API is working

### 2.5 Stop services

```powershell
docker-compose down
```

---

## 🐳 STEP 3: Push Images to Docker Hub (Manual)

If you want to test without Jenkins first:

### 3.1 Login to Docker Hub

```powershell
docker login
# Enter your Docker Hub username and password
```

### 3.2 Build images

```powershell
# Backend
cd backend
docker build -t your-dockerhub-username/fullstack-backend:latest .

# Frontend
cd ../frontend
docker build -t your-dockerhub-username/fullstack-frontend:latest .
```

### 3.3 Push images

```powershell
docker push your-dockerhub-username/fullstack-backend:latest
docker push your-dockerhub-username/fullstack-frontend:latest
```

---

## ☸️ STEP 4: Deploy to Kubernetes

### 4.1 Verify kubectl is configured

```powershell
kubectl cluster-info
kubectl get nodes
```

### 4.2 Apply Kubernetes manifests

```powershell
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy backend
kubectl apply -f k8s/backend.yml

# Deploy frontend
kubectl apply -f k8s/frontend.yml

# Apply ingress (if you have a domain)
kubectl apply -f k8s/ingress.yaml
```

### 4.3 Check deployment status

```powershell
# Check pods
kubectl get pods

# Check services
kubectl get services

# Check deployments
kubectl get deployments

# Get detailed pod info
kubectl describe pods
```

### 4.4 Wait for pods to be ready

```powershell
kubectl rollout status deployment/backend-deployment
kubectl rollout status deployment/frontend-deployment
```

### 4.5 Access the application

**Option A: Using LoadBalancer (if supported)**

```powershell
kubectl get service frontend-service
# Note the EXTERNAL-IP and access via browser
```

**Option B: Using Port Forward (local testing)**

```powershell
# Frontend
kubectl port-forward service/frontend-service 8080:80

# Backend
kubectl port-forward service/backend-service 5000:5000

# Access: http://localhost:8080
```

**Option C: Using Ingress (if configured with domain)**

- Access via your domain: https://your-domain.com

---

## 🔄 STEP 5: Setup Jenkins CI/CD Pipeline

### 5.1 Install Jenkins Plugins

- Docker Pipeline
- Kubernetes CLI
- Git

### 5.2 Configure Jenkins Credentials

#### Docker Hub Credentials:

1. Jenkins → Manage Jenkins → Credentials
2. Add Credentials → Username with password
3. ID: `dockerhub-credentials`
4. Username: your Docker Hub username
5. Password: your Docker Hub password/token

#### Kubeconfig Credentials:

1. Get your kubeconfig file (usually `~/.kube/config`)
2. Jenkins → Manage Jenkins → Credentials
3. Add Credentials → Secret file
4. ID: `kubeconfig`
5. Upload your kubeconfig file

### 5.3 Create Jenkins Pipeline Job

1. New Item → Pipeline
2. Pipeline → Definition: "Pipeline script from SCM"
3. SCM: Git
4. Repository URL: https://github.com/29edu/Deployment.git
5. Script Path: `jenkinsfile`
6. Save

### 5.4 Run Pipeline

1. Click "Build Now"
2. Monitor console output
3. Pipeline will:
   - Checkout code
   - Test backend & frontend
   - Build Docker images
   - Push to Docker Hub
   - Deploy to Kubernetes
   - Verify deployment

---

## 🔍 STEP 6: Verify and Monitor

### 6.1 Check application health

```powershell
# Backend health
curl http://your-backend-url/health

# Frontend health
curl http://your-frontend-url/health
```

### 6.2 View logs

```powershell
# Backend logs
kubectl logs -l app=backend --tail=50 -f

# Frontend logs
kubectl logs -l app=frontend --tail=50 -f
```

### 6.3 Check resource usage

```powershell
kubectl top pods
kubectl top nodes
```

---

## 🐛 Troubleshooting

### Pods not starting?

```powershell
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Image pull errors?

- Verify Docker Hub credentials
- Ensure images are public or credentials are configured
- Check image names match exactly

### Connection refused errors?

- Verify services are running: `kubectl get services`
- Check service endpoints: `kubectl get endpoints`
- Verify network policies

### Frontend can't reach backend?

- In Kubernetes, use service names (e.g., `backend-service:5000`)
- Check nginx.conf proxy settings
- Verify backend service is running

---

## 📊 Monitoring URLs

Once deployed, access:

- **Frontend UI:** http://your-domain.com or http://EXTERNAL-IP
- **Backend API:** http://your-domain.com/api/tasks
- **Health Check:** http://your-domain.com/health

---

## 🔄 Making Updates

### After code changes:

```powershell
# Commit to GitHub
git add .
git commit -m "Your changes"
git push origin main

# Jenkins will automatically trigger the pipeline
# Or trigger manually in Jenkins UI
```

### Manual update:

```powershell
# Build new images
docker build -t your-username/fullstack-backend:v2 ./backend
docker build -t your-username/fullstack-frontend:v2 ./frontend

# Push to Docker Hub
docker push your-username/fullstack-backend:v2
docker push your-username/fullstack-frontend:v2

# Update Kubernetes
kubectl set image deployment/backend-deployment backend=your-username/fullstack-backend:v2
kubectl set image deployment/frontend-deployment frontend=your-username/fullstack-frontend:v2
```

---

## 📝 Quick Command Reference

```powershell
# Local Development
docker-compose up --build          # Start locally
docker-compose down                # Stop locally

# Docker
docker login                       # Login to Docker Hub
docker build -t name:tag .        # Build image
docker push name:tag              # Push image

# Kubernetes
kubectl get all                   # See all resources
kubectl get pods                  # List pods
kubectl get services              # List services
kubectl logs <pod-name>          # View logs
kubectl describe pod <pod-name>  # Pod details
kubectl delete pod <pod-name>    # Delete pod (will recreate)
kubectl rollout restart deployment/backend-deployment  # Restart deployment

# Cleanup
kubectl delete -f k8s/           # Delete all k8s resources
docker system prune -a           # Clean Docker
```

---

## ✅ Checklist

- [ ] Updated Docker Hub username in all files
- [ ] Updated domain name in ingress.yaml (or disabled ingress)
- [ ] Tested locally with docker-compose
- [ ] Pushed images to Docker Hub
- [ ] Deployed to Kubernetes
- [ ] Verified pods are running
- [ ] Tested application functionality
- [ ] Configured Jenkins credentials
- [ ] Tested Jenkins pipeline
- [ ] Set up monitoring/logging

---

## 🎉 Success!

Your fullstack application should now be:

- ✅ Running in Kubernetes
- ✅ Accessible via LoadBalancer/Ingress
- ✅ Auto-deploying via Jenkins CI/CD
- ✅ Production-ready with health checks and monitoring

Need help? Check the troubleshooting section or review pod logs!
