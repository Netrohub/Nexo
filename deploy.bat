@echo off
REM Nexo Windows Deployment Script
REM Handles React frontend deployment on Windows

setlocal enabledelayedexpansion

REM Colors (Windows doesn't support colors in batch, but we can use echo)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Configuration
set "PROJECT_NAME=Nexo Frontend"
set "BUILD_DIR=dist"
set "NODE_VERSION=18"

REM Functions
:log_info
echo %BLUE%ℹ️  %~1%NC%
goto :eof

:log_success
echo %GREEN%✅ %~1%NC%
goto :eof

:log_warning
echo %YELLOW%⚠️  %~1%NC%
goto :eof

:log_error
echo %RED%❌ %~1%NC%
goto :eof

REM Check if we're in the right directory
:check_project
if not exist "package.json" (
    call :log_error "package.json not found. Make sure you're in the project root."
    exit /b 1
)

if not exist "vite.config.ts" (
    call :log_error "vite.config.ts not found. This doesn't appear to be a Vite project."
    exit /b 1
)

call :log_success "Project structure verified"
goto :eof

REM Check Node.js version
:check_node
node --version >nul 2>&1
if errorlevel 1 (
    call :log_error "Node.js is not installed. Please install Node.js %NODE_VERSION%+"
    exit /b 1
)

call :log_success "Node.js version: "
node --version
goto :eof

REM Install dependencies
:install_dependencies
call :log_info "Installing dependencies..."

if exist "node_modules" (
    call :log_info "Cleaning existing node_modules..."
    rmdir /s /q node_modules
)

npm ci --production=false

call :log_success "Dependencies installed"
goto :eof

REM Set environment variables
:setup_environment
call :log_info "Setting up environment variables..."

if not defined VITE_API_BASE_URL set "VITE_API_BASE_URL=https://api.nxoland.com/api"
if not defined VITE_COMING_SOON_MODE set "VITE_COMING_SOON_MODE=false"
if not defined VITE_MOCK_API set "VITE_MOCK_API=false"

call :log_info "Environment variables:"
call :log_info "  VITE_API_BASE_URL: %VITE_API_BASE_URL%"
call :log_info "  VITE_COMING_SOON_MODE: %VITE_COMING_SOON_MODE%"
call :log_info "  VITE_MOCK_API: %VITE_MOCK_API%"
goto :eof

REM Build the project
:build_project
call :log_info "Building React application..."

if exist "%BUILD_DIR%" (
    call :log_info "Removing old build..."
    rmdir /s /q %BUILD_DIR%
)

npm run build

if not exist "%BUILD_DIR%" (
    call :log_error "Build failed. %BUILD_DIR% directory not found."
    exit /b 1
)

if not exist "%BUILD_DIR%\index.html" (
    call :log_error "Build output is incomplete. index.html not found."
    exit /b 1
)

call :log_success "Build completed successfully!"
goto :eof

REM Deploy to server
:deploy_to_server
if not defined DEPLOY_PATH (
    call :log_warning "DEPLOY_PATH not set. Skipping server deployment."
    goto :eof
)

call :log_info "Deploying to server: %DEPLOY_PATH%"

if not exist "%DEPLOY_PATH%" (
    mkdir "%DEPLOY_PATH%"
)

xcopy /E /I /Y "%BUILD_DIR%\*" "%DEPLOY_PATH%\"

call :log_success "Deployed to %DEPLOY_PATH%"
goto :eof

REM Create deployment package
:create_package
if "%CREATE_PACKAGE%"=="true" (
    call :log_info "Creating deployment package..."
    
    set "PACKAGE_NAME=nexo-frontend-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%.zip"
    set "PACKAGE_NAME=!PACKAGE_NAME: =0!"
    
    powershell -command "Compress-Archive -Path '%BUILD_DIR%\*' -DestinationPath '!PACKAGE_NAME!'"
    
    call :log_success "Package created: !PACKAGE_NAME!"
)
goto :eof

REM Main deployment function
:main
echo %BLUE%
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                  NEXO FRONTEND DEPLOYMENT                   ║
echo ║                    React + Vite Build                      ║
echo ╚══════════════════════════════════════════════════════════════╝
echo %NC%

REM Parse command line arguments
:parse_args
if "%~1"=="" goto :run_deployment
if "%~1"=="--deploy-path" (
    set "DEPLOY_PATH=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="--create-package" (
    set "CREATE_PACKAGE=true"
    shift
    goto :parse_args
)
if "%~1"=="--coming-soon" (
    set "VITE_COMING_SOON_MODE=true"
    shift
    goto :parse_args
)
if "%~1"=="--api-url" (
    set "VITE_API_BASE_URL=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="--help" (
    echo Usage: %0 [options]
    echo Options:
    echo   --deploy-path PATH    Deploy to specific path
    echo   --create-package     Create deployment package
    echo   --coming-soon        Enable coming soon mode
    echo   --api-url URL        Set API URL
    echo   --help               Show this help
    exit /b 0
)
call :log_error "Unknown option: %~1"
exit /b 1

:run_deployment
call :check_project
call :check_node
call :install_dependencies
call :setup_environment
call :build_project
call :deploy_to_server
call :create_package

echo %GREEN%
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                FRONTEND DEPLOYMENT COMPLETED!               ║
echo ║                                                              ║
echo ║  🎉 Your Nexo frontend has been built successfully!         ║
echo ║                                                              ║
echo ║  📁 Build output: %BUILD_DIR%/                              ║
echo ║  🌐 Ready for deployment to web server                      ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo %NC%

goto :eof

REM Run main function
call :main %*