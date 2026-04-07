# cysh

This project offers a single shell script that quickly initializes a [Cypress](https://cypress.io) testing automation project from scratch.

> **Notes:**
>
> - This script only works on Unix-based operating systems, such as Linux and OSX.
>
> - The script expects a `workspaces/` directory at the same root where you run it, otherwise, it will fail. If you don't have it, create it before running the script:
>
> ```bash
> mkdir workspaces
> ```

## Usage

1. Download the [`cy.sh`](./cy.sh) file and move it to your root directory

2. In the root directory, run `./cy.sh name-of-the-project-you-want-to-create` to create a Cypress project from scratch (you might have first to give execution permission to the `cy.sh` file)
  2.1. Alternatively, you can run `./cy.sh name-of-your-project-here x.x.x` (where `x.x.x` is the specific Cypress version you want to install). Otherwise, the latest version is installed.
  2.2. Optionally, pass a third argument with your GitHub username to set the remote origin and README badge. If omitted, it defaults to `wlsf82`.

Examples:

```bash
# Latest Cypress, default GitHub user (wlsf82)
./cy.sh my-repo

# Specific Cypress version, default GitHub user (wlsf82)
./cy.sh my-repo 15.8.1

# Latest Cypress with a custom GitHub user (leave version empty)
./cy.sh my-repo "" my-gh-user

# Specific Cypress version and custom GitHub user
./cy.sh my-repo 15.8.1 my-gh-user
```

3. After the script is executed, access the newly created project and start working on it.

## What does `cy.sh` do?

- Creates the project directory and accesses it
- Initializes git and creates a `.gitignore` file with common Cypress exclusions
- Links the local repository with a remote GitHub repository
- Creates a `README.md` file with a GitHub Actions CI badge
- Initializes npm with a `package.json` file including Cypress scripts
- Adds an MIT license file with the current year
- Installs Cypress (specific version if provided, otherwise the latest)
- Creates `cypress.env.json` and `cypress.env.example.json` files
- Creates a `cypress.config.js` file with basic E2E test configuration
- Creates a sample test file (`cypress/e2e/spec.cy.js`) with a test suite skeleton
- Creates a GitHub Actions workflow (`.github/workflows/ci.yml`) to run tests on push
- Creates comprehensive Copilot instructions for Cypress testing:
  - Main instructions file (`.github/copilot-instructions.md`)
  - Topic-based guides covering project structure, test organization, authentication, selectors, commands, assertions, code quality, and component testing
  - A Cypress automation skill file (`SKILL.md`) for quick reference
- Commits all files with "Create cypress project" message
- Opens the project in VS Code

## Support this project

If you liked this project, consider leaving a ⭐.

___

Created with 🖤 by [Walmyr](https://walmyr.dev).
