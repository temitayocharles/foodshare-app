# 🤝 Contributing to FoodShare

Thank you for your interest in contributing to FoodShare! This document provides guidelines and information for contributors.

## 📋 Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Style Guidelines](#style-guidelines)
- [Community](#community)

## 🤝 Code of Conduct

This project follows a code of conduct to ensure a welcoming environment for all contributors. By participating, you agree to:

- Be respectful and inclusive
- Focus on constructive feedback
- Accept responsibility for mistakes
- Show empathy towards other contributors
- Help create a positive community

## 🚀 Getting Started

### Prerequisites
- Node.js 16+ and npm
- Docker and Docker Compose
- kubectl (for Kubernetes deployment)
- Git

### Quick Setup
```bash
# Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/foodshare-app.git
cd foodshare-app

# Install dependencies
npm run install:all

# Start development environment
npm run dev
```

## 💡 How to Contribute

### Types of Contributions
- 🐛 **Bug Fixes**: Fix existing issues
- ✨ **Features**: Add new functionality
- 📚 **Documentation**: Improve documentation
- 🎨 **UI/UX**: Enhance user interface
- 🧪 **Testing**: Add or improve tests
- 🔧 **Infrastructure**: Improve deployment and CI/CD

### Finding Issues
- Check the [Issues](../../issues) tab for open tasks
- Look for issues labeled `good first issue` or `help wanted`
- Comment on issues you'd like to work on

## 🛠️ Development Setup

### Local Development
```bash
# Install all dependencies
npm run install:all

# Start all services
npm run dev

# Or start services individually
npm run dev:frontend
npm run dev:backend
npm run dev:database
```

### Kubernetes Development
```bash
# Deploy to local Kubernetes
npm run k8s:deploy

# View logs
npm run k8s:logs

# Clean up
npm run k8s:cleanup
```

### Environment Variables
Create a `.env` file in the root directory:
```env
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/foodshare
JWT_SECRET=your-secret-key
```

## 🧪 Testing

### Running Tests
```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run specific test suite
npm run test:unit
npm run test:integration
npm run test:e2e
```

### Test Structure
```
tests/
├── unit/           # Unit tests
├── integration/    # Integration tests
├── e2e/           # End-to-end tests
└── fixtures/      # Test data
```

## 📝 Submitting Changes

### Commit Guidelines
We follow conventional commit format:

```bash
# Feature commits
git commit -m "feat: add user authentication"

# Bug fix commits
git commit -m "fix: resolve memory leak in data processing"

# Documentation
git commit -m "docs: update API documentation"

# Style changes
git commit -m "style: format code with prettier"
```

### Pull Request Process
1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature-name`
3. **Make** your changes and commit them
4. **Push** to your fork: `git push origin feature/your-feature-name`
5. **Create** a Pull Request with:
   - Clear title describing the change
   - Detailed description of what was changed
   - Screenshots for UI changes
   - Tests for new functionality

### PR Checklist
- [ ] Tests pass locally
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Commit messages are clear
- [ ] PR description is detailed
- [ ] Screenshots included for UI changes

## 🎨 Style Guidelines

### Code Style
- Use ESLint and Prettier configurations
- Follow JavaScript/React best practices
- Use meaningful variable and function names
- Add comments for complex logic

### File Organization
```
src/
├── components/     # React components
├── services/       # API services
├── utils/         # Utility functions
├── hooks/         # Custom React hooks
├── styles/        # CSS/SCSS files
└── types/         # TypeScript definitions
```

### Naming Conventions
- **Components**: PascalCase (e.g., `UserProfile.tsx`)
- **Functions**: camelCase (e.g., `getUserData()`)
- **Files**: kebab-case (e.g., `user-profile.tsx`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `API_BASE_URL`)

## 🌟 Recognition

Contributors will be:
- Listed in the repository's contributor list
- Mentioned in release notes
- Featured in our contributor spotlight
- Eligible for repository maintainer roles

## 📞 Getting Help

### Communication Channels
- **Issues**: For bugs and feature requests
- **Discussions**: For questions and general discussion
- **Pull Requests**: For code contributions

### Resources
- [API Documentation](./docs/api.md)
- [Architecture Overview](./architecture-diagram.md)
- [Deployment Guide](./docs/deployment.md)

## 🎉 Recognition

We appreciate all contributions, big and small! Every contributor helps make FoodShare better for the community.

**Thank you for contributing to FoodShare! 🚀**
