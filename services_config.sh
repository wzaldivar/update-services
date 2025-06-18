# Released under the MIT License.
# You may use, modify, and distribute this script freely.
# Attribution is appreciated but not required.
#
# (c) 2025 Walber Zaldivar (wzaldivar)

# Update logic for each service.
updateService() {
  local service="$1"
  local current_dir
  current_dir=$(pwd)

  echo "Updating service: $service"

  cd "$service" || exit 1

  case "$service" in
    "specialService")
      # Custom update logic for this particular service
      docker compose build --no-cache
      docker compose up -d || exit 1
      ;;
    *)
      # Standard update logic
      docker compose pull
      docker compose up -d || exit 1
      ;;
  esac

  cd "$current_dir" || exit 1
}

# List of services excluded by default when not using --all
default_exclude=("criticService" "excludeService")

# To disable default exclusions, comment the line above and uncomment the following:
# default_exclude=()
