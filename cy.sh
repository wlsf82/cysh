
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
# Create copilot-instructions.md file with the instructions for writing Cypress tests in this project, organized into focused topic areas with cross-references to the cypress-automation skill and related topic files. The instructions should cover project structure, test organization, authentication, selectors, commands, assertions, and code quality standards.
mkdir -p .github/
touch .github/copilot-instructions.md
cat > .github/copilot-instructions.md << 'EOF'
# Cypress Testing Instructions

This documentation provides comprehensive guidance for writing Cypress tests in this project. The instructions are organized into focused topic areas for easy navigation and reference.

> **Quick Reference:** For a concise summary of core principles and rules, see the [cypress-automation skill](./skills/cypress-automation/SKILL.md).

## Documentation Structure

The Cypress testing guidelines are organized into the following topic areas:

### 📁 [01. Project Structure](./cypress/01-project-structure.md)

How to organize your Cypress project, including folder structure, configuration files, and environment setup. Covers `baseUrl`, `apiUrl`, fixtures, and support files configuration.

### 🧪 [02. Test Organization](./cypress/02-test-organization.md)

Best practices for organizing test files and test cases. Includes guidance on hooks (`beforeEach`, `before`, `after`, `afterEach`), `testIsolation`, using `context` for sub-features, and the AAA (Arrange-Act-Assert) pattern.

### 🔐 [03. Authentication](./cypress/03-authentication.md)

Session management and authentication patterns using `cy.session` and `cy.sessionLogin` custom commands. Learn how to efficiently cache and restore user sessions across tests.

### 🎯 [04. Selectors](./cypress/04-selectors.md)

Comprehensive selector strategy guidance, including priority order (`data-testid` > `aria-label` > descriptive attributes > `id`), using `cy.contains` effectively, and alias patterns with `.as()` to avoid selector repetition.

### ⚡ [05. Commands](./cypress/05-commands.md)

Best practices for using Cypress commands, including proper destructuring with `cy.request()` and `cy.wait('@alias')`, working with `.last()` elements safely, and the strict prohibition of `cy.wait(Number)`.

### ✅ [06. Assertions](./cypress/06-assertions.md)

Assertion strategies and patterns, including when to use `.should('be.visible')` vs `.should('exist')`, avoiding redundant assertion chains, and writing effective negative assertions.

### 🎨 [07. Code Quality](./cypress/07-code-quality.md)

Code quality standards covering sensitive data handling, conditional testing rules, import organization, indentation standards, and npm script conventions.

## Navigation Tips

- **For quick rules:** Start with the [SKILL.md](./skills/cypress-automation/SKILL.md) for core principles
- **For specific topics:** Jump directly to the relevant topic file above
- **For comprehensive learning:** Read through topics 01-07 in order
- **Each topic file** includes "See Also" sections to related topics

## Contributing

When updating these instructions:

- Keep the `SKILL.md` concise with core rules only
- Place detailed examples and explanations in the appropriate topic file
- Maintain cross-references between related topics
- Follow the established formatting and example patterns
EOF
# Create the 01-project-structure.md file with detailed instructions on how to structure a Cypress project, including recommended folder organization, configuration settings, and environment variable management.
mkdir -p .github/cypress/
touch .github/cypress/01-project-structure.md
cat > .github/cypress/01-project-structure.md << 'EOF'
# Cypress Project Structure

> **Part of:** [Cypress Instructions](../copilot-instructions.md)

This guide covers the recommended project structure, configuration, and file organization for Cypress projects.

## Files and Folders Structure

It's suggested using the default Cypress files and folders structure, with small modifications, such as specs divided per feature, and tasks inside the support directory, as demonstrated below.

```bash
cypress/
  ├── fixtures/                    # Test data files (JSON, txt, etc.)
  │   └── example.json             # Example fixture file
  ├── e2e/                         # End-to-end test specs, organized by feature
  │   ├── auth/                    # Login feature specs
  │   │   └── login.cy.{js,ts}     # Login test file
  │   ├── dashboard/               # Dashboard feature specs
  │   │   └── dashboard.cy.{js,ts} # Dashboard test file
  │   └── settings/                # Settings feature specs
  │       └── settings.cy.{js,ts}  # Settings test file
  └── support/                     # Support utilities and custom commands
      ├── tasks/                   # Custom tasks for plugins and custom node.js code
      │   └── index.{js,ts}        # Task definitions
      ├── commands.{js,ts}         # Custom Cypress commands
      └── e2e.{js,ts}              # Global setup for e2e tests
cypress.config.{js,ts}             # Cypress configuration file
cypress.env.example.json           # Example environment variables file
cypress.env.json                   # Project-specific environment variables (not versioned)
```

