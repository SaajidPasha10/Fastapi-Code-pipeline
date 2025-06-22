#!/bin/bash
pkill -f "uvicorn app:app" || true
