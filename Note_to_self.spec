# NOTE: Disable debug packages for script-only RPMs to avoid
# "Empty %files file debugsourcefiles.list" error:
# Add either:
#   %define _enable_debug_package 0
# or
#   %global debug_package %{nil}