## Configuration Settings

### `baseUrl`

Always define the `baseUrl` in the `cypress.config.{js,ts}` file so tests can run against different environments by simply overwriting it via a command line argument.

For example:

```bash
cypress run --config baseUrl=https://staging.example.com
```

### `apiUrl`

Define the `apiUrl` as an `expose` inside in the `cypress.config.{js,ts}` file so tests can run against different environments by simply overwriting it via a command line argument.

For example:

```bash
cypress run --expose apiUrl=https://api.staging.example.com
```

### Disabling Unused Folders

When not using the `cypress/fixtures/` or `cypress/support/` files and directories, update the `cypress.config.{js,ts}` file as below.

```js
const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    fixturesFolder: false, // Do not use fixtures
    supportFile: false, // Do not use support files
  },
});
```

## Environment Variables

No sensitive data should be EVER versioned, and so, they should be set in environment variables prefixed by `CYPRESS_`, (e.g., `CYPRESS_USERNAME`), or defined inside the not-versioned `cypress.env.json` file.

> It's a good practice to have a `cypress.env.example.json` file as an example of how the `cypress.env.json` file should look like.

## See Also

- [Test Organization](./02-test-organization.md) - How to structure test files
- [Authentication](./03-authentication.md) - Session management patterns
- [Code Quality](./07-code-quality.md) - Handling sensitive data
EOF
# Create the 02-test-organization.md file with detailed instructions on how to organize Cypress test files and test cases, including best practices for using hooks, test isolation, and the AAA pattern.
mkdir -p .github/cypress/
touch .github/cypress/02-test-organization.md
cat > .github/cypress/02-test-organization.md << 'EOF'
# Cypress Test Organization

> **Part of:** [Cypress Instructions](../copilot-instructions.md)

This guide covers best practices for organizing test files, using hooks effectively, and structuring test cases with the AAA pattern.

## Hooks

To avoid repetitive steps inside `cypress/e2e/**/*.cy.{js,ts}` files, use the `beforeEach` hook.

Below is an example.

```js
// cypress/e2e/settings/settings.cy.{js,ts}

describe("Settings", () => {
  beforeEach(() => {
    cy.login(); // Login first using a custom command.
  });

  it("access the settings page", () => {
    // Already logged in, continue doing whatever this test should do.
  });

  it("does something else", () => {
    // Already logged in, continue doing whatever this test should do.
  });
});
```

### `before`, `after`, and `afterEach`

- Avoid the `before` hook to ensure tests inside the same file can be ran independently.
- Do not use the `after` and `afterEach` hooks to avoid leaving trash behind in case Cypress crashes and never runs such hooks. Instead, we cleanup first using the `beforeEach` hook.

## `testIsolation`

It's strictly forbidden to define `testIsolation: false` in the `cypress.config.{js,ts}` file.

> This ensures every test case is written with test-independence in mind.

## Using `context` for Sub-features

When writing tests for a feature that has sub-features, divide them using the `context` function.

**Good example** 👍

```js
describe("Auth", () => {
  context("Login", () => {
    beforeEach(() => {
      cy.visit("/login");
    });

    // Login tests here
  });

  context("Sign in", () => {
    beforeEach(() => {
      cy.visit("/sign-in");
    });

    // Sign in tests here
  });
});
```

> `context` functions can have their own `beforeEach` hook if needed.

**Good example - 2** 👍

```js
describe("Main Feature", () => {
  beforeEach(() => {
    // Common steps shared between `context`s
  });

  context("Sub-feature", () => {
    beforeEach(() => {
      // Common steps of a specific `context`
    });

    // Sub-feature tests here
  });

  context("Sub-feature-2", () => {
    beforeEach(() => {
      // Common steps of another specific `context`
    });

    // Sub-feature-2 tests here
  });
});
```

> If many `context`s have common setup steps, they can share a `beforeEach` in an upper `context` or in the main `describe` function.

**Bad example** 👎

```js
describe("Auth", () => {
  // Test cases of auth sub-features mixed up all together.

  it("login test sample", () => {});

  it("sign in test sample", () => {});

  it("forgot password test sample", () => {});
});
```

## Arrange, Act, Assert (AAA) Pattern

Follow the AAA (Arrange, Act, Assert) pattern for writing tests, and separate each of them between a blank line.

### Example 1

