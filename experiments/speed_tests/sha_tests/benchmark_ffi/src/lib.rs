use sha1::{Digest, Sha1};

#[no_mangle]
pub fn sha(msg: String, count: usize) -> Vec<String> {
    let mut vec: Vec<String> = Vec::new();
    for _ in 0..count {
        let mut hasher = Sha1::new();
        hasher.update(&msg);
        vec.push(format!("{:x}", hasher.finalize()));
    }
    vec
}
