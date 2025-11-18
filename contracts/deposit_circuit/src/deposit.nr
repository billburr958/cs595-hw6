use dep::merkle_trees::compute_merkle_root;
use dep::std::hash::pedersen_hash;

fn main(
    // Private inputs
    id: Field,
    r: Field,
    oldPath: [Field; 8],

    // Public inputs
    oldRoot: pub Field,
    newRoot: pub Field,
    commitment: pub Field,
    index: pub Field,
) {
    // 1. Enforce commitment = PedersenHash(id, r)
    let computed_commitment = pedersen_hash([id, r]);
    assert(computed_commitment == commitment);

    // 2. Recompute old root assuming the leaf at `index` was the "zero" leaf.
    //    This constant is the same as MerkleTree.zeroValue in MerkleTree.ts.
    let zero_leaf: Field =
        0x2df8b940e5890e4e1377e05373fae69a1d754f6935e6a780b666947431f2cdcd;

    let recomputed_old_root = compute_merkle_root(zero_leaf, index, oldPath);
    assert(recomputed_old_root == oldRoot);

    // 3. Recompute new root after inserting the commitment at that index.
    let recomputed_new_root = compute_merkle_root(commitment, index, oldPath);
    assert(recomputed_new_root == newRoot);
}
