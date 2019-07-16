
# Download the repo
git clone https://github.com/jwrr/lued

# Sync locate git repo with remote repo
# This does not change the files in your local repo
git fetch origin

# Select the master branch
git checkout master

# Set local branch to match remort repo
git reset --hard origin/master

# Create a feature branch
git checkout -b feature_name

# Make changes

# List changes
git status

# View changes
git diff filename.txt

# Add changes to the local staging area (.git/index)
git add [files]

# Commit files from staging area to local repo (.git/objects)
git commit –m “message”

# Push changes to remote repo
git push origin feature_name

# Select master branch
git checkout master

# Compare master branch with feature_branch
Git diff master feature_name

# Merge feature branch into master branch
git merge feature_name

# Commit and push master
git commit –m "message"
git push origin dev

# Review history of changes
git log --pretty=oneline
git log --oneline --abbrev-commit --all --graph --decorate --color

# Create label
git tag 2019.07.xxx 1b2e1d63ff

# List branches and mark What branch I am on?
git branch

# Find branch that made a commit
git name-rev 6acd7babe166b92332fcdd558589974b48c4dd7e


