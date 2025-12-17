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
# Create the cypress.config.js file with a basic configuration for e2e tests
cat > cypress.config.js << 'EOF'
const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    fixturesFolder: false,
    supportFile: false,
  },
})
EOF
# Create a sample test file just with a test suite skeleton
mkdir cypress/
mkdir cypress/e2e/
cat > cypress/e2e/spec.cy.js << 'EOF'
describe('Sample Test Suite', () => {
  beforeEach(() => {
    // cy.visit('url-here')
  })

  it('works', () => {
    // add test logic here
  })
})
EOF
# Create a basic GitHub Actions workflow to run the tests
mkdir .github/
mkdir .github/workflows
touch .github/workflows/ci.yml
cat > .github/workflows/ci.yml << 'EOF'
name: End-to-end tests 🧪
on: push
jobs:
  cypress-run:
    runs-on: ubuntu-24.04
    steps:
      - name: Checkout
        uses: actions/checkout@v6
      # Install npm dependencies, cache them correctly
      # and run all Cypress tests
      - name: Cypress run
        uses: cypress-io/github-action@v6
EOF
# Version and commit all the files and directories
git add .
git commit -m "Create cypress project"
# Open the project on VSCode
code .
