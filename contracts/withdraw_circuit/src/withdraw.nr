use dep::merkle_trees::compute_merkle_root;
use dep::std::hash::pedersen_hash;

fn main(
    // Private inputs
    r: Field,
    index: Field,
    hashpath: [Field; 8],

    // Public inputs
    root: pub Field,
    id: pub Field,
) {
    // 1. Rebuild commitment from (id, r)
    let commitment = pedersen_hash([id, r]);

    // 2. Recompute Merkle root from this commitment and the supplied path
    let recomputed_root = compute_merkle_root(commitment, index, hashpath);

    // 3. Enforce that recomputed root equals the public root
    assert(recomputed_root == root);
}
