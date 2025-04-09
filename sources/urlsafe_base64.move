module blob_utils::urlsafe_base64;

use std::string::String;

const KEYS: vector<u8> = b"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

public(package) fun encode(mut bytes: vector<u8>): String {
    let keys = KEYS;
    let mut res = vector[];
    let mut len = bytes.length();
    bytes.reverse();

    while (len > 0) {
        let rem = if (len >= 3) 3 else len;

        let b1 = bytes.pop_back();
        len = len - 1;
        let b2 = if (rem > 1) {
            let b = bytes.pop_back();
            len = len - 1;
            b
        } else 0;

        let b3 = if (rem > 2) {
            let b = bytes.pop_back();
            len = len - 1;
            b
        } else 0;

        let c1 = b1 >> 2;
        let c2 = ((b1 & 3) << 4) | (b2 >> 4);
        let c3 = ((b2 & 15) << 2) | (b3 >> 6);
        let c4 = b3 & 63;

        res.push_back(keys[c1 as u64]);
        res.push_back(keys[c2 as u64]);
        if (rem > 1) res.push_back(keys[c3 as u64]);
        if (rem > 2) res.push_back(keys[c4 as u64]);
    };

    res.to_string()
}

public(package) fun decode(str: String): vector<u8> {
    let keys = KEYS;
    let mut res = vector[];
    let mut bytes = str.into_bytes();
    bytes.reverse();

    let mut chunk = vector[];

    while (!bytes.is_empty()) {
        let ch = bytes.pop_back();
        chunk.push_back(ch);

        if (chunk.length() == 4) {
            let (ok1, b1) = keys.index_of(&chunk[0]);
            let (ok2, b2) = keys.index_of(&chunk[1]);
            let (ok3, b3) = keys.index_of(&chunk[2]);
            let (ok4, b4) = keys.index_of(&chunk[3]);

            assert!(ok1 && ok2 && ok3 && ok4, 0);

            let c1 = (b1 << 2) | (b2 >> 4);
            let c2 = ((b2 & 15) << 4) | (b3 >> 2);
            let c3 = ((b3 & 3) << 6) | b4;

            res.push_back(c1 as u8);
            res.push_back(c2 as u8);
            res.push_back(c3 as u8);

            chunk = vector[];
        };
    };

    if (chunk.length() > 0) {
        let count = chunk.length();
        while (chunk.length() < 4) {
            chunk.push_back(keys[0]); // dummy pad with char that maps to 0
        };

        let (ok1, b1) = keys.index_of(&chunk[0]);
        let (ok2, b2) = keys.index_of(&chunk[1]);
        let (ok3, b3) = if (count > 2) keys.index_of(&chunk[2])
        else (true, 0);
        let (ok4, b4) = if (count > 3) keys.index_of(&chunk[3])
        else (true, 0);

        assert!(ok1 && ok2 && ok3 && ok4, 0);

        let c1 = (b1 << 2) | (b2 >> 4);
        let c2 = ((b2 & 15) << 4) | (b3 >> 2);
        let c3 = ((b3 & 3) << 6) | b4;

        res.push_back(c1 as u8);
        if (count > 2) res.push_back(c2 as u8);
        if (count > 3) res.push_back(c3 as u8);
    };

    res
}
