# Contributing to Proto2FFI

Thank you for your interest in contributing to Proto2FFI! This document provides guidelines and instructions for contributing.

## 🚀 Getting Started

### Prerequisites

- Rust 1.70 or later
- Dart/Flutter SDK 3.0 or later
- Git

### Setting Up Development Environment

1. **Clone the repository**:
```bash
git clone https://github.com/yourusername/proto2ffi
cd proto2ffi
```

2. **Build the project**:
```bash
cargo build
```

3. **Run tests**:
```bash
# Rust tests
cargo test

# Example Flutter plugin tests
cd examples/flutter_plugin
flutter pub get
dart test
```

## 📝 Code Style

### Rust

- Follow the [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
- Use `cargo fmt` before committing
- Run `cargo clippy` and fix all warnings
- Add documentation comments for public APIs

### Dart

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` before committing
- Run `dart analyze` and fix all issues
- Add documentation comments for public APIs

## 🔧 Development Workflow

1. **Create a feature branch**:
```bash
git checkout -b feature/your-feature-name
```

2. **Make your changes** following the code style guidelines

3. **Write tests** for your changes

4. **Ensure all tests pass**:
```bash
cargo test
cd examples/flutter_plugin && dart test
```

5. **Commit your changes**:
```bash
git add .
git commit -m "feat: add your feature description"
```

Use conventional commits:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `test:` for test additions/changes
- `refactor:` for code refactoring
- `perf:` for performance improvements

6. **Push and create a pull request**:
```bash
git push origin feature/your-feature-name
```

## 🧪 Testing Guidelines

### Unit Tests

- Write unit tests for all new functions
- Place tests in the same file as the code (Rust) or in `test/` (Dart)
- Test edge cases and error conditions

### Integration Tests

- Add integration tests for end-to-end functionality
- Test cross-language interactions
- Include performance benchmarks for critical paths

### Performance Tests

- Benchmark performance-critical code
- Compare against baseline measurements
- Document performance characteristics

## 📖 Documentation

### Code Documentation

- Document all public APIs with doc comments
- Include examples in doc comments
- Explain complex algorithms and design decisions

### User Documentation

- Update README.md for user-facing changes
- Add examples to `examples/` directory
- Update architecture docs in `docs/`

## 🐛 Bug Reports

When filing a bug report, please include:

1. **Description**: Clear description of the bug
2. **Reproduction**: Minimal code to reproduce the issue
3. **Expected behavior**: What you expected to happen
4. **Actual behavior**: What actually happened
5. **Environment**: OS, Rust version, Dart version
6. **Logs**: Relevant error messages or logs

## ✨ Feature Requests

For feature requests, please include:

1. **Use case**: Why is this feature needed?
2. **Proposed solution**: How would you implement it?
3. **Alternatives**: Other solutions you've considered
4. **Examples**: Code examples of how it would be used

## 🔍 Code Review Process

1. All changes require review before merging
2. Address reviewer feedback promptly
3. Keep PRs focused and reasonably sized
4. Ensure CI passes before requesting review

## 📋 Checklist Before Submitting PR

- [ ] Code follows project style guidelines
- [ ] All tests pass (`cargo test` and `dart test`)
- [ ] New tests added for new functionality
- [ ] Documentation updated
- [ ] Commit messages follow conventional commits
- [ ] No `println!` or debug code left in
- [ ] Performance impact considered and documented
- [ ] Breaking changes clearly marked

## 🎯 Priority Areas

We especially welcome contributions in these areas:

- **Platform support**: Windows, Android, iOS optimizations
- **Performance**: SIMD, memory optimization, benchmarks
- **Documentation**: Tutorials, guides, examples
- **Testing**: More test coverage, edge cases
- **Tooling**: IDE plugins, build tools integration

## 💡 Questions?

- Open a [Discussion](https://github.com/yourusername/proto2ffi/discussions)
- Join our community chat
- Email: your.email@example.com

## 📜 Code of Conduct

This project follows the [Rust Code of Conduct](https://www.rust-lang.org/policies/code-of-conduct). By participating, you agree to uphold this code.

---

Thank you for contributing to Proto2FFI! 🎉
