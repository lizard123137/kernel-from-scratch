all:
	@nasm -f bin ./src/boot.asm -o ./build/boot.bin

run:
	@qemu-system-x86_64 ./build/boot.bin

clean:
	@rm -f ./build/boot.bin