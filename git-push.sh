
#!/bin/bash

set -e

echo "===== Git Workflow ====="

# 1. Check Git status
echo ""
echo "===== Git Status ====="
git status

# 2. Ask for confirmation before git add
echo ""
read -r -p "Do you want to stage all changes? (y/n): " add_confirm

if [[ "$add_confirm" != "y" && "$add_confirm" != "Y" ]]; then
    echo "Git add cancelled."
    exit 0
fi

git add -A
echo "Changes staged successfully."

# Show staged changes
git status

# 3. Ask for commit message
echo ""
read -r -p "Enter commit message: " commit_message

if [[ -z "$commit_message" ]]; then
    echo "Commit message cannot be empty."
    exit 1
fi

git commit -m "$commit_message"

echo "Commit created successfully."

# 4. Ask for confirmation before pushing
echo ""
read -r -p "Do you want to push changes to remote? (y/n): " push_confirm

if [[ "$push_confirm" != "y" && "$push_confirm" != "Y" ]]; then
    echo "Push cancelled. Your commit is saved locally."
    exit 0
fi

git push

echo ""
echo "===== Git workflow completed successfully! ====="