```js
describe("Login", () => {
  it("logs in successfully", () => {
    // Arrange
    cy.visit("/login");

    // Act
    cy.env(["USERNAME", "PASSWORD"]).then(({ USERNAME, PASSWORD }) => {
      cy.get('input[data-testid="username"]').type(USERNAME);
      cy.get('input[data-testid="password"]').type(PASSWORD, {
        log: false,
      });
      cy.contains("button", "Login").click();
    });

    // Assert
    cy.url().should("be.equal", "https://example.com/dashboard");
    cy.contains("h1", "Welcome to the Dashboard").should("be.visible");
  });
});
```

### Example 2 - Many tests with the same arrange steps

```js
describe("Dashboard", () => {
  beforeEach(() => {
    // Arrange
    cy.sessionLogin();
    cy.visit("/dashboard");
  });

  it("opens the dashboard menu", () => {
    // Act
    cy.get("#dashboard-menu-btn").click();

    // Assert
    cy.get("#dashboard-menu-modal").should("be.visible");
  });

  it("closes the dashboard menu", () => {
    // Act
    cy.get("#dashboard-menu-btn").click();
    cy.get("#dashboard-menu-btn").click();

    // Assert
    cy.get("#dashboard-menu-modal").should("not.exist");
  });
});
```

> If many tests share the same arrange steps, move them to the `beforeEach` hook.

### Example 3 - Intermediate Assertions

Sometimes, intermediate assertions might be needed before the final ones to ensure the elements we want to interact with are really there.

```js
describe("Login", () => {
  it("logs in successfully", () => {
    // Arrange
    cy.visit("/login");

    cy.env(["USERNAME", "PASSWORD"]).then(({ USERNAME, PASSWORD }) => {
      cy.get('input[data-testid="username"]')
        // Assert
        .should("be.visible")
        // Act
        .type(USERNAME);
      cy.get('input[data-testid="password"]')
        // Assert
        .should("be.visible")
        // Act
        .type(PASSWORD, {
          log: false,
        });
      cy.contains("button", "Login")
        // Assert
        .should("be.visible")
        // Act
        .click();
    });

    // Assert
    cy.url().should("be.equal", "https://example.com/dashboard");
    cy.contains("h1", "Welcome to the Dashboard").should("be.visible");
  });
});
```

## See Also

- [Authentication](./03-authentication.md) - Session management and login patterns
- [Selectors](./04-selectors.md) - Best practices for element selection
- [Assertions](./06-assertions.md) - Assertion strategies
EOF
# Create the 03-authentication.md file with detailed instructions on how to handle authentication in Cypress tests, including session management patterns and best practices for login flows.
mkdir -p .github/cypress/
touch .github/cypress/03-authentication.md
cat > .github/cypress/03-authentication.md << 'EOF'
# Cypress Authentication and Session Management

> **Part of:** [Cypress Instructions](../copilot-instructions.md)

This guide covers best practices for handling authentication in Cypress tests using session caching.

## Usage of `cy.session`

For every test case that requires log in as a pre-condition, use a `cy.sessionLogin()` custom command.

> **Important:** The exception for the above rule are for tests inside a `cypress/e2e/auth/login.cy.{js,ts}` file, where the session should not be cached.

The `cy.sessionLogin` custom command uses Cypress's native `cy.session` command, which caches and restores `cookies`, `localStorage`, and `sessionStorage` (i.e. session data) in order to recreate a consistent browser context between tests.

## Example Implementation

Below is an example of how a `cy.sessionLogin` command looks like.

```js
Cypress.Commands.add("sessionLogin", (username, password) => {
  cy.env(["USERNAME", "PASSWORD"]).then(({ USERNAME, PASSWORD }) => {
    const loginUser = username || USERNAME;
    const loginPassword = password || PASSWORD;

    const sessionId = loginUser;

    const setup = () => {
      cy.visit("users/sign_in");

      cy.get('[data-qa-selector="login_field"]').type(loginUser);
      cy.get('[data-qa-selector="password_field"]').type(loginPassword, {
        log: false,
      });
      cy.get('[data-qa-selector="sign_in_button"]').click();

      cy.get(".qa-user-avatar").should("exist");
    };

    const validate = () => {
      cy.visit("");
      cy.location("pathname", { timeout: 1000 }).should(
        "not.eq",
        "/users/sign_in",
      );
    };

    const options = {
      cacheAcrossSpecs: true,
      validate,
    };

    /**
     * @param sessionId string - the id of the session. If the id changes, a new
     * session is created.
     * @param setup function - the function that creates the session.
     * @param options object - an object to add certain characteristics to the
     * session, such as sharing the cached session across specs (test files),
     * and a way to validate if the session is still valid (validate function).
     * If the session gets invalidated, the setup function runs again to recreate it.
     *
     * @example cy.session() // Logs in with the default credentials, or restores an existing session for the default user
     * @example cy.session('user-sample@example.com', '53cr37P@55w0Rd') // Logs in (or restores the session) passing the credentials (username and password)
     *
     * For more details, visit https://docs.cypress.io/api/commands/session
     */
    cy.session(sessionId, setup, options);
  });
});
```

