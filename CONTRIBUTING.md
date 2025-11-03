# Contributing to Proto2FFI

Thank you for your interest in contributing to Proto2FFI! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Project Structure](#project-structure)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

We are committed to providing a welcoming and inclusive environment. Please:

- Be respectful and professional
- Be open to constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites

- Rust 1.70 or later
- Dart SDK 3.0 or later
- protoc (Protocol Buffer compiler)
- Git

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork:

```bash
git clone https://github.com/YOUR_USERNAME/proto2ffi.git
cd proto2ffi
```

3. Add upstream remote:

```bash
git remote add upstream https://github.com/santoshakil/proto2ffi.git
```

### Build the Project

```bash
cargo build
cargo test
```

### Run Examples

```bash
cd examples/hello_world/rust_service
cargo build --release

cd ../dart_client
dart pub get
dart run lib/main.dart
```

## Development Workflow

### 1. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Test improvements

### 2. Make Changes

Follow the [Coding Standards](#coding-standards) below.

### 3. Test Your Changes

```bash
cargo test
cargo clippy
cargo fmt --check
```

### 4. Commit Your Changes

Write clear, concise commit messages:

```bash
git add .
git commit -m "feat: add streaming RPC support"
```

Commit message format:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Test improvements
- `chore:` - Maintenance tasks

### 5. Keep Your Branch Updated

```bash
git fetch upstream
git rebase upstream/main
```

### 6. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## Project Structure

```
proto2ffi/
├── proto2ffi-core/           # Core library
│   ├── src/
│   │   ├── parser/           # Proto file parsing
│   │   ├── model/            # Data models (Service, Method, Message)
│   │   └── generator/        # Code generation
│   │       ├── rust/         # Rust FFI generator
│   │       └── dart/         # Dart client generator
│   └── Cargo.toml
├── proto2ffi-cli/            # CLI tool
│   ├── src/
│   │   └── main.rs
│   └── Cargo.toml
├── proto2ffi-runtime/        # Runtime support
│   ├── rust/                 # Rust runtime
│   └── dart/                 # Dart runtime
├── examples/                 # Example projects
│   └── hello_world/
├── docs/                     # Documentation
├── research/                 # Performance analysis
└── Cargo.toml                # Workspace config
```

## Coding Standards

### Rust Code Style

Follow standard Rust conventions:

```rust
// Use descriptive names
fn generate_service_trait(service: &ProtoService) -> String { }

// Document public APIs
/// Generates Rust FFI exports for a service.
///
/// # Arguments
///
/// * `service` - The protobuf service definition
/// * `output_dir` - Directory for generated code
pub fn generate_ffi_exports(
    service: &ProtoService,
    output_dir: &Path
) -> Result<()> { }

// Use Result for error handling
fn parse_proto(path: &Path) -> Result<ProtoFile> {
    let parser = ProtoParser::new();
    parser.parse_file(path)
}

// Prefer `?` over unwrap/expect
fn process() -> Result<()> {
    let data = read_file(path)?;
    let parsed = parse_data(&data)?;
    Ok(())
}
```

### Dart Code Style

Follow Dart conventions:

```dart
// Use descriptive names
class GreeterClient {
  final ffi.DynamicLibrary _dylib;

  // Document public APIs
  /// Calls the say_hello RPC method.
  ///
  /// Returns null if the call fails.
  List<int>? say_hello(List<int> requestBytes) { }

  // Use nullable types appropriately
  User? getUser(int id) { }

  // Prefer expression bodies for simple functions
  bool isValid(int id) => id > 0;
}
```

### Code Formatting

Rust:
```bash
cargo fmt
```

Dart:
```bash
dart format .
```

### Linting

Rust:
```bash
cargo clippy -- -D warnings
```

## Testing

### Unit Tests

Write unit tests for all new functionality:

**Rust:**

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_service_trait_generation() {
        let service = ProtoService::new("Greeter".to_string());
        let code = generate_service_trait(&service);
        assert!(code.contains("pub trait Greeter"));
    }
}
```

**Dart:**

```dart
import 'package:test/test.dart';

void main() {
  test('client calls FFI function correctly', () {
    // Test implementation
  });
}
```

### Integration Tests

Add integration tests for end-to-end functionality:

```rust
#[test]
fn test_code_generation_roundtrip() {
    // Parse proto
    let proto_files = parser.parse_file("test.proto").unwrap();

    // Generate code
    generator::rust::generate(&proto_files, Path::new("output")).unwrap();

    // Verify generated files exist
    assert!(Path::new("output/greeter.rs").exists());
}
```

### Running Tests

```bash
# Run all tests
cargo test

# Run specific test
cargo test test_name

# Run with output
cargo test -- --nocapture

# Run Dart tests
cd dart_client
dart test
```

## Areas for Contribution

### High Priority

- [ ] Streaming RPC support (client/server/bidirectional)
- [ ] Async/await support
- [ ] Better error type generation
- [ ] Middleware/interceptor support

### Medium Priority

- [ ] Code generation optimizations
- [ ] More examples (database service, file operations, etc.)
- [ ] Performance benchmarks for different message sizes
- [ ] Better error messages in CLI

### Low Priority

- [ ] IDE plugin support
- [ ] Web assembly support
- [ ] Custom derive macros
- [ ] Proto3 optional field support

## Submitting Changes

### Pull Request Process

1. **Update Documentation**: Update relevant documentation for your changes

2. **Add Tests**: Ensure your changes are covered by tests

3. **Update Changelog**: Add entry to CHANGELOG.md (if exists)

4. **Create PR**: Create a pull request with:
   - Clear title describing the change
   - Detailed description of what and why
   - Link to related issues
   - Screenshots/examples if applicable

5. **Code Review**: Address review feedback promptly

6. **CI Checks**: Ensure all CI checks pass

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe testing done

## Checklist
- [ ] Code follows project style
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] All tests passing
- [ ] Clippy passes without warnings
- [ ] Code formatted with rustfmt/dart format
```

## Code Review Guidelines

When reviewing PRs:

- Be constructive and respectful
- Focus on code quality and design
- Suggest improvements, don't demand
- Test the changes locally if possible
- Approve only when satisfied

## Documentation

### Code Documentation

Document all public APIs:

```rust
/// Generates FFI bindings from protobuf service definitions.
///
/// # Arguments
///
/// * `proto_files` - Parsed proto files
/// * `output_dir` - Output directory for generated code
///
/// # Errors
///
/// Returns `Error::Io` if file operations fail.
///
/// # Example
///
/// ```
/// use proto2ffi_core::{ProtoParser, generator};
/// use std::path::Path;
///
/// let parser = ProtoParser::new();
/// let proto_files = parser.parse_file(Path::new("service.proto"))?;
/// generator::rust::generate(&proto_files, Path::new("output"))?;
/// ```
pub fn generate(proto_files: &[ProtoFile], output_dir: &Path) -> Result<()> {
    // Implementation
}
```

### User Documentation

Update relevant documentation:
- README.md - Overview and quick start
- docs/GETTING_STARTED.md - Tutorial
- docs/API.md - API reference
- docs/PERFORMANCE.md - Performance guide
- docs/PRODUCTION_GUIDE.md - Production deployment

## Performance Considerations

When contributing, consider:

- Minimize allocations in hot paths
- Use appropriate data structures
- Profile before optimizing
- Document performance characteristics
- Add benchmarks for critical paths

Example benchmark:

```rust
#[bench]
fn bench_code_generation(b: &mut Bencher) {
    let service = create_test_service();
    b.iter(|| {
        black_box(generate_service_trait(&service))
    });
}
```

## Questions or Issues?

- Open an issue for bugs or feature requests
- Start a discussion for questions or ideas
- Join our community chat (if available)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project README

Thank you for contributing to Proto2FFI!
