use clap::{Parser, Subcommand};
use colored::Colorize;
use proto2ffi_core::{calculate_layout, generate_all, parse_proto_file};
use std::path::PathBuf;

#[derive(Parser)]
#[command(name = "proto2ffi")]
#[command(version, about = "Generate zero-copy FFI bindings from Protocol Buffers", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Generate FFI bindings from a .proto file
    Generate {
        /// Path to the .proto file
        proto_file: PathBuf,

        /// Output directory for Rust code
        #[arg(long, short = 'r')]
        rust_out: PathBuf,

        /// Output directory for Dart code
        #[arg(long, short = 'd')]
        dart_out: PathBuf,

        /// Verbose output
        #[arg(long, short = 'v')]
        verbose: bool,
    },

    /// Validate a .proto file without generating code
    Validate {
        /// Path to the .proto file
        proto_file: PathBuf,
    },

    /// Show memory layout for a .proto file
    Layout {
        /// Path to the .proto file
        proto_file: PathBuf,

        /// Show detailed field-level layout
        #[arg(long)]
        detailed: bool,
    },
}

fn main() {
    if let Err(e) = run() {
        eprintln!("{} {}", "Error:".red().bold(), e);
        std::process::exit(1);
    }
}

fn run() -> anyhow::Result<()> {
    let cli = Cli::parse();

    match cli.command {
        Commands::Generate {
            proto_file,
            rust_out,
            dart_out,
            verbose,
        } => {
            if verbose {
                println!("{}", "🚀 Proto2FFI Code Generator".cyan().bold());
                println!();
            }

            println!(
                "{}",
                format!("   Input: {}", proto_file.display())
                    .dimmed()
            );

            let proto = parse_proto_file(&proto_file)?;

            if verbose {
                println!(
                    "{}",
                    format!(
                        "   Found {} messages, {} enums",
                        proto.messages.len(),
                        proto.enums.len()
                    )
                    .dimmed()
                );
            }

            let layout = calculate_layout(&proto, 8)?;

            if verbose {
                for msg in &layout.messages {
                    println!(
                        "{}",
                        format!(
                            "   {} - {} bytes (align: {})",
                            msg.name, msg.size, msg.alignment
                        )
                        .dimmed()
                    );
                }
                println!();
            }

            generate_all(&layout, &rust_out, &dart_out)?;

            println!(
                "   {} {}",
                "✓".green(),
                format!("Generated Rust: {}", rust_out.display())
            );
            println!(
                "   {} {}",
                "✓".green(),
                format!("Generated Dart: {}", dart_out.display())
            );
            println!();
            println!("{}", "✅ Successfully generated FFI bindings!".green().bold());

            Ok(())
        }

        Commands::Validate { proto_file } => {
            println!(
                "{}",
                format!("Validating: {}", proto_file.display()).cyan()
            );

            let proto = parse_proto_file(&proto_file)?;

            println!("   {} messages found", proto.messages.len());
            println!("   {} enums found", proto.enums.len());

            let layout = calculate_layout(&proto, 8)?;

            println!();
            println!("{}", "✅ Validation passed!".green().bold());
            println!(
                "   Total size: {} bytes",
                layout.messages.iter().map(|m| m.size).sum::<usize>()
            );

            Ok(())
        }

        Commands::Layout {
            proto_file,
            detailed,
        } => {
            let proto = parse_proto_file(&proto_file)?;
            let layout = calculate_layout(&proto, 8)?;

            println!("{}", "Memory Layout".cyan().bold());
            println!();

            for msg in &layout.messages {
                println!(
                    "  {} {} bytes (align: {})",
                    msg.name.yellow().bold(),
                    msg.size,
                    msg.alignment
                );

                if detailed {
                    for field in &msg.fields {
                        println!(
                            "    {} @ {} - {} bytes",
                            field.name.dimmed(),
                            field.offset,
                            field.size
                        );
                    }
                    println!();
                }
            }

            for enum_layout in &layout.enums {
                println!(
                    "  {} (enum - {} variants)",
                    enum_layout.name.yellow().bold(),
                    enum_layout.variants.len()
                );

                if detailed {
                    for (variant, value) in &enum_layout.variants {
                        println!("    {} = {}", variant.dimmed(), value);
                    }
                    println!();
                }
            }

            Ok(())
        }
    }
}