## Key Components

### Session ID

The session ID is used to uniquely identify a session. If the ID changes, a new session is created. Typically use the username as the session ID.

### Setup Function

The function that performs the actual login. This is only executed when a session needs to be created or recreated.

### Validate Function

Optional function to check if the session is still valid. If validation fails, the setup function runs again to recreate the session.

### Options

- `cacheAcrossSpecs: true` - Shares the cached session across different spec files
- `validate` - Function to validate the session is still active

## See Also

- [Test Organization](./02-test-organization.md) - Using beforeEach with session login
- [Code Quality](./07-code-quality.md) - Handling sensitive credentials
- [Selectors](./04-selectors.md) - Selecting login form elements
EOF
# Create the 04-selectors.md file with detailed instructions on how to use selectors in Cypress tests, including best practices for selector strategies, priority order, and aliasing patterns.
mkdir -p .github/cypress/
touch .github/cypress/04-selectors.md
cat > .github/cypress/04-selectors.md << 'EOF'
# Cypress Selectors and Element Selection

> **Part of:** [Cypress Instructions](../copilot-instructions.md)

This guide covers best practices for selecting elements in Cypress tests, including selector strategies and alias usage.

## Selector Principles

First of all:

- Selectors should be resilient to UI changes
- Selectors should reveal intent, not implementation details
- Selectors should be consistent across the entire project
- Selectors should be as simple as possible

## Recommended Selectors Strategy

The recommended selectors approach is as follows.

```js
// If data-testid or similar exist, use them.
cy.get('[data-testid="shopping-cart"]');
// If data-testid is not available, use accessibility (A11y) properties such as aria-label for element selection.
cy.get('[aria-label="Next Page"]');
// If none of the above are present, try descriptive selectors.
cy.get('input[placeholder="Search emojis..."]');
// Otherwise, use id.
cy.get("#avatar");
```

**Priority:** `[data-testid]` > `[aria-label]` > descriptive attributes > `#id`

## What to Avoid

**Avoid** 👎

- Generic classes (e.g., `.btn`)
- Dynamic classes (e.g., `cy.get('.Messenger_openButton_OgKIA')`)
- Generic selectors with indexes, first, or last (e.g., `cy.get('a').first()` or `cy.get('button').eq(3)`)
- Long and hard-to-read selectors (e.g., `cy.get('div > p > span')`)
- **XPATH - NEVER USE XPATH!**

## Using `cy.contains`

Below are examples of how to use and how not to use the `contains` command.

**Good example** 👍

```js
cy.contains("button", "Send"); // Generic selector + element's content that makes it specific.
```

**Bad examples** 👎

```js
cy.contains("Send"); // Too generic

cy.get("button").contains("Send"); // Too many chainings

cy.get("button:contains(Send)"); // Too complex as it depends on JQuery's :contains
```

## Aliases: `cy.get('selector').as('alias')` and `cy.get('@alias')`

To avoid repeating the same selector over and over, give alias to elements, and then, get them by their aliases.

**Good examples** 👍

```js
describe("Sample Test Suite", () => {
  beforeEach(() => {
    cy.visit("https://example.com/login");
    cy.get('input[name="username"]').as("username");
    cy.get('input[name="password"]').as("password");
    cy.get('input[type="submit"]').as("loginButton");
  });

  it("successful login", () => {
    cy.env(["USERNAME", "PASSWORD"]).then(({ USERNAME, PASSWORD }) => {
      cy.get("@username").type(USERNAME);
      cy.get("@password").type(PASSWORD, { log: false });
      cy.get("@loginButton").click();
    });

    cy.url().should("contain", "/dashboard");
    cy.contains("h1", "Welcome to the Dashboard").should("be.visible");
  });

  it("errors on invalid email", () => {
    cy.env(["PASSWORD"]).then(({ PASSWORD }) => {
      cy.get("@username").type("invalid");
      cy.get("@password").type(PASSWORD, { log: false });
      cy.get("@loginButton").click();
    });

    cy.contains(".error", "Invalid email or password.");
    cy.url().should("contain", "/login");
    cy.get("@username").should("be.visible");
  });

  it("errors on invalid password", () => {
    cy.env(["USERNAME"]).then(({ USERNAME }) => {
      cy.get("@username").type(USERNAME);
      cy.get("@password").type("invalid-password", { log: false });
      cy.get("@loginButton").click();
    });

    cy.contains(".error", "Invalid email or password.");
    cy.url().should("contain", "/login");
    cy.get("@username").should("be.visible");
  });

  it("does not enable the login button while username and password are not filled", () => {
    cy.get("@loginButton").should("be.disabled");
  });
});
```

