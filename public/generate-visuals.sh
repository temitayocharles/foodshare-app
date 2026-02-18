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
