use std::env;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    prost_build::compile_protos(
        &[
            "../proto/calculator.proto",
            "../proto/complex_data.proto",
        ],
        &["../proto/"],
    )?;

    let crate_dir = env::var("CARGO_MANIFEST_DIR")?;
    cbindgen::Builder::new()
        .with_crate(crate_dir)
        .with_config(cbindgen::Config::from_file("cbindgen.toml")?)
        .generate()?
        .write_to_file("rust_lib.h");

    Ok(())
}