**Bad examples** 👎

```js
describe("Sample Test Suite", () => {
  beforeEach(() => {
    cy.visit("https://example.com/login");
  });

  it("successful login", () => {
    cy.env(["USERNAME", "PASSWORD"]).then(({ USERNAME, PASSWORD }) => {
      cy.get('input[name="username"]').type(USERNAME);
      cy.get('input[name="password"]').type(PASSWORD, { log: false });
      cy.get('input[type="submit"]').click();
    });

    cy.url().should("contain", "/dashboard");
    cy.contains("h1", "Welcome to the Dashboard").should("be.visible");
  });

  it("errors on invalid email", () => {
    cy.env(["PASSWORD"]).then(({ PASSWORD }) => {
      cy.get('input[name="username"]').type("invalid");
      cy.get('input[name="password"]').type(PASSWORD, { log: false });
      cy.get('input[type="submit"]').click();
    });

    cy.contains(".error", "Invalid email or password.");
    cy.url().should("contain", "/login");
    cy.get('input[name="username"]').should("be.visible");
  });

  it("errors on invalid password", () => {
    cy.env(["USERNAME"]).then(({ USERNAME }) => {
      cy.get('input[name="username"]').type(USERNAME);
      cy.get('input[name="password"]').type("invalid-password", { log: false });
      cy.get('input[type="submit"]').click();
    });

    cy.contains(".error", "Invalid email or password.");
    cy.url().should("contain", "/login");
    cy.get('input[name="username"]').should("be.visible");
  });

  it("does not enable the login button while username and password are not filled", () => {
    cy.get('input[type="submit"]').should("be.disabled");
  });
});
```

## See Also

- [Commands](./05-commands.md) - Interacting with selected elements
- [Assertions](./06-assertions.md) - Asserting on element state
- [Test Organization](./02-test-organization.md) - Using aliases in beforeEach
EOF
# Create the 05-commands.md file with detailed instructions on how to use Cypress commands effectively, including best practices for destructuring responses, handling dynamic elements, and avoiding anti-patterns.
mkdir -p .github/cypress/
touch .github/cypress/05-commands.md
cat > .github/cypress/05-commands.md << 'EOF'
# Cypress Commands and Best Practices

> **Part of:** [Cypress Instructions](../copilot-instructions.md)

This guide covers best practices for using Cypress commands, including proper usage patterns and common pitfalls to avoid.

## `cy.request` and `cy.wait('@alias')` with `.then()`

Below are examples of how to use and how not to use the `cy.request` and `cy.wait('@alias')` commands when chaining them to the `.then` command.

### `cy.request().then()`

**Good example** 👍

> Always destructure what's needed from a request's response to avoid duplications like `response.status`, or `response.body`.

```js
cy.request("GET", "https://api.example.com").then(({ body, status }) => {
  expect(status).to.equal(200);
  expect(body.someProperty).should.exist;
});
```

**Bad example** 👎

```js
cy.request("GET", "https://api.example.com").then((response) => {
  expect(response.status).to.equal(200);
  expect(response.body.someProperty).should.exist;
});
```

### `cy.wait('@alias').then()`

**Good example** 👍

> Always destructure what's needed from an intercepted response to avoid duplications like `response.status`, or `response.body`.

```js
cy.intercept("GET", "https://api.example.com").as("alias");

cy.login();

cy.wait("@alias").then(({ status }) => {
  expect(status).to.equal(200);
});

// Continue here.
```

**Bad example** 👎

```js
cy.intercept("GET", "https://api.example.com").as("alias");

cy.login();

cy.wait("@alias").then((response) => {
  expect(response.status).to.equal(200);
});

// Continue here.
```

## Working with the `.last()` Element

When working with the `.last` element, make sure the correct number of elements are visible before getting the last.

This ensures you are selecting the correct element, especially in scenarios where multiple elements with the same selector may render at different times, such as in a dynamic list.

