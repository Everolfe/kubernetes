@echo off
echo ==========================================
echo DEPLOYING TO MINIKUBE
echo ==========================================

echo.
echo [1/3] Building images in Docker Desktop...
docker-compose build
if %errorlevel% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo [2/3] Loading images into Minikube...
echo This may take a minute...

minikube image load authservice-app:latest
if %errorlevel% neq 0 echo WARNING: auth-service-app image not loaded!

minikube image load userservice-app:latest
if %errorlevel% neq 0 echo WARNING: user-service-app image not loaded!

minikube image load orderservice-app:latest
if %errorlevel% neq 0 echo WARNING: order-service-app image not loaded!

minikube image load paymentservice-app:latest
if %errorlevel% neq 0 echo WARNING: payment-service-app image not loaded!

minikube image load apigateway-app:latest
if %errorlevel% neq 0 echo WARNING: api-gateway-app image not loaded!

echo.
echo [3/3] Deploying with Helm...
helm uninstall microservices 2>nul
timeout /t 5 /nobreak >nul
helm install microservices ./k8s-chart --set appConfig.imagePullPolicy=Never

echo.
echo ==========================================
echo Done! Checking pods...
echo ==========================================
timeout /t 3 /nobreak >nul
kubectl get pods

echo.
echo If pods are still ErrImageNeverPull, check images in Minikube:
echo   minikube ssh "docker images ^| grep kubernetes"
pause