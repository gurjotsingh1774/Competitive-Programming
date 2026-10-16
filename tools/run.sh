#!/usr/bin/env bash
# ==============================================================================
# Competitive Programming C++ Compile & Run Helper
# ==============================================================================
# Overview:
#   A safe, automated build script for competitive programming that compiles
#   and executes C++ solutions with strict GCC sanitizers and debug flags.
#
# Usage:
#   tools/run.sh <source.cpp> [input_file] [mode: debug|fast]
#
# Arguments:
#   source.cpp : The C++ solution file to compile and execute (required).
#   input_file : Input testcase file (optional, defaults to "input.txt" if present).
#   mode       : Compilation mode:
#                  - "debug" (default): Enables AddressSanitizer, UndefinedBehaviorSanitizer,
#                    and _GLIBCXX_DEBUG to catch out-of-bounds indexing, pointer errors,
#                    and undefined behavior locally with exact line numbers.
#                  - "fast": Optimized -O2 release build mimicking the online judge
#                    (Codeforces, AtCoder, CSES) for benchmark testing.
#
# Examples:
#   tools/run.sh sol.cpp                     # Debug mode with sanitizers (reads input.txt if present)
#   tools/run.sh sol.cpp custom_in.txt       # Debug mode with custom input file
#   tools/run.sh sol.cpp input.txt fast      # Fast -O2 mode for benchmark and timing tests
# ==============================================================================

set -euo pipefail

# 1. Validate arguments
if [ $# -lt 1 ]; then
  echo "Usage: $0 <source.cpp> [input_file] [mode: debug|fast]"
  echo "Example: $0 sol.cpp input.txt debug"
  exit 1
fi

SRC=$1
IN=${2:-}
MODE=${3:-debug}
BIN="/tmp/cp_run_${USER:-user}"

# 2. Check source file existence
if [ ! -f "$SRC" ]; then
  echo "[-] Error: Source file '$SRC' not found."
  exit 1
fi

# 3. Compile based on mode
if [ "$MODE" = "fast" ]; then
  echo "==> Compiling '$SRC' in FAST mode (-O2 release)..."
  g++ -std=c++17 -O2 -Wall -Wextra -Wno-unused-result "$SRC" -o "$BIN"
else
  echo "==> Compiling '$SRC' in DEBUG mode (Sanitizers + _GLIBCXX_DEBUG)..."
  g++ -std=c++17 -g -O1 \
      -Wall -Wextra -Wno-unused-result -Wshadow \
      -D_GLIBCXX_DEBUG \
      -fsanitize=address,undefined \
      "$SRC" -o "$BIN"
fi

echo "==> Build successful. Executing..."
echo "----------------------------------------"

# 4. Execute with input redirection
if [ -n "$IN" ] && [ -f "$IN" ]; then
  "$BIN" < "$IN"
elif [ -z "$IN" ] && [ -f "input.txt" ]; then
  "$BIN" < "input.txt"
else
  "$BIN"
fi

echo "----------------------------------------"
echo "[+] Process finished."
