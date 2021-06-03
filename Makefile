BGFX_DIR = deps/bgfx

# OS & File
UNAME:=$(shell uname)
ifeq ($(UNAME),$(filter $(UNAME),Linux Darwin))
CMD_MKDIR=mkdir -p "$(1)"
CMD_RMDIR=rm -r "$(1)"
ifeq ($(UNAME),$(filter $(UNAME),Darwin))
OS=darwin
BGFX_BIN = $(BGFX_DIR)/.build/osx-x64/bin
BGFX_LIB = $(BGFX_BIN)/libbgfx-shared-libRelease.dylib 
LD_FLAGS = $(BGFX_LIB) -framework OpenGL -lglfw -stdlib=libc++
else
OS=linux
endif
else
CMD_MKDIR=cmd /C "if not exist "$(subst /,\,$(1))" mkdir "$(subst /,\,$(1))""
CMD_RMDIR=cmd /C "if exist "$(subst /,\,$(1))" rmdir /S /Q "$(subst /,\,$(1))""
OS=windows
endif

# CC specifies which compiler we're using
CC = clang
CXX = clang++
MAKE = make
CXXFLAGS = -w

OUT = ./build
ASSETS_OUT = $(OUT)/assets
SHADER_OUT = $(OUT)/shaders

# BGFX
BGFX_HEADERS =  -Ideps/bgfx/include -Ideps/bx/include -Ideps/bimg/include
# PC x86
#-stdlib=libstdc++ -ldl -lpthread -lrt

# Shaders


# src files
SRC = ./src
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

SRC_FILES = $(call rwildcard,$(SRC),*.cpp)

# build output
.PHONY : deps all shaders out clean clean.all bgfx
# Output
all : main shaders assets

code : 
	compiledb $(MAKE) main

out:
	$(call CMD_MKDIR,$(OUT))
	$(call CMD_MKDIR,$(SHADER_OUT))
	$(call CMD_MKDIR,$(ASSETS_OUT))

# Deps libs
deps : bgfx
bgfx : 
	cd $(BGFX_DIR) && $(MAKE) osx && $(MAKE) tools

shaders: deps out
	cd $(SRC)/shaders && $(MAKE) TARGET=4 #GLSL
assets: deps out
	cd ./assets && $(MAKE) all

main : deps out
	$(CXX) $(SRC_FILES) -o  $(OUT)/main $(CXXFLAGS) $(LD_FLAGS) $(BGFX_HEADERS)


run :
	$(OUT)/main

clean.all: clean
	$(call CMD_RMDIR,$(BGFX_DIR)/.build)
	$(call CMD_RMDIR,$(OUT))

clean:
	$(call CMD_RMDIR,$(OUT))
