use anyhow::Result;
use clap::{Parser, Subcommand};
use colored::Colorize;
use proto2ffi_core::parser::ProtoParser;
use proto2ffi_core::Proto2Ffi;
use std::path::PathBuf;

#[derive(Parser)]
#[command(name = "proto2ffi")]
#[command(version)]
#[command(about = "Generate FFI bindings from protobuf service definitions", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Generate Rust and Dart code from proto files
    Generate {
        /// Proto file to parse
        #[arg(short, long)]
        proto: PathBuf,

        /// Output directory for Rust code
        #[arg(short, long)]
        rust_out: PathBuf,

        /// Output directory for Dart code
        #[arg(short, long)]
        dart_out: PathBuf,

        /// Include paths for proto imports
        #[arg(short, long)]
        includes: Vec<String>,
    },

    /// Show version information
    Version,
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    match cli.command {
        Commands::Generate {
            proto,
            rust_out,
            dart_out,
            includes,
        } => {
            generate(proto, rust_out, dart_out, includes)?;
        }
        Commands::Version => {
            println!("proto2ffi version {}", env!("CARGO_PKG_VERSION"));
        }
    }

    Ok(())
}

fn generate(
    proto_path: PathBuf,
    rust_out: PathBuf,
    dart_out: PathBuf,
    includes: Vec<String>,
) -> Result<()> {
    println!(
        "{} Generating FFI bindings from {}",
        "→".cyan(),
        proto_path.display()
    );

    let mut parser = ProtoParser::new();
    if !includes.is_empty() {
        parser = parser.with_includes(includes);
    }

    let proto_file = parser.parse_file(&proto_path)?;

    println!(
        "  {} Found {} service(s), {} message(s)",
        "✓".green(),
        proto_file.services.len(),
        proto_file.messages.len()
    );

    let mut generator = Proto2Ffi::new();
    generator.add_proto_file(proto_file);

    println!("{} Generating Rust code...", "→".cyan());
    generator.generate_rust(&rust_out)?;
    println!("  {} Generated Rust FFI exports", "✓".green());

    println!("{} Generating Dart code...", "→".cyan());
    generator.generate_dart(&dart_out)?;
    println!("  {} Generated Dart client", "✓".green());

    println!("\n{} Code generation complete!", "✓".green().bold());
    println!();
    println!("Next steps:");
    println!("  1. Add generated Rust files to your service");
    println!("  2. Implement the service trait");
    println!("  3. Build Rust as cdylib: cargo build --release");
    println!("  4. Copy .so/.dylib to your Dart project");
    println!("  5. Use the generated Dart client");

    Ok(())
}
