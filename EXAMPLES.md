# Detailed Examples and Use Cases

This document provides additional context and detailed examples for using the workflows and actions in this repository.

## Reusable Workflows

### Example 1: Multi-Stage Pipeline

Create a complete CI/CD pipeline using reusable workflows:

```yaml
name: Complete Pipeline

on:
  push:
    branches: [ main ]

jobs:
  # Stage 1: CI
  continuous-integration:
    uses: ./.github/workflows/reusable-ci.yml
    with:
      node-version: '20'
      run-tests: true
  
  # Stage 2: Deploy to Staging
  deploy-to-staging:
    needs: continuous-integration
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: staging
      artifact-name: build-artifact
    secrets:
      DEPLOY_TOKEN: ${{ secrets.STAGING_TOKEN }}
  
  # Stage 3: Integration Tests
  integration-tests:
    needs: deploy-to-staging
    runs-on: ubuntu-latest
    steps:
      - name: Run integration tests
        run: |
          echo "Running integration tests against staging..."
          # Your integration tests here
  
  # Stage 4: Deploy to Production
  deploy-to-production:
    needs: integration-tests
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: production
      artifact-name: build-artifact
    secrets:
      DEPLOY_TOKEN: ${{ secrets.PRODUCTION_TOKEN }}
```

### Example 2: Matrix Strategy with Reusable Workflow

Test across multiple Node.js versions:

```yaml
name: Multi-Version Testing

on: [push, pull_request]

jobs:
  test:
    strategy:
      matrix:
        node-version: [16, 18, 20]
    uses: ./.github/workflows/reusable-ci.yml
    with:
      node-version: ${{ matrix.node-version }}
      run-tests: true
```

## Composite Actions

### Example 3: Chaining Composite Actions

Use multiple composite actions in sequence:

```yaml
name: Full Build Pipeline

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Step 1: Setup
      - name: Setup environment
        id: setup
        uses: ./.github/actions/composite-setup
        with:
          node-version: '18'
          install-dependencies: 'true'
      
      # Step 2: Build and Test
      - name: Build and test
        id: build
        uses: ./.github/actions/composite-build-test
        with:
          build-command: 'npm run build'
          test-command: 'npm run test:coverage'
          upload-coverage: 'true'
      
      # Step 3: Use outputs from previous steps
      - name: Summary
        run: |
          echo "Setup completed with Node ${{ steps.setup.outputs.node-version }}"
          echo "Build status: ${{ steps.build.outputs.build-status }}"
          echo "Test status: ${{ steps.build.outputs.test-status }}"
```

### Example 4: Conditional Composite Action Usage

Use composite actions conditionally:

```yaml
name: Conditional Build

on: [pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup for PR
        uses: ./.github/actions/composite-setup
        with:
          node-version: '18'
      
      # Only run full tests on main branch PRs
      - name: Full test suite
        if: github.base_ref == 'main'
        uses: ./.github/actions/composite-build-test
        with:
          build-command: 'npm run build'
          test-command: 'npm run test:all'
          upload-coverage: 'true'
      
      # Run quick tests on other PRs
      - name: Quick tests
        if: github.base_ref != 'main'
        uses: ./.github/actions/composite-build-test
        with:
          build-command: 'npm run build'
          test-command: 'npm run test:quick'
          skip-tests: 'false'
```

## Bash Actions

### Example 5: Processing Files with Bash Action

Use the file processor action in various scenarios:

```yaml
name: File Processing Examples

on: [workflow_dispatch]

jobs:
  process-files:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Count different file types
      - name: Count markdown files
        id: count-md
        uses: ./.github/actions/bash-script
        with:
          path: './'
          pattern: '*.md'
          operation: 'count'
      
      - name: Count JavaScript files
        id: count-js
        uses: ./.github/actions/bash-script
        with:
          path: './src'
          pattern: '*.js'
          operation: 'count'
      
      # List specific files
      - name: List workflow files
        id: list-workflows
        uses: ./.github/actions/bash-script
        with:
          path: '.github/workflows'
          pattern: '*.yml'
          operation: 'list'
      
      # Calculate total size
      - name: Calculate action size
        id: action-size
        uses: ./.github/actions/bash-script
        with:
          path: '.github/actions'
          pattern: '*'
          operation: 'size'
      
      # Create summary
      - name: Create summary
        run: |
          echo "## File Statistics" >> $GITHUB_STEP_SUMMARY
          echo "- Markdown files: ${{ steps.count-md.outputs.count }}" >> $GITHUB_STEP_SUMMARY
          echo "- JavaScript files: ${{ steps.count-js.outputs.count }}" >> $GITHUB_STEP_SUMMARY
          echo "- Total action size: ${{ steps.action-size.outputs.total-size }} bytes" >> $GITHUB_STEP_SUMMARY
```

### Example 6: Custom Notifications with Bash Action

Use the simple bash action for notifications:

```yaml
name: Deployment with Notifications

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        type: choice
        options:
          - staging
          - production

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Send start notification
      - name: Deployment started
        uses: ./.github/actions/bash-simple
        with:
          name: ${{ github.actor }}
          greeting: 'Deployment to ${{ inputs.environment }} started by'
          format: 'text'
      
      # Actual deployment steps
      - name: Deploy
        run: |
          echo "Deploying to ${{ inputs.environment }}..."
          # Your deployment commands here
      
      # Send completion notification
      - name: Deployment completed
        if: success()
        uses: ./.github/actions/bash-simple
        with:
          name: ${{ inputs.environment }}
          greeting: 'Successfully deployed to'
          format: 'json'
```

## Advanced Patterns

### Example 7: Combining All Three Types

A real-world example using reusable workflows, composite actions, and bash actions:

```yaml
name: Advanced Pipeline

on: [push]

jobs:
  # Use composite actions for setup and build
  build:
    runs-on: ubuntu-latest
    outputs:
      artifact-name: ${{ steps.info.outputs.artifact }}
    steps:
      - uses: actions/checkout@v4
      
      - uses: ./.github/actions/composite-setup
        with:
          node-version: '20'
      
      - uses: ./.github/actions/composite-build-test
        with:
          build-command: 'npm run build:production'
          test-command: 'npm test'
      
      # Use bash action for file processing
      - name: Check artifact size
        id: size
        uses: ./.github/actions/bash-script
        with:
          path: './dist'
          pattern: '*'
          operation: 'size'
      
      - name: Set artifact info
        id: info
        run: |
          echo "artifact=build-${{ github.sha }}" >> $GITHUB_OUTPUT
          echo "Artifact size: ${{ steps.size.outputs.total-size }} bytes"
      
      - uses: actions/upload-artifact@v4
        with:
          name: ${{ steps.info.outputs.artifact }}
          path: ./dist
  
  # Use reusable workflow for deployment
  deploy:
    needs: build
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: staging
      artifact-name: ${{ needs.build.outputs.artifact-name }}
    secrets:
      DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
```

## Tips and Tricks

### Output Handling

Accessing outputs from different action types:

```yaml
# From reusable workflow
- uses: ./.github/workflows/reusable-ci.yml
  # Outputs available at job level: ${{ needs.job-id.outputs.output-name }}

# From composite action
- uses: ./.github/actions/composite-setup
  id: setup
  # Outputs available immediately: ${{ steps.setup.outputs.node-version }}

# From bash action
- uses: ./.github/actions/bash-simple
  id: greet
  # Outputs available immediately: ${{ steps.greet.outputs.message }}
```

### Error Handling

Best practices for error handling:

```yaml
# In composite actions - use continue-on-error
- name: Optional step
  uses: ./.github/actions/composite-build-test
  continue-on-error: true

# In bash actions - check exit codes
- name: Safe operation
  uses: ./.github/actions/bash-script
  with:
    path: './optional-dir'
    pattern: '*.txt'
    operation: 'count'
  # Action handles missing directories gracefully

# In reusable workflows - use if conditions
deploy:
  if: github.ref == 'refs/heads/main'
  uses: ./.github/workflows/reusable-deploy.yml
```

## Debugging

Enable debug logging:

```bash
# In your repository settings, add these secrets:
ACTIONS_STEP_DEBUG=true
ACTIONS_RUNNER_DEBUG=true
```

Add debug output in your actions:

```yaml
# In composite actions
- name: Debug info
  shell: bash
  run: |
    echo "::debug::Current directory: $(pwd)"
    echo "::debug::Files: $(ls -la)"
```

This should help you understand and use the examples more effectively!
