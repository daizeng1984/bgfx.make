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
	-o $(1).bin \
	--platform osx \
	--type $(2) \
	--verbose \
	-i deps/bgfx/src

# build output
OUT = ./build
MKDIR_P = mkdir -p

.PHONY : deps all shaders out
# Output
out:
	$(MKDIR_P) $(OUT)
	$(MKDIR_P) $(SHADER_OUT)

# Deps libs
deps : bgfx
bgfx : 
	cd ./deps/bgfx && $(MAKE) osx

shaders:
	$(call SHADER_COMPILE,v_simple,vertex)
	$(call SHADER_COMPILE,f_simple,fragment)

helloworld : main.cpp out deps shaders
	$(CXX) main.cpp -o  $(OUT)/main $(CXXFLAGS) $(LD_FLAGS) $(BGFX_HEADERS)

all : helloworld

run : all
	DYLD_LIBRARY_PATH=$(BGFX_BIN) ./main

code : 
	compiledb $(MAKE) all
