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

SRC = ./src
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
# Shaders
SHADERCOMPILER = ./deps/bgfx/.build/osx-x64/bin/shadercRelease
SHADER_FOLDER = ./
SHADER_OUT = $(OUT)/shaders
VERT_FILES = $(call rwildcard,$(SRC),*_vert.sc)
FRAG_FILES = $(call rwildcard,$(SRC),*_frag.sc)
GEOM_FILES = $(call rwildcard,$(SRC),*_geom.sc)

SHADER_COMPILE = $(SHADERCOMPILER) \
	-f $(1) \
	-o $(SHADER_OUT)/$(basename $(notdir $(1))).bin \
	--platform osx \
	--type $(2) \
	--verbose \
	-i deps/bgfx/src

# src files
SRC_FILES = $(call rwildcard,$(SRC),*.cpp)

# build output
OUT = ./build
MKDIR_P = mkdir -p

.PHONY : deps all shaders out clean bgfx
# Output
all : main

code : 
	compiledb $(MAKE) all

out:
	$(MKDIR_P) $(OUT)
	$(MKDIR_P) $(SHADER_OUT)

# Deps libs
deps : bgfx
bgfx : 
	cd ./deps/bgfx && $(MAKE) osx

shaders: deps out
	$(foreach frag,$(GEOM_FILES),$(call SHADER_COMPILE,$(frag),geometry))
	$(foreach frag,$(VERT_FILES),$(call SHADER_COMPILE,$(frag),vertex))
	$(foreach frag,$(FRAG_FILES),$(call SHADER_COMPILE,$(frag),fragment))

main : out shaders
	$(CXX) $(SRC_FILES) -o  $(OUT)/main $(CXXFLAGS) $(LD_FLAGS) $(BGFX_HEADERS)


run :
	$(OUT)/main

clean.all: clean
	rm -rf ./deps/bgfx/.build
	rm -rf ./build
clean:
	rm -rf ./build
