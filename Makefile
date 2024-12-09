kernel := build/kernel.bin
iso := build/os.iso

linker_script := src/linker.ld
grub_cfg := src/grub.cfg

asm_source_files := $(wildcard src/*.asm)
asm_object_files := $(patsubst src/%.asm, build/%.o, $(asm_source_files))

.PHONY: all	clean run iso

all: $(kernel)

clean:
	rm -r build

run: $(iso)
	qemu-system-x86_64 $(iso)

iso: $(iso)

$(iso): $(kernel) $(grub_cfg)
	mkdir -p build/isofiles/boot/grub
	cp $(kernel) build/isofiles/boot/kernel.bin
	cp $(grub_cfg) build/isofiles/boot/grub
	grub2-mkrescue -o $(iso) build/isofiles 2> /dev/null
	rm -r build/isofiles

$(kernel): $(asm_object_files) $(linker_script)
	ld -n -T $(linker_script) -o $(kernel) $(asm_object_files)

build/%.o: src/%.asm
	mkdir -p $(shell dirname $@)
	nasm -felf64 $< -o $@