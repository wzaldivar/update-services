#!/bin/bash

# Released under the MIT License.
# You may use, modify, and distribute this script freely.
# Attribution is appreciated but not required.
# 
# (c) 2025 Walber Zaldivar (wzaldivar)

source ./services_config.sh

contains() {
  local item="$1"
  shift
  for i in "$@"; do
    [[ "$i" == "$item" ]] && return 0
  done
  return 1
}

# Initialize variables
exclude_services=("${default_exclude[@]}")
include_services=()
explicit_services=()
dry_run=false  # <-- added for dry-run
all_services=false

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      echo "Usage: $0 [OPTIONS] [SERVICE ...]"
      echo
      echo "Options:"
      echo "  --all                 Include all services, ignoring exclusions"
      echo "  --exclude SERVICE     Exclude SERVICE from update (can be used multiple times)"
      echo "  --include SERVICE     Force include SERVICE even if excluded (can be used multiple times)"
      echo "  --dry-run             Show actions without executing them"
      echo "  --help, -h            Show this help message"
      echo
      echo "Positional arguments:"
      echo "  SERVICE               One or more service directories to explicitly update"
      echo
      echo "Behavior:"
      echo "  - If no SERVICE is specified, all subdirectories are considered services."
      echo "  - Default excluded services: ${default_exclude[*]}"
      echo "  - Explicitly named SERVICE arguments override exclusions, regardless of --exclude."
      exit 0
      ;;
    --exclude)
      exclude_services+=("$2")
      shift 2
      ;;
    --include)
      include_services+=("$2")
      shift 2
      ;;
    --dry-run)  # <-- added for dry-run
      dry_run=true
      shift
      ;;
    --all)
      all_services=true
      shift
      ;;
    *)
      include_services+=("$1")
      explicit_services+=("$1")
      shift
      ;;
  esac
done

# Use all subdirectories if no explicit services given
if [ ${#explicit_services[@]} -eq 0 ]; then
  services=($(ls -d */))
else
  services=("${explicit_services[@]}")
fi

# Update each service, excluding unless overridden by --include
for service in "${services[@]}"; do
  service="${service%/}"

  if [ "$all_services" != true ] && contains "$service" "${exclude_services[@]}" && ! contains "$service" "${include_services[@]}"; then
    echo "Skipping excluded service: $service"
    continue
  fi

  if [ ! -d "$service" ]; then
    echo "Directory '$service' not found. Skipping..."
    continue
  fi

  if [ "$dry_run" = true ]; then # <-- skip
    echo "[Dry-run] Would update service: $service"
    continue
  fi

  updateService "$service"
done

if [ "$dry_run" = false ]; then  # <-- skip prune in dry-run
  docker system prune -a -f
  docker volume prune -a -f
else
  echo "[Dry-run] Would prune system and volumes"
fi
