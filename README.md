# GitHub Actions Workflow Examples

A comprehensive collection of examples demonstrating GitHub Actions reusable workflows, composite actions, and bash-based actions.

## 📚 Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Reusable Workflows](#reusable-workflows)
- [Composite Actions](#composite-actions)
- [Bash-Based Actions](#bash-based-actions)
- [Demo Workflows](#demo-workflows)
- [Usage Examples](#usage-examples)
- [Best Practices](#best-practices)
- [Contributing](#contributing)

## 🎯 Overview

This repository provides practical examples of three key GitHub Actions features:

1. **Reusable Workflows**: Complete workflows that can be called from other workflows
2. **Composite Actions**: Custom actions composed of multiple steps
3. **Bash-Based Actions**: Simple actions using shell scripts

Each example includes detailed inline documentation and demonstrates real-world use cases.

## 📁 Repository Structure

```
.github/
├── workflows/
│   ├── reusable-ci.yml              # Reusable CI workflow
│   ├── reusable-deploy.yml          # Reusable deployment workflow
│   ├── demo-reusable-workflows.yml  # Demo using reusable workflows
│   ├── demo-composite-actions.yml   # Demo using composite actions
│   └── demo-bash-actions.yml        # Demo using bash actions
└── actions/
    ├── composite-setup/             # Composite action for environment setup
    │   └── action.yml
    ├── composite-build-test/        # Composite action for build and test
    │   └── action.yml
    ├── bash-simple/                 # Simple inline bash action
    │   └── action.yml
    └── bash-script/                 # Bash action with separate script
        ├── action.yml
        └── script.sh
```

## 🔄 Reusable Workflows

Reusable workflows allow you to call an entire workflow from another workflow, promoting DRY (Don't Repeat Yourself) principles.

### Reusable CI Workflow

**Location**: `.github/workflows/reusable-ci.yml`

A flexible CI workflow that can be called with different parameters:

**Features**:
- Configurable Node.js version
- Optional test execution
- Outputs test results
- Standard CI steps: checkout, setup, install, lint, test, build

**Usage**:
```yaml
jobs:
  ci:
    uses: ./.github/workflows/reusable-ci.yml
    with:
      node-version: '20'
      run-tests: true
```

### Reusable Deployment Workflow

**Location**: `.github/workflows/reusable-deploy.yml`

A deployment workflow supporting multiple environments:

**Features**:
- Environment-specific deployments (staging/production)
- Artifact download and deployment
- Secret handling for deploy tokens
- Post-deployment verification

**Usage**:
```yaml
jobs:
  deploy:
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: staging
      artifact-name: build-artifact
    secrets:
      DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
```

## 🧩 Composite Actions

Composite actions group multiple steps into a reusable action that can be used across workflows.

### Setup Environment Action

**Location**: `.github/actions/composite-setup/action.yml`

Sets up the development environment with Node.js and dependencies:

**Features**:
- Node.js installation with configurable version
- Dependency caching
- Optional dependency installation
- Outputs: node version and cache hit status

**Usage**:
```yaml
- name: Setup environment
  uses: ./.github/actions/composite-setup
  with:
    node-version: '18'
    cache-dependency-path: 'package-lock.json'
    install-dependencies: 'true'
```

### Build and Test Action

**Location**: `.github/actions/composite-build-test/action.yml`

Runs linting, building, and testing with configurable commands:

**Features**:
- Configurable build and test commands
- Optional test skipping
- Coverage report upload
- Build summary in GitHub UI
- Outputs: build and test status

**Usage**:
```yaml
- name: Build and test
  uses: ./.github/actions/composite-build-test
  with:
    build-command: 'npm run build'
    test-command: 'npm test'
    skip-tests: 'false'
    upload-coverage: 'true'
```

## 💻 Bash-Based Actions

Bash-based actions use shell scripts to perform custom operations.

### Simple Bash Action

**Location**: `.github/actions/bash-simple/action.yml`

A simple greeting action demonstrating inline bash scripting:

**Features**:
- Customizable greeting and name
- Multiple output formats (text/json)
- Timestamp output
- Step summary generation

**Usage**:
```yaml
- name: Generate greeting
  uses: ./.github/actions/bash-simple
  with:
    name: 'World'
    greeting: 'Hello'
    format: 'text'
```

### File Processor Action

**Location**: `.github/actions/bash-script/`

A more complex action using a separate bash script file:

**Features**:
- File counting, listing, and size calculation
- Pattern matching support
- Multiple operations (count/list/size)
- Separate script file for better organization

**Usage**:
```yaml
- name: Count files
  uses: ./.github/actions/bash-script
  with:
    path: './'
    pattern: '*.md'
    operation: 'count'
```

## 🎬 Demo Workflows

Three demonstration workflows show how to use all the examples:

### Demo: Reusable Workflows
**File**: `.github/workflows/demo-reusable-workflows.yml`

Demonstrates calling reusable workflows with different parameters and chaining them together.

### Demo: Composite Actions
**File**: `.github/workflows/demo-composite-actions.yml`

Shows how to use composite actions in real workflows, including accessing outputs.

### Demo: Bash Actions
**File**: `.github/workflows/demo-bash-actions.yml`

Illustrates both simple inline bash actions and script-based bash actions.

## 📖 Usage Examples

### Calling a Reusable Workflow

```yaml
name: My Workflow

on: [push]

jobs:
  build:
    uses: owner/repo/.github/workflows/reusable-ci.yml@main
    with:
      node-version: '18'
```

### Using a Composite Action

```yaml
steps:
  - uses: actions/checkout@v4
  - uses: ./.github/actions/composite-setup
    with:
      node-version: '20'
```

### Using a Bash Action

```yaml
steps:
  - uses: actions/checkout@v4
  - uses: ./.github/actions/bash-simple
    with:
      name: 'GitHub'
      greeting: 'Hi'
```

## ✨ Best Practices

### Reusable Workflows
- Use `workflow_call` trigger
- Define clear inputs and outputs
- Document parameters with descriptions
- Version your workflows (use tags/branches)
- Keep workflows focused on a single purpose

### Composite Actions
- Use meaningful names and descriptions
- Provide sensible defaults for inputs
- Document all inputs and outputs
- Use `shell: bash` for shell steps
- Group related steps together

### Bash Actions
- Set `set -e` for error handling
- Validate inputs before processing
- Use environment variables for inputs
- Output to `$GITHUB_OUTPUT` for action outputs
- Use `$GITHUB_STEP_SUMMARY` for rich summaries
- Make scripts executable (`chmod +x`)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests with:
- New example workflows or actions
- Improvements to existing examples
- Documentation enhancements
- Bug fixes

## 📝 License

See the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [Creating Composite Actions](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action)
- [Creating a JavaScript Action](https://docs.github.com/en/actions/creating-actions/creating-a-javascript-action)