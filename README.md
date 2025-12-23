# cysh

This project offers a single shell script that quickly initializes a [Cypress](https://cypress.io) testing automation project from scratch.

> **Note:** This script only works on Unix-based operating systems, such as Linux and OSX.

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

3. After the script is executed, access the newly created directory and start working on it.

## What does `cy.sh` do?

To understand exactly what it does, read the comments in the [`cy.sh`](./cy.sh) file.

## Support this project

If you liked this project, consider leaving a ⭐.

___

Created with 🖤 by [Walmyr](https://walmyr.dev).
