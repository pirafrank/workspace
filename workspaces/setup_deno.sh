#!/usr/bin/env bash

# headless install of the latest available version of Deno

echo "About to install latest Deno version"

# download and install using their script.
# script updates install if one is found.
curl -fsSL https://deno.land/x/install/install.sh | sh

# print installed Deno version
$HOME/.deno/bin/deno --version