**Good example** 👍

```js
cy.get("ul li")
  // Assert the expected number of elements.
  .should("have.length", 10)
  // All items rendered, now get the last one and make an assertion.
  .last()
  .should("have.text", "Buy Milk");
```

**Bad example** 👎

```js
cy.get("ul li")
  .last() // This may select the wrong element if the list is still rendering.
  .should("have.text", "Buy Milk");
```

## `cy.wait(Number)` is Strictly Forbidden

**NO EXCEPTION** - Using `cy.wait()` with a hardcoded number is strictly forbidden.

Instead of doing something like this: 👎

```js
cy.get(...).type(...)
cy.get(...).type(...)
cy.get(...).click()

cy.wait(3000)

cy.get(...).should('be.visible')
```

Do something like this: 👍

```js
cy.intercept().as('requestThatWillHappenAfterFormSubmit')

cy.get(...).type(...)
cy.get(...).type(...)
cy.get(...).click()

cy.wait('@requestThatWillHappenAfterFormSubmit')

cy.get(...).should('be.visible')
```

### Why This Matters

- Arbitrary waits make tests slower and non-deterministic
- Tests may pass on a fast machine but fail on a slow one
- Using `cy.intercept()` + `cy.wait('@alias')` ensures the test waits for the actual condition to be met
- This approach is faster when the request completes quickly and more reliable when it takes longer

## See Also

- [Selectors](./04-selectors.md) - Selecting elements to interact with
- [Assertions](./06-assertions.md) - Proper assertion patterns
- [Code Quality](./07-code-quality.md) - Keeping tests deterministic
EOF
# Create the 06-assertions.md file with detailed instructions on how to write effective assertions in Cypress tests, including strategies for visibility vs existence, negative assertions, and avoiding redundant assertion chains.
mkdir -p .github/cypress/
touch .github/cypress/06-assertions.md
cat > .github/cypress/06-assertions.md << 'EOF'
# Cypress Assertions and Expectations

> **Part of:** [Cypress Instructions](../copilot-instructions.md)

This guide covers best practices for writing assertions in Cypress tests, including choosing the right assertion type and avoiding common mistakes.

## The `.should('be.visible')` vs. `.should('exist')` Assertions

If an element should be visible in the page, always assert that using the `.should('be.visible')` assertion.

Only asserting that an element exists in the DOM is not enough since the element might exist in the DOM but could be hidden by a CSS rule, for example.

### When to Use Each

- **`.should('be.visible')`** - Use when the element should be visible to users
- **`.should('exist')`** - Use only when you need to verify an element is in the DOM but don't care about visibility (rare cases)

**Good example** 👍

```js
cy.get(".avatar").should("be.visible");
```

**Bad examples** 👎

```js
cy.get(".avatar").should("exist"); // Not enough - element might be hidden
```

## Unnecessary Chain of Commands

It's not necessary to ensure the element exists in the DOM if you will assert that it's visible.

> An element cannot be visible without existing in the DOM.

**Good example** 👍

```js
cy.get(".avatar").should("be.visible");
```

**Bad examples** 👎

```js
cy.get(".avatar").should("exist").and("be.visible");

cy.get(".avatar").should("be.visible").and("exist");
```

## Negative Assertions

Always run a positive assertion before a negative one to avoid tests passing prematurely.

**Good example** 👍

```js
it("deletes a note", () => {
  cy.get(".list-group").contains("My note updated").click();
  cy.contains("Delete").click();

  cy.get(".list-group-item").its("length").should("be.at.least", 1); // Ensure you're in the right place before the negative assertion.
  cy.contains(".list-group-item", "My note").should("not.exist");
});
```

**Bad example** 👎

```js
it("deletes a note", () => {
  cy.get(".list-group").contains("My note updated").click();
  cy.contains("Delete").click();

  cy.get(".list-group:contains(My note updated)").should("not.exist"); // This assertion will happen right after the click, when the app might not have redirected to the correct place where the assertion should happen
});
```

### Why Positive Assertions First?

- A negative assertion might pass immediately if you're not in the right state yet
- The positive assertion ensures you've navigated to the expected page/state
- This prevents false positives where tests pass for the wrong reasons

## Using `.its()` Effectively

When accessing properties, use `.its()` followed by assertions rather than `.should()` with callback functions when possible.

**Good example** 👍

```js
cy.get(".list-group-item").its("length").should("be.at.least", 1);
```

## See Also

