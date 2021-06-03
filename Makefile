# CC specifies which compiler we're using
CC = clang
CXX = clang++
MAKE = make
CXXFLAGS = -w

# BGFX
BGFX_HEADERS =  -Ideps/bgfx/include -Ideps/bx/include -Ideps/bimg/include
BGFX_BIN = deps/bgfx/.build/osx-x64/bin
BGFX_LIB = $(BGFX_BIN)/libbgfx-shared-libRelease.dylib 
LD_FLAGS = $(BGFX_LIB) -framework OpenGL -lglfw -stdlib=libc++
#-stdlib=libstdc++ -ldl -lpthread -lrt

# Shaders
SHADERCOMPILER = ./deps/bgfx/.build/osx-x64/bin/shadercRelease
SHADER_OUT = $(OUT)/shaders
SHADER_COMPILE = $(SHADERCOMPILER) \
	-f $(1).sc \
	-o $(SHADER_OUT)/$(1).bin \
	--platform osx \
	--type $(2) \
	--verbose \
	-i deps/bgfx/src

# src files
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
SRC_FILES = $(call rwildcard,./src/misc,*.cpp)

# build output
OUT = ./build
MKDIR_P = mkdir -p
SRC = ./src

.PHONY : deps all shaders out clean bgfx
# Output
out:
	$(MKDIR_P) $(OUT)
	$(MKDIR_P) $(SHADER_OUT)

# Deps libs
deps : bgfx
bgfx : 
	cd ./deps/bgfx && $(MAKE) osx

shaders: deps
	$(call SHADER_COMPILE,v_simple,vertex)
	$(call SHADER_COMPILE,f_simple,fragment)

main : $(SRC)/main.cpp out shaders
	$(CXX) $(SRC)/main.cpp $(SRC_FILES) -o  $(OUT)/main $(CXXFLAGS) $(LD_FLAGS) $(BGFX_HEADERS)

all : main

run :
	$(OUT)/main

code : 
	compiledb $(MAKE) all

clean: 
	rm -rf ./deps/bgfx/.build
	rm -rf ./build
