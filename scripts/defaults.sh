#!/usr/bin/env bash
# This file contains automated macOS system preferences configuration.
# TODO: make it conditional, and execute `killal {Dock/Finder}` only if there
# were changes.

#
# System Preferences
#

# System Preferences > General

# Ask to keep changes when closing documents
defaults write -globalDomain NSCloseAlwaysConfirmsChanges -int 1

# Prefer tabs when opening documents: Always
defaults write -globalDomain AppleWindowTabbingMode -string always

## System Preferences > Dock & Menu Bar

# Size
defaults write com.apple.dock tilesize -int 54

# Magnification
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 65

# Minimise windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 1
defaults write com.apple.dock autohide-delay -float 0

# Show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

## System Preferences > Mission Control

# Automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

## System Preferences > Keyboard | Keyboard

# Use F1, F2, etc. keys as standard function keys
defaults write -globalDomain com.apple.keyboard.fnState -int 1

## System Preferences > Trackpad | Point & Click

# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1

# Force click
defaults write -globalDomain com.apple.trackpad.forceClick -int 1

# ## System Preferences > Trackpad | More Gestures

# App Expose
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

#
# Finder
#

## Finder > Preferences | General

# New Finder windows show
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder NewWindowTargetPath -string "file:///$HOME/"

## Finder > Preferences | Advanced

# Show all filename extensions
defaults write -globalDomain AppleShowAllExtensions -bool true

# #
# # Apply changes immediately
# #

killall Dock
killall Finder
