# Create the project directory and access it
mkdir workspaces/$1
cd workspaces/$1
# Initialize git and .gitignore
git init
touch .gitignore
echo ".DS_Store\ncypress.env.json\ncypress/downloads/\ncypress/screenshots/\ncypress/videos/\nnode_modules/" > .gitignore
# Create a readme file to be defined
touch README.md
echo "# $1\n\nTBD." > README.md
# Initialize npm
npm init -y
# Install Cypress (if the version is provided, it will install it, otherwise, the latestet version is installed)
if [ "$2" ]; then
  npm i cypress@"$2" -D
else
  npm i cypress -D
fi
# Create the cypress.env.json and cypress.env.example.json files defaulting them to empty objects
touch cypress.env.json
echo "{}" > cypress.env.json
touch cypress.env.example.json
echo "{}" > cypress.env.example.json
# Version and commit all the files and directories
git add .
git commit -m "Create cypress project"
# Open the project on VSCode
code .
