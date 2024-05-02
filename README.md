# cysh

This project offers a single shell script that quickly initializes a [Cypress](https://cypress.io) testing automation project from scratch.

> **Note:** This script only works on Unix-based operating systems, such as Linux and OSX.

## Usage

1. Download the [`cy.sh`](./cy.sh) file and move it to your root directory

2. In the root directory, run `./cy.sh name-of-the-project-you-want-to-create` to create a Cypress project from scratch (you might have first to give execution permission to the `cy.sh` file)
  2.1. Alternatively, you can run `./cy.sh name-of-your-project-here x.x.x` (where x.x.x is the specific Cypress version you want to install). Otherwise, the latest version is installed.

3. After the script is run, access the newly created directory and run `npx cypress open` to start Cypress for the first time so it will bootstrap itself.

## What does `cy.sh` do?

To understand exactly what it does, read the comments in the [cy.sh](./cy.sh) file.

## Support this project

If you liked this project, consider leaving a ⭐.

___

Created with 🖤 by [Walmyr](https://walmyr.dev).
