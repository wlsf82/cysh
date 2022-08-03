# cysh

This project offers a single shell script that quickly initializes a [Cypress](https://cypress.io) testing automation project from scratch.

> **Note:** This script only works on Unix-based operating systems, such as Linux and macOS.

## Usage

1. Download the [`cy.sh`](./cy.sh) file and move it to your root directory
2. In the root directory, run `./cy.sh name-of-the-project-you-want-to-create-here` to create a Cypress project from scratch (you might have to first give execution permission to the `cy.sh` file)
- 2.1. Alternatively, you can run `./cy.sh name-of-your-project-here x.x.x` if you want to install a specific version of Cypress, other than its latest version.
3. Close Cypress and access the newly created project (e.g., `cd name-of-your-project-here/`)
4. Open it on your favorite IDE and start writing your Cypress tests! 🙌

## What does `cy.sh` do?

1. It creates a project directory and accesses it
2. Then, it initialize git and .gitignore
3. After that, it creates a readme file to be defined
4. It then initializes NPM
5. It installs Cypress (if a version is provided, it will install it; otherwise, the latest version is installed)
6. It creates cypress.env and cypress.env.example files defaulting them to empty objects
7. Finally, it opens Cypress for the first time so that it creates its default structure.

## Support this project

If you liked this project, consider leaving a ⭐.

___

Created with 🖤 by [Walmyr](https://walmyr.dev).
