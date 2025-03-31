module blob_utils::blob_utils;

use codec::base64;
use std::string::String;
use sui::bcs;

//=== Public Functions ===

public fun blob_id_b64_to_u256(blob_id_b64: String): u256 {
    bcs::peel_u256(&mut bcs::new(base64::decode(blob_id_b64)))
}

public fun blob_id_u256_to_b64(blob_id_u256: u256): String {
    base64::encode(bcs::to_bytes(&blob_id_u256))
}

//=== Test Functions ===

#[test]
fun test_blob_id_b64_to_u256() {
    let blob_id_b64 = b"DbuJ7GRmwjoqo1LDp2qk/H/aI1ycOi2lH3Ka4ATdLzo=".to_string();
    let blob_id_256 = blob_id_b64_to_u256(blob_id_b64);
    assert!(
        blob_id_256 == 26318712447309950621133794408605739963587829295802287350894110878892617743117,
    );
}

#[test]
fun test_blob_id_u256_to_b64() {
    let blob_id_u256: u256 =
        26318712447309950621133794408605739963587829295802287350894110878892617743117;
    let blob_id_b64 = blob_id_u256_to_b64(blob_id_u256);
    assert!(blob_id_b64 == b"DbuJ7GRmwjoqo1LDp2qk/H/aI1ycOi2lH3Ka4ATdLzo=".to_string());
}
