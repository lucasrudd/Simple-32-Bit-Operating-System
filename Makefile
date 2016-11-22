default: build

.PHONY: clean

build/boot_header.o: multiboot_header.asm
	mkdir -p build
	nasm -f elf64 multiboot_header.asm -o build/boot_header.o

build/asmk.o: kernel.asm
	mkdir -p build
	nasm -f elf64 kernel.asm -o build/asmk.o

build/ckern.o: kernel.c
	gcc -m64 -c kernel.c -o build/ckern.o

build/kernel.bin: build/boot_header.o build/asmk.o build/ckern.o link.ld
	ld -n -o build/kernel.bin -T link.ld build/boot_header.o build/ckern.o build/asmk.o

build/os.iso: build/kernel.bin grub.cfg
		mkdir -p build/isofiles/boot/grub
		cp grub.cfg build/isofiles/boot/grub
		cp build/kernel.bin build/isofiles/boot/
		grub-mkrescue -o build/os.iso build/isofiles

run: build/os.iso
	qemu-system-x86_64 -curses -cdrom build/os.iso

build: build/os.iso

clean:
	rm -rf build
