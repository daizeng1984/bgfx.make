# CC specifies which compiler we're using
CC = clang
CXX = clang++
MAKE = make

# COMPILER_FLAGS specifies the additional compilation options we're using
# -w suppresses all warnings
COMPILER_FLAGS = -w

BGFX_HEADERS =  -Ibgfx/include -Ibx/include -Ibimg/include

BGFX_BIN = bgfx/.build/osx-x64/bin
#LINKER_FLAGS specifies the libraries we're linking against
#LINKER_FLAGS = bgfx/.build/linux64_gcc/bin/libbgfx-shared-libRelease.so -lSDL2 -lGL -lX11 -ldl -lpthread -lrt
LINKER_FLAGS = $(BGFX_BIN)/libbgfx-shared-libRelease.dylib -framework OpenGL -lglfw -stdlib=libc++
#-stdlib=libstdc++ -ldl -lpthread -lrt

SHADERCOMPILER = ./bgfx/.build/osx-x64/bin/shadercRelease

#This is the target that compiles our executable
deps : bgfx
	cd ./bgfx && $(MAKE) osx
all : main.cpp deps
	$(SHADERCOMPILER) \
	-f v_simple.sc \
	-o v_simple.bin \
	--platform linux \
	--type vertex \
	--verbose \
	-i bgfx/src
	$(SHADERCOMPILER) \
	-f f_simple.sc \
	-o f_simple.bin \
	--platform linux \
	--type fragment \
	--verbose \
	-i bgfx/src
	$(CXX) main.cpp -o  main $(COMPILER_FLAGS) $(LINKER_FLAGS) $(BGFX_HEADERS)
run : all
	DYLD_LIBRARY_PATH=$(BGFX_BIN) ./main

code : 
	compiledb $(MAKE) all
