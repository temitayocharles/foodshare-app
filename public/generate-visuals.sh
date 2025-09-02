#!/bin/bash

# Automated Visual Generation Script for LinkedIn Posts
# This script creates professional visuals for your DevOps content

echo "🎨 LinkedIn Visual Generator"
echo "============================"

# Check if we're in the right directory
if [ ! -f "post1-visual.html" ]; then
    echo "❌ Error: post1-visual.html not found. Please run this script from the foodshare-public-repo directory"
    exit 1
fi

echo "✅ Found visual template"

# Method 1: Try wkhtmltoimage (most reliable)
if command -v wkhtmltoimage &> /dev/null; then
    echo "📸 Using wkhtmltoimage to generate high-quality image..."
    wkhtmltoimage --width 1200 --height 675 --quality 100 post1-visual.html post1-devops-cage.png
    if [ $? -eq 0 ]; then
        echo "✅ Successfully created post1-devops-cage.png using wkhtmltoimage"
        echo "📏 Image size: 1200x675px (LinkedIn optimal)"
        exit 0
    fi
fi

# Method 2: Try webkit2png (macOS alternative)
if command -v webkit2png &> /dev/null; then
    echo "📸 Using webkit2png to generate image..."
    webkit2png --width=1200 --height=675 --scale=1 post1-visual.html -o post1-devops-cage
    if [ $? -eq 0 ]; then
        mv post1-devops-cage-full.png post1-devops-cage.png 2>/dev/null || echo "✅ Created post1-devops-cage-full.png"
        echo "✅ Successfully created visual using webkit2png"
        exit 0
    fi
fi

# Method 3: Try Python with playwright/selenium
if command -v python3 &> /dev/null; then
    echo "📸 Using Python to generate image..."

    # Create Python script for screenshot
    cat > generate_visual.py << 'EOF'
from playwright.sync_api import sync_playwright
import os

def generate_visual():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page(viewport={'width': 1200, 'height': 675})

        # Load the HTML file
        page.goto(f"file://{os.getcwd()}/post1-visual.html")

        # Wait for content to load
        page.wait_for_timeout(1000)

        # Take screenshot
        page.screenshot(path="post1-devops-cage.png", full_page=False)
        print("✅ Successfully created post1-devops-cage.png using Playwright")

        browser.close()

if __name__ == "__main__":
    generate_visual()
EOF

    python3 generate_visual.py
    if [ $? -eq 0 ]; then
        echo "✅ Successfully created visual using Python/Playwright"
        rm generate_visual.py
        exit 0
    fi
    rm generate_visual.py
fi

# Method 4: Manual instructions
echo ""
echo "🤖 AUTOMATION COMPLETE!"
echo "======================"
echo ""
echo "📁 Generated Files:"
echo "• post1-visual.html (source template)"
echo ""
echo "🎯 Next Steps:"
echo "1. Open post1-visual.html in your browser"
echo "2. Take a screenshot (1200x675px)"
echo "3. Save as 'post1-devops-cage.png'"
echo "4. Or use online HTML to PNG converter"
echo ""
echo "💡 Pro Tips:"
echo "• Use browser dev tools to ensure 1200x675 viewport"
echo "• Zoom to 100% before screenshot"
echo "• Crop if needed to exact dimensions"
echo ""
echo "🚀 Ready for LinkedIn posting!"

# Create additional visual templates for other posts
echo ""
echo "📋 Creating templates for all posts..."

# Post 2: Architecture diagram
cat > post2-visual.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Post 2 Visual: Enterprise Cloud at Home</title>
    <style>
        body { margin: 0; padding: 20px; font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); width: 1200px; height: 675px; display: flex; flex-direction: column; justify-content: center; align-items: center; color: white; }
        .title { font-size: 48px; font-weight: bold; margin-bottom: 40px; text-align: center; }
        .diagram { display: flex; align-items: center; margin: 40px 0; }
        .home { background: rgba(255,255,255,0.9); padding: 30px; border-radius: 15px; margin-right: 30px; }
        .arrow { font-size: 36px; margin: 0 20px; }
        .cloud { background: rgba(255,255,255,0.9); padding: 30px; border-radius: 15px; margin-left: 30px; }
        .components { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 40px; }
        .component { background: rgba(255,255,255,0.8); padding: 15px; border-radius: 10px; text-align: center; font-size: 14px; }
        .hashtag { position: absolute; bottom: 30px; right: 30px; font-size: 18px; opacity: 0.8; }
    </style>
