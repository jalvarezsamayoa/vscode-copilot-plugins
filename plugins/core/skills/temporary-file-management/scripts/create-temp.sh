#!/bin/bash
# Utility: Create temporary file with automatic cleanup

# Usage:
#   source create-temp.sh
#   temp_file=$(create_temp "prefix")
#   trap "cleanup_temp $temp_file" EXIT

create_temp() {
    local prefix="${1:-temp}"
    local temp_file

    # Use mktemp with prefix
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        temp_file=$(mktemp -t "$prefix.XXXXXX")
    else
        # Linux and others
        temp_file=$(mktemp -t "$prefix.XXXXXX" 2>/dev/null) || \
        temp_file=$(mktemp --tmpdir "$prefix.XXXXXX")
    fi

    # Return the temp file path
    echo "$temp_file"
}

cleanup_temp() {
    local temp_file="$1"

    if [[ -z "$temp_file" ]]; then
        return 0
    fi

    # Safe removal with error handling
    if [[ -e "$temp_file" ]]; then
        rm -f "$temp_file" 2>/dev/null || true
    fi
}

cleanup_temp_dir() {
    local temp_dir="$1"

    if [[ -z "$temp_dir" ]]; then
        return 0
    fi

    # Safe directory removal with error handling
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir" 2>/dev/null || true
    fi
}

# Register cleanup on EXIT if ENABLE_AUTO_CLEANUP is set
if [[ "${ENABLE_AUTO_CLEANUP:-0}" == "1" ]]; then
    trap 'cleanup_temp "$TEMP_FILE"; cleanup_temp_dir "$TEMP_DIR"' EXIT
fi
