#!/usr/bin/env bash
# A simple tool helping to experiment with macOS system preferences .

defaults read > before
read -r -p "Change setting(s) and press any key..."
defaults read > after

diff --unified=5 before after

rm before after