- [Selectors](./04-selectors.md) - Selecting elements to assert on
- [Commands](./05-commands.md) - Commands that lead to assertions
- [Test Organization](./02-test-organization.md) - AAA pattern with assertions
EOF
# Create the 07-code-quality.md file with detailed instructions on code quality standards for Cypress tests, including handling sensitive data, conditional testing rules, import organization, and npm script conventions.
mkdir -p .github/cypress/
touch .github/cypress/07-code-quality.md
cat > .github/cypress/07-code-quality.md << 'EOF'
# Cypress Code Quality and Standards

> **Part of:** [Cypress Instructions](../copilot-instructions.md)

This guide covers code quality standards, security practices, and formatting conventions for Cypress test code.

## Sensitive Data

No sensitive data should be EVER versioned, and so, they should be set in environment variables prefixed by `CYPRESS_`, (e.g., `CYPRESS_USERNAME`), or defined inside the not-versioned `cypress.env.json` file.

> It's a good practice to have a `cypress.env.example.json` file as an example of how the `cypress.env.json` file should look like.

After that, such data can be retrieved using `cy.env(["ENV_HERE"]).then(({ ENV_HERE }) => { ... })`.

Finally, do not leak sensitive data in the Cypress command logs. To protect data from leaking, use the `{ log: false }` option both in the `cy.env()` command and when typing such data (e.g., in `.type()`).

**Good example** 👍

```js
cy.env(["PASSWORD"], { log: false }).then(({ PASSWORD }) => {
  cy.get('input[data-testid="password"]').type(PASSWORD, { log: false });
});
```

**Bad examples** 👎

```js
cy.get('input[data-testid="password"]').type("hardcoded-sensitive-data"); // Sensitive data should never be hardcoded.

cy.env(["PASSWORD"]).then(({ PASSWORD }) => {
  cy.get('input[data-testid="password"]').type(PASSWORD); // Although the data come from a protected env, it leaks in the Cypress command log.
});
```

## Conditionals Testing

It's discouraged to use conditions in testing code, except in a few exceptions.

Below is an exception example, where we want to validate an API response, and a few fields are optional.

```js
it("returns the correct status and body structure on a simple GET request (with default query params.)", () => {
  cy.request("GET", CUSTOMERS_API_URL).as("getCustomers");

  cy.get("@getCustomers").its("status").should("eq", 200);

  cy.get("@getCustomers")
    .its("body")
    .should("have.all.keys", "customers", "pageInfo");
  cy.get("@getCustomers")
    .its("body.customers")
    .each((customer) => {
      expect(customer.id).to.exist.and.be.a("number");
      expect(customer.name).to.exist.and.be.a("string");
      expect(customer.employees).to.exist.and.be.a("number");
      expect(customer.industry).to.exist.and.be.a("string");

      // Since customer.contactInfo can be null, this condition is accepted. 👍
      if (customer.contactInfo) {
        expect(customer.contactInfo).to.have.all.keys("name", "email");
        expect(customer.contactInfo.name).to.be.a("string");
        expect(customer.contactInfo.email).to.be.a("string");
      }

      // Since customer.address can be null, this condition is accepted. 👍
      if (customer.address) {
        expect(customer.address).to.have.all.keys(
          "street",
          "city",
          "state",
          "zipCode",
          "country",
        );
        expect(customer.address.street).to.be.a("string");
        expect(customer.address.city).to.be.a("string");
        expect(customer.address.state).to.be.a("string");
        expect(customer.address.zipCode).to.be.a("string");
        expect(customer.address.country).to.be.a("string");
      }
    });

  cy.get("@getCustomers")
    .its("body.pageInfo")
    .should("have.all.keys", "currentPage", "totalPages", "totalCustomers");
  cy.get("@getCustomers")
    .its("body.pageInfo")
    .then(({ currentPage, totalPages, totalCustomers }) => {
      expect(currentPage).to.be.a("number");
      expect(totalPages).to.be.a("number");
      expect(totalCustomers).to.be.a("number");
    });
});
```

And below is another exception, where we can control in which viewport tests will run against.

```js
it("logs out", { tags: "@desktop-and-tablet" }, () => {
  cy.visit("/");

  const viewportWidthBreakpoint = Cypress.expose("viewportWidthBreakpoint");

  if (Cypress.config("viewportWidth") < viewportWidthBreakpoint) {
    // 👍
    cy.get(".navbar-toggle.collapsed").should("be.visible").click(); // On smaller viewports, the user must open the menu before clicking the Logout link
  }

  cy.contains(".nav a", "Logout").click();

  cy.get("#email").should("be.visible");
});
```