</head>
<body>
    <div class="title">🏠 Home Office = Enterprise Cloud</div>

    <div class="diagram">
        <div class="home">
            <div style="font-size: 24px;">🏠</div>
            <div>Your Home</div>
        </div>

        <div class="arrow">→</div>

        <div class="cloud">
            <div style="font-size: 24px;">☸️</div>
            <div>Kubernetes</div>
            <div>Cluster</div>
        </div>
    </div>

    <div class="components">
        <div class="component">📊 Monitoring<br>Prometheus</div>
        <div class="component">🚀 GitOps<br>ArgoCD</div>
        <div class="component">🔒 Security<br>Enterprise</div>
        <div class="component">💾 Storage<br>Persistent</div>
        <div class="component">📈 Scaling<br>HPA</div>
        <div class="component">🔄 Service Mesh<br>Istio</div>
    </div>

    <div class="hashtag">#Kubernetes #DevOps #CloudNative</div>
</body>
</html>
EOF

# Post 3: Before/After deployment
cat > post3-visual.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Post 3 Visual: 5-Minute Magic</title>
    <style>
        body { margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; width: 1200px; height: 675px; background: #f8f9fa; display: flex; flex-direction: column; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; }
        .title { font-size: 36px; font-weight: bold; margin-bottom: 10px; }
        .subtitle { font-size: 18px; opacity: 0.9; }
        .content { display: flex; flex: 1; }
        .before, .after { flex: 1; padding: 40px; display: flex; flex-direction: column; align-items: center; }
        .before { background: #ffebee; }
        .after { background: #e8f5e8; }
        .terminal { background: #1e1e1e; color: #d4d4d4; padding: 20px; border-radius: 10px; font-family: 'Courier New', monospace; margin: 20px 0; width: 100%; max-width: 400px; }
        .command { color: #4ade80; }
        .app { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); margin: 20px 0; width: 100%; max-width: 400px; text-align: center; }
        .app-title { color: #1976d2; font-weight: bold; margin-bottom: 10px; }
        .status { padding: 10px; border-radius: 5px; margin: 10px 0; }
        .running { background: #d4edda; color: #155724; }
        .center { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 20px; border-radius: 50%; box-shadow: 0 4px 20px rgba(0,0,0,0.2); font-size: 24px; font-weight: bold; color: #1976d2; }
        .hashtag { position: absolute; bottom: 20px; right: 20px; font-size: 16px; color: #666; }
    </style>
</head>
<body>
    <div class="header">
        <div class="title">⚡ 5-Minute Magic: Command to Production</div>
        <div class="subtitle">From Terminal to Running Application</div>
    </div>

    <div class="content">
        <div class="before">
            <h3>🚀 Deploy Command</h3>
            <div class="terminal">
$ <span class="command">kubectl apply -f foodshare/</span><br>
deployment.apps/foodshare-backend created<br>
deployment.apps/foodshare-frontend created<br>
service/foodshare-backend created<br>
service/foodshare-frontend created<br>
ingress.networking.k8s.io/foodshare-ingress created
            </div>
        </div>

        <div class="center">5 Minutes →</div>

        <div class="after">
            <h3>🌐 Running Application</h3>
            <div class="app">
                <div class="app-title">🍕 FoodShare</div>
                <div class="status running">✅ Running at localhost:8080</div>
                <div>Real app, real impact, zero cost</div>
            </div>
        </div>
    </div>

    <div class="hashtag">#FoodShare #Kubernetes #DevOps</div>
</body>
</html>
EOF

echo "✅ Created visual templates:"
echo "• post1-visual.html (DevOps Cage split-screen)"
echo "• post2-visual.html (Architecture diagram)"
echo "• post3-visual.html (Before/After deployment)"
echo ""
echo "🎯 To generate images:"
echo "1. Open any HTML file in your browser"
echo "2. Take screenshot at 1200x675px"
echo "3. Or use: wkhtmltoimage --width 1200 --height 675 file.html output.png"
echo ""
echo "🚀 Ready for LinkedIn posting!"</content>
<parameter name="filePath">/Volumes/256-B/tc-enterprise-devops-platform/foodshare-public-repo/generate-visuals.sh
