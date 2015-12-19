# Author : Karthikeyan Natarajan

SDK_BASE ?= C:\Espressif\ESP8266_SDK
XTENSA_BINDIR ?= C:\Espressif\xtensa-lx106-elf\bin
SDK_BASE := $(subst \,/,$(addprefix /,$(subst :,,$(SDK_BASE))))
XTENSA_BINDIR := $(subst \,/,$(addprefix /,$(subst :,,$(XTENSA_BINDIR))))
SPI_SIZE ?= 512K
PORT ?= COM7


FLAGS = SDK_BASE=$(SDK_BASE) XTENSA_BINDIR=$(XTENSA_BINDIR) SPI_SIZE=$(SPI_SIZE) PORT=$(PORT)
all:
	@echo "Making esptool2"
	@$(MAKE) -C esptool2 $(FLAGS)
	@echo "Making rboot"
	@$(MAKE) -C rboot       $(FLAGS)
	@echo "Making rboot-sample"
	@$(MAKE) -C rboot-sample $(FLAGS)
	
clean:
	@$(MAKE) clean -C esptool2
	@$(MAKE) clean -C rboot
	@$(MAKE) clean -C rboot-sample
	@echo "Clean complete"
	
check: esptool2/esptool2.exe rboot/firmware/rboot.bin  rboot-sample/firmware/rom0.bin rboot-sample/firmware/rom1.bin
	@echo "All files are present"