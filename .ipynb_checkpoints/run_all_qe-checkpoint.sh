#!/bin/bash
set -euo pipefail

# =========================
# User settings
# =========================
INPUT_ROOT="qe_inputs_by_structure"
PSEUDO_SRC="$(pwd)/pseudo"

NPROC_PER_JOB=4
MAX_PARALLEL_JOBS=4

PW_CMD="pw.x"

# =========================
# Environment
# =========================
ulimit -s unlimited
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

# =========================
# Basic checks
# =========================
if ! command -v "$PW_CMD" >/dev/null 2>&1; then
    echo "[ERROR] Cannot find $PW_CMD in PATH"
    exit 1
fi

if [ ! -d "$INPUT_ROOT" ]; then
    echo "[ERROR] Cannot find input directory: $INPUT_ROOT"
    exit 1
fi

if [ ! -d "$PSEUDO_SRC" ]; then
    echo "[ERROR] Cannot find pseudo directory: $PSEUDO_SRC"
    exit 1
fi

# =========================
# Run function
# =========================
run_one() {
    infile="$1"
    workdir="$(dirname "$infile")"
    name="$(basename "$infile" .in)"

    echo "======================================"
    echo "[START] $infile"
    echo "Workdir: $workdir"
    echo "Name: $name"
    echo "======================================"

    cd "$workdir"

    # Avoid QE tmp/outdir error
    mkdir -p tmp
    mkdir -p pseudo

    # Make pseudo available inside each folder
    # Use symlinks to avoid copying large pseudo files repeatedly
    for pp in "$PSEUDO_SRC"/*; do
        ln -sf "$pp" pseudo/
    done

    # If previous crash left partial files, keep them but use separate output log
    if mpirun -np "$NPROC_PER_JOB" "$PW_CMD" < "${name}.in" > "${name}.out" 2> "${name}.err"; then
        echo "[DONE] $name"
    else
        echo "[FAILED] $name"
        echo "Check: $workdir/${name}.out"
        echo "Check: $workdir/${name}.err"
        exit 1
    fi
}

export -f run_one
export PSEUDO_SRC NPROC_PER_JOB PW_CMD

# =========================
# Run all inputs in parallel
# =========================
find "$INPUT_ROOT" -name "*.in" | sort | \
xargs -I{} -P "$MAX_PARALLEL_JOBS" bash -c 'run_one "$@"' _ {}

echo "All QE jobs finished."