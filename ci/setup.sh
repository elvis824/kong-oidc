#!/bin/bash
set -e

export LUA_VERSION=${LUA_VERSION:-5.1}
export LUAROCKS_VERSION=${LUAROCKS_VERSION:-3.0.2}
export KONG_VERSION=${KONG_VERSION:-2.0.3-0}
export LUA_RESTY_OPENIDC_VERSION=${LUA_RESTY_OPENIDC_VERSION:-1.6.1-1}

pip install hererocks
hererocks lua_install --lua ${LUA_VERSION} --luarocks ${LUAROCKS_VERSION}
export PATH=${PATH}:${PWD}/lua_install/bin

luarocks install kong ${KONG_VERSION}
luarocks install lua-resty-openidc ${LUA_RESTY_OPENIDC_VERSION}
luarocks install lua-cjson
luarocks install luaunit
luarocks install luacov

