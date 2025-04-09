module blob_utils::blob_utils;

use blob_utils::urlsafe_base64::{encode, decode};
use std::string::String;
use sui::bcs;

//=== Public Functions ===

public fun b64_to_u256(blob_id_b64: String): u256 {
    bcs::peel_u256(&mut bcs::new(decode(blob_id_b64)))
}

public fun u256_to_b64(blob_id_u256: u256): String {
    encode(bcs::to_bytes(&blob_id_u256))
}

//=== Test Functions ===

#[test]
fun test_blob_id_b64_to_u256() {
    let blob_id_b64 = b"G_yJ1_4w0Cqtc5b4QqVlSxW2ejaOx4nDdn6SLEe_h48".to_string();
    let blob_id_256 = b64_to_u256(blob_id_b64);
    assert!(
        blob_id_256 == 64920581853554630756702829916328823282551178707586530945570764805840887741467,
    );
}

#[test]
fun test_blob_id_u256_to_b64() {
    let blob_id_u256: u256 =
        64920581853554630756702829916328823282551178707586530945570764805840887741467;
    let blob_id_b64 = u256_to_b64(blob_id_u256);
    assert!(blob_id_b64 == b"G_yJ1_4w0Cqtc5b4QqVlSxW2ejaOx4nDdn6SLEe_h48".to_string());
}
