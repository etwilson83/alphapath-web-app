#!/bin/bash
set -e

echo "🔧 Updating frontend environment after backend deployment..."

# Get the backend URL from azd environment (now available after backend deployment)
BACKEND_URL=$(azd env get-value BACKEND_APP_URL)
echo "📡 Backend URL: $BACKEND_URL"

# Navigate to frontend directory (from backend directory) and update .env.production
cd ../frontend
echo "VITE_API_URL=$BACKEND_URL" > .env.production
echo "✅ Created frontend/.env.production with VITE_API_URL=$BACKEND_URL"

# Update GitHub secret using GitHub CLI (if gh is installed and authenticated)
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    echo "🔑 Updating GitHub secret VITE_API_URL..."
    gh secret set VITE_API_URL --body "$BACKEND_URL"
    echo "✅ GitHub secret updated successfully!"
    
    # Trigger a new deployment by creating an empty commit
    echo "🚀 Triggering frontend rebuild..."
    cd ..
    git commit --allow-empty -m "Update frontend environment variables"
    git push
    echo "✅ Frontend rebuild triggered!"
else
    echo "⚠️  GitHub CLI not found or not authenticated"
    echo "   Manual step: Add $BACKEND_URL as VITE_API_URL secret in GitHub"
fi

echo "🎯 Frontend environment update complete!" 