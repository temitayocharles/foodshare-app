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

echo "✅ Found visual templates"

# Function to generate visual for a specific post
generate_visual() {
    local post_num=$1
    local html_file="post${post_num}-visual.html"
    local output_file="post${post_num}-visual.png"
    
    if [ ! -f "$html_file" ]; then
        echo "⚠️  Warning: $html_file not found, skipping..."
        return 1
    fi
    
    echo "📸 Generating visual for Post $post_num..."
    
    # Method 1: Try wkhtmltoimage (most reliable)
    if command -v wkhtmltoimage &> /dev/null; then
        wkhtmltoimage --width 1200 --height 675 --quality 100 "$html_file" "$output_file"
        if [ $? -eq 0 ]; then
            echo "✅ Successfully created $output_file using wkhtmltoimage"
            return 0
        fi
    fi
    
    # Method 2: Try webkit2png (macOS alternative)
    if command -v webkit2png &> /dev/null; then
        webkit2png --width=1200 --height=675 --scale=1 "$html_file" -o "post${post_num}-temp"
        if [ $? -eq 0 ]; then
            mv "post${post_num}-temp-full.png" "$output_file" 2>/dev/null || echo "✅ Created $output_file"
            return 0
        fi
    fi
    
    echo "⚠️  Automated generation failed for Post $post_num, will provide manual instructions"
    return 1
}

# Generate visuals for all posts
posts=(1 2 3 4 5)
failed_posts=()

for post in "${posts[@]}"; do
    if generate_visual "$post"; then
        echo "✅ Post $post visual generated successfully"
    else
        failed_posts+=("$post")
    fi
    echo ""
done

# Manual instructions for any failed posts
if [ ${#failed_posts[@]} -gt 0 ]; then
    echo ""
    echo "🤖 MANUAL GENERATION REQUIRED"
    echo "=============================="
    echo ""
    echo "📁 Generated Files:"
    ls -la post*-visual.html 2>/dev/null || echo "No HTML files found"
    echo ""
    echo "🎯 Manual Steps for Failed Posts:"
    for post in "${failed_posts[@]}"; do
        echo "Post $post:"
        echo "1. Open post${post}-visual.html in your browser (Chrome/Safari/Firefox)"
        echo "2. Press F12 → Go to responsive design mode"
        echo "3. Set dimensions to 1200x675px"
        echo "4. Take a screenshot (Cmd+Shift+4 on Mac, or right-click → Save image)"
        echo "5. Save as 'post${post}-visual.png'"
        echo ""
    done
fi

echo ""
echo "💡 Pro Tips:"
echo "• Use browser dev tools to ensure 1200x675 viewport"
echo "• Zoom to 100% before screenshot"
echo "• The HTML is already styled for perfect LinkedIn dimensions"
echo ""
echo "🚀 Ready for LinkedIn posting!"
echo ""
echo "📊 Summary:"
echo "• Post 1: Breaking the DevOps Cage"
echo "• Post 2: Architecture Overview" 
echo "• Post 3: Before/After Deployment"
echo "• Post 4: Home Office = Enterprise Cloud"
echo "• Post 5: DevOps Leadership & Value Proposition"
