NODE_LTS_VERSION=4.3.0
NODE_VERSION=$(NODE_LTS_VERSION)
PKGSRC=nodejs4
BUILD_DIR=build-$(NODE_VERSION)
NODE_BIN=$(BUILD_DIR)/out/Release/node-$(shell basename `readlink $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/rumpmain.js` .js)
