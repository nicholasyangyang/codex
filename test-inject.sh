#!/bin/bash
# Test script for Codex external message injection via Unix socket.
#
# Usage:
#   1. Start Codex in another terminal:
#      cd /home/deeptuuk/AgentChat/codex/codex-rs
#      RUST_LOG=codex_tui=info cargo run -p codex-cli
#
#   2. Find the socket (replace <PID> with the codex process PID):
#      ls /tmp/codex-inject-*.sock
#
#   3. Run this script:
#      ./test-inject.sh /tmp/codex-inject-<PID>.sock "Hello from external!"
#
# Or with JSON format:
#      ./test-inject.sh /tmp/codex-inject-<PID>.sock '{"text":"Hello from external!"}'

SOCKET="$1"
MESSAGE="$2"

if [ -z "$SOCKET" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: $0 <socket-path> <message>"
    echo ""
    echo "Available sockets:"
    ls /tmp/codex-inject-*.sock 2>/dev/null || echo "  (none found - is codex running?)"
    exit 1
fi

if [ ! -S "$SOCKET" ]; then
    echo "Error: $SOCKET is not a Unix socket"
    exit 1
fi

echo "$MESSAGE" | socat - UNIX-CONNECT:"$SOCKET"
echo "Sent: $MESSAGE"