But this isn't allowed: 👎

```js
// This only works if there's 100% guarantee
// body has fully rendered without any pending changes
// to its state
cy.get('body').then(($body) => {
  // synchronously ask for the body's text
  // and do something based on whether it includes
  // another string
  if ($body.text().includes('some string')) {
    // yup found it
    cy.get(...).should(...)
  } else {
    // nope not here
    cy.get(...).should(...)
  }
})
```

> **Tests must be deterministic.
> Each run should produce the same behavior and results.
> If multiple paths exist, write a separate test for each.**

## Imports of Internal vs. External Packages

To differentiate between internal and external packages, the rule is:

- Import external packages first
- Leave an empty line between the last import of an external package and the beginning of imports of internal ones
- Following the above rules, import internal and external packages in alphabetical order

**Good example** 👍

```js
// External packages
import { expect } from "chai";
import supertest from "supertest";

// Internal modules
import { apiClient } from "../support/apiClient";
import { testData } from "../fixtures/testData";
```

## Indentation

Use two spaces of indentation.

This helps with breaking lines when chaining Cypress commands.

For example:

```js
cy.contains("a", "Privacy Policy")
  .should("be.visible")
  .and("have.attr", "target", "_blank");
```

> If four spaces were used, the chained commands would not align with the `cy` object.

## npm Scripts

There's no need to add `npx` inside the npm scripts.

npm already knows where to find the binaries when calling scripts defined inside the `package.json` file, so, `npx` is not needed.

**Good example** 👍

```json
"scripts": {
  "cy:open": "cypress open",
  "test": "cypress run"
},
```

**Bad example** 👎

```json
"scripts": {
  "cy:open": "npx cypress open",
  "test": "npx cypress run"
},
```

## See Also

- [Project Structure](./01-project-structure.md) - Environment variable configuration
- [Authentication](./03-authentication.md) - Using sensitive credentials
- [Commands](./05-commands.md) - Writing deterministic tests
EOF
# Create the cypress-automation skill file with a concise summary of core principles and rules for writing Cypress tests in this project, organized into focused topic areas with cross-references to the detailed topic files in the copilot-instructions.md. The skill file should cover project structure, test organization, authentication, selectors, commands, assertions, and code quality standards in a concise format suitable for quick reference by developers.
mkdir -p .github/skills/cypress-automation/
touch .github/skills/cypress-automation/SKILL.md
cat > .github/skills/cypress-automation/SKILL.md << 'EOF'
# Skill: Cypress Automation Expert

You are an expert in web test automation using Cypress + TypeScript/JavaScript. Your goal is to write high-quality, deterministic, and maintainable end-to-end tests.

> **Note:** For detailed implementation guidance, examples, and code snippets, refer to the [Cypress Instructions](../../copilot-instructions.md) - a comprehensive guide organized into focused topics.

## Core Principles

- **Test Independence:** Every test must be independent. Never set `testIsolation: false`
- **Deterministic Tests:** Tests must produce the same result every time. No conditional logic based on non-deterministic UI states
- **AAA Pattern:** Follow Arrange-Act-Assert structure with blank lines separating each phase

## Critical Rules

- **No Arbitrary Waits:** `cy.wait(Number)` is strictly forbidden. Use `cy.intercept()` + `cy.wait('@alias')`
- **No XPath:** Never use XPath selectors
- **Selector Priority:** `[data-testid]` > `HTML tag + Tag's content` > `[aria-label]` > `[placeholder]` > `#id` > descriptive class names (e.g., `.submit-button`) > class with static + dynamic parts (e.g., `[class^="foo-"]` || `[class*=" -ooba-"]`) || `class$="-bar"]` > `:nth-child()` || `:nth-of-type()`
- **Visibility over Existence:** Use `.should('be.visible')` not `.should('exist')`
- **Session Caching:** Use `cy.sessionLogin()` for authenticated tests (except login specs)

## Essential Patterns

- Use **`beforeEach`** for setup. Avoid `before`, `after`, `afterEach`
- Use **`context()`** to organize sub-features within `describe()` blocks
- Use **`.as('alias')`** to avoid selector repetition
- Always **destructure** in `.then()` callbacks: `{ body, status }` not `response.body`
- For **`.last()`** elements, verify list length first
- For **negative assertions**, run a positive assertion first
- Use **`{ log: false }`** with sensitive data in `cy.env()` and `.type()`
EOF
# Version and commit all the files and directories
git add .
git commit -m "Create cypress project"
# Open the project on VSCode
code .
