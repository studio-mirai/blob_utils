module blob_utils::blob_utils;

use codec::base64url::{encode, decode};
use std::string::String;
use sui::bcs;

//=== Public Functions ===

// Convert a Walrus blob ID encoded in URL-safe Base64 to a u256.
public fun blob_id_to_u256(blob_id_b64: String): u256 {
    bcs::peel_u256(&mut bcs::new(decode(blob_id_b64)))
}

// Convert a u256 to a Walrus blob ID encoded in URL-safe Base64.
public fun blob_id_to_string(blob_id_u256: u256): String {
    encode(bcs::to_bytes(&blob_id_u256))
}

//=== Test Functions ===

#[test]
fun test_to_u256() {
    let blob_id_b64_string = b"G_yJ1_4w0Cqtc5b4QqVlSxW2ejaOx4nDdn6SLEe_h48".to_string();
    let blob_id_256 = to_u256(blob_id_b64_string);
    assert!(
        blob_id_256 == 64920581853554630756702829916328823282551178707586530945570764805840887741467,
    );
}

#[test]
fun test_to_b64_string() {
    let blob_id_u256: u256 =
        64920581853554630756702829916328823282551178707586530945570764805840887741467;
    let blob_id_b64_string = to_b64_string(blob_id_u256);
    assert!(blob_id_b64_string  == b"G_yJ1_4w0Cqtc5b4QqVlSxW2ejaOx4nDdn6SLEe_h48".to_string());
}
