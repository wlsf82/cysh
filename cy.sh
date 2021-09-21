# Create project directory and access it
mkdir $1
cd $1
# Initialize git and .gitignore
git init
touch .gitignore
echo ".DS_Store\ncypress.env.json\ncypress/screenshots/\ncypress/videos/\nnode_modules/" > .gitignore
# Create readme file to be defined
touch README.md
echo "# $1\n\nTBD." > README.md
# Initialize NPM
npm init -y
# Install Cypress (if version is provided, it will install it, otherwise, the latestet version is installed)
if [ "$2" ]; then
  npm i cypress@"$2" -D
else
  npm i cypress -D
fi
# Create cypress.env and cypress.env.example files defaulting them to empty objects
touch cypress.env.json
echo "{}" > cypress.env.json
touch cypress.env.example.json
echo "{}" > cypress.env.example.json
# Open Cypress for the first time so that it creates its default structure
npx cypress open
