"""Benchmark datasketch MinHashLSH on the shared synthetic corpus.

Mirrors LimpiaR's pipeline: 3-word shingles, 100 hash functions,
threshold 0.7, groups formed with union-find, first document kept.
"""

import csv
import sys
import time

from datasketch import MinHash, MinHashLSH

CORPUS = sys.argv[1] if len(sys.argv) > 1 else "../corpus_1e5.csv"
NUM_PERM = 100
THRESHOLD = 0.7
SHINGLE = 3

start = time.perf_counter()

docs = {}
with open(CORPUS, newline="") as f:
    for row in csv.DictReader(f):
        words = row["text"].lower().split()
        shingles = {
            " ".join(words[i : i + SHINGLE])
            for i in range(len(words) - SHINGLE + 1)
        }
        if shingles:
            docs[int(row["id"])] = shingles

t_load = time.perf_counter()

lsh = MinHashLSH(threshold=THRESHOLD, num_perm=NUM_PERM)
minhashes = {}
for doc_id, shingles in docs.items():
    m = MinHash(num_perm=NUM_PERM, seed=1)
    m.update_batch([s.encode("utf8") for s in shingles])
    minhashes[doc_id] = m
    lsh.insert(doc_id, m)

t_index = time.perf_counter()

parent = {doc_id: doc_id for doc_id in docs}


def find(i):
    while parent[i] != i:
        parent[i] = parent[parent[i]]
        i = parent[i]
    return i


for doc_id, m in minhashes.items():
    for match in lsh.query(m):
        if match == doc_id:
            continue
        ra, rb = find(doc_id), find(match)
        if ra < rb:
            parent[rb] = ra
        elif rb < ra:
            parent[ra] = rb

removed = sorted(d for d in docs if find(d) != d)
t_end = time.perf_counter()

print(f"docs: {len(docs)}")
print(f"shingle+load: {t_load - start:.1f}s")
print(f"minhash+index: {t_index - t_load:.1f}s")
print(f"query+group: {t_end - t_index:.1f}s")
print(f"total: {t_end - start:.1f}s")
print(f"removed: {len(removed)}")

with open("removed_py.csv", "w") as f:
    f.write("document\n")
    f.writelines(f"{d}\n" for d in removed)
