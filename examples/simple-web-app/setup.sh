#!/bin/bash

# Simple Web App Setup Script
# This script demonstrates how to start a task manager web app project using the Claude Orchestrator

set -e  # Exit on any error

PROJECT_NAME="task-manager-app"
PROJECT_PATH="${PWD}/${PROJECT_NAME}"
ORCHESTRATOR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "🚀 Setting up Simple Web App Example Project"
echo "============================================"

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "❌ Error: tmux is required but not installed"
    echo "   Install with: sudo apt install tmux (Ubuntu/Debian) or brew install tmux (macOS)"
    exit 1
fi

# Check if Claude CLI is available
if ! command -v claude &> /dev/null; then
    echo "❌ Error: Claude CLI is required but not found"
    echo "   Make sure Claude CLI is installed and in your PATH"
    exit 1
fi

# Check if Python is available for the orchestrator
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is required for the orchestrator"
    exit 1
fi

echo "✅ Prerequisites check passed"

# Create project directory structure
echo "📁 Creating project directory structure..."

if [ -d "$PROJECT_PATH" ]; then
    echo "⚠️  Project directory already exists: $PROJECT_PATH"
    read -p "Do you want to continue? This may overwrite existing files. (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 1
    fi
fi

mkdir -p "$PROJECT_PATH"
cd "$PROJECT_PATH"

# Create basic project structure
mkdir -p {frontend,backend,database,docs,tests,config}

# Create project specification file
echo "📄 Creating project specification..."
cp "${ORCHESTRATOR_DIR}/examples/simple-web-app/project_spec.md" "./project_spec.md"

# Create team configuration
echo "👥 Setting up team configuration..."
cp "${ORCHESTRATOR_DIR}/examples/simple-web-app/team_config.yaml" "./team_config.yaml"

# Create basic package.json files for frontend and backend
echo "📦 Creating package.json files..."

# Frontend package.json
cat > frontend/package.json << 'EOF'
{
  "name": "task-manager-frontend",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "test": "jest",
    "test:watch": "jest --watch",
    "lint": "eslint src --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "lint:fix": "eslint src --ext ts,tsx --fix"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.1",
    "@tanstack/react-query": "^4.24.6",
    "axios": "^1.3.4"
  },
  "devDependencies": {
    "@types/react": "^18.0.27",
    "@types/react-dom": "^18.0.10",
    "@vitejs/plugin-react": "^3.1.0",
    "typescript": "^4.9.3",
    "vite": "^4.1.0",
    "tailwindcss": "^3.2.7",
    "@types/jest": "^29.4.0",
    "jest": "^29.4.3",
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^5.16.5",
    "@testing-library/user-event": "^14.4.3",
    "eslint": "^8.35.0",
    "@typescript-eslint/eslint-plugin": "^5.54.0",
    "@typescript-eslint/parser": "^5.54.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.3.4"
  }
}
EOF

# Backend package.json
cat > backend/package.json << 'EOF'
{
  "name": "task-manager-backend",
  "version": "0.1.0",
  "main": "dist/server.js",
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "db:generate": "prisma generate",
    "db:push": "prisma db push",
    "db:migrate": "prisma migrate dev",
    "db:studio": "prisma studio",
    "lint": "eslint src --ext ts --report-unused-disable-directives --max-warnings 0",
    "lint:fix": "eslint src --ext ts --fix"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^6.0.1",
    "jsonwebtoken": "^9.0.0",
    "bcryptjs": "^2.4.3",
    "prisma": "^4.10.1",
    "@prisma/client": "^4.10.1",
    "zod": "^3.20.6",
    "dotenv": "^16.0.3"
  },
  "devDependencies": {
    "@types/node": "^18.14.2",
    "@types/express": "^4.17.17",
    "@types/cors": "^2.8.13",
    "@types/jsonwebtoken": "^9.0.1",
    "@types/bcryptjs": "^2.4.2",
    "@types/jest": "^29.4.0",
    "typescript": "^4.9.5",
    "tsx": "^3.12.3",
    "jest": "^29.4.3",
    "supertest": "^6.3.3",
    "@types/supertest": "^2.0.12",
    "eslint": "^8.35.0",
    "@typescript-eslint/eslint-plugin": "^5.54.0",
    "@typescript-eslint/parser": "^5.54.0"
  }
}
EOF

# Create basic TypeScript configs
echo "⚙️  Creating TypeScript configurations..."

# Frontend tsconfig.json
cat > frontend/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

