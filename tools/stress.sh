#!/usr/bin/env bash
# ==============================================================================
# Competitive Programming Stress Testing Utility
# ==============================================================================
# Usage:
#   tools/stress.sh <sol.cpp> <brute.cpp> <gen.cpp> [iterations=500]
#
# Arguments:
#   sol.cpp      : Fast candidate solution (compiled with Address/UB Sanitizers).
#   brute.cpp    : Slow but obviously correct brute-force solution.
#   gen.cpp      : Random test generator (receives seed as argv[1], prints test to stdout).
#   iterations   : Number of tests to execute before declaring success (default: 500).
#
# Output on Failure:
#   - failing_input.txt : The generated testcase that triggered the failure.
#   - failing_sol.txt   : Output produced by sol.cpp.
#   - failing_brute.txt : Expected output from brute.cpp.
# ==============================================================================

set -u

if [ $# -lt 3 ]; then
  echo "Usage: $0 <sol.cpp> <brute.cpp> <gen.cpp> [iterations=500]"
  exit 2
fi

SOL=$1
BRUTE=$2
GEN=$3
N=${4:-500}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

FLAGS="-std=c++17 -O2 -Wall -Wextra -Wno-unused-result"

echo "==> Compiling: $SOL (with sanitizers), $BRUTE, $GEN..."
g++ $FLAGS -fsanitize=address,undefined "$SOL" -o "$TMP/sol" || exit 1
g++ $FLAGS "$BRUTE" -o "$TMP/brute" || exit 1
g++ $FLAGS "$GEN" -o "$TMP/gen" || exit 1

echo "==> Running up to $N randomized tests..."

for i in $(seq 1 "$N"); do
  "$TMP/gen" "$i" > "$TMP/in.txt"

  timeout 5 "$TMP/sol" < "$TMP/in.txt" > "$TMP/out_sol.txt" 2> "$TMP/err.txt"
  rc=$?

  timeout 20 "$TMP/brute" < "$TMP/in.txt" > "$TMP/out_brute.txt" 2>/dev/null

  if [ $rc -ne 0 ]; then
    echo "[-] RUNTIME ERROR / TIMEOUT (exit code $rc) on seed $i"
    cp "$TMP/in.txt" failing_input.txt
    [ -s "$TMP/err.txt" ] && head -n 20 "$TMP/err.txt"
    echo "Saved failing input to failing_input.txt"
    exit 1
  fi

  if ! diff -bq "$TMP/out_sol.txt" "$TMP/out_brute.txt" > /dev/null; then
    echo "[-] MISMATCH on seed $i"
    cp "$TMP/in.txt" failing_input.txt
    cp "$TMP/out_sol.txt" failing_sol.txt
    cp "$TMP/out_brute.txt" failing_brute.txt
    echo "--- Input ---"
    head -n 25 "$TMP/in.txt"
    echo "--- Your Output ---"
    head -n 10 "$TMP/out_sol.txt"
    echo "--- Brute Output ---"
    head -n 10 "$TMP/out_brute.txt"
    echo "Artifacts saved: failing_input.txt, failing_sol.txt, failing_brute.txt"
    exit 1
  fi
done

echo "[+] OK: All $N tests passed successfully without mismatches."
