# Contributing to Workflow Examples

Thank you for your interest in contributing to this repository! This guide will help you get started.

## 🎯 Types of Contributions

We welcome the following types of contributions:

1. **New Examples**: Add new reusable workflows, composite actions, or bash actions
2. **Improvements**: Enhance existing examples with better practices or features
3. **Documentation**: Improve README, add comments, or create tutorials
4. **Bug Fixes**: Fix issues in existing examples

## 📋 Guidelines

### Adding New Examples

When adding a new example, please:

1. **Choose the Right Category**:
   - Reusable workflows go in `.github/workflows/`
   - Composite actions go in `.github/actions/<action-name>/`
   - Bash actions can be simple (inline) or use separate script files

2. **Follow Naming Conventions**:
   - Use descriptive names: `reusable-<purpose>.yml`
   - Action folders: `<type>-<name>` (e.g., `composite-setup`)
   - Demo workflows: `demo-<feature>.yml`

3. **Include Documentation**:
   - Add clear descriptions in action metadata
   - Document all inputs and outputs
   - Include usage examples in comments
   - Update the main README.md

4. **Add a Demo**:
   - Create or update a demo workflow showing how to use your example
   - Test that the demo works correctly

### Code Style

- **YAML Files**:
  - Use 2 spaces for indentation
  - Quote strings that contain special characters
  - Add comments for complex logic
  
- **Bash Scripts**:
  - Use `set -e` for error handling
  - Add comments explaining logic
  - Validate inputs
  - Use meaningful variable names

- **Action Metadata**:
  ```yaml
  name: 'Action Name'
  description: 'Clear description of what it does'
  author: 'Your Name or Organization'
  
  inputs:
    input-name:
      description: 'What this input does'
      required: false
      default: 'sensible-default'
  ```

### Testing

Before submitting:

1. Test your examples in a fork or test repository
2. Verify all inputs and outputs work as documented
3. Check that error cases are handled gracefully
4. Ensure demo workflows run successfully

## 🚀 Submission Process

1. **Fork the Repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR-USERNAME/workflow-examples.git
   cd workflow-examples
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/my-new-example
   ```

3. **Make Your Changes**
   - Add your examples
   - Update documentation
   - Test thoroughly

4. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add: description of your contribution"
   ```

5. **Push and Create PR**
   ```bash
   git push origin feature/my-new-example
   # Then create a Pull Request on GitHub
   ```

### PR Description Template

```markdown
## Description
Brief description of what this PR adds or changes.

## Type of Change
- [ ] New example
- [ ] Enhancement to existing example
- [ ] Documentation improvement
- [ ] Bug fix

## Testing
Describe how you tested your changes.

## Checklist
- [ ] Code follows the style guidelines
- [ ] Documentation is updated
- [ ] Examples are tested and working
- [ ] Demo workflow is included/updated
```

## 💡 Example Ideas

Looking for inspiration? Here are some examples we'd love to see:

- **Reusable Workflows**:
  - Security scanning workflow
  - Release automation workflow
  - Multi-platform build workflow
  - Database migration workflow

- **Composite Actions**:
  - Docker build and push action
  - Notification action (Slack, Teams, etc.)
  - Code quality checks action
  - Multi-language setup action

- **Bash Actions**:
  - Version bumping action
  - Changelog generator
  - Environment variable validator
  - File content processor

## ❓ Questions?

If you have questions or need help:

1. Check existing issues and discussions
2. Open a new issue with the `question` label
3. Reach out to maintainers

## 📜 Code of Conduct

Be respectful, inclusive, and constructive. We're all here to learn and improve.

Thank you for contributing! 🎉