# Backend tsconfig.json
cat > backend/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "node",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "allowSyntheticDefaultImports": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# Create Prisma schema
echo "🗄️  Creating database schema..."
mkdir -p backend/prisma

cat > backend/prisma/schema.prisma << 'EOF'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  password  String
  name      String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  tasks     Task[]
  
  @@map("users")
}

model Task {
  id          String    @id @default(cuid())
  title       String
  description String?
  completed   Boolean   @default(false)
  dueDate     DateTime?
  category    String?
  priority    Priority  @default(MEDIUM)
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt
  
  userId      String
  user        User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@map("tasks")
}

enum Priority {
  LOW
  MEDIUM
  HIGH
  URGENT
}
EOF

# Create environment file template
cat > backend/.env.example << 'EOF'
# Database
DATABASE_URL="postgresql://username:password@localhost:5432/taskmanager?schema=public"

# JWT Secret
JWT_SECRET="your-super-secret-jwt-key-change-this-in-production"

# Server
PORT=3001
NODE_ENV=development

# CORS
CORS_ORIGIN="http://localhost:3000"
EOF

# Create basic README
echo "📚 Creating README..."
cat > README.md << 'EOF'
# Task Manager Web App

A modern, responsive task management application built with React, Node.js, and PostgreSQL.

## 🚀 Quick Start

1. **Install Dependencies**
   ```bash
   # Frontend
   cd frontend && npm install
   
   # Backend  
   cd backend && npm install
   ```

2. **Setup Database**
   ```bash
   cd backend
   cp .env.example .env
   # Edit .env with your database credentials
   npm run db:push
   ```

3. **Start Development Servers**
   ```bash
   # Terminal 1 - Backend
   cd backend && npm run dev
   
   # Terminal 2 - Frontend
   cd frontend && npm run dev
   ```

## 📋 Features

- ✅ User authentication (signup/login)
- ✅ Create, edit, and delete tasks
- ✅ Mark tasks as complete/incomplete
- ✅ Organize tasks by categories and priority
- ✅ Responsive design for mobile and desktop
- ✅ Dark/light theme switching

## 🧪 Testing

```bash
# Frontend tests
cd frontend && npm test

# Backend tests
cd backend && npm test
```

## 📖 API Documentation

See `docs/api.md` for detailed API documentation.

## 🏗️ Architecture

- **Frontend**: React + TypeScript + Tailwind CSS
- **Backend**: Node.js + Express + TypeScript
- **Database**: PostgreSQL + Prisma ORM
- **Authentication**: JWT tokens
- **Testing**: Jest + React Testing Library + Supertest

## 🤝 Development Team

This project is managed by Claude AI agents:
- **Project Manager**: Quality assurance and coordination
- **Full-Stack Developer**: Implementation and technical decisions  
- **QA Engineer**: Testing and quality validation

## 📄 License

MIT License - see LICENSE file for details.
EOF

# Create Git repository
echo "📝 Initializing Git repository..."
git init
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
*/node_modules/

# Production builds
dist/
build/

# Environment files
.env
.env.local
.env.production

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# Database
*.db
*.sqlite

# Temporary files
.tmp/
temp/
EOF

git add .
git commit -m "Initial project setup with basic structure

- Frontend and backend package.json files
- TypeScript configurations
- Prisma database schema
- Basic project documentation
- Git repository initialized

🤖 Generated with Claude Orchestrator"

echo "✅ Project structure created successfully!"
echo ""
echo "📍 Project Location: $PROJECT_PATH"
echo ""
echo "🚀 Next Steps:"
echo "1. Start the Claude Orchestrator team:"
echo "   cd '$ORCHESTRATOR_DIR'"
echo "   ./orchestrator.py start $PROJECT_NAME '$PROJECT_PATH' --template startup-team"
echo ""
echo "2. Monitor the team's progress:"
echo "   tmux attach-session -t claude-$PROJECT_NAME"
echo ""
echo "3. Check project status anytime:"
echo "   ./orchestrator.py status --project $PROJECT_NAME"
echo ""
echo "🎯 The AI team will:"
echo "   - Set up the development environment"
echo "   - Implement authentication and task management"
echo "   - Create a responsive, modern UI"
echo "   - Write comprehensive tests"
echo "   - Deploy to production"
echo ""
echo "💡 Tip: Watch the tmux windows to see the agents collaborating in real-time!"

# Make the setup script executable
chmod +x setup.sh