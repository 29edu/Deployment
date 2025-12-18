# Quick Deployment Script for Docker Desktop + Kubernetes
# Author: Configured for user 29edu

Write-Host "🚀 Fullstack App - Quick Deploy" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
$dockerRunning = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker is not running! Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Docker is running" -ForegroundColor Green

# Check if Kubernetes is enabled
$k8sRunning = kubectl cluster-info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Kubernetes is not enabled! Enable it in Docker Desktop settings." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Kubernetes is enabled" -ForegroundColor Green
Write-Host ""

# Menu
Write-Host "What would you like to do?" -ForegroundColor Yellow
Write-Host "1. Test locally with Docker Compose"
Write-Host "2. Build and push images to Docker Hub"
Write-Host "3. Deploy to Kubernetes"
Write-Host "4. Access application (port-forward)"
Write-Host "5. View status"
Write-Host "6. View logs"
Write-Host "7. Delete deployment"
Write-Host "0. Exit"
Write-Host ""

$choice = Read-Host "Enter your choice (0-7)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🐳 Starting Docker Compose..." -ForegroundColor Cyan
        docker-compose up --build
    }
    
    "2" {
        Write-Host ""
        Write-Host "🔑 Please login to Docker Hub first..." -ForegroundColor Yellow
        docker login
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "🔨 Building backend image..." -ForegroundColor Cyan
            docker build -t 29edu/fullstack-backend:latest ./backend
            
            Write-Host "📤 Pushing backend image..." -ForegroundColor Cyan
            docker push 29edu/fullstack-backend:latest
            
            Write-Host ""
            Write-Host "🔨 Building frontend image..." -ForegroundColor Cyan
            docker build -t 29edu/fullstack-frontend:latest ./frontend
            
            Write-Host "📤 Pushing frontend image..." -ForegroundColor Cyan
            docker push 29edu/fullstack-frontend:latest
            
            Write-Host ""
            Write-Host "✅ Images built and pushed successfully!" -ForegroundColor Green
            Write-Host "View at: https://hub.docker.com/u/29edu" -ForegroundColor Cyan
        }
    }
    
    "3" {
        Write-Host ""
        Write-Host "☸️ Deploying to Kubernetes..." -ForegroundColor Cyan
        
        kubectl apply -f k8s/namespace.yaml
        kubectl apply -f k8s/backend.yml
        kubectl apply -f k8s/frontend.yml
        
        Write-Host ""
        Write-Host "⏳ Waiting for pods to be ready..." -ForegroundColor Yellow
        kubectl wait --for=condition=ready pod -l app=backend --timeout=120s
        kubectl wait --for=condition=ready pod -l app=frontend --timeout=120s
        
        Write-Host ""
        Write-Host "✅ Deployment complete!" -ForegroundColor Green
        Write-Host ""
        kubectl get pods
        Write-Host ""
        Write-Host "💡 Next: Run option 4 to access the application" -ForegroundColor Cyan
    }
    
    "4" {
        Write-Host ""
        Write-Host "🌐 Starting port forward to frontend..." -ForegroundColor Cyan
        Write-Host "Access the app at: http://localhost:8080" -ForegroundColor Green
        Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
        Write-Host ""
        kubectl port-forward service/frontend-service 8080:80
    }
    
    "5" {
        Write-Host ""
        Write-Host "📊 Current Status:" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Pods:" -ForegroundColor Yellow
        kubectl get pods
        Write-Host ""
        Write-Host "Services:" -ForegroundColor Yellow
        kubectl get services
        Write-Host ""
        Write-Host "Deployments:" -ForegroundColor Yellow
        kubectl get deployments
    }
    
    "6" {
        Write-Host ""
        Write-Host "Which logs do you want to view?" -ForegroundColor Yellow
        Write-Host "1. Backend logs"
        Write-Host "2. Frontend logs"
        Write-Host "3. Both"
        Write-Host ""
        $logChoice = Read-Host "Enter your choice (1-3)"
        
        Write-Host ""
        switch ($logChoice) {
            "1" { kubectl logs -l app=backend --tail=50 -f }
            "2" { kubectl logs -l app=frontend --tail=50 -f }
            "3" { 
                Write-Host "Backend Logs:" -ForegroundColor Cyan
                kubectl logs -l app=backend --tail=20
                Write-Host ""
                Write-Host "Frontend Logs:" -ForegroundColor Cyan
                kubectl logs -l app=frontend --tail=20
            }
        }
    }
    
    "7" {
        Write-Host ""
        Write-Host "⚠️ This will delete all Kubernetes resources." -ForegroundColor Yellow
        $confirm = Read-Host "Are you sure? (yes/no)"
        
        if ($confirm -eq "yes") {
            Write-Host ""
            Write-Host "🗑️ Deleting resources..." -ForegroundColor Red
            kubectl delete -f k8s/frontend.yml
            kubectl delete -f k8s/backend.yml
            kubectl delete -f k8s/namespace.yaml
            Write-Host ""
            Write-Host "✅ Cleanup complete!" -ForegroundColor Green
        } else {
            Write-Host "❌ Cancelled" -ForegroundColor Yellow
        }
    }
    
    "0" {
        Write-Host ""
        Write-Host "👋 Goodbye!" -ForegroundColor Cyan
        exit 0
    }
    
    default {
        Write-Host ""
        Write-Host "❌ Invalid choice" -ForegroundColor Red
    }
}

Write-Host ""
