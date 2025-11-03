use std::path::PathBuf;

fn main() {
    let out_dir = PathBuf::from(std::env::var("OUT_DIR").unwrap());

    prost_build::Config::new()
        .out_dir(&out_dir)
        .compile_protos(
            &["proto/benchmark.proto"],
            &["proto"],
        )
        .unwrap();
}
