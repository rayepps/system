#
#   .bashrc is run every time a new instance of
#   bash is created. Example: cmd+t creates a new tab
#   when bash is already open. In the new windows scope,
#   the .bashrc will be run.
#


pip_global() {
  PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

load_auto_env
