#!/bin/bash
# WARNING! This file should not be executed directly.
# Shebang here is for shellcheck.
################################################################################

log::debug() {
  echo -e "$(date -u +"%Y-%m-%dT%H:%M:%SZ") \e[36m[DEBU]\e[0m $*" >&2
}

log::info() {
  echo -e "$(date -u +"%Y-%m-%dT%H:%M:%SZ") \e[34m[INFO]\e[0m $*" >&2
}

log::error() {
  echo -e "$(date -u +"%Y-%m-%dT%H:%M:%SZ") \e[31m[ERRO]\e[0m $*" >&2
}

log::command() {
  echo -e "$(date -u +"%Y-%m-%dT%H:%M:%SZ") \e[1;34m[COMM]\e[0m $*" >&2
}
