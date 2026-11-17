#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1

PORT=8004

echo "=================================================="
echo "Starting Scopion (mock data, port $PORT)..."
echo "=================================================="

# Recreate the virtual environment if it is missing or unusable (e.g. the project folder was renamed).
if ! venv/bin/python -c "import sys" >/dev/null 2>&1; then
    rm -rf venv
    python3 -m venv venv || { echo "Could not create a virtual environment (is python3 installed?)."; exit 1; }
fi

venv/bin/python -m pip install -q -r requirements.txt || { echo "Dependency install failed."; exit 1; }

# Only stop a previous Scopion server - never an unrelated process that happens to use the port.
PID="$(lsof -ti "tcp:$PORT" -sTCP:LISTEN 2>/dev/null | head -n 1)"
if [ -n "$PID" ]; then
    if ps -p "$PID" -o command= | grep -q "uvicorn main:app"; then
        kill "$PID" && sleep 1
    else
        echo "Port $PORT is in use by another program (PID $PID). Close it and run this again."
        exit 1
    fi
fi

echo "Booting up the local web server (127.0.0.1:$PORT)..."
nohup venv/bin/python -m uvicorn main:app --host 127.0.0.1 --port "$PORT" --log-level warning > /dev/null 2>&1 &

sleep 2
open "http://127.0.0.1:$PORT/Scopion"
exit 0
