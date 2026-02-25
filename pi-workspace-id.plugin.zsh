# pi-workspace-id zsh plugin
#
# Adds this repo's bin/ to PATH and aliases:
#   pi -> piw
#   pi-raw -> command pi
#
# Set PIW_NO_ALIASES=1 before loading the plugin to disable aliases.

typeset -g PIW_PLUGIN_DIR="${${(%):-%N}:A:h}"

if (( ${path[(Ie)$PIW_PLUGIN_DIR/bin]} == 0 )); then
  path=("$PIW_PLUGIN_DIR/bin" $path)
fi

if [[ "${PIW_NO_ALIASES:-0}" != "1" ]]; then
  alias pi='piw'
  alias pi-raw='command pi'
fi
