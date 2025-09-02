#!/bin/bash

# FoodShare LinkedIn Content Generator
# Creates engaging content for social media sharing

echo "🍕 FoodShare LinkedIn Content Generator"
echo "======================================"

# Check if we're in the right directory
if [ ! -f "README.md" ]; then
    echo "❌ Error: Please run this script from the foodshare-public-repo directory"
    exit 1
fi

echo "✅ Found repository files"

# Create a simple HTML version for PDF generation
cat > linkedin-content.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>FoodShare: DevOps Portfolio</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { text-align: center; color: #1976d2; }
        .tech-stack { background: #f5f5f5; padding: 15px; border-radius: 8px; margin: 20px 0; }
        .code { background: #2d3748; color: #e2e8f0; padding: 10px; border-radius: 4px; font-family: monospace; }
        .highlight { background: #fff3cd; padding: 15px; border-left: 4px solid #ffc107; margin: 20px 0; }
        .footer { text-align: center; margin-top: 40px; color: #666; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🍕 FoodShare: Enterprise App from Home</h1>
        <p><strong>DevOps Portfolio Demonstration</strong></p>
    </div>

    <div class="highlight">
        <h2>⚡ The 60-Second Pitch</h2>
        <p><em>"I built a complete enterprise application from my kitchen table that reduces food waste and demonstrates production DevOps skills."</em></p>
    </div>

    <h2>🏗️ What I Built</h2>
    <div class="tech-stack">
        <h3>Complete 3-Tier Architecture:</h3>
        <ul>
            <li>🌐 <strong>Frontend:</strong> React.js with Material-UI</li>
            <li>🚀 <strong>Backend:</strong> Node.js/Express REST API</li>
            <li>🗄️ <strong>Database:</strong> PostgreSQL with persistent storage</li>
            <li>☸️ <strong>Orchestration:</strong> Kubernetes with NGINX ingress</li>
        </ul>
    </div>

    <h2>🚀 Deploy in 5 Minutes</h2>
    <div class="code">
git clone https://github.com/temitayocharles/foodshare-app.git<br>
cd foodshare-app<br>
kubectl apply -f foodshare/<br>
kubectl port-forward svc/ingress-nginx-controller 8080:80 -n ingress-nginx
    </div>
    <p><strong>Access:</strong> http://localhost:8080</p>

    <h2>🎯 Key Skills Demonstrated</h2>
    <ul>
        <li>✅ Kubernetes container orchestration</li>
        <li>✅ Full-stack web development</li>
        <li>✅ Database design and persistence</li>
        <li>✅ DevOps and infrastructure as code</li>
        <li>✅ API design and security</li>
        <li>✅ Problem-solving with real impact</li>
    </ul>

    <h2>📊 Real Impact</h2>
    <p>This isn't just a demo—it's a working application that:</p>
    <ul>
        <li>🍽️ <strong>Reduces food waste</strong> by connecting restaurants to communities</li>
        <li>💻 <strong>Proves enterprise skills</strong> in a home lab environment</li>
        <li>⚡ <strong>Demonstrates rapid deployment</strong> capabilities</li>
        <li>🚀 <strong>Shows innovation potential</strong> from any location</li>
    </ul>

    <div class="footer">
        <h3>👨‍💻 Temitayo Charles</h3>
        <p>DevOps Engineer | Full-Stack Developer | Innovation Catalyst</p>
        <p>
            <strong>GitHub:</strong> github.com/temitayocharles<br>
            <strong>LinkedIn:</strong> linkedin.com/in/temitayocharles
        </p>
        <p><em>Built with ❤️ for impact and innovation</em></p>
    </div>
</body>
</html>
EOF

echo "✅ Created linkedin-content.html for PDF generation"

# Create a simple text version for quick sharing
cat > linkedin-post.txt << 'EOF'
🍕 FOODSHARE: Enterprise App from Home

⚡ HOOK: "I built a complete enterprise application from my kitchen table"

🏗️ WHAT I BUILT:
• React frontend with Material-UI
• Node.js/Express backend API
• PostgreSQL database with persistence
• Kubernetes orchestration
• NGINX load balancing

🚀 DEPLOY IN 5 MINUTES:
git clone https://github.com/temitayocharles/foodshare-app.git
cd foodshare-app
kubectl apply -f foodshare/
kubectl port-forward svc/ingress-nginx-controller 8080:80 -n ingress-nginx

🎯 WHY IT MATTERS:
• Proves enterprise DevOps skills
• Demonstrates full-stack capabilities
• Shows real problem-solving
• Built from home, for free

🔗 github.com/temitayocharles/foodshare-app

#DevOps #Kubernetes #FullStack #Innovation #FoodShare

👨‍💻 Temitayo Charles
DevOps Engineer | Full-Stack Developer
EOF

echo "✅ Created linkedin-post.txt for quick sharing"

echo ""
echo "🎉 Content generation complete!"
echo ""
echo "Files created:"
echo "• linkedin-content.html (for PDF generation)"
echo "• linkedin-post.txt (ready to copy-paste)"
echo ""
echo "Next steps:"
echo "1. Convert linkedin-content.html to PDF using your browser"
echo "2. Copy linkedin-post.txt content for LinkedIn"
echo "3. Record a short video demo using video-script.md"
echo "4. Share the infographic from foodshare-infographic.md"
echo ""
echo "🚀 Ready to engage your network!"
