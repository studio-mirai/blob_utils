module blob_utils::blob_utils;

use codec::base64;
use std::string::String;
use sui::bcs;

public fun blob_id_u256_to_b64(blob_id_u256: u256): String {
    base64::encode(bcs::to_bytes(&blob_id_u256))
}

public fun blob_id_b64_to_u256(blob_id_b64: String): u256 {
    bcs::peel_u256(&mut bcs::new(base64::decode(blob_id_b64)))
}
