# 🔄 Service Updater Script

A minimal Bash-based tool to update and manage Docker-based services, organized into subdirectories.

## 📦 Overview

This script allows you to:

- ✅ Update all or selected services
- ❌ Skip or ✅ force specific services
- 🔍 Perform dry-run simulations
- 🧼 Automatically prune Docker system and volumes
- 🛠️ Customize update behavior per service

## 📁 Directory Structure

Expected layout, every directory is a service:

```
services/
├── update.sh
├── services_config.sh
├── serviceA/
│ └── docker-compose.yml
├── serviceB/
│ └── docker-compose.yml
├── serviceC/
| └── docker-compose.yml
└── ...
```


## 🚀 Usage

From the root directory, run:

```
./update.sh [OPTIONS] [SERVICE ...]
```
### Options

| Option | Description |
| --- | --- |
| ```--all``` | Update all service directories, ignoring default exclusions |
| ```--exclude``` SERVICE | Exclude a service (can be used multiple times) |
| ```--include``` SERVICE | Force include a service, even if excluded (can be used multiple times) |
| ```--dry-run``` | Show what would be updated without running any commands |
| ```--help```, ```-h``` | Show usage information |


### Positional Arguments
You can also specify service names directly to update only those:

```
./update.sh serviceA serviceB
```

## ⚙️ Configuration
The script ```sources services_config.sh```, which defines:

The ```updateService()``` function — customize per-service logic here.

A ```default_exclude``` array — services to skip by default.

Example:

```
default_exclude=("grafana" "pgadmin")
```

## 🧪 Dry Run Mode
Use ```--dry-run``` to preview actions without executing them:

```
./update.sh --dry-run
```
This will show:

- ✅ Which services would be updated
- ⛔ What would be skipped
- 🧼 Which Docker resources would be pruned

## 🧼 System Cleanup
After all updates, if not in dry-run mode, the script runs:

```
docker system prune -a -f
docker volume prune -a -f
```
This helps to recover disk space.

## 🪪 License
Released under the MIT License.\
You may use, modify, and distribute this script freely.\
Attribution is appreciated but not required.

(c) 2025 Walber Zaldivar ([wzaldivar](https://github.com/wzaldivar))

Feel free to fork, extend, or adapt for your own service stack.
