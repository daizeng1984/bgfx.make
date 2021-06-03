OUT=./../build/assets

# OS & File
UNAME:=$(shell uname)
ifeq ($(UNAME),$(filter $(UNAME),Linux Darwin))
ifeq ($(UNAME),$(filter $(UNAME),Darwin))
OS=darwin
else
OS=linux
endif
else
OS=windows
endif
TOOLS = $(PWD)/../deps/bgfx/tools/bin/$(OS)

geometryc=$(TOOLS)/geometryc -f $(1) -o $(2)

geometryc_pack_normal=$(TOOLS)/geometryc -f $(1) -o $(2) --packnormal 1

geometryc_pack_normal_compressed=$(TOOLS)/geometryc -f $(1) -o $(2) --packnormal 1 -c

geometryc_pack_normal_barycentric=$(TOOLS)/geometryc -f $(1) -o $(2) --packnormal 1 --barycentric

texturec_bc1=$(TOOLS)/texturec -f $(1) -o $(2) -t bc1 -m

texturec_bc2=$(TOOLS)/texturec -f $(1) -o $(2) -t bc2 -m

texturec_bc3=$(TOOLS)/texturec -f $(1) -o $(2) -t bc3 -m

texturec_bc4=$(TOOLS)/texturec -f $(1) -o $(2) -t bc4 -m

texturec_bc5=$(TOOLS)/texturec -f $(1) -o $(2) -t bc5 -m

texturec_bc7=$(TOOLS)/texturec -f $(1) -o $(2) -t bc7 -m

texturec_etc1=$(TOOLS)/texturec -f $(1) -o $(2) -t etc1 -m

texturec_etc2=$(TOOLS)/texturec -f $(1) -o $(2) -t etc2 -m

texturec_diffuse=$(TOOLS)/texturec -f $(1) -o $(2) -t bc2 -m

texturec_normal=$(TOOLS)/texturec -f $(1) -o $(2) -t bc5 -m -n

texturec_height=$(TOOLS)/texturec -f $(1) -o $(2) -t r8

texturec_equirect=$(TOOLS)/texturec -f $(1) -o $(2) --max 512 -t rgba16f --equirect

ASSETS = .
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

OBJ = $(call rwildcard,$(ASSETS),*.obj)
PNG = $(call rwildcard,$(ASSETS),*.png)

all:
	$(foreach obj,$(OBJ),$(call geometryc,$(obj),$(OUT)/$(basename $(obj)).bin );)

