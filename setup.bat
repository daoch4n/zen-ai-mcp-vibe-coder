@echo off
REM Setup script for Vibe Coder MCP Server (Updated)

echo Setting up Vibe Coder MCP Server...
echo ==================================================

REM Check if npm is installed
where npm >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: npm is not installed. Please install Node.js and npm first.
    exit /b 1
)
echo npm is installed.

REM Check Node.js version (require v18+)
echo Checking Node.js version...
SET MAJOR_NODE_VERSION=
FOR /F "tokens=1 delims=v." %%a IN ('node -v') DO SET MAJOR_NODE_VERSION=%%a

powershell -Command "if ($env:MAJOR_NODE_VERSION -eq $null -or $env:MAJOR_NODE_VERSION -eq '') { Write-Warning 'Could not determine Node.js major version. Proceeding anyway...'; exit 0 } elseif ([int]$env:MAJOR_NODE_VERSION -lt 18) { Write-Error 'Node.js v18+ is required (found v$env:MAJOR_NODE_VERSION). Please upgrade Node.js.'; exit 1 } else { Write-Host \"Node.js version $env:MAJOR_NODE_VERSION detected (v18+ required) - OK.\"; exit 0 }"
if %ERRORLEVEL% neq 0 (
    exit /b 1
)

REM Install dependencies
echo Installing dependencies...
call npm install
if %ERRORLEVEL% neq 0 (
    echo ERROR: npm install failed. Check npm logs above.
    exit /b 1
)
echo Dependencies installed successfully.

REM Create required VibeCoderOutput directories (for tools that save files)
echo Creating required VibeCoderOutput directories...
if not exist "VibeCoderOutput" mkdir "VibeCoderOutput"
REM Original tool output dirs:
if not exist "VibeCoderOutput\research-manager" mkdir "VibeCoderOutput\research-manager"
if not exist "VibeCoderOutput\rules-generator" mkdir "VibeCoderOutput\rules-generator"
if not exist "VibeCoderOutput\prd-generator" mkdir "VibeCoderOutput\prd-generator"
if not exist "VibeCoderOutput\user-stories-generator" mkdir "VibeCoderOutput\user-stories-generator"
if not exist "VibeCoderOutput\task-list-generator" mkdir "VibeCoderOutput\task-list-generator"
if not exist "VibeCoderOutput\fullstack-starter-kit-generator" mkdir "VibeCoderOutput\fullstack-starter-kit-generator"
REM Additional tool output dirs:
if not exist "VibeCoderOutput\workflow-runner" mkdir "VibeCoderOutput\workflow-runner"
if not exist "VibeCoderOutput\code-map-generator" mkdir "VibeCoderOutput\code-map-generator"
REM New tools generally don't save files here by default.

REM Build TypeScript project
echo Building TypeScript project...
call npm run build
if %ERRORLEVEL% neq 0 (
    echo ERROR: TypeScript build failed (npm run build). Check compiler output above.
    exit /b 1
)
echo TypeScript project built successfully.

REM Check if .env file exists, copy from .env.example if not
echo Checking for .env file...
if not exist ".env" (
    if exist ".env.example" (
        echo Creating .env file from template (.env.example)...
        copy ".env.example" ".env" > nul
        echo IMPORTANT: .env file created from template. Please edit it now to add your required OPENROUTER_API_KEY.
    ) else (
        echo WARNING: .env file not found and .env.example template is missing. Cannot create .env. Please create it manually with your OPENROUTER_API_KEY.
    )
) else (
    echo .env file already exists. Skipping creation. (Ensure it contains OPENROUTER_API_KEY)
)

echo.
echo Setup script completed successfully!
echo ==================================================
echo Vibe Coder MCP Server is now set up with core features:
echo   - Planning & Documentation Tools (PRD, User Stories, Tasks, Rules)
echo   - Project Scaffolding (Fullstack Starter Kit)
echo   - Code Map Generator (semantic codebase analysis with Mermaid diagrams)
echo   - Research Manager (using configured models)
echo   - Workflow Runner (using workflows.json)
echo   - Job Result Retriever (for asynchronous task management)
echo   - Semantic Routing & Sequential Thinking (for specific tools)
echo   - Asynchronous Job Handling (JobManager, SSE Notifications) for long-running tools
echo.
echo IMPORTANT NEXT STEPS:
echo 1. If you haven't already, **edit the .env file** to add your valid OPENROUTER_API_KEY.
echo 2. Review the default models in `.env` (GEMINI_MODEL, PERPLEXITY_MODEL) and ensure they fit your needs/OpenRouter plan.
echo 3. Review workflow definitions in `workflows.json` if you plan to use the `run-workflow` tool.
echo 4. To run the server (using stdio for Claude Desktop): npm start
echo 5. To run the server (using SSE on http://localhost:3000): npm run start:sse
echo 6. For Claude Desktop integration, update its MCP settings using the current `mcp-config.json` and ensure the path in Claude's config points to `build/index.js`.
echo 7. Use the 'get-job-result' tool to retrieve outcomes from long-running asynchronous tasks.
echo.
