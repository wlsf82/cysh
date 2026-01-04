
# Create the project directory and access it
mkdir workspaces/$1
cd workspaces/$1
# Initialize git and .gitignore
git init
touch .gitignore
echo ".DS_Store\ncypress.env.json\ncypress/downloads/\ncypress/screenshots/\ncypress/videos/\nnode_modules/" > .gitignore
# Link local repository with the remote one
git remote add origin git@github.com:${3:-wlsf82}/$1.git
# Create a readme file with a GitHub Actions badge
touch README.md
cat > README.md << EOF
# $1

[![CI](https://github.com/${3:-wlsf82}/$1/actions/workflows/ci.yml/badge.svg)](https://github.com/${3:-wlsf82}/$1/actions/workflows/ci.yml)
EOF
# Initialize npm
touch package.json
cat > package.json << EOF
{
  "name": "$1",
  "version": "1.0.0",
  "description": "TBD.",
  "main": "cypress.config.js",
  "scripts": {
    "cy:open": "cypress open",
    "test": "cypress run"
  },
  "keywords": [
    "cypress",
    "talking-about-testing",
    "testing"
  ],
  "author": "Walmyr <wlsf82@gmail.com> (https://walmyr.dev/)",
  "license": "MIT",
  "type": "commonjs"
}
EOF
# Add the MIT license file
touch LICENSE
CURRENT_YEAR=$(date +%Y)
cat > LICENSE << EOF
MIT License

Copyright (c) $CURRENT_YEAR Walmyr

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
# Install Cypress (if the version is provided, install it, otherwise, install the latestet version)
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
# Create the cypress.config.js file with a basic configuration for E2E tests
cat > cypress.config.js << 'EOF'
const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {},
  retries: {
    openMode: 0,
    runMode: 2,
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
# Create the support directory with the e2e and commands files in it
mkdir cypress/support/
touch cypress/support/e2e.js
touch cypress/support/commands.js
echo "import './commands'" > cypress/support/e2e.js
# Create the fixtures directory with an empty json file in it
mkdir cypress/fixtures/
touch cypress/fixtures/example.json
echo "{}" > cypress/fixtures/example.json
# Create a basic GitHub Actions workflow to run the tests
mkdir .github/
mkdir .github/workflows/
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
      - name: Save screenshots in case of failures
        uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: cypress-screenshots
          path: cypress/screenshots
          if-no-files-found: ignore
EOF
# Version and commit all the files and directories
git add .
git commit -m "Create cypress project"
# Open the project on VSCode
code .
