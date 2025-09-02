# FoodShare Application - Isolated Repository

This is the **isolated FoodShare application** repository, completely separated from the TC Enterprise DevOps Platform lab infrastructure.

## 📁 Directory Structure

```
foodshare-app/
├── app/                    # Core application code
│   ├── App.js             # React frontend
│   ├── index.html         # Frontend HTML
│   ├── index.js           # Frontend entry point
│   ├── server.js          # Node.js backend
│   ├── package.json       # Backend dependencies
│   ├── backend.Dockerfile # Backend container
│   ├── backend.yaml       # Backend deployment
│   ├── frontend-package.json
│   ├── frontend.Dockerfile
│   ├── frontend.yaml
│   ├── ingress.yaml
│   └── postgres.yaml
├── docs/                  # Documentation
│   ├── README.md
│   ├── CONTRIBUTING.md
│   ├── KUBERNETES-LAB-PRESENTATION.md
│   └── *.md files
├── demo/                  # Demo and presentation materials
│   ├── screenshots/
│   ├── post1-visual.html
│   ├── post2-visual.html
│   ├── post3-visual.html
│   ├── post4-visual.html
│   └── post5-visual.html
└── public/                # Public repository files
    ├── .git/
    ├── .github/
    ├── .gitignore
    ├── generate-visuals-fixed.sh
    ├── linkedin-posts.md
    └── *.yaml, *.sh, *.txt files
```

## 🚀 Quick Start

### Development Setup
```bash
cd app/
npm install
npm start
```

### Production Deployment
```bash
cd app/
kubectl apply -f postgres.yaml
kubectl apply -f backend.yaml
kubectl apply -f frontend.yaml
kubectl apply -f ingress.yaml
```

## 🔄 Working with the Lab

This application is **completely isolated** from the TC Enterprise DevOps Platform lab. You can:

1. **Develop independently** - Make changes without affecting the lab
2. **Deploy to any cluster** - Use with your lab or any Kubernetes cluster
3. **Version control separately** - Independent git history and releases
4. **Share publicly** - Push to GitHub without lab-specific configurations

## 🔗 Integration with Lab

To deploy this application to your lab:

```bash
# From the lab directory
kubectl apply -f /path/to/foodshare-app/app/postgres.yaml
kubectl apply -f /path/to/foodshare-app/app/backend.yaml
kubectl apply -f /path/to/foodshare-app/app/frontend.yaml
kubectl apply -f /path/to/foodshare-app/app/ingress.yaml
```

## 📝 Development Guidelines

### Local Changes vs Lab Changes
- **Local changes**: Keep in this isolated repository
- **Lab-specific changes**: Make in the TC Enterprise DevOps Platform repository
- **Shared changes**: Coordinate between repositories as needed

### Resource Constraints
If you encounter resource constraints:
1. Use the minimal cluster configuration
2. Scale down PostgreSQL resources
3. Deploy only essential components

## 🎯 Next Steps

1. **Initialize git** in this directory if needed
2. **Push to GitHub** for public sharing
3. **Update documentation** as you develop
4. **Test deployments** independently from the lab

## 📞 Support

This isolated repository allows you to:
- ✅ Work on FoodShare without affecting the lab
- ✅ Make local changes without upstream concerns
- ✅ Deploy to any environment
- ✅ Share publicly without exposing lab infrastructure

---

**Remember**: This is your independent FoodShare application - develop, deploy, and share freely! 🌟
