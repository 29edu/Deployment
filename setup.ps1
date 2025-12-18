# Quick Setup Script
# This script helps you replace placeholder values

Write-Host "🚀 Fullstack DevOps - Quick Setup" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Get Docker Hub username
$dockerUsername = Read-Host "Enter your Docker Hub username"

if ([string]::IsNullOrWhiteSpace($dockerUsername)) {
    Write-Host "❌ Docker Hub username is required!" -ForegroundColor Red
    exit 1
}

# Ask about domain
$hasDomain = Read-Host "Do you have a domain name? (y/n)"

$domainName = ""
if ($hasDomain -eq "y" -or $hasDomain -eq "Y") {
    $domainName = Read-Host "Enter your domain name (e.g., example.com)"
}

Write-Host ""
Write-Host "📝 Updating files..." -ForegroundColor Yellow
Write-Host ""

# Update jenkinsfile
$jenkinsfile = "jenkinsfile"
if (Test-Path $jenkinsfile) {
    $content = Get-Content $jenkinsfile -Raw
    $content = $content -replace 'YOUR_DOCKERHUB_USERNAME', $dockerUsername
    Set-Content $jenkinsfile -Value $content
    Write-Host "✅ Updated: $jenkinsfile" -ForegroundColor Green
}

# Update k8s/backend.yml
$backendFile = "k8s\backend.yml"
if (Test-Path $backendFile) {
    $content = Get-Content $backendFile -Raw
    $content = $content -replace 'YOUR_DOCKERHUB_USERNAME', $dockerUsername
    Set-Content $backendFile -Value $content
    Write-Host "✅ Updated: $backendFile" -ForegroundColor Green
}

# Update k8s/frontend.yml
$frontendFile = "k8s\frontend.yml"
if (Test-Path $frontendFile) {
    $content = Get-Content $frontendFile -Raw
    $content = $content -replace 'YOUR_DOCKERHUB_USERNAME', $dockerUsername
    Set-Content $frontendFile -Value $content
    Write-Host "✅ Updated: $frontendFile" -ForegroundColor Green
}

# Update k8s/ingress.yaml if domain provided
if (-not [string]::IsNullOrWhiteSpace($domainName)) {
    $ingressFile = "k8s\ingress.yaml"
    if (Test-Path $ingressFile) {
        $content = Get-Content $ingressFile -Raw
        $content = $content -replace 'YOUR_DOMAIN\.com', $domainName
        Set-Content $ingressFile -Value $content
        Write-Host "✅ Updated: $ingressFile" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "✨ Setup Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Summary:" -ForegroundColor Cyan
Write-Host "  Docker Hub Username: $dockerUsername"
if (-not [string]::IsNullOrWhiteSpace($domainName)) {
    Write-Host "  Domain Name: $domainName"
}
Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Test locally: docker-compose up --build"
Write-Host "  2. Login to Docker Hub: docker login"
Write-Host "  3. Review DEPLOYMENT_GUIDE.md for detailed instructions"
Write-Host ""
