#!/bin/bash

# Walker Performance Optimization Script
# This script helps diagnose and optimize walker menu performance

echo "🔍 Walker Performance Diagnostic Tool"
echo "====================================="

# Check system resources
echo -e "\n📊 System Resources:"
echo "Memory Usage:"
free -h | grep -E "Mem|Swap"
echo -e "\nCPU Load:"
uptime
echo -e "\nCPU Info:"
lscpu | grep "Model name" | head -1

# Check walker installation
echo -e "\n🚀 Walker Installation:"
if command -v walker &> /dev/null; then
    echo "Walker version: $(walker --version 2>/dev/null || echo 'Unknown')"
    echo "Walker location: $(which walker)"
else
    echo "❌ Walker not found in PATH"
    exit 1
fi

# Check walker config
echo -e "\n⚙️  Walker Configuration:"
CONFIG_FILE="$HOME/.config/walker/config.toml"
if [ -f "$CONFIG_FILE" ]; then
    echo "Config file: $CONFIG_FILE"
    echo "Config size: $(du -h "$CONFIG_FILE" | cut -f1)"
    
    # Count enabled modules
    ENABLED_MODULES=$(grep -c "^\[builtins\." "$CONFIG_FILE")
    HIDDEN_MODULES=$(grep -c "hidden = true" "$CONFIG_FILE")
    TOTAL_MODULES=$(grep -c "^\[builtins\." "$CONFIG_FILE")
    
    echo "Total builtin modules: $TOTAL_MODULES"
    echo "Hidden modules: $HIDDEN_MODULES"
    echo "Visible modules: $((TOTAL_MODULES - HIDDEN_MODULES))"
    
    # Check for performance-critical settings
    echo -e "\n🔧 Performance Settings:"
    if grep -q "refresh = true" "$CONFIG_FILE"; then
        echo "⚠️  Found modules with refresh=true (performance impact)"
        grep -B2 "refresh = true" "$CONFIG_FILE" | grep "\[builtins\." | sed 's/\[builtins\.//' | sed 's/\]//'
    fi
    
    if grep -q "eager_loading = true" "$CONFIG_FILE"; then
        echo "⚠️  Found modules with eager_loading=true (startup impact)"
        grep -B2 "eager_loading = true" "$CONFIG_FILE" | grep "\[builtins\." | sed 's/\[builtins\.//' | sed 's/\]//'
    fi
    
    if grep -q "concurrency = [8-9]" "$CONFIG_FILE"; then
        echo "⚠️  Found high concurrency settings"
        grep -B2 "concurrency = [8-9]" "$CONFIG_FILE" | grep "\[builtins\." | sed 's/\[builtins\.//' | sed 's/\]//'
    fi
else
    echo "❌ Walker config file not found"
fi

# Check for potential conflicts
echo -e "\n🔍 Potential Conflicts:"
if pgrep -x "waybar" > /dev/null; then
    echo "✅ Waybar is running"
else
    echo "⚠️  Waybar not running (may affect Hyprland integration)"
fi

if pgrep -x "hyprland" > /dev/null; then
    echo "✅ Hyprland is running"
else
    echo "⚠️  Hyprland not running"
fi

# Performance recommendations
echo -e "\n💡 Performance Recommendations:"
echo "1. Keep only frequently used modules visible (hidden=false)"
echo "2. Set refresh=false for modules that don't need real-time updates"
echo "3. Set eager_loading=false for faster startup"
echo "4. Reduce concurrency for file operations"
echo "5. Use fd instead of find for file searching"
echo "6. Limit max_entries to 20-30 for better responsiveness"

# Quick performance test
echo -e "\n⚡ Quick Performance Test:"
echo "Testing walker startup time..."
START_TIME=$(date +%s.%N)
timeout 5s walker --help > /dev/null 2>&1
END_TIME=$(date +%s.%N)
STARTUP_TIME=$(echo "$END_TIME - $START_TIME" | bc -l 2>/dev/null || echo "unknown")
echo "Startup time: ${STARTUP_TIME}s"

echo -e "\n✅ Diagnostic complete!"
echo "For optimal performance, consider the optimizations above." 