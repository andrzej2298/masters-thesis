use sha1::{Digest, Sha1};
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();

    let repeat_count = args[1].parse::<usize>().unwrap();

    let mut vec: Vec<String> = Vec::new();
    for _ in 0..repeat_count {
        let mut hasher = Sha1::new();
        hasher.update(b"helloworld");
        vec.push(format!("{:x}", hasher.finalize()));
    }
    println!("{:?}", vec);
}
