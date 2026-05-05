@echo off
echo Setting MINIKUBE_HOME to D:\.minikube...
set MINIKUBE_HOME=D:\.minikube
minikube start --cpus 4 --memory 7500
if %errorlevel% neq 0 (
    echo Error starting minikube!
    pause
    exit /b 1
)
echo Done!
pause